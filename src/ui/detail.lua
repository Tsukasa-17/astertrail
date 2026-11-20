--[[
  Astertrail - クエスト詳細
  名前、区分、場所、発生NPC、状態、受けられない理由、手順、報酬。
  - 本の右側（一覧で選んだもの）と、詳細だけの窓（一覧でダブルクリック）の両方で同じ中身を描く。
  - 出典は画面に出さない（参照元は「このアドオンについて」に書く）。
  操作: set_state / check_step / set_current_step / pin
  最後の手順をチェックしても自動で完了にはしない（勧める表示だけ）。
  0.1.60〜：手順の行を決定すると、前の手順（選んだルートと共通の手順）に全部チェックを付け、
  その手順から後のチェックは外す。□ を押すと前の手順にも付き、■ を外すとそこから後も外れる。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local labels = require('src.ui.labels')
local poss_ui = require('src.ui.possession_ui')
local CT = require('src.ui.colored_text')
local marks_core = require('src.core.marks')
local theme = require('src.ui.theme')

local detail = {}

--[[
  中身。win は選択（focus）を登録する窓の名前（本の中なら 'book'）。
  opts = { embedded = bool, on_close = function }
]]
function detail.body(ui, win, q, opts)
    opts = opts or {}
    local imgui, t = ui.imgui, ui.t
    local st = ui.state
    local P, D = ui.progress, ui.data
    local name = win

    local marked = require('src.ui.book').is_marked_unimplemented(ui.settings, q.id)
    local sf_on = opts.sf == true
    if sf_on then
        local sc = window.font_scale(ui, 'detail')
        window.set_font(ui, sc * 1.38, { bold = true })
    end
    theme.TextColored(imgui, theme.col(marked and 'muted' or (sf_on and 'heading' or 'accent')), (q.mission_no and (q.mission_no .. '  ') or '') .. labels.qname(q))
    if sf_on then window.set_font(ui, window.font_scale(ui, 'detail') * 0.78, nil) end
    if marked then W.muted(ui, ui.t('roe.tag_failed.not_impl')) end
    if sf_on then
        theme.TextColored(imgui, theme.col('sf_cyan'), t('detail.category', {
            kind = t('kind.' .. q.kind), area = D:category_label(q.category, ui.settings.language) }))
        window.set_font(ui, window.font_scale(ui, 'detail'), nil)
    else
        W.muted(ui, t('detail.category', {
            kind = t('kind.' .. q.kind), area = D:category_label(q.category, ui.settings.language) }))
    end

    -- 地図は名前を押して開く（設定でオフなら、名前は色だけ）
    local map_on = ui.settings.map and ui.settings.map.enabled ~= false and ui.open_map

    local place = D:start_place_text(q)
    local sl = D:start_location(q)
    if place then
        local terms = {}
        if sl and sl.zone_name then CT.add(terms, sl.zone_name, 'zone') end
        W.ctext(ui, t('detail.where', { loc = place }), terms)
    end
    local npc = D:start_npc_name(q)
    if npc then
        local can = map_on and sl and sl.zone_id
        if W.named(ui, name, 'open_map', t('detail.start_npc', { name = '{name}' }), npc, {
            color = 'npc', click = can, section = 'd_view', row = 'v',
            tooltip = can and t('map.view') or nil, muted = true,
        }) then
            ui.open_map(q.id)
        end
    end

    -- 詳細だけの窓から本に戻る（本の右側には出さない）
    if not opts.embedded then
        if W.button(ui, name, 'to_book', t('detail.to_book'), { section = 'd_view', row = 'v', small = true }) then
            ui.select_in_book(q.id)
        end
    end

    local state = P:state(q.id)
    W.text(ui, t('detail.state', { state = labels.state(t, state) }))
    if state ~= 'not_accepted' and ui.can_revert_unstarted and ui.can_revert_unstarted(q.id) then
        if W.button(ui, name, 'reset_unstarted', t('detail.reset_unstarted'), {
            section = 'state', row = 'state', tooltip = t('detail.reset_unstarted_tip'),
        }) then
            if ui.revert_unstarted then ui.revert_unstarted(q.id) end
        end
    end

    -- 状態とピンを1列に（公開版は状態のボタンを出さない。受注・完了はゲームの記録から。t225）
    local manual = (ui.manual_checks == nil) or ui.manual_checks()
    -- 手で 未受注・受注中・完了 にするボタンはデバッグ用（0.1.187〜、t308。設定のデバッグか /astertrail debug buttons）
    local state_buttons = manual and ui.state_buttons ~= nil and ui.state_buttons()
    if state_buttons then
        for i, s in ipairs({ 'not_accepted', 'accepted', 'completed' }) do
            if i > 1 then W.same(ui) end
            local mark = (state == s) and '◆' or '◇'
            if W.button(ui, name, 'state_' .. s, mark .. ' ' .. t('state.' .. s),
                { section = 'state', row = 'state' }) then
                ui.request('set_state', q.id, s)
            end
        end
        W.same(ui)
    end
    local pinned = P:is_pinned(q.id)
    local can_pin = pinned or not marked
    if W.button(ui, name, 'pin', pinned and t('detail.unpin') or t('detail.pin'), {
        section = 'state', row = 'state',
        disabled = not can_pin,
        tooltip = (not can_pin) and t('book.pin_unimplemented') or nil,
    }) then
        ui.request(pinned and 'unpin' or 'pin', q.id)
    end
    W.same(ui)
    do
        local book = require('src.ui.book')
        local label = marked and t('detail.clear_unimplemented') or t('detail.mark_unimplemented')
        local tip = marked and t('detail.clear_unimplemented_tip') or t('detail.mark_unimplemented_tip')
        if W.button(ui, name, 'unimplemented', label, { section = 'state', row = 'state', tooltip = tip }) then
            if book.toggle_unimplemented(ui.settings, q.id) and ui.mark_settings_dirty then
                ui.mark_settings_dirty()
            end
        end
    end

    if q.repeatable == 'yes' then W.muted(ui, t('detail.repeatable_yes'))
    elseif q.repeatable == 'no' then W.muted(ui, t('detail.repeatable_no')) end

    -- 確認（リピート可否が「可」でない周回、完了の勧め）
    if st.confirm and st.confirm.quest == q.id then
        W.colored(ui, 'warn', st.confirm.text)
        if W.button(ui, name, 'confirm_yes', t('common.yes'), { section = 'confirm', row = 'c' }) then
            ui.request(st.confirm.action, q.id, st.confirm.arg, true)
            st.confirm = nil
        end
        W.same(ui)
        if W.button(ui, name, 'confirm_no', t('common.no'), { section = 'confirm', row = 'c' }) then
            st.confirm = nil
        end
    end
    if state_buttons and st.suggest_complete == q.id and P:state(q.id) ~= 'completed' then
        W.colored(ui, 'good', t('detail.suggest_complete'))
        if W.button(ui, name, 'suggest_yes', t('detail.mark_complete'), { section = 'confirm', row = 's' }) then
            ui.request('set_state', q.id, 'completed')
            st.suggest_complete = nil
        end
        W.same(ui)
        if W.button(ui, name, 'suggest_no', t('common.later'), { section = 'confirm', row = 's' }) then
            st.suggest_complete = nil
        end
    end

    -- 受ける条件（資料に書いてあるものだけ）。まだ満たしていないときだけ「受けられない理由」
    if q.lock_reasons and #q.lock_reasons > 0 then
        W.sep(ui)
        local blocked = false
        if P and D and P:state(q.id) == 'not_accepted' then
            local status = ui.player_status and ui.player_status() or nil
            blocked = marks_core.prereq_unmet(D, P, q) or marks_core.reqs_unmet(q, status)
        end
        W.heading(ui, t(blocked and 'detail.lock_reasons' or 'detail.lock_conditions'))
        for _, r in ipairs(q.lock_reasons) do W.text(ui, '・' .. (r.text_ja or '')) end
    end

    -- 手順
    W.sep(ui)
    if opts.sf then
        window.set_font(ui, window.font_scale(ui, 'detail') * 0.74, { bold = true })
        theme.TextColored(imgui, theme.col('sf_cyan'), t('sf.label_objective'))
        window.set_font(ui, window.font_scale(ui, 'detail'), nil)
    else
        W.heading(ui, t('detail.steps'))
    end
    local cur = P:current_step(q.id)
    -- ルート：選んだルートの手順だけ出し、ほかのルートはたたむ（切り替え・全部表示もできる）
    local routes = P.routes and P:routes(q.id) or {}
    local route = (#routes > 1) and P:chosen_route(q.id) or nil
    st.show_all_routes = st.show_all_routes or {}
    local show_all = st.show_all_routes[q.id] == true
    if route then
        W.colored(ui, 'accent', t('detail.route_chosen', { route = route }))
        local first_btn = true
        for _, other in ipairs(routes) do
            if other ~= route then
                if not first_btn then W.same(ui) end
                first_btn = false
                if W.button(ui, name, 'route_' .. other, t('detail.route_switch', { route = other }),
                    { section = 'route', row = 'route', small = true }) then
                    ui.request('set_route', q.id, other)
                    st.show_all_routes[q.id] = nil
                end
            end
        end
        W.same(ui)
        if W.button(ui, name, 'route_all', show_all and t('detail.route_hide_others') or t('detail.route_show_all'),
            { section = 'route', row = 'route', small = true }) then
            st.show_all_routes[q.id] = (not show_all) or nil
        end
    end
    local shown, hidden = 0, 0
    local step_lock = P.steps_locked and P:steps_locked(q.id) or false
    if manual and step_lock then W.muted(ui, t('detail.steps_locked')) end
    for _, s in ipairs(q.steps) do
      local in_route = (route == nil) or P.step_in_route(s, route)
      if not in_route and not show_all then
        hidden = hidden + 1
      else
        shown = shown + 1
        local done = P:step_done(q.id, s.id)
        local is_cur = cur and cur.id == s.id
        if opts.sf then
            local sfst = require('src.ui.sf_style')
            local okp, px, py = pcall(imgui.GetCursorScreenPos)
            if type(px) == 'table' then px, py = px.x or px[1], px.y or px[2] end
            if okp and px and py then
                local dl = imgui.GetWindowDrawList and imgui.GetWindowDrawList()
                local cx, cy = px + 9, py + 10
                sfst.step_dot(dl, cx, cy, 8, shown, { current = is_cur })
                if is_cur then
                    local aw = 200
                    local oka, aa = pcall(imgui.GetContentRegionAvail)
                    if oka and type(aa) == 'table' then aw = tonumber(aa.x or aa[1]) or aw
                    elseif oka then aw = tonumber(aa) or aw end
                    pcall(function ()
                        dl:AddRectFilled({ px + 22, py - 2 }, { px + math.max(80, aw - 4), py + 22 },
                            theme.u32('sf_cyan', 0.10), 0)
                    end)
                end
            end
            imgui.Dummy({ 22, 1 })
            imgui.SameLine(0, 4)
        end
        if manual then
            -- 未受注のクエストは □ を押せない（0.1.180〜、t290。付いている ■ は外せる）
            local locked = (not done) and step_lock
            if W.button(ui, name, 'chk_' .. s.id, done and '■' or '□',
                -- コントローラーの選択は ■/□ に止めない（行の決定で前の手順まで付く。0.1.60〜）
                { section = 'steps', row = s.id, small = true, no_focus = true, disabled = locked,
                  tooltip = locked and t('detail.check_locked') or (done and t('detail.uncheck') or t('detail.check')) }) then
                ui.request(done and 'uncheck_step' or 'check_step', q.id, s.id)
            end
        else
            W.muted(ui, done and '■' or '□')   -- 公開版：印だけ（押せない）
        end
        W.same(ui)
        local terms = CT.quest_terms(D, q)
        -- 1行目：番号と次の一手（今の手順は番号と「← 今」の印で示す。名前の色は残す）
        local first = { { text = string.format('%d. ', route and shown or (s.order or 0)), color = is_cur and 'accent' or nil } }
        for _, sp in ipairs(CT.spans(s.next_line_ja or t('detail.step_no_text'), terms)) do first[#first + 1] = sp end
        if is_cur then first[#first + 1] = { text = '  ' .. t('detail.current_mark'), color = 'accent' } end
        local lines = { { spans = first } }
        lines[#lines + 1] = { text = t('detail.where', { loc = D:location_text(s, t) }), terms = terms, muted = true }
        local rname = (type(s.routes_ja) == 'table' and #s.routes_ja > 0) and table.concat(s.routes_ja, ' / ') or s.route_ja
        if rname and rname ~= '' then
            lines[#lines + 1] = { text = t('detail.route', { route = rname }) ..
                ((not in_route) and ('  ' .. t('detail.route_other')) or ''), muted = true }
        end
        local tn = D:target_name(s.target)
        local tg = s.target and D:target(s.target)
        -- 「相手」の名前は行の外で、色と地図の操作を付ける
        if s.text_ja and s.text_ja ~= '' then lines[#lines + 1] = { text = s.text_ja, terms = terms, muted = true } end
        if s.time_weather_ja then
            lines[#lines + 1] = { text = labels.time_weather(t, s.time_weather_ja, ui.current_weather and ui.current_weather()), color = 'warn' }
        end
        if #s.needs > 0 then
            local parts = {}
            local alt = false
            for _, n in ipairs(s.needs) do
                parts[#parts + 1] = labels.need(t, n)
                if n.group then alt = true end
            end
            local joined = table.concat(parts, alt and t('need.or') or '、')
            lines[#lines + 1] = { text = t('detail.needs', { list = joined }), terms = terms, muted = true }
        end
        if #s.next > 1 then
            lines[#lines + 1] = { text = t('detail.branch'), color = 'warn' }
        end
        local function on_term(hit)
            if hit and hit.act == 'copy' and ui.copy_to_clipboard then ui.copy_to_clipboard(hit.text) end
        end
        if W.row(ui, name, 'step_' .. s.id, lines, {
            section = 'steps', row = s.id, term_click = true, on_term = on_term,
            tip = function (act, piece)
                if piece and piece.tip then return piece.tip end
                if act == 'copy' then return t('tracker.copy_item') end
            end,
        }) then
            ui.request('set_current_step', q.id, s.id)
        end
        -- 所持（0.1.184〜）：名前は正式名称をコピー。数は場所、だいじなものはチェック／バツ
        if #s.needs > 0 and ui.settings.items.show_possession then poss_ui.draw_inline(ui, s.needs, name, 'd' .. s.id) end
        if tn then
            local tloc = (s.location and s.location.zone_id) or (tg and tg.location and tg.location.zone_id)
            local kind = (tg and tg.kind) or 'npc'
            -- モンスター（0.1.171〜）も地図を開き、近くにいればその位置に出す
            local can = map_on and tloc
            local col = CT.KIND_COLOR[kind] or 'npc'
            if W.named(ui, name, 'map_' .. s.id, t('detail.target', { name = '{name}' }), tn, {
                -- 「相手」は手順の下の行なので、キー・パッドでも上下で移る（0.1.175〜。前は左右）
                color = col, click = can, section = 'steps', row = s.id .. '#target',
                tooltip = can and t('map.view') or nil, muted = true,
            }) then
                if kind == 'mob' then ui.open_map(q.id, s.id, nil, { mob = s.target }) else ui.open_map(q.id, s.id) end
            end
        end
      end
    end
    if hidden > 0 then W.muted(ui, t('detail.route_hidden', { n = hidden })) end
    -- 手順の使い方の説明は出さない（0.1.180〜、t291。動きは同じ）

    -- 報酬
    W.sep(ui)
    if opts.sf then
        window.set_font(ui, window.font_scale(ui, 'detail') * 0.74, { bold = true })
        theme.TextColored(imgui, theme.col('sf_cyan'), t('sf.label_reward'))
        window.set_font(ui, window.font_scale(ui, 'detail'), nil)
    else
        W.heading(ui, t('detail.rewards'))
    end
    if q.rewards and #q.rewards > 0 then
        for _, r in ipairs(q.rewards) do
            local text = '・' .. labels.reward(t, r)
            if r.kind == 'item' or r.kind == 'key_item' then
                local nm = r.name_ja or r.name_en or ''
                local hit = W.term_line(ui, name, 'rw_' .. tostring(nm), text, CT.add({}, nm, 'item', { copy_text = nm }), {
                    tip = function (act)
                        if act == 'copy' then return t('tracker.copy_item') end
                    end,
                })
                if hit and hit.act == 'copy' and ui.copy_to_clipboard then ui.copy_to_clipboard(hit.text) end
            else
                W.text(ui, text)
            end
        end
    else
        W.muted(ui, t('detail.rewards_none'))
    end
    if q.note_ja then W.muted(ui, q.note_ja) end
end

-- 詳細だけの窓（本の一覧でダブルクリックした時）
function detail.draw(ui)
    if theme.is_sf and theme.is_sf() then
        return require('src.ui.detail_win_sf').draw(ui)
    end
    local t = ui.t
    local st = ui.state
    local qid = st.detail_quest
    local q = qid and ui.data:quest(qid)
    local name = 'detail'
    if not q then ui.close_window(name); return end
    local P = ui.progress
    local open = { true }
    local drawing = window.begin(ui, name, { title = t('detail.title'), open = open, operable = true })
    if drawing then
        ui.status_line()
        detail.body(ui, name, q, { embedded = false })
        W.sep(ui)
        if W.button(ui, name, 'to_book_footer', t('detail.to_book'), { section = 'footer', row = 'fb' }) then
            ui.select_in_book(q.id)
        end
        W.same(ui)
        if W.button(ui, name, 'back', t('common.close'), { section = 'footer', row = 'fb' }) then
            open[1] = false
        end
    end
    local cur = P:current_step(q.id)
    window.finish(ui, name, cur and ('step_' .. cur.id) or nil)
    if not open[1] and st.open.detail then ui.close_window(name) end
end

return detail
