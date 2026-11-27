-- 0.1.256：SF 本の余白・次の目標のはみ出し・チップの基準線・詳細の枠
require('fake_env')

local sf = require('src.ui.sf_style')
local util = require('src.lib.util')
local app = require('src.app')
eq(app.VERSION, '1.1.327', 'version')

-- 残り高さは窓の下端とカーソルの差
do
    local im = {
        GetWindowPos = function () return { x = 10, y = 100 } end,
        GetWindowSize = function () return { x = 400, y = 500 } end,
        GetCursorScreenPos = function () return { x = 20, y = 200 } end,
        GetContentRegionAvail = function () return { x = 100, y = 10 } end,
    }
    eq(sf.remain_below(im, 20), 380, 'remain_below uses window bottom minus cursor and reserve')
    eq(sf.remain_below(im, 0), 400, 'remain_below without reserve')
end

check(util.utf8_cut('あいうえお', 3):find('…', 1, true) ~= nil, 'utf8_cut adds ellipsis')

-- 窓の枠は内側へ空けて描く（左端で線が切れない）
local src = io.open(ROOT .. '/src/ui/sf_style.lua', 'r'):read('*a')
check(src:find('px + m', 1, true) ~= nil and src:find('function sf.remain_below', 1, true) ~= nil, 'window frame is inset')
check(src:find('function sf.add_text', 1, true) ~= nil, 'add_text helper exists')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local D = app._data()

-- クラシックはこれまでどおり
S.look = 'classic'
app.close_all(); app.open_window('book'); frame(); frame()
check(labeled('ミッション') or texted('ミッション'), 'classic tab unchanged')
check(not texted('ASTERTRAIL'), 'classic has no logo')

S.look = 'sf'
S.book.tab = 'mission'
app.close_all(); app.open_window('book'); frame(); frame(); frame()
check(texted('ASTERTRAIL'), 'SF logo')
check(texted('MISSION') and texted('QUEST'), 'SF tabs')
FAKE.clicks['##sfcard_mission.bastok.001'] = true
frame(); frame()
check(texted('OBJECTIVE') or labeled('OBJECTIVE'), 'detail after select')
check(texted('REWARD') or labeled('REWARD'), 'REWARD heading')
check(texted('LOCATION') or labeled('LOCATION'), 'LOCATION heading')

-- 絞り込みを開いてもカードと詳細は残る（検索ヒントは切れずに出る）
FAKE.clicks['##sfchip_filters'] = true
frame(); frame()
check(texted('受注中') or labeled('受注中'), 'status chips appear on their own row')
check(texted('サンドリア') or labeled('サンドリア') or texted('バストゥーク') or labeled('バストゥーク'),
    'area chips still appear')
-- 検索欄のヒントは Fake の InputTextWithHint が文字列を残さない。実機では単独行＋広い幅にした。
check(texted('OBJECTIVE') or labeled('OBJECTIVE'), 'detail remains when filters open')
check(texted('REWARD') or labeled('REWARD'), 'REWARD remains below steps when filters open')

print('test_sf_256 ok')
