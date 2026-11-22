-- 0.1.273：SF 設定パネル内の説明・長い値は内側の幅で折り返す。詳細の手順と報酬のあいだに横線
require('fake_env')
local imgui = package.loaded['imgui'] or require('imgui')

local app = require('src.app')
eq(app.VERSION, '1.1.308', 'version')

local CT = require('src.ui.colored_text')
local theme = require('src.ui.theme')
local sf = require('src.ui.sf_style')
local json = require('src.lib.json')

local settings_src = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a')
check(settings_src:find('panel_inner_w', 1, true) ~= nil, 'settings_sf tracks panel inner width')
check(settings_src:find("CT.wrapped(ui, text, 'muted'", 1, true) ~= nil, 'help wraps to panel inner width')
check(settings_src:find('PushTextWrapPos', 1, true) ~= nil, 'panel also sets ImGui wrap pos')
check(settings_src:find('wrap_w = panel_inner_w', 1, true) ~= nil, 'toggles and sliders pass wrap_w')
check(settings_src:find('o.wrap_w = panel_inner_w', 1, true) ~= nil or settings_src:find('o.wrap_w == nil then o.wrap_w = panel_inner_w', 1, true) ~= nil, 'color rows get wrap_w')

local book_src = io.open(ROOT .. '/src/ui/book_sf.lua', 'r'):read('*a')
check(book_src:find('sf.rule', 1, true) ~= nil, 'quest/mission detail draws a rule')
check(book_src:find('sf.rule_gap', 1, true) ~= nil, 'steps/bottom split reserves the rule gap')

local em_src = io.open(ROOT .. '/src/ui/eminence_sf.lua', 'r'):read('*a')
check(em_src:find('sf.rule', 1, true) ~= nil, 'eminence detail draws a rule before reward')
-- クラシックの詳細は触らない
local detail_src = io.open(ROOT .. '/src/ui/detail.lua', 'r'):read('*a')
check(not detail_src:find('sf.rule(', 1, true), 'classic detail has no SF rule')

