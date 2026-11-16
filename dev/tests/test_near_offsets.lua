-- 0.1.60: 近くのオブジェクト名の位置を、クエストのオブジェクト名とは別に調整する
require('fake_env')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local settings = require('src.core.settings')

-- 設定：初期は 0。古い保存はオブジェクトの行（アイコンと名前）の値を引き継ぐ（今の見え方を変えない）
do
    local d = settings.defaults()
    eq(d.marks.near_name_dx, 0, 'default x'); eq(d.marks.near_name_dy, 0, 'default y')
    local old = settings.merge({ settings_schema = 1, marks = { introduced = 1, obj_mark_dx = 6, obj_mark_dy = -10 } })
    eq(old.marks.near_name_dx, 6, 'old save inherits x'); eq(old.marks.near_name_dy, -10, 'old save inherits y')
    local kept = settings.merge({ settings_schema = 1, marks = { introduced = 1, obj_mark_dx = 6, near_name_dx = -4, near_name_dy = 2 } })
    eq(kept.marks.near_name_dx, -4, 'saved x kept'); eq(kept.marks.near_name_dy, 2, 'saved y kept')
    eq(kept.marks.obj_mark_dx, 6, 'quest object position separate')
    local big = settings.merge({ settings_schema = 1, marks = { introduced = 1, near_name_dx = 9999 } })
    eq(big.marks.near_name_dx, settings.OFFSET_MAX, 'clamped')
    local o = settings.near_offsets({ near_name_dx = 3, near_name_dy = -5 })
    eq(o.name_dx, 3, 'near_offsets x'); eq(o.name_dy, -5, 'near_offsets y')
end

-- 描画
local D = data_mod.load(posix_fs(), ROOT .. '/data/')
local P = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
P:reset({ server = 'catseye', name = 'Test' })
P:set_state('quest.bastok.003', 'accepted')
P:set_current_step('quest.bastok.003', 'quest.bastok.003#g02')
local marks_ui = require('src.ui.marks')
local S = settings.defaults()
S.marks.obj_mark_dx, S.marks.obj_mark_dy = 6, -10
S.marks.near_name_dx, S.marks.near_name_dy = 20, 30
local placed = {}
local scene = {
    { index = 11, name = '???', x = 50, y = 60, z = 4, model_size = 2.5, grid = 'J-5', kind = 'npc' },
    { index = 20, name = 'Signpost', x = 55, y = 60, z = 4, model_size = 2, kind = 'npc', entity_type = 2 },
}
local ui = {
    settings = S, state = { ready = true },
    player = { zone_id = 191, x = 50, y = 60 },
    data = D, progress = P,
    platform = {
        visible_entities = function () return scene end,
        attach_available = function () return true end,
        set_name_marks = function () return true end,
        clear_name_marks = function () end,
        place_available = function () return true end,
        set_world_marks = function (items) placed = items; return true, #items end,
        clear_world_marks = function () placed = {} end,
        object_info = function (e) return { type = e.entity_type, name_shown = false } end,
    },
    imgui = { GetBackgroundDrawList = function () return setmetatable({}, { __index = function () return function () end end }) end },
}
local function draw()
    placed = {}
    marks_ui.draw(ui)
    local quest, sign
    for _, it in ipairs(placed) do
        if it.index == 11 then quest = it elseif it.index == 20 then sign = it end
    end
    return quest, sign
end

-- 両方オン：クエストのオブジェクトはクエストのオブジェクト名の位置、ほかは近くのオブジェクト名の位置
S.marks.show_object_names, S.marks.show_nearby_names = true, true
local q, sg = draw()
eq(q.under, '???', 'quest object named')
eq(q.name_dx, 6, 'both on: quest object name uses quest position x'); eq(q.name_dy, -10, 'both on: y')
eq(q.mark_dx, 6, 'icon stays at quest position')
eq(sg.name_dx, 20, 'nearby name x'); eq(sg.name_dy, 30, 'nearby name y')

-- クエストのオブジェクト名オフ・近くオン：近くとして出す名前は近くの位置（アイコンはそのまま）
S.marks.show_object_names = false
q, sg = draw()
eq(q.under, '???', 'named because nearby')
eq(q.name_dx, 20, 'nearby path: nearby position x'); eq(q.name_dy, 30, 'nearby path: y')
eq(q.mark_dx, 6, 'icon still at quest position x'); eq(q.mark_dy, -10, 'icon y')
eq(sg.name_dx, 20, 'signpost nearby position')

-- クエストのオブジェクト名だけ：今までどおり
S.marks.show_object_names, S.marks.show_nearby_names = true, false
q, sg = draw()
eq(q.name_dx, 6, 'quest only: quest position'); check(sg == nil, 'no nearby')

-- 同じ値なら見え方は今までと同じ
S.marks.near_name_dx, S.marks.near_name_dy = 6, -10
S.marks.show_object_names, S.marks.show_nearby_names = false, true
q, sg = draw()
eq(q.name_dx, 6, 'same values: same look'); eq(sg.name_dx, 6, 'same values: nearby same look')

-- 設定画面：見出しと2つの調整、「位置を元に戻す」で 0
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local AS = app._settings()
AS.marks.near_name_dx, AS.marks.near_name_dy = 12, -8
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('marks'); frame(); frame()
check(texted('位置の調整：近くのオブジェクト名') or labeled('位置の調整：近くのオブジェクト名'), 'heading')
check(texted('名前の位置（左右）') or labeled('名前の位置（左右）'), 'x row')
check(texted('名前の位置（上下）') or labeled('名前の位置（上下）'), 'y row')
check(labeled('##marks_near_name_dx') or labeled('marks_near_name_dx'), 'x slider id')
FAKE.clicks['##marks_pos_reset'] = true; frame(); frame()
eq(AS.marks.near_name_dx, 0, 'reset x'); eq(AS.marks.near_name_dy, 0, 'reset y')
app.close_all(); frame()
-- en の文言
local json = require('src.lib.json')
local EN = json.decode(io.open(ROOT .. '/locales/en.json'):read('*a'))
check(EN['settings.marks_pos_near'] and EN['settings.marks_near_name_dx'] and EN['settings.marks_near_name_dy'], 'en texts')
