-- 0.1.208: 左の見出しの木で選び、決定で中央の表へ。木でキャンセルすると本を閉じる
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local book = require('src.ui.book')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()

local function cur() return tostring(focus.current('book') or '') end
local function key(action)
    app.input(action, true, 'key'); app.input(action, false, 'key'); frame(); frame()
end
local function open_tab(tab)
    S.book.tab = tab
    S.book.last_row = nil
    S.book.last_heading = S.book.last_heading or {}
    S.book.last_heading[tab] = nil
    if S.eminence then S.eminence.last_id = nil end
    local em = require('src.ui.eminence')
    if em.select then em.select(nil) end
    app.close_window('book'); frame()
    app.open_window('book'); frame(); frame(); frame()
end

-- ミッション：すべて → 系列。決定で行へ。キャンセルは見出しへ、もう一度で閉じる
open_tab('mission')
eq(S.book.tab, 'mission', 'mission tab')
eq(cur(), 'sec_mission_all', 'mission starts on すべて: ' .. cur())
check(texted('見出しを選び') or texted('picks a heading'), 'mission tree help')
key('down')
local mh = cur()
check(mh:find('^sec_mission_') and mh ~= 'sec_mission_all', 'down to a series heading: ' .. mh)
key('up')
eq(cur(), 'sec_mission_all', 'up back to すべて')
key('down')
eq(cur(), mh, 'down to the series again')
local mid = mh:match('^sec_mission_(.+)$')
check(mid ~= nil, 'mission heading id')
key('left')
eq(cur(), mh, 'left keeps focus on the heading')
eq(book.is_collapsed(S, 'mission', mid), true, 'left collapses the series')
key('right')
eq(cur(), mh, 'right keeps focus on the heading')
eq(book.is_collapsed(S, 'mission', mid), false, 'right expands the series')
key('left')
eq(book.is_collapsed(S, 'mission', mid), true, 'collapsed again')
key('confirm')
eq(book.is_collapsed(S, 'mission', mid), false, 'confirm expands if collapsed')
local mr = cur()
check(mr:find('^row_'), 'confirm enters the first table row: ' .. mr)
check(texted('行を選び') or texted('picks a row') or texted('見出しへ戻ります') or texted('returns to the heading') or texted('operating_rows'), 'mission row help')
local before_col = book.is_collapsed(S, 'mission', mid)
key('left')
local after_left = cur()
check(after_left:find(mr:sub(5), 1, true) or after_left == mr,
    'left on a row stays in the row (in-row move ok): ' .. after_left)
check(not after_left:find('^sec_'), 'left on a row does not leave for the heading')
eq(book.is_collapsed(S, 'mission', mid), before_col, 'left on a row does not collapse')
key('up')
eq(cur(), after_left, 'up on the first row stays')
key('down')
local mr2 = cur()
check(mr2 ~= after_left and not mr2:find('^sec_'), 'down moves to another row: ' .. mr2)
key('back')
eq(cur(), mh, 'cancel from a row returns to the same series heading')
key('back')
eq(app.state.open.book, false, 'cancel in the tree closes the book')

-- クエスト：すべて → 地域。右でエリアへ。決定で行へ。木でキャンセルは閉じる
open_tab('quest')
eq(cur(), 'sec_quest_all', 'quest starts on すべて: ' .. cur())
key('down')
local rh = cur()
check(rh:find('^sec_quest_') and not rh:find('zone_') and rh ~= 'sec_quest_all',
    'down to a region heading: ' .. rh)
eq(rh, 'sec_quest_sandoria', 'first region is San d\'Oria')
-- バストゥークへ
local found_bastok
for _ = 1, 8 do
    if cur() == 'sec_quest_bastok' then found_bastok = true; break end
    key('down')
