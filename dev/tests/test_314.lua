-- 0.1.314：汎用プラグイン japanese_ime の決まり（"on astertrail"／"off astertrail"、文字は "astertrail\t文字"）。
-- ほかのアドオンあての文字は入れない
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
local ime = require('src.ui.ime_input')
local platform = require('src.platform.ashita')
eq(app.VERSION, '1.1.318', 'version')
local orig = { chat_run = platform.chat_run, log_only = platform.log_only }
local ran = {}
platform.chat_run = function (line) ran[#ran + 1] = line; return true end
platform.log_only = function () return true end
FAKE.events.load()
FAKE.player = { name = 'R314', zone = 230, tidx = 5, status = 0 }
frames(1)
local function pev(name, data) FAKE.events.plugin_event({ name = name, data = data, size = #data }) end
cmd('/astertrail'); frames(0.3)

active_label = '##astertrail_search'
frame(); frame()
eq(PM.raised[#PM.raised], 'japanese_ime_ctl=on astertrail', 'on with the addon id')
pev('japanese_ime_state', 'on astertrail'); frame()
eq(ime.state().plugin_on, true, 'answer for astertrail')
-- ほかのアドオンあての文字・変換中は使わない
pev('japanese_ime_text', 'yunaui\tよそ'); frame()
eq(ime.state().pending[1], nil, 'text for another addon ignored')
pev('japanese_ime_comp', 'yunaui\tよそ'); frame()
eq(ime.state().comp, '', 'composition for another addon ignored')
-- 区切りの無い古い形も使わない
pev('japanese_ime_text', 'むし'); frame()
eq(ime.state().pending[1], nil, 'untagged text ignored')
-- ほかのアドオンが on にした（プラグインの返事が別の ID）→ 自分は返事なし扱い
pev('japanese_ime_state', 'on yunaui'); frame()
eq(ime.state().plugin_on, false, 'owner is another addon')
-- 返事が無いままなら、黙ったコマンドも ID 付き
frames(1.2)
eq(ran[#ran], '/jime addon on astertrail', 'silent command with the id')
active_label = nil; frames(0.2)
eq(PM.raised[#PM.raised], 'japanese_ime_ctl=off astertrail', 'off with the addon id')
eq(ran[#ran], '/jime addon off astertrail', 'silent off with the id')
for k, v in pairs(orig) do platform[k] = v end
print("test_314 ok")
