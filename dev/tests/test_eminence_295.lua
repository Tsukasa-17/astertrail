-- 0.1.295：未実装の札を手で外す（元に戻す）⇄ 未実装に戻す
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
eq(app.VERSION, '1.1.324', 'version')
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
    ['roe.wait.in_m'] = 'あと{m}分', ['roe.unimpl.restore'] = '元に戻す', ['roe.unimpl.mark'] = '未実装に戻す',
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
    roe_unimpl_state = app.roe_unimpl_state, roe_toggle_unimpl = app.roe_toggle_unimpl,
    roe_cycle_status = app.roe_cycle_status, roe_cycle_keep = app.roe_cycle_keep,
    epoch_now = app.epoch_now, mark_settings_dirty = function () end,
    data = app._data(), progress = app._progress(),
}

---------------------------------------------------------------------------
-- 本体：手で外す ⇄ 戻す
---------------------------------------------------------------------------
S.eminence.failed = { ['13'] = { why = 'not_impl', at = 'x' }, ['20'] = { why = 'unable', at = 'x' } }
S.eminence.impl_ok = {}
S.eminence.unimpl_off = {}
S.eminence.known_unimpl = true
eq(app.roe_unimpl_state(386), 'unimpl', 'listed: can restore')
eq(app.roe_unimpl_state(13), 'unimpl', 'own refusal: can restore')
eq(app.roe_unimpl_state(20), nil, 'unable is not 未実装: no button')
eq(app.roe_unimpl_state(12), nil, 'normal record: no button')
eq(app.roe_unimpl_state(16), nil, 'accepted record: no button')
eq(app.roe_toggle_unimpl(12), nil, 'toggle on a normal record does nothing')
eq(app.roe_toggle_unimpl(386), 'restored', 'restore listed')
eq(app.roe_failed(386), nil, 'restored listed -> not 未実装')
eq(app.roe_unimpl_state(386), 'restored', 'restored: can mark again')
eq(S.eminence.unimpl_off['386'], true, 'saved in settings')
eq(app.roe_toggle_unimpl(13), 'restored', 'restore own refusal')
eq(app.roe_failed(13), nil, 'restored own refusal -> not 未実装')
check(S.eminence.failed['13'] ~= nil, 'own refusal record is kept')
-- 設定のオン・オフでは戻らない
S.eminence.known_unimpl = false
eq(app.roe_failed(386), nil, 'off: still restored'); eq(app.roe_failed(13), nil, 'off: own still restored')
S.eminence.known_unimpl = true
eq(app.roe_failed(386), nil, 'on again: still restored')
-- 保存して読み直しても残る
local mm = settings.merge(json.decode(json.encode(S)))
eq(mm.eminence.unimpl_off['386'], true, 'round trip keeps unimpl_off')
eq(mm.eminence.unimpl_off['13'], true, 'round trip keeps 13')
local mz = settings.merge({ eminence = { unimpl_off = { ['5000'] = true, x = true, ['7'] = 'yes', ['8'] = true } } })
eq(mz.eminence.unimpl_off['8'], true, 'valid kept')
eq(mz.eminence.unimpl_off['5000'], nil, 'out of range dropped'); eq(mz.eminence.unimpl_off['7'], nil, 'non-true dropped')
eq(settings.merge({}).eminence.unimpl_off ~= nil, true, 'default empty table')
-- 同じボタンで未実装に戻す
eq(app.roe_toggle_unimpl(386), 'unimpl', 'mark again')
eq(app.roe_failed(386).why, 'not_impl', 'marked again -> 未実装')
eq(S.eminence.unimpl_off['386'], nil, 'mark removes the saved entry')
-- もう一度受注して「未実装」と断られたら、また未実装
eq(app.roe_toggle_unimpl(386), 'restored', 'restore again')
app.roe_mark_failed(386, 'not_impl')
eq(S.eminence.unimpl_off['386'], nil, 'refused again -> restore cleared')
eq(app.roe_failed(386).why, 'not_impl', 'refused again -> 未実装')
-- 「受けられない」（742）だけでは外した印を消さない
app.roe_mark_failed(13, 'unable')
eq(S.eminence.unimpl_off['13'], true, 'unable reply keeps the restore')
-- サーバーの文から（on_text_in）
eq(app.roe_toggle_unimpl(386), 'restored', 'restore once more')
app.on_text_in('The record #386 is not implemented at this time.', 0)
eq(app.roe_failed(386) and app.roe_failed(386).why, 'not_impl', 'server text -> 未実装 again')

