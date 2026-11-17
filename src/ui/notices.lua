--[[
  Astertrail - ログイン時の続き（エリア入場時の表示は 0.1.173 でなくした）と、受注・完了のお知らせ（0.1.183〜、t295）
  自動で出るので、遊んでいるときはキーは奪わない（マウスのクリックはできる）。
  パッドは出ているあいだ使える（0.1.197〜）：十字キーでピンのボタンを選び、決定で押す、キャンセルで閉じる（0.1.226〜：左スティックでは動かさない）。
  閉じたあと（ボタン・キャンセル・時間切れ）は入力を全部離す（ゲームのボタンが押しっぱなしにならないように）。
  キーで操作するときは /astertrail notice（お知らせが先）か、ほかの窓を操作しているとき。閉じたら前の窓へ戻る。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local util = require('src.lib.util')
local CT = require('src.ui.colored_text')
local labels = require('src.ui.labels')
local theme = require('src.ui.theme')

local notices = {}

function notices.draw_resume(ui, now)
    local r = ui.state.resume
    if not r then return end
    if now >= r.hide_at and not r.hovered then ui.state.resume = nil; return end
    local imgui, t = ui.imgui, ui.t
    local q = ui.data:quest(r.quest)
    if not q then ui.state.resume = nil; return end
    local name = 'resume'
    local drawing = window.begin(ui, name, { title = 'resume', no_title = true, no_focus = true, operable = false })
    if drawing then
        W.muted(ui, t('resume.title'))
        local line, step = ui.progress:next_line(r.quest)
        local terms = CT.step_terms(ui.data, step)
        if W.row(ui, name, 'go', { { text = labels.qname(q), color = 'accent' }, { text = t('tracker.next', { text = line or '' }), terms = terms } },
            { section = 'main', row = 'go' }) then
            ui.state.resume = nil
            if ui.progress:is_pinned(r.quest) then
                ui.show_tracker(r.quest)
            else
                ui.open_detail(r.quest, 'resume')
            end
        end
        r.hovered = imgui.IsWindowHovered()
        if W.button(ui, name, 'dismiss', t('common.close'), { section = 'main', row = 'x', small = true }) then
            ui.state.resume = nil
        end
    end
    window.finish(ui, name)
end

-- 受注・完了のお知らせ（先頭の 1 件だけ。ほかは待つ）。選ぶとふわっと消える。マウスを乗せている間・操作中は消えない
-- 0.1.197〜：大きな見出し（影・輪郭・太字）、金色の名前、飾り線、半透明の地、ふわっと出る
function notices.draw_popup(ui, now)
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
        -- 見出しの無い大きな窓：最小の幅を確保する
        if imgui.Dummy then pcall(imgui.Dummy, { 560, 0 }) end
        local base = window.font_scale(ui, name)
        local function font(s)
            if window.set_font then window.set_font(ui, base * (s or 1)) end
        end
        local is_m = (q.kind == 'mission')
        local title_key = (p.kind == 'accept')
            and (is_m and 'popup.title_mission_accept' or 'popup.title_quest_accept')
            or (is_m and 'popup.title_mission_complete' or 'popup.title_quest_complete')
        local complete = (p.kind == 'complete')
        theme.popup_divider(ui, { col = complete and 'gold' or 'good' })
        font(1.85)
        theme.popup_text(ui, t(title_key), {
            col = complete and 'gold' or 'good', bold = true, outline = true, shadow = true,
            glow = complete, shimmer = complete, outline_px = 1.5, pad = 4,
        })
        font(1.0)
        theme.popup_divider(ui, { col = complete and 'gold' or 'good' })
        font(1.45)
        local qname = labels.qname(q)
        if q.mission_no and q.mission_no ~= '' then qname = q.mission_no .. '  ' .. qname end
        theme.popup_text(ui, qname, {
            col = 'gold', bold = true, outline = true, shadow = true,
            glow = complete, shimmer = complete, pad = 6, wrap = 520,
        })
        font(0.92)
        local npc = ui.data.start_npc_name and ui.data:start_npc_name(q)
        local place = ui.data.start_place_text and ui.data:start_place_text(q)
        if npc and npc ~= '' then
            theme.popup_text(ui, t('popup.npc', { name = npc }), {
                col = 'muted', bold = false, outline = false, shadow = true, pad = 0,
            })
        end
        if place and place ~= '' then
            theme.popup_text(ui, t('popup.place', { loc = place }), {
                col = 'muted', bold = false, outline = false, shadow = true, pad = 0,
            })
        end
        local rewards = labels.rewards_cell(q)
        if rewards and rewards ~= '' then
            theme.popup_text(ui, t('popup.rewards', { text = rewards }), {
                col = 'muted', bold = false, outline = false, shadow = true, pad = 2, wrap = 520,
            })
        end
        font(1.0)
        theme.popup_divider(ui, { col = complete and 'gold' or 'good' })
        local closing = p.closing_at ~= nil
        local target = ui.popup_target and ui.popup_target(p)
        if target then
            if p.kind == 'accept' then
                theme.popup_text(ui, t('popup.ask_pin'), {
                    col = 'text', bold = false, outline = false, shadow = true, pad = 4,
                })
            else
                local nq = ui.data:quest(target)
                theme.popup_text(ui, t(nq and nq.kind == 'mission' and 'popup.ask_next_mission' or 'popup.ask_next_quest',
                    { name = nq and labels.qname(nq) or '' }), {
                    col = 'text', bold = false, outline = false, shadow = true, pad = 4, wrap = 520,
                })
            end
            -- ボタンは横方向の中央（0.1.198〜）。パッド・キーの左右移動はそのまま
            local yes, no = t('popup.pin_yes'), t('popup.pin_no')
            local w1, h1 = theme.popup_button_size(imgui, yes)
            local w2, h2 = theme.popup_button_size(imgui, no)
            local bw, bh, gap = math.max(w1, w2), math.max(h1, h2), 14
            local aw = 520
            if imgui.GetContentRegionAvail then
                local ok, a = pcall(imgui.GetContentRegionAvail)
                if ok then
                    if type(a) == 'table' then a = a.x or a[1] end
                    if tonumber(a) then aw = tonumber(a) end
                end
            end
            local ox = math.max(0, (aw - (bw * 2 + gap)) / 2)
            if imgui.Dummy then pcall(imgui.Dummy, { ox, 0 }) end
            if imgui.SameLine then imgui.SameLine(0, 0) end
            if W.popup_button(ui, name, 'pin_yes', yes, {
                section = 'main', row = 'c', width = bw, height = bh, kind = p.kind,
            }) then
                if not closing then ui.popup_choose(true) end
            end
            imgui.SameLine(0, gap)
            if W.popup_button(ui, name, 'pin_no', no, {
                section = 'main', row = 'c', width = bw, height = bh, kind = p.kind,
            }) then
                if not closing then ui.popup_choose(false) end
            end
        else
            local close = t('common.close')
            local bw, bh = theme.popup_button_size(imgui, close)
            local aw = 520
            if imgui.GetContentRegionAvail then
                local ok, a = pcall(imgui.GetContentRegionAvail)
                if ok then
                    if type(a) == 'table' then a = a.x or a[1] end
                    if tonumber(a) then aw = tonumber(a) end
                end
            end
            local ox = math.max(0, (aw - bw) / 2)
            if imgui.Dummy then pcall(imgui.Dummy, { ox, 0 }) end
            if imgui.SameLine then imgui.SameLine(0, 0) end
            if W.popup_button(ui, name, 'dismiss', close, {
                section = 'main', row = 'c', width = bw, height = bh, kind = p.kind,
            }) then
                if not closing then ui.popup_choose(false) end
            end
        end
        if #list > 1 then W.muted(ui, t('popup.more', { n = tostring(#list - 1) })) end
        p.hovered = imgui.IsWindowHovered() and not closing
    end
    window.finish(ui, name)
end

return notices
