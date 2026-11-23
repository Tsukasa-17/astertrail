-- 0.1.263：アイテム名ホバーのツールチップ（term_line）、エミネンスカードのお気に入り、
-- トラッカー一覧の件間セパレータ、SF 本のカード／詳細スプリッタ
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.324', 'version')

local W = require('src.ui.widgets')
local CT = require('src.ui.colored_text')
local item_tip = require('src.ui.item_tip')
local book = require('src.ui.book')
local eminence = require('src.ui.eminence')
local eminence_sf = require('src.ui.eminence_sf')
local theme = require('src.ui.theme')
local settings = require('src.core.settings')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')

---------------------------------------------------------------------------
-- ツールチップ：W.term_line 経由（0.1.262 では番号が渡らず出ていなかった）
---------------------------------------------------------------------------
item_tip.clear_source()
item_tip.set_source({
    item = function (id)
        if id == 4155 then
            return { name = '万能薬', description = 'ほとんどの状態異常を治す。', level = 1, flags = 0 }
        end
        return nil
    end,
    icon = function () error('icon failed') end,
})

local im = package.loaded['imgui']
local tips = {}
local last_btn = nil
local hover_pat = nil
local saved = {}
for _, k in ipairs({ 'IsItemHovered', 'SetTooltip', 'BeginTooltip', 'EndTooltip', 'InvisibleButton' }) do
    saved[k] = rawget(im, k)
end
local saved_ib = rawget(im, 'InvisibleButton')
im.InvisibleButton = function (label, size)
    last_btn = label
    return saved_ib(label, size)
end
im.IsItemHovered = function ()
    if not hover_pat then return false end
    return type(last_btn) == 'string' and last_btn:find(hover_pat, 1, true) ~= nil
