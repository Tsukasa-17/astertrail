-- 0.1.267：見出しの Melete はくっきり設定に縛られない。受注は sf_amber。
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.324', 'version')

local crisp = require('src.ui.crisp_font')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')

local crisp_src = io.open(ROOT .. '/src/ui/crisp_font.lua', 'r'):read('*a')
-- push_heading 本体が crisp.active で止まらない（コメントに残る言及は除く）
check(crisp_src:find('if not crisp.active(S) then why = \'crisp_inactive\'', 1, true) == nil, 'push_heading is not gated on crisp.active')
check(crisp_src:find("if not heading.ready then why = 'heading_not_ready'", 1, true) ~= nil, 'push_heading still requires heading.ready')
check(crisp_src:find('gate=heading_ready_only', 1, true) ~= nil, 'debug log records the heading-only gate')
check(crisp_src:find('crisp_active=', 1, true) ~= nil, 'debug log still records whether crisp is active')
eq(crisp.heading_rel(), 'fonts/melete/Melete-Bold.ttf', 'heading still prefers the TTF')

local sfsrc = io.open(ROOT .. '/src/ui/eminence_sf.lua', 'r'):read('*a')
-- 0.1.322〜：受注・解除は状態の札の色（roe_st_open／roe_st_active）。乗せる・押すで濃さが変わる
check(sfsrc:find("'roe_st_open'", 1, true) ~= nil, 'accept uses roe_st_open')
check(sfsrc:find('hover and', 1, true) ~= nil, 'accept has a hover shade')
check(sfsrc:find('press and', 1, true) ~= nil, 'accept has a press shade')
check(sfsrc:find("'roe_st_active'", 1, true) ~= nil, 'remove uses roe_st_active')

local th = io.open(ROOT .. '/src/ui/theme.lua', 'r'):read('*a')
check(th:find('sf_amber_hover', 1, true) ~= nil, 'SF palette has amber hover')
check(th:find('sf_amber_press', 1, true) ~= nil, 'SF palette has amber press')

print('test_sf_267 ok')
