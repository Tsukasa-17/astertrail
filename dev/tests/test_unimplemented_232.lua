-- 0.1.232：エミネンスと本の「☑未実装」。手で付ける印、隠す、件数、ピン、詳細のボタン
require('fake_env')
local settings = require('src.core.settings')
local book = require('src.ui.book')
local eminence = require('src.ui.eminence')

-- 保存の初期値と古い保存
do
    local d = settings.defaults()
    eq(d.book.filters.show.unimplemented, true, 'book: 未実装 default on')
    eq(d.eminence.book_show.unimplemented, true, 'eminence: 未実装 default on')
    local empty = settings.merge({})
    eq(empty.book.filters.show.unimplemented, true, 'merge empty book: 未実装 on')
    eq(empty.eminence.book_show.unimplemented, true, 'merge empty eminence: 未実装 on')
    local old = settings.merge({ book = { filters = { show = { accepted = true, not_accepted = true, completed = false } } } })
    eq(old.book.filters.show.unimplemented, true, 'old book show without key: 未実装 on')
    eq(old.book.filters.show.completed, false, 'old completed kept')
    local off = settings.merge({ book = { filters = { show = { accepted = true, not_accepted = true, completed = true, unimplemented = false } } } })
    eq(off.book.filters.show.unimplemented, false, 'saved 未実装 off is kept')
    local eold = settings.merge({ eminence = { book_show = { accepted = true, not_accepted = true, completed = false } } })
    eq(eold.eminence.book_show.unimplemented, true, 'old eminence show without key: 未実装 on')
    local eoff = settings.merge({ eminence = { book_show = { accepted = true, not_accepted = true, completed = false, unimplemented = false } } })
    eq(eoff.eminence.book_show.unimplemented, false, 'saved eminence 未実装 off is kept')
    local marks = settings.merge({ book = { unimplemented = { ['quest.sandoria.006'] = true, ['nope'] = true, [12] = true, ['mission.sandoria.001'] = true } } })
    eq(marks.book.unimplemented['quest.sandoria.006'], true, 'quest mark kept')
    eq(marks.book.unimplemented['mission.sandoria.001'], true, 'mission mark kept')
    eq(marks.book.unimplemented['nope'], nil, 'junk key dropped')
    eq(marks.book.unimplemented['12'], nil, 'numeric key dropped')
end

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(app.VERSION, '1.1.245', 'version')
eq(S.book.filters.show.unimplemented, true, 'runtime default 未実装 on')
eq(S.eminence.book_show.unimplemented, true, 'runtime eminence 未実装 on')

local function items()
    local m = {}
    for _, it in ipairs(focus.windows.book.list or {}) do m[it.id] = it end
    return m
