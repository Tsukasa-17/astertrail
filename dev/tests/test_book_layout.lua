-- 0.1.40: 本の上の行（タブ＋右端のボタン）、検索は状態の右、地域・状態はパッドでもプルダウン、一覧と詳細の境目
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local book = require('src.ui.book')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()

app.open_window('book'); frame(); frame()
-- ボタンは上の行（タブと同じ行）。下の行はない
local function item(id)
    for _, it in ipairs(focus._list and focus._list('book') or {}) do if it.id == id then return it end end
end
for _, id in ipairs({ 'compass_toggle', 'tracker_toggle', 'eminence_toggle', 'open_settings', 'close' }) do
    check(labeled('##' .. id), 'button ' .. id)
end
-- タブの行で右へ動くと、右端のボタンに届く（0.1.202 どおり。タブは上の行）
focus.set('book', 'tab_eminence'); frame()   -- 右端のタブ（0.1.172〜 エミネンス）
press(0xCD); frame()
eq(focus.current('book'), 'compass_toggle', 'right from tabs reaches compass button (0.1.173)')
press(0xCD); frame()
eq(focus.current('book'), 'tracker_toggle', 'then tracker button')
press(0xCD); frame()
eq(focus.current('book'), 'eminence_toggle', 'then eminence button (0.1.177)')
press(0xCD); press(0xCD); frame()
eq(focus.current('book'), 'close', 'then settings, then close')
-- 決定で閉じる（その行の閉じる）
press(0x1C); frame(); frame()
eq(app.state.open.book, false, 'close button in top row works')
app.open_window('book'); frame(); frame()
local cur0 = tostring(focus.current('book') or '')
check(cur0:find('^sec_') or cur0:find('^cat_') or cur0:find('^row_'), 'reopen on a heading or a list row: ' .. cur0)

-- 検索は地域・状態と同じ行（右へ動くと 地域 → 状態 → 検索）
S.book.tab = 'mission'; frame(); frame()
focus.set('book', 'f_area'); frame()
press(0xCD); frame(); eq(focus.current('book'), 'f_state', 'area -> state')
press(0xCD); frame(); eq(focus.current('book'), 'search', 'state -> search on same row')

-- 地域：決定で一覧を開き、下で動かし、決定で選ぶ
S.book.filters.area = 'all'
focus.set('book', 'f_area'); frame()
press(0x1C); frame()
local dd = focus.dropdown('book')
check(dd ~= nil and dd.id == 'f_area', 'dropdown opened by confirm')
eq(S.book.filters.area, 'all', 'value not changed by opening')
press(0xD0); frame()
eq(focus.dropdown('book').idx, 2, 'down moves in the list')
eq(focus.current('book'), 'f_area', 'cursor stays on the control')
press(0x1C); frame(); frame()
eq(focus.dropdown('book'), nil, 'closed after pick')
check(S.book.filters.area ~= 'all', 'area picked: ' .. tostring(S.book.filters.area))
-- キャンセルは一覧だけ閉じる（本は閉じない、値も変わらない）
local before = S.book.filters.area
press(0x1C); frame(); press(0xD0); frame()
press(0x01); frame()
eq(focus.dropdown('book'), nil, 'cancel closes the dropdown')
eq(app.state.open.book, true, 'book stays open')
eq(S.book.filters.area, before, 'value unchanged by cancel')
-- 上で一番上から最後へ回る
S.book.filters.area = 'all'; frame()
press(0x1C); frame(); press(0xC8); frame()
eq(focus.dropdown('book').idx, focus.dropdown('book').n, 'up wraps to last')
press(0x01); frame()
S.book.filters.area = 'all'
-- 状態も同じ（パッド）
focus.set('book', 'f_state'); frame()
pad(12, 1); pad(12, 0); frame()
check(focus.dropdown('book') ~= nil, 'state dropdown by pad A')
pad(13, 1); pad(13, 0); frame()
eq(focus.dropdown('book'), nil, 'pad B closes dropdown only')
eq(app.state.open.book, true, 'book still open after pad B')
S.book.filters.state = 'all'

