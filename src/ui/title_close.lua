--[[
  Astertrail - 右上の ×（0.1.283〜、0.1.284 で枠の内側へ）
  トラッカーと同じ「×」を、見出し行の右端に置く。本文の子窓より前の行に出し、
  置いたあとカーソルを見出しの左へ戻す。呼び出し側は本文を見出しの下から始め、
  子窓が見出し（×）を覆わないようにする（0.1.279 の地図の閉じると同じ理由）。
  位置は窓の外枠ではなく、角を切った枠の内側（余白 3 + 切れ 12 + 隙間）。
]]

local W = require('src.ui.widgets')
local CT = require('src.ui.colored_text')
local sf = require('src.ui.sf_style')

local title_close = {}

-- sf.draw_window の枠は内側 3、角の切れ 12。その先に隙間を取る
title_close.INSET_X = 22
title_close.INSET_Y = 20
title_close.GAP = 8

local function style_x(imgui, key, fallback)
    local ok, st = pcall(imgui.GetStyle)
    if ok and st then
        local ok2, v = pcall(function () return st[key] end)
        if ok2 and v ~= nil then
            if type(v) == 'table' then return tonumber(v.x or v[1]) or fallback end
            return tonumber(v) or fallback
        end
    end
    return fallback
end

function title_close.button_w(imgui, label)
    label = label or '×'
    local w = CT.text_w(imgui, label)
    if not w then return 22 end
    return w + style_x(imgui, 'FramePadding', 4) * 2
end

-- × とその左の隙間を合わせた幅（見出しの部品はこの左に収める）
function title_close.reserved_w(imgui, label)
    return title_close.button_w(imgui, label) + title_close.GAP
end

-- 見出しの部品が越えてはいけない画面 x（× の左端 − 隙間）
function title_close.right_limit(imgui, label)
    local wx, wy = sf.xy(pcall(imgui.GetWindowPos))
    local ww, wh = sf.xy(pcall(imgui.GetWindowSize))
    local cw = title_close.button_w(imgui, label)
    if wx and ww then
        return wx + ww - title_close.INSET_X - cw - title_close.GAP
    end
    local hx, hy = sf.xy(pcall(imgui.GetCursorScreenPos))
    local aw = select(1, sf.avail(imgui)) or 200
    return (hx or 0) + aw - cw - title_close.GAP
end

-- 見出しの開始位置。上と左も枠の切れにかからないところまで下げる／右へ
function title_close.header_origin(imgui)
    local hx, hy = sf.xy(pcall(imgui.GetCursorScreenPos))
    local wx, wy = sf.xy(pcall(imgui.GetWindowPos))
    hx, hy = hx or 0, hy or 0
    if wy and hy < wy + title_close.INSET_Y then hy = wy + title_close.INSET_Y end
    if wx and hx < wx + 10 then hx = wx + 10 end
    return hx, hy
end

-- opts: id, label, tooltip, section, row, origin_x, origin_y, no_focus, keep_cursor
-- 戻り: clicked, reserved_width
function title_close.draw(ui, win, opts)
    opts = opts or {}
    local imgui = ui.imgui
    local label = opts.label or '×'
    local id = opts.id or 'title_close'
    local pad_x = tonumber(opts.pad) or title_close.INSET_X
    local pad_y = tonumber(opts.pad_y) or title_close.INSET_Y
    local cw = title_close.button_w(imgui, label)
    local ox, oy = sf.xy(pcall(imgui.GetCursorScreenPos))
    if opts.origin_x ~= nil then ox = opts.origin_x end
    if opts.origin_y ~= nil then oy = opts.origin_y end
    local wx, wy = sf.xy(pcall(imgui.GetWindowPos))
    local ww, wh = sf.xy(pcall(imgui.GetWindowSize))
    local right
    if wx and ww then
        right = wx + ww - pad_x
    else
        local aw = select(1, sf.avail(imgui)) or 200
        right = (ox or 0) + aw - (pad_x - 8)
    end
    local bx = right - cw
    if ox and bx < ox then bx = ox end
    local by = oy
    if wy and by and by < wy + pad_y then by = wy + pad_y end
    if bx and by then sf.set_cursor(imgui, bx, by) end
    local clicked = W.button(ui, win, id, label, {
        section = opts.section or 'head',
        row = opts.row or 'h',
        small = true,
        no_focus = opts.no_focus ~= false,
        tooltip = opts.tooltip,
    })
    if not opts.keep_cursor and ox and oy then
        sf.set_cursor(imgui, ox, oy)
    end
    return clicked, cw
end

return title_close
