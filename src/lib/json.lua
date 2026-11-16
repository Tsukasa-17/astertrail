--[[
  Astertrail - 最小限の JSON 読み書き（自作）
  - UTF-8 の文字列はそのまま通す。\uXXXX（サロゲートペア含む）は UTF-8 に戻す。
  - 配列は decode 時に印（メタテーブル）を付け、空でも [] で書き戻す。
  - null は読むと nil（キーが無いのと同じ）。書く時は json.null を置けば null になる。
  - encode は キーを並べ替え、2 スペースで字下げする（差分が読みやすいように）。
  Lua 5.1 / LuaJIT 向け。外部の部品は使っていない。
]]

local json = {}

local ARRAY_MT = { __jsontype = 'array' }
local OBJECT_MT = { __jsontype = 'object' }

json.null = setmetatable({}, { __tostring = function () return 'null' end, __jsontype = 'null' })

-- 空でも配列として書きたい表を作る
function json.array(t)
    return setmetatable(t or {}, ARRAY_MT)
end

-- 空でもオブジェクトとして書きたい表を作る
function json.object(t)
    return setmetatable(t or {}, OBJECT_MT)
end

function json.is_array(t)
    if type(t) ~= 'table' then return false end
    local mt = getmetatable(t)
    if mt and mt.__jsontype == 'array' then return true end
    if mt and mt.__jsontype == 'object' then return false end
    local n = 0
    for k, _ in pairs(t) do
        if type(k) ~= 'number' or k < 1 or math.floor(k) ~= k then return false end
        n = n + 1
    end
    if n == 0 then return false end
    for i = 1, n do
        if t[i] == nil then return false end
    end
    return true
end

---------------------------------------------------------------------------
-- encode
---------------------------------------------------------------------------

local escapes = {
    ['"'] = '\\"', ['\\'] = '\\\\', ['\b'] = '\\b', ['\f'] = '\\f',
    ['\n'] = '\\n', ['\r'] = '\\r', ['\t'] = '\\t',
}

local function encode_string(s)
    return '"' .. s:gsub('[%c"\\]', function (c)
        local e = escapes[c]
        if e then return e end
        return string.format('\\u%04x', c:byte())
    end) .. '"'
end

local function encode_number(n)
    if n ~= n or n == math.huge or n == -math.huge then
        error('json: NaN や無限大は書けません')
    end
    if math.floor(n) == n and math.abs(n) < 2^53 then
        return string.format('%d', n)
    end
    local s = string.format('%.14g', n)
    if tonumber(s) ~= n then s = string.format('%.17g', n) end
    return s
end

