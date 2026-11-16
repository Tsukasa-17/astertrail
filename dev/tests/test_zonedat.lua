-- 0.1.176（t266）：ゾーンの DAT（MZB の当たり判定）から階を出す。作った小さな DAT で確かめる（ゲームのデータは使わない）
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local P = require('src.platform.ashita')
local zd = require('src.core.zonedat')
local exits = require('src.core.exits')
local maps = require('src.core.maps')

eq(zd.file_id(238), 338, 'zone < 256: +100')
eq(zd.file_id(259), 259 + 83635, 'zone >= 256: +83635')
eq(zd._f32(0x3F800000), 1, 'f32 1.0')
eq(zd._f32(0xC0400000), -3, 'f32 -3.0')
eq(zd._f32(0), 0, 'f32 0')

-- 小さな MZB を作る
local function bytes_of(n) local t = {}; for i = 1, n do t[i] = 0 end; return t end
local function put_u32(t, o, v)
    for i = 0, 3 do t[o + i + 1] = v % 256; v = math.floor(v / 256) end
end
local function put_u16(t, o, v) t[o + 1] = v % 256; t[o + 2] = math.floor(v / 256) % 256 end
local function put_f32(t, o, f)
    local v = 0
    if f ~= 0 then
        local sign = f < 0 and 0x80000000 or 0
        f = math.abs(f)
        local m, e = math.frexp(f)        -- f = m * 2^e, 0.5 <= m < 1
        v = sign + (e + 126) * 0x800000 + math.floor((m * 2 - 1) * 0x800000 + 0.5)
    end
    put_u32(t, o, v)
end
local function matrix(t, o, ty)
    local m = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, ty, 0, 1 }
    for i = 1, 16 do put_f32(t, o + (i - 1) * 4, m[i]) end
end

local SIZE = 0x1000
local function build(encode)
    local t = bytes_of(SIZE)
    t[0x0c + 1], t[0x0d + 1], t[0x0e + 1], t[0x0f + 1] = 2, 2, 40, 40   -- 20×20 区画、原点 40
    put_u32(t, 0x08, 0x40)                 -- mesh
    local G = 0x80
    put_u32(t, 0x40 + 0x10, G)             -- grid（20×20×4 = 1600 バイト）
    local E = 0x700                        -- 区画の中身
    for cy = 9, 11 do for cx = 9, 11 do put_u32(t, G + (cy * 20 + cx) * 4, E) end end
    local A1, A2, GEO = 0x800, 0x8C0, 0x980
    put_u32(t, E, 2)                       -- head（2 組）
    put_u32(t, E + 4, A1); put_u32(t, E + 8, GEO)
    put_u32(t, E + 12, A2); put_u32(t, E + 16, GEO)
    put_u32(t, E + 20, 0)
    -- 置き場所 1：y=2 の床、FloorId 3。置き場所 2：y=5 の床（移動で）、FloorId 9
    matrix(t, A1, 2); matrix(t, A1 + 0x40, -2)
    put_u32(t, A1 + 0xA4, 3 * 8)
    put_f32(t, A1 + 0xB4, -20); put_f32(t, A1 + 0xB8, 20)
    matrix(t, A2, 5); matrix(t, A2 + 0x40, -5)
    put_u32(t, A2 + 0xA4, 0x4000000 + 1 * 8)
    put_f32(t, A2 + 0xB4, -20); put_f32(t, A2 + 0xB8, 20)
    -- 形：y=0 の四角（三角 2 つ）
    local V, N, T = GEO + 0x10, GEO + 0x40, GEO + 0x50
    put_u32(t, GEO, V); put_u32(t, GEO + 4, N); put_u32(t, GEO + 8, T); put_u16(t, GEO + 12, 2)
    local vs = { { -10, 0, -10 }, { 10, 0, -10 }, { 10, 0, 10 }, { -10, 0, 10 } }
    for i, v in ipairs(vs) do for j = 1, 3 do put_f32(t, V + ((i - 1) * 3 + j - 1) * 4, v[j]) end end
    put_f32(t, N, 0); put_f32(t, N + 4, -1); put_f32(t, N + 8, 0)
    local tri = { 0, 1, 2, 0, 0, 2, 3, 0 }
    for i, v in ipairs(tri) do put_u16(t, T + (i - 1) * 2, v) end
    if encode then
        -- クライアントと同じ形で包む（解くのと同じ操作）
        put_u32(t, 0, SIZE)
        t[3 + 1] = 0x1B
        t[7 + 1] = 0x5A
        local key = zd._KT[(255 - 0x5A) + 1]   -- 0x5A ^ 0xFF
        local kc, pos = 0, 8
        while pos < SIZE do
            local xl = (math.floor(key / 16) % 8) + 16
            if key % 2 == 1 and pos + xl < SIZE then
                for i = pos, pos + xl - 1 do t[i + 1] = 255 - t[i + 1] end
            end
            kc = kc + 1; key = key + kc; pos = pos + xl
        end
    end
    local parts = {}
    for i = 1, #t, 64 do parts[#parts + 1] = string.char(unpack(t, i, math.min(i + 63, #t))) end
    return table.concat(parts)
