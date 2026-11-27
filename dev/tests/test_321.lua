-- 0.1.322：エミネンスの状態の札（枠と文字）だけ状態の色。カードの外枠・行の見た目はそのまま
require('fake_env')

local roe = require('src.core.roe')
local C = require('src.core.roe_cycle')
local json = require('src.lib.json')
local settings = require('src.core.settings')
local function readj(rel) return json.decode(io.open(ROOT .. '/' .. rel, 'r'):read('*a')) end
check(C.bind(readj('data/roe_cycles.json')) and C.bind_missing(readj('data/roe_unimplemented.json')), 'bind')
local NOW = roe.EPOCH + 9087 * 86400 + 12 * 3600
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
S.eminence.failed = {}
S.eminence.impl_ok = {}
S.eminence.unimpl_off = {}
S.eminence.known_unimpl = true

---------------------------------------------------------------------------
-- 1) 色の決まり（どの見た目でも同じ）
---------------------------------------------------------------------------
local WANT = {
    roe_st_active = { 0.85, 0.65, 0.91 }, roe_st_open = { 0.50, 0.68, 0.78 }, roe_st_done = { 0.95, 0.78, 0.32 },
    roe_st_auto = { 0.56, 0.83, 0.78 }, roe_st_other = { 0.37, 0.45, 0.50 }, roe_st_unimpl = { 0.54, 0.50, 0.53 },
}
for _, look in ipairs({ 'sf', 'classic', 'yunaui' }) do
    theme.set_look(look)
    for k, v in pairs(WANT) do
        local p = theme.palette[k]
        check(p and math.abs(p[1] - v[1]) < 0.01 and math.abs(p[2] - v[2]) < 0.01 and math.abs(p[3] - v[3]) < 0.01, look .. ': ' .. k)
    end
end
theme.set_look('sf')
check(math.abs(theme.palette.roe_st_active[1] - theme.palette.sf_violet[1]) < 1e-6, 'active = mission in-progress violet')
check(math.abs(theme.palette.roe_st_done[2] - theme.palette.sf_amber[2]) < 1e-6, 'done = mission done gold')
check(math.abs(theme.palette.roe_st_open[2] - theme.palette.muted[2]) < 1e-6, 'open = SF muted #80ADC7 (as now)')
eq(eminence_sf.state_color('active', {}), 'roe_st_active', 'active')
eq(eminence_sf.state_color('active', { reason = 'timed_auto' }), 'roe_st_active', 'timed active stays violet')
eq(eminence_sf.state_color('open', {}), 'roe_st_open', 'open')
eq(eminence_sf.state_color('done', {}), 'roe_st_done', 'done')
eq(eminence_sf.state_color('wait', { reason = 'period' }), 'roe_st_open', 'period = #80ADC7')
eq(eminence_sf.state_color('wait', { reason = 'not_this_week' }), 'roe_st_open', 'other wait reasons = #80ADC7')
eq(eminence_sf.state_color('wait', { reason = 'timed_auto' }), 'roe_st_auto', 'auto')
eq(eminence_sf.state_color('wait', { reason = 'other_leader' }), 'roe_st_other', 'other leader')
eq(eminence_sf.state_color('wait', { reason = 'not_impl', unimpl = true }), 'roe_st_unimpl', 'unimplemented')
eq(eminence.tag_color('rotation', 'other_leader'), 'roe_st_other', 'classic: other leader')
eq(eminence.tag_color('rotation', 'timed_auto'), 'roe_st_auto', 'classic: auto')
eq(eminence.tag_color('rotation', 'not_today'), nil, 'classic: period stays grey')
eq(eminence.tag_color('rotation', 'not_this_week'), nil, 'classic: week stays grey')
eq(eminence.tag_color('failed', 'not_impl'), 'roe_st_unimpl', 'classic: unimplemented')
eq(eminence.tag_color('failed', 'unable'), nil, 'classic: unable stays grey')

