--[[
  Astertrail - 新しい版のダウンロードと更新のお知らせ（0.1.282〜）
  クラシック／YunaUI は従来のガラス、SF は sf.draw_popup（window の glass）。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local theme = require('src.ui.theme')
local sf = require('src.ui.sf_style')
local CT = require('src.ui.colored_text')

local update_popup = {}

local function status_text(ui, job)
    local t = ui.t
    local st = job and job.status or 'idle'
    -- 0.1.297〜：前のバージョンに戻す
    if job and job.kind == 'rollback' then
        if st == 'confirm' then return t('update.rollback_body', { v = job.version or '?', cur = job.current or '?' }) end
        if st == 'verify' then return t('update.verifying') end
        if st == 'reload' then return t('update.reloading') end
        if st == 'done' then return t('update.rolled_back', { v = job.version or '?' }) end
        if st == 'failed' then return t('update.err_rollback') end
        return ''
    end
    if st == 'offer' then
        if job.zip_url then
            return t('update.body', { v = job.version or '?', cur = job.current or '?' })
        end
        return t('update.no_zip', { v = job.version or '?' })
    end
    if st == 'download' then return t('update.downloading') end
    if st == 'verify' then return t('update.verifying') end
    if st == 'extract' then return t('update.extracting') end
    if st == 'swap' then return t('update.swapping') end
    if st == 'reload' then return t('update.reloading') end
    if st == 'done' then return t('update.done', { v = job.version or '?' }) end
    if st == 'failed' then
        local key = 'update.err_generic'
        local e = job.error
        if e == 'network' then key = 'update.err_network'
        elseif e == 'hash' then key = 'update.err_hash'
        elseif e == 'extract' then key = 'update.err_extract'
        elseif e == 'swap' then key = 'update.err_swap'
        elseif e == 'https' then key = 'update.err_https'
        elseif e == 'temp' then key = 'update.err_temp'
        elseif e == 'no_zip' then key = 'update.no_zip'
        elseif e == 'no_sha' then key = 'update.err_no_sha'
        elseif e == 'backup' then key = 'update.err_backup'
        elseif e == 'rollback' then key = 'update.err_rollback'
        elseif type(e) == 'string' and e ~= '' then
            return t('update.err_generic') .. ' (' .. e .. ')'
        end
        return t(key, { v = job.version or '?' })
    end
    return ''
end

function update_popup.visible(ui)
    local job = ui.state and ui.state.update
    if not job then return false end
    local st = job.status
    return st == 'confirm' or st == 'offer' or st == 'download' or st == 'verify' or st == 'extract'
        or st == 'swap' or st == 'reload' or st == 'done' or st == 'failed'
end

function update_popup.draw(ui)
    if not update_popup.visible(ui) then return end
    local job = ui.state.update
    local imgui, t = ui.imgui, ui.t
    local name = 'update'
    local drawing = window.begin(ui, name, {
        title = 'update', no_title = true, no_focus = true, operable = false,
        glass = true, glass_kind = 'accept', bg_alpha = 0.42,
    })
    if drawing then
        -- SF：お知らせと同じ固定の本文幅（560）で中央。クラシック：従来どおり 520 と残り幅（0.1.291〜）
        local is_sf = theme.is_sf and theme.is_sf()
        local iw = is_sf and (sf.POPUP_INNER_W or 560) or nil
        if is_sf then
            sf.reserve_popup_inner(imgui, iw)
        elseif imgui.Dummy then
            pcall(imgui.Dummy, { 520, 0 })
        end
        local base = window.font_scale(ui, name)
        if window.set_font then
            window.set_font(ui, base * 1.20, { heading = true, bold = true })
        end
        local title = (job.kind == 'rollback') and t('update.rollback_title') or t('update.title')
        if is_sf then
            sf.heading_line(ui, title, theme.u32('sf_cyan', 1.0), 'title', { align = 'center', max_w = iw })
        else
            CT.wrapped(ui, title, 'heading', 'center')
        end
        if window.set_font then window.set_font(ui, base * 1.0, {}) end
        local body = status_text(ui, job)
        if body and body ~= '' then
            imgui.Dummy({ 1, 8 })
            CT.wrapped(ui, body, 'text', 'center', iw)
        end
        local st = job.status
        local busy = (st == 'download' or st == 'verify' or st == 'extract' or st == 'swap' or st == 'reload')
        if not busy then
            imgui.Dummy({ 1, 10 })
            local function bw(lab)
                local w = (tonumber((theme.measure_text(imgui, lab))) or 40) + 28
                return math.max(72, math.min(240, w))
            end
            local function center(width)
                if is_sf then return sf.center_in_popup(imgui, width, iw) end
                local avail = select(1, sf.avail(imgui)) or 520
                local ox = math.max(0, (avail - width) / 2)
                if ox > 0 and imgui.Dummy then
                    pcall(imgui.Dummy, { ox, 0 })
                    if imgui.SameLine then imgui.SameLine(0, 0) end
                end
            end
            local function btn(id, lab)
                if is_sf then
                    return W.astral_popup_button(ui, name, id, lab, { section = 'main', row = 'c', width = bw(lab) })
                end
                return W.button(ui, name, id, lab, { section = 'main', row = 'c' })
            end
            if job.kind == 'rollback' and st == 'confirm' then
                local a, b = t('update.rollback_go'), t('update.rollback_cancel')
                center(bw(a) + 14 + bw(b))
                if btn('upd_rb_go', a) then
                    if ui.start_rollback then ui.start_rollback() end
                end
                imgui.SameLine(0, 14)
                if btn('upd_rb_cancel', b) then
                    if ui.update_later then ui.update_later() end
                end
            elseif st == 'offer' and job.zip_url then
                local a, b = t('update.download'), t('update.later')
                center(bw(a) + 14 + bw(b))
                if btn('upd_go', a) then
                    if ui.start_update then ui.start_update() end
                end
                imgui.SameLine(0, 14)
                if btn('upd_later', b) then
                    if ui.update_later then ui.update_later() end
                end
            elseif st == 'done' then
                local lab = t('update.reload_now')
                center(bw(lab))
                if btn('upd_reload', lab) then
                    if ui.update_reload then ui.update_reload() end
                end
            else
                -- failed or offer without zip
                local lab = t('common.close')
                center(bw(lab))
                if btn('upd_close', lab) then
                    if ui.update_later then ui.update_later() end
                end
            end
        end
    end
    window.finish(ui, name)
end

return update_popup
