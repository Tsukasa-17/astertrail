--[[
  Astertrail - SF 見た目の図形（0.1.253〜）
  ImGui の DrawList で、角を切った枠・角のブラケット・細い水色の線・薄いバーを描く。
  画像は同梱しない。他アドオンのコードは使わない。DrawList が無い・足りないときは pcall で何もしない。
]]

local theme = require('src.ui.theme')

local sf = {}
sf.CUT = 8

local function vec_xy(a, b)
    local typ = type(a)
    if typ == 'table' or typ == 'userdata' or typ == 'cdata' then
        local okx, x = pcall(function ()
            if a.x ~= nil then return a.x end
            return a[1]
        end)
        local oky, y = pcall(function ()
            if a.y ~= nil then return a.y end
            return a[2]
        end)
        x = okx and tonumber(x) or nil
        y = oky and tonumber(y) or nil
        if x and y then return x, y end
    end
    return tonumber(a), tonumber(b)
end

-- pcall(GetCursorScreenPos) などの戻り（ok, a, b）から座標を取る。ImVec2（userdata）にも対応
function sf.xy(ok, a, b)
    if ok == false then return nil, nil end
    if ok == true then return vec_xy(a, b) end
    return vec_xy(ok, a)
end
local xy = sf.xy

function sf.u32(name, a)
    return theme.u32(name, a)
end

function sf.pts_cut(x1, y1, x2, y2, cut)
    cut = tonumber(cut) or sf.CUT
    local w, h = x2 - x1, y2 - y1
    if w < 4 or h < 4 then
        return { { x1, y1 }, { x2, y1 }, { x2, y2 }, { x1, y2 } }
    end
    local c = math.max(2, math.min(cut, math.floor(math.min(w, h) * 0.28)))
    return {
        { x1 + c, y1 }, { x2 - c, y1 }, { x2, y1 + c }, { x2, y2 - c },
        { x2 - c, y2 }, { x1 + c, y2 }, { x1, y2 - c }, { x1, y1 + c },
    }
end

