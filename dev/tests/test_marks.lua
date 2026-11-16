require('harness')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local marks = require('src.core.marks')
local project = require('src.core.project')
local settings = require('src.core.settings')

local fs = posix_fs()
local D = data_mod.load(fs, ROOT .. '/data/')
eq(#D.errors, 0, 'data errors')

local P = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
P:reset({ server = 'catseye', name = 'Test' })

local function wanted_named(list, name, role)
    local out = {}
    for _, w in ipairs(list) do
        if w.name == name and (role == nil or w.role == role) then out[#out + 1] = w end
    end
    return out
end

-- 未受注・くり返しで相手に出る状態のアイコン（0.1.63〜）。talk / examine の古い見た目は使わない
local STATUS_LOOK = { sub = true, ['repeat'] = true, unavailable = true, main = true }

-- データから「??? を調べて受ける」クエストを集める（発生の相手の名前が ???）。
-- 期待する場所は発生の相手自身の場所（手順1が同じ相手で場所を持つならそちら）。
local function qqq_start_quests()
    local out = {}
    for _, q in ipairs(D.quests or {}) do
        local tg = D.start_target and D:start_target(q)
        if not tg and q.start then tg = D:target(q.start.target) end
        if tg and marks.norm_name(tg.name_en) == '???' then
            local s1 = q.steps and q.steps[1]
            local loc = tg.location or {}
            if s1 and s1.target == tg.id and s1.location and s1.location.grid then loc = s1.location end
            out[#out + 1] = { q = q, tg = tg, zone_id = loc.zone_id or (tg.location and tg.location.zone_id), grid = loc.grid or (tg.location and tg.location.grid) }
        end
    end
    return out
end

local function shown_qqq_start_marks()
    local n = 0
    for _, e in ipairs(qqq_start_quests()) do
        if P:state(e.q.id) == 'not_accepted' and not marks.has_open_same_npc_ancestor(D, P, e.q, e.tg.id) then
            n = n + 1
        end
    end
    return n
end

-- 0.1.140〜：未受注で手順1が発生とは別の ???（してもしなくてもよい「カギを取る」など。手順はゲームの順のまま）なら、
-- その手順の印も出てよい。数を返し、どれも今の手順の印がちょうど1つかを確かめる
local function step1_qqq_marks(all)
    local n = 0
    for _, q in ipairs(D.quests or {}) do
        if P:state(q.id) == 'not_accepted' then
            local s = P:current_step(q.id)
            local t = s and s.target and D:target(s.target)
            local st = D.start_target and D:start_target(q)
            if not st and q.start then st = D:target(q.start.target) end
            if t and marks.norm_name(t.name_en) == '???' and not (st and st.id == t.id) then
                n = n + 1
                local hit = 0
                for _, x in ipairs(all) do
                    if x.quest_id == q.id and x.target_id == t.id and x.step_id == s.id then hit = hit + 1 end
                end
                eq(hit, 1, q.id .. ': one mark on the step-1 ??? (' .. t.id .. ')')
            end
        end
    end
    return n
end

-- 未受注の ??? 発生は、どれも「調べる」の印がちょうど1つ、正しいゾーンとマスで、マス必須で出る
local function check_qqq_starts(wl, label)
    local starts = qqq_start_quests()
    local n = 0
    for _, e in ipairs(starts) do
        if P:state(e.q.id) == 'not_accepted' then
            n = n + 1
            local hits, other = {}, 0
            for _, x in ipairs(wl) do
                if x.quest_id == e.q.id and x.target_id == e.tg.id then
                    if x.role == 'examine' then hits[#hits + 1] = x else other = other + 1 end
                end
            end
            local id = label .. ' ' .. e.q.id
            local later = marks.has_open_same_npc_ancestor(D, P, e.q, e.tg.id)
            if later then
                eq(#hits, 0, id .. ': later chain stage hidden at this ???')
            else
                eq(#hits, 1, id .. ': one examine mark on the start ???')
            end
            eq(other, 0, id .. ': no talk mark on the start ???')
            if hits[1] then
                -- 見た目は 0.1.63 の状態のアイコン（未受注なら sub）。役割の「調べる」は置き場所だけ
                eq(hits[1].icon, marks.quest_icon(D, P, e.q), id .. ': status icon')
                check(STATUS_LOOK[hits[1].icon], id .. ': not an old role look: ' .. tostring(hits[1].icon))
                check(hits[1].require_grid, id .. ': requires grid')
                check(e.grid ~= nil, id .. ': data has a grid')
                eq(hits[1].grid, e.grid, id .. ': grid from the ??? itself')
                eq(hits[1].zone_id, e.zone_id, id .. ': zone')
            end
        end
    end
    return n
end

local function roles(list)
    local s = {}
    for _, w in ipairs(list) do s[#s + 1] = (w.role or '?') .. ':' .. (w.name or '?') end
    table.sort(s)
    return table.concat(s, ',')
end

-- ??? を調べて受けるクエスト：未受注では全部に「調べる」の印。照合ではそのマスの ??? にだけ付く（データから）
do
    local all = marks.wanted(D, P)
    local starts = qqq_start_quests()
    check(#starts >= 1, 'data has ??? start quests')
    eq(check_qqq_starts(all, 'fresh'), #starts, 'all ??? starts not accepted at reset')
    local step_qqq = step1_qqq_marks(all)
    eq(#wanted_named(all, '???'), shown_qqq_start_marks() + step_qqq, 'no other ??? marks at reset')
    for _, e in ipairs(starts) do
        if marks.has_open_same_npc_ancestor(D, P, e.q, e.tg.id) then
            -- 同じ ??? の連続クエストのあとの段は、いまは印を出さない
        else
        local w = {}
        for _, x in ipairs(all) do if x.quest_id == e.q.id and x.target_id == e.tg.id then w[#w + 1] = x end end
        local far = (e.grid == 'A-1') and 'L-12' or 'A-1'
        local ents = { { index = 1, name = '???', grid = far }, { index = 2, name = '？？？', grid = e.grid } }
        local m = marks.match(w, ents, { zone_id = e.zone_id, grid_of = function (ent) return ent.grid end })
        eq(#m, 1, e.q.id .. ': one ??? matched')
        if m[1] then
            eq(m[1].entity.index, 2, e.q.id .. ': the ??? on ' .. tostring(e.grid))
            eq(m[1].role, 'examine', e.q.id .. ': examine role')
            -- 前提クエストがある ??? 発生は、前提を終えるまで unavailable（0.1.92 で前提リンクを増やした）
            eq(m[1].icon, marks.quest_icon(D, P, e.q), e.q.id .. ': 未受注 icon on the ???')
            check(m[1].icon == 'sub' or m[1].icon == 'unavailable' or (e.q.repeatable == 'yes' and m[1].icon == 'repeat'), e.q.id .. ': sub, unavailable or repeat')  -- 繰り返せる ??? 発生（神在月など、0.1.110〜）は repeat
            local on_name, on_body = marks.split_for_draw(m)
            eq(#on_body, 1, e.q.id .. ': drawn on the object')
            eq(#on_name, 0, e.q.id .. ': not on a name')
        end
        end
    end
end

-- 物（??? ・扉・Imperial Whitegate など）から受けるクエスト全部：未受注では物の上に状態のアイコン、
-- マスは物自身のもの。「話す」の印は付けない（データから）
do
    local all = marks.wanted(D, P)
    local n = 0
    for _, q in ipairs(D.quests or {}) do
        local tg = D.start_target and D:start_target(q)
        if not tg and q.start then tg = D:target(q.start.target) end
        if tg and tg.kind == 'obj' and P:state(q.id) == 'not_accepted' then
            n = n + 1
            if marks.has_open_same_npc_ancestor(D, P, q, tg.id) then
                -- 同じ物の連続クエストのあとの段は出さない
            else
            local ex, talk = {}, 0
            for _, x in ipairs(all) do
                if x.quest_id == q.id and x.target_id == tg.id then
                    if x.role == 'examine' then ex[#ex + 1] = x elseif x.role == 'talk' then talk = talk + 1 end
                end
            end
            eq(#ex, 1, q.id .. ': one examine-placed mark on ' .. tostring(tg.name_en))
            eq(talk, 0, q.id .. ': no talk mark on the object')
            if ex[1] then
                eq(ex[1].icon, marks.quest_icon(D, P, q), q.id .. ': status icon')
                check(STATUS_LOOK[ex[1].icon], q.id .. ': status look, got ' .. tostring(ex[1].icon))
                local s1 = q.steps and q.steps[1]
                local loc = (s1 and s1.target == tg.id and s1.location and s1.location.grid) and s1.location or tg.location or {}
                if loc.grid then eq(ex[1].grid, loc.grid, q.id .. ': grid of the object') end
                check(marks.on_body(ex[1].name, ex[1].role), q.id .. ': drawn on the body')
            end
            end
        end
    end
    check(n >= 10, 'object start quests found in data: ' .. n)
end

-- 未受注でも、次の手順に相手がいれば印の対象にする（話して受ける、など）
do
    local w = marks.wanted(D, P)
    local n_guard, n_other = 0, 0
    for _, x in ipairs(w) do
        if x.role == 'guard' then n_guard = n_guard + 1 else n_other = n_other + 1 end
    end
    eq(n_guard, 11, '11 gate guards')
    check(n_other >= 14, 'start marks when not accepted: ' .. tostring(n_other))
    local rakoh = wanted_named(w, 'Rakoh Buuma', 'guard')
    eq(#rakoh, 1, 'rakoh present')
    local aq = wanted_named(w, 'Aquillina', 'talk')
    eq(#aq, 1, 'aquillina wanted when not accepted')
    eq(aq[1].grid, 'K-9', 'aquillina grid')
    local m = marks.match(marks.in_zone(w, 235), {
        { index = 1, name = 'Aquillina' },
        { index = 2, name = 'Someone Else' },
    }, { zone_id = 235 })
    eq(#m, 1, 'aquillina matched')
    eq(m[1].role, 'talk', 'talk')
    eq(m[1].entity.index, 1, 'same entity')
    -- 同じ発生NPCに公式クエストが2件（Nbu Latteh）。2件目は1件目が前提の連続クエストなので、まだ受けられない間は出さない（0.1.204〜）
    local nbu = wanted_named(w, 'Nbu Latteh', 'talk')
    eq(#nbu, 1, 'only the current mom quest on Nbu Latteh')
    eq(nbu[1].quest_id, 'quest.bastok.005', 'first mom quest')
    eq(nbu[1].icon, 'repeat', 'first mom quest is repeatable')
    -- 前提が済む前の2件目は wanted から外す（受けられない印も重ねない）
    eq(marks.quest_icon(D, P, D:quest('quest.bastok.006'), { status = nil }), 'unavailable', 'second needs the first')
    local m2 = marks.match(marks.in_zone(w, 235), {
        { index = 9, name = 'Nbu Latteh' },
    }, { zone_id = 235 })
    eq(#m2, 1, 'one nbu entity')
    eq(#m2[1].wanted, 1, 'only the current chain quest')
    eq(m2[1].icon, 'repeat', 'row icon')
end

-- 受注中の話す NPC
P:set_state('quest.windurst.001', 'accepted')
do
    local w = marks.in_zone(marks.wanted(D, P), 241)
    local talks = wanted_named(w, 'Illu Bohjaa', 'talk')
    eq(#talks, 1, 'illu talk wanted')
    eq(talks[1].grid, 'I-6', 'illu grid')
    -- 別ゾーンでは出ない
    eq(#wanted_named(marks.in_zone(marks.wanted(D, P), 230), 'Illu Bohjaa'), 0, 'not in sandoria')
    -- 照合：見えている相手に付く
    local ents = {
        { index = 1, name = 'Illu Bohjaa', x = 0, y = 0, dead = false },
        { index = 2, name = 'Someone Else', x = 0, y = 0, dead = false },
    }
    local m = marks.match(w, ents, { zone_id = 241 })
    eq(#m, 1, 'one match')
    eq(m[1].role, 'talk', 'talk role')
    eq(m[1].entity.index, 1, 'same entity')
end

-- 討伐：生きている同じ名前の敵すべて。死んでいる相手には付けない
P:set_state('quest.windurst.001', 'not_accepted')
P:set_state('mission.sandoria.001', 'accepted')
P:set_current_step('mission.sandoria.001', 'mission.sandoria.001#g02')
do
    local step = P:current_step('mission.sandoria.001')
    eq(step and step.type, 'defeat', 'defeat step')
    local w = marks.wanted(D, P)
    local hunts = wanted_named(w, 'Orcish Fodder', 'hunt')
    eq(#hunts, 1, 'fodder wanted')
    eq(hunts[1].moves, true, 'mobs move')
    local ents = {
        { index = 10, name = 'Orcish Fodder', dead = false },
        { index = 11, name = 'Orcish Fodder', dead = false },
        { index = 12, name = 'Orcish Fodder', dead = true },
        { index = 13, name = 'Orcish Warmachine', dead = false },
    }
    local m = marks.match(marks.in_zone(w, 100), ents, {})
    local ids = {}
    for _, row in ipairs(m) do
        eq(row.role, 'hunt', 'hunt')
        ids[#ids + 1] = row.entity.index
    end
    table.sort(ids)
    eq(table.concat(ids, ','), '10,11', 'living fodder only')
end

-- 調べる対象
P:set_state('mission.sandoria.001', 'not_accepted')
P:set_state('mission.sandoria.002', 'accepted')
P:set_current_step('mission.sandoria.002', 'mission.sandoria.002#g02')
do
    local w = wanted_named(marks.wanted(D, P), 'Tombstone', 'examine')
    eq(#w, 1, 'tombstone')
    local m = marks.match(w, { { index = 3, name = 'Tombstone' } }, {})
    eq(#m, 1, 'tombstone matched')
    eq(m[1].role, 'examine', 'examine role')
end

-- 「???」は座標が無いと付けない。座標が合う相手だけ。
P:set_state('mission.sandoria.002', 'not_accepted')
P:set_state('quest.bastok.003', 'accepted')
P:set_current_step('quest.bastok.003', 'quest.bastok.003#g02')
do
    -- ??? を調べて受けるクエストも未受注で出る。データから数を出して、全体の数も確かめる
    local all = marks.wanted(D, P)
    local n_start = check_qqq_starts(all, 'accepted bastok.003')
    check(#qqq_start_quests() >= 1, 'data has ??? start quests')
    eq(#wanted_named(all, '???'), 1 + shown_qqq_start_marks() + step1_qqq_marks(all), '??? wanted = this step + ??? starts + step-1 ???')
    local w = {}
    for _, x in ipairs(wanted_named(all, '???', 'examine')) do
        if x.quest_id == 'quest.bastok.003' then w[#w + 1] = x end
    end
    eq(#w, 1, '??? wanted')
    check(w[1].require_grid, '??? requires grid')
    eq(w[1].grid, 'J-5', '??? grid J-5 (0.1.52: 用語辞典に合わせた)')
    -- 以下の照合の確かめは J-5 を基準にする
    w[1].grid = 'J-5'
    local ents = {
        { index = 1, name = '???', grid = 'H-8' },
        { index = 2, name = '???', grid = 'J-5' },
        { index = 3, name = '???', grid = nil },
    }
    local m = marks.match(w, ents, {
        grid_of = function (ent) return ent.grid end,
    })
    eq(#m, 1, 'only J-5 ???')
    eq(m[1].entity.index, 2, 'J-5 entity')
    -- 資料に座標が無い状態なら、どれにも付けない
    local w2 = { { role = 'examine', name = '???', require_grid = true, grid = nil } }
    eq(#marks.match(w2, ents, { grid_of = function (ent) return ent.grid end }), 0, '??? without grid marks none')

    -- 境目：基準が J-5 でも、隣の I-5 に落ちた相手は認める。離れた H-8 は付けない。
    local ents_edge = {
        { index = 1, name = '???', grid = 'I-5' },
        { index = 2, name = '???', grid = 'H-8' },
    }
    local m_edge = marks.match(w, ents_edge, { grid_of = function (ent) return ent.grid end })
    eq(#m_edge, 1, 'adjacent I-5 accepted')
    eq(m_edge[1].entity.index, 1, 'I-5 entity')

    -- ぴったりと隣が両方いるときは、ぴったりだけ。
    local ents_both = {
        { index = 1, name = '???', grid = 'I-5' },
        { index = 2, name = '???', grid = 'J-5' },
    }
    local m_both = marks.match(w, ents_both, { grid_of = function (ent) return ent.grid end })
    eq(#m_both, 1, 'exact preferred over adjacent')
    eq(m_both[1].entity.index, 2, 'prefer J-5')

    -- 斜め隣（I-4）も境目の角用に認める。2マス離れ（H-5）は付けない。
    local ents_diag = {
        { index = 1, name = '???', grid = 'I-4' },
        { index = 2, name = '???', grid = 'H-5' },
    }
    local m_diag = marks.match(w, ents_diag, { grid_of = function (ent) return ent.grid end })
    eq(#m_diag, 1, 'diagonal I-4 accepted, H-5 not')
    eq(m_diag[1].entity.index, 1, 'I-4 entity')

    eq(marks.grid_dist('I-5', 'J-5'), 1, 'dist I-5 J-5')
    eq(marks.grid_dist('J-5', 'J-5'), 0, 'dist same')
    eq(marks.grid_dist('H-5', 'J-5'), 2, 'dist H-5 J-5')
    eq(marks.grid_dist('I-4', 'J-5'), 1, 'dist diagonal')
    check(marks.near_grid('I-5', 'J-5'), 'near I-5')
    check(not marks.near_grid('H-8', 'J-5'), 'not near H-8')
end

-- 同名 NPC（Naji）は、大工房の J-8 が合う相手だけ（利用者確認）
P:set_state('quest.bastok.003', 'not_accepted')
P:set_state('mission.bastok.001', 'accepted')
P:set_current_step('mission.bastok.001', 'mission.bastok.001#g03')
do
    -- アビセア-コンシュタット（15）の Naji は別のゾーンなので数えない（0.1.97〜）
    local w = {}
    for _, x in ipairs(wanted_named(marks.wanted(D, P), 'Naji', 'talk')) do
        if x.zone_id ~= 15 then w[#w + 1] = x end
    end
    check(#w >= 1, 'naji wanted: ' .. tostring(#w))
    for _, x in ipairs(w) do
        check(x.require_grid, 'same_name requires grid')
        eq(x.grid, 'J-8', 'naji grid')
    end
    local ents = {
        { index = 1, name = 'Naji', grid = 'H-8' },
        { index = 2, name = 'Naji', grid = 'J-8' },
        { index = 3, name = 'Naji', grid = nil },
    }
    local m = marks.match(w, ents, { grid_of = function (ent) return ent.grid end })
    eq(#m, 1, 'only J-8 Naji')
    eq(m[1].entity.index, 2, 'J-8 entity')
end

-- 動く相手は座標に頼らず、名前で付いてくる
do
    local w = {
        { role = 'guard', name = 'Rakoh Buuma', moves = true, require_grid = false, grid = 'G-8' },
    }
    local ents = {
        { index = 1, name = 'Rakoh Buuma', grid = 'A-1' },
        { index = 2, name = 'Mokyokyo', grid = 'G-8' },
    }
    local m = marks.match(w, ents, { grid_of = function (ent) return ent.grid end })
    eq(#m, 1, 'moving rakoh')
    eq(m[1].entity.index, 1, 'follows despite grid')
end

-- 完了したくり返しのクエストは、発生NPCにくり返しのアイコン（0.1.63〜）。本の [再] でも次の周回を始められる。
P:set_state('mission.bastok.001', 'not_accepted')
do
    local qid = 'quest.sandoria.001'
    P:set_state(qid, 'completed')
    check(P:repeat_mark(qid), 'repeat_mark still recorded for the book')
    local function icons_of(name)
        local out = {}
        for _, w in ipairs(marks.wanted(D, P)) do
            if w.name == name and w.quest_id == qid then out[#out + 1] = w.icon end
        end
        return out
    end
    local ic = icons_of('Parvipon')
    eq(#ic, 1, 'completed repeatable: one mark at start npc')
    eq(ic[1], 'repeat', 'repeat icon when completed')
    -- 新しい周回を始めたら話す相手（進行中か目標達成）
    local rc = P:start_cycle(qid, true)
    check(rc.ok, 'start cycle')
    eq(P:state(qid), 'accepted', 'cycle accepted')
    eq(#wanted_named(marks.wanted(D, P), 'Parvipon', 'talk'), 1, 'talk while accepted')
    local ic2 = icons_of('Parvipon')
    check(ic2[1] == 'progress' or ic2[1] == 'complete', 'progress/complete while accepted: ' .. tostring(ic2[1]))
    P:set_state(qid, 'completed')
    eq(icons_of('Parvipon')[1], 'repeat', 'repeat again after completing')
end

-- 同じ相手がガードかつ話す相手のときは、話すほうが優先（役割の表示）
do
    local w = {
        { role = 'guard', name = 'Ambrotien' },
        { role = 'talk', name = 'Ambrotien', quest_id = 'mission.sandoria.001' },
    }
    local m = marks.match(w, { { index = 7, name = 'Ambrotien' } }, {})
    eq(#m, 1, 'one mark')
    eq(m[1].role, 'talk', 'talk over guard')
    eq(#m[1].wanted, 2, 'both kept')
end

-- 投影の計算（単位行列なら原点は画面の中央、カメラの後ろは出さない）
do
    local ident = { 1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1 }
    local vp = { x = 0, y = 0, w = 200, h = 100 }
    local r = project.screen(0, 0, 0, ident, ident, vp)
    check(r, 'projected')
    check(r.visible, 'visible at origin')
    eq(r.x, 100, 'center x')
    eq(r.y, 50, 'center y')
    -- x=1 は右端
    local right = project.screen(1, 0, 0, ident, ident, vp)
    eq(right.x, 200, 'right edge')
    -- 画面外
    local off = project.screen(2, 0, 0, ident, ident, vp)
    check(off and not off.visible, 'off screen')
    -- w<=0 はカメラの後ろ
    local back = { 1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,-1 }
    local behind = project.screen(0, 0, 0, back, nil, vp)
    check(behind and behind.behind and not behind.visible, 'behind camera')
end

-- 設定：目印は初期オン、以前の予約 false はオンに上げる（0.1.59〜は4つのスイッチへ移す）
do
    local d = settings.defaults()
    eq(d.marks.show_icons, true, 'default on')
    eq(d.marks.enabled, nil, 'no old enabled key')
    local merged = settings.merge({ settings_schema = 1, marks = { enabled = false } })
    eq(merged.marks.show_icons, true, 'reserved false becomes on')
    eq(merged.marks.enabled, nil, 'old enabled dropped')
    eq(merged.marks.introduced, 1, 'introduced set')
    local kept = settings.merge({ settings_schema = 1, marks = { enabled = false, introduced = 1 } })
    eq(kept.marks.show_icons, false, 'user off is kept')
    eq(settings.marks_active(kept), false, 'user off: nothing active')
    eq(d.marks.placement, 'above', 'default placement')
    local left = settings.merge({ settings_schema = 1, marks = { enabled = true, introduced = 1, placement = 'left' } })
    eq(left.marks.placement, 'left', 'left kept')
    local named = settings.merge({ settings_schema = 1, marks = { placement = 'above_name', introduced = 1 } })
    eq(named.marks.placement, 'above_name', 'above_name kept')
    local bad = settings.merge({ settings_schema = 1, marks = { placement = 'sideways', introduced = 1 } })
    eq(bad.marks.placement, 'above', 'bad placement becomes above')
    -- 種類ごとの位置。古い保存は共通の位置を引き継ぐ
    eq(left.marks.placement_talk, 'left', 'talk inherits left')
    eq(left.marks.placement_hunt, 'left', 'hunt inherits left')
    eq(left.marks.placement_examine, 'left', 'examine inherits left')
    eq(left.marks.placement_guard, 'left', 'guard inherits left')
    eq(d.marks.placement_examine, 'above', 'default examine above')
    eq(settings.placement_for(left.marks, 'examine'), 'left', 'placement_for inherits')
    local mixed = settings.merge({
        settings_schema = 1,
        marks = { placement = 'left', placement_examine = 'above_name', introduced = 1 },
    })
    eq(mixed.marks.placement_talk, 'left', 'mixed talk stays left')
    eq(mixed.marks.placement_examine, 'above_name', 'mixed examine kept')
    eq(settings.placement_for(mixed.marks, 'examine'), 'above_name', 'placement_for examine')
    eq(settings.placement_for(mixed.marks, 'hunt'), 'left', 'placement_for hunt fallback')
    local bad_role = settings.merge({
        settings_schema = 1,
        marks = { placement = 'left', placement_talk = 'sideways', introduced = 1 },
    })
    eq(bad_role.marks.placement_talk, 'left', 'bad role inherits common')
    eq(d.marks.show_object_names, true, 'default show object names')
    eq(left.marks.show_object_names, true, 'old save shows object names')
    local qoff = settings.merge({
        settings_schema = 1,
        marks = { enabled = true, introduced = 1, show_question = false },
    })
    eq(qoff.marks.show_object_names, false, 'old show_question off migrates')
    eq(qoff.marks.show_question, nil, 'old show_question dropped')
    local ooff = settings.merge({
        settings_schema = 1,
        marks = { enabled = true, introduced = 1, show_objects = false },
    })
    eq(ooff.marks.show_object_names, false, 'old show_objects off migrates')
    eq(ooff.marks.show_objects, nil, 'old show_objects dropped')
    eq(ooff.marks.show_icons, true, 'icons stay on')
    -- クエスト名の表示。新しい初期は出す。古い「右にクエスト名」から引き継ぐ。
    eq(d.marks.show_quest_name, true, 'default show quest name')
    eq(d.marks.icon_size, 28, 'default icon size')
    eq(settings.merge({ marks = { icon_size = 8 } }).marks.icon_size, 16, 'icon min 16')
    eq(settings.merge({ marks = { icon_size = 99 } }).marks.icon_size, 64, 'icon max 64')
    eq(settings.merge({ marks = { icon_size = 40 } }).marks.icon_size, 40, 'icon kept')
    local fresh = settings.merge({})
    eq(fresh.marks.show_quest_name, true, 'new save shows quest name')
    local from_name = settings.merge({
        settings_schema = 1,
        marks = { placement_examine = 'above_name', introduced = 1 },
    })
    eq(from_name.marks.show_quest_name, true, 'above_name migrates to show')
    local from_above = settings.merge({
        settings_schema = 1,
        marks = { placement = 'above', introduced = 1 },
    })
    eq(from_above.marks.show_quest_name, false, 'old mark-only stays hidden')
    local explicit = settings.merge({
        settings_schema = 1,
        marks = { show_quest_name = false, placement_examine = 'above_name', introduced = 1 },
    })
    eq(explicit.marks.show_quest_name, false, 'explicit off is kept')
    local on = settings.merge({
        settings_schema = 1,
        marks = { show_quest_name = true, placement = 'above', introduced = 1 },
    })
    eq(on.marks.show_quest_name, true, 'explicit on is kept')
end

-- 未受注で、今の手順が「品を用意する」（相手なし）でも発生NPCに印を出す
do
    P:set_state('quest.bastok.002', 'not_accepted')
    P:set_current_step('quest.bastok.002', 'quest.bastok.002#g02')
    local step = P:current_step('quest.bastok.002')
    eq(step and step.target, nil, 'gather step has no target')
    local w = wanted_named(marks.wanted(D, P), 'Aquillina', 'talk')
    eq(#w, 1, 'start npc marked while gather is current')
    P:set_current_step('quest.bastok.002', 'quest.bastok.002#g01')
end

-- ??? は名前ではなく本体の位置に印を出す。全角の？？？も同じ。
do
    check(marks.on_body('???'), '??? is on body')
    check(marks.on_body('？？？'), 'fullwidth ??? is on body')
    check(marks.on_body('  ???  '), 'trimmed ??? is on body')
    check(not marks.on_body('Horatius'), 'npc is on name')
    check(not marks.on_body('Horatius', 'talk'), 'talk stays on name')
    check(marks.on_body('Signpost', 'examine'), 'examine object is on body')
    check(not marks.on_body('Signpost'), 'signpost without role is not on body')
    check(not marks.on_body(nil), 'nil is not on body')
    eq(marks.norm_name('？？？'), '???', 'fullwidth normalizes')
    check(marks.same_name('???', '？？？'), 'fullwidth matches ascii')
end

do
    local matched = {
        { name = 'Horatius', role = 'talk', entity = { index = 1, name = 'Horatius' } },
        { name = '???', role = 'examine', entity = { index = 2, name = '???' } },
        { name = '？？？', role = 'examine', entity = { index = 3, name = '？？？' } },
        { name = 'Signpost', role = 'examine', entity = { index = 4, name = 'Signpost' } },
    }
    local on_name, on_body = marks.split_for_draw(matched)
    eq(#on_name, 1, 'npc on name')
    eq(#on_body, 3, 'examine objects on body')
    eq(on_name[1].name, 'Horatius', 'npc on name')
    eq(on_body[1].name, '???', '??? on body')
    eq(on_body[2].entity.name, '？？？', 'fullwidth on body')
    eq(on_body[3].name, 'Signpost', 'signpost on body')
end

-- 照合：全角の名前でも J-5 の ??? に付く
do
    P:set_state('quest.bastok.003', 'accepted')
    P:set_current_step('quest.bastok.003', 'quest.bastok.003#g02')
    local all = marks.wanted(D, P)
    local n_start = check_qqq_starts(all, 'fullwidth')
    eq(#wanted_named(all, '???'), 1 + shown_qqq_start_marks() + step1_qqq_marks(all), '??? wanted = this step + ??? starts + step-1 ??? (fullwidth)')
    local w = {}
    for _, x in ipairs(wanted_named(all, '???', 'examine')) do
        if x.quest_id == 'quest.bastok.003' then w[#w + 1] = x end
    end
    eq(#w, 1, '??? wanted for fullwidth match')
    local ents = {
        { index = 1, name = '？？？', grid = 'J-5' },
        { index = 2, name = '？？？', grid = 'H-8' },
    }
    local m = marks.match(w, ents, { grid_of = function (ent) return ent.grid end })
    eq(#m, 1, 'only J-5 fullwidth ???')
    eq(m[1].entity.index, 1, 'J-5 index')
end

-- 描画：??? は attach せず本体位置、NPC は attach
do
    local marks_ui = require('src.ui.marks')
    local attached, cleared, world_calls = {}, 0, {}
    local shapes = {}
    local ui = {
        settings = { marks = { enabled = true, placement = 'above' }, font_scale = 1, language = 'ja' },
        state = { ready = true },
        player = { zone_id = 191 },
        data = D,
        progress = P,
        platform = {
            visible_entities = function ()
                return {
                    { index = 10, name = 'Horatius', x = 1, y = 2, z = 3 },
                    { index = 11, name = '???', x = 50, y = 60, z = 4, grid = 'J-5' },
                }
            end,
            attach_available = function () return true end,
            set_name_marks = function (items)
                attached = items
                return true
            end,
            clear_name_marks = function () cleared = cleared + 1 end,
            attach_kind = function () return 'image' end,
            entity_world_screen = function (ent)
                world_calls[#world_calls + 1] = ent.index
                if ent.name == '???' then
                    return 200, 100, 'to_screen'
                end
                return nil
            end,
        },
        imgui = {
            GetBackgroundDrawList = function ()
                return {
                    AddCircleFilled = function () end,
                    AddCircle = function () end,
                    AddConvexPolyFilled = function () end,
                    AddPolyline = function () end,
                }
            end,
        },
    }
    -- Horatius is in zone 235, not 191, so only ??? should match in zone 191
    P:set_state('quest.bastok.003', 'accepted')
    P:set_current_step('quest.bastok.003', 'quest.bastok.003#g02')
    local info = marks_ui.draw(ui)
    eq(info.matched, 1, 'only ??? matched in wadi')
    eq(#attached, 0, '??? is not attached to a name')
    eq(info.body, 1, 'one body mark')
    eq(info.drawn, 1, 'drawn once')
    check(info.how == 'body' or (info.how or ''):find('body', 1, true), 'how mentions body: ' .. tostring(info.how))
    eq(#world_calls, 1, 'used world screen')
    eq(world_calls[1], 11, 'world screen on ???')
end


-- 名前の後ろの終端ゴミ、疑問符だけの名前も ??? と同じ
do
    check(marks.norm_name('???\0abc') == '???', 'null-padded ???')
    check(marks.same_name('???\0', '？？？'), 'null-padded matches fullwidth')
    check(marks.on_body('???\0'), 'null-padded is on body')
    check(marks.on_body('????'), 'four questions is on body')
    check(not marks.on_body('?'), 'one question is not on body')
    check(not marks.on_body('Horatius?'), 'name with question is not on body')
end

-- 描画：place が使えるときは、??? を公式の本体座標に置く（ImGui も attach もしない）
do
    local marks_ui = require('src.ui.marks')
    local attached, placed, world_calls, cleared_world = {}, {}, {}, 0
    local ui = {
        settings = { marks = { enabled = true, placement = 'above' }, font_scale = 1, language = 'ja' },
        state = { ready = true },
        player = { zone_id = 191 },
        data = D,
        progress = P,
        platform = {
            visible_entities = function ()
                return {
                    { index = 11, name = '???', x = 50, y = 60, z = 4, model_size = 2.5, grid = 'J-5' },
                }
            end,
            attach_available = function () return true end,
            set_name_marks = function (items)
                attached = items
                return true
            end,
            clear_name_marks = function () end,
            attach_kind = function () return 'image' end,
            place_available = function () return true end,
            set_world_marks = function (items)
                placed = items
                return true, #items
            end,
            place_kind = function () return 'image' end,
            clear_world_marks = function () cleared_world = cleared_world + 1 end,
            game_entity = function (index)
                if index == 11 then
                    return { x = 51, y = 61, z = 5, model_size = 2.5 }
                end
            end,
            entity_world_screen = function (ent)
                world_calls[#world_calls + 1] = ent.index
                return 200, 100, 'to_screen'
            end,
        },
        imgui = {
            GetBackgroundDrawList = function ()
                return {
                    AddCircleFilled = function () end,
                    AddCircle = function () end,
                    AddConvexPolyFilled = function () end,
                    AddPolyline = function () end,
                }
            end,
        },
    }
    P:set_state('quest.bastok.003', 'accepted')
    P:set_current_step('quest.bastok.003', 'quest.bastok.003#g02')
    local info = marks_ui.draw(ui)
    eq(info.matched, 1, 'place path: matched ???')
    eq(#attached, 0, 'place path: not attached to a name')
    eq(#placed, 1, 'place path: one world mark')
    eq(placed[1].x, 51, 'place uses official entity x')
    eq(placed[1].y, 61, 'place uses official entity y')
    eq(placed[1].z, 5, 'place uses official entity z')
    eq(placed[1].up, 2.5, 'place uses official height')
    eq(placed[1].role, 'examine', 'place role examine')
    eq(placed[1].index, 11, 'place index')
    eq(info.place, 1, 'place drawn')
    eq(info.body, 1, 'body count includes place')
    eq(info.drawn, 1, 'drawn once')
    check((info.how or ''):find('place', 1, true), 'how mentions place: ' .. tostring(info.how))
    eq(#world_calls, 0, 'place path does not fall back to imgui screen')
    check(info.detail and info.detail:find('J-5', 1, true), 'detail has grid: ' .. tostring(info.detail))
    -- 位置の調整と、頭上のクエスト名・名前の大きさが、そのまま渡る
    -- 0.1.46：調べるオブジェクトは obj_ の値（アイコンと名前はいっしょ、クエスト名は別）。そのほかの値は使わない
    ui.settings.marks.mark_dx, ui.settings.marks.mark_dy = 100, 100
    ui.settings.marks.label_dx, ui.settings.marks.label_dy = 100, 100
    ui.settings.marks.obj_mark_dx, ui.settings.marks.obj_mark_dy = 6, -10
    ui.settings.marks.obj_label_dx, ui.settings.marks.obj_label_dy = -8, 4
    ui.settings.fonts = { overhead_quest = 1.2, overhead_name = 1.4 }
    marks_ui.draw(ui)
    eq(placed[1].mark_dx, 6, 'mark_dx passed'); eq(placed[1].mark_dy, -10, 'mark_dy passed')
    eq(placed[1].name_dx, 6, 'name moves with icon x'); eq(placed[1].name_dy, -10, 'name moves with icon y')
    eq(placed[1].label_dx, -8, 'label_dx passed'); eq(placed[1].label_dy, 4, 'label_dy passed')
    eq(placed[1].scale, 1.2, 'quest name scale'); eq(placed[1].under_scale, 1.4, 'name scale')
    -- 0.1.47：文字の色が渡る（グラデーションのときだけ終わりの色）
    eq(table.concat(placed[1].label_color, ','), '248,244,232', 'default quest color'); eq(placed[1].label_color2, nil, 'no gradient')
    ui.settings.marks.label_color = { 1, 2, 3 }
    ui.settings.marks.under_color, ui.settings.marks.under_grad, ui.settings.marks.under_color2 = { 4, 5, 6 }, true, { 7, 8, 9 }
    marks_ui.draw(ui)
    eq(table.concat(placed[1].label_color, ','), '1,2,3', 'quest color passed')
    eq(table.concat(placed[1].under_color, ','), '4,5,6', 'object color passed')
    eq(table.concat(placed[1].under_color2, ','), '7,8,9', 'object gradient end passed')
    ui.settings.marks.label_color, ui.settings.marks.under_color, ui.settings.marks.under_grad, ui.settings.marks.under_color2 = nil, nil, nil, nil
    for _, k in ipairs({ 'mark_dx', 'mark_dy', 'label_dx', 'label_dy', 'obj_mark_dx', 'obj_mark_dy', 'obj_label_dx', 'obj_label_dy' }) do
        ui.settings.marks[k] = nil
    end
    ui.settings.fonts = nil
    eq(placed[1].label, nil, 'place default has no quest name')
    eq(placed[1].under, '???', '??? caption under the mark')

    -- クエスト名を出すと、??? にも名前を渡す
    ui.settings.marks.show_quest_name = true
    placed, attached = {}, {}
    info = marks_ui.draw(ui)
    eq(#placed, 1, 'show quest name: one world mark')
    eq(placed[1].label, 'ダングルフの奇岩', 'quest name passed for ???')
    eq(#attached, 0, 'still not attached to a name')

    -- オフにするとクエスト名は出さない。対象の名前は残る。
    ui.settings.marks.show_quest_name = false
    placed = {}
    info = marks_ui.draw(ui)
    eq(placed[1].label, nil, 'hidden has no quest name')
    eq(placed[1].under, '???', 'still has ??? under the mark')

    -- アイコン・クエスト名・オブジェクト名を全部オフにすると、何も出さない
    ui.settings.marks.show_icons = false
    ui.settings.marks.show_object_names = false
    ui.settings.marks.show_quest_name = false
    placed, attached = {}, {}
    info = marks_ui.draw(ui)
    eq(#placed, 0, 'all off: none placed')
    eq(info.place or 0, 0, 'all off: place drawn 0')
    eq(#attached, 0, 'all off: not attached')
    eq(#world_calls, 0, 'all off: no imgui fallback')
    ui.settings.marks.show_icons = true
    ui.settings.marks.show_object_names = true
end


-- 調べる対象：名前が Signpost でも、画面の名前が ??? なら同じマスの本体に付ける
do
    P:set_state('quest.bastok.006', 'accepted')
    P:set_current_step('quest.bastok.006', 'quest.bastok.006#g02')
    local w = marks.wanted(D, P)
    local sign = nil
    for _, x in ipairs(w) do
        if x.name == 'Signpost' and x.role == 'examine' then sign = x break end
    end
    check(sign, 'Signpost wanted')
    eq(sign.grid, 'G-5', 'Signpost grid')
    -- 名前どおり
    local m = marks.match({ sign }, { { index = 1, name = 'Signpost', grid = 'G-5' } }, {})
    eq(#m, 1, 'named Signpost matches')
    eq(m[1].entity.index, 1, 'named entity')
    local on_name, on_body = marks.split_for_draw(m)
    eq(#on_body, 1, 'Signpost goes on body')
    eq(#on_name, 0, 'Signpost not on name')
    -- 名前が出ないとき、同じマスの ??? を候補に
    m = marks.match({ sign }, { { index = 8, name = '???', grid = 'G-5' } }, {})
    eq(#m, 1, 'nameless Signpost in grid matches')
    eq(m[1].entity.index, 8, '??? entity for Signpost')
    -- ぴったりがいれば隣は使わない
    m = marks.match({ sign }, {
        { index = 8, name = '???', grid = 'G-5' },
        { index = 9, name = '???', grid = 'H-5' },
    }, {})
    eq(#m, 1, 'exact grid only')
    eq(m[1].entity.index, 8, 'exact G-5')
    -- 名前がある相手がいれば、??? には付けない
    m = marks.match({ sign }, {
        { index = 1, name = 'Signpost', grid = 'G-5' },
        { index = 8, name = '???', grid = 'G-5' },
    }, {})
    eq(#m, 1, 'named wins over ???')
    eq(m[1].entity.name, 'Signpost', 'named entity preferred')
    P:set_state('quest.bastok.006', 'not_accepted')
end

-- ブリジッド：用語辞典どおり「ファッションチェック」は連続クエスト（I の続編が II）。杯は蝕世のミッションで別件
do
    local q1, q2, cup = D:quest('quest.bastok.011'), D:quest('quest.bastok.084'), D:quest('mission.tvr.003')
    check(q1 and q2 and cup, 'brygid quests loaded')
    local parents = marks.prereq_parents(D, q2)
    local has_i
    for _, id in ipairs(parents) do if id == 'quest.bastok.011' then has_i = true end end
    check(has_i, 'II lists Fashion Check as a completion prereq')
    eq(#marks.prereq_parents(D, cup), 0, 'Brygid Cup is not linked to the fashion chain in our prereq data')
    -- まだ I を受けていない：頭上は I と杯。II は出さない
    P:set_state('quest.bastok.011', 'not_accepted')
    P:set_state('quest.bastok.084', 'not_accepted')
    P:set_state('mission.tvr.003', 'not_accepted')
    local function brygid_of(list)
        return wanted_named(marks.in_zone(list, 235), 'Brygid', 'talk')
    end
    local w = marks.wanted(D, P)
    local b = brygid_of(w)
    local qids = {}
    for _, x in ipairs(b) do qids[x.quest_id] = x.icon end
    check(qids['quest.bastok.011'], 'I shown when not started: ' .. tostring(qids['quest.bastok.011']))
    check(qids['mission.tvr.003'], 'Cup shown independently: ' .. tostring(qids['mission.tvr.003']))
    check(not qids['quest.bastok.084'], 'II hidden until I is done')
    eq(qids['quest.bastok.011'], 'sub', 'I is an available sub quest')
    -- I を受注中：I と杯。II はまだ出さない
    P:set_state('quest.bastok.011', 'accepted')
    b = brygid_of(marks.wanted(D, P))
    qids = {}
    for _, x in ipairs(b) do qids[x.quest_id] = x.icon end
    check(qids['quest.bastok.011'] == 'progress' or qids['quest.bastok.011'] == 'complete', 'accepted I is in progress or complete')
    check(qids['mission.tvr.003'], 'Cup still shown while I is accepted')
    check(not qids['quest.bastok.084'], 'II hidden while I is accepted')
    -- I を完了：II（くり返し）と杯。完了した I は出さない
    P:set_state('quest.bastok.011', 'completed')
    b = brygid_of(marks.wanted(D, P))
    qids = {}
    for _, x in ipairs(b) do qids[x.quest_id] = x.icon end
    eq(qids['quest.bastok.084'], 'repeat', 'II shown as repeatable after I is done')
    check(qids['mission.tvr.003'], 'Cup still shown after I is done')
    check(not qids['quest.bastok.011'], 'completed I is hidden')
    -- 頭上：クエスト名は複数でも印は1つ
    local marks_ui = require('src.ui.marks')
    local attached = {}
    local ui = {
        settings = { marks = { enabled = true, show_icons = true, show_quest_name = true, placement = 'above' }, font_scale = 1, language = 'ja' },
        state = { ready = true },
        player = { zone_id = 235 },
        data = D,
        progress = P,
        platform = {
            visible_entities = function ()
                return { { index = 20, name = 'Brygid', x = 1, y = 2, z = 3 } }
            end,
            attach_available = function () return true end,
            set_name_marks = function (items) attached = items or {}; return true end,
            clear_name_marks = function () end,
            attach_kind = function () return 'image' end,
        },
        imgui = { GetBackgroundDrawList = function () return {} end },
    }
    marks_ui.draw(ui)
    local labs, icons = {}, 0
    for _, it in ipairs(attached) do
        if it.label then labs[#labs + 1] = it.label end
        if not it.no_icon then icons = icons + 1 end
    end
    eq(icons, 1, 'one status icon on Brygid')
    local has_ii, has_cup, has_i = false, false, false
    for _, lab in ipairs(labs) do
        if lab == 'ブリジッドのファッションチェックII' then has_ii = true end
        if lab == 'ブリジッド杯' then has_cup = true end
        if lab == 'ブリジッドのファッションチェック' then has_i = true end
    end
    check(has_ii, 'label for current fashion quest (II)')
    check(has_cup, 'label for independent Cup mission')
    check(not has_i, 'completed fashion I has no label')
    P:set_state('quest.bastok.011', 'not_accepted')
    P:set_state('quest.bastok.084', 'not_accepted')
    P:set_state('mission.tvr.003', 'not_accepted')
end

print('test_marks ok')
