-- 0.1.286：アストラル詳細の手順行全体が当たり。①も選べる。枠は ▢ に重ねない
require('fake_env')

local theme = require('src.ui.theme')
local app = require('src.app')
eq(app.VERSION, '1.1.324', 'version')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
FAKE.keep_default_look = true
theme.set_look('sf')
frames(1)
check(app.state.ready, 'logged in')
local S = app._settings()
S.look = 'sf'
theme.set_look('sf')

local bsf = io.open(ROOT .. '/src/ui/book_sf.lua', 'r'):read('*a')
check(bsf:find("'##sfstep_' .. s.id", 1, true) ~= nil, 'each step has a full-row ##sfstep_ hit')
check(bsf:find('SetItemAllowOverlap', 1, true) ~= nil, 'row hit allows later checkbox and name links to overlap')
check(bsf:find('sf.set_cursor(imgui, ax, ay)', 1, true) ~= nil, 'cursor returns to the row origin after the hit so layout is unchanged')
check(not bsf:find('text_col - 6', 1, true), 'frame no longer starts 6px into the text column')
check(bsf:find('FRAME_GAP', 1, true) ~= nil, 'frame keeps a gap after the checkbox')
check(bsf:find('chk_x2 + FRAME_GAP', 1, true) ~= nil, 'measured checkbox right edge drives the frame start')
check(bsf:find("ui.request('set_current_step', q.id, s.id)", 1, true) ~= nil, 'row click still selects the step')
check(bsf:find('row_clicked', 1, true) ~= nil, 'selection uses the row hit')
check(bsf:find('IsMouseClicked', 1, true) ~= nil, 'fallback click still selects when a child steals the row hit')
-- IsItemClicked だけに頼らない（折り返しの最後の断片にしか効かなかった）
local i_hit = bsf:find("'##sfstep_' .. s.id", 1, true)
local i_sel = bsf:find("ui.request('set_current_step', q.id, s.id)", 1, true)
check(i_hit and i_sel and i_hit < i_sel, 'row hit is created before the select request')
local step_loop = bsf:sub(bsf:find('local DOT_R, COL, ROW_GAP', 1, true) or 1,
    bsf:find('if hidden > 0 then', 1, true) or #bsf)
check(not step_loop:find('IsItemClicked', 1, true), 'step selection no longer depends on IsItemClicked of the last text item')
check(step_loop:find('consumed', 1, true) ~= nil, 'name / checkbox actions are consumed so they keep their own behavior')
check(step_loop:find('over_chk', 1, true) ~= nil, 'click on the checkbox does not select via the mouse fallback')
-- 本の右ペインも独立した窓も同じ draw_detail
check(bsf:find('book_sf.draw_detail = draw_detail_sf', 1, true) ~= nil, 'book pane and standalone share draw_detail')
local dsf = io.open(ROOT .. '/src/ui/detail_win_sf.lua', 'r'):read('*a')
check(dsf:find('book_sf.draw_detail', 1, true) ~= nil, 'standalone detail still uses book_sf.draw_detail')
check(dsf:find('standalone = true', 1, true) ~= nil, 'standalone still asks for extra rows')

-- 実行：独立した詳細で、行の当たりを押すと今の手順が移る
local Q = 'quest.windurst.013'
local q = app._data():quest(Q)
if not q or not q.steps or #q.steps < 2 then
    Q = 'quest.sandoria.020'
    q = app._data():quest(Q)
end
check(q and q.steps and #q.steps >= 2, 'test quest has at least two steps: ' .. Q .. ' n=' .. tostring(q and q.steps and #q.steps))
local sid1, sid2 = q.steps[1].id, q.steps[2].id
app._progress():set_state(Q, 'accepted')
eq(app._progress():state(Q), 'accepted', 'accept the quest so checks work')
app.request('set_current_step', Q, sid1)
eq(app._progress():current_step(Q).id, sid1, 'start on the first step')

local imgui = package.loaded['imgui']
local hits = {}
local allow_n = 0
local saved_hit = imgui.InvisibleButton
local saved_allow = rawget(imgui, 'SetNextItemAllowOverlap')
imgui.SetNextItemAllowOverlap = function () allow_n = allow_n + 1 end
imgui.InvisibleButton = function (label, size)
    local w, h = 0, 0
    if type(size) == 'table' then w = tonumber(size.x or size[1]) or 0; h = tonumber(size.y or size[2]) or 0 end
    if type(label) == 'string' and label:find('##sfstep_', 1, true) then
        hits[#hits + 1] = { id = label, w = w, h = h }
    end
    if saved_hit then return saved_hit(label, size) end
    FAKE.labels[#FAKE.labels + 1] = label
    return false
end

app.open_detail_solo(Q)
frame(); frame(); frame()
check(app.state.open.detail, 'standalone Astral detail opens')
check(#hits >= 2, 'row hits are drawn for steps: ' .. tostring(#hits))
local h1, h2
for _, h in ipairs(hits) do
    if h.id:find(sid1, 1, true) then h1 = h end
    if h.id:find(sid2, 1, true) then h2 = h end
end
check(h1 and h2, 'hits exist for ' .. tostring(sid1) .. ' and ' .. tostring(sid2))
check(h1.w >= 80, 'row hit is full width (got ' .. tostring(h1.w) .. ')')
check(h1.h >= 26, 'row hit is tall enough to cover the number circle (got ' .. tostring(h1.h) .. ')')
check(allow_n >= 1, 'SetNextItemAllowOverlap was called')
-- 公開版は手でチェックを付けない（箱は出さない）。非公開版では箱は出して押せる
if app.PUBLIC then
    check(not (labeled('chk_' .. sid1) or labeled('□##chk_' .. sid1) or labeled('■##chk_' .. sid1)),
        'public: checkbox is hidden')
else
    check(labeled('chk_' .. sid1) or labeled('□##chk_' .. sid1) or labeled('■##chk_' .. sid1)
        or labeled('chk_' .. sid1), 'checkbox is still drawn')
end

-- 2番目の手順の行（①の列を含む当たり）を押す
hits = {}
FAKE.clicks['##sfstep_' .. sid2] = true
frame(); frame()
eq(app._progress():current_step(Q).id, sid2, 'clicking the row hit (including the number circle) selects that step')

-- チェックは押せる（今の手順ではない手順を付け外し、進みの連動と分ける）。公開版では変わらない
local done_before = app._progress():step_done(Q, sid1)
FAKE.clicks['chk_' .. sid1] = true
frame(); frame()
if app.PUBLIC then
    eq(app._progress():step_done(Q, sid1), done_before, 'public: checkbox does not toggle the step')
else
    eq(app._progress():step_done(Q, sid1), not done_before, 'checkbox still toggles the step check')
end

-- 本の右ペインでも同じ当たりが出る
app.close_window('detail')
app.open_window('book')
S.book = S.book or {}
S.book.tab = (q.kind == 'mission') and 'mission' or 'quest'
if app.select_in_book then app.select_in_book(Q, true) end
hits = {}
allow_n = 0
frame(); frame(); frame()
local book_hits = 0
for _, h in ipairs(hits) do
    if h.id:find('##sfstep_', 1, true) then book_hits = book_hits + 1 end
end
check(book_hits >= 1 or labeled('##sfstep_'), 'book right pane also draws ##sfstep_ hits')

imgui.InvisibleButton = saved_hit
if saved_allow then imgui.SetNextItemAllowOverlap = saved_allow else imgui.SetNextItemAllowOverlap = nil end

print('test_sf_286 ok')
