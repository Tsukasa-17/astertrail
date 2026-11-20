--[[
  Astertrail - 窓の開け閉めと位置・大きさの記憶
  - 位置・大きさは窓ごとに覚え、文字サイズ（font_scale）とは別に扱う。
  - 文字サイズを変えても、利用者が決めた窓の大きさは変えない。
  - くっきりフォント（0.1.246）が使える窓は PushFont。使えないときはこれまでどおり SetWindowFontScale。
]]

local theme = require('src.ui.theme')
local focus = require('src.ui.focus')
local settings_mod = require('src.core.settings')
local crisp_font = require('src.ui.crisp_font')
local crisp_outline = require('src.ui.crisp_outline')

local window = {}

local DEFAULTS = {
    -- 画面に対する割合（中心）と既定の大きさ
    -- 本は左に一覧・右に詳細を並べるので広め（保存済みの大きさがあればそちらを使う）
    book     = { fx = 0.50, fy = 0.45, w = 1000, h = 600 },
    detail   = { fx = 0.72, fy = 0.45, w = 520, h = 620 },
    tracker  = { fx = 0.86, fy = 0.30, w = 360, h = 280 },
    settings = { fx = 0.50, fy = 0.50, w = 520, h = 620 },
    map      = { fx = 0.62, fy = 0.48, w = 680, h = 820 },
    entry    = { fx = 0.97, fy = 0.60, auto = true },
    resume   = { fx = 0.50, fy = 0.18, auto = true },
    popup    = { fx = 0.50, fy = 0.28, auto = true },   -- 受注・完了のお知らせ（0.1.183〜。0.1.197〜は大きめ）
    update   = { fx = 0.50, fy = 0.28, auto = true },   -- 新しい版のダウンロード（0.1.282〜）
    eminence = { fx = 0.14, fy = 0.40, w = 380, h = 320 },   -- 0.1.172〜
    compass  = { fx = 0.14, fy = 0.72, w = 400, h = 240 },   -- 0.1.173〜
}
window.DEFAULTS = DEFAULTS

-- 窓ごとの文字の大きさの場所。ここに無い窓（設定・お知らせ・入口）は「その他」。
-- エミネンス（0.1.172〜）とコンパス（0.1.173〜）の窓はトラッカーと同じ文字の大きさ
local FONT_AREA = { book = 'book', detail = 'detail', tracker = 'tracker', map = 'map', eminence = 'eminence', compass = 'tracker' }
window.FONT_AREA = FONT_AREA

function window.font_scale(ui, name)
    local area = FONT_AREA[name]
    if area then return settings_mod.font_for(ui.settings, area) end
    return tonumber(ui.settings.font_scale) or 1.0
end

local function display_size(imgui)
    local ok, io = pcall(imgui.GetIO)
    if ok and io and io.DisplaySize then
        local w, h = io.DisplaySize.x, io.DisplaySize.y
        if w and h and w > 0 and h > 0 then return w, h end
    end
    return 1280, 720
end
window.display_size = display_size

local applied = {}

function window.reapply(name)
    if name then applied[name] = nil else applied = {} end
end

--[[
  opts: { title, open (table {bool}) or nil, flags, operable (bool), no_title, auto }
  戻り値: drawing (bool) — false なら中身を描かない（End は呼ぶ）
]]
local open_tables = {}   -- 開閉の表を渡さない窓のための、窓ごとの { true }

--[[ ゲームのメニューに譲る（0.1.189〜、t315）
  ゲームのメニュー（ホームポイント・店・選択肢・アイテムなど）が開いている間、その窓と重なるこちらの窓は
  透明にしてマウスも通す（閉じたら戻す）。どの窓（本・設定・詳細・トラッカー・地図・エミネンス・コンパス・
  お知らせ・続き・入口）もここを通るので、同じ動きになる。重なりは前のフレームの場所で見る。 ]]
local last_rect = {}     -- 窓の名前 → { x, y, w, h }（前のフレーム）
local yielded = {}       -- 窓の名前 → true（いま譲っている）

