--[[
  Astertrail - くっきりフォントの縁取り（0.1.247〜）
  本・トラッカー・コンパス・エミネンス・設定の文字に、黒い縁取りを付ける。
  描き方は YunaUI のチャットの縁取りと同じ考え方（太さ 1 は 8 方向に 1px、
  それより太いときは円周の上の点をずらす。位置は整数に丸める）。
  0.1.248：1.5px より上は円周の点を 24〜32 に増やす。3px では内側も 1px 刻みで重ね、
  縁の端だけ濃さを少し下げてガタつきを和らげる。1 行あたりの描画は上限あり。
  0.1.249：縁取りを今の文字の大きさ（GetFontSize）に合わせる。くっきりフォントがオフで
  SetWindowFontScale のとき、4 引数の AddText だけだと基準サイズのままになり、縁が見えない。
  0.1.251：ただし PushFont(GetFontSize) は、倍率がもう一度掛かって縁だけ巨大になる。
  くっきりオフ（SetWindowFontScale）では縁を描かない。オンのときだけ、今までどおり付ける。
  0.1.252：色付きの名前が混じる行は、縁を行全体で先に描き、本文をあとから重ねる
  （隣の部品の縁が本文にかぶらない）。影は付けない。AddText は 4 引数を使う。
]]

local theme = require('src.ui.theme')

local outline = {}

local WINDOWS = {
    book = true, detail = true, tracker = true, compass = true, eminence = true, settings = true,
    popup = true, resume = true,
}

local DIR8 = {
    {  1,  0 }, { -1,  0 }, {  0,  1 }, {  0, -1 },
    {  1,  1 }, {  1, -1 }, { -1,  1 }, { -1, -1 },
}

local active = false
local hooked_for = nil
local orig = {}
local width, alpha = 0, 0.85
local last_pts, last_w = nil, nil

-- 1 行あたりのずらし上限（3px でも 8+24+32=64 に収める）
outline.MAX_POINTS = 64
-- いちばん外側の縁だけ、濃さをこの倍率にする（内側は 1）
outline.EDGE_MUL = 0.80

function outline.windows() return WINDOWS end
function outline.active() return active end

function outline.clamp_width(v)
    v = tonumber(v)
    if v == nil then return 0 end
    v = math.floor(v * 4 + 0.5) / 4
    if v < 0 then v = 0 elseif v > 3 then v = 3 end
    return v
end

function outline.clamp_alpha(v)
    v = tonumber(v)
    if v == nil then return 0.85 end
    if v < 0 then v = 0 elseif v > 1 then v = 1 end
    return v
end

-- 太さ 1.5 より上の円周の点数（24 または 32）
function outline.circle_n(w)
    w = tonumber(w) or 0
    if w <= 1.5 then return 8 end
    if w > 2.5 then return 32 end
    return 24
end

