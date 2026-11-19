--[[
  Astertrail - トラッカー（SF 見た目、0.1.253〜）
  クラシック／YunaUI の配置・コントローラー操作は触らない。見た目が sf のときだけ tracker.draw から呼ばれる。
  琥珀色の太字の名前、次にやること一行、区切りのある進みバーと「今/全部」、角のある小さいボタン。
  タブ・手順のリンク・所持・天候・分岐・ピン外しなど、今の機能は残す。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local labels = require('src.ui.labels')
local poss_ui = require('src.ui.possession_ui')
local util = require('src.lib.util')
local CT = require('src.ui.colored_text')
local focus = require('src.ui.focus')
local theme = require('src.ui.theme')
local marks_core = require('src.core.marks')
local ui_marks = require('src.ui.marks')
local sf = require('src.ui.sf_style')
local tracker = require('src.ui.tracker')

local tracker_sf = {}

local function font(ui, mul, bold)
    local base = window.font_scale(ui, 'tracker')
    window.set_font(ui, base * (mul or 1), bold and { bold = true } or nil)
end

local function avail_x(imgui)
    return select(1, sf.avail(imgui)) or 300
end

local function avail_y(imgui)
    return select(2, sf.avail(imgui)) or 200
end

local function style_x(imgui, key, fallback)
    local ok, st = pcall(imgui.GetStyle)
    if ok and st then
        local ok2, v = pcall(function () return st[key] end)
        if ok2 and v ~= nil then
            if type(v) == 'table' then return tonumber(v.x or v[1]) or fallback end
        end
    end
    return fallback
end

local function button_w(imgui, label)
    local w = CT.text_w(imgui, label)
    if not w then return 22 end
    return w + style_x(imgui, 'FramePadding', 4) * 2
end

local function op_btn(ui, name, id, label, opts)
    opts = opts or {}
    local imgui = ui.imgui
    font(ui, 0.9, false)
    local tw, th = theme.measure_text(imgui, label)
    tw, th = (tw or 10) + 12, (th or 14) + 6
    local clicked = sf.hit(imgui, '##sfop_' .. id, tw, th)
    -- 公式の W.button と同じ id でも反応するよう、重ねて置かない。ヒットは InvisibleButton のみ。
    local x1, y1, x2, y2 = sf.item_rect(imgui)
    if x1 then
        local on = not opts.disabled
        sf.frame(imgui.GetWindowDrawList and imgui.GetWindowDrawList(), x1, y1, x2, y2, {
            cut = 4, fill_a = on and 0.36 or 0.14, line_a = on and 0.90 or 0.30,
            brackets = false, glow = false, thick = 1.1,
        })
        sf.add_text(imgui.GetWindowDrawList and imgui.GetWindowDrawList(), x1 + 6, y1 + 3,
            theme.u32(on and 'heading' or 'muted', 1.0), label)
        if sf.snap_after_item then sf.snap_after_item(imgui) end
    end
    if opts.tooltip and imgui.IsItemHovered and imgui.IsItemHovered() and imgui.SetTooltip then
        pcall(imgui.SetTooltip, opts.tooltip)
    end
    font(ui, 1, false)
    if opts.disabled then return false end
    return clicked
end

-- 互換のため、操作ボタンは W.button の id を残す（テストとパッド）。見た目だけ枠を重ねる。
local function ops_button(ui, name, id, label, opts)
    opts = opts or {}
    opts.small = true
    local clicked = W.button(ui, name, id, label, opts)
    local x1, y1, x2, y2 = sf.item_rect(ui.imgui)
    if x1 then
        pcall(function ()
            -- 線はボタンの内側に描き、左端でクリップされないようにする
        sf.stroke_cut(ui.imgui.GetWindowDrawList(), x1, y1, x2, y2, 4, theme.u32('sf_cyan', opts.disabled and 0.25 or 0.75), 1.1)
        end)
    end
    return clicked
end

function tracker_sf.draw(ui)
    local imgui, t, S = ui.imgui, ui.t, ui.settings
    local P, D = ui.progress, ui.data
    local C = theme.C
    local pins = P:pinned_list()
    if #pins == 0 then return end
    local name = 'tracker'
    local st = ui.state
    local operating = st.active == 'tracker'
    focus.set_shows_frame(name, operating)
    local tabs = (S.tracker.view == 'tabs')
    local shown = pins
    if tabs then shown = { tracker.current_tab(ui, pins) } end
    local level, entry = 'all', nil
    if operating then
        local owner, is_entry = tracker.owner_of(focus.current(name), shown)
        if owner and not is_entry then level, entry = 'inside', owner else level = 'entries' end
        if tabs then level, entry = 'inside', shown[1] end
        if owner then st.tracker_last = owner end
    end
    st.tracker_level = (level ~= 'all') and level or nil
    st.tracker_entry = entry
    local title = t('tracker.title', { n = #pins })
    local drawing = window.begin(ui, name, {
        title = title, operable = false, no_focus = true, no_title = true, fixed_top = true, sf_frame = true,
    })
    if drawing then
        local collapsed = S.tracker.collapsed
        local show_close = S.tracker.show_close ~= false

        if tabs then
            font(ui, tracker.SCALE.ops or 0.95, false)
            window.set_font(ui, tracker.tab_font_scale(ui) * (tracker.SCALE.ops or 1.0))
            local sp = style_x(imgui, 'ItemSpacing', 8)
            local tw = 80
            do
                -- タブ幅は今の設定（文字数）に合わせる
                local nch = tracker.tab_chars(S)
                local sample = string.rep('あ', nch)
                tw = (CT.text_w(imgui, sample) or (nch * 12)) + 8
            end
            local close_w = show_close and button_w(imgui, '×') or 0
            local room = avail_x(imgui) - (show_close and (close_w + sp) or 0)
            local n_fit = math.max(1, math.floor((room + sp) / (tw + sp)))
            local arrows = #pins > n_fit
            if arrows then
                n_fit = math.max(1, math.floor((room - 40 + sp) / (tw + sp)))
            end
            local sel = shown[1]
            local si = 1
            for i, q in ipairs(pins) do if q == sel then si = i end end
            local first = tonumber(st.tracker_tab_first) or 1
            if st.tracker_tab_seen ~= sel then
                if si < first then first = si end
                if si > first + n_fit - 1 then first = si - n_fit + 1 end
                st.tracker_tab_seen = sel
            end
            local last_first = math.max(1, #pins - n_fit + 1)
            first = math.max(1, math.min(first, last_first))
            st.tracker_tab_first = first
            W.line_pass(imgui, function ()
                local scroll
                if arrows then
                    if W.button(ui, name, 'tab_prev', '◀', { section = 'head', row = 'h', small = true, no_focus = true,
                        disabled = first <= 1, tooltip = t('tracker.tab_prev') }) then scroll = -1 end
                    W.same(ui)
                end
                for i = first, math.min(#pins, first + n_fit - 1) do
                    local q = D:quest(pins[i])
                    local full = q and tracker.head_text(q) or pins[i]
                    local label, cut = tracker.fit_label(imgui, full, tw - 8)
                    if i > first then W.same(ui) end
                    local on = (pins[i] == sel)
                    local clicked = W.button(ui, name, 'tab_' .. pins[i], label, { section = 'head', row = 'h', no_focus = true,
                        width = tw, tooltip = cut and full or nil })
                    if clicked and not on then
                        st.tracker_tab = pins[i]
                        local fc = focus.current(name)
                        local owner, is_entry = tracker.owner_of(fc, pins)
                        if owner then focus.set(name, (is_entry and 'e_' or 'q_') .. pins[i], true) end
                    end
                end
                if arrows then
                    W.same(ui)
                    if W.button(ui, name, 'tab_next', '▶', { section = 'head', row = 'h', small = true, no_focus = true,
                        disabled = first >= last_first, tooltip = t('tracker.tab_next') }) then scroll = 1 end
                end
                if scroll then st.tracker_tab_first = math.max(1, math.min(first + scroll, last_first)) end
            end)
            font(ui, 1, false)
        end
        if show_close then
            if tabs then W.same(ui) end
            local cw = button_w(imgui, '×')
            local rest = avail_x(imgui)
            if rest and cw and rest > cw then
                pcall(function ()
                    local x = imgui.GetCursorPosX()
                    imgui.SetCursorPosX(x + rest - cw)
                end)
            end
            if W.button(ui, name, 'hide', '×', { section = 'head', row = 'h', small = true, no_focus = true,
                tooltip = t('tracker.hide') }) then
                ui.set_tracker_visible(false)
            end
        end

        local body_h = math.max(20, avail_y(imgui))
        local child = pcall(imgui.BeginChild, '##astertrail_tracker_body', { 0, body_h }, 0, 0)
        if child then window.push(ui, 'child') end
        if st.save_error then
            W.colored(ui, 'warn', t('save.failed_once'))
        end

        local next_missions = marks_core.next_missions(D, P)
        for n_i, qid in ipairs(shown) do
            local q = D:quest(qid)
            local nf = not (level == 'all' or (level == 'inside' and entry == qid))
            local efocused = false
            if level == 'entries' then
                efocused = focus.item(name, 'e_' .. qid, 'entries', qid)
                imgui.BeginGroup()
                window.push(ui, 'group')
            end

            -- 琥珀色の太字タイトル
            font(ui, 1.22, true)
            local icon = tracker.mission_icon(ui, q, next_missions)
            if icon then ui_marks.inline_icon(ui, icon) end
            local head = tracker.head_text(q)
            local dim = require('src.ui.book').is_marked_unimplemented(S, qid)
            W.line_pass(imgui, function ()
                if W.link(ui, name, 'q_' .. qid, head, {
                    color = dim and 'muted' or 'sf_amber', section = 'list', row = qid .. '_name', bold = true, no_focus = nf,
                }) then
                    ui.open_detail_solo(qid, 'tracker')
                end
            end)
            font(ui, 1, false)

            if not collapsed then
                local step = P:current_step(qid)
                local nav = P:step_nav(qid)
                local terms = CT.quest_terms(D, q)
                local function term_line(text, key, sid, line_opts, terms_use)
                    line_opts = line_opts or {}
                    local hit = W.term_line(ui, name, 'qn_' .. qid .. key, text, terms_use or terms, {
                        muted = line_opts.muted, color = line_opts.color, align = 'left',
                        section = 'list', row = qid .. key,
                        focus_acts = nf and {} or { map = true },
                        tip = function (act, piece)
                            if act == 'map' and piece and piece.kind == 'group' then return t('tracker.map_all') end
                            if act == 'map' then return t('map.view') end
                            if act == 'copy' then return t('tracker.copy_item') end
                        end,
                    })
                    if not hit then return end
                    if hit.act == 'map' then
                        if hit.kind == 'group' then
                            ui.open_map(qid, sid)
                        else
                            local msid, mloc, mtg = tracker.map_target(D, q, hit.text, sid)
                            if mtg and mtg.kind == 'mob' then
                                ui.open_map(qid, msid, mloc, { mob = mtg.id })
                            else
                                ui.open_map(qid, msid, mloc)
                            end
                        end
                    elseif hit.act == 'copy' and ui.copy_to_clipboard then
                        ui.copy_to_clipboard(hit.text)
                    end
                end

                -- 進みバーと 4/5
                local ci, ct = P:step_count(qid)
                if ci and ct and ct > 0 then
                    local aw = avail_x(imgui)
                    local bar_w = math.max(40, (aw or 200) - 48)
                    local frac = math.max(0, math.min(1, (ci - 1) / ct))
                    if nav.done then frac = 1 end
                    local x, y = sf.xy(pcall(imgui.GetCursorScreenPos))
                    if x and y then
                        local dl = imgui.GetWindowDrawList and imgui.GetWindowDrawList()
                        -- 区切りのあるバー
                        sf.bar(dl, x, y + 4, bar_w, 6, frac)
                        if ct <= 16 then
                            for i = 1, ct - 1 do
                                local sx = x + bar_w * (i / ct)
                                pcall(function ()
                                    dl:AddLine({ sx, y + 3 }, { sx, y + 11 }, theme.u32('bg', 0.85), 1.0)
                                end)
                            end
                        end
                        font(ui, 0.80, true)
                        sf.text_at(imgui, x + bar_w + 6, y, function ()
                            theme.TextColored(imgui, theme.col('sf_amber'), tostring(ci) .. '/' .. tostring(ct))
                        end)
                        font(ui, 1, false)
                    end
                    imgui.Dummy({ aw or 200, 16 })
                end

                if step then
                    font(ui, 0.96, false)
                    local cur_text = step.next_line_ja or t('detail.step_no_text')
                    local poss_ex
                    cur_text, poss_ex = poss_ui.apply_to_step(ui, step, cur_text, q)
                    local cur_terms, counts = {}, {}
                    for _, x in ipairs(terms) do cur_terms[#cur_terms + 1] = x end
                    poss_ui.merge_terms(cur_terms, poss_ex)
                    local has_multi = tracker.has_multi_map_targets(D, step)
                    if has_multi then
                        counts = tracker.people_counts(cur_text)
                        for _, s in ipairs(counts) do CT.add(cur_terms, s, 'group') end
                    end
                    term_line(cur_text, '_cur', step.id, nil, cur_terms)
                    if has_multi and #counts == 0 then
                        W.same(ui)
                        if W.link(ui, name, 'qn_' .. qid .. '_cur_group_map', t('map.view_short'), {
                            color = 'sf_cyan', section = 'list', row = qid .. '_cur',
                            no_focus = nf, tooltip = t('tracker.map_all'),
                        }) then
                            ui.open_map(qid, step.id)
                        end
                    end
                    if S.tracker.show_time_weather and step.time_weather_ja then
                        font(ui, tracker.SCALE.time or 0.92, false)
                        W.colored(ui, 'warn', labels.time_weather(t, step.time_weather_ja, ui.current_weather and ui.current_weather()))
                        font(ui, 1, false)
                    end
                    font(ui, tracker.SCALE.next or 0.88, false)
                    if nav.next then
                        local nx_text = t('tracker.next', { text = nav.next.next_line_ja or t('detail.step_no_text') })
                        local nx_ex
                        nx_text, nx_ex = poss_ui.apply_to_step(ui, nav.next, nx_text, q)
                        local nx_terms = {}
                        for _, x in ipairs(terms) do nx_terms[#nx_terms + 1] = x end
                        poss_ui.merge_terms(nx_terms, nx_ex)
                        term_line(nx_text, '_nx', nav.next.id, { muted = true }, nx_terms)
                    elseif nav.branch then
                        W.muted(ui, t('tracker.next', { text = t('tracker.next_branch') }))
                    elseif nav.last then
                        W.muted(ui, t('tracker.next', { text = t('tracker.next_last') }))
                    end
                    font(ui, 1, false)
                else
                    W.muted(ui, t('tracker.all_done'))
                end

                local branch = st.branch and st.branch.quest == qid and st.branch
                if branch then
                    W.colored(ui, 'warn', t('tracker.branch'))
                    for j, nid in ipairs(branch.options) do
                        local ns = D:step(nid)
                        local bl = util.utf8_cut(ns and ns.next_line_ja or nid, 24)
                        if W.button(ui, name, 'br_' .. nid, bl,
                            { section = 'list', row = qid .. '_br' .. j, small = true, no_focus = nf }) then
                            ui.request('set_current_step', qid, nid)
                            st.branch = nil
                        end
                    end
                end

                local row = qid .. '_ops'
                local unpinned = false
                font(ui, tracker.SCALE.ops or 0.95, false)
                -- 左の ◀ が窓のクリップで欠けないよう、少し内側へ空ける
                pcall(function () imgui.Dummy({ 8, 1 }) end)
                if imgui.SameLine then imgui.SameLine(0, 0) end
                if ops_button(ui, name, 'prev_' .. qid, '◀', { section = 'list', row = row, no_focus = nf,
                    disabled = not nav.prev, tooltip = t('tracker.prev_step') }) then
                    ui.tracker_step(qid, -1)
                end
                W.same(ui)
                if ops_button(ui, name, 'next_' .. qid, '▶', { section = 'list', row = row, no_focus = nf,
                    disabled = (nav.done or not nav.cur or (nav.last and P.steps_locked and P:steps_locked(qid))) and true or false,
                    tooltip = (nav.last and P.steps_locked and P:steps_locked(qid)) and t('detail.check_locked') or t('tracker.next_step') }) then
                    ui.tracker_step(qid, 1)
                end
                if not tabs then
                    W.same(ui)
                    if ops_button(ui, name, 'up_' .. qid, '▲', { section = 'list', row = row, no_focus = nf,
                        disabled = not P:can_move_pin(qid, -1), tooltip = t('tracker.up') }) then
                        ui.request('move_pin', qid, -1)
                    end
                    W.same(ui)
                    if ops_button(ui, name, 'down_' .. qid, '▼', { section = 'list', row = row, no_focus = nf,
                        disabled = not P:can_move_pin(qid, 1), tooltip = t('tracker.down') }) then
                        ui.request('move_pin', qid, 1)
                    end
                end
                W.same(ui)
                unpinned = ops_button(ui, name, 'unpin_' .. qid, '×', { section = 'list', row = row, no_focus = nf,
                    tooltip = t('tracker.unpin') })
                font(ui, 1, false)
                if unpinned then ui.request('unpin', qid) end
                if st.suggest_complete == qid then
                    W.colored(ui, 'good', t('tracker.suggest_complete'))
                end
            end
            if level == 'entries' then
                window.pop(ui, 'group')
                W.after_item(ui, name, 'e_' .. qid, efocused)
            end
        end
        if child then window.pop(ui, 'child') end
        local okh, hov = pcall(imgui.IsWindowHovered, C('ImGuiHoveredFlags_ChildWindows'))
        local oki, item_hov = pcall(imgui.IsAnyItemHovered)
        if okh and hov and not (oki and item_hov) and imgui.IsMouseDoubleClicked(0) then
            tracker.set_collapsed(ui, not S.tracker.collapsed)
        end
        font(ui, 1, false)
    end
    local preferred
    if level == 'entries' then preferred = 'e_' .. shown[1]
    elseif entry then preferred = 'q_' .. entry
    else preferred = 'q_' .. shown[1] end
    window.finish(ui, name, preferred)
end

return tracker_sf
