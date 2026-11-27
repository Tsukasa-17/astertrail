-- 0.1.294：アストラルのエミネンスの絞り込みを札の言葉に、未実装の札を自動でつける設定、自動の残り時間
require('fake_env')

local roe = require('src.core.roe')
local C = require('src.core.roe_cycle')
local json = require('src.lib.json')
local settings = require('src.core.settings')

local function readj(rel) return json.decode(io.open(ROOT .. '/' .. rel, 'r'):read('*a')) end

---------------------------------------------------------------------------
-- データ
---------------------------------------------------------------------------
local cyc = readj('data/roe_cycles.json')
local known = {}
for _, v in ipairs(cyc.known) do known[v] = true end
eq(#cyc.known, 1087, 'known after stripping Lua comments')
check(not known[490] and not known[726] and not known[3690], 'commented-out records are not known')
local un = readj('data/roe_unimplemented.json')
eq(#un.missing, 483, 'missing count')
local miss = {}
for _, v in ipairs(un.missing) do miss[v] = true end
-- 実機でサーバーに断られた番号（設定の failed）はすべて入っている。受け付けられた番号（impl_ok）は入っていない
for _, id in ipairs({ 386, 387, 388, 527, 532, 701, 926, 955, 968, 1444, 2043, 3055, 3360, 3789, 3790 }) do
    check(miss[id], 'refused by the server -> missing: ' .. id)
end
for _, id in ipairs({ 1447, 215, 227, 3000, 3002, 3009, 3011, 4082, 499 }) do
    check(not miss[id], 'accepted by the server -> not missing: ' .. id)
end
for id in pairs(miss) do check(not known[id], 'missing is never in the implemented list: ' .. id) end
check(C.bind(cyc) and C.bind_missing(un), 'bind')
check(C.known_missing(386) and not C.known_missing(12), 'known_missing')
eq(#cyc.timed_schedule, 7, 'timed schedule 7 days')

---------------------------------------------------------------------------
-- 自動（期間限定）の次の時刻：JST 0・4・8・12・16・20 時の枠、曜日ごとの表
---------------------------------------------------------------------------
local NOW = roe.EPOCH + 9087 * 86400 + 12 * 3600    -- 2026-11-18（水）12:00 JST
eq(C.jst_weekday_sun0(NOW), 3, 'Wednesday (Sun=0)')
-- 水曜の表：4017, 4014, 4019, 4008, 4021, 4010
eq(C.format_when(C.next_timed(4021, NOW)), '11/18 16:00', '4021 next at 16:00')
eq(C.format_when(C.next_timed(4010, NOW)), '11/18 20:00', '4010 next at 20:00')
-- 今の枠（12〜16 時は 4008）は次の回：金曜 4:00
eq(C.format_when(C.next_timed(4008, NOW)), '11/20 4:00', 'current slot -> next time it comes (Fri 04-08)')
-- 日をまたぐ：木曜 0:00 は 4018
eq(C.format_when(C.next_timed(4018, NOW + 11 * 3600)), '11/19 0:00', 'crosses midnight')
local h, m = C.remain_parts(C.next_timed(4021, NOW + 45 * 60), NOW + 45 * 60)
eq(h, 3, 'hours left'); eq(m, 15, 'minutes left')
h, m = C.remain_parts(NOW + 30, NOW)
eq(h, 0, 'under a minute: 0h'); eq(m, 1, 'under a minute rounds up to 1m')
eq(C.next_timed(12, NOW), nil, 'not a timed record')

---------------------------------------------------------------------------
-- 保存：絞り込みの引き継ぎ・設定の初期値
---------------------------------------------------------------------------
local m1 = settings.merge({ eminence = { book_show = { accepted = true, not_accepted = false, completed = true, unimplemented = false } } })
local sh = m1.eminence.sf_show
eq(sh.active, true, '解除 <- 受注中'); eq(sh.open, false, '受注 <- 未受注')
eq(sh.wait, false, '期間外 <- 未受注'); eq(sh.other, false, '対象外 <- 未受注'); eq(sh.auto, false, '自動 <- 未受注')
eq(sh.completed, true, '達成 <- 達成'); eq(sh.unimplemented, false, '未実装 <- 未実装')
eq(m1.eminence.book_show.not_accepted, false, 'classic book_show is kept')
eq(m1.eminence.known_unimpl, true, 'known_unimpl defaults to on')
local m2 = settings.merge({ eminence = { sf_show = { open = false, auto = false }, known_unimpl = false } })
eq(m2.eminence.sf_show.open, false, 'saved sf_show kept'); eq(m2.eminence.sf_show.auto, false, 'saved auto kept')
eq(m2.eminence.sf_show.active, true, 'missing key from defaults')
eq(m2.eminence.known_unimpl, false, 'known_unimpl off is kept')
local m3 = settings.merge(json.decode(json.encode(m2)))
eq(m3.eminence.sf_show.open, false, 'round trip'); eq(m3.eminence.known_unimpl, false, 'round trip known_unimpl')

---------------------------------------------------------------------------
-- 本体：未実装の札（オン：調べた一覧、オフ：自分で断られたものだけ）
---------------------------------------------------------------------------
vana = vana or {}
vana.packets = vana.packets or { inject = function () end, last = function () return nil end }
vana.encoding = vana.encoding or { from_shift_jis = function (s) return s end, to_shift_jis = function (s) return s end }
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
eq(app.VERSION, '1.1.327', 'version')
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')
local platform = require('src.platform.ashita')
platform.roe_snapshot = function () return nil, 'no_memory' end
app.epoch_now = function () return NOW end
FAKE.player = { name = 'Tester', zone = 100, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local st = app.state
check(C.missing_loaded(), 'app loaded roe_unimplemented.json')
S.eminence.failed = { ['13'] = { why = 'not_impl', at = 'x' } }   -- 自分で受けて断られた番号
S.eminence.impl_ok = { ['387'] = true }                          -- 一覧にあるが、受け付けられたことがある
S.eminence.known_unimpl = true
eq(app.roe_failed(386).why, 'not_impl', 'on: listed -> 未実装')
eq(app.roe_failed(387), nil, 'on: accepted before -> not 未実装')
eq(app.roe_failed(13).why, 'not_impl', 'on: own refusal stays')
eq(app.roe_failed(3056).why, 'not_impl', 'on: 3055-3060 too')
S.eminence.known_unimpl = false
eq(app.roe_failed(386), nil, 'off: listed goes back')
eq(app.roe_failed(3056), nil, 'off: 3055-3060 go back')
eq(app.roe_failed(13).why, 'not_impl', 'off: own refusal stays')
check(S.eminence.failed['13'] ~= nil, 'own refusal is not deleted')
S.eminence.known_unimpl = true

---------------------------------------------------------------------------
-- アストラルの本：札と絞り込み
---------------------------------------------------------------------------
local db = {
    quests = {
        [16] = { id = 16, name = '受注中', body = '', target = 5, repeatable = true, special = '' },
        [12] = { id = 12, name = '受けられる', body = '', target = 10, repeatable = true, special = '' },
        [4082] = { id = 4082, name = '期間外', body = '', target = 1, repeatable = false, special = '' },
        [3500] = { id = 3500, name = '対象外', body = '', target = 1, repeatable = false, special = '' },
        [4021] = { id = 4021, name = '自動', body = '', target = 1, repeatable = true, special = '' },
        [1] = { id = 1, name = '達成', body = '', target = 1, repeatable = false, special = '' },
        [386] = { id = 386, name = '未実装', body = '', target = 1, repeatable = false, special = '' },
    },
    cats = {}, roots = {}, loose = { 16, 12, 4082, 3500, 4021, 1, 386 }, cat_of = {}, zones = {},
}
local complete = roe.new_complete()
for _, id in ipairs({ 1, 4082 }) do
    local idx, bit = math.floor(id / 8) + 1, 2 ^ (id % 8)
    complete[idx] = (complete[idx] or 0) + bit
end
st.roe.db, st.roe.db_lang, st.roe.db_why = db, (S.language == 'en') and 'en' or 'ja', nil
st.roe.active = { { id = 16, progress = 2 } }
st.roe.complete = complete
st.roe.cycle_seen = {}
st.roe.unity = { shared = 3, week = 2, day_at = roe.days_since(NOW), week_at = roe.weeks_since(NOW) }
st.roe.leader = 4

local theme = require('src.ui.theme')
local eminence = require('src.ui.eminence')
local eminence_sf = require('src.ui.eminence_sf')
local sf = require('src.ui.sf_style')
local imgui = require('imgui')
local MAP = {
    ['roe.accept'] = '受注', ['roe.remove'] = '解除', ['sf.badge_done'] = '完了',
    ['roe.wait.period'] = '期間外', ['roe.wait.other'] = '対象外', ['roe.wait.auto'] = '自動',
    ['roe.state.completed'] = '達成', ['state.unimplemented'] = '未実装', ['roe.favs_only'] = 'お気に入りのみ',
    ['roe.wait.from'] = '{when}から', ['roe.wait.in_hm'] = 'あと{h}時間{m}分', ['roe.wait.in_h'] = 'あと{h}時間',
    ['roe.wait.in_m'] = 'あと{m}分',
}
local function tr(k, a)
    local s = MAP[k] or k
    if type(a) == 'table' then for key, val in pairs(a) do s = s:gsub('{' .. key .. '}', tostring(val)) end end
    return s
end
local ui = {
    t = tr, imgui = imgui, settings = S, state = st,
    roe_db = function () return db end,
    roe_active_count = function () return 1 end,
    roe_can = app.roe_can, roe_send = function () end,
    roe_failed = app.roe_failed, roe_why_text = app.roe_why_text,
    roe_cycle_status = app.roe_cycle_status, roe_cycle_keep = app.roe_cycle_keep,
    epoch_now = app.epoch_now, mark_settings_dirty = function () end,
    data = app._data(), progress = app._progress(),
}
local cat = {}
for id in pairs(db.quests) do cat[id] = eminence_sf.category(ui, id) end
eq(cat[16], 'active', '受注中 -> 解除'); eq(cat[12], 'open', '受けられる -> 受注')
eq(cat[4082], 'wait', '期間外'); eq(cat[3500], 'other', '対象外'); eq(cat[4021], 'auto', '自動')
eq(cat[1], 'completed', '達成'); eq(cat[386], 'unimplemented', '未実装')
S.eminence.known_unimpl = false
eq(eminence_sf.category(ui, 386), 'open', 'setting off: 386 back to 受注')
S.eminence.known_unimpl = true

S.eminence.sf_show = { active = true, open = true, wait = true, other = true, auto = true, completed = true, unimplemented = true }
S.eminence.book_text = ''
S.eminence.book_favs_only = false
S.book = S.book or {}
S.book.last_heading = S.book.last_heading or {}
S.book.last_heading.eminence = 'all'
S.look = 'sf'
theme.set_look('sf')
local function ids_shown()
    eminence_sf.reset_cache()
    local out, pos = {}, {}
    for i, r in ipairs(eminence_sf.shown_rows(ui)) do out[i] = r.id; pos[r.id] = i end
    return out, pos
end
local order, pos = ids_shown()
eq(#order, 7, 'all shown: ' .. table.concat(order, ','))
eq(pos[16], 1, 'accepted first')
check(pos[12] < pos[4082] and pos[4082] < pos[386] and pos[386] < pos[1], 'open < wait < unimpl < done: ' .. table.concat(order, ','))
for _, k in ipairs({ 'active', 'open', 'wait', 'other', 'auto', 'completed', 'unimplemented' }) do
    S.eminence.sf_show[k] = false
    local _, p = ids_shown()
    for id, c in pairs(cat) do
        if c == k then eq(p[id], nil, k .. ' off hides ' .. id) else check(p[id] ~= nil, k .. ' off keeps ' .. id) end
    end
    S.eminence.sf_show[k] = true
end

-- 絞り込みのボタンの並びと字、カードの札
local labels, texts = {}, {}
local saved_ib = rawget(imgui, 'InvisibleButton')
imgui.InvisibleButton = function (id, size)
    labels[#labels + 1] = tostring(id)
    return saved_ib and saved_ib(id, size) or false
end
local saved_add = sf.add_text
sf.add_text = function (dl, x, y, col, s) texts[#texts + 1] = tostring(s); return saved_add(dl, x, y, col, s) end
st.sf_em_filters_open = true
eminence_sf.reset_cache()
local ok, err = pcall(eminence_sf.book_body, ui, 'book')
check(ok, 'book_body draws: ' .. tostring(err))
local seq = {}
for _, l in ipairs(labels) do
    local k = l:match('##sfc_em_sf_show_(%w+)') or (l:find('##sfc_em_favs', 1, true) and 'favs')
    if k then seq[#seq + 1] = k end
end
local function has(list, s) for _, v in ipairs(list) do if v:find(s, 1, true) then return true end end return false end
check(#seq > 0, 'filter chips drawn')
do
    eq(table.concat(seq, ','), 'active,open,wait,other,auto,completed,unimplemented,favs', 'chip order')
    for _, w in ipairs({ '解除', '受注', '期間外', '対象外', '自動', '達成', '未実装', 'お気に入りのみ' }) do
        check(has(texts, w), 'chip label ' .. w)
    end
end
check(has(labels, '##sfemw_386'), 'unimplemented card has the grey tag')
check(not has(labels, '##sfemb_386'), 'unimplemented card has no accept button')
check(has(labels, '##sfemw_4021'), 'auto card has the grey tag')
check(has(texts, 'あと4時間'), 'auto card shows time left: next 4021 at 16:00')
imgui.InvisibleButton = saved_ib
sf.add_text = saved_add

-- ボタンの source：古い 受注中・未受注 の SF チップは無い。クラシックの絞り込みは今までどおり
local sfsrc = io.open(ROOT .. '/src/ui/eminence_sf.lua', 'r'):read('*a')
check(not sfsrc:find("'em_show_' .. k", 1, true), 'old SF state chips are gone')
check(sfsrc:find('flow_chips(ui, name, items)', 1, true) ~= nil, 'chips still wrap with flow_chips')
local clsrc = io.open(ROOT .. '/src/ui/eminence.lua', 'r'):read('*a')
check(clsrc:find("'roe_show_' .. k", 1, true) ~= nil, 'classic chips unchanged')
S.look = 'classic'
theme.set_look('classic')
S.eminence.book_show = { accepted = true, not_accepted = true, completed = false, unimplemented = true }
eq(eminence.book_visible(ui, 1, nil), false, 'classic still hides a non-repeatable completed')
eq(eminence.book_visible(ui, 12, nil), true, 'classic shows a normal record')

-- 設定画面：アストラルとクラシックに同じ項目。字は locales
local ss = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a')
local cs = io.open(ROOT .. '/src/ui/settings_ui.lua', 'r'):read('*a')
check(ss:find("'roe_known_unimpl'", 1, true) and ss:find("'known_unimpl'", 1, true), 'astral settings has the switch')
check(cs:find("'roe_known_unimpl'", 1, true) and cs:find("'known_unimpl'", 1, true), 'classic settings has the switch')
local ja = readj('locales/ja.json')
local en = readj('locales/en.json')
eq(ja['sf.set.roe_known_unimpl'], '未実装の札を自動でつける', 'ja label')
eq(ja['sf.set.roe_known_unimpl_help'], 'LSBで未実装のエミネンスに未実装の札をつけます。サーバーが独自に実装している場合もあります。', 'ja help')
eq(ja['settings.roe_known_unimpl'], ja['sf.set.roe_known_unimpl'], 'classic label same')
check(type(en['sf.set.roe_known_unimpl']) == 'string' and type(en['roe.wait.in_hm']) == 'string', 'en strings')
eq(ja['roe.wait.in_hm'], 'あと{h}時間{m}分', 'ja time left')

print('test_eminence_294 ok')
