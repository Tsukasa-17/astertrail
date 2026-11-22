-- 0.1.175：本の上の行（タブと 地域・状態・検索 を1行に）、肩ボタンは3つの場所だけ、設定は本の中
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local book_ui = require('src.ui.book')
local sui = require('src.ui.settings_ui')
local imgui = package.loaded['imgui']
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()

local function item(id)
    for _, it in ipairs(focus.windows.book.list or {}) do if it.id == id then return it end end
end
local function area() local it = item(focus.current('book')); return it and book_ui.area_of(it.section) end
local function key(action) app.input(action, true, 'key'); app.input(action, false, 'key'); frame() end
local function list_rows()
    for _, it in ipairs(focus.windows.book.list or {}) do if it.id:find('^row_') then return true end end
    return false
end

-- (6) 広い窓：地域・状態・検索はタブと同じ行（キー・パッドでも同じ行＝左右で移る）
local avail0 = imgui.GetContentRegionAvail
imgui.GetContentRegionAvail = function () return 2000, 600 end
app.open_window('book'); frame(); frame()
eq(item('tab_mission').row, 'tabs', 'tabs row')
eq(item('f_area'), nil, 'no area filter (0.1.225)')
eq(item('f_state'), nil, 'no state filter (0.1.225)')
eq(item('search').row, 'tabs', 'search on the tab row')
eq(item('open_settings').row, 'tabs', 'icons on the tab row')
eq(item('col_name').row, 'cols', 'column chips on the next row')
eq(item('show_accepted').row, 'cols', 'show checks on the same row as the columns (0.1.225)')
eq(book_ui.area_of(item('tab_mission').section), 'top', 'tabs are in the top area')
eq(book_ui.area_of(item('search').section), 'top', 'search stays in the top area')
-- 左右：タブ → … → 検索 → 右端のボタン（並びは描いた順）
focus.set('book', 'tab_eminence'); key('right')
eq(focus.current('book'), 'search', 'right from the last tab goes to the search')
key('right')
eq(focus.current('book'), 'compass_toggle', 'then the icons on the right')
-- 下で列の行
focus.set('book', 'search'); key('down')
local dn = tostring(focus.current('book'))
check(dn:find('^col_') ~= nil or dn:find('^show_') ~= nil, 'down from the tab row goes to the show/column chips: ' .. dn)
-- エミネンス：検索はタブの行、表示のチェック・達成を隠す・列は次の行（0.1.226〜：分類・状態の選択はなし）
S.book.tab = 'eminence'; frame(); frame()
eq(item('roe_root'), nil, 'no eminence category filter')
eq(item('roe_state'), nil, 'no eminence state filter')
eq(item('roe_search').row, 'tabs', 'eminence search on the tab row')
eq(item('roe_show_accepted').row, 'f2', 'eminence show checks on the next row')
eq(item('roe_show_completed').row, 'f2', '達成 on the next row')
eq(item('roe_hide_done'), nil, 'no 達成済みを非表示 checkbox')
eq(book_ui.area_of(item('roe_show_completed').section), 'top', 'and still in the top area')
S.book.tab = 'mission'; frame(); frame()
-- 狭い窓：地域・状態・検索は次の行
imgui.GetContentRegionAvail = avail0
frame(); frame()
eq(item('tab_mission').row, 'tabs', 'narrow: tabs row')
-- 0.1.225〜：地域・状態が無くなったので、ふつうの幅なら検索もタブの行に入る
check(item('search').row == 'f' or item('search').row == 'tabs', 'narrow: search on the tab row or its own row')
eq(item('close').row, 'tabs', 'narrow: close stays on the tab row')
app.close_window('book'); frame()

-- (7) 肩ボタン（Tab・LB/RB）は 上の行 → 見出しの木 → 一覧 → 詳細 を回る。戻ると前にいた所
app.open_window('book'); frame(); frame()
-- 行が選ばれていなければ、見出しから決定で中の行へ（詳細へ回れるように）
local cur = tostring(focus.current('book') or '')
if cur:find('^sec_') or cur:find('^cat_') then
    key('confirm'); frame(); frame()
    cur = tostring(focus.current('book') or '')
    if cur:find('^sec_') or cur:find('^cat_') then key('confirm'); frame(); frame() end
