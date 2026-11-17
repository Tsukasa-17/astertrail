--[[
  Astertrail - 名前の色分け（アイテム・エリア・話すNPC・モンスター・調べる対象）
  - 資料の決まった欄（location.zone_name、相手の name_en、needs[].name_ja など）から
    「色を付ける言葉」を集め、文の中でその言葉と同じ部分だけに色を付ける。
  - 文に無い名前は付け足さない。推測で言葉を探さない。色だけに意味を持たせない（文字はそのまま）。
  - 折り返しは CalcTextSize が使える時だけ自前で行う（使えなければ1行のまま並べる）。
  - トラッカー・詳細・お知らせ・必要品まとめで同じものを使う。
]]

local theme = require('src.ui.theme')

local CT = {}

-- 色分けの種類 → theme.palette の名前
CT.KIND_COLOR = { item = 'item', key_item = 'item', zone = 'zone', npc = 'npc', mob = 'mob', object = 'obj', obj = 'obj', group = 'accent' }

-- トラッカーなどで名前を押したときの動作。
-- 話すNPCと調べる対象（???を含む）は地図。アイテムはコピー。
-- ゾーンは対象外。モンスター（0.1.171〜）は地図を開き、近くにいれば出す。
CT.CLICK = { npc = 'map', obj = 'map', object = 'map', mob = 'map', item = 'copy', key_item = 'copy', group = 'map' }

function CT.click_action(kind)
    return kind and CT.CLICK[kind] or nil
end


