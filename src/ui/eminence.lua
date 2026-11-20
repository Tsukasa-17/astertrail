--[[
  Astertrail - エミネンス・レコード（0.1.172〜、t243）
  ・窓：受けているものと進み（142/200）。
    0.1.177〜 達成間近のタブ、0.1.179〜 このエリアのしぼり込みと「一覧」のボタンはなくした（全部を出す。上の行はピン留めだけ）。
    「ピン留め」（0.1.177〜。前の「たたむ」）がオンなら ★ を付けたものだけ。
    出す・隠すは設定 eminence.visible（右上の ×、本のエミネンスのボタン、/astertrail eminence）。
  ・本の「エミネンス」：DAT の全部を分類ごとに。受けていないものに「受ける」、受けているものに「解除」。
    押したときに app.roe_send が 1 回だけ送る（やり直さない・ためない）。押せないときは理由をボタンの説明に出す。
    0.1.203〜 達成済みでくり返せないものはボタン自体を出さない（升は空）。「受ける」は塗った青緑＋「＋」、「解除」は赤い縁＋「×」。
    達成したもの（受けていない）は薄く、設定で隠す。受けられない・まだ無いと言われた番号は薄くして印を出す。
  ・名前・目標の数・くり返しは DAT から。分からないものは空のまま（番号だけ）。
  ・0.1.177〜：本は左に一覧・右に詳細（名前・説明・特別報酬・指定数・報酬・くり返し。DAT に無いものは空）。
    分類は「すべて」といちばん上の分類（0.1.182〜。下の分類のものは上の分類に入れる）。★ は窓のピン（窓の「ピン留め」で出す）。
    0.1.182〜 お気に入り（♥ の絵）は ★ と別で本だけ。「お気に入り」で ♥ のものだけを出す（窓には効かない）。
    そこからも「受ける」「解除」は押したときに 1 回だけ送る。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local focus = require('src.ui.focus')
local theme = require('src.ui.theme')
local util = require('src.lib.util')
local roe = require('src.core.roe')
local settings_mod = require('src.core.settings')

local eminence = {
    SEARCH_MAX = 300,   -- 本の検索で出す数の上限
}

local search_buf = { '' }
local search_synced = false
local sel_id = nil       -- 本の詳細に出す番号（0.1.177〜）

local function db_of(ui)
    if not ui.roe_db then return nil end
    local ok, db = pcall(ui.roe_db)
    if ok then return db end
    return nil
end

local function R(ui) return ui.state.roe or {} end

-- 名前（DAT に無ければ番号）
function eminence.name(ui, id)
    local db = db_of(ui)
    local q = db and db.quests[id]
    if q and q.name and q.name ~= '' then return q.name end
    return '#' .. tostring(id)
end

local function target_of(ui, id)
    local db = db_of(ui)
    local q = db and db.quests[id]
    return q and q.target or nil
end

-- 進みの文字（142/200、目標が分からなければ 142）
function eminence.progress_text(ui, entry)
    local t = target_of(ui, entry.id)
    local p = tonumber(entry.progress) or 0
    if t then return string.format('%d/%d', p, t) end
    return tostring(p)
end

---------------------------------------------------------------------------
-- 窓
---------------------------------------------------------------------------

-- 窓に出す行（ピン留めを当てた後。0.1.179〜 しぼり込みは無く、いつも全部）。戻り値: 行の表, 理由（空のとき）
function eminence.window_rows(ui)
    local E = ui.settings.eminence
    local r = R(ui)
    if not r.active then return {}, 'unknown' end
    local out = {}
    for _, e in ipairs(r.active) do
        if not (E.collapsed and not E.pins[tostring(e.id)]) then out[#out + 1] = e end
    end
    if #out == 0 then
        if #r.active == 0 then return out, 'none' end
        if E.collapsed then return out, 'no_pins' end
        return out, 'filtered'
    end
    return out
end

function eminence.draw(ui)
    if theme.is_sf and theme.is_sf() then
        return require('src.ui.eminence_win_sf').draw(ui)
    end
    local imgui, t, S = ui.imgui, ui.t, ui.settings
    local E = S.eminence
    local name = 'eminence'
    local open = { true }
    local r = R(ui)
    local n_act = 0
    for _, e in ipairs(r.active or {}) do if not e.timed then n_act = n_act + 1 end end
    local title = t('roe.window_title', { n = r.active and tostring(n_act) or '-', max = tostring(roe.MAX_ACTIVE) })
    local drawing = window.begin(ui, name, { title = title, open = open, operable = false, no_focus = true, fixed_top = true })
    if drawing then
        -- 上の行：ピン留めだけ（0.1.177〜。前の「たたむ」）。オンなら ★ を付けたものだけ。
        -- 0.1.179〜（t288）：「全部／このエリア」と「一覧」はなくした（全部だけになるのでタブの行ごと出さない）
        if W.button(ui, name, 'collapse', (E.collapsed and '◆ ' or '◇ ') .. t('roe.pin_only'),
            { section = 'head', row = 'h', small = true, no_focus = true, tooltip = t('roe.pin_only_tip') }) then
            E.collapsed = not E.collapsed
            ui.mark_settings_dirty()
        end

        local _, avail_h = imgui.GetContentRegionAvail()
        imgui.BeginChild('##astertrail_eminence_body', { 0, math.max(40, (avail_h or 200) - 2) }, 0, 0)
        window.push(ui, 'child')
        window.set_font(ui, window.font_scale(ui, name))
        local rows, why = eminence.window_rows(ui)
        if why then W.muted(ui, t('roe.empty.' .. why)) end
        for _, e in ipairs(rows) do
            local key = tostring(e.id)
            local pinned = E.pins[key] == true
            if W.button(ui, name, 'pin_' .. key, pinned and '★' or '☆', { section = 'list', row = key, small = true,
                no_focus = true, tooltip = t(pinned and 'roe.unpin' or 'roe.pin') }) then
                if pinned then E.pins[key] = nil else E.pins[key] = true end
                ui.mark_settings_dirty()
            end
            imgui.SameLine()
            local nm = eminence.name(ui, e.id)
            if e.timed then nm = t('roe.timed_mark') .. nm end
            local tgt = target_of(ui, e.id)
            local done = tgt and (tonumber(e.progress) or 0) >= tgt
            theme.TextColored(imgui, theme.col(done and 'ic_done' or 'text'), nm)
            if imgui.IsItemHovered() then
                local db = db_of(ui)
                local q = db and db.quests[e.id]
                if q and q.desc then imgui.SetTooltip(q.desc) end
            end
            imgui.SameLine()
            theme.TextColored(imgui, theme.col(done and 'ic_done' or 'ic_progress'), eminence.progress_text(ui, e))
        end
        window.pop(ui, 'child')
    end
    window.finish(ui, name, nil)
    if not open[1] and ui.set_eminence_visible then ui.set_eminence_visible(false) end
end

---------------------------------------------------------------------------
-- 本の「エミネンス」
---------------------------------------------------------------------------

-- 番号の状態：'accepted' / 'completed' / 'not_accepted'（記録がまだなら nil）
function eminence.state_of(ui, id)
    local r = R(ui)
    if not r.active then return nil end
    for _, e in ipairs(r.active) do if e.id == id then return 'accepted', e end end
    if roe.is_complete(r.complete, id) then return 'completed' end
    return 'not_accepted'
end

local function matches(ui, id, words)
    if not words then return true end
    local db = db_of(ui)
    local q = db and db.quests[id]
    local hay = util.lower(((q and q.name) or '') .. ' ' .. ((q and q.desc) or '') .. ' #' .. tostring(id))
    for _, w in ipairs(words) do
        if not hay:find(util.lower(w), 1, true) then return false end
    end
    return true
end

-- 0.1.226〜：本の「表示：」のチェック（受注中・未受注・達成）。
-- 達成オン＝全部出す。オフ＝くり返しできない達成だけ隠す（くり返しできる達成は残す）
eminence.SHOW_STATES = { 'accepted', 'not_accepted', 'completed' }

function eminence.state_shown(E, st)
    if st == 'unknown' or st == nil then st = 'not_accepted' end
    -- 達成は book_visible で、くり返しできるかを見て決める
    if st == 'completed' then return true end
    local show = E and E.book_show
    if type(show) ~= 'table' then return true end
    return show[st] ~= false
end

function eminence.show_completed(E)
    local show = E and E.book_show
    return type(show) == 'table' and show.completed == true
end

function eminence.show_sig(E)
    local show = E and E.book_show
    if type(show) ~= 'table' then return 'all' end
    local out = {}
    for _, k in ipairs(eminence.SHOW_STATES) do out[#out + 1] = (show[k] ~= false) and '1' or '0' end
    out[#out + 1] = (show.unimplemented ~= false) and '1' or '0'
    return table.concat(out)
end

-- 0.1.232〜：未実装（roe_failed why=not_impl。受注中は隠さない）
function eminence.hidden_unimplemented(ui, id)
    local E = ui and ui.settings and ui.settings.eminence
    local show = E and E.book_show
    if type(show) == 'table' and show.unimplemented == false then
        if eminence.state_of(ui, id) == 'accepted' then return false end
        local failed = ui.roe_failed and ui.roe_failed(id)
        if failed and failed.why == 'not_impl' then return true end
    end
    return false
end

-- 本で出すか（状態・達成を隠す・検索）
function eminence.book_visible(ui, id, words, opts)
    opts = opts or {}
    local E = ui.settings.eminence
    -- 未実装のチェックは件数にも効く（ignore_state でも隠す。受注中は残す）
    if eminence.hidden_unimplemented(ui, id) then return false end
    local st = eminence.state_of(ui, id)
    if not opts.ignore_state then
        if st == 'completed' then
            -- 達成オフ：くり返しできない達成だけ隠す。くり返しできる達成は残す（以前の「達成済みを非表示」と同じ）
            if not eminence.show_completed(E) then
                local db = db_of(ui)
                local q = db and db.quests and db.quests[id]
                if not (q and q.repeatable) then return false end
            end
        elseif not eminence.state_shown(E, st) then
            return false
        end
    end
    return matches(ui, id, words)
end

-- 見出しの (達成/総数)。状態・達成を隠すは無視。検索は反映（0.1.193〜）
function eminence.cat_progress(ui, ids, words)
    local done, total = 0, 0
    for _, id in ipairs(ids or {}) do
        if eminence.book_visible(ui, id, words, { ignore_state = true }) then
            total = total + 1
            if eminence.state_of(ui, id) == 'completed' then done = done + 1 end
        end
    end
    return done, total
end

-- 受けている行の文字色（0.1.193〜）：行の文字は全部青（ボタンはそのまま）
function eminence.row_ink(st, failed)
    if st == 'accepted' then return 'ic_progress' end
    if st == 'completed' or failed then return 'muted' end
    return 'text'
end

-- 分類の選択肢（0.1.182〜、t293）：先頭に「すべて」、続けていちばん上の分類だけ（下の分類は出さない）。
-- 下の分類のレコードは、いちばん上の分類に入れて出す。-1 は分類のないもの
eminence.ALL = -2
function eminence.root_choices(ui)
    local db = db_of(ui)
    local out = {}
    if not db then return out end
    out[1] = { value = eminence.ALL, label = ui.t('filter.all') }
    for _, cid in ipairs(db.roots) do
        local c = db.cats[cid]
        if c then out[#out + 1] = { value = cid, label = c.name or ('#' .. tostring(cid)) } end
    end
    if #db.loose > 0 then out[#out + 1] = { value = -1, label = ui.t('roe.loose') } end
    return out
end

-- いまの分類の根。0.1.226〜：分類の選択はなくした（左の見出しの木で選ぶ）。保存の book_root は使わない
function eminence.current_root(ui)
    return eminence.ALL
end

-- その分類と、その下の分類すべてのレコード（DAT の並び。同じ番号は一度だけ）。db ごとに覚える
local under_cache = setmetatable({}, { __mode = 'k' })
local open_cats = {}     -- 本で開け閉めした分類の見出し { [cid] = true/false }（0.1.189〜 もとに戻した。nil は開いている）
function eminence.ids_under(db, cid)
    if not db then return {} end
    local cache = under_cache[db]
    if not cache then cache = {}; under_cache[db] = cache end
    if cache[cid] then return cache[cid] end
    local out, seen_id, seen_cat = {}, {}, {}
    local function walk(c, depth)
        if seen_cat[c] or depth > 8 then return end
        seen_cat[c] = true
        for _, id in ipairs(roe.objectives_in(db, c)) do
            if not seen_id[id] then seen_id[id] = true; out[#out + 1] = id end
        end
        for _, sub in ipairs(roe.subcats(db, c)) do walk(sub, depth + 1) end
    end
    walk(cid, 0)
    cache[cid] = out
    return out
end

-- 「すべて」：いちばん上の分類の順に全部、最後に分類のないもの（同じ番号は一度だけ）
function eminence.all_ids(db)
    if not db then return {} end
    local cache = under_cache[db]
    if not cache then cache = {}; under_cache[db] = cache end
    if cache.all then return cache.all end
    local out, seen = {}, {}
    for _, cid in ipairs(db.roots) do
        for _, id in ipairs(eminence.ids_under(db, cid)) do
            if not seen[id] then seen[id] = true; out[#out + 1] = id end
        end
    end
    for _, id in ipairs(db.loose) do
        if not seen[id] and db.quests[id] then seen[id] = true; out[#out + 1] = id end
    end
    cache.all = out
    return out
end

-- 押すボタンと理由
local function action_of(ui, id)
    local st = eminence.state_of(ui, id)
    local op = (st == 'accepted') and 'remove' or 'start'
    local can, why = true, nil
    if ui.roe_can then can, why = ui.roe_can(op, id) end
    return op, can, why, st
end

-- 達成済みでくり返せないものはボタンを出さない（0.1.203〜）
function eminence.action_hidden(st, repeatable)
    return st == 'completed' and not repeatable
end

function eminence.action_visible(ui, id)
    local st = eminence.state_of(ui, id)
    local db = db_of(ui)
    local q = db and db.quests and db.quests[id]
    return not eminence.action_hidden(st, q and q.repeatable)
end

-- 見た目の印（受ける＝＋、解除＝×）。幅をそろえるために両方の字幅を測る
local function action_caption(t, op)
    if op == 'start' then return '＋ ' .. t('roe.accept') end
    return '× ' .. t('roe.remove')
end

local function action_btn_size(imgui, t)
    local w1, h1 = theme.measure_text(imgui, action_caption(t, 'start'))
    local w2, h2 = theme.measure_text(imgui, action_caption(t, 'remove'))
    local pad_x, pad_y = 16, 6
    local w = math.max(w1 or 0, w2 or 0, 56) + pad_x
    local h = math.max(h1 or 0, h2 or 0, 14) + pad_y
    if imgui.GetFrameHeight then
        local ok, v = pcall(imgui.GetFrameHeight)
        if ok and tonumber(v) and tonumber(v) > 0 then h = math.max(h, tonumber(v)) end
    end
    return w, h
end

-- 空の升の幅をそろえる（ボタンを出さないときも列がずれないように）
local function action_spacer(ui)
    local imgui, t = ui.imgui, ui.t
    local w, h = action_btn_size(imgui, t)
    if imgui.Dummy then pcall(imgui.Dummy, { w, h }) end
end

local function item_xy(imgui, getter)
    local ok, a, b = pcall(getter)
    if not ok then return nil, nil end
    if type(a) == 'table' then return tonumber(a.x or a[1]), tonumber(a.y or a[2]) end
    return tonumber(a), tonumber(b)
end

-- 受ける・解除のボタン（押したときに 1 回だけ送る）。row はキー・パッドの行
-- 0.1.203〜：受けるは塗った青緑、解除は赤い縁。どちらも同じ幅。選択枠は W.after_item で描く
local function action_button(ui, name, id, section, row)
    local t = ui.t
    local imgui = ui.imgui
    if not eminence.action_visible(ui, id) then
        action_spacer(ui)
        return false
    end
    local op, can, why = action_of(ui, id)
    local label = action_caption(t, op)
    local tip = can and t(op == 'start' and 'roe.accept_tip' or 'roe.remove_tip')
        or (ui.roe_why_text and ui.roe_why_text(why, id)) or t('roe.msg.' .. tostring(why), { name = '' })
    local key = (section == 'list') and ('roe_' .. op .. '_' .. id) or ('roed_' .. op .. '_' .. id)
    local bw, bh = action_btn_size(imgui, t)
    local focused, activated = false, false
    focused, activated = focus.item(name, key, section, row)
    if not can then
        imgui.BeginDisabled(true)
        window.push(ui, 'disabled')
    end
    local clicked
    if imgui.InvisibleButton then
        clicked = imgui.InvisibleButton(label .. '##' .. key, { bw, bh }) and true or false
    else
        clicked = imgui.Button(label .. '##' .. key, { bw, bh }) and true or false
    end
    if not can then
        window.pop(ui, 'disabled')
        clicked, activated = false, false
    end
    if tip and imgui.IsItemHovered and imgui.IsItemHovered() then imgui.SetTooltip(tip) end
    -- 見た目：地・縁・ホバー・押下、文字は影付き
    local x1, y1 = item_xy(imgui, imgui.GetItemRectMin)
    local x2, y2 = item_xy(imgui, imgui.GetItemRectMax)
    if not (x1 and y1 and x2 and y2) then
        x1, y1, x2, y2 = 0, 0, bw, bh
    end
    local hover = imgui.IsItemHovered and imgui.IsItemHovered() or false
    local pressed = imgui.IsItemActive and imgui.IsItemActive() or false
    local a = can and 1 or 0.45
    local fill, rim, rim_w
    if op == 'start' then
        local kind = pressed and 'roe_take_press' or (hover and 'roe_take_hover' or 'roe_take')
        fill, rim, rim_w = kind, 'roe_take_press', 1
    else
        -- 解除は塗りつぶさず、縁を赤くする。乗せた・押したときは薄い赤を敷く
        fill = pressed and 'roe_drop_press' or (hover and 'roe_drop_hover' or nil)
        rim, rim_w = pressed and 'roe_drop_press' or (hover and 'roe_drop_hover' or 'roe_drop'), 1.6
    end
    local dl = imgui.GetWindowDrawList and imgui.GetWindowDrawList()
    if dl then
        if fill then
            local fa = a * ((op == 'start') and 1 or (pressed and 0.55 or 0.28))
            if dl.AddRectFilled then pcall(dl.AddRectFilled, dl, { x1, y1 }, { x2, y2 }, theme.u32(fill, fa), 3) end
        end
        if dl.AddRect then pcall(dl.AddRect, dl, { x1, y1 }, { x2, y2 }, theme.u32(rim, a), 3, 0, rim_w) end
    end
    local tw, th = theme.measure_text(imgui, label)
    local tx = (x1 + x2 - (tw or 0)) / 2
    local ty = (y1 + y2 - (th or 0)) / 2
    theme.paint_text(imgui, tx, ty, label, {
        col = 'cream', shadow = true, outline = true, alpha = a,
    })
    W.after_item(ui, name, key, focused)
    if (clicked or activated) and can then
        ui.roe_send(op, id)
        return true
    end
    return false
end

-- ★ の付け外し（窓のピンと同じ）
local function fav_button(ui, name, id, section, row)
    local E = ui.settings.eminence
    local key = tostring(id)
    local on = E.pins[key] == true
    local wid = ((section == 'list') and 'roe_fav_' or 'roed_fav_') .. key
    if W.button(ui, name, wid, on and '★' or '☆', { section = section, row = row, small = true,
        tooltip = ui.t(on and 'roe.unpin' or 'roe.pin') }) then
        if on then E.pins[key] = nil else E.pins[key] = true end
        ui.mark_settings_dirty()
    end
end

-- お気に入り（0.1.182〜、t294）：♥ の絵のボタン。本だけで使い、窓には効かない（★ のピンとは別）。
-- 字の ♥ は入っていないフォントがあるので、線で描く
local function heart(dl, cx, cy, r, on)
    local col = on and theme.u32('ic_bad', 1) or theme.u32('text', 0.55)
    local s = r * 1.15
    local pts = {}
    for i = 0, 23 do
        local a = (i / 24) * math.pi * 2
        local sx = math.sin(a)
        local x = 16 * sx * sx * sx
        local y = 13 * math.cos(a) - 5 * math.cos(2 * a) - 2 * math.cos(3 * a) - math.cos(4 * a)
        pts[#pts + 1] = { cx + x * s / 17, cy - y * s / 17 - s * 0.05 }
    end
    if on and dl.AddCircleFilled then
        pcall(dl.AddCircleFilled, dl, { cx - s * 0.45, cy - s * 0.28 }, s * 0.47, col, 16)
        pcall(dl.AddCircleFilled, dl, { cx + s * 0.45, cy - s * 0.28 }, s * 0.47, col, 16)
        if dl.AddConvexPolyFilled then
            pcall(dl.AddConvexPolyFilled, dl, { { cx - s * 0.9, cy - s * 0.12 }, { cx + s * 0.9, cy - s * 0.12 }, { cx, cy + s * 0.9 } }, col)
        end
    end
    if dl.AddPolyline then pcall(dl.AddPolyline, dl, pts, col, true, 1.5) end
end

local function heart_button(ui, name, id, section, row)
    local E = ui.settings.eminence
    local key = tostring(id)
    local on = E.favs[key] == true
    local wid = ((section == 'list') and 'roe_heart_' or 'roed_heart_') .. key
    if W.icon_button(ui, name, wid, function (dl, cx, cy, r) heart(dl, cx, cy, r, on) end,
        { section = section, row = row, small = true, like = '☆', tooltip = ui.t(on and 'roe.unfav' or 'roe.fav') }) then
        if on then E.favs[key] = nil else E.favs[key] = true end
        ui.mark_settings_dirty()
    end
end
eminence._heart = heart

-- 0.1.265：SF カード用。heart_options.png の A（丸みのあるクラシックハート）。
-- 塗りは凹ポリ、無ければ左右の凸に分ける。色とオン／オフは今までどおり。
function eminence._heart_a(dl, cx, cy, r, on)
    if not dl then return end
    local col = on and theme.u32('ic_bad', 1) or theme.u32('text', 0.55)
    local s = r * 1.15
    local pts = {}
    local n = 48
    for i = 0, n - 1 do
        local a = (i / n) * math.pi * 2
        local sx = math.sin(a)
        local x = 16 * sx * sx * sx
        local y = 13 * math.cos(a) - 5 * math.cos(2 * a) - 2 * math.cos(3 * a) - math.cos(4 * a)
        pts[#pts + 1] = { cx + x * s / 17, cy - y * s / 17 - s * 0.05 }
    end
    if on then
        local filled = false
        if dl.AddConcavePolyFilled then
            filled = pcall(dl.AddConcavePolyFilled, dl, pts, col)
        end
        if not filled and dl.PathClear and dl.PathLineTo and (dl.PathFillConcave or dl.PathFillConvex) then
            local ok = pcall(function ()
                dl:PathClear()
                for _, pt in ipairs(pts) do dl:PathLineTo(pt) end
                if dl.PathFillConcave then dl:PathFillConcave(col) else dl:PathFillConvex(col) end
            end)
            filled = ok
        end
        if not filled and dl.AddConvexPolyFilled then
            local mid = math.floor(n / 2)
            local right, left = {}, {}
            for i = 1, mid + 1 do right[#right + 1] = pts[i] end
            left[#left + 1] = pts[1]
            for i = mid + 1, n do left[#left + 1] = pts[i] end
            pcall(dl.AddConvexPolyFilled, dl, right, col)
            pcall(dl.AddConvexPolyFilled, dl, left, col)
        end
    end
    if dl.AddPolyline then pcall(dl.AddPolyline, dl, pts, col, true, on and 1.2 or 1.6) end
end


-- 0.1.266：コンパクトな丸ハート。☆と同じ正方形（高さ 2r）に収まり、下の尖りは短い。
function eminence._heart_round(dl, cx, cy, r, on)
    if not dl or not r or r <= 0 then return end
    local col = on and theme.u32('ic_bad', 1) or theme.u32('text', 0.55)
    -- クラシック式の下半分を縮め、バウンディングを 2r の正方形へ正規化して中央に置く
    local raw = {}
    local n = 64
    for i = 0, n - 1 do
        local a = (i / n) * math.pi * 2
        local sx = math.sin(a)
        local x = 16 * sx * sx * sx
        local y = 13 * math.cos(a) - 5 * math.cos(2 * a) - 2 * math.cos(3 * a) - math.cos(4 * a)
        if y < 0 then y = y * 0.52 end
        raw[#raw + 1] = { x, y }
    end
    local minx, miny, maxx, maxy = raw[1][1], raw[1][2], raw[1][1], raw[1][2]
    for _, p in ipairs(raw) do
        if p[1] < minx then minx = p[1] end
        if p[1] > maxx then maxx = p[1] end
        if p[2] < miny then miny = p[2] end
        if p[2] > maxy then maxy = p[2] end
    end
    local bw, bh = maxx - minx, maxy - miny
    if bw < 0.001 then bw = 1 end
    if bh < 0.001 then bh = 1 end
    -- 高さは☆（2r）以内。幅は同じ 18px マス（r=6 のとき 3r）に少し余白を残して収める。
    local sc = math.min((r * 2 * 0.92) / bh, (r * 3 * 0.90) / bw)
    local midx, midy = (minx + maxx) * 0.5, (miny + maxy) * 0.5
    local pts = {}
    for _, p in ipairs(raw) do
        -- 式の y は上が正なので、画面座標では反転
        pts[#pts + 1] = { cx + (p[1] - midx) * sc, cy - (p[2] - midy) * sc }
    end
    if on then
        local filled = false
        if dl.AddConcavePolyFilled then
            filled = pcall(dl.AddConcavePolyFilled, dl, pts, col)
        end
        if not filled and dl.PathClear and dl.PathLineTo then
            local ok = pcall(function ()
                dl:PathClear()
                for _, pt in ipairs(pts) do dl:PathLineTo(pt) end
                if dl.PathFillConcave then dl:PathFillConcave(col)
                elseif dl.PathFillConvex then dl:PathFillConvex(col) end
            end)
            filled = ok
        end
        if not filled and dl.AddConvexPolyFilled then
            local mid = math.floor(n / 2)
            local right, left = {}, {}
            for i = 1, mid + 1 do right[#right + 1] = pts[i] end
            left[#left + 1] = pts[1]
            for i = mid + 1, n do left[#left + 1] = pts[i] end
            pcall(dl.AddConvexPolyFilled, dl, right, col)
            pcall(dl.AddConvexPolyFilled, dl, left, col)
        end
    end
    if dl.AddPolyline then pcall(dl.AddPolyline, dl, pts, col, true, on and 1.15 or 1.5) end
end

-- SF の詳細からも同じ操作を使う（見た目は先方で描く）
function eminence.action_info(ui, id)
    return action_of(ui, id)
end

function eminence.draw_actions(ui, name, id, section, row)
    fav_button(ui, name, id, section, row)
    ui.imgui.SameLine()
    heart_button(ui, name, id, section, row)
    ui.imgui.SameLine()
    action_button(ui, name, id, section, row)
end

function eminence.toggle_pin(ui, id)
    local E = ui.settings.eminence
    local key = tostring(id)
    if E.pins[key] == true then E.pins[key] = nil else E.pins[key] = true end
    if ui.mark_settings_dirty then ui.mark_settings_dirty() end
    return E.pins[key] == true
end

function eminence.toggle_fav(ui, id)
    local E = ui.settings.eminence
    local key = tostring(id)
    if E.favs[key] == true then E.favs[key] = nil else E.favs[key] = true end
    if ui.mark_settings_dirty then ui.mark_settings_dirty() end
    return E.favs[key] == true
end

function eminence.is_pinned(ui, id)
    local E = ui.settings and ui.settings.eminence
    return E and E.pins and E.pins[tostring(id)] == true
end

function eminence.is_faved(ui, id)
    local E = ui.settings and ui.settings.eminence
    return E and E.favs and E.favs[tostring(id)] == true
end



-- 本のクエスト一覧と同じ：Selectable で押し、名前は TextColored（縁取りが SmallButton とずれない）
local function hide_sel_bg(imgui)
    local n = 0
    if type(imgui.PushStyleColor) ~= 'function' then return 0 end
    for _, name in ipairs({ 'ImGuiCol_Header', 'ImGuiCol_HeaderHovered', 'ImGuiCol_HeaderActive' }) do
        if pcall(imgui.PushStyleColor, theme.C(name), { 0, 0, 0, 0 }) then n = n + 1 end
    end
    return n
end

local function name_selectable(ui, name, id, nm, color, row)
    local imgui = ui.imgui
    local wid = 'roesel_' .. id
    local focused, activated = focus.item(name, wid, 'list', row)
    local cx, cy
    if imgui.GetCursorPosX and imgui.GetCursorPosY then
        cx, cy = imgui.GetCursorPosX(), imgui.GetCursorPosY()
    end
    local hid = hide_sel_bg(imgui)
    local hid_txt = W.hide_item_text(imgui)
    local clicked = imgui.Selectable(nm .. '##' .. wid, false)
    W.show_item_text(imgui, hid_txt)
    if hid > 0 then pcall(imgui.PopStyleColor, hid) end
    if cx and cy then
        if type(imgui.SetCursorPos) == 'function' then pcall(imgui.SetCursorPos, { cx, cy })
        elseif type(imgui.SetCursorPosX) == 'function' then
            pcall(imgui.SetCursorPosX, cx); pcall(imgui.SetCursorPosY, cy)
        end
    end
    if color == 'muted' then theme.TextDisabled(imgui, nm)
    else theme.TextColored(imgui, theme.col(color), nm) end
    W.after_item(ui, name, wid, focused)
    return (clicked or activated) and true or false
end

-- 1 行：★ ♥ ［受ける］／［解除］ 名前 進み 印。名前を押す（キー・パッドで行に来る）と右に詳細
local function draw_row(ui, name, id)
    local imgui, t = ui.imgui, ui.t
    local db = db_of(ui)
    local q = db and db.quests[id]
    local st = eminence.state_of(ui, id)
    local failed = ui.roe_failed and ui.roe_failed(id)
    local row = 'r' .. id
    fav_button(ui, name, id, 'list', row)
    imgui.SameLine()
    heart_button(ui, name, id, 'list', row)
    imgui.SameLine()
    action_button(ui, name, id, 'list', row)
    imgui.SameLine()
    local nm = (q and q.name ~= '' and q.name) or ('#' .. tostring(id))
    -- 今日・今週は受けられない目標（0.1.224〜）。受けている目標は灰色にしない
    local rot, today = nil, nil
    if st ~= 'accepted' and ui.roe_rotation then rot, today = ui.roe_rotation(id) end
    local dim = (st == 'completed') or failed ~= nil or rot ~= nil
    local color = dim and 'muted' or (st == 'accepted' and 'ic_progress' or 'text')
    if sel_id == id then nm = '▶ ' .. nm end
    if name_selectable(ui, name, id, nm, color, row) then
        sel_id = id
    end
    local tags = {}
    if st == 'accepted' then
        local _, e = eminence.state_of(ui, id)
        tags[#tags + 1] = eminence.progress_text(ui, e)
    elseif q and q.target then
        tags[#tags + 1] = '/' .. tostring(q.target)
    end
    if q and q.repeatable then tags[#tags + 1] = t('roe.tag_repeat') end
    if st == 'completed' then tags[#tags + 1] = t('roe.tag_done') end
    if rot then tags[#tags + 1] = t('roe.tag_rotation.' .. tostring(rot), { today = today or '?' })
    elseif failed then tags[#tags + 1] = t('roe.tag_failed.' .. tostring(failed.why)) end
    if #tags > 0 then
        imgui.SameLine()
        theme.TextDisabled(imgui, table.concat(tags, ' '))
    end
    -- キー・パッドでこの行に来たら詳細もこの行に（0.1.228〜：マウスを乗せただけでは動かさない）
    local cur = focus.current(name)
    if cur and sel_id ~= id and focus.why and focus.why(name) == 'nav' then
        local k = tostring(id)
        if cur == 'roesel_' .. k or cur == 'roe_fav_' .. k or cur == 'roe_heart_' .. k or cur == 'roe_start_' .. k or cur == 'roe_remove_' .. k then
            sel_id = id
        end
    end
end

-- 分類の見出し（押すと開く・閉じる）。検索中はいつも開く（0.1.181 までの形を 0.1.189 で戻した、t316）
-- depth 0：選んだ分類そのもの（見出しは出さない）。depth 1〜：見出しを出し、その下にその分類のレコード、続けて下の分類。
-- 見出しは押すと閉じる・開く（前と同じ）。初めは開いている（0.1.181 までは閉じていた。見出しの下にレコードが見えるように）。
-- 0.1.189〜（t317）：行の並び（見出しの行・レコードの行）を作ってから、表（クエストの一覧と同じ見た目）で描く
local function cat_rows(ui, out, cid, words, depth, keep_children)
    local db = db_of(ui)
    local c = db and db.cats[cid]
    if not c or depth > 5 then return false end
    local ids = {}
    for _, id in ipairs(roe.objectives_in(db, cid)) do
        if eminence.book_visible(ui, id, words) then ids[#ids + 1] = id end
    end
    local subs = roe.subcats(db, cid)
    if #ids == 0 and #subs == 0 then return false end
    local book = require('src.ui.book')
    local is_open
    if words ~= nil then is_open = true
    else is_open = not book.is_collapsed(ui.settings, 'eminence', cid) end
    open_cats[cid] = is_open
    local head
    if depth > 0 then
        local done, total = eminence.cat_progress(ui, eminence.ids_under(db, cid), words)
        head = { kind = 'cat', key = cid, label = c.name, n = total, done = done, total = total, depth = depth, open = is_open }
        out[#out + 1] = head
    end
    if depth == 0 or is_open or keep_children then
        local mark = #out
        for _, id in ipairs(ids) do out[#out + 1] = { kind = 'rec', id = id, depth = depth } end
        local any_sub = false
        for _, sub in ipairs(subs) do if cat_rows(ui, out, sub, words, depth + 1, keep_children) then any_sub = true end end
        if #ids == 0 and not any_sub then
            -- 中身が全部しぼり込みで消えた見出しは出さない
            for i = #out, mark + 1, -1 do out[i] = nil end
            if head then out[#out] = nil end
            return false
        end
    end
    return true
end

-- 一覧の行（見出し・レコード）。root：すべて（ALL）／いちばん上の分類／-1 分類なし
function eminence.list_rows(ui, root, words, keep_children)
    local db = db_of(ui)
    local out = {}
    if not db then return out end
    if root == -1 then
        for _, id in ipairs(db.loose) do
            if db.quests[id] and eminence.book_visible(ui, id, words) then out[#out + 1] = { kind = 'rec', id = id, depth = 0 } end
        end
    elseif root == eminence.ALL then
        for _, cid in ipairs(db.roots) do cat_rows(ui, out, cid, words, 1, keep_children) end
        local loose = {}
        for _, id in ipairs(db.loose) do
            if db.quests[id] and eminence.book_visible(ui, id, words) then loose[#loose + 1] = id end
        end
        if #loose > 0 then
            local book = require('src.ui.book')
            local is_open = not book.is_collapsed(ui.settings, 'eminence', 'loose')
            open_cats.loose = is_open
            local all_loose = {}
            for _, id in ipairs(db.loose) do
                if db.quests[id] then all_loose[#all_loose + 1] = id end
            end
            local done, total = eminence.cat_progress(ui, all_loose, words)
            out[#out + 1] = { kind = 'cat', key = 'loose', label = ui.t('roe.loose'), n = total, done = done, total = total, depth = 1, open = is_open }
            if is_open or keep_children then
                for _, id in ipairs(loose) do out[#out + 1] = { kind = 'rec', id = id, depth = 1 } end
            end
        end
    elseif root then
        cat_rows(ui, out, root, words, 0, keep_children)
    end
    return out
end

-- 操作ツリー用：閉じた見出しの子も含める（描画の list_rows は今までどおり隠す）
function eminence.nav_rows(ui)
    return eminence.list_rows(ui, eminence.current_root(ui), nil, true)
end

-- 左の木用の分類見出し（0.1.208〜）
function eminence.heading_tree(ui)
    local db = db_of(ui)
    if not db then return {} end
    local root = eminence.current_root(ui)
    local rows = eminence.list_rows(ui, root, nil, true)
    local forest, stack = {}, {}
    for _, r in ipairs(rows) do
        if r.kind == 'cat' then
            local d = tonumber(r.depth) or 1
            local n = {
                id = r.key,
                label = r.label,
                done = r.done,
                total = r.total or r.n,
                indent = (d > 1) and ((d - 1) * 12) or 0,
                children = {},
            }
            while #stack > 0 and stack[#stack].depth >= d do stack[#stack] = nil end
            if #stack == 0 then forest[#forest + 1] = n
            else
                local p = stack[#stack].node
                p.children[#p.children + 1] = n
            end
            stack[#stack + 1] = { node = n, depth = d }
        end
    end
    return forest
end

function eminence.heading_of_record(ui, id)
    id = tonumber(id) or id
    if not id then return nil end
    local db = db_of(ui)
    if not db then return nil end
    for _, lid in ipairs(db.loose or {}) do
        if lid == id then return 'loose' end
    end
    local best
    local function walk(nodes)
        for _, n in ipairs(nodes or {}) do
            local ids = eminence.ids_under(db, n.id)
            for _, oid in ipairs(ids) do
                if oid == id then
                    best = n.id
                    walk(n.children)
                    return
                end
            end
        end
    end
    walk(eminence.heading_tree(ui))
    return best
end

function eminence.recs_for_heading(ui, heading_id, rows)
    local recs = {}
    for _, r in ipairs(rows or {}) do
        if r.kind == 'rec' then recs[#recs + 1] = r end
    end
    if not heading_id or heading_id == 'all' then return recs end
    local db = db_of(ui)
    local want = {}
    if tostring(heading_id) == 'loose' then
        for _, id in ipairs(db and db.loose or {}) do want[id] = true end
    elseif db then
        local cid = tonumber(heading_id) or heading_id
        for _, id in ipairs(eminence.ids_under(db, cid)) do want[id] = true end
    end
    local out = {}
    for _, r in ipairs(recs) do
        if want[r.id] then out[#out + 1] = r end
    end
    return out
end

-- 見出しの行のボタン（押すと開け閉め）。id は ##cat_<id> のまま（0.1.193〜：表の外、(達成/総数)、保存する）
local function cat_button(ui, name, r)
    local book = require('src.ui.book')
    local indent = (r.depth and r.depth > 1) and ((r.depth - 1) * 12) or 0
    book.section_heading(ui, name, {
        tab = 'eminence',
        id = r.key,
        label = r.label,
        done = r.done,
        total = r.total or r.n,
        widget_id = 'cat_' .. tostring(r.key),
        indent = indent,
        force_open = r.force_open,
        color = 'accent',
        section = 'list',
        row = 'c' .. tostring(r.key),
    })
end

-- 表が使えないときの形（1 行ずつ。0.1.188 までと同じ並び）
local function draw_rows_plain(ui, name, rows)
    local imgui = ui.imgui
    local level = 0
    for _, r in ipairs(rows) do
        local want = (r.kind == 'cat') and (r.depth - 1) or r.depth
        while level < want do imgui.Indent(); level = level + 1 end
        while level > want do imgui.Unindent(); level = level - 1 end
        if r.kind == 'cat' then cat_button(ui, name, r) else draw_row(ui, name, r.id) end
    end
    while level > 0 do imgui.Unindent(); level = level - 1 end
end

-- 表の列（0.1.193〜）：くり返しの列は無し。並びはドラッグで入れ替え、隠せる
-- 0.1.209〜：「状態」の列はなくした（受ける・解除のボタンで分かる。詳細の ◇◆ は残す）
eminence.COLS = { 'action', 'pin', 'fav', 'name', 'progress', 'rewards' }
eminence.table_failed = nil

function eminence.column_keys(S)
    local order = settings_mod.normalize_eminence_columns(S and S.eminence and S.eminence.columns)
    local hidden = settings_mod.normalize_eminence_hidden(S and S.eminence and S.eminence.hidden)
    local out = {}
    for _, k in ipairs(order) do
        if not hidden[k] then out[#out + 1] = k end
    end
    if #out == 0 then out[1] = 'name' end
    return out
end

function eminence.column_shown(S, key)
    local h = S and S.eminence and S.eminence.hidden
    return not (type(h) == 'table' and h[key] == true)
end

function eminence.toggle_column(S, key)
    S.eminence = S.eminence or {}
    if type(S.eminence.hidden) ~= 'table' then S.eminence.hidden = {} end
    local H = S.eminence.hidden
    if H[key] then H[key] = nil; return true end
    local shown = 0
    for _, k in ipairs(settings_mod.EMINENCE_COLUMNS) do
        if not H[k] and k ~= key then shown = shown + 1 end
    end
    if shown == 0 then return false end
    H[key] = true
    return true
end

function eminence.swap_columns(S, a, b)
    if a == b then return false end
    S.eminence = S.eminence or {}
    local order = settings_mod.normalize_eminence_columns(S.eminence.columns)
    local ia, ib
    for i, k in ipairs(order) do
        if k == a then ia = i elseif k == b then ib = i end
    end
    if not ia or not ib then return false end
    order[ia], order[ib] = order[ib], order[ia]
    S.eminence.columns = order
    return true
end

function eminence.reset_columns(S)
    S.eminence = S.eminence or {}
    local same = true
    local cur = settings_mod.normalize_eminence_columns(S.eminence.columns)
    for i, k in ipairs(settings_mod.EMINENCE_COLUMNS) do if cur[i] ~= k then same = false end end
    S.eminence.columns = settings_mod.normalize_eminence_columns(nil)
    if type(S.eminence.hidden) == 'table' and next(S.eminence.hidden) ~= nil then same = false end
    S.eminence.hidden = {}
    local book = require('src.ui.book')
    if book.reset_col_widths(S, 'eminence') then same = false end
    return not same
end

local function col_title(t, k)
    if k == 'name' then return t('book.col.name') end
    if k == 'rewards' then return t('book.col.rewards') end
    return t('roe.col.' .. k)
end

local function rect_of(imgui)
    local ok, r = pcall(function ()
        local x1, y1 = imgui.GetItemRectMin()
        local x2, y2 = imgui.GetItemRectMax()
        if type(x1) == 'table' then x1, y1 = x1.x or x1[1], x1.y or x1[2] end
        if type(x2) == 'table' then x2, y2 = x2.x or x2[1], x2.y or x2[2] end
        if x1 and y1 and x2 and y2 then return { x1, y1, x2, y2 } end
        return nil
    end)
    return ok and r or nil
end

local function union(a, b)
    if not a then return b end
    if not b then return a end
    return { math.min(a[1], b[1]), math.min(a[2], b[2]), math.max(a[3], b[3]), math.max(a[4], b[4]) }
end

-- 表で描く（タブ全体で1つの表。見出しもその中の行。0.1.207〜）。戻り値: true（描けた）
local function draw_rows_table(ui, name, rows, force_top)
    local imgui, t = ui.imgui, ui.t
    local C = theme.C
    if type(imgui.BeginTable) ~= 'function' or eminence.table_failed then return false end
    local db = db_of(ui)
    local book = require('src.ui.book')
    local S = ui.settings
    local keys = eminence.column_keys(S)
    if book.widths_look_stale(S, 'eminence', keys) then
        S.book.col_widths = S.book.col_widths or {}
        S.book.col_widths.eminence = {}
        if ui.mark_settings_dirty then ui.mark_settings_dirty() end
    end
    local flags = book.table_flags(S, 'eminence', keys)
    local depth0 = window.depth(ui)
    local ok, err = pcall(function ()
        local avail_w, avail_h = book.content_width(imgui), nil
        do
            local oka, a, b = pcall(imgui.GetContentRegionAvail)
            if oka then
                if type(a) == 'table' then avail_h = tonumber(a.y or a[2]) else avail_h = tonumber(b) end
            end
        end
        local tid = book.table_id('##astertrail_roe_table', 'eminence')
        local started, scrolling = book.begin_list_table(imgui, tid, #keys, flags, avail_w, avail_h)
        if not started then error('no_table', 0) end
        window.push(ui, 'table')
        local scale = book.list_scale(ui)
        -- 0.1.210〜：表の中（ImGui の子の窓）でも文字の倍率を決める
        window.set_font(ui, scale)
        pcall(imgui.TableSetupScrollFreeze, 0, 1)
        local ox, oy = book.table_origin(imgui)
        -- 列の幅は手で変えるだけ（0.1.211〜）
        local planned = book.plan_col_widths(S, 'eminence', keys, avail_w or book.content_width(imgui), scale)
        book.setup_planned_cols(ui, keys, planned, function (k) return col_title(t, k) end)
        book.draw_headers(ui, keys, {
            has_pin = false,
            title = function (k) return col_title(t, k) end,
            swap = eminence.swap_columns,
            reset = eminence.reset_columns,
        })
        book.apply_scroll(ui, 'eminence', force_top)
        -- 0.1.210〜：表に出すのは項目だけ（見出しは左の木）。見えている行だけ描く
        local recs = {}
        for _, r in ipairs(rows) do if r.kind == 'rec' then recs[#recs + 1] = r end end
        local force = {}
        local cur = focus.current(name)
        for i, r in ipairs(recs) do
            if r.kind == 'rec' and r.id then
                local kk = tostring(r.id)
                if cur == 'roesel_' .. kk or cur == 'roe_fav_' .. kk or cur == 'roe_heart_' .. kk
                    or cur == 'roe_start_' .. kk or cur == 'roe_remove_' .. kk then
                    force[#force + 1] = i
                end
                if sel_id == r.id then force[#force + 1] = i end
            end
        end
        book.for_clipped_rows(imgui, #recs, function (i)
            local r = recs[i]
            if not r then return end
            if r.kind == 'cat' then
                -- 0.1.208〜：見出しは左の木。表には項目だけ
                return
            end
            local id = r.id
            local q = db and db.quests[id]
            local stt = eminence.state_of(ui, id)
            local failed = ui.roe_failed and ui.roe_failed(id)
            local row = 'r' .. id
            -- 今日・今週は受けられない目標（0.1.224〜）。受けている目標は灰色にしない
            local rot, today = nil, nil
            if stt ~= 'accepted' and ui.roe_rotation then rot, today = ui.roe_rotation(id) end
            local ink = eminence.row_ink(stt, failed or rot)
            local accepted = stt == 'accepted'
            local dim = (not accepted) and (ink == 'muted')
            book.next_row(imgui)
            local row_rect
            for i, k in ipairs(keys) do
                if i > 1 then imgui.TableSetColumnIndex(i - 1) end
                if k == 'name' then
                    local nm = (q and q.name ~= '' and q.name) or ('#' .. tostring(id))
                    if sel_id == id then nm = '▶ ' .. nm end
                    local color = accepted and 'ic_progress' or (dim and 'muted' or (sel_id == id and 'accent' or 'text'))
                    if name_selectable(ui, name, id, nm, color, row) then sel_id = id end
                    -- 0.1.209〜：状態の列をなくしたので、受けられなかった印は名前の右に小さく
                    if rot then
                        pcall(imgui.SameLine, 0, 4)
                        theme.TextDisabled(imgui, t('roe.tag_rotation.' .. tostring(rot), { today = today or '?' }))
                    elseif failed then
                        pcall(imgui.SameLine, 0, 4)
                        theme.TextDisabled(imgui, t('roe.tag_failed.' .. tostring(failed.why)))
                    end
                elseif k == 'progress' then
                    local ptext = eminence.count_text(ui, id)
                    if dim then theme.TextDisabled(imgui, ptext)
                    else theme.TextColored(imgui, theme.col(accepted and 'ic_progress' or 'text'), ptext) end
                elseif k == 'rewards' then
                    local rtext = eminence.reward_text(q)
                    if accepted then theme.TextColored(imgui, theme.col('ic_progress'), rtext)
                    else theme.TextDisabled(imgui, rtext) end
                elseif k == 'pin' then
                    fav_button(ui, name, id, 'list', row)
                elseif k == 'fav' then
                    heart_button(ui, name, id, 'list', row)
                elseif k == 'action' then
                    action_button(ui, name, id, 'list', row)
                end
                row_rect = union(row_rect, rect_of(imgui))
            end
            -- 行の色（クエストの一覧と同じ：選んだ行・キー・パッドで来ている行）
            local cur2 = focus.current(name)
            local kk = tostring(id)
            local here = cur2 == 'roesel_' .. kk or cur2 == 'roe_fav_' .. kk or cur2 == 'roe_heart_' .. kk
                or cur2 == 'roe_start_' .. kk or cur2 == 'roe_remove_' .. kk
            -- 0.1.228〜：キー・パッドで移ったときだけ詳細を動かす。マウスは行のクリック（下）や名前のリンク。
            if here and sel_id ~= id and focus.why and focus.why(name) == 'nav' then sel_id = id end
            if sel_id == id or here then
                pcall(imgui.TableSetBgColor, C('ImGuiTableBgTarget_RowBg0'), theme.u32('accent', sel_id == id and 0.22 or 0.12))
            end
            -- 行のどこを押しても選ぶ（ボタンの上はボタン）
            if row_rect then
                local okm, mx, my = pcall(imgui.GetMousePos)
                if okm and type(mx) == 'table' then mx, my = mx.x or mx[1], mx.y or mx[2] end
                mx, my = tonumber(mx), tonumber(my)
                if mx and my and mx >= row_rect[1] and my >= row_rect[2] and my <= row_rect[4] and imgui.IsMouseClicked(0) then
                    local okh, any = pcall(imgui.IsAnyItemHovered)
                    if not (okh and any) then sel_id = id end
                end
            end
        end, { force = force, min = 80, key = 'eminence', scrolling = scrolling,
               sig = book.rows_sig(scale), id_of = function (i) local r = recs[i]; return r and r.id or i end })
        book.capture_col_widths(ui, 'eminence', keys)
        book.capture_scroll(ui, 'eminence')
        if ui.state then ui.state._table_scroll_captured = true end
        book.paint_col_resize_rails(ui, #keys, ox, oy)
        window.pop(ui, 'table')
        book.flush_col_resize_rails(ui)
    end)
    if not ok then
        window.unwind_to(ui, depth0)
        if err ~= 'no_table' then
            eminence.table_failed = tostring(err)
            if ui.log then ui.log('ui', 'roe table: ' .. tostring(err)) end
        end
        return false
    end
    return true
end
eminence._draw_rows_table = draw_rows_table

function eminence.draw_rows(ui, name, rows, force_top)
    local book = require('src.ui.book')
    if #rows == 0 then return end
    if eminence.table_failed or not draw_rows_table(ui, name, rows, force_top) then
        book.apply_scroll(ui, 'eminence', force_top)
        draw_rows_plain(ui, name, rows)
        book.capture_scroll(ui, 'eminence')
    end
end

function eminence.fav_ids(ui, words)
    local E = ui.settings.eminence
    local db = db_of(ui)
    local out = {}
    if not db then return out end
    for k, v in pairs(E.favs or {}) do
        local id = tonumber(k)
        if v == true and id and db.quests[id] and eminence.book_visible(ui, id, words) then out[#out + 1] = id end
    end
    table.sort(out)
    return out
end

-- 報酬の文字（DAT の数。0 のものは出さない。EMI・EXP だけ。ほかは名前が確かでないので出さない）
function eminence.reward_text(q)
    if not q or not q.rewards then return '' end
    local parts = {}
    local r = q.rewards
    if (tonumber(r.emi) or 0) > 0 then parts[#parts + 1] = tostring(r.emi) .. 'EMI' end
    if (tonumber(r.exp) or 0) > 0 then parts[#parts + 1] = tostring(r.exp) .. 'EXP' end
    return table.concat(parts, ' ')
end

-- 指定数（受けていれば 進み/目標、受けていなければ /目標。目標が分からなければ空）
function eminence.count_text(ui, id)
    local db = db_of(ui)
    local q = db and db.quests[id]
    if not q or not q.target then return '' end
    local st, e = eminence.state_of(ui, id)
    if st == 'accepted' and e then return string.format('%d/%d', tonumber(e.progress) or 0, q.target) end
    return '/' .. tostring(q.target)
end

function eminence.selected() return sel_id end
function eminence.select(id) sel_id = id end

-- 右の詳細（ゲームのエミネンスの詳細と同じ並び）
function eminence.detail(ui, name, id)
    local imgui, t = ui.imgui, ui.t
    local db = db_of(ui)
    local q = db and db.quests[id]
    if not q then W.muted(ui, t('roe.detail_hint')); return end
    local st = eminence.state_of(ui, id)
    local icon, icol = '◇', 'text'
    if st == 'accepted' then icon, icol = '◆', 'ic_progress' elseif st == 'completed' then icon, icol = '◆', 'muted' end
    theme.TextColored(imgui, theme.col(icol), icon)
    imgui.SameLine()
    W.heading(ui, (q.name ~= '' and q.name) or ('#' .. tostring(id)))
    if q.body and q.body ~= '' then W.text(ui, q.body) end
    W.sep(ui)
    local function line(label, value)
        theme.TextColored(imgui, theme.col('heading'), label)
        imgui.SameLine()
        W.text(ui, value or '')
    end
    line(t('roe.d.special'), q.special or '')
    line(t('roe.d.count'), eminence.count_text(ui, id))
    line(t('roe.d.reward'), eminence.reward_text(q))
    W.muted(ui, t(q.repeatable and 'roe.d.repeatable' or 'roe.d.not_repeatable'))
    W.sep(ui)
    fav_button(ui, name, id, 'detail', 'd')
    imgui.SameLine()
    heart_button(ui, name, id, 'detail', 'd')
    imgui.SameLine()
    action_button(ui, name, id, 'detail', 'd')
    -- 今日・今週は受けられないわけ（0.1.224〜。パッドでは説明の吹き出しが出ないので、ここに書く）
    if st ~= 'accepted' and ui.roe_rotation then
        local rot = ui.roe_rotation(id)
        if rot and ui.roe_why_text then W.muted(ui, ui.roe_why_text(rot, id)) end
    end
end

-- 検索の結果（分類によらず、番号の順。上限まで）
function eminence.search(ui, words)
    local db = db_of(ui)
    local out = {}
    if not db then return out end
    local ids = {}
    for id in pairs(db.quests) do ids[#ids + 1] = id end
    table.sort(ids)
    for _, id in ipairs(ids) do
        if eminence.book_visible(ui, id, words) then
            out[#out + 1] = id
            if #out >= eminence.SEARCH_MAX then break end
        end
    end
    return out
end

-- 検索（0.1.226〜：分類・状態の選択はなくした。分類は左の見出しの木、状態は2行目の「表示：」のチェック。
-- 本の book.draw_filters から。入らなければ次の行）
function eminence.book_filters(ui, name, row, cw1, cw2, search_w, inline)
    local imgui, t, S = ui.imgui, ui.t, ui.settings
    local E = S.eminence
    local rest = 0
    local okr, a = pcall(imgui.GetContentRegionAvail)
    if okr then rest = (type(a) == 'table' and (a.x or a[1])) or tonumber(a) or 0 end
    if not inline and rest < 140 then imgui.NewLine() end
    -- 検索
    if not search_synced then search_buf[1] = E.book_text or ''; search_synced = true end
    local sf, sa = focus.item(name, 'roe_search', 'top', row)
    if sa then imgui.SetKeyboardFocusHere(0) end
    imgui.SetNextItemWidth(search_w(rest))
    if imgui.InputTextWithHint('##astertrail_roe_search', t('roe.search_hint'), search_buf, 64) then
        E.book_text = search_buf[1] or ''
        ui.mark_settings_dirty()
    end
    ui.text_active = ui.text_active or imgui.IsItemActive()
    if (imgui.IsItemHovered() and imgui.IsMouseClicked(0)) then focus.set(name, 'roe_search') end
    if sf then
        local x1, y1 = imgui.GetItemRectMin()
        local x2, y2 = imgui.GetItemRectMax()
        theme.draw_focus(imgui, x1, y1, x2, y2, ui.reduce_motion)
    end
end

-- 本のいまの分類・検索・フィルタで見えるレコードの行（選んだものが残っているか見る用。0.1.203〜）
function eminence.book_list_rows(ui, E, db, root)
    if not db then return {}, nil, nil end
    local words = util.split_words(E.book_text or '')
    if #words == 0 then words = nil end
    local rows, empty, extra = {}, nil, nil
    if E.book_favs_only then
        local list = eminence.fav_ids(ui, words)
        if #list == 0 then empty = 'roe.empty.no_favs' end
        for _, id in ipairs(list) do rows[#rows + 1] = { kind = 'rec', id = id, depth = 0 } end
    elseif words then
        local list = eminence.search(ui, words)
        if #list == 0 then empty = 'book.empty' end
        for _, id in ipairs(list) do rows[#rows + 1] = { kind = 'rec', id = id, depth = 0 } end
        if #list >= eminence.SEARCH_MAX then extra = 'search_max' end
    else
        -- 0.1.224〜：左の木の開け閉めでは表のレコードを隠さない（木の (達成/総数) と表の行を合わせる。
        -- 前は閉じた扱いの見出しのレコードが表から消え、「共通C (1/10)」なのに表が空になっていた）
        rows = eminence.list_rows(ui, root, nil, true)
        if #rows == 0 then empty = 'book.empty' end
    end
    return rows, empty, extra
end

function eminence.book_body(ui, name)
    local imgui, t, S = ui.imgui, ui.t, ui.settings
    local E = S.eminence
    local db, why = db_of(ui), R(ui).db_why
    local root = eminence.current_root(ui)
    -- 2行目：表示（受注中・未受注・達成・お気に入りのみ）と列（出す・隠す）。検索はタブの行
    -- 「表示：」はチェックと同じ高さ（AlignTextToFramePadding）。表示と列のあいだに「｜」（0.1.200〜）
    W.frame_label(ui, t('book.view_label'), true)
    -- 0.1.226〜：受注中・未受注・達成。「達成済みを非表示」はやめた（達成オン＝全部出す、オフ＝くり返しできない達成だけ隠す）
    if type(E.book_show) ~= 'table' then E.book_show = { accepted = true, not_accepted = true, completed = false, unimplemented = true } end
    if E.book_show.unimplemented == nil then E.book_show.unimplemented = true end
    for _, k in ipairs(eminence.SHOW_STATES) do
        local label = (k == 'completed') and t('roe.state.completed') or t('state.' .. k)
        local tip = (k == 'completed') and t('roe.show_completed_tip') or t('book.show_tip')
        W.same(ui)
        if W.check_chip(ui, name, 'roe_show_' .. k, label, E.book_show[k] ~= false,
            { section = 'top', row = 'f2', tooltip = tip }) then
            E.book_show[k] = not (E.book_show[k] ~= false)
            ui.mark_settings_dirty()
        end
    end
    W.same(ui)
    if W.check_chip(ui, name, 'roe_show_unimplemented', t('state.unimplemented'), E.book_show.unimplemented ~= false,
        { section = 'top', row = 'f2', tooltip = t('roe.show_unimplemented_tip') }) then
        E.book_show.unimplemented = not (E.book_show.unimplemented ~= false)
        ui.mark_settings_dirty()
    end
    W.same(ui)
    if W.check_chip(ui, name, 'roe_favs_only', t('roe.favs_only'), E.book_favs_only == true,
        { section = 'top', row = 'f2', tooltip = t('roe.favs_only_tip') }) then
        E.book_favs_only = not E.book_favs_only
        ui.mark_settings_dirty()
    end
    W.same(ui)
    W.frame_label(ui, '｜', true)
    W.same(ui)
    W.frame_label(ui, t('book.cols_label'), true)
    for _, k in ipairs(settings_mod.EMINENCE_COLUMNS) do
        local label = col_title(t, k)
        local need_c = W.check_chip_width(imgui, label)
        imgui.SameLine()
        local rest = 0
        local okr, a = pcall(imgui.GetContentRegionAvail)
        if okr then rest = (type(a) == 'table' and (a.x or a[1])) or tonumber(a) or 0 end
        if rest > 0 and rest < need_c then imgui.NewLine() end
        if W.check_chip(ui, name, 'roe_col_' .. k, label, eminence.column_shown(S, k),
            { section = 'top', row = 'f2', tooltip = t('book.cols_tip') }) then
            if eminence.toggle_column(S, k) then ui.mark_settings_dirty() end
        end
    end
    -- 窓の出す・隠すは本の上の行のボタンだけ（0.1.182〜、t293。ここのボタンはなくした）
    -- 様子の一行（記録がまだ・送れない・受けている数）
    local r = R(ui)
    if not r.active then
        W.colored(ui, 'warn', t('roe.no_record'))
    else
        local n = ui.roe_active_count and ui.roe_active_count() or 0
        W.muted(ui, t('roe.count_line', { n = tostring(n), max = tostring(roe.MAX_ACTIVE) }))
    end
    W.sep(ui)

    -- 左：分類の木　中央：項目の表　右：詳細（0.1.208〜）
    local book = require('src.ui.book')
    local rows, empty_key, extra = eminence.book_list_rows(ui, E, db, root)
    if sel_id == nil then sel_id = tonumber(E.last_id) end
    local searching = E.book_text and E.book_text ~= ''
    local heading_id = book.current_heading(S, 'eminence')
    if searching then
        heading_id = 'all'
    else
        if heading_id == nil and sel_id and ui.state and ui.state.book_restore_scroll then
            heading_id = eminence.heading_of_record(ui, sel_id) or 'all'
            book.set_heading(S, 'eminence', heading_id, function () ui.mark_settings_dirty() end)
        end
        heading_id = heading_id or 'all'
        if heading_id ~= 'all' and #book.heading_path_ids(ui, heading_id) == 0 then
            heading_id = 'all'
            book.set_heading(S, 'eminence', heading_id, function () ui.mark_settings_dirty() end)
        end
    end
    local shown = eminence.recs_for_heading(ui, heading_id, rows)
    local visible = {}
    for _, row in ipairs(shown) do visible[#visible + 1] = row.id end
    local fallback = false
    if sel_id then
        local ok = false
        for _, id in ipairs(visible) do if id == sel_id then ok = true; break end end
        if not ok then
            -- 0.1.233〜：一覧にカーソルがあるときは見出しへ戻さず、一番近い行へ
            if book.focus_is_list(name) then
                local prev = book._shown_ids and book._shown_ids.eminence
                local nxt = book.nearest_entry(shown, sel_id, prev)
                if nxt then sel_id = nxt.id
                else sel_id = nil; fallback = true end
            else
                sel_id = nil; fallback = true
            end
        end
    end
    if E.last_id ~= sel_id then E.last_id = sel_id; ui.mark_settings_dirty() end
    book.remember_shown('eminence', shown)

    local avail_w, avail_h = imgui.GetContentRegionAvail()
    avail_w = tonumber(avail_w) or 800
    local body_h = math.max(80, (avail_h or 300) - 6)
    local tree_w, table_w, list_w = book.pane_widths(S, avail_w)
    local force_table_top = fallback or (ui.state and ui.state.book_heading_changed)
    if ui.state then ui.state.book_heading_changed = nil end

    imgui.BeginChild('##astertrail_roe_tree', { tree_w, body_h }, 1, 0)
    window.push(ui, 'child')
    window.set_font(ui, book.list_scale(ui))   -- 一覧の文字サイズ（0.1.209〜）
    book.draw_tree_pane(ui, name, book.tree_nodes(ui), heading_id, ui.state and ui.state.book_restore_tree_scroll)
    window.pop(ui, 'child')

    imgui.SameLine(0, 2)
    book.tree_splitter(ui, S, avail_w, tree_w, body_h)
    imgui.SameLine(0, 2)

    imgui.BeginChild('##astertrail_roe_list', { table_w, body_h }, 0, 0)
    window.push(ui, 'child')
    window.set_font(ui, book.list_scale(ui))   -- 一覧の文字サイズ（0.1.209〜）
    if not db then
        book.apply_scroll(ui, 'eminence', force_table_top)
        W.colored(ui, 'warn', t('roe.no_dat', { why = tostring(why or '-') }))
    else
        if empty_key then W.muted(ui, t(empty_key)) end
        if #shown > 0 then
            eminence.draw_rows(ui, name, shown, force_table_top)
        else
            book.apply_scroll(ui, 'eminence', force_table_top)
            if not empty_key then W.muted(ui, t('book.empty')) end
        end
        if extra == 'search_max' then W.muted(ui, t('roe.search_more', { n = tostring(eminence.SEARCH_MAX) })) end
        if db.cat_why then W.muted(ui, t('roe.no_cat_dat')) end
    end
    if not (ui.state and ui.state._table_scroll_captured) then
        book.capture_scroll(ui, 'eminence')
    end
    if ui.state then ui.state._table_scroll_captured = nil end
    if ui.state and ui.state.book_enter_table then
        ui.state.book_enter_table = nil
        if shown[1] then
            ui.state.book_nav_pending = 'roesel_' .. tostring(shown[1].id)
            sel_id = shown[1].id
            E.last_id = sel_id
            ui.mark_settings_dirty()
        end
    end
    -- 0.1.233〜：一覧にカーソルがあるときは見出しへ戻さない（行が無くなったときだけ）
    if fallback and (not book.focus_is_list(name) or #shown == 0) then
        focus.set(name, book.tree_wid('eminence', heading_id or 'all'), true)
    end
    window.pop(ui, 'child')

    imgui.SameLine(0, 2)
    book.splitter(ui, S, avail_w, list_w, body_h)
    imgui.SameLine(0, 2)
    imgui.BeginChild('##astertrail_roe_detail', { 0, body_h }, 1, 0)
    window.push(ui, 'child')
    window.set_font(ui, window.font_scale(ui, 'detail'))
    book.detail_anchor(ui, name)   -- 0.1.225〜（t502）：見出し → 一覧 → 詳細
    if db and sel_id and db.quests[sel_id] then
        eminence.detail(ui, name, sel_id)
    else
        W.muted(ui, t('roe.detail_hint'))
    end
    window.pop(ui, 'child')
end

function eminence.reset_search() search_synced = false end
function eminence._open_cats() return open_cats end   -- 開発用

return eminence
