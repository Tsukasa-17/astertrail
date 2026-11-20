-- 0.1.247：くっきりフォントの縁取り（太さ 0〜3px、濃さ、黒い縁だけ。影なし）
require('fake_env')

local settings = require('src.core.settings')
local outline = require('src.ui.crisp_outline')
local theme = require('src.ui.theme')
local app = require('src.app')
local imgui = require('imgui')

eq(app.VERSION, '1.1.285', 'version')

---------------------------------------------------------------------------
-- 1) 初期値と保存。古い font_outline は使わない
---------------------------------------------------------------------------
local D = settings.defaults()
eq(D.font_crisp_outline, 0, 'default thickness 0')
eq(D.font_crisp_outline_alpha, 0.85, 'default alpha 85%')

local m = settings.merge({})
eq(m.font_crisp_outline, 0, 'missing key stays 0')
eq(m.font_crisp_outline_alpha, 0.85, 'missing alpha stays 85%')

m = settings.merge({ font_outline = 8, font_outline_alpha = 1, font_shadow = true })
eq(m.font_crisp_outline, 0, 'old font_outline 8 is not applied')
eq(m.font_crisp_outline_alpha, 0.85, 'old outline alpha is not applied')

m = settings.merge({ font_crisp_outline = 2.3, font_crisp_outline_alpha = 0.4 })
eq(m.font_crisp_outline, 2.25, 'snapped to 0.25')
eq(m.font_crisp_outline_alpha, 0.4, 'alpha kept')

m = settings.merge({ font_crisp_outline = 9, font_crisp_outline_alpha = 2 })
eq(m.font_crisp_outline, 3, 'clamped to 3')
eq(m.font_crisp_outline_alpha, 1, 'alpha clamped to 1')

m = settings.merge({ font_crisp_outline = 'no', font_crisp_outline_alpha = 'no' })
eq(m.font_crisp_outline, 0, 'junk width -> 0')
eq(m.font_crisp_outline_alpha, 0.85, 'junk alpha -> 85%')

eq(settings.clamp_crisp_outline(nil), 0, 'clamp nil width')
eq(settings.clamp_crisp_outline_alpha(nil), 0.85, 'clamp nil alpha')

