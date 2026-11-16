--[[
  Astertrail - data（クエスト資料）
  ゲーム中は読むだけ。ファイルを読む手段は外（platform）から渡してもらう。
]]

local json = require('src.lib.json')
local util = require('src.lib.util')

local SUPPORTED_DATA_SCHEMA = 1

local data = {}
data.__index = data

-- fs: { read = function(path) -> text or nil, why }
-- base: data フォルダ（末尾に区切りを含む）
function data.load(fs, base)
    local self = setmetatable({
        base = base,
        manifest = nil,
        version = nil,
        quests = {},        -- 資料の順
        by_id = {},
        steps = {},         -- step id -> step
        step_quest = {},    -- step id -> quest
        draft_steps = {},   -- 古い手順（下書き）の id -> 新しい手順 id の一覧（guides/step_map.json。進み具合の引き継ぎ用）
        step_alias = {},    -- 古い手順（下書き）の id -> 新しい手順 id（最初に当たるもの）
        _guide_docs = {},
        targets = {},
        zones = {},
        guards = {},
        categories = {},
        map_floors = {},
        map_unconfirmed = {},
        errors = {},        -- 読めなかった区分など（画面に出す）
        warnings = {},      -- データ検査の気付き
    }, data)

    local text, why = fs.read(base .. 'manifest.json')
    if not text then
        self.errors[#self.errors + 1] = { file = 'manifest.json', why = why or 'not found' }
        return self
    end
    local man, err = json.decode(text)
    if not man then
        self.errors[#self.errors + 1] = { file = 'manifest.json', why = err }
        return self
    end
    self.manifest = man
    self.version = man.data_version
    for _, c in ipairs(man.categories or {}) do
        self.categories[#self.categories + 1] = c
    end

    for _, rel in ipairs(man.files or {}) do
        local path = base .. rel:gsub('/', fs.sep or '\\')
        local t, w = fs.read(path)
        local doc, e
        if t then doc, e = json.decode(t) else e = w or 'not found' end
        if not doc then
            self.errors[#self.errors + 1] = { file = rel, why = e }
        elseif doc.data_schema ~= SUPPORTED_DATA_SCHEMA then
            self.errors[#self.errors + 1] = { file = rel, why = 'data_schema ' .. tostring(doc.data_schema) .. ' には対応していません' }
        else
            self:_absorb(rel, doc)
        end
    end
    self:_apply_guides()
    self:_load_game_refs(fs, base)
    self:_load_item_refs(fs, base)
    self:_load_exits(fs, base)
    self:_load_step_mobs(fs, base)
    self:_check()
    return self
end

-- となりのエリアへの出口（0.1.171〜、t227-map。dev/build_exits.py が作る）。無くても動く（出口を出さないだけ）。
function data:_load_exits(fs, base)
    local exits = require('src.core.exits')
    local t = fs.read(base .. 'exits.json')
    local doc = t and json.decode(t) or nil
    if t and type(doc) ~= 'table' then
        self.warnings[#self.warnings + 1] = 'exits.json: 読めません'
    end
    exits.bind(self, doc)
end

-- 手順の文に書いてある、落とすモンスターと種族（0.1.190〜、t321・t322。dev/build_step_mobs.py が作る）。
-- 無くても動く（印を出さないだけ）。名前は本物のモンスターの名前だけ、種族の名前はゾーンごと。
function data.mob_key(name)
    if type(name) ~= 'string' then return nil end
    local z = name:find('\0', 1, true)
    if z then name = name:sub(1, z - 1) end
    name = name:gsub("['’]", ''):gsub('^%s+', ''):gsub('%s+$', '')
    if name == '' then return nil end
    return name:lower()
end

function data:_load_step_mobs(fs, base)
    self.step_mob_list = {}
    self.mob_families = {}
    local t = fs.read(base .. 'step_mobs.json')
    if not t then return end
    local doc = json.decode(t)
    if type(doc) ~= 'table' or type(doc.steps) ~= 'table' then
        self.warnings[#self.warnings + 1] = 'step_mobs.json: 読めません'
        return
    end
    for sid, e in pairs(doc.steps) do
        if self.steps[sid] and type(e) == 'table' then self.step_mob_list[sid] = e end
    end
    for fam, zones in pairs(type(doc.families) == 'table' and doc.families or {}) do
        local per = {}
        if type(zones) == 'table' then
            for z, names in pairs(zones) do
                local set = {}
                for _, n in ipairs(type(names) == 'table' and names or {}) do
                    local k = data.mob_key(n)
                    if k then set[k] = true end
                end
                if tonumber(z) then per[tonumber(z)] = set end
            end
        end
        self.mob_families[fam] = per
    end
end

-- その手順の、落とすモンスター（names）と種族（families）と、外す名前（exclude）
function data:step_mobs(sid)
    return sid and self.step_mob_list and self.step_mob_list[sid] or nil
end

-- そのゾーンのその名前が、その種族か（分からなければ false）
function data:mob_in_family(fam, zone_id, name)
    local per = self.mob_families and self.mob_families[fam]
    local set = per and per[tonumber(zone_id) or -1]
    local k = data.mob_key(name)
    return (set ~= nil and k ~= nil and set[k] == true) or false
end

-- 必要な品の名前 → ゲームの品の番号（0.1.184〜、t297。dev/build_item_refs.py が作る）。
-- 無くても動く（所持が「未確認」のままなだけ）。資料に番号があればそちらを使う。
function data:_load_item_refs(fs, base)
    self.item_ref_count = 0
    local t = fs.read(base .. 'item_refs.json')
    if not t then return end
    local doc = json.decode(t)
    if type(doc) ~= 'table' or type(doc.items) ~= 'table' or type(doc.key_items) ~= 'table' then
        self.warnings[#self.warnings + 1] = 'item_refs.json: 読めません'
        return
    end
    local n = 0
    for _, q in pairs(self.by_id) do
        for _, s in ipairs(q.steps or {}) do
            for _, nd in ipairs(s.needs or {}) do
                if type(nd) == 'table' and type(nd.name_ja) == 'string' then
                    if nd.kind == 'key_item' then
                        local id = tonumber(doc.key_items[nd.name_ja])
                        if nd.key_item_id == nil and id then nd.key_item_id = id; n = n + 1 end
                    elseif nd.item_id == nil then
                        local id = tonumber(doc.items[nd.name_ja])
                        if id then nd.item_id = id; n = n + 1 end
                    end
                end
            end
        end
    end
    self.item_ref_count = n
end

-- ゲームの番号との対応（0.1.169〜、t223。dev/build_game_refs.py が作る）。無くても動く（自動で読まないだけ）。
function data:_load_game_refs(fs, base)
    self.game_refs = {}
    self.game_mission_info = {}
    local t = fs.read(base .. 'game_refs.json')
    if not t then return end
    local doc = json.decode(t)
    if type(doc) ~= 'table' or type(doc.refs) ~= 'table' then
        self.warnings[#self.warnings + 1] = 'game_refs.json: 読めません'
        return
    end
    local n = 0
    for qid, r in pairs(doc.refs) do
        if self.by_id[qid] and type(r) == 'table' and (r[1] == 'q' or r[1] == 'm') then
            self.game_refs[qid] = r
            n = n + 1
        end
    end
    local ordered = {}
    for _, log in ipairs(doc.mission_ordered or {}) do ordered[tonumber(log)] = true end
    for log, list in pairs(doc.mission_ids or {}) do
        local l = tonumber(log)
        if l and type(list) == 'table' then
            self.game_mission_info[l] = { ids = list, ordered = ordered[l] == true }
        end
    end
    self.game_ref_count = n
end

function data:game_ref(qid)
    return self.game_refs and self.game_refs[qid] or nil
end

-- 書き直した手順（guides）を当てる。手順は新しいほうだけを使う（0.1.54 から）。
-- 古い下書きは表示に使わない。書き直しの無いクエストは手順なし（気付きに出す）。
function data:_apply_guides()
    for _, doc in ipairs(self._guide_docs) do
        for _, g in ipairs(doc.guides or {}) do
            local q = g.quest and self.by_id[g.quest]
            if not q then
                self.warnings[#self.warnings + 1] = 'guides: クエストがありません ' .. tostring(g.quest)
            elseif type(g.steps) ~= 'table' or #g.steps == 0 then
                self.warnings[#self.warnings + 1] = 'guides: 手順がありません ' .. tostring(g.quest)
            elseif not q.guide then
                local steps = {}
                for _, s in ipairs(g.steps) do
                    if type(s.id) == 'string' then
                        s.needs = s.needs or {}
                        s.next = s.next or {}
                        s.migrated_from = s.migrated_from or {}
                        steps[#steps + 1] = s
                    end
                end
                table.sort(steps, function (a, b) return (a.order or 0) < (b.order or 0) end)
                for _, s in ipairs(q.steps) do
                    if s.id then
                        self.steps[s.id] = nil
                        self.step_quest[s.id] = nil
                    end
                end
                q.steps = steps
                q.guide = { version = doc.guide_version, source = g.source }
                q._search = nil
                for _, s in ipairs(steps) do
                    self.steps[s.id] = s
                    self.step_quest[s.id] = q
                    for _, old in ipairs(s.migrated_from) do
                        if not self.step_alias[old] then self.step_alias[old] = s.id end
                        if not self.draft_steps[old] then self.draft_steps[old] = { s.id } end
                    end
                end
            end
        end
    end
    self._guide_docs = {}
    -- 下書きへの代替表示はしない
    for _, q in ipairs(self.quests) do
        if not q.guide then
            for _, s in ipairs(q.steps) do
                if s.id then
                    self.steps[s.id] = nil
                    self.step_quest[s.id] = nil
                end
            end
            if #q.steps > 0 then
                self.warnings[#self.warnings + 1] = 'guides: 書き直した手順がありません ' .. q.id
            end
            q.steps = {}
        end
    end
end

-- 古い手順（下書き）の id だったか（書き直しで置き換えたもの）
function data:is_draft_step(id)
    return id ~= nil and self.draft_steps[id] ~= nil
end

function data:_absorb(rel, doc)
    -- 地図の対応表（クエストとは別ファイル）
    if doc.data_kind == 'maps' or doc.floors or doc.unconfirmed_zones then
        self.map_floors = doc.floors or {}
        self.map_unconfirmed = doc.unconfirmed_zones or {}
        self.map_meta = {
            client_version = doc.client_version,
            dumped_at = doc.dumped_at,
            rule_ja = doc.rule_ja,
            source = doc.source,
        }
        require('src.core.maps').bind(self)
    end
    if doc.data_kind == 'guides' or doc.guides then
        self._guide_docs[#self._guide_docs + 1] = doc
    end
    -- 古い手順 id -> 新しい手順 id の対応表（文は持たない）
    if doc.data_kind == 'step_map' and type(doc.map) == 'table' then
        for old, news in pairs(doc.map) do
            if type(news) == 'table' and #news > 0 then
                self.draft_steps[old] = news
                self.step_alias[old] = news[1]
            end
        end
    end
    for _, z in ipairs(doc.zones or {}) do
        if z.zone_id then self.zones[z.zone_id] = z end
    end
    for _, g in ipairs(doc.guards or {}) do
        self.guards[#self.guards + 1] = g
    end
    for _, t in ipairs(doc.targets or {}) do
        if t.id then self.targets[t.id] = t end
    end
    for _, q in ipairs(doc.quests or {}) do
        if type(q.id) ~= 'string' then
            self.warnings[#self.warnings + 1] = rel .. ': id のないクエスト'
        elseif self.by_id[q.id] then
            self.warnings[#self.warnings + 1] = rel .. ': id が重複 ' .. q.id
        elseif not q.retired then
            q._file = rel
            q.steps = q.steps or {}
            table.sort(q.steps, function (a, b) return (a.order or 0) < (b.order or 0) end)
            for _, s in ipairs(q.steps) do
                if s.id then
                    self.steps[s.id] = s
                    self.step_quest[s.id] = q
                end
                s.needs = s.needs or {}
                s.next = s.next or {}
            end
            self.quests[#self.quests + 1] = q
            self.by_id[q.id] = q
        end
    end
end

-- 形と整合性の簡単な検査（推測で直さず、気付きとして残す）
function data:_check()
    for _, q in ipairs(self.quests) do
        for _, s in ipairs(q.steps) do
            for _, n in ipairs(s.next) do
                if not self.steps[n] then
                    self.warnings[#self.warnings + 1] = s.id .. ': 次の手順 ' .. tostring(n) .. ' がありません'
                end
            end
            if s.target and not self.targets[s.target] then
                self.warnings[#self.warnings + 1] = s.id .. ': 対象 ' .. tostring(s.target) .. ' がありません'
            end
        end
    end
end

function data:quest(id) return self.by_id[id] end
function data:step(id) return self.steps[id] end
function data:quest_of_step(id) return self.step_quest[id] end
function data:target(id) return id and self.targets[id] or nil end

function data:category_label(cat, lang)
    for _, c in ipairs(self.categories) do
        if c.id == cat then
            if lang == 'en' then return c.label_en or c.label_ja or cat end
            return c.label_ja or cat
        end
    end
    return cat or ''
end

function data:list(kind)
    local out = {}
    for _, q in ipairs(self.quests) do
        if kind == nil or q.kind == kind then out[#out + 1] = q end
    end
    return out
end

function data:first_step(q)
    return q and q.steps[1] or nil
end

function data:is_last_step(step)
    return step ~= nil and (#(step.next or {}) == 0)
end

function data:zone_name(zone_id)
    local z = zone_id and self.zones[zone_id]
    return z and z.zone_name or nil
end

-- 開始地点のゾーン（開始NPCの場所から）
function data:start_target(q)
    return q and q.start and self:target(q.start.target) or nil
end

function data:start_location(q)
    local tg = self:start_target(q)
    return tg and tg.location or nil
end

function data:start_zone(q)
    local loc = self:start_location(q)
    return loc and loc.zone_id or nil
end

function data:start_npc_name(q)
    local tg = self:start_target(q)
    return tg and tg.name_en or nil
end

-- 見出し用の場所（ゾーンと座標。MAP未確認は出さない）
function data:start_place_text(q)
    local loc = self:start_location(q)
    if not loc then return nil end
    local zone = loc.zone_name or self:zone_name(loc.zone_id)
    if not zone or zone == '' then return nil end
    if loc.grid and loc.grid ~= '' then
        return zone .. ' (' .. loc.grid .. ')'
    end
    return zone
end

-- 場所の表示「ゾーン MAP[n] (H-3)」。i18n の t を受け取る。
function data:location_text(step_or_loc, t)
    local loc = step_or_loc and (step_or_loc.location or (step_or_loc.zone_id and step_or_loc))
    if not loc then
        if step_or_loc and step_or_loc.location_note_ja then return step_or_loc.location_note_ja end
        return t('loc.unknown')
    end
    local zone = loc.zone_name or self:zone_name(loc.zone_id) or t('loc.zone_unknown')
    local map = loc.map or {}
    local parts = { zone }
    if map.kind == 'number' and map.n then
        parts[#parts + 1] = 'MAP[' .. tostring(map.n) .. ']'
    elseif map.kind == 'single' then
        -- 1枚だけの地図は番号を付けない
    else
        parts[#parts + 1] = t('loc.map_unknown')
    end
    if loc.grid and loc.grid ~= '' then
        parts[#parts + 1] = '(' .. loc.grid .. ')'
    end
    return table.concat(parts, ' ')
end

function data:target_name(id)
    local tg = self:target(id)
    return tg and tg.name_en or nil
end

-- 検索用の文字列（英語名・資料の日本語名・エリア名・NPC名）
function data:search_text(q)
    if q._search then return q._search end
    local parts = { q.name_en or '', q.name_ja_ref or '', q.mission_no or '' }
    local seen = {}
    local function add(s) if s and not seen[s] then seen[s] = true; parts[#parts + 1] = s end end
    local st = q.start and self:target(q.start.target)
    if st then
        add(st.name_en)
        add(st.location and (st.location.zone_name or self:zone_name(st.location.zone_id)))
    end
    for _, s in ipairs(q.steps) do
        if s.location then add(s.location.zone_name or self:zone_name(s.location.zone_id)) end
        add(self:target_name(s.target))
    end
    q._search = util.lower(table.concat(parts, '\n'))
    return q._search
end

function data:has_needs(q)
    for _, s in ipairs(q.steps) do
        if #s.needs > 0 then return true end
    end
    return false
end

return data
