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
frames(1)
local S = app._settings()
eq(S.look, 'classic', 'default look is classic (0.1.204)')

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
eq(require('src.core.settings').defaults().look, 'classic', 'reset-to-default is classic')

-- 変な値はクラシックへ。前の初期値（YunaUI風）は改訂で移す。改訂後に選んだ YunaUI風はそのまま
local settings = require('src.core.settings')
eq(settings.merge({}).look, 'classic', 'merge empty is classic')
eq(settings.merge({ look = 'zzz' }).look, 'classic', 'bad look falls back to classic')
eq(settings.merge({ defaults_rev = 5, look = 'yunaui' }).look, 'classic', 'old default yunaui migrated')
eq(settings.merge({ defaults_rev = 5, look = 'classic' }).look, 'classic', 'already classic kept')
eq(settings.merge({ defaults_rev = 6, look = 'yunaui' }).look, 'yunaui', 'rev6 yunaui kept as chosen')
eq(settings.merge({ defaults_rev = 6, look = 'classic' }).look, 'classic', 'rev6 classic kept')
eq(settings.merge({ defaults_rev = 6, look = 'zzz' }).look, 'classic', 'rev6 bad falls back to classic')
print('test_look ok')
