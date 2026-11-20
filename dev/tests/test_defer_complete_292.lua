-- 0.1.292：BM7-2 の完了と QUEST COMPLETE は、ウェライからの手紙を渡すまで待たせる
require('harness')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local marks = require('src.core.marks')

local D = data_mod.load(posix_fs(), ROOT .. '/data/')
eq(#D.errors, 0, 'data errors')
local P = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
P:reset({ server = 'catseye', name = 'Defer' })

local Q16, Q17 = 'mission.bastok.016', 'mission.bastok.017'
local G05 = 'mission.bastok.016#g05'
local LETTER = 'BM7-2の後日談：バストゥーク鉱山区(J-7)のGumbahに「ウェライからの手紙」を渡す'

local function have_ki(v)
    return function (id, n)
        local kid = tonumber((type(n) == 'table' and n.key_item_id) or id)
        if kid == 290 then return v end
        return nil
    end
end

local fu = P:followup_complete_step(Q16)
check(fu and fu.id == G05, 'BM7-2 g05 is the key-item followup')
check(P:followup_complete_step(Q17) == nil, 'BM8-1 has no key-item followup')

-- ほかのミッションで、同じ形（して完了のあと、一時的なだいじなものを渡す後日談）があるか
local others, cand = {}, {}
for _, q in ipairs(D.quests) do
    if q.kind == 'mission' then
        local st = P:followup_complete_step(q.id)
        if st and q.id ~= Q16 then
            others[#others + 1] = { id = q.id, no = q.mission_no, sid = st.id, ki = st.followup_key_item }
        end
        -- 資料上の候補（followup_key_item がまだ無いもの）
        local route = P:chosen_route(q.id)
        for _, s in ipairs(q.steps or {}) do
            if progress.is_post_complete_followup(q, s, route) then
                local line = s.next_line_ja or ''
                if (line:find('渡す', 1, true) or line:find('渡して', 1, true))
                    and (line:find('だいじなもの', 1, true) or line:find('手紙', 1, true)
                        or #(s.needs or {}) > 0) then
                    if not (st and st.id == s.id) then
                        cand[#cand + 1] = { id = q.id, no = q.mission_no, sid = s.id, line = line }
                    end
                end
            end
        end
    end
end
local f = io.open(TMP .. '/defer_complete_missions.txt', 'w')
f:write(string.format('wired=%d candidates_unwired=%d\n', 1 + #others, #cand))
f:write(string.format('wired\t%s\tBM7-2\t%s\tウェライからの手紙\n', Q16, G05))
for _, row in ipairs(others) do
    f:write(string.format('wired\t%s\t%s\t%s\t%s\n', row.id, row.no or '', row.sid, row.ki or ''))
end
for _, row in ipairs(cand) do
    f:write(string.format('candidate\t%s\t%s\t%s\t%s\n', row.id, row.no or '', row.sid, row.line))
end
f:close()
eq(#others, 0, 'only BM7-2 is wired for deferred complete among missions')

local st7 = { nation = 1, rank = 8, main_job = 1, main_job_level = 75 }

-- 受注中に Karst へ報告：ゲームは完了、手紙を持っている → 進行中のまま、g05 が次
P:set_state(Q16, 'accepted')
local changed, before = P:apply_game(Q16, 'completed', have_ki(1))
check(changed, 'apply_game reports a change when deferring')
eq(before, 'accepted', 'was accepted')
eq(P:state(Q16), 'accepted', 'stays in progress while letter is held')
local r = P.doc.quests[Q16]
check(r.defer_complete == true, 'defer_complete flag set')
check(P:step_done(Q16, 'mission.bastok.016#g04'), 'Karst report is checked')
check(not P:step_done(Q16, G05), 'g05 not checked while letter held')
local cur = P:current_step(Q16)
check(cur and cur.id == G05, 'current step is Gumbah letter')
check(P._defer_notify and P._defer_notify[Q16], 'will notify when letter is gone')

-- BM8-1 は受けられない。理由は後日談（まだ 7-2 も完了していない）
local blocks = marks.accept_blocks(D, P, D:quest(Q17), st7, have_ki(1))
local kinds, reason = {}, nil
for _, b in ipairs(blocks) do
    kinds[#kinds + 1] = b.kind
    if b.kind == 'followup' then reason = marks.block_text(nil, b) end
end
check(#blocks > 0, 'BM8-1 blocked while letter held')
eq(reason, LETTER, 'followup reason while 7-2 is still in progress')
eq(marks.quest_icon(D, P, D:quest(Q17), { status = st7, have = have_ki(1) }), 'unavailable', 'BM8-1 icon')

-- 手紙を渡した：完了になり、お知らせ対象になる
local n, done = P:sync_followup_key_steps(have_ki(0))
check(n > 0, 'sync finalizes on letter gone')
eq(#done, 1, 'one deferred complete to announce')
eq(done[1], Q16, 'announces BM7-2')
eq(P:state(Q16), 'completed', 'now completed')
check(P:step_done(Q16, G05), 'g05 done after letter gone')
check(not (P.doc.quests[Q16].defer_complete), 'defer flag cleared')
eq(#(P.doc.quests[Q16].cycles or {}), 1, 'one completion cycle')

-- もう一度同期してもお知らせしない（ログイン・読み直し）
n, done = P:sync_followup_key_steps(have_ki(0))
eq(#done, 0, 'no second announce after already complete')
eq(P:state(Q16), 'completed', 'stays completed')

-- ゲームの完了を have なしで当てる（従来のテスト・手動に近い）は、待たせない
P:reset({ server = 'catseye', name = 'Defer2' })
P:set_state(Q16, 'accepted')
changed = P:apply_game(Q16, 'completed')
eq(P:state(Q16), 'completed', 'without have(), game complete is applied as before')

-- 移行：0.1.291 の保存（ゲーム完了・5/5・g05 チェック済み・current は g04・ピンなし）＋手紙を所持
local function done_n(prog, qid)
    local n = 0
    for _, st in ipairs(D:quest(qid).steps or {}) do
        if prog:step_done(qid, st.id) then n = n + 1 end
    end
    return n, #(D:quest(qid).steps or {})
end
P:reset({ server = 'catseye', name = 'Defer3' })
P:set_state(Q16, 'completed')
P:check_step(Q16, G05, true)
local r16 = P.doc.quests[Q16]
r16.state_source = 'game'
r16.current_step = 'mission.bastok.016#g04'
r16.pinned = false
r16.pin_order = nil
P:pin(Q17)
eq(P:state(Q16), 'completed', 'saved: BM7-2 completed')
local dn, dt = done_n(P, Q16)
eq(dn, dt, 'saved: all steps checked (5/5)')
check(P:step_done(Q16, G05), 'saved: g05 was auto-checked')
check(not P:is_pinned(Q16), 'saved: 7-2 was unpinned on complete')

-- 読み込み（所持はまだ未確認）：g05 は外すが、完了のまま。お知らせは出さない
P._defer_notify = {}
n, done = P:sync_followup_key_steps(nil)
check(not P:step_done(Q16, G05), 'load unknown: g05 unchecked')
eq(P:state(Q16), 'completed', 'load unknown: state stays completed until letter is known held')
eq(#done, 0, 'load unknown: no completion notice')

-- 手紙を持っていると分かった：進行中に戻す（4/5）、g05 を外し、次は Gumbah。お知らせは出さない
n, done = P:sync_followup_key_steps(have_ki(1))
eq(P:state(Q16), 'accepted', 'migrated to in progress while letter held')
check(P.doc.quests[Q16].defer_complete, 'defer flag after migrate')
check(not P.doc.quests[Q16].defer_complete_notified, 'not marked as already announced')
check(not P:step_done(Q16, G05), 'g05 stays unchecked')
dn, dt = done_n(P, Q16)
eq(dn, 4, '4 steps still done')
eq(dt, 5, '5 steps total')
cur = P:current_step(Q16)
check(cur and cur.id == G05, 'current step is Gumbah after migrate')
local line = select(1, P:next_line(Q16)) or ''
check(line:find('Gumbah', 1, true) and line:find('ウェライからの手紙', 1, true),
    'tracker next line is the Gumbah letter: ' .. line)
check(P:is_pinned(Q16), '7-2 is pinned again so the tracker shows Gumbah')
eq(#done, 0, 'migrate/revert does not fire a completion notice')
n, done = P:sync_followup_key_steps(have_ki(1))
eq(#done, 0, 'still no notice while the letter is held')
-- 渡したら、完了のお知らせを一度だけ出す
n, done = P:sync_followup_key_steps(have_ki(0))
eq(P:state(Q16), 'completed', 'completed after handing in, post-migrate')
eq(#done, 1, 'fire completion notice once when the letter is gone')
eq(done[1], Q16, 'notice is BM7-2')
n, done = P:sync_followup_key_steps(have_ki(0))
eq(#done, 0, 'do not fire the notice again')
eq(#(P.doc.quests[Q16].cycles or {}), 1, 'no extra cycle after migrate finalize')

-- ログイン：すでに手紙を渡して完了。have==0 で当ててもお知らせ対象にしない
P:reset({ server = 'catseye', name = 'Defer4' })
P:set_state(Q16, 'accepted')
P:apply_game(Q16, 'completed', have_ki(0))
eq(P:state(Q16), 'completed', 'letter already gone: complete immediately')
n, done = P:sync_followup_key_steps(have_ki(0))
eq(#done, 0, 'login/reload with already-complete does not announce')

-- 未確認のときは完了にしない（ゲーム完了の通信）
P:reset({ server = 'catseye', name = 'Defer5' })
P:set_state(Q16, 'accepted')
P:apply_game(Q16, 'completed', have_ki(nil))
eq(P:state(Q16), 'accepted', 'unknown possession: still deferred')
n, done = P:sync_followup_key_steps(have_ki(nil))
eq(P:state(Q16), 'accepted', 'unknown still deferred')
eq(#done, 0, 'unknown does not announce')
-- 所持が分かって手紙あり → お知らせ待ち
n, done = P:sync_followup_key_steps(have_ki(1))
eq(P:state(Q16), 'accepted', 'held: still in progress')
check(P._defer_notify[Q16], 'notify armed once letter is seen')
n, done = P:sync_followup_key_steps(have_ki(0))
eq(#done, 1, 'announce when letter disappears after being seen')
eq(P:state(Q16), 'completed', 'completed after seen-held then gone')

print('test_defer_complete_292 ok others=' .. #others .. ' candidates=' .. #cand)
