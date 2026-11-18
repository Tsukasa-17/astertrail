--[[
  Astertrail - コンパスの窓（0.1.173〜、t251）
  いまいるエリアで受けられるクエストを近い順に。1行：クエスト名・受注NPC名・距離（行は app.tick_compass が作る）。
  クエスト名を押すと詳細。依頼者の名前を押すと、その人の場所の地図を開く（0.1.202〜。本・トラッカーと同じ。座標が無いときは押しても開かない）。
  受けられない理由が資料にあるもの（確かめられない）は本と同じ印を付け、乗せると理由。
  出す・隠すは設定 compass.visible（本の上の行のコンパスのボタン、右上の ×、/astertrail compass）。
  文字・背景はトラッカーと同じ設定。窓の大きさは文字の大きさで変えない。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local theme = require('src.ui.theme')
local labels = require('src.ui.labels')
local compass_core = require('src.core.compass')

local compass = {}

function compass.draw(ui)
    local imgui, t = ui.imgui, ui.t
    local name = 'compass'
    local open = { true }
    local rows = ui.state.compass or {}
    local pl = ui.player
    local zone = pl and pl.zone_id and ui.data:zone_name(pl.zone_id) or nil
    local title = t('compass.title', { zone = zone or '?' })
    local drawing = window.begin(ui, name, { title = title, open = open, operable = true, no_focus = true, hscroll = true })
    if drawing then
        window.set_font(ui, window.font_scale(ui, name))
        if ui.state.compass == nil then
            W.muted(ui, t('compass.loading'))
        elseif #rows == 0 then
            W.muted(ui, t('compass.empty'))
        end
        local map_on = ui.settings.map and ui.settings.map.enabled ~= false and ui.open_map
        for i, r in ipairs(rows) do
            local q = ui.data:quest(r.qid)
            if q then
                local nm = labels.qname(q)
                if W.link(ui, name, 'q_' .. r.qid, nm, { color = r.icon == 'repeat' and 'ic_repeat' or 'accent',
                    section = 'list', row = r.qid .. '_name' }) then
                    ui.open_detail_solo(r.qid, 'compass')
                end
                -- 受けられない理由：※ に乗せたときだけ（0.1.177〜）
                if #r.reasons > 0 then
                    imgui.SameLine(0, 2)
                    theme.TextColored(imgui, theme.col('warn'), t('book.cond_mark'))
                    if imgui.IsItemHovered() then
                        local tip = {}
                        for _, x in ipairs(r.reasons) do tip[#tip + 1] = t('book.lock_reason', { text = x.text_ja or '' }) end
                        imgui.SetTooltip(table.concat(tip, '\n'))
                    end
                end
                -- 2行目（0.1.177〜）：依頼者と距離。字下げして、折り返さない（狭いときは横のスクロールバー）
                -- 依頼者を押すと、その人の場所の地図（0.1.202〜。座標が無い・地図オフのときは色だけ）
                imgui.Indent()
                local sl = ui.data:start_location(q)
                local can = map_on and sl and sl.zone_id and r.npc
                if can then
                    if W.link(ui, name, 'npc_' .. r.qid, r.npc, {
                        color = 'npc', tooltip = t('map.view'),
                        section = 'list', row = r.qid .. '_npc',
                    }) then
                        ui.open_map(r.qid, nil, sl)
                    end
                else
                    theme.TextColored(imgui, theme.col('npc'), r.npc or t('compass.npc_unknown'))
                end
                imgui.SameLine()
                theme.TextColored(imgui, theme.col(r.dist and 'text' or 'muted'), compass_core.dist_text(t, r))
                imgui.Unindent()
            end
        end
    end
    window.finish(ui, name, nil)
    if not open[1] and ui.set_compass_visible then ui.set_compass_visible(false) end
end

return compass
