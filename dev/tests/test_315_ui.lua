-- 0.1.315：設定画面（アイコン → LABEL／OBJECT）にフォント・グラデーションの向き・色の不透明度
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
eq(app.VERSION, '1.1.318', 'version')
FAKE.player = { name = 'T315', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local sui = require('src.ui.settings_ui')
local theme = require('src.ui.theme')
local ext = require('src.platform.vanacore_ext')
local focus = require('src.ui.focus')

-- 一覧は偽物（読み込み中 → 読み終わり）
local scan_calls, fake_done = 0, false
local real_step, real_fam = ext.font_scan_step, ext.font_families
ext.font_scan_step = function () scan_calls = scan_calls + 1; return fake_done end
ext.font_families = function ()
    if not fake_done then return {}, false, false end
    return { { value = 'Meiryo', label = 'メイリオ（Meiryo）' }, { value = 'Yu Gothic UI', label = 'Yu Gothic UI' } }, true, false
end
sui._reset_font_choices()

for _, look in ipairs({ 'sf', 'yunaui', 'classic' }) do
    S.look = look; theme.set_look(look)
    S.marks.label_grad = false; S.marks.label_font = ''
    app.close_all(); frame()
    app.open_window('settings'); frame(); frame()
    sui.select_tab('marks'); frame(); frame()
    check(texted('透明度') or labeled('透明度'), look .. ': clear row (0.1.317)')
    check(not texted('色の不透明度') and not labeled('色の不透明度'), look .. ': no opacity row')
    check(texted('クエスト名・オブジェクト名のフォント') or labeled('クエスト名・オブジェクト名のフォント'), look .. ': font row')
    check(texted('いつもの（今までと同じ）'), look .. ': usual font shown')
    check(not texted('グラデーションの向き') and not labeled('グラデーションの向き'), look .. ': no direction row while gradient is off')
    S.marks.label_grad = true; frame(); frame()
    check(texted('グラデーションの向き') or labeled('グラデーションの向き'), look .. ': direction row')
    check(texted('左から右') or labeled('左から右'), look .. ': left to right by default')
    -- 押すと上から下
    FAKE.clicks['##marks_label_grad_dir'] = true; frame(); frame()
    eq(S.marks.label_grad_dir, 'down', look .. ': switched to down')
    check(texted('上から下') or labeled('上から下'), look .. ': shows top to bottom')
    check(texted(' ↓ '), look .. ': preview says top to bottom')
    -- 元に戻すボタンで向き・不透明度も今まで
    S.marks.label_clear = 0.5; frame(); frame()
    check(texted('透明度 50%'), look .. ': clear shown once in the preview (0.1.317)')
    FAKE.clicks['##marks_label_all_reset'] = true; frame(); frame()
    eq(S.marks.label_grad_dir, 'across', look .. ': reset dir')
    eq(S.marks.label_clear, 0, look .. ': reset clear')
    eq(S.marks.label_grad, false, look .. ': reset gradient')
end
check(scan_calls > 0, 'font list read while the row is shown')

-- 読み終わったら一覧から選べる（アストラル）
fake_done = true
S.look = 'sf'; theme.set_look('sf')
app.close_all(); frame()
app.open_window('settings'); frame(); frame()
sui.select_tab('marks'); frame(); frame()
FAKE.clicks['Yu Gothic UI##c_Yu Gothic UI'] = true; frame(); frame()
eq(S.marks.label_font, 'Yu Gothic UI', 'picked a font')
local st = require('src.core.settings').label_style(S.marks, 'label')
eq(st.font, 'Yu Gothic UI', 'style carries the font')
FAKE.clicks['いつもの（今までと同じ）##c_'] = true; frame(); frame()
eq(S.marks.label_font, '', 'back to the usual font')

-- 色えらび：0.1.317〜 不透明度の帯は出さない（透明度は 1 つの行だけ）
-- 見本を押したときと同じに開く（↺ の当たりの名前が見本の名前を含むので、クリックの代わりに開く）
focus.open_picker('settings', 'marks_label_color', 0, 0, 1, { 248, 244, 232 })
frame(); frame()
check(not texted('A 100%'), 'no alpha bar in the picker')
app.close_all(); frame()

-- 設定画面を閉じたら一覧は読まない
local before = scan_calls
frame(); frame()
eq(scan_calls, before, 'no reading while settings are closed')
ext.font_scan_step, ext.font_families = real_step, real_fam
print('test_315_ui ok')
