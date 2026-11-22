--[[
  Astertrail - 地図の窓（SF 見た目、0.1.275〜）
  クラシック／YunaUI は map_view.lua のまま。地図画像は同梱せず、実行時に DAT を読む。
  マス目の目盛りは枠の外、線は地図の上。ズーム・パンに合わせる。列数は固定しない。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local theme = require('src.ui.theme')
local maps = require('src.core.maps')
local labels = require('src.ui.labels')
local CT = require('src.ui.colored_text')
local sf = require('src.ui.sf_style')
local exits = require('src.core.exits')
local map_view = require('src.ui.map_view')
local title_close = require('src.ui.title_close')

local map_sf = {}

-- 枠の外の目盛り帯（上の列記号・左の行番号）。マスの線とつながる。ズーム・パンに追従（0.1.277〜）
local SCALE_BAND = 24
-- 下バー（案内＋ボタン）の前フレームの高さ。地図の下端と被らないように残す（0.1.278〜）
local bar_used = 48

local function dl_of(imgui)
    local ok, dl = pcall(imgui.GetWindowDrawList)
    if ok then return dl end
    return nil
end

local function font(ui, win, mul, heading)
    local base = window.font_scale(ui, win)
    if heading then
        window.set_font(ui, base * (mul or 1), { heading = true, bold = true })
    else
        window.set_font(ui, base * (mul or 1), {})
    end
end

local function xy(v, b)
    if type(v) == 'table' then return tonumber(v.x or v[1]), tonumber(v.y or v[2]) end
    return tonumber(v), tonumber(b)
end

local function cur_xy(imgui)
    local ok, a, b = pcall(imgui.GetCursorScreenPos)
    if not ok then return nil, nil end
    if type(a) == 'table' then return tonumber(a.x or a[1]), tonumber(a.y or a[2]) end
    return tonumber(a), tonumber(b)
end

local function avail(imgui)
    return sf.avail(imgui)
end

local function learned_of(ui)
    if ui.exit_floors then
        local ok, l = pcall(ui.exit_floors)
        if ok then return l end
    end
    return nil
end

local function dat_of(ui)
    if ui.dat_floors then
        local ok, l = pcall(ui.dat_floors)
        if ok then return l end
    end
    return nil
end

local function want_dat(ui, zone_id)
    if ui.want_dat_floors and zone_id then pcall(ui.want_dat_floors, zone_id) end
end

local function loc_text(D, t, loc)
    if not loc then return t('loc.unknown') end
    return D:location_text(loc, t)
end

local function grid_alpha(ui)
    local a = ui.settings and ui.settings.map and tonumber(ui.settings.map.grid_alpha)
    if a == nil then a = 0.35 end
    if a < 0 then a = 0 elseif a > 1 then a = 1 end
    return a
end

-- 画面座標への変換（draw_image と同じ：view は 0〜1、基準は 512px）
local function to_screen_fn(view, r1, r2, r3, r4)
    view = view or { z = 1, ox = 0, oy = 0 }
    local w = (r3 - r1)
    if w <= 0 then return function () return nil end end
    local s = w / maps.BASE * (view.z or 1)
    local offx = (view.ox or 0) * maps.BASE
    local offy = (view.oy or 0) * maps.BASE
    return function (bx, by)
        local sx = r1 + (bx - offx) * s
        local sy = r2 + (by - offy) * s
        return sx, sy
    end, s
end

local function draw_grid_and_scales(imgui, layout, view, box, alpha, focus_grid)
    if not layout or alpha <= 0 then return end
    local r1, r2, r3, r4 = box[1], box[2], box[3], box[4]
    local to, scale = to_screen_fn(view, r1, r2, r3, r4)
    local dl = dl_of(imgui)
    if not dl then return end
    local line_col = theme.u32('sf_cyan', 0.22 + 0.55 * alpha)
    local edge_col = theme.u32('sf_cyan', 0.35 + 0.50 * alpha)
    local band_col = theme.u32('sf_cyan', 0.40 + 0.50 * alpha)
    local text_col = theme.u32('heading', 0.92)
    local band = SCALE_BAND
    local function clip_x(x)
        if not x then return nil end
        if x < r1 then return r1 end
        if x > r3 then return r3 end
        return x
    end
    local function clip_y(y)
        if not y then return nil end
        if y < r2 then return r2 end
        if y > r4 then return r4 end
        return y
    end
    pcall(function ()
        if dl.PushClipRect then dl:PushClipRect({ r1, r2 }, { r3, r4 }, true) end
        -- 縦線（列の境界）
        local ids = layout.col_ids
        if #ids > 0 then
            local last = ids[#ids]
            for _, i in ipairs(ids) do
                local x = to(layout.x_at(i), 0)
                if x and x >= r1 - 1 and x <= r3 + 1 then
                    dl:AddLine({ x, r2 }, { x, r4 }, line_col, 1.0)
                end
            end
            local x2 = to(layout.x_at(last) + layout.cell, 0)
            if x2 and x2 >= r1 - 1 and x2 <= r3 + 1 then
                dl:AddLine({ x2, r2 }, { x2, r4 }, edge_col, 1.0)
            end
        end
        for _, i in ipairs(layout.row_ids) do
            local _, y = to(0, layout.y_at(i))
            if y and y >= r2 - 1 and y <= r4 + 1 then
                dl:AddLine({ r1, y }, { r3, y }, line_col, 1.0)
            end
        end
        if #layout.row_ids > 0 then
            local last = layout.row_ids[#layout.row_ids]
            local _, y2 = to(0, layout.y_at(last) + layout.cell)
            if y2 and y2 >= r2 - 1 and y2 <= r4 + 1 then
                dl:AddLine({ r1, y2 }, { r3, y2 }, edge_col, 1.0)
            end
        end
        if focus_grid then
            local col, row = maps.parse_grid(focus_grid)
            if col ~= nil and row then
                local x1, y1 = to(layout.x_at(col), layout.y_at(row - 1))
                local x2, y2 = to(layout.x_at(col) + layout.cell, layout.y_at(row - 1) + layout.cell)
                if x1 and y1 and x2 and y2 then
                    dl:AddRectFilled({ x1, y1 }, { x2, y2 }, theme.u32('sf_cyan', 0.20), 0)
                    dl:AddRect({ x1, y1 }, { x2, y2 }, theme.u32('sf_cyan', 0.90), 0, 0, 1.4)
                end
            end
        end
        if dl.PopClipRect then dl:PopClipRect() end

        -- 上の列記号帯・左の行番号帯：枠の外、マスの線とつながる仕切り、ラベルはマスの中央（0.1.277〜）
        local by1, by2 = r2 - band, r2
        local lx1, lx2 = r1 - band, r1
        -- 左上の角
        dl:AddRect({ lx1, by1 }, { r1, r2 }, band_col, 0, 0, 1.1)

        if #ids > 0 then
            if dl.PushClipRect then dl:PushClipRect({ r1, by1 - 1 }, { r3, r2 + 1 }, true) end
            local x_first = clip_x(to(layout.x_at(ids[1]), 0))
            local x_last = clip_x(to(layout.x_at(ids[#ids]) + layout.cell, 0))
            if x_first and x_last and x_last > x_first then
                dl:AddRect({ x_first, by1 }, { x_last, by2 }, band_col, 0, 0, 1.2)
            end
            for _, i in ipairs(ids) do
                local xa = to(layout.x_at(i), 0)
                local xb = to(layout.x_at(i) + layout.cell, 0)
                if xa and xb then
                    local cxa, cxb = clip_x(xa), clip_x(xb)
                    if cxa and cxb and cxb > cxa then
                        dl:AddLine({ cxa, by1 }, { cxa, by2 }, band_col, 1.0)
                    end
                end
            end
            local xe = clip_x(to(layout.x_at(ids[#ids]) + layout.cell, 0))
            if xe then dl:AddLine({ xe, by1 }, { xe, by2 }, band_col, 1.0) end
            if dl.PopClipRect then dl:PopClipRect() end
            for k, i in ipairs(ids) do
                local letter = layout.letters:sub(k, k)
                if letter and letter ~= '' then
                    local xa = to(layout.x_at(i), 0)
                    local xb = to(layout.x_at(i) + layout.cell, 0)
                    local cx = to(layout.x_center(i), 0)
                    if cx and xa and xb then
                        -- マスが枠の横幅と少しでも重なるときだけ
                        if xb > r1 and xa < r3 and cx >= r1 and cx <= r3 then
                            local tw, th = theme.measure_text(imgui, letter)
                            tw, th = tonumber(tw) or 6, tonumber(th) or 14
                            sf.add_text(dl, cx - tw * 0.5, (by1 + by2) * 0.5 - th * 0.5, text_col, letter)
                        end
                    end
                end
            end
        end

        if #layout.row_ids > 0 then
            if dl.PushClipRect then dl:PushClipRect({ lx1 - 1, r2 }, { r1 + 1, r4 }, true) end
            local y_first = clip_y(select(2, to(0, layout.y_at(layout.row_ids[1]))))
            local last_r = layout.row_ids[#layout.row_ids]
            local y_last = clip_y(select(2, to(0, layout.y_at(last_r) + layout.cell)))
            if y_first and y_last and y_last > y_first then
                dl:AddRect({ lx1, y_first }, { lx2, y_last }, band_col, 0, 0, 1.2)
            end
            for _, i in ipairs(layout.row_ids) do
                local _, ya = to(0, layout.y_at(i))
                local cya = clip_y(ya)
                if cya then
                    dl:AddLine({ lx1, cya }, { lx2, cya }, band_col, 1.0)
                end
            end
            local _, ye = to(0, layout.y_at(last_r) + layout.cell)
            local cye = clip_y(ye)
            if cye then dl:AddLine({ lx1, cye }, { lx2, cye }, band_col, 1.0) end
            if dl.PopClipRect then dl:PopClipRect() end
            for _, row in ipairs(layout.rows) do
                local i = row - 1
                local _, ya = to(0, layout.y_at(i))
                local _, yb = to(0, layout.y_at(i) + layout.cell)
                local _, cy = to(0, layout.y_center(i))
                if cy and ya and yb and yb > r2 and ya < r4 and cy >= r2 and cy <= r4 then
                    local lab = tostring(row)
                    local tw, th = theme.measure_text(imgui, lab)
                    tw, th = tonumber(tw) or 8, tonumber(th) or 14
                    sf.add_text(dl, (lx1 + lx2) * 0.5 - tw * 0.5, cy - th * 0.5, text_col, lab)
                end
            end
        end
    end)
end

local function collect(ui)
    local t, st = ui.t, ui.state
    local info = st.map
    if not info then return nil end
    local D, P = ui.data, ui.progress
    local q = info.quest and D:quest(info.quest)
    local loc, step = maps.location_for(D, P, q, info.step)
    if info.loc then loc = info.loc end
    local a0 = info.arrive
    if loc and info.arrive_pending and a0 and tonumber(a0.zone_id) == tonumber(loc.zone_id) then
        local mn = exits.map_n_of(D, maps, learned_of(ui), loc.zone_id, a0.x, a0.y, dat_of(ui))
        if mn then
            if info.map_n ~= mn then info.view = nil end
            info.map_n = mn
            info.arrive_pending = nil
        end
    end
    local floor, reason
    if loc then
        floor, reason = maps.pick_floor(D, loc, info.map_n)
        if floor and info.map_n == nil then info.map_n = floor.map_n end
    end
    local list = loc and maps.floors(D, loc.zone_id) or {}
    local here_n = nil
    local cur = st.floor
    if cur and loc and cur.map_n and tonumber(cur.zone_id) == tonumber(loc.zone_id)
        and ui.player and tonumber(ui.player.zone_id) == tonumber(loc.zone_id) then
        here_n = cur.map_n
    end
    info.view = info.view or { z = 1, ox = 0, oy = 0 }
    local pin, cands = map_view.step_pin(ui, D, floor, loc, step, info.loc)
    local talk_pins = map_view.talk_pins(ui, D, floor, loc, step, info.loc)
    local on_dest = maps.dest_on_floor(floor, loc, #list)
    if pin and not on_dest then pin = nil end
    if cands and not on_dest then cands = nil end
    if not on_dest then talk_pins = {} end
    if #talk_pins > 0 then
        pin = talk_pins[1]
        cands = nil
    end
    local me = maps.player_pin(floor, ui.player, loc)
    local here_other = nil
    if me and here_n and #list > 1 and floor and floor.map_n ~= here_n then
        me = nil
        here_other = here_n
    end
    local ov = { t = (ui.state and ui.state.now) or os.clock(), reduce = ui.reduce_motion,
                 heading = ui.player and tonumber(ui.player.heading) or nil, exits = {}, cands = cands,
                 quest_pins = (#talk_pins > 0) and talk_pins or nil }
    local learned, dat, unplaced = learned_of(ui), dat_of(ui), 0
    if floor and loc and loc.zone_id then
        if #list > 1 then want_dat(ui, loc.zone_id) end
        for _, e in ipairs(exits.of(D, loc.zone_id)) do
            local mn = exits.map_n_of(D, maps, learned, loc.zone_id, e.x, e.y, dat)
            if mn == nil then
                unplaced = unplaced + 1
            elseif mn == floor.map_n then
                local bx, by = maps.world_px(floor, e.x, e.y)
                if bx then
                    ov.exits[#ov.exits + 1] = { base_x = bx, base_y = by, to = e.to, exit = e,
                        name = D:zone_name(e.to) }
                end
            end
        end
        local a = info.arrive
        if a and tonumber(a.zone_id) == tonumber(loc.zone_id)
            and exits.map_n_of(D, maps, learned, loc.zone_id, a.x, a.y, dat) == floor.map_n then
            local bx, by = maps.world_px(floor, a.x, a.y)
            if bx then
                if a.pulse_at == nil then a.pulse_at = ov.t end
                ov.arrive = { base_x = bx, base_y = by, age = ov.t - a.pulse_at }
            end
        end
    end
    local mobs, mob_why
    if info.mob and loc and loc.zone_id then
        mobs, mob_why = map_view.find_mobs(ui, info, loc.zone_id)
        if mobs and floor and me then
            ov.mobs = {}
            for _, m in ipairs(mobs) do
                local bx, by = maps.world_px(floor, m.x, m.y)
                if bx then ov.mobs[#ov.mobs + 1] = { base_x = bx, base_y = by } end
            end
        end
    end
    return {
        t = t, D = D, P = P, q = q, loc = loc, step = step, info = info,
        floor = floor, reason = reason, list = list, here_n = here_n,
        pin = pin, cands = cands, talk_pins = talk_pins, me = me, here_other = here_other,
        ov = ov, unplaced = unplaced, mobs = mobs, mob_why = mob_why, on_dest = on_dest,
    }
end

local function target_rows(ui, sc)
    local t, D, P, loc, floor, q, info = sc.t, sc.D, sc.P, sc.loc, sc.floor, sc.q, sc.info
    local rows, seen = {}, {}
    local function add(nm, grid, pin, extra)
        if not nm or nm == '' then return end
        local key = tostring(nm) .. '\t' .. tostring(grid or '')
        if seen[key] then return end
        seen[key] = true
        local r = { name = nm, grid = grid, pin = pin }
        if extra then for k, v in pairs(extra) do r[k] = v end end
        rows[#rows + 1] = r
    end
    if q and sc.talk_pins and #sc.talk_pins > 0 then
        for _, p in ipairs(sc.talk_pins) do
            local nm = p.name
            if (not nm or nm == '') and p.target and D.target_name then nm = D:target_name(p.target) end
            add(nm or labels.qname(q), p.grid, p, { step = info.step, current = true })
        end
    elseif q and sc.pin then
        local nm = sc.step and sc.step.target and D.target_name and D:target_name(sc.step.target)
        add(nm or labels.qname(q), sc.pin.grid or maps.grid_name(sc.pin.base_x, sc.pin.base_y), sc.pin, { step = info.step, current = true })
    end
    if q and not info.loc then
        for _, c in ipairs(map_view.target_choices(D, q, info.step, t) or {}) do
            if c.value ~= info.step then
                local loc2, step2 = maps.location_for(D, P, q, c.value)
                if loc and loc2 and loc2.zone_id == loc.zone_id then
                    local p2 = map_view.step_pin(ui, D, floor, loc2, step2, nil)
                    local g = p2 and (p2.grid or maps.grid_name(p2.base_x, p2.base_y))
                    add(c.label, g, p2, { step = c.value })
                else
                    add(c.label, nil, nil, { step = c.value })
                end
            end
        end
    end
    if P and P.pinned_list and D and loc then
        for _, qid in ipairs(P:pinned_list()) do
            if not (q and qid == q.id) then
                local pq = D:quest(qid)
                if pq then
                    local loc2, step2 = maps.location_for(D, P, pq, nil)
                    if loc2 and tonumber(loc2.zone_id) == tonumber(loc.zone_id) then
                        local p2, _ = map_view.step_pin(ui, D, floor, loc2, step2, nil)
                        if p2 then
                            add(labels.qname(pq), p2.grid or maps.grid_name(p2.base_x, p2.base_y), p2, {
                                quest = qid, step = step2 and step2.id, pinned = true,
                            })
                        end
                    end
                end
            end
        end
    end
    return rows
end

local function legend_lines(ui, sc)
    local t, info = sc.t, sc.info
    local lines = {}
    local function add(col, text)
        if text and text ~= '' then lines[#lines + 1] = { col = col, text = text } end
    end
    if info.browse then
        if info.arrive and sc.ov.arrive then add('zone', t('map.arrive_legend'))
        elseif info.arrive then add('muted', t('map.arrive_unknown')) end
    elseif sc.pin and sc.pin.kind == 'live' then add('muted', t('map.live_pin'))
    elseif sc.cands then add('muted', t('map.cand_pin', { n = tostring(#sc.cands) }))
    elseif sc.pin and sc.pin.kind == 'grid' then add('muted', t('map.grid_pin'))
    elseif sc.pin and sc.pin.kind == 'pos' then add('muted', t('map.pos_pin'))
    elseif sc.loc and sc.loc.zone_id and not sc.pin then
        local want = maps.wanted_map(sc.loc)
        if want and sc.floor and sc.floor.map_n ~= want then
            add('muted', t('map.dest_on_other', { n = tostring(want) }))
        elseif not want and #sc.list > 1 and (sc.loc.grid or (sc.loc.pos and sc.loc.pos.x)) then
            add('muted', t('map.dest_map_unknown'))
        else
            add('muted', t('map.no_pin'))
        end
    end
    if sc.me and not sc.me.off then
        if sc.me.grid then add('player', t('map.legend_here', { grid = sc.me.grid }))
        else add('player', t('map.you_are_here')) end
    elseif sc.me and sc.me.off then add('muted', t('map.you_off'))
    elseif sc.here_other then add('muted', t('map.you_on_other', { n = tostring(sc.here_other) })) end
    local dest = sc.pin and (sc.pin.grid or maps.grid_name(sc.pin.base_x, sc.pin.base_y))
    if dest then add('pin', t('map.legend_dest', { grid = dest })) end
    if info.mob then
        if sc.mob_why == 'other_zone' then add('muted', t('map.mob_other_zone'))
        elseif sc.mobs and #sc.mobs > 0 then
            local d = sc.mobs[1].dist
            add('mob', t(d and 'map.mob_found_dist' or 'map.mob_found',
                { n = tostring(#sc.mobs), d = d and string.format('%d', math.floor(d + 0.5)) or '' }))
            if not (sc.ov.mobs and #sc.ov.mobs > 0) then add('muted', t('map.mob_on_other')) end
        elseif sc.mobs then add('muted', t('map.mob_none')) end
    end
    if sc.unplaced > 0 then add('muted', t('map.exits_unplaced')) end
    return lines
end

local function pan_to(view, bx, by)
    if not view or bx == nil or by == nil then return end
    local span = 1 / (view.z or 1)
    view.ox = (bx / maps.BASE) - span * 0.5
    view.oy = (by / maps.BASE) - span * 0.5
    map_view.clamp_view(view)
end

local function tab_chip(ui, win, id, label, on, x, y)
    local imgui = ui.imgui
    font(ui, win, 0.86, true)
    local tw, th = theme.measure_text(imgui, label)
    tw, th = tw or 40, th or 16
    local w, h = tw + 20, th + 10
    if x and y then sf.set_cursor(imgui, x, y) end
    local clicked = sf.hit(imgui, '##sffloor_' .. id, w, h)
    local x1, y1, x2, y2 = sf.item_rect(imgui)
    if x1 then
        -- 少し斜めのタブ（モックに近い）
        local shear = 6
        local dl = dl_of(imgui)
        if dl then
            pcall(function ()
                local pts = { { x1 + shear, y1 }, { x2 + 2, y1 }, { x2 - 2, y2 }, { x1, y2 } }
                local fill = on and theme.u32('sf_cyan', 0.28) or theme.u32('bg', 0.35)
                local line = on and theme.u32('sf_cyan', 1.0) or theme.u32('sf_cyan', 0.35)
                if dl.AddConvexPolyFilled then dl:AddConvexPolyFilled(pts, fill) end
                if dl.AddPolyline then dl:AddPolyline(pts, line, true, on and 1.8 or 1.1) end
            end)
        end
        sf.add_heading(imgui, x1 + 10, y1 + 5, theme.u32(on and 'heading' or 'muted', 1), label, 'label')
    end
    font(ui, win, 1, false)
    return clicked, w, h
end

local function map_hint_lines(ui, sc, has_image)
    local t = ui.t
    local lines = {}
    if sc.reason == 'unknown_map' then
        lines[#lines + 1] = { 'warn', t('map.map_unknown') }
    elseif sc.reason == 'unconfirmed' then
        lines[#lines + 1] = { 'warn', t('map.unconfirmed') }
    elseif sc.reason == 'no_map' and sc.loc then
        lines[#lines + 1] = { 'warn', t('map.no_map') }
    elseif sc.floor and sc.floor.file_id and not has_image then
        lines[#lines + 1] = { 'muted', t('map.no_image') }
    end
    return lines
end

local function hint_block_h(imgui, lines, wrap_w)
    local h = 0
    for _, ln in ipairs(lines or {}) do
        local tw, th = theme.measure_text(imgui, ln[2], wrap_w)
        tw, th = tonumber(tw) or wrap_w, tonumber(th) or 16
        if wrap_w and wrap_w > 0 and tw > wrap_w and (not th or th <= 18) then
            th = math.ceil(tw / wrap_w) * 16
        end
        h = h + math.max(16, th) + 2
    end
    return h
end

function map_sf.draw(ui)
    local t, imgui = ui.t, ui.imgui
    local st = ui.state
    local info = st.map
    if not info then ui.close_window('map'); return end
    local name = 'map'
    local open = { true }
    local sc0 = collect(ui)
    local loc = sc0 and sc0.loc
    local title = (loc and loc.zone_name) or t('map.title')
    local drawing = window.begin(ui, name, {
        title = title, open = open, operable = true, no_title = true, sf_frame = true,
    })
    if drawing then
        -- 待ち／読み取り専用などの案内は下バーの行へ出す（上に出すと下のボタンと重ならないが、地図の高さがずれる）
        local sc = collect(ui) or sc0
        info, loc = sc.info, sc.loc
        local aw, ah = avail(imgui)
        aw, ah = aw or 500, ah or 600
        local hx, hy = title_close.header_origin(imgui)
        hx, hy = hx or 0, hy or 0
        sf.set_cursor(imgui, hx, hy)

        -- 右ペインは幅が足りるときだけ横へ。狭ければ下へ（窓サイズは変えない）
        local right_w = 0
        if aw >= 560 then right_w = math.max(160, math.min(240, math.floor(aw * 0.30))) end
        local gap, gutter, head_h = 10, SCALE_BAND + 4, 40
        local wrap_w = math.max(80, aw - 8)
        local file_id0 = sc.floor and sc.floor.file_id
        local has_img = false
        if file_id0 and ui.load_map_image then
            local img0 = select(1, ui.load_map_image(file_id0))
            has_img = img0 and img0.tex and true or false
        end
        local hints = map_hint_lines(ui, sc, has_img)
        local hint_h = hint_block_h(imgui, hints, wrap_w)
        local btn_h = 28
        if imgui.GetFrameHeightWithSpacing then
            local okf, fh = pcall(imgui.GetFrameHeightWithSpacing)
            if okf then btn_h = math.max(24, tonumber(fh) or btn_h) end
        end
        -- 地図枠・左の目盛り帯の下端とバーがぶつからない隙間。案内があればその分だけバーを高くする
        local gap_bar = 10
        local bot_h = gap_bar + (hint_h > 0 and (hint_h + 6) or 0) + btn_h + 8
        if (bar_used or 0) > bot_h then bot_h = bar_used end
        local map_w = aw - (right_w > 0 and (right_w + gap) or 0)
        local map_h = ah - head_h - bot_h - ((right_w == 0) and 120 or 0)
        local inner = math.max(160, math.min(map_w - gutter - 8, map_h - gutter - 8))

        -- ゾーン名（日本語の白。Melete にはしない）。幅は今の字体で測り、階タブはその右へ（0.1.277〜）
        -- 右上の × は見出し行の最後に出し、階タブは × の左までに収める（0.1.283〜）
        local title_s = (loc and loc.zone_name) or t('map.title')
        font(ui, name, 1.28, false)
        local nw = select(1, theme.measure_text(imgui, title_s)) or 80
        theme.TextColored(imgui, theme.col('heading'), title_s)
        font(ui, name, 1, false)
        -- 階タブ
        local list = sc.list or {}
        local tab_limit = title_close.right_limit(imgui, '×')
        if #list > 0 then
            -- 測ったタイトル幅 + 隙間のあとから置く（重ならない）
            local fx, fy = hx + nw + 16, hy + 4
            for _, f in ipairs(list) do
                local lab = t('map.floor', { n = tostring(f.map_n) })
                if sc.here_n and sc.here_n == f.map_n and #list > 1 then lab = lab .. t('map.floor_here') end
                if tab_limit and fx >= tab_limit then break end
                local clicked, tw, th = tab_chip(ui, name, tostring(f.map_n), lab, info.map_n == f.map_n, fx, fy)
                if clicked then
                    if info.map_n ~= f.map_n then info.view = nil end
                    info.map_n = f.map_n
                    info.arrive_pending = nil
                end
                fx = fx + tw + 8
            end
        end
        if title_close.draw(ui, name, {
            tooltip = t('common.close'), origin_x = hx, origin_y = hy,
        }) then
            open[1] = false
            ui.close_window('map')
        end
        sf.set_cursor(imgui, hx, hy + head_h)

        -- 地図枠と目盛り用の余白
        local mx, my = cur_xy(imgui)
        mx, my = mx or hx, my or (hy + head_h)
        local frame_x, frame_y = mx + gutter, my + gutter
        local frame_r, frame_b = frame_x + inner, frame_y + inner
        sf.frame(dl_of(imgui), frame_x - 2, frame_y - 2, frame_r + 2, frame_b + 2, {
            cut = 6, fill_a = 0.08, line_a = 0.90, line = theme.u32('sf_cyan', 0.90),
            brackets = true, bracket_len = 10, glow = 0, thick = 1.4, band = false,
        })
        sf.set_cursor(imgui, frame_x, frame_y)

        local shown_image, hot, clicked, hover_at = false, nil, false, nil
        local file_id = sc.floor and sc.floor.file_id
        local img
        if file_id and ui.load_map_image then
            img = select(1, ui.load_map_image(file_id))
        end
        if img and img.tex then
            shown_image, hot, clicked, hover_at = map_view._draw_image_for_test(
                imgui, img.tex, img.width, img.height, inner, sc.pin, sc.me, info.view, sc.ov)
        end
        if not shown_image then
            -- 画像が無いときも、同じ換算のマス目（枠の中）
            local ok = pcall(function ()
                imgui.Dummy({ inner, inner })
            end)
            shown_image = false
        end
        local layout = maps.grid_layout(sc.floor, {
            image_w = img and img.width, image_h = img and img.height,
        })
        draw_grid_and_scales(imgui, layout, info.view, { frame_x, frame_y, frame_r, frame_b },
            grid_alpha(ui), info.focus_grid)
        if not (img and img.tex) then
            -- 方眼の下地
            local dl = dl_of(imgui)
            if dl then
                pcall(function ()
                    dl:AddRectFilled({ frame_x, frame_y }, { frame_r, frame_b }, theme.u32('bg', 0.70), 2)
                end)
            end
            -- ピンだけ重ねる（画像パスと同じオーバーレイを簡易に）
            if map_view._draw_image_for_test then
                -- 既に Dummy 済み。ピンは grid のとき map_view.draw_grid 相当が無いので、
                -- 不可視のまま to_screen でオーバーレイしたいが、既存の draw_grid はズームしない。
                -- ここでは線と目盛りを優先し、ピンは to_screen で最小限。
            end
        end
        -- 0.1.301〜：画像が無いときも、枠の中に乗せた所をマスの名前に使う
        if not hover_at and not (img and img.tex) then
            local mok, mx0, my0 = pcall(function () return xy(imgui.GetMousePos()) end)
            local okh, wh = pcall(function () return imgui.IsWindowHovered and imgui.IsWindowHovered() end)
            if mok and mx0 and my0 and okh and wh and mx0 >= frame_x and mx0 <= frame_r and my0 >= frame_y and my0 <= frame_b then
                local v = info.view or { z = 1, ox = 0, oy = 0 }
                local s0 = (frame_r - frame_x) / maps.BASE * (v.z or 1)
                if s0 > 0 then
                    hover_at = { bx = (v.ox or 0) * maps.BASE + (mx0 - frame_x) / s0, by = (v.oy or 0) * maps.BASE + (my0 - frame_y) / s0 }
                end
            end
        end
        if hot then
            pcall(function ()
                imgui.BeginTooltip()
                theme.Text(imgui, t('map.exit_tip', { zone = hot.name or tostring(hot.to) }))
                imgui.EndTooltip()
            end)
            if clicked then map_view.go(ui, hot.exit) end
        else
            map_view.grid_tip(ui, hover_at, layout)
        end
        -- 下バー：案内はボタンの上の独立した行。幅で折り返し、高さを確保する（0.1.278〜）
        -- 目盛り帯は枠の外（下端は frame_b）まで。バーは gap_bar だけ離す
        local by = frame_b + gap_bar
        sf.set_cursor(imgui, mx, by)
        ui.status_line()
        for _, ln in ipairs(hints) do
            if ln[1] == 'muted' then
                CT.wrapped(ui, ln[2], 'muted', nil, wrap_w)
            else
                CT.wrapped(ui, ln[2], ln[1], nil, wrap_w)
            end
        end
        local _, after_hint = cur_xy(imgui)
        if after_hint and after_hint > by then
            sf.set_cursor(imgui, mx, after_hint + 4)
        end
        -- 下バー：戻る（履歴があるときだけ。クラシックと同じ）／現在地／ZOOM ±／右寄せの閉じる
        if info.back and #info.back > 0 then
            if W.button(ui, name, 'nav_back', t('map.back'), { section = 'nav', row = 'n', small = true }) then
                map_view.go_back(ui)
            end
            W.same(ui)
        end
        if ui.player and ui.player.zone_id then
            if W.button(ui, name, 'nav_here', t('map.here'), { section = 'nav', row = 'n', small = true }) then
                map_view.go_here(ui)
            end
            W.same(ui)
        end
        font(ui, name, 0.80, true)
        if W.button(ui, name, 'zoom_in', (ui.t and ui.t('map.zoom_in')) or 'ZOOM +',
            { section = 'nav', row = 'z', small = true }) then
            map_view.zoom_at(info.view, 1, 0.5, 0.5)
        end
        W.same(ui)
        if W.button(ui, name, 'zoom_out', 'ZOOM −', { section = 'nav', row = 'z', small = true }) then
            map_view.zoom_at(info.view, -1, 0.5, 0.5)
        end
        font(ui, name, 1, false)
        if info.view.z and info.view.z > 1 then
            W.same(ui)
            if W.button(ui, name, 'zoom_reset', t('map.zoom_reset', { z = string.format('%.1f', info.view.z) }),
                { section = 'nav', row = 'z', small = true }) then
                info.view = { z = 1, ox = 0, oy = 0 }
            end
        end
        -- 閉じるは地図列の下バー右端（0.1.281〜）。窓全体の右端に置くと、あとから出す右ペインの子窓に重なり、押せない
        W.same(ui)
        do
            local close_lab = t('common.close')
            local cw = (tonumber((theme.measure_text(imgui, close_lab))) or 40) + 24
            local bx, bys = cur_xy(imgui)
            local col_r = (mx or 0) + math.max(80, (right_w > 0) and map_w or (aw or 200)) - 4
            if bx and bys and col_r - cw > bx + 8 then
                sf.set_cursor(imgui, col_r - cw, bys)
            end
            if W.button(ui, name, 'close', close_lab, { section = 'footer', row = 'f', small = true }) then
                open[1] = false
                if ui.close_window then ui.close_window('map') end
            end
        end
        local _, bar_bottom = cur_xy(imgui)
        if bar_bottom and frame_b then
            local bh = (bar_bottom - frame_b) + 8
            if imgui.GetItemRectMax then
                local okm, a, b = pcall(imgui.GetItemRectMax)
                local y2
                if okm then
                    if type(a) == 'table' then y2 = tonumber(a.y or a[2])
                    else y2 = tonumber(b) end
                end
                if y2 then bh = math.max(bh, (y2 - frame_b) + 8) end
            end
            bar_used = math.max(48, math.floor(bh + 0.5))
        end

        -- 右（または下）のターゲット／凡例
        local rx, ry, rw, rh
        if right_w > 0 then
            rx, ry = frame_r + gap + 8, my
            -- 高さは下バーより上まで（バーの閉じると重ならない）
            rw, rh = right_w - 8, math.max(40, (by or frame_b) - my)
        else
            rx, ry = mx, by + bot_h
            rw, rh = aw - 8, math.max(80, hy + ah - (by + bot_h) - 8)
        end
        if rx and rw and rw > 40 then
            sf.set_cursor(imgui, rx, ry)
            local okp = pcall(imgui.BeginChild, '##astertrail_sf_map_side', { rw, math.max(40, rh) }, 0, 0)
            if okp then window.push(ui, 'child') end
            font(ui, name, 0.78, true)
            theme.TextColored(imgui, theme.col('sf_cyan'), ui.t and ui.t('map.targets') or 'ターゲット')
            font(ui, name, 1, false)
            if sc.q then
                theme.TextColored(imgui, theme.col('accent'), labels.qname(sc.q))
                if sc.step and (sc.step.next_line_ja or sc.step.order) then
                    W.muted(ui, string.format('%s %s',
                        sc.step.order and (tostring(sc.step.order) .. '.') or '',
                        sc.step.next_line_ja or ''))
                end
            end
            if sc.info.mob and sc.info.mob.name then
                W.ctext(ui, t('map.mob_target', { name = sc.info.mob.name }), CT.add({}, sc.info.mob.name, 'mob'))
            end
            for i, row in ipairs(target_rows(ui, sc)) do
                local lab = row.name
                if row.grid and row.grid ~= '' then lab = lab .. '  ' .. row.grid end
                local on = (info.focus_grid and row.grid == info.focus_grid) or (row.current and not info.focus_grid)
                if W.button(ui, name, 'tg_' .. tostring(i), lab, {
                    section = 'target', row = 't' .. i, small = true,
                }) then
                    if row.step and sc.q and not info.loc then
                        info.step = row.step
                        info.map_n = nil
                        -- 表示中の地図は維持しつつ強調
                    end
                    info.focus_grid = row.grid
                    if row.pin and row.pin.base_x then
                        pan_to(info.view, row.pin.base_x, row.pin.base_y)
                    end
                end
            end
            imgui.Dummy({ 1, 10 })
            font(ui, name, 0.78, true)
            theme.TextColored(imgui, theme.col('sf_cyan'), ui.t and ui.t('map.legend') or '凡例')
            font(ui, name, 1, false)
            for _, ln in ipairs(legend_lines(ui, sc)) do
                if ln.col == 'muted' then W.muted(ui, ln.text)
                else W.colored(ui, ln.col, ln.text) end
            end
            if okp then window.pop(ui, 'child') end
        end

        sf.set_cursor(imgui, hx, hy + ah - 2)
    end
    window.finish(ui, name, nil)
    if not open[1] and st.open.map then ui.close_window('map') end
end

return map_sf
