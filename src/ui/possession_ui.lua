--[[
  Astertrail - 所持の表示（0.1.184〜、t297）。詳細の手順とトラッカーで使う。
  足りていれば「○」、足りなければ「所持数/必要数」、だいじなものは「○／未所持」。
  持っている品（または未確認の入れ物がある品）に乗せると、どこにいくつあるかを出す（例：かばん2・金庫3）。
]]
local poss = require('src.core.possession')
local theme = require('src.ui.theme')
local CT = require('src.ui.colored_text')

local M = {}

-- 必要の欄ごとの { text, color, tip, state }
function M.segments(ui, needs)
    local t = ui.t
    local out = {}
    local many = #needs > 1
    for _, n in ipairs(needs) do
        local s = ui.need_possession and ui.need_possession(n) or { state = 'unknown' }
        local st = poss.text(t, s)
        local text = many and t('poss.seg', { name = n.name_ja or n.name_en or '?', state = st }) or st
        out[#out + 1] = { text = text, color = poss.color(s), tip = poss.where(t, s), state = s.state }
    end
    return out
end

function M.all_unknown(segs)
    for _, g in ipairs(segs) do if g.state ~= 'unknown' then return false end end
    return true
end

local function draw_one(ui, g)
    local imgui = ui.imgui
    if g.color then imgui.TextColored(theme.col(g.color), g.text) else imgui.TextDisabled(g.text) end
    if g.tip and imgui.IsItemHovered and imgui.IsItemHovered() and imgui.SetTooltip then imgui.SetTooltip(g.tip) end
end

-- 1 行に並べる（幅が足りなければ次の行へ）。先頭に「所持:」
function M.draw_inline(ui, needs)
    local t = ui.t
    local segs = M.segments(ui, needs)
    if #segs == 0 then return end
    local imgui = ui.imgui
    if M.all_unknown(segs) then imgui.TextDisabled(t('need.possession_unknown')); return end
    imgui.TextDisabled(t('poss.label'))
    local okw, av = pcall(imgui.GetContentRegionAvail)
    local avail = okw and (type(av) == 'table' and tonumber(av.x or av[1]) or tonumber(av)) or nil
    local used = CT.text_w(imgui, t('poss.label')) or 0
    for i, g in ipairs(segs) do
        local w = CT.text_w(imgui, g.text) or 0
        if i > 1 then
            imgui.SameLine(); imgui.TextDisabled(t('poss.sep_between'))
            used = used + (CT.text_w(imgui, t('poss.sep_between')) or 0) + 8
        end
        if avail and used + w + 8 > avail and i > 1 then used = 0 else imgui.SameLine() end
        draw_one(ui, g)
        used = used + w + 8
    end
end

-- 1 品 1 行（トラッカー）。push_w(幅) で右そろえ。どれも未確認なら何も出さない
function M.draw_lines(ui, needs, push_w)
    local segs = M.segments(ui, needs)
    if #segs == 0 or M.all_unknown(segs) then return false end
    local t = ui.t
    for _, g in ipairs(segs) do
        g.text = t('poss.label') .. g.text
        if push_w then push_w(CT.text_w(ui.imgui, g.text)) end
        draw_one(ui, g)
    end
    return true
end

return M
