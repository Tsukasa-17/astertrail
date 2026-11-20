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
    return st == 'offer' or st == 'download' or st == 'verify' or st == 'extract'
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
        if imgui.Dummy then pcall(imgui.Dummy, { 520, 0 }) end
        local base = window.font_scale(ui, name)
        if window.set_font then
            window.set_font(ui, base * 1.20, { heading = true, bold = true })
        end
        local aw = select(1, sf.avail(imgui)) or 520
        local title = t('update.title')
        if theme.is_sf and theme.is_sf() then
            sf.heading_line(ui, title, theme.u32('sf_cyan', 1.0), 'title', { align = 'center' })
        else
            CT.wrapped(ui, title, 'heading', 'center')
        end
        if window.set_font then window.set_font(ui, base * 1.0, {}) end
        local body = status_text(ui, job)
        if body and body ~= '' then
            imgui.Dummy({ 1, 8 })
            CT.wrapped(ui, body, 'text', 'center')
        end
        local st = job.status
        local busy = (st == 'download' or st == 'verify' or st == 'extract' or st == 'swap' or st == 'reload')
        if not busy then
            imgui.Dummy({ 1, 10 })
            local function bw(lab)
                return (tonumber(select(1, theme.measure_text(imgui, lab))) or 40) + 24
            end
            local function center(width)
                local avail = select(1, sf.avail(imgui)) or 520
                local ox = math.max(0, (avail - width) / 2)
                if ox > 0 and imgui.Dummy then
                    pcall(imgui.Dummy, { ox, 0 })
                    if imgui.SameLine then imgui.SameLine(0, 0) end
                end
            end
            if st == 'offer' and job.zip_url then
                local a, b = t('update.download'), t('update.later')
                center(bw(a) + 14 + bw(b))
                if W.button(ui, name, 'upd_go', a, { section = 'main', row = 'c' }) then
                    if ui.start_update then ui.start_update() end
                end
                imgui.SameLine(0, 14)
                if W.button(ui, name, 'upd_later', b, { section = 'main', row = 'c' }) then
                    if ui.update_later then ui.update_later() end
                end
            elseif st == 'done' then
                local lab = t('update.reload_now')
                center(bw(lab))
                if W.button(ui, name, 'upd_reload', lab, { section = 'main', row = 'c' }) then
                    if ui.update_reload then ui.update_reload() end
                end
            else
                -- failed or offer without zip
                local lab = t('common.close')
                center(bw(lab))
                if W.button(ui, name, 'upd_close', lab, { section = 'main', row = 'c' }) then
                    if ui.update_later then ui.update_later() end
                end
            end
        end
    end
    window.finish(ui, name)
end

return update_popup
