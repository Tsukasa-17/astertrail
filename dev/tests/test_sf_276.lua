-- 0.1.276：SF 設定の中央・左ナビは残り高さに合わせる
-- 0.1.300：右の PREVIEW はやめた。中央の箱がその幅を使い、試すボタンは POPUP の箱へ
require('fake_env')
local imgui = package.loaded['imgui'] or require('imgui')

local app = require('src.app')
eq(app.VERSION, '1.1.318', 'version')

local theme = require('src.ui.theme')
local no_bar = theme.C('ImGuiWindowFlags_NoScrollbar') + theme.C('ImGuiWindowFlags_NoScrollWithMouse')
eq(no_bar, 24, 'NoScrollbar|NoScrollWithMouse is 8+16')

local src = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a')
check(not src:find("'##astertrail_sf_set_prev'", 1, true), 'preview child is gone')
check(not src:find('draw_preview', 1, true) and not src:find('PREV_PAD', 1, true), 'preview code removed')
check(src:find('no_scroll_flags()', 1, true) ~= nil, 'nav passes no-scroll flags')
check(src:find("begin_pane(ui, '##astertrail_sf_set_mid', center_w, mid_h, 0, { 0, 0 })", 1, true) ~= nil,
    'center column padding is 0 so the outer bar is only for real overflow')
check(src:find('footer_used', 1, true) ~= nil, 'mid height accounts for the footer')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)

imgui.GetContentRegionAvail = function () return 900, 520 end
imgui.GetWindowSize = function () return 920, 560 end

local S = app._settings()
S.look = 'sf'
theme.set_look('sf')
app.open_window('book')
app.open_window('settings')
frame(); frame(); frame()

local function child_of(id)
    local found
    for _, c in ipairs(FAKE.child_calls or {}) do
        if c.id == id then found = c end
    end
    return found
end
local function labeled(s)
    for _, l in ipairs(FAKE.labels or {}) do if tostring(l):find(s, 1, true) then return true end end
    return false
end

local settings_ui = require('src.ui.settings_ui')
for _, cat in ipairs({ 'look', 'layout', 'tracker', 'map', 'marks', 'notify', 'input', 'save' }) do
    FAKE.child_calls = {}
    settings_ui.select_tab(cat)
    frame(); frame()
    check(child_of('##astertrail_sf_set_prev') == nil, cat .. ' has no preview pane')
    local mid = child_of('##astertrail_sf_set_mid')
    check(mid ~= nil, cat .. ' center column child is opened')
    eq(tonumber(mid.flags) or 0, 0, cat .. ' center keeps default flags')
    local mw = tonumber(mid.size and (mid.size[1] or mid.size.x))
    -- 900 − ナビ 148 − すき間 10 − 4
    eq(mw, 738, cat .. ' center uses the freed width')
    local nav = child_of('##astertrail_sf_set_nav')
    eq(tonumber(nav.flags) or 0, no_bar, cat .. ' nav has no scrollbar flags')
end
-- 試すボタンは POPUP の箱の中に
FAKE.labels = {}
settings_ui.select_tab('notify'); frame(); frame()
check(labeled('##n_popup_try') and labeled('##n_popup_try2'), 'try buttons are in the POPUP box')

app.close_all(); frame()
S.look = 'classic'
theme.set_look('classic')
print('test_sf_276 ok')
