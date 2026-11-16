-- 0.1.43: YunaUI 風のスライダーとスイッチ、一覧の列の並べ替え
require('fake_env')
local imgui = package.loaded['imgui']
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local theme = require('src.ui.theme')
local W = require('src.ui.widgets')
local book = require('src.ui.book')
local settings = require('src.core.settings')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()

local function seen(pat)
    for _, l in ipairs(FAKE.labels) do if l:find(pat, 1, true) then return true end end
    return false
end
local function open_layout()
    app.close_all(); frame()
    FAKE.labels = {}
    app.open_window('settings'); frame(); frame()
    require('src.ui.settings_ui').select_tab('layout'); frame(); frame()
end

-- YunaUI 風：スイッチ（ボタンに「：オン」は付かない）
S.look = 'yunaui'
open_layout()
check(seen('配置ロック##lock'), 'switch drawn')
check(not seen('：オフ##lock') and not seen('：オン##lock'), 'no on/off text button in yunaui')
local before = S.layout_locked
FAKE.clicks['##lock'] = true; frame(); frame()
eq(S.layout_locked, not before, 'switch click toggles once')
focus.set('settings', 'lock'); frame()
press(0x1C); frame(); frame()
eq(S.layout_locked, before, 'enter toggles back')

-- これまで：今までのボタン
S.look = 'classic'
open_layout()
check(seen('：オフ##lock') or seen('：オン##lock'), 'classic on/off button')
S.look = 'yunaui'

