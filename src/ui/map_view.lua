--[[
  Astertrail - 地図の窓
  手順の場所にピンを出す。地図画像は同梱せず、読めたときだけクライアントの DAT を表示する。
  読めない・未確定のときは、マス目の簡易方眼に戻す（別の地図では代用しない）。
  マス目だけのピンは参考位置で、正確な NPC の位置とは出さない。
  0.1.60〜：「相手：」で、そのクエストの相手を一覧から選んで切り替えられる。キー・パッドでも選べるよう、選択枠も出す。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local theme = require('src.ui.theme')
local maps = require('src.core.maps')
local labels = require('src.ui.labels')
local CT = require('src.ui.colored_text')
local marks_ui = require('src.ui.marks')
local exits = require('src.core.exits')
local marks_core = require('src.core.marks')

local map_view = {}

local COLS = 'ABCDEFGHIJKLMNOP'

-- 羊皮紙の地図でも埋もれないよう、黒い縁と白い輪を付ける
local function halo(dl, sx, sy, fill, r, segs)
    dl:AddCircleFilled({ sx, sy }, r + 4, theme.u32('ink', 0.92), segs)
    dl:AddCircleFilled({ sx, sy }, r + 2, theme.u32('paper', 1), segs)
    dl:AddCircleFilled({ sx, sy }, r, fill, segs)
    dl:AddCircle({ sx, sy }, r, theme.u32('ink', 0.95), segs, 1.6)
end

local function add_quest_mark(dl, sx, sy)
    halo(dl, sx, sy, theme.u32('pin', 1), 10, 16)
end

-- 場所の候補（0.1.213〜）：小さい白抜きの丸。ピン（塗りの丸）より小さく、見分けがつくように
local function add_candidate_mark(dl, sx, sy)
    dl:AddCircleFilled({ sx, sy }, 6, theme.u32('ink', 0.85), 12)
    dl:AddCircleFilled({ sx, sy }, 4.6, theme.u32('paper', 0.95), 12)
    dl:AddCircle({ sx, sy }, 3.2, theme.u32('pin', 1), 12, 2)
end

local function add_player_mark(dl, sx, sy)
    -- 菱形（頂点 4）＋中心。クエストの丸ピンと見分けがつくように
    halo(dl, sx, sy, theme.u32('player', 1), 12, 4)
    dl:AddCircleFilled({ sx, sy }, 3.5, theme.u32('ink', 0.95), 8)
end

-- 自分の矢印（0.1.171〜）：向いている方へ尖った矢じり＋広がる輪（現在地の目印）。
-- heading はゲームのラジアン（0＝東）。地図は北が上なので、画面では (cos h, sin h) の向き。
-- ov.t は秒（輪の動き）。ov.reduce（動きを減らす）なら輪は止めて出す。向きが読めなければ菱形のまま。
function map_view.arrow_points(sx, sy, r, heading)
    local c, s = math.cos(heading), math.sin(heading)
    local function at(f, l) return { sx + c * f - s * l, sy + s * f + c * l } end
    return at(r * 1.25, 0), at(-r * 0.85, r * 0.8), at(-r * 0.35, 0), at(-r * 0.85, -r * 0.8)
end

local function add_player_arrow(dl, sx, sy, heading, ov)
    ov = ov or {}
    local col = theme.u32('player', 1)
    -- 現在地の輪：1.6 秒ごとに外へ広がって消える（動きを減らすときは止まった二重の輪）
    if ov.reduce or not ov.t then
        dl:AddCircle({ sx, sy }, 19, theme.u32('player', 0.55), 32, 2)
    else
        local k = (ov.t % 1.6) / 1.6
        dl:AddCircle({ sx, sy }, 12 + 18 * k, theme.u32('player', 0.85 * (1 - k)), 32, 2.4)
        local k2 = ((ov.t + 0.8) % 1.6) / 1.6
        dl:AddCircle({ sx, sy }, 12 + 18 * k2, theme.u32('player', 0.85 * (1 - k2)), 32, 2.4)
    end
    dl:AddCircleFilled({ sx, sy }, 13, theme.u32('player', 0.16), 24)
    if heading == nil then
        add_player_mark(dl, sx, sy)
        return
    end
    local r = 11
    local tip, bl, notch, br = map_view.arrow_points(sx, sy, r + 2.5, heading)
    -- 黒い縁（少し大きい矢じり）→ 白 → 色
    dl:AddTriangleFilled(tip, bl, notch, theme.u32('ink', 0.95))
    dl:AddTriangleFilled(tip, notch, br, theme.u32('ink', 0.95))
    tip, bl, notch, br = map_view.arrow_points(sx, sy, r + 1, heading)
    dl:AddTriangleFilled(tip, bl, notch, theme.u32('paper', 1))
    dl:AddTriangleFilled(tip, notch, br, theme.u32('paper', 1))
    tip, bl, notch, br = map_view.arrow_points(sx, sy, r - 1, heading)
    dl:AddTriangleFilled(tip, bl, notch, col)
    dl:AddTriangleFilled(tip, notch, br, col)
end

-- 見えている範囲の外にいるとき、ふちに小さな矢印（そちらに自分がいる）
local function add_edge_arrow(dl, x1, y1, x2, y2, sx, sy)
    local cx, cy = (x1 + x2) / 2, (y1 + y2) / 2
    local dx, dy = sx - cx, sy - cy
    if dx == 0 and dy == 0 then return end
    local hw, hh = (x2 - x1) / 2 - 12, (y2 - y1) / 2 - 12
    local k = math.min(hw / math.max(1e-6, math.abs(dx)), hh / math.max(1e-6, math.abs(dy)))
    local ex, ey = cx + dx * k, cy + dy * k
    local tip, bl, notch, br = map_view.arrow_points(ex, ey, 8, math.atan2(dy, dx))
    dl:AddTriangleFilled(tip, bl, notch, theme.u32('ink', 0.9))
    dl:AddTriangleFilled(tip, notch, br, theme.u32('ink', 0.9))
    tip, bl, notch, br = map_view.arrow_points(ex, ey, 6.5, math.atan2(dy, dx))
    dl:AddTriangleFilled(tip, bl, notch, theme.u32('player', 1))
    dl:AddTriangleFilled(tip, notch, br, theme.u32('player', 1))
end

-- となりのエリアへの出口（0.1.171〜）：青緑の丸に白い「›」。乗せると行き先、押すとその地図
local function add_exit_mark(dl, sx, sy, hot)
    local r = hot and 9 or 7.5
    halo(dl, sx, sy, theme.u32('zone', 1), r, 20)
    local w = r * 0.45
    if dl.AddPolyline then
        pcall(dl.AddPolyline, dl, { { sx - w * 0.6, sy - w }, { sx + w * 0.6, sy }, { sx - w * 0.6, sy + w } },
            theme.u32('paper', 1), false, 2.2)
    end
end

-- 行き先で立つ位置（出口から開いたとき）：二重の輪
local function add_arrive_mark(dl, sx, sy)
    dl:AddCircle({ sx, sy }, 15, theme.u32('ink', 0.9), 32, 4)
    dl:AddCircle({ sx, sy }, 15, theme.u32('zone', 1), 32, 2.4)
    dl:AddCircle({ sx, sy }, 8, theme.u32('zone', 0.9), 24, 2)
end

-- 出口から来たとき、立つ位置に広がる輪（0.1.178〜、t286）。数回広がってから消える。
-- age = その地図で初めて見えてからの秒。戻り値: 描く輪 { { r, alpha }, ... }（終わったら空）
map_view.PULSE_N, map_view.PULSE_PERIOD, map_view.PULSE_FADE = 3, 0.9, 0.6
function map_view.arrive_pulse(age, reduce)
    local out = {}
    age = tonumber(age)
    if not age or age < 0 then return out end
    local total = map_view.PULSE_N * map_view.PULSE_PERIOD
    local fade = map_view.PULSE_FADE
    if age >= total + fade then return out end
    -- 最後は全体を薄くして消す
    local master = 1
    if age > total then master = 1 - (age - total) / fade end
    if reduce then
        -- 動きを減らす：広がらない明るい輪が、同じ時間で薄くなるだけ
        local k = math.min(1, age / (total + fade))
        out[1] = { r = 24, alpha = 0.9 * (1 - k) }
        return out
    end
    for i = 0, map_view.PULSE_N - 1 do
        local k = (age - i * map_view.PULSE_PERIOD) / map_view.PULSE_PERIOD
        if k >= 0 and k < 1.6 and age <= total + fade then
            local kk = math.min(1, k)
            local a = (1 - kk) * 0.95 * master
            if a > 0.01 then out[#out + 1] = { r = 15 + 34 * kk, alpha = a } end
        end
    end
    return out
end

local function add_arrive_pulse(dl, sx, sy, age, reduce)
    for _, ring in ipairs(map_view.arrive_pulse(age, reduce)) do
        dl:AddCircle({ sx, sy }, ring.r, theme.u32('ink', ring.alpha * 0.6), 40, 4.5)
        dl:AddCircle({ sx, sy }, ring.r, theme.u32('zone', ring.alpha), 40, 2.6)
    end
end

-- 近くにいる討伐の相手（0.1.171〜。0.1.201〜は魔物の顔。頭上・本・トラッカーと同じ形）
local function add_mob_mark(dl, sx, sy)
    marks_ui.draw_shape(dl, 'hunt', sx, sy, 7)
end

-- 地図の上の印をまとめて描く。to_screen(base_x, base_y) → sx, sy（範囲の外なら nil と外の座標）。
-- 戻り値: マウスの下の出口（無ければ nil）
local function draw_overlay(dl, to_screen, box, pin, me, ov, mouse)
    ov = ov or {}
    local hot
    for _, m in ipairs(ov.mobs or {}) do
        local sx, sy = to_screen(m.base_x, m.base_y)
        if sx then add_mob_mark(dl, sx, sy) end
    end
    for _, c in ipairs(ov.cands or {}) do
        local sx, sy = to_screen(c.base_x, c.base_y)
        if sx then add_candidate_mark(dl, sx, sy) end
    end
    if ov.arrive then
        local sx, sy = to_screen(ov.arrive.base_x, ov.arrive.base_y)
        if sx then
            if ov.arrive.age then add_arrive_pulse(dl, sx, sy, ov.arrive.age, ov.reduce) end
            add_arrive_mark(dl, sx, sy)
        end
    end
    for _, e in ipairs(ov.exits or {}) do
        local sx, sy = to_screen(e.base_x, e.base_y)
        if sx then
            local near = mouse and mouse.x and ((mouse.x - sx) ^ 2 + (mouse.y - sy) ^ 2) <= 11 * 11
            if near and not hot then hot = e end
            add_exit_mark(dl, sx, sy, near)
        end
    end
    local qpins = ov.quest_pins
    if qpins and #qpins > 0 then
        for _, qp in ipairs(qpins) do
            if qp and not qp.off and qp.base_x ~= nil then
                local sx, sy = to_screen(qp.base_x, qp.base_y)
                if sx then add_quest_mark(dl, sx, sy) end
            end
        end
    elseif pin and not pin.off and pin.base_x ~= nil then
        local sx, sy = to_screen(pin.base_x, pin.base_y)
        if sx then add_quest_mark(dl, sx, sy) end
    end
    if me and not me.off and me.base_x ~= nil then
        local sx, sy, ox, oy = to_screen(me.base_x, me.base_y)
        if sx then
            add_player_arrow(dl, sx, sy, ov.heading, ov)
        elseif ox and box then
            add_edge_arrow(dl, box[1], box[2], box[3], box[4], ox, oy)
        end
    end
    return hot
end
map_view._draw_overlay_for_test = draw_overlay

-- 窓の余りに合わせて正方形で出す（上限は設けない。引き延ばした分だけ大きくする）
local function content_square(imgui, reserve)
    local aw, ah
    local a = imgui.GetContentRegionAvail and imgui.GetContentRegionAvail()
    if type(a) == 'table' then
        aw = tonumber(a.x or a[1])
        ah = tonumber(a.y or a[2])
    elseif type(a) == 'number' then
        aw = a
        local ok, h = pcall(function () return select(2, imgui.GetContentRegionAvail()) end)
        if ok then ah = tonumber(h) end
    end
    aw = aw or 420
    ah = ah or 500
    reserve = reserve or 110
    return math.max(240, math.min(aw, math.max(0, ah - reserve)))
end

local function loc_text(D, t, loc)
    if not loc then return t('loc.unknown') end
    return D:location_text(loc, t)
end

-- 512px 基準の方眼（画像が無いときの案内）
local function draw_grid(imgui, size, pin, highlight, player_pin, ov, mouse)
    local dl = imgui.GetWindowDrawList and imgui.GetWindowDrawList()
    local ok, pos = pcall(function () return imgui.GetCursorScreenPos() end)
    local x0, y0
    if ok and pos then
        if type(pos) == 'table' then x0 = pos.x or pos[1]; y0 = pos.y or pos[2]
        elseif type(pos) == 'number' then
            local y
            ok, y = pcall(function () return select(2, imgui.GetCursorScreenPos()) end)
            x0, y0 = pos, ok and y or 0
        end
    end
    size = size or 400
    local label = 22
    local gx = (x0 or 0) + label
    local gy = (y0 or 0) + label
    local scale = size / maps.BASE
    local function px(v) return v * scale end
    local hot

    if dl and x0 then
        pcall(function ()
            dl:AddRectFilled({ gx, gy }, { gx + size, gy + size }, theme.u32('bg', 0.95), 2)
            dl:AddRect({ gx, gy }, { gx + size, gy + size }, theme.u32('border', 0.8), 2, 0, 1)
            -- マス目（16px 余白の内側に 16×16）
            for i = 0, 16 do
                local a = maps.MARGIN + i * maps.CELL
                local c = theme.u32('border', (i == 0 or i == 16) and 0.85 or 0.35)
                dl:AddLine({ gx + px(a), gy + px(maps.MARGIN) },
                           { gx + px(a), gy + px(maps.BASE - maps.MARGIN) }, c, 1)
                dl:AddLine({ gx + px(maps.MARGIN), gy + px(a) },
                           { gx + px(maps.BASE - maps.MARGIN), gy + px(a) }, c, 1)
            end
            -- 列・行の記号
            for i = 0, 15 do
                local cx = gx + px(maps.MARGIN + i * maps.CELL + maps.CELL / 2)
                local letter = COLS:sub(i + 1, i + 1)
                dl:AddText({ cx - 4, gy - 16 }, theme.u32('muted', 1), letter)
                local cy = gy + px(maps.MARGIN + i * maps.CELL + maps.CELL / 2)
                local num = tostring(i + 1)
                dl:AddText({ gx - 18, cy - 7 }, theme.u32('muted', 1), num)
            end
            if highlight and highlight.col and highlight.row then
                local hx = maps.MARGIN + highlight.col * maps.CELL
                local hy = maps.MARGIN + (highlight.row - 1) * maps.CELL
                dl:AddRectFilled(
                    { gx + px(hx), gy + px(hy) },
                    { gx + px(hx + maps.CELL), gy + px(hy + maps.CELL) },
                    theme.u32('accent', 0.28), 0)
            end
            hot = draw_overlay(dl, function (bx, by) return gx + px(bx), gy + px(by) end,
                { gx, gy, gx + size, gy + size }, pin, player_pin, ov, mouse)
        end)
    end
    if imgui.Dummy then imgui.Dummy({ label + size, label + size }) end
    local clicked = false
    if hot and imgui.IsMouseClicked then
        local ok, c = pcall(imgui.IsMouseClicked, 0)
        clicked = ok and c and true or false
    end
    return hot, clicked
end

-- 拡大（マウスホイール）。1倍〜MAX_ZOOM倍。拡大中は左ドラッグで動かす。
local MAX_ZOOM = 4
local ZOOM_STEP = 1.25

local function xy(v, b)
    if type(v) == 'table' then return tonumber(v.x or v[1]), tonumber(v.y or v[2]) end
    if type(v) == 'userdata' then
        local ok, x, y = pcall(function () return v.x, v.y end)
        if ok then return tonumber(x), tonumber(y) end
        return nil, nil
    end
    return tonumber(v), tonumber(b)
end

-- 見えている範囲（0〜1 の左上 ox, oy と倍率 z）を、はみ出さないように直す
local function clamp_view(view)
    if view.z < 1 then view.z = 1 elseif view.z > MAX_ZOOM then view.z = MAX_ZOOM end
    local span = 1 / view.z
    if view.ox < 0 then view.ox = 0 elseif view.ox > 1 - span then view.ox = 1 - span end
    if view.oy < 0 then view.oy = 0 elseif view.oy > 1 - span then view.oy = 1 - span end
end
map_view.clamp_view = clamp_view

-- ホイール1回ぶんの拡大・縮小。マウスの下の点が動かないようにする（fx, fy は窓の中の 0〜1）
function map_view.zoom_at(view, wheel, fx, fy)
    if not wheel or wheel == 0 then return false end
    local before = view.z
    local z = before * (wheel > 0 and ZOOM_STEP or (1 / ZOOM_STEP)) ^ math.min(3, math.abs(wheel))
    if z < 1.01 then z = 1 end
    if z > MAX_ZOOM then z = MAX_ZOOM end
    if z == before then return false end
    local px = view.ox + fx / before
    local py = view.oy + fy / before
    view.z = z
    view.ox = px - fx / z
    view.oy = py - fy / z
    clamp_view(view)
    return true
end

-- 画像の上にピンを重ねる（拡大中は見えている範囲だけ。外にはみ出たピンは出さない）
local function draw_image(imgui, tex, iw, ih, show_w, pin, player_pin, view, ov)
    view = view or { z = 1, ox = 0, oy = 0 }
    clamp_view(view)
    local span = 1 / view.z
    local ok
    ok = pcall(function ()
        if view.z > 1 then
            imgui.Image(tex, { show_w, show_w }, { view.ox, view.oy }, { view.ox + span, view.oy + span })
        else
            imgui.Image(tex, { show_w, show_w })
        end
    end)
    if not ok then return false end
    local dl = imgui.GetWindowDrawList and imgui.GetWindowDrawList()
    -- Image のあとカーソルは下に進んでいるので、直前のアイテム矩形を使う
    local r1, r2, r3, r4
    if imgui.GetItemRectMin and imgui.GetItemRectMax then
        local aok, a, b = pcall(imgui.GetItemRectMin)
        local bok, c, d = pcall(imgui.GetItemRectMax)
        if aok then r1, r2 = xy(a, b) end
        if bok then r3, r4 = xy(c, d) end
    end
    if not (r1 and r3) then return true end
    local w = r3 - r1
    -- 画像の上に見えないボタンを重ねて、ホイールとドラッグを受ける（窓が動かないように）
    local hovered, active, pressed = false, false, false
    pcall(function ()
        if imgui.SetCursorScreenPos and imgui.InvisibleButton then
            local cx, cy = xy(imgui.GetCursorScreenPos())
            imgui.SetCursorScreenPos({ r1, r2 })
            pressed = imgui.InvisibleButton('##astertrail_map_view', { w, r4 - r2 }) and true or false
            hovered = imgui.IsItemHovered() and true or false
            active = imgui.IsItemActive() and true or false
            if cx and cy then imgui.SetCursorScreenPos({ cx, cy }) end
        end
    end)
    if hovered or active then
        -- GetIO は表ではなく userdata のことがあるので、型は見ずに読む
        local io_ok, io = pcall(imgui.GetIO)
        if io_ok and io then
            local wok, wv = pcall(function () return io.MouseWheel end)
            local wheel = (wok and tonumber(wv)) or 0
            if hovered and wheel ~= 0 and w > 0 then
                local mx, my = xy(imgui.GetMousePos())
                if mx and my then
                    map_view.zoom_at(view, wheel, (mx - r1) / w, (my - r2) / w)
                end
            end
            if active and view.z > 1 and w > 0 then
                local dok, dv = pcall(function () return io.MouseDelta end)
                local dx, dy
                if dok and dv then dx, dy = xy(dv) end
                if dx and dy and (dx ~= 0 or dy ~= 0) then
                    view.dragged = (view.dragged or 0) + math.abs(dx) + math.abs(dy)
                    view.ox = view.ox - dx / w / view.z
                    view.oy = view.oy - dy / w / view.z
                    clamp_view(view)
                end
            end
        end
    end
    local hot
    if dl then
        local s = w / maps.BASE * view.z
        local offx = view.ox * maps.BASE
        local offy = view.oy * maps.BASE
        local function to_screen(bx, by)
            local sx = r1 + (bx - offx) * s
            local sy = r2 + (by - offy) * s
            if sx < r1 or sx > r3 or sy < r2 or sy > r4 then return nil, nil, sx, sy end
            return sx, sy
        end
        local mouse
        if hovered then
            local mx, my = xy(imgui.GetMousePos())
            if mx and my then mouse = { x = mx, y = my } end
        end
        pcall(function ()
            if dl.PushClipRect then dl:PushClipRect({ r1, r2 }, { r3, r4 }, true) end
            hot = draw_overlay(dl, to_screen, { r1, r2, r3, r4 }, pin, player_pin, ov, mouse)
            if dl.PopClipRect then dl:PopClipRect() end
        end)
    end
    -- ドラッグで動かしたあとの離しは「押した」にしない
    local clicked = pressed and (view.dragged or 0) < 6
    if not active then view.dragged = 0 end
    return true, hot, clicked
end

map_view._draw_image_for_test = draw_image

-- 「相手：」で選べる相手（0.1.60〜）。そのクエストの手順に出てくる相手（NPC・調べるオブジェクトなど）で、
-- 手順に場所（ゾーン）があるもの。同じ相手は一つにまとめ、値はその相手が出てくる手順の id。
-- モンスターは座標が無いことが多いので、詳細の「相手：」と同じく入れない。
-- prefer: 今の地図の手順（同じ相手なら、その手順を値にする）
function map_view.target_choices(D, q, prefer, t)
    local out, by = {}, {}
    if not q then return out end
    for _, s in ipairs(q.steps or {}) do
        local tn = s.target and D:target_name(s.target)
        local tg = s.target and D:target(s.target)
        local kind = (tg and tg.kind) or 'npc'
        if tn and kind ~= 'mob' and s.location and s.location.zone_id then
            local key = tostring(s.target)
            local c = by[key]
            if not c then
                local zone = s.location.zone_name or (D.zone_name and D:zone_name(s.location.zone_id))
                c = { value = s.id, label = zone and (tn .. '（' .. zone .. '）') or tn, target = s.target, kind = kind }
                by[key] = c
                out[#out + 1] = c
            end
            if prefer and s.id == prefer then c.value = s.id end
        end
    end
    return out
end

-- 地図の移り変わり（0.1.171〜）。戻るで前の地図に戻れるよう、今の地図を積んでおく
local KEEP = { 'quest', 'step', 'loc', 'map_n', 'arrive', 'arrive_pending', 'mob', 'browse' }
local function push_back(info)
    info.back = info.back or {}
    local snap = {}
    for _, k in ipairs(KEEP) do snap[k] = info[k] end
    info.back[#info.back + 1] = snap
    if #info.back > 30 then table.remove(info.back, 1) end
end

-- 覚えた出口の階（ui.exit_floors が無ければ空）
local function learned_of(ui)
    if ui.exit_floors then
        local ok, l = pcall(ui.exit_floors)
        if ok and type(l) == 'table' then return l end
    end
    return {}
end

-- DAT から出した出口の階（0.1.176〜。ui.dat_floors が無ければ空）
local function dat_of(ui)
    if ui.dat_floors then
        local ok, l = pcall(ui.dat_floors)
        if ok and type(l) == 'table' then return l end
    end
    return {}
end

local function want_dat(ui, zone_id)
    if ui.want_dat_floors and zone_id then pcall(ui.want_dat_floors, zone_id) end
end

-- 出口から、となりのエリアの地図へ。来たときに立つ位置に輪を出す
function map_view.go(ui, e)
    local info = ui.state.map
    if not info or not e or not e.to then return end
    local D = ui.data
    push_back(info)
    info.quest, info.step, info.mob = nil, nil, nil
    info.browse = true
    info.loc = { zone_id = e.to, zone_name = D:zone_name(e.to) }
    info.arrive = nil
    info.arrive_pending = nil
    info.map_n = nil
    if e.at then
        info.arrive = { zone_id = e.to, x = e.at.x, y = e.at.y }
        info.map_n = exits.map_n_of(D, maps, learned_of(ui), e.to, e.at.x, e.at.y, dat_of(ui))
        if info.map_n == nil and #maps.floors(D, e.to) > 1 then
            -- 階が DAT から分かったら、その MAP に切り替える（自分で MAP を選ぶまで）
            info.arrive_pending = true
            want_dat(ui, e.to)
        end
    end
    info.view = nil
end

-- いまいるエリアの地図へ（いまいる MAP が分かればその MAP）
function map_view.go_here(ui)
    local info = ui.state.map
    local pl = ui.player
    if not info or not pl or not pl.zone_id then return end
    push_back(info)
    info.quest, info.step, info.mob, info.arrive = nil, nil, nil, nil
    info.browse = true
    info.loc = { zone_id = pl.zone_id, zone_name = ui.data:zone_name(pl.zone_id) }
    local f = ui.state.floor
    info.map_n = (f and tonumber(f.zone_id) == tonumber(pl.zone_id)) and f.map_n or nil
    info.view = nil
end

function map_view.go_back(ui)
    local info = ui.state.map
    if not info or not info.back or #info.back == 0 then return false end
    local snap = table.remove(info.back)
    for _, k in ipairs(KEEP) do info[k] = snap[k] end
    info.view = nil
    return true
end

-- 見ている手順のピンと候補（0.1.217〜 で分けた）。本物が見えていればピン1つ（kind='live'）で候補なし、
-- 見えていなければ候補（あれば）。fixed_loc は場所を選んで見ているとき（そのときは相手を探さない）
function map_view.step_pin(ui, D, floor, loc, step, fixed_loc)
    local pin = maps.pin(floor, loc, maps.BASE)
    -- 相手が同じゾーンで読み込まれていれば（NPCも ??? などのオブジェクトも）、本当の座標に出す
    -- 0.1.217〜：「今」の手順でなくても、見ている手順の相手が見えていれば本当の座標に1つだけ出す
    if floor and loc and step and step.target and not fixed_loc then
        local live = marks_ui.step_live_position(ui, loc.zone_id, step)
        if live then
            local bx, by = maps.world_px(floor, live.x, live.y)
            if bx and bx >= 0 and by >= 0 and bx <= maps.BASE and by <= maps.BASE then
                pin = { x = bx, y = by, kind = 'live', base_x = bx, base_y = by,
                        grid = maps.grid_name(bx, by) }
            end
        end
    end
    -- 場所が変わる ??? など（0.1.213〜）：本物が見えていなければ、候補の場所を小さく全部出す
    local cands = nil
    if floor and loc and step and not fixed_loc and not (pin and pin.kind == 'live') then
        local list_c = marks_core.candidates_for(D, step)
        if list_c then
            cands = {}
            for _, c in ipairs(list_c) do
                local bx, by = maps.world_px(floor, c.x, c.y)
                if bx and bx >= 0 and by >= 0 and bx <= maps.BASE and by <= maps.BASE then
                    cands[#cands + 1] = { base_x = bx, base_y = by, grid = maps.grid_name(bx, by) }
                end
            end
            if #cands == 0 then cands = nil else pin = nil end
        end
    end
    return pin, cands
end

-- 手順に並んだ複数の話し相手のピン（0.1.228〜）。座標がある相手だけ。同じゾーンのもの。
-- 見えていれば本当の座標、なければ資料の LSB 座標。
function map_view.talk_pins(ui, D, floor, loc, step, fixed_loc)
    local out = {}
    if not floor or not loc or not step or fixed_loc then return out end
    if not D or not D.listed_talk_targets then return out end
    local ids = D:listed_talk_targets(step)
    if #ids == 0 then return out end
    for _, id in ipairs(ids) do
        local tg = D:target(id)
        local tloc = tg and tg.location
        if tloc and tonumber(tloc.zone_id) == tonumber(loc.zone_id) then
            local live = marks_ui.live_position and marks_ui.live_position(ui, loc.zone_id, id)
            local x, y
            if live and tonumber(live.x) and tonumber(live.y) then
                x, y = tonumber(live.x), tonumber(live.y)
            elseif tloc.pos and tloc.pos.x ~= nil and tloc.pos.y ~= nil then
                x, y = tonumber(tloc.pos.x), tonumber(tloc.pos.y)
            end
            if x and y then
                local bx, by = maps.world_px(floor, x, y)
                if bx and bx >= 0 and by >= 0 and bx <= maps.BASE and by <= maps.BASE then
                    out[#out + 1] = {
                        x = bx, y = by, base_x = bx, base_y = by,
                        kind = live and 'live' or 'data',
                        grid = maps.grid_name(bx, by),
                        target = id,
                    }
                end
            end
        end
    end
    return out
end

-- 近くにいる討伐の相手（0.1.171〜）。いまいるゾーンで、読み込まれている相手だけ。
-- 名前が同じ・生きている・ターゲットできる（読めるときだけ見る）。0.5 秒ごとに探し直す。
-- 戻り値: list（近い順。{ x, y, dist }）または nil, 理由（'other_zone' | 'no_platform'）
function map_view.find_mobs(ui, info, zone_id)
    local plat = ui.platform
    if not plat or not plat.visible_entities then return nil, 'no_platform' end
    local pl = ui.player
    if not pl or tonumber(pl.zone_id) ~= tonumber(zone_id) then return nil, 'other_zone' end
    local now = (ui.state and ui.state.now) or 0
    local c = info.mob_cache
    if c and c.zone == tonumber(zone_id) and c.name == info.mob.name and now - c.at < 0.5 then return c.list end
    local want = marks_core.norm_name(info.mob.name)
    local list = {}
    local ok, ents = pcall(plat.visible_entities)
    for _, ent in ipairs(ok and ents or {}) do
        if want and ent.name and marks_core.norm_name(ent.name) == want and not ent.dead
            and ent.kind ~= 'pc' and tonumber(ent.x) and tonumber(ent.y) then
            local good = true
            if plat.game_entity and ent.index ~= nil then
                local gok, e = pcall(plat.game_entity, ent.index)
                if gok and type(e) == 'table' and e.valid_target == false then good = false end
            end
            if good then
                local d
                if tonumber(pl.x) and tonumber(pl.y) then
                    d = math.sqrt((ent.x - pl.x) ^ 2 + (ent.y - pl.y) ^ 2)
                end
                list[#list + 1] = { x = tonumber(ent.x), y = tonumber(ent.y), dist = d, index = ent.index }
            end
        end
    end
    table.sort(list, function (a, b) return (a.dist or 1e9) < (b.dist or 1e9) end)
    info.mob_cache = { zone = tonumber(zone_id), name = info.mob.name, at = now, list = list }
    return list
end

function map_view.draw(ui)
    local t, imgui = ui.t, ui.imgui
    local st = ui.state
    local info = st.map
    if not info then ui.close_window('map'); return end
    if ui.settings.map and ui.settings.map.enabled == false then
        -- 設定でオフでも、今開いている窓はそのまま（閉じるまで）
    end
    local D, P = ui.data, ui.progress
    local q = info.quest and D:quest(info.quest)
    local loc, step = maps.location_for(D, P, q, info.step)
    if info.loc then loc = info.loc end
    local name = 'map'
    local open = { true }
    local title = t('map.title')
    if loc and loc.zone_name then title = loc.zone_name .. ' · ' .. title end
    local drawing = window.begin(ui, name, { title = title, open = open, operable = true })
    if drawing then
        ui.status_line()
        -- 戻る・現在地（0.1.171〜）
        local nav_n = 0
        if info.back and #info.back > 0 then
            if W.button(ui, name, 'nav_back', t('map.back'), { section = 'nav', row = 'n', small = true }) then
                map_view.go_back(ui)
                q = info.quest and D:quest(info.quest)
                loc, step = maps.location_for(D, P, q, info.step)
                if info.loc then loc = info.loc end
            end
            nav_n = nav_n + 1
        end
        if ui.player and ui.player.zone_id then
            if nav_n > 0 then W.same(ui) end
            if W.button(ui, name, 'nav_here', t('map.here'), { section = 'nav', row = 'n', small = true }) then
                map_view.go_here(ui)
                q = nil
                loc, step = info.loc, nil
            end
        end
        if q then
            theme.TextColored(imgui, theme.col('accent'), labels.qname(q))
            if step and (step.next_line_ja or step.order) then
                W.muted(ui, string.format('%s %s',
                    step.order and (tostring(step.order) .. '.') or '',
                    step.next_line_ja or ''))
            end
        end
        -- 相手：（0.1.60〜）。一覧から選ぶと、その相手の手順の場所に地図を切り替える。マウスでもキー・パッドでも選べる
        if q and not info.loc then
            local choices = map_view.target_choices(D, q, info.step, t)
            if #choices > 0 then
                local cur_v = nil
                for _, c in ipairs(choices) do if c.value == info.step then cur_v = c.value end end
                if cur_v == nil and step and step.target then
                    for _, c in ipairs(choices) do if c.target == step.target then cur_v = c.value end end
                end
                local changed, v = W.combo(ui, name, 'map_target', t('map.target'), cur_v, choices,
                    { section = 'target', row = 't', width = 260, placeholder = t('map.target_none') })
                if changed and v and v ~= info.step then
                    info.step = v
                    info.map_n = nil
                    info.view = nil
                    loc, step = maps.location_for(D, P, q, info.step)
                end
            end
        end
        if info.mob and info.mob.name then
            W.ctext(ui, t('map.mob_target', { name = info.mob.name }), CT.add({}, info.mob.name, 'mob'))
        end
        if loc then
            local terms = {}
            if loc.zone_name then CT.add(terms, loc.zone_name, 'zone') end
            W.ctext(ui, t('detail.where', { loc = loc_text(D, t, loc) }), terms)
        else
            W.colored(ui, 'warn', t('map.no_zone'))
        end

        local floor, reason
        local a0 = info.arrive
        if loc and info.arrive_pending and a0 and tonumber(a0.zone_id) == tonumber(loc.zone_id) then
            local mn = exits.map_n_of(D, maps, learned_of(ui), loc.zone_id, a0.x, a0.y, dat_of(ui))
            if mn then
                if info.map_n ~= mn then info.view = nil end
                info.map_n = mn
                info.arrive_pending = nil
            end
        end
        if loc then
            floor, reason = maps.pick_floor(D, loc, info.map_n)
            if floor and info.map_n == nil then info.map_n = floor.map_n end
        end
        local list = loc and maps.floors(D, loc.zone_id) or {}
        -- ゲームが教えてくれた、いまいる MAP（同じゾーンで、表にあるときだけ）
        local here_n = nil
        local cur = st.floor
        if cur and loc and cur.map_n and tonumber(cur.zone_id) == tonumber(loc.zone_id)
            and ui.player and tonumber(ui.player.zone_id) == tonumber(loc.zone_id) then
            here_n = cur.map_n
        end
        if #list > 0 then
            for i, f in ipairs(list) do
                if i > 1 then W.same(ui) end
                local lab = t('map.floor', { n = tostring(f.map_n) })
                if info.map_n == f.map_n then lab = '◆ ' .. lab else lab = '◇ ' .. lab end
                if here_n and here_n == f.map_n and #list > 1 then lab = lab .. t('map.floor_here') end
                if W.button(ui, name, 'fl_' .. tostring(f.map_n), lab, { section = 'floors', row = 'f', small = true }) then
                    if info.map_n ~= f.map_n then info.view = nil end
                    info.map_n = f.map_n
                    info.arrive_pending = nil
                    floor, reason = maps.pick_floor(D, loc, f.map_n)
                end
            end
        end
        info.view = info.view or { z = 1, ox = 0, oy = 0 }
        if info.view.z > 1 then
            if #list > 0 then W.same(ui) end
            if W.button(ui, name, 'zoom_reset', t('map.zoom_reset', { z = string.format('%.1f', info.view.z) }),
                { section = 'floors', row = 'f', small = true }) then
                info.view = { z = 1, ox = 0, oy = 0 }
            end
        end
        if reason == 'unknown_map' then
            W.colored(ui, 'warn', t('map.map_unknown'))
        elseif reason == 'unconfirmed' then
            W.colored(ui, 'warn', t('map.unconfirmed'))
        elseif reason == 'no_map' and loc then
            W.colored(ui, 'warn', t('map.no_map'))
        end

        local pin, cands = map_view.step_pin(ui, D, floor, loc, step, info.loc)
        local talk_pins = map_view.talk_pins(ui, D, floor, loc, step, info.loc)
        local on_dest = maps.dest_on_floor(floor, loc, #list)
        if pin and not on_dest then pin = nil end
        if cands and not on_dest then cands = nil end
        if not on_dest then talk_pins = {} end
        if #talk_pins > 0 then
            pin = talk_pins[1]
            cands = nil
        end
        local me = maps.player_pin(floor, ui.player, loc)
        -- いまいる MAP が分かっていれば、ほかの MAP には菱形を出さない（分からなければこれまでどおり）
        local here_other = nil
        if me and here_n and #list > 1 and floor and floor.map_n ~= here_n then
            me = nil
            here_other = here_n
        end
        local hl
        if loc and on_dest then
            local col, row = maps.parse_grid(loc.grid)
            if col then hl = { col = col, row = row } end
        end

        -- 地図の上の印（0.1.171〜）：自分の矢印と輪・出口・来たときに立つ位置・近くの討伐の相手
        local ov = { t = (ui.state and ui.state.now) or os.clock(), reduce = ui.reduce_motion,
                     heading = ui.player and tonumber(ui.player.heading) or nil, exits = {}, cands = cands,
                     quest_pins = (#talk_pins > 0) and talk_pins or nil }
        local learned = learned_of(ui)
        local dat = dat_of(ui)
        local unplaced = 0
        if floor and loc and loc.zone_id then
            if #list > 1 then want_dat(ui, loc.zone_id) end
            for _, e in ipairs(exits.of(D, loc.zone_id)) do
                local mn = exits.map_n_of(D, maps, learned, loc.zone_id, e.x, e.y, dat)
                if mn == nil then
                    unplaced = unplaced + 1
                elseif mn == floor.map_n then
                    local bx, by = maps.world_px(floor, e.x, e.y)
                    if bx then
                        ov.exits[#ov.exits + 1] = { base_x = bx, base_y = by, to = e.to, exit = e,
                            name = D:zone_name(e.to) }
                    end
                end
            end
            local a = info.arrive
            if a and tonumber(a.zone_id) == tonumber(loc.zone_id)
                and exits.map_n_of(D, maps, learned, loc.zone_id, a.x, a.y, dat) == floor.map_n then
                local bx, by = maps.world_px(floor, a.x, a.y)
                if bx then
                    -- 広がる輪は、正しい MAP で初めて見えたときから（0.1.178〜。階が後から分かったときも、切り替えてから）
                    if a.pulse_at == nil then a.pulse_at = ov.t end
                    ov.arrive = { base_x = bx, base_y = by, age = ov.t - a.pulse_at }
                end
            end
        end
        local mobs, mob_why
        if info.mob and loc and loc.zone_id then
            mobs, mob_why = map_view.find_mobs(ui, info, loc.zone_id)
            -- 自分を出している MAP にだけ置く（近くの相手なので、同じ階とみなせるのはそこだけ）
            if mobs and floor and me then
                ov.mobs = {}
                for _, m in ipairs(mobs) do
                    local bx, by = maps.world_px(floor, m.x, m.y)
                    if bx then ov.mobs[#ov.mobs + 1] = { base_x = bx, base_y = by } end
                end
            end
        end

        -- 画像が読めたらそれを出し、だめなら方眼。大きさは窓の余りに合わせ、上限は設けない。
        local shown_image = false
        local hot, clicked
        local file_id = floor and floor.file_id
        if file_id and ui.load_map_image then
            local img, why = ui.load_map_image(file_id)
            if img and img.tex then
                local show_w = content_square(imgui, 140)
                shown_image, hot, clicked = draw_image(imgui, img.tex, img.width, img.height, show_w, pin, me, info.view, ov)
            end
        end
        if not shown_image then
            local size = math.max(240, content_square(imgui, 140) - 22)
            local mouse
            local mok, mx, my = pcall(function () return xy(imgui.GetMousePos()) end)
            if mok and mx and my then mouse = { x = mx, y = my } end
            hot, clicked = draw_grid(imgui, size, pin, hl, me, ov, mouse)
            if file_id then
                W.muted(ui, t('map.no_image'))
            end
        end
        if hot then
            pcall(function ()
                imgui.BeginTooltip()
                theme.Text(imgui, t('map.exit_tip', { zone = hot.name or tostring(hot.to) }))
                imgui.EndTooltip()
            end)
            if clicked then map_view.go(ui, hot.exit) end
        end

        if info.browse then
            -- 出口・現在地から開いた地図：目的地のピンは無い
            if info.arrive and ov.arrive then W.colored(ui, 'zone', t('map.arrive_legend'))
            elseif info.arrive then W.muted(ui, t('map.arrive_unknown')) end
        elseif pin and pin.kind == 'live' then
            W.muted(ui, t('map.live_pin'))
        elseif cands then
            W.muted(ui, t('map.cand_pin', { n = tostring(#cands) }))
        elseif pin and pin.kind == 'grid' then
            W.muted(ui, t('map.grid_pin'))
        elseif pin and pin.kind == 'pos' then
            W.muted(ui, t('map.pos_pin'))
        elseif loc and loc.zone_id and not pin then
            local want = maps.wanted_map(loc)
            if want and floor and floor.map_n ~= want then
                W.muted(ui, t('map.dest_on_other', { n = tostring(want) }))
            elseif not want and #list > 1 and (loc.grid or (loc.pos and loc.pos.x)) then
                W.muted(ui, t('map.dest_map_unknown'))
            else
                W.muted(ui, t('map.no_pin'))
            end
        end
        -- 地図の下の凡例（印そのものには文字を重ねない）
        local shown_legend = false
        if me and not me.off then
            local g = me.grid
            if g then
                W.colored(ui, 'player', t('map.legend_here', { grid = g }))
            else
                W.colored(ui, 'player', t('map.you_are_here'))
            end
            shown_legend = true
        elseif me and me.off then
            W.muted(ui, t('map.you_off'))
            shown_legend = true
        elseif here_other then
            W.muted(ui, t('map.you_on_other', { n = tostring(here_other) }))
            shown_legend = true
        end
        local dest = pin and (pin.grid or maps.grid_name(pin.base_x, pin.base_y))
        if dest then
            if shown_legend then W.same(ui) end
            W.colored(ui, 'pin', t('map.legend_dest', { grid = dest }))
        end

        -- 近くの討伐の相手（0.1.171〜）
        if info.mob then
            if mob_why == 'other_zone' then
                W.muted(ui, t('map.mob_other_zone'))
            elseif mobs and #mobs > 0 then
                local d = mobs[1].dist
                W.colored(ui, 'mob', t(d and 'map.mob_found_dist' or 'map.mob_found',
                    { n = tostring(#mobs), d = d and string.format('%d', math.floor(d + 0.5)) or '' }))
                if not (ov.mobs and #ov.mobs > 0) then W.muted(ui, t('map.mob_on_other')) end
            elseif mobs then
                W.muted(ui, t('map.mob_none'))
            end
        end
        -- 出口は地図の上だけに出す（0.1.175〜、となりのエリアのボタンはなくした）。
        -- 階が分からず置けない出口があるときだけ、ひとこと（そのエリアに一度入ると置ける）
        if unplaced > 0 then W.muted(ui, t('map.exits_unplaced')) end

        if W.button(ui, name, 'close', t('common.close'), { section = 'footer', row = 'f' }) then
            open[1] = false
        end
    end
    window.finish(ui, name, nil)
    if not open[1] and st.open.map then ui.close_window('map') end
end

return map_view
