-- 0.1.189（t319・t320）：完了したら手順を全部チェック済みにする（ゲームの記録・ログインの読み直し・デバッグの手）。
-- ルートを選んでいれば共通と選んだルート、選んでいなければ全部。未完了に戻してもチェックは外さない。読み込みで1回だけ移し替え。
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
FAKE.player = { name = 'Steps', zone = 230, tidx = 5, status = 0 }
frames(1)
local PR, D = app._progress(), app._data()
local progress = require('src.core.progress')

-- 手順が 3 つ以上でルートの無いクエストと、ルートが 2 つ以上あるクエスト
local linear, routed
for _, q in ipairs(D.quests) do
    if not linear and q.kind == 'quest' and #q.steps >= 3 and #PR:routes(q.id) == 0 then linear = q end
    if not routed and #PR:routes(q.id) >= 2 then
        local only = 0
        for _, s in ipairs(q.steps) do if s.route_ja and s.route_ja ~= '' and not s.routes_ja then only = only + 1 end end
        if only >= 2 then routed = q end
    end
    if linear and routed then break end
end
check(linear ~= nil, 'a linear quest')
check(routed ~= nil, 'a quest with routes')
local function ndone(q) local n = 0 for _, s in ipairs(q.steps) do if PR:step_done(q.id, s.id) then n = n + 1 end end return n end

