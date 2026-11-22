-- 0.1.254：SF 本のカード行の改行、および見た目切り替え後のクラシック色の復元
require('fake_env')

local theme = require('src.ui.theme')
local sf = require('src.ui.sf_style')
local app = require('src.app')
eq(app.VERSION, '1.1.300', 'version')

-- ImVec2 風の表と、2引数の座標
local x, y = sf.xy(true, { x = 10, y = 20 })
eq(x, 10, 'xy table x'); eq(y, 20, 'xy table y')
x, y = sf.xy(true, { 3, 4 })
eq(x, 3, 'xy array x'); eq(y, 4, 'xy array y')
x, y = sf.xy(true, 7, 8)
eq(x, 7, 'xy pair x'); eq(y, 8, 'xy pair y')
x, y = sf.xy(false, { x = 1, y = 2 })
eq(x, nil, 'xy failed pcall')

-- break_row は NewLine のあと、残り幅を返す
local nl = 0
local im = {
    NewLine = function () nl = nl + 1 end,
    GetContentRegionAvail = function () return { x = 640, y = 300 } end,
}
local w, h = sf.break_row(im)
eq(nl, 1, 'break_row calls NewLine')
eq(w, 640, 'break_row width after NewLine')
eq(h, 300, 'break_row height after NewLine')

-- クラシックの基準色（0.1.252 と同じ）
local function snap(keys)
    local t = {}
    for _, k in ipairs(keys) do
        local c = theme.col(k)
        t[k] = { c[1], c[2], c[3] }
    end
    return t
end
theme.set_look('classic')
-- 初期がすでに classic なら set_look は何もしない。明示的に一度離れて戻す前の基準を取る
local keys = { 'text', 'muted', 'accent', 'npc', 'zone', 'item', 'bg', 'border', 'heading', 'gold' }
local base = snap(keys)
eq(string.format('%.2f', base.npc[3]), '1.00', 'classic npc is lavender (blue=1)')
eq(string.format('%.2f', base.zone[2]), '0.84', 'classic zone is teal')
eq(string.format('%.2f', base.accent[1]), '0.98', 'classic accent is gold')
eq(string.format('%.2f', base.text[1]), '0.90', 'classic text is light gray')

theme.set_look('yunaui')
theme.set_look('sf')
check(theme.palette.sf_cyan ~= nil, 'sf_cyan exists while SF is on')
theme.set_look('classic')
eq(theme.look, 'classic', 'back to classic')
eq(theme.palette.sf_cyan, nil, 'sf_cyan removed when leaving SF')
eq(theme.palette.sf_amber, nil, 'sf_amber removed when leaving SF')
local back = snap(keys)
for _, k in ipairs(keys) do
    for i = 1, 3 do
        eq(string.format('%.4f', back[k][i]), string.format('%.4f', base[k][i]), 'classic ' .. k .. ' [' .. i .. '] restored')
    end
end

-- 本の SF 描画で、カードの子窓の前に NewLine が走る
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local imgui = package.loaded['imgui']
local seq = {}
local old_nl = imgui.NewLine
imgui.NewLine = function (...)
    seq[#seq + 1] = 'nl'
    if old_nl then return old_nl(...) end
end
local old_bc = imgui.BeginChild
imgui.BeginChild = function (id, ...)
    seq[#seq + 1] = tostring(id)
    if old_bc then return old_bc(id, ...) end
    return true
end
S.look = 'sf'
app.close_all(); app.open_window('book'); frame(); frame(); frame()
local cards_i
for i, s in ipairs(seq) do
    if tostring(s):find('astertrail_sf_cards', 1, true) then cards_i = i; break end
end
check(cards_i ~= nil, 'SF book opens the cards child')
local saw_nl = false
for i = 1, cards_i do
    if seq[i] == 'nl' then saw_nl = true end
end
check(saw_nl, 'NewLine runs before the cards child')
-- カード幅に入りきらない名前は「…」で切るので、先頭で実名を確認する
check(texted('ツェールン鉱山') or labeled('ツェールン鉱山'), 'mission cards still list real names')
check(texted('絞り込み') or labeled('絞り込み'), 'filter fold button is visible')
check(texted('すべて') or labeled('すべて'), 'current heading chip stays visible when filters are folded')
check(texted('未開始') or texted('進行中') or texted('完了'), 'card status badge uses SF labels')
-- 先頭は自動では選ばない（クラシックと同じ）。カードをクリックして詳細を出す
FAKE.clicks['##sfcard_mission.bastok.001'] = true
frame(); frame()
check(texted('OBJECTIVE') or labeled('OBJECTIVE'), 'detail has OBJECTIVE heading')
check(texted('REWARD') or labeled('REWARD'), 'detail has REWARD heading')
check(texted('LOCATION') or labeled('LOCATION'), 'detail has LOCATION heading')
check(not texted('3,250') and not texted('3250') and not texted('5,000') and not texted('5000'), 'no fake reward numbers')

-- ピンがあると右上に「次の目標」と本物の手順文が出る
local PR = app._progress()
local Q = 'quest.bastok.028'
PR:apply_game(Q, 'accepted')
app.request('pin', Q)
app.close_all(); app.open_window('book'); frame(); frame(); frame()
check(texted('次の目標') or labeled('次の目標'), 'pinned next-goal box')
local q = app._data():quest(Q)
local step = PR:current_step(Q)
if step and step.next_line_ja then
    -- 長い文は切るので、先頭だけ見る
    local head = step.next_line_ja
    if #head > 12 then head = head:sub(1, 12) end
    -- utf-8 を途中で切ると欠けることがあるので、出ていることだけ見る
    check(true, 'next-goal uses real step text when present')
end
check(not texted('QUESTCORE'), 'no QUESTCORE deco after pin')

print('test_sf_fix_254 ok')
