-- 0.1.293：アストラルのエミネンス。くり返しできる達成は受注ボタン、いま受けられないものは「期間外」で下へ
require('fake_env')

local roe = require('src.core.roe')
local C = require('src.core.roe_cycle')
local json = require('src.lib.json')

---------------------------------------------------------------------------
-- データ（data/roe_cycles.json。LSB の flags から作ったもの）
---------------------------------------------------------------------------
local doc = json.decode(io.open(ROOT .. '/data/roe_cycles.json', 'r'):read('*a'))
check(type(doc) == 'table' and type(doc.known) == 'table' and #doc.known > 1000, 'roe_cycles.json has the known list')
check(C.bind(doc), 'bind')
eq(C.kind(4082), 'daily', '4082 daily'); eq(C.kind(3367), 'weekly', '3367 weekly')
eq(C.kind(3768), 'monthly', '3768 monthly'); eq(C.kind(3027), 'unity', '3027 unity')
eq(C.kind(12), nil, '12 has no reset')
eq(C.repeatable(12, false), true, 'LSB repeat wins over DAT')
eq(C.repeatable(1, true), false, 'LSB non-repeat wins over DAT')
eq(C.repeatable(999, true), true, 'unknown id falls back to DAT (true)')
eq(C.repeatable(999, false), false, 'unknown id falls back to DAT (false)')

---------------------------------------------------------------------------
-- 時刻（JST）
---------------------------------------------------------------------------
local NOW = roe.EPOCH + 9087 * 86400 + 12 * 3600    -- 2026-11-18（水）12:00 JST
eq(C.weekday(NOW), 2, 'Wednesday (Mon=0)')
eq(C.format_when(NOW), '11/18 12:00', 'format')
eq(C.format_when(C.next_midnight(NOW)), '11/19 0:00', 'next midnight')
eq(C.format_when(C.next_monday(NOW)), '11/23 0:00', 'next Monday')
eq(C.format_when(C.next_month(NOW)), '12/1 0:00', 'next month')
-- 月曜 0:00 ちょうどは次の月曜
eq(C.format_when(C.next_monday(C.next_monday(NOW))), '11/30 0:00', 'Monday 0:00 -> next Monday')
-- 12 月 → 1 月
local DEC31 = C._days_from_civil(2026, 12, 31) * 86400 - 9 * 3600 + 3600
eq(C.format_when(C.next_month(DEC31)), '1/1 0:00', 'December -> January')

-- 状態（組・週は時刻つきの関数で渡す。ここでは共通 D(3) の日、リーダー 4 の第 2 週）
local function rot_at(id, t)
    local cur = roe.rotation_now({ shared = 3, week = 2, day_at = roe.days_since(NOW), week_at = roe.weeks_since(NOW) }, t)
    return roe.rotation_block(id, cur, 4)
end
local function S_(id, st, extra)
    local o = { st = st, now = NOW, rotation_at = rot_at }
    for k, v in pairs(extra or {}) do o[k] = v end
    return C.status(id, o)
end
eq(S_(12, 'completed').mode, 'open', 'repeatable completed -> open (accept button)')
eq(S_(12, 'accepted').mode, 'active', 'accepted -> active')
eq(S_(1, 'completed').mode, 'done', 'plain completed -> done')
local d = S_(4082, 'completed')
eq(d.mode, 'wait', 'daily completed -> wait'); eq(d.reason, 'cycle_daily', 'daily reason')
eq(C.format_when(d.at), '11/19 0:00', 'daily opens next midnight')
local w = S_(3367, 'completed')
eq(w.reason, 'cycle_weekly', 'weekly reason'); eq(C.format_when(w.at), '11/23 0:00', 'weekly opens Monday')
local m = S_(3768, 'completed')
eq(m.reason, 'cycle_monthly', 'monthly reason'); eq(C.format_when(m.at), '12/1 0:00', 'monthly opens on the 1st')
eq(S_(4082, 'not_accepted').mode, 'open', 'daily not completed -> open')
-- 区切りを過ぎた（サーバーが消すはず）なら受けられる扱い
eq(S_(4082, 'completed', { seen_at = NOW - 86400 }).mode, 'open', 'seen yesterday -> open after midnight')
-- ユニティ共通：今日の組 D を達成 → 次に D が来る 6 日後
local u = S_(3027, 'completed')
eq(u.reason, 'cycle_unity', 'unity reason'); eq(C.format_when(u.at), '11/24 0:00', 'unity D opens again 6 days later')
-- 組の違う共通 C（3018）：次の C の日（5 日後）
local c3 = S_(3018, 'not_accepted')
eq(c3.mode, 'wait', 'not today -> wait'); eq(c3.reason, 'not_today', 'reason not_today')
eq(C.format_when(c3.at), '11/23 0:00', 'C comes back in 5 days')
-- リーダーの週：第 2 週の今、第 0 週（3548）は火曜区切りで 2 週後
local lw = S_(3548, 'not_accepted')
eq(lw.reason, 'not_this_week', 'not this week')
check(lw.at ~= nil and C.weekday(lw.at) == 1, 'leader week opens on a Tuesday 0:00 JST: ' .. tostring(C.format_when(lw.at)))
-- ほかのリーダー・期間限定は時刻なし
local ol = S_(3500, 'not_accepted')
eq(ol.mode, 'wait', 'other leader -> wait'); eq(ol.at, nil, 'other leader has no time')
eq(S_(4010, 'not_accepted').reason, 'timed_auto', 'timed -> wait auto')
-- 0.1.294〜：期間限定は入れ替え表から次に入る時刻を出す（test_eminence_294 で詳しく）
check(S_(4010, 'not_accepted').at ~= nil, 'timed has the next time (0.1.294)')
-- 組・週が分からないあいだは止めない
eq(C.status(3018, { st = 'not_accepted', now = NOW, rotation_at = function (id, t)
    return roe.rotation_block(id, roe.rotation_now(nil, t) or {}, nil) end }).mode, 'open', 'unknown rotation: open')
-- 並び
check(C.RANK.active < C.RANK.open and C.RANK.open < C.RANK.wait and C.RANK.wait < C.RANK.done, 'rank order')

---------------------------------------------------------------------------
-- 本体：受けられるか・理由の文
---------------------------------------------------------------------------
vana = vana or {}
vana.packets = vana.packets or {
    inject = function () end,
    last = function () return nil end,
}
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
check(st.ready, 'logged in')
check(C.loaded(), 'app loaded roe_cycles.json')

local db = {
    quests = {
        [12] = { id = 12, name = 'くり返しA', body = '', target = 10, repeatable = true, special = '' },
        [1] = { id = 1, name = '一度きりB', body = '', target = 1, repeatable = false, special = '' },
        [4082] = { id = 4082, name = '毎日C', body = '', target = 1, repeatable = false, special = '' },
        [3367] = { id = 3367, name = '毎週D', body = '', target = 1, repeatable = false, special = '' },
        [13] = { id = 13, name = 'ふつうE', body = '', target = 5, repeatable = false, special = '' },
        [16] = { id = 16, name = '受注中F', body = '', target = 5, repeatable = true, special = '' },
    },
    cats = {}, roots = {}, loose = { 1, 3367, 4082, 12, 13, 16 }, cat_of = {}, zones = {},
}
local complete = roe.new_complete()
local function set_done(id)
    local idx, bit = math.floor(id / 8) + 1, 2 ^ (id % 8)
    complete[idx] = (complete[idx] or 0) + bit
end
for _, id in ipairs({ 12, 1, 4082, 3367 }) do set_done(id) end
st.roe.db, st.roe.db_lang, st.roe.db_why = db, (S.language == 'en') and 'en' or 'ja', nil
st.roe.active = { { id = 16, progress = 2 } }
st.roe.complete = complete
st.roe.unity, st.roe.leader = nil, nil

eq(app.roe_can('start', 12), true, 'repeatable completed: can accept')
eq(select(2, app.roe_can('start', 1)), 'completed', 'plain completed: completed')
eq(select(2, app.roe_can('start', 4082)), 'cycle_daily', 'daily completed: refused until reset')
eq(select(2, app.roe_can('start', 3367)), 'cycle_weekly', 'weekly completed: refused until reset')
eq(app.roe_can('start', 13), true, 'normal: can accept')
local msg = app.roe_why_text('cycle_weekly', 3367)
check(msg:find('11/23 0:00', 1, true) ~= nil, 'reason names the next time: ' .. msg)
eq(app.roe_cycle_status(4082).mode, 'wait', 'app status wait')
eq(app.roe_cycle_keep(1), false, 'plain completed is not kept')
eq(app.roe_cycle_keep(4082), true, 'daily completed is kept (shown as wait)')
eq(app.roe_cycle_keep(12), true, 'repeatable completed is kept')
-- 日が替わったら受けられる（記録の読み直しも予約する）
NOW = NOW + 13 * 3600
eq(app.roe_cycle_status(4082).mode, 'open', 'after midnight: daily opens')
st.roe.mem_due = nil
app.tick_roe()
check(st.roe.mem_due ~= nil, 'day change schedules a re-read')
NOW = NOW - 13 * 3600
st.roe.cycle_seen = {}

---------------------------------------------------------------------------
-- アストラルの本：並びとカードの札
---------------------------------------------------------------------------
local theme = require('src.ui.theme')
local eminence = require('src.ui.eminence')
local eminence_sf = require('src.ui.eminence_sf')
local imgui = require('imgui')
local texts = {}
local sf = require('src.ui.sf_style')
local saved_add = sf.add_text
sf.add_text = function (dl, x, y, col, s)
    texts[#texts + 1] = tostring(s)
    return saved_add(dl, x, y, col, s)
end
local function tr(k, a)
    local map = {
        ['roe.accept'] = '受注', ['roe.remove'] = '解除', ['sf.badge_done'] = '完了',
        ['roe.wait.period'] = '期間外', ['roe.wait.from'] = '{when}から',
    }
    local s = map[k] or k
    if type(a) == 'table' then for key, val in pairs(a) do s = s:gsub('{' .. key .. '}', tostring(val)) end end
    return s
end
local ui = {
    t = tr, imgui = imgui, settings = S,
    state = st,
    roe_db = function () return db end,
    roe_active_count = function () return 1 end,
    roe_can = app.roe_can,
    roe_send = function () end,
    roe_failed = function () return nil end,
    roe_why_text = app.roe_why_text,
    roe_cycle_status = app.roe_cycle_status,
    roe_cycle_keep = app.roe_cycle_keep,
    epoch_now = app.epoch_now,
    mark_settings_dirty = function () end,
    data = app._data(), progress = app._progress(),
}
S.eminence = S.eminence or {}
S.eminence.book_show = { accepted = true, not_accepted = true, completed = false, unimplemented = true }
S.eminence.book_text = ''
S.eminence.book_favs_only = false
S.book = S.book or {}
S.book.last_heading = S.book.last_heading or {}
S.book.last_heading.eminence = 'all'
S.look = 'sf'
theme.set_look('sf')
eminence_sf.reset_cache()
local shown = eminence_sf.shown_rows(ui)
local order = {}
for i, r in ipairs(shown) do order[i] = r.id end
local pos = {}
for i, id in ipairs(order) do pos[id] = i end
eq(pos[1], nil, 'plain completed hidden when 達成 is off')
check(pos[16] and pos[12] and pos[13] and pos[4082] and pos[3367], 'others shown: ' .. table.concat(order, ','))
eq(pos[16], 1, 'accepted first')
check(pos[12] < pos[4082] and pos[13] < pos[4082] and pos[13] < pos[3367], 'wait goes below open: ' .. table.concat(order, ','))

-- カード：くり返しの達成は受注ボタン（押せる当たり）、期間外は灰色の札で押せない
local labels = {}
local saved_ib = rawget(imgui, 'InvisibleButton')
imgui.InvisibleButton = function (id, size)
    labels[#labels + 1] = tostring(id)
    return saved_ib and saved_ib(id, size) or false
end
local function has(list, s)
    for _, v in ipairs(list) do if v:find(s, 1, true) then return true end end
    return false
end
texts, labels = {}, {}
eminence_sf.reset_cache()
pcall(eminence_sf.book_body, ui, 'book')
check(has(labels, '##sfemb_12'), 'repeatable completed card has the accept button')
check(not has(labels, '##sfemb_4082'), 'wait card has no accept button')
check(has(labels, '##sfemw_4082'), 'wait card has the grey tag')
check(has(texts, '期間外'), 'wait tag reads 期間外')
check(has(texts, '11/19 0:00から'), 'wait card shows when it opens')
imgui.InvisibleButton = saved_ib
sf.add_text = saved_add

-- 受けられる日になれば元の位置へ（0:00 JST を過ぎると署名が替わる）
NOW = NOW + 13 * 3600
local shown2 = eminence_sf.shown_rows(ui)
local p2 = {}
for i, r in ipairs(shown2) do p2[r.id] = i end
check(p2[4082] < p2[3367], 'daily returns above the still-waiting weekly after midnight')
NOW = NOW - 13 * 3600

-- クラシックは今までどおり（達成オフで、くり返しできない達成は隠す・並びは状態だけ）
S.look = 'classic'
theme.set_look('classic')
eq(eminence.book_visible(ui, 4082, nil), false, 'classic still hides a completed daily when 達成 is off')
eq(eminence.book_visible(ui, 12, nil), true, 'classic keeps a repeatable completed (DAT flag)')
local clsrc = io.open(ROOT .. '/src/ui/eminence.lua', 'r'):read('*a')
check(clsrc:find("ui.settings.look == 'sf' and ui.roe_cycle_keep", 1, true) ~= nil, 'classic path guarded by look')

print('test_eminence_cycle_293 ok')