end
check(found_bastok, 'can reach Bastok region')
-- 決定は表へ（下のエリアへは入らない）
key('confirm')
local qr0 = cur()
check(qr0:find('^row_'), 'confirm from a region enters the table: ' .. qr0)
key('back')
eq(cur(), 'sec_quest_bastok', 'cancel from the table returns to Bastok')
-- 右で下のエリアへ
key('right')
local zh = cur()
check(zh:find('/zone_', 1, true) or zh:find('^sec_quest_zone_'), 'right moves into the first area heading: ' .. zh)
key('down')
local zh2 = cur()
check((zh2:find('/zone_', 1, true) or zh2:find('^sec_quest_zone_')) and zh2 ~= zh, 'down among visible area headings: ' .. zh2)
key('up')
eq(cur(), zh, 'up back to the first area')
local zid = zh:match('/(zone_.+)$') or zh:match('^sec_quest_zone_(.+)$')
key('left')
eq(cur(), zh, 'left on an open area collapses it (leaf stays on it)')
-- エリアは子が無いので、左は親（地域）へ戻る
-- または閉じるだけ。子が無ければ has_children は false で、左は親へ
eq(cur() == zh or cur() == 'sec_quest_bastok', true, 'left on an area stays or goes to the region: ' .. cur())
if cur() == zh then
    -- 子が無くてもう一度左で親へ
    key('left')
    eq(cur(), 'sec_quest_bastok', 'left on a leaf area returns to the region')
end
-- もう一度右でエリアへ、決定で行へ
key('right')
zh = cur()
check(zh:find('/zone_', 1, true) or zh:find('^sec_quest_zone_'), 'right enters an area again: ' .. zh)
key('confirm')
local qr = cur()
check(qr:find('^row_'), 'confirm from an area enters a quest row: ' .. qr)
key('back')
eq(cur(), zh, 'cancel from a row returns to the area heading')
key('back')
eq(app.state.open.book, false, 'cancel in the tree (area) closes the book')

-- 前回の行：親の見出しを開いてその行を出す。カーソルは見出し（通常の開き直し）
S.book.tab = 'quest'
S.book.last_row = 'quest.sandoria.006'
S.book.last_heading = S.book.last_heading or {}
S.book.last_heading.quest = nil
S.book.collapsed = S.book.collapsed or {}
S.book.collapsed.quest = { sandoria = true, ['sandoria/zone_100'] = true, ['zone_100'] = true }
app.open_window('book'); frame(); frame(); frame()
eq(book.is_collapsed(S, 'quest', 'sandoria'), false, 'restored path expands the region')
eq(book.is_collapsed(S, 'quest', 'sandoria/zone_100'), false, 'restored path expands the area')
eq(S.book.last_row, 'quest.sandoria.006', 'last row is still selected')
local rc = cur()
check(rc:find('^sec_quest_'), 'normal reopen focuses the heading, not the row: ' .. rc)
app.close_window('book'); frame()

-- エミネンス：すべて、または分類見出し
open_tab('eminence')
local eh = cur()
if eh:find('^cat_') or eh == 'sec_eminence_all' or eh:find('^sec_') then
    check(texted('見出しを選び') or texted('picks a heading') or eh == 'sec_eminence_all' or eh:find('^cat_') or eh:find('^tab_'),
        'eminence starts in the tree or top: ' .. eh)
    if eh == 'sec_eminence_all' then
        key('down')
        eh = cur()
    end
    if eh:find('^cat_') then
        local ckey = eh:match('^cat_(.+)$')
        key('left')
        -- 左は閉じるか親へ。フォーカスは木に残る
        check(cur():find('^cat_') or cur() == 'sec_eminence_all', 'left stays in the tree: ' .. cur())
        key('right')
        key('confirm')
        local child = cur()
        -- 決定は表の行（DAT があれば）
        if child:find('^roesel_') then
            key('back')
            check(cur():find('^cat_') or cur() == 'sec_eminence_all', 'cancel returns to the tree')
            key('back')
            eq(app.state.open.book, false, 'cancel in the eminence tree closes the book')
        else
            key('back')
            if app.state.open.book then
                key('back')
            end
        end
    else
        key('back')
        eq(app.state.open.book, false, 'cancel at すべて closes the book')
    end
else
    check(eh:find('^tab_') or eh == '', 'eminence without DAT stays on the top row: ' .. eh)
end

print('test_book_nav ok')
