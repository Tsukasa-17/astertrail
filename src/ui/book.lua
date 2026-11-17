--[[
  Astertrail - 本（一覧）
  タブ（クエスト／ミッション）、検索、地域・状態のプルダウン、表の一覧。
  一覧は1件1行の表：☆｜状態｜リピート｜（ミッションなら番号）｜名前｜報酬。セルは幅に合わせて折り返す。
  リピートの列は、資料でリピート可なら「可」、初回クリア後は「[再]」。記載がなければ空。
  クエストはリージョン（サンドリアなど）の大枠の中に開始エリア、その下に表。ミッションは系列ごと。「次」は出さない（トラッカーと詳細で出す）。
  行を選ぶ（クリック・決定）と本の右側に詳細。ダブルクリックで詳細だけの窓にする。
  状態の変更は詳細だけで行う。ピンの印で pin / unpin。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local labels = require('src.ui.labels')
local focus = require('src.ui.focus')
local util = require('src.lib.util')
local settings_mod = require('src.core.settings')
local perf = require('src.core.perf')
local theme = require('src.ui.theme')
local marks_core = require('src.core.marks')
local ui_marks = require('src.ui.marks')
local icons = require('src.ui.icons')

local book = {
    SPLIT = 0.56,      -- 一覧の幅（窓の中の割合）。残りが右の詳細
    SPLIT_TABS = { 'mission', 'quest', 'eminence' },
    table_failed = nil, -- 表（BeginTable）で問題が起きたら、以後は並べたセルで描く
}

-- 0.1.225〜（t497/t498）：ミッション・クエストの「表示：」のチェック（状態の選択と地域の選択はなくした）
book.SHOW_STATES = { 'accepted', 'not_accepted', 'completed' }

-- 出す状態か（無い・壊れた保存は出す）
function book.state_shown(f, st)
    if st == 'unknown' or st == nil then st = 'not_accepted' end
    local show = f and f.show
    if type(show) ~= 'table' then return true end
    return show[st] ~= false
end

-- 0.1.232〜：表示の「未実装」チェック（無い・壊れた保存は出す）
function book.show_unimplemented(S)
    local f = S and S.book and S.book.filters
    local show = f and f.show
    return type(show) ~= 'table' or show.unimplemented ~= false
end

function book.is_marked_unimplemented(S, qid)
    if not qid then return false end
    local marks = S and S.book and S.book.unimplemented
    return type(marks) == 'table' and marks[qid] == true
end

function book.set_unimplemented(S, qid, on)
    if not S or not S.book or not qid then return false end
    local marks = S.book.unimplemented
    if type(marks) ~= 'table' then marks = {}; S.book.unimplemented = marks end
    local cur = marks[qid] == true
    if on and not cur then marks[qid] = true
    elseif (not on) and cur then marks[qid] = nil
    else return false end
    book.clear_view_cache()
    return true
end

function book.toggle_unimplemented(S, qid)
    return book.set_unimplemented(S, qid, not book.is_marked_unimplemented(S, qid))
end

-- 表示の☑未実装がオフのとき隠すか（受注中のものは残す）
function book.hidden_unimplemented(ui, q)
    if not q or not book.is_marked_unimplemented(ui.settings, q.id) then return false end
    if book.show_unimplemented(ui.settings) then return false end
    local st = ui.progress and ui.progress:state(q.id)
    if st == 'accepted' then return false end
    return true
end

local function show_sig(f)
    local show = f and f.show
    if type(show) ~= 'table' then return 'all' end
    local out = {}
    for _, k in ipairs(book.SHOW_STATES) do out[#out + 1] = (show[k] ~= false) and '1' or '0' end
    out[#out + 1] = (show.unimplemented ~= false) and '1' or '0'
    return table.concat(out)
end
book._show_sig = show_sig

local search_buf = { '' }
local search_synced = false

-- 0.1.210〜：一覧と見出しの木は、資料・進み具合・タブ・絞り込み・言語が変わったときだけ作り直す（前は毎フレーム全件）
local view_memo = {}
book._view_memo = view_memo
function book.view_key(ui, extra)
    local S = ui.settings
    local f = S.book.filters or {}
    local PR = ui.progress
    local um = S.book.unimplemented
    local usig = ''
    if type(um) == 'table' then
        local keys = {}
        for k, v in pairs(um) do if v then keys[#keys + 1] = k end end
        table.sort(keys)
        usig = table.concat(keys, ',')
    end
    return tostring(ui.data) .. '|' .. tostring(PR) .. '|' .. tostring(PR and PR.rev or 0) .. '|' .. tostring(S.book.tab)
        .. '|' .. show_sig(f) .. '|' .. tostring(f.text) .. '|' .. tostring(S.language)
        .. '|' .. usig .. '|' .. tostring(extra)
end
function book.clear_view_cache()
    for k in pairs(view_memo) do view_memo[k] = nil end
end
local function memo(name, key, fn)
    local m = view_memo[name]
    if m and m.key == key then return m.val end
    local val = fn()
    view_memo[name] = { key = key, val = val }
    return val
end
book._memo = memo

function book.filtered(ui, opts)
    opts = opts or {}
    local f = ui.settings.book.filters
    if f and f.state == 'unknown' then f.state = 'all' end
    local flags = (opts.ignore_area and 'a' or '') .. (opts.ignore_state and 's' or '') .. (opts.ignore_text and 't' or '')
    return memo('filtered:' .. flags, book.view_key(ui), function () return book.filtered_now(ui, opts) end)
end

function book.filtered_now(ui, opts)
    opts = opts or {}
    local f = ui.settings.book.filters
    local tab = ui.settings.book.tab
    local out = {}
    for _, q in ipairs(ui.data:list(tab)) do
        local ok = true
        -- 地域は左の見出しの木で選ぶ（0.1.225〜、地域の絞り込みはなくした）
        if not opts.ignore_state then
            if ok and not book.state_shown(f, ui.progress:state(q.id)) then ok = false end
        end
        -- 未実装のチェックは件数にも効く（ignore_state でも隠す。受注中は残す）
        if ok and book.hidden_unimplemented(ui, q) then ok = false end
        if ok and (not opts.ignore_text) and f.text and f.text ~= '' then
            local hay = ui.data:search_text(q)
            for _, word in ipairs(util.split_words(f.text)) do
                if not hay:find(util.lower(word), 1, true) then ok = false break end
            end
        end
        if ok then out[#out + 1] = q end
    end
    return out
end

-- 地域ごとの件数（kind = 'mission' / 'quest'）。資料は読み込みのあと変わらないので、data に覚えておく（0.1.174〜）
function book.category_counts(data, kind)
    data._cat_counts = data._cat_counts or {}
    local c = data._cat_counts[kind]
    if c then return c end
    c = {}
    for _, q in ipairs(data:list(kind)) do
        if q.category then c[q.category] = (c[q.category] or 0) + 1 end
    end
    data._cat_counts[kind] = c
    return c
end

-- 報酬のセル（資料の公式名を「、」でつなぐ。無ければ空。作らない）
function book.reward_text(q) return labels.rewards_cell(q) end

-- リピートのセル：資料で可なら「可」、初回クリア後は「[再]」。記載がなければ空（作らない）
function book.repeat_cell(ui, q)
    if ui.progress:repeat_mark(q.id) then return ui.t('badge.repeat') end
    if q.repeatable == 'yes' then return ui.t('book.repeat_yes') end
    return ''
end

-- くり返しの印（0.1.69〜、名前の横）：資料でくり返し可なら 'yes'、初回クリア後は 'again'。記載がなければ nil
function book.repeat_kind(ui, q)
    if ui.progress:repeat_mark(q.id) then return 'again' end
    if q.repeatable == 'yes' then return 'yes' end
    return nil
end

-- 1行分のセル。戻り値: { pin, state, state_color, repeat_text, repeat_kind, no, name, rewards, tip }
function book.row_cells(ui, q)
    local t, P = ui.t, ui.progress
    local st = P:state(q.id)
    local marks = {}
    if P:is_locked(q.id) then marks[#marks + 1] = t('badge.locked') end
    local tip = {}
    local cond = false
    if st == 'not_accepted' then
        local reasons = q.lock_reasons or {}
        if #reasons > 0 then
            cond = true
            for _, r in ipairs(reasons) do tip[#tip + 1] = t('book.lock_reason', { text = r.text_ja or '' }) end
        end
    end
    local rewards = book.reward_text(q)
    local rpt = book.repeat_cell(ui, q)
    local unimplemented = book.is_marked_unimplemented(ui.settings, q.id)
    if unimplemented then marks[#marks + 1] = t('roe.tag_failed.not_impl') end
    return {
        pinned = P:is_pinned(q.id),
        unimplemented = unimplemented or nil,
        state = labels.state(t, st) .. (#marks > 0 and (' ' .. table.concat(marks, '')) or ''),
        state_color = unimplemented and 'muted' or labels.state_color(st),
        repeat_text = rpt,
        repeat_kind = book.repeat_kind(ui, q),
        repeat_color = (rpt == t('badge.repeat')) and 'accent' or 'muted',
        no = q.mission_no or '',
        name = labels.qname(q),
        rewards = rewards,
        tip = tip,
        cond = cond or nil,   -- 状態の右に ※ を出す（説明は ※ の上だけ）
        -- 状態のアイコン（0.1.63〜。相手の印・トラッカーと同じ分け方）
        icon = (ui.data and marks_core.quest_icon(ui.data, P, q, {
            have = ui.inventory_count, next_missions = ui._icon_nm,
            status = ui.player_status and ui.player_status() or nil,
        })) or nil,
    }
end

-- 行が選ばれた／ダブルクリックされた時
local function on_row(ui, q, double)
    if double then
        ui.open_detail_solo(q.id)
    else
        ui.select_in_book(q.id, true)
    end
end

-- 番号の列はミッションのときだけ（クエストには番号が無い）
local function show_no_col(ui)
    return ui.settings.book.tab == 'mission'
end

-- クエストはリージョンの大枠の中に開始エリア。ミッションは系列ごと。
-- 開始エリア（開始NPCの場所）で分けるキー。場所の記載がなければ unknown
function book.zone_key(ui, q)
    local D = ui.data
    local loc = D:start_location(q)
    if loc and loc.zone_id then
        local label = loc.zone_name or D:zone_name(loc.zone_id)
        return 'zone_' .. tostring(loc.zone_id), label, loc.zone_id
    end
    if loc and loc.zone_name and loc.zone_name ~= '' then
        return 'zone_' .. loc.zone_name, loc.zone_name, 10000
    end
    return 'zone_unknown', ui.t('loc.unknown'), 20000
end

function book.zone_groups(ui, list)
    local by, meta = {}, {}
    for _, q in ipairs(list) do
        local id, label, order = book.zone_key(ui, q)
        if not by[id] then
            by[id] = {}
            meta[id] = { id = id, label = label, order = order }
        end
        by[id][#by[id] + 1] = q
    end
    local groups = {}
    for id, items in pairs(by) do
        local m = meta[id]
        groups[#groups + 1] = { id = m.id, label = m.label, items = items, order = m.order }
    end
    table.sort(groups, function (a, b)
        if a.order ~= b.order then return a.order < b.order end
        return tostring(a.label or '') < tostring(b.label or '')
    end)
    return groups
end

-- リージョン（サンドリアなど）の大枠の中に、開始エリアごとの表
function book.region_groups(ui, list)
    local by = {}
    for _, q in ipairs(list) do
        local c = q.category or '_'
        if not by[c] then by[c] = {} end
        by[c][#by[c] + 1] = q
    end
    local groups, seen = {}, {}
    local function add(cid)
        if seen[cid] or not by[cid] then return end
        seen[cid] = true
        groups[#groups + 1] = {
            id = cid,
            label = ui.data:category_label(cid, ui.settings.language),
            children = book.zone_groups(ui, by[cid]),
        }
    end
    for _, c in ipairs(ui.data.categories or {}) do add(c.id) end
    for _, q in ipairs(list) do add(q.category or '_') end
    if #groups == 0 then groups[1] = { id = 'all', items = list } end
    return groups
end

function book.groups(ui, list)
    -- クエストはリージョン＞エリア。ミッションは系列のまま
    local only_quest, has_mission = #list > 0, false
    for _, q in ipairs(list) do
        if q.kind == 'mission' then has_mission = true; only_quest = false end
        if q.kind ~= 'quest' then only_quest = false end
    end
    if only_quest and not has_mission then
        return book.region_groups(ui, list)
    end

    local by = {}
    for _, q in ipairs(list) do
        local c = q.category or '_'
        if not by[c] then by[c] = {} end
        by[c][#by[c] + 1] = q
    end
    local groups, seen = {}, {}
    for _, c in ipairs(ui.data.categories) do
        if by[c.id] and #by[c.id] > 0 then
            groups[#groups + 1] = {
                id = c.id,
                label = ui.data:category_label(c.id, ui.settings.language),
                items = by[c.id],
            }
            seen[c.id] = true
        end
    end
    for _, q in ipairs(list) do
        local c = q.category or '_'
        if not seen[c] and by[c] then
            groups[#groups + 1] = {
                id = c,
                label = ui.data:category_label(c, ui.settings.language),
                items = by[c],
            }
            seen[c] = true
        end
    end
    if #groups == 0 then groups[1] = { id = 'all', items = list } end
    return groups
end

-- セルの文字を列の幅で折り返す（切って隠さない）
local function cell_text(imgui, text, color, muted)
    text = tostring(text or '')
    local avail = imgui.GetContentRegionAvail()
    local w = tonumber(avail) or (type(avail) == 'table' and (avail.x or avail[1])) or 0
    local wrap = type(imgui.PushTextWrapPos) == 'function' and w and w > 8
    if wrap then
        local cx = 0
        if type(imgui.GetCursorPosX) == 'function' then
            cx = tonumber(imgui.GetCursorPosX()) or 0
        elseif type(imgui.GetCursorPos) == 'function' then
            local ok, a = pcall(imgui.GetCursorPos)
            if ok then
                if type(a) == 'table' then cx = tonumber(a.x or a[1]) or 0
                elseif type(a) == 'number' then cx = a end
            end
        end
        imgui.PushTextWrapPos(cx + w)
    end
    if muted then imgui.TextDisabled(text)
    else imgui.TextColored(theme.col(color or 'text'), text) end
    if wrap then imgui.PopTextWrapPos() end
end

local function restore_cursor(imgui, cx, cy)
    if cx == nil or cy == nil then return end
    if type(imgui.SetCursorPos) == 'function' then
        pcall(imgui.SetCursorPos, { cx, cy })
    elseif type(imgui.SetCursorPosX) == 'function' and type(imgui.SetCursorPosY) == 'function' then
        pcall(function () imgui.SetCursorPosX(cx); imgui.SetCursorPosY(cy) end)
    end
end

local function cursor_xy(imgui)
    if type(imgui.GetCursorPosX) == 'function' and type(imgui.GetCursorPosY) == 'function' then
        return imgui.GetCursorPosX(), imgui.GetCursorPosY()
    end
    if type(imgui.GetCursorPos) == 'function' then
        local ok, a, b = pcall(imgui.GetCursorPos)
        if ok then
            if type(a) == 'table' then return a.x or a[1], a.y or a[2] end
            return a, b
        end
    end
    return nil, nil
end

-- 画面上の矩形を足し合わせる（選択枠を折り返し分まで伸ばす用）
function book.union_rect(a, b)
    if not a then return b end
    if not b then return a end
    return {
        math.min(a[1], b[1]), math.min(a[2], b[2]),
        math.max(a[3], b[3]), math.max(a[4], b[4]),
    }
end

local function xy_pair(fn)
    if type(fn) ~= 'function' then return nil, nil end
    local ok, a, b = pcall(fn)
    if not ok then return nil, nil end
    if type(a) == 'table' then
        return tonumber(a.x or a[1]), tonumber(a.y or a[2])
    end
    return tonumber(a), tonumber(b)
end

local function item_rect(imgui)
    local x1, y1 = xy_pair(imgui.GetItemRectMin)
    local x2, y2 = xy_pair(imgui.GetItemRectMax)
    if not (x1 and y1 and x2 and y2) then return nil end
    return { x1, y1, x2, y2 }
end

local function mouse_in(imgui, rect)
    if not rect then return false end
    local mx, my = xy_pair(imgui.GetMousePos)
    if not mx or not my then return false end
    return mx >= rect[1] and my >= rect[2] and mx <= rect[3] and my <= rect[4]
end

local function table_col_w(imgui, idx)
    if type(imgui.TableGetColumnWidth) ~= 'function' then
        local h = book._hdr
        local w = h and tonumber(h.w[idx])
        return (w and w > 0) and w or nil
    end
    local ok, w = pcall(imgui.TableGetColumnWidth, idx)
    if not ok then return nil end
    if type(w) == 'table' then w = w.x or w[1] end
    w = tonumber(w)
    return (w and w > 0) and w or nil
end

local function parse_size(ok, a, b)
    if not ok then return nil, nil end
    if type(a) == 'table' then return tonumber(a.x or a[1]), tonumber(a.y or a[2]) end
    if type(a) == 'userdata' then
        local ox, x = pcall(function () return a.x end)
        local oy, y = pcall(function () return a.y end)
        if ox and oy then return tonumber(x), tonumber(y) end
    end
    return tonumber(a), tonumber(b)
end

-- 折り返しを含めた文字の高さ。測れなければ nil
function book.text_height(imgui, text, wrap_w)
    text = tostring(text or '')
    if text == '' then return 0 end
    if type(imgui.CalcTextSize) ~= 'function' then return nil end
    local w, h
    if wrap_w and wrap_w > 0 then
        w, h = parse_size(pcall(imgui.CalcTextSize, text, nil, false, wrap_w))
        if h and h > 0 then return h end
        w, h = parse_size(pcall(imgui.CalcTextSize, text, nil, wrap_w))
        if h and h > 0 then return h end
    end
    w, h = parse_size(pcall(imgui.CalcTextSize, text))
    if w and h and h > 0 and wrap_w and wrap_w > 0 then
        return math.max(1, math.ceil(w / wrap_w)) * h
    end
    return h
end

-- 一覧の列の並び（表示順）。ピンはいつも左端、番号は番号のある一覧だけ
function book.column_keys(S, with_no)
    local order = settings_mod.normalize_columns(S and S.book and S.book.columns)
    local hidden = settings_mod.normalize_hidden(S and S.book and S.book.hidden, with_no)
    local out = {}
    for _, k in ipairs(order) do
        if (k ~= 'no' or with_no) and not hidden[k] then out[#out + 1] = k end
    end
    return out
end

-- その一覧で出し入れできる列（番号は番号のある一覧だけ）。並びは保存した並び
function book.toggle_keys(S, with_no)
    local out = {}
    for _, k in ipairs(settings_mod.normalize_columns(S and S.book and S.book.columns)) do
        if k ~= 'no' or with_no then out[#out + 1] = k end
    end
    return out
end

function book.column_shown(S, key)
    local h = S and S.book and S.book.hidden
    return not (type(h) == 'table' and h[key] == true)
end

-- 列を出す・隠す。最後の1列は隠さない（戻り値: 変わったか）
function book.toggle_column(S, key, with_no)
    S.book = S.book or {}
    if type(S.book.hidden) ~= 'table' then S.book.hidden = {} end
    local H = S.book.hidden
    if H[key] then H[key] = nil; return true end
    local shown = 0
    for _, k in ipairs(book.toggle_keys(S, with_no)) do
        if not H[k] and k ~= key then shown = shown + 1 end
    end
    if shown == 0 then return false end
    H[key] = true
    return true
end

-- 見えている列 a と b を入れ替える（番号の列が隠れていても、全体の並びの中で入れ替える）
function book.swap_columns(S, a, b)
    if a == b then return false end
    S.book = S.book or {}
    local order = settings_mod.normalize_columns(S.book.columns)
    local ia, ib
    for i, k in ipairs(order) do
        if k == a then ia = i elseif k == b then ib = i end
    end
    if not ia or not ib then return false end
    order[ia], order[ib] = order[ib], order[ia]
    S.book.columns = order
    return true
end

function book.reset_columns(S)
    S.book = S.book or {}
    local same = true
    local cur = settings_mod.normalize_columns(S.book.columns)
    for i, k in ipairs(settings_mod.BOOK_COLUMNS) do if cur[i] ~= k then same = false end end
    S.book.columns = settings_mod.normalize_columns(nil)
    -- 隠した列も出し直す
    if type(S.book.hidden) == 'table' and next(S.book.hidden) ~= nil then same = false end
    S.book.hidden = {}
    local tab = S.book.tab
    if tab ~= 'mission' and tab ~= 'quest' then tab = 'mission' end
    if book.reset_col_widths(S, tab) then same = false end
    return not same
end

-- 名前の右の小さな くり返しの印（0.1.69〜。0.1.173〜は ♾️ のような絵、0.1.177〜は青い文字の【再】）
-- kind = 'yes'（くり返し受けられる）/ 'again'（一度済んで、もう一度受けられる）。戻り値: マウスが乗っているか
function book.repeat_icon(ui, kind)
    local imgui = ui.imgui
    if not imgui or not kind then return end
    if imgui.SameLine then pcall(imgui.SameLine, 0, 4) end
    local a = (kind == 'again') and 1 or 0.85
    pcall(imgui.TextColored, theme.col('repeat_mark', a), ui.t('book.repeat_mark'))
    if imgui.IsItemHovered then
        local ok, hov = pcall(imgui.IsItemHovered)
        if ok and hov and imgui.SetTooltip then
            pcall(imgui.SetTooltip, ui.t(kind == 'again' and 'book.repeat_again_tip' or 'book.repeat_tip'))
            return true
        end
    end
    return false
end

-- 状態の右の ※（受けられない理由があるとき）。理由の説明は ※ に乗せたときだけ（0.1.177〜。行全体では出さない）
function book.cond_icon(ui, c)
    local imgui = ui.imgui
    if not c or not c.cond then return false end
    local tip = c.tip and #c.tip > 0 and table.concat(c.tip, '\n') or nil
    pcall(imgui.SameLine, 0, 2)
    pcall(imgui.TextColored, theme.col('warn'), ui.t('book.cond_mark'))
    local ok, hov = pcall(imgui.IsItemHovered)
    if ok and hov and tip then
        pcall(imgui.SetTooltip, tip)
        return true
    end
    return false
end

-- 列ごとの文字（高さを測る・描く）
local function col_cell(ui, c, key, selected_mark)
    local t = ui.t
    if key == 'state' then return '  ' .. (c.state or ''), c.state_color, c.unimplemented and true or false end
    if key == 'no' then return c.no, 'text', c.unimplemented and true or false end
    if key == 'name' then
        local dim = c.unimplemented and true or false
        local color = dim and 'muted' or (selected_mark and 'accent' or 'text')
        return (selected_mark and '▶ ' or '') .. (c.name or ''), color, dim
    end
    return c.rewards, 'text', true
end
book.col_cell = col_cell

local function row_min_height(imgui, c, keys, selected_mark, ui)
    local rh
    for i, k in ipairs(keys) do
        local w = table_col_w(imgui, i)
        if w then
            local text = col_cell(ui, c, k, selected_mark)
            local v = book.text_height(imgui, text, math.max(8, w - 8))
            if v and (not rh or v > rh) then rh = v end
        end
    end
    return rh
end

local function paint_row_bg(imgui, selected, focused)
    if not (selected or focused) then return false end
    if type(imgui.TableSetBgColor) ~= 'function' then return false end
    local a = selected and 0.22 or 0.12
    return pcall(imgui.TableSetBgColor, theme.C('ImGuiTableBgTarget_RowBg0'), theme.u32('accent', a))
end

local function hide_selectable_bg(imgui)
    local n = 0
    if type(imgui.PushStyleColor) ~= 'function' then return 0 end
    for _, name in ipairs({ 'ImGuiCol_Header', 'ImGuiCol_HeaderHovered', 'ImGuiCol_HeaderActive' }) do
        if pcall(imgui.PushStyleColor, theme.C(name), { 0, 0, 0, 0 }) then n = n + 1 end
    end
    return n
end

-- 見出しの行。見出しをつかんで左右へ動かすと列が入れ替わる（ピンの列は動かない）。
-- 見出しをダブルクリックすると決まった並びに戻る。TableHeader が無い版では、ふつうの見出しだけ
-- opts.has_pin（初期 true）：左端のピン列は動かない。opts.title / swap / reset でエミネンスからも使う（0.1.193〜）
function book.near_col_edge(imgui, r)
    if not r then return false end
    local okm, mx = pcall(imgui.GetMousePos)
    if okm and type(mx) == 'table' then mx = mx.x or mx[1] end
    mx = tonumber(mx)
    if not mx then return false end
    return math.abs(mx - r[1]) <= 6 or math.abs(mx - r[3]) <= 6
end

function book.draw_headers(ui, keys, opts)
    opts = opts or {}
    book._hdr = nil
    local imgui, t, S = ui.imgui, ui.t, ui.settings
    if type(imgui.TableHeader) ~= 'function' then imgui.TableHeadersRow(); return end
    local has_pin = opts.has_pin ~= false
    local title_of = opts.title or function (key) return t('book.col.' .. key) end
    local swap_fn = opts.swap or book.swap_columns
    local reset_fn = opts.reset or book.reset_columns
    local hflag = theme.C_opt('ImGuiTableRowFlags_Headers') or 1
    if not pcall(imgui.TableNextRow, hflag) then imgui.TableNextRow() end
    local swap, reset
    local rects, active = {}, nil
    local ncols = has_pin and (#keys + 1) or #keys
    -- 0.1.210〜：列の幅と左端を見出しのセルで測る（VanaCore の ImGui 1.92 には TableGetColumnWidth が無い）
    local hdr = { x = {}, w = {}, n = ncols }
    book._hdr = hdr
    for col = 0, ncols - 1 do
        imgui.TableSetColumnIndex(col)
        do
            local cx = xy_pair(imgui.GetCursorScreenPos)
            local cw = book.content_width(imgui)
            hdr.x[col], hdr.w[col] = cx, cw
        end
        local key, ki
        if has_pin then
            key = col == 0 and 'pin' or keys[col]
            ki = col > 0 and col or nil
        else
            key = keys[col + 1]
            ki = col + 1
        end
        imgui.TableHeader(title_of(key) .. '##hdr_' .. key)
        if ki then
            rects[ki] = W.item_rect(imgui)
            local hovered = imgui.IsItemHovered()
            if hovered then
                imgui.SetTooltip(t('book.col_drag'))
                -- 列の境の近くのダブルクリックでは並びを戻さない（境は ImGui が幅を扱う）
                if imgui.IsMouseDoubleClicked(0) and not book.near_col_edge(imgui, rects[ki]) then reset = true end
            end
            if imgui.IsItemActive() then active = ki end
        end
    end
    -- つかんだ列は、マウスがとなりの列の真ん中を越えたときだけ一つ動く（速く動きすぎないように）。
    -- 入れ替えた直後は少し待つ（並びが描き直されてから次を判断する）
    if active then
        local okt, tv = pcall(imgui.GetTime)
        local now = okt and tonumber(tv) or nil
        local wait = now and book._swap_t and (now - book._swap_t) < 0.15
        local okm, mx = pcall(imgui.GetMousePos)
        if okm and type(mx) == 'table' then mx = mx.x or mx[1] end
        mx = tonumber(mx)
        if mx and not wait then
            local L, R = rects[active - 1], rects[active + 1]
            if L and active - 1 >= 1 and mx < (L[1] + L[3]) / 2 then
                swap = { keys[active], keys[active - 1] }
            elseif R and mx > (R[1] + R[3]) / 2 then
                swap = { keys[active], keys[active + 1] }
            end
            if swap then book._swap_t = now end
        end
    end
    if swap and swap_fn(S, swap[1], swap[2]) then
        pcall(imgui.ResetMouseDragDelta, 0)
        ui.mark_settings_dirty()
    elseif reset and reset_fn(S) then
        ui.mark_settings_dirty()
    end
end

-- ImGui の表で描く。戻り値: true（描けた）
-- 0.1.207〜：タブごとに表は1つ。見出しもその表の行。幅は同じ表で共有される
local function heading_count(ui, area, counts)
    local c = area.id and counts and counts[tostring(area.id)]
    local done, total = c and c.done, c and c.total
    if not total or total < 1 then
        done, total = 0, #(area.items or {})
        for _, q in ipairs(area.items or {}) do
            if ui.progress:state(q.id) == 'completed' then done = done + 1 end
        end
        if total < 1 then total = nil; done = nil end
    end
    return done, total
end

function book.flatten_book_rows(ui, list)
    local S = ui.settings
    local tab = book.split_tab(S)
    local groups = book.groups(ui, list)
    local counts = book.progress_by_group(ui)
    local out = {}
    local function add_head(g, indent, color)
        local done, total = heading_count(ui, g, counts)
        local open = true
        if g.id ~= nil then open = not book.is_collapsed(S, tab, g.id) end
        out[#out + 1] = {
            kind = 'head',
            id = g.id,
            wid = book.heading_wid(tab, g.id),
            label = g.label,
            done = done,
            total = total,
            color = color,
            indent = indent or 0,
            open = open,
        }
        return open
    end
    for _, g in ipairs(groups) do
        if g.children and #g.children > 0 then
            local open = true
            if g.label then open = add_head(g, 0, 'accent') end
            if open then
                for _, area in ipairs(g.children) do
                    local aopen = true
                    if area.label then aopen = add_head(area, 12, 'text') end
                    if aopen then
                        for _, q in ipairs(area.items or {}) do
                            out[#out + 1] = { kind = 'row', q = q }
                        end
                    end
                end
            end
        else
            local open = true
            if g.label then open = add_head(g, 0, 'accent') end
            if open then
                for _, q in ipairs(g.items or {}) do
                    out[#out + 1] = { kind = 'row', q = q }
                end
            end
        end
    end
    return out
end

-- 幅の保存が明らかにおかしい（★ が 320px など、列の並び変更の名残）ときは使わない
book.NARROW_COL = { pin = true, fav = true, action = true, no = true, progress = true }
function book.widths_look_stale(S, tab, keys)
    local any, bad = false, false
    for _, k in ipairs(keys or {}) do
        local w = book.col_width(S, tab, k)
        if w then
            any = true
            if book.NARROW_COL[k] and w >= settings_mod.stale_narrow_w(S) then bad = true end
        end
    end
    return any and bad
end

-- 一覧の行（0.1.210〜：見えている行だけ描く）
-- VanaCore の ImGui には ImGuiListClipper が無く、前は 1800 行を毎フレーム全部描いていた。
-- 見えない行は「空の行」1〜2 本にまとめ（高さは描いたときに測った値、まだなら一番低い行の高さ）、
-- 縞の色がずれないよう、まとめる行の数の偶奇を合わせる。
-- opts: { force = {行番号}, min = 行数, key = 表ごとの名前, sig = 幅・文字の大きさ, id_of = function(i), scrolling = 表が縦に動くか }
-- fn(i) は行を描く。行の始めは book.next_row で（行の上端を測る）
local vstate = {}
book._vstate = vstate
book._vrow_top = nil

local function cur_y(imgui)
    local ok, y = pcall(imgui.GetCursorPosY)
    return ok and tonumber(y) or nil
end

-- 行を始める（TableNextRow と 1 列目）。行の上端を覚える
function book.next_row(imgui, rh)
    if rh then
        if not pcall(imgui.TableNextRow, 0, rh) then imgui.TableNextRow() end
    else
        imgui.TableNextRow()
    end
    imgui.TableSetColumnIndex(0)
    if book._vmeasure then book._vrow_top = cur_y(imgui) end
end

-- 行の高さが変わりうるもの：列の幅（見出しで測った値）と文字の大きさ
function book.rows_sig(scale, extra)
    local parts = { string.format('%.2f', tonumber(scale) or 1), tostring(extra) }
    local h = book._hdr
    if h and h.w then
        for i = 0, 15 do
            local w = h.w[i]
            if w == nil then break end
            parts[#parts + 1] = tostring(math.floor(w + 0.5))
        end
    end
    return table.concat(parts, ',')
end

function book.can_virtualize(imgui)
    return imgui and type(imgui.GetCursorPosY) == 'function' and type(imgui.GetScrollY) == 'function'
        and type(imgui.GetWindowHeight) == 'function' and type(imgui.TableNextRow) == 'function'
end

function book.for_clipped_rows(imgui, count, fn, opts)
    opts = opts or {}
    local min = opts.min or 80
    if not (opts.key and opts.scrolling and count > min and book.can_virtualize(imgui)) then
        for i = 1, count do fn(i) end
        perf.count('rows', count)
        return
    end
    local key = opts.key
    local st = vstate[key]
    if not st or st.sig ~= opts.sig then
        st = { sig = opts.sig, h = {}, base = st and st.base, adj = st and st.adj, y0 = st and st.y0 }
        vstate[key] = st
    end
    local id_of = opts.id_of or function (i) return i end
    local okh, view = pcall(imgui.GetWindowHeight)
    view = okh and tonumber(view) or 600
    local oks, scroll = pcall(imgui.GetScrollY)
    scroll = oks and tonumber(scroll) or 0
    local base = st.base
    if not base then
        local okf, fh = pcall(imgui.GetFrameHeightWithSpacing)
        base = (okf and tonumber(fh)) or 24
    end
    local adj = st.adj or 4
    local y0 = st.y0 or base
    local margin = base * 3
    local lo, hi = scroll - margin, scroll + view + margin
    local force = {}
    for _, i in ipairs(opts.force or {}) do
        i = tonumber(i)
        if i then
            -- キー・パッドで隣へ動けるよう、前後の行も描く
            for d = -2, 2 do force[i + d] = true end
        end
    end
    -- 描く行を決める
    local draw, est = {}, {}
    local acc = 0
    for i = 1, count do
        local h = st.h[id_of(i)] or base
        est[i] = h
        local top = y0 + acc
        if force[i] or (top + h >= lo and top <= hi) then draw[i] = true end
        acc = acc + h
    end
    local emitted = 0      -- 描いた行と空の行の数（縞の偶奇）
    local drawn = 0
    local prev_kind, prev_top, prev_id, prev_req = nil, nil, nil, nil
    local first_acc = nil
    local function measured(top)
        if not (top and prev_top) then return end
        local h = top - prev_top
        if h <= 0 then return end
        if prev_kind == 'row' then
            st.h[prev_id] = h
            if not st.base or h < st.base then st.base = h end
        elseif prev_kind == 'gap' and prev_req then
            local a = (h - prev_req.sum) / prev_req.n
            if a >= 0 and a < 40 then st.adj = a end
        end
    end
    local function gap(sum, n_rows)
        if n_rows <= 0 then return end
        local rows = (n_rows % 2 == 1) and 1 or 2
        local r1 = sum - adj * rows
        if r1 < 0 then r1 = 0 end
        if not pcall(imgui.TableNextRow, 0, r1) then imgui.TableNextRow() end
        pcall(imgui.TableSetColumnIndex, 0)
        local top = cur_y(imgui)
        measured(top)
        if rows == 2 then
            if not pcall(imgui.TableNextRow, 0, 0) then imgui.TableNextRow() end
            pcall(imgui.TableSetColumnIndex, 0)
        end
        emitted = emitted + rows
        prev_kind, prev_top, prev_id = 'gap', top, nil
        prev_req = { sum = r1, n = rows }
    end
    local skip_sum, skip_n = 0, 0
    acc = 0
    book._vmeasure = true
    for i = 1, count do
        if draw[i] then
            gap(skip_sum, skip_n)
            skip_sum, skip_n = 0, 0
            book._vrow_top = nil
            book._vrow_index = i
            fn(i)
            emitted = emitted + 1
            drawn = drawn + 1
            local top = book._vrow_top
            measured(top)
            if top and not first_acc then
                first_acc = true
                st.y0 = top - acc
            end
            prev_kind, prev_top, prev_id, prev_req = 'row', top, id_of(i), nil
        else
            skip_sum = skip_sum + est[i]
            skip_n = skip_n + 1
        end
        acc = acc + est[i]
    end
    gap(skip_sum, skip_n)
    book._vmeasure = false
    book._vrow_index = nil
    perf.count('rows', drawn)
end

function book.begin_list_table(imgui, id, ncol, flags, avail_w, avail_h)
    if type(imgui.BeginTable) ~= 'function' then return false, flags end
    local scroll = theme.C('ImGuiTableFlags_ScrollY')
    local use_scroll = avail_h and avail_h > 40 and type(scroll) == 'number'
    local f = flags
    if use_scroll then f = flags + scroll end
    local function begin_with(ff, w, h)
        if w and w > 0 then
            local size = (h and h > 0) and { w, h } or { w, 0 }
            local okb, res = pcall(imgui.BeginTable, id, ncol, ff, size)
            if okb then return res, true end
        end
        local okb, res = pcall(imgui.BeginTable, id, ncol, ff)
        if okb then return res, true end
        return imgui.BeginTable(id, ncol, ff), true
    end
    local started = begin_with(f, avail_w, use_scroll and avail_h or 0)
    if not started and use_scroll then
        started = begin_with(flags, avail_w, 0)
        use_scroll = started and false
    end
    return started, use_scroll
end

-- 見出し行：列をまたいで文字を出し、クリックで開閉。フォーカス ID はこれまでどおり
function book.draw_heading_row(ui, name, opts)
    local imgui = ui.imgui
    local C = theme.C
    opts = opts or {}
    imgui.TableNextRow()
    imgui.TableSetColumnIndex(0)
    local open = opts.open ~= false
    if opts.collapse_id ~= nil and not opts.force_open then
        open = not book.is_collapsed(ui.settings, opts.tab, opts.collapse_id)
    end
    local mark = open and '▾ ' or '▸ '
    local text = mark .. book.heading_label(opts.label, opts.done, opts.total)
    local wid = opts.widget_id or book.heading_wid(opts.tab, opts.collapse_id)
    local indent = tonumber(opts.indent) or 0
    local focused = focus.current(name) == wid
    local color = focused and 'accent' or (opts.color or 'text')
    if opts.color == 'accent' or focused then
        pcall(imgui.TableSetBgColor, C('ImGuiTableBgTarget_RowBg0'),
            theme.u32('accent', focused and 0.16 or 0.08))
    end
    local span = (C('ImGuiSelectableFlags_SpanAllColumns') or 0)
    local _, activated = focus.item(name, wid, opts.section or 'list', opts.row or ('h_' .. tostring(opts.collapse_id or 'x')))
    local hid = hide_selectable_bg(imgui)
    local clicked = imgui.Selectable('##' .. wid, false, span)
    if hid > 0 then pcall(imgui.PopStyleColor, hid) end
    local r = item_rect(imgui)
    local x1, y1 = book.table_origin(imgui)
    -- Selectable のあとのカーソルではなく、行の左端から表の幅までを使う
    if not r then
        local cx, cy = cursor_xy(imgui)
        local tw = book.content_width(imgui) or 400
        if cx and cy then r = { cx, cy, cx + tw, cy + 22 } end
    end
    if r then
        -- 1列目のクリップを外して、見出しを行の幅いっぱいに書く
        local right = r[3]
        local tw = book.content_width(imgui)
        if tw and x1 and (x1 + tw) > right then right = x1 + tw end
        pcall(imgui.PushClipRect, r[1], r[2], right, r[4], false)
        local tx = r[1] + 4 + indent
        pcall(imgui.SetCursorScreenPos, { tx, r[2] + 1 })
        imgui.TextColored(theme.col(color), text)
        pcall(imgui.PopClipRect)
    else
        imgui.TextColored(theme.col(color), text)
    end
    W.after_item(ui, name, wid, focused)
    -- マウスだけ開閉。キー／パッドの決定は nav_action が見出しの中へ入る（ここではたたまない）
    if clicked and not activated and opts.collapse_id ~= nil and not opts.force_open then
        if book.toggle_collapsed(ui.settings, opts.tab, opts.collapse_id) then
            ui.mark_settings_dirty()
        end
    end
    return open, focused, r
end

local function draw_quest_row(ui, name, q, selected, keys, sel_flags, deferred_fn, sel_fn)
    local imgui, t = ui.imgui, ui.t
    local c = book.row_cells(ui, q)
    local rh = row_min_height(imgui, c, keys, selected == q.id, ui)
    book.next_row(imgui, rh)
    do
        local can_pin = c.pinned or not c.unimplemented
        local tip = c.pinned and t('book.unpin') or (c.unimplemented and t('book.pin_unimplemented') or t('book.pin'))
        if W.button(ui, name, 'bpin_' .. q.id, c.pinned and '★' or '☆',
            { section = 'list', row = q.id, small = true, disabled = not can_pin, tooltip = tip }) then
            ui.request(c.pinned and 'unpin' or 'pin', q.id)
        end
    end
    imgui.TableSetColumnIndex(1)
    local rid = 'row_' .. q.id
    local focused, activated = focus.item(name, rid, 'list', q.id)
    local cx, cy = cursor_xy(imgui)
    local hid = hide_selectable_bg(imgui)
    local clicked
    if rh then
        local ok_s, res = pcall(imgui.Selectable, '##' .. rid, false, sel_flags, { 0, rh })
        if ok_s then clicked = res
        else clicked = imgui.Selectable('##' .. rid, false, sel_flags) end
    else
        clicked = imgui.Selectable('##' .. rid, false, sel_flags)
    end
    if hid > 0 then pcall(imgui.PopStyleColor, hid) end
    local double = clicked and imgui.IsMouseDoubleClicked(0) and true or false
    local _, rect = W.after_item(ui, name, rid, focused, true)
    local row_rect = book.union_rect(rect, item_rect(imgui))
    restore_cursor(imgui, cx, cy)
    for i, k in ipairs(keys) do
        if i > 1 then imgui.TableSetColumnIndex(i) end
        local text, color, muted = col_cell(ui, c, k, selected == q.id)
        if k == 'state' and c.icon then ui_marks.inline_icon(ui, c.icon) end
        cell_text(imgui, text, color, muted)
        if k == 'state' and book.cond_icon(ui, c) then c.icon_hover = true end
        row_rect = book.union_rect(row_rect, item_rect(imgui))
        if k == 'name' and c.repeat_kind and book.repeat_icon(ui, c.repeat_kind) then c.icon_hover = true end
    end
    if mouse_in(imgui, row_rect) then
        focused = true
        if imgui.IsMouseClicked(0) then
            clicked = true
            if imgui.IsMouseDoubleClicked(0) then double = true end
        end
    end
    if focused and row_rect and deferred_fn then deferred_fn(row_rect) end
    if selected == q.id and row_rect and sel_fn then sel_fn(row_rect) end
    paint_row_bg(imgui, selected == q.id, focused)
    if double then on_row(ui, q, true)
    elseif clicked or activated then on_row(ui, q, false) end
end

-- 一覧を1つの表で描く（項目の行だけ。見出しは左の木。0.1.208〜）
local function draw_flat_book_table(ui, name, list, selected, with_no, force_top)
    local imgui, t = ui.imgui, ui.t
    local C = theme.C
    if type(imgui.BeginTable) ~= 'function' then return false end
    local S = ui.settings
    local keys = book.column_keys(S, with_no)
    local ncol = #keys + 1
    local tab = book.split_tab(S)
    local width_keys = { 'pin' }
    for _, k in ipairs(keys) do width_keys[#width_keys + 1] = k end
    if book.widths_look_stale(S, tab, width_keys) then
        S.book.col_widths = S.book.col_widths or {}
        S.book.col_widths[tab] = {}
        if ui.mark_settings_dirty then ui.mark_settings_dirty() end
    end
    local flags = book.table_flags(S, tab, width_keys)
    local depth = window.depth(ui)
    local deferred, sel_rect
    local ok, err = pcall(function ()
        local avail_w, avail_h = book.content_width(imgui), nil
        do
            local oka, a, b = pcall(imgui.GetContentRegionAvail)
            if oka then
                if type(a) == 'table' then avail_h = tonumber(a.y or a[2]) else avail_h = tonumber(b) end
            end
        end
        local tid = book.table_id('##astertrail_book_table', tab)
        local started, scrolling = book.begin_list_table(imgui, tid, ncol, flags, avail_w, avail_h)
        if not started then error('no_table', 0) end
        window.push(ui, 'table')
        local scale = book.list_scale(ui)
        -- 0.1.210〜：縦にスクロールする表は ImGui の中で子の窓になり、文字の倍率は受け継がれない（ImGui 1.92）。表の中でも倍率を決める
        window.set_font(ui, scale)
        pcall(imgui.TableSetupScrollFreeze, 0, 1)
        local ox, oy = book.table_origin(imgui)
        local title_of = function (k) return t('book.col.' .. k) end
        -- 列の幅は手で変えるだけ（0.1.211〜）。覚えた幅（無ければ初期の幅）で表を始め、あとは ImGui のまま
        local planned = book.plan_col_widths(S, tab, width_keys, avail_w or book.content_width(imgui), scale)
        book.setup_planned_cols(ui, width_keys, planned, title_of)
        book.draw_headers(ui, keys)
        book.apply_scroll(ui, tab, force_top)
        local sel_flags = C('ImGuiSelectableFlags_SpanAllColumns') + C('ImGuiSelectableFlags_AllowDoubleClick')
        ui._icon_nm = marks_core.next_missions(ui.data, ui.progress)
        local force = {}
        local cur = focus.current(name)
        for i, q in ipairs(list) do
            if q and ('row_' .. q.id) == cur then force[#force + 1] = i end
            if q and selected == q.id then force[#force + 1] = i end
        end
        book.for_clipped_rows(imgui, #list, function (i)
            local q = list[i]
            if not q then return end
            draw_quest_row(ui, name, q, selected, keys, sel_flags,
                function (rect) deferred = rect end,
                function (rect) sel_rect = rect end)
        end, { force = force, min = 80, key = 'book:' .. tostring(tab), scrolling = scrolling,
               sig = book.rows_sig(scale), id_of = function (i) local q = list[i]; return q and q.id or i end })
        book.capture_col_widths(ui, tab, width_keys)
        book.capture_scroll(ui, tab)
        if ui.state then ui.state._table_scroll_captured = true end
        book.paint_col_resize_rails(ui, ncol, ox, oy)
        window.pop(ui, 'table')
        book.flush_col_resize_rails(ui)
    end)
    if not ok then
        window.unwind_to(ui, depth)
        if err ~= 'no_table' then
            book.table_failed = tostring(err)
            ui.log('ui', 'book table: ' .. tostring(err))
        end
        return false
    end
    pcall(function ()
        if sel_rect then
            theme.draw_row_bg(imgui, sel_rect[1], sel_rect[2], sel_rect[3], sel_rect[4], 0.22)
        end
        if deferred then theme.draw_focus(imgui, deferred[1], deferred[2], deferred[3], deferred[4], ui.reduce_motion) end
    end)
    return true
end

local function draw_columns(ui, name, list, selected, with_no)
    local imgui, t = ui.imgui, ui.t
    local scale = book.list_scale(ui)
    local avail = imgui.GetContentRegionAvail() or 400
    avail = tonumber(avail) or (type(avail) == 'table' and (avail.x or avail[1])) or 400
    -- 0.1.69〜：初期の並びと同じ ピン・(番号)・名前・報酬・状態。リピートの列は無し
    local x0 = 40 * scale
    local state_w = math.max(90 * scale, avail * 0.18)   -- 0.1.63〜：アイコンの分を足す
    local x_name = x0 + (with_no and 60 * scale or 0)
    local x_state = math.max(x_name + 80, avail - state_w)
    local rest = math.max(80, x_state - x_name)
    local x_rew = x_name + rest * 0.55
    local xs, heads
    if with_no then
        xs = { 0, x0, x_name, x_rew, x_state }
        heads = { t('book.col.pin'), t('book.col.no'), t('book.col.name'), t('book.col.rewards'), t('book.col.state') }
    else
        xs = { 0, x_name, x_rew, x_state }
        heads = { t('book.col.pin'), t('book.col.name'), t('book.col.rewards'), t('book.col.state') }
    end
    local function wrap_cell(xi, text, color, muted)
        local x2 = xs[xi + 1] or avail
        if type(imgui.PushTextWrapPos) == 'function' then
            imgui.PushTextWrapPos(x2 - 6)
        end
        if muted then imgui.TextDisabled(text)
        else imgui.TextColored(theme.col(color or 'text'), text) end
        if type(imgui.PopTextWrapPos) == 'function' then imgui.PopTextWrapPos() end
    end
    local dl = imgui.GetWindowDrawList()
    local function rules(y1, y2)
        local x0 = imgui.GetCursorScreenPos()
        if not dl or not x0 then return end
        local origin = tonumber(x0) or (type(x0) == 'table' and (x0.x or x0[1])) or nil
        if not origin then return end
        for i = 2, #xs do
            local x = origin + xs[i] - 5
            dl:AddLine({ x, y1 }, { x, y2 }, theme.u32('border', 0.45), 1.0)
        end
        dl:AddLine({ origin, y2 + 2 }, { origin + avail, y2 + 2 }, theme.u32('border', 0.25), 1.0)
    end
    imgui.BeginGroup()
    window.push(ui, 'group')
    for i, h in ipairs(heads) do
        if i > 1 then imgui.SameLine(xs[i]) end
        imgui.TextColored(theme.col('accent'), h)
    end
    window.pop(ui, 'group')
    do local _, y1 = imgui.GetItemRectMin(); local _, y2 = imgui.GetItemRectMax(); if y1 and y2 then rules(y1, y2) end end
    ui._icon_nm = marks_core.next_missions(ui.data, ui.progress)
    for _, q in ipairs(list) do
        local c = book.row_cells(ui, q)
        local rid = 'row_' .. q.id
        local y0 = select(2, cursor_xy(imgui))
        do
            local can_pin = c.pinned or not c.unimplemented
            local tip = c.pinned and t('book.unpin') or (c.unimplemented and t('book.pin_unimplemented') or t('book.pin'))
            if W.button(ui, name, 'bpin_' .. q.id, c.pinned and '★' or '☆',
                { section = 'list', row = q.id, small = true, disabled = not can_pin, tooltip = tip }) then
                ui.request(c.pinned and 'unpin' or 'pin', q.id)
            end
        end
        local focused, activated = focus.item(name, rid, 'list', q.id)
        imgui.BeginGroup()
        window.push(ui, 'group')
        -- 各セルを同じ行の先頭から描き、幅で折り返す
        local vi = 2
        local y_max = y0 or 0
        if with_no then
            restore_cursor(imgui, xs[vi], y0)
            wrap_cell(vi, c.no, 'text')
            y_max = math.max(y_max or 0, select(2, cursor_xy(imgui)) or 0)
            vi = vi + 1
        end
        restore_cursor(imgui, xs[vi], y0)
        wrap_cell(vi, (selected == q.id and '▶ ' or '') .. c.name, selected == q.id and 'accent' or 'text')
        if c.repeat_kind then book.repeat_icon(ui, c.repeat_kind) end
        y_max = math.max(y_max or 0, select(2, cursor_xy(imgui)) or 0)
        restore_cursor(imgui, xs[vi + 1], y0)
        wrap_cell(vi + 1, c.rewards, 'text', true)
        y_max = math.max(y_max or 0, select(2, cursor_xy(imgui)) or 0)
        restore_cursor(imgui, xs[vi + 2], y0)
        if c.icon then ui_marks.inline_icon(ui, c.icon) end
        wrap_cell(vi + 2, c.state, c.state_color)
        book.cond_icon(ui, c)
        y_max = math.max(y_max or 0, select(2, cursor_xy(imgui)) or 0)
        if y_max and y0 and y_max > y0 then
            restore_cursor(imgui, 0, y_max)
        end
        imgui.Dummy({ 1, 1 })
        window.pop(ui, 'group')
        local clicked = imgui.IsItemClicked(0)
        local double = clicked and imgui.IsMouseDoubleClicked(0) and true or false
        do local _, y1 = imgui.GetItemRectMin(); local _, y2 = imgui.GetItemRectMax(); if y1 and y2 then rules(y1, y2) end end
        W.after_item(ui, name, rid, focused)
        if selected == q.id then
            local r = item_rect(imgui)
            if r then theme.draw_row_bg(imgui, r[1], r[2], r[3], r[4], 0.22) end
        end
        if double then on_row(ui, q, true)
        elseif clicked or activated then on_row(ui, q, false) end
    end
end

-- 選んだ見出しの項目だけを、1つの表で描く（0.1.208〜）
local function draw_list(ui, name, list, selected, force_top)
    local with_no = show_no_col(ui)
    list = list or {}
    if book.table_failed or not draw_flat_book_table(ui, name, list, selected, with_no, force_top) then
        local tab = book.split_tab(ui.settings)
        book.apply_scroll(ui, tab, force_top)
        draw_columns(ui, name, list, selected, with_no)
        book.capture_scroll(ui, tab)
    end
end

-- 幅の計算（文字の大きさが変わっても合うように、その場で測る）
local function vec_x(a)
    if type(a) == 'table' then return tonumber(a.x or a[1]) end
    if type(a) == 'userdata' then
        local ok, x = pcall(function () return a.x end)
        return ok and tonumber(x) or nil
    end
    return tonumber(a)
end

local function style_vec(imgui, key, fallback)
    local ok, st = pcall(imgui.GetStyle)
    if ok and st then
        local ok2, v = pcall(function () return st[key] end)
        if ok2 and v ~= nil then
            local x = vec_x(v)
            if x then return x end
        end
    end
    return fallback
end

local function item_spacing(imgui) return style_vec(imgui, 'ItemSpacing', 8) end

local function button_w(imgui, label)
    local w
    if type(imgui.CalcTextSize) == 'function' then
        local ok, a = pcall(imgui.CalcTextSize, label)
        if ok then w = vec_x(a) end
    end
    w = w or (#label * 7)
    return w + style_vec(imgui, 'FramePadding', 4) * 2
end

local function avail_x(imgui)
    local ok, a = pcall(imgui.GetContentRegionAvail)
    if not ok then return nil end
    return vec_x(a)
end

-- 同じ行の右端へ寄せる。入らなければ次の行の右端へ
local function right_align(imgui, need)
    imgui.SameLine()
    local rest = avail_x(imgui)
    local okc, cx = pcall(imgui.GetCursorPosX)
    if not rest or not okc or not tonumber(cx) then return end
    if rest < need then
        imgui.NewLine()
        rest = avail_x(imgui) or rest
        okc, cx = pcall(imgui.GetCursorPosX)
        if not okc or not tonumber(cx) then return end
    end
    if rest > need then pcall(imgui.SetCursorPosX, cx + rest - need) end
end

-- 今のタブの、一覧と詳細の境目の割合（0.1.192〜）。タブはミッション・クエスト・エミネンス
function book.split_tab(S)
    local tab = S and S.book and S.book.tab
    if tab == 'quest' or tab == 'eminence' or tab == 'mission' then return tab end
    return 'mission'
end

function book.split_of(S, tab)
    tab = tab or book.split_tab(S)
    local splits = S and S.book and S.book.splits
    local r = type(splits) == 'table' and tonumber(splits[tab])
    return r or book.SPLIT
end

-- 今のタブ（または指定のタブ）の割合を書く。変わったら true
function book.set_split(S, ratio, tab)
    if not S or not S.book then return false end
    tab = tab or book.split_tab(S)
    S.book.splits = S.book.splits or {}
    local r = math.floor((tonumber(ratio) or book.SPLIT) * 1000 + 0.5) / 1000
    if r < 0.2 then r = 0.2 elseif r > 0.8 then r = 0.8 end
    if S.book.splits[tab] == r then return false end
    S.book.splits[tab] = r
    return true
end

-- 左の見出しの木の幅（窓に対する割合。初期 0.18）
book.TREE_SPLIT = 0.18
function book.tree_split_of(S, tab)
    tab = tab or book.split_tab(S)
    local splits = S and S.book and S.book.tree_splits
    local r = type(splits) == 'table' and tonumber(splits[tab])
    return r or book.TREE_SPLIT
end

function book.set_tree_split(S, ratio, tab)
    if not S or not S.book then return false end
    tab = tab or book.split_tab(S)
    S.book.tree_splits = S.book.tree_splits or {}
    local r = math.floor((tonumber(ratio) or book.TREE_SPLIT) * 1000 + 0.5) / 1000
    if r < 0.08 then r = 0.08 elseif r > 0.45 then r = 0.45 end
    if S.book.tree_splits[tab] == r then return false end
    S.book.tree_splits[tab] = r
    return true
end

-- たたんだ見出し（0.1.193〜）。無いものは開いている
function book.is_collapsed(S, tab, id)
    tab = tab or book.split_tab(S)
    local c = S and S.book and S.book.collapsed
    local t = type(c) == 'table' and c[tab]
    return type(t) == 'table' and t[tostring(id)] == true
end

function book.set_collapsed(S, tab, id, collapsed)
    if not S or not S.book or id == nil then return false end
    tab = tab or book.split_tab(S)
    S.book.collapsed = S.book.collapsed or {}
    S.book.collapsed[tab] = S.book.collapsed[tab] or {}
    local t = S.book.collapsed[tab]
    local k = tostring(id)
    if collapsed then
        if t[k] == true then return false end
        t[k] = true
    else
        if t[k] == nil then return false end
        t[k] = nil
    end
    return true
end

function book.toggle_collapsed(S, tab, id)
    return book.set_collapsed(S, tab, id, not book.is_collapsed(S, tab, id))
end

-- 見出しの件数（状態の絞り込みは無視。地域・検索は反映）
function book.progress_by_group(ui)
    local all = book.filtered(ui, { ignore_state = true, ignore_text = true, ignore_area = true })
    local groups = book.groups(ui, all)
    local map = {}
    local function acc(g)
        local items
        if g.children and #g.children > 0 then
            items = {}
            for _, ch in ipairs(g.children) do
                acc(ch)
                for _, q in ipairs(ch.items or {}) do items[#items + 1] = q end
            end
        else
            items = g.items or {}
        end
        local done, total = 0, #items
        for _, q in ipairs(items) do
            if ui.progress:state(q.id) == 'completed' then done = done + 1 end
        end
        if g.id then map[tostring(g.id)] = { done = done, total = total } end
    end
    for _, g in ipairs(groups) do acc(g) end
    return map
end

function book.heading_label(label, done, total)
    label = tostring(label or '')
    if total and total > 0 then
        return label .. '  (' .. tostring(done or 0) .. '/' .. tostring(total) .. ')'
    end
    return label
end

book.ALL_ID = 'all'

-- 木の材料：状態・検索・地域では減らさない（件数は達成/総数のまま）
function book.tree_source_list(ui)
    return book.filtered(ui, { ignore_state = true, ignore_text = true, ignore_area = true })
end

local function node_from_group(ui, g, counts, indent, id_prefix)
    local done, total = heading_count(ui, g, counts)
    local nid = g.id
    -- 同じエリアが見つかる地域が複数あるので、子の id は「地域/エリア」にする
    if id_prefix and nid then nid = tostring(id_prefix) .. '/' .. tostring(nid) end
    local n = {
        id = nid,
        label = g.label,
        done = done,
        total = total,
        indent = indent or 0,
        children = {},
        items = g.items,
    }
    if g.children then
        for _, ch in ipairs(g.children) do
            n.children[#n.children + 1] = node_from_group(ui, ch, counts, (indent or 0) + 12, g.id)
        end
    end
    return n
end

-- タブの見出しの木（「すべて」は含まない）
function book.tab_tree(ui)
    return memo('tab_tree', book.view_key(ui), function () return book.tab_tree_now(ui) end)
end

function book.tab_tree_now(ui)
    local list = book.tree_source_list(ui)
    local counts = book.progress_by_group(ui)
    local groups = book.groups(ui, list)
    local out = {}
    for _, g in ipairs(groups) do
        if g.label then
            out[#out + 1] = node_from_group(ui, g, counts, 0)
        elseif g.children then
            for _, ch in ipairs(g.children) do
                if ch.label then out[#out + 1] = node_from_group(ui, ch, counts, 0) end
            end
        end
    end
    return out
end

local function sum_counts(nodes)
    local done, total = 0, 0
    for _, n in ipairs(nodes or {}) do
        done = done + (tonumber(n.done) or 0)
        total = total + (tonumber(n.total) or 0)
    end
    return done, total
end

function book.tree_nodes(ui)
    local tab = book.split_tab(ui.settings)
    local children
    if tab == 'eminence' then
        local em = require('src.ui.eminence')
        children = (em.heading_tree and em.heading_tree(ui)) or {}
    else
        children = book.tab_tree(ui)
    end
    local done, total = sum_counts(children)
    -- 中が一段しかないときの合計は、その段の件数の和
    if total == 0 then
        for _, n in ipairs(children) do
            if n.children then
                for _, ch in ipairs(n.children) do
                    done = done + (tonumber(ch.done) or 0)
                    total = total + (tonumber(ch.total) or 0)
                end
            end
        end
    end
    local all = {
        id = book.ALL_ID,
        label = ui.t('filter.all'),
        done = done,
        total = total,
        indent = 0,
        children = {},
        is_all = true,
    }
    local out = { all }
    for _, n in ipairs(children) do out[#out + 1] = n end
    return out
end

local function collect_items(node, out)
    for _, q in ipairs(node.items or {}) do out[#out + 1] = q end
    for _, ch in ipairs(node.children or {}) do collect_items(ch, out) end
end

local function find_node(nodes, id)
    if id == nil then return nil end
    id = tostring(id)
    for _, n in ipairs(nodes or {}) do
        if tostring(n.id) == id then return n end
        local f = find_node(n.children, id)
        if f then return f end
    end
    return nil
end

-- 見出し（親なら子の分も含む）に含まれる項目。並びは木の順
function book.entries_under_heading(ui, heading_id, list)
    list = list or book.filtered(ui)
    heading_id = heading_id or book.current_heading(ui.settings)
    if not heading_id or heading_id == book.ALL_ID then return list end
    local tree = book.tab_tree(ui)
    local node = find_node(tree, heading_id)
    if not node then return {} end
    local allowed, order = {}, {}
    collect_items(node, order)
    for _, q in ipairs(order) do allowed[q.id] = true end
    local out = {}
    for _, q in ipairs(list) do
        if allowed[q.id] then out[#out + 1] = q end
    end
    return out
end

function book.heading_of_quest(ui, qid)
    if not qid then return nil end
    local q = ui.data and ui.data.quest and ui.data:quest(qid)
    if not q then
        -- id だけで探す
        for _, it in ipairs(book.tree_source_list(ui)) do
            if it.id == qid then q = it; break end
        end
    end
    if not q then return nil end
    local tree = book.tab_tree(ui)
    local function has(n)
        for _, item in ipairs(n.items or {}) do if item.id == qid then return true end end
        for _, ch in ipairs(n.children or {}) do if has(ch) then return true end end
        return false
    end
    -- いちばん細い見出し（エリア）を優先
    local best
    local function walk(nodes)
        for _, n in ipairs(nodes or {}) do
            if has(n) then
                best = n.id
                walk(n.children)
                return
            end
        end
    end
    walk(tree)
    return best
end

function book.current_heading(S, tab)
    tab = tab or book.split_tab(S)
    local h = S and S.book and S.book.last_heading
    local id = type(h) == 'table' and h[tab] or nil
    if id == nil or id == '' then return nil end
    return tostring(id)
end

function book.set_heading(S, tab, id, dirty)
    if not S or not S.book then return false end
    tab = tab or book.split_tab(S)
    S.book.last_heading = S.book.last_heading or {}
    id = tostring(id or book.ALL_ID)
    if S.book.last_heading[tab] == id then return false end
    S.book.last_heading[tab] = id
    if dirty then dirty() end
    return true
end

-- 表示する見出し：検索中は「すべて」（保存は変えない）
function book.display_heading(ui)
    local S = ui.settings
    local tab = book.split_tab(S)
    if tab == 'eminence' then
        local E = S.eminence or {}
        if E.book_text and E.book_text ~= '' then return book.ALL_ID end
    else
        local f = S.book.filters
        if f and f.text and f.text ~= '' then return book.ALL_ID end
    end
    return book.current_heading(S, tab) or book.ALL_ID
end

-- 木に出ている見出し（たたんだ見出しの子は出ない）。カーソルを乗せるとき用（0.1.233〜）
function book.visible_heading(ui, hid)
    local S = ui and ui.settings
    local tab = book.split_tab(S)
    hid = hid or book.display_heading(ui)
    if not hid or hid == book.ALL_ID then return book.ALL_ID end
    local vis = book.ALL_ID
    for _, id in ipairs(book.heading_path_ids(ui, hid)) do
        if id ~= book.ALL_ID then
            vis = id
            if book.is_collapsed(S, tab, id) then break end
        end
    end
    return vis
end

function book.heading_path_ids(ui, heading_id)
    local out = {}
    if not heading_id or heading_id == book.ALL_ID then return out end
    heading_id = tostring(heading_id)
    local function walk(nodes, path)
        for _, n in ipairs(nodes or {}) do
            path[#path + 1] = n.id
            if tostring(n.id) == heading_id then
                for i = 1, #path do out[i] = path[i] end
                return true
            end
            if walk(n.children, path) then return true end
            path[#path] = nil
        end
        return false
    end
    walk(book.tree_nodes(ui), {})
    return out
end

-- たたみ込み見出し（表の外）。widget_id を指定すると、その id でボタンを出す（エミネンスの cat_<id> 用）
function book.section_heading(ui, name, opts)
    opts = opts or {}
    local tab = opts.tab or book.split_tab(ui.settings)
    local id = opts.id
    local open = true
    if id ~= nil and not opts.force_open then
        open = not book.is_collapsed(ui.settings, tab, id)
    end
    local mark = open and '▾ ' or '▸ '
    local label = mark .. book.heading_label(opts.label, opts.done, opts.total)
    local wid = opts.widget_id or ('sec_' .. tab .. '_' .. tostring(id or 'x'))
    local indent = tonumber(opts.indent) or 0
    if indent > 0 then
        ui.imgui.Dummy({ indent, 1 })
        ui.imgui.SameLine()
    end
    local focused = focus.current(name) == wid
    local color = focused and 'accent' or (opts.color or 'text')
    if W.button(ui, name, wid, label, { section = opts.section or 'list', row = opts.row or 'head', color = color, small = true }) then
        if id ~= nil and not opts.force_open then
            if book.toggle_collapsed(ui.settings, tab, id) then ui.mark_settings_dirty() end
        end
    end
    return open
end

-- 列の幅（0.1.193〜）。覚えてあるのはピクセルのまま（文字サイズでは変えない）
function book.col_widths_of(S, tab)
    tab = tab or book.split_tab(S)
    local w = S and S.book and S.book.col_widths
    if type(w) ~= 'table' then return {} end
    return w[tab] or {}
end

function book.col_width(S, tab, key)
    local w = book.col_widths_of(S, tab)[key]
    w = tonumber(w)
    if w and w >= 16 and w <= settings_mod.COL_WIDTH_MAX then return math.floor(w + 0.5) end
    return nil
end

-- 列の初期の幅（px）。ボタン類は固定、名前と報酬は残りを分け合う（0.1.205〜）
book.COL_FIXED = { pin = 36, fav = 36, action = 76, no = 64, progress = 58, state = 80 }
book.COL_WEIGHT = { name = 2.2, rewards = 1.3 }
local col_width_gen = { mission = 0, quest = 0, eminence = 0 }
local col_drag = nil           -- { i = 境の番号 } ドラッグ中はマウスが境を離れてもハイライトを保つ
local pending_col_rails = nil

function book.col_width_gen(tab)
    return col_width_gen[tab] or 0
end

-- 表はタブに1つ。初期値に戻したときだけ ID を変えて、ImGui が覚えている古い幅を捨てる
function book.table_id(id, tab)
    if not id or id == '' then return id end
    local g = col_width_gen[tab] or 0
    if g > 0 then return id .. '_g' .. tostring(g) end
    return id
end
function book.table_id_with_gen(id, tab)
    return book.table_id(id, tab)
end

function book.content_width(imgui)
    if not imgui or type(imgui.GetContentRegionAvail) ~= 'function' then return nil end
    local ok, a, b = pcall(imgui.GetContentRegionAvail)
    if not ok then return nil end
    if type(a) == 'table' then return tonumber(a.x or a[1]) end
    if type(a) == 'userdata' then
        local okx, x = pcall(function () return a.x end)
        if okx then return tonumber(x) end
    end
    return tonumber(a) or tonumber(b)
end

-- 分類の枠は、グループの中身の幅ではなく一覧の幅いっぱいにする（0.1.205〜）
function book.section_bounds(r, origin_x, width)
    if not r then return nil end
    local x1, y1, x2, y2 = r[1], r[2], r[3], r[4]
    origin_x, width = tonumber(origin_x), tonumber(width)
    if origin_x and width and width > 0 then
        x1, x2 = origin_x, origin_x + width
    end
    return x1, y1, x2, y2
end

function book.plan_col_widths(S, tab, keys, avail_w, scale)
    keys = keys or {}
    scale = tonumber(scale) or 1
    if scale < 0.5 then scale = 0.5 end
    avail_w = tonumber(avail_w) or 0
    -- 表の内側の余白・線のぶんだけ少し引く（列数では引かない。引きすぎると名前が潰れる）
    local inner = avail_w > 0 and math.max(80, avail_w - 12) or 0
    local min_st = 48
    local last = keys[#keys]
    local widths, stretch = {}, {}
    local used = 0
    for _, k in ipairs(keys) do
        if k == last then
            -- 最後の列は伸び縮みして表を埋める。ここではまだ幅を決めない
        else
            local saved = book.col_width(S, tab, k)
            if saved then
                widths[k] = saved
                used = used + saved
            elseif book.COL_WEIGHT[k] then
                stretch[#stretch + 1] = k
            else
                local d = book.COL_FIXED[k] or 40
                local w = math.max(16, math.floor(d * scale + 0.5))
                widths[k] = w
                used = used + w
            end
        end
    end
    local left = inner - used - min_st   -- 最後の列の下限を残す
    if #stretch > 0 then
        if left < min_st * #stretch then left = min_st * #stretch end
        local tw = 0
        for _, k in ipairs(stretch) do tw = tw + book.COL_WEIGHT[k] end
        if tw <= 0 then tw = #stretch end
        local acc = 0
        for i, k in ipairs(stretch) do
            local w
            if i == #stretch then w = left - acc else w = math.floor(left * (book.COL_WEIGHT[k] / tw) + 0.5) end
            if w < min_st then w = min_st end
            widths[k] = w
            used = used + w
            acc = acc + w
        end
    end
    if last then
        local lw = inner > 0 and (inner - used) or (book.COL_FIXED[last] or min_st)
        if lw < min_st then lw = min_st end
        widths[last] = lw
    end
    return widths
end

-- 一覧（見出しの木と表）の文字の大きさ（0.1.209〜）。窓の大きさは変えない
function book.list_scale(ui)
    return settings_mod.font_for(ui and ui.settings, 'list')
end

function book.cell_pad_x(imgui)
    local ok, st = pcall(function () return imgui.GetStyle() end)
    if ok and st then
        local okp, cp = pcall(function () return st.CellPadding end)
        if okp and cp then
            local x = (type(cp) == 'table' and (cp.x or cp[1])) or nil
            if x == nil then
                local okx, v = pcall(function () return cp.x end)
                if okx then x = v end
            end
            if tonumber(x) then return tonumber(x) end
        end
    end
    return 4
end

function book.setup_planned_cols(ui, keys, planned, title_of)
    local imgui = ui and ui.imgui
    if not imgui or type(imgui.TableSetupColumn) ~= 'function' then return end
    local fx = theme.C('ImGuiTableColumnFlags_WidthFixed')
    local st = theme.C('ImGuiTableColumnFlags_WidthStretch')
    local n = keys and #keys or 0
    for i, k in ipairs(keys or {}) do
        local title = title_of and title_of(k) or tostring(k)
        local w = planned and planned[k]
        -- 最後の列だけ伸ばして表を埋める。ほかは列の ID で共有した固定幅
        if i == n then
            if w then imgui.TableSetupColumn(title, st, w)
            else imgui.TableSetupColumn(title, st) end
        elseif w then
            imgui.TableSetupColumn(title, fx, w)
        else
            imgui.TableSetupColumn(title, fx)
        end
    end
end

function book.read_table_col_widths(imgui, keys)
    local out = {}
    if not imgui then return out end
    if type(imgui.TableGetColumnWidth) ~= 'function' then
        -- 0.1.210〜：見出しのセルで測った幅（このフレームの並び）
        local h = book._hdr
        if not h then return out end
        for i, key in ipairs(keys or {}) do
            local w = tonumber(h.w[i - 1])
            if w and w >= 16 and w <= settings_mod.COL_WIDTH_MAX then out[key] = math.floor(w + 0.5) end
        end
        return out
    end
    for i, key in ipairs(keys or {}) do
        local ok, w = pcall(imgui.TableGetColumnWidth, i - 1)
        w = ok and tonumber(w)
        if type(w) == 'table' then w = w.x or w[1] end
        w = tonumber(w)
        if w and w >= 16 and w <= settings_mod.COL_WIDTH_MAX then out[key] = math.floor(w + 0.5) end
    end
    return out
end

-- 列の境をつかんで動かし、離したときに1回だけ幅を覚える（0.1.211〜）。
-- 覚えるのは境をつかんだときだけ（行や窓の中をクリック・ドラッグしても覚えない）。最後の列は伸び縮みするので覚えない。
-- 覚えた幅は次に表を作るとき（本を開き直す・読み込み直す）の初めの幅。いま出ている表の幅は ImGui のまま変えない
function book.capture_col_widths(ui, tab, keys)
    local imgui = ui and ui.imgui
    if not imgui then return false end
    if type(imgui.TableGetColumnWidth) ~= 'function' and not book._hdr then return false end
    tab = tab or book.split_tab(ui.settings)
    local down = type(imgui.IsMouseDown) == 'function' and imgui.IsMouseDown(0)
    local active = down and col_drag ~= nil
    local finishing = book._col_was_dragging and not active
    book._col_was_dragging = active or nil
    if not finishing then return false end
    local got = book.read_table_col_widths(imgui, keys)
    local S = ui.settings
    S.book.col_widths = S.book.col_widths or {}
    S.book.col_widths[tab] = S.book.col_widths[tab] or {}
    local dest = S.book.col_widths[tab]
    local dirty = false
    local last = keys and keys[#keys]
    for _, key in ipairs(keys or {}) do
        local w = got[key]
        if key ~= last and w and dest[key] ~= w then dest[key] = w; dirty = true end
    end
    if dirty and ui.mark_settings_dirty then ui.mark_settings_dirty() end
    return dirty
end

function book.reset_col_widths(S, tab)
    if not S or not S.book then return false end
    tab = tab or book.split_tab(S)
    S.book.col_widths = S.book.col_widths or {}
    local cur = S.book.col_widths[tab]
    local n = 0
    if type(cur) == 'table' then for _ in pairs(cur) do n = n + 1 end end
    S.book.col_widths[tab] = {}
    -- ImGui が同じ表 ID に覚えている幅を捨てる
    col_width_gen[tab] = (col_width_gen[tab] or 0) + 1
    book._col_was_dragging = nil
    return n > 0
end

function book.setup_col(ui, title, tab, key, flags, width)
    local saved = book.col_width(ui.settings, tab, key)
    if saved then
        ui.imgui.TableSetupColumn(title, theme.C('ImGuiTableColumnFlags_WidthFixed'), saved)
    elseif flags then
        ui.imgui.TableSetupColumn(title, flags, width)
    else
        ui.imgui.TableSetupColumn(title)
    end
end

-- 列の境のつかめる線。表の中は列で切り取られるので、位置だけ表の中で集め、描くのは表を閉じてから（flush）

function book.paint_col_resize_rails(ui, ncol, ox, oy)
    pending_col_rails = nil
    local imgui = ui and ui.imgui
    if not imgui or not ox or not oy or not ncol or ncol < 2 then return end
    local hdr = (type(imgui.TableGetColumnWidth) ~= 'function') and book._hdr or nil
    if type(imgui.TableGetColumnWidth) ~= 'function' and not hdr then return end
    local padx = book.cell_pad_x(imgui)
    local _, cy = xy_pair(imgui.GetCursorScreenPos)
    local y2 = cy or (oy + 20)
    if y2 < oy + 4 then y2 = oy + 20 end
    local mx, my = xy_pair(imgui.GetMousePos)
    local down = type(imgui.IsMouseDown) == 'function' and imgui.IsMouseDown(0)
    if col_drag and not down then col_drag = nil end
    local x = ox
    local rails = { y1 = oy, y2 = y2, items = {} }
    for i = 0, ncol - 2 do
        if hdr then
            -- 境 = その列の文字の左端 + 幅 + セルの余白
            local cx, cw = tonumber(hdr.x[i]), tonumber(hdr.w[i])
            if not cx or not cw then break end
            x = cx + cw + padx
        else
            local okw, w = pcall(imgui.TableGetColumnWidth, i)
            w = okw and tonumber(w)
            if not w then break end
            x = x + w
        end
        local hovered = mx and my and math.abs(mx - x) <= 5 and my >= oy and my <= y2
        if hovered and down then col_drag = { i = i } end
        local active = (col_drag and col_drag.i == i) or false
        rails.items[#rails.items + 1] = { x = x, hovered = hovered, active = active }
    end
    pending_col_rails = rails
end

-- 表を閉じたあとで描く（列のクリップの外、前景の線）
function book.flush_col_resize_rails(ui)
    local rails = pending_col_rails
    pending_col_rails = nil
    if not rails or not ui or not ui.imgui then return end
    for _, r in ipairs(rails.items or {}) do
        theme.draw_resize_rail(ui.imgui, r.x, rails.y1, rails.y2, r.hovered, r.active)
    end
end

function book.table_origin(imgui)
    local ok, a, b = pcall(imgui.GetCursorScreenPos)
    if not ok then return nil, nil end
    if type(a) == 'table' then return tonumber(a.x or a[1]), tonumber(a.y or a[2]) end
    return tonumber(a), tonumber(b)
end

function book.table_flags(S, tab, width_keys)
    -- 0.1.205〜：保存の有無にかかわらず、同じ方針で一覧の幅いっぱいにする
    local flags = theme.C('ImGuiTableFlags_Borders')
        + theme.C('ImGuiTableFlags_RowBg')
        + theme.C('ImGuiTableFlags_NoSavedSettings')
        + theme.C('ImGuiTableFlags_Resizable')
        + theme.C('ImGuiTableFlags_SizingStretchProp')
    return flags
end

-- 一覧の幅（割合を窓の幅に掛け、両側に最低限の幅を残す）
-- 0.1.208〜：list_width は「見出しの木＋表」（詳細の左）の幅
book.SPLIT_MIN_LIST, book.SPLIT_MIN_DETAIL = 260, 240
book.SPLIT_MIN_TREE, book.SPLIT_MIN_TABLE = 120, 200
function book.list_width(avail_w, ratio)
    avail_w = tonumber(avail_w) or 800
    ratio = tonumber(ratio) or book.SPLIT
    local w = math.floor(avail_w * ratio)
    local hi = avail_w - book.SPLIT_MIN_DETAIL
    if w > hi then w = hi end
    if w < book.SPLIT_MIN_LIST then w = book.SPLIT_MIN_LIST end
    return math.floor(w)
end

function book.tree_width(avail_w, list_w, ratio)
    avail_w = tonumber(avail_w) or 800
    list_w = tonumber(list_w) or 0
    ratio = tonumber(ratio) or book.TREE_SPLIT
    local w = math.floor(avail_w * ratio + 0.5)
    local min_t, min_b = book.SPLIT_MIN_TREE, book.SPLIT_MIN_TABLE
    local max_w = list_w - min_b
    if max_w < min_t then
        w = math.max(80, math.floor(list_w * 0.3 + 0.5))
        if w > list_w - 80 then w = math.max(80, list_w - 80) end
        return math.floor(w)
    end
    if w < min_t then w = min_t end
    if w > max_w then w = max_w end
    return math.floor(w)
end

function book.pane_widths(S, avail_w)
    local list_w = book.list_width(avail_w, book.split_of(S))
    local tree_w = book.tree_width(avail_w, list_w, book.tree_split_of(S))
    local table_w = list_w - tree_w
    if table_w < 80 then table_w = 80 end
    return tree_w, table_w, list_w
end

-- 一覧の縦位置を覚える／戻す（0.1.203〜）。タブごと。開くときとタブを戻したときに使う
function book.capture_scroll(ui, tab)
    if not ui or not ui.settings or not ui.settings.book then return end
    tab = tab or book.split_tab(ui.settings)
    local ok, y = pcall(function() return ui.imgui.GetScrollY() end)
    y = ok and tonumber(y) or nil
    if not y then return end
    if y < 0 then y = 0 end
    local sc = ui.settings.book.scroll
    if type(sc) ~= 'table' then
        ui.settings.book.scroll = { mission = 0, quest = 0, eminence = 0 }
        sc = ui.settings.book.scroll
    end
    if sc[tab] ~= y then sc[tab] = y; ui.mark_settings_dirty() end
end

-- force_top か、戻す印が付いているときだけ縦位置を変える。印はここで消す
function book.apply_scroll(ui, tab, force_top)
    if not ui or not ui.imgui then return end
    tab = tab or book.split_tab(ui.settings)
    if force_top then
        pcall(ui.imgui.SetScrollY, 0)
        local sc = ui.settings.book.scroll
        if type(sc) == 'table' and sc[tab] ~= 0 then sc[tab] = 0; ui.mark_settings_dirty() end
        if ui.state then ui.state.book_restore_scroll = false end
        return
    end
    if not (ui.state and ui.state.book_restore_scroll) then return end
    ui.state.book_restore_scroll = false
    local sc = ui.settings.book.scroll
    local y = type(sc) == 'table' and tonumber(sc[tab]) or nil
    if y then pcall(ui.imgui.SetScrollY, y) end
end

-- 覚えていた行が一覧（フィルタ後）にあればそのまま、無ければ先頭。先頭に戻すときは true
-- パッド・キーで表の行（☆ のボタンも同じ行）へ移ったら、その行を選ぶ。移ったときだけ（マウスで選んだ行を上書きしない）
function book.follow_focus_row(ui, name, shown)
    local cur = focus.current(name)
    if cur == book._follow_seen then return false end
    book._follow_seen = cur
    -- 0.1.228〜：マウスを乗せただけでは詳細を動かさない。クリックと、キー・パッドで移ったときだけ。
    if focus.why and focus.why(name) == 'hover' then return false end
    local s = tostring(cur or '')
    local qid = s:match('^row_(.+)$') or s:match('^bpin_(.+)$')
    if not qid then return false end
    local S = ui.settings
    for _, q in ipairs(shown or {}) do
        if tostring(q.id) == qid then
            if S.book.last_row ~= q.id then
                S.book.last_row = q.id
                if ui.mark_settings_dirty then ui.mark_settings_dirty() end
                return true
            end
            return false
        end
    end
    return false
end

-- カーソルが一覧（または詳細の行のボタン）にあるか（0.1.233〜）
function book.focus_is_list(name)
    name = name or 'book'
    local cur = focus.current(name)
    if not cur then return false end
    local t = tostring(cur)
    if t:find('^row_') or t:find('^bpin_') or t:find('^roesel_')
        or t:find('^roe_start_') or t:find('^roe_remove_')
        or t:find('^roe_fav_') or t:find('^roe_heart_')
        or t:find('^roed_') then
        return true
    end
    local w = focus.windows and focus.windows[name]
    local list = w and (w.list or w.building)
    if list then
        for _, it in ipairs(list) do
            if it.id == cur then
                return it.section == 'list' or it.section == 'detail' or it.section == 'state'
            end
        end
    end
    return false
end

-- 消えた id のいちばん近い行（前の並びで後ろを優先、無ければ前）
function book.nearest_entry(list, lost_id, prev_ids)
    list = list or {}
    if #list == 0 then return nil end
    if lost_id ~= nil then
        for _, q in ipairs(list) do
            if q.id == lost_id then return q end
        end
    end
    local have = {}
    for _, q in ipairs(list) do have[q.id] = q end
    local idx
    if prev_ids then
        for i, id in ipairs(prev_ids) do
            if id == lost_id then idx = i; break end
        end
        if idx then
            for i = idx, #prev_ids do
                if have[prev_ids[i]] then return have[prev_ids[i]] end
            end
            for i = idx - 1, 1, -1 do
                if have[prev_ids[i]] then return have[prev_ids[i]] end
            end
        end
    end
    if idx then
        if idx > #list then return list[#list] end
        return list[idx]
    end
    return list[1]
end

function book.remember_shown(tab, list)
    book._shown_ids = book._shown_ids or {}
    local ids = {}
    for _, q in ipairs(list or {}) do ids[#ids + 1] = q.id end
    book._shown_ids[tab] = ids
    return ids
end

function book.ensure_visible_row(S, list, dirty, opts)
    list = list or {}
    opts = opts or {}
    local selected = S and S.book and S.book.last_row
    -- まだ選んでいなければ、詳細は案内のまま（先頭を自動では選ばない）
    if not selected then return nil, false end
    for _, q in ipairs(list) do
        if q.id == selected then return selected, false end
    end
    -- 一覧にカーソルがあるときにフィルタで行が消えたら、一番近い行へ（0.1.233〜）。
    -- 見出しにいる・本を開き直したときは、これまでどおり行を外して見出しへ（0.1.204〜）。
    local keep = opts.keep_in_list
    if keep == nil then keep = book.focus_is_list(opts.name or 'book') end
    if keep then
        local tab = book.split_tab(S)
        local prev = opts.prev_ids or (book._shown_ids and book._shown_ids[tab])
        local nxt = book.nearest_entry(list, selected, prev)
        if nxt then
            if S.book.last_row ~= nxt.id then
                S.book.last_row = nxt.id
                if dirty then dirty() end
            end
            return nxt.id, false
        end
    end
    if S.book.last_row ~= nil then
        S.book.last_row = nil
        if dirty then dirty() end
    end
    return nil, true
end

local drags = {}   -- [id] = { mouse_x, left_w } ドラッグ中はマウスが当たりを外れてもハイライトを保つ

local function mouse_x(imgui)
    local ok, a, b = pcall(imgui.GetMousePos)
    if not ok then return nil end
    if type(a) == 'number' then return a end
    return vec_x(a)
end

-- opts.id / on_width(new_left) / reset() / min_left / min_right
local function splitter(ui, S, avail_w, left_w, body_h, opts)
    opts = opts or {}
    local imgui = ui.imgui
    local w = 6
    local id = opts.id or '##book_split'
    local drag = drags[id]
    -- GetCursorScreenPos は実機では x, y の2値（表の形のときもある）。y を取りこぼすと線が全く出ない
    local px, py = xy_pair(imgui.GetCursorScreenPos)
    if px then px = px + w / 2 end
    imgui.InvisibleButton(id, { w, body_h })
    local hovered = imgui.IsItemHovered()
    local active = type(imgui.IsItemActive) == 'function' and imgui.IsItemActive() or false
    -- ボタンの実の矩形を優先（カーソル位置の取りこぼしを防ぐ）
    local rmin = item_rect(imgui)
    if rmin then
        px = (rmin[1] + rmin[3]) / 2
        py = rmin[2]
        local h = rmin[4] - rmin[2]
        if h and h > 4 then body_h = h end
    end
    local function reset_ratio()
        if opts.reset then opts.reset()
        elseif book.set_split(S, book.SPLIT) then ui.mark_settings_dirty() end
    end
    if hovered and type(imgui.IsMouseDoubleClicked) == 'function' and imgui.IsMouseDoubleClicked(0) then
        reset_ratio()
        drags[id] = nil
        if px and py then theme.draw_resize_rail(imgui, px, py, py + body_h, true, false) end
        return
    end
    -- ドラッグ中にマウスが 6px の当たりを外れても（幅が変わるため）、つかんでいる間は動かし続ける
    local down = type(imgui.IsMouseDown) == 'function' and imgui.IsMouseDown(0)
    if not active and drag and down then active = true end
    if active then
        local mx = mouse_x(imgui)
        if mx then
            if not drag then drag = { mouse_x = mx, left_w = left_w }; drags[id] = drag end
            local nw = drag.left_w + (mx - drag.mouse_x)
            local aw = tonumber(avail_w) or 800
            local lo = opts.min_left or book.SPLIT_MIN_LIST
            local hi = aw - (opts.min_right or book.SPLIT_MIN_DETAIL)
            -- 窓が狭くて両側の最低限が入らないときは動かさない
            if aw > 0 and hi > lo then
                if nw < lo then nw = lo elseif nw > hi then nw = hi end
                if opts.on_width then
                    opts.on_width(nw, aw)
                else
                    local r = math.floor(nw / aw * 1000 + 0.5) / 1000
                    if book.set_split(S, r) then ui.mark_settings_dirty() end
                end
            end
        end
    else
        drags[id] = nil
        drag = nil
    end
    if px and py then
        theme.draw_resize_rail(imgui, px, py, py + body_h, hovered, active or drag ~= nil)
    elseif hovered or active or drag then
        pcall(imgui.SetMouseCursor, theme.C('ImGuiMouseCursor_ResizeEW'))
    end
end
book.splitter = splitter   -- エミネンスの一覧と詳細の境目にも使う（0.1.177〜）。割合は今のタブだけ変える（0.1.192〜）

function book.tree_splitter(ui, S, avail_w, tree_w, body_h)
    splitter(ui, S, avail_w, tree_w, body_h, {
        id = '##book_split_tree',
        min_left = book.SPLIT_MIN_TREE,
        min_right = book.SPLIT_MIN_TABLE + book.SPLIT_MIN_DETAIL,
        on_width = function (nw, aw)
            if book.set_tree_split(S, nw / aw) then ui.mark_settings_dirty() end
        end,
        reset = function ()
            if book.set_tree_split(S, book.TREE_SPLIT) then ui.mark_settings_dirty() end
        end,
    })
end


-- 本の区画を4つの場所にまとめる（0.1.208〜）：上の行／見出しの木／一覧の表／詳細。
-- 肩ボタン（Tab）はこの4つを回り、ほかの動きは十字キー
function book.area_of(section)
    if section == 'top' or section == 'tabs' or section == 'filters' then return 'top' end
    if section == 'tree' or section == 'head' then return 'tree' end
    if section == 'list' then return 'list' end
    return 'detail'
end

function book.is_tab_id(id)
    local s = tostring(id or '')
    return s == 'tab_mission' or s == 'tab_quest' or s == 'tab_eminence'
end

function book.heading_wid(tab, id)
    return 'sec_' .. tostring(tab) .. '_' .. tostring(id or 'x')
end

function book.tree_wid(tab, id)
    if tab == 'eminence' and tostring(id) ~= book.ALL_ID then
        return 'cat_' .. tostring(id)
    end
    return book.heading_wid(tab, id)
end

local function nav_from_tree_nodes(tab, nodes, parent_id)
    local out = {}
    for _, n in ipairs(nodes or {}) do
        local children = nav_from_tree_nodes(tab, n.children, n.id)
        local has = (n.children and #n.children > 0) or false
        -- 「すべて」はたたみ対象にしない
        local collapse_id = n.is_all and nil or n.id
        out[#out + 1] = {
            kind = 'head',
            id = book.tree_wid(tab, n.id),
            collapse_id = collapse_id,
            heading_id = n.id,
            tab = tab,
            has_children = has,
            is_all = n.is_all and true or false,
            children = children,
        }
    end
    return out
end

function book.nav_tree(ui)
    local S = ui and ui.settings
    if not S or not S.book then return { kind = 'root', id = '_root', children = {} } end
    local tab = book.split_tab(S)
    local nodes = book.tree_nodes(ui)
    return { kind = 'root', id = '_root', children = nav_from_tree_nodes(tab, nodes) }
end

local function nav_find(tree, id)
    if not tree or id == nil then return nil end
    local found_n, found_p, found_path
    local path = {}
    local function walk(node, parent)
        if node.id == id then
            found_n, found_p = node, parent
            found_path = {}
            for i = 1, #path do found_path[i] = path[i] end
            return true
        end
        for _, ch in ipairs(node.children or {}) do
            path[#path + 1] = node
            if walk(ch, node) then return true end
            path[#path] = nil
        end
        return false
    end
    walk(tree, nil)
    return found_n, found_p, found_path
end

local function nav_aliases(cur)
    local out = { cur }
    if not cur then return out end
    local s = tostring(cur)
    local n = s:match('^roesel_(.+)$') or s:match('^roe_%w+_(.+)$') or s:match('^roed_%w+_(.+)$')
    if n then out[#out + 1] = 'roesel_' .. n end
    local q = s:match('^row_(.+)$')
    if q then out[#out + 1] = 'row_' .. q end
    return out
end

function book.nav_resolve(tree, cur)
    if not cur then return nil end
    for _, id in ipairs(nav_aliases(cur)) do
        local n, p, path = nav_find(tree, id)
        if n then return n, p, path end
    end
    -- 同じ行のピンなど：フォーカス項目の row から探す
    local flist = focus.windows and focus.windows.book and focus.windows.book.list
    if flist then
        local row
        for _, it in ipairs(flist) do
            if it.id == cur then row = it.row; break end
        end
        if row ~= nil then
            local tries = { 'row_' .. tostring(row), 'roesel_' .. tostring(row) }
            local rs = tostring(row)
            if rs:sub(1, 1) == 'r' then tries[#tries + 1] = 'roesel_' .. rs:sub(2) end
            for _, id in ipairs(tries) do
                local n, p, path = nav_find(tree, id)
                if n then return n, p, path end
            end
        end
    end
    return nil
end

-- 見えている見出し（閉じたものの子は出さない）を上から順に
function book.visible_nav_heads(tree, S)
    tree = tree or book._nav_tree
    S = S or (book._nav_ui and book._nav_ui.settings)
    local out = {}
    local function walk(nodes)
        for _, n in ipairs(nodes or {}) do
            if n.kind == 'head' then
                out[#out + 1] = n
                local hidden = n.collapse_id ~= nil and book.is_collapsed(S, n.tab, n.collapse_id)
                if not hidden then walk(n.children) end
            end
        end
    end
    if tree then walk(tree.children) end
    return out
end

function book.nav_first_heading(tree)
    tree = tree or book._nav_tree
    local S = book._nav_ui and book._nav_ui.settings
    local vis = book.visible_nav_heads(tree, S)
    if vis[1] then return vis[1].id end
    return nil
end

local function has_prefix(s, p)
    s, p = tostring(s or ''), tostring(p or '')
    return p ~= '' and s:sub(1, #p) == p
end

-- 0.1.233〜：たたんだ見出しは十字キー左右と、見出しのクリック以外では開かない。
-- 選んだ行を見せるために親を自動で開く処理はしない（行は隠したまま、選択は残す）。
function book.nav_expand_path(ui, node_id)
    return false
end

function book.nav_help_key(node, parent, cur)
    if not node then
        -- 表の行にいる（ナビ木には行が無い）
        cur = cur or (focus.current and focus.current('book'))
        local s = tostring(cur or '')
        if has_prefix(s, 'row_') or has_prefix(s, 'roesel_') or has_prefix(s, 'roe_') then
            return 'book.operating_rows'
        end
        return 'book.operating_other'
    end
    if node.kind == 'head' then return 'book.operating_heads' end
    if node.kind == 'row' then return 'book.operating_rows' end
    return 'book.operating_other'
end

local function focus_nav(id)
    if id then focus.set('book', id, true); return true end
    return false
end

-- 行に乗ったら右側の詳細も合わせる（肩ボタンで詳細へ移れるように）
local function nav_select(ui, node)
    if not ui or not ui.settings or not node or node.kind ~= 'row' then return end
    local qid = tostring(node.id or ''):match('^row_(.+)$')
    if qid then
        if ui.settings.book.last_row ~= qid then
            ui.settings.book.last_row = qid
            if ui.mark_settings_dirty then ui.mark_settings_dirty() end
        end
        return
    end
    local rid = tostring(node.id or ''):match('^roesel_(.+)$')
    if rid then
        local em = require('src.ui.eminence')
        if em.select then em.select(tonumber(rid) or rid) end
    end
end

-- 0.1.225〜（t502）：詳細の入り口（右の詳細の先頭。ボタンが無い詳細でも、ここで上下に送れる）
book.DETAIL_ANCHOR = 'detail_pane'
book.DETAIL_STEP = 60   -- 上下で送る量（px）

-- 右の詳細の子窓の中、いちばん先に呼ぶ（BeginChild のすぐ後）
function book.detail_anchor(ui, name)
    local imgui = ui.imgui
    local here = focus.item(name, book.DETAIL_ANCHOR, 'detail_top', 'd0')
    if focus.take_scroll(name, book.DETAIL_ANCHOR) then pcall(imgui.SetScrollY, 0) end
    local d = book._detail_scroll
    if d then
        book._detail_scroll = nil
        local ok, y = pcall(imgui.GetScrollY)
        if ok and tonumber(y) then pcall(imgui.SetScrollY, math.max(0, tonumber(y) + d)) end
    end
    if here and imgui.GetWindowPos and imgui.GetWindowSize and imgui.GetWindowDrawList then
        pcall(function ()
            local px, py = imgui.GetWindowPos()
            if type(px) == 'table' then px, py = px.x or px[1], px.y or px[2] end
            local sw, sh = imgui.GetWindowSize()
            if type(sw) == 'table' then sw, sh = sw.x or sw[1], sw.y or sw[2] end
            local dl = imgui.GetWindowDrawList()
            if dl and px and sw then
                dl:AddRect({ px + 2, py + 2 }, { px + sw - 2, py + sh - 2 }, theme.u32('ring', 0.95), 4, 0, 2)
            end
        end)
    end
    return here
end

local function section_of_current(name)
    local cur = focus.current(name)
    for _, it in ipairs((focus.windows[name] or {}).list or {}) do
        if it.id == cur then return it.section end
    end
    return nil
end

-- いま選んでいる行（一覧へ戻るとき）
local function selected_row_wid(ui)
    local S = ui.settings
    if S.book.tab == 'eminence' then
        local em = require('src.ui.eminence')
        local sid = em.selected and em.selected()
        if not sid and S.eminence then sid = tonumber(S.eminence.last_id) end
        return sid and ('roesel_' .. tostring(sid)) or nil
    end
    return S.book.last_row and ('row_' .. S.book.last_row) or nil
end

local function is_table_row_id(id)
    local s = tostring(id or '')
    return has_prefix(s, 'row_') or has_prefix(s, 'roesel_')
        or has_prefix(s, 'roe_fav_') or has_prefix(s, 'roe_heart_')
        or has_prefix(s, 'roe_start_') or has_prefix(s, 'roe_remove_')
        or has_prefix(s, 'bpin_')
end

-- 0.1.208〜：木の中で見出しを選び、決定で中央の表へ。表でキャンセルすると同じ見出しへ戻る。
-- 木でキャンセルすると本を閉じる。左右は見出しの開閉（右で下の見出しへ、左は閉じていれば親へ）。
function book.nav_action(action)
    local ui = book._nav_ui
    local tree = book._nav_tree
    if not ui or not tree then return false end
    if ui.state and ui.state.open and ui.state.open.settings then return false end
    local cur = focus.current('book')
    -- 0.1.225〜（t502）：詳細の中。キャンセルで一覧の選んでいる行へ、上下はボタンを移り、端では詳細を送る
    if book.area_of(section_of_current('book')) == 'detail' then
        if action == 'back' then
            local wid = selected_row_wid(ui)
            if wid then focus_nav(wid)
            else focus_nav(book.tree_wid(book.split_tab(ui.settings), book.display_heading(ui))) end
            if ui.state then ui.state.book_scroll_to_sel = true end
            return true
        end
        if action == 'up' or action == 'down' then
            if not focus.move('book', action) then
                book._detail_scroll = (action == 'up') and -book.DETAIL_STEP or book.DETAIL_STEP
            end
            return true
        end
        if action == 'confirm' and cur == book.DETAIL_ANCHOR then return true end
        return false
    end
    if is_table_row_id(cur) then
        if action == 'back' then
            local tab = book.split_tab(ui.settings)
            local hid = book.display_heading(ui)
            focus_nav(book.tree_wid(tab, hid))
            return true
        end
        -- 0.1.225〜（t502）：行（名前）で決定 → その行を選んで右の詳細へ（見出し → 一覧 → 詳細）
        local s = tostring(cur or '')
        local qid = s:match('^row_(.+)$')
        local rid = s:match('^roesel_(.+)$')
        if action == 'confirm' and (qid or rid) then
            local S = ui.settings
            if qid then
                if S.book.last_row ~= qid then
                    S.book.last_row = qid
                    if ui.mark_settings_dirty then ui.mark_settings_dirty() end
                end
            else
                local em = require('src.ui.eminence')
                if em.select then em.select(tonumber(rid) or rid) end
                if S.eminence and S.eminence.last_id ~= tonumber(rid) then
                    S.eminence.last_id = tonumber(rid)
                    if ui.mark_settings_dirty then ui.mark_settings_dirty() end
                end
            end
            focus.set('book', book.DETAIL_ANCHOR, true)
            return true
        end
        -- 上下左右・ほかのボタンの決定は表の通常の動き（行の中、行の移動）
        return false
    end
    local node, parent = book.nav_resolve(tree, cur)
    if not node or node.kind ~= 'head' then return false end
    local S = ui.settings
    local tab = node.tab or book.split_tab(S)

    local function select_head(n)
        if not n then return end
        if n.heading_id and book.set_heading(S, tab, n.heading_id, function () ui.mark_settings_dirty() end) then
            if ui.state then ui.state.book_heading_changed = true end
        end
        focus_nav(n.id)
    end

    if action == 'up' or action == 'down' then
        local vis = book.visible_nav_heads(tree, S)
        local i = 1
        for k, n in ipairs(vis) do if n.id == node.id then i = k end end
        local j = i + ((action == 'up') and -1 or 1)
        if j < 1 then j = 1 elseif j > #vis then j = #vis end
        select_head(vis[j])
        return true
    end

    if action == 'left' or action == 'right' then
        if node.collapse_id == nil then return true end  -- 「すべて」など：開閉しない
        local collapsed = book.is_collapsed(S, node.tab, node.collapse_id)
        -- 0.1.224〜：エミネンスの、下の見出しの無い見出しは閉じない（閉じる印が無いのに閉じた扱いになり、表が空になっていた）
        local leaf = (node.tab or tab) == 'eminence' and not (node.children and node.children[1])
        if leaf and action == 'left' then collapsed = true end
        if action == 'left' then
            if not collapsed then
                book.set_collapsed(S, node.tab, node.collapse_id, true)
                if ui.mark_settings_dirty then ui.mark_settings_dirty() end
                focus_nav(node.id)
            elseif parent and parent.kind == 'head' then
                select_head(parent)
            else
                focus_nav(node.id)
            end
        else
            if collapsed then
                book.set_collapsed(S, node.tab, node.collapse_id, false)
                if ui.mark_settings_dirty then ui.mark_settings_dirty() end
                focus_nav(node.id)
            elseif node.children and node.children[1] then
                select_head(node.children[1])
            else
                focus_nav(node.id)
            end
        end
        return true
    end

    if action == 'confirm' then
        -- 決定：中央の表の先頭の行へ。0.1.225〜（t503）：閉じた見出しは開かない（表は閉じていても中身を出す。開け閉めは左右だけ）
        if node.heading_id then
            book.set_heading(S, tab, node.heading_id, function () ui.mark_settings_dirty() end)
        end
        -- 表の先頭行は次の描画で決まるので、印を付けて finish で乗せる
        ui.state.book_enter_table = true
        return true
    end

    if action == 'back' then
        -- 木のどこにいても本を閉じる
        return false
    end

    return false
end

function book.list_focus_id(ui)
    local S = ui and ui.settings
    if not S or not S.book then return nil end
    local tab = book.split_tab(S)
    -- 通常は左の木の見出し。指定の行へ飛ばすときだけ表の行
    if ui.state and (ui.state.book_enter_table or ui.state.book_scroll_to_sel) then
        if S.book.tab == 'eminence' then
            local em = require('src.ui.eminence')
            local sid = em.selected and em.selected()
            if not sid and S.eminence then sid = tonumber(S.eminence.last_id) end
            if sid then return 'roesel_' .. tostring(sid) end
        elseif S.book.last_row then
            return 'row_' .. S.book.last_row
        end
    end
    local hid = book.display_heading(ui)
    return book.tree_wid(tab, hid)
end

-- 検索（エミネンスも同じ。分類・状態の選択は 0.1.226 でなくした）。row はキー・パッドの行（タブと同じ行なら 'tabs'）。
-- search_w(rest) → 検索の幅（-1 なら残りいっぱい）。inline はタブと同じ行に続けて描くとき
function book.draw_filters(ui, name, emin, row, search_w, inline)
    local imgui, t, S = ui.imgui, ui.t, ui.settings
    local cw1, cw2 = inline and 150 or 180, inline and 130 or 200
    if emin then
        require('src.ui.eminence').book_filters(ui, name, row, cw1, cw2, search_w, inline)
        return
    end
    -- 0.1.225〜（t497/t498）：地域・状態の選択はなくした（地域は左の見出しの木、状態は2行目の「表示：」のチェック）
    local rest = avail_x(imgui)
    if not inline and rest and rest < 140 then imgui.NewLine() end
    if not search_synced then search_buf[1] = S.book.filters.text or ''; search_synced = true end
    local sf, sa = focus.item(name, 'search', 'top', row)
    if sa then imgui.SetKeyboardFocusHere(0) end
    imgui.SetNextItemWidth(search_w(rest or 0))
    if imgui.InputTextWithHint('##astertrail_search', t('book.search_hint'), search_buf, 64) then
        S.book.filters.text = search_buf[1] or ''
        ui.mark_settings_dirty()
    end
    ui.text_active = ui.text_active or imgui.IsItemActive()
    if (imgui.IsItemHovered() and imgui.IsMouseClicked(0)) then focus.set(name, 'search') end
    if sf then
        local x1, y1 = imgui.GetItemRectMin()
        local x2, y2 = imgui.GetItemRectMax()
        theme.draw_focus(imgui, x1, y1, x2, y2, ui.reduce_motion)
    end
end

-- 左の見出しの木を描く（0.1.208〜）
function book.draw_tree_pane(ui, name, nodes, selected_id, restore_scroll)
    local imgui = ui.imgui
    local S = ui.settings
    local tab = book.split_tab(S)
    if restore_scroll then
        local sc = S.book.tree_scroll
        local y = type(sc) == 'table' and tonumber(sc[tab]) or nil
        if y then pcall(imgui.SetScrollY, y) end
        if ui.state then ui.state.book_restore_tree_scroll = false end
    end
    local function draw_node(n, depth)
        local wid = book.tree_wid(tab, n.id)
        local indent = tonumber(n.indent)
        if indent == nil then indent = (depth or 0) * 12 end
        if indent > 0 then
            imgui.Dummy({ indent, 1 })
            imgui.SameLine()
        end
        local has = n.children and #n.children > 0 and not n.is_all
        local open = true
        if has then
            open = not book.is_collapsed(S, tab, n.id)
            local mark = open and '▾' or '▸'
            if W.button(ui, name, 'tw_' .. wid, mark, {
                section = 'tree', row = wid, small = true, no_focus = true
            }) then
                if book.toggle_collapsed(S, tab, n.id) then ui.mark_settings_dirty() end
            end
            imgui.SameLine()
        end
        local label = book.heading_label(n.label, n.done, n.total)
        local focused = focus.current(name) == wid
        local selected = tostring(selected_id) == tostring(n.id)
        local color = (focused or selected) and 'accent' or (n.is_all and 'text' or 'text')
        if W.button(ui, name, wid, label, { section = 'tree', row = wid, color = color, small = true }) then
            if book.set_heading(S, tab, n.id, function () ui.mark_settings_dirty() end) then
                if ui.state then ui.state.book_heading_changed = true end
            end
        end
        if has and open then
            for _, ch in ipairs(n.children) do draw_node(ch, (depth or 0) + 1) end
        end
    end
    for _, n in ipairs(nodes or {}) do draw_node(n, 0) end
    do
        local ok, y = pcall(function () return imgui.GetScrollY() end)
        y = ok and tonumber(y) or nil
        if y then
            if y < 0 then y = 0 end
            S.book.tree_scroll = S.book.tree_scroll or { mission = 0, quest = 0, eminence = 0 }
            if S.book.tree_scroll[tab] ~= y then
                S.book.tree_scroll[tab] = y
                if ui.mark_settings_dirty then ui.mark_settings_dirty() end
            end
        end
    end
end

function book.prepare_heading(ui, list)
    local S = ui.settings
    local tab = book.split_tab(S)
    local searching = false
    if tab == 'eminence' then
        local E = S.eminence or {}
        searching = E.book_text and E.book_text ~= ''
    else
        local f = S.book.filters
        searching = f and f.text and f.text ~= ''
    end
    if searching then return book.ALL_ID end
    local hid = book.current_heading(S, tab)
    -- 開いたときの復元は、見出しの保存が無いときだけ行から決める
    -- トラッカーなどから行へ飛ぶときは、その行を含む見出しへ合わせる
    local jump = ui.state and (ui.state.book_jump_row or ui.state.book_nav_pending)
    if S.book.last_row and (jump or (hid == nil and ui.state and ui.state.book_restore_scroll)) then
        local found = book.heading_of_quest(ui, S.book.last_row)
        if found then
            hid = found
            book.set_heading(S, tab, hid, function () ui.mark_settings_dirty() end)
        end
    end
    hid = hid or book.ALL_ID
    if hid ~= book.ALL_ID and #book.heading_path_ids(ui, hid) == 0 then
        hid = book.ALL_ID
        book.set_heading(S, tab, hid, function () ui.mark_settings_dirty() end)
    end
    return hid
end

function book.draw(ui)
    local imgui, t, S = ui.imgui, ui.t, ui.settings
    local open = { true }
    local name = 'book'
    local drawing = window.begin(ui, name, { title = t('book.title'), open = open, operable = true, fixed_top = true })
    if drawing then
        -- 状態の一行（確認待ち・読み取り専用・保存失敗など）。緑色の短い案内は見出しの帯（0.1.233〜）
        ui.status_line()
        -- 0.1.233〜：たたんだ見出しは自動で開かない。選んだ行は覚えるが、親は開かない。
        -- 一覧の縦位置だけ戻す（本を開き直したとき・描き直したとき）。
        do
            if ui.state.book_restore_scroll then ui.state.book_restore_tree_scroll = true end
            if ui.state.book_expand_path then ui.state.book_expand_path = nil end
        end
        book._nav_ui = ui
        book._nav_tree = book.nav_tree(ui)
        -- 0.1.225〜（t499）：パッドの案内の一行（「パッドで操作中：…」）は出さない（マウスのときに邪魔）

        -- 設定（0.1.175〜）：別の窓は作らず、一覧と詳細の場所に出す。そのあいだキー・パッドは設定の中だけ
        local settings_on = ui.state.open.settings == true
        focus.set_shows_frame(name, not (settings_on and ui.state.active == 'settings'))
        focus.set_areas(name, book.area_of)
        local emin = S.book.tab == 'eminence'

        -- いちばん上の行（0.1.175〜）：左にタブ（ミッション → クエスト → エミネンス）、続けて検索、
        -- 右端に コンパス・トラッカー・⚙️・閉じる。狭くて入らないときは、検索を次の行へ
        local tabs = { 'mission', 'quest', 'eminence' }   -- ミッションが先。エミネンスはクエストの右（0.1.172〜）
        for i, tab in ipairs(tabs) do
            if i > 1 then W.same(ui) end
            local mark = (S.book.tab == tab) and '◆ ' or '◇ '
            if W.button(ui, name, 'tab_' .. tab, mark .. t('book.tab.' .. tab), { section = 'top', row = 'tabs' }) then
                S.book.tab = tab
                ui.mark_settings_dirty()
                ui.state.book_restore_scroll = true
                if settings_on then ui.close_window('settings'); settings_on = false end
            end
        end
        emin = S.book.tab == 'eminence'
        -- 右端（0.1.173〜、t251）：コンパス・トラッカー・エミネンス（0.1.177〜）の出す・隠す（自分で描いた絵。出しているときは明るく、下に線）、
        -- ⚙️（設定。設定を出しているあいだは下に線。もう一度押すと一覧に戻る）、閉じる。絵のボタンはマウスを乗せると名前
        local tr_on = S.tracker.visible == true
        local em_on = S.eminence and S.eminence.visible == true
        local cp_on = S.compass and S.compass.visible == true
        local function lit(on) return on and 1.0 or 0.45 end
        local function underline(dl, x, y, r, on)
            if on and dl and dl.AddLine then
                pcall(dl.AddLine, dl, { x - r, y + r * 1.25 }, { x + r, y + r * 1.25 }, theme.u32('accent', 0.95), 2)
            end
        end
        local right = {
            { id = 'compass_toggle', tip = t(cp_on and 'book.compass_on' or 'book.compass_off'), draw = function (dl, x, y, r)
                icons.compass(dl, x, y - r * 0.12, r * 0.95, theme.u32('compass_blue', lit(cp_on)), theme.u32('paper', lit(cp_on)),
                    theme.u32('ic_bad', lit(cp_on)), theme.u32('paper', lit(cp_on)))
                underline(dl, x, y - r * 0.12, r, cp_on)
            end },
            { id = 'tracker_toggle', tip = t(tr_on and 'book.tracker_on' or 'book.tracker_off'), draw = function (dl, x, y, r)
                -- 0.1.177〜：金色の星（前はリストの絵）
                icons.star(dl, x, y - r * 0.12, r * 0.98, theme.u32('star_gold', lit(tr_on)), theme.u32('star_rim', lit(tr_on)))
                underline(dl, x, y - r * 0.12, r, tr_on)
            end },
            -- エミネンスの窓（0.1.177〜）：クリーム色の紙に緑のチェック
            { id = 'eminence_toggle', tip = t(em_on and 'book.eminence_on' or 'book.eminence_off'), draw = function (dl, x, y, r)
                icons.checklist(dl, x, y - r * 0.12, r * 0.95, theme.u32('roe_paper', lit(em_on)), theme.u32('roe_rim', lit(em_on)),
                    theme.u32('roe_check', lit(em_on)), theme.u32('roe_line', lit(em_on)))
                underline(dl, x, y - r * 0.12, r, em_on)
            end },
            { id = 'open_settings', tip = t(settings_on and 'book.settings_close' or 'book.settings'), draw = function (dl, x, y, r)
                icons.gear(dl, x, y - (settings_on and r * 0.12 or 0), r * (settings_on and 0.9 or 1), theme.u32('text', 0.95), theme.u32('bg', 1))
                underline(dl, x, y - r * 0.12, r, settings_on)
            end },
        }
        local fh = 22
        if imgui.GetFrameHeight then
            local okf, v = pcall(imgui.GetFrameHeight)
            if okf and tonumber(v) then fh = tonumber(v) end
        end
        local icon_w = math.floor(fh * 1.25 + 0.5)
        local need = #right * icon_w + button_w(imgui, t('common.close')) + #right * item_spacing(imgui)

        -- 検索がタブと同じ行に入るか（検索は 120 以上。0.1.226〜：エミネンスの分類・状態の選択もなくした）
        local sp = item_spacing(imgui)
        local f = S.book.filters
        local E = S.eminence or {}
        local em = emin and require('src.ui.eminence') or nil
        local before = emin and { em.show_sig(E), E.book_text, nil } or { show_sig(f), f.text, nil }
        local min_filters = 120 + sp * 2
        imgui.SameLine()
        local rest0 = avail_x(imgui)
        local inline = rest0 ~= nil and (rest0 - need - sp) >= min_filters
        local function draw_icons()
            right_align(imgui, need)
            for i, r in ipairs(right) do
                if i > 1 then W.same(ui) end
                if W.icon_button(ui, name, r.id, r.draw, { section = 'top', row = 'tabs', tooltip = r.tip }) then
                    if r.id == 'tracker_toggle' then
                        if ui.toggle_tracker then ui.toggle_tracker() end
                    elseif r.id == 'compass_toggle' then
                        if ui.toggle_compass then ui.toggle_compass() end
                    elseif r.id == 'eminence_toggle' then
                        if ui.toggle_eminence then ui.toggle_eminence() end
                    elseif settings_on then
                        ui.close_window('settings')
                    else
                        ui.open_window('settings')
                    end
                end
            end
            W.same(ui)
            if W.button(ui, name, 'close', t('common.close'), { section = 'top', row = 'tabs' }) then open[1] = false end
        end
        if inline then
            -- 検索の幅：残りから右端のボタンの分を引く
            book.draw_filters(ui, name, emin, 'tabs', function (used_rest) return math.max(120, used_rest - need - sp) end, true)
            draw_icons()
        else
            draw_icons()
            book.draw_filters(ui, name, emin, 'f', function () return -1 end, false)
        end
        local after = emin and { em.show_sig(E), E.book_text, nil } or { show_sig(f), f.text, nil }
        if settings_on and (before[1] ~= after[1] or before[2] ~= after[2] or before[3] ~= after[3]) then
            -- 設定を出しているあいだに絞り込みを替えたら、一覧に戻す
            ui.close_window('settings')
            settings_on = false
        end

        if settings_on then
            W.sep(ui)
            require('src.ui.settings_ui').body(ui)
        elseif emin then
            -- エミネンス（0.1.172〜）：2行目から下は src/ui/eminence.lua（達成を隠す・窓・一覧）
            require('src.ui.eminence').book_body(ui, name)
        else
        -- 2行目：列を出す・隠す（■ 出す　▢ 隠す）。並びは保存した列の並び。狭いときは折り返す
        do
            local with_no = show_no_col(ui)
            -- 0.1.225〜（t497/t498）：「表示：」受注中・未受注・完了のチェック（エミネンスと同じ形）。初めは全部出す
            W.frame_label(ui, t('book.view_label'), true)
            if type(f.show) ~= 'table' then f.show = { accepted = true, not_accepted = true, completed = true, unimplemented = true } end
            if f.show.unimplemented == nil then f.show.unimplemented = true end
            for _, k in ipairs(book.SHOW_STATES) do
                W.same(ui)
                if W.check_chip(ui, name, 'show_' .. k, t('state.' .. k), f.show[k] ~= false,
                    { section = 'top', row = 'cols', tooltip = t('book.show_tip') }) then
                    f.show[k] = not (f.show[k] ~= false)
                    ui.mark_settings_dirty()
                end
            end
            W.same(ui)
            if W.check_chip(ui, name, 'show_unimplemented', t('state.unimplemented'), f.show.unimplemented ~= false,
                { section = 'top', row = 'cols', tooltip = t('book.show_unimplemented_tip') }) then
                f.show.unimplemented = not (f.show.unimplemented ~= false)
                ui.mark_settings_dirty()
            end
            W.same(ui)
            W.frame_label(ui, '｜', true)
            W.same(ui)
            -- 「列：」はチェックと同じ高さ（0.1.200〜）
            W.frame_label(ui, t('book.cols_label'), true)
            for _, k in ipairs(book.toggle_keys(S, with_no)) do
                local label = t('book.col.' .. k)
                local need_c = W.check_chip_width(imgui, label)
                imgui.SameLine()
                local rest = avail_x(imgui)
                if rest and rest < need_c then imgui.NewLine() end
                if W.check_chip(ui, name, 'col_' .. k, label, book.column_shown(S, k),
                    { section = 'top', row = 'cols', tooltip = t('book.cols_tip') }) then
                    if book.toggle_column(S, k, with_no) then ui.mark_settings_dirty() end
                end
            end
        end

        W.sep(ui)

        -- 左：見出しの木　中央：項目の表　右：詳細（0.1.208〜）
        local list = book.filtered(ui)
        local heading_id = book.prepare_heading(ui, list)
        local shown = book.entries_under_heading(ui, heading_id, list)
        -- 0.1.225〜（t500）：パッド・キーで表の行を移ったら、右の詳細もその行に（エミネンスと同じ）
        book.follow_focus_row(ui, name, shown)
        local selected, fallback = book.ensure_visible_row(S, shown, function() ui.mark_settings_dirty() end)
        book.remember_shown(S.book.tab, shown)
        local sel_q = selected and ui.data:quest(selected) or nil
        local avail_w, avail_h = imgui.GetContentRegionAvail()
        avail_w = avail_w or 800
        local body_h = math.max(80, (avail_h or 300) - 6)
        local tree_w, table_w, list_w = book.pane_widths(S, avail_w)
        local force_table_top = fallback or (ui.state and ui.state.book_heading_changed)
        if ui.state then ui.state.book_heading_changed = nil end
        if ui.state and ui.state.book_scroll_to_sel then ui.state.book_scroll_to_sel = nil end

        imgui.BeginChild('##astertrail_book_tree', { tree_w, body_h }, 1, 0)
        window.push(ui, 'child')
        window.set_font(ui, book.list_scale(ui))   -- 一覧の文字サイズ（0.1.209〜）
        book.draw_tree_pane(ui, name, book.tree_nodes(ui), heading_id, ui.state and ui.state.book_restore_tree_scroll)
        window.pop(ui, 'child')

        imgui.SameLine(0, 2)
        book.tree_splitter(ui, S, avail_w, tree_w, body_h)
        imgui.SameLine(0, 2)

        imgui.BeginChild('##astertrail_book_list', { table_w, body_h }, 0, 0)
        window.push(ui, 'child')
        window.set_font(ui, book.list_scale(ui))   -- 一覧の文字サイズ（0.1.209〜）
        if #ui.data.errors > 0 then
            for _, e in ipairs(ui.data.errors) do
                W.colored(ui, 'warn', t('data.file_error', { file = e.file }))
            end
        end
        if #shown == 0 then
            book.apply_scroll(ui, S.book.tab, force_table_top)
            W.muted(ui, t('book.empty'))
        end
        draw_list(ui, name, shown, selected, force_table_top)
        if fallback then
            local hid = book.tree_wid(S.book.tab, heading_id or book.ALL_ID)
            if hid then focus.set(name, hid, true) end
        end
        if not (ui.state and ui.state._table_scroll_captured) then
            book.capture_scroll(ui, S.book.tab)
        end
        if ui.state then ui.state._table_scroll_captured = nil end
        if ui.state and ui.state.book_enter_table then
            ui.state.book_enter_table = nil
            if shown[1] then
                ui.state.book_nav_pending = 'row_' .. shown[1].id
                if S.book.last_row ~= shown[1].id then
                    S.book.last_row = shown[1].id
                    ui.mark_settings_dirty()
                end
            end
        end
        window.pop(ui, 'child')

        imgui.SameLine(0, 2)
        splitter(ui, S, avail_w, list_w, body_h)
        imgui.SameLine(0, 2)
        imgui.BeginChild('##astertrail_book_detail', { 0, body_h }, 1, 0)
        window.push(ui, 'child')
        window.set_font(ui, window.font_scale(ui, 'detail'))
        book.detail_anchor(ui, name)   -- 0.1.225〜（t502）
        if sel_q then
            require('src.ui.detail').body(ui, name, sel_q, { embedded = true })
        else
            W.muted(ui, t('book.detail_hint'))
        end
        window.pop(ui, 'child')
        end   -- 設定でもエミネンスでもないとき

    end
    -- カーソル：木の見出しが基本（0.1.208〜）。指定の行へ飛ばす／表へ入るときだけ行
    local pref, force_pref
    if ui.state.book_nav_pending then
        pref = ui.state.book_nav_pending
        ui.state.book_nav_pending = nil
        force_pref = true
    elseif ui.state.book_enter_table then
        pref = book.list_focus_id(ui)
        force_pref = pref ~= nil
    else
        -- トラッカーなどから開いた直後は行へ。通常の開き直しは見出しへ
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

function book.reset_search()
    search_synced = false
end

return book
