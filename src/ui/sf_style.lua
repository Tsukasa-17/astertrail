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

-- 薄い横線の高さ（上下の余白を含む）。詳細の手順と報酬のあいだの予約に使う
function sf.rule_gap(opts)
    opts = opts or {}
    local pad = tonumber(opts.pad) or 6
    local thick = tonumber(opts.thick) or 1.0
    return pad + math.max(1, math.ceil(thick)) + pad
end

-- カーソル位置に薄い水色の横線を描き、上下に余白を取って高さを進める。
-- 詳細の OBJECTIVE / 手順と、下の REWARD / LOCATION のあいだ用（0.1.273〜）。
function sf.rule(imgui, opts)
    opts = opts or {}
    if not imgui then return 0 end
    local pad = tonumber(opts.pad) or 6
    local thick = tonumber(opts.thick) or 1.0
    local inset = tonumber(opts.inset) or 0
    local gap = sf.rule_gap({ pad = pad, thick = thick })
    if imgui.Dummy and pad > 0 then pcall(imgui.Dummy, { 1, pad }) end
    local okd, dl = pcall(imgui.GetWindowDrawList)
    if not okd then dl = nil end
    local x, y = sf.xy(pcall(imgui.GetCursorScreenPos))
    local aw = select(1, sf.avail(imgui)) or 0
    if dl and x and y and aw > 8 then
        local x1, x2 = x + inset, x + aw - inset
        if x2 > x1 + 4 then
            local col = opts.col or theme.u32('sf_cyan', 0.42)
            pcall(function ()
                dl:AddLine({ x1, y }, { x2, y }, theme.u32('sf_cyan', 0.14), thick + 3)
                dl:AddLine({ x1, y }, { x2, y }, col, thick)
            end)
        end
    end
    local after = gap - pad
    if imgui.Dummy and after > 0 then pcall(imgui.Dummy, { 1, after }) end
    return gap
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


-- 英語の見出し語（ASTERTRAIL / MISSION / OBJECTIVE など）。日本語は対象外。
function sf.is_en_heading(text)
    text = tostring(text or '')
    if text == '' then return false end
    if not text:find('%a') then return false end
    return not text:find('[^%w %p]')
end

-- 0.1.264〜0.1.268：サンプルに近づけ、タイトルは 8/46（46px で 8px）、見出しは 5/24（24px で 5px）、下限 1px。
-- 0.1.269：字間が広すぎて狭い窓で切れるので、追加の字間は付けない（0px。フォント本来の間隔）。
-- 幅が足りないときは、残っている字間を 0 まで詰めてから描く。窓の大きさは変えない。
function sf.heading_track(px, kind)
    return 0
end

