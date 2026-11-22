-- いまいる階（FloorId → MAP）と、場所ごとの文字サイズ
require('harness')
local json = require('src.lib.json')
local data_mod = require('src.core.data')
local maps = require('src.core.maps')
local settings = require('src.core.settings')

local fs = posix_fs()
local D = data_mod.load(fs, ROOT .. '/data/')

-- FloorId → MAP 番号（表のとおり。無ければ nil）
eq(maps.map_n_for_floor(D, 193, 14), 3, 'ordelle FloorId 14 = MAP 3')
eq(maps.map_n_for_floor(D, 193, 15), 4, 'ordelle FloorId 15 = MAP 4')
eq(maps.map_n_for_floor(D, 238, 2), 2, 'waters FloorId 2 = MAP 2')
eq(maps.map_n_for_floor(D, 238, 99), nil, 'unknown FloorId')
eq(maps.map_n_for_floor(D, 238, nil), nil, 'nil FloorId')
eq(maps.map_n_for_floor(D, 9999, 1), nil, 'unknown zone')

-- 文字サイズ：古い保存（共通の1つだけ）は、各場所の初めの値になる
do
    local m = settings.merge({ settings_schema = 1, font_scale = 1.3 })
    for _, a in ipairs(settings.FONT_AREAS) do eq(m.fonts[a], 1.3, 'migrated ' .. a) end
    eq(m.font_scale, 1.3, 'other keeps old value')
    local big = settings.merge({ settings_schema = 1, font_scale = 3.9 })
    eq(big.fonts.book, 3.9, 'book 3.9 (0.1.210: max 4.0)')
    eq(big.fonts.overhead_quest, 3.2, 'overhead quest clamped to 3.2')
    eq(big.fonts.overhead_name, 3.2, 'overhead name clamped to 3.2')
    eq(big.fonts.list, 3.0, 'list clamped to 3.0')
    local mixed = settings.merge({ settings_schema = 1, font_scale = 1.2, fonts = { book = 0.9, map = 5 } })
    eq(mixed.fonts.book, 0.9, 'saved book kept')
    eq(mixed.fonts.map, 4.0, 'map clamped to 4.0')
    eq(mixed.fonts.detail, 1.2, 'missing detail from old value')
    local d = settings.defaults()
    for _, a in ipairs(settings.FONT_AREAS) do eq(d.fonts[a], 1.0, 'default ' .. a) end
    eq(settings.font_for({ font_scale = 1.4 }, 'tracker'), 1.4, 'font_for falls back')
    eq(settings.font_for({ font_scale = 1.4, fonts = { tracker = 0.8 } }, 'tracker'), 0.8, 'font_for area')
    eq(settings.font_for(nil, 'map'), 1.0, 'font_for nil')
    -- 保存してから読み直しても同じ
    local again = settings.merge(json.decode(json.encode(mixed)))
    eq(again.fonts.book, 0.9, 'round trip')
end

---------------------------------------------------------------------------
-- 偽のゲーム：メモリと関数呼び出し
---------------------------------------------------------------------------
require('fake_env')

local BASE, SIZE = 0x10000000, 0x01000000
local FUNC_AT, OWNER_AT, SLOT, OBJ = 0x10001000, 0x10002000, 0x10500000, 0x20000000
local FUNC_SIG = '8B542408568D4424108BF18B4C2410508B44240C'
local OWNER_SIG = '8B7424148B4424108B7C240C8B0D'
local G = { ret = 2, calls = {}, finds = 0, fail = false, mode = 'ok' }

ashita.memory = {
    find = function (module, size, pattern, offset, nth)
        G.finds = G.finds + 1
        check(module == 'FFXiMain.dll', 'game module')
        if G.mode == 'missing' then return 0 end
        if G.mode == 'twice' and (nth or 0) == 1 then return (pattern == FUNC_SIG) and 0x10009000 or 0 end
        if (nth or 0) ~= 0 then return 0 end
        if pattern == FUNC_SIG then return FUNC_AT + (offset or 0) end
        if pattern == OWNER_SIG then return OWNER_AT + (offset or 0) end
        return 0
    end,
    read_uint32 = function (addr)
        if addr == OWNER_AT + 0x0E then return SLOT end
        if addr == SLOT then return OBJ end
        return 0
    end,
    get_base = function () return BASE end,
    get_size = function () return SIZE end,
}

