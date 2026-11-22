-- 0.1.274：SF 設定は2列フォーム（名前左・操作右でそろえる）。詳細の REWARD|LOCATION に縦線、下段は中身の高さ
require('fake_env')
local imgui = package.loaded['imgui'] or require('imgui')

local app = require('src.app')
eq(app.VERSION, '1.1.308', 'version')

local W = require('src.ui.widgets')
local theme = require('src.ui.theme')
local json = require('src.lib.json')

local ss = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a')
check(ss:find('form_label_w', 1, true) ~= nil, 'settings_sf uses form_label_w')
check(ss:find('form_cat', 1, true) ~= nil, 'label column is shared in the category')
check(ss:find('form_note', 1, true) ~= nil, 'labels are measured for the column width')
check(ss:find('form_value_w', 1, true) ~= nil, 'slider values have a fixed width')

local bs = io.open(ROOT .. '/src/ui/book_sf.lua', 'r'):read('*a')
check(bs:find('bottom_fit', 1, true) ~= nil, 'detail bottom height is measured')
check(bs:find('split * 0.5', 1, true) ~= nil or bs:find('split * 0.5', 1, false) ~= nil, 'vertical rule sits in the gap')
check(bs:find('sf.vline', 1, true) ~= nil, 'vertical divider uses sf.vline')
-- クラシックの詳細は触らない
local ds = io.open(ROOT .. '/src/ui/detail.lua', 'r'):read('*a')
check(not ds:find('bottom_fit', 1, true), 'classic detail has no SF bottom_fit')

check(type(W._form_start) == 'function', 'form_start is exported')
check(type(W._form_end) == 'function', 'form_end is exported')

-- 短い名前と長い名前で、操作の開始 x が同じ
do
    local cur = { x = 10, y = 40 }
    local texts, cursors = {}, {}
    local im = setmetatable({
        GetCursorScreenPos = function () return cur.x, cur.y end,
        SetCursorScreenPos = function (p)
            if type(p) == 'table' then cur.x, cur.y = p[1] or p.x, p[2] or p.y end
            cursors[#cursors + 1] = { cur.x, cur.y }
        end,
        GetItemRectMax = function () return cur.x + 8, cur.y + 16 end,
        AlignTextToFramePadding = function () end,
        Text = function (s) texts[#texts + 1] = s end,
        CalcTextSize = imgui.CalcTextSize,
    }, { __index = function () return function () end end })
    local ui = { imgui = im }
    local a = W._form_start(ui, im, '本', { form_label_w = 100, form_gap = 8 })
    local ax = cur.x
    cur.x, cur.y = 10, 80
    local b = W._form_start(ui, im, 'とても長い設定の名前', { form_label_w = 100, form_gap = 8 })
    local bx = cur.x
    check(a ~= nil and b ~= nil, 'form_start returns a row')
    eq(ax, 10 + 100 + 8, 'short label: controls start at label_w + gap')
    eq(bx, 10 + 100 + 8, 'long label: controls start at the same x')
    eq(ax, bx, 'control column x is identical')
    -- 列幅を超える名前は折り返す（1行の幅に収めてから操作位置へ戻る）
    check(#texts >= 1, 'labels were drawn')
end

-- クラシックのウィジェットは form なしのまま（名前の直後）
do
    local src = io.open(ROOT .. '/src/ui/widgets.lua', 'r'):read('*a')
    check(src:find('if not form then', 1, true) ~= nil, 'classic path remains when form opts are absent')
    check(src:find('label_fits_or_wrap', 1, true) ~= nil, 'legacy wrap path kept')
end

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)

local function labeled(s)
    for _, l in ipairs(FAKE.labels) do if tostring(l):find(s, 1, true) then return true end end
    return false
end
local function seen(s)
    if labeled(s) then return true end
    for _, l in ipairs(FAKE.texts) do if tostring(l):find(s, 1, true) then return true end end
    return false
end

local S = app._settings()
S.look = 'sf'
theme.set_look('sf')
app.open_window('settings'); frame(); frame(); frame()
check(labeled('画面の文字をくっきり（メイリオ）'), 'look toggles still work in the form')
check(labeled('本の文字') or seen('本の文字') or labeled('縁取りの太さ') or seen('縁取りの太さ'), 'sliders still show labels')

-- クラシックの設定は触っていない
S.look = 'classic'
theme.set_look('classic')
app.close_all(); app.open_window('settings'); frame(); frame(); frame()
check(labeled('画面の文字をくっきり（メイリオ）'), 'classic uses the same settings rows (0.1.304)')

print('test_sf_274 ok')
