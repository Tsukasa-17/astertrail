-- 0.1.249：縁取りを今の文字サイズ（GetFontSize）に合わせる。PushFont/PopFont は組。
require('fake_env')

local outline = require('src.ui.crisp_outline')
local theme = require('src.ui.theme')
local app = require('src.app')

eq(app.VERSION, '1.1.285', 'version')

local adds, pushes, pops = {}, {}, {}
local font = { name = 'fake-font' }
local dl = {
    AddText = function (self, pos, col, text)
        adds[#adds + 1] = { x = pos[1], y = pos[2], col = col, text = text }
    end,
}
local im = {
    GetWindowDrawList = function () return dl end,
    GetFontSize = function () return 36 end,
    GetFont = function () return font end,
    PushFont = function (f, size)
        pushes[#pushes + 1] = { font = f, size = size }
    end,
    PopFont = function ()
        pops[#pops + 1] = true
    end,
    GetWindowPos = function () return 100, 100 end,
    GetWindowSize = function () return 400, 300 end,
    GetCursorScreenPos = function () return 120, 130 end,
    GetContentRegionAvail = function () return 200, 200 end,
    CalcTextSize = function (s) return { x = 16, y = 16 } end,
}

adds, pushes, pops = {}, {}, {}
local n = outline.paint_at(im, 200, 200, '幅', { width = 3, alpha = 0.85 })
eq(n, 64, '3px still 64 draws')
eq(#adds, 64, '64 AddText')
eq(#pushes, 1, 'one PushFont for current size')
eq(pushes[1].font, font, 'PushFont uses GetFont')
eq(pushes[1].size, 36, 'PushFont uses GetFontSize (not the unscaled default)')
eq(#pops, 1, 'PopFont paired')

-- PushFont が失敗しても Pop はせず、描画は続く
local im2 = {}
for k, v in pairs(im) do im2[k] = v end
im2.PushFont = function () error('no size push') end
im2.PopFont = function () error('should not pop') end
adds = {}
n = outline.paint_at(im2, 200, 200, '幅', { width = 1, alpha = 0.85 })
eq(n, 8, '1px still draws if PushFont fails')

-- GetFont が無いときは Push せず、4 引数のまま
local im3 = {}
for k, v in pairs(im) do im3[k] = v end
im3.GetFont = nil
local push_n = 0
im3.PushFont = function () push_n = push_n + 1 end
adds = {}
n = outline.paint_at(im3, 200, 200, '幅', { width = 1, alpha = 0.85 })
eq(n, 8, 'draws without GetFont')
eq(push_n, 0, 'no PushFont without GetFont')

-- 画面の外はこれまでどおり飛ばす（PushFont もしない）
pushes, pops, adds = {}, {}, {}
n = outline.paint_at(im, 10, 10, '外', { width = 3, alpha = 0.85 })
eq(n, 0, 'off-screen skipped')
eq(#pushes, 0, 'no PushFont when skipped')
