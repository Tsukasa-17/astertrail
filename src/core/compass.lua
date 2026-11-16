--[[
  Astertrail - コンパス（0.1.173〜、t251）
  いまいるエリアで受けられるクエストを近い順に。1行はクエスト名・受注NPC名・距離だけ。
  - 受けられるか：本の一覧・相手の印と同じ分け方（src/core/marks.lua の quest_icon）。'sub'（未受注）と
    'repeat'（くり返し）だけ出す。受けられないと分かったもの（'unavailable'）・受注中・くり返せない完了は出さない。
    受けられない理由が資料にあるだけ（確かめられない）のものは、本と同じく出して印を付ける。
  - 距離：受注NPCが見えていれば（同じ名前・生きている）その相手の実際の位置、見えていなければ資料の座標
    （pos があればそれ、無ければマス目の中央。マス目からのときは「約」）。地図が何枚かあって MAP が分からないときや、
    座標もマス目も無いときは距離なし（いちばん下）。推測はしない。
  - 出す範囲（0.1.201〜）：opts.max_dist（ヤルム）以内だけ出す。初期値は 30。設定で 5〜100（5きざみ）に変えられる。
    距離が分からないものは、範囲を指定しているときは出さない。opts.max_dist が無ければ、今までどおり距離の上限なし
    （いちばん下に距離不明を残し、MAX_ROWS まで）。
]]

local marks = require('src.core.marks')
local maps = require('src.core.maps')

local compass = {}

compass.MAX_ROWS = 40
compass.RANGE_DEFAULT = 30
compass.RANGE_MIN = 5
compass.RANGE_MAX = 100
compass.RANGE_STEP = 5

-- 表示距離（ヤルム）。5〜100 の 5 きざみ。壊れた値は初期値 30
function compass.clamp_range(v)
    local n = tonumber(v)
    if not n then n = compass.RANGE_DEFAULT end
    n = math.floor((n / compass.RANGE_STEP) + 0.5) * compass.RANGE_STEP
    if n < compass.RANGE_MIN then n = compass.RANGE_MIN
    elseif n > compass.RANGE_MAX then n = compass.RANGE_MAX end
    return n
end

-- マス目の中央（512px 基準）→ ゲームの x, y（maps.world_px の逆）
function compass.grid_world(floor, loc)
    if not floor or not loc then return nil end
    local scale = math.abs(tonumber(floor.scale) or 0)
    if scale == 0 then return nil end
    local cells = maps.grid_cells(loc.grid)
    if not cells then return nil end
    local sx, sy = 0, 0
    for _, c in ipairs(cells) do
        local x, y = maps.grid_px(c.col, c.row)
        sx, sy = sx + x, sy + y
    end
    local bx, by = sx / #cells, sy / #cells
    local wx = (bx + (tonumber(floor.offset_x) or 0)) / (scale * 0.2)
    local wy = -(by + (tonumber(floor.offset_y) or 0)) / (scale * 0.2)
    return wx, wy
end

-- 資料の場所の x, y。戻り値: x, y, approx（マス目から＝true）。分からなければ nil
function compass.loc_world(data, loc)
    if not loc or not loc.zone_id then return nil end
    local pos = loc.pos
    if type(pos) == 'table' and tonumber(pos.x) and tonumber(pos.y) then
        return tonumber(pos.x), tonumber(pos.y), false
    end
    local floor, why = maps.pick_floor(data, loc)
    if not floor or why == 'unknown_map' then return nil end
    local x, y = compass.grid_world(floor, loc)
    if not x then return nil end
    return x, y, true
end

local function dist(ax, ay, bx, by)
    local dx, dy = ax - bx, ay - by
    return math.sqrt(dx * dx + dy * dy)
end

-- 見えている相手のうち、名前が同じで生きている、いちばん近いもの
local function seen(ents, name, px, py)
    if type(ents) ~= 'table' or not name then return nil end
    local best, bd
    for _, e in ipairs(ents) do
        if e.name == name and not e.dead and tonumber(e.x) and tonumber(e.y) then
            local d = (px and py) and dist(px, py, e.x, e.y) or 0
            if not bd or d < bd then best, bd = e, d end
        end
    end
    return best
end

-- 行を作る。player = { zone_id, x, y }、ents = 見えている相手（無くてもよい）
-- opts = { status = …, have = …, max_dist = ヤルム }（max_dist があればその距離以内だけ）
function compass.rows(data, progress, player, ents, opts)
    local out = {}
    local zone = player and tonumber(player.zone_id)
    if not data or not progress or not zone then return out end
    opts = opts or {}
    local max_dist = (opts.max_dist ~= nil) and compass.clamp_range(opts.max_dist) or nil
    local px, py = player and tonumber(player.x), player and tonumber(player.y)
    for _, q in ipairs(data.quests or {}) do
        if q.kind ~= 'mission' and data:start_zone(q) == zone then
            local icon = marks.quest_icon(data, progress, q, { status = opts.status, have = opts.have })
            if icon == 'sub' or icon == 'repeat' then
                local npc = data:start_npc_name(q)
                local row = { qid = q.id, icon = icon, npc = npc,
                              reasons = (progress:state(q.id) == 'not_accepted') and (q.lock_reasons or {}) or {} }
                local e = seen(ents, npc, px, py)
                if e and px and py then
                    row.dist, row.approx, row.seen = dist(px, py, e.x, e.y), false, true
                elseif px and py then
                    local x, y, approx = compass.loc_world(data, data:start_location(q))
                    if x then row.dist, row.approx = dist(px, py, x, y), approx end
                end
                if max_dist ~= nil and (not row.dist or row.dist > max_dist) then
                    -- 範囲指定あり：距離不明と範囲の外は出さない
                else
                    out[#out + 1] = row
                end
            end
        end
    end
    table.sort(out, function (a, b)
        if a.dist and b.dist then
            if a.dist ~= b.dist then return a.dist < b.dist end
        elseif a.dist or b.dist then
            return a.dist ~= nil
        end
        return a.qid < b.qid
    end)
    while #out > compass.MAX_ROWS do out[#out] = nil end
    return out
end

-- 距離の文字（ヤルム、1 の位まで）。approx なら「約」
function compass.dist_text(t, row)
    if not row or not row.dist then return t('compass.dist_unknown') end
    local n = math.floor(row.dist + 0.5)
    return t(row.approx and 'compass.dist_approx' or 'compass.dist', { n = n })
end

return compass
