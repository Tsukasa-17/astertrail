--[[
  Astertrail - 地図の対応表とピン位置
  画像は同梱しない。対応表は 2026-11-12 の実機読み出しとメニュー照合。
  マス目からのピンは、512px 基準の画像上の区画の中央（参考位置。正確な NPC 位置ではない）。
  実座標があるときだけ、Offset と Scale で画像上の位置を出す。
]]

local maps = {}

maps.BASE = 512
maps.MARGIN = 16
maps.CELL = 32

-- data が maps.json を読み込んだあとに呼ぶ
function maps.bind(data)
    local by, unc = {}, {}
    for _, f in ipairs(data.map_floors or {}) do
        local z = f.zone_id
        if z and f.map_n then
            if not by[z] then by[z] = {} end
            by[z][#by[z] + 1] = f
        end
    end
    for z, list in pairs(by) do
        table.sort(list, function (a, b) return (a.map_n or 0) < (b.map_n or 0) end)
    end
    for _, u in ipairs(data.map_unconfirmed or {}) do
        if u.zone_id then unc[u.zone_id] = u end
    end
    data._map_by_zone = by
    data._map_unconfirmed = unc
end

function maps.floors(data, zone_id)
    if not data or not zone_id then return {} end
    return (data._map_by_zone and data._map_by_zone[zone_id]) or {}
end

function maps.floor(data, zone_id, map_n)
    if not map_n then return nil end
    for _, f in ipairs(maps.floors(data, zone_id)) do
        if f.map_n == map_n then return f end
    end
    return nil
end

function maps.is_unconfirmed(data, zone_id)
    return data and data._map_unconfirmed and data._map_unconfirmed[zone_id] ~= nil
        and #maps.floors(data, zone_id) == 0
end

-- ゲームが返す FloorId → その地図の MAP 番号（表に無ければ nil）
function maps.map_n_for_floor(data, zone_id, floor_id)
    floor_id = tonumber(floor_id)
    if floor_id == nil then return nil end
    for _, f in ipairs(maps.floors(data, tonumber(zone_id))) do
        if tonumber(f.floor_id) == floor_id then return f.map_n end
    end
    return nil
end

local function parse_one(grid)
    local col, row = grid:match('^%s*([A-Za-z])%s*[%-－]?%s*(%d+)%s*$')
    if not col then return nil end
    col = col:upper():byte() - string.byte('A')
    row = tonumber(row)
    if not row or row < 1 or col < 0 then return nil end
    return col, row
end

-- マス目 "E-8" → 列 0 始まり（A=0）、行 1 始まり。
-- 境界の2マス "F-6/G-6" は1つ目のマスを返す（全部ほしいときは grid_cells）。
function maps.parse_grid(grid)
    if type(grid) ~= 'string' then return nil end
    local cells = maps.grid_cells(grid)
    if not cells then return nil end
    return cells[1].col, cells[1].row
end

-- マス目の一覧。"E-8" は1つ、境界の "F-6/G-6" は2つ。読めなければ nil。
function maps.grid_cells(grid)
    if type(grid) ~= 'string' then return nil end
    local out = {}
    for part in grid:gmatch('[^/]+') do
        local col, row = parse_one(part)
        if not col then return nil end
        out[#out + 1] = { col = col, row = row }
    end
    if #out == 0 then return nil end
    return out
end

-- 512px 基準の画像上の位置（左上が 0,0）
function maps.grid_px(col, row)
    if col == nil or row == nil then return nil end
    local x = maps.MARGIN + col * maps.CELL + maps.CELL / 2
    local y = maps.MARGIN + (row - 1) * maps.CELL + maps.CELL / 2
    return x, y
end

-- 実座標（ゲーム内の x, y）→ 512px 基準の画像上の位置
function maps.world_px(floor, world_x, world_y)
    if not floor or world_x == nil or world_y == nil then return nil end
    local scale = math.abs(tonumber(floor.scale) or 0)
    if scale == 0 then return nil end
    local mapX = world_x * scale * 0.2
    local mapY = -world_y * scale * 0.2
    local x = mapX - (tonumber(floor.offset_x) or 0)
    local y = mapY - (tonumber(floor.offset_y) or 0)
    return x, y
end

-- ピン。kind は 'pos'（実座標）か 'grid'（マス目の中央、参考）
function maps.pin(floor, loc, image_w)
    if not loc then return nil end
    local bx, by, kind
    local pos = loc.pos
    if type(pos) == 'table' and pos.x ~= nil and pos.y ~= nil and floor then
        bx, by = maps.world_px(floor, tonumber(pos.x), tonumber(pos.y))
        kind = 'pos'
    end
    if not bx then
        -- 境界の2マスは、そのあいだ（境目）に出す
        local cells = maps.grid_cells(loc.grid)
        if cells then
            local sx, sy = 0, 0
            for _, c in ipairs(cells) do
                local x, y = maps.grid_px(c.col, c.row)
                sx, sy = sx + x, sy + y
            end
            bx, by = sx / #cells, sy / #cells
            kind = 'grid'
        end
    end
    if not bx then return nil end
    local w = tonumber(image_w) or maps.BASE
    local s = w / maps.BASE
    return { x = bx * s, y = by * s, kind = kind, base_x = bx, base_y = by,
             grid = maps.grid_name(bx, by) }
end

-- マス目の名前（512px 基準の画像位置から）。範囲外なら nil。
function maps.grid_name(bx, by)
    if bx == nil or by == nil then return nil end
    local col = math.floor((bx - maps.MARGIN) / maps.CELL)
    local row = math.floor((by - maps.MARGIN) / maps.CELL) + 1
    if col < 0 or col > 15 or row < 1 or row > 16 then return nil end
    return string.char(string.byte('A') + col) .. '-' .. tostring(row)
end

-- 自分の現在地。Ashita の GetLocalPositionX と GetLocalPositionY が水平面で、
-- GetLocalPositionZ は高さ。Z を水平に使うと、印が「高さ 0」の線に寄ってしまう。
-- 同じゾーンのときだけ。地図の範囲から大きく外れていれば off=true（別階層などの目安）。
function maps.player_pin(floor, player, loc)
    if not floor or not player or not loc then return nil end
    if tonumber(player.zone_id) ~= tonumber(loc.zone_id) then return nil end
    local wx, wy = tonumber(player.x), tonumber(player.y)
    if wx == nil or wy == nil then return nil end
    local bx, by = maps.world_px(floor, wx, wy)
    if not bx then return nil end
    local off = (bx < -32 or by < -32 or bx > maps.BASE + 32 or by > maps.BASE + 32)
    return { base_x = bx, base_y = by, kind = 'player', off = off and true or false,
             x = bx, y = by, grid = maps.grid_name(bx, by) }
end

-- 資料に書いてある MAP 番号（無ければ nil）
function maps.wanted_map(loc)
    if loc and loc.map and loc.map.kind == 'number' and loc.map.n then
        return loc.map.n
    end
    return nil
end

-- 目的地のピンをこの階層に出してよいか。
-- MAP が分かっていればその番号だけ。未確認で複数枚あるときは、すべての地図には出さない。
function maps.dest_on_floor(floor, loc, floor_count)
    if not loc or not floor then return false end
    local want = maps.wanted_map(loc)
    if want then return floor.map_n == want end
    if loc.map and loc.map.kind == 'single' then return true end
    if (tonumber(floor_count) or 0) > 1 then return false end
    return true
end

-- 資料の場所から、出す階層（map_n）と注意
-- 戻り値: floor, reason
--   reason は nil（確定）、'unknown_map'（MAP未確認で複数あるので仮に選んだ）、
--   'unconfirmed'（対応未確定）、'no_map'（表にない）
function maps.pick_floor(data, loc, chosen_n)
    if not loc or not loc.zone_id then return nil, 'no_zone' end
    local z = loc.zone_id
    local list = maps.floors(data, z)
    local want
    if loc.map and loc.map.kind == 'number' and loc.map.n then want = loc.map.n end

    local floor
    if chosen_n then floor = maps.floor(data, z, chosen_n) end
    if not floor and want then floor = maps.floor(data, z, want) end
    if not floor and #list == 1 then floor = list[1] end
    if not floor and #list > 1 then floor = list[1] end

    if floor then
        -- 資料で MAP が未確認のまま複数あるときは、階層を選んでも警告を残す
        if #list > 1 and not want then return floor, 'unknown_map' end
        return floor, nil
    end
    if maps.is_unconfirmed(data, z) then return nil, 'unconfirmed' end
    return nil, 'no_map'
end

-- クエスト／手順から場所を決める（手順があればそれを優先）
function maps.location_for(data, progress, q, step_id)
    if not q then return nil, nil end
    if step_id then
        local s = data:step(step_id)
        if s and s.location and s.location.zone_id then return s.location, s end
    end
    if progress then
        local cur = progress:current_step(q.id)
        if cur and cur.location and cur.location.zone_id then return cur.location, cur end
    end
    for _, s in ipairs(q.steps or {}) do
        if s.location and s.location.zone_id then return s.location, s end
    end
    local sl = data:start_location(q)
    if sl and sl.zone_id then return sl, nil end
    return nil, nil
end

-- その地図のマス目の範囲。A–P / 1–16 を固定しない。
-- 換算は maps.BASE / MARGIN / CELL。地図ごとの列数・行数が資料にあればそれを使い、
-- 無ければ画像の内側に収まるマスだけを出す（0.1.275〜）。
function maps.grid_layout(floor, opts)
    opts = opts or {}
    local base = tonumber(opts.base) or maps.BASE
    local margin = maps.MARGIN
    local cell = maps.CELL
    if floor then
        if tonumber(floor.grid_margin) then margin = tonumber(floor.grid_margin) end
        if tonumber(floor.margin) then margin = tonumber(floor.margin) end
        if tonumber(floor.grid_cell) then cell = tonumber(floor.grid_cell) end
        if tonumber(floor.cell) then cell = tonumber(floor.cell) end
    end
    if tonumber(opts.margin) then margin = tonumber(opts.margin) end
    if tonumber(opts.cell) then cell = tonumber(opts.cell) end
    if cell == nil or cell <= 0 then cell = maps.CELL end
    if margin == nil then margin = 0 end
    -- 表示は 512px 基準の座標。画像サイズが違うときは、同じ UV をその大きさに合わせる
    local iw = tonumber(opts.image_w)
    local ih = tonumber(opts.image_h) or iw
    local w = base
    local h = base
    if iw and iw > 0 then w = base end
    if ih and iw and iw > 0 and ih > 0 and ih ~= iw then
        h = base * (ih / iw)
    end
    local function axis(first, limit)
        -- マスの矩形が画像の内側（0..limit）に完全に収まるものだけ
        local ids = {}
        local i, guard = 0, 0
        while guard < 40 do
            guard = guard + 1
            local a = first + i * cell
            local b = a + cell
            if a >= limit then break end
            if a >= -1e-6 and b <= limit + 1e-6 then
                ids[#ids + 1] = i
            elseif a > limit then
                break
            end
            i = i + 1
        end
        return ids
    end
    -- 明示の列数・行数（資料にあるときだけ。推測では付けない）
    local col_ids, row_ids
    local given_c = floor and (tonumber(floor.grid_cols) or tonumber(floor.cols))
    local given_r = floor and (tonumber(floor.grid_rows) or tonumber(floor.rows))
    if given_c and given_c > 0 then
        col_ids = {}
        for i = 0, math.floor(given_c) - 1 do col_ids[#col_ids + 1] = i end
    else
        col_ids = axis(margin, w)
    end
    if given_r and given_r > 0 then
        row_ids = {}
        for i = 0, math.floor(given_r) - 1 do row_ids[#row_ids + 1] = i end
    else
        row_ids = axis(margin, h)
    end
    local letters = {}
    for _, i in ipairs(col_ids) do
        if i >= 0 and i < 26 then letters[#letters + 1] = string.char(string.byte('A') + i) end
    end
    local rows = {}
    for _, i in ipairs(row_ids) do rows[#rows + 1] = i + 1 end
    return {
        margin = margin, cell = cell, base = base, w = w, h = h,
        col_ids = col_ids, row_ids = row_ids,
        letters = table.concat(letters),
        rows = rows,
        col_count = #col_ids, row_count = #row_ids,
        -- マス i の左／上（512px 基準）
        x_at = function (i) return margin + i * cell end,
        y_at = function (i) return margin + i * cell end,
        x_center = function (i) return margin + i * cell + cell / 2 end,
        y_center = function (i) return margin + i * cell + cell / 2 end,
    }
end

return maps