local function append_circle(pts, radius, n, mul)
    for k = 0, n - 1 do
        if #pts >= outline.MAX_POINTS then return end
        local t = k * 2 * math.pi / n
        pts[#pts + 1] = { math.cos(t) * radius, math.sin(t) * radius, mul }
    end
end

-- 戻り値は { dx, dy, 濃さの倍率 }。倍率は外側の縁だけ EDGE_MUL、それ以外は 1。
-- 太さ 1：8 方向に 1px。1 より大きく 1.5 以下：8 点を軸・斜めに揃え、半径は太さ。
-- 1.5 より上：円周上に 24〜32 点。3px のときは内側も 1px・2px で重ねる。
function outline.offsets(w)
    w = tonumber(w) or 0
    if w <= 0 then return {} end
    local pts = {}
    local function add(dx, dy, mul)
        if #pts >= outline.MAX_POINTS then return end
        pts[#pts + 1] = { dx, dy, mul or 1 }
    end
    if math.abs(w - 1) <= 1e-6 then
        for i = 1, #DIR8 do add(DIR8[i][1], DIR8[i][2], 1) end
        return pts
    end
    if w <= 1.5 then
        local n = 8
        for k = 0, n - 1 do
            local t = k * 2 * math.pi / n
            local ox, oy = math.cos(t), math.sin(t)
            ox = (math.abs(ox) > 0.3) and (ox > 0 and 1 or -1) or 0
            oy = (math.abs(oy) > 0.3) and (oy > 0 and 1 or -1) or 0
            add(ox * w, oy * w, 1)
        end
        return pts
    end
    -- 3px：内側を 1px 刻みで塗り、外側だけ濃さを落とす
    if w >= 3 - 1e-6 then
        for i = 1, #DIR8 do add(DIR8[i][1], DIR8[i][2], 1) end
        append_circle(pts, 2, 24, 1)
        append_circle(pts, 3, 32, outline.EDGE_MUL)
        return pts
    end
    append_circle(pts, w, outline.circle_n(w), outline.EDGE_MUL)
    return pts
end

local function pts_for(w)
    if last_pts and last_w == w then return last_pts end
    last_pts, last_w = outline.offsets(w), w
    return last_pts
end

local function font_size(imgui)
    if imgui and imgui.GetFontSize then
        local ok, v = pcall(imgui.GetFontSize)
        v = ok and tonumber(v) or nil
        if v and v > 0 then return v end
    end
    return 16
end

local function visible(imgui, x, y)
    if not x or not y then return false end
    local fs = font_size(imgui)
    local wx, wy, ww, wh
    if imgui.GetWindowPos then
        local ok, a, b = pcall(imgui.GetWindowPos)
        if ok then wx, wy = theme.xy(a, b) end
    end
    if imgui.GetWindowSize then
        local ok, a, b = pcall(imgui.GetWindowSize)
        if ok then ww, wh = theme.xy(a, b) end
    end
    if wx and wy and ww and wh and ww > 1 and wh > 1 then
        local m = fs + 8
        if y + fs < wy - m or y > wy + wh + m then return false end
        if x > wx + ww + m or x + 1 < wx - m then return false end
    end
    return true
end

local function measure_w(imgui, s)
    if not imgui or not imgui.CalcTextSize then return nil end
    local ok, a, b = pcall(imgui.CalcTextSize, s)
    if not ok then return nil end
    local w = theme.xy(a, b)
    if w then return w end
    return tonumber(a)
end

local function wrap_lines(imgui, text)
    local lines = {}
    if tostring(text):find('\n', 1, true) then
        for para in (text .. '\n'):gmatch('(.-)\n') do lines[#lines + 1] = para end
        if #lines == 0 then lines[1] = text end
    else
        lines[1] = text
    end
    local wrap_w
    if imgui.GetContentRegionAvail then
        local ok, a, b = pcall(imgui.GetContentRegionAvail)
        if ok then
            local w = theme.xy(a, b)
            if not w then w = tonumber(a) end
            if w and w > 8 then wrap_w = w end
        end
    end
    if not wrap_w then return lines end
    local split = {}
    for _, para in ipairs(lines) do
        if para == '' then
            split[#split + 1] = ''
        else
            local tw = measure_w(imgui, para)
            if tw and tw > wrap_w then
                local acc, aw = '', 0
                for ch in para:gmatch('[%z\1-\127\194-\244][\128-\191]*') do
                    local cw = measure_w(imgui, ch) or 0
                    if acc ~= '' and aw + cw > wrap_w then
                        split[#split + 1] = acc
                        acc, aw = ch, cw
                    else
                        acc, aw = acc .. ch, aw + cw
                    end
                end
                if acc ~= '' then split[#split + 1] = acc end
            else
                split[#split + 1] = para
            end
        end
    end
    return split
end

-- 黒。壊れた値でも 0,0,0 と濃さへ戻す
function outline.color_u32(a)
    a = tonumber(a)
    if a == nil then a = 0.85 end
    if a < 0 then a = 0 elseif a > 1 then a = 1 end
    local ok, v = pcall(theme.rgba, 0, 0, 0, a)
    if ok and type(v) == 'number' then return v end
    local by = math.floor(a * 255 + 0.5)
    if by < 0 then by = 0 elseif by > 255 then by = 255 end
    return ((by * 256 + 0) * 256 + 0) * 256 + 0
end

local function add_text_4(dl, px, py, col, text)
    -- 動いていた 4 引数（位置の表・色・文）。直前の PushFont のフォントと大きさを使う。
    local ok = pcall(function ()
        if dl.AddText then
            local used = pcall(dl.AddText, dl, { px, py }, col, text)
            if not used then pcall(function () dl:AddText({ px, py }, col, text) end) end
        end
    end)
    return ok
end

-- くっきりオフ（SetWindowFontScale）でも、縁取りを本文と同じ大きさで描く。
-- PushFont(font, size) はくっきりフォントと同じ API。失敗したら今のフォントのまま描く。
-- 呼んだら必ず PopFont する。
local function push_current_size(imgui)
    if not imgui or type(imgui.PushFont) ~= 'function' then return false end
    local font
    if type(imgui.GetFont) == 'function' then
        local ok, f = pcall(imgui.GetFont)
        if ok then font = f end
    end
    if font == nil then return false end
    local size = font_size(imgui)
    if not size or size <= 0 then return false end
    local ok = pcall(function () imgui.PushFont(font, size) end)
    return ok and true or false
end

function outline.paint_at(imgui, x, y, text, opts)
    if not imgui then return 0 end
    local w = (opts and tonumber(opts.width)) or width
    local al = (opts and tonumber(opts.alpha)) or alpha
    w = outline.clamp_width(w)
    al = outline.clamp_alpha(al)
    if w <= 0 or al <= 0 then return 0 end
    text = tostring(text or '')
    if text == '' or text == ' ' then return 0 end
    x, y = tonumber(x), tonumber(y)
    if not x or not y then return 0 end
    if not visible(imgui, x, y) then return 0 end
    local dl = imgui.GetWindowDrawList and imgui.GetWindowDrawList()
    if not dl then return 0 end
    local col = outline.color_u32(al)
    if col == nil then return 0 end
    local dirs = pts_for(w)
    local lh = font_size(imgui)
    local n = 0
    local lines = (opts and opts.wrap) and wrap_lines(imgui, text) or { text }
    if not (opts and opts.wrap) and text:find('\n', 1, true) then
        lines = wrap_lines(imgui, text)
    end
    local sized = push_current_size(imgui)
    local ok, err = pcall(function ()
        for li, line in ipairs(lines) do
            if line ~= '' and line ~= ' ' then
                local ly = y + (li - 1) * lh
                if visible(imgui, x, ly) then
                    local remain = outline.MAX_POINTS
                    for i = 1, #dirs do
                        if remain <= 0 then break end
                        local d = dirs[i]
                        local mul = tonumber(d[3]) or 1
                        if mul < 0 then mul = 0 elseif mul > 1 then mul = 1 end
                        local px = math.floor(x + d[1] + 0.5)
                        local py = math.floor(ly + d[2] + 0.5)
                        local c = col
                        if mul < 0.999 then
                            c = outline.color_u32(al * mul)
                            if c == nil then c = col end
                        end
                        add_text_4(dl, px, py, c, line)
                        n = n + 1
                        remain = remain - 1
                    end
                end
            end
        end
    end)
    if sized then pcall(imgui.PopFont) end
    if not ok then return 0 end
    return n
end

local function cursor(imgui)
    if not imgui or not imgui.GetCursorScreenPos then return nil end
    local ok, a, b = pcall(imgui.GetCursorScreenPos)
    if not ok then return nil end
    return theme.xy(a, b)
end

local function visible_label(s)
    s = tostring(s or '')
    local i = s:find('##', 1, true)
    if i then s = s:sub(1, i - 1) end
    return s
end

local function paint_cursor(imgui, text, wrap)
    if not active then return end
    local x, y = cursor(imgui)
    if not x then return end
    outline.paint_at(imgui, x, y, text, { wrap = wrap == true })
end

local function frame_pad(imgui)
    if imgui and imgui.GetStyle then
        local ok, st = pcall(imgui.GetStyle)
        if ok and type(st) == 'table' then
            local px, py = theme.xy(st.FramePadding)
            if px then return px, py or 0 end
        end
    end
    return 0, 0
end

local function paint_padded(imgui, text)
    if not active then return end
    local x, y = cursor(imgui)
    if not x then return end
    local px, py = frame_pad(imgui)
    outline.paint_at(imgui, x + (px or 0), y + (py or 0), visible_label(text))
end

-- 混在する 1 行：縁を全部先に、本文を全部あとから。line_begin〜line_end のあいだは
-- Text* / paint をキューに溜める（カーソルは Dummy で進める）。
local line_q = nil

local function col_u32(col, fallback)
    if type(col) == 'number' then return col end
    if type(col) == 'string' then
        local ok, v = pcall(theme.u32, col, 1)
        if ok and type(v) == 'number' then return v end
    end
    if type(col) == 'table' then
        local r = tonumber(col[1] or col.r or col.x)
        local g = tonumber(col[2] or col.g or col.y)
        local b = tonumber(col[3] or col.b or col.z)
        local a = tonumber(col[4] or col.a or col.w) or 1
        if r and g and b then
            if r <= 1 and g <= 1 and b <= 1 then
                r, g, b = math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
            else
                r, g, b = math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5)
            end
            local ok, v = pcall(theme.rgba, r, g, b, a)
            if ok and type(v) == 'number' then return v end
        end
    end
    -- userdata / cdata の ImVec4 も読む（表として取れないとき）
    if col ~= nil and type(col) ~= 'number' and type(col) ~= 'string' then
        local function field(k1, k2, k3)
            local ok, v = pcall(function ()
                if type(col[k1]) ~= 'nil' then return col[k1] end
                if k2 and type(col[k2]) ~= 'nil' then return col[k2] end
                if k3 and type(col[k3]) ~= 'nil' then return col[k3] end
                return nil
            end)
            if ok then return tonumber(v) end
            return nil
        end
        local r, g, b = field(1, 'r', 'x'), field(2, 'g', 'y'), field(3, 'b', 'z')
        local a = field(4, 'a', 'w') or 1
        if r and g and b then
            if r <= 1 and g <= 1 and b <= 1 then
                r, g, b = math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
            else
                r, g, b = math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5)
            end
            local ok, v = pcall(theme.rgba, r, g, b, a)
            if ok and type(v) == 'number' then return v end
        end
    end
    local ok, v = pcall(theme.u32, fallback or 'text', 1)
    if ok and type(v) == 'number' then return v end
    return 0xFFFFFFFF
end

outline.pack_color = col_u32

local function dummy_text(imgui, text)
    local w = measure_w(imgui, tostring(text or '')) or 1
    local h = font_size(imgui)
    if imgui.Dummy then pcall(imgui.Dummy, { w, h }) end
end

function outline.line_begin()
    line_q = {}
end

function outline.in_line()
    return line_q ~= nil
end

function outline.line_push(x, y, text, col)
    if line_q == nil then return false end
    text = tostring(text or '')
    if text == '' or text == ' ' then
        -- 空白も幅は呼び出し側で進める。描画はしない／空白は本文だけでもよい
        if text == ' ' and x and y then
            line_q[#line_q + 1] = { x = x, y = y, text = ' ', col = col, skip_outline = true }
        end
        return true
    end
    x, y = tonumber(x), tonumber(y)
    if not x or not y then return true end
    line_q[#line_q + 1] = { x = x, y = y, text = text, col = col }
    return true
end

function outline.line_end(imgui)
    local q = line_q
    line_q = nil
    if not q or #q == 0 then return end
    if active then
        for i = 1, #q do
            local p = q[i]
            if not p.skip_outline then
                outline.paint_at(imgui, p.x, p.y, p.text)
            end
        end
    end
    if not imgui then return end
    local dl = imgui.GetWindowDrawList and imgui.GetWindowDrawList()
    if not dl then return end
    for i = 1, #q do
        local p = q[i]
        add_text_4(dl, p.x, p.y, p.col or col_u32(nil, 'text'), p.text)
    end
end

local function hook(imgui)
    if hooked_for == imgui then return end
    hooked_for = imgui
    orig.Text = imgui.Text
    orig.TextColored = imgui.TextColored
    orig.TextDisabled = imgui.TextDisabled
    orig.TextWrapped = imgui.TextWrapped
    orig.TextUnformatted = imgui.TextUnformatted
    -- Button / SmallButton / Selectable はフックしない。
    -- 公式ラベル位置（中央揃え・SmallButton のベースライン）と FramePadding からの縁がずれ、
    -- 「縁の形が変」に見えた。見える文字は Text* で描き、ここの Text フックだけを使う（本の一覧と同じ）。

    imgui.Text = function (text, ...)
        if line_q then
            local x, y = cursor(imgui)
            outline.line_push(x, y, text, col_u32(nil, 'text'))
            dummy_text(imgui, text)
            return
        end
        paint_cursor(imgui, text, false)
        if orig.Text then return orig.Text(text, ...) end
    end
    imgui.TextColored = function (col, text, ...)
        if line_q then
            local x, y = cursor(imgui)
            outline.line_push(x, y, text, col_u32(col, 'text'))
            dummy_text(imgui, text)
            return
        end
        paint_cursor(imgui, text, false)
        if orig.TextColored then return orig.TextColored(col, text, ...) end
    end
    imgui.TextDisabled = function (text, ...)
        if line_q then
            local x, y = cursor(imgui)
            outline.line_push(x, y, text, col_u32(nil, 'muted'))
            dummy_text(imgui, text)
            return
        end
        paint_cursor(imgui, text, false)
        if orig.TextDisabled then return orig.TextDisabled(text, ...) end
    end
    imgui.TextWrapped = function (text, ...)
        if line_q then
            local x, y = cursor(imgui)
            outline.line_push(x, y, text, col_u32(nil, 'text'))
            dummy_text(imgui, text)
            return
        end
        paint_cursor(imgui, text, true)
        if orig.TextWrapped then return orig.TextWrapped(text, ...) end
    end
    imgui.TextUnformatted = function (text, ...)
        if line_q then
            local x, y = cursor(imgui)
            outline.line_push(x, y, text, col_u32(nil, 'text'))
            dummy_text(imgui, text)
            return
        end
        paint_cursor(imgui, text, false)
        if orig.TextUnformatted then return orig.TextUnformatted(text, ...) end
    end
end

function outline.enter(ui, name)
    active = false
    if not ui or not WINDOWS[name] then return end
    local S = ui.settings
    if not S then return end
    width = outline.clamp_width(S.font_crisp_outline)
    alpha = outline.clamp_alpha(S.font_crisp_outline_alpha)
    if width <= 0 or alpha <= 0 then return end
    -- 0.1.251：くっきりオフ、またはフォールバックの倍率経路では縁を付けない。
    -- 0.1.249 の PushFont(GetFont(), GetFontSize()) は、GetFontSize が
    -- SetWindowFontScale 込みの大きさなのに、PushFont 側で倍率がもう一度掛かり、
    -- 本文よりずっと大きい黒い縁が重なった。同じ大きさへ確実に合わせられないため、
    -- PushFont で大きさだけ決めているくっきりオンのときだけ描く。
    if S.font_crisp == false then return end
    if ui._crisp_pushed ~= true then return end
    if ui.imgui then hook(ui.imgui) end
    active = true
end

function outline.leave()
    active = false
end

function outline._reset()
    active = false
    width, alpha = 0, 0.85
    last_pts, last_w = nil, nil
    line_q = nil
end

-- テスト用：今のずらしと色
function outline._state()
    return { width = width, alpha = alpha, active = active }
end

return outline
