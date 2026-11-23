-- 地図の対応表・ピン位置・地図の窓
require('harness')
local json = require('src.lib.json')
local data_mod = require('src.core.data')
local maps = require('src.core.maps')
local map_dat = require('src.core.map_dat')
local settings = require('src.core.settings')
local focus = require('src.ui.focus')

local fs = posix_fs()
local D = data_mod.load(fs, ROOT .. '/data/')
eq(#D.errors, 0, 'data errors: ' .. json.encode(D.errors, true))
eq(D.version, '2026.11.20-125', 'data version')
eq(#D.map_floors, 529, '529 floors with map_n (0.1.324: Heaven Tower is 4 pages)')
eq(#D.map_unconfirmed, 15, '15 unconfirmed zones')

-- 機械固有のパスは資料に入れない
local raw = fs.read(ROOT .. '/data/maps.json')
check(not raw:find('C:\\Games', 1, true) and not raw:find('C:/Games', 1, true), 'no machine path')
check(not raw:lower():find('remapster', 1, true), 'no remapster path')
check(not raw:find('dat_path', 1, true), 'no dat_path field')

-- オルデール MAP 3 = FloorId 14（メニュー照合済み）
local ord = maps.floor(D, 193, 3)
check(ord, 'ordelle map 3')
eq(ord.floor_id, 14, 'ordelle MAP 3 FloorId')
eq(ord.status, 'confirmed', 'ordelle confirmed')
eq(#maps.floors(D, 193), 4, 'ordelle 4 maps')
local o4 = maps.floor(D, 193, 4)
eq(o4.floor_id, 15, 'ordelle MAP 4 FloorId')

-- ツェールン：メニューなし1枚、FloorIndex＝MAP番号の例外（FloorIndex 2、MAP 1）
local zeh = maps.floor(D, 172, 1)
check(zeh, 'zeruhn map 1')
eq(zeh.floor_index, 2, 'zeruhn FloorIndex exception')
eq(zeh.floor_id, 0, 'zeruhn FloorId')
eq(zeh.status, 'confirmed', 'zeruhn confirmed')
eq(#maps.floors(D, 172), 1, 'zeruhn one map')

-- FloorIndex 0 の行は出さない（未確定15ゾーン）
eq(#maps.floors(D, 43), 0, 'Abdhaljs no displayable floors')
check(maps.is_unconfirmed(D, 43), 'Abdhaljs unconfirmed')
local uf, ur = maps.pick_floor(D, { zone_id = 43, zone_name = 'アブダルスの箱庭-ゲルスバ' })
eq(uf, nil, 'unconfirmed has no floor')
eq(ur, 'unconfirmed', 'unconfirmed reason')

-- 南サンドリア E-8：マス目ピンは画像空間、Offset は足さない
local south = maps.floor(D, 230, 1)
check(south, 'south sandoria')
eq(south.scale, 4, 'scale')
eq(south.offset_x, -288, 'offset x')
eq(south.offset_y, -272, 'offset y')
local col, row = maps.parse_grid('E-8')
eq(col, 4, 'col E=4')
eq(row, 8, 'row 8')
local gx, gy = maps.grid_px(col, row)
eq(gx, 160, 'grid img x')
eq(gy, 256, 'grid img y')

-- 世界座標とマス目の対応（設計の検証例）
local wx, wy = maps.world_px(south, -160, 20)
eq(wx, 160, 'world px x')
eq(wy, 256, 'world px y')

local pin = maps.pin(south, { grid = 'E-8' })
eq(pin.kind, 'grid', 'grid pin kind')
eq(pin.base_x, 160, 'grid pin x')
eq(pin.base_y, 256, 'grid pin y')
eq(pin.grid, 'E-8', 'grid pin name')

-- 実座標があるときはそれを優先し、Offset を使う
local pin2 = maps.pin(south, { grid = 'E-8', pos = { x = -160, y = 20 } })
eq(pin2.kind, 'pos', 'pos pin kind')
eq(pin2.base_x, 160, 'pos pin x')
eq(pin2.base_y, 256, 'pos pin y')

-- 1枚だけのエリアは MAP 未確認でもその1枚
local fl, reason = maps.pick_floor(D, { zone_id = 230, grid = 'E-8' })
eq(fl.map_n, 1, 'single map default')
eq(reason, nil, 'single no warning')

-- 複数枚かつ MAP 未確認なら、仮に先頭を出して警告
eq(#maps.floors(D, 238), 2, 'waters 2 maps')
local f2, r2 = maps.pick_floor(D, { zone_id = 238, grid = 'L-6', map = { kind = 'unknown' } })
eq(r2, 'unknown_map', 'multi unknown warns')
eq(f2.map_n, 1, 'tentative first floor')
local f3, r3 = maps.pick_floor(D, { zone_id = 238, map = { kind = 'number', n = 2 } })
eq(f3.map_n, 2, 'known map number used')
eq(r3, nil, 'known no warning')
local f4, r4 = maps.pick_floor(D, { zone_id = 238 }, 2)
eq(f4.map_n, 2, 'user chosen floor')
eq(r4, 'unknown_map', 'still warns after choosing when source is unknown')

-- 開始場所
local q = D:quest('quest.sandoria.001')
local locq = maps.location_for(D, nil, q)
check(locq and locq.zone_id == 230 and locq.grid == 'E-8', 'quest start loc')

-- 手順を指定したときはその場所
local s2 = D:step('quest.bastok.003#g02')
local locs, st = maps.location_for(D, nil, D:quest('quest.bastok.003'), 'quest.bastok.003#g02')
check(locs and locs.zone_id == 191, 'step location')
eq(st.id, 'quest.bastok.003#g02', 'step returned')
check(s2.location.map and s2.location.map.kind == 'number', 'dungle map known')
local fd, rd = maps.pick_floor(D, locs)
eq(rd, nil, 'known dungeon map')
eq(fd.map_n, 1, 'dungle map 1')

-- 形式が分からないものは nil（推測で画像を作らない）
local dec, dwhy = map_dat.decode('xxxxxxxxxxxxxxxx')
eq(dec, nil, 'unknown format returns nil')
eq(dwhy, 'unknown_format', 'unknown format reason')
eq(map_dat.decode('short'), nil, 'too short')

local function le16(n)
    n = n % 65536
    return string.char(n % 256, math.floor(n / 256))
end
local function le32(n)
    if n < 0 then n = n + 4294967296 end
    local a = n % 256; n = math.floor(n / 256)
    local b = n % 256; n = math.floor(n / 256)
    local c = n % 256; n = math.floor(n / 256)
    return string.char(a, b, c, n % 256)
end

-- 8×8 の 8bit 地図（左上赤、左下緑）
local function make_pal8()
    local w, h = 8, 8
    local hdr = string.char(0xB1) .. 'menumap ' .. 'test_001' .. le32(40)
        .. le32(w) .. le32(h) .. le16(1) .. le16(8)
        .. le32(0) .. le32(0) .. le32(0) .. le32(0) .. le32(0) .. le32(32)
        .. le32(10)
    local pal = {}
    pal[1] = string.char(0, 0, 255, 0x80)     -- 0: 赤 BGRA
    pal[2] = string.char(0, 255, 0, 0x80)     -- 1: 緑
    pal[3] = string.char(0, 0, 0, 0x80)       -- 2: 黒
    for i = 3, 255 do pal[i + 1] = pal[3] end
    local pix = {}
    for y = h - 1, 0, -1 do
        for x = 0, w - 1 do
            local idx = 2
            if x == 0 and y == 0 then idx = 0
            elseif x == 0 and y == h - 1 then idx = 1 end
            pix[#pix + 1] = string.char(idx)
        end
    end
    return hdr .. table.concat(pal) .. table.concat(pix)
end
local img = map_dat.decode(make_pal8())
check(img and img.width == 8 and img.height == 8, 'pal8 size')
eq(img.format, 'pal8', 'pal8 format')
eq(#img.rgba, 8 * 8 * 4, 'pal8 rgba len')
local function pix(im, x, y)
    local o = (y * im.width + x) * 4 + 1
    return im.rgba:byte(o), im.rgba:byte(o + 1), im.rgba:byte(o + 2), im.rgba:byte(o + 3)
end
local r, g, b, a = pix(img, 0, 0)
check(r == 255 and g == 0 and b == 0 and a == 255, 'pal8 top-left red: ' .. tostring(r) .. ',' .. tostring(g))
r, g, b, a = pix(img, 0, 7)
check(r == 0 and g == 255 and b == 0 and a == 255, 'pal8 bottom-left green')

-- 4×4 の DXT3（不透明な青一色）
local function make_dxt3()
    local w, h = 4, 4
    local hdr = string.char(0xA1) .. 'menumap ' .. 'test_dxt' .. le32(40)
        .. le32(w) .. le32(h) .. le16(1) .. le16(8)
        .. le32(0) .. le32(0) .. le32(0) .. le32(0) .. le32(0) .. le32(32)
        .. '3TXD' .. string.char(0, 0, 0, 0, 0, 0, 0, 0)
    local alpha = string.char(0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF)
    local color = le16(0x001F) .. le16(0x001F) .. le32(0)
    return hdr .. alpha .. color
end
local dimg = map_dat.decode(make_dxt3())
check(dimg and dimg.width == 4 and dimg.height == 4, 'dxt3 size')
eq(dimg.format, 'dxt3', 'dxt3 format')
r, g, b, a = pix(dimg, 0, 0)
check(r == 0 and g == 0 and b == 255 and a == 255, 'dxt3 blue: ' .. tostring(r) .. ',' .. tostring(g) .. ',' .. tostring(b) .. ',' .. tostring(a))
r, g, b, a = pix(dimg, 3, 3)
check(b == 255 and a == 255, 'dxt3 corner blue')

-- 現在地ピン（南サンドリア、E-8 と同じ座標）。水平面は x と y（z は高さで使わない）
local me = maps.player_pin(south, { zone_id = 230, x = -160, y = 20, z = 999 }, { zone_id = 230 })
check(me and me.kind == 'player' and not me.off, 'player pin in zone')
eq(me.base_x, 160, 'player x is E-8')
eq(me.base_y, 256, 'player y is E-8')
eq(me.grid, 'E-8', 'player grid name')
eq(maps.player_pin(south, { zone_id = 231, x = -160, y = 20 }, { zone_id = 230 }), nil, 'other zone no pin')
eq(maps.player_pin(south, { zone_id = 230 }, { zone_id = 230 }), nil, 'no coords no pin')
eq(maps.player_pin(south, { zone_id = 230, x = -160, z = 20 }, { zone_id = 230 }), nil, 'height z is not the map axis')
eq(maps.grid_name(160, 256), 'E-8', 'grid_name E-8')
eq(maps.grid_name(160, 288), 'E-9', 'grid_name E-9')

-- 商業区 E-9。高さを水平に使うと E-7 付近に寄る（実機で見えたずれ）
local markets = maps.floor(D, 235, 1)
check(markets, 'bastok markets')
eq(markets.scale, 4, 'markets scale')
eq(markets.offset_x, -424, 'markets ox')
eq(markets.offset_y, -208, 'markets oy')
local mx, my = maps.world_px(markets, -330, -100)
eq(mx, 160, 'markets E-9 x')
eq(my, 288, 'markets E-9 y')
local me9 = maps.player_pin(markets, { zone_id = 235, x = -330, y = -100, z = 0 }, { zone_id = 235 })
check(me9 and not me9.off, 'markets player on map')
eq(me9.base_y, 288, 'markets uses horizontal Y')
eq(me9.grid, 'E-9', 'markets grid E-9')
local _, zy = maps.world_px(markets, -330, 0)
-- 高さ 0 を水平にすると y=208 で、E-7 付近になる
eq(zy, 208, 'height 0 sits near E-7 (the old bug)')

-- 目的地は該当の MAP だけ
local dang1 = maps.floor(D, 191, 1)
local dang2 = maps.floor(D, 191, 2)
local dloc = { zone_id = 191, grid = 'J-5', map = { kind = 'number', n = 1 } }
check(maps.dest_on_floor(dang1, dloc, 2), 'dest on its MAP')
check(not maps.dest_on_floor(dang2, dloc, 2), 'dest hidden on other MAP')
local h1 = maps.floor(D, 192, 1)
local hloc = { zone_id = 192, grid = 'H-9', map = { kind = 'unknown' } }
check(not maps.dest_on_floor(h1, hloc, 4), 'unknown MAP not shown on every floor')
check(maps.dest_on_floor(south, { zone_id = 230, grid = 'E-8', map = { kind = 'unknown' } }, 1),
    'unknown MAP ok when the zone has only one')
eq(maps.wanted_map(dloc), 1, 'wanted_map')
eq(maps.wanted_map(hloc), nil, 'wanted_map unknown')

-- 古い保存の地図オフは、初めて出す版ではオン。利用者がオフにしたらそのまま。
eq(settings.defaults().map.enabled, true, 'default map on')
local old = settings.merge({ settings_schema = 1, map = { enabled = false } })
eq(old.map.enabled, true, 'old reserved off becomes on')
eq(old.map.introduced, 1, 'introduced set')
local user_off = settings.merge({ settings_schema = 1, map = { enabled = false, introduced = 1 } })
eq(user_off.map.enabled, false, 'user off is kept')

-- 選択枠は本と設定と、地図（0.1.60〜、「相手：」をパッドで選ぶため）
check(focus.shows_frame('book') and focus.shows_frame('settings'), 'frames on book and settings')
check(focus.shows_frame('map'), 'frame on map')
check(not focus.shows_frame('tracker') and not focus.shows_frame('detail'), 'no frame on tracker/detail')

-- 窓
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local window = require('src.ui.window')
check(window.DEFAULTS.map and window.DEFAULTS.map.w >= 500, 'map window default')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(app._settings().map.enabled, true, 'settings map on after login')

-- 詳細の発生NPCの名前から地図を開く（「地図で見る」ボタンは出さない）
FAKE.table = true
cmd('/astertrail'); frame()
app._settings().book.tab = 'quest'; frame(); frame()
FAKE.clicks['##row_quest.sandoria.001'] = true; frame(); frame()
check(not labeled('地図で見る'), 'no map button on detail')
check(labeled('Parvipon'), 'npc name is a link')
FAKE.clicks['Parvipon'] = true; frame(); frame()
check(app.state.open.map, 'map opens from npc name')
check(drawn('南サンドリア') or texted('南サンドリア'), 'zone name on map')
check(not texted('SQUARE ENIX') and not texted('© SQUARE'), 'no Square Enix credit')
check(not texted('同梱せず'), 'no credit note on map')
-- 0.1.218〜：Parvipon は正確な座標があるので、マス目の中央の注は出ない（マス目だけの場所の注は test_exact_pos_218）
check(not texted('マス目の中央。正確な位置ではありません。'), 'exact pin: no grid note')
-- この時点では座標が無いので現在地の凡例は出ない（目的地は出る）
check(not texted('◆＝現在地') and not texted('現在地は MAP'), 'no player legend without coords')
check(texted('目的地'), 'dest legend without player')
-- 選択枠あり（0.1.60〜）
check(focus.shows_frame('map'), 'frame on map now')

-- 閉じても本は残る（偽環境では「閉じる」が本のボタンにも当たるので、API で閉じる）
check(app.state.open.book, 'book is open with map')
app.close_window('map')
frame()
check(not app.state.open.map, 'map closed')
check(app.state.open.book, 'book still open')

-- ウィンダス水の区（2枚）。耳の院（北部）は MAP 1
local WQ = 'quest.windurst.003'
app.open_map(WQ)
frame(); frame()
check(app.state.open.map, 'waters map open')
check(texted('ウィンダス水の区'), 'waters zone')
check(not texted('MAP番号が未確認です'), 'waters MAP is known')
check(labeled('MAP 1') and labeled('MAP 2'), 'floor buttons')
check(labeled('◆ ') and labeled('◇ '), 'side-by-side marks')
eq(app.state.map.map_n, 1, 'starts on dest MAP')
check(texted('○＝目的地'), 'dest on Waters MAP 1')
-- 階層を選ぶ
FAKE.clicks['MAP 2'] = true; frame(); frame()
eq(app.state.map.map_n, 2, 'chose MAP 2')
check(not texted('○＝目的地'), 'no dest on Waters MAP 2')
check(texted('MAP 1 にあります'), 'points to MAP 1')
check(labeled('◆ ') and labeled('◇ '), 'buttons still side-by-side')
FAKE.clicks['MAP 1'] = true; frame(); frame()
check(texted('○＝目的地'), 'dest returns on Waters MAP 1')
app.close_window('map'); frame()

-- ダングルフ MAP 1 の目的地は、MAP 2 には出さない
app.open_map('quest.bastok.003', 'quest.bastok.003#g02')
frame(); frame()
check(app.state.open.map, 'dangruf map open')
check(texted('ダングルフ'), 'dangruf zone')
eq(app.state.map.map_n, 1, 'starts on dest MAP')
check(texted('○＝目的地'), 'dest on MAP 1')
FAKE.clicks['MAP 2'] = true; frame(); frame()
eq(app.state.map.map_n, 2, 'switched to MAP 2')
check(not texted('○＝目的地'), 'no dest on MAP 2')
check(texted('MAP 1 にあります'), 'tells which MAP')
FAKE.clicks['MAP 1'] = true; frame(); frame()
eq(app.state.map.map_n, 1, 'back to MAP 1')
check(texted('○＝目的地'), 'dest returns on MAP 1')
app.close_window('map'); frame()

-- 内ホルトト Gate: Magical Gizmo は MAP 1
app.open_map('mission.windurst.001', 'mission.windurst.001#g04')
frame(); frame()
check(app.state.open.map, 'horutoto map open')
check(texted('内ホルトト遺跡'), 'horutoto zone')
eq(app.state.map.map_n, 1, 'starts on MAP 1')
check(texted('○＝目的地（I-9）'), 'gizmo dest on MAP 1 at I-9')
check(not texted('MAP番号が未確認です'), 'gizmo MAP is known')
FAKE.clicks['MAP 2'] = true; frame(); frame()
eq(app.state.map.map_n, 2, 'horutoto MAP 2')
check(not texted('○＝目的地'), 'no gizmo dest on MAP 2')
check(texted('MAP 1 にあります'), 'gizmo points to MAP 1')
FAKE.clicks['MAP 1'] = true; frame(); frame()
check(texted('○＝目的地（I-9）'), 'gizmo dest returns on MAP 1 at I-9')
app.close_window('map'); frame()

-- Ancient Magical Gizmo は同じ MAP 1。座標は複数あるのでピンは出さない
app.open_map('mission.windurst.001', 'mission.windurst.001#g05')
frame(); frame()
eq(app.state.map.map_n, 1, 'ancient starts on MAP 1')
check(not texted('○＝目的地'), 'no pin without coords')
check(texted('マス目や座標は資料にない') or texted('ピンは出していません'), 'no-pin message on MAP 1')
FAKE.clicks['MAP 2'] = true; frame(); frame()
check(texted('MAP 1 にあります'), 'ancient points to MAP 1')
app.close_window('map'); frame()

-- 未確定ゾーンは文章（別の地図で代用しない）
app.open_map(nil, nil, { zone_id = 86, zone_name = '常花の石窟' })
frame(); frame()
check(texted('まだ確定していません') or texted('別の地図では代用しません'), 'unconfirmed message')
check(not labeled('MAP 1'), 'no floor buttons for unconfirmed')
app.close_window('map'); frame()

-- コマンド
app.open_window('book')
-- last_row を南サンドリアのクエストに
app.open_map('quest.sandoria.001')
frame()
check(app.state.open.map, 'open_map api')
app.close_window('map')
cmd('/astertrail map'); frame(); frame()
check(app.state.open.map, 'command opens map')
check(not texted('SQUARE ENIX'), 'no credit via command')

-- 設定でオフにするとコマンドは案内だけ
app._settings().map.enabled = false
app.close_window('map')
FAKE.printed = {}
cmd('/astertrail map'); frame()
check(not app.state.open.map, 'disabled does not open')
check(printed('設定で地図がオフ'), 'disabled message')
-- 戻す
app._settings().map.enabled = true

-- 設定画面にトグルがある
cmd('/astertrail settings'); frame()
require('src.ui.settings_ui').select_tab('map'); frame(); frame()
check(labeled('地図を出す'), 'settings toggle')
-- 0.1.304〜：地図の画像の説明は「地図を出す」の i
check(io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a'):find('sf.set.map_credit', 1, true) ~= nil, 'settings credit note (i)')

-- 同じゾーンに座標があれば「いまここ」
FAKE.player.x = -160
FAKE.player.y = 20
FAKE.player.z = 0
FAKE.player.zone = 230
app.open_map('quest.sandoria.001')
frame(); frame()
check(app.state.open.map, 'map open for player pin')
check(texted('◆＝現在地（E-8）'), 'player legend with grid')
check(texted('○＝目的地'), 'dest legend')
check(not texted('いまここ'), 'no you-are-here on or under the map')
-- 別ゾーンなら現在地は出さない（目的地は残る）
FAKE.player.zone = 231
frame(); frame()
check(not texted('◆＝現在地') and not texted('現在地は MAP'), 'hidden in other zone')
check(not texted('範囲の外'), 'not off-map either')
check(texted('目的地'), 'dest remains in other zone')
FAKE.player.zone = 230
app.close_window('map'); frame()

-- テクスチャが渡れば、方眼の案内は出さずに画像を出す
app.load_map_image = function (id)
    return { tex = 'tex:' .. tostring(id), width = 512, height = 512 }
end
FAKE.calls.Image = 0
app.open_map('quest.sandoria.001')
frame(); frame()
check(app.state.open.map, 'map open with image')
check((FAKE.calls.Image or 0) >= 1, 'image drawn')
check(not texted('読み取れませんでした') and not texted('まだ表示できません'), 'no missing-image note')
check(texted('現在地（E-8）'), 'player legend with image')
check(not texted('いまここ'), 'no you-are-here with image')
app.close_window('map'); frame()

-- マウスホイールの拡大：1〜4倍、マウスの下の点は動かない、はみ出さない
do
    local mv = require('src.ui.map_view')
    local v = { z = 1, ox = 0, oy = 0 }
    check(mv.zoom_at(v, 1, 0.5, 0.5), 'zoom in')
    check(math.abs(v.z - 1.25) < 1e-9, 'zoom 1.25')
    check(math.abs((v.ox + 0.5 / v.z) - 0.5) < 1e-9, 'center stays')
    for _ = 1, 20 do mv.zoom_at(v, 1, 0, 0) end
    eq(v.z, 4, 'max 4')
    check(v.ox >= 0 and v.ox <= 0.75 and v.oy >= 0 and v.oy <= 0.75, 'in range')
    check(not mv.zoom_at(v, 1, 0, 0), 'no more zoom')
    for _ = 1, 20 do mv.zoom_at(v, -1, 1, 1) end
    eq(v.z, 1, 'back to 1')
    eq(v.ox, 0, 'ox 0 at 1x'); eq(v.oy, 0, 'oy 0 at 1x')
    local c = { z = 2, ox = 0.9, oy = -0.2 }
    mv.clamp_view(c)
    eq(c.ox, 0.5, 'clamp ox'); eq(c.oy, 0, 'clamp oy')
end

-- 地図の上でホイール：GetIO が userdata でも読めること（実機の形）
do
    local mv = require('src.ui.map_view')
    local imgui = require('imgui')
    local saved = {}
    for _, k in ipairs({ 'GetIO', 'IsItemHovered', 'IsItemActive', 'GetMousePos', 'GetItemRectMin', 'GetItemRectMax', 'Image' }) do saved[k] = imgui[k] end
    local io = newproxy and newproxy(true) or nil
    if io then
        getmetatable(io).__index = function (_, k)
            if k == 'MouseWheel' then return 1 end
            if k == 'MouseDelta' then return { x = 0, y = 0 } end
            if k == 'DisplaySize' then return { x = 1920, y = 1080 } end
        end
        imgui.GetIO = function () return io end
        imgui.IsItemHovered = function () return true end
        imgui.GetMousePos = function () return 300, 300 end
        imgui.GetItemRectMin = function () return 100, 100 end
        imgui.GetItemRectMax = function () return 500, 500 end
        imgui.Image = function () end
        local view = { z = 1, ox = 0, oy = 0 }
        mv._draw_image_for_test(imgui, 1, 512, 512, 400, nil, nil, view)
        check(view.z > 1, 'wheel zooms with userdata io')
    end
    for k, v in pairs(saved) do imgui[k] = v end
end

-- 地図のピン：見えた相手の本当の座標を覚える（同じゾーンだけ）
do
    local mu = require('src.ui.marks')
    local ui = { state = {} }
    mu.remember_positions(ui, 191, { { entity = { x = 10, y = -20, z = 3 }, wanted = { { target_id = 'obj.191.???' } } } })
    local p = mu.live_position(ui, 191, 'obj.191.???')
    check(p and p.x == 10 and p.y == -20, 'live pos kept')
    eq(mu.live_position(ui, 230, 'obj.191.???'), nil, 'other zone none')
    eq(mu.live_position(ui, 191, 'npc.x'), nil, 'unknown target none')
    mu.remember_positions(ui, 230, {})
    eq(mu.live_position(ui, 191, 'obj.191.???'), nil, 'cleared on zone change')
end
