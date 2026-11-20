--[[
  Astertrail - progress（キャラ別進行）
  - 画面からの「依頼」を受け、資料と照らして確かめてから記録を変える。
  - ファイルの読み書きはしない（storage が担当）。ゲームの API も呼ばない。
  - 記録元は manual（画面）と game（ゲームのクエスト・ミッションのログ、0.1.169〜）。状態は not_accepted / accepted / completed（不明は使わない）。
  - 記録がないクエストは未受注。古い保存の unknown は読み込み時に未受注へ合わせる。
]]

local json = require('src.lib.json')
local util = require('src.lib.util')

local PROGRESS_SCHEMA = 1

local STATES = { not_accepted = true, accepted = true, completed = true }

local progress = {}
progress.__index = progress
progress.SCHEMA = PROGRESS_SCHEMA
progress.STATES = { 'not_accepted', 'accepted', 'completed' }

-- opts: { data, clock = { now(), iso(t) }, max_pins = function() -> n, addon_version, on_change(kind, qid) }
function progress.new(opts)
    local self = setmetatable({
        data = opts.data,
        clock = opts.clock or { now = os.time, iso = util.iso_time },
        max_pins = opts.max_pins or function () return 10 end,
        addon_version = opts.addon_version or '0.0.0',
        on_change = opts.on_change,
        read_only = false,
        read_only_reason = nil,
        doc = nil,
    }, progress)
    self:reset(nil)
    return self
end

function progress:reset(character)
    self.rev = (self.rev or 0) + 1   -- 0.1.210〜：覚えた計算を作り直す印
    self.doc = {
        progress_schema = PROGRESS_SCHEMA,
        addon_version = self.addon_version,
        data_version = self.data and self.data.version or nil,
        character = character,
        saved_at = nil,
        quests = json.object({}),
        last_focus = nil,
        history = json.array({}),
        steps_on_complete = true,   -- 0.1.189〜：新しい記録は移し替え済み
    }
    self.read_only = false
    self.read_only_reason = nil
    self._defer_notify = {}
end

-- 読み込んだ表を受け入れる。戻り値: ok, why
function progress:adopt(doc, character)
    self.rev = (self.rev or 0) + 1   -- 0.1.210〜：覚えた計算を作り直す印
    if type(doc) ~= 'table' then return false, 'not_table' end
    local schema = tonumber(doc.progress_schema)
    if schema == nil then return false, 'no_schema' end
    if schema > PROGRESS_SCHEMA then
        -- 本体より新しい形式：読み取り専用で開き、上書きしない
        self.doc = doc
        self.read_only = true
        self.read_only_reason = 'newer_schema'
        return true, 'newer_schema'
    end
    -- （schema < 1 は存在しない。将来はここで1版ずつ変換する）
    if character and doc.character and doc.character.name and
        util.lower(doc.character.name) ~= util.lower(character.name or '') then
        return false, 'character_mismatch'
    end
    doc.quests = doc.quests or json.object({})
    setmetatable(doc.quests, getmetatable(doc.quests) or { __jsontype = 'object' })
    doc.history = doc.history or json.array({})
    for _, r in pairs(doc.quests) do
        r.steps = r.steps or json.object({})
        r.cycles = r.cycles or json.array({})
        if getmetatable(r.cycles) == nil then json.array(r.cycles) end
        if getmetatable(r.steps) == nil then json.object(r.steps) end
        -- 古い保存の unknown、または未知の値は未受注へ
        if r.state == 'unknown' or not STATES[r.state or ''] then r.state = 'not_accepted' end
        -- 固定は画面から外した。古い保存の固定は外して、状態を変えられないまま残さない
        r.locked = false
    end
    self:_migrate_guides(doc)
    doc.character = character or doc.character
    self.doc = doc
    self.read_only = false
    -- 0.1.57: 完了しているのにピン留めが残っている古い保存は外す（次の保存で書き戻す）
    self.unpinned_on_load = 0
    for qid, r in pairs(doc.quests) do
        if r.pinned and r.state == 'completed' then
            r.pinned = false
            r.pin_order = nil
            self.unpinned_on_load = self.unpinned_on_load + 1
        end
    end
    if self.unpinned_on_load > 0 then self:_renumber_pins() end
    -- 0.1.189〜（t319・t320）：完了しているクエスト・ミッションの手順を全部チェック済みにする（1回だけ）
    self.steps_done_on_load = 0
    if not doc.steps_on_complete then
        for qid, r in pairs(doc.quests) do
            if r.state == 'completed' then
                self.steps_done_on_load = self.steps_done_on_load + self:complete_steps(qid, 'migrate')
            end
        end
        doc.steps_on_complete = true
        self.steps_migrated = true
    end
    -- だいじなもの依存の後日談は、所持が分かるまで自動チェックを残さない（0.1.291〜）
    self._defer_notify = {}
    self:sync_followup_key_steps(nil)
    return true
end

