-- 0.1.323：天の塔（242）の地図。ゲームの地図が無いので、ゾーン DAT から描いた画像を同梱し、層は高さで決める。
-- 同梱の PNG を読む・高さ→層・出口・scale 20 の位置・いる層に地図を合わせる（0.1.324 で地図は 1024 px、層のつながりの印は外した）
require('fake_env')
_G.vana = _G.vana or {}
vana.world = vana.world or { marks = function () end }
vana.graphics = vana.graphics or { info = function () return { active = true } end }
vana.game = vana.game or { entity = function () return nil end }
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local maps = require('src.core.maps')
local exits = require('src.core.exits')
local mv = require('src.ui.map_view')
local png = require('src.core.png')
local json = require('src.lib.json')
eq(app.VERSION, '1.1.324', 'version')
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')
FAKE.player = { name = 'Tester', zone = 100, tidx = 5, status = 0, x = -100, y = 200, z = -60 }
frames(3)
local D = app._data()

-- (1) PNG：フィルタ 0〜4 を行ごとに使った小さな絵（RGBA・RGB・4 ビットのパレット+tRNS）
local function unhex(h) return (h:gsub('..', function (c) return string.char(tonumber(c, 16)) end)) end
local FX = {
    rgba = { '89504e470d0a1a0a0000000d49484452000000070000000608060000000f0e84760000005c4944415478da01ae0051ff0082b70eee7f1a5039bef07ec2347f066ed08f5dc7512447e340430002016b6e545529321113c9c45f30ae5410bc3fcf4d55507a8c7804b4efd50236f0a29cc67d1ea35a6a453eb0083093cdd54393e3eb0394e23760fc08b80000005d494441549bc60347e362b6f297092f1ecfce0feef64165f0229820b464fc8d2d26fd830440383fe265fd4e14474607b79bebf2f635d851967fbfb1ba7ca4c60700ce4b39c15bffad5c2dfb8bb820b6119cba8ff88796ae5b05f280a68cbfb7532d9ed322d40000000049454e44ae426082',
      '82b70eee7f1a5039bef07ec2347f066ed08f5dc7512447e3404300026b6e545594a065685d64c4980bb8d4544a8721a99a01ad219eb59cf6a15ef6f15a1d830bb7ce09d6bbc004e7175c643c7decb0b580ec37bc9712dd2e6aaeb94bae8d2f9fa29c5a284c9ef7521829cf1079b080e9d74a1c10fcab6a4243d33656debe4c1ed79648e856e8f9a2f58c95f0ce4b39c15bffad5c2dfb8bb820b6119cba8ff88796ae5b05f280a68c' },
    rgb = { '89504e470d0a1a0a0000000d4948445200000007000000060802000000806c1321000000474944415478da0184007bff0082b70e7f1a50bef07e347f06d08f5d512447404300016b6e54293211c9c45fae54103fcf4d507a8c04b4ef0236f0a2c67d1e5a6a45b00830cdd543e3eb03e2f575ab290000004849444154379b0347e362f297091ecfceeef641f02298b464fc2d26fd0440383f65fd4e4746079bebf235d8517fbfb17ca4c600ce4b395bffad2dfb8b20b611ba8ff896ae5bf280a6d5f43e2bb8d1dc930000000049454e44ae426082',
      '82b70eff7f1a50ffbef07eff347f06ffd08f5dff512447ff404300ff6b6e54ff94a065ff5d64c4ff0bb8d4ff4a8721ff9a01adff9eb59cffa15ef6ff5a1d83ffb7ce09ffbbc004ff175c64ff7decb0ff80ec37ff9712ddff6aaeb9ffae8d2fffa29c5aff4c9ef7ff1829cfff79b080ffd74a1cfffcab6aff43d336ffdebe4cffd79648ff56e8f9fff58c95ffce4b39ff5bffadff2dfb8bff20b611ffba8ff8ff96ae5bfff280a6ff' },
    pal4 = { '89504e470d0a1a0a0000000d4948445200000007000000060403000000fd2099450000000f504c54450a141ec86432010203fafafa0080ffee3c60f20000000274524e5300809b2b4e18000000134944415478da633072525260347ac82fc7f4e81fe303e62f42cd1800000014494441549f5c9aff5814e5f6f233383b0a320000864b088cdcaf5af70000000049454e44ae426082',
      'fafafaff010203ff0080ffff010203ff010203ff010203ff010203fffafafaff010203ffc8643280fafafaff010203ff010203ff0080ffffc86432800080ffffc8643280c8643280010203fffafafaff010203ff0a141e00fafafaffc86432800080ffff0080ffff0080fffffafafaff010203ff0080ffff0080ffff010203ff0a141e00c8643280c86432800080fffffafafaff0080ffffc8643280c8643280c86432800a141e00' },
}
for name, v in pairs(FX) do
    local img, why = png.decode(unhex(v[1]))
    check(img ~= nil, 'decodes ' .. name .. ' ' .. tostring(why))
    eq(img.width, 7, name .. ' width'); eq(img.height, 6, name .. ' height')
    check(img.rgba == unhex(v[2]), name .. ' pixels')
