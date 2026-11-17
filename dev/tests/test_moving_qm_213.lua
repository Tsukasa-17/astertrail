-- 0.1.213：消えた ??? に印を残さない・動いた相手に印がついていく・場所が変わる ???（バストゥーク 7-1）の候補と番号
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local P = require('src.platform.ashita')
local marks_core = require('src.core.marks')
local marks_ui = require('src.ui.marks')
local mv = require('src.ui.map_view')
local maps = require('src.core.maps')

-- 相手の表を真似る。render の 0x200 が「描かれている」
local E = {}
local function put(i, t) E[i] = t end
local function fake_entity()
    local function f(key) return function (_, i) local e = E[i]; return e and e[key] end end
    return {
        GetName = f('name'), GetSpawnFlags = f('spawn'), GetRenderFlags0 = f('render'),
        GetServerId = f('sid'), GetHealthPercent = function (_, i) return E[i] and 100 or nil end,
        GetStatus = function (_, i) if i == 5 then return FAKE.player.status end return E[i] and 0 or nil end,
        GetLocalPositionX = function (_, i) if i == 5 then return FAKE.player.x end local e = E[i]; return e and e.x end,
        GetLocalPositionY = function (_, i) if i == 5 then return FAKE.player.y end local e = E[i]; return e and e.y end,
        GetLocalPositionZ = function (_, i) if i == 5 then return FAKE.player.z end local e = E[i]; return e and e.z end,
        GetDistance = function () return 25 end,
    }
end
local real_mm = AshitaCore.GetMemoryManager
AshitaCore.GetMemoryManager = function (self)
    local mm = real_mm(self)
    local wrap = setmetatable({ GetEntity = function () return fake_entity() end }, { __index = mm })
    return wrap
end
local function by_index(rows, i)
    for _, r in ipairs(rows) do if r.index == i then return r end end
    return nil
end

FAKE.player = { name = 'Tester', zone = 122, tidx = 5, status = 0, x = 100, y = -100, z = -4 }
put(5, { name = 'Tester', spawn = 1, render = 0x200, sid = 0x400001, x = 100, y = -100, z = -4 })
frames(1)

-- (1) 消えた ??? は出さない（render の印が使えるとき）
do
    put(300, { name = '???', spawn = 0, render = 0x200, sid = 0x107A12C, x = 10, y = 10, z = 0 })
    put(301, { name = '???', spawn = 0, render = 0, sid = 0x107A12D, x = 20, y = 20, z = 0 })
    put(302, { name = 'Old Man', spawn = 2, render = 0, sid = 0x107A12E, x = 30, y = 30, z = 0 })
    P.clear_entity_cache()
    local rows = P.visible_entities()
    eq(P.entity_render_usable(), true, 'render flags usable (the player has 0x200)')
    check(by_index(rows, 300) ~= nil, 'a shown ??? is kept even with spawn flags 0')
    eq(by_index(rows, 301), nil, 'a ??? that is not shown is dropped')
    eq(by_index(rows, 302), nil, 'any entity that is not shown is dropped')
    -- 全体の読み直しのあいだ（0.25 秒）でも、消えたらすぐ外す
    E[300].render = 0
    rows = P.visible_entities()
    eq(by_index(rows, 300), nil, 'despawned ??? dropped at once between full scans')
    FAKE.time = FAKE.time + 0.3
    rows = P.visible_entities()
    eq(by_index(rows, 300), nil, 'and stays dropped after the next full scan')
    -- また出たら、次の全体の読み直しで戻る
    E[300].render = 0x200
    FAKE.time = FAKE.time + 0.3
    rows = P.visible_entities()
    check(by_index(rows, 300) ~= nil, 'respawned ??? found again on the next full scan')
    -- 動いた相手：印の位置は今の位置についていく（読み直しのあいだも）
    E[300].x, E[300].y = 55, -66
    rows = P.visible_entities()
    local r = by_index(rows, 300)
    eq(r and r.x, 55, 'moved entity: x follows'); eq(r and r.y, -66, 'moved entity: y follows')
    E[300], E[301], E[302] = nil, nil, nil
end

-- (2) render が読めないときは前のやり方（spawn が 0 の相手は外す、??? は残す）
do
    local saved = E
    E = {}
    put(5, { name = 'Tester', spawn = 1, sid = 1, x = 0, y = 0, z = 0 })
    put(300, { name = '???', spawn = 0, x = 1, y = 1, z = 0 })
    put(302, { name = 'Old Man', spawn = 0, x = 3, y = 3, z = 0 })
    P.clear_entity_cache()
    local rows = P.visible_entities()
    eq(P.entity_render_usable(), false, 'no render flags: not used')
    check(by_index(rows, 300) ~= nil, 'fallback keeps ??? like before')
    eq(by_index(rows, 302), nil, 'fallback drops spawn 0 like before')
    E = saved
    P.clear_entity_cache()
end

