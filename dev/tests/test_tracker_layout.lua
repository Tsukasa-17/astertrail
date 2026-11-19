-- 0.1.62: トラッカーの見出しなし・右上の ×・たたむと必要品なし・本のトラッカーのボタン・右そろえ／左そろえ
-- 0.1.63: 通し番号なし・ミッション番号＋状態のアイコン
require('fake_env')
local imgui = package.loaded['imgui']

-- 文字の位置を数える偽の imgui（1文字 7px、行の始まり x=8、使える幅 380 → 右端 388）
local START, AVAIL, CW = 8, 380, 7
local L = { cx = START, last_end = START, pad = 4, items = {} }
local function ulen(s) local n = 0; for _ in tostring(s):gmatch('[%z\1-\127\194-\244][\128-\191]*') do n = n + 1 end; return n end
local function vis(label) return (tostring(label):gsub('##.*$', '')) end
imgui.CalcTextSize = function (s) return ulen(vis(s)) * CW, 14 end
imgui.GetCursorPosX = function () return L.cx end
imgui.SetCursorPosX = function (x) L.cx = x end
imgui.GetContentRegionAvail = function () return START + AVAIL - L.cx, 200 end
imgui.GetStyle = function () return { FramePadding = { x = 4, y = 2 }, ItemSpacing = { x = 8, y = 4 } } end
imgui.SameLine = function (_, sp) L.cx = L.last_end + ((sp == nil or sp < 0) and 8 or sp) end
imgui.NewLine = function () L.cx = START end
local old_begin = imgui.Begin
imgui.Begin = function (...) L.cx = START; L.win = (...); return old_begin(...) end
imgui.PushStyleVar = function (idx, v) if type(v) == 'table' and v[1] == 0 then L.pad = 0 end end
imgui.PopStyleVar = function () L.pad = 4 end
local function put(label, w, kind)
    L.items[#L.items + 1] = { label = label, x = L.cx, w = w, win = L.win, kind = kind }
    L.last_end = L.cx + w
    L.cx = START
end
local old_small = imgui.SmallButton
imgui.SmallButton = function (label)
    local r = old_small(label)
    put(label, ulen(vis(label)) * CW + L.pad * 2, 'button')
    return r
end
local old_sel = imgui.Selectable
imgui.Selectable = function (label, ...)
    local r = old_sel(label, ...)
    put(label, ulen(vis(label)) * CW + L.pad * 2, 'button')
    return r
end
local old_inv = imgui.InvisibleButton
imgui.InvisibleButton = function (label, ...)
    local r = old_inv(label, ...)
    put(label, ulen(vis(label)) * CW + L.pad * 2, 'button')
    return r
end
local old_btn = imgui.Button
imgui.Button = function (label, ...)
    local r = old_btn(label, ...)
    put(label, ulen(vis(label)) * CW + L.pad * 2, 'button')
    return r
end
for _, fn in ipairs({ 'TextColored', 'TextDisabled', 'TextWrapped', 'Text' }) do
    imgui[fn] = function (a, b)
        local s = (fn == 'TextColored') and b or a
        FAKE.texts[#FAKE.texts + 1] = s
        put(s, ulen(s) * CW, 'text')
    end
end
-- 状態のアイコン（0.1.63〜）：Dummy で幅を取り、SameLine(0, 4) で名前が続く
imgui.Dummy = function (sz) put('[icon]', (type(sz) == 'table' and sz[1]) or 0, 'icon') end
local function begin_frame() L.items = {} end
local function tracker_items() local o = {}; for _, it in ipairs(L.items) do if tostring(it.win):find('astertrail_tracker') then o[#o + 1] = it end end; return o end
local function find(pat) for _, it in ipairs(tracker_items()) do if tostring(it.label):find(pat, 1, true) then return it end end end

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local PR = app._progress()
local settings = require('src.core.settings')
eq(settings.merge({}).tracker.align, 'right', 'default align is right')
eq(settings.merge({ tracker = { align = 'bogus' } }).tracker.align, 'right', 'bad align -> right')
eq(settings.merge({ tracker = { align = 'left' } }).tracker.align, 'left', 'left kept')

local QM, QA = 'mission.sandoria.001', 'quest.bastok.005'
app.close_all()
S.tracker.visible = true; S.tracker.collapsed = false
app.request('pin', QA); app.request('pin', QM)
app.request('set_current_step', QA, QA .. '#g03')
begin_frame(); frame()

-- 見出しの行なし（NoTitleBar）、右上に × だけ
check(drawn('astertrail_tracker'), 'tracker drawn')
check(labeled('×##hide'), 'small × button')
check(not labeled('##collapse'), 'no collapse button in a header row')
check(not labeled('－ たたむ') and not labeled('＋ ひらく'), 'no collapse labels')
local x = find('##hide')
eq(x.x + x.w, START + AVAIL, '× sits at the top right')
-- ミッション番号は出さない（通し番号は残す）
check(not labeled('1. '), 'no serial number (0.1.63)')
check(find('##q_' .. QM).label:find('^SM%d') ~= nil, 'mission number first (0.1.63)')
-- アイコンは名前のすぐ左
do
    local list = tracker_items()
    local qi
    for i, it in ipairs(list) do if tostring(it.label):find('##q_' .. QM, 1, true) then qi = i end end
    check(qi and list[qi - 1].kind == 'icon', 'icon right before the mission name')
    eq(list[qi - 1].x + list[qi - 1].w + 4, list[qi].x, 'name follows the icon')
end

-- 右そろえ：どの行も右端 388 で終わる。押せる名前（地図・コピー）も文字の位置どおり
local function line_ends()
    local ends, rows = {}, {}
    local list = tracker_items()
    for i, it in ipairs(list) do
        local nxt = list[i + 1]
        local same_line = nxt and nxt.x == it.x + it.w   -- SameLine(0,0) で続く
        local spaced = nxt and nxt.x == it.x + it.w + 8  -- ボタンの並び
        local after_icon = it.kind == 'icon' and nxt and nxt.x == it.x + it.w + 4
        if not same_line and not spaced and not after_icon then ends[#ends + 1] = it end
    end
    return ends
end
local ends = line_ends()
check(#ends >= 8, 'many lines measured (' .. #ends .. ')')
for _, it in ipairs(ends) do
    local bold = tostring(it.label):find('##q_', 1, true) and 1 or 0
    eq(it.x + it.w + bold, START + AVAIL, 'right aligned: ' .. vis(it.label))
end
local link = find('Roh Latteh##')
check(link ~= nil, 'map link drawn')
local nm = find('##q_' .. QA)
eq(nm.x + nm.w + 1, START + AVAIL, 'name (with 1px bold) at right edge')
local item = find('カッパーリング##')
if item then check(item.x > START, 'item link moved with the text') end
local unpin = find('##unpin_' .. QM)
eq(unpin.x + unpin.w, START + AVAIL, 'ops row right aligned')
-- 手順の数（0.1.64〜）：右そろえは ◀ の左
local function before(pat)
    local list = tracker_items()
    for i, it in ipairs(list) do if tostring(it.label):find(pat, 1, true) then return list[i - 1], it end end
end
local function after(pat)
    local list = tracker_items()
    for i, it in ipairs(list) do if tostring(it.label):find(pat, 1, true) then return list[i + 1], it end end
end
do
    local cnt, prev = before('##prev_' .. QM)
    check(cnt and tostring(cnt.label):match('^%d+/%d+$'), 'right: count left of ◀ (' .. tostring(cnt and cnt.label) .. ')')
    eq(cnt.x + cnt.w + 8, prev.x, 'right: count then ◀')
    local cq = before('##prev_' .. QA)
    local ci, ct = PR:step_count(QA)
    eq(cq.label, ci .. '/' .. ct, 'quest count matches step_count')
    local nxt = after('##unpin_' .. QM)
    check(not (nxt and tostring(nxt.label):match('^%d+/%d+$')), 'right: nothing after the pin')
end
-- 見出しの帯を出さない：Begin に開閉の表と NoTitleBar・NoCollapse を渡す
do
    local fl
    for k, v in pairs(FAKE.begin_flags or {}) do if tostring(k):find('astertrail_tracker', 1, true) then fl = v end end
    check(fl ~= nil, 'tracker flags recorded')
    check(math.floor(fl / 1) % 2 == 1, 'NoTitleBar set')
    check(math.floor(fl / 32) % 2 == 1, 'NoCollapse set')
end

-- 折り返した行も右へ（幅を狭くして）
AVAIL = 160
begin_frame(); frame()
local ends2 = line_ends()
check(#ends2 > #ends, 'narrow: more lines (wrapped) ' .. #ends2 .. ' > ' .. #ends)
for _, it in ipairs(ends2) do
    local bold = tostring(it.label):find('##q_', 1, true) and 1 or 0
    if it.w + bold <= AVAIL then eq(it.x + it.w + bold, START + AVAIL, 'wrapped right aligned: ' .. vis(it.label)) end
end
AVAIL = 380

-- 左そろえ：行の始まりは 8
S.tracker.align = 'left'
begin_frame(); frame()
eq(find('##q_' .. QM).x, START + 14 + 4, 'left: icon at start, then the name')
eq(find('##prev_' .. QM).x, START, 'left: ops row at start')
do
    local cnt, unpin2 = after('##unpin_' .. QM)
    check(cnt and tostring(cnt.label):match('^%d+/%d+$'), 'left: count right of the pin')
    eq(unpin2.x + unpin2.w + 8, cnt.x, 'left: pin then count')
    local b4 = before('##prev_' .. QM)
    check(not (b4 and tostring(b4.label):match('^%d+/%d+$')), 'left: nothing before ◀')
end
local link2 = find('Roh Latteh##')
check(link2 and link2.x < link.x, 'left: map link moves left with the text')
local x2 = find('##hide')
eq(x2.x + x2.w, START + AVAIL, '× stays at top right when left aligned')
S.tracker.align = 'right'

-- 必要品まとめのボタンは 0.1.173 でなくした
begin_frame(); frame()
check(not labeled('##items'), 'no items button (removed 0.1.173)')
-- 空いている所をダブルクリックでたたむ
imgui.IsWindowHovered = function () return true end
imgui.IsAnyItemHovered = function () return false end
FAKE.double = true; frame(); FAKE.double = false
imgui.IsWindowHovered = function () return false end
check(S.tracker.collapsed, 'double-click on empty area collapses')
begin_frame(); frame()
local n = 0
for _, it in ipairs(tracker_items()) do if tostring(it.label):find('必要品', 1, true) or tostring(it.label):find('##items', 1, true) then n = n + 1 end end
eq(n, 0, 'collapsed: nothing about items in the tracker')
check(labeled('×##hide'), '× also when collapsed')
S.tracker.collapsed = false

-- × で隠れる
FAKE.clicks['##hide'] = true; frame(); frame()
check(not S.tracker.visible, '× hides the tracker')
check(not drawn('astertrail_tracker'), 'not drawn after ×')

-- 本の上の行：コンパス・トラッカー（自分で描いた絵）・⚙️ の順（0.1.173〜。前は「● トラッカー／○ トラッカー」）
app.open_window('book'); frame()
local labels_ = FAKE.labels
local ic_, it_, ie_, is_ = nil, nil, nil, nil
for i, l in ipairs(labels_) do
    if l == '##compass_toggle' then ic_ = i end
    if l == '##tracker_toggle' then it_ = i end
    if l == '##eminence_toggle' then ie_ = i end
    if l == '##open_settings' then is_ = i end
end
-- 0.1.177〜：エミネンスの窓のボタン（チェックの紙）がトラッカー（金色の星）と ⚙️ のあいだ
check(ic_ and it_ and ie_ and is_ and ic_ + 1 == it_ and it_ + 1 == ie_ and ie_ + 1 == is_, 'compass, tracker, eminence, settings icons in a row')
do
    local icons = require('src.ui.icons')
    local n_star, n_paper = 0, 0
    local o1, o2 = icons.star, icons.checklist
    icons.star = function (...) n_star = n_star + 1; return o1(...) end
    icons.checklist = function (...) n_paper = n_paper + 1; return o2(...) end
    -- 描画リストを使う偽物で絵を描かせる
    local dl = setmetatable({}, { __index = function () return function () end end })
    o1(dl, 10, 10, 8, 1, 2); o2(dl, 10, 10, 8, 1, 2, 3, 4)
    icons.star, icons.checklist = o1, o2
    local e0 = S.eminence.visible == true
    local n_inj = INJ and #INJ or 0
    FAKE.clicks['##eminence_toggle'] = true; frame(); frame()
    eq(S.eminence.visible == true, not e0, 'book button toggles the eminence window')
    FAKE.clicks['##eminence_toggle'] = true; frame(); frame()
    eq(S.eminence.visible == true, e0, 'and back')
    eq(INJ and #INJ or 0, n_inj, 'eminence button sends nothing')
end
check(not labeled('トラッカー##tracker_toggle'), 'no text on the tracker button')
FAKE.clicks['##tracker_toggle'] = true; frame(); frame()
check(S.tracker.visible, 'book button turns tracker on')
-- コントローラーでも押せる
local focus = require('src.ui.focus')
focus.set('book', 'tracker_toggle'); frame()
press(0x1C); frame(); frame()
check(not S.tracker.visible, 'confirm on book button turns tracker off')
check(app.state.open.book, 'book stays open')
app.close_all(); frame()

-- 設定：そろえ方とたたむ
S.tracker.visible = true
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('tracker'); frame(); frame()
check(labeled('文字のそろえ方：右そろえ'), 'align setting shows right')
FAKE.clicks['##tr_align'] = true; frame(); frame()
eq(S.tracker.align, 'left', 'switched to left')
check(labeled('文字のそろえ方：左そろえ'), 'align setting shows left')
app.close_all(); frame()
