--[[
  Astertrail - 設定・配置編集（4-6）
  予約の auto_detect は出さない。地図と頭上マークのオン／オフは出す。
  パッド・キーで操作しやすいよう、値は「－」「＋」とオン／オフのボタンで変える。
]]

local window = require('src.ui.window')
local W = require('src.ui.widgets')
local util = require('src.lib.util')
local settings_mod = require('src.core.settings')
local focus = require('src.ui.focus')
local theme = require('src.ui.theme')

local settings_ui = {}

local function onoff(ui, v) return v and ui.t('common.on') or ui.t('common.off') end

local label_w   -- 下で決める（名前の列の幅）
local text_w
local function toggle(ui, name, id, label, tbl, key, section)
    if theme.look == 'yunaui' then
        -- YunaUI 風：名前と、丸いスイッチ（スライダーの ↺ と同じ列にそろえる。名前が長ければ名前のすぐ右）
        local col_x
        if label_w then
            local w = text_w(ui.imgui, label)
            if w and w + 12 < label_w + 20 then col_x = label_w + 20 end
        end
        if W.switch(ui, name, id, label, tbl[key] == true, { section = section, row = id, col_x = col_x, reduce_motion = ui.reduce_motion }) then
            tbl[key] = not tbl[key]
            ui.mark_settings_dirty()
            return true
        end
        return false
    end
    if W.button(ui, name, id, label .. '：' .. onoff(ui, tbl[key]), { section = section, row = id }) then
        tbl[key] = not tbl[key]
        ui.mark_settings_dirty()
        return true
    end
    return false
end

-- 初期値（↺ で戻す先）
local DEF = settings_mod.defaults()

-- 名前の列の幅（前のフレームで測った一番長い名前に合わせる）
label_w = nil
local label_w_next = 0

text_w = function (imgui, s)
    if type(imgui.CalcTextSize) ~= 'function' then return nil end
    local ok, a, b = pcall(imgui.CalcTextSize, s)
    if not ok then return nil end
    if type(a) == 'table' then return tonumber(a.x or a[1]) end
    if type(a) == 'userdata' then
        local ok2, x = pcall(function () return a.x end)
        return ok2 and tonumber(x) or nil
    end
    return tonumber(a)
end

local UNIT = {
    pct = function (v) return string.format('%d%%', math.floor(v * 100 + 0.5)) end,
    px  = function (v) return string.format('%d px', math.floor(v + 0.5)) end,
    spx = function (v)
        local n = math.floor(v + 0.5)
        if n == 0 then return '0 px' end
        return string.format('%+d px', n)
    end,
}
local function unit(word)
    word = tostring(word or '')
    if word:find('^settings%.') then word = '' end   -- 訳が無いときは単位を付けない
    return function (v)
        local n = math.floor(v + 0.5)
        if word == '' then return tostring(n) end
        return string.format('%d %s', n, word)
    end
end

-- 数値の設定（VanaCore の設定画面のような、名前・↺・スライダー・値）
local function stepper(ui, name, id, label, tbl, key, step, lo, hi, text, section, default)
    local imgui = ui.imgui
    local w = text_w(imgui, label)
    if w and w > label_w_next then label_w_next = w end
    local scale = ui.settings.font_scale or 1
    return W.slider(ui, name, id, label, tbl, key, {
        step = step, lo = lo, hi = hi, default = default, text = text, section = section,
        label_w = label_w and (label_w + 20) or nil,
        slider_w = math.floor(170 * scale + 0.5),
        tooltip_reset = ui.t('settings.reset_default'),
    })
end

-- タブ（見出しごと）。選んだタブは読み込み中ずっと覚える
local SEC = 'page'          -- キー・パッドの移動は1ページ（本を開く → タブの中身 → 閉じる）を上下で通す
local current_tab = nil     -- 今のタブの key
local focus_first = false   -- タブを替えたら、中身の最初の項目を選ぶ
local tab_keys = {}         -- 前のフレームのタブの並び
local lay_bufs = {}         -- マイレイアウトの名前（0.1.194〜）
local tabs_seen = false     -- タブで描けた（LB/RB をタブ切り替えに使う）

-- app から：LB/RB（Tab/Shift+Tab）でタブを替える。替えたら true
function settings_ui.cycle_tab(dir)
    if not tabs_seen or #tab_keys == 0 then return false end
    local idx = 1
    for i, k in ipairs(tab_keys) do if k == current_tab then idx = i end end
    idx = idx + (dir < 0 and -1 or 1)
    if idx < 1 then idx = #tab_keys elseif idx > #tab_keys then idx = 1 end
    current_tab = tab_keys[idx]
    focus_first = true
    return true
