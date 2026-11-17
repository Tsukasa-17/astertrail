--[[
  Astertrail - エミネンス・レコード（0.1.172〜、t243）
  - 名前・目標の数・くり返せるか・分類は、手元のクライアントの DAT から読み込みのたびに読む（同梱しない）。
    ja：ROM 307/15（レコード）・307/23（分類）＝ファイル番号 55552・55553。en：55672・55673。
    1件の箱は 0xC00 バイト（新しい版は 0x1400）。どのバイトも右へ 5 ビット回して戻す。
    レコード：id・日付・くり返し・目標の数・報酬 4 つ（古い版は 3 つ）の後に文字の表（名前・説明）。
    分類：id・子の数・子 28 個（子の id、印）・文字の表（名前）。子の印の上の 8 ビットが 4 なら、下の 24 ビットがエリアの番号
    （2026-11-16、GAME-PC の DAT で確かめた。「採集：東ロンフォール」の印の下が 101 など）。
  - 受けているもの：0x111（u32 が 64 個。下 12 ビットが番号、上 20 ビットが進み。1〜30 番目と、64 番目が時限のもの）。
    達成：0x112（128 バイトの 4 つ。番号 n はバイト n/8 のビット n%8。最後の u16 が何番目か）。
    ゲームは同じ形を FFXiMain.dll の中に写している（platform が読む）。
  - 受ける・外すの通信（LSB の packets/c2s/0x10c_roe_start.h・0x10d_roe_remove.h を読んで確かめた形）：
    0x10C／0x10D、8 バイト（頭 4 ＋ 番号 u16 ＋ 0 の u16）。送るのは押したときに 1 回だけ（ここは形を作るだけ）。
  - 番号が分からないもの・DAT に無いものは空のまま（推測しない）。
]]

local roe = {}

roe.MAX_ACTIVE = 30          -- ふつうに受けられる数
roe.TIMED_INDEX = 64         -- 0x111 の 64 番目（1 から数えて）が時限のもの
roe.PKT_START = 0x10C
roe.PKT_REMOVE = 0x10D
roe.PKT_ACTIVE = 0x111
roe.PKT_LOG = 0x112
roe.PKT_MESSAGE = 0x029
roe.MSG_START = 704          -- 受けた（0x029 の文の番号。数 1 が番号）
roe.MSG_UNABLE = 742         -- 今は受けられない
roe.DAT_IDS = {
    ja = { quest = 55552, category = 55553 },
    en = { quest = 55672, category = 55673 },
}
roe.ZONE_FLAG = 4            -- 分類の子の印の上の 8 ビットがこれならエリア

-- 右へ 5 ビット回す（1 バイト）
local DEC = {}
for b = 0, 255 do DEC[b] = math.floor(b / 32) + (b % 32) * 8 end
roe._DEC = DEC

local function dec_byte(raw, pos)
    local b = raw:byte(pos)
    if not b then return nil end
    return DEC[b]
end

local function dec_u32(raw, pos)
    local a, b, c, d = raw:byte(pos, pos + 3)
    if not d then return nil end
    return DEC[a] + DEC[b] * 256 + DEC[c] * 65536 + DEC[d] * 16777216
end

local function dec_i32(raw, pos)
    local v = dec_u32(raw, pos)
    if v and v >= 2147483648 then v = v - 4294967296 end
    return v
end

-- 戻した文字列（i〜j、1 から数えて）
local function dec_str(raw, i, j)
    local out = {}
    local n = 0
    for p = i, j, 256 do
        local q = math.min(j, p + 255)
        local t = { raw:byte(p, q) }
        for k = 1, #t do t[k] = DEC[t[k]] end
        n = n + 1
        out[n] = string.char(unpack(t))
    end
    return table.concat(out)
end
roe._dec_str = dec_str

