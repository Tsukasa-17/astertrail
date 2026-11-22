-- 0.1.288：イベント中は頭上の名前も消す。アストラルお知らせの枠は一枚・ボタンは枠幅で中央へ
require('fake_env')

local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local settings = require('src.core.settings')
local marks_ui = require('src.ui.marks')
local theme = require('src.ui.theme')

local app = require('src.app')
eq(app.VERSION, '1.1.314', 'version')

local src = io.open(ROOT .. '/src/ui/marks.lua', 'r'):read('*a')
local i_draw = src:find('function marks.draw(ui)', 1, true)
check(i_draw ~= nil, 'marks.draw exists')
local chunk = src:sub(i_draw, i_draw + 2500)
check(chunk:find('marks.hide_now(ui)', 1, true) ~= nil, 'draw uses the same hide_now check as rings (0.1.296)')
check(chunk:find("why = 'event'", 1, true) ~= nil, 'event hide returns why=event')
check(chunk:find('clear_world_marks', 1, true) ~= nil, 'event hide clears world marks (object / nearby names)')
check(chunk:find('clear_name_marks', 1, true) ~= nil or chunk:find('clear()', 1, true) ~= nil,
    'event hide clears name marks (quest names and icons)')

-- 設定の案内も、名前が消えることに触れる
local ja = io.open(ROOT .. '/locales/ja.json', 'r'):read('*a')
local en = io.open(ROOT .. '/locales/en.json', 'r'):read('*a')
check(ja:find('隠す場面', 1, true) ~= nil, 'JA hide scenes label')
check(ja:find('クエスト名', 1, true) ~= nil and ja:find('オブジェクト名', 1, true) ~= nil, 'JA note lists name kinds')
check(ja:find('「調べる」だけはイベントが始まらないと分かりません', 1, true) ~= nil, 'JA help about examine')
check(en:find('Hide in scenes', 1, true) ~= nil, 'EN hide scenes label')
check(en:find('Examining alone', 1, true) ~= nil, 'EN help about examine')

local D = data_mod.load(posix_fs(), ROOT .. '/data/')
local P = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
P:reset({ server = 'catseye', name = 'Sf288' })
P:set_state('quest.bastok.003', 'accepted')
P:set_current_step('quest.bastok.003', 'quest.bastok.003#g02')

local S = settings.defaults()
S.marks.show_object_names = true
S.marks.show_nearby_names = true
S.marks.show_icons = true
S.marks.show_quest_name = true
S.marks.show_rings = true
S.marks.hide_scenes.event.on = true; S.marks.hide_scenes.menu.on = true

local attached, placed, rings, cleared = {}, {}, {}, { name = 0, world = 0, rings = 0 }
local status, menu = 0, false
local scene = {
    { index = 11, name = '???', x = 50, y = 60, z = 4, model_size = 2.5, grid = 'J-5', kind = 'npc' },
    { index = 20, name = 'Signpost', x = 55, y = 60, z = 4, model_size = 2, kind = 'npc', entity_type = 2 },
}
local ui = {
    settings = S, state = { ready = true },
    player = { zone_id = 191, x = 50, y = 60 },
    data = D, progress = P,
    platform = {
        visible_entities = function () return scene end,
        self_status = function () return status end,
        game_menu_state = function () return menu end,
        attach_available = function () return true end,
        set_name_marks = function (items) attached = items or {}; return true end,
        clear_name_marks = function () cleared.name = cleared.name + 1; attached = {} end,
        place_available = function () return true end,
        set_world_marks = function (items) placed = items or {}; return true, items and #items or 0 end,
        clear_world_marks = function () cleared.world = cleared.world + 1; placed = {} end,
        rings_available = function () return true end,
        rings_native = function () return true end,
        set_ground_rings = function (items) rings = items or {}; return true end,
        clear_ground_rings = function () cleared.rings = cleared.rings + 1; rings = {} end,
        object_info = function (e) return { type = e.entity_type, name_shown = false } end,
    },
    imgui = { GetBackgroundDrawList = function () return setmetatable({}, { __index = function () return function () end end }) end },
}

local function reset_counts()
    cleared.name, cleared.world, cleared.rings = 0, 0, 0
    attached, placed, rings = {}, {}, {}
end

local function has_index(list, idx)
    for _, it in ipairs(list or {}) do
        if it.index == idx then return true end
    end
    return false
end

-- 平常時：オブジェクト名と近くの名前が出る
status, menu = 0, false
reset_counts()
local info = marks_ui.draw(ui)
check(not info.skipped, 'idle: not skipped')
check(has_index(placed, 11), 'idle: quest object name is drawn')
check(has_index(placed, 20), 'idle: nearby object name is drawn')

