-- 0.1.63: クエストの状態のアイコン（FF14 のジャーナルの分け方を参考にした自作の印）
require('harness')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local marks = require('src.core.marks')

local fs = posix_fs()
local D = data_mod.load(fs, ROOT .. '/data/')
eq(#D.errors, 0, 'data errors')
local P = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
P:reset({ server = 'catseye', name = 'Test' })

-- 優先の順（小さいほど先）
local order = { 'complete', 'progress', 'hunt', 'blocked', 'main', 'sub', 'repeat', 'unavailable', 'guard', 'fame' }
for i = 2, #order do
    check(marks.ICON_RANK[order[i - 1]] < marks.ICON_RANK[order[i]], 'rank ' .. order[i - 1] .. ' < ' .. order[i])
end
eq(#marks.ICONS, 10, 'ten icons (0.1.69: fame)')

-- 未受注：ミッションは次のものだけ main。前提が済んでいないものは受けられない。
-- 前提が済んでいる（または資料に無い）後のミッションは sub（0.1.196〜）
local nm = marks.next_missions(D, P)
local mains, later_un, later_sub = 0, 0, 0
for _, q in ipairs(D.quests) do
    if q.kind == 'mission' then
        local ic = marks.quest_icon(D, P, q, { next_missions = nm })
        if ic == 'main' then mains = mains + 1
        elseif ic == 'unavailable' then
            later_un = later_un + 1
            check(marks.prereq_unmet(D, P, q), 'unavailable mission has unmet prereq: ' .. q.id)
        elseif ic == 'sub' then later_sub = later_sub + 1
        end
    end
end
check(mains >= 3, 'each nation has a next mission (' .. mains .. ')')
check(later_un > mains, 'missions with unmet prereqs stay unavailable')
check(later_sub > 0, 'later missions with met or unknown prereqs are sub')
local m1 = D:quest('mission.sandoria.001')
eq(marks.quest_icon(D, P, m1), 'main', 'first sandoria mission is main')

-- 前提のクエスト：bastok.006 は bastok.005 が済むまで受けられない
local q5, q6 = D:quest('quest.bastok.005'), D:quest('quest.bastok.006')
eq(marks.quest_icon(D, P, q6), 'unavailable', 'needs the earlier quest')
P:set_state(q5.id, 'completed')
check(marks.quest_icon(D, P, q6) ~= 'unavailable', 'available after the earlier quest')
P:set_state(q5.id, 'not_accepted')
-- 打ち消しの理由（〜は不可）は前提にしない
local fake = { id = 'x', lock_reasons = { { type = 'quest', text_ja = 'クエスト「' .. q5.name_ja_ref .. '」が進行中は不可' } } }
eq(#marks.prereq_ids(D, fake), 0, 'negative reason ignored')
local fake2 = { id = 'y', lock_reasons = { { type = 'quest', text_ja = 'ミッション「' .. (m1.name_ja_ref or '') .. '」をクリア' } } }
eq(#marks.prereq_ids(D, fake2), 1, 'mission prereq read')
local nparsed = 0
for _, q in ipairs(D.quests) do if #marks.prereq_ids(D, q) > 0 then nparsed = nparsed + 1 end end
check(nparsed >= 5, 'prereqs found in data (' .. nparsed .. ')')

-- 未受注のくり返し／ふつう
local rq, sq
for _, q in ipairs(D.quests) do
    if q.kind ~= 'mission' and #marks.prereq_ids(D, q) == 0 then
        if q.repeatable == 'yes' and not rq then rq = q end
        if q.repeatable ~= 'yes' and not sq then sq = q end
    end
end
eq(marks.quest_icon(D, P, rq), 'repeat', 'repeatable not accepted')
eq(marks.quest_icon(D, P, sq), 'sub', 'plain quest not accepted')
P:set_state(sq.id, 'completed')
eq(marks.quest_icon(D, P, sq), nil, 'completed plain quest: no icon')
P:set_state(rq.id, 'completed')
eq(marks.quest_icon(D, P, rq), 'repeat', 'completed repeatable: repeat')
P:set_state(sq.id, 'not_accepted'); P:set_state(rq.id, 'not_accepted')
-- 0.1.189〜：完了で手順が全部チェック済みになり、戻しても残るので、記録ごと消して最初の形に戻す
P.doc.quests[sq.id] = nil; P.doc.quests[rq.id] = nil

-- 受注中：途中は進行中、最後の手順は目標達成
local qa
for _, q in ipairs(D.quests) do
    if q.kind ~= 'mission' and q.steps and #q.steps >= 3 then qa = q; break end
end
P:set_state(qa.id, 'accepted')
local first = P:current_step(qa.id)
check(first and not D:is_last_step(first), 'first step is not last')
eq(marks.quest_icon(D, P, qa), 'progress', 'accepted: progress')
local last
for _, st in ipairs(qa.steps) do if D:is_last_step(st) then last = st end end
check(last ~= nil, 'has a last step')
P:set_current_step(qa.id, last.id)
eq(marks.quest_icon(D, P, qa), 'complete', 'last step: complete')
P:set_state(qa.id, 'not_accepted')

-- 進められない：必要な品の所持数が読めて足りないときだけ
local step_need = { needs = { { item_id = 640, count = 2 } } }
check(not marks.step_blocked(step_need, nil), 'unknown inventory: not blocked')
check(not marks.step_blocked(step_need, function () return nil end), 'nil count: not blocked')
check(marks.step_blocked(step_need, function () return 1 end), 'short: blocked')
check(not marks.step_blocked(step_need, function () return 2 end), 'enough: not blocked')

-- 相手の印：討伐はいつも討伐、ガードはガード、ほかは状態のアイコン
P:set_state('mission.sandoria.001', 'not_accepted')
local seen = {}
for _, w in ipairs(marks.wanted(D, P)) do
    seen[w.icon or '?'] = true
    if w.role == 'hunt' then eq(w.icon, 'hunt', 'hunt keeps its mark') end
    if w.role == 'guard' then check(w.icon == 'guard' or w.icon == 'main', 'guard: shield or mission') end
    check(w.icon ~= nil, 'every wanted has an icon')
end
local ks = {}; for k in pairs(seen) do ks[#ks + 1] = k end; table.sort(ks)
check(seen.sub and seen['repeat'] and seen.main and seen.unavailable, 'sub/repeat/main(guard)/unavailable on targets: ' .. table.concat(ks, ','))

-- 同じ相手：目標達成が先、受けられないは他があれば出さない
local m = marks.match({
    { role = 'talk', icon = 'unavailable', name = 'Foo', quest_id = 'a' },
    { role = 'talk', icon = 'sub', name = 'Foo', quest_id = 'b' },
    { role = 'talk', icon = 'complete', name = 'Foo', quest_id = 'c' },
    { role = 'guard', icon = 'guard', name = 'Foo' },
}, { { index = 1, name = 'Foo' } }, {})
eq(#m, 1, 'one entity')
eq(m[1].icon, 'complete', 'complete first')
eq(#m[1].wanted, 3, 'unavailable dropped')
local m2 = marks.match({
    { role = 'talk', icon = 'unavailable', name = 'Bar', quest_id = 'a' },
    { role = 'talk', icon = 'unavailable', name = 'Bar', quest_id = 'b' },
}, { { index = 2, name = 'Bar' } }, {})
eq(#m2[1].wanted, 1, 'only one unavailable')

-- 絵はある（自作の PNG）。見た目の対応
for _, ic in ipairs({ 'main', 'sub', 'unavailable', 'progress', 'blocked', 'complete', 'repeat', 'hunt', 'guard' }) do
    local f = io.open(ROOT .. '/assets/marks/example/' .. ic .. '.png', 'rb')
    check(f ~= nil, 'png ' .. ic)
    if f then f:close() end
end
local ext = require('src.platform.vanacore_ext')
check(ext.mark_file('complete'):find('complete.png', 1, true) ~= nil, 'ext knows complete.png')
check(ext.mark_file('main'):find('main.png', 1, true) ~= nil, 'ext knows main.png')

-- ImGui の控えの描き方：どのアイコンでも落ちない
local calls = 0
local dl = setmetatable({}, { __index = function () return function () calls = calls + 1 end end })
local um = require('src.ui.marks')
for _, ic in ipairs(marks.ICONS) do um.draw_shape(dl, ic, 10, 10, 7) end
check(calls > 20, 'shapes drawn')

-- 0.1.65: 読めた値（ジョブ・レベル・所属国・ランク）で受けられないを決める。読めない値では決めない
do
    local lq = { id = 'lv1', lock_reasons = { { type = 'condition', text_ja = 'モンクLv40以上で話しかける' } } }
    local r = marks.level_reqs(lq)
    eq(#r, 1, 'job level req'); eq(r[1].job, 2, 'monk'); eq(r[1].level, 40, 'lv40')
    local lq2 = { id = 'lv2', lock_reasons = { { type = 'quest', text_ja = '前クエスト「x」クリア後、Lv50以上の暗黒騎士で話す' } } }
    r = marks.level_reqs(lq2); eq(#r, 1, 'lv before job'); eq(r[1].job, 8, 'drk'); eq(r[1].level, 50, 'lv50')
    local lq3 = { id = 'lv3', lock_reasons = { { type = 'fame', text_ja = '名声ランク4以上、レベル10以上' }, { type = 'condition', text_ja = 'Lv5以上' } } }
    r = marks.level_reqs(lq3); eq(#r, 2, 'plain levels'); eq(r[1].job, nil, 'any job')
    local lq4 = { id = 'lv4', lock_reasons = { { type = 'condition', text_ja = 'シーフAFクエスト進行中は不可' } } }
    eq(#marks.level_reqs(lq4), 0, 'negative text ignored')
    -- 判定
    check(not marks.reqs_unmet(lq, nil), 'unknown status: never unmet')
    check(not marks.reqs_unmet(lq, {}), 'empty status: never unmet')
    check(marks.reqs_unmet(lq, { main_job = 1, main_job_level = 75 }), 'wrong job')
    check(marks.reqs_unmet(lq, { main_job = 2, main_job_level = 30 }), 'monk too low')
    check(not marks.reqs_unmet(lq, { main_job = 2, main_job_level = 40 }), 'monk 40 ok')
    check(not marks.reqs_unmet(lq, { main_job_level = 40 }), 'job unknown: not judged')
    check(marks.reqs_unmet(lq3, { main_job = 1, main_job_level = 4 }), 'lv4 < 5')
    check(not marks.reqs_unmet(lq3, { main_job = 1, main_job_level = 10 }), 'lv10 ok (fame not judged)')
    local found = 0
    for _, q in ipairs(D.quests) do if #marks.level_reqs(q) > 0 then found = found + 1 end end
    check(found >= 20, 'level reqs in data (' .. found .. ')')
    -- ミッション：ランクと所属国
    local s21 = nil
    for _, q in ipairs(D.quests) do if q.mission_no == 'SM2-1' then s21 = q end end
    eq(marks.mission_rank(s21), 2, 'SM2-1 rank 2')
    check(marks.reqs_unmet(s21, { main_job = 1, main_job_level = 10, nation = 0, rank = 1 }), 'rank 1 < 2')
    check(not marks.reqs_unmet(s21, { main_job = 1, main_job_level = 10, nation = 0, rank = 2 }), 'rank 2 ok')
    check(not marks.reqs_unmet(s21, { main_job = 1, main_job_level = 10, nation = 0 }), 'rank unknown: not judged')
    check(marks.reqs_unmet(s21, { main_job = 1, main_job_level = 10, nation = 1, rank = 5 }), 'other nation')
    check(not marks.reqs_unmet(s21, { main_job = 1, main_job_level = 10, rank = 1 }), 'nation unknown: not judged')
    -- アイコン：バストゥークのランク1なら、サンドリアの最初のミッションは受けられない、バストゥークのは main
    local P2 = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
    P2:reset({ server = 'catseye', name = 'Test2' })
    local bst = { main_job = 1, main_job_level = 5, nation = 1, rank = 1 }
    eq(marks.quest_icon(D, P2, D:quest('mission.sandoria.001'), { status = bst }), 'unavailable', 'other nation mission')
    eq(marks.quest_icon(D, P2, D:quest('mission.bastok.001'), { status = bst }), 'main', 'own nation next mission')
    eq(marks.quest_icon(D, P2, D:quest('mission.sandoria.001')), 'main', 'unknown status: main')
    -- ジラート（0.1.118〜）：国のミッションでないので、所属国やランクでは止めない。並びは order
    local z1, z2 = D:quest('mission.zilart.001'), D:quest('mission.zilart.002')
    check(z1 and z2, 'zilart missions')
    eq(marks.mission_rank(z1), 6, 'zilart ZM1: rank 6 needed (0.1.119)')
    eq(marks.mission_rank(z2), nil, 'zilart ZM2: no rank')
    check(marks.reqs_unmet(z1, bst), 'zilart ZM1: rank 1 < 6')
    local bst6 = { main_job = 1, main_job_level = 75, nation = 1, rank = 6 }
    check(not marks.reqs_unmet(z1, bst6), 'zilart ZM1: rank 6 ok, any nation')
    check(not marks.reqs_unmet(z1, { main_job = 1, main_job_level = 75, nation = 1 }), 'zilart: rank unknown not judged')
    check(not marks.reqs_unmet(z1, { main_job = 1, main_job_level = 75, rank = 6 }), 'zilart: nation unknown ok')
    eq(marks.quest_icon(D, P2, z1, { status = bst }), 'unavailable', 'zilart ZM1 with rank 1')
    eq(marks.quest_icon(D, P2, z1, { status = bst6 }), 'main', 'zilart first mission is main')
    eq(marks.quest_icon(D, P2, z2, { status = bst6 }), 'sub', 'zilart later mission is not main (no prereq in data)')
    P2:set_state('mission.zilart.001', 'completed')
    eq(marks.quest_icon(D, P2, z2, { status = bst }), 'main', 'zilart next by order')
    P2:set_state('mission.zilart.002', 'completed')
    eq(marks.quest_icon(D, P2, D:quest('mission.zilart.019'), { status = bst }), 'main', 'ZM3 after ZM2')
    P2:set_state('mission.zilart.002', 'not_accepted')
    P2:set_state('mission.zilart.001', 'not_accepted')
    -- プロマシア（0.1.119〜）：ランクの条件なし。並びは order（ふたつの道は両編のあと、導入は最後）
    local p1, p11, p12, p28 = D:quest('mission.promathia.001'), D:quest('mission.promathia.011'), D:quest('mission.promathia.012'), D:quest('mission.promathia.028')
    check(p1 and p11 and p12 and p28, 'promathia missions')
    eq(marks.mission_rank(p1), nil, 'promathia PM1-1: no rank')
    check(not marks.reqs_unmet(p1, bst), 'promathia: rank 1 ok')
    eq(marks.quest_icon(D, P2, p1, { status = bst }), 'main', 'promathia first mission is main')
    eq(marks.quest_icon(D, P2, p28, { status = bst }), 'sub', 'promathia intro is not main')
    check(tonumber(p12.order) < tonumber(p11.order), 'Emerald Waters before The Road Forks')
    -- アトルガン（0.1.120〜）：ランクの条件なし。並びは order
    local a1, a2, a48 = D:quest('mission.aht_urhgan.001'), D:quest('mission.aht_urhgan.002'), D:quest('mission.aht_urhgan.048')
    check(a1 and a2 and a48, 'aht_urhgan missions')
    eq(marks.mission_rank(a1), nil, 'ToAU1: no rank')
    check(not marks.reqs_unmet(a1, bst), 'ToAU1: rank 1 ok')
    eq(marks.quest_icon(D, P2, a1, { status = bst }), 'unavailable', 'ToAU1 needs the jeuno quest')
    P2:set_state('quest.jeuno.053', 'completed')
    eq(marks.quest_icon(D, P2, a1, { status = bst }), 'main', 'ToAU first mission is main')
    eq(marks.quest_icon(D, P2, a2, { status = bst }), 'unavailable', 'ToAU later mission')
    P2:set_state('mission.aht_urhgan.001', 'completed')
    eq(marks.quest_icon(D, P2, a2, { status = bst }), 'main', 'ToAU next by order')
    P2:set_state('mission.aht_urhgan.001', 'not_accepted')
    P2:set_state('quest.jeuno.053', 'not_accepted')
    check(tonumber(a48.order) == 48, 'ToAU48 order')
    -- アルタナ（0.1.121〜）：ランクの条件なし。並びは order
    local w1, w2, w54 = D:quest('mission.altana.001'), D:quest('mission.altana.002'), D:quest('mission.altana.054')
    check(w1 and w2 and w54, 'altana missions')
    eq(marks.mission_rank(w1), nil, 'WotG1: no rank')
    eq(marks.quest_icon(D, P2, w1, { status = bst }), 'main', 'WotG first mission is main')
    eq(marks.quest_icon(D, P2, w2, { status = bst }), 'unavailable', 'WotG later mission')
    P2:set_state('mission.altana.001', 'completed')
    eq(marks.quest_icon(D, P2, w2, { status = bst }), 'main', 'WotG next by order')
    P2:set_state('mission.altana.001', 'not_accepted')
    check(tonumber(w54.order) == 54, 'WotG54 order')
    -- 石の見る夢・モグ祭り（0.1.122〜）：ランクの条件なし。始めるには は最後、＜完＞ は最後の節の次
    local st20 = { main_job = 1, main_job_level = 20, nation = 1, rank = 1 }
    local c1, c2, c13 = D:quest('mission.acp.001'), D:quest('mission.acp.002'), D:quest('mission.acp.013')
    check(c1 and c2 and c13, 'acp missions')
    eq(marks.mission_rank(c2), nil, 'ACP1: no rank')
    eq(marks.quest_icon(D, P2, c2, { status = st20 }), 'main', 'ACP1 is main')
    eq(marks.quest_icon(D, P2, c1, { status = st20 }), 'sub', 'ACP intro is not main')
    check(marks.reqs_unmet(c2, { main_job = 1, main_job_level = 5 }), 'ACP1 needs Lv10')
    check(tonumber(c13.order) == 13, 'ACP Fin order')
    local k1, k2, k15 = D:quest('mission.mkd.001'), D:quest('mission.mkd.002'), D:quest('mission.mkd.015')
    check(k1 and k2 and k15, 'mkd missions')
    eq(marks.quest_icon(D, P2, k1, { status = st20 }), 'main', 'MKD1 is main')
    eq(marks.quest_icon(D, P2, k2, { status = st20 }), 'unavailable', 'MKD later mission')
    P2:set_state('mission.mkd.001', 'completed')
    eq(marks.quest_icon(D, P2, k2, { status = st20 }), 'main', 'MKD next by order')
    P2:set_state('mission.mkd.001', 'not_accepted')
    check(tonumber(k15.order) == 15, 'MKD Fin order')
    -- シャントット帝国の陰謀（0.1.123〜）：始めるには は最後、＜完＞ は16番目
    local a1, a2, a3, a16 = D:quest('mission.asa.001'), D:quest('mission.asa.002'), D:quest('mission.asa.003'), D:quest('mission.asa.016')
    check(a1 and a2 and a3 and a16, 'asa missions')
    eq(marks.mission_rank(a2), nil, 'ASA1: no rank')
    eq(marks.quest_icon(D, P2, a2, { status = st20 }), 'main', 'ASA1 is main')
    eq(marks.quest_icon(D, P2, a1, { status = st20 }), 'sub', 'ASA intro is not main')
    check(marks.reqs_unmet(a2, { main_job = 1, main_job_level = 5 }), 'ASA1 needs Lv10')
    P2:set_state('mission.asa.002', 'completed')
    eq(marks.quest_icon(D, P2, a3, { status = st20 }), 'main', 'ASA2 next by order')
    P2:set_state('mission.asa.002', 'not_accepted')
    check(tonumber(a16.order) == 16, 'ASA Fin order')
    -- アドゥリン（0.1.124〜）：最初が本筋、下に足した節（id 359）も並びで次になる
    local s1, s2, s27 = D:quest('mission.adoulin.001'), D:quest('mission.adoulin.359'), D:quest('mission.adoulin.361')
    check(s1 and s2 and s27, 'adoulin missions')
    eq(marks.quest_icon(D, P2, s1, { status = st20 }), 'main', 'SoA1-1 is main')
    P2:set_state('mission.adoulin.001', 'completed')
    eq(marks.quest_icon(D, P2, s2, { status = st20 }), 'main', 'SoA1-2 next by order')
    P2:set_state('mission.adoulin.001', 'not_accepted')
    check(tonumber(s27.order) == 27, 'SoA2-7-3 order')
    local s56 = D:quest('mission.adoulin.053')
    check(s56 and tonumber(s56.order) == 56, 'SoA3-6-5 order')
    -- 0.1.126：待つ手順を分けた（導く鍵は 待つ・Levil の2手順）
    local s32 = D:quest('mission.adoulin.029')
    check(s32 and #s32.steps == 2 and s32.steps[2].target == 'npc.256.Levil', 'SoA3-1-4 wait step')
    -- 0.1.127：第4章（下に足したメルヴィアン id 362 は4-1の次）
    local s57, s58, s77 = D:quest('mission.adoulin.055'), D:quest('mission.adoulin.362'), D:quest('mission.adoulin.074')
    check(s57 and s58 and s77 and tonumber(s58.order) == 58 and tonumber(s77.order) == 77, 'SoA4 order')
    -- 0.1.128：第4章の後半（墓所の秘密は移動＋3か所＋城門の5手順、BF は場所なし）
    local s81, s90 = D:quest('mission.adoulin.078'), D:quest('mission.adoulin.087')
    check(s81 and #s81.steps == 5 and tonumber(s81.order) == 81 and s90 and tonumber(s90.order) == 90, 'SoA4-4-3 steps and order')
    -- 0.1.129：第5章（始めるには は order 999、世界樹の導きは BF 2つで6手順、若き指導者が最後）
    local s0, s95, s105 = D:quest('mission.adoulin.089'), D:quest('mission.adoulin.094'), D:quest('mission.adoulin.104')
    check(s0 and tonumber(s0.order) == 999 and s95 and #s95.steps == 6 and s105 and tonumber(s105.order) == 105, 'SoA5 order and steps')
    -- 星唄（0.1.130〜）：始めるには は最後、鳴くはクリスタル が本筋、Lv3
    local r0, r1, r2, r17 = D:quest('mission.rov.001'), D:quest('mission.rov.002'), D:quest('mission.rov.003'), D:quest('mission.rov.018')
    check(r0 and r1 and r2 and r17, 'rov missions')
    eq(marks.quest_icon(D, P2, r1, { status = st20 }), 'main', 'RoV1-1 is main')
    eq(marks.quest_icon(D, P2, r0, { status = st20 }), 'sub', 'RoV intro is not main')
    check(marks.reqs_unmet(r1, { main_job = 1, main_job_level = 2 }), 'RoV1-1 needs Lv3')
    P2:set_state('mission.rov.002', 'completed')
    eq(marks.quest_icon(D, P2, r2, { status = st20 }), 'main', 'RoV1-2 next by order')
    P2:set_state('mission.rov.002', 'not_accepted')
    check(tonumber(r17.order) == 17 and #D:quest('mission.rov.016').steps == 3, 'RoV1-17 order, Siren 3 steps')
    -- 0.1.131：第2章の前半（理外の鯨は4手順、長いお別れが37番目）
    local r36, r38 = D:quest('mission.rov.036'), D:quest('mission.rov.038')
    check(r36 and #r36.steps == 4 and r38 and tonumber(r38.order) == 37, 'RoV2 first half')
    -- 0.1.132：第2章の後半（面汚しは4手順、時の溜りが58番目）
    local r54, r59 = D:quest('mission.rov.054'), D:quest('mission.rov.059')
    check(r54 and #r54.steps == 4 and r59 and tonumber(r59.order) == 58, 'RoV2 second half')
    -- 0.1.133：第3章の前半（叫ぶ闇は9手順、未来を導くが75番目）
    local r60, r76 = D:quest('mission.rov.060'), D:quest('mission.rov.076')
    check(r60 and #r60.steps == 9 and r76 and tonumber(r76.order) == 75, 'RoV3 first half')
    -- 0.1.134：資料に座標がない Inconspicuous Barrel（ララ水道）はマスなし
    local bar, r67 = D:target('obj.258.Inconspicuous_Barrel'), D:quest('mission.rov.067')
    check(bar and (bar.location == nil or bar.location.grid == nil) and r67 and r67.steps[3].location and r67.steps[3].location.grid == nil, 'RoV3-8 barrel has no grid')
    -- 0.1.135：第3章の後半（ローディングは3手順、すべてが星の唄となるが93番目）
    local r85, r94 = D:quest('mission.rov.085'), D:quest('mission.rov.094')
    check(r85 and #r85.steps == 3 and r94 and tonumber(r94.order) == 93, 'RoV3 second half')
    -- 0.1.136：蝕世のエンブリオの始まり（1番目はシートにない行を足した。Kupipi は資料に座標がない）
    local t1, t6, kp = D:quest('mission.tvr.001'), D:quest('mission.tvr.006'), D:target('npc.天の塔.Kupipi')
    check(t1 and tonumber(t1.order) == 1 and #t1.steps == 2 and t6 and #t6.steps == 11 and kp and (kp.location == nil or kp.location.grid == nil), 'TVR start')
    -- 0.1.137：蝕世の第2章の最後〜第3章の前半（フェ・インの Talos はマップの番号が資料で違うので番号なし）
    local t12, t14, ta = D:quest('mission.tvr.012'), D:quest('mission.tvr.014'), D:target('npc.204.Talos')
    -- 0.1.222〜：LSB の Talos 2件は同じ場所なので正確な座標が入り、MAP はゾーンの当たり判定の階（MAP3）
    check(t12 and #t12.steps == 12 and t14 and tonumber(t14.order) == 14 and ta and ta.location and ta.location.grid == 'H-7' and ta.location.pos and ta.location.map and ta.location.map.kind == 'number' and ta.location.map.n == 3, 'TVR chapter 3 first half')
    -- 0.1.138：蝕世の第4章〜第5章の前半（エジワ蘿洞の Survey Point は3か所を別の相手にした）
    local t15, t20, sp = D:quest('mission.tvr.015'), D:quest('mission.tvr.020'), D:target('obj.68.Survey_Point_F-8')
    check(t15 and #t15.steps == 11 and t20 and tonumber(t20.order) == 20 and sp and sp.location and sp.location.grid == 'F-8', 'TVR chapter 4')
    -- 0.1.139：蝕世の第5章の後半〜第6章の前半（翡翠廟の扉と Incantrix は座標なし、エジワ蘿洞の出口は2つのマス）
    local t23, t26, inc = D:quest('mission.tvr.023'), D:quest('mission.tvr.026'), D:target('npc.醴泉島.Incantrix')
    check(t23 and #t23.steps == 20 and t26 and tonumber(t26.order) == 26 and inc and inc.location and inc.location.grid == nil, 'TVR chapter 5-6')
    -- 0.1.140：蝕世の第7章〜第8章の前半（流砂洞 H-8 の ??? はもとの相手を使う。イフリートの釜の Mining Point は場所が動くので座標なし）
    local t27, t32, gfs = D:quest('mission.tvr.027'), D:quest('mission.tvr.032'), D:target('obj.105.Goblin_Festival_Site')
    check(t27 and #t27.steps == 13 and t27.steps[9].target == 'obj.208.???_H-8_7' and t32 and tonumber(t32.order) == 32 and gfs and gfs.location and gfs.location.grid == 'J-7 K-7', 'TVR chapter 7-8')
    -- 0.1.141：蝕世の第8章の最後〜第9章（夢幻なる英雄たちはシートに2行あるが同じミッションなので1件。37番目はシートの36番目の次）
    local t33, t35, t37, sw = D:quest('mission.tvr.033'), D:quest('mission.tvr.035'), D:quest('mission.tvr.037'), D:target('obj.274.Shrouded_Workroom')
    check(t33 and #t33.steps == 14 and t35 and tonumber(t35.order) == 35 and t37 and tonumber(t37.order) == 37 and sw and sw.location and sw.location.grid == 'K-3', 'TVR chapter 8-9')
    -- 0.1.142：第10章の前半（0.1.143 からプライムウェポンの復活の開始は Andreine。BG Wiki に書いてある）
    local t34s, t38, t40, t42, hg = D:quest('mission.tvr.034'), D:quest('mission.tvr.038'), D:quest('mission.tvr.040'), D:quest('mission.tvr.042'), D:target('obj.112.Heroes_Gambit')
    check(t37 and t37.start and t37.start.target == 'npc.セレニア図書館.Andreine' and t38 and #t38.steps == 7 and t40 and #t40.steps == 4 and t42 and #t42.steps == 7 and tonumber(t42.order) == 42 and hg and hg.location and hg.location.grid == 'J-9' and t34s and t34s.steps[2] and t34s.steps[2].text_ja and t34s.steps[2].text_ja:find('J-9 J-10', 1, true), 'TVR chapter 10 (1)')
    -- 0.1.143：プライムウェポンの復活の開始は Andreine（BG Wiki の見出し）。第10章の後半〜後日談（後日談は開始なし・どの順でもよい）
    local t43, t46, t47, tp = D:quest('mission.tvr.043'), D:quest('mission.tvr.046'), D:quest('mission.tvr.047'), D:target('obj.デュナミス-ザルカバード.Twinkling_Presence_G-10')
    check(t37 and t37.start and t37.start.target == 'npc.セレニア図書館.Andreine' and t43 and #t43.steps == 11 and t46 and #t46.steps == 5 and t47 and #t47.steps == 11 and tonumber(t47.order) == 47 and not (t47.start and t47.start.target) and tp and tp.location and tp.location.grid == 'G-10', 'TVR chapter 10-11')
    -- 0.1.144：アサルトの最初の5件（新しい分類 assault。何度でもでき、開始は公務代理店の受付。作戦の中で名前のある敵だけ討伐の相手にする）
    -- 0.1.214〜：名前のない敵の戦いの手順（001 の6番目・018 の7番目）は、BF の入口（Runic Seal）が相手
    local a1, a3, a4, br, ry = D:quest('mission.assault.001'), D:quest('mission.assault.003'), D:quest('mission.assault.004'), D:target('mob.63.Brittle_Rock'), D:target('npc.アトルガン白門.Rytaal')
    check(a1 and a1.repeatable == 'yes' and a1.start and a1.start.target == 'npc.アトルガン白門.Yahsra' and #a1.steps == 8 and a1.steps[6].target == 'obj.79.Runic_Seal' and a1.steps[6].entrance == true and a3 and a3.steps[6].target == 'mob.63.Brittle_Rock' and br and br.kind == 'mob' and br.location and br.location.zone_name == 'レベロス風穴' and tonumber(br.location.zone_id) == 63 and a4 and #a4.steps == 10 and tonumber(a4.order) == 4 and ry and ry.location and ry.location.grid == 'K-10', 'Assault 1')
    -- 0.1.145：作戦の中のゾーンにも番号（LSB のゾーン一覧：55・56・63・69・77）。印はゾーン＋名前で付く。ナイズル島（踏査指令・未開領域）と 008〜012
    local a6, a7, a9, a12, lam, vr = D:quest('mission.assault.006'), D:quest('mission.assault.007'), D:quest('mission.assault.009'), D:quest('mission.assault.012'), D:target('mob.55.Lamia_No13'), D:target('mob.77.Lord_Vryko')
    check(a6 and a6.repeatable == 'yes' and a6.start and a6.start.target == 'npc.アトルガン白門.Sorrowful_Sage' and #a6.steps == 9 and a7 and #a7.steps == 15 and tonumber(a7.order) == 7 and a7.steps[12].target == 'mob.77.Lord_Vryko' and vr and tonumber(vr.location.zone_id) == 77 and a9 and a9.steps[6].target == 'mob.66.Mamool_Ja_Executioner' and a12 and a12.steps[6].target == 'mob.55.Lamia_No13' and lam and tonumber(lam.location.zone_id) == 55, 'Assault 2')
    local inz = marks.in_zone({ { name = 'Brittle Rock', zone_id = 63 }, { name = 'Lamia No.13', zone_id = 55 } }, 63)
    check(#inz == 1 and inz[1].name == 'Brittle Rock', 'assault marks need the zone')
    -- 0.1.146：Yahsra・Isdebaaq・Famad は L-9 L-10（BG Wiki L-10、FFXIclopedia L-9/10 は境目）。013〜017（男爵の護衛・賢哲王・トロール・ライアーフ・蠱物）
    local yah, a13, a14, a15, a16 = D:target('npc.アトルガン白門.Isdebaaq'), D:quest('mission.assault.013'), D:quest('mission.assault.014'), D:quest('mission.assault.015'), D:quest('mission.assault.016')
    local mol, bts = D:target('mob.66.Sagelord_Molaal_Ja'), D:target('mob.63.Broken_Troll_Soldier')
    check(yah and yah.location and yah.location.grid == 'L-9 L-10' and a13 and #a13.steps == 9 and a13.steps[6].target == 'npc.69.Clavauert_B_Chanoix' and a14 and a14.steps[7].target == 'mob.66.Sagelord_Molaal_Ja' and mol and tonumber(mol.location.zone_id) == 66 and a15 and a15.steps[6].target == 'mob.63.Broken_Troll_Soldier' and bts and tonumber(bts.location.zone_id) == 63 and a16 and #a16.steps == 11 and a16.steps[7].target == 'npc.56.Ryaaf' and tonumber(a16.order) == 16, 'Assault 3')
    -- 0.1.147：018〜022（シャナーハ草・慰問物資・土筆・黒い男爵・掃海）。Black Baron は動く相手、Quhaaja・Uzhahn は作戦の中の NPC
    local a18, a19, a21, a22, bb, uz = D:quest('mission.assault.018'), D:quest('mission.assault.019'), D:quest('mission.assault.021'), D:quest('mission.assault.022'), D:target('mob.56.Black_Baron'), D:target('npc.55.Uzhahn')
    check(a18 and #a18.steps == 9 and a18.steps[7].target == 'obj.79.Runic_Seal' and a18.steps[7].entrance == true and a19 and #a19.steps == 11 and a19.steps[7].target == 'npc.66.Quhaaja' and a21 and a21.steps[7].target == 'mob.56.Black_Baron' and bb and tonumber(bb.location.zone_id) == 56 and a22 and #a22.steps == 12 and tonumber(a22.order) == 22 and uz and uz.location and uz.location.grid == 'H-10' and tonumber(uz.location.zone_id) == 55, 'Assault 4')
    -- 0.1.148：023〜027（黒羊・二重スパイ・傭兵軍師・架橋・シーラット）。Old Troll は倒す相手、Karakul・Qiqirn Diver は動く NPC
    local a23, a24, a25, a26, a27, ot, kk = D:quest('mission.assault.023'), D:quest('mission.assault.024'), D:quest('mission.assault.025'), D:quest('mission.assault.026'), D:quest('mission.assault.027'), D:target('mob.63.Old_Troll'), D:target('npc.69.Karakul')
    check(a23 and #a23.steps == 16 and a23.steps[13].target == 'npc.69.Karakul' and kk and tonumber(kk.location.zone_id) == 69 and a24 and #a24.steps == 9 and a25 and a25.steps[6].target == 'mob.63.Old_Troll' and ot and tonumber(ot.location.zone_id) == 63 and a26 and #a26.steps == 12 and a26.steps[7].target == 'obj.56.Switch_F-8' and a27 and #a27.steps == 12 and tonumber(a27.order) == 27, 'Assault 5')
    -- 0.1.149：028〜032（補給物資・魔宝石・アプカル繁殖・ブラッドバス・アプカル捕獲）。Augmented Chigoe は倒す相手、Lebros Apkallu・Fairy Apkallu は動く NPC
    local a28, a29, a30, a31, a32, ch, zk = D:quest('mission.assault.028'), D:quest('mission.assault.029'), D:quest('mission.assault.030'), D:quest('mission.assault.031'), D:quest('mission.assault.032'), D:target('mob.56.Augmented_Chigoe'), D:target('npc.66.Zahakahm')
    check(a28 and #a28.steps == 10 and a28.steps[8].target == nil and a29 and #a29.steps == 13 and zk and zk.location and zk.location.grid == 'H-10' and tonumber(zk.location.zone_id) == 66 and a30 and a30.steps[7].target == 'npc.63.Lebros_Apkallu' and a31 and a31.steps[6].target == 'mob.56.Augmented_Chigoe' and ch and tonumber(ch.location.zone_id) == 56 and a32 and #a32.steps == 15 and tonumber(a32.order) == 32, 'Assault 6')
    -- 0.1.150：033〜037（青の治験・謝鱗祭・ワモーラ・地雷原・指輪）。Ranch Wamouracampa は倒す相手、Lumaayu は I-6、Rune of Release H-8 I-9
    local a33, a34, a35, a36, a37, rw, lu, rr = D:quest('mission.assault.033'), D:quest('mission.assault.034'), D:quest('mission.assault.035'), D:quest('mission.assault.036'), D:quest('mission.assault.037'), D:target('mob.63.Ranch_Wamouracampa'), D:target('npc.66.Lumaayu'), D:target('obj.55.Rune_of_Release_H-8_I-9')
    check(a33 and #a33.steps == 16 and a33.steps[7].target == 'obj.79.Runic_Seal' and a33.steps[7].entrance == true and a33.steps[6].target == 'npc.69.Nareema' and a34 and #a34.steps == 14 and lu and lu.location and lu.location.grid == 'I-6' and tonumber(lu.location.zone_id) == 66 and a35 and a35.steps[6].target == 'mob.63.Ranch_Wamouracampa' and rw and tonumber(rw.location.zone_id) == 63 and a36 and a36.steps[8].target == 'obj.56.Qiqirn_Mine' and a37 and #a37.steps == 14 and tonumber(a37.order) == 37 and rr and rr.location and rr.location.grid == 'H-8 I-9', 'Assault 7')
    -- 0.1.151：038〜042（オグマ・マーリド・ハンターキラー・双頭の蛇・脱走兵）。Saizo は H-8 I-8、Umarid は倒さない NPC、Rune of Release I-5
    local a38, a39, a40, a41, a42, sz, um, r5 = D:quest('mission.assault.038'), D:quest('mission.assault.039'), D:quest('mission.assault.040'), D:quest('mission.assault.041'), D:quest('mission.assault.042'), D:target('mob.69.Saizo'), D:target('npc.56.Umarid'), D:target('obj.56.Rune_of_Release_I-5')
    check(a38 and #a38.steps == 12 and a38.steps[6].target == 'mob.69.Saizo' and sz and sz.location and sz.location.grid == 'H-8 I-8' and tonumber(sz.location.zone_id) == 69 and a39 and a39.steps[7].target == 'mob.66.Marid' and a39.steps[10].target == 'obj.52.Runic_Seal' and a39.steps[10].entrance == true and a40 and #a40.steps == 10 and a41 and a41.steps[11].target == 'npc.56.Umarid' and um and um.location and um.location.grid == 'H-6' and r5 and r5.location.grid == 'I-5' and a42 and #a42.steps == 11 and tonumber(a42.order) == 42, 'Assault 8')
    -- 0.1.152：043〜047（合同演習・青の症例・ブラックパール・人形の目覚め・鱆号）。Raubahn は I-6 の倒す相手、Garjham は H-8、Orobon は動く印
    local a43, a44, a45, a46, a47, rb, gj, ob = D:quest('mission.assault.043'), D:quest('mission.assault.044'), D:quest('mission.assault.045'), D:quest('mission.assault.046'), D:quest('mission.assault.047'), D:target('mob.69.Raubahn'), D:target('npc.66.Garjham'), D:target('mob.55.Orobon')
    check(a43 and #a43.steps == 10 and a43.steps[8].target == 'mob.69.Raubahn' and rb and rb.location and rb.location.grid == 'I-6' and tonumber(rb.location.zone_id) == 69 and a44 and #a44.steps == 14 and gj and gj.location and gj.location.grid == 'H-8' and a45 and a45.steps[10].target == 'mob.63.Jorporbor_the_Hellraker' and a45.steps[12].target == 'obj.63.Rune_of_Release_G-7' and a46 and #a46.steps == 15 and a46.steps[11].target == 'npc.56.Adeeha' and a47 and #a47.steps == 16 and a47.steps[13].target == 'mob.55.Orobon' and ob and tonumber(a47.order) == 47, 'Assault 9')
    -- 0.1.153：048〜052（中尉：ヘルシング・スサノオ・ヘラクレス・キラーロード・ベレロフォン）。地図がないのでマスなし、Rune of Release はエリアだけ
    local a48, a49, a50, a51, a52, cd, kg, r55 = D:quest('mission.assault.048'), D:quest('mission.assault.049'), D:quest('mission.assault.050'), D:quest('mission.assault.051'), D:quest('mission.assault.052'), D:target('mob.69.Count_Dracula'), D:target('mob.56.King_Goldemar'), D:target('obj.55.Rune_of_Release')
    check(a48 and #a48.steps == 9 and a48.steps[7].target == 'mob.69.Count_Dracula' and cd and cd.location and tonumber(cd.location.zone_id) == 69 and (cd.location.grid == nil or cd.location.grid == '') and a49 and a49.steps[7].target == 'mob.66.Orochi' and a50 and #a50.steps == 10 and a50.steps[8].target == 'obj.61.Runic_Seal' and a50.steps[8].entrance == true and a51 and a51.steps[8].target == 'mob.56.King_Goldemar' and kg and a52 and a52.steps[7].target == nil and a52.steps[8].target == 'mob.55.Khimaira_14X' and a52.steps[10].target == 'obj.55.Rune_of_Release' and r55 and tonumber(a52.order) == 52, 'Assault 10')
    -- 0.1.154：カンパニエの最初の5件（新しい分類 campaign。何度でもでき、受付は各国の Campaign Ops の NPC。不審物回収は Suspicious Object が動く印）
    do
    local c1, c3, c5, ra, so, em = D:quest('mission.campaign.001'), D:quest('mission.campaign.003'), D:quest('mission.campaign.005'), D:target('npc.南サンドリア〔Ｓ〕.Rasdinice'), D:target('obj.南サンドリア〔Ｓ〕.Suspicious_Object'), D:target('npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo')
    check(c1 and c1.repeatable == 'yes' and c1.start and c1.start.target == 'npc.南サンドリア〔Ｓ〕.Rasdinice' and #c1.steps == 5 and c1.steps[4].target == 'obj.南サンドリア〔Ｓ〕.Suspicious_Object' and c1.steps[5].target == 'npc.南サンドリア〔Ｓ〕.Rasdinice' and ra and ra.location and ra.location.grid == 'I-9' and so and so.kind == 'obj' and c3 and #c3.steps == 4 and c3.start.target == 'npc.バストゥーク商業区〔Ｓ〕.Hieronymus' and c5 and tonumber(c5.order) == 5 and em and em.location and em.location.grid == 'H-9', 'Campaign 1')
    end
    -- 0.1.155：カンパニエ 6〜11件目（兵員輸送は Gate Sentry から Reinforcement を Arlayse, R.K. まで。兵士調練は常花の石窟の BF に勝つ。BF の相手は印なし）
    do
    local c6, c8, c9, c11, gs, ar, ae = D:quest('mission.campaign.006'), D:quest('mission.campaign.008'), D:quest('mission.campaign.009'), D:quest('mission.campaign.011'), D:target('npc.東ロンフォール〔Ｓ〕.Gate_Sentry'), D:target('npc.東ロンフォール〔Ｓ〕.Arlayse_RK'), D:target('npc.東ロンフォール〔Ｓ〕.Allied_Ensign')
    check(c6 and c6.repeatable == 'yes' and #c6.steps == 7 and c6.steps[3].target == 'npc.東ロンフォール〔Ｓ〕.Gate_Sentry' and c6.steps[6].target == 'npc.東ロンフォール〔Ｓ〕.Arlayse_RK' and c8 and tonumber(c8.order) == 8 and gs and gs.location and gs.location.grid == 'J-11' and ar and ar.location and ar.location.grid == 'H-8' and c9 and #c9.steps == 8 and c9.steps[3].target == 'npc.東ロンフォール〔Ｓ〕.Allied_Ensign' and c9.steps[6].target == nil and ae and ae.location and ae.location.grid == 'G-5' and c11 and c11.start and c11.start.target == 'npc.南サンドリア〔Ｓ〕.Rasdinice', 'Campaign 2')
    end
    -- 0.1.156：カンパニエ 12・14〜16件目（即身成神討伐は BF に勝つ・印なし。巡回任務は東ロンフォール〔Ｓ〕の ??? と Goblin Picaroon（ゾーン番号 81 の印）。596 友軍支援は 0.1.157 で9件に分けた）
    do
    local c12, c14, c16, gp, q7 = D:quest('mission.campaign.012'), D:quest('mission.campaign.014'), D:quest('mission.campaign.016'), D:target('mob.81.Goblin_Picaroon'), D:target('obj.81.???_H-7')
    check(c12 and c12.repeatable == 'yes' and #c12.steps == 7 and c12.start and c12.start.target == 'npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo' and c12.steps[3].target == nil and c12.steps[5].target == 'obj.オズトロヤ城〔Ｓ〕.Collapsing_Floor' and c14 and #c14.steps == 6 and c14.steps[4].target == 'mob.81.Goblin_Picaroon' and c14.steps[3].target == 'obj.81.???_K-5' and gp and gp.kind == 'mob' and c16 and tonumber(c16.order) == 24 and c16.steps[5].target == 'obj.81.???_H-7' and q7 and q7.location and q7.location.grid == 'H-7', 'Campaign 3')
    end
    -- 0.1.157：カンパニエ 友軍支援 9件（3軍×I〜III。013 が 596 行、060〜067 はシートの下に足した行。Fortilace はゾーン番号の印、中は場所だけ。Stormer は印なし）
    do
    local a, b, c, w1, f84, f98, da, dg = D:quest('mission.campaign.013'), D:quest('mission.campaign.061'), D:quest('mission.campaign.064'), D:quest('mission.campaign.067'), D:target('obj.84.Fortilace'), D:target('obj.98.Fortilace'), D:target('obj.常花の石窟.Dawn_Aureola'), D:target('obj.ゴユの空洞.Dawn_Aureola')
    check(a and a.repeatable == 'yes' and #a.steps == 7 and tonumber(a.order) == 13 and a.steps[3].target == 'obj.84.Fortilace' and a.steps[5].target == 'obj.84.Fortilace' and a.steps[5].entrance == true and a.steps[6].target == 'obj.常花の石窟.Dawn_Aureola' and b and tonumber(b.order) == 15 and c and c.start and c.start.target == 'npc.バストゥーク商業区〔Ｓ〕.Hieronymus' and c.steps[3].target == 'obj.91.Fortilace' and w1 and tonumber(w1.order) == 21 and w1.steps[6].target == 'obj.ゴユの空洞.Dawn_Aureola' and f84 and f84.location and f84.location.grid == 'D-6' and f98 and f98.location and f98.location.grid == 'L-9' and da and dg and dg.kind == 'obj', 'Campaign 4')
    end
    -- 0.1.158：カンパニエ 戦略物資収集 12件（3軍×I〜IV。Quartermaster は新しい印、集める場所は印なし）
    do
    local s1, s4, w1, qs, qw = D:quest('mission.campaign.027'), D:quest('mission.campaign.023'), D:quest('mission.campaign.028'), D:target('npc.南サンドリア〔Ｓ〕.Quartermaster'), D:target('npc.ウィンダス水の区〔Ｓ〕.Quartermaster')
    check(s1 and s1.repeatable == 'yes' and #s1.steps == 5 and tonumber(s1.order) == 35 and s1.start and s1.start.target == 'npc.南サンドリア〔Ｓ〕.Rasdinice' and s1.steps[2].target == 'npc.南サンドリア〔Ｓ〕.Quartermaster' and s1.steps[3].target == nil and s1.steps[4].target == 'npc.南サンドリア〔Ｓ〕.Quartermaster' and s4 and s4.steps[2].target == 'npc.バストゥーク商業区〔Ｓ〕.Quartermaster' and w1 and tonumber(w1.order) == 36 and qs and qs.location and qs.location.grid == 'H-9' and qw and qw.location and qw.location.grid == 'F-9', 'Campaign 5')
    end
    -- 0.1.159：カンパニエ 技術供与 III〜I（王国軍）（Adjutant は新しい印 D-8、2問を2つの手順に分けた）
    do
    local a3, a1, adj = D:quest('mission.campaign.029'), D:quest('mission.campaign.031'), D:target('npc.南サンドリア〔Ｓ〕.Adjutant')
    check(a3 and a3.repeatable == 'yes' and #a3.steps == 5 and tonumber(a3.order) == 37 and a3.start and a3.start.target == 'npc.南サンドリア〔Ｓ〕.Rasdinice' and a3.steps[2].target == 'npc.南サンドリア〔Ｓ〕.Adjutant' and a3.steps[4].target == 'npc.南サンドリア〔Ｓ〕.Adjutant' and a3.steps[5].target == 'npc.南サンドリア〔Ｓ〕.Rasdinice' and a1 and tonumber(a1.order) == 39 and adj and adj.location and adj.location.grid == 'D-8', 'Campaign 6')
    end
    -- 0.1.160：カンパニエ 拠点偵察・拠点攻略・拠点防衛 III〜I（王国軍）（行き先のエリアが決まらないので受付と報告だけ印）
    do
    local h3, s1, a2 = D:quest('mission.campaign.032'), D:quest('mission.campaign.037'), D:quest('mission.campaign.039')
    check(h3 and h3.repeatable == 'yes' and #h3.steps == 5 and tonumber(h3.order) == 40 and h3.start and h3.start.target == 'npc.南サンドリア〔Ｓ〕.Rasdinice' and h3.steps[3].target == nil and h3.steps[5].target == 'npc.南サンドリア〔Ｓ〕.Rasdinice' and s1 and #s1.steps == 4 and tonumber(s1.order) == 45 and s1.steps[2].target == nil and a2 and tonumber(a2.order) == 47 and a2.steps[4].target == 'npc.南サンドリア〔Ｓ〕.Rasdinice', 'Campaign 7')
    end
    -- 0.1.161：カンパニエ 敵兵装備偵察 II・I と破壊工作 III〜I（王国軍）（Crochepallade は新しい印 H-9、拠点の手順は印なし）
    do
    local d2, d1, b3, b1, cro = D:quest('mission.campaign.041'), D:quest('mission.campaign.042'), D:quest('mission.campaign.043'), D:quest('mission.campaign.045'), D:target('npc.南サンドリア〔Ｓ〕.Crochepallade')
    check(cro and d2 and d2.repeatable == 'yes' and #d2.steps == 6 and tonumber(d2.order) == 49 and d2.start and d2.start.target == 'npc.南サンドリア〔Ｓ〕.Rasdinice' and d2.steps[2].target == 'npc.南サンドリア〔Ｓ〕.Crochepallade' and d2.steps[4].target == nil and d2.steps[5].target == 'npc.南サンドリア〔Ｓ〕.Crochepallade' and d2.steps[6].target == 'npc.南サンドリア〔Ｓ〕.Rasdinice' and d1 and tonumber(d1.order) == 50 and b3 and #b3.steps == 6 and tonumber(b3.order) == 51 and b3.steps[3].target == nil and b3.steps[6].target == 'npc.南サンドリア〔Ｓ〕.Rasdinice' and b1 and tonumber(b1.order) == 53, 'Campaign 8')
    end
    -- 0.1.162：カンパニエ 職業訓練 III・II・I（王国軍）と I（共和国軍）（バストゥークの Adjutant は新しい印 J-9、3問を3つの手順に分けた）
    do
    local c3, cb, c1, adjb = D:quest('mission.campaign.046'), D:quest('mission.campaign.048'), D:quest('mission.campaign.049'), D:target('npc.バストゥーク商業区〔Ｓ〕.Adjutant')
    check(adjb and c3 and c3.repeatable == 'yes' and #c3.steps == 6 and tonumber(c3.order) == 54 and c3.start and c3.start.target == 'npc.南サンドリア〔Ｓ〕.Rasdinice' and c3.steps[2].target == 'npc.南サンドリア〔Ｓ〕.Adjutant' and c3.steps[5].target == 'npc.南サンドリア〔Ｓ〕.Adjutant' and cb and tonumber(cb.order) == 56 and cb.start.target == 'npc.バストゥーク商業区〔Ｓ〕.Hieronymus' and cb.steps[2].target == 'npc.バストゥーク商業区〔Ｓ〕.Adjutant' and cb.steps[6].target == 'npc.バストゥーク商業区〔Ｓ〕.Hieronymus' and c1 and tonumber(c1.order) == 57, 'Campaign 9')
    end
    -- 0.1.163：カンパニエ 補給部隊強襲を三国×I〜III の9件に分けた（633 行が III（王国軍）、ほかの8件は 658〜665 行。Beastman Ensign と Twilight Aureola の印）
    do
    local s3, b3, w1 = D:quest('mission.campaign.050'), D:quest('mission.campaign.070'), D:quest('mission.campaign.075')
    check(s3 and s3.repeatable == 'yes' and #s3.steps == 7 and tonumber(s3.order) == 58 and s3.start and s3.start.target == 'npc.南サンドリア〔Ｓ〕.Rasdinice' and s3.steps[2].target == 'obj.ブンカール浦〔Ｓ〕.Beastman_Ensign' and s3.steps[5].target == 'obj.ブンカール浦〔Ｓ〕.Beastman_Ensign' and s3.steps[5].entrance == true and s3.steps[6].target == 'obj.常花の石窟.Twilight_Aureola' and b3 and tonumber(b3.order) == 61 and b3.start.target == 'npc.バストゥーク商業区〔Ｓ〕.Hieronymus' and b3.steps[3].target == 'obj.グロウベルグ〔Ｓ〕.Beastman_Ensign' and w1 and tonumber(w1.order) == 66 and w1.steps[2].target == 'obj.カルゴナルゴ城砦〔Ｓ〕.Beastman_Ensign' and w1.steps[7].target == 'npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo' and D:target('obj.ゴユの空洞.Twilight_Aureola'), 'Campaign 10')
    end
    -- 0.1.164：カンパニエ 軍需品調達 III・II・IV・I（王国軍）。Quartermaster の印はこれまでのもの
    do
      local m3, m4, m1 = D:quest('mission.campaign.051'), D:quest('mission.campaign.053'), D:quest('mission.campaign.054')
      check(m3 and m3.repeatable == 'yes' and #m3.steps == 5 and tonumber(m3.order) == 67 and m3.start and m3.start.target == 'npc.南サンドリア〔Ｓ〕.Rasdinice' and m3.steps[2].target == 'npc.南サンドリア〔Ｓ〕.Quartermaster' and m3.steps[3].target == nil and m3.steps[4].target == 'npc.南サンドリア〔Ｓ〕.Quartermaster' and m4 and tonumber(m4.order) == 69 and m1 and tonumber(m1.order) == 70 and m1.steps[5].target == 'npc.南サンドリア〔Ｓ〕.Rasdinice', 'Campaign 11')
    end
    -- 0.1.165：カンパニエ 軍需品運搬 III・II・I（王国軍）。エリアは選べるので受付だけ印
    do
      local c3, c1 = D:quest('mission.campaign.055'), D:quest('mission.campaign.057')
      check(c3 and c3.repeatable == 'yes' and #c3.steps == 7 and tonumber(c3.order) == 71 and c3.start and c3.start.target == 'npc.南サンドリア〔Ｓ〕.Rasdinice' and c3.steps[2].target == nil and c3.steps[6].target == nil and c1 and tonumber(c1.order) == 73 and c1.steps[7].target == 'npc.南サンドリア〔Ｓ〕.Rasdinice', 'Campaign 12')
    end
    -- 0.1.166：カンパニエ 金剛王討伐（共和国軍）・黒太子討伐（王国軍）
    do
      local b, s = D:quest('mission.campaign.058'), D:quest('mission.campaign.059')
      check(b and #b.steps == 8 and tonumber(b.order) == 74 and b.start and b.start.target == 'npc.バストゥーク商業区〔Ｓ〕.Hieronymus' and b.steps[3].target == nil and b.steps[4].target == 'obj.ベドー〔Ｓ〕.Corroded_Gate' and b.steps[6].target == 'obj.ベドー〔Ｓ〕.Ironbound_Gate' and s and #s.steps == 7 and tonumber(s.order) == 75 and s.steps[5].target == 'obj.ラヴォール村〔Ｓ〕.Reinforced_Gateway' and s.steps[7].target == 'npc.南サンドリア〔Ｓ〕.Rasdinice', 'Campaign 13')
    end
    -- 0.1.167：前のミッションの見直し（ジラート・プロマシア）。足した手順は新しい id（g00・g01a など）で、前の id は変えない
    do
      local z, t, w = D:quest('mission.zilart.002'), D:quest('mission.promathia.026'), D:quest('mission.promathia.030')
      check(z and #z.steps == 2 and z.steps[1].id == 'mission.zilart.002#g00' and z.steps[1].type == 'go' and z.steps[2].id == 'mission.zilart.002#g01'
        and t and #t.steps == 8 and t.steps[1].id == 'mission.promathia.026#g00a' and t.steps[3].target == 'npc.232.Anoki' and t.steps[4].id == 'mission.promathia.026#g01'
        and w and #w.steps == 5 and w.steps[2].id == 'mission.promathia.030#g01a' and w.steps[2].target == 'npc.11.Tarnotik' and w.steps[3].id == 'mission.promathia.030#g02', 'Review 1')
    end
    -- 0.1.168：前のミッションの見直し 2（アトルガン・アルタナ・モグ祭り）
    do
      local a, k, m = D:quest('mission.aht_urhgan.036'), D:quest('mission.altana.037'), D:quest('mission.mkd.007')
      check(a and #a.steps == 3 and a.steps[1].id == 'mission.aht_urhgan.036#g00' and a.steps[2].id == 'mission.aht_urhgan.036#g01'
        and k and #k.steps == 3 and k.steps[1].type == 'go' and k.steps[3].id == 'mission.altana.037#g02'
        and m and #m.steps == 3 and m.steps[1].id == 'mission.mkd.007#g00' and m.steps[3].target == 'obj.244.Inconspicuous_Door', 'Review 2')
    end
    -- ゲートガード：所属国に次のミッションがあれば六角形、ほかの国のガードは盾
    local g = {}
    for _, w in ipairs(marks.wanted(D, P2, { status = bst })) do if w.role == 'guard' then g[w.name] = w end end
    eq(g['Argus'].icon, 'main', 'bastok guard shows the mission')
    eq(g['Argus'].next_mission, 'mission.bastok.001', 'next mission named')
    eq(g['Ambrotien'].icon, 'guard', 'sandoria guard keeps the shield')
    local g2 = {}
    for _, w in ipairs(marks.wanted(D, P2)) do if w.role == 'guard' then g2[w.name] = w end end
    eq(g2['Ambrotien'].icon, 'main', 'unknown nation: every nation with a next mission')
    eq(g2['Mokyokyo'].icon, 'main', 'windurst too')
    -- 受注中なら次のミッションは進行中なので、その国のガードは盾
    P2:set_state('mission.bastok.001', 'accepted')
    for _, w in ipairs(marks.wanted(D, P2, { status = bst })) do
        if w.name == 'Argus' and w.role == 'guard' then eq(w.icon, 'guard', 'mission in progress: shield') end
    end
end
