-- ルート：詳細でルートの手順をチェックすると、そのルートを選んだことになり、ほかのルートはたたむ
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local Q = 'mission.sandoria.006'       -- 他国を回れ（バストゥーク先／ウィンダス先）
local A1 = Q .. '#ga01'                -- バストゥーク先の最初
local B1 = Q .. '#gb01'                -- ウィンダス先の最初

cmd('/astertrail'); frame()
app._settings().book.tab = 'mission'; frame()
app.select_in_book(Q, true); frame(); frame()
-- 選ぶ前は両方のルートが見える
check(labeled('##chk_' .. A1) and labeled('##chk_' .. B1), 'both routes before choosing')
check(not texted('で進めています'), 'no route bar before choosing')

-- ウィンダス先の手順をチェック → ウィンダス先に決まり、バストゥーク先はたたむ
FAKE.clicks['##chk_' .. B1] = true; frame(); frame()
check(labeled('##chk_' .. B1), 'chosen route shown')
check(not labeled('##chk_' .. A1), 'other route folded')
check(texted('ウィンダス先 で進めています'), 'route bar')
check(texted('たたんでいます'), 'folded count shown')
check(labeled('##route_バストゥーク先'), 'switch button')
check(labeled('##chk_' .. Q .. '#g01') and labeled('##chk_' .. Q .. '#g02'), 'common steps stay')

-- 全部表示 → もう一度たたむ
FAKE.clicks['##route_all'] = true; frame(); frame()
check(labeled('##chk_' .. A1), 'show all')
FAKE.clicks['##route_all'] = true; frame(); frame()
check(not labeled('##chk_' .. A1), 'fold again')

-- 切り替え
FAKE.clicks['##route_バストゥーク先'] = true; frame(); frame()
check(labeled('##chk_' .. A1) and not labeled('##chk_' .. B1), 'switched route')
check(texted('バストゥーク先 で進めています'), 'route bar after switch')
-- 済みの記録は消さない
check(app._progress():step_done(Q, B1), 'other route check kept')
-- 今の手順は選んだルートの中
local cur = app._progress():current_step(Q)
check(cur and (cur.route_ja == nil or cur.route_ja == 'バストゥーク先'), 'current step in chosen route: ' .. tostring(cur and cur.id))