---------------------------------------------------------------------------
-- アストラル：カードと詳細のボタン
---------------------------------------------------------------------------
S.look = 'sf'
theme.set_look('sf')
S.eminence.sf_show = { active = true, open = true, wait = true, other = true, auto = true, completed = true, unimplemented = true }
S.eminence.book_text = ''
S.eminence.book_favs_only = false
S.book = S.book or {}
S.book.last_heading = S.book.last_heading or {}
S.book.last_heading.eminence = 'all'
local labels, texts = {}, {}
local saved_ib = rawget(imgui, 'InvisibleButton')
local press = {}
-- カードの大きさが分かるように、最後のボタンの大きさを当たりの四角にする
local last_w, last_h = 10, 10
local saved_min, saved_max = rawget(imgui, 'GetItemRectMin'), rawget(imgui, 'GetItemRectMax')
imgui.GetItemRectMin = function () return { x = 0, y = 0 } end
imgui.GetItemRectMax = function () return { x = last_w, y = last_h } end
local cur_pos, rects = { 0, 0 }, {}
local saved_scp = rawget(imgui, 'SetCursorScreenPos')
imgui.SetCursorScreenPos = function (p) cur_pos = p; if saved_scp then return saved_scp(p) end end
imgui.InvisibleButton = function (id, size)
    if type(size) == 'table' then last_w, last_h = size[1] or size.x or 10, size[2] or size.y or 10 end
    rects[tostring(id)] = { cur_pos[1] or 0, cur_pos[2] or 0, (cur_pos[1] or 0) + last_w, (cur_pos[2] or 0) + last_h }
    labels[#labels + 1] = tostring(id)
    if press[tostring(id)] then press[tostring(id)] = nil; return true end
    return saved_ib and saved_ib(id, size) or false
end
local saved_add = sf.add_text
sf.add_text = function (dl, x, y, col, s) texts[#texts + 1] = tostring(s); return saved_add(dl, x, y, col, s) end
local function has(list, s) for _, v in ipairs(list) do if v:find(s, 1, true) then return true end end return false end
local function draw_book()
    labels, texts = {}, {}
    eminence_sf.reset_cache()
    local ok, err = pcall(eminence_sf.book_body, ui, 'book')
    check(ok, 'book_body draws: ' .. tostring(err))
end
draw_book()
check(has(labels, '##sfemu_386'), 'unimplemented card has the restore button')
check(has(texts, '元に戻す'), 'restore label on the card')
check(has(labels, '##sfemw_386'), 'still the grey 未実装 tag')
check(not has(labels, '##sfemu_12'), 'normal card has no restore button')
do
    local u, b = rects['##sfemu_386'], rects['##sfemw_386']
    check(u and b, 'rects recorded')
    if u and b then
        local overlap = u[1] < b[3] and b[1] < u[3] and u[2] < b[4] and b[2] < u[4]
        check(not overlap, 'restore button does not overlap the tag: ' .. table.concat(u, ',') .. ' / ' .. table.concat(b, ','))
        check(u[1] >= 10 and u[2] >= 30, 'restore button inside the card')
    end
end
check(not has(labels, '##sfemu_16'), 'accepted card has no restore button')
press['##sfemu_386'] = true
draw_book()
eq(S.eminence.unimpl_off['386'], true, 'card button restores')
draw_book()
check(has(labels, '##sfemb_386'), 'restored card now has the accept button')
check(not has(labels, '##sfemw_386'), 'restored card has no grey tag')
check(has(labels, '##sfemu_386') and has(texts, '未実装に戻す'), 'restored card offers 未実装に戻す')
eq(eminence_sf.category(ui, 386), 'open', 'restored -> 受注 category')
press['##sfemu_386'] = true
draw_book()
eq(S.eminence.unimpl_off['386'], nil, 'card button marks again')
eq(eminence_sf.category(ui, 386), 'unimplemented', 'marked again -> 未実装 category')

-- 詳細
local function draw_detail()
    labels, texts = {}, {}
    local ok, err = pcall(eminence_sf._draw_detail, ui, 'book', 386)
    check(ok, 'detail draws: ' .. tostring(err))
end
check(type(eminence_sf._draw_detail) == 'function', 'sf detail exists')
draw_detail()
local det = nil
for _, l in ipairs(labels) do if l:find('unimpl', 1, true) then det = l end end
check(det ~= nil, 'detail has the unimpl chip: ' .. table.concat(labels, ' '))
check(has(texts, '元に戻す'), 'detail label 元に戻す')
if det then
    press[det] = true
    draw_detail()
    eq(S.eminence.unimpl_off['386'], true, 'detail chip restores')
    draw_detail()
    check(has(texts, '未実装に戻す'), 'detail now offers 未実装に戻す')
    press[det] = true
    draw_detail()
    eq(S.eminence.unimpl_off['386'], nil, 'detail chip marks again')
end
imgui.InvisibleButton = saved_ib
imgui.GetItemRectMin, imgui.GetItemRectMax = saved_min, saved_max
imgui.SetCursorScreenPos = saved_scp
sf.add_text = saved_add

---------------------------------------------------------------------------
-- クラシック：詳細のボタン（W.button）
---------------------------------------------------------------------------
S.look = 'classic'
theme.set_look('classic')
local W = require('src.ui.widgets')
local saved_btn = W.button
local btns, click = {}, nil
W.button = function (u, n, id, label, o)
    btns[#btns + 1] = { id = id, label = label, tip = o and o.tooltip }
    if click == id then click = nil; return true end
    return false
end
local function draw_classic(id)
    btns = {}
    local ok, err = pcall(eminence.detail, ui, 'eminence', id)
    check(ok, 'classic detail draws: ' .. tostring(err))
end
local function find_btn(id) for _, b in ipairs(btns) do if b.id == id then return b end end end
draw_classic(386)
local b = find_btn('roe_unimpl')
check(b ~= nil and b.label == '元に戻す', 'classic detail has 元に戻す')
click = 'roe_unimpl'
draw_classic(386)
eq(S.eminence.unimpl_off['386'], true, 'classic button restores')
draw_classic(386)
b = find_btn('roe_unimpl')
check(b ~= nil and b.label == '未実装に戻す', 'classic detail offers 未実装に戻す')
click = 'roe_unimpl'
draw_classic(386)
eq(S.eminence.unimpl_off['386'], nil, 'classic button marks again')
draw_classic(12)
eq(find_btn('roe_unimpl'), nil, 'classic: no button on a normal record')
W.button = saved_btn

-- 字は locales（日本語と英語）
local ja = readj('locales/ja.json')
local en = readj('locales/en.json')
eq(ja['roe.unimpl.restore'], '元に戻す', 'ja restore'); eq(ja['roe.unimpl.mark'], '未実装に戻す', 'ja mark')
for _, k in ipairs({ 'roe.unimpl.restore', 'roe.unimpl.mark', 'roe.unimpl.restore_tip', 'roe.unimpl.mark_tip' }) do
    check(type(ja[k]) == 'string' and ja[k] ~= '' and type(en[k]) == 'string' and en[k] ~= '', 'locale ' .. k)
end
check(not ja['roe.unimpl.restore_tip']:find('LSB', 1, true), 'no source name in the tip')

print('test_eminence_295 ok')
