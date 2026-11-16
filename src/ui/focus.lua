--[[
  Astertrail - 選択（フォーカス）の仕組み
  - 各窓は「今選んでいる項目」を一つ持つ。
  - 項目は 区画（section）と 行（row）を持つ。上下は同じ区画の行、左右は同じ行の中、
    区画の切り替えは Tab / 肩ボタン。端では止まる（区画の切り替えだけ一周）。
  - 区画をまとめた「場所」を決めた窓（本）では、肩ボタンは場所だけを一周する（focus.set_areas）。
  - マウスを乗せた時（マウスが動いた時だけ）も同じ選択を動かす。
  - ゲームの API は使わない。
]]

local focus = { windows = {} }

local function W(win)
    local w = focus.windows[win]
    if not w then
        w = { list = {}, building = nil, current = nil, scroll_to = nil, activate = nil }
        focus.windows[win] = w
    end
    return w
end

function focus.begin(win)
    W(win).building = {}
end

-- 項目を登録する。戻り値: focused, activated
-- 選択枠とキー・パッドの移動は、コントローラー対応する窓だけ（冒険の本と設定）
local FRAME_WINS = { book = true, settings = true, map = true }   -- 地図は 0.1.60〜（「相手：」を選ぶため）
-- トラッカーは操作しているときだけ枠を出す（0.1.61〜。トラッカーが毎フレーム決める）
function focus.set_shows_frame(win, on) FRAME_WINS[win] = on and true or nil end
function focus.shows_frame(win)
    return FRAME_WINS[win] == true
end

