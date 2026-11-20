--[[
  Astertrail - ZIP の展開（このアドオン用。Stored と Deflate。ほかのアドオンの実装は使っていない）
  パスに .. が含まれる項目は書かない。先に作業フォルダへ全部出し、失敗したら何も残さない前提で使う。
]]

local zip = {}

local bit = rawget(_G, 'bit') or require('bit')
local band, bor, bxor, rshift, lshift = bit.band, bit.bor, bit.bxor, bit.rshift, bit.lshift

local function u16(s, i)
    i = i or 1
    local a, b = s:byte(i, i + 1)
    if not a or not b then return nil end
    return a + b * 256
end

local function u32(s, i)
    i = i or 1
    local a, b, c, d = s:byte(i, i + 3)
    if not a or not b or not c or not d then return nil end
    return a + b * 256 + c * 65536 + d * 16777216
end

-- 相対パスとして安全か。絶対パスや .. は拒否
function zip.safe_rel(name)
    if type(name) ~= 'string' or name == '' then return nil end
    name = name:gsub('\\', '/')
    if name:match('^/') or name:match('^%a:[/\\]') then return nil end
    local parts = {}
    for seg in name:gmatch('[^/]+') do
        if seg == '..' then return nil end
        if seg ~= '.' and seg ~= '' then parts[#parts + 1] = seg end
    end
    if #parts == 0 then return nil end
    return table.concat(parts, '/')
end

---------------------------------------------------------------------------
-- Deflate（RFC 1951、ZIP の method 8 は zlib ラッパ無し）
---------------------------------------------------------------------------

local function inflate_raw(src)
    if type(src) ~= 'string' then return nil, 'no data' end
    local pos, bitn, acc = 1, 0, 0
    local function pull(n)
        while bitn < n do
            local b = src:byte(pos)
            if not b then return nil, 'truncated' end
            pos = pos + 1
            acc = acc + lshift(b, bitn)
            bitn = bitn + 8
        end
        local v = band(acc, rshift(0xFFFFFFFF, 32 - n))
        acc = rshift(acc, n)
        bitn = bitn - n
        return v
    end

    local function build_codes(lens)
        local maxc, count = 0, {}
        for i = 1, #lens do
            local l = lens[i] or 0
            if l > 0 then
                count[l] = (count[l] or 0) + 1
                if l > maxc then maxc = l end
            end
        end
        local nextc, code = {}, 0
        for l = 1, maxc do
            code = lshift(code + (count[l - 1] or 0), 1)
            nextc[l] = code
        end
        local map = {}
        for i = 1, #lens do
            local l = lens[i] or 0
            if l > 0 then
                local c = nextc[l]
                nextc[l] = c + 1
                local key = l * 65536 + c
                map[key] = i - 1
            end
        end
        return map, maxc
    end

    local function decode(map, maxc)
        local code = 0
        for l = 1, maxc do
            local b, err = pull(1)
            if not b then return nil, err end
            code = lshift(code, 1) + b
            local s = map[l * 65536 + code]
            if s ~= nil then return s end
        end
        return nil, 'bad huffman'
    end

    local function lens_from_clen(order, clen, n)
        local lens = {}
        for i = 1, n do lens[i] = 0 end
        local map, maxc = build_codes(clen)
        local i = 1
        while i <= n do
            local s, err = decode(map, maxc)
            if not s then return nil, err end
            if s <= 15 then
                lens[i] = s; i = i + 1
            elseif s == 16 then
                local extra, e2 = pull(2)
                if not extra then return nil, e2 end
                local rep = 3 + extra
                local prev = (i > 1) and lens[i - 1] or 0
                for _ = 1, rep do lens[i] = prev; i = i + 1 end
            elseif s == 17 then
                local extra, e2 = pull(3)
                if not extra then return nil, e2 end
                local rep = 3 + extra
                for _ = 1, rep do lens[i] = 0; i = i + 1 end
            elseif s == 18 then
                local extra, e2 = pull(7)
                if not extra then return nil, e2 end
                local rep = 11 + extra
                for _ = 1, rep do lens[i] = 0; i = i + 1 end
            else
                return nil, 'bad clen'
            end
        end
        return lens
    end

    -- fixed Huffman
    local fixed_lit, fixed_lit_max, fixed_dist, fixed_dist_max
    do
        local lit = {}
        for i = 0, 143 do lit[i + 1] = 8 end
        for i = 144, 255 do lit[i + 1] = 9 end
        for i = 256, 279 do lit[i + 1] = 7 end
        for i = 280, 287 do lit[i + 1] = 8 end
        fixed_lit, fixed_lit_max = build_codes(lit)
        local dist = {}
        for i = 1, 32 do dist[i] = 5 end
        fixed_dist, fixed_dist_max = build_codes(dist)
    end

    local LEN_BASE = {
        3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,
        67,83,99,115,131,163,195,227,258
    }
    local LEN_EXTRA = {
        0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,
        4,4,4,4,5,5,5,5,0
    }
    local DIST_BASE = {
        1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,
        1025,1537,2049,3073,4097,6145,8193,12289,16385,24577
    }
    local DIST_EXTRA = {
        0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,
        9,9,10,10,11,11,12,12,13,13
    }

    local out = {}
    local out_len = 0
    local function emit(b)
        out_len = out_len + 1
        out[out_len] = string.char(band(b, 255))
        -- compact occasionally
        if out_len >= 4096 then
            -- leave as array; concat at end / mid if huge
        end
    end
    local function byte_at(idx)
        -- idx is 1-based in the output
        local chunk = 4096
        -- we will flatten when needed... use a string buffer instead
        return nil
    end

    -- Use a string buffer that we append to in pieces, and a window of last 32K
    local parts, plen = {}, 0
    local window = {}
    local wlen = 0
    local function put(b)
        b = band(b, 255)
        wlen = wlen + 1
        window[wlen] = b
        plen = plen + 1
        if wlen >= 65536 then
            -- flush first 32k into parts, keep last 32k
            local buf, n = {}, 32768
            for i = 1, 32768 do buf[i] = string.char(window[i]) end
            parts[#parts + 1] = table.concat(buf)
            local nw = {}
            for i = 32769, wlen do nw[i - 32768] = window[i] end
            window, wlen = nw, wlen - 32768
        end
    end
    local function put_copy(dist, len)
        for _ = 1, len do
            local src = wlen - dist + 1
            if src < 1 then return nil, 'bad distance' end
            put(window[src])
        end
        return true
    end
    local function flush_all()
        if wlen > 0 then
            local buf = {}
            for i = 1, wlen do buf[i] = string.char(window[i]) end
            parts[#parts + 1] = table.concat(buf)
            wlen = 0
        end
        return table.concat(parts)
    end

    local function inflate_codes(lit_map, lit_max, dist_map, dist_max)
        while true do
            local sym, err = decode(lit_map, lit_max)
            if not sym then return nil, err end
            if sym < 256 then
                put(sym)
            elseif sym == 256 then
                return true
            elseif sym <= 285 then
                local li = sym - 257 + 1
                local base, extra = LEN_BASE[li], LEN_EXTRA[li]
                if not base then return nil, 'bad length' end
                local add, e2 = 0, nil
                if extra > 0 then
                    add, e2 = pull(extra)
                    if not add then return nil, e2 end
                end
                local length = base + add
                local ds, e3 = decode(dist_map, dist_max)
                if not ds then return nil, e3 end
                if ds < 0 or ds > 29 then return nil, 'bad dist' end
                local dbase, dextra = DIST_BASE[ds + 1], DIST_EXTRA[ds + 1]
                local dadd, e4 = 0, nil
                if dextra > 0 then
                    dadd, e4 = pull(dextra)
                    if not dadd then return nil, e4 end
                end
                local dist = dbase + dadd
                local ok, e5 = put_copy(dist, length)
                if not ok then return nil, e5 end
            else
                return nil, 'bad lit'
            end
        end
    end

    while true do
        local bfinal, e1 = pull(1)
        if not bfinal then return nil, e1 end
        local btype, e2 = pull(2)
        if not btype then return nil, e2 end
        if btype == 0 then
            -- stored: skip to byte boundary
            acc, bitn = 0, 0
            if pos + 3 > #src then return nil, 'stored truncated' end
            local len = u16(src, pos)
            local nlen = u16(src, pos + 2)
            pos = pos + 4
            if band(len, 0xFFFF) ~= band(bxor(nlen, 0xFFFF), 0xFFFF) then
                return nil, 'stored nlen'
            end
            if pos + len - 1 > #src then return nil, 'stored data' end
            for i = 0, len - 1 do put(src:byte(pos + i)) end
            pos = pos + len
        elseif btype == 1 then
            local ok, err = inflate_codes(fixed_lit, fixed_lit_max, fixed_dist, fixed_dist_max)
            if not ok then return nil, err end
        elseif btype == 2 then
            local hlit, e3 = pull(5)
            local hdist, e4 = pull(5)
            local hclen, e5 = pull(4)
            if not hlit or not hdist or not hclen then return nil, 'dyn header' end
            hlit, hdist, hclen = hlit + 257, hdist + 1, hclen + 4
            local order = { 16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15 }
            local clen = {}
            for i = 1, 19 do clen[i] = 0 end
            for i = 1, hclen do
                local v, ev = pull(3)
                if not v then return nil, ev end
                clen[order[i] + 1] = v
            end
            local all, err = lens_from_clen(order, clen, hlit + hdist)
            if not all then return nil, err end
            local lit_lens, dist_lens = {}, {}
            for i = 1, hlit do lit_lens[i] = all[i] or 0 end
            for i = 1, hdist do dist_lens[i] = all[hlit + i] or 0 end
            local lit_map, lit_max = build_codes(lit_lens)
            local dist_map, dist_max = build_codes(dist_lens)
            local ok, e6 = inflate_codes(lit_map, lit_max, dist_map, dist_max)
            if not ok then return nil, e6 end
        else
            return nil, 'bad btype'
        end
        if bfinal == 1 then break end
    end
    return flush_all()
end

zip.inflate = inflate_raw

---------------------------------------------------------------------------
-- ZIP の読み取りと展開
---------------------------------------------------------------------------

local function find_eocd(data)
    -- コメント最大 65535。末尾から EOCD シグネチャを探す
    local n = #data
    if n < 22 then return nil, 'too small' end
    local min = n - 22 - 65535
    if min < 1 then min = 1 end
    for i = n - 21, min, -1 do
        if u32(data, i) == 0x06054b50 then
            return i
        end
    end
    return nil, 'no eocd'
end

function zip.list(data)
    if type(data) ~= 'string' then return nil, 'no data' end
    local eocd, err = find_eocd(data)
    if not eocd then return nil, err end
    local total = u16(data, eocd + 10)
    local cd_size = u32(data, eocd + 12)
    local cd_off = u32(data, eocd + 16)
    if not total or not cd_off then return nil, 'bad eocd' end
    if cd_off < 0 or cd_off + 46 > #data + 1 then return nil, 'bad cd offset' end
    local entries, p = {}, cd_off + 1
    for _ = 1, total do
        if u32(data, p) ~= 0x02014b50 then return nil, 'bad central' end
        local method = u16(data, p + 10)
        local crc = u32(data, p + 16)
        local csize = u32(data, p + 20)
        local usize = u32(data, p + 24)
        local namelen = u16(data, p + 28)
        local extralen = u16(data, p + 30)
        local commentlen = u16(data, p + 32)
        local local_off = u32(data, p + 42)
        local name = data:sub(p + 46, p + 45 + namelen)
        entries[#entries + 1] = {
            name = name,
            method = method,
            crc = crc,
            csize = csize,
            usize = usize,
            local_off = local_off,
        }
        p = p + 46 + namelen + extralen + commentlen
    end
    return entries
end

local function local_payload(data, ent)
    local p = (ent.local_off or 0) + 1
    if u32(data, p) ~= 0x04034b50 then return nil, 'bad local' end
    local namelen = u16(data, p + 26)
    local extralen = u16(data, p + 28)
    local start = p + 30 + namelen + extralen
    local csize = ent.csize or 0
    if start < 1 or start + csize - 1 > #data then return nil, 'payload range' end
    return data:sub(start, start + csize - 1)
end

function zip.extract(data, dest, opts)
    opts = opts or {}
    if type(data) ~= 'string' then return nil, 'no data' end
    dest = tostring(dest or '')
    if dest == '' then return nil, 'no dest' end
    dest = dest:gsub('[\\/]+$', '')
    local entries, err = zip.list(data)
    if not entries then return nil, err end
    local write = opts.write
    local mkdir = opts.mkdir
    local sep = opts.sep or package.config:sub(1, 1)
    if type(write) ~= 'function' or type(mkdir) ~= 'function' then
        return nil, 'no fs'
    end
    mkdir(dest)
    local written, skipped = {}, {}
    for _, ent in ipairs(entries) do
        local name = ent.name or ''
        if name:sub(-1) == '/' or name:sub(-1) == '\\' then
            local rel = zip.safe_rel(name)
            if rel then mkdir(dest .. sep .. rel:gsub('/', sep)) end
        else
            local rel = zip.safe_rel(name)
            if not rel then
                skipped[#skipped + 1] = name
                if opts.strict ~= false then
                    return nil, 'unsafe path: ' .. tostring(name)
                end
            else
                local payload, e2 = local_payload(data, ent)
                if not payload then return nil, e2 end
                local raw
                if ent.method == 0 then
                    raw = payload
                elseif ent.method == 8 then
                    raw, e2 = inflate_raw(payload)
                    if not raw then return nil, 'deflate: ' .. tostring(e2) end
                else
                    return nil, 'method ' .. tostring(ent.method)
                end
                if ent.usize and ent.usize > 0 and #raw ~= ent.usize then
                    return nil, 'size mismatch: ' .. rel
                end
                local parent = rel:match('^(.*)[/\\][^/\\]+$')
                if parent then mkdir(dest .. sep .. parent:gsub('/', sep)) end
                local ok, e3 = write(dest .. sep .. rel:gsub('/', sep), raw)
                if not ok then return nil, e3 or ('write ' .. rel) end
                written[#written + 1] = rel
            end
        end
    end
    return { files = written, skipped = skipped }
end

function zip.extract_file(path, dest, opts)
    local read = opts and opts.read
    local data, err
    if type(read) == 'function' then
        data, err = read(path)
    else
        local f, e = io.open(path, 'rb')
        if not f then return nil, e end
        data = f:read('*a')
        f:close()
    end
    if not data then return nil, err or 'read zip' end
    return zip.extract(data, dest, opts)
end

-- zip 内の共通の先頭フォルダ（astertrail/ など）を外したルート
function zip.strip_root(files)
    if type(files) ~= 'table' or #files == 0 then return files, nil end
    local first = files[1]:match('^([^/]+)/')
    if not first then return files, nil end
    for _, n in ipairs(files) do
        if not n:find('^' .. first .. '/', 1) and n ~= first then
            return files, nil
        end
    end
    local out = {}
    for _, n in ipairs(files) do
        if n ~= first then
            out[#out + 1] = n:sub(#first + 2)
        end
    end
    return out, first
end

return zip
