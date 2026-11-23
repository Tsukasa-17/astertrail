-- 0.1.299: 隠す場面のわかりやすい名前と i の説明、説明の行を i へ、値と単位は 1 行、「表示言語：」の「：」
require('fake_env')
local json = require('src.lib.json')
local W = require('src.ui.widgets')
local focus = require('src.ui.focus')
local imgui = package.loaded['imgui']

local f = io.open(ROOT .. '/locales/ja.json', 'rb'); local ja = json.decode(f:read('*a')); f:close()
eq(ja['settings.hide_scene_event'], 'イベント中に隠す', 'event label')
eq(ja['settings.hide_scene_combat'], '戦闘中に隠す', 'combat label')
eq(ja['settings.hide_scene_talk'], '会話中に隠す', 'talk label')
eq(ja['settings.hide_scene_menu'], 'メニューを開いたときに隠す', 'menu label')
eq(ja['settings.hide_scene_chat'], 'チャット入力中に隠す', 'chat label')
for _, sc in ipairs({ 'event', 'combat', 'talk', 'menu', 'chat' }) do
    local tip = ja['settings.hide_scene_' .. sc .. '_tip']
    check(type(tip) == 'string' and tip:find('下でチェックしたものを消します', 1, true), 'tip ' .. sc)
end
check(ja['settings.hide_scene_combat_tip']:find('武器を構えて', 1, true), 'combat tip says weapon drawn')
check(ja['settings.hide_scene_talk_tip']:find('はい／いいえ', 1, true), 'talk tip mentions other yes/no')
check(ja['settings.reduce_motion_tip']:find('選んだ枠', 1, true), 'reduce motion tip')