-- 手順を書き直したクエストの記録を、新しい手順へ引き継ぐ。
-- 新しい手順は、元になった下書きの手順（migrated_from）が全部済みなら済みにする。
-- 古い手順の記録は steps_draft に残す（消さない）。古い id は guides/step_map.json で分かる。
function progress:_migrate_guides(doc)
    local D = self.data
    if not D or not D.is_draft_step then return 0 end
    local moved = 0
    local function map_step(q, r, old_id)
        for _, s in ipairs(q.steps) do
            if util.contains(s.migrated_from or {}, old_id) and not (r.steps[s.id] and r.steps[s.id].done) then
                return s.id
            end
        end
        return D.step_alias[old_id]
    end
    for qid, r in pairs(doc.quests) do
        local q = D:quest(qid)
        if q and q.guide then
            local has_old = D:is_draft_step(r.current_step)
            for k in pairs(r.steps) do
                if D:is_draft_step(k) then has_old = true; break end
            end
            if has_old then
                local old_rec = json.object({})
                local new_rec = json.object({})
                for k, v in pairs(r.steps) do
                    if D:is_draft_step(k) then old_rec[k] = v else new_rec[k] = v end
                end
                for _, s in ipairs(q.steps) do
                    local from = s.migrated_from or {}
                    if #from > 0 and not new_rec[s.id] then
                        local all, at = true, nil
                        for _, o in ipairs(from) do
                            local rec = old_rec[o]
                            if not (rec and rec.done == true) then all = false; break end
                            if rec.at and (at == nil or rec.at > at) then at = rec.at end
                        end
                        if all then new_rec[s.id] = { done = true, source = 'migrated', at = at } end
                    end
                end
                local keep = r.steps_draft or json.object({})
                if getmetatable(keep) == nil then json.object(keep) end
                for k, v in pairs(old_rec) do keep[k] = v end
                r.steps_draft = keep
                r.steps = new_rec
                if D:is_draft_step(r.current_step) then
                    local was = r.current_step
                    r.current_step = map_step(q, r, was)
                    -- 0.1.217〜：まとめた手順（例：BM7-1 の g03 → g02）。まとめる前の手順にいて、それが済んでいなければ、
                    -- まとめた手順も済みにしない（「探す」だけ済んで「調べる」がまだ、のとき）
                    local mid = r.current_step
                    if mid and not was:match('#s%d+$') and not (old_rec[was] and old_rec[was].done == true)
                        and new_rec[mid] and new_rec[mid].done == true then
                        new_rec[mid] = nil
                    end
                end
                moved = moved + 1
            end
        end
    end
    local lf = doc.last_focus
    if type(lf) == 'table' and D:is_draft_step(lf.step) then
        lf.step = D.step_alias[lf.step]
    end
    self.migrated_guides = moved
    return moved
end

function progress:set_read_only(reason)
    self.rev = (self.rev or 0) + 1   -- 0.1.210〜：覚えた計算を作り直す印
    self.read_only = true
    self.read_only_reason = reason
end

function progress:snapshot()
    local d = self.doc
    d.addon_version = self.addon_version
    d.data_version = self.data and self.data.version or d.data_version
    d.saved_at = self.clock.iso(self.clock.now())
    return d
end

---------------------------------------------------------------------------
-- 読み取り（画面向けの見え方）
---------------------------------------------------------------------------

function progress:record(qid)
    return self.doc.quests[qid]
end

function progress:state(qid)
    local r = self.doc.quests[qid]
    local st = r and r.state or 'not_accepted'
    if st == 'unknown' or not STATES[st] then return 'not_accepted' end
    return st
end

function progress:is_locked(qid)
    local r = self.doc.quests[qid]
    return r ~= nil and r.locked == true
end

function progress:is_pinned(qid)
    local r = self.doc.quests[qid]
    return r ~= nil and r.pinned == true
end

function progress:step_done(qid, sid)
    local r = self.doc.quests[qid]
    local s = r and r.steps[sid]
    return s ~= nil and s.done == true
end

function progress:cycle_count(qid)
    local r = self.doc.quests[qid]
    return r and #r.cycles or 0
end

-- リピートの印：資料で repeatable が yes かつ 完了歴が1件以上
function progress:repeat_mark(qid)
    local q = self.data:quest(qid)
    return q ~= nil and q.repeatable == 'yes' and self:cycle_count(qid) >= 1
end

---------------------------------------------------------------------------
-- ルート（書き直した手順で、回る順などを選ぶもの）
-- 同じルート（または共通）の手順で、先に「して完了」「ここで完了」があり、自分はそうでないもの（後日談）
function progress.is_complete_line(step)
    local line = step and step.next_line_ja or ''
    if type(line) ~= 'string' or line == '' then return false end
    return line:find('して完了', 1, true) ~= nil or line:find('ここで完了', 1, true) ~= nil
end

function progress.is_post_complete_followup(q, step, route)
    if not q or not step or progress.is_complete_line(step) then return false end
    local seen = false
    for _, st in ipairs(q.steps or {}) do
        if progress.step_in_route(st, route) then
            if st.id == step.id then return seen end
            if progress.is_complete_line(st) then seen = true end
        end
    end
    return false
end

--[[ 完了したら手順をチェック済みにする（0.1.189〜、t319・t320）
  ゲームの記録・ログインの読み直し・デバッグの手の切り替えのどれで完了になっても。
  ルートを選んでいれば、共通の手順と選んだルートの手順。選んでいなければ全部の手順（どのルートで済ませたか分からないため）。
  「して完了」よりあとの後日談は付けない（0.1.291〜。手紙を渡すなど、ミッション完了とは別のあと始末）。
  前からチェックしてあるものはそのまま（いつ・どこで付けたかを残す）。未完了に戻してもチェックは外さない。
  戻り値: 新しくチェックした数 ]]
function progress:complete_steps(qid, source)
    local q = self.data and self.data:quest(qid)
    local r = self.doc.quests[qid]
    if not q or not r then return 0 end
    r.steps = r.steps or json.object({})
    if getmetatable(r.steps) == nil then json.object(r.steps) end
    local route = self:chosen_route(qid)
    local now = self.clock.iso(self.clock.now())
    local n = 0
    for _, st in ipairs(q.steps or {}) do
        if progress.step_in_route(st, route) and not (r.steps[st.id] and r.steps[st.id].done)
            and not progress.is_post_complete_followup(q, st, route) then
            r.steps[st.id] = { done = true, source = 'completed', via = source, at = now }
            n = n + 1
        end
    end
    return n
end

