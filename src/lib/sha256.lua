--[[
  Astertrail - SHA-256（FIPS 180-4 どおりに自前で書く。ほかのアドオンの実装は使っていない）
]]

local sha256 = {}

local bit = rawget(_G, 'bit') or require('bit')
local band, bor, bxor, bnot = bit.band, bit.bor, bit.bxor, bit.bnot
local rshift, lshift = bit.rshift, bit.lshift

local function u32(x)
    return band(x, 0xFFFFFFFF)
end

local function rrot(x, n)
    return bor(rshift(x, n), lshift(x, 32 - n))
end

local K = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
}

local function to_hex(h)
    local out = {}
    for i = 1, 8 do
        local v = u32(h[i])
        -- LuaJIT の bit は符号付き 32bit を返すことがあるので、16bit ずつ出す
        out[i] = string.format('%04x%04x', rshift(v, 16), band(v, 0xFFFF))
    end
    return table.concat(out)
end

local function process(h, chunk)
    local w = {}
    for i = 1, 16 do
        local o = (i - 1) * 4
        w[i] = bor(
            lshift(chunk:byte(o + 1), 24),
            lshift(chunk:byte(o + 2), 16),
            lshift(chunk:byte(o + 3), 8),
            chunk:byte(o + 4)
        )
    end
    for i = 17, 64 do
        local v15, v2 = w[i - 15], w[i - 2]
        local s0 = bxor(rrot(v15, 7), rrot(v15, 18), rshift(v15, 3))
        local s1 = bxor(rrot(v2, 17), rrot(v2, 19), rshift(v2, 10))
        w[i] = u32(w[i - 16] + s0 + w[i - 7] + s1)
    end
    local a, b, c, d, e, f, g, hh = h[1], h[2], h[3], h[4], h[5], h[6], h[7], h[8]
    for i = 1, 64 do
        local S1 = bxor(rrot(e, 6), rrot(e, 11), rrot(e, 25))
        local ch = bxor(band(e, f), band(bnot(e), g))
        local t1 = u32(hh + S1 + ch + K[i] + w[i])
        local S0 = bxor(rrot(a, 2), rrot(a, 13), rrot(a, 22))
        local maj = bxor(band(a, b), band(a, c), band(b, c))
        local t2 = u32(S0 + maj)
        hh, g, f, e, d, c, b, a = g, f, e, u32(d + t1), c, b, a, u32(t1 + t2)
    end
    h[1] = u32(h[1] + a)
    h[2] = u32(h[2] + b)
    h[3] = u32(h[3] + c)
    h[4] = u32(h[4] + d)
    h[5] = u32(h[5] + e)
    h[6] = u32(h[6] + f)
    h[7] = u32(h[7] + g)
    h[8] = u32(h[8] + hh)
end

function sha256.of_string(s)
    s = tostring(s or '')
    local h = {
        0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
        0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
    }
    local len = #s
    local n = math.floor(len / 64)
    for i = 1, n do
        process(h, s:sub((i - 1) * 64 + 1, i * 64))
    end
    local rem = s:sub(n * 64 + 1)
    local bitlen = len * 8
    rem = rem .. string.char(0x80)
    local zero = (56 - (#rem % 64)) % 64
    if zero == 0 and #rem % 64 ~= 56 then zero = 64 end
    rem = rem .. string.rep('\0', zero)
    local hi = math.floor(bitlen / 4294967296)
    local lo = bitlen % 4294967296
    local function be32(v)
        v = u32(v)
        return string.char(
            rshift(v, 24),
            band(rshift(v, 16), 255),
            band(rshift(v, 8), 255),
            band(v, 255)
        )
    end
    rem = rem .. be32(hi) .. be32(lo)
    for i = 1, #rem / 64 do
        process(h, rem:sub((i - 1) * 64 + 1, i * 64))
    end
    return to_hex(h)
end

function sha256.of_file(path, read)
    if type(read) == 'function' then
        local data, err = read(path)
        if not data then return nil, err end
        return sha256.of_string(data)
    end
    local f, err = io.open(path, 'rb')
    if not f then return nil, err end
    local data = f:read('*a')
    f:close()
    if not data then return nil, 'read failed' end
    return sha256.of_string(data)
end

function sha256.eq(a, b)
    if type(a) ~= 'string' or type(b) ~= 'string' then return false end
    a = a:gsub('%s+', ''):lower()
    b = b:gsub('%s+', ''):lower()
    if #a ~= 64 or #b ~= 64 or a:find('[^0-9a-f]') or b:find('[^0-9a-f]') then return false end
    return a == b
end

return sha256