-- (3) データ：7-1 の ??? は番号と 10 か所の候補を持つ
local D = app._data()
local tg = D:target('obj.122.???_BM7-1')
check(tg ~= nil, 'target exists')
eq(tg.server_id, 17277208, 'server id')
eq(#tg.candidates, 10, 'ten candidates')
for _, c in ipairs(tg.candidates) do check(c.grid ~= 'G-8', 'no G-8') end
for _, sid in ipairs({ 'mission.bastok.015#g02', 'mission.bastok.015#g05' }) do
    eq(D:step(sid).target, 'obj.122.???_BM7-1', sid .. ' uses the moving ???')
end
local floor = maps.floors(D, 122)[1]
local cands = marks_core.candidates_for(D, D:step('mission.bastok.015#g02'))
eq(#cands, 10, 'candidates_for gives ten')
for _, c in ipairs(cands) do
    local bx, by = maps.world_px(floor, c.x, c.y)
    local g = maps.grid_name(bx, by)
    local ok = (g == c.grid) or (c.grid == 'I-8/J-8' and (g == 'I-8' or g == 'J-8')) or (c.grid == 'L-10' and (g == 'L-10' or g == 'L-11'))
    check(ok, 'candidate lands on its grid: ' .. tostring(c.grid) .. ' -> ' .. tostring(g))
end
eq(marks_core.candidates_for(D, D:step('mission.bastok.015#g04')), nil, 'no candidates on the fight step')

-- (4) 番号で見分ける：同じゾーンのほかの ??? には付けない
local PR = app._progress()
PR:set_state('mission.bastok.015', 'accepted')
PR:set_current_step('mission.bastok.015', 'mission.bastok.015#g02')
local wanted = marks_core.in_zone(marks_core.wanted(D, PR, {}), 122)
local w7
for _, w in ipairs(wanted) do if w.target_id == 'obj.122.???_BM7-1' then w7 = w end end
check(w7 ~= nil, 'the moving ??? is wanted on g02')
eq(w7 and w7.server_id, 17277208, 'wanted carries the server id')
eq(w7 and w7.require_grid, false, 'no grid needed')
local others = {
    { index = 233, name = '???', server_id = 17277169, x = 0, y = 0 },
    { index = 281, name = '???', server_id = 17277209, x = 260, y = 10 },
    { index = 313, name = '???', server_id = 17277241, x = 5, y = 5 },
}
local function matched_ids(ents)
    local out = {}
    for _, row in ipairs(marks_core.match({ w7 }, ents, { zone_id = 122 })) do out[#out + 1] = row.entity.server_id or row.entity.index end
    return out
end
eq(#matched_ids(others), 0, 'other ??? in the zone are not matched')
local qm2 = { index = 280, name = '???', server_id = 17277208, x = 105, y = -112, z = -4 }
local ids = matched_ids({ others[1], qm2, others[2], others[3] })
eq(#ids, 1, 'only one matched'); eq(ids[1], 17277208, 'matched qm2 by id')
-- 名前が読めない・番号が読めないときは、ゾーンと読み込みの番号で
ids = matched_ids({ { index = 280, name = nil, x = 1, y = 1 } })
eq(#ids, 1, 'nameless qm2 matched by zone and index')
check(not marks_core.same_server_id(17277208, { index = 280 }, 123), 'other zone: not matched by index')

-- (5) 地図：見えていなければ候補、qm2 が出ていれば本物の位置、消えたら候補に戻る
put(281, { name = '???', spawn = 0, render = 0x200, sid = 17277209, x = 260, y = 10, z = -6 })
P.clear_entity_cache()
app.open_map('mission.bastok.015', 'mission.bastok.015#g02')
frame(); frame()
check(app.state.open.map, 'map open')
check(texted('出るかもしれない場所（10か所）'), 'candidates legend when qm2 is not loaded')
check(not texted('近くで見えた相手の位置'), 'no live pin yet')
eq(marks_ui.live_position({ state = app.state }, 122, 'obj.122.???_BM7-1'), nil, 'the M-8 ??? is not taken for qm2')

put(280, { name = '???', spawn = 0, render = 0x200, sid = 17277208, x = 105, y = -112, z = -4 })
FAKE.time = FAKE.time + 0.3
frame(); frame()
local lp = marks_ui.live_position({ state = app.state }, 122, 'obj.122.???_BM7-1')
check(lp ~= nil and lp.x == 105 and lp.y == -112, 'live position from qm2')
check(texted('近くで見えた相手の位置'), 'live pin when qm2 is loaded')
check(not texted('出るかもしれない場所'), 'candidates hidden when qm2 is loaded')

-- 動いたら、地図のピンもついていく
E[280].x, E[280].y = -48, -32
frame(); frame()
lp = marks_ui.live_position({ state = app.state }, 122, 'obj.122.???_BM7-1')
check(lp ~= nil and lp.x == -48 and lp.y == -32, 'live position follows the move')

-- 消えたら、候補に戻る（古い場所は残さない）
E[280].render = 0
frame(); frame()
eq(marks_ui.live_position({ state = app.state }, 122, 'obj.122.???_BM7-1'), nil, 'forgotten on despawn')
check(texted('出るかもしれない場所（10か所）'), 'candidates back after despawn')

-- 候補の印は小さい白抜きの丸（ピンより小さい）
do
    local radii = {}
    local rec = setmetatable({}, { __index = function (_, k)
        return function (_, _, r) if k == 'AddCircleFilled' then radii[#radii + 1] = r end end
    end })
    mv._draw_overlay_for_test(rec, function (x, y) return x, y end, { 0, 0, 512, 512 }, nil, nil,
        { cands = { { base_x = 10, base_y = 10 }, { base_x = 20, base_y = 20 } } }, nil)
    check(#radii >= 2, 'candidate circles drawn')
    local maxr = 0
    for _, r in ipairs(radii) do if r > maxr then maxr = r end end
    check(maxr < 10, 'candidate marks are smaller than the pin (r 10): ' .. maxr)
end

app.close_window('map'); frame()
AshitaCore.GetMemoryManager = real_mm
P.clear_entity_cache()
print('test_moving_qm_213 done')
