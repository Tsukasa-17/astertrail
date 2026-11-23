-- 0.1.239：設定の折りたたみ見出し → 0.1.304：どのテーマもアストラルと同じ並び（折りたたみは無い）。
-- キー・パッド：開くと最初の項目、スライダーは先に ↺、もう一度のキャンセルで閉じる（本へ）。L1/R1 で分類
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local sui = require('src.ui.settings_ui')
local settings = require('src.core.settings')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()

eq(app.VERSION, '1.1.318', 'version')
eq(addon.version, app.VERSION, 'lua matches')
-- 保存の settings_folds は読み込めるまま（使わないが、壊さない）
eq(settings.merge({ settings_folds = { look_fx = true, look_fonts = false } }).settings_folds['look_fonts'], nil, 'false dropped')

for _, look in ipairs({ 'classic', 'yunaui', 'sf' }) do
    S.look = look; require('src.ui.theme').set_look(look)
    app.close_all(); frame()
    FAKE.labels, FAKE.texts = {}, {}
    app.open_window('book'); app.open_window('settings'); frame(); frame(); frame()
    eq(sui.current_tab(), 'look', look .. ': look tab')
    eq(focus.current('settings'), 'lang', look .. ': first item (language)')
    check(not labeled('▾ ') and not labeled('▸ '), look .. ': no fold headings')
    check(labeled('##sfcat_look') and labeled('##sfcat_save'), look .. ': category list')
    check(not labeled('##sfcat_notify'), look .. ': no notify category (0.1.304)')
    check(texted('GENERAL') and texted('POPUP') and texted('UPDATES') and texted('LAYOUTS'), look .. ': look has notify and layouts')
    -- 下へ動ける（並びを作っている）
    app.input('down', true, 'key'); app.input('down', false, 'key'); frame(); frame()
    check(focus.current('settings') ~= 'lang', look .. ': down moves')
    -- スライダー：キャンセルで ↺、もう一度で閉じる
    focus.set('settings', 'font_book'); frame()
    app.input('back', true, 'key'); app.input('back', false, 'key'); frame(); frame()
    eq(focus.current('settings'), 'font_book_reset', look .. ': back from slider goes to reset')
    app.input('back', true, 'key'); app.input('back', false, 'key'); frame(); frame()
    eq(app.state.open.settings, false, look .. ': back again closes settings')
    eq(app.state.open.book, true, look .. ': book remains')
    -- R1 で次の分類、最初の項目
    app.open_window('settings'); frame(); frame()
    pad(9, 1); pad(9, 0); frame(); frame(); frame()
    eq(sui.current_tab(), 'layout', look .. ': R1 next category')
    eq(focus.current('settings'), 'lock', look .. ': first item of layout')
    pad(8, 1); pad(8, 0); frame(); frame()
    pad(8, 1); pad(8, 0); frame(); frame()
    eq(sui.current_tab(), 'save', look .. ': L1 wraps to last')
end
print('test_settings_folds_239 ok')
