-- 0.1.239：設定の折りたたみ見出し（本と同じ：左右で開閉、決定では開かない、決定で中へ、キャンセルで見出しへ）
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

eq(app.VERSION, '1.1.260', 'version')
eq(addon.version, app.VERSION, 'lua matches')
eq(S.settings_folds == nil or next(S.settings_folds) == nil, true, 'fresh folds all open')
eq(settings.merge({}).settings_folds['look_fx'], nil, 'missing key stays open')
eq(settings.merge({ settings_folds = { look_fx = true, look_fonts = false, x = 'yes' } }).settings_folds['look_fx'], true, 'true is kept')
eq(settings.merge({ settings_folds = { look_fx = true, look_fonts = false } }).settings_folds['look_fonts'], nil, 'false dropped')
eq(settings.merge({ settings_folds = { look_fx = true, [1] = true } }).settings_folds[1], nil, 'non-string dropped')

local function open_settings()
    app.open_window('settings'); frame(); frame(); frame()
end
open_settings()
eq(sui.current_tab(), 'look', 'look tab')
eq(focus.current('settings'), 'lang', 'cursor still first item (language)')
check(labeled('▾ 文字サイズ') or labeled('文字サイズ'), 'fonts heading drawn open')
check(not (labeled('縁取りと影') or texted('縁取りと影')), 'old look fx fold removed')
check(labeled('背景の濃さ'), 'alpha heading')

-- 左で閉じる（カーソルは見出しのまま、先頭の言語へ戻らない）
focus.set('settings', 'fold_look_fonts'); frame()
app.input('left', true, 'key'); app.input('left', false, 'key'); frame(); frame()
eq(S.settings_folds.look_fonts, true, 'left collapses fonts')
eq(focus.current('settings'), 'fold_look_fonts', 'cursor stays on heading after close')
check(labeled('▸ 文字サイズ') or labeled('文字サイズ'), 'closed mark')

-- 決定では開かない
app.input('confirm', true, 'key'); app.input('confirm', false, 'key'); frame(); frame()
eq(S.settings_folds.look_fonts, true, 'confirm does not open')
eq(focus.current('settings'), 'fold_look_fonts', 'confirm on closed heading stays')

-- 右で開く
app.input('right', true, 'key'); app.input('right', false, 'key'); frame(); frame()
eq(S.settings_folds.look_fonts, nil, 'right opens')
eq(focus.current('settings'), 'fold_look_fonts', 'cursor stays on heading after open')

-- 決定で中の先頭へ
app.input('confirm', true, 'key'); app.input('confirm', false, 'key'); frame(); frame()
eq(focus.current('settings'), 'font_book', 'confirm enters first item')
eq(S.settings_folds.look_fonts, nil, 'confirm does not collapse')

-- スライダーは先に ↺、もう一度で見出しへ（窓は閉じない）
app.input('back', true, 'key'); app.input('back', false, 'key'); frame(); frame()
eq(focus.current('settings'), 'font_book_reset', 'back from slider goes to reset first')
app.input('back', true, 'key'); app.input('back', false, 'key'); frame(); frame()
eq(focus.current('settings'), 'fold_look_fonts', 'back from reset returns to heading')
eq(app.state.open.settings, true, 'back from inside does not close settings')

-- 見出しでキャンセルすると設定を閉じる（本へ）
app.input('back', true, 'key'); app.input('back', false, 'key'); frame(); frame()
eq(app.state.open.settings, false, 'back on heading closes settings')
eq(app.state.open.book, true, 'book remains')

-- 覚えたたたみを読み直す
S.settings_folds.look_fonts = true
open_settings()
sui.select_tab('look'); frame(); frame()
check(labeled('▸ 文字サイズ') or labeled('文字サイズ'), 'remembered collapse keeps fonts heading')

-- アイコンのタブも見出しがある
sui.select_tab('marks'); frame(); frame(); frame()
check(labeled('表示'), 'marks show heading')
check(labeled('位置'), 'marks pos heading')
check(labeled('クエスト名'), 'marks quest heading')
check(labeled('オブジェクト名'), 'marks object heading')
check(labeled('リング'), 'marks rings heading')

-- 操作・保存
sui.select_tab('input'); frame(); frame()
check(labeled('パッド'), 'pad heading')
check(labeled('ショートカット'), 'shortcut heading')
check(labeled('ゲームのメニュー') or labeled('ゲームUI'), 'gameui heading')
sui.select_tab('save'); frame(); frame()
check(labeled('バックアップ'), 'backup heading')
check(labeled('マイレイアウト'), 'layouts heading')

-- 文字サイズを変えても、自分で決めた窓の大きさは変えない（既存方針）
-- 本を閉じてから大きさを書く（開いたままだと試験の GetWindowSize が上書きする）
if app.close_window then app.close_window('book') else app.state.open.book = false end
sui.select_tab('look'); frame()
S.windows = S.windows or {}
S.windows.book = S.windows.book or {}
S.windows.book.w, S.windows.book.h = 640, 480
S.fonts = S.fonts or {}
S.fonts.book = 2.0
if sui.apply_font_live then sui.apply_font_live(app) end
frame(); frame()
eq(S.windows.book.w, 640, 'font change keeps width')
eq(S.windows.book.h, 480, 'font change keeps height')
eq(S.windows.book.w ~= nil and S.windows.book.h ~= nil, true, 'font change does not clear size')

-- 0.1.240：見出しごとに区切り線（タブ下と戻るボタンの線に加えて、折りたたみ見出しの数だけ増える）
sui.select_tab('look'); frame(); frame()
local seps = (FAKE.calls and FAKE.calls.Separator) or 0
check(seps >= 5, 'look tab has heading separators')
-- たたんでも線は残る
S.settings_folds.look_fx = true
sui.select_tab('look'); frame(); frame()
seps = (FAKE.calls and FAKE.calls.Separator) or 0
check(seps >= 5, 'separators remain when a heading is collapsed')
eq(S.windows.book.w, 640, 'separators do not change saved width')
eq(S.windows.book.h, 480, 'separators do not change saved height')
