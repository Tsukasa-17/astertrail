-- 0.1.285：アストラル移行の混在、コンパス枠、独立詳細の重なり、本の Esc
require('fake_env')

local json = require('src.lib.json')
local theme = require('src.ui.theme')

local CLASSIC_BG = 0.075
local SF_BG = 0.035
local YUNA_BG = 0.068

local function nearly(a, b)
    return type(a) == 'number' and type(b) == 'number' and math.abs(a - b) < 0.0005
end

local function has_sf_keys()
    return theme.palette.sf_cyan ~= nil and theme.palette.sf_amber ~= nil
end

local function bg1()
    return theme.palette and theme.palette.bg and theme.palette.bg[1]
end

local function look_matches(name)
    if theme.look ~= name then return false, 'look' end
    if name == 'sf' then
        if not has_sf_keys() then return false, 'sf keys' end
        if not nearly(bg1(), SF_BG) then return false, 'sf bg' end
        if not theme.is_sf() then return false, 'is_sf' end
    else
        if has_sf_keys() then return false, 'sf keys leaked' end
        if theme.is_sf() then return false, 'is_sf' end
        if name == 'classic' and not nearly(bg1(), CLASSIC_BG) then return false, 'classic bg' end
        if name == 'yunaui' and not nearly(bg1(), YUNA_BG) then return false, 'yunaui bg' end
    end
    return true
end

-- 読み込み時点で、初期の見た目（アストラル）とパレットが揃っている
eq(theme.look, 'sf', 'module default look is アストラル')
check(look_matches('sf'), 'module load already applies the アストラル palette')

local src = io.open(ROOT .. '/src/ui/theme.lua', 'r'):read('*a')
check(not src:find('if theme.look == name then return end', 1, true),
    'set_look no longer skips a same-name apply')
check(src:find('theme.set_look(theme.look)', 1, true) ~= nil,
    'module load calls set_look so the default palette is applied')

-- 0.1.284 の再現：look はすでに sf、パレットだけクラシック
theme.set_look('classic')
check(look_matches('classic'), 'can switch to classic')
theme.look = 'sf'
check(not has_sf_keys(), 'desynced: classic palette under sf look (0.1.284 shape)')
eq(theme.is_sf(), true, 'desynced: is_sf follows the look flag')
theme.set_look('sf')
check(look_matches('sf'), 'set_look(sf) still applies the palette when look was already sf')

-- 実行中の切り替え（両方向）で混在しない
for _, name in ipairs({ 'classic', 'sf', 'yunaui', 'classic', 'sf', 'yunaui', 'sf' }) do
    theme.set_look(name)
    check(look_matches(name), 'palette matches after switch to ' .. name)
end

-- ログイン時の初回移行：描画の前にパレットもアストラルへ揃える
local dir = TMP .. '/Vanacore/config/addons/astertrail/catseye_MixUser/'
os.execute('mkdir -p "' .. dir .. '"')
local wf = io.open(dir .. 'settings.json', 'wb')
wf:write(json.encode({ look = 'classic', language = 'ja' }))
wf:close()

local app = require('src.app')
eq(app.VERSION, '1.1.327', 'version')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'MixUser', zone = 230, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
FAKE.keep_default_look = true
frames(1)
check(app.state.ready, 'logged in')
local S = app._settings()
eq(S.look, 'sf', 'classic without flag migrates to アストラル')
eq(S.theme_astral_migrated, true, 'migration flag is set')
eq(theme.look, 'sf', 'theme.look follows the migrated setting')
check(look_matches('sf'), 'migration applies the full アストラル palette, not a mixed classic background')

