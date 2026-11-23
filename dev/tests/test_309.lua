-- 0.1.309：日本語入力のプラグイン（AstertrailIME）の文字を、Astertrail の入力欄（まず本の検索）に入れる
require('fake_env')
-- プラグインの窓口（Ashita の PluginManager。VanaCore の vana.plugins が無いとき）
local PM = { loaded = false, raised = {} }
AshitaCore.GetPluginManager = function ()
    return {
        IsLoaded = function (_, name) return PM.loaded and name == 'japanese_ime' end,
        RaiseEvent = function (_, name, data, size) PM.raised[#PM.raised + 1] = name .. '=' .. tostring(data) end,
    }
end
local imgui = package.loaded['imgui']
local last_label, active_label = nil, nil
imgui.InputTextWithHint = function (label, hint, buf, size)
    check(type(buf) == 'table' and type(buf[1]) == 'string', 'input buffer')
    FAKE.labels[#FAKE.labels + 1] = label
    last_label = label
    return false
end
imgui.IsItemActive = function () return active_label ~= nil and last_label == active_label end

dofile(ROOT .. '/astertrail.lua')
local app = require('src.app')
local ime = require('src.ui.ime_input')
eq(app.VERSION, '1.1.324', 'version')
FAKE.events.load()
FAKE.player = { name = 'R309', zone = 230, tidx = 5, status = 0 }
frames(1)
check(FAKE.events.plugin_event ~= nil, 'plugin_event registered')
local function pev(name, data) FAKE.events.plugin_event({ name = name, data = data, size = #data }) end

-- UTF-8 の途中で切らない
eq(ime._clip_utf8('あいう', 7), 'あい', 'clip utf8')
eq(ime._clip_utf8('abc', 5), 'abc', 'clip short')

cmd('/astertrail'); frames(0.3)
check(app.state.open.book, 'book open')
check(labeled('##astertrail_search'), 'search box drawn')

-- 欄を選んでいても、プラグインが無ければ何も頼まない・何も出さない
active_label = '##astertrail_search'
local np = #FAKE.printed
frames(0.5)
eq(#PM.raised, 0, 'no plugin, no raise')
eq(#FAKE.printed, np, 'no chat lines without plugin')
check(app.state.text_active, 'text active')
-- 選ばれていない欄の文字は捨てる
active_label = nil; frame(); frame()
pev('japanese_ime_text', 'astertrail\tむし'); frame()
eq(ime.state().pending[1], nil, 'ignored while no box is active')

-- プラグインあり：選んだら 1 回だけ on
PM.loaded = true
active_label = '##astertrail_search'
frame(); frame(); frame()
eq(#PM.raised, 1, 'one raise')
eq(PM.raised[1], 'japanese_ime_ctl=on astertrail', 'capture on')

-- 変換中の文字は欄の後ろに薄く出す
pev('japanese_ime_comp', 'astertrail\tかんじ'); frame()
check(texted('かんじ'), 'composition drawn')
pev('japanese_ime_comp', 'astertrail\t'); frame()
check(not texted('かんじ'), 'composition cleared')

-- 確定：ImGui の入力として渡せる環境ではそちらへ（カーソルの位置に入る）
local fed = {}
local old_io = imgui.GetIO
imgui.GetIO = function ()
    return { DisplaySize = { x = 1920, y = 1080 },
             AddInputCharactersUTF8 = function (self, s) fed[#fed + 1] = s end }
end
pev('japanese_ime_text', 'astertrail\t漢字'); frame()
eq(fed[1], '漢字', 'fed to imgui io')
eq(app._settings().book.filters.text or '', '', 'buffer left to imgui')
imgui.GetIO = old_io

-- 渡せない環境：欄の文字の後ろに足し、1 フレームだけ別の ID で描く（ImGui の持つ文字に戻されないように）
pev('japanese_ime_text', 'astertrail\tバストゥーク'); frame()
eq(app._settings().book.filters.text, 'バストゥーク', 'appended to search')
frame()
check(labeled('##astertrail_search_ime'), 'redrawn once with another id')
frame()
check(labeled('##astertrail_search') and not labeled('##astertrail_search_ime'), 'back to the normal id')

-- 欄を離れたら off、戻ったら on
active_label = nil; frame(); frame()
eq(PM.raised[#PM.raised], 'japanese_ime_ctl=off astertrail', 'capture off when no box is active')
local n = #PM.raised
frame(); frame()
eq(#PM.raised, n, 'off sent once')
active_label = '##astertrail_search'; frame(); frame()
eq(PM.raised[#PM.raised], 'japanese_ime_ctl=on astertrail', 'on again')

-- プラグインの返事は覚えるだけ
pev('japanese_ime_state', 'on astertrail'); frame()
eq(ime.state().plugin_on, true, 'state answer')
-- ほかのプラグインの知らせは見ない
pev('someone_else', 'x'); frame()

-- 閉じるときは off を頼む
FAKE.events.unload()
eq(PM.raised[#PM.raised], 'japanese_ime_ctl=off astertrail', 'off on unload')

-- エミネンスの検索・レイアウト名の欄も同じ
for _, f in ipairs({ 'src/ui/eminence.lua', 'src/ui/settings_ui.lua', 'src/ui/settings_sf.lua', 'src/ui/book.lua' }) do
    local s = io.open(ROOT .. '/' .. f, 'r'):read('*a')
    check(s:find('ime.field(ui, imgui,', 1, true) and s:find('ime.label(', 1, true), 'ime wired: ' .. f)
end
print('test_309 ok')
