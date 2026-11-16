-- 0.1.60: 詳細の手順。決定で前の手順に自動チェック、戻ると後のチェックを外す。■/□ にはパッドの選択を止めない。
-- 地図の「相手：」を選べる。
require('fake_env')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local D = data_mod.load(posix_fs(), ROOT .. '/data/')
local Q = 'quest.sandoria.056'   -- g01 g02 共通 / ga01 ga02「初めて」/ gb01「他国クリア済み」/ g05 共通
local function S(id) return Q .. '#' .. id end
local function new_p()
    local P = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
    P:reset({ server = 'catseye', name = 'Test' })
    P:set_state(Q, 'accepted')   -- 0.1.180〜：未受注のクエストはチェックできない（下で別に確かめる）
    return P
end
local function done_list(P)
    local out = {}
    for _, s in ipairs(D:quest(Q).steps) do if P:step_done(Q, s.id) then out[#out + 1] = s.id:match('#(.*)') end end
    return table.concat(out, ',')
end
eq(#D:quest(Q).steps, 6, 'quest shape')

-- ルートを選んでいないとき：共通の手順だけ前にチェック
do
    local P = new_p()
    local r = P:decide_step(Q, S('g05'))
    check(r.ok, 'decide ok')
    eq(done_list(P), 'g01,g02', 'no route: only shared steps before')
    eq(P:current_step(Q).id, S('g05'), 'decided step is current')
    eq(P:state(Q), 'accepted', 'accepted')
    check(not P:step_done(Q, S('g05')), 'decided step itself not checked')
end

-- ルートを選んでいるとき：そのルートと共通だけ。ほかのルートには付けない
do
    local P = new_p()
    P:set_route(Q, '初めて')
    P:decide_step(Q, S('g05'))
    eq(done_list(P), 'g01,g02,ga01,ga02', 'route chosen: route + shared')
    check(not P:step_done(Q, S('gb01')), 'other route not checked')
    -- ルートの手順を決定すると、そのルートを選んだことになる
    local P2 = new_p()
    P2:decide_step(Q, S('gb01'))
    eq(P2:chosen_route(Q), '他国クリア済み', 'deciding a route step picks the route')
    eq(done_list(P2), 'g01,g02', 'before gb01: shared only (not the other route)')
    P2:decide_step(Q, S('g05'))
    eq(done_list(P2), 'g01,g02,gb01', 'after picking gb route: gb01 checked, ga not')
end

-- 戻る：チェック済みの手順を決定し直すと、そこから後のチェックを外す
do
    local P = new_p()
    P:set_route(Q, '初めて')
    local r = P:check_through(Q, S('g05'))
    eq(done_list(P), 'g01,g02,ga01,ga02,g05', 'check last: all before checked')
    check(r.suggest_complete, 'last step: completion suggested (not completed)')
    eq(P:state(Q), 'accepted', 'not completed automatically')
    P:decide_step(Q, S('g02'))
    eq(done_list(P), 'g01', 'back to g02: later checks cleared')
    eq(P:current_step(Q).id, S('g02'), 'current is g02')
    eq(P:next_line(Q), D:step(S('g02')).next_line_ja, 'tracker line follows')
    -- ■ を外す：そこから後を外し、そこを今の手順に
    P:check_through(Q, S('g05'))
    P:uncheck_from(Q, S('ga01'))
    eq(done_list(P), 'g01,g02', 'uncheck ga01: ga01 and later cleared')
    eq(P:current_step(Q).id, S('ga01'), 'current goes to ga01')
    -- □ を押すと前にも付き、今の手順がチェック済みになれば次へ
    P:check_through(Q, S('ga01'))
    eq(done_list(P), 'g01,g02,ga01', 'check ga01')
    eq(P:current_step(Q).id, S('ga02'), 'current moves to the next unchecked step')
end

-- 完了とピン留め：最後の手順の勧めと、完了にしたらピンを外すのは今までどおり
do
    local P = new_p()
    P:pin(Q)
    P:set_route(Q, '初めて')
    P:decide_step(Q, S('g05'))
    check(P:is_pinned(Q), 'still pinned while in progress')
    local r = P:check_through(Q, S('g05'))
    check(r.suggest_complete, 'suggest')
    local c = P:set_state(Q, 'completed')
    check(c.unpinned and not P:is_pinned(Q), 'completed: unpinned')
    -- 完了のあと「今」を選んでも、状態もチェックも変えない（0.1.191〜）
    P:decide_step(Q, S('g02'))
    eq(P:state(Q), 'completed', 'state kept when choosing 今')
    eq(done_list(P), 'g01,g02,ga01,ga02,g05', 'completed: every check stays')
    eq(P:current_step(Q).id, S('g02'), 'completed: current is the chosen step')
end

-- 画面：■/□ はパッドの選択に入らない。行の決定（Enter）で前に付く。マウスの □ でも前に付く
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
app.open_detail(Q); frame(); frame()
local list = focus.windows.book.list
local has_chk, has_step = false, false
for _, it in ipairs(list) do
    if it.id:find('^chk_') then has_chk = true end
    if it.id == 'step_' .. S('g01') then has_step = true end
end
check(not has_chk, 'no ■/□ in pad selection')
check(has_step, 'step rows are selectable')
-- 上下は行から行へ
focus.set('book', 'step_' .. S('g01'))
app.input('down', true, 'pad'); app.input('down', false, 'pad'); frame()
-- 「相手」は手順の下の行（0.1.175〜：上下で移る）。その下が次の手順
eq(focus.current('book'), 'map_' .. S('g01'), 'down goes to the target under the step')
app.input('down', true, 'pad'); app.input('down', false, 'pad'); frame()
eq(focus.current('book'), 'step_' .. S('g02'), 'down goes to the next step row')
app.input('up', true, 'pad'); app.input('up', false, 'pad'); frame()
eq(focus.current('book'), 'map_' .. S('g01'), 'up goes back to the target')
app.input('down', true, 'pad'); app.input('down', false, 'pad'); frame()
app.input('right', true, 'pad'); app.input('right', false, 'pad'); frame()
check(not tostring(focus.current('book')):find('^chk_'), 'right does not land on ■/□')
-- 決定（キーボードの Enter・パッドの × と同じ）
focus.set('book', 'step_' .. S('g05'))
press(0x1C); frame(); frame()
local AP = app._progress()
-- 0.1.180〜（t290）：未受注では今の手順を選ぶだけ（前に付けない）。□ は押せない表示
eq(done_list(AP), '', 'not accepted: Enter does not check earlier steps')
eq(AP:current_step(Q).id, S('g05'), 'not accepted: Enter still picks the current step')
check(not AP:step_done(Q, S('g01')), 'not accepted: nothing checked')
app.request('set_state', Q, 'accepted'); frame()
focus.set('book', 'step_' .. S('g05'))
press(0x1C); frame(); frame()
eq(done_list(AP), 'g01,g02', 'decided g05 by Enter: shared steps before checked')
eq(AP:current_step(Q).id, S('g05'), 'Enter: g05 is current')
check(labeled('■##chk_' .. S('g01')) and labeled('□##chk_' .. S('ga01')), 'boxes drawn to match')
-- マウスで □ を押す：ga02 まで（ルート「初めて」を選んだことになる）
FAKE.clicks['##chk_' .. S('ga02')] = true; frame(); frame()
eq(done_list(AP), 'g01,g02,ga01,ga02', 'mouse check ga02: ga01 too, gb01 untouched')
-- マウスで ■ を外す：そこから後も外れる
FAKE.clicks['##chk_' .. S('g02')] = true; frame(); frame()
eq(done_list(AP), 'g01', 'mouse uncheck g02: later cleared')
eq(AP:current_step(Q).id, S('g02'), 'mouse uncheck: back at g02')
app.close_all(); frame()

-- 地図の「相手：」
local map_view = require('src.ui.map_view')
local choices = map_view.target_choices(D, D:quest(Q), nil)
check(#choices >= 2, 'several targets to pick: ' .. #choices)
local seen = {}
for _, c in ipairs(choices) do
    check(not seen[tostring(c.target)], 'targets are unique')
    seen[tostring(c.target)] = true
    check(c.kind ~= 'mob', 'no monsters')
    check(D:step(c.value) and D:step(c.value).location.zone_id, 'each choice has a place')
end
app.open_map(Q, choices[1].value); frame(); frame()
check(app.state.open.map, 'map open')
check(labeled('##map_target'), 'target dropdown shown')
check(texted('相手：') or labeled('相手：') or drawn('相手：'), 'target label')
check(texted(choices[1].label), 'current target shown')
-- マウスで選ぶ
FAKE.clicks['##c_' .. choices[2].value] = true; frame(); frame()
eq(app.state.map.step, choices[2].value, 'mouse: map switched to the other target')
-- パッドで選ぶ（決定で一覧、下、決定）
focus.set('map', 'map_target')
app.input('confirm', true, 'pad'); app.input('confirm', false, 'pad'); frame(); frame()
check(focus.dropdown('map') ~= nil, 'pad: dropdown opened')
app.input('up', true, 'pad'); app.input('up', false, 'pad'); frame()
app.input('confirm', true, 'pad'); app.input('confirm', false, 'pad'); frame(); frame()
eq(app.state.map.step, choices[1].value, 'pad: picked the first target')
app.close_all(); frame()