local fake_ffi = {
    typeof = function (s) return s end,
    cast = function (t, v)
        if t == 'void *' then return { ptr = v } end
        check(t:find('__thiscall', 1, true), 'thiscall type')
        check(v == FUNC_AT, 'cast at found function')
        return function (this, a, b, c)
            G.calls[#G.calls + 1] = { this = this.ptr, a = a, b = b, c = c }
            if G.fail then error('boom') end
            return G.ret
        end
    end,
}

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local P = require('src.platform.ashita')
P._ffi = fake_ffi
local function reset_floor()
    for k in pairs(P._floor) do P._floor[k] = nil end
    P._floor.tried = false
end

FAKE.player = { name = 'Tester', zone = 238, tidx = 5, status = 0, x = 10, y = -20, z = 3 }
frames(3)   -- ゾーン直後の待ちを過ぎる

-- 0.1.171〜：ゾーンに入って少ししたら一度だけ、出口と「来たときに立つ位置」の階を調べて覚える（読むだけ）
local exits = require('src.core.exits')
local D = app._data()
local n_pts = #exits.of(D, 238) + #exits.arrivals(D, 238)
check(n_pts > 0, 'zone 238 has exits')
eq(#G.calls, n_pts, 'exit floors learned once on entering')
eq(G.calls[1].this, OBJ, 'learning calls the same game function')
eq(G.calls[1].a, exits.of(D, 238)[1].x, 'learn: x'); eq(G.calls[1].c, exits.of(D, 238)[1].y, 'learn: y')
frames(3)
eq(#G.calls, n_pts, 'not again in the same zone')
G.calls = {}
-- 地図を開いていないときは、いまいる階は呼ばない
frames(3)
eq(#G.calls, 0, 'no call without map')

-- ウィンダス水の区（2枚）。目的地 MAP 1 で開き、ゲームは MAP 2 と言う
app.open_map('quest.windurst.003')
frame(); frame()
eq(app.state.map.map_n, 1, 'opens on destination MAP')
check(#G.calls >= 1, 'floor checked')
local c = G.calls[1]
eq(c.this, OBJ, 'this = zone map manager')
eq(c.a, 10, 'arg x'); eq(c.b, 3, 'arg height (z)'); eq(c.c, -20, 'arg y')
eq(app.state.floor.floor_id, 2, 'FloorId 2')
eq(app.state.floor.map_n, 2, 'MAP 2')
check(labeled('MAP 2（現在地）'), 'current MAP marked on button')
check(not labeled('MAP 1（現在地）'), 'not on MAP 1')
check(not texted('◆＝現在地'), 'no diamond on other MAP')
check(texted('現在地は MAP 2 です'), 'says where you are')
check(texted('○＝目的地'), 'dest still on MAP 1')

-- 1秒ごと（毎フレームは呼ばない）
local n0 = #G.calls
frames(0.5)
eq(#G.calls, n0, 'not every frame')
frames(0.7)
eq(#G.calls, n0 + 1, 'about once a second')

-- MAP 2 を選ぶと菱形が出る
FAKE.clicks['MAP 2'] = true; frame(); frame()
eq(app.state.map.map_n, 2, 'switched to MAP 2')
check(texted('◆＝現在地'), 'diamond on current MAP')
check(not texted('現在地は MAP'), 'no other-MAP note')

-- ゲームが MAP 1 に変わる
G.ret = 1; frames(1.2)
eq(app.state.floor.map_n, 1, 'now MAP 1')
check(not texted('◆＝現在地'), 'diamond hidden on MAP 2')
check(texted('現在地は MAP 1 です'), 'points to MAP 1')
check(labeled('MAP 1（現在地）'), 'button follows')

-- 表に無い FloorId：これまでどおり（選んだ MAP に菱形）
G.ret = 77; frames(1.2)
eq(app.state.floor.map_n, nil, 'unknown FloorId has no MAP')
eq(app.state.floor.why, 'not_in_table', 'reason')
check(texted('◆＝現在地'), 'fallback draws diamond on selected MAP')
check(not labeled('（現在地）'), 'no current mark')

-- 負の値（判定なし）も、これまでどおり
G.ret = -1; frames(1.2)
eq(app.state.floor.floor_id, nil, 'negative is none')
check(texted('◆＝現在地'), 'fallback on negative')

-- デバッグ表示
G.ret = 2
FAKE.printed = {}
cmd('/astertrail floor')
check(printed('FloorId 2') and printed('MAP 2') and printed('ゾーン 238'), 'floor command prints')
check(printed('ashita.memory'), 'shows source')
G.ret = 55
FAKE.printed = {}
cmd('/astertrail floor')
check(printed('FloorId 55') and printed('MAP 不明'), 'floor command unknown MAP')

-- 呼び出しが失敗したら、それ以降は呼ばない（これまでどおりの表示）
G.fail = true; G.ret = 2
local before = #G.calls
frames(1.2)
G.fail = false
frames(3)
eq(#G.calls, before + 1, 'no more calls after failure')
eq(P._floor.why, 'call_failed', 'call_failed kept')
check(texted('◆＝現在地'), 'fallback after failure')
check(not labeled('（現在地）'), 'no mark after failure')

-- 見つからない：探すのは一度だけで、呼ばない
reset_floor(); G.mode = 'missing'; G.calls = {}; G.finds = 0
frames(3)
eq(#G.calls, 0, 'no call when not found')
local finds = G.finds
frames(3)
eq(G.finds, finds, 'scan only once')
eq(P._floor.why, 'not_found', 'not_found')
check(texted('◆＝現在地'), 'fallback when not found')
FAKE.printed = {}
cmd('/astertrail floor')
check(printed('MAP 不明') and printed('not_found'), 'command shows not_found')

-- 二つ以上見つかったら使わない
reset_floor(); G.mode = 'twice'; G.calls = {}
frames(1.2)
eq(#G.calls, 0, 'no call when ambiguous')
eq(P._floor.why, 'ambiguous', 'ambiguous')

-- 1枚だけのエリアは呼ばない（コマンドでは確かめる）
reset_floor(); G.mode = 'ok'; G.calls = {}; G.ret = 0
app.close_window('map')
FAKE.player.zone = 230
frames(3)
app.open_map(nil, nil, { zone_id = 230, zone_name = '南サンドリア' })
frames(2)
eq(#G.calls, 0, 'single-map zone not checked')
cmd('/astertrail floor')
eq(#G.calls, 1, 'command checks anyway')
app.close_window('map'); frame()

-- VanaCore の vana.memory を先に使う（詰めた書き方で無ければ、空白入りでも探す）
reset_floor(); G.calls = {}
local vfinds = {}
_G.vana = {
    memory = {
        find = function (module, size, pattern, offset, nth)
            vfinds[#vfinds + 1] = pattern
            if (nth or 0) ~= 0 then return 0 end
            local p = pattern:gsub(' ', '')
            if not pattern:find(' ', 1, true) then return 0 end
            if p == FUNC_SIG then return FUNC_AT + (offset or 0) end
            if p == OWNER_SIG then return OWNER_AT + (offset or 0) end
            return 0
        end,
        read_uint32 = ashita.memory.read_uint32,
        module = function () return BASE, SIZE end,
    },
    game = { zoning = function () return G.zoning or false end },
}
FAKE.player.zone = 238
local fid = P.current_floor_id()
eq(fid, 0, 'vana.memory path works')
eq(P.floor_status().source, 'vana.memory', 'vana.memory preferred')
check(vfinds[2] and vfinds[2]:find(' ', 1, true), 'spaced pattern tried')
G.zoning = true
local zf, zwhy = P.current_floor_id()
eq(zf, nil, 'no floor while zoning'); eq(zwhy, 'zoning', 'zoning reason')
G.zoning = false

-- 管理役の場所がゲームの外を指していたら使わない
reset_floor()
local saved_read = ashita.memory.read_uint32
_G.vana.memory.read_uint32 = function (addr) if addr == OWNER_AT + 0x0E then return 0x7FFF0000 end return saved_read(addr) end
ashita.memory.read_uint32 = _G.vana.memory.read_uint32
local bf, bwhy = P.current_floor_id()
eq(bf, nil, 'bad owner slot'); eq(bwhy, 'bad_owner_slot', 'bad_owner_slot reason')
ashita.memory.read_uint32 = saved_read
_G.vana = nil

---------------------------------------------------------------------------
-- 窓ごとの文字サイズ（窓の大きさは変えない）
---------------------------------------------------------------------------
local imgui = require('imgui')
local window = require('src.ui.window')
local S = app._settings()
S.fonts.book, S.fonts.detail, S.fonts.tracker, S.fonts.map = 1.5, 1.2, 0.8, 1.7
S.fonts.overhead_quest, S.fonts.overhead_name = 1.1, 1.3
S.font_scale = 0.9
local ui = { settings = S }
eq(window.font_scale(ui, 'book'), 1.5, 'book font')
eq(window.font_scale(ui, 'detail'), 1.2, 'detail font')
eq(window.font_scale(ui, 'tracker'), 0.8, 'tracker font')
eq(window.font_scale(ui, 'map'), 1.7, 'map font')
eq(window.font_scale(ui, 'settings'), 0.9, 'settings uses other')
eq(window.font_scale(ui, 'items'), 0.9, 'items uses other')

local scales = {}
local saved_sfs = rawget(imgui, 'SetWindowFontScale')
imgui.SetWindowFontScale = function (v) scales[#scales + 1] = v end
local saved_size = rawget(imgui, 'SetNextWindowSize')
local sizes = 0
imgui.SetNextWindowSize = function () sizes = sizes + 1 end
app.open_window('book'); frame(); frame()
local function has(v) for _, s in ipairs(scales) do if math.abs(s - v) < 1e-6 then return true end end return false end
check(has(1.5), 'book window scale')
check(has(1.2), 'book right detail uses detail size exactly')
check(not has(1.2 / 1.5), 'no ratio any more')
local w_before = S.windows.book.w
sizes = 0
S.fonts.book = 1.0; scales = {}
frame(); frame()
eq(sizes, 0, 'font change does not resize windows')
eq(S.windows.book.w, w_before, 'saved book width unchanged')
check(has(1.0), 'new book scale applied')
app.close_window('book')
cmd('/astertrail settings'); frame(); frame()
check(labeled('本の見出しの文字サイズ') or texted('本の見出しの文字サイズ'), 'book font setting')
for _, lab in ipairs({ '詳細の文字サイズ', 'トラッカーの文字サイズ', '地図の文字サイズ', 'アイコンのクエスト名の文字サイズ', 'アイコンの名前の文字サイズ', 'その他（設定・お知らせ・入口）',
    }) do
    check(texted(lab), 'setting ' .. lab)
end
-- アイコンのタブ
require('src.ui.settings_ui').select_tab('marks'); frame(); frame()
for _, lab in ipairs({ 'アイコンの位置（左右）', 'アイコンの位置（上下）', 'クエスト名の位置（左右）', 'クエスト名の位置（上下）' }) do
    check(texted(lab), 'setting ' .. lab)
end
for _, lab in ipairs({ 'アイコンを表示する', 'クエスト名を表示する', 'クエストの対象名を表示する', '近くのオブジェクト名を表示する' }) do
    check(labeled(lab), 'setting ' .. lab)
end
-- 古い名前は出さない（0.1.58・0.1.59 で変えたもの）
for _, lab in ipairs({ 'アイコンと名前の位置', 'アイコンのクエスト名を出す', 'オブジェクトにアイコンを出す',
    'アイコンを出す', 'クエスト名を出す', 'オブジェクト名等を表示する', '近くのオブジェクトの名前を出す' }) do
    check(not labeled(lab) and not texted(lab), 'old label gone ' .. lab)
end
require('src.ui.settings_ui').select_tab('look'); frame(); frame()
check(has(0.9), 'settings window uses other size')
-- ＋で本だけが変わる
local other_before, map_before = S.font_scale, S.fonts.map
do
    -- スライダーを動かした（1.13 → 0.1 刻みで 1.1）
    local saved_slider = rawget(imgui, 'SliderFloat')
    imgui.SliderFloat = function (label, buf, lo, hi, fmt)
        if label == '##font_book' then buf[1] = 1.13; return true end
        return false
    end
    frame()
    imgui.SliderFloat = saved_slider
end
frame(); frame()
imgui.SetWindowFontScale = saved_sfs
imgui.SetNextWindowSize = saved_size
-- 頭上の文字は overhead を使う（アイコンの大きさとは別）
eq(S.fonts.book, 1.1, 'book + pressed')
eq(S.font_scale, other_before, 'other unchanged by book +')
eq(S.fonts.map, map_before, 'map unchanged by book +')
eq(require('src.core.settings').font_for(S, 'overhead_quest'), 1.1, 'overhead quest own size')
eq(require('src.core.settings').font_for(S, 'overhead_name'), 1.3, 'overhead name own size')
eq(S.marks.icon_size, 28, 'icon size independent')


-- 0.1.31 の「頭上の文字」は、頭上のクエスト名と頭上の名前の両方へ
do
    local m = settings.merge({ settings_schema = 1, font_scale = 1.0, fonts = { book = 1.2, overhead = 1.4 } })
    eq(m.fonts.overhead_quest, 1.4, 'old overhead -> quest name')
    eq(m.fonts.overhead_name, 1.4, 'old overhead -> name')
    eq(m.fonts.overhead, nil, 'old key dropped')
    eq(settings.font_for({ font_scale = 1, fonts = { overhead = 1.2 } }, 'overhead_name'), 1.2, 'font_for old overhead')
    -- 位置の調整：初めは 0、範囲 -64〜64
    local d = settings.merge(nil)
    for _, k in ipairs(settings.OFFSET_KEYS) do eq(d.marks[k], 0, 'offset default ' .. k) end
    local o = settings.merge({ settings_schema = 1, marks = { mark_dx = 900, mark_dy = -900, label_dx = 'x', label_dy = 6 } })
    eq(o.marks.mark_dx, 256, 'clamp +'); eq(o.marks.mark_dy, -256, 'clamp -')
    local o2 = settings.merge({ settings_schema = 1, marks = { mark_dx = 100, label_dy = -120 } })
    eq(o2.marks.mark_dx, 100, '100 allowed'); eq(o2.marks.label_dy, -120, '-120 allowed')
    eq(o.marks.label_dx, 0, 'bad -> 0'); eq(o.marks.label_dy, 6, 'kept')
end

-- 子の窓の文字：親の倍率を受け継ぐ ImGui でも、ちょうどの大きさになる
do
    local W2 = require('src.ui.window')
    local cur, parent = 1, 1.5
    local fake = {
        SetWindowFontScale = function (v) cur = v end,
        GetFontSize = function () return 13 * cur * parent end,   -- 受け継ぐ版
    }
    local ui2 = { imgui = fake, _font_base = 13 }
    W2.set_font(ui2, 1.2)
    check(math.abs(13 * cur * parent - 13 * 1.2) < 1e-9, 'compounding imgui gets exact size')
    fake.GetFontSize = function () return 13 * cur end            -- 受け継がない版
    W2.set_font(ui2, 1.2)
    check(math.abs(cur - 1.2) < 1e-9, 'non-compounding imgui gets exact size')
    fake.GetFontSize = nil
    W2.set_font(ui2, 0.9)
    eq(cur, 0.9, 'without GetFontSize pass through')
end

-- 画面の日本語に「頭上」は出さない
do
    local raw = io.open(ROOT .. '/locales/ja.json', 'rb'):read('*a')
    check(not raw:find('頭上', 1, true), 'no 頭上 in ja strings')
end

-- 設定のスライダー：↺（初期値に戻す）、左右キー、刻みへの丸め、値と単位
do
    local W = require('src.ui.widgets')
    eq(W.snap(1.13, 0.1, 0.7, 2.0), 1.1, 'snap 0.1')
    eq(W.snap(27, 4, 16, 64), 28, 'snap icon to 4 from 16')
    eq(W.snap(3, 2, -128, 128), 4, 'snap offset 2')
    eq(W.snap(500, 2, -256, 256), 256, 'snap clamp')
    local S = app._settings()
    S.fonts.book = 1.0; S.marks.mark_dx = 0; S.marks.icon_size = 28
    app.open_window('settings'); frame(); frame()
    check(texted('100%'), 'percent shown')
    require('src.ui.settings_ui').select_tab('marks'); frame(); frame()
    check(texted('28') and texted('px'), 'icon px shown (number and unit drawn apart)')
    check(texted('0'), 'offset px shown')
    require('src.ui.settings_ui').select_tab('look'); frame(); frame()
    check(labeled('##font_book_plus') and labeled('##font_book_minus'), 'plus/minus step buttons')
    check(labeled('##font_book_reset'), 'reset button')
    -- 初期値のときの ↺ は効かない
    FAKE.clicks['##font_book_reset'] = true; frame()
    eq(S.fonts.book, 1.0, 'reset no-op at default')
    S.fonts.book = 1.5; frame()
    check(texted('150%'), '150%')
    FAKE.clicks['##font_book_reset'] = true; frame(); frame()
    eq(S.fonts.book, 1.0, 'reset to default')
    -- キー：スライダーを選んで右で1刻み、選択は動かない
    local focus = require('src.ui.focus')
    require('src.ui.settings_ui').select_tab('marks'); frame(); frame()
    focus.set('settings', 'marks_mark_dx', false)
    app.activate('settings')
    app.input('right', true, 'key'); app.input('right', false, 'key'); frame(); frame()
    eq(S.marks.mark_dx, 2, 'right adds one step')
    eq(focus.current('settings'), 'marks_mark_dx', 'focus stays on slider')
    check(texted('+2') and texted('px'), 'signed px')
    for _ = 1, 200 do app.input('right', true, 'key'); app.input('right', false, 'key'); frame() end
    eq(S.marks.mark_dx, 256, 'up to 256')
    app.input('left', true, 'key'); app.input('left', false, 'key'); frame()
    eq(S.marks.mark_dx, 254, 'left one step')
    -- 押し続け：スライダーは2倍の速さ（同じ時間で、ほかの項目の約2倍くり返す）
    S.marks.mark_dx = 0
    focus.set('settings', 'marks_mark_dx', false)
    app.input('right', true, 'key')
    for _ = 1, 100 do frame(0.01) end   -- 1秒
    app.input('right', false, 'key'); frame()
    local fast = S.marks.mark_dx / 2
    check(app.slider_held('right'), 'slider is held target')
    check(fast >= 8, 'fast repeat on slider: ' .. tostring(fast))
    check(app.slider_held('up') == false, 'up/down not sped up')
    -- ↺ を選んで決定
    focus.set('settings', 'marks_mark_dx_reset', false)
    app.input('confirm', true, 'key'); app.input('confirm', false, 'key'); frame(); frame()
    eq(S.marks.mark_dx, 0, 'reset by confirm')
    -- 位置を元に戻すボタンも残る
    S.marks.label_dy = 10
    FAKE.clicks['位置を元に戻す'] = true; frame(); frame()
    eq(S.marks.label_dy, 0, 'reset positions button')
    app.close_window('settings')
end
