--[[
  Astertrail - game_log（ゲームのクエスト・ミッションの記録を読む。0.1.169〜、t223）
  - ゲームとサーバーの通信 0x056（クエスト・ミッションのログ）の中身と、ゲームがそれを写した場所の中身を読むだけ。
    通信を送ったり、変えたり、止めたりはしない。ゲームの API も呼ばない（読むのは platform）。
  - 0x056 の形（Port と 32 バイト）は LandSandBoat の src/map/packets/s2c/0x056_*.cpp（dev/sources/lsb/）。
    ゲームがどこに写すかは、ゲームの 0x056 の処理を読んで確かめた（2026-11-16、実機、読むだけ）：
      クエスト受注中 11 個（Port 0x50〜0x88・0xE0・0xF0・0x100）、クエスト完了 11 個（0x90〜0xC8・0xE8・0xF8・0x108）、
      ミッション完了 4 個（0xD0・0xD8・0x30・0x38）、それぞれ 32 バイトで続けて並ぶ。
      その後ろに 0xFFFF の中身（今のミッション）、0xFFFE（TVR）、届いた印（全部そろうと 0x83FFFFFF）。
  - 番号の対応は data/game_refs.json（dev/build_game_refs.py、LSB の id 表から名前が1つだけ一致したもの）。
]]

local bit = rawget(_G, 'bit') or (pcall(require, 'bit') and require('bit')) or nil

local gl = {}

-- クエストのログ（LSB の questLog の番号）と、受注中・完了の Port
gl.QUEST_LOGS = 11
gl.QUEST_CUR_PORT = { [0] = 0x50, 0x58, 0x60, 0x68, 0x70, 0x78, 0x80, 0x88, 0xE0, 0xF0, 0x100 }
gl.QUEST_DONE_PORT = { [0] = 0x90, 0x98, 0xA0, 0xA8, 0xB0, 0xB8, 0xC0, 0xC8, 0xE8, 0xF8, 0x108 }
-- ミッション完了の Port（0xD0 三国＋ジラート、0xD8 アトルガン＋アルタナ、0x30・0x38 カンパニエ）
gl.MISSION_DONE_PORT = { [0] = 0xD0, 0xD8, 0x30, 0x38 }
gl.MAIN_PORT = 0xFFFF
gl.TVR_PORT = 0xFFFE
-- 届いた印のビット（ゲームの処理と同じ）：受注中 0〜10、完了 11〜21、ミッション完了 22〜25、0xFFFF/0xFFFE は 31
gl.ALL_RECEIVED = 0x83FFFFFF

-- ミッションのログ（LSB の mission log_id）
gl.M = { SANDORIA = 0, BASTOK = 1, WINDURST = 2, ZILART = 3, TOAU = 4, WOTG = 5, COP = 6, ASSAULT = 7,
         ACP = 9, AMK = 10, ASA = 11, SOA = 12, ROV = 13 }

local function u32le(s, pos)  -- pos は 1 始まり
    local a, b, c, d = s:byte(pos, pos + 3)
    if not d then return nil end
    return a + b * 256 + c * 65536 + d * 16777216
end

local function u16le(s, pos)
    local a, b = s:byte(pos, pos + 1)
    if not b then return nil end
    return a + b * 256
end

local function band(a, b)
    if bit then return bit.band(a, b) % 4294967296 end
    local r, m = 0, 1
    a, b = a % 4294967296, b % 4294967296
    while a > 0 and b > 0 do
        if a % 2 == 1 and b % 2 == 1 then r = r + m end
        a, b, m = math.floor(a / 2), math.floor(b / 2), m * 2
    end
    return r
end
gl._band = band

local function rshift(a, n) return math.floor((a % 4294967296) / 2 ^ n) end

-- words（1 始まり 8 個の u32）の n 番目のビット（0 始まり）
local function bit_on(words, n)
    if type(words) ~= 'table' or n < 0 then return false end
    local w = words[math.floor(n / 32) + 1]
    if not w then return false end
    return band(rshift(w, n % 32), 1) == 1
end
gl.bit_on = bit_on

---------------------------------------------------------------------------
-- 記録の入れ物
---------------------------------------------------------------------------

function gl.new_snapshot()
    return { cur = {}, done = {}, mdone = {}, main = nil, tvr = nil, ports = {}, source = nil }
end

local PORT_SLOT = {}
for i = 0, gl.QUEST_LOGS - 1 do
    PORT_SLOT[gl.QUEST_CUR_PORT[i]] = { 'cur', i }
    PORT_SLOT[gl.QUEST_DONE_PORT[i]] = { 'done', i }
end
for i = 0, 3 do PORT_SLOT[gl.MISSION_DONE_PORT[i]] = { 'mdone', i } end

