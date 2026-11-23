-- 0.1.275：SF の地図窓と独立エミネンス窓。マス目は地図ごとの換算（A–P / 1–16 を固定しない）
require('fake_env')
local imgui = package.loaded['imgui'] or require('imgui')

local app = require('src.app')
eq(app.VERSION, '1.1.324', 'version')

local maps = require('src.core.maps')
local theme = require('src.ui.theme')
local settings_mod = require('src.core.settings')

-- 換算：共通の 512 / 余白 16 / マス 32 では、画像内に完全に収まるマスは 15×15（A–O、1–15）
local g = maps.grid_layout(nil, {})
eq(g.col_count, 15, 'default columns are computed, not hardcoded 16')
eq(g.row_count, 15, 'default rows are computed, not hardcoded 16')
eq(g.letters, 'ABCDEFGHIJKLMNO', 'letters stop at O when P does not fit inside the image')
eq(g.rows[1], 1, 'first row is 1')
eq(g.rows[#g.rows], 15, 'last full row is 15')
-- 資料に列数があればそれを使う
local g16 = maps.grid_layout({ grid_cols = 16, grid_rows = 16 }, {})
eq(g16.col_count, 16, 'explicit grid_cols is honored')
eq(g16.letters, 'ABCDEFGHIJKLMNOP', 'explicit 16 includes P')

-- maps.json に列数・行数の個別項目は無く、525 件とも同じ換算
local raw, n, differ, have_override = nil, 0, 0, 0
do
    local f = io.open(ROOT .. '/data/maps.json', 'r')
    raw = f:read('*a'); f:close()
end
local json = require('src.lib.json')
local doc = json.decode(raw)
for _, fl in ipairs(doc.floors or {}) do
    n = n + 1
    if fl.grid_cols or fl.grid_rows or fl.cols or fl.rows or fl.grid_cell or fl.grid_margin then
        have_override = have_override + 1
    end
    local lg = maps.grid_layout(fl, {})
    if lg.col_count ~= 16 or lg.row_count ~= 16 then differ = differ + 1 end
end
eq(n, 529, 'all floors in maps.json (0.1.324: Heaven Tower 4 pages)')
eq(have_override, 0, 'no per-map column/row/cell overrides in maps.json')
eq(differ, 529, 'all floors compute 15x15 from BASE/MARGIN/CELL (P and 16 fall in the margin)')

local mv = io.open(ROOT .. '/src/ui/map_view.lua', 'r'):read('*a')
check(mv:find("require('src.ui.map_sf')", 1, true) ~= nil, 'map_view hooks map_sf in SF')
local ev = io.open(ROOT .. '/src/ui/eminence.lua', 'r'):read('*a')
check(ev:find("require('src.ui.eminence_win_sf')", 1, true) ~= nil, 'eminence window hooks SF drawer')
-- 本のタブは別ファイルのまま
check(io.open(ROOT .. '/src/ui/eminence_sf.lua', 'r'):read('*a'):find('book_body', 1, true) ~= nil, 'book Eminence tab unchanged file')

local ms = io.open(ROOT .. '/src/ui/map_sf.lua', 'r'):read('*a')
check(ms:find('grid_layout', 1, true) ~= nil, 'SF map uses grid_layout')
check(ms:find('draw_grid_and_scales', 1, true) ~= nil, 'outer scales and overlay lines')
check(ms:find('ZOOM +', 1, true) ~= nil and (ms:find('ZOOM −', 1, true) or ms:find('zoom_out', 1, true)), 'ZOOM buttons')
check(ms:find("maps.floor_label(t, f)", 1, true) ~= nil, 'floor tabs keep MAP n labels (0.1.324: maps.floor_label, MAP n + name for Heaven\'s Tower)')
check(ms:find("t('map.targets')", 1, true) ~= nil, 'targets pane')
check(ms:find("t('map.legend')", 1, true) ~= nil, 'legend pane')
check(ms:find('focus_grid', 1, true) ~= nil, 'clicking a target highlights the pin/cell')
check(ms:find('map.back', 1, true) ~= nil and ms:find('map.here', 1, true) ~= nil, 'back and here in the bottom bar')

local ew = io.open(ROOT .. '/src/ui/eminence_win_sf.lua', 'r'):read('*a')
check(ew:find("'EMINENCE'", 1, true) ~= nil, 'Melete EMINENCE heading')
check(ew:find('sf.bar', 1, true) ~= nil, 'progress bar')
check(ew:find('progress_text', 1, true) ~= nil, '3/10 text')
check(ew:find('★', 1, true) ~= nil and (ew:find('❤', 1, true) ~= nil or ew:find('♥', 1, true) ~= nil), 'star and heart')
check(ew:find('SetTooltip', 1, true) ~= nil, 'hover description kept')
check(not ew:find('roe.accept', 1, true) and not ew:find('roe.remove', 1, true), 'no accept/remove buttons')
check(not ew:find("open_window('book'", 1, true) and not ew:find('open_window("book"', 1, true), 'no row-click-to-open-book')

local def = settings_mod.defaults()
eq(def.map.grid_alpha, 0.35, 'default grid alpha')
local ss = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a')
check(ss:find("map_grid", 1, true) ~= nil, 'SF MAP settings has grid slider')
local su = io.open(ROOT .. '/src/ui/settings_ui.lua', 'r'):read('*a')
check(su:find("map_grid", 1, true) ~= nil, 'classic settings also expose the same key')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)

local function labeled(s)
    for _, l in ipairs(FAKE.labels) do if tostring(l):find(s, 1, true) then return true end end
    return false
end
local function seen(s)
    if labeled(s) then return true end
    for _, l in ipairs(FAKE.texts) do if tostring(l):find(s, 1, true) then return true end end
    return false
end

local S = app._settings()
eq(S.map.grid_alpha, 0.35, 'loaded settings get grid_alpha')
-- クラシックの設定にスライダーは出る（地図の見た目は変えない）
S.look = 'classic'
theme.set_look('classic')
app.open_window('settings'); frame(); frame(); frame()
require('src.ui.settings_ui').select_tab('map'); frame(); frame()
check(labeled('マス目の線の濃さ') or seen('マス目の線の濃さ'), 'classic settings shows grid alpha')
app.close_all(); frame()

S.look = 'sf'
theme.set_look('sf')
app.open_window('settings'); frame(); frame(); frame()
require('src.ui.settings_ui').select_tab('map'); frame(); frame(); frame()
check(labeled('マス目の線の濃さ') or seen('マス目の線の濃さ'), 'SF MAP panel shows grid alpha')
check(labeled('地図を出す') or seen('地図を出す'), 'map enabled toggle remains')

-- エミネンス窓（SF）：見出しとピン留めは出る。受注ボタンは出ない
S.eminence.visible = true
frame(); frame(); frame()
local joined = table.concat(FAKE.texts or {}) .. table.concat(FAKE.labels or {})
check(joined:find('EMINENCE', 1, true) or seen('エミネンス'), 'eminence window heading is drawn')
check(labeled('ピン留め') or seen('ピン留め'), 'pin-only control remains')

app.close_all(); frame()
S.look = 'classic'
theme.set_look('classic')
print('test_sf_275 ok')
