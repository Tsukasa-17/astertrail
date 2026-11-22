-- 0.1.59: アイコンのタブの表示のオン・オフは4つだけ。それぞれが自分のものだけを動かす
require('fake_env')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local settings = require('src.core.settings')

-- 初期：今の見た目のまま（近くのオブジェクト名だけオフ）
do
    local d = settings.defaults()
    eq(d.marks.show_icons, true, 'icons default on')
    eq(d.marks.show_quest_name, true, 'quest name default on')
    eq(d.marks.show_object_names, true, 'object names default on')
    eq(d.marks.show_nearby_names, false, 'nearby default off')
    eq(d.marks.enabled, nil, 'no enabled'); eq(d.marks.show_objects, nil, 'no show_objects'); eq(d.marks.show_question, nil, 'no show_question')
    eq(table.concat(settings.MARK_SWITCHES, ','), 'show_icons,show_quest_name,show_object_names,show_nearby_names', 'order')
    check(settings.marks_active(d), 'default active')
end

-- 古い保存からの移し替え
do
    local function m(old) return settings.merge({ settings_schema = 1, marks = old }).marks end
    local a = m({ enabled = false, introduced = 1, show_quest_name = true, show_nearby_names = true })
    eq(a.show_icons, false, 'old all off: icons off'); eq(a.show_quest_name, false, 'old all off: quest off')
    eq(a.show_object_names, false, 'old all off: objects off'); eq(a.show_nearby_names, false, 'old all off: nearby off')
    local b = m({ enabled = true, introduced = 1, show_objects = false, show_quest_name = false, show_nearby_names = true })
    eq(b.show_icons, true, 'icons on'); eq(b.show_quest_name, false, 'quest off kept')
    eq(b.show_object_names, false, 'show_objects off -> object names off'); eq(b.show_nearby_names, true, 'nearby kept')
    local c = m({ enabled = true, introduced = 1, show_question = false })
    eq(c.show_object_names, false, 'show_question off -> object names off')
    local e = m({ enabled = false })   -- 予約の false（introduced なし）はオン
    eq(e.show_icons, true, 'reserved false on'); eq(e.show_object_names, true, 'reserved false objects on')
    -- 新しいキーはそのまま。古いキーは消える
    local f = m({ introduced = 1, show_icons = false, show_quest_name = true, show_object_names = true, enabled = true })
    eq(f.show_icons, false, 'new icons kept'); eq(f.show_quest_name, true, 'new quest kept')
    eq(f.enabled, nil, 'enabled dropped'); eq(f.show_objects, nil, 'show_objects dropped')
    -- 保存し直しても同じ（2回目の読み込み）
    local g = settings.merge({ settings_schema = 1, marks = f })
    eq(g.marks.show_icons, false, 'round trip icons'); eq(g.marks.show_object_names, true, 'round trip objects')
    -- 位置・色・大きさはそのまま
    local h = m({ introduced = 1, enabled = false, obj_mark_dx = 7, icon_size = 30, under_color = { 1, 2, 3 } })
    eq(h.obj_mark_dx, 7, 'position kept'); eq(h.icon_size, 30, 'size kept'); eq(h.under_color[2], 2, 'colour kept')
end

-- 描画
local D = data_mod.load(posix_fs(), ROOT .. '/data/')
local P = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
P:reset({ server = 'catseye', name = 'Test' })
P:set_state('quest.bastok.003', 'accepted')
P:set_current_step('quest.bastok.003', 'quest.bastok.003#g02')
local marks_ui = require('src.ui.marks')
local S = settings.defaults()
local placed, attached, fallback = {}, {}, 0
local zone = 191
local scene = {
    { index = 11, name = '???', x = 50, y = 60, z = 4, model_size = 2.5, grid = 'J-5', kind = 'npc' },   -- クエストの ???
    { index = 20, name = 'Signpost', x = 55, y = 60, z = 4, model_size = 2, kind = 'npc', entity_type = 2 }, -- 関係ないもの
}
local ui = {
    settings = S, state = { ready = true },
    player = { zone_id = 191, x = 50, y = 60 },
    data = D, progress = P,
    platform = {
        visible_entities = function () return scene end,
        attach_available = function () return true end,
        set_name_marks = function (items) attached = items; return true end,
        clear_name_marks = function () attached = {} end,
        place_available = function () return true end,
        set_world_marks = function (items) placed = items; return true, #items end,
        clear_world_marks = function () placed = {} end,
        object_info = function (e) return { type = e.entity_type, name_shown = false } end,
        entity_world_screen = function () fallback = fallback + 1; return 1, 1, 'x' end,
    },
    imgui = { GetBackgroundDrawList = function () return setmetatable({}, { __index = function () return function () end end }) end },
}
local function set(i, q, o, n)
    S.marks.show_icons, S.marks.show_quest_name, S.marks.show_object_names, S.marks.show_nearby_names = i, q, o, n
end
local function draw()
    placed, attached, fallback = {}, {}, 0
    marks_ui.draw(ui)
    local quest, near = nil, {}
    for _, it in ipairs(placed) do
        if it.name_only then near[it.under or '?'] = it else quest = it end
    end
    return quest, near
end
-- 名前（under）を数える：同じものに二つ出さない
local function names_of(index)
    local n = 0
    for _, it in ipairs(placed) do if it.index == index and it.under then n = n + 1 end end
    return n
end

