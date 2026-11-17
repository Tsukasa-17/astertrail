-- 0.1.197：お知らせが出ているあいだ、パッドでピンのボタンを選べる。
-- 閉じたあと（決定・キャンセル・時間切れ）は入力を全部離し、ゲームのボタンが押しっぱなしにならない（0.1.188 と同じ）。
require('fake_env')
local ffi = require('ffi')
local focus = require('src.ui.focus')

local G = { catches = {}, next_id = 0 }
_G.vana = { gameui = {
    watch = function () G.next_id = G.next_id + 1; return G.next_id end,
    unwatch = function () end,
    add = function () return true end,
    remove = function () return true end,
    catch = function () G.next_id = G.next_id + 1; G.catches[G.next_id] = true; return G.next_id end,
    off = function (id) G.catches[id] = nil end,
}, game = { world = function () return { chat_open = false } end } }
local function ncatch() local n = 0 for _ in pairs(G.catches) do n = n + 1 end return n end

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local plat = require('src.platform.ashita')
FAKE.player = { name = 'PopupPad', zone = 230, tidx = 5, status = 0 }
frames(1)
check(app.state.ready, 'logged in')
local S = app._settings()
local PR = app._progress()
S.input.gamepad = true
S.gameui.capture = true
S.notify.popup = true
S.notify.sound = false
S.reduce_motion = true