-- 実行中にクラシック ↔ アストラルを切り替え、描画したあとも混在しない
app.open_window('book')
app.open_window('settings')
frames(1)
S.look = 'classic'
theme.set_look(S.look)
frames(2)
eq(S.look, 'classic', 'settings stay classic')
check(look_matches('classic'), 'runtime switch to classic is complete')
S.look = 'sf'
theme.set_look(S.look)
frames(2)
eq(S.look, 'sf', 'settings stay アストラル')
check(look_matches('sf'), 'runtime switch back to アストラル is complete')
S.look = theme.next_look(S.look)  -- sf -> classic
theme.set_look(S.look)
frames(1)
check(look_matches('classic'), 'next_look to classic stays consistent')
S.look = theme.next_look(S.look)  -- classic -> yunaui
theme.set_look(S.look)
frames(1)
check(look_matches('yunaui'), 'next_look to yunaui stays consistent')
S.look = theme.next_look(S.look)  -- yunaui -> sf
theme.set_look(S.look)
frames(1)
check(look_matches('sf'), 'next_look back to アストラル stays consistent')

-- ログイン処理が、窓の再配置より前に set_look する
local app_src = io.open(ROOT .. '/src/app.lua', 'r'):read('*a')
local merge_at = app_src:find('S = merged', 1, true)
local look_at = app_src:find('theme.set_look(S.look)', merge_at, true)
local reapply_at = app_src:find('window.reapply()', merge_at, true)
check(look_at ~= nil and reapply_at ~= nil and look_at < reapply_at,
    'on_login applies the look before window.reapply')

-- アストラルのコンパス：枠は中身（クエスト名と依頼者・距離）を余白つきで収め、線は文字を横切らない
local csf = io.open(ROOT .. '/src/ui/compass_sf.lua', 'r'):read('*a')
check(not csf:find('y0 + 52', 1, true), 'card frame is not a fixed 52px')
check(csf:find('row_h[key]', 1, true) ~= nil, 'card height is remembered per quest')
check(csf:find('content_bottom', 1, true) ~= nil, 'card height follows the content')
check(csf:find('bump_bottom', 1, true) ~= nil, 'both the name row and the NPC/distance row are measured')
check(csf:find('GetFontSize', 1, true) ~= nil, 'padding and minimum height follow the font size')
check(csf:find('sf.fill_cut', 1, true) ~= nil, 'fill is drawn without a stroke so a short guess cannot cut text')
check(csf:find('local min_h', 1, true) ~= nil, 'minimum height covers both rows and padding')
-- 線の sf.frame は測ったあとに一度だけ
local i_name = csf:find("row = r.qid .. '_name'", 1, true)
local i_npc = csf:find("row = r.qid .. '_npc'", 1, true)
local i_fill = csf:find('sf.fill_cut', 1, true)
local i_frame = csf:find('sf.frame(dl,', 1, true)
check(i_fill and i_name and i_fill < i_name, 'fill is behind the quest name')
check(i_npc and i_frame and i_npc < i_frame, 'stroked frame is drawn after the NPC/distance row')
check(csf:find('y0 + h', i_frame, true) ~= nil, 'stroked frame uses the measured height')
check(csf:find('sf.set_cursor(imgui, x0, y0 + h)', 1, true) ~= nil, 'cursor advances to the bottom of the card so height grows')
-- クラシックのコンパスは触らない
local c_classic = io.open(ROOT .. '/src/ui/compass.lua', 'r'):read('*a')
check(not c_classic:find('row_h[key]', 1, true), 'classic compass is unchanged')
check(not c_classic:find('sf.fill_cut', 1, true), 'classic compass has no SF fill_cut')
check(c_classic:find("require('src.ui.compass_sf')", 1, true) ~= nil, 'classic file still hooks SF')

-- 独立した詳細：場所／相手はタイムラインの右へ。今の手順の枠は中身の高さ。下段は手順の下。
local bsf = io.open(ROOT .. '/src/ui/book_sf.lua', 'r'):read('*a')
check(bsf:find('function indent_extra', 1, true) ~= nil, 'standalone extras are indented to the step text column')
check(bsf:find('indent_extra()', 1, true) ~= nil, 'each extra row is indented')
check(bsf:find("t('detail.where'", 1, true) ~= nil, 'where row remains')
check(bsf:find("t('detail.target'", 1, true) ~= nil, 'target row remains')
check(bsf:find('step_card_h[card_key]', 1, true) ~= nil, 'current-step frame height is measured')
check(bsf:find('sf.fill_cut', 1, true) ~= nil, 'current-step fill is drawn without a short stroke')
local i_where = bsf:find("t('detail.where'", 1, true)
local i_frame2 = bsf:find('ay + card_h', 1, true)
check(i_where and i_frame2 and i_where < i_frame2, 'current-step stroke is after the extra rows')
check(bsf:find('flow_steps = standalone', 1, true) ~= nil or bsf:find('flow_steps = standalone == true', 1, true) ~= nil,
    'standalone detail flows steps then REWARD/LOCATION')
