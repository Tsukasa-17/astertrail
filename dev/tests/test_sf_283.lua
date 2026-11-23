-- 0.1.283：独立した詳細とコンパスの SF 見た目、右上の ×
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.318', 'version')

-- --- ソース：フックと右上の ×。クラシックは触らない。窓サイズは上書きしない ---
local det = io.open(ROOT .. '/src/ui/detail.lua', 'r'):read('*a')
check(det:find("require('src.ui.detail_win_sf')", 1, true) ~= nil, 'detail hooks detail_win_sf in SF')
local ddraw = det:find('function detail.draw', 1, true)
check(ddraw ~= nil, 'detail.draw exists')
-- クラシックの本体は no_title / sf_frame を使わない
local classic_body = det:sub(ddraw)
local hook_end = classic_body:find('local t = ui.t', 1, true)
check(hook_end ~= nil, 'classic detail.draw remains after the hook')
local classic = classic_body:sub(hook_end)
check(classic:find("title = t('detail.title')", 1, true) ~= nil, 'classic detail title unchanged')
check(not classic:find('no_title', 1, true), 'classic detail keeps the title bar')
check(not classic:find('sf_frame', 1, true), 'classic detail has no sf_frame')
check(classic:find("W.button(ui, name, 'back', t('common.close')", 1, true) ~= nil, 'classic footer close unchanged')

local cmp = io.open(ROOT .. '/src/ui/compass.lua', 'r'):read('*a')
check(cmp:find("require('src.ui.compass_sf')", 1, true) ~= nil, 'compass hooks compass_sf in SF')
local cdraw = cmp:find('function compass.draw', 1, true)
local c_classic = cmp:sub(cdraw)
local c_hook = c_classic:find("local imgui, t = ui.imgui, ui.t", 1, true)
check(c_hook ~= nil, 'classic compass.draw remains after the hook')
c_classic = c_classic:sub(c_hook)
check(not c_classic:find('no_title', 1, true), 'classic compass keeps the title bar')
check(not c_classic:find('sf_frame', 1, true), 'classic compass has no sf_frame')

local dsf = io.open(ROOT .. '/src/ui/detail_win_sf.lua', 'r'):read('*a')
check(dsf:find('book_sf.draw_detail', 1, true) ~= nil, 'standalone SF detail reuses book_sf.draw_detail')
check(dsf:find('title_close', 1, true) ~= nil, 'standalone SF detail has title close')
check(dsf:find('##astertrail_sf_detail_win', 1, true) ~= nil, 'detail body is in a child below the header')
check(not dsf:find('SetNextWindowSize', 1, true), 'detail_win_sf does not override size')

local csf = io.open(ROOT .. '/src/ui/compass_sf.lua', 'r'):read('*a')
check(csf:find('title_close', 1, true) ~= nil, 'SF compass has title close')
check(csf:find('##astertrail_sf_compass_body', 1, true) ~= nil, 'compass body is in a child below the header')
check(csf:find("'sf_amber'", 1, true) ~= nil, 'SF compass quest names use amber')
check(csf:find("color = 'npc'", 1, true) ~= nil, 'SF compass NPC names use npc color')
check(not csf:find('SetNextWindowSize', 1, true), 'compass_sf does not override size')

local bsf = io.open(ROOT .. '/src/ui/book_sf.lua', 'r'):read('*a')
check(bsf:find('book_sf.draw_detail = draw_detail_sf', 1, true) ~= nil, 'book_sf exports draw_detail')

local ms = io.open(ROOT .. '/src/ui/map_sf.lua', 'r'):read('*a')
check(ms:find('title_close', 1, true) ~= nil, 'SF map has title close')
check(ms:find("W.button(ui, name, 'close'", 1, true) ~= nil, 'SF map keeps the footer close')
check(ms:find("ui.close_window('map')", 1, true) ~= nil, 'SF map title/footer close still closes')
-- × は見出し行。本文（地図枠）はその下から
local i_title = ms:find('title_close.draw', 1, true)
local i_frame = ms:find('地図枠と目盛り用の余白', 1, true)
check(i_title and i_frame and i_title < i_frame, 'map title close is drawn before the map body')
check(ms:find('hy + head_h', 1, true) ~= nil, 'map body starts below the header')

