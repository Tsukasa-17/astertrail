-- 0.1.298: アストラルの設定の行（名前は左・操作は右端・行のあいだに線）、隠す場面の「会話」と「メニュー」
require('fake_env')
local settings = require('src.core.settings')
local marks_ui = require('src.ui.marks')
local W = require('src.ui.widgets')

-- 会話とメニューを窓の名前で分ける（GAME-PC で見た名前）
local function kind(names) local r = {} for _, n in ipairs(names) do r[#r + 1] = { name = n } end
    return marks_ui.menu_kind(true, { rects = r, focused = { 'inline' } }) end
local tk, mn = kind({ 'rem4line', 'rem4li2', 'inline' }); eq(tk, true, 'talk window'); eq(mn, false, 'talk is not menu')
tk, mn = kind({ 'query', 'inline' }); eq(tk, true, 'choice = talk'); eq(mn, false, 'choice not menu')
tk, mn = kind({ 'shopmain', 'inline' }); eq(tk, false, 'shop not talk'); eq(mn, true, 'shop = menu')
tk, mn = kind({ 'menuwind', 'inline' }); eq(mn, true, 'main menu')
tk, mn = kind({ 'iteminfo', 'itmsort2', 'inventor', 'inline' }); eq(mn, true, 'inventory'); eq(tk, false, 'inventory not talk')
tk, mn = kind({ 'inline' }); eq(tk, false, 'inline only: not talk'); eq(mn, true, 'inline only: menu (as before)')
tk, mn = marks_ui.menu_kind(true, {}); eq(mn, true, 'flag only: menu')
tk, mn = marks_ui.menu_kind(false, { rects = { { name = 'rem4line' } } }); eq(tk, false, 'closed: nothing'); eq(mn, false, 'closed')

-- 初期値と、前の「会話・メニュー」からの引き継ぎ
local d = settings.defaults().marks.hide_scenes
eq(d.talk.on, true, 'talk default on'); eq(d.menu.on, true, 'menu default on')
eq(table.concat(settings.HIDE_SCENES, ','), 'event,combat,talk,menu,chat', 'scene order')
local m = settings.merge({ marks = { hide_scenes = { menu = { on = false, icons = false } } } }).marks
eq(m.hide_scenes.talk.on, false, '0.1.297 menu off -> talk off'); eq(m.hide_scenes.talk.icons, false, 'parts copied')
eq(m.hide_scenes.menu.on, false, 'menu kept')
m = settings.merge({ marks = { hide_scenes = { menu = { on = true } } } }).marks
eq(m.hide_scenes.talk.on, true, 'menu on -> talk on'); eq(m.hide_scenes.talk.rings, true, 'parts default')
m = settings.merge({ marks = { hide_rings_in_event = false } }).marks
eq(m.hide_scenes.talk.on, false, 'old off -> talk off'); eq(m.hide_scenes.menu.on, false, 'old off -> menu off')
m = settings.merge({ marks = { hide_scenes = { talk = { on = false }, menu = { on = true } } } }).marks
eq(m.hide_scenes.talk.on, false, 'saved talk kept'); eq(m.hide_scenes.menu.on, true, 'saved menu kept')

-- 隠す：会話だけオフなら会話の窓では消さない、メニューでは消す
local hs = settings.hide_scenes_of({})
local st = { game_menu_open = true, game_menu_info = { rects = { { name = 'rem4line' }, { name = 'inline' } } } }
local ui = { settings = { marks = { hide_scenes = hs } }, state = st, platform = { self_status = function () return 0 end } }
local h = marks_ui.hide_now(ui)
check(h and h.scene == 'talk' and h.all, 'talk hides all')
hs.talk.on = false
eq(marks_ui.hide_now(ui), nil, 'talk off: shown while talking')
st.game_menu_info = { rects = { { name = 'shopmain' } } }
h = marks_ui.hide_now(ui)
check(h and h.scene == 'menu', 'menu still hides')
hs.menu.on = false
eq(marks_ui.hide_now(ui), nil, 'menu off')

-- 行：名前は左、スイッチは箱の右端。名前は操作と重ならない（長い名前は名前の列で折り返す）
local imgui = package.loaded['imgui']
local cx, cy = 100, 50
local saved = {}
for _, k in ipairs({ 'GetCursorScreenPos', 'SetCursorScreenPos', 'InvisibleButton', 'GetItemRectMin', 'GetItemRectMax', 'Text', 'BeginGroup', 'EndGroup' }) do saved[k] = imgui[k] end
local placed, texts, last = {}, {}, nil
local groups = {}
imgui.GetCursorScreenPos = function () return { cx, cy } end
imgui.SetCursorScreenPos = function (p) cx, cy = p[1], p[2] end
imgui.Text = function (s) texts[#texts + 1] = { s = s, x = cx }; last = { cx, cy, cx + 16 * 4, cy + 16 }; cy = cy + 18 end
imgui.InvisibleButton = function (label, size)
    placed[#placed + 1] = { label = label, x = cx, y = cy, w = size[1] }
    last = { cx, cy, cx + size[1], cy + size[2] }
    for _, g in ipairs(groups) do g.x2 = math.max(g.x2, cx + size[1]) end
    return false
end
imgui.BeginGroup = function () groups[#groups + 1] = { x1 = cx, x2 = cx } end
imgui.EndGroup = function () local g = table.remove(groups); last = { g.x1, cy, g.x2, cy + 16 } end
imgui.GetItemRectMin = function () return { last and last[1] or 0, last and last[2] or 0 } end
imgui.GetItemRectMax = function () return { last and last[3] or 0, last and last[4] or 0 } end
local fui = { imgui = imgui, t = function (k) return k end }
local inner = 520
local opts = { form_right = true, form_inner = inner, form_gap = 12, section = 'page' }
W.switch(fui, 'settings', 'sw1', '未実装の札を自動でつける', false, opts)
local sw = placed[#placed]
eq(math.floor(sw.x + sw.w + 0.5), 100 + inner, 'switch right edge = box right edge')
check(texts[#texts].x == 100, 'label at the left')
eq(#texts, 1, 'label on one line (no wrap)')
-- 線は 2 行目から
local lines = 0
local dl = imgui.GetWindowDrawList()
local orig_line = dl.AddLine
dl.AddLine = function (...) lines = lines + 1 end
local o2 = { form_right = true, form_inner = inner, form_gap = 12, section = 'page', form_rule = true }
W.switch(fui, 'settings', 'sw2', '動きを減らす', false, o2)
eq(lines, 1, 'thin divider above the second row')
dl.AddLine = orig_line
-- せまい箱：名前は名前の列で折り返し、スイッチは右端のまま
local narrow = { form_right = true, form_inner = 120, form_gap = 12, section = 'page' }
local CT = require('src.ui.colored_text')
local ow, wrap_w = CT.wrapped, nil
CT.wrapped = function (u, text, col, terms, w) wrap_w = w end
W.switch(fui, 'settings', 'sw3', '未実装の札を自動でつける', false, narrow)
CT.wrapped = ow
local sw3 = placed[#placed]
eq(math.floor(sw3.x + sw3.w + 0.5), 100 + 120, 'narrow: switch still at right edge')
check(wrap_w ~= nil, 'narrow: label wraps in its column')
check(wrap_w and 100 + wrap_w <= sw3.x, 'wrapped label stays left of the switch')
-- スライダー：初めは見積もり、次のフレームから測った幅で右端にそろう
W.slider(fui, 'settings', 'sl1', '文字の大きさ', { v = 1 }, 'v', { step = 0.1, lo = 0.5, hi = 2, default = 1,
    form_right = true, form_inner = inner, form_gap = 12, form_value_w = 56, section = 'page', slider_w = 120 })
check(W._ctrl_w_cache['settings/sl1'] ~= nil, 'slider width measured')
for k, v in pairs(saved) do imgui[k] = v end

-- アストラルの設定：選ぶボタンは「名前」＋右に今の値
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
eq(app.VERSION, '1.1.327', 'version')
FAKE.player = { name = 'Rows298', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
S.look = 'sf'; require('src.ui.theme').set_look('sf')
app.open_window('settings'); frame(); frame()
require('src.ui.settings_ui').select_tab('tracker'); frame(); frame()
check(texted('文字のそろえ'), 'align label on the left')
check(labeled('右そろえ##tr_align') or labeled('右そろえ'), 'align value on the right')
check(not labeled('文字のそろえ：右そろえ'), 'no combined button text')
check(labeled('一覧##tr_view') or labeled('一覧'), 'view value on the right')
FAKE.clicks['##tr_align'] = true; frame(); frame()
eq(S.tracker.align, 'left', 'value button still switches')
check(labeled('左そろえ##tr_align') or labeled('左そろえ'), 'value updated')
-- 隠す場面に「会話」と「メニュー」（0.1.308〜は操作）
require('src.ui.settings_ui').select_tab('input'); frame(); frame()
check(texted('会話') and texted('メニュー'), 'talk and menu scenes (astral)')
check(not texted('会話・メニュー'), 'old combined label gone')
app.close_all(); frame()
S.look = 'classic'; require('src.ui.theme').set_look('classic')
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('input'); frame(); frame()
check(texted('会話') and texted('メニュー'), 'talk and menu scenes (classic)')
app.close_all(); frame()
