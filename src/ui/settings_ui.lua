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

--[[ 0.1.315〜：頭上の文字のフォント（クエスト名・オブジェクト名で共通）。
  一覧は vanacore_ext が Windows のフォントフォルダから少しずつ読む（この行が見えている間だけ、1 フレーム数ファイル）。
  選択肢の表は、一覧の数・今の値・言葉が変わったときだけ作り直す（毎フレーム作らない）。 ]]
local font_choice_cache = { n = -1, cur = nil, done = nil, def = nil, list = nil }
function settings_ui.label_font_choices(t, cur)
    local ok_ext, ext = pcall(require, 'src.platform.vanacore_ext')
    local list, done, unavailable = {}, true, true
    if ok_ext and ext and ext.font_scan_step then
        ext.font_scan_step(ext.FONT_SCAN_PER_STEP)
        list, done, unavailable = ext.font_families()
    end
    cur = cur or ''
    local def = t('settings.label_font_default')
    local c = font_choice_cache
    if c.list and c.n == #list and c.cur == cur and c.done == done and c.def == def then
        return c.list, done, unavailable, #list
    end
    local choices = { { value = '', label = def } }
    local has = (cur == '')
    for _, it in ipairs(list) do
        choices[#choices + 1] = it
        if it.value == cur then has = true end
    end
    -- 保存されている名前が一覧に無い（読み込み中・消したフォント）ときも、そのまま選べるように 2 番目に出す
    if not has then table.insert(choices, 2, { value = cur, label = cur }) end
    font_choice_cache = { n = #list, cur = cur, done = done, def = def, list = choices }
    return choices, done, unavailable, #list
end
function settings_ui._reset_font_choices() font_choice_cache = { n = -1 } end

local label_w   -- 下で決める（名前の列の幅）
local text_w
local function toggle(ui, name, id, label, tbl, key, section, info)
    if theme.look == 'yunaui' then
        -- YunaUI 風：名前と、丸いスイッチ（スライダーの ↺ と同じ列にそろえる。名前が長ければ名前のすぐ右）
        local col_x
        if label_w then
            local w = text_w(ui.imgui, label)
            if w and w + 12 < label_w + 20 then col_x = label_w + 20 end
        end
        if W.switch(ui, name, id, label, tbl[key] == true, { section = section, row = id, col_x = col_x, reduce_motion = ui.reduce_motion, info = info }) then
            tbl[key] = not tbl[key]
            ui.mark_settings_dirty()
            return true
        end
        return false
    end
    local hit = W.button(ui, name, id, label .. '：' .. onoff(ui, tbl[key]), { section = section, row = id })
    -- 0.1.299〜：説明の i（乗せる・パッドで選ぶと説明）
    if info and info ~= '' then
        local focused = focus.current(name) == id and focus.why(name) ~= 'hover'
        ui.imgui.SameLine(0, 6)
        W.info_mark(ui, name .. '/' .. id, info, { lit = focused })
        if focused then W.tooltip(ui, info) end
    end
    if hit then
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
    fpx = function (v)
        v = tonumber(v) or 0
        local n = math.floor(v * 4 + 0.5) / 4
        if math.abs(n - math.floor(n + 0.5)) < 1e-6 then
            return string.format('%d px', math.floor(n + 0.5))
        end
        return string.format('%.2f px', n)
    end,
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

-- 0.1.304〜：設定の画面（settings_sf）が左の分類の並びを渡す。LB/RB（R1 など）でタブを替えられるように
-- 0.1.304〜：分類を替えたあと最初の項目を選ぶか（一度だけ true）
function settings_ui.take_focus_first()
    local f = focus_first
    focus_first = false
    return f
end

function settings_ui.set_tab_keys(keys)
    tab_keys = {}
    for i, k in ipairs(keys or {}) do tab_keys[i] = k end
    tabs_seen = #tab_keys > 0
end

function settings_ui._reset_tabs() current_tab, focus_first, tab_keys, tabs_seen = nil, false, {}, false end

-- 折りたたみ見出し（0.1.239〜）。初期はすべて開く。settings_folds[id] == true がたたんだ状態。
-- 決定では開閉しない。開け閉めは左右（マウスはクリック）。決定で中の先頭へ、キャンセルで見出しへ（本と同じ）。
local FOLD_PREFIX = 'fold_'
local fold_items = {}

local function folds_tbl(S)
    if not S then return {} end
    if type(S.settings_folds) ~= 'table' then S.settings_folds = {} end
    return S.settings_folds
end

function settings_ui.is_folded(S, id)
    return S and type(S.settings_folds) == 'table' and S.settings_folds[id] == true
end

function settings_ui.set_folded(S, id, folded, ui)
    if not S or type(id) ~= 'string' or id == '' then return false end
    local t = folds_tbl(S)
    folded = folded and true or false
    if (t[id] == true) == folded then return false end
    if folded then t[id] = true else t[id] = nil end
    if ui and ui.mark_settings_dirty then ui.mark_settings_dirty() end
    return true
end

-- 見出しの前の余白と、境目の区切り線。ImGui の Dummy / Separator だけ（描画中に公式の文字箱は作らない）。
local function fold_gap(ui)
    if #fold_items == 0 then return end
    local imgui = ui.imgui
    if imgui and imgui.Dummy then pcall(imgui.Dummy, { 1, 8 }) end
end

local function fold_rule(ui)
    local imgui = ui.imgui
    if imgui and imgui.Separator then pcall(imgui.Separator) end
end

local function fold_heading(ui, id, label)
    local name = 'settings'
    local S = ui.settings
    local wid = FOLD_PREFIX .. id
    fold_gap(ui)
    local open = not settings_ui.is_folded(S, id)
    local mark = open and '▾ ' or '▸ '
    local focused = focus.current(name) == wid
    local color = focused and 'accent' or 'heading'
    local before = focus.mark(name)
    if W.button(ui, name, wid, mark .. tostring(label or ''), { section = SEC, row = wid, color = color }) then
        -- マウスのクリックだけ開閉（決定は nav_action が見出しの中へ入る）
        settings_ui.set_folded(S, id, open, ui)
        open = not settings_ui.is_folded(S, id)
        focus.set(name, wid)
    end
    fold_rule(ui)
    local rec = { id = id, wid = wid, open = open, index = before + 1, children = {} }
    fold_items[#fold_items + 1] = rec
    return open, rec
end

local function fold_end(ui, rec)
    if not rec then return end
    local name = 'settings'
    local last = focus.mark(name)
    rec.children = {}
    if rec.open then
        for i = rec.index + 1, last do
            local id = focus.id_at(name, i)
            if id then rec.children[#rec.children + 1] = id end
        end
    end
    rec.first = rec.children[1]
    for _, id in ipairs(rec.children) do
        -- 行の先頭が ↺ のときは、本体の項目へ入る
        if not tostring(id):find('_reset$') then rec.first = id; break end
    end
end

-- 入力：見出しの上では左右で開閉、決定で中へ（閉じたままでは開かない）。中ではキャンセルで見出しへ。
function settings_ui.nav_action(action)
    local cur = focus.current('settings')
    if not cur then return false end
    local rec, inside
    for _, r in ipairs(fold_items) do
        if r.wid == cur then rec = r; break end
        for _, id in ipairs(r.children or {}) do
            if id == cur then inside = r; break end
        end
        if inside then break end
    end
    if rec then
        local S
        -- ui は描画時の settings と同じ表を app が持っている。fold_items の開閉は設定を直接触る
        -- 呼び出し側が S を渡さなくてよいよう、見出しの id から設定を探すのは app 経由ではなく
        -- 直近の描画で使った表を覚える
        S = settings_ui._fold_settings
        if action == 'left' then
            if rec.open and S then
                settings_ui.set_folded(S, rec.id, true, settings_ui._fold_ui)
                rec.open = false
                rec.children, rec.first = {}, nil
            end
            focus.set('settings', rec.wid)
            return true
        elseif action == 'right' then
            if (not rec.open) and S then
                settings_ui.set_folded(S, rec.id, false, settings_ui._fold_ui)
                rec.open = true
            end
            focus.set('settings', rec.wid)
            return true
        elseif action == 'confirm' then
            if rec.open and rec.first then
                focus.set('settings', rec.first, true)
            end
            -- 閉じていれば開かない（決定では開かない）
            return true
        end
        return false
    end
    if inside and action == 'back' then
        focus.set('settings', inside.wid, true)
        return true
    end
    return false
end


-- 本の中（一覧と詳細の場所）に設定を描く（0.1.175〜。本の book.draw から呼ぶ）
function settings_ui.body(ui)
    -- 0.1.304〜：どのテーマもアストラルと同じ並びの設定画面（settings_sf.body）。枠・色はテーマごと。
    -- 下の古い組み立て（折りたたみの見出しで並べる形）は、settings_sf が使えないときだけの控え
    do
        local ok_sf, sfmod = pcall(require, 'src.ui.settings_sf')
        if ok_sf and sfmod and sfmod.body then return sfmod.body(ui) end
    end
    local imgui, t, S = ui.imgui, ui.t, ui.settings
    local name = 'settings'
    fold_items = {}
    settings_ui._fold_settings = S
    settings_ui._fold_ui = ui
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
        local fold, frec
        fold, frec = fold_heading(ui, 'look_fonts', t('settings.fold_fonts'))
        if fold then
        S.fonts = S.fonts or {}
        for _, area in ipairs(settings_mod.FONT_AREAS) do
            if S.fonts[area] == nil then S.fonts[area] = settings_mod.font_for(S, area) end
            local lo, hi = settings_mod.font_range(area)
            stepper(ui, name, 'font_' .. area, t('settings.font_' .. area), S.fonts, area, 0.1, lo, hi, UNIT.pct, SEC, DEF.fonts[area])
            -- 0.1.234〜：タブの文字の大きさ（トラッカーの文字サイズのすぐ下）。未設定はトラッカーに追従
            if area == 'tracker' then
                local lo_t, hi_t = settings_mod.font_range('tracker')
                local follow = settings_mod.font_for(S, 'tracker')
                local proxy = { v = S.fonts.tracker_tabs }
                if proxy.v == nil then proxy.v = follow end
                if stepper(ui, name, 'font_tracker_tabs', t('settings.font_tracker_tabs'), proxy, 'v',
                    0.1, lo_t, hi_t, UNIT.pct, SEC, follow) then
                    local nv = tonumber(proxy.v)
                    if nv and math.abs(nv - follow) < 1e-6 then
                        S.fonts.tracker_tabs = nil
                    else
                        S.fonts.tracker_tabs = nv
                    end
                    ui.mark_settings_dirty()
                end
            end
        end
        stepper(ui, name, 'font', t('settings.font_other'), S, 'font_scale', 0.1, settings_mod.FONT_MIN, settings_mod.FONT_MAX, UNIT.pct, SEC, DEF.font_scale)
        W.muted(ui, t('settings.font_note'))
        toggle(ui, name, 'font_crisp', t('settings.font_crisp'), S, 'font_crisp', SEC)
        toggle(ui, name, 'font_crisp_bold', t('settings.font_crisp_bold'), S, 'font_crisp_bold', SEC)
        W.muted(ui, t('settings.font_crisp_note'))
        stepper(ui, name, 'font_crisp_outline', t('settings.font_crisp_outline'), S, 'font_crisp_outline',
            0.25, 0, 3, UNIT.fpx, SEC, DEF.font_crisp_outline)
        stepper(ui, name, 'font_crisp_outline_alpha', t('settings.font_crisp_outline_alpha'), S, 'font_crisp_outline_alpha',
            0.05, 0, 1, UNIT.pct, SEC, DEF.font_crisp_outline_alpha)
        W.muted(ui, t('settings.font_crisp_outline_note'))
        end
        fold_end(ui, frec)
        -- 背景の濃さも窓ごと（文字サイズと同じ並び）
        fold, frec = fold_heading(ui, 'look_alpha', t('settings.fold_alpha'))
        if fold then
        S.alphas = S.alphas or {}
        for _, area in ipairs(settings_mod.ALPHA_AREAS) do
          -- 設定は本の中に出すので（0.1.175〜）、設定だけの背景の濃さは出さない（値は残す）
          if area ~= 'settings' then
            if S.alphas[area] == nil then S.alphas[area] = settings_mod.alpha_for(S, area) end
            stepper(ui, name, 'alpha_' .. area, t('settings.alpha_' .. area), S.alphas, area, 0.05, 0.3, 1.0, UNIT.pct, SEC, DEF.alphas[area])
          end
        end
        W.muted(ui, t('settings.alpha_note'))
        do
            local look = (S.look == 'yunaui' or S.look == 'sf' or S.look == 'classic') and S.look or 'classic'
            if W.button(ui, name, 'look_style', t('settings.look_style', { v = t('settings.look_' .. look) }),
                { section = SEC, row = 'look_style' }) then
                S.look = theme.next_look(look)
                theme.set_look(S.look)
                ui.mark_settings_dirty()
            end
        end
        toggle(ui, name, 'motion', t('settings.reduce_motion'), S, 'reduce_motion', SEC, t('settings.reduce_motion_tip'))
        end
        fold_end(ui, frec)
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
        local fold, frec
        fold, frec = fold_heading(ui, 'tracker_main', t('settings.fold_tracker'))
        if fold then
        if toggle(ui, name, 'tr_vis', t('settings.tracker_visible'), S.tracker, 'visible', SEC) then
            if not S.tracker.visible and ui.release then ui.release() end
        end
        W.muted(ui, t('settings.tracker_visible_note'))
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
        end
        fold_end(ui, frec)
        -- コンパス（0.1.173〜）：いまいるエリアで受けられるクエストを近い順に
        fold, frec = fold_heading(ui, 'tracker_compass', t('settings.fold_compass'))
        if fold then
        if toggle(ui, name, 'compass_vis', t('settings.compass_visible'), S.compass, 'visible', SEC) and S.compass.visible
            and ui.set_compass_visible then ui.set_compass_visible(true) end
        stepper(ui, name, 'compass_range', t('settings.compass_range'), S.compass, 'max_dist', 5, 5, 100,
            unit(t('settings.unit_yalms')), SEC, DEF.compass.max_dist)
        end
        fold_end(ui, frec)
    end }
    SECTIONS[#SECTIONS + 1] = { key = 'map', title = t('settings.map'), draw = function ()
        toggle(ui, name, 'map_on', t('map.enabled'), S.map, 'enabled', SEC)
        if S.map.grid_alpha == nil then S.map.grid_alpha = 0.35 end
        stepper(ui, name, 'map_grid', t('map.grid_alpha'), S.map, 'grid_alpha', 0.05, 0, 1, UNIT.pct, SEC, 0.35)
        W.muted(ui, t('map.grid_alpha_help'))
        W.muted(ui, t('map.credit_note'))
    end }
    SECTIONS[#SECTIONS + 1] = { key = 'marks', title = t('settings.marks'), draw = function ()
        local fold, frec
        -- 表示のオン・オフは4つだけ（0.1.59〜）。それぞれ名前のとおりのものだけを動かす
        fold, frec = fold_heading(ui, 'marks_show', t('settings.fold_show'))
        if fold then
        toggle(ui, name, 'marks_icons', t('settings.marks_show_icons'), S.marks, 'show_icons', SEC)
        toggle(ui, name, 'marks_quest', t('settings.marks_show_quest_name'), S.marks, 'show_quest_name', SEC)
        toggle(ui, name, 'marks_objects', t('settings.marks_show_object_names'), S.marks, 'show_object_names', SEC)
        toggle(ui, name, 'marks_nearby', t('settings.marks_show_nearby'), S.marks, 'show_nearby_names', SEC)
        -- 0.1.302〜：近くのオブジェクト名の距離（5〜50 ヤルム）。オンのときだけ
        if S.marks.show_nearby_names then
            if type(S.marks.nearby_radius) ~= 'number' then S.marks.nearby_radius = settings_mod.NEARBY_RADIUS_DEFAULT end
            stepper(ui, name, 'marks_nearby_radius', t('settings.marks_nearby_radius'), S.marks, 'nearby_radius', 1,
                settings_mod.NEARBY_RADIUS_MIN, settings_mod.NEARBY_RADIUS_MAX, unit(t('settings.unit_yalms')), SEC, DEF.marks.nearby_radius)
            -- 説明（乗せる・パッドで選ぶ）
            local hov = ui.imgui.IsItemHovered and ui.imgui.IsItemHovered()
            if hov or (focus.current(name) == 'marks_nearby_radius' and focus.why(name) ~= 'hover') then
                W.tooltip(ui, t('settings.marks_nearby_radius_tip', { d = settings_mod.nearby_radius(S.marks) }))
            end
        end
        -- 名声を教えてくれる人のアイコン（0.1.69〜）。アイコンを表示するがオンのときだけ出る
        toggle(ui, name, 'marks_fame', t('settings.marks_show_fame'), S.marks, 'show_fame_npcs', SEC)
        W.muted(ui, t('settings.marks_switches_note', { d = settings_mod.nearby_radius(S.marks) }))
        stepper(ui, name, 'marks_icon', t('settings.marks_icon_size'), S.marks, 'icon_size', 4, 16, 64, UNIT.px, SEC, DEF.marks.icon_size)
        end
        fold_end(ui, frec)
        -- 位置の調整（px、＋で右・下）
        fold, frec = fold_heading(ui, 'marks_pos', t('settings.fold_pos'))
        if fold then
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
        toggle(ui, name, 'marks_no_enlarge', t('settings.marks_no_enlarge_near'), S.marks, 'no_enlarge_near', SEC)
        W.muted(ui, t('settings.marks_no_enlarge_near_note'))
        if W.button(ui, name, 'marks_pos_reset', t('settings.marks_pos_reset'), { section = SEC, row = 'marks_pos_reset', small = true }) then
            for _, k in ipairs(settings_mod.OFFSET_KEYS) do S.marks[k] = 0 end
            for _, k in ipairs(settings_mod.OBJ_OFFSET_KEYS) do S.marks[k] = 0 end
            for _, k in ipairs(settings_mod.NEAR_OFFSET_KEYS) do S.marks[k] = 0 end
            ui.mark_settings_dirty()
        end
        W.muted(ui, t('settings.marks_pos_note'))
        end
        fold_end(ui, frec)
        -- 文字の色（クエスト名・オブジェクト名。RGB それぞれ 0〜255、↺ で初めの色。グラデーションは左から右へ）
        local function color_block(which, sample)
            local M = S.marks
            local DM = DEF.marks
            W.heading(ui, t('settings.marks_color_' .. which))
            local c1, c2 = settings_mod.text_colors(M, which)
            local dir_key = which .. '_grad_dir'
            M[dir_key] = settings_mod.clamp_grad_dir(M[dir_key])
            local clear_key = which .. '_clear'
            M[clear_key] = settings_mod.clamp_clear(M[clear_key])
            W.color_preview(ui, sample, c1, c2, { dir = M[dir_key], clear = M[clear_key] })
            -- 0.1.326〜：フォントはクエスト名／オブジェクト名の枠の中（保存キーはそのまま）
            do
                local fkey = (which == 'under') and 'under_font' or 'label_font'
                local id = 'marks_' .. fkey
                local flabel = t('settings.' .. fkey)
                local info = t('settings.' .. fkey .. '_help')
                local cur = settings_mod.clamp_label_font(M[fkey])
                local choices, done, unavailable, n = settings_ui.label_font_choices(t, cur)
                local preview = t('settings.label_font_default')
                for _, it in ipairs(choices) do
                    if it.value == cur then preview = it.label or preview; break end
                end
                local tw = text_w(ui.imgui, tostring(preview)) or 0
                local defw = text_w(ui.imgui, t('settings.label_font_default')) or 0
                local cw = math.max(240, math.ceil(math.max(tw, defw) + 36))
                local imgui = ui.imgui
                imgui.Text(flabel)
                if info and info ~= '' then
                    pcall(imgui.SameLine, 0, 6)
                    W.info_mark(ui, name .. '/' .. id, info)
                end
                local changed, v = W.combo(ui, name, id, nil, cur, choices, { section = SEC, row = id, width = cw })
                if changed then
                    M[fkey] = settings_mod.clamp_label_font(v)
                    ui.mark_settings_dirty()
                end
                if not done then
                    W.muted(ui, t('settings.label_font_loading', { n = n }))
                elseif unavailable then
                    W.muted(ui, t('settings.label_font_unavailable'))
                end
            end
            local function pick(key, label, ck, bgk)
                local w = text_w(ui.imgui, label)
                if w and w > label_w_next then label_w_next = w end
                W.color_row(ui, name, 'marks_' .. key, label, M, key, DM[key], {
                    section = SEC, row = 'marks_' .. key,
                    label_w = label_w and (label_w + 20) or nil,
                    tooltip_reset = t('settings.reset_default'),
                    clear_key = ck,
                    alpha_key = bgk, show_clear = bgk ~= nil,
                })
            end
            -- 0.1.318〜：メインの色（始めの色）の色えらびにだけ透明度の帯
            pick(which .. '_color', t('settings.color_start'), clear_key)
            toggle(ui, name, 'marks_' .. which .. '_grad', t('settings.color_gradient'), M, which .. '_grad', SEC)
            if M[which .. '_grad'] then
                local dv = M[dir_key]
                if W.button(ui, name, 'marks_' .. dir_key, t('settings.color_grad_dir') .. '：' .. t('settings.color_grad_dir_' .. dv),
                    { section = SEC, row = 'marks_' .. dir_key }) then
                    M[dir_key] = (dv == 'down') and 'across' or 'down'
                    ui.mark_settings_dirty()
                end
                pick(which .. '_color2', t('settings.color_end'))
            end
            -- 0.1.317〜：文字の透明度は 1 つ（始めの色と終わりの色の両方に効く）
            stepper(ui, name, 'marks_' .. clear_key, t('settings.color_clear'), M, clear_key, 0.05, 0, 1, UNIT.pct, SEC, 0)
            if W.button(ui, name, 'marks_' .. which .. '_all_reset', t('settings.color_reset'),
                { section = SEC, row = 'marks_' .. which .. '_all_reset', small = true }) then
                for _, k in ipairs({ which .. '_color', which .. '_color2', which .. '_bg_color', which .. '_bg_color2' }) do
                    if DM[k] then M[k] = { DM[k][1], DM[k][2], DM[k][3] } end
                end
                M[which .. '_grad'] = false
                M[which .. '_bg_grad'] = false
                M[which .. '_stroke'] = DM[which .. '_stroke'] or 1
                M[which .. '_stroke_alpha'] = DM[which .. '_stroke_alpha'] or 1
                M[which .. '_grad_dir'] = 'across'
                M[which .. '_bg_grad_dir'] = 'across'
                M[which .. '_clear'] = 0
                ui.mark_settings_dirty()
            end
            -- 頭上の文字の背景の濃さ（0.1.215〜）。クエスト名とオブジェクト名で別
            local bg_key = which .. '_bg_alpha'
            if type(M[bg_key]) ~= 'number' then M[bg_key] = settings_mod.LABEL_BG_ALPHA_DEFAULT end
            -- 0.1.318〜：「透明度」（1 - 濃さ）で見せる。保存は濃さのまま
            local inv = { v = math.floor((1 - M[bg_key]) * 100 + 0.5) / 100 }
            if stepper(ui, name, 'marks_' .. bg_key, t('settings.marks_' .. bg_key), inv, 'v',
                0.05, 1 - settings_mod.LABEL_BG_ALPHA_MAX, 1 - settings_mod.LABEL_BG_ALPHA_MIN,
                UNIT.pct, SEC, math.floor((1 - DM[bg_key]) * 100 + 0.5) / 100) or math.abs((1 - inv.v) - M[bg_key]) > 0.001 then
                M[bg_key] = math.floor((1 - inv.v) * 100 + 0.5) / 100
                ui.mark_settings_dirty()
            end
            pick(which .. '_bg_color', t('settings.marks_' .. which .. '_bg_color'), nil, bg_key)
            toggle(ui, name, 'marks_' .. which .. '_bg_grad', t('settings.marks_' .. which .. '_bg_grad'),
                M, which .. '_bg_grad', SEC)
            if M[which .. '_bg_grad'] then
                local bdir = which .. '_bg_grad_dir'
                M[bdir] = settings_mod.clamp_grad_dir(M[bdir])
                local bdv = M[bdir]
                if W.button(ui, name, 'marks_' .. bdir, t('settings.color_grad_dir') .. '：' .. t('settings.color_grad_dir_' .. bdv),
                    { section = SEC, row = 'marks_' .. bdir }) then
                    M[bdir] = (bdv == 'down') and 'across' or 'down'
                    ui.mark_settings_dirty()
                end
                pick(which .. '_bg_color2', t('settings.marks_' .. which .. '_bg_color2'))
            end
            local sk = which .. '_stroke'
            if type(M[sk]) ~= 'number' then M[sk] = settings_mod.STROKE_DEFAULT or 1 end
            stepper(ui, name, 'marks_' .. sk, t('settings.marks_' .. sk), M, sk, 1,
                settings_mod.STROKE_MIN, settings_mod.STROKE_MAX, UNIT.px, SEC, DM[sk])
            local sak = which .. '_stroke_alpha'
            if type(M[sak]) ~= 'number' then M[sak] = 1 end
            stepper(ui, name, 'marks_' .. sak, t('settings.marks_' .. sak), M, sak, 0.05,
                0, 1, UNIT.pct, SEC, DM[sak] or 1)
        end
        fold, frec = fold_heading(ui, 'marks_quest', t('settings.fold_quest_name'))
        if fold then
        color_block('label', t('settings.color_sample_label'))
        W.muted(ui, t('settings.color_note'))
        W.muted(ui, t('settings.marks_bg_alpha_note'))
        W.muted(ui, t('settings.marks_bg_color_note'))
        end
        fold_end(ui, frec)
        fold, frec = fold_heading(ui, 'marks_object', t('settings.fold_object_name'))
        if fold then
        color_block('under', '???')
        W.muted(ui, t('settings.color_note'))
        W.muted(ui, t('settings.marks_bg_alpha_note'))
        W.muted(ui, t('settings.marks_bg_color_note'))
        end
        fold_end(ui, frec)
        -- 足元の輪（0.1.171〜）：オンオフ・大きさ・種類ごとの色（初めの色は今のアイコンの色）
        fold, frec = fold_heading(ui, 'marks_rings', t('settings.fold_rings'))
        if fold then
        do
            local M, DM = S.marks, DEF.marks
            toggle(ui, name, 'marks_rings', t('settings.rings_show'), M, 'show_rings', SEC)
            stepper(ui, name, 'marks_ring_size', t('settings.rings_size'), M, 'ring_size', 0.1,
                settings_mod.RING_SIZE_MIN, settings_mod.RING_SIZE_MAX, UNIT.pct, SEC, DM.ring_size)
            if type(M.ring_strength) ~= 'number' then M.ring_strength = settings_mod.RING_STRENGTH_DEFAULT or 1 end
            stepper(ui, name, 'marks_ring_strength', t('settings.rings_strength'), M, 'ring_strength', 0.1,
                settings_mod.RING_STRENGTH_MIN, settings_mod.RING_STRENGTH_MAX, nil, SEC, DM.ring_strength)
            W.muted(ui, t('settings.rings_strength_note'))
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
        end
        fold_end(ui, frec)
        W.muted(ui, t('settings.marks_note'))
        if caps.marks_project == false then
            W.muted(ui, t('settings.marks_no_project'))
        end
    end }
    SECTIONS[#SECTIONS + 1] = { key = 'notify', title = t('settings.notify'), draw = function ()
        local N = S.notify
        local fold, frec
        -- ログイン時の続き（と表示秒数）は 0.1.303 でなくした
        -- 受注・完了のお知らせと効果音（0.1.183〜、t295）
        fold, frec = fold_heading(ui, 'notify_popup', t('settings.fold_popup'))
        if fold then
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
        end
        fold_end(ui, frec)
        -- エリア入場の「いまここで進めること」とミュートは 0.1.173 でなくした（t251）
    end }
    SECTIONS[#SECTIONS + 1] = { key = 'input', title = t('settings.input'), draw = function ()
        local fold, frec
        fold, frec = fold_heading(ui, 'input_pad', t('settings.fold_pad'))
        if fold then
        toggle(ui, name, 'pad', t('settings.gamepad'), S.input, 'gamepad', SEC)
        stepper(ui, name, 'repeat', t('settings.repeat_ms'), S.input, 'repeat_ms', 20, 60, 1000, unit('ms'), SEC, DEF.input.repeat_ms)
        W.muted(ui, t('settings.input_note'))
        W.muted(ui, t('settings.pad_state', { v = caps.gamepad_note or '?' }))
        end
        fold_end(ui, frec)
        -- パッドのショートカット（0.1.57〜。0.1.61〜は「操作」の中。0.1.194〜はエミネンス・コンパスも）。押すとボタン待ち、全部離すと決まる
        fold, frec = fold_heading(ui, 'input_shortcut', t('settings.fold_shortcut'))
        if fold then
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
        end
        fold_end(ui, frec)
        -- ゲームのメニュー（0.1.67〜は「操作」の中。前は別のタブ）
        fold, frec = fold_heading(ui, 'input_gameui', t('settings.fold_gameui'))
        if fold then
        W.colored(ui, 'accent', t('settings.gameui'))
        toggle(ui, name, 'g_mission', t('settings.gameui_mission_book'), S.gameui, 'mission_book', SEC)
        toggle(ui, name, 'g_config', t('settings.gameui_config_button'), S.gameui, 'config_button', SEC)
        toggle(ui, name, 'g_capture', t('settings.gameui_capture'), S.gameui, 'capture', SEC)
        toggle(ui, name, 'g_ontop', t('settings.gameui_menus_on_top'), S.gameui, 'menus_on_top', SEC)
        -- 0.1.301〜：メニューと重なったとき（隠す／メニューの後ろに出す）
        do
            local ov = (S.gameui.menu_overlap == 'behind') and 'behind' or 'hide'
            if W.button(ui, name, 'g_overlap', t('settings.menu_overlap') .. '：' .. t('settings.menu_overlap_' .. ov),
                { section = SEC, row = 'g_overlap' }) then
                S.gameui.menu_overlap = (ov == 'hide') and 'behind' or 'hide'
                ui.mark_settings_dirty()
            end
            -- 説明は読みやすいツールチップで（乗せたとき・パッドで選んだとき）
            local hov = ui.imgui.IsItemHovered and ui.imgui.IsItemHovered()
            if hov or focus.current(name) == 'g_overlap' then W.tooltip(ui, t('settings.menu_overlap_tip')) end
        end
        -- 隠す場面（0.1.296〜。0.1.308〜は表示から、メニューと重なったときの下へ）
        require('src.ui.hide_scenes_ui').draw(ui, name, {
            toggle = function (u, n, id, label, tbl, key, info) return toggle(u, n, id, label, tbl, key, SEC, info) end,
            help = function (text) W.muted(ui, text) end,
            subhead = function (text) W.heading(ui, text) end,
            section = SEC,
        })
        if ui.state.gameui_note then W.muted(ui, ui.state.gameui_note) end
        W.muted(ui, t('settings.gameui_note'))
        end
        fold_end(ui, frec)
    end }
    SECTIONS[#SECTIONS + 1] = { key = 'save', title = t('settings.save'), draw = function ()
        local fold, frec
        fold, frec = fold_heading(ui, 'save_backup', t('settings.fold_backup'))
        if fold then
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
        end
        fold_end(ui, frec)
        -- マイレイアウト（0.1.194〜）：5つ。各窓の位置・大きさと設定を覚える（進行・ピンなどは入れない）
        fold, frec = fold_heading(ui, 'save_layout', t('settings.fold_layouts'))
        if fold then
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
            local ime = require('src.ui.ime_input')
            local edited = imgui.InputTextWithHint(ime.label('##astertrail_' .. id), t('settings.layout_placeholder', { n = tostring(i) }), buf, 40)
            if ime.field(ui, imgui, '##astertrail_' .. id, buf, 40) then edited = true end
            if edited then
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
        end
        if W.button(ui, name, 'reset_unstarted', t('settings.reset_unstarted'), { section = SEC, row = 'reset_unstarted' }) then
            if ui.revert_unstarted then ui.revert_unstarted() end
        end
        W.muted(ui, t('settings.reset_unstarted_note'))
        fold_end(ui, frec)
        -- デバッグ（0.1.187〜、t308）。公開版には出さない
        if ui.manual_checks == nil or ui.manual_checks() then
            fold, frec = fold_heading(ui, 'save_debug', t('settings.fold_debug'))
            if fold then
            W.colored(ui, 'accent', t('settings.debug'))
            S.debug = S.debug or { state_buttons = false }
            toggle(ui, name, 'dbg_state', t('settings.debug_state_buttons'), S.debug, 'state_buttons', SEC)
            W.muted(ui, t('settings.debug_note'))
            end
            fold_end(ui, frec)
        end
    end }
    -- エミネンス（0.1.172〜）
    SECTIONS[#SECTIONS + 1] = { key = 'eminence', title = t('settings.eminence'), draw = function ()
        -- 窓の出す・隠すは本の上の行のボタンだけ（0.1.182〜、t293。ここのスイッチはなくした）
        toggle(ui, name, 'roe_fold', t('settings.roe_collapsed'), S.eminence, 'collapsed', SEC)
        -- 0.1.294〜：サーバーに入っていないと分かっているものに未実装の札（初期オン）
        if S.eminence.known_unimpl == nil then S.eminence.known_unimpl = true end
        toggle(ui, name, 'roe_known_unimpl', t('settings.roe_known_unimpl'), S.eminence, 'known_unimpl', SEC)
        W.muted(ui, t('settings.roe_known_unimpl_note'))
        -- 達成間近の目安は、窓の達成間近のタブをなくしたので出さない（0.1.177〜。値は残す）
        -- 0.1.226〜：「本で達成したものを隠す」はやめた（本の「表示：☑達成」に移した）
        W.muted(ui, t('settings.roe_note'))
    end }
    SECTIONS[#SECTIONS + 1] = { key = 'about', title = t('about.title'), draw = function ()
        W.muted(ui, 'Based on YunaUI by Yunas - https://github.com/YunasXI/yunaui')
        W.muted(ui, t('about.license'))
        W.muted(ui, t('about.font_melete'))
        W.muted(ui, t('about.version', { v = ui.addon_version, d = ui.data.version or '?' }))
        -- 0.1.297〜：更新（様子・今すぐ確認・前のバージョンに戻す）
        W.heading(ui, t('settings.update_title'))
        require('src.ui.update_panel_ui').draw(ui, name, {
            toggle = function (u, n, id, label, tbl, key, info) return toggle(u, n, id, label, tbl, key, SEC, info) end,
            text = function (s) W.muted(ui, s) end,
            button = function (n, id, label, o)
                o = o or {}
                return W.button(ui, n, id, label, { section = SEC, row = id, disabled = o.disabled, tooltip = o.tooltip })
            end,
        })
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
        W.muted(ui, t('settings.fold_note'))
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
            local hid = W.hide_item_text(imgui)
            local clicked = imgui.Button(label .. '##st_' .. sec.key)
            W.show_item_text(imgui, hid)
            W.overlay_item_text(imgui, label, 'text', 'center')
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