-- 境目：幅の計算（両側に最低限）
eq(book.list_width(1000, 0.56), 560, 'ratio')
eq(book.list_width(1000, 0.1), book.SPLIT_MIN_LIST, 'min list')
eq(book.list_width(1000, 0.95), 1000 - book.SPLIT_MIN_DETAIL, 'min detail')
eq(book.tree_width(1000, 560, 0.18), 180, 'tree default is 18% of the window')
check(labeled('##book_split'), 'detail splitter drawn')
check(labeled('##book_split_tree'), 'tree splitter drawn')
eq(book.tree_split_of(S), 0.18, 'tree split default')
-- ドラッグ：つかんで右へ 100px
local im = package.loaded['imgui']
local last = nil
local saved_ib, saved_act, saved_mp = rawget(im, 'InvisibleButton'), rawget(im, 'IsItemActive'), rawget(im, 'GetMousePos')
local mx, holding = 500, true
local saved_avail = rawget(im, 'GetContentRegionAvail')
im.GetContentRegionAvail = function () return 1000, 600 end
im.InvisibleButton = function (id, size) last = id; FAKE.labels[#FAKE.labels + 1] = id; return false end
im.IsItemActive = function () return holding and last == '##book_split' end
im.GetMousePos = function () return { x = mx, y = 300 } end
S.book.tab = 'mission'
local r0 = book.split_of(S)
local w_before = S.windows.book.w
local q0, e0 = S.book.splits.quest, S.book.splits.eminence
frame()
mx = 600; frame()
check(book.split_of(S) > r0, 'drag right widens the list: ' .. tostring(book.split_of(S)))
eq(S.book.splits.quest, q0, 'quest split unchanged while dragging missions')
eq(S.book.splits.eminence, e0, 'eminence split unchanged while dragging missions')
mx = 99999; frame()
check(book.split_of(S) < 1, 'clamped ratio ' .. tostring(book.split_of(S)))
holding = false; frame()
local mission_after = S.book.splits.mission
-- 狭い窓（両側の最低限が入らない）では動かさない
im.GetContentRegionAvail = function () return 380, 260 end
local r_n = book.split_of(S); holding = true; mx = 500; frame(); mx = 700; frame(); holding = false; frame()
eq(book.split_of(S), r_n, 'narrow window: no drag change')
im.GetContentRegionAvail = function () return 1000, 600 end
eq(S.windows.book.w, w_before, 'window size unchanged')
-- クエストタブで動かすと、ミッションの値はそのまま
S.book.tab = 'quest'; frame()
eq(book.split_of(S), q0, 'quest starts at its own saved width')
holding = true; mx = 500; frame(); mx = 620; frame(); holding = false; frame()
check(book.split_of(S) ~= q0, 'quest split changes on its tab')
eq(S.book.splits.mission, mission_after, 'mission split stays after changing quest')
eq(S.book.splits.eminence, e0, 'eminence split stays after changing quest')
local quest_after = S.book.splits.quest
-- エミネンスでも同じ
S.book.tab = 'eminence'; frame()
eq(book.split_of(S), e0, 'eminence starts at its own saved width')
holding = true; mx = 500; frame(); mx = 580; frame(); holding = false; frame()
check(book.split_of(S) ~= e0, 'eminence split changes on its tab')
eq(S.book.splits.mission, mission_after, 'mission split stays after changing eminence')
eq(S.book.splits.quest, quest_after, 'quest split stays after changing eminence')
-- 保存される値の範囲と、前の共通の値の移し替え（0.1.192〜）
local settings = require('src.core.settings')
local hi = settings.merge({ settings_schema = 1, book = { split = 5 } })
eq(hi.book.splits.mission, 0.8, 'old split clamp hi: mission')
eq(hi.book.splits.quest, 0.8, 'old split clamp hi: quest')
eq(hi.book.splits.eminence, 0.8, 'old split clamp hi: eminence')
eq(hi.book.split, nil, 'old shared split not kept')
local lo = settings.merge({ settings_schema = 1, book = { split = 0 } })
eq(lo.book.splits.mission, 0.2, 'old split clamp lo')
eq(lo.book.splits.quest, 0.2, 'old split clamp lo quest')
eq(lo.book.splits.eminence, 0.2, 'old split clamp lo eminence')
local kept = settings.merge({ settings_schema = 1, book = { split = 0.7 } })
eq(kept.book.splits.mission, 0.7, 'old shared value: mission')
eq(kept.book.splits.quest, 0.7, 'old shared value: quest')
eq(kept.book.splits.eminence, 0.7, 'old shared value: eminence')
local part = settings.merge({ settings_schema = 1, book = { split = 0.7, splits = { mission = 0.3 } } })
eq(part.book.splits.mission, 0.3, 'per-tab value wins')
eq(part.book.splits.quest, 0.7, 'missing tab gets the old shared value')
eq(part.book.splits.eminence, 0.7, 'missing eminence gets the old shared value')
local d = settings.defaults()
eq(d.book.splits.mission, 0.56, 'split default mission')
eq(d.book.splits.quest, 0.56, 'split default quest')
eq(d.book.splits.eminence, 0.56, 'split default eminence')
eq(d.book.split, nil, 'no shared split in defaults')
-- ダブルクリックで、今のタブだけ元に戻す
S.book.tab = 'eminence'
local saved_hov, saved_dbl = rawget(im, 'IsItemHovered'), rawget(im, 'IsMouseDoubleClicked')
im.IsItemHovered = function () return last == '##book_split' end
im.IsMouseDoubleClicked = function () return true end
frame()
eq(S.book.splits.eminence, 0.56, 'double click resets the current tab')
eq(S.book.splits.mission, mission_after, 'double click leaves the other tabs')
eq(S.book.splits.quest, quest_after, 'double click leaves quest')
im.IsItemHovered, im.IsMouseDoubleClicked = saved_hov, saved_dbl
im.InvisibleButton, im.IsItemActive, im.GetMousePos = saved_ib, saved_act, saved_mp
im.GetContentRegionAvail = saved_avail
app.close_window('book'); frame()
print('test_book_layout ok')
