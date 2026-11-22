-- 0.1.233：見出しの帯の緑色の案内、たたんだ見出しを自動で開かない、
-- メニューが開いているときに本／設定を出したときは隠さない、
-- 受ける・解除などのあとカーソルを一覧の行に残す
require('fake_env')

-- ゲームのメニュー検出（test_menu_hide_231 と同じ窓口）
local wins = { helpwind = { focused = false }, partywin = { focused = false }, logwindo = { focused = false } }
local order = { 'helpwind', 'partywin', 'logwindo' }
local flag = false
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
    ui = { game_on_top = function () end },
}

---------------------------------------------------------------------------
-- 1) 見出しの帯：長い文は「…」で切る（折り返さない）
---------------------------------------------------------------------------
do
    local window = require('src.ui.window')
    local imgui = require('imgui')
    local short, cut = window.clip_line(imgui, '短い案内', 400)
    eq(short, '短い案内', 'short flash fits')
    eq(cut, false, 'short not clipped')
    local long = 'A.M.A.N. トローブってなぁに？ を解除すると送りました。'
    local shown, clipped = window.clip_line(imgui, long, 80)
    check(clipped, 'long flash is clipped')
    check(shown:find('…', 1, true), 'long flash uses ellipsis')
    check(not shown:find('\n', 1, true), 'clipped flash is one line')
    local w = imgui.CalcTextSize(shown)
    local tw = type(w) == 'table' and (w.x or w[1]) or w
    check(tw <= 80, 'clipped width fits: ' .. tostring(tw))
end

