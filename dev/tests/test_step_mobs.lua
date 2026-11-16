-- 0.1.190（t321・t322）：手順の文に書いてある、落とすモンスター（名前）と種族に印を出す。
-- 0.1.191：デバッグONなら、完了していても選んだ「今」の手順に印を出す。
require('harness')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local marks = require('src.core.marks')

local D = data_mod.load(posix_fs(), ROOT .. '/data/')
eq(#D.errors, 0, 'data errors')
local P = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
P:reset({ server = 'catseye', name = 'Test' })

local Q = 'mission.bastok.003'
local S2, S3 = Q .. '#g02', Q .. '#g03'

-- 1) データ：「Amber・Brass・Greater・Old・Onyx・Veteran Quadav」は 6 つに広がる。落とさない 3 つは外す。種族は使わない（名前が書いてある）
local sm = D:step_mobs(S2)
check(sm ~= nil, 'BM1-3 step 2 has drop mobs')
local got = {}
for _, n in ipairs(sm.names) do got[#got + 1] = n.name; eq(n.zones[1], 143, 'zone of ' .. n.name); eq(#n.zones, 1, 'one zone ' .. n.name) end
eq(table.concat(got, ','), 'Amber Quadav,Brass Quadav,Greater Quadav,Old Quadav,Onyx Quadav,Veteran Quadav', 'expanded names')
eq(table.concat(sm.exclude, ','), 'Amethyst Quadav,Copper Quadav,Young Quadav', 'excluded names')
check(sm.families == nil, 'names win over the family')
check(D:step_mobs(S3) == nil, 'step 3 (trade) has none')
-- ほかの広げ方（前が同じ）
local w39 = D:step_mobs('quest.windurst.039#g04')
local n39 = {}
for _, n in ipairs(w39.names) do n39[#n39 + 1] = n.name end
eq(table.concat(n39, ','), 'Yagudo Mendicant,Yagudo Persecutor,Yagudo Piper', 'shared prefix expanded')
-- 「・」で切れた片割れ（Amber・Persecutor）は名前として残らない
for sid, e in pairs(D.step_mob_list) do
    for _, n in ipairs(e.names or {}) do
        check(n.name ~= 'Amber' and n.name ~= 'Persecutor', 'no bare fragment ' .. n.name)
    end
end

local ENTS = {
    { index = 1, name = 'Amber Quadav', kind = 'mob' },
    { index = 2, name = 'Veteran Quadav', kind = 'mob' },
    { index = 3, name = 'Young Quadav', kind = 'mob' },
    { index = 4, name = 'Amethyst Quadav', kind = 'mob' },
    { index = 5, name = 'Copper Quadav', kind = 'mob' },
    { index = 6, name = 'BeHya Hundredwall', kind = 'mob' },
    { index = 7, name = 'Cave Funguar', kind = 'mob' },
    { index = 8, name = 'Old Quadav', kind = 'mob', dead = true },
    { index = 9, name = 'Amber Quadav', kind = 'npc' },
    { index = 10, name = "Ni'Ghu Nestfender", kind = 'mob' },
}
local function marked(zone_id)
    local wanted = marks.in_zone(marks.wanted(D, P, { fame = false }), zone_id)
    local out = {}
    for _, row in ipairs(marks.match(wanted, ENTS, { zone_id = zone_id })) do
        if row.icon == 'hunt' then out[#out + 1] = row.entity.index end
    end
    table.sort(out)
    return table.concat(out, ',')
end

-- 2) 状態：完了・未受注では出ない。受注中で手順2が今の手順なら出る
P:set_state(Q, 'completed')
eq(marked(143), '', 'completed: no drop marks')
P.doc.quests[Q] = nil
eq(marked(143), '', 'not accepted: no drop marks')
P:apply_game(Q, 'accepted')
eq(P:current_step(Q).id, Q .. '#g01', 'step 1 first')
eq(marked(143), '', 'step 1: no drop marks')
P:check_step(Q, Q .. '#g01')
eq(P:current_step(Q).id, S2, 'step 2 now')
eq(marked(143), '1,2', 'step 2: the six drop names, alive mobs only, not the three excluded, not NPCs')
eq(marked(108), '', 'other zone: none')
-- ヒントの名前
local wl = marks.in_zone(marks.wanted(D, P, { fame = false }), 143)
local rows = marks.match(wl, ENTS, { zone_id = 143 })
for _, row in ipairs(rows) do
    if row.entity.index == 1 then eq(row.wanted[1].name, 'Amber Quadav', 'tip name'); eq(row.wanted[1].quest_id, Q, 'tip quest') end
end
P:check_step(Q, S2)
eq(marked(143), '', 'step 3: none')

-- 3) くり返し：完了で全部チェック→ゲームの記録でもう一度受けると、新しい回なのでチェックを外して手順1から
P:apply_game(Q, 'completed')
eq(P:current_step(Q), nil, 'all checked when completed')
P:apply_game(Q, 'accepted')
eq(P:current_step(Q).id, Q .. '#g01', 'repeat: back to step 1')
check(not P:step_done(Q, Q .. '#g01'), 'checks from the last round cleared')
eq(#P:record(Q).cycles, 1, 'completion history kept')
P.doc.quests[Q] = nil

-- 4) 種族：名前が書いていない手順は、そのゾーンのその種族を全部（NM も）。ほかの種族・NPC・死んでいるのは出ない
local MK = 'mission.mkd.002'
local fm = D:step_mobs(MK .. '#g02')
check(fm and fm.families and not fm.names, 'family step')
local fams = {}
for _, f in ipairs(fm.families) do fams[#fams + 1] = f.family .. '@' .. table.concat(f.zones, '/') end
eq(table.concat(fams, ','), 'quadav@143,goblin@191', 'families with their zones (ゾーン名の「の」も読む)')
check(D:mob_in_family('quadav', 143, 'BeHya Hundredwall'), 'NM of the family')
check(D:mob_in_family('quadav', 143, "Ni'Ghu Nestfender"), "' is ignored")
check(not D:mob_in_family('quadav', 143, 'Cave Funguar'), 'other family')
check(not D:mob_in_family('quadav', 100, 'Amber Quadav'), 'zone without that name')
P:apply_game(MK, 'accepted')
P:check_step(MK, MK .. '#g01')
eq(P:current_step(MK).id, MK .. '#g02', 'mkd step 2')
eq(marked(143), '1,2,3,4,5,6,10', 'family: every live quadav mob in the zone')
eq(marked(191), '', 'goblin zone: no quadav marked')
P.doc.quests[MK] = nil

-- 5) 「〜は落とさない」は種族より強い。名前があれば種族は使わない
local fake_step = { id = 'x#1' }
local fake_q = { id = 'x' }
local function list_for(entry, zone_id)
    D.step_mob_list['x#1'] = entry
    local out = {}
    marks.add_step_mobs(D, fake_q, fake_step, function (w) out[#out + 1] = w end)
    D.step_mob_list['x#1'] = nil
    local idx = {}
    for _, row in ipairs(marks.match(marks.in_zone(out, zone_id), ENTS, { zone_id = zone_id })) do idx[#idx + 1] = row.entity.index end
    table.sort(idx)
    return table.concat(idx, ',')
end
eq(list_for({ families = { { family = 'quadav', zones = {} } }, exclude = { 'Young Quadav', 'Amethyst Quadav', 'Copper Quadav' } }, 143),
    '1,2,6,10', 'exclusions override the family')
eq(list_for({ families = { { family = 'quadav', zones = {} } } }, 143), '1,2,3,4,5,6,10', 'no zone: the current zone')
eq(list_for({ names = { { name = 'Amber Quadav', zones = { 143 } } }, families = { { family = 'quadav', zones = {} } } }, 143),
    '1', 'names win over the family')
eq(list_for({ names = { { name = 'amber quadav', zones = {} } } }, 143), '1', 'name match ignores case')

-- 6) デバッグONなら、完了していても選んだ「今」の手順に印が出る（0.1.191〜）。オフなら出ない（受注中の今の手順だけ）
P.doc.quests[Q] = nil
P:apply_game(Q, 'completed')
eq(P:current_step(Q), nil, 'completed with no 今: no current step')
eq(marked(143), '', 'completed, no 今: no marks even before debug')
check(P:decide_step(Q, S2).ok, 'choose step 2 as 今 while completed')
check(P:step_done(Q, Q .. '#g01') and P:step_done(Q, S2) and P:step_done(Q, S3), 'checks stay when choosing 今')
eq(marked(143), '', 'debug off: completed still has no drop marks')
local function marked_dbg(zone_id)
    local wanted = marks.in_zone(marks.wanted(D, P, { fame = false, debug = true }), zone_id)
    local out = {}
    for _, row in ipairs(marks.match(wanted, ENTS, { zone_id = zone_id })) do
        if row.icon == 'hunt' then out[#out + 1] = row.entity.index end
    end
    table.sort(out)
    return table.concat(out, ',')
end
eq(marked_dbg(143), '1,2', 'debug on, completed, 今 is step 2: same drop marks as accepted')
eq(marked_dbg(108), '', 'debug on, other zone: none')
-- デバッグONでも、今の手順を選んでいなければ出ない
P.doc.quests[Q].current_step = nil
eq(marked_dbg(143), '', 'debug on, completed, no 今 chosen: no drop marks')
-- 受注中はデバッグの有無に関係なく、今までどおり出る
P.doc.quests[Q] = nil
P:apply_game(Q, 'accepted')
P:check_step(Q, Q .. '#g01')
eq(P:current_step(Q).id, S2, 'accepted step 2')
eq(marked(143), '1,2', 'accepted: marks without debug')
eq(marked_dbg(143), '1,2', 'accepted: marks with debug too')
