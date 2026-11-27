-- 0.1.324：天の塔の地図を 1024 px で描き直し（地形・水・階段の段）、層どうしのつながりの印を外した。
-- 天の塔の NPC・オブジェクトの手順は、その層の地図にピンを出す。「現在地」の地図は、いる層・ページ・ゾーンについていく（全ゾーン）。
require('fake_env')
_G.vana = _G.vana or {}
vana.world = vana.world or { marks = function () end }
vana.graphics = vana.graphics or { info = function () return { active = true } end }
vana.game = vana.game or { entity = function () return nil end }
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local maps = require('src.core.maps')
local mv = require('src.ui.map_view')
local json = require('src.lib.json')
eq(app.VERSION, '1.1.327', 'version')
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')
FAKE.player = { name = 'Tester', zone = 100, tidx = 5, status = 0, x = -100, y = 200, z = -60 }
frames(3)
local D = app._data()
local function read(p) local f = io.open(ROOT .. '/' .. p, 'r'); if not f then return nil end local s = f:read('*a'); f:close(); return s end

-- (1) 層どうしのつながり（0.1.322 の floor links、0.1.323 の天の塔の 6 か所）は機能ごと外した。出口は残る
for _, p in ipairs({ 'src/core/floor_links.lua', 'data/floor_links.json', 'dev/build_floor_links.py' }) do
    eq(read(p), nil, p .. ' removed')
end
check(not read('install_files.json'):find('floor_links', 1, true), 'not in the install list')
for _, p in ipairs({ 'locales/ja.json', 'locales/en.json' }) do
    local s = read(p)
    check(not s:find('floor_link_tip', 1, true) and not s:find('floor_arrive_legend', 1, true), p .. ': link texts removed')
