-- 0.1.230：場所が変わる相手の LSB 候補と、文に出る NPC を資料へ追加したこと
require('harness')
local data_mod = require('src.core.data')
local marks = require('src.core.marks')

local D = data_mod.load(posix_fs(), ROOT .. '/data/')
eq(#D.errors, 0, 'data errors')

-- (1) 動く相手（ロ・メーヴと Storage Hole 以外）
local cases = {
    { 'obj.48.blank_striking_a_balance', 16974404, 8, 'quest.aht_urhgan.010#g06' },
    { 'obj.グロウベルグ〔Ｓ〕.Indescript_Markings_D-8', 17142582, 9, 'quest.altana.105#ga01' },
    { 'obj.90.Indescript_Markings_Body', 17146629, 10, 'quest.altana.105#ga02' },
    { 'obj.90.Indescript_Markings_Pants', 17146628, 9, 'quest.altana.105#gb01' },
    { 'obj.96.Indescript_Markings', 17171273, 8, 'quest.altana.105#gc01' },
    { 'obj.106.???_J-8', 17212046, 5, 'quest.bastok.049#g03' },
    { 'obj.208.???', 17629736, 6, 'quest.rabao.004#g02' },
    { 'obj.149.Jar', 17388022, 10, 'quest.selbina_mhaura.008#g03' },
    { 'obj.27.???_Ovens', 16888124, 4, 'quest.tavnazia.007#ga01' },
    { 'obj.28.???_Ovens', 16892185, 4, 'quest.tavnazia.007#gb01' },
    { 'obj.195.???_I-10', 17576359, 4, 'quest.windurst.030#g02' },
}
for _, c in ipairs(cases) do
    local id, sid, n, step = c[1], c[2], c[3], c[4]
    local tg = D:target(id)
    check(tg ~= nil, 'target exists: ' .. id)
    eq(tg.server_id, sid, id .. ' server id')
    eq(tg.moves, true, id .. ' moves')
    local cand = marks.candidates_for(D, D:step(step))
    eq(cand and #cand, n, id .. ' candidates_for ' .. tostring(cand and #cand))
    eq(D:step(step).target, id, step .. ' target')
    for _, x in ipairs(cand) do
        check(x.x ~= nil and x.y ~= nil, id .. ' candidate has pos')
    end
end
-- 前の版で入れた2件は残っている
eq(#(D:target('obj.122.???_BM7-1').candidates or {}), 10, 'RoMaeve still 10')
eq(#((D:step('quest.sandoria.063#g04').location or {}).candidates or {}), 15, 'Storage Hole still 15')
-- 礼拝堂の古い別 NPC 座標は候補に入れない
do
    local bad = false
    for _, x in ipairs(marks.candidates_for(D, D:step('quest.tavnazia.007#gb01'))) do
        if math.abs((x.x or 0) - 22.669) < 0.01 and math.abs((x.y or 0) + 127.318) < 0.01 then bad = true end
    end
    check(not bad, 'Sacrarium yaml of a different NPC is not a candidate')
end

-- (2) 0.1.228 で資料に無くて省かれた話し相手を LSB から追加
local tg = D:target('npc.236.Tilian')
check(tg and tg.location and tg.location.pos and tg.location.pos.x ~= nil, 'Tilian has exact pos')
eq(tg.server_id, 17743932, 'Tilian LSB id')
eq(tg.location.grid, 'F-8', 'Tilian grid')
check(D:resolve_talk_name('Tilian', 'F-8', 236) ~= nil, 'Tilian resolves')
check(D:resolve_talk_name('Authere', 'J-9', 230) ~= nil, 'Authere resolves')
check(D:resolve_talk_name('Umumu', 'I-5', 241) ~= nil, 'Umumu resolves')
check(D:resolve_talk_name('Three of Clubs', 'G-7', 240) ~= nil, 'Three of Clubs resolves')
-- ほかのゾーンの同名は今も使わない
local pfm = D:resolve_talk_name('Perfaumand', 'H-7', 233)
check(pfm ~= nil and pfm.id == 'npc.233.Perfaumand', 'Chateau Perfaumand is the 233 one (not [S])')
local rgt = D:resolve_talk_name('Rugiette', 'J-8', 232)
check(rgt ~= nil and rgt.id == 'npc.232.Rugiette', 'Port Rugiette is the 232 one (not 132)')

local ids = D:listed_talk_targets(D:step('quest.bastok.028#g02'))
local have = {}
for _, id in ipairs(ids) do have[id] = true end
check(have['npc.236.Tilian'], 'wildcat port lists Tilian')
eq(#ids, 5, 'wildcat port 5 pins')
