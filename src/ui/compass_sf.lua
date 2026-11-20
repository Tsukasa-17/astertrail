--[[
  Astertrail - コンパスの窓（SF 見た目、0.1.283〜）
  クラシック／YunaUI の配置は compass.lua のまま。見た目が sf のときだけ呼ばれる。
  地図・トラッカーと同じ角切りの枠、シアンの見出し、琥珀色のクエスト名、NPC 色の依頼者。
  右上の × は見出し行に置き、本文の子窓は見出しの下から始める。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local theme = require('src.ui.theme')
local labels = require('src.ui.labels')
local sf = require('src.ui.sf_style')
local title_close = require('src.ui.title_close')
local compass_core = require('src.core.compass')

local compass_sf = {}

-- 行カードの高さ（クエストごと）。前フレームの実測を次の塗りの高さに使う。
local row_h = {}

local function font(ui, mul, heading)
    local base = window.font_scale(ui, 'compass')
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

function compass_sf.draw(ui)
    local imgui, t = ui.imgui, ui.t
    local name = 'compass'
    local open = { true }
    local rows = ui.state.compass or {}
    local pl = ui.player
    local zone = pl and pl.zone_id and ui.data:zone_name(pl.zone_id) or nil
    local title = t('compass.title', { zone = zone or '?' })
    local drawing = window.begin(ui, name, {
        title = title, open = open, operable = true, no_focus = true,
        no_title = true, sf_frame = true, fixed_top = true,
    })
    if drawing then
        local hx, hy = title_close.header_origin(imgui)
        hx, hy = hx or 0, hy or 0
        sf.set_cursor(imgui, hx, hy)
        font(ui, 0.92, true)
        sf.add_heading(imgui, hx, hy, theme.u32('sf_cyan', 1.0), 'COMPASS', 'label')
        local hw = select(1, sf.measure_heading(imgui, 'COMPASS', 'label')) or 90
        font(ui, 0.80, false)
        if zone and zone ~= '' then
            sf.set_cursor(imgui, hx + hw + 10, hy + 2)
            theme.TextColored(imgui, theme.col('muted'), zone)
        end
        font(ui, 1, false)
        if title_close.draw(ui, name, {
            tooltip = t('compass.hide'), origin_x = hx, origin_y = hy,
        }) then
            open[1] = false
        end
        local head_h = 28
        sf.set_cursor(imgui, hx, hy + head_h)
        local remain = sf.remain_below(imgui, 4) or select(2, sf.avail(imgui)) or 160
        local ok = pcall(imgui.BeginChild, '##astertrail_sf_compass_body', { 0, math.max(40, remain) }, 0, 0)
        if ok then window.push(ui, 'child') end

        if ui.state.compass == nil then
            W.muted(ui, t('compass.loading'))
        elseif #rows == 0 then
            W.muted(ui, t('compass.empty'))
        end
        local map_on = ui.settings.map and ui.settings.map.enabled ~= false and ui.open_map
        for _, r in ipairs(rows) do
            local q = ui.data:quest(r.qid)
            if q then
                local key = tostring(r.qid)
                local x0, y0 = sf.xy(pcall(imgui.GetCursorScreenPos))
                local aw = select(1, sf.avail(imgui)) or 200
                local right = x0 and (x0 + math.max(80, aw) - 2) or math.max(80, aw)
                local fs = 16
                if imgui.GetFontSize then
                    local okf, v = pcall(imgui.GetFontSize)
                    if okf then fs = tonumber(v) or fs end
                end
                -- 内側余白。枠線が文字を横切らないよう、両行のまわりに取る（0.1.285〜）
                local pad = math.max(8, math.floor(fs * 0.5 + 0.5))
                local gap = math.max(2, math.floor(fs * 0.15 + 0.5))
                local min_h = pad + math.ceil(fs * 1.10) + gap + math.ceil(fs * 0.92) + pad
                -- 塗りの高さ。0.1.284 までは常に 52px の枠を先に描き、依頼者・距離の行を線が横切った。
                -- 先に塗るのは文字の下に地を敷くため。線は測ってから一度だけ描く。
                local guessed = row_h[key] or min_h
                local dl = dl_of(imgui)
                if x0 and y0 then
                    sf.fill_cut(dl, x0, y0, right, y0 + guessed, 4, theme.u32('bg', 0.16))
                    sf.set_cursor(imgui, x0 + pad, y0 + pad)
                end
                local content_bottom = y0 and (y0 + pad) or 0
                local function bump_bottom()
                    local _, y2 = sf.xy(pcall(imgui.GetItemRectMax))
                    local _, cy2 = sf.xy(pcall(imgui.GetCursorScreenPos))
                    if y2 then content_bottom = math.max(content_bottom, y2) end
                    if cy2 then content_bottom = math.max(content_bottom, cy2) end
                end
                local nm = labels.qname(q)
                local open_q = false
                font(ui, 1.10, false)
                W.line_pass(imgui, function ()
                    if W.link(ui, name, 'q_' .. r.qid, nm, {
                        color = r.icon == 'repeat' and 'ic_repeat' or 'sf_amber',
                        section = 'list', row = r.qid .. '_name', bold = true,
                    }) then
                        open_q = true
                    end
                    if #r.reasons > 0 then
                        imgui.SameLine(0, 2)
                        theme.TextColored(imgui, theme.col('warn'), t('book.cond_mark'))
                        if imgui.IsItemHovered() then
                            local tip = {}
                            for _, x in ipairs(r.reasons) do
                                tip[#tip + 1] = t('book.lock_reason', { text = x.text_ja or '' })
                            end
                            imgui.SetTooltip(table.concat(tip, '\n'))
                        end
                    end
                end)
                bump_bottom()
                font(ui, 1, false)
                if open_q then ui.open_detail_solo(r.qid, 'compass') end
                local sl = ui.data:start_location(q)
                local can = map_on and sl and sl.zone_id and r.npc
                local open_m = false
                font(ui, 0.92, false)
                if x0 and y0 then
                    local _, cy = sf.xy(pcall(imgui.GetCursorScreenPos))
                    sf.set_cursor(imgui, x0 + pad, math.max(cy or (y0 + pad), content_bottom + gap))
                end
                W.line_pass(imgui, function ()
                    if can then
                        if W.link(ui, name, 'npc_' .. r.qid, r.npc, {
                            color = 'npc', tooltip = t('map.view'),
                            section = 'list', row = r.qid .. '_npc',
                        }) then
                            open_m = true
                        end
                    else
                        theme.TextColored(imgui, theme.col('npc'), r.npc or t('compass.npc_unknown'))
                    end
                    imgui.SameLine()
                    theme.TextColored(imgui, theme.col(r.dist and 'text' or 'muted'), compass_core.dist_text(t, r))
                end)
                bump_bottom()
                font(ui, 1, false)
                if open_m then ui.open_map(r.qid, nil, sl) end
                -- 枠の高さは両行と下の余白に合わせる。先に描いた 52px の線は出さない。
                local h = math.max(min_h, (content_bottom - (y0 or 0)) + pad)
                row_h[key] = h
                if x0 and y0 then
                    sf.frame(dl, x0, y0, right, y0 + h, {
                        cut = 4, fill_a = 0, line_a = 0.45, line = theme.u32('sf_cyan', 0.40),
                        brackets = false, glow = 0, thick = 1.0, band = false,
                    })
                    sf.set_cursor(imgui, x0, y0 + h)
                end
                if imgui.Dummy then pcall(imgui.Dummy, { math.max(80, aw) - 2, 6 }) end
            end
        end
        if ok then window.pop(ui, 'child') end
    end
    window.finish(ui, name, nil)
    if not open[1] and ui.set_compass_visible then ui.set_compass_visible(false) end
end

return compass_sf
