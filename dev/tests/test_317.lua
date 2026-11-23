-- 0.1.317：文字の透明度（1 つ、始めと終わりの両方に効く）。0% 透けない／100% 見えない。
-- 0.1.315〜316 の色ごとの不透明度は、始めの色の値から読み替える。
require('harness')
local settings = require('src.core.settings')
local ext = require('src.platform.vanacore_ext')
local app = require('src.app')
eq(app.VERSION, '1.1.324', 'version')

-- 1) 初期値と読み替え
local d = settings.defaults()
eq(d.marks.label_clear, 0, 'default label clear')
eq(d.marks.under_clear, 0, 'default under clear')
eq(d.marks.label_color_a, nil, 'no per-color opacity default')
local m = settings.merge({ marks = { under_color_a = 0, under_color2_a = 1, under_grad = true, under_grad_dir = 'down' } }).marks
eq(m.under_clear, 1, 'opacity 0 -> clear 100%')
eq(m.under_color_a, nil, 'old key dropped'); eq(m.under_color2_a, nil, 'old key 2 dropped')
eq(m.label_clear, 0, 'label untouched')
m = settings.merge({ marks = { label_color_a = 0.3, label_color2_a = 0.9 } }).marks
eq(m.label_clear, 0.7, 'start color value used (1 - 0.3)')
m = settings.merge({ marks = { label_color2_a = 0.2 } }).marks
eq(m.label_clear, 0, 'only the end color: start was opaque -> 0')
m = settings.merge({ marks = { label_clear = 0.25, label_color_a = 0 } }).marks
eq(m.label_clear, 0.25, 'new key wins')
eq(settings.merge({ marks = { label_clear = 'x', under_clear = 7 } }).marks.label_clear, 0, 'broken -> 0')
eq(settings.merge({ marks = { under_clear = 7 } }).marks.under_clear, 1, 'clamped high')
eq(settings.merge({ marks = { under_clear = -1 } }).marks.under_clear, 0, 'clamped low')
local old = settings.merge({ marks = { label_grad = true } }).marks
local o1, o2 = settings.text_colors(old, 'label')
eq(o1[4], nil, 'old look: no alpha'); eq(o2[4], nil, 'old look: no alpha 2')
local half = settings.merge({ marks = { label_grad = true, label_clear = 0.5 } }).marks
local h1, h2 = settings.text_colors(half, 'label')
eq(h1[4], 128, 'half: start'); eq(h2[4], 128, 'half: end same')

-- 2) 文字の箱に渡すもの
local BLUE, RED = { 0x3C, 0x66, 0xB6 }, { 0xC6, 0x25, 0x55 }
local function with(c, a) return { c[1], c[2], c[3], a } end
local function P(c1, c2, dir, slot, sty)
    sty = sty or {}
    sty.text_dir = dir
    return ext._label_props(slot or { codes = true }, 'Goblin Footprint', c1, c2, 0.8, sty)
end
ext.native_gradient = nil
-- 透けない（今まで）
local p0 = P(BLUE, RED, 'down')
eq(p0.color, '#3C66B6FF', '0%: color as before')
eq(p0.gradient_from, '#3C66B6FF', '0%: from'); eq(p0.gradient_to, '#C62555FF', '0%: to')
eq(p0.stroke_color, nil, '0%: outline color untouched')
eq(p0.outline, true, '0%: outline on')
local pa = P(BLUE, RED, 'across')
check(pa.text:find('\\cs(', 1, true) ~= nil, '0% across: codes as before')
eq(pa.color, '#FFFFFFFF', '0% across: white base as before')
local ps = P(BLUE, nil, nil)
eq(ps.color, '#3C66B6FF', '0% single as before')
-- 100%（Tsukasa さんの OBJECT：上から下）
for _, dir in ipairs({ 'down', 'across' }) do
    local p = P(with(BLUE, 0), with(RED, 0), dir)
    eq(p.color, '#3C66B600', dir .. ' 100%: no fill')
    check(p.gradient == nil or p.gradient == 'none', dir .. ' 100%: no gradient')
    eq(p.text, 'Goblin Footprint', dir .. ' 100%: plain text, no codes')
    eq(p.outline, false, dir .. ' 100%: no outline (not black letters)')
    eq(p.stroke, 0, dir .. ' 100%: stroke 0')
    eq(p.background, ext._bg_hex(0.8), dir .. ' 100%: background unchanged')
