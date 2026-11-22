-- 0.1.47: アイコンの文字の色（クエスト名・オブジェクト名）とグラデーション
require('fake_env')
local settings = require('src.core.settings')
local d = settings.defaults().marks
eq(table.concat(d.label_color, ','), '248,244,232', 'quest name default = old color')
eq(table.concat(d.under_color, ','), '248,244,232', 'object name default = old color')
eq(d.label_grad, false, 'gradient off'); eq(d.under_grad, false, 'gradient off 2')
local m = settings.merge({ marks = { label_color = { 300, -5, 'x' }, under_color = { 10, 20, 30 }, under_grad = true } })
eq(table.concat(m.marks.label_color, ','), '248,244,232', 'broken -> default')
eq(table.concat(m.marks.under_color, ','), '10,20,30', 'kept')
eq(m.marks.under_grad, true, 'grad kept'); eq(m.marks.label_grad, false, 'grad default')
local m2 = settings.merge({ marks = { label_color = { 300, -5, 7.4 } } })
eq(table.concat(m2.marks.label_color, ','), '255,0,7', 'clamped and rounded')
local c1, c2 = settings.text_colors({ label_color = { 1, 2, 3 }, label_grad = false, label_color2 = { 9, 9, 9 } }, 'label')
eq(c1[3], 3, 'c1'); eq(c2, nil, 'no c2 without gradient')
c1, c2 = settings.text_colors({ under_color = { 1, 2, 3 }, under_grad = true, under_color2 = { 9, 8, 7 } }, 'under')
eq(c2[1], 9, 'c2 with gradient')

-- 色の印つきの文（一文字ずつ。空白には付けない）
local ext = require('src.platform.vanacore_ext')
eq(ext.gradient_text('ab', { 0, 0, 0 }, { 255, 100, 50 }), '\\cs(0,0,0)a\\cs(255,100,50)b\\cr', 'two chars')
eq(ext.gradient_text('a c', { 0, 0, 0 }, { 200, 200, 200 }), '\\cs(0,0,0)a \\cs(200,200,200)c\\cr', 'space kept plain')
eq(ext.gradient_text('あいう', { 0, 0, 0 }, { 100, 0, 0 }), '\\cs(0,0,0)あ\\cs(50,0,0)い\\cs(100,0,0)う\\cr', 'utf-8 per char')
eq(ext.gradient_text('x', { 1, 2, 3 }, nil), 'x', 'no gradient')
eq(ext.hex_of({ 255, 16, 0 }), '#FF1000FF', 'hex')
local p = ext._label_props({ codes = true }, 'ab', { 0, 0, 0 }, { 255, 255, 255 })
check(p.text:find('\\cs(', 1, true), 'codes used when the box supports them')
local q = ext._label_props({ codes = false }, 'ab', { 10, 20, 30 }, { 255, 255, 255 })
eq(q.text, 'ab', 'plain text when no codes'); eq(q.color, '#0A141EFF', 'start color only')
local r = ext._label_props({ codes = true }, 'ab', { 10, 20, 30 }, nil)
eq(r.text, 'ab', 'solid'); eq(r.color, '#0A141EFF', 'solid color')

-- 設定の アイコン タブ
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local function seen(pat)
    for _, x in ipairs(FAKE.texts) do if x:find(pat, 1, true) then return true end end
    for _, x in ipairs(FAKE.labels) do if x:find(pat, 1, true) then return true end end
    return false
end
FAKE.texts = {}; FAKE.labels = {}
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('marks'); frame(); frame()
check(seen('クエスト名の背景色'), 'quest color group'); check(seen('オブジェクト名の背景色'), 'object color group')
check(seen('#F8F4E8'), 'hex preview')
check(not seen('##marks_label_color2') and not seen('##marks_under_color2'), 'end color hidden while gradient off')
check(not seen('赤（R）'), 'no RGB sliders any more')
for _, id in ipairs({ 'marks_label_color', 'marks_label_color_reset', 'marks_under_color' }) do
    focus.set('settings', id); frame()
    eq(focus.current('settings'), id, 'pad reaches ' .. id)
end
-- 色の計算（HSV ⇔ RGB、#RRGGBB）
local W = require('src.ui.widgets')
for _, c in ipairs({ { 161, 32, 158 }, { 248, 244, 232 }, { 0, 0, 0 }, { 255, 255, 255 }, { 10, 200, 90 } }) do
    local h, s2, v = W.rgb_to_hsv(c)
    eq(table.concat(W.hsv_to_rgb(h, s2, v), ','), table.concat(c, ','), 'hsv round trip ' .. table.concat(c, ','))
