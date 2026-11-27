-- 1.1.327：頭上の印の照合を 0.25 秒ごと（4回/秒）に間引く。描画と位置の追従は毎フレーム。
require('harness')
local marks = require('src.ui.marks')

eq(marks.MATCH_EVERY, 0.25, 'match interval is 0.25s')

local src = io.open(ROOT .. '/astertrail.lua', 'r'):read('*a')
check(src:find("addon.version = '1.1.327'", 1, true), 'addon.version')
src = io.open(ROOT .. '/src/app.lua', 'r'):read('*a')
check(src:find("VERSION = '1.1.327'", 1, true), 'app.VERSION')

marks.clear_match_cache()

-- follow_matched：同じ番号の相手は、新しい座標の表に付け直す。消えた相手は外す。新しい相手は足さない。
local e1 = { index = 1, name = 'Npc A', x = 0, y = 0, z = 0 }
local prev = { { entity = e1, wanted = { { name = 'Npc A', role = 'talk' } }, rank = 1 } }
local e1b = { index = 1, name = 'Npc A', x = 10, y = 20, z = 3 }
local e2 = { index = 2, name = 'Npc B', x = 1, y = 1, z = 1 }
local out = marks.follow_matched(prev, { e1b, e2 })
eq(#out, 1, 'follow keeps only previously matched')
eq(out[1].entity, e1b, 'follow rebinds to current entity')
eq(out[1].entity.x, 10, 'follow uses current position')
local gone = marks.follow_matched(out, { e2 })
eq(#gone, 0, 'follow drops disappeared entity')

-- match_cached：0.25 秒以内は新しい相手を足さない。位置は追う。
marks.clear_match_cache()
local wanted = { { name = 'Npc A', role = 'talk' } }
local ui = { state = { now = 100 } }
local first = marks.match_cached(ui, wanted, { e1 }, { zone_id = 230 }, 230)
eq(#first, 1, 'first match finds the entity')
eq(first[1].entity.index, 1, 'first match index')

ui.state.now = 100.1
local mid = marks.match_cached(ui, wanted, { e1b, e2 }, { zone_id = 230 }, 230)
eq(#mid, 1, 'within interval: no new match yet')
eq(mid[1].entity, e1b, 'within interval: position follows')
eq(mid[1].entity.x, 10, 'within interval: x updated')

ui.state.now = 100.25
local later = marks.match_cached(ui, wanted, { e1b, { index = 3, name = 'Npc A', x = 8, y = 8, z = 0 } }, { zone_id = 230 }, 230)
eq(#later, 2, 'after 0.25s: rematch adds the new same-name entity')

-- ゾーンが変わったらすぐ照合し直す
marks.clear_match_cache()
ui.state.now = 200
local wzone = { { name = 'Npc A', role = 'talk' } }
local a = marks.match_cached(ui, wzone, { e1 }, { zone_id = 230 }, 230)
eq(#a, 1, 'zone A match')
ui.state.now = 200.05
local b = marks.match_cached(ui, wzone, { { index = 9, name = 'Npc A', x = 2, y = 2, z = 0 } }, { zone_id = 231 }, 231)
eq(#b, 1, 'zone change rematches immediately')
eq(b[1].entity.index, 9, 'zone change uses the new zone entity')

-- 探す相手の一覧が変わったら（進行・設定の変化）すぐ照合し直す
marks.clear_match_cache()
ui.state.now = 300
local w1 = { { name = 'Npc A', role = 'talk' } }
local c = marks.match_cached(ui, w1, { e1, e2 }, { zone_id = 230 }, 230)
eq(#c, 1, 'wanted A only')
ui.state.now = 300.05
local w2 = { { name = 'Npc A', role = 'talk' }, { name = 'Npc B', role = 'talk' } }
local d = marks.match_cached(ui, w2, { e1, e2 }, { zone_id = 230 }, 230)
eq(#d, 2, 'wanted list change rematches immediately')

-- draw は match_cached を使い、marks_core.match を毎フレーム直接は呼ばない
local draw_src = io.open(ROOT .. '/src/ui/marks.lua', 'r'):read('*a')
local i = draw_src:find('function marks.draw(ui)', 1, true)
check(i ~= nil, 'draw exists')
local body = draw_src:sub(i)
local j = body:find('\nfunction ', 2)
if j then body = body:sub(1, j) end
check(body:find('marks.match_cached', 1, true) ~= nil, 'draw uses match_cached')
check(not body:find('marks_core.match(', 1, true), 'draw does not call marks_core.match directly')

print('test_327 ok')
