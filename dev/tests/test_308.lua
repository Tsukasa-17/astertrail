-- 0.1.308：本の左の地図ボタンは、閉じているときはいまいるエリアの地図を開く。隠す場面は操作の GAME UI
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
local app = require('src.app')
eq(app.VERSION, '1.1.314', 'version')
FAKE.events.load()
FAKE.player = { name = 'R308', zone = 230, tidx = 5, status = 0 }
frames(1)
-- 選んでいる項目があっても、here ならクエストなしでいまのエリア
app.state.detail_quest = 'quest.bastok.003'
app.open_map(nil, nil, nil, { here = true })
check(app.state.open.map, 'map opened')
eq(app.state.map.quest, nil, 'no quest for here')
eq(app.state.map.loc and app.state.map.loc.zone_id, 230, 'current zone')
-- here でなければ今までどおり選んでいる項目
app.close_window('map')
app.open_map()
eq(app.state.map.quest, 'quest.bastok.003', 'plain open still uses the selected quest')
app.close_window('map')
-- ボタンの関数
local src = io.open(ROOT .. '/src/ui/book_sf.lua', 'r'):read('*a')
local body = src:match('local function toggle_map%(ui%).-\nend\n')
check(body and body:find('{ here = true }', 1, true), 'rail map button opens current zone')
check(body:find("close_window('map')", 1, true), 'button still closes an open map')
print('test_308 ok')
