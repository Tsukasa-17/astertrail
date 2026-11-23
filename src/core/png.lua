--[[
  Astertrail - PNG を読む（0.1.323〜。同梱の自作の地図画像用。ほかのアドオンの実装は使っていない）
  対応：8 ビットのグレー・RGB・RGBA・グレー+α、パレット（1/2/4/8 ビット、tRNS あり）。インターレースは無し。
  zlib の中身は src/lib/zip.lua の inflate（ラッパ無しの Deflate）で開く。
  戻り値：{ width, height, rgba }（rgba は R,G,B,A の順の文字列。map_dat.decode と同じ形）。失敗は nil, 理由
]]

local png = {}

local zip = require('src.lib.zip')
local bit = rawget(_G, 'bit') or require('bit')
local band, rshift = bit.band, bit.rshift

local SIG = '\137PNG\r\n\26\n'

local function u32be(s, i)
    local a, b, c, d = s:byte(i, i + 3)
    if not d then return nil end
    return ((a * 256 + b) * 256 + c) * 256 + d
end

local CHANNELS = { [0] = 1, [2] = 3, [3] = 1, [4] = 2, [6] = 4 }

function png.decode(bytes)
    if type(bytes) ~= 'string' or bytes:sub(1, 8) ~= SIG then return nil, 'not_png' end
    local pos, w, h, depth, ctype, interlace = 9, nil, nil, nil, nil, nil
    local idat, plte, trns = {}, nil, nil
    while pos + 7 <= #bytes do
        local len = u32be(bytes, pos)
        local typ = bytes:sub(pos + 4, pos + 7)
        if not len or pos + 12 + len - 1 > #bytes then return nil, 'truncated' end
        local data = bytes:sub(pos + 8, pos + 7 + len)
        if typ == 'IHDR' then
            w, h = u32be(data, 1), u32be(data, 5)
            depth, ctype = data:byte(9), data:byte(10)
            interlace = data:byte(13)
        elseif typ == 'PLTE' then plte = data
        elseif typ == 'tRNS' then trns = data
        elseif typ == 'IDAT' then idat[#idat + 1] = data
        elseif typ == 'IEND' then break end
        pos = pos + 12 + len
    end
    if not w or not h or w < 1 or h < 1 then return nil, 'no_header' end
    if interlace ~= 0 then return nil, 'interlaced' end
    local ch = CHANNELS[ctype]
    if not ch then return nil, 'bad_color_type' end
    if ctype == 3 then
        if not (depth == 1 or depth == 2 or depth == 4 or depth == 8) then return nil, 'bad_depth' end
        if not plte then return nil, 'no_palette' end
    elseif depth ~= 8 then
        return nil, 'bad_depth'
    end
    local z = table.concat(idat)
    if #z < 3 then return nil, 'no_data' end
    -- zlib：先頭 2 バイト（CMF/FLG）を飛ばす。辞書つきは使わない
    if band(z:byte(2), 0x20) ~= 0 then return nil, 'zlib_dict' end
    local raw, why = zip.inflate(z:sub(3))
    if not raw then return nil, why or 'inflate' end

    local bpp = math.max(1, math.floor(ch * depth / 8))        -- フィルタの左隣のバイト数
    local stride = math.floor((w * ch * depth + 7) / 8)
    if #raw < (stride + 1) * h then return nil, 'short_data' end

    -- パレット → 4 文字の色
    local pal
    if ctype == 3 then
        pal = {}
        for i = 0, math.floor(#plte / 3) - 1 do
            local r, g, b = plte:byte(i * 3 + 1, i * 3 + 3)
            local a = trns and trns:byte(i + 1) or 255
            pal[i] = string.char(r, g, b, a)
        end
    end
    local black = string.char(0, 0, 0, 255)

    local prev, cur = {}, {}
    for i = 1, stride do prev[i] = 0 end
    local rows = {}
    local sp = 1
    local char = string.char
    for y = 1, h do
        local ft = raw:byte(sp)
        sp = sp + 1
        for i = 1, stride do
            local x = raw:byte(sp + i - 1)
            local a = (i > bpp) and cur[i - bpp] or 0
            local b = prev[i]
            if ft == 1 then x = x + a
            elseif ft == 2 then x = x + b
            elseif ft == 3 then x = x + math.floor((a + b) / 2)
            elseif ft == 4 then
                local c = (i > bpp) and prev[i - bpp] or 0
                local p = a + b - c
                local pa, pb, pc = math.abs(p - a), math.abs(p - b), math.abs(p - c)
                if pa <= pb and pa <= pc then x = x + a
                elseif pb <= pc then x = x + b
                else x = x + c end
            elseif ft ~= 0 then
                return nil, 'bad_filter'
            end
            cur[i] = x % 256
        end
        sp = sp + stride
        local line = {}
        if ctype == 3 then
            if depth == 8 then
                for x = 1, w do line[x] = pal[cur[x]] or black end
            else
                local per = 8 / depth
                local mask = 2 ^ depth - 1
                for x = 0, w - 1 do
                    local byte = cur[math.floor(x / per) + 1]
                    local shift = 8 - depth * (x % per + 1)
                    line[x + 1] = pal[band(rshift(byte, shift), mask)] or black
                end
            end
        elseif ctype == 0 then
            for x = 1, w do local v = cur[x]; line[x] = char(v, v, v, 255) end
        elseif ctype == 4 then
            for x = 1, w do local v = cur[x * 2 - 1]; line[x] = char(v, v, v, cur[x * 2]) end
        elseif ctype == 2 then
            for x = 1, w do local i = x * 3 - 2; line[x] = char(cur[i], cur[i + 1], cur[i + 2], 255) end
        else
            for x = 1, w do local i = x * 4 - 3; line[x] = char(cur[i], cur[i + 1], cur[i + 2], cur[i + 3]) end
        end
        rows[y] = table.concat(line)
        prev, cur = cur, prev
    end
    return { width = w, height = h, rgba = table.concat(rows) }
end

function png.decode_file(path, fs)
    if not path or not fs or not fs.read then return nil, 'no_file' end
    local bytes, why = fs.read(path)
    if not bytes then return nil, why or 'read_failed' end
    return png.decode(bytes)
end

return png
