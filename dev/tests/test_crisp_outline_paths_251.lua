-- 0.1.251：縁取りは本のミッション・クエスト一覧と同じ（Text* のカーソル位置）。Button はフックしない。
require('fake_env')

local settings = require('src.core.settings')
local outline = require('src.ui.crisp_outline')
local theme = require('src.ui.theme')

local order = {}
local hook_dl = {
    AddText = function (self, pos, col, text)
        order[#order + 1] = { kind = 'outline', text = text, x = pos and pos[1], y = pos and pos[2] }
    end,
}
local cursor = { 40, 80 }
local hook_im = {
    GetWindowDrawList = function () return hook_dl end,
    GetWindowPos = function () return 0, 0 end,
    GetWindowSize = function () return 800, 600 end,
    GetCursorScreenPos = function () return cursor[1], cursor[2] end,
    GetContentRegionAvail = function () return 400, 400 end,
    GetFontSize = function () return 16 end,
    GetFont = function () return {} end,
    PushFont = function () end,
    PopFont = function () end,
    CalcTextSize = function (s) return { x = 16, y = 16 } end,
    Text = function (text) order[#order + 1] = { kind = 'body', text = text } end,
    TextColored = function (col, text) order[#order + 1] = { kind = 'body', text = text } end,
    Button = function (label) order[#order + 1] = { kind = 'button', text = label } end,
    SmallButton = function (label) order[#order + 1] = { kind = 'button', text = label } end,
    Selectable = function (label) order[#order + 1] = { kind = 'sel', text = label } end,
}
local ui = {
    imgui = hook_im,
    _crisp_pushed = true,
    settings = settings.merge({ font_crisp = true, font_crisp_outline = 1, font_crisp_outline_alpha = 0.85 }),
}

outline._reset()
outline.enter(ui, 'book')
eq(outline.active(), true, 'book outline on')

order = {}
theme.TextColored(hook_im, { 1, 1, 1, 1 }, 'クエスト名')
check(#order >= 9, 'text path: outline then body')
eq(order[1].kind, 'outline', 'outline first')
eq(order[#order].kind, 'body', 'body last')
eq(order[#order].text, 'クエスト名', 'body is the name')
check(math.abs((order[1].x or 0) - 40) <= 1 and math.abs((order[1].y or 0) - 80) <= 1, 'outline at cursor, not padded')

order = {}
hook_im.Button('設定タブ##st_look')
local kinds = {}
for _, e in ipairs(order) do kinds[#kinds + 1] = e.kind end
local joined = table.concat(kinds, ',')
eq(joined, 'button', 'Button itself is not hooked for outline')

order = {}
hook_im.SmallButton('名前##link')
eq(table.concat((function ()
    local k = {}
    for _, e in ipairs(order) do k[#k + 1] = e.kind end
    return k
end)(), ','), 'button', 'SmallButton is not hooked')

outline.enter(ui, 'popup')
eq(outline.active(), true, 'popup uses the same outline')
outline.enter(ui, 'resume')
eq(outline.active(), true, 'resume uses the same outline')
outline.enter({ imgui = hook_im, _crisp_pushed = true, settings = ui.settings }, 'map')
eq(outline.active(), false, 'map stays without body outline (grid letters)')
outline.leave()
