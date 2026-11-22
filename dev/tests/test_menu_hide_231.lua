-- 0.1.231：ゲームのメニューが開いているあいだは本を隠し、コントローラー操作はゲームに渡す。
-- メニューを閉じたら、同じタブ・見出し・一覧・詳細の位置で本と操作を戻す。
-- メニューが開いているあいだに本を閉じたら、出さない。トラッカーの操作中も入力はゲームへ。
require('fake_env')

local wins = { helpwind = { focused = false }, partywin = { focused = false }, logwindo = { focused = false } }
local order = { 'helpwind', 'partywin', 'logwindo' }
local flag = false
local on_top_calls = {}
_G.vana = {
    game = { target = function () return { menu_open = flag } end },
    gameui = {
        windows = function () local o = {} for i, n in ipairs(order) do o[i] = n end return o end,
        window = function (n) local w = wins[n]; if not w then return nil end
            return { name = n, focused = w.focused, closing = w.closing or false, hidden = false } end,
        catch = function () return 1 end,
        off = function () end,
        watch = function () return 1 end,
        unwatch = function () end,
        add = function () return true end,
        remove = function () end,
    },
    ui = { game_on_top = function (on) on_top_calls[#on_top_calls + 1] = on end },
}

-- 本の描画回数（###astertrail_book の Begin）
local book_begins = 0
local im = require('imgui')
local orig_begin = im.Begin
im.Begin = function (title, open, flags)
    if type(title) == 'string' and title:find('###astertrail_book', 1, true) then
        book_begins = book_begins + 1
    end
    return orig_begin(title, open, flags)
end

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local smod = require('src.core.settings')
FAKE.player = { name = 'Menus', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
S.input.gamepad = true
S.gameui.capture = true
S.gameui.menus_on_top = true
eq(app.VERSION, '1.1.308', 'version')

local LIST = '##astertrail_book_list'
local function open_menu_flag()
    flag = true
    frames(0.3)
end
local function open_menu_window(name)
    flag = false
    order[#order + 1] = name
    wins[name] = { focused = true }
    frames(0.3)
end
local function close_menu()
    flag = false
    if order[#order] ~= 'helpwind' and order[#order] ~= 'partywin' and order[#order] ~= 'logwindo' then
        wins[order[#order]] = nil
        order[#order] = nil
    end
    frames(0.3)
end

local function book_drawn_since(n0)
    return book_begins - n0
end

-- 1) 本を開いて操作し、ホームポイントのメニューを開くと本は隠れ、入力はゲームへ
app.open_window('book'); frame(); frame(); frame()
eq(app.state.open.book, true, 'book open')
check(app.book_visible(), 'book visible before menu')
check(app.operating(), 'operating the book')
eq(app.state.active, 'book', 'active is book')
app.select_in_book('quest.sandoria.006'); frame(); frame(); frame()
eq(S.book.tab, 'quest', 'quest tab')
eq(S.book.last_row, 'quest.sandoria.006', 'selected row')
local cur_before = tostring(focus.current('book') or '')
check(cur_before ~= '', 'cursor set: ' .. cur_before)
FAKE.scroll_y = FAKE.scroll_y or {}
FAKE.scroll_y[LIST] = 144
frame()
eq(S.book.scroll.quest, 144, 'list scroll saved')
S.windows = S.windows or {}
S.windows.book = S.windows.book or {}
S.windows.book.w, S.windows.book.h = 1111, 777
S.windows.book.x, S.windows.book.y = 40, 50
local w0, h0, x0, y0 = S.windows.book.w, S.windows.book.h, S.windows.book.x, S.windows.book.y
-- 仮の ImGui は既定の 400x300 を返すので、本の保存サイズを返す（実機では SetNextWindowSize のあとと同じ）
local orig_gpos, orig_gsz = im.GetWindowPos, im.GetWindowSize
im.GetWindowPos = function ()
    local ws = S.windows and S.windows.book
    if ws and ws.x then return ws.x, ws.y end
    return orig_gpos()
end
im.GetWindowSize = function ()
    local ws = S.windows and S.windows.book
    if ws and ws.w then return ws.w, ws.h end
    return orig_gsz()
end

local n0 = book_begins
open_menu_window('homepoin')
eq(app.state.game_menu_open, true, 'menu detected (focused window)')
eq(app.state.open.book, true, 'book still marked open (not closed)')
check(not app.book_visible(), 'book hidden while menu open')
eq(app.state.book_hidden_for_menu, true, 'hidden-for-menu flag')
check(not app.operating(), 'not operating while menu open')
check(app.state.active ~= 'book', 'book not active')
check(not app.want_pad(), 'pad goes to the game')
check(not app.want_keys(), 'keys go to the game')
check(not app.pad_block_all(), 'pad not blocked')
eq(app.state.menu_captured, false, 'game menus not caught')
check(book_drawn_since(n0) == 0, 'book not drawn while hidden: ' .. book_drawn_since(n0))
eq(S.book.tab, 'quest', 'tab kept while hidden')
eq(S.book.last_row, 'quest.sandoria.006', 'row kept while hidden')
eq(S.book.scroll.quest, 144, 'scroll kept while hidden')
eq(S.windows.book.w, w0, 'width unchanged while hidden')
eq(S.windows.book.h, h0, 'height unchanged while hidden')
eq(S.windows.book.x, x0, 'x unchanged while hidden')
eq(S.windows.book.y, y0, 'y unchanged while hidden')

-- 2) メニューを閉じたら本が出て、同じ位置・同じ操作に戻る
close_menu()
eq(app.state.game_menu_open, false, 'menu closed')
check(app.book_visible(), 'book visible again')
eq(app.state.open.book, true, 'book still open')
eq(app.state.book_hidden_for_menu, false, 'flag cleared')
eq(app.state.active, 'book', 'operating the book again')
check(app.operating(), 'operating resumed')
check(app.want_pad(), 'pad back to the book')
eq(S.book.tab, 'quest', 'tab restored')
eq(S.book.last_row, 'quest.sandoria.006', 'row restored')
eq(S.book.scroll.quest, 144, 'scroll restored')
eq(tostring(focus.current('book') or ''), cur_before, 'cursor restored')
eq(S.windows.book.w, w0, 'width unchanged after restore')
eq(S.windows.book.h, h0, 'height unchanged after restore')
eq(S.windows.book.x, x0, 'x unchanged after restore')
eq(S.windows.book.y, y0, 'y unchanged after restore')
eq(app.state.book_restore_scroll, false, 'scroll restore consumed')
eq(FAKE.scroll_y[LIST], 144, 'list scrolled back')
check(book_begins > n0, 'book drawn after menu closed')

-- 3) メインメニュー（印だけ。窓の場所が無い）でも同じ
open_menu_flag()
eq(app.state.game_menu_open, true, 'main menu flag detected')
check(not app.book_visible(), 'book hidden for main menu flag')
check(not app.operating(), 'input released for main menu')
close_menu()
check(app.book_visible(), 'book back after main menu')
eq(app.state.active, 'book', 'operate book after main menu')

-- 4) メニューが開いているあいだに本を閉じたら、メニューを閉じても出さない
open_menu_window('homepoin')
check(not app.book_visible(), 'hidden again')
app.close_window('book'); frame()
eq(app.state.open.book, false, 'book closed by user')
eq(app.state.book_hidden_for_menu, false, 'hide flag cleared on close')
close_menu()
eq(app.state.open.book, false, 'did not reopen after user closed it')
check(not app.book_visible(), 'still not visible')
check(app.state.active ~= 'book', 'did not resume book')

-- 5) ショートカット（開いている本を閉じる）でも同じ
app.open_window('book'); frame(); frame()
check(app.book_visible(), 'book open for shortcut test')
open_menu_flag()
check(app.state.open.book, true, 'still marked open')
check(not app.book_visible(), 'hidden for shortcut test')
app.shortcut_run('open_book'); frame()
eq(app.state.open.book, false, 'shortcut closed the hidden book')
close_menu()
eq(app.state.open.book, false, 'shortcut close: did not reopen')

-- 6) 設定を出している本も、隠したあと設定のまま戻る
app.open_window('settings'); frame(); frame()
eq(app.state.open.book, true, 'settings opens the book')
eq(app.state.open.settings, true, 'settings on')
eq(app.state.active, 'settings', 'operating settings')
open_menu_flag()
check(not app.book_visible(), 'book+settings hidden')
eq(app.state.open.settings, true, 'settings still marked on')
check(not app.operating(), 'settings input released')
close_menu()
check(app.book_visible(), 'book back with settings')
eq(app.state.open.settings, true, 'settings still on')
eq(app.state.active, 'settings', 'settings operation resumed')
app.close_window('book'); frame()

-- 7) トラッカーの操作中も、メニューが開いたら入力をゲームへ。窓は出したまま。閉じたら操作に戻る
S.tracker.visible = true; S.tracker.collapsed = false
local QA = 'quest.bastok.005'
app.request('pin', QA); frame(); frame()
check(app.tracker_on(), 'tracker on')
check(app.enter_tracker(), 'entered tracker operate')
eq(app.state.active, 'tracker', 'active tracker')
check(app.operating(), 'operating tracker')
frame(); frame()
open_menu_flag()
eq(S.tracker.visible, true, 'tracker stays visible')
check(app.tracker_on(), 'tracker still on')
check(not app.operating(), 'tracker input released')
check(app.state.active ~= 'tracker', 'tracker not active during menu')
check(not app.want_pad(), 'tracker pad goes to the game')
check(not app.pad_block_all(), 'tracker pad not blocked')
local tr_cur = tostring(focus.current('tracker') or '')
check(tr_cur:find(QA, 1, true) ~= nil, 'tracker still on the same pin while menu open: ' .. tr_cur)
close_menu()
eq(app.state.active, 'tracker', 'tracker operation resumed')
check(app.operating(), 'operating tracker again')
eq(tostring(focus.current('tracker') or ''), tr_cur, 'tracker cursor not reset on resume')
eq(S.tracker.visible, true, 'tracker still visible after menu')

-- 8) 印もフォーカスも無いときは隠さない
app.open_window('book'); frame(); frame()
flag = false
-- フォーカス付きの窓を残さない
while order[#order] and order[#order] ~= 'logwindo' do wins[order[#order]] = nil; order[#order] = nil end
frames(0.3)
eq(app.state.game_menu_open, false, 'no menu when nothing focused and flag off')
check(app.book_visible(), 'book stays visible when no menu is detected')
check(app.operating() or app.state.active == 'book' or app.state.active == 'settings',
    'still operating when no menu: ' .. tostring(app.state.active))

-- 9) メニュー検出はこれまでどおり（閉じかけの窓は数えない）
order[#order + 1] = 'query'; wins.query = { focused = true, closing = true }
frames(0.3)
eq(app.state.game_menu_open, false, 'closing window does not count as a menu')
check(app.book_visible(), 'book stays up for a closing window')
wins.query = nil; order[#order] = nil
