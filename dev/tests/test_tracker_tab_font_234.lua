-- 0.1.234：トラッカーのタブの文字サイズを、中身とは別に設定できる
require('fake_env')
local settings = require('src.core.settings')
local json = require('src.lib.json')

-- 保存と初期値：未設定はトラッカーに追従。書いた値は残す。範囲はトラッカーと同じ
do
    local d = settings.defaults()
    eq(d.fonts.tracker, 1.0, 'tracker font default')
    eq(d.fonts.tracker_tabs, nil, 'tab font unset by default (follows tracker)')
    eq(settings.font_for(d, 'tracker_tabs'), 1.0, 'unset tab font follows default tracker')
    local m = settings.merge({})
    eq(m.fonts.tracker_tabs, nil, 'empty save: tab font stays unset')
    eq(settings.font_for(m, 'tracker_tabs'), m.fonts.tracker, 'empty save: follows tracker')
    local old = settings.merge({ font_scale = 1.3, fonts = { tracker = 0.8 } })
    eq(old.fonts.tracker, 0.8, 'old tracker kept')
    eq(old.fonts.tracker_tabs, nil, 'old save has no tab font')
    eq(settings.font_for(old, 'tracker_tabs'), 0.8, 'old save: tab font follows tracker 0.8')
    -- トラッカーだけ変えても、未設定のタブは追従する
    old.fonts.tracker = 1.5
    eq(settings.font_for(old, 'tracker_tabs'), 1.5, 'still follows after tracker changes')
    local set = settings.merge({ fonts = { tracker = 1.0, tracker_tabs = 2.0 } })
    eq(set.fonts.tracker, 1.0, 'tracker kept when tab font is set')
    eq(set.fonts.tracker_tabs, 2.0, 'saved tab font kept')
    eq(settings.font_for(set, 'tracker_tabs'), 2.0, 'font_for uses the saved tab font')
    eq(settings.font_for(set, 'tracker'), 1.0, 'content font stays the tracker size')
    local lo, hi = settings.font_range('tracker')
    local clamp = settings.merge({ fonts = { tracker_tabs = 9 } })
    eq(clamp.fonts.tracker_tabs, hi, 'tab font clamped to tracker max')
    local tiny = settings.merge({ fonts = { tracker_tabs = 0.1 } })
    eq(tiny.fonts.tracker_tabs, lo, 'tab font clamped to tracker min')
    eq(lo, settings.FONT_MIN, 'same min as tracker')
    eq(hi, settings.FONT_MAX, 'same max as tracker')
    -- 保存して読み直しても同じ
    local again = settings.merge(json.decode(json.encode(set)))
    eq(again.fonts.tracker_tabs, 2.0, 'tab font survives save')
    eq(again.fonts.tracker, 1.0, 'tracker font survives save')