-- 文字の表（数 n、n 個の {位置, 種類}、本体）。base は表の始まり（1 から数えて）、limit はその箱の終わり
-- 戻り値: 中身の表（文字は Shift-JIS のまま、数は数）。崩れていれば nil
local function read_cells(raw, base, limit, want)
    local n = dec_i32(raw, base)
    if not n or n < 1 or n > 32 or base + 4 + n * 8 > limit then return nil end
    local out = {}
    for i = 1, math.min(n, want or n) do
        local off = dec_i32(raw, base + 4 + (i - 1) * 8)
        local typ = dec_i32(raw, base + 8 + (i - 1) * 8)
        if not off or off < 4 + n * 8 or base + off >= limit then return nil end
        local p = base + off
        if typ == 1 then
            out[i] = dec_i32(raw, p)
        elseif typ == 0 then
            -- 28 バイトの頭（1 と 0 が 6 つ）の後に、0 で終わる文字。0 は回しても 0 なので、そのまま探せる
            if dec_i32(raw, p) ~= 1 then return nil end
            local s = p + 28
            local e = raw:find('\0', s, true)
            if not e or e > limit then return nil end
            out[i] = (e > s) and dec_str(raw, s, e - 1) or ''
        else
            return nil
        end
    end
    return out
end
roe._read_cells = read_cells

-- 箱の大きさ：大きさが割り切れて、最初の箱の最後が 0xFF のもの
function roe.slot_size(raw)
    local len = #raw
    for _, s in ipairs({ 0x1400, 0xC00 }) do
        if len >= s and len % s == 0 and raw:byte(s) == 0xFF then return s end
    end
    return nil
end

local function placeholder(name)
    return name == nil or name == '' or name == '.'
end

-- レコードの DAT。conv(sjis) → UTF-8（無ければそのまま）。lang 'ja' / 'en'
-- 戻り値: { [id] = { id, name, desc, target, repeatable, date, rewards = { emi, exp, cap, uni } } }, 数, 理由
-- 説明の中の「特別報酬」の行を分ける（0.1.177〜）。ja は「　特別報酬:…」、en は「Special reward: …」。
-- すぐ後の字下げした括弧の行（「　(複数所持することはできません)」）は特別報酬の続き。
-- 戻り値: 特別報酬を除いた説明（後ろの空行も除く）, 特別報酬の文字（無ければ nil）
local SPECIAL_PATS = { '^[%s\227\128\128]*特別報酬%s*:%s*(.*)$', '^[%s\227\128\128]*特別報酬%s*：%s*(.*)$',
    '^%s*[Ss]pecial [Rr]eward%s*:%s*(.*)$' }
local function lstrip(s)
    while true do
        local n = s:gsub('^%s+', ''):gsub('^\227\128\128', '')
        if n == s then return s end
        s = n
    end
