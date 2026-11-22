--[[
  Astertrail - 頭上の印（見えている相手にだけ付ける）
  0.1.63〜：印の見た目はクエストの状態のアイコン（src/core/marks.lua の ICON_RANK を参照）。
  ミッションは金の六角形、未受注は黄色の丸に「!」、受けられないは赤の丸に「!」、進行中は空色の丸に「▶」、
  進められないは赤の丸に「‖」、目標達成は緑の丸に「✓」、くり返しは緑の二重の丸。
  討伐は珊瑚色の、角と牙のある怒った魔物の顔（0.1.202〜。以前は三角、0.1.201 は丸い顔）、ゲートガードは金色の盾。いずれも黒い縁と白い輪。
  黄・金の印の中の記号は濃い茶色（0.1.201〜。白だと読みにくい）。
  画面の外・未読み込みには出さない。??? のように名前が出ない調べる対象は、
  読み込まれている本体の座標に、公式 vana.world.place で出す（マス目の中央には置かない）。
]]

local theme = require('src.ui.theme')

local marks_core = require('src.core.marks')
local perf = require('src.core.perf')
local marks = {}

-- 地図のピン用：照合できた相手の本当の座標を覚えておく（同じゾーンにいるあいだだけ）。
-- 相手ごと（target_id）に、最後に見えた x, y（水平面）を残す。ゾーンが変わったら捨てる。
function marks.remember_positions(ui, zone_id, matched)
    local st = ui and ui.state
    if not st then return end
    zone_id = tonumber(zone_id)
    local lp = st.live_pos
    if not lp or lp.zone_id ~= zone_id then
        lp = { zone_id = zone_id, by_target = {} }
        st.live_pos = lp
    end
    if not zone_id then return end
    -- 0.1.213〜：場所が変わる相手（番号で見分ける相手・動く相手・???）は、いま見えていなければ忘れる。
    -- 消えた・別の場所に移った ??? の古い場所に、地図のピンが残らないように。
    lp.volatile = lp.volatile or {}
    local seen = {}
    for _, row in ipairs(matched or {}) do
        local ent = row.entity
        local x, y = ent and tonumber(ent.x), ent and tonumber(ent.y)
        if x and y then
            for _, w in ipairs(row.wanted or {}) do
                if w.target_id then
                    lp.by_target[w.target_id] = { x = x, y = y, z = ent and tonumber(ent.z) or nil }
                    seen[w.target_id] = true
                    if w.server_id or w.moves or w.name == '???' then lp.volatile[w.target_id] = true end
                end
            end
        end
    end
    for tid in pairs(lp.volatile) do
        if not seen[tid] then
            lp.by_target[tid] = nil
            lp.volatile[tid] = nil
        end
    end
end

-- 覚えている本当の座標（同じゾーンのときだけ）。無ければ nil。
function marks.live_position(ui, zone_id, target_id)
    local lp = ui and ui.state and ui.state.live_pos
    if not lp or not target_id or lp.zone_id == nil then return nil end
    if tonumber(zone_id) ~= lp.zone_id then return nil end
    return lp.by_target[target_id]
end

-- 見えている相手（0.1.217〜）：1フレームに1回だけ読む。頭上の印と地図で同じものを使う。
-- ui.state.now が同じあいだは前に読んだものを返す（now が無ければ毎回読む）。
function marks.frame_entities(ui)
    local plat = ui and ui.platform
    if not plat or not plat.visible_entities then return {} end
    local st = ui.state
    local now = st and st.now
    local c = st and st.frame_ents
    if c and now ~= nil and c.at == now and c.plat == plat then return c.rows end
    local rows = plat.visible_entities()
    if type(rows) ~= 'table' then rows = {} end
    if st and now ~= nil then st.frame_ents = { at = now, rows = rows, plat = plat } end
    return rows
end

local function grid_fn(ui, plat, zone_id)
    return function (ent, w)
        if ent.grid then return ent.grid end
        if plat and plat.entity_grid then
            local ok, g = pcall(plat.entity_grid, ent, w)
            if ok and g then return g end
        end
        return marks_core.grid_of(ui.data, zone_id, ent.x, ent.y, w and w.map_n)
    end
end

