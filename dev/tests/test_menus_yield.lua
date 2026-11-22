-- 0.1.189（t315）：ゲームのメニューが開いている間、そのメニューと重なるこちらの窓は、どれも同じように引っ込む
-- （透明・マウスを通す）。エミネンスの窓だけ前に残っていた（ホームポイントのメニューが後ろ）のを直した。
require('fake_env')
local im = require('imgui')
local theme = require('src.ui.theme')
local NOMOUSE = theme.C('ImGuiWindowFlags_NoMouseInputs')
check(NOMOUSE == 512, 'NoMouseInputs flag known')

-- 窓ごとの場所（実機の ImGui と同じに、Begin した窓の場所を返す）
local POS = {}
local cur_title
local orig_begin = im.Begin
im.Begin = function (title, open, flags) cur_title = title; return orig_begin(title, open, flags) end
local function where()
    local n = cur_title and cur_title:match('###astertrail_(%w+)')
    return POS[n] or { 100, 100, 400, 300 }
end
im.GetWindowPos = function () local p = where(); return p[1], p[2] end
im.GetWindowSize = function () local p = where(); return p[3], p[4] end
-- Alpha（透明）を積んだ回数
local alpha_pushes = {}
local orig_psv = im.PushStyleVar
im.PushStyleVar = function (id, v)
    if id == theme.C('ImGuiStyleVar_Alpha') and v == 0.0 then alpha_pushes[#alpha_pushes + 1] = true end
    if orig_psv then return orig_psv(id, v) end
end

-- VanaCore：メニューの印と窓の一覧
local flag = false
local WINS = {
    helpwind = { x = 188, y = 0, w = 3013, h = 40, drawn = true },
    logwindo = { x = 57, y = 1317, w = 900, h = 300, drawn = true },
}
local order = { 'helpwind', 'logwindo' }
local on_top = {}
_G.vana = {
    game = { target = function () return { menu_open = flag } end },
    gameui = {
        windows = function () local o = {} for i, n in ipairs(order) do o[i] = n end return o end,
        window = function (n) local w = WINS[n]; if not w then return nil end
            return { name = n, x = w.x, y = w.y, w = w.w, h = w.h, focused = w.focused or false,
                     closing = w.closing or false, hidden = w.hidden or false, drawn = w.drawn ~= false } end,
    },
    ui = { game_on_top = function (on) on_top[#on_top + 1] = on end },
}

-- 1) 読み取り：いつもの窓（ヘルプの行・チャット欄）は数えない。小さい・閉じかけ・隠れた窓も数えない
local ext = require('src.platform.vanacore_ext')
order[#order + 1] = 'inline'; WINS.inline = { x = 40, y = 60, w = 600, h = 400, focused = true }
order[#order + 1] = 'tiny'; WINS.tiny = { x = 0, y = 0, w = 10, h = 10 }
order[#order + 1] = 'gone'; WINS.gone = { x = 0, y = 0, w = 300, h = 300, closing = true }
local open, info = ext.game_menu_state()
eq(open, true, 'menu open (focused inline)')
eq(#info.rects, 1, 'one menu rect'); eq(info.rects[1].name, 'inline', 'the inline menu')
eq(info.rects[1].x, 40, 'x'); eq(info.rects[1].w, 600, 'w')
order = { 'helpwind', 'logwindo' }; WINS.tiny = nil; WINS.gone = nil; WINS.inline = nil

-- 2) 窓の部品だけで、全部の窓が同じように譲る
local window = require('src.ui.window')
local settings = require('src.core.settings')
do
    local S = settings.defaults()
    local st = { game_menu_rects = { { name = 'inline', x = 40, y = 60, w = 600, h = 400 } } }
    local ui = { imgui = im, settings = S, state = st, mark_settings_dirty = function () end, activate = function () end }
    local names = {}
    for n in pairs(window.DEFAULTS) do names[#names + 1] = n end
    table.sort(names)
    check(#names >= 10, 'all windows listed: ' .. #names)
    local function draw_all()
        FAKE.begin_flags = {}
        for _, n in ipairs(names) do
            cur_title = nil
            window.begin(ui, n, { title = n })
            window.finish(ui, n)
        end
        cur_title = nil
    end
    -- 重なる場所（全部の窓）
    for _, n in ipairs(names) do POS[n] = { 100, 100, 300, 200 } end
    draw_all()   -- 1回目は前の場所が無い
    draw_all()
    for _, n in ipairs(names) do
        local f = FAKE.begin_flags[n .. '###astertrail_' .. n]
        check(f and math.floor(f / NOMOUSE) % 2 == 1, n .. ': steps aside over a game menu')
    end
    eq(#window.yielding(), #names, 'every window yielding')
    -- 重ならない場所
    for _, n in ipairs(names) do POS[n] = { 1500, 900, 300, 200 } end
    draw_all(); draw_all()
    for _, n in ipairs(names) do
        local f = FAKE.begin_flags[n .. '###astertrail_' .. n]
        check(f and math.floor(f / NOMOUSE) % 2 == 0, n .. ': stays when not overlapping')
    end
    eq(#window.yielding(), 0, 'none yielding')
    -- メニューを閉じたら全部戻る
    for _, n in ipairs(names) do POS[n] = { 100, 100, 300, 200 } end
    draw_all(); draw_all()
    st.game_menu_rects = nil
    draw_all()
    eq(#window.yielding(), 0, 'all back after the menu closes')
    POS = {}
    window._reset_yield()
end

-- 3) 本体：本・トラッカー・地図・エミネンス・コンパス・続き・お知らせ・詳細・入口
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
FAKE.player = { name = 'Yield', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local Q = 'quest.sandoria.001'
app.request('pin', Q)
S.tracker.visible = true; S.tracker.collapsed = false
S.eminence.visible = true; S.compass.visible = true; S.notify.popup = true
app.open_window('book')
app.open_map(Q)
app.state.popups[#app.state.popups + 1] = { kind = 'accept', quest = Q }
frames(0.5)
local function titles()
    local out = {}
    for t in pairs(FAKE.begin_flags or {}) do local n = t:match('###astertrail_(%w+)'); if n then out[n] = FAKE.begin_flags[t] end end
    return out
end
local function check_all(expect, label)
    FAKE.begin_flags = {}
    frame(); frame()
    local got = titles()
    local n = 0
    for name, f in pairs(got) do
        n = n + 1
        local y = math.floor(f / NOMOUSE) % 2 == 1
        check(y == expect, label .. ': ' .. name .. (expect and ' steps aside' or ' stays'))
    end
    return got, n
end
local got, n = check_all(false, 'no menu')
for _, w in ipairs({ 'book', 'tracker', 'map', 'eminence', 'compass', 'popup' }) do
    check(got[w] ~= nil, 'drawn: ' .. w)
end
-- ホームポイントのメニュー（左上。全部の窓と重なる場所に）
order[#order + 1] = 'inline'; WINS.inline = { x = 0, y = 0, w = 1920, h = 1080, focused = true }
frames(0.3)
eq(app.state.game_on_top, true, 'game on top as before')
check_all(true, 'home point menu')
local a0 = #alpha_pushes
frame()
check(#alpha_pushes > a0, 'drawn transparent')
-- 本を閉じて、詳細だけ・入口
app.close_window('map'); app.close_window('book'); frames(0.3)
app.open_detail_solo(Q); frames(0.3)
got = check_all(true, 'home point menu (detail, entry)')
check(got.detail ~= nil, 'drawn: detail')
check(got.entry ~= nil or not S.entry_icon.visible, 'drawn: entry')
-- コマンドに引っ込めた窓が出る
FAKE.printed = {}
cmd('/astertrail menus')
check(printed('ゲームのメニューの窓 inline'), 'menus lists the game menu window')
check(printed('エミネンス'), 'menus lists the Eminence window')
-- メニューの場所が離れていれば、そのまま
WINS.inline = { x = 1700, y = 1000, w = 100, h = 50, focused = true }
frames(0.3)
check_all(false, 'menu far away')
-- 閉じたら戻る
WINS.inline = { x = 0, y = 0, w = 1920, h = 1080, focused = true }; frames(0.3)
order[#order] = nil; WINS.inline = nil
frames(0.3)
check_all(false, 'menu closed')
eq(app.state.game_menu_rects, nil, 'no rects after close')
-- 設定でオフ：引っ込めない
S.gameui.menus_on_top = false
order[#order + 1] = 'inline'; WINS.inline = { x = 0, y = 0, w = 1920, h = 1080, focused = true }
frames(0.3)
check_all(false, 'setting off')
S.gameui.menus_on_top = true
-- メインメニュー（印と menuwind）
order[#order] = nil; WINS.inline = nil
flag = true; order[#order + 1] = 'menuwind'; WINS.menuwind = { x = 0, y = 0, w = 1920, h = 1080 }
frames(0.3)
check_all(true, 'main menu')
flag = false; order[#order] = nil; WINS.menuwind = nil
frames(0.3)
check_all(false, 'main menu closed')
-- アンロードで消す
app.release_gameui()
eq(app.state.game_menu_rects, nil, 'released on unload')
