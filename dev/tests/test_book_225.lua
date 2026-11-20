-- 0.1.225：ミッション・クエストの「表示：」チェック（地域・状態の選択はなくした、t497/t498）、
-- パッドの案内の一行はなし（t499）、パッドで行を移ると詳細もついてくる（t500）、
-- 決定は 見出し → 一覧 → 詳細、キャンセルは 詳細 → 一覧 → 見出し → 閉じる（t502）
require('fake_env')
local settings = require('src.core.settings')

-- 保存の移し替え
do
    local d = settings.defaults().book.filters
    check(d.show.accepted and d.show.not_accepted and d.show.completed, 'default shows everything')
    local m = settings.merge({ book = { filters = { area = 'bastok', state = 'accepted', text = 'x' } } }).book.filters
    eq(m.show.accepted, true, 'old 受注中 → 受注中 checked')
    eq(m.show.not_accepted, false, 'old 受注中 → 未受注 unchecked')
    eq(m.show.completed, false, 'old 受注中 → 完了 unchecked')
    eq(m.area, 'all', 'saved area ignored')
    eq(m.state, 'all', 'state reset')
    eq(m.text, 'x', 'search kept')
    local c = settings.merge({ book = { filters = { state = 'completed' } } }).book.filters
    check(c.show.completed and not c.show.accepted and not c.show.not_accepted, 'old 完了 → only 完了')
    local a = settings.merge({ book = { filters = { state = 'all', area = 'jeuno' } } }).book.filters
    check(a.show.completed and a.show.accepted and a.show.not_accepted, 'old すべて → all checked')
    local u = settings.merge({ book = { filters = { state = 'unknown' } } }).book.filters
    check(u.show.completed and u.show.accepted and u.show.not_accepted, 'old unknown → all checked')
    local k = settings.merge({ book = { filters = { state = 'accepted', show = { accepted = true, not_accepted = true, completed = false } } } }).book.filters
    check(k.show.accepted and k.show.not_accepted and not k.show.completed, 'new show kept (old state ignored)')
    local bad = settings.merge({ book = { filters = { show = 'x' } } }).book.filters
    check(bad.show.accepted and bad.show.not_accepted and bad.show.completed, 'broken show → all')
end

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local book = require('src.ui.book')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()

local function cur() return tostring(focus.current('book') or '') end
local function key(action) app.input(action, true, 'key'); app.input(action, false, 'key'); frame(); frame() end
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

-- 「表示：」のチェック（地域・状態の選択は無い）
for _, tab in ipairs({ 'mission', 'quest' }) do
    open_tab(tab)
    local m = items()
    check(m.show_accepted and m.show_not_accepted and m.show_completed, tab .. ': show checks')
    check(not m.f_area and not m.f_state, tab .. ': no area/state filter')
    eq(m.show_accepted.row, m.col_name and m.col_name.row or 'cols', tab .. ': same row as columns')
    check(texted('表示：') or texted('Show:'), tab .. ': 表示 label')
    -- 案内の一行は出さない
    check(not texted('パッドで操作中') and not texted('with the pad'), tab .. ': no pad help line')
end

