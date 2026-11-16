-- 0.1.59: VanaCore の説明書 09-input に合わせたパッドの読み取り
--   ・R1（組み合わせに入っているボタン）のタブ切り替えは離したときに。組み合わせが発動したら切り替えない
--   ・xinput_button の 16・17（LT・RT、0〜255）
--   ・止めるときは true を返す（e.blocked も立てる）
--   ・state_modified が無いときは state を書き換える
--   ・DirectInput のパッド（dinput_button、ボタンは 48＋n）
require('fake_env')
local ffi = require('ffi')
local sc = require('src.core.shortcut')

-- 番号
eq(sc.key_of_button_id(16), 'l2', '16 = LT (L2)')
eq(sc.key_of_button_id(17), 'r2', '17 = RT (R2)')
check(sc.button_down(16, 200) and not sc.button_down(16, 10), 'trigger threshold')
check(sc.button_down(9, 1) and not sc.button_down(9, 0), 'button 0/1')
eq(sc.key_of_dinput(48 + 3), 'triangle', 'dinput 3 = △')
eq(sc.key_of_dinput(48 + 5), 'r1', 'dinput 5 = R1')
eq(sc.key_of_dinput(48 + 0), 'square', 'dinput 0 = □')
eq(sc.key_of_dinput(32), nil, 'POV is not a button')
check(sc.dinput_down(0x80) and not sc.dinput_down(0), 'dinput 0x80 down')
check(sc.in_combo({ 'r1', 'triangle' }, 'r1'), 'r1 in combo')
check(not sc.in_combo({ 'r1', 'triangle' }, 'l1'), 'l1 not in combo')
check(not sc.in_combo({ 'r1' }, 'r1'), 'single-button combo: no deferring')
local d = sc.new()
d:update({ r1 = true, triangle = true }, { 'r1', 'triangle' }, true)
eq(d.fires, 1, 'fire counter')

dofile(ROOT .. '/astertrail.lua')
check(FAKE.events.dinput_button, 'dinput_button registered')
FAKE.events.load()
local app = require('src.app')
local platform = require('src.platform.ashita')
local sui = require('src.ui.settings_ui')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
S.shortcut.open_book = { 'r1', 'triangle' }   -- 0.1.67 から初期値は なし。R1＋△ を決めたものとして
S.input.gamepad = true

local cur = ffi.new('astertrail_xinput_state_t')
local mod = ffi.new('astertrail_xinput_state_t')
local function xs(buttons, lt, rt, no_mod)
    cur.wButtons = buttons; cur.bLeftTrigger = lt or 0; cur.bRightTrigger = rt or 0
    mod.wButtons = buttons; mod.bLeftTrigger = lt or 0; mod.bRightTrigger = rt or 0
    FAKE.events.xinput_state({ user = 0, size = ffi.sizeof(cur), state = ffi.cast('void*', cur),
        state_modified = (not no_mod) and ffi.cast('void*', mod) or nil })
end
local function xb(b, st)
    local e = { button = b, state = st, blocked = false }
    local r = FAKE.events.xinput_button(e)
    return e.blocked, r
end
local R1, TRI = 0x0200, 0x8000

-- 1) R1 だけ：押したときは切り替えず、離したときに次のタブへ
app.close_all(); frame()
app.open_window('settings'); frame(); frame()
sui.select_tab('marks'); frame(); frame()
local before = sui.current_tab()
xs(R1); local blk, ret = xb(9, 1); frame()
check(blk and ret == true, 'R1 press taken from the game (true returned)')
eq(sui.current_tab(), before, 'R1 press: tab not switched yet')
xs(0); xb(9, 0); frame(); frame()
check(sui.current_tab() ~= before, 'R1 release: tab switched once')
local after_one = sui.current_tab()
frame(); frame()
eq(sui.current_tab(), after_one, 'switched only once')