local function sorted_keys(t)
    local keys = {}
    for k, _ in pairs(t) do
        if type(k) ~= 'string' and type(k) ~= 'number' then
            error('json: 文字列か数値以外のキーは書けません')
        end
        keys[#keys + 1] = k
    end
    table.sort(keys, function (a, b)
        local ta, tb = type(a), type(b)
        if ta ~= tb then return ta == 'number' end
        return a < b
    end)
    return keys
end

local function encode_value(v, indent, depth, seen, compact)
    local tv = type(v)
    if v == nil or v == json.null then return 'null' end
    if tv == 'boolean' then return v and 'true' or 'false' end
    if tv == 'number' then return encode_number(v) end
    if tv == 'string' then return encode_string(v) end
    if tv ~= 'table' then error('json: ' .. tv .. ' は書けません') end
    if seen[v] then error('json: 自分を含む表は書けません') end
    seen[v] = true

    local nl, pad, pad_in, sep
    if compact then
        nl, pad, pad_in, sep = '', '', '', ':'
    else
        nl = '\n'
        pad = string.rep(indent, depth)
        pad_in = string.rep(indent, depth + 1)
        sep = ': '
    end

    local out
    if json.is_array(v) then
        local n = #v
        if n == 0 then
            out = '[]'
        else
            local parts = {}
            for i = 1, n do
                parts[i] = pad_in .. encode_value(v[i], indent, depth + 1, seen, compact)
            end
            out = '[' .. nl .. table.concat(parts, ',' .. nl) .. nl .. pad .. ']'
        end
    else
        local keys = sorted_keys(v)
        if #keys == 0 then
            out = '{}'
        else
            local parts = {}
            for i, k in ipairs(keys) do
                parts[i] = pad_in .. encode_string(tostring(k)) .. sep ..
                    encode_value(v[k], indent, depth + 1, seen, compact)
            end
            out = '{' .. nl .. table.concat(parts, ',' .. nl) .. nl .. pad .. '}'
        end
    end
    seen[v] = nil
    return out
end

-- 値を JSON 文字列にする。失敗時は nil, 理由
function json.encode(value, compact)
    local ok, res = pcall(encode_value, value, '  ', 0, {}, compact)
    if not ok then return nil, tostring(res) end
    if not compact then res = res .. '\n' end
    return res
end

---------------------------------------------------------------------------
-- decode
---------------------------------------------------------------------------

local function utf8_char(cp)
    if cp < 0x80 then
        return string.char(cp)
    elseif cp < 0x800 then
        return string.char(0xC0 + math.floor(cp / 0x40), 0x80 + cp % 0x40)
    elseif cp < 0x10000 then
        return string.char(0xE0 + math.floor(cp / 0x1000),
            0x80 + math.floor(cp / 0x40) % 0x40, 0x80 + cp % 0x40)
    else
        return string.char(0xF0 + math.floor(cp / 0x40000),
            0x80 + math.floor(cp / 0x1000) % 0x40,
            0x80 + math.floor(cp / 0x40) % 0x40, 0x80 + cp % 0x40)
    end
end

local Parser = {}
Parser.__index = Parser

local function where(self)
    local line = 1
    local last = 1
    for i = 1, self.pos - 1 do
        if self.s:byte(i) == 10 then line = line + 1; last = i + 1 end
    end
    return string.format('%d行目 %d文字目', line, self.pos - last + 1)
end

function Parser:fail(msg)
    error({ json_error = msg .. '（' .. where(self) .. '）' }, 0)
end

function Parser:skip()
    local s, p = self.s, self.pos
    while true do
        local c = s:byte(p)
        if c == 32 or c == 9 or c == 10 or c == 13 then
            p = p + 1
        else
            break
        end
    end
    self.pos = p
end

function Parser:peek()
    self:skip()
    return self.s:sub(self.pos, self.pos)
end

function Parser:string()
    local s = self.s
    local p = self.pos + 1
    local buf = {}
    while true do
        local c = s:sub(p, p)
        if c == '' then self.pos = p; self:fail('文字列が閉じていません') end
        if c == '"' then break end
        if c == '\\' then
            local e = s:sub(p + 1, p + 1)
            if e == 'u' then
                local hex = s:sub(p + 2, p + 5)
                if not hex:match('^%x%x%x%x$') then self.pos = p; self:fail('\\u の後が16進4桁ではありません') end
                local cp = tonumber(hex, 16)
                p = p + 6
                if cp >= 0xD800 and cp <= 0xDBFF then
                    local hex2 = s:match('^\\u(%x%x%x%x)', p)
                    local lo = hex2 and tonumber(hex2, 16)
                    if lo and lo >= 0xDC00 and lo <= 0xDFFF then
                        cp = 0x10000 + (cp - 0xD800) * 0x400 + (lo - 0xDC00)
                        p = p + 6
                    end
                end
                buf[#buf + 1] = utf8_char(cp)
            else
                local map = { ['"'] = '"', ['\\'] = '\\', ['/'] = '/', b = '\b', f = '\f', n = '\n', r = '\r', t = '\t' }
                local r = map[e]
                if not r then self.pos = p; self:fail('不明なエスケープ \\' .. e) end
                buf[#buf + 1] = r
                p = p + 2
            end
        else
            -- 区切り文字かエスケープまでをまとめて取る
            local q = s:find('["\\]', p)
            if not q then self.pos = p; self:fail('文字列が閉じていません') end
            local chunk = s:sub(p, q - 1)
            if chunk:find('[%z\1-\31]') then self.pos = p; self:fail('文字列の中に制御文字があります') end
            buf[#buf + 1] = chunk
            p = q
        end
    end
    self.pos = p + 1
    return table.concat(buf)
end

function Parser:number()
    local s = self.s
    local num = s:match('^-?%d+%.?%d*[eE]?[-+]?%d*', self.pos)
    if not num or num == '' or num == '-' then self:fail('数値が読めません') end
    local n = tonumber(num)
    if not n then self:fail('数値が読めません') end
    self.pos = self.pos + #num
    return n
end

function Parser:value(depth)
    if depth > 200 then self:fail('入れ子が深すぎます') end
    local c = self:peek()
    if c == '{' then
        self.pos = self.pos + 1
        local obj = setmetatable({}, OBJECT_MT)
        if self:peek() == '}' then self.pos = self.pos + 1; return obj end
        while true do
            if self:peek() ~= '"' then self:fail('キーは文字列でなければいけません') end
            local k = self:string()
            if self:peek() ~= ':' then self:fail('":" がありません') end
            self.pos = self.pos + 1
            obj[k] = self:value(depth + 1)
            local d = self:peek()
            self.pos = self.pos + 1
            if d == '}' then break end
            if d ~= ',' then self.pos = self.pos - 1; self:fail('"," か "}" がありません') end
        end
        return obj
    elseif c == '[' then
        self.pos = self.pos + 1
        local arr = setmetatable({}, ARRAY_MT)
        if self:peek() == ']' then self.pos = self.pos + 1; return arr end
        local n = 0
        while true do
            n = n + 1
            arr[n] = self:value(depth + 1)
            local d = self:peek()
            self.pos = self.pos + 1
            if d == ']' then break end
            if d ~= ',' then self.pos = self.pos - 1; self:fail('"," か "]" がありません') end
        end
        return arr
    elseif c == '"' then
        return self:string()
    elseif c == '-' or c:match('%d') then
        return self:number()
    elseif self.s:sub(self.pos, self.pos + 3) == 'true' then
        self.pos = self.pos + 4; return true
    elseif self.s:sub(self.pos, self.pos + 4) == 'false' then
        self.pos = self.pos + 5; return false
    elseif self.s:sub(self.pos, self.pos + 3) == 'null' then
        self.pos = self.pos + 4; return nil
    elseif c == '' then
        self:fail('途中で終わっています')
    end
    self:fail('読めない文字 "' .. c .. '"')
end

-- JSON 文字列を値にする。失敗時は nil, 理由
function json.decode(text)
    if type(text) ~= 'string' then return nil, '文字列ではありません' end
    -- UTF-8 BOM を読み飛ばす
    if text:sub(1, 3) == '\239\187\191' then text = text:sub(4) end
    local p = setmetatable({ s = text, pos = 1 }, Parser)
    local ok, res = pcall(function ()
        local v = p:value(0)
        p:skip()
        if p.pos <= #p.s then p:fail('余分な文字があります') end
        return v
    end)
    if not ok then
        if type(res) == 'table' and res.json_error then return nil, res.json_error end
        return nil, tostring(res)
    end
    return res
end

-- json.null を nil として扱う小さな補助
function json.val(v)
    if v == json.null then return nil end
    return v
end

return json
