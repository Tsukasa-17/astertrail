-- 0.1.291：国ミッションの前提は本の完了を見る。名前の参照が解けないものを列挙する
require('harness')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local marks = require('src.core.marks')

local fs = posix_fs()
local D = data_mod.load(fs, ROOT .. '/data/')
eq(#D.errors, 0, 'data errors')
local P = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
P:reset({ server = 'catseye', name = 'Test' })

local q16 = D:quest('mission.bastok.016')
local q17 = D:quest('mission.bastok.017')
check(q16 and q16.mission_no == 'BM7-2' and q16.name_ja_ref == 'それぞれの行方', 'BM7-2 data')
check(q17 and q17.mission_no == 'BM8-1' and q17.name_ja_ref == '流砂の鎖', 'BM8-1 data')

-- 名前は mission.bastok.016 に解ける（別 id や表記ゆれではない）
local ids = marks.prereq_ids(D, q17)
eq(#ids, 1, 'BM8-1 has one prereq group')
eq(ids[1][1], 'mission.bastok.016', '「それぞれの行方」 resolves to BM7-2')
eq(#ids[1], 1, 'only one id named それぞれの行方')

eq(marks.granted_nation_rank(D, q16), 8, 'completing BM7-2 grants rank 8')
eq(marks.granted_nation_rank(D, D:quest('mission.bastok.015')), 7, 'completing BM7-1 (not last) stays rank 7')
eq(marks.granted_nation_rank(D, D:quest('mission.bastok.010')), 5, 'completing BM4-1 (only 4-x) grants rank 5')
eq(marks.granted_nation_rank(D, D:quest('mission.bastok.003')), 2, 'completing BM1-3 grants rank 2')

eq(P:state('mission.bastok.016'), 'not_accepted', 'start: BM7-2 not done')
eq(marks.progress_nation_rank(D, P, 'bastok'), 0, 'no completed bastok missions: inferred 0')

-- ゲームの rank が 7 のままだと、本の完了を見ない旧判定では BM8-1 を止めてしまう
local st7 = { nation = 1, rank = 7, main_job = 1, main_job_level = 75 }
check(marks.reqs_unmet(q17, st7), 'without progress, live rank 7 still blocks BM8-1')
check(marks.prereq_unmet(D, P, q17), 'prereq unmet while BM7-2 is not completed')
check(marks.quest_icon(D, P, q17, { status = st7 }) == 'unavailable', 'icon unavailable before complete')

P:set_state('mission.bastok.016', 'completed')
eq(P:state('mission.bastok.016'), 'completed', 'book state of BM7-2 is completed')
eq(marks.progress_nation_rank(D, P, 'bastok'), 8, 'inferred nation rank is 8 after BM7-2')
check(not marks.prereq_unmet(D, P, q17), 'prereq_unmet sees BM7-2 completed')
-- 本の完了があれば、ゲームの rank が古くても、所属国の読み違いでも止めない
check(not marks.reqs_unmet(q17, st7, D, P), 'reqs_unmet uses book rank 8, not stale live rank 7')
check(not marks.reqs_unmet(q17, { nation = 0, rank = 7, main_job = 1, main_job_level = 75 }, D, P),
    'completed Bastok missions override a misread nation')
-- 完了しても g05（手紙）は自動ではチェックしない
check(P:step_done('mission.bastok.016', 'mission.bastok.016#g04'), 'Karst report auto-checked on complete')
check(not P:step_done('mission.bastok.016', 'mission.bastok.016#g05'), 'Gumbah letter is not auto-checked')

local LETTER = 'BM7-2の後日談：バストゥーク鉱山区(J-7)のGumbahに「ウェライからの手紙」を渡す'
local function have_ki(v)
    return function (id, n)
        local kid = tonumber((type(n) == 'table' and n.key_item_id) or id)
        if kid == 290 then return v end
        return nil
    end
end

-- 所持が未確認／手紙を持っている間は、BM8-1 を受けられない。理由は後日談であり、前提の文ではない
local function followup_reason(blocks)
    for _, b in ipairs(blocks) do
        if b.kind == 'followup' then return marks.block_text(nil, b) end
    end
end
local function kinds(blocks)
    local s = {}
    for _, b in ipairs(blocks) do s[#s + 1] = b.kind end
    return table.concat(s, ',')
end

local ref = D:lookup_item_name('ウェライからの手紙')
check(ref and ref.kind == 'key_item' and ref.key_item_id == 290, 'Letter from Werei is key item 290')
local g05 = D:step('mission.bastok.016#g05')
check(g05 and g05.followup_key_item_id == 290, 'g05 has followup key item id 290')
check(q17.followup_requires and q17.followup_requires.step == 'mission.bastok.016#g05', 'BM8-1 followup_requires g05')
check((g05.text_ja or ''):find('蝕世のエンブリオ', 1, true) ~= nil, 'g05 note mentions 蝕世のエンブリオ')

local pending_haves = { false, have_ki(nil), have_ki(1) }  -- false = have 関数なし（未確認）
for i = 1, #pending_haves do
    local have = pending_haves[i]
    if have == false then have = nil end
    local blocks = marks.accept_blocks(D, P, q17, st7, have)
    eq(followup_reason(blocks), LETTER, 'followup reason when letter held or unknown #' .. tostring(i))
    check(not kinds(blocks):find('prereq', 1, true), 'do not show prereq text when 7-2 is complete: ' .. kinds(blocks))
    check(not kinds(blocks):find('rank', 1, true), 'rank inference still allows BM8-1: ' .. kinds(blocks))
    eq(marks.quest_icon(D, P, q17, { status = st7, have = have }), 'unavailable', 'icon unavailable while letter pending #' .. tostring(i))
end

-- 手紙を渡した（持っていない）ら g05 済み、BM8-1 を受けられる
eq(P:sync_followup_key_steps(have_ki(0)), 1, 'sync marks g05 done when letter is gone')
check(P:step_done('mission.bastok.016', 'mission.bastok.016#g05'), 'g05 done after letter is gone')
local blocks0 = marks.accept_blocks(D, P, q17, st7, have_ki(0))
eq(#blocks0, 0, 'no accept blocks after letter delivered')
local icon = marks.quest_icon(D, P, q17, { status = st7, have = have_ki(0) })
check(icon ~= 'unavailable', 'BM8-1 icon is not unavailable after letter: ' .. tostring(icon))
check(icon == 'main' or icon == 'sub', 'available BM8-1 is main or sub, got ' .. tostring(icon))

-- まだ渡していない状態に戻し、所持 1 なら自動チェックを外す
P:check_step('mission.bastok.016', 'mission.bastok.016#g05', true)
check((P:sync_followup_key_steps(have_ki(1)) or 0) >= 1, 'sync unchecks g05 while letter is held')
check(not P:step_done('mission.bastok.016', 'mission.bastok.016#g05'), 'g05 not done while letter held')

-- ランクだけが足りないときは、前提の文ではなくランク不足と出す
P:set_state('mission.bastok.016', 'not_accepted')
-- BM7-2 を戻したので、前提とランク（推定なし・ライブ 7）の両方が止まる
local blocks_rank = marks.accept_blocks(D, P, q17, st7, have_ki(0))
check(kinds(blocks_rank):find('prereq', 1, true) ~= nil, 'prereq listed when 7-2 is not done')
check(kinds(blocks_rank):find('rank', 1, true) ~= nil, 'rank listed when live rank 7 and no book inference')
local rank_text = marks.block_text(nil, { kind = 'rank', need = 8, have = 7 })
check(rank_text:find('所属国ランク', 1, true) and rank_text:find('8', 1, true), 'rank reason text')

-- 前の段が終わっていなければ、これまでどおりランク不足で止める
P:set_state('mission.bastok.016', 'not_accepted')
check(marks.reqs_unmet(q17, st7, D, P), 'without BM7-2 complete, live rank 7 still blocks')

-- サンドリア／ウィンダスも同じ（最後の段を終えると次のランク）
eq(marks.granted_nation_rank(D, D:quest('mission.sandoria.016')), 8, 'SM7-2 grants 8')
eq(marks.granted_nation_rank(D, D:quest('mission.windurst.016')), 8, 'WM7-2 grants 8')

-- --- すべてのクエスト・ミッションの前提名を解く ---
local NATION = { sandoria = true, bastok = true, windurst = true }
local DONE = { 'クリア', '終了', '完了', 'コンプリート', 'を終え', '終え', '済み', '達成', 'のあと',
    'をすべて終え', 'をクリア', 'まで終え' }
local function looks_done(text)
    for _, w in ipairs(DONE) do
        if text:find(w, 1, true) then return true end
    end
    return false
end
local function quoted(text)
    local out, pos = {}, 1
    while true do
        local a, b, name = text:find('「(.-)」', pos)
        if not a then break end
        out[#out + 1] = name
        pos = b + 1
    end
    return out
end
local function name_in_groups(groups, name)
    local key = marks.prereq_name_key(name)
    for _, g in ipairs(groups) do
        for _, id in ipairs(g) do
            local pq = D:quest(id)
            if pq and marks.prereq_name_key(pq.name_ja_ref or '') == key then return id end
        end
    end
end

local chain_miss, other_miss, resolved = {}, {}, 0
for _, q in ipairs(D.quests) do
    local groups = marks.prereq_ids(D, q)
    for _, r in ipairs(q.lock_reasons or {}) do
        local text = r.text_ja or ''
        if looks_done(text) then
            for _, name in ipairs(quoted(text)) do
                local id = name_in_groups(groups, name)
                if id then
                    resolved = resolved + 1
                else
                    local row = { qid = q.id, no = q.mission_no or q.kind, name = name, text = text }
                    -- 国ミッションの「名前」終了／クリアは、必ず資料の id に解けなければならない
                    if q.kind == 'mission' and NATION[q.category or ''] and (
                        text:find(name .. '」終了', 1, true) or text:find(name .. '」クリア', 1, true)
                        or text:find(name .. '」完了', 1, true) or text:find(name .. '」コンプリート', 1, true)
                    ) then
                        chain_miss[#chain_miss + 1] = row
                    else
                        other_miss[#other_miss + 1] = row
                    end
                end
            end
        end
    end
end
eq(#chain_miss, 0, 'every nation-mission completion prereq resolves to a data id')
check(resolved >= 20, 'resolved some prereq names: ' .. tostring(resolved))

-- 解けなかった参照は列挙する（名声の呼び名・だいじなもの・節の別名など。国チェーンではない）
local f = io.open(TMP .. '/prereq_unresolved.txt', 'w')
f:write(string.format('resolved=%d unresolved=%d (not nation-mission chains)\n', resolved, #other_miss))
for _, row in ipairs(other_miss) do
    f:write(string.format('%s\t%s\t%s\t%s\n', row.qid, row.no, row.name, row.text))
end
f:close()
-- 件数は資料の変化で動きうるので、異常な増加だけ見る
check(#other_miss <= 120, 'unresolved non-chain refs stay in a known range: ' .. tostring(#other_miss))

-- 「して完了」よりあとの後日談（同じルート／共通。自分も「して完了」なら別ルートの完了なので数えない）
local followups, fu_file = {}, io.open(TMP .. '/post_complete_followups.txt', 'w')
for _, q in ipairs(D.quests) do
    local route = nil
    -- ルート無し＝共通＋全手順の走査。各ルートでも見る
    local routes = { false }  -- false = ルート指定なし（共通の手順だけで見る）
    if P.routes then
        for _, r in ipairs(P:routes(q.id) or {}) do routes[#routes + 1] = r end
    end
    local seen = {}
    for _, route in ipairs(routes) do
        if route == false then route = nil end
        for _, st in ipairs(q.steps or {}) do
            if progress.is_post_complete_followup(q, st, route) and not seen[st.id] then
                seen[st.id] = true
                followups[#followups + 1] = {
                    qid = q.id, no = q.mission_no or q.kind, sid = st.id,
                    line = st.next_line_ja or '', note = st.text_ja or '',
                }
            end
        end
    end
end
fu_file:write(string.format('post-complete followup steps: %d\n', #followups))
for _, row in ipairs(followups) do
    fu_file:write(string.format('%s\t%s\t%s\t%s\t%s\n', row.qid, row.no, row.sid, row.line, row.note))
end
fu_file:close()
check(#followups >= 1, 'found post-complete followups including BM7-2 g05')
local has_g05 = false
for _, row in ipairs(followups) do
    if row.sid == 'mission.bastok.016#g05' then has_g05 = true; break end
end
check(has_g05, 'BM7-2 g05 is classified as a post-complete followup')

-- サンプル：明示の後日談は自動チェックしない。分岐の「して完了」は付ける
local q_ab = D:quest('quest.abyssea.129')
if q_ab then
    P:set_state('quest.abyssea.129', 'completed')
    local any_fu, any_complete = false, false
    for _, st in ipairs(q_ab.steps or {}) do
        if progress.is_post_complete_followup(q_ab, st, P:chosen_route('quest.abyssea.129')) then
            any_fu = true
            check(not P:step_done('quest.abyssea.129', st.id), 'abyssea followup not auto-checked: ' .. st.id)
        elseif progress.is_complete_line(st) then
            any_complete = true
        end
    end
    check(any_fu, 'quest.abyssea.129 has a post-complete followup')
end

print('test_prereq_291 ok resolved=' .. resolved .. ' other_unresolved=' .. #other_miss
    .. ' followups=' .. #followups)
