-- 0.1.311：Astertrail の入力欄が選ばれている間、Enter・Esc・Space などをゲームに渡さない（チャット欄が開かない）。
-- 日本語の変換中・確定した直後は、Astertrail の操作（Esc で閉じるなど）にも使わない
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
eq(app.VERSION, '1.1.327', 'version')
platform.chat_run = function () return true end
FAKE.events.load()
FAKE.player = { name = 'R311', zone = 230, tidx = 5, status = 0 }
frames(1)
local function pev(name, data) FAKE.events.plugin_event({ name = name, data = data, size = #data }) end
cmd('/astertrail'); frames(0.3)
check(app.state.open.book, 'book open')

-- 欄が選ばれていなければ今までどおり（Enter はゲームへ）
eq(app.text_key_block(0x1C), nil, 'no box: nil')
check(not key(0x39, true), 'no box: space to the game'); key(0x39, false)

active_label = '##astertrail_search'
frame(); frame()
pev('japanese_ime_state', 'on astertrail'); frame()
check(app.state.text_active, 'box active')
eq(app.text_key_block(0x1C), 'box', 'box: enter')
eq(app.text_key_block(0x1E), nil, 'letters are not taken')
-- Enter：押したのも離したのもゲームに渡さない
check(key(0x1C, true), 'enter down blocked')
check(key(0x1C, false), 'enter up blocked')
check(key(0x9C, true), 'numpad enter blocked'); key(0x9C, false)
check(key(0x39, true), 'space blocked'); check(key(0x39, false), 'space up blocked')
check(key(0x0E, true), 'backspace blocked'); key(0x0E, false)
check(key(0xCB, true), 'left blocked'); key(0xCB, false)
check(not key(0x1E, true), 'letter to the game'); key(0x1E, false)
eq(platform._held_inputs(), 0, 'nothing left held')

-- 変換中：Esc は変換の取り消し。本は閉じない
pev('japanese_ime_comp', 'astertrail\tかな'); frame()
eq(app.text_key_block(0x01), 'ime', 'composing: ime')
check(key(0x01, true), 'esc blocked while composing')
check(key(0x01, false), 'esc up blocked')
frame()
check(app.state.open.book, 'book still open')
-- 確定：直後の Enter も変換のもの
pev('japanese_ime_text', 'astertrail\t仮名'); pev('japanese_ime_comp', 'astertrail\t'); frame()
eq(app.text_key_block(0x1C), 'ime', 'just committed: ime')
check(key(0x1C, true), 'confirming enter blocked'); key(0x1C, false)
frames(1)
eq(app.text_key_block(0x1C), 'box', 'later: box again')

-- プラグインが無い（取得オフ）なら変換中とは見ない
active_label = nil; frame(); frame()
frames(1)  -- 0.1.312〜：抜けた直後（0.5 秒）は止め続ける
eq(ime.composing(), false, 'not composing when off')
eq(app.text_key_block(0x1C), nil, 'box left: nil')
check(not key(0x39, true), 'space to the game again'); key(0x39, false)

-- チャット欄が開いているときは渡す
active_label = '##astertrail_search'; frame(); frame()
app.state.chat_open = true
eq(app.text_key_block(0x1C), nil, 'chat open: nil')
app.state.chat_open = false
print('test_311 ok')
