-- 0.1.250：くっきりフォントはメイリオ。0.1.252：選択は使わない。大きいサイズで ImGui に付ける。
require('fake_env')

local settings = require('src.core.settings')
local crisp = require('src.ui.crisp_font')
local window = require('src.ui.window')
local app = require('src.app')
local imgui = require('imgui')
local ffi = require('ffi')

eq(app.VERSION, '1.1.300', 'version')
eq(crisp.DEFAULT_FACE, 'meiryo.ttc', 'default face')
eq(crisp.LARGE_PX, 36, 'loaded at 36px from the start')

---------------------------------------------------------------------------
-- 1) 初期値と保存の合わせ込み
---------------------------------------------------------------------------
local D = settings.defaults()
eq(D.font_face_ja, 'meiryo.ttc', 'ja default meiryo')
eq(D.font_face_en, 'meiryo.ttc', 'en default meiryo')
eq(D.font_face_num, 'meiryo.ttc', 'num default meiryo')

local m = settings.merge({})
eq(m.font_face_ja, 'meiryo.ttc', 'missing ja stays meiryo')
eq(m.font_face_en, 'meiryo.ttc', 'missing en stays meiryo')
eq(m.font_face_num, 'meiryo.ttc', 'missing num stays meiryo')

m = settings.merge({ font_face_ja = 'YuGothM.ttc', font_face_en = 'arial.ttf', font_face_num = 'consola.ttf' })
eq(m.font_face_ja, 'YuGothM.ttc', 'saved ja kept')
eq(m.font_face_en, 'arial.ttf', 'saved en kept')
eq(m.font_face_num, 'consola.ttf', 'saved num kept')

eq(settings.clamp_font_face(nil), 'meiryo.ttc', 'nil -> default')
eq(settings.clamp_font_face(''), 'meiryo.ttc', 'empty -> default')
eq(settings.clamp_font_face('default'), 'meiryo.ttc', 'default keyword')
eq(settings.clamp_font_face('meiryo'), 'meiryo.ttc', 'meiryo keyword')
eq(settings.clamp_font_face('../arial.ttf'), 'meiryo.ttc', 'parent rejected')
eq(settings.clamp_font_face('C:\\Windows\\Fonts\\arial.ttf'), 'meiryo.ttc', 'abs path rejected')
eq(settings.clamp_font_face('foo/arial.ttf'), 'meiryo.ttc', 'rel path rejected')
eq(settings.clamp_font_face('arial.exe'), 'meiryo.ttc', 'bad ext rejected')
eq(settings.clamp_font_face('arial.ttf'), 'arial.ttf', 'plain ttf kept')
eq(crisp.sanitize_face('segoeui.ttf'), 'segoeui.ttf', 'sanitize allows segoe')
eq(crisp.sanitize_face('..\\meiryo.ttc'), 'meiryo.ttc', 'sanitize rejects \\..')

---------------------------------------------------------------------------
-- 2) 同じフォント（初期）：合成せず、36px で 1 系統だけ読む
---------------------------------------------------------------------------
local added = {}
local function norm(path)
    return tostring(path or ''):gsub('/', '\\'):lower()
end

local present = {
    ['c:\\windows\\fonts\\meiryo.ttc'] = true,
    ['c:\\windows\\fonts\\meiryob.ttc'] = true,
    ['c:\\windows\\fonts\\arial.ttf'] = true,
    ['c:\\windows\\fonts\\consola.ttf'] = true,
    ['c:\\windows\\fonts\\yugothm.ttc'] = true,
}
local io_open = io.open
io.open = function (path, mode)
    if present[norm(path)] then
        return {
            close = function () end,
            read = function () return '' end,
            seek = function () return 0 end,
        }
    end
    return io_open(path, mode)
end

local function cfg_new()
    return { MergeMode = false, GlyphRanges = nil, DstFont = nil }
