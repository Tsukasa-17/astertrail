--[[
  Astertrail - 画面の部品
  ボタンと行は、選択（focus）に登録し、マウス・キー・パッドで同じ印を出す。
]]

local theme = require('src.ui.theme')
local focus = require('src.ui.focus')
local window = require('src.ui.window')
local CT = require('src.ui.colored_text')

local W = {}

-- マウスが動いたか（動いた時だけ hover で選択を動かす）
local mouse = { x = -1, y = -1, moved = false }

function W.frame_start(imgui)
    local x, y = imgui.GetMousePos()
    x, y = x or -1, y or -1
    mouse.moved = (x ~= mouse.x or y ~= mouse.y)
    mouse.x, mouse.y = x, y
end

-- defer=true の時は印を描かず、枠の位置を返す（表の中など、あとで描く時）
local function after_item(ui, win, id, focused, defer)
    local imgui = ui.imgui
    if imgui.IsItemHovered() and mouse.moved then
        focus.set(win, id, false, 'hover')
        focused = true
    end
    if focused then
        local x1, y1 = imgui.GetItemRectMin()
        local x2, y2 = imgui.GetItemRectMax()
        if focus.take_scroll(win, id) then imgui.SetScrollHereY(0.5) end
        if defer then return focused, { x1, y1, x2, y2 } end
        -- 選択枠は冒険の本と設定だけ（トラッカー・詳細だけ窓などには出さない）
        if focus.shows_frame(win) then
            theme.draw_focus(imgui, x1, y1, x2, y2, ui.reduce_motion)
        end
    end
    return focused
end
W.after_item = after_item

-- ボタン。戻り値: clicked（マウス or 決定）
function W.button(ui, win, id, label, opts)
    opts = opts or {}
    local imgui = ui.imgui
    -- no_focus：キー・パッドの選択に入れない（マウスだけで押す。詳細の ■/□ など、0.1.60〜）
    local focused, activated = false, false
    if not opts.no_focus then focused, activated = focus.item(win, id, opts.section, opts.row) end
    if opts.disabled then
        imgui.BeginDisabled(true)
        window.push(ui, 'disabled')
    end
    local clicked
    if opts.small then
        clicked = imgui.SmallButton(label .. '##' .. id)
    else
        clicked = imgui.Button(label .. '##' .. id, { opts.width or 0, 0 })
    end
    if opts.disabled then
        window.pop(ui, 'disabled')
        clicked, activated = false, false
    end
    if opts.tooltip and imgui.IsItemHovered() then imgui.SetTooltip(opts.tooltip) end
    if not opts.no_focus then after_item(ui, win, id, focused) end
    return clicked or activated
end

-- お知らせ専用の豪華なボタン（0.1.198〜）。金の縁・光・ホバー・押下・選択。本や設定では使わない
-- opts: { section, row, width, height, kind, alpha, disabled }
function W.popup_button(ui, win, id, label, opts)
    opts = opts or {}
    local imgui = ui.imgui
    label = tostring(label or '')
    local focused, activated = false, false
    if not opts.no_focus then focused, activated = focus.item(win, id, opts.section, opts.row) end
    local bw, bh = theme.popup_button_size(imgui, label)
    bw = tonumber(opts.width) or bw
    bh = tonumber(opts.height) or bh
    local clicked = false
    if imgui.InvisibleButton then
        clicked = imgui.InvisibleButton(label .. '##' .. id, { bw, bh }) and true or false
    else
        clicked = imgui.Button(label .. '##' .. id, { bw, bh }) and true or false
    end
    if opts.disabled then clicked, activated = false, false end
    local function xy(ok, a, b)
        if not ok then return nil, nil end
        if type(a) == 'table' then return tonumber(a.x or a[1]), tonumber(a.y or a[2]) end
        return tonumber(a), tonumber(b)
    end
    local x1, y1 = xy(pcall(imgui.GetItemRectMin))
    local x2, y2 = xy(pcall(imgui.GetItemRectMax))
    if not (x1 and y1 and x2 and y2) then
        x1, y1, x2, y2 = 0, 0, bw, bh
    end
    local hover = imgui.IsItemHovered and imgui.IsItemHovered() or false
    local pressed = imgui.IsItemActive and imgui.IsItemActive() or false
    theme.draw_popup_button(imgui, x1, y1, x2, y2, label, {
        hover = hover, pressed = pressed, focused = focused,
        kind = opts.kind or 'accept', alpha = opts.alpha,
        reduce_motion = ui.settings and ui.settings.reduce_motion,
    })
    if opts.tooltip and imgui.IsItemHovered and imgui.IsItemHovered() then imgui.SetTooltip(opts.tooltip) end
    if not opts.no_focus then after_item(ui, win, id, focused) end
    return clicked or activated
end

-- 絵のボタン（0.1.173〜、⚙️・コンパス・トラッカー）。四角いボタンの上に draw(dl, cx, cy, r) で絵を描く。
-- 文字は出さず、マウスを乗せると tooltip。キー・パッドの選択にも入る（W.button と同じ）
function W.icon_button(ui, win, id, draw, opts)
    opts = opts or {}
    local imgui = ui.imgui
    local focused, activated = false, false
    if not opts.no_focus then focused, activated = focus.item(win, id, opts.section, opts.row) end
    local h = 22
    if imgui.GetFrameHeight then
        local ok, v = pcall(imgui.GetFrameHeight)
        if ok and tonumber(v) then h = tonumber(v) end
    end
    local w = math.floor(h * (opts.aspect or 1.25) + 0.5)
    -- small（0.1.189〜、t318）：小さいボタン（☆ など SmallButton）と同じ箱。高さは文字の高さ、幅は like（初めは ☆）の字の幅＋左右の余白。
    -- 文字の大きさに合わせて変わる（☆ と同じ）
    if opts.small then
        local fs
        if imgui.GetFontSize then
            local ok, v = pcall(imgui.GetFontSize)
            if ok and tonumber(v) and tonumber(v) > 0 then fs = tonumber(v) end
        end
        fs = fs or h
        local tw
        if imgui.CalcTextSize then
            local ok, a, b = pcall(imgui.CalcTextSize, opts.like or '☆')
            if ok then
                if type(a) == 'table' then a = a.x or a[1] end
                tw = tonumber(a)
            end
        end
        local padx = 8
        pcall(function ()
            local st = imgui.GetStyle()
            local fp = st and st.FramePadding
            local x = fp and (fp.x or fp[1])
            if tonumber(x) then padx = tonumber(x) end
        end)
        h = fs
        w = math.floor((tw and tw > 0 and tw or fs) + padx * 2 + 0.5)
    end
    local clicked = imgui.Button('##' .. id, { w, h })
    pcall(function ()
        local x1, y1 = imgui.GetItemRectMin()
        local x2, y2 = imgui.GetItemRectMax()
        if type(x1) == 'table' then x1, y1 = x1.x or x1[1], x1.y or x1[2] end
        if type(x2) == 'table' then x2, y2 = x2.x or x2[1], x2.y or x2[2] end
        if x1 and y1 and x2 and y2 then
            local dl = imgui.GetWindowDrawList()
            draw(dl, (x1 + x2) / 2, (y1 + y2) / 2, math.max(4, math.min(x2 - x1, y2 - y1) * 0.36))
        end
    end)
    if opts.tooltip and imgui.IsItemHovered() then imgui.SetTooltip(opts.tooltip) end
    if not opts.no_focus then after_item(ui, win, id, focused) end
    return clicked or activated
