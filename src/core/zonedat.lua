--[[
  Astertrail - ゾーンの DAT から「その点はどの階か」を調べる（0.1.176〜、t266）
  まだ入ったことのない複数 MAP のゾーンでも、出口と「来たときに立つ位置」を正しい MAP に置くため。
  データは同梱しない。実行時に、そのゾーンの 3D の DAT（ファイル番号 = ゾーン番号 + 100、
  256 以上は + 83635）を読み、中の当たり判定（MZB）を使う。
  ゲームの階の関数（FFXiMain の floor 関数）と同じことをする：
    点の 0.51 上から 10 下まで、だめなら 0.51 下から 15 上まで、縦に線を引き、
    いちばん近くで当たった面の持ち主（当たり判定の置き場所）の flags から階の番号（FloorId）を出す。
      FloorId = ((flags >> 26) & 3) << 3 | ((flags >> 3) & 7)
  形の分からないところ・壊れているところは nil（その点は置かない。推測はしない）。
  読むだけ。何も書かない・送らない。
]]

local zonedat = {}

zonedat.TYPE_MZB = 0x1C

-- 3D の DAT のファイル番号
function zonedat.file_id(zone_id)
    zone_id = tonumber(zone_id)
    if not zone_id or zone_id < 0 then return nil end
    if zone_id < 256 then return zone_id + 100 end
    return zone_id + 83635
end

-- MZB を解く鍵の表（クライアントの形式。データではなく解き方）
local KT = {  -- zonedat._KT（テスト用）
    0xE2, 0xE5, 0x06, 0xA9, 0xED, 0x26, 0xF4, 0x42, 0x15, 0xF4, 0x81, 0x7F, 0xDE, 0x9A, 0xDE, 0xD0,
    0x1A, 0x98, 0x20, 0x91, 0x39, 0x49, 0x48, 0xA4, 0x0A, 0x9F, 0x40, 0x69, 0xEC, 0xBD, 0x81, 0x81,
    0x8D, 0xAD, 0x10, 0xB8, 0xC1, 0x88, 0x15, 0x05, 0x11, 0xB1, 0xAA, 0xF0, 0x0F, 0x1E, 0x34, 0xE6,
    0x81, 0xAA, 0xCD, 0xAC, 0x02, 0x84, 0x33, 0x0A, 0x19, 0x38, 0x9E, 0xE6, 0x73, 0x4A, 0x11, 0x5D,
    0xBF, 0x85, 0x77, 0x08, 0xCD, 0xD9, 0x96, 0x0D, 0x79, 0x78, 0xCC, 0x35, 0x06, 0x8E, 0xF9, 0xFE,
    0x66, 0xB9, 0x21, 0x03, 0x20, 0x29, 0x1E, 0x27, 0xCA, 0x86, 0x82, 0xE6, 0x45, 0x07, 0xDD, 0xA9,
    0xB6, 0xD5, 0xA2, 0x03, 0xEC, 0xAD, 0x62, 0x45, 0x2D, 0xCE, 0x79, 0xBD, 0x8F, 0x2D, 0x10, 0x18,
    0xE6, 0x0A, 0x6F, 0xAA, 0x6F, 0x46, 0x84, 0x32, 0x9F, 0x29, 0x2C, 0xC2, 0xF0, 0xEB, 0x18, 0x6F,
    0xF2, 0x3A, 0xDC, 0xEA, 0x7B, 0x0C, 0x81, 0x2D, 0xCC, 0xEB, 0xA1, 0x51, 0x77, 0x2C, 0xFB, 0x49,
    0xE8, 0x90, 0xF7, 0x90, 0xCE, 0x5C, 0x01, 0xF3, 0x5C, 0xF4, 0x41, 0xAB, 0x04, 0xE7, 0x16, 0xCC,
    0x3A, 0x05, 0x54, 0x55, 0xDC, 0xED, 0xA4, 0xD6, 0xBF, 0x3F, 0x9E, 0x08, 0x93, 0xB5, 0x63, 0x38,
    0x90, 0xF7, 0x5A, 0xF0, 0xA2, 0x5F, 0x56, 0xC8, 0x08, 0x70, 0xCB, 0x24, 0x16, 0xDD, 0xD2, 0x74,
    0x95, 0x3A, 0x1A, 0x2A, 0x74, 0xC4, 0x9D, 0xEB, 0xAF, 0x69, 0xAA, 0x51, 0x39, 0x65, 0x94, 0xA2,
    0x4B, 0x1F, 0x1A, 0x60, 0x52, 0x39, 0xE8, 0x23, 0xEE, 0x58, 0x39, 0x06, 0x3D, 0x22, 0x6A, 0x2D,
    0xD2, 0x91, 0x25, 0xA5, 0x2E, 0x71, 0x62, 0xA5, 0x0B, 0xC1, 0xE5, 0x6E, 0x43, 0x49, 0x7C, 0x58,
    0x46, 0x19, 0x9F, 0x45, 0x49, 0xC6, 0x40, 0x09, 0xA2, 0x99, 0x5B, 0x7B, 0x98, 0x7F, 0xA0, 0xD0,
}

