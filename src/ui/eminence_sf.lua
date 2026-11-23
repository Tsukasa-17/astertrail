--[[
  Astertrail - SF テーマのエミネンス（0.1.262〜）
  本のミッション／クエストと同じ：面取りタブは book_sf 側、ここはカード格子と詳細。
  見えるカードだけ描き、一覧は署名が同じあいだ使い回す。クラシック／YunaUI の画面は変えない。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local theme = require('src.ui.theme')
local focus = require('src.ui.focus')
local book = require('src.ui.book')
local eminence = require('src.ui.eminence')
local sf = require('src.ui.sf_style')
local util = require('src.lib.util')
local roe = require('src.core.roe')
local roe_cycle = require('src.core.roe_cycle')

local eminence_sf = {}

local cache = { sig = nil, shown = nil, empty = nil, extra = nil, heading = nil }

local function font(ui, win, mul, bold)
    window.set_font(ui, window.font_scale(ui, 'book') * (mul or 1), bold and { bold = true } or nil)
end

local function dl_of(imgui)
    if imgui.GetWindowDrawList then
        local ok, dl = pcall(imgui.GetWindowDrawList)
        if ok then return dl end
    end
    return nil
end

local function cursor(imgui)
    local x, y
    if imgui.GetCursorScreenPos then
        local ok, a, b = pcall(imgui.GetCursorScreenPos)
        if ok then
            if type(a) == 'table' then return tonumber(a.x or a[1]), tonumber(a.y or a[2]) end
            return tonumber(a), tonumber(b)
        end
    end
    return x, y
end

local function chip_w(imgui, label, pad_x)
    local tw = select(1, theme.measure_text(imgui, label)) or 40
    return tw + (pad_x or 8) * 2
end


-- 0.1.321〜：エミネンスの状態の札の色（枠と文字）。mode は cycle_of の mode、cyc は区分
function eminence_sf.state_color(mode, cyc)
    if mode == 'active' then return 'roe_st_active' end
    if mode == 'done' then return 'roe_st_done' end
    if mode == 'wait' then
        if cyc and cyc.unimpl then return 'roe_st_unimpl' end
        local r = cyc and cyc.reason
        if r == 'other_leader' then return 'roe_st_other' end
        if r == 'timed_auto' then return 'roe_st_auto' end
        return 'roe_st_open'
    end
    return 'roe_st_open'
end

-- 受注・解除の札（押せる）。0.1.321〜：受注＝#80ADC7、解除（受注中）＝紫ピンク。乗せる・押すと濃く
local function action_look(op, hover, press)
    local key = (op == 'start') and 'roe_st_open' or 'roe_st_active'
    local fa = press and 0.30 or (hover and 0.20 or 0.10)
    local la = press and 1.0 or (hover and 1.0 or 0.85)
    return theme.u32(key, fa), theme.u32(key, la), theme.u32(key, (hover or press) and 1 or 0.95), 1, 1
end
eminence_sf._action_look = action_look

local function paint_action(dl, x1, y1, x2, y2, op, hover, press)
    local fill, line, text, fill_a, line_a = action_look(op, hover, press)
    sf.frame(dl, x1, y1, x2, y2, {
        cut = 3, fill = fill, line = line,
        fill_a = fill_a or 1, line_a = line_a or 1, brackets = false, glow = false, thick = 1.15, band = false,
    })
    return text
end

local function chip(ui, win, id, label, on, tip, opts)
    opts = opts or {}
    local imgui = ui.imgui
    local pad_x = opts.pad_x or 8
    local pad_y = opts.pad_y or 3
    font(ui, win, opts.scale or 0.78, opts.bold)
    local tw, th = theme.measure_text(imgui, label)
    tw, th = tw or 40, th or 12
    font(ui, win, 1, false)
    local w, h = tw + pad_x * 2, th + pad_y * 2
    if opts.x and opts.y then sf.set_cursor(imgui, opts.x, opts.y) end
    local clicked = sf.hit(imgui, '##sfc_' .. id, w, h)
    local x1, y1, x2, y2 = sf.item_rect(imgui)
    if x1 then
        local dl = dl_of(imgui)
        local tcol
        if opts.action then
            local hover = imgui.IsItemHovered and imgui.IsItemHovered()
            local press = imgui.IsItemActive and imgui.IsItemActive()
            tcol = paint_action(dl, x1, y1, x2, y2, opts.action, hover, press)
        else
            sf.frame(dl, x1, y1, x2, y2, {
                cut = 4, fill_a = on and 0.50 or 0.18, line_a = on and 0.95 or 0.55,
                line = on and theme.u32('sf_cyan', 0.95) or nil,
                brackets = false, glow = false, thick = 1.1, band = false,
            })
            tcol = theme.u32(on and 'sf_cyan' or 'text', 1)
        end
        font(ui, win, opts.scale or 0.78, opts.bold)
        sf.add_text(dl, x1 + pad_x, y1 + pad_y, tcol, label)
        font(ui, win, 1, false)
    end
    if tip and imgui.IsItemHovered and imgui.IsItemHovered() and imgui.SetTooltip then
        pcall(imgui.SetTooltip, tip)
    end
    return clicked, w, h
end

local function flow_start(imgui)
    local x, y = cursor(imgui)
    local avail = select(1, sf.avail(imgui)) or 400
    return { x = x or 0, y = y or 0, row_x = x or 0, row_y = y or 0, row_h = 0, right = (x or 0) + avail, max_y = y or 0 }
end

local function flow_next(st, w, h)
    if st.row_x > st.x and st.row_x + w > st.right then
        st.row_x = st.x
        st.row_y = st.row_y + st.row_h + 6
        st.row_h = 0
    end
    local x, y = st.row_x, st.row_y
    st.row_x = st.row_x + w + 6
    if h > st.row_h then st.row_h = h end
    st.max_y = math.max(st.max_y, st.row_y + st.row_h)
    return x, y
end

local function flow_end(imgui, st)
    pcall(function ()
        local wx, wy = sf.xy(pcall(imgui.GetWindowPos))
        if wx and wy then
            imgui.SetCursorScreenPos({ st.x, st.max_y + 6 })
        end
    end)
    pcall(function () imgui.Dummy({ 1, 1 }) end)
end

local function badge_of(t, st)
    if st == 'accepted' then return t('sf.badge_progress'), 'sf_cyan' end
    if st == 'completed' then return t('sf.badge_done'), 'muted' end
    return t('sf.badge_idle'), 'muted'
end

local function allow_overlap(imgui)
    if imgui and imgui.SetItemAllowOverlap then pcall(imgui.SetItemAllowOverlap) end
end

local function mouse_in(imgui, x1, y1, x2, y2)
    if not (x1 and y1 and x2 and y2) then return false end
    local mx, my = sf.xy(pcall(imgui.GetMousePos))
    return mx and my and mx >= x1 and mx < x2 and my >= y1 and my < y2
end

local function show_tip(imgui, text)
    if text and imgui.IsItemHovered and imgui.IsItemHovered() and imgui.SetTooltip then
        pcall(imgui.SetTooltip, text)
    end
end

local function db_of(ui)
    if not ui.roe_db then return nil end
    local ok, db = pcall(ui.roe_db)
    if ok then return db end
    return nil
end

-- くり返し・期間外（0.1.293〜）。戻り値: { mode = 'active'|'open'|'wait'|'done', reason, at }
local function cycle_of(ui, id)
    if ui.roe_cycle_status then
        local ok, c = pcall(ui.roe_cycle_status, id)
        if ok and c then return c end
    end
    local st = eminence.state_of(ui, id) or 'not_accepted'
    if st == 'accepted' then return { mode = 'active' } end
    if st == 'completed' then
        local db = db_of(ui)
        local q = db and db.quests and db.quests[id]
        return { mode = (q and q.repeatable) and 'open' or 'done' }
    end
    return { mode = 'open' }
end
eminence_sf.cycle_of = cycle_of

-- 札の区分（0.1.294〜。絞り込みも同じ区分）：
--   active＝解除（受注中）、open＝受注、wait＝期間外、other＝対象外、auto＝自動、completed＝達成、unimplemented＝未実装
-- 受注中は未実装でも解除のまま。未実装は期間外などより先に見る（受けても断られるため）
eminence_sf.SHOW_KEYS = { 'active', 'open', 'wait', 'other', 'auto', 'completed', 'unimplemented' }
local SHOW_DEFAULT = { active = true, open = true, wait = true, other = true, auto = true, completed = false, unimplemented = true }
local SHOW_FROM_BOOK = { active = 'accepted', open = 'not_accepted', wait = 'not_accepted', other = 'not_accepted',
    auto = 'not_accepted', completed = 'completed', unimplemented = 'unimplemented' }

function eminence_sf.ensure_show(E)
    if type(E.sf_show) ~= 'table' then E.sf_show = {} end
    for _, k in ipairs(eminence_sf.SHOW_KEYS) do
        if type(E.sf_show[k]) ~= 'boolean' then
            local b = nil
            if type(E.book_show) == 'table' then b = E.book_show[SHOW_FROM_BOOK[k]] end
            if type(b) == 'boolean' then E.sf_show[k] = b else E.sf_show[k] = SHOW_DEFAULT[k] end
        end
    end
    return E.sf_show
end

local function is_unimpl(ui, id)
    local failed = ui.roe_failed and ui.roe_failed(id)
    return failed ~= nil and failed.why == 'not_impl'
end

function eminence_sf.category(ui, id, cyc)
    cyc = cyc or cycle_of(ui, id)
    if cyc.mode == 'active' then return 'active' end
    if is_unimpl(ui, id) then return 'unimplemented' end
    if cyc.mode == 'done' then return 'completed' end
    if cyc.mode == 'wait' then
        if cyc.reason == 'other_leader' then return 'other' end
        if cyc.reason == 'timed_auto' then return 'auto' end
        return 'wait'
    end
    return 'open'
end

-- 本の一覧で出すか（eminence.book_visible から。ignore_state は見出しの件数用：未実装の絞りだけ効かせる）
function eminence_sf.visible(ui, id, opts)
    local E = ui.settings.eminence
    if not E then return true end
    local show = eminence_sf.ensure_show(E)
    local cat = eminence_sf.category(ui, id)
    if opts and opts.ignore_state then
        return not (cat == 'unimplemented' and show.unimplemented == false)
    end
    return show[cat] ~= false
end
eminence.sf_filter = eminence_sf.visible

-- 期間外の札の字：待てば受けられる＝期間外、ほかのリーダー＝対象外、ゲームが入れる＝自動
local WAIT_LABEL = { other_leader = 'roe.wait.other', timed_auto = 'roe.wait.auto' }
function eminence_sf.wait_label(t, c)
    if c and c.unimpl then return t('state.unimplemented') end
    return t(WAIT_LABEL[c and c.reason] or 'roe.wait.period')
end

-- 次に受けられる時刻の字（分からなければ nil）
function eminence_sf.wait_when(t, c, now)
    if not (c and c.at) then return nil end
    -- 自動（ゲームが4時間ごとに入れる）は、次に入るまでの残り時間（0.1.294〜）
    if c.reason == 'timed_auto' then
        local h, m = roe_cycle.remain_parts(c.at, now or os.time())
        if h > 0 and m == 0 then return t('roe.wait.in_h', { h = tostring(h) }) end
        if h > 0 then return t('roe.wait.in_hm', { h = tostring(h), m = tostring(m) }) end
        return t('roe.wait.in_m', { m = tostring(m) })
    end
    return t('roe.wait.from', { when = roe_cycle.format_when(c.at) })
end

local function list_sig(ui, heading_id)
    local E = ui.settings.eminence or {}
    local r = ui.state and ui.state.roe or {}
    local nact = 0
    if r.active then nact = #r.active end
    local parts = {
        tostring(heading_id or 'all'),
        E.book_text or '',
        E.book_favs_only and '1' or '0',
        eminence.show_sig(E),
        (function ()
            local sh = eminence_sf.ensure_show(E)
            local o = {}
            for _, k in ipairs(eminence_sf.SHOW_KEYS) do o[#o + 1] = sh[k] and '1' or '0' end
            return table.concat(o)
        end)(),
        (E.known_unimpl == false) and 'u0' or 'u1',
        tostring(nact),
        tostring(r.db_why or ''),
        tostring(r.rev or r.complete_rev or ''),
        -- 達成の表が替わったとき・0:00 JST を過ぎたとき・組や週が届いたときも組み直す（0.1.293〜）
        tostring(r.complete),
        tostring(roe.days_since(ui.epoch_now and ui.epoch_now() or os.time())),
        tostring(r.unity and r.unity.shared or '') .. ':' .. tostring(r.unity and r.unity.week or '') .. ':' .. tostring(r.leader or ''),
        -- 0.1.305〜：ゲームでまだ出ていない目標の組が替わったら（達成の表・行ったエリア）
        tostring(r.gate_key or ''),
    }
    -- 受けている id と進みも署名へ（件数が同じでも中身が変わったら組み直す）
    if r.active then
        for _, e in ipairs(r.active) do
            parts[#parts + 1] = tostring(e.id) .. ':' .. tostring(e.progress or 0)
        end
    end
    return table.concat(parts, '|')
end

function eminence_sf.shown_rows(ui)
    local S = ui.settings
    local E = S.eminence or {}
    if type(E.book_show) ~= 'table' then E.book_show = { accepted = true, not_accepted = true, completed = false, unimplemented = true } end
    if E.book_show.unimplemented == nil then E.book_show.unimplemented = true end
    local db = db_of(ui)
    local root = eminence.current_root(ui)
    local heading_id = book.display_heading(ui)
    local sig = list_sig(ui, heading_id)
    if cache.sig == sig and cache.shown then
        return cache.shown, cache.empty, cache.extra, cache.heading
    end
    local rows, empty_key, extra = eminence.book_list_rows(ui, E, db, root)
    local searching = E.book_text and E.book_text ~= ''
    if searching then
        heading_id = book.ALL_ID
    else
        heading_id = heading_id or book.ALL_ID
        if heading_id ~= book.ALL_ID and #book.heading_path_ids(ui, heading_id) == 0 then
            heading_id = book.ALL_ID
        end
    end
    local shown = eminence.recs_for_heading(ui, heading_id, rows)
    -- 受注中 → 受けられる → 期間外 → 達成（0.1.293〜。期間外は下へ。受けられる日になれば元の位置に戻る）
    local rank = roe_cycle.RANK
    local tagged = {}
    for i, r in ipairs(shown) do
        local c = cycle_of(ui, r.id)
        local cat = eminence_sf.category(ui, r.id, c)
        local key = (cat == 'unimplemented') and 'unimplemented' or c.mode
        tagged[i] = { r = r, i = i, rank = rank[key] or 2 }
    end
    table.sort(tagged, function (a, b)
        if a.rank ~= b.rank then return a.rank < b.rank end
        return a.i < b.i
    end)
    local out = {}
    for i, x in ipairs(tagged) do out[i] = x.r end
    cache.sig, cache.shown, cache.empty, cache.extra, cache.heading = sig, out, empty_key, extra, heading_id
    return out, empty_key, extra, heading_id
end

function eminence_sf.reset_cache()
    cache.sig, cache.shown = nil, nil
end

local function frac_of(ui, id)
    local st, entry = eminence.state_of(ui, id)
    local db = db_of(ui)
    local q = db and db.quests and db.quests[id]
    local target = q and tonumber(q.target) or nil
    local p = (entry and tonumber(entry.progress)) or 0
    if st == 'completed' then return 1, p, target or p end
    if target and target > 0 then return math.max(0, math.min(1, p / target)), p, target end
    return 0, p, target
end

local function draw_card(ui, win, rec, selected, width)
    local imgui, t = ui.imgui, ui.t
    local id = rec.id
    local w = math.max(80, tonumber(width) or 160)
    local h = 108
    local clicked = sf.hit(imgui, '##sfem_' .. tostring(id), w, h)
    local x1, y1, x2, y2 = sf.item_rect(imgui)
    if not x1 then return clicked end
    -- 先に出したカード全体の当たりが、右上の♥／★やバッジのクリックを奪わないようにする
    allow_overlap(imgui)
    local card_hov = imgui.IsItemHovered and imgui.IsItemHovered() or false
    local dl = dl_of(imgui)
    sf.frame(dl, x1, y1, x2, y2, {
        cut = 8, fill_a = selected and 0.46 or 0.24, line_a = selected and 1.0 or 0.62,
        brackets = selected, bracket_len = 10,
        thick = selected and 1.9 or 1.25, glow = selected and 1 or 0,
        glow_col = theme.u32('sf_cyan', 0.80),
        band = selected, band_a = selected and 0.14 or 0,
    })
    local st = eminence.state_of(ui, id) or 'not_accepted'
    local cyc = cycle_of(ui, id)
    local mode = cyc.mode
    local failed = ui.roe_failed and ui.roe_failed(id)
    -- 0.1.294〜：未実装（受注中でないもの）は「未実装」の灰色の札。押せない
    local unimpl = mode ~= 'active' and failed ~= nil and failed.why == 'not_impl'
    if unimpl then cyc = { mode = 'wait', reason = 'not_impl', unimpl = true }; mode = 'wait' end
    local name = eminence.name(ui, id)
    local yy = y1 + 10
    font(ui, win, 1.05, true)
    local pin_s, pin_gap = 18, 2
    local name_max = math.max(16, w - 10 - pin_s * 2 - pin_gap - 8)
    local shown, _ = window.clip_line(imgui, name, name_max)
    local muted = (mode == 'done') or (mode == 'wait') or (failed and failed.why == 'not_impl' and st ~= 'accepted')
    sf.text_at(imgui, x1 + 10, yy, function ()
        theme.TextColored(imgui, theme.col(muted and 'muted' or 'text'), shown)
    end)
    -- 未開始／進行中の表示は出さず、受注／解除のボタンだけ（完了はこれまでどおり表示）
    -- 0.1.293〜：くり返しできる達成は受注ボタン。いま受けられないものは「期間外」などの灰色の札
    local badge, bcol
    if mode == 'done' then
        badge = badge_of(t, 'completed')
        bcol = eminence_sf.state_color(mode, cyc)
    elseif mode == 'wait' then
        badge, bcol = eminence_sf.wait_label(t, cyc), eminence_sf.state_color(mode, cyc)
    elseif mode == 'active' then
        badge, bcol = t('roe.remove'), eminence_sf.state_color(mode, cyc)
    else
        badge, bcol = t('roe.accept'), eminence_sf.state_color(mode, cyc)
    end
    font(ui, win, 0.68, true)
    local twb, thb = theme.measure_text(imgui, badge)
    local bpad_x, bpad_y = 7, 3
    local bw = (twb or 36) + bpad_x * 2
    local bh = (thb or 12) + bpad_y * 2
    local bx2, by2 = x2 - 10, y2 - 8
    local bx1, by1 = bx2 - bw, by2 - bh
    -- 0.1.295〜：未実装の札は手で外せる（「元に戻す」）。外したものは「未実装に戻す」。札の左の小さいボタン
    local ust = ui.roe_unimpl_state and ui.roe_unimpl_state(id) or nil
    local ulab = ust and t(ust == 'unimpl' and 'roe.unimpl.restore' or 'roe.unimpl.mark') or nil
    local ux1, uy1, ux2, uy2
    if ulab then
        font(ui, win, 0.62, false)
        local twu, thu = theme.measure_text(imgui, ulab)
        font(ui, win, 1, false)
        local uw, uh = (twu or 40) + 10, (thu or 11) + 5
        ux2 = bx1 - 6
        ux1 = ux2 - uw
        uy2 = by2
        uy1 = uy2 - uh
        -- カードが狭くて左の数と重なるときは、札の上に重ねて置く。それでも入らなければ出さない（詳細のボタンで切りかえる）
        if ux1 < x1 + 70 then
            ux2 = bx2
            ux1 = ux2 - uw
            uy2 = by1 - 4
            uy1 = uy2 - uh
            if ux1 < x1 + 10 or uy1 < y1 + 30 then ulab, ux1 = nil, nil end
        end
    end
    local frac, ci, ct = frac_of(ui, id)
    local count = (ci ~= nil) and (ct and (tostring(ci) .. ' / ' .. tostring(ct)) or tostring(ci)) or nil
    -- 期間外で次に受けられる時刻が分かるときは、数の代わりに「11/23 0:00から」
    local when = (mode == 'wait') and eminence_sf.wait_when(t, cyc, ui.epoch_now and ui.epoch_now() or nil) or nil
    if when then count = when end
    font(ui, win, when and 0.78 or 1.12, not when)
    local cw, ch = 0, 16
    if count then
        cw, ch = theme.measure_text(imgui, count)
        cw, ch = cw or 40, ch or 16
    end
    local count_y = by1 + math.max(0, (bh - ch) * 0.5)
    local bar_h = 5
    local bar_y = math.min(by1, count_y) - 8 - bar_h
    if bar_y < yy + 14 then bar_y = yy + 14 end
    sf.bar(dl, x1 + 10, bar_y, math.max(36, (ux1 or bx1) - 8 - (x1 + 10)), bar_h, frac or 0)
    if count then
        if when then font(ui, win, 0.78, false) end
        sf.add_text(dl, x1 + 10, count_y, theme.u32(when and 'muted' or 'heading', 1), count)
        if when then font(ui, win, 1, false) end
    end
    -- 未開始／進行中のバッジは受注・解除のボタン（色で見分けやすく）。完了は表示だけ。
    local badge_hit, over_badge = false, false
    if mode == 'wait' then
        -- 期間外：押せない灰色の札。理由と次に受けられる時刻は札のツールチップ
        pcall(function () imgui.SetCursorScreenPos({ bx1, by1 }) end)
        sf.hit(imgui, '##sfemw_' .. tostring(id), bw, bh)
        sf.frame(dl, bx1, by1, bx2, by2, {
            cut = 3, fill = theme.u32(bcol, 0.10), fill_a = 1, line = theme.u32(bcol, 0.70), line_a = 1,
            brackets = false, glow = false, thick = 1.0, band = false,
        })
        font(ui, win, 0.68, true)
        sf.add_text(dl, bx1 + bpad_x, by1 + bpad_y, theme.u32(bcol, 0.95), badge)
        font(ui, win, 1, false)
        local tip = ui.roe_why_text and ui.roe_why_text(cyc.reason, id) or nil
        show_tip(imgui, tip)
    elseif mode ~= 'done' then
        pcall(function () imgui.SetCursorScreenPos({ bx1, by1 }) end)
        badge_hit = sf.hit(imgui, '##sfemb_' .. tostring(id), bw, bh)
        local op, can, why = eminence.action_info(ui, id)
        local hover = (imgui.IsItemHovered and imgui.IsItemHovered()) or mouse_in(imgui, bx1, by1, bx2, by2)
        local press = imgui.IsItemActive and imgui.IsItemActive()
        local tcol = paint_action(dl, bx1, by1, bx2, by2, op, hover, press)
        font(ui, win, 0.68, true)
        sf.add_text(dl, bx1 + bpad_x, by1 + bpad_y, tcol, badge)
        font(ui, win, 1, false)
        local tip = can and t(op == 'start' and 'roe.accept_tip' or 'roe.remove_tip')
            or (ui.roe_why_text and ui.roe_why_text(why, id)) or nil
        show_tip(imgui, tip)
        over_badge = mouse_in(imgui, bx1, by1, bx2, by2)
        if tip and over_badge and (card_hov or (imgui.IsItemHovered and imgui.IsItemHovered())) and imgui.SetTooltip then
            if not (imgui.IsItemHovered and imgui.IsItemHovered()) then
                pcall(imgui.SetTooltip, tip)
            end
        end
        if badge_hit or (clicked and over_badge) then
            if can and ui.roe_send then ui.roe_send(op, id) end
            clicked = false
        end
    else
        sf.frame(dl, bx1, by1, bx2, by2, {
            cut = 3, fill_a = 0.42, line_a = 0.92, line = theme.u32(bcol, 0.95),
            brackets = false, glow = false, thick = 1.15, band = false,
        })
        font(ui, win, 0.68, true)
        sf.add_text(dl, bx1 + bpad_x, by1 + bpad_y, theme.u32(bcol, 1.0), badge)
        font(ui, win, 1, false)
    end
    if ulab and ux1 then
        pcall(function () imgui.SetCursorScreenPos({ ux1, uy1 }) end)
        local uhit = sf.hit(imgui, '##sfemu_' .. tostring(id), ux2 - ux1, uy2 - uy1)
        local utip = t(ust == 'unimpl' and 'roe.unimpl.restore_tip' or 'roe.unimpl.mark_tip')
        show_tip(imgui, utip)
        local over_u = mouse_in(imgui, ux1, uy1, ux2, uy2)
        local ucol = (ust == 'unimpl') and 'sf_cyan' or 'muted'
        sf.frame(dl, ux1, uy1, ux2, uy2, {
            cut = 2, fill = theme.u32(ucol, over_u and 0.22 or 0.08), fill_a = 1, line = theme.u32(ucol, over_u and 0.95 or 0.60), line_a = 1,
            brackets = false, glow = false, thick = 1.0, band = false,
        })
        font(ui, win, 0.62, false)
        sf.add_text(dl, ux1 + 5, uy1 + 2, theme.u32(ucol, 0.95), ulab)
        font(ui, win, 1, false)
        if over_u and card_hov and imgui.SetTooltip and not (imgui.IsItemHovered and imgui.IsItemHovered()) then
            pcall(imgui.SetTooltip, utip)
        end
        if uhit or (clicked and over_u) then
            if ui.roe_toggle_unimpl then ui.roe_toggle_unimpl(id) end
            clicked = false
        end
    end
    -- 右上：お気に入りの♥、その右に★（ピン）
    -- カード全体の InvisibleButton が先だと、ImGui は重なった小さい当たりをクリックしない。
    -- AllowOverlap と、カード側のクリック＋マウス位置の両方で拾う。
    local star_x = x2 - pin_s - 6
    local heart_x = star_x - pin_s - pin_gap
    local icon_y = y1 + 6
    pcall(function () imgui.SetCursorScreenPos({ heart_x, icon_y }) end)
    local faved = eminence.is_faved(ui, id)
    local heart_hit = sf.hit(imgui, '##sfemf_' .. tostring(id), pin_s, pin_s)
    show_tip(imgui, t(faved and 'roe.unfav' or 'roe.fav'))
    local hx1, hy1, hx2, hy2 = sf.item_rect(imgui)
    if not hx1 then hx1, hy1, hx2, hy2 = heart_x, icon_y, heart_x + pin_s, icon_y + pin_s end
    if hx1 and eminence._heart then
        local draw_h = eminence._heart_round or eminence._heart
        draw_h(dl_of(imgui), (hx1 + hx2) / 2, (hy1 + hy2) / 2, 6, faved)
    end
    pcall(function () imgui.SetCursorScreenPos({ star_x, icon_y }) end)
    local pinned = eminence.is_pinned(ui, id)
    local star_hit = sf.hit(imgui, '##sfemp_' .. tostring(id), pin_s, pin_s)
    show_tip(imgui, t(pinned and 'roe.unpin' or 'roe.pin'))
    local px1, py1, px2, py2 = sf.item_rect(imgui)
    if not px1 then px1, py1, px2, py2 = star_x, icon_y, star_x + pin_s, icon_y + pin_s end
    if px1 and sf.icon_star then
        sf.icon_star(dl_of(imgui), (px1 + px2) / 2, (py1 + py2) / 2, 6, theme.u32(pinned and 'sf_cyan' or 'muted', pinned and 1 or 0.55))
    end
    local over_heart = mouse_in(imgui, hx1, hy1, hx2, hy2)
    local over_star = mouse_in(imgui, px1, py1, px2, py2)
    if heart_hit or (clicked and over_heart) then
        eminence.toggle_fav(ui, id)
        clicked = false
    elseif star_hit or (clicked and over_star) then
        eminence.toggle_pin(ui, id)
        clicked = false
    end
    pcall(function () imgui.SetCursorScreenPos({ x1, y2 }) end)
    return clicked
end

local function section_label(ui, win, key)
    local label = ui.t(key)
    if sf.is_en_heading(label) then
        window.set_font(ui, window.font_scale(ui, win) * 0.72, { heading = true, bold = true })
        sf.heading_line(ui, label, theme.u32('sf_cyan', 1.0), 'label')
    else
        font(ui, win, 0.72, true)
        theme.TextColored(ui.imgui, theme.col('sf_cyan'), label)
    end
    font(ui, win, 1, false)
end

local function draw_detail(ui, win, id)
    local imgui, t = ui.imgui, ui.t
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
    local ok_inner = pcall(imgui.BeginChild, '##astertrail_sf_em_detail_inner', { inner_w, inner_h }, 0, 0)
    if ok_inner then window.push(ui, 'child') end
    local db = db_of(ui)
    local q = db and id and db.quests[id]
    if not q then
        W.muted(ui, t('roe.detail_hint'))
        if ok_inner then window.pop(ui, 'child') end
        return
    end
    local st = eminence.state_of(ui, id)
    local cyc = cycle_of(ui, id)
    local mode = cyc.mode
    if mode ~= 'active' and is_unimpl(ui, id) then cyc = { mode = 'wait', reason = 'not_impl', unimpl = true }; mode = 'wait' end
    font(ui, win, 1.42, true)
    theme.TextColored(imgui, theme.col((mode == 'done' or mode == 'wait') and 'muted' or 'heading'), eminence.name(ui, id))
    font(ui, win, 0.78, false)
    -- 状態の字：くり返しできる達成は「未開始」、いま受けられないものは「期間外」（0.1.293〜）
    if mode == 'wait' then
        local lab = eminence_sf.wait_label(t, cyc)
        local when = eminence_sf.wait_when(t, cyc, ui.epoch_now and ui.epoch_now() or nil)
        theme.TextColored(imgui, theme.col(eminence_sf.state_color(mode, cyc)), when and (lab .. '  ' .. when) or lab)
    else
        local badge = badge_of(t, (mode == 'done' and 'completed') or (mode == 'active' and 'accepted') or 'not_accepted')
        -- 0.1.321〜：状態の字も札と同じ色（受注中＝紫ピンク、達成＝金、未開始＝#80ADC7）
        theme.TextColored(imgui, theme.col(eminence_sf.state_color(mode, cyc)), badge)
    end
    font(ui, win, 1, false)
    if q.body and q.body ~= '' then W.text(ui, q.body) end

    do
        local stf = flow_start(imgui)
        local function put(cid, lab, on, tip, fn, copts)
            font(ui, win, 0.78, false)
            local w = chip_w(imgui, lab, 8)
            font(ui, win, 1, false)
            local cx, cy = flow_next(stf, w, 20)
            local o = { x = cx, y = cy }
            if copts then for k, v in pairs(copts) do o[k] = v end end
            if chip(ui, win, cid, lab, on, tip, o) then fn() end
        end
        local pinned = eminence.is_pinned(ui, id)
        put('pin', pinned and t('roe.unpin') or t('roe.pin'), pinned, nil, function ()
            eminence.toggle_pin(ui, id)
        end)
        local faved = eminence.is_faved(ui, id)
        put('fav', faved and t('roe.unfav') or t('roe.fav'), faved, nil, function ()
            eminence.toggle_fav(ui, id)
        end)
        if mode == 'active' or mode == 'open' then
            local op, can, why = eminence.action_info(ui, id)
            local lab = (op == 'start') and t('roe.accept') or t('roe.remove')
            local tip = can and t(op == 'start' and 'roe.accept_tip' or 'roe.remove_tip')
                or (ui.roe_why_text and ui.roe_why_text(why, id)) or nil
            put('act', lab, op == 'start', tip, function ()
                if can and ui.roe_send then ui.roe_send(op, id) end
            end, { action = op })
        end
        -- 0.1.295〜：未実装の札を手で外す ⇄ 未実装に戻す
        local ust = ui.roe_unimpl_state and ui.roe_unimpl_state(id) or nil
        if ust then
            put('unimpl', t(ust == 'unimpl' and 'roe.unimpl.restore' or 'roe.unimpl.mark'), ust == 'restored',
                t(ust == 'unimpl' and 'roe.unimpl.restore_tip' or 'roe.unimpl.mark_tip'), function ()
                    if ui.roe_toggle_unimpl then ui.roe_toggle_unimpl(id) end
                end)
        end
        flow_end(imgui, stf)
    end

    section_label(ui, win, 'roe.d.special')
    W.text(ui, q.special or '')
    section_label(ui, win, 'roe.d.count')
    W.text(ui, eminence.count_text(ui, id))
    -- 手順・回数の下、REWARD の上（クエスト詳細と同じ薄い横線）
    if sf.rule then sf.rule(imgui) end
    section_label(ui, win, 'roe.d.reward')
    W.text(ui, eminence.reward_text(q))
    local rep = cyc['repeat']
    if rep == nil then rep = q.repeatable end
    W.muted(ui, t(rep and 'roe.d.repeatable' or 'roe.d.not_repeatable'))
    if mode == 'wait' and ui.roe_why_text then
        W.muted(ui, ui.roe_why_text(cyc.reason, id))
    end
    if ok_inner then window.pop(ui, 'child') end
end

eminence_sf._draw_detail = draw_detail   -- テスト用

local function flow_chips(ui, name, items)
    local imgui = ui.imgui
    local stf = flow_start(imgui)
    for _, it in ipairs(items) do
        font(ui, name, 0.78, it.bold)
        local need = chip_w(imgui, it.label, it.pad_x or 8)
        font(ui, name, 1, false)
        local cx, cy = flow_next(stf, need, 14 + 6)
        if chip(ui, name, it.id, it.label, it.on, it.tip, { x = cx, y = cy, pad_x = it.pad_x, bold = it.bold }) then
            if it.on_click then it.on_click() end
        end
    end
    flow_end(imgui, stf)
end

function eminence_sf.book_body(ui, name)
    local imgui, t, S = ui.imgui, ui.t, ui.settings
    local E = S.eminence
    local r = ui.state and ui.state.roe or {}
    local db, why = db_of(ui), r.db_why

    if not r.active then
        W.colored(ui, 'warn', t('roe.no_record'))
    else
        local n = ui.roe_active_count and ui.roe_active_count() or 0
        W.muted(ui, t('roe.count_line', { n = tostring(n), max = tostring(roe.MAX_ACTIVE) }))
    end

    local st = ui.state
    local filters_on = st.sf_em_filters_open == true
    if chip(ui, name, 'em_filters', t('sf.filter'), filters_on, t('book.show_tip'), { scale = 0.80, bold = true, pad_x = 10, pad_y = 4 }) then
        st.sf_em_filters_open = not filters_on
        filters_on = st.sf_em_filters_open
    end
    imgui.SameLine(0, 8)

    local shown, empty_key, extra, heading_id = eminence_sf.shown_rows(ui)
    heading_id = heading_id or book.display_heading(ui) or book.ALL_ID
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
    chip(ui, name, 'em_hd_cur', hd_label, true, nil)

    if filters_on then
        sf.break_row(imgui)
        eminence.book_filters(ui, name, 'f1', nil, nil, function (rest)
            return math.max(260, math.min(460, (tonumber(rest) or 400) - 16))
        end, false)
        sf.break_row(imgui)
        -- 0.1.294〜：カードの札と同じ言葉で絞る。解除＝受注中、受注＝受けられる、期間外・対象外・自動・達成・未実装
        local show = eminence_sf.ensure_show(E)
        local CHIP = {
            active = { 'roe.remove', 'roe.filter.active_tip' },
            open = { 'roe.accept', 'roe.filter.open_tip' },
            wait = { 'roe.wait.period', 'roe.filter.wait_tip' },
            other = { 'roe.wait.other', 'roe.filter.other_tip' },
            auto = { 'roe.wait.auto', 'roe.filter.auto_tip' },
            completed = { 'roe.state.completed', 'roe.filter.completed_tip' },
            unimplemented = { 'state.unimplemented', 'roe.filter.unimplemented_tip' },
        }
        local items = {}
        for _, k in ipairs(eminence_sf.SHOW_KEYS) do
            local on = show[k] ~= false
            items[#items + 1] = {
                id = 'em_sf_show_' .. k, label = t(CHIP[k][1]), on = on, tip = t(CHIP[k][2]),
                on_click = function ()
                    show[k] = not on
                    ui.mark_settings_dirty()
                    eminence_sf.reset_cache()
                end,
            }
        end
        local on_f = E.book_favs_only == true
        items[#items + 1] = {
            id = 'em_favs', label = t('roe.favs_only'), on = on_f, tip = t('roe.favs_only_tip'),
            on_click = function ()
                E.book_favs_only = not on_f
                ui.mark_settings_dirty()
                eminence_sf.reset_cache()
            end,
        }
        flow_chips(ui, name, items)
        local function chips_of(ns)
            local hd = {}
            for _, n in ipairs(ns or {}) do
                local lab = book.heading_label(n.label, n.done, n.total)
                local on = tostring(heading_id) == tostring(n.id)
                hd[#hd + 1] = {
                    id = 'emhd_' .. tostring(n.id), label = lab, on = on,
                    on_click = function ()
                        if book.set_heading(S, 'eminence', n.id, function () ui.mark_settings_dirty() end) then
                            if ui.state then ui.state.book_heading_changed = true end
                            eminence_sf.reset_cache()
                        end
                    end,
                }
            end
            flow_chips(ui, name, hd)
        end
        chips_of(nodes)
        if cur_hd and cur_hd.children and #cur_hd.children > 0 then
            chips_of(cur_hd.children)
        end
        -- フィルタを変えたあと一覧を取り直す
        shown, empty_key, extra, heading_id = eminence_sf.shown_rows(ui)
    end

    book.follow_focus_row(ui, name, shown)
    local sel_id = eminence.selected and eminence.selected()
    if sel_id == nil then sel_id = tonumber(E.last_id) end
    local visible = {}
    for _, row in ipairs(shown) do visible[#visible + 1] = row.id end
    local fallback = false
    if sel_id then
        local ok = false
        for _, id in ipairs(visible) do if id == sel_id then ok = true; break end end
        if not ok then
            if book.focus_is_list(name) then
                local prev = book._shown_ids and book._shown_ids.eminence
                local nxt = book.nearest_entry(shown, sel_id, prev)
                if nxt then sel_id = nxt.id else sel_id = nil; fallback = true end
            else
                sel_id = nil; fallback = true
            end
        end
    end
    if not sel_id and shown[1] then sel_id = shown[1].id end
    if E.last_id ~= sel_id then E.last_id = sel_id; ui.mark_settings_dirty() end
    if eminence.select then eminence.select(sel_id) end
    book.remember_shown('eminence', shown)

    pcall(function () if imgui.NewLine then imgui.NewLine() end end)
    local rem_w = select(1, sf.avail(imgui)) or 800
    local rem_h = math.max(80, sf.remain_below(imgui, 8))
    local cards_w = book.sf_cards_width(S, rem_w, 'eminence')

    local force_top = fallback or (ui.state and ui.state.book_heading_changed)
    if ui.state then ui.state.book_heading_changed = nil end

    local ok_cards = pcall(imgui.BeginChild, '##astertrail_sf_em_cards', { cards_w, rem_h }, 0, 0)
    if ok_cards then window.push(ui, 'child') end
    window.set_font(ui, book.list_scale(ui))
    if ui.state and ui.state.book_restore_scroll then
        book.apply_scroll(ui, 'eminence', force_top)
    elseif force_top then
        book.apply_scroll(ui, 'eminence', true)
    end
    if why then
        W.colored(ui, 'warn', t('roe.no_dat', { why = tostring(why) }))
    elseif #shown == 0 then
        if empty_key then W.muted(ui, t(empty_key)) else W.muted(ui, t('book.empty')) end
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
                    local rec = shown[i]
                    if col > 0 then imgui.SameLine(0, gap) end
                    imgui.BeginGroup()
                    local clicked = draw_card(ui, name, rec, sel_id == rec.id, cw)
                    imgui.Dummy({ cw, 0 })
                    imgui.EndGroup()
                    if clicked then
                        sel_id = rec.id
                        E.last_id = sel_id
                        if eminence.select then eminence.select(sel_id) end
                        if ui.mark_settings_dirty then ui.mark_settings_dirty() end
                    end
                end
            end
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
            if ui.diag and ui.diag.log then pcall(ui.diag.log, 'eminence_sf', err) end
        end
    end
    if extra == 'search_max' then W.muted(ui, t('roe.search_more', { n = tostring(eminence.SEARCH_MAX) })) end
    if not (ui.state and ui.state._table_scroll_captured) then
        book.capture_scroll(ui, 'eminence')
    end
    if ui.state then ui.state._table_scroll_captured = nil end
    if ok_cards then window.pop(ui, 'child') end

    imgui.SameLine(0, 0)
    book.sf_cards_splitter(ui, S, rem_w, cards_w, rem_h, 'eminence')
    imgui.SameLine(0, 0)
    local ok_det = pcall(imgui.BeginChild, '##astertrail_sf_em_detail', { 0, rem_h }, 0, 0)
    if ok_det then window.push(ui, 'child') end
    window.set_font(ui, window.font_scale(ui, 'detail'))
    book.detail_anchor(ui, name)
    if db and sel_id and db.quests[sel_id] then
        draw_detail(ui, name, sel_id)
    else
        W.muted(ui, t('roe.detail_hint'))
    end
    if ok_det then window.pop(ui, 'child') end
end

return eminence_sf
