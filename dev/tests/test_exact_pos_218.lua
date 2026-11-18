-- 0.1.218：マス目しか無かった場所に正確な座標（pos）。地図のピンはその位置（マス目は同じ）。座標の無い場所は今までどおりマス目の中央
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local maps = require('src.core.maps')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(app.VERSION, '1.1.245', 'version 1.1.245')
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')
local D = app._data()
eq(D.version, '2026.11.17-124', 'data version')

local function has_lsb(list)
    for _, s in ipairs(list or {}) do
        if s.name == 'LSB' and (s.fact_ja or ''):find('座標 x=', 1, true) then return true end
    end
    return false
end

local function pin_of(loc)
    local floor = maps.pick_floor(D, loc, nil)
    check(floor ~= nil, 'floor for zone ' .. tostring(loc.zone_id))
    return maps.pin(floor, loc, 512)
end

-- 埋めたもの：手順の場所（アルド、ジュノ下層 J-8）
local s = D:step('mission.sandoria.010#g04')
eq(s.target, 'npc.245.Aldo', 'Aldo step')
check(s.location.pos and math.abs(s.location.pos.x - 21.049) < 0.01 and math.abs(s.location.pos.y - -61.53) < 0.01, 'Aldo exact pos')
local p = pin_of(s.location)
eq(p.kind, 'pos', 'Aldo pin from pos')
eq(p.grid, 'J-8', 'Aldo pin still in J-8')
check(has_lsb(s.extra_sources), 'Aldo step source kept off screen')

-- 埋めたもの：クエストの相手（data/quests の Cid、大工房 H-8）
local cid = D:target('npc.237.Cid')
check(cid.location.pos ~= nil, 'Cid exact pos')
eq(cid.location.grid, 'H-8', 'Cid grid unchanged')
p = pin_of(cid.location)
eq(p.kind, 'pos', 'Cid pin from pos')
eq(p.grid, 'H-8', 'Cid pin still in H-8')
check(has_lsb(cid.location_sources), 'Cid source')

-- 依頼者の場所（地図・方角の距離）：Parvipon
local q = D:quest('quest.sandoria.001')
local sl = D:start_location(q)
eq(pin_of(sl).kind, 'pos', 'giver pin from pos')

-- マス目だけのもの：資料の座標がマス目から遠い（Narcheral、北サンドリア H-8。LSB は M-6）・資料に無い（Maloquedil、ドラギーユ城 J-8）
-- （0.1.219〜 Quemaricond はとなりのマスなので座標が入った）
for _, id in ipairs({ 'npc.231.Narcheral', 'npc.233.Maloquedil' }) do
    local t = D:target(id)
    check(t ~= nil, 'target ' .. id)
    eq(t.location.pos, nil, 'no pos ' .. id)
    local gp = pin_of(t.location)
    eq(gp.kind, 'grid', 'grid pin ' .. id)
    eq(gp.grid, t.location.grid, 'grid center in its square ' .. id)
end

-- 場所が変わる ??? は候補のまま（pos は入れない）
local bm = D:target('obj.122.???_BM7-1')
eq(bm.location.pos, nil, 'moving ??? has no fixed pos')
check(bm.candidates and #bm.candidates > 1, 'moving ??? keeps candidates')

-- 全部の pos：その階の地図で、書いてあるマス目に入る
local n, bad = 0, {}
local function each(loc, what)
    if not (loc and loc.pos and loc.pos.x and loc.grid) then return end
    local floor, why = maps.pick_floor(D, loc, nil)
    if not floor or not maps.dest_on_floor(floor, loc, #maps.floors(D, loc.zone_id)) then return end
    local pp = maps.pin(floor, loc, 512)
    -- 0.1.219〜：となりのマス（3×3）まで
    local ok = false
    for _, c in ipairs(maps.grid_cells(loc.grid) or {}) do
        for dc = -1, 1 do
            for dr = -1, 1 do
                if pp.grid == string.char(65 + c.col + dc) .. '-' .. (c.row + dr) then ok = true end
            end
        end
    end
    n = n + 1
    if not ok then bad[#bad + 1] = what .. ' ' .. tostring(loc.grid) .. ' -> ' .. tostring(pp.grid) end
end
for id, t in pairs(D.targets) do each(t.location, id) end
for _, qq in ipairs(D.quests) do
    for _, st in ipairs(qq.steps or {}) do each(st.location, st.id) end
end
check(n > 5000, 'many exact places: ' .. n)
eq(#bad, 0, 'every pos falls in its grid or a neighbor: ' .. table.concat(bad, ', '))