local function heading_chars(text)
    text = tostring(text or '')
    local out, i, n = {}, 1, #text
    while i <= n do
        local b = text:byte(i)
        local step = (not b and 1) or (b < 128 and 1) or (b < 224 and 2) or (b < 240 and 3) or 4
        out[#out + 1] = text:sub(i, i + step - 1)
        i = i + step
    end
    return out
end

local function font_px(imgui)
    if imgui and imgui.GetFontSize then
        local ok, v = pcall(imgui.GetFontSize)
        if ok and tonumber(v) and tonumber(v) > 0 then return tonumber(v) end
    end
    return 18
end

local function heading_opts(opts)
    if type(opts) == 'number' then return { max_w = opts } end
    return opts or {}
end

-- 今のフォント（見出しなら Push 済み）で、字間込みの幅を測る。
-- opts.track で字間を指定、opts.max_w があればその幅に収まるまで字間を 0 まで詰める。
function sf.measure_heading(imgui, text, kind, opts)
    opts = heading_opts(opts)
    text = tostring(text or '')
    if text == '' then return 0, 0, {} end
    local chars = heading_chars(text)
    local spaced = kind and sf.is_en_heading(text)
    local gap = 0
    if spaced then
        if tonumber(opts.track) then
            gap = math.max(0, tonumber(opts.track))
        else
            gap = sf.heading_track(font_px(imgui), kind)
        end
    end
    local function pack(g)
        local total, th, parts, letters = 0, 0, {}, 0
        for i, ch in ipairs(chars) do
            local tw, h = theme.measure_text(imgui, ch)
            tw, h = tonumber(tw) or 12, tonumber(h) or 16
            local gi = (spaced and i < #chars) and g or 0
            parts[i] = { ch = ch, w = tw, gap = gi }
            total = total + tw + gi
            letters = letters + tw
            if h > th then th = h end
        end
        return total, th, parts, letters
    end
    local total, th, parts, letters = pack(gap)
    local max_w = tonumber(opts.max_w)
    if spaced and max_w and max_w > 0 and total > max_w then
        local n = #chars - 1
        gap = (n > 0) and math.max(0, (max_w - letters) / n) or 0
        total, th, parts = pack(gap)
    end
    return total, th, parts
end

-- DrawList に字間付きで描く。縁取りがオンなら既存の outline.paint_at を使う。
function sf.add_heading(imgui, x, y, col, text, kind, opts)
    text = tostring(text or '')
    if text == '' or not x or not y then return 0, 0 end
    local w, h, parts = sf.measure_heading(imgui, text, kind, opts)
    local outline = package.loaded['src.ui.crisp_outline']
    if not outline then pcall(function () outline = require('src.ui.crisp_outline') end) end
    local dl
    if imgui and imgui.GetWindowDrawList then
        local ok, got = pcall(imgui.GetWindowDrawList)
        if ok then dl = got end
    end
    local tx = x
    for _, p in ipairs(parts) do
        if outline and outline.active and outline.active() and outline.paint_at then
            pcall(outline.paint_at, imgui, tx, y, p.ch)
        end
        sf.add_text(dl, tx, y, col, p.ch)
        tx = tx + (p.w or 0) + (p.gap or 0)
    end
    return w, h
end

-- カーソル位置に見出しを出し、高さを進める（OBJECTIVE などの行）
-- 幅の指定がなければ、今の行の残り幅に収まるまで字間を詰める。
function sf.heading_line(ui, text, col, kind, opts)
    if not ui or not ui.imgui then return 0, 0 end
    local imgui = ui.imgui
    opts = heading_opts(opts)
    if opts.max_w == nil and imgui.GetContentRegionAvail then
        local oka, a, b = pcall(imgui.GetContentRegionAvail)
        if oka then
            if type(a) == 'table' then a = a.x or a[1] end
            opts.max_w = tonumber(a) or opts.max_w
        end
    end
    local x, y = sf.xy(pcall(imgui.GetCursorScreenPos))
    x, y = x or 0, y or 0
    local kind_s = kind or 'label'
    local mw = select(1, sf.measure_heading(imgui, text, kind_s, opts)) or 0
    if (opts.align == 'center' or opts.center) and opts.max_w and mw then
        x = x + math.max(0, (opts.max_w - mw) * 0.5)
    end
    local w, h = sf.add_heading(imgui, x, y, col, text, kind_s, opts)
    local dummy_w = w
    if (opts.align == 'center' or opts.center) and opts.max_w then
        dummy_w = math.max(w, opts.max_w)
    end
    if imgui.Dummy then pcall(imgui.Dummy, { math.max(1, dummy_w), math.max(1, h) }) end
    return w, h
end

-- 受注・完了お知らせの SF 枠（シアンのガラス＋角のアクセント。完了は金の縁）（0.1.280〜）
function sf.draw_popup(imgui, kind, opts)
    opts = opts or {}
    local dl
    if imgui and imgui.GetWindowDrawList then
        local ok, got = pcall(imgui.GetWindowDrawList)
        if ok then dl = got end
    end
    if not dl then return end
    local x, y = sf.xy(pcall(imgui.GetWindowPos))
    local w, h = sf.xy(pcall(imgui.GetWindowSize))
    if not (x and y and w and h) or w < 8 or h < 8 then return end
    local scale = tonumber(opts.scale) or 1
    local alpha = tonumber(opts.alpha) or 1
    if alpha <= 0 then return end
    local cx, cy = x + w / 2, y + h / 2
    local rw, rh = w * scale, h * scale
    local x1, y1 = cx - rw / 2, cy - rh / 2
    local x2, y2 = cx + rw / 2, cy + rh / 2
    local complete = (kind == 'complete')
    local colname = complete and 'gold' or 'sf_cyan'
    local line = theme.u32(colname, 0.90 * alpha)
    local glow = theme.u32(colname, 0.22 * alpha)
    -- 柔らかいネオンの暈（広がるほど薄く。完了は金。reduce_motion なら脈打たない）（0.1.281〜）
    local pulse = 1
    if not opts.reduce_motion then
        local now = 0
        if imgui.GetTime then
            local okt, v = pcall(imgui.GetTime)
            if okt then now = tonumber(v) or 0 end
        end
        pulse = 0.84 + 0.16 * (0.5 + 0.5 * math.sin(now * 2.1))
    end
    local halo_dl = dl
    if imgui.GetForegroundDrawList then
        local okf, got = pcall(imgui.GetForegroundDrawList)
        if okf and got then halo_dl = got end
    end
    local dx, dy = 1920, 1080
    if imgui.GetIO then
        local oki, io = pcall(imgui.GetIO)
        if oki and type(io) == 'table' and io.DisplaySize then
            dx = tonumber(io.DisplaySize.x or io.DisplaySize[1]) or dx
            dy = tonumber(io.DisplaySize.y or io.DisplaySize[2]) or dy
        end
    end
    for i = 1, 5 do
        local pad = 2.6 * i
        local a = (0.26 / i) * alpha * pulse
        local hx1 = math.max(1, x1 - pad)
        local hy1 = math.max(1, y1 - pad)
        local hx2 = math.min(dx - 1, x2 + pad)
        local hy2 = math.min(dy - 1, y2 + pad)
        if hx2 > hx1 + 4 and hy2 > hy1 + 4 then
            sf.stroke_cut(halo_dl, hx1, hy1, hx2, hy2, 8 + i * 0.5, theme.u32(colname, a), math.max(1.15, 2.3 - i * 0.18))
        end
    end
    sf.frame(dl, x1, y1, x2, y2, {
        cut = 8,
        fill = theme.u32('bg', 0.62 * alpha),
        line = line,
        brackets = true,
        bracket_len = 14,
        glow = 1,
        glow_col = glow,
        thick = 1.6,
        band = true,
        band_a = 0.08,
    })
end

return sf
