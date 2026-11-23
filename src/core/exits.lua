--[[
  Astertrail - となりのエリアへの出口（0.1.171〜、t227-map）
  data/exits.json（dev/build_exits.py。LSB の zone.yaml の zonelines から、数だけ）を読む。
  出口ひとつ：x, y（水平面）, z（高さ）, to（行き先のゾーン）, at（行き先で立つ位置）。
  どの MAP（階）にあるかは、
    - そのゾーンの地図が1枚なら、その1枚
    - そうでなければ、そのゾーンにいたときにゲームの階の関数で調べて覚えた番号（learned）
    - まだ入ったことがなければ、そのゾーンの DAT の当たり判定から出した番号（dat。core/zonedat.lua、0.1.176〜）
    - それも無ければ、どれか1枚の地図の中にしか入らない位置なら、その地図（0.1.175〜）
  だけを使う。分からない出口は地図の上に置かない。推測はしない。
]]

local exits = {}

-- data に出口を入れる（doc は exits.json を読んだ表）
function exits.bind(data, doc)
    local by = {}
    local into = {}
    local zones = type(doc) == 'table' and doc.zones or nil
    if type(zones) == 'table' then
        for zk, list in pairs(zones) do
            local z = tonumber(zk)
            if z and type(list) == 'table' then
                local out = {}
                for _, e in ipairs(list) do
                    local x, y, to = tonumber(e.x), tonumber(e.y), tonumber(e.to)
                    if x and y and to then
                        local row = { x = x, y = y, z = tonumber(e.z), to = to, from = z, line = e.line }
                        if type(e.at) == 'table' and tonumber(e.at.x) and tonumber(e.at.y) then
                            row.at = { x = tonumber(e.at.x), y = tonumber(e.at.y), z = tonumber(e.at.z) }
                            into[to] = into[to] or {}
                            into[to][#into[to] + 1] = row
                        end
                        out[#out + 1] = row
                    end
                end
                by[z] = out
            end
        end
    end
    data._exits = by
    data._exits_into = into
end

function exits.of(data, zone_id)
    return (data and data._exits and data._exits[tonumber(zone_id)]) or {}
end

-- ほかのゾーンからこのゾーンへ来たときに立つ位置（その出口の at）
function exits.arrivals(data, zone_id)
    return (data and data._exits_into and data._exits_into[tonumber(zone_id)]) or {}
end

-- 覚えておく鍵（ゾーンの中の点。0.1 単位で丸める）
function exits.key(x, y)
    return string.format('%.1f,%.1f', tonumber(x) or 0, tonumber(y) or 0)
end

-- その点がどの MAP にあるか。分からなければ nil
-- dat: { [ゾーン番号] = { [exits.key] = MAP 番号 か false } }（DAT から出した階。無くてもよい）
-- h（高さ。無くてもよい）：高さで層を決めるゾーン（0.1.323〜、天の塔）では、それだけで決める。無ければ nil
function exits.map_n_of(data, maps, learned, zone_id, x, y, dat, h)
    local list = maps.floors(data, zone_id)
    if #list == 1 then return list[1].map_n end
    if maps.by_height and maps.by_height(data, zone_id) then
        return maps.map_n_for_height(data, zone_id, h)
    end
    local z = learned and learned[tostring(tonumber(zone_id))]
    if type(z) == 'table' then
        local n = tonumber(z[exits.key(x, y)])
        if n then return n end
    end
    local dz = type(dat) == 'table' and dat[tonumber(zone_id)] or nil
    if type(dz) == 'table' then
        local n = tonumber(dz[exits.key(x, y)])
        if n then return n end
    end
    -- まだ入ったことのないゾーン（0.1.175〜）：出口の位置が、どれか1枚の地図の中にしか入らないなら、その地図。
    -- 2枚以上の地図に重なる位置は、ゲームの階の関数で調べるまで置かない（入ったときに覚える）
    local hit = nil
    for _, f in ipairs(list) do
        local bx, by = maps.world_px(f, x, y)
        if bx and bx >= 0 and by >= 0 and bx <= maps.BASE and by <= maps.BASE then
            if hit then return nil end
            hit = f.map_n
        end
    end
    return hit
end

-- 行き先ごとにまとめた一覧（同じ行き先の出口が何か所あっても1つ）。並びは名前の順。
-- 戻り値: { { to=, name=, list={出口...} }, ... }
function exits.neighbors(data, zone_id)
    local by, out = {}, {}
    for _, e in ipairs(exits.of(data, zone_id)) do
        local g = by[e.to]
        if not g then
            g = { to = e.to, name = data.zone_name and data:zone_name(e.to) or nil, list = {} }
            by[e.to] = g
            out[#out + 1] = g
        end
        g.list[#g.list + 1] = e
    end
    table.sort(out, function (a, b)
        local an, bn = a.name or '', b.name or ''
        if an ~= bn then return an < bn end
        return a.to < b.to
    end)
    return out
end

-- いまいるゾーンで、出口と「来たときに立つ位置」の階を調べて learned に入れる。
-- floor_at(x, y, z) → FloorId（ゲームの関数）。FloorId は maps.map_n_for_floor で MAP 番号へ。
-- 戻り値: 新しく覚えた数
function exits.learn(data, maps, learned, zone_id, floor_at)
    zone_id = tonumber(zone_id)
    if not zone_id or type(floor_at) ~= 'function' or type(learned) ~= 'table' then return 0 end
    if #maps.floors(data, zone_id) <= 1 then return 0 end
    if maps.by_height and maps.by_height(data, zone_id) then return 0 end -- 高さで決まる（0.1.323〜）
    local zk = tostring(zone_id)
    local z = learned[zk]
    if type(z) ~= 'table' then z = {}; learned[zk] = z end
    local n = 0
    local function one(x, y, h)
        local k = exits.key(x, y)
        if z[k] ~= nil then return end
        local ok, fid = pcall(floor_at, x, y, h)
        if not ok or fid == nil then return end
        local mn = maps.map_n_for_floor(data, zone_id, fid)
        if mn then z[k] = mn; n = n + 1 end
    end
    for _, e in ipairs(exits.of(data, zone_id)) do one(e.x, e.y, e.z) end
    for _, e in ipairs(exits.arrivals(data, zone_id)) do one(e.at.x, e.at.y, e.at.z) end
    return n
end

-- DAT から階を出す（0.1.176〜）。z は zonedat.open の戻り値、floor_of(z, x, y, h) → FloorId。
-- out（そのゾーンの表）に、出口と「来たときに立つ位置」の MAP 番号を入れる。出せない点は false。
-- from から max 個だけ調べ、続きの番号を返す（全部済めば nil）。点の並びは exits.dat_points。
function exits.dat_points(data, zone_id)
    local pts = {}
    for _, e in ipairs(exits.of(data, zone_id)) do pts[#pts + 1] = { e.x, e.y, e.z } end
    for _, e in ipairs(exits.arrivals(data, zone_id)) do pts[#pts + 1] = { e.at.x, e.at.y, e.at.z } end
    return pts
end

function exits.dat_step(data, maps, zone_id, pts, z, floor_of, out, from, max)
    from = from or 1
    local last = math.min(#pts, from + (max or #pts) - 1)
    for i = from, last do
        local p = pts[i]
        local k = exits.key(p[1], p[2])
        if out[k] == nil then
            local mn = false
            if p[3] ~= nil then
                local ok, fid = pcall(floor_of, z, p[1], p[2], p[3])
                if ok and fid ~= nil then mn = maps.map_n_for_floor(data, zone_id, fid) or false end
            end
            out[k] = mn
        end
    end
    if last >= #pts then return nil end
    return last + 1
end

-- まだ階を覚えていない点（出口と来たときに立つ位置）の数。1枚だけのゾーンは 0
function exits.unlearned(data, maps, learned, zone_id)
    zone_id = tonumber(zone_id)
    if not zone_id or #maps.floors(data, zone_id) <= 1 then return 0 end
    if maps.by_height and maps.by_height(data, zone_id) then return 0 end -- 高さで決まる（0.1.323〜）
    local z = type(learned) == 'table' and learned[tostring(zone_id)] or nil
    local n = 0
    local function one(x, y)
        if not (type(z) == 'table' and z[exits.key(x, y)] ~= nil) then n = n + 1 end
    end
    for _, e in ipairs(exits.of(data, zone_id)) do one(e.x, e.y) end
    for _, e in ipairs(exits.arrivals(data, zone_id)) do one(e.at.x, e.at.y) end
    return n
end

return exits
