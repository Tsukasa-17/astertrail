-- 0.1.302：近くのオブジェクト名の距離（設定、5〜50 ヤルム・初期 30）／ログイン時の続きのアストラル版と「テスト」ボタン
require('fake_env')
local imgui = package.loaded['imgui'] or require('imgui')
local smod = require('src.core.settings')
local marks = require('src.core.marks')

-- 設定：初期 30、5〜50 に収める
eq(smod.defaults().marks.nearby_radius, 30, 'default 30 yalms')
eq(smod.NEARBY_RADIUS_MAX, 50, 'max is the game load range (50)')
local m1 = smod.merge({ marks = { nearby_radius = 99 } })
eq(m1.marks.nearby_radius, 50, 'clamped to 50')
local m2 = smod.merge({ marks = { nearby_radius = 2 } })
eq(m2.marks.nearby_radius, 5, 'clamped to 5')
local m3 = smod.merge({ marks = { nearby_radius = 'x' } })
eq(m3.marks.nearby_radius, 30, 'bad value: 30')
eq(smod.nearby_radius({ nearby_radius = 42.4 }), 42, 'rounded')

-- 選ぶ：距離の中だけ
local ents = {
    { index = 10, name = '???', x = 25, y = 0 },
    { index = 11, name = '???', x = 40, y = 0 },
    { index = 12, name = '???', x = 55, y = 0 },
}
local function idx(list) local o = {} for _, n in ipairs(list) do o[#o + 1] = n.entity.index end return table.concat(o, ',') end
eq(idx(marks.nearby_objects(ents, { px = 0, py = 0 })), '10', 'default radius 30')
eq(idx(marks.nearby_objects(ents, { px = 0, py = 0, radius = 45 })), '10,11', 'radius 45')
eq(idx(marks.nearby_objects(ents, { px = 0, py = 0, radius = 50 })), '10,11', 'radius 50 (55 is out)')

-- 頭上の印：設定の距離を使う
do
    local f = io.open(ROOT .. '/src/ui/marks.lua', 'r'); local src = f:read('*a'); f:close()
    check(src:find('radius = tonumber(SM.nearby_radius)', 1, true) ~= nil, 'marks pass the setting radius')
end

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
eq(app.VERSION, '1.1.318', 'version')
FAKE.player = { name = 'Rb302', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local theme = require('src.ui.theme')
local W = require('src.ui.widgets')
local settings_ui = require('src.ui.settings_ui')

-- アストラルの設定：近くのオブジェクト名がオンのときだけ距離の行、i の説明は今の距離
imgui.GetContentRegionAvail = function () return 900, 520 end
imgui.GetWindowSize = function () return 920, 560 end
S.look = 'sf'; theme.set_look('sf')
app.open_window('book'); app.open_window('settings')
settings_ui.select_tab('marks')
local sliders = {}
local keep_slider = W.slider
W.slider = function (u, win, id, ...) sliders[id] = true; return keep_slider(u, win, id, ...) end
local tips = {}
local keep_tip = W.tooltip
W.tooltip = function (u, s) tips[#tips + 1] = s; return keep_tip(u, s) end
S.marks.show_nearby_names = false
frame(); frame()
check(not sliders.marks_nearby_radius, 'no distance row while nearby names are off')
S.marks.show_nearby_names = true
S.marks.nearby_radius = 42
frame(); frame()
check(sliders.marks_nearby_radius, 'distance row while nearby names are on')
local focus = require('src.ui.focus')
tips = {}
focus.set('settings', 'marks_nearby', false, 'nav'); frame()
local hit = false
for _, s in ipairs(tips) do if s:find('42 ヤルム', 1, true) then hit = true end end
check(hit, 'nearby help says the chosen distance (42)')
tips = {}
focus.set('settings', 'marks_nearby_radius', false, 'nav'); frame()
hit = false
for _, s in ipairs(tips) do if s:find('42 ヤルム', 1, true) and s:find('50 ヤルム', 1, true) then hit = true end end
check(hit, 'distance row tooltip: current and max')
W.slider = keep_slider
W.tooltip = keep_tip

-- 0.1.303：ログイン時の続きはなくした（窓・アストラル版・LOGIN の設定・テストボタン・訳）
local function src_of(f) local h = io.open(ROOT .. '/' .. f, 'r'); local x = h:read('*a'); h:close(); return x end
check(app.resume_preview == nil, 'no resume preview')
eq(app.state.resume, nil, 'no resume state')
check(not src_of('src/ui/notices.lua'):find('draw_resume', 1, true), 'classic resume window removed')
check(not src_of('src/ui/notices_sf.lua'):find('draw_resume', 1, true), 'astral resume window removed')
check(not src_of('src/app.lua'):find('show_resume', 1, true), 'show_resume removed')
check(not src_of('src/ui/settings_sf.lua'):find("'nt_login'", 1, true), 'LOGIN box removed')
check(not src_of('src/ui/settings_ui.lua'):find("'n_login'", 1, true), 'classic login rows removed')
local json = require('src.lib.json')
for _, lang in ipairs({ 'ja', 'en' }) do
    local d = json.decode(src_of('locales/' .. lang .. '.json'))
    for k in pairs(d) do
        check(not k:find('^resume%.') and not k:find('login_resume', 1, true) and not k:find('resume_try', 1, true),
            lang .. ': no resume key ' .. k)
    end
end
settings_ui.select_tab('notify'); FAKE.labels = {}; FAKE.texts = {}; frame(); frame()
check(not labeled('ログイン時の続き') and not texted('ログイン時の続き'), 'no login resume row in NOTIFY')
check(not labeled('続きの表示秒数'), 'no seconds row')
-- ログインしても何も出ない
FAKE.texts = {}
app.close_window('book')
frames(1)
check(not texted('前回の続き'), 'no resume window')
