-- 0.1.246：くっきりフォント（ImGui にメイリオを読み、PushFont で大きさのフォントを使う）
require('fake_env')

local settings = require('src.core.settings')
local crisp = require('src.ui.crisp_font')
local window = require('src.ui.window')
local app = require('src.app')
local imgui = require('imgui')

eq(app.VERSION, '1.1.300', 'version')
---------------------------------------------------------------------------
-- 1) 初期値と保存の合わせ込み
---------------------------------------------------------------------------
local D = settings.defaults()
eq(D.font_crisp, true, 'crisp default on')
eq(D.font_crisp_bold, false, 'bold default off')

local m = settings.merge({})
eq(m.font_crisp, true, 'missing key stays on')
eq(m.font_crisp_bold, false, 'missing bold stays off')

m = settings.merge({ font_crisp = false, font_crisp_bold = true })
eq(m.font_crisp, false, 'saved off is kept')
eq(m.font_crisp_bold, true, 'saved bold is kept')

m = settings.merge({ font_crisp = 'yes', font_crisp_bold = 1 })
eq(m.font_crisp, true, 'junk crisp treated as on')
eq(m.font_crisp_bold, false, 'junk bold treated as off')

---------------------------------------------------------------------------
-- 2) フォントが読めない／API が無いときは、今までの倍率に戻す
---------------------------------------------------------------------------
crisp._reset()
eq(crisp.ensure(imgui), false, 'no font file: not ready')
eq(crisp.ready(), false, 'still not ready')
eq(crisp.active({ font_crisp = true }), false, 'active false when not loaded')

-- set_font は落ちず、倍率の経路を使う
local scales = {}
local old_scale = imgui.SetWindowFontScale
imgui.SetWindowFontScale = function (v) scales[#scales + 1] = v end
local ui = {
    imgui = imgui,
    settings = settings.merge({}),
    _font_base = 18,
    _crisp_win = 'tracker',
    mark_settings_dirty = function () end,
}
window.set_font(ui, 1.5)
check(#scales > 0, 'fallback still calls SetWindowFontScale')
eq(ui._crisp_pushed, nil, 'no PushFont when unavailable')
if old_scale then imgui.SetWindowFontScale = old_scale end

---------------------------------------------------------------------------
-- 3) 静的サイズの選び方（一番近い。同じ差なら大きめ）
---------------------------------------------------------------------------
local list = { { 'a', 16 }, { 'b', 24 }, { 'c', 32 } }
local f, px = crisp.pick_static(list, 27)
eq(f, 'b', '27px -> nearest 24')
eq(px, 24, '24 picked')
f, px = crisp.pick_static(list, 20)
-- 差が同じ (4) で 24 >= 20 かつ 16 < 20 なので、少し大きめの 24
eq(f, 'b', 'tie prefers slightly larger')
eq(px, 24, 'tie 24')
eq(crisp.pick_px(18, 1.5), 27, '18*1.5=27')
eq(crisp.pick_px(18, 0.1), 8, 'clamp min 8')
eq(crisp.pick_px(18, 10), 72, 'clamp max 72')

---------------------------------------------------------------------------
-- 4) 動的フォント：読み込みは一度、次の ensure から使える。Push/Pop は組。
---------------------------------------------------------------------------
crisp._reset()
local tmp = (TMP or '/tmp') .. '/astertrail_fonts'
-- TMP は run_tests が作る一時フォルダ
os.execute('mkdir -p "' .. tmp .. '"')
local function touch(path)
    local f = io.open(path, 'wb')
    f:write('dummy')
    f:close()
end
local path_r, path_b = tmp .. '/meiryo.ttc', tmp .. '/meiryob.ttc'
touch(path_r); touch(path_b)
crisp._set_paths(path_r, path_b)

