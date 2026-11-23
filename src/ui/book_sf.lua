--[[
  Astertrail - 本のメイン画面（SF 見た目、0.1.253〜。0.1.254 でモックアップ C に近づける）
  クラシック／YunaUI の配置は触らない。見た目が sf のときだけ book.draw から呼ばれる。
  中身は本物のデータだけ。検索・絞り込み・ピン・未実装・地図・所持・リピート・受けられない理由は残す。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local theme = require('src.ui.theme')
local focus = require('src.ui.focus')
local labels = require('src.ui.labels')
local sf = require('src.ui.sf_style')
local book = require('src.ui.book')
local util = require('src.lib.util')
local CT = require('src.ui.colored_text')
local poss_ui = require('src.ui.possession_ui')
local marks_core = require('src.core.marks')
local book_sf = {}
local bottom_fit = {}
local steps_fit = {}
local step_card_h = {}

local function font(ui, win, mul, bold)
    local base = window.font_scale(ui, win)
    window.set_font(ui, base * (mul or 1), bold and { bold = true } or nil)
end

local function dl_of(imgui)
    local ok, dl = pcall(imgui.GetWindowDrawList)
    if ok then return dl end
    return nil
end

local function tooltip(imgui, text)
    if text and imgui.IsItemHovered and imgui.IsItemHovered() and imgui.SetTooltip then
        pcall(imgui.SetTooltip, text)
    end
end

local function frac_of(P, q)
    local st = P:state(q.id)
    local ci, ct = P:step_count(q.id)
    if st == 'completed' then
        if ct and ct > 0 then return 1, ct, ct end
        return 1
    end
    if st == 'not_accepted' then return 0, ci, ct end
    if ci and ct and ct > 0 then return math.max(0, math.min(1, (ci - 1) / ct)), ci, ct end
    return 0, ci, ct
end

local function badge_of(t, st)
    if st == 'completed' then return t('sf.badge_done'), 'sf_amber' end
    -- 0.1.320〜：状態の札（右下の枠と文字）だけ状態の色。進行中はやわらかい紫ピンク。外枠はどの状態でも共通
    if st == 'accepted' then return t('sf.badge_progress'), 'sf_violet' end
    return t('sf.badge_idle'), 'muted'
end
book_sf._badge_of = badge_of

local function card_tag(ui, q)
    if q.mission_no and q.mission_no ~= '' then return q.mission_no end
    local D = ui.data
    local zone = D and D.start_place_text and D:start_place_text(q)
    if zone and zone ~= '' then return zone end
    if D and D.category_label then
        local lab = D:category_label(q.category, ui.settings.language)
        if lab and lab ~= '' then return lab end
    end
    return nil
end


-- タブやチップを同じ高さに並べるために、実機の ImVec2 でもカーソルを読む
local function cursor(imgui)
    return sf.xy(pcall(imgui.GetCursorScreenPos))
end

local function mouse_in(imgui, x1, y1, x2, y2)
    if not (x1 and y1 and x2 and y2) then return false end
    local mx, my = sf.xy(pcall(imgui.GetMousePos))
    return mx and my and mx >= x1 and mx < x2 and my >= y1 and my < y2
end

local function label_col(name)
    return theme.u32(name or 'text', 1.0)
end

local function chip_w(imgui, label, pad_x)
    local tw = select(1, theme.measure_text(imgui, label)) or 40
    return (tw or 40) + (pad_x or 8) * 2
end

local function draw_logo(ui, win, x, y)
    local imgui, t = ui.imgui, ui.t
    window.set_font(ui, window.font_scale(ui, win) * 1.85, { heading = true, bold = true })
    local label = t('sf.logo')
    local total, th = sf.measure_heading(imgui, label, 'title')
    total, th = total or 0, th or 22
    local w, h = total + 4, th + 10
    if x and y then sf.set_cursor(imgui, x, y) end
    local clicked = sf.hit(imgui, '##sflogo', w, h)
    local x1, y1, x2, y2 = sf.item_rect(imgui)
    if x1 then
        sf.add_heading(imgui, x1, y1, label_col('heading'), label, 'title')
        if sf.underline then
            sf.underline(dl_of(imgui), x1, y2 - 3, x1 + total, theme.u32('sf_cyan', 0.95), 1.5)
        end
        if sf.snap_after_item then sf.snap_after_item(imgui) end
    end
    font(ui, win, 1, false)
    return clicked, w, h
end

local function draw_tab(ui, win, id, label, on, x, y)
    local imgui = ui.imgui
    window.set_font(ui, window.font_scale(ui, win) * 1.08, { heading = true, bold = true })
    local tw, th = sf.measure_heading(imgui, label, 'label')
    tw, th = tw or 64, th or 18
    local pad_x, pad_y = 18, 9
    local w, h = tw + pad_x * 2, th + pad_y * 2
    if x and y then sf.set_cursor(imgui, x, y) end
    local clicked = sf.hit(imgui, '##sftab_' .. id, w, h)
    local x1, y1, x2, y2 = sf.item_rect(imgui)
    if x1 then
        -- 選んでいるタブは水色の光りを最大2重（はっきり見えるようにする）
        sf.frame(dl_of(imgui), x1, y1, x2, y2, {
            cut = 8, fill_a = on and 0.58 or 0.16, line_a = on and 1.0 or 0.38,
            line = on and theme.u32('sf_cyan', 1.0) or nil,
            brackets = on, bracket_len = 10, thick = on and 2.2 or 1.2,
            glow = on and 2 or 0,
            glow_col = theme.u32('sf_cyan', 0.90),
            glow_col2 = theme.u32('sf_cyan', 0.32),
            band_a = on and 0.22 or 0.03,
        })
        sf.add_heading(imgui, x1 + pad_x, y1 + pad_y - 1, label_col(on and 'heading' or 'muted'), label, 'label')
        if sf.snap_after_item then sf.snap_after_item(imgui) end
    end
    font(ui, win, 1, false)
    return clicked, w, h
end

local function rail_btn(ui, win, id, icon, tip, on)
    local imgui = ui.imgui
    local size = 36
    local clicked = sf.hit(imgui, '##sfrail_' .. id, size, size)
    local x1, y1, x2, y2 = sf.item_rect(imgui)
    if x1 then
        local dl = dl_of(imgui)
        if on then sf.stroke_cut(dl, x1, y1, x2, y2, 5, theme.u32('sf_cyan', 0.95), 1.4) end
        if icon then icon(dl, (x1 + x2) / 2, (y1 + y2) / 2, 10, theme.u32('sf_cyan', on and 1.0 or 0.42)) end
    end
    tooltip(imgui, tip)
    return clicked
end

local function chip(ui, win, id, label, on, tip, opts)
    opts = opts or {}
    local imgui = ui.imgui
    font(ui, win, opts.scale or 0.78, opts.bold)
    local tw, th = theme.measure_text(imgui, label)
    tw, th = tw or 40, th or 14
    local pad_x, pad_y = opts.pad_x or 8, opts.pad_y or 3
    local w, h = tw + pad_x * 2, th + pad_y * 2
    if opts.x and opts.y then sf.set_cursor(imgui, opts.x, opts.y) end
    local clicked = sf.hit(imgui, '##sfchip_' .. id, w, h)
    local x1, y1, x2, y2 = sf.item_rect(imgui)
    if x1 then
        local line = opts.line
        sf.frame(dl_of(imgui), x1, y1, x2, y2, {
            cut = opts.cut or 4, fill_a = on and (opts.fill_on or 0.40) or (opts.fill_off or 0.16),
            line_a = on and 0.95 or 0.35, line = line,
            brackets = false, glow = false, thick = 1.1, band = false,
        })
        sf.add_text(dl_of(imgui), x1 + pad_x, y1 + pad_y, label_col(opts.color or (on and 'heading' or 'muted')), label)
    end
    if sf.snap_after_item then sf.snap_after_item(imgui) end
    tooltip(imgui, tip)
    font(ui, win, 1, false)
    return clicked, w, h
end

-- チップを同じ高さで折り返す（SameLine は使わない。文字を ImGui 項目にすると基準が斜めにずれる）
local function flow_start(imgui)
    local x, y = cursor(imgui)
    x, y = x or 0, y or 0
    -- 残りの幅ではなく、窓の右端で折り返す（検索欄の右にチップが乗らないように）
    local wx, wy = sf.xy(pcall(imgui.GetWindowPos))
    local ww, wh = sf.xy(pcall(imgui.GetWindowSize))
    local right
    if wx and ww then
        right = wx + ww - 8
    else
        right = x + (select(1, sf.avail(imgui)) or 400)
    end
    if wx and x > wx + 24 and right - x < 80 then
        sf.break_row(imgui)
        x, y = cursor(imgui)
        x, y = x or 0, y or 0
        if wx and ww then right = wx + ww - 8 end
    end
    return { x0 = x, x = x, y = y, row_h = 0, right = right, gap = 6 }
end

local function flow_next(st, w, h)
    w, h = w or 40, h or 18
    if st.x > st.x0 and st.x + w > st.right then
        st.x = st.x0
        st.y = st.y + st.row_h + st.gap
        st.row_h = 0
    end
    local x, y = st.x, st.y
    st.x = st.x + w + st.gap
    if h > st.row_h then st.row_h = h end
    return x, y
end

local function flow_end(imgui, st)
    -- SetCursor だけだと次の行の開始位置が戻らないことがあるので、Dummy で高さを進める
    sf.set_cursor(imgui, st.x0, st.y)
    local h = (st.row_h or 0) + 6
    pcall(function () imgui.Dummy({ 1, math.max(1, h) }) end)
    sf.break_row(imgui)
end


-- 右上：琥珀色の「次の目標」（ピンしている件の今の手順。無ければ出さない）
-- opts: { y=, left_min=, right= }  right は窓の内側の右端。はみ出さず、長い文は … で切る
local function draw_next_goal(ui, win, opts)
    opts = opts or {}
    local imgui, t, P, S = ui.imgui, ui.t, ui.progress, ui.settings
    if not P or not P.pinned_list then return 0, 0 end
    local pins = P:pinned_list()
    if #pins == 0 then return 0, 0 end
    local qid = pins[1]
    if S.tracker and S.tracker.view == 'tabs' and ui.state and ui.state.tracker_tab then
        for _, id in ipairs(pins) do
            if id == ui.state.tracker_tab then qid = id; break end
        end
    end
    local q = ui.data:quest(qid)
    local step = P:current_step(qid)
    local line = step and (step.next_line_ja or t('detail.step_no_text')) or t('tracker.all_done')
    local prefix = t('sf.next_goal') .. ' : '
    local ci, ct = P:step_count(qid)
    font(ui, win, 0.78, true)
    local function text_w(s)
        return (select(1, theme.measure_text(imgui, s)) or 80)
    end
    local pad_x, box_h, num_w = 12, 44, 0
    if ci and ct then
        num_w = (text_w(tostring(ci) .. '/' .. tostring(ct)) or 28) + 10
    end
    local max_w = opts.right and opts.left_min and (opts.right - opts.left_min - 4) or nil
    if max_w and max_w < 120 then max_w = math.max(80, max_w) end
    local inner = (max_w or 400) - pad_x * 2 - num_w
    local chars = 28
    local head = prefix .. util.utf8_cut(line, chars)
    while inner and chars > 4 and text_w(head) > inner do
        chars = chars - 1
        head = prefix .. util.utf8_cut(line, chars)
    end
    local box_w = text_w(head) + pad_x * 2 + num_w + 8
    if box_w < 160 then box_w = 160 end
    if max_w and box_w > max_w then box_w = max_w end
    local gx
    if opts.right then
        gx = opts.right - box_w
        if opts.left_min and gx < opts.left_min then gx = opts.left_min end
    end
    if gx and opts.y then sf.set_cursor(imgui, gx, opts.y) end
    local clicked = sf.hit(imgui, '##sfgoal', box_w, box_h)
    local x1, y1, x2, y2 = sf.item_rect(imgui)
    if x1 then
        sf.frame(dl_of(imgui), x1, y1, x2, y2, {
            cut = 6, fill_a = 0.32, line_a = 0.95,
            line = theme.u32('sf_amber', 0.95), glow = 1, brackets = true,
            bracket_len = 8, thick = 1.5, band_a = 0.08,
            glow_col = theme.u32('sf_amber', 0.40),
        })
        sf.add_text(dl_of(imgui), x1 + pad_x, y1 + 5, theme.u32('sf_amber', 1.0), head)
        if ci and ct and ct > 0 then
            local bar_w = math.max(40, (x2 - x1) - num_w - pad_x * 2)
            local frac = math.max(0, math.min(1, (ci - (step and 1 or 0)) / ct))
            if not step then frac = 1 end
            sf.bar(dl_of(imgui), x1 + pad_x, y2 - 12, bar_w, 5, frac, {
                bg = theme.u32('sf_amber', 0.18), fg = theme.u32('sf_amber', 0.95),
            })
            font(ui, win, 0.72, true)
            sf.add_text(dl_of(imgui), x1 + pad_x + bar_w + 6, y2 - 16, theme.u32('sf_amber', 1.0), tostring(ci) .. '/' .. tostring(ct))
        end
        if sf.snap_after_item then sf.snap_after_item(imgui) end
    end
    font(ui, win, 1, false)
    if clicked and q and ui.select_in_book then
        if q.kind and S.book.tab ~= q.kind and (q.kind == 'mission' or q.kind == 'quest') then
            S.book.tab = q.kind
            ui.mark_settings_dirty()
        end
        ui.select_in_book(qid, true)
    end
    tooltip(imgui, q and labels.display_name(q) or nil)
    return box_w, box_h
end

local function draw_card(ui, win, q, selected, width)
    local imgui, t, P = ui.imgui, ui.t, ui.progress
    local w = math.max(80, tonumber(width) or 160)
    local h = 108
    local clicked = sf.hit(imgui, '##sfcard_' .. q.id, w, h)
    local x1, y1, x2, y2 = sf.item_rect(imgui)
    local dbl = false
    if imgui.IsItemHovered and imgui.IsItemHovered() and imgui.IsMouseDoubleClicked and imgui.IsMouseDoubleClicked(0) then
        dbl = true
    end
    local card_hover = imgui.IsItemHovered and imgui.IsItemHovered()
    if not x1 then return clicked, dbl end
    local dl = dl_of(imgui)
    local pinned = P:is_pinned(q.id)
    local unimplemented = book.is_marked_unimplemented(ui.settings, q.id)
    -- 選んでいないカードは光りとブラケットを省略（描画回数を抑える）
    sf.frame(dl, x1, y1, x2, y2, {
        cut = 8, fill_a = selected and 0.46 or 0.24, line_a = selected and 1.0 or 0.62,
        brackets = selected, bracket_len = 10,
        thick = selected and 1.9 or 1.25, glow = selected and 1 or 0,
        glow_col = theme.u32('sf_cyan', 0.80),
        band = selected, band_a = selected and 0.14 or 0,
    })
    local st = P:state(q.id)
    local frac, ci, ct = frac_of(P, q)
    local tag = card_tag(ui, q)
    local yy = y1 + 7
    if tag then
        font(ui, win, 0.70, false)
        sf.text_at(imgui, x1 + 10, yy, function ()
            theme.TextColored(imgui, theme.col('sf_cyan'), tag)
        end)
        yy = yy + 14
    end
    font(ui, win, 1.05, true)
    -- 名前は内側幅で切ってから Text に出す。切らないと文字幅で隣のカードが右へずれる。
    local pin_s = 18
    local full = labels.display_name(q)
    -- 列の固定幅 w で測る（テストの ItemRect が常に小さい箱でも、実機の列幅と同じ）
    local name_max = math.max(16, w - 10 - pin_s - 8)
    local shown, name_clipped = window.clip_line(imgui, full, name_max)
    -- 切った名前だけ Text に出す。幅はカード内に収まるので、隣の列はずれない。
    sf.text_at(imgui, x1 + 10, yy, function ()
        theme.TextColored(imgui, theme.col(unimplemented and 'muted' or 'text'), shown)
    end)
    -- 下段：大きい手順数（左）と、枠付きの状態バッジ（右下）
    local badge, bcol = badge_of(t, st)
    font(ui, win, 0.68, true)
    local twb, thb = theme.measure_text(imgui, badge)
    local bpad_x, bpad_y = 7, 3
    local bw = (twb or 36) + bpad_x * 2
    local bh = (thb or 12) + bpad_y * 2
    local bx2, by2 = x2 - 10, y2 - 8
    local bx1, by1 = bx2 - bw, by2 - bh
    font(ui, win, 1.12, true)
    local count = (ci and ct) and (tostring(ci) .. ' / ' .. tostring(ct)) or nil
    local cw, ch = 0, 16
    if count then
        cw, ch = theme.measure_text(imgui, count)
        cw, ch = cw or 40, ch or 16
    end
    local count_y = by1 + math.max(0, (bh - ch) * 0.5)
    local bar_h = 5
    local bar_y = math.min(by1, count_y) - 8 - bar_h
    if bar_y < yy + 14 then bar_y = yy + 14 end
    sf.bar(dl, x1 + 10, bar_y, math.max(36, bx1 - 8 - (x1 + 10)), bar_h, frac)
    if count then
        sf.add_text(dl, x1 + 10, count_y, label_col('heading'), count)
    end
    sf.frame(dl, bx1, by1, bx2, by2, {
        cut = 3, fill_a = 0.42, line_a = 0.92, line = theme.u32(bcol, 0.95),
        brackets = false, glow = false, thick = 1.15, band = false,
    })
    -- 枠は 0.68 で測ったので、文字も同じ大きさで描く（1.12 のままだと枠からはみ出す）
    font(ui, win, 0.68, true)
    sf.add_text(dl, bx1 + bpad_x, by1 + bpad_y, theme.u32(bcol, 1.0), badge)
    font(ui, win, 1, false)
    pcall(function () imgui.SetCursorScreenPos({ x2 - pin_s - 6, y1 + 6 }) end)
    local can_pin = pinned or not unimplemented
    local tip = pinned and t('book.unpin') or (unimplemented and t('book.pin_unimplemented') or t('book.pin'))
    if sf.hit(imgui, '##sfp_' .. q.id, pin_s, pin_s) and can_pin then
        ui.request(pinned and 'unpin' or 'pin', q.id)
    end
    tooltip(imgui, tip)
    -- ピンに乗っているときはピンの案内を優先。切った名前はカードに乗せたとき全体を出す。
    if not (imgui.IsItemHovered and imgui.IsItemHovered()) then
        if card_hover and name_clipped and full and full ~= '' and imgui.SetTooltip then
            pcall(imgui.SetTooltip, full)
        end
    end
    local ix1, iy1 = sf.item_rect(imgui)
    if ix1 then
        sf.text_at(imgui, ix1 + 2, iy1, function ()
            theme.TextColored(imgui, theme.col(pinned and 'star_gold' or 'muted'), pinned and '★' or '☆')
        end)
    end
    pcall(function () imgui.SetCursorScreenPos({ x1, y2 }) end)
    font(ui, win, 1, false)
    return clicked, dbl
end

local function loc_lines(ui, q)
    local D = ui.data
    local sl = D:start_location(q)
    if not sl then return nil end
    local zone = sl.zone_name or (D.zone_name and D:zone_name(sl.zone_id))
    if not zone or zone == '' then return nil end
    local lines = { zone }
    if sl.grid and sl.grid ~= '' then lines[#lines + 1] = sl.grid end
    local x, y = tonumber(sl.x), tonumber(sl.y)
    if (not x or not y) and type(sl.pos) == 'table' then
        x, y = tonumber(sl.pos.x or sl.pos[1]), tonumber(sl.pos.y or sl.pos[2])
    end
    if x and y then
        lines[#lines + 1] = string.format('X: %.1f  Y: %.1f', x, y)
    end
    return lines, sl
end

local function section_label(ui, win, key)
    local imgui, t = ui.imgui, ui.t
    local label = t(key)
    if sf.is_en_heading(label) then
        window.set_font(ui, window.font_scale(ui, win) * 0.72, { heading = true, bold = true })
        sf.heading_line(ui, label, theme.u32('sf_cyan', 1.0), 'label')
    else
        font(ui, win, 0.72, true)
        theme.TextColored(imgui, theme.col('sf_cyan'), label)
    end
    font(ui, win, 1, false)
end

-- 右ペイン：大きいタイトル、OBJECTIVE の手順タイムライン、下に REWARD / LOCATION

-- SF の手順文用の言葉（地図が開ける名前）。クエスト単位で覚え、手順ごとに作り直さない
local function id_tail_name(id)
    local last = tostring(id or ''):match('%.([^%.]+)$') or ''
    last = last:gsub('_', ' ')
    if last ~= '' then return last end
    return nil
end

local function add_target_terms(D, terms, id)
    if not id then return end
    local tg = D:target(id)
    local k = (tg and tg.kind) or 'npc'
    if k ~= 'npc' and k ~= 'mob' and k ~= 'obj' and k ~= 'object' then k = 'npc' end
    if tg and tg.name_en and tg.name_en ~= '' then CT.add(terms, tg.name_en, k) end
    local derived = id_tail_name(id)
    if derived then CT.add(terms, derived, k) end
end

local function sf_terms(ui, q)
    local st = ui.state
    st.sf_terms = st.sf_terms or {}
    local cache = st.sf_terms
    if cache.q == q and cache.terms then return cache.terms end
    local D = ui.data
    local terms = CT.quest_terms(D, q)
    for _, s in ipairs(q.steps or {}) do
        add_target_terms(D, terms, s.target)
        for _, id in ipairs(type(s.extra_targets) == 'table' and s.extra_targets or {}) do
            add_target_terms(D, terms, id)
        end
        for _, text in ipairs({ s.next_line_ja or '', s.text_ja or '' }) do
            if D.parse_listed_names then
                for _, e in ipairs(D.parse_listed_names(text)) do
                    if e.name then CT.add(terms, e.name, 'npc') end
                end
            end
        end
    end
    cache.q = q
    cache.terms = terms
    return terms
end

local function poss_suffix(ui, n)
    local S = ui.settings
    if not (S.items and S.items.show_possession) then return nil end
    local s = ui.need_possession and ui.need_possession(n) or { state = 'unknown' }
    if s.state == 'unknown' then return nil end
    local t = ui.t
    if n.kind == 'key_item' or s.kind == 'key' then
        if s.state == 'missing' then return t('sf.poss_key_missing') end
        if s.state == 'owned' then return t('sf.poss_owned') end
        return nil
    end
    if s.have ~= nil and s.need ~= nil then
        return t('sf.poss_held', { have = s.have, need = s.need })
    end
    return nil
end

local function short_need_name(name)
    return poss_ui.short_need_name(name)
end

local function step_text_with_poss(ui, s, text)
    local out = poss_ui.apply_to_step(ui, s, text)
    return out
end

local function draw_detail_sf(ui, win, q, opts)
    opts = opts or {}
    local standalone = opts.standalone == true
    local imgui, t = ui.imgui, ui.t
    local P, D, S = ui.progress, ui.data, ui.settings
    -- 枠は外側の子窓に描き、中身は内側の子窓へ入れて四方の余白を共有する
    -- （一度 SetCursor しただけでは、次の行が x=0 に戻る）
    local FRAME_IN, PAD = 4, 12
    local wx, wy = sf.xy(pcall(imgui.GetWindowPos))
    local ww, wh = sf.xy(pcall(imgui.GetWindowSize))
    if wx and wy and ww and wh then
        sf.frame(dl_of(imgui), wx + FRAME_IN, wy + FRAME_IN, wx + ww - FRAME_IN, wy + wh - FRAME_IN, {
            cut = 8, fill_a = 0.10, line_a = 0.92, glow = 0, brackets = true,
            bracket_len = 10, thick = 1.4, band = false,
        })
    end
    local inset = FRAME_IN + PAD
    local inner_w = math.max(40, (ww or (select(1, sf.avail(imgui)) or 240)) - inset * 2)
    local inner_h = math.max(40, (wh or (sf.remain_below(imgui, inset) + inset)) - inset * 2)
    if wx and wy then sf.set_cursor(imgui, wx + inset, wy + inset) end
    local ok_inner = pcall(imgui.BeginChild, '##astertrail_sf_detail_inner', { inner_w, inner_h }, 0, 0)
    if ok_inner then window.push(ui, 'child') end
    if not q then
        W.muted(ui, t('book.detail_hint'))
        if ok_inner then window.pop(ui, 'child') end
        return
    end
    local marked = book.is_marked_unimplemented(S, q.id)
    font(ui, win, 1.42, true)
    theme.TextColored(imgui, theme.col(marked and 'muted' or 'heading'), labels.display_name(q))
    font(ui, win, 0.78, false)
    local sub = {}
    if q.mission_no and q.mission_no ~= '' then sub[#sub + 1] = q.mission_no end
    sub[#sub + 1] = t('kind.' .. (q.kind or 'quest'))
    local cat = D:category_label(q.category, S.language)
    if cat and cat ~= '' then sub[#sub + 1] = cat end
    theme.TextColored(imgui, theme.col('sf_cyan'), table.concat(sub, '  ·  '))
    font(ui, win, 1, false)
    if marked then W.muted(ui, t('roe.tag_failed.not_impl')) end

    local pinned = P:is_pinned(q.id)
    local can_pin = pinned or not marked
    do
        local stf = flow_start(imgui)
        local function put(id, lab, on, tip, fn)
            font(ui, win, 0.78, false)
            local w = chip_w(imgui, lab, 8)
            font(ui, win, 1, false)
            local cx, cy = flow_next(stf, w, 20)
            if chip(ui, win, id, lab, on, tip, { x = cx, y = cy }) then fn() end
        end
        put('pin', pinned and t('detail.unpin') or t('detail.pin'), pinned,
            (not can_pin) and t('book.pin_unimplemented') or nil,
            function () if can_pin then ui.request(pinned and 'unpin' or 'pin', q.id) end end)
        local um = marked and t('detail.clear_unimplemented') or t('detail.mark_unimplemented')
        put('unimplemented', um, marked,
            marked and t('detail.clear_unimplemented_tip') or t('detail.mark_unimplemented_tip'),
            function ()
                if book.toggle_unimplemented(S, q.id) and ui.mark_settings_dirty then ui.mark_settings_dirty() end
            end)
        -- 0.1.261〜：ゲームの受注フラグが無いものを未開始に戻す
        if P:state(q.id) ~= 'not_accepted' and ui.can_revert_unstarted and ui.can_revert_unstarted(q.id) then
            put('reset_unstarted', t('detail.reset_unstarted'), false, t('detail.reset_unstarted_tip'),
                function ()
                    if ui.revert_unstarted then ui.revert_unstarted(q.id) end
                end)
        end
        flow_end(imgui, stf)
    end
    if q.repeatable == 'yes' then W.muted(ui, t('detail.repeatable_yes'))
    elseif q.repeatable == 'no' then W.muted(ui, t('detail.repeatable_no')) end

    -- 独立した窓だけ：クラシックの詳細にある状態・確認・勧め（本の右ペインの見た目は変えない）
    if standalone then
        local state = P:state(q.id)
        W.text(ui, t('detail.state', { state = labels.state(t, state) }))
        local manual = (ui.manual_checks == nil) or ui.manual_checks()
        local state_buttons = manual and ui.state_buttons ~= nil and ui.state_buttons()
        if state_buttons then
            for i, stt in ipairs({ 'not_accepted', 'accepted', 'completed' }) do
                if i > 1 then W.same(ui) end
                local mark = (state == stt) and '◆' or '◇'
                if W.button(ui, win, 'state_' .. stt, mark .. ' ' .. t('state.' .. stt),
                    { section = 'state', row = 'state' }) then
                    ui.request('set_state', q.id, stt)
                end
            end
        end
        local st = ui.state
        if st.confirm and st.confirm.quest == q.id then
            W.colored(ui, 'warn', st.confirm.text)
            if W.button(ui, win, 'confirm_yes', t('common.yes'), { section = 'confirm', row = 'c' }) then
                ui.request(st.confirm.action, q.id, st.confirm.arg, true)
                st.confirm = nil
            end
            W.same(ui)
            if W.button(ui, win, 'confirm_no', t('common.no'), { section = 'confirm', row = 'c' }) then
                st.confirm = nil
            end
        end
        if state_buttons and st.suggest_complete == q.id and P:state(q.id) ~= 'completed' then
            W.colored(ui, 'good', t('detail.suggest_complete'))
            if W.button(ui, win, 'suggest_yes', t('detail.mark_complete'), { section = 'confirm', row = 's' }) then
                ui.request('set_state', q.id, 'completed')
                st.suggest_complete = nil
            end
            W.same(ui)
            if W.button(ui, win, 'suggest_no', t('common.later'), { section = 'confirm', row = 's' }) then
                st.suggest_complete = nil
            end
        end
    end

    local status = ui.player_status and ui.player_status() or nil
    local blocks, blocked = {}, false
    if P and D and P:state(q.id) == 'not_accepted' then
        blocks = marks_core.accept_blocks(D, P, q, status, ui.inventory_count)
        blocked = #blocks > 0
    end
    if blocked or (q.lock_reasons and #q.lock_reasons > 0) then
        W.muted(ui, t(blocked and 'detail.lock_reasons' or 'detail.lock_conditions'))
        if blocked then
            for _, b in ipairs(blocks) do
                local s = marks_core.block_text(t, b)
                if s and s ~= '' then W.muted(ui, '・' .. s) end
            end
        else
            for _, r in ipairs(q.lock_reasons or {}) do W.muted(ui, '・' .. (r.text_ja or '')) end
        end
    end

    section_label(ui, win, 'sf.label_objective')
    local cur = P:current_step(q.id)
    local routes = P.routes and P:routes(q.id) or {}
    local route = (#routes > 1) and P:chosen_route(q.id) or nil
    local st = ui.state
    st.show_all_routes = st.show_all_routes or {}
    local show_all = st.show_all_routes[q.id] == true
    if route then
        local stf = flow_start(imgui)
        font(ui, win, 0.80, false)
        local rlab = t('detail.route_chosen', { route = route })
        local rw = (select(1, theme.measure_text(imgui, rlab)) or 80) + 8
        local rx, ry = flow_next(stf, rw, 20)
        sf.add_text(dl_of(imgui), rx, ry, label_col('sf_cyan'), rlab)
        font(ui, win, 1, false)
        local function rchip(id, lab, on, fn)
            font(ui, win, 0.78, false)
            local w = chip_w(imgui, lab, 8)
            font(ui, win, 1, false)
            local cx, cy = flow_next(stf, w, 20)
            if chip(ui, win, id, lab, on, nil, { x = cx, y = cy }) then fn() end
        end
        for _, other in ipairs(routes) do
            if other ~= route then
                rchip('route_' .. other, t('detail.route_switch', { route = other }), false, function ()
                    ui.request('set_route', q.id, other)
                    st.show_all_routes[q.id] = nil
                end)
            end
        end
        rchip('route_all', show_all and t('detail.route_hide_others') or t('detail.route_show_all'), show_all, function ()
            st.show_all_routes[q.id] = (not show_all) or nil
        end)
        flow_end(imgui, stf)
    end

    -- 手順と REWARD/LOCATION が重ならないよう、残り高さに収める
    -- 内側の子窓にいるので、余白はもう載っている
    local rest = sf.remain_below(imgui, 4)
    -- 手順と REWARD/LOCATION のあいだに横線と余白を置く（0.1.273〜）
    local split_gap = (sf.rule_gap and sf.rule_gap()) or 13
    -- 下段は中身の高さに合わせ、K-6 などが切れないようにする（0.1.274〜）。手順側がスクロールする
    local min_steps, min_bot = 36, 80
    local need = bottom_fit[q.id] or 120
    local bottom_h = need
    -- 独立した窓（0.1.285〜）：手順の実測高さを使い、下段をその下に置く。
    -- 固定の下段バンドを先に取ると、足した場所／相手の行に REWARD が重なっていた。
    -- 足りなければ内側の子窓がスクロールする。本の右ペインは従来どおり下段を残して手順をスクロール。
    local need_steps = steps_fit[q.id]
    local flow_steps = standalone == true
    if (not flow_steps) and need_steps and rest >= need_steps + need + split_gap then
        bottom_h = need
    elseif (not flow_steps) and rest < bottom_h + min_steps + split_gap then
        bottom_h = math.max(min_bot, rest - min_steps - split_gap)
    end
    local steps_h
    if not flow_steps then
        if need_steps and rest >= need_steps + bottom_h + split_gap then
            steps_h = need_steps
        else
            steps_h = math.max(min_steps, rest - bottom_h - split_gap)
        end
    end
    local steps_top = select(2, sf.xy(pcall(imgui.GetCursorScreenPos)))
    local ok_steps = false
    if steps_h then
        ok_steps = pcall(imgui.BeginChild, '##astertrail_sf_steps', { 0, steps_h }, 0, 0)
        if ok_steps then window.push(ui, 'child') end
    end
    local shown, hidden = 0, 0
    local first_y, last_y, line_x
    local manual = (ui.manual_checks == nil) or ui.manual_checks()
    local step_lock = P.steps_locked and P:steps_locked(q.id) or false
    local map_on = S.map and S.map.enabled ~= false and ui.open_map
    if standalone and manual and step_lock then W.muted(ui, t('detail.steps_locked')) end
    local terms = sf_terms(ui, q)
    local tracker = require('src.ui.tracker')
    -- 丸はモックアップの ①②③ に近い大きさ。数字は CalcTextSize で中央へ
    local DOT_R, COL, ROW_GAP = 13, 32, 6
    for _, s in ipairs(q.steps or {}) do
        local in_route = (route == nil) or P.step_in_route(s, route)
        if not in_route and not show_all then
            hidden = hidden + 1
        else
            shown = shown + 1
            local done = P:step_done(q.id, s.id)
            local is_cur = cur and cur.id == s.id
            local n = route and shown or (s.order or shown)
            local text, poss_ex = poss_ui.apply_to_step(ui, s, s.next_line_ja or t('detail.step_no_text'), q)
            local step_terms = {}
            for _, x in ipairs(terms) do step_terms[#step_terms + 1] = x end
            poss_ui.merge_terms(step_terms, poss_ex)
            local has_multi = tracker.has_multi_map_targets(D, s)
            if has_multi then
                for _, c in ipairs(tracker.people_counts(text)) do CT.add(step_terms, c, 'group') end
            end
            local ax, ay = sf.xy(pcall(imgui.GetCursorScreenPos))
            local aw = select(1, sf.avail(imgui)) or 200
            local chk_w = manual and 22 or 0
            local text_col = COL + chk_w + 8
            font(ui, win, is_cur and 0.96 or 0.88, is_cur)
            local text_avail = math.max(40, (aw or 200) - text_col - 12)
            local _, th = theme.measure_text(imgui, text, text_avail)
            font(ui, win, 1, false)
            local row_h = math.max(DOT_R * 2 + 6, (th or 16) + 10)
            -- 今の手順の枠は丸とチェックに重ねず、チェックの右から始める（0.1.286〜）。
            -- 独立した窓では場所／相手などの行も含めた高さを使う（0.1.285〜）。
            -- 線は測ってから描く。先に 1 行分の枠を描くと、下の行に枠が重なっていた。
            local card_key = tostring(q.id) .. '\0' .. tostring(s.id)
            local guessed = step_card_h[card_key] or row_h
            local card_r = ax and (ax + math.max(80, aw) - 4) or nil
            local row_w = math.max(80, aw or 200)
            -- 手順行全体（①、チェック、本文と折り返し、独立詳細の足した行）を当たりにする。
            -- 先に置き、AllowOverlap で後のチェックや名前のリンクがクリックを受け取れるようにする。
            -- 枠はチェックの右から始める（6px 左へ寄せると ▢ に重なっていた）。
            local FRAME_GAP = 4
            local frame_x = ax and (ax + (manual and (COL + chk_w) or COL) + FRAME_GAP) or nil
            local row_clicked = false
            if ax and ay then
                -- 行全体の当たりは残す（0.1.286）。地・ホバーの塗りは出さない。
                -- そうしないと ▢ の下から枠の右・下にはみ出す別の塗りになる。
                local ninv = 0
                local function hide_hit_col(name)
                    if imgui.PushStyleColor then
                        pcall(imgui.PushStyleColor, theme.C(name), { 0, 0, 0, 0 })
                        ninv = ninv + 1
                    end
                end
                hide_hit_col('ImGuiCol_Button')
                hide_hit_col('ImGuiCol_ButtonHovered')
                hide_hit_col('ImGuiCol_ButtonActive')
                hide_hit_col('ImGuiCol_Header')
                hide_hit_col('ImGuiCol_HeaderHovered')
                hide_hit_col('ImGuiCol_HeaderActive')
                hide_hit_col('ImGuiCol_FrameBg')
                hide_hit_col('ImGuiCol_FrameBgHovered')
                hide_hit_col('ImGuiCol_FrameBgActive')
                -- 0.1.307：実機の ImGui では SetItemAllowOverlap が効かず、先に置いた行の当たりが
                -- NPC・対象・アイテム名のクリックを全部取っていた（詳細から地図が開かなかった）。
                -- 後の部品に譲れる SetNextItemAllowOverlap があるときだけ当たりを置き、
                -- 無いときは下のマウス位置の判定だけで行を選ぶ
                if imgui.SetNextItemAllowOverlap then
                    sf.set_cursor(imgui, ax, ay)
                    pcall(imgui.SetNextItemAllowOverlap)
                    row_clicked = sf.hit(imgui, '##sfstep_' .. s.id, row_w, math.max(1, guessed))
                end
                if ninv > 0 and imgui.PopStyleColor then pcall(imgui.PopStyleColor, ninv) end
                sf.set_cursor(imgui, ax, ay)
            end
            local cx, cy
            if ax and ay then
                cx, cy = ax + DOT_R + 2, ay + DOT_R + 2
                line_x = line_x or cx
                first_y = first_y or cy
                last_y = cy
                sf.step_dot(dl_of(imgui), cx, cy, DOT_R, n, { current = is_cur })
                font(ui, win, 0.96, true)
                local nw, nh = theme.measure_text(imgui, tostring(n))
                nw, nh = nw or 8, nh or 14
                sf.add_text(dl_of(imgui), cx - nw * 0.5, cy - nh * 0.5, label_col(is_cur and 'heading' or 'muted'), tostring(n))
                font(ui, win, 1, false)
            end
            imgui.Dummy({ COL, math.max(1, DOT_R * 2) })
            imgui.SameLine(0, 6)
            local chk_clicked, chk_x1, chk_y1, chk_x2, chk_y2 = false, nil, nil, nil, nil
            if manual then
                local locked = (not done) and step_lock
                if W.button(ui, win, 'chk_' .. s.id, done and '■' or '□', {
                    section = 'steps', row = s.id, small = true, no_focus = true,
                    disabled = locked,
                    tooltip = locked and t('detail.check_locked') or (done and t('detail.uncheck') or t('detail.check')),
                }) then
                    chk_clicked = true
                    ui.request(done and 'uncheck_step' or 'check_step', q.id, s.id)
                end
                chk_x1, chk_y1, chk_x2, chk_y2 = sf.item_rect(imgui)
                if ax and chk_x2 then
                    frame_x = chk_x2 + FRAME_GAP
                end
                imgui.SameLine(0, 6)
            end
            -- 折り返し行は、手順文の開始列（丸とチェックの右）にぶら下げる
            local hang_x
            do
                local okp, a, b = pcall(imgui.GetCursorPos)
                if okp then hang_x = select(1, sf.xy(true, a, b)) or a end
                if type(hang_x) ~= 'number' then hang_x = text_col end
            end
            font(ui, win, is_cur and 0.96 or 0.88, is_cur)
            local hit = W.term_line(ui, win, 'step_' .. s.id, text, step_terms, {
                section = 'steps', row = s.id, muted = not is_cur, hang_x = hang_x,
                wrap_width = text_avail,
                focus_acts = { map = true },
                tip = function (act, piece)
                    if piece and piece.tip then return piece.tip end
                    if act == 'map' and piece and piece.kind == 'group' then return t('tracker.map_all') end
                    if act == 'map' then return t('map.view') end
                    if act == 'copy' then return t('tracker.copy_item') end
                end,
            })
            font(ui, win, 1, false)
            local consumed = chk_clicked
            if hit and hit.act == 'map' then
                consumed = true
                if hit.kind == 'group' then
                    ui.open_map(q.id, s.id)
                else
                    local msid, mloc, mtg = tracker.map_target(D, q, hit.text, s.id)
                    if mtg and mtg.kind == 'mob' then
                        ui.open_map(q.id, msid, mloc, { mob = mtg.id })
                    elseif msid then
                        ui.open_map(q.id, msid, mloc)
                    else
                        local tg = s.target and D:target(s.target)
                        if tg and tg.kind == 'mob' then ui.open_map(q.id, s.id, nil, { mob = s.target })
                        else ui.open_map(q.id, s.id) end
                    end
                end
            elseif hit and hit.act == 'copy' and ui.copy_to_clipboard then
                consumed = true
                ui.copy_to_clipboard(hit.text)
            end
            if has_multi and map_on and #tracker.people_counts(text) == 0 then
                imgui.SameLine(0, 6)
                font(ui, win, 0.88, false)
                if W.link(ui, win, 'step_' .. s.id .. '_group_map', t('map.view_short'), {
                    color = 'sf_cyan', section = 'steps', row = s.id, no_focus = true,
                    tooltip = t('tracker.map_all'),
                }) then
                    consumed = true
                    ui.open_map(q.id, s.id)
                end
                font(ui, win, 1, false)
            end
            -- 本の右ペインでは「相手：」「所持：」の別行は出さない（名前のクリックと、文中の所持表示に任せる）
            -- 独立した窓では、クラシックと同じ詳しい行をアストラルの色で足す（0.1.284〜）
            -- 0.1.285〜：これらの行はタイムラインの線の右、手順文と同じ列から始める。
            local function indent_extra()
                if hang_x and imgui.SetCursorPosX then
                    pcall(imgui.SetCursorPosX, hang_x)
                elseif ax then
                    local _, cy = cursor(imgui)
                    if cy then sf.set_cursor(imgui, ax + text_col, cy) end
                end
            end
            local extra_opts = { hang_x = hang_x, wrap_width = text_avail }
            if standalone then
                font(ui, win, 0.82, false)
                local loc = D:location_text(s, t)
                if loc and loc ~= '' then
                    indent_extra()
                    W.ctext(ui, t('detail.where', { loc = loc }), step_terms, extra_opts)
                end
                local rname = (type(s.routes_ja) == 'table' and #s.routes_ja > 0) and table.concat(s.routes_ja, ' / ') or s.route_ja
                if rname and rname ~= '' then
                    indent_extra()
                    W.muted(ui, t('detail.route', { route = rname }) ..
                        ((not in_route) and ('  ' .. t('detail.route_other')) or ''))
                end
                if s.text_ja and s.text_ja ~= '' then
                    indent_extra()
                    W.ctext(ui, s.text_ja, step_terms, extra_opts)
                end
                if s.time_weather_ja then
                    indent_extra()
                    W.colored(ui, 'warn', labels.time_weather(t, s.time_weather_ja, ui.current_weather and ui.current_weather()))
                end
                if s.needs and #s.needs > 0 then
                    local parts, alt = {}, false
                    for _, n in ipairs(s.needs) do
                        parts[#parts + 1] = labels.need(t, n)
                        if n.group then alt = true end
                    end
                    local joined = table.concat(parts, alt and t('need.or') or '、')
                    indent_extra()
                    W.ctext(ui, t('detail.needs', { list = joined }), step_terms, extra_opts)
                    if S.items and S.items.show_possession then
                        indent_extra()
                        poss_ui.draw_inline(ui, s.needs, win, 'd' .. s.id)
                    end
                end
                if s.next and #s.next > 1 then
                    indent_extra()
                    W.colored(ui, 'warn', t('detail.branch'))
                end
                local tn = D:target_name(s.target)
                if tn then
                    local tg = s.target and D:target(s.target)
                    local tloc = (s.location and s.location.zone_id) or (tg and tg.location and tg.location.zone_id)
                    local kind = (tg and tg.kind) or 'npc'
                    local can = map_on and tloc
                    local col = CT.KIND_COLOR and (CT.KIND_COLOR[kind] or 'npc') or 'npc'
                    indent_extra()
                    if W.named(ui, win, 'map_' .. s.id, t('detail.target', { name = '{name}' }), tn, {
                        color = col, click = can, section = 'steps', row = s.id .. '#target',
                        tooltip = can and t('map.view') or nil, muted = true,
                    }) then
                        consumed = true
                        if kind == 'mob' then ui.open_map(q.id, s.id, nil, { mob = s.target }) else ui.open_map(q.id, s.id) end
                    end
                end
                font(ui, win, 1, false)
            end
            local _, cy2 = cursor(imgui)
            local card_h = row_h
            if ay and cy2 then card_h = math.max(card_h, (cy2 - ay) + (standalone and 6 or 0)) end
            step_card_h[card_key] = card_h
            -- 今の手順の塗りは、測った枠と同じ矩形。線の太さと角の切れの分だけ内側へ。
            -- 先に guessed で塗ると、チェック前の frame_x や高さが枠とずれてはみ出していた（0.1.290〜）。
            if is_cur and ax and ay and card_r and frame_x then
                local x1, y1, x2, y2 = frame_x, ay, card_r, ay + card_h
                local thick, cut = 1.4, 5
                sf.fill_cut(dl_of(imgui), x1 + thick, y1 + thick, x2 - thick, y2 - thick,
                    math.max(2, cut - thick), theme.u32('sf_cyan', 0.28))
                sf.frame(dl_of(imgui), x1, y1, x2, y2, {
                    cut = cut, fill_a = 0, line_a = 0.95, glow = 1, brackets = false,
                    thick = thick, band = false, glow_col = theme.u32('sf_cyan', 0.75),
                })
            end
            -- ①・本文・折り返し・余白など、行のどこを押しても今の手順にする。
            -- チェックと、NPC／対象／アイテム名の動作は上で消費済み。
            -- 名前の InvisibleButton が行の当たりを奪っても、マウスが行の中なら拾う。
            if ax and ay and not consumed then
                local over_chk = chk_x1 and mouse_in(imgui, chk_x1, chk_y1, chk_x2, chk_y2)
                local over_row = mouse_in(imgui, ax, ay, ax + row_w, ay + card_h)
                local clicked_mouse = imgui.IsMouseClicked and imgui.IsMouseClicked(0)
                -- ほかの窓が上に重なっているときは拾わない
                if clicked_mouse and imgui.IsWindowHovered then
                    local okh, hv = pcall(imgui.IsWindowHovered)
                    if okh and hv == false then clicked_mouse = false end
                end
                if row_clicked or (clicked_mouse and over_row and not over_chk) then
                    ui.request('set_current_step', q.id, s.id)
                end
            end
            if ay and cy2 and cy2 < ay + card_h then
                imgui.Dummy({ 1, (ay + card_h) - cy2 })
            end
            -- 縦線は最後の手順の本文の下まで（ドット中心だけだと、下の行を横切って見える）
            if ay then last_y = math.max(last_y or ay, ay + card_h) end
            imgui.Dummy({ 1, ROW_GAP })
        end
    end
    if line_x and first_y and last_y and last_y > first_y + 8 then
        sf.vline(dl_of(imgui), line_x, first_y + 10, last_y - 10, theme.u32('sf_cyan', 0.40), 1.2)
    end
    if hidden > 0 then W.muted(ui, t('detail.route_hidden', { n = hidden })) end
    do
        local steps_bot = select(2, sf.xy(pcall(imgui.GetCursorScreenPos)))
        if steps_top and steps_bot and steps_bot > steps_top then
            steps_fit[q.id] = (steps_bot - steps_top) + 4
        end
    end
    if ok_steps then window.pop(ui, 'child') end
    -- 手順の下、REWARD / LOCATION の上。文字に重ねず、ペインの内側いっぱい
    if sf.rule then
        sf.rule(imgui)
    else
        pcall(function () if imgui.NewLine then imgui.NewLine() end end)
    end
    do
        local left = sf.remain_below(imgui, 4)
        if left < bottom_h then bottom_h = math.max(48, left) end
    end

    -- 下段：REWARD と LOCATION（手順の下。重ならない）
    local ok_bot = pcall(imgui.BeginChild, '##astertrail_sf_bottom', { 0, bottom_h }, 0, 0)
    if ok_bot then window.push(ui, 'child') end
    local aw = select(1, sf.avail(imgui)) or 400
    local split = 12
    local left_w = math.max(140, math.floor((aw - split) * 0.52))
    local bx, by = sf.xy(pcall(imgui.GetCursorScreenPos))
    -- REWARD | LOCATION のあいだに薄い縦線（横線とは別。スクロールバーと混同しない）
    if bx and by and sf.vline then
        local vx = bx + left_w + split * 0.5
        local col = theme.u32('sf_cyan', 0.42)
        pcall(function ()
            local dl = dl_of(imgui)
            if dl then
                dl:AddLine({ vx, by + 4 }, { vx, by + math.max(8, bottom_h - 8) }, theme.u32('sf_cyan', 0.14), 4)
                sf.vline(dl, vx, by + 4, by + math.max(8, bottom_h - 8), col, 1.0)
            end
        end)
    end
    local ok_rw = pcall(imgui.BeginChild, '##astertrail_sf_rew', { left_w, 0 }, 0, 0)
    if ok_rw then window.push(ui, 'child') end
    local rew_top = select(2, sf.xy(pcall(imgui.GetCursorScreenPos)))
    section_label(ui, win, 'sf.label_reward')
    if q.rewards and #q.rewards > 0 then
        for _, r in ipairs(q.rewards) do
            local text = labels.reward(t, r)
            if r.kind == 'item' or r.kind == 'key_item' then
                local nm = r.name_ja or r.name_en or ''
                local hit = W.term_line(ui, win, 'rw_' .. tostring(nm), text, CT.add({}, nm, 'item', { copy_text = nm }), {
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
    if standalone and q.note_ja then W.muted(ui, q.note_ja) end
    local rew_bot = select(2, sf.xy(pcall(imgui.GetCursorScreenPos)))
    if ok_rw then window.pop(ui, 'child') end

    imgui.SameLine(0, split)
    local ok_lc = pcall(imgui.BeginChild, '##astertrail_sf_loc', { 0, 0 }, 0, 0)
    if ok_lc then window.push(ui, 'child') end
    local loc_top = select(2, sf.xy(pcall(imgui.GetCursorScreenPos)))
    section_label(ui, win, 'sf.label_location')
    local lines, sl = loc_lines(ui, q)
    local place = D:start_place_text(q)
    if lines then
        for _, ln in ipairs(lines) do
            theme.TextColored(imgui, theme.col('text'), ln)
        end
    elseif place then
        theme.TextColored(imgui, theme.col('text'), place)
    end
    local npc = D:start_npc_name(q)
    if npc then
        local can = map_on and sl and sl.zone_id
        if W.named(ui, win, 'open_map', t('detail.start_npc', { name = '{name}' }), npc, {
            color = 'npc', click = can, section = 'd_view', row = 'v',
            tooltip = can and t('map.view') or nil, muted = true,
        }) then
            ui.open_map(q.id)
        end
    end
    -- 右下の小さな方位磁針（装飾）。窓の矩形の内側に収める
    do
        local wx, wy = sf.xy(pcall(imgui.GetWindowPos))
        local ww, wh = sf.xy(pcall(imgui.GetWindowSize))
        if wx and wy and ww and wh and ww > 24 and wh > 24 then
            local r, m, nspace = 14, 8, 12
            local fit_w = ww / 2 - m - 2
            local fit_h = wh - nspace - m - 4
            if r > fit_w then r = math.max(8, fit_w) end
            if r > fit_h then r = math.max(8, fit_h) end
            local cx = wx + ww - m - r
            local cy = wy + wh - m - r
            if sf.compass_rose then sf.compass_rose(dl_of(imgui), cx, cy, r) end
            font(ui, win, 0.62, true)
            local nw = select(1, theme.measure_text(imgui, 'N')) or 6
            local ny = cy - r - 2 - 8
            if ny < wy + 2 then ny = wy + 2 end
            sf.text_at(imgui, cx - nw * 0.5, ny, function ()
                theme.TextColored(imgui, theme.col('sf_cyan'), 'N')
            end)
            font(ui, win, 1, false)
        end
    end
    local loc_bot = select(2, sf.xy(pcall(imgui.GetCursorScreenPos)))
    -- 方位磁針と文字が重ならないよう、下に余白を見る
    local loc_need = 0
    if loc_top and loc_bot then loc_need = (loc_bot - loc_top) + 36 end
    local rew_need = 0
    if rew_top and rew_bot then rew_need = (rew_bot - rew_top) + 8 end
    local fitted = math.max(min_bot or 80, rew_need, loc_need, 72)
    bottom_fit[q.id] = fitted
    if ok_lc then window.pop(ui, 'child') end
    if ok_bot then window.pop(ui, 'child') end
    if ok_inner then window.pop(ui, 'child') end
end

local function toggle_map(ui)
    if not ui.open_window then return end
    if ui.state.open and ui.state.open.map then
        if ui.close_window then ui.close_window('map') end
    elseif ui.open_map then
        -- 0.1.308〜：閉じているときは、いまいるエリアの地図を開く
        ui.open_map(nil, nil, nil, { here = true })
    else
        ui.open_window('map')
    end
end

local function finish_book(ui, name, S, open)
    local pref, force_pref
    if ui.state.book_nav_pending then
        pref = ui.state.book_nav_pending
        ui.state.book_nav_pending = nil
        force_pref = true
    elseif ui.state.book_enter_table then
        pref = book.list_focus_id(ui)
        force_pref = pref ~= nil
        ui.state.book_enter_table = nil
    else
        if ui.state.book_jump_row then
            ui.state.book_jump_row = nil
            if S.book.tab == 'eminence' then
                local em = require('src.ui.eminence')
                local sid = em.selected and em.selected()
                pref = sid and ('roesel_' .. tostring(sid)) or nil
            elseif S.book.last_row then
                pref = 'row_' .. S.book.last_row
            end
            force_pref = pref ~= nil
        end
        if not pref then
            local hid = book.visible_heading(ui, book.display_heading(ui))
            pref = book.tree_wid(book.split_tab(S), hid)
        end
    end
    window.finish(ui, name, pref)
    if force_pref and pref then focus.set(name, pref, true) end
    if not open[1] and ui.state.open.book then ui.close_window(name) end
end

function book_sf.draw(ui)
    local imgui, t, S = ui.imgui, ui.t, ui.settings
    local open = { true }
    local name = 'book'
    local drawing = window.begin(ui, name, {
        title = t('book.title'), open = open, operable = true, fixed_top = true,
        no_title = true, sf_frame = true,
    })
    if drawing then
        do
            if ui.state.book_restore_scroll then ui.state.book_restore_tree_scroll = true end
            if ui.state.book_expand_path then ui.state.book_expand_path = nil end
        end
        book._nav_ui = ui
        book._nav_tree = book.nav_tree(ui)

        local settings_on = ui.state.open.settings == true
        focus.set_shows_frame(name, not (settings_on and ui.state.active == 'settings'))
        focus.set_areas(name, book.area_of)

        -- 上の行：大きいロゴ、同じ高さのタブ、右に次の目標（SameLine に頼らず基準線を固定）
        do
            local hx, hy = cursor(imgui)
            hx, hy = hx or 0, hy or 0
            local _, logo_w, logo_h = draw_logo(ui, name, hx, hy)
            logo_w, logo_h = logo_w or 160, logo_h or 36
            local tabs = { 'mission', 'quest', 'eminence' }
            local gap = 10
            local x = hx + logo_w + 16
            local tab_h = logo_h
            for _, tab in ipairs(tabs) do
                local clicked, tw, th = draw_tab(ui, name, 'tab_' .. tab, t('sf.tab.' .. tab), S.book.tab == tab, x, hy)
                tw, th = tw or 80, th or 32
                if th > tab_h then tab_h = th end
                if clicked then
                    S.book.tab = tab
                    ui.mark_settings_dirty()
                    ui.state.book_restore_scroll = true
                    if settings_on then ui.close_window('settings'); settings_on = false end
                end
                x = x + tw + gap
            end
            -- 次の目標はタブの右〜窓の内側の右端に収める（枠の余白を残す）
            local wx, wy = sf.xy(pcall(imgui.GetWindowPos))
            local ww = select(1, sf.xy(pcall(imgui.GetWindowSize)))
            local inset = 16
            local right = (wx and ww) and (wx + ww - inset) or nil
            draw_next_goal(ui, name, { y = hy, left_min = x + 8, right = right })
            local header_h = math.max(logo_h, tab_h, 44)
            sf.set_cursor(imgui, hx, hy + header_h + 6)
        end

        local emin = S.book.tab == 'eminence'
        local footer_h = 28
        pcall(function () if imgui.NewLine then imgui.NewLine() end end)
        -- 残りの高さは画面座標で測る（Avail が窓全体を返すと、子が下にはみ出して枠が切れる）
        local body_h = math.max(80, sf.remain_below(imgui, footer_h + 10))
        local rail_w = 48

        local ok_rail = pcall(imgui.BeginChild, '##astertrail_sf_rail', { rail_w, body_h }, 0, 0)
        if ok_rail then window.push(ui, 'child') end
        local tr_on = S.tracker.visible == true
        local em_on = S.eminence and S.eminence.visible == true
        local cp_on = S.compass and S.compass.visible == true
        local map_on = ui.state.open and ui.state.open.map == true
        if rail_btn(ui, name, 'compass_toggle', sf.icon_compass, t(cp_on and 'book.compass_on' or 'book.compass_off'), cp_on) then
            if ui.toggle_compass then ui.toggle_compass() end
        end
        if rail_btn(ui, name, 'open_map', sf.icon_map, t('map.view'), map_on) then
            toggle_map(ui)
        end
        if rail_btn(ui, name, 'tracker_toggle', sf.icon_star, t(tr_on and 'book.tracker_on' or 'book.tracker_off'), tr_on) then
            if ui.toggle_tracker then ui.toggle_tracker() end
        end
        if rail_btn(ui, name, 'eminence_toggle', sf.icon_check, t(em_on and 'book.eminence_on' or 'book.eminence_off'), em_on) then
            if ui.toggle_eminence then ui.toggle_eminence() end
        end
        if rail_btn(ui, name, 'open_settings', sf.icon_gear, t(settings_on and 'book.settings_close' or 'book.settings'), settings_on) then
            if settings_on then ui.close_window('settings') else ui.open_window('settings') end
        end
        if ok_rail then window.pop(ui, 'child') end

        imgui.SameLine(0, 8)
        local ok_body = pcall(imgui.BeginChild, '##astertrail_sf_body', { 0, body_h }, 0, 0)
        if ok_body then window.push(ui, 'child') end

        if settings_on then
            require('src.ui.settings_ui').body(ui)
        elseif emin then
            require('src.ui.eminence_sf').book_body(ui, name)
        else
            local f = S.book.filters
            if type(f.show) ~= 'table' then
                f.show = { accepted = true, not_accepted = true, completed = true, unimplemented = true }
            end
            if f.show.unimplemented == nil then f.show.unimplemented = true end
            local st = ui.state
            local filters_on = st.sf_filters_open == true

            -- コンパクトな1行：絞り込みボタンと、今の見出し。検索や地域の列は折りたたむ
            if chip(ui, name, 'filters', t('sf.filter'), filters_on, t('book.show_tip'), { scale = 0.80, bold = true, pad_x = 10, pad_y = 4 }) then
                st.sf_filters_open = not filters_on
                filters_on = st.sf_filters_open
            end
            imgui.SameLine(0, 8)
            local list = book.filtered(ui)
            local heading_id = book.prepare_heading(ui, list)
            local nodes = book.tree_nodes(ui) or {}
            local function find(ns, id)
                for _, n in ipairs(ns or {}) do
                    if tostring(n.id) == tostring(id) then return n end
                    local hit = find(n.children, id)
                    if hit then return hit end
                end
            end
            local cur_hd = find(nodes, heading_id)
            local hd_label = cur_hd and book.heading_label(cur_hd.label, cur_hd.done, cur_hd.total) or t('filter.all')
            chip(ui, name, 'hd_cur', hd_label, true, nil)

            if filters_on then
                -- 検索は単独の行にして、ヒントが切れない幅を取る
                sf.break_row(imgui)
                book.draw_filters(ui, name, false, 'tabs', function (rest)
                    return math.max(260, math.min(460, (tonumber(rest) or 400) - 16))
                end, false)
                -- 検索欄の右に状態チップが並ばないよう、次の行から始める
                sf.break_row(imgui)
                -- 状態チップ・地域チップは基準線フロー（SameLine 禁止）
                local function flow_chips(items)
                    local stf = flow_start(imgui)
                    for _, it in ipairs(items) do
                        font(ui, name, 0.78, it.bold)
                        local need = chip_w(imgui, it.label, it.pad_x or 8)
                        local ch = 14 + 6
                        font(ui, name, 1, false)
                        local cx, cy = flow_next(stf, need, ch)
                        if chip(ui, name, it.id, it.label, it.on, it.tip, { x = cx, y = cy, pad_x = it.pad_x, bold = it.bold }) then
                            if it.on_click then it.on_click() end
                        end
                    end
                    flow_end(imgui, stf)
                end
                do
                    local items = {}
                    for _, k in ipairs(book.SHOW_STATES) do
                        local on = f.show[k] ~= false
                        items[#items + 1] = {
                            id = 'show_' .. k, label = t('state.' .. k), on = on, tip = t('book.show_tip'),
                            on_click = function ()
                                f.show[k] = not on
                                ui.mark_settings_dirty()
                            end,
                        }
                    end
                    local on_u = f.show.unimplemented ~= false
                    items[#items + 1] = {
                        id = 'show_unimplemented', label = t('state.unimplemented'), on = on_u,
                        tip = t('book.show_unimplemented_tip'),
                        on_click = function ()
                            f.show.unimplemented = not on_u
                            ui.mark_settings_dirty()
                        end,
                    }
                    flow_chips(items)
                end
                local function chips_of(ns)
                    local items = {}
                    for _, n in ipairs(ns or {}) do
                        local lab = book.heading_label(n.label, n.done, n.total)
                        local on = tostring(heading_id) == tostring(n.id)
                        items[#items + 1] = {
                            id = 'hd_' .. tostring(n.id), label = lab, on = on,
                            on_click = function ()
                                if book.set_heading(S, book.split_tab(S), n.id, function () ui.mark_settings_dirty() end) then
                                    if ui.state then ui.state.book_heading_changed = true end
                                end
                            end,
                        }
                    end
                    flow_chips(items)
                end
                chips_of(nodes)
                if cur_hd and cur_hd.children and #cur_hd.children > 0 then
                    chips_of(cur_hd.children)
                end
            end

            -- 見出しを折りたたみ内で変えたあとも、同じ list / heading でカードを組む
            heading_id = book.prepare_heading(ui, list)
            local shown = book.entries_under_heading(ui, heading_id, list)
            shown = book_sf.sort_cards(ui, shown)
            book.follow_focus_row(ui, name, shown)
            local selected, fallback = book.ensure_visible_row(S, shown, function () ui.mark_settings_dirty() end)
            book.remember_shown(S.book.tab, shown)
            local sel_q = selected and ui.data:quest(selected) or nil
            local force_table_top = fallback or (ui.state and ui.state.book_heading_changed)
            if ui.state then ui.state.book_heading_changed = nil end

            -- 見出しチップが SameLine のままだと、カードと詳細の子窓が同じ行の右（画面外）に出る
            pcall(function () if imgui.NewLine then imgui.NewLine() end end)
            local rem_w = select(1, sf.avail(imgui)) or 800
            -- カードと詳細の高さは、この子窓の下端までの実測。絞り込みを開いた分だけ短くなる。
            local rem_h = math.max(80, sf.remain_below(imgui, 8))
            local cards_w = book.sf_cards_width(S, rem_w, S.book.tab)

            local ok_cards = pcall(imgui.BeginChild, '##astertrail_sf_cards', { cards_w, rem_h }, 0, 0)
            if ok_cards then window.push(ui, 'child') end
            window.set_font(ui, book.list_scale(ui))
            if ui.state and ui.state.book_restore_scroll then
                book.apply_scroll(ui, S.book.tab, force_table_top)
            elseif force_table_top then
                book.apply_scroll(ui, S.book.tab, true)
            end
            if #ui.data.errors > 0 then
                for _, e in ipairs(ui.data.errors) do
                    W.colored(ui, 'warn', t('data.file_error', { file = e.file }))
                end
            end
            if #shown == 0 then
                W.muted(ui, t('book.empty'))
            else
                local ok_draw, err = pcall(function ()
                    local pane_w = select(1, sf.avail(imgui)) or cards_w
                    if pane_w < 80 then pane_w = cards_w end
                    local cols = 3
                    if pane_w < 540 then cols = 2 end
                    if pane_w < 300 then cols = 1 end
                    local gap = 8
                    local cw = math.max(80, math.floor((pane_w - gap * (cols - 1)) / cols))
                    local card_h, row_h = 108, 108 + 8
                    local n = #shown
                    local rows = math.ceil(n / cols)
                    local sy = (sf.scroll_y and sf.scroll_y(imgui)) or 0
                    local view_h = select(2, sf.avail(imgui)) or 300
                    local r0 = math.floor((sy - row_h) / row_h)
                    local r1 = math.ceil((sy + view_h + row_h) / row_h)
                    if r0 < 0 then r0 = 0 end
                    if r1 > rows - 1 then r1 = rows - 1 end
                    local function draw_row(row)
                        for col = 0, cols - 1 do
                            local i = row * cols + col + 1
                            if i > n then break end
                            local q = shown[i]
                            if col > 0 then imgui.SameLine(0, gap) end
                            imgui.BeginGroup()
                            local clicked, dbl = draw_card(ui, name, q, selected == q.id, cw)
                            imgui.Dummy({ cw, 0 })
                            imgui.EndGroup()
                            if dbl and ui.open_detail_solo then
                                ui.open_detail_solo(q.id)
                            elseif clicked and ui.select_in_book then
                                ui.select_in_book(q.id, true)
                            end
                        end
                    end
                    -- 画面外の行は Dummy 1つで飛ばす。カーソルの Y が進まない環境（テスト）では全行を描く。
                    local y_before = select(2, cursor(imgui))
                    if r0 > 0 then imgui.Dummy({ 1, r0 * row_h }) end
                    if r0 <= r1 then draw_row(r0) end
                    local y_after = select(2, cursor(imgui))
                    local y_moves = y_before and y_after and (y_after > y_before + 2)
                    if (not y_moves) and r0 == 0 then
                        for row = 1, rows - 1 do draw_row(row) end
                    else
                        for row = r0 + 1, r1 do draw_row(row) end
                        if r1 + 1 < rows then imgui.Dummy({ 1, (rows - r1 - 1) * row_h }) end
                    end
                end)
                if not ok_draw then
                    W.muted(ui, t('book.empty'))
                    if ui.diag and ui.diag.log then pcall(ui.diag.log, 'book_sf', err) end
                end
            end
            if not (ui.state and ui.state._table_scroll_captured) then
                book.capture_scroll(ui, S.book.tab)
            end
            if ui.state then ui.state._table_scroll_captured = nil end
            if ok_cards then window.pop(ui, 'child') end

            imgui.SameLine(0, 0)
            book.sf_cards_splitter(ui, S, rem_w, cards_w, rem_h, S.book.tab)
            imgui.SameLine(0, 0)
            local ok_det = pcall(imgui.BeginChild, '##astertrail_sf_detail', { 0, rem_h }, 0, 0)
            if ok_det then window.push(ui, 'child') end
            window.set_font(ui, window.font_scale(ui, 'detail'))
            book.detail_anchor(ui, name)
            if sel_q then
                draw_detail_sf(ui, name, sel_q)
            else
                W.muted(ui, t('book.detail_hint'))
            end
            if ok_det then window.pop(ui, 'child') end
        end
        if ok_body then window.pop(ui, 'child') end

        -- 下の細い状態行（作り話の BUILD は入れない。待ち・読み取り専用など本物の案内と閉じる）
        sf.break_row(imgui)
        pcall(function () ui.status_line() end)
        imgui.SameLine(0, 10)
        do
            local rest = select(1, sf.avail(imgui))
            local cw = (select(1, theme.measure_text(imgui, t('common.close'))) or 40) + 20
            if rest and rest > cw + 4 then
                pcall(function ()
                    local x = imgui.GetCursorPosX()
                    imgui.SetCursorPosX(x + rest - cw)
                end)
            end
            if chip(ui, name, 'close', t('common.close'), false, nil) then open[1] = false end
        end
    end
    finish_book(ui, name, S, open)
end

function book_sf.sort_cards(ui, list)
    list = list or {}
    local P = ui and ui.progress
    local rows = {}
    for i, q in ipairs(list) do
        local st = P and P:state(q.id) or 'not_accepted'
        local rank = 2
        if st == 'accepted' then rank = 1
        elseif st == 'completed' then rank = 3
        end
        rows[i] = { q = q, i = i, rank = rank }
    end
    table.sort(rows, function (a, b)
        if a.rank ~= b.rank then return a.rank < b.rank end
        return a.i < b.i
    end)
    local out = {}
    for i, r in ipairs(rows) do out[i] = r.q end
    return out
end

book_sf._step_text_with_poss = step_text_with_poss
book_sf._short_need_name = short_need_name
book_sf.draw_detail = draw_detail_sf

return book_sf
