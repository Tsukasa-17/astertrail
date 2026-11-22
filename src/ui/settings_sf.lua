--[[
  Astertrail - SF テーマ専用の設定画面（0.1.270〜、パネル構成は 0.1.272〜）
  クラシック／YunaUI は src/ui/settings_ui.lua のまま。設定キーと保存形式は変えない。
  DETAILS の折りたたみは使わない。項目は属する名前付きパネルへ出す。パネルの高さは中身に合わせ、重ねない。
  説明文・長い値・見出しは、パネルの内側の幅（右余白つき）で折り返す（0.1.273〜）。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local util = require('src.lib.util')
local settings_mod = require('src.core.settings')
local focus = require('src.ui.focus')
local theme = require('src.ui.theme')
local sf = require('src.ui.sf_style')
local settings_ui = require('src.ui.settings_ui')
local CT = require('src.ui.colored_text')

local M = {}

local SEC = 'page'
local DEF = settings_mod.defaults()
local lay_bufs = {}
local panel_h = {}
local panel_inner_w = nil
-- カテゴリ内でそろえるラベル列（前フレームの最大幅を使う）
local form_cat = {}
local form = nil
-- 0.1.300〜：箱ごとの、前のフレームのスライダーの行の名前の幅と、スライダー以外の操作の幅
local step_meas = {}

local CATS = {
    { key = 'look',    ja = '見た目' },
    { key = 'layout',  ja = '配置' },
    { key = 'tracker', ja = 'トラッカー' },
    { key = 'map',     ja = '地図' },
    { key = 'marks',   ja = 'アイコン' },
    { key = 'input',   ja = '操作' },
    { key = 'save',    ja = '保存' },
}

local function onoff(ui, v) return v and ui.t('common.on') or ui.t('common.off') end

local UNIT = {
    pct = function (v) return string.format('%d%%', math.floor(v * 100 + 0.5)) end,
    px  = function (v) return string.format('%d px', math.floor(v + 0.5)) end,
    fpx = function (v)
        v = tonumber(v) or 0
        local n = math.floor(v * 4 + 0.5) / 4
        if math.abs(n - math.floor(n + 0.5)) < 1e-6 then
            return string.format('%d px', math.floor(n + 0.5))
        end
        return string.format('%.2f px', n)
    end,
    spx = function (v)
        local n = math.floor(v + 0.5)
        if n == 0 then return '0 px' end
        return string.format('%+d px', n)
    end,
}
local function unit(word)
    word = tostring(word or '')
    if word:find('^settings%.') or word:find('^sf%.') then word = '' end
    return function (v)
        local n = math.floor(v + 0.5)
        if word == '' then return tostring(n) end
        return string.format('%d %s', n, word)
    end
end

local function tkey(ui, key, fallback, vars)
    local s = ui.t(key, vars)
    if type(s) == 'string' and s ~= '' and s ~= key then return s end
    if type(fallback) == 'string' then
        if vars and vars.v then return (fallback:gsub('{v}', tostring(vars.v))) end
        return fallback
    end
    return s or fallback or key
end

local function dl_of(imgui)
    if imgui and imgui.GetWindowDrawList then
        local ok, d = pcall(imgui.GetWindowDrawList)
        if ok then return d end
    end
    return nil
end

-- 0.1.304〜：クラシック・YunaUI もこの設定画面の並び（名前は左、操作は右の列、行の間の線、i の説明）を使う。
-- 枠・見出し・左の選択の見た目だけテーマごと（アストラルは角を切ったシアンの枠と Melete の英字見出し）
local function astral()
    return theme.is_sf and theme.is_sf() or false
end

local function skin_rect(dl, x1, y1, x2, y2, fill_a, line_a, fill_key, line_key)
    if not dl then return end
    local rnd = (theme.look == 'yunaui') and 6 or 3
    if fill_a and fill_a > 0 and dl.AddRectFilled then
        pcall(dl.AddRectFilled, dl, { x1, y1 }, { x2, y2 }, theme.u32(fill_key or 'border', fill_a), rnd)
    end
    if line_a and line_a > 0 and dl.AddRect then
        pcall(dl.AddRect, dl, { x1, y1 }, { x2, y2 }, theme.u32(line_key or 'border', line_a), rnd, 0, 1)
    end
end

-- 箱の枠（塗り＋線）。fill_only=false のときは線だけ描き直す
local function box_frame(dl, x1, y1, x2, y2, fill)
    if astral() then
        sf.frame(dl, x1, y1, x2, y2, {
            cut = 6, fill_a = fill and 0.14 or 0, line_a = 0.78,
            line = theme.u32('sf_cyan', 0.85),
            brackets = false, glow = 0, thick = 1.25, band = false,
        })
    elseif theme.look == 'yunaui' then
        skin_rect(dl, x1, y1, x2, y2, fill and 0.04 or 0, 0.16, 'border', 'border')
    else
        skin_rect(dl, x1, y1, x2, y2, fill and 0.10 or 0, 0.55, 'frame', 'accent')
    end
end

-- 箱の見出し。アストラルは Melete の英字、ほかはふつうの文字でテーマの見出しの色。高さを返す
local function box_heading(ui, imgui, x, y, title, max_w)
    if astral() then
        local _, hh = sf.add_heading(imgui, x, y, theme.u32('sf_cyan', 1.0), title, 'label', { max_w = max_w })
        return hh
    end
    local h = select(2, theme.measure_text(imgui, title)) or 16
    sf.text_at(imgui, x, y, function ()
        theme.TextColored(imgui, theme.col(theme.look == 'yunaui' and 'lavender' or 'heading'), title)
    end)
    return h
end

local function avail(imgui)
    return sf.avail(imgui)
end

-- 左のカテゴリアイコン（線画。外部画像は使わない）
local ICONS = {}
function ICONS.look(dl, x, y, r, col)
    -- 4 方向の火花（見た目）
    pcall(function ()
        for i = 0, 3 do
            local a = math.rad(-90 + i * 90)
            local c, s = math.cos(a), math.sin(a)
            dl:AddLine({ x + c * r * 0.15, y + s * r * 0.15 }, { x + c * r, y + s * r }, col, 1.6)
        end
        for i = 0, 3 do
            local a = math.rad(-45 + i * 90)
            local c, s = math.cos(a), math.sin(a)
            dl:AddLine({ x + c * r * 0.2, y + s * r * 0.2 }, { x + c * r * 0.62, y + s * r * 0.62 }, col, 1.2)
        end
        dl:AddCircle({ x, y }, r * 0.16, col, 10, 1.2)
    end)
end
function ICONS.layout(dl, x, y, r, col)
    pcall(function ()
        dl:AddRect({ x - r * 0.85, y - r * 0.55 }, { x + r * 0.25, y + r * 0.25 }, col, 0, 0, 1.5)
        dl:AddRect({ x - r * 0.25, y - r * 0.15 }, { x + r * 0.85, y + r * 0.70 }, col, 0, 0, 1.5)
    end)
end
function ICONS.tracker(dl, x, y, r, col)
    sf.icon_target(dl, x, y, r, col)
end
function ICONS.map(dl, x, y, r, col)
    -- 菱形（地図）
    pcall(function ()
        local pts = {
            { x, y - r }, { x + r * 0.78, y }, { x, y + r }, { x - r * 0.78, y },
        }
        dl:AddLine(pts[1], pts[2], col, 1.5)
        dl:AddLine(pts[2], pts[3], col, 1.5)
        dl:AddLine(pts[3], pts[4], col, 1.5)
        dl:AddLine(pts[4], pts[1], col, 1.5)
        dl:AddLine({ x, y - r * 0.15 }, { x, y + r * 0.15 }, col, 1.2)
        dl:AddLine({ x - r * 0.15, y }, { x + r * 0.15, y }, col, 1.2)
    end)
end
function ICONS.marks(dl, x, y, r, col)
    -- 人と人（アイコン）
    pcall(function ()
        dl:AddCircle({ x - r * 0.32, y - r * 0.28 }, r * 0.28, col, 10, 1.4)
        dl:AddCircle({ x + r * 0.38, y - r * 0.18 }, r * 0.22, col, 10, 1.3)
        dl:AddLine({ x - r * 0.32, y + r * 0.05 }, { x - r * 0.32, y + r * 0.25 }, col, 1.3)
        dl:AddLine({ x + r * 0.38, y + r * 0.08 }, { x + r * 0.38, y + r * 0.22 }, col, 1.3)
        dl:AddLine({ x - r * 0.70, y + r * 0.78 }, { x - r * 0.32, y + r * 0.28 }, col, 1.3)
        dl:AddLine({ x + r * 0.05, y + r * 0.78 }, { x - r * 0.32, y + r * 0.28 }, col, 1.3)
        dl:AddLine({ x + r * 0.08, y + r * 0.70 }, { x + r * 0.38, y + r * 0.26 }, col, 1.2)
        dl:AddLine({ x + r * 0.72, y + r * 0.70 }, { x + r * 0.38, y + r * 0.26 }, col, 1.2)
    end)
end
function ICONS.input(dl, x, y, r, col)
    -- マウス（操作）
    pcall(function ()
        dl:AddRect({ x - r * 0.42, y - r * 0.85 }, { x + r * 0.42, y + r * 0.80 }, col, r * 0.4, 0, 1.5)
        dl:AddLine({ x, y - r * 0.85 }, { x, y - r * 0.05 }, col, 1.3)
        dl:AddLine({ x - r * 0.42, y - r * 0.05 }, { x + r * 0.42, y - r * 0.05 }, col, 1.3)
    end)
end
function ICONS.save(dl, x, y, r, col)
    -- ディスク
    pcall(function ()
        dl:AddRect({ x - r * 0.75, y - r * 0.75 }, { x + r * 0.75, y + r * 0.75 }, col, 2, 0, 1.5)
        dl:AddRect({ x - r * 0.35, y - r * 0.75 }, { x + r * 0.45, y - r * 0.18 }, col, 0, 0, 1.3)
        dl:AddRect({ x - r * 0.50, y + r * 0.05 }, { x + r * 0.50, y + r * 0.75 }, col, 0, 0, 1.3)
        dl:AddLine({ x - r * 0.25, y + r * 0.22 }, { x + r * 0.25, y + r * 0.22 }, col, 1.1)
    end)
end

local function cat_key(raw)
    if raw == 'eminence' then return 'tracker' end
    if raw == 'about' then return 'save' end
    -- 0.1.304〜：お知らせの分類はなくし、中身は見た目へ
    if raw == 'notify' then return 'look' end
    for _, c in ipairs(CATS) do
        if c.key == raw then return raw end
    end
    return 'look'
end

local function form_note(ui, label)
    if not form then return end
    local tw = tonumber((theme.measure_text(ui.imgui, tostring(label or '')))) or 0
    if tw > (form.measured or 0) then form.measured = tw end
end

local function form_opts(base)
    local o = base or {}
    -- 0.1.298〜：名前は左、操作は箱の右端。行のあいだに薄い線
    if form and form.label_w and panel_inner_w and panel_inner_w > 40 then
        o.form_right = true
        o.form_inner = panel_inner_w
        o.form_gap = 12
        o.form_value_w = form.value_w
        o.form_slider_w = form.slider_w
        -- 0.1.299〜：まとまり（group）の中は線を引かない。線はまとまりの前だけ
        local g = form.group
        o.form_rule = (form.rows or 0) > 0 and (not g or g.first)
        if g then g.first = false end
        form.rows = (form.rows or 0) + 1
        o.wrap_w = nil
    elseif form and form.label_w then
        o.form_label_w = form.label_w
        o.form_gap = form.gap
        o.form_value_w = form.value_w
        o.form_control_w = form.control_w
        o.wrap_w = nil
    elseif o.wrap_w == nil then
        o.wrap_w = panel_inner_w
    end
    return o
end

-- 続けて置く行のまとまり（線はまとまりの前に 1 本だけ）。fn の中の行をまとめる
local function group(fn)
    if not form then return fn() end
    local prev = form.group
    form.group = { first = true }
    local ok, err = pcall(fn)
    form.group = prev
    if not ok then error(err, 0) end
end

local function toggle(ui, name, id, label, tbl, key, info)
    form_note(ui, label)
    if W.switch(ui, name, id, label, tbl[key] == true, form_opts({
        section = SEC, row = id, reduce_motion = ui.reduce_motion, info = info,
    })) then
        tbl[key] = not tbl[key]
        ui.mark_settings_dirty()
        return true
    end
    return false
end

-- 0.1.299〜：パッドでその行を選んでいるときも説明を出す（ids のどれかが選ばれている）
local function focus_tip(ui, name, info, ids)
    if not info or info == '' then return end
    if focus.why(name) == 'hover' then return end
    local cur = focus.current(name)
    for _, i in ipairs(ids) do
        if cur == i then W.tooltip(ui, info); return end
    end
end

local function stepper(ui, name, id, label, tbl, key, step, lo, hi, text, default, info)
    form_note(ui, label)
    local r = W.slider(ui, name, id, label, tbl, key, form_opts({
        step = step, lo = lo, hi = hi, default = default, text = text, section = SEC,
        slider_w = 120, info = info,
        tooltip_reset = ui.t('settings.reset_default'),
    }))
    -- 0.1.300〜：次のフレームのスライダーの幅のために、名前の幅（i の印も）とスライダー以外の操作の幅を覚える
    if form and form.slider_w then
        local imgui = ui.imgui
        local tw = tonumber((theme.measure_text(imgui, tostring(label or '')))) or 0
        if info and info ~= '' then tw = tw + W.info_mark_size(imgui) + 6 end
        if tw > (form.step_lab or 0) then form.step_lab = tw end
        local cw = tonumber(W._ctrl_w_cache[name .. '/' .. id])
        if cw and cw > form.slider_w then
            local rest = cw - form.slider_w
            if rest > (form.step_fixed or 0) then form.step_fixed = rest end
        end
    end
    focus_tip(ui, name, info, { id, id .. '_reset' })
    return r
end

-- パネル内の説明は、子窓の残り幅ではなく、そのパネルの内側の幅で折り返す
local function help(ui, text)
    if not text or text == '' then return end
    if panel_inner_w and panel_inner_w > 8 then
        CT.wrapped(ui, text, 'muted', nil, panel_inner_w)
    else
        W.muted(ui, text)
    end
end

local function colored(ui, name, text)
    if not text or text == '' then return end
    if panel_inner_w and panel_inner_w > 8 then
        CT.wrapped(ui, text, name, nil, panel_inner_w)
    else
        W.colored(ui, name, text)
    end
end

local function subhead(ui, text)
    if not text or text == '' then return end
    if form then form.rows = 0 end
    if panel_inner_w and panel_inner_w > 8 then
        CT.wrapped(ui, text, 'heading', nil, panel_inner_w)
    else
        W.heading(ui, text)
    end
end

local function button(ui, win, id, label, opts)
    opts = opts or {}
    local imgui = ui.imgui
    local form_row
    -- 0.1.298〜：操作のボタン（名前のないもの）は左から。名前の列へずらさない
    if false then
        local ok, a, b = pcall(imgui.GetCursorScreenPos)
        local sx, sy
        if ok and type(a) == 'table' then sx, sy = tonumber(a.x or a[1]), tonumber(a.y or a[2])
        elseif ok then sx, sy = tonumber(a), tonumber(b) end
        if sx and sy then
            pcall(imgui.SetCursorScreenPos, { sx + form.label_w + (form.gap or 8), sy })
            form_row = { sx = sx, sy = sy, label_bottom = sy }
        end
        local o = {}
        for k, v in pairs(opts) do o[k] = v end
        local tw = (tonumber((theme.measure_text(imgui, tostring(label or '')))) or 0) + 16
        local cap = form.control_w or panel_inner_w
        if cap and tw > cap then o.width = cap end
        opts = o
    elseif panel_inner_w and panel_inner_w > 8 and not opts.width then
        local o = {}
        for k, v in pairs(opts) do o[k] = v end
        local tw = select(1, theme.measure_text(imgui, tostring(label or '')))
        tw = (tonumber(tw) or 0) + 16
        if tw > panel_inner_w then o.width = panel_inner_w end
        opts = o
    end
    local hit = W.button(ui, win, id, label, opts)
    if form_row and W._form_end then W._form_end(imgui, form_row) end
    -- 0.1.299〜：説明はボタンのすぐ右の i（乗せる・パッドで選ぶと出る）
    if opts.info and opts.info ~= '' then
        pcall(imgui.SameLine, 0, 6)
        W.info_mark(ui, win .. '/' .. id, opts.info)
        focus_tip(ui, win, opts.info, { id })
    end
    return hit
end

-- 「文字のそろえ：{v}」の形から名前だけ（0.1.298〜）
local function strip_v(s)
    s = tostring(s or ''):gsub('{v}', '')
    -- 0.1.299〜：全角の「：」は 3 バイト。文字のまとまりで後ろから外す（[：:] だと 1 バイトだけ消えて「?」が残る）
    local changed = true
    while changed do
        changed = false
        for _, tail in ipairs({ '：', ':', ' ', '　' }) do
            if #s >= #tail and s:sub(-#tail) == tail then s = s:sub(1, -#tail - 1); changed = true end
        end
    end
    return s
end

-- 名前は左、いまの値を出す小さなボタンを右端に（押すと切りかえ）。opts.after で右にもう一つ置ける
local function choice(ui, win, id, label, value, opts)
    opts = opts or {}
    local imgui = ui.imgui
    value = tostring(value or '')
    if form and form.label_w and panel_inner_w and panel_inner_w > 40 and W._form_start then
        local fo = form_opts({ info = opts.info })
        local tw = tonumber((theme.measure_text(imgui, value))) or 0
        local row = W._form_start(ui, imgui, label, fo, win .. '/' .. id, tw + 18 + (opts.extra_w or 0))
        if row then
            local hit = W.button(ui, win, id, value, {
                section = SEC, row = opts.row or id, tooltip = opts.tooltip, disabled = opts.disabled,
            })
            focus_tip(ui, win, fo.info, { id })
            local extra
            if opts.after then
                imgui.SameLine(0, 6)
                extra = opts.after()
            end
            W._form_end(imgui, row)
            return hit, extra
        end
    end
    local sep = (ui.settings and ui.settings.language == 'en') and ': ' or '：'
    local hit = button(ui, win, id, label .. sep .. value, { section = SEC, row = opts.row or id })
    local extra
    if opts.after then W.same(ui); extra = opts.after() end
    return hit, extra
end

local function heading_font(ui, win, on)
    if on then
        window.set_font(ui, window.font_scale(ui, win) * 0.78, { heading = true, bold = true })
    else
        window.set_font(ui, window.font_scale(ui, win), {})
    end
end

local function panel(ui, id, title, pw, fn)
    local imgui = ui.imgui
    local win = 'settings'
    local x, y = sf.xy(pcall(imgui.GetCursorScreenPos))
    x, y = x or 0, y or 0
    local pad = 10
    local guessed = panel_h[id] or 90
    local dl = dl_of(imgui)
    box_frame(dl, x, y, x + pw, y + guessed, true)
    if astral() then heading_font(ui, win, true) end
    local hh = box_heading(ui, imgui, x + pad, y + 5, title, pw - pad * 2)
    if astral() then heading_font(ui, win, false) end
    -- 見出しの実高さを確保して、説明文や次の見出しと重ねない
    local title_block = math.max(22, (tonumber(hh) or 18) + 8)
    sf.set_cursor(imgui, x + pad, y + pad + title_block)
    imgui.BeginGroup()
    window.push(ui, 'group')
    local inner = math.max(40, pw - pad * 2)
    local prev_w = panel_inner_w
    local prev_form = form
    -- 右余白を少し残して折り返す
    panel_inner_w = math.max(40, inner - 4)
    -- 2列フォーム：ラベル列はカテゴリ内の前フレーム最大幅（上限あり）
    local gap, value_w, min_ctrl = 8, 56, 168
    -- 0.1.299〜：値と単位の幅は決めておく（-128 px・100 %・100 ヤルムなどが 1 行に入る幅）。どの行もそろう
    do
        local t = ui.t
        local samples = { '-128 px', '100 %', '1000 ms', '1.25 px' }
        for _, k in ipairs({ 'settings.unit_yalms', 'settings.unit_count', 'settings.unit_chars' }) do
            local u = t and t(k)
            if type(u) == 'string' and u ~= k then samples[#samples + 1] = '100 ' .. u end
        end
        for _, smp in ipairs(samples) do
            local w = tonumber((theme.measure_text(imgui, smp))) or 0
            if w + 4 > value_w then value_w = math.ceil(w + 4) end
        end
    end
    local cap = math.max(64, math.min(200, inner - min_ctrl))
    local last = 0
    if prev_form and prev_form.shared then last = prev_form.shared end
    local lw = math.min(cap, math.max(64, last > 0 and last or cap))
    -- 0.1.300〜：スライダーの幅は箱で 1 つ。名前の列と、↺・－・＋・値のかたまりのあいだを埋める。
    -- 最小 120・最大 260（4K などの倍率つき）。狭いときは名前を折り返す前にスライダーを縮める
    local slider_w
    do
        local okh, fh = pcall(imgui.GetFrameHeight)
        fh = okh and tonumber(fh) or 20
        local sc = math.max(0.5, fh / 20)
        local smin, smax = math.floor(120 * sc + 0.5), math.floor(260 * sc + 0.5)
        local m = step_meas[id]
        local fixed = (m and m.fixed and m.fixed > 0) and m.fixed or (fh + 52 + value_w + 32)
        local lab = (m and m.lab) or 0
        if lab > 0 then
            local avail = (math.max(40, inner - 4)) - 12 - lab - fixed - 2
            slider_w = math.max(smin, math.min(smax, math.floor(avail)))
        else
            slider_w = smin
        end
        -- 箱がとても狭いときは、行の幅の中に収まるところまで（最小より小さくなることもある）
        slider_w = math.max(48, math.min(slider_w, math.floor((inner - 4) - 12 - 40 - fixed)))
    end
    form = {
        slider_w = slider_w, id = id, step_lab = 0, step_fixed = 0,
        label_w = lw, gap = gap, value_w = value_w, inner = inner,
        control_w = math.max(48, inner - lw - gap),
        measured = 0, shared = last, cat = prev_form and prev_form.cat or nil,
    }
    local wrapped = false
    if imgui.GetCursorPosX and imgui.PushTextWrapPos then
        local okx, cx = pcall(imgui.GetCursorPosX)
        cx = okx and tonumber(cx) or nil
        if cx then
            wrapped = pcall(imgui.PushTextWrapPos, cx + panel_inner_w)
        end
    end
    if imgui.PushItemWidth then pcall(imgui.PushItemWidth, math.max(80, panel_inner_w)) end
    fn(inner)
    if form and form.step_lab and form.step_lab > 0 then
        step_meas[id] = { lab = form.step_lab, fixed = form.step_fixed }
    end
    if imgui.PopItemWidth then pcall(imgui.PopItemWidth) end
    if wrapped and imgui.PopTextWrapPos then pcall(imgui.PopTextWrapPos) end
    if form and form.cat then
        local st = form_cat[form.cat] or { measured = 0, used = 0 }
        st.measured = math.max(st.measured or 0, form.measured or 0)
        form_cat[form.cat] = st
    end
    form = prev_form
    panel_inner_w = prev_w
    if imgui.Dummy then pcall(imgui.Dummy, { 1, 1 }) end
    window.pop(ui, 'group')
    local _, y2 = sf.xy(pcall(imgui.GetItemRectMax))
    local _, cy = sf.xy(pcall(imgui.GetCursorScreenPos))
    local bottom = y + pad + title_block
    if y2 then bottom = math.max(bottom, y2) end
    if cy then bottom = math.max(bottom, cy) end
    local h = math.max(56, (bottom - y) + pad)
    panel_h[id] = h
    -- 高さが前フレームと違うとき、枠線だけ正しい大きさで描き直す（塗りは文字の上に重ねない）
    if math.abs(h - guessed) > 1 then
        box_frame(dl, x, y, x + pw, y + h, false)
    end
    sf.set_cursor(imgui, x, y + h)
    if imgui.Dummy then pcall(imgui.Dummy, { pw, 1 }) end
    return h
end

-- ========== カテゴリ中身 ==========

local function draw_look_base(ui, name)
    local t, S = ui.t, ui.settings
    -- GENERAL
    -- THEME / TYPE / WINDOWS / FONT
    return {
        { id = 'look_general', title = 'GENERAL', draw = function ()
            if choice(ui, name, 'lang', strip_v(tkey(ui, 'sf.set.language', '表示言語：{v}')),
                S.language == 'ja' and '日本語' or 'English') then
                S.language = (S.language == 'ja') and 'en' or 'ja'
                ui.set_language(S.language)
                ui.mark_settings_dirty()
            end
            do
                local look = (S.look == 'yunaui' or S.look == 'sf' or S.look == 'classic') and S.look or 'classic'
                if choice(ui, name, 'look_style', strip_v(tkey(ui, 'sf.set.theme', 'テーマ：{v}')), t('settings.look_' .. look)) then
                    S.look = theme.next_look(look)
                    theme.set_look(S.look)
                    ui.mark_settings_dirty()
                end
            end
            toggle(ui, name, 'motion', tkey(ui, 'sf.set.reduce_motion', '動きを減らす'), S, 'reduce_motion', t('settings.reduce_motion_tip'))
        end },
        { id = 'look_type', title = 'TYPE', draw = function ()
            S.fonts = S.fonts or {}
            local labels = {
                book = { 'sf.set.font_book', '本の見出しの文字サイズ' },
                list = { 'sf.set.font_list', '一覧の表の文字サイズ' },
                detail = { 'sf.set.font_detail', '詳細の文字サイズ' },
                tracker = { 'sf.set.font_tracker', 'トラッカーの文字サイズ' },
                eminence = { 'sf.set.font_eminence', 'エミネンスの文字サイズ' },
                map = { 'sf.set.font_map', '地図の文字サイズ' },
                overhead_quest = { 'sf.set.font_overhead_quest', 'アイコンのクエスト名の文字サイズ' },
                overhead_name = { 'sf.set.font_overhead_name', 'アイコンの名前の文字サイズ' },
            }
            for _, area in ipairs(settings_mod.FONT_AREAS) do
                if S.fonts[area] == nil then S.fonts[area] = settings_mod.font_for(S, area) end
                local lo, hi = settings_mod.font_range(area)
                local L = labels[area] or { 'settings.font_' .. area, area }
                -- 0.1.299〜：トラッカーとトラッカータブの文字は 1 つのまとまり
                if area == 'tracker' and form then form.group = { first = true } end
                stepper(ui, name, 'font_' .. area, tkey(ui, L[1], L[2]), S.fonts, area, 0.1, lo, hi, UNIT.pct, DEF.fonts[area])
                if area == 'tracker' then
                    local lo_t, hi_t = settings_mod.font_range('tracker')
                    local follow = settings_mod.font_for(S, 'tracker')
                    local proxy = { v = S.fonts.tracker_tabs }
                    if proxy.v == nil then proxy.v = follow end
                    if stepper(ui, name, 'font_tracker_tabs', tkey(ui, 'sf.set.font_tracker_tabs', 'トラッカータブの文字'),
                        proxy, 'v', 0.1, lo_t, hi_t, UNIT.pct, follow) then
                        local nv = tonumber(proxy.v)
                        if nv and math.abs(nv - follow) < 1e-6 then S.fonts.tracker_tabs = nil
                        else S.fonts.tracker_tabs = nv end
                        ui.mark_settings_dirty()
                    end
                    if form then form.group = nil end
                end
            end
            stepper(ui, name, 'font', tkey(ui, 'sf.set.font_other', 'その他（設定・お知らせ・入口）'),
                S, 'font_scale', 0.1, settings_mod.FONT_MIN, settings_mod.FONT_MAX, UNIT.pct, DEF.font_scale)
        end },
        { id = 'look_windows', title = 'WINDOWS', draw = function ()
            S.alphas = S.alphas or {}
            local labels = {
                book = { 'sf.set.alpha_book', '本の背景の濃さ' },
                detail = { 'sf.set.alpha_detail', '詳細の背景の濃さ' },
                tracker = { 'sf.set.alpha_tracker', 'トラッカーの背景の濃さ' },
                eminence = { 'sf.set.alpha_eminence', 'エミネンスの背景の濃さ' },
                compass = { 'sf.set.alpha_compass', 'コンパスの背景の濃さ' },
                map = { 'sf.set.alpha_map', '地図の背景の濃さ' },
                other = { 'sf.set.alpha_other', 'その他の背景の濃さ' },
            }
            for _, area in ipairs(settings_mod.ALPHA_AREAS) do
                if area ~= 'settings' then
                    if S.alphas[area] == nil then S.alphas[area] = settings_mod.alpha_for(S, area) end
                    local L = labels[area] or { 'settings.alpha_' .. area, area }
                    -- 0.1.299〜：「その他」の説明は、その行の i に
                    stepper(ui, name, 'alpha_' .. area, tkey(ui, L[1], L[2]), S.alphas, area, 0.05, 0.3, 1.0, UNIT.pct, DEF.alphas[area],
                        area == 'other' and tkey(ui, 'sf.set.alpha_note', '「その他」は、お知らせと入口のアイコンです。') or nil)
                end
            end
        end },
        { id = 'look_font', title = 'FONT', draw = function ()
            toggle(ui, name, 'font_crisp', tkey(ui, 'sf.set.font_crisp', '画面の文字をくっきり（メイリオ）'), S, 'font_crisp',
                tkey(ui, 'sf.set.font_crisp_help', 'オフでも、英語見出しの Melete はそのままです。'))
            toggle(ui, name, 'font_crisp_bold', tkey(ui, 'sf.set.font_crisp_bold', '太字（メイリオ）'), S, 'font_crisp_bold')
            group(function ()
                stepper(ui, name, 'font_crisp_outline', tkey(ui, 'sf.set.font_crisp_outline', '縁取りの太さ'),
                    S, 'font_crisp_outline', 0.25, 0, 3, UNIT.fpx, DEF.font_crisp_outline)
                stepper(ui, name, 'font_crisp_outline_alpha', tkey(ui, 'sf.set.font_crisp_outline_alpha', '縁取りの濃さ'),
                    S, 'font_crisp_outline_alpha', 0.05, 0, 1, UNIT.pct, DEF.font_crisp_outline_alpha)
            end)
        end },
    }
end

local function draw_layout(ui, name)
    local S = ui.settings
    return {
        { id = 'lay_windows', title = 'WINDOWS', draw = function ()
            -- 0.1.300〜：右のプレビューをやめたので、窓の動かし方の説明は i に
            toggle(ui, name, 'lock', tkey(ui, 'sf.set.layout_locked', '窓の位置を固定'), S, 'layout_locked',
                tkey(ui, 'sf.set.preview_unlocked', '窓はドラッグして動かせます'))
            if button(ui, name, 'inside', tkey(ui, 'sf.set.bring_inside', '画面内へ戻す'), { section = SEC, row = 'pos_inside' }) then
                ui.bring_inside()
            end
            if button(ui, name, 'reset', tkey(ui, 'sf.set.reset_layout', '初期配置に戻す'), { section = SEC, row = 'pos_reset' }) then
                ui.reset_layout()
            end
            toggle(ui, name, 'icon', tkey(ui, 'sf.set.entry_icon', '画面の入口アイコン'), S.entry_icon, 'visible')
        end },
        { id = 'lay_book', title = 'BOOK', draw = function ()
            toggle(ui, name, 'filters', tkey(ui, 'sf.set.remember_filters', '絞り込みを覚える'), S.book, 'remember_filters')
            toggle(ui, name, 'remember_pos', tkey(ui, 'sf.set.remember_position', '設定を開いたとき、前回の項目から始める'), S, 'remember_position')
            if button(ui, name, 'reset_cols', tkey(ui, 'sf.set.reset_columns', '一覧の列の並びと表示を元に戻す'),
                { section = SEC, row = 'reset_cols',
                  info = tkey(ui, 'sf.set.preview_layout_book', '本は開いたときの位置と、一覧の列を覚えます。') }) then
                if require('src.ui.book').reset_columns(S) then ui.mark_settings_dirty() end
            end
        end },
    }
end

local function draw_tracker(ui, name)
    local t, S = ui.t, ui.settings
    return {
        { id = 'tr_main', title = 'TRACKER', draw = function ()
            if toggle(ui, name, 'tr_vis', tkey(ui, 'sf.set.tracker_visible', 'トラッカーを出す'), S.tracker, 'visible',
                tkey(ui, 'sf.set.tracker_visible_help', '本の★からも切り替えられます。')) then
                if not S.tracker.visible and ui.release then ui.release() end
            end
            stepper(ui, name, 'pins', tkey(ui, 'sf.set.max_pins', 'ピンの上限'), S.tracker, 'max_pins', 1, 1, 30,
                unit(t('settings.unit_count')), DEF.tracker.max_pins)
            if toggle(ui, name, 'tr_fold', tkey(ui, 'sf.set.tracker_collapsed', '名前だけ表示'), S.tracker, 'collapsed')
                and S.tracker.collapsed then
                require('src.ui.tracker').set_collapsed(ui, true)
            end
            local al = (S.tracker.align == 'left') and 'left' or 'right'
            if choice(ui, name, 'tr_align', strip_v(tkey(ui, 'sf.set.tracker_align', '文字のそろえ：{v}')), t('settings.tracker_align_' .. al)) then
                S.tracker.align = (al == 'left') and 'right' or 'left'
                ui.mark_settings_dirty()
            end
            local vw = (S.tracker.view == 'tabs') and 'tabs' or 'list'
            if choice(ui, name, 'tr_view', strip_v(tkey(ui, 'sf.set.tracker_view', '表示形式：{v}')), t('settings.tracker_view_' .. vw)) then
                S.tracker.view = (vw == 'tabs') and 'list' or 'tabs'
                ui.mark_settings_dirty()
            end
            stepper(ui, name, 'tr_tabw', tkey(ui, 'sf.set.tracker_tab_chars', 'タブの幅'), S.tracker, 'tab_chars', 1, 3, 16,
                unit(t('settings.unit_chars')), DEF.tracker.tab_chars)
            toggle(ui, name, 'tr_close', tkey(ui, 'sf.set.tracker_show_close', '右上の × を出す'), S.tracker, 'show_close')
        end },
        { id = 'tr_contents', title = 'CONTENTS', draw = function ()
            toggle(ui, name, 'tr_tw', tkey(ui, 'sf.set.show_time_weather', '時間帯・天候を出す'), S.tracker, 'show_time_weather')
            toggle(ui, name, 'tr_items', tkey(ui, 'sf.set.show_items', '手順の必要品アイコン'), S.tracker, 'show_items')
            toggle(ui, name, 'poss', tkey(ui, 'sf.set.show_possession', '持っている数の表示'), S.items, 'show_possession')
        end },
        { id = 'tr_compass', title = 'COMPASS', draw = function ()
            group(function ()
                if toggle(ui, name, 'compass_vis', tkey(ui, 'sf.set.compass_visible', 'コンパスを出す'), S.compass, 'visible')
                    and S.compass.visible and ui.set_compass_visible then
                    ui.set_compass_visible(true)
                end
                stepper(ui, name, 'compass_range', tkey(ui, 'sf.set.compass_range', '何ヤルム以内を出す'),
                    S.compass, 'max_dist', 5, 5, 100, unit(t('settings.unit_yalms')), DEF.compass.max_dist)
            end)
        end },
        { id = 'tr_eminence', title = 'EMINENCE', draw = function ()
            toggle(ui, name, 'roe_fold', tkey(ui, 'sf.set.roe_collapsed', '★を付けたものだけ出す'), S.eminence, 'collapsed')
            -- 0.1.294〜：サーバーに入っていないと分かっているものに未実装の札（初期オン）
            -- 0.1.305〜：ゲームの目標一覧にまだ出ていない目標を隠す
            if S.eminence.game_gate == nil then S.eminence.game_gate = true end
            toggle(ui, name, 'roe_game_gate', tkey(ui, 'sf.set.roe_game_gate', 'ゲームでまだ出ていない目標を隠す'), S.eminence, 'game_gate',
                tkey(ui, 'sf.set.roe_game_gate_help', 'ゲームの目標一覧と同じに、まだ出ていない目標を隠します。'))
            if S.eminence.known_unimpl == nil then S.eminence.known_unimpl = true end
            toggle(ui, name, 'roe_known_unimpl', tkey(ui, 'sf.set.roe_known_unimpl', '未実装の札を自動でつける'), S.eminence, 'known_unimpl',
                tkey(ui, 'sf.set.roe_known_unimpl_help', 'LSBで未実装のエミネンスに未実装の札をつけます。サーバーが独自に実装している場合もあります。'))
        end },
    }
end

local function draw_map(ui, name)
    local S = ui.settings
    return {
        { id = 'map_main', title = 'MAP', draw = function ()
            toggle(ui, name, 'map_on', tkey(ui, 'sf.set.map_enabled', '地図を出す'), S.map, 'enabled',
                tkey(ui, 'sf.set.map_credit', '地図の画像は同梱せず、クライアントのデータを実行時に表示します。'))
            if S.map.grid_alpha == nil then S.map.grid_alpha = 0.35 end
            stepper(ui, name, 'map_grid', tkey(ui, 'sf.set.map_grid_alpha', 'マス目の線の濃さ'),
                S.map, 'grid_alpha', 0.05, 0, 1, UNIT.pct, 0.35,
                tkey(ui, 'sf.set.map_grid_alpha_help', '0 で線と外側の目盛りを出さない。ズームしても、地図の枠の外にマスの記号を出します。'))
        end },
    }
end

local function color_row(ui, name, id, label, tbl, key, def, opts)
    opts = opts or {}
    form_note(ui, label)
    local o = {}
    for k, v in pairs(opts) do o[k] = v end
    o = form_opts(o)
    local r = W.color_row(ui, name, id, label, tbl, key, def, o)
    focus_tip(ui, name, o.info, { id, id .. '_reset' })
    return r
end

-- 0.1.299〜：色の行は「色・グラデーション・終わりの色」と「背景色・背景グラデーション・背景の終わりの色」を
-- それぞれ 1 つのまとまりにして（中は線なし）。0.1.301〜「背景の濃さ」は背景のまとまりの先頭
local function color_main(ui, name, which, sample)
    local S, t = ui.settings, ui.t
    local M, DM = S.marks, DEF.marks
    subhead(ui, tkey(ui, 'sf.set.color_' .. which, which == 'label' and 'クエスト名' or 'オブジェクト（クエスト対象名を含む）'))
    local c1, c2 = settings_mod.text_colors(M, which)
    W.color_preview(ui, sample, c1, c2)
    group(function ()
        color_row(ui, name, 'marks_' .. which .. '_color', tkey(ui, 'sf.set.color_start', '色'),
            M, which .. '_color', DM[which .. '_color'], {
                section = SEC, row = 'marks_' .. which .. '_color',
                tooltip_reset = t('settings.reset_default'),
            })
        toggle(ui, name, 'marks_' .. which .. '_grad', t('settings.color_gradient'), M, which .. '_grad')
        if M[which .. '_grad'] then
            color_row(ui, name, 'marks_' .. which .. '_color2', t('settings.color_end'),
                M, which .. '_color2', DM[which .. '_color2'], {
                    section = SEC, row = 'marks_' .. which .. '_color2', tooltip_reset = t('settings.reset_default'),
                })
        end
    end)
    -- 0.1.301〜：「背景の濃さ」は背景のまとまりの先頭（背景色・背景グラデーション・背景の終わりの色と一緒、中は線なし）
    local bg_key = which .. '_bg_alpha'
    if type(M[bg_key]) ~= 'number' then M[bg_key] = settings_mod.LABEL_BG_ALPHA_DEFAULT end
    group(function ()
        stepper(ui, name, 'marks_' .. bg_key, tkey(ui, 'sf.set.' .. bg_key, '背景の濃さ'),
            M, bg_key, 0.05, settings_mod.LABEL_BG_ALPHA_MIN, settings_mod.LABEL_BG_ALPHA_MAX, UNIT.pct, DM[bg_key])
        color_row(ui, name, 'marks_' .. which .. '_bg_color', t('settings.marks_' .. which .. '_bg_color'),
            M, which .. '_bg_color', DM[which .. '_bg_color'], {
                section = SEC, row = 'marks_' .. which .. '_bg_color', tooltip_reset = t('settings.reset_default'),
            })
        toggle(ui, name, 'marks_' .. which .. '_bg_grad', t('settings.marks_' .. which .. '_bg_grad'), M, which .. '_bg_grad')
        if M[which .. '_bg_grad'] then
            color_row(ui, name, 'marks_' .. which .. '_bg_color2', t('settings.marks_' .. which .. '_bg_color2'),
                M, which .. '_bg_color2', DM[which .. '_bg_color2'], {
                    section = SEC, row = 'marks_' .. which .. '_bg_color2', tooltip_reset = t('settings.reset_default'),
                })
        end
    end)
end

local function color_detail(ui, name, which)
    local S, t = ui.settings, ui.t
    local M, DM = S.marks, DEF.marks
    -- 縁取りの太さ・濃さは 1 つのまとまり
    local sk, sak = which .. '_stroke', which .. '_stroke_alpha'
    group(function ()
        if type(M[sk]) ~= 'number' then M[sk] = settings_mod.STROKE_DEFAULT or 1 end
        stepper(ui, name, 'marks_' .. sk, t('settings.marks_' .. sk), M, sk, 1,
            settings_mod.STROKE_MIN, settings_mod.STROKE_MAX, UNIT.px, DM[sk])
        if type(M[sak]) ~= 'number' then M[sak] = 1 end
        stepper(ui, name, 'marks_' .. sak, t('settings.marks_' .. sak), M, sak, 0.05, 0, 1, UNIT.pct, DM[sak] or 1)
    end)
    if button(ui, name, 'marks_' .. which .. '_all_reset', t('settings.color_reset'),
        { section = SEC, row = 'marks_' .. which .. '_all_reset', small = true }) then
        for _, k in ipairs({ which .. '_color', which .. '_color2', which .. '_bg_color', which .. '_bg_color2' }) do
            if DM[k] then M[k] = { DM[k][1], DM[k][2], DM[k][3] } end
        end
        M[which .. '_grad'] = false
        M[which .. '_bg_grad'] = false
        M[which .. '_stroke'] = DM[which .. '_stroke'] or 1
        M[which .. '_stroke_alpha'] = DM[which .. '_stroke_alpha'] or 1
        ui.mark_settings_dirty()
    end
end

local function draw_marks(ui, name)
    local t, S = ui.t, ui.settings
    return {
        { id = 'mk_display', title = 'DISPLAY', draw = function ()
            toggle(ui, name, 'marks_icons', tkey(ui, 'sf.set.marks_show_icons', 'アイコンを表示する'), S.marks, 'show_icons')
            toggle(ui, name, 'marks_quest', tkey(ui, 'sf.set.marks_show_quest_name', 'クエスト名を表示する'), S.marks, 'show_quest_name')
            -- 0.1.299〜：DISPLAY の説明は、対象名と近くのオブジェクト名の行の i に
            -- 0.1.302〜：近くのオブジェクト名の距離は設定（説明の数もそれに合わせる）
            -- 0.1.306〜：説明は 2 行（1 行目：クエストの対象名、2 行目：近くのオブジェクト名）
            local near_r = settings_mod.nearby_radius(S.marks)
            local names_help = tkey(ui, 'sf.set.marks_names_help', '「クエストの対象名」はクエストに関わる ??? など。\n「近くのオブジェクト名」は {d} ヤルム以内の名前で、アイコンは付けません。', { d = near_r }):gsub('{d}', tostring(near_r))
            toggle(ui, name, 'marks_objects', tkey(ui, 'sf.set.marks_show_object_names', 'クエストの対象名を表示する'), S.marks, 'show_object_names', names_help)
            group(function ()
                toggle(ui, name, 'marks_nearby', tkey(ui, 'sf.set.marks_show_nearby', '近くのオブジェクト名を表示する'), S.marks, 'show_nearby_names', names_help)
                if S.marks.show_nearby_names then
                    if type(S.marks.nearby_radius) ~= 'number' then S.marks.nearby_radius = settings_mod.NEARBY_RADIUS_DEFAULT end
                    stepper(ui, name, 'marks_nearby_radius', t('settings.marks_nearby_radius'), S.marks, 'nearby_radius', 1,
                        settings_mod.NEARBY_RADIUS_MIN, settings_mod.NEARBY_RADIUS_MAX, unit(t('settings.unit_yalms')),
                        DEF.marks.nearby_radius, t('settings.marks_nearby_radius_tip', { d = near_r }))
                end
            end)
            toggle(ui, name, 'marks_fame', tkey(ui, 'sf.set.marks_show_fame', '名声を教える人のアイコン'), S.marks, 'show_fame_npcs')
            stepper(ui, name, 'marks_icon', tkey(ui, 'sf.set.marks_icon_size', 'アイコンの大きさ'),
                S.marks, 'icon_size', 4, 16, 64, UNIT.px, DEF.marks.icon_size)
        end },
        { id = 'mk_position', title = 'POSITION', draw = function ()
            local lo, hi, st = settings_mod.OFFSET_MIN, settings_mod.OFFSET_MAX, settings_mod.OFFSET_STEP
            -- 0.1.299〜：小見出しごとの位置の行は 1 つのまとまり（中は線なし）
            local function offsets(keys, base)
                group(function ()
                    for i, k in ipairs(keys) do
                        if type(S.marks[k]) ~= 'number' then S.marks[k] = 0 end
                        stepper(ui, name, 'marks_' .. k, t('settings.marks_' .. base[i]), S.marks, k, st, lo, hi, UNIT.spx, 0)
                    end
                end)
            end
            subhead(ui, t('settings.marks_pos_obj'))
            offsets(settings_mod.OBJ_OFFSET_KEYS, { 'row_dx', 'row_dy', 'label_dx', 'label_dy' })
            subhead(ui, t('settings.marks_pos_near'))
            offsets(settings_mod.NEAR_OFFSET_KEYS, { 'near_name_dx', 'near_name_dy' })
            subhead(ui, t('settings.marks_pos_other'))
            offsets(settings_mod.OFFSET_KEYS, { 'mark_dx', 'mark_dy', 'label_dx', 'label_dy' })
            toggle(ui, name, 'marks_zoom', tkey(ui, 'sf.set.marks_zoom_follow', 'ズームに合わせて位置を調整する'), S.marks, 'zoom_follow')
            toggle(ui, name, 'marks_no_enlarge', tkey(ui, 'sf.set.marks_no_enlarge_near', '近づいても大きくしない'), S.marks, 'no_enlarge_near')
            if button(ui, name, 'marks_pos_reset', t('settings.marks_pos_reset'),
                { section = SEC, row = 'marks_pos_reset', small = true }) then
                for _, k in ipairs(settings_mod.OFFSET_KEYS) do S.marks[k] = 0 end
                for _, k in ipairs(settings_mod.OBJ_OFFSET_KEYS) do S.marks[k] = 0 end
                for _, k in ipairs(settings_mod.NEAR_OFFSET_KEYS) do S.marks[k] = 0 end
                ui.mark_settings_dirty()
            end
        end },
        { id = 'mk_label', title = 'LABEL', draw = function ()
            color_main(ui, name, 'label', t('settings.color_sample_label'))
            color_detail(ui, name, 'label')
        end },
        { id = 'mk_object', title = 'OBJECT', draw = function ()
            color_main(ui, name, 'under', '???')
            color_detail(ui, name, 'under')
        end },
        { id = 'mk_rings', title = 'RINGS', draw = function ()
            local M, DM = S.marks, DEF.marks
            toggle(ui, name, 'marks_rings', tkey(ui, 'sf.set.rings_show', '足元のリングを出す'), M, 'show_rings')
            stepper(ui, name, 'marks_ring_size', tkey(ui, 'sf.set.rings_size', 'リングの大きさ'),
                M, 'ring_size', 0.1, settings_mod.RING_SIZE_MIN, settings_mod.RING_SIZE_MAX, UNIT.pct, DM.ring_size)
            if type(M.ring_strength) ~= 'number' then M.ring_strength = settings_mod.RING_STRENGTH_DEFAULT or 1 end
            stepper(ui, name, 'marks_ring_strength', tkey(ui, 'sf.set.rings_strength', 'リングの濃さ'),
                M, 'ring_strength', 0.1, settings_mod.RING_STRENGTH_MIN, settings_mod.RING_STRENGTH_MAX, nil, DM.ring_strength)
            -- 0.1.299〜：種類ごとのリングの色は 1 つのまとまり
            group(function ()
                for _, k in ipairs(settings_mod.RING_KINDS) do
                    local key = 'ring_' .. k
                    color_row(ui, name, 'marks_' .. key, t('settings.rings_' .. k), M, key, DM[key], {
                        section = SEC, row = 'marks_' .. key, tooltip_reset = t('settings.reset_default'),
                    })
                end
            end)
            if button(ui, name, 'marks_rings_reset', t('settings.rings_reset'),
                { section = SEC, row = 'marks_rings_reset', small = true }) then
                for _, k in ipairs(settings_mod.RING_KINDS) do
                    local d = DM['ring_' .. k]
                    M['ring_' .. k] = { d[1], d[2], d[3] }
                end
                ui.mark_settings_dirty()
            end
        end },
    }
end

local function draw_notify(ui, name)
    local t, S = ui.t, ui.settings
    local N = S.notify
    return {
        -- LOGIN（ログイン時の続き・表示秒数・テスト）は 0.1.303 でなくした
        { id = 'nt_popup', title = 'POPUP', draw = function ()
            group(function ()
                toggle(ui, name, 'n_popup', tkey(ui, 'sf.set.popup', '受注・完了のお知らせ'), N, 'popup')
                stepper(ui, name, 'n_popup_s', tkey(ui, 'sf.set.popup_seconds', 'お知らせの表示秒数'),
                    N, 'popup_seconds', 1, 3, 30, unit(t('settings.unit_sec')), DEF.notify.popup_seconds)
            end)
            group(function ()
                local no_sound = ui.can_play_sound and not ui.can_play_sound()
                toggle(ui, name, 'n_sound', tkey(ui, 'sf.set.sound', '受注・完了の効果音'), N, 'sound',
                    no_sound and t('settings.sound_unavailable') or nil)
                stepper(ui, name, 'n_sound_v', tkey(ui, 'sf.set.sound_volume', '効果音の音量'),
                    N, 'sound_volume', 10, 0, 100, unit('%'), DEF.notify.sound_volume)
            end)
            -- 0.1.300〜：試すボタンは右のプレビューからここへ（プレビューはやめた）
            if button(ui, name, 'n_popup_try', t('settings.popup_try_accept'),
                { section = SEC, row = 'n_popup_try', info = t('settings.popup_try_note') }) then
                if ui.popup_preview then ui.popup_preview('accept') end
            end
            W.same(ui)
            if button(ui, name, 'n_popup_try2', t('settings.popup_try_complete'), { section = SEC, row = 'n_popup_try' }) then
                if ui.popup_preview then ui.popup_preview('complete') end
            end
        end },
        { id = 'nt_updates', title = 'UPDATES', draw = function ()
            -- 0.1.297〜：更新の様子・今すぐ確認・前のバージョンに戻す（src/ui/update_panel_ui.lua）
            require('src.ui.update_panel_ui').draw(ui, name, {
                toggle = function (u, n, id, _label, tbl, key)
                    return toggle(u, n, id, tkey(ui, 'sf.set.update_notice', '新しいバージョンを知らせる'), tbl, key,
                        tkey(ui, 'sf.set.update_notice_help', '新しいバージョンがあれば、読み込み時にチャットと画面でお知らせします。zip の場所が書いてあれば、そこから更新できます。'))
                end,
                text = function (s) help(ui, s) end,
                button = function (n, id, label, o)
                    o = o or {}
                    return button(ui, n, id, label, { section = SEC, row = id, small = true, disabled = o.disabled, tooltip = o.tooltip, no_form = true })
                end,
            })
        end },
    }
end

local function draw_input(ui, name)
    local t, S = ui.t, ui.settings
    local caps = ui.capabilities and ui.capabilities() or {}
    return {
        { id = 'in_pad', title = 'GAMEPAD', draw = function ()
            -- 0.1.299〜：説明とパッドの読み取りの様子は、この行の i に
            toggle(ui, name, 'pad', tkey(ui, 'sf.set.gamepad', 'パッドで画面を操作'), S.input, 'gamepad',
                tkey(ui, 'sf.set.gamepad_help', 'パッドで本・設定・トラッカーなどを操作します。設定の分類は L1／R1 で替えます。')
                .. '\n' .. t('settings.pad_state', { v = caps.gamepad_note or '?' }))
            stepper(ui, name, 'repeat', tkey(ui, 'sf.set.repeat_ms', '押し続けの間隔（ミリ秒）'),
                S.input, 'repeat_ms', 20, 60, 1000, unit('ms'), DEF.input.repeat_ms)
        end },
        { id = 'in_short', title = 'SHORTCUTS', draw = function ()
            S.shortcut = S.shortcut or { open_book = {}, pass_to_game = true }
            local info = ui.shortcut_info and ui.shortcut_info() or {}
            local sc = require('src.core.shortcut')
            local json_ = require('src.lib.json')
            local ROWS = {
                { key = 'open_book', id = 'sc_open', reset = 'sc_open_reset' },
                { key = 'tracker_toggle', id = 'sc_tt', reset = 'sc_tt_reset' },
                { key = 'tracker_operate', id = 'sc_to', reset = 'sc_to_reset' },
                { key = 'eminence_toggle', id = 'sc_et', reset = 'sc_et_reset' },
                { key = 'compass_toggle', id = 'sc_ct', reset = 'sc_ct_reset' },
            }
            for _, R in ipairs(ROWS) do
                if info.capturing and info.which == R.key then
                    if button(ui, name, 'sc_wait', t('settings.shortcut_waiting'), { section = SEC, row = R.id }) then
                        if ui.shortcut_capture_cancel then ui.shortcut_capture_cancel() end
                    end
                    if info.so_far then colored(ui, 'good', t('settings.shortcut_so_far', { v = info.so_far })) end
                    if button(ui, name, 'sc_cancel', t('settings.shortcut_cancel'), { section = SEC, row = 'sc_cancel', small = true }) then
                        if ui.shortcut_capture_cancel then ui.shortcut_capture_cancel() end
                    end
                else
                    local v = sc.label(S.shortcut[R.key]) or t('settings.shortcut_none')
                    local at_default = sc.same(S.shortcut[R.key] or {}, {})
                    -- 0.1.298〜：名前は左、いまの組み合わせと ↺ は右端
                    local hit, reset = choice(ui, name, R.id, t('settings.shortcut_name_' .. R.key), v, {
                        extra_w = 30,
                        after = function ()
                            return W.reset_button(ui, name, R.reset, {
                                section = SEC, row = R.id, tooltip = t('settings.reset_default'), at_default = at_default,
                            })
                        end,
                    })
                    if hit then
                        if ui.shortcut_capture_start then ui.shortcut_capture_start(R.key) end
                    end
                    if reset then
                        S.shortcut[R.key] = json_.array({})
                        ui.mark_settings_dirty()
                    end
                end
            end
            -- 0.1.304〜：ショートカットの説明とパッドの読み取りの様子は、この行の i に（クラシックの説明の行から）
            local src = caps.pad_source
            local sv = t('settings.shortcut_src_' .. ((src == 'state' or src == 'button' or src == 'dinput') and src or 'none'))
            toggle(ui, name, 'sc_pass', tkey(ui, 'sf.set.shortcut_pass', 'ショートカット操作中は、そのボタンをゲームに送らない'), S.shortcut, 'pass_to_game',
                table.concat({ t('settings.shortcut_note'), t('settings.shortcut_tracker_note'), t('settings.shortcut_windows_note'),
                    t('settings.shortcut_state', { v = sv }) }, '\n'))
        end },
        { id = 'in_gameui', title = 'GAME UI', draw = function ()
            toggle(ui, name, 'g_mission', t('settings.gameui_mission_book'), S.gameui, 'mission_book')
            toggle(ui, name, 'g_config', t('settings.gameui_config_button'), S.gameui, 'config_button')
            toggle(ui, name, 'g_capture', t('settings.gameui_capture'), S.gameui, 'capture')
            toggle(ui, name, 'g_ontop', t('settings.gameui_menus_on_top'), S.gameui, 'menus_on_top')
            -- 0.1.301〜：メニューと重なったとき（隠す／メニューの後ろに出す）
            local ov = (S.gameui.menu_overlap == 'behind') and 'behind' or 'hide'
            if choice(ui, name, 'g_overlap', t('settings.menu_overlap'), t('settings.menu_overlap_' .. ov),
                { info = t('settings.menu_overlap_tip') }) then
                S.gameui.menu_overlap = (ov == 'hide') and 'behind' or 'hide'
                ui.mark_settings_dirty()
            end
            -- 隠す場面（0.1.296〜。0.1.308〜はアイコンの DISPLAY から、メニューと重なったときの下へ）
            require('src.ui.hide_scenes_ui').draw(ui, name, {
                -- 0.1.299〜：まとめの説明は「イベント中に隠す」の i に足す（文の行は出さない）
                toggle = toggle, subhead = subhead, section = SEC, help_into_first = true,
                width = (panel_inner_w and panel_inner_w > 8) and panel_inner_w or nil,
            })
        end },
    }
end

local function draw_save(ui, name)
    local t, S = ui.t, ui.settings
    local caps = ui.capabilities and ui.capabilities() or {}
    return {
        { id = 'sv_backup', title = 'BACKUP', draw = function ()
            stepper(ui, name, 'keep', tkey(ui, 'sf.set.backup_keep', '残すバックアップの数'),
                S.backup, 'keep', 1, 1, 100, unit(t('settings.unit_count')), DEF.backup.keep)
            -- 0.1.299〜：保存先のフォルダとデータのバージョンは「今すぐ保存」の i に
            if button(ui, name, 'save_now', tkey(ui, 'sf.set.save_now', '今すぐ保存'), { section = SEC, row = 'save_now',
                info = t('settings.char_folder', { v = ui.state.char_folder or t('status.waiting') })
                    .. '\n' .. t('settings.data_version', { v = ui.data and ui.data.version or '?' }) }) then
                ui.save_now()
            end
            local orphans = ui.progress and ui.progress.orphan_count and ui.progress:orphan_count() or 0
            if orphans > 0 then colored(ui, 'warn', t('settings.orphans', { n = orphans })) end
            if ui.data and ui.data.warnings and #ui.data.warnings > 0 then
                help(ui, t('settings.data_warnings', { n = #ui.data.warnings }))
            end
        end },
        { id = 'sv_layouts', title = 'LAYOUTS', draw = function ()
            local slots = ui.layout_slots and ui.layout_slots() or {}
            local scale = S.font_scale or 1
            local imgui = ui.imgui
            for i = 1, 5 do
                local s = slots[i] or { name = '', saved = false }
                local id = 'lay_name_' .. i
                local buf = lay_bufs[i] or { '' }
                lay_bufs[i] = buf
                if focus.current(name) ~= id then buf[1] = s.name or '' end
                local sfoc, sa = focus.item(name, id, SEC, id)
                if sa and imgui.SetKeyboardFocusHere then imgui.SetKeyboardFocusHere(0) end
                imgui.SetNextItemWidth(math.floor(160 * scale + 0.5))
                if imgui.InputTextWithHint('##astertrail_' .. id, t('settings.layout_placeholder', { n = tostring(i) }), buf, 40) then
                    if ui.set_layout_name then ui.set_layout_name(i, buf[1]) end
                end
                ui.text_active = ui.text_active or imgui.IsItemActive()
                if imgui.IsItemHovered() and imgui.IsItemClicked and imgui.IsItemClicked(0) then focus.set(name, id) end
                W.same(ui)
                if button(ui, name, 'lay_save_' .. i, t('settings.layout_save'), { section = SEC, row = 'lay_save_' .. i,
                    info = (i == 1) and t('settings.layouts_tip') or nil }) then
                    if ui.set_layout_name then ui.set_layout_name(i, buf[1]) end
                    if ui.save_layout then ui.save_layout(i) end
                end
                W.same(ui)
                if button(ui, name, 'lay_load_' .. i, t('settings.layout_load'), {
                    section = SEC, row = 'lay_load_' .. i, disabled = not s.saved,
                    tooltip = (not s.saved) and t('settings.layout_empty') or nil,
                }) then
                    if ui.load_layout then ui.load_layout(i) end
                end
            end
        end },
        { id = 'sv_progress', title = 'PROGRESS', draw = function ()
            if button(ui, name, 'reset_unstarted', tkey(ui, 'sf.set.reset_unstarted', '受注フラグのないものを未開始に戻す'),
                { section = SEC, row = 'reset_unstarted', info = t('settings.reset_unstarted_note') }) then
                if ui.revert_unstarted then ui.revert_unstarted() end
            end
        end },
        { id = 'sv_about', title = 'ABOUT', draw = function ()
            help(ui, 'Based on YunaUI by Yunas - https://github.com/YunasXI/yunaui')
            help(ui, t('about.license'))
            help(ui, t('about.version', { v = ui.addon_version, d = (ui.data and ui.data.version) or '?' }))
        end },
        { id = 'sv_debug', title = 'DEBUG', draw = function ()
            colored(ui, 'accent', t('settings.debug'))
            S.debug = S.debug or { state_buttons = false }
            toggle(ui, name, 'dbg_state', t('settings.debug_state_buttons'), S.debug, 'state_buttons', t('settings.debug_note'))
        end, when = function ()
            return ui.manual_checks == nil or ui.manual_checks()
        end },
    }
end

-- 0.1.304〜：見た目に、お知らせ（POPUP・UPDATES）とマイレイアウト（LAYOUTS）もまとめる。お知らせの分類はなくした
local function draw_look(ui, name)
    local out = {}
    for _, sp in ipairs(draw_look_base(ui, name)) do out[#out + 1] = sp end
    for _, sp in ipairs(draw_notify(ui, name)) do out[#out + 1] = sp end
    for _, sp in ipairs(draw_save(ui, name, true)) do
        if sp.id == 'sv_layouts' then out[#out + 1] = sp end
    end
    return out
end

local function draw_save_only(ui, name)
    local out = {}
    for _, sp in ipairs(draw_save(ui, name)) do
        if sp.id ~= 'sv_layouts' then out[#out + 1] = sp end
    end
    return out
end

local DRAWERS = {
    look = draw_look, layout = draw_layout, tracker = draw_tracker, map = draw_map,
    marks = draw_marks, input = draw_input, save = draw_save_only,
}

-- ========== 窓の組み立て（0.1.300〜：右のプレビューはやめた。中央の箱が幅を使う） ==========

local footer_used = 32

local function no_scroll_flags()
    return theme.C('ImGuiWindowFlags_NoScrollbar') + theme.C('ImGuiWindowFlags_NoScrollWithMouse')
end

local function begin_pane(ui, id, w, h, flags, pad)
    local imgui = ui.imgui
    local nvar = 0
    if pad and imgui.PushStyleVar then
        if pcall(imgui.PushStyleVar, theme.C('ImGuiStyleVar_WindowPadding'), pad) then
            nvar = 1
        end
    end
    local ok = pcall(imgui.BeginChild, id, { w, h }, 0, flags or 0)
    if ok then
        window.push(ui, 'child')
        -- 0.1.304〜：本の中に出すときも設定の文字サイズ（「その他」）で描く
        window.set_font(ui, window.font_scale(ui, 'settings'), {})
    end
    return ok, nvar
end

local function end_pane(ui, ok, nvar)
    local imgui = ui.imgui
    if ok then window.pop(ui, 'child') end
    if (nvar or 0) > 0 and imgui.PopStyleVar then pcall(imgui.PopStyleVar, nvar) end
end

local function draw_nav(ui, name, cat, nw, nh)
    local imgui = ui.imgui
    local x, y = sf.xy(pcall(imgui.GetCursorScreenPos))
    x, y = x or 0, y or 0
    local dl = dl_of(imgui)
    local row_h = 36
    for i, c in ipairs(CATS) do
        local y1 = y + (i - 1) * row_h
        local on = (c.key == cat)
        local id = 'sfcat_' .. c.key
        sf.set_cursor(imgui, x, y1)
        local hit = sf.hit(imgui, '##' .. id, nw - 4, row_h - 4)
        if on then
            if astral() then
                sf.frame(dl, x, y1, x + nw - 4, y1 + row_h - 4, {
                    cut = 4, fill_a = 0.40, line_a = 0.95, line = theme.u32('sf_cyan', 1.0),
                    brackets = false, glow = 0, thick = 1.3, band = false,
                })
            else
                skin_rect(dl, x, y1, x + nw - 4, y1 + row_h - 4, 0.30, 0.70, 'select', theme.look == 'yunaui' and 'lavender' or 'accent')
            end
        end
        local col = theme.u32(on and 'heading' or 'muted', 1)
        local icon = ICONS[c.key]
        if icon then icon(dl, x + 16, y1 + (row_h - 4) / 2, 9, col) end
        sf.text_at(imgui, x + 32, y1 + 8, function ()
            theme.TextColored(imgui, theme.col(on and 'heading' or 'muted'), c.ja)
        end)
        if hit then
            settings_ui.select_tab(c.key)
            cat = c.key
        end
    end
    sf.set_cursor(imgui, x, y + nh)
    if imgui.Dummy then pcall(imgui.Dummy, { nw, 1 }) end
    return cat
end

local function pack_panels(ui, name, specs, width, cols)
    local imgui = ui.imgui
    local gap = 10
    local pw = (cols == 2) and math.floor((width - gap) / 2) or width
    local x0, y0 = sf.xy(pcall(imgui.GetCursorScreenPos))
    x0, y0 = x0 or 0, y0 or 0
    local col_y = { 0, 0 }
    for _, sp in ipairs(specs or {}) do
        if sp.when and not sp.when() then
            -- 出さないパネル（公開ビルドのデバッグなど）
        else
            local c = 1
            if cols == 2 and col_y[2] < col_y[1] then c = 2 end
            local px = x0 + (c - 1) * (pw + gap)
            local py = y0 + col_y[c]
            sf.set_cursor(imgui, px, py)
            local h = panel(ui, sp.id, sp.title, pw, sp.draw)
            col_y[c] = col_y[c] + h + gap
        end
    end
    local total = math.max(col_y[1], col_y[2], 8)
    sf.set_cursor(imgui, x0, y0 + total)
    if imgui.Dummy then pcall(imgui.Dummy, { width, 0 }) end
end

function M.body(ui)
    local imgui, t, S = ui.imgui, ui.t, ui.settings
    local name = 'settings'
    if not imgui then return end

    -- 0.1.304〜：キー・パッドの選択の並びを毎フレーム作り直す（前は作っておらず、
    -- アストラルの設定ではキー・パッドで行を動けず、開いたときの選択も無かった）
    focus.begin(name)
    -- 開いたとき・分類を替えたとき（LB/RB）は中身の最初の項目を選ぶ
    local want_first = settings_ui.take_focus_first and settings_ui.take_focus_first()
    -- 0.1.304〜：左の分類を LB/RB（R1 など）で替えられるように並びを渡す（前はアストラルで替わらなかった）
    if settings_ui.set_tab_keys then
        local keys = {}
        for i, c in ipairs(CATS) do keys[i] = c.key end
        settings_ui.set_tab_keys(keys)
    end
    local cat = cat_key(settings_ui.current_tab())
    if settings_ui.current_tab() ~= cat then settings_ui.select_tab(cat) end

    local aw, ah = avail(imgui)
    aw, ah = aw or 800, ah or 500
    local hx, hy = sf.xy(pcall(imgui.GetCursorScreenPos))
    hx, hy = hx or 0, hy or 0

    -- ヘッダー：ASTERTRAIL  SETTINGS
    local logo = 'ASTERTRAIL'
    local sub = 'SETTINGS'
    if astral() then
        heading_font(ui, name, true)
        local lw = select(1, sf.measure_heading(imgui, logo, 'title')) or 120
        sf.add_heading(imgui, hx + 4, hy + 2, theme.u32('heading', 1.0), logo, 'title')
        sf.add_heading(imgui, hx + 4 + lw + 16, hy + 2, theme.u32('sf_cyan', 1.0), sub, 'title')
        heading_font(ui, name, false)
    else
        -- クラシック・YunaUI：テーマの見出しの色で「設定」
        local head = t('settings.title')
        if type(head) ~= 'string' or head == 'settings.title' then head = 'Astertrail ' .. sub end
        sf.text_at(imgui, hx + 4, hy + 6, function ()
            theme.TextColored(imgui, theme.col(theme.look == 'yunaui' and 'lavender' or 'heading'), head)
        end)
    end
    local header_h = 36
    local nav_w = 148
    local gap = 10
    -- 見出しの直後の残り高さから、枠・余白・フッタを引いて中央とプレビューの高さを決める
    sf.set_cursor(imgui, hx, hy + header_h)
    local rem_w, rem_h = avail(imgui)
    rem_w, rem_h = rem_w or aw, rem_h or ah
    local frame_h = 24
    if imgui.GetFrameHeightWithSpacing then
        local okf, fh = pcall(imgui.GetFrameHeightWithSpacing)
        if okf then frame_h = tonumber(fh) or frame_h end
    end
    local footer_h = math.max(footer_used or 32, frame_h + 8)
    local mid_h = math.max(80, (tonumber(rem_h) or ah or 200) - footer_h)
    -- 0.1.300〜：右のプレビューはやめて、その幅を中央の箱に使う
    local center_w = math.max(200, (rem_w or aw) - nav_w - gap - 4)
    -- 配置は長い名前とボタンがあるので、常に1列（2列だと BOOK が窮屈で、WINDOWS の横が空く）
    -- 0.1.300〜：2 列にするのは、箱 1 つに名前・スライダー（最小 120）・↺／－／＋／値が 1 行で入る幅（460×倍率）があるときだけ
    local sc = 1
    do
        local okh, fh1 = pcall(imgui.GetFrameHeight)
        fh1 = okh and tonumber(fh1) or nil
        if fh1 and fh1 > 0 then sc = math.max(0.5, fh1 / 20) end
    end
    local cols = (center_w >= math.floor(460 * sc) * 2 + 10 and cat ~= 'layout') and 2 or 1

    -- 左ナビ（高さは残りぴったり。中は自分で置くので余白0、バーは出さない）
    local ok_nav, var_nav = begin_pane(ui, '##astertrail_sf_set_nav', nav_w, mid_h, no_scroll_flags(), { 0, 0 })
    cat = draw_nav(ui, name, cat, nav_w, mid_h)
    end_pane(ui, ok_nav, var_nav)

    imgui.SameLine(0, gap)
    -- 中央：中身が本当に超えたときだけ外のスクロールバー
    local ok_mid, var_mid = begin_pane(ui, '##astertrail_sf_set_mid', center_w, mid_h, 0, { 0, 0 })
    local drawer = DRAWERS[cat]
    local specs = drawer and drawer(ui, name) or {}
    -- このカテゴリのラベル列幅（前フレームの最大。パネル間でそろえる）
    local st = form_cat[cat] or { measured = 0, used = 0 }
    if (st.measured or 0) > 0 then st.used = st.measured end
    st.measured = 0
    form_cat[cat] = st
    form = { shared = st.used or 0, cat = cat, measured = 0 }
    local mark0 = focus.mark and focus.mark(name) or nil
    pack_panels(ui, name, specs, select(1, avail(imgui)) or center_w, cols)
    if (want_first or focus.current(name) == nil) and mark0 and focus.id_at then
        local first = focus.id_at(name, mark0 + 1)
        if first then focus.set(name, first, true) end
    end
    st = form_cat[cat] or st
    if (st.measured or 0) > 0 then st.used = st.measured end
    form = nil
    end_pane(ui, ok_mid, var_mid)

    -- フッタ
    local fy = hy + header_h + mid_h + 4
    sf.set_cursor(imgui, hx, fy)
    local ver = t('about.version', { v = ui.addon_version or '?', d = (ui.data and ui.data.version) or '?' })
    local hint = tkey(ui, 'sf.set.footer_hint', 'クリックで選ぶ　　Esc で閉じる')
    local close_lab = tkey(ui, 'sf.set.back', '戻る')
    local fw = select(1, avail(imgui)) or 200
    local ver_w = tonumber((theme.measure_text(imgui, ver))) or 0
    local hint_w = tonumber((theme.measure_text(imgui, hint))) or 0
    local btn_w = (tonumber((theme.measure_text(imgui, close_lab))) or 40) + 24
    -- 狭いときは版を折り返し、案内は次の行へ（はみ出さない）
    if fw > 40 and (ver_w + 16 + btn_w + 12 + hint_w) > fw then
        CT.wrapped(ui, ver, 'muted', nil, fw)
        if button(ui, name, 'close', close_lab, { section = SEC, row = 'f', small = true }) then
            ui.close_window(name)
        end
        local left = tonumber((select(1, avail(imgui)))) or 0
        if left > 48 and hint_w + 12 < left then
            imgui.SameLine(0, 12)
            theme.TextColored(imgui, theme.col('muted'), hint)
        else
            CT.wrapped(ui, hint, 'muted', nil, fw)
        end
    else
        theme.TextColored(imgui, theme.col('muted'), ver)
        imgui.SameLine(0, 16)
        if button(ui, name, 'close', close_lab, { section = SEC, row = 'f', small = true }) then
            ui.close_window(name)
        end
        imgui.SameLine(0, 12)
        theme.TextColored(imgui, theme.col('muted'), hint)
    end
    local _, fy2 = sf.xy(pcall(imgui.GetCursorScreenPos))
    if fy and fy2 then
        footer_used = math.max(28, (fy2 - fy) + 4)
    end
    focus.finish(name)
end

M.CATS = CATS
M.cat_key = cat_key
return M