-- 値と単位：決まった幅に右よせ。どの値でも行の操作の位置は同じ。操作の中は折り返さない
local cx, cy = 100, 50
local saved = {}
for _, k in ipairs({ 'GetCursorScreenPos', 'SetCursorScreenPos', 'InvisibleButton', 'PushTextWrapPos', 'SetTooltip', 'IsItemHovered' }) do saved[k] = imgui[k] end
local resets, wraps, tips, hov_next = {}, {}, {}, false
imgui.GetCursorScreenPos = function () return { cx, cy } end
imgui.SetCursorScreenPos = function (p) cx, cy = p[1], p[2] end
imgui.InvisibleButton = function (label)
    if tostring(label):find('_reset', 1, true) then resets[#resets + 1] = cx end
    hov_next = tostring(label):find('##info_', 1, true) ~= nil and FAKE.hover_info == true
    return false
end
imgui.IsItemHovered = function () return hov_next end
imgui.PushTextWrapPos = function (x) wraps[#wraps + 1] = x end
local saved_tooltip = W.tooltip
W.tooltip = function (_, s) tips[#tips + 1] = s end
local fui = { imgui = imgui, t = function (k) return k end }
local function row(id, v)
    W.slider(fui, 'settings', id, '名前の位置（上下）', { v = v }, 'v', { step = 1, lo = -128, hi = 128, default = 0,
        text = function (x) return string.format('%+d px', x) end,
        form_right = true, form_inner = 360, form_gap = 12, form_value_w = 72, section = 'page', slider_w = 120 })
end
row('pos_a', 0); row('pos_b', -64); row('pos_c', -128)
eq(resets[1], resets[2], 'same control x for 0 and -64')
eq(resets[2], resets[3], 'same control x for -128')
local nowrap = false
for _, x in ipairs(wraps) do if x == -1 then nowrap = true end end
check(nowrap, 'value and unit never wrap inside the control')
-- i に乗せると説明
FAKE.hover_info = true
W.switch(fui, 'settings', 'sw_i', 'イベント中に隠す', true, { form_right = true, form_inner = 360, section = 'page', info = 'TIP-EVENT' })
FAKE.hover_info = false
check(tips[#tips] == 'TIP-EVENT', 'hover the i: tooltip')
-- パッドで行を選ぶと説明
tips = {}
focus.set('settings', 'sw_i2', false, 'nav')
W.switch(fui, 'settings', 'sw_i2', 'チャット入力中に隠す', false, { form_right = true, form_inner = 360, section = 'page', info = 'TIP-CHAT' })
check(tips[#tips] == 'TIP-CHAT', 'pad focus: tooltip')
for k, v in pairs(saved) do imgui[k] = v end
W.tooltip = saved_tooltip

-- アプリ：アストラルの GENERAL は「表示言語」「テーマ」（「：」の切れ端が残らない）
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
eq(app.VERSION, '1.1.318', 'version')
FAKE.player = { name = 'Info299', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
S.look = 'sf'; require('src.ui.theme').set_look('sf')
app.open_window('settings'); frame(); frame()
require('src.ui.settings_ui').select_tab('look'); frame(); frame()
local function exact(s) for _, x in ipairs(FAKE.texts) do if x == s then return true end end return false end
check(exact('表示言語'), 'language label exact')
check(exact('テーマ'), 'theme label exact')
for _, x in ipairs(FAKE.texts) do
    check(not x:find('表示言語\239', 1, true) and not x:find('テーマ\239', 1, true), 'no broken colon bytes: ' .. x)
end
-- 説明の行は出さず、i の説明へ（DISPLAY の対象名の説明・トラッカーの★の説明）
require('src.ui.settings_ui').select_tab('marks'); frame(); frame()
require('src.ui.settings_ui').select_tab('input'); frame(); frame()
check(texted('イベント中に隠す') and texted('メニューを開いたときに隠す'), 'clear scene labels (astral)')
check(not texted('「クエストの対象名」はクエストに関わる'), 'names help is not a text line')
check(not texted('オンの場面では'), 'hide scenes help is not a text line (astral)')
require('src.ui.settings_ui').select_tab('marks'); frame(); frame()
-- 0.1.300：POSITION のスライダーは箱で同じ幅（テストの窓は狭いので最小 120 より小さくなる）
do
    local ig = package.loaded['imgui']
    local sw0, sl0 = ig.SetNextItemWidth, ig.SliderFloat
    local nw, ws = nil, {}
    ig.SetNextItemWidth = function (w) nw = w; if sw0 then return sw0(w) end end
    ig.SliderFloat = function (label, ...) ws[tostring(label)] = nw; return sl0(label, ...) end
    frame(); frame()
    ig.SetNextItemWidth, ig.SliderFloat = sw0, sl0
    local first, n = nil, 0
    for lab, w in pairs(ws) do
        if lab:find('marks_obj_', 1, true) or lab:find('marks_near_', 1, true) or lab:find('marks_mark_', 1, true) or lab:find('marks_label_d', 1, true) then
            n = n + 1
            first = first or w
            eq(w, first, 'POSITION slider width shared: ' .. lab)
        end
    end
    check(n >= 4, 'POSITION sliders seen: ' .. n)
    check(first and first >= 48, 'slider has a usable width: ' .. tostring(first))
end
local tip_seen = {}
W.tooltip = function (_, s) tip_seen[#tip_seen + 1] = s end
focus.set('settings', 'marks_objects', false, 'nav'); frame()
local found = false
for _, s in ipairs(tip_seen) do if s:find('「クエストの対象名」', 1, true) then found = true end end
check(found, 'names help shown as tooltip when the row is selected by pad')
-- まとまり：色・グラデーション・終わりの色／背景色・背景グラデーション・背景の終わりの色は中に線なし
do
    local rules = {}
    local wrapped = {}
    for _, fn in ipairs({ 'switch', 'slider', 'color_row' }) do
        local orig = W[fn]; wrapped[fn] = orig
        W[fn] = function (u, win, id, label, a, b, c, d)
            local o = (fn == 'switch') and b or ((fn == 'slider') and c or d)
            if type(o) == 'table' and o.form_right then rules[id] = o.form_rule == true end
            return orig(u, win, id, label, a, b, c, d)
        end
    end
    S.marks.label_grad = true; S.marks.label_bg_grad = true
    frame(); frame()
    for fn, orig in pairs(wrapped) do W[fn] = orig end
    eq(rules['marks_label_color'], false, 'label color: first row after the sample (subhead)')
    eq(rules['marks_label_grad'], false, 'no line between 色 and グラデーション')
    eq(rules['marks_label_color2'], false, 'no line before 終わりの色')
    -- 0.1.301〜：背景の濃さは背景のまとまりの先頭（線はその前だけ）
    eq(rules['marks_label_bg_alpha'], true, 'line between the two groups (before 背景の濃さ)')
    eq(rules['marks_label_bg_color'], false, 'no line between 背景の濃さ and 背景色')
    eq(rules['marks_label_bg_grad'], false, 'no line inside the background group')
    eq(rules['marks_label_bg_color2'], false, 'no line before 背景の終わりの色')
    S.marks.obj_bg_grad = true
    eq(rules['marks_obj_bg_alpha'] ~= false, true, 'object: density opens its bg group')
    eq(rules['marks_label_stroke_alpha'], false, 'stroke group')
    eq(rules['marks_ring_main'] ~= nil and rules['marks_ring_progress'], false, 'ring colors: no lines inside')
end
require('src.ui.settings_ui').select_tab('tracker'); frame(); frame()
check(not texted('本の★からも切り替えられます'), 'tracker help is not a text line')
require('src.ui.settings_ui').select_tab('save'); frame(); frame()
check(texted('Based on YunaUI'), 'about text stays')
W.tooltip = saved_tooltip
app.close_all(); frame()
-- クラシック：わかりやすい名前（説明の文はそのまま）
S.look = 'classic'; require('src.ui.theme').set_look('classic')
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('input'); frame(); frame()
check(texted('イベント中に隠す') or labeled('イベント中に隠す'), 'classic scene label')
app.close_all(); frame()

-- 0.1.300：説明のツールチップは設定の本文と同じ大きさで、折り返す
do
    eq(W.tooltip_wrap_w(16, 400), 224, 'narrow window: at least 14 chars')
    eq(W.tooltip_wrap_w(16, 1000), 400, '40% of the window')
    eq(W.tooltip_wrap_w(32, 3000), 960, '4K: capped at 30 full-width chars')
    local calls = {}
    local keep = {}
    for _, k in ipairs({ 'BeginTooltip', 'EndTooltip', 'SetWindowFontScale', 'GetFontSize', 'PushTextWrapPos', 'PopTextWrapPos', 'GetWindowSize', 'TextColored' }) do keep[k] = imgui[k] end
    local fsz, scale = 26, 1
    imgui.GetFontSize = function () return fsz end
    imgui.GetWindowSize = function () return 1000, 600 end
    imgui.BeginTooltip = function () calls[#calls + 1] = 'begin'; fsz = 13; return true end
    imgui.EndTooltip = function () calls[#calls + 1] = 'end' end
    imgui.SetWindowFontScale = function (s) scale = s; calls[#calls + 1] = 'scale ' .. string.format('%.2f', s) end
    imgui.PushTextWrapPos = function (x) calls[#calls + 1] = 'wrap ' .. tostring(x) end
    imgui.TextColored = function (c, s) calls[#calls + 1] = 'text ' .. s end
    W.tooltip({ imgui = imgui }, '一段落目\n\n二段落目')
    imgui.GetFontSize, imgui.BeginTooltip = keep.GetFontSize, keep.BeginTooltip
    for k, v in pairs(keep) do imgui[k] = v end
    local all = table.concat(calls, '|')
    check(all:find('scale 2.00', 1, true), 'tooltip text scaled to the settings font size: ' .. all)
    check(all:find('wrap 400', 1, true), 'wraps at 40% of the settings window: ' .. all)
    check(all:find('text 一段落目', 1, true) and all:find('text 二段落目', 1, true), 'two paragraphs')
    check(not all:find('\n', 1, true), 'no raw newlines left')
end