-- チェックで絞る（決定で付け外し）。公開版は手で受注にできないので、この塊だけ飛ばす
if not require('src.build_flags').public then
    open_tab('quest')
    key('confirm')   -- すべて → 表
    local all_n = #rows()
    check(all_n > 0, 'quest rows: ' .. all_n)
    -- 1件を受注中に
    local qid = rows()[1]
    local rq = app.request('set_state', qid, 'accepted', true); frame()
    check(rq and rq.ok, 'set accepted: ' .. tostring(rq and rq.code))
    focus.set('book', 'show_not_accepted'); frame()
    key('confirm')
    eq(S.book.filters.show.not_accepted, false, 'confirm unchecks 未受注')
    focus.set('book', 'show_completed'); frame()
    key('confirm')
    eq(S.book.filters.show.completed, false, 'confirm unchecks 完了')
    frame(); frame()
    local only = rows()
    check(#only >= 1 and #only < all_n, 'only accepted rows: ' .. #only .. '/' .. all_n)
    local PR = app._progress and app._progress() or nil
    if PR then for _, id in ipairs(only) do eq(PR:state(id), 'accepted', 'row is accepted: ' .. id) end end
    S.book.filters.show = { accepted = true, not_accepted = true, completed = true }
    frame(); frame()
    eq(#rows(), all_n, 'all rows again')
    -- 古い保存の地域が残っていても使わない
    S.book.filters.area = 'bastok'; frame(); frame()
    eq(#rows(), all_n, 'stale area ignored')
    S.book.filters.area = 'all'
end

-- t500：パッドで行を移ると、詳細もその行に
do
    open_tab('mission')
    key('down')
    key('confirm')
    local r1 = cur()
    check(r1:find('^row_'), 'in the mission table: ' .. r1)
    key('down')
    local r2 = cur()
    check(r2:find('^row_') and r2 ~= r1, 'down to the next row: ' .. r2)
    eq('row_' .. tostring(S.book.last_row), r2, 'detail follows the focused row')
    key('up')
    eq('row_' .. tostring(S.book.last_row), r1, 'and back up')
end

-- t502：決定 見出し → 一覧 → 詳細。1.1.285〜：詳細のキャンセルは本を閉じる（枠の点滅だけにしない）
for _, tab in ipairs({ 'mission', 'quest' }) do
    open_tab(tab)
    key('down')
    local head = cur()
    check(head:find('^sec_'), tab .. ': on a heading: ' .. head)
    key('confirm')
    local row = cur()
    check(row:find('^row_'), tab .. ': confirm → list: ' .. row)
    key('confirm')
    eq(cur(), book.DETAIL_ANCHOR, tab .. ': confirm → detail')
    eq('row_' .. tostring(S.book.last_row), row, tab .. ': the row is selected')
    eq(book.area_of(items()[cur()].section), 'detail', tab .. ': in the detail area')
    -- 上下：ボタンがあれば移る、端では詳細を送る（一覧へは出ない）
    key('down')
    local d1 = cur()
    eq(book.area_of(items()[d1] and items()[d1].section), 'detail', tab .. ': down stays in the detail: ' .. d1)
    for _ = 1, 40 do key('down') end
    eq(book.area_of(items()[cur()] and items()[cur()].section), 'detail', tab .. ': many downs stay in the detail')
    key('up')
    eq(book.area_of(items()[cur()] and items()[cur()].section), 'detail', tab .. ': up stays in the detail')
    key('back')
    eq(app.state.open.book, false, tab .. ': cancel from in-book detail closes the book')
    -- 一覧からのキャンセルは、これまでどおり見出しへ、もう一度で閉じる
    open_tab(tab)
    key('down')
    eq(cur(), head, tab .. ': heading again')
    key('confirm')
    check(cur():find('^row_'), tab .. ': confirm → list again')
    key('back')
    eq(cur(), head, tab .. ': cancel from the list → heading')
    key('back')
    eq(app.state.open.book, false, tab .. ': cancel from the heading closes the book')
end

-- 詳細の上の端で上：詳細を送る指示（詳細の中にとどまる）
do
    open_tab('quest')
    key('confirm'); key('confirm')
    eq(cur(), book.DETAIL_ANCHOR, 'quest detail anchor')
    book._detail_scroll = nil
    app.input('up', true, 'key'); app.input('up', false, 'key')
    eq(book._detail_scroll, -book.DETAIL_STEP, 'up at the top scrolls the detail')
    frame()
    eq(book._detail_scroll, nil, 'scroll applied in the detail pane')
    eq(cur(), book.DETAIL_ANCHOR, 'focus stays')
    app.close_window('book'); frame()
end

print('test_book_225 ok')

-- t503：閉じた見出しで決定しても開かない。表へ入り、その見出しの行が出る（開け閉めは左右だけ）
for _, tab in ipairs({ 'mission', 'quest' }) do
    open_tab(tab)
    key('down')
    local head = cur()
    local hid = head:match('^sec_' .. tab .. '_(.+)$')
    check(hid ~= nil, tab .. ': heading id: ' .. head)
    key('left')
    eq(book.is_collapsed(S, tab, hid), true, tab .. ': left collapses')
    key('confirm')
    eq(book.is_collapsed(S, tab, hid), true, tab .. ': confirm keeps it collapsed')
    check(cur():find('^row_') ~= nil, tab .. ': confirm enters the rows: ' .. cur())
    check(#rows() > 0, tab .. ': rows shown under the collapsed heading')
    key('back')
    eq(cur(), head, tab .. ': cancel back to the heading')
    eq(book.is_collapsed(S, tab, hid), true, tab .. ': still collapsed')
    key('right')
    eq(book.is_collapsed(S, tab, hid), false, tab .. ': right expands')
    app.close_window('book'); frame()
end
print('test_book_225 t503 ok')
