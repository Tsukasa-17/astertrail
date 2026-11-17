-- 0.1.194：マイレイアウト（設定の保存）。進行・ピン・お気に入り・名声・デバッグは入れない
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local layouts = require('src.core.layouts')
local smod = require('src.core.settings')
local json = require('src.lib.json')
local focus = require('src.ui.focus')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local st = app.state

eq(layouts.COUNT, 5, 'five slots')

-- 取るもの・取らないもの
S.fonts.book = 1.3
S.windows.book.x, S.windows.book.y, S.windows.book.w, S.windows.book.h = 40, 50, 900, 500
S.look = 'classic'
S.book.col_widths = { mission = { name = 120 } }
S.layout_locked = true
S.tracker.visible = false
S.eminence.visible = true
S.eminence.book_show = { accepted = true, not_accepted = true, completed = false }
S.eminence.columns = { 'name', 'state', 'progress', 'rewards', 'pin', 'fav', 'action' }
S.eminence.pins = { ['12'] = true }
S.eminence.favs = { ['13'] = true }
S.eminence.failed = { ['3055'] = { why = 'not_impl' } }
S.fame = { sandoria = { level = 3 } }
S.debug.state_buttons = true
local snap = layouts.capture_settings(S)
eq(snap.fonts.book, 1.3, 'font captured')
eq(snap.windows.book.x, 40, 'window x captured')
eq(snap.look, 'classic', 'look captured')
eq(snap.book.col_widths.mission.name, 120, 'col width captured')
eq(snap.layout_locked, true, 'lock captured')
eq(snap.tracker.visible, false, 'tracker visibility captured')
eq(snap.eminence.visible, true, 'eminence visibility captured')
eq(snap.eminence.hide_completed, nil, 'hide_completed not captured')
eq(snap.eminence.book_show.completed, false, 'book_show captured')
eq(snap.eminence.columns[1], 'name', 'eminence columns captured')
eq(snap.eminence.pins, nil, 'pins excluded')
eq(snap.eminence.favs, nil, 'favorites excluded')
eq(snap.eminence.failed, nil, 'failed memory excluded')
eq(snap.fame, nil, 'fame excluded')
eq(snap.debug, nil, 'debug excluded')

local open = layouts.capture_open({ open = { book = true, map = true, detail = false } }, S)
eq(open.book, true, 'book open captured')
eq(open.map, true, 'map open captured')
eq(open.detail, false, 'detail closed captured')
eq(open.tracker, false, 'tracker from settings')
eq(open.eminence, true, 'eminence from settings')

-- 欠け・古いキーでも読める。余分なスロットは捨てる
local raw = layouts.normalize({
    slots = {
        { name = '昼\n用', saved = true, settings = { fonts = { book = 1.4 }, eminence = { columns = { 'repeat', 'name' }, pins = { ['1'] = true } } } },
        { name = 123, saved = true }, -- settings が無いので空
        { name = 'x' },
        { name = 'y' },
        { name = 'z' },
        { name = 'sixth', saved = true, settings = { look = 'classic' } },
    }
})
eq(raw.slots[1].name, '昼 用', 'name cleaned')
eq(raw.slots[1].saved, true, 'slot 1 saved')
eq(raw.slots[2].saved, false, 'no settings: not saved')
eq(raw.slots[6], nil, 'sixth slot dropped')
local T = smod.merge({})
T.eminence.pins = { ['99'] = true }
T.debug.state_buttons = true
T.fame = { bastok = { level = 2 } }
layouts.apply_settings(T, raw.slots[1].settings)
eq(T.fonts.book, 1.4, 'missing keys filled, font applied')
eq(T.eminence.pins['99'], true, 'pins kept on apply')
eq(T.debug.state_buttons, true, 'debug kept on apply')
eq(T.fame.bastok.level, 2, 'fame kept on apply')
local has_rep = false
for _, k in ipairs(T.eminence.columns) do if k == 'repeat' then has_rep = true end end
check(not has_rep, 'old repeat column dropped on apply')

