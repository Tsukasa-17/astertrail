-- 0.1.57: パッドのショートカット（本を開く・自前のメニューを閉じる）と、版の番号がそろっていること
require('fake_env')
local ffi = require('ffi')
local sc = require('src.core.shortcut')

-- 名前と表記（PS 表記）
eq(sc.label(sc.DEFAULT), nil, 'default is none (0.1.67)')
eq(sc.label(sc.OLD_DEFAULT), 'R1＋△', 'old default label')
eq(sc.label({ 'triangle', 'r1', 'r1' }), 'R1＋△', 'sorted, unique')
eq(sc.label({}), nil, 'empty label')
eq(sc.label({ 'l1', 'l2', 'cross', 'circle', 'square', 'up' }), 'L1＋L2＋○＋×＋□＋↑', 'order')
eq(sc.key_of_button_id(9), 'r1', 'button 9 = R1')
eq(sc.key_of_button_id(15), 'triangle', 'button 15 = △')
eq(sc.key_of_button_id(12), 'cross', 'button 12 = ×')
eq(sc.key_of_button_id(13), 'circle', 'button 13 = ○')
eq(sc.key_of_button_id(10), nil, 'unused bit')
local h = sc.held_from_state(0x0200 + 0x8000, 0, 200)
check(h.r1 and h.triangle and h.r2 and not h.l2 and not h.cross, 'held from state')
check(sc.same({ 'triangle', 'r1' }, { 'r1', 'triangle' }), 'same')

-- 判定：そろった時に1回だけ
local d = sc.new()
local C = { 'r1', 'triangle' }
check(not d:update({ r1 = true }, C, true).fire, 'R1 alone: no fire')
check(d:update({ r1 = true, triangle = true }, C, true).fire, 'R1+△ fires')
check(not d:update({ r1 = true, triangle = true }, C, true).fire, 'held: no repeat')
check(not d:update({ r1 = true }, C, true).fire, 'partial release')
check(d:update({ r1 = true, triangle = true }, C, true).fire, 'fires again')
d:update({}, C, true)
check(not d:update({ r1 = true, triangle = true }, {}, true).fire, 'empty combo never fires')
-- ゲームに渡さない
d = sc.new()
local r = d:update({ r1 = true, triangle = true }, C, false)
check(r.fire and r.block.r1 and r.block.triangle, 'blocked when not passing')
r = d:update({ r1 = true }, C, false)
check(r.block.r1 and not r.block.triangle, 'released triangle unblocked')
r = d:update({}, C, false)
check(next(r.block) == nil, 'all released')
d = sc.new()
r = d:update({ r1 = true, triangle = true }, C, true)
check(r.fire and next(r.block) == nil, 'passing: nothing blocked')
-- ボタン待ち：押したまま（決定の ×）は一度離すまで数えない
d = sc.new()
d:update({ cross = true }, C, true)
d:start_capture()
r = d:update({ cross = true }, C, true)
check(d:capturing() and r.block.cross and not r.captured, 'wait for release first')
d:update({}, C, true)
d:update({ l1 = true }, C, true)
r = d:update({ l1 = true, circle = true }, C, true)
check(r.block.l1 and r.block.circle and not r.fire, 'collecting, blocked, no fire')
eq(sc.label(d:captured_so_far()), 'L1＋○', 'so far')
d:update({ circle = true }, C, true)
r = d:update({}, C, true)
eq(sc.label(r.captured), 'L1＋○', 'captured on full release')
check(not d:capturing(), 'capture ended')

