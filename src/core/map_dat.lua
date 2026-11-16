--[[
  Astertrail - 2D メニュー地図 DAT の読み取り
  画像は同梱せず、実行時にクライアントのファイルを読む。
  分かっている形式（8bit パレット、DXT1/DXT3/DXT5）だけを扱い、
  分からない・壊れているときは nil を返して、画面はマス目の方眼に戻る。
  （3D ゾーン用のライブラリとは別物なので、そちらには頼らない）
]]

local map_dat = {}
local unpack = unpack or table.unpack


local function u8(s, o)
    return s:byte(o + 1)
end

local function u16(s, o)
    local a, b = s:byte(o + 1, o + 2)
    if not b then return nil end
    return a + b * 256
end

local function u32(s, o)
    local a, b, c, d = s:byte(o + 1, o + 4)
    if not d then return nil end
    return a + b * 256 + c * 65536 + d * 16777216
end

local function i32(s, o)
    local v = u32(s, o)
    if not v then return nil end
    if v >= 2147483648 then return v - 4294967296 end
    return v
end

local function rgb565(c)
    local r = math.floor(c / 2048) % 32
    local g = math.floor(c / 32) % 64
    local b = c % 32
    return math.floor(r * 255 / 31 + 0.5), math.floor(g * 255 / 63 + 0.5), math.floor(b * 255 / 31 + 0.5)
end

-- 0 始まりの (x,y) に RGBA を書く（上左が 0,0）
local function put(rows, w, h, x, y, r, g, b, a)
    if x < 0 or y < 0 or x >= w or y >= h then return end
    local row = rows[y + 1]
    local i = x * 4
    row[i + 1], row[i + 2], row[i + 3], row[i + 4] = r, g, b, a
end

