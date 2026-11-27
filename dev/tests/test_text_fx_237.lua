-- 0.1.237：輪を消す初期オン、本文の縁取り・影、頭上の影箱
require('fake_env')
local settings = require('src.core.settings')
local theme = require('src.ui.theme')
local ext = require('src.platform.vanacore_ext')
local marks_ui = require('src.ui.marks')

eq(settings.defaults().marks.hide_scenes.event.on, true, 'default hide on')
eq(settings.merge({ marks = {} }).marks.hide_scenes.event.on, true, 'unsaved is on')
eq(settings.merge({ marks = { hide_rings_in_event = false } }).marks.hide_scenes.event.on, false, 'explicit off kept (migrated)')
eq(settings.merge({ marks = { hide_rings_in_event = true } }).marks.hide_scenes.event.on, true, 'explicit on kept (migrated)')

-- 0.1.245：見た目の縁取り・影は保存値があっても描画に出さない
theme.set_text_fx(settings.defaults())
eq(theme.fx_active(), false, 'look fx off with defaults')
theme.set_text_fx({ font_outline = 8, font_outline_alpha = 1, font_shadow = true, font_body_fx = true })
eq(theme.fx_active(), false, 'look fx stays off when saved on')
eq(theme.body_fx_on(), false, 'body fx stays off')
theme.set_text_fx({ font_outline = 0, font_shadow = false })
eq(theme.fx_active(), false, 'fx off when outline 0 and shadow off')

-- wrap_imgui は本番では使わない。縁取りを切った状態では AddText しない
theme.set_text_fx(settings.defaults())
local draws, last, lastc = {}, nil, nil
local src = {
    GetCursorScreenPos = function () return 10, 20 end,
    GetWindowDrawList = function ()
        return {
            AddText = function (self, pos, col, text)
                draws[#draws + 1] = { x = pos and pos[1], y = pos and pos[2], col = col, text = text }
            end,
        }
    end,
    Text = function (text) last = text end,
    TextColored = function (c, text) lastc = text end,
}
local im = theme.wrap_imgui(src)
im.Text('あ')
eq(#draws, 0, 'no look fx strokes behind Text')
eq(last, 'あ', 'raw Text called')
eq(theme.wrap_imgui(im), im, 'wrap is idempotent')
im.TextColored({ 1, 1, 1, 1 }, 'い')
eq(lastc, 'い', 'raw TextColored called')
eq(#draws, 0, 'no look fx on TextColored')

-- 頭上の影色
eq(ext._shadow_hex({ shadow_color = 'black', shadow_alpha = 1 }), '#0D0D12B8', 'black 72%')
-- 0.72*255=183.6 -> 184 = 0xB8; 13,13,18 = 0D0D12
local off = ext._shadow_hex({ shadow_color = 'white', shadow_alpha = 0.5 })
-- 0.5*0.72*255=91.8 -> 92 = 0x5C
eq(off, '#F5F5F55C', 'white half')

-- 影指定が無い既存の置き方は箱の数が変わらない
_G.vana = _G.vana or {}
_G.vana.ui = _G.vana.ui or {}
_G.vana.world = _G.vana.world or {}
local places = {}
_G.vana.ui.image = function (opts)
    local box = { file = opts and opts.file, width = opts and opts.width, height = opts and opts.height, visible = true }
    function box:set(t) for k, v in pairs(t) do self[k] = v end end
    function box:destroy() end
    return box
end
_G.vana.ui.text = function (opts)
    local sz = tonumber(opts and opts.size) or 16
    local box = {
        text = opts and opts.text, size = opts and opts.size,
        width = 80 * (sz / 16), height = 18 * (sz / 16), visible = true,
    }
    function box:set(t) for k, v in pairs(t) do self[k] = v end end
    function box:destroy() end
    return box
end
_G.vana.world.place = function (box, x, y, z, opts)
    places[#places + 1] = { box = box, opts = opts, part = box.text }
    box.placed_at = { x, y, z }
end
_G.vana.world.update = function () return true end
ext.clear_world_marks()
eq(ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 11, under = '???' },
}), true, 'place without shadow')
local n1 = #places
check(n1 >= 2, 'mark and name')
for _, p in ipairs(places) do places[p] = nil end
for i = #places, 1, -1 do places[i] = nil end
ext.ALLOW_LABEL_SHADOW = true
ext.clear_world_marks()
eq(ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 12, under = '???',
      shadow = true, shadow_color = 'black', shadow_distance = 2, shadow_alpha = 1 },
}), true, 'place with shadow')
check(#places > n1, 'shadow adds a box')
local has_shadow = false
for _, p in ipairs(places) do
    if p.box and p.box.layer == -1 and p.box.background == '#00000000' then has_shadow = true end
end

check(has_shadow, 'shadow box behind')

-- 0.1.238：本番では影箱を作らない
ext.ALLOW_LABEL_SHADOW = false
for i = #places, 1, -1 do places[i] = nil end
ext.clear_world_marks()
eq(ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 13, under = '???',
      shadow = true, shadow_color = 'black', shadow_distance = 2, shadow_alpha = 1 },
}), true, 'place with flag off')
eq(#places, n1, 'flag off adds no shadow box')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
eq(app.VERSION, '1.1.327', 'version')
eq(addon.version, app.VERSION, 'lua matches')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(S.marks.hide_scenes.event.on, true, 'fresh hide on')
