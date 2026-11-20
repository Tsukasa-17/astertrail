-- 0.1.217：地図で見ている手順が「今」の手順でなくても、相手が見えていれば本当の座標にピン1つ（候補は消す）
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local marks_core = require('src.core.marks')
local marks_ui = require('src.ui.marks')
local mv = require('src.ui.map_view')
local maps = require('src.core.maps')

FAKE.player = { name = 'Tester', zone = 122, tidx = 5, status = 0 }
frames(1)
eq(app.VERSION, '1.1.285', 'version 0.1.251')
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')

local D = app._data()
local step = D:step('mission.bastok.015#g02')
eq(step.target, 'obj.122.???_BM7-1', 'viewed step targets the moving ???')
local loc = step.location
eq(tonumber(loc.zone_id), 122, 'Ro\'Maeve')
local floor = maps.pick_floor(D, loc, nil)
check(floor ~= nil, 'floor for Ro\'Maeve')

-- 頭上の印の側は「今」の手順（Cid と話す）だけ：live_pos には何も無い
local rows, scans = {}, 0
local plat = { visible_entities = function () scans = scans + 1; return rows end }
local st = { now = 1, ready = true }
local ui = { data = D, platform = plat, state = st, player = { zone_id = 122, x = 100, y = -110 } }
eq(marks_ui.live_position(ui, 122, step.target), nil, 'not remembered by the marks pass')

local me = { index = 5, name = 'Tester', kind = 'pc', x = 100, y = -110, render_flags = 0x200 }
local other = { index = 281, name = '???', server_id = 17277209, x = 260, y = 10, render_flags = 0x200 }
local qm2 = { index = 280, name = '???', server_id = 17277208, x = 105, y = -112, z = -4, render_flags = 0x400200 }

-- 見えている（番号が合う・出ている）：ピン1つ、候補なし
rows = { me, other, qm2 }
local pin, cands = mv.step_pin(ui, D, floor, loc, step, nil)
check(pin and pin.kind == 'live', 'live pin for the viewed non-current step')
eq(cands, nil, 'no candidates when the real ??? is loaded')
local bx, by = maps.world_px(floor, 105, -112)
check(pin and math.abs(pin.base_x - bx) < 0.01 and math.abs(pin.base_y - by) < 0.01, 'pin at the live position')
local lp = marks_ui.step_live_position(ui, 122, step)
check(lp and lp.x == 105 and lp.y == -112, 'step_live_position gives the real ???')

-- 同じフレームでは読み直さない（頭上の印の側と共有）
local s0 = scans
marks_ui.frame_entities(ui)
mv.step_pin(ui, D, floor, loc, step, nil)
eq(scans, s0, 'no extra scan in the same frame')

