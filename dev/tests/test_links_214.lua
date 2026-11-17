-- 0.1.214：場所の無かった手順に相手と場所をつないだ（Aldo・監視哨の NPC・BF の入口・何人もの相手・Waypoint の候補）と、
-- 文から拾えない討伐の相手（名前・種族）。LSB の名前の後ろの言葉（past・war など）を外したこと。
require('harness')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local marks = require('src.core.marks')
local maps = require('src.core.maps')

local D = data_mod.load(posix_fs(), ROOT .. '/data/')
eq(#D.errors, 0, 'data errors')
for _, w in ipairs(D.warnings) do check(not w:find('対象', 1, true), 'no missing target: ' .. w) end
local P = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
P:reset({ server = 'catseye', name = 'Test' })

local function go(sid)
    local q = D:quest_of_step(sid)
    local qid = q and q.id or sid:match('^(.-)#')
    P:apply_game(qid, 'accepted')
    for _ = 1, 40 do
        local cur = P:current_step(qid)
        if not cur or cur.id == sid then break end
        P:check_step(qid, cur.id)
    end
    eq(P:current_step(qid).id, sid, 'now at ' .. sid)
    return qid
end
local function marked(zone_id, ents, role)
    local wanted = marks.in_zone(marks.wanted(D, P, { fame = false }), zone_id)
    local out = {}
    for _, row in ipairs(marks.match(wanted, ents, { zone_id = zone_id })) do
        for _, w in ipairs(row.wanted) do
            if (role == nil or w.role == role) and w.quest_id then out[#out + 1] = row.entity.index; break end
        end
    end
    table.sort(out)
    return table.concat(out, ',')
end

-- 1) Aldo（用語辞典の「アルド」）：ジュノ下層 J-8 の Aldo につないだ
do
    local s = D:step('mission.sandoria.010#g04')
    eq(s.target, 'npc.245.Aldo', 'Aldo linked')
    eq(s.location.grid, 'J-8', 'Aldo grid on the step')
    eq(D:target(s.target).name_en, 'Aldo', 'English name')
    go('mission.sandoria.010#g04')
    local ents = { { index = 1, name = 'Aldo', kind = 'npc' }, { index = 2, name = 'Raibaht', kind = 'npc' } }
    eq(marked(245, ents, 'talk'), '1', 'Aldo gets the talk mark')
    P:set_state('mission.sandoria.010', 'completed')
end

-- 2) 分類2のマス目：監視哨の Nareema（K-9、MAP1）・Shanruru（G-5、座標つき）
do
    local s = D:step('quest.aht_urhgan.058#g02')
    eq(s.target, 'npc.79.Nareema', 'Nareema linked to the existing target')
    eq(s.location.zone_id, 79, 'Caedarva Mire')
    eq(s.location.grid, 'K-9', 'K-9')
    eq(s.location.map.kind, 'number', 'map number')
    eq(s.location.map.n, 1, 'MAP1')
    local d = D:step('quest.aht_urhgan.058#g04')
    eq(d.location.grid, 'H-11', 'Daswil: BG Wiki grid')
    eq(d.location.pos, nil, 'Daswil: no LSB position (it converts to another cell)')
    local sh = D:step('mission.tvr.008#g03')
    eq(sh.target, 'npc.240.Shanruru', 'Shanruru')
    eq(sh.location.grid, 'G-5', 'G-5')
    check(sh.location.pos ~= nil, 'position from the source')
    local f = maps.floor(D, 240, 1) or (maps.floors(D, 240) or {})[1]
    local pin = maps.pin(f, sh.location, maps.BASE)
    eq(pin and pin.kind, 'pos', 'pin from the position')
    eq(pin and pin.grid, 'G-5', 'the position is in G-5')
    -- 出典は手順に残る（画面には出さない）
    local srcs = {}
    for _, x in ipairs(sh.extra_sources or {}) do srcs[#srcs + 1] = x.name end
    check(table.concat(srcs, ','):find('LSB', 1, true) ~= nil, 'source kept in extra_sources')
    -- モグガーデン：地図が無いので相手だけ
    eq(D:step('quest.misc.027#g01').target, 'npc.280.Green_Thumb_Moogle', 'Green Thumb Moogle linked')
    eq(D:step('quest.misc.036#g02').target, 'npc.280.Chacharoon', 'Chacharoon linked')
    -- 番号が分からない ??? は入れない
    eq(D:step('quest.misc.006#g03').target, nil, 'Walk of Echoes ??? left for MCP')
    eq(D:step('quest.jeuno.028#g04').target, nil, 'inner door of Neptune\'s Spire left')
end

-- 3) 何人もの相手（Hat in Hand の8人）：みんなに話す印
do
    local s = D:step('quest.windurst.035#g03')
    eq(#(s.extra_targets or {}), 7, 'seven more NPCs')
    go('quest.windurst.035#g03')
    local names = { 'Honoi-Gomoi', 'Kenapa-Keppa', 'Bondada', 'Kyume-Romeh', 'Tosuka-Porika', 'Clais', 'Pechiru-Mashiru', 'Machitata', 'Someone Else' }
    local ents = {}
    for i, n in ipairs(names) do ents[i] = { index = i, name = n, kind = 'npc' } end
    eq(marked(238, ents, 'talk'), '1,2,3,4,5,6,7,8', 'all eight NPCs, nobody else')
    P:set_state('quest.windurst.035', 'completed')
    -- Stone Monument：ゾーンごとに1つ
    local m = D:step('quest.selbina_mhaura.001#g02')
    eq(1 + #(m.extra_targets or {}), 17, 'seventeen Stone Monuments')
    eq(D:target('obj.102.Stone_Monument').location.grid, 'J-7', 'La Theine J-7 from the text')
end

-- 4) Waypoint（西アドゥリン）：9か所を候補の丸で
do
    local s = D:step('quest.adoulin.043#g02')
    eq(s.target, 'obj.256.Waypoint', 'Waypoint')
    local c = marks.candidates_for(D, s)
    eq(c and #c, 9, 'nine candidates')
    local grids = {}
    for _, x in ipairs(c or {}) do grids[#grids + 1] = x.grid end
    table.sort(grids)
    eq(table.concat(grids, ' '), 'E-8 F-10 G-10 H-11 H-4 H-8 I-5 J-9 L-9', 'the grids in the text')
    eq(marks.candidates_for(D, D:step('quest.adoulin.056#g02')), nil, 'East Adoulin: sources differ, no candidates')
end

-- 5) BF の入口：アサルトの戦いの手順は Runic Seal（カダーバの浮沼 K-9）。印は「調べる」（討伐ではない）
do
    local s = D:step('mission.assault.001#g06')
    eq(s.entrance, true, 'entrance step')
    eq(s.target, 'obj.79.Runic_Seal', 'Runic Seal')
    eq(s.location.zone_id, 79, 'entrance zone')
    eq(s.location.grid, 'K-9', 'entrance grid')
    go('mission.assault.001#g06')
    local ents = { { index = 1, name = 'Runic Seal', kind = 'obj' } }
    eq(marked(79, ents, 'examine'), '1', 'Runic Seal gets the examine mark')
    eq(marked(79, ents, 'hunt'), '', 'not a hunt mark')
    P:set_state('mission.assault.001', 'completed')
    eq(D:step('mission.adoulin.094#g03').target, 'obj.270.Wavering_Flux', 'Wavering Flux entrance')
    eq(D:step('mission.rov.057#g04').target, nil, 'no grid for the entrance: left')
end

-- 6) 討伐：名前（Seed Mandragora）と、新しい種族（エフト族）と、LSB の後ろの言葉を外した名前
do
    local sm = D:step_mobs('mission.acp.005#g02')
    eq(sm and sm.names[1].name, 'Seed Mandragora', 'Seed Mandragora')
    eq(sm and sm.names[1].zones[1], 126, 'Qufim')
    go('mission.acp.005#g02')
    local ents = { { index = 1, name = 'Seed Mandragora', kind = 'mob' }, { index = 2, name = 'Seed Mandragora', kind = 'mob', dead = true },
                   { index = 3, name = 'Seed Crab', kind = 'mob' } }
    eq(marked(126, ents, 'hunt'), '1', 'alive Seed Mandragora only')
    P:set_state('mission.acp.005', 'completed')
    local ef = D:step_mobs('quest.adoulin.141#g02')
    eq(ef and ef.families[1].family, 'eft', 'eft family')
    eq(ef and ef.families[1].zones[1], 272, 'Dho Gates')
    local any = false
    for k in pairs(D.mob_families.eft[272] or {}) do any = true end
    check(any, 'eft names in Dho Gates')
    -- 「Copper Quadav past」（LSB）→ Copper Quadav（ゲームの名前）
    check(D:mob_in_family('quadav', 89, 'Copper Quadav'), 'past-zone name without the LSB tail')
    check(not D:mob_in_family('quadav', 89, 'Copper Quadav past'), 'the LSB tail is not a game name')
    local cq = D:step_mobs('quest.altana.100#g04')
    eq(cq and table.concat(cq.names[1].zones, ','), '88,89', 'Copper Quadav in the two [S] zones of the text')
    eq(D:step_mobs('mission.windurst.008#gc01').names[1].name, 'Wendigo', 'Wendigo (LSB: Wendigo blm / war)')
    -- 種族の全部ではないもの・一覧が作れないものは入れない
    eq(D:step_mobs('quest.bastok.013#g02'), nil, 'puppetmaster trolls only: left')
    eq(D:step_mobs('quest.jeuno.137#g02'), nil, 'kraken: no LSB species')
end