end
eq(select(2, png.decode('nope')), 'not_png', 'not a PNG')
local fs = posix_fs()
local function px(img, x, y)
    local i = (y * img.width + x) * 4 + 1
    return { img.rgba:byte(i, i + 3) }
end
for n = 1, 4 do
    local img = png.decode_file(ROOT .. '/assets/maps/z242_' .. n .. '.png', fs)
    check(img ~= nil, 'bundled map ' .. n .. ' decodes')
    eq(img.width, 1024, 'map ' .. n .. ' is 1024 wide'); eq(img.height, 1024, 'map ' .. n .. ' is 1024 high')
    local c = px(img, 10, 10)
    eq(c[1] .. ',' .. c[2] .. ',' .. c[3], '222,196,150', 'map ' .. n .. ' frame band colour')
end
local m3 = png.decode_file(ROOT .. '/assets/maps/z242_2.png', fs)   -- 0.1.324〜：入口は MAP 2（4 枚）
local c = px(m3, 512, 820)
check(c[1] >= 225 and c[3] >= 180 and not (c[1] == 236 and c[2] == 216), 'MAP 2: floor under the entrance (' .. c[1] .. ',' .. c[2] .. ',' .. c[3] .. ')')
c = px(m3, 200, 200)
eq(c[1] .. ',' .. c[2] .. ',' .. c[3], '236,216,178', 'MAP 2: ground off the tower')

