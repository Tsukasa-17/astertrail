-- 0.1.64: トラッカーの手順の数（今/全部）。ルートを選んだら共通＋そのルートだけ
require('harness')
local D = require('src.core.data').load(posix_fs(), ROOT .. '/data/')
eq(#D.errors, 0, 'data errors')
local P = require('src.core.progress').new({ data = D, max_pins = function () return 10 end, on_change = function () end })
P:reset({ server = 'catseye', name = 'Test' })

-- ルートの無いクエスト
local plain
for _, q in ipairs(D.quests) do
    if #P:routes(q.id) == 0 and #q.steps >= 3 then plain = q; break end
end
local c, t = P:step_count(plain.id)
eq(c, 1, 'plain: first step')
eq(t, #plain.steps, 'plain: all steps')
P:decide_step(plain.id, plain.steps[3].id)
eq((P:step_count(plain.id)), 3, 'plain: third step')

-- sandoria.056：共通 g01 g02 g05、初めて ga01 ga02、他国クリア済み gb01
local Q = 'quest.sandoria.056'
local a, b = P:step_count(Q)
eq(a, 1, 'no route yet: 1')
eq(b, 5, 'no route yet: common + the longest route')
P:set_route(Q, '他国クリア済み')
P:decide_step(Q, Q .. '#gb01')
a, b = P:step_count(Q)
eq(b, 4, 'route chosen: common 3 + 1')
eq(a, 3, 'gb01 is the third counted step')
P:decide_step(Q, Q .. '#g05')
a, b = P:step_count(Q)
eq(a .. '/' .. b, '4/4', 'last step on the short route')
P:set_route(Q, '初めて')
P:decide_step(Q, Q .. '#ga02')
a, b = P:step_count(Q)
eq(a .. '/' .. b, '4/5', 'ga02 on the long route')
P:set_state(Q, 'accepted')   -- 0.1.180〜：未受注のクエストはチェックできない
P:check_through(Q, Q .. '#g05')
a, b = P:step_count(Q)
eq(a .. '/' .. b, '5/5', 'all done: total/total')
eq(P:step_count('nope'), nil, 'unknown quest: nil')