end

-- 色付きの名前で、押すと動作する（地図を開くなど）。見た目はボタンではなく文字。
function W.link(ui, win, id, label, opts)
    opts = opts or {}
    local imgui = ui.imgui
    local C = theme.C
    -- no_focus：キー・パッドの選択に入れない（トラッカーのアイテム名のコピーなど、0.1.61〜）
    local focused, activated = false, false
    if not opts.no_focus then focused, activated = focus.item(win, id, opts.section, opts.row) end
    local col = theme.col(opts.color or 'npc')
    local n = 0
    local function pushc(idx, c)
        local ok = pcall(function () imgui.PushStyleColor(idx, c) end)
        if ok then n = n + 1 end
    end
    pushc(C('ImGuiCol_Button'), { 0, 0, 0, 0 })
    pushc(C('ImGuiCol_ButtonHovered'), theme.col(opts.color or 'npc', 0.22))
    pushc(C('ImGuiCol_ButtonActive'), theme.col(opts.color or 'npc', 0.35))
    pushc(C('ImGuiCol_Text'), col)
    local okv = pcall(function () imgui.PushStyleVar(C('ImGuiStyleVar_FramePadding'), { 0, 0 }) end)
    local clicked = imgui.SmallButton(label .. '##' .. id)
    if okv then pcall(function () imgui.PopStyleVar(1) end) end
    if n > 0 then pcall(function () imgui.PopStyleColor(n) end) end
    if opts.tooltip and imgui.IsItemHovered() then imgui.SetTooltip(opts.tooltip) end
    if opts.bold then
        -- 太字の代わり：同じ文字を 1px 右にもう一度描く（ImGui に太字のフォントが無いため）
        pcall(function ()
            local x1, y1 = imgui.GetItemRectMin()
            local dl = imgui.GetWindowDrawList()
            dl:AddText({ x1 + 1, y1 }, theme.u32(opts.color or 'npc', 1.0), label)
        end)
    end
    if not opts.no_focus then after_item(ui, win, id, focused) end
    return clicked or activated
end

-- 「発生NPC: Name」のように、前置き＋色付きの名前。click があれば名前を押せる。
-- 戻り値: 名前が押されたか
function W.named(ui, win, id, template, name, opts)
    opts = opts or {}
    local imgui = ui.imgui
    local marked = (template or '{name}'):gsub('{name}', '', 1)
    local pre, post = marked:match('^(.*)(.*)$')
    if not pre then pre, post = '', '' end
    if pre ~= '' then
        if imgui.AlignTextToFramePadding then pcall(imgui.AlignTextToFramePadding) end
        if opts.muted ~= false then imgui.TextDisabled(pre) else imgui.Text(pre) end
        imgui.SameLine(0, 0)
    end
    local clicked = false
    if opts.click then
        clicked = W.link(ui, win, id, name, {
            color = opts.color or 'npc', section = opts.section, row = opts.row,
            tooltip = opts.tooltip,
        })
    else
        imgui.TextColored(theme.col(opts.color or 'npc'), name)
    end
    if post and post ~= '' then
        imgui.SameLine(0, 0)
        if opts.muted ~= false then imgui.TextDisabled(post) else imgui.Text(post) end
    end
    return clicked
end

--[[
  行。lines = { {text=, muted=bool, color=name, terms=色分けの言葉, spans=色付きの区切り}, ... }
  幅いっぱいのまとまりとして描き、クリック／決定で true
]]
function W.row(ui, win, id, lines, opts)
    opts = opts or {}
    local imgui = ui.imgui
    local focused, activated = focus.item(win, id, opts.section, opts.row)
    local avail = imgui.GetContentRegionAvail()
    imgui.BeginGroup()
    window.push(ui, 'group')
    imgui.PushTextWrapPos(0)
    window.push(ui, 'wrap')
    for _, l in ipairs(lines) do
        if l.same_line then imgui.SameLine() end
        if l.spans or l.terms then
            CT.draw_spans(ui, l.spans or CT.spans(l.text, l.terms), { base = l.color, muted = l.muted })
        elseif l.color then
            imgui.TextColored(theme.col(l.color), tostring(l.text or ''))
        elseif l.muted then
            imgui.TextDisabled(tostring(l.text or ''))
        else
            imgui.TextWrapped(tostring(l.text or ''))
        end
    end
    window.pop(ui, 'wrap')
    imgui.Dummy({ math.max(1, (avail or 200) - 4), 2 })
    window.pop(ui, 'group')
    local clicked = (opts.click ~= false) and imgui.IsItemClicked(0)
    after_item(ui, win, id, focused)
    return clicked or activated
end

-- 文だけの行は窓の幅で折り返す（狭くしても消えない。日本語は一文字ずつ折る）
function W.text(ui, s) CT.wrapped(ui, s, 'text') end
function W.muted(ui, s) CT.wrapped(ui, s, 'muted') end
function W.colored(ui, name, s) CT.wrapped(ui, s, name) end
-- 名前に色を付けた文（terms は colored_text の言葉の一覧）
function W.ctext(ui, s, terms, opts) CT.draw(ui, s, terms, opts) end

-- 色付きの名前が押せる文。戻り値: { act='map'|'copy', text=, kind= } または nil
function W.term_line(ui, win, id, text, terms, opts)
    opts = opts or {}
    local clicked
    CT.draw(ui, text, terms, {
        base = opts.color, muted = opts.muted, wrap = opts.wrap, align = opts.align,
        link = function (piece, act)
            local tip = opts.tip and opts.tip(act, piece) or nil
            -- 折り返して下の段に出た名前は、キー・パッドでも上下で移る（0.1.175〜。段ごとに行を分ける）
            local row = opts.row
            if row ~= nil and ui.imgui.GetCursorPosY then
                local okp, cy = pcall(ui.imgui.GetCursorPosY)
                if okp and tonumber(cy) then row = tostring(row) .. '@' .. tostring(math.floor(tonumber(cy) + 0.5)) end
            end
            return W.link(ui, win, id .. '_' .. (piece.kind or 'x') .. '_' .. tostring(piece.text), piece.text, {
                color = piece.color or CT.KIND_COLOR[piece.kind] or 'npc',
                tooltip = tip, section = opts.section, row = row,
                -- focus_acts があれば、その種類の名前だけをキー・パッドで選べる（0.1.61〜）
                no_focus = opts.focus_acts ~= nil and not opts.focus_acts[act],
            })
        end,
        on_linked = function (act, piece)
            clicked = { act = act, text = piece.text, kind = piece.kind }
        end,
    })
    return clicked