function window.overlaps(a, b)
    return a.x < b.x + b.w and b.x < a.x + a.w and a.y < b.y + b.h and b.y < a.y + a.h
end

function window.yields(ui, name)
    local rects = ui.state and ui.state.game_menu_rects
    if type(rects) ~= 'table' or #rects == 0 then return false end
    local r = last_rect[name]
    if not r then return false end
    for _, m in ipairs(rects) do
        if window.overlaps(r, m) then return true end
    end
    return false
end

-- いま譲っている窓の名前（並びは決まった順）
function window.yielding()
    local out = {}
    for n, on in pairs(yielded) do if on then out[#out + 1] = n end end
    table.sort(out)
    return out
end
function window._last_rect(name) return last_rect[name] end   -- 開発用
function window._reset_yield() last_rect = {}; yielded = {} end   -- 開発用

local ELLIPSIS = '…'

local function parse_xy(a, b)
    if type(a) == 'table' then
        return tonumber(a.x or a[1]), tonumber(a.y or a[2])
    end
    return tonumber(a), tonumber(b)
end

local function text_size(imgui, text)
    if not imgui or type(imgui.CalcTextSize) ~= 'function' then return nil, nil end
    local ok, a, b = pcall(imgui.CalcTextSize, text)
    if not ok then return nil, nil end
    return parse_xy(a, b)
end

-- 1 行に収める。入りきらなければ末尾を「…」にする（折り返さない）
function window.clip_line(imgui, text, max_w)
    text = tostring(text or '')
    max_w = tonumber(max_w) or 0
    if text == '' or max_w <= 0 then return '', text ~= '' end
    local w = text_size(imgui, text)
    if not w or w <= max_w then return text, false end
    local ew = text_size(imgui, ELLIPSIS) or 8
    if ew >= max_w then return ELLIPSIS, true end
    local budget = max_w - ew
    local acc, aw = '', 0
    for ch in text:gmatch('[%z\1-\127\194-\244][\128-\191]*') do
        local cw = text_size(imgui, ch) or 0
        if aw + cw > budget then break end
        acc, aw = acc .. ch, aw + cw
    end
    if acc == '' then return ELLIPSIS, true end
    return acc .. ELLIPSIS, true
end

-- 窓の見出しの帯に、緑色の短い案内をタイトルの右隣へ描く（0.1.233〜）。中身の行は動かない。
function window.draw_title_flash(ui, title, px, py, sw, sh)
    local flash = ui and ui.state and ui.state.flash
    local text = flash and flash.text
    if type(text) ~= 'string' or text == '' then return end
    local imgui = ui.imgui
    if not imgui then return end
    px, py = parse_xy(px, py)
    sw, sh = parse_xy(sw, sh)
    if not (px and py and sw) then
        local okp, a, b = pcall(function () return imgui.GetWindowPos() end)
        if okp then px, py = parse_xy(a, b) end
        local oks, c, d = pcall(function () return imgui.GetWindowSize() end)
        if oks then sw, sh = parse_xy(c, d) end
    end
    if not (px and py and sw) then return end
    local bar_h = 19
    if imgui.GetFrameHeight then
        local ok, v = pcall(imgui.GetFrameHeight)
        v = ok and tonumber(v) or nil
        if v and v > 0 then bar_h = v end
    elseif imgui.GetFontSize then
        local ok, v = pcall(imgui.GetFontSize)
        v = ok and tonumber(v) or nil
        if v and v > 0 then bar_h = v + 8 end
    end
    local pad = 8
    local title_w = text_size(imgui, tostring(title or '')) or 0
    local x = px + pad + title_w + 10
    local right = px + sw - bar_h - pad
    local max_w = right - x
    if max_w < 8 then return end
    local shown = window.clip_line(imgui, text, max_w)
    if shown == '' then return end
    local tw, th = text_size(imgui, shown)
    th = th or 16
    local y = py + math.max(0, (bar_h - th) / 2)
    local okd, dl = pcall(imgui.GetWindowDrawList)
    if not okd or not dl or not dl.AddText then return end
    local col = theme.u32('good', 1)
    pcall(function ()
        if dl.PushClipRect then dl:PushClipRect({ x, py }, { right, py + bar_h }, true) end
        local outline = package.loaded['src.ui.crisp_outline']
        if outline and outline.active and outline.active() and outline.paint_at then
            outline.paint_at(imgui, x, y, shown)
        end
        dl:AddText({ x, y }, col, shown)
        if dl.PopClipRect then dl:PopClipRect() end
    end)
end

-- くっきりフォントを使う窓（本・トラッカー・コンパス・エミネンス・設定。詳細は本の一部）
local CRISP_WINS = {
    book = true, detail = true, tracker = true, compass = true, eminence = true, settings = true,
    popup = true, resume = true,
}

local function release_crisp(ui)
    crisp_outline.leave()
    if ui and ui._crisp_pushed then
        crisp_font.pop(ui.imgui)
        ui._crisp_pushed = false
    end
end

-- scale を指定の大きさとして出す。くっきりが使えれば PushFont（引き伸ばさない）。
local function apply_font(ui, scale, opts)
    local imgui = ui and ui.imgui
    if not imgui then return end
    scale = tonumber(scale) or 1.0
    if ui._crisp_pushed then
        crisp_font.pop(imgui)
        ui._crisp_pushed = false
    end
    -- 昔の呼び出しは第3引数に bold（boolean）を渡すことがある
    if type(opts) == 'boolean' then
        opts = { bold = opts }
    elseif type(opts) ~= 'table' then
        opts = nil
    end
    local name = ui._crisp_win
    if name and CRISP_WINS[name] then
        -- SF の英語見出し：同梱フォント。失敗したら今のくっきりフォントへ。
        if opts and opts.heading and crisp_font.push_heading and crisp_font.push_heading(imgui, ui.settings, ui._font_base, scale) then
            ui._crisp_pushed = true
            return
        end
        if crisp_font.push(imgui, ui.settings, ui._font_base, scale, opts) then
            ui._crisp_pushed = true
            return
        end
    end
    -- 今までの倍率（フォールバック）
    if not imgui.SetWindowFontScale then return end
    local base = ui._font_base
    if base and base > 0 and imgui.GetFontSize then
        pcall(imgui.SetWindowFontScale, 1.0)
        local ok, s1 = pcall(imgui.GetFontSize)
        s1 = ok and tonumber(s1) or nil
        if s1 and s1 > 0 then
            local inherited = s1 / base
            if inherited > 0.05 then
                pcall(imgui.SetWindowFontScale, scale / inherited)
                return
            end
        end
    end
    pcall(imgui.SetWindowFontScale, scale)
end

function window.begin(ui, name, opts)
    local imgui = ui.imgui
    local C = theme.C
    local ws = ui.settings.windows[name]
    if not ws then ws = {}; ui.settings.windows[name] = ws end
    local d = DEFAULTS[name] or { fx = 0.5, fy = 0.5, w = 400, h = 300 }
    local dw, dh = display_size(imgui)

    local anim = opts.anim
    if not applied[name] or (anim and anim.lock_pos) then
        if not applied[name] then applied[name] = true end
        local w = ws.w or d.w
        local h = ws.h or d.h
        local x = (anim and anim.rest_x) or ws.x
        local y = (anim and anim.rest_y) or ws.y
        if x == nil or y == nil then
            x = dw * d.fx - (w or 200) / 2
            y = dh * d.fy - (h or 100) / 2
            if d.auto then x = dw * d.fx - 120; y = dh * d.fy end
        end
        -- 画面の外に出ていたら内側へ
        x = math.max(0, math.min(x, dw - 60))
        y = math.max(0, math.min(y, dh - 40))
        if anim then
            x = x + (tonumber(anim.ox) or 0)
            y = y + (tonumber(anim.oy) or 0)
        end
        imgui.SetNextWindowPos({ x, y }, C('ImGuiCond_Always'))
        if not d.auto and w and h and not (anim and anim.lock_pos) then
            imgui.SetNextWindowSize({ w, h }, C('ImGuiCond_Always'))
        end
    end

    -- 地図の窓は画面いっぱいまで引き延ばせる
    if name == 'map' then
        pcall(function ()
            imgui.SetNextWindowSizeConstraints({ 320, 400 }, { math.max(dw, 320), math.max(dh, 400) })
        end)
    end

    local flags = C('ImGuiWindowFlags_NoCollapse') + C('ImGuiWindowFlags_NoSavedSettings') +
        C('ImGuiWindowFlags_NoNavInputs') + C('ImGuiWindowFlags_NoNavFocus')
    if ui.settings.layout_locked then
        flags = flags + C('ImGuiWindowFlags_NoMove') + C('ImGuiWindowFlags_NoResize')
    end
    if opts.no_title then
        flags = flags + C('ImGuiWindowFlags_NoTitleBar')
        -- 見出しの無い窓は、前にたたまれたままの状態が残っていても必ず開いて描く（0.1.63〜）
        if imgui.SetNextWindowCollapsed then
            pcall(imgui.SetNextWindowCollapsed, false, C('ImGuiCond_Always'))
        end
    end
    if d.auto then
        flags = flags + C('ImGuiWindowFlags_AlwaysAutoResize')
        if not (ui.settings.layout_locked) then
            -- 自動の大きさの窓は大きさを変えない
        end
    end
    if opts.no_focus then flags = flags + C('ImGuiWindowFlags_NoFocusOnAppearing') end
    -- 横にはみ出す窓（コンパス、0.1.177〜）：狭いときは横のスクロールバー
    if opts.hscroll then flags = flags + C('ImGuiWindowFlags_HorizontalScrollbar') end
    -- 上の行（タブなど）をいつも見せる窓：窓そのものは動かさず、中の子の窓だけが動く
    if opts.fixed_top then
        flags = flags + C('ImGuiWindowFlags_NoScrollbar') + C('ImGuiWindowFlags_NoScrollWithMouse')
    end
    local yield = window.yields(ui, name)
    yielded[name] = yield or nil
    if yield then flags = flags + C('ImGuiWindowFlags_NoMouseInputs') end

    theme.set_look(ui.settings.look)
    local alpha = tonumber(opts.bg_alpha) or settings_mod.alpha_for(ui.settings, name)
    if opts.glass then alpha = tonumber(opts.bg_alpha) or 0.42 end
    local ncol, nvar = theme.push(imgui, alpha)
    local sf_frame = theme.look == 'sf' and (opts.no_title or opts.sf_frame) and not opts.glass
    if sf_frame then
        -- 公式の四角い地は出さず、角を切った枠をあとから描く
        imgui.PushStyleColor(C('ImGuiCol_WindowBg'), { 0, 0, 0, 0 })
        ncol = ncol + 1
    end
    if opts.glass then
        -- 地は自分で描く（ゲームの画面が透ける）。見出しの帯は出さない
        imgui.PushStyleColor(C('ImGuiCol_WindowBg'), { 0, 0, 0, 0 })
        imgui.PushStyleColor(C('ImGuiCol_Border'), { 0, 0, 0, 0 })
        ncol = ncol + 2
        imgui.PushStyleVar(C('ImGuiStyleVar_WindowBorderSize'), 0)
        imgui.PushStyleVar(C('ImGuiStyleVar_WindowRounding'), 16)
        imgui.PushStyleVar(C('ImGuiStyleVar_WindowPadding'), { 26, 22 })
        nvar = nvar + 3
    end
    if anim and tonumber(anim.a) and anim.a < 0.999 then
        imgui.PushStyleVar(C('ImGuiStyleVar_Alpha'), math.max(0, math.min(1, anim.a)))
        nvar = nvar + 1
    end
    -- YunaUI 風のミニマップのふち（いまはトラッカーだけ）：地とふちの形を合わせる
    local capsule = opts.frame == 'capsule' and theme.look == 'yunaui'
    local cap_s
    if capsule then
        cap_s = theme.capsule_scale(window.font_scale(ui, name))
        local c2, v2 = theme.push_capsule(imgui, alpha, cap_s)
        ncol, nvar = ncol + c2, nvar + v2
    end
    if yield then
        -- 透明に（中身も地も描かない）。ふつうに作るので、閉じたらすぐ元のとおりに出る
        imgui.PushStyleVar(C('ImGuiStyleVar_Alpha'), 0.0)
        nvar = nvar + 1
    end
    window.push(ui, 'style', ncol, nvar)
    local title = (opts.title or name) .. '###astertrail_' .. name
    -- 開閉の表は必ず渡す（0.1.64〜）。nil を渡すと、実機の ImGui（Ashita/VanaCore）は flags まで
    -- 無視して、見出しの帯（▼ とタイトル）を出してしまう。見出しの無い窓は × も出ない
    local open = opts.open
    if not open then
        open_tables[name] = open_tables[name] or { true }
        open = open_tables[name]
        open[1] = true
    end
    local drawing = imgui.Begin(title, open, flags)
    window.push(ui, 'window')
    -- 倍率 1 のときの文字の高さを測っておく（子の窓で、親の倍率に関係なく同じ大きさにするため）
    pcall(imgui.SetWindowFontScale, 1.0)
    if imgui.GetFontSize then
        local fok, fsz = pcall(imgui.GetFontSize)
        fsz = fok and tonumber(fsz) or nil
        if fsz and fsz > 0 then ui._font_base = fsz end
    end
    ui._crisp_win = name
    apply_font(ui, window.font_scale(ui, name))
    crisp_outline.enter(ui, name)
    -- 通常メニューの縁取り・影（0.1.236〜）。斜体フォントは読まない
    theme.set_text_fx(ui.settings)
    if theme.set_body_area then theme.set_body_area(FONT_AREA[name] or name) end
    if capsule and drawing then
        pcall(theme.draw_capsule, imgui, name, cap_s, ui.settings.reduce_motion)
    end
    if opts.glass and drawing then
        local gopts = {
            scale = anim and tonumber(anim.scale) or 1,
            alpha = anim and tonumber(anim.a) or 1,
            reduce_motion = ui.settings and ui.settings.reduce_motion,
        }
        -- SF はシアンのガラス枠。クラシック／YunaUI は従来のガラスのまま（0.1.280〜）
        if theme.is_sf and theme.is_sf() then
            pcall(function ()
                require('src.ui.sf_style').draw_popup(imgui, opts.glass_kind or 'accept', gopts)
            end)
        else
            pcall(theme.draw_popup_glass, imgui, opts.glass_kind or 'accept', gopts)
        end
    end
    if sf_frame and drawing then
        pcall(function ()
            require('src.ui.sf_style').draw_window(imgui, {
                alpha = alpha,
                reduce_motion = ui.settings and ui.settings.reduce_motion,
            })
        end)
    end

    -- 位置と大きさを覚える（動かした・変えた時だけ）
    local px, py = imgui.GetWindowPos()
    local sw, sh = imgui.GetWindowSize()
    if px and py and sw and sh then last_rect[name] = { x = px, y = py, w = sw, h = sh } end
    -- 緑色の短い案内は見出しの帯へ（0.1.233〜）。本・設定・詳細・地図。タイトルの無い窓には出さない。
    if drawing and not opts.no_title and not yield and (name == 'book' or name == 'settings' or name == 'detail' or name == 'map') then
        window.draw_title_flash(ui, opts.title, px, py, sw, sh)
    end
    -- ふわっと出る間は、ずらした位置を記憶しない（ずれたまま固まらないように）
    if anim and anim.lock_pos then
        -- 通すだけ
    elseif px and py then
        if ws.x ~= px or ws.y ~= py then
            if ws.x ~= nil and (math.abs((ws.x or 0) - px) > 0.5 or math.abs((ws.y or 0) - py) > 0.5) then
                ui.mark_settings_dirty()
            elseif ws.x == nil then
                ui.mark_settings_dirty()
            end
            ws.x, ws.y = math.floor(px + 0.5), math.floor(py + 0.5)
        end
        if not d.auto and sw and sh then
            local nw, nh = math.floor(sw + 0.5), math.floor(sh + 0.5)
            if ws.w ~= nw or ws.h ~= nh then
                ws.w, ws.h = nw, nh
                ui.mark_settings_dirty()
            end
        end
    end

    -- マウスでこの窓を押したら、この窓を「操作中」にする（操作できる窓だけ）
    if opts.operable and imgui.IsWindowHovered(C('ImGuiHoveredFlags_ChildWindows')) and imgui.IsMouseClicked(0) then
        ui.activate(name)
    end
    if imgui.IsWindowHovered(C('ImGuiHoveredFlags_ChildWindows')) then
        ui.hovered_any = true
        ui.win_hover = ui.win_hover or {}
        ui.win_hover[name] = true
    end
    -- フォーカス（子窓も含む）。Esc で閉じる判定に使う（0.1.282〜）
    do
        local okf, foc = pcall(imgui.IsWindowFocused, C('ImGuiFocusedFlags_ChildWindows'))
        if okf and foc then
            ui.win_focus = ui.win_focus or {}
            ui.win_focus[name] = true
        end
    end
    focus.begin(name)
    return drawing
end

-- 今の窓（子の窓でも）の文字を、決めた倍率ちょうどにする。
-- くっきりフォントが使えるときは PushFont（引き伸ばさない）。
-- 使えないときは、子の窓が親の倍率を受け継ぐか版で違うので、倍率 1 にして測り、受け継いだ分を割り戻す。
-- 測れないときは、そのまま渡す（受け継がない動き。0.1.31 の実機ではこちら）。
function window.set_font(ui, scale, opts)
    apply_font(ui, scale, opts)
end

function window.finish(ui, name, preferred)
    local imgui = ui.imgui
    -- PushFont は End の前に戻す（組を崩さない）
    release_crisp(ui)
    focus.finish(name, preferred)
    window.pop(ui, 'window')
    window.pop(ui, 'style')
end

---------------------------------------------------------------------------
-- Begin/End の組を覚えておき、画面の途中で失敗しても必ず閉じる
-- （ImGui は組が崩れるとゲームごと止まることがあるため）
---------------------------------------------------------------------------

local CLOSERS = {
    window   = function (im) im.End() end,
    child    = function (im) im.EndChild() end,
    table    = function (im) im.EndTable() end,
    combo    = function (im) im.EndCombo() end,
    popup    = function (im) im.EndPopup() end,
    group    = function (im) im.EndGroup() end,
    disabled = function (im) im.EndDisabled() end,
    wrap     = function (im) im.PopTextWrapPos() end,
    style    = function (im, e) theme.pop(im, e.a, e.b) end,
}

function window.push(ui, kind, a, b)
    ui._stack = ui._stack or {}
    ui._stack[#ui._stack + 1] = { kind = kind, a = a, b = b }
end

function window.pop(ui, kind)
    local st = ui._stack or {}
    local e = st[#st]
    if not e then return end
    st[#st] = nil
    -- 閉じる処理が失敗しても、残りの組を閉じられるようにする
    pcall(CLOSERS[e.kind], ui.imgui, e)
end

function window.depth(ui) return #(ui._stack or {}) end

-- 指定の深さまで閉じる（表が使えなかった時に、その場だけ戻す）
function window.unwind_to(ui, depth)
    local st = ui._stack or {}
    for i = #st, depth + 1, -1 do
        pcall(CLOSERS[st[i].kind], ui.imgui, st[i])
        st[i] = nil
    end
end

-- 失敗した時に、開いたままの組を逆順に閉じる
function window.unwind(ui)
    release_crisp(ui)
    local st = ui._stack or {}
    for i = #st, 1, -1 do
        pcall(CLOSERS[st[i].kind], ui.imgui, st[i])
        st[i] = nil
    end
end

return window