end
im.SetTooltip = function (s)
    tips[#tips + 1] = tostring(s or '')
end
-- 無い／失敗しても名前は SetTooltip に出す。テストでは文字だけの経路を使う。
im.BeginTooltip = function () return false end
im.EndTooltip = function () end

local function has_tip(pat)
    for _, s in ipairs(tips) do
        if tostring(s):find(pat, 1, true) then return true end
    end
    return false
end

local function ui_of()
    return {
        imgui = im,
        settings = S,
        data = app._data(),
        t = function (k) return k end,
        mark_settings_dirty = function () end,
    }
end

local terms = {}
CT.add(terms, '万能薬', 'item', { item_id = 4155, copy_text = '万能薬' })
CT.add(terms, '0/1', 'poss_count', { tip = 'かばん1', copy_text = '万能薬', dup = true, once = true, key = '万能薬' })

-- 名前に乗せると、アイコン取得が失敗しても名前のツールチップが出る（0.1.262 の穴を拾う）
tips = {}
hover_pat = '万能薬##need_1_item'
local clicked = W.term_line(ui_of(), 'detail', 'need_1', '万能薬を持っていく (0/1)', terms, {
    color = nil, muted = false, no_focus = true, focus_acts = {},
})
check(has_tip('万能薬'), 'item name hover shows the name')
check(has_tip('ほとんどの状態異常'), 'item name hover shows the description')
check(not has_tip('かばん1'), 'item hover does not show the location tip')
eq(clicked, nil, 'hover alone does not copy')

-- 数に乗せると、場所の内訳だけ（アイテムのツールチップは出さない）
tips = {}
hover_pat = '0/1##need_1_poss_count'
clicked = W.term_line(ui_of(), 'detail', 'need_1', '万能薬を持っていく (0/1)', terms, {
    color = nil, muted = false, no_focus = true, focus_acts = {},
})
check(has_tip('かばん1'), 'count hover still shows the location tip')
check(not has_tip('ほとんどの状態異常'), 'count hover does not show the item description')

-- アイコン／説明が例外でも、show_for_need は名前を出す
tips = {}
hover_pat = nil
local shown = item_tip.show_for_need(ui_of(), { kind = 'item', item_id = 4155, name_ja = '万能薬' })
check(shown == true, 'show_for_need returns true when icon throws')
check(has_tip('万能薬'), 'name is shown when icon throws')

-- 資料が全く無くても、渡した正式名称は出す
item_tip.clear_source()
item_tip.set_source({
    item = function () return nil end,
    icon = function () error('no icon') end,
})
tips = {}
shown = item_tip.show_for_need(ui_of(), { kind = 'item', item_id = 999999, name_ja = '名前だけの品' })
check(shown == true, 'name-only fallback returns true')
check(has_tip('名前だけの品'), 'official name is shown when gamedata is missing')

-- クリックはこれまでどおり正式名称を返す（コピー）
item_tip.set_source({
    item = function (id)
        if id == 4155 then
            return { name = '万能薬', description = 'ほとんどの状態異常を治す。', level = 1, flags = 0 }
        end
        return nil
    end,
})
hover_pat = nil
FAKE.clicks['万能薬'] = true
clicked = W.term_line(ui_of(), 'detail', 'need_1', '万能薬を持っていく (0/1)', terms, {
    color = nil, muted = false, no_focus = true, focus_acts = {},
})
check(clicked and clicked.act == 'copy', 'click copies')
eq(clicked and clicked.text, '万能薬', 'click copies the official name')

for _, k in ipairs({ 'IsItemHovered', 'SetTooltip', 'BeginTooltip', 'EndTooltip', 'InvisibleButton' }) do
    im[k] = saved[k]
end
item_tip.clear_source()

---------------------------------------------------------------------------
-- SF エミネンスカード：星の左にお気に入りのハート（##sfemf_、vector _heart）
---------------------------------------------------------------------------
local db = {
    quests = {
        [12] = { id = 12, name = '記録A', body = '', target = 200, repeatable = true, special = '' },
        [13] = { id = 13, name = '記録B', body = '', target = 500, repeatable = false, special = '' },
        [300] = { id = 300, name = '記録C', body = '', target = 5, repeatable = false, special = '' },
    },
    cats = {},
    roots = {},
    loose = { 12, 13, 300 },
    cat_of = {},
}
local complete = (require('src.core.roe')).new_complete()
local ui = {
    t = function (k, a)
        if type(a) == 'table' then
            local s = k
            for key, val in pairs(a) do s = s:gsub('{' .. key .. '}', tostring(val)) end
            return s
        end
        return k
    end,
    imgui = im,
    settings = S,
    state = {
        roe = { active = { { id = 12, progress = 50 } }, complete = complete, db = db, db_lang = 'ja' },
        open = {},
    },
    roe_db = function () return db end,
    roe_active_count = function () return 1 end,
    roe_can = function () return true end,
    roe_send = function () end,
    mark_settings_dirty = function () end,
    data = app._data(),
    progress = app._progress(),
}
S.eminence = S.eminence or {}
S.eminence.book_show = { accepted = true, not_accepted = true, completed = true, unimplemented = true }
S.eminence.book_text = ''
S.eminence.book_favs_only = false
S.eminence.pins = S.eminence.pins or {}
S.eminence.favs = S.eminence.favs or {}
S.eminence.favs['12'] = nil
S.book = S.book or {}
S.book.last_heading = S.book.last_heading or {}
S.book.last_heading.eminence = 'all'
S.look = 'sf'
theme.set_look('sf')
eminence_sf.reset_cache()
FAKE.labels = {}
eminence_sf.book_body(ui, 'book')
local saw_heart, saw_star = false, false
for _, lab in ipairs(FAKE.labels) do
    if type(lab) == 'string' and lab:find('##sfemf_12', 1, true) then saw_heart = true end
    if type(lab) == 'string' and lab:find('##sfemp_12', 1, true) then saw_star = true end
end
check(saw_heart, 'eminence card has favorite heart hit ##sfemf_')
check(saw_star, 'eminence card still has pin star ##sfemp_')
check(not eminence.is_faved(ui, 12), 'heart starts empty')
FAKE.clicks['##sfemf_12'] = true
eminence_sf.reset_cache()
eminence_sf.book_body(ui, 'book')
check(eminence.is_faved(ui, 12), 'clicking the heart toggles favorite')
-- 中身はグリフではなく既存の vector
local src = io.open(ROOT .. '/src/ui/eminence_sf.lua', 'r'):read('*a')
check(src:find('eminence._heart', 1, true) ~= nil, 'heart is drawn with eminence._heart')
check(src:find('##sfemf_', 1, true) ~= nil, 'heart id is ##sfemf_')

---------------------------------------------------------------------------
-- トラッカー一覧：件と件のあいだだけ細い線（最後のあとは無し、タブ表示では無し）
---------------------------------------------------------------------------
local sep_calls = 0
local saved_sep = W.entry_sep
W.entry_sep = function (ui2)
    sep_calls = sep_calls + 1
    return saved_sep(ui2)
end

local q1, q2, q3 = 'quest.sandoria.001', 'quest.bastok.001', 'quest.jeuno.116'
app.request('pin', q1)
app.request('pin', q2)
app.request('pin', q3)
S.tracker.view = 'list'
S.tracker.visible = true
S.look = 'classic'
theme.set_look('classic')
app.close_all(); app.open_window('tracker')
frame()
sep_calls = 0
frame()
local n_pins = #(app._progress():pinned_list())
check(n_pins >= 2, 'tracker list has at least two pins')
eq(sep_calls, n_pins - 1, 'classic list draws a sep between entries, not after the last')

S.look = 'sf'
theme.set_look('sf')
frame()
sep_calls = 0
frame()
eq(sep_calls, n_pins - 1, 'SF list draws a sep between entries, not after the last')

S.look = 'yunaui'
theme.set_look('yunaui')
frame()
sep_calls = 0
frame()
eq(sep_calls, n_pins - 1, 'YunaUI list draws a sep between entries, not after the last')

S.tracker.view = 'tabs'
S.look = 'classic'
theme.set_look('classic')
frame()
sep_calls = 0
frame()
eq(sep_calls, 0, 'tabs view has no entry separators')

S.look = 'sf'
theme.set_look('sf')
frame()
sep_calls = 0
frame()
eq(sep_calls, 0, 'SF tabs view has no entry separators')

W.entry_sep = saved_sep
S.tracker.view = 'list'
app.close_window('tracker'); frame()

-- 色：SF はシアン、他は border（1px の線）
do
    local lines = {}
    local imgui = package.loaded['imgui']
    local real_dl = imgui.GetWindowDrawList()
    imgui.GetWindowDrawList = function ()
        return setmetatable({
            AddLine = function (_, a, b, col, thick)
                lines[#lines + 1] = { col = col, thick = thick }
            end,
        }, { __index = real_dl })
    end
    theme.set_look('sf')
    lines = {}
    W.entry_sep({ imgui = imgui, settings = { look = 'sf' } })
    check(#lines >= 1, 'entry_sep draws a line in SF')
    eq(lines[1].col, theme.u32('sf_cyan', 0.32), 'SF separator is cyan-ish')
    theme.set_look('classic')
    lines = {}
    W.entry_sep({ imgui = imgui, settings = { look = 'classic' } })
    check(#lines >= 1, 'entry_sep draws a line in classic')
    eq(lines[1].col, theme.u32('border', 0.40), 'classic separator uses border')
    imgui.GetWindowDrawList = function () return real_dl end
end

---------------------------------------------------------------------------
-- SF 本：カード格子と詳細の境目をドラッグして幅を変える。割合は設定に残す。
---------------------------------------------------------------------------
S.look = 'sf'
theme.set_look('sf')
S.book.tab = 'mission'
S.book.splits.mission, S.book.splits.quest, S.book.splits.eminence = 0.56, 0.56, 0.56
app.close_all(); app.open_window('book')
frame(); frame()
local w_before = S.windows.book.w
check(labeled('##astertrail_sf_split_mission'), 'SF mission splitter is drawn')
check(not labeled('##book_split') or true, 'classic splitter id may be absent in SF') -- just a note; we only require the SF id

local dirty_n = 0
local saved_dirty = app.mark_settings_dirty
app.mark_settings_dirty = function (...)
    dirty_n = dirty_n + 1
    if saved_dirty then return saved_dirty(...) end
end

local last = nil
local saved_ib2, saved_act, saved_mp, saved_avail, saved_hov, saved_cur =
    rawget(im, 'InvisibleButton'), rawget(im, 'IsItemActive'), rawget(im, 'GetMousePos'),
    rawget(im, 'GetContentRegionAvail'), rawget(im, 'IsItemHovered'), rawget(im, 'SetMouseCursor')
local mx, holding = 500, true
local cursors = {}
im.GetContentRegionAvail = function () return 1000, 600 end
im.InvisibleButton = function (id, size)
    last = id
    FAKE.labels[#FAKE.labels + 1] = id
    return false
end
im.IsItemActive = function ()
    return holding and type(last) == 'string' and last:find('##astertrail_sf_split_', 1, true) ~= nil
end
im.IsItemHovered = function ()
    return type(last) == 'string' and last:find('##astertrail_sf_split_', 1, true) ~= nil
end
im.GetMousePos = function () return { x = mx, y = 300 } end
im.SetMouseCursor = function (c) cursors[#cursors + 1] = c end

local r0 = book.split_of(S, 'mission')
local q0, e0 = S.book.splits.quest, S.book.splits.eminence
dirty_n = 0
frame()
mx = 600; frame()
check(book.split_of(S, 'mission') > r0, 'SF drag right widens the cards: ' .. tostring(book.split_of(S, 'mission')))
eq(S.book.splits.quest, q0, 'quest split unchanged while dragging SF missions')
eq(S.book.splits.eminence, e0, 'eminence split unchanged while dragging SF missions')
check(dirty_n >= 1, 'split change uses mark_settings_dirty')
check(#cursors >= 1, 'resize cursor is set on hover or drag')
mx = 99999; frame()
local hi = book.split_of(S, 'mission')
check(hi < 1, 'SF split ratio stays below 1: ' .. tostring(hi))
-- 右の最低幅を残す（割合 × 窓幅が min_right を侵さない）
check(1000 - (hi * 1000) >= book.SPLIT_MIN_DETAIL - 1, 'detail keeps a minimum width')
holding = false; frame()
local mission_after = S.book.splits.mission
eq(S.windows.book.w, w_before, 'window size unchanged after SF split drag')

-- フォントを変えても、保存した割合はそのまま
S.font_scale = 1.45
if S.fonts then S.fonts.book = 1.45; S.fonts.list = 1.45; S.fonts.detail = 1.45 end
frame()
eq(S.book.splits.mission, mission_after, 'split ratio is kept when font size changes')

-- 狭い窓では動かさない
im.GetContentRegionAvail = function () return 380, 260 end
local r_n = book.split_of(S, 'mission')
holding = true; mx = 500; frame(); mx = 700; frame(); holding = false; frame()
eq(book.split_of(S, 'mission'), r_n, 'narrow SF window: no drag change')
im.GetContentRegionAvail = function () return 1000, 600 end

-- クエスト／エミネンスはそれぞれのタブの割合
S.book.tab = 'quest'; frame()
check(labeled('##astertrail_sf_split_quest'), 'SF quest splitter is drawn')
eq(book.split_of(S, 'quest'), q0, 'quest starts at its own saved width')
holding = true; mx = 500; frame(); mx = 620; frame(); holding = false; frame()
check(book.split_of(S, 'quest') ~= q0, 'quest split changes on its SF tab')
eq(S.book.splits.mission, mission_after, 'mission split stays after changing SF quest')

S.book.tab = 'eminence'; frame(); frame()
check(labeled('##astertrail_sf_split_eminence'), 'SF eminence splitter is drawn')
eq(book.split_of(S, 'eminence'), e0, 'eminence starts at its own saved width')
holding = true; mx = 500; frame(); mx = 580; frame(); holding = false; frame()
check(book.split_of(S, 'eminence') ~= e0, 'eminence split changes on its SF tab')
eq(S.book.splits.mission, mission_after, 'mission split stays after changing SF eminence')

-- 幅の計算：保存割合 0.2〜0.8 をそのまま使い、ピクセルの最低幅で抑える（0.35〜0.70 の追加クランプはしない）
S.book.splits.mission = 0.22
local w22 = book.sf_cards_width(S, 1000, 'mission')
check(w22 == book.SPLIT_MIN_LIST, 'saved 0.22 is allowed; pixel min applies: ' .. tostring(w22))
S.book.splits.mission = 0.78
local w78 = book.sf_cards_width(S, 1000, 'mission')
local max_w = 1000 - book.SF_SPLIT_GAP - book.SPLIT_MIN_DETAIL
check(w78 == max_w, 'saved 0.78 is allowed; pixel max applies: ' .. tostring(w78))

-- クラシックに戻すと SF のスプリッタは出ない
S.look = 'classic'
theme.set_look('classic')
S.book.tab = 'mission'
FAKE.labels = {}
frame(); frame()
check(labeled('##book_split'), 'classic book still uses ##book_split')
check(not labeled('##astertrail_sf_split_mission'), 'classic book does not draw the SF splitter')

im.InvisibleButton, im.IsItemActive, im.GetMousePos = saved_ib2, saved_act, saved_mp
im.GetContentRegionAvail, im.IsItemHovered, im.SetMouseCursor = saved_avail, saved_hov, saved_cur
app.mark_settings_dirty = saved_dirty
app.close_window('book'); frame()
S.look = 'classic'
theme.set_look('classic')

print('test_sf_263 ok')
