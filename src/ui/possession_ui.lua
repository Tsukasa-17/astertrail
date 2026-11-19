--[[
  Astertrail - 所持の表示（0.1.184〜、t297）。詳細の手順とトラッカーで使う。
  必要な品は手順文の横に「(0/1所持)」を付ける。だいじなものは名前の直後に、
  括弧の中へ持っているときは緑のチェック、持っていないときは赤のバツを描く。
  名前を押すと正式名称だけコピーする。数や印はコピーせず、乗せると場所（または未所持）を出す。
  決まり：テンポラリは数えない。まだ届いていない入れ物は空にしない。
]]
local poss = require('src.core.possession')
local theme = require('src.ui.theme')
local CT = require('src.ui.colored_text')

local M = {}

-- 必要の欄ごとの { text, color, tip, state }
function M.segments(ui, needs)
    local t = ui.t
    local out = {}
    local many = #needs > 1
    for _, n in ipairs(needs) do
        local s = ui.need_possession and ui.need_possession(n) or { state = 'unknown' }
        local st = poss.text(t, s)
        local text = many and t('poss.seg', { name = n.name_ja or n.name_en or '?', state = st }) or st
        out[#out + 1] = { text = text, color = poss.color(s), tip = poss.where(t, s), state = s.state, need = n, st = s }
    end
    return out
end

function M.all_unknown(segs)
    for _, g in ipairs(segs) do if g.state ~= 'unknown' then return false end end
    return true
end

function M.count_color(st)
    if not st then return 'text' end
    if st.state == 'enough' or st.state == 'owned' then return 'good' end
    if st.state == 'short' or st.state == 'missing' then return 'ic_bad' end
    return 'text'
end

function M.count_tip(ui, st)
    if not st then return nil end
    local t = ui.t
    local tip = poss.where(t, st)
    if tip and tip ~= '' then return tip end
    if st.state == 'missing' or st.state == 'short' or (st.kind == 'item' and (st.have or 0) <= 0) then
        return t('sf.poss_none_tip')
    end
    return nil
end

-- だいじなものの印用の幅（全角スペース）。文字は描かず、同じ大きさで形を描く。
M.KEY_MARK_SLOT = '　'

local function cursor_xy(imgui)
    if not imgui or not imgui.GetCursorScreenPos then return nil, nil end
    local ok, a, b = pcall(imgui.GetCursorScreenPos)
    if not ok then return nil, nil end
    if type(a) == 'table' then return tonumber(a.x or a[1]), tonumber(a.y or a[2]) end
    return tonumber(a), tonumber(b)
end

local function item_xy(imgui, getter)
    if not imgui or not getter then return nil, nil end
    local ok, a, b = pcall(getter)
    if not ok then return nil, nil end
    if type(a) == 'table' then return tonumber(a.x or a[1]), tonumber(a.y or a[2]) end
    return tonumber(a), tonumber(b)
end

-- 持っている：緑のチェック。持っていない：赤のバツ。Meiryo に ✔❌ が無くても形で描く。
function M.draw_key_mark(ui, owned, opts)
    opts = opts or {}
    local imgui = ui and ui.imgui
    if not imgui then return end
    local tw, th = theme.measure_text(imgui, M.KEY_MARK_SLOT)
    tw, th = tonumber(tw) or 16, tonumber(th) or 16
    if tw < 8 then tw = 12 end
    if th < 8 then th = 12 end
    local id = opts.id or '##poss_key_mark'
    if imgui.InvisibleButton then
        pcall(imgui.InvisibleButton, id, { tw, th })
    elseif imgui.Dummy then
        pcall(imgui.Dummy, { tw, th })
    end
    local x1, y1 = item_xy(imgui, imgui.GetItemRectMin)
    local x2, y2 = item_xy(imgui, imgui.GetItemRectMax)
    if not x1 then
        x1, y1 = cursor_xy(imgui)
        if x1 then x2, y2 = x1 + tw, y1 + th end
    end
    local ok, dl = pcall(function () return imgui.GetWindowDrawList() end)
    if ok and dl and x1 and y1 and x2 and y2 then
        local pad = math.max(1, math.floor(math.min(x2 - x1, y2 - y1) * 0.18))
        local ax, ay, bx, by = x1 + pad, y1 + pad, x2 - pad, y2 - pad
        local thick = math.max(1.4, (by - ay) * 0.14)
        local col
        if owned then
            col = theme.u32('good', 1)
            local mx = ax + (bx - ax) * 0.32
            local my = by - (by - ay) * 0.08
            pcall(function ()
                dl:AddLine({ ax, ay + (by - ay) * 0.48 }, { mx, my }, col, thick)
                dl:AddLine({ mx, my }, { bx, ay }, col, thick)
            end)
        else
            col = theme.u32('ic_bad', 1)
            pcall(function ()
                dl:AddLine({ ax, ay }, { bx, by }, col, thick)
                dl:AddLine({ bx, ay }, { ax, by }, col, thick)
            end)
        end
    end
    local tip = opts.tooltip
    if tip and imgui.IsItemHovered and imgui.IsItemHovered() and imgui.SetTooltip then
        pcall(imgui.SetTooltip, tip)
    end
end

local function official_name(n)
    if type(n) == 'table' then return n.name_ja or n.name_en or '' end
    return tostring(n or '')
end

local function copy_name(ui, name)
    if name and name ~= '' and ui.copy_to_clipboard then ui.copy_to_clipboard(name) end
end

local function draw_need_name(ui, win, id, name)
    local W = require('src.ui.widgets')
    local tip = ui.t and ui.t('tracker.copy_item') or nil
    if W.link(ui, win or 'book', id, name, { color = 'item', tooltip = tip, no_focus = true }) then
        copy_name(ui, name)
    end
end

local function draw_need_count(ui, win, id, text, st)
    local W = require('src.ui.widgets')
    local col = M.count_color(st)
    local tip = M.count_tip(ui, st)
    -- 押してもコピーしない。ツールチップだけ。
    W.link(ui, win or 'book', id, text, { color = col, tooltip = tip, no_focus = true })
end

local function draw_need_pieces(ui, win, prefix, n, st, i)
    local imgui = ui.imgui
    local name = official_name(n)
    if name == '' then return end
    local t = ui.t
    draw_need_name(ui, win, prefix .. '_n' .. tostring(i), name)
    if st.state == 'unknown' then return end
    imgui.SameLine(0, 0)
    theme.TextColored(imgui, theme.col('text'), '(')
    imgui.SameLine(0, 0)
    if n.kind == 'key_item' or st.kind == 'key' then
        M.draw_key_mark(ui, st.state == 'owned', {
            id = '##pk_' .. prefix .. '_' .. tostring(i),
            tooltip = M.count_tip(ui, st),
        })
    else
        local num
        if st.have ~= nil and st.need ~= nil then
            num = tostring(st.have) .. '/' .. tostring(st.need)
        else
            num = poss.text(t, st)
        end
        draw_need_count(ui, win, prefix .. '_c' .. tostring(i), num, st)
        if st.state == 'short' and st.unknown and #st.unknown > 0 then
            imgui.SameLine(0, 0)
            theme.TextColored(imgui, theme.col('text'), t('poss.count_partial', { text = '' }):gsub('^%s*', ''))
        end
    end
    imgui.SameLine(0, 0)
    -- 通常の品は括弧の中に「所持」を残す。だいじなものは印だけ。
    if not (n.kind == 'key_item' or st.kind == 'key') then
        theme.TextColored(imgui, theme.col('text'), '所持)')
    else
        theme.TextColored(imgui, theme.col('text'), ')')
    end
end

-- 1 行に並べる（幅が足りなければ次の行へ）。先頭に「所持:」
function M.draw_inline(ui, needs, win, id_prefix)
    local t = ui.t
    needs = needs or {}
    if #needs == 0 then return end
    local segs = M.segments(ui, needs)
    if #segs == 0 then return end
    local imgui = ui.imgui
    if M.all_unknown(segs) then theme.TextDisabled(imgui, t('need.possession_unknown')); return end
    theme.TextDisabled(imgui, t('poss.label'))
    local prefix = id_prefix or 'poss'
    for i, g in ipairs(segs) do
        imgui.SameLine(0, (i == 1) and 0 or 8)
        if i > 1 then
            theme.TextDisabled(imgui, t('poss.sep_between'))
            imgui.SameLine(0, 4)
        end
        if g.need then
            draw_need_pieces(ui, win, prefix, g.need, g.st, i)
        else
            local col = g.color
            if col then theme.TextColored(imgui, theme.col(col), g.text) else theme.TextDisabled(imgui, g.text) end
            if g.tip and imgui.IsItemHovered and imgui.IsItemHovered() and imgui.SetTooltip then imgui.SetTooltip(g.tip) end
        end
    end
end

-- 1 品 1 行。どれも未確認なら何も出さない（互換のため残す）
function M.draw_lines(ui, needs, push_w, win, id_prefix)
    local segs = M.segments(ui, needs)
    if #segs == 0 or M.all_unknown(segs) then return false end
    local t = ui.t
    local imgui = ui.imgui
    local prefix = id_prefix or 'possL'
    for i, g in ipairs(segs) do
        theme.TextDisabled(imgui, t('poss.label'))
        imgui.SameLine(0, 0)
        if g.need then
            draw_need_pieces(ui, win, prefix, g.need, g.st, i)
        else
            if push_w then push_w(CT.text_w(imgui, t('poss.label') .. (g.text or ''))) end
            local col = g.color
            if col then theme.TextColored(imgui, theme.col(col), g.text) else theme.TextDisabled(imgui, g.text) end
            if g.tip and imgui.IsItemHovered and imgui.IsItemHovered() and imgui.SetTooltip then imgui.SetTooltip(g.tip) end
        end
    end
    return true
end

-- 「クゥダフ人形の胴」→「胴」のように、の後ろの短い名前
function M.short_need_name(name)
    if not name or name == '' then return name end
    local last, i = nil, 1
    while true do
        local a, b = name:find('の', i, true)
        if not a then break end
        last, i = b, b + 1
    end
    if last and last < #name then return name:sub(last + 1) end
    return name
end

local function find_uncovered(text, needle, used, from)
    from = from or 1
    while true do
        local a, b = text:find(needle, from, true)
        if not a then return nil end
        local covered = false
        for _, r in ipairs(used) do
            if a >= r[1] and b <= r[2] then covered = true; break end
        end
        if not covered then return a, b end
        from = a + 1
    end
end

-- 長い順。入手と必要の直後の言葉
local OBTAIN_TAIL = {
    'を手に入れる', 'を手に入れ', 'をもらって', 'をもらう', 'を受け取って', 'を受け取り',
    'を入手する', 'を入手し', 'を入手', 'をゲット',
}
local REQUIRE_TAIL = {
    'をトレードして', 'をトレード', 'を渡して', 'を渡し', 'を渡せ',
    'を届けて', 'を届け', 'を提出して', 'を提出',
    'を見せて', 'を見せ', 'を提示して', 'を提示',
    'を使って', 'を使う', 'を使用して', 'を使用',
    'をはめて', 'をはめ', 'を入れて', 'を入れ',
    'をセットして', 'をセット', 'を消費して', 'を消費',
    'を預けて', 'を預け', 'を売って', 'を売り',
}

local function starts_with(s, prefix)
    return type(s) == 'string' and type(prefix) == 'string' and s:sub(1, #prefix) == prefix
end

function M.role_after(text, endpos)
    if not text or not endpos then return nil end
    local rest = text:sub(endpos + 1)
    -- 閉じかっこを飛ばす
    if starts_with(rest, '」') then rest = rest:sub(#'」' + 1) end
    if starts_with(rest, '"') or starts_with(rest, '“') then rest = rest:sub(2) end
    for _, p in ipairs(OBTAIN_TAIL) do
        if starts_with(rest, p) then return 'obtain' end
    end
    for _, p in ipairs(REQUIRE_TAIL) do
        if starts_with(rest, p) then return 'require' end
    end
    return nil
end

function M.quoted_names(text)
    local out = {}
    if type(text) ~= 'string' then return out end
    local i = 1
    while true do
        local a, b = text:find('「', i, true)
        if not a then break end
        local c, d = text:find('」', b + 1, true)
        if not c then break end
        local name = text:sub(b + 1, c - 1)
        if name ~= '' then
            out[#out + 1] = { name = name, a = b + 1, b = c - 1 }
        end
        i = d + 1
    end
    return out
end

local function need_key(n)
    if not n then return '' end
    return tostring(n.kind or '') .. ':' .. tostring(n.item_id or n.key_item_id or n.name_ja or n.name_en or '')
end

local function lookup_need(ui, name, hint)
    if hint then
        local h = {}
        for k, v in pairs(hint) do h[k] = v end
        if not h.name_ja then h.name_ja = name end
        return h
    end
    local D = ui and ui.data
    if D and D.lookup_item_name then
        local r = D:lookup_item_name(name)
        if r then return r end
    end
    -- 番号が無い。だいじなものかどうかは分からないので、表示だけ名前を残す
    return { kind = 'item', name_ja = name, count = 1 }
end

-- この手順が必要とする品（資料の needs ＋ 文面から分かる渡し・トレードなど）。入手だけの品は入れない。
function M.gather_needs(ui, step, text, q)
    local out, seen = {}, {}
    local function add(n)
        if type(n) ~= 'table' then return end
        local key = need_key(n)
        if key == ':' or seen[key] then return end
        seen[key] = true
        out[#out + 1] = n
    end
    for _, n in ipairs(step and step.needs or {}) do add(n) end

    local hints = {}
    if q then
        for _, s in ipairs(q.steps or {}) do
            for _, n in ipairs(s.needs or {}) do
                local name = n.name_ja or n.name_en
                if name and name ~= '' then hints[name] = n end
            end
        end
    end

    -- かぎかっこの名前：直後が必要の言葉なら足す。入手の言葉なら足さない。
    for _, qn in ipairs(M.quoted_names(text or '')) do
        local role = M.role_after(text, qn.b)
        if role == 'require' and not hints[qn.name] or role == 'require' then
            -- always add required quoted names (may already be in step.needs)
            local already = false
            for _, n in ipairs(out) do
                if (n.name_ja or n.name_en) == qn.name then already = true; break end
            end
            if not already then add(lookup_need(ui, qn.name, hints[qn.name])) end
        end
    end

    -- 資料の needs にだけあり、文では短い名前で出ているものはそのまま（step.needs 済み）
    return out
end

local function poss_suffix(ui, n)
    local S = ui.settings
    if not (S and S.items and S.items.show_possession) then return nil, nil, nil end
    local st = ui.need_possession and ui.need_possession(n) or { state = 'unknown' }
    if st.state == 'unknown' then return nil, nil, st end
    local t = ui.t
    local suf
    if n.kind == 'key_item' or st.kind == 'key' then
        suf = '(' .. M.KEY_MARK_SLOT .. ')'
    elseif st.have ~= nil and st.need ~= nil then
        suf = t('sf.poss_held', { have = st.have, need = st.need })
    end
    if not suf then return nil, nil, st end
    return suf, M.count_tip(ui, st), st
end

local function push_name_terms(extras, shown, official, kind)
    extras[#extras + 1] = { s = shown, kind = kind, copy_text = official }
    if official and official ~= shown then
        extras[#extras + 1] = { s = official, kind = kind, copy_text = official }
    end
end

local function push_hold_terms(extras, n, shown, official, suf, tip, st)
    local kind = (n.kind == 'key_item' or (st and st.kind == 'key')) and 'key_item' or 'item'
    push_name_terms(extras, shown, official, kind)
    if not suf or not st then return end
    if kind == 'key_item' then
        extras[#extras + 1] = {
            s = M.KEY_MARK_SLOT, kind = 'poss_key_mark', mark = (st.state == 'owned') and 'ok' or 'no',
            tip = tip, once = true, dup = true, key = official, color = (st.state == 'owned') and 'good' or 'ic_bad',
        }
    elseif st.have ~= nil and st.need ~= nil then
        local num = tostring(st.have) .. '/' .. tostring(st.need)
        extras[#extras + 1] = {
            s = num, kind = 'poss_count', color = M.count_color(st),
            tip = tip, once = true, dup = true, key = official,
        }
    end
end

-- 手順文に所持を足し、名前・数・印の言葉を返す
-- 戻り値: text, extras（{ s, kind, tip, copy_text, color, once, mark }）
function M.apply_to_step(ui, step, text, q)
    if not step or not text or text == '' then return text, {} end
    local needs = M.gather_needs(ui, step, text, q)
    if #needs == 0 then return text, {} end
    local found, missing, used = {}, {}, {}
    local extras = {}
    for _, n in ipairs(needs) do
        local name = n.name_ja or n.name_en
        if name and name ~= '' then
            local suf, tip, st = poss_suffix(ui, n)
            if suf then
                local a, b = text:find(name, 1, true)
                if a then
                    found[#found + 1] = { a = a, b = b, suf = suf, name = name, tip = tip, st = st, n = n }
                    used[#used + 1] = { a, b }
                else
                    missing[#missing + 1] = { name = name, suf = suf, tip = tip, st = st, n = n }
                end
            end
        end
    end
    for _, e in ipairs(missing) do
        local short = M.short_need_name(e.name)
        if short and short ~= '' then
            local a, b = find_uncovered(text, short, used, 1)
            if a then
                -- 短い名前の直後が入手なら、別の品の話なので付けない
                if M.role_after(text, b) == 'obtain' then
                    -- skip
                else
                    found[#found + 1] = { a = a, b = b, suf = e.suf, name = e.name, short = short, tip = e.tip, st = e.st, n = e.n }
                    used[#used + 1] = { a, b }
                    e.placed = true
                end
            end
        end
    end
    table.sort(found, function (x, y) return x.b > y.b end)
    local out, seen = text, {}
    for _, e in ipairs(found) do
        if not seen[e.name] then
            seen[e.name] = true
            out = out:sub(1, e.b) .. e.suf .. out:sub(e.b + 1)
            push_hold_terms(extras, e.n, e.short or e.name, e.name, e.suf, e.tip, e.st)
        end
    end
    local trail = {}
    for _, e in ipairs(missing) do
        if not e.placed and not seen[e.name] then
            -- 文に無い必要品は末尾へ（入手だけの品は gather で入っていない）
            local short = M.short_need_name(e.name)
            trail[#trail + 1] = short .. e.suf
            push_hold_terms(extras, e.n, short, e.name, e.suf, e.tip, e.st)
            seen[e.name] = true
        end
    end
    if #trail > 0 then
        out = out .. ' ' .. table.concat(trail, '・')
    end
    return out, extras
end

function M.merge_terms(terms, extras)
    terms = terms or {}
    for _, e in ipairs(extras or {}) do
        CT.add(terms, e.s, e.kind, {
            tip = e.tip, copy_text = e.copy_text, color = e.color,
            once = e.once, dup = e.dup, key = e.key, mark = e.mark,
        })
    end
    return terms
end

return M
