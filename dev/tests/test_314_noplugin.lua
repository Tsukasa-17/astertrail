-- 0.1.314：プラグイン（japanese_ime）が入っていなくても、Astertrail はそのまま使える。
-- エラーなし・チャットに何も出ない・ふつうの ImGui の入力は動く・英数字の Space／Enter はアドオン側で隠す
require('fake_env')
local raised = {}
-- プラグインの窓口はあるが、何も読み込まれていない
AshitaCore.GetPluginManager = function ()
    return {
        IsLoaded = function () return false end,
        RaiseEvent = function (_, name, data) raised[#raised + 1] = name .. '=' .. tostring(data) end,
    }
end
local imgui = package.loaded['imgui']
local last_label, active_label = nil, nil
local typed = {}
imgui.InputTextWithHint = function (label, hint, buf, size)
    FAKE.labels[#FAKE.labels + 1] = label; last_label = label
    if active_label == label and typed[label] then buf[1] = typed[label]; typed[label] = nil; return true end
    return false
end
imgui.IsItemActive = function () return active_label ~= nil and last_label == active_label end

dofile(ROOT .. '/astertrail.lua')
local app = require('src.app')
local platform = require('src.platform.ashita')
eq(app.VERSION, '1.1.327', 'version')
local ran = {}
local orig = { chat_run = platform.chat_run }
platform.chat_run = function (line) ran[#ran + 1] = line; return true end
FAKE.events.load()
FAKE.player = { name = 'NoPl', zone = 230, tidx = 5, status = 0 }
frames(1)
cmd('/astertrail'); frames(0.3)
local S = app._settings()
local L = '##astertrail_search'
local function problems()
    for _, line in ipairs(FAKE.printed) do
        local s = tostring(line)
        if s:find('問題', 1, true) or s:find('error', 1, true) or s:find('nil value', 1, true) or s:find('jime', 1, true) then return s end
    end
end
FAKE.printed = {}
active_label = L; frames(1.5)
eq(#raised, 0, 'no plugin: nothing raised')
eq(#ran, 0, 'no plugin: no silent command')
eq(problems(), nil, 'no plugin: nothing in chat')
-- ふつうの入力（英数字・ImGui がそのまま受ける）
typed[L] = 'Bastok'; frame(); frame()
eq(S.book.filters.text, 'Bastok', 'plain ImGui typing works')
-- 英数字の Space／Enter はゲームに渡さない（DirectInput の押下と状態の両方）
local ffi = require('ffi')
local st = ffi.new('uint8_t[256]')
for _, k in ipairs({ 0x39, 0x1C, 0x9C }) do
    local e = { key = k, down = true, blocked = false }
    FAKE.events.key_data(e)
    check(e.blocked == true, string.format('dik 0x%02X down hidden without the plugin', k))
    st[k] = 0x80
end
FAKE.events.key_state({ data_raw = st, data = st, size = 256 })
eq(st[0x39], 0, 'space hidden from the state'); eq(st[0x1C], 0, 'enter hidden from the state')
for _, k in ipairs({ 0x39, 0x1C, 0x9C }) do
    st[k] = 0
    local e = { key = k, down = false, blocked = false }
    FAKE.events.key_data(e)
    check(e.blocked == true, string.format('dik 0x%02X release hidden too', k))
end
FAKE.events.key_state({ data_raw = st, data = st, size = 256 })
-- 文字のキーはそのまま
local e = { key = 0x1E, down = true, blocked = false }
FAKE.events.key_data(e)
check(e.blocked ~= true, 'letters are not hidden')
FAKE.events.key_data({ key = 0x1E, down = false, blocked = false })
-- 欄を抜ける・閉じる・アンロードでもエラーにならない
active_label = nil; frames(1)
cmd('/astertrail'); frames(0.3)
eq(#raised, 0, 'still nothing raised')
eq(problems(), nil, 'no errors without the plugin')
platform.chat_run = orig.chat_run
print('test_314_noplugin ok')
