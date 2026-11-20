--[[
  Astertrail - 受注・完了のお知らせ（SF 見た目、0.1.280〜）
  クラシック／YunaUI は notices.lua のまま。シアンのガラス枠と角のアクセント、
  英語見出しは Melete、日本語の名前・詳細はメイリオ。完了は金のアクセント。
  出現のスライド／フェードは既存の popup_anim を使い、reduce_motion を尊重する。
  0.1.281〜：見出し・名前・詳細・ボタンを横方向の中央に。枠のネオン暈は sf.draw_popup。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local labels = require('src.ui.labels')
local theme = require('src.ui.theme')
local sf = require('src.ui.sf_style')
local CT = require('src.ui.colored_text')

local notices_sf = {}

local function sf_title_key(q, kind)
    local k = q and q.kind or 'quest'
    if k == 'mission' then
        return (kind == 'complete') and 'popup.sf_title_mission_complete' or 'popup.sf_title_mission_accept'
    end
    if k == 'eminence' or k == 'roe' then
        return (kind == 'complete') and 'popup.sf_title_eminence_complete' or 'popup.sf_title_eminence_accept'
    end
    return (kind == 'complete') and 'popup.sf_title_quest_complete' or 'popup.sf_title_quest_accept'
end

local function btn_w(imgui, lab)
    return (tonumber(select(1, theme.measure_text(imgui, lab))) or 40) + 24
end

local function center_row(imgui, width)
    local aw = select(1, sf.avail(imgui)) or 520
    local ox = math.max(0, ((aw or 0) - (width or 0)) / 2)
    if ox > 0 and imgui.Dummy then
        pcall(imgui.Dummy, { ox, 0 })
        if imgui.SameLine then imgui.SameLine(0, 0) end
    end
end

function notices_sf.draw_popup(ui, now)
    local list = ui.state.popups
    local p = list and list[1]
    if not p or not p.shown_at then return end
    local imgui, t = ui.imgui, ui.t
    local q = ui.data:quest(p.quest)
    if not q then return end
    local name = 'popup'
    local reduce = ui.settings and ui.settings.reduce_motion
    local anim = { a = 1, ox = 0, oy = 0, scale = 1, lock_pos = false }
    if ui.popup_anim then
        local a, oy, sc, locking = ui.popup_anim(p, now, reduce)
        local ws = ui.settings and ui.settings.windows and ui.settings.windows.popup or {}
        anim = { a = a, ox = 0, oy = oy, scale = sc, lock_pos = locking or false, rest_x = ws.x, rest_y = ws.y }
    end
    local drawing = window.begin(ui, name, {
        title = 'popup', no_title = true, no_focus = true, operable = false,
        glass = true, glass_kind = p.kind, bg_alpha = 0.42, anim = anim,
    })
    if drawing then
        if imgui.Dummy then pcall(imgui.Dummy, { 560, 0 }) end
        local base = window.font_scale(ui, name)
        local complete = (p.kind == 'complete')
        -- 英語見出し（Melete）。QUEST ACCEPTED など
        if window.set_font then
            window.set_font(ui, base * 1.20, { heading = true, bold = true })
        end
        sf.heading_line(ui, t(sf_title_key(q, p.kind)),
            theme.u32(complete and 'gold' or 'sf_cyan', 1.0), 'title', { align = 'center' })
        -- 日本語の名前・詳細はメイリオ（Melete にはしない）。横方向の中央（0.1.281〜）
        if window.set_font then window.set_font(ui, base * 1.28, {}) end
        local qname = labels.qname(q)
        if q.mission_no and q.mission_no ~= '' then qname = q.mission_no .. '  ' .. qname end
        CT.wrapped(ui, qname, complete and 'gold' or 'heading', 'center')
        if window.set_font then window.set_font(ui, base * 0.92, {}) end
        local npc = ui.data.start_npc_name and ui.data:start_npc_name(q)
        local place = ui.data.start_place_text and ui.data:start_place_text(q)
        if npc and npc ~= '' then
            CT.wrapped(ui, t('popup.npc', { name = npc }), 'muted', 'center')
        end
        if place and place ~= '' then
            CT.wrapped(ui, t('popup.place', { loc = place }), 'muted', 'center')
        end
        local rewards = labels.rewards_cell(q)
        if rewards and rewards ~= '' then
            CT.wrapped(ui, t('popup.rewards', { text = rewards }), 'muted', 'center')
        end
        if window.set_font then window.set_font(ui, base * 1.0, {}) end
        local closing = p.closing_at ~= nil
        local target = ui.popup_target and ui.popup_target(p)
        if target then
            if p.kind == 'accept' then
                CT.wrapped(ui, t('popup.ask_pin'), 'text', 'center')
            else
                local nq = ui.data:quest(target)
                CT.wrapped(ui, t(nq and nq.kind == 'mission' and 'popup.ask_next_mission' or 'popup.ask_next_quest',
                    { name = nq and labels.qname(nq) or '' }), 'text', 'center')
            end
            local yes, no = t('popup.pin_yes'), t('popup.pin_no')
            if imgui.Dummy then pcall(imgui.Dummy, { 1, 6 }) end
            local gap = 14
            center_row(imgui, btn_w(imgui, yes) + gap + btn_w(imgui, no))
            if W.button(ui, name, 'pin_yes', yes, { section = 'main', row = 'c' }) then
                if not closing then ui.popup_choose(true) end
            end
            imgui.SameLine(0, gap)
            if W.button(ui, name, 'pin_no', no, { section = 'main', row = 'c' }) then
                if not closing then ui.popup_choose(false) end
            end
        else
            local close = t('common.close')
            if imgui.Dummy then pcall(imgui.Dummy, { 1, 6 }) end
            center_row(imgui, btn_w(imgui, close))
            if W.button(ui, name, 'dismiss', close, { section = 'main', row = 'c' }) then
                if not closing then ui.popup_choose(false) end
            end
        end
        if #list > 1 then
            CT.wrapped(ui, t('popup.more', { n = tostring(#list - 1) }), 'muted', 'center')
        end
        p.hovered = imgui.IsWindowHovered() and not closing
    end
    window.finish(ui, name)
end

return notices_sf
