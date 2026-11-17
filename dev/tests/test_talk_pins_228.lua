-- 0.1.228：複数の話し相手が並んだ手順は、座標がある相手を全部地図のピンに出し、
-- 今の手順では読み込まれている相手全員に頭上の印と足元の輪（vana.world.marks）を付ける。
-- 三国（サンドリア・バストゥーク・ウィンダス）を含む、すべての地域の手順が対象。
require('harness')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local marks = require('src.core.marks')
local marks_ui = require('src.ui.marks')
local maps = require('src.core.maps')
local map_view = require('src.ui.map_view')
local settings_mod = require('src.core.settings')

local D = data_mod.load(posix_fs(), ROOT .. '/data/')
eq(#D.errors, 0, 'data errors')
local fill = D._talk_fill
check(fill and fill.steps > 0, 'filled talk steps: ' .. tostring(fill and fill.steps))

-- 名前の拾い方：小文字のつなぎ、マスのあとの注記
do
    local a = data_mod.parse_listed_names('Kunchichi(E-7)、Three of Clubs(G-7)、Yujuju(M-6)')
    eq(#a, 3, 'Three of Clubs parsed')
    eq(a[2].name, 'Three of Clubs', 'particle in the name')
    eq(a[2].grid, 'G-7', 'Clubs grid')
    local b = data_mod.parse_listed_names('南：Honoi-Gomoi(E-7 民家裏の階段の上)・Kenapa-Keppa(J-9)')
    eq(#b, 2, 'annotation after the grid')
    eq(b[1].name, 'Honoi-Gomoi', 'Honoi-Gomoi from annotated grid')
end

-- ほかのゾーンの同名は使わない（推測しない）
do
    local pfm = D:resolve_talk_name('Perfaumand', 'H-7', 233)
    check(pfm ~= nil and pfm.id == 'npc.233.Perfaumand', 'Chateau Perfaumand is the 233 one (not [S])')
    eq(pfm.location.zone_id, 233, 'Perfaumand zone')
    local rgt = D:resolve_talk_name('Rugiette', 'J-8', 232)
    check(rgt ~= nil and rgt.id == 'npc.232.Rugiette', 'Port Rugiette is the 232 one (not 132)')
    eq(rgt.location.zone_id, 232, 'Rugiette zone')
    check(D:resolve_talk_name('Tilian', 'F-8', 236) ~= nil, 'Tilian is in the data (0.1.230 LSB)')
    check(D:resolve_talk_name('Three of Clubs', 'G-7', 240) ~= nil, 'Three of Clubs is in the data (0.1.230 LSB)')
end

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

local function rec_of(sid)
    for _, r in ipairs(fill.by_quest or {}) do
        if r.step == sid then return r end
    end
end

local function mark_names(qid, zone_id)
    local wanted = marks.in_zone(marks.wanted(D, P, { fame = false }), zone_id)
    local names = {}
    for _, w in ipairs(wanted) do
        if w.quest_id == qid then names[w.name] = true end
    end
    return names, wanted
end

local function match_and_rings(qid, zone_id, ents)
    local wanted = marks.in_zone(marks.wanted(D, P, { fame = false }), zone_id)
    local matched = marks.match(wanted, ents, { zone_id = zone_id })
    local rows, hit = {}, {}
    for _, row in ipairs(matched) do
        for _, w in ipairs(row.wanted or {}) do
            if w.quest_id == qid then
                rows[#rows + 1] = row
                hit[row.entity.name] = true
                break
            end
        end
    end
    local ui = { settings = settings_mod.defaults(), platform = {} }
    local rings = marks_ui.ground_rings(ui, rows, { x = 0, y = 0 })
    return hit, rings, rows
end

-- バストゥーク 山猫の誘惑 手順2：5人とも LSB で一意に決まる（0.1.230 で Tilian を追加）
do
    local s = D:step('quest.bastok.028#g02')
    local ids = D:listed_talk_targets(s)
    local have = {}
    for _, id in ipairs(ids) do have[id] = true end
    check(have['npc.236.Kaede'], 'Kaede with LSB pos')
    check(have['npc.236.Paujean'], 'Paujean')
    check(have['obj.236.Patient_Wheel'], 'Patient Wheel')
    check(have['npc.236.Hilda'], 'Hilda')
    check(have['npc.236.Tilian'], 'Tilian from LSB (0.1.230)')
    eq(#ids, 5, 'five pins for port step')
    check(#(s.extra_targets or {}) >= 3, 'extras filled')
    go('quest.bastok.028#g02')
    local names = mark_names('quest.bastok.028', 236)
    check(names['Kaede'] and names['Paujean'] and names['Patient Wheel'] and names['Hilda'] and names['Tilian'], 'wanted marks for all five')
    local floor = maps.floor(D, 236, 1) or (maps.floors(D, 236) or {})[1]
    check(floor ~= nil, 'Port Bastok map')
    local pins = map_view.talk_pins({ data = D, state = {} }, D, floor, s.location, s, nil)
    eq(#pins, 5, 'map shows five pins')
    -- 近くに読み込まれていれば、頭上の印と足元の輪がそれぞれに付く
    local ents = {
        { index = 1, name = 'Kaede', kind = 'npc', x = 1, y = 1, z = 0, hitbox_size = 1 },
        { index = 2, name = 'Paujean', kind = 'npc', x = 2, y = 2, z = 0, hitbox_size = 1 },
        { index = 3, name = 'Patient Wheel', kind = 'obj', x = 3, y = 3, z = 0, hitbox_size = 1 },
        { index = 4, name = 'Hilda', kind = 'npc', x = 4, y = 4, z = 0, hitbox_size = 1 },
        { index = 5, name = 'Tilian', kind = 'npc', x = 5, y = 5, z = 0, hitbox_size = 1, server_id = 17743932 },
    }
    local hit, rings = match_and_rings('quest.bastok.028', 236, ents)
    check(hit['Kaede'] and hit['Paujean'] and hit['Patient Wheel'] and hit['Hilda'] and hit['Tilian'], 'overhead marks when nearby')
    eq(#rings, 5, 'foot ring for each loaded listed NPC')
    P:set_state('quest.bastok.028', 'completed')
end

-- ウィンダス 山猫のウィンク 森の区：LSB で一意に決まる5人（0.1.230 で座標を追加）
do
    local s = D:step('quest.windurst.013#g02')
    local rec = rec_of(s.id)
    check(rec ~= nil, 'Windurst wildcat g02 filled')
    local pins = D:listed_talk_targets(s)
    check(#pins >= 5, 'Windurst forest pins: ' .. #pins)
    check(rec.marks >= 5 and rec.pins >= 5, 'Windurst forest all five have marks and pins')
    go('quest.windurst.013#g02')
    local names = mark_names('quest.windurst.013', 241)
    check(names['Etsa Rhuyuli'] and names['Soni-Muni'] and names['Nanaa Mihgo'] and names['Cayu Pensharhumi'] and names['Umumu'], 'Windurst forest wanted all five')
    local ents = {
        { index = 1, name = 'Etsa Rhuyuli', kind = 'npc', x = 1, y = 1, z = 0, hitbox_size = 1, server_id = 17764498 },
        { index = 2, name = 'Soni-Muni', kind = 'npc', x = 2, y = 2, z = 0, hitbox_size = 1 },
        { index = 3, name = 'Nanaa Mihgo', kind = 'npc', x = 3, y = 3, z = 0, hitbox_size = 1 },
        { index = 4, name = 'Umumu', kind = 'npc', x = 4, y = 4, z = 0, hitbox_size = 1, server_id = 17764489 },
        { index = 5, name = 'Cayu Pensharhumi', kind = 'npc', x = 5, y = 5, z = 0, hitbox_size = 1, server_id = 17764510 },
    }
    local hit, rings = match_and_rings('quest.windurst.013', 241, ents)
    check(hit['Etsa Rhuyuli'] and hit['Soni-Muni'] and hit['Nanaa Mihgo'] and hit['Umumu'] and hit['Cayu Pensharhumi'], 'Windurst forest marks when nearby')
    eq(#rings, 5, 'Windurst forest foot rings')
    local floor = maps.floor(D, 241, 1) or (maps.floors(D, 241) or {})[1]
    if floor and s.location then
        local pp = map_view.talk_pins({ data = D, state = {} }, D, floor, s.location, s, nil)
        check(#pp >= 5, 'Windurst forest map pins include Etsa now that LSB pos exists')
    end
    P:set_state('quest.windurst.013', 'completed')
end

-- サンドリア 山猫のいざない 南サンドリア
do
    local s = D:step('quest.sandoria.055#g02')
    local rec = rec_of(s.id)
    check(rec ~= nil, 'San d\'Oria wildcat g02 filled')
    eq(rec.marks, 5, 'Daggao+Femitte+Rouva+Deraquien+Authere (0.1.230 LSB)')
    eq(rec.pins, 5, 'all five have LSB pos')
    go('quest.sandoria.055#g02')
    local names = mark_names('quest.sandoria.055', 230)
    check(names['Daggao'] and names['Femitte'] and names['Rouva'] and names['Deraquien'] and names['Authere'], 'San d\'Oria south wanted all five')
    local ents = {
        { index = 1, name = 'Daggao', kind = 'npc', x = 1, y = 1, z = 0, hitbox_size = 1, server_id = 17719503 },
        { index = 2, name = 'Femitte', kind = 'npc', x = 2, y = 2, z = 0, hitbox_size = 1 },
        { index = 3, name = 'Rouva', kind = 'npc', x = 3, y = 3, z = 0, hitbox_size = 1 },
        { index = 4, name = 'Deraquien', kind = 'npc', x = 4, y = 4, z = 0, hitbox_size = 1 },
        { index = 5, name = 'Authere', kind = 'npc', x = 5, y = 5, z = 0, hitbox_size = 1, server_id = 17719357 },
    }
    local hit, rings = match_and_rings('quest.sandoria.055', 230, ents)
    check(hit['Daggao'] and hit['Femitte'] and hit['Rouva'] and hit['Deraquien'] and hit['Authere'], 'San d\'Oria marks when nearby')
    eq(#rings, 5, 'San d\'Oria south foot rings')
    P:set_state('quest.sandoria.055', 'completed')
end

-- 既に extra_targets がある手順（Hat in Hand）は件数を保ったままピンが増える
do
    local s = D:step('quest.windurst.035#g03')
    eq(#(s.extra_targets or {}), 7, 'Hat in Hand still has seven extras')
    local ids = D:listed_talk_targets(s)
    check(#ids >= 8, 'primary plus extras: ' .. #ids)
end

-- サンドリア 魔法屋のチラシ（トレードも同じ扱い）
do
    local rec = rec_of('quest.sandoria.020#g02')
    check(rec ~= nil, 'Flyers for Regine port filled')
    check(rec.marks >= 3, 'Answald + Portaure + Miene')
end

-- 数と、全地域の内訳（報告用）
do
    local qn, mn = 0, 0
    local nations = {}
    for _, r in ipairs(fill.by_quest or {}) do
        if tostring(r.quest):find('^mission%.', 1) then mn = mn + 1 else qn = qn + 1 end
        local cat = r.category or '?'
        nations[cat] = (nations[cat] or 0) + 1
    end
    print(string.format('talk_fill steps=%s listed=%s resolved=%s resolved_pos=%s added=%s multi_marks=%s multi_pins=%s',
        tostring(fill.steps), tostring(fill.listed), tostring(fill.resolved), tostring(fill.resolved_pos),
        tostring(fill.added), tostring(fill.steps_multi_marks), tostring(fill.steps_multi_pins)))
    print(string.format('multi-name talk/trade/examine steps: quests=%d missions=%d', qn, mn))
    local keys = {}
    for k in pairs(nations) do keys[#keys + 1] = k end
    table.sort(keys)
    local parts = {}
    for _, k in ipairs(keys) do parts[#parts + 1] = k .. '=' .. tostring(nations[k]) end
    print('by category: ' .. table.concat(parts, ', '))
    print('--- Windurst ---')
    for _, r in ipairs(fill.by_quest or {}) do
        if r.category == 'windurst' or tostring(r.quest):find('^quest%.windurst%.', 1) or tostring(r.quest):find('^mission%.windurst%.', 1) then
            print(string.format('  %s  %s / %s  listed=%s marks=%s pins=%s',
                r.step, tostring(r.name_ja), tostring(r.name_en), r.listed, r.marks, r.pins))
        end
    end
    print('--- San d\'Oria ---')
    for _, r in ipairs(fill.by_quest or {}) do
        if r.category == 'sandoria' or tostring(r.quest):find('^quest%.sandoria%.', 1) or tostring(r.quest):find('^mission%.sandoria%.', 1) then
            print(string.format('  %s  %s / %s  listed=%s marks=%s pins=%s',
                r.step, tostring(r.name_ja), tostring(r.name_en), r.listed, r.marks, r.pins))
        end
    end
    eq(qn + mn, fill.steps, 'count matches fill.steps')
    check(fill.steps >= 20, 'enough multi-NPC steps')
    check(fill.listed >= 100, 'enough listed names')
    check(fill.resolved >= 50, 'enough resolved for marks')
    check(fill.resolved_pos >= 40, 'enough pins with exact pos')
    check(fill.resolved >= 120, 'most listed names now resolve (0.1.230 LSB targets)')
    check(fill.steps_multi_marks >= 15, 'steps that got multiple mark targets')
    check(nations.windurst and nations.windurst >= 5, 'Windurst steps covered')
    check(nations.sandoria and nations.sandoria >= 6, 'San d\'Oria steps covered')
    check(nations.bastok and nations.bastok >= 4, 'Bastok steps covered')
    -- ピン対象は座標があるものだけ
    for _, q in ipairs(D.quests or {}) do
        for _, s in ipairs(q.steps or {}) do
            for _, id in ipairs(D:listed_talk_targets(s)) do
                local tg = D:target(id)
                check(tg and tg.location and tg.location.pos and tg.location.pos.x ~= nil,
                    'only targets with pos: ' .. tostring(id))
            end
        end
    end
end
