-- Astertrail - 小さな共通の補助（ゲームの API は使わない）

local util = {}

function util.deep_copy(v, seen)
    if type(v) ~= 'table' then return v end
    seen = seen or {}
    if seen[v] then return seen[v] end
    local t = {}
    seen[v] = t
    for k, x in pairs(v) do t[util.deep_copy(k, seen)] = util.deep_copy(x, seen) end
    return setmetatable(t, getmetatable(v))
end

-- defaults を土台に、loaded の値で上書きした新しい表を返す。
-- 型が違う値は defaults を使う（壊れた設定で落ちないように）。
function util.merge_defaults(defaults, loaded)
    if type(loaded) ~= 'table' then return util.deep_copy(defaults) end
    local out = util.deep_copy(defaults)
    for k, dv in pairs(defaults) do
        local lv = loaded[k]
        if lv ~= nil then
            if type(dv) == 'table' and type(lv) == 'table' then
                local mt = getmetatable(dv)
                if mt and mt.__jsontype == 'array' then
                    out[k] = util.deep_copy(lv)
                    setmetatable(out[k], mt)
                elseif next(dv) == nil then
                    out[k] = util.deep_copy(lv)
                else
                    out[k] = util.merge_defaults(dv, lv)
                end
            elseif dv == nil or type(dv) == type(lv) then
                out[k] = lv
            end
        end
    end
    -- defaults に無いキー（予約・将来の項目）も消さずに残す
    for k, lv in pairs(loaded) do
        if defaults[k] == nil then out[k] = util.deep_copy(lv) end
    end
    return out
end

function util.trim(s)
    return (tostring(s or ''):gsub('^%s+', ''):gsub('%s+$', ''))
end

-- ASCII だけ小文字にする（日本語はそのまま）
function util.lower(s)
    return (tostring(s or ''):gsub('%u', string.lower))
end

-- 大文字小文字を区別しない部分一致（plain）
function util.icontains(hay, needle)
    if needle == nil or needle == '' then return true end
    if hay == nil then return false end
    return util.lower(hay):find(util.lower(needle), 1, true) ~= nil
end

function util.split_words(s)
    local t = {}
    for w in tostring(s or ''):gmatch('%S+') do t[#t + 1] = w end
    return t
end

-- フォルダ名に使えない文字を _ に置き換える
function util.safe_name(s)
    s = tostring(s or '')
    s = s:gsub('[<>:"/\\|%?%*%c]', '_')
    s = s:gsub('[%. ]+$', '')
    if s == '' then s = '_' end
    return s
end

-- 時差（秒）を求める
local function tz_offset(t)
    local utc = os.date('!*t', t)
    local loc = os.date('*t', t)
    utc.isdst = loc.isdst
    return os.difftime(os.time(loc), os.time(utc))
end

-- 2026-11-12T14:00:00+09:00 の形
function util.iso_time(t)
    t = t or os.time()
    local off = tz_offset(t)
    local sign = off >= 0 and '+' or '-'
    off = math.abs(off)
    return os.date('%Y-%m-%dT%H:%M:%S', t) .. string.format('%s%02d:%02d', sign, math.floor(off / 3600), math.floor(off % 3600 / 60))
end

-- ファイル名用 20261112-140000
function util.stamp(t)
    return os.date('%Y%m%d-%H%M%S', t or os.time())
end

function util.day(t)
    return os.date('%Y%m%d', t or os.time())
end

-- UTF-8 を文字数で切る（表示用）
function util.utf8_cut(s, max_chars)
    s = tostring(s or '')
    local count, i, n = 0, 1, #s
    while i <= n do
        count = count + 1
        if count > max_chars then
            return s:sub(1, i - 1) .. '…'
        end
        local c = s:byte(i)
        if c < 0x80 then i = i + 1
        elseif c < 0xE0 then i = i + 2
        elseif c < 0xF0 then i = i + 3
        else i = i + 4 end
    end
    return s
end

function util.clamp(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

function util.contains(list, v)
    for _, x in ipairs(list or {}) do if x == v then return true end end
    return false
end

function util.count(t)
    local n = 0
    for _ in pairs(t or {}) do n = n + 1 end
    return n
end

return util