-- 番号のちがう ??? だけ：候補のまま
st.now = 2
rows = { me, other }
pin, cands = mv.step_pin(ui, D, floor, loc, step, nil)
check(not (pin and pin.kind == 'live'), 'no live pin when not loaded')
eq(cands and #cands, 10, 'ten candidates when not loaded')

-- 見えているが「出ている」合図が無い：候補のまま（そのフレームでピンを外す）
st.now = 3
rows = { me, other, { index = 280, name = '???', server_id = 17277208, x = 105, y = -112, render_flags = 0x400000 } }
pin, cands = mv.step_pin(ui, D, floor, loc, step, nil)
check(not (pin and pin.kind == 'live'), 'no live pin when render is not shown')
eq(cands and #cands, 10, 'candidates when render is not shown')

-- 戻ってきたら、またピン1つ
st.now = 4
rows = { me, qm2 }
pin, cands = mv.step_pin(ui, D, floor, loc, step, nil)
check(pin and pin.kind == 'live' and cands == nil, 'live pin again when it reappears')

-- ほかのゾーンにいるときは探さない
st.now = 5
ui.player = { zone_id = 230, x = 0, y = 0 }
pin, cands = mv.step_pin(ui, D, floor, loc, step, nil)
check(not (pin and pin.kind == 'live') and cands and #cands == 10, 'other zone: candidates')

-- 場所を選んで見ているとき（fixed_loc）は今までどおり
st.now = 6
ui.player = { zone_id = 122, x = 100, y = -110 }
pin, cands = mv.step_pin(ui, D, floor, loc, step, { zone_id = 122 })
check(not (pin and pin.kind == 'live') and cands == nil, 'fixed location: no search, no candidates')

-- 頭上の印は「今」の手順だけ：手順2の ??? は wanted に入らない
check(marks_core.wanted_for_step(D, step).server_id == 17277208, 'wanted_for_step uses the server id')

-- 0.1.217：BM7-1 の手順2「???を探す」と手順3「見つけた???を調べる」を1つにまとめた（6 → 5手順）
do
    local Q = 'mission.bastok.015'
    local q = D:quest(Q)
    eq(#q.steps, 5, 'BM7-1 has 5 steps')
    local ids = {}
    for i, s in ipairs(q.steps) do ids[#ids + 1] = s.id; eq(s.order, i, 'order ' .. s.id) end
    eq(table.concat(ids, ','), table.concat({ Q .. '#g01', Q .. '#g02', Q .. '#g04', Q .. '#g05', Q .. '#g06' }, ','), 'step ids')
    eq(D:step(Q .. '#g03'), nil, 'g03 removed')
    local g2 = D:step(Q .. '#g02')
    eq(g2.type, 'examine', 'merged step examines')
    eq(g2.target, 'obj.122.???_BM7-1', 'merged target')
    eq(g2.next_line_ja, 'ロ・メーヴのガレキの山のどこかに出る???を探して調べる', 'merged line')
    check(g2.text_ja:find('10か所', 1, true) and g2.text_ja:find('Mokkurkalfi', 1, true), 'merged text has both')
    eq(g2.next[1], Q .. '#g04', 'next skips g03')
    check(g2.extra_sources and #g2.extra_sources > 0, 'extra sources kept')
    eq(#marks_core.candidates_for(D, g2), 10, 'candidates kept')
    eq(D.step_alias[Q .. '#g03'], Q .. '#g02', 'g03 alias to g02')

    local progress = require('src.core.progress')
    local json = require('src.lib.json')
    local who = { server = 'catseye', name = 'Test' }
    local function adopt(rec)
        local Pm = progress.new({ data = D })
        rec.state = rec.state or 'accepted'; rec.cycles = rec.cycles or {}
        check(Pm:adopt({ progress_schema = 1, character = who, quests = { [Q] = rec },
            last_focus = { quest = Q, step = rec.current_step } }, who), 'adopt')
        return Pm
    end
    -- g03（調べる）にいた：まとめた g02 に着地。g02 は「調べる」がまだなので未済
    local Pm = adopt({ current_step = Q .. '#g03', steps = {
        [Q .. '#g01'] = { done = true, source = 'manual' }, [Q .. '#g02'] = { done = true, source = 'manual' } } })
    eq(Pm:current_step(Q).id, Q .. '#g02', 'saved on g03 lands on merged g02')
    check(not Pm:step_done(Q, Q .. '#g02'), 'merged step not done while examine was pending')
    check(Pm:step_done(Q, Q .. '#g01'), 'g01 kept')
    eq(Pm.doc.last_focus.step, Q .. '#g02', 'last focus mapped')
    -- g03 まで済んで g04 にいた：g02 は済みのまま、g03 の記録は steps_draft に
    Pm = adopt({ current_step = Q .. '#g04', steps = {
        [Q .. '#g01'] = { done = true }, [Q .. '#g02'] = { done = true }, [Q .. '#g03'] = { done = true } } })
    check(Pm:step_done(Q, Q .. '#g02'), 'merged step done when both were done')
    eq(Pm:current_step(Q).id, Q .. '#g04', 'current stays on g04')
    check(Pm:record(Q).steps_draft[Q .. '#g03'], 'g03 record kept aside')
    -- 2回目は何もしない
    local P2 = progress.new({ data = D })
    check(P2:adopt(json.decode(json.encode(Pm:snapshot())), who), 'adopt again')
    eq(P2.migrated_guides, 0, 'idempotent')
end
