--[[
  Astertrail - 世界座標から画面座標への投影（行列の計算だけ。ゲーム API は含まない）
  Direct3D の行ベクトル（v * M）。view のあとに projection を掛ける。
  行列は 16 個の数値（行優先、_11, _12, _13, _14, _21, ...）。
]]

local project = {}

local function as16(m)
    if type(m) ~= 'table' then return nil end
    if type(m[1]) == 'number' and type(m[16]) == 'number' then
        local out = {}
        for i = 1, 16 do
            local v = tonumber(m[i])
            if not v then return nil end
            out[i] = v
        end
        return out
    end
    local names = {
        '_11', '_12', '_13', '_14', '_21', '_22', '_23', '_24',
        '_31', '_32', '_33', '_34', '_41', '_42', '_43', '_44',
    }
    if m._11 == nil and m[1] == nil and type(m.m) == 'table' then m = m.m end
    -- m[1][1] 形式
    if type(m[1]) == 'table' and type(m[1][1]) == 'number' then
        local out = {}
        for i = 1, 4 do
            for j = 1, 4 do
                local v = tonumber(m[i][j])
                if not v then return nil end
                out[(i - 1) * 4 + j] = v
            end
        end
        return out
    end
    if m._11 ~= nil then
        local out = {}
        for i, n in ipairs(names) do
            local v = tonumber(m[n] or m[n:sub(2)])
            if not v then return nil end
            out[i] = v
        end
        return out
    end
    return nil
end

function project.matrix(m)
    return as16(m)
end

-- 行優先の 4x4 積 A * B
function project.mul(a, b)
    a, b = as16(a), as16(b)
    if not a or not b then return nil end
    local r = {}
    for i = 0, 3 do
        for j = 0, 3 do
            local s = 0
            for k = 0, 3 do
                s = s + a[i * 4 + k + 1] * b[k * 4 + j + 1]
            end
            r[i * 4 + j + 1] = s
        end
    end
    return r
end

-- (x,y,z,1) * M
function project.transform(m, x, y, z)
    m = as16(m)
    x, y, z = tonumber(x), tonumber(y), tonumber(z)
    if not m or x == nil or y == nil or z == nil then return nil end
    return {
        x = x * m[1] + y * m[5] + z * m[9]  + m[13],
        y = x * m[2] + y * m[6] + z * m[10] + m[14],
        z = x * m[3] + y * m[7] + z * m[11] + m[15],
        w = x * m[4] + y * m[8] + z * m[12] + m[16],
    }
end

-- 画面座標。vp は { x, y, w, h }（左上が原点）。
-- カメラの後ろ、または画面の外なら visible=false。
function project.screen(x, y, z, view, proj, vp)
    local m
    if proj then
        m = project.mul(view, proj)
    else
        m = as16(view)
    end
    local clip = m and project.transform(m, x, y, z)
    if not clip then return nil end
    local w = clip.w
    if not w or w <= 1e-5 then
        return { visible = false, behind = true }
    end
    local ndc_x = clip.x / w
    local ndc_y = clip.y / w
    vp = vp or {}
    local vx = tonumber(vp.x) or 0
    local vy = tonumber(vp.y) or 0
    local vw = tonumber(vp.w) or 0
    local vh = tonumber(vp.h) or 0
    if vw <= 0 or vh <= 0 then return nil end
    local sx = vx + (1 + ndc_x) * vw / 2
    local sy = vy + (1 - ndc_y) * vh / 2
    local visible = sx >= vx and sx <= vx + vw and sy >= vy and sy <= vy + vh
    return { x = sx, y = sy, visible = visible, behind = false, ndc_x = ndc_x, ndc_y = ndc_y, w = w }
end

return project