end

function settings_ui.current_tab() return current_tab end

-- 最初のタブへ戻す（開いたとき。前回の位置を覚えない設定）
function settings_ui.reset_tab()
    if tab_keys[1] then
        settings_ui.select_tab(tab_keys[1])
    else
        current_tab = nil
    end
    -- カーソルは最初のタブの最初の項目（focus.reset で最初の項目になる）
    focus_first = false
end

-- 指定のタブを選ぶ（コマンドや開発用）
function settings_ui.select_tab(key)
    current_tab = key
end
function settings_ui._reset_tabs() current_tab, focus_first, tab_keys, tabs_seen = nil, false, {}, false end

-- 本の中（一覧と詳細の場所）に設定を描く（0.1.175〜。本の book.draw から呼ぶ）
function settings_ui.body(ui)
    local imgui, t, S = ui.imgui, ui.t, ui.settings
    local name = 'settings'
    -- 見出しごとの中身（タブ1枚ずつ。タブが使えないときは1ページに並べる）
    local caps = ui.capabilities and ui.capabilities() or {}
    local SECTIONS = {}
    SECTIONS[#SECTIONS + 1] = { key = 'look', title = t('settings.look'), draw = function ()
        if W.button(ui, name, 'lang', t('settings.language', { v = S.language == 'ja' and '日本語' or 'English' }),
            { section = SEC, row = 'lang' }) then
            S.language = (S.language == 'ja') and 'en' or 'ja'
            ui.set_language(S.language)
            ui.mark_settings_dirty()
        end
        -- 文字サイズは場所ごと（窓の大きさと頭上のアイコンの大きさは変えない）
        S.fonts = S.fonts or {}
        for _, area in ipairs(settings_mod.FONT_AREAS) do
            if S.fonts[area] == nil then S.fonts[area] = settings_mod.font_for(S, area) end
            local lo, hi = settings_mod.font_range(area)
            stepper(ui, name, 'font_' .. area, t('settings.font_' .. area), S.fonts, area, 0.1, lo, hi, UNIT.pct, SEC, DEF.fonts[area])
        end
        stepper(ui, name, 'font', t('settings.font_other'), S, 'font_scale', 0.1, settings_mod.FONT_MIN, settings_mod.FONT_MAX, UNIT.pct, SEC, DEF.font_scale)
        W.muted(ui, t('settings.font_note'))
        -- 背景の濃さも窓ごと（文字サイズと同じ並び）
        S.alphas = S.alphas or {}
        for _, area in ipairs(settings_mod.ALPHA_AREAS) do
          -- 設定は本の中に出すので（0.1.175〜）、設定だけの背景の濃さは出さない（値は残す）
          if area ~= 'settings' then
            if S.alphas[area] == nil then S.alphas[area] = settings_mod.alpha_for(S, area) end
            stepper(ui, name, 'alpha_' .. area, t('settings.alpha_' .. area), S.alphas, area, 0.05, 0.3, 1.0, UNIT.pct, SEC, DEF.alphas[area])
          end
        end
        W.muted(ui, t('settings.alpha_note'))
        if W.button(ui, name, 'look_style', t('settings.look_style', { v = t('settings.look_' .. (S.look == 'classic' and 'classic' or 'yunaui')) }),
            { section = SEC, row = 'look_style' }) then
            S.look = (S.look == 'classic') and 'yunaui' or 'classic'
            ui.mark_settings_dirty()
        end
        toggle(ui, name, 'motion', t('settings.reduce_motion'), S, 'reduce_motion', SEC)
    end }
    SECTIONS[#SECTIONS + 1] = { key = 'layout', title = t('settings.layout'), draw = function ()
        toggle(ui, name, 'lock', t('settings.layout_locked'), S, 'layout_locked', SEC)
        if W.button(ui, name, 'inside', t('settings.bring_inside'), { section = SEC, row = 'pos' }) then
            ui.bring_inside()
        end
        W.same(ui)
        if W.button(ui, name, 'reset', t('settings.reset_layout'), { section = SEC, row = 'pos' }) then
            ui.reset_layout()
        end
        toggle(ui, name, 'icon', t('settings.entry_icon'), S.entry_icon, 'visible', SEC)
        toggle(ui, name, 'filters', t('settings.remember_filters'), S.book, 'remember_filters', SEC)
        toggle(ui, name, 'remember_pos', t('settings.remember_position'), S, 'remember_position', SEC)
        -- 本の一覧の列の並び（見出しのドラッグで変えたもの）を元に戻す
        if W.button(ui, name, 'reset_cols', t('settings.reset_columns'), { section = SEC, row = 'reset_cols' }) then
            if require('src.ui.book').reset_columns(S) then ui.mark_settings_dirty() end
        end
        W.muted(ui, t('settings.remember_position_note'))
    end }
    SECTIONS[#SECTIONS + 1] = { key = 'tracker', title = t('settings.tracker'), draw = function ()
        if toggle(ui, name, 'tr_vis', t('settings.tracker_visible'), S.tracker, 'visible', SEC) then
            if not S.tracker.visible and ui.release then ui.release() end
        end
        W.muted(ui, t('settings.tracker_visible_note'))
        -- コンパス（0.1.173〜）：いまいるエリアで受けられるクエストを近い順に
        if toggle(ui, name, 'compass_vis', t('settings.compass_visible'), S.compass, 'visible', SEC) and S.compass.visible
            and ui.set_compass_visible then ui.set_compass_visible(true) end
        stepper(ui, name, 'compass_range', t('settings.compass_range'), S.compass, 'max_dist', 5, 5, 100,
            unit(t('settings.unit_yalms')), SEC, DEF.compass.max_dist)
        stepper(ui, name, 'pins', t('settings.max_pins'), S.tracker, 'max_pins', 1, 1, 30, unit(t('settings.unit_count')), SEC, DEF.tracker.max_pins)
        -- たたむ（0.1.62〜。トラッカーでは空いている所をダブルクリック）
        if toggle(ui, name, 'tr_fold', t('settings.tracker_collapsed'), S.tracker, 'collapsed', SEC) and S.tracker.collapsed then
            require('src.ui.tracker').set_collapsed(ui, true)
        end
        -- 文字のそろえ方（0.1.62〜。初期値は右そろえ）
        local al = (S.tracker.align == 'left') and 'left' or 'right'
        if W.button(ui, name, 'tr_align', t('settings.tracker_align', { v = t('settings.tracker_align_' .. al) }),
            { section = SEC, row = 'tr_align' }) then
            S.tracker.align = (al == 'left') and 'right' or 'left'
            ui.mark_settings_dirty()
        end
        -- 出し方（一覧／タブ）と右上の ×（0.1.170〜）
        local vw = (S.tracker.view == 'tabs') and 'tabs' or 'list'
        if W.button(ui, name, 'tr_view', t('settings.tracker_view', { v = t('settings.tracker_view_' .. vw) }),
            { section = SEC, row = 'tr_view' }) then
            S.tracker.view = (vw == 'tabs') and 'list' or 'tabs'
            ui.mark_settings_dirty()
        end
        W.muted(ui, t('settings.tracker_view_note'))
        -- タブの幅（全角の字数、0.1.171〜）
        stepper(ui, name, 'tr_tabw', t('settings.tracker_tab_chars'), S.tracker, 'tab_chars', 1, 3, 16,
            unit(t('settings.unit_chars')), SEC, DEF.tracker.tab_chars)
        toggle(ui, name, 'tr_close', t('settings.tracker_show_close'), S.tracker, 'show_close', SEC)
        W.muted(ui, t('settings.tracker_show_close_note'))
        W.muted(ui, t('settings.tracker_fold_note'))
        toggle(ui, name, 'tr_tw', t('settings.show_time_weather'), S.tracker, 'show_time_weather', SEC)
        toggle(ui, name, 'tr_items', t('settings.show_items'), S.tracker, 'show_items', SEC)
        toggle(ui, name, 'poss', t('settings.show_possession'), S.items, 'show_possession', SEC)
    end }
    SECTIONS[#SECTIONS + 1] = { key = 'map', title = t('settings.map'), draw = function ()
        toggle(ui, name, 'map_on', t('map.enabled'), S.map, 'enabled', SEC)
        W.muted(ui, t('map.credit_note'))
    end }
    SECTIONS[#SECTIONS + 1] = { key = 'marks', title = t('settings.marks'), draw = function ()
        -- 表示のオン・オフは4つだけ（0.1.59〜）。それぞれ名前のとおりのものだけを動かす
        toggle(ui, name, 'marks_icons', t('settings.marks_show_icons'), S.marks, 'show_icons', SEC)
        toggle(ui, name, 'marks_quest', t('settings.marks_show_quest_name'), S.marks, 'show_quest_name', SEC)
        toggle(ui, name, 'marks_objects', t('settings.marks_show_object_names'), S.marks, 'show_object_names', SEC)
        toggle(ui, name, 'marks_nearby', t('settings.marks_show_nearby'), S.marks, 'show_nearby_names', SEC)
        -- 名声を教えてくれる人のアイコン（0.1.69〜）。アイコンを表示するがオンのときだけ出る
        toggle(ui, name, 'marks_fame', t('settings.marks_show_fame'), S.marks, 'show_fame_npcs', SEC)
        W.muted(ui, t('settings.marks_switches_note'))
        stepper(ui, name, 'marks_icon', t('settings.marks_icon_size'), S.marks, 'icon_size', 4, 16, 64, UNIT.px, SEC, DEF.marks.icon_size)
        -- 位置の調整（px、＋で右・下）
        -- 調べるオブジェクト（??? など）と、そのほか（話す相手・討伐対象・ゲートガード）で別々
        local lo, hi, st = settings_mod.OFFSET_MIN, settings_mod.OFFSET_MAX, settings_mod.OFFSET_STEP
        local function offsets(keys, base)
            for i, k in ipairs(keys) do
                if type(S.marks[k]) ~= 'number' then S.marks[k] = 0 end
                stepper(ui, name, 'marks_' .. k, t('settings.marks_' .. base[i]), S.marks, k, st, lo, hi, UNIT.spx, SEC, 0)
            end
        end
        W.heading(ui, t('settings.marks_pos_obj'))
        offsets(settings_mod.OBJ_OFFSET_KEYS, { 'row_dx', 'row_dy', 'label_dx', 'label_dy' })
        -- 近くのオブジェクト名（0.1.60〜）。クエストのオブジェクト名とは別に動かす
        W.heading(ui, t('settings.marks_pos_near'))
        offsets(settings_mod.NEAR_OFFSET_KEYS, { 'near_name_dx', 'near_name_dy' })
        W.heading(ui, t('settings.marks_pos_other'))
        offsets(settings_mod.OFFSET_KEYS, { 'mark_dx', 'mark_dy', 'label_dx', 'label_dy' })
        toggle(ui, name, 'marks_zoom', t('settings.marks_zoom_follow'), S.marks, 'zoom_follow', SEC)
        -- 文字の色（クエスト名・オブジェクト名。RGB それぞれ 0〜255、↺ で初めの色。グラデーションは左から右へ）
        local function color_block(which, sample)
            local M = S.marks
            local DM = DEF.marks
            W.heading(ui, t('settings.marks_color_' .. which))
            local c1, c2 = settings_mod.text_colors(M, which)
            W.color_preview(ui, sample, c1, c2)
            local function pick(key, label)
                local w = text_w(ui.imgui, label)
                if w and w > label_w_next then label_w_next = w end
                W.color_row(ui, name, 'marks_' .. key, label, M, key, DM[key], {
                    section = SEC, row = 'marks_' .. key,
                    label_w = label_w and (label_w + 20) or nil,
                    tooltip_reset = t('settings.reset_default'),
                })
            end
            pick(which .. '_color', t('settings.color_start'))
            toggle(ui, name, 'marks_' .. which .. '_grad', t('settings.color_gradient'), M, which .. '_grad', SEC)
            if M[which .. '_grad'] then
                pick(which .. '_color2', t('settings.color_end'))
            end
            if W.button(ui, name, 'marks_' .. which .. '_all_reset', t('settings.color_reset'),
                { section = SEC, row = 'marks_' .. which .. '_all_reset', small = true }) then
                for _, k in ipairs({ which .. '_color', which .. '_color2' }) do
                    M[k] = { DM[k][1], DM[k][2], DM[k][3] }
                end
                M[which .. '_grad'] = false
                ui.mark_settings_dirty()
            end
            -- 頭上の文字の背景の濃さ（0.1.215〜）。クエスト名とオブジェクト名で別
            local bg_key = which .. '_bg_alpha'
            if type(M[bg_key]) ~= 'number' then M[bg_key] = settings_mod.LABEL_BG_ALPHA_DEFAULT end
            stepper(ui, name, 'marks_' .. bg_key, t('settings.marks_' .. bg_key), M, bg_key,
                0.05, settings_mod.LABEL_BG_ALPHA_MIN, settings_mod.LABEL_BG_ALPHA_MAX,
                UNIT.pct, SEC, DM[bg_key])
        end
        color_block('label', t('settings.color_sample_label'))
        color_block('under', '???')
        W.muted(ui, t('settings.color_note'))
        W.muted(ui, t('settings.marks_bg_alpha_note'))
        -- 足元の輪（0.1.171〜）：オンオフ・大きさ・種類ごとの色（初めの色は今のアイコンの色）
        do
            local M, DM = S.marks, DEF.marks
            W.heading(ui, t('settings.rings'))
            toggle(ui, name, 'marks_rings', t('settings.rings_show'), M, 'show_rings', SEC)
            stepper(ui, name, 'marks_ring_size', t('settings.rings_size'), M, 'ring_size', 0.1,
                settings_mod.RING_SIZE_MIN, settings_mod.RING_SIZE_MAX, UNIT.pct, SEC, DM.ring_size)
            for _, k in ipairs(settings_mod.RING_KINDS) do
                local key = 'ring_' .. k
                local label = t('settings.rings_' .. k)
                local w = text_w(ui.imgui, label)
                if w and w > label_w_next then label_w_next = w end
                W.color_row(ui, name, 'marks_' .. key, label, M, key, DM[key], {
                    section = SEC, row = 'marks_' .. key,
                    label_w = label_w and (label_w + 20) or nil,
                    tooltip_reset = t('settings.reset_default'),
                })
            end
            if W.button(ui, name, 'marks_rings_reset', t('settings.rings_reset'),
                { section = SEC, row = 'marks_rings_reset', small = true }) then
                for _, k in ipairs(settings_mod.RING_KINDS) do
                    local d = DM['ring_' .. k]
                    M['ring_' .. k] = { d[1], d[2], d[3] }
                end
                ui.mark_settings_dirty()
            end
            W.muted(ui, t('settings.rings_note'))
        end
        if W.button(ui, name, 'marks_pos_reset', t('settings.marks_pos_reset'), { section = SEC, row = 'marks_pos_reset', small = true }) then
            for _, k in ipairs(settings_mod.OFFSET_KEYS) do S.marks[k] = 0 end
            for _, k in ipairs(settings_mod.OBJ_OFFSET_KEYS) do S.marks[k] = 0 end
            for _, k in ipairs(settings_mod.NEAR_OFFSET_KEYS) do S.marks[k] = 0 end
            ui.mark_settings_dirty()
        end
        W.muted(ui, t('settings.marks_pos_note'))
        W.muted(ui, t('settings.marks_note'))
        if caps.marks_project == false then
            W.muted(ui, t('settings.marks_no_project'))
        end
    end }
    SECTIONS[#SECTIONS + 1] = { key = 'notify', title = t('settings.notify'), draw = function ()
        local N = S.notify
        toggle(ui, name, 'n_login', t('settings.login_resume'), N, 'login_resume', SEC)
        stepper(ui, name, 'n_login_s', t('settings.login_resume_seconds'), N, 'login_resume_seconds', 1, 3, 60, unit(t('settings.unit_sec')), SEC, DEF.notify.login_resume_seconds)
        -- 受注・完了のお知らせと効果音（0.1.183〜、t295）
        W.sep(ui)
        toggle(ui, name, 'n_popup', t('settings.popup'), N, 'popup', SEC)
        stepper(ui, name, 'n_popup_s', t('settings.popup_seconds'), N, 'popup_seconds', 1, 3, 30, unit(t('settings.unit_sec')), SEC, DEF.notify.popup_seconds)
        toggle(ui, name, 'n_sound', t('settings.sound'), N, 'sound', SEC)
        stepper(ui, name, 'n_sound_v', t('settings.sound_volume'), N, 'sound_volume', 10, 0, 100, unit('%'), SEC, DEF.notify.sound_volume)
        if W.button(ui, name, 'n_popup_try', t('settings.popup_try_accept'), { section = SEC, row = 'n_popup_try' }) then
            if ui.popup_preview then ui.popup_preview('accept') end
        end
        W.same(ui)
        if W.button(ui, name, 'n_popup_try2', t('settings.popup_try_complete'), { section = SEC, row = 'n_popup_try' }) then
            if ui.popup_preview then ui.popup_preview('complete') end
        end
        if ui.can_play_sound and not ui.can_play_sound() then W.muted(ui, t('settings.sound_unavailable')) end
        W.muted(ui, t('settings.popup_try_note'))
        W.muted(ui, t('settings.popup_note'))
        -- エリア入場の「いまここで進めること」とミュートは 0.1.173 でなくした（t251）
    end }
    SECTIONS[#SECTIONS + 1] = { key = 'input', title = t('settings.input'), draw = function ()
        toggle(ui, name, 'pad', t('settings.gamepad'), S.input, 'gamepad', SEC)
        stepper(ui, name, 'repeat', t('settings.repeat_ms'), S.input, 'repeat_ms', 20, 60, 1000, unit('ms'), SEC, DEF.input.repeat_ms)
        W.muted(ui, t('settings.input_note'))
        W.muted(ui, t('settings.pad_state', { v = caps.gamepad_note or '?' }))
        -- パッドのショートカット（0.1.57〜。0.1.61〜は「操作」の中。0.1.194〜はエミネンス・コンパスも）。押すとボタン待ち、全部離すと決まる
        W.sep(ui)
        W.colored(ui, 'accent', t('settings.shortcut'))
        S.shortcut = S.shortcut or { open_book = {}, pass_to_game = true }
        local info = ui.shortcut_info and ui.shortcut_info() or {}
        local sc = require('src.core.shortcut')
        local json_ = require('src.lib.json')
        -- id：本を開くは sc_open。戻すは sc_*_reset（同じ行。0.1.194〜。前の「消す」はやめた）
        local ROWS = {
            { key = 'open_book', id = 'sc_open', reset = 'sc_open_reset' },
            { key = 'tracker_toggle', id = 'sc_tt', reset = 'sc_tt_reset' },
            { key = 'tracker_operate', id = 'sc_to', reset = 'sc_to_reset' },
            { key = 'eminence_toggle', id = 'sc_et', reset = 'sc_et_reset' },
            { key = 'compass_toggle', id = 'sc_ct', reset = 'sc_ct_reset' },
        }
        for _, R in ipairs(ROWS) do
            if info.capturing and info.which == R.key then
                if W.button(ui, name, 'sc_wait', t('settings.shortcut_waiting'), { section = SEC, row = R.id }) then
                    if ui.shortcut_capture_cancel then ui.shortcut_capture_cancel() end
                end
                if info.so_far then W.colored(ui, 'good', t('settings.shortcut_so_far', { v = info.so_far })) end
                if W.button(ui, name, 'sc_cancel', t('settings.shortcut_cancel'), { section = SEC, row = 'sc_cancel', small = true }) then
                    if ui.shortcut_capture_cancel then ui.shortcut_capture_cancel() end
                end
            else
                local v = sc.label(S.shortcut[R.key]) or t('settings.shortcut_none')
                if W.button(ui, name, R.id, t('settings.shortcut_' .. R.key, { v = v }), { section = SEC, row = R.id }) then
                    if ui.shortcut_capture_start then ui.shortcut_capture_start(R.key) end
                end
                W.same(ui)
                -- 初期値はどれもなし。戻すと消える。初期値のときは薄くて押せない
                local at_default = sc.same(S.shortcut[R.key] or {}, {})
                if W.reset_button(ui, name, R.reset, {
                    section = SEC, row = R.id, tooltip = t('settings.reset_default'), at_default = at_default,
                }) then
                    S.shortcut[R.key] = json_.array({})
                    ui.mark_settings_dirty()
                end
            end
        end
        toggle(ui, name, 'sc_pass', t('settings.shortcut_pass'), S.shortcut, 'pass_to_game', SEC)
        W.muted(ui, t('settings.shortcut_note'))
        W.muted(ui, t('settings.shortcut_tracker_note'))
        W.muted(ui, t('settings.shortcut_windows_note'))
        local src = caps.pad_source
        local sv = t('settings.shortcut_src_' .. ((src == 'state' or src == 'button' or src == 'dinput') and src or 'none'))
        W.muted(ui, t('settings.shortcut_state', { v = sv }))
        -- ゲームのメニュー（0.1.67〜は「操作」の中。前は別のタブ）
        W.sep(ui)
        W.colored(ui, 'accent', t('settings.gameui'))
        toggle(ui, name, 'g_mission', t('settings.gameui_mission_book'), S.gameui, 'mission_book', SEC)
        toggle(ui, name, 'g_config', t('settings.gameui_config_button'), S.gameui, 'config_button', SEC)
        toggle(ui, name, 'g_capture', t('settings.gameui_capture'), S.gameui, 'capture', SEC)
        toggle(ui, name, 'g_ontop', t('settings.gameui_menus_on_top'), S.gameui, 'menus_on_top', SEC)
        if ui.state.gameui_note then W.muted(ui, ui.state.gameui_note) end
        W.muted(ui, t('settings.gameui_note'))
    end }
    SECTIONS[#SECTIONS + 1] = { key = 'save', title = t('settings.save'), draw = function ()
        stepper(ui, name, 'keep', t('settings.backup_keep'), S.backup, 'keep', 1, 1, 100, unit(t('settings.unit_count')), SEC, DEF.backup.keep)
        W.muted(ui, t('settings.char_folder', { v = ui.state.char_folder or t('status.waiting') }))
        W.muted(ui, t('settings.data_version', { v = ui.data.version or '?' }))
        local orphans = ui.progress:orphan_count()
        if orphans > 0 then W.colored(ui, 'warn', t('settings.orphans', { n = orphans })) end
        if #ui.data.warnings > 0 then W.muted(ui, t('settings.data_warnings', { n = #ui.data.warnings })) end
        W.muted(ui, t('settings.inventory_state', { v = caps.inventory and t('common.on') or t('settings.inventory_unverified') }))
        if W.button(ui, name, 'save_now', t('settings.save_now'), { section = SEC, row = 'save_now' }) then
            ui.save_now()
        end
        -- マイレイアウト（0.1.194〜）：5つ。各窓の位置・大きさと設定を覚える（進行・ピンなどは入れない）
        W.sep(ui)
        W.colored(ui, 'accent', t('settings.layouts'))
        W.same(ui)
        if W.button(ui, name, 'lay_info', 'ⓘ', { section = SEC, row = 'lay_info', small = true, tooltip = t('settings.layouts_tip') }) then
            -- 説明だけ（押しても動作なし）
        end
        if focus.current(name) == 'lay_info' and imgui.SetTooltip then
            pcall(imgui.SetTooltip, t('settings.layouts_tip'))
        end
        local slots = ui.layout_slots and ui.layout_slots() or {}
        local scale = S.font_scale or 1
        for i = 1, 5 do
            local s = slots[i] or { name = '', saved = false }
            local id = 'lay_name_' .. i
            local buf = lay_bufs[i] or { '' }
            lay_bufs[i] = buf
            if focus.current(name) ~= id then buf[1] = s.name or '' end
            local sf, sa = focus.item(name, id, SEC, id)
            if sa then imgui.SetKeyboardFocusHere(0) end
            imgui.SetNextItemWidth(math.floor(200 * scale + 0.5))
            if imgui.InputTextWithHint('##astertrail_' .. id, t('settings.layout_placeholder', { n = tostring(i) }), buf, 40) then
                if ui.set_layout_name then ui.set_layout_name(i, buf[1]) end
            end
            ui.text_active = ui.text_active or imgui.IsItemActive()
            if imgui.IsItemHovered() and imgui.IsMouseClicked(0) then focus.set(name, id) end
            if sf then
                local x1, y1 = imgui.GetItemRectMin()
                local x2, y2 = imgui.GetItemRectMax()
                theme.draw_focus(imgui, x1, y1, x2, y2, ui.reduce_motion)
            end
            W.same(ui)
            if W.button(ui, name, 'lay_save_' .. i, t('settings.layout_save'), { section = SEC, row = 'lay_save_' .. i }) then
                if ui.set_layout_name then ui.set_layout_name(i, buf[1]) end
                if ui.save_layout then ui.save_layout(i) end
            end
            W.same(ui)
            if W.button(ui, name, 'lay_load_' .. i, t('settings.layout_load'), {
                section = SEC, row = 'lay_load_' .. i, disabled = not s.saved,
                tooltip = (not s.saved) and t('settings.layout_empty') or nil,
            }) then
                if ui.load_layout then ui.load_layout(i) end
            end
        end
        -- デバッグ（0.1.187〜、t308）。公開版には出さない
        if ui.manual_checks == nil or ui.manual_checks() then
            W.sep(ui)
            W.colored(ui, 'accent', t('settings.debug'))
            S.debug = S.debug or { state_buttons = false }
            toggle(ui, name, 'dbg_state', t('settings.debug_state_buttons'), S.debug, 'state_buttons', SEC)
            W.muted(ui, t('settings.debug_note'))
        end
    end }
    -- エミネンス（0.1.172〜）
    SECTIONS[#SECTIONS + 1] = { key = 'eminence', title = t('settings.eminence'), draw = function ()
        -- 窓の出す・隠すは本の上の行のボタンだけ（0.1.182〜、t293。ここのスイッチはなくした）
        toggle(ui, name, 'roe_fold', t('settings.roe_collapsed'), S.eminence, 'collapsed', SEC)
        -- 達成間近の目安は、窓の達成間近のタブをなくしたので出さない（0.1.177〜。値は残す）
        -- 0.1.226〜：「本で達成したものを隠す」はやめた（本の「表示：☑達成」に移した）
        W.muted(ui, t('settings.roe_note'))
    end }
    SECTIONS[#SECTIONS + 1] = { key = 'about', title = t('about.title'), draw = function ()
        W.muted(ui, 'Based on YunaUI by Yunas - https://github.com/YunasXI/yunaui')
        W.muted(ui, t('about.license'))
        W.muted(ui, t('about.version', { v = ui.addon_version, d = ui.data.version or '?' }))
        S.update_notice = S.update_notice or { enabled = true }
        toggle(ui, name, 'update_notice', t('about.update_notice'), S.update_notice, 'enabled', SEC)
        W.muted(ui, t('about.update_notice_note'))
    end }

    -- 0.1.175〜：設定は本の中（一覧と詳細の場所）に出す。窓は別に作らない。
    -- キー・パッドの選択は今までどおり 'settings' の名前で持つ（本の上の行とは別。LB/RB はタブ、キャンセルで本へ）
    focus.begin(name)
    do
        if label_w_next > 0 then label_w = label_w_next end
        label_w_next = 0

        tab_keys = {}
        for _, sec in ipairs(SECTIONS) do tab_keys[#tab_keys + 1] = sec.key end
        if not current_tab then current_tab = tab_keys[1] end

        -- タブの列（自前のボタン。マウスで押せる。キー・パッドのカーソルは乗らず、LB/RB で替える）
        -- ImGui のタブ（SetSelected）はこの環境では選び直しが効かなかったため使わない
        tabs_seen = true
        -- 0.1.225〜（t499）：パッドの案内（LB／RB でタブを替える…）は出さない
        W.muted(ui, t('settings.heading'))
        local avail = 0
        local okw, aw = pcall(imgui.GetContentRegionAvail)
        if okw then avail = (type(aw) == 'table' and (aw.x or aw[1])) or tonumber(aw) or 0 end
        local used = 0
        local style_pad = 16
        for i, sec in ipairs(SECTIONS) do
            local on = (sec.key == current_tab)
            local label = (on and '◆ ' or '◇ ') .. sec.title
            local w = (text_w(imgui, label) or (#label * 7)) + style_pad
            if i > 1 then
                if avail > 0 and used + 8 + w > avail then
                    used = 0
                else
                    imgui.SameLine()
                    used = used + 8
                end
            end
            local clicked = imgui.Button(label .. '##st_' .. sec.key)
            used = used + w
            if clicked and not on then
                current_tab = sec.key
                focus_first = true
            end
        end
        W.sep(ui)
        -- 中身だけが動く（上のタブと、下の「一覧に戻る」はいつも見える）
        local _, avail_h = imgui.GetContentRegionAvail()
        if type(avail_h) ~= 'number' then
            local okh, ah = pcall(imgui.GetContentRegionAvail)
            avail_h = (okh and type(ah) == 'table') and (ah.y or ah[2]) or nil
        end
        local okf, fh = pcall(imgui.GetFrameHeightWithSpacing)
        fh = (okf and tonumber(fh)) or 28
        local body_h = math.max(60, (tonumber(avail_h) or 400) - fh - 10)
        local child = pcall(imgui.BeginChild, '##astertrail_settings_body', { 0, body_h }, 0, 0)
        if child then
            window.push(ui, 'child')
            window.set_font(ui, window.font_scale(ui, name))
        end
        for _, sec in ipairs(SECTIONS) do
            if sec.key == current_tab then
                local mark = focus.mark(name)
                sec.draw()
                if focus_first then
                    local first = focus.id_at(name, mark + 1)
                    if first then focus.set(name, first, true) end
                    focus_first = false
                end
            end
        end
        if child then window.pop(ui, 'child') end

        W.sep(ui)
        if W.button(ui, name, 'close', t('settings.back_to_book'), { section = SEC, row = 'f' }) then
            ui.close_window(name)
        end
    end
    focus.finish(name)
end

return settings_ui
