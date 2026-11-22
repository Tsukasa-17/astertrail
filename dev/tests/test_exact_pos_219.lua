-- 0.1.219：となりのマス（3×3 に同名が1つだけ）と、MAP の書いていない場所（当たり判定の階から MAP を決める）にも正確な座標
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local maps = require('src.core.maps')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(app.VERSION, '1.1.308', 'version 0.1.251')
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')
local D = app._data()
eq(D.version, '2026.11.20-125', 'data version')

local function near(a, b) return a and math.abs(a - b) < 0.01 end
local function pin_of(loc)
    local floor = maps.pick_floor(D, loc, nil)
    check(floor ~= nil, 'floor for zone ' .. tostring(loc.zone_id))
    check(maps.dest_on_floor(floor, loc, #maps.floors(D, loc.zone_id)), 'shown on its floor ' .. tostring(loc.zone_id))
    return maps.pin(floor, loc, 512)
end
local function has_src(list, sid)
    for _, s in ipairs(list or {}) do
        if s.name == 'LSB' and (s.fact_ja or ''):find('id ' .. sid, 1, true) then return true end
    end
    return false
end

-- ダングルフの涸れ谷の ???（用語辞典 J-5。LSB の 17559912 は I-5 で、3×3 に ??? はこれだけ）
for _, loc in ipairs({ D:target('obj.191.???_J-5').location, D:step('quest.bastok.003#g02').location }) do
    check(near(loc.pos and loc.pos.x, -120.041) and near(loc.pos.y, 415.989) and near(loc.pos.z, 2.621), 'Dangruf ??? at 17559912')
    eq(loc.grid, 'I-5', 'grid text follows the exact pos (0.1.220〜)')
    local p = pin_of(loc)
    eq(p.kind, 'pos', 'Dangruf ??? pin from pos')
    eq(p.grid, 'I-5', 'pin in the neighbor square')
end
check(has_src(D:step('quest.bastok.003#g02').extra_sources, 17559912), 'Dangruf ??? source')

-- MAP の書いていなかった場所：当たり判定の階から MAP を入れた（Eggblix は MAP2、Grasswix・Saltvix は MAP1）
local cases = {
    { 'quest.windurst.008#g08', 'npc.191.Eggblix', 2, 'E-12', -465.308 },
    { 'quest.windurst.008#g07', 'npc.191.Grasswix', 1, 'F-4', -375.395 },
    { 'quest.windurst.008#g06', nil, 1, 'F-7', -367.518 },
}
for _, c in ipairs(cases) do
    local st = D:step(c[1])
    local loc = st.location
    check(near(loc.pos and loc.pos.x, c[5]), 'pos ' .. c[1])
    eq(loc.map.kind, 'number', 'map now known ' .. c[1])
    eq(loc.map.n, c[3], 'map number ' .. c[1])
    local p = pin_of(loc)
    eq(p.kind, 'pos', 'pin from pos ' .. c[1])
    eq(p.grid, c[4], 'same grid ' .. c[1])
    if c[2] then
        local t = D:target(c[2])
        check(t.location.pos ~= nil, 'target pos ' .. c[2])
        eq(t.location.map.n, c[3], 'target map ' .. c[2])
    end
end

-- 3×3 に同名が2つ（Derelict Bridge、アビセア-ブンカール F-7。LSB は F-6 と F-8）：今までどおりマス目の真ん中
local db = D:target('obj.217.Derelict_Bridge')
eq(db.location.pos, nil, 'two candidates: no pos')
local p = pin_of(db.location)
eq(p.kind, 'grid', 'two candidates: grid pin')
eq(p.grid, 'F-7', 'two candidates: center of F-7')

-- 0.1.218 で入れた場所はそのまま（Aldo）
local s = D:step('mission.sandoria.010#g04')
check(near(s.location.pos and s.location.pos.x, 21.049), 'Aldo kept')
