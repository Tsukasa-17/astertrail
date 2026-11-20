-- 0.1.234：設定の数値スライダーをドラッグしても値が暴れない。－／＋と左右で1刻み
require('fake_env')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local W = require('src.ui.widgets')
local focus = require('src.ui.focus')
local sui = require('src.ui.settings_ui')
local imgui = require('imgui')
FAKE.player = { name = 'Slider234', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(app.VERSION, '1.1.292', 'version')
eq(app._data().version, '2026.11.20-125', 'data version unchanged')
S.input.gamepad = true

-- 単体：ドラッグ中は書かず、離したとき確定。途中で値が前後しても保存は動かない
do
    local dirty = false
    local ui = {
        imgui = imgui,
        settings = { font_scale = 1 },
        t = function (k) return k end,
        mark_settings_dirty = function () dirty = true end,
    }
    local tbl = { n = 1.0 }
    local opts = {
        step = 0.1, lo = 0.7, hi = 4, default = 1.0,
        text = function (v) return tostring(v) end, section = 'look',
    }
    local want, dragging, last
    local saved_sf, saved_act = rawget(imgui, 'SliderFloat'), rawget(imgui, 'IsItemActive')
    imgui.SliderFloat = function (label, buf)
        last = label
        if want ~= nil then buf[1] = want; return true end
        return false
    end
    imgui.IsItemActive = function ()
        return dragging == true and last == '##n'
    end
    local function slide()
        return W.slider(ui, 'settings', 'n', 'N', tbl, 'n', opts)
    end

    want, dragging = 2.5, true
    dirty = false
    eq(slide(), false, 'drag frame 1: not committed')
    eq(tbl.n, 1.0, 'drag frame 1: stored value stays')
    eq(dirty, false, 'drag frame 1: not dirty')

    -- マウスの下でレイアウトが動いたつもりで値が前後する
    want = 0.7
    eq(slide(), false, 'drag flip small: not committed')
    eq(tbl.n, 1.0, 'drag flip small: stored value stays')
    want = 3.9
    eq(slide(), false, 'drag flip large: not committed')
    eq(tbl.n, 1.0, 'drag flip large: stored value stays')
    want = 2.4
    eq(slide(), false, 'drag last preview: not committed')
    eq(tbl.n, 1.0, 'drag last preview: stored value stays')

    -- 離した：最後のプレビューを確定
    dragging = false
    check(slide() == true, 'release commits')
    eq(tbl.n, 2.4, 'release writes the last preview')
    eq(dirty, true, 'release marks settings dirty')

    -- ドラッグなしで SliderFloat が動いた（クリックやテスト）：すぐ確定
    want, dragging = 1.3, false
    dirty = false
    check(slide() == true, 'inactive move commits immediately')
    eq(tbl.n, 1.3, 'inactive move written')

    imgui.SliderFloat, imgui.IsItemActive = saved_sf, saved_act
end

-- 単体：－／＋は1刻み。端では動かない
do
    local ui = {
        imgui = imgui,
        settings = { font_scale = 1 },
        t = function (k) return k end,
        mark_settings_dirty = function () end,
    }
    local tbl = { n = 1.0 }
    local opts = { step = 0.1, lo = 0.7, hi = 4, default = 1.0, section = 'look' }
    FAKE.clicks['##n_plus'] = true
    check(W.slider(ui, 'settings', 'n', 'N', tbl, 'n', opts) == true, 'plus changes')
    eq(tbl.n, 1.1, 'plus steps +0.1')
    FAKE.clicks['##n_minus'] = true
    check(W.slider(ui, 'settings', 'n', 'N', tbl, 'n', opts) == true, 'minus changes')
    eq(tbl.n, 1.0, 'minus steps -0.1')
    tbl.n = 0.7
    FAKE.clicks['##n_minus'] = true
    eq(W.slider(ui, 'settings', 'n', 'N', tbl, 'n', opts), false, 'minus at min does nothing')
    eq(tbl.n, 0.7, 'stays at min')
    tbl.n = 4.0
    FAKE.clicks['##n_plus'] = true
    eq(W.slider(ui, 'settings', 'n', 'N', tbl, 'n', opts), false, 'plus at max does nothing')
    eq(tbl.n, 4.0, 'stays at max')
end

-- 単体：コントローラーの左右は1刻みですぐ入る（ドラッグ待ちではない）
do
    local ui = {
        imgui = imgui,
        settings = { font_scale = 1 },
        t = function (k) return k end,
        mark_settings_dirty = function () end,
    }
    local tbl = { n = 1.0 }
    local opts = { step = 0.1, lo = 0.7, hi = 4, default = 1.0, section = 'look' }
    local function slide()
        focus.begin('settings')
        local ch = W.slider(ui, 'settings', 'n', 'N', tbl, 'n', opts)
        focus.finish('settings')
        return ch
    end
    slide()
    focus.set('settings', 'n', true)
    check(focus.move('settings', 'right'), 'right is adjust')
    check(slide() == true, 'right applies now')
    eq(tbl.n, 1.1, 'controller right +0.1 immediately')
    check(focus.move('settings', 'left'), 'left is adjust')
    check(slide() == true, 'left applies now')
    eq(tbl.n, 1.0, 'controller left -0.1 immediately')
end

-- 設定の窓：文字サイズスライダーをドラッグしても、離すまでフォントは変わらない
app.open_window('settings'); frame()
sui.select_tab('look'); frame(); frame()
check(labeled('－##font') or labeled('－##font_minus'), 'minus button next to other-font slider')
check(labeled('＋##font') or labeled('＋##font_plus') or labeled('＋##font_book_plus'),
    'plus button next to a font slider')
check(labeled('－##font_tracker') or labeled('－##font_tracker_minus'), 'minus on tracker font')
check(labeled('－##font_tracker_tabs') or labeled('－##font_tracker_tabs_minus'), 'minus on tab font')

S.font_scale = 1.0
S.fonts.book = 1.0
frame()

local last, drag_to, dragging
local scales_during = {}
local saved_sf, saved_act, saved_sfs = rawget(imgui, 'SliderFloat'), rawget(imgui, 'IsItemActive'), rawget(imgui, 'SetWindowFontScale')
imgui.SliderFloat = function (label, buf)
    last = label
    if label == '##font' and drag_to ~= nil then buf[1] = drag_to; return true end
    return false
end
-- SliderFloat の直後の IsItemActive だけをドラッグ扱いにし、ほかの項目は巻き込まない
imgui.IsItemActive = function ()
    if last == '##font' then
        last = nil
        return dragging == true
    end
    return false
end
imgui.SetWindowFontScale = function (s)
    scales_during[#scales_during + 1] = tonumber(s)
    if saved_sfs then return saved_sfs(s) end
end

drag_to, dragging = 2.5, true
scales_during = {}
frame(); frame(); frame()
eq(S.font_scale, 1.0, 'settings font not applied while dragging')
local seen_big = false
for _, s in ipairs(scales_during) do
    if s and s >= 2.0 then seen_big = true end
end
check(not seen_big, 'settings window font stays at the old size while dragging')

-- 離す
dragging = false
scales_during = {}
frame(); frame()
eq(S.font_scale, 2.5, 'settings font applied on release')
imgui.SliderFloat, imgui.IsItemActive, imgui.SetWindowFontScale = saved_sf, saved_act, saved_sfs

-- －／＋を設定の文字サイズに使う
S.font_scale = 1.0
frame()
FAKE.clicks['##font_plus'] = true
frame(); frame()
eq(S.font_scale, 1.1, 'settings plus steps other font +0.1')
FAKE.clicks['##font_minus'] = true
frame(); frame()
eq(S.font_scale, 1.0, 'settings minus steps other font -0.1')

-- 文字以外のスライダー（ピンの数）にも －／＋ があり、1刻み
sui.select_tab('tracker'); frame(); frame()
check(labeled('－##pins') or labeled('－##pins_minus'), 'minus next to max pins')
check(labeled('＋##pins') or labeled('＋##pins_plus'), 'plus next to max pins')
local pins0 = S.tracker.max_pins
FAKE.clicks['##pins_plus'] = true
frame(); frame()
eq(S.tracker.max_pins, pins0 + 1, 'plus steps max pins by 1')
FAKE.clicks['##pins_minus'] = true
frame(); frame()
eq(S.tracker.max_pins, pins0, 'minus steps max pins by 1')

-- パッド：設定のスライダーで左右
sui.select_tab('look'); frame(); frame()
S.fonts.book = 1.0
focus.set('settings', 'font_book', true)
app.input('right', true, 'key'); app.input('right', false, 'key'); frame(); frame()
eq(S.fonts.book, 1.1, 'controller right on book font steps immediately')
app.input('left', true, 'key'); app.input('left', false, 'key'); frame(); frame()
eq(S.fonts.book, 1.0, 'controller left on book font steps immediately')

app.close_window('settings'); frame()
print('test_settings_slider_234 ok')
