-- 0.1.296：隠す場面（場面ごとのオン・オフと消すもの）、地図はキャンセルで閉じない、「版」→「バージョン」
require('fake_env')
local settings = require('src.core.settings')
local json = require('src.lib.json')
local marks_ui = require('src.ui.marks')

-- 初期値：イベントと会話・メニューがオンで全部消す。戦闘とチャットはオフ
local d = settings.defaults().marks.hide_scenes
eq(d.event.on, true, 'event on'); eq(d.menu.on, true, 'menu on')
eq(d.combat.on, false, 'combat off'); eq(d.chat.on, false, 'chat off')
for _, sc in ipairs(settings.HIDE_SCENES) do
    for _, part in ipairs(settings.HIDE_PARTS) do eq(d[sc][part], true, sc .. ' hides ' .. part .. ' by default') end
end
-- 引き継ぎ
local m = settings.merge({ marks = { hide_rings_in_event = false } }).marks
eq(m.hide_scenes.event.on, false, 'old off -> event off'); eq(m.hide_scenes.menu.on, false, 'old off -> menu off')
eq(m.hide_scenes.combat.on, false, 'combat stays off'); eq(m.hide_rings_in_event, nil, 'old key dropped')
m = settings.merge({ marks = { hide_rings_in_event = true } }).marks
eq(m.hide_scenes.event.on, true, 'old on -> event on'); eq(m.hide_scenes.menu.on, true, 'old on -> menu on')
m = settings.merge({ marks = { hide_scenes = { combat = { on = true, icons = false }, menu = { on = false } } } }).marks
eq(m.hide_scenes.combat.on, true, 'saved combat on'); eq(m.hide_scenes.combat.icons, false, 'saved part off')
eq(m.hide_scenes.combat.rings, true, 'missing part -> true'); eq(m.hide_scenes.menu.on, false, 'saved menu off')
eq(m.hide_scenes.event.on, true, 'missing scene -> default')
local m2 = settings.merge(json.decode(json.encode({ marks = m }))).marks
eq(m2.hide_scenes.combat.icons, false, 'round trip')

-- いまの場面と消すもの
local status, menu, chat = 0, false, false
local function ui_with(hs)
    return {
        settings = { marks = { hide_scenes = hs } },
        state = {},
        platform = {
            self_status = function () return status end,
            game_menu_state = function () return menu end,
            chat_open = function () return chat end,
        },
    }
end
local hs = settings.hide_scenes_of({})
local ui = ui_with(hs)
eq(marks_ui.hide_now(ui), nil, 'idle: nothing hidden')
status = 4
local h = marks_ui.hide_now(ui)
check(h and h.all and h.scene == 'event', 'event hides all')
eq(marks_ui.hide_rings_now(ui), true, 'event hides rings')
status = 1
eq(marks_ui.hide_now(ui), nil, 'combat off by default')
hs.combat.on = true
hs.combat.icons, hs.combat.quest, hs.combat.names, hs.combat.nearby = false, false, false, false
h = marks_ui.hide_now(ui)
check(h and h.rings and not h.icons and not h.all and h.scene == 'combat', 'combat: rings only')
status = 0
menu = true
h = marks_ui.hide_now(ui)
check(h and h.all and h.scene == 'menu', 'menu hides all')
hs.menu.on = false
eq(marks_ui.hide_now(ui), nil, 'menu off')
menu = false
chat = true
eq(marks_ui.hide_now(ui), nil, 'chat off by default')
hs.chat.on = true
hs.chat.rings = false
h = marks_ui.hide_now(ui)
check(h and not h.rings and h.icons and h.quest and h.names and h.nearby and not h.all, 'chat: everything but rings')
eq(marks_ui.hide_rings_now(ui), false, 'chat keeps rings')
-- 二つの場面が重なれば、消すものは合わせる
status = 1
h = marks_ui.hide_now(ui)
check(h and h.all, 'combat (rings) + chat (rest) -> all')
status, chat = 0, false
-- 前の形の設定（hide_scenes が無い）も読める
eq(marks_ui.hide_rings_now({ settings = { marks = { hide_rings_in_event = false } }, state = { game_menu_open = true },
    platform = { self_status = function () return 4 end } }), false, 'legacy off never hides')

-- 設定画面：アストラルは DISPLAY、クラシックは表示。RINGS の古いスイッチは無い
local ss = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a')
local cs = io.open(ROOT .. '/src/ui/settings_ui.lua', 'r'):read('*a')
check(not ss:find('hide_rings_in_event', 1, true) and not cs:find('hide_rings_in_event', 1, true), 'old toggle removed')
local i_disp, i_pos = ss:find("id = 'mk_display'", 1, true), ss:find("id = 'mk_position'", 1, true)
local i_hide = ss:find("hide_scenes_ui", 1, true)
check(i_disp and i_hide and i_pos and i_disp < i_hide and i_hide < i_pos, 'astral: in DISPLAY')
local c_show, c_pos = cs:find("'marks_show'", 1, true), cs:find("'marks_pos'", 1, true)
local c_hide = cs:find("hide_scenes_ui", 1, true)
check(c_show and c_hide and c_pos and c_show < c_hide and c_hide < c_pos, 'classic: in the display fold')

-- 字
local ja = json.decode(io.open(ROOT .. '/locales/ja.json', 'r'):read('*a'))
local en = json.decode(io.open(ROOT .. '/locales/en.json', 'r'):read('*a'))
eq(ja['settings.hide_scenes'], '隠す場面', 'ja title')
eq(ja['settings.hide_scene_menu'], 'メニューを開いたときに隠す', 'ja menu (0.1.299 clear name)')
eq(ja['settings.hide_part_nearby'], '近くのオブジェクト名', 'ja nearby')
check(ja['settings.hide_scenes_help']:find('「調べる」', 1, true) ~= nil, 'ja help mentions examine')
for k in pairs(ja) do
    if k:find('^settings%.hide_') then check(type(en[k]) == 'string' and en[k] ~= '', 'en ' .. k) end
end
-- 「版」は使わない（バージョン）
for k, v in pairs(ja) do check(not v:find('版', 1, true), 'no 版 in ' .. k) end
eq(ja['sf.set.update_notice_help']:sub(1, #'新しいバージョンがあれば'), '新しいバージョンがあれば', 'update help')
eq(ja['msg.update_available'], '新しいバージョン {v} があります（いまは {cur}）。', 'chat line')
check(ss:find("'新しいバージョンがあれば", 1, true) ~= nil, 'tkey default updated')

-- 地図：キャンセルは閉じない（do_action の back）。❌ は close_window
local as = io.open(ROOT .. '/src/app.lua', 'r'):read('*a')
check(as:find("elseif win == 'map' then app.map_cancel()", 1, true) ~= nil, 'map cancel does not close')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
eq(app.VERSION, '1.1.300', 'version')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
app.open_map(); frames(1)
eq(app.state.active, 'map', 'map operating')
app.map_cancel()
eq(app.state.open.map, true, 'map stays open after cancel')
check(app.state.active ~= 'map', 'control leaves the map')
app.close_window('map')
eq(app.state.open.map, false, 'close button closes it')

print('test_hide_scenes_296 ok')
