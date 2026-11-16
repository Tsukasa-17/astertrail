--[[
  Astertrail - 自分で描く小さな絵（0.1.173〜、t251）。絵文字のフォントは使わない。
  どれも中心 (x, y)・半径 r で、ImGui の描画リスト（dl）に描く。描けない環境では何もしない。
  ・gear     ⚙️ のような歯車（設定）
  ・compass  🧭 のような青い円のコンパス（コンパスの表示・非表示）
  ・list     リストのような絵（トラッカーの表示・非表示）
  ・infinity ♾️ のような無限の印（0.1.177〜は使っていない）
  ・star      金色の星（トラッカーの表示・非表示、0.1.177〜）
  ・checklist クリーム色の紙に緑のチェック3つ（エミネンスの窓の表示・非表示、0.1.177〜）
]]

local icons = {}

local function call(dl, fn, ...)
    local f = dl and dl[fn]
    if type(f) ~= 'function' then return false end
    return pcall(f, dl, ...)
end

-- 歯車：歯 8 枚の外形（凸でないので三角に分けて塗る）と、真ん中の穴
function icons.gear(dl, x, y, r, col, hole)
    local teeth = 8
    local ro, ri = r, r * 0.72
    local pts = {}
    for i = 0, teeth - 1 do
        local a = i * 2 * math.pi / teeth
        local w = math.pi / teeth * 0.55
        pts[#pts + 1] = { a - w * 1.25, ri }
        pts[#pts + 1] = { a - w * 0.7, ro }
        pts[#pts + 1] = { a + w * 0.7, ro }
        pts[#pts + 1] = { a + w * 1.25, ri }
    end
    local n = #pts
    for i = 1, n do
        local p, q = pts[i], pts[i % n + 1]
        call(dl, 'AddTriangleFilled', { x, y },
            { x + p[2] * math.cos(p[1]), y + p[2] * math.sin(p[1]) },
            { x + q[2] * math.cos(q[1]), y + q[2] * math.sin(q[1]) }, col)
    end
    call(dl, 'AddCircleFilled', { x, y }, r * 0.34, hole, 16)
end

-- コンパス：青い円・白い縁・北が赤、南が白の針
function icons.compass(dl, x, y, r, blue, rim, red, white)
    call(dl, 'AddCircleFilled', { x, y }, r, rim, 24)
    call(dl, 'AddCircleFilled', { x, y }, r * 0.84, blue, 24)
    local w = r * 0.26
    local len = r * 0.68
    call(dl, 'AddTriangleFilled', { x - w, y }, { x + w, y }, { x, y - len }, red)
    call(dl, 'AddTriangleFilled', { x - w, y }, { x + w, y }, { x, y + len }, white)
    call(dl, 'AddCircleFilled', { x, y }, math.max(1, r * 0.12), rim, 8)
end

-- リスト：左に小さな四角、右に横線を 3 段
function icons.list(dl, x, y, r, col)
    local lw = math.max(1.4, r * 0.22)
    for i = -1, 1 do
        local yy = y + i * r * 0.62
        local s = r * 0.17
        call(dl, 'AddRectFilled', { x - r * 0.9 - s, yy - s }, { x - r * 0.9 + s, yy + s }, col)
        call(dl, 'AddLine', { x - r * 0.45, yy }, { x + r * 0.95, yy }, col, lw)
    end
end

-- 無限の印：レムニスケート（横に長い 8）。w は横の半分の長さ
function icons.infinity(dl, x, y, w, col, thick)
    local pts, n = {}, 32
    for i = 0, n do
        local t = i / n * 2 * math.pi
        local d = 1 + math.sin(t) ^ 2
        pts[#pts + 1] = { x + w * math.cos(t) / d, y + w * math.sin(t) * math.cos(t) / d * 1.25 }
    end
    call(dl, 'AddPolyline', pts, col, false, thick or math.max(1.4, w * 0.22))
end

-- 金色の星：5つの角（凸でないので真ん中からの三角に分けて塗る）と、明るい縁
function icons.star(dl, x, y, r, fill, rim)
    local pts = {}
    for i = 0, 9 do
        local a = -math.pi / 2 + i * math.pi / 5
        local rr = (i % 2 == 0) and r or r * 0.45
        pts[#pts + 1] = { x + rr * math.cos(a), y + rr * math.sin(a) }
    end
    for i = 1, 10 do
        local a, b = pts[i], pts[i % 10 + 1]
        call(dl, 'AddTriangleFilled', { x, y }, a, b, fill)
    end
    if rim then
        local closed = {}
        for i = 1, 10 do closed[i] = pts[i] end
        closed[11] = pts[1]
        call(dl, 'AddPolyline', closed, rim, false, math.max(1.0, r * 0.12))
    end
end

-- チェックの紙：クリーム色の紙（濃い縁）に、緑のチェック3つと右に灰色の線
function icons.checklist(dl, x, y, r, paper, rim, check, line)
    local w, h = r * 0.72, r * 0.95
    call(dl, 'AddRectFilled', { x - w, y - h }, { x + w, y + h }, paper, r * 0.12)
    if rim then call(dl, 'AddRect', { x - w, y - h }, { x + w, y + h }, rim, r * 0.12, 0, math.max(1.0, r * 0.1)) end
    local lw = math.max(1.2, r * 0.16)
    for i = -1, 1 do
        local yy = y + i * h * 0.55
        local cx = x - w * 0.45
        local s = r * 0.17
        call(dl, 'AddPolyline', { { cx - s * 1.2, yy }, { cx - s * 0.2, yy + s }, { cx + s * 1.5, yy - s * 1.1 } }, check, false, lw)
        if line then call(dl, 'AddLine', { x + w * 0.15, yy }, { x + w * 0.65, yy }, line, math.max(1.0, r * 0.12)) end
    end
end

return icons
