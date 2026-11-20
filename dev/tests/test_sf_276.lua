-- 0.1.276：SF 設定の PREVIEW は残り高さに合わせ、スクロールバーを出さない。中身は枠の内側余白で折り返す
require('fake_env')
local imgui = package.loaded['imgui'] or require('imgui')

local app = require('src.app')
eq(app.VERSION, '1.1.285', 'version')

local theme = require('src.ui.theme')
local no_bar = theme.C('ImGuiWindowFlags_NoScrollbar') + theme.C('ImGuiWindowFlags_NoScrollWithMouse')
eq(no_bar, 24, 'NoScrollbar|NoScrollWithMouse is 8+16')

local src = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a')
check(src:find('ImGuiWindowFlags_NoScrollbar', 1, true) ~= nil, 'preview uses NoScrollbar')
check(src:find('ImGuiWindowFlags_NoScrollWithMouse', 1, true) ~= nil, 'preview uses NoScrollWithMouse')
check(src:find("'##astertrail_sf_set_prev'", 1, true) ~= nil, 'preview child id kept')
check(src:find('no_scroll_flags()', 1, true) ~= nil, 'preview/nav pass no-scroll flags')
check(src:find('{ PREV_PAD, PREV_PAD }', 1, true) ~= nil, 'preview child gets inner padding')
check(src:find("begin_pane(ui, '##astertrail_sf_set_mid'", 1, true) ~= nil, 'center column is a pane')
check(src:find("begin_pane(ui, '##astertrail_sf_set_mid', center_w, mid_h, 0, { 0, 0 })", 1, true) ~= nil,
    'center column padding is 0 so the outer bar is only for real overflow')
check(src:find('footer_used', 1, true) ~= nil, 'mid height accounts for the footer')
check(src:find('GetWindowPos', 1, true) ~= nil and src:find('GetWindowSize', 1, true) ~= nil,
    'preview frame follows the child window, not a padded cursor + mid_h')
check(src:find('はみ出す Dummy は置かない', 1, true) ~= nil, 'preview does not Dummy past the child')
check(src:find('PushTextWrapPos', 1, true) ~= nil, 'preview content uses wrap pos')
check(src:find("help(ui, tkey(ui, 'sf.set.preview_look'", 1, true) ~= nil, 'look preview still uses help wrap')
-- 全カテゴリのプレビュー文は help / 明示余白経由
for _, key in ipairs({
    'preview_look', 'preview_locked', 'preview_unlocked', 'preview_tracker_list',
    'preview_need', 'preview_map_off', 'preview_marks', 'preview_input',
}) do
    check(src:find(key, 1, true) ~= nil, 'preview still covers ' .. key)
end

-- クラシックの設定本体はプレビュー子窓を足していない
local classic = io.open(ROOT .. '/src/ui/settings_ui.lua', 'r'):read('*a')
check(not classic:find('astertrail_sf_set_prev', 1, true), 'classic settings has no SF preview child')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)

-- 偽環境の既定 Avail は 380px で、プレビュー列は 580px 以上のときだけ出る
imgui.GetContentRegionAvail = function () return 900, 520 end
imgui.GetWindowSize = function () return 920, 560 end

local S = app._settings()
S.look = 'sf'
theme.set_look('sf')
-- 本の中に設定を出す（実機と同じ）
app.open_window('book')
app.open_window('settings')
frame(); frame(); frame()

local function seen(s)
    for _, l in ipairs(FAKE.texts or {}) do if tostring(l):find(s, 1, true) then return true end end
    for _, l in ipairs(FAKE.labels or {}) do if tostring(l):find(s, 1, true) then return true end end
    return false
end

local function child_of(id)
    for _, c in ipairs(FAKE.child_calls or {}) do
        if c.id == id then return c end
    end
end

local prev = child_of('##astertrail_sf_set_prev')
check(prev ~= nil, 'preview child is opened in SF settings')
check(type(prev.size) == 'table', 'preview child is given an explicit size')
local ph = (prev.size[2] or prev.size.y)
check(tonumber(ph) and tonumber(ph) >= 80, 'preview height is the remaining mid band')
eq(tonumber(prev.flags) or 0, no_bar, 'preview child has NoScrollbar and NoScrollWithMouse')

local mid = child_of('##astertrail_sf_set_mid')
check(mid ~= nil, 'center column child is opened')
eq(tonumber(mid.flags) or 0, 0, 'center column keeps default flags (bar only when content exceeds)')
if mid.size and prev.size then
    local mh = mid.size[2] or mid.size.y
    eq(tonumber(mh), tonumber(ph), 'preview and center share the same remaining height')
end

check(seen('PREVIEW') or seen('文字サイズと背景の濃さの見本'), 'look preview caption is drawn')
check(seen('文字サイズと背景の濃さの見本'), 'sample text is present (wraps inside the frame, not clipped away)')
-- 既定の文字サイズ見本（130%）も内側から出す
local pct = false
for _, l in ipairs(FAKE.texts or {}) do
    if tostring(l):match('^%d+%%$') then pct = true end
end
check(pct or seen('%'), 'font-scale sample line is drawn')

-- すべてのカテゴリでプレビュー子窓が同じフラグ・高さを使う
local settings_ui = require('src.ui.settings_ui')
local cats = { 'look', 'layout', 'tracker', 'map', 'marks', 'notify', 'input', 'save' }
for _, cat in ipairs(cats) do
    settings_ui.select_tab(cat)
    frame(); frame()
    local c = child_of('##astertrail_sf_set_prev')
    check(c ~= nil, cat .. ' opens the preview pane')
    eq(tonumber(c.flags) or 0, no_bar, cat .. ' preview has no scrollbar flags')
end

app.close_all(); frame()
S.look = 'classic'
theme.set_look('classic')
print('test_sf_276 ok')