end
local p1s = P(with(BLUE, 0), nil, nil)
eq(p1s.color, '#3C66B600', 'single 100%'); eq(p1s.outline, false, 'single 100%: no outline')
-- 50%
local pd = P(with(BLUE, 128), with(RED, 128), 'down')
eq(pd.gradient, 'down', '50% down native')
eq(pd.gradient_from, '#3C66B680', '50% from'); eq(pd.gradient_to, '#C6255580', '50% to same alpha')
eq(pd.color, '#3C66B680', '50% color alpha')
eq(pd.stroke_color, '#00000080', '50%: outline fades with the text')
eq(pd.background, ext._bg_hex(0.8), '50%: background unchanged')
local px = P(with(BLUE, 128), with(RED, 128), 'across')
eq(px.gradient, 'across', '50% across native')
eq(px.text, 'Goblin Footprint', '50% across: no codes (codes have no alpha)')
eq(px.gradient_to, '#C6255580', '50% across to')
local p5s = P(with(BLUE, 128), nil, nil)
eq(p5s.color, '#3C66B680', 'single 50%'); eq(p5s.gradient, nil, 'single: no gradient')
-- 縁取りの濃さと掛け合わせる
local pk = P(with(BLUE, 128), nil, nil, nil, { stroke_alpha = 0.5 })
eq(pk.stroke_color, '#00000040', 'outline strength x transparency')
-- 片側だけアルファ 0 にはしない（小さい方にそろえる）
local pm = P(with(BLUE, 128), RED, 'down')
eq(pm.gradient_to, '#C6255580', 'both ends same alpha')
-- 古い VanaCore（gradient が無い）：色の印は使わず単色で透かす
ext.native_gradient = false
local pold = P(with(BLUE, 128), with(RED, 128), 'across')
eq(pold.gradient, nil, 'old vanacore: no gradient')
eq(pold.color, '#3C66B680', 'old vanacore: start color, transparent')
eq(pold.text, 'Goblin Footprint', 'old vanacore: no codes')
ext.native_gradient = nil

-- 3) 透明度を 0 に戻すと縁取りの色も戻る（箱ごと）
local slot = { codes = true }
P(with(BLUE, 128), nil, nil, slot)
local back = P(BLUE, nil, nil, slot)
eq(back.stroke_color, '#000000FF', 'outline back to 100%')
eq(back.outline, true, 'outline back on')
eq(P(BLUE, nil, nil, slot).stroke_color, nil, 'and not sent again')
-- 100% から戻す：gradient も戻る
local s2 = { codes = true }
P(with(BLUE, 128), with(RED, 128), 'down', s2)
local z = P(with(BLUE, 0), with(RED, 0), 'down', s2)
eq(z.gradient, 'none', '100%: native gradient turned off on this box')
eq(z.color_codes, true, 'codes back on')
local r = P(BLUE, RED, 'down', s2)
eq(r.gradient, 'down', 'back to 0%: down again')

-- 4) 実際の箱へ：同じなら入れ直さない、透明度が変われば入れ直す
local store, sets = {}, 0
local box = setmetatable({}, { __index = function (_, k)
    if k == 'set' then return function (_, pr) for kk, vv in pairs(pr) do store[kk] = vv end sets = sets + 1 end end
    return store[k] end, __newindex = function (_, k, v) store[k] = v end })
local bs = { box = box, codes = true }
local st = settings.label_style(half, 'label')
ext._apply_label_text(bs, 'AB', h1, h2, 0.8, st)
local n = sets
ext._apply_label_text(bs, 'AB', h1, h2, 0.8, st)
eq(sets, n, 'no re-set for the same look')
local f1, f2 = settings.text_colors(settings.merge({ marks = { label_grad = true, label_clear = 1 } }).marks, 'label')
ext._apply_label_text(bs, 'AB', f1, f2, 0.8, st)
eq(sets, n + 1, 're-set when the transparency changes')
eq(store.outline, false, 'box: outline off at 100%')

print('test_317 ok')