end
eq(mv.floor_link_marks, nil, 'no link marks in the map view')
local srcj = read('dev/sources/heavens_tower_242.json')   -- dev/sources は公開のリポジトリには無い
if srcj then eq(json.decode(srcj).links, nil, 'tower source has no links') end
check(#require('src.core.exits').of(D, 242) == 1, 'the exit to Windurst stays')

-- (2) 天の塔では、MAP 番号が無くても「未確認」と言わない。資料の高さがあればその層
for n = 1, 4 do
    local f, why = maps.pick_floor(D, { zone_id = 242 }, n)
    eq(f and f.map_n, n, 'chosen MAP ' .. n); eq(why, nil, 'no warning on MAP ' .. n)
end
local f0, why0 = maps.pick_floor(D, { zone_id = 242, zone_name = '天の塔' })
check(f0 ~= nil and why0 == nil, 'no unknown_map in Heaven\'s Tower')
local fz = maps.pick_floor(D, { zone_id = 242, pos = { x = 0, y = 20, z = 30.749 } })
eq(fz and fz.map_n, 1, 'height of the data picks MAP 1')
local _, w238 = maps.pick_floor(D, { zone_id = 238 })
eq(w238, 'unknown_map', 'other multi-map zones still warn')

-- (3) 天の塔の NPC・オブジェクト：手順の場所に MAP 番号・マス目・座標。その層の地図にピン
local WANT = {
    Kupipi = 2, Zubaba = 3, Rhy_Epocan = 4, Chumimi = 1, Sheelala = 2, ['Habida-Jubida'] = 2,
    ['Sassa-Kotassa'] = 2, Door_Vestal_Chamber = 4,
}
local guides = json.decode(read('data/guides/steps_v2.json'))
local seen, nopin = {}, {}
for _, g in ipairs(guides.guides) do
    for _, s in ipairs(g.steps) do
        local L = s.location
        if L and L.zone_id == 242 then
            if s.target then
                local key = s.target:match('^[no][pb][cj]%.[^.]+%.(.+)$')
                local n = WANT[key]
                check(n ~= nil, 'known target ' .. s.target)
                eq(L.map and L.map.kind, 'number', s.id .. ' has a MAP number')
                eq(L.map and L.map.n, n, s.id .. ' on MAP ' .. tostring(n))
                check(L.pos and L.grid, s.id .. ' has a position and grid')
                local f, why = maps.pick_floor(D, L)
                eq(f and f.map_n, n, s.id .. ' opens MAP ' .. tostring(n)); eq(why, nil, s.id .. ' no warning')
                check(maps.dest_on_floor(f, L, 4), s.id .. ' pin is shown')
                local pin = maps.pin(f, L, maps.BASE)
                check(pin and pin.base_x > 16 and pin.base_x < 496 and pin.base_y > 16 and pin.base_y < 496, s.id .. ' pin on the map')
                eq(pin.grid, L.grid, s.id .. ' grid matches the pin')
                seen[key] = true
                local tg = D:target(s.target)
                eq(tg and tg.location and tg.location.map and tg.location.map.n, n, s.target .. ' target on MAP ' .. tostring(n))
            else
                nopin[#nopin + 1] = s.id
            end
        end
    end
end
for k in pairs(WANT) do check(seen[k], 'steps of ' .. k) end
eq(#nopin, 2, 'two steps without a target (event on entering)')
-- 扉は床より少し上：床の高さで決める（Door:Vestal Chamber は床 -49.0、羅星の間の MAP 4）
local tv = D:target('obj.天の塔.Door_Vestal_Chamber')
eq(tv.location.map.n, 4, 'Vestal Chamber door on MAP 4')
-- 実際に：手順から地図を開くと、その層。ほかの層にいても警告は出ない
local S = app._settings()
S.map = S.map or {}
S.map.enabled = true
local P = require('src.platform.ashita')
local old_tex = P.load_texture
P.load_texture = function (img) return { _tex = true, w = img.width, h = img.height } end
install_backslash_io()
local qk, sk
for _, g in ipairs(guides.guides) do
    for _, s in ipairs(g.steps) do
        if s.target == 'npc.天の塔.Kupipi' and not qk and D:quest(g.quest) then qk, sk = g.quest, s.id end
    end
end
check(qk ~= nil, 'a quest with a Kupipi step')
FAKE.player = { name = 'Tester', zone = 242, tidx = 5, status = 0, x = 0, y = 20, z = 30.75 }
frames(3)
app.open_map(qk, sk)
app.state.floor_at = nil
frame(); frame(); frame()
eq(app.state.map.here, nil, 'a quest map is not 現在地')
eq(app.state.map.map_n, 2, 'Kupipi step opens MAP 2 (the player is on MAP 1)')
app.close_window('map'); frame()

-- (4) 「現在地」：全ゾーンで、いるページについていく。自分で選んだページはそのまま
local fid = 1
local old_fid = P.current_floor_id
P.current_floor_id = function () return fid end
FAKE.player = { name = 'Tester', zone = 238, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
frames(3)
app.state.zone_entered_at[238] = -100
app.open_map(nil, nil, nil, { here = true })
eq(app.state.map.here, true, 'opened as 現在地')
app.state.floor_at = nil
frames(2)
eq(app.state.floor.map_n, 1, 'Windurst Waters FloorId 1 = MAP 1')
eq(app.state.map.map_n, 1, 'shows MAP 1')
fid = 2
app.state.floor_at = nil
frames(2)
eq(app.state.floor.map_n, 2, 'walked into MAP 2')
eq(app.state.map.map_n, 2, 'the map followed to MAP 2 (not a height zone)')
app.state.map.map_n = 1   -- 自分で選ぶ（いるのは MAP 2 のまま）
app.state.floor_at = nil
frames(2)
app.state.floor_at = nil
frames(2)
eq(app.state.map.map_n, 1, 'picked by hand: kept')
-- 選んだページに自分で入ったあとは、またついていく（天の塔と同じ）
fid = 1; app.state.floor_at = nil; frames(2)
fid = 2; app.state.floor_at = nil; frames(2)
eq(app.state.map.map_n, 2, 'after walking onto the picked page, it follows again')
app.close_window('map'); frame()
-- クエストの地図（現在地でない）は、いるページが変わってもついていかない
app.open_map(nil, nil, { zone_id = 238, zone_name = 'x', map = { kind = 'number', n = 1 } })
fid = 1; app.state.floor_at = nil; frames(2)
fid = 2; app.state.floor_at = nil; frames(2)
eq(app.state.map.here, nil, 'a place map is not 現在地')
eq(app.state.map.map_n, 1, 'a place map does not follow in FloorId zones')
app.close_window('map'); frame()

-- (5) 「現在地」：ゾーンを移ったら、移った先の地図（いる層）。地図の無いゾーンでも落ちない
app.open_map(nil, nil, nil, { here = true })
frames(2)
FAKE.player = { name = 'Tester', zone = 242, tidx = 5, status = 0, x = 0, y = -22.4, z = 0 }
frames(3)
app.state.floor_at = nil
frames(2)
eq(app.state.map.loc.zone_id, 242, 'zoned: the map moved to Heaven\'s Tower')
eq(app.state.map.map_n, 2, 'and the page the player is on')
eq(app.state.map.here, true, 'still 現在地')
FAKE.player = { name = 'Tester', zone = 6, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
FAKE.printed = {}
frames(3)
eq(app.state.map.loc.zone_id, 6, 'zoned into a zone with no map')
eq(app.state.map.map_n, nil, 'no page there')
for _, line in ipairs(FAKE.printed) do check(not tostring(line):find('nil value', 1, true), 'no error without a map') end
FAKE.player = { name = 'Tester', zone = 238, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
fid = 2
frames(3)
app.state.zone_entered_at[238] = -100
app.state.floor_at = nil
frames(2)
eq(app.state.map.loc.zone_id, 238, 'and back to a zone with maps')
eq(app.state.map.map_n, 2, 'on the page the player is on')
-- 出口から別のゾーンを見ると、現在地はやめる（ついていかない）
mv.go(app._ui and app._ui() or { state = app.state, data = D }, { to = 239 })
eq(app.state.map.here, nil, 'browsing through an exit ends 現在地')
app.close_window('map'); frame()
-- クエストの地図は、ゾーンを移っても変わらない
app.open_map(qk, sk)
frames(2)
FAKE.player = { name = 'Tester', zone = 239, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
frames(3)
local L = maps.location_for(D, app._progress and app._progress() or nil, D:quest(qk), sk)
eq(app.state.map.quest, qk, 'quest map keeps its quest after zoning')
eq(app.state.map.loc, nil, 'and its place')
app.close_window('map'); frame()

-- (6) SF の地図でも同じ
local theme = require('src.ui.theme')
S.look = 'sf'; theme.set_look('sf')
FAKE.player = { name = 'Tester', zone = 242, tidx = 5, status = 0, x = 0, y = -22.4, z = 0 }
frames(3)
app.open_map(nil, nil, nil, { here = true })
app.state.floor_at = nil
FAKE.printed = {}
frames(2)
eq(app.state.map.map_n, 2, 'SF: MAP 2')
FAKE.player.z = -22.1; FAKE.player.y = 0
app.state.floor_at = nil
frames(2)
eq(app.state.map.map_n, 3, 'SF: followed to MAP 3')
FAKE.player = { name = 'Tester', zone = 6, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
frames(3)
eq(app.state.map.loc.zone_id, 6, 'SF: zoned into a zone with no map')
FAKE.player = { name = 'Tester', zone = 238, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
fid = 1
frames(3)
app.state.zone_entered_at[238] = -100
app.state.floor_at = nil
frames(2)
eq(app.state.map.loc.zone_id, 238, 'SF: back in Windurst Waters')
eq(app.state.map.map_n, 1, 'SF: on MAP 1')
for _, line in ipairs(FAKE.printed) do check(not tostring(line):find('nil value', 1, true), 'no draw error in SF') end
app.close_window('map'); frame()
S.look = nil; theme.set_look('classic')
P.current_floor_id = old_fid
P.load_texture = old_tex

-- (7) 天の塔の地図：1024 px、水（DAT の面の印 0x2006 の、1 階中央のくぼみ）は青
local png = require('src.core.png')
local fs = posix_fs()
local m3 = png.decode_file(ROOT .. '/assets/maps/z242_2.png', fs)
eq(m3.width, 1024, 'MAP 2 is 1024 px')
local i = (640 * m3.width + 512) * 4 + 1
local r, g2, b = m3.rgba:byte(i, i + 2)
eq(r .. ',' .. g2 .. ',' .. b, '160,204,232', 'the fountain in the middle of MAP 2 (1F) is water')
local m4 = png.decode_file(ROOT .. '/assets/maps/z242_3.png', fs)
r, g2, b = m4.rgba:byte(i, i + 2)
check(not (r == 160 and g2 == 204 and b == 232), 'no water on MAP 3')
local tris = read('dev/sources/heavens_tower_242_tris.json.gz')
if tris then check(#tris > 100000, 'DAT triangles kept for the drawing') end
-- (8) 天の塔は 4 枚（0.1.324〜）：地下・1階・侍女の間・羅星の間（と星の神子の部屋）。タブに名前、高さの境目
local list = maps.floors(D, 242)
eq(#list, 4, 'four pages')
local NAMES = { 'MAP 1 地下', 'MAP 2 1階', 'MAP 3 侍女の間', 'MAP 4 羅星の間' }
local I = require('src.core.i18n').new(posix_fs(), ROOT .. '/locales/')
I:set_language('ja')
local tj = function (k, p) return I:t(k, p) end
for i, f in ipairs(list) do eq(maps.floor_label(tj, f), NAMES[i], 'tab name ' .. i) end
I:set_language('en')
eq(maps.floor_label(tj, list[3]), 'MAP 3 Vestibule', 'English tab name')
eq(maps.floor_label(function (k, p) return k == 'map.floor' and ('MAP ' .. p.n) or k end, maps.floors(D, 238)[1]), 'MAP 1', 'other zones: MAP n')
-- 境目：地下 3.5〜40、1階 -7.5〜3.5、侍女の間 -30.5〜-7.5、羅星の間 -80〜-30.5
local B = { { 3.5, 40 }, { -7.5, 3.5 }, { -30.5, -7.5 }, { -80, -30.5 } }
for i, f in ipairs(list) do eq(f.h_min, B[i][1], 'h_min ' .. i); eq(f.h_max, B[i][2], 'h_max ' .. i) end
-- NPC の高さ（LSB）で裏づけ：Chumimi 地下、Kupipi 1階、Zubaba 侍女の間、Rhy Epocan と Star Sibyl 羅星の間の MAP
local NPC = { { 30.749, 1, 'Chumimi' }, { 0, 2, 'Kupipi' }, { -26.25, 3, 'Zubaba' }, { -47, 4, 'Rhy Epocan' }, { -61.521, 4, 'Star Sibyl' }, { 9.383, 1, 'Karaha-Baruha' } }
for _, c in ipairs(NPC) do eq(maps.map_n_for_height(D, 242, c[1]), c[2], c[3] .. ' page') end
for n = 5, 6 do eq(read('assets/maps/z242_' .. n .. '.png'), nil, 'no old image ' .. n) end
print('test_324 ok')
