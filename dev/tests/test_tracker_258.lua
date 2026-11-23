-- 0.1.258：トラッカー手順の本文はテーマの「text」（クラシック／YunaUI は白）。色分けは残す。
require('fake_env')

local settings = require('src.core.settings')
local outline = require('src.ui.crisp_outline')
local theme = require('src.ui.theme')
local W = require('src.ui.widgets')
local CT = require('src.ui.colored_text')
local app = require('src.app')

eq(app.VERSION, '1.1.318', 'version')

-- pack_color(本文の表) は theme.u32('text') と同じ
local packed = outline.pack_color(theme.col('text'), 'text')
eq(packed, theme.u32('text', 1), 'table text packs to u32 text')
eq(outline.pack_color('text'), theme.u32('text', 1), 'name text packs')
eq(outline.pack_color(nil, 'muted'), theme.u32('muted', 1), 'fallback muted')
check(packed ~= theme.u32('npc', 1), 'text is not npc lavender')
check(packed ~= theme.u32('accent', 1), 'text is not accent')

local order = {}
local hook_dl = {
    AddText = function (self, pos, col, text)
        order[#order + 1] = { kind = 'draw', text = text, col = col }
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
    SetCursorPosX = function (x) cursor[1] = x end,
    Dummy = function (sz)
        local w = type(sz) == 'table' and (sz[1] or sz.x) or 0
        cursor[1] = cursor[1] + (tonumber(w) or 0)
    end,
    SameLine = function () end,
    GetContentRegionAvail = function () return 800, 400 end,
    GetFontSize = function () return 16 end,
    GetFont = function () return {} end,
    PushFont = function () end,
    PopFont = function () end,
    CalcTextSize = function (s) return { x = 8 * #tostring(s), y = 16 } end,
    Text = function (text) end,
    TextColored = function (col, text) end,
    TextDisabled = function (text) end,
    InvisibleButton = function (label)
        order[#order + 1] = { kind = 'hit', text = label }
        return false
    end,
    GetItemRectMin = function () return cursor[1] - 8, cursor[2] end,
    GetItemRectMax = function () return cursor[1], cursor[2] + 16 end,
    Measure = function () end,
    IsItemHovered = function () return false end,
    PushStyleVar = function () end,
    PopStyleVar = function () end,
}
theme.measure_text = function (_, s)
    return 8 * #tostring(s), 16
end

local function draw_line(look)
    theme.set_look(look)
    local ui = {
        imgui = hook_im,
        _crisp_pushed = true,
        settings = settings.merge({ font_crisp = true, font_crisp_outline = 1, font_crisp_outline_alpha = 0.85, look = look }),
    }
    outline._reset()
    outline.enter(ui, 'tracker')
    check(outline.active(), 'outline on for ' .. look)
    order, cursor[1], cursor[2] = {}, 40, 80
    local text = 'ゲートガードでミッションを受け、大工房のCidに話す'
    local terms = {}
    CT.add(terms, '大工房', 'zone')
    CT.add(terms, 'Cid', 'npc')
    W.term_line(ui, 'tracker', 'qn_1_cur', text, terms, { color = nil, muted = false, no_focus = true, focus_acts = {} })
    local bodies = {}
    for _, e in ipairs(order) do
        if e.kind == 'draw' then bodies[#bodies + 1] = e end
    end
    -- 縁のあとに本文が並ぶ。本文の色だけ見る
    local by_text = {}
    -- 同じ文言の最後の描画が本文
    local last = {}
    for _, e in ipairs(bodies) do
        last[e.text] = e
    end
    outline.leave()
    return last
end

for _, look in ipairs({ 'classic', 'yunaui', 'sf' }) do
    local last = draw_line(look)
    local body1 = last['ゲートガードでミッションを受け、']
    local zone = last['大工房']
    local mid = last['の']
    local npc = last['Cid']
    local body2 = last['に話す']
    check(body1 ~= nil, look .. ' has body prefix')
    check(zone ~= nil, look .. ' has zone')
    check(npc ~= nil, look .. ' has npc')
    check(body2 ~= nil, look .. ' has body suffix')
    eq(body1.col, theme.u32('text', 1), look .. ' body prefix is text')
    eq(body2.col, theme.u32('text', 1), look .. ' body suffix is text')
    if mid then eq(mid.col, theme.u32('text', 1), look .. ' の is text') end
    eq(zone.col, theme.u32('zone', 1), look .. ' 大工房 is zone')
    eq(npc.col, theme.u32('npc', 1), look .. ' Cid is npc')
    check(body1.col ~= theme.u32('npc', 1), look .. ' body is not npc purple')
end

-- クラシック／YunaUI の本文は白に近い（R,G,B すべて高い）
local function rgb_of_u32(u)
    local r = u % 256
    local g = math.floor(u / 256) % 256
    local b = math.floor(u / 65536) % 256
    return r, g, b
end
theme.set_look('classic')
local r, g, b = rgb_of_u32(theme.u32('text', 1))
check(r > 200 and g > 200 and b > 200, 'classic text is near white')
theme.set_look('yunaui')
r, g, b = rgb_of_u32(theme.u32('text', 1))
check(r > 200 and g > 200 and b > 200, 'yunaui text is near white')
