-- 0.1.188（t310）：トラッカーの操作から出たあと、ゲームのボタン（決定・キャンセルなど）が効かなくなる不具合。
-- 入るのに使ったボタン（R1 など）の押下はゲームに届いていたのに、操作中はその「離した」を止めていたため、
-- ゲームは押しっぱなしと思ったままだった。どの出方（キャンセル・ショートカットをもう一度・窓を閉じる・
-- エリア移動・お知らせ）でも、ゲームが押していると思うボタンが残らず、ゲームのメニューの入力止めも外れることを確かめる。
require('fake_env')
local ffi = require('ffi')

-- VanaCore のゲームのメニュー（入力止め＝catch）の代わり
local G = { catches = {}, next_id = 0 }
_G.vana = { gameui = {
    watch = function () G.next_id = G.next_id + 1; return G.next_id end,
    unwatch = function () end,
    add = function () return true end,
    remove = function () return true end,
    catch = function (menu, event) G.next_id = G.next_id + 1; G.catches[G.next_id] = true; return G.next_id end,
    off = function (id) G.catches[id] = nil end,
}, game = { world = function () return { chat_open = false } end } }
local function ncatch() local n = 0 for _ in pairs(G.catches) do n = n + 1 end return n end

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local plat = require('src.platform.ashita')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
S.input.gamepad = true
S.gameui.capture = true
S.tracker.visible = true; S.tracker.collapsed = false
S.shortcut.tracker_operate = { 'r1', 'share' }
local QA, QB = 'quest.bastok.005', 'quest.sandoria.056'
app.request('pin', QA); app.request('pin', QB)
frame(); frame()

local BIT = { up = 0x0001, down = 0x0002, cross = 0x1000, circle = 0x2000, share = 0x0020, r1 = 0x0200, l1 = 0x0100 }
local ID = { up = 0, down = 1, cross = 12, circle = 13, share = 5, r1 = 9, l1 = 8 }
local cur = ffi.new('astertrail_xinput_state_t')
local MODE = 'after'
local last = 0
local game = {}   -- ゲームが押していると思っているボタン（止められなかった出入りから）
local function held_names() local t = {} for k in pairs(game) do t[#t + 1] = k end table.sort(t) return table.concat(t, ',') end
local mask = 0
local function send()
    cur.wButtons = mask; cur.bLeftTrigger = 0; cur.bRightTrigger = 0
    FAKE.events.xinput_state({ user = 0, size = ffi.sizeof(cur), state = ffi.cast('void*', cur), state_modified = ffi.cast('void*', cur) })
    local seen = (MODE == 'after') and tonumber(cur.wButtons) or mask
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
local function enter()
    press('r1'); press('share'); frame()
    check(app.state.active == 'tracker', MODE .. ': entered operate')
    eq(ncatch(), 1, MODE .. ': game menus caught while operating')
    lift('share'); lift('r1')
end
local function released(route)
    frame(); send(); frame()
    eq(mask, 0, route .. ': nothing held')
    check(app.state.active ~= 'tracker' and app.state.active ~= 'popup', route .. ': not operating')
    eq(held_names(), '', route .. ': game thinks nothing is held')
    eq(ncatch(), 0, route .. ': game menu catch released')
    check(not app.pad_block_all(), route .. ': pad not blocked')
    eq(plat._held_inputs(), 0, route .. ': no held inputs')
    -- 決定・キャンセルがゲームに届く
    for _, n in ipairs({ 'cross', 'circle' }) do
        press(n); check(game[n] == true, route .. ': ' .. n .. ' reaches the game')
        lift(n); check(game[n] == nil, route .. ': ' .. n .. ' release reaches the game')
    end
end

for _, mode in ipairs({ 'after', 'before' }) do
    MODE = mode; plat._reset_pad_source(); last = 0; mask = 0; game = {}
    app.release(); frame()
    -- 1) キャンセルで出る（件の段で ○）
    enter(); for _ = 1, 3 do if app.state.active == 'tracker' then tap('circle') end end; released(mode .. ' cancel')
    -- 2) ショートカットをもう一度
    enter(); press('r1'); press('share'); frame(); lift('share'); lift('r1'); released(mode .. ' shortcut again')
    -- 3) R1 を押したまま出る（ショートカットで入って、R1 を離さずにもう一度 SHARE）
    press('r1'); press('share'); frame(); lift('share')
    check(app.state.active == 'tracker', mode .. ': in with R1 still held')
    press('share'); frame(); lift('share'); lift('r1'); released(mode .. ' R1 held through')
    -- 4) 窓を閉じる（トラッカーを隠す）
    enter(); app.set_tracker_visible(false); frame(); released(mode .. ' window closed')
    app.set_tracker_visible(true); frame()
    -- 5) エリアが変わる
    enter(); FAKE.player.zone = (FAKE.player.zone == 230) and 231 or 230; frames(3); released(mode .. ' zone change')
    -- 6) お知らせ（操作中に出る → しない → トラッカーへ戻る → キャンセル）
    S.notify.popup = true
    enter()
    app.state.popups[#app.state.popups + 1] = { kind = 'accept', quest = 'quest.sandoria.001' }
    frames(2)
    eq(app.state.active, 'popup', mode .. ': popup takes the pad')
    tap('circle'); frames(2)
    eq(app.state.active, 'tracker', mode .. ': back to the tracker')
    -- 件の中にいれば、キャンセルで件の段へ、もう一度でゲームへ
    for _ = 1, 3 do if app.state.active == 'tracker' then tap('circle') end end
    released(mode .. ' popup')
    -- 7) お知らせの操作中に消える（お知らせを出さない設定に変わった）：操作の印も外す
    enter()
    app.state.popups[#app.state.popups + 1] = { kind = 'accept', quest = 'quest.sandoria.001' }
    frames(2)
    eq(app.state.active, 'popup', mode .. ': popup again')
    S.notify.popup = false; frames(3); S.notify.popup = true
    released(mode .. ' popup vanished')
    -- 8) ピンが全部外れた（トラッカーが消えた）：操作の印を残さない
    enter()
    app.request('unpin', QA); app.request('unpin', QB); frames(2)
    eq(app.state.active, nil, mode .. ': released when the tracker is gone')
    app.request('pin', QA); app.request('pin', QB); frames(2)
    check(not app.operating(), mode .. ': does not silently come back')
    released(mode .. ' pins gone')
