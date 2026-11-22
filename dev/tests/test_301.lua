-- 0.1.301：窓ごとの隠す場面・メニューと重なったとき（隠す／後ろに出す）・単体の詳細の ??? で地図・地図のマス目のツールチップ
require('fake_env')

local flag = false
local on_top_calls = {}
_G.vana = {
    game = { target = function () return { menu_open = flag } end },
    gameui = {
        windows = function () return { 'helpwind' } end,
        window = function (n) return { name = n, focused = false, closing = false, hidden = false } end,
        catch = function () return 1 end, off = function () end,
        watch = function () return 1 end, unwatch = function () end,
        add = function () return true end, remove = function () end,
    },
    ui = { game_on_top = function (on) on_top_calls[#on_top_calls + 1] = on end },
}

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local smod = require('src.core.settings')
FAKE.player = { name = 'Rb301', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(app.VERSION, '1.1.308', 'version')

-- 初期値：窓は隠さない・重なったら隠す（今まで）
for _, sc in ipairs(smod.HIDE_SCENES) do
    for _, w in ipairs(smod.HIDE_WINDOWS) do
        eq(S.marks.hide_scenes[sc]['win_' .. w], false, 'default win_' .. w .. ' off in ' .. sc)
    end
end
eq(S.gameui.menu_overlap, 'hide', 'default menu_overlap = hide')
local bad = smod.merge and smod.merge({ gameui = { menu_overlap = 'zzz' } }) or nil
if bad then eq(bad.gameui.menu_overlap, 'hide', 'unknown menu_overlap falls back to hide') end

-- 戦闘中：場面がオンでも、窓にチェックが無ければ隠さない
S.tracker.visible = true
S.marks.hide_scenes.combat.on = true
FAKE.player.status = 1
frames(0.3)
check(not app.scene_hides('tracker'), 'combat on but no window checked: tracker stays')
S.marks.hide_scenes.combat.win_tracker = true
frames(0.3)
check(app.scene_hides('tracker'), 'combat + win_tracker: tracker hidden')
check(not app.scene_hides('book'), 'book not checked: not hidden')
FAKE.player.status = 0
frames(0.3)
check(not app.scene_hides('tracker'), 'out of combat: tracker back')
S.marks.hide_scenes.combat.on = false
S.marks.hide_scenes.combat.win_tracker = false

-- メニューと重なったとき
S.gameui.menus_on_top = true
cmd('/astertrail'); frames(0.3)
check(app.state.open.book, 'book open')
flag = true; frames(0.3)
check(not app.book_visible(), 'hide: book hidden while menu open')
flag = false; frames(0.3)
check(app.book_visible(), 'hide: book back after menu')
S.gameui.menu_overlap = 'behind'
flag = true; frames(0.3)
check(app.book_visible(), 'behind: book stays while menu open')
eq(app.state.game_menu_rects, nil, 'behind: no yielding rects')
eq(on_top_calls[#on_top_calls], true, 'behind: game menu asked on top')
flag = false; frames(0.3)
eq(on_top_calls[#on_top_calls], false, 'behind: on top released after menu')
S.gameui.menu_overlap = 'hide'
cmd('/astertrail close'); frames(0.2)

-- 単体の詳細：??? で地図（クラシック）
do
    local Qe, s02 = 'quest.bastok.003', 'quest.bastok.003#g02'
    app.request('set_current_step', Qe, s02)
    app.state.open.map = false
    app.open_detail_solo(Qe)
    FAKE.labels = {}
    frame(); frame()
    check(app.state.open.detail, 'detail solo open')
    check(labeled('???'), '??? link in detail solo')
    FAKE.clicks['???'] = true
    frame(); frame()
    check(app.state.open.map, '??? in detail solo opens map')
    eq(app.state.map and app.state.map.quest, Qe, 'map is that quest')
    app.state.open.map = false
    app.state.open.detail = false
end

-- 地図のマス目：名前とツールチップ
local maps = require('src.core.maps')
local lay = { cell = 10, margin = 0, col_ids = { 5, 6, 7 }, row_ids = { 6, 7, 8 } }
eq(maps.grid_name_in(lay, 65, 75), 'G-8', 'G-8 from layout')
eq(maps.grid_name_in(lay, 5, 75), nil, 'outside grid: nil')
local mv = require('src.ui.map_view')
FAKE.texts = {}
local imgui = require('imgui')
local tips = {}
local keep_tip = imgui.SetTooltip
local W = require('src.ui.widgets')
local keep_wt = W.tooltip
W.tooltip = function (_, s) tips[#tips + 1] = s end
eq(mv.grid_tip({ imgui = imgui, t = function (k) return k end, settings = S }, { bx = 65, by = 75 }, lay), 'G-8', 'grid tip text')
eq(tips[1], 'G-8', 'tooltip shows G-8 (readable tooltip style)')
eq(mv.grid_tip({ imgui = imgui }, nil, lay), nil, 'no hover: no tip')
W.tooltip = keep_wt
imgui.SetTooltip = keep_tip

-- アストラル：「背景の濃さ」は背景色・背景グラデーション・背景の終わりの色と同じまとまりの先頭（クエスト名・クエストの対象名とも color_main）
do
    local f = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'); local src = f:read('*a'); f:close()
    local body = src:match('local function color_main%(.-\nend\n')
    check(body, 'color_main found')
    local g2 = select(2, body:find('group%(function %(%)[^\n]*\n.-group%(function %(%)'))
    local a = body:find("'_bg_alpha'", 1, true) and body:find("stepper(ui, name, 'marks_' .. bg_key", 1, true)
    local c = body:find("'marks_' .. which .. '_bg_color',", 1, true)
    check(g2 and a and c and g2 < a and a < c, 'bg density is first row inside the bg group')
    local tail = body:sub(c)
    check(not tail:find('stepper(ui, name, \'marks_\' .. bg_key', 1, true), 'no density row after the bg group')
end
