--[[
  Astertrail - 詳細だけの窓（SF 見た目、0.1.283〜）
  本の右側（book_sf.draw_detail）と同じ中身。クラシック／YunaUI は detail.lua のまま。
  見出し行の右上に ×。本文は見出しの下の子窓に入れ、× を覆わない。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local theme = require('src.ui.theme')
local sf = require('src.ui.sf_style')
local title_close = require('src.ui.title_close')
local book_sf = require('src.ui.book_sf')

local detail_win_sf = {}

local function font(ui, mul, heading)
    local base = window.font_scale(ui, 'detail')
    if heading then
        window.set_font(ui, base * (mul or 1), { heading = true, bold = true })
    else
        window.set_font(ui, base * (mul or 1), {})
    end
end

function detail_win_sf.draw(ui)
    local t, imgui = ui.t, ui.imgui
    local st = ui.state
    local qid = st.detail_quest
    local q = qid and ui.data:quest(qid)
    local name = 'detail'
    if not q then ui.close_window(name); return end
    local P = ui.progress
    local open = { true }
    local drawing = window.begin(ui, name, {
        title = t('detail.title'), open = open, operable = true,
        no_title = true, sf_frame = true,
    })
    if drawing then
        local hx, hy = title_close.header_origin(imgui)
        sf.set_cursor(imgui, hx, hy)
        local limit = title_close.right_limit(imgui, '×')
        font(ui, 0.92, true)
        sf.add_heading(imgui, hx, hy, theme.u32('sf_cyan', 1.0), 'DETAIL', 'label')
        local hw = select(1, sf.measure_heading(imgui, 'DETAIL', 'label')) or 70
        font(ui, 1, false)
        -- 「本に戻る」は見出しの右。× と右上の切れに重ならない位置まで。足りなければ次の行へ
        local to_lab = t('detail.to_book')
        local to_w = title_close.button_w(imgui, to_lab)
        local bx = hx + hw + 10
        local head_h = 28
        local to_y = hy + 2
        if limit and bx + to_w > limit then
            bx = hx
            to_y = hy + head_h
            head_h = head_h + 24
        end
        if not limit or bx + to_w <= limit or to_y > hy + 2 then
            sf.set_cursor(imgui, bx, to_y)
            if W.button(ui, name, 'to_book', to_lab, {
                section = 'head', row = 'h', small = true,
            }) then
                ui.select_in_book(q.id)
            end
        end
        if title_close.draw(ui, name, {
            tooltip = t('common.close'), origin_x = hx, origin_y = hy,
        }) then
            open[1] = false
        end
        sf.set_cursor(imgui, hx, hy + head_h)
        local remain = sf.remain_below(imgui, 4) or select(2, sf.avail(imgui)) or 200
        local ok = pcall(imgui.BeginChild, '##astertrail_sf_detail_win', { 0, math.max(40, remain) }, 0, 0)
        if ok then window.push(ui, 'child') end
        if ui.status_line then pcall(ui.status_line) end
        if book_sf.draw_detail then book_sf.draw_detail(ui, name, q, { standalone = true }) end
        if ok then window.pop(ui, 'child') end
    end
    local cur = P:current_step(q.id)
    window.finish(ui, name, cur and ('step_' .. cur.id) or nil)
    if not open[1] and st.open.detail then ui.close_window(name) end
end

return detail_win_sf