end

-- 9) DirectInput のパッド（ボタンは 48＋n、R1 は 5、SHARE は 8、○ は 2、× は 1）
plat._reset_pad_source()
local dgame = {}
local function di(n, down)
    local e = { button = 48 + n, state = down and 0x80 or 0, blocked = false }
    local r = FAKE.events.dinput_button(e)
    if not (e.blocked or r == true) then dgame[n] = down or nil end
    frame()
end
local function dheld() local c = 0 for _ in pairs(dgame) do c = c + 1 end return c end
-- 入る（R1＋SHARE）→ 離す → ○ で出る
di(5, true); di(8, true); frame()
eq(app.state.active, 'tracker', 'dinput: entered')
di(8, false); di(5, false)
di(2, true); di(2, false); frame()
check(app.state.active ~= 'tracker', 'dinput: left with circle')
eq(dheld(), 0, 'dinput: game thinks nothing is held (R1 not stuck)')
eq(ncatch(), 0, 'dinput: catch released')
di(1, true); check(dgame[1] == true, 'dinput: cross reaches the game')
di(1, false); check(dgame[1] == nil, 'dinput: cross release reaches the game')
-- 十字キー（POV）：入る前から押していた上は、真ん中に戻ったのがゲームに届く
local function pov(st)
    local e = { button = 32, state = st, blocked = false }
    local r = FAKE.events.dinput_button(e)
    if not (e.blocked or r == true) then dgame.pov = (st ~= 0xFFFFFFFF) or nil end
    frame()
end
pov(0)
check(dgame.pov == true, 'dinput: up seen by the game')
di(5, true); di(8, true); frame()
eq(app.state.active, 'tracker', 'dinput: entered while holding up')
di(8, false); di(5, false)
pov(0xFFFFFFFF)
check(dgame.pov == nil, 'dinput: centre reaches the game while operating')
di(2, true); di(2, false); frame()
eq(dheld(), 0, 'dinput: nothing stuck at the end')

-- 10) ショートカットの「ゲームに渡さない」：R1 を先に押して（ゲームに届く）から SHARE で発動 → R1 の離したは届く
plat._reset_pad_source(); MODE = 'after'; last = 0; mask = 0; game = {}
S.shortcut.pass_to_game = false
app.release(); frame()
enter(); tap('circle'); released('no-pass')
S.shortcut.pass_to_game = true