---------------------------------------------------------------------------
-- 2) ずらし位置（YunaUI と同じ考え方）
---------------------------------------------------------------------------
eq(#outline.offsets(0), 0, '0: no offsets')
eq(#outline.offsets(-1), 0, 'negative: none')

local o1 = outline.offsets(1)
eq(#o1, 8, '1px: 8 directions')
local seen = {}
for _, d in ipairs(o1) do
    local k = string.format('%d,%d', d[1], d[2])
    seen[k] = true
    check(math.abs(d[1]) <= 1 and math.abs(d[2]) <= 1, '1px unit step: ' .. k)
    check(d[1] ~= 0 or d[2] ~= 0, 'no zero offset')
end
for _, k in ipairs({ '1,0', '-1,0', '0,1', '0,-1', '1,1', '1,-1', '-1,1', '-1,-1' }) do
    check(seen[k], 'has ' .. k)
end

local o2 = outline.offsets(2)
eq(#o2, 24, '2px: 24 points on the circle')
for _, d in ipairs(o2) do
    local r = math.sqrt(d[1] * d[1] + d[2] * d[2])
    check(math.abs(r - 2) < 1e-9, 'radius 2: ' .. r)
end

local o15 = outline.offsets(1.5)
eq(#o15, 8, '1.5px: still 8 points')
local has_axis = false
for _, d in ipairs(o15) do
    if d[2] == 0 and math.abs(d[1] - 1.5) < 1e-9 then has_axis = true end
end
check(has_axis, '1.5 on axis is 1.5px')

---------------------------------------------------------------------------
-- 3) 描画：位置は整数、色は黒 85%、縁取りだけ（本体は Text 側）
---------------------------------------------------------------------------
outline._reset()
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
    CalcTextSize = function (s)
        s = tostring(s or '')
        return { x = #s * 8, y = 16 }
    end,
}

-- 画面の外は飛ばす
eq(outline.paint_at(im, 10, 10, '外', { width = 1, alpha = 0.85 }), 0, 'off-screen skipped')

-- 太さ 0 は描かない
eq(outline.paint_at(im, 120, 130, '今と同じ', { width = 0, alpha = 0.85 }), 0, 'width 0 draws nothing')

adds = {}
local n = outline.paint_at(im, 120.4, 130.4, 'Hello', { width = 1, alpha = 0.85 })
eq(n, 8, '1px paints 8 times')
eq(#adds, 8, '8 AddText')
local black85 = theme.rgba(0, 0, 0, 0.85)
local want = {}
for _, d in ipairs(outline.offsets(1)) do
    want[string.format('%d,%d', math.floor(120.4 + d[1] + 0.5), math.floor(130.4 + d[2] + 0.5))] = true
end
eq(math.floor(120.4 + 0.5), 120, 'round 120.4 -> 120')
local got = {}
for _, a in ipairs(adds) do
    eq(a.text, 'Hello', 'outline uses the same text')
    eq(a.col, black85, 'black at 85%')
    got[string.format('%d,%d', a.x, a.y)] = true
    -- 本体 (120,130) には縁取りを描かない（ずらしだけ）
    check(not (a.x == 120 and a.y == 130), 'outline is offset, not on the glyph')
end
for k in pairs(want) do check(got[k], 'rounded pos ' .. k) end
for k in pairs(got) do check(want[k], 'unexpected pos ' .. k) end

-- 濃さ 40%、太さ 2：16 点、整数位置、色
adds = {}
n = outline.paint_at(im, 200, 200, '幅', { width = 2, alpha = 0.4 })
eq(n, 24, '2px paints 24 times')
local edge40 = theme.rgba(0, 0, 0, 0.4 * 0.80)
for _, a in ipairs(adds) do
    eq(a.col, edge40, '2px edge is slightly faded (40% * 0.80)')
    check(a.x == math.floor(a.x) and a.y == math.floor(a.y), 'integer position')
end

-- 色の nil：落ちずに黒へ戻す
eq(type(outline.color_u32(nil)), 'number', 'nil alpha still a color')
eq(outline.color_u32(nil), black85, 'nil alpha -> 85% black')
eq(outline.color_u32('bad'), black85, 'junk alpha -> 85% black')

-- 折り返し：長い文を 2 行に分け、行ごとに縁取り
adds = {}
-- CalcTextSize: 8px per byte; wrap width 200 -> 25 ASCII chars per line
local long = string.rep('a', 30)
n = outline.paint_at(im, 120, 130, long, { width = 1, alpha = 0.85, wrap = true })
eq(n, 16, 'wrapped two lines: 8+8')
local line1, line2 = long:sub(1, 25), long:sub(26)
local y1, y2 = 0, 0
for _, a in ipairs(adds) do
    if a.text == line1 then y1 = y1 + 1 end
    if a.text == line2 then y2 = y2 + 1 end
end
eq(y1, 8, 'first wrapped line outlined')
eq(y2, 8, 'second wrapped line outlined')
local ys = {}
for _, a in ipairs(adds) do ys[a.y] = true end
local distinct = 0
for _ in pairs(ys) do distinct = distinct + 1 end
check(distinct >= 2, 'second line is shifted down')

---------------------------------------------------------------------------
-- 4) Text のフック：縁取りが先、本体はあと。太さ 0 ではフックしても描かない
---------------------------------------------------------------------------
outline._reset()
local order = {}
local hook_dl = {
    AddText = function (self, pos, col, text)
        order[#order + 1] = { kind = 'outline', text = text, col = col, x = pos[1], y = pos[2] }
    end,
}
local hook_im = {
    GetWindowDrawList = function () return hook_dl end,
    GetFontSize = function () return 16 end,
    GetWindowPos = function () return 0, 0 end,
    GetWindowSize = function () return 800, 600 end,
    GetCursorScreenPos = function () return 40, 40 end,
    GetContentRegionAvail = function () return 400, 400 end,
    CalcTextSize = function (s) return { x = 16, y = 16 } end,
    Text = function (text) order[#order + 1] = { kind = 'body', text = text } end,
    TextColored = function (col, text) order[#order + 1] = { kind = 'body', text = text } end,
}
local ui = { imgui = hook_im, _crisp_pushed = true, settings = settings.merge({ font_crisp_outline = 1, font_crisp_outline_alpha = 0.85 }) }
outline.enter(ui, 'tracker')
eq(outline.active(), true, 'enter tracker activates')
hook_im.Text('本文')
check(#order == 9, '8 outline + 1 body')
for i = 1, 8 do eq(order[i].kind, 'outline', 'outline first ' .. i) end
eq(order[9].kind, 'body', 'body last')
eq(order[9].text, '本文', 'body text kept')
eq(order[1].col, black85, 'hook uses 85% black')

outline.leave()
eq(outline.active(), false, 'leave deactivates')
local n_before = #order
hook_im.Text('あと')
eq(#order, n_before + 1, 'after leave: body only')
eq(order[#order].kind, 'body', 'no outline when inactive')

-- 対象外の窓（地図）では付けない
outline.enter({ imgui = hook_im, settings = ui.settings }, 'map')
eq(outline.active(), false, 'map is not a crisp window')

-- 本でも有効
outline.enter(ui, 'book')
eq(outline.active(), true, 'book activates')
outline.leave()

---------------------------------------------------------------------------
-- 5) 設定の項目が出る。太さ 0 の初期では描画は今までどおり
---------------------------------------------------------------------------
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(addon.version, app.VERSION, 'lua matches')
eq(S.font_crisp_outline, 0, 'live default 0')
eq(S.font_crisp_outline_alpha, 0.85, 'live default 85%')
app.open_window('settings'); frame(); frame(); frame()
require('src.ui.settings_ui').select_tab('look'); frame(); frame()
local function seen_ui(pat)
    for _, l in ipairs(FAKE.labels) do if l:find(pat, 1, true) then return true end end
    for _, l in ipairs(FAKE.texts) do if l:find(pat, 1, true) then return true end end
    return false
end
check(seen_ui('くっきりフォント（テスト）'), 'crisp toggle still shown')
check(seen_ui('縁取りの太さ'), 'outline width shown')
check(seen_ui('縁取りの濃さ'), 'outline alpha shown')
check(not seen_ui('縁取りと影'), 'old fx fold not back')
