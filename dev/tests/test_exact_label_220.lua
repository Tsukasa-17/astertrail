-- 0.1.220〜0.1.221：場所の文字（マス目）を正確な座標のマスに合わせる（0.1.221 で境目の2マス・テンキーも）。ひとりでできる？の Marin（ダングルフの涸れ谷）をつなぎ直す
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local maps = require('src.core.maps')
local marks = require('src.core.marks')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(app.VERSION, '1.1.314', 'version 0.1.251')
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')
local D = app._data()
eq(D.version, '2026.11.20-125', 'data version')

local function T(k) return k end
local function pin_of(loc)
    local floor = maps.pick_floor(D, loc, nil)
    check(floor ~= nil, 'floor for zone ' .. tostring(loc.zone_id))
    return maps.pin(floor, loc, 512)
end
local function has(s, pat) return (s or ''):find(pat, 1, true) ~= nil end

-- ダングルフの涸れ谷の ???（0.1.219 で I-5 の本物の位置。文字も I-5 に）
for _, loc in ipairs({ D:target('obj.191.???_J-5').location, D:step('quest.bastok.003#g02').location }) do
    eq(loc.grid, 'I-5', 'Dangruf ??? label I-5')
    eq(pin_of(loc).grid, 'I-5', 'pin in I-5')
    check(has(D:location_text(loc, T), '(I-5)'), 'location text I-5')
    check(not has(D:location_text(loc, T), 'J-5'), 'no J-5 in location text')
end

-- 手順の文のマス目の字だけ直す（用語辞典の文はそのまま）
local s = D:step('mission.sandoria.006#gam1')
eq(s.location.grid, 'J-8', 'Pius label')
eq(s.next_line_ja, '大統領府のPius(J-8)に話す', 'Pius text: only the grid changed')
s = D:step('quest.windurst.018#g03')
eq(s.location.grid, 'B-13', 'Five of Diamonds label')
check(has(s.next_line_ja, '（石の区B-13）') and has(s.next_line_ja, '（水の区北K-9）'), 'only Five of Diamonds grid changed')
-- 0.1.221〜：テンキー付き（G-8 テンキー7）もただのマス目（座標のマス G-7）に
s = D:step('mission.sandoria.010#g05')
eq(s.location.grid, 'G-7', 'Baudin label')
eq(s.next_line_ja, 'ジュノ上層(G-7)のBaudinにクァールの肉を渡し「ダボイ村紋章」を入手', 'numpad dropped')
-- 0.1.221〜：境目の2マスも、座標のマスだけに
eq(D:target('npc.249.Rycharde').location.grid, 'H-8', 'border label -> exact square')
-- ほかの手順の文・クエストの注の「ゾーン(旧)…名前」
check(has(D:step('mission.rov.071#g01').text_ja, 'ル・ルデの庭(H-4)のJamal'), 'Jamal in another step text')
check(has(D:step('quest.sandoria.020#g04').text_ja, 'Rosel(K-7)'), 'Rosel in a list')
check(has(D:quest('mission.sandoria.020').note_ja, '北サンドリア(M-6)Door:Papal Chambers'), 'quest note')
-- 手順の場所と同じマスを指す (H-6) はそのまま（ロランベリー耕地の ??? は H-6）
check(has(D:step('mission.rov.032#gb01').next_line_ja, 'ロランベリー耕地(H-6)'), 'own place text kept')

