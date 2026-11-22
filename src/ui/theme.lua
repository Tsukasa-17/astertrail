--[[
  Astertrail - 見た目（落ち着いた暗色 dark_calm）
  ImGui の定数は、読み込まれた imgui ライブラリの名前を優先し、無ければ 1.92 の値を使う。
]]

local theme = {}

-- 通常メニューの縁取り・影（0.1.236〜）。初期は今までの見た目
local outline_mul = 1
local outline_alpha = 1
local shadow_on = true
local shadow_color = 'black'
local shadow_distance = 2
local shadow_alpha = 1
local body_fx = false
function theme.set_outline_mul(m)
    m = tonumber(m)
    if m == nil then m = 1 end
    if m < 0 then m = 0 elseif m > 8 then m = 8 end
    outline_mul = m
end
function theme.outline_mul()
    return outline_mul
end
local SHADOW_COL = {
    black = 'ink',
    dark = { 0.28, 0.28, 0.30 },
    white = { 0.96, 0.96, 0.96 },
}
function theme.set_text_fx(S)
    -- 0.1.245：見た目タブの縁取りと影は使わない。保存値は読んでも描画には出さない（落ちないようにするだけ）。
    S = S or {}
    theme.set_outline_mul(0)
    outline_alpha = 0
    shadow_on = false
    shadow_color = 'black'
    shadow_distance = 2
    shadow_alpha = 1
    body_fx = false
end

local FALLBACK = {
    ImGuiCol_Text = 0, ImGuiCol_TextDisabled = 1, ImGuiCol_WindowBg = 2, ImGuiCol_ChildBg = 3,
    ImGuiCol_PopupBg = 4, ImGuiCol_Border = 5, ImGuiCol_FrameBg = 7, ImGuiCol_FrameBgHovered = 8,
    ImGuiCol_FrameBgActive = 9, ImGuiCol_TitleBg = 10, ImGuiCol_TitleBgActive = 11,
    ImGuiCol_TitleBgCollapsed = 12, ImGuiCol_ScrollbarBg = 14, ImGuiCol_ScrollbarGrab = 15,
    ImGuiCol_SliderGrab = 19, ImGuiCol_SliderGrabActive = 20,
    ImGuiCol_Button = 21, ImGuiCol_ButtonHovered = 22, ImGuiCol_ButtonActive = 23,
    ImGuiCol_Header = 24, ImGuiCol_HeaderHovered = 25, ImGuiCol_HeaderActive = 26, ImGuiCol_Separator = 27,
    ImGuiStyleVar_WindowPadding = 2, ImGuiStyleVar_WindowRounding = 3, ImGuiStyleVar_WindowBorderSize = 4,
    ImGuiStyleVar_FramePadding = 11, ImGuiStyleVar_FrameRounding = 12, ImGuiStyleVar_ItemSpacing = 14,
    ImGuiWindowFlags_NoTitleBar = 1, ImGuiWindowFlags_NoResize = 2, ImGuiWindowFlags_NoMove = 4,
    ImGuiWindowFlags_NoScrollbar = 8, ImGuiWindowFlags_NoScrollWithMouse = 16, ImGuiWindowFlags_NoCollapse = 32,
    ImGuiWindowFlags_AlwaysAutoResize = 64, ImGuiWindowFlags_NoBackground = 128, ImGuiWindowFlags_NoSavedSettings = 256,
    ImGuiWindowFlags_NoFocusOnAppearing = 4096, ImGuiWindowFlags_NoNavInputs = 65536,
    ImGuiWindowFlags_NoNavFocus = 131072, ImGuiWindowFlags_HorizontalScrollbar = 2048,
    ImGuiWindowFlags_NoMouseInputs = 512, ImGuiStyleVar_Alpha = 0,
    ImGuiTableFlags_RowBg = 64, ImGuiTableFlags_BordersInnerH = 128, ImGuiTableFlags_BordersOuterH = 256,
    ImGuiTableFlags_BordersInnerV = 512, ImGuiTableFlags_BordersOuterV = 1024, ImGuiTableFlags_Borders = 1920,
    ImGuiTableFlags_SizingFixedFit = 8192, ImGuiTableFlags_SizingStretchProp = 24576, ImGuiTableFlags_ScrollY = 33554432,
    ImGuiTableColumnFlags_WidthStretch = 8, ImGuiTableColumnFlags_WidthFixed = 16,
    ImGuiSelectableFlags_SpanAllColumns = 2, ImGuiSelectableFlags_AllowDoubleClick = 4,
    ImGuiTableFlags_Resizable = 2, ImGuiTableFlags_NoSavedSettings = 16,
    ImGuiTableBgTarget_RowBg0 = 1, ImGuiTableBgTarget_RowBg1 = 2,
    ImGuiChildFlags_Borders = 1,
    ImGuiCond_Always = 1, ImGuiCond_FirstUseEver = 4,
    ImGuiMouseCursor_ResizeEW = 4,
    ImGuiHoveredFlags_ChildWindows = 1, ImGuiHoveredFlags_AnyWindow = 4,
    ImGuiFocusedFlags_ChildWindows = 1, ImGuiFocusedFlags_RootAndChildWindows = 3,
}

-- 番号が版で変わる定数（表の色など）は、読み込まれた imgui に名前がある時だけ使う
function theme.C_opt(name)
    local v = rawget(_G, name)
    if type(v) == 'number' then return v end
    return nil
end

function theme.C(name)
    local v = rawget(_G, name)
    if type(v) == 'number' then return v end
    return FALLBACK[name] or 0
end

-- ImU32（ABGR）
function theme.rgba(r, g, b, a)
    r = tonumber(r) or 0
    g = tonumber(g) or 0
    b = tonumber(b) or 0
    if r < 0 then r = 0 elseif r > 255 then r = 255 end
    if g < 0 then g = 0 elseif g > 255 then g = 255 end
    if b < 0 then b = 0 elseif b > 255 then b = 255 end
    a = tonumber(a)
    if a == nil then a = 1 end
    if a < 0 then a = 0 elseif a > 1 then a = 1 end
    a = math.floor(a * 255 + 0.5)
    if a < 0 then a = 0 elseif a > 255 then a = 255 end
    return ((a * 256 + b) * 256 + g) * 256 + r
end

local rgba = theme.rgba

-- 色（0-255）
theme.palette = {
    text       = { 0.90, 0.91, 0.93 },
    muted      = { 0.62, 0.66, 0.72 },
    bg         = { 0.075, 0.085, 0.11 },
    border     = { 0.42, 0.50, 0.62 },
    accent     = { 0.98, 0.83, 0.50 },   -- 選択の枠と光（控えめな金色）
    good       = { 0.58, 0.82, 0.64 },
    warn       = { 0.96, 0.72, 0.45 },
    button     = { 0.18, 0.21, 0.27 },
    button_hv  = { 0.24, 0.28, 0.36 },
    button_ac  = { 0.30, 0.35, 0.45 },
    frame      = { 0.12, 0.14, 0.18 },
    title      = { 0.10, 0.12, 0.16 },
    title_ac   = { 0.14, 0.17, 0.23 },
    -- 名前の色分け（半透明の暗い背景でも読める明るさ。選択の印には使わない）
    item       = { 1.00, 0.74, 0.36 },   -- アイテム・だいじなもの：あたたかい琥珀色
    zone       = { 0.46, 0.84, 0.78 },   -- エリア（ゾーン）名：やわらかい青緑
    npc        = { 0.72, 0.70, 1.00 },   -- 話す NPC：明るいラベンダー
    mob        = { 1.00, 0.60, 0.55 },   -- モンスター：やわらかい珊瑚
    obj        = { 0.62, 0.80, 1.00 },   -- 調べる対象：スカイブルー
    player     = { 0.10, 0.95, 1.00 },   -- いまいる位置：鮮やかなシアン（黒縁と組む）
    pin        = { 1.00, 0.28, 0.10 },   -- クエストの印：朱色（羊皮紙の金色に埋もれない）
    ink        = { 0.05, 0.05, 0.07 },   -- 印の縁
    cream      = { 0.98, 0.96, 0.90 },   -- 金ボタン上の文字（0.1.200〜。金色だと読みにくい）
    paper      = { 1.00, 1.00, 1.00 },   -- 印の白い輪
    ic_glyph_dark = { 0.16, 0.10, 0.05 }, -- 黄・金の印の記号（0.1.201〜。白だと読みにくい）
    -- クエストの状態のアイコン（0.1.63〜。どちらの見た目でも同じ）
    ic_main    = { 0.98, 0.76, 0.22 },   -- ミッション：金
    ic_sub     = { 1.00, 0.86, 0.36 },   -- 未受注のクエスト：明るい黄
    ic_repeat  = { 0.58, 0.82, 0.64 },   -- くり返し：緑（今までの二重丸と同じ）
    repeat_mark = { 0.40, 0.66, 1.00 },  -- 本の名前の右の【再】（0.1.177〜）：青
    ic_progress = { 0.42, 0.74, 1.00 },  -- 進行中：空色
    ic_done    = { 0.36, 0.84, 0.46 },   -- 目標達成：若葉色
    ic_bad     = { 0.90, 0.28, 0.26 },   -- 受けられない・進められない：赤
    ic_fame    = { 0.86, 0.36, 0.84 },   -- 名声を教えてくれる人（0.1.69〜）：赤紫（ほかの印と重ならない色）
    compass_blue = { 0.22, 0.52, 0.96 }, -- 本の上の行のコンパスの絵（0.1.173〜）：🧭 のような青
    star_gold  = { 0.95, 0.75, 0.22 },   -- 本の上の行のトラッカーの星（0.1.177〜）
    star_rim   = { 1.00, 0.91, 0.58 },
    roe_paper  = { 0.93, 0.91, 0.84 },   -- 本の上の行のエミネンスの紙（0.1.177〜）：クリーム色
    roe_rim    = { 0.58, 0.55, 0.46 },
    roe_check  = { 0.24, 0.70, 0.38 },   -- 緑のチェック
    roe_line   = { 0.45, 0.43, 0.38 },
    -- エミネンスの受ける／解除（0.1.203〜）。色を変えて見分けやすくする
    roe_take       = { 0.14, 0.58, 0.64 },  -- 受ける：塗った青緑
    roe_take_hover = { 0.18, 0.70, 0.76 },
    roe_take_press = { 0.10, 0.44, 0.50 },
    roe_drop       = { 0.70, 0.20, 0.20 },  -- 解除：縁の暗い赤
    roe_drop_hover = { 0.84, 0.28, 0.26 },
    roe_drop_press = { 0.52, 0.12, 0.12 },
}

