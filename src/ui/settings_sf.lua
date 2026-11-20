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

local CATS = {
    { key = 'look',    ja = '見た目' },
    { key = 'layout',  ja = '配置' },
    { key = 'tracker', ja = 'トラッカー' },
    { key = 'map',     ja = '地図' },
    { key = 'marks',   ja = 'アイコン' },
    { key = 'notify',  ja = 'お知らせ' },
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
function ICONS.notify(dl, x, y, r, col)
    -- ベル
    pcall(function ()
        dl:AddLine({ x - r * 0.45, y + r * 0.15 }, { x - r * 0.45, y - r * 0.05 }, col, 1.5)
        dl:AddLine({ x + r * 0.45, y + r * 0.15 }, { x + r * 0.45, y - r * 0.05 }, col, 1.5)
        dl:AddLine({ x - r * 0.45, y - r * 0.05 }, { x, y - r * 0.85 }, col, 1.5)
        dl:AddLine({ x + r * 0.45, y - r * 0.05 }, { x, y - r * 0.85 }, col, 1.5)
        dl:AddLine({ x - r * 0.55, y + r * 0.15 }, { x + r * 0.55, y + r * 0.15 }, col, 1.5)
        dl:AddCircle({ x, y + r * 0.42 }, r * 0.14, col, 8, 1.4)
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
    for _, c in ipairs(CATS) do
        if c.key == raw then return raw end
    end
    return 'look'
end

local function form_note(ui, label)
    if not form then return end
    local tw = tonumber(select(1, theme.measure_text(ui.imgui, tostring(label or '')))) or 0
    if tw > (form.measured or 0) then form.measured = tw end
end

local function form_opts(base)
    local o = base or {}
    if form and form.label_w then
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

local function toggle(ui, name, id, label, tbl, key)
    form_note(ui, label)
    if W.switch(ui, name, id, label, tbl[key] == true, form_opts({
        section = SEC, row = id, reduce_motion = ui.reduce_motion,
    })) then
        tbl[key] = not tbl[key]
        ui.mark_settings_dirty()
        return true
    end
    return false
end

local function stepper(ui, name, id, label, tbl, key, step, lo, hi, text, default)
    form_note(ui, label)
    return W.slider(ui, name, id, label, tbl, key, form_opts({
        step = step, lo = lo, hi = hi, default = default, text = text, section = SEC,
        slider_w = 120,
        tooltip_reset = ui.t('settings.reset_default'),
    }))
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
    if form and form.label_w and form.label_w > 8 and imgui.SetCursorScreenPos and not opts.no_form then
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
        local tw = (tonumber(select(1, theme.measure_text(imgui, tostring(label or '')))) or 0) + 16
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
    return hit
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
    sf.frame(dl, x, y, x + pw, y + guessed, {
        cut = 6, fill_a = 0.14, line_a = 0.78,
        line = theme.u32('sf_cyan', 0.85),
        brackets = false, glow = 0, thick = 1.25, band = false,
    })
    heading_font(ui, win, true)
    local _, hh = sf.add_heading(imgui, x + pad, y + 5, theme.u32('sf_cyan', 1.0), title, 'label', { max_w = pw - pad * 2 })
    heading_font(ui, win, false)
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
    local cap = math.max(64, math.min(200, inner - min_ctrl))
    local last = 0
    if prev_form and prev_form.shared then last = prev_form.shared end
    local lw = math.min(cap, math.max(64, last > 0 and last or cap))
    form = {
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
        sf.frame(dl, x, y, x + pw, y + h, {
            cut = 6, fill_a = 0, line_a = 0.78,
            line = theme.u32('sf_cyan', 0.85),
            brackets = false, glow = 0, thick = 1.25, band = false,
        })
    end
    sf.set_cursor(imgui, x, y + h)
    if imgui.Dummy then pcall(imgui.Dummy, { pw, 1 }) end
    return h
end

-- ========== カテゴリ中身 ==========

local function draw_look(ui, name)
    local t, S = ui.t, ui.settings
    -- GENERAL
    -- THEME / TYPE / WINDOWS / FONT
    return {
        { id = 'look_general', title = 'GENERAL', draw = function ()
            if button(ui, name, 'lang', tkey(ui, 'sf.set.language', '表示言語：{v}', {
                v = S.language == 'ja' and '日本語' or 'English'
            }), { section = SEC, row = 'lang' }) then
                S.language = (S.language == 'ja') and 'en' or 'ja'
                ui.set_language(S.language)
                ui.mark_settings_dirty()
            end
            do
                local look = (S.look == 'yunaui' or S.look == 'sf' or S.look == 'classic') and S.look or 'classic'
                if button(ui, name, 'look_style', tkey(ui, 'sf.set.theme', 'テーマ：{v}', { v = t('settings.look_' .. look) }),
                    { section = SEC, row = 'look_style' }) then
                    S.look = theme.next_look(look)
                    theme.set_look(S.look)
                    ui.mark_settings_dirty()
                end
            end
            toggle(ui, name, 'motion', tkey(ui, 'sf.set.reduce_motion', '動きを減らす'), S, 'reduce_motion')
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
                    stepper(ui, name, 'alpha_' .. area, tkey(ui, L[1], L[2]), S.alphas, area, 0.05, 0.3, 1.0, UNIT.pct, DEF.alphas[area])
                end
            end
            help(ui, tkey(ui, 'sf.set.alpha_note', '「その他」は、お知らせと入口のアイコンです。'))
        end },
        { id = 'look_font', title = 'FONT', draw = function ()
            toggle(ui, name, 'font_crisp', tkey(ui, 'sf.set.font_crisp', '画面の文字をくっきり（メイリオ）'), S, 'font_crisp')
            help(ui, tkey(ui, 'sf.set.font_crisp_help', 'オフでも、英語見出しの Melete はそのままです。'))
            toggle(ui, name, 'font_crisp_bold', tkey(ui, 'sf.set.font_crisp_bold', '太字（メイリオ）'), S, 'font_crisp_bold')
            stepper(ui, name, 'font_crisp_outline', tkey(ui, 'sf.set.font_crisp_outline', '縁取りの太さ'),
                S, 'font_crisp_outline', 0.25, 0, 3, UNIT.fpx, DEF.font_crisp_outline)
            stepper(ui, name, 'font_crisp_outline_alpha', tkey(ui, 'sf.set.font_crisp_outline_alpha', '縁取りの濃さ'),
                S, 'font_crisp_outline_alpha', 0.05, 0, 1, UNIT.pct, DEF.font_crisp_outline_alpha)
        end },
    }
end

local function draw_layout(ui, name)
    local S = ui.settings
    return {
        { id = 'lay_windows', title = 'WINDOWS', draw = function ()
            toggle(ui, name, 'lock', tkey(ui, 'sf.set.layout_locked', '窓の位置を固定'), S, 'layout_locked')
            if button(ui, name, 'inside', tkey(ui, 'sf.set.bring_inside', '画面内へ戻す'), { section = SEC, row = 'pos' }) then
                ui.bring_inside()
            end
            W.same(ui)
            if button(ui, name, 'reset', tkey(ui, 'sf.set.reset_layout', '初期配置に戻す'), { section = SEC, row = 'pos' }) then
                ui.reset_layout()
            end
            toggle(ui, name, 'icon', tkey(ui, 'sf.set.entry_icon', '画面の入口アイコン'), S.entry_icon, 'visible')
        end },
        { id = 'lay_book', title = 'BOOK', draw = function ()
            toggle(ui, name, 'filters', tkey(ui, 'sf.set.remember_filters', '絞り込みを覚える'), S.book, 'remember_filters')
            toggle(ui, name, 'remember_pos', tkey(ui, 'sf.set.remember_position', '設定を開いたとき、前回の項目から始める'), S, 'remember_position')
            if button(ui, name, 'reset_cols', tkey(ui, 'sf.set.reset_columns', '一覧の列の並びと表示を元に戻す'),
                { section = SEC, row = 'reset_cols' }) then
                if require('src.ui.book').reset_columns(S) then ui.mark_settings_dirty() end
            end
        end },
    }
end

local function draw_tracker(ui, name)
    local t, S = ui.t, ui.settings
    return {
        { id = 'tr_main', title = 'TRACKER', draw = function ()
            if toggle(ui, name, 'tr_vis', tkey(ui, 'sf.set.tracker_visible', 'トラッカーを出す'), S.tracker, 'visible') then
                if not S.tracker.visible and ui.release then ui.release() end
            end
            help(ui, tkey(ui, 'sf.set.tracker_visible_help', '本の★からも切り替えられます。'))
            stepper(ui, name, 'pins', tkey(ui, 'sf.set.max_pins', 'ピンの上限'), S.tracker, 'max_pins', 1, 1, 30,
                unit(t('settings.unit_count')), DEF.tracker.max_pins)
            if toggle(ui, name, 'tr_fold', tkey(ui, 'sf.set.tracker_collapsed', '名前だけ表示'), S.tracker, 'collapsed')
                and S.tracker.collapsed then
                require('src.ui.tracker').set_collapsed(ui, true)
            end
            local al = (S.tracker.align == 'left') and 'left' or 'right'
            if button(ui, name, 'tr_align', tkey(ui, 'sf.set.tracker_align', '文字のそろえ：{v}', { v = t('settings.tracker_align_' .. al) }),
                { section = SEC, row = 'tr_align' }) then
                S.tracker.align = (al == 'left') and 'right' or 'left'
                ui.mark_settings_dirty()
            end
            local vw = (S.tracker.view == 'tabs') and 'tabs' or 'list'
            if button(ui, name, 'tr_view', tkey(ui, 'sf.set.tracker_view', '表示形式：{v}', { v = t('settings.tracker_view_' .. vw) }),
                { section = SEC, row = 'tr_view' }) then
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
            if toggle(ui, name, 'compass_vis', tkey(ui, 'sf.set.compass_visible', 'コンパスを出す'), S.compass, 'visible')
                and S.compass.visible and ui.set_compass_visible then
                ui.set_compass_visible(true)
            end
            stepper(ui, name, 'compass_range', tkey(ui, 'sf.set.compass_range', '何ヤルム以内を出す'),
                S.compass, 'max_dist', 5, 5, 100, unit(t('settings.unit_yalms')), DEF.compass.max_dist)
        end },
        { id = 'tr_eminence', title = 'EMINENCE', draw = function ()
            toggle(ui, name, 'roe_fold', tkey(ui, 'sf.set.roe_collapsed', '★を付けたものだけ出す'), S.eminence, 'collapsed')
        end },
    }
end

local function draw_map(ui, name)
    local S = ui.settings
    return {
        { id = 'map_main', title = 'MAP', draw = function ()
            toggle(ui, name, 'map_on', tkey(ui, 'sf.set.map_enabled', '地図を出す'), S.map, 'enabled')
            if S.map.grid_alpha == nil then S.map.grid_alpha = 0.35 end
            stepper(ui, name, 'map_grid', tkey(ui, 'sf.set.map_grid_alpha', 'マス目の線の濃さ'),
                S.map, 'grid_alpha', 0.05, 0, 1, UNIT.pct, 0.35)
            help(ui, tkey(ui, 'sf.set.map_grid_alpha_help', '0 で線と外側の目盛りを出さない。ズームしても、地図の枠の外にマスの記号を出します。'))
            help(ui, tkey(ui, 'sf.set.map_credit', '地図の画像は同梱せず、クライアントのデータを実行時に表示します。'))
        end },
    }
end

local function color_row(ui, name, id, label, tbl, key, def, opts)
    opts = opts or {}
    form_note(ui, label)
    local o = {}
    for k, v in pairs(opts) do o[k] = v end
    o = form_opts(o)
    return W.color_row(ui, name, id, label, tbl, key, def, o)
end

local function color_main(ui, name, which, sample)
    local S, t = ui.settings, ui.t
    local M, DM = S.marks, DEF.marks
    subhead(ui, tkey(ui, 'sf.set.color_' .. which, which == 'label' and 'クエスト名' or 'オブジェクト名'))
    local c1, c2 = settings_mod.text_colors(M, which)
    W.color_preview(ui, sample, c1, c2)
    color_row(ui, name, 'marks_' .. which .. '_color', tkey(ui, 'sf.set.color_start', '色'),
        M, which .. '_color', DM[which .. '_color'], {
            section = SEC, row = 'marks_' .. which .. '_color',
            tooltip_reset = t('settings.reset_default'),
        })
    local bg_key = which .. '_bg_alpha'
    if type(M[bg_key]) ~= 'number' then M[bg_key] = settings_mod.LABEL_BG_ALPHA_DEFAULT end
    stepper(ui, name, 'marks_' .. bg_key, tkey(ui, 'sf.set.' .. bg_key, '背景の濃さ'),
        M, bg_key, 0.05, settings_mod.LABEL_BG_ALPHA_MIN, settings_mod.LABEL_BG_ALPHA_MAX, UNIT.pct, DM[bg_key])
end

local function color_detail(ui, name, which)
    local S, t = ui.settings, ui.t
    local M, DM = S.marks, DEF.marks
    toggle(ui, name, 'marks_' .. which .. '_grad', t('settings.color_gradient'), M, which .. '_grad')
    if M[which .. '_grad'] then
        color_row(ui, name, 'marks_' .. which .. '_color2', t('settings.color_end'),
            M, which .. '_color2', DM[which .. '_color2'], {
                section = SEC, row = 'marks_' .. which .. '_color2', tooltip_reset = t('settings.reset_default'),
            })
    end
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
    local sk, sak = which .. '_stroke', which .. '_stroke_alpha'
    if type(M[sk]) ~= 'number' then M[sk] = settings_mod.STROKE_DEFAULT or 1 end
    stepper(ui, name, 'marks_' .. sk, t('settings.marks_' .. sk), M, sk, 1,
        settings_mod.STROKE_MIN, settings_mod.STROKE_MAX, UNIT.px, DM[sk])
    if type(M[sak]) ~= 'number' then M[sak] = 1 end
    stepper(ui, name, 'marks_' .. sak, t('settings.marks_' .. sak), M, sak, 0.05, 0, 1, UNIT.pct, DM[sak] or 1)
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
            toggle(ui, name, 'marks_objects', tkey(ui, 'sf.set.marks_show_object_names', 'クエストの対象名を表示する'), S.marks, 'show_object_names')
            toggle(ui, name, 'marks_nearby', tkey(ui, 'sf.set.marks_show_nearby', '近くのオブジェクト名を表示する'), S.marks, 'show_nearby_names')
            toggle(ui, name, 'marks_fame', tkey(ui, 'sf.set.marks_show_fame', '名声を教える人のアイコン'), S.marks, 'show_fame_npcs')
            help(ui, tkey(ui, 'sf.set.marks_names_help', '「クエストの対象名」はクエストに関わる ??? など。「近くのオブジェクト名」は 30 ヤルム以内の名前で、アイコンは付けません。'))
            stepper(ui, name, 'marks_icon', tkey(ui, 'sf.set.marks_icon_size', 'アイコンの大きさ'),
                S.marks, 'icon_size', 4, 16, 64, UNIT.px, DEF.marks.icon_size)
        end },
        { id = 'mk_position', title = 'POSITION', draw = function ()
            local lo, hi, st = settings_mod.OFFSET_MIN, settings_mod.OFFSET_MAX, settings_mod.OFFSET_STEP
            local function offsets(keys, base)
                for i, k in ipairs(keys) do
                    if type(S.marks[k]) ~= 'number' then S.marks[k] = 0 end
                    stepper(ui, name, 'marks_' .. k, t('settings.marks_' .. base[i]), S.marks, k, st, lo, hi, UNIT.spx, 0)
                end
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
            toggle(ui, name, 'marks_rings_event', tkey(ui, 'sf.set.rings_hide_in_event', 'イベント中はリングを消す'), M, 'hide_rings_in_event')
            for _, k in ipairs(settings_mod.RING_KINDS) do
                local key = 'ring_' .. k
                color_row(ui, name, 'marks_' .. key, t('settings.rings_' .. k), M, key, DM[key], {
                    section = SEC, row = 'marks_' .. key, tooltip_reset = t('settings.reset_default'),
                })
            end
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
        { id = 'nt_login', title = 'LOGIN', draw = function ()
            toggle(ui, name, 'n_login', tkey(ui, 'sf.set.login_resume', 'ログイン時の続き'), N, 'login_resume')
            stepper(ui, name, 'n_login_s', tkey(ui, 'sf.set.login_resume_seconds', '続きの表示秒数'),
                N, 'login_resume_seconds', 1, 3, 60, unit(t('settings.unit_sec')), DEF.notify.login_resume_seconds)
        end },
        { id = 'nt_popup', title = 'POPUP', draw = function ()
            toggle(ui, name, 'n_popup', tkey(ui, 'sf.set.popup', '受注・完了のお知らせ'), N, 'popup')
            stepper(ui, name, 'n_popup_s', tkey(ui, 'sf.set.popup_seconds', 'お知らせの表示秒数'),
                N, 'popup_seconds', 1, 3, 30, unit(t('settings.unit_sec')), DEF.notify.popup_seconds)
            toggle(ui, name, 'n_sound', tkey(ui, 'sf.set.sound', '受注・完了の効果音'), N, 'sound')
            stepper(ui, name, 'n_sound_v', tkey(ui, 'sf.set.sound_volume', '効果音の音量'),
                N, 'sound_volume', 10, 0, 100, unit('%'), DEF.notify.sound_volume)
            if ui.can_play_sound and not ui.can_play_sound() then
                help(ui, t('settings.sound_unavailable'))
            end
        end },
        { id = 'nt_updates', title = 'UPDATES', draw = function ()
            toggle(ui, name, 'update_notice', tkey(ui, 'sf.set.update_notice', 'アップデートのお知らせ'), S.update_notice, 'enabled')
            help(ui, tkey(ui, 'sf.set.update_notice_help', '新しい版があれば、読み込み時にチャットへ1行出します。'))
        end },
    }
end

local function draw_input(ui, name)
    local t, S = ui.t, ui.settings
    local caps = ui.capabilities and ui.capabilities() or {}
    return {
        { id = 'in_pad', title = 'GAMEPAD', draw = function ()
            toggle(ui, name, 'pad', tkey(ui, 'sf.set.gamepad', 'パッドで画面を操作'), S.input, 'gamepad')
            help(ui, tkey(ui, 'sf.set.gamepad_help', 'このテーマの設定画面はマウスで操作します。パッドはほかの画面で使えます。'))
            stepper(ui, name, 'repeat', tkey(ui, 'sf.set.repeat_ms', '押し続けの間隔（ミリ秒）'),
                S.input, 'repeat_ms', 20, 60, 1000, unit('ms'), DEF.input.repeat_ms)
            help(ui, t('settings.pad_state', { v = caps.gamepad_note or '?' }))
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
                    if button(ui, name, R.id, t('settings.shortcut_' .. R.key, { v = v }), { section = SEC, row = R.id }) then
                        if ui.shortcut_capture_start then ui.shortcut_capture_start(R.key) end
                    end
                    W.same(ui)
                    local at_default = sc.same(S.shortcut[R.key] or {}, {})
                    if W.reset_button(ui, name, R.reset, {
                        section = SEC, row = R.id, tooltip = t('settings.reset_default'), at_default = at_default,
                    }) then
                        S.shortcut[R.key] = json_.array({})
                        ui.mark_settings_dirty()
                    end
                end
            end
            toggle(ui, name, 'sc_pass', tkey(ui, 'sf.set.shortcut_pass', 'ショートカット操作中は、そのボタンをゲームに送らない'), S.shortcut, 'pass_to_game')
        end },
        { id = 'in_gameui', title = 'GAME UI', draw = function ()
            toggle(ui, name, 'g_mission', t('settings.gameui_mission_book'), S.gameui, 'mission_book')
            toggle(ui, name, 'g_config', t('settings.gameui_config_button'), S.gameui, 'config_button')
            toggle(ui, name, 'g_capture', t('settings.gameui_capture'), S.gameui, 'capture')
            toggle(ui, name, 'g_ontop', t('settings.gameui_menus_on_top'), S.gameui, 'menus_on_top')
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
            help(ui, t('settings.char_folder', { v = ui.state.char_folder or t('status.waiting') }))
            help(ui, t('settings.data_version', { v = ui.data and ui.data.version or '?' }))
            if button(ui, name, 'save_now', tkey(ui, 'sf.set.save_now', '今すぐ保存'), { section = SEC, row = 'save_now' }) then
                ui.save_now()
            end
            local orphans = ui.progress and ui.progress.orphan_count and ui.progress:orphan_count() or 0
            if orphans > 0 then colored(ui, 'warn', t('settings.orphans', { n = orphans })) end
            if ui.data and ui.data.warnings and #ui.data.warnings > 0 then
                help(ui, t('settings.data_warnings', { n = #ui.data.warnings }))
            end
        end },
        { id = 'sv_layouts', title = 'LAYOUTS', draw = function ()
            help(ui, t('settings.layouts_tip'))
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
                if button(ui, name, 'lay_save_' .. i, t('settings.layout_save'), { section = SEC, row = 'lay_save_' .. i }) then
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
                { section = SEC, row = 'reset_unstarted' }) then
                if ui.revert_unstarted then ui.revert_unstarted() end
            end
            help(ui, t('settings.reset_unstarted_note'))
        end },
        { id = 'sv_about', title = 'ABOUT', draw = function ()
            help(ui, 'Based on YunaUI by Yunas - https://github.com/YunasXI/yunaui')
            help(ui, t('about.license'))
            help(ui, t('about.version', { v = ui.addon_version, d = (ui.data and ui.data.version) or '?' }))
        end },
        { id = 'sv_debug', title = 'DEBUG', draw = function ()
            colored(ui, 'accent', t('settings.debug'))
            S.debug = S.debug or { state_buttons = false }
            toggle(ui, name, 'dbg_state', t('settings.debug_state_buttons'), S.debug, 'state_buttons')
            help(ui, t('settings.debug_note'))
        end, when = function ()
            return ui.manual_checks == nil or ui.manual_checks()
        end },
    }
end

local DRAWERS = {
    look = draw_look, layout = draw_layout, tracker = draw_tracker, map = draw_map,
    marks = draw_marks, notify = draw_notify, input = draw_input, save = draw_save,
}

-- ========== プレビュー（0.1.276〜：高さは残りに合わせ、スクロールバーを出さない。中身は枠の内側余白で折り返す） ==========

local footer_used = 32
local PREV_PAD = 16

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
    if ok then window.push(ui, 'child') end
    return ok, nvar
end

local function end_pane(ui, ok, nvar)
    local imgui = ui.imgui
    if ok then window.pop(ui, 'child') end
    if (nvar or 0) > 0 and imgui.PopStyleVar then pcall(imgui.PopStyleVar, nvar) end
end

local function win_rect(imgui, fw, fh)
    local x, y = sf.xy(pcall(imgui.GetWindowPos))
    local ok, a, b = pcall(imgui.GetWindowSize)
    local w, h
    if ok then
        if type(a) == 'table' then w, h = tonumber(a.x or a[1]), tonumber(a.y or a[2])
        else w, h = tonumber(a), tonumber(b) end
    end
    return x or 0, y or 0, w or fw or 200, h or fh or 200
end

local function preview_text(ui, imgui, x, y, w, h, text, col)
    sf.add_heading(imgui, x, y + h * 0.42, col or theme.u32('heading', 0.95), text, 'label', { max_w = math.max(8, w) })
end

local function draw_preview(ui, name, cat, pw, ph)
    local imgui, t, S = ui.imgui, ui.t, ui.settings
    -- 枠は子窓の外接矩形（余白の外側）に合わせ、中身は WindowPadding の内側から始める
    local wx, wy, ww, wh = win_rect(imgui, pw, ph)
    local dl = dl_of(imgui)
    sf.frame(dl, wx, wy, wx + ww, wy + wh, {
        cut = 8, fill_a = 0.10, line_a = 0.80, line = theme.u32('sf_cyan', 0.80),
        brackets = false, glow = 0, thick = 1.3, band = false,
    })
    local x, y = sf.xy(pcall(imgui.GetCursorScreenPos))
    x, y = x or (wx + PREV_PAD), y or (wy + PREV_PAD)
    local cw, ch = avail(imgui)
    cw = math.max(40, cw or ((pw or ww) - PREV_PAD * 2) or 80)
    ch = math.max(20, ch or ((ph or wh) - PREV_PAD * 2) or 40)
    heading_font(ui, 'settings', true)
    local _, hh = sf.add_heading(imgui, x, y, theme.u32('sf_cyan', 1.0), 'PREVIEW', 'label', { max_w = cw })
    heading_font(ui, 'settings', false)
    local title_block = math.max(22, (tonumber(hh) or 18) + 8)
    local cx, cy = x, y + title_block
    sf.set_cursor(imgui, cx, cy)
    local prev_w = panel_inner_w
    panel_inner_w = math.max(40, cw - 4)
    local wrapped = false
    if imgui.GetCursorPosX and imgui.PushTextWrapPos then
        local okx, px = pcall(imgui.GetCursorPosX)
        px = okx and tonumber(px) or nil
        if px then wrapped = pcall(imgui.PushTextWrapPos, px + panel_inner_w) end
    end

    if cat == 'look' then
        heading_font(ui, 'settings', true)
        local _, lh = sf.add_heading(imgui, cx, cy, theme.u32('heading', 1), 'ASTERTRAIL', 'title', { max_w = panel_inner_w })
        heading_font(ui, 'settings', false)
        -- 見出しの下へ進めてから説明を出す（同じ位置に重ねない）
        local ty = cy + (tonumber(lh) or 22) + 8
        sf.set_cursor(imgui, cx, ty)
        help(ui, tkey(ui, 'sf.set.preview_look', '文字サイズと背景の濃さの見本'))
        help(ui, string.format('%d%%', math.floor((S.font_scale or 1) * 100 + 0.5)))
    elseif cat == 'layout' then
        pcall(function ()
            dl:AddRect({ cx, cy + 10 }, { cx + cw * 0.55, cy + 70 }, theme.u32('sf_cyan', 0.85), 0, 0, 1.4)
            dl:AddRect({ cx + cw * 0.48, cy + 40 }, { cx + cw - 4, math.max(cy + 80, cy + ch - 16) }, theme.u32('sf_cyan', 0.55), 0, 0, 1.2)
        end)
        help(ui, S.layout_locked and tkey(ui, 'sf.set.preview_locked', '窓の位置は固定されています')
            or tkey(ui, 'sf.set.preview_unlocked', '窓はドラッグして動かせます'))
    elseif cat == 'tracker' then
        help(ui, (S.tracker.view == 'tabs') and 'TAB  ·  TAB  ·  TAB' or tkey(ui, 'sf.set.preview_tracker_list', 'ピン留めしたクエストの一覧'))
        if S.tracker.show_time_weather then help(ui, '12:00  晴れ') end
        if S.tracker.show_items then help(ui, tkey(ui, 'sf.set.preview_need', '必要品アイコン')) end
        if S.items and S.items.show_possession then help(ui, '0/1') end
    elseif cat == 'map' then
        pcall(function ()
            dl:AddRect({ cx, cy }, { cx + math.max(8, cw), cy + math.min(ch - 8, 140) }, theme.u32('sf_cyan', 0.5), 0, 0, 1.2)
            local mx, my = cx + cw * 0.5, cy + 50
            dl:AddCircle({ mx, my }, 6, theme.u32('sf_amber', 1), 10, 1.6)
        end)
        if not (S.map and S.map.enabled) then
            help(ui, tkey(ui, 'sf.set.preview_map_off', '地図を出すがオフです'))
        end
    elseif cat == 'marks' then
        pcall(function ()
            dl:AddCircle({ cx + 10, cy + 10 }, 6, theme.u32('npc', 1), 10, 1.5)
        end)
        sf.set_cursor(imgui, cx + 22, cy)
        theme.TextColored(imgui, theme.col('item'), 'NPC')
        sf.set_cursor(imgui, cx, cy + 22)
        theme.TextColored(imgui, theme.col('obj'), '???')
        help(ui, tkey(ui, 'sf.set.preview_marks', 'アイコンと名前の見本'))
    elseif cat == 'notify' then
        if button(ui, name, 'n_popup_try', t('settings.popup_try_accept'), { section = SEC, row = 'n_popup_try' }) then
            if ui.popup_preview then ui.popup_preview('accept') end
        end
        if button(ui, name, 'n_popup_try2', t('settings.popup_try_complete'), { section = SEC, row = 'n_popup_try' }) then
            if ui.popup_preview then ui.popup_preview('complete') end
        end
        help(ui, t('settings.popup_try_note'))
    elseif cat == 'input' then
        help(ui, tkey(ui, 'sf.set.preview_input', 'ショートカットとパッドの割り当て'))
    elseif cat == 'save' then
        help(ui, t('settings.layouts'))
        help(ui, t('about.version', { v = ui.addon_version, d = (ui.data and ui.data.version) or '?' }))
    end
    if wrapped and imgui.PopTextWrapPos then pcall(imgui.PopTextWrapPos) end
    panel_inner_w = prev_w
    -- 子窓の高さは呼び出し側で残りに合わせてあり、ここからはみ出す Dummy は置かない（0.1.276〜）
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
            sf.frame(dl, x, y1, x + nw - 4, y1 + row_h - 4, {
                cut = 4, fill_a = 0.40, line_a = 0.95, line = theme.u32('sf_cyan', 1.0),
                brackets = false, glow = 0, thick = 1.3, band = false,
            })
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

    local cat = cat_key(settings_ui.current_tab())
    if settings_ui.current_tab() ~= cat then settings_ui.select_tab(cat) end

    local aw, ah = avail(imgui)
    aw, ah = aw or 800, ah or 500
    local hx, hy = sf.xy(pcall(imgui.GetCursorScreenPos))
    hx, hy = hx or 0, hy or 0

    -- ヘッダー：ASTERTRAIL  SETTINGS
    heading_font(ui, name, true)
    local logo = 'ASTERTRAIL'
    local sub = 'SETTINGS'
    local lw = select(1, sf.measure_heading(imgui, logo, 'title')) or 120
    sf.add_heading(imgui, hx + 4, hy + 2, theme.u32('heading', 1.0), logo, 'title')
    sf.add_heading(imgui, hx + 4 + lw + 16, hy + 2, theme.u32('sf_cyan', 1.0), sub, 'title')
    heading_font(ui, name, false)
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
    local prev_w = 0
    if (rem_w or aw) >= 700 then prev_w = math.max(180, math.min(250, math.floor((rem_w or aw) * 0.28)))
    elseif (rem_w or aw) >= 580 then prev_w = 170 end
    local center_w = math.max(200, (rem_w or aw) - nav_w - gap - (prev_w > 0 and (prev_w + gap) or 0) - 4)
    local cols = (center_w >= 440) and 2 or 1

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
    pack_panels(ui, name, specs, select(1, avail(imgui)) or center_w, cols)
    st = form_cat[cat] or st
    if (st.measured or 0) > 0 then st.used = st.measured end
    form = nil
    end_pane(ui, ok_mid, var_mid)

    if prev_w > 0 then
        imgui.SameLine(0, gap)
        -- プレビュー：残り高さぴったり、NoScrollbar / NoScrollWithMouse、内側余白は枠の内側
        local ok_pr, var_pr = begin_pane(ui, '##astertrail_sf_set_prev', prev_w, mid_h, no_scroll_flags(), { PREV_PAD, PREV_PAD })
        local pw_in, ph_in = avail(imgui)
        draw_preview(ui, name, cat, pw_in or prev_w, ph_in or mid_h)
        end_pane(ui, ok_pr, var_pr)
    elseif cat == 'notify' then
        -- 狭いときはプレビュー代わりに試すボタンを下へ
        if button(ui, name, 'n_popup_try', t('settings.popup_try_accept'), { section = SEC, row = 'n_popup_try' }) then
            if ui.popup_preview then ui.popup_preview('accept') end
        end
        W.same(ui)
        if button(ui, name, 'n_popup_try2', t('settings.popup_try_complete'), { section = SEC, row = 'n_popup_try' }) then
            if ui.popup_preview then ui.popup_preview('complete') end
        end
    end

    -- フッタ
    local fy = hy + header_h + mid_h + 4
    sf.set_cursor(imgui, hx, fy)
    local ver = t('about.version', { v = ui.addon_version or '?', d = (ui.data and ui.data.version) or '?' })
    local hint = tkey(ui, 'sf.set.footer_hint', 'クリックで選ぶ　　Esc で閉じる')
    local close_lab = tkey(ui, 'sf.set.back', '戻る')
    local fw = select(1, avail(imgui)) or 200
    local ver_w = tonumber(select(1, theme.measure_text(imgui, ver))) or 0
    local hint_w = tonumber(select(1, theme.measure_text(imgui, hint))) or 0
    local btn_w = (tonumber(select(1, theme.measure_text(imgui, close_lab))) or 40) + 24
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