end
local function rows()
    local out = {}
    for _, it in ipairs(focus.windows.book.list or {}) do
        local q = it.id:match('^row_(.+)$')
        if q then out[#out + 1] = q end
    end
    return out
end
local function open_tab(tab)
    S.book.tab = tab
    S.book.last_row = nil
    S.book.last_heading = S.book.last_heading or {}
    S.book.last_heading[tab] = nil
    app.close_window('book'); frame()
    app.open_window('book'); frame(); frame(); frame()
end

-- エミネンス：☑未実装は表示の行。オフだと未実装（3055）を隠し、件数からも外す。受けているものは残す
do
    S.book.tab = 'eminence'
    S.book.last_heading = S.book.last_heading or {}
    S.book.last_heading.eminence = 'all'
    S.eminence.book_text = ''
    S.eminence.book_favs_only = false
    S.eminence.book_show = { accepted = true, not_accepted = true, completed = true, unimplemented = true }
    eminence.reset_search()
    app.close_window('book'); frame()
    app.open_window('book'); frame(); frame(); frame()
    local m = items()
    check(m.roe_show_unimplemented, 'eminence has ☑未実装')
    eq(m.roe_show_unimplemented.row, m.roe_show_completed and m.roe_show_completed.row or 'f2', 'same row as 達成')
    eq(m.roe_show_unimplemented.row, m.roe_favs_only and m.roe_favs_only.row or 'f2', 'same row as お気に入りのみ')
    check(texted('未実装') or texted('Unimplemented'), '未実装 label in eminence')

    -- ヘッドレスで book_visible / cat_progress
    local ui = {
        settings = S,
        state = app.state,
        roe_failed = app.roe_failed,
        progress = app._progress and app._progress() or nil,
        t = function (k) return k end,
    }
    check(app.roe_failed(3055) and app.roe_failed(3055).why == 'not_impl', '3055 is unimplemented')
    check(eminence.book_visible(ui, 3055, nil), '3055 visible while ☑未実装 on')
    local d0, t0 = eminence.cat_progress(ui, { 12, 3055 }, nil)
    check(t0 == 2, 'total includes 3055 when shown: ' .. tostring(t0))
    S.eminence.book_show.unimplemented = false
    check(eminence.hidden_unimplemented(ui, 3055), '3055 hidden when ☑ off')
    check(not eminence.book_visible(ui, 3055, nil), '3055 not listed when ☑ off')
    check(not eminence.book_visible(ui, 3055, nil, { ignore_state = true }), '3055 also out of totals')
    local d1, t1 = eminence.cat_progress(ui, { 12, 3055 }, nil)
    eq(t1, 1, 'total leaves 3055 out when hidden')
    -- 受けている未実装は隠さない
    app.state.roe = app.state.roe or {}
    app.state.roe.active = { { id = 3055, progress = 0 } }
    check(not eminence.hidden_unimplemented(ui, 3055), 'accepted 3055 is not hidden')
    check(eminence.book_visible(ui, 3055, nil), 'accepted 3055 stays listed')
    local d2, t2 = eminence.cat_progress(ui, { 12, 3055 }, nil)
    eq(t2, 2, 'accepted 3055 stays in the total')
    app.state.roe.active = nil
    S.eminence.book_show.unimplemented = true
end

-- 本：詳細のボタンで印を付け外し、薄く出す、☑で隠す、件数から外す、受注中は残す、ピンは付けられないが既にあるピンは残る
open_tab('quest')
do
    local m = items()
    check(m.show_unimplemented, 'quest 表示 has ☑未実装')
    eq(m.show_unimplemented.row, m.show_completed and m.show_completed.row or 'cols', 'same row as 完了')
    check(texted('未実装') or texted('Unimplemented'), '未実装 label in quests')
end

local qid = 'quest.sandoria.006'
local PR = app._progress()
check(PR:state(qid) ~= nil or true, 'progress ready')
app.select_in_book(qid); frame(); frame(); frame()
do
    local m = items()
    check(m.unimplemented, 'detail 未実装 button is in the focus list')
    eq(m.unimplemented.section, 'state', 'button section is state')
    eq(m.unimplemented.row, m.pin and m.pin.row or 'state', 'same row as pin (pad can reach it)')
    check(not book.is_marked_unimplemented(S, qid), 'not marked yet')
    -- コントローラー相当：フォーカスを載せて決定
    focus.set('book', 'unimplemented', true)
    app.input('confirm', true, 'key'); app.input('confirm', false, 'key'); frame(); frame()
    check(book.is_marked_unimplemented(S, qid), 'marked after confirm on the button')
    eq(S.book.unimplemented[qid], true, 'saved on the character settings')
    -- 一覧のセルは薄い
    local q = app._data():quest(qid)
    local cells = book.row_cells({ settings = S, progress = PR, t = function (k) return k end, data = app._data() }, q)
    check(cells.unimplemented, 'row_cells marks it')
    eq(cells.state_color, 'muted', 'state is greyed')
    local _, ncol, nmuted = book.col_cell({ t = function (k) return k end }, cells, 'name', false)
    eq(ncol, 'muted', 'name color greyed')
    check(nmuted, 'name muted')
end

-- ピン：新しく付けられない。既にあるものは残る
do
    local r = app.request('pin', qid)
    eq(r.ok, false, 'cannot pin a marked quest')
    eq(r.code, 'unimplemented', 'pin refused as unimplemented')
    check(not PR:is_pinned(qid), 'not pinned')
    -- 先にピンしてから印を付ける
    book.set_unimplemented(S, qid, false)
    local rp = app.request('pin', qid)
    check(rp and rp.ok, 'pin ok when not marked')
    check(PR:is_pinned(qid), 'is pinned')
    book.set_unimplemented(S, qid, true)
    check(PR:is_pinned(qid), 'pin kept after marking')
    -- 外すのはできる
    local ru = app.request('unpin', qid)
    check(ru and ru.ok, 'unpin still works')
    check(not PR:is_pinned(qid), 'unpinned')
    book.set_unimplemented(S, qid, true)
end

-- ☑未実装をオフ：一覧から消え、見出しの件数からも外れる。受注中なら残る
do
    open_tab('quest')
    book.set_unimplemented(S, qid, true)
    S.book.filters.show = { accepted = true, not_accepted = true, completed = true, unimplemented = true }
    book.clear_view_cache(); frame(); frame()
    local function bui()
        return { settings = S, progress = PR, data = app._data(), t = function (k) return k end }
    end
    local all = book.filtered(bui())
    local function has(list, id)
        for _, q in ipairs(list) do if q.id == id then return true end end
        return false
    end
    check(has(all, qid), 'listed while ☑未実装 on')
    local counts_on = book.progress_by_group(bui())
    S.book.filters.show.unimplemented = false
    book.clear_view_cache()
    local hidden = book.filtered(bui())
    check(not has(hidden, qid), 'hidden from the list when ☑ off')
    check(book.hidden_unimplemented(bui(), app._data():quest(qid)), 'hidden_unimplemented true')
    local counts_off = book.progress_by_group(bui())
    -- 同じ見出しの総数が 1 減る（親と子の両方下がることがあるので、下がった見出しを使う）
    local hid, on_c, off_c
    for k, c in pairs(counts_on) do
        local o = counts_off[k]
        if c and o and o.total == c.total - 1 then hid, on_c, off_c = k, c, o; break end
    end
    check(hid ~= nil, 'some heading total dropped by 1')
    eq(off_c.total, on_c.total - 1, 'heading total leaves it out')
    -- 受注中なら残す
    local st = app.request('set_state', qid, 'accepted', true)
    check(st and st.ok, 'set accepted')
    book.clear_view_cache()
    local kept = book.filtered(bui())
    check(has(kept, qid), 'accepted marked quest stays listed')
    local counts_acc = book.progress_by_group(bui())
    local acc_c = counts_acc[hid]
    check(acc_c, 'accepted heading still present')
    eq(acc_c.total, on_c.total, 'accepted stays in the heading total')
    app.request('set_state', qid, 'not_accepted', true)
    S.book.filters.show.unimplemented = true
    book.clear_view_cache()
end

-- もう一度ボタンを押すと印が外れる
app.select_in_book(qid); frame(); frame(); frame()
check(book.is_marked_unimplemented(S, qid), 'still marked')
focus.set('book', 'unimplemented', true)
app.input('confirm', true, 'key'); app.input('confirm', false, 'key'); frame(); frame()
check(not book.is_marked_unimplemented(S, qid), 'cleared after pressing again')
eq(S.book.unimplemented[qid], nil, 'removed from settings')
