-- 0.1.41: 見た目（YunaUI 風 / クラシック）。積んだ色と形を必ず同じ数だけ戻す。ラベルは 0.1.194 で「これまで」→「クラシック」（保存キーは classic）
require('fake_env')
local imgui = package.loaded['imgui']
local pc, pv = 0, 0
imgui.PushStyleColor = function () pc = pc + 1 end
imgui.PopStyleColor = function (n) pc = pc - (n or 1) end
imgui.PushStyleVar = function () pv = pv + 1 end
imgui.PopStyleVar = function (n) pv = pv - (n or 1) end
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local theme = require('src.ui.theme')
local focus = require('src.ui.focus')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
FAKE.keep_default_look = true
frames(1)
local S = app._settings()
eq(S.look, 'sf', 'default look is アストラル (0.1.285)')
eq(S.theme_astral_migrated, true, 'new session has the migration flag')
-- 以降の切替テストはクラシック起点（サイクルは classic → yunaui → sf → classic）
S.look = 'classic'
theme.set_look('classic')
eq(S.look, 'classic', 'classic selected for toggle tests')

local function all_windows()
    for _, w in ipairs({ 'book', 'settings', 'tracker', 'map' }) do pcall(app.open_window, w) end
    frame(); frame()
end
all_windows()
eq(theme.look, 'classic', 'theme follows setting')
eq(pc, 0, 'colors balanced (classic)'); eq(pv, 0, 'vars balanced (classic)')
local acc = theme.col('accent')
check(math.abs(acc[2] - 0.83) < 1e-6, 'classic gold accent')
local item_c = theme.col('item')
local g = theme.col('gold'); check(math.abs(g[2] - 0.83) < 1e-6, 'icon gold kept in classic')

-- 設定の 見た目 タブにある切り替え
app.close_all(); app.open_window('settings'); frame(); frame(); frame()
check(labeled('見た目：クラシック'), 'toggle label is classic')
focus.set('settings', 'look_style'); frame()
press(0x1C); frame(); frame()
eq(S.look, 'yunaui', 'toggle to YunaUI style')
check(labeled('見た目：YunaUI風'), 'label shows YunaUI style')
eq(theme.look, 'yunaui', 'theme yunaui')
local acc2 = theme.col('ring')
check(math.abs(acc2[1] - 1.0) < 1e-6 and math.abs(acc2[2] - 0.42) < 1e-6, 'neon focus ring in yunaui')
local item_y = theme.col('item')
for i = 1, 3 do eq(item_y[i], item_c[i], 'name color unchanged ' .. i) end
all_windows()
eq(pc, 0, 'colors balanced (yunaui)'); eq(pv, 0, 'vars balanced (yunaui)')

-- 初期値に戻すとクラシック
eq(require('src.core.settings').defaults().look, 'sf', 'reset-to-default is アストラル')

-- 0.1.285：印が無い保存は一度アストラルへ。印のあとは自分で選んだ見た目を維持する
local settings = require('src.core.settings')
eq(settings.merge({}).look, 'sf', 'merge empty is アストラル')
eq(settings.merge({}).theme_astral_migrated, true, 'merge empty sets the flag')
eq(settings.merge({ look = 'classic' }).look, 'sf', 'first load migrates classic to アストラル')
eq(settings.merge({ look = 'yunaui' }).look, 'sf', 'first load migrates yunaui to アストラル')
eq(settings.merge({ look = 'zzz' }).look, 'sf', 'bad look without flag becomes アストラル')
local m = settings.merge({ look = 'classic', theme_astral_migrated = true })
eq(m.look, 'classic', 'after migration, classic is kept')
eq(m.theme_astral_migrated, true, 'flag stays')
eq(settings.merge({ look = 'yunaui', theme_astral_migrated = true }).look, 'yunaui', 'after migration, yunaui is kept')
eq(settings.merge({ look = 'sf', theme_astral_migrated = true }).look, 'sf', 'after migration, アストラル is kept')
eq(settings.merge({ look = 'zzz', theme_astral_migrated = true }).look, 'sf', 'bad look after migration falls back to アストラル')
eq(theme.next_look('classic'), 'yunaui', 'cycle classic to yunaui')
eq(theme.next_look('yunaui'), 'sf', 'cycle yunaui to sf')
eq(theme.next_look('sf'), 'classic', 'cycle sf to classic')

-- 2回目のボタンで SF、3回目でクラシックに戻る
app.close_all(); app.open_window('settings'); frame(); frame(); frame()
eq(S.look, 'yunaui', 'still yunaui before second press')
focus.set('settings', 'look_style'); frame()
press(0x1C); frame(); frame()
eq(S.look, 'sf', 'toggle to アストラル')
check(labeled('アストラル') and texted('テーマ'), 'label テーマ + value アストラル (0.1.298)')
eq(theme.look, 'sf', 'theme sf')
all_windows()
eq(pc, 0, 'colors balanced (sf)'); eq(pv, 0, 'vars balanced (sf)')
local acc3 = theme.col('border')
check(acc3[3] > acc3[1], 'sf border is cyan-leaning')
focus.set('settings', 'look_style'); frame()
press(0x1C); frame(); frame()
eq(S.look, 'classic', 'third press back to classic')
print('test_look ok')
