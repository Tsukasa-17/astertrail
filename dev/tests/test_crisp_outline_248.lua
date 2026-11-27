-- 0.1.248：縁取りをなめらかに（点数を増やす、3px は内側も塗る、端の濃さを下げる、回数の上限）
require('fake_env')

local settings = require('src.core.settings')
local outline = require('src.ui.crisp_outline')
local theme = require('src.ui.theme')
local app = require('src.app')
local imgui = require('imgui')

eq(app.VERSION, '1.1.327', 'version')
eq(outline.MAX_POINTS, 64, 'cap is 64')
eq(outline.EDGE_MUL, 0.80, 'edge fade 80%')

---------------------------------------------------------------------------
-- 1) ずらし位置と回数
---------------------------------------------------------------------------
eq(#outline.offsets(1), 8, '1px stays 8')
eq(outline.circle_n(1.5), 8, '1.5 uses 8')
eq(#outline.offsets(1.5), 8, '1.5 still 8 points')

eq(outline.circle_n(1.75), 24, 'just above 1.5 -> 24')
eq(outline.circle_n(2), 24, '2px -> 24')
eq(outline.circle_n(2.5), 24, '2.5 -> 24')
eq(outline.circle_n(2.75), 32, '2.75 -> 32')
eq(outline.circle_n(3), 32, '3px outer 32')

local o2 = outline.offsets(2)
eq(#o2, 24, '2px: 24 points')
check(#o2 <= outline.MAX_POINTS, '2px under cap')
for _, d in ipairs(o2) do
    local r = math.sqrt(d[1] * d[1] + d[2] * d[2])
    check(math.abs(r - 2) < 1e-9, '2px radius 2')
    eq(d[3], outline.EDGE_MUL, '2px is the outer edge')
end

local o275 = outline.offsets(2.75)
eq(#o275, 32, '2.75: 32 points, no inner fill yet')
for _, d in ipairs(o275) do
    local r = math.sqrt(d[1] * d[1] + d[2] * d[2])
    check(math.abs(r - 2.75) < 1e-9, '2.75 radius')
end

local o3 = outline.offsets(3)
eq(#o3, 64, '3px: 8+24+32 = 64')
check(#o3 <= outline.MAX_POINTS, '3px at cap')
local n1, n2, n3 = 0, 0, 0
local inner_mul, outer_mul = 0, 0
for _, d in ipairs(o3) do
    local r = math.sqrt(d[1] * d[1] + d[2] * d[2])
    if math.abs(r - 1) < 1e-6 or (math.abs(math.abs(d[1]) - 1) < 1e-6 and math.abs(math.abs(d[2]) - 1) < 1e-6 and math.abs(r - math.sqrt(2)) < 1e-6) then
        -- 1px ring: axis r=1 or diagonal r=sqrt(2)
        if math.abs(r - 1) < 1e-6 or math.abs(r - math.sqrt(2)) < 1e-6 then
            if math.abs(r - 1) < 1e-6 or (math.abs(d[1]) == 1 and math.abs(d[2]) == 1) then
                if math.abs(r - math.sqrt(2)) < 1e-6 or math.abs(r - 1) < 1e-6 then
                    -- classify more simply below
                end
            end
        end
    end
    if math.abs(r - 2) < 1e-6 then
        n2 = n2 + 1
        inner_mul = d[3]
    elseif math.abs(r - 3) < 1e-6 then
        n3 = n3 + 1
        outer_mul = d[3]
    else
        n1 = n1 + 1
        eq(d[3], 1, '1px inner full alpha')
    end
end
eq(n1, 8, '3px inner 1px ring: 8')
eq(n2, 24, '3px inner 2px ring: 24')
eq(n3, 32, '3px outer 3px ring: 32')
eq(inner_mul, 1, 'inner 2px full alpha')
eq(outer_mul, outline.EDGE_MUL, 'outer 3px faded')

---------------------------------------------------------------------------
-- 2) 描画：回数、整数位置、端の色、画面外は飛ばす
---------------------------------------------------------------------------
local adds = {}
local dl = {
    AddText = function (self, pos, col, text)
        adds[#adds + 1] = {
            x = pos and (pos[1] or pos.x),
            y = pos and (pos[2] or pos.y),
            col = col,
            text = text,
        }
    end,
}
local im = {
    GetWindowDrawList = function () return dl end,
    GetFontSize = function () return 16 end,
    GetWindowPos = function () return 100, 100 end,
    GetWindowSize = function () return 400, 300 end,
    GetCursorScreenPos = function () return 120, 130 end,
    GetContentRegionAvail = function () return 200, 200 end,
    CalcTextSize = function (s) return { x = 16, y = 16 } end,
}

eq(outline.paint_at(im, 10, 10, '外', { width = 3, alpha = 0.85 }), 0, 'off-screen skipped')

adds = {}
local n = outline.paint_at(im, 200, 200, '平滑', { width = 3, alpha = 0.85 })
eq(n, 64, '3px paints 64 times')
eq(#adds, 64, '64 AddText')
check(n <= outline.MAX_POINTS, 'paint respects cap')

local black = theme.rgba(0, 0, 0, 0.85)
local faded = theme.rgba(0, 0, 0, 0.85 * 0.80)
local full_n, fade_n = 0, 0
for _, a in ipairs(adds) do
    eq(a.text, '平滑', 'same text')
    check(a.x == math.floor(a.x) and a.y == math.floor(a.y), 'integer position')
    if a.col == faded then fade_n = fade_n + 1
    elseif a.col == black then full_n = full_n + 1
    else error('unexpected color ' .. tostring(a.col)) end
end
eq(full_n, 8 + 24, 'inner rings full 85%')
eq(fade_n, 32, 'outer ring faded')

-- 丸めた位置が、ずらしを整数にしたものと一致する
local want = {}
for _, d in ipairs(outline.offsets(3)) do
    want[string.format('%d,%d', math.floor(200 + d[1] + 0.5), math.floor(200 + d[2] + 0.5))] = true
end
for _, a in ipairs(adds) do
    check(want[string.format('%d,%d', a.x, a.y)], 'rounded pos recorded')
end

adds = {}
n = outline.paint_at(im, 200, 200, '二', { width = 2, alpha = 0.85 })
eq(n, 24, '2px paints 24')
for _, a in ipairs(adds) do
    eq(a.col, faded, '2px only has the faded edge')
end

-- 壊れた色でも落ちない
eq(type(outline.color_u32(nil)), 'number', 'nil-safe color')

---------------------------------------------------------------------------
-- 3) 設定の初期はこれまでどおり太さ 0。版が揃う
---------------------------------------------------------------------------
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(addon.version, app.VERSION, 'lua matches')
eq(app._settings().font_crisp_outline, 0, 'default thickness still 0')
