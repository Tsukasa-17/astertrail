-- 0.1.235：頭上ラベルの背景色・グラデ・斜体・縁取り、ぼやけ直し、輪の濃さ、イベント中に消す、メニューの斜体・縁取り
require('fake_env')
local settings = require('src.core.settings')
local ext = require('src.platform.vanacore_ext')
local marks_ui = require('src.ui.marks')
local theme = require('src.ui.theme')

eq(settings.defaults().font_italic, false, 'menu italic off')
eq(settings.defaults().font_outline, 1, 'menu outline 1')
eq(settings.defaults().marks.label_bg_color[1], 0, 'bg black')
eq(settings.defaults().marks.label_bg_grad, false, 'bg grad off')
eq(settings.defaults().marks.label_italic, false, 'label italic off')
eq(settings.defaults().marks.label_stroke, 1, 'stroke 1')
eq(settings.defaults().marks.no_enlarge_near, false, 'enlarge near on (current)')
eq(settings.defaults().marks.ring_strength, 1, 'ring strength 1')
eq(settings.defaults().marks.hide_scenes.event.on, true, 'hide in event on (0.1.296: hide_scenes)')

local old = settings.merge({ marks = {} })
eq(old.marks.label_stroke, 1, 'old save stroke 1')
eq(old.marks.ring_strength, 1, 'old save strength 1')
eq(old.marks.label_bg_grad, false, 'old save no bg grad')
eq(old.font_italic, false, 'old save no italic')
eq(old.font_outline, 1, 'old save outline 1')

eq(settings.clamp_stroke(nil), 1, 'stroke default')
eq(settings.clamp_stroke(-1), 0, 'stroke low')
eq(settings.clamp_stroke(9), 8, 'stroke high')
eq(settings.clamp_ring_strength(nil), 1, 'strength default')
eq(settings.clamp_ring_strength(0), 0, 'strength 0')
eq(settings.clamp_ring_strength(4.14), 4, 'strength cap')
eq(settings.clamp_ring_strength(1.26), 1.3, 'strength snap')

local st = settings.label_style({
    label_bg_color = { 10, 20, 30 }, label_bg_alpha = 0.5, label_bg_grad = true,
    label_bg_color2 = { 40, 50, 60 }, label_italic = true, label_stroke = 3,
}, 'label')
eq(st.color[2], 20, 'style color')
eq(st.color2[1], 40, 'style color2')
eq(st.grad, true, 'style grad')
eq(st.italic, false, 'style italic ignored')
eq(st.stroke, 3, 'style stroke')
eq(st.alpha, 0.5, 'style alpha')

-- 背景色つきの hex。引数なしは今までの黒
eq(ext._bg_hex(0.8), '#000000CC', 'default hex')
eq(ext._bg_hex(0.5, { 255, 0, 0 }), '#FF000080', 'red half')

local p = ext._label_props({ codes = false }, 'ab', { 10, 20, 30 }, nil, 0.5, { color = { 0, 0, 0 } })
eq(p.background, '#00000080', 'solid black bg')
eq(p.outline, true, 'outline on at 1')
eq(p.stroke, 1, 'stroke 1')
eq(p.italic, false, 'italic off')
local p2 = ext._label_props({ codes = false }, 'ab', { 10, 20, 30 }, nil, 0.8, {
    color = { 1, 2, 3 }, grad = true, color2 = { 9, 9, 9 }, italic = true, stroke = 0,
})
eq(p2.background, '#00000000', 'grad makes text bg clear')
eq(p2.italic, false, 'italic forced off')
eq(p2.outline, false, 'stroke 0 no outline')
eq(p2.stroke, 0, 'stroke 0')

eq(ext._visual_scale(1, 64), 0.25, 'bake 64 scale')
eq(ext._visual_scale(2, 64), 0.5, 'bake 64 at 200%')
eq(ext._visual_scale(1, 16), 1, 'fallback bake 16')
eq(math.abs(ext._icon_place_scale() - (28/64)) < 1e-6, true, 'icon scale 28/64')

-- グラデ BMP
local bmp = TMP .. '/grad.bmp'
check(ext._write_gradient_bmp(bmp, 8, 2, { 0, 0, 0 }, { 255, 0, 0 }), 'wrote bmp')
local f = assert(io.open(bmp, 'rb'))
local raw = f:read('*a'); f:close()
eq(raw:sub(1, 2), 'BM', 'bmp magic')
eq(#raw, 54 + 2 * 24, '24bit 8x2 padded') -- 8*3=24, already multiple of 4

-- 輪の濃さ・イベント中
local rings = marks_ui.ground_rings({
    settings = { marks = { show_rings = true, ring_strength = 2.0, ring_sub = { 1, 2, 3 } } },
    platform = {},
}, { { entity = { x = 1, y = 2, z = 3, hitbox_size = 1, dead = false }, role = 'sub', icon = 'sub' } }, { x = 0, y = 0 })
eq(rings[1].strength, 2, 'strength passed')
eq(rings[1].color, '#010203', 'color kept')

local hidden = {}
local how = marks_ui.apply_rings({
    settings = { marks = { hide_rings_in_event = true } },
    platform = {
        self_status = function () return 4 end,
        rings_available = function () return true end,
        rings_native = function () return true end,
        set_ground_rings = function (items) hidden.n = #items; return true end,
    },
}, rings)
eq(hidden.n, 0, 'event hides rings')
eq(how, 'off', 'apply returns off when empty')

how = marks_ui.apply_rings({
    settings = { marks = { hide_rings_in_event = false } },
    platform = {
        self_status = function () return 4 end,
        rings_available = function () return true end,
        rings_native = function () return true end,
        set_ground_rings = function (items) hidden.n = #items; hidden.st = items[1] and items[1].strength; return true end,
    },
}, rings)
eq(hidden.n, 1, 'event hide off keeps rings')
eq(hidden.st, 2, 'strength forwarded')

theme.set_outline_mul(1)
eq(theme.outline_mul(), 1, 'mul 1')
theme.set_outline_mul(0)
eq(theme.outline_mul(), 0, 'mul 0')
theme.set_outline_mul(1)

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
eq(app.VERSION, '1.1.327', 'version')
eq(addon.version, app.VERSION, 'lua matches')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(S.marks.ring_strength, 1, 'fresh strength')
eq(S.marks.no_enlarge_near, false, 'fresh no enlarge')
eq(S.font_italic, false, 'fresh italic')

local function seen(pat)
    for _, x in ipairs(FAKE.texts) do if x:find(pat, 1, true) then return true end end
    for _, x in ipairs(FAKE.labels) do if x:find(pat, 1, true) then return true end end
    return false
end
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('look'); frame(); frame()
check(seen('縁取りの太さ'), 'crisp outline slider in font size')
check(not seen('縁取りと影'), 'old look fx fold still removed')
require('src.ui.settings_ui').select_tab('marks'); frame(); frame()
check(seen('クエスト名の背景色'), 'bg color')
check(seen('クエスト名の背景グラデーション'), 'bg grad')
check(seen('クエスト名の縁取りの太さ'), 'label stroke')
check(seen('近づいても大きくしない'), 'no enlarge')
check(seen('リングの濃さ'), 'ring strength')
require('src.ui.settings_ui').select_tab('input'); frame(); frame() -- 0.1.308〜：隠す場面は操作の GAME UI
check(seen('イベント中に隠す'), 'hide scenes block (0.1.296)')
