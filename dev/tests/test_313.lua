-- 0.1.313：ゲームのチャット欄が開いている間は、Astertrail の欄が選ばれていても日本語入力の取得を頼まない（off にする）
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
eq(app.VERSION, '1.1.327', 'version')
local orig = { chat_run = platform.chat_run, log_only = platform.log_only, chat_open = platform.chat_open }
platform.chat_run = function () return true end
platform.log_only = function () return true end
local chat = false
platform.chat_open = function () return chat end
FAKE.events.load()
FAKE.player = { name = 'R313', zone = 230, tidx = 5, status = 0 }
frames(1)
local function pev(name, data) FAKE.events.plugin_event({ name = name, data = data, size = #data }) end
cmd('/astertrail'); frames(0.3)

active_label = '##astertrail_search'
frame(); frame()
eq(PM.raised[#PM.raised], 'japanese_ime_ctl=on astertrail', 'on while the box is active')
pev('japanese_ime_state', 'on astertrail')
-- ゲームのチャット欄が開いた → off
chat = true; frames(0.2)
eq(PM.raised[#PM.raised], 'japanese_ime_ctl=off astertrail', 'off while the game chat is open')
local n = #PM.raised
frames(0.5)
eq(#PM.raised, n, 'stays off, no repeats')
-- 閉じたら、欄が選ばれたままなら on に戻る
chat = false; frames(0.2)
eq(PM.raised[#PM.raised], 'japanese_ime_ctl=on astertrail', 'on again after the chat closed')
active_label = nil; frames(0.2)
eq(PM.raised[#PM.raised], 'japanese_ime_ctl=off astertrail', 'off after leaving the box')
for k, v in pairs(orig) do platform[k] = v end
print("test_313 ok")
