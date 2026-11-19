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
CT.CLICK = { npc = 'map', obj = 'map', object = 'map', mob = 'map', item = 'copy', key_item = 'copy', group = 'map', poss_count = 'tip', poss_key_mark = 'tip' }

function CT.click_action(kind)
    return kind and CT.CLICK[kind] or nil
end


-- 言葉を足す（空・同じ言葉は足さない）
function CT.add(terms, s, kind, extra)
    terms = terms or {}
    if type(s) ~= 'string' or s == '' then return terms end
    extra = extra or {}
    if not extra.dup then
        for _, t in ipairs(terms) do
            if t.s == s then
                if extra.tip and not t.tip then t.tip = extra.tip end
                if extra.copy_text and not t.copy_text then t.copy_text = extra.copy_text end
                if extra.color and not t.color then t.color = extra.color end
                if extra.key and not t.key then t.key = extra.key end
                if extra.mark and not t.mark then t.mark = extra.mark end
                return terms
            end
        end
    end
    local e = { s = s, kind = kind }
    if extra.tip then e.tip = extra.tip end
    if extra.copy_text then e.copy_text = extra.copy_text end
    if extra.color then e.color = extra.color end
    if extra.once then e.once = true end
    if extra.dup then e.dup = true end
    if extra.key then e.key = extra.key end
    if extra.mark then e.mark = extra.mark end
    terms[#terms + 1] = e
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
    local used = {}
    while pos <= n do
        local best_s, best_e, best_i
        for i, t in ipairs(terms) do
            if not (t.once and used[i]) then
                local s, e = text:find(t.s, pos, true)
                if s and (not best_s or s < best_s or (s == best_s and e > best_e)) then
                    best_s, best_e, best_i = s, e, i
                end
            end
        end
        if not best_s then
            out[#out + 1] = { text = text:sub(pos) }
            break
        end
        local t = terms[best_i]
        if t.once then used[best_i] = true end
        if best_s > pos then out[#out + 1] = { text = text:sub(pos, best_s - 1) } end
        out[#out + 1] = {
            text = text:sub(best_s, best_e),
            color = t.color or CT.KIND_COLOR[t.kind] or t.kind,
            kind = t.kind, tip = t.tip, copy_text = t.copy_text, key = t.key, mark = t.mark,
        }
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
    if span.color or span.kind then
        out[1] = {
            text = span.text, color = span.color, kind = span.kind, atom = true,
            tip = span.tip, copy_text = span.copy_text, key = span.key, mark = span.mark,
        }
        return out
    end
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
        out[#out + 1] = { text = ch, color = tok.color, kind = tok.kind, tip = tok.tip, copy_text = tok.copy_text, key = tok.key, mark = tok.mark }
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
    for _, s in ipairs(spans) do
        key[#key + 1] = (s.color or '') .. '\1' .. s.text .. '\1' .. (s.kind or '') .. '\1' .. (s.tip or '') .. '\1' .. (s.copy_text or '') .. '\1' .. (s.mark or '')
    end
    local ck = table.concat(key, '\2') .. '\3' .. math.floor(width) .. '\3' .. unit
    if cache[ck] then return cache[ck] end
    local lines, line, x = {}, {}, 0
    local function push(tok, w)
        local last = line[#line]
        if last and last.color == tok.color and last.kind == tok.kind and last.tip == tok.tip and last.copy_text == tok.copy_text and last.mark == tok.mark and last.key == tok.key then
            last.text = last.text .. tok.text
        else
            line[#line + 1] = { text = tok.text, color = tok.color, kind = tok.kind, tip = tok.tip, copy_text = tok.copy_text, key = tok.key, mark = tok.mark }
        end
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

local function cursor_xy(imgui)
    if not imgui or not imgui.GetCursorScreenPos then return nil, nil end
    local ok, a, b = pcall(imgui.GetCursorScreenPos)
    if not ok then return nil, nil end
    if type(a) == 'table' then return tonumber(a.x or a[1]), tonumber(a.y or a[2]) end
    return tonumber(a), tonumber(b)
end

-- 色名を必ず決めてから描く。行パス中は theme.u32(名前) でキューに載せ、
-- TextColored に色の表を渡してフックで組み直す経路は使わない（0.1.258）。
local function draw_piece(imgui, piece, opts)
    local name = piece.color or opts.base
    if not name then name = opts.muted and 'muted' or 'text' end
    local outline = package.loaded['src.ui.crisp_outline']
    if outline and outline.in_line and outline.in_line() and outline.line_push then
        local x, y = cursor_xy(imgui)
        outline.line_push(x, y, piece.text, theme.u32(name, 1))
        local tw, th = theme.measure_text(imgui, piece.text)
        if imgui.Dummy then pcall(imgui.Dummy, { tw or 1, th or 1 }) end
        return
    end
    if name == 'muted' and not piece.color and not opts.base then
        theme.TextDisabled(imgui, piece.text)
    else
        theme.TextColored(imgui, theme.col(name), piece.text)
    end
end

--[[
  区切りを描く。opts = { base = 色の名前（無ければ通常）, muted = bool, wrap = bool（既定 true） }
  色の付く部分が無ければ、今までと同じ一つの呼び出しで描く（折り返しも ImGui に任せる）。
]]
function CT.draw_spans(ui, spans, opts)
    opts = opts or {}
    local imgui = ui.imgui
    if #spans == 0 then theme.TextColored(imgui, theme.col('text'), ' '); return end
    local has_link = opts.link ~= nil
    local right = opts.align == 'right'
    -- hang_x があるときは TextWrapped を使わない（折り返し行が x=0 に戻るため）
    if #spans == 1 and not spans[1].color and not (has_link and CT.click_action(spans[1].kind)) and not right and not opts.hang_x then
        local s = spans[1].text
        if opts.base then theme.TextColored(imgui, theme.col(opts.base), s)
        elseif opts.muted then theme.TextDisabled(imgui, s)
        else theme.TextWrapped(imgui, s) end
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
            if opts.base then theme.TextColored(imgui, theme.col(opts.base), s)
            elseif opts.muted then theme.TextDisabled(imgui, s)
            else theme.TextWrapped(imgui, s) end
            return
        end
        lines = { spans }
    end
    for _, line in ipairs(lines) do
        -- 手順文の折り返しは、1行目と同じ列（hang_x）から始める
        if opts.hang_x and imgui.SetCursorPosX then
            pcall(imgui.SetCursorPosX, opts.hang_x)
        end
        -- 右そろえ：行の幅を測って、右端に寄せる（名前のボタンも同じ位置に置くので、押せる場所は文字と同じ）
        if right then
            if #line > 0 and line[#line].text == ' ' then
                local trimmed = {}
                for k = 1, #line - 1 do trimmed[k] = line[k] end
                line = trimmed
            end
            CT.push_right(imgui, line_w(imgui, line))
        end
        local Wline = package.loaded['src.ui.widgets']
        local function draw_line()
            for i, piece in ipairs(line) do
                if i > 1 then imgui.SameLine(0, 0) end
                if piece.kind == 'poss_key_mark' or piece.mark then
                    local Wmark = package.loaded['src.ui.widgets']
                    if Wmark and Wmark.draw_key_mark then
                        Wmark.draw_key_mark(ui, piece, opts)
                    else
                        draw_piece(imgui, piece, opts)
                    end
                else
                    local act = has_link and CT.click_action(piece.kind)
                    if act then
                        local hit = opts.link(piece, act)
                        if hit and opts.on_linked then opts.on_linked(act, piece) end
                    else
                        draw_piece(imgui, piece, opts)
                    end
                end
            end
            if #line == 0 then theme.TextColored(imgui, theme.col('text'), ' ') end
        end
        -- 既に行パス中ならそのまま（入れ子にしない）。でなければこの行だけ縁を先にまとめる。
        local o = package.loaded['src.ui.crisp_outline']
        if o and o.in_line and o.in_line() then
            draw_line()
        elseif Wline and Wline.line_pass then
            Wline.line_pass(imgui, draw_line)
        else
            draw_line()
        end
    end
end

-- 色の付かない文を、今の幅で折り返して描く（日本語は一文字ずつ、英語は空白で）。
-- mode: 'muted' | 'text' | 色の名前。改行はそのまま。幅が測れないときは ImGui の折り返しに任せる
function CT.wrapped(ui, text, mode, align)
    local imgui = ui.imgui
    text = tostring(text or '')
    local function one(s)
        if mode == 'muted' then theme.TextDisabled(imgui, s)
        elseif mode == 'text' or mode == nil then theme.TextColored(imgui, theme.col('text'), s)
        else theme.TextColored(imgui, theme.col(mode), s) end
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
