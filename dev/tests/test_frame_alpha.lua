-- 0.1.42: トラッカーの YunaUI 風のふち、窓ごとの背景の濃さ、設定の説明の折り返し
require('fake_env')
local imgui = package.loaded['imgui']
local settings = require('src.core.settings')
local theme = require('src.ui.theme')

-- 古い保存の「背景の濃さ」を、どの窓にも引き継ぐ
local m = settings.merge({ background_alpha = 0.55 })
for _, a in ipairs(settings.ALPHA_AREAS) do eq(m.alphas[a], 0.55, 'migrated ' .. a) end
local m2 = settings.merge({ background_alpha = 0.55, alphas = { tracker = 0.4, map = 5 } })
eq(m2.alphas.tracker, 0.4, 'kept tracker'); eq(m2.alphas.map, 1.0, 'clamped map'); eq(m2.alphas.book, 0.55, 'others migrate')
eq(settings.alpha_for(m2, 'tracker'), 0.4, 'tracker area')
eq(settings.alpha_for(m2, 'items'), 0.55, 'items is other')
eq(settings.alpha_for(m2, 'entry'), 0.55, 'entry is other')
eq(settings.defaults().alphas.settings, 0.85, 'default')

-- 積み数と、窓の地の濃さ・ふちの線
local pc, pv, bgs, lines = 0, 0, {}, 0
local WBG = theme.C('ImGuiCol_WindowBg')
imgui.PushStyleColor = function (id, c) pc = pc + 1; if id == WBG then bgs[#bgs + 1] = c[4] end end
imgui.PopStyleColor = function (n) pc = pc - (n or 1) end
imgui.PushStyleVar = function () pv = pv + 1 end
imgui.PopStyleVar = function (n) pv = pv - (n or 1) end
local dl = setmetatable({ AddLine = function () lines = lines + 1 end }, { __index = function () return function () end end })
imgui.GetWindowDrawList = function () return dl end
-- 文字の幅：ASCII 7、それ以外 14
imgui.CalcTextSize = function (s)
    local w = 0
    for ch in s:gmatch('[%z\1-\127\194-\244][\128-\191]*') do w = w + (#ch == 1 and 7 or 14) end
    return w, 14
end

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local Q = 'quest.sandoria.001'
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
S.look = 'yunaui'
S.alphas.tracker = 0.4; S.alphas.book = 0.9
app.open_detail(Q); frame()
FAKE.clicks['##pin'] = true; frame(); frame()
app.close_all(); frame()
frames(2)
bgs, lines = {}, 0
FAKE.drawn = {}
frame()
check(lines >= 28 * 3, 'full edge after draw-in: shadow + glow + line')
check(drawn('astertrail_tracker'), 'tracker drawn')
local has04 = false
for _, a in ipairs(bgs) do if math.abs(a - 0.4) < 1e-6 then has04 = true end end
check(has04, 'tracker uses its own opacity')

eq(pc, 0, 'colors balanced'); eq(pv, 0, 'vars balanced')
-- これまでの見た目ではふちは描かない
S.look = 'classic'; lines = 0; frame()
check(lines < 5, 'no capsule in classic')
-- 出た瞬間はふちが描かれ始めるだけ
S.look = 'yunaui'; frames(2); S.look = 'classic'; frames(2); S.look = 'yunaui'; lines = 0; frame()
check(lines >= 28 and lines < 28 * 3 + 1, 'draw-in starts (' .. lines .. ')')
S.look = 'classic'
eq(pc, 0, 'classic balanced'); eq(pv, 0, 'classic vars balanced')
S.look = 'yunaui'

-- 本の窓は本の濃さ
app.open_window('book'); bgs = {}; frame()
local has09 = false
for _, a in ipairs(bgs) do if math.abs(a - 0.9) < 1e-6 then has09 = true end end
check(has09, 'book uses its own opacity')
app.close_all(); frame()

-- 設定の 見た目 に窓ごとの背景の濃さ
FAKE.labels = {}; FAKE.texts = {}
app.open_window('settings'); frame(); frame()
for _, k in ipairs({ '本の背景の濃さ', '詳細の背景の濃さ', 'トラッカーの背景の濃さ', '地図の背景の濃さ', 'その他の背景の濃さ' }) do
    local hit = labeled(k)
    for _, x in ipairs(FAKE.texts) do if x:find(k, 1, true) then hit = true end end
    check(hit, 'row ' .. k)
end
-- 設定は本の中に出すので（0.1.175〜）、設定だけの濃さは出さない
check(not labeled('背景の濃さ（設定）'), 'no settings-only opacity row')
focus.set('settings', 'alpha_tracker'); frame()
check(focus.current('settings') == 'alpha_tracker', 'alpha row focusable')

-- 折り返し：狭い幅で、説明の文が消えずに一文字ずつ折れる
local CT = require('src.ui.colored_text')
local out = {}
local fake = { imgui = setmetatable({
    GetContentRegionAvail = function () return 4 + 14 * 5, 100 end,
    CalcTextSize = imgui.CalcTextSize,
    TextDisabled = function (s) out[#out + 1] = s end,
}, { __index = function () return function () end end }) }
CT.wrapped(fake, 'あいうえおかきくけこさ。', 'muted')
eq(#out, 3, 'three lines'); eq(out[1], 'あいうえお', 'line 1'); eq(out[2], 'かきくけこ', 'line 2')
eq(out[3], 'さ。', 'kinsoku: 。 not at line start')
out = {}
CT.wrapped(fake, 'あいうえお。', 'muted')
eq(#out, 1, 'punctuation stays on the line'); eq(out[1], 'あいうえお。', 'hang')
out = {}
CT.wrapped(fake, 'ab cd efgh', 'muted')   -- 74px: 10 ascii
eq(#out, 1, 'english fits')
out = {}
CT.wrapped(fake, 'hello world again', 'muted')
eq(out[1], 'hello', 'english breaks at space'); eq(out[2], 'world', 'no leading space'); eq(out[3], 'again', 'line 3')
out = {}
CT.wrapped(fake, '一行目\n二行目', 'muted')
eq(#out, 2, 'newline kept')
print('test_frame_alpha ok')
