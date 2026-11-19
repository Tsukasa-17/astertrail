-- 0.1.251：くっきりオフでは縁を描かない。オン（PushFont 経路）のときだけ付ける。
require('fake_env')

local settings = require('src.core.settings')
local outline = require('src.ui.crisp_outline')
local app = require('src.app')

eq(app.VERSION, '1.1.260', 'version')

local order = {}
local hook_dl = {
    AddText = function (self, pos, col, text)
        order[#order + 1] = { kind = 'outline', text = text }
    end,
}
local hook_im = {
    GetWindowDrawList = function () return hook_dl end,
    GetFontSize = function () return 36 end,
    GetFont = function () return { name = 'f' } end,
    PushFont = function () end,
    PopFont = function () end,
    GetWindowPos = function () return 0, 0 end,
    GetWindowSize = function () return 800, 600 end,
    GetCursorScreenPos = function () return 40, 40 end,
    GetContentRegionAvail = function () return 400, 400 end,
    CalcTextSize = function (s) return { x = 16, y = 16 } end,
    Text = function (text) order[#order + 1] = { kind = 'body', text = text } end,
}

-- くっきりオフ：倍率経路。縁は付けない（巨大化を避ける）
outline._reset()
local ui_off = {
    imgui = hook_im,
    _crisp_pushed = false,
    settings = settings.merge({ font_crisp = false, font_crisp_outline = 3, font_crisp_outline_alpha = 0.85 }),
}
outline.enter(ui_off, 'tracker')
eq(outline.active(), false, 'crisp off: outline not active')
order = {}
hook_im.Text('オフ')
eq(#order, 1, 'crisp off: body only')
eq(order[1].kind, 'body', 'no outline when crisp off')
outline.leave()

-- 設定はオンでも、フォールバック（PushFont していない）なら付けない
outline._reset()
local ui_fb = {
    imgui = hook_im,
    _crisp_pushed = false,
    settings = settings.merge({ font_crisp = true, font_crisp_outline = 3, font_crisp_outline_alpha = 0.85 }),
}
outline.enter(ui_fb, 'compass')
eq(outline.active(), false, 'fallback scale path: no outline')
order = {}
hook_im.Text('倍率')
eq(#order, 1, 'fallback: body only')
outline.leave()

-- くっきりオン（PushFont 済み）：縁を付ける
outline._reset()
local ui_on = {
    imgui = hook_im,
    _crisp_pushed = true,
    settings = settings.merge({ font_crisp = true, font_crisp_outline = 3, font_crisp_outline_alpha = 0.85 }),
}
outline.enter(ui_on, 'tracker')
eq(outline.active(), true, 'crisp on: outline active')
order = {}
hook_im.Text('オン')
check(#order > 1, 'crisp on: outline + body')
eq(order[1].kind, 'outline', 'outline first when crisp on')
eq(order[#order].kind, 'body', 'body last when crisp on')
outline.leave()
eq(outline.active(), false, 'leave still deactivates')
