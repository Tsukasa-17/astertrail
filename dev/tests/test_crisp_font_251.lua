-- 0.1.252：保存の英字・数字は無視し、いつもメイリオ。ensure はログイン後。
require('fake_env')

local settings = require('src.core.settings')
local crisp = require('src.ui.crisp_font')
local app = require('src.app')
local imgui = require('imgui')

eq(app.VERSION, '1.1.285', 'version')

local function norm(path)
    return tostring(path or ''):gsub('/', '\\'):lower()
end

local present = {
    ['c:\\windows\\fonts\\meiryo.ttc'] = true,
    ['c:\\windows\\fonts\\meiryob.ttc'] = true,
    ['c:\\windows\\fonts\\arial.ttf'] = true,
    ['c:\\windows\\fonts\\segoeui.ttf'] = true,
}
local io_open = io.open
io.open = function (path, mode)
    if present[norm(path)] then
        return { close = function () end, read = function () return '' end, seek = function () return 0 end }
    end
    return io_open(path, mode)
end

local added = {}
local function cfg_new()
    return { MergeMode = false, GlyphRanges = nil, DstFont = nil }
end
imgui.types = { ImFontConfig = { new = cfg_new } }
imgui.AddFontFromFileTTF = function (path, px, cfg, ranges)
    added[#added + 1] = { path = path, px = px, cfg = cfg, merge = cfg and cfg.MergeMode == true }
    return { LegacySize = px or 36, path = path, px = px }
end

crisp._reset()
local S = settings.merge({
    font_crisp = true,
    font_face_ja = 'meiryo.ttc',
    font_face_en = 'segoeui.ttf',
    font_face_num = 'arial.ttf',
})
eq(S.font_face_en, 'segoeui.ttf', 'saved value is readable')
eq(crisp.ensure(imgui, S), false, 'first ensure')
check(#added >= 1, 'loaded something')
check(norm(added[1].path):find('meiryo.ttc', 1, true), 'always meiryo first')
for _, e in ipairs(added) do
    check(not norm(e.path):find('segoeui.ttf', 1, true), 'segoe not loaded')
    check(not norm(e.path):find('arial.ttf', 1, true), 'arial not loaded')
end
eq(crisp.used_merge(), false, 'no merge')
eq(crisp.needs_reload(S), false, 'face keys do not request reload')
eq(crisp.ensure(imgui, S), true, 'ready next frame')

io.open = io_open

local src = io.open(ROOT .. '/src/app.lua', 'r'):read('*a')
local i_tick = src:find('app.tick%(now%)')
local i_ensure = src:find("crisp_font'%)%.ensure")
check(i_tick and i_ensure and i_tick < i_ensure, 'ensure after tick so login settings are used')