end
eq(W.hex({ 161, 32, 158 }), '#A1209E', 'hex text')
eq(table.concat(W.parse_hex('#a1209e'), ','), '161,32,158', 'parse hex')
eq(W.parse_hex('#12345'), nil, 'bad hex')
-- 決定で色えらびが開き、窓は増えない（キャンセルは色えらびだけ閉じる）
focus.set('settings', 'marks_label_color'); frame()
press(0x1C); frame(); frame()
check(focus.picker('settings') ~= nil, 'picker opened')
check(FAKE.popups['##cp_marks_label_color'], 'popup open')
check(seen('決める'), 'done button'); check(seen('初めの色'), 'default button')
local before = table.concat(S.marks.label_color, ',')
-- 右（あざやかさ）・下（明るさ）・Tab（色合い）で色が変わる。すぐ反映
press(0xCD); frame(); press(0xCD); frame(); press(0xD0); frame(); press(0x0F); frame(); frame()
check(table.concat(S.marks.label_color, ',') ~= before, 'color changed live')
FAKE.texts = {}; FAKE.labels = {}; frame()
check(seen('オブジェクト名の背景色'), 'tab not switched by hue key')
-- キャンセル：元の色に戻り、色えらびだけ閉じる（設定の窓は開いたまま）
press(0x01); frame(); frame()
eq(table.concat(S.marks.label_color, ','), before, 'cancel restores color')
eq(focus.picker('settings'), nil, 'picker closed')
eq(focus.current('settings'), 'marks_label_color', 'focus back on the row')
-- もう一度開いて、決定で決める
press(0x1C); frame(); frame()
check(focus.picker('settings') ~= nil, 'reopened')
press(0xD0); frame(); press(0xD0); frame(); press(0xD0); frame()
press(0x1C); frame(); frame()
eq(focus.picker('settings'), nil, 'done closes')
local kept = table.concat(S.marks.label_color, ',')
check(kept ~= before, 'done keeps new color (' .. kept .. ')')
-- ↺ で初めの色
FAKE.clicks['##marks_label_color_reset'] = true; frame(); frame()
eq(table.concat(S.marks.label_color, ','), '248,244,232', 'swatch reset')
-- グラデーションをオンにすると終わりの色が出る
focus.set('settings', 'marks_under_grad'); frame()
press(0x1C); frame(); frame()
eq(S.marks.under_grad, true, 'gradient on')
FAKE.texts = {}; FAKE.labels = {}; frame()
check(seen('##marks_under_color2'), 'end color row')
check(seen('→'), 'preview shows both colors')
focus.set('settings', 'marks_under_color2'); frame()
eq(focus.current('settings'), 'marks_under_color2', 'pad reaches end color')
-- 開いたままタブを変えると色えらびは閉じる（入力を取りっぱなしにしない）
focus.set('settings', 'marks_under_color2'); frame()
press(0x1C); frame(); frame()
check(focus.picker('settings') ~= nil, 'end color picker opened')
require('src.ui.settings_ui').select_tab('layout'); frame(); frame()
eq(focus.picker('settings'), nil, 'picker dropped when row is gone')
require('src.ui.settings_ui').select_tab('marks'); frame(); frame()
-- マウスで見本を押しても開く
local imgui = package.loaded['imgui']
local oib = imgui.InvisibleButton
local hit = true
imgui.InvisibleButton = function (label, ...)
    if hit and label == '##marks_label_color' then hit = false; return true end
    return oib(label, ...)
end
frame(); frame()
imgui.InvisibleButton = oib
check(focus.picker('settings') ~= nil and focus.picker('settings').id == 'marks_label_color', 'click opens picker')
press(0x01); frame(); frame()
eq(focus.picker('settings'), nil, 'closed again')
S.marks.label_color = { 1, 2, 3 }
-- この色を元に戻す
FAKE.clicks['##marks_label_color_reset'] = true; frame(); frame()
eq(S.marks.label_color[1], 248, 'reset quest color')
FAKE.clicks['##marks_under_all_reset'] = true; frame(); frame()
eq(S.marks.under_grad, false, 'reset turns gradient off')

print('test_colors ok')