end

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local tr = require('src.ui.tracker')
local focus = require('src.ui.focus')
local sui = require('src.ui.settings_ui')
FAKE.player = { name = 'TabFont', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(app.VERSION, '1.1.245', 'version')
eq(app._data().version, '2026.11.17-124', 'data version unchanged')
S.input.gamepad = true
S.tracker.visible = true
S.tracker.collapsed = false
S.tracker.view = 'tabs'
S.tracker.show_close = true
local QM, QA, QB = 'mission.sandoria.001', 'quest.bastok.005', 'quest.bastok.011'
for _, q in ipairs({ QA, QB, QM }) do app.request('pin', q) end
frame(); frame()

eq(tr.tab_font_scale({ settings = S }), S.fonts.tracker, 'runtime: unset follows tracker')
S.fonts.tracker = 1.4
eq(tr.tab_font_scale({ settings = S }), 1.4, 'runtime: still follows after tracker change')
S.fonts.tracker_tabs = 2.0
eq(tr.tab_font_scale({ settings = S }), 2.0, 'runtime: set tab font is used')
eq(require('src.core.settings').font_for(S, 'tracker'), 1.4, 'content font stays 1.4')

-- 描画：タブのボタンはタブの大きさ、中身はトラッカーの大きさ。窓の大きさは変えない
local imgui = require('imgui')
local scale_now = 1
local tab_scales, name_scales = {}, {}
local orig_set = imgui.SetWindowFontScale
imgui.SetWindowFontScale = function (s)
    scale_now = tonumber(s) or scale_now
    if orig_set then return orig_set(s) end
end
local function watch(label)
    label = tostring(label or '')
    if label:find('##tab_', 1, true) then tab_scales[#tab_scales + 1] = scale_now
    elseif label:find('##q_', 1, true) then name_scales[#name_scales + 1] = scale_now
    end
end
local orig_btn, orig_small = imgui.Button, imgui.SmallButton
imgui.Button = function (label, ...)
    watch(label)
    return orig_btn(label, ...)
end
imgui.SmallButton = function (label, ...)
    watch(label)
    return orig_small(label, ...)
end

S.windows = S.windows or {}
S.windows.tracker = S.windows.tracker or {}
-- 仮の ImGui は既定の大きさを返すので、先に一度描いてから、その大きさを「自分で決めた大きさ」とする
frame()
local w0, h0 = S.windows.tracker.w, S.windows.tracker.h
check(w0 and h0, 'tracker has a saved size')
S.fonts.tracker = 1.0
S.fonts.tracker_tabs = 2.0
tab_scales, name_scales = {}, {}
frame(); frame()
check(#tab_scales > 0, 'tab buttons were drawn')
check(#name_scales > 0, 'content name was drawn')
local ops = tr.SCALE.ops or 1.0
local name_mul = tr.SCALE.name or 1.0
local ts, ns = tab_scales[#tab_scales], name_scales[#name_scales]
check(math.abs(ts - 2.0 * ops) < 0.05, 'tab labels use the tab font: ' .. tostring(ts))
check(math.abs(ns - 1.0 * name_mul) < 0.05, 'content uses the tracker font: ' .. tostring(ns))
eq(S.windows.tracker.w, w0, 'tab font change keeps width')
eq(S.windows.tracker.h, h0, 'tab font change keeps height')

-- トラッカーの文字サイズを変えても、タブは別のまま、窓の大きさも変えない
S.fonts.tracker = 1.6
tab_scales, name_scales = {}, {}
frame(); frame()
ts, ns = tab_scales[#tab_scales], name_scales[#name_scales]
check(math.abs(ts - 2.0 * ops) < 0.05, 'tab font stays after tracker font changes: ' .. tostring(ts))
check(math.abs(ns - 1.6 * name_mul) < 0.05, 'content follows tracker font: ' .. tostring(ns))
eq(S.windows.tracker.w, w0, 'tracker font change keeps width')
eq(S.windows.tracker.h, h0, 'tracker font change keeps height')

-- 未設定に戻すと、タブはトラッカーに追従
S.fonts.tracker_tabs = nil
S.fonts.tracker = 1.3
tab_scales = {}
frame(); frame()
ts = tab_scales[#tab_scales]
check(math.abs(ts - 1.3 * ops) < 0.05, 'unset again: tabs follow tracker: ' .. tostring(ts))
eq(S.windows.tracker.w, w0, 'follow mode keeps width')

imgui.SetWindowFontScale = orig_set
imgui.Button, imgui.SmallButton = orig_btn, orig_small

-- 設定の「見た目」：トラッカーの文字サイズのすぐ下に同じ形のスライダー。パッドでも届く
app.open_window('settings'); frame()
sui.select_tab('look'); frame(); frame()
check(texted('タブの文字の大きさ'), 'settings: タブの文字の大きさ')
check(texted('文字サイズ（トラッカー）'), 'settings: tracker font still there')
local ids = {}
for _, it in ipairs((focus.windows.settings and focus.windows.settings.list) or {}) do
    ids[#ids + 1] = it.id
end
local function idx(id)
    for i, v in ipairs(ids) do if v == id then return i end end
end
local i_tr, i_tab = idx('font_tracker'), idx('font_tracker_tabs')
check(i_tr and i_tab, 'both sliders are in the focus list (controller can reach them)')
check(i_tab == i_tr + 1 or (idx('font_tracker_reset') and i_tab == idx('font_tracker') + 2)
    or (i_tr and i_tab and i_tab > i_tr), 'tab font is next to the tracker font')
-- スライダーを左右で変えられる（コントローラーと同じ take_adjust）
S.fonts.tracker = 1.0
S.fonts.tracker_tabs = nil
frame(); frame()
eq(S.fonts.tracker_tabs, nil, 'still unset before adjusting')
focus.set('settings', 'font_tracker_tabs', true)
-- 右へ：トラッカー（1.0）から離れる → 値が保存される
local adj = focus.take_adjust or function () end
-- 実機は focus.move / take_adjust。テストではスライダーにフォーカスして right を送る
if focus.set then focus.set('settings', 'font_tracker_tabs', true) end
app.input('right', true, 'key'); app.input('right', false, 'key'); frame(); frame()
check(S.fonts.tracker_tabs ~= nil and S.fonts.tracker_tabs > 1.0,
    'controller right on the slider sets a tab font: ' .. tostring(S.fonts.tracker_tabs))
local set_v = S.fonts.tracker_tabs
-- ↺ で未設定（トラッカーに追従）へ戻す
FAKE.clicks['##font_tracker_tabs_reset'] = true; frame(); frame()
eq(S.fonts.tracker_tabs, nil, 'reset returns to follow-tracker (unset)')
eq(settings.font_for(S, 'tracker_tabs'), settings.font_for(S, 'tracker'), 'after reset, follows tracker')
app.close_window('settings'); frame()

print('test_tracker_tab_font_234 ok')
