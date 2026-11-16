require('harness')
-- 0.1.57: ピン留めしているクエスト・ミッションが完了扱いになったら、ピン留めを自動で外す
local json = require('src.lib.json')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local D = data_mod.load(posix_fs(), ROOT .. '/data/')
local who = { server = 'catseye', name = 'Test' }
local changes = {}
local P = progress.new({ data = D, on_change = function (k, q) changes[#changes + 1] = k end })
P:reset(who)
local A, B, C = 'quest.sandoria.001', 'mission.sandoria.010', 'quest.bastok.001'
for _, q in ipairs({ A, B, C }) do check(P:pin(q).ok, 'pin ' .. q) end
eq(#P:pinned_list(), 3, 'three pinned')

-- 本・詳細の「完了」
local r = P:set_state(B, 'completed')
check(r.ok and r.unpinned, 'unpinned on complete')
check(not P:is_pinned(B), 'B not pinned')
eq(#P:pinned_list(), 2, 'two left')
eq(P:pinned_list()[1], A, 'order kept 1'); eq(P:pinned_list()[2], C, 'order kept 2')
eq(P:record(A).pin_order, 1, 'renumbered A'); eq(P:record(C).pin_order, 2, 'renumbered C')
eq(P:record(B).pin_order, nil, 'no order for B')
eq(changes[#changes], 'set_state', 'save scheduled via on_change')

-- 最後の手順へのチェック → 完了をすすめる → 完了
local q = D:quest(A)
local last = q.steps[#q.steps]
P:set_state(A, 'accepted')   -- 0.1.180〜：未受注のクエストはチェックできない
local cr = P:check_step(A, last.id, true)
check(cr.suggest_complete, 'suggest complete after last step')
check(P:is_pinned(A), 'still pinned until completed')
check(P:set_state(A, 'completed').unpinned, 'unpinned after last step + complete')
check(not P:is_pinned(A), 'A not pinned')

-- 完了以外の状態では外さない
local r2 = P:set_state(C, 'accepted')
check(r2.ok and not r2.unpinned, 'accepted keeps pin')
check(P:is_pinned(C), 'C pinned')

-- ピン留めしていないものを完了にしても何も起きない
check(not P:set_state('quest.bastok.002', 'completed').unpinned, 'not pinned: nothing')

-- 保存データにも反映
local snap = json.decode(json.encode(P:snapshot()))
eq(snap.quests[A].pinned, false, 'saved A unpinned'); eq(snap.quests[B].pinned, false, 'saved B unpinned')
eq(snap.quests[C].pinned, true, 'saved C pinned')

-- 古い保存（完了なのにピン留めが残っている）は読み込みで外す
snap.quests[A].pinned = true; snap.quests[A].pin_order = 2; snap.quests[C].pin_order = 1
local P2 = progress.new({ data = D })
check(P2:adopt(snap, who), 'adopt')
eq(P2.unpinned_on_load, 1, 'one unpinned on load')
check(not P2:is_pinned(A), 'old save A unpinned')
eq(#P2:pinned_list(), 1, 'tracker shows only C'); eq(P2:record(C).pin_order, 1, 'C order 1')
