require('fake_env')
dofile(ROOT .. '/astertrail.lua')
local app = require('src.app')
local focus = require('src.ui.focus')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local book_ui = require('src.ui.book')
local S = app._settings()
local function area()
    local c = focus.current('book')
    for _, it in ipairs(focus.windows.book.list or {}) do
        if it.id == c then return book_ui.area_of(it.section) end
    end
end
cmd('/astertrail'); frame(); frame(); frame()
-- 0.1.204〜：選んでいた行が無い初回は、いちばん上の見出しから（タブの選択ではない）
eq(S.book.tab, 'mission', 'first open is missions')
local h0 = focus.current('book')
check(h0 and tostring(h0):find('^sec_'), 'starts on a top heading: ' .. tostring(h0))
check(not texted('パッドで操作中') and not texted('with the pad'), 'no pad help line (0.1.225, t499)')
-- 上下は同じ段の見出し。決定で中の行へ
press(0xD0); frame(); frame()
local h1 = focus.current('book')
check(h1 and tostring(h1):find('^sec_'), 'down stays on a heading: ' .. tostring(h1))
check(h1 ~= h0, 'down moves to the next heading')
press(0xC8); frame(); frame()
eq(focus.current('book'), h0, 'up back to the first heading')
press(0x1C); frame(); frame(); frame()
local id0 = focus.current('book')
check(id0 and tostring(id0):find('^row_'), 'confirm enters the mission list: ' .. tostring(id0))
check(not texted('パッドで操作中') and not texted('with the pad'), 'no pad help line on rows (0.1.225, t499)')
-- Tab（肩ボタン）は 上の行 → 見出しの木 → 一覧 → 詳細 の4つを回る
local seen = {}
for i = 1, 4 do press(0x0F); frame(); seen[#seen + 1] = area() end
eq(table.concat(seen, ','), 'detail,top,tree,list', 'Tab cycles the four areas')
local id = focus.current('book')
eq(id, id0, 'back on the same list row')
check(id and tostring(id):find('row_'), 'reach list via Tab: ' .. tostring(id))
press(0xD0); frame()
check(focus.current('book') ~= id, 'down moves in the list')
local row = focus.current('book')
press(0x1C); frame(); frame()
-- 決定は本の中で選ぶだけ（詳細は本の右側。別の窓は出さない）
check(not app.state.open.detail, 'enter does not open a separate detail')
eq(app.state.active, 'book', 'book still operating')
eq('row_' .. tostring(S.book.last_row), row, 'enter selects the focused row')
check(labeled('##pin') or labeled('##chk_'), 'detail pane drawn in the book')
-- 0.1.285〜：行で決定すると右の詳細へ。キャンセルは本を閉じる（枠の点滅だけにしない）
eq(focus.current('book'), 'detail_pane', 'enter moves into the detail')
press(0x01); frame(); frame()
eq(app.state.open.book, false, 'cancel from in-book detail closes the book')
-- 一覧からのキャンセルは見出しへ戻る（本は開いたまま）
cmd('/astertrail'); frame(); frame(); frame()
press(0x1C); frame(); frame(); frame()
local row2 = focus.current('book')
check(row2 and tostring(row2):find('^row_'), 'reopened list: ' .. tostring(row2))
press(0x01); frame(); frame()
eq(app.state.open.book, true, 'cancel from a row keeps the book open')
local back = focus.current('book')
check(back and tostring(back):find('^sec_'), 'cancel returns to the heading: ' .. tostring(back))
-- いちばん上の見出しでもう一度キャンセルすると本を閉じる
app.state.active = 'book'
pad(13, 1); pad(13, 0); frame()
check(not app.state.open.book, 'B on the top heading closes the book')
check(not app.want_pad(), 'released')
-- 選んでいた行があるときは、開き直すと見出しから（行は選んだまま詳細に出る）
S.book.tab = 'quest'
S.book.last_row = 'quest.sandoria.006'
app.open_window('book'); frame(); frame(); frame()
local hq = focus.current('book')
check(hq and tostring(hq):find('^sec_quest_'), 'reopen focuses the heading, not the row: ' .. tostring(hq))
eq(S.book.last_row, 'quest.sandoria.006', 'last row is still selected')
press(0x01); frame(); frame()
check(not app.state.open.book, 'cancel in the tree closes the book')
-- トラッカー操作
FAKE.player.zone = 230
app.open_detail('quest.bastok.001'); frame()
FAKE.clicks['##pin'] = true; frame(); frame()
cmd('/astertrail close'); frame()
cmd('/astertrail tracker focus'); frame()
eq(app.state.active, 'tracker', 'tracker focus')
check(pad(1, 1), 'pad taken in tracker focus'); pad(1, 0); frame()
press(0x01); frame()
check(not app.want_keys(), 'Esc releases tracker')
check(drawn('astertrail_tracker'), 'tracker still visible')
-- 文字入力中は Esc 以外のキーを Astertrail の操作に使わない（0.1.311〜：ゲームにも渡さない。欄は Windows のキーの知らせで動く）
cmd('/astertrail'); frame()
app.state.text_active = true
local sel0 = app.state.focus and app.state.focus.book
eq(key(0xCB, true), true, 'text input: the game does not get arrows'); key(0xCB, false)
eq(app.state.focus and app.state.focus.book, sel0, 'text input keeps keys from the book')
FAKE.events.unload()
