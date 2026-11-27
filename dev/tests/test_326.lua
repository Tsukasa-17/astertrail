-- 0.1.326：フォント選びをクエスト名／オブジェクト名の枠へ。保存キーはそのまま。プルダウン幅は文字が収まるように。
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
eq(app.VERSION, '1.1.327', 'version')
eq(addon.version, app.VERSION, 'addon.version matches')

local settings = require('src.core.settings')
-- 保存キーは 0.1.325 のまま（label_font / under_font）
local split = settings.merge({ marks = { label_font = 'Meiryo', under_font = 'Yu Gothic UI' } })
eq(split.marks.label_font, 'Meiryo', 'quest font key unchanged')
eq(split.marks.under_font, 'Yu Gothic UI', 'object font key unchanged')

-- ソース：color_main の中で font_row(ui, name, which)。DISPLAY には無い
local src = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a')
local a = src:find("id = 'mk_display'", 1, true)
local b = src:find("id = 'mk_position'", 1, true)
local cm = src:find('local function color_main', 1, true)
local cd = src:find('local function color_detail', 1, true)
local f = src:find('font_row(ui, name, which)', cm, true)
check(cm and cd and f and f > cm and f < cd, 'font_row call is inside color_main')
check(a and b and not src:sub(a, b):find('font_row', 1, true), 'DISPLAY no longer has font_row')
check(src:find('text_w(preview)', 1, true) or src:find('measure_text', f, true), 'combo width uses measured preview')

-- 設定画面：両方の枠のラベルが見える（パネルは同時に描く）
local theme = require('src.ui.theme')
local sui = require('src.ui.settings_ui')
sui._reset_font_choices()
local S = app._settings()
S.look = 'sf'; theme.set_look('sf')
app.close_all(); frame()
app.open_window('settings'); frame(); frame()
sui.select_tab('marks'); frame(); frame()
check(texted('クエスト名のフォント') or labeled('クエスト名のフォント'), 'quest font still in the quest name frame')
check(texted('オブジェクト名のフォント') or labeled('オブジェクト名のフォント'), 'object font still in the object name frame')
check(texted('いつもの（今までと同じ）'), 'usual font label is drawn in full')
-- キーはそのまま（直接代入してもフィールド名は label_font / under_font）
S.marks.label_font = 'Meiryo'
S.marks.under_font = 'Yu Gothic UI'
eq(S.marks.label_font, 'Meiryo', 'quest font still label_font')
eq(S.marks.under_font, 'Yu Gothic UI', 'object font still under_font')
app.close_all(); frame()
print('test_326 ok')