local function fill_poly(dl, pts, col)
    if not dl or not pts or #pts < 3 then return end
    local ok = pcall(function () dl:AddConvexPolyFilled(pts, col) end)
    if ok then return end
    ok = pcall(function () dl.AddConvexPolyFilled(dl, pts, #pts, col) end)
    if ok then return end
    -- 足りないときは四角で代用
    local x1, y1, x2, y2 = pts[1][1], pts[1][2], pts[1][1], pts[1][2]
    for i = 2, #pts do
        local x, y = pts[i][1], pts[i][2]
        if x < x1 then x1 = x end
        if y < y1 then y1 = y end
        if x > x2 then x2 = x end
        if y > y2 then y2 = y end
    end
    pcall(function () dl:AddRectFilled({ x1, y1 }, { x2, y2 }, col, 0) end)
end

local function stroke_poly(dl, pts, col, thick)
    if not dl or not pts or #pts < 2 then return end
    thick = tonumber(thick) or 1.4
    for i = 1, #pts do
        local a, b = pts[i], pts[i % #pts + 1]
        pcall(function () dl:AddLine({ a[1], a[2] }, { b[1], b[2] }, col, thick) end)
    end
end

function sf.fill_cut(dl, x1, y1, x2, y2, cut, col)
    fill_poly(dl, sf.pts_cut(x1, y1, x2, y2, cut), col)
end

function sf.stroke_cut(dl, x1, y1, x2, y2, cut, col, thick)
    stroke_poly(dl, sf.pts_cut(x1, y1, x2, y2, cut), col, thick)
end

-- 角のブラケット（内側に短い L）
function sf.brackets(dl, x1, y1, x2, y2, len, col, thick)
    if not dl then return end
    len = tonumber(len) or 12
    thick = tonumber(thick) or 1.6
    local function L(ax, ay, bx, by, cx, cy)
        pcall(function ()
            dl:AddLine({ ax, ay }, { bx, by }, col, thick)
            dl:AddLine({ ax, ay }, { cx, cy }, col, thick)
        end)
    end
    L(x1, y1, x1 + len, y1, x1, y1 + len)
    L(x2, y1, x2 - len, y1, x2, y1 + len)
    L(x1, y2, x1 + len, y2, x1, y2 - len)
    L(x2, y2, x2 - len, y2, x2, y2 - len)
end

-- ガラスっぽい枠：暗い塗り＋上側を少し明るく＋細い光る線＋角のブラケット
function sf.frame(dl, x1, y1, x2, y2, opts)
    opts = opts or {}
    if not dl then return end
    local cut = opts.cut or sf.CUT
    local fill_a = opts.fill_a
    if fill_a == nil then fill_a = 0.78 end
    local line_a = opts.line_a
    if line_a == nil then line_a = 0.92 end
    local fill = opts.fill or theme.u32('bg', fill_a)
    local line = opts.line or theme.u32('border', line_a)
    sf.fill_cut(dl, x1, y1, x2, y2, cut, fill)
    -- 上辺のグラデーション代わり（半透明の明るい帯）。opts.band == false で省略（カードの負荷を下げる）
    if opts.band ~= false and (y2 - y1) > 18 then
        local band_h = math.min(28, (y2 - y1) * 0.28)
        sf.fill_cut(dl, x1 + 1, y1 + 1, x2 - 1, y1 + band_h, math.max(3, cut - 2), theme.u32('sf_cyan', opts.band_a or 0.07))
    end
    -- 光りは最大2重まで。数を増やすと FPS が落ちる。
    local glow_n = 0
    if opts.glow == false or opts.glow == 0 then
        glow_n = 0
    elseif type(opts.glow) == 'number' then
        glow_n = opts.glow
    else
        -- nil はこれまでどおり 1 重（窓の枠）。true も同じ。
        glow_n = 1
    end
    if glow_n > 2 then glow_n = 2 end
    if glow_n >= 2 then
        local c2 = opts.glow_col2 or theme.u32('sf_cyan', 0.28)
        sf.stroke_cut(dl, x1 - 3, y1 - 3, x2 + 3, y2 + 3, cut + 2, c2, 5.0)
    end
    if glow_n >= 1 then
        local c1 = opts.glow_col or theme.u32('border', line_a * 0.22)
        sf.stroke_cut(dl, x1 - 1, y1 - 1, x2 + 1, y2 + 1, cut + 1, c1, 3.0)
    end
    sf.stroke_cut(dl, x1, y1, x2, y2, cut, line, opts.thick or 1.5)
    if opts.brackets ~= false then
        local inset = 3
        sf.brackets(dl, x1 + inset, y1 + inset, x2 - inset, y2 - inset, opts.bracket_len or 11, line, 1.5)
    end
end

function sf.bar(dl, x, y, w, h, frac, opts)
    opts = opts or {}
    if not dl or not w or w < 4 then return end
    h = math.max(3, tonumber(h) or 4)
    frac = tonumber(frac) or 0
    if frac < 0 then frac = 0 elseif frac > 1 then frac = 1 end
    local bg = opts.bg or theme.u32('sf_cyan', 0.16)
    local fg = opts.fg or theme.u32('sf_cyan', 0.95)
    pcall(function () dl:AddRectFilled({ x, y }, { x + w, y + h }, bg, 0) end)
    if frac > 0 then
        pcall(function () dl:AddRectFilled({ x, y }, { x + w * frac, y + h }, fg, 0) end)
    end
end

-- 手順の番号の丸（今の手順は光らせる）
function sf.step_dot(dl, cx, cy, r, n, opts)
    opts = opts or {}
    if not dl then return end
    r = tonumber(r) or 9
    local fill = opts.current and theme.u32('sf_cyan', 0.28) or theme.u32('bg', 0.85)
    local line = opts.current and theme.u32('sf_cyan', 0.98) or theme.u32('border', 0.70)
    pcall(function ()
        dl:AddCircleFilled({ cx, cy }, r, fill, 16)
        dl:AddCircle({ cx, cy }, r, line, 16, opts.current and 1.8 or 1.2)
    end)
end

function sf.vline(dl, x, y1, y2, col, thick)
    if not dl then return end
    pcall(function () dl:AddLine({ x, y1 }, { x, y2 }, col or theme.u32('border', 0.55), thick or 1.2) end)
end

-- 窓全体の枠（見出しの無い SF 窓）
function sf.draw_window(imgui, opts)
    opts = opts or {}
    if not imgui then return end
    local okd, dl = pcall(imgui.GetWindowDrawList)
    if not okd or not dl then return end
    local px, py = xy(pcall(imgui.GetWindowPos))
    local sw, sh = xy(pcall(imgui.GetWindowSize))
    if not (px and py and sw and sh) then return end
    local a = tonumber(opts.alpha)
    if a == nil then a = 0.86 end
    -- 線と光りが窓のクリップで切れないよう、枠は内側へ少し空ける
    local m = 3
    sf.frame(dl, px + m, py + m, px + sw - m, py + sh - m, {
        cut = 12, fill_a = math.max(0.72, a), line_a = 0.92, brackets = true, bracket_len = 16, thick = 1.6,
        glow = 1, glow_col = theme.u32('sf_cyan', 0.35),
    })
end

-- カーソルから窓の下端までの残り高さ（footer などを reserve）。ImVec2 でも画面座標で測る
function sf.remain_below(imgui, reserve)
    reserve = tonumber(reserve) or 0
    local wx, wy = xy(pcall(imgui.GetWindowPos))
    local ww, wh = xy(pcall(imgui.GetWindowSize))
    local cx, cy = xy(pcall(imgui.GetCursorScreenPos))
    if wy and wh and cy then
        return math.max(0, wy + wh - cy - reserve)
    end
    local _, h = sf.avail(imgui)
    return math.max(0, (h or 0) - reserve)
end

-- 直前の当たり（InvisibleButton）の下へカーソルを戻す
function sf.snap_after_item(imgui)
    local x1, y1, x2, y2 = sf.item_rect(imgui)
    if x1 and y2 then sf.set_cursor(imgui, x1, y2) end
end

-- DrawList の文字。ImGui の項目にならないので、SameLine の基準がずれない
function sf.add_text(dl, x, y, col, text)
    if not dl or text == nil then return end
    text = tostring(text)
    if text == '' then return end
    pcall(function () dl:AddText({ x, y }, col, text) end)
end

-- 画面内（スクロール込み）に、この縦範囲が見えるか
function sf.visible_y(imgui, y1, y2)
    local wx, wy = xy(pcall(imgui.GetWindowPos))
    local ww, wh = xy(pcall(imgui.GetWindowSize))
    if not wh and imgui.GetWindowHeight then
        local ok, h = pcall(imgui.GetWindowHeight)
        wh = ok and tonumber(h) or nil
    end
    if not (wy and wh and y1 and y2) then return true end
    local pad = 8
    return y2 >= wy - pad and y1 <= wy + wh + pad
end

-- 子窓のスクロール位置（数値）。取れなければ 0
function sf.scroll_y(imgui)
    if not imgui or not imgui.GetScrollY then return 0 end
    local ok, y = pcall(imgui.GetScrollY)
    return (ok and tonumber(y)) or 0
end

function sf.avail(imgui)
    local ok, a, b = pcall(imgui.GetContentRegionAvail)
    if not ok then return 800, 400 end
    local w, h = vec_xy(a, b)
    return w or 800, h or 400
end

-- 今の行を閉じ、残りの幅・高さをカード列用に測る（SameLine の右に子窓がはみ出さないように）
function sf.break_row(imgui)
    if imgui and imgui.NewLine then
        pcall(imgui.NewLine)
    elseif imgui and imgui.Dummy then
        pcall(imgui.Dummy, { 1, 1 })
    end
    return sf.avail(imgui)
end

-- 透明な当たり（文字と同じ大きさで使うときは呼び出し側で大きさ指定）
function sf.hit(imgui, id, w, h)
    if not imgui or not imgui.InvisibleButton then return false end
    w = math.max(1, tonumber(w) or 1)
    h = math.max(1, tonumber(h) or 1)
    local ok, clicked = pcall(imgui.InvisibleButton, id, { w, h })
    return ok and clicked and true or false
end

function sf.item_rect(imgui)
    local x1, y1 = xy(pcall(imgui.GetItemRectMin))
    local x2, y2 = xy(pcall(imgui.GetItemRectMax))
    if not (x1 and y1 and x2 and y2) then return nil end
    return x1, y1, x2, y2
end

-- レール用の細い線アイコン（既存の塗りつぶしアイコンとは別）
local function stroke(dl, a, b, col, thick)
    pcall(function () dl:AddLine(a, b, col, thick or 1.5) end)
end

function sf.icon_compass(dl, x, y, r, col)
    col = col or theme.u32('sf_cyan', 0.95)
    pcall(function ()
        dl:AddCircle({ x, y }, r, col, 16, 1.5)
        dl:AddCircle({ x, y }, r * 0.18, col, 10, 1.2)
    end)
    stroke(dl, { x, y - r * 0.85 }, { x, y + r * 0.85 }, col, 1.2)
    stroke(dl, { x - r * 0.85 }, { x + r * 0.85, y }, col, 1.2) -- typo check
end

-- fix icon_compass horizontal line - I may have written a bad table. Will rewrite icons clearly below.

function sf.icon_book(dl, x, y, r, col)
    col = col or theme.u32('sf_cyan', 0.95)
    local x1, y1, x2, y2 = x - r * 0.7, y - r * 0.8, x + r * 0.7, y + r * 0.8
    pcall(function ()
        dl:AddRect({ x1, y1 }, { x2, y2 }, col, 0, 0, 1.5)
        dl:AddLine({ x, y1 }, { x, y2 }, col, 1.2)
    end)
end

function sf.icon_target(dl, x, y, r, col)
    col = col or theme.u32('sf_cyan', 0.95)
    pcall(function ()
        dl:AddCircle({ x, y }, r * 0.85, col, 16, 1.5)
        dl:AddCircle({ x, y }, r * 0.40, col, 12, 1.2)
        dl:AddLine({ x, y - r }, { x, y - r * 0.55 }, col, 1.4)
        dl:AddLine({ x, y + r * 0.55 }, { x, y + r }, col, 1.4)
        dl:AddLine({ x - r, y }, { x - r * 0.55, y }, col, 1.4)
        dl:AddLine({ x + r * 0.55, y }, { x + r, y }, col, 1.4)
    end)
end

function sf.icon_star(dl, x, y, r, col)
    col = col or theme.u32('sf_cyan', 0.95)
    -- 5 点の細い星（塗りなし）
    local pts = {}
    for i = 0, 4 do
        local a = math.rad(-90 + i * 144)
        pts[#pts + 1] = { x + math.cos(a) * r, y + math.sin(a) * r }
    end
    stroke_poly(dl, pts, col, 1.5)
end

function sf.icon_check(dl, x, y, r, col)
    col = col or theme.u32('sf_cyan', 0.95)
    pcall(function ()
        dl:AddRect({ x - r * 0.75, y - r * 0.8 }, { x + r * 0.75, y + r * 0.8 }, col, 0, 0, 1.5)
        dl:AddLine({ x - r * 0.4, y }, { x - r * 0.1, y + r * 0.35 }, col, 1.6)
        dl:AddLine({ x - r * 0.1, y + r * 0.35 }, { x + r * 0.42, y - r * 0.32 }, col, 1.6)
    end)
end

function sf.icon_gear(dl, x, y, r, col)
    col = col or theme.u32('sf_cyan', 0.95)
    pcall(function ()
        dl:AddCircle({ x, y }, r * 0.42, col, 12, 1.5)
        for i = 0, 5 do
            local a = math.rad(i * 60)
            local c, s = math.cos(a), math.sin(a)
            dl:AddLine({ x + c * r * 0.55, y + s * r * 0.55 }, { x + c * r, y + s * r }, col, 1.8)
        end
    end)
end

function sf.icon_map(dl, x, y, r, col)
    col = col or theme.u32('sf_cyan', 0.95)
    pcall(function ()
        dl:AddRect({ x - r * 0.85, y - r * 0.65 }, { x + r * 0.85, y + r * 0.65 }, col, 0, 0, 1.5)
        dl:AddLine({ x - r * 0.2, y - r * 0.65 }, { x - r * 0.05, y + r * 0.65 }, col, 1.2)
        dl:AddLine({ x + r * 0.25, y - r * 0.65 }, { x + r * 0.10, y + r * 0.65 }, col, 1.2)
    end)
end

-- コンパス横線の直し（上の仮定義を上書き）
function sf.icon_compass(dl, x, y, r, col)
    col = col or theme.u32('sf_cyan', 0.95)
    pcall(function ()
        dl:AddCircle({ x, y }, r, col, 16, 1.5)
        dl:AddCircle({ x, y }, r * 0.18, col, 10, 1.2)
        dl:AddLine({ x, y - r * 0.85 }, { x, y + r * 0.85 }, col, 1.2)
        dl:AddLine({ x - r * 0.85, y }, { x + r * 0.85, y }, col, 1.2)
    end)
end

-- 指定位置に文字（縁取りは 0.1.252 のフックを使う）。カーソルは元に戻す。
function sf.set_cursor(imgui, x, y)
    if not imgui or not x or not y then return end
    pcall(function () imgui.SetCursorScreenPos({ x, y }) end)
end

-- 指定位置に文字（縁取りは 0.1.252 のフックを使う）。カーソルは元に戻す。
-- 実機の ImVec2（userdata）も sf.xy で読む。復帰できないと、タブやチップが斜めにずれて重なる。
function sf.text_at(imgui, x, y, fn)
    if not imgui or not fn then return end
    local sx, sy = sf.xy(pcall(imgui.GetCursorScreenPos))
    sf.set_cursor(imgui, x, y)
    fn()
    if sx and sy then sf.set_cursor(imgui, sx, sy) end
end

-- ロゴ用の細い光る下線
function sf.underline(dl, x1, y, x2, col, thick)
    if not dl then return end
    thick = tonumber(thick) or 1.4
    col = col or theme.u32('sf_cyan', 0.95)
    pcall(function ()
        dl:AddLine({ x1, y }, { x2, y }, theme.u32('sf_cyan', 0.22), (thick or 1.4) + 4)
        dl:AddLine({ x1, y }, { x2, y }, col, thick)
    end)
end

-- LOCATION 欄の小さな方位磁針（装飾。N だけ文字）
function sf.compass_rose(dl, cx, cy, r, col)
    col = col or theme.u32('sf_cyan', 0.90)
    if not dl then return end
    pcall(function ()
        dl:AddCircle({ cx, cy }, r, col, 24, 1.4)
        dl:AddCircle({ cx, cy }, r * 0.16, col, 10, 1.2)
        for i = 0, 7 do
            local a = (3.1415926535 * 2) * (i / 8)
            local c, s = math.cos(a), math.sin(a)
            local inner = (i % 2 == 0) and (r * 0.55) or (r * 0.72)
            dl:AddLine({ cx + c * inner, cy + s * inner }, { cx + c * r * 0.92, cy + s * r * 0.92 }, col, i % 2 == 0 and 1.5 or 1.0)
        end
    end)
end

return sf