end
function W.sep(ui) ui.imgui.Separator() end
function W.same(ui) ui.imgui.SameLine() end

-- チェックやコンボと同じ高さに揃えるラベル（本の「表示：」「列：」。0.1.200〜）
function W.frame_label(ui, text, disabled)
    local imgui = ui.imgui
    if imgui.AlignTextToFramePadding then pcall(imgui.AlignTextToFramePadding) end
    if disabled then imgui.TextDisabled(text) else imgui.Text(text) end
end

function W.heading(ui, s)
    local imgui = ui.imgui
    imgui.TextColored(theme.col('heading'), s)
    theme.heading_line(imgui)
end


---------------------------------------------------------------------------
-- 数値の設定の1行：名前 ／ 初期値に戻す（↺）／ スライダー ／ － ／ ＋ ／ 値と単位
-- 値は step 刻みに丸め、lo〜hi に収める。初期値と同じときは ↺ を薄くして押せなくする。
-- キー・パッド：スライダーを選んで左右で1刻み、↺ を選んで決定で初期値。
-- マウスの －／＋ でも1刻み（細かい調整用）。
-- 0.1.234〜：ドラッグ中は値をまだ設定に書かない（離したとき確定）。
--   文字サイズを動かすと設定のレイアウトが変わり、つまみがマウスの下からずれて値が暴れるのを防ぐ。
---------------------------------------------------------------------------

function W.snap(v, step, lo, hi)
    v = tonumber(v) or lo
    step = tonumber(step) or 0
    if step > 0 then v = lo + math.floor((v - lo) / step + 0.5) * step end
    v = math.floor(v * 100 + 0.5) / 100
    if v < lo then v = lo elseif v > hi then v = hi end
    return v
end

local function frame_h(imgui)
    local ok, h = pcall(imgui.GetFrameHeight)
    h = ok and tonumber(h) or nil
    return h or 20
end

-- 直前の項目の四角（x1, y1, x2, y2）。測れなければ nil
function W.item_rect(imgui)
    local function xy(a, b)
        if type(a) == 'table' then return a.x or a[1], a.y or a[2] end
        return a, b
    end
    local ok1, a1, b1 = pcall(imgui.GetItemRectMin)
    local ok2, a2, b2 = pcall(imgui.GetItemRectMax)
    if not (ok1 and ok2) then return nil end
    local x1, y1 = xy(a1, b1)
    local x2, y2 = xy(a2, b2)
    x1, y1, x2, y2 = tonumber(x1), tonumber(y1), tonumber(x2), tonumber(y2)
    if not (x1 and y1 and x2 and y2) or x2 <= x1 or y2 <= y1 then return nil end
    return { x1, y1, x2, y2 }
end

-- YunaUI 風の色（桃色のネオン）
local PINK = { 1.00, 0.42, 0.72 }
local function u4(r, g, b, a) return theme.rgba(math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5), a) end

-- ImGui のスライダーの地とつまみを透明にする。戻り値: 積んだ数
function W.hide_slider(imgui)
    local n = 0
    for _, name in ipairs({ 'ImGuiCol_FrameBg', 'ImGuiCol_FrameBgHovered', 'ImGuiCol_FrameBgActive',
                            'ImGuiCol_SliderGrab', 'ImGuiCol_SliderGrabActive' }) do
        if pcall(imgui.PushStyleColor, theme.C(name), { 0, 0, 0, 0 }) then n = n + 1 end
    end
    return n
end

-- 細い暗い溝、左から桃色の帯（両端は丸い）。触っている・選んでいる間だけ白い丸
function W.draw_slider(imgui, r, f, knob)
    local dl = imgui.GetWindowDrawList()
    if not dl then return end
    f = math.max(0, math.min(1, tonumber(f) or 0))
    local x1, x2 = r[1], r[3]
    local h = r[4] - r[2]
    local cy = (r[2] + r[4]) / 2
    local th = math.max(4, math.floor(h * 0.22 + 0.5))
    dl:AddRectFilled({ x1, cy - th / 2 }, { x2, cy + th / 2 }, u4(1, 1, 1, 0.13), th / 2)
    if f > 0 then
        dl:AddRectFilled({ x1, cy - th / 2 }, { math.max(x1 + th, x1 + (x2 - x1) * f), cy + th / 2 }, u4(PINK[1], PINK[2], PINK[3], 1), th / 2)
    end
    if knob then
        local kx = x1 + (x2 - x1) * f
        local kr = math.max(5, h * 0.27)
        dl:AddCircleFilled({ kx, cy + 1 }, kr, u4(0, 0, 0, 0.35), 20)
        dl:AddCircleFilled({ kx, cy }, kr, u4(1, 1, 1, 1), 20)
    end
end

-- オン・オフの丸いスイッチ（YunaUI 風）。名前の右に置き、行ごと押せる。
-- opts: { section, row, col_x = スイッチを置く位置（名前の列の右）, reduce_motion }
local SWA = {}
function W.switch(ui, win, id, label, on, opts)
    opts = opts or {}
    local imgui = ui.imgui
    local focused, activated = focus.item(win, id, opts.section, opts.row or id)
    imgui.BeginGroup()
    window.push(ui, 'group')
    if imgui.AlignTextToFramePadding then pcall(imgui.AlignTextToFramePadding) end
    imgui.Text(label)
    if opts.col_x then
        if not pcall(imgui.SameLine, opts.col_x) then imgui.SameLine() end
    else
        imgui.SameLine()
    end
    local h = frame_h(imgui)
    local sh = math.max(12, math.floor(h * 0.72 + 0.5))   -- YunaUI より低め
    local sw = sh * 2
    local okp, px, py = pcall(imgui.GetCursorScreenPos)
    if okp and type(px) == 'table' then px, py = px.x or px[1], px.y or px[2] end
    local pressed = imgui.InvisibleButton(label .. '##' .. id, { sw, h })
    local hov = imgui.IsItemHovered()
    window.pop(ui, 'group')
    -- 名前の上を押したときも切り替える（スイッチの上は、スイッチ自身が押した後に返す。二重にしない）
    local row_clicked = (not hov) and imgui.IsItemClicked and imgui.IsItemClicked(0) or false
    -- つまみはゆっくり滑る（動きを減らす設定なら、すぐ）
    local target = on and 1 or 0
    local v = SWA[id] or target
    if opts.reduce_motion then v = target
    else
        local dt = 0.016
        local okio, io = pcall(imgui.GetIO)
        if okio and type(io) == 'table' and tonumber(io.DeltaTime) then dt = tonumber(io.DeltaTime) end
        v = v + (target - v) * math.min(1, dt * 14)
        if math.abs(v - target) < 0.01 then v = target end
    end
    SWA[id] = v
    if tonumber(px) and tonumber(py) then
        pcall(function ()
            local dl = imgui.GetWindowDrawList()
            local x, y = px, py + (h - sh) / 2
            local c0 = { 0.16, 0.15, 0.19 }
            local c1 = { PINK[1] * 0.92, PINK[2] * 0.92, PINK[3] * 0.92 }
            local function mix(i) return c0[i] + (c1[i] - c0[i]) * v end
            dl:AddRectFilled({ x, y }, { x + sw, y + sh }, u4(mix(1), mix(2), mix(3), 1), sh / 2)
            dl:AddRect({ x - 0.5, y - 0.5 }, { x + sw + 0.5, y + sh + 0.5 }, u4(0, 0, 0, 0.40), sh / 2 + 0.5, 0, 1.2)
            dl:AddRect({ x, y }, { x + sw, y + sh }, u4(1, 1, 1, 0.10 * (1 - v)), sh / 2, 0, 1)
            local m = math.max(2, sh * 0.12)
            local kh = sh - m * 2
            local kw = kh * 28 / 21
            local kx = x + m + (sw - m * 2 - kw) * v
            local ky = y + m
            dl:AddRectFilled({ kx, ky + 1.5 }, { kx + kw, ky + kh + 1.5 }, u4(0, 0, 0, 0.30), kh / 2)
            local kc = hov and 1.0 or 0.95
            dl:AddRectFilled({ kx, ky }, { kx + kw, ky + kh }, u4(kc, kc, kc, 1), kh / 2)
        end)
    end
    after_item(ui, win, id, focused)
    return pressed or row_clicked or activated