-- (2) 地図の表：4 枚（0.1.324〜。前は 6 層）、高さの範囲、同梱の画像
local list = maps.floors(D, 242)
eq(#list, 4, 'four pages')
check(maps.by_height(D, 242), 'Heaven\'s Tower is split by height')
check(not maps.by_height(D, 238), 'other zones use FloorId')
check(not maps.by_height(D, 9999), 'unknown zone')
check(not maps.is_unconfirmed(D, 242), 'no longer unconfirmed')
for i, f in ipairs(list) do
    eq(f.map_n, i, 'MAP ' .. i)
    eq(f.scale, 20, 'scale 20')
    eq(maps.image_key(f), 'assets/maps/z242_' .. i .. '.png', 'bundled image ' .. i)
    check(f.h_min < f.h_max, 'height range ' .. i)
    if i > 1 then eq(list[i - 1].h_min, f.h_max, 'layers touch ' .. i) end
end
local f238 = maps.floors(D, 238)[1]
eq(maps.image_key(f238), f238.file_id, 'game maps still use the map DAT')
eq(maps.image_key(nil), nil, 'no floor')

-- 高さ（+ が下）→ ページ。入口・出口の床（0）は MAP 2（0.1.324〜）
local H = { [30.8] = 1, [10.1] = 1, [0] = 2, [-22.1] = 3, [-43.8] = 4, [-60.5] = 4, [20.5] = 1, [3.5] = 1, [-7.5] = 2, [-30.5] = 3, [-30.6] = 4 }
for h, n in pairs(H) do eq(maps.map_n_for_height(D, 242, h), n, 'height ' .. h) end
eq(maps.map_n_for_height(D, 242, 60), nil, 'below the tower')
eq(maps.map_n_for_height(D, 242, -120), nil, 'above the tower')
eq(maps.map_n_for_height(D, 242, nil), nil, 'no height')
eq(maps.map_n_for_height(D, 238, 0), nil, 'not for FloorId zones')
eq(maps.map_n_for_floor(D, 242, 0), nil, 'FloorId 0 does not pick a layer here')
eq(maps.map_n_for_floor(D, 238, 2), 2, 'FloorId zones unchanged')

-- (3) scale 20：ゲームの地図と同じ式。マスは A〜O × 1〜15（32 px、縁 16 px）
local f3 = maps.floor(D, 242, 2)
local x, y = maps.world_px(f3, 0, -22.4)
check(math.abs(x - 256) < 1e-6 and math.abs(y - 409.6) < 1e-6, 'arrival spot in pixels')
x, y = maps.world_px(f3, 64, 80)
check(math.abs(x - 512) < 1e-6 and math.abs(y - 0) < 1e-6, 'edge of the drawing')
eq(maps.grid_name(256, 409.6), 'H-13', 'grid cell of the entrance')
local lay = maps.grid_layout(f3)
eq(#lay.col_ids, 15, '15 columns'); eq(#lay.row_ids, 15, '15 rows')
local me = maps.player_pin(f3, { zone_id = 242, x = 0, y = -22.4 }, { zone_id = 242 })
check(me and math.abs(me.x - 256) < 1e-6 and math.abs(me.y - 409.6) < 1e-6, 'player pin at scale 20')
local qp = maps.pin(f3, { zone_id = 242, pos = { x = 0, y = -22.4 } }, maps.BASE)
check(qp == nil or (math.abs(qp.x - 256) < 1e-6 and math.abs(qp.y - 409.6) < 1e-6), 'quest pin at scale 20')

-- (4) 出口：ウィンダス側（239）へ。高さで MAP 2（0.1.324〜）。高さが無ければ決めない（推測しない）
local ex = exits.of(D, 242)
eq(#ex, 1, 'one exit')
eq(ex[1].to, 239, 'to Windurst Walls')
eq(exits.map_n_of(D, maps, {}, 242, ex[1].x, ex[1].y, nil, ex[1].z), 2, 'exit on MAP 2')
eq(exits.map_n_of(D, maps, {}, 242, ex[1].x, ex[1].y, nil, nil), nil, 'no height: not placed')
eq(exits.map_n_of(D, maps, { ['242'] = { [exits.key(ex[1].x, ex[1].y)] = 5 } }, 242, ex[1].x, ex[1].y, nil, ex[1].z), 2,
    'height wins over old learned values')
local arr = exits.arrivals(D, 242)
check(#arr >= 1, 'arrival from 239')
for _, a in ipairs(arr) do
    eq(exits.map_n_of(D, maps, {}, 242, a.at.x, a.at.y, nil, a.at.z), 2, 'arrival on MAP 2')
end
eq(exits.unlearned(D, maps, {}, 242), 0, 'nothing to learn from FloorId')
eq(exits.learn(D, maps, {}, 242, function () return 0 end), 0, 'learn skips height zones')

-- (5) 層どうしのつながりの印は 0.1.324 で外した
check(not pcall(require, 'src.core.floor_links'), 'no floor links module')

-- (6) 実際に：天の塔にいると、高さで層が決まり、地図がいる層に合う。降りると次の層に切りかわる
local P = require('src.platform.ashita')
local tex_calls = 0
local old_tex = P.load_texture
P.load_texture = function (img) tex_calls = tex_calls + 1; return { _tex = true, w = img.width, h = img.height } end
install_backslash_io()
local img, why = app.load_map_image('assets/maps/z242_2.png')
check(img and img.tex and img.width == 1024, 'bundled image becomes a texture ' .. tostring(why))
check(app.load_map_image('assets/maps/z242_2.png') == img, 'cached')
eq(tex_calls, 1, 'decoded once')
eq(select(2, app.load_map_image('assets/../settings.png')), 'bad_path', 'only assets/maps')

local S = app._settings()
S.map = S.map or {}
S.map.enabled = true
FAKE.player = { name = 'Tester', zone = 242, tidx = 5, status = 0, x = 0, y = -22.4, z = 0 }
frames(3)
app.open_map(nil, nil, nil, { here = true })
app.state.floor_at = nil
frame(); frame()
local fl_now = app.poll_floor(true)
eq(fl_now.map_n, 2, 'standing at the entrance: MAP 2')
eq(fl_now.why, 'height', 'decided by height')
frame(); frame()
eq(app.state.map.map_n, 2, 'map shows MAP 2')
FAKE.player.z = -22.1; FAKE.player.y = 0
app.state.floor_at = nil
frame(); frame(); frame()
eq(app.state.floor.map_n, 3, 'went up: MAP 3')
eq(app.state.map.map_n, 3, 'the map followed')
-- 自分でほかの層を見ているときは、そのまま
app.state.map.map_n = 1
frame(); frame()
eq(app.state.map.map_n, 1, 'picked by hand: kept')
FAKE.player.z = -43.8
app.state.floor_at = nil
frame(); frame()
eq(app.state.floor.map_n, 4, 'MAP 4 now')
eq(app.state.map.map_n, 1, 'still the page picked by hand')
FAKE.player.z = 80
app.state.floor_at = nil
frame(); frame()
eq(app.state.floor.map_n, nil, 'outside every band: unknown')
eq(app.state.floor.why, 'out_of_height', 'and says why')
app.close_window('map'); frame()
P.load_texture = old_tex

-- (7) SF 地図でも落ちない
local theme = require('src.ui.theme')
S.look = 'sf'; theme.set_look('sf')
FAKE.player.z = 0
app.open_map(nil, nil, nil, { here = true })
app.state.floor_at = nil
FAKE.printed = {}
frame(); frame(); frame()
for _, line in ipairs(FAKE.printed) do
    check(not tostring(line):find('nil value', 1, true), 'no draw error in SF')
end
eq(app.state.map.map_n, 2, 'SF map on MAP 2')
app.close_window('map'); frame()

-- (8) 作るためのスクリプトとデータは dev/ にある（ゲームには不要）
check(io.open(ROOT .. '/dev/build_dat_maps.py', 'r') ~= nil, 'dev/build_dat_maps.py')
-- dev/sources は公開のリポジトリに入れていないので、あるときだけ確かめる
local sf = io.open(ROOT .. '/dev/sources/heavens_tower_242.json', 'r')
if sf then
    local src = json.decode(sf:read('*a')); sf:close()
    eq(#src.layers, 6, 'source has six DAT height bands')
    eq(#src.pages, 4, 'drawn as four pages')
end
print('test_323 ok')
