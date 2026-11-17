-- 0.1.216：クライアントの DAT の名前（英語・日本語）で確かめた番号の足し分（dev/sources/game_refs_extra.json）と、英語名の直し
require('fake_env')
local json = require('src.lib.json')
local data_mod = require('src.core.data')
local D = data_mod.load(posix_fs(), ROOT .. '/data/')

local function ref(qid) return json.encode(D:game_ref(qid)) end

-- 足した番号（DAT で確かめたもの）
eq(ref('quest.misc.016'), json.encode({ 'q', 4, 37 }), "Kupofried's Sword Moogle Magic")
eq(ref('quest.misc.014'), json.encode({ 'q', 4, 35 }), "Kupofried's H2H Moogle Magic")
eq(ref('quest.altana.001'), json.encode({ 'q', 2, 95 }), 'Babban Ny Mheillea (Windurst log)')
eq(ref('quest.norg.017'), json.encode({ 'q', 5, 143 }), '20 in Pirate Years')
eq(ref('mission.bastok.002'), json.encode({ 'm', 1, 1 }), 'A Geological Survey')
eq(ref('mission.promathia.012'), json.encode({ 'm', 6, 330 }), 'Emerald Waters')
eq(ref('mission.adoulin.022'), json.encode({ 'm', 12, 30 }), 'Predators and Prey (LSB number)')
-- 英語名を直して LSB の表で結べるようになったもの
eq(ref('mission.sandoria.001'), json.encode({ 'm', 0, 0 }), 'Smash the Orcish Scouts')
eq(ref('quest.jeuno.039'), json.encode({ 'q', 3, 87 }), 'Mixed Signals')
eq(ref('quest.jeuno.106'), json.encode({ 'q', 3, 100 }), 'The Miraculous Dale')
-- LSB から作った番号は前のまま
eq(ref('quest.bastok.002'), json.encode({ 'q', 1, 14 }), 'LSB ref unchanged')
-- 決めきれないものは結ばない
check(D:game_ref('quest.misc.053') == nil, 'Divine Might stays unmapped')
check(D:game_ref('quest.sandoria.009') == nil, 'The Competition (意地・根性) stays unmapped')
-- 同じ番号に2つ結ばない
local seen = {}
for qid, r in pairs(D.game_refs) do
    local k = table.concat({ r[1], r[2], r[3] }, ':')
    check(seen[k] == nil, 'one entry per game number ' .. k .. ' ' .. qid)
    seen[k] = qid
end

-- 英語名の直し
local names = {
    ['mission.sandoria.001'] = 'Smash the Orcish Scouts',
    ['quest.jeuno.032'] = 'Past Reflections',
    ['quest.jeuno.039'] = 'Mixed Signals',
    ['quest.jeuno.052'] = 'The Wonder Magic Set',
    ['quest.jeuno.106'] = 'The Miraculous Dale',
    ['quest.misc.014'] = "Kupofried's H2H Moogle Magic",
}
for qid, n in pairs(names) do eq(D:quest(qid).name_en, n, 'name ' .. qid) end