-- adjust=true の項目（スライダー）は、選んでいるあいだ左右で値を動かす（選択は動かさない）
function focus.item(win, id, section, row, adjust)
    local w = W(win)
    local b = w.building
    if b then
        b[#b + 1] = { id = id, section = section or 'main', row = row or id, adjust = adjust and true or false }
    end
    local activated = (w.activate == id)
    if activated then w.activate = nil end
    return w.current == id, activated
end

function focus.finish(win, preferred)
    local w = W(win)
    if not w.building then return end
    w.list = w.building
    w.building = nil
    if w.activate then w.activate = nil end
    local exists = false
    for _, it in ipairs(w.list) do if it.id == w.current then exists = true break end end
    -- 行が見えなくなった（タブを変えた等）色えらびは閉じる。入力を取りっぱなしにしない
    if w.picker then
        local alive = false
        for _, it in ipairs(w.list) do if it.id == w.picker.id then alive = true break end end
        if not alive then w.picker = nil end
    end
    if not exists then
        local pick
        if preferred then
            for _, it in ipairs(w.list) do if it.id == preferred then pick = it.id break end end
        end
        w.current = pick or (w.list[1] and w.list[1].id or nil)
    end
end

function focus.current(win) return W(win).current end

function focus.set(win, id, scroll)
    local w = W(win)
    w.current = id
    if scroll then w.scroll_to = id end
end

function focus.reset(win)
    local w = W(win)
    w.current = nil
    w.list = {}
end

-- 項目を描いた直後に呼ぶ（スクロール追従）
function focus.take_scroll(win, id)
    local w = W(win)
    if w.scroll_to == id then
        w.scroll_to = nil
        return true
    end
    return false
end

local function rows_of_section(list, section)
    local rows, index = {}, {}
    for _, it in ipairs(list) do
        if it.section == section then
            local r = index[it.row]
            if not r then
                r = {}
                index[it.row] = r
                rows[#rows + 1] = r
            end
            r[#r + 1] = it
        end
    end
    return rows
end

local function sections_of(list)
    local out, seen = {}, {}
    for _, it in ipairs(list) do
        if not seen[it.section] then seen[it.section] = true; out[#out + 1] = it.section end
    end
    return out
end

-- 区画をまとめた「場所」（0.1.175〜）。fn(section) → 場所の名前。決めた窓では、
-- 肩ボタン（Tab）は場所だけを一周し（場所の中の区画は飛ばない）、上下は場所の中の区画をまたいで動く。
-- 場所へ戻るときは、その場所で最後に選んでいた項目へ（もう無ければ場所の最初）
function focus.set_areas(win, fn)
    local w = W(win)
    w.areas = fn
    w.area_last = w.area_last or {}
end

function focus.area_of(win, section)
    local w = W(win)
    if not w.areas then return section end
    return w.areas(section) or section
end

-- action: up / down / left / right / section_next / section_prev
function focus.move(win, action)
    local w = W(win)
    local list = w.list
    if #list == 0 then return false end
    local cur
    for _, it in ipairs(list) do if it.id == w.current then cur = it break end end
    if not cur then
        w.current = list[1].id
        w.scroll_to = w.current
        return true
    end
    if (action == 'section_next' or action == 'section_prev') and w.areas then
        local order, seen, first = {}, {}, {}
        for _, it in ipairs(list) do
            local a = w.areas(it.section) or it.section
            if not seen[a] then seen[a] = true; order[#order + 1] = a; first[a] = it end
        end
        local here = w.areas(cur.section) or cur.section
        w.area_last[here] = cur.id
        local ai = 1
        for i, a in ipairs(order) do if a == here then ai = i end end
        local nj = ai + (action == 'section_next' and 1 or -1)
        if nj < 1 then nj = #order elseif nj > #order then nj = 1 end
        local to = order[nj]
        local pick = first[to]
        local last = w.area_last[to]
        if last then
            for _, it in ipairs(list) do
                if it.id == last and (w.areas(it.section) or it.section) == to then pick = it break end
            end
        end
        if pick and pick.id ~= cur.id then
            w.current = pick.id
            w.scroll_to = w.current
            return true
        end
        return false
    end
    if action == 'section_next' or action == 'section_prev' then
        local secs = sections_of(list)
        local si = 1
        for i, s in ipairs(secs) do if s == cur.section then si = i end end
        local nj = si + (action == 'section_next' and 1 or -1)
        if nj < 1 then nj = #secs elseif nj > #secs then nj = 1 end
        local rows = rows_of_section(list, secs[nj])
        if rows[1] and rows[1][1] then
            w.current = rows[1][1].id
            w.scroll_to = w.current
            return true
        end
        return false
    end
    local rows = rows_of_section(list, cur.section)
    local ri, ci = 1, 1
    for i, r in ipairs(rows) do
        for j, it in ipairs(r) do
            if it.id == cur.id then ri, ci = i, j end
        end
    end
    local target
    if action == 'up' or action == 'down' then
        local nr = rows[ri + (action == 'up' and -1 or 1)]
        if nr then target = nr[math.min(ci, #nr)]
        elseif w.areas then
            -- 区画の端：同じ場所の、となりの区画へ（上なら前の区画の最後の行、下なら次の区画の最初の行）
            local here = w.areas(cur.section) or cur.section
            local secs = {}
            for _, s in ipairs(sections_of(list)) do
                if (w.areas(s) or s) == here then secs[#secs + 1] = s end
            end
            local si = 1
            for i, s in ipairs(secs) do if s == cur.section then si = i end end
            local ns = secs[si + (action == 'up' and -1 or 1)]
            if ns then
                local nrows = rows_of_section(list, ns)
                local r = (action == 'up') and nrows[#nrows] or nrows[1]
                if r then target = r[math.min(ci, #r)] end
            end
        end
    elseif action == 'left' or action == 'right' then
        if cur.adjust then
            w.adjust = { id = cur.id, dir = (action == 'left') and -1 or 1 }
            return true
        end
        target = rows[ri][ci + (action == 'left' and -1 or 1)]
    end
    if target then
        w.current = target.id
        w.scroll_to = target.id
        return true
    end
    return false
end

-- 今の項目がスライダー（左右で値を動かす）か
function focus.is_adjust(win)
    local w = W(win)
    for _, it in ipairs(w.list) do
        if it.id == w.current then return it.adjust == true end
    end
    return false
end

-- スライダーへの左右（-1 / 1）。一度読んだら消える
function focus.take_adjust(win, id)
    local w = W(win)
    local a = w.adjust
    if a and a.id == id then
        w.adjust = nil
        return a.dir
    end
    return nil
end

-- プルダウン（キー・パッドで開いた一覧）。開いているあいだ、上下は一覧の中、決定で選ぶ、キャンセルで閉じる
function focus.dropdown(win)
    return W(win).dropdown
end

function focus.open_dropdown(win, id, idx, n)
    W(win).dropdown = { id = id, idx = idx or 1, n = n or 1, opened = false }
end

function focus.close_dropdown(win)
    W(win).dropdown = nil
end

-- app から：プルダウンが開いていればその中で動かす。使ったら true
function focus.dropdown_action(win, action)
    local d = W(win).dropdown
    if not d then return false end
    if action == 'up' then
        d.idx = d.idx - 1; if d.idx < 1 then d.idx = d.n end
    elseif action == 'down' then
        d.idx = d.idx + 1; if d.idx > d.n then d.idx = 1 end
    elseif action == 'confirm' then
        d.pick = true
    elseif action == 'back' then
        W(win).dropdown = nil
    end
    -- 左右・LB/RB は何もしない（一覧の外へ動かない）
    return true
end

-- 色えらび（キー・パッドで開いた色の窓）。開いているあいだ：
--   左右＝あざやかさ、上下＝明るさ、LB/RB＝色合い、決定＝決める、キャンセル＝元の色に戻して閉じる
function focus.picker(win)
    return W(win).picker
end

function focus.open_picker(win, id, h, s, v, orig)
    W(win).picker = { id = id, h = h or 0, s = s or 0, v = v or 1, orig = orig, opened = false }
end

function focus.close_picker(win)
    W(win).picker = nil
end

focus.PICKER_STEP = 0.02     -- あざやかさ・明るさの1刻み
focus.PICKER_HUE_STEP = 1 / 72   -- 色合いの1刻み（5 度）

-- app から：色えらびが開いていればその中で動かす。使ったら true
function focus.picker_action(win, action)
    local p = W(win).picker
    if not p then return false end
    local st, hs = focus.PICKER_STEP, focus.PICKER_HUE_STEP
    local function clamp(x) if x < 0 then return 0 elseif x > 1 then return 1 end return x end
    if action == 'left' then p.s = clamp(p.s - st)
    elseif action == 'right' then p.s = clamp(p.s + st)
    elseif action == 'up' then p.v = clamp(p.v + st)
    elseif action == 'down' then p.v = clamp(p.v - st)
    elseif action == 'section_next' then p.h = (p.h + hs) % 1
    elseif action == 'section_prev' then p.h = (p.h - hs) % 1
    elseif action == 'confirm' then p.done = true
    elseif action == 'back' then p.cancel = true
    end
    p.moved = true
    return true
end

-- 今まで描いた項目の数（この後に描く項目の番号を知るため）
function focus.mark(win)
    local b = W(win).building
    return b and #b or 0
end

-- 今描いている途中の i 番目の項目の id
function focus.id_at(win, i)
    local b = W(win).building
    local it = b and b[i]
    return it and it.id or nil
end

-- キャンセル：今の項目がスライダーなら、同じ行の左の項目（↺）へ移る。移ったら true
function focus.back_from_adjust(win)
    local w = W(win)
    local cur
    for _, it in ipairs(w.list) do if it.id == w.current then cur = it break end end
    if not cur or not cur.adjust then return false end
    local prev
    for _, it in ipairs(w.list) do
        if it.id == cur.id then break end
        if it.section == cur.section and it.row == cur.row and not it.adjust then prev = it end
    end
    if not prev then return false end
    w.current = prev.id
    w.adjust = nil
    w.scroll_to = prev.id
    return true
end

-- 決定：次のフレームで今の項目を実行する
function focus.activate(win)
    local w = W(win)
    if w.current then w.activate = w.current end
end

return focus