-- スライダーの見た目：積んだ色は戻す、桃色の帯の長さは値の割合
local pc = 0
local op, oq = imgui.PushStyleColor, imgui.PopStyleColor
imgui.PushStyleColor = function () pc = pc + 1 end
imgui.PopStyleColor = function (n) pc = pc - (n or 1) end
local n = W.hide_slider(imgui)
check(n == 5, 'slider colors hidden (' .. n .. ')')
imgui.PopStyleColor(n)
eq(pc, 0, 'balanced')
imgui.PushStyleColor, imgui.PopStyleColor = op, oq
local fills, circles = {}, 0
local dl = setmetatable({
    AddRectFilled = function (_, a, b, c) fills[#fills + 1] = { a[1], b[1], c } end,
    AddCircleFilled = function () circles = circles + 1 end,
}, { __index = function () return function () end end })
local ogd = imgui.GetWindowDrawList
imgui.GetWindowDrawList = function () return dl end
W.draw_slider(imgui, { 100, 0, 300, 24 }, 0.5, false)
eq(#fills, 2, 'track + fill'); eq(fills[1][2], 300, 'track full width'); eq(fills[2][2], 200, 'fill to half')
eq(circles, 0, 'no knob when idle')
fills = {}
W.draw_slider(imgui, { 100, 0, 300, 24 }, 0, true)
eq(#fills, 1, 'no fill at zero'); check(circles >= 1, 'knob when hovered/focused')
imgui.GetWindowDrawList = ogd

-- 列の並び
local d = settings.normalize_columns(nil)
eq(table.concat(d, ','), 'no,name,rewards,state', 'default columns (0.1.69: pin no name rewards state)')
eq(table.concat(settings.normalize_columns({ 'name', 'bogus', 'name', 'state', 'repeat' }), ','), 'name,state,no,rewards', 'normalize drops repeat')
local m = settings.merge({ book = { columns = { 'rewards', 'name' } } })
eq(m.book.columns[1], 'rewards', 'loaded order kept')
eq(#m.book.columns, 4, 'filled up')
local T = { book = { columns = settings.normalize_columns(nil) } }
eq(table.concat(book.column_keys(T, false), ','), 'name,rewards,state', 'no column hidden')
check(book.swap_columns(T, 'state', 'name'), 'swap')
eq(table.concat(T.book.columns, ','), 'no,state,rewards,name', 'swap keeps hidden no in place')
check(book.reset_columns(T), 'reset changed'); eq(table.concat(T.book.columns, ','), 'no,name,rewards,state', 'reset')
check(not book.reset_columns(T), 'reset again unchanged')

-- 見出しをつかんで左へ動かす：となりの列の真ん中を越えたときだけ、一つずつ（0.1.44）
-- 見出しは幅 100 ずつ並ぶ（i 番目は i*100 〜 (i+1)*100）
local last, idx, dirty, mx, now = nil, -1, 0, 0, 0
local hdr = setmetatable({
    TableSetColumnIndex = function (i) idx = i end,
    TableHeader = function (l) last = l end,
    GetItemRectMin = function () return idx * 100, 0 end,
    GetItemRectMax = function () return idx * 100 + 100, 20 end,
    GetMousePos = function () return mx, 10 end,
    GetTime = function () return now end,
    IsItemActive = function () return last == 'book.col.state##hdr_state' end,
    IsItemHovered = function () return false end,
    IsMouseDoubleClicked = function () return false end,
}, { __index = function () return function () end end })
local fui = { imgui = hdr, t = function (k) return k end, settings = T, mark_settings_dirty = function () dirty = dirty + 1 end }
-- state は 4 番目（400〜500）。左どなりの rewards は 300〜400、真ん中 350
mx = 380; now = 1; book.draw_headers(fui, book.column_keys(T, true))
eq(table.concat(T.book.columns, ','), 'no,name,rewards,state', 'not past middle: no swap')
mx = 340; now = 2; book.draw_headers(fui, book.column_keys(T, true))
eq(table.concat(T.book.columns, ','), 'no,name,state,rewards', 'past middle: swap with left neighbour')
eq(dirty, 1, 'saved')
-- すぐ次のフレームでは動かない（待ち）、そのあとも同じ位置ならもう動かない（state は 300〜400、左の name の真ん中は 250）
now = 2.05; book.draw_headers(fui, book.column_keys(T, true))
now = 3; book.draw_headers(fui, book.column_keys(T, true))
eq(table.concat(T.book.columns, ','), 'no,name,state,rewards', 'one swap per crossing')
-- 遠くまで一気に動かしても、一回に一つだけ
mx = 0; now = 4; book.draw_headers(fui, book.column_keys(T, true))
eq(table.concat(T.book.columns, ','), 'no,state,name,rewards', 'one step at a time')
now = 4.05; book.draw_headers(fui, book.column_keys(T, true))
eq(table.concat(T.book.columns, ','), 'no,state,name,rewards', 'waits right after a swap')
now = 5; book.draw_headers(fui, book.column_keys(T, true))
eq(table.concat(T.book.columns, ','), 'state,no,name,rewards', 'next step later')
-- ピンの列とは入れ替わらない
now = 6; book.draw_headers(fui, book.column_keys(T, true))
eq(T.book.columns[1], 'state', 'pin column fixed')
-- 右へ
mx = 260; now = 7; book.draw_headers(fui, book.column_keys(T, true))
eq(table.concat(T.book.columns, ','), 'no,state,name,rewards', 'drag right past middle')
-- ダブルクリックで元へ
hdr.IsItemActive = function () return false end
hdr.IsItemHovered = function () return last == 'book.col.name##hdr_name' end
hdr.IsMouseDoubleClicked = function () return true end
book.draw_headers(fui, book.column_keys(T, true))
eq(table.concat(T.book.columns, ','), 'no,name,rewards,state', 'double click resets')

-- 列を出す・隠す（0.1.44）
local V = { book = { columns = settings.normalize_columns(nil), hidden = {} } }
check(book.toggle_column(V, 'rewards', true), 'hide rewards')
eq(table.concat(book.column_keys(V, true), ','), 'no,name,state', 'rewards hidden')
check(book.column_shown(V, 'name') and not book.column_shown(V, 'rewards'), 'shown flags')
for _, k in ipairs({ 'state', 'no' }) do book.toggle_column(V, k, true) end
eq(table.concat(book.column_keys(V, true), ','), 'name', 'only name left')
check(not book.toggle_column(V, 'name', true), 'cannot hide the last column')
eq(table.concat(book.column_keys(V, true), ','), 'name', 'name stays')
-- 番号の無い一覧：番号は数えない
local V2 = { book = { columns = settings.normalize_columns(nil), hidden = { state = true, rewards = true } } }
check(not book.toggle_column(V2, 'name', false), 'last shown in quest list (no is not there)')
check(book.toggle_column(V, 'rewards', true), 'show again')
eq(table.concat(book.column_keys(V, true), ','), 'name,rewards', 'order follows saved order')
V.book.columns = { 'rewards', 'name', 'state', 'no' }
eq(table.concat(book.column_keys(V, true), ','), 'rewards,name', 'reordered + hidden skipped')
check(book.reset_columns(V), 'reset'); eq(#book.column_keys(V, true), 4, 'reset shows all')

-- 0.1.69：リピートの列を無くしたときの保存の移し替え
do
    -- 前の初期の並びのまま（変えていない）→ 新しい初期の並び
    local a = settings.merge({ defaults_rev = 2, book = { columns = { 'state', 'repeat', 'no', 'name', 'rewards' } } })
    eq(table.concat(a.book.columns, ','), 'no,name,rewards,state', 'old default order -> new default')
    eq(a.defaults_rev, 8, 'defaults_rev 8')
    -- 自分で並べた保存（実機の保存と同じ）：リピートだけ外し、並びはそのまま
    local b = settings.merge({ defaults_rev = 2, book = { columns = { 'no', 'name', 'rewards', 'state', 'repeat' }, hidden = { ['repeat'] = true } } })
    eq(table.concat(b.book.columns, ','), 'no,name,rewards,state', 'own order kept, repeat dropped')
    check(next(b.book.hidden) == nil, 'hidden repeat dropped')
    local c = settings.merge({ defaults_rev = 2, book = { columns = { 'name', 'repeat', 'state', 'no', 'rewards' }, hidden = { rewards = true, ['repeat'] = true } } })
    eq(table.concat(c.book.columns, ','), 'name,state,no,rewards', 'custom order kept without repeat')
    check(c.book.hidden.rewards == true and c.book.hidden['repeat'] == nil, 'other hidden kept')
    -- 改訂後の保存で前の初期の並びと同じでも、自分で並べたものとして残す（リピートだけ外す）
    local e = settings.merge({ defaults_rev = 3, book = { columns = { 'state', 'no', 'name', 'rewards' } } })
    eq(table.concat(e.book.columns, ','), 'state,no,name,rewards', 'rev3 order kept')
    -- 全部隠していてリピートだけ出ていた → 全部出す
    local f = settings.merge({ defaults_rev = 2, book = { hidden = { state = true, name = true, rewards = true, no = true } } })
    check(next(f.book.hidden) == nil, 'all hidden -> all shown')
end
-- 保存の読み込み
local mh = settings.merge({ book = { hidden = { rewards = true, bogus = true } } })
check(mh.book.hidden.rewards and mh.book.hidden.bogus == nil, 'hidden normalized')
local mall = settings.merge({ book = { hidden = { state = true, ['repeat'] = true, no = true, name = true, rewards = true } } })
check(next(mall.book.hidden) == nil, 'all hidden -> all shown')
eq(#book.toggle_keys({ book = {} }, false), 3, 'toggles without no column')

-- 設定の 配置 に「列の並びを元に戻す」
S.book.columns = { 'rewards', 'state', 'no', 'name' }
open_layout()
FAKE.clicks['##reset_cols'] = true; frame(); frame()
eq(S.book.columns[1], 'no', 'settings button resets order')

-- 本の表は並びのとおりに列を作る
S.book.columns = { 'name', 'state', 'no', 'rewards' }
local setup = {}
local otsc = imgui.TableSetupColumn
rawset(imgui, 'TableSetupColumn', function (l) setup[#setup + 1] = l end)
FAKE.table = true
app.close_all(); frame(); app.open_window('book'); frame(); frame()
rawset(imgui, 'TableSetupColumn', otsc)
FAKE.table = false
check(#setup >= 4, 'table columns set up (' .. #setup .. ')')
eq(setup[1], 'ピン', 'pin first')
eq(setup[2], '名前', 'name second')
-- 本の上の「列：」の行。■／▢ は自分で描き、決定で切り替わる
S.book.columns = settings.normalize_columns(nil); S.book.hidden = {}
app.close_all(); frame()
FAKE.texts = {}
app.open_window('book'); frame(); frame()
local saw, sep = false, false
for _, x in ipairs(FAKE.texts) do
    if x == '列：' then saw = true end
    if x == '｜' then sep = true end
end
check(saw, 'columns label shown')
check(not sep, 'no view/column separator on mission or quest')
focus.set('book', 'col_rewards'); frame()
press(0x1C); frame(); frame()
eq(S.book.hidden.rewards, true, 'enter hides rewards')
press(0x1C); frame(); frame()
eq(S.book.hidden.rewards, nil, 'enter shows again')
print('test_controls ok')
