-- 0.1.252：混在する行は縁を全部先に、本文を全部あとに。リンクは背景箱を出さない。
require('fake_env')

local settings = require('src.core.settings')
local outline = require('src.ui.crisp_outline')
local theme = require('src.ui.theme')
local W = require('src.ui.widgets')
local app = require('src.app')

eq(app.VERSION, '1.1.314', 'version')

local order = {}
local hook_dl = {
    AddText = function (self, pos, col, text)
        order[#order + 1] = { kind = 'draw', text = text, x = pos and pos[1], y = pos and pos[2], col = col }
    end,
}
local cursor = { 40, 80 }
local hook_im = {
    GetWindowDrawList = function () return hook_dl end,
    GetWindowPos = function () return 0, 0 end,
    GetWindowSize = function () return 800, 600 end,
    GetCursorScreenPos = function () return cursor[1], cursor[2] end,
    GetCursorPosX = function () return cursor[1] end,
    GetCursorPosY = function () return cursor[2] end,
    SetCursorPos = function (v)
        if type(v) == 'table' then cursor[1], cursor[2] = v[1] or v.x, v[2] or v.y end
    end,
    Dummy = function (sz)
        local w = type(sz) == 'table' and (sz[1] or sz.x) or 0
        cursor[1] = cursor[1] + (tonumber(w) or 0)
    end,
    SameLine = function () end,
    GetContentRegionAvail = function () return 400, 400 end,
    GetFontSize = function () return 16 end,
    GetFont = function () return {} end,
    PushFont = function () end,
    PopFont = function () end,
    CalcTextSize = function (s) return { x = 8 * #tostring(s), y = 16 } end,
    Text = function (text) order[#order + 1] = { kind = 'body', text = text } end,
    TextColored = function (col, text) order[#order + 1] = { kind = 'body', text = text } end,
    TextDisabled = function (text) order[#order + 1] = { kind = 'body', text = text } end,
    InvisibleButton = function (label) order[#order + 1] = { kind = 'hit', text = label }; return false end,
    GetItemRectMin = function () return cursor[1] - 24, cursor[2] end,
    GetItemRectMax = function () return cursor[1], cursor[2] + 16 end,
    Measure = function () end,
}
theme.measure_text = function (_, s)
    return 8 * #tostring(s), 16
end

local ui = {
    imgui = hook_im,
    _crisp_pushed = true,
    settings = settings.merge({ font_crisp = true, font_crisp_outline = 1, font_crisp_outline_alpha = 0.85 }),
}

outline._reset()
outline.enter(ui, 'tracker')
eq(outline.active(), true, 'tracker outline on')

-- 行パス：先に縁、あとに本文（「の」「Cid」「に」が隣り合う）
order, cursor[1], cursor[2] = {}, 40, 80
W.line_pass(hook_im, function ()
    theme.TextDisabled(hook_im, 'の')
    hook_im.SameLine()
    theme.TextColored(hook_im, { 0.6, 0.9, 1, 1 }, 'Cid')
    hook_im.SameLine()
    theme.TextDisabled(hook_im, 'に')
end)
local texts = {}
for _, e in ipairs(order) do
    if e.kind == 'draw' or e.kind == 'body' then texts[#texts + 1] = e.text end
end
-- 縁は各片 8 方向。本文 3 片は最後にまとまる
local first_body
for i, e in ipairs(order) do
    if e.kind == 'body' or (e.kind == 'draw' and e.text and not first_body and false) then
    end
end
-- paint_at は kind=draw（AddText）。本文も line_end で AddText するので kind=draw。
-- 順序：の縁×8、Cid縁×8、に縁×8、の本文、Cid本文、に本文
local names = {}
for _, e in ipairs(order) do
    if e.kind == 'draw' then names[#names + 1] = e.text end
end
check(#names == 8 + 8 + 8 + 3, '8 outlines each + 3 bodies: ' .. tostring(#names))
eq(names[1], 'の', 'first outline is の')
eq(names[9], 'Cid', 'Cid outlines after の')
eq(names[17], 'に', 'に outlines after Cid')
eq(names[25], 'の', 'bodies start with の')
eq(names[26], 'Cid', 'then Cid body')
eq(names[27], 'に', 'then に body')

-- リンクは Selectable ではなく InvisibleButton（背景箱なし）
order = {}
local clicked = W.link({ imgui = hook_im, settings = ui.settings }, 'tracker', 'npc', 'Cid', { color = 'npc', no_focus = true })
local kinds = {}
for _, e in ipairs(order) do kinds[#kinds + 1] = e.kind end
local joined = table.concat(kinds, ',')
check(joined:find('hit', 1, true), 'link uses InvisibleButton')
check(not joined:find('sel', 1, true), 'link does not use Selectable')

outline.leave()