-- 0xFFFF の 32 バイト（通信の 0x04〜0x23）を読む。words は 8 個の u32。
local function main_from_words(w)
    local addons = w[6] % 65536
    return {
        nation = w[1] % 256,
        nation_mission = w[2] % 65536,
        zilart = w[3],
        cop = w[4],
        cop2 = w[5],
        acp = addons % 16,
        amk = math.floor(addons / 16) % 16,
        asa = math.floor(addons / 256) % 16,
        declined = math.floor(w[6] / 65536) % 65536,
        soa_raw = w[7],
        rov_raw = w[8],
    }
end

-- 1 つの Port の中身を入れる。words は 8 個の u32（1 始まり）。戻り値: 入れたか
function gl.apply_port(snap, port, words)
    if type(words) ~= 'table' or #words < 8 then return false end
    if port == gl.MAIN_PORT then
        snap.main = main_from_words(words)
        snap.ports[port] = true
        return true
    elseif port == gl.TVR_PORT then
        snap.tvr = words[1]
        snap.ports[port] = true
        return true
    end
    local slot = PORT_SLOT[port]
    if not slot then return false end
    local w = {}
    for i = 1, 8 do w[i] = words[i] end
    snap[slot[1]][slot[2]] = w
    snap.ports[port] = true
    return true
end

-- 届いた通信 0x056（4 バイトの頭から。packet_in の e.data と同じ）を読む。戻り値: port, words（読めなければ nil）
function gl.parse_packet(data)
    if type(data) ~= 'string' or #data < 0x26 then return nil end
    local id = u16le(data, 1) % 512
    if id ~= 0x056 then return nil end
    local words = {}
    for i = 0, 7 do words[i + 1] = u32le(data, 5 + i * 4) end
    local port = u16le(data, 0x25)
    return port, words
end

-- ゲームが写した場所の中身から。read_u32(addr) と、先頭の番地（受注中クエストの最初）を渡す。
-- 届いた印がそろっていなければ、そろっている分だけ入れる。戻り値: snap, mask
function gl.from_memory(read_u32, cur_base)
    local snap = gl.new_snapshot()
    snap.source = 'memory'
    local done_base = cur_base + 0x160
    local m_base = done_base + 0x160
    local main_base = m_base + 0x80
    local mask = read_u32(main_base + 0x24)
    if type(mask) ~= 'number' then return nil, 'no_mask' end
    local function words_at(addr)
        local w = {}
        for i = 0, 7 do
            local v = read_u32(addr + i * 4)
            if type(v) ~= 'number' then return nil end
            w[i + 1] = v
        end
        return w
    end
    local function has(bitn) return band(rshift(mask, bitn), 1) == 1 end
    for i = 0, gl.QUEST_LOGS - 1 do
        if has(i) then snap.cur[i] = words_at(cur_base + i * 32); snap.ports[gl.QUEST_CUR_PORT[i]] = snap.cur[i] ~= nil end
        if has(i + 11) then snap.done[i] = words_at(done_base + i * 32); snap.ports[gl.QUEST_DONE_PORT[i]] = snap.done[i] ~= nil end
    end
    for i = 0, 3 do
        if has(22 + i) then snap.mdone[i] = words_at(m_base + i * 32); snap.ports[gl.MISSION_DONE_PORT[i]] = snap.mdone[i] ~= nil end
    end
    if has(31) then
        -- ゲームの中の並び：+0 ジラート、+4 所属国のミッション(u16)、+6 所属国(u8)、+8 プロマシア、+0x0C プロマシアの章、
        -- +0x10 追加シナリオ(u16)、+0x14 アドゥリン、+0x18 ヴァナ・ディールの星唄、+0x1C TVR、+0x20 始めない印
        local z = read_u32(main_base)
        local nm = read_u32(main_base + 4)
        local cop = read_u32(main_base + 8)
        local cop2 = read_u32(main_base + 0x0C)
        local addons = read_u32(main_base + 0x10)
        local soa = read_u32(main_base + 0x14)
        local rov = read_u32(main_base + 0x18)
        local tvr = read_u32(main_base + 0x1C)
        local tales = read_u32(main_base + 0x20)
        if z and nm and cop and addons and soa and rov and tales then
            snap.main = {
                nation = math.floor(nm / 65536) % 256,
                nation_mission = nm % 65536,
                zilart = z, cop = cop, cop2 = cop2,
                acp = addons % 16, amk = math.floor(addons / 16) % 16, asa = math.floor(addons / 256) % 16,
                declined = tales % 65536,
                soa_raw = soa, rov_raw = rov,
            }
            snap.tvr = tvr
            snap.ports[gl.MAIN_PORT] = true
        end
    end
    return snap, mask
end

---------------------------------------------------------------------------
-- 1 件の状態（'accepted' / 'completed' / 'not_accepted'。分からなければ nil）
-- ref: { 'q', log, id } または { 'm', log, id }
-- info: { ids = そのログの番号の並び, ordered = 番号が話の順か }（今のミッションだけ分かるログ用）
---------------------------------------------------------------------------

