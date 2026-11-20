-- 0.1.196: 前提が済んでいるミッションを、次かどうかだけで受けられないにしない。
-- 名前の照合は「（ミッション）」の有無や中黒の表記ゆれも見る。
require('harness')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local marks = require('src.core.marks')

local D = data_mod.load(posix_fs(), ROOT .. '/data/')
eq(#D.errors, 0, 'data errors')
local P = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
P:reset({ server = 'catseye', name = 'Prereq' })

local q31 = D:quest('mission.bastok.007')  -- BM3-1 四銃士
local q32 = D:quest('mission.bastok.008')  -- BM3-2 忘れられた鉱山にて
local q71 = D:quest('mission.bastok.015')  -- BM7-1 完成品のイメージ
local q62 = D:quest('mission.bastok.014')  -- BM6-2 海賊たちの唄
local q72 = D:quest('mission.bastok.016')  -- BM7-2 それぞれの行方
check(q31 and q32 and q71 and q62 and q72, 'bastok missions')

-- 名前は資料どおりつながる（四銃士 と 「四銃士」クリア後）
local ids32 = marks.prereq_ids(D, q32)
eq(#ids32, 1, 'BM3-2 has one prereq group')
eq(ids32[1][1], 'mission.bastok.007', 'BM3-2 prereq is 四銃士')
local ids71 = marks.prereq_ids(D, q71)
eq(#ids71, 1, 'BM7-1 has one prereq group')
eq(ids71[1][1], 'mission.bastok.014', 'BM7-1 prereq is 海賊たちの唄')

-- 画面と同じ進み：1-2 は未受注のまま、3-1 と 6-2 は完了
local done = {
    'mission.bastok.001', 'mission.bastok.003', 'mission.bastok.004', 'mission.bastok.005',
    'mission.bastok.006', 'mission.bastok.007', 'mission.bastok.009', 'mission.bastok.010',
    'mission.bastok.011', 'mission.bastok.012', 'mission.bastok.013', 'mission.bastok.014',
}
for _, id in ipairs(done) do P:set_state(id, 'completed') end
eq(P:state(q31.id), 'completed', '3-1 done')
eq(P:state(q62.id), 'completed', '6-2 done')
eq(P:state('mission.bastok.002'), 'not_accepted', '1-2 still open')
check(not marks.prereq_unmet(D, P, q32), '3-2 prereq met')
check(not marks.prereq_unmet(D, P, q71), '7-1 prereq met')
check(marks.prereq_unmet(D, P, q72), '7-2 still needs 7-1')

local nm = marks.next_missions(D, P)
eq(nm['mission.bastok.002'] and true or false, true, 'next bastok is 1-2')
eq(marks.quest_icon(D, P, D:quest('mission.bastok.002'), { next_missions = nm }), 'main', '1-2 is main')
eq(marks.quest_icon(D, P, q32, { next_missions = nm }), 'sub', '3-2 takeable even if not next')
eq(marks.quest_icon(D, P, q71, { next_missions = nm }), 'sub', '7-1 takeable after 6-2')
eq(marks.quest_icon(D, P, q72, { next_missions = nm }), 'unavailable', '7-2 still blocked')

-- 名前の照合：接尾と中黒
local r48 = D:quest('mission.rov.048')
local g = marks.prereq_ids(D, r48)
local has = false
for _, grp in ipairs(g) do
    for _, id in ipairs(grp) do if id == 'mission.rov.047' then has = true end end
end
check(has, 'エスカ-ル・オン matches エスカ-ル・オン（ミッション）')

-- quest.misc.056 の理由は「宣託の間」（資料は 宣託の間（ミッション））
local z_ok = false
for _, grp in ipairs(marks.prereq_ids(D, D:quest('quest.misc.056'))) do
    for _, id in ipairs(grp) do if id == 'mission.zilart.006' then z_ok = true end end
end
check(z_ok, '宣託の間 matches 宣託の間（ミッション）')

local m_ok = false
for _, grp in ipairs(marks.prereq_ids(D, D:quest('quest.adoulin.044'))) do
    for _, id in ipairs(grp) do if id == 'quest.misc.024' then m_ok = true end end
end
check(m_ok, 'モンストロス･プレッジ matches モンストロス・プレッジ')

-- 前提が済んだミッションは、次でなくても受けられないにならない（全体）
local false_un = 0
P:reset({ server = 'catseye', name = 'Prereq2' })
for _, q in ipairs(D.quests) do
    P.doc.quests = {}
    for _, grp in ipairs(marks.prereq_ids(D, q)) do
        for _, id in ipairs(grp) do P:set_state(id, 'completed') end
    end
    local ic = marks.quest_icon(D, P, q)
    -- 後日談（BM8-1 の手紙など）が残っている受けられないは、前提が済んでいても正しい
    if ic == 'unavailable' and not marks.prereq_unmet(D, P, q)
        and not marks.followup_block(D, P, q, nil) then
        false_un = false_un + 1
    end
end
eq(false_un, 0, 'no false unavailable when own prereqs are done')