end

-- 四角の印と名前（■ 出す／▢ 隠す）。印はフォントに頼らず自分で描く。
local function chip_metrics(imgui)
    local h = frame_h(imgui)
    local sq = math.max(8, math.floor(h * 0.5 + 0.5))
    return h, sq, math.floor(sq * 0.5 + 0.5)
end
local function text_width(imgui, s)
    local ok, a = pcall(imgui.CalcTextSize, s)
    if not ok then return #s * 7 end
    if type(a) == 'table' then a = a.x or a[1] end
    return tonumber(a) or #s * 7
end
function W.check_chip_width(imgui, label)
    local _, sq, gap = chip_metrics(imgui)
    return sq + gap + text_width(imgui, label) + 12
end
function W.check_chip(ui, win, id, label, on, opts)
    opts = opts or {}
    local imgui = ui.imgui
    local focused, activated = focus.item(win, id, opts.section, opts.row or id)
    local h, sq, gap = chip_metrics(imgui)
    local okp, px, py = pcall(imgui.GetCursorScreenPos)
    if okp and type(px) == 'table' then px, py = px.x or px[1], px.y or px[2] end
    imgui.BeginGroup()
    window.push(ui, 'group')
    imgui.Dummy({ sq + gap, h })
    imgui.SameLine(0, 0)
    if imgui.AlignTextToFramePadding then pcall(imgui.AlignTextToFramePadding) end
    if on then imgui.TextColored(theme.col('text'), label) else imgui.TextDisabled(label) end
    window.pop(ui, 'group')
    local hov = imgui.IsItemHovered()
    local clicked = imgui.IsItemClicked and imgui.IsItemClicked(0) or false
    if hov and opts.tooltip then imgui.SetTooltip(opts.tooltip) end
    if tonumber(px) and tonumber(py) then
        pcall(function ()
            local dl = imgui.GetWindowDrawList()
            local x, y = px + 1, py + (h - sq) / 2
            local yuna = theme.look == 'yunaui'
            local r = yuna and 2 or 1
            if on then
                local c = yuna and theme.CAPSULE.pink or theme.palette.accent
                local u = theme.rgba(math.floor(c[1] * 255), math.floor(c[2] * 255), math.floor(c[3] * 255), 1)
                dl:AddRectFilled({ x, y }, { x + sq, y + sq }, u, r)
            else
                dl:AddRect({ x + 0.5, y + 0.5 }, { x + sq - 0.5, y + sq - 0.5 }, theme.u32('muted', hov and 1.0 or 0.8), r, 0, 1.5)
            end
        end)
    end
    after_item(ui, win, id, focused)
    return clicked or activated
end