---------------------------------------------------------------------------
-- 2) フォーカス：受ける→解除でボタン id が変わっても同じ行。行が消えたら一番近い行
---------------------------------------------------------------------------
do
    local focus = require('src.ui.focus')
    local function build(win, items)
        focus.begin(win)
        for _, it in ipairs(items) do
            focus.item(win, it[1], it[2], it[3])
        end
        focus.finish(win, 'sec_eminence_all')
    end
    local heading = { 'sec_eminence_all', 'tree', 'all' }
    local function rec(id, op)
        local row = 'r' .. id
        return {
            { 'roe_' .. op .. '_' .. id, 'list', row },
            { 'roe_fav_' .. id, 'list', row },
            { 'roesel_' .. id, 'list', row },
        }
    end
    -- 受けるを押したあと、ボタンが解除に変わる
    local items = { heading }
    for _, it in ipairs(rec(12, 'start')) do items[#items + 1] = it end
    for _, it in ipairs(rec(13, 'remove')) do items[#items + 1] = it end
    build('book', items)
    focus.set('book', 'roe_start_12')
    local after = { heading }
    for _, it in ipairs(rec(12, 'remove')) do after[#after + 1] = it end
    for _, it in ipairs(rec(13, 'remove')) do after[#after + 1] = it end
    build('book', after)
    eq(focus.current('book'), 'roe_remove_12', 'accept: stay on the same row action button')

    -- 解除してフィルタで行が消えたら、次の行へ（見出しではない）
    focus.set('book', 'roe_remove_12')
    local gone = { heading }
    for _, it in ipairs(rec(13, 'remove')) do gone[#gone + 1] = it end
    build('book', gone)
    local cur = tostring(focus.current('book') or '')
    check(cur:find('13', 1, true), 'filter-out: nearest row 13: ' .. cur)
    check(not cur:find('^sec_', 1, false) and cur ~= 'sec_eminence_all', 'filter-out: not the heading: ' .. cur)

    -- クエストのピン：行が消えたら近い行へ
    local qh = { 'sec_quest_sandoria', 'tree', 'sandoria' }
    build('book', {
        qh,
        { 'bpin_quest.sandoria.006', 'list', 'quest.sandoria.006' },
        { 'row_quest.sandoria.006', 'list', 'quest.sandoria.006' },
        { 'bpin_quest.sandoria.007', 'list', 'quest.sandoria.007' },
        { 'row_quest.sandoria.007', 'list', 'quest.sandoria.007' },
    })
    focus.set('book', 'bpin_quest.sandoria.006')
    build('book', {
        qh,
        { 'bpin_quest.sandoria.007', 'list', 'quest.sandoria.007' },
        { 'row_quest.sandoria.007', 'list', 'quest.sandoria.007' },
    })
    local qc = tostring(focus.current('book') or '')
    check(qc:find('quest.sandoria.007', 1, true), 'quest filter-out: nearest row: ' .. qc)
    check(qc ~= 'sec_quest_sandoria', 'quest filter-out: not the heading')

    focus.reset('book')
end

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local book = require('src.ui.book')
local window = require('src.ui.window')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
S.input.gamepad = true
S.gameui.capture = true
eq(app.VERSION, '1.1.308', 'version')
eq(app._data().version, '2026.11.20-125', 'data version unchanged')

---------------------------------------------------------------------------
-- 3) 緑色の案内は見出しの帯へ。中身の TextColored には出ない
---------------------------------------------------------------------------
do
    local imgui = require('imgui')
    local colored = {}
    local orig = imgui.TextColored
    imgui.TextColored = function (col, text)
        colored[#colored + 1] = tostring(text or '')
        if orig then return orig(col, text) end
    end
    local msg = 'A.M.A.N. トローブってなぁに？ を解除すると送りました。'
    app.flash(msg)
    app.open_window('book'); frame(); frame()
    local in_colored = false
    for _, t in ipairs(colored) do
        if t:find('トローブってなぁに', 1, true) or t:find('解除すると送りました', 1, true) then
            in_colored = true
        end
    end
    check(not in_colored, 'flash is not a content TextColored line')
    check(texted('解除すると送りました') or texted('…'), 'flash is drawn on the title bar (AddText)')
    -- 設定を出していても、同じ本の見出しに出る
    colored = {}
    app.open_window('settings'); frame(); frame()
    check(app.state.open.settings, 'settings open')
    check(texted('解除すると送りました') or texted('…'), 'settings: flash still on the book title bar')
    local in_colored2 = false
    for _, t in ipairs(colored) do
        if t:find('トローブってなぁに', 1, true) or t:find('解除すると送りました', 1, true) then
            in_colored2 = true
        end
    end
    check(not in_colored2, 'settings: flash is not a content line')
    imgui.TextColored = orig
    app.state.flash = nil
    app.close_window('book'); frame()
end

---------------------------------------------------------------------------
-- 4) たたんだ見出しは自動で開かない（開き直し・復元・指定の行）
---------------------------------------------------------------------------
do
    eq(book.nav_expand_path({}, 'row_quest.sandoria.006'), false, 'nav_expand_path is a no-op')
    S.book.tab = 'quest'
    S.book.last_row = 'quest.sandoria.006'
    S.book.last_heading = S.book.last_heading or {}
    S.book.last_heading.quest = 'sandoria'
    S.book.collapsed = S.book.collapsed or {}
    S.book.collapsed.quest = { sandoria = true, ['sandoria/zone_230'] = true, ['sandoria/zone_100'] = true }
    book.set_collapsed(S, 'quest', 'sandoria', true)
    app.open_window('book'); frame(); frame(); frame()
    check(book.is_collapsed(S, 'quest', 'sandoria'), 'reopen keeps sandoria collapsed')
    eq(S.book.last_row, 'quest.sandoria.006', 'reopen keeps the selected row')
    -- 受ける／解除のあとの一覧描き直し（book_restore_scroll）でも開かない
    app.state.book_restore_scroll = true
    frame(); frame()
    check(book.is_collapsed(S, 'quest', 'sandoria'), 'restore_scroll does not expand')
    eq(S.book.last_row, 'quest.sandoria.006', 'restore_scroll keeps the selected row')
    -- トラッカーなどから指定して開いても、たたんだ見出しは開かない
    app.close_window('book'); frame()
    book.set_collapsed(S, 'quest', 'sandoria', true)
    app.state.book_expand_path = true
    app.open_window('book')
    app.state.book_expand_path = true
    frame(); frame()
    check(book.is_collapsed(S, 'quest', 'sandoria'), 'expand_path does not force the heading open')
    -- 設定に残る
    local merged = require('src.core.settings').merge({ book = { collapsed = { quest = { sandoria = true } } } })
    eq(merged.book.collapsed.quest.sandoria, true, 'collapsed state persists in settings')
    app.close_window('book'); frame()
end

---------------------------------------------------------------------------
-- 5) メニューがすでに開いているときに本／設定を出すと、隠さず操作できる
---------------------------------------------------------------------------
do
    local function open_menu_flag()
        flag = true
        frames(0.3)
    end
    local function close_menu()
        flag = false
        frames(0.3)
    end
    -- 先に本を出してからメニュー → これまでどおり隠す
    app.open_window('book'); frame(); frame()
    check(app.book_visible(), 'book visible before menu')
    eq(app.state.active, 'book', 'operating book before menu')
    open_menu_flag()
    eq(app.state.game_menu_open, true, 'menu detected')
    check(not app.book_visible(), 'already-open book is hidden')
    check(not app.operating(), 'input released for already-open book')
    close_menu()
    check(app.book_visible(), 'book restored after menu')
    eq(app.state.active, 'book', 'operation restored')
    app.close_window('book'); frame()

    -- メニューが先に開いているときに本を出す（メインメニューの項目）
    open_menu_flag()
    eq(app.state.game_menu_open, true, 'menu already open')
    app.state.pending_book = 'mission'
    frame(); frame(); frame()
    eq(app.state.open.book, true, 'menu entry opens the book')
    check(app.book_visible(), 'book opened from menu is visible')
    eq(app.state.book_keep_over_menu, true, 'keep-over-menu flag')
    eq(app.state.book_hidden_for_menu, false, 'not hidden-for-menu')
    check(app.operating(), 'book opened from menu has input')
    check(app.state.active == 'book' or app.state.active == 'settings', 'active is book/settings: ' .. tostring(app.state.active))
    check(app.want_pad(), 'pad goes to the book over the menu')
    check(app.want_keys(), 'keys go to the book over the menu')
    close_menu()
    check(app.book_visible(), 'book stays visible after menu closes')
    app.close_window('book'); frame()

    -- 設定の項目から
    open_menu_flag()
    app.state.pending_book = 'settings'
    frame(); frame(); frame()
    eq(app.state.open.book, true, 'settings entry opens the book')
    eq(app.state.open.settings, true, 'settings shown')
    check(app.book_visible(), 'settings opened from menu is visible')
    eq(app.state.active, 'settings', 'operating settings over the menu')
    check(app.want_pad(), 'pad goes to settings over the menu')
    close_menu()
    check(app.book_visible(), 'settings stay visible after menu closes')
    eq(app.state.open.settings, true, 'settings still on')
    app.close_window('book'); frame()

    -- 隠れた本を、メニューの項目から出し直す
    app.open_window('book'); frame(); frame()
    open_menu_flag()
    check(not app.book_visible(), 'hidden again')
    app.open_window('book'); frame(); frame()
    check(app.book_visible(), 're-open from menu unhides the book')
    check(app.operating(), 're-open from menu gives input')
    close_menu()
    app.close_window('book'); frame()
end

---------------------------------------------------------------------------
-- 6) クエスト：一覧にカーソルがあるとき、行がフィルタで消えたら近い行へ（見出しではない）
---------------------------------------------------------------------------
do
    app.open_window('book'); frame(); frame()
    S.book.tab = 'quest'
    S.book.filters = S.book.filters or {}
    S.book.filters.show = S.book.filters.show or {}
    S.book.filters.show.unimplemented = true
    local D = app._data()
    local a = 'quest.sandoria.006'
    check(D:quest(a) ~= nil, 'sample quest exists')
    app.select_in_book(a, true); frame(); frame()
    S.book.last_row = a
    focus.set('book', 'row_' .. a, true)
    frame()
    book.set_unimplemented(S, a, true)
    S.book.filters.show.unimplemented = false
    frame(); frame()
    check(S.book.last_row ~= a, 'hidden row is no longer last_row: ' .. tostring(S.book.last_row))
    check(S.book.last_row ~= nil, 'nearest row is selected for detail')
    local cur = tostring(focus.current('book') or '')
    check(not cur:find('^sec_', 1, false), 'hidden by filter: cursor stays in the list, not a heading: ' .. cur)
    S.book.filters.show.unimplemented = true
    book.set_unimplemented(S, a, false)
    app.close_window('book'); frame()
end

print('test_ui_233 ok')