-- render の 0x200（出ている）。だれにも印が無いときは読めていないとみなして見ない（platform と同じ）
local function shown_filter(ents)
    local any = false
    for _, e in ipairs(ents) do
        local r = tonumber(e.render_flags)
        if r and math.floor(r / 0x200) % 2 == 1 then any = true; break end
    end
    if not any then return ents end
    local out = {}
    for _, e in ipairs(ents) do
        local r = tonumber(e.render_flags)
        if r == nil or math.floor(r / 0x200) % 2 == 1 then out[#out + 1] = e end
    end
    return out
end

-- 地図で見ている手順の相手の本当の座標（0.1.217〜）。
-- 「今」の手順なら頭上の印で覚えた座標。そうでなくても、自分がそのゾーンにいれば、
-- いま見えている相手から同じ見分け方で探す（印は付けない）。見えなくなったらそのフレームから nil。
function marks.step_live_position(ui, zone_id, step)
    if not step or not step.target then return nil end
    local p = marks.live_position(ui, zone_id, step.target)
    if p then return p end
    local pl = ui and ui.player
    if not pl or tonumber(pl.zone_id) == nil or tonumber(pl.zone_id) ~= tonumber(zone_id) then return nil end
    local plat = ui.platform
    if not plat or not plat.visible_entities then return nil end
    local w = marks_core.wanted_for_step(ui.data, step)
    if not w then return nil end
    if w.zone_id ~= nil and tonumber(w.zone_id) ~= tonumber(zone_id) then return nil end
    local st = ui.state
    local now = st and st.now
    local key = tostring(zone_id) .. '|' .. tostring(step.id) .. '|' .. tostring(step.target)
    local c = st and st.step_live
    if c and now ~= nil and c.at == now and c.key == key then return c.pos end
    local ok, ents = pcall(marks.frame_entities, ui)
    ents = shown_filter(ok and ents or {})
    local matched = marks_core.match({ w }, ents, { zone_id = zone_id, grid_of = grid_fn(ui, plat, zone_id) })
    local pos = nil
    local best = nil
    for _, row in ipairs(matched or {}) do
        local ent = row.entity
        local x, y = ent and tonumber(ent.x), ent and tonumber(ent.y)
        if x and y then
            local d = 0
            if tonumber(pl.x) and tonumber(pl.y) then d = (x - pl.x) ^ 2 + (y - pl.y) ^ 2 end
            if not best or d < best then
                best = d
                pos = { x = x, y = y, z = tonumber(ent.z) }
            end
        end
    end
    if st and now ~= nil then st.step_live = { at = now, key = key, pos = pos } end
    return pos
end

-- アイコンの大きさ（px）。16〜64、初期 28。
local function util_clamp_icon(v)
    local n = math.floor(tonumber(v) or 28)
    if n < 16 then n = 16 elseif n > 64 then n = 64 end
    return n
end

-- 公式 name_at の top は名前の上端。印はそのすぐ上。
-- to_screen は指定した世界点（頭）なので、少しだけ上げる。
function marks.anchor_y(sy, how, r)
    sy = tonumber(sy)
    r = tonumber(r) or 7
    if not sy then return nil end
    if how == 'name_at' or how == 'name_x' or how == 'name_top' then
        return sy - r - 4
    end
    return sy - r - 8
end

-- 公式 to_screen：z は高さで、上は z が小さい。頭は足元から高さを引く。
function marks.head_z(foot_z, model_size)
    foot_z = tonumber(foot_z) or 0
    local h = tonumber(model_size) or 1.5
    if h < 0.4 then h = 0.4 end
    return foot_z - h
end


local function draw_list(imgui)
    if imgui.GetBackgroundDrawList then
        local ok, dl = pcall(imgui.GetBackgroundDrawList)
        if ok and dl then return dl end
    end
    if imgui.GetForegroundDrawList then
        local ok, dl = pcall(imgui.GetForegroundDrawList)
        if ok and dl then return dl end
    end
    if imgui.GetWindowDrawList then
        local ok, dl = pcall(imgui.GetWindowDrawList)
        if ok and dl then return dl end
    end
    return nil
end

local function poly(dl, pts, fill, edge, white, edge_w)
    if dl.AddConvexPolyFilled then
        pcall(dl.AddConvexPolyFilled, dl, pts, fill)
    end
    if dl.AddPolyline then
        pcall(dl.AddPolyline, dl, pts, white, true, (edge_w or 2) + 2)
        pcall(dl.AddPolyline, dl, pts, edge, true, edge_w or 2)
    end
end

-- 円：黒縁＋白い輪＋塗り（地図のピンと同じ考え方）
local function circle(dl, x, y, r, fill)
    local segs = 16
    dl:AddCircleFilled({ x, y }, r + 3.2, theme.u32('ink', 0.92), segs)
    dl:AddCircleFilled({ x, y }, r + 1.6, theme.u32('paper', 1), segs)
    dl:AddCircleFilled({ x, y }, r, fill, segs)
    dl:AddCircle({ x, y }, r, theme.u32('ink', 0.95), segs, 1.4)
end

local function square(dl, x, y, r, fill)
    local s = r * 0.92
    local function pts(pad)
        return {
            { x - s - pad, y - s - pad }, { x + s + pad, y - s - pad },
            { x + s + pad, y + s + pad }, { x - s - pad, y + s + pad },
        }
    end
    if dl.AddConvexPolyFilled then
        pcall(dl.AddConvexPolyFilled, dl, pts(3.2), theme.u32('ink', 0.92))
        pcall(dl.AddConvexPolyFilled, dl, pts(1.6), theme.u32('paper', 1))
        pcall(dl.AddConvexPolyFilled, dl, pts(0), fill)
    else
        -- 退化するときでも印自体は出す
        circle(dl, x, y, r, fill)
        return
    end
    if dl.AddPolyline then
        pcall(dl.AddPolyline, dl, pts(0), theme.u32('ink', 0.95), true, 1.4)
    end
end

-- 討伐（0.1.201〜）：角と牙のある魔物の顔。コーラル色のまま、小さなサイズでも顔と角が分かるようにする
local function beast_pts(x, y, s)
    return {
        { x - 0.70 * s, y - 1.00 * s }, { x - 0.98 * s, y - 0.32 * s },
        { x - 0.90 * s, y + 0.22 * s }, { x - 0.52 * s, y + 0.80 * s },
        { x, y + 1.00 * s },
        { x + 0.52 * s, y + 0.80 * s }, { x + 0.90 * s, y + 0.22 * s },
        { x + 0.98 * s, y - 0.32 * s }, { x + 0.70 * s, y - 1.00 * s },
        { x + 0.24 * s, y - 0.40 * s }, { x, y - 0.28 * s }, { x - 0.24 * s, y - 0.40 * s },
    }
end

-- 凹んだ形なので、中心からの三角に分けて塗る（AddConvexPolyFilled を1回では谷が埋まってしまう）
local function fill_fan(dl, pts, col)
    if not dl.AddConvexPolyFilled then return false end
    local n = #pts
    local cx, cy = 0, 0
    for i = 1, n do cx, cy = cx + pts[i][1], cy + pts[i][2] end
    cx, cy = cx / n, cy / n
    for i = 1, n do
        pcall(dl.AddConvexPolyFilled, dl, { { cx, cy }, pts[i], pts[i % n + 1] }, col)
    end
    return true
end

local function beast(dl, x, y, r, fill)
    if not fill_fan(dl, beast_pts(x, y, r + 3.2), theme.u32('ink', 0.92)) then
        circle(dl, x, y, r, fill)
        return
    end
    fill_fan(dl, beast_pts(x, y, r + 1.6), theme.u32('paper', 1))
    fill_fan(dl, beast_pts(x, y, r), fill)
    if dl.AddPolyline then
        pcall(dl.AddPolyline, dl, beast_pts(x, y, r), theme.u32('ink', 0.95), true, 1.4)
    end
    -- 目と牙（小さくても消えないよう最小の大きさを決める）
    local dark = theme.u32('ic_glyph_dark', 1)
    local paper = theme.u32('paper', 1)
    local er = math.max(1.05, r * 0.15)
    local ex, ey = r * 0.30, y - r * 0.06
    if dl.AddCircleFilled then
        pcall(dl.AddCircleFilled, dl, { x - ex, ey }, er, dark, 10)
        pcall(dl.AddCircleFilled, dl, { x + ex, ey }, er, dark, 10)
        if r >= 6 then
            local hr = math.max(0.6, er * 0.32)
            pcall(dl.AddCircleFilled, dl, { x - ex - er * 0.2, ey - er * 0.25 }, hr, paper, 8)
            pcall(dl.AddCircleFilled, dl, { x + ex - er * 0.2, ey - er * 0.25 }, hr, paper, 8)
        end
    end
    if dl.AddConvexPolyFilled then
        local my = y + r * 0.32
        local lw, lh = r * 0.42, math.max(1.1, r * 0.10)
        pcall(dl.AddConvexPolyFilled, dl, {
            { x - lw, my - lh * 0.2 }, { x, my + lh * 0.6 }, { x + lw, my - lh * 0.2 },
        }, dark)
        local fw, fh = math.max(0.9, r * 0.09), math.max(1.6, r * 0.28)
        local fy = my - lh * 0.15
        local function fang(fx)
            pcall(dl.AddConvexPolyFilled, dl, { { fx - fw, fy }, { fx + fw, fy }, { fx, fy + fh } }, paper)
        end
        fang(x - r * 0.15)
        fang(x + r * 0.15)
    end
end

-- ゲートガード専用：盾（上が平ら、下が尖る）
local function shield(dl, x, y, r, fill)
    local function pts(pad)
        local w, h = r * 0.9 + pad, r * 1.15 + pad
        return {
            { x - w, y - h * 0.55 }, { x + w, y - h * 0.55 },
            { x + w, y + h * 0.15 }, { x, y + h }, { x - w, y + h * 0.15 },
        }
    end
    if dl.AddConvexPolyFilled then
        pcall(dl.AddConvexPolyFilled, dl, pts(3.2), theme.u32('ink', 0.92))
        pcall(dl.AddConvexPolyFilled, dl, pts(1.6), theme.u32('paper', 1))
        pcall(dl.AddConvexPolyFilled, dl, pts(0), fill)
    else
        circle(dl, x, y, r, fill)
        return
    end
    if dl.AddPolyline then
        pcall(dl.AddPolyline, dl, pts(0), theme.u32('ink', 0.95), true, 1.4)
    end
end

-- リピート：二重の丸
local function double_circle(dl, x, y, r, fill)
    circle(dl, x, y, r, fill)
    dl:AddCircle({ x, y }, r * 0.52, theme.u32('paper', 0.95), 16, 1.8)
    dl:AddCircle({ x, y }, r * 0.52, theme.u32('ink', 0.85), 16, 1.2)
end

-- 名声を教えてくれる人（0.1.69〜、自作の絵）：赤紫のふきだし（左下に尾）に白い星。
-- 丸・六角形・盾・魔物の顔・四角のどれとも違う形にして、ほかの印と見分けやすくする
local function fame_bubble(dl, x, y, r, fill)
    local function tail(pad)
        return { { x - r * 0.55 - pad, y + r * 0.35 }, { x - r * 0.05, y + r * 0.75 + pad * 0.3 },
            { x - r * 1.05 - pad * 1.2, y + r * 1.25 + pad } }
    end
    local cy = y - r * 0.08
    local segs = 18
    if dl.AddConvexPolyFilled then pcall(dl.AddConvexPolyFilled, dl, tail(3.2), theme.u32('ink', 0.92)) end
    dl:AddCircleFilled({ x, cy }, r + 3.2, theme.u32('ink', 0.92), segs)
    if dl.AddConvexPolyFilled then pcall(dl.AddConvexPolyFilled, dl, tail(1.6), theme.u32('paper', 1)) end
    dl:AddCircleFilled({ x, cy }, r + 1.6, theme.u32('paper', 1), segs)
    if dl.AddConvexPolyFilled then pcall(dl.AddConvexPolyFilled, dl, tail(0), fill) end
    dl:AddCircleFilled({ x, cy }, r, fill, segs)
    -- 白い五つの角の星（真ん中の五角形＋角の三角）
    local ro, ri = r * 0.62, r * 0.26
    local outer, inner = {}, {}
    for i = 0, 4 do
        local a1 = -math.pi / 2 + i * 2 * math.pi / 5
        local a2 = a1 + math.pi / 5
        outer[#outer + 1] = { x + ro * math.cos(a1), cy + ro * math.sin(a1) }
        inner[#inner + 1] = { x + ri * math.cos(a2), cy + ri * math.sin(a2) }
    end
    local white = theme.u32('paper', 1)
    if dl.AddConvexPolyFilled then
        pcall(dl.AddConvexPolyFilled, dl, inner, white)
        for i = 1, 5 do
            local prev = inner[(i + 3) % 5 + 1]
            pcall(dl.AddConvexPolyFilled, dl, { outer[i], inner[i], prev }, white)
        end
    end
end

-- 本の名前の横の くり返しの印（0.1.69〜、自作の絵）：丸く回る矢印2本（🔄 のような形。絵文字のフォントは使わない）
function marks.draw_cycle(dl, x, y, r, col)
    if not dl or not dl.AddPolyline then return end
    local lw = math.max(1.4, r * 0.32)
    local function arc(a0, a1)
        local pts, n = {}, 8
        for i = 0, n do
            local a = a0 + (a1 - a0) * i / n
            pts[#pts + 1] = { x + r * math.cos(a), y + r * math.sin(a) }
        end
        pcall(dl.AddPolyline, dl, pts, col, false, lw)
    end
    local function head(a)
        -- 矢じり：円の接線の向き（時計回り）に向いた三角
        local px, py = x + r * math.cos(a), y + r * math.sin(a)
        local tx, ty = -math.sin(a), math.cos(a)
        local nx, ny = math.cos(a), math.sin(a)
        local s = math.max(2.2, r * 0.62)
        local tri = { { px + tx * s, py + ty * s }, { px + nx * s * 0.8, py + ny * s * 0.8 }, { px - nx * s * 0.8, py - ny * s * 0.8 } }
        if dl.AddConvexPolyFilled then pcall(dl.AddConvexPolyFilled, dl, tri, col) end
    end
    local d = math.pi / 7
    arc(math.pi + d, 2 * math.pi - d)
    arc(d, math.pi - d)
    head(2 * math.pi - d)
    head(math.pi - d)
end

-- 六角形（ミッション）：金の六角形に濃い茶色のひし形（0.1.201〜）
local function hexagon(dl, x, y, r, fill)
    local function pts(pad)
        local out = {}
        for i = 0, 5 do
            local a = math.pi / 6 + i * math.pi / 3
            out[#out + 1] = { x + (r * 1.05 + pad) * math.cos(a), y + (r * 1.05 + pad) * math.sin(a) }
        end
        return out
    end
    if not dl.AddConvexPolyFilled then
        circle(dl, x, y, r, fill)
        return
    end
    pcall(dl.AddConvexPolyFilled, dl, pts(3.2), theme.u32('ink', 0.92))
    pcall(dl.AddConvexPolyFilled, dl, pts(1.6), theme.u32('paper', 1))
    pcall(dl.AddConvexPolyFilled, dl, pts(0), fill)
    if dl.AddPolyline then
        pcall(dl.AddPolyline, dl, pts(0), theme.u32('ink', 0.95), true, 1.4)
    end
    local d = r * 0.42
    pcall(dl.AddConvexPolyFilled, dl, { { x, y - d }, { x + d, y }, { x, y + d }, { x - d, y } },
        theme.u32('ic_glyph_dark', 1))
end

-- 丸の中の記号（! ▶ ‖ ✓）。小さくても読めるように太めに描く。
-- 黄・金の地には濃い茶（0.1.201〜。白だと読みにくい）。ほかは白のまま。
local function glyph(dl, kind, x, y, r, col)
    col = col or theme.u32('paper', 1)
    local lw = math.max(1.6, r * 0.28)
    local function rect(x1, y1, x2, y2)
        if dl.AddRectFilled then pcall(dl.AddRectFilled, dl, { x1, y1 }, { x2, y2 }, col) end
    end
    if kind == 'bang' then
        local w = math.max(1.2, r * 0.16)
        rect(x - w, y - r * 0.62, x + w, y + r * 0.18)
        pcall(dl.AddCircleFilled, dl, { x, y + r * 0.46 }, w * 1.15, col, 8)
    elseif kind == 'play' then
        local a = r * 0.5
        if dl.AddConvexPolyFilled then
            pcall(dl.AddConvexPolyFilled, dl, { { x - a * 0.7, y - a }, { x + a, y }, { x - a * 0.7, y + a } }, col)
        end
    elseif kind == 'pause' then
        local w, h, g = r * 0.17, r * 0.52, r * 0.2
        rect(x - g - w * 2, y - h, x - g, y + h)
        rect(x + g, y - h, x + g + w * 2, y + h)
    elseif kind == 'check' then
        if dl.AddPolyline then
            local pts = { { x - r * 0.5, y + r * 0.02 }, { x - r * 0.12, y + r * 0.42 }, { x + r * 0.55, y - r * 0.42 } }
            pcall(dl.AddPolyline, dl, pts, col, false, lw + 0.6)
        end
    end
end

-- 印の形と色（role は役割、または 0.1.63〜のアイコンの名前）
function marks.draw_shape(dl, role, x, y, r)
    if not dl or x == nil or y == nil then return end
    r = r or 7
    if role == 'main' then
        hexagon(dl, x, y, r, theme.u32('ic_main', 1))
    elseif role == 'sub' then
        circle(dl, x, y, r, theme.u32('ic_sub', 1)); glyph(dl, 'bang', x, y, r, theme.u32('ic_glyph_dark', 1))
    elseif role == 'unavailable' then
        circle(dl, x, y, r, theme.u32('ic_bad', 1)); glyph(dl, 'bang', x, y, r)
    elseif role == 'progress' then
        circle(dl, x, y, r, theme.u32('ic_progress', 1)); glyph(dl, 'play', x, y, r)
    elseif role == 'blocked' then
        circle(dl, x, y, r, theme.u32('ic_bad', 1)); glyph(dl, 'pause', x, y, r)
    elseif role == 'complete' then
        circle(dl, x, y, r, theme.u32('ic_done', 1)); glyph(dl, 'check', x, y, r)
    elseif role == 'hunt' then
        beast(dl, x, y, r, theme.u32('mob', 1))
    elseif role == 'examine' then
        square(dl, x, y, r, theme.u32('obj', 1))
    elseif role == 'guard' then
        shield(dl, x, y, r, theme.u32('gold', 1))
    elseif role == 'repeat' then
        double_circle(dl, x, y, r, theme.u32('ic_repeat', 1))
    elseif role == 'fame' then
        fame_bubble(dl, x, y, r, theme.u32('ic_fame', 1))
    else
        circle(dl, x, y, r, theme.u32('npc', 1))
    end
end

---------------------------------------------------------------------------
-- 足元の輪（0.1.171〜、t227-map）。印を付けた相手（読み込まれている相手だけ）の足元に、アイコンと同じ色の輪。
-- 公式 vana.world.marks（地面に沿い、手前の物にかくれる）。シーンの効果が使えないとき（graphics.info().active が false）は、
-- 公式 to_screen で円の点を画面に写して ImGui の線で描く。輪は近い順に 16 まで（公式が描くのも 16 まで）。
---------------------------------------------------------------------------

marks.RING_MAX = 16
local function hex(c)
    return string.format('#%02X%02X%02X', c[1], c[2], c[3])
end

-- matched（marks_core.match の結果）から輪の一覧を作る
function marks.ground_rings(ui, matched, player)
    local S = ui and ui.settings
    local SM = (S and S.marks) or {}
    if SM.show_rings == false then return {} end
    local settings_mod = require('src.core.settings')
    local size = tonumber(SM.ring_size) or 1
    local plat = ui.platform
    local out = {}
    local px, py = player and tonumber(player.x), player and tonumber(player.y)
    for _, row in ipairs(matched or {}) do
        local ent = row.entity
        if ent and not ent.dead then
            local x, y, z = tonumber(ent.x), tonumber(ent.y), tonumber(ent.z)
            local hb = tonumber(ent.hitbox_size)
            if plat and plat.game_entity and ent.index ~= nil then
                local ok, e = pcall(plat.game_entity, ent.index)
                if ok and type(e) == 'table' and tonumber(e.x) and tonumber(e.y) then
                    x, y, z = tonumber(e.x), tonumber(e.y), tonumber(e.z)
                    hb = tonumber(e.hitbox_size) or hb
                end
            end
            local look = row.icon or (row.wanted and row.wanted[1] and row.wanted[1].icon) or row.role
            if look == 'examine' or look == 'talk' then look = 'sub' end
            local c = settings_mod.ring_color(SM, look)
            if x and y and c then
                -- 大きさは当たり判定の大きさから（読めなければ 1）。小さすぎ・大きすぎは止める
                local r = (hb and hb > 0) and hb or 1
                if r < 0.6 then r = 0.6 elseif r > 6 then r = 6 end
                r = r * size
                local d = (px and py) and ((x - px) ^ 2 + (y - py) ^ 2) or 0
                local strength = settings_mod.ring_strength(SM)
                out[#out + 1] = { x = x, y = y, z = z or 0, radius = r, color = hex(c), strength = strength, kind = look, _d = d, _c = c }
            end
        end
    end
    table.sort(out, function (a, b) return a._d < b._d end)
    while #out > marks.RING_MAX do table.remove(out) end
    return out
end

-- 公式に渡す（使えなければ ImGui で描く）。戻り値: 'native' | 'imgui' | 'off' | 'none'
local function settings_core() return require('src.core.settings') end

-- 会話の窓（0.1.298〜。GAME-PC の /astertrail menus で確かめた：NPC のセリフは rem4line・rem4li2、選択肢は query）。
-- inline はどちらでも出るので数えない。query は会話でない「はい／いいえ」でも出ることがある
marks.TALK_WINDOWS = { rem4line = true, rem4li2 = true, query = true }
marks.NEUTRAL_WINDOWS = { inline = true }

-- ゲームの窓が開いているとき、会話かメニューか。戻り値: talk, menu
function marks.menu_kind(open, info)
    if open ~= true then return false, false end
    local talk, other, any = false, false, false
    local function look(list, field)
        if type(list) ~= 'table' then return end
        for _, x in ipairs(list) do
            local n = tostring(field and type(x) == 'table' and x[field] or x):lower()
            if marks.TALK_WINDOWS[n] then talk = true; any = true
            elseif not marks.NEUTRAL_WINDOWS[n] and n ~= '' then other = true; any = true end
        end
    end
    if type(info) == 'table' then
        look(info.rects, 'name')
        look(info.focused, nil)
    end
    -- 名前で分からないとき（印だけ・inline だけ）はメニューとして扱う（前と同じ）
    if not any then return false, true end
    return talk, other
end

-- いまの場面（0.1.296〜）。event＝自分の status 4（カットシーンなど）、combat＝status 1（戦闘中）、
-- menu＝ゲームのメニュー・会話の窓が開いている、chat＝チャット入力中。戻り値: { event=, combat=, menu=, chat= }
function marks.scenes_now(ui, need)
    local plat = ui and ui.platform
    local out = {}
    local st
    if (need.event or need.combat) and plat and plat.self_status then
        local ok, v = pcall(plat.self_status)
        if ok then st = tonumber(v) end
    end
    out.event = need.event and st == 4 or false
    out.combat = need.combat and st == 1 or false
    if need.menu or need.talk then
        -- 同じフレームで app が調べ済みならそれを使う（メニュー一覧を二重に読まない）
        local open, info
        if ui.state and ui.state.game_menu_open ~= nil then
            open, info = ui.state.game_menu_open, ui.state.game_menu_info
        elseif plat and plat.game_menu_state then
            local ok, o, i = pcall(plat.game_menu_state)
            if ok then open, info = o, i end
        end
        local talk, menu = marks.menu_kind(open == true, info)
        out.talk = need.talk and talk or false
        out.menu = need.menu and menu or false
    end
    if need.chat then
        if ui.state and ui.state.chat_open ~= nil then
            out.chat = ui.state.chat_open == true
        elseif plat and plat.chat_open then
            local ok, c = pcall(plat.chat_open)
            out.chat = ok and c == true
        end
    end
    return out
end

-- 今消すもの（隠す場面の設定と、いまの場面から）。戻り値: { rings=, icons=, quest=, names=, nearby=, all=, scene= } または nil
function marks.hide_now(ui)
    local SM = ui and ui.settings and ui.settings.marks or {}
    local HS = settings_core().hide_scenes_of(SM)
    local need, any = {}, false
    for sc, e in pairs(HS) do
        if e.on then
            for _, part in ipairs(settings_core().HIDE_PARTS) do
                if e[part] then need[sc] = true; any = true; break end
            end
        end
    end
    if not any then return nil end
    local now = marks.scenes_now(ui, need)
    local out, hit = {}, nil
    for _, sc in ipairs(settings_core().HIDE_SCENES) do
        if need[sc] and now[sc] then
            hit = hit or sc
            for _, part in ipairs(settings_core().HIDE_PARTS) do
                if HS[sc][part] then out[part] = true end
            end
        end
    end
    if not hit then return nil end
    out.scene = hit
    out.all = true
    for _, part in ipairs(settings_core().HIDE_PARTS) do
        if not out[part] then out.all = false end
    end
    return out
end

-- 今は輪を出さないか（隠す場面で「リング」を選んだ場面のどれかに入っている）
function marks.hide_rings_now(ui)
    local h = marks.hide_now(ui)
    return h ~= nil and h.rings == true
end

function marks.apply_rings(ui, rings)
    local plat = ui and ui.platform
    if not plat then return 'none' end
    rings = rings or {}
    local SM = ui.settings and ui.settings.marks or {}
    -- イベント中・会話中は輪を消す（初期オン）。
    -- status==4 はカットシーンなどのイベント。普通の会話は番号が 4 にならないことが多いので、
    -- 本を隠すときと同じ「ゲームのメニューが開いているか」も見る。
    if marks.hide_rings_now(ui) then
        rings = {}
    end
    local native = plat.rings_native and plat.rings_native()
    if plat.set_ground_rings and plat.rings_available and plat.rings_available() and native ~= false then
        local list = {}
        for i, r in ipairs(rings) do
            list[i] = { x = r.x, y = r.y, z = r.z, radius = r.radius, color = r.color, strength = r.strength }
        end
        local ok = plat.set_ground_rings(list)
        if ok then return (#list > 0) and 'native' or 'off' end
    end
    if plat.clear_ground_rings then plat.clear_ground_rings() end
    if #rings == 0 or not plat.world_to_screen then return 'off' end
    local imgui = ui.imgui
    local dl = imgui and draw_list(imgui)
    if not dl then return 'none' end
    for _, r in ipairs(rings) do
        local pts = {}
        local ok_all = true
        for i = 0, 23 do
            local a = i / 24 * math.pi * 2
            local ok, sx, sy = pcall(plat.world_to_screen, r.x + math.cos(a) * r.radius, r.y + math.sin(a) * r.radius, r.z)
            if ok and type(sx) == 'table' then sx, sy = sx.visible ~= false and sx.x or nil, sx.y end
            if not (ok and type(sx) == 'number' and type(sy) == 'number') then ok_all = false; break end
            pts[#pts + 1] = { sx, sy }
        end
        if ok_all and dl.AddPolyline then
            local c = r._c
            local u = function (al)
                local okc, v = pcall(imgui.GetColorU32, { c[1] / 255, c[2] / 255, c[3] / 255, al })
                return okc and v or theme.u32('accent', al)
            end
            local st = tonumber(r.strength) or 1
            if st < 0 then st = 0 end
            local al = 0.95 * (st <= 1 and st or 1)
            local ink_al = 0.6 * (st <= 1 and st or 1)
            local thick = 2.2 * (st <= 1 and 1 or math.min(st, 2))
            pcall(dl.AddPolyline, dl, pts, theme.u32('ink', ink_al), true, 4 * (st <= 1 and 1 or math.min(st, 1.5)))
            pcall(dl.AddPolyline, dl, pts, u(al), true, thick)
        end
    end
    return 'imgui'
end

-- 文字の行の中に状態のアイコンを1つ置く（トラッカー・本）。戻りは使った幅（px）
-- 置けないとき（アイコンなし）は nil。小さく描くので縁は細めにする
function marks.inline_icon(ui, icon, opts)
    local imgui = ui and ui.imgui
    if not imgui or not icon then return nil end
    opts = opts or {}
    local h = 14
    if imgui.GetTextLineHeight then
        local ok, v = pcall(imgui.GetTextLineHeight)
        if ok and tonumber(v) then h = tonumber(v) end
    end
    local gap = opts.gap or 4
    local x, y
    if imgui.GetCursorScreenPos then
        local ok, a, b = pcall(imgui.GetCursorScreenPos)
        if ok then
            if type(a) == 'table' then x, y = tonumber(a.x or a[1]), tonumber(a.y or a[2])
            elseif tonumber(a) then x, y = tonumber(a), tonumber(b) end
        end
    end
    if x and y and imgui.GetWindowDrawList then
        local ok, dl = pcall(imgui.GetWindowDrawList)
        if ok and dl then
            local r = math.max(3, h * 0.5 - 3.4)
            pcall(marks.draw_shape, dl, icon, x + h / 2, y + h / 2, r)
        end
    end
    if imgui.Dummy then pcall(imgui.Dummy, { h, h }) end
    if opts.tip ~= false and imgui.IsItemHovered then
        local ok, hov = pcall(imgui.IsItemHovered)
        if ok and hov and imgui.SetTooltip and ui.t then
            pcall(imgui.SetTooltip, opts.tip_text or ui.t('marks.icon.' .. icon))
        end
    end
    if imgui.SameLine then pcall(imgui.SameLine, 0, gap) end
    return h + gap
end

-- 文字の行に置いたときの幅（右揃えの計算用）
function marks.inline_icon_w(ui, icon, opts)
    local imgui = ui and ui.imgui
    if not imgui or not icon then return 0 end
    local h = 14
    if imgui.GetTextLineHeight then
        local ok, v = pcall(imgui.GetTextLineHeight)
        if ok and tonumber(v) then h = tonumber(v) end
    end
    return h + ((opts and opts.gap) or 4)
end

local function tip_text(ui, row)
    local t = ui.t
    local parts = {}
    local seen = {}
    for _, w in ipairs(row.wanted or {}) do
        local qref = w.quest_id or w.next_mission   -- ゲートガードは次のミッションの名前（0.1.65〜）
        local q = qref and ui.data:quest(qref)
        local qn = q and (q.name_ja_ref or q.name_en) or nil
        local key = (w.role or '') .. '|' .. (w.name or '') .. '|' .. (qn or '')
        if not seen[key] then
            seen[key] = true
            local look = w.icon
            if look and look ~= 'guard' and look ~= 'hunt' and look ~= 'fame' then
                parts[#parts + 1] = t('marks.tip.' .. look, { name = w.name, quest = qn or '' })
            elseif w.role == 'guard' then
                parts[#parts + 1] = t('marks.tip.guard', { name = w.name })
            elseif w.role == 'fame' then
                parts[#parts + 1] = t('marks.tip.fame', { name = w.name })
            elseif w.role == 'repeat' then
                parts[#parts + 1] = t('marks.tip.repeat', { name = w.name, quest = qn or '' })
            elseif w.role == 'hunt' then
                parts[#parts + 1] = t('marks.tip.hunt', { name = w.name, quest = qn or '' })
            elseif w.role == 'examine' then
                parts[#parts + 1] = t('marks.tip.examine', { name = w.name, quest = qn or '' })
            else
                parts[#parts + 1] = t('marks.tip.talk', { name = w.name, quest = qn or '' })
            end
        end
    end
    return table.concat(parts, '\n')
end

-- 収集して描く。戻りは診断用（見えている数、照合した数、描いた数、投影の成否）
-- 探す相手の一覧は重い（全クエストを見る）ので、毎フレームは作らない（0.1.210〜）。
-- ゾーン・進み具合・所持・設定が変わったときと、WANTED_EVERY 秒ごとだけ作り直す。
-- ジョブ・レベル・名声（受ける条件）は STATUS_EVERY 秒ごとに見比べる
marks.WANTED_EVERY = 60
marks.STATUS_EVERY = 1
local wanted_memo = { key = nil, list = nil, at = -1, status_sig = nil, status_at = -1 }

local function status_sig(st)
    if type(st) ~= 'table' then return '-' end
    local keys = {}
    for k in pairs(st) do keys[#keys + 1] = tostring(k) end
    table.sort(keys)
    local parts = {}
    for _, k in ipairs(keys) do
        local v = st[k]
        if type(v) == 'table' then
            local sub = {}
            for kk, vv in pairs(v) do
                if type(vv) ~= 'table' then sub[#sub + 1] = tostring(kk) .. '=' .. tostring(vv) end
            end
            table.sort(sub)
            parts[#parts + 1] = k .. '{' .. table.concat(sub, ',') .. '}'
        else
            parts[#parts + 1] = k .. '=' .. tostring(v)
        end
    end
    return table.concat(parts, ';')
end
marks._status_sig = status_sig

function marks.clear_wanted_cache()
    wanted_memo.key, wanted_memo.list, wanted_memo.at = nil, nil, -1
end

function marks.wanted_cached(ui, S, zone_id)
    local now = (ui.state and tonumber(ui.state.now)) or os.clock()
    local status = ui.player_status and ui.player_status() or nil
    local m = wanted_memo
    if m.status_sig == nil or now - m.status_at >= marks.STATUS_EVERY or now < m.status_at then
        m.status_sig = status_sig(status)
        m.status_at = now
    end
    local fame = not (S and S.marks and S.marks.show_fame_npcs == false)
    local debug = ui.state_buttons ~= nil and ui.state_buttons() or false
    local poss = ui.possession and ui.possession() or nil
    local key = tostring(zone_id) .. '|' .. tostring(ui.data) .. '|' .. tostring(ui.progress) .. '|'
        .. tostring(ui.progress and ui.progress.rev or 0) .. '|' .. m.status_sig
        .. '|' .. tostring(fame) .. '|' .. tostring(debug)
    local fresh = m.list and m.key == key and now - m.at < marks.WANTED_EVERY and now >= m.at
    if fresh and m.poss ~= poss then
        -- 所持は数秒ごとに読み直される。使った数だけ見比べ、同じなら作り直さない
        local have = ui.inventory_count
        for _, r in ipairs(m.asked or {}) do
            local v = have and have(r[1], r[2]) or nil
            if v ~= r[3] then fresh = false; break end
        end
        if fresh then m.poss = poss end
    end
    if fresh then return m.list end
    local t0 = perf.start()
    local asked = {}
    local have = ui.inventory_count and function (a, n)
        local v = ui.inventory_count(a, n)
        asked[#asked + 1] = { a, n, v }
        return v
    end or nil
    m.list = marks_core.in_zone(marks_core.wanted(ui.data, ui.progress, { have = have, status = status,
        fame = fame, debug = debug }), zone_id)
    perf.stop('marks.wanted', t0)
    perf.count('wanted_rebuild')
    m.key, m.at, m.poss, m.asked = key, now, poss, asked
    return m.list
end

function marks.draw(ui)
    local plat = ui and ui.platform
    local function clear()
        if plat and plat.clear_name_marks then
            pcall(plat.clear_name_marks)
        end
    end
    local S = ui and ui.settings
    local function clear_rings()
        if plat and plat.clear_ground_rings then pcall(plat.clear_ground_rings) end
    end
    if not S or not S.marks or not require('src.core.settings').marks_active(S) then
        clear()
        clear_rings()
        if plat and plat.clear_world_marks then pcall(plat.clear_world_marks) end
        return { skipped = true }
    end
    if not ui.state or not ui.state.ready then
        clear()
        clear_rings()
        return { skipped = true, why = 'not_ready' }
    end
    if not plat or not plat.visible_entities then
        clear()
        return { skipped = true, why = 'no_platform' }
    end
    -- 隠す場面（0.1.296〜。前は「イベント中はリングや名前を消す」）：場面ごとに選んだものだけ消す。
    -- 全部消すときはこれまでどおり何も描かない。UI の窓は触らない。
    local hide = marks.hide_now(ui)
    if hide and hide.all then
        clear()
        clear_rings()
        if plat.clear_world_marks then pcall(plat.clear_world_marks) end
        return { skipped = true, why = 'event', drawn = 0, nearby = 0, rings = 0 }
    end
    local player = ui.player or {}
    local zone_id = player.zone_id
    local wanted = marks.wanted_cached(ui, S, zone_id)
    local settings_mod = require('src.core.settings')
    -- 頭上のクエスト名と、調べる対象の名前（??? など）は別々の大きさ
    local scale = settings_mod.font_for(S, 'overhead_quest')
    local omin, omax = settings_mod.font_range('overhead_quest')   -- 0.1.210〜：0.8〜3.2
    if scale < omin then scale = omin elseif scale > omax then scale = omax end
    local under_scale = settings_mod.font_for(S, 'overhead_name')
    if under_scale < omin then under_scale = omin elseif under_scale > omax then under_scale = omax end
    -- 位置の調整（px、＋で右・下）。0 ならこれまでどおり
    local SM = S.marks or {}
    -- 調べるオブジェクト（examine）と、そのほか（話す・討伐・ゲートガード）で別々
    local offs_obj = settings_mod.offsets_for(SM, 'examine')
    local offs_other = settings_mod.offsets_for(SM, 'talk')
    -- 近くのオブジェクト名の位置（0.1.60〜）。クエストのオブジェクト名とは別
    local offs_near = settings_mod.near_offsets(SM)
    local function offs_of(role) return (role == 'examine') and offs_obj or offs_other end
    -- 文字の色（クエスト名はどのアイコンも同じ。オブジェクト名は ??? などの名前）
    local lc1, lc2 = settings_mod.text_colors(SM, 'label')
    local uc1, uc2 = settings_mod.text_colors(SM, 'under')
    -- 頭上の文字の背景の濃さ（0.1.215〜）。クエスト名とオブジェクト名で別
    local label_bg = settings_mod.label_bg_alpha(SM, 'label')
    local under_bg = settings_mod.label_bg_alpha(SM, 'under')
    local label_style = settings_mod.label_style(SM, 'label')
    local under_style = settings_mod.label_style(SM, 'under')
    local function with_shadow(it)
        -- 0.1.238：頭上の影箱（同じ文をもう一つ spawn してずらす）は、
        -- 0.1.237 で公式の spawn が書き込みアクセス違反を起こしたため作らない。
        -- メニューの影設定は、頭上には載せない。
        return it
    end
    -- ズームに合わせて位置を調整する（試し）。オフならこれまでどおり
    local zoom_follow = SM.zoom_follow ~= false
    -- 近づいても大きくしない（0.1.235〜）。初期オフ
    local no_enlarge_near = SM.no_enlarge_near == true
    -- 近くのオブジェクトの名前（0.1.58〜、初期はオフ）。クエストに関係ないものにも名前だけ
    -- 表示の4つ（0.1.59〜）。それぞれ名前のとおりのものだけを動かす
    local show_icons = SM.show_icons ~= false           -- アイコン（NPC・モンスター・調べるオブジェクト）
    local show_obj_names = SM.show_object_names ~= false -- クエストのオブジェクト名
    local show_nearby = SM.show_nearby_names == true     -- 近くのオブジェクト名（クエストに関係ないもの）
    -- 隠す場面で選んだものは、その場面のあいだだけ消す（0.1.296〜）
    if hide then
        if hide.icons then show_icons = false end
        if hide.names then show_obj_names = false end
        if hide.nearby then show_nearby = false end
    end
    if #wanted == 0 and not show_nearby then
        clear()
        clear_rings()
        return { wanted = 0, entities = 0, matched = 0, drawn = 0 }
    end
    local ents = marks.frame_entities(ui)
    local grid_of = grid_fn(ui, plat, zone_id)
    local matched = marks_core.match(wanted, ents, { zone_id = zone_id, grid_of = grid_of })
    marks.remember_positions(ui, zone_id, matched)
    local on_name, on_body = marks_core.split_for_draw(matched)
    -- 足元の輪（0.1.171〜）
    local rings = marks.ground_rings(ui, matched, player)
    local rok, rhow = pcall(marks.apply_rings, ui, rings)
    local rings_how = rok and rhow or 'error'

    -- 名前に箱を付ける公式 API（vana.world.attach）。名前と同じパスで描かれ、カメラでもずれない。
    -- ??? のように名前が出ない相手は attach では見えないので、本体の位置（公式 to_screen）に出す。
    -- 名前付きの相手を自前描画に落とすとカメラでずれるので、そちらは attach だけを使う。
    local can_attach = plat.set_name_marks
        and plat.attach_available and plat.attach_available()

    local icon_size = util_clamp_icon(S.marks and S.marks.icon_size)
    local function show_quest_name()
        if hide and hide.quest then return false end
        return S.marks and S.marks.show_quest_name == true
    end
    local function quest_label(w)
        if not show_quest_name() then return nil end
        if not w or not w.quest_id or not ui.data or not ui.data.quest then return nil end
        local q = ui.data:quest(w.quest_id)
        if not q then return nil end
        if S.language == 'en' then
            return q.name_en
        end
        return q.name_ja_ref or q.name_en
    end

    -- 同じ相手：印はいちばん優先の1つだけ。クエスト名の行には印を付けない（0.1.204〜）
    local function each_quest_layer(list, fn)
        list = list or {}
        local seen, uniq = {}, {}
        for _, w in ipairs(list) do
            local qid = w.quest_id
            if not (qid and seen[qid]) then
                if qid then seen[qid] = true end
                uniq[#uniq + 1] = w
            end
        end
        local icon_at
        if show_icons then
            for i, w in ipairs(uniq) do
                if w.icon and (not icon_at or marks_core.rank_of(w) < marks_core.rank_of(uniq[icon_at])) then
                    icon_at = i
                end
            end
        end
        -- 印は layer 0（名前のすぐ上）。クエスト名の行はその上に、印なしで重ねる
        local order = {}
        if icon_at then order[1] = icon_at end
        for i = 1, #uniq do
            if i ~= icon_at then order[#order + 1] = i end
        end
        for layer, idx in ipairs(order) do
            fn(uniq[idx], layer - 1, show_icons and idx == icon_at)
        end
    end

    local attach_how, attach_drawn = nil, 0
    if can_attach then
        local items = {}
        -- 同じ人の複数クエストは、優先の1件をすぐ上、ほかはその上に重ねる。
        -- 同じクエストが役割違いで二重にならないよう、quest_id でまとめる。
        for _, row in ipairs(on_name) do
            local ent = row.entity
            if ent and ent.index ~= nil then
                local list = row.wanted
                if not list or #list == 0 then
                    list = { { role = row.role or 'talk', icon = row.icon } }
                end
                each_quest_layer(list, function (w, layer, with_icon)
                    local role = w.role or row.role or 'talk'
                    local offs = offs_of(role)
                    local lab = quest_label(w)
                    if with_icon or lab then
                        items[#items + 1] = with_shadow({
                            no_icon = not with_icon,
                            index = ent.index,
                            role = role,
                            look = with_icon and w.icon or nil,
                            scale = scale,
                            icon = icon_size,
                            label = lab,
                            layer = layer,
                            mark_dx = offs.mark_dx, mark_dy = offs.mark_dy, zoom_follow = zoom_follow,
                            label_dx = offs.label_dx, label_dy = offs.label_dy,
                            label_color = lc1, label_color2 = lc2,
                            label_bg_alpha = label_bg, label_style = label_style,
                            no_enlarge_near = no_enlarge_near,
                        })
                    end
                end)
            end
        end
        if #items == 0 then
            -- 名前用だけ空にする。本体位置の印は消さない。
            pcall(plat.set_name_marks, {})
            attach_how = 'attach'
            attach_drawn = 0
        else
            local ok, r = pcall(plat.set_name_marks, items)
            if ok and r ~= false then
                attach_how = 'attach'
                if plat.attach_kind then
                    local k = plat.attach_kind()
                    if type(k) == 'string' and k ~= '' then
                        attach_how = 'attach:' .. k
                    end
                end
                attach_drawn = #items
            else
                -- 名前付きは自前描画に落とさない。??? の本体位置の印は後で出す。
                clear()
                attach_how = 'attach_failed'
                attach_drawn = 0
            end
        end
    else
        clear()
    end

    -- ??? は公式 vana.world.place で、読み込まれている本体の座標に置く。
    -- 置く点は相手そのものの x, y, z（公式 entity と同じ）。マス目の中央には置かない。
    -- 設定でオフなら、??? には印を出さない。
    -- 近くのオブジェクト（クエストに関係するものも含めて選ぶ）。二重にしないため、
    -- クエストのオブジェクトは自分の行で名前を出し、近くの名前だけの行には入れない。
    local near_all, near_of = {}, {}
    if show_nearby then
        near_all = marks_core.nearby_objects(ents, {
            px = player.x, py = player.y,
            info = plat.object_info and function (ent)
                local ok, info = pcall(plat.object_info, ent)
                return ok and info or nil
            end or nil,
        })
        for _, n in ipairs(near_all) do near_of[n.entity.index] = true end
    end
    local can_place = plat.set_world_marks
        and plat.place_available and plat.place_available()
    local place_how, place_drawn = nil, 0
    local nearby_drawn = 0
    if can_place then
        local items = {}
        for _, row in ipairs(on_body) do
            local ent = row.entity
            if ent and (ent.x ~= nil or ent.index ~= nil) then
                local x, y, z, up = ent.x, ent.y, ent.z, ent.model_size
                -- 公式の本体座標を優先（同じ相手の、ゲームが持っている位置）
                if plat.game_entity and ent.index ~= nil then
                    local ok, e = pcall(plat.game_entity, ent.index)
                    if ok and type(e) == 'table' and e.x ~= nil and e.y ~= nil then
                        x, y, z = e.x, e.y, e.z
                        if e.model_size then up = e.model_size end
                    end
                end
                if x ~= nil and y ~= nil then
                    -- 名前付きと同じく、複数クエストは重ねて出す。位置は種類ごとの設定に従う。
                    local list = row.wanted
                    if not list or #list == 0 then
                        list = { { role = row.role or 'examine', quest_id = row.quest_id, icon = row.icon } }
                    end
                    each_quest_layer(list, function (w, layer, with_icon)
                        local role = w.role or row.role or 'examine'
                        local offs = offs_of(role)
                        local lab = quest_label(w)
                        -- 名前：「クエストのオブジェクト名」がオン、または「近くのオブジェクト名」がオンで近くにある
                        -- 位置：両方オンならクエストのオブジェクト名の位置、近くの方だけで出すときは近くのオブジェクト名の位置
                        local uname, ndx, ndy = nil, offs.name_dx, offs.name_dy
                        if show_obj_names or (show_nearby and near_of[ent.index]) then
                            uname = (w and w.name and w.name ~= '' and w.name) or '???'
                            if not show_obj_names then ndx, ndy = offs_near.name_dx, offs_near.name_dy end
                        end
                        if with_icon or lab or uname then
                            items[#items + 1] = with_shadow({
                                no_icon = not with_icon,
                                x = x,
                                y = y,
                                z = z or 0,
                                up = up,
                                role = role,
                                look = with_icon and w.icon or nil,
                                scale = scale,
                                under_scale = under_scale,
                                mark_dx = offs.mark_dx, mark_dy = offs.mark_dy, zoom_follow = zoom_follow,
                                name_dx = ndx, name_dy = ndy,
                                label_dx = offs.label_dx, label_dy = offs.label_dy,
                                label_color = lc1, label_color2 = lc2,
                                under_color = uc1, under_color2 = uc2,
                                label_bg_alpha = label_bg, under_bg_alpha = under_bg,
                                label_style = label_style, under_style = under_style,
                                no_enlarge_near = no_enlarge_near,
                                icon = icon_size,
                                key = (ent.index ~= nil) and (tostring(ent.index) .. ':' .. tostring(layer)) or nil,
                                index = ent.index,
                                label = lab,
                                under = uname,
                                layer = layer,
                            })
                        end
                    end)
                end
            end
        end
        -- 近くのオブジェクト：名前だけ（アイコン・クエスト名なし）。色はオブジェクト名の色、位置は調べるオブジェクト用
        nearby_drawn = 0
        if show_nearby then
            local skip = {}
            for _, row in ipairs(matched) do
                if row.entity and row.entity.index ~= nil then skip[row.entity.index] = true end
            end
            local near = {}
            for _, n in ipairs(near_all) do
                if not skip[n.entity.index] then near[#near + 1] = n end
            end
            for _, n in ipairs(near) do
                local ent = n.entity
                items[#items + 1] = with_shadow({
                    x = ent.x, y = ent.y, z = ent.z or 0, up = ent.model_size,
                    role = 'examine', name_only = true,
                    scale = scale, under_scale = under_scale,
                    mark_dx = offs_obj.mark_dx, mark_dy = offs_obj.mark_dy, zoom_follow = zoom_follow,
                    name_dx = offs_near.name_dx, name_dy = offs_near.name_dy,
                    under_color = uc1, under_color2 = uc2,
                    under_bg_alpha = under_bg, under_style = under_style,
                    no_enlarge_near = no_enlarge_near,
                    icon = icon_size,
                    key = 'near:' .. tostring(ent.index),
                    index = ent.index,
                    under = n.name,
                    layer = 0,
                })
                nearby_drawn = nearby_drawn + 1
            end
        end
        if #items == 0 then
            if plat.set_world_marks then pcall(plat.set_world_marks, {}) end
        else
            local ok, r, n = pcall(plat.set_world_marks, items)
            if ok and r ~= false then
                place_drawn = tonumber(n) or #items
                place_how = 'place'
                if plat.place_kind then
                    local k = plat.place_kind()
                    if type(k) == 'string' and k ~= '' then
                        place_how = 'place:' .. k
                    end
                end
            else
                place_how = 'place_failed'
                place_drawn = 0
                if plat.place_error then
                    local err = plat.place_error()
                    if err then place_how = 'place_failed:' .. tostring(err) end
                end
            end
        end
    elseif plat.clear_world_marks then
        pcall(plat.clear_world_marks)
    end

    -- place が使えない・失敗したときの控え、および attach が使えないときの名前付き
    local imgui_rows = {}
    if show_icons and (not can_place or place_drawn == 0) then
        for _, row in ipairs(on_body) do
            imgui_rows[#imgui_rows + 1] = { row = row, body = true }
        end
    end
    if not can_attach and show_icons then
        for _, row in ipairs(on_name) do
            imgui_rows[#imgui_rows + 1] = { row = row, body = false }
        end
    end

    local imgui = ui.imgui
    local dl = imgui and draw_list(imgui) or nil
    local r = 7 * scale
    local mouse
    if imgui and imgui.GetIO then
        local ok, io = pcall(imgui.GetIO)
        if ok and io and io.MousePos then mouse = io.MousePos end
    end
    local drawn, projected, failed = attach_drawn, 0, 0
    local hover
    local body_drawn = 0
    for _, item in ipairs(imgui_rows) do
        local row = item.row
        local ent = row.entity
        if not ent then
            failed = failed + 1
        else
            local sx, sy, how
            -- 本体の位置：名前の位置（name_at）は使わない
            if item.body and plat.entity_world_screen then
                local ok, a, b, c = pcall(plat.entity_world_screen, ent)
                if ok and type(a) == 'number' and type(b) == 'number' then
                    sx, sy, how = a, b, c or 'to_screen'
                end
            end
            if not sx and (not item.body) and plat.entity_screen then
                local ok, a, b, c = pcall(plat.entity_screen, ent)
                if ok and type(a) == 'number' and type(b) == 'number' then
                    sx, sy, how = a, b, c or 'entity'
                end
            end
            if not sx and plat.world_to_screen then
                local hz = marks.head_z(ent.z, ent.model_size)
                local ok, a, b, c = pcall(plat.world_to_screen, ent.x, ent.y, hz)
                if ok and type(a) == 'number' and type(b) == 'number' then
                    sx, sy, how = a, b, c or 'to_screen'
                elseif ok and type(a) == 'table' and a.visible and a.x then
                    sx, sy, how = a.x, a.y, 'world'
                end
            end
            if not sx and type(ent.sx) == 'number' and type(ent.sy) == 'number' then
                sx, sy, how = ent.sx, ent.sy, how or 'given'
            end
            if sx and sy then
                projected = projected + 1
                sy = marks.anchor_y(sy, how, r)
                if dl then
                    marks.draw_shape(dl, row.icon or row.role, sx, sy, r)
                end
                drawn = drawn + 1
                if item.body then body_drawn = body_drawn + 1 end
                row.sx, row.sy = sx, sy
                if mouse and mouse.x and mouse.y then
                    local dx, dy = mouse.x - sx, mouse.y - sy
                    if dx * dx + dy * dy <= (r + 8) * (r + 8) then
                        hover = row
                    end
                end
            else
                failed = failed + 1
            end
        end
    end
    if hover and imgui and imgui.BeginTooltip then
        local ok = pcall(function ()
            imgui.BeginTooltip()
            imgui.Text(tip_text(ui, hover))
            imgui.EndTooltip()
        end)
        if not ok and imgui.EndTooltip then pcall(imgui.EndTooltip) end
    end

    -- 本体の印は place が先。ImGui 控えが出せたときは body も足す。
    if place_drawn > 0 then
        drawn = attach_drawn + place_drawn + body_drawn
        -- body_drawn は控えの ImGui。place 成功時は出さないので 0 のはず。
    end

    local parts = {}
    if #on_name > 0 and attach_how then
        parts[#parts + 1] = attach_how
    end
    if place_drawn > 0 and place_how then
        parts[#parts + 1] = place_how
    elseif body_drawn > 0 then
        parts[#parts + 1] = 'body'
    elseif #on_body > 0 then
        parts[#parts + 1] = place_how or 'body_failed'
    elseif #parts == 0 then
        if attach_how then
            parts[#parts + 1] = attach_how
        elseif not can_attach then
            parts[#parts + 1] = 'imgui'
        end
    end
    local how = table.concat(parts, '+')
    if how == '' then how = attach_how or place_how or 'none' end

    local who = {}
    for _, row in ipairs(matched) do
        if row.name and row.name ~= '' then
            who[#who + 1] = row.name
        end
    end

    -- 診断：見えている ??? のマス目
    local seen_q = {}
    for _, ent in ipairs(ents) do
        if marks_core.on_body(ent.name) then
            local g = grid_of(ent, nil) or ent.grid or '?'
            seen_q[#seen_q + 1] = tostring(g)
        end
    end
    local detail
    if #on_body > 0 or #seen_q > 0 then
        detail = '??? 見える' .. tostring(#seen_q)
        if #seen_q > 0 then
            detail = detail .. '（' .. table.concat(seen_q, ',') .. '）'
        end
        detail = detail .. ' 照合' .. tostring(#on_body) .. ' 配置' .. tostring(place_drawn + body_drawn)
    end

    return {
        wanted = #wanted, entities = #ents, matched = #matched,
        drawn = drawn, projected = projected, failed = failed, how = how,
        body = place_drawn + body_drawn, who = table.concat(who, ', '),
        place = place_drawn, detail = detail, nearby = nearby_drawn,
        rings = #rings, rings_how = rings_how,
        err = (place_how and place_how:find('failed', 1, true) and place_how) or nil,
    }
end

marks.wanted = marks_core.wanted
marks.match = marks_core.match
marks.in_zone = marks_core.in_zone
marks.on_body = marks_core.on_body
marks.split_for_draw = marks_core.split_for_draw
marks.norm_name = marks_core.norm_name
marks.core = marks_core

return marks