-- RGB 表を複製する（同じ表を共有すると、別の見た目へ書き換えたときにクラシックへ漏れないように）
local function copy_rgb(c)
    if type(c) ~= 'table' then return c end
    return { tonumber(c[1] or c.r) or 0, tonumber(c[2] or c.g) or 0, tonumber(c[3] or c.b) or 0 }
end
local function copy_map(src)
    local out = {}
    for k, v in pairs(src) do out[k] = copy_rgb(v) end
    return out
end

-- これまでの色（保存して、切り替えで戻せるように）。値は複製して持ち、共有しない
local CLASSIC = copy_map(theme.palette)
CLASSIC.heading = copy_rgb(CLASSIC.accent)
CLASSIC.select = copy_rgb(CLASSIC.accent)
CLASSIC.ring = copy_rgb(CLASSIC.accent)
CLASSIC.gold = copy_rgb(CLASSIC.accent)    -- 印や入口の絵の金色（どちらの見た目でも同じ）
for _, k in ipairs({ 'heading', 'select', 'ring', 'gold' }) do theme.palette[k] = copy_rgb(CLASSIC[k]) end

-- YunaUI 風（作者の許可あり。値は YunaUI の設定画面の色と形を見て、こちらで組み直したもの）
--   地：ほぼ黒にすみれ色を少し（0.068, 0.066, 0.088）、文字は青みの白、薄い文字は灰青
--   枠・区切り・ボタンは白の薄い重ね（ガラス）、操作中の光は桃色（ネオン）、設定の差し色はやわらかいラベンダー
local YUNA = {
    text       = { 0.910, 0.922, 0.957 },
    muted      = { 0.545, 0.576, 0.667 },
    bg         = { 0.068, 0.066, 0.088 },
    border     = { 1.00, 1.00, 1.00 },        -- 白を薄く重ねて使う
    accent     = { 0.74, 0.66, 0.95 },        -- 差し色（クエスト名など）：やわらかいラベンダー
    ring       = { 1.00, 0.42, 0.72 },        -- 選択の輪：YunaUI のネオンの桃色
    lavender   = { 0.74, 0.66, 0.95 },        -- 設定の差し色
    heading    = { 0.93, 0.90, 1.00 },        -- 見出しの文字
    select     = { 0.74, 0.66, 0.95 },        -- 選んだ行の背景
    button     = { 1.00, 1.00, 1.00 },
    button_hv  = { 1.00, 1.00, 1.00 },
    button_ac  = { 1.00, 1.00, 1.00 },
    frame      = { 1.00, 1.00, 1.00 },
    title      = { 0.068, 0.066, 0.088 },
    title_ac   = { 0.165, 0.158, 0.205 },
}

-- SF（0.1.253〜）：薄暗いガラス＋水色の枠。
-- 0.1.268〜：調べる対象はピンクマゼンタ、話すNPCは鮮やかな紫（本文の水色白や既存の色分けと区別する）
local SF = {
    text       = { 0.86, 0.95, 1.00 },
    obj        = { 1.00, 0.48, 0.82 },   -- 調べる対象（??? など）：ピンクマゼンタ
    npc        = { 0.82, 0.58, 1.00 },   -- 話す NPC：鮮やかな紫
    muted      = { 0.50, 0.68, 0.78 },
    bg         = { 0.035, 0.055, 0.08 },
    border     = { 0.35, 0.85, 0.98 },
    accent     = { 0.40, 0.90, 1.00 },
    ring       = { 0.45, 0.95, 1.00 },
    heading    = { 0.75, 0.95, 1.00 },
    select     = { 0.16, 0.42, 0.55 },
    button     = { 0.08, 0.14, 0.20 },
    button_hv  = { 0.12, 0.22, 0.30 },
    button_ac  = { 0.16, 0.30, 0.40 },
    frame      = { 0.06, 0.10, 0.14 },
    title      = { 0.03, 0.05, 0.07 },
    title_ac   = { 0.05, 0.09, 0.12 },
    sf_amber   = { 0.95, 0.78, 0.32 },
    sf_amber_hover = { 1.00, 0.88, 0.45 },
    sf_amber_press = { 0.78, 0.60, 0.18 },
    sf_cyan    = { 0.40, 0.90, 1.00 },
}

theme.look = 'sf'
theme.LOOKS = { 'yunaui', 'classic', 'sf' }

function theme.is_sf()
    return theme.look == 'sf'
end

function theme.next_look(cur)
    if cur == 'classic' then return 'yunaui' end
    if cur == 'yunaui' then return 'sf' end
    return 'classic'
end

-- 見た目を切り替える（'yunaui' / 'classic' / 'sf'）。名前の色分けはクラシックを土台にする。
-- パレットの表は毎回複製して渡し、別テーマの表を直接指さない。クラシックに戻すときは、
-- クラシックに無いキー（sf_cyan など）も消す。
-- 同じ名前でもパレットを作り直す（0.1.285〜）。0.1.284 では theme.look の初期値が
-- すでに 'sf' のため set_look('sf') が何もせず、パレットがクラシックのまま残った。
-- アストラルの枠の下にクラシックの地色が出る混在の原因。
function theme.set_look(name)
    if name ~= 'yunaui' and name ~= 'sf' then name = 'classic' end
    theme.look = name
    for k in pairs(theme.palette) do
        if CLASSIC[k] == nil then theme.palette[k] = nil end
    end
    for k, v in pairs(CLASSIC) do theme.palette[k] = copy_rgb(v) end
    if name == 'yunaui' then
        for k, v in pairs(YUNA) do theme.palette[k] = copy_rgb(v) end
    elseif name == 'sf' then
        for k, v in pairs(SF) do theme.palette[k] = copy_rgb(v) end
    end
end
-- 読み込み時に、初期の見た目（アストラル）とパレットを揃える。最初の描画より前に行う。
theme.set_look(theme.look)

-- 色名、{r,g,b}、壊れた値のどれでも、RGB 0〜1 を返す。不明なら黒（ink）。
local function color_rgb(c)
    if type(c) == 'string' then
        c = theme.palette and theme.palette[c]
    end
    if type(c) == 'table' then
        local r = tonumber(c[1] or c.r or c.x)
        local g = tonumber(c[2] or c.g or c.y)
        local b = tonumber(c[3] or c.b or c.z)
        if r and g and b then
            if r > 1 or g > 1 or b > 1 then
                r, g, b = r / 255, g / 255, b / 255
            end
            return r, g, b
        end
    end
    local d = (theme.palette and theme.palette.ink) or { 0.05, 0.05, 0.07 }
    return tonumber(d[1]) or 0.05, tonumber(d[2]) or 0.05, tonumber(d[3]) or 0.07
end

function theme.col(name, alpha)
    local r, g, b = color_rgb(name)
    local a = tonumber(alpha)
    if a == nil then a = 1.0 end
    if a < 0 then a = 0 elseif a > 1 then a = 1 end
    return { r, g, b, a }
end

function theme.u32(name, alpha)
    local r, g, b = color_rgb(name)
    local a = tonumber(alpha)
    if a == nil then a = 1.0 end
    if a < 0 then a = 0 elseif a > 1 then a = 1 end
    return rgba(math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), a)
end