end
local function chunk(typ, body)
    local n = (#body + 16) / 16
    local t = bytes_of(16)
    t[1], t[2], t[3], t[4] = 116, 101, 115, 116
    put_u32(t, 4, typ + n * 128)
    return string.char(unpack(t)) .. body
end

for _, enc in ipairs({ false, true }) do
    local raw = chunk(0x20, string.rep('\0', 32)) .. chunk(0x1C, build(enc))
    local z, why = zd.open(raw)
    check(z ~= nil, 'opened (encoded=' .. tostring(enc) .. ') ' .. tostring(why))
    eq(z.gw, 20, 'grid width from the header')
    eq(zd.floor_at(z, 0, 0, 0), 3, 'ground below: the nearer floor (y=2)')
    eq(zd.floor_at(z, 1, 1, 3), 9, 'below at y=5 (moved by the matrix)')
    eq(zd.floor_at(z, 0, 0, 8), 9, 'nothing below: looks up, nearest is y=5')
    eq(zd.floor_at(z, 0, 0, 30), nil, 'too far from any floor: unknown')
    eq(zd.floor_at(z, 60, 0, 0), nil, 'outside the grid: unknown')
end
eq(select(2, zd.open('short')), 'no_mzb', 'no MZB chunk')
eq(select(2, zd.open(chunk(0x1C, string.rep('\0', 0x40)))), 'no_mesh', 'broken MZB')

-- 出口に使う：DAT の表は覚えた階のあと、地図の枠より先
local D = app._data()
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
local fl = maps.floors(D, amb_zone)
local want = fl[#fl]
eq(exits.map_n_of(D, maps, {}, amb_zone, amb_e.x, amb_e.y), nil, 'overlapping without DAT: unknown')
local dat = { [amb_zone] = { [exits.key(amb_e.x, amb_e.y)] = want.map_n } }
eq(exits.map_n_of(D, maps, {}, amb_zone, amb_e.x, amb_e.y, dat), want.map_n, 'DAT floor places it')
local learned = { [tostring(amb_zone)] = { [exits.key(amb_e.x, amb_e.y)] = fl[1].map_n } }
eq(exits.map_n_of(D, maps, learned, amb_zone, amb_e.x, amb_e.y, dat), fl[1].map_n, 'what the game said comes first')
dat[amb_zone][exits.key(amb_e.x, amb_e.y)] = false
eq(exits.map_n_of(D, maps, {}, amb_zone, amb_e.x, amb_e.y, dat), nil, 'DAT could not tell: unknown')

-- dat_step：少しずつ、続きの番号を返す
local pts = exits.dat_points(D, amb_zone)
check(#pts > 2, 'points to look up')
local out = {}
local nxt = exits.dat_step(D, maps, amb_zone, pts, {}, function () return want.floor_id end, out, 1, 2)
eq(nxt, 3, 'two at a time')
local seen = 0
for _ in pairs(out) do seen = seen + 1 end
check(seen >= 1, 'stored')
repeat nxt = exits.dat_step(D, maps, amb_zone, pts, {}, function () return want.floor_id end, out, nxt, 2) until nxt == nil
eq(out[exits.key(pts[1][1], pts[1][2])], want.map_n, 'FloorId to MAP number')
local out2 = {}
exits.dat_step(D, maps, amb_zone, pts, {}, function () return 99 end, out2, 1, nil)
eq(out2[exits.key(pts[1][1], pts[1][2])], false, 'unknown FloorId: false')
exits.dat_step(D, maps, amb_zone, pts, {}, function () error('boom') end, out2, 1, nil)

-- 本体：地図を開くと読む（ファイル番号から）。読むのは 1 回だけ、少しずつ
local reads = {}
local real_open, real_floor = zd.open, zd.floor_at
P.read_dat = function (fid) reads[#reads + 1] = fid; return 'RAW' end
zd.open = function (raw) eq(raw, 'RAW', 'raw handed over'); return { fake = true } end
zd.floor_at = function (z, x, y, h) return want.floor_id end
check(app.want_dat_floors(amb_zone), 'queued')
check(not app.want_dat_floors(amb_zone), 'not twice')
check(not app.want_dat_floors(100), 'single map zone: not needed')
for _ = 1, 40 do frame() end
eq(#reads, 1, 'read once')
eq(reads[1], zd.file_id(amb_zone), 'the zone model file')
eq(app.state.dat_status[amb_zone], 'done', 'done')
eq(app.dat_floors()[amb_zone][exits.key(amb_e.x, amb_e.y)], want.map_n, 'placed')
-- 読めないゾーンは一度だけ試す
local z2
for zid = 1, 300 do
    if #maps.floors(D, zid) > 1 and #exits.dat_points(D, zid) > 0 and zid ~= amb_zone then z2 = zid break end
end
check(z2 ~= nil, 'another multi map zone')
if z2 then
    P.read_dat = function (fid) reads[#reads + 1] = fid; return nil, 'no_path' end
    check(app.want_dat_floors(z2), 'queued another')
    for _ = 1, 3 do frame() end
    eq(app.state.dat_status[z2], 'failed', 'no file: failed')
    check(not app.want_dat_floors(z2), 'not retried')
end
-- 地図の窓：となりのゾーンへ行くと、DAT の階が分かった時点でその MAP に切り替わる
local mv = require('src.ui.map_view')
app.state.dat_floors[amb_zone] = nil
app.state.dat_status[amb_zone] = nil
local arr
for zid = 1, 300 do
    for _, e in ipairs(exits.of(D, zid)) do
        if e.to == amb_zone and e.at and exits.map_n_of(D, maps, {}, amb_zone, e.at.x, e.at.y) == nil then arr = e break end
    end
    if arr then break end
end
check(arr ~= nil, 'an exit into the zone')
if arr then
    P.read_dat = function (fid) return 'RAW' end
    local last = fl[#fl].map_n
    zd.floor_at = function () return fl[#fl].floor_id end
    app.open_map(); frame()
    mv.go({ state = app.state, data = D, exit_floors = app.exit_floors, dat_floors = app.dat_floors,
            want_dat_floors = app.want_dat_floors, player = app.state.player }, arr)
    check(app.state.map.arrive_pending, 'waiting for the DAT floor')
    frame()
    eq(app.state.map.arrive.pulse_at, nil, 'no arrival pulse while the floor is unknown (0.1.178)')
    for _ = 1, 40 do frame() end
    check(app.state.map.arrive.pulse_at ~= nil, 'arrival pulse starts on the right MAP')
    eq(app.state.map.map_n, last, 'switched to the MAP the arrival point is on')
    check(not app.state.map.arrive_pending, 'no longer waiting')
    app.close_window('map'); frame()
end
zd.open, zd.floor_at = real_open, real_floor
print('test_zonedat ok')
