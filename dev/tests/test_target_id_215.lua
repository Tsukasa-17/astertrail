-- 0.1.215：座標コマンドに ID・番号・「出ている」合図を足す。頭上の文字の背景の濃さ
require('fake_env')
local settings = require('src.core.settings')
local ext = require('src.platform.vanacore_ext')
local plat = require('src.platform.ashita')

-- 「出ている」合図（render の 0x200）
eq(plat._render_shown(0x200), true, 'player-like 0x200 is shown')
eq(plat._render_shown(0x500200), true, '??? 0x500200 is shown')
eq(plat._render_shown(0), false, '0 is hidden')
eq(plat._render_shown(0x100), false, 'other bits only: hidden')
eq(plat._render_shown(nil), nil, 'unreadable is nil')
eq(plat._render_shown('nope'), nil, 'bad value is nil')

-- 背景の濃さ：初期は今までの見た目（#000000CC = 80%）
eq(settings.defaults().marks.label_bg_alpha, 0.8, 'quest name default 80%')
eq(settings.defaults().marks.under_bg_alpha, 0.8, 'object name default 80%')
eq(settings.label_bg_alpha({}, 'label'), 0.8, 'missing key keeps current look')
eq(settings.label_bg_alpha({ under_bg_alpha = 0.45 }, 'under'), 0.45, 'own value')
eq(settings.merge({ marks = {} }).marks.label_bg_alpha, 0.8, 'old save: 80%')
eq(settings.merge({ marks = { label_bg_alpha = 0.35, under_bg_alpha = 0 } }).marks.under_bg_alpha, 0, '0 allowed')
eq(settings.merge({ marks = { label_bg_alpha = 5 } }).marks.label_bg_alpha, 1.0, 'clamped high')
eq(settings.merge({ marks = { under_bg_alpha = -1 } }).marks.under_bg_alpha, 0, 'clamped low')
eq(ext._bg_hex(0.8), '#000000CC', 'default hex matches previous look')
eq(ext._bg_hex(0), '#00000000', '0 is transparent')
eq(ext._bg_hex(1), '#000000FF', '1 is opaque')
local p0 = ext._label_props({ codes = false }, 'ab', { 10, 20, 30 }, nil)
eq(p0.background, nil, 'props without alpha leave background unset')
local p1 = ext._label_props({ codes = false }, 'ab', { 10, 20, 30 }, nil, 0.5)
eq(p1.background, '#00000080', 'props include background when set')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(app.VERSION, '1.1.226', 'version 1.1.226')
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')

local function last_lines()
    return table.concat(FAKE.printed, '\n')
end

-- ターゲットあり：既存の座標行はそのまま、次の1行に ID など
local saved_tgt, saved_ent = plat.current_target, plat.game_entity
plat.current_target = function ()
    return { name = '???', x = 1.25, y = 2.5, z = -0.5, index = 12, id = 17559912, render_flags = 0x500200 }
end
plat.game_entity = function (i)
    if i == 12 then return { id = 17559912, render_flags = 0x500200, name = '???' } end
end
FAKE.printed = {}
check(app.command('/astertrail target'), 'target command')
check(printed('ターゲット: ???'), 'keeps the coordinate line')
check(printed('座標: x=1.25 y=2.50 z=-0.50'), 'coords kept')
check(printed('ID: 17559912  番号: 12  出ている: はい  印: 0x500200'), 'new id line')

-- /ast pos でも同じ
FAKE.printed = {}
check(app.command('/ast pos'), 'pos alias')
check(printed('ID: 17559912  番号: 12  出ている: はい  印: 0x500200'), 'pos alias prints the id line')

-- 出ていない相手
plat.game_entity = function (i)
    if i == 12 then return { id = 17559912, render_flags = 0x100000, name = '???' } end
end
FAKE.printed = {}
app.command('/astertrail target')
check(printed('出ている: いいえ'), 'hidden target')
check(printed('印: 0x100000'), 'raw flags when hidden')

-- 読めない値は ?
plat.current_target = function ()
    return { name = '???', x = 0, y = 0, z = 0 }
end
plat.game_entity = function () return nil end
FAKE.printed = {}
app.command('/astertrail target')
check(printed('ID: ?  番号: ?  出ている: ?  印: ?'), 'unreadable values are ?')

-- ターゲットがいないときは自分
plat.current_target = function () return nil end
plat.game_entity = function (i)
    if i == 5 then return { id = 12345, render_flags = 0x200, name = 'Tester' } end
end
FAKE.printed = {}
app.command('/astertrail target')
check(printed('ターゲット: Tester'), 'falls back to the player')
check(printed('ID: 12345  番号: 5  出ている: はい  印: 0x200'), 'player id line')
check(not printed('ターゲットがいません'), 'does not say no target when the player is readable')

plat.current_target, plat.game_entity = saved_tgt, saved_ent

-- 設定の「アイコン」に、色の設定のすぐ下にスライダー
local S = app._settings()
eq(S.marks.label_bg_alpha, 0.8, 'fresh settings: 80%')
eq(S.marks.under_bg_alpha, 0.8, 'fresh object: 80%')
local function seen(pat)
    for _, x in ipairs(FAKE.texts) do if x:find(pat, 1, true) then return true end end
    for _, x in ipairs(FAKE.labels) do if x:find(pat, 1, true) then return true end end
    return false
end
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('marks'); frame(); frame()
check(seen('クエスト名の背景の濃さ'), 'quest name opacity in アイコン')
check(seen('オブジェクト名の背景の濃さ'), 'object name opacity in アイコン')
check(seen('##marks_label_bg_alpha'), 'quest slider id')
check(seen('##marks_under_bg_alpha'), 'object slider id')
-- 色の設定のあとに出る
local order, ic, iq, iunder = 0, nil, nil, nil
for _, l in ipairs(FAKE.labels) do
    order = order + 1
    if not ic and l:find('##marks_label_color', 1, true) and not l:find('color2', 1, true) then ic = order end
    if not iq and l:find('##marks_label_bg_alpha', 1, true) then iq = order end
    if not iunder and l:find('##marks_under_bg_alpha', 1, true) then iunder = order end
end
check(ic and iq and ic < iq, 'quest opacity comes after quest color')
check(iq and iunder and iq < iunder, 'object opacity comes after quest opacity')

-- 保存と読み直し
S.marks.label_bg_alpha = 0.4
S.marks.under_bg_alpha = 0.15
app.save_all('test')
local raw = io.open(TMP .. '/Vanacore/config/addons/astertrail/catseye_Tester/settings.json', 'rb'):read('*a')
local saved = require('src.lib.json').decode(raw)
eq(saved.marks.label_bg_alpha, 0.4, 'saved quest opacity')
eq(saved.marks.under_bg_alpha, 0.15, 'saved object opacity')
eq(settings.merge(saved).marks.label_bg_alpha, 0.4, 'loads back')
eq(settings.merge(saved).marks.under_bg_alpha, 0.15, 'loads object back')
print('test_target_id_215 ok')
