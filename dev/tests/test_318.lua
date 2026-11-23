-- 0.1.318：メインの色（始めの色）の色えらびにだけ透明度の帯。各まとまりの「透明度」と同じキー（marks.label_clear／under_clear）
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
eq(app.VERSION, '1.1.324', 'version')
FAKE.player = { name = 'T318', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local sui = require('src.ui.settings_ui')
local theme = require('src.ui.theme')
local focus = require('src.ui.focus')
local W = require('src.ui.widgets')
local imgui = require('imgui')

-- その名前の見えないボタンだけ、1 回押す（部分一致だと ↺ や終わりの色に当たるため）
local exact = nil
local real_ib = imgui.InvisibleButton
imgui.InvisibleButton = function (label, ...)
    if exact and label == exact then exact = nil; return true end
    return real_ib(label, ...)
end

for _, look in ipairs({ 'sf', 'classic' }) do
    for _, which in ipairs({ 'label', 'under' }) do
        S.look = look; theme.set_look(look)
        S.marks[which .. '_grad'] = true
        S.marks[which .. '_clear'] = 0.25
        app.close_all(); frame()
        app.open_window('settings'); frame(); frame()
        sui.select_tab('marks'); frame(); frame()
        local tag = look .. '/' .. which .. ': '
        -- メインの色の見本を押す → 帯が開く。透明度 25% ＝ 不透明の量 0.75
        exact = '##marks_' .. which .. '_color'; frame(); frame()
        local p = focus.picker('settings')
        check(p and p.id == 'marks_' .. which .. '_color', tag .. 'main color picker open')
        eq(p.clear, true, tag .. 'band is transparency')
        eq(p.a, 0.75, tag .. 'band starts at the slider value')
        check(texted('透明度 25%'), tag .. 'band says transparency 25%')
        check(not texted('不透明度 75%'), tag .. 'not shown as opacity')
        -- 帯を動かす → スライダーの値（保存のキー）がすぐ変わる
        p.a = 0.4; frame()
        eq(S.marks[which .. '_clear'], 0.6, tag .. 'band -> slider')
        check(texted('透明度 60%'), tag .. 'band text follows')
        -- スライダー側で変える → 帯もすぐ同じ値
        S.marks[which .. '_clear'] = 0.1; frame()
        eq(focus.picker('settings').a, 0.9, tag .. 'slider -> band')
        eq(S.marks[which .. '_clear'], 0.1, tag .. 'slider value kept')
        -- やめると開く前（25%）に戻る
        focus.picker('settings').cancel = true; frame(); frame()
        eq(S.marks[which .. '_clear'], 0.25, tag .. 'cancel restores')
        eq(S.marks[which .. '_color_a'], nil, tag .. 'no extra key saved')
        -- 終わりの色の色えらびには帯が無い
        exact = '##marks_' .. which .. '_color2'; frame(); frame()
        local q = focus.picker('settings')
        check(q and q.id == 'marks_' .. which .. '_color2', tag .. 'end color picker open')
        eq(q.a, nil, tag .. 'no band for the end color')
        q.cancel = true; frame(); frame()
        eq(S.marks[which .. '_clear'], 0.25, tag .. 'end color picker leaves transparency alone')
        S.marks[which .. '_clear'] = 0; S.marks[which .. '_grad'] = false
    end
end

-- 背景色（0.1.318〜、t898u）：背景色の色えらびにも透明度の帯。保存は今までの濃さ（label_bg_alpha、0.8＝透明度 20%）のまま
for _, look in ipairs({ 'sf', 'classic' }) do
    for _, which in ipairs({ 'label', 'under' }) do
        S.look = look; theme.set_look(look)
        local bk = which .. '_bg_alpha'
        S.marks[bk] = 0.8
        S.marks[which .. '_bg_grad'] = true
        app.close_all(); frame()
        app.open_window('settings'); frame(); frame()
        sui.select_tab('marks'); frame(); frame()
        local tag = 'bg ' .. look .. '/' .. which .. ': '
        eq(S.marks[bk], 0.8, tag .. 'old value unchanged by showing it')
        check(texted('背景の透明度') or labeled('背景の透明度'), tag .. 'row named transparency')
        check(texted('20%'), tag .. 'shown as transparency 20%')
        exact = '##marks_' .. which .. '_bg_color'; frame(); frame()
        local p = focus.picker('settings')
        check(p and p.id == 'marks_' .. which .. '_bg_color', tag .. 'bg picker open')
        eq(p.clear, true, tag .. 'bg band is transparency')
        eq(p.a, 0.8, tag .. 'band = strength')
        check(texted('透明度 20%'), tag .. 'band says 20%')
        p.a = 0.6; frame()
        eq(S.marks[bk], 0.6, tag .. 'band -> slider (strength 0.6)')
        frame()
        check(texted('40%'), tag .. 'slider shows transparency 40%')
        S.marks[bk] = 0.5; frame()
        eq(focus.picker('settings').a, 0.5, tag .. 'slider -> band')
        focus.picker('settings').cancel = true; frame(); frame()
        eq(S.marks[bk], 0.8, tag .. 'cancel restores')
        -- 背景の終わりの色には帯なし
        exact = '##marks_' .. which .. '_bg_color2'; frame(); frame()
        local q = focus.picker('settings')
        check(q and q.id == 'marks_' .. which .. '_bg_color2', tag .. 'bg end picker open')
        eq(q.a, nil, tag .. 'no band for the bg end color')
        q.cancel = true; frame(); frame()
        -- 背景色の ↺ は色だけ（透明度はそのまま）
        S.marks[which .. '_bg_color'] = { 10, 20, 30 }; S.marks[bk] = 0.3; frame()
        exact = '##marks_' .. which .. '_bg_color_reset'; frame(); frame()
        local dm = require('src.core.settings').marks_defaults()[which .. '_bg_color']
        eq(S.marks[which .. '_bg_color'][1], dm[1], tag .. 'bg color reset')
        eq(S.marks[bk], 0.3, tag .. 'bg reset leaves transparency')
        -- スライダーの ＋ は透明度を上げる（濃さは下がる）。↺ は今までの見た目（濃さ 0.8）
        S.marks[bk] = 0.8; frame()
        FAKE.clicks['marks_' .. bk .. '_plus'] = true; frame(); frame()
        eq(S.marks[bk], 0.75, tag .. 'plus = more transparent')
        FAKE.clicks['marks_' .. bk .. '_reset'] = true; frame(); frame()
        eq(S.marks[bk], 0.8, tag .. 'reset = strength 0.8 (transparency 20%)')
        S.marks[bk] = 0.8; S.marks[which .. '_bg_grad'] = false
    end
end
-- 描き方は今まで（濃さ 0.8 → #000000CC）
eq(require('src.platform.vanacore_ext')._bg_hex(0.8), '#000000CC', 'background draw unchanged')
imgui.InvisibleButton = real_ib

-- 8 桁の入力は透明度の帯では読まない（6 桁のまま）。ほかの用途の 8 桁読みはそのまま
local c, a = W.parse_hex_a('#11223380')
eq(a, 0.5, 'parse 8 digits still works')
print('test_318 ok')
