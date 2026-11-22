-- 0.1.307：つかめる線（一覧と詳細の境目・列の境目）。実機の描画リストは userdata。
-- table だけ受けていたため線が一度も描かれていなかった。今の窓の描画リストを先に使う
require('fake_env')
local theme = require('src.ui.theme')
local drawn = {}
local proxy = newproxy(true)
local mt = getmetatable(proxy)
local methods = {
    AddRectFilled = function (self, a, b, col, r) drawn[#drawn + 1] = { a = a, b = b, col = col } end,
}
mt.__index = methods
check(type(proxy) == 'userdata', 'proxy is userdata')
local fg_used = false
local imgui = {
    GetWindowDrawList = function () return proxy end,
    GetForegroundDrawList = function () fg_used = true; return proxy end,
    SetMouseCursor = function () end,
}
eq(theme.resize_rail_drawlist(imgui), proxy, 'userdata draw list accepted')
check(not fg_used, 'window draw list first')
theme.draw_resize_rail(imgui, 50, 10, 200, false, false)
eq(#drawn, 1, 'idle: thin line drawn')
drawn = {}
theme.draw_resize_rail(imgui, 50, 10, 200, true, false)
eq(#drawn, 2, 'hover: glow and line')
drawn = {}
theme.draw_resize_rail(imgui, 50, 10, 200, false, true)
eq(#drawn, 2, 'drag: glow and line')
-- 窓の描画リストが無ければ前景
local imgui2 = { GetForegroundDrawList = function () return proxy end }
eq(theme.resize_rail_drawlist(imgui2), proxy, 'foreground fallback')
dofile(ROOT .. '/astertrail.lua')
local app = require('src.app')
eq(app.VERSION, app.VERSION, 'version')

-- 行をまとめて描いている途中のツールチップ：中の文字は行に積まない。終わったら行に戻る
do
    local outline = require('src.ui.crisp_outline')
    local item_tip = require('src.ui.item_tip')
    local W = require('src.ui.widgets')
    local seen_in_line = {}
    local fake = setmetatable({
        BeginTooltip = function () return true end,
        EndTooltip = function () end,
        TextColored = function (c, t) seen_in_line[#seen_in_line + 1] = outline.in_line() end,
        Text = function (t) seen_in_line[#seen_in_line + 1] = outline.in_line() end,
        TextWrapped = function (t) seen_in_line[#seen_in_line + 1] = outline.in_line() end,
        TextUnformatted = function (t) seen_in_line[#seen_in_line + 1] = outline.in_line() end,
    }, { __index = function () return nil end })
    outline.line_begin()
    item_tip.draw({ imgui = fake, t = function (k) return k end }, { kind = 'item', name = '火打石', description = '火を起こすのに適した石。' })
    check(#seen_in_line >= 2, 'tooltip text drawn')
    for i, v in ipairs(seen_in_line) do check(v == false, 'item tip line ' .. i .. ' not queued') end
    check(outline.in_line(), 'line resumed after item tip')
    seen_in_line = {}
    W.tooltip({ imgui = fake }, 'せつめい')
    for i, v in ipairs(seen_in_line) do check(v == false, 'W.tooltip line ' .. i .. ' not queued') end
    check(outline.in_line(), 'line resumed after W.tooltip')
    outline.line_end(nil)
    check(not outline.in_line(), 'line ended')
end

-- アストラルの詳細：SetNextItemAllowOverlap が無い実機では行の当たりを置かず、名前のクリックで地図が開く
do
    FAKE.events.load()
    FAKE.player = { name = 'R307', zone = 230, tidx = 5, status = 0 }
    frames(1)
    local S = app._settings()
    S.look = 'sf'
    theme.set_look('sf')
    local imgui = package.loaded['imgui']
    local saved_next = rawget(imgui, 'SetNextItemAllowOverlap')
    imgui.SetNextItemAllowOverlap = false
    local Qe, s02 = 'quest.bastok.003', 'quest.bastok.003#g02'
    app.request('set_current_step', Qe, s02)
    app.state.open.map = false
    app.open_detail_solo(Qe)
    FAKE.labels = {}
    frame(); frame()
    check(app.state.open.detail, 'astral detail solo open')
    check(not labeled('##sfstep_' .. s02), 'no row hit without SetNextItemAllowOverlap')
    check(labeled('???'), '??? link in astral detail')
    FAKE.clicks['???'] = true
    frame(); frame()
    check(app.state.open.map, '??? in astral detail opens map')
    eq(app.state.map and app.state.map.quest, Qe, 'map is that quest')
    imgui.SetNextItemAllowOverlap = saved_next
end
