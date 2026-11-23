-- 0.1.310：日本語入力のプラグインへの on／off。知らせに返事が無ければ、黙ったコマンド（/atime addon on|off）でも頼む。
-- 切りかえは VanaCore の記録（vana.log）だけに出す
require('fake_env')
local PM = { loaded = true, raised = {} }
AshitaCore.GetPluginManager = function ()
    return {
        IsLoaded = function (_, name) return PM.loaded and name == 'japanese_ime' end,
        RaiseEvent = function (_, name, data) PM.raised[#PM.raised + 1] = name .. '=' .. tostring(data) end,
    }
end
local imgui = package.loaded['imgui']
local last_label, active_label = nil, nil
imgui.InputTextWithHint = function (label, hint, buf, size)
    FAKE.labels[#FAKE.labels + 1] = label; last_label = label; return false
end
imgui.IsItemActive = function () return active_label ~= nil and last_label == active_label end

dofile(ROOT .. '/astertrail.lua')
local app = require('src.app')
local platform = require('src.platform.ashita')
local ime = require('src.ui.ime_input')
eq(app.VERSION, '1.1.324', 'version')
local ran, logged = {}, {}
platform.chat_run = function (line) ran[#ran + 1] = line; return true end
platform.log_only = function (text) logged[#logged + 1] = text; return true end
local function has_log(pat) for _, t in ipairs(logged) do if t:find(pat, 1, true) then return true end end return false end
FAKE.events.load()
FAKE.player = { name = 'R310', zone = 230, tidx = 5, status = 0 }
frames(1)
local function pev(name, data) FAKE.events.plugin_event({ name = name, data = data, size = #data }) end
cmd('/astertrail'); frames(0.3)
check(app.state.open.book, 'book open')

-- 1) プラグインが返事をする（0.4〜）：コマンドは使わない
active_label = '##astertrail_search'
frame(); frame()
eq(PM.raised[#PM.raised], 'japanese_ime_ctl=on astertrail', 'event on')
pev('japanese_ime_state', 'on astertrail')
frames(2)
eq(#ran, 0, 'no command when the plugin answers')
check(has_log('ime: box active, plugin loaded=true'), 'log: loaded')
check(has_log('ime: capture on (event)'), 'log: on')
active_label = nil; frame(); frame()
eq(PM.raised[#PM.raised], 'japanese_ime_ctl=off astertrail', 'event off')
eq(#ran, 0, 'no off command either')
check(has_log('ime: capture off (event)'), 'log: off')

-- 2) 返事が無い（知らせが届かない）：1 秒後に黙ったコマンドで on、離れたら off もコマンドで
active_label = '##astertrail_search'
frame(); frame()
frames(0.5)
eq(#ran, 0, 'waits for an answer')
frames(1)
eq(ran[1], '/jime addon on astertrail', 'command on')
frames(2)
eq(#ran, 1, 'command sent once')
check(has_log('no answer to the event'), 'log: command')
active_label = nil; frame(); frame()
eq(ran[2], '/jime addon off astertrail', 'command off')
check(has_log('capture off (event + command)'), 'log: off both')

-- 3) プラグインが無ければコマンドも送らない（ゲームに知らないコマンドを渡さない）
PM.loaded = false
active_label = '##astertrail_search'
frames(3)
eq(#ran, 2, 'no command without plugin')
active_label = nil; frame(); frame()

-- 4) コマンドで頼んだまま閉じたら off のコマンドも
PM.loaded = true
active_label = '##astertrail_search'
frames(2)
eq(ran[3], '/jime addon on astertrail', 'command on again')
FAKE.events.unload()
eq(ran[4], '/jime addon off astertrail', 'command off on unload')
print('test_310 ok')
