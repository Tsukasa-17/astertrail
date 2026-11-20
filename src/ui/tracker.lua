--[[
  Astertrail - トラッカー
  ピン留めしたものだけ。ミッションをいつも上に、その下にクエスト（0.1.61〜）。
  0.1.64〜：ボタンの行に手順の数「今/全部」（右そろえは ◀ の左、左そろえはピンの右）。ルートを選んでいれば共通＋そのルートだけ数える。
  1件の並び（上から）：アイコン＋名前（ミッションは番号も：SM1-1 名前）／ 今の手順 ／ 時間帯・天候（資料ありのみ）／ 次：次の手順 ／ ◀ ▶ ▲ ▼ ピン外し。
  たたむとアイコン＋名前だけ（必要品のボタンも出さない）。通し番号（1. 2. 3.）は付けない（0.1.63〜）。
  0.1.62〜：見出し（タイトルの行）は無し。右上に小さい × だけ（押すと隠す＝設定の「トラッカーを出す」をオフ）。
  たたむ・ひらくは、空いている所をダブルクリック（設定の「トラッカー」タブにもある）。必要品まとめのボタンは一番下（たたんだら出さない）。
  窓は空いている所をドラッグして動かし、右下の角で大きさを変える。
  文字のそろえ方は設定（右そろえが初期値）。右そろえのときは行ごとに幅を測って右に寄せる（押せる場所・選択枠も同じ位置）。
  0.1.63〜：名前の左に状態のアイコン（相手の印と同じ。進行中・目標達成・進められない など）。
  ピンがなければ窓を出さない。見えているだけの時は入力を受け取らない。
  ショートカットの「トラッカーを操作する」（または /astertrail tracker focus）で操作中にすると、
  パッド・キーで選べる（選択枠を出す）。選べるのは名前（詳細）・地図の名前・◀▶▲▼・ピン外し。アイテム名のコピーはマウスだけ。
  0.1.68〜：パッドの十字キー・×・○ は platform が xinput_state（書き換える前の値）から読む（操作中は状態を 0 にするため、
  xinput_button が届かないことがある）。地図の名前を決定すると、その名前の相手の場所で地図を開く。
  文字の大きさは SetWindowFontScale だけで変える（窓の大きさは変えない）。
  0.1.234〜：タブ表示のタブの名前は、設定の「タブの文字の大きさ」で別に変えられる（未設定はトラッカーと同じ）。
  0.1.170〜：上の行（× とタブ）はいつも見せ、中身だけが動く。× は設定で隠せる（show_close）。
  パッドは2段：件を選ぶ（上下）→ 決定でその件の中（名前・地図の名前・◀▶▲▼・ピン外し）→ キャンセルで件へ → もう一度でゲームへ。
  タブ表示（view = 'tabs'）：上の行に固定幅のタブ（長い名前は「…」、乗せると全体）。選んだ1件だけ出す。LB/RB・‹ › で切り替え。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local labels = require('src.ui.labels')
local poss_ui = require('src.ui.possession_ui')
local util = require('src.lib.util')
local CT = require('src.ui.colored_text')
local focus = require('src.ui.focus')
local theme = require('src.ui.theme')
local settings_mod = require('src.core.settings')
local marks_core = require('src.core.marks')
local ui_marks = require('src.ui.marks')

local tracker = {}

-- 項目ごとの文字の大きさ（トラッカーの文字サイズに掛ける）
tracker.SCALE = { name = 1.12, step = 1.0, time = 0.92, next = 0.88, ops = 0.95 }

function tracker.visible(ui)
    -- ピンがあれば出す。隠すのは設定の「トラッカーを出す」だけ。
    if not ui.settings.tracker.visible then return false end
    return #ui.progress:pinned_list() > 0
end

-- ピンの形をボタンの上に描く（絵文字のフォントが無くても見えるように）
local function draw_pin(imgui)
    pcall(function ()
        local x1, y1 = imgui.GetItemRectMin()
        local x2, y2 = imgui.GetItemRectMax()
        local dl = imgui.GetWindowDrawList()
        local cx, h = (x1 + x2) / 2, (y2 - y1)
        local r = math.max(2.5, h * 0.2)
        local top = y1 + h * 0.18
        local col = theme.u32('pin', 1.0)
        dl:AddLine({ cx, top + r }, { cx, y2 - h * 0.12 }, theme.u32('text', 0.9), 1.5)
        dl:AddCircleFilled({ cx, top + r * 0.6 }, r, col, 12)
    end)
end

-- たたむ・ひらく
function tracker.set_collapsed(ui, on)
    on = on and true or false
    if ui.settings.tracker.collapsed ~= on then
        ui.settings.tracker.collapsed = on
        ui.mark_settings_dirty()
    end
end

-- 名前の横の状態のアイコン（0.1.63〜。相手の印と同じ分け方。src/core/marks.lua の quest_icon）
function tracker.mission_icon(ui, q, next_missions)
    if not q or not ui.progress or not ui.data then return nil end
    return marks_core.quest_icon(ui.data, ui.progress, q, {
        have = ui.inventory_count, next_missions = next_missions,
        status = ui.player_status and ui.player_status() or nil,
    })
end

-- 名前の行の文字：ミッションは番号を前に（SM1-1 名前）。通し番号は付けない（0.1.63〜）
function tracker.head_text(q)
    local no = q and q.mission_no
    if no and no ~= '' then return tostring(no) .. ' ' .. labels.qname(q) end
    return labels.qname(q)
end

local function style_x(imgui, key, fallback)
    local ok, st = pcall(imgui.GetStyle)
    if ok and st then
        local ok2, v = pcall(function () return st[key] end)
        if ok2 and v ~= nil then
            if type(v) == 'table' then return tonumber(v.x or v[1]) or fallback end
            local ok3, x = pcall(function () return v.x end)
            if ok3 and tonumber(x) then return tonumber(x) end
        end
    end
    return fallback
end

-- 小さいボタンの幅（文字の幅＋左右の余白）
local function button_w(imgui, label)
    local w = CT.text_w(imgui, label)
    if not w then return nil end
    return w + style_x(imgui, 'FramePadding', 4) * 2
end

-- 小さいボタンを横に並べたときの幅
local function buttons_w(imgui, labels_)
    local total, sp = 0, style_x(imgui, 'ItemSpacing', 8)
    for i, l in ipairs(labels_) do
        local w = button_w(imgui, l)
        if not w then return nil end
        total = total + w + (i > 1 and sp or 0)
    end
    return total
end

-- 地図の名前（NPC・調べる対象）を押したとき、地図で出す手順と場所（0.1.68〜）
-- その行の手順の相手ならその手順。違えば、同じクエストでその名前が相手の手順（場所があるもの）。戻り値: step_id, loc
function tracker.map_target(D, q, name, sid)
    if not D or not q or not name then return sid, nil end
    local function hit(s)
        local tg = s and s.target and D:target(s.target)
        return tg and tg.name_en == name and tg or nil
    end
    -- 3つめは相手（モンスターなら、地図で近くの相手を探すのに使う。0.1.171〜）
    local s0 = sid and D:step(sid)
    local tg0 = hit(s0)
    if tg0 then
        if s0.location and s0.location.zone_id then return sid, nil, tg0 end
        if tg0.location and tg0.location.zone_id then return sid, tg0.location, tg0 end
        return sid, nil, tg0
    end
    for _, s in ipairs(q.steps or {}) do
        local tg = hit(s)
        if tg then
            if s.location and s.location.zone_id then return s.id, nil, tg end
            if tg.location and tg.location.zone_id then return s.id, tg.location, tg end
        end
    end
    return sid, nil
end

-- 文の「5人」「20人分」など（0.1.229〜）。UTF-8 なので「人分」を先に取る。
function tracker.people_counts(text)
    local out, seen = {}, {}
    if type(text) ~= 'string' or text == '' then return out end
    local i = 1
    while i <= #text do
        local a, b, n = text:find('(%d+)人分', i)
        local suf = '人分'
        if not a then
            a, b, n = text:find('(%d+)人', i)
            suf = '人'
        end
        if not a then break end
        local s = n .. suf
        if not seen[s] then
            seen[s] = true
            out[#out + 1] = s
        end
        i = b + 1
    end
    return out
end

-- 今の手順に、地図へ出す相手・候補が複数あるか（話し相手の一覧、または候補の座標）
function tracker.has_multi_map_targets(D, step)
    if not step then return false end
    local loc = step.location
    if loc and type(loc.candidates) == 'table' and #loc.candidates >= 2 then return true end
    if D and D.listed_talk_targets then
        if #D:listed_talk_targets(step) >= 2 then return true end
    end
    local n = 0
    if step.target then n = n + 1 end
    n = n + #(type(step.extra_targets) == 'table' and step.extra_targets or {})
    return n >= 2
end

-- パッドの2段の操作（0.1.170〜）：項目の id がどの件のものか。戻り値: qid, 件そのもの（e_）か
-- 件の中の項目：q_（名前）、qn_<qid>_（地図の名前）、br_<qid>#（分岐）、prev_/next_/up_/down_/unpin_<qid>
function tracker.owner_of(id, pins)
    if type(id) ~= 'string' then return nil end
    for _, qid in ipairs(pins or {}) do
        if id == 'e_' .. qid then return qid, true end
        if id == 'q_' .. qid then return qid, false end
        for _, k in ipairs({ 'prev_', 'next_', 'up_', 'down_', 'unpin_' }) do
            if id == k .. qid then return qid, false end
        end
        if id:sub(1, #qid + 4) == 'qn_' .. qid .. '_' then return qid, false end
        if id:sub(1, #qid + 4) == 'br_' .. qid .. '#' then return qid, false end
    end
    return nil
end

-- タブ表示（0.1.170〜）：選んでいる件（無い・外れたときは先頭）
function tracker.current_tab(ui, pins)
    local st = ui.state
    for _, q in ipairs(pins) do if q == st.tracker_tab then return q end end
    st.tracker_tab = pins[1]
    return pins[1]
end

-- 固定幅に入るように名前を「…」で切る。戻り値: 文字, 切ったか
function tracker.fit_label(imgui, text, width)
    text = tostring(text or '')
    local w = CT.text_w(imgui, text)
    if not w or w <= width then return text, false end
    local n = 0
    for _ in text:gmatch('[%z\1-\127\194-\244][\128-\191]*') do n = n + 1 end
    for k = n - 1, 1, -1 do
        local cut = util.utf8_cut(text, k)
        local cw = CT.text_w(imgui, cut)
        if cw and cw <= width then return cut, true end
    end
    return util.utf8_cut(text, 1), true
end

-- タブの幅（全角 n 文字＋余白。初期 6、設定で 3〜16。文字の大きさに合わせて変わるが、窓の大きさは変えない）
tracker.TAB_CHARS_MIN, tracker.TAB_CHARS_MAX, tracker.TAB_CHARS_DEFAULT = 3, 16, 6
function tracker.tab_chars(S)
    local n = math.floor(tonumber(S and S.tracker and S.tracker.tab_chars) or tracker.TAB_CHARS_DEFAULT)
    if n < tracker.TAB_CHARS_MIN then n = tracker.TAB_CHARS_MIN elseif n > tracker.TAB_CHARS_MAX then n = tracker.TAB_CHARS_MAX end
    return n
end

-- タブの名前の文字サイズ（0.1.234〜）。未設定ならトラッカーの文字サイズに追従
function tracker.tab_font_scale(ui)
    return settings_mod.font_for(ui and ui.settings, 'tracker_tabs')
end
local function tab_width(imgui, n)
    local w = CT.text_w(imgui, string.rep('あ', n or 6))
    return (w or 84) + style_x(imgui, 'FramePadding', 4) * 2
end

local function avail_x(imgui)
    local ok, a, b = pcall(imgui.GetContentRegionAvail)
    if not ok then return nil end
    if type(a) == 'number' then return a end
    if type(a) == 'table' then return tonumber(a.x or a[1]) end
    return nil
end

local function avail_y(imgui)
    local ok, a, b = pcall(imgui.GetContentRegionAvail)
    if not ok then return nil end
    if type(a) == 'number' then return tonumber(b) end
    if type(a) == 'table' then return tonumber(a.y or a[2]) end
    return nil
end

-- タブを1つ動かす（LB/RB・‹ ›）。dir: -1 / 1。戻り値: 新しく選んだ件
function tracker.step_tab(ui, pins, dir)
    if #pins == 0 then return nil end
    local cur = tracker.current_tab(ui, pins)
    local idx = 1
    for i, q in ipairs(pins) do if q == cur then idx = i end end
    local ni = ((idx - 1 + dir) % #pins) + 1
    ui.state.tracker_tab = pins[ni]
    -- パッドの選択も新しい件へ（件の中にいたら中のまま）
    local fc = focus.current('tracker')
    local owner, is_entry = tracker.owner_of(fc, pins)
    if (owner and not is_entry) or (ui.state.active == 'tracker' and ui.settings and ui.settings.tracker and ui.settings.tracker.view == 'tabs') then
        focus.set('tracker', 'q_' .. pins[ni], true)
    elseif owner then
        focus.set('tracker', 'e_' .. pins[ni], true)
    end
    return pins[ni]
end

function tracker.draw(ui)
    local imgui, t, S = ui.imgui, ui.t, ui.settings
    local P, D = ui.progress, ui.data
    local C = theme.C
    local pins = P:pinned_list()
    if #pins == 0 then return end
    if ui.settings and ui.settings.look == 'sf' then
        return require('src.ui.tracker_sf').draw(ui)
    end
    local name = 'tracker'
    local st = ui.state
    local operating = st.active == 'tracker'
    focus.set_shows_frame(name, operating)
    local tabs = (S.tracker.view == 'tabs')
    local shown = pins
    if tabs then shown = { tracker.current_tab(ui, pins) } end
    -- パッドの2段（0.1.170〜）：entries＝件を選ぶ、inside＝その件の中の名前・地図の名前・ボタンを選ぶ。
    -- 段は選択（focus）の今の項目から決める。操作していないときは全部（マウスの乗せ方は前と同じ）
    local level, entry = 'all', nil
    if operating then
        local owner, is_entry = tracker.owner_of(focus.current(name), shown)
        if owner and not is_entry then level, entry = 'inside', owner else level = 'entries' end
        -- タブ表示は1件しか出さないので、件を選ぶ段はなく、いつもその件の中（0.1.171〜）
        if tabs then level, entry = 'inside', shown[1] end
        if owner then st.tracker_last = owner end   -- 次に操作に入るとき、この件から
    end
    st.tracker_level = (level ~= 'all') and level or nil
    st.tracker_entry = entry
    local title = t('tracker.title', { n = #pins })
    -- 見出しの行は出さない（0.1.62〜）。クリックでは入力を奪わない。
    -- 上の行（× とタブ）はいつも見せ、中身だけが動く（0.1.170〜）
    local drawing = window.begin(ui, name, { title = title, operable = false, no_focus = true, frame = 'capsule',
        no_title = true, fixed_top = true })
    if drawing then
        local base = window.font_scale(ui, name)
        local function font(k) window.set_font(ui, base * (tracker.SCALE[k] or 1.0)) end
        local collapsed = S.tracker.collapsed
        local right = (S.tracker.align ~= 'left')
        local align = right and 'right' or 'left'
        local function push_w(w) if right then CT.push_right(imgui, w) end end
        local function line(mode, text)
            CT.wrapped(ui, text, mode, align)
        end
        local show_close = S.tracker.show_close ~= false

        -- 上の行：タブ（タブ表示のとき）と、右上の小さい ×（押すと隠す。マウスだけ。パッドはキャンセルでゲームに戻る）
        font('ops')
        local close_w = show_close and button_w(imgui, '×') or 0
        local top_drawn = false
        if tabs then
            -- タブの名前だけ、タブの文字サイズ（未設定ならトラッカーと同じ）。窓の大きさは変えない
            window.set_font(ui, tracker.tab_font_scale(ui) * (tracker.SCALE.ops or 1.0))
            local sp = style_x(imgui, 'ItemSpacing', 8)
            local tw = tab_width(imgui, tracker.tab_chars(S))
            local room = (avail_x(imgui) or 300) - (show_close and ((close_w or 0) + sp) or 0)
            local n_fit = math.max(1, math.floor((room + sp) / (tw + sp)))
            local arrows = #pins > n_fit
            if arrows then
                local aw = (button_w(imgui, '◀') or 12) + (button_w(imgui, '▶') or 12) + sp * 2
                n_fit = math.max(1, math.floor((room - aw + sp) / (tw + sp)))
            end
            local sel = shown[1]
            local si = 1
            for i, q in ipairs(pins) do if q == sel then si = i end end
            local first = tonumber(st.tracker_tab_first) or 1
            -- 選んだタブが替わったときだけ、そのタブが見えるところまで送る（◀▶ で送った並びは、選び直すまでそのまま）
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
                -- ◀▶（0.1.171〜）：タブの並びを1つ送る（選んでいる件は替えない）。マウスで押す
                if W.button(ui, name, 'tab_prev', '◀', { section = 'head', row = 'h', small = true, no_focus = true,
                    disabled = first <= 1, tooltip = t('tracker.tab_prev') }) then scroll = -1 end
                W.same(ui)
            end
            for i = first, math.min(#pins, first + n_fit - 1) do
                local q = D:quest(pins[i])
                local full = q and tracker.head_text(q) or pins[i]
                local label, cut = tracker.fit_label(imgui, full, tw - style_x(imgui, 'FramePadding', 4) * 2)
                if i > first then W.same(ui) end
                local on = (pins[i] == sel)
                local nc = 0
                if on then
                    for _, k in ipairs({ 'ImGuiCol_Button', 'ImGuiCol_ButtonHovered' }) do
                        if pcall(imgui.PushStyleColor, C(k), theme.col('accent', 0.38)) then nc = nc + 1 end
                    end
                end
                local clicked = W.button(ui, name, 'tab_' .. pins[i], label, { section = 'head', row = 'h', no_focus = true,
                    width = tw, tooltip = cut and full or nil })
                if nc > 0 then pcall(imgui.PopStyleColor, nc) end
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
            top_drawn = true
            font('ops')   -- × とこれ以降はトラッカーの文字サイズ
        end
        if show_close then
            if top_drawn then W.same(ui) end
            CT.push_right(imgui, close_w)
            if W.button(ui, name, 'hide', '×', { section = 'head', row = 'h', small = true, no_focus = true,
                tooltip = t('tracker.hide') }) then
                ui.set_tracker_visible(false)
            end
            top_drawn = true
        end

        -- 中身（ここだけが動く）
        local body_h = math.max(20, (avail_y(imgui) or 200))
        local child = pcall(imgui.BeginChild, '##astertrail_tracker_body', { 0, body_h }, 0, 0)
        if child then window.push(ui, 'child') end
        font('step')
        -- 0.1.226〜：パッドの案内の一行（「パッドで操作中：…」）は出さない（本と同じ。マウスのときに邪魔）
        if st.save_error then line('warn', t('save.failed_once')) end

        local next_missions = marks_core.next_missions(D, P)
        for n_i, qid in ipairs(shown) do
            local q = D:quest(qid)
            -- 件の中をパッドで選べるか（操作していない＝全部、inside＝その件だけ、entries＝件そのものだけ）
            local nf = not (level == 'all' or (level == 'inside' and entry == qid))
            local efocused = false
            if level == 'entries' then
                efocused = focus.item(name, 'e_' .. qid, 'entries', qid)
                imgui.BeginGroup()
                window.push(ui, 'group')
            end
            -- 1) アイコン＋（ミッション番号）＋名前（太め・少し大きく・アクセント色）。押すと詳細
            font('name')
            local icon = tracker.mission_icon(ui, q, next_missions)
            local head = tracker.head_text(q)
            local hw = CT.text_w(imgui, head)
            local iw = icon and ui_marks.inline_icon_w(ui, icon) or 0
            push_w(hw and (hw + 1 + iw) or nil)   -- 太めにした分の 1px
            local icon_tip
            if icon == 'unavailable' and ui.data and ui.progress then
                icon_tip = marks_core.unavailable_tip(ui.t, marks_core.accept_blocks(
                    ui.data, ui.progress, q,
                    ui.player_status and ui.player_status() or nil,
                    ui.inventory_count))
            end
            if icon then ui_marks.inline_icon(ui, icon, { tip_text = icon_tip }) end
            local dim = require('src.ui.book').is_marked_unimplemented(S, qid)
            W.line_pass(imgui, function ()
                if W.link(ui, name, 'q_' .. qid, head, {
                    color = dim and 'muted' or 'accent', section = 'list', row = qid .. '_name', bold = true, no_focus = nf,
                }) then
                    ui.open_detail_solo(qid, 'tracker')
                end
            end)
            font('step')
            if not collapsed then
                local step = P:current_step(qid)
                local nav = P:step_nav(qid)
                local terms = CT.quest_terms(D, q)
                local function term_line(text, key, sid, line_opts, terms_use)
                    line_opts = line_opts or {}
                    local hit = W.term_line(ui, name, 'qn_' .. qid .. key, text, terms_use or terms, {
                        muted = line_opts.muted, color = line_opts.color, align = align,
                        section = 'list', row = qid .. key,
                        focus_acts = nf and {} or { map = true },   -- 地図の名前だけパッドで選べる（コピーはマウス）
                        tip = function (act, piece)
                            if act == 'map' and piece and piece.kind == 'group' then return t('tracker.map_all') end
                            if act == 'map' then return t('map.view') end
                            if act == 'copy' then return t('tracker.copy_item') end
                        end,
                    })
                    if not hit then return end
                    if hit.act == 'map' then
                        -- 人数（5人など）は、その手順の相手を全員地図に出す（0.1.229〜）
                        if hit.kind == 'group' then
                            ui.open_map(qid, sid)
                        else
                            -- 押した名前の相手の場所で地図を開く（0.1.68〜。前はいつもその行の手順の場所）
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
                if step then
                    -- 2) 今の手順（ふつうの大きさ・ふつうの色）
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
                    -- 人数の表記が無い手順でも、複数の相手がいれば「地図」を出す
                    if has_multi and #counts == 0 then
                        W.same(ui)
                        if W.link(ui, name, 'qn_' .. qid .. '_cur_group_map', t('map.view_short'), {
                            color = 'accent', section = 'list', row = qid .. '_cur',
                            no_focus = nf, tooltip = t('tracker.map_all'),
                        }) then
                            ui.open_map(qid, step.id)
                        end
                    end
                    -- 3) 時間帯・天候（資料がある手順だけ。少し小さく・注意の色）
                    if S.tracker.show_time_weather and step.time_weather_ja then
                        font('time')
                        line('warn', labels.time_weather(t, step.time_weather_ja, ui.current_weather and ui.current_weather()))
                        font('step')
                    end
                    -- 4) 次：次の手順（小さく・薄く）
                    font('next')
                    if nav.next then
                        local nx_text = t('tracker.next', { text = nav.next.next_line_ja or t('detail.step_no_text') })
                        local nx_ex
                        nx_text, nx_ex = poss_ui.apply_to_step(ui, nav.next, nx_text, q)
                        local nx_terms = {}
                        for _, x in ipairs(terms) do nx_terms[#nx_terms + 1] = x end
                        poss_ui.merge_terms(nx_terms, nx_ex)
                        term_line(nx_text, '_nx', nav.next.id, { muted = true }, nx_terms)
                    elseif nav.branch then
                        line('muted', t('tracker.next', { text = t('tracker.next_branch') }))
                    elseif nav.last then
                        line('muted', t('tracker.next', { text = t('tracker.next_last') }))
                    end
                    font('step')
                else
                    line('muted', t('tracker.all_done'))
                end

                -- 分岐：▶ で次が選べないとき、進む手順を選ぶ
                local branch = st.branch and st.branch.quest == qid and st.branch
                if branch then
                    line('warn', t('tracker.branch'))
                    for j, nid in ipairs(branch.options) do
                        local ns = D:step(nid)
                        local bl = util.utf8_cut(ns and ns.next_line_ja or nid, 24)
                        push_w(button_w(imgui, bl))
                        if W.button(ui, name, 'br_' .. nid, bl,
                            { section = 'list', row = qid .. '_br' .. j, small = true, no_focus = nf }) then
                            ui.request('set_current_step', qid, nid)
                            st.branch = nil
                        end
                    end
                end

                -- 5) ◀ ▶ ▲ ▼ ピン外し と 手順の数（0.1.64〜：「今/全部」。右そろえは ◀ の左、左そろえはピンの右）
                font('ops')
                local row = qid .. '_ops'
                local ci, ct = P:step_count(qid)
                local count = ci and (tostring(ci) .. '/' .. tostring(ct)) or nil
                local function count_text()
                    theme.TextDisabled(imgui, count)
                    if imgui.IsItemHovered and imgui.IsItemHovered() and imgui.SetTooltip then
                        imgui.SetTooltip(t('tracker.step_count', { cur = ci, total = ct }))
                    end
                end
                local ops_w = buttons_w(imgui, tabs and { '◀', '▶', '   ' } or { '◀', '▶', '▲', '▼', '   ' })
                local cw = count and CT.text_w(imgui, count)
                if ops_w and count then
                    ops_w = cw and (ops_w + cw + style_x(imgui, 'ItemSpacing', 8)) or nil
                end
                push_w(ops_w)
                local unpinned = false
                W.line_pass(imgui, function ()
                if count and right then
                    count_text()
                    W.same(ui)
                end
                if W.button(ui, name, 'prev_' .. qid, '◀', { section = 'list', row = row, small = true, no_focus = nf,
                    disabled = not nav.prev, tooltip = t('tracker.prev_step') }) then
                    ui.tracker_step(qid, -1)
                end
                W.same(ui)
                if W.button(ui, name, 'next_' .. qid, '▶', { section = 'list', row = row, small = true, no_focus = nf,
                    -- 未受注のクエストは、最後の手順で ▶（チェックを付ける）を押せない（0.1.180〜）
                    disabled = (nav.done or not nav.cur or (nav.last and P.steps_locked and P:steps_locked(qid))) and true or false,
                    tooltip = (nav.last and P.steps_locked and P:steps_locked(qid)) and t('detail.check_locked') or t('tracker.next_step') }) then
                    ui.tracker_step(qid, 1)
                end
                W.same(ui)
                -- 並べ替えの ▲▼ は一覧のときだけ（タブ表示では出さない。0.1.171〜）
                if not tabs then
                    if W.button(ui, name, 'up_' .. qid, '▲', { section = 'list', row = row, small = true, no_focus = nf,
                        disabled = not P:can_move_pin(qid, -1), tooltip = t('tracker.up') }) then
                        ui.request('move_pin', qid, -1)
                    end
                    W.same(ui)
                    if W.button(ui, name, 'down_' .. qid, '▼', { section = 'list', row = row, small = true, no_focus = nf,
                        disabled = not P:can_move_pin(qid, 1), tooltip = t('tracker.down') }) then
                        ui.request('move_pin', qid, 1)
                    end
                    W.same(ui)
                end
                unpinned = W.button(ui, name, 'unpin_' .. qid, '   ', { section = 'list', row = row, small = true,
                    no_focus = nf, tooltip = t('tracker.unpin') })
                draw_pin(imgui)
                if count and not right then
                    W.same(ui)
                    count_text()
                end
                end)
                font('step')
                if unpinned then ui.request('unpin', qid) end
                if st.suggest_complete == qid then
                    line('good', t('tracker.suggest_complete'))
                end
            end
            if level == 'entries' then
                window.pop(ui, 'group')
                -- 件ごとの枠（パッドの1段目）
                W.after_item(ui, name, 'e_' .. qid, efocused)
            end
            -- 一覧で複数あるとき、件と件のあいだだけ細い線（最後のあとは引かない）
            if (not tabs) and n_i < #shown then W.entry_sep(ui) end
        end
        -- 一番下の「必要品」（必要品まとめを開く）は 0.1.173 でなくした（t251）
        if child then window.pop(ui, 'child') end
        -- 空いている所をダブルクリックで、たたむ・ひらく（中身の子の窓も含める）
        local okh, hov = pcall(imgui.IsWindowHovered, C('ImGuiHoveredFlags_ChildWindows'))
        local oki, item_hov = pcall(imgui.IsAnyItemHovered)
        if okh and hov and not (oki and item_hov) and imgui.IsMouseDoubleClicked(0) then
            tracker.set_collapsed(ui, not S.tracker.collapsed)
        end
        window.set_font(ui, base)
    end
    local preferred
    if level == 'entries' then preferred = 'e_' .. shown[1]
    elseif entry then preferred = 'q_' .. entry
    else preferred = 'q_' .. shown[1] end
    window.finish(ui, name, preferred)
end

return tracker