-- 全部の pos：場所の文字のマス目＝ピンのマス（境目の2マスは、その中のどちらか）
local n, bad = 0, {}
local function each(loc, what)
    if not (loc and loc.pos and loc.pos.x and loc.grid) then return end
    local floor = maps.pick_floor(D, loc, nil)
    if not floor or not maps.dest_on_floor(floor, loc, #maps.floors(D, loc.zone_id)) then return end
    local g = maps.pin(floor, loc, 512).grid
    local ok = false
    for part in loc.grid:gmatch('[^/]+') do
        if part == g then ok = true end
    end
    n = n + 1
    if not ok then bad[#bad + 1] = what .. ' ' .. loc.grid .. ' -> ' .. tostring(g) end
end
for id, t in pairs(D.targets) do each(t.location, id) end
for _, qq in ipairs(D.quests) do
    for _, st in ipairs(qq.steps or {}) do each(st.location, st.id) end
end
check(n > 5000, 'many exact places: ' .. n)
eq(#bad, 0, 'label matches the pin square: ' .. table.concat(bad, ', '))

-- Marin：受ける・完了は商業区、Ken のあとはダングルフの涸れ谷の Marin
eq(D:step('quest.bastok.007#g01').target, 'npc.235.Marin', 'accept in Markets')
eq(D:step('quest.bastok.007#g05').target, 'npc.235.Marin', 'finish in Markets')
eq(D:step('quest.bastok.007#g01').location.grid, 'E-10', 'Markets E-10')
local st = D:step('quest.bastok.007#g04')
eq(st.target, 'npc.191.Marin', 'relinked to Dangruf Marin')
local tg = D:target('npc.191.Marin')
eq(tg.name_en, 'Marin', 'name')
for _, loc in ipairs({ tg.location, st.location }) do
    eq(loc.zone_id, 191, 'Dangruf')
    eq(loc.map.kind, 'number', 'map known')
    eq(loc.map.n, 1, 'MAP1')
    check(math.abs(loc.pos.x - -19.701) < 0.01 and math.abs(loc.pos.y - -6.325) < 0.01, 'LSB pos')
    eq(loc.grid, 'K-10', 'label K-10')
    local p = pin_of(loc)
    eq(p.kind, 'pos', 'pin from pos')
    eq(p.grid, 'K-10', 'pin K-10')
end
eq(D:location_text(st, T), 'ダングルフの涸れ谷 MAP[1] (K-10)', 'location text')
for _, x in ipairs(st.extra_sources or {}) do
    check(not has(x.fact_ja, 'E-10'), 'old Markets grid source gone')
end
-- 印：出ている Marin にだけ付く（ふだんは居ないので付かない）
local w = marks.wanted_for_step(D, st)
check(w ~= nil, 'wanted for step')
eq(#marks.match({ w }, { { index = 3, name = 'Ken', x = 0, y = 0 } }, { zone_id = 191 }), 0, 'not shown: no mark')
eq(#marks.match({ w }, { { index = 4, name = 'Marin', x = -19.7, y = -6.3 } }, { zone_id = 191 }), 1, 'shown: mark')

-- 0.1.221〜：境目の2マスも座標のマスだけ。全部の pos で、場所の文字＝ピンのマス（1マス）
local bad2, n2 = {}, 0
local function each2(loc, what)
    if not (loc and loc.pos and loc.pos.x and loc.grid) then return end
    local floor = maps.pick_floor(D, loc, nil)
    if not floor or not maps.dest_on_floor(floor, loc, #maps.floors(D, loc.zone_id)) then return end
    n2 = n2 + 1
    local g = maps.pin(floor, loc, 512).grid
    if loc.grid ~= g then bad2[#bad2 + 1] = what .. ' ' .. loc.grid .. ' -> ' .. tostring(g) end
end
for id, t in pairs(D.targets) do each2(t.location, id) end
for _, qq in ipairs(D.quests) do
    for _, st in ipairs(qq.steps or {}) do each2(st.location, st.id) end
end
check(n2 > 5000, 'many exact places (strict): ' .. n2)
eq(#bad2, 0, 'label is exactly the pin square: ' .. table.concat(bad2, ', '))
eq(D:target('npc.252.Kieran').location.grid, 'I-8', 'Kieran border -> I-8')
eq(D:step('quest.selbina_mhaura.013#g01').location.grid, 'H-8', 'Rycharde step H-8')
check(has(D:step('quest.selbina_mhaura.013#g01').next_line_ja, 'マウラ(H-8)船乗りの宿'), 'border text -> exact square')
check(has(D:step('quest.jeuno.044#g02').next_line_ja, '(E-4)にあるChocobo Tracks'), 'Chocobo Tracks E-4')

-- 0.1.221〜：座標のある場所のテンキーの説明は外して、ただのマス目
local nl = {
    ['mission.bastok.010#g05'] = 'ジュノ上層(G-7)のBaudin',
    ['mission.windurst.010#g05'] = 'ジュノ上層(G-7)のBaudin',
    ['mission.bastok.009#g01'] = '大工房(I-9)補佐官室のLucius',
    ['quest.norg.001#g01'] = 'ノーグ(I-8)簡易倉庫前のKieran',
    ['quest.jeuno.115#g07'] = 'タロンギ大峡谷(I-9)のGeomagnetic Fount',
    ['quest.jeuno.128#g10'] = '高台の中央（H-6）の???',
    ['mission.sandoria.019#g03'] = 'ザルカバード(H-7)上段の???',
    ['quest.abyssea.089#g02'] = '(J-8)の北西のFaint Glister',
    ['quest.windurst.008#g06'] = 'ダングルフの涸れ谷(F-7)の???',
}
for id, want in pairs(nl) do
    local st2 = D:step(id)
    check(has(st2.next_line_ja, want), 'numpad dropped ' .. id)
end
eq(D:step('quest.abyssea.114#g03').text_ja, '山の西。', 'numpad sentence dropped from note')
eq(D:step('quest.adoulin.078#g03').text_ja, nil, 'note was only the numpad')
local left = 0
for _, qq in ipairs(D.quests) do
    for _, st2 in ipairs(qq.steps or {}) do
        if st2.location and st2.location.pos and has(st2.next_line_ja, 'テンキー') then left = left + 1 end
    end
end
eq(left, 0, 'Eldieme step no longer has a single pos (0.1.230 candidates); Batallia numpad text is still kept')
check(has(D:step('quest.windurst.030#g02').next_line_ja, 'バタリア丘陵(H-7)テンキー2の入口'), 'other place kept')
-- そのまま：動く相手の説明・ロランベリー耕地の ???
check(has(D:step('mission.tvr.010#g03').text_ja, 'G-7とH-7のあいだの道'), 'moving NPC note kept')
check(has(D:step('mission.rov.032#gb01').next_line_ja, 'ロランベリー耕地(H-6)'), 'Rolanberry ??? kept')
