-- 0.1.236：斜体をやめる、メニューの縁取り・影、会話中も輪を消す
require('fake_env')
local settings = require('src.core.settings')
local ext = require('src.platform.vanacore_ext')
local marks_ui = require('src.ui.marks')
local theme = require('src.ui.theme')

eq(settings.defaults().font_italic, false, 'italic default off')
eq(settings.defaults().font_outline, 1, 'outline 1 px')
eq(settings.defaults().font_outline_alpha, 1, 'outline alpha 100')
eq(settings.defaults().font_shadow, true, 'shadow on')
eq(settings.defaults().font_shadow_color, 'black', 'shadow black')
eq(settings.defaults().font_shadow_distance, 2, 'shadow 2 px')
eq(settings.defaults().font_shadow_alpha, 1, 'shadow alpha 100')
eq(settings.defaults().marks.label_stroke_alpha, 1, 'label stroke alpha 100')

-- 保存に斜体オンが残っていても無視する
local loaded = settings.merge({
    font_italic = true,
    marks = { label_italic = true, under_italic = true, hide_rings_in_event = true },
})
eq(loaded.font_italic, false, 'saved italic ignored')
eq(loaded.marks.label_italic, false, 'saved label italic ignored')
eq(loaded.marks.under_italic, false, 'saved under italic ignored')
eq(loaded.font_shadow, true, 'missing shadow stays on')
eq(loaded.font_outline_alpha, 1, 'missing outline alpha 1')
eq(loaded.marks.hide_scenes.event.on, true, 'hide in event kept (0.1.296: hide_scenes)')

eq(settings.clamp_font_outline(2.26), 2.25, 'outline snap 0.25')
eq(settings.clamp_font_outline(9), 8, 'outline cap')
eq(settings.clamp_unit_alpha(0.52), 0.5, 'alpha snap 0.05')
eq(settings.clamp_shadow_color('dark'), 'dark', 'shadow color dark')
eq(settings.clamp_shadow_color('nope'), 'black', 'shadow color fallback')
eq(settings.clamp_shadow_distance(2.26), 2.25, 'distance snap')

local st = settings.label_style({ label_italic = true, label_stroke = 3, label_stroke_alpha = 0.5 }, 'label')
eq(st.italic, false, 'style never italic')
eq(st.stroke, 3, 'stroke kept')
eq(st.stroke_alpha, 0.5, 'stroke alpha')

-- 頭上：斜体は付けない。濃さが 100% 未満のときだけ stroke_color
local p = ext._label_props({ codes = false }, 'ab', { 10, 20, 30 }, nil, 0.8, { italic = true, stroke = 2 })
eq(p.italic, false, 'box italic off')
eq(p.stroke, 2, 'stroke 2')
eq(p.stroke_color, nil, 'no stroke_color at 100%')
local p2 = ext._label_props({ codes = false }, 'ab', { 10, 20, 30 }, nil, 0.8, { stroke = 2, stroke_alpha = 0.5 })
eq(p2.stroke_color, '#00000080', 'stroke color half')
local p3 = ext._label_props({ codes = false }, 'ab', { 10, 20, 30 }, nil, 0.8, { stroke = 0, stroke_alpha = 0.5 })
eq(p3.stroke, 0, 'stroke 0')
eq(p3.stroke_color, nil, 'no color when no stroke')

check(ext.get_italic_font == nil, 'no italic font loader')
check(ext.push_italic_font == nil, 'no italic push')

-- 輪：status==4 でも、会話のメニューでも消す
local rings = { { x = 1, y = 2, z = 3, radius = 1, color = '#010203', strength = 1 } }
local hidden = {}
local function plat(extra)
    local p = {
        rings_available = function () return true end,
        rings_native = function () return true end,
        set_ground_rings = function (items) hidden.n = #items; return true end,
    }
    for k, v in pairs(extra or {}) do p[k] = v end
    return p
end
marks_ui.apply_rings({
    settings = { marks = { hide_rings_in_event = true } },
    platform = plat({ self_status = function () return 0 end }),
    state = { game_menu_open = true },
}, rings)
eq(hidden.n, 0, 'talk menu hides rings')

hidden.n = nil
marks_ui.apply_rings({
    settings = { marks = { hide_rings_in_event = true } },
    platform = plat({
        self_status = function () return 0 end,
        game_menu_state = function () return true, { flag = true } end,
    }),
    state = {},
}, rings)
eq(hidden.n, 0, 'game_menu_state hides rings')

hidden.n = nil
marks_ui.apply_rings({
    settings = { marks = { hide_rings_in_event = true } },
    platform = plat({ self_status = function () return 0 end }),
    state = { game_menu_open = false },
}, rings)
eq(hidden.n, 1, 'idle keeps rings')

eq(marks_ui.hide_rings_now({
    settings = { marks = { hide_rings_in_event = true } },
    platform = { self_status = function () return 4 end },
}), true, 'status 4 hides')
eq(marks_ui.hide_rings_now({
    settings = { marks = { hide_rings_in_event = false } },
    state = { game_menu_open = true },
    platform = {},
}), false, 'setting off never hides')

theme.set_text_fx(settings.defaults())
eq(theme.outline_mul(), 0, '0.1.245: look fx not applied')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
eq(app.VERSION, '1.1.300', 'version')
eq(addon.version, app.VERSION, 'lua matches')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(S.font_shadow, true, 'fresh shadow on')
eq(S.font_italic, false, 'fresh italic off')

local function seen(pat)
    for _, x in ipairs(FAKE.texts) do if x:find(pat, 1, true) then return true end end
    for _, x in ipairs(FAKE.labels) do if x:find(pat, 1, true) then return true end end
    return false
end
local function unseen(pat)
    return not seen(pat)
end
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('look'); frame(); frame()
check(unseen('斜体'), 'no italic in look')
check(seen('縁取りの太さ'), 'crisp outline slider in font size')
check(unseen('本文にも使う'), 'body fx toggle removed')
check(unseen('縁取りと影'), 'look fx fold removed')
check(seen('文字サイズ'), 'fonts remain')
check(seen('背景の濃さ'), 'alpha remains')
require('src.ui.settings_ui').select_tab('marks'); frame(); frame()
check(unseen('を斜体にする'), 'no label italic')
check(seen('クエスト名の縁取りの濃さ'), 'label stroke alpha')
check(seen('隠す場面') and seen('イベント中'), 'hide scenes block (0.1.296)')
check(seen('会話'), 'hide note mentions talk')