end
function roe.split_special(desc)
    if type(desc) ~= 'string' or desc == '' then return desc, nil end
    local body, special = {}, {}
    local in_special = false
    for line in (desc .. '\n'):gmatch('([^\n]*)\n') do
        local v
        for _, pat in ipairs(SPECIAL_PATS) do
            v = line:match(pat)
            if v then break end
        end
        if v then
            special[#special + 1] = v
            in_special = true
        elseif in_special and line:match('^[%s\227]') and (lstrip(line):sub(1, 1) == '(' or lstrip(line):sub(1, 3) == '（') then
            special[#special + 1] = lstrip(line)
        else
            in_special = false
            body[#body + 1] = line
        end
    end
    if #special == 0 then return desc, nil end
    while #body > 0 and lstrip(body[#body]) == '' do body[#body] = nil end
    local text = table.concat(special, '\n')
    if lstrip(text) == '' then text = nil end
    return table.concat(body, '\n'), text
end

function roe.parse_quests(raw, conv, lang)
    if type(raw) ~= 'string' then return nil, 0, 'no_file' end
    local S = roe.slot_size(raw)
    if not S then return nil, 0, 'bad_size' end
    conv = conv or function (s) return s end
    local out, count = {}, 0
    local text_off
    for slot = 0, #raw / S - 1 do
        local b = slot * S + 1
        local limit = b + S - 1
        local rid = dec_u32(raw, b)
        -- 文字の表の位置（報酬が 4 つなら 32、古い版の 3 つなら 28）。最初に読めたほうに決める
        local cells
        if text_off then
            cells = read_cells(raw, b + text_off, limit, 5)
        else
            for _, off in ipairs({ 32, 28 }) do
                cells = read_cells(raw, b + off, limit, 5)
                if cells and type(cells[1]) == 'string' then text_off = off; break end
                cells = nil
            end
        end
        local id = rid and rid % 4096
        local name = cells and cells[1]
        if id and id > 0 and type(name) == 'string' and not placeholder(name) then
            -- 説明：ja は 2 つ目、en は 5 つ目（en は 1 が数、3 つ目が長い名前）
            local desc = cells[(#cells >= 5 and lang ~= 'ja') and 5 or 2]
            if type(desc) ~= 'string' then desc = nil end
            local q = {
                id = id,
                name = conv(name),
                desc = desc and desc ~= '' and conv(desc) or nil,
                date = dec_u32(raw, b + 4),
                repeatable = dec_u32(raw, b + 8) == 1,
                target = dec_u32(raw, b + 12),
                rewards = { emi = dec_u32(raw, b + 16), exp = dec_u32(raw, b + 20), cap = dec_u32(raw, b + 24),
                    uni = (text_off == 32) and dec_u32(raw, b + 28) or nil },
            }
            if q.target == 0 then q.target = nil end
            q.body, q.special = roe.split_special(q.desc)
            if not out[id] then count = count + 1 end
            out[id] = q
        end
    end
    if count == 0 then return nil, 0, 'empty' end
    return out, count
end

-- 分類の DAT。戻り値: { [cid] = { id, name, children = { { kind = 'cat'|'obj', id, flag, zone } } } }, 数, 理由
function roe.parse_categories(raw, conv)
    if type(raw) ~= 'string' then return nil, 0, 'no_file' end
    local S = roe.slot_size(raw)
    if not S then return nil, 0, 'bad_size' end
    conv = conv or function (s) return s end
    local out, count = {}, 0
    for slot = 0, #raw / S - 1 do
        local b = slot * S + 1
        local limit = b + S - 1
        local cid = dec_u32(raw, b)
        local n = dec_u32(raw, b + 4) or 0
        local cells = read_cells(raw, b + 568, limit, 1)
        local name = cells and cells[1]
        if cid and type(name) == 'string' and not placeholder(name) and n <= 28 then
            local ch = {}
            for i = 1, n do
                local p = b + 8 + (i - 1) * 20
                local child, flag = dec_u32(raw, p), dec_u32(raw, p + 4)
                if child and child > 0 then
                    local e = { id = child, flag = flag or 0 }
                    if child >= 0xF000 then
                        e.kind = 'cat'
                    else
                        e.kind = 'obj'
                        e.id = child % 4096
                        if math.floor((flag or 0) / 16777216) == roe.ZONE_FLAG then e.zone = (flag or 0) % 16777216 end
                    end
                    ch[#ch + 1] = e
                end
            end
            out[cid] = { id = cid, name = conv(name), children = ch }
            count = count + 1
        end
    end
    if count == 0 then return nil, 0, 'empty' end
    return out, count
end

-- 二つをまとめる。戻り値: db
-- db.quests[id]、db.cats[cid]、db.roots（上の分類、id の順）、db.zones[id] = { [zone] = true }、db.cat_of[id] = 最初に出てくる分類
function roe.build(quests, cats)
    local db = { quests = quests or {}, cats = cats or {}, roots = {}, zones = {}, cat_of = {}, loose = {} }
    local is_child = {}
    for _, c in pairs(db.cats) do
        for _, e in ipairs(c.children) do
            if e.kind == 'cat' then is_child[e.id] = true end
        end
    end
    for cid in pairs(db.cats) do
        if not is_child[cid] then db.roots[#db.roots + 1] = cid end
    end
    table.sort(db.roots)
    -- 上から順に見て、レコードの分類とエリアを覚える
    local seen = {}
    local function walk(cid, depth)
        if seen[cid] or depth > 6 then return end
        seen[cid] = true
        local c = db.cats[cid]
        if not c then return end
        for _, e in ipairs(c.children) do
            if e.kind == 'cat' then
                walk(e.id, depth + 1)
            else
                if not db.cat_of[e.id] then db.cat_of[e.id] = cid end
                if e.zone then
                    db.zones[e.id] = db.zones[e.id] or {}
                    db.zones[e.id][e.zone] = true
                end
            end
        end
    end
    for _, r in ipairs(db.roots) do walk(r, 0) end
    -- どの分類にも出てこないレコード
    for id in pairs(db.quests) do
        if not db.cat_of[id] then db.loose[#db.loose + 1] = id end
    end
    table.sort(db.loose)
    db.count = 0
    for _ in pairs(db.quests) do db.count = db.count + 1 end
    return db
end

-- 分類の中の、表示するレコードの番号（その分類の直下だけ、DAT の並び）
function roe.objectives_in(db, cid)
    local out = {}
    local c = db and db.cats[cid]
    if not c then return out end
    for _, e in ipairs(c.children) do
        if e.kind == 'obj' and db.quests[e.id] then out[#out + 1] = e.id end
    end
    return out
end

-- 分類の直下の分類
function roe.subcats(db, cid)
    local out = {}
    local c = db and db.cats[cid]
    if not c then return out end
    for _, e in ipairs(c.children) do
        if e.kind == 'cat' and db.cats[e.id] then out[#out + 1] = e.id end
    end
    return out
end

---------------------------------------------------------------------------
-- 受けているもの・達成
---------------------------------------------------------------------------

local function u32_at(s, pos)
    local a, b, c, d = s:byte(pos, pos + 3)
    if not d then return nil end
    return a + b * 256 + c * 65536 + d * 16777216
end

local function u16_at(s, pos)
    local a, b = s:byte(pos, pos + 1)
    if not b then return nil end
    return a + b * 256
end

-- u32 の 64 個 → 受けているもの { { id, progress, timed } }（空きは飛ばす。並びはゲームのまま）
function roe.active_from_words(words)
    local out = {}
    for i = 1, 64 do
        local w = tonumber(words[i]) or 0
        local id = w % 4096
        if id > 0 and (i <= roe.MAX_ACTIVE or i == roe.TIMED_INDEX) then
            out[#out + 1] = { id = id, progress = math.floor(w / 4096), timed = (i == roe.TIMED_INDEX) or nil }
        end
    end
    return out
end

-- 届いた 0x111（頭 4 バイトから）。戻り値: 受けているもの、または nil
function roe.parse_active(data)
    if type(data) ~= 'string' or #data < 4 + 64 * 4 then return nil end
    if (data:byte(1) + (data:byte(2) % 2) * 256) ~= roe.PKT_ACTIVE then return nil end
    local words = {}
    for i = 1, 64 do words[i] = u32_at(data, 5 + (i - 1) * 4) end
    return roe.active_from_words(words)
end

-- 届いた 0x112。戻り値: 何番目（0〜3）, 128 バイトの表（数 128 個）
function roe.parse_log(data)
    if type(data) ~= 'string' or #data < 4 + 128 + 2 then return nil end
    if (data:byte(1) + (data:byte(2) % 2) * 256) ~= roe.PKT_LOG then return nil end
    local part = u16_at(data, 5 + 128)
    if not part or part > 3 then return nil end
    return part, { data:byte(5, 4 + 128) }
end

-- 届いた 0x029 のうち、受けた・受けられないだけ。戻り値: 'start'|'unable', 数 1
function roe.parse_message(data)
    if type(data) ~= 'string' or #data < 0x1C then return nil end
    if (data:byte(1) + (data:byte(2) % 2) * 256) ~= roe.PKT_MESSAGE then return nil end
    local msg = (u16_at(data, 0x19) or 0) % 32768
    local p1 = u32_at(data, 0x0D)
    if msg == roe.MSG_START then return 'start', p1 end
    if msg == roe.MSG_UNABLE then return 'unable', p1 end
    return nil
end

-- チャットの行（UTF-8 か英語のまま）：「The record #3055 is not implemented at this time.」
function roe.not_implemented_id(text)
    if type(text) ~= 'string' then return nil end
    local n = text:match('[Rr]ecord #(%d+) is not implemented')
    n = tonumber(n)
    if n and n >= 1 and n <= 4095 then return n end
    return nil
end

-- 達成の表（512 バイト、0 から数えた番号）
function roe.new_complete() local t = {}; for i = 1, 512 do t[i] = 0 end; return t end

function roe.apply_log(complete, part, bytes)
    for i = 1, 128 do complete[part * 128 + i] = bytes[i] or 0 end
end

function roe.is_complete(complete, id)
    if not complete or not id or id < 0 or id > 4095 then return nil end
    local b = complete[math.floor(id / 8) + 1]
    if b == nil then return nil end
    return math.floor(b / 2 ^ (id % 8)) % 2 == 1
end

---------------------------------------------------------------------------
-- 送る形（作るだけ。送るのは platform）
---------------------------------------------------------------------------

-- op 'start' / 'remove'。戻り値: 通信の番号, 中身（頭 4 バイトを含む 8 バイト。頭は VanaCore が入れる）
function roe.build_packet(op, id)
    id = tonumber(id)
    if not id or id ~= math.floor(id) or id < 1 or id > 4095 then return nil, 'bad_id' end
    local pid = (op == 'start' and roe.PKT_START) or (op == 'remove' and roe.PKT_REMOVE) or nil
    if not pid then return nil, 'bad_op' end
    return pid, string.char(0, 0, 0, 0, id % 256, math.floor(id / 256), 0, 0)
end

---------------------------------------------------------------------------
-- 一覧の判断
---------------------------------------------------------------------------

-- 達成間近：目標の数が分かっていて、進みが pct% 以上（達成済みの数より下）
function roe.near(entry, target, pct)
    target = tonumber(target)
    if not target or target <= 0 then return false end
    local p = tonumber(entry and entry.progress) or 0
    return p < target and p * 100 >= target * (tonumber(pct) or 80)
end

-- このエリアで進むもの：DAT の分類にエリアの印があり、それがいまのエリア
function roe.in_zone(db, id, zone_id)
    local z = db and db.zones[id]
    return z ~= nil and zone_id ~= nil and z[tonumber(zone_id)] == true
end


---------------------------------------------------------------------------
-- 日・週で替わる目標（0.1.224〜、t496）。LSB の roe.cpp・0x10c_roe_start.cpp・0x110_unity.cpp・0x061_clistatus.h を読んで確かめた
-- - ユニティ共通 3000〜3053：9 件ずつ 6 日の組（A〜F）。今日の組だけ受けられる（0x110 の RoEUnityShared が今日の組 0〜5）。
-- - ユニティリーダー 3488〜3707：リーダー 11 人 × 20 件、その中が 4 週 × 5 件。自分のリーダー（0x061 の unity_info の下 5 ビット）
--   で、今週（0x110 の RoEUnityLeader 0〜3）の分だけ受けられる。
-- - 期間限定 4008〜4021：ゲームが 4 時間ごとに入れる。0x10C では受けられない（サーバーが受け付けない）。
-- 組・週は、届いた 0x110 の値を、届いた日（2002-01-01 0:00 JST からの日・週）からの日数・週数だけ進めて使う（0:00 JST に替わる）。
-- どれも分からないあいだは止めない（推測しない）。
---------------------------------------------------------------------------
roe.PKT_UNITY = 0x110
roe.PKT_STATUS = 0x061
roe.SHARED_FIRST, roe.SHARED_LAST = 3000, 3053
roe.LEADER_FIRST, roe.LEADER_LAST = 3488, 3707
roe.TIMED_FIRST, roe.TIMED_LAST = 4008, 4021
roe.EPOCH = 1009810800      -- 2002-01-01 00:00 JST（LSB の vanadiel_epoch）
roe.BLOCKS = { 'A', 'B', 'C', 'D', 'E', 'F' }

function roe.days_since(t) return math.floor(((tonumber(t) or 0) - roe.EPOCH) / 86400) end
function roe.weeks_since(t) return math.floor(((tonumber(t) or 0) - roe.EPOCH) / (86400 * 7)) end

-- 届いた 0x110。戻り値: { shared = 0〜5, week = 0〜3 } または nil
function roe.parse_unity(data)
    -- 頭 4 ＋ Sparks u32・Deeds u16・Plaudits u16 の後（0 から数えて 12・13 バイト目）
    if type(data) ~= 'string' or #data < 14 then return nil end
    if (data:byte(1) + (data:byte(2) % 2) * 256) ~= roe.PKT_UNITY then return nil end
    local sh, wk = data:byte(13), data:byte(14)
    if not sh or sh > 5 or not wk or wk > 3 then return nil end
    return { shared = sh, week = wk }
end

-- 届いた 0x061。戻り値: 自分のユニティのリーダー 1〜11（入っていなければ 0）、または nil
function roe.parse_leader(data)
    -- unity_info は CLISTATUS の 84 バイト目（頭 4 を足して 0 から数えて 0x58）。下 5 ビットがリーダー
    if type(data) ~= 'string' or #data < 0x58 + 4 then return nil end
    if (data:byte(1) + (data:byte(2) % 2) * 256) ~= roe.PKT_STATUS then return nil end
    local v = u32_at(data, 0x58 + 1)
    if not v then return nil end
    local f = v % 32
    if f > 11 then return nil end
    return f
end

-- 届いた 0x110 の値を、いまの時刻まで進める。rot: { shared, week, day_at, week_at }
function roe.rotation_now(rot, now)
    if not rot or rot.shared == nil then return nil end
    local d = roe.days_since(now) - (rot.day_at or roe.days_since(now))
    local w = roe.weeks_since(now) - (rot.week_at or roe.weeks_since(now))
    return { shared = (rot.shared + d) % 6, week = rot.week and ((rot.week + w) % 4) or nil }
end

function roe.shared_block(id) return math.floor((id - roe.SHARED_FIRST) / 9) end
function roe.leader_of(id) return math.floor((id - roe.LEADER_FIRST) / 20) + 1 end
function roe.leader_week_of(id) return math.floor(((id - roe.LEADER_FIRST) % 20) / 5) end
function roe.is_rotating(id)
    id = tonumber(id)
    return id ~= nil and ((id >= roe.SHARED_FIRST and id <= roe.SHARED_LAST) or (id >= roe.LEADER_FIRST and id <= roe.LEADER_LAST))
end

-- いま受けられない理由（受けられる・分からないなら nil）。cur: rotation_now の値、leader: 1〜11
-- 戻り値: 理由, 今日の組の字（'D' など）
function roe.rotation_block(id, cur, leader)
    id = tonumber(id)
    if not id then return nil end
    if id >= roe.TIMED_FIRST and id <= roe.TIMED_LAST then return 'timed_auto' end
    if id >= roe.SHARED_FIRST and id <= roe.SHARED_LAST then
        if cur and cur.shared ~= nil and roe.shared_block(id) ~= cur.shared then return 'not_today', roe.BLOCKS[cur.shared + 1] end
        return nil
    end
    if id >= roe.LEADER_FIRST and id <= roe.LEADER_LAST then
        if leader and leader >= 1 and roe.leader_of(id) ~= leader then return 'other_leader' end
        if leader and leader >= 1 and cur and cur.week ~= nil and roe.leader_week_of(id) ~= cur.week then return 'not_this_week' end
        return nil
    end
    return nil
end

return roe
