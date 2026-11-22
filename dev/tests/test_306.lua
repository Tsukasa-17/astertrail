-- 0.1.306：OBJECT の色の箱は「オブジェクト（クエスト対象名を含む）」（近くのオブジェクト名にも効く）。行は「オブジェクト名の…」。
-- DISPLAY の「クエストの対象名を表示する」はそのまま。対象名・近くのオブジェクト名の (i) は 2 行
require('fake_env')
local json = require('src.lib.json')
local ja = json.decode(io.open(ROOT .. '/locales/ja.json', 'r'):read('*a'))
local en = json.decode(io.open(ROOT .. '/locales/en.json', 'r'):read('*a'))
eq(ja['sf.set.color_under'], 'オブジェクト（クエスト対象名を含む）', 'heading')
eq(ja['settings.fold_object_name'], 'オブジェクト（クエスト対象名を含む）', 'classic heading key')
for _, k in ipairs({ 'bg_alpha', 'bg_color', 'bg_color2', 'bg_grad', 'stroke', 'stroke_alpha' }) do
    check(ja['settings.marks_under_' .. k]:find('^オブジェクト名の') ~= nil, 'row ' .. k)
    check(en['settings.marks_under_' .. k]:find('^Object name') ~= nil, 'en row ' .. k)
end
eq(ja['sf.set.marks_show_object_names'], 'クエストの対象名を表示する', 'DISPLAY toggle unchanged')
eq(ja['settings.marks_show_object_names'], 'クエストの対象名を表示する', 'classic DISPLAY toggle unchanged')
eq(ja['sf.set.marks_names_help'], '「クエストの対象名」はクエストに関わる ??? など。\n「近くのオブジェクト名」は {d} ヤルム以内の名前で、アイコンは付けません。', 'tooltip two lines')
check(not ja['sf.set.marks_names_help']:find('\n\n', 1, true), 'one newline, not a paragraph break')
check(en['sf.set.marks_names_help']:find('???.\n"Nearby', 1, true) ~= nil, 'en two lines')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
eq(app.VERSION, app.VERSION, 'version')
eq(addon.version, app.VERSION, 'lua matches')
FAKE.player = { name = 'T306', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local imgui = package.loaded['imgui']
local focus = require('src.ui.focus')
local sui = require('src.ui.settings_ui')
local theme = require('src.ui.theme')
for _, look in ipairs({ 'classic', 'yunaui', 'sf' }) do
    S.look = look; theme.set_look(look)
    S.marks.show_nearby_names = true; S.marks.nearby_radius = 42
    app.close_all(); frame()
    app.open_window('settings'); frame(); frame()
    sui.select_tab('marks'); FAKE.labels, FAKE.texts = {}, {}; frame(); frame()
    check(texted('オブジェクト（クエスト対象名を含む）'), look .. ': OBJECT heading')
    check(texted('オブジェクト名の背景色') or labeled('オブジェクト名の背景色'), look .. ': row label')
    check(not texted('クエストの対象名の背景色') and not labeled('クエストの対象名の背景色'), look .. ': old row label gone')
    check(texted('クエストの対象名を表示する') or labeled('クエストの対象名を表示する'), look .. ': DISPLAY toggle unchanged')
    -- (i) を選ぶとツールチップ（2 行、距離は設定の値）
    focus.set('settings', 'marks_nearby', false, 'nav'); app.activate('settings'); FAKE.texts = {}; frame(); frame()
    check(texted('「クエストの対象名」はクエストに関わる ??? など。\n「近くのオブジェクト名」は 42 ヤルム以内'), look .. ': tooltip two lines with distance')
end
app.close_all(); frame()
print('test_306 ok')