-- だいじなものの所持から、後日談の手順のチェックを合わせる。
-- have(id, need) → 1 / 0 / nil。nil（未確認）と持っているときは未完了。持っていないときだけ済み。
-- 手紙を受け取る前（指定の手順より前）は、所持が 0 でもまだ受け取っていないことがあるので触れない。
function progress:followup_key_received(qid, step)
    if not step then return false end
    if self:state(qid) == 'completed' then return true end
    local r = self.doc and self.doc.quests and self.doc.quests[qid]
    if r and r.defer_complete then return true end
    local after = step.followup_key_item_after
    if after and self:step_done(qid, after) then return true end
    return false
end

-- ミッションの、一時的なだいじなものを渡す後日談（0.1.292〜）
function progress:followup_complete_step(qid)
    local q = self.data and self.data:quest(qid)
    if not q or q.kind ~= 'mission' then return nil end
    local route = self:chosen_route(qid)
    for _, st in ipairs(q.steps or {}) do
        if st.followup_key_item_id and progress.is_post_complete_followup(q, st, route) then
            return st
        end
    end
    return nil
end

function progress:followup_key_count(step, have)
    local kid = step and step.followup_key_item_id
    if type(have) ~= 'function' or not kid then return nil end
    local ok, c = pcall(have, kid, {
        kind = 'key_item', key_item_id = kid, name_ja = step.followup_key_item,
    })
    if not ok then return nil end
    if c == 0 or c == 1 then return c end
    return nil
end

-- have が渡されているときだけ：持っている／未確認なら、ゲームの完了を待たせる
function progress:should_defer_game_complete(qid, have)
    if type(have) ~= 'function' then return false end
    if not self:followup_complete_step(qid) then return false end
    local st = self:followup_complete_step(qid)
    return self:followup_key_count(st, have) ~= 0
end

function progress:_begin_defer_complete(qid, before, have)
    local r = self:_ensure(qid)
    if r.state ~= 'accepted' then
        r.state = 'accepted'
        r.state_at = self.clock.iso(self.clock.now())
    end
    r.state_source = 'game'
    r.defer_complete = true
    self:complete_steps(qid, 'game')
    self:_point_current_at_followup(qid)
    self._defer_notify = self._defer_notify or {}
    if self:followup_key_count(self:followup_complete_step(qid), have) == 1 then
        self._defer_notify[qid] = true
    end
    self:_changed('defer_complete', qid)
    return true, before
end

-- すでに本が完了になっていた（前の版で Karst 報告時に完了にした）記録を、手紙があるあいだ進行中に戻す。
-- 戻すときは完了のお知らせを出さない。手紙を渡したとき、一度だけ出す。
function progress:_demote_deferred_complete(qid)
    local r = self.doc.quests[qid]
    if not r or r.state ~= 'completed' then return false end
    r.state = 'accepted'
    r.state_source = 'game'
    r.defer_complete = true
    r.defer_complete_notified = nil
    self._defer_notify = self._defer_notify or {}
    self._defer_notify[qid] = true
    self:_point_current_at_followup(qid)
    -- 完了時にピン留めが外れているので、トラッカーに Gumbah の手順が出るよう付け直す
    if not r.pinned then self:pin(qid) end
    self:_changed('defer_complete', qid)
    return true
end

function progress:_finalize_deferred_complete(qid, have)
    local r = self.doc.quests[qid]
    if not r then return false end
    r.defer_complete = nil
    local notified = r.defer_complete_notified
    r.defer_complete_notified = nil
    local notify = (self._defer_notify and self._defer_notify[qid] and true or false) and not notified
    if self._defer_notify then self._defer_notify[qid] = nil end
    if r.state == 'completed' then return false end
    if r.state == 'accepted' and #(r.cycles or {}) > 0 then
        self._skip_cycle_once = qid
    end
    self:apply_game(qid, 'completed', have)
    self._skip_cycle_once = nil
    return notify
end

