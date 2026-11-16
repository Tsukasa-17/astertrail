-- エミネンス・レコード（0.1.172〜、t243）：DAT の読み方・0x111/0x112/0x029・送る形・窓と本・1回だけ送る
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
    quest_slot(12, true, 200, 'Vanquish Multiple Enemies I', 'Defeat enemies.\n\nSpecial reward: Test Primer\n  (You may only hold one.)'),
    quest_slot(13, false, 500, 'Vanquish Multiple Enemies II'),
    slot(u32(0xE000 + 14) .. u32(0) .. u32(0) .. u32(1) .. u32(0) .. u32(0) .. u32(0) .. u32(0) .. record({ '.', '.', '' })),
    quest_slot(215, false, 10, 'Combat: West Ronfaure'),
    quest_slot(300, false, 5, 'Loose One'),
    quest_slot(3055, false, 10, 'Unity Leader A'),
}))
local CDAT = enc(table.concat({
    cat_slot(0xF210, { { 0xF230, 0 } }, 'Tutorial'),
    cat_slot(0xF230, { { 0xE000 + 12, 0x01000001 }, { 0xE000 + 13, 0x01000001 } }, 'Basics'),
    cat_slot(0xF212, { { 0xF259, 0 } }, 'Combat (Region)'),
    cat_slot(0xF259, { { 0xE000 + 215, 0x04000064 }, { 0xE000 + 3055, 0x06000000 } }, 'Original Areas 1'),
}))