zonedat._KT = KT

local floor = math.floor
local unpack = unpack or table.unpack

local function bxor8(a, b)
    local r, bitv = 0, 1
    for _ = 1, 8 do
        local x, y = a % 2, b % 2
        if x ~= y then r = r + bitv end
        a, b, bitv = (a - x) / 2, (b - y) / 2, bitv * 2
    end
    return r
end

local function raw_u32(s, o)
    local a, b, c, d = s:byte(o + 1, o + 4)
    if not d then return nil end
    return a + b * 256 + c * 65536 + d * 16777216
end

-- DAT の中の最初の MZB の場所（0 始まり）と長さ
function zonedat.find_mzb(raw)
    if type(raw) ~= 'string' then return nil end
    local pos, n = 0, #raw
    while pos + 16 <= n do
        local v = raw_u32(raw, pos + 4)
        if not v then return nil end
        local typ = v % 128
        local size = 16 * (floor(v / 128) % 0x80000) - 16
        if size < 0 then return nil end
        if typ == zonedat.TYPE_MZB and size > 0 then
            if pos + 16 + size > n then return nil end
            return pos + 16, size
        end
        pos = pos + 16 + size
    end
    return nil
end

-- 解いた中身を読む道具。解くのは読むところだけ（256 バイトずつ）
local CHUNK = 256
local Reader = {}
Reader.__index = Reader

