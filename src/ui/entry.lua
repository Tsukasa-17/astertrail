-- Astertrail - 入口アイコン（本を閉じている時の小さな独自アイコン。クリックで本を開く）

local window = require('src.ui.window')
local theme = require('src.ui.theme')
local focus = require('src.ui.focus')

local entry = {}

function entry.draw(ui)
    local imgui, t = ui.imgui, ui.t
    local name = 'entry'
    local drawing = window.begin(ui, name, { title = 'entry', no_title = true, no_focus = true })
    if drawing then
        local size = 30 * (ui.settings.font_scale or 1)
        local x, y = imgui.GetCursorScreenPos()
        local clicked = imgui.InvisibleButton('##astertrail_entry', { size, size })
        local hovered = imgui.IsItemHovered()
        local dl = imgui.GetWindowDrawList()
        -- 自作の小さな本の形（四角2つと綴じ目、星の代わりの小さな菱形）
        local c = theme.u32(hovered and 'gold' or 'text', hovered and 1.0 or 0.85)
        local m = size * 0.18
        dl:AddRect({ x + m, y + m }, { x + size / 2, y + size - m }, c, 2, 0, 1.5)
        dl:AddRect({ x + size / 2, y + m }, { x + size - m, y + size - m }, c, 2, 0, 1.5)
        dl:AddLine({ x + size / 2, y + m }, { x + size / 2, y + size - m }, c, 1.5)
        local cx, cy, r = x + size * 0.75, y + size * 0.42, size * 0.08
        dl:AddQuadFilled({ cx, cy - r }, { cx + r, cy }, { cx, cy + r }, { cx - r, cy }, theme.u32('gold', 0.95))
        if hovered then
            imgui.SetTooltip(t('entry.tooltip'))
            theme.draw_focus(imgui, x, y, x + size, y + size, ui.reduce_motion)
        end
        if clicked then ui.open_window('book') end
    end
    window.finish(ui, name)
end

return entry
