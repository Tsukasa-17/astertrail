-- 0.1.228：本の一覧。マウスはクリックしたときだけ詳細を動かす。キー・パッドは移ったときに動かす。見出しでは動かさない。
require('fake_env')
local book = require('src.ui.book')
local focus = require('src.ui.focus')
local settings_mod = require('src.core.settings')

-- ユニット：follow_focus_row（クエスト・ミッションの一覧）
do
    local settings = settings_mod.defaults()
    settings.book.last_row = 'quest.bastok.001'
    local shown = { { id = 'quest.bastok.001' }, { id = 'quest.bastok.002' } }
    local ui = { settings = settings, mark_settings_dirty = function () end, t = function (k) return k end }
    book._follow_seen = nil
    focus.set('book', 'row_quest.bastok.002', false, 'hover')
    eq(book.follow_focus_row(ui, 'book', shown), false, 'hover does not follow')
    eq(settings.book.last_row, 'quest.bastok.001', 'detail stays on the clicked row')
    book._follow_seen = nil
    focus.set('book', 'row_quest.bastok.002', false, 'nav')
    eq(book.follow_focus_row(ui, 'book', shown), true, 'nav follows')
    eq(settings.book.last_row, 'quest.bastok.002', 'detail moves with the pad')
    -- 見出しに移っても詳細は行のまま
    local kept = settings.book.last_row
    book._follow_seen = nil
    focus.set('book', 'sec_bastok', false, 'nav')
    eq(book.follow_focus_row(ui, 'book', shown), false, 'heading does not change the row')
    eq(settings.book.last_row, kept, 'detail stays when a heading is focused')
    -- クリック（why が set）は詳細を動かす
    book._follow_seen = nil
    settings.book.last_row = 'quest.bastok.002'
    focus.set('book', 'row_quest.bastok.001', false, 'set')
    eq(book.follow_focus_row(ui, 'book', shown), true, 'click/set follows')
    eq(settings.book.last_row, 'quest.bastok.001', 'detail moves on click')
end
