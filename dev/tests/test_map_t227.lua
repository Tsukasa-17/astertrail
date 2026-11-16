-- 0.1.171（t227-map）：となりのエリアへの出口・自分の矢印と輪・モンスター名から地図・足元の輪
require('fake_env')
local GOT = { marks = nil, marks_calls = 0, active = true, heading = 1.0 }
_G.vana = {
    world = { marks = function (list) GOT.marks = list; GOT.marks_calls = GOT.marks_calls + 1 end },
    graphics = { info = function () return { active = GOT.active } end },
    game = {
        entity = function (i)
            if i == 5 then return { index = 5, heading = GOT.heading } end
            return nil
        end,
    },
}
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local P = require('src.platform.ashita')
local exits = require('src.core.exits')
local maps = require('src.core.maps')
local mv = require('src.ui.map_view')
local marks_ui = require('src.ui.marks')
local settings = require('src.core.settings')
local theme = require('src.ui.theme')
FAKE.player = { name = 'Tester', zone = 100, tidx = 5, status = 0, x = -100, y = 200, z = -60 }
frames(3)
local D = app._data()
local S = app._settings()

-- (1) 出口のデータ：西ロンフォール（100）
local ex = exits.of(D, 100)
eq(#ex, 8, 'West Ronfaure has 8 zone lines')
local nb = exits.neighbors(D, 100)
local by = {}
for _, g in ipairs(nb) do by[g.to] = g end
check(by[230] and #by[230].list == 1, 'South San d\'Oria once')
check(by[231] and #by[231].list == 2, 'North San d\'Oria: two ways, one entry')
eq(#nb, 6, 'six neighbours')
-- 座標の向き：ラテーヌ高原（102）は南（画像の下の方）、ゲルスバ（140）は北西
local f100 = maps.floors(D, 100)[1]
local bx, byy = maps.world_px(f100, by[102].list[1].x, by[102].list[1].y)
check(byy > 330, 'La Theine exit is in the south: ' .. byy)
bx, byy = maps.world_px(f100, by[140].list[1].x, by[140].list[1].y)
check(byy < 160 and bx < 200, 'Ghelsba exit is in the north-west')
check(by[230].list[1].at and by[230].list[1].at.x, 'exit has an arrival point')
-- 1枚の地図なら MAP はその1枚
eq(exits.map_n_of(D, maps, {}, 100, ex[1].x, ex[1].y), 1, 'single map: MAP 1')
-- 何枚かの地図（ウィンダス水の区 238）：位置が1枚の地図にしか入らなければその地図（0.1.175〜）。
-- 2枚以上に重なる位置は、覚えるまで分からない（推測しない）
local e238 = exits.of(D, 238)
check(#e238 > 0, 'zone 238 has exits')
local n_uniq, n_amb = 0, 0
for _, e in ipairs(e238) do
    local inside = {}
    for _, f in ipairs(maps.floors(D, 238)) do
        local bx, by = maps.world_px(f, e.x, e.y)
        if bx and bx >= 0 and by >= 0 and bx <= maps.BASE and by <= maps.BASE then inside[#inside + 1] = f.map_n end
    end
    local got = exits.map_n_of(D, maps, {}, 238, e.x, e.y)
    if #inside == 1 then n_uniq = n_uniq + 1; eq(got, inside[1], 'multi map: only one map holds it')
    else n_amb = n_amb + 1; eq(got, nil, 'multi map: overlapping, unknown until learned') end
end
check(n_uniq + n_amb == #e238, 'all 238 exits judged')
local amb_zone, amb_e
for _, zid in ipairs({ 238, 239, 240, 241, 234, 235, 236, 237, 231, 232 }) do
    for _, e in ipairs(exits.of(D, zid)) do
        local c = 0
        for _, f in ipairs(maps.floors(D, zid)) do
            local bx, by = maps.world_px(f, e.x, e.y)
            if bx and bx >= 0 and by >= 0 and bx <= maps.BASE and by <= maps.BASE then c = c + 1 end
        end
        if c > 1 and not amb_e then amb_zone, amb_e = zid, e end
    end
end
check(amb_e ~= nil, 'an overlapping exit exists')
eq(exits.map_n_of(D, maps, {}, amb_zone, amb_e.x, amb_e.y), nil, 'overlapping: unknown until learned')
eq(exits.unlearned(D, maps, {}, 100), 0, 'single map zone: nothing to learn')
check(exits.unlearned(D, maps, {}, 238) > 0, 'multi map zone: points to learn')
local learned = {}
local n = exits.learn(D, maps, learned, 238, function (x, y, z) return 2 end)
check(n > 0, 'learned some: ' .. n)
eq(exits.map_n_of(D, maps, learned, 238, e238[1].x, e238[1].y), 2, 'learned: MAP 2 (FloorId 2)')
eq(exits.learn(D, maps, learned, 238, function () return 2 end), 0, 'nothing new the second time')
eq(exits.learn(D, maps, {}, 238, function () return nil end), 0, 'no floor, nothing learned')
eq(exits.learn(D, maps, {}, 100, function () return 1 end), 0, 'single map zones are not looked up')
-- 覚えた階はファイルに残る（全キャラ共通）
app.state.exit_floors = nil
app.state.exit_learned_zone = nil
P.floor_at = function () return 2 end
FAKE.player.zone = 238; frames(3)
local saved = app.exit_floors()
check(saved['238'] and next(saved['238']) ~= nil, 'learned on entering 238')
app.state.exit_floors = nil
check(app.exit_floors()['238'] ~= nil, 'read back from exit_floors.json')
FAKE.player.zone = 100; frames(3)

-- (2) 地図：となりのエリアのボタンは出さない（0.1.175〜。出口は地図の上だけ）。出口を押すとその地図・戻る・現在地
local GUI = { state = app.state, data = D, exit_floors = app.exit_floors, player = app.state.player }
local function go_exit(e) mv.go(GUI, e); frame(); frame() end
app.open_map(); frame(); frame()
eq(app.state.map.loc and app.state.map.loc.zone_id, 100, 'map with no quest opens the current area')
check(not labeled('##nb_230') and not labeled('##nb_102'), 'no neighbour buttons')
check(not labeled('となりのエリア'), 'no neighbour heading')
check(labeled('##nav_here'), 'where-am-I button')
check(not labeled('##nav_back'), 'no back yet')
go_exit(by[102].list[1])
local info = app.state.map
eq(info.loc.zone_id, 102, 'neighbour map opened')
check(info.arrive and info.arrive.zone_id == 102, 'arrival point kept')
eq(info.map_n, 1, 'La Theine MAP 1')
check(texted('◎'), 'arrival legend shown')
-- 0.1.178〜（t286）：来たときに立つ位置で輪が数回広がってから消える（正しい MAP で初めて見えたときから）
check(info.arrive.pulse_at ~= nil, 'arrival pulse started')
do
    local p0 = mv.arrive_pulse(0, false)
    check(#p0 >= 1 and p0[1].alpha > 0.5, 'pulse visible at the start')
    local a1, a2 = mv.arrive_pulse(0.2, false), mv.arrive_pulse(0.7, false)
    check(a2[1].r > a1[1].r and a2[1].alpha < a1[1].alpha, 'ring grows and fades')
    local total = mv.PULSE_N * mv.PULSE_PERIOD
    check(#mv.arrive_pulse(total - 0.1, false) >= 1, 'several pulses')
    eq(#mv.arrive_pulse(total + mv.PULSE_FADE + 0.01, false), 0, 'gone after the pulses')
    local r1, r2 = mv.arrive_pulse(0.2, true), mv.arrive_pulse(1.5, true)
    eq(r1[1].r, r2[1].r, 'reduce motion: the ring does not grow')
    check(r2[1].alpha < r1[1].alpha, 'reduce motion: it only fades')
    eq(#mv.arrive_pulse(total + mv.PULSE_FADE + 0.01, true), 0, 'reduce motion: gone too')
    -- 描く数：輪のあいだは多く、終わったら二重の輪だけ
    local function circles(age)
        local c = setmetatable({ n = 0 }, { __index = function (t, k) return function () if k == 'AddCircle' then t.n = t.n + 1 end end end })
        mv._draw_overlay_for_test(c, function (x, y) return x, y end, { 0, 0, 512, 512 }, nil, nil,
            { arrive = { base_x = 50, base_y = 50, age = age } }, nil)
        return c.n
    end
    check(circles(0.1) > circles(99), 'rings drawn during the pulse only')
    eq(circles(99), circles(nil), 'afterwards the plain arrival mark')
    local t0 = info.arrive.pulse_at
    frames(1); eq(info.arrive.pulse_at, t0, 'pulse start kept while drawing')
end
check(labeled('##nav_back'), 'back button')
local back100
for _, e in ipairs(exits.of(D, 102)) do if e.to == 100 then back100 = e break end end
check(back100 ~= nil, 'La Theine has an exit back to West Ronfaure')
go_exit(back100)
eq(app.state.map.loc.zone_id, 100, 'and on again')
eq(#app.state.map.back, 2, 'two steps of back')
FAKE.clicks['##nav_back'] = true; frame(); frame()
eq(app.state.map.loc.zone_id, 102, 'back once')
FAKE.clicks['##nav_back'] = true; frame(); frame()
eq(app.state.map.loc.zone_id, 100, 'back twice')
check(not labeled('##nav_back'), 'back runs out')
go_exit(by[230].list[1])
FAKE.clicks['##nav_here'] = true; frame(); frame()
eq(app.state.map.loc.zone_id, 100, 'where-am-I returns to the current area')
app.close_window('map'); frame()

-- 地図の上の出口：マウスの下なら行き先（押すとその地図）
local rec = setmetatable({ n = 0 }, { __index = function (t, k) return function () t.n = t.n + 1 end end })
local hot = mv._draw_overlay_for_test(rec, function (x, y) return x, y end, { 0, 0, 512, 512 }, nil, nil,
    { exits = { { base_x = 100, base_y = 100, to = 230, name = 'x' } } }, { x = 104, y = 98 })
eq(hot and hot.to, 230, 'exit under the mouse')
hot = mv._draw_overlay_for_test(rec, function (x, y) return x, y end, { 0, 0, 512, 512 }, nil, nil,
    { exits = { { base_x = 100, base_y = 100, to = 230 } } }, { x = 140, y = 140 })
eq(hot, nil, 'not under the mouse')

-- (3) 自分の矢印：heading 0 は東（右）、π/2 は画面の下（南）。読めなければ菱形
local tip = mv.arrow_points(0, 0, 10, 0)
check(tip[1] > 9 and math.abs(tip[2]) < 1e-6, 'heading 0 points right (east)')
tip = mv.arrow_points(0, 0, 10, math.pi / 2)
check(tip[2] > 9 and math.abs(tip[1]) < 1e-6, 'heading pi/2 points down')
eq(app.state.player.heading, 1.0, 'heading read from vana.game.entity')
-- 範囲の外にいるときは、ふちの矢印（落ちずに描ける）
mv._draw_overlay_for_test(rec, function (x, y) return nil, nil, x + 900, y end, { 0, 0, 512, 512 }, nil,
    { base_x = 10, base_y = 10 }, { heading = 0, t = 1 }, nil)
check(rec.n > 0, 'edge arrow drawn')

-- (4) モンスター名から地図：近くにいる同じ名前の相手（読み込まれている相手だけ）
local Qh, sh = 'quest.bastok.004', 'quest.bastok.004#g02'
local st = D:step(sh)
local tg = D:target(st.target)
eq(tg.kind, 'mob', 'the step target is a monster')
local mz = (st.location and st.location.zone_id) or (tg.location and tg.location.zone_id)
FAKE.player.zone = mz; FAKE.player.x = 0; FAKE.player.y = 0; frames(3)
P.visible_entities = function ()
    return {
        { index = 300, name = tg.name_en, x = 30, y = 40, kind = 'mob' },
        { index = 301, name = tg.name_en, x = 5, y = 0, kind = 'mob', dead = true },
        { index = 302, name = 'Someone Else', x = 1, y = 1, kind = 'mob' },
        { index = 303, name = tg.name_en, x = 8, y = 6, kind = 'mob' },
    }
end
app.open_map(Qh, sh, nil, { mob = st.target }); frame(); frame()
eq(app.state.map.mob.name, tg.name_en, 'looking for the monster')
local found = mv.find_mobs({ platform = P, player = app.state.player, state = app.state }, app.state.map, mz)
eq(#found, 2, 'two alive with the same name')
eq(math.floor(found[1].dist + 0.5), 10, 'nearest first (10 yalms)')
check(texted('近くにいる：2体'), 'legend: two nearby')
P.visible_entities = function () return {} end
app.state.map.mob_cache = nil; frame(); frame()
check(texted('近くには見つかりません'), 'legend: none nearby')
FAKE.player.zone = 100; frames(3)
app.state.map.mob_cache = nil; frame(); frame()
check(texted('このエリアにいないので'), 'legend: not in that area')
app.close_window('map'); frame()

-- (5) 足元の輪：アイコンと同じ色、近い順に16まで、オフで出さない、大きさの設定
local rows = {}
for i = 1, 20 do
    rows[#rows + 1] = { entity = { x = i, y = 0, z = 0, hitbox_size = 2 }, icon = (i == 1) and 'progress' or 'hunt' }
end
rows[#rows + 1] = { entity = { x = 0.5, y = 0, z = 0, dead = true }, icon = 'progress' }
local ui = { settings = S, platform = {} }
local rings = marks_ui.ground_rings(ui, rows, { x = 0, y = 0 })
eq(#rings, 16, 'at most 16 rings')
eq(rings[1].color, '#6BBDFF', 'in progress: sky blue')
eq(rings[2].color, '#FF998C', 'defeat: coral')
eq(rings[1].radius, 2, 'radius from the hitbox')
S.marks.ring_size = 2
eq(marks_ui.ground_rings(ui, rows, { x = 0, y = 0 })[1].radius, 4, 'ring size setting')
S.marks.ring_size = 1
S.marks.ring_progress = { 1, 2, 3 }
eq(marks_ui.ground_rings(ui, rows, { x = 0, y = 0 })[1].color, '#010203', 'own colour per kind')
S.marks.ring_progress = { 107, 189, 255 }
S.marks.show_rings = false
eq(#marks_ui.ground_rings(ui, rows, { x = 0, y = 0 }), 0, 'off: no rings')
S.marks.show_rings = true
-- 公式 vana.world.marks に渡す（シーンの効果が使えるとき）
eq(marks_ui.apply_rings({ platform = P, imgui = require('imgui') }, rings), 'native', 'native rings')
eq(#GOT.marks, 16, 'handed to vana.world.marks')
eq(GOT.marks[1].color, '#6BBDFF', 'colour handed over')
eq(marks_ui.apply_rings({ platform = P, imgui = require('imgui') }, {}), 'off', 'empty list clears')
eq(GOT.marks, nil, 'cleared with marks()')
-- 使えないとき（active=false）は、画面に写して描く
GOT.active = false
-- 0.1.210〜：場面の効果の有無は 1 秒ごとに聞く。テストではすぐ読み直させる
require('src.platform.vanacore_ext').clear_rings_native_cache()
P.world_to_screen = function (x, y, z) return x * 10, y * 10 end
eq(marks_ui.apply_rings({ platform = P, imgui = require('imgui') }, rings), 'imgui', 'drawn by the addon when the scene effects are off')
GOT.active = true
require('src.platform.vanacore_ext').clear_rings_native_cache()
-- 初めの色は今のアイコンの色
local function rgb(k) local c = theme.palette[k]; return { math.floor(c[1] * 255 + 0.5), math.floor(c[2] * 255 + 0.5), math.floor(c[3] * 255 + 0.5) } end
local d = settings.defaults().marks
for kind, pk in pairs({ sub = 'ic_sub', progress = 'ic_progress', blocked = 'ic_bad', complete = 'ic_done', ['repeat'] = 'ic_repeat',
    unavailable = 'ic_bad', hunt = 'mob', main = 'ic_main', guard = 'gold', fame = 'ic_fame' }) do
    local want = rgb(pk)
    local got = d['ring_' .. kind]
    check(got[1] == want[1] and got[2] == want[2] and got[3] == want[3], 'default ring colour = icon colour: ' .. kind)
end
eq(settings.merge({ marks = { ring_size = 9 } }).marks.ring_size, 3, 'ring size held to 3')
eq(settings.merge({ marks = { ring_progress = 'x' } }).marks.ring_progress[1], 107, 'broken colour back to the first')
-- 設定の画面：足元の輪の色の行（10種類）
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('marks'); frame(); frame()
local n_rows = 0
for _, kind in ipairs(settings.RING_KINDS) do
    for _, l in ipairs(FAKE.labels) do if l:find('marks_ring_' .. kind, 1, true) then n_rows = n_rows + 1; break end end
end
eq(n_rows, 10, 'ten ring colour rows')
check(labeled('marks_rings'), 'rings switch')
app.close_all(); frame()

-- 0.1.181〜（t292）：町と中の建物の行き来（LSB ではスクリプトで動かすもの）も出口に入る
do
    local function to_of(z, to)
        for _, e in ipairs(exits.of(D, z)) do if e.to == to then return e end end
        return nil
    end
    local function arrives(z, from)
        for _, e in ipairs(exits.arrivals(D, z)) do if e.from == from then return e end end
        return nil
    end
    for _, pr in ipairs({ { 231, 233 }, { 233, 231 }, { 239, 242 }, { 242, 239 }, { 257, 284 }, { 284, 257 } }) do
        check(to_of(pr[1], pr[2]) ~= nil, 'scripted exit ' .. pr[1] .. ' -> ' .. pr[2])
    end
    check(arrives(233, 231) and arrives(231, 233) and arrives(239, 242) and arrives(257, 284), 'arrival points for scripted exits')
    -- 地図の上に置ける（1枚の地図、画像の中）
    for _, pr in ipairs({ { 231, 233 }, { 233, 231 }, { 239, 242 }, { 257, 284 } }) do
        local e = to_of(pr[1], pr[2])
        local mn = exits.map_n_of(D, maps, {}, pr[1], e.x, e.y, nil)
        eq(mn, 1, 'scripted exit on map 1: ' .. pr[1])
        local fl = maps.floors(D, pr[1])[1]
        local bx, by = maps.world_px(fl, e.x, e.y)
        check(bx and bx >= 0 and by >= 0 and bx <= maps.BASE and by <= maps.BASE, 'scripted exit inside the map image: ' .. pr[1])
    end
    -- 北サンドリアの出口は x=0（I と J の境目）。少し西は BG Wiki と同じ I-6
    local fl231 = maps.floors(D, 231)[1]
    local c = maps.grid_name(maps.world_px(fl231, to_of(231, 233).x - 0.01, to_of(231, 233).y))
    eq(c, 'I-6', 'chateau exit cell in Northern San d\'Oria')
end

-- 読み込み解除で輪を消す
marks_ui.apply_rings({ platform = P, imgui = require('imgui') }, rings)
check(GOT.marks ~= nil, 'rings on before unload')
FAKE.events.unload()
eq(GOT.marks, nil, 'unload clears the rings')