local function chars(t)
    -- string.char の引数上限を超えないよう、少しずつつなぐ
    local n, out, i = #t, {}, 1
    while i <= n do
        local e = math.min(i + 511, n)
        out[#out + 1] = string.char(unpack(t, i, e))
        i = e + 1
    end
    return table.concat(out)
end

local function finish(rows, w, h, fmt, id)
    local lines = {}
    for y = 1, h do
        lines[y] = chars(rows[y])
    end
    return {
        width = w, height = h,
        rgba = table.concat(lines),
        format = fmt,
        id = id,
    }
end

local function new_rows(w, h)
    local rows = {}
    for y = 1, h do
        local row = {}
        for i = 1, w * 4 do row[i] = 0 end
        rows[y] = row
    end
    return rows
end

-- 32bit パレット色（BGRA。A が 0x80 未満なら 2 倍、それ以外は不透明）
local function pal_color(s, o)
    local b, g, r, a = s:byte(o + 1, o + 4)
    if a < 128 then a = a * 2 else a = 255 end
    return r, g, b, a
end

local function decode_pal8(s, off, w, h, id)
    local pal = {}
    for i = 0, 255 do
        local r, g, b, a = pal_color(s, off + i * 4)
        pal[i] = { r, g, b, a }
    end
    off = off + 1024
    local need = off + w * h
    if need - 1 > #s then return nil, 'truncated' end
    local rows = new_rows(w, h)
    for n = 0, w * h - 1 do
        local x = n % w
        local y = h - 1 - math.floor(n / w)
        local c = pal[s:byte(off + n + 1)]
        put(rows, w, h, x, y, c[1], c[2], c[3], c[4])
    end
    return finish(rows, w, h, 'pal8', id)
end

local function mix(c0, c1, a, b)
    return math.floor((a * c0[1] + b * c1[1] + 1) / 3),
           math.floor((a * c0[2] + b * c1[2] + 1) / 3),
           math.floor((a * c0[3] + b * c1[3] + 1) / 3)
end

local function dxt_block(s, off, four, rows, w, h, bx, by)
    local alpha = {}
    if four == 'DXT2' or four == 'DXT3' or four == 'DXT4' or four == 'DXT5' then
        if four == 'DXT2' or four == 'DXT3' then
            for i = 0, 15 do
                local byte = s:byte(off + math.floor(i / 2) + 1)
                local a = (i % 2 == 0) and (byte % 16) or math.floor(byte / 16) % 16
                alpha[i] = a * 17
            end
        else
            local a0 = s:byte(off + 1)
            local a1 = s:byte(off + 2)
            local av = { a0, a1 }
            if a0 > a1 then
                av[3] = math.floor((6 * a0 + 1 * a1 + 3) / 7)
                av[4] = math.floor((5 * a0 + 2 * a1 + 3) / 7)
                av[5] = math.floor((4 * a0 + 3 * a1 + 3) / 7)
                av[6] = math.floor((3 * a0 + 4 * a1 + 3) / 7)
                av[7] = math.floor((2 * a0 + 5 * a1 + 3) / 7)
                av[8] = math.floor((1 * a0 + 6 * a1 + 3) / 7)
            else
                av[3] = math.floor((4 * a0 + 1 * a1 + 2) / 5)
                av[4] = math.floor((3 * a0 + 2 * a1 + 2) / 5)
                av[5] = math.floor((2 * a0 + 3 * a1 + 2) / 5)
                av[6] = math.floor((1 * a0 + 4 * a1 + 2) / 5)
                av[7] = 0
                av[8] = 255
            end
            -- 3bit 指標は 6 バイト（48bit）。バイト列から取る
            for i = 0, 15 do
                local bitpos = 16 + 3 * i  -- 先頭 16bit は a0,a1
                local boff = math.floor(bitpos / 8)
                local bsh = bitpos % 8
                local v = s:byte(off + boff + 1) or 0
                v = v + (s:byte(off + boff + 2) or 0) * 256
                local idx = math.floor(v / (2 ^ bsh)) % 8
                alpha[i] = av[idx + 1]
            end
        end
        off = off + 8
    else
        for i = 0, 15 do alpha[i] = 255 end
    end
    local c0 = u16(s, off)
    local c1 = u16(s, off + 2)
    local bits = u32(s, off + 4)
    off = off + 8
    local cols = {}
    local r0, g0, b0 = rgb565(c0)
    local r1, g1, b1 = rgb565(c1)
    cols[0] = { r0, g0, b0, 255 }
    cols[1] = { r1, g1, b1, 255 }
    if c0 > c1 or four ~= 'DXT1' then
        local r, g, b = mix(cols[0], cols[1], 2, 1)
        cols[2] = { r, g, b, 255 }
        r, g, b = mix(cols[1], cols[0], 2, 1)
        cols[3] = { r, g, b, 255 }
    else
        cols[2] = { math.floor((r0 + r1) / 2), math.floor((g0 + g1) / 2), math.floor((b0 + b1) / 2), 255 }
        cols[3] = { 0, 0, 0, 0 }
    end
    for i = 0, 15 do
        local ci = math.floor(bits / (2 ^ (2 * i))) % 4
        local c = cols[ci]
        local a = (four == 'DXT1') and c[4] or alpha[i]
        put(rows, w, h, bx + (i % 4), by + math.floor(i / 4), c[1], c[2], c[3], a)
    end
    return off
end

local function decode_dxt(s, off, w, h, id)
    if (w % 4) ~= 0 or (h % 4) ~= 0 then return nil, 'dxt_size' end
    local raw = s:sub(off + 1, off + 4)
    if #raw < 4 then return nil, 'truncated' end
    local four = raw:reverse():gsub('%z', '')
    if four ~= 'DXT1' and four ~= 'DXT2' and four ~= 'DXT3' and four ~= 'DXT4' and four ~= 'DXT5' then
        return nil, 'unknown_dxt'
    end
    off = off + 4 + 8  -- FourCC のあと 8 バイトは使わない
    local rows = new_rows(w, h)
    local bx, by = 0, 0
    local nblocks = (w / 4) * (h / 4)
    for _ = 1, nblocks do
        if off + 8 > #s then return nil, 'truncated' end
        off = dxt_block(s, off, four, rows, w, h, bx, by)
        bx = bx + 4
        if bx >= w then bx = 0; by = by + 4 end
    end
    return finish(rows, w, h, four:lower(), id)
end

-- ヘッダを探して、メニュー地図らしいものを選ぶ
local function find_graphic(bytes)
    local n = #bytes
    local limit = math.min(n - 60, 8192)
    local best, best_score
    for i = 0, limit do
        local flag = bytes:byte(i + 1)
        if flag == 0x91 or flag == 0xA1 or flag == 0xB1 then
            local cat = bytes:sub(i + 2, i + 9)
            local id = bytes:sub(i + 10, i + 17)
            if u32(bytes, i + 17) == 40 then
                local w = i32(bytes, i + 21)
                local h = i32(bytes, i + 25)
                local planes = u16(bytes, i + 29)
                local bits = u16(bytes, i + 31)
                if w and h and w >= 1 and w <= 4096 and h >= 1 and h <= 4096 and planes == 1 then
                    local score = 1
                    if cat:find('menu', 1, true) or cat:find('map', 1, true) then score = 3 end
                    if not best or score > best_score then
                        best_score = score
                        best = { off = i, flag = flag, cat = cat, id = id, w = w, h = h, bits = bits }
                    end
                    if score >= 3 then break end  -- メニュー地図を見つけたらそれで十分
                end
            end
        end
    end
    return best
end

-- bytes: ファイルの中身（文字列）。成功時は { width, height, rgba }、失敗時は nil, 理由
function map_dat.decode(bytes)
    if type(bytes) ~= 'string' or #bytes < 16 then
        return nil, 'too_short'
    end
    local g = find_graphic(bytes)
    if not g then return nil, 'unknown_format' end
    -- BITMAPINFO の直後（off + 17 + 40）
    local off = g.off + 57
    if g.flag == 0xB1 then
        off = off + 4  -- 種別（BITMAP のとき 10 が入っていることが多い）
    end
    if g.flag == 0xA1 then
        return decode_dxt(bytes, off, g.w, g.h, g.id)
    end
    if (g.flag == 0x91 or g.flag == 0xB1) and g.bits == 8 then
        return decode_pal8(bytes, off, g.w, g.h, g.id)
    end
    return nil, 'unsupported'
end

-- fs.read でパスから読む
function map_dat.decode_file(path, fs)
    if not path or not fs or not fs.read then return nil, 'no_file' end
    local bytes, why = fs.read(path)
    if not bytes then return nil, why or 'read_failed' end
    return map_dat.decode(bytes)
end

return map_dat