local added, pushes, pops, last_push = {}, {}, {}, nil
imgui.AddFontFromFileTTF = function (path, px)
    added[#added + 1] = { path = path, px = px }
    return { LegacySize = 16, path = path, px = px }
end
imgui.PushFont = function (font, size)
    last_push = { font = font, size = size }
    pushes[#pushes + 1] = last_push
end
imgui.PopFont = function ()
    pops[#pops + 1] = true
end
local scale_calls = {}
imgui.SetWindowFontScale = function (v) scale_calls[#scale_calls + 1] = v end

eq(crisp.ensure(imgui), false, 'first ensure loads, not yet ready (atlas next frame)')
eq(crisp.dynamic(), true, 'LegacySize -> dynamic')
check(#added >= 1, 'regular loaded')
do
    local body, head = 0, 0
    for _, e in ipairs(added) do
        if tostring(e.path):find('Melete', 1, true) then head = head + 1 else body = body + 1 end
    end
    eq(body, 2, 'only regular+bold meiryo, not a size list')
    eq(head, 1, 'Melete heading loaded once with the body fonts')
end
eq(crisp.ensure(imgui), true, 'second ensure ready')
eq(crisp.ensure(imgui), true, 'later ensure does not reload')
eq(#added, 3, 'still regular+bold+heading, no reload')

local S = settings.merge({ font_crisp = true, font_crisp_bold = false, fonts = { tracker = 1.5 } })
ui.settings = S
ui._crisp_pushed = nil
ui._font_base = 18
ui._crisp_win = 'tracker'
window.set_font(ui, 1.5)
eq(ui._crisp_pushed, true, 'PushFont used')
eq(#pushes, 1, 'one push')
eq(last_push.size, 27, 'PushFont(font, 27) for 18*1.5')
check(scale_calls[#scale_calls] == 1.0, 'scale forced to 1 (no stretch)')
eq(last_push.font.path, path_r, 'regular meiryo')

-- 同じ窓で大きさだけ変える（前のフォントを戻してから押し直す）
window.set_font(ui, 2.0)
eq(#pushes, 2, 're-push')
eq(#pops, 1, 'popped previous first')
eq(last_push.size, 36, '18*2=36')

-- finish で PopFont（End の前）
-- 本物の finish は End も呼ぶ。release を見るため finish を使う
-- window.finish は focus と End が要るので、unwind で組を閉じる
window.unwind(ui)
eq(#pops, 2, 'unwind pops font')
eq(ui._crisp_pushed, false, 'cleared')

-- オフにすると倍率の経路
S.font_crisp = false
scale_calls = {}
pushes = {}
window.set_font(ui, 1.5)
eq(ui._crisp_pushed, false, 'off: no push flag')
eq(#pushes, 0, 'off: no PushFont')
check(#scale_calls > 0, 'off: SetWindowFontScale used')

-- 太字
S.font_crisp = true
S.font_crisp_bold = true
pushes = {}; pops = {}
window.set_font(ui, 1.0)
eq(last_push.font.path, path_b, 'bold meiryob')
eq(last_push.size, 18, '18*1')
window.unwind(ui)
eq(#pushes, #pops, 'bold push/pop paired')

-- 地図など対象外の窓は倍率のまま
S.font_crisp = true
ui._crisp_win = 'map'
pushes = {}; scale_calls = {}
window.set_font(ui, 1.5)
eq(#pushes, 0, 'map is not a crisp window')
check(#scale_calls > 0, 'map uses scale')

---------------------------------------------------------------------------
-- 5) 表示テスト：設定に項目が出る。フォント無しでも描画は止まない
---------------------------------------------------------------------------
crisp._reset()
crisp._set_paths(nil, nil)
-- API は残したままだと exists 失敗でフォールバック
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S2 = app._settings()
eq(addon.version, app.VERSION, 'lua matches')
eq(S2.font_crisp, true, 'live default on')
eq(S2.font_crisp_bold, false, 'live bold off')
app.open_window('settings'); frame(); frame(); frame()
local sui = require('src.ui.settings_ui')
sui.select_tab('look'); frame(); frame()
local function seen(pat)
    for _, l in ipairs(FAKE.labels) do if l:find(pat, 1, true) then return true end end
    for _, l in ipairs(FAKE.texts) do if l:find(pat, 1, true) then return true end end
    return false
end
check(seen('くっきりフォント（テスト）'), 'crisp toggle shown')
check(seen('太字（メイリオ）'), 'bold toggle shown')
