-- 0.1.305：エミネンスの一覧を、ゲームの目標一覧と同じにする。
-- DAT の子の印（1＝前の目標の達成、4＝エリアに行ったこと）を目標と分類の両方で見て、まだ出ていないものを隠す。
-- 行ったエリアは 0x008（届いたもの・最後に届いたもの・キャラの保存）。達成の表か行ったエリアが無ければ何も隠さない。
require('fake_env')
local roe = require('src.core.roe')
local settings = require('src.core.settings')
local json = require('src.lib.json')

local function bitset(t, id) local i = math.floor(id / 8) + 1; t[i] = (t[i] or 0) + 2 ^ (id % 8) end
local function u32le(n) return string.char(n % 256, math.floor(n / 256) % 256, math.floor(n / 65536) % 256, math.floor(n / 16777216) % 256) end
local function visited_of(zones)
    local v = {}
    for i = 1, 38 do v[i] = 0 end
    for _, z in ipairs(zones) do bitset(v, z) end
    return v
end
local function pkt008(zones, junk)
    local v = visited_of(zones)
    local s = string.char(0x08, 0x1A, 0, 0)   -- 頭（番号 0x008、大きさ）
    for i = 1, 38 do s = s .. string.char(v[i]) end
    for _ = 1, 10 do s = s .. string.char(junk or 0) end   -- LSB は後ろ 10 バイトにごみを写す
    return s
end