end
imgui.types = { ImFontConfig = { new = cfg_new } }
imgui.AddFontFromFileTTF = function (path, px, cfg, ranges)
    added[#added + 1] = { path = path, px = px, cfg = cfg, ranges = ranges, merge = cfg and cfg.MergeMode == true }
    return { LegacySize = px or 36, path = path, px = px }
end

crisp._reset()
-- re-apply open hook after reset (reset does not touch io)
local S0 = settings.merge({ font_crisp = true })
eq(crisp.ensure(imgui, S0), false, 'first ensure not ready')
eq(crisp.dynamic(), true, 'dynamic after large load')
do
    local body, head = 0, 0
    for _, e in ipairs(added) do
        if tostring(e.path):find('Melete', 1, true) then head = head + 1 else body = body + 1 end
    end
    eq(body, 2, 'default: regular+bold only, no merge')
    eq(head, 1, 'Melete heading is also loaded at the same time')
end
eq(added[1].px, 36, 'regular loaded at 36')
eq(added[2].px, 36, 'bold loaded at 36')
check(not added[1].merge, 'default: no MergeMode')
check(not added[2].merge, 'bold: no MergeMode')
check(norm(added[1].path):find('meiryo.ttc', 1, true), 'default regular meiryo')
eq(crisp.used_merge(), false, 'same faces: no merge')
eq(crisp.ensure(imgui, S0), true, 'second ensure ready')
eq(crisp.needs_reload(S0), false, 'unchanged: no reload')
S0.font_face_en = 'arial.ttf'
eq(crisp.needs_reload(S0), false, 'changed en is ignored, no reload')

---------------------------------------------------------------------------
-- 3) 0.1.252：保存に別フォントがあっても、いつもメイリオだけを読む
---------------------------------------------------------------------------
added = {}
crisp._reset()
imgui.types = { ImFontConfig = { new = cfg_new } }
local S1 = settings.merge({
    font_crisp = true,
    font_face_ja = 'meiryo.ttc',
    font_face_en = 'arial.ttf',
    font_face_num = 'consola.ttf',
})
eq(S1.font_face_en, 'arial.ttf', 'saved en key is kept but unused')
eq(crisp.ensure(imgui, S1), false, 'first ensure')
eq(added[1].px, 36, 'still loaded at 36')
check(norm(added[1].path):find('meiryo.ttc', 1, true), 'regular is meiryo, not arial')
for _, e in ipairs(added) do
    check(not norm(e.path):find('arial.ttf', 1, true), 'arial not loaded')
    check(not norm(e.path):find('consola.ttf', 1, true), 'consola not loaded')
end
eq(crisp.used_merge(), false, 'no merge')
eq(crisp.ensure(imgui, S1), true, 'ready next frame')

---------------------------------------------------------------------------
-- 4) API が無いときは今までの描画へ
---------------------------------------------------------------------------
crisp._reset()
local old_add = imgui.AddFontFromFileTTF
imgui.AddFontFromFileTTF = nil
eq(crisp.ensure(imgui, S0), false, 'no API: not ready')
eq(crisp.active({ font_crisp = true }), false, 'not active when unloaded')
imgui.AddFontFromFileTTF = old_add

---------------------------------------------------------------------------
-- 5) 設定画面からフォント選択は消す。くっきり切替は残る
---------------------------------------------------------------------------
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local Slive = app._settings()
eq(addon.version, app.VERSION, 'lua matches')
app.open_window('settings'); frame(); frame(); frame()
local sui = require('src.ui.settings_ui')
sui.select_tab('look'); frame(); frame()
local function seen(pat)
    for _, l in ipairs(FAKE.labels) do if l:find(pat, 1, true) then return true end end
    for _, l in ipairs(FAKE.texts) do if l:find(pat, 1, true) then return true end end
    return false
end
check(not seen('日本語のフォント'), 'ja font picker removed')
check(not seen('英字のフォント'), 'en font picker removed')
check(not seen('数字のフォント'), 'num font picker removed')
check(not seen('Windows のフォントから選べます'), 'selection note removed')
check(seen('くっきりフォント（テスト）'), 'crisp toggle still shown')
check(seen('太字（メイリオ）'), 'bold switch still shown')

io.open = io_open
