-- 0.1.229：トラッカーの今の手順で、複数の話し相手がいるとき「5人」を押す（パッドは決定）と、全員をピンした地図を開く
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local tracker = require('src.ui.tracker')
local map_view = require('src.ui.map_view')
local maps = require('src.core.maps')
FAKE.player = { name = 'Tester', zone = 236, tidx = 5, status = 0, x = 0, y = 0 }
frames(1)
local S = app._settings()
local PR = app._progress()
local D = app._data()

-- 人数の拾い方
do
    local a = tracker.people_counts('バストゥーク港の5人に話す')
    eq(#a, 1, 'one count')
    eq(a[1], '5人', '5人')
    local b = tracker.people_counts('署名を20人分以上集める。8人にも話す')
    eq(#b, 2, '20人分 first, then 8人')
    eq(b[1], '20人分', '20人分 kept together')
    eq(b[2], '8人', '8人')
    eq(#tracker.people_counts('誰かに話す'), 0, 'no count')
end

local Q, sid = 'quest.bastok.028', 'quest.bastok.028#g02'
local step = D:step(sid)
check(tracker.has_multi_map_targets(D, step), 'wildcat port is a multi-target step')
check(#D:listed_talk_targets(step) >= 2, 'has listed talk targets')

PR:apply_game(Q, 'accepted')
eq(app.request('set_current_step', Q, sid).ok, true, 'set current to port step')
eq(PR:current_step(Q).id, sid, 'now at port step')

app.close_all()
S.tracker.visible = true
S.tracker.collapsed = false
app.request('pin', Q)
frame(); frame()

local function has_label(pat)
    for _, l in ipairs(FAKE.labels or {}) do
        if type(l) == 'string' and l:find(pat, 1, true) then return l end
    end
end
local lab = has_label('_group_5人')
check(lab ~= nil, '5人 is a clickable term')
FAKE.clicks['##qn_' .. Q .. '_cur_group_5人'] = true
if lab then FAKE.clicks[lab] = true end
frame(); frame()
check(app.state.open.map, 'clicking 5人 opens the map')
eq(app.state.map.step, sid, 'map is the current multi-target step')
local floor = maps.floor(D, 236, 1) or (maps.floors(D, 236) or {})[1]
local pins = map_view.talk_pins({ data = D, state = app.state }, D, floor, step.location, step, nil)
check(#pins >= 2, 'map has all listed pins: ' .. tostring(#pins))
app.close_window('map'); frame()

-- パッド：件の中で「5人」を選んで決定
check(app.enter_tracker(), 'enter tracker')
frame()
if focus.current('tracker') == 'e_' .. Q then
    app.input('confirm', true, 'key'); app.input('confirm', false, 'key'); frame()
end
eq(app.state.tracker_level, 'inside', 'inside the entry')
focus.set('tracker', 'qn_' .. Q .. '_cur_group_5人')
frame()
eq(focus.current('tracker'), 'qn_' .. Q .. '_cur_group_5人', 'focused 5人')
app.input('confirm', true, 'key'); app.input('confirm', false, 'key'); frame(); frame()
check(app.state.open.map, 'controller confirm on 5人 opens the map')
eq(app.state.map.step, sid, 'pad confirm uses the same step')
app.close_window('map'); frame()
app.release(); frame()

-- 人数の表記が無い複数候補（Storage Hole）は「地図」リンク
local Q2, sid2 = 'quest.sandoria.063', 'quest.sandoria.063#g04'
local step2 = D:step(sid2)
check(tracker.has_multi_map_targets(D, step2), 'Storage Hole candidates are multi-target')
eq(#tracker.people_counts(step2.next_line_ja or ''), 0, 'no people-count in the line')
PR:apply_game(Q2, 'accepted')
eq(app.request('set_current_step', Q2, sid2).ok, true, 'set current to Storage Hole')
app.request('unpin', Q)
app.request('pin', Q2)
app.close_all()
S.tracker.visible = true
S.tracker.collapsed = false
frame(); frame()
local maplab = has_label('_cur_group_map')
check(maplab ~= nil, 'fallback 地図 link is shown')
FAKE.clicks['##qn_' .. Q2 .. '_cur_group_map'] = true
if maplab then FAKE.clicks[maplab] = true end
frame(); frame()
check(app.state.open.map, 'clicking 地図 opens the map')
eq(app.state.map.step, sid2, 'map is the Storage Hole step')
app.request('unpin', Q2)