-- 2) R1＋△：ショートカットだけ。タブは切り替えない
sui.select_tab('marks'); frame(); frame()
xs(R1); xb(9, 1); frame()
xs(R1 + TRI); xb(15, 1); frame(); frame()
check(not app.state.open.settings, 'R1+△ closes the menus')
xs(R1); xb(15, 0); xs(0); xb(9, 0); frame(); frame()
app.open_window('settings'); frame(); frame()
sui.select_tab('marks'); frame(); frame()
eq(sui.current_tab(), 'marks', 'no tab switch after the combo')
-- 本が閉じているとき、R1 はゲームへ（止めない）
app.close_all(); frame()
xs(R1); blk = xb(9, 1); frame()
eq(blk, false, 'book closed: R1 reaches the game')
xs(0); xb(9, 0); frame()

-- 3) 組み合わせに入っていないボタン（L1）は、押したときにすぐ動く
app.open_window('settings'); frame(); frame()
sui.select_tab('marks'); frame(); frame()
xs(0x0100); xb(8, 1); frame()
check(sui.current_tab() ~= 'marks', 'L1 still switches on press')
xs(0); xb(8, 0); frame()
app.close_all(); frame()

-- 4) state_modified が無いときは state を書き換える（ゲームに渡さない）
S.shortcut.pass_to_game = false
xs(R1 + TRI, 0, 0, true); frame()
check(app.state.open.book, 'fires without state_modified')
eq(tonumber(cur.wButtons), 0, 'combo stripped from state')
xs(0, 0, 0, true); frame()
S.shortcut.pass_to_game = true
app.close_all(); frame()

-- 5) xinput_button だけの環境：L2（16、0〜255）
platform._reset_pad_source()
S.shortcut.open_book = { 'l2', 'triangle' }
xb(16, 10); xb(15, 1); frame()
check(not app.state.open.book, 'L2 under threshold: not held')
xb(16, 200); frame()
check(app.state.open.book, 'L2 (trigger 16) + △ fires')
eq(platform.pad_source(), 'button', 'button source')
xb(16, 0); xb(15, 0); frame()
app.close_all(); frame()
S.shortcut.open_book = { 'r1', 'triangle' }

-- 6) DirectInput のパッド
platform._reset_pad_source()
local function di(n, down)
    local e = { button = 48 + n, state = down and 0x80 or 0, blocked = false }
    local r = FAKE.events.dinput_button(e)
    return e.blocked, r
end
di(5, true); frame()
check(not app.state.open.book, 'dinput R1 alone: nothing')
di(3, true); frame()
check(app.state.open.book, 'dinput R1+△ opens the book')
eq(platform.pad_source(), 'dinput', 'dinput source')
di(3, false); di(5, false); frame()
app.close_all(); frame()
-- ゲームに渡さない
S.shortcut.pass_to_game = false
di(5, true); di(3, true); frame()
check(app.state.open.book, 'dinput fires again')
local b2, r2 = di(3, true)
check(b2 and r2 == true, 'dinput combo kept from the game')
di(3, false); di(5, false); frame()
S.shortcut.pass_to_game = true
app.close_all(); frame()
app.open_window('settings'); frame()
sui.select_tab('input'); frame(); frame()
local function seen(p) for _, l in ipairs(FAKE.labels) do if l:find(p, 1, true) then return true end end return texted and texted(p) end
check(seen('DirectInput（dinput_button'), 'source shown as DirectInput')
app.close_all(); frame()
-- XInput が届いたら DirectInput は数えない（二重にしない）
platform._reset_pad_source()
xs(0); frame()
eq(platform.pad_source(), 'state', 'xinput state seen')
di(5, true); di(3, true); frame()
check(not app.state.open.book, 'dinput ignored while XInput is read')
di(3, false); di(5, false); frame()
platform._reset_pad_source()

-- 7) ボタン待ちの間は true を返す
app.open_window('settings'); frame()
sui.select_tab('input'); frame(); frame()
FAKE.clicks['##sc_open'] = true; frame(); frame()
check(app.pad_capturing(), 'waiting')
local b3, r3 = xb(12, 1)
check(b3 and r3 == true, 'capture: true returned')
xb(12, 0)
app.shortcut_capture_cancel()
app.close_all(); frame()
