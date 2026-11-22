-- 0.1.272：SF 設定から DETAILS をやめ、属するパネルへ移す。プレビューの文字は重ねない
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.300', 'version')

local theme = require('src.ui.theme')
local settings_ui = require('src.ui.settings_ui')
local json = require('src.lib.json')

local sfsrc = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a')
check(not sfsrc:find("title = 'DETAILS'", 1, true), 'no DETAILS panel title')
check(not sfsrc:find('detail = true', 1, true), 'no collapsible detail flag')
check(not sfsrc:find('detail_open', 1, true), 'no detail_open state')
check(not sfsrc:find('DETAILS  ▸', 1, true) and not sfsrc:find('DETAILS  ▾', 1, true), 'no DETAILS toggle buttons')
check(sfsrc:find("title = 'FONT'", 1, true) ~= nil, 'FONT panel exists')
check(sfsrc:find("title = 'POSITION'", 1, true) ~= nil, 'POSITION panel exists')
check(sfsrc:find("title = 'PROGRESS'", 1, true) ~= nil, 'PROGRESS panel exists')
check(sfsrc:find('look_font', 1, true) ~= nil, 'look font panel id')
-- 1.1.300：右のプレビューはやめた
check(not sfsrc:find('draw_preview', 1, true), 'preview pane removed')
check(sfsrc:find('panel_h[id] = h', 1, true) ~= nil, 'panel height follows measured content')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)

local function texted(s)
    for _, l in ipairs(FAKE.texts) do if tostring(l):find(s, 1, true) then return true end end
    return false
end
local function labeled(s)
    for _, l in ipairs(FAKE.labels) do if tostring(l):find(s, 1, true) then return true end end
    return false
end
local function seen(s) return texted(s) or labeled(s) end
-- Melete 見出しは1文字ずつ DrawList に描くので、つなげて探す
local function seen_joined(s)
    if seen(s) then return true end
    local all = table.concat(FAKE.texts or {}) .. table.concat(FAKE.labels or {})
    return all:find(s, 1, true) ~= nil
end

local S = app._settings()
-- クラシックは DETAILS をいじらない（従来の項目のまま）
S.look = 'classic'
theme.set_look('classic')
app.close_all(); app.open_window('settings'); frame(); frame(); frame()
check(labeled('くっきりフォント（テスト）'), 'classic crisp label unchanged')
app.close_all(); frame()

S.look = 'sf'
theme.set_look('sf')
app.open_window('settings'); frame(); frame(); frame()
-- たたまず、すぐ見える
check(labeled('画面の文字をくっきり（メイリオ）'), 'crisp lives in FONT, visible without a click')
check(labeled('太字（メイリオ）') or seen('太字（メイリオ）'), 'bold lives in FONT')
check(labeled('縁取りの太さ') or seen('縁取りの太さ'), 'outline width lives in FONT')
check(labeled('縁取りの濃さ') or seen('縁取りの濃さ'), 'outline alpha lives in FONT')
check(not seen('お知らせと入口のアイコンです'), 'windows help moved into the i tooltip (0.1.299)')
check(seen_joined('FONT'), 'FONT heading is shown')
check(not labeled('DETAILS  ▸') and not labeled('DETAILS  ▾') and not labeled('DETAILS'), 'no DETAILS control on screen')

settings_ui.select_tab('tracker'); frame(); frame()
check(labeled('タブの幅') or seen('タブの幅'), 'tab width is in TRACKER')
check(labeled('右上の × を出す') or seen('右上の × を出す') or labeled('右上の') or seen('右上の'), 'close button toggle is in TRACKER')
check(seen('★を付けたものだけ出す'), 'eminence fold still under tracker')

settings_ui.select_tab('layout'); frame(); frame()
check(labeled('一覧の列の並びと表示を元に戻す') or seen('一覧の列の並びと表示を元に戻す'), 'reset columns lives in BOOK')

settings_ui.select_tab('save'); frame(); frame()
check(labeled('受注フラグのないものを未開始に戻す') or seen('受注フラグのないものを未開始に戻す'), 'reset unstarted lives in PROGRESS')
check(seen_joined('PROGRESS'), 'PROGRESS heading is shown')
check(texted('バージョン ' .. app.VERSION) or labeled('バージョン ' .. app.VERSION), 'version shown')

-- 1.1.300：右のプレビューはやめた（見本の文は出さない）
check(not seen('文字サイズと背景の濃さの見本'), 'no preview sample text')

app.close_all(); frame()
S.look = 'classic'
theme.set_look('classic')
print('test_sf_272 ok')
