-- 0.1.81〜：物（??? など）を調べて受けるクエストは、未受注なら物の上に「未受注」のアイコン（0.1.63 の sub）。
-- 役割の「調べる」は置き場所（物の体の上・物用の位置）だけに使い、見た目は状態のアイコンのまま。
require('harness')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local marks = require('src.core.marks')
local settings = require('src.core.settings')

local D = data_mod.load(posix_fs(), ROOT .. '/data/')
local P = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
P:reset({ server = 'catseye', name = 'Test' })

-- データから、同じ ??? から受けるクエストを集める（アラパゴ暗礁域 H-10 の難破船の ???）
local tid = 'obj.54.???_H-10'
local tg = D:target(tid)
check(tg ~= nil, 'start ??? exists')
local qs = {}
for _, q in ipairs(D.quests or {}) do
    local st = D.start_target and D:start_target(q)
    if not st and q.start then st = D:target(q.start.target) end
    if st and st.id == tid then qs[q.id] = true end
end
local nq = 0
for _ in pairs(qs) do nq = nq + 1 end
check(nq >= 1, 'quests start at the ???: ' .. nq)

local marks_ui = require('src.ui.marks')
local S = settings.defaults()
local placed, attached = {}, {}
local scene = {
    { index = 31, name = '???', x = 10, y = 10, z = 0, model_size = 2, grid = tg.location.grid, kind = 'npc', entity_type = 2 },
    { index = 32, name = '???', x = 90, y = 90, z = 0, model_size = 2, grid = 'A-1', kind = 'npc', entity_type = 2 },
}
local ui = {
    settings = S, state = { ready = true },
    player = { zone_id = tg.location.zone_id, x = 10, y = 10, map_n = tg.location.map and tg.location.map.n },
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
        entity_world_screen = function () return 1, 1, 'x' end,
    },
    imgui = { GetBackgroundDrawList = function () return setmetatable({}, { __index = function () return function () end end }) end },
}
S.marks.show_icons, S.marks.show_quest_name = true, true
marks_ui.draw(ui)

local on_obj, other, names = 0, 0, {}
for _, it in ipairs(placed) do
    if not it.name_only then
        if it.index == 31 then
            on_obj = on_obj + 1
            if not it.no_icon then
                eq(it.look, 'sub', 'look is the 未受注 icon')
                eq(it.role, 'examine', 'placed as an object')
            end
        else
            other = other + 1
        end
    end
end
for _, it in ipairs(attached) do
    check(it.index ~= 31, 'not attached to a name like an NPC')
end
check(on_obj >= 1, 'icon on the ??? at its square: ' .. on_obj)
eq(other, 0, 'nothing on the ??? at another square')

-- 受注したら、今の手順の状態のアイコンに変わる（進行中・目標達成）
for qid in pairs(qs) do
    local q = D:quest(qid)
    P:set_state(qid, 'accepted')
    local s1 = q.steps[1]
    P:set_current_step(qid, s1.id)
    local icon = marks.quest_icon(D, P, q)
    check(icon == 'progress' or icon == 'complete' or icon == 'blocked', qid .. ': accepted icon ' .. tostring(icon))
    for _, w in ipairs(marks.wanted(D, P)) do
        if w.quest_id == qid and w.role ~= 'hunt' then
            eq(w.icon, icon, qid .. ': step mark uses the step status icon')
        end
    end
    P:set_state(qid, 'not_accepted')
end

print('test_obj_start_icon ok')