function progress:sync_followup_key_steps(have)
    if not self.data then return 0, {} end
    local n, completed = 0, {}
    for _, q in ipairs(self.data.quests or {}) do
        local changed = 0
        for _, st in ipairs(q.steps or {}) do
            local kid = st.followup_key_item_id
            if kid and self:followup_key_received(q.id, st) then
                local held
                if type(have) == 'function' then
                    local ok, c = pcall(have, kid, {
                        kind = 'key_item', key_item_id = kid,
                        name_ja = st.followup_key_item,
                    })
                    if ok then held = c end
                end
                local want = (held == 0)
                -- 未確認・持っている・have が無い → 未完了
                local is_done = self:step_done(q.id, st.id)
                if want and not is_done then
                    local r = self:_ensure(q.id)
                    r.steps = r.steps or json.object({})
                    if getmetatable(r.steps) == nil then json.object(r.steps) end
                    r.steps[st.id] = {
                        done = true, source = 'key_item',
                        at = self.clock.iso(self.clock.now()),
                    }
                    changed = changed + 1
                elseif (not want) and is_done then
                    local r = self.doc.quests[q.id]
                    if r and r.steps then r.steps[st.id] = nil end
                    changed = changed + 1
                end
            end
        end
        if changed > 0 then
            self:_point_current_at_followup(q.id)
            n = n + changed
        end
        -- ゲームが完了でも、一時的なだいじなものを持っているあいだは進行中のまま（0.1.292〜）
        local fu = self:followup_complete_step(q.id)
        if fu and type(have) == 'function' then
            local held = self:followup_key_count(fu, have)
            local r = self.doc.quests[q.id]
            if r and r.state == 'completed' and held == 1 then
                if self:_demote_deferred_complete(q.id) then n = n + 1 end
            elseif r and r.defer_complete and held == 0 then
                local notify = self:_finalize_deferred_complete(q.id, have)
                n = n + 1
                if notify then completed[#completed + 1] = q.id end
            elseif r and r.defer_complete and held == 1 then
                if not r.defer_complete_notified then
                    self._defer_notify = self._defer_notify or {}
                    self._defer_notify[q.id] = true
                end
            end
        end
    end
    if n > 0 then self:_changed('sync_followup', nil) end
    return n, completed
end

-- 完了済みの本文のあとに、未完了の後日談があれば、今の手順をそこに合わせる
function progress:_point_current_at_followup(qid)
    local q = self.data and self.data:quest(qid)
    local r = self.doc.quests[qid]
    if not q or not r then return end
    local route = self:chosen_route(qid)
    local first
    for _, st in ipairs(q.steps or {}) do
        if progress.step_in_route(st, route) and not self:step_done(qid, st.id) then
            first = st
            break
        end
    end
    if first and progress.is_post_complete_followup(q, first, route) then
        if r.current_step ~= first.id then
            r.current_step = first.id
        end
    end
end

-- 手順の route_ja（1つ）か routes_ja（複数）がルート。どちらも無い手順は全ルート共通。
---------------------------------------------------------------------------

function progress.step_in_route(step, route)
    if route == nil or step == nil then return true end
    if type(step.routes_ja) == 'table' and #step.routes_ja > 0 then
        return util.contains(step.routes_ja, route)
    end
    if step.route_ja and step.route_ja ~= '' then return step.route_ja == route end
    return true
end

local function first_route(step)
    if not step then return nil end
    if type(step.routes_ja) == 'table' and #step.routes_ja > 0 then return step.routes_ja[1] end
    if step.route_ja and step.route_ja ~= '' then return step.route_ja end
    return nil
end

-- クエストにあるルートの名前（手順の順）
function progress:routes(qid)
    local q = self.data:quest(qid)
    local out, seen = {}, {}
    for _, s in ipairs(q and q.steps or {}) do
        local list = (type(s.routes_ja) == 'table' and #s.routes_ja > 0) and s.routes_ja or
            ((s.route_ja and s.route_ja ~= '') and { s.route_ja } or {})
        for _, r in ipairs(list) do
            if not seen[r] then seen[r] = true; out[#out + 1] = r end
        end
    end
    return out
end

-- 選んでいるルート：明示（切り替え・ルートの手順のチェック）、なければ今の手順・済みの手順から
function progress:chosen_route(qid)
    local q = self.data:quest(qid)
    local r = self.doc.quests[qid]
    if not q or not r then return nil end
    local routes = self:routes(qid)
    if #routes == 0 then return nil end
    if r.route and util.contains(routes, r.route) then return r.route end
    local cur = r.current_step and self.data:step(r.current_step)
    if cur and self.data:quest_of_step(cur.id) == q and first_route(cur) and not cur.routes_ja then
        return cur.route_ja
    end
    for _, s in ipairs(q.steps) do
        if s.route_ja and s.route_ja ~= '' and not s.routes_ja and self:step_done(qid, s.id) then
            return s.route_ja
        end
    end
    return nil
end

-- 今の手順：手動で選んだもの、なければ（選んだルートの中で）最初の未チェックの手順
function progress:current_step(qid)
    local q = self.data:quest(qid)
    if not q then return nil end
    local r = self.doc.quests[qid]
    if r and r.current_step and self.data:step(r.current_step) and
        self.data:quest_of_step(r.current_step) == q then
        return self.data:step(r.current_step), true
    end
    local route = self:chosen_route(qid)
    for _, s in ipairs(q.steps) do
        if progress.step_in_route(s, route) and not self:step_done(qid, s.id) then return s, false end
    end
    return nil, false
end

-- 本・トラッカーの1行
function progress:next_line(qid)
    local s = self:current_step(qid)
    return s and s.next_line_ja or nil, s
end

function progress:all_steps_done(qid)
    local q = self.data:quest(qid)
    if not q or #q.steps == 0 then return false end
    local route = self:chosen_route(qid)
    if route == nil and #self:routes(qid) > 0 then
        -- ルートを選んでいないうちは、最後の手順が済んだときだけ
        local last = q.steps[#q.steps]
        for _, s in ipairs(q.steps) do
            if #(s.next or {}) == 0 and not self:step_done(qid, s.id) then return false end
        end
        return last ~= nil
    end
    for _, s in ipairs(q.steps) do
        if progress.step_in_route(s, route) and not self:step_done(qid, s.id) then return false end
    end
    return true
end

function progress:pinned_list()
    local out = {}
    for qid, r in pairs(self.doc.quests) do
        if r.pinned and self.data:quest(qid) then out[#out + 1] = qid end
    end
    -- ミッションをいつも上に（0.1.61〜）。その中はピン留めの順
    local function grp(qid)
        local q = self.data:quest(qid)
        return (q and q.kind == 'mission') and 0 or 1
    end
    table.sort(out, function (a, b)
        local ga, gb = grp(a), grp(b)
        if ga ~= gb then return ga < gb end
        local ra, rb = self.doc.quests[a], self.doc.quests[b]
        local pa, pb = ra.pin_order or 9999, rb.pin_order or 9999
        if pa ~= pb then return pa < pb end
        return a < b
    end)
    return out
end

function progress:last_focus()
    return self.doc.last_focus
end

-- 資料にない記録の数（消さずに残す）
function progress:orphan_count()
    local n = 0
    for qid, _ in pairs(self.doc.quests) do
        if not self.data:quest(qid) then n = n + 1 end
    end
    return n
end

---------------------------------------------------------------------------
-- 依頼（記録を変える唯一の入口）
-- 戻り値: { ok = bool, code = '...', ... }
---------------------------------------------------------------------------

local function fail(code, extra)
    local r = extra or {}
    r.ok = false
    r.code = code
    return r
end

-- ルートを選ぶ（nil で選び直し）。今の手順がほかのルートなら外す。
function progress:set_route(qid, route)
    local g = self:_guard(qid); if g then return g end
    if route ~= nil and not util.contains(self:routes(qid), route) then return fail('unknown_route') end
    local r = self:_ensure(qid)
    r.route = route
    local cur = r.current_step and self.data:step(r.current_step)
    if cur and route and not progress.step_in_route(cur, route) then r.current_step = nil end
    self:_changed('set_route', qid)
    return { ok = true, code = 'ok', route = route }
end


function progress:_ensure(qid)
    local r = self.doc.quests[qid]
    if not r then
        r = {
            state = 'not_accepted', state_source = 'manual', state_at = nil,
            locked = false, pinned = false, pin_order = nil,
            current_step = nil,
            steps = json.object({}),
            cycles = json.array({}),
        }
        self.doc.quests[qid] = r
    end
    return r
end

function progress:_changed(kind, qid)
    -- 変わった回数（0.1.210〜）。頭上の印などが、変わったときだけ計算し直すのに使う
    self.rev = (self.rev or 0) + 1
    if self.on_change then self.on_change(kind, qid) end
end

function progress:_focus(qid, sid)
    self.doc.last_focus = { quest = qid, step = sid, at = self.clock.iso(self.clock.now()) }
end

function progress:_guard(qid)
    if self.read_only then return fail('read_only') end
    if not self.doc.character then return fail('no_character') end
    if not self.data:quest(qid) then return fail('unknown_quest') end
    return nil
end

function progress:set_state(qid, state)
    local g = self:_guard(qid); if g then return g end
    if not STATES[state or ''] then return fail('bad_state') end
    if self:is_locked(qid) then return fail('locked') end
    local r = self:_ensure(qid)
    local now = self.clock.iso(self.clock.now())
    local before = r.state
    r.state = state
    r.state_source = 'manual'
    r.state_at = now
    if state == 'completed' and before ~= 'completed' then
        local c = r.cycles
        c[#c + 1] = { completed_at = now, source = 'manual' }
    end
    if state == 'completed' then self:complete_steps(qid, 'manual') end
    local unpinned = (state == 'completed') and self:_unpin_completed(qid) or false
    self:_focus(qid, r.current_step)
    self:_changed('set_state', qid)
    return { ok = true, code = 'ok', before = before, unpinned = unpinned }
end

-- ゲームの記録（クエスト・ミッションのログ）を当てる（0.1.169〜、t223）。
-- 受注・完了はゲームの記録を正しいものとする。手順のチェック（steps）はさわらない（消さない）。
-- 記録がなく、ゲームでも未受注のものは記録を作らない。戻り値: 変えたか, 前の状態
progress.HISTORY_MAX = 300
function progress:apply_game(qid, state, have)
    if self.read_only or not self.doc.character then return false end
    if not STATES[state or ''] or not self.data:quest(qid) then return false end
    local r = self.doc.quests[qid]
    if not r and state == 'not_accepted' then return false end
    local before = r and r.state or 'not_accepted'
    if r and before == state then
        if r.state_source ~= 'game' then r.state_source = 'game'; self:_changed('game', qid); return true, before end
        return false
    end
    r = self:_ensure(qid)
    -- 後日談で一時的なだいじなものをまだ持っている／未確認なら、完了にしない（0.1.292〜）
    if state == 'completed' and before ~= 'completed' and self:should_defer_game_complete(qid, have) then
        return self:_begin_defer_complete(qid, before, have)
    end
    local now = self.clock.iso(self.clock.now())
    r.state = state
    r.state_source = 'game'
    r.state_at = now
    if state == 'completed' and before ~= 'completed' then
        r.defer_complete = nil
        local c = r.cycles
        if self._skip_cycle_once ~= qid then
            c[#c + 1] = { completed_at = now, source = 'game' }
        end
        self:_unpin_completed(qid)
        self:complete_steps(qid, 'game')
    elseif state == 'accepted' and before == 'completed' then
        -- ゲームの記録で、完了からもう一度受けた（くり返し。0.1.190〜）：新しい回なので手順のチェックを外して手順1から。
        -- 完了の記録（cycles）は残す。デバッグの手で戻したとき（set_state）は外さない（t319）。
        r.steps = json.object({})
        r.current_step = nil
    end
    local h = self.doc.history
    h[#h + 1] = { at = now, quest = qid, from = before, to = state, source = 'game' }
    while #h > progress.HISTORY_MAX do table.remove(h, 1) end
    self:_changed('game', qid)
    return true, before
end

-- 手順にチェックを付けられないか（0.1.180〜、t290）：未受注のクエストは付けられない（外すのはできる）。
-- ミッションはこれまでどおり（拡張のミッションは受ける操作が無く、ゲームの記録からも分からないことがあるため）。
function progress:steps_locked(qid)
    local q = self.data:quest(qid)
    return q ~= nil and q.kind == 'quest' and self:state(qid) == 'not_accepted'
end

function progress:check_step(qid, sid, done)
    local g = self:_guard(qid); if g then return g end
    if done == nil then done = true end
    local step = self.data:step(sid)
    if not step or self.data:quest_of_step(sid) ~= self.data:quest(qid) then
        return fail('unknown_step')
    end
    if done and self:steps_locked(qid) then return fail('not_accepted') end
    local r = self:_ensure(qid)
    local now = self.clock.iso(self.clock.now())
    if done then
        r.steps[sid] = { done = true, source = 'manual', at = now }
        -- ルートの手順をチェックしたら、そのルートを選んだことにする
        if step.route_ja and step.route_ja ~= '' and not step.routes_ja then r.route = step.route_ja end
    else
        r.steps[sid] = nil
    end
    -- 0.1.261〜：手順のチェックは記録するが、受注中にはしない（受注はゲームの記録から）
    local promoted, kept_by_lock = false, false
    self:_focus(qid, sid)
    self:_changed('check_step', qid)
    local last = self.data:is_last_step(step)
    -- 最後の手順でもクエストは完了にしない。勧めるだけ。
    local suggest = done and r.state ~= 'completed' and (last or self:all_steps_done(qid))
    return { ok = true, code = 'ok', promoted = promoted, kept_by_lock = kept_by_lock,
             is_last = last, suggest_complete = suggest }
end

function progress:uncheck_step(qid, sid)
    return self:check_step(qid, sid, false)
end

---------------------------------------------------------------------------
-- 手順の決定と、前の手順の自動チェック（0.1.60〜）
-- 手順は q.steps の順。「前の手順」は、選んだルートの手順と、どのルートにも共通の手順だけ。
-- ルートをまだ選んでいないときは、共通の手順だけ（ほかのルートには付けない）。
---------------------------------------------------------------------------

local function index_of(q, sid)
    for i, s in ipairs(q and q.steps or {}) do if s.id == sid then return i end end
    return nil
end

-- 共通の手順（route_ja も routes_ja も無い）
local function is_common(s)
    return not ((type(s.routes_ja) == 'table' and #s.routes_ja > 0) or (s.route_ja and s.route_ja ~= ''))
end

-- その手順の「前」に数える手順か
function progress:_counts_before(qid, s)
    if is_common(s) then return true end
    local route = self:chosen_route(qid)
    if route == nil then return false end
    return progress.step_in_route(s, route)
end

-- sid の前の手順に全部チェックを付ける（through=true なら sid も）。付けた数を返す
function progress:_check_before(qid, sid, through, now)
    local q = self.data:quest(qid)
    local r = self:_ensure(qid)
    local idx = index_of(q, sid)
    if not idx then return 0 end
    local n = 0
    for i, s in ipairs(q.steps) do
        if i > idx then break end
        if (i < idx and self:_counts_before(qid, s)) or (i == idx and through) then
            if not (r.steps[s.id] and r.steps[s.id].done) then
                r.steps[s.id] = { done = true, source = (i == idx) and 'manual' or 'auto_before', at = now }
                n = n + 1
            end
        end
    end
    return n
end

-- sid から後（from_self=true なら sid も）のチェックを全部外す。外した数を返す
function progress:_uncheck_after(qid, sid, from_self)
    local q = self.data:quest(qid)
    local r = self.doc.quests[qid]
    if not r then return 0 end
    local idx = index_of(q, sid)
    if not idx then return 0 end
    local n = 0
    for i, s in ipairs(q.steps) do
        if (i > idx or (i == idx and from_self)) and r.steps[s.id] then
            r.steps[s.id] = nil
            n = n + 1
        end
    end
    return n
end

-- 手順のチェックを付ける：その手順と、前の手順に全部（画面の □ から）
function progress:check_through(qid, sid)
    local res = self:check_step(qid, sid, true)
    if not res.ok then return res end
    local r = self.doc.quests[qid]
    res.auto_checked = self:_check_before(qid, sid, false, self.clock.iso(self.clock.now()))
    -- 今の手順がチェック済みになったら、次の未チェックの手順へ（トラッカーの「次にやること」と合わせる）
    if r.current_step and self:step_done(qid, r.current_step) then r.current_step = nil end
    local last = self.data:is_last_step(self.data:step(sid))
    res.suggest_complete = r.state ~= 'completed' and (last or self:all_steps_done(qid))
    if res.auto_checked > 0 then self:_changed('check_step', qid) end
    return res
end

-- 手順のチェックを外す：その手順から後を全部（「戻る」）。今の手順はその手順にする
function progress:uncheck_from(qid, sid)
    local res = self:check_step(qid, sid, false)
    if not res.ok then return res end
    local r = self.doc.quests[qid]
    res.auto_unchecked = self:_uncheck_after(qid, sid, false)
    r.current_step = sid
    local st = self.data:step(sid)
    if st and st.route_ja and st.route_ja ~= '' and not st.routes_ja then r.route = st.route_ja end
    self:_changed('uncheck_step', qid)
    return res
end

-- トラッカーの手順の数（0.1.64〜）：今の手順が何番目か / 全部でいくつか。
-- ルートを選んでいれば、共通の手順とそのルートの手順だけを数える。
-- ルートがまだ決まっていなければ、共通の手順と、いちばん長いルートの手順を数える（多めに見る）。
-- 全部済み（今の手順が無い）なら 全部/全部。手順が無ければ nil
function progress:step_count(qid)
    local q = self.data:quest(qid)
    if not q or #(q.steps or {}) == 0 then return nil end
    local route = self:chosen_route(qid)
    if route == nil then
        local best, best_n = nil, -1
        for _, rt in ipairs(self:routes(qid)) do
            local n = 0
            for _, st in ipairs(q.steps) do
                if not is_common(st) and progress.step_in_route(st, rt) then n = n + 1 end
            end
            if n > best_n then best, best_n = rt, n end
        end
        route = best
    end
    local list = {}
    for _, st in ipairs(q.steps) do
        if progress.step_in_route(st, route) then list[#list + 1] = st end
    end
    local total = #list
    local cur = self:current_step(qid)
    if not cur then return total, total end
    for i, st in ipairs(list) do
        if st.id == cur.id then return i, total end
    end
    -- 今の手順が数えた中に無い（別のルートの手順など）：q.steps の順で、その前にある数えた手順の数＋1
    local idx = index_of(q, cur.id) or 1
    local n = 0
    for i, st in ipairs(q.steps) do
        if i >= idx then break end
        if progress.step_in_route(st, route) then n = n + 1 end
    end
    return math.min(n + 1, total), total
end

-- トラッカーの ◀▶（0.1.61〜）：今の手順から、前・次の手順を決める
-- 戻り値 { cur, prev, next, branch（次がいくつもあってルート未定のときの手順 id の表）, last（最後の手順）, done（全部済み） }
-- 前：q.steps の順で、今の手順より前の「数える手順」（共通・選んだルート）。
-- 次：資料の next。選んだルートがあればその中で。next が無い手順は、q.steps の順で後ろの同じルートの手順。
function progress:step_nav(qid)
    local q = self.data:quest(qid)
    local out = {}
    if not q or #(q.steps or {}) == 0 then return out end
    local steps = q.steps
    local cur = self:current_step(qid)
    out.cur = cur
    if not cur then
        out.done = true
        for i = #steps, 1, -1 do
            if self:_counts_before(qid, steps[i]) then out.prev = steps[i]; break end
        end
        out.prev = out.prev or steps[#steps]
        return out
    end
    local idx = index_of(q, cur.id) or 1
    for i = idx - 1, 1, -1 do
        if self:_counts_before(qid, steps[i]) then out.prev = steps[i]; break end
    end
    local route = self:chosen_route(qid)
    local nexts = {}
    for _, nid in ipairs(cur.next or {}) do
        local ns = self.data:step(nid)
        if ns and self.data:quest_of_step(nid) == q and (route == nil or progress.step_in_route(ns, route)) then
            nexts[#nexts + 1] = ns
        end
    end
    if #nexts == 1 then
        out.next = nexts[1]
    elseif #nexts > 1 then
        out.branch = {}
        for _, ns in ipairs(nexts) do out.branch[#out.branch + 1] = ns.id end
    elseif #(cur.next or {}) == 0 then
        if self.data:is_last_step(cur) then
            out.last = true
        else
            for i = idx + 1, #steps do
                if progress.step_in_route(steps[i], route) then out.next = steps[i]; break end
            end
            if not out.next then out.last = true end
        end
    else
        -- 選んだルートに合う次が無い：資料の next をそのまま（1つなら次、いくつもなら選ぶ）
        local raw = {}
        for _, nid in ipairs(cur.next) do
            if self.data:step(nid) and self.data:quest_of_step(nid) == q then raw[#raw + 1] = nid end
        end
        if #raw == 1 then out.next = self.data:step(raw[1])
        elseif #raw > 1 then out.branch = raw
        else out.last = true end
    end
    return out
end

-- 手順を決定する（行を押す・決定ボタン）：今の手順にし、前の手順に全部チェックを付け、
-- その手順から後のチェックは外す（チェック済みの手順を決定し直すと、そこまで戻る）
-- 完了しているクエスト・ミッションは、今の手順を選ぶだけ（チェックは全部残す。0.1.191〜）
function progress:decide_step(qid, sid)
    local res = self:set_current_step(qid, sid)
    if not res.ok then return res end
    local r = self.doc.quests[qid]
    if r.state == 'completed' then
        res.auto_unchecked = 0
        res.auto_checked = 0
        return res
    end
    local now = self.clock.iso(self.clock.now())
    res.auto_unchecked = self:_uncheck_after(qid, sid, true)
    -- 未受注のクエストは、今の手順を選ぶだけ（前の手順にチェックを付けない。0.1.180〜）
    res.auto_checked = self:steps_locked(qid) and 0 or self:_check_before(qid, sid, false, now)
    -- 0.1.261〜：今の手順を選んでも受注中にはしない
    r.current_step = sid
    self:_changed('set_current_step', qid)
    return res
end

function progress:set_current_step(qid, sid)
    local g = self:_guard(qid); if g then return g end
    local step = self.data:step(sid)
    if not step or self.data:quest_of_step(sid) ~= self.data:quest(qid) then
        return fail('unknown_step')
    end
    local r = self:_ensure(qid)
    -- 資料の next でたどれるか（たどれなくても手動なので記録し、注意を返す）
    local reachable = true
    local cur = r.current_step and self.data:step(r.current_step)
    if cur and cur.id ~= sid then
        reachable = util.contains(cur.next, sid)
    end
    r.current_step = sid
    if step.route_ja and step.route_ja ~= '' and not step.routes_ja then r.route = step.route_ja end
    self:_focus(qid, sid)
    self:_changed('set_current_step', qid)
    return { ok = true, code = reachable and 'ok' or 'not_reachable', reachable = reachable }
end

function progress:pin(qid)
    self.rev = (self.rev or 0) + 1   -- 0.1.210〜：覚えた計算を作り直す印
    local g = self:_guard(qid); if g then return g end
    if self:is_pinned(qid) then return { ok = true, code = 'already' } end
    local list = self:pinned_list()
    if #list >= self.max_pins() then return fail('pin_limit', { limit = self.max_pins() }) end
    local r = self:_ensure(qid)
    r.pinned = true
    r.pin_order = #list + 1
    self:_changed('pin', qid)
    return { ok = true, code = 'ok' }
end

-- 完了扱いになったクエストのピン留めを外す（トラッカーからも消える）。
-- 完了にする所はすべてここを通す（本・詳細・トラッカーの「完了にする」、最後の手順のあとの完了。
-- 進み具合の自動読み取りを入れるときも、完了にしたらここを呼ぶ）。
function progress:_unpin_completed(qid)
    self.rev = (self.rev or 0) + 1   -- 0.1.210〜：覚えた計算を作り直す印
    local r = self.doc.quests[qid]
    if not r or not r.pinned or r.state ~= 'completed' then return false end
    r.pinned = false
    r.pin_order = nil
    self:_renumber_pins()
    return true
end

function progress:_renumber_pins()
    for i, qid in ipairs(self:pinned_list()) do
        self.doc.quests[qid].pin_order = i
    end
end

function progress:unpin(qid)
    self.rev = (self.rev or 0) + 1   -- 0.1.210〜：覚えた計算を作り直す印
    local g = self:_guard(qid); if g then return g end
    local r = self.doc.quests[qid]
    if not r or not r.pinned then return { ok = true, code = 'already' } end
    r.pinned = false
    r.pin_order = nil
    self:_renumber_pins()
    self:_changed('unpin', qid)
    return { ok = true, code = 'ok' }
end

-- 同じ並びの組か（ミッション同士・クエスト同士）
function progress:same_pin_group(a, b)
    local qa, qb = self.data:quest(a), self.data:quest(b)
    return ((qa and qa.kind == 'mission') or false) == ((qb and qb.kind == 'mission') or false)
end

-- 上へ・下へ動かせるか（トラッカーの ▲▼ を薄くするため）
function progress:can_move_pin(qid, dir)
    local list = self:pinned_list()
    for i, id in ipairs(list) do
        if id == qid then
            local j = i + (dir < 0 and -1 or 1)
            return list[j] ~= nil and self:same_pin_group(qid, list[j])
        end
    end
    return false
end

-- dir: -1 上へ / +1 下へ
function progress:move_pin(qid, dir)
    self.rev = (self.rev or 0) + 1   -- 0.1.210〜：覚えた計算を作り直す印
    local g = self:_guard(qid); if g then return g end
    local list = self:pinned_list()
    local idx
    for i, id in ipairs(list) do if id == qid then idx = i end end
    if not idx then return fail('not_pinned') end
    local j = idx + (dir < 0 and -1 or 1)
    if j < 1 or j > #list then return { ok = true, code = 'edge' } end
    -- ミッションとクエストのあいだは入れ替えない（ミッションはいつも上）
    if not self:same_pin_group(list[idx], list[j]) then return { ok = true, code = 'edge' } end
    list[idx], list[j] = list[j], list[idx]
    for i, id in ipairs(list) do self.doc.quests[id].pin_order = i end
    self:_changed('move_pin', qid)
    return { ok = true, code = 'ok' }
end

function progress:lock(qid, on)
    self.rev = (self.rev or 0) + 1   -- 0.1.210〜：覚えた計算を作り直す印
    local g = self:_guard(qid); if g then return g end
    if on == nil then on = true end
    local r = self:_ensure(qid)
    r.locked = on and true or false
    self:_changed(on and 'lock' or 'unlock', qid)
    return { ok = true, code = 'ok' }
end

function progress:unlock(qid)
    self.rev = (self.rev or 0) + 1   -- 0.1.210〜：覚えた計算を作り直す印
    return self:lock(qid, false)
end

-- 新しい周回。confirmed: リピート可否が yes 以外の時、確認を済ませたか
function progress:start_cycle(qid, confirmed)
    self.rev = (self.rev or 0) + 1   -- 0.1.210〜：覚えた計算を作り直す印
    local g = self:_guard(qid); if g then return g end
    if self:is_locked(qid) then return fail('locked') end
    local r = self.doc.quests[qid]
    if not r or #r.cycles < 1 then return fail('no_completion') end
    local q = self.data:quest(qid)
    if q.repeatable ~= 'yes' and not confirmed then
        return fail('need_confirm')
    end
    -- 過去の周回は残し、手順のチェックだけ新しい周回用に空にする
    local last = r.cycles[#r.cycles]
    if last and last.steps == nil then last.steps = r.steps end
    r.steps = json.object({})
    r.current_step = nil
    r.route = nil
    r.state = 'accepted'
    r.state_source = 'manual'
    r.state_at = self.clock.iso(self.clock.now())
    self:_focus(qid, nil)
    self:_changed('start_cycle', qid)
    return { ok = true, code = 'ok' }
end


-- ゲームの受注フラグが立っていないものを未開始に戻す（0.1.261〜）。
-- game_of(qid) は 'not_accepted' / 'accepted' / 'completed' / nil（読めない）。
-- qid を指定すればその1件だけ。ゲームが受注・完了としているものは触らない。
function progress:revert_unstarted(game_of, qid)
    if self.read_only or type(game_of) ~= 'function' then
        return { ok = false, code = 'read_only', reverted = 0, skipped = 0, kept = 0 }
    end
    local ids = {}
    if qid then
        ids[1] = qid
    else
        for id in pairs(self.doc.quests or {}) do ids[#ids + 1] = id end
        table.sort(ids)
    end
    local reverted, skipped, kept = 0, 0, 0
    local names = {}
    for _, id in ipairs(ids) do
        if not self.data:quest(id) then goto nx end
        local st = game_of(id)
        if not st then
            skipped = skipped + 1
        elseif st == 'accepted' or st == 'completed' then
            kept = kept + 1
        elseif st == 'not_accepted' then
            local cur = self:state(id)
            if cur == 'not_accepted' then
                kept = kept + 1
            else
                local ok = self:apply_game(id, 'not_accepted')
                if ok then
                    reverted = reverted + 1
                    if #names < 5 then names[#names + 1] = id end
                else
                    skipped = skipped + 1
                end
            end
        else
            skipped = skipped + 1
        end
        ::nx::
    end
    return { ok = true, code = 'ok', reverted = reverted, skipped = skipped, kept = kept, ids = names }
end

---------------------------------------------------------------------------
-- 集計（画面向け）
---------------------------------------------------------------------------

-- 必要品まとめ（needs_summary）とエリア入場（here_now）は 0.1.173 でなくした（t251）

return progress
