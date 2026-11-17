-- 0.1.212（t397u）：コンパスの窓の背景の濃さ。ほかの窓と同じ「見た目」の並び（5% きざみ、30〜100%）
require('fake_env')
local imgui = package.loaded['imgui']
local settings = require('src.core.settings')
local theme = require('src.ui.theme')

-- 初期値と、古い保存の引き継ぎ（いままでの見た目＝トラッカーの濃さのまま）
eq(settings.defaults().alphas.compass, 0.85, 'default compass opacity 85%')
eq(settings.defaults().alphas.tracker, settings.defaults().alphas.compass, 'default matches the tracker (same look)')
local found
for _, a in ipairs(settings.ALPHA_AREAS) do if a == 'compass' then found = true end end
check(found, 'compass is an opacity area')
local m = settings.merge({ alphas = { tracker = 0.6, book = 0.9 } })
eq(m.alphas.compass, 0.6, 'old save: compass keeps the tracker opacity')
eq(settings.alpha_for(m, 'compass'), 0.6, 'window reads it')
local m2 = settings.merge({ alphas = { tracker = 0.6, compass = 0.35 } })
eq(m2.alphas.compass, 0.35, 'own compass value kept')
eq(settings.alpha_for(m2, 'compass'), 0.35, 'compass uses its own value')
eq(settings.alpha_for(m2, 'tracker'), 0.6, 'tracker unaffected')
eq(settings.merge({ alphas = { compass = 5 } }).alphas.compass, 1.0, 'clamped high')
eq(settings.merge({ alphas = { compass = 0.01 } }).alphas.compass, 0.3, 'clamped low')
eq(settings.merge({ background_alpha = 0.55 }).alphas.compass, 0.55, 'very old save migrates')
eq(settings.alpha_for({ alphas = { tracker = 0.7 } }, 'compass'), 0.7, 'missing key falls back to the tracker')
-- マイレイアウトにも入る（alphas ごと）
local layouts_src = io.open(ROOT .. '/src/core/layouts.lua', 'rb'):read('*a')
check(layouts_src:find("'alphas'", 1, true), 'layouts keep alphas')

-- 実際の窓の地の色
local bgs = {}
local WBG = theme.C('ImGuiCol_WindowBg')
local cur
imgui.PushStyleColor = function (id, c) if id == WBG then bgs[#bgs + 1] = c[4] end end
imgui.PopStyleColor = function () end
local real_begin = imgui.Begin
imgui.Begin = function (title, ...)
    cur = title
    if type(title) == 'string' and title:find('###astertrail_compass', 1, true) then bgs.compass = bgs[#bgs] end
    return real_begin(title, ...)
end
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(S.alphas.compass, 0.85, 'fresh settings: 85%')
app.command('/astertrail compass show'); frame(); frame()
check(drawn('###astertrail_compass'), 'compass drawn')
S.alphas.tracker = 0.5; S.alphas.compass = 0.4
bgs = {}; frame()
check(bgs.compass and math.abs(bgs.compass - 0.4) < 1e-6, 'compass background uses its own opacity: ' .. tostring(bgs.compass))
S.alphas.compass = 1.0
bgs = {}; frame()
check(bgs.compass and math.abs(bgs.compass - 1.0) < 1e-6, 'change applies next frame')

-- 設定の「見た目」に、エミネンスの次に出る。押すと 5% ずつ変わり、保存される
local sui = require('src.ui.settings_ui')
app.open_window('settings'); frame()
sui.select_tab('look'); frame(); frame()
check(labeled('##alpha_compass') or texted('背景の濃さ（コンパス）'), 'compass opacity row in 見た目')
local order, ie, ic = 0, nil, nil
for _, l in ipairs(FAKE.labels) do
    order = order + 1
    if not ie and l:find('##alpha_eminence', 1, true) then ie = order end
    if not ic and l:find('##alpha_compass', 1, true) then ic = order end
end
check(ie and ic and ie < ic, 'compass row comes after eminence')
local src = io.open(ROOT .. '/locales/ja.json', 'rb'):read('*a')
check(src:find('"settings.alpha_compass": "背景の濃さ（コンパス）"', 1, true), 'ja label')
check(not src:find('コンパスはトラッカーの濃さを使います', 1, true), 'old note removed')
app.close_window('settings'); frame()

-- 保存と読み直し
S.alphas.compass = 0.45
app.save_all('test')
local raw = io.open(TMP .. '/Vanacore/config/addons/astertrail/catseye_Tester/settings.json', 'rb'):read('*a')
local saved = require('src.lib.json').decode(raw)
eq(saved.alphas.compass, 0.45, 'saved to settings.json')
eq(settings.merge(saved).alphas.compass, 0.45, 'loads back')
print('test_compass_alpha_212 ok')
