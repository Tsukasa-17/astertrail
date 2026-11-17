-- ゲームのクエスト・ミッションの記録（0.1.169〜、t223）と、公開版の切り替え（t225）
require('fake_env')
local json = require('src.lib.json')
local gl = require('src.core.game_log')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local D = data_mod.load(posix_fs(), ROOT .. '/data/')

-- 32 バイト（u32 8 個）を立てたビットから作る
local function words_with(bits)
    local w = { 0, 0, 0, 0, 0, 0, 0, 0 }
    for _, n in ipairs(bits or {}) do
        local i = math.floor(n / 32) + 1
        w[i] = w[i] + 2 ^ (n % 32)
    end
    return w
end
local function u32s(v)
    v = v % 4294967296
    return string.char(v % 256, math.floor(v / 256) % 256, math.floor(v / 65536) % 256, math.floor(v / 16777216) % 256)
end
-- 0x056 の通信（頭 4 バイト＋32 バイト＋Port 2 バイト＋埋め）
local function packet(port, words)
    local s = string.char(0x56, 0x14, 0x01, 0x00)
    for i = 1, 8 do s = s .. u32s(words[i] or 0) end
    return s .. string.char(port % 256, math.floor(port / 256)) .. string.char(0, 0)
end

-- 通信を読む
do
    local p, w = gl.parse_packet(packet(0x58, words_with({ 14, 40 })))
    eq(p, 0x58, 'port'); check(gl.bit_on(w, 14) and gl.bit_on(w, 40) and not gl.bit_on(w, 15), 'bits')
    -- 実機で届いた 0x056（2026-11-16、GAME-PC、40 バイト、Port 0xFFFE）
    local hex = '56 14 09 00' .. string.rep(' 00', 32) .. ' FE FF 00 00'
    local live = hex:gsub('%s*(%x%x)', function (h) return string.char(tonumber(h, 16)) end)
    eq(#live, 40, 'live packet size')
    local lp, lw = gl.parse_packet(live)
    eq(lp, 0xFFFE, 'live packet port'); eq(lw[1], 0, 'live packet tvr')
    eq(gl.parse_packet('short'), nil, 'short packet')
    eq(gl.parse_packet(string.char(0x55, 0x14, 0, 0) .. string.rep('\0', 36)), nil, 'other id')
end

-- クエスト：両方そろってから。受注中が先、次に完了、どちらもなければ未受注
do
    local s = gl.new_snapshot()
    eq(gl.state_of(s, { 'q', 1, 14 }), nil, 'nothing received')
    gl.apply_port(s, 0x58, words_with({ 14 }))
    eq(gl.state_of(s, { 'q', 1, 14 }), nil, 'only current log')
    gl.apply_port(s, 0x98, words_with({ 14, 20 }))
    eq(gl.state_of(s, { 'q', 1, 14 }), 'accepted', 'current wins (repeat)')
    eq(gl.state_of(s, { 'q', 1, 20 }), 'completed', 'completed')
    eq(gl.state_of(s, { 'q', 1, 21 }), 'not_accepted', 'neither')
    gl.apply_port(s, 0x80, words_with({ 5 })); gl.apply_port(s, 0xC0, words_with({}))
    eq(gl.state_of(s, { 'q', 6, 130 }), nil, 'aht urhgan upper half is not quests')
    eq(gl.port_count(s), 4, 'port count')
end

-- ミッション
do
    local s = gl.new_snapshot()
    -- 0xFFFF：所属国 1、今のミッションなし、ジラート 6、プロマシア 0、追加 ACP1 AMK1 ASA2、始めない印 8、SoA・RoV の生の値
    gl.apply_port(s, 0xFFFF, { 1, 0xFFFF, 6, 0, 0, 1 + 1 * 16 + 2 * 256 + 8 * 65536, 0x6E + 2 * 2, 0x6C + 3 })
    eq(gl.state_of(s, { 'm', 1, 0 }), nil, 'nation needs completed log')
    gl.apply_port(s, 0xD0, words_with({ 64 + 0, 64 + 5, 192 + 0, 192 + 4 }))
    eq(gl.state_of(s, { 'm', 1, 0 }), 'completed', 'bastok 0 completed')
    eq(gl.state_of(s, { 'm', 1, 7 }), 'not_accepted', 'bastok 7 not')
    eq(gl.state_of(s, { 'm', 3, 6 }), 'accepted', 'zilart current')
    eq(gl.state_of(s, { 'm', 3, 4 }), 'completed', 'zilart done bit')
    eq(gl.state_of(s, { 'm', 3, 8 }), 'not_accepted', 'zilart later')
    local cop = { ids = { 101, 110, 118 }, ordered = false }
    eq(gl.state_of(s, { 'm', 6, 110 }, cop), nil, 'cop declined')
    local acp = { ids = { 0, 1, 2, 3 }, ordered = true }
    eq(gl.state_of(s, { 'm', 9, 0 }, acp), 'completed', 'acp before current')
    eq(gl.state_of(s, { 'm', 9, 1 }, acp), 'accepted', 'acp current')
    eq(gl.state_of(s, { 'm', 9, 2 }, acp), 'not_accepted', 'acp later')
    eq(gl.state_of(s, { 'm', 11, 2 }, acp), 'accepted', 'asa current')
    eq(gl.state_of(s, { 'm', 9, 1 }, nil), nil, 'no id list: unknown')
    eq(gl.state_of(s, { 'm', 12, 2 }, { ids = { 0, 1, 2, 3 }, ordered = true }), 'accepted', 'soa raw decoded')
    eq(gl.state_of(s, { 'm', 13, 2 }, { ids = { 0, 1, 2, 3, 4 }, ordered = true }), 'completed', 'rov raw decoded')
    -- プロマシア（道が分かれる）：今のミッションだけ受注中。前後は分からない
    gl.apply_port(s, 0xFFFF, { 1, 0xFFFF, 6, 118, 0, 0, 0x6E, 0x6C })
    eq(gl.state_of(s, { 'm', 6, 118 }, cop), 'accepted', 'cop current')
    eq(gl.state_of(s, { 'm', 6, 110 }, cop), nil, 'cop earlier unknown (not ordered)')
    eq(gl.state_of(s, { 'm', 9, 0 }, acp), nil, 'acp at first id: unknown')
    -- 所属国の今のミッション
    gl.apply_port(s, 0xFFFF, { 1, 7, 6, 0, 0, 0, 0x6E, 0x6C })
    eq(gl.state_of(s, { 'm', 1, 7 }), 'accepted', 'nation current')
    eq(gl.state_of(s, { 'm', 0, 7 }), 'not_accepted', 'other nation not current')
    -- アトルガン：完了 0xD8 と、アトルガンの受注中ログのワード 5
    gl.apply_port(s, 0x80, { 0, 0, 0, 0, 3, 2, 0, 0 })
    gl.apply_port(s, 0xC0, words_with({ 128 + 1 }))
    gl.apply_port(s, 0xD8, words_with({ 0, 1 }))
    eq(gl.state_of(s, { 'm', 4, 0 }), 'completed', 'toau 0 completed')
    eq(gl.state_of(s, { 'm', 4, 2 }), 'accepted', 'toau current')
    eq(gl.state_of(s, { 'm', 4, 5 }), 'not_accepted', 'toau later')
    eq(gl.state_of(s, { 'm', 7, 3 }), 'accepted', 'assault current')
    eq(gl.state_of(s, { 'm', 7, 1 }), 'completed', 'assault done bit')
    eq(gl.state_of(s, { 'm', 7, 2 }), 'not_accepted', 'assault not')
    gl.apply_port(s, 0x80, { 0, 0, 0, 0, 0, 0, 0, 0 })
    gl.apply_port(s, 0xD8, words_with({}))
    eq(gl.state_of(s, { 'm', 4, 0 }), nil, 'toau first mission: unknown')
end

-- ゲームが写した場所の並び（受注中 11 → 完了 11 → ミッション完了 4 → 今のミッション → 届いた印）
local function fake_memory(C, opts)
    opts = opts or {}
    local m = {}
    local P, M = C + 0x160, C + 0x2C0
    local main = M + 0x80
    for i, v in pairs(opts.cur or {}) do m[C + i * 32 + v[1] * 4] = v[2] end
    for i, v in pairs(opts.done or {}) do m[P + i * 32 + v[1] * 4] = v[2] end
    for i, v in pairs(opts.mdone or {}) do m[M + i * 32 + v[1] * 4] = v[2] end
    m[main] = 6; m[main + 4] = 0xFFFF + 1 * 65536; m[main + 8] = 0; m[main + 0x0C] = 0
    m[main + 0x10] = 1 + 16 + 512; m[main + 0x14] = 110; m[main + 0x18] = 134; m[main + 0x1C] = 0; m[main + 0x20] = 8
    m[main + 0x24] = opts.mask or gl.ALL_RECEIVED
    return function (a) return m[a] or 0 end
end
do
    local rd = fake_memory(0x10000000, { cur = { [1] = { 0, 2 ^ 14 } }, done = { [1] = { 1, 2 ^ (52 - 32) } }, mdone = { [0] = { 2, 1 } } })
    local s, mask = gl.from_memory(rd, 0x10000000)
    eq(mask, gl.ALL_RECEIVED, 'mask')
    eq(gl.state_of(s, { 'q', 1, 14 }), 'accepted', 'mem: current quest')
    eq(gl.state_of(s, { 'q', 1, 52 }), 'completed', 'mem: completed quest')
    eq(gl.state_of(s, { 'm', 1, 0 }), 'completed', 'mem: bastok mission 0')
    eq(s.main.nation, 1, 'mem: nation'); eq(s.main.zilart, 6, 'mem: zilart'); eq(s.main.asa, 2, 'mem: asa')
    eq(s.main.declined, 8, 'mem: declined')
    eq(gl.port_count(s), 27, 'mem: 26 logs + main')
    -- 届いていない欄は入れない
    local s2 = gl.from_memory(fake_memory(0x10000000, { mask = 1 + 2 ^ 11 }), 0x10000000)
    check(s2.cur[0] and s2.done[0] and not s2.cur[1] and not s2.main, 'partial mask')
end

-- 資料との対応
do
    check((D.game_ref_count or 0) > 1000, 'game refs loaded: ' .. tostring(D.game_ref_count))
    eq(json.encode(D:game_ref('quest.bastok.002')), json.encode({ 'q', 1, 14 }), 'ref quest.bastok.002')
    check(D.game_mission_info[9] and D.game_mission_info[9].ordered, 'acp ordered')
    check(D.game_mission_info[6] and not D.game_mission_info[6].ordered, 'cop not ordered')
    for qid, r in pairs(D.game_refs) do check(D:quest(qid) ~= nil, 'ref to known entry ' .. qid) end
end

-- 進行：ゲームの記録が正しい。手順のチェックは消さない
do
    local who = { server = 'catseye', name = 'Test' }
    local kinds = {}
    local P = progress.new({ data = D, on_change = function (k) kinds[#kinds + 1] = k end })
    P:reset(who)
    local qid = 'quest.bastok.002'
    local q = D:quest(qid)
    check(P:set_state(qid, 'accepted').ok, 'manual accept')
    check(P:check_step(qid, q.steps[1].id, true).ok, 'manual step check')
    check(P:pin(qid).ok, 'pin')
    local ch, before = P:apply_game(qid, 'completed')
    check(ch and before == 'accepted', 'game completes')
    eq(P:state(qid), 'completed', 'state completed')
    eq(P:record(qid).state_source, 'game', 'source game')
    check(P:step_done(qid, q.steps[1].id), 'step check kept')
    check(not P:is_pinned(qid), 'unpinned on game completion')
    eq(#P:record(qid).cycles, 1, 'one cycle'); eq(P:record(qid).cycles[1].source, 'game', 'cycle source')
    check(not P:apply_game(qid, 'completed'), 'same state: no change')
    eq(#P:record(qid).cycles, 1, 'no double cycle')
    -- ゲームで未受注なら、手で付けた完了も未受注へ（手順のチェックは残す）
    check(P:apply_game(qid, 'not_accepted'), 'game says not accepted')
    eq(P:state(qid), 'not_accepted', 'manual completed overwritten')
    check(P:step_done(qid, q.steps[1].id), 'step check still kept')
    -- 記録がなく、ゲームでも未受注なら記録を作らない
    check(not P:apply_game('quest.bastok.003', 'not_accepted'), 'no record created')
    eq(P:record('quest.bastok.003'), nil, 'still none')
    local h = P:snapshot().history
    eq(#h, 2, 'history 2'); eq(h[1].source, 'game', 'history source')
    eq(kinds[#kinds], 'game', 'save scheduled')
    P:set_read_only('broken')
    check(not P:apply_game(qid, 'accepted'), 'read only: no change')
end

-- 本体：読み込み・ログインで読み直し、届いた 0x056 はすぐ当てる（送る口は使わない）
dofile(ROOT .. '/astertrail.lua')
check(FAKE.events.packet_in, 'packet_in registered')
FAKE.events.load()
local app = require('src.app')
local platform = require('src.platform.ashita')
local reads = 0
local mem_cur = {}          -- ゲームが写した受注中（バストゥーク）
local mem_has_cur = true    -- 受注中の欄が届いているか
platform.quest_log_snapshot = function ()
    reads = reads + 1
    local s = gl.new_snapshot(); s.source = 'memory'
    if mem_has_cur then gl.apply_port(s, 0x58, words_with(mem_cur)) end
    gl.apply_port(s, 0x98, words_with({ 52 }))
    return s, gl.ALL_RECEIVED
end
FAKE.player = { name = 'Gamelog', zone = 234, tidx = 5, status = 0 }
frames(1)
check(app.state.ready, 'logged in')
check(reads >= 1, "read on login")
local PR = app._progress()
local q52
for qid, r in pairs(app._data().game_refs) do if r[1] == 'q' and r[2] == 1 and r[3] == 52 then q52 = qid end end
check(q52 ~= nil, 'a mapped bastok quest 52')
eq(PR:state(q52), 'completed', 'memory read applied')
local qid = 'quest.bastok.002'
eq(PR:state(qid), 'not_accepted', 'not yet')
-- 受注の通信（ほかの通信・足した通信は見ない）
FAKE.events.packet_in({ id = 0x056, data = packet(0x58, words_with({ 14 })), injected = true })
FAKE.events.packet_in({ id = 0x055, data = packet(0x58, words_with({ 14 })) })
frames(1)
eq(PR:state(qid), 'not_accepted', 'injected / other id ignored')
FAKE.events.packet_in({ id = 0x056, data = packet(0x58, words_with({ 14 })) })
frames(1)
eq(PR:state(qid), 'accepted', 'packet applied')
eq(PR:record(qid).state_source, 'game', 'from game')
-- ゾーンが変わると読み直す。写した場所に届いていない欄は、届いた通信の分を残す
local before = reads
mem_has_cur = false
FAKE.player.zone = 235
frames(7)
check(reads > before, 're-read after zone change')
eq(PR:state(qid), 'accepted', 'packet data kept when memory lacks the log')
-- 写した場所の中身が正しい（ゲームで受注を取り消した等）
mem_has_cur = true; mem_cur = {}
FAKE.player.zone = 236
frames(7)
eq(PR:state(qid), 'not_accepted', 'memory is the truth after re-read')
mem_cur = { 14 }
check(cmd('/astertrail gamelog read'), 'gamelog read')
eq(PR:state(qid), 'accepted', 'command re-read')
check(cmd('/astertrail gamelog'), 'gamelog command')
check(printed('ゲームの記録') or printed('Game log'), 'gamelog printed')

-- 公開版の切り替え（t225）：手で状態・チェックを変える操作を受けない。今の手順を選ぶのは残す
local flags = require('src.build_flags')
eq(flags.public, true, 'this build is the public build')
local q = app._data():quest(qid)
app.PUBLIC = true
eq(app.request('set_state', qid, 'completed').code, 'public_build', 'public: no set_state')
eq(app.request('check_step', qid, q.steps[1].id).code, 'public_build', 'public: no check_step')
eq(app.request('uncheck_step', qid, q.steps[1].id).code, 'public_build', 'public: no uncheck_step')
check(app.request('pin', qid).ok, 'public: pin still works')
check(app.request('set_current_step', qid, q.steps[1].id).ok, 'public: current step still works')
eq(PR:state(qid), 'accepted', 'public: state unchanged')
app.open_detail_solo(qid); frame(); frame()
check(not labeled('◇') and not labeled('◆'), 'public: no state buttons')
check(not labeled('□') and not labeled('■'), 'public: no step check buttons')
app.PUBLIC = false
frame(); frame()
check(not labeled('◇') and not labeled('◆'), 'debug build: state buttons hidden until the debug setting (0.1.187)')
check(cmd('/astertrail debug buttons on'), 'debug buttons command')
frame(); frame()
check(labeled('◇') or labeled('◆'), 'debug: state buttons shown')
check(app.request('set_state', qid, 'completed').ok, 'debug: manual set_state works')