-- カットシーン（status==4）：全部消えて、終わると戻る
status = 4
reset_counts()
info = marks_ui.draw(ui)
eq(info.why, 'event', 'cutscene: why is event')
check(info.skipped, 'cutscene: skipped')
eq(info.drawn, 0, 'cutscene: nothing drawn')
eq(info.nearby, 0, 'cutscene: no nearby names')
eq(#placed, 0, 'cutscene: world marks cleared (object / nearby names)')
eq(#attached, 0, 'cutscene: name marks cleared (quest names / icons)')
eq(#rings, 0, 'cutscene: rings cleared')
check(cleared.world >= 1, 'cutscene: clear_world_marks called')
check(cleared.name >= 1, 'cutscene: clear_name_marks called')

status = 0
reset_counts()
info = marks_ui.draw(ui)
check(not info.skipped, 'after cutscene: drawing resumes')
check(has_index(placed, 11), 'after cutscene: quest object name returns')
check(has_index(placed, 20), 'after cutscene: nearby object name returns')

-- ゲームのメニュー（会話など）でも同じ
status, menu = 0, true
ui.state.game_menu_open = true
reset_counts()
info = marks_ui.draw(ui)
eq(info.why, 'event', 'menu: hidden with the same check')
eq(#placed, 0, 'menu: names hidden')
ui.state.game_menu_open = nil
menu = false

-- 設定オフなら、イベント中も名前は出たまま（リングと同じ）
S.marks.hide_scenes.event.on = false; S.marks.hide_scenes.menu.on = false
status = 4
reset_counts()
info = marks_ui.draw(ui)
check(not info.skipped, 'setting off: still drawn in a cutscene')
check(has_index(placed, 11), 'setting off: object name stays')
check(has_index(placed, 20), 'setting off: nearby name stays')
S.marks.hide_scenes.event.on = true; S.marks.hide_scenes.menu.on = true
status = 0

-- アドオンの窓は消さない（リングの判定も窓は触らない）
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Sf288', zone = 230, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
FAKE.keep_default_look = true
theme.set_look('sf')
frames(1)
check(app.state.ready, 'logged in')
local AS = app._settings()
AS.look = 'sf'
app.open_window('book')
app.open_window('settings')
frames(1)
check(app.state.open.book, 'book is open before the event')
check(app.state.open.settings, 'settings is open before the event')
-- status 4 でも marks.draw は窓を閉じない
local plat = require('src.platform.ashita')
local saved = plat.self_status
plat.self_status = function () return 4 end
frames(1)
check(app.state.open.book, 'book stays open during an event')
check(app.state.open.settings, 'settings stays open during an event')
if saved then plat.self_status = saved else plat.self_status = nil end
app.close_all()

-- --- アストラルお知らせ：枠は一枚、見出しの帯なし、ボタンは枠と同じ幅で中央 ---
local nsf = io.open(ROOT .. '/src/ui/notices_sf.lua', 'r'):read('*a')
check(nsf:find('reserve_popup_inner', 1, true) ~= nil, 'popup reserves a fixed inner width')
check(nsf:find('center_in_popup', 1, true) ~= nil, 'buttons use center_in_popup')
check(nsf:find('max_w = iw', 1, true) ~= nil, 'heading uses the same inner width')
check(nsf:find("'center', iw", 1, true) ~= nil, 'wrapped text uses the same inner width')
check(nsf:find('width = yw', 1, true) ~= nil and nsf:find('width = cw', 1, true) ~= nil,
    'button widgets use the same width used for centering')

local wins = io.open(ROOT .. '/src/ui/window.lua', 'r'):read('*a')
check(wins:find("ImGuiWindowFlags_NoBackground", 1, true) ~= nil, 'glass windows request NoBackground')
check(wins:find("ImGuiCol_TitleBg", 1, true) ~= nil, 'glass windows hide the title-bar color')
check(wins:find('and 0 or 16', 1, true) ~= nil, 'SF glass sets WindowRounding to 0')
check(wins:find('SetNextWindowSizeConstraints', 1, true) ~= nil, 'SF popup width is constrained to the frame')
check(wins:find('popup_outer_w', 1, true) ~= nil, 'constraint uses sf.popup_outer_w')

local sfs = io.open(ROOT .. '/src/ui/sf_style.lua', 'r'):read('*a')
check(sfs:find('sf.POPUP_INNER_W = 560', 1, true) ~= nil, 'shared inner width is 560')
check(sfs:find('function sf.reserve_popup_inner', 1, true) ~= nil, 'reserve helper exists')
check(sfs:find('function sf.center_in_popup', 1, true) ~= nil, 'center helper exists')
-- 暈の矩形は枠と同じ x1,y1,x2,y2 から広げる
local i_pop = sfs:find('function sf.draw_popup', 1, true)
check(i_pop ~= nil, 'draw_popup exists')
local body = sfs:sub(i_pop, i_pop + 4500)
check(body:find('sf.frame(dl, x1, y1, x2, y2', 1, true) ~= nil, 'frame uses the window rect')
check(body:find('x1 - pad', 1, true) ~= nil and body:find('x2 + pad', 1, true) ~= nil,
    'halo expands from the same frame rect')

local theme = require('src.ui.theme')
eq(theme.C('ImGuiWindowFlags_NoBackground'), 128, 'NoBackground fallback is 128')

local imgui = package.loaded['imgui'] or require('imgui')
local C = theme.C
local sf = require('src.ui.sf_style')
eq(sf.POPUP_INNER_W, 560, 'inner width')
eq(sf.popup_outer_w(), 560 + (26 + sf.POPUP_GLOW) * 2, 'outer width is inner plus padding (incl. glow, 0.1.291)')

-- スタイルと制約、中央寄せの実行を記録
local styles = {}
local orig_psc = imgui.PushStyleColor
imgui.PushStyleColor = function (id, col)
    styles[#styles + 1] = { id = id, col = col }
    if orig_psc then return orig_psc(id, col) end
end
local styles_var = {}
local orig_psv = imgui.PushStyleVar
imgui.PushStyleVar = function (id, v)
    styles_var[#styles_var + 1] = { id = id, v = v }
    if orig_psv then return orig_psv(id, v) end
end
local constrained
local orig_const = imgui.SetNextWindowSizeConstraints
imgui.SetNextWindowSizeConstraints = function (a, b)
    constrained = { a = a, b = b }
    if orig_const then return orig_const(a, b) end
end
local cx, cy = 26, 22
imgui.GetCursorPosX = function () return cx end
imgui.GetCursorPosY = function () return cy end
imgui.GetCursorPos = function () return { cx, cy } end
imgui.SetCursorPosX = function (x)
    cx = tonumber(x) or cx
    FAKE.cursor_xs = FAKE.cursor_xs or {}
    FAKE.cursor_xs[#FAKE.cursor_xs + 1] = cx
end
imgui.SetCursorPosY = function (y) cy = tonumber(y) or cy end
imgui.SetCursorPos = function (p)
    local x, y
    if type(p) == 'table' then x, y = p[1] or p.x, p[2] or p.y else x, y = p, nil end
    if x ~= nil then imgui.SetCursorPosX(x) end
    if y ~= nil then imgui.SetCursorPosY(y) end
end
local dummies = {}
local orig_dummy = imgui.Dummy
imgui.Dummy = function (sz)
    dummies[#dummies + 1] = sz
    if orig_dummy then pcall(orig_dummy, sz) end
end
local frame_rects = {}
local orig_frame = sf.frame
local orig_draw_popup = sf.draw_popup
sf.frame = function (dl, x1, y1, x2, y2, opts)
    -- draw_popup 内で描いた枠だけを見る（他の SF 窓の枠は除く）
    if sf._in_draw_popup then
        frame_rects[#frame_rects + 1] = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
    end
    return orig_frame(dl, x1, y1, x2, y2, opts)
end
sf.draw_popup = function (im, kind, opts)
    sf._in_draw_popup = true
    local ok, r = pcall(orig_draw_popup, im, kind, opts)
    sf._in_draw_popup = false
    if not ok then error(r) end
    return r
end
local center_calls = {}
local orig_center = sf.center_in_popup
sf.center_in_popup = function (im, width, inner)
    local ox = orig_center(im, width, inner)
    center_calls[#center_calls + 1] = { width = width, inner = inner or sf.POPUP_INNER_W, ox = ox }
    return ox
end
-- 窓サイズは枠の外幅に合わせる（ずれた内側枠を出さない）
local outer = sf.popup_outer_w()
imgui.GetWindowSize = function () return outer, 240 end
imgui.GetWindowPos = function () return 200, 120 end

local S = app._settings()
S.look = 'sf'
theme.set_look('sf')
S.notify = S.notify or {}
S.notify.popup = true
S.notify.sound = false
S.reduce_motion = true

check(app.popup_preview('accept'), 'sf preview accept')
styles, styles_var, dummies, frame_rects, center_calls, FAKE.cursor_xs = {}, {}, {}, {}, {}, {}
constrained = nil
cx, cy = 26, 22
frame()
check(texted('QUEST ACCEPTED'), 'SF heading still QUEST ACCEPTED')

-- ImGui の地・ふち・見出しの帯は透明
local function a_of(col)
    if type(col) ~= 'table' then return nil end
    return tonumber(col[4] or col.w or col.a)
end
local function pushed(name)
    local id = C(name)
    local col
    for _, s in ipairs(styles) do
        if s.id == id then col = s.col end
    end
    return col
end
local wbg = pushed('ImGuiCol_WindowBg')
local bdr = pushed('ImGuiCol_Border')
local tbg = pushed('ImGuiCol_TitleBg')
check(wbg and a_of(wbg) == 0, 'WindowBg is transparent')
check(bdr and a_of(bdr) == 0, 'Border is transparent')
check(tbg and a_of(tbg) == 0, 'TitleBg is transparent (no dark title strip)')

-- Rounding 0（丸角の内側枠を出さない）
local rnd_id = C('ImGuiStyleVar_WindowRounding')
local rnd
for _, s in ipairs(styles_var) do
    if s.id == rnd_id then rnd = s.v end
end
eq(rnd, 0, 'SF popup WindowRounding is 0')

-- フラグ：見出しなし + 地なし
local flags
for title, f in pairs(FAKE.begin_flags or {}) do
    if tostring(title):find('astertrail_popup', 1, true) then flags = f end
end
check(flags ~= nil, 'popup Begin flags were recorded')
check(bit.band(flags, C('ImGuiWindowFlags_NoTitleBar')) ~= 0, 'NoTitleBar is set')
check(bit.band(flags, C('ImGuiWindowFlags_NoBackground')) ~= 0, 'NoBackground is set')

-- 横幅は枠の外幅に固定
check(constrained ~= nil, 'size constraints were set')
local cmin = constrained.a
local cw = type(cmin) == 'table' and (cmin[1] or cmin.x) or cmin
eq(tonumber(cw), outer, 'min width matches the frame outer width')
local cmax = constrained.b
local mw = type(cmax) == 'table' and (cmax[1] or cmax.x) or cmax
eq(tonumber(mw), outer, 'max width matches the frame outer width')

-- Dummy は 560x1 で、カーソルを戻す
local reserved = false
for _, sz in ipairs(dummies) do
    if type(sz) == 'table' then
        local w, h = tonumber(sz[1] or sz.x), tonumber(sz[2] or sz.y)
        if w == 560 and h == 1 then reserved = true end
    end
end
check(reserved, 'inner width Dummy is 560x1')

-- 枠は一枚。暈はその矩形から広がるだけ
check(#frame_rects >= 1, 'custom frame was drawn')
-- お知らせの枠は窓の矩形と一致
local fr = frame_rects[1]
-- 0.1.291〜：枠は窓の矩形から暈の幅だけ内側（暈は窓の中）
local G = sf.POPUP_GLOW
eq(fr.x1, 200 + G, 'frame left is window pos x + glow')
eq(fr.y1, 120 + G, 'frame top is window pos y + glow')
eq(fr.x2, 200 + outer - G, 'frame right is window pos + outer width - glow')
eq(fr.y2, 120 + 240 - G, 'frame bottom is window pos + height - glow')
-- 同じ描画で複数のずれた枠を足していない
local distinct = {}
for _, r in ipairs(frame_rects) do
    local k = string.format('%.1f,%.1f,%.1f,%.1f', r.x1, r.y1, r.x2, r.y2)
    distinct[k] = true
end
local nrect = 0
for _ in pairs(distinct) do nrect = nrect + 1 end
eq(nrect, 1, 'only one frame rectangle is drawn')

-- ボタンは枠の内側幅で中央
check(#center_calls >= 1, 'buttons were centered')
local cc = center_calls[1]
eq(cc.inner, 560, 'button centering uses inner width 560')
eq(cc.ox, (560 - cc.width) / 2, 'button offset is (frame width - row width) / 2')
check(cc.ox > 40, 'offset is visibly centered, not flush left')

-- 完了も同じ（金の見出し）。枠は一枚のまま
app.popup_choose(false); frames(1)
check(app.popup_preview('complete'), 'sf preview complete')
frame_rects, center_calls = {}, {}
frame()
check(texted('QUEST COMPLETE') or texted('MISSION COMPLETE') or texted('EMINENCE COMPLETE'),
    'SF complete heading')
check(#frame_rects >= 1, 'complete also draws the custom frame')
app.popup_choose(false); frames(1)

-- クラシックは英語見出しにしない（従来）
S.look = 'classic'
theme.set_look('classic')
check(app.popup_preview('accept'), 'classic preview')
frame()
check(texted('クエスト受注') or texted('Quest Accepted'), 'classic popup title unchanged')
check(not texted('QUEST ACCEPTED'), 'classic does not use the SF English heading')
app.popup_choose(false); frames(1)

-- フックを戻す
imgui.PushStyleColor = orig_psc
imgui.PushStyleVar = orig_psv
imgui.SetNextWindowSizeConstraints = orig_const
imgui.Dummy = orig_dummy
sf.frame = orig_frame
sf.draw_popup = orig_draw_popup
sf.center_in_popup = orig_center

print('test_sf_288 ok')
