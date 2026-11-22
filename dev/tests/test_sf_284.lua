-- 0.1.285：見た目の表示名をアストラルに、初期と初回移行、× を枠の内側へ、独立詳細の詳しい行
require('fake_env')

local json = require('src.lib.json')
local settings = require('src.core.settings')
local theme = require('src.ui.theme')

eq(settings.defaults().look, 'sf', 'defaults look is アストラル')
eq(settings.defaults().theme_astral_migrated, true, 'defaults already have the flag')
eq(require('src.ui.theme').LOOKS[3], 'sf', 'internal key stays sf')

-- 印が無い保存は一度アストラルへ。印のあとは選んだ見た目を維持する
eq(settings.merge({}).look, 'sf', 'empty merge is アストラル')
eq(settings.merge({ look = 'classic' }).look, 'sf', 'classic without flag migrates')
eq(settings.merge({ look = 'yunaui' }).theme_astral_migrated, true, 'yunaui without flag gets the flag')
eq(settings.merge({ look = 'classic', theme_astral_migrated = true }).look, 'classic', 'classic after flag is kept')
eq(settings.merge({ look = 'yunaui', theme_astral_migrated = true }).look, 'yunaui', 'yunaui after flag is kept')
eq(settings.merge({ look = 'sf', theme_astral_migrated = true }).look, 'sf', 'アストラル after flag is kept')

local ja = json.decode(io.open(ROOT .. '/locales/ja.json', 'r'):read('*a'))
local en = json.decode(io.open(ROOT .. '/locales/en.json', 'r'):read('*a'))
eq(ja['settings.look_sf'], 'アストラル', 'JA display name is アストラル')
eq(en['settings.look_sf'], 'Astral', 'EN display name is Astral')
check(not tostring(ja['settings.look_sf']):find('実験', 1, true), 'JA dropped 実験中')
check(not tostring(en['settings.look_sf']):lower():find('experimental', 1, true), 'EN dropped experimental')

-- × は枠の内側。角の切れ（余白 3 + 切れ 12）より外に出さない
local tc = io.open(ROOT .. '/src/ui/title_close.lua', 'r'):read('*a')
check(tc:find('INSET_X = 22', 1, true) ~= nil, 'close has a right inset')
check(tc:find('INSET_Y = 20', 1, true) ~= nil, 'close has a top inset')
check(tc:find('function title_close.header_origin', 1, true) ~= nil, 'header_origin exists')
check(tc:find('function title_close.right_limit', 1, true) ~= nil, 'right_limit exists')
for _, f in ipairs({ 'map_sf.lua', 'eminence_win_sf.lua', 'compass_sf.lua', 'detail_win_sf.lua' }) do
    local src = io.open(ROOT .. '/src/ui/' .. f, 'r'):read('*a')
    check(src:find('title_close.header_origin', 1, true) ~= nil, f .. ' uses header_origin')
    check(src:find('title_close.draw', 1, true) ~= nil, f .. ' still draws ×')
end
local dsf = io.open(ROOT .. '/src/ui/detail_win_sf.lua', 'r'):read('*a')
check(dsf:find('title_close.right_limit', 1, true) ~= nil, 'detail keeps 本に戻る left of ×')
check(dsf:find('standalone = true', 1, true) ~= nil, 'standalone detail asks for extra rows')
check(dsf:find('status_line', 1, true) ~= nil, 'standalone detail shows the status line')
local bsf = io.open(ROOT .. '/src/ui/book_sf.lua', 'r'):read('*a')
check(bsf:find("t('detail.state'", 1, true) ~= nil, 'standalone can show state')
check(bsf:find("t('detail.where'", 1, true) ~= nil, 'standalone can show step location')
check(bsf:find("t('detail.needs'", 1, true) ~= nil, 'standalone can show needs')
check(bsf:find("t('detail.target'", 1, true) ~= nil, 'standalone can show the target')
check(bsf:find("t('detail.branch'", 1, true) ~= nil, 'standalone can show branch')
check(bsf:find('q.note_ja', 1, true) ~= nil, 'standalone can show the note')
check(bsf:find('opts.standalone == true', 1, true) ~= nil, 'book pane stays unless standalone')

