-- 0.1.37: 設定のタブ（LB/RB で切り替え）と、開いたときの位置（前回の位置を覚える）
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local sui = require('src.ui.settings_ui')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(S.remember_position, false, 'default: do not remember')
eq(S.marks.zoom_follow, true, 'zoom follow default on')

local function open_settings() FAKE.tab_selected = nil; app.open_window('settings'); frame(); frame(); frame() end

-- 開くと最初のタブ、カーソルは中身の最初（0.1.175〜：本の中に出すので「本を開く」は無い）
open_settings()
eq(sui.current_tab(), 'look', 'first tab')
eq(focus.current('settings'), 'lang', 'cursor on first setting')
check(labeled('◆ 見た目'), 'tab row drawn with current mark')
check(not labeled('##open_book'), 'no open-book button (already in the book)')
check(not labeled('地図を出す'), 'other tabs hidden')

-- RB（パッド 9）で次のタブ、カーソルは中身の最初
pad(9, 1); pad(9, 0); frame(); frame(); frame()
eq(sui.current_tab(), 'layout', 'RB next tab')
eq(focus.current('settings'), 'lock', 'cursor on first of layout')
-- LB で戻り、さらに LB で最後へ回る
pad(8, 1); pad(8, 0); frame(); frame()
eq(sui.current_tab(), 'look', 'LB back')
pad(8, 1); pad(8, 0); frame(); frame()
eq(sui.current_tab(), 'about', 'LB wraps to last')
-- Tab キーも同じ
press(0x0F); frame(); frame()
eq(sui.current_tab(), 'look', 'Tab wraps to first')

-- 地図のタブ
for _ = 1, 3 do pad(9, 1); pad(9, 0); frame(); frame() end
eq(sui.current_tab(), 'map', 'map tab')
check(labeled('地図を出す'), 'map toggle shown in map tab')

-- 閉じて開き直すと最初のタブ（覚えない）
app.close_window('settings'); frame()
open_settings()
eq(sui.current_tab(), 'look', 'reopen: first tab')
eq(focus.current('settings'), 'lang', 'reopen: first setting')

-- 覚えるにすると、タブとカーソルはそのまま
S.remember_position = true
pad(9, 1); pad(9, 0); frame(); frame()
focus.set('settings', 'filters'); frame()
app.close_window('settings'); frame()
app.open_window('settings'); frame(); frame()
eq(sui.current_tab(), 'layout', 'remember: same tab')
eq(focus.current('settings'), 'filters', 'remember: same cursor')
app.close_window('settings'); frame()
S.remember_position = false

-- 本：前回のタブと行に戻る（0.1.203〜。設定の「前回の位置を覚える」は設定のタブだけ）
-- （設定を閉じると本に戻るので、本も閉じてから開き直す。0.1.175〜）
eq(app.state.open.book, true, 'closing settings leaves the book open')
app.close_window('book'); frame()
S.book.tab = 'quest'
S.book.last_row = 'mission.sandoria.001'   -- クエストの一覧には無い
app.open_window('book'); frame(); frame(); frame()
eq(S.book.tab, 'quest', 'book reopens on last tab')
check(labeled('クエスト') or labeled('Quests'), 'quest tab')
local cur = focus.current('book') or ''
check(cur:find('^sec_quest_') or cur:find('^cat_'), 'book cursor on the tab top heading: ' .. cur)
eq(S.book.last_row, nil, 'remembered mission is hidden on quest tab -> last_row cleared')
-- 別の行を選んで閉じ、開き直すと選んだ行のまま
app.select_in_book('quest.sandoria.006', true); frame(); frame()
eq(S.book.last_row, 'quest.sandoria.006', 'selected a quest')
app.close_window('book'); frame()
app.open_window('book'); frame(); frame(); frame()
eq(S.book.tab, 'quest', 'reopen: same tab')
eq(S.book.last_row, 'quest.sandoria.006', 'reopen: same row')
check(tostring(focus.current('book') or ''):find('^sec_quest_'), 'reopen: cursor on the heading: ' .. tostring(focus.current('book')))
-- 覚える設定をオンにしても同じ（本はオフでも覚える）
S.remember_position = true
S.book.tab = 'quest'; frame()
app.select_in_book('quest.sandoria.006', true); frame(); frame()
app.close_window('book'); frame()
app.open_window('book'); frame(); frame(); frame()
eq(S.book.last_row, 'quest.sandoria.006', 'remember: same row')
check(tostring(focus.current('book') or ''):find('^sec_quest_'), 'remember: cursor on the heading: ' .. tostring(focus.current('book')))
app.close_window('book'); frame()
S.remember_position = false

-- ミッションメニューから開いても、前回のタブ・行に戻す（0.1.206〜）
app.state.pending_book = 'mission'; frame(); frame(); frame()
eq(S.book.tab, 'quest', 'mission menu restores last tab')
eq(S.book.last_row, 'quest.sandoria.006', 'mission menu restores last row')
check(tostring(focus.current('book') or ''):find('^sec_quest_'), 'mission menu cursor on the heading: ' .. tostring(focus.current('book')))
app.close_window('book'); frame()

local function list_rows()
    for _, it in ipairs(focus.windows.book.list or {}) do if it.id:find('^row_') then return true end end
    return false
end
local function close_book()
    -- 0.1.203〜：一覧にいればキャンセルでタブへ、もう一度で閉じる
    for _ = 1, 3 do
        if not app.state.open.book or app.state.active ~= 'book' then break end
        press(0x01); frame()
    end
end
-- 0.1.175〜：設定は本の中。設定から開く → キャンセルで設定を閉じて本（一覧）へ、もう一度で本も閉じる
app.open_window('settings'); frame(); frame()
eq(app.state.open.book, true, 'settings open the book')
eq(app.state.active, 'settings', 'settings operating')
check(not list_rows(), 'list hidden while settings are shown')
check(labeled('◆ 見た目'), 'settings tabs drawn in the book')
press(0x01); frame(); frame()
eq(app.state.open.settings, false, 'settings closed')
eq(app.state.open.book, true, 'book still open')
eq(app.state.active, 'book', 'back to the book')
check(list_rows(), 'list back')
check(app.want_keys(), 'still capturing for the book')
close_book()
eq(app.state.open.book, false, 'book closed')
eq(app.state.active, nil, 'back to the game')
-- 逆（本 → 設定）もこれまでどおり
app.open_window('book'); frame(); app.open_window('settings'); frame()
press(0x01); frame()
eq(app.state.active, 'book', 'settings closed -> book')
close_book()
eq(app.state.active, nil, 'book closed -> game')
-- 3枚：本 → 設定 → 地図（必要品まとめは 0.1.173 でなくした）
app.open_window('book'); frame(); app.open_window('settings'); frame(); app.open_map(); frame()
press(0x01); frame(); eq(app.state.active, 'settings', 'map -> settings')
press(0x01); frame(); eq(app.state.active, 'book', 'settings -> book')
close_book()
eq(app.state.active, nil, 'book -> game')

print('test_tabs ok')
