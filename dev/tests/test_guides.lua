-- 書き直した手順（guides/steps_v2.json）：新しい手順だけを使い、古い id → 新しい id の対応表（guides/step_map.json）で
-- 保存済みの進み具合を引き継ぐ。0.1.54 から古い下書きはゲーム用データに持たず、代わりに表示もしない。
require('harness')
local json = require('src.lib.json')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')

local D = data_mod.load(posix_fs(), ROOT .. '/data/')
eq(#D.errors, 0, 'data errors: ' .. json.encode(D.errors, true))
for _, w in ipairs(D.warnings) do check(not w:find('guides'), 'guide warning: ' .. w) end

local n_guides = 0
for _, q in ipairs(D.quests) do
    if q.guide then
        n_guides = n_guides + 1
        eq(q.steps_draft, nil, 'no draft kept in memory ' .. q.id)
        for _, s in ipairs(q.steps) do
            check(s.id:find('#g'), 'new id ' .. s.id)
            eq(D:quest_of_step(s.id), q, 'step quest ' .. s.id)
            check(s.next_line_ja and s.next_line_ja ~= '', 'line ' .. s.id)
            check(not s.next_line_ja:find('→'), 'one action per step (no arrows) ' .. s.id)
            for _, n in ipairs(s.next) do check(D:step(n), 'next ' .. n) end
            if s.target then check(D:target(s.target), 'target ' .. s.target) end
        end
    end
end
eq(n_guides, 1829, 'all guides')

-- 対応表：古い id 1168件。どれも新しい手順（同じクエスト）に当たり、古い id は手順として出てこない
local map_doc = json.decode(io.open(ROOT .. '/data/guides/step_map.json'):read('*a'))
eq(map_doc.data_kind, 'step_map', 'map kind')
local n_old = 0
for old, news in pairs(map_doc.map) do
    n_old = n_old + 1
    check(D:is_draft_step(old), 'old id known ' .. old)
    eq(D.step_alias[old], news[1], 'alias ' .. old)
    eq(D:step(old), nil, 'old id not active ' .. old)
    -- 0.1.217〜：まとめて消した新しい手順（BM7-1 の g03 → g02）も対応表に入る
    local qid = old:match('^(.-)#s%d+$') or (old == 'mission.bastok.015#g03' and 'mission.bastok.015') or nil
    check(qid, 'old id form ' .. old)
    for _, n in ipairs(news) do
        check(D:step(n), 'new step ' .. n)
        eq(D:quest_of_step(n).id, qid, 'same quest ' .. n)
    end
end
eq(n_old, 1169, 'all old ids mapped (1168 drafts + 1 merged step)')
-- 対応表に文は入れない（id と一覧だけ）
for k, v in pairs(map_doc) do check(k ~= 'steps' and k ~= 'quests', 'no text in map: ' .. k) end

-- ゲーム用データ：下書きの文は持たない（0.1.56 から全件。初版の18件はシートの「手順下書き（アドオン版）」列に写した）
local kept_draft = {}
for _, rel in ipairs({ 'quests/bastok', 'quests/sandoria', 'quests/windurst', 'missions/bastok', 'missions/sandoria', 'missions/windurst' }) do
    local doc = json.decode(io.open(ROOT .. '/data/' .. rel .. '.json'):read('*a'))
    for _, q in ipairs(doc.quests) do
        if q.steps and #q.steps > 0 then kept_draft[#kept_draft + 1] = q.id end
    end
end
eq(#kept_draft, 0, 'no drafts kept in files: ' .. table.concat(kept_draft, ','))
-- 初版の18件も古い id の対応は残る
for _, qid in ipairs({ 'mission.bastok.001', 'mission.sandoria.001', 'mission.sandoria.002', 'mission.windurst.001',
        'quest.bastok.001', 'quest.bastok.006', 'quest.sandoria.004', 'quest.windurst.004' }) do
    check(map_doc.map[qid .. '#s01'], 'map kept ' .. qid)
    check(D.step_alias[qid .. '#s01'], 'alias kept ' .. qid)
end

-- 書き直しの無いクエストは下書きを出さず、手順なし（代替表示なし）
do
    local fake_fs = posix_fs()
    local real_read = fake_fs.read
    fake_fs.read = function (path)
        local t, w = real_read(path)
        if t and path:find('manifest.json', 1, true) then
            t = t:gsub('"guides/steps_v2.json",?', '')
        end
        return t, w
    end
    local D2 = data_mod.load(fake_fs, ROOT .. '/data/')
    local q1 = D2:quest('quest.sandoria.001')
    eq(q1.guide, nil, 'no guide loaded')
    eq(#q1.steps, 0, 'no draft fallback')
    eq(D2:step('quest.sandoria.001#s01'), nil, 'draft step not shown')
end

-- 0.1.52：全部のミッション・クエストに書き直しがある
local plain = D:quest('quest.sandoria.001')
check(plain and plain.guide and plain.steps[1].id == 'quest.sandoria.001#g01', 'guide used')

-- 魔晶石を奪え：8手順 → 21手順
local mq = D:quest('mission.sandoria.010')
local n_magicite_old = 0
for old in pairs(map_doc.map) do if old:find('mission.sandoria.010#s', 1, true) == 1 then n_magicite_old = n_magicite_old + 1 end end
eq(n_magicite_old, 8, 'magicite old ids'); eq(#mq.steps, 21, 'magicite new')
eq(mq.steps[1].target, 'npc.243.Nelcabrit', 'first target')

-- 分岐：他国を回れは最初の手順で2つのルート
local ja = D:quest('mission.sandoria.006')
eq(#ja.steps[1].next, 2, 'two routes')

-- 進み具合の引き継ぎ
local who = { server = 'catseye', name = 'Test' }
local P = progress.new({ data = D })
local ok = P:adopt({
    progress_schema = 1, character = who,
    quests = {
        ['mission.sandoria.010'] = {
            state = 'accepted', current_step = 'mission.sandoria.010#s05',
            steps = {
                ['mission.sandoria.010#s01'] = { done = true, source = 'manual', at = '2026-11-01T10:00:00' },
                ['mission.sandoria.010#s02'] = { done = true, source = 'manual', at = '2026-11-02T10:00:00' },
                ['mission.sandoria.010#s03'] = { done = true, source = 'manual', at = '2026-11-03T10:00:00' },
                ['mission.sandoria.010#s04'] = { done = true, source = 'manual', at = '2026-11-04T10:00:00' },
            },
            cycles = {},
        },
        ['quest.sandoria.001'] = {
            state = 'accepted', steps = { ['quest.sandoria.001#s01'] = { done = true, source = 'manual' } }, cycles = {},
        },
    },
    last_focus = { quest = 'mission.sandoria.010', step = 'mission.sandoria.010#s05' },
}, who)
check(ok, 'adopt')
eq(P.migrated_guides, 2, 'two quests migrated')  -- 0.1.52: quest.sandoria.001 にも書き直しがある
for i = 1, 7 do
    check(P:step_done('mission.sandoria.010', string.format('mission.sandoria.010#g%02d', i)), 'migrated done g' .. i)
end
check(not P:step_done('mission.sandoria.010', 'mission.sandoria.010#g08'), 'g08 not done')
local cur = P:current_step('mission.sandoria.010')
eq(cur.id, 'mission.sandoria.010#g08', 'current mapped to first new step of s05')
local rec = P:record('mission.sandoria.010')
check(rec.steps_draft['mission.sandoria.010#s04'], 'draft record kept')
eq(rec.steps['mission.sandoria.010#g07'].source, 'migrated', 'source migrated')
eq(P.doc.last_focus.step, 'mission.sandoria.010#g08', 'last focus mapped')
-- quest.sandoria.001 も書き直し済み（0.1.52）：s01 の記録は g01 に引き継ぐ
check(P:step_done('quest.sandoria.001', 'quest.sandoria.001#g01'), 'sandoria.001 migrated')
-- もう一度読み込んでも変わらない（2回目は何もしない）
local snap = json.decode(json.encode(P:snapshot()))
local P2 = progress.new({ data = D })
check(P2:adopt(snap, who), 'adopt again')
eq(P2.migrated_guides, 0, 'idempotent')
check(P2:step_done('mission.sandoria.010', 'mission.sandoria.010#g07'), 'still done')

-- ルート（星読み：1回目の2コースに共通の手順と、2回目以降）
do
    local P3 = progress.new({ data = D })
    P3:reset(who)
    local SR = 'mission.windurst.008'
    eq(#P3:routes(SR), 3, 'star reading routes')
    P3:check_step(SR, SR .. '#g01', true)
    eq(P3:chosen_route(SR), nil, 'no route yet')
    check(not P3:all_steps_done(SR), 'not done before choosing')
    P3:check_step(SR, SR .. '#gc01', true)
    eq(P3:chosen_route(SR), '2回目以降', 'route from checked step')
    check(not progress.step_in_route(D:step(SR .. '#g02'), '2回目以降'), 'gate of light not in 2nd route')
    check(progress.step_in_route(D:step(SR .. '#g02'), '1回目・水呼びの扉'), 'shared step in both 1st routes')
    eq(P3:current_step(SR).id, SR .. '#gc02', 'current within route')
    P3:check_step(SR, SR .. '#gc02', true)
    check(P3:all_steps_done(SR), 'route complete')
    check(P3:set_route(SR, '1回目・魔封門').ok, 'switch')
    eq(P3:chosen_route(SR), '1回目・魔封門', 'switched')
    check(not P3:set_route(SR, 'nope').ok, 'unknown route refused')
end
