-- 0.1.68: トラッカーをパッドで操作する（十字キーで全部の件と、件の中の名前・地図の名前・ボタンを動く、×で決定、○でゲームへ）
-- 実機の VanaCore と同じように、xinput_button は xinput_state で書き換えたあとの値から作る（操作中は 0 になる）、
-- または書き換える前の値から作る（両方届く）の二通りで確かめる。
require('fake_env')
local ffi = require('ffi')
local focus = require('src.ui.focus')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local plat = require('src.platform.ashita')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local PR = app._progress()
local D = app._data()
S.input.gamepad = true
S.tracker.visible = true; S.tracker.collapsed = false
S.shortcut.tracker_operate = { 'share', 'options' }

local QM, QA, QB = 'mission.sandoria.001', 'quest.bastok.005', 'quest.sandoria.056'
for _, q in ipairs({ QA, QB, QM }) do app.request('pin', q) end
frame(); frame()

local BIT = { up = 0x0001, down = 0x0002, left = 0x0004, right = 0x0008, cross = 0x1000, circle = 0x2000,
    share = 0x0020, options = 0x0010, l1 = 0x0100, r1 = 0x0200, square = 0x4000 }
local ID = { up = 0, down = 1, left = 2, right = 3, cross = 12, circle = 13, l1 = 8, r1 = 9, share = 5, options = 4, square = 14 }
local cur = ffi.new('astertrail_xinput_state_t')
local MODE = 'after'      -- 'after'：書き換えたあとの値から xinput_button を作る ／ 'before'：書き換える前の値から
local game_seen = 0       -- ゲームに届いた（止められなかった）ボタンの押下の数
local last_buttons = 0
local function send(buttons)
    cur.wButtons = buttons; cur.bLeftTrigger = 0; cur.bRightTrigger = 0
    FAKE.events.xinput_state({ user = 0, size = ffi.sizeof(cur), state = ffi.cast('void*', cur), state_modified = ffi.cast('void*', cur) })
    local seen = (MODE == 'after') and tonumber(cur.wButtons) or buttons
    for name, b in pairs(BIT) do
        local was = math.floor(last_buttons / b) % 2 == 1
        local now = math.floor(seen / b) % 2 == 1
        if was ~= now then
            local e = { button = ID[name], state = now and 1 or 0, blocked = false }
            FAKE.events.xinput_button(e)
            if now and not e.blocked then game_seen = game_seen + 1 end
        end
    end
    last_buttons = seen
end
local function tap(...)
    local b = 0
    for _, n in ipairs({ ... }) do b = b + BIT[n] end
    send(b); frame(); send(0); frame()
end
local function fid() return focus.current('tracker') end

