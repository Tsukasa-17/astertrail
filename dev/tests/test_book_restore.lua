-- 0.1.203: 本を開くと前回のタブ・行・一覧の位置に戻る。指定して開いたときはその項目へ
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local smod = require('src.core.settings')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(S.remember_position, false, 'settings-tab remember still off by default')
eq((S.book.scroll.mission or 0), 0, 'scroll default 0')

local LIST = '##astertrail_book_list'
local function open_book()
    app.open_window('book'); frame(); frame(); frame()
end

-- クエストのタブで行を選び、一覧を動かし、閉じてもう一度開くと戻る
open_book()
S.remember_position = false
app.select_in_book('quest.sandoria.006'); frame(); frame(); frame()
eq(S.book.tab, 'quest', 'selected quest tab')
eq(S.book.last_row, 'quest.sandoria.006', 'selected row')
FAKE.scroll_y = FAKE.scroll_y or {}
FAKE.scroll_y[LIST] = 144
frame()
eq(S.book.scroll.quest, 144, 'scroll saved while open')
app.close_window('book'); frame()
eq(S.book.tab, 'quest', 'tab kept while closed')
eq(S.book.last_row, 'quest.sandoria.006', 'row kept while closed')
FAKE.scroll_y[LIST] = 0
open_book()
eq(S.book.tab, 'quest', 'reopen: last tab')
eq(S.book.last_row, 'quest.sandoria.006', 'reopen: last row')
local re = tostring(focus.current('book') or '')
check(re:find('^sec_quest_'), 'reopen: cursor on the heading, not the row: ' .. re)
eq(FAKE.scroll_y[LIST], 144, 'reopen: last scroll')

-- 覚えていた行が無い（フィルタで隠れた）ときは、そのタブのいちばん上の見出しへ（行は選ばない）
S.book.last_row = 'quest.does.not.exist'
S.book.scroll.quest = 144
app.close_window('book'); frame()
open_book()
eq(S.book.tab, 'quest', 'missing row: same tab')
eq(S.book.last_row, nil, 'missing row: last_row cleared')
local miss = tostring(focus.current('book') or '')
check(miss == 'sec_quest_all' or miss:find('^sec_quest_') ~= nil, 'missing row: top heading: ' .. miss)
eq(S.book.scroll.quest, 0, 'missing row: scroll back to top')
eq(FAKE.scroll_y[LIST], 0, 'missing row: list at top')

-- トラッカーなどから指定して開いたときは、覚えていた場所ではなくその項目へ
app.close_window('book'); frame()
S.book.tab = 'eminence'
S.book.last_row = 'mission.sandoria.001'
S.book.scroll.quest = 80
S.book.scroll.eminence = 50
app.select_in_book('quest.sandoria.006'); frame(); frame(); frame()
eq(S.book.tab, 'quest', 'targeted open: quest tab')
eq(S.book.last_row, 'quest.sandoria.006', 'targeted open: that row')
eq(focus.current('book'), 'row_quest.sandoria.006', 'targeted open: cursor')
eq(app.state.open.book, true, 'targeted open: book is open')

-- 本が開いているときにゲームのミッションメニューが来ても、タブを奪わない
S.book.tab = 'quest'
S.book.last_row = 'quest.sandoria.006'
S.book.scroll.quest = 72
FAKE.scroll_y[LIST] = 72
frame()
app.state.pending_book = 'mission'
frame(); frame(); frame()
eq(S.book.tab, 'quest', 'open book: mission menu does not steal the tab')
eq(S.book.last_row, 'quest.sandoria.006', 'open book: selection kept')
eq(S.book.scroll.quest, 72, 'open book: scroll kept')

-- 本が閉じているときにミッションメニューから開いても、前回のタブ・行・縦位置に戻す（0.1.206〜）
app.close_window('book'); frame()
S.book.tab = 'quest'
S.book.last_row = 'quest.sandoria.006'
S.book.scroll.quest = 72
FAKE.scroll_y[LIST] = 0
app.state.pending_book = 'mission'
frame(); frame(); frame()
eq(app.state.open.book, true, 'closed book: mission menu opens it')
eq(S.book.tab, 'quest', 'closed book: mission menu restores last tab')
eq(S.book.last_row, 'quest.sandoria.006', 'closed book: last row kept')
check(tostring(focus.current('book') or ''):find('^sec_quest_'), 'closed book: cursor on the heading: ' .. tostring(focus.current('book')))
eq(FAKE.scroll_y[LIST], 72, 'closed book: last scroll restored')

-- 再読み込み・再ログイン：設定に残る
local m = smod.merge({
    remember_position = false,
    book = {
        tab = 'eminence',
        last_row = 'quest.sandoria.006',
        scroll = { mission = 10, quest = 20, eminence = 30 },
    },
    eminence = { last_id = 215 },
})
eq(m.book.tab, 'eminence', 'reload: tab')
eq(m.book.last_row, 'quest.sandoria.006', 'reload: last_row')
eq(m.book.scroll.mission, 10, 'reload: mission scroll')
eq(m.book.scroll.quest, 20, 'reload: quest scroll')
eq(m.book.scroll.eminence, 30, 'reload: eminence scroll')
eq(m.eminence.last_id, 215, 'reload: eminence last_id')
-- 壊れた値は落とす
local m2 = smod.merge({ book = { scroll = { quest = -8, eminence = 'x' } }, eminence = { last_id = 'nope' } })
eq(m2.book.scroll.quest, 0, 'bad scroll clamped')
eq(m2.book.scroll.eminence, 0, 'non-number scroll is 0')
eq(m2.eminence.last_id, nil, 'bad last_id dropped')

print('test_book_restore ok')