-- 窓を描く前に積む。戻り値は pop 用の数
function theme.push(imgui, alpha)
    local C = theme.C
    if theme.look == 'yunaui' then return theme.push_yunaui(imgui, alpha) end
    if theme.look == 'sf' then return theme.push_sf(imgui, alpha) end
    local cols = {
        { C('ImGuiCol_Text'), theme.col('text') },
        { C('ImGuiCol_TextDisabled'), theme.col('muted') },
        { C('ImGuiCol_WindowBg'), theme.col('bg', alpha) },
        { C('ImGuiCol_ChildBg'), { 0, 0, 0, 0 } },
        { C('ImGuiCol_PopupBg'), theme.col('bg', math.max(alpha, 0.95)) },
        { C('ImGuiCol_Border'), theme.col('border', 0.55) },
        { C('ImGuiCol_FrameBg'), theme.col('frame', 0.95) },
        { C('ImGuiCol_FrameBgHovered'), theme.col('button_hv', 0.95) },
        { C('ImGuiCol_FrameBgActive'), theme.col('button_ac', 0.95) },
        { C('ImGuiCol_TitleBg'), theme.col('title', math.max(alpha, 0.9)) },
        { C('ImGuiCol_TitleBgActive'), theme.col('title_ac', math.max(alpha, 0.95)) },
        { C('ImGuiCol_TitleBgCollapsed'), theme.col('title', 0.8) },
        { C('ImGuiCol_Button'), theme.col('button', 0.95) },
        { C('ImGuiCol_ButtonHovered'), theme.col('button_hv', 1.0) },
        { C('ImGuiCol_ButtonActive'), theme.col('button_ac', 1.0) },
        { C('ImGuiCol_Header'), theme.col('button', 0.6) },
        { C('ImGuiCol_HeaderHovered'), theme.col('button_hv', 0.7) },
        { C('ImGuiCol_HeaderActive'), theme.col('button_ac', 0.8) },
        { C('ImGuiCol_Separator'), theme.col('border', 0.35) },
    }
    -- 表の色（定数の名前が分かる時だけ。番号を推測して別の色を変えないように）
    local opt = {
        { 'ImGuiCol_TableHeaderBg', theme.col('title_ac', 0.95) },
        { 'ImGuiCol_TableBorderStrong', theme.col('border', 0.60) },
        { 'ImGuiCol_TableBorderLight', theme.col('border', 0.40) },
        { 'ImGuiCol_TableRowBgAlt', theme.col('button', 0.25) },
        -- 窓の幅を変えるグリップと同じ色。列の境と仕切りのつかめる所にも使う
        { 'ImGuiCol_SeparatorHovered', theme.col('accent', 0.80) },
        { 'ImGuiCol_SeparatorActive', theme.col('accent', 0.95) },
        { 'ImGuiCol_ResizeGrip', theme.col('border', 0.30) },
        { 'ImGuiCol_ResizeGripHovered', theme.col('accent', 0.80) },
        { 'ImGuiCol_ResizeGripActive', theme.col('accent', 0.95) },
    }
    for _, o in ipairs(opt) do
        local id = theme.C_opt(o[1])
        if id then cols[#cols + 1] = { id, o[2] } end
    end
    for _, c in ipairs(cols) do imgui.PushStyleColor(c[1], c[2]) end
    local vars = {
        { C('ImGuiStyleVar_WindowRounding'), 6 },
        { C('ImGuiStyleVar_FrameRounding'), 4 },
        { C('ImGuiStyleVar_WindowBorderSize'), 1 },
    }
    for _, v in ipairs(vars) do imgui.PushStyleVar(v[1], v[2]) end
    imgui.PushStyleVar(C('ImGuiStyleVar_WindowPadding'), { 12, 10 })
    imgui.PushStyleVar(C('ImGuiStyleVar_ItemSpacing'), { 8, 6 })
    imgui.PushStyleVar(C('ImGuiStyleVar_FramePadding'), { 8, 4 })
    return #cols, #vars + 3
end

-- SF：暗い半透明の地、角の丸みは付けない（枠は DrawList で角を切って描く）
function theme.push_sf(imgui, alpha)
    local C = theme.C
    alpha = alpha or 0.86
    local bg = theme.palette.bg or { 0.035, 0.055, 0.08 }
    local cols = {
        { C('ImGuiCol_Text'), theme.col('text') },
        { C('ImGuiCol_TextDisabled'), theme.col('muted') },
        { C('ImGuiCol_WindowBg'), { bg[1], bg[2], bg[3], alpha } },
        { C('ImGuiCol_ChildBg'), { 0, 0, 0, 0 } },
        { C('ImGuiCol_PopupBg'), { bg[1], bg[2], bg[3], math.max(alpha, 0.94) } },
        { C('ImGuiCol_Border'), theme.col('border', 0.55) },
        { C('ImGuiCol_FrameBg'), theme.col('frame', 0.90) },
        { C('ImGuiCol_FrameBgHovered'), theme.col('button_hv', 0.95) },
        { C('ImGuiCol_FrameBgActive'), theme.col('button_ac', 0.95) },
        { C('ImGuiCol_TitleBg'), theme.col('title', math.max(alpha, 0.92)) },
        { C('ImGuiCol_TitleBgActive'), theme.col('title_ac', math.max(alpha, 0.95)) },
        { C('ImGuiCol_TitleBgCollapsed'), theme.col('title', 0.8) },
        { C('ImGuiCol_Button'), theme.col('button', 0.90) },
        { C('ImGuiCol_ButtonHovered'), theme.col('button_hv', 1.0) },
        { C('ImGuiCol_ButtonActive'), theme.col('button_ac', 1.0) },
        { C('ImGuiCol_Header'), theme.col('select', 0.45) },
        { C('ImGuiCol_HeaderHovered'), theme.col('select', 0.60) },
        { C('ImGuiCol_HeaderActive'), theme.col('select', 0.75) },
        { C('ImGuiCol_Separator'), theme.col('border', 0.28) },
    }
    local opt = {
        { 'ImGuiCol_TableHeaderBg', theme.col('title_ac', 0.95) },
        { 'ImGuiCol_TableBorderStrong', theme.col('border', 0.45) },
        { 'ImGuiCol_TableBorderLight', theme.col('border', 0.25) },
        { 'ImGuiCol_TableRowBgAlt', theme.col('button', 0.25) },
        { 'ImGuiCol_SeparatorHovered', theme.col('accent', 0.80) },
        { 'ImGuiCol_SeparatorActive', theme.col('accent', 0.95) },
        { 'ImGuiCol_ResizeGrip', theme.col('border', 0.30) },
        { 'ImGuiCol_ResizeGripHovered', theme.col('accent', 0.80) },
        { 'ImGuiCol_ResizeGripActive', theme.col('accent', 0.95) },
        { 'ImGuiCol_ScrollbarBg', { bg[1], bg[2], bg[3], 0.4 } },
        { 'ImGuiCol_ScrollbarGrab', theme.col('border', 0.40) },
    }
    for _, o in ipairs(opt) do
        local id = theme.C_opt(o[1])
        if id then cols[#cols + 1] = { id, o[2] } end
    end
    for _, c in ipairs(cols) do imgui.PushStyleColor(c[1], c[2]) end
    local vars = {
        { C('ImGuiStyleVar_WindowRounding'), 0 },
        { C('ImGuiStyleVar_FrameRounding'), 0 },
        { C('ImGuiStyleVar_WindowBorderSize'), 0 },
    }
    for _, v in ipairs(vars) do imgui.PushStyleVar(v[1], v[2]) end
    imgui.PushStyleVar(C('ImGuiStyleVar_WindowPadding'), { 18, 16 })
    imgui.PushStyleVar(C('ImGuiStyleVar_ItemSpacing'), { 8, 6 })
    imgui.PushStyleVar(C('ImGuiStyleVar_FramePadding'), { 8, 4 })
    return #cols, #vars + 3
end

-- YunaUI 風：白の薄い重ねのガラス、丸い角、細いスクロールバー
function theme.push_yunaui(imgui, alpha)
    local C = theme.C
    alpha = alpha or 0.92
    local W = function (a) return { 1, 1, 1, a } end
    local L = function (a) local c = YUNA.lavender; return { c[1], c[2], c[3], a } end
    local bg = YUNA.bg
    local cols = {
        { C('ImGuiCol_Text'), theme.col('text') },
        { C('ImGuiCol_TextDisabled'), theme.col('muted') },
        { C('ImGuiCol_WindowBg'), { bg[1], bg[2], bg[3], alpha } },
        { C('ImGuiCol_ChildBg'), { 0, 0, 0, 0 } },
        { C('ImGuiCol_PopupBg'), { bg[1], bg[2], bg[3], 0.98 } },
        { C('ImGuiCol_Border'), W(0.08) },
        { C('ImGuiCol_FrameBg'), W(0.06) },
        { C('ImGuiCol_FrameBgHovered'), W(0.10) },
        { C('ImGuiCol_FrameBgActive'), L(0.14) },
        { C('ImGuiCol_TitleBg'), { bg[1], bg[2], bg[3], math.max(alpha, 0.92) } },
        { C('ImGuiCol_TitleBgActive'), theme.col('title_ac', math.max(alpha, 0.95)) },
        { C('ImGuiCol_TitleBgCollapsed'), { bg[1], bg[2], bg[3], 0.8 } },
        { C('ImGuiCol_Button'), W(0.035) },
        { C('ImGuiCol_ButtonHovered'), W(0.08) },
        { C('ImGuiCol_ButtonActive'), W(0.12) },
        { C('ImGuiCol_Header'), L(0.14) },
        { C('ImGuiCol_HeaderHovered'), L(0.20) },
        { C('ImGuiCol_HeaderActive'), L(0.28) },
        { C('ImGuiCol_Separator'), W(0.07) },
        { C('ImGuiCol_ScrollbarBg'), { 0, 0, 0, 0 } },
        { C('ImGuiCol_ScrollbarGrab'), W(0.07) },
        { C('ImGuiCol_ScrollbarGrabHovered'), L(0.55) },
        { C('ImGuiCol_ScrollbarGrabActive'), L(0.80) },
    }
    local opt = {
        { 'ImGuiCol_SliderGrab', L(0.80) },
        { 'ImGuiCol_SliderGrabActive', { 1.00, 0.42, 0.72, 1.0 } },
        { 'ImGuiCol_CheckMark', L(1.0) },
        { 'ImGuiCol_SeparatorHovered', L(0.55) },
        { 'ImGuiCol_SeparatorActive', L(0.80) },
        { 'ImGuiCol_ResizeGrip', W(0.05) },
        { 'ImGuiCol_ResizeGripHovered', L(0.45) },
        { 'ImGuiCol_ResizeGripActive', L(0.75) },
        { 'ImGuiCol_TableHeaderBg', W(0.05) },
        { 'ImGuiCol_TableBorderStrong', W(0.10) },
        { 'ImGuiCol_TableBorderLight', W(0.06) },
        { 'ImGuiCol_TableRowBgAlt', W(0.02) },
    }
    for _, o in ipairs(opt) do
        local id = theme.C_opt(o[1])
        if id then cols[#cols + 1] = { id, o[2] } end
    end
    for _, c in ipairs(cols) do imgui.PushStyleColor(c[1], c[2]) end
    local nv = 0
    local function var(name, v)
        local id = (name:find('Rounding') or name:find('Size')) and theme.C_opt(name) or nil
        if id == nil then id = C(name) end
        if id == nil then return end
        imgui.PushStyleVar(id, v); nv = nv + 1
    end
    var('ImGuiStyleVar_WindowRounding', 12)
    var('ImGuiStyleVar_FrameRounding', 10)
    var('ImGuiStyleVar_WindowBorderSize', 1)
    var('ImGuiStyleVar_WindowPadding', { 16, 12 })
    var('ImGuiStyleVar_ItemSpacing', { 8, 7 })
    var('ImGuiStyleVar_FramePadding', { 10, 5 })
    -- 番号が版で変わるものは、名前が分かるときだけ
    for _, o in ipairs({ { 'ImGuiStyleVar_ScrollbarSize', 6 }, { 'ImGuiStyleVar_ScrollbarRounding', 3 },
                         { 'ImGuiStyleVar_PopupRounding', 10 }, { 'ImGuiStyleVar_ChildRounding', 10 },
                         { 'ImGuiStyleVar_GrabRounding', 8 }, { 'ImGuiStyleVar_FrameBorderSize', 0 } }) do
        local id = theme.C_opt(o[1])
        if id then imgui.PushStyleVar(id, o[2]); nv = nv + 1 end
    end
    return #cols, nv
end

---------------------------------------------------------------------------
-- YunaUI のミニマップのふち（通常モードの「カプセル」）を、こちらの描き方で組み直したもの
--   角の丸い暗いすみれのガラス。ふちは左の桃色から右のすみれ色へ移る細い線と、その外の淡い光、
--   下に黒い影の線。出たときに、ふちが一周ぐるりと描かれ、薄い光が上から下へ流れる。
--   描くのは窓の描画リストだけ（入力は奪わない）。大きさは文字の倍率に合わせる。
---------------------------------------------------------------------------
theme.CAPSULE = {
    pink   = { 1.00, 0.42, 0.72 },
    violet = { 0.62, 0.40, 1.00 },
    glass  = { 0.055, 0.050, 0.078 },
}

function theme.capsule_scale(font)
    local f = tonumber(font) or 1.0
    return math.max(0.7, math.min(4.0, f))   -- 0.1.210〜：文字サイズの上限（400%）に合わせる
end

function theme.capsule_radius(w, h, s)
    local r = 18 * (s or 1)
    if w and h then r = math.min(r, w / 4, h / 4) end
    return math.max(2, r)
end

-- 地をガラスに、ImGui の枠とタイトル帯の色は消す（ふちは自分で描く）
function theme.push_capsule(imgui, alpha, s)
    local C = theme.C
    local g = theme.CAPSULE.glass
    local a = alpha or 0.85
    local cols = {
        { C('ImGuiCol_WindowBg'), { g[1], g[2], g[3], a } },
        { C('ImGuiCol_Border'), { 0, 0, 0, 0 } },
        { C('ImGuiCol_TitleBg'), { 0, 0, 0, 0 } },
        { C('ImGuiCol_TitleBgActive'), { 0, 0, 0, 0 } },
        { C('ImGuiCol_TitleBgCollapsed'), { 0, 0, 0, 0 } },
    }
    for _, c in ipairs(cols) do imgui.PushStyleColor(c[1], c[2]) end
    imgui.PushStyleVar(C('ImGuiStyleVar_WindowRounding'), 18 * (s or 1))
    imgui.PushStyleVar(C('ImGuiStyleVar_WindowBorderSize'), 0)
    return #cols, 2
end

-- 角の丸い四角の輪郭の点（左上の角の終わりから時計回り）
function theme.rounded_points(x0, y0, x1, y1, r, n)
    local p = {}
    local function arc(cx, cy, a0)
        for k = 0, n do
            local a = a0 + (math.pi / 2) * k / n
            p[#p + 1] = { cx + math.cos(a) * r, cy + math.sin(a) * r }
        end
    end
    arc(x1 - r, y0 + r, -math.pi / 2)
    arc(x1 - r, y1 - r, 0)
    arc(x0 + r, y1 - r, math.pi / 2)
    arc(x0 + r, y0 + r, math.pi)
    return p
end

local cap_seen = {}
local function now_s(imgui)
    if imgui.GetTime then
        local ok, t = pcall(imgui.GetTime)
        if ok and tonumber(t) then return tonumber(t) end
    end
    return os.clock()
end

local function xy(a, b)
    if type(a) == 'table' then return a.x or a[1], a.y or a[2] end
    return a, b
end

-- 窓の Begin の直後に呼ぶ。窓が出た瞬間を覚え、ふちの描き始めに使う
function theme.draw_capsule(imgui, key, s, reduce_motion)
    local dl = imgui.GetWindowDrawList()
    if not dl then return end
    local x, y = xy(imgui.GetWindowPos())
    local w, h = xy(imgui.GetWindowSize())
    if not (tonumber(x) and tonumber(y) and tonumber(w) and tonumber(h)) or w < 8 or h < 8 then return end
    s = s or 1
    local now = now_s(imgui)
    local seen = cap_seen[key]
    -- 1 秒以上描かれていなかったら、出直したとみなす
    if not seen or now - seen.last > 1.0 then seen = { t0 = now, last = now }; cap_seen[key] = seen end
    seen.last = now
    local age = reduce_motion and 99 or (now - seen.t0)
    local zf = math.min(1, age / 0.9); zf = 1 - (1 - zf) ^ 3

    local inset = 2.5 * s
    local x0, y0, x1, y1 = x + inset, y + inset, x + w - inset, y + h - inset
    local R = math.max(2, theme.capsule_radius(w, h, s) - inset)
    local P = theme.rounded_points(x0, y0, x1, y1, R, 6)
    local PK, VI = theme.CAPSULE.pink, theme.CAPSULE.violet
    local span = math.max(1, x1 - x0)
    local function col(t, a)
        t = math.max(0, math.min(1, t))
        return theme.rgba(math.floor((PK[1] + (VI[1] - PK[1]) * t) * 255), math.floor((PK[2] + (VI[2] - PK[2]) * t) * 255),
            math.floor((PK[3] + (VI[3] - PK[3]) * t) * 255), a)
    end
    local n = #P
    dl:PushClipRect({ x, y }, { x + w, y + h }, false)
    for i = 1, n do
        local p0, p1 = P[i], P[i % n + 1]
        dl:AddLine({ p0[1], p0[2] }, { p1[1], p1[2] }, theme.rgba(0, 0, 0, 0.5), 4 * s)
    end
    local function edge(a, th)
        local L = zf * n
        for i = 1, n do
            if L <= 0 then break end
            local p0, p1 = P[i], P[i % n + 1]
            local e = math.min(1, L)
            local q = { p0[1] + (p1[1] - p0[1]) * e, p0[2] + (p1[2] - p0[2]) * e }
            dl:AddLine({ p0[1], p0[2] }, q, col((p0[1] - x0) / span, a), th)
            L = L - 1
        end
    end
    edge(0.25, 5 * s)
    edge(0.9, 1.5 * s)
    -- 出たばかりのときだけ、薄い光が上から下へ
    if age > 0.6 and age < 1.6 then
        local q = (age - 0.6) / 1.0
        local sy = y0 + q * (y1 - y0)
        local hw = (x1 - x0) / 2 - R * 0.6
        local cx = (x0 + x1) / 2
        if hw > 0 then
            dl:AddLine({ cx - hw, sy }, { cx + hw, sy }, col(0, 0.6 * (1 - q)), 2 * s)
            dl:AddLine({ cx - hw, sy - 3 * s }, { cx + hw, sy - 3 * s }, col(1, 0.2 * (1 - q)), 5 * s)
        end
    end
    dl:PopClipRect()
end

function theme.pop(imgui, ncol, nvar)
    imgui.PopStyleVar(nvar)
    imgui.PopStyleColor(ncol)
end

-- 今選んでいる項目の印：細い枠＋控えめな光＋左の帯（色だけに頼らない）
-- clip: { x1, y1, x2, y2 } を渡すと、表の列の切り取りを外してその範囲に描く（行全体の枠用）
function theme.draw_focus(imgui, x1, y1, x2, y2, reduce_motion, clip)
    local dl = imgui.GetWindowDrawList()
    if not dl then return end
    if theme.look == 'yunaui' then return theme.draw_focus_yunaui(imgui, dl, x1, y1, x2, y2, reduce_motion, clip) end
    if theme.look == 'sf' then return theme.draw_focus_sf(imgui, dl, x1, y1, x2, y2, reduce_motion, clip) end
    if clip then
        dl:PushClipRect({ clip[1], clip[2] }, { clip[3], clip[4] }, false)
    end
    -- 左の帯と枠が文字に被らないよう、少し外側に描く
    x1, y1, x2, y2 = x1 - 8, y1 - 2, x2 + 2, y2 + 2
    local a = 1.0
    if not reduce_motion then
        local t = imgui.GetTime and imgui.GetTime() or 0
        a = 0.85 + 0.15 * math.sin(t * 3.0)
    end
    if not reduce_motion then
        -- 外側へ薄くにじむ光
        for i = 3, 1, -1 do
            dl:AddRect({ x1 - i, y1 - i }, { x2 + i, y2 + i }, theme.u32('accent', 0.10 * a / i), 4 + i, 0, 1.0)
        end
        dl:AddRectFilled({ x1, y1 }, { x2, y2 }, theme.u32('accent', 0.07 * a), 4)
    end
    dl:AddRect({ x1, y1 }, { x2, y2 }, theme.u32('accent', 0.95), 4, 0, 1.0)
    dl:AddRectFilled({ x1 + 1, y1 + 3 }, { x1 + 4, y2 - 3 }, theme.u32('accent', 0.95), 1)
    if clip then dl:PopClipRect() end
end

-- YunaUI 風の選択：項目を包む細い桃色の輪と、ゆっくり息をする薄い光（左の帯は付けない）
function theme.draw_focus_yunaui(imgui, dl, x1, y1, x2, y2, reduce_motion, clip)
    if clip then dl:PushClipRect({ clip[1], clip[2] }, { clip[3], clip[4] }, false) end
    local p = 3
    x1, y1, x2, y2 = x1 - p - 2, y1 - p, x2 + p, y2 + p
    local r = math.min(10, (y2 - y1) / 2)
    local br = 1.0
    if not reduce_motion then
        local t = imgui.GetTime and imgui.GetTime() or 0
        br = 0.75 + 0.25 * math.sin(t * 4.0)
    end
    dl:AddRectFilled({ x1, y1 }, { x2, y2 }, theme.u32('ring', 0.08 * br), r)
    dl:AddRect({ x1, y1 }, { x2, y2 }, theme.u32('ring', 0.18 * br), r, 0, 4.0)
    dl:AddRect({ x1, y1 }, { x2, y2 }, theme.u32('ring', 0.95), r, 0, 1.5)
    if clip then dl:PopClipRect() end
end

function theme.draw_focus_sf(imgui, dl, x1, y1, x2, y2, reduce_motion, clip)
    pcall(function ()
        if clip then dl:PushClipRect({ clip[1], clip[2] }, { clip[3], clip[4] }, false) end
        x1, y1, x2, y2 = x1 - 4, y1 - 2, x2 + 4, y2 + 2
        local a = 1.0
        if not reduce_motion then
            local tm = imgui.GetTime and imgui.GetTime() or 0
            a = 0.80 + 0.20 * math.sin((tonumber(tm) or 0) * 3.2)
        end
        local sf = package.loaded['src.ui.sf_style']
        if sf and sf.brackets then
            sf.brackets(dl, x1, y1, x2, y2, 10, theme.u32('ring', 0.95 * a), 1.6)
        else
            dl:AddRect({ x1, y1 }, { x2, y2 }, theme.u32('ring', 0.95 * a), 0, 0, 1.4)
        end
        if clip then dl:PopClipRect() end
    end)
end

-- 見出し：YunaUI 風は文字の右に細い線を伸ばす（文字は少し明るいすみれ）
function theme.heading_line(imgui)
    if theme.look ~= 'yunaui' then return end
    pcall(function ()
        local dl = imgui.GetWindowDrawList()
        local x1, y1 = imgui.GetItemRectMin()
        local x2, y2 = imgui.GetItemRectMax()
        if type(x1) == 'table' then x1, y1 = x1.x or x1[1], x1.y or x1[2] end
        if type(x2) == 'table' then x2, y2 = x2.x or x2[1], x2.y or x2[2] end
        local wx, ww = imgui.GetWindowPos(), nil
        local okw, sz = pcall(imgui.GetWindowSize)
        local right
        local okc, cmax = pcall(imgui.GetWindowContentRegionMax)
        if okc and cmax and type(wx) ~= 'nil' then
            local cx = type(cmax) == 'table' and (cmax.x or cmax[1]) or cmax
            local px = type(wx) == 'table' and (wx.x or wx[1]) or wx
            if tonumber(cx) and tonumber(px) then right = px + cx end
        end
        if not right then return end
        local my = (y1 + y2) / 2
        if right > x2 + 18 then
            dl:AddLine({ x2 + 14, my }, { right, my }, theme.u32('border', 0.08), 1)
        end
    end)
end

-- 選択行の背景（表の行全体。折り返し分も含む）
function theme.draw_row_bg(imgui, x1, y1, x2, y2, alpha)
    local dl = imgui.GetWindowDrawList()
    if not dl then return end
    if theme.look == 'yunaui' then
        dl:AddRectFilled({ x1, y1 }, { x2, y2 }, theme.u32('select', (alpha or 0.22) * 0.8), 8)
        return
    end
    if theme.look == 'sf' then
        dl:AddRectFilled({ x1, y1 }, { x2, y2 }, theme.u32('select', (alpha or 0.22) * 0.9), 0)
        return
    end
    dl:AddRectFilled({ x1, y1 }, { x2, y2 }, theme.u32('accent', alpha or 0.22), 4)
end

-- リージョンの大枠（選択の金枠とは別。落ち着いた境界）
function theme.draw_section(imgui, x1, y1, x2, y2)
    local dl = imgui.GetWindowDrawList()
    if not dl then return end
    x1, y1, x2, y2 = x1 - 8, y1 - 6, x2 + 8, y2 + 6
    if theme.look == 'yunaui' then
        -- 白を薄く重ねたガラスのカード
        dl:AddRectFilled({ x1, y1 }, { x2, y2 }, theme.u32('border', 0.035), 12)
        dl:AddRect({ x1, y1 }, { x2, y2 }, theme.u32('border', 0.10), 12, 0, 1.0)
        return
    end
    if theme.look == 'sf' then
        local sf = package.loaded['src.ui.sf_style']
        if sf and sf.frame then
            sf.frame(dl, x1, y1, x2, y2, { fill_a = 0.18, line_a = 0.70, cut = 7, brackets = true })
            return
        end
    end
    dl:AddRectFilled({ x1, y1 }, { x2, y2 }, theme.u32('border', 0.08), 5)
    dl:AddRect({ x1, y1 }, { x2, y2 }, theme.u32('border', 0.70), 5, 0, 1.2)
end


-- つかめる線の描画先。0.1.307〜：実機の描画リストは table ではなく userdata なので、
-- table だけ受けていた 0.1.204〜0.1.306 は線が一度も描かれていなかった。
-- 重なったほかの窓の上に線が出ないよう、今の窓の描画リストを先に使う（線は表を閉じたあとに描く）
function theme.resize_rail_drawlist(imgui)
    if not imgui then return nil end
    local function ok_dl(fn)
        if type(fn) ~= 'function' then return nil end
        local ok, v = pcall(fn)
        local tv = type(v)
        if ok and (tv == 'table' or tv == 'userdata') then return v end
        return nil
    end
    return ok_dl(imgui.GetWindowDrawList) or ok_dl(imgui.GetForegroundDrawList)
end

-- 窓の幅を変えるときと同じ、縦のつかめる線。乗っている／つかんでいると色と太さが変わる
-- いつも線を出し、ホバーとドラッグ中は目立たせる（0.1.193〜。0.1.204 で前景に描き、ドラッグ中ずっと出す）
function theme.draw_resize_rail(imgui, x, y1, y2, hovered, active)
    if not imgui or not x or not y1 or not y2 then return end
    local lit = hovered or active
    if lit and imgui.SetMouseCursor then
        pcall(imgui.SetMouseCursor, theme.C('ImGuiMouseCursor_ResizeEW'))
    end
    local dl = theme.resize_rail_drawlist(imgui)
    if not dl then return end
    local w = active and 5 or (hovered and 4 or 2)
    local rail = (theme.look == 'sf') and 'sf_cyan' or 'accent'
    local col = active and theme.u32(rail, 0.95)
        or (hovered and theme.u32(rail, 0.80) or theme.u32('border', 0.70))
    pcall(function ()
        if lit then
            dl:AddRectFilled({ x - (w / 2 + 2), y1 }, { x + (w / 2 + 2), y2 }, theme.u32(rail, 0.18), 1)
        end
        dl:AddRectFilled({ x - w / 2, y1 }, { x + w / 2, y2 }, col, 1)
    end)
end


-- 文字の大きさ（測れなければ文字数から見積もる）
function theme.measure_text(imgui, text, wrap_w)
    text = tostring(text or '')
    if text == '' then return 0, 0 end
    local function parse(ok, a, b)
        if not ok then return nil, nil end
        if type(a) == 'table' then return tonumber(a.x or a[1]), tonumber(a.y or a[2]) end
        return tonumber(a), tonumber(b)
    end
    local w, h
    if type(imgui.CalcTextSize) == 'function' then
        if wrap_w and wrap_w > 0 then
            w, h = parse(pcall(imgui.CalcTextSize, text, nil, false, wrap_w))
            if not (h and h > 0) then w, h = parse(pcall(imgui.CalcTextSize, text, nil, wrap_w)) end
        end
        if not (h and h > 0) then w, h = parse(pcall(imgui.CalcTextSize, text)) end
    end
    local fs = 16
    if imgui.GetFontSize then
        local ok, v = pcall(imgui.GetFontSize)
        if ok and tonumber(v) and tonumber(v) > 0 then fs = tonumber(v) end
    end
    -- 日本語は幅が広いので、測れないときは少し広めに見積もる
    if not (w and w > 0) then w = math.max(1, #text) * fs * 0.55 end
    if not (h and h > 0) then h = fs end
    if wrap_w and wrap_w > 0 and w > wrap_w then
        h = math.max(h, math.ceil(w / wrap_w) * h)
        w = wrap_w
    end
    return w, h
end

-- 2 数、表 {x,y}/{[1],[2]}、ImVec2 の userdata のどれでも読む。
function theme.xy(a, b)
    if type(a) == 'number' and type(b) == 'number' then return a, b end
    if a ~= nil then
        local okx, x = pcall(function ()
            local v = a.x
            if v == nil and type(a) == 'table' then v = a[1] end
            return tonumber(v)
        end)
        local oky, y = pcall(function ()
            local v = a.y
            if v == nil and type(a) == 'table' then v = a[2] end
            return tonumber(v)
        end)
        if okx and oky and x and y then return x, y end
    end
    local x, y = tonumber(a), tonumber(b)
    if x and y then return x, y end
    return nil
end

local function cursor_xy(imgui)
    local ok, a, b = pcall(imgui.GetCursorScreenPos)
    if not ok then return 0, 0 end
    local x, y = theme.xy(a, b)
    return x or 0, y or 0
end

local function avail_w(imgui)
    local ok, a, b = pcall(imgui.GetContentRegionAvail)
    if not ok then return nil end
    local x = theme.xy(a, b)
    if x then return x end
    return tonumber(a)
end

-- 影・輪郭・太字（太字フォントが無くても、ずらして重ねて太く見せる）
-- opts: { col='heading', shadow, outline, bold, glow, shimmer, wrap, align='center', min_w }
function theme.popup_text(ui, text, opts)
    opts = opts or {}
    text = tostring(text or '')
    local imgui = ui.imgui
    if text == '' then return 0, 0 end
    local wrap = opts.wrap
    local w, h = theme.measure_text(imgui, text, wrap)
    local aw = avail_w(imgui)
    local x, y = cursor_xy(imgui)
    local ox = 0
    if (opts.align or 'center') == 'center' and aw and w then ox = math.max(0, (aw - w) / 2) end
    theme.paint_text(imgui, x + ox, y, text, opts)
    if imgui.Dummy then pcall(imgui.Dummy, { math.max(w, opts.min_w or 0, 1), h + (opts.pad or 0) }) end
    return w, h
end

-- 縁取りと影だけを、画面上の位置へ描く（本文は呼び出し側）。wrap_w があれば折り返しを試みる
function theme.paint_fx(dl, x, y, text, opts)
    opts = opts or {}
    if not dl or not dl.AddText or not text or text == '' then return end
    local a = tonumber(opts.alpha) or 1
    -- 4 引数だけ（位置・色・文）。折り返し用に nil と幅を足すと、
    -- VanaCore の AddText がフォント指定の形に取り違えて落ちることがある。
    local function add(px, py, col, aa)
        pcall(function ()
            local u = theme.u32(col, (aa or 1) * a)
            dl.AddText(dl, { px, py }, u, text)
        end)
    end
    local do_shadow = (opts.shadow ~= false) and shadow_on and shadow_alpha > 0
    if do_shadow then
        local d = shadow_distance
        local scol = SHADOW_COL[shadow_color] or 'ink'
        add(x + d, y + d + 1, scol, 0.72 * shadow_alpha)
        add(x + d + 1, y + d + 2, scol, 0.35 * shadow_alpha)
    end
    if opts.outline ~= false and outline_mul > 0 and outline_alpha > 0 then
        local o = outline_mul
        if o > 0 then
            for _, d in ipairs({ { -o, 0 }, { o, 0 }, { 0, -o }, { 0, o }, { -o, -o }, { o, -o }, { -o, o }, { o, o } }) do
                add(x + d[1], y + d[2], 'ink', 0.88 * outline_alpha)
            end
        end
    end
end

function theme.fx_active(opts)
    opts = opts or {}
    if opts.shadow ~= false and shadow_on and shadow_alpha > 0 then return true end
    if opts.outline ~= false and outline_mul > 0 and outline_alpha > 0 then return true end
    return false
end

-- ふつうの ImGui 文字（Text / TextColored など）に、縁取りと影を重ねる。
-- 本物の imgui は触らず、呼び出しだけを包む。ボタンやスライダーの中の文字には効かない。
function theme.wrap_imgui(imgui)
    if type(imgui) ~= 'table' then return imgui end
    if imgui._at_fx then return imgui end
    local raw = imgui
    local proxy = { _at_fx = true }
    setmetatable(proxy, {
        __index = raw,
        __newindex = function (_, k, v) raw[k] = v end,
    })
    local function cursor()
        if not raw.GetCursorScreenPos then return nil end
        local ok, a, b = pcall(raw.GetCursorScreenPos)
        if not ok then return nil end
        return theme.xy(a, b)
    end
    local function wrap_w()
        if raw.GetContentRegionAvail then
            local ok, a, b = pcall(raw.GetContentRegionAvail)
            if ok then
                local x = theme.xy(a, b)
                if x then return x end
                return tonumber(a)
            end
        end
        return nil
    end
    local function fx(text, wrapped)
        if theme._fx_lock or not theme.fx_active() then return end
        text = tostring(text or '')
        if text == '' then return end
        local x, y = cursor()
        if not x or not y then return end
        local dl
        if raw.GetWindowDrawList then
            local ok, v = pcall(raw.GetWindowDrawList)
            if ok then dl = v end
        end
        if not dl then return end
        theme.paint_fx(dl, x, y, text, { wrap = wrapped and wrap_w() or nil })
    end
    local function hook(name, text_i, wrapped)
        local fn = raw[name]
        if type(fn) ~= 'function' then return end
        proxy[name] = function (...)
            local n = select('#', ...)
            local args = { ... }
            local text = args[text_i]
            if n >= text_i then fx(text, wrapped) end
            return fn(...)
        end
    end
    hook('Text', 1, false)
    hook('TextUnformatted', 1, false)
    hook('TextDisabled', 1, false)
    hook('TextWrapped', 1, true)
    hook('TextColored', 2, false)
    return proxy
end


-- 本文の縁取りと影（0.1.241〜）。共有の ImGui.Text は包まない。
-- 今の窓の描画リストへ、4 引数の AddText（位置・色・文）をずらして重ねるだけ。
-- 位置の表は使い回す。縁取りは最大 8 方向、影は 1 回。画面外は描かない。
-- 公式の文字箱（spawn）は作らない。
-- 0.1.242〜：ImVec2 の userdata も読む。本文の太さ・影の距離は 3px まで（見出しのスライダーは 0〜8）。
-- IsRectVisible は束縛ごとに引数が違うので使わない（誤って全部飛ばすのを避ける）。
local BODY_POS = { 0, 0 }
local BODY_OUT = {
    { -1, 0 }, { 1, 0 }, { 0, -1 }, { 0, 1 },
    { -1, -1 }, { 1, -1 }, { -1, 1 }, { 1, 1 },
}
local BODY_FX_MAX = 3

local function body_cap(v, hi)
    v = tonumber(v) or 0
    hi = tonumber(hi) or BODY_FX_MAX
    if hi < 0 then hi = 0 elseif hi > BODY_FX_MAX then hi = BODY_FX_MAX end
    if v < 0 then return 0 end
    if v > hi then return hi end
    return v
end

-- トラッカー・コンパスなど小さい文字の窓。未設定のときは文字の高さでも判断する。
local body_area = nil
local SMALL_BODY = { tracker = true, compass = true }
local body_stat_calls, body_stat_adds = 0, 0

function theme.set_body_area(area)
    if type(area) == 'string' and area ~= '' then body_area = area else body_area = nil end
end

local function body_small(imgui)
    -- トラッカーとコンパスだけ太さを抑える（設定の説明や本は、指定の太さを 3px まで使う）
    return body_area and SMALL_BODY[body_area] and true or false
end

local function body_max(imgui)
    if body_small(imgui) then return 1 end
    return BODY_FX_MAX
end

function theme.body_fx_on()
    return body_fx == true and theme.fx_active()
end

function theme.body_fx_extra_draws(imgui)
    if not theme.body_fx_on() then return 0 end
    local n = 0
    local hi = body_max(imgui)
    if shadow_on and shadow_alpha > 0 then n = n + 1 end
    local o = body_cap(outline_mul, hi)
    if o > 0 and outline_alpha > 0 then n = n + 8 * math.ceil(o) end
    return n
end

function theme.body_fx_stats()
    return { calls = body_stat_calls, adds = body_stat_adds, area = body_area, on = theme.body_fx_on() }
end

function theme.body_fx_stats_reset()
    body_stat_calls, body_stat_adds = 0, 0
end

local function body_cursor(imgui)
    if not imgui or not imgui.GetCursorScreenPos then return nil end
    local ok, a, b = pcall(imgui.GetCursorScreenPos)
    if not ok then return nil end
    return theme.xy(a, b)
end

local function body_visible(imgui, x, y)
    if not x or not y then return false end
    local fs = 16
    if imgui.GetFontSize then
        local ok, v = pcall(imgui.GetFontSize)
        if ok and tonumber(v) and tonumber(v) > 0 then fs = tonumber(v) end
    end
    local wx, wy, ww, wh
    if imgui.GetWindowPos then
        local ok, a, b = pcall(imgui.GetWindowPos)
        if ok then wx, wy = theme.xy(a, b) end
    end
    if imgui.GetWindowSize then
        local ok, a, b = pcall(imgui.GetWindowSize)
        if ok then ww, wh = theme.xy(a, b) end
    end
    -- 窓の境が読めたときだけ、明らかに外なら飛ばす（余白を多めに取り、端の行を落とさない）
    if wx and wy and ww and wh and ww > 1 and wh > 1 then
        local m = fs + 8
        if y + fs < wy - m or y > wy + wh + m then return false end
        if x > wx + ww + m or x + 1 < wx - m then return false end
    end
    return true
end

-- 指定した画面位置へ、縁取りと影だけを重ねる（本体の文字は呼び出し側）。
function theme.paint_body_fx_at(imgui, x, y, text)
    if not theme.body_fx_on() then return 0 end
    text = tostring(text or '')
    if text == '' or text == ' ' then return 0 end
    if not body_visible(imgui, x, y) then return 0 end
    local dl = imgui and imgui.GetWindowDrawList and imgui.GetWindowDrawList()
    if not dl or not dl.AddText then return 0 end
    body_stat_calls = body_stat_calls + 1
    local function line_h()
        local fs = 16
        if imgui.GetFontSize then
            local ok, v = pcall(imgui.GetFontSize)
            if ok and tonumber(v) and tonumber(v) > 0 then fs = tonumber(v) end
        end
        return fs
    end
    local function measure_w(s)
        if imgui.CalcTextSize then
            local ok, a, b = pcall(imgui.CalcTextSize, s)
            if ok then
                local w = theme.xy(a, b)
                if w then return w end
                w = tonumber(a)
                if w then return w end
            end
        end
        return nil
    end
    -- 折り返しや改行があるときは、1 行ずつ重ねる（全文を 1 行で描くと本文とずれる）
    local lines = {}
    if text:find('\n', 1, true) then
        for para in (text .. '\n'):gmatch('(.-)\n') do lines[#lines + 1] = para end
        if #lines == 0 then lines[1] = text end
    else
        lines[1] = text
    end
    local wrap_w = nil
    if imgui.GetContentRegionAvail then
        local ok, a, b = pcall(imgui.GetContentRegionAvail)
        if ok then
            local w = theme.xy(a, b)
            if not w then w = tonumber(a) end
            if w and w > 8 then wrap_w = w end
        end
    end
    if wrap_w then
        local split = {}
        for _, para in ipairs(lines) do
            if para == '' then
                split[#split + 1] = ''
            else
                local tw = measure_w(para)
                if tw and tw > wrap_w then
                    local acc, aw = '', 0
                    for ch in para:gmatch('[%z\1-\127\194-\244][\128-\191]*') do
                        local cw = measure_w(ch) or 0
                        if acc ~= '' and aw + cw > wrap_w then
                            split[#split + 1] = acc
                            acc, aw = ch, cw
                        else
                            acc, aw = acc .. ch, aw + cw
                        end
                    end
                    if acc ~= '' then split[#split + 1] = acc end
                else
                    split[#split + 1] = para
                end
            end
        end
        lines = split
    end
    local hi = body_max(imgui)
    local small = body_small(imgui)
    local n = 0
    local lh = line_h()
    for li, line in ipairs(lines) do
        if line ~= '' and line ~= ' ' then
            local ly = y + (li - 1) * lh
            -- 飾りつき見出しと同じ呼び方：4 引数 AddText（位置の表・色・文）
            local function add(px, py, col, aa)
                pcall(dl.AddText, dl, { px, py }, theme.u32(col, aa), line)
                n = n + 1
                body_stat_adds = body_stat_adds + 1
            end
            if shadow_on and shadow_alpha > 0 then
                local d = body_cap(shadow_distance, hi)
                local scol = SHADOW_COL[shadow_color] or 'ink'
                local sa = 0.72 * shadow_alpha
                -- 小さい文字に白い影を強くすると、にじんで潰れる
                if small and shadow_color == 'white' then sa = 0.28 * shadow_alpha end
                add(x + d, ly + d, scol, sa)
            end
            local o = body_cap(outline_mul, hi)
            -- 太さ 2px を外側の 1 周だけずらすと、文字の隣が空いて見えにくい。1px から太さまで重ねる。
            local rings = (o > 0) and math.ceil(o) or 0
            if o > 0 and outline_alpha > 0 and rings > 0 then
                local oa = 0.88 * outline_alpha
                if small then oa = 0.75 * outline_alpha end
                for r = 1, rings do
                    for i = 1, 8 do
                        local d = BODY_OUT[i]
                        add(x + d[1] * r, ly + d[2] * r, 'ink', oa)
                    end
                end
            end
        end
    end
    return n
end

function theme.paint_body_fx(imgui, text)
    if not theme.body_fx_on() then return 0 end
    text = tostring(text or '')
    if text == '' or text == ' ' then return 0 end
    local x, y = body_cursor(imgui)
    return theme.paint_body_fx_at(imgui, x, y, text)
end

local function emit_body(imgui, text, fn, ...)
    theme.paint_body_fx(imgui, text)
    if type(fn) == 'function' then return fn(...) end
end

function theme.Text(imgui, text, ...)
    return emit_body(imgui, text, imgui and imgui.Text, text, ...)
end

function theme.TextColored(imgui, col, text, ...)
    return emit_body(imgui, text, imgui and imgui.TextColored, col, text, ...)
end

function theme.TextDisabled(imgui, text, ...)
    return emit_body(imgui, text, imgui and imgui.TextDisabled, text, ...)
end

function theme.TextWrapped(imgui, text, ...)
    return emit_body(imgui, text, imgui and imgui.TextWrapped, text, ...)
end

function theme.TextUnformatted(imgui, text, ...)
    return emit_body(imgui, text, imgui and imgui.TextUnformatted, text, ...)
end

function theme.paint_text(imgui, x, y, text, opts)
    opts = opts or {}
    local dl = imgui.GetWindowDrawList and imgui.GetWindowDrawList()
    if not dl or not dl.AddText then return end
    local a = tonumber(opts.alpha) or 1
    local shimmer = 1
    if opts.shimmer then
        local now = 0
        if imgui.GetTime then
            local ok, v = pcall(imgui.GetTime)
            if ok then now = tonumber(v) or 0 end
        end
        shimmer = 0.78 + 0.22 * (0.5 + 0.5 * math.sin(now * 3.4))
    end
    local function add(px, py, col, aa)
        pcall(dl.AddText, dl, { px, py }, theme.u32(col, (aa or 1) * a), text)
    end
    -- 縁取りは本の一覧と同じ crisp_outline（古い paint_fx の 8 方向＋太字ずらしは使わない）
    local outline = package.loaded['src.ui.crisp_outline']
    if outline and type(outline.paint_at) == 'function' and outline.active and outline.active() then
        if opts.outline ~= false then
            pcall(outline.paint_at, imgui, x, y, text)
        end
    else
        theme.paint_fx(dl, x, y, text, opts)
    end
    if opts.glow then
        local gcol = opts.glow_col or 'gold'
        for _, d in ipairs({ { -3, 0 }, { 3, 0 }, { 0, -2 }, { 0, 2 }, { -2, -2 }, { 2, 2 } }) do
            add(x + d[1], y + d[2], gcol, 0.16 * shimmer)
        end
    end
    local col = opts.col or 'text'
    -- 太字のずらし重ねは、縁と同じに見えて形が崩れるので、明示したときだけ
    if opts.bold == true then
        add(x + 1, y, col, 1)
        add(x, y + 1, col, 0.9)
        add(x + 1, y + 1, col, 0.7)
    end
    add(x, y, col, 1)
end

-- 飾り線（画像は使わない。左右の線と中央の菱形）
function theme.popup_divider(ui, opts)
    opts = opts or {}
    local imgui = ui.imgui
    local dl = imgui.GetWindowDrawList and imgui.GetWindowDrawList()
    local aw = avail_w(imgui) or 400
    local x, y = cursor_xy(imgui)
    local a = (tonumber(opts.alpha) or 1) * 0.95
    local mid = x + aw / 2
    local y0 = y + 5
    local left, right = x + 10, x + aw - 10
    local span = 12
    if dl then
        local col = theme.u32(opts.col or 'gold', 0.72 * a)
        local dim = theme.u32(opts.col or 'gold', 0.28 * a)
        pcall(function ()
            dl:AddLine({ left, y0 }, { mid - span, y0 }, dim, 1.2)
            dl:AddLine({ mid + span, y0 }, { right, y0 }, dim, 1.2)
            -- 中央の菱形と小さな点
            local d = 4
            dl:AddLine({ mid, y0 - d }, { mid + d, y0 }, col, 1.6)
            dl:AddLine({ mid + d, y0 }, { mid, y0 + d }, col, 1.6)
            dl:AddLine({ mid, y0 + d }, { mid - d, y0 }, col, 1.6)
            dl:AddLine({ mid - d, y0 }, { mid, y0 - d }, col, 1.6)
            if dl.AddCircleFilled then
                dl:AddCircleFilled({ mid, y0 }, 1.6, col, 8)
            end
        end)
    end
    if imgui.Dummy then pcall(imgui.Dummy, { aw, 14 }) end
end

-- 角丸の外周の点（ネオンの光を流す用。角は 6 点で軽く）
local function rounded_path(x1, y1, x2, y2, rad)
    rad = math.max(1, math.min(rad, (x2 - x1) / 2, (y2 - y1) / 2))
    local pts = {}
    local function add(px, py) pts[#pts + 1] = { px, py } end
    local function arc(cx, cy, a0, a1, n)
        for i = 1, n do
            local a = a0 + (a1 - a0) * (i / n)
            add(cx + rad * math.cos(a), cy + rad * math.sin(a))
        end
    end
    add(x1 + rad, y1)
    add(x2 - rad, y1)
    arc(x2 - rad, y1 + rad, -math.pi / 2, 0, 6)
    add(x2, y2 - rad)
    arc(x2 - rad, y2 - rad, 0, math.pi / 2, 6)
    add(x1 + rad, y2)
    arc(x1 + rad, y2 - rad, math.pi / 2, math.pi, 6)
    add(x1, y1 + rad)
    arc(x1 + rad, y1 + rad, math.pi, math.pi * 1.5, 6)
    if #pts > 1 then
        -- 閉じる
        pts[#pts + 1] = { pts[1][1], pts[1][2] }
    end
    return pts
end

local function path_lengths(pts)
    local acc, total = { 0 }, 0
    for i = 2, #pts do
        local dx, dy = pts[i][1] - pts[i - 1][1], pts[i][2] - pts[i - 1][2]
        total = total + math.sqrt(dx * dx + dy * dy)
        acc[i] = total
    end
    return acc, total
end

local function point_on_path(pts, acc, total, s)
    if total <= 0 or #pts < 2 then return pts[1][1], pts[1][2] end
    s = s % total
    for i = 2, #pts do
        if acc[i] >= s then
            local a, b = acc[i - 1], acc[i]
            local t = (b > a) and ((s - a) / (b - a)) or 0
            local x = pts[i - 1][1] + (pts[i][1] - pts[i - 1][1]) * t
            local y = pts[i - 1][2] + (pts[i][2] - pts[i - 1][2]) * t
            return x, y
        end
    end
    return pts[#pts][1], pts[#pts][2]
end

-- 半透明の地と、枠を流れる光（受注・完了のお知らせ。0.1.198〜 ネオンの光）
-- scale, alpha, reduce_motion は数値でも、表でも受け取る
function theme.draw_popup_glass(imgui, kind, scale, alpha)
    -- アストラルは sf.draw_popup の角切り枠だけ。こちらは丸角 r=16 の内側枠になる（0.1.290〜）
    if theme.is_sf and theme.is_sf() then return end
    local reduce = false
    if type(scale) == 'table' then
        local o = scale
        scale, alpha, reduce = o.scale, o.alpha, o.reduce_motion
    end
    local dl = imgui.GetWindowDrawList and imgui.GetWindowDrawList()
    if not dl then return end
    local function xy(a, b)
        if type(a) == 'table' then return tonumber(a.x or a[1]), tonumber(a.y or a[2]) end
        return tonumber(a), tonumber(b)
    end
    local x, y = xy(imgui.GetWindowPos())
    local w, h = xy(imgui.GetWindowSize())
    if not (x and y and w and h) or w < 8 or h < 8 then return end
    scale = tonumber(scale) or 1
    alpha = tonumber(alpha) or 1
    if alpha <= 0 then return end
    local cx, cy = x + w / 2, y + h / 2
    local rw, rh = w * scale, h * scale
    local x1, y1 = cx - rw / 2, cy - rh / 2
    local x2, y2 = cx + rw / 2, cy + rh / 2
    local r = 16
    local now = 0
    if imgui.GetTime then
        local ok, v = pcall(imgui.GetTime)
        if ok then now = tonumber(v) or 0 end
    end
    local shimmer = 1
    if kind == 'complete' then
        shimmer = 0.80 + 0.20 * (0.5 + 0.5 * math.sin(now * 3.1))
    end
    local bg = theme.palette.bg or { 0.07, 0.08, 0.11 }
    local function rgba(rr, gg, bb, a) return theme.rgba(math.floor(rr * 255), math.floor(gg * 255), math.floor(bb * 255), a) end
    local complete = (kind == 'complete')
    pcall(function ()
        -- 外の淡い光
        for i = 4, 1, -1 do
            local pad = 3 * i
            local aa = (complete and 0.07 or 0.05) * shimmer * alpha / i
            local col = complete and theme.u32('gold', aa) or theme.u32('good', aa)
            if dl.AddRect then dl:AddRect({ x1 - pad, y1 - pad }, { x2 + pad, y2 + pad }, col, r + pad, 0, 2.5) end
        end
        -- 地（上を少し明るく）
        local top = rgba(bg[1] + 0.05, bg[2] + 0.05, bg[3] + 0.07, 0.58 * alpha)
        local bot = rgba(bg[1], bg[2], bg[3], 0.46 * alpha)
        if dl.AddRectFilledMultiColor then
            dl:AddRectFilledMultiColor({ x1, y1 }, { x2, y2 }, top, top, bot, bot)
        elseif dl.AddRectFilled then
            dl:AddRectFilled({ x1, y1 }, { x2, y2 }, rgba(bg[1], bg[2], bg[3], 0.50 * alpha), r)
        end
        -- 内側の縁
        local edge = complete and theme.u32('gold', 0.55 * shimmer * alpha) or theme.u32('good', 0.48 * alpha)
        local inner = theme.u32('text', 0.18 * alpha)
        if dl.AddRect then
            dl:AddRect({ x1 + 1, y1 + 1 }, { x2 - 1, y2 - 1 }, edge, r, 0, 1.8)
            dl:AddRect({ x1 + 3, y1 + 3 }, { x2 - 3, y2 - 3 }, inner, r - 2, 0, 1.0)
        end
        -- 枠を流れる光（2 本、対向。速さは前の約半分。点は約 40、残光は各 11 本で負荷は同程度）
        if not dl.AddLine then return end
        local pts = rounded_path(x1 + 1.5, y1 + 1.5, x2 - 1.5, y2 - 1.5, r)
        local acc, total = path_lengths(pts)
        if total < 8 then return end
        -- 一周は受注 4.0 秒、完了 4.8 秒（0.1.198 の半分）
        local period = complete and 4.8 or 4.0
        local head0 = reduce and 0.12 or ((now / period) % 1)
        local trail = 0.18
        local segs = 11
        local function tint(bright, a)
            if complete then
                return rgba(1.00, 0.92 + 0.08 * bright, 0.55 + 0.40 * bright, a)
            end
            return rgba(0.70 + 0.30 * bright, 1.00, 0.72 + 0.28 * bright, a)
        end
        for k = 0, 1 do
            local head = (head0 + k * 0.5) % 1
            for i = 0, segs - 1 do
                local u0 = (i / segs) * trail
                local u1 = ((i + 1) / segs) * trail
                local fall = (i / segs)
                local bright = (1 - fall) ^ 1.6
                local a_glow = (0.10 + 0.28 * bright) * alpha * shimmer
                local a_core = (0.35 + 0.65 * bright) * alpha
                local xa, ya = point_on_path(pts, acc, total, (head - u0) * total)
                local xb, yb = point_on_path(pts, acc, total, (head - u1) * total)
                dl:AddLine({ xa, ya }, { xb, yb }, tint(bright, a_glow), 6.0)
                dl:AddLine({ xa, ya }, { xb, yb }, tint(math.min(1, bright + 0.25), a_core), 2.0)
            end
            local hx, hy = point_on_path(pts, acc, total, head * total)
            if dl.AddCircleFilled then
                dl:AddCircleFilled({ hx, hy }, 3.2, tint(1, 0.90 * alpha), 8)
                dl:AddCircleFilled({ hx, hy }, 6.0, tint(0.6, 0.22 * alpha), 8)
            end
        end
    end)
end

-- お知らせ専用ボタンの大きさ（文字＋余白。ペアは揃える）
function theme.popup_button_size(imgui, label)
    local tw, th = theme.measure_text(imgui, tostring(label or ''))
    local w = math.max((tw or 0) + 36, 120)
    local h = math.max((th or 16) + 16, 34)
    return w, h
end

-- お知らせ専用の豪華なボタン（金の縁・内側の光・ホバー・押下・選択）。ここ以外では使わない
-- opts: { hover, pressed, focused, kind='accept'|'complete', alpha, reduce_motion }
function theme.draw_popup_button(imgui, x1, y1, x2, y2, label, opts)
    opts = opts or {}
    local dl = imgui.GetWindowDrawList and imgui.GetWindowDrawList()
    if not dl or not x1 or not y1 or not x2 or not y2 then return end
    local a = tonumber(opts.alpha) or 1
    if a <= 0 then return end
    local complete = (opts.kind == 'complete')
    local hover, pressed, focused = opts.hover, opts.pressed, opts.focused
    local now = 0
    if imgui.GetTime then
        local ok, v = pcall(imgui.GetTime)
        if ok then now = tonumber(v) or 0 end
    end
    local shim = 1
    if hover and not (opts.reduce_motion) then
        shim = 0.86 + 0.14 * (0.5 + 0.5 * math.sin(now * 6.2))
    end
    local function rgba(rr, gg, bb, aa)
        return theme.rgba(math.floor(rr * 255), math.floor(gg * 255), math.floor(bb * 255), aa)
    end
    local gold = theme.palette.gold or theme.palette.accent or { 0.98, 0.83, 0.50 }
    local good = theme.palette.good or { 0.58, 0.82, 0.64 }
    local edge = complete and gold or { (gold[1] + good[1]) * 0.5, (gold[2] + good[2]) * 0.5, (gold[3] + good[3]) * 0.5 }
    local r = 8
    local inset = pressed and 1 or 0
    pcall(function ()
        -- 外の淡い光
        local glow_a = ((focused and 0.22) or (hover and 0.16) or 0.10) * a * shim
        if dl.AddRect then
            dl:AddRect({ x1 - 2, y1 - 2 }, { x2 + 2, y2 + 2 }, rgba(edge[1], edge[2], edge[3], glow_a), r + 2, 0, 3)
            dl:AddRect({ x1 - 4, y1 - 4 }, { x2 + 4, y2 + 4 }, rgba(edge[1], edge[2], edge[3], glow_a * 0.45), r + 3, 0, 2)
        end
        -- 地（上を明るく。ホバーでさらに明るく、押下で少し沈める）
        local lift = pressed and -0.05 or (hover and 0.07 or 0)
        local top = rgba(0.20 + lift, 0.18 + lift, 0.12 + lift, 0.82 * a)
        local bot = rgba(0.10 + lift * 0.5, 0.09 + lift * 0.5, 0.07, 0.78 * a)
        if complete then
            top = rgba(0.22 + lift, 0.18 + lift, 0.10 + lift, 0.84 * a)
        end
        local ix1, iy1, ix2, iy2 = x1 + inset, y1 + inset, x2 - inset, y2 + inset
        if dl.AddRectFilledMultiColor then
            dl:AddRectFilledMultiColor({ ix1, iy1 }, { ix2, iy2 }, top, top, bot, bot)
        elseif dl.AddRectFilled then
            dl:AddRectFilled({ ix1, iy1 }, { ix2, iy2 }, bot, r)
        end
        -- 面取り（上を明るく、下を暗く）
        if dl.AddLine then
            dl:AddLine({ ix1 + r * 0.4, iy1 + 1 }, { ix2 - r * 0.4, iy1 + 1 }, rgba(1, 0.95, 0.75, 0.42 * a * shim), 1.2)
            dl:AddLine({ ix1 + r * 0.4, iy2 - 1 }, { ix2 - r * 0.4, iy2 - 1 }, rgba(0.05, 0.04, 0.02, 0.45 * a), 1.2)
        end
        -- 金の縁
        local ba = ((focused and 0.95) or (hover and 0.82) or 0.70) * a * shim
        if dl.AddRect then
            dl:AddRect({ x1, y1 }, { x2, y2 }, rgba(edge[1], edge[2], edge[3], ba), r, 0, focused and 2.2 or 1.6)
            dl:AddRect({ x1 + 2, y1 + 2 }, { x2 - 2, y2 - 2 }, rgba(1, 0.96, 0.80, 0.18 * a * shim), r - 1, 0, 1.0)
        end
        -- 選択中（パッド・キー）：内側の脈打つ光
        if focused then
            local pulse = opts.reduce_motion and 1 or (0.75 + 0.25 * (0.5 + 0.5 * math.sin(now * 5.0)))
            if dl.AddRect then
                dl:AddRect({ x1 - 1, y1 - 1 }, { x2 + 1, y2 + 1 }, rgba(1, 0.97, 0.80, 0.55 * a * pulse), r + 1, 0, 2.4)
            end
        end
    end)
    -- 文字（中央。影と輪郭）
    local tw, th = theme.measure_text(imgui, tostring(label or ''))
    local tx = (x1 + x2) / 2 - (tw or 0) / 2
    local ty = (y1 + y2) / 2 - (th or 16) / 2 + (pressed and 1 or 0)
    -- 文字はクリーム色（金色だと金の地に埋もれる）。黒い影と輪郭で読む。ホバー・選択も同じ色のまま少し光る
    theme.paint_text(imgui, tx, ty, tostring(label or ''), {
        col = 'cream', bold = false, outline = true, shadow = false,
        outline_px = 1.5, glow = hover or focused, glow_col = 'cream',
        alpha = a,
    })
end


return theme