for _, mode in ipairs({ 'after', 'before' }) do
    MODE = mode
    plat._reset_pad_source()
    last_buttons = 0
    app.release(); frame()
    app.state.tracker_last = nil   -- 前の回で最後に選んだ件は覚えている。ここでは初めから
    -- 操作に入る（SHARE＋OPTIONS）
    tap('share', 'options')
    eq(app.state.active, 'tracker', mode .. ': operate entered')
    check(focus.shows_frame('tracker'), mode .. ': focus frame shown')
    -- 0.1.170〜：2段。1段目は件を選ぶ（上下）。操作に入ったら一番上の件
    eq(fid(), 'e_' .. QM, mode .. ': starts on the first entry')
    eq(app.state.tracker_level, 'entries', mode .. ': entries level')
    tap('down'); eq(fid(), 'e_' .. QA, mode .. ': down to the next entry')
    tap('down'); eq(fid(), 'e_' .. QB, mode .. ': down to the last entry')
    tap('down'); eq(fid(), 'e_' .. QB, mode .. ': stops at the last entry')
    tap('up'); tap('up'); eq(fid(), 'e_' .. QM, mode .. ': up returns to the top')
    -- 決定でその件の中へ。中では名前 → 地図の名前 → ボタン、ほかの件には出ない
    tap('down'); tap('cross')
    eq(fid(), 'q_' .. QA, mode .. ': confirm goes inside the entry')
    eq(app.state.tracker_level, 'inside', mode .. ': inside level')
    check(not app.state.open.detail, mode .. ': confirm on the entry does not open detail')
    local order = { fid() }
    for _ = 1, 8 do tap('down'); order[#order + 1] = fid() end
    local function pos(id) for i, v in ipairs(order) do if v == id then return i end end end
    check(pos('qn_' .. QA .. '_cur_npc_Nbu Latteh'), mode .. ': map name inside an entry is focused: ' .. table.concat(order, ','))
    check(pos('prev_' .. QA), mode .. ': ops row focused')
    for _, id in ipairs(order) do
        check(id:find(QA, 1, true) ~= nil, mode .. ': stays inside the entry: ' .. id)
    end
    -- キャンセルで件を選ぶところへ（ゲームには戻らない）
    tap('circle')
    eq(app.state.active, 'tracker', mode .. ': cancel inside keeps operating')
    eq(fid(), 'e_' .. QA, mode .. ': back on the entry')
    tap('down'); tap('cross')
    local order2 = { fid() }
    for _ = 1, 8 do tap('down'); order2[#order2 + 1] = fid() end
    local found = false
    for _, id in ipairs(order2) do if id == 'qn_' .. QB .. '_nx_npc_Excenmille' then found = true end end
    check(found, mode .. ': map name on the next line too: ' .. table.concat(order2, ','))
    tap('circle'); eq(fid(), 'e_' .. QB, mode .. ': back on QB')
    -- ボタンの行の左右
    focus.set('tracker', 'prev_' .. QB); frame()
    local row = { fid() }
    for _ = 1, 5 do tap('right'); row[#row + 1] = fid() end
    eq(table.concat(row, ','), table.concat({ 'prev_' .. QB, 'next_' .. QB, 'up_' .. QB, 'down_' .. QB, 'unpin_' .. QB, 'unpin_' .. QB }, ','),
        mode .. ': right walks the buttons')
    tap('left'); eq(fid(), 'down_' .. QB, mode .. ': left goes back')
    -- 押しっぱなし：くり返しで動く
    focus.set('tracker', 'e_' .. QM); frame()
    send(BIT.down); frame()
    local after_press = fid()
    check(after_press ~= 'e_' .. QM, mode .. ': press moves once')
    for _ = 1, 3 do frame(0.2) end
    check(fid() ~= after_press, mode .. ': held down repeats')
    send(0); frame()
    -- ▶（次の手順）・◀（前の手順）
    local s0 = PR:current_step(QB) and PR:current_step(QB).id
    focus.set('tracker', 'next_' .. QB); frame()
    tap('cross'); frame()
    check(PR:current_step(QB) and PR:current_step(QB).id ~= s0, mode .. ': ▶ advances the step')
    focus.set('tracker', 'prev_' .. QB); frame()
    tap('cross'); frame()
    eq(PR:current_step(QB) and PR:current_step(QB).id, s0, mode .. ': ◀ goes back')
    -- ▲（上へ）・▼（下へ）
    focus.set('tracker', 'up_' .. QB); frame()
    tap('cross'); frame()
    local pl = PR:pinned_list()
    check(pl[2] == QB, mode .. ': ▲ moves the quest up: ' .. table.concat(pl, ','))
    focus.set('tracker', 'down_' .. QB); frame()
    tap('cross'); frame()
    eq(PR:pinned_list()[3], QB, mode .. ': ▼ moves it down')
    -- 地図の名前：その名前の相手の場所で地図を開く
    focus.set('tracker', 'qn_' .. QB .. '_nx_npc_Excenmille'); frame()
    tap('cross'); frame()
    check(app.state.open.map and app.state.map and app.state.map.quest == QB, mode .. ': map name opens the map')
    local ms = app.state.map.step and D:step(app.state.map.step)
    local tg = ms and ms.target and D:target(ms.target)
    eq(tg and tg.name_en, 'Excenmille', mode .. ': map shows that target')
    tap('circle'); frame()
    eq(app.state.active, 'tracker', mode .. ': ○ on the map returns to the tracker')
    eq(app.state.open.map, true, mode .. ': ○ does not close the map (0.1.296)')
    app.close_window('map'); frame()
    -- 名前：詳細
    focus.set('tracker', 'q_' .. QA); frame()
    tap('cross'); frame()
    check(app.state.open.detail and app.state.detail_quest == QA, mode .. ': name opens detail')
    tap('circle'); frame()
    eq(app.state.active, 'tracker', mode .. ': back to tracker after detail')
    -- ピン外し
    focus.set('tracker', 'unpin_' .. QA); frame()
    tap('cross'); frame()
    check(not PR:is_pinned(QA), mode .. ': unpin works')
    app.request('pin', QA); frame(); frame()
    app.request('move_pin', QA, -1); frame(); frame()
    eq(table.concat(PR:pinned_list(), ','), table.concat({ QM, QA, QB }, ','), mode .. ': order restored')
    -- ○：ゲームに戻す。押した ○ も離した ○ もゲームには届かない
    -- ピンを外した件の中にいたら、件を選ぶところへ戻っている
    eq(app.state.tracker_level, 'entries', mode .. ': after unpin, back on the entries')
    focus.set('tracker', 'q_' .. QA); frame()
    local seen0 = game_seen
    tap('circle'); frame()
    eq(app.state.active, 'tracker', mode .. ': first ○ goes back to the entries')
    tap('circle'); frame()
    check(app.state.active ~= 'tracker', mode .. ': ○ returns control to the game')
    eq(game_seen, seen0, mode .. ': the ○ itself did not reach the game')
    -- 操作していないときは、十字キーはゲームへ
    tap('down')
    eq(game_seen, seen0 + 1, mode .. ': D-pad reaches the game when not operating')
end

-- DirectInput のパッド：十字キーは POV（位置 32、角度×100）、× は 48+1、○ は 48+2
plat._reset_pad_source()
app.release(); frame()
app.activate('tracker'); frame()
focus.set('tracker', 'q_' .. QM); frame()
local function di(off, st) local e = { button = off, state = st, blocked = false }; FAKE.events.dinput_button(e); return e.blocked end
check(di(32, 18000), 'dinput: POV down taken'); frame(); di(32, 0xFFFFFFFF); frame()
check(fid() ~= 'q_' .. QM, 'dinput: POV down moves')
eq(plat.pad_source(), 'dinput', 'dinput source')
di(32, 0); frame(); di(32, -1); frame()
eq(fid(), 'q_' .. QM, 'dinput: POV up moves back')
local p = plat._pov_held(4500); check(p.up and p.right, 'POV diagonal')
eq(next(plat._pov_held(65535)), nil, 'POV centered (65535)')
eq(next(plat._pov_held(-1)), nil, 'POV centered (-1)')
check(di(48 + 2, 0x80), 'dinput: ○ taken'); di(48 + 2, 0); frame()
eq(fid(), 'e_' .. QM, 'dinput: ○ goes back to the entries')
di(48 + 2, 0x80); di(48 + 2, 0); frame()
check(app.state.active ~= 'tracker', 'dinput: ○ returns to the game')

-- 右そろえ・左そろえのどちらでも、ボタンの並びは同じ
for _, al in ipairs({ 'right', 'left' }) do
    S.tracker.align = al
    plat._reset_pad_source(); last_buttons = 0; MODE = 'after'
    app.activate('tracker'); frame(); frame()
    focus.set('tracker', 'prev_' .. QM); frame()
    tap('right'); eq(fid(), 'next_' .. QM, al .. ': ◀ → ▶')
    tap('right'); tap('right'); tap('right'); eq(fid(), 'unpin_' .. QM, al .. ': to the pin')
    tap('down'); eq(fid(), 'unpin_' .. QM, al .. ': down from the buttons stays inside the entry (0.1.170)')
    tap('circle'); eq(fid(), 'e_' .. QM, al .. ': cancel to the entry')
    tap('circle'); frame()
end
FAKE.events.unload()
check(not printed('present:'), 'no present errors')
io.write('test_tracker_dpad done\n')