local Q1, Q2, Q3 = 'quest.sandoria.001', 'quest.sandoria.002', 'quest.bastok.005'
local BIT = { up = 0x0001, down = 0x0002, left = 0x0004, right = 0x0008, cross = 0x1000, circle = 0x2000, share = 0x0020, r1 = 0x0200 }
local ID = { up = 0, down = 1, left = 2, right = 3, cross = 12, circle = 13, share = 5, r1 = 9 }
local cur = ffi.new('astertrail_xinput_state_t')
local last, mask = 0, 0
local game = {}
local function held_names() local t = {} for k in pairs(game) do t[#t + 1] = k end table.sort(t) return table.concat(t, ',') end
local function send()
    cur.wButtons = mask
    cur.bLeftTrigger = 0; cur.bRightTrigger = 0
    FAKE.events.xinput_state({ user = 0, size = ffi.sizeof(cur), state = ffi.cast('void*', cur), state_modified = ffi.cast('void*', cur) })
    local seen = tonumber(cur.wButtons)
    for name, b in pairs(BIT) do
        local was = math.floor(last / b) % 2 == 1
        local now = math.floor(seen / b) % 2 == 1
        if was ~= now then
            local e = { button = ID[name], state = now and 1 or 0, blocked = false }
            local r = FAKE.events.xinput_button(e)
            if not (e.blocked or r == true) then game[name] = now or nil end
        end
    end
    last = seen
end
local function press(n) mask = mask + BIT[n]; send(); frame() end
local function lift(n) mask = mask - BIT[n]; send(); frame() end
local function tap(n) press(n); lift(n) end
local function stick(lx, ly)
    cur.sThumbLX = lx or 0; cur.sThumbLY = ly or 0
    send(); frame()
end
local function released(route)
    frame(); send(); frame()
    eq(mask, 0, route .. ': nothing held')
    check(not app.popup_visible(), route .. ': popup gone')
    check(app.state.active ~= 'popup', route .. ': not operating popup')
    eq(held_names(), '', route .. ': game thinks nothing is held')
    eq(ncatch(), 0, route .. ': game menu catch released')
    check(not app.pad_block_all(), route .. ': pad not blocked')
    eq(plat._held_inputs(), 0, route .. ': no held inputs')
    for _, n in ipairs({ 'cross', 'circle' }) do
        press(n); check(game[n] == true, route .. ': ' .. n .. ' reaches the game')
        lift(n); check(game[n] == nil, route .. ': ' .. n .. ' release reaches the game')
    end
end

-- 遊んでいるときに出る：キーは奪わず、パッドは使う
app.release(); plat._reset_pad_source(); last = 0; mask = 0; game = {}
app.popup_push('accept', Q1); frames(0.2)
eq(app.state.active, nil, 'playing: keys not taken')
check(not app.want_keys(), 'playing: want_keys off')
check(app.popup_visible(), 'popup visible')
check(app.want_pad(), 'playing: want_pad on')
check(app.pad_block_all(), 'playing: pad blocked for the popup')
eq(focus.current('popup'), 'pin_yes', 'starts on pin yes')
check(not PR:is_pinned(Q1), 'not pinned yet')

-- 十字キーでピン留めする／しない
tap('right')
eq(focus.current('popup'), 'pin_no', 'dpad right to pin no')
tap('left')
eq(focus.current('popup'), 'pin_yes', 'dpad left to pin yes')

-- 0.1.226〜：左スティックでは動かない（十字キーだけ）
eq(focus.current('popup'), 'pin_yes', 'still on pin yes before stick')
stick(25000, 0)
eq(focus.current('popup'), 'pin_yes', 'stick right does not move')
stick(-25000, 0)
eq(focus.current('popup'), 'pin_yes', 'stick left does not move')
stick(0, -25000)
eq(focus.current('popup'), 'pin_yes', 'stick down does not move')
stick(0, 0)

-- 決定で「ピン留めする」
tap('cross')
frames(0.2)
check(PR:is_pinned(Q1), 'confirm pins')
released('confirm pin')

-- キャンセルは「しない」と同じ。ピンは留めない
plat._reset_pad_source(); last = 0; mask = 0; game = {}
app.popup_push('accept', Q2); frames(0.2)
eq(focus.current('popup'), 'pin_yes', 'next popup starts on yes')
check(not PR:is_pinned(Q2), 'q2 not pinned')
tap('circle')
frames(0.2)
check(not PR:is_pinned(Q2), 'cancel does not pin')
released('cancel')

-- 時間切れでも入力を離す
plat._reset_pad_source(); last = 0; mask = 0; game = {}
S.notify.popup_seconds = 3
app.popup_push('accept', Q3); frames(0.2)
check(app.popup_visible(), 'timeout: shown')
check(app.pad_block_all(), 'timeout: pad blocked while shown')
frames(3.2)
check(not app.popup_visible(), 'timeout: faded away')
check(not PR:is_pinned(Q3), 'timeout does not pin')
released('timeout')
S.notify.popup_seconds = 8

-- お知らせが出る前から押していた決定は、離したのがゲームに届く（飲み込まれない）
plat._reset_pad_source(); last = 0; mask = 0; game = {}
press('cross')
check(game.cross == true, 'pre-popup: game saw confirm down')
app.popup_push('accept', 'quest.windurst.001'); frames(0.2)
check(app.pad_block_all(), 'held confirm: popup blocks pad')
lift('cross')
check(game.cross == nil, 'held confirm: release still reaches the game')
eq(held_names(), '', 'held confirm: game not stuck')
-- 残ったお知らせはキャンセルで閉じ、そのあともゲームのボタンが効く
tap('circle'); frames(0.2)
released('held confirm then cancel')

-- パッド操作オフのときは、遊んでいるときのお知らせにパッドを使わない
S.input.gamepad = false
plat._reset_pad_source(); last = 0; mask = 0; game = {}
app.popup_push('accept', 'quest.jeuno.001'); frames(0.2)
check(app.popup_visible(), 'pad off: popup still shown')
check(not app.want_pad(), 'pad off: want_pad false')
check(not app.pad_block_all(), 'pad off: not blocked')
press('cross'); check(game.cross == true, 'pad off: confirm reaches the game')
lift('cross'); check(game.cross == nil, 'pad off: confirm release reaches the game')
app.popup_choose(false); frames(0.2)
S.input.gamepad = true
released('pad setting off')