end
check(tostring(focus.current('book')):find('^row_') ~= nil, 'in the list (confirm from a heading if needed)')
key('down'); key('down')
local row3 = focus.current('book')
key('section_next'); eq(area(), 'detail', 'R: list -> detail')
key('section_next'); eq(area(), 'top', 'R: detail -> top')
key('section_next'); eq(area(), 'tree', 'R: top -> tree')
key('section_next'); eq(area(), 'list', 'R: tree -> list')
eq(focus.current('book'), row3, 'back on the same row')
key('section_prev'); eq(area(), 'tree', 'L: list -> tree')
key('section_prev'); eq(area(), 'top', 'L: tree -> top')
key('section_prev'); eq(area(), 'detail', 'L: top -> detail')
-- 詳細の中は十字キーの上下で区画をまたぐ（状態の行 → 手順）
local d0 = focus.current('book')
local moved_sections = { [item(d0).section] = true }
for _ = 1, 6 do
    key('down')
    local it = item(focus.current('book'))
    if it then moved_sections[it.section] = true end
    eq(book_ui.area_of(it.section), 'detail', 'down stays in the detail')
end
check(focus.current('book') ~= d0, 'down moves inside the detail')
local nsec = 0
for _ in pairs(moved_sections) do nsec = nsec + 1 end
check(nsec >= 2, 'down crosses detail sections (' .. nsec .. ')')
-- 一覧のいちばん上で上を押しても上の行には行かない（場所の切り替えは肩ボタン）
key('section_next'); key('section_next'); key('section_next')
eq(area(), 'list', 'back in the list')
for _ = 1, 5 do key('up') end
eq(area(), 'list', 'up stays in the list')
app.close_window('book'); frame()

-- (10) 設定は本の中（一覧と詳細の場所）。⚙️ で出し、もう一度で一覧に戻る
app.open_window('book'); frame(); frame()
FAKE.clicks['##open_settings'] = true; frame(); frame()
eq(app.state.open.settings, true, 'gear shows the settings')
eq(app.state.open.book, true, 'in the book')
eq(app.state.active, 'settings', 'pad goes to the settings')
check(not list_rows(), 'list hidden')
check(labeled('##sfcat_look'), 'settings categories drawn (0.1.304: same layout as Astral)')
check(item('tab_mission') ~= nil, 'book tab row still drawn')
check(not focus.shows_frame('book'), 'no book cursor frame while in the settings')
check(focus.shows_frame('settings'), 'settings cursor frame')
-- LB/RB は設定のタブ
local t0 = sui.current_tab()
pad(9, 1); pad(9, 0); frame(); frame()
check(sui.current_tab() ~= t0, 'RB switches settings tabs')
pad(8, 1); pad(8, 0); frame(); frame()
eq(sui.current_tab(), t0, 'LB back')
-- 本を押しても操作は設定のまま
app.activate('book')
eq(app.state.active, 'settings', 'clicking the book keeps the settings operating')
-- キャンセルで一覧へ
press(0x01); frame(); frame()
eq(app.state.open.settings, false, 'cancel closes the settings')
eq(app.state.active, 'book', 'back to the book')
check(list_rows(), 'list back')
check(focus.shows_frame('book'), 'book frame back')
-- ⚙️ を2回：出して戻す
FAKE.clicks['##open_settings'] = true; frame(); frame()
eq(app.state.open.settings, true, 'gear again')
FAKE.clicks['##open_settings'] = true; frame(); frame()
eq(app.state.open.settings, false, 'gear toggles back to the list')
-- 設定の「一覧に戻る」
FAKE.clicks['##open_settings'] = true; frame(); frame()
check(labeled('戻る##close'), 'back button (0.1.304: footer)')
FAKE.clicks['##close'] = nil
-- タブを押すと一覧に戻ってそのタブ
FAKE.clicks['##tab_quest'] = true; frame(); frame()
eq(app.state.open.settings, false, 'a book tab leaves the settings')
eq(S.book.tab, 'quest', 'and opens that tab')
-- 本の項目を選ぶ（トラッカーなどから）と設定は閉じる
app.open_window('settings'); frame()
app.select_in_book('quest.bastok.001'); frame(); frame()
eq(app.state.open.settings, false, 'select_in_book leaves the settings')
eq(S.book.last_row, 'quest.bastok.001', 'and selects the entry')
-- 本を閉じると設定も閉じる
app.open_window('settings'); frame()
app.close_window('book'); frame()
eq(app.state.open.settings, false, 'closing the book closes the settings')
eq(app.state.open.book, false, 'book closed')
eq(app.state.active, nil, 'back to the game')
-- コマンドでも本の中に出す
cmd('/astertrail settings'); frame(); frame()
eq(app.state.open.book, true, 'command opens the book')
eq(app.state.open.settings, true, 'in settings')
app.close_all(); frame()
-- 詳細だけの窓にしたら設定は閉じる
app.open_window('settings'); frame()
app.open_detail_solo('quest.bastok.001'); frame()
eq(app.state.open.settings, false, 'solo detail closes the settings')
app.close_all(); frame()

-- 設定だけの窓は作らない
for title in pairs(FAKE.begin_flags or {}) do
    check(not tostring(title):find('設定 - Astertrail', 1, true), 'no separate settings window: ' .. tostring(title))
end

print('test_book_areas ok')