check(bsf:find('steps_fit[q.id]', 1, true) ~= nil, 'steps height is remembered')
-- 本の右ペインは standalone のときだけ足す行を出す、はそのまま
check(bsf:find('opts.standalone == true', 1, true) ~= nil, 'book pane stays unless standalone')

-- 本の Esc：右ペインにフォーカスがあっても、枠が点滅するだけで終わらず本を閉じる
local bnav = io.open(ROOT .. '/src/ui/book.lua', 'r'):read('*a')
local i_det = bnav:find("== 'detail' then", 1, true)
check(i_det ~= nil, 'nav_action still has a detail branch')
local det_back = bnav:sub(i_det, i_det + 400)
check(det_back:find('action == \'back\'', 1, true) ~= nil, 'detail branch handles back')
check(det_back:find('return false', 1, true) ~= nil, 'back from in-book detail does not consume Esc')
check(not det_back:find('focus_nav(wid)', 1, true), 'back from detail no longer only moves focus')

-- 実行：操作中・詳細フォーカスでも Esc 1回で本が閉じる
FAKE.keep_default_look = true
theme.set_look('sf')
S.look = 'sf'
app.open_window('book')
app.activate('book')
frames(2)
check(app.state.open.book, 'book is open')
local book = require('src.ui.book')
local focus = require('src.ui.focus')
if book.DETAIL_ANCHOR then focus.set('book', book.DETAIL_ANCHOR, true) end
frames(1)
eq(app.state.active, 'book', 'book is operating')
eq(app.esc_target() or (app.state.active == 'book' and 'book'), 'book', 'esc target can be the book')
local function press_esc()
    local e = { key = 0x01, down = true, blocked = false }
    local r = FAKE.events.key_data(e)
    FAKE.events.key_data({ key = 0x01, down = false, blocked = false })
    return r, e.blocked
end
press_esc()
frames(1)
check(not app.state.open.book, 'Esc closes the book even when focus is in the in-book detail pane')

-- 乗っているだけの本も閉じる（0.1.282）
app.open_window('book')
app.release()
frames(1)
app.state.win_hover = { book = true }
app.state.win_focus = {}
check(app.want_esc(), 'hovered book wants Esc')
eq(app.esc_target(), 'book', 'hovered target is book')
press_esc()
frames(1)
check(not app.state.open.book, 'hovered book still closes with Esc')

-- 各窓：乗っていれば Esc の対象になる。トラッカーは HUD なので対象にしない
app.open_window('map')
app.release()
app.state.win_hover = { map = true }
eq(app.esc_target(), 'map', 'map is an Esc target')
app.close_window('map')

app.open_window('settings')
app.release()
app.state.win_hover = { settings = true, book = true }
eq(app.esc_target(), 'settings', 'settings is above book')
app.close_window('settings')
app.close_window('book')

S.eminence = S.eminence or {}
S.eminence.visible = true
app.state.win_hover = { eminence = true }
eq(app.esc_target(), 'eminence', 'eminence is an Esc target')
app.close_window('eminence')
eq(S.eminence.visible, false, 'Esc path hides eminence via close_window')

S.compass = S.compass or {}
S.compass.visible = true
app.state.win_hover = { compass = true }
eq(app.esc_target(), 'compass', 'compass is an Esc target')
app.close_window('compass')
eq(S.compass.visible, false, 'Esc path hides compass via close_window')

S.tracker = S.tracker or {}
S.tracker.visible = true
app.state.win_hover = { tracker = true }
eq(app.esc_target(), nil, 'tracker is not closed by Esc')