---------------------------------------------------------------------------
-- 0x008 と行ったエリア
---------------------------------------------------------------------------
local v = roe.parse_visited(pkt008({ 0, 230, 261, 303 }, 0xFF))
check(v ~= nil, 'parse 0x008')
eq(#v, 38, 'only 38 bytes (zones 0-303)')
eq(roe.has_visited(v, 230), true, 'visited 230'); eq(roe.has_visited(v, 261), true, 'visited 261')
eq(roe.has_visited(v, 303), true, 'visited 303'); eq(roe.has_visited(v, 100), false, 'not visited 100')
eq(roe.has_visited(v, 304), nil, '304+ unknown (garbage bytes ignored)')
eq(roe.parse_visited(string.char(0x09, 0x1A, 0, 0) .. string.rep('\0', 48)), nil, 'other packet id rejected')
eq(roe.parse_visited('short'), nil, 'short rejected')
local hex = roe.visited_hex(v)
eq(#hex, 76, 'hex 76 chars')
eq(roe.visited_hex(roe.visited_from_hex(hex)), hex, 'hex round trip')
eq(roe.visited_from_hex('zz'), nil, 'bad hex')

---------------------------------------------------------------------------
-- 分類の DAT：子の印を種類と値で残す（目標にも分類にも）
---------------------------------------------------------------------------
do
    -- roe.slot_size に合う 1 つ分の大きさの DAT を作るのは重いので、parse_categories の子の読み方だけ確かめる
    local src = io.open(ROOT .. '/src/core/roe.lua', 'r'):read('*a')
    check(src:find('gate_kind = math.floor((flag or 0) / 16777216), gate_val = (flag or 0) % 16777216', 1, true) ~= nil,
        'children keep gate kind/value for objectives and categories')
end

---------------------------------------------------------------------------
-- 隠すものの組（作った DAT）
---------------------------------------------------------------------------
local function obj(id, kind, val) return { kind = 'obj', id = id, flag = (kind or 0) * 16777216 + (val or 0), gate_kind = kind or 0, gate_val = val or 0 } end
local function cat(id, kind, val) return { kind = 'cat', id = id, flag = (kind or 0) * 16777216 + (val or 0), gate_kind = kind or 0, gate_val = val or 0 } end
local quests = {}
for _, id in ipairs({ 1, 2, 3, 5, 10, 11, 12, 20, 21, 30, 31, 40 }) do
    quests[id] = { id = id, name = 'Q' .. id, body = '', target = 1, repeatable = false, special = '' }
end
local cats = {
    [61000] = { id = 61000, name = '基礎編', children = {
        obj(1, 0, 0), obj(2, 1, 1), obj(3, 1, 2), obj(5, 1, 4085), cat(61010, 1, 3), cat(61020, 4, 261) } },
    [61010] = { id = 61010, name = '応用編', children = { obj(10, 1, 1), obj(11, 1, 1) } },
    [61020] = { id = 61020, name = 'アドゥリン', children = { obj(20, 4, 261), obj(21, 0, 0) } },
    [62000] = { id = 62000, name = '戦闘', children = { obj(30, 4, 100), obj(31, 4, 230), obj(12, 1, 4079), obj(11, 1, 1), obj(40, 1, 4057) } },
}
local db = roe.build(quests, cats)
eq(db.kind_counts.obj[1], 8, 'objective flag kind 1 count'); eq(db.kind_counts.obj[4], 3, 'objective flag kind 4 count')
eq(db.kind_counts.cat[1], 1, 'category kind 1'); eq(db.kind_counts.cat[4], 1, 'category kind 4')

local complete = roe.new_complete()
bitset(complete, 1)      -- 始まりの軌跡は達成
bitset(complete, 4085)   -- 隠しの記録（DAT に無い番号）も達成の表で見る
local g0 = roe.hidden_sets(db, { complete = complete })
check(not g0.ready and g0.n_ids == 0, 'no visited table: hide nothing')
local g1 = roe.hidden_sets(db, { visited = v })
check(not g1.ready and g1.n_ids == 0, 'no completed table: hide nothing')

local g = roe.hidden_sets(db, { complete = complete, visited = visited_of({ 230 }) })
check(g.ready, 'ready')
check(not g.ids[1] and not g.ids[2], 'no flag / prereq done: shown')
check(g.ids[3], 'prereq #2 not done: hidden')
check(not g.ids[5], 'prereq hidden record 4085 done in the table: shown')
check(g.cats[61010], 'category with undone prereq #3: hidden')
check(g.ids[10], 'objective under hidden category: hidden')
check(not g.ids[11], 'objective also shown in another category: not hidden as a whole')
check(g.occ[61010] and g.occ[61010][11], '...but hidden inside the hidden category')
check(g.cats[61020] and g.ids[20] and g.ids[21], 'area category not visited (261): category and all under it hidden')
check(g.ids[30] and not g.ids[31], 'area objective: 100 not visited hidden, 230 visited shown')
check(g.ids[12] and g.ids[40], 'hidden-record prereqs 4079/4057 not done: hidden')
eq(g.n_cats, 2, 'two categories hidden')
eq(g.n_ids, 7, 'seven objectives hidden (3,10,20,21,30,12,40)')
eq(g.by_kind[1], 4, 'by prereq (3,10,12,40)'); eq(g.by_kind[4], 3, 'by area (20,21,30)')
-- 行ったら出る
local g2 = roe.hidden_sets(db, { complete = complete, visited = visited_of({ 230, 261, 100 }) })
check(not g2.cats[61020] and not g2.ids[20] and not g2.ids[30], 'visited: shown')

---------------------------------------------------------------------------
-- 設定：初期オン、行ったエリアの保存
---------------------------------------------------------------------------
local d = settings.defaults()
eq(d.eminence.game_gate, true, 'setting default on')
eq(settings.merge({ eminence = { game_gate = false } }).eminence.game_gate, false, 'off kept')
eq(settings.merge({ eminence = { visited = 'xyz' } }).eminence.visited, '', 'bad visited dropped')
eq(settings.merge({ eminence = { visited = hex } }).eminence.visited, hex, 'visited kept')
local lay = require('src.core.layouts')
for _, k in ipairs(lay.EMINENCE_KEYS) do check(k ~= 'visited' and k ~= 'game_gate', 'layouts do not carry ' .. k) end

---------------------------------------------------------------------------
-- 本体
---------------------------------------------------------------------------
local last = {}
vana = vana or {}
vana.packets = { inject = function () end, last = function (incoming, id) return incoming and last[id] or nil end }
vana.encoding = vana.encoding or { from_shift_jis = function (s) return s end, to_shift_jis = function (s) return s end }
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
eq(app.VERSION, '1.1.327', 'version')
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')
local platform = require('src.platform.ashita')
platform.roe_snapshot = function () return nil, 'no_memory' end
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local st = app.state
st.roe.db, st.roe.db_lang, st.roe.db_why = db, (S.language == 'en') and 'en' or 'ja', nil
st.roe.complete = complete
st.roe.active = { { id = 30, progress = 0 } }   -- 受けているもの（エリアに行っていなくても隠さない）

-- 行ったエリアがまだ無い：何も隠さない
st.roe.visited = nil; S.eminence.visited = ''
check(not app.roe_gate_sets().ready, 'no visited: not ready')
-- 最後に届いた 0x008（読み込み時）
last[0x008] = pkt008({ 230 })
app.read_roe('test')
check(st.roe.visited ~= nil, 'last 0x008 read on load')
eq(st.roe.visited_src, 'last_packet', 'source last_packet')
eq(S.eminence.visited, roe.visited_hex(visited_of({ 230 })), 'saved per character (settings)')
-- 届いた 0x008（ゾーンに入ったとき）
check(app.on_visited_packet(pkt008({ 230, 100 }), 'packet'), 'packet accepted')
eq(roe.has_visited(st.roe.visited, 100), true, 'packet updates')
app.on_visited_packet(pkt008({ 230 }), 'packet')
-- 保存だけある（まだ届いていない）
local keep = st.roe.visited
st.roe.visited = nil
local sv, src = app.roe_visited()
check(sv ~= nil and src == 'saved', 'saved table used before the packet')
st.roe.visited = keep

local eminence = require('src.ui.eminence')
local ui = app._ui and app._ui() or nil
if not ui then
    ui = { settings = S, state = st, t = function (k) return k end,
        roe_db = function () return db end, roe_gate_sets = app.roe_gate_sets, roe_failed = app.roe_failed,
        roe_cycle_keep = app.roe_cycle_keep, roe_cycle_status = app.roe_cycle_status, epoch_now = app.epoch_now }
end
ui.roe_db = function () return db end
ui.roe_gate_sets = app.roe_gate_sets

local function ids_of(rows) local o = {} for _, r in ipairs(rows) do if r.kind == 'rec' then o[#o + 1] = r.id end end return o end
local function cats_of(rows) local o = {} for _, r in ipairs(rows) do if r.kind == 'cat' then o[r.key] = r end end return o end
local function has(t, x) for _, y in ipairs(t) do if y == x then return true end end return false end

for _, look in ipairs({ 'classic', 'sf' }) do
    S.look = look
    S.eminence.book_show = { accepted = true, not_accepted = true, completed = true, unimplemented = true }
    S.eminence.sf_show = { active = true, open = true, wait = true, other = true, auto = true, completed = true, unimplemented = true }
    S.eminence.game_gate = true
    local rows = eminence.list_rows(ui, eminence.ALL, nil, true)
    local ids, cs = ids_of(rows), cats_of(rows)
    check(has(ids, 1) and has(ids, 2) and has(ids, 5) and has(ids, 31), look .. ': shown ones listed')
    check(not has(ids, 3) and not has(ids, 12) and not has(ids, 40) and not has(ids, 20) and not has(ids, 21), look .. ': hidden ones not listed')
    check(has(ids, 30), look .. ': accepted objective never hidden (30, area 100 not visited)')
    check(cs[61010] == nil and cs[61020] == nil, look .. ': hidden categories gone')
    eq(cs[61000] and cs[61000].total, 3, look .. ': 基礎編 count excludes hidden (1,2,5)')
    eq(cs[62000] and cs[62000].total, 3, look .. ': 戦闘 count excludes hidden (30 accepted, 31, 11)')
    -- オフ：全部出す
    S.eminence.game_gate = false
    rows = eminence.list_rows(ui, eminence.ALL, nil, true)
    ids, cs = ids_of(rows), cats_of(rows)
    check(has(ids, 3) and has(ids, 12) and has(ids, 20), look .. ': off shows all')
    check(cs[61010] ~= nil and cs[61020] ~= nil, look .. ': off shows categories')
    eq(cs[61000] and cs[61000].total, 8, look .. ': off counts all under 基礎編')
    S.eminence.game_gate = true
end
check(eminence.show_sig(S.eminence) ~= (function () S.eminence.game_gate = false; local x = eminence.show_sig(S.eminence); S.eminence.game_gate = true; return x end)(),
    'show_sig changes with the setting')

-- 達成の表が無い：何も隠さない
local keepc = st.roe.complete
st.roe.complete = nil
check(not eminence.game_hidden(ui, 3), 'no completed table: not hidden')
st.roe.complete = keepc
check(eminence.game_hidden(ui, 3), 'hidden again with the table')

-- /astertrail roe
FAKE.printed = {}
app.command('/astertrail roe')
check(printed('1=8') and printed('4=3'), 'flag counts printed')
check(printed('7') and printed('分類 2') or printed('categories 2'), 'hidden counts printed')

-- 設定の行（全テーマ。トラッカーの分類の EMINENCE）
local focus = require('src.ui.focus')
local sui = require('src.ui.settings_ui')
local theme = require('src.ui.theme')
for _, look in ipairs({ 'classic', 'yunaui', 'sf' }) do
    S.look = look; theme.set_look(look)
    app.close_all(); frame()
    app.open_window('settings'); frame(); frame()
    sui.select_tab('tracker'); FAKE.labels, FAKE.texts = {}, {}; frame(); frame()
    local found = false
    for _, it in ipairs((focus.windows.settings and focus.windows.settings.list) or {}) do
        if it.id == 'roe_game_gate' then found = true end
    end
    check(found, look .. ': setting row present')
    check(texted('ゲームでまだ出ていない目標を隠す') or labeled('ゲームでまだ出ていない目標を隠す'), look .. ': setting label')
    check(labeled('##info_settings/roe_game_gate') or labeled('roe_game_gate'), look .. ': (i) tooltip mark')
end
app.close_all(); frame()

-- 通信のフック：0x008 を読む
local asrc = io.open(ROOT .. '/src/platform/ashita.lua', 'r'):read('*a')
check(asrc:find('if id == 0x008 then', 1, true) ~= nil and asrc:find('app.on_visited_packet', 1, true) ~= nil, 'packet_in reads 0x008')
print('test_305 ok')