-- DAT の読み方
do
    eq(roe.slot_size(QDAT), SLOT, 'slot size')
    local q, n = roe.parse_quests(QDAT, nil, 'en')
    eq(n, 5, 'named objectives (no empty, no placeholder)')
    eq(q[12].name, 'Vanquish Multiple Enemies I', 'name')
    eq(q[12].target, 200, 'target count')
    eq(q[12].repeatable, true, 'repeatable')
    eq(q[13].repeatable, false, 'not repeatable')
    eq(q[12].rewards.uni, 7, 'four rewards layout')
    -- 0.1.177〜：特別報酬の行を説明から分ける（続きの括弧の行も）
    eq(q[12].special, 'Test Primer\n(You may only hold one.)', 'special reward split out')
    eq(q[12].body, 'Defeat enemies.', 'body without the special reward')
    eq(q[13].special, nil, 'no special reward: nil (blank)')
    local jb, js = roe.split_special('マウラ(G-9)にいる、\n話を聞く。\n\n\227\128\128特別報酬:アンバスケード大典2章')
    eq(jb, 'マウラ(G-9)にいる、\n話を聞く。', 'ja body'); eq(js, 'アンバスケード大典2章', 'ja special')
    local jb2, js2 = roe.split_special('\227\128\128特別報酬：本\n\227\128\128(複数所持することはできません)\n\227\128\128コスト:1')
    eq(js2, '本\n(複数所持することはできません)', 'ja full-width colon and continuation'); eq(jb2, '\227\128\128コスト:1', 'other lines kept')
    eq(select(2, roe.split_special('ただの説明')), nil, 'plain desc has no special')
    eq(q[14], nil, 'placeholder dropped')
    eq(q[0], nil, 'id 0 dropped')
    local c = roe.parse_categories(CDAT)
    eq(c[0xF259].children[1].zone, 100, 'zone flag (0x04) gives the area')
    eq(c[0xF259].children[2].zone, nil, 'other flags are not areas')
    eq(c[0xF210].children[1].kind, 'cat', 'category child')
    local db = roe.build(q, c)
    eq(#db.roots, 2, 'two roots')
    eq(db.roots[1], 0xF210, 'roots sorted')
    eq(db.cat_of[215], 0xF259, 'category of objective')
    check(roe.in_zone(db, 215, 100), 'objective in West Ronfaure')
    check(not roe.in_zone(db, 12, 100), 'no area for basics')
    eq(db.loose[1], 300, 'objective in no category')
    eq(roe.parse_quests('short', nil, 'en'), nil, 'bad size')
end

-- 本物の DAT（環境変数 ASTERTRAIL_ROE_DAT にフォルダがあるときだけ。同梱しない）
do
    local dat_dir = os.getenv('ASTERTRAIL_ROE_DAT') or '__no_dat__'
    local f = io.open(dat_dir .. '/307_15.DAT', 'rb')
    if f then
        local raw = f:read('*a'); f:close()
        local q, n = roe.parse_quests(raw, nil, 'ja')
        check(n > 1500, 'real ja objectives: ' .. tostring(n))
        eq(q[12].target, 200, 'real: #12 needs 200 (in-game 142/200)')
        eq(q[12].repeatable, true, 'real: #12 repeatable')
        local cf = io.open(dat_dir .. '/307_23.DAT', 'rb')
        local c = roe.parse_categories(cf:read('*a')); cf:close()
        local db = roe.build(q, c)
        check(roe.in_zone(db, roe.objectives_in(db, 0xF253)[1], 101), 'real: gathering East Ronfaure is area 101')
        local ef = io.open(dat_dir .. '/307_16.DAT', 'rb')
        local qe = roe.parse_quests(ef:read('*a'), nil, 'en'); ef:close()
        eq(qe[12].name, 'Vanquish Multiple Enemies I', 'real en name')
        check(qe[12].desc and qe[12].desc:find('Defeat', 1, true), 'real en description')
    end
end

-- 通信の読み方
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
do
    -- 実機の 0x111 の頭（2026-11-16、実機）：0C E0 08 00 → #12 進み 142
    local live = act_packet({ [1] = { 12, 142 }, [2] = { 0x16, 9 }, [64] = { 0xFAF, 0 } })
    eq(live:sub(5, 8), string.char(0x0C, 0xE0, 0x08, 0x00), 'live bytes')
    local a = roe.parse_active(live)
    eq(#a, 3, 'active with timed')
    eq(a[1].id, 12, 'id'); eq(a[1].progress, 142, 'progress')
    eq(a[3].timed, true, 'slot 64 is timed')
    local part, bytes = roe.parse_log(log_packet(0, { 0x3E }))
    eq(part, 0, 'log part')
    local c = roe.new_complete()
    roe.apply_log(c, part, bytes)
    check(roe.is_complete(c, 1) and roe.is_complete(c, 5) and not roe.is_complete(c, 0) and not roe.is_complete(c, 6), 'bits low first')
    eq(roe.parse_message(msg_packet(742, 3055)), 'unable', 'unable message')
    local k, p = roe.parse_message(msg_packet(704, 12)); eq(k, 'start'); eq(p, 12, 'start message id')
    eq(roe.parse_message(msg_packet(6, 1)), nil, 'other message')
    eq(roe.not_implemented_id('The record #3055 is not implemented at this time.'), 3055, 'not implemented line')
    eq(roe.not_implemented_id('hello'), nil, 'other line')
    check(roe.near({ progress = 160 }, 200, 80) and not roe.near({ progress = 150 }, 200, 80) and not roe.near({ progress = 200 }, 200, 80), 'near')
    check(not roe.near({ progress = 5 }, nil, 80), 'near needs a target')
end

-- 送る形（LSB の 0x10C/0x10D：番号 u16 ＋ 0 の u16。頭 4 バイトは VanaCore）
do
    local pid, data = roe.build_packet('start', 12)
    eq(pid, 0x10C, 'start id'); eq(data, string.char(0, 0, 0, 0, 12, 0, 0, 0), 'start bytes (8)')
    pid, data = roe.build_packet('remove', 3055)
    eq(pid, 0x10D, 'remove id'); eq(data, string.char(0, 0, 0, 0, 0xEF, 0x0B, 0, 0), 'remove bytes')
    eq(roe.build_packet('start', 0), nil, 'id 0 refused')
    eq(roe.build_packet('start', 4096), nil, 'id 4096 refused')
    eq(roe.build_packet('claim', 12), nil, 'other op refused')
end

---------------------------------------------------------------------------
-- 本体で（偽の環境）。DAT は get_file_path → fs.read。送るのは vana.packets.inject（数える）
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
check(FAKE.events.packet_in and FAKE.events.packet_out, 'packet hooks registered (read only)')
FAKE.events.load()
local app = require('src.app')
local platform = require('src.platform.ashita')
platform.roe_snapshot = function () return nil, 'no_memory' end   -- 写した場所は読めない扱い
FAKE.player = { name = 'Tester', zone = 100, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local st = app.state
check(st.ready, 'logged in')
eq(S.eminence.visible, false, 'window hidden at first')
eq(S.eminence.filter, 'all', 'filter default')

-- 記録がまだ：押せない
do
    eq(app.roe_can('start', 13), false, 'no record yet')
    local r = app.roe_send('start', 13)
    eq(r.code, 'unknown', 'refused without record')
    eq(#INJ, 0, 'nothing sent')
end

-- 読み込んだ直後：場所が読めなければ最後に届いた 0x111
FAKE.last_packets = { [0x111] = act_packet({ [1] = { 12, 142 } }) }
app.read_roe('test')
eq(st.roe.src, 'last_packet', 'from last packet')
eq(app.roe_active_entry(12).progress, 142, 'progress from last packet')

-- 届いた通信（platform の packet_in を通す）
FAKE.events.packet_in({ id = 0x111, data = act_packet({ [1] = { 12, 150 }, [2] = { 215, 9 }, [64] = { 0xFAF, 1 } }) })
eq(st.roe.src, 'packet', 'packet source')
eq(app.roe_active_entry(12).progress, 150, 'progress updated')
for p = 0, 3 do FAKE.events.packet_in({ id = 0x112, data = log_packet(p, p == 0 and { 0x3E, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x10 } or {}) }) end
check(st.roe.complete ~= nil, 'completion table after 4 parts')
check(roe.is_complete(st.roe.complete, 1), 'objective 1 done')
check(roe.is_complete(st.roe.complete, 300), 'objective 300 done (byte 37 bit 4)')
-- 注入された通信は読まない
FAKE.events.packet_in({ id = 0x111, data = act_packet({}), injected = true })
eq(app.roe_active_entry(12).progress, 150, 'injected packet ignored')

-- 押せるか
eq(app.roe_can('start', 12), false, 'already taken'); eq(select(2, app.roe_can('start', 12)), 'already')
eq(app.roe_can('remove', 12), true, 'can drop taken')
eq(select(2, app.roe_can('remove', 0xFAF)), 'timed', 'timed cannot be dropped')
eq(select(2, app.roe_can('start', 300)), 'completed', 'done and not repeatable')
eq(app.roe_can('start', 13), true, 'can take')

do
    local em = require('src.ui.eminence')
    eq(em.action_hidden('completed', false), true, 'hide button when done and not repeatable')
    eq(em.action_hidden('completed', true), false, 'keep button when done and repeatable')
    eq(em.action_hidden('accepted', false), false, 'keep button when accepted')
    eq(em.action_hidden('available', false), false, 'keep button when not yet taken')
    eq(em.action_hidden(nil, false), false, 'keep button when state unknown')
end

-- 1回だけ送る
do
    local r = app.roe_send('start', 13)
    eq(r.code, 'sent', 'sent')
    eq(#INJ, 1, 'one packet')
    eq(INJ[1].incoming, false, 'outgoing'); eq(INJ[1].id, 0x10C, '0x10C')
    eq(INJ[1].data, string.char(0, 0, 0, 0, 13, 0, 0, 0), 'bytes')
    -- 続けて押しても送らない（答え待ち）
    r = app.roe_send('start', 13)
    eq(r.code, 'busy', 'busy'); eq(#INJ, 1, 'no second packet')
    -- 何フレーム経っても、やり直さない
    frames(5)
    eq(#INJ, 1, 'no retry by itself')
    -- 外す
    r = app.roe_send('remove', 12)
    eq(r.code, 'sent'); eq(#INJ, 2); eq(INJ[2].id, 0x10D, '0x10D'); eq(INJ[2].data:byte(5), 12, 'remove id')
    -- 0.1.178〜（t287）：進みだけの 0x111（まだ #13 が無い・#12 が残る）では解かない
    FAKE.events.packet_in({ id = 0x111, data = act_packet({ [1] = { 12, 151 }, [2] = { 215, 9 } }) })
    eq(select(2, app.roe_can('remove', 12)), 'busy', 'progress-only 0x111 keeps the lock')
    -- 答えの 0x111 が届いても、すぐ逆の操作は押せない（連打で受けて解除しない）
    FAKE.events.packet_in({ id = 0x111, data = act_packet({ [1] = { 215, 9 }, [2] = { 13, 0 } }) })
    eq(select(2, app.roe_can('remove', 13)), 'busy', 'locked right after the answer')
    eq(app.roe_send('remove', 13).code, 'busy', 'rapid press after the answer sends nothing')
    eq(#INJ, 2, 'still only two')
    frames(1.5)
    eq(app.roe_can('remove', 13), true, 'pressable a moment after the answer')
    eq(#INJ, 2, 'unlocking sends nothing')
    -- 答えが来なくても、上限の秒で解ける（やり直しはしない）
    eq(app.roe_send('remove', 13).code, 'sent', 'next press sends once')
    eq(#INJ, 3)
    frames(2); eq(select(2, app.roe_can('remove', 13)), 'busy', 'still waiting for the answer')
    frames(4); eq(app.roe_can('remove', 13), true, 'timeout unlocks'); eq(#INJ, 3, 'no retry')
    -- 断られた（0x029）のも答え
    st.roe.sent[13].answered_at = nil; st.roe.sent[13].at = st.now
    FAKE.events.packet_in({ id = 0x029, data = msg_packet(742, 13) })
    check(st.roe.sent[13].answered_at ~= nil, 'refusal counts as the answer')
    frames(1.5)
    S.eminence.failed['13'] = nil
end

-- 30 件でいっぱい
do
    local full = {}
    for i = 1, 30 do full[i] = { 1000 + i, 0 } end
    FAKE.events.packet_in({ id = 0x111, data = act_packet(full) })
    eq(select(2, app.roe_can('start', 13)), 'full', 'full at 30')
    FAKE.events.packet_in({ id = 0x111, data = act_packet({ [1] = { 215, 9 }, [2] = { 13, 0 } }) })
end

-- 受けられない・まだ無いと言われた番号を覚える
do
    FAKE.events.packet_in({ id = 0x029, data = msg_packet(742, 12) })
    eq(app.roe_failed(12).why, 'unable', 'unable remembered')
    FAKE.events.text_in({ message = 'The record #3055 is not implemented at this time.', mode = 9 })
    eq(app.roe_failed(3055).why, 'not_impl', 'not implemented remembered')
    -- 番号の無い「受けられない」は、直前に押した番号
    app.roe_send('start', 300)   -- 押せない（達成済み）→ 送らない
    eq(#INJ, 3, 'refused press sends nothing')
    st.roe.last_send = { op = 'start', id = 12, at = st.now }
    FAKE.events.packet_in({ id = 0x029, data = msg_packet(704, 12) })
    eq(app.roe_failed(12), nil, 'taken later: mark cleared')
    -- 保存して読み直しても残る
    app.save_all('test')
    local saved = require('src.core.settings').merge(json.decode(json.encode(S)))
    eq(saved.eminence.failed['3055'].why, 'not_impl', 'failed survives save')
end

-- 窓
do
    app.command('/astertrail eminence')
    eq(S.eminence.visible, true, 'command shows the window')
    frame()
    check(drawn('###astertrail_eminence'), 'window drawn')
    check(texted('Combat: West Ronfaure'), 'name in window')
    check(texted('9/10'), 'progress text n/target')
    check(texted('0/500'), 'progress of #13')
    -- 0.1.177〜 達成間近、0.1.179〜（t288）このエリアと「一覧」もなくした：タブの行ごと無い（保存に残っていても全部に戻す）
    FAKE.labels = {}; frame()
    check(not labeled('##f_all') and not labeled('##f_area') and not labeled('##f_near'), 'no filter tabs')
    check(not labeled('##to_book'), 'no 一覧 button')
    eq(require('src.core.settings').merge({ eminence = { filter = 'near' } }).eminence.filter, 'all', 'saved near goes back to all')
    eq(require('src.core.settings').merge({ eminence = { filter = 'area' } }).eminence.filter, 'all', 'saved area goes back to all')
    -- ピン留め（前の「たたむ」）のボタン
    check(labeled('ピン留め##collapse') or labeled('Pinned only##collapse'), 'pin toggle button')
    check(not labeled('たたむ##collapse') and not labeled('ひらく##collapse'), 'no fold button')
    -- 前の保存が「このエリア」でも、ほかのエリアのものも出る（いつも全部）
    S.eminence.filter = 'area'; FAKE.player.zone = 101; frame(); frame()
    check(texted('Combat: West Ronfaure') and texted('Vanquish Multiple Enemies II'), 'old area setting shows all')
    FAKE.player.zone = 100
    S.eminence.filter = 'all'
    -- ピン留め：★ だけ
    S.eminence.collapsed = true; frame()
    check(labeled('◆ ピン留め##collapse') or labeled('◆ Pinned only##collapse'), 'pin toggle shows on')
    check(not texted('Combat: West Ronfaure'), 'folded hides unstarred')
    S.eminence.pins['215'] = true; frame()
    check(texted('Combat: West Ronfaure') and not texted('Vanquish Multiple Enemies II'), 'folded shows starred')
    S.eminence.collapsed = false
    -- 窓の大きさは文字の大きさで変わらない
    local ws = S.windows.eminence
    local w0, h0 = ws.w, ws.h
    S.fonts.eminence = 1.6; frame(); frame()
    eq(ws.w, w0, 'width kept on font change'); eq(ws.h, h0, 'height kept on font change')
    S.fonts.eminence = 1.0
    app.command('/astertrail eminence hide')
    frame()
    check(not drawn('###astertrail_eminence'), 'hidden')
end

-- 本の「エミネンス」
do
    app.open_window('book')
    S.book.tab = 'eminence'
    frame()
    check(labeled('エミネンス') or labeled('Eminence'), 'eminence tab')
    -- 初めは「すべて」：0.1.189〜 分類の見出しの下にレコード（0.1.182〜0.1.188 は見出しなし）
    check(labeled('##cat_' .. 0xF230), 'subcategory header in すべて')
    frame()
    check(labeled('Vanquish Multiple Enemies I'), 'objective row (name is a link to the detail)')
    local n0 = #INJ
    -- #13 は受けている → 外す、#12 は受けていない（受けられなかった印は消えた）→ 受ける
    check(labeled('##roe_remove_13'), 'drop button for taken')
    check(labeled('解除##roe_remove_13') or labeled('Cancel##roe_remove_13'), 'remove button is labeled 解除 (0.1.177)')
    check(labeled('× 解除##roe_remove_13') or labeled('× Cancel##roe_remove_13'), 'remove has × mark (0.1.203)')
    check(not labeled('外す##roe_remove_13'), 'no 外す label')
    check(labeled('##roe_start_12'), 'take button for not taken')
    check(labeled('＋ 受ける##roe_start_12') or labeled('＋ Take##roe_start_12'), 'accept has ＋ mark (0.1.203)')
    FAKE.clicks['##roe_start_12'] = true; frame()
    eq(#INJ, n0 + 1, 'one press, one packet')
    eq(INJ[#INJ].id, 0x10C); eq(INJ[#INJ].data:byte(5), 12)
    frame(); frame()
    eq(#INJ, n0 + 1, 'drawing again sends nothing')
    -- 分類なし（0.1.203：初期は達成済みを非表示なので、見せるために一度オフにする）
    eq(S.eminence.hide_completed, true, 'hide completed on by default')
    S.eminence.hide_completed = false
    S.eminence.book_root = -1; frame()
    check(labeled('Loose One'), 'loose objective')
    check(texted('［達成］') or texted('[Done]'), 'done tag')
    -- 0.1.203：達成済みでくり返せないものはボタンを出さない（一覧も詳細も）
    check(not labeled('##roe_start_300') and not labeled('##roe_remove_300'),
        'no list button for completed non-repeatable')
    do
        local em = require('src.ui.eminence')
        em.select(300); FAKE.labels = {}; frame()
        check(not labeled('##roed_start_300') and not labeled('##roed_remove_300'),
            'no detail button for completed non-repeatable')
        em.select(nil)
    end
    -- 達成を隠す（くり返しできない達成だけ。0.1.194〜 くり返しできる達成は残す）
    S.eminence.hide_completed = true; frame()
    check(not labeled('Loose One'), 'non-repeatable done is hidden')
    S.eminence.book_root = -2
    local c = st.roe.complete
    check(c ~= nil, 'completion table exists')
    local idx, bit = math.floor(12 / 8) + 1, 2 ^ (12 % 8)
    if math.floor((c[idx] or 0) / bit) % 2 ~= 1 then c[idx] = (c[idx] or 0) + bit end
    check(roe.is_complete(c, 12), '#12 marked complete')
    FAKE.labels = {}; frame(); frame()
    check(labeled('Vanquish Multiple Enemies I'), 'repeatable completed stays visible')
    check(labeled('##roe_start_12'), 'repeatable completed still has accept button')
    check(not labeled('Loose One'), 'non-repeatable completed still hidden')
    S.eminence.hide_completed = false
    -- ビットを戻す（あとの受けられ判定に影響しないように）
    c[idx] = (c[idx] or 0) - bit
    -- 検索
    S.eminence.book_root = 0
    S.eminence.book_text = 'unity'; require('src.ui.eminence').reset_search(); frame()
    check(labeled('Unity Leader A'), 'search finds')
    check(texted('［未実装］') or texted('[Not on this server]'), 'not implemented tag')
    S.eminence.book_text = ''; require('src.ui.eminence').reset_search()
    -- 0.1.182〜（t293）：分類は「すべて」といちばん上の分類だけ（下の分類は出さない）
    FAKE.texts, FAKE.labels = {}, {}
    S.eminence.book_root = require('src.core.settings').defaults().eminence.book_root; frame()
    eq(S.eminence.book_root, -2, 'default is すべて')
    local em0 = require('src.ui.eminence')
    for _, nm in ipairs({ 'Tutorial', 'Combat (Region)' }) do
        check(labeled(nm), 'top category in the combo: ' .. nm)
    end
    do
        local vals = {}
        for _, c in ipairs(em0.root_choices({ settings = S, t = function (k) return k end, state = app.state, roe_db = app.roe_db })) do vals[#vals + 1] = c.value end
        local has = {}
        for _, v in ipairs(vals) do has[v] = true end
        check(not has[0xF230] and not has[0xF259], 'no sub categories in the combo')
    end
    check(labeled('すべて') or labeled('All'), 'すべて in the combo')
    -- すべて：全部のレコード
    check(labeled('Combat: West Ronfaure') and labeled('Vanquish Multiple Enemies II') and labeled('Loose One'), 'すべて shows every record')
    -- いちばん上の分類：下の分類のレコードも入る
    S.eminence.book_root = 0xF212; frame()
    check(labeled('Combat: West Ronfaure') and not labeled('Vanquish Multiple Enemies II'), 'top category includes its sub category records')
    -- 0.1.189〜（t316）：一覧は下の分類の見出しと、その下のレコード（0.1.181 までの形）。見出しは開け閉めできる
    check(labeled('##cat_' .. 0xF259), 'sub category header in the list')
    check(not labeled('##cat_' .. 0xF212), 'no header for the chosen category itself')
    local function label_at(pat) for i, l in ipairs(FAKE.labels) do if l:find(pat, 1, true) then return i end end end
    check(label_at('##cat_' .. 0xF259) < label_at('Combat: West Ronfaure'), 'records under their header')
    FAKE.clicks['##cat_' .. 0xF259] = true; frame(); frame()
    check(labeled('##cat_' .. 0xF259) and labeled('Combat: West Ronfaure'), 'selecting the sub category shows its records')
    FAKE.clicks['##sec_eminence_all'] = true; frame(); frame()
    check(labeled('Combat: West Ronfaure'), 'すべて still includes the sub category records')
    -- すべて：いちばん上の分類の見出し → 下の分類の見出し → レコード、最後に分類なし
    S.eminence.book_root = -2; frame()
    local iT, iB, i12 = label_at('##cat_' .. 0xF210), label_at('##cat_' .. 0xF230), label_at('Vanquish Multiple Enemies I')
    local iC, iO, i215 = label_at('##cat_' .. 0xF212), label_at('##cat_' .. 0xF259), label_at('Combat: West Ronfaure')
    local iL, iLo = label_at('##cat_loose'), label_at('Loose One')
    check(iT and iB and i12 and iC and iO and i215 and iL and iLo, 'すべて: headers and records')
    check(iT < iB and iB < iC and iC < iO and iO < iL, 'tree headings: top then sub then loose')
    check(iL < i12 and i12 < i215 and i215 < iLo, 'table records follow the tree, in heading order')
    FAKE.clicks['##tw_cat_' .. 0xF210] = true; frame(); frame()
    check(not labeled('##cat_' .. 0xF230), 'すべて: collapsing a top heading hides its sub headings')
    FAKE.clicks['##tw_cat_' .. 0xF210] = true; frame(); frame()
    check(labeled('##cat_' .. 0xF230) and labeled('Vanquish Multiple Enemies I'), 'すべて: top heading opens again')

    -- 前の保存が下の分類なら「すべて」
    S.eminence.book_root = 0xF259; FAKE.labels = {}; frame()
    check(labeled('Combat: West Ronfaure') and labeled('Vanquish Multiple Enemies II'), 'old sub category falls back to すべて')
    S.eminence.book_root = 0xF210; FAKE.labels = {}; frame()
    check(labeled('Vanquish Multiple Enemies I') and not labeled('Combat: West Ronfaure'), 'records under a top category')
    -- 窓の出す・隠すのボタンは本のエミネンスには無い（上の行のボタンだけ）
    check(not labeled('##roe_window'), 'no window toggle in the eminence tab')
    S.eminence.book_root = 0xF210; frame()
    -- 右の詳細：名前を押すと出す
    local em = require('src.ui.eminence')
    check(texted('一覧の名前を押すと') or texted('Select a name'), 'detail hint before selecting')
    FAKE.clicks['##roesel_12'] = true; frame(); frame()
    eq(em.selected(), 12, 'name press selects')
    check(texted('Defeat enemies.'), 'detail description from DAT')
    check(texted('Test Primer\n(You may only hold one.)'), 'detail special reward')
    check(texted('100EMI 500EXP'), 'detail rewards (EMI/EXP)')
    check(texted('/200'), 'detail count when not accepted')
    check(texted('＜繰り返し可＞') or texted('<Repeatable>'), 'repeatable mark')
    check(labeled('##roed_start_12'), 'accept button in the detail')
    em.select(13); frame()
    check(texted('0/500'), 'detail count progress/target when accepted')
    check(texted('＜繰り返し不可＞') or texted('<Not repeatable>'), 'not repeatable mark')
    check(labeled('##roed_remove_13'), 'remove button in the detail')
    -- 特別報酬が無い：見出しだけで中身は空（ほかのものの特別報酬を出さない）
    check((texted('特別報酬') or texted('Special reward')) and not texted('Test Primer\n(You may only hold one.)'),
        'special reward blank when the DAT has none')
    -- 詳細のボタンも押したときに 1 回だけ
    local n1 = #INJ
    FAKE.clicks['##roed_remove_13'] = true; frame()
    eq(#INJ, n1 + 1, 'detail press, one packet')
    frame(); frame()
    eq(#INJ, n1 + 1, 'no repeat')
    -- ★：一覧で付けて、「★だけ」で分類によらず出す
    S.eminence.pins = {}
    FAKE.clicks['##roe_fav_215'] = nil
    S.eminence.book_root = 0xF212; frame()
    FAKE.clicks['##roe_fav_215'] = true; frame()
    eq(S.eminence.pins['215'], true, 'star from the book list')
    S.eminence.book_root = 0xF210; frame()
    FAKE.clicks['##roe_fav_12'] = true; frame()
    eq(S.eminence.pins['12'], true, 'second star')
    local n2 = #INJ
    eq(n2, n1 + 1, 'starring sends nothing')
    -- 0.1.182〜（t294）：お気に入り（♥ の絵）は ★ と別。本だけで使う
    S.eminence.favs = {}
    FAKE.labels = {}; frame()
    check(labeled('##roe_heart_12') and labeled('##roe_fav_12'), 'heart button next to the star')
    FAKE.clicks['##roe_heart_12'] = true; frame()
    eq(S.eminence.favs['12'], true, 'favorite from the book list')
    S.eminence.book_root = 0xF212; frame()
    FAKE.clicks['##roe_heart_215'] = true; frame()
    eq(S.eminence.favs['215'], true, 'second favorite')
    FAKE.clicks['##roe_fav_215'] = true; frame()
    eq(S.eminence.pins['215'], nil, 'unstar keeps the favorite'); eq(S.eminence.favs['215'], true, 'favorite stays')
    FAKE.clicks['##roe_fav_215'] = true; frame()
    eq(S.eminence.pins['215'], true, 'star again')
    FAKE.clicks['##roe_heart_12'] = nil
    eq(#INJ, n2, 'favorites send nothing')
    S.eminence.book_favs_only = true; FAKE.texts = {}; FAKE.labels = {}; frame(); frame()
    check(texted('お気に入り') or texted('Favorites'), 'favorites chip')
    check(not texted('★だけ') and not texted('★ only'), 'no star-only chip')
    check(labeled('Combat: West Ronfaure') and labeled('Vanquish Multiple Enemies I'), 'favorites from all categories')
    check(not labeled('Vanquish Multiple Enemies II') and not labeled('Unity Leader A'), 'others hidden')
    -- ★ を外しても、お気に入りの表示は変わらない（★ は窓のピンだけ）
    S.eminence.pins = {}; FAKE.labels = {}; frame()
    check(labeled('Combat: West Ronfaure') and labeled('Vanquish Multiple Enemies I'), 'favorites do not follow stars')
    -- そこから受ける・解除（1回押すと1回）
    -- #215 は受けている → 解除、#12 は受けていない → 受ける（入れ替えがお気に入りの表示で済む）
    check(labeled('##roe_remove_215') and labeled('##roe_start_12'), 'remove/accept from favorites view')
    FAKE.clicks['##roe_remove_215'] = true; frame()
    eq(#INJ, n2 + 1, 'one press from favorites view, one packet')
    frame(); frame()
    eq(#INJ, n2 + 1, 'favorites view sends nothing by itself')
    -- お気に入りが無ければ説明
    S.eminence.favs = {}; frame()
    check(texted('お気に入りがありません。一覧のハートの印を押すと入ります。') or texted('No favorites yet'), 'no favorites message')
    S.eminence.book_favs_only = false; frame()
    -- 設定に残る。前の ★ はピンのまま、お気に入りは空から
    local smod = require('src.core.settings')
    local m2 = smod.merge({ eminence = { book_fav_only = true, pins = { ['12'] = true } } })
    eq(m2.eminence.pins['12'], true, 'old star stays a pin')
    eq(next(m2.eminence.favs), nil, 'favorites start empty')
    eq(m2.eminence.book_favs_only, false, 'favorites filter off at first')
    eq(m2.eminence.book_fav_only, nil, 'old star-only setting dropped')
    local m3 = smod.merge({ eminence = { favs = { ['12'] = true, x = true }, book_favs_only = 1 } })
    eq(m3.eminence.favs['12'], true, 'favorite saved'); eq(m3.eminence.favs.x, nil, 'bad favorite dropped')
    eq(m3.eminence.book_favs_only, false, 'bad favorites-only value')
    S.eminence.book_root = 0
    -- ほかのタブはそのまま
    S.book.tab = 'quest'; frame()
    check(not labeled('##roe_start_12'), 'quest tab has no eminence rows')
end

-- 0.1.203〜：受ける／解除や 0x111、ゲームのミッションメニューで、選択がミッションに戻らない
do
    local em = require('src.ui.eminence')
    S.eminence.book_root = -2
    S.eminence.book_favs_only = false
    S.eminence.hide_completed = false
    S.book.tab = 'eminence'
    app.open_window('book')
    em.select(12)
    S.eminence.last_id = 12
    S.book.scroll = S.book.scroll or {}
    S.book.scroll.eminence = 96
    FAKE.scroll_y = FAKE.scroll_y or {}
    FAKE.scroll_y['##astertrail_roe_list'] = 96
    frame(); frame()
    eq(S.book.tab, 'eminence', 'on eminence')
    eq(em.selected(), 12, 'selected #12')
    eq(S.book.scroll.eminence, 96, 'scroll kept before action')
    -- 受ける／解除のあとにゲームが missionm を開いたように見えても、タブも選択も縦位置も動かない
    FAKE.clicks['##roe_start_12'] = true
    FAKE.clicks['##roe_remove_12'] = true
    frame()
    app.state.pending_book = 'mission'
    frame(); frame()
    eq(S.book.tab, 'eminence', 'accept/remove + mission menu: tab stays eminence')
    eq(em.selected(), 12, 'accept/remove + mission menu: same record')
    eq(S.book.scroll.eminence, 96, 'accept/remove + mission menu: same scroll')
    -- 0x111 で一覧が描き直されても同じ
    FAKE.events.packet_in({ id = 0x111, data = act_packet({ [1] = { 12, 10 }, [2] = { 215, 9 } }) })
    frame(); frame()
    eq(S.book.tab, 'eminence', '0x111: tab stays')
    eq(em.selected(), 12, '0x111: same record')
    eq(S.book.scroll.eminence, 96, '0x111: same scroll')
    -- 閉じて開き直す。モジュール内の選択を消しても、保存した番号に戻る
    app.close_window('book'); frame()
    em.select(nil)
    FAKE.scroll_y['##astertrail_roe_list'] = 0
    app.open_window('book'); frame(); frame(); frame()
    eq(S.book.tab, 'eminence', 'reopen: eminence tab')
    eq(em.selected(), 12, 'reopen: last record from saved last_id')
    eq(FAKE.scroll_y['##astertrail_roe_list'], 96, 'reopen: last scroll')
    -- 隠れた番号は先頭へ
    S.eminence.book_favs_only = true
    S.eminence.favs = {}
    S.eminence.last_id = 12
    em.select(12)
    frame(); frame()
    eq(em.selected(), nil, 'hidden record: no selection when the list is empty')
    S.eminence.book_favs_only = false
    frame()
end

-- ゲームのメニューが送った 0x10C を比べる（読むだけ）
do
    local n0 = #INJ
    FAKE.events.packet_out({ id = 0x10C, data = string.char(0x0C, 0x05, 0x34, 0x12, 13, 0, 0, 0) })
    eq(st.roe.game_sent.same, true, 'game menu packet matches ours')
    FAKE.events.packet_out({ id = 0x10C, data = string.char(0x0C, 0x07, 0x34, 0x12, 13, 0, 0, 0, 0, 0, 0, 0) })
    eq(st.roe.game_sent.same, false, 'different size is reported')
    FAKE.events.packet_out({ id = 0x10C, data = string.char(0x0C, 0x05, 0, 0, 13, 0, 0, 0), injected = true })
    eq(st.roe.game_sent.same, false, 'own injected packet is not taken as the game menu')
    eq(#INJ, n0, 'watching sends nothing')
    app.command('/astertrail roe')
    check(printed('Eminence') or printed('エミネンス'), 'roe status printed')
end

-- 公式の送る窓口が無ければ送らない
do
    local keep = vana.packets.inject
    vana.packets.inject = nil
    local r = app.roe_send('start', 13)
    check(not r.ok, 'no api: not sent')
    vana.packets.inject = keep
end

-- 窓のピンとしぼり込みは保存して戻る
do
    local m = require('src.core.settings').merge({ eminence = { filter = 'bogus', near_pct = 3, pins = { ['12'] = true, x = true, ['5000'] = true } } })
    eq(m.eminence.filter, 'all', 'bad filter')
    eq(m.eminence.book_root, -2, 'book category defaults to すべて')
    eq(m.eminence.near_pct, 50, 'near pct clamped')
    eq(m.eminence.pins['12'], true, 'pin kept'); eq(m.eminence.pins.x, nil, 'bad key dropped'); eq(m.eminence.pins['5000'], nil, 'out of range dropped')
end
-- 設定のエミネンスのタブ（最後の「このアドオンについて」の前）
do
    local sui = require('src.ui.settings_ui')
    app.open_window('settings'); frame()
    sui.select_tab('eminence'); frame(); frame()
    eq(sui.current_tab(), 'eminence', 'settings tab')
    -- 0.1.182〜（t293）：窓を出すスイッチは設定に無い（本の上の行のボタンだけ）
    check(not labeled('エミネンスの窓を出す') and not labeled('Show the Eminence window') and not labeled('##roe_vis'), 'no window switch in settings')
    check(labeled('##roe_fold'), 'other eminence settings stay')
    sui.cycle_tab(1); frame(); frame()
    eq(sui.current_tab(), 'about', 'about stays last')
    app.close_window('settings'); frame()
end
-- 0.1.177〜：設定の「見た目」にエミネンスの窓の文字サイズ・背景の濃さ（まだ無い保存はトラッカーの値）
do
    local smod = require('src.core.settings')
    local m = smod.merge({ fonts = { tracker = 1.4 }, alphas = { tracker = 0.6 } })
    eq(m.fonts.eminence, 1.4, 'eminence font inherits tracker on old saves')
    eq(m.alphas.eminence, 0.6, 'eminence background inherits tracker on old saves')
    local m2 = smod.merge({ fonts = { tracker = 1.4, eminence = 0.9 }, alphas = { tracker = 0.6, eminence = 1.0 } })
    eq(m2.fonts.eminence, 0.9, 'own eminence font kept'); eq(m2.alphas.eminence, 1.0, 'own eminence background kept')
    eq(smod.alpha_for(m2, 'eminence'), 1.0, 'window uses its own background')
    eq(smod.alpha_for(m2, 'compass'), 0.6, 'compass still follows the tracker')
    eq(require('src.ui.window').FONT_AREA.eminence, 'eminence', 'window uses its own font size')
    local sui = require('src.ui.settings_ui')
    app.open_window('settings'); frame()
    sui.select_tab('look'); frame(); frame()
    check(labeled('##font_eminence') or texted('文字サイズ（エミネンス）'), 'eminence font in 見た目')
    check(labeled('##alpha_eminence') or texted('背景の濃さ（エミネンス）'), 'eminence background in 見た目')
    app.close_window('settings'); frame()
end
-- 0.1.193〜：本のエミネンスの一覧は分類ごとに表（見出しは表の外）。くり返しの列は無し。詳細は右のまま
-- （t318）ハートは ☆ と同じ箱の大きさ（文字の大きさに合わせる）
do
    local im = require('imgui')
    local em = require('src.ui.eminence')
    app.open_window('book')
    S.book.tab = 'eminence'
    S.eminence.book_root = -2; S.eminence.book_text = ''; S.eminence.book_favs_only = false
    em.reset_search()
    FAKE.table = true
    FAKE.tables = {}
    local sizes = {}
    local ob, ofs, octs = im.Button, rawget(im, 'GetFontSize'), rawget(im, 'CalcTextSize')
    im.Button = function (label, size)
        if type(label) == 'string' and label:find('##roe_heart_', 1, true) then sizes[#sizes + 1] = size end
        return ob(label, size)
    end
    local FS = 20
    im.GetFontSize = function () return FS end
    im.CalcTextSize = function (s) return 18, FS end
    FAKE.texts, FAKE.labels = {}, {}
    frame(); frame()
    local found, any_id
    for _, tb in ipairs(FAKE.tables or {}) do
        if type(tb.id) == 'string' and tb.id:find('##astertrail_roe_table', 1, true) then
            found = found or tb
            any_id = tb.id
        end
    end
    check(found ~= nil, 'eminence list is a table')
    eq(found and found.cols, 6, 'six columns (no くり返し, no 状態 since 0.1.209)')
    for _, h in ipairs({ '名前', '進み', '報酬', '★', 'お気に入り', '受ける・解除' }) do
        check(texted(h), 'column header: ' .. h)
    end
    check(not texted('くり返し'), 'no くり返し column header')
    local function at(pat) for i, l in ipairs(FAKE.labels) do if l:find(pat, 1, true) then return i end end end
    check(at('##cat_' .. 0xF210) and at('##cat_' .. 0xF230) and at('##roesel_12'), 'group headers and records')
    check(at('##cat_' .. 0xF230) < at('##roesel_12'), 'records under the group heading')
    local act = at('##roe_start_12') or at('##roe_remove_12')
    check(act, 'take/drop button in the row')
    check(act < at('##roe_fav_12') and at('##roe_fav_12') < at('##roe_heart_12') and at('##roe_heart_12') < at('##roesel_12'),
        'action, ★, ♥, name in this order (0.1.203 default)')
    check(texted('/200') or texted('/500'), 'progress column')
    check(texted('100EMI 500EXP'), 'rewards column')
    check(texted('表示：') or texted('Show:'), 'view filter label')
    check(texted('｜'), 'separator between view and columns')
    check(texted('列：') or texted('Columns:'), 'columns label')
    do
        local focus = require('src.ui.focus')
        local function has(id)
            for _, it in ipairs((focus.windows.book and focus.windows.book.list) or {}) do
                if it.id == id then return true end
            end
        end
        check(has('roe_col_name') and not has('roe_col_state'), 'eminence column chips (no state chip since 0.1.209)')
    end
    -- 名前を押すと右に詳細
    FAKE.clicks['##roesel_12'] = true; frame(); frame()
    eq(em.selected(), 12, 'row selects')
    check(texted('Defeat enemies.'), 'detail stays on the right')
    -- ハート：☆ と同じ箱（高さ＝文字の高さ、幅＝☆ の幅＋余白）
    check(#sizes > 0, 'heart buttons drawn')
    local sz = sizes[#sizes]
    eq(sz[2], 20, 'heart box height = font size like ☆')
    eq(sz[1], 18 + 16, 'heart box width = ☆ width + padding')
    FS = 30; sizes = {}; frame()
    eq(sizes[#sizes][2], 30, 'heart scales with the font')
    -- 別の分類を選ぶと、その分類に無い行は表から消える
    -- 0xF210 は Tutorial で、Basics (0xF230) の親。親を選ぶと子の行も出る。
    -- 12 を含まない別系統（Combat Region）を選ぶと行は消える。
    FAKE.clicks['##cat_' .. 0xF212] = true; frame(); frame()
    check(not labeled('##roesel_12'), 'selecting another category hides its rows')
    FAKE.clicks['##cat_' .. 0xF230] = true; frame(); frame()
    check(labeled('##roesel_12'), 'selecting the category shows its rows again')
    FAKE.clicks['##sec_eminence_all'] = true; frame(); frame()
    check(labeled('##roesel_12'), 'すべて shows rows from every category')
    -- 表がこけたら 1 行ずつの形
    FAKE.table_error = true; frame(); frame()
    check(labeled('##roesel_12'), 'falls back to plain rows')
    FAKE.table_error = nil; em.table_failed = nil
    im.Button, im.GetFontSize, im.CalcTextSize = ob, ofs, octs
    FAKE.table = false
    app.close_window('book'); frame()
end
print('test_eminence ok')