local esf = io.open(ROOT .. '/src/ui/eminence_win_sf.lua', 'r'):read('*a')
check(esf:find('title_close', 1, true) ~= nil, 'SF eminence has title close')
local i_em_close = esf:find('title_close.draw', 1, true)
local i_em_child = esf:find('##astertrail_sf_em_win', 1, true)
check(i_em_close and i_em_child and i_em_close < i_em_child, 'eminence close is before the body child')
check(esf:find("ui.set_eminence_visible(false)", 1, true) ~= nil, 'eminence close hides the window')
check(not esf:find('SetNextWindowSize', 1, true), 'eminence_win_sf does not override size')

local tc = io.open(ROOT .. '/src/ui/title_close.lua', 'r'):read('*a')
check(tc:find("label or '×'", 1, true) ~= nil, 'title close uses the same × as the tracker')
check(tc:find("id or 'title_close'", 1, true) ~= nil, 'title close has its own id')

local mv = io.open(ROOT .. '/src/ui/map_view.lua', 'r'):read('*a')
check(not mv:find('title_close', 1, true), 'classic map_view does not get title_close')
local em = io.open(ROOT .. '/src/ui/eminence.lua', 'r'):read('*a')
-- hook only
local em_draw = em:find('function eminence.draw', 1, true) or em:find('function M.draw', 1, true)
-- eminence.draw is in eminence.lua; after hook the classic path has no title_close
check(not em:find('title_close', 1, true), 'classic eminence.lua does not get title_close')

-- 0.1.282 の Esc はそのまま
local aps = io.open(ROOT .. '/src/app.lua', 'r'):read('*a')
check(aps:find('function app.want_esc', 1, true) ~= nil, 'want_esc remains')
check(aps:find('function app.esc_target', 1, true) ~= nil, 'esc_target remains')

-- --- 実行 ---
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Sf283', zone = 100, tidx = 5, status = 0, x = -100, y = 200, z = -60 }
frames(1)
check(app.state.ready, 'logged in')
local S = app._settings()
local theme = require('src.ui.theme')

local Q = 'quest.bastok.001'

-- クラシックの独立詳細はこれまでどおり（フッタの閉じる・本で見る）
S.look = 'classic'
theme.set_look('classic')
app.open_detail_solo(Q); frame(); frame()
check(app.state.open.detail, 'classic standalone detail opens')
check(labeled('##to_book') or labeled('##to_book_footer'), 'classic to-book remains')
check(labeled('##back'), 'classic footer close remains')
check(not labeled('##title_close'), 'classic standalone detail has no title ×')
FAKE.clicks['##back'] = true; frame(); frame()
check(not app.state.open.detail, 'classic footer close still works')

-- SF の独立詳細：本と同じ見出し・手順・REWARD/LOCATION、右上の ×
S.look = 'sf'
theme.set_look('sf')
app.open_detail_solo(Q); frame(); frame(); frame()
check(app.state.open.detail, 'SF standalone detail opens')
check(labeled('##title_close'), 'SF standalone detail drew ×')
check(labeled('##to_book'), 'SF standalone detail has to-book')
local joined = table.concat(FAKE.texts or {}, '') .. table.concat(FAKE.labels or {}, '')
check(joined:find('DETAIL', 1, true) or seen('DETAIL'), 'SF detail heading is DETAIL')
check(joined:find('OBJECTIVE', 1, true) or seen('OBJECTIVE') or seen('目的'), 'SF detail shows OBJECTIVE')
check(joined:find('REWARD', 1, true) or seen('REWARD'), 'SF detail shows REWARD')
check(joined:find('LOCATION', 1, true) or seen('LOCATION'), 'SF detail shows LOCATION')
-- ギル：このクエストは 150ギル
check(joined:find('ギル', 1, true) or labeled('ギル') or seen('150'), 'SF detail shows the gil reward')
FAKE.clicks['##title_close'] = true; frame(); frame()
check(not app.state.open.detail, 'clicking × closes the standalone detail')

