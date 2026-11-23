-- 0.1.322：マイレイアウトの名前の欄も、本の検索と同じやり方で日本語入力（japanese_ime）が入る。どの見た目でも
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
local real_hint = imgui.InputTextWithHint
imgui.InputTextWithHint = function (label, hint, buf, size)
    FAKE.labels[#FAKE.labels + 1] = label
    last_label = label
    return false
end
imgui.IsItemActive = function () return active_label ~= nil and last_label == active_label end

dofile(ROOT .. '/astertrail.lua')
local app = require('src.app')
local ime = require('src.ui.ime_input')
local layouts = require('src.core.layouts')
eq(app.VERSION, '1.1.324', 'version')
FAKE.events.load()
FAKE.player = { name = 'I319', zone = 230, tidx = 5, status = 0 }
frames(1)
local function pev(name, data) FAKE.events.plugin_event({ name = name, data = data, size = #data }) end
local S = app._settings()
local sui = require('src.ui.settings_ui')
local theme = require('src.ui.theme')

-- 自由に名前を打つ欄はすべて日本語入力の道を通る（色の #RRGGBB だけは対象外）
for _, f in ipairs({ 'src/ui/book.lua', 'src/ui/eminence.lua', 'src/ui/settings_sf.lua', 'src/ui/settings_ui.lua' }) do
    local src = io.open(ROOT .. '/' .. f, 'r'):read('*a')
    local n_in, n_ime = 0, 0
    for _ in src:gmatch('imgui%.InputText') do n_in = n_in + 1 end
    for _ in src:gmatch('ime%.field%(') do n_ime = n_ime + 1 end
    check(n_in > 0 and n_in == n_ime, f .. ': every text box goes through ime.field')
end
local wsrc = io.open(ROOT .. '/src/ui/widgets.lua', 'r'):read('*a')
local only = 0
for _ in wsrc:gmatch('InputText') do only = only + 1 end
eq(only, 1, 'widgets: only the color hex box (not a free text box)')

for li, look in ipairs({ 'sf', 'yunaui', 'classic' }) do
    S.look = look; theme.set_look(look)
    app.close_all(); frame()
    app.open_window('settings'); frame(); frame()
    sui.select_tab('look'); frame(); frame()
    local id = '##astertrail_lay_name_' .. li
    check(labeled(id), look .. ': layout name box drawn')
    active_label = id
    frame(); frame(); frame()
    check(ime.state().on, look .. ': capture on while the layout name box is active')
    pev('japanese_ime_comp', 'astertrail\tれいあうと'); frame()
    check(texted('れいあうと'), look .. ': composition shown on the layout box')
    pev('japanese_ime_comp', 'astertrail\t'); frame()
    pev('japanese_ime_text', 'astertrail\t狩り用'); frame()
    eq(app.layout_slots()[li].name, '狩り用', look .. ': Japanese name stored in the layout slot')
    frame()
    check(labeled(id .. '_ime'), look .. ': redrawn once with another id')
    active_label = nil; frame(); frame()
    check(not ime.state().on, look .. ': capture off after leaving')
    eq(app.layout_slots()[li].name, '狩り用', look .. ': name kept after leaving')
end
-- 長い名前は日本語の途中で切らない
local long = string.rep('あ', 25)   -- 75 バイト
local c = layouts.clean_name(long)
eq(#c, 60, 'clipped to 60 bytes on a character boundary')
eq(c, string.rep('あ', 20), 'whole characters only')
imgui.InputTextWithHint = real_hint
print('test_319_ime ok')
