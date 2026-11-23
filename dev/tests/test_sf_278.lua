-- 0.1.278：SF 地図の案内文を下バーのボタンと重ねない。独立エミネンス窓の行カードは中身に高さ・余白を合わせる
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.318', 'version')

local ms = io.open(ROOT .. '/src/ui/map_sf.lua', 'r'):read('*a')
check(ms:find('map_hint_lines', 1, true) ~= nil, 'hint lines are collected for the bottom bar')
check(ms:find("t('map.map_unknown')", 1, true) ~= nil, 'unknown-map hint is still used')
check(ms:find('CT.wrapped', 1, true) ~= nil, 'hint text is wrapped to width')
check(ms:find('wrap_w', 1, true) ~= nil, 'hint uses a wrap width')
-- 案内はボタンより前（上の行）
local i_hint = ms:find('下バー：案内はボタンの上の独立した行', 1, true)
local i_btn = ms:find("W.button(ui, name, 'nav_here'", i_hint or 1, true)
check(i_hint and i_btn and i_hint < i_btn, 'hint row is drawn above the here/zoom buttons')
-- 上で status_line を出してカーソルをずらさない。下バーで出す
local i_draw = ms:find('function map_sf.draw', 1, true)
local i_status = ms:find('ui.status_line()', i_draw or 1, true)
check(i_status and i_hint and i_status > i_hint, 'status_line is drawn in the bottom hint row, not at the top')
check(ms:find('gap_bar', 1, true) ~= nil, 'gap between map/scale and the bar')
check(ms:find('bar_used', 1, true) ~= nil, 'bar height is remembered so the map shrinks to fit')
check(ms:find('hint_h', 1, true) ~= nil, 'hint height is measured before laying out the map')
check(ms:find('bot_h = gap_bar', 1, true) ~= nil or ms:find('bot_h = gap_bar +', 1, true) ~= nil,
    'bottom bar height grows with the hint')
-- クラシックの地図は従来どおり（先頭で status_line、配置は変えない）
local mv = io.open(ROOT .. '/src/ui/map_view.lua', 'r'):read('*a')
check(mv:find('ui.status_line()', 1, true) ~= nil, 'classic map still has status_line')
check(not mv:find('map_hint_lines', 1, true), 'classic map_view is unchanged')
check(not mv:find('gap_bar', 1, true), 'classic map has no SF bottom-bar layout')


-- 独立エミネンス窓：行カードは固定44pxではなく中身＋内側余白。バーと 14/20 は枠内、☆/❤ は余白の内側
local ew = io.open(ROOT .. '/src/ui/eminence_win_sf.lua', 'r'):read('*a')
check(ew:find('ROW_PAD', 1, true) ~= nil, 'row cards have inner padding')
check(ew:find('row_h[key]', 1, true) ~= nil or ew:find('row_h[key]', 1, true) ~= nil, 'row height is measured')
check(not ew:find('y0 + 44', 1, true), 'row frame is not a fixed 44px')
check(ew:find('x0 + pad', 1, true) ~= nil, 'star/heart start inside the padding')
check(ew:find('sf.bar', 1, true) ~= nil, 'progress bar remains')
check(ew:find('progress_text', 1, true) ~= nil, '14/20 count remains')
check(ew:find('inner_w - cw', 1, true) ~= nil or ew:find('right - pad', 1, true) ~= nil, 'count is right-aligned on the bar line')
check(ew:find('GetFontSize', 1, true) ~= nil, 'padding/height follow the font size')
check(ew:find("open_window('book'", 1, true) == nil, 'still no row-click-to-open-book')
local ev = io.open(ROOT .. '/src/ui/eminence.lua', 'r'):read('*a')
check(not ev:find('ROW_PAD', 1, true), 'classic eminence window is unchanged')

print('test_sf_278 ok')