-- いつもの見た目
set(true, true, true, false)
local q, near = draw()
check(q and not q.no_icon, 'icon shown'); eq(q.label, 'ダングルフの奇岩', 'quest name shown'); eq(q.under, '???', 'object name shown')
check(next(near) == nil, 'nearby off: no names for others')

-- アイコンだけオフ：クエスト名と名前は残る
set(false, true, true, false)
q = draw()
check(q and q.no_icon == true, 'icon off'); eq(q.label, 'ダングルフの奇岩', 'quest name stays'); eq(q.under, '???', 'object name stays')
eq(fallback, 0, 'icon off: no imgui icon fallback')

-- クエスト名だけオフ
set(true, false, true, false)
q = draw()
check(q and not q.no_icon, 'icon stays'); eq(q.label, nil, 'quest name off'); eq(q.under, '???', 'object name stays')

-- クエストのオブジェクト名だけオフ
set(true, true, false, false)
q = draw()
check(q and not q.no_icon, 'icon stays'); eq(q.label, 'ダングルフの奇岩', 'quest name stays'); eq(q.under, nil, 'object name off')

-- 近くのオブジェクト名だけオン：関係ないものだけでなく、近くのクエストのオブジェクトにも名前（二重にしない）
set(false, false, false, true)
q, near = draw()
check(near['Signpost'], 'nearby name for Signpost')
check(not near['???'], 'quest ??? not in the name-only list')
eq(q and q.under, '???', 'quest ??? still named because it is nearby')
eq(q.label, nil, 'no quest name'); check(q.no_icon, 'no icon')
eq(names_of(11), 1, 'one name on quest ???')

-- 両方オン：二重にしない
set(true, true, true, true)
q, near = draw()
eq(names_of(11), 1, 'both on: one name on quest ???')
check(not near['???'], 'both on: not in name-only list')
check(near['Signpost'], 'both on: Signpost named')
check(q and not q.no_icon and q.label, 'both on: icon and quest name')

-- 近くのオブジェクト名だけオフ：関係ないものは出ない、クエストのものはそのまま
set(true, true, true, false)
q, near = draw()
check(next(near) == nil, 'nearby off'); eq(q.under, '???', 'quest name of object stays')

-- クエストのオブジェクト名オフ・近くオン、でも遠いときは名前を出さない
scene[1].x = 200
ui.player.x = 50
set(true, true, false, true)
q, near = draw()
eq(q and q.under, nil, 'far quest object: no name')
check(q and not q.no_icon, 'far: icon still')
scene[1].x = 50

-- 4つともオフ：何も出さない
set(false, false, false, false)
q, near = draw()
eq(#placed, 0, 'all off: nothing'); eq(fallback, 0, 'all off: no fallback')
check(not settings.marks_active(S), 'not active')

-- 話す相手（名前に付ける）：アイコンとクエスト名が別々
do
    local P2 = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
    P2:reset({ server = 'catseye', name = 'Test2' })
    ui.progress = P2
    ui.player = { zone_id = 235, x = 0, y = 0 }
    scene = { { index = 1, name = 'Aquillina', x = 0, y = 0, z = 0, kind = 'npc' } }
    set(true, true, true, false); draw()
    check(#attached >= 1 and not attached[1].no_icon and attached[1].label, 'talk: icon and quest name')
    set(false, true, true, false); draw()
    check(#attached >= 1 and attached[1].no_icon and attached[1].label, 'talk: quest name without icon')
    set(true, false, true, false); draw()
    check(#attached >= 1 and not attached[1].no_icon and attached[1].label == nil, 'talk: icon without quest name')
    set(false, false, true, true); draw()
    eq(#attached, 0, 'talk: nothing when icon and quest name are off')
end

-- 設定画面：4つだけ、この順番
do
    local ui_src = io.open(ROOT .. '/src/ui/settings_ui.lua'):read('*a')
    local a = ui_src:find("'marks_icons'", 1, true)
    local b = ui_src:find("'marks_quest'", 1, true)
    local c = ui_src:find("'marks_objects'", 1, true)
    local d = ui_src:find("'marks_nearby'", 1, true)
    check(a and b and c and d and a < b and b < c and c < d, 'four toggles in order')
    check(not ui_src:find("'marks_on'", 1, true), 'old all toggle gone')
    local json = require('src.lib.json')
    for _, lang in ipairs({ 'ja', 'en' }) do
        local L = json.decode(io.open(ROOT .. '/locales/' .. lang .. '.json'):read('*a'))
        for _, k in ipairs({ 'settings.marks_show_icons', 'settings.marks_show_quest_name', 'settings.marks_show_object_names', 'settings.marks_show_nearby', 'settings.marks_switches_note' }) do
            check(type(L[k]) == 'string' and L[k] ~= '', lang .. ' ' .. k)
        end
        for _, k in ipairs({ 'settings.marks_enabled', 'settings.marks_show_objects', 'settings.marks_show_question' }) do
            check(L[k] == nil, lang .. ' removed ' .. k)
        end
        if lang == 'ja' then
            eq(L['settings.marks_show_icons'], 'アイコンを表示する', 'ja 1')
            eq(L['settings.marks_show_quest_name'], 'クエスト名を表示する', 'ja 2')
            eq(L['settings.marks_show_object_names'], 'クエストの対象名を表示する', 'ja 3')
            eq(L['settings.marks_show_nearby'], '近くのオブジェクト名を表示する', 'ja 4')
            check(not L['settings.marks_switches_note']:find('頭上', 1, true), 'no disliked word')
        end
    end
end
print('test_marks_switches ok')
