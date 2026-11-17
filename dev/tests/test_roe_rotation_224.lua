-- 0.1.224（t496）：日・週で替わる目標（ユニティ共通・リーダー・期間限定）を灰色にして押せなくする。
-- 「受けられない」(742) に名前とわけを出す。共通C (1/10) なのに表が空だったのを直す
require('fake_env')
local json = require('src.lib.json')
local roe = require('src.core.roe')
require('fake_env')
local json = require('src.lib.json')
local roe = require('src.core.roe')

---------------------------------------------------------------------------
-- 小さな DAT を作る（どのバイトも左へ 3 ビット回す＝読むときに右へ 5 ビットで戻る）
---------------------------------------------------------------------------
local ENC = {}
for b = 0, 255 do ENC[roe._DEC[b]] = b end
local function enc(s)
    local out = {}
    for p = 1, #s, 256 do
        local t = { s:byte(p, math.min(#s, p + 255)) }
        for i = 1, #t do t[i] = ENC[t[i]] end
        out[#out + 1] = string.char(unpack(t))
    end
    return table.concat(out)
end
local function u32(v)
    v = v % 4294967296
    return string.char(v % 256, math.floor(v / 256) % 256, math.floor(v / 65536) % 256, math.floor(v / 16777216) % 256)
end
local function pad4(s) local n = (4 - #s % 4) % 4; return s .. string.rep('\0', n) end
-- 文字の表：cells は文字列か数
local function record(cells)
    local n = #cells
    local head = u32(n)
    local body = ''
    local off = 4 + n * 8
    local specs = ''
    for _, c in ipairs(cells) do
        if type(c) == 'number' then
            specs = specs .. u32(off) .. u32(1)
            body = body .. u32(c); off = off + 4
        else
            local piece = pad4(u32(1) .. string.rep('\0', 24) .. c .. '\0')
            specs = specs .. u32(off) .. u32(0)
            body = body .. piece; off = off + #piece
        end
    end
    return head .. specs .. body
end
local SLOT = 0xC00
local function slot(bytes)
    check(#bytes <= SLOT - 1, 'slot fits')
    return bytes .. string.rep('\0', SLOT - 1 - #bytes) .. '\255'
end
local function quest_slot(id, rep, target, name, desc)
    return slot(u32(0xE000 + id) .. u32(20170404) .. u32(rep and 1 or 0) .. u32(target) .. u32(100) .. u32(500) .. u32(0) .. u32(7)
        .. record({ name, desc or '', '' }))
end
local function cat_slot(cid, children, name)
    local s = u32(cid) .. u32(#children)
    for i = 1, 28 do
        local c = children[i]
        if c then s = s .. u32(c[1]) .. u32(c[2]) .. u32(0) .. u32(0) .. u32(0) else s = s .. string.rep('\0', 20) end
    end
    return slot(s .. record({ name }))
end
local QDAT = enc(table.concat({
    quest_slot(0, true, 0, '(empty)'),
    quest_slot(12, true, 200, 'Vanquish Multiple Enemies I'),
    quest_slot(3018, false, 10, 'Shared C One'),
    quest_slot(3019, false, 10, 'Shared C Two'),
    quest_slot(3027, false, 10, 'Shared D One'),
    quest_slot(3548, false, 10, 'Leader4 Week0'),
    quest_slot(3558, false, 10, 'Leader4 Week2'),
    quest_slot(3500, false, 10, 'Leader1 Week2'),
    quest_slot(4010, false, 10, 'Timed One'),
}))
local CDAT = enc(table.concat({
    cat_slot(0xF210, { { 0xE000 + 12, 0x01000001 } }, 'Tutorial'),
    cat_slot(0xF300, { { 0xF303, 0 }, { 0xF304, 0 } }, 'Unity Shared'),
    cat_slot(0xF303, { { 0xE000 + 3018, 0x01000001 }, { 0xE000 + 3019, 0x01000001 } }, 'Shared C'),
    cat_slot(0xF304, { { 0xE000 + 3027, 0x01000001 } }, 'Shared D'),
    cat_slot(0xF310, { { 0xE000 + 3548, 0x01000001 }, { 0xE000 + 3558, 0x01000001 }, { 0xE000 + 3500, 0x01000001 } }, 'Unity Leader'),
    cat_slot(0xF320, { { 0xE000 + 4010, 0x01000001 } }, 'Timed'),
}))
local function hdr(id, size) return string.char(id % 256, math.floor(id / 256) + math.floor(size / 4) * 2, 0, 0) end
local function act_packet(list)
    local w = {}
    for i = 1, 64 do w[i] = 0 end
    for i, e in pairs(list) do w[i] = e[1] + e[2] * 4096 end
    local s = hdr(0x111, 260)
    for i = 1, 64 do s = s .. u32(w[i]) end
    return s
end
local function log_packet(part, bytes)
    local s = hdr(0x112, 136)
    for i = 1, 128 do s = s .. string.char(bytes[i] or 0) end
    return s .. string.char(part, 0, 0, 0)
end
local function msg_packet(num, p1)
    return hdr(0x029, 28) .. u32(1) .. u32(1) .. u32(p1) .. u32(0) .. string.char(0, 0, 0, 0) .. string.char(num % 256, math.floor(num / 256)) .. string.char(0, 0)
end
-- 実機の 0x110（2026-11-18、GAME-PC）：… 03 02 FF … → 今日は共通 D（3）、今週 2
local function unity_packet(shared, week)
    return string.char(0x10, 0x0B, 0xFB, 0x51, 0x43, 0x19, 0, 0, 0, 0, 0, 0, shared, week) .. string.rep('\255', 6) .. string.rep('\0', 2)
end
-- 0x061：unity_info（0 から数えて 0x58）。実機は 24 70 57 01 → リーダー 4（アプルル）・22080 の前の 21980
local function status_packet(info)
    return string.char(0x61, 0x38, 0, 0) .. string.rep('\0', 0x58 - 4) .. u32(info) .. string.rep('\0', 16)
end

-- 読み方と決まり（core）
do
    local u = roe.parse_unity(unity_packet(3, 2))
    eq(u.shared, 3, 'live 0x110: shared block D'); eq(u.week, 2, 'live 0x110: leader week 2')
    eq(roe.parse_unity(unity_packet(6, 0)), nil, 'bad block refused')
    eq(roe.parse_unity(msg_packet(742, 1)), nil, 'other packet refused')
    eq(roe.parse_leader(status_packet(0x01577024)), 4, 'live 0x061: leader 4')
    eq(math.floor(0x01577024 / 1024) % 131072, 21980, 'live 0x061: points 21980 (+100 = 22080)')
    eq(roe.parse_leader(status_packet(0)), 0, 'no unity: 0')
    eq(roe.parse_leader('short'), nil, 'short 0x061')
    -- 2026-11-18 12:00 JST は 2002-01-01 から 9087 日、9087 % 6 = 3（D）。LSB と同じ数え方
    local noon = roe.EPOCH + 9087 * 86400 + 12 * 3600
    eq(roe.days_since(noon) % 6, 3, 'Nov 18 is block D')
    local rot = { shared = 3, week = 2, day_at = roe.days_since(noon), week_at = roe.weeks_since(noon) }
    local cur = roe.rotation_now(rot, noon)
    eq(cur.shared, 3, 'same day'); eq(cur.week, 2, 'same week')
    local next_day = roe.EPOCH + 9088 * 86400 + 60   -- 11/19 0:01 JST
    eq(roe.rotation_now(rot, next_day).shared, 4, 'flips at 00:00 JST to E')
    eq(roe.rotation_now(rot, roe.EPOCH + 9088 * 86400 - 60).shared, 3, 'still D at 23:59 JST')
    local nw = roe.EPOCH + (roe.weeks_since(noon) + 1) * 7 * 86400 + 60
    eq(roe.rotation_now(rot, nw).week, 3, 'next week')
    -- 決まり
    eq(roe.rotation_block(3027, cur, 4), nil, 'today D ok')
    local why, letter = roe.rotation_block(3018, cur, 4)
    eq(why, 'not_today', 'C is not today'); eq(letter, 'D', 'today letter')
    eq(roe.rotation_block(3000, cur, 4), 'not_today', 'A is not today')
    eq(roe.rotation_block(3053, cur, 4), 'not_today', 'F last is not today')
    eq(roe.rotation_block(3558, cur, 4), nil, 'leader 4 week 2 ok (3558-3562)')
    eq(roe.rotation_block(3562, cur, 4), nil, 'leader 4 week 2 last ok')
    eq(roe.rotation_block(3563, cur, 4), 'not_this_week', 'leader 4 week 3')
    eq(roe.rotation_block(3548, cur, 4), 'not_this_week', 'leader 4 week 0')
    eq(roe.rotation_block(3500, cur, 4), 'other_leader', 'leader 1')
    eq(roe.rotation_block(3500, cur, nil), nil, 'leader unknown: not blocked (no guess)')
    eq(roe.rotation_block(3500, cur, 0), nil, 'no unity: not blocked')
    eq(roe.rotation_block(3018, nil, 4), nil, 'no 0x110 yet: not blocked')
    eq(roe.rotation_block(4010, nil, nil), 'timed_auto', 'timed objectives are added by the game')
    eq(roe.rotation_block(4022, cur, 4), nil, 'after timed: not blocked')
    eq(roe.rotation_block(12, cur, 4), nil, 'others not blocked')
    check(roe.is_rotating(3000) and roe.is_rotating(3707) and not roe.is_rotating(3055) and not roe.is_rotating(4010), 'rotating ranges')
end

---------------------------------------------------------------------------
-- 本体で
---------------------------------------------------------------------------
local datdir = TMP .. '/dat'
os.execute('mkdir -p "' .. datdir .. '"')
local function put(name, s) local f = io.open(datdir .. '/' .. name, 'wb'); f:write(s); f:close() end
put('q.dat', QDAT); put('c.dat', CDAT)
AshitaCore.GetResourceManager = function ()
    return { GetFilePath = function (_, id)
        if id == 55672 or id == 55552 then return datdir .. '/q.dat' end
        if id == 55673 or id == 55553 then return datdir .. '/c.dat' end
        return nil
    end }
end
local INJ = {}
vana = {
    packets = {
        inject = function (incoming, id, data) INJ[#INJ + 1] = { incoming = incoming, id = id, data = data } end,
        last = function (incoming, id) return FAKE.last_packets and FAKE.last_packets[id] or nil end,
    },
    encoding = { from_shift_jis = function (s) return s end, to_shift_jis = function (s) return s end },
}
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local platform = require('src.platform.ashita')
platform.roe_snapshot = function () return nil, 'no_memory' end
local NOW = roe.EPOCH + 9087 * 86400 + 12 * 3600    -- 2026-11-18 12:00 JST
app.epoch_now = function () return NOW end
FAKE.player = { name = 'Tester', zone = 100, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local st = app.state
check(st.ready, 'logged in')

-- まだ 0x110・0x061 が無い：止めない（推測しない）。期間限定だけは止める
FAKE.events.packet_in({ id = 0x111, data = act_packet({ [1] = { 3018, 2 } }) })
eq(app.roe_can('start', 3019), true, 'no rotation data yet: not blocked')
eq(app.roe_can('start', 3500), true, 'no leader yet: not blocked')
eq(select(2, app.roe_can('start', 4010)), 'timed_auto', 'timed: blocked')

-- 読み込んだ直後は最後に届いたもの
FAKE.last_packets = { [0x110] = unity_packet(3, 2), [0x061] = status_packet(0x01577024) }
app.read_roe('test')
eq(st.roe.unity.shared, 3, 'last 0x110 read at load'); eq(st.roe.leader, 4, 'last 0x061 read at load')
FAKE.last_packets = nil
-- 届いた通信でも
st.roe.unity, st.roe.leader = nil, nil
FAKE.events.packet_in({ id = 0x110, data = unity_packet(3, 2) })
FAKE.events.packet_in({ id = 0x061, data = status_packet(0x01577024) })
eq(st.roe.unity.shared, 3, '0x110 via packet_in'); eq(st.roe.leader, 4, '0x061 via packet_in')

do
    eq(app.roe_can('start', 3027), true, 'today D: can take')
    eq(select(2, app.roe_can('start', 3019)), 'not_today', 'C: not today')
    eq(select(2, app.roe_can('start', 3548)), 'not_this_week', 'leader 4 week 0: not this week')
    eq(select(2, app.roe_can('start', 3500)), 'other_leader', 'leader 1: other leader')
    eq(app.roe_can('start', 3558), true, 'leader 4 week 2: can take')
    -- 受けている C は受けているまま（灰色にしない・解除できる）
    eq(app.roe_rotation(3018), nil, 'accepted C: not greyed')
    eq(app.roe_can('remove', 3018), true, 'accepted C: can drop')
    eq(select(2, app.roe_can('start', 3018)), 'already', 'accepted C: already')
    -- 押しても送らない。わけを出す
    local n = #INJ
    local r = app.roe_send('start', 3019)
    eq(r.code, 'not_today', 'press refused'); eq(#INJ, n, 'nothing sent')
    local msg = app.roe_why_text('not_today', 3019)
    check(msg:find('D', 1, true) and msg:find('3027', 1, true) and msg:find('3035', 1, true), 'reason names today D (3027-3035): ' .. msg)
    -- 日が替わると E
    NOW = roe.EPOCH + 9088 * 86400 + 60
    eq(select(2, app.roe_can('start', 3027)), 'not_today', 'next day: D no longer')
    NOW = roe.EPOCH + 9087 * 86400 + 12 * 3600
end

-- 742：名前とわけ。日・週で替わるものは「受けられなかった」を覚えない
do
    st.roe.last_send = { op = 'start', id = 3027, at = st.now }
    st.roe.sent[3027] = { op = 'start', at = st.now }
    FAKE.events.packet_in({ id = 0x029, data = msg_packet(742, 3027) })
    eq(app.roe_failed(3027), nil, 'rotating refusal not remembered')
    check(st.roe.sent[3027].answered_at ~= nil, 'refusal counts as the answer')
    local f = st.flash and st.flash.text or ''
    check(type(f) == 'string' and f:find('Shared D One', 1, true) ~= nil, 'note names the objective: ' .. tostring(f))
    st.roe.last_send = { op = 'start', id = 12, at = st.now }
    FAKE.events.packet_in({ id = 0x029, data = msg_packet(742, 12) })
    eq(app.roe_failed(12).why, 'unable', 'other refusal still remembered')
    S.eminence.failed['12'] = nil
    frames(2)
end

-- 本：灰色・印・押せない。共通C の (1/10) と表を合わせる
do
    app.open_window('book')
    S.book.tab = 'eminence'
    S.eminence.book_root = -2
    S.eminence.book_show = S.eminence.book_show or { accepted = true, not_accepted = true }
    S.eminence.book_show.completed = false
    frame(); frame()
    check(labeled('Shared C Two'), 'not-today row still listed')
    check(texted('［今日は共通D］') or texted('[Today: Shared D]'), 'not-today tag')
    check(texted('［ほかのリーダー］') or texted('[Other leader]'), 'other leader tag')
    check(texted('［今週の分ではない］') or texted('[Not this week]'), 'not this week tag')
    check(texted('［自動で入る］') or texted('[Added by the game]'), 'timed tag')
    check(labeled('##roe_remove_3018'), 'accepted C keeps its drop button')
    -- 下の見出しの無い「Shared C」が閉じた扱いで保存されていても、選べば表に出る
    local book = require('src.ui.book')
    book.set_collapsed(S, 'eminence', 0xF303, true)
    book.set_heading(S, 'eminence', 0xF303, function () end)
    FAKE.labels = {}; frame(); frame()
    check(labeled('Shared C One') and labeled('Shared C Two'), 'collapsed leaf heading still shows its records')
    -- 上の見出しを閉じていても、選んだ下の見出しのレコードは出る
    book.set_collapsed(S, 'eminence', 0xF303, false)
    book.set_collapsed(S, 'eminence', 0xF300, true)
    FAKE.labels = {}; frame(); frame()
    check(labeled('Shared C One') and labeled('Shared C Two'), 'collapsed parent: selected child still shows its records')
    -- t501：閉じた見出しそのものを選んでも、その下のレコードが表に出る（クエストと同じ）
    book.set_heading(S, 'eminence', 0xF300, function () end)
    FAKE.labels = {}; frame(); frame()
    check(labeled('Shared C One') and labeled('Shared D One'), 'collapsed heading selected: its records show')
    book.set_heading(S, 'eminence', 'all', function () end)
    FAKE.labels = {}; frame(); frame()
    check(labeled('Shared C One') and labeled('Vanquish Multiple Enemies I'), 'すべて with a collapsed heading: records show')
    book.set_collapsed(S, 'eminence', 0xF300, false)
end

print('test_roe_rotation_224 ok')