local ja = json.decode(io.open(ROOT .. '/locales/ja.json', 'r'):read('*a'))
local note = ja['settings.reset_unstarted_note']
local debug_note = ja['settings.debug_note']
local layouts_tip = ja['settings.layouts_tip']
check(type(note) == 'string' and #note > 40, 'reset note is a long Japanese string')
local yuna = 'Based on YunaUI by Yunas - https://github.com/YunasXI/yunaui'

-- 子窓の残り幅より狭い幅を渡すと、複数行になる（2列ではみ出す再現）
local function wrap_out(text, width)
    local out = {}
    local fake = { imgui = setmetatable({
        GetContentRegionAvail = function () return 800, 200 end,
        CalcTextSize = imgui.CalcTextSize,
        TextDisabled = function (s) out[#out + 1] = s end,
        TextColored = function (_, s) out[#out + 1] = s end,
    }, { __index = function () return function () end end }) }
    CT.wrapped(fake, text, 'muted', nil, width)
    return out
end

local function widest(lines)
    local m = 0
    for _, l in ipairs(lines) do
        local w = select(1, imgui.CalcTextSize(l))
        w = (type(w) == 'table' and (w.x or w[1])) or w
        m = math.max(m, tonumber(w) or 0)
    end
    return m
end

local narrow = 160
for name, text in pairs({
    reset = note,
    debug = debug_note,
    layouts = layouts_tip,
    yuna = yuna,
    folder = '設定フォルダ: C:\\Games\\CatsEyeXI\\catseyexi-client\\Vanacore\\config\\addons\\astertrail\\Tester',
    version = 'バージョン 0.1.273 ／ データ 2026.11.20-125',
    preview = '文字サイズと背景の濃さの見本',
}) do
    local lines = wrap_out(text, narrow)
    check(#lines >= 2, name .. ' wraps to more than one line at 160px')
    check(widest(lines) <= narrow + 20, name .. ' each line fits the given width (kinsoku may hang one mark)')
    local joined = table.concat(lines):gsub(' ', '')
    local compact = tostring(text):gsub(' ', '')
    check(joined:find(compact:sub(1, 12), 1, true) or compact:find(joined:sub(1, 8), 1, true), name .. ' text is kept')
end

-- 幅を省略したときはAvailを使う。明示幅はAvailより優先する
do
    local out = {}
    local fake = { imgui = setmetatable({
        GetContentRegionAvail = function () return 800, 200 end,
        CalcTextSize = imgui.CalcTextSize,
        TextDisabled = function (s) out[#out + 1] = s end,
    }, { __index = function () return function () end end }) }
    CT.wrapped(fake, note, 'muted', nil, 160)
    check(#out >= 2, 'explicit width wins over a wide Avail')
end

-- 横線：内側の幅いっぱいに描き、上下の余白で高さを進める
eq(sf.rule_gap(), 13, 'default rule gap is pad+thick+pad')
do
    local lines, dummy, y = {}, {}, 40
    local im = {
        Dummy = function (sz)
            dummy[#dummy + 1] = sz
            y = y + ((type(sz) == 'table' and (sz[2] or sz.y)) or 0)
        end,
        GetWindowDrawList = function ()
            return {
                AddLine = function (_, a, b, col, thick)
                    lines[#lines + 1] = { a = a, b = b, col = col, thick = thick }
                end,
            }
        end,
        GetCursorScreenPos = function () return 20, y end,
        GetContentRegionAvail = function () return 300, 80 end,
    }
    local h = sf.rule(im)
    eq(h, 13, 'rule returns the consumed height')
    check(#dummy >= 2, 'rule advances with padding dummies')
    check(#lines >= 2, 'rule draws a subtle glow plus the cyan line')
    local core = lines[#lines]
    local x1 = (type(core.a) == 'table' and (core.a[1] or core.a.x)) or core.a
    local x2 = (type(core.b) == 'table' and (core.b[1] or core.b.x)) or core.b
    eq(x1, 20, 'rule starts at the pane left')
    eq(x2, 320, 'rule spans the inner width (20+300)')
    local y1 = (type(core.a) == 'table' and (core.a[2] or core.a.y))
    local y2 = (type(core.b) == 'table' and (core.b[2] or core.b.y))
    eq(y1, y2, 'rule is horizontal')
end

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)

local function texted(s)
    for _, l in ipairs(FAKE.texts) do if tostring(l):find(s, 1, true) then return true end end
    return false
end
local function labeled(s)
    for _, l in ipairs(FAKE.labels) do if tostring(l):find(s, 1, true) then return true end end
    return false
end
local function seen(s) return texted(s) or labeled(s) end
local function seen_joined(s)
    if seen(s) then return true end
    local all = table.concat(FAKE.texts or {}) .. table.concat(FAKE.labels or {})
    return all:find(s, 1, true) ~= nil
end

local S = app._settings()
S.look = 'sf'
theme.set_look('sf')
app.open_window('settings'); frame(); frame(); frame()
require('src.ui.settings_ui').select_tab('save'); frame(); frame(); frame()
check(seen_joined('ゲームの記録で受注') or seen_joined('未開始に戻す'), 'save/PROGRESS help is drawn')
check(seen_joined('github.com/YunasXI') or seen_joined('Based on YunaUI'), 'ABOUT YunaUI credit is drawn')
check(seen_joined(app.VERSION), 'footer or about shows the version')
-- くっきりの長いラベルは折り返してもスイッチの ID は残る
require('src.ui.settings_ui').select_tab('look'); frame(); frame(); frame()
check(labeled('画面の文字をくっきり（メイリオ）'), 'long look label keeps its widget id')

-- クラシックの設定は触っていない
S.look = 'classic'
theme.set_look('classic')
app.close_all(); app.open_window('settings'); frame(); frame(); frame()
check(labeled('画面の文字をくっきり（メイリオ）'), 'classic uses the same settings rows (0.1.304)')

print('test_sf_273 ok')
