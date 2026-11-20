--[[
  Astertrail - data（クエスト資料）
  ゲーム中は読むだけ。ファイルを読む手段は外（platform）から渡してもらう。
]]

local json = require('src.lib.json')
local util = require('src.lib.util')
local gil = require('src.core.gil')

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
    self:_fill_listed_talk_targets()
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
                        if id and not gil.should_skip_item_lookup(nd.name_ja, id) then
                            nd.item_id = id; n = n + 1
                        end
                    end
                end
            end
        end
    end
    self.item_ref_count = n
    self.item_name_id = doc.items
    self.key_name_id = doc.key_items
    self.item_name_ids = {}
    self.key_name_ids = {}
    self:_merge_item_refs_extra(fs, base)
    self:_apply_item_ref_ids()
end

local function _copy_ids(src)
    local out = {}
    if type(src) ~= 'table' then return out end
    for _, v in ipairs(src) do
        local id = tonumber(v)
        if id then out[#out + 1] = id end
    end
    return out
end

-- 手で足した番号（data/item_refs_extra.json。同じ公式名の複数番号は合算）
function data:_merge_item_refs_extra(fs, base)
    local t = fs.read(base .. 'item_refs_extra.json')
    if not t then return end
    local extra = json.decode(t)
    if type(extra) ~= 'table' then return end
    self.item_name_id = self.item_name_id or {}
    self.key_name_id = self.key_name_id or {}
    for name, id in pairs(type(extra.items) == 'table' and extra.items or {}) do
        if type(name) == 'string' and tonumber(id) then
            -- items に一本化したら、以前の items_any は使わない（0.1.281〜 堀ブナなど）
            self.item_name_id[name] = tonumber(id)
            if self.item_name_ids then self.item_name_ids[name] = nil end
        end
    end
    for name, id in pairs(type(extra.key_items) == 'table' and extra.key_items or {}) do
        if type(name) == 'string' and tonumber(id) then
            self.key_name_id[name] = tonumber(id)
            if self.key_name_ids then self.key_name_ids[name] = nil end
        end
    end
    for name, ids in pairs(type(extra.items_any) == 'table' and extra.items_any or {}) do
        local list = _copy_ids(ids)
        if type(name) == 'string' and #list > 0 then self.item_name_ids[name] = list end
    end
    for name, ids in pairs(type(extra.key_items_any) == 'table' and extra.key_items_any or {}) do
        local list = _copy_ids(ids)
        if type(name) == 'string' and #list > 0 then self.key_name_ids[name] = list end
    end
end

-- 資料の needs に、名前表（本体＋手入力）の番号を足す
function data:_apply_item_ref_ids()
    local n = self.item_ref_count or 0
    for _, q in pairs(self.by_id or {}) do
        for _, s in ipairs(q.steps or {}) do
            for _, nd in ipairs(s.needs or {}) do
                if type(nd) == 'table' then
                    local name = nd.name_ja or nd.name_en
                    local ref = name and self:lookup_item_name(name)
                    if ref then
                        if ref.kind == 'key_item' then
                            nd.kind = 'key_item'
                            if nd.key_item_id == nil then nd.key_item_id = ref.key_item_id; n = n + 1 end
                            if ref.key_item_ids then nd.key_item_ids = ref.key_item_ids end
                        else
                            if nd.item_id == nil then nd.item_id = ref.item_id; n = n + 1 end
                            if ref.item_ids then nd.item_ids = ref.item_ids end
                        end
                    end
                end
            end
        end
    end
    self.item_ref_count = n
end

-- 名前から品／だいじなものの番号を返す（資料の needs に無いとき、表示側の照合用）
function data:lookup_item_name(name)
    if type(name) ~= 'string' or name == '' then return nil end
    if gil.should_skip_item_lookup(name) then return nil end
    local kids = self.key_name_ids and self.key_name_ids[name]
    if kids and #kids > 0 then
        return { kind = 'key_item', key_item_id = kids[1], key_item_ids = kids, name_ja = name }
    end
    local kid = self.key_name_id and tonumber(self.key_name_id[name])
    if kid then return { kind = 'key_item', key_item_id = kid, name_ja = name } end
    local iids = self.item_name_ids and self.item_name_ids[name]
    if iids and #iids > 0 then
        return { kind = 'item', item_id = iids[1], item_ids = iids, name_ja = name, count = 1 }
    end
    local iid = self.item_name_id and tonumber(self.item_name_id[name])
    if iid then return { kind = 'item', item_id = iid, name_ja = name, count = 1 } end
    return nil
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
            for _, x in ipairs(type(s.extra_targets) == 'table' and s.extra_targets or {}) do
                if not self.targets[x] then
                    self.warnings[#self.warnings + 1] = s.id .. ': 対象 ' .. tostring(x) .. ' がありません'
                end
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

---------------------------------------------------------------------------
-- 手順の文に並んだ複数の話し相手（0.1.228〜）
-- 例：山猫の誘惑 手順2「Kaede(J-5)・Paujean(F-6)・…」
-- 既存の NPC データと、LSB 由来の正確な座標があるものだけ使う。分からないものは出さない。
---------------------------------------------------------------------------

local function target_has_pos(t)
    local loc = t and t.location
    local pos = loc and loc.pos
    return loc and loc.zone_id and pos and pos.x ~= nil and pos.y ~= nil
end

local function target_en_name(t)
    if not t then return nil end
    if type(t.name_en) == 'string' and t.name_en ~= '' then return t.name_en end
    local id = tostring(t.id or '')
    local last = id:match('%.([^%.]+)$') or id
    if last == '' then return nil end
    return (last:gsub('_', ' '))
end

-- マスの直前にある英語名（Kaede、Patient Wheel、Three of Clubs）。Lua のパターンに非キャプチャは使えない。
local function trailing_english_name(pre)
    if type(pre) ~= 'string' then return nil end
    local s = pre:gsub('%s+$', '')
    local words = {}
    while s ~= '' do
        local rest, word = s:match("^(.-)%s+([A-Za-z'%.%-]+)$")
        if not word then
            word = s:match("([A-Za-z'%.%-]+)$")
            rest = word and s:sub(1, #s - #word) or nil
            if rest then rest = rest:gsub('%s+$', '') end
        end
        if not word then break end
        table.insert(words, 1, word)
        s = rest or ''
        if s == '' or not s:match("[A-Za-z'%.%-]$") then break end
    end
    while #words > 0 and not words[1]:match('^[A-Z]') do
        table.remove(words, 1)
    end
    if #words == 0 then return nil end
    return table.concat(words, ' ')
end

-- 文から Name(マス) を拾う（英語名のみ。推測しない）。
-- Three of Clubs のような短い小文字のつなぎや、(E-7 民家裏) のようなマスのあとの注記も拾う。
function data.parse_listed_names(text)
    local out, seen = {}, {}
    if type(text) ~= 'string' or text == '' then return out end
    local i = 1
    while i <= #text do
        local a, b, col, row = text:find('%(([A-P])%s*%-%s*(%d%d?)[^%)]*%)', i)
        if not a then
            a, b, col, row = text:find('（([A-P])%s*%-%s*(%d%d?)[^）]*）', i)
        end
        if not a then break end
        local pre = text:sub(1, a - 1)
        local name = trailing_english_name(pre)
        if name and not seen[name] then
            seen[name] = true
            out[#out + 1] = { name = name, grid = col .. '-' .. tonumber(row) }
        end
        i = b + 1
    end
    return out
end

function data:_talk_index()
    -- 頭上の印・足元の輪用。座標が無くても、名前が一つに決まる相手は載せる（地図のピンは座標があるものだけ）。
    if self._talk_by_name then return self._talk_by_name end
    local idx = {}
    for _, t in pairs(self.targets or {}) do
        local n = target_en_name(t)
        if n then
            local k = util.lower(n)
            local list = idx[k]
            if not list then list = {}; idx[k] = list end
            list[#list + 1] = t
        end
    end
    self._talk_by_name = idx
    return idx
end

local function is_zoned_id(id)
    -- npc.236.Kaede / obj.236.Patient_Wheel
    local mid = tostring(id or ''):match('^[^%.]+%.([^%.]+)%.')
    return mid ~= nil and tonumber(mid) ~= nil
end

local function loc_zone(t)
    return t and t.location and tonumber(t.location.zone_id) or nil
end

local function loc_grid(t)
    return t and t.location and t.location.grid or nil
end

-- 名前＋マス＋手順のゾーンで、既存データのうち一つに決まるものだけ返す（推測しない）。
-- ほかのゾーンの同名は使わない。座標が無くても、印のためには返す（ピンは呼び出し側で座標を見る）。
function data:resolve_talk_name(name, grid, zone_id)
    if type(name) ~= 'string' or name == '' then return nil end
    local list = self:_talk_index()[util.lower(name)]
    if not list or #list == 0 then return nil end
    local cands = list
    zone_id = tonumber(zone_id)
    if zone_id then
        local z, unzoned = {}, {}
        for _, t in ipairs(cands) do
            local zid = loc_zone(t)
            if zid == zone_id then
                z[#z + 1] = t
            elseif not zid then
                unzoned[#unzoned + 1] = t
            end
        end
        if #z > 0 then cands = z else cands = unzoned end
    end
    if type(grid) == 'string' and grid ~= '' then
        local g = {}
        for _, t in ipairs(cands) do
            if loc_grid(t) == grid then g[#g + 1] = t end
        end
        if #g > 0 then cands = g end
    end
    local zoned = {}
    for _, t in ipairs(cands) do
        if is_zoned_id(t.id) then zoned[#zoned + 1] = t end
    end
    if #zoned > 0 then cands = zoned end
    -- 同じゾーンに座標ありとなしがあるときは、座標があるほうを優先（ピンと印を揃える）
    local with_pos = {}
    for _, t in ipairs(cands) do
        if target_has_pos(t) then with_pos[#with_pos + 1] = t end
    end
    if #with_pos > 0 then cands = with_pos end
    local uniq, n = {}, 0
    for _, t in ipairs(cands) do
        if not uniq[t.id] then uniq[t.id] = t; n = n + 1 end
    end
    if n ~= 1 then return nil end
    for _, t in pairs(uniq) do return t end
end

-- 手順に書かれた話し相手（主対象＋ extra_targets ＋文から解決できたもの）。座標がある id だけ。
function data:listed_talk_targets(step)
    if not step then return {} end
    local out, seen = {}, {}
    local function add(id)
        if not id or seen[id] then return end
        local t = self:target(id)
        if t and target_has_pos(t) then
            seen[id] = true
            out[#out + 1] = id
        end
    end
    add(step.target)
    for _, id in ipairs(type(step.extra_targets) == 'table' and step.extra_targets or {}) do
        add(id)
    end
    local zone = step.location and step.location.zone_id
    local names = {}
    for _, text in ipairs({ step.text_ja or '', step.next_line_ja or '' }) do
        for _, e in ipairs(data.parse_listed_names(text)) do
            names[#names + 1] = e
        end
    end
    if #names >= 2 or (#names >= 1 and (step.extra_targets and #step.extra_targets > 0 or step.target)) then
        for _, e in ipairs(names) do
            local t = self:resolve_talk_name(e.name, e.grid, zone)
            if t then add(t.id) end
        end
    end
    return out
end

function data:_fill_listed_talk_targets()
    -- resolved: 印用（座標なしでも一意に決まった相手）。resolved_pos: 地図のピン用（正確な LSB 座標あり）。
    self._talk_fill = { steps = 0, listed = 0, resolved = 0, resolved_pos = 0, added = 0,
        steps_multi_marks = 0, steps_multi_pins = 0, by_quest = {} }
    for _, q in ipairs(self.quests or {}) do
        for _, s in ipairs(q.steps or {}) do
            local typ = s.type
            local names = {}
            local seen = {}
            for _, text in ipairs({ s.text_ja or '', s.next_line_ja or '' }) do
                for _, e in ipairs(data.parse_listed_names(text)) do
                    if not seen[e.name] then seen[e.name] = true; names[#names + 1] = e end
                end
            end
            local talkish = typ == 'talk' or typ == 'trade' or typ == 'examine'
            if talkish and #names >= 2 then
                self._talk_fill.steps = self._talk_fill.steps + 1
                self._talk_fill.listed = self._talk_fill.listed + #names
                local zone = s.location and s.location.zone_id
                local extra = type(s.extra_targets) == 'table' and s.extra_targets or {}
                local have = { [s.target or ''] = true }
                local have_names = {}
                local function remember(id)
                    if not id then return end
                    have[id] = true
                    local tg = self:target(id)
                    local n = target_en_name(tg)
                    if n then have_names[util.lower(n)] = true end
                end
                remember(s.target)
                for _, id in ipairs(extra) do remember(id) end
                for _, e in ipairs(names) do
                    local t = self:resolve_talk_name(e.name, e.grid, zone)
                    if t then
                        self._talk_fill.resolved = self._talk_fill.resolved + 1
                        if target_has_pos(t) then self._talk_fill.resolved_pos = self._talk_fill.resolved_pos + 1 end
                        local nk = util.lower(target_en_name(t) or '')
                        -- 同じ英語名が既にあるときは足さない（主対象の短い id とゾーン付き id の二重登録を防ぐ）
                        if not have[t.id] and (nk == '' or not have_names[nk]) then
                            extra[#extra + 1] = t.id
                            remember(t.id)
                            self._talk_fill.added = self._talk_fill.added + 1
                        end
                    end
                end
                if #extra > 0 then s.extra_targets = extra end
                -- 印の対象（主対象＋ extra。座標なしでも名前が分かれば印と輪に使う）
                local mark_ids, pin_ids, seen_m = {}, {}, {}
                local function add_mark(id)
                    if not id or seen_m[id] then return end
                    local tg = self:target(id)
                    if not tg then return end
                    seen_m[id] = true
                    mark_ids[#mark_ids + 1] = id
                    if target_has_pos(tg) then pin_ids[#pin_ids + 1] = id end
                end
                add_mark(s.target)
                for _, id in ipairs(s.extra_targets or {}) do add_mark(id) end
                if #mark_ids >= 2 then
                    self._talk_fill.steps_multi_marks = self._talk_fill.steps_multi_marks + 1
                end
                if #pin_ids >= 2 then
                    self._talk_fill.steps_multi_pins = self._talk_fill.steps_multi_pins + 1
                end
                local rec = {
                    quest = q.id, step = s.id, category = q.category,
                    name_ja = q.name_ja_ref or q.name_ja, name_en = q.name_en,
                    listed = #names, marks = #mark_ids, pins = #pin_ids,
                }
                self._talk_fill.by_quest[#self._talk_fill.by_quest + 1] = rec
            end
        end
    end
end


return data
