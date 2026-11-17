-- 0.1.226：エミネンスの「表示：」に受注中・未受注・達成（達成済みを非表示はやめた。分類・状態の選択はなくした）、
-- トラッカーのパッドの案内の一行はなし
require('fake_env')
local settings = require('src.core.settings')

-- 保存の移し替え（達成は book_show.completed。「達成済みを非表示」の保存はやめた）
do
    local d = settings.defaults().eminence
    check(d.book_show.accepted and d.book_show.not_accepted, 'default shows 受注中 and 未受注')
    eq(d.book_show.completed, false, 'default 達成 off')
    eq(d.hide_completed, nil, 'hide_completed dropped')
    eq(d.book_root, -2, 'default book_root is すべて（残すだけ）')
    eq(d.book_state, 'all', 'default book_state is all（残すだけ）')
    local m = settings.merge({ eminence = { book_root = 0xF212, book_state = 'accepted', book_text = 'x' } }).eminence
    eq(m.book_show.accepted, true, 'old 受注中 → checked')
    eq(m.book_show.not_accepted, false, 'old 受注中 → 未受注 unchecked')
    eq(m.book_show.completed, false, 'old 受注中 → 達成 off')
    eq(m.hide_completed, nil, 'hide_completed dropped')
    eq(m.book_root, -2, 'saved category ignored')
    eq(m.book_state, 'all', 'state reset')
    eq(m.book_text, 'x', 'search kept')
    local c = settings.merge({ defaults_rev = 5, eminence = { book_state = 'completed', hide_completed = true } }).eminence
    check(not c.book_show.accepted and not c.book_show.not_accepted and c.book_show.completed, 'old 達成 → only 達成')
    eq(c.hide_completed, nil, 'hide_completed dropped')
    local n = settings.merge({ eminence = { book_state = 'not_accepted' } }).eminence
    check(n.book_show.not_accepted and not n.book_show.accepted and not n.book_show.completed, 'old 未受注 → only that')
    local a = settings.merge({ eminence = { book_state = 'all', book_root = -1 } }).eminence
    check(a.book_show.accepted and a.book_show.not_accepted and not a.book_show.completed, 'old すべて → 受注中・未受注 on, 達成 off')
    eq(a.book_root, -2, 'old 分類なし reset')
    local u = settings.merge({ eminence = { book_state = 'unknown' } }).eminence
    check(u.book_show.accepted and u.book_show.not_accepted and not u.book_show.completed, 'old unknown → 受注中・未受注 on, 達成 off')
    local shown = settings.merge({ defaults_rev = 5, eminence = { book_state = 'all', hide_completed = false } }).eminence
    eq(shown.book_show.completed, true, 'old hide off → 達成 on')
    local k = settings.merge({ defaults_rev = 5, eminence = { book_state = 'accepted', book_show = { accepted = true, not_accepted = true, completed = false }, hide_completed = false } }).eminence
    check(k.book_show.accepted and k.book_show.not_accepted and not k.book_show.completed, 'new book_show kept (old state / hide ignored)')
    eq(k.hide_completed, nil, 'hide_completed dropped')
    local bad = settings.merge({ eminence = { book_show = 'x' } }).eminence
    check(bad.book_show.accepted and bad.book_show.not_accepted and not bad.book_show.completed, 'broken book_show → default')
    -- マイレイアウトに book_show が入る
    local layouts = require('src.core.layouts')
    check((function ()
        for _, k in ipairs(layouts.EMINENCE_KEYS) do if k == 'book_show' then return true end end
    end)(), 'layouts capture book_show')
end

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local eminence = require('src.ui.eminence')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()

local function items()
    local m = {}
    for _, it in ipairs(focus.windows.book.list or {}) do m[it.id] = it end
    return m
end
local function open_eminence()
    S.book.tab = 'eminence'
    S.book.last_heading = S.book.last_heading or {}
    S.book.last_heading.eminence = 'all'
    S.eminence.book_text = ''
    S.eminence.book_favs_only = false
    if type(S.eminence.book_show) ~= 'table' then
        S.eminence.book_show = { accepted = true, not_accepted = true, completed = false }
    else
        S.eminence.book_show.accepted = true
        S.eminence.book_show.not_accepted = true
        if S.eminence.book_show.completed == nil then S.eminence.book_show.completed = false end
    end
    eminence.reset_search()
    app.close_window('book'); frame()
    app.open_window('book'); frame(); frame(); frame()
end

-- 「表示：」のチェック（分類・状態の選択は無い）
open_eminence()
do
    local m = items()
    check(m.roe_show_accepted and m.roe_show_not_accepted and m.roe_show_completed, 'eminence 受注中 / 未受注 / 達成 checks')
    check(not m.roe_hide_done, 'no 達成済みを非表示 checkbox')
    check(not m.roe_root and not m.roe_state, 'no category/state filter')
    eq(m.roe_show_accepted.row, m.roe_show_completed and m.roe_show_completed.row or 'f2', 'same row as 達成')
    eq(m.roe_show_completed.row, m.roe_favs_only and m.roe_favs_only.row or 'f2', 'favorites stay on the same row')
    check(m.roe_favs_only, 'favorites stay')
    check(texted('表示：') or texted('Show:'), '表示 label')
    check(texted('受注中') or texted('In progress'), '受注中 label')
    check(texted('未受注') or texted('Not accepted'), '未受注 label')
    check(texted('達成') or texted('Done'), '達成 label')
    check(m.roe_search and m.roe_search.row == 'tabs', 'search on the tab row')
end

app.close_window('book'); frame()


-- トラッカー：操作中でも案内の一行は出さない
do
    app.close_all(); frame()
    S.tracker.visible = true
    S.tracker.collapsed = false
    app.request('pin', 'mission.sandoria.001')
    app.state.active = 'tracker'
    frame(); frame()
    check(drawn('astertrail_tracker'), 'tracker drawn')
    eq(app.state.active, 'tracker', 'tracker operating')
    check(not texted('パッドで操作中') and not texted('with the pad'), 'no tracker pad help line')
    app.state.active = nil
    frame()
end

print('test_book_226 ok')
