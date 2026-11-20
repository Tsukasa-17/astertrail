-- 0.1.272：SF 専用の設定画面（C案。クラシック／YunaUI は変えない）
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.292', 'version')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')

local theme = require('src.ui.theme')
local settings_ui = require('src.ui.settings_ui')
local settings_sf = require('src.ui.settings_sf')
local json = require('src.lib.json')

local hook = io.open(ROOT .. '/src/ui/settings_ui.lua', 'r'):read('*a')
check(hook:find("theme.is_sf()", 1, true) ~= nil, 'settings_ui.body routes SF to settings_sf')
check(hook:find("require('src.ui.settings_sf')", 1, true) ~= nil, 'settings_sf is required only for SF')
-- クラシックのタブ構成は残す
check(hook:find("key = 'eminence'", 1, true) ~= nil or hook:find("key = \"eminence\"", 1, true) ~= nil
    or hook:find("'eminence'", hook:find('SECTIONS') or 1, true) ~= nil, 'classic still has eminence tab')
check(hook:find("t('settings.look_style'", 1, true) ~= nil, 'classic look_style label key is unchanged')

local sfsrc = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a')
check(sfsrc:find('ASTERTRAIL', 1, true) ~= nil, 'header includes ASTERTRAIL')
check(sfsrc:find("'SETTINGS'", 1, true) ~= nil or sfsrc:find('"SETTINGS"', 1, true) ~= nil, 'header includes SETTINGS')
check(sfsrc:find('function ICONS.notify', 1, true) ~= nil, 'bell icon is drawn in code')
check(sfsrc:find('function ICONS.save', 1, true) ~= nil, 'disk icon is drawn in code')
check(sfsrc:find('function ICONS.input', 1, true) ~= nil, 'input icon is drawn in code')
check(sfsrc:find('.png', 1, true) == nil, 'no copied image assets')
check(sfsrc:find('n_popup_try', 1, true) ~= nil, 'notify preview has try buttons')
check(sfsrc:find('manual_checks', 1, true) ~= nil, 'debug stays behind manual_checks')
check(sfsrc:find("look_style", 1, true) ~= nil, 'look_style widget id is kept')

local keys = {}
for _, c in ipairs(settings_sf.CATS) do keys[#keys + 1] = c.key end
eq(table.concat(keys, ','), 'look,layout,tracker,map,marks,notify,input,save', 'eight SF categories')
eq(settings_sf.cat_key('eminence'), 'tracker', 'old eminence tab maps to tracker')
eq(settings_sf.cat_key('about'), 'save', 'old about tab maps to save')

local ja = json.decode(io.open(ROOT .. '/locales/ja.json', 'r'):read('*a'))
local en = json.decode(io.open(ROOT .. '/locales/en.json', 'r'):read('*a'))
eq(ja['settings.look_style'], '見た目：{v}', 'classic ja look_style unchanged')
eq(ja['settings.font_crisp'], 'くっきりフォント（テスト）', 'classic ja crisp label unchanged')
eq(ja['sf.set.theme'], 'テーマ：{v}', 'SF theme label')
eq(ja['sf.set.font_crisp'], '画面の文字をくっきり（メイリオ）', 'SF crisp rename')
eq(ja['sf.set.roe_collapsed'], '★を付けたものだけ出す', 'SF eminence fold rename')
eq(ja['sf.set.show_items'], '手順の必要品アイコン', 'SF need-item rename')
eq(ja['sf.set.show_possession'], '持っている数の表示', 'SF possession rename')
eq(ja['sf.set.remember_position'], '設定を開いたとき、前回の項目から始める', 'SF remember-position rename')
eq(en['sf.set.theme'], 'Theme: {v}', 'EN theme label present')
eq(en['settings.look_style'], 'Look: {v}', 'classic en look_style unchanged')

-- クラシックの設定画面は今までどおり
local S = app._settings()
S.look = 'classic'
theme.set_look('classic')
app.close_all(); app.open_window('settings'); frame(); frame(); frame()
check(labeled('見た目：クラシック'), 'classic settings still use the old theme label')
check(labeled('くっきりフォント（テスト）'), 'classic crisp label unchanged at runtime')
app.close_all(); frame()

-- SF に切り替えると新しい画面（look_style の ID はそのまま）
S.look = 'sf'
theme.set_look('sf')
app.open_window('settings'); frame(); frame(); frame()
check(labeled('テーマ：アストラル'), 'SF settings uses the アストラル theme label')
-- くっきりは FONT パネルに出している（たたみはしない）
check(labeled('画面の文字をくっきり（メイリオ）'), 'SF crisp rename is visible')
check(not labeled('くっきりフォント（テスト）'), 'old crisp label is not used on the SF screen')
check(texted('見た目') or labeled('見た目'), 'left category 見た目')
check(texted('配置') or labeled('配置'), 'left category 配置')
check(texted('トラッカー') or labeled('トラッカー'), 'left category トラッカー')
check(texted('地図') or labeled('地図'), 'left category 地図')
check(texted('アイコン') or labeled('アイコン'), 'left category アイコン')
check(texted('お知らせ') or labeled('お知らせ'), 'left category お知らせ')
check(texted('操作') or labeled('操作'), 'left category 操作')
check(texted('保存') or labeled('保存'), 'left category 保存')
check(labeled('戻る'), 'footer back')
check(texted('クリックで選ぶ') or labeled('クリックで選ぶ'), 'footer mouse hint')
check(texted('Esc で閉じる') or labeled('Esc で閉じる'), 'footer Esc hint')

settings_ui.select_tab('notify'); frame(); frame()
check(labeled('試す') or labeled('受注を試す') or labeled('受注'), 'notify preview try control is present')

settings_ui.select_tab('tracker'); frame(); frame()
check(texted('★を付けたものだけ出す') or labeled('★を付けたものだけ出す'), 'eminence fold lives under tracker with the new label')

settings_ui.select_tab('save'); frame(); frame()
check(texted('版 ' .. app.VERSION) or labeled('版 ' .. app.VERSION), 'footer or about shows the version')
check(texted('Based on YunaUI by Yunas') or labeled('Based on YunaUI by Yunas'), 'license credit at end of save')

-- 公開ビルドではデバッグが出ない
local old_mc = app.manual_checks
package.loaded['src.build_flags'] = nil
-- public フラグそのものは変えない。ソースの分岐だけ見る
check(sfsrc:find('ui.manual_checks', 1, true) ~= nil, 'debug widgets are gated')

-- 保存キーは増やさない（折りたたみはモジュール内。settings テーブルへは書かない）
check(sfsrc:find('S.settings_folds', 1, true) == nil, 'SF details do not write settings_folds')
check(type(S.language) == 'string', 'existing keys still present')

app.close_all(); frame()
S.look = 'classic'
theme.set_look('classic')
print('test_sf_270 ok')