---------------------------------------------------------------------------
-- 2) アストラルのカード：札の枠と文字は状態の色、カードの外枠は今までどおり
---------------------------------------------------------------------------
S.look = 'sf'
S.eminence.sf_show = { active = true, open = true, wait = true, other = true, auto = true, completed = true, unimplemented = true }
S.eminence.book_text = ''
S.eminence.book_favs_only = false
S.book = S.book or {}
S.book.last_heading = S.book.last_heading or {}
S.book.last_heading.eminence = 'all'
local texts, frs = {}, {}
local saved_add, saved_frame = sf.add_text, sf.frame
sf.add_text = function (dl, x, y, col, s) texts[#texts + 1] = { s = tostring(s), col = col, n = #frs }; return saved_add(dl, x, y, col, s) end
sf.frame = function (dl, x1, y1, x2, y2, o) frs[#frs + 1] = o or {}; return saved_frame(dl, x1, y1, x2, y2, o) end
texts, frs = {}, {}
eminence_sf.reset_cache()
local ok, err = pcall(eminence_sf.book_body, ui, 'book')
check(ok, 'sf book_body draws: ' .. tostring(err))
local function find(s)
    for _, x in ipairs(texts) do if x.s == s then return x end end
end
local function badge_frame(x)
    for i = x.n, 1, -1 do if frs[i].cut == 3 then return frs[i] end end
end
local function card_frame(x)
    for i = x.n, 1, -1 do if frs[i].cut == 8 then return frs[i] end end
end
local seen = 0
for s, want in pairs({ ['解除'] = 'roe_st_active', ['受注'] = 'roe_st_open', ['完了'] = 'roe_st_done', ['対象外'] = 'roe_st_other', ['自動'] = 'roe_st_auto', ['未実装'] = 'roe_st_unimpl', ['期間外'] = 'roe_st_open' }) do
    local x = find(s)
    if x then
        seen = seen + 1
        local okc = x.col == theme.u32(want, 0.95) or x.col == theme.u32(want, 1.0) or x.col == theme.u32(want, 1)
        check(okc, 'sf badge text color: ' .. s)
        local bf = badge_frame(x)
        check(bf and bf.line and (bf.line == theme.u32(want, 0.95) or bf.line == theme.u32(want, 0.85) or bf.line == theme.u32(want, 0.70)), 'sf badge frame color: ' .. s)
        local cf = card_frame(x)
        check(cf and cf.line == nil and cf.glow_col == theme.u32('sf_cyan', 0.80), 'sf card frame unchanged: ' .. s)
    end
end
check(find('解除') and find('受注') and find('完了') and find('未実装'), 'sf: active/open/done/unimpl badges drawn')
check(seen >= 5, 'sf: most states drawn (' .. seen .. ')')
-- 詳細の状態の字
local tc = {}
local saved_tc = theme.TextColored
theme.TextColored = function (im, col, s) tc[#tc + 1] = { col = col, s = tostring(s) }; return saved_tc(im, col, s) end
local okd = pcall(eminence_sf._draw_detail, ui, 'book', 16)
check(okd, 'sf detail draws')
local got = false
for _, x in ipairs(tc) do
    local c = x.col
    local w = theme.col('roe_st_active')
    if type(c) == 'table' and type(w) == 'table' and math.abs((c[1] or c.x or 0) - (w[1] or w.x or 0)) < 1e-6 and math.abs((c[2] or c.y or 0) - (w[2] or w.y or 0)) < 1e-6 then got = true end
end
check(got, 'sf detail: in-progress state text is violet')
theme.TextColored = saved_tc
sf.add_text, sf.frame = saved_add, saved_frame

---------------------------------------------------------------------------
-- 3) クラシック・YunaUI 風：行の札だけ色。崩れない
---------------------------------------------------------------------------
app.roe_rotation = app.roe_rotation or function () return nil end
for _, look in ipairs({ 'classic', 'yunaui' }) do
    S.look = look
    theme.set_look(look)
    local rows = {}
    for _, id in ipairs({ 16, 12, 4082, 3500, 4021, 1, 386 }) do rows[#rows + 1] = { kind = 'rec', id = id, depth = 1 } end
    ui.roe_rotation = function (id)
        if id == 3500 then return 'other_leader', nil end
        if id == 4021 then return 'timed_auto', nil end
        if id == 4082 then return 'not_today', '3' end
        return nil
    end
    for _, mode in ipairs({ 'table', 'plain' }) do
    FAKE.table = (mode == 'table') or nil
    tc = {}
    local dis = {}
    local saved_td = theme.TextDisabled
    theme.TextColored = function (im, col, s) tc[#tc + 1] = { col = col, s = tostring(s) }; return saved_tc(im, col, s) end
    theme.TextDisabled = function (im, s) dis[#dis + 1] = tostring(s); return saved_td(im, s) end
    eminence.table_failed = (mode == 'plain') and 'test' or nil
    local okr, er = pcall(eminence.draw_rows, ui, 'book', rows, false)
    check(okr, look .. ' ' .. mode .. ': rows draw: ' .. tostring(er))
    theme.TextColored, theme.TextDisabled = saved_tc, saved_td
    local function colored(sub, key)
        local w = theme.col(key)
        for _, x in ipairs(tc) do
            if x.s:find(sub, 1, true) then
                local c = x.col
                if type(c) == 'table' and math.abs((c[1] or c.x or 0) - (w[1] or w.x or 0)) < 1e-6 then return true end
            end
        end
        return false
    end
    local function grey(sub) for _, s in ipairs(dis) do if s:find(sub, 1, true) then return true end end return false end
    local tr_other = tr('roe.tag_rotation.other_leader')
    local tr_auto = tr('roe.tag_rotation.timed_auto')
    local tr_un = tr('roe.tag_failed.not_impl')
    local tr_today = tr('roe.tag_rotation.not_today', { today = '3' })
    check(colored(tr_other, 'roe_st_other'), look .. ' ' .. mode .. ': other-leader tag is #5F7380')
    check(colored(tr_auto, 'roe_st_auto'), look .. ' ' .. mode .. ': auto tag is #8FD3C8')
    check(colored(tr_un, 'roe_st_unimpl'), look .. ' ' .. mode .. ': unimplemented tag is #8A7F86')
    check(grey(tr_today), look .. ' ' .. mode .. ': period tag stays grey')
    end
    eminence.table_failed = nil
    FAKE.table = nil
end
S.look = 'sf'
theme.set_look('sf')
print('test_321 ok')
