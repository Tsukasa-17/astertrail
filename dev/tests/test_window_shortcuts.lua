-- 0.1.194：エミネンスとコンパスの表示／非表示ショートカット（初期値はなし。窓そのものの初期表示は変えない）
require('fake_env')
local ffi = require('ffi')
local sc = require('src.core.shortcut')
local settings = require('src.core.settings')
local json = require('src.lib.json')

local m = settings.merge({})
eq(#m.shortcut.eminence_toggle, 0, 'eminence toggle unbound by default')
eq(#m.shortcut.compass_toggle, 0, 'compass toggle unbound by default')
eq(m.compass.visible, false, 'compass window default stays hidden')
eq(m.eminence.visible, false, 'eminence window default stays hidden')
check(json.encode(m):find('"eminence_toggle":%s*%[%s*%]') ~= nil, 'empty eminence saved as array')
check(json.encode(m):find('"compass_toggle":%s*%[%s*%]') ~= nil, 'empty compass saved as array')

-- 古い保存にキーが無くてもなし。既存の割り当ては触らない
m = settings.merge({ defaults_rev = 3, shortcut = { open_book = { 'r1', 'triangle' }, tracker_toggle = { 'l3', 'r3' } } })
eq(sc.label(m.shortcut.open_book), 'R1＋△', 'existing book binding kept')
eq(sc.label(m.shortcut.tracker_toggle), 'L3＋R3', 'existing tracker binding kept')
eq(#m.shortcut.eminence_toggle, 0, 'missing eminence key stays empty')
eq(#m.shortcut.compass_toggle, 0, 'missing compass key stays empty')

-- すでに入っている割り当ては残す
m = settings.merge({ shortcut = { compass_toggle = { 'share', 'l1', 'bogus' }, eminence_toggle = { 'l2', 'r2' } } })
eq(sc.label(m.shortcut.compass_toggle), 'L1＋SHARE', 'saved compass binding kept')
eq(sc.label(m.shortcut.eminence_toggle), 'L2＋R2', 'saved eminence binding kept')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(#S.shortcut.eminence_toggle, 0, 'new character: eminence unbound')
eq(#S.shortcut.compass_toggle, 0, 'new character: compass unbound')
eq(S.compass.visible, false, 'new character: compass window hidden')
eq(S.eminence.visible, false, 'new character: eminence window hidden')

check(app.shortcut_set('eminence_toggle', { 'l3', 'r3' }), 'set eminence')
check(app.shortcut_set('compass_toggle', { 'share', 'options' }), 'set compass')
check(not app.shortcut_set('compass_toggle', { 'r3', 'l3' }), 'duplicate with eminence refused')
eq(sc.label(S.shortcut.compass_toggle), 'SHARE＋OPTIONS', 'compass binding unchanged after conflict')
check(app.state.flash and app.state.flash.text:find('エミネンスの表示／非表示', 1, true), 'conflict names the other shortcut')

local cur = ffi.new('astertrail_xinput_state_t')
local mod = ffi.new('astertrail_xinput_state_t')
local function xs(buttons, lt, rt)
    cur.wButtons = buttons; cur.bLeftTrigger = lt or 0; cur.bRightTrigger = rt or 0
    mod.wButtons = buttons; mod.bLeftTrigger = lt or 0; mod.bRightTrigger = rt or 0
    FAKE.events.xinput_state({ user = 0, size = ffi.sizeof(cur), state = ffi.cast('void*', cur), state_modified = ffi.cast('void*', mod) })
end
local SHARE, OPTIONS, L3, R3 = 0x0020, 0x0010, 0x0040, 0x0080
local function tap(b) xs(b); frame(); xs(0); frame() end

app.close_all(); frame()
S.eminence.visible = false
S.compass.visible = false
tap(L3 + R3)
check(S.eminence.visible, 'eminence shown')
check(app.state.flash and tostring(app.state.flash.text):find('出しました', 1, true), 'eminence shown flash')
check(drawn('astertrail_eminence'), 'eminence window drawn')
tap(L3 + R3)
check(not S.eminence.visible, 'eminence hidden')
check(app.state.flash and tostring(app.state.flash.text):find('隠しました', 1, true), 'eminence hidden flash')
check(not drawn('astertrail_eminence'), 'eminence window not drawn')

tap(SHARE + OPTIONS)
check(S.compass.visible, 'compass shown')
check(app.state.flash and tostring(app.state.flash.text):find('出しました', 1, true), 'compass shown flash')
check(drawn('astertrail_compass'), 'compass window drawn')
tap(SHARE + OPTIONS)
check(not S.compass.visible, 'compass hidden')
check(app.state.flash and tostring(app.state.flash.text):find('隠しました', 1, true), 'compass hidden flash')
check(not drawn('astertrail_compass'), 'compass window not drawn')

-- 操作タブに並ぶ。消すとなしに戻る
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('input'); frame(); frame()
check(texted('エミネンスの表示／非表示') and texted('L3＋R3'), 'eminence row in input tab')
check(texted('コンパスの表示／非表示') and (texted('OPTIONS＋SHARE') or texted('SHARE＋OPTIONS')), 'compass row in input tab')
FAKE.clicks['##sc_et_reset'] = true; frame(); frame()
eq(#S.shortcut.eminence_toggle, 0, 'reset eminence')
FAKE.clicks['##sc_ct_reset'] = true; frame(); frame()
eq(#S.shortcut.compass_toggle, 0, 'reset compass')
check(texted('なし'), 'rows show none after clear')
check(not labeled('消す##sc_et_clear') and not labeled('消す##sc_ct_clear') and not labeled('消す##sc_open'), 'no 消す button on shortcut rows')
local focus = require('src.ui.focus')
local function has(id)
    for _, it in ipairs((focus.windows.settings and focus.windows.settings.list) or {}) do
        if it.id == id then return it end
    end
end
check(has('sc_et') and has('sc_et_reset') and has('sc_ct') and has('sc_ct_reset'), 'reset buttons in the pad list')
eq(has('sc_et').row, has('sc_et_reset').row, 'eminence reset is on the same row')
eq(has('sc_ct').row, has('sc_ct_reset').row, 'compass reset is on the same row')
eq(has('sc_open').row, has('sc_open_reset').row, 'book reset is on the same row')
-- 初期値のときは押せない
FAKE.clicks['##sc_et_reset'] = true; frame(); frame()
eq(#S.shortcut.eminence_toggle, 0, 'reset at default is a no-op')
app.close_all(); frame()
print('test_window_shortcuts ok')
