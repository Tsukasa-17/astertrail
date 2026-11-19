-- 0.1.253：SF 見た目（本のメインとトラッカー）。クラシック／YunaUI は変えない。
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local theme = require('src.ui.theme')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local D = app._data()
eq(app.VERSION, '1.1.260', 'version')
eq(S.look, 'classic', 'default remains classic')
eq(require('src.core.settings').defaults().look, 'classic', 'defaults classic')

-- クラシックの本：従来のタブ名。ASTERTRAIL ロゴは出さない。作り話の BUILD も出さない。
app.close_all(); app.open_window('book'); frame(); frame()
check(labeled('ミッション') or texted('ミッション'), 'classic mission tab')
check(not texted('ASTERTRAIL'), 'classic has no ASTERTRAIL logo')
check(not texted('BUILD'), 'no fake BUILD in classic')
check(texted('ツェールン鉱山からの報告') or labeled('ツェールン鉱山からの報告'), 'classic shows real mission name')

-- SF に切り替え：ロゴと英字タブ、本物の名前、飾り文言なし
S.look = 'sf'
app.close_all(); app.open_window('book'); frame(); frame(); frame()
eq(theme.look, 'sf', 'theme follows sf')
check(texted('ASTERTRAIL'), 'SF logo')
check(texted('MISSION') or labeled('MISSION'), 'SF mission tab')
check(texted('QUEST') or labeled('QUEST'), 'SF quest tab')
check(texted('EMINENCE') or labeled('EMINENCE'), 'SF eminence tab')
check(not texted('BUILD'), 'no fake BUILD deco')
check(not texted('QUEST LOG'), 'no fake QUEST LOG footer')
check(not texted('QUESTCORE'), 'no fake QUESTCORE deco')
-- カード幅に入りきらない名前は「…」で切るので、先頭で実名を確認する
check(texted('ツェールン鉱山') or labeled('ツェールン鉱山'), 'SF shows real mission name')
check(texted('BM1-1') or labeled('BM1-1'), 'SF shows real mission number')
check(texted('すべて') or labeled('すべて'), 'SF keeps heading all-chip')

-- クエストタブ（本物のクエスト名）
-- タブの当たりは ##sftab_tab_quest
FAKE.clicks['##sftab_tab_quest'] = true
frame(); frame()
eq(S.book.tab, 'quest', 'SF quest tab click')
check(texted('商人のお願い') or labeled('商人のお願い'), 'SF quest tab shows real quest name')

-- クラシックに戻すとロゴが消え、従来のタブに戻る
S.look = 'classic'
S.book.tab = 'mission'
app.close_all(); app.open_window('book'); frame(); frame()
check(labeled('ミッション') or texted('ミッション'), 'back to classic tab label')
check(not texted('ASTERTRAIL'), 'logo gone in classic')
check(texted('ツェールン鉱山からの報告') or labeled('ツェールン鉱山からの報告'), 'classic still shows the mission')

-- トラッカー：SF でも名前と次の一手、手順数が出る
S.look = 'sf'
S.tracker.visible = true
S.tracker.collapsed = false
local PR = app._progress()
local Q = 'quest.bastok.028'
PR:apply_game(Q, 'accepted')
app.request('pin', Q)
app.close_all()
-- トラッカーはピンがあれば出る
frame(); frame(); frame()
local q = D:quest(Q)
local qn = q and (q.name_ja_ref or q.name_en) or Q
check(texted(qn) or labeled(qn), 'SF tracker shows real quest name: ' .. tostring(qn))
local ci, ct = PR:step_count(Q)
if ci and ct then
    check(texted(tostring(ci) .. '/' .. tostring(ct)) or texted(tostring(ci) .. ' / ' .. tostring(ct)),
        'SF tracker shows real step count')
end
check(not texted('BUILD'), 'no BUILD on tracker')

print('test_look_sf_253 ok')
