-- 0.1.312：入力欄の Esc は今の文字のまま抜ける（ImGui が戻した文字を戻し直す）。
-- 欄の間と抜けた直後は Enter・Space などを DirectInput の状態からも外す（離すまで）。キーの記録は vana.log だけ
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
local typed = {}     -- label → 打った文字（次のフレームで欄に入る）
local reverted = {}  -- label → true（このフレームで ImGui の Esc：選ぶ前の文字に戻して抜ける）
local start_text = {}
imgui.InputTextWithHint = function (label, hint, buf, size)
    FAKE.labels[#FAKE.labels + 1] = label; last_label = label
    if active_label == label and start_text[label] == nil then start_text[label] = buf[1] end
    if reverted[label] then
        reverted[label] = nil
        buf[1] = start_text[label] or ''
        start_text[label] = nil
        active_label = nil
        return true
    end
    if active_label == label and typed[label] then
        buf[1] = typed[label]; typed[label] = nil
        return true
    end
    return false
end
imgui.IsItemActive = function () return active_label ~= nil and last_label == active_label end

dofile(ROOT .. '/astertrail.lua')
local app = require('src.app')
local platform = require('src.platform.ashita')
eq(app.VERSION, '1.1.324', 'version')
platform.chat_run = function () return true end
local logged = {}
platform.log_only = function (t) logged[#logged + 1] = t; return true end
local function has_log(pat) for _, t in ipairs(logged) do if t:find(pat, 1, true) then return true end end return false end
FAKE.events.load()
FAKE.player = { name = 'R312', zone = 230, tidx = 5, status = 0 }
frames(1)
cmd('/astertrail'); frames(0.3)
local S = app._settings()
local L = '##astertrail_search'

-- 打って Enter で確定（ここではそのまま）→ 全部消す → Esc：ImGui は「選んだときの文字」に戻すが、今の文字（空）で抜ける
active_label = L; frame(); frame()
typed[L] = 'バス'; frame(); frame()
eq(S.book.filters.text, 'バス', 'typed')
typed[L] = ''; frame(); frame()
eq(S.book.filters.text, '', 'cleared')
reverted[L] = true; frame(); frame()
eq(S.book.filters.text, '', 'Esc keeps the current text (empty)')
check(not app.state.text_active, 'left the box')
-- 選び直して文字を入れて Esc：その文字のまま
active_label = L; frame(); frame()
typed[L] = 'ウィン'; frame(); frame()
reverted[L] = true; frame(); frame()
eq(S.book.filters.text, 'ウィン', 'Esc keeps typed text')
-- ふつうに抜けた（クリックなど）ときは何も変えない
active_label = L; frame(); frame()
active_label = nil; frame(); frame()
eq(S.book.filters.text, 'ウィン', 'plain leave unchanged')

-- DirectInput の状態からも外す
local ffi = require('ffi')
local st = ffi.new('uint8_t[256]')
local function kstate() FAKE.events.key_state({ data_raw = st, data = st, size = 256 }) end
active_label = L; frame(); frame()
st[0x39] = 0x80; kstate()
eq(st[0x39], 0, 'space hidden from the state')
check(has_log('keys: state dik=0x39 hidden from the game'), 'logged')
st[0x1E] = 0x80; kstate()
eq(st[0x1E], 0x80, 'letters stay'); st[0x1E] = 0
-- Enter で抜けた直後（次のフレーム）に状態で読まれても外す
st[0x1C] = 0x80
active_label = nil; frame()
kstate()
eq(st[0x1C], 0, 'enter hidden right after leaving the box')
-- 押したままなら、時間が過ぎても離すまで外し続ける
frames(1)
st[0x1C] = 0x80; kstate()
eq(st[0x1C], 0, 'still hidden until released')
st[0x1C] = 0; kstate()
st[0x39] = 0; kstate()
eq(platform._held_inputs(), 0, 'released: nothing held')
-- 時間が過ぎたら、新しく押した Space はゲームへ
st[0x39] = 0x80; kstate()
eq(st[0x39], 0x80, 'space to the game later'); st[0x39] = 0; kstate()
eq(app.text_keys_now(), nil, 'no text keys now')
print('test_312 ok')
