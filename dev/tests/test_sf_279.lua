-- 0.1.279：SF 地図の下バーに、右寄せの「閉じる」を足す。戻るは履歴があるときだけ（クラシックと同じ）
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.308', 'version')

local ms = io.open(ROOT .. '/src/ui/map_sf.lua', 'r'):read('*a')
-- 閉じるボタンがある。ラベルは common.close。動きはクラシックと同じ
check(ms:find("W.button(ui, name, 'close'", 1, true) ~= nil, 'SF map has a close button')
check(ms:find("t('common.close')", 1, true) ~= nil, 'close uses common.close (閉じる)')
check(ms:find("open[1] = false", 1, true) ~= nil, 'close sets open to false')
local i_close = ms:find("W.button(ui, name, 'close'", 1, true)
local i_finish = ms:find("window.finish(ui, name, nil)", 1, true)
local i_cw = ms:find("ui.close_window('map')", i_finish or 1, true)
check(i_close and i_finish and i_cw and i_close < i_finish and i_finish < i_cw,
    'close then finish then close_window(map), same as classic')
-- 0.1.281：閉じるは地図列の右端（窓全体の右端だと右ペインの子窓に重なる）
check(ms:find('sf.set_cursor', 1, true) ~= nil, 'close is placed with sf.set_cursor (screen pos)')
check(ms:find('col_r', 1, true) ~= nil, 'close uses the map-column right edge')
check(ms:find("ui.close_window('map')", 1, true) ~= nil, 'click also calls close_window')
local i_here = ms:find("W.button(ui, name, 'nav_here'", 1, true)
local i_zoom = ms:find("W.button(ui, name, 'zoom_in'", 1, true)
check(i_here and i_zoom and i_close and i_here < i_close and i_zoom < i_close,
    'close sits on the bottom bar after here/zoom')

-- 戻るは履歴があるときだけ。クラシックと同じ条件
local back_sf = ms:find('if info.back and #info.back > 0 then', 1, true)
local i_nav = ms:find("W.button(ui, name, 'nav_back'", 1, true)
check(back_sf ~= nil and i_nav ~= nil and back_sf < i_nav,
    'SF back button is shown only when info.back has history')

local mv = io.open(ROOT .. '/src/ui/map_view.lua', 'r'):read('*a')
local back_cl = mv:find('if info.back and #info.back > 0 then', 1, true)
check(back_cl ~= nil, 'classic also shows back only when there is history')
check(mv:find("W.button(ui, name, 'close', t('common.close')", 1, true) ~= nil,
    'classic map still has its footer close')
-- クラシックの地図は触っていない（SF の右寄せは入れない）
check(not mv:find('rest - cw', 1, true), 'classic map_view close layout is unchanged')

print('test_sf_279 ok')