-- アプリ：保存してファイルに書き、読込ですぐ戻る
S.fonts.book = 1.0
S.look = 'yunaui'
S.windows.book.x, S.windows.book.y, S.windows.book.w, S.windows.book.h = 11, 22, 640, 480
S.tracker.visible = true
S.eminence.visible = false
S.eminence.pins = { ['12'] = true }
S.eminence.favs = { ['13'] = true }
S.fame = { sandoria = { level = 5 } }
S.debug.state_buttons = true
S.layout_locked = false
app.open_window('book')
eq(app.save_layout(1), true, 'save slot 1')
app.set_layout_name(1, '戦闘用')
eq(app.layout_slots()[1].name, '戦闘用', 'name stored')
eq(app.layout_slots()[1].saved, true, 'marked saved')
local dir = TMP .. '/Vanacore/config/addons/astertrail/catseye_Tester/'
check(ashita.fs.exists(dir .. 'layouts.json'), 'layouts.json in config folder')
local file = json.decode((io.open(dir .. 'layouts.json', 'rb'):read('*a')))
eq(file.data_kind, 'astertrail_layouts', 'file kind')
eq(file.slots[1].name, '戦闘用', 'name in file')
eq(file.slots[1].settings.eminence.pins, nil, 'file has no pins')

-- 今の値を変える（ピン・名声・デバッグも変える）
S.fonts.book = 1.8
S.windows.book.x = 200
S.look = 'classic'
S.tracker.visible = false
S.eminence.visible = true
S.eminence.pins['215'] = true
S.debug.state_buttons = false
S.fame = { windurst = { level = 1 } }
S.layout_locked = true
app.open_window('map')
eq(app.load_layout(2), false, 'empty slot does not load')
eq(app.layout_slots()[2].saved, false, 'slot 2 empty')
eq(app.load_layout(1), true, 'load slot 1')
eq(S.fonts.book, 1.0, 'font restored')
eq(S.windows.book.x, 11, 'window moved')
eq(S.windows.book.y, 22, 'window y restored')
eq(S.look, 'yunaui', 'look restored')
eq(S.tracker.visible, true, 'tracker visible restored')
eq(S.eminence.visible, false, 'eminence hidden restored')
eq(S.layout_locked, false, 'lock restored')
eq(S.eminence.pins['12'], true, 'old pin kept')
eq(S.eminence.pins['215'], true, 'pin added after save is kept')
eq(S.eminence.favs['13'], true, 'favorites kept')
eq(S.fame.windurst.level, 1, 'fame not rolled back')
eq(S.fame.sandoria, nil, 'fame from the snapshot not applied')
eq(S.debug.state_buttons, false, 'debug not restored')

-- 設定の保存タブに並ぶ
app.open_window('settings')
require('src.ui.settings_ui').select_tab('save')
FAKE.texts, FAKE.labels = {}, {}
frame(); frame()
check(texted('マイレイアウト') or texted('My layouts'), 'heading')
check(labeled('ⓘ##lay_info'), 'info button')
check(labeled('保存##lay_save_1') or labeled('Save##lay_save_1'), 'save button')
check(labeled('読込##lay_load_1') or labeled('Load##lay_load_1'), 'load button')
local function has(id)
    for _, it in ipairs((focus.windows.settings and focus.windows.settings.list) or {}) do
        if it.id == id then return it end
    end
end
check(has('lay_info') and has('lay_name_1') and has('lay_save_1') and has('lay_load_1'), 'items are in the pad list')
check(has('lay_name_5') and has('lay_save_5') and has('lay_load_5'), 'all five slots')
eq(has('lay_name_1').section, 'page', 'same section as other save rows')
-- 空のスロットの読込は押せない
FAKE.clicks['読込##lay_load_2'] = true
FAKE.clicks['Load##lay_load_2'] = true
frame()
eq(app.layout_slots()[2].saved, false, 'empty load does nothing')
-- 空のスロットへ保存
FAKE.clicks['保存##lay_save_2'] = true
FAKE.clicks['Save##lay_save_2'] = true
frame()
eq(app.layout_slots()[2].saved, true, 'save from the button')

app.close_window('book'); frame()
print('test_layouts ok')
