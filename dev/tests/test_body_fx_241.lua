-- 0.1.245：見た目の縁取りと影（本文への重ね描き）は使わない。保存キーが残っても落ちない。
require('fake_env')
local settings = require('src.core.settings')
local theme = require('src.ui.theme')
local ext = require('src.platform.vanacore_ext')

eq(settings.defaults().font_body_fx, false, 'body fx default off')
eq(settings.merge({}).font_body_fx, false, 'missing stays off')
eq(settings.merge({ font_body_fx = true }).font_body_fx, true, 'saved on kept in settings')
eq(settings.merge({ font_body_fx = false }).font_body_fx, false, 'explicit off kept')
eq(settings.merge({ font_body_fx = 'yes' }).font_body_fx, false, 'non-true dropped')
-- 古い保存の縁取り・影の値も、読んで落とさない
local kept = settings.merge({
    font_body_fx = true, font_outline = 8, font_shadow = true,
    font_shadow_color = 'white', font_shadow_distance = 8, font_shadow_alpha = 1,
})
eq(kept.font_body_fx, true, 'key remains')
eq(kept.font_outline, 8, 'outline key remains')
eq(kept.font_shadow_color, 'white', 'shadow color key remains')

theme.set_text_fx(settings.defaults())
eq(theme.fx_active(), false, 'look fx off')
eq(theme.body_fx_on(), false, 'body fx off with defaults')
eq(theme.body_fx_extra_draws(), 0, 'no extra body draws when off')

-- 保存でオンでも描画はしない（色が壊れても落ちない）
theme.set_text_fx(kept)
eq(theme.body_fx_on(), false, 'saved on does not enable body fx')
eq(theme.fx_active(), false, 'saved outline/shadow not applied')

local function make_imgui(x, y)
    local draws = {}
    local im = {
        GetCursorScreenPos = function () return x, y end,
        GetWindowPos = function () return 0, 0 end,
        GetWindowSize = function () return 400, 300 end,
        GetFontSize = function () return 16 end,
        GetWindowDrawList = function ()
            return {
                AddText = function (self, pos, col, text, fifth)
                    draws[#draws + 1] = { x = pos and pos[1], y = pos and pos[2], col = col, text = text, fifth = fifth }
                end,
            }
        end,
        Text = function () end,
        TextColored = function () end,
        TextDisabled = function () end,
    }
    return im, draws
end

local im, draws = make_imgui(20, 30)
eq(theme.paint_body_fx(im, 'あ'), 0, 'paint returns 0 when feature off')
eq(#draws, 0, 'no AddText when feature off')
local ok, err = pcall(theme.u32, 'no_such_color')
check(ok, 'u32 unknown still safe' .. (ok and '' or (': ' .. tostring(err))))
ok, err = pcall(theme.set_text_fx, { font_shadow_color = 2, font_body_fx = true })
check(ok, 'set_text_fx with bad color does not throw')
im, draws = make_imgui(20, 30)
eq(theme.paint_body_fx(im, '本文'), 0, 'still no paint after bad color')
eq(#draws, 0, 'no AddText after bad color')

eq(ext.ALLOW_LABEL_SHADOW, false, 'overhead shadow boxes stay off')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
eq(app.VERSION, '1.1.324', 'version')
eq(addon.version, app.VERSION, 'lua matches')
local wrapped = 0
local raw_wrap = theme.wrap_imgui
theme.wrap_imgui = function (...)
    wrapped = wrapped + 1
    return raw_wrap(...)
end
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(S.font_body_fx, false, 'fresh default off')
S.font_body_fx = true
S.font_shadow_color = 'white'
S.font_outline = 3
theme.set_text_fx(S)
eq(theme.body_fx_on(), false, 'forcing saved on still off in draw')
app.open_window('settings')
frame(); frame(); frame()
eq(wrapped, 0, 'wrap_imgui not used in present')
sui = require('src.ui.settings_ui')
sui.select_tab('look'); frame(); frame()
check(not (texted('本文にも使う') or labeled('本文にも使う')), 'body fx toggle hidden')
check(labeled('縁取りの太さ') or texted('縁取りの太さ'), 'crisp outline slider shown')
check(not (labeled('縁取りと影') or texted('縁取りと影')), 'look fx fold hidden')
eq(ext.ALLOW_LABEL_SHADOW, false, 'still no overhead shadow boxes')
