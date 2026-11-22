-- 0.1.300: 右よせのスライダーの行は、値の文字（0 px／-64 px／-128 px）に関係なく同じ位置にそろう
require('fake_env')
local W = require('src.ui.widgets')
local imgui = package.loaded['imgui']
local keep = {}
local names = { 'GetCursorScreenPos', 'SetCursorScreenPos', 'InvisibleButton', 'Button', 'Text', 'Dummy', 'SameLine',
    'BeginGroup', 'EndGroup', 'CalcTextSize', 'GetItemRectMin', 'GetItemRectMax', 'SliderFloat', 'SetNextItemWidth', 'GetFrameHeight', 'TextColored' }
for _, k in ipairs(names) do keep[k] = imgui[k] end
local cx, cy, line_x = 100, 50, 100
local last = { 100, 50, 100, 50 }
local groups, next_w = {}, 100
local resets = {}
local function tw(s) s = tostring(s or ''):gsub('##.*$', ''); local w = 0
    local i = 1
    while i <= #s do local b = s:byte(i); local st = (b < 128 and 1) or (b < 224 and 2) or (b < 240 and 3) or 4
        w = w + ((b < 128) and 8 or 16); i = i + st end
    return w end
-- 測る幅と描く幅を同じにする（実機の ImGui と同じ）
imgui.CalcTextSize = function (s) return tw(s), 16 end
local function item(w, h)
    last = { cx, cy, cx + w, cy + h }
    for _, g in ipairs(groups) do g[3] = math.max(g[3], cx + w); g[4] = math.max(g[4], cy + h) end
    cx, cy = line_x, cy + h + 4
end
imgui.GetFrameHeight = function () return 20 end
imgui.GetCursorScreenPos = function () return { cx, cy } end
imgui.SetCursorScreenPos = function (p) cx, cy = p[1], p[2] end
imgui.SameLine = function (off, sp) cx, cy = last[3] + (sp or 8), last[2] end
imgui.InvisibleButton = function (label, size)
    if tostring(label):find('_reset', 1, true) then resets[#resets + 1] = cx end
    item(size[1], size[2]); return false end
imgui.Button = function (label) item(tw(label) + 8, 20); return false end
local text_log = {}
imgui.Text = function (s) text_log[#text_log + 1] = { s = s, x1 = cx, x2 = cx + tw(s) }; item(tw(s), 16) end
imgui.TextColored = function (_, s) item(tw(s), 16) end
imgui.Dummy = function (size) item(size[1], size[2]) end
imgui.SetNextItemWidth = function (w) next_w = w end
local slider_ws = {}
imgui.SliderFloat = function () slider_ws[#slider_ws + 1] = next_w; item(next_w, 20); return false end
imgui.BeginGroup = function () groups[#groups + 1] = { cx, cy, cx, cy, line_x }; line_x = cx end
imgui.EndGroup = function () local g = table.remove(groups); line_x = g[5]; last = { g[1], g[2], g[3], g[4] }; cx, cy = line_x, g[4] + 4 end
imgui.GetItemRectMin = function () return { last[1], last[2] } end
imgui.GetItemRectMax = function () return { last[3], last[4] } end

local fui = { imgui = imgui, t = function (k) return k end }
local function row(id, v)
    cx, cy, line_x = 100, 50, 100
    W.slider(fui, 'settings', id, '名前の位置（上下）', { v = v }, 'v', { step = 1, lo = -128, hi = 128, default = 0,
        text = function (x) return string.format('%d px', x) end,
        form_right = true, form_inner = 420, form_gap = 12, form_value_w = 72, section = 'page', slider_w = 120 })
end
for frame_no = 1, 3 do
    resets = {}
    row('a', 0); row('b', -64); row('c', -128); row('d', 8)
end
-- 0.1.301：値の右端（単位）と数の右端も、値に関係なくそろう
local function value_edges(v)
    text_log = {}
    row('e' .. tostring(v), v)
    local u, n
    for _, e in ipairs(text_log) do
        if e.s == 'px' then u = e end
        if e.s:match('^[%+%-]?%d+$') then n = e end
    end
    return u and u.x2, n and n.x2
end
for _ = 1, 2 do value_edges(0); value_edges(-64); value_edges(-128); value_edges(8); value_edges(100) end
local u0, n0 = value_edges(0)
for _, v in ipairs({ -64, -128, 8, 100 }) do
    local u, n = value_edges(v)
    eq(u, u0, 'unit right edge same for ' .. v)
    eq(n, n0, 'number right edge same for ' .. v)
end
eq(resets[1], resets[2], '0 px and -64 px line up')
eq(resets[2], resets[3], '-64 px and -128 px line up')
eq(resets[3], resets[4], '-128 px and 8 px line up')
-- 値の列は右端で終わる（値は右よせ）
check(W._ctrl_w_cache['settings/a'] == W._ctrl_w_cache['settings/c'], 'same cluster width for every value')
-- 0.1.300：箱で決めたスライダーの幅（form_slider_w）をそのまま使う
slider_ws = {}
cx, cy, line_x = 100, 50, 100
W.slider(fui, 'settings', 'w1', '幅', { v = 0 }, 'v', { step = 1, lo = 0, hi = 10, default = 0,
    text = function (x) return x .. ' px' end, form_right = true, form_inner = 600, form_gap = 12,
    form_value_w = 72, form_slider_w = 210, section = 'page', slider_w = 120 })
eq(slider_ws[#slider_ws], 210, 'slider uses the box width')
for k, v in pairs(keep) do imgui[k] = v end

-- 0.1.301：tonumber(select(1, measure_text(...))) は高さが「進数」に入り、幅が16進で読まれる（小数の幅だと nil）。
-- src に残っていないこと
for _, f in ipairs({ 'src/ui/widgets.lua', 'src/ui/settings_sf.lua', 'src/ui/notices_sf.lua', 'src/ui/map_sf.lua', 'src/ui/update_popup.lua' }) do
    local fh = io.open(ROOT .. '/' .. f, 'r'); local src = fh:read('*a'); fh:close()
    check(not src:find('tonumber(select(1,', 1, true), 'no tonumber(select(1, ...)) in ' .. f)
end
