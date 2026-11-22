--[[
  隠す場面（0.1.296〜）：設定の DISPLAY（アストラル）と、印の「表示」（クラシック・YunaUI）で同じ形。
  場面ごとのオン・オフ（各テーマのスイッチ）と、オンの場面の下に「消すもの」のチェック（折り返す）。
  保存は settings.marks.hide_scenes。
]]
local W = require('src.ui.widgets')
local settings_mod = require('src.core.settings')

local M = {}

local function avail_w(imgui)
    local ok, a, b = pcall(imgui.GetContentRegionAvail)
    if not ok then return 240 end
    if type(a) == 'table' then a = a.x or a[1] end
    return tonumber(a) or 240
end

-- 消すもののチェックを、入るだけ横に並べて折り返す。戻り値: 押した key または nil
-- keys: 並べる保存の名前、label_of(key): 字、lead: 行の初めの小さな見出し（0.1.301〜「窓：」）
local function chips(ui, name, sc, e, section, width, indent, keys, label_of, row, lead)
    local imgui = ui.imgui
    local max_w = math.max(80, (width or avail_w(imgui)) - (indent or 0))
    local used, hit = 0, nil
    local lead_w = 0
    if lead then
        if indent and indent > 0 then
            pcall(imgui.Dummy, { indent, 1 })
            pcall(imgui.SameLine, 0, 0)
        end
        if imgui.AlignTextToFramePadding then pcall(imgui.AlignTextToFramePadding) end
        local th = require('src.ui.theme')
        th.TextColored(imgui, th.col('muted'), lead)
        local okm, lw = pcall(function () return select(1, require('src.ui.theme').measure_text(imgui, lead)) end)
        lead_w = (okm and tonumber(lw) or 0) + 8
        used = lead_w
    end
    for i, key in ipairs(keys) do
        local label = label_of(key)
        local w = W.check_chip_width(imgui, label)
        if (i == 1 and not lead) or used + 8 + w > max_w then
            if indent and indent > 0 then
                pcall(imgui.Dummy, { indent, 1 })
                pcall(imgui.SameLine, 0, 0)
            end
            used = w
        else
            pcall(imgui.SameLine, 0, 8)
            used = used + 8 + w
        end
        if W.check_chip(ui, name, 'hide_' .. sc .. '_' .. key, label, e[key] == true,
            { section = section, row = 'hide_' .. sc .. '_' .. row }) then
            hit = key
        end
    end
    return hit
end

local function part_chips(ui, name, sc, e, section, width, indent)
    local t = ui.t
    return chips(ui, name, sc, e, section, width, indent, settings_mod.HIDE_PARTS,
        function (part) return t('settings.hide_part_' .. part) end, 'parts')
end

-- 0.1.301〜：こちらの窓も隠す（本・コンパス・トラッカー・エミネンス・詳細の単体画面）
local WIN_KEYS = {}
for _, w in ipairs(settings_mod.HIDE_WINDOWS) do WIN_KEYS[#WIN_KEYS + 1] = 'win_' .. w end
local function window_chips(ui, name, sc, e, section, width, indent)
    local t = ui.t
    return chips(ui, name, sc, e, section, width, indent, WIN_KEYS,
        function (k) return t('settings.hide_' .. k) end, 'wins', t('settings.hide_windows_lead'))
end

-- toggle(ui, name, id, label, tbl, key) は各テーマのスイッチ。help(text) は説明の一行
function M.draw(ui, name, opts)
    local S, t = ui.settings, ui.t
    local SM = S.marks
    if type(SM.hide_scenes) ~= 'table' then SM.hide_scenes = settings_mod.hide_scenes_of(SM) end
    local HS = SM.hide_scenes
    -- 足りない場面・項目は埋める（古い保存や手で消した場合）
    local norm = settings_mod.hide_scenes_of(SM)
    for _, sc in ipairs(settings_mod.HIDE_SCENES) do
        if type(HS[sc]) ~= 'table' then HS[sc] = norm[sc] end
        for k, v in pairs(norm[sc]) do if HS[sc][k] == nil then HS[sc][k] = v end end
    end
    if opts.subhead then opts.subhead(t('settings.hide_scenes')) end
    for _, sc in ipairs(settings_mod.HIDE_SCENES) do
        local e = HS[sc]
        -- 0.1.299〜：わかりやすい名前と、i の説明（いつのことか・下のチェックを消す）
        local tip = t('settings.hide_scene_' .. sc .. '_tip')
        if sc == settings_mod.HIDE_SCENES[1] then
            -- 2 段落目：窓も隠せること（0.1.301〜）と、アストラルでは「調べる」の注意
            local extra = t('settings.hide_windows_tip')
            if opts.help_into_first then extra = extra .. t('settings.hide_scenes_help_short') end
            tip = tip .. '\n\n' .. extra
        end
        opts.toggle(ui, name, 'hide_scene_' .. sc, t('settings.hide_scene_' .. sc), e, 'on', tip)
        if e.on then
            local part = part_chips(ui, name, sc, e, opts.section, opts.width, opts.indent or 12)
            if part then
                e[part] = not e[part]
                ui.mark_settings_dirty()
            end
            local wk = window_chips(ui, name, sc, e, opts.section, opts.width, opts.indent or 12)
            if wk then
                e[wk] = not e[wk]
                ui.mark_settings_dirty()
            end
        end
    end
    if opts.help then opts.help(t('settings.hide_scenes_help')) end
end

return M
