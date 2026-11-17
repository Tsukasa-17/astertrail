-- 0.1.61: トラッカーのショートカット（表示／非表示・操作）、パッドでの操作、表示の並び（ミッションが上）、◀▶▲▼ピン外し
require('fake_env')
local ffi = require('ffi')
local sc = require('src.core.shortcut')
local settings = require('src.core.settings')

-- 初期値：トラッカーの二つは未設定（オフ）。本を開くも 0.1.67 から なし
local m = settings.merge({})
eq(#m.shortcut.tracker_toggle, 0, 'tracker toggle off by default')
eq(#m.shortcut.tracker_operate, 0, 'tracker operate off by default')
eq(#m.shortcut.open_book, 0, 'book default none (0.1.67)')
m = settings.merge({ shortcut = { tracker_toggle = { 'share', 'l1', 'bogus' } } })
eq(sc.label(m.shortcut.tracker_toggle), 'L1＋SHARE', 'tracker toggle normalized')
local json = require('src.lib.json')
check(json.encode(settings.merge({})):find('"tracker_operate":%s*%[%s*%]') ~= nil, 'empty saved as array')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local PR = app._progress()

local cur = ffi.new('astertrail_xinput_state_t')
local mod = ffi.new('astertrail_xinput_state_t')
local function xs(buttons, lt, rt)
    cur.wButtons = buttons; cur.bLeftTrigger = lt or 0; cur.bRightTrigger = rt or 0
    mod.wButtons = buttons; mod.bLeftTrigger = lt or 0; mod.bRightTrigger = rt or 0
    cur.sThumbLX = 1200; mod.sThumbLX = 1200
    FAKE.events.xinput_state({ user = 0, size = ffi.sizeof(cur), state = ffi.cast('void*', cur), state_modified = ffi.cast('void*', mod) })
end
local CROSS, SHARE, OPTIONS, L3, R3 = 0x1000, 0x0020, 0x0010, 0x0040, 0x0080
local function tap(b) xs(b); frame(); xs(0); frame() end
-- 実機と同じに：xinput_state（毎回の読み取り）と xinput_button（ボタンの出入り）の両方を送る（0.1.68〜）
local XBIT = { [0] = 0x0001, [1] = 0x0002, [2] = 0x0004, [3] = 0x0008, [12] = 0x1000, [13] = 0x2000, [8] = 0x0100, [9] = 0x0200 }
local function btn(id) xs(XBIT[id]); pad(id, 1); frame(); xs(0); pad(id, 0); frame() end
local function label_index(pat)
    for i, l in ipairs(FAKE.labels) do if l:find(pat, 1, true) then return i end end
    return nil
end

local QM = 'mission.sandoria.001'
local QA = 'quest.bastok.005'
local QB = 'quest.sandoria.056'
app.close_all()
S.tracker.visible = true
S.tracker.collapsed = false
app.request('pin', QA)
app.request('pin', QB)
app.request('pin', QM)
frame(); frame()

-- ミッションはいつも一番上
local list = PR:pinned_list()
eq(list[1], QM, 'mission first even when pinned last')
eq(list[2], QA, 'quests keep pin order')
check(drawn('astertrail_tracker'), 'tracker drawn')
local im, ia = label_index('##q_' .. QM), label_index('##q_' .. QA)
check(im and ia and im < ia, 'mission drawn above quests')
-- 0.1.63〜：通し番号は無し、ミッション番号は名前の前に。アイコンは状態に合わせる
check(not labeled('1. ') and not labeled('2. '), 'no serial numbers (0.1.63)')
local DD = app._data()
local qm = DD:quest(QM)
check(qm.mission_no and labeled(qm.mission_no .. ' '), 'mission number before the name')
local tr = require('src.ui.tracker')
check(tr.mission_icon({ data = DD, progress = PR }, qm) ~= nil, 'mission has an icon')
eq(tr.head_text(qm):sub(1, #qm.mission_no + 1), qm.mission_no .. ' ', 'head text starts with the number')
-- ▲▼：ミッションとクエストのあいだは入れ替えない
check(not PR:can_move_pin(QA, -1), 'quest cannot move above mission')
eq(app.request('move_pin', QA, -1).code, 'edge', 'move across groups refused')
eq(PR:pinned_list()[1], QM, 'mission still first')
FAKE.clicks['##down_' .. QA] = true; frame(); frame()
eq(PR:pinned_list()[3], QA, '▼ swaps within quests')
FAKE.clicks['##up_' .. QA] = true; frame(); frame()
eq(PR:pinned_list()[2], QA, '▲ swaps back')
-- 表示の並び：今の手順・次：・◀▶▲▼・ピン外し。古い「チェック」「場所」の行は出さない
check(labeled('##prev_' .. QM) and labeled('##next_' .. QM) and labeled('##up_' .. QM) and labeled('##down_' .. QM)
    and labeled('##unpin_' .. QM), 'ops row')
check(not labeled('##chk_'), 'old check button removed')
check(texted('次：') or labeled('次：') or drawn('次：'), 'next line shown')

-- 必要品まとめのボタンは 0.1.173 でなくした（たたんでも開いても出さない）
check(not labeled('##items'), 'no items button (0.1.173)')
S.tracker.collapsed = true; frame(); frame()
check(not labeled('##items'), 'no items button when collapsed')
check(labeled('##q_' .. QM), 'names still shown when collapsed')
check(not labeled('##prev_' .. QM), 'ops hidden when collapsed')
S.tracker.collapsed = false; frame(); frame()

-- ◀▶：決定と同じルール（進むと前にチェック、戻ると後のチェックを外す）
local function sid(q, g) return q .. '#' .. g end
eq(PR:current_step(QM).id, sid(QM, 'g01'), 'starts at g01')
check(PR:step_nav(QM).prev == nil, 'no prev at first step')
FAKE.clicks['##next_' .. QM] = true; frame(); frame()
eq(PR:current_step(QM).id, sid(QM, 'g02'), '▶ moves to g02')
check(PR:step_done(QM, sid(QM, 'g01')), '▶ checks the step before')
FAKE.clicks['##next_' .. QM] = true; frame(); frame()
eq(PR:current_step(QM).id, sid(QM, 'g03'), '▶ moves to g03')
check(PR:step_done(QM, sid(QM, 'g02')), 'g02 checked')
FAKE.clicks['##next_' .. QM] = true; frame(); frame()
check(PR:step_done(QM, sid(QM, 'g03')), '▶ on last step checks it')
eq(app.state.suggest_complete, QM, 'suggests completion')
check(PR:state(QM) ~= 'completed', 'never completes automatically')
check(PR:is_pinned(QM), 'still pinned')
FAKE.clicks['##prev_' .. QM] = true; frame(); frame()
eq(PR:current_step(QM).id, sid(QM, 'g03'), '◀ after all done returns to last step')
check(not PR:step_done(QM, sid(QM, 'g03')), 'last step unchecked')
FAKE.clicks['##prev_' .. QM] = true; frame(); frame()
eq(PR:current_step(QM).id, sid(QM, 'g02'), '◀ moves to g02')
check(not PR:step_done(QM, sid(QM, 'g02')), '◀ unchecks from there')
check(PR:step_done(QM, sid(QM, 'g01')), 'steps before stay checked')
check(not app.state.flash or not tostring(app.state.flash.text):find('たどれ'), 'no not-reachable notice on ◀')

-- 分岐：ルート未定なら ▶ で選ぶ行。ルートを選んでいればそのルートへ
app.request('set_current_step', QB, sid(QB, 'g02'))
frame()
FAKE.clicks['##next_' .. QB] = true; frame(); frame()
eq(PR:current_step(QB).id, sid(QB, 'g02'), 'branch: stays until chosen')
check(labeled('##br_' .. sid(QB, 'ga01')) and labeled('##br_' .. sid(QB, 'gb01')), 'branch options shown')
FAKE.clicks['##br_' .. sid(QB, 'gb01')] = true; frame(); frame()
eq(PR:current_step(QB).id, sid(QB, 'gb01'), 'picked branch')
FAKE.clicks['##prev_' .. QB] = true; frame(); frame()
eq(PR:current_step(QB).id, sid(QB, 'g02'), '◀ from route step back to shared step')
PR:set_route(QB, '初めて')
FAKE.clicks['##next_' .. QB] = true; frame(); frame()
eq(PR:current_step(QB).id, sid(QB, 'ga01'), 'route chosen: ▶ follows route')

-- ショートカット：同じ組み合わせは入れない
S.shortcut.tracker_operate = json.array({ 'share', 'options' })
check(not app.shortcut_set('tracker_toggle', { 'options', 'share' }), 'duplicate refused')
eq(#S.shortcut.tracker_toggle, 0, 'duplicate not saved')
check(app.state.flash and app.state.flash.text:find('トラッカーを操作する', 1, true), 'duplicate notice names the other shortcut')
S.shortcut.open_book = json.array({ 'r1', 'triangle' })
check(not app.shortcut_set('tracker_toggle', { 'r1', 'triangle' }), 'book combo refused too')
-- ボタン待ちでも同じ
app.shortcut_capture_start('tracker_toggle')
check(app.pad_capturing(), 'capturing tracker toggle')
xs(0); frame()
xs(SHARE + OPTIONS); frame(); xs(0); frame()
check(not app.pad_capturing(), 'capture ended')
eq(#S.shortcut.tracker_toggle, 0, 'captured duplicate not saved')
app.shortcut_capture_start('tracker_toggle')
xs(0); frame()
xs(L3 + R3); frame(); xs(0); frame()
eq(sc.label(S.shortcut.tracker_toggle), 'L3＋R3', 'captured new combo')

-- 表示／非表示
app.close_all(); frame()
tap(L3 + R3)
check(not S.tracker.visible, 'toggle hides tracker')
check(not drawn('astertrail_tracker'), 'tracker not drawn')
tap(L3 + R3)
check(S.tracker.visible, 'toggle shows tracker')

-- 操作：隠れていても出して操作に入る。もう一度押すとゲームに戻す
S.tracker.visible = false
app.open_window('book'); frame()
tap(SHARE + OPTIONS)
eq(app.state.active, 'tracker', 'operate shortcut enters tracker')
check(S.tracker.visible, 'shown when hidden')
check(not app.state.open.book, 'book closed so nothing conflicts')
-- 操作中はパッドの入力をゲームに渡さない（ボタン・スティックとも）
xs(0x4000); frame()   -- □（画面の操作に使わないボタン）
eq(tonumber(mod.wButtons), 0, 'buttons kept from the game while operating')
eq(tonumber(mod.sThumbLX), 0, 'sticks kept from the game while operating')
check(pad(1, 1), 'xinput_button blocked while operating'); pad(1, 0)
xs(0); frame()
-- 選択枠（上下で動く）
check(require('src.ui.focus').shows_frame('tracker'), 'focus frame while operating')
check(require('src.ui.focus').current('tracker') ~= nil, 'something focused')
check(not texted('パッドで操作中') and not texted('with the pad'), 'no tracker pad help line (0.1.226)')
tap(SHARE + OPTIONS)
check(app.state.active ~= 'tracker', 'pressing again returns to the game')
check(not require('src.ui.focus').shows_frame('tracker'), 'no frame when not operating')
xs(CROSS); frame()
eq(tonumber(mod.wButtons), CROSS, 'game gets buttons again')
xs(0); frame()
-- キャンセル（B／○）でもゲームに戻す
tap(SHARE + OPTIONS)
eq(app.state.active, 'tracker', 'entered again')
btn(13)
check(app.state.active ~= 'tracker', 'cancel returns to the game')
-- 名前の決定で詳細。閉じるとトラッカーの操作に戻る
tap(SHARE + OPTIONS)
require('src.ui.focus').set('tracker', 'q_' .. QM, false); frame()
btn(12); frame()
check(app.state.open.detail, 'confirm on name opens detail')
eq(app.state.detail_quest, QM, 'detail of mission')
btn(13); frame()
check(not app.state.open.detail, 'detail closed')
eq(app.state.active, 'tracker', 'back to tracker operation')
-- 0.1.170〜：件の中からのキャンセルは、まず件を選ぶところへ。もう一度でゲームへ
btn(13)
eq(app.state.active, 'tracker', 'cancel inside an entry goes back to the entries')
eq(require('src.ui.focus').current('tracker'), 'e_' .. QM, 'the entry is selected')
btn(13)
check(app.state.active ~= 'tracker', 'cancel again returns to the game')
-- ピンが無ければ操作に入らない
for _, q in ipairs(PR:pinned_list()) do app.request('unpin', q) end
frame()
tap(SHARE + OPTIONS)
check(app.state.active ~= 'tracker', 'no pins: not entered')

-- 設定：ショートカットは「操作」タブ。「ショートカット設定」タブは無い
local sui = require('src.ui.settings_ui')
app.open_window('settings'); frame()
sui.select_tab('input'); frame(); frame()
check(labeled('本を開く：R1＋△'), 'book shortcut in input tab')
check(labeled('トラッカーの表示／非表示：L3＋R3'), 'tracker toggle in input tab')
check(labeled('トラッカーを操作する：OPTIONS＋SHARE') or labeled('トラッカーを操作する：SHARE＋OPTIONS'), 'tracker operate in input tab')
check(not labeled('ショートカット設定'), 'no separate shortcut tab')
FAKE.clicks['##sc_to_reset'] = true; frame(); frame()
eq(#S.shortcut.tracker_operate, 0, 'reset tracker operate')
app.close_all(); frame()
