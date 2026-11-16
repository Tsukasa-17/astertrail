require('fake_env')
dofile(ROOT .. '/astertrail.lua')
for _, n in ipairs({ 'load', 'unload', 'command', 'd3d_present', 'key_data', 'key_state', 'xinput_button' }) do
    check(FAKE.events[n], 'event registered: ' .. n)
end
FAKE.events.load()
local app = require('src.app')
-- キャラが分かるまで保存しない
frames(1)
local cfg = TMP .. '/Vanacore/config/addons/astertrail/'
check(not ashita.fs.exists(cfg .. 'catseye_Tester'), 'nothing saved before login')
check(not app.want_keys(), 'not operating')
eq(key(0xC8, true), false, 'keys pass through when idle'); key(0xC8, false)
eq(pad(0, 1), false, 'pad passes through when idle'); pad(0, 0)
-- ログイン
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
check(app.state.character and app.state.character.name == 'Tester', 'logged in')
-- 本を開く
check(cmd('/astertrail'), 'command handled'); frame()
check(drawn('###astertrail_book') or drawn('astertrail'), 'book drawn: ' .. table.concat(FAKE.drawn, ','))
check(app.want_keys(), 'operating after open')
eq(press(0xD0), true, 'down blocked while operating')
eq(pad(1, 1), true, 'pad blocked while operating'); pad(1, 0)
for _ = 1, 5 do press(0xD0); frame() end
press(0x1C); frame()   -- 決定
frame()
-- ピン留め（本の星）
FAKE.clicks['☆'] = true; frame(); frame()
local PRm = app._progress and app._progress() 
-- 詳細を開いて手順チェック
cmd('/astertrail tracker show'); frame()
-- Esc で戻る・閉じる
for _ = 1, 4 do press(0x01); frame() end
check(not app.want_keys(), 'released after Esc')
eq(press(0xC8), false, 'keys pass again after release')
-- トラッカーは見えているだけでは入力を取らない
frame(); eq(pad(0, 1), false, 'tracker visible does not take pad'); pad(0, 0)
-- 各コマンド
for _, c in ipairs({ 'compass', 'compass', 'settings', 'tracker focus', 'notice', 'release', 'status', 'target', 'save', 'resetlayout', 'help', 'close', 'toggle', 'toggle', 'tracker hide' }) do
    check(cmd('/astertrail ' .. c), 'cmd ' .. c); frame(); frame()
end
check(not cmd('/other'), 'other commands not blocked')
-- 保存が書かれる
frames(4)
check(cmd('/astertrail save'), 'save')
local dir = cfg .. 'catseye_Tester/'
check(ashita.fs.exists(dir .. 'progress.json'), 'progress saved')
check(ashita.fs.exists(dir .. 'settings.json'), 'settings saved')
-- ゾーン移動中の一瞬の空白ではログアウトしない
FAKE.player.name = ''; frames(1); FAKE.player.name = 'Tester'; FAKE.player.zone = 231; frames(4)
check(app.state.character, 'still logged in after brief blank')
-- 本当のログアウト
FAKE.player.name = ''; frames(7)
check(not app.state.character, 'logged out after grace')
-- 再ログイン、アンロード
FAKE.player.name = 'Tester'; frames(1)
FAKE.events.unload()
check(not printed('present:'), 'no present errors: ' .. table.concat(FAKE.printed, ' | '))
check(not printed('command:'), 'no command errors')
local diag = require('src.core.diagnostics')
local errs = {}
for _, l in ipairs(diag.recent(100)) do if l.kind ~= 'session' then errs[#errs + 1] = type(l) == 'table' and ((l.kind or '') .. ':' .. tostring(l.msg)) or tostring(l) end end
check(#errs == 0, 'diag errors: ' .. table.concat(errs, '\n'))