-- もう一度開いて、Esc（0.1.282）でも閉じる
app.open_detail_solo(Q); frame(); frame()
check(app.state.open.detail, 'SF detail open again')
app.release()
app.state.win_hover = { detail = true }
app.state.win_focus = { detail = true }
check(app.want_esc(), 'hovered SF detail wants Esc')
eq(app.esc_target(), 'detail', 'esc target is detail')
do
    local e = { key = 0x01, down = true, blocked = false }
    FAKE.events.key_data(e)
    FAKE.events.key_data({ key = 0x01, down = false, blocked = false })
end
frame()
check(not app.state.open.detail, 'Esc still closes the standalone detail')

-- SF 地図：右上の × でも閉じる。フッタの閉じるは残す
S.map = S.map or {}
S.map.enabled = true
app.open_map(); frame(); frame()
check(app.state.open.map, 'SF map is open')
check(labeled('##title_close'), 'SF map drew header ×')
check(labeled('##close') or labeled('閉じる'), 'SF map still has footer close')
FAKE.clicks['##title_close'] = true; frame(); frame()
check(not app.state.open.map, 'clicking header × closes the SF map')
-- フッタもこれまでどおり
app.open_map(); frame(); frame()
FAKE.clicks['##close'] = true; frame()
check(not app.state.open.map, 'footer 閉じる still closes the SF map')

-- SF エミネンス：右上の × で隠す
S.eminence = S.eminence or {}
S.eminence.visible = true
frame(); frame(); frame()
check(S.eminence.visible, 'eminence visible')
check(labeled('##title_close'), 'SF eminence drew ×')
FAKE.clicks['##title_close'] = true; frame(); frame()
check(not S.eminence.visible, 'clicking × hides the eminence window')

-- SF コンパス：見た目と ×
S.compass = S.compass or {}
S.compass.visible = true
S.compass.max_dist = 200
FAKE.player = { name = 'Sf283', zone = 230, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
-- zone_id on app.state.player is set by poll; nudge
if app.state.player then app.state.player.zone_id = 230; app.state.player.x = 0; app.state.player.y = 0 end
frames(1.2)
check(S.compass.visible, 'compass visible')
check(labeled('##title_close'), 'SF compass drew ×')
local cjoin = table.concat(FAKE.texts or {}, '') .. table.concat(FAKE.labels or {}, '')
check(cjoin:find('COMPASS', 1, true) or seen('COMPASS') or seen('コンパス'), 'SF compass heading is drawn')
if app.state.compass and #app.state.compass > 0 then
    local row = app.state.compass[1]
    local qn = app._data():quest(row.qid)
    local nm = require('src.ui.labels').qname(qn)
    check(labeled(nm) or texted(nm) or seen(nm), 'SF compass shows a quest name')
    if row.npc then
        check(labeled(row.npc) or texted(row.npc) or seen(row.npc), 'SF compass shows the giver')
    end
end
FAKE.clicks['##title_close'] = true; frame(); frame()
check(not S.compass.visible, 'clicking × hides the compass')

-- クラシックに戻して、地図の閉じるは残る
app.close_all(); frame()
S.look = 'classic'
theme.set_look('classic')
app.open_map(); frame(); frame()
check(app.state.open.map, 'classic map is open')
check(not labeled('##title_close'), 'classic map has no title ×')
check(labeled('##close') or labeled('閉じる'), 'classic map drew close')
FAKE.clicks['##close'] = true; frame(); frame()
check(not app.state.open.map, 'classic map close still works')

print('test_sf_283 ok')
