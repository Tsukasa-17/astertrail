-- 0.1.272：SF の Melete 見出しの追加字間をなくし、狭い幅では字間を詰める
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.324', 'version')

local sf = require('src.ui.sf_style')
local theme = require('src.ui.theme')
local imgui = require('imgui')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')

local src = io.open(ROOT .. '/src/ui/sf_style.lua', 'r'):read('*a')
check(src:find('8 / 46', 1, true) == nil or src:find('0.1.264〜0.1.268', 1, true) ~= nil, 'old 8/46 ratio is not the live default')
check(src:find('return 0', 1, true) ~= nil, 'heading_track returns 0')
check(src:find('opts.max_w', 1, true) ~= nil, 'measure_heading can shrink to a max width')

-- 以前：title は 46px で 8px、label は 24px で 5px（下限 1px）
-- いま：追加の字間は 0px
eq(sf.heading_track(46, 'title'), 0, 'title tracking is 0px (was 8px at 46px)')
eq(sf.heading_track(24, 'label'), 0, 'label tracking is 0px (was 5px at 24px)')
eq(sf.heading_track(12, 'label'), 0, 'small label tracking is 0px (was floored at 1px)')

local tw0 = select(1, theme.measure_text(imgui, 'ASTERTRAIL'))
local tw1 = select(1, sf.measure_heading(imgui, 'ASTERTRAIL', 'title'))
check(math.abs((tw1 or 0) - (tw0 or 0)) < 0.51, 'logo width matches natural Melete spacing')

local mw0 = select(1, theme.measure_text(imgui, 'MISSION'))
local mw1 = select(1, sf.measure_heading(imgui, 'MISSION', 'label'))
check(math.abs((mw1 or 0) - (mw0 or 0)) < 0.51, 'tab width matches natural Melete spacing')

-- 幅が足りないときは、指定した字間を 0 まで詰めて収める
local wide = select(1, sf.measure_heading(imgui, 'EMINENCE', 'label', { track = 8 }))
local tight = select(1, sf.measure_heading(imgui, 'EMINENCE', 'label', { track = 8, max_w = wide - 20 }))
check(tight <= wide - 20 + 0.51, 'tracking shrinks to fit max_w: ' .. tostring(tight) .. ' <= ' .. tostring(wide - 20))
local natural = select(1, sf.measure_heading(imgui, 'EMINENCE', 'label', { track = 0 }))
check(tight + 0.51 >= natural, 'fit does not go tighter than 0px tracking')

-- 日本語やクラシック経路は触らない
check(not sf.is_en_heading('報酬'), 'Japanese labels stay off the heading tracker')
local bsrc = io.open(ROOT .. '/src/ui/book.lua', 'r'):read('*a')
check(bsrc:find('heading_track', 1, true) == nil, 'classic book does not use SF heading tracking')

---------------------------------------------------------------------------
-- 受注：完了バッジと同じ（暗い半透明の塗り、sf_amber の枠と文字）。解除はそのまま
---------------------------------------------------------------------------
local esrc = io.open(ROOT .. '/src/ui/eminence_sf.lua', 'r'):read('*a')
check(esrc:find('local function action_look', 1, true) ~= nil, 'action_look is present')
check(esrc:find("(op == 'start')", 1, true) ~= nil, 'start branch is present')
-- 0.1.322〜：受注・解除は状態の札の色。完了の札は金（roe_st_done）、塗りは 0.42 のまま
check(esrc:find("'roe_st_open'", 1, true) ~= nil, 'accept uses roe_st_open (0.1.322)')
check(esrc:find('fill_a = 0.42', 1, true) ~= nil, 'done badge fill stays 0.42')
check(esrc:find("theme.u32('ink'", 1, true) == nil, 'accept does not use dark ink text')
check(esrc:find("'roe_st_active'", 1, true) ~= nil, 'remove uses roe_st_active (0.1.322)')
-- 本の完了バッジと同じ枠の出し方（半透明の塗り、金色の枠）
local booksf = io.open(ROOT .. '/src/ui/book_sf.lua', 'r'):read('*a')
check(booksf:find('fill_a = 0.42', 1, true) ~= nil, 'quest/mission done badge uses fill_a 0.42')
check(booksf:find("'sf.badge_done'), 'sf_amber'", 1, true) ~= nil, 'done badge color is sf_amber')

print('test_sf_269 ok')