-- 1) ゲームの記録で完了：全部チェック。前に付けたチェックは元のまま
PR:apply_game(linear.id, 'accepted')
check(PR:check_step(linear.id, linear.steps[1].id).ok, 'first step checked by hand')
local before_at = PR:record(linear.id).steps[linear.steps[1].id]
PR:apply_game(linear.id, 'completed')
eq(ndone(linear), #linear.steps, 'game completion checks every step')
eq(PR:record(linear.id).steps[linear.steps[1].id].source, 'manual', 'hand check kept as it was')
eq(PR:record(linear.id).steps[linear.steps[2].id].source, 'completed', 'auto check marked')
-- 2) 未完了に戻してもチェックはそのまま
check(PR:set_state(linear.id, 'accepted').ok, 'back to accepted (debug)')
eq(ndone(linear), #linear.steps, 'checks stay when it goes back')
-- 同じ完了がもう一度届いても、外したチェックは付け直さない（変わったときだけ）
PR:uncheck_step(linear.id, linear.steps[2].id)
PR:apply_game(linear.id, 'completed')
eq(ndone(linear), #linear.steps, 'completed again (a change) checks again')
PR:uncheck_step(linear.id, linear.steps[2].id)
PR:apply_game(linear.id, 'completed')
eq(ndone(linear), #linear.steps - 1, 'same state again: no re-check')

-- 3) ルート：選んでいなければ全部
PR:apply_game(routed.id, 'completed')
eq(ndone(routed), #routed.steps, 'no route chosen: every step')
-- ルートを選んでいれば、共通と選んだルートだけ
local r2 = PR:routes(routed.id)[1]
PR.doc.quests[routed.id] = nil
PR:apply_game(routed.id, 'accepted')
check(PR:set_route(routed.id, r2).ok, 'route chosen')
PR:apply_game(routed.id, 'completed')
for _, s in ipairs(routed.steps) do
    eq(PR:step_done(routed.id, s.id), progress.step_in_route(s, r2), 'route step: ' .. s.id)
end

-- 4) デバッグの手（set_state）でも
local other
for _, q in ipairs(D.quests) do
    if q.id ~= linear.id and q.id ~= routed.id and #q.steps >= 2 and #PR:routes(q.id) == 0 then other = q; break end
end
check(PR:set_state(other.id, 'completed').ok, 'manual complete')
eq(ndone(other), #other.steps, 'manual completion checks every step')

-- 5) 読み込み：完了しているものを1回だけ移し替え
local doc = {
    progress_schema = 1, character = PR.doc.character,
    quests = { [linear.id] = { state = 'completed', steps = {} }, [other.id] = { state = 'accepted', steps = {} } },
}
local P2 = progress.new({ data = D })
check(P2:adopt(doc, PR.doc.character), 'adopt old save')
local function n2(p, q) local n = 0 for _, s in ipairs(q.steps) do if p:step_done(q.id, s.id) then n = n + 1 end end return n end
eq(n2(P2, linear), #linear.steps, 'completed on load: every step checked')
eq(n2(P2, other), 0, 'not completed on load: untouched')
check(P2.steps_migrated == true and doc.steps_on_complete == true, 'migration flag set')
eq(P2.steps_done_on_load, #linear.steps, 'count of checked steps')
-- 2回目は移し替えない（外したチェックはそのまま）
doc.quests[linear.id].steps[linear.steps[1].id] = nil
local P3 = progress.new({ data = D })
check(P3:adopt(doc, PR.doc.character), 'adopt again')
eq(n2(P3, linear), #linear.steps - 1, 'one-time: no re-check on the next load')
check(not P3.steps_migrated, 'no migration the second time')
-- 新しい記録は移し替え済み
check(progress.new({ data = D }).doc.steps_on_complete == true, 'fresh record already migrated')

-- 6) 完了しているクエスト・ミッションで「今」を選んでも、チェックは全部残る（0.1.191〜）
-- ゲームの記録でもう一度受けたとき（くり返し）は、今までどおりチェックを外して手順1から
local function all_done(q)
    for _, s in ipairs(q.steps) do if not PR:step_done(q.id, s.id) then return false end end
    return true
end
PR.doc.quests[linear.id] = nil
PR:apply_game(linear.id, 'completed')
check(all_done(linear), 'quest completed: every step checked')
local mid = linear.steps[2].id
check(PR:decide_step(linear.id, mid).ok, 'quest: choose 今 on a completed entry')
eq(PR:current_step(linear.id).id, mid, 'quest: current is the chosen step')
check(all_done(linear), 'quest: every check stays')
eq(PR:state(linear.id), 'completed', 'quest: state stays completed')

local BM = D:quest('mission.bastok.003')
check(BM ~= nil and #BM.steps >= 2, 'BM1-3 exists')
PR.doc.quests[BM.id] = nil
PR:apply_game(BM.id, 'completed')
check(all_done(BM), 'mission completed: every step checked')
local bm2 = BM.id .. '#g02'
check(PR:decide_step(BM.id, bm2).ok, 'mission: choose 今 on a completed entry')
eq(PR:current_step(BM.id).id, bm2, 'mission: current is step 2')
check(all_done(BM), 'mission: every check stays')
eq(PR:state(BM.id), 'completed', 'mission: state stays completed')

-- 受注中は今までどおり、選んだ手順から後のチェックを外す
PR.doc.quests[linear.id] = nil
PR:apply_game(linear.id, 'accepted')
PR:check_through(linear.id, linear.steps[#linear.steps].id)
check(all_done(linear), 'accepted: all checked through last')
PR:decide_step(linear.id, linear.steps[2].id)
check(PR:step_done(linear.id, linear.steps[1].id), 'accepted: earlier stays checked')
check(not PR:step_done(linear.id, linear.steps[2].id), 'accepted: chosen step unchecked')
check(not PR:step_done(linear.id, linear.steps[3].id), 'accepted: later unchecked')

-- くり返し：ゲームの記録で完了→受注はチェックを外す（0.1.190のまま）
PR:apply_game(BM.id, 'accepted')
eq(PR:current_step(BM.id).id, BM.steps[1].id, 're-accept: back to step 1')
check(not PR:step_done(BM.id, BM.steps[1].id), 're-accept: checks cleared')
eq(PR:state(BM.id), 'accepted', 're-accept: accepted')
eq(#PR:record(BM.id).cycles, 1, 're-accept: completion history kept')
