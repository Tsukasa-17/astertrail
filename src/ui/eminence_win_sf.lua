--[[
  Astertrail - 独立したエミネンスの窓（SF 見た目、0.1.275〜）
  本の EMINENCE タブ（eminence_sf.lua）とは別。クラシック／YunaUI の窓は eminence.draw のまま。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local theme = require('src.ui.theme')
local sf = require('src.ui.sf_style')
local eminence = require('src.ui.eminence')
local roe = require('src.core.roe')
local CT = require('src.ui.colored_text')
local title_close = require('src.ui.title_close')

local M = {}

-- 行カードの内側余白と、前フレームで測った高さ（字体が大きくても枠に収める）（0.1.278〜）
local ROW_PAD = 8
local row_h = {}

local function font(ui, win, mul, heading)
    local base = window.font_scale(ui, win)
    if heading then
        window.set_font(ui, base * (mul or 1), { heading = true, bold = true })
    else
        window.set_font(ui, base * (mul or 1), {})
    end
end

local function dl_of(imgui)
    local ok, dl = pcall(imgui.GetWindowDrawList)
    if ok then return dl end
    return nil
end

local function target_of(ui, id)
    local db
    if ui.roe_db then
        local ok, d = pcall(ui.roe_db)
        if ok then db = d end
    end
    local q = db and db.quests and db.quests[id]
    return q and q.target or nil
end

function M.draw(ui)
    local imgui, t, S = ui.imgui, ui.t, ui.settings
    local E = S.eminence
    local name = 'eminence'
    local open = { true }
    local r = ui.state.roe or {}
    local n_act = 0
    for _, e in ipairs(r.active or {}) do if not e.timed then n_act = n_act + 1 end end
    local title = t('roe.window_title', { n = r.active and tostring(n_act) or '-', max = tostring(roe.MAX_ACTIVE) })
    local drawing = window.begin(ui, name, {
        title = title, open = open, operable = false, no_focus = true, fixed_top = true,
        no_title = true, sf_frame = true,
    })
    if drawing then
        local count = (r.active and tostring(n_act) or '-') .. '/' .. tostring(roe.MAX_ACTIVE)
        font(ui, name, 0.92, true)
        local hx, hy = title_close.header_origin(imgui)
        hx, hy = hx or 0, hy or 0
        sf.set_cursor(imgui, hx, hy)
        sf.add_heading(imgui, hx, hy, theme.u32('sf_cyan', 1.0), 'EMINENCE', 'label')
        local hw = select(1, sf.measure_heading(imgui, 'EMINENCE', 'label')) or 90
        font(ui, name, 0.80, false)
        do
            local cx = hx + hw + 10
            local limit = title_close.right_limit(imgui, '×')
            local cw = select(1, theme.measure_text(imgui, count)) or 32
            if not limit or cx + cw <= limit then
                sf.set_cursor(imgui, cx, hy + 2)
                theme.TextColored(imgui, theme.col('muted'), count)
            end
        end
        font(ui, name, 1, false)
        -- 右上の × は見出し行の最後に出す。本文の子窓は Dummy の下から（0.1.283〜）
        if title_close.draw(ui, name, {
            tooltip = t('roe.hide'), origin_x = hx, origin_y = hy,
        }) then
            open[1] = false
            if ui.set_eminence_visible then ui.set_eminence_visible(false) end
        end
        -- ピン留めチップ
        imgui.Dummy({ 1, 22 })
        local lab = t('roe.pin_only')
        if W.button(ui, name, 'collapse', (E.collapsed and '◆ ' or '◇ ') .. lab, {
            section = 'head', row = 'h', small = true, no_focus = true, tooltip = t('roe.pin_only_tip'),
        }) then
            E.collapsed = not E.collapsed
            ui.mark_settings_dirty()
        end
        local _, avail_h = imgui.GetContentRegionAvail()
        if type(avail_h) == 'table' then avail_h = avail_h.y or avail_h[2] end
        imgui.BeginChild('##astertrail_sf_em_win', { 0, math.max(40, (tonumber(avail_h) or 200) - 2) }, 0, 0)
        window.push(ui, 'child')
        window.set_font(ui, window.font_scale(ui, name))
        local rows, why = eminence.window_rows(ui)
        if why then W.muted(ui, t('roe.empty.' .. why)) end
        for _, e in ipairs(rows) do
            local key = tostring(e.id)
            local pinned = E.pins[key] == true
            local faved = eminence.is_faved(ui, e.id)
            local x0, y0 = sf.xy(pcall(imgui.GetCursorScreenPos))
            local aw = select(1, sf.avail(imgui)) or 200
            local fs = 16
            if imgui.GetFontSize then
                local okf, v = pcall(imgui.GetFontSize)
                if okf then fs = tonumber(v) or fs end
            end
            local pad = math.max(ROW_PAD, math.floor(fs * 0.5 + 0.5))
            local right = x0 and (x0 + math.max(80, aw) - 2) or (math.max(80, aw) - 2)
            local guessed = row_h[key] or (pad * 2 + math.max(36, fs * 2 + 10))
            -- 行の枠（高さは中身に合わせる。前フレームの値で塗り、違えば枠線だけ描き直す）
            if x0 and y0 then
                sf.frame(dl_of(imgui), x0, y0, right, y0 + guessed, {
                    cut = 4, fill_a = 0.16, line_a = 0.45, line = theme.u32('sf_cyan', 0.40),
                    brackets = false, glow = 0, thick = 1.0, band = false,
                })
            end
            -- ☆ / ❤ は枠の左端に付けず、内側余白から始める
            if x0 and y0 then sf.set_cursor(imgui, x0 + pad, y0 + pad) end
            if W.button(ui, name, 'pin_' .. key, pinned and '★' or '☆', {
                section = 'list', row = key, small = true, no_focus = true,
                tooltip = t(pinned and 'roe.unpin' or 'roe.pin'),
            }) then
                eminence.toggle_pin(ui, e.id)
            end
            imgui.SameLine(0, 4)
            if W.button(ui, name, 'fav_' .. key, faved and '❤' or '♡', {
                section = 'list', row = key, small = true, no_focus = true,
                tooltip = t(faved and 'roe.unfav' or 'roe.fav'),
            }) then
                eminence.toggle_fav(ui, e.id)
            end
            imgui.SameLine(0, 6)
            local nm = eminence.name(ui, e.id)
            if e.timed then nm = t('roe.timed_mark') .. nm end
            local tgt = target_of(ui, e.id)
            local prog = tonumber(e.progress) or 0
            local done = tgt and prog >= tgt
            local nx, ny = sf.xy(pcall(imgui.GetCursorScreenPos))
            local name_w = math.max(40, (right - pad) - (nx or (x0 and (x0 + pad) or 0)))
            if CT and CT.wrapped then
                CT.wrapped(ui, nm, done and 'ic_done' or 'heading', nil, name_w)
            else
                theme.TextColored(imgui, theme.col(done and 'ic_done' or 'heading'), nm)
            end
            if imgui.IsItemHovered() then
                local db
                if ui.roe_db then
                    local ok, d = pcall(ui.roe_db)
                    if ok then db = d end
                end
                local q = db and db.quests and db.quests[e.id]
                if q and q.desc then imgui.SetTooltip(q.desc) end
            end
            -- 進みバーと 14/20（枠の内側。件数はバー行の右寄せ。行クリックでは本を開かない）
            local frac = 0
            if tgt and tgt > 0 then frac = math.max(0, math.min(1, prog / tgt)) end
            if done then frac = 1 end
            local ptxt = eminence.progress_text(ui, e)
            font(ui, name, 0.85, false)
            local cw, ch = theme.measure_text(imgui, ptxt)
            cw, ch = tonumber(cw) or 32, tonumber(ch) or 14
            font(ui, name, 1, false)
            local gapc = 8
            local bar_h = math.max(6, math.floor(ch * 0.45 + 0.5))
            local line_h = math.max(bar_h, ch)
            if x0 and y0 then
                -- 名前の次の行（ウィンドウ左端ではなくカードの内側）
                local _, cy = sf.xy(pcall(imgui.GetCursorScreenPos))
                sf.set_cursor(imgui, x0 + pad, (cy or (y0 + pad)) + 4)
            end
            local bx, by = sf.xy(pcall(imgui.GetCursorScreenPos))
            local inner_w = math.max(40, (right - pad) - (bx or 0))
            local bar_w = math.max(24, inner_w - gapc - cw)
            if bx and by then
                local bar_y = by + math.max(0, (line_h - bar_h) * 0.5)
                sf.bar(dl_of(imgui), bx, bar_y, bar_w, bar_h, frac, {
                    fg = theme.u32(done and 'ic_done' or 'sf_amber', 0.95),
                    bg = theme.u32('sf_cyan', 0.14),
                })
                font(ui, name, 0.85, false)
                -- 件数はバー行の右端
                sf.text_at(imgui, bx + inner_w - cw, by + math.max(0, (line_h - ch) * 0.5), function ()
                    theme.TextColored(imgui, theme.col(done and 'ic_done' or 'sf_amber'), ptxt)
                end)
                font(ui, name, 1, false)
            end
            if imgui.Dummy then pcall(imgui.Dummy, { math.max(8, inner_w), line_h }) end
            local bottom = y0 and (y0 + pad) or 0
            local _, y2 = sf.xy(pcall(imgui.GetItemRectMax))
            local _, cy2 = sf.xy(pcall(imgui.GetCursorScreenPos))
            if y2 then bottom = math.max(bottom, y2) end
            if cy2 then bottom = math.max(bottom, cy2) end
            local h = math.max(pad * 2 + 28, (bottom - (y0 or 0)) + pad)
            row_h[key] = h
            if x0 and y0 and math.abs(h - guessed) > 1 then
                sf.frame(dl_of(imgui), x0, y0, right, y0 + h, {
                    cut = 4, fill_a = 0, line_a = 0.45, line = theme.u32('sf_cyan', 0.40),
                    brackets = false, glow = 0, thick = 1.0, band = false,
                })
            end
            if x0 and y0 then sf.set_cursor(imgui, x0, y0 + h) end
            if imgui.Dummy then pcall(imgui.Dummy, { math.max(80, aw) - 2, 6 }) end
        end
        window.pop(ui, 'child')
    end
    window.finish(ui, name, nil)
    if not open[1] and ui.set_eminence_visible then ui.set_eminence_visible(false) end
end

return M