-- 言葉を足す（空・同じ言葉は足さない）
function CT.add(terms, s, kind)
    terms = terms or {}
    if type(s) ~= 'string' or s == '' then return terms end
    for _, t in ipairs(terms) do if t.s == s then return terms end end
    terms[#terms + 1] = { s = s, kind = kind }
    return terms
end

-- 手順に書いてある名前（エリア・相手・必要品）
function CT.step_terms(D, step, terms)
    terms = terms or {}
    if not step then return terms end
    local loc = step.location
    if loc then CT.add(terms, loc.zone_name or (D and D:zone_name(loc.zone_id)), 'zone') end
    local tg = D and step.target and D:target(step.target)
    if tg then
        local k = tg.kind
        if k ~= 'npc' and k ~= 'mob' and k ~= 'obj' and k ~= 'object' then k = 'npc' end
        CT.add(terms, tg.name_en, k)
        if tg.location then CT.add(terms, tg.location.zone_name or D:zone_name(tg.location.zone_id), 'zone') end
    end
    for _, n in ipairs(step.needs or {}) do
        local k = (n.kind == 'key_item') and 'key_item' or 'item'
        CT.add(terms, n.name_ja, k)
        CT.add(terms, n.name_en, k)
    end
    return terms
end

-- 同じクエストの全手順から言葉を集める（他の手順に出る名前も色を付ける）
function CT.quest_terms(D, q, terms)
    terms = terms or {}
    if not q then return terms end
    for _, s in ipairs(q.steps or {}) do
        CT.step_terms(D, s, terms)
    end
    return terms
end

-- 文を色付きの区切りに分ける。戻り値: { {text=, color=palette名 or nil}, ... }
-- 同じ位置から始まる言葉が複数あれば長い方を使う
function CT.spans(text, terms)
    text = tostring(text or '')
    local out = {}
    if text == '' then return out end
    if not terms or #terms == 0 then out[1] = { text = text }; return out end
    local pos, n = 1, #text
    while pos <= n do
        local best_s, best_e, best_k
        for _, t in ipairs(terms) do
            local s, e = text:find(t.s, pos, true)
            if s and (not best_s or s < best_s or (s == best_s and e > best_e)) then
                best_s, best_e, best_k = s, e, t.kind
            end
        end
        if not best_s then
            out[#out + 1] = { text = text:sub(pos) }
            break
        end
        if best_s > pos then out[#out + 1] = { text = text:sub(pos, best_s - 1) } end
        out[#out + 1] = { text = text:sub(best_s, best_e), color = CT.KIND_COLOR[best_k] or best_k, kind = best_k }
        pos = best_e + 1
    end
    return out
end

function CT.has_color(spans)
    for _, s in ipairs(spans) do if s.color then return true end end
    return false
end

---------------------------------------------------------------------------
-- 描く
---------------------------------------------------------------------------

local function text_w(imgui, s)
    if not imgui.CalcTextSize then return nil end
    local ok, a = pcall(imgui.CalcTextSize, s)
    if not ok then return nil end
    if type(a) == 'number' then return a end
    if type(a) == 'table' then return a.x or a[1] end
    if type(a) == 'userdata' then
        local ok2, x = pcall(function () return a.x end)
        if ok2 and type(x) == 'number' then return x end
    end
    return nil
end

-- 文字（UTF-8）と英数字のかたまりに分ける。色付きの名前は一つのかたまりにする
local function tokens_of(span)
    local out = {}
    if span.color or span.kind then out[1] = { text = span.text, color = span.color, kind = span.kind, atom = true }; return out end
    local s = span.text
    local i, n = 1, #s
    while i <= n do
        local c = s:byte(i)
        local j
        if c == 32 then
            j = i
        elseif c < 0x80 then
            j = i
            while j + 1 <= n do
                local d = s:byte(j + 1)
                if d >= 0x80 or d == 32 then break end
                j = j + 1
            end
        else
            local len = (c >= 0xF0) and 4 or (c >= 0xE0) and 3 or (c >= 0xC0) and 2 or 1
            j = math.min(n, i + len - 1)
        end
        out[#out + 1] = { text = s:sub(i, j), color = nil }
        i = j + 1
    end
    return out
end

local function split_chars(tok)
    local out = {}
    for ch in tok.text:gmatch('[%z\1-\127\194-\244][\128-\191]*') do
        out[#out + 1] = { text = ch, color = tok.color, kind = tok.kind }
    end
    return out
end

CT.text_w = text_w

-- 右そろえ（0.1.61〜、トラッカー）：今の行の右端に w の幅が収まる位置へカーソルを動かす。測れなければ何もしない
local function num_x(a)
    if type(a) == 'table' then return tonumber(a.x or a[1]) end
    if type(a) == 'userdata' then
        local ok, x = pcall(function () return a.x end)
        return ok and tonumber(x) or nil
    end
    return tonumber(a)
end
function CT.push_right(imgui, w)
    if not w then return false end
    local okc, cx = pcall(imgui.GetCursorPosX)
    local oka, av = pcall(imgui.GetContentRegionAvail)
    cx, av = okc and num_x(cx) or nil, oka and num_x(av) or nil
    if not cx or not av then return false end
    if av > w then pcall(imgui.SetCursorPosX, cx + av - w) end
    return true
end

local function line_w(imgui, line)
    local w = 0
    for _, piece in ipairs(line) do
        local pw = text_w(imgui, piece.text)
        if not pw then return nil end
        w = w + pw
    end
    return w
end

local cache, cache_n = {}, 0
local NO_START = {}
for ch in ('、。，．・：；？！ー」』）】〉》〕］｝…‥ぁぃぅぇぉっゃゅょァィゥェォッャュョ,.:;!?)]}'):gmatch('[%z\1-\127\194-\244][\128-\191]*') do NO_START[ch] = true end

-- 行に分ける。戻り値: { { {text,color}, ... }, ... }（行ごとの区切り）。測れなければ nil
local function layout(imgui, spans, width)
    local unit = text_w(imgui, 'M')
    if not unit or not width or width <= 0 then return nil end
    local key = {}
    for _, s in ipairs(spans) do key[#key + 1] = (s.color or '') .. '\1' .. s.text end
    local ck = table.concat(key, '\2') .. '\3' .. math.floor(width) .. '\3' .. unit
    if cache[ck] then return cache[ck] end
    local lines, line, x = {}, {}, 0
    local function push(tok, w)
        local last = line[#line]
        if last and last.color == tok.color and last.kind == tok.kind then last.text = last.text .. tok.text
        else line[#line + 1] = { text = tok.text, color = tok.color, kind = tok.kind } end
        x = x + w
    end
    local function newline()
        lines[#lines + 1] = line
        line, x = {}, 0
    end
    local function by_char(tok)
        for _, ch in ipairs(split_chars(tok)) do
            local cw = text_w(imgui, ch) or 0
            if x > 0 and x + cw > width then newline() end
            push(ch, cw)
        end
    end
    for _, sp in ipairs(spans) do
        for _, tok in ipairs(tokens_of(sp)) do
            local w = text_w(imgui, tok.text) or 0
            if w > width and #tok.text > 1 then
                -- 一行に入らない長いかたまりは文字で折る
                by_char(tok)
            elseif x > 0 and x + w > width and NO_START[tok.text] and x + w <= width + w then
                -- 行頭に来てはいけない記号（、。」など）は前の行の終わりに付ける
                push(tok, w)
            elseif x > 0 and x + w > width then
                newline()
                if tok.text ~= ' ' then push(tok, w) end
            else
                push(tok, w)
            end
        end
    end
    if #line > 0 then lines[#lines + 1] = line end
    if cache_n > 400 then cache, cache_n = {}, 0 end
    cache[ck] = lines
    cache_n = cache_n + 1
    return lines
end
CT._layout = layout

local function draw_piece(imgui, piece, opts)
    local name = piece.color or opts.base
    if name then
        imgui.TextColored(theme.col(name), piece.text)
    elseif opts.muted then
        imgui.TextDisabled(piece.text)
    else
        imgui.TextColored(theme.col('text'), piece.text)
    end
end

--[[
  区切りを描く。opts = { base = 色の名前（無ければ通常）, muted = bool, wrap = bool（既定 true） }
  色の付く部分が無ければ、今までと同じ一つの呼び出しで描く（折り返しも ImGui に任せる）。
]]
function CT.draw_spans(ui, spans, opts)
    opts = opts or {}
    local imgui = ui.imgui
    if #spans == 0 then imgui.TextColored(theme.col('text'), ' '); return end
    local has_link = opts.link ~= nil
    local right = opts.align == 'right'
    if #spans == 1 and not spans[1].color and not (has_link and CT.click_action(spans[1].kind)) and not right then
        local s = spans[1].text
        if opts.base then imgui.TextColored(theme.col(opts.base), s)
        elseif opts.muted then imgui.TextDisabled(s)
        else imgui.TextWrapped(s) end
        return
    end
    local lines
    if opts.wrap ~= false or right then
        local avail = imgui.GetContentRegionAvail()
        if type(avail) == 'table' then avail = avail.x or avail[1] end
        lines = layout(imgui, spans, (tonumber(avail) or 0) - 4)
    end
    if not lines then
        -- 測れない：右そろえはやめて、今までどおり描く
        if right and #spans == 1 and not spans[1].color and not (has_link and CT.click_action(spans[1].kind)) then
            local s = spans[1].text
            if opts.base then imgui.TextColored(theme.col(opts.base), s)
            elseif opts.muted then imgui.TextDisabled(s)
            else imgui.TextWrapped(s) end
            return
        end
        lines = { spans }
    end
    for _, line in ipairs(lines) do
        -- 右そろえ：行の幅を測って、右端に寄せる（名前のボタンも同じ位置に置くので、押せる場所は文字と同じ）
        if right then
            if #line > 0 and line[#line].text == ' ' then
                local trimmed = {}
                for k = 1, #line - 1 do trimmed[k] = line[k] end
                line = trimmed
            end
            CT.push_right(imgui, line_w(imgui, line))
        end
        if has_link and imgui.AlignTextToFramePadding then pcall(imgui.AlignTextToFramePadding) end
        for i, piece in ipairs(line) do
            if i > 1 then imgui.SameLine(0, 0) end
            local act = has_link and CT.click_action(piece.kind)
            if act then
                local hit = opts.link(piece, act)
                if hit and opts.on_linked then opts.on_linked(act, piece) end
            else
                draw_piece(imgui, piece, opts)
            end
        end
        if #line == 0 then imgui.TextColored(theme.col('text'), ' ') end
    end
end

-- 色の付かない文を、今の幅で折り返して描く（日本語は一文字ずつ、英語は空白で）。
-- mode: 'muted' | 'text' | 色の名前。改行はそのまま。幅が測れないときは ImGui の折り返しに任せる
function CT.wrapped(ui, text, mode, align)
    local imgui = ui.imgui
    text = tostring(text or '')
    local function one(s)
        if mode == 'muted' then imgui.TextDisabled(s)
        elseif mode == 'text' or mode == nil then imgui.TextColored(theme.col('text'), s)
        else imgui.TextColored(theme.col(mode), s) end
    end
    local avail = imgui.GetContentRegionAvail and imgui.GetContentRegionAvail() or nil
    if type(avail) == 'table' then avail = avail.x or avail[1] end
    local width = (tonumber(avail) or 0) - 4
    local lines = {}
    local measured = width > 8
    for para in (text .. '\n'):gmatch('(.-)\n') do
        if para == '' then
            lines[#lines + 1] = ''
        else
            local ls = measured and layout(imgui, { { text = para } }, width) or nil
            if not ls then measured = false; break end
            for _, l in ipairs(ls) do
                local parts = {}
                for _, piece in ipairs(l) do parts[#parts + 1] = piece.text end
                lines[#lines + 1] = (table.concat(parts):gsub('^ +', ''):gsub(' +$', ''))
            end
        end
    end
    if not measured then
        if imgui.PushTextWrapPos then imgui.PushTextWrapPos(0) end
        one(text)
        if imgui.PopTextWrapPos then imgui.PopTextWrapPos() end
        return
    end
    for _, l in ipairs(lines) do
        local s = (l == '' and ' ' or l)
        if align == 'right' then CT.push_right(imgui, text_w(imgui, s)) end
        one(s)
    end
end

-- 文と言葉から描く
function CT.draw(ui, text, terms, opts)
    CT.draw_spans(ui, CT.spans(text, terms), opts)
end

return CT