-- 設定：保存した空の組み合わせは空のまま、無いときはおすすめ
local settings = require('src.core.settings')
local json_pre = require('src.lib.json')
local m = settings.merge({ shortcut = { open_book = {}, pass_to_game = false } })
eq(#m.shortcut.open_book, 0, 'cleared stays cleared')
eq(m.shortcut.pass_to_game, false, 'pass kept off')
m = settings.merge({})
eq(#m.shortcut.open_book, 0, 'default none (0.1.67)')
eq(m.defaults_rev, 8, 'defaults revision (0.1.210)')
-- 0.1.66 までの保存で R1＋△（前の初期値）のままなら なし へ。ほかの組み合わせ・改訂後の保存はそのまま
m = settings.merge({ shortcut = { open_book = { 'r1', 'triangle' } } })
eq(#m.shortcut.open_book, 0, 'old default migrated to none')
m = settings.merge({ shortcut = { open_book = { 'l1', 'circle' } } })
eq(sc.label(m.shortcut.open_book), 'L1＋○', 'own combo kept')
m = settings.merge({ defaults_rev = 2, shortcut = { open_book = { 'r1', 'triangle' } } })
eq(sc.label(m.shortcut.open_book), 'R1＋△', 'chosen after 0.1.67 kept')
m = settings.merge(json_pre.decode(json_pre.encode(settings.merge({ shortcut = { open_book = { 'r1', 'triangle' } } }))))
eq(#m.shortcut.open_book, 0, 'stays none after save and load')
m = settings.merge({ gameui = { mission_book = false, config_button = true, capture = false } })
eq(m.gameui.mission_book, false, 'own gameui off kept'); eq(m.gameui.capture, false, 'own capture off kept')
m = settings.merge({})
check(m.gameui.mission_book and m.gameui.config_button and m.gameui.capture, 'gameui defaults on')
eq(m.shortcut.pass_to_game, true, 'default pass to game')
m = settings.merge({ defaults_rev = 2, shortcut = { open_book = { 'triangle', 'bogus', 'r1' } } })
eq(sc.label(m.shortcut.open_book), 'R1＋△', 'normalized')
local json = require('src.lib.json')
check(json.encode(settings.merge({ shortcut = { open_book = {} } })):find('"open_book":%s*%[%s*%]') ~= nil, 'empty saved as array')

-- アドオンに通す
dofile(ROOT .. '/astertrail.lua')
check(FAKE.events.xinput_state, 'xinput_state registered')
FAKE.events.load()
local app = require('src.app')
local platform = require('src.platform.ashita')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(#S.shortcut.open_book, 0, 'new character: no shortcut')
S.shortcut.open_book = { 'r1', 'triangle' }   -- 以下は R1＋△ を決めたものとして

-- 版の番号：astertrail.lua と src/app.lua
eq(addon.version, app.VERSION, 'addon.version == app.VERSION')
local f = io.open(ROOT .. '/astertrail.lua', 'r'); local src = f:read('*a'); f:close()
eq(src:match("addon%.version%s*=%s*'([^']+)'"), app.VERSION, 'astertrail.lua text matches app.lua')

local cur = ffi.new('astertrail_xinput_state_t')
local mod = ffi.new('astertrail_xinput_state_t')
local function xs(buttons, lt, rt, user)
    cur.wButtons = buttons; cur.bLeftTrigger = lt or 0; cur.bRightTrigger = rt or 0
    mod.wButtons = buttons; mod.bLeftTrigger = lt or 0; mod.bRightTrigger = rt or 0
    FAKE.events.xinput_state({ user = user or 0, size = ffi.sizeof(cur), state = ffi.cast('void*', cur), state_modified = ffi.cast('void*', mod) })
end
local R1, TRI, CROSS, L1, CIRCLE = 0x0200, 0x8000, 0x1000, 0x0100, 0x2000

app.close_all(); frame()
check(not app.own_menu_open(), 'nothing open')
xs(R1); frame()
check(not app.state.open.book, 'R1 alone does nothing')
xs(R1 + TRI); frame()
check(app.state.open.book, 'R1+△ opens book')
eq(platform.pad_source(), 'state', 'read from xinput_state')
eq(tonumber(mod.wButtons), R1 + TRI, 'passed to game by default')
xs(R1 + TRI); frame()
check(app.state.open.book, 'holding does not toggle')
xs(0); frame()
-- 開いているメニューを全部閉じる（トラッカーは残す）
app.open_window('settings'); frame()
S.tracker.visible = true
xs(R1 + TRI); frame(); xs(0); frame()
check(not app.state.open.book and not app.state.open.settings, 'closes all own menus')
check(app.tracker_on() ~= nil and S.tracker.visible, 'tracker stays')
-- 「パッドで画面を操作」がオフなら動かさない
S.input.gamepad = false
xs(R1 + TRI); frame(); xs(0); frame()
check(not app.state.open.book, 'pad operation off: no shortcut')
S.input.gamepad = true
-- 2台目のパッドは読まない
xs(R1 + TRI, 0, 0, 1); frame(); xs(0, 0, 0, 1); frame()
check(not app.state.open.book, 'second pad ignored')

-- ゲームに渡さない
S.shortcut.pass_to_game = false
xs(R1); frame()
eq(tonumber(mod.wButtons), R1, 'before combo: R1 reaches the game')
xs(R1 + TRI + CROSS); frame()
check(app.state.open.book, 'superset still fires')
eq(tonumber(mod.wButtons), CROSS, 'combo kept from the game, others pass')
check(pad(15, 1), 'xinput_button △ blocked too')
xs(R1); frame()
eq(tonumber(mod.wButtons), 0, 'R1 still blocked until released')
xs(0); frame()
eq(pad(15, 0), false, 'after release: not blocked')
S.shortcut.pass_to_game = true
app.close_all(); frame()

-- 設定：ショートカット設定のタブ
local function seen(pat) for _, l in ipairs(FAKE.labels) do if l:find(pat, 1, true) then return true end end return false end
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('input'); frame(); frame()
check(seen('本を開く：R1＋△'), 'shows combo in PS notation')
check(seen('ゲームに渡す'), 'pass toggle')
check(not seen('おすすめに戻す'), 'no recommended button (0.1.67)')
check(not seen('初期値に戻す（なし）'), 'no reset-to-none buttons')
check(not labeled('消す##sc_clear') and not labeled('消す##sc_tt_clear'), 'no separate clear button (0.1.194)')
check(seen('ゲームのメニュー') and seen('本の操作中はゲームのメニューを止める') and seen('コンフィグに設定のボタンを出す') and seen('ミッションを開いたら本も開く'), 'game menu settings in the operation tab')
FAKE.clicks['##sc_open'] = true; frame(); frame()
check(app.pad_capturing(), 'click starts waiting')
check(seen('ボタンを押してください'), 'waiting label')
xs(0)
xs(L1); frame()
check(pad(8, 1), 'pad nav blocked while waiting'); 
xs(L1 + CIRCLE); frame()
check(seen('押しているボタン：L1＋○') or texted('押しているボタン：L1＋○') or drawn('押しているボタン：L1＋○'), 'shows held so far')
eq(tonumber(mod.wButtons), 0, 'nothing reaches the game while waiting')
check(app.state.open.settings, 'circle did not close settings')
xs(CIRCLE); frame()
check(app.pad_capturing(), 'still waiting while any held')
xs(0); frame(); frame()
check(not app.pad_capturing(), 'decided on release')
eq(sc.label(S.shortcut.open_book), 'L1＋○', 'saved new combo')
check(seen('本を開く：L1＋○'), 'label updated')
check(app.state.open.settings, 'settings stays open after capture')
-- 新しい組み合わせで閉じる
xs(L1 + CIRCLE); frame(); xs(0); frame()
check(not app.state.open.settings, 'new combo closes menus')
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('input'); frame(); frame()
FAKE.clicks['##sc_open_reset'] = true; frame(); frame()
eq(#S.shortcut.open_book, 0, 'reset to default (unbound)')
check(seen('本を開く：なし'), 'shows none')
app.close_all(); frame()
xs(R1 + TRI); frame(); xs(0); frame()
check(not app.state.open.book, 'cleared: nothing fires')
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('input'); frame(); frame()
S.shortcut.open_book = { 'r1', 'triangle' }
-- Esc でボタン待ちをやめる
FAKE.clicks['##sc_open'] = true; frame(); frame()
check(app.pad_capturing(), 'waiting again')
press(0x01); frame()
check(not app.pad_capturing(), 'Esc cancels waiting')
eq(sc.label(S.shortcut.open_book), 'R1＋△', 'unchanged after cancel')
app.close_all(); frame()

-- xinput_state が読めない環境：xinput_button から作る
platform._reset_pad_source()
pad(9, 1); pad(15, 1); frame()
check(app.state.open.book, 'fallback from xinput_button')
eq(platform.pad_source(), 'button', 'source = button')
pad(15, 0); pad(9, 0); frame()
app.close_all(); frame()
platform._reset_pad_source()