-- 既存ユーザーの設定ファイルを置いてからログイン（初回移行と保存）
local dir = TMP .. '/Vanacore/config/addons/astertrail/catseye_OldUser/'
os.execute('mkdir -p "' .. dir .. '"')
local wf = io.open(dir .. 'settings.json', 'wb')
wf:write(json.encode({ look = 'classic', language = 'ja' }))
wf:close()

local app = require('src.app')
eq(app.VERSION, '1.1.314', 'version')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'OldUser', zone = 230, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
FAKE.keep_default_look = true
frames(1)
check(app.state.ready, 'logged in')
local S = app._settings()
eq(S.look, 'sf', 'existing classic user migrates to アストラル once')
eq(S.theme_astral_migrated, true, 'migration flag is set in memory')
app.save_all('manual')
local saved = json.decode((io.open(dir .. 'settings.json', 'rb'):read('*a')))
eq(saved.look, 'sf', 'migrated look was saved through normal settings save')
eq(saved.theme_astral_migrated, true, 'flag was saved in the user settings file')

-- そのあとクラシックへ戻して保存し、読み直してもクラシックのまま
S.look = 'classic'
theme.set_look('classic')
app.mark_settings_dirty()
app.save_all('manual')
app.on_logout()
FAKE.events.load()
FAKE.player = { name = 'OldUser', zone = 230, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
frames(1)
S = app._settings()
eq(S.look, 'classic', 'after the one-time migration, classic is kept')
eq(S.theme_astral_migrated, true, 'flag remains')

-- 表示名
S.look = 'sf'
theme.set_look('sf')
app.close_all(); app.open_window('settings'); frame(); frame(); frame()
check(labeled('テーマ：アストラル') or labeled('アストラル'), 'settings label is アストラル')
app.close_all(); frame()

-- 独立詳細：クラシックにある詳しい行と、枠の内側の ×
local Q = 'quest.bastok.001'
app.open_detail_solo(Q); frame(); frame(); frame()
check(app.state.open.detail, 'アストラル standalone detail opens')
check(labeled('##title_close'), 'detail drew ×')
check(labeled('##to_book'), '本に戻る remains')
local joined = table.concat(FAKE.texts or {}, '') .. table.concat(FAKE.labels or {}, '')
check(joined:find('状態:', 1, true) or seen('状態:'), 'standalone shows state')
check(joined:find('場所:', 1, true) or seen('場所:'), 'standalone shows location')
FAKE.clicks['##title_close'] = true; frame(); frame()
check(not app.state.open.detail, 'inset × still closes the detail window')

-- 地図・エミネンス・コンパスの × も押せる
S.map = S.map or {}; S.map.enabled = true
app.open_map(); frame(); frame()
check(app.state.open.map, 'map open')
check(labeled('##title_close'), 'map drew ×')
FAKE.clicks['##title_close'] = true; frame(); frame()
check(not app.state.open.map, 'map × still works')

S.eminence = S.eminence or {}; S.eminence.visible = true
frame(); frame(); frame()
check(S.eminence.visible, 'eminence visible')
check(labeled('##title_close'), 'eminence drew ×')
FAKE.clicks['##title_close'] = true; frame(); frame()
check(not S.eminence.visible, 'eminence × still works')

S.compass = S.compass or {}; S.compass.visible = true; S.compass.max_dist = 200
frames(1.2)
check(S.compass.visible, 'compass visible')
check(labeled('##title_close'), 'compass drew ×')
FAKE.clicks['##title_close'] = true; frame(); frame()
check(not S.compass.visible, 'compass × still works')

-- クラシックの独立詳細は触っていない
S.look = 'classic'
theme.set_look('classic')
app.open_detail_solo(Q); frame(); frame()
check(labeled('##back'), 'classic footer close remains')
check(not labeled('##title_close'), 'classic standalone has no title ×')
FAKE.clicks['##back'] = true; frame(); frame()
check(not app.state.open.detail, 'classic close still works')

print('test_sf_284 ok')