local function quest_state(snap, log, id)
    local cur, done = snap.cur[log], snap.done[log]
    if not cur or not done then return nil end
    -- アトルガンのログは後ろ半分（ワード 4〜7）がアサルトなどに使われるので、クエストは 0〜127 だけ
    if log == 6 and id >= 128 then return nil end
    if id < 0 or id >= 256 then return nil end
    if bit_on(cur, id) then return 'accepted' end
    if bit_on(done, id) then return 'completed' end
    return 'not_accepted'
end

-- 今のミッションの値 v と、そのログの番号の並び（小さい順）から。
-- v が並びの最初（始めていないときと区別できない）・並びにない値のときは分からない。
-- ordered でないログ（プロマシア：道が分かれる）は、今のミッションを受注中にするだけ。
local function by_current(v, id, info)
    local list = info and info.ids
    if type(v) ~= 'number' or type(list) ~= 'table' or #list == 0 then return nil end
    local known = false
    for _, x in ipairs(list) do if x == v then known = true; break end end
    if not known or v == list[1] then return nil end
    if id == v then return 'accepted' end
    if not info.ordered then return nil end
    if id < v then return 'completed' end
    return 'not_accepted'
end

local function mission_state(snap, log, id, info)
    local M = gl.M
    local main = snap.main
    if log == M.SANDORIA or log == M.BASTOK or log == M.WINDURST or log == M.ZILART then
        local done = snap.mdone[0]
        if not done or not main then return nil end
        if id < 0 or id >= 64 then return nil end
        local cur
        if log == M.ZILART then cur = main.zilart
        elseif main.nation == log and main.nation_mission ~= 0xFFFF then cur = main.nation_mission end
        if cur == id then
            -- ジラートの最初（0）は、始めていないときと区別できない
            if log == M.ZILART and id == 0 and not bit_on(done, log * 64 + id) then return nil end
            return 'accepted'
        end
        if bit_on(done, log * 64 + id) then return 'completed' end
        return 'not_accepted'
    elseif log == M.TOAU or log == M.WOTG then
        local done, ahtcur = snap.mdone[1], snap.cur[6]
        if not done or not ahtcur then return nil end
        if id < 0 or id >= 64 then return nil end
        local base = (log == M.TOAU) and 0 or 64
        local cur = ahtcur[(log == M.TOAU) and 6 or 7]
        if bit_on(done, base + id) then
            if cur == id then return 'accepted' end
            return 'completed'
        end
        if cur == id then
            if id == 0 then return nil end  -- 最初のミッションは、始めていないときと区別できない
            return 'accepted'
        end
        return 'not_accepted'
    elseif log == M.ASSAULT then
        local done, ahtcur, ahtdone = snap.mdone[1], snap.cur[6], snap.done[6]
        if not ahtcur or not ahtdone then return nil end
        if id < 1 or id >= 128 then return nil end
        if ahtcur[5] == id then return 'accepted' end
        if bit_on(ahtdone, 128 + id) then return 'completed' end
        return 'not_accepted'
    end
    if not main then return nil end
    -- 始めないと決めた印（説明書 04-game-data：1 ACP、2 ASA、3 プロマシア、5 アドゥリン、6 星唄）が付いていれば読まない
    local DECLINED_BIT = { [M.COP] = 8, [M.ACP] = 2, [M.ASA] = 4, [M.SOA] = 32, [M.ROV] = 64 }
    if DECLINED_BIT[log] and band(main.declined or 0, DECLINED_BIT[log]) ~= 0 then return nil end
    if log == M.COP then
        return by_current(main.cop, id, info)
    elseif log == M.ACP then return by_current(main.acp, id, info)
    elseif log == M.AMK then return by_current(main.amk, id, info)
    elseif log == M.ASA then return by_current(main.asa, id, info)
    elseif log == M.SOA then
        local raw = main.soa_raw
        if type(raw) ~= 'number' or raw < 0x6E or (raw - 0x6E) % 2 ~= 0 then return nil end
        return by_current((raw - 0x6E) / 2, id, info)
    elseif log == M.ROV then
        local raw = main.rov_raw
        if type(raw) ~= 'number' or raw < 0x6C then return nil end
        return by_current(raw - 0x6C, id, info)
    end
    return nil
end

function gl.state_of(snap, ref, info)
    if type(snap) ~= 'table' or type(ref) ~= 'table' then return nil end
    local kind, log, id = ref[1], tonumber(ref[2]), tonumber(ref[3])
    if not log or not id then return nil end
    if kind == 'q' then return quest_state(snap, log, id) end
    if kind == 'm' then return mission_state(snap, log, id, info) end
    return nil
end

-- 届いた Port の数（/astertrail gamelog で見る）
function gl.port_count(snap)
    local n = 0
    for _ in pairs(snap and snap.ports or {}) do n = n + 1 end
    return n
end

return gl
