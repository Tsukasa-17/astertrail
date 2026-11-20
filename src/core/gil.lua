--[[
  Astertrail - ギルは通貨でありアイテムではない（0.1.270〜）
  資料の needs に kind=item / name_ja=ギル と書いてあることや、
  名前表の「ギル」→ 65535（かばんの空き／ギル欄の番兵）があっても、
  所持数・番号の照合・ツールチップは付けない。
  文中の「5ギル」「100ギル」のような金額の左に、小さなコインを出す（0.1.272〜）。
  「ギルド」など、後ろにカタカナが続く語には合わせない。
]]

local M = {}

M.WORD = 'ギル'
-- かばんの空き／ギル欄。アイテム番号として使わない
M.SENTINEL_ID = 65535

local UNITS = { ['万'] = true, ['億'] = true, ['兆'] = true }

local function utf8_len_at(s, i)
    local b = s:byte(i)
    if not b then return 0 end
    if b < 0x80 then return 1 end
    if b < 0xE0 then return 2 end
    if b < 0xF0 then return 3 end
    return 4
end

local function utf8_prev(s, i)
    -- i は次の文字の開始位置。直前の文字の開始を返す
    if i <= 1 then return nil end
    local j = i - 1
    while j > 1 and s:byte(j) >= 0x80 and s:byte(j) < 0xC0 do
        j = j - 1
    end
    return j
end

local function utf8_char(s, i)
    local n = utf8_len_at(s, i)
    if n == 0 then return nil end
    return s:sub(i, i + n - 1), n
end

-- カタカナ（長音・中黒・小書き・拡張を含む）
function M.is_katakana(ch)
    if type(ch) ~= 'string' or ch == '' then return false end
    local a, b, c = ch:byte(1, 3)
    if not a then return false end
    -- U+30A0..U+30FF
    if a == 0xE3 and b == 0x82 and c and c >= 0xA0 then return true end
    if a == 0xE3 and b == 0x83 and c and c <= 0xBF then return true end
    -- U+31F0..U+31FF
    if a == 0xE3 and b == 0x87 and c and c >= 0xB0 then return true end
    return false
end

local function is_ascii_digit(b)
    return b and b >= 48 and b <= 57
end

local function is_fullwidth_digit(ch)
    if type(ch) ~= 'string' or #ch ~= 3 then return false end
    local a, b, c = ch:byte(1, 3)
    -- U+FF10..U+FF19 = EF BC 90 .. EF BC 99
    return a == 0xEF and b == 0xBC and c and c >= 0x90 and c <= 0x99
end

local function is_comma(ch)
    return ch == ',' or ch == '，' or ch == '、'
end

local function is_digit_char(ch)
    if type(ch) ~= 'string' or ch == '' then return false end
    if #ch == 1 and is_ascii_digit(ch:byte(1)) then return true end
    return is_fullwidth_digit(ch)
end

function M.is_gil_name(s)
    if type(s) ~= 'string' or s == '' then return false end
    if s == M.WORD then return true end
    local low = s:lower()
    if low == 'gil' then return true end
    -- 「5ギル」「2,000ギル」「10万ギル」そのもの
    if M.amount_at(s, 1) == 1 and select(2, M.amount_at(s, 1)) == #s then
        return true
    end
    return false
end

function M.is_gil_id(id)
    id = tonumber(id)
    return id == M.SENTINEL_ID
end

function M.is_gil_need(n)
    if type(n) ~= 'table' then return false end
    if n.kind == 'gil' then return true end
    if M.is_gil_id(n.item_id) then return true end
    if type(n.item_ids) == 'table' then
        for _, id in ipairs(n.item_ids) do
            if M.is_gil_id(id) then return true end
        end
    end
    return M.is_gil_name(n.name_ja) or M.is_gil_name(n.name_en)
end

-- 名前表や needs の番号として、ギル／番兵を品にしない
function M.should_skip_item_lookup(name, id)
    if M.is_gil_id(id) then return true end
    if M.is_gil_name(name) then return true end
    return false
end

-- text の pos 以降で、左端の金額「…ギル」を探す。
-- 戻り値: 開始位置, 終了位置（両方ともバイト。終了は inclusive）。無ければ nil。
function M.find_amount(text, pos)
    if type(text) ~= 'string' or text == '' then return nil end
    pos = math.max(1, tonumber(pos) or 1)
    local i = pos
    local n = #text
    local word = M.WORD
    local wlen = #word
    while i <= n do
        local s, e = text:find(word, i, true)
        if not s then return nil end
        local nxt, nxtn = utf8_char(text, e + 1)
        if nxt and M.is_katakana(nxt) then
            i = e + 1
        else
            local start = M._amount_start(text, s)
            if start then
                return start, e
            end
            i = e + 1
        end
    end
    return nil
end

-- 別名（CT.spans から）
M.amount_at = function (text, pos)
    -- pos ちょうどから始まる金額ならその開始・終了。違えば find と同じく先を探すわけではなく、
    -- ここは「この文字列全体が金額か」の判定にも使う。
    local s, e = M.find_amount(text, pos)
    if s == pos then return s, e end
    return nil
end

function M._amount_start(text, gil_s)
    -- ギルの直前を見る
    local i = gil_s
    local prev_i = utf8_prev(text, i)
    if not prev_i then return nil end
    local ch = utf8_char(text, prev_i)
    -- 任意の 万/億/兆
    if UNITS[ch] then
        i = prev_i
        prev_i = utf8_prev(text, i)
        if not prev_i then return nil end
        ch = utf8_char(text, prev_i)
    end
    -- 直前は数字でなければならない（カンマだけの「,ギル」は不可）
    if not is_digit_char(ch) then return nil end
    local start = prev_i
    local p = prev_i
    while p do
        local q = utf8_prev(text, p)
        if not q then break end
        local qc = utf8_char(text, q)
        if is_digit_char(qc) or is_comma(qc) then
            start = q
            p = q
        else
            break
        end
    end
    -- 先頭がカンマだけにならないよう、少なくとも1桁あることは上で保証
    return start
end

return M