local function new_reader(raw, base, size)
    local r = setmetatable({ raw = raw, base = base, size = size, cache = {}, xs = {}, xe = {}, nodes_end = 0 }, Reader)
    local b3 = raw:byte(base + 4)
    if b3 and b3 >= 0x1B then
        local L = (raw_u32(raw, base) or 0) % 0x1000000
        if L > size then L = size end
        local key = KT[bxor8(raw:byte(base + 8), 0xFF) + 1]
        local kc, pos = 0, 8
        local xs, xe = r.xs, r.xe
        while pos < L do
            local xl = (floor(key / 16) % 8) + 16
            if key % 2 == 1 and pos + xl < L then
                xs[#xs + 1] = pos
                xe[#xe + 1] = pos + xl
            end
            kc = kc + 1
            key = key + kc
            pos = pos + xl
        end
        local nodes = (raw_u32(raw, base + 4) or 0) % 0x1000000
        r.nodes_end = 0x20 + nodes * 0x64
    end
    return r
end

-- p を含むかもしれない最後の帯の番号
local function span_at(xs, p)
    local lo, hi = 1, #xs
    local ans = 0
    while lo <= hi do
        local mid = floor((lo + hi) / 2)
        if xs[mid] <= p then ans = mid; lo = mid + 1 else hi = mid - 1 end
    end
    return ans
end

function Reader:chunk(c)
    local s = self.cache[c]
    if s then return s end
    local from = c * CHUNK
    local to = math.min(from + CHUNK, self.size) - 1
    if to < from then return nil end
    local bytes = { self.raw:byte(self.base + from + 1, self.base + to + 1) }
    local xs, xe = self.xs, self.xe
    local i = span_at(xs, from)
    if i == 0 then i = 1 end
    while i <= #xs and xs[i] <= to do
        local a, b = math.max(xs[i], from), math.min(xe[i] - 1, to)
        for p = a, b do
            local k = p - from + 1
            bytes[k] = 255 - bytes[k]
        end
        i = i + 1
    end
    if from < self.nodes_end then
        for p = math.max(from, 0x20), math.min(to, self.nodes_end - 1) do
            if (p - 0x20) % 0x64 < 16 then
                local k = p - from + 1
                bytes[k] = bxor8(bytes[k], 0x55)
            end
        end
    end
    local parts = {}
    for k = 1, #bytes, 64 do
        parts[#parts + 1] = string.char(unpack(bytes, k, math.min(k + 63, #bytes)))
    end
    s = table.concat(parts)
    self.cache[c] = s
    return s
end

function Reader:u8(p)
    if p < 0 or p >= self.size then return nil end
    local c = floor(p / CHUNK)
    local s = self:chunk(c)
    return s and s:byte(p - c * CHUNK + 1)
end

function Reader:u16(p)
    if p < 0 or p + 2 > self.size then return nil end
    local c = floor(p / CHUNK)
    local o = p - c * CHUNK
    if o + 2 <= CHUNK then
        local a, b = self:chunk(c):byte(o + 1, o + 2)
        return a + b * 256
    end
    return self:u8(p) + self:u8(p + 1) * 256
end

function Reader:u32(p)
    if p < 0 or p + 4 > self.size then return nil end
    local c = floor(p / CHUNK)
    local o = p - c * CHUNK
    if o + 4 <= CHUNK then
        local a, b, cc, d = self:chunk(c):byte(o + 1, o + 4)
        return a + b * 256 + cc * 65536 + d * 16777216
    end
    return self:u8(p) + self:u8(p + 1) * 256 + self:u8(p + 2) * 65536 + self:u8(p + 3) * 16777216
end

local function bits_f32(v)
    if not v then return nil end
    local sign = v >= 0x80000000 and -1 or 1
    local e = floor(v / 0x800000) % 256
    local m = v % 0x800000
    if e == 0 then
        if m == 0 then return 0 * sign end
        return sign * math.ldexp(m, -149)
    elseif e == 255 then
        return nil
    end
    return sign * math.ldexp(m + 0x800000, e - 150)
end
zonedat._f32 = bits_f32

function Reader:f32(p) return bits_f32(self:u32(p)) end

-- MZB を開く。戻り値: 調べる道具, または nil, 理由
function zonedat.open(raw)
    local base, size = zonedat.find_mzb(raw)
    if not base then return nil, 'no_mzb' end
    if size < 0x40 then return nil, 'short' end
    local r = new_reader(raw, base, size)
    local mo = 8
    while mo < 0x20 and r:u32(mo) == 0 do mo = mo + 4 end
    local meshoff = r:u32(mo)
    if not meshoff or meshoff <= 0 or meshoff + 0x14 > size then return nil, 'no_mesh' end
    local grid = r:u32(meshoff + 0x10)
    local gw = floor(r:u8(0x0c) * r:u8(0x0e) / 4)
    local gh = floor(r:u8(0x0d) * r:u8(0x0f) / 4)
    if not grid or grid <= 0 or gw <= 0 or gh <= 0 or grid + gw * gh * 4 > size then return nil, 'no_grid' end
    return { r = r, grid = grid, gw = gw, gh = gh, ox = gw * 2.0, oy = gh * 2.0, mats = {} }
end

-- 区画 (cx, cy) に入っている (置き場所, 形) の組
local function cell_entries(z, cx, cy, out, seen)
    if cx < 0 or cy < 0 or cx >= z.gw or cy >= z.gh then return end
    local r = z.r
    local e = r:u32(z.grid + (cy * z.gw + cx) * 4)
    if not e or e <= 0 or e >= r.size then return end
    local p = e
    for _ = 1, 64 do
        local head = r:u32(p)
        if not head or head == 0 then return end
        local n = head % 0x800
        p = p + 4
        if floor(head / 0x2000) % 2 == 1 then
            p = p + n * 8
        else
            for _ = 1, n do
                local a, g = r:u32(p), r:u32(p + 4)
                if not a or not g then return end
                p = p + 8
                local k = a * 4294967296 + g
                if not seen[k] and a > 0 and g > 0 and a + 0xC0 <= r.size and g + 0x10 <= r.size then
                    seen[k] = true
                    out[#out + 1] = a
                    out[#out + 1] = g
                end
            end
        end
    end
end

local function mat16(z, a, off)
    local key = a + off
    local m = z.mats[key]
    if m then return m end
    m = {}
    for i = 0, 15 do
        local v = z.r:f32(a + off + i * 4)
        if v == nil then return nil end
        m[i] = v
    end
    z.mats[key] = m
    return m
end

local function xf(m, x, y, w)
    return x * m[0] + y * m[4] + w * m[8] + m[12],
           x * m[1] + y * m[5] + w * m[9] + m[13],
           x * m[2] + y * m[6] + w * m[10] + m[14]
end

local function vec(r, p)
    local x, y, w = r:f32(p), r:f32(p + 4), r:f32(p + 8)
    if x == nil or y == nil or w == nil then return nil end
    return x, y, w
end

-- 縦の線 (x, y0, w) → (x, y1, w) が最初に当たる面の FloorId と、当たった高さ
local function ray(z, x, y0, w, y1)
    local r = z.r
    local cx, cy = floor((z.ox + x) * 0.25), floor((z.oy + w) * 0.25)
    local list, seen = {}, {}
    for gy = cy - 1, cy + 1 do
        for gx = cx - 1, cx + 1 do cell_entries(z, gx, gy, list, seen) end
    end
    local ymin, ymax = math.min(y0, y1), math.max(y0, y1)
    local best, best_d, best_y = nil, 1e12, nil
    for i = 1, #list, 2 do
        local a, g = list[i], list[i + 1]
        local lo, hi = r:f32(a + 0xB4), r:f32(a + 0xB8)
        if lo and hi and lo <= ymax and hi >= ymin then
            local inv, M = mat16(z, a, 0x40), mat16(z, a, 0)
            if inv and M then
                local sx, sy, sw = xf(inv, x, y0, w)
                local ex, ey, ew = xf(inv, x, y1, w)
                local dx, dy, dw = ex - sx, ey - sy, ew - sw
                local verts, norms, tris = r:u32(g), r:u32(g + 4), r:u32(g + 8)
                local tc = r:u16(g + 12)
                if verts and norms and tris and tc and tc < 0x8000 then
                    for t = 0, tc - 1 do
                        local q = tris + t * 8
                        local i0, i1, i2, i3 = r:u16(q), r:u16(q + 2), r:u16(q + 4), r:u16(q + 6)
                        if not i3 then break end
                        local nx, ny, nw = vec(r, norms + (i3 % 0x8000) * 12)
                        if nx then
                            nx, ny, nw = -nx, -ny, -nw
                            local den = nx * dx + ny * dy + nw * dw
                            if den ~= 0 then
                                local ax, ay, aw = vec(r, verts + (i0 % 0x8000) * 12)
                                if ax then
                                    local tt = ((nx * ax + ny * ay + nw * aw) - (nx * sx + ny * sy + nw * sw)) / den
                                    if tt >= 0 and tt < 1 then
                                        local bx, by, bw = vec(r, verts + (i1 % 0x4000) * 12)
                                        local qx, qy, qw = vec(r, verts + (i2 % 0x4000) * 12)
                                        if bx and qx then
                                            local px, py, pw = sx + tt * dx, sy + tt * dy, sw + tt * dw
                                            local function side(ux, uy, uw, vx, vy, vw)
                                                -- ((v - u) × (p - u)) · n
                                                local e1x, e1y, e1w = vx - ux, vy - uy, vw - uw
                                                local e2x, e2y, e2w = px - ux, py - uy, pw - uw
                                                return (e1y * e2w - e1w * e2y) * nx + (e1w * e2x - e1x * e2w) * ny
                                                    + (e1x * e2y - e1y * e2x) * nw
                                            end
                                            local c0 = side(ax, ay, aw, bx, by, bw)
                                            local c1 = side(bx, by, bw, qx, qy, qw)
                                            local c2 = side(qx, qy, qw, ax, ay, aw)
                                            local eps = 1e-4
                                            if (c0 >= -eps and c1 >= -eps and c2 >= -eps) or (c0 <= eps and c1 <= eps and c2 <= eps) then
                                                local wx, wy, ww = xf(M, px, py, pw)
                                                local d = (wx - x) ^ 2 + (wy - y0) ^ 2 + (ww - w) ^ 2
                                                if d < best_d then
                                                    local fl = r:u32(a + 0xA4)
                                                    if fl then
                                                        best_d = d
                                                        best = (floor(fl / 0x4000000) % 4) * 8 + floor(fl / 8) % 8
                                                        best_y = wy
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return best, best_y
end

-- その点（x, y は水平面、h は高さ。vana.game.entity と同じ向き）の FloorId。分からなければ nil
function zonedat.floor_at(z, x, y, h)
    x, y, h = tonumber(x), tonumber(y), tonumber(h)
    if not z or not x or not y or not h then return nil end
    local f = ray(z, x, h - 0.51, y, h - 0.51 + 10)
    if f ~= nil then return f end
    return (ray(z, x, h + 0.51, y, h + 0.51 - 15))
end

return zonedat
