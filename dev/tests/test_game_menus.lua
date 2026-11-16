-- ゲームのメニューを前に（0.1.186〜、t302）：メニューが開いている間だけ vana.ui.game_on_top(true)
require('fake_env')
local wins = { helpwind = { focused = false }, partywin = { focused = false }, logwindo = { focused = false } }
local order = { 'helpwind', 'partywin', 'logwindo' }
local flag = false
local on_top_calls = {}
local reads = 0
_G.vana = {
    game = { target = function () return { menu_open = flag } end },
    gameui = {
        windows = function () reads = reads + 1; local o = {} for i, n in ipairs(order) do o[i] = n end return o end,
        window = function (n) local w = wins[n]; if not w then return nil end
            return { name = n, focused = w.focused, closing = w.closing or false, hidden = false } end,
    },
    ui = { game_on_top = function (on) on_top_calls[#on_top_calls + 1] = on end },
}
local ext = require('src.platform.vanacore_ext')
local open, info = ext.game_menu_state()
eq(open, false, 'idle: no menu'); eq(info.flag, false, 'flag read'); eq(#info.focused, 0, 'none focused')
flag = true
eq((ext.game_menu_state()), true, 'menu flag')
flag = false
order[#order + 1] = 'query'; wins.query = { focused = true }
open, info = ext.game_menu_state()
eq(open, true, 'focused window (event choices)'); eq(info.focused[1], 'query', 'focused name')
wins.query.closing = true
eq((ext.game_menu_state()), false, 'closing window does not count')
order[#order] = nil; wins.query = nil

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local S = app._settings()
FAKE.player = { name = 'Menus', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(#on_top_calls, 0, 'nothing while no menu')
check(not app.state.game_on_top, 'not on top')
-- ホームポイントのメニュー（キーが行く窓）
order[#order + 1] = 'homepoin'; wins.homepoin = { focused = true }
frames(0.3)
eq(on_top_calls[#on_top_calls], true, 'game windows in front while a menu is open')
eq(app.state.game_on_top, true, 'state on')
local n = #on_top_calls
frames(1)
eq(#on_top_calls, n, 'called once, not every frame')
-- 閉じたら戻す
order[#order] = nil; wins.homepoin = nil
frames(0.3)
eq(on_top_calls[#on_top_calls], false, 'off after the menu closes')
-- メインメニュー（印だけ）
flag = true; frames(0.3)
eq(on_top_calls[#on_top_calls], true, 'main menu flag')
flag = false; frames(0.3)
-- 読む回数は 0.1 秒に 1 回まで
local r0 = reads
frames(1)
check(reads - r0 <= 11, 'throttled reads: ' .. (reads - r0))
-- 設定でオフ
S = app._settings(); S.gameui.menus_on_top = false
local n2 = #on_top_calls
flag = true; frames(0.3)
for i = n2 + 1, #on_top_calls do check(on_top_calls[i] == false, 'setting off: never on') end
eq(app.state.game_on_top, false, 'setting off state')
S.gameui.menus_on_top = true
frames(0.3)
eq(on_top_calls[#on_top_calls], true, 'setting back on')
-- コマンド
FAKE.printed = {}
check(cmd('/astertrail menus'), 'menus command')
check(printed('ゲームのメニュー: 開いている はい'), 'menus command prints')
-- アンロードで外す
flag = false
app.release_gameui()
eq(on_top_calls[#on_top_calls], false, 'released on unload')
-- 設定の画面にスイッチ
local s2 = require('src.core.settings').defaults()
eq(s2.gameui.menus_on_top, true, 'default on')
local merged = require('src.core.settings').merge({ gameui = { capture = false } })
eq(merged.gameui.menus_on_top, true, 'old save gets the default')