-- 色の見本：ゲームと同じ黒い地に、見本の文字を設定の色で（グラデーションなら一文字ずつ）。右に #RRGGBB
-- c1, c2 は {r, g, b}（0〜255）。c2 が nil なら単色
function W.color_preview(ui, sample, c1, c2)
    local imgui = ui.imgui
    sample = tostring(sample or '')
    local chars = {}
    for ch in sample:gmatch('[%z\1-\127\194-\244][\128-\191]*') do chars[#chars + 1] = ch end
    local function at(t)
        if not c2 then return c1 end
        return { c1[1] + (c2[1] - c1[1]) * t, c1[2] + (c2[2] - c1[2]) * t, c1[3] + (c2[3] - c1[3]) * t }
    end
    if imgui.AlignTextToFramePadding then pcall(imgui.AlignTextToFramePadding) end
    local okp, px, py = pcall(imgui.GetCursorScreenPos)
    if okp and type(px) == 'table' then px, py = px.x or px[1], px.y or px[2] end
    local tw = text_width(imgui, sample)
    local h = frame_h(imgui)
    if tonumber(px) and tonumber(py) then
        pcall(function ()
            local dl = imgui.GetWindowDrawList()
            dl:AddRectFilled({ px - 6, py - 2 }, { px + tw + 6, py + h + 2 }, theme.rgba(0, 0, 0, 0.80), 4)
        end)
    end
    for i, ch in ipairs(chars) do
        if i > 1 then imgui.SameLine(0, 0) end
        local c = at((#chars <= 1) and 0 or (i - 1) / (#chars - 1))
        imgui.TextColored({ c[1] / 255, c[2] / 255, c[3] / 255, 1 }, ch)
    end
    imgui.SameLine(0, 18)
    local hex = string.format('#%02X%02X%02X', math.floor(c1[1] + 0.5), math.floor(c1[2] + 0.5), math.floor(c1[3] + 0.5))
    if c2 then hex = hex .. ' → ' .. string.format('#%02X%02X%02X', c2[1], c2[2], c2[3]) end
    imgui.TextDisabled(hex)
end

-- 自前の「初期値に戻す」印（時計回りの円弧と矢じり ↻）。字形に頼らない（フォントに ↻ が無いことがある）
-- ImGui は Y が下向きなので、角の増え方向が画面上の時計回りになる。
local function draw_reset_icon(imgui, x, y, size, col)
    local dl = imgui.GetWindowDrawList and imgui.GetWindowDrawList()
    if not dl then return end
    local cx, cy = x + size / 2, y + size / 2
    local r = size * 0.30
    -- 右やや下から時計回りに、上で終わる（右上を開け、矢じりは上で右向き）
    local a0, a1 = math.pi * 0.12, math.pi * 1.52
    local drawn = pcall(function ()
        dl:PathClear()
        dl:PathArcTo({ cx, cy }, r, a0, a1, 16)
        local ok = pcall(function () dl:PathStroke(col, 0, 1.6) end)
        if not ok then dl:PathStroke(col, false, 1.6) end
    end)
    if not drawn then
        pcall(function () dl:AddCircle({ cx, cy }, r, col, 16, 1.6) end)
    end
    -- 矢じり（円弧の終わりの接線方向へ）
    local tx, ty = -math.sin(a1), math.cos(a1)
    local nx, ny = -ty, tx
    local ex = cx + r * math.cos(a1)
    local ey = cy + r * math.sin(a1)
    local s = size * 0.18
    local tipx, tipy = ex + tx * s * 0.85, ey + ty * s * 0.85
    local bx, by = ex - tx * s * 0.25, ey - ty * s * 0.25
    pcall(function ()
        dl:AddTriangleFilled(
            { tipx, tipy },
            { bx + nx * s * 0.7, by + ny * s * 0.7 },
            { bx - nx * s * 0.7, by - ny * s * 0.7 },
            col)
    end)
end

-- 初期値に戻すボタン（↻）。同じ行に置く。初期値のときは薄くて押せない。
-- opts: { section, row, tooltip, at_default, no_focus }
function W.reset_button(ui, win, id, opts)
    opts = opts or {}
    local imgui = ui.imgui
    local at_default = opts.at_default == true
    local focused, activated = false, false
    if not opts.no_focus then focused, activated = focus.item(win, id, opts.section, opts.row) end
    local h = frame_h(imgui)
    local okp, px, py = pcall(imgui.GetCursorScreenPos)
    local pressed = imgui.InvisibleButton('##' .. id, { h, h })
    local hovered = imgui.IsItemHovered()
    if okp and type(px) == 'table' then px, py = px.x or px[1], px.y or px[2] end
    if px and py then
        if hovered and not at_default then
            pcall(function ()
                imgui.GetWindowDrawList():AddRectFilled({ px, py }, { px + h, py + h }, theme.u32('accent', 0.18), 4)
            end)
        end
        draw_reset_icon(imgui, px, py, h, theme.u32(at_default and 'muted' or 'text', at_default and 0.35 or 0.95))
    end
    local tip = opts.tooltip
    if tip and (hovered or focused) and imgui.SetTooltip then pcall(imgui.SetTooltip, tip) end
    if not opts.no_focus then after_item(ui, win, id, focused) end
    return ((pressed or activated) and not at_default) and true or false
end

-- opts: { step, lo, hi, default, text = function(v) → 表示, section, label_w, slider_w, tooltip_reset }
-- 戻り値: changed
-- ドラッグ中の仮の値（窓と項目ごと）。離すまで tbl には書かない
local slider_drag = {}

function W.slider(ui, win, id, label, tbl, key, opts)
    local imgui = ui.imgui
    local step, lo, hi = opts.step or 1, opts.lo or 0, opts.hi or 1
    local def = opts.default
    local v = W.snap(tbl[key], step, lo, hi)
    if v ~= tbl[key] then tbl[key] = v end
    local committed = v
    local changed = false

    -- 名前（左の列をそろえる）
    if imgui.AlignTextToFramePadding then pcall(imgui.AlignTextToFramePadding) end
    imgui.Text(label)
    if opts.label_w then
        if not pcall(imgui.SameLine, opts.label_w) then imgui.SameLine() end
    else
        imgui.SameLine()
    end

    -- 初期値に戻す
    local h = frame_h(imgui)
    local at_default = (def == nil) or (math.abs(v - def) < 1e-6)
    local rid = id .. '_reset'
    local rfocused, ractivated = focus.item(win, rid, opts.section, opts.row or id)
    local okp, px, py = pcall(imgui.GetCursorScreenPos)
    local pressed = imgui.InvisibleButton('##' .. rid, { h, h })
    local hovered = imgui.IsItemHovered()
    if okp and type(px) == 'table' then px, py = px.x or px[1], px.y or px[2] end
    if px and py then
        if hovered and not at_default then
            pcall(function ()
                imgui.GetWindowDrawList():AddRectFilled({ px, py }, { px + h, py + h }, theme.u32('accent', 0.18), 4)
            end)
        end
        draw_reset_icon(imgui, px, py, h, theme.u32(at_default and 'muted' or 'text', at_default and 0.35 or 0.95))
    end
    if hovered and opts.tooltip_reset then imgui.SetTooltip(opts.tooltip_reset) end
    after_item(ui, win, rid, rfocused)
    local drag_key = tostring(win) .. '/' .. tostring(id)
    if (pressed or ractivated) and not at_default then
        v = def
        changed = true
        slider_drag[drag_key] = nil
    end
    imgui.SameLine()

    -- スライダー（中の文字は出さず、右に値を出す）
    local sfocused = focus.item(win, id, opts.section, opts.row or id, true)
    if slider_drag[drag_key] ~= nil then v = slider_drag[drag_key] end
    local buf = { v }
    local w = opts.slider_w or 160
    if not pcall(imgui.SetNextItemWidth, w) then pcall(imgui.PushItemWidth, w); pcall(imgui.PopItemWidth) end
    -- YunaUI 風：ImGui のスライダーは透明にして動きはそのまま使い、上に細い溝と桃色の帯を描く
    local yuna = theme.look == 'yunaui'
    local hidden = yuna and W.hide_slider(imgui) or 0
    local sok, moved = pcall(imgui.SliderFloat, '##' .. id, buf, lo, hi, '')
    if hidden > 0 then pcall(imgui.PopStyleColor, hidden) end
    local srect = yuna and W.item_rect(imgui) or nil
    local s_hov = yuna and imgui.IsItemHovered() or false
    -- いまつまみをドラッグしているか（設定の文字サイズをその場で変えないための判定）
    local active = false
    do
        local oka, a = pcall(function ()
            return imgui.IsItemActive and imgui.IsItemActive()
        end)
        active = oka and a and true or false
    end
    local s_act = yuna and active or false
    if sok and moved and tonumber(buf[1]) then
        local nv = W.snap(buf[1], step, lo, hi)
        if active then
            -- ドラッグ中は見た目だけ動かし、設定（設定の文字サイズを含む）にはまだ書かない
            slider_drag[drag_key] = nv
            v = nv
        else
            -- クリックやテスト、または離したフレーム：ここで確定
            slider_drag[drag_key] = nil
            if nv ~= committed then v = nv; changed = true end
        end
    elseif active then
        if slider_drag[drag_key] ~= nil then v = slider_drag[drag_key] end
    elseif slider_drag[drag_key] ~= nil then
        local nv = W.snap(slider_drag[drag_key], step, lo, hi)
        slider_drag[drag_key] = nil
        if nv ~= committed then v = nv; changed = true end
    end
    after_item(ui, win, id, sfocused)
    local dir = focus.take_adjust(win, id)
    if dir then
        slider_drag[drag_key] = nil
        local nv = W.snap(v + dir * step, step, lo, hi)
        if nv ~= v then v = nv; changed = true end
    end
    if srect then
        pcall(W.draw_slider, imgui, srect, (v - lo) / math.max(1e-9, hi - lo), s_hov or s_act or sfocused)
    end
    -- －／＋（マウスの細かい調整。パッドはスライダー上の左右で同じ刻み）
    imgui.SameLine()
    local tip_minus, tip_plus
    if ui.t then
        tip_minus = ui.t('settings.step_minus')
        tip_plus = ui.t('settings.step_plus')
        if tip_minus == 'settings.step_minus' then tip_minus = nil end
        if tip_plus == 'settings.step_plus' then tip_plus = nil end
    end
    if W.button(ui, win, id .. '_minus', '－', {
        small = true, no_focus = true, disabled = (v <= lo + 1e-9), tooltip = tip_minus,
    }) then
        slider_drag[drag_key] = nil
        local nv = W.snap(v - step, step, lo, hi)
        if nv ~= v then v = nv; changed = true end
    end
    imgui.SameLine()
    if W.button(ui, win, id .. '_plus', '＋', {
        small = true, no_focus = true, disabled = (v >= hi - 1e-9), tooltip = tip_plus,
    }) then
        slider_drag[drag_key] = nil
        local nv = W.snap(v + step, step, lo, hi)
        if nv ~= v then v = nv; changed = true end
    end
    imgui.SameLine()
    if yuna then
        imgui.TextColored({ 1, 1, 1, 0.70 }, opts.text and opts.text(v) or tostring(v))
    else
        imgui.Text(opts.text and opts.text(v) or tostring(v))
    end

    if changed then
        tbl[key] = v
        if ui.mark_settings_dirty then ui.mark_settings_dirty() end
    end
    return changed
end


---------------------------------------------------------------------------
-- 色えらび（VanaCore のゲームの設定の色の行のような形を、こちらで組み直したもの）
--   行：名前・↺・色の見本と #RRGGBB。押す（決定）と色の窓が開く。
--   色の窓：あざやかさと明るさの四角、色合いの縦の帯、大きな見本、R/G/B の数、#RRGGBB の入力、ボタン。
---------------------------------------------------------------------------
function W.rgb_to_hsv(c)
    local r, g, b = (c[1] or 0) / 255, (c[2] or 0) / 255, (c[3] or 0) / 255
    local mx, mn = math.max(r, g, b), math.min(r, g, b)
    local d = mx - mn
    local h = 0
    if d > 1e-9 then
        if mx == r then h = ((g - b) / d) % 6
        elseif mx == g then h = (b - r) / d + 2
        else h = (r - g) / d + 4 end
        h = h / 6
    end
    local s = (mx > 1e-9) and (d / mx) or 0
    return h, s, mx
end

function W.hsv_to_rgb(h, s, v)
    h = (h or 0) % 1
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p, q, t = v * (1 - s), v * (1 - f * s), v * (1 - (1 - f) * s)
    local r, g, b
    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    else r, g, b = v, p, q end
    return { math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5) }
end

function W.hex(c)
    return string.format('#%02X%02X%02X', c[1] or 0, c[2] or 0, c[3] or 0)
end

-- '#A1209E' / 'a1209e' → {161, 32, 158}。読めなければ nil
function W.parse_hex(sx)
    sx = tostring(sx or ''):gsub('^%s*#?', ''):gsub('%s+$', '')
    if not sx:match('^%x%x%x%x%x%x$') then return nil end
    return { tonumber(sx:sub(1, 2), 16), tonumber(sx:sub(3, 4), 16), tonumber(sx:sub(5, 6), 16) }
end

local function u4c(c, a) return theme.rgba(c[1], c[2], c[3], a or 1) end

-- 四角に色を塗る。左上・右上・右下・左下の色（{r,g,b,a} 0〜255 と 0〜1）。
-- AddRectFilledMultiColor が無ければ、小さな升目で塗る
local function multi(dl, x1, y1, x2, y2, ul, ur, dr, dl_)
    local ok = pcall(function ()
        dl:AddRectFilledMultiColor({ x1, y1 }, { x2, y2 }, u4c(ul, ul[4]), u4c(ur, ur[4]), u4c(dr, dr[4]), u4c(dl_, dl_[4]))
    end)
    if ok then return end
    local n = 12
    local function mix(a, b, t) return { a[1] + (b[1] - a[1]) * t, a[2] + (b[2] - a[2]) * t, a[3] + (b[3] - a[3]) * t, a[4] + (b[4] - a[4]) * t } end
    for i = 0, n - 1 do
        for j = 0, n - 1 do
            local tx, ty = (i + 0.5) / n, (j + 0.5) / n
            local c = mix(mix(ul, ur, tx), mix(dl_, dr, tx), ty)
            local cx = { math.floor(c[1] + 0.5), math.floor(c[2] + 0.5), math.floor(c[3] + 0.5) }
            pcall(function ()
                dl:AddRectFilled({ x1 + (x2 - x1) * i / n, y1 + (y2 - y1) * j / n },
                    { x1 + (x2 - x1) * (i + 1) / n + 0.5, y1 + (y2 - y1) * (j + 1) / n + 0.5 }, u4c(cx, c[4]))
            end)
        end
    end
end

local hex_bufs = {}

-- 色の窓の中身。p は focus の picker（h, s, v）。戻り値: 'done' | 'cancel' | 'default' | nil
local function picker_body(ui, id, p, def)
    local imgui, t = ui.imgui, ui.t
    local h = frame_h(imgui)
    local size = math.floor(h * 7)
    local bar_w = math.floor(h * 0.9)
    local result
    local function xy()
        local okp, px, py = pcall(imgui.GetCursorScreenPos)
        if okp and type(px) == 'table' then px, py = px.x or px[1], px.y or px[2] end
        return tonumber(px) or 0, tonumber(py) or 0
    end
    local function mouse()
        local okm, mx, my = pcall(imgui.GetMousePos)
        if okm and type(mx) == 'table' then mx, my = mx.x or mx[1], mx.y or mx[2] end
        return tonumber(mx), tonumber(my)
    end
    local dl = imgui.GetWindowDrawList()
    -- あざやかさ（左右）と明るさ（上下）の四角
    local x0, y0 = xy()
    imgui.InvisibleButton('##sv_' .. id, { size, size })
    if imgui.IsItemActive() then
        local mx, my = mouse()
        if mx and my then
            p.s = math.max(0, math.min(1, (mx - x0) / size))
            p.v = math.max(0, math.min(1, 1 - (my - y0) / size))
            p.moved = true
        end
    end
    local hue = W.hsv_to_rgb(p.h, 1, 1)
    pcall(function ()
        multi(dl, x0, y0, x0 + size, y0 + size, { 255, 255, 255, 1 }, { hue[1], hue[2], hue[3], 1 }, { hue[1], hue[2], hue[3], 1 }, { 255, 255, 255, 1 })
        multi(dl, x0, y0, x0 + size, y0 + size, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 1 }, { 0, 0, 0, 1 })
        dl:AddRect({ x0, y0 }, { x0 + size, y0 + size }, theme.rgba(255, 255, 255, 0.15), 0, 0, 1)
        local cx, cy = x0 + p.s * size, y0 + (1 - p.v) * size
        dl:AddCircle({ cx, cy }, 6, theme.rgba(0, 0, 0, 0.8), 16, 3)
        dl:AddCircle({ cx, cy }, 6, theme.rgba(255, 255, 255, 1), 16, 1.5)
    end)
    -- 色合いの縦の帯
    imgui.SameLine(0, 10)
    local bx, by = xy()
    imgui.InvisibleButton('##hue_' .. id, { bar_w, size })
    if imgui.IsItemActive() then
        local _, my = mouse()
        if my then p.h = math.max(0, math.min(0.9999, (my - by) / size)); p.moved = true end
    end
    pcall(function ()
        for k = 0, 5 do
            local a, b = W.hsv_to_rgb(k / 6, 1, 1), W.hsv_to_rgb((k + 1) / 6, 1, 1)
            local ya, yb = by + size * k / 6, by + size * (k + 1) / 6
            multi(dl, bx, ya, bx + bar_w, yb + 0.5, { a[1], a[2], a[3], 1 }, { a[1], a[2], a[3], 1 }, { b[1], b[2], b[3], 1 }, { b[1], b[2], b[3], 1 })
        end
        local hy = by + p.h * size
        dl:AddRect({ bx - 2, hy - 3 }, { bx + bar_w + 2, hy + 3 }, theme.rgba(255, 255, 255, 1), 2, 0, 2)
    end)
    -- 大きな見本と、R/G/B の数、#RRGGBB
    local c = W.hsv_to_rgb(p.h, p.s, p.v)
    imgui.SameLine(0, 14)
    imgui.BeginGroup()
    window.push(ui, 'group')
    local px, py = xy()
    imgui.Dummy({ h * 3, h * 2 })
    pcall(function ()
        dl:AddRectFilled({ px, py }, { px + h * 3, py + h * 2 }, u4c(c, 1), 6)
        if p.orig then
            -- 下半分に開く前の色（くらべる用）
            dl:AddRectFilled({ px, py + h * 1.3 }, { px + h * 3, py + h * 2 }, u4c(p.orig, 1), 6)
        end
        dl:AddRect({ px, py }, { px + h * 3, py + h * 2 }, theme.rgba(255, 255, 255, 0.25), 6, 0, 1)
    end)
    imgui.TextDisabled(string.format('R %d', c[1]))
    imgui.TextDisabled(string.format('G %d', c[2]))
    imgui.TextDisabled(string.format('B %d', c[3]))
    local buf = hex_bufs[id]
    if not buf or (p.moved and not buf.active) then buf = { W.hex(c) }; hex_bufs[id] = buf end
    pcall(imgui.SetNextItemWidth, h * 4)
    local changed = false
    local okin, res = pcall(imgui.InputText, '##hex_' .. id, buf, 8)
    if okin and res then changed = true end
    buf.active = imgui.IsItemActive and imgui.IsItemActive() or false
    ui.text_active = ui.text_active or buf.active
    if changed then
        local nc = W.parse_hex(buf[1])
        if nc then p.h, p.s, p.v = W.rgb_to_hsv(nc); p.moved = false end
    end
    window.pop(ui, 'group')
    p.moved = false
    -- ボタン
    if imgui.Button(t('color.done') .. '##cpd_' .. id) then result = 'done' end
    imgui.SameLine()
    if imgui.Button(t('color.cancel') .. '##cpc_' .. id) then result = 'cancel' end
    imgui.SameLine()
    if imgui.Button(t('color.default') .. '##cpf_' .. id) then result = 'default' end
    imgui.TextDisabled(t('color.pad_hint'))
    return result
end

-- 色の行。tbl[key] は {r, g, b}（0〜255）。def は初めの色。戻り値: changed
-- opts: { section, row, label_w, tooltip_reset }
function W.color_row(ui, win, id, label, tbl, key, def, opts)
    opts = opts or {}
    local imgui = ui.imgui
    local cur = tbl[key]
    if type(cur) ~= 'table' then cur = { def[1], def[2], def[3] }; tbl[key] = cur end
    local changed = false
    if imgui.AlignTextToFramePadding then pcall(imgui.AlignTextToFramePadding) end
    imgui.Text(label)
    if opts.label_w then
        if not pcall(imgui.SameLine, opts.label_w) then imgui.SameLine() end
    else
        imgui.SameLine()
    end
    -- ↺（初めの色に戻す）
    local h = frame_h(imgui)
    local at_default = cur[1] == def[1] and cur[2] == def[2] and cur[3] == def[3]
    local rid = id .. '_reset'
    local rfocused, ractivated = focus.item(win, rid, opts.section, opts.row or id)
    local okp, px, py = pcall(imgui.GetCursorScreenPos)
    if okp and type(px) == 'table' then px, py = px.x or px[1], px.y or px[2] end
    local pressed = imgui.InvisibleButton('##' .. rid, { h, h })
    local hovered = imgui.IsItemHovered()
    if px and py then
        if hovered and not at_default then
            pcall(function ()
                imgui.GetWindowDrawList():AddRectFilled({ px, py }, { px + h, py + h }, theme.u32('accent', 0.18), 4)
            end)
        end
        draw_reset_icon(imgui, px, py, h, theme.u32(at_default and 'muted' or 'text', at_default and 0.35 or 0.95))
    end
    if hovered and opts.tooltip_reset then imgui.SetTooltip(opts.tooltip_reset) end
    after_item(ui, win, rid, rfocused)
    if (pressed or ractivated) and not at_default then
        tbl[key] = { def[1], def[2], def[3] }; cur = tbl[key]
        changed = true
    end
    imgui.SameLine()
    -- 見本と #RRGGBB（押すと色の窓）
    local focused, activated = focus.item(win, id, opts.section, opts.row or id)
    imgui.BeginGroup()
    window.push(ui, 'group')
    local okq, qx, qy = pcall(imgui.GetCursorScreenPos)
    if okq and type(qx) == 'table' then qx, qy = qx.x or qx[1], qx.y or qx[2] end
    local sw = math.floor(h * 1.4)
    local sw_pressed = imgui.InvisibleButton('##' .. id, { sw, h })
    imgui.SameLine(0, 8)
    if imgui.AlignTextToFramePadding then pcall(imgui.AlignTextToFramePadding) end
    imgui.Text(W.hex(cur))
    window.pop(ui, 'group')
    local clicked = sw_pressed or (imgui.IsItemClicked and imgui.IsItemClicked(0)) or false
    if tonumber(qx) and tonumber(qy) then
        pcall(function ()
            local dl = imgui.GetWindowDrawList()
            local m = math.max(2, math.floor(h * 0.15))
            dl:AddRectFilled({ qx, qy + m }, { qx + sw, qy + h - m }, u4c(cur, 1), 4)
            dl:AddRect({ qx, qy + m }, { qx + sw, qy + h - m }, theme.rgba(255, 255, 255, 0.30), 4, 0, 1)
        end)
    end
    after_item(ui, win, id, focused)
    local p = focus.picker(win)
    if (clicked or activated) and not (p and p.id == id) then
        local hh, ss, vv = W.rgb_to_hsv(cur)
        focus.open_picker(win, id, hh, ss, vv, { cur[1], cur[2], cur[3] })
        p = focus.picker(win)
        hex_bufs[id] = nil
    end
    if p and p.id == id then
        local pid = '##cp_' .. id
        if not p.opened then
            pcall(imgui.OpenPopup, pid)
            p.opened = true
            local okr, x2, y2 = pcall(imgui.GetItemRectMax)
            if type(x2) == 'table' then x2, y2 = x2.x or x2[1], x2.y or x2[2] end
            if okr and tonumber(x2) and tonumber(y2) then pcall(imgui.SetNextWindowPos, { x2 + 8, y2 - h }) end
        end
        local close
        if imgui.BeginPopup(pid) then
            window.push(ui, 'popup')
            if type(imgui.IsWindowHovered) == 'function' and imgui.IsWindowHovered() then ui.hovered_any = true end
            local r = picker_body(ui, id, p, def)
            if r == 'done' then p.done = true
            elseif r == 'cancel' then p.cancel = true
            elseif r == 'default' then p.h, p.s, p.v = W.rgb_to_hsv(def) end
            if p.done or p.cancel then
                pcall(imgui.CloseCurrentPopup)
                close = true
            end
            window.pop(ui, 'popup')
        else
            -- マウスで外を押して閉じた：そのときの色のまま
            close = true
        end
        -- 動かした色をすぐ反映（アイコンでも見える）。やめたら開く前の色
        local nc = W.hsv_to_rgb(p.h, p.s, p.v)
        if p.cancel and p.orig then nc = { p.orig[1], p.orig[2], p.orig[3] } end
        if nc[1] ~= cur[1] or nc[2] ~= cur[2] or nc[3] ~= cur[3] then
            tbl[key] = nc
            changed = true
        end
        if close then
            focus.close_picker(win)
            focus.set(win, id, false)
        end
    end
    if changed and ui.mark_settings_dirty then ui.mark_settings_dirty() end
    return changed
end

--[[
  プルダウン。choices = { { value=, label= }, ... }
  マウスは一覧から選ぶ。キー・パッドの決定では、次の値へ進める（開けない環境でも使える）。
  戻り値: changed, value
]]
function W.combo(ui, win, id, prefix, current, choices, opts)
    opts = opts or {}
    local imgui = ui.imgui
    local focused, activated = focus.item(win, id, opts.section, opts.row)
    local preview, idx = (current == nil and opts.placeholder) or tostring(current), 1
    for i, c in ipairs(choices) do
        if c.value == current then preview, idx = c.label, i end
    end
    if prefix and prefix ~= '' then
        imgui.Text(prefix)
        imgui.SameLine()
    end
    imgui.SetNextItemWidth(opts.width or 180)
    local changed, newv = false, current
    if type(imgui.BeginCombo) == 'function' then
        local opened = imgui.BeginCombo('##' .. id, preview)
        if opened then
            window.push(ui, 'combo')
            for _, c in ipairs(choices) do
                local sel = (c.value == current)
                if imgui.Selectable((c.label or '') .. '##c_' .. tostring(c.value), sel) then
                    changed, newv = true, c.value
                end
                if sel then pcall(imgui.SetItemDefaultFocus) end
            end
            window.pop(ui, 'combo')
        end
    else
        if imgui.Button(preview .. ' ▾##' .. id, { opts.width or 0, 0 }) then
            local nidx = idx + 1
            if nidx > #choices then nidx = 1 end
            changed, newv = true, choices[nidx].value
        end
    end
    after_item(ui, win, id, focused)
    -- キー・パッド：決定で一覧を開く（上下で動かし、決定で選ぶ、キャンセルで一覧だけ閉じる）
    local can_popup = type(imgui.OpenPopup) == 'function' and type(imgui.BeginPopup) == 'function'
        and type(imgui.EndPopup) == 'function' and type(imgui.Selectable) == 'function'
    local dd = focus.dropdown(win)
    if activated and not changed and #choices > 0 then
        if can_popup then
            focus.open_dropdown(win, id, idx, #choices)
            dd = focus.dropdown(win)
        else
            local nidx = idx + 1
            if nidx > #choices then nidx = 1 end
            changed, newv = true, choices[nidx].value
        end
    end
    if dd and dd.id == id and can_popup then
        local pid = '##dd_' .. id
        local okr, x1, y1 = pcall(imgui.GetItemRectMin)
        local okr2, x2, y2 = pcall(imgui.GetItemRectMax)
        if type(x1) == 'table' then x1, y1 = x1.x or x1[1], x1.y or x1[2] end
        if type(x2) == 'table' then x2, y2 = x2.x or x2[1], x2.y or x2[2] end
        if not dd.opened then
            pcall(imgui.OpenPopup, pid)
            dd.opened = true
        end
        if okr and okr2 and x1 and y2 then
            pcall(imgui.SetNextWindowPos, { x1, y2 + 2 })
        end
        if imgui.BeginPopup(pid) then
            window.push(ui, 'popup')
            -- 一覧の上をマウスで押しても「窓の外」にしない
            if type(imgui.IsWindowHovered) == 'function' and imgui.IsWindowHovered() then ui.hovered_any = true end
            for i, c in ipairs(choices) do
                local here = (i == dd.idx)
                if imgui.Selectable((here and '▶ ' or '   ') .. (c.label or '') .. '##dd_' .. id .. '_' .. tostring(c.value), here) then
                    dd.idx = i; dd.pick = true
                end
                if here then pcall(imgui.SetScrollHereY, 0.5) end
            end
            if dd.pick then
                local c = choices[dd.idx]
                if c then changed, newv = (c.value ~= current), c.value end
                pcall(imgui.CloseCurrentPopup)
                focus.close_dropdown(win)
            end
            window.pop(ui, 'popup')
        else
            -- マウスで外を押して閉じたなど
            focus.close_dropdown(win)
        end
    end
    return changed, newv
end

return W
