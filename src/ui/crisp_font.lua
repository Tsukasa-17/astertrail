--[[
  Astertrail - くっきりフォント（0.1.246〜）
  Windows のメイリオを ImGui に一度だけ読む。描画では PushFont で大きさのフォントを使う。
  拡大（SetWindowFontScale）では引き伸ばさない。読めないときは今までの倍率に戻す。
  0.1.252：日本語・英字・数字の選択は使わない。保存の font_face_* は無視し、いつもメイリオ。
  0.1.264：SF テーマの英語見出しだけ、同梱の Melete Bold を同じタイミング・大きさごとに読む。
  読めなければ今のフォント（メイリオ）に戻す。毎フレームは読まない。
  フォントの読み込み（Windows のフォントを ImGui に足し、大きさごとに使う）は、
  YunaUI のやり方をもとにしています（作者 Tsukasa が YunaUI 側で書いた部分を、
  本人の許可を得て使っています）。Based on YunaUI by Yunas - https://github.com/YunasXI/yunaui
]]

local crisp = {}

-- 動的フォントが使えないときの大きさ（種類は少なく。アトラスを大きくしすぎない）
local SIZES = { 13, 16, 20, 24, 32, 36, 40, 52, 72 }
-- 3 フォントを合成するときは、CJK でアトラスが大きくなりすぎないよう種類を減らす
local MERGE_SIZES = { 13, 17, 22, 28, 36 }
local MIN_PX, MAX_PX = 8, 72
local DEFAULT_BASE = 18
-- YunaUI と同じく、最初から大きめのサイズで ImGui に付ける
local LARGE_PX = 36
local DEFAULT_FACE = 'meiryo.ttc'
local DEFAULT_BOLD = 'meiryob.ttc'

crisp.DEFAULT_FACE = DEFAULT_FACE
crisp.DEFAULT_BOLD = DEFAULT_BOLD
crisp.LARGE_PX = LARGE_PX

-- グリフ範囲（開始・終了の組、末尾 0）。ImGui が生きているあいだ保持する。
-- 英字は数字を除く。数字は半角・全角の 0-9。日本語は CJK / かな（ラテン・数字は含めない）。
crisp.RANGE_EN = {
    0x0020, 0x002F, 0x003A, 0x007E, 0x00A0, 0x00FF, 0x0100, 0x017F,
    0x2000, 0x206F, 0x2100, 0x214F,
    0,
}
crisp.RANGE_NUM = {
    0x0030, 0x0039, 0x00B2, 0x00B3, 0x00B9, 0x2070, 0x2079, 0xFF10, 0xFF19,
    0,
}
crisp.RANGE_JA = {
    0x2E80, 0x2EFF, 0x2F00, 0x2FDF, 0x3000, 0x303F, 0x3040, 0x309F,
    0x30A0, 0x30FF, 0x3190, 0x319F, 0x31F0, 0x31FF, 0x3200, 0x32FF,
    0x3300, 0x33FF, 0x3400, 0x4DBF, 0x4E00, 0x9FFF, 0xF900, 0xFAFF,
    0xFE30, 0xFE4F, 0xFF00, 0xFF0F, 0xFF1A, 0xFFEF,
    0,
}

local DISPLAY_NAMES = {
    ['meiryo.ttc'] = 'メイリオ',
    ['meiryob.ttc'] = 'メイリオ ボールド',
    ['yugothr.ttc'] = '游ゴシック',
    ['yugothm.ttc'] = '游ゴシック Medium',
    ['yugothb.ttc'] = '游ゴシック ボールド',
    ['yugothl.ttc'] = '游ゴシック Light',
    ['yumj.ttc'] = '游明朝',
    ['msgothic.ttc'] = 'ＭＳ ゴシック',
    ['msmincho.ttc'] = 'ＭＳ 明朝',
    ['meiryo.ttc'] = 'メイリオ',
    ['segoeui.ttf'] = 'Segoe UI',
    ['segoeuib.ttf'] = 'Segoe UI Bold',
    ['arial.ttf'] = 'Arial',
    ['arialbd.ttf'] = 'Arial Bold',
    ['tahoma.ttf'] = 'Tahoma',
    ['tahomabd.ttf'] = 'Tahoma Bold',
    ['consola.ttf'] = 'Consolas',
    ['bahnschrift.ttf'] = 'Bahnschrift',
    ['calibri.ttf'] = 'Calibri',
    ['times.ttf'] = 'Times New Roman',
    ['cour.ttf'] = 'Courier New',
    ['malgun.ttf'] = '맑은 고딕',
}

-- 一覧の先頭に出す（存在するファイルだけ）
local RECOMMENDED = {
    'meiryo.ttc', 'meiryob.ttc', 'YuGothM.ttc', 'YuGothR.ttc', 'YuGothB.ttc',
    'msgothic.ttc', 'msmincho.ttc', 'YuMincho.ttc', 'segoeui.ttf', 'arial.ttf',
    'tahoma.ttf', 'consola.ttf', 'bahnschrift.ttf', 'calibri.ttf',
}

local tried, pending, ready, dynamic = false, false, false, false
local fonts = { regular = nil, bold = nil }
local baked = { regular = {}, bold = {} }
local path_override = nil
local heading_path_override = nil
local heading = { tried = false, ready = false, pending = false, dynamic = false, font = nil, baked = {}, path = nil }
local list_override = nil
local loaded_key = nil
local used_merge = false
local ranges_applied = false
local split_mode = 'none'  -- none / full / partial / not_applied / same
local force_no_ranges = false
local wchar_bytes = nil
local limitations = {}
local keep_cfg, keep_ranges = {}, {}
local list_cache = { at = -1e9, list = nil }

local function win_fonts_dir()
    local windir = os.getenv('WINDIR') or os.getenv('SystemRoot') or 'C:\\Windows'
    if windir:sub(-1) == '\\' or windir:sub(-1) == '/' then
        return windir .. 'Fonts\\'
    end
    return windir .. '\\Fonts\\'
end

function crisp.default_paths()
    local dir = win_fonts_dir()
    return dir .. DEFAULT_FACE, dir .. DEFAULT_BOLD
end

function crisp._set_paths(regular, bold)
    path_override = { regular = regular, bold = bold }
end

local function file_ok(path)
    if type(path) ~= 'string' or path == '' then return false end
    local f = io.open(path, 'rb')
    if not f then return false end
    f:close()
    return true
end

function crisp._set_heading_path(path)
    heading_path_override = path
end

function crisp.heading_rel()
    -- ImGui の AddFontFromFileTTF（stb_truetype）は CFF/OTTO の .otf を読めない。
    -- 公式 OTF から TrueType 輪郭へ変換した .ttf を先に試す。
    return 'fonts/melete/Melete-Bold.ttf'
end

function crisp.heading_rel_otf()
    return 'fonts/melete/Melete-Bold.otf'
end

local function join_font(dir, rel)
    if type(dir) ~= 'string' or dir == '' then return nil end
    local sep = '/'
    if dir:find('\\') and not dir:find('/') then sep = '\\' end
    if dir:sub(-1) ~= '/' and dir:sub(-1) ~= '\\' then dir = dir .. sep end
    return dir .. tostring(rel or ''):gsub('[/\\]+', sep)
end

function crisp.heading_file()
    if heading_path_override == false then return nil end
    if type(heading_path_override) == 'string' and heading_path_override ~= '' then
        if file_ok(heading_path_override) then return heading_path_override end
        return heading_path_override
    end
    local rels = { crisp.heading_rel(), crisp.heading_rel_otf() }
    local cands = {}
    local function add(dir, rel)
        local p = join_font(dir, rel)
        if p then cands[#cands + 1] = p end
    end
    local dirs = {}
    local ad = rawget(_G, 'addon')
    if type(ad) == 'table' then dirs[#dirs + 1] = ad.path end
    local ok, plat = pcall(require, 'src.platform.ashita')
    if ok and plat and type(plat.addon_dir) == 'function' then
        local okd, d = pcall(plat.addon_dir)
        if okd then dirs[#dirs + 1] = d end
    end
    for _, rel in ipairs(rels) do
        for _, dir in ipairs(dirs) do
            add(dir, rel)
        end
    end
    for i = 1, #cands do
        if file_ok(cands[i]) then return cands[i] end
    end
    return cands[1]
end

function crisp._set_font_list(list)
    list_override = list
    list_cache = { at = -1e9, list = nil }
end

function crisp._reset()
    tried, pending, ready, dynamic = false, false, false, false
    fonts = { regular = nil, bold = nil }
    baked = { regular = {}, bold = {} }
    path_override = nil
    heading_path_override = nil
    heading = { tried = false, ready = false, pending = false, dynamic = false, font = nil, baked = {}, path = nil }
    list_override = nil
    loaded_key = nil
    used_merge = false
    ranges_applied = false
    split_mode = 'none'
    force_no_ranges = false
    wchar_bytes = nil
    limitations = {}
    keep_cfg, keep_ranges = {}, {}
    list_cache = { at = -1e9, list = nil }
end

function crisp._force_no_ranges(on)
    force_no_ranges = on and true or false
end

function crisp.sanitize_face(v)
    if type(v) ~= 'string' then return DEFAULT_FACE end
    v = v:match('^%s*(.-)%s*$') or v
    if v == '' or v == 'default' or v == 'meiryo' then return DEFAULT_FACE end
    if v:find('[/\\]') or v:find('%.%.') then return DEFAULT_FACE end
    local base = v:match('[^/\\]+$') or v
    if base ~= v then return DEFAULT_FACE end
    local ext = (base:match('%.([^%.]+)$') or ''):lower()
    if ext ~= 'ttf' and ext ~= 'otf' and ext ~= 'ttc' then return DEFAULT_FACE end
    if #base > 80 then return DEFAULT_FACE end
    return base
end

local function font_config(imgui, merge, ranges)
    local types = (imgui and imgui.types) or (rawget(_G, 'vana') and rawget(_G.vana, 'imgui') and _G.vana.imgui.types)
    if type(types) ~= 'table' or type(types.ImFontConfig) ~= 'table' then return nil end
    local T = types.ImFontConfig
    local ok, c = pcall(function ()
        if type(T.new) == 'function' then return T.new() end
        return T()
    end)
    if not ok or c == nil then return nil end
    if merge then pcall(function () c.MergeMode = true end) end
    if ranges ~= nil then pcall(function () c.GlyphRanges = ranges end) end
    keep_cfg[#keep_cfg + 1] = c
    return c
end

-- ImGui 1.92 は ImWchar が 32bit のことが多い。16bit のまま渡すと範囲が壊れ、
-- 英字が乗らず日本語フォントだけが見えることがある。GetGlyphRangesDefault の先頭で幅を見る。
local function detect_wchar_bytes(imgui)
    if wchar_bytes then return wchar_bytes end
    local ok, n = pcall(function ()
        local ffi = require('ffi')
        local io = imgui and imgui.GetIO and imgui.GetIO()
        local fonts = io and (io.Fonts or io.fonts)
        local ptr
        if fonts then
            if fonts.GetGlyphRangesDefault then ptr = fonts:GetGlyphRangesDefault()
            elseif fonts.GetGlyphRangesJapanese then ptr = fonts:GetGlyphRangesJapanese() end
        end
        if ptr == nil then return nil end
        local b = ffi.cast('const uint8_t*', ptr)
        -- 既定範囲は U+0020, U+00FF で始まる
        if b[0] == 0x20 and b[1] == 0x00 and b[2] == 0xFF and b[3] == 0x00 then return 2 end
        if b[0] == 0x20 and b[1] == 0x00 and b[2] == 0x00 and b[3] == 0x00 and b[4] == 0xFF then return 4 end
        return nil
    end)
    -- 幅が分からなければ 32bit（VanaCore の PushFont(font, size) / LegacySize = 新しい ImGui）
    wchar_bytes = (ok and n) or 4
    return wchar_bytes
end

-- 範囲バッファを、ImGui が生きているあいだ保持するポインタにする。
local function bind_ranges(imgui, values)
    if force_no_ranges then return values, false end
    if type(values) ~= 'table' or #values == 0 then return nil, false end
    local bytes = detect_wchar_bytes(imgui)
    local ok, ptr = pcall(function ()
        local ffi = require('ffi')
        local n = #values
        local typ = (bytes == 2) and 'uint16_t[?]' or 'uint32_t[?]'
        local buf = ffi.new(typ, n)
        for i = 1, n do
            buf[i - 1] = values[i]
        end
        return buf
    end)
    if ok and ptr ~= nil then
        keep_ranges[#keep_ranges + 1] = ptr
        return ptr, true
    end
    keep_ranges[#keep_ranges + 1] = values
    return values, false
end

local function add_font(imgui, path, px, cfg, ranges)
    if type(imgui) ~= 'table' or type(imgui.AddFontFromFileTTF) ~= 'function' then
        return nil
    end
    if type(path) ~= 'string' or path == '' then return nil end
    local function try(fn)
        local ok, font = pcall(fn)
        if ok and font ~= nil then return font end
        return nil
    end
    local font
    if cfg ~= nil and ranges ~= nil then
        font = try(function () return imgui.AddFontFromFileTTF(path, px, cfg, ranges) end)
    end
    if font == nil and cfg ~= nil then
        font = try(function () return imgui.AddFontFromFileTTF(path, px, cfg) end)
    end
    if font == nil and ranges ~= nil then
        font = try(function () return imgui.AddFontFromFileTTF(path, px, nil, ranges) end)
    end
    if font == nil then
        font = try(function () return imgui.AddFontFromFileTTF(path, px) end)
    end
    return font
end

local function is_dynamic(font)
    if font == nil then return false end
    local ok, ls = pcall(function () return font.LegacySize end)
    return ok and ls ~= nil
end

local function resolve_path(face, fallback_path)
    face = crisp.sanitize_face(face)
    local dir = win_fonts_dir()
    local path = dir .. face
    if file_ok(path) then return path, face, false end
    if fallback_path and file_ok(fallback_path) then return fallback_path, DEFAULT_FACE, true end
    local d1, d2 = crisp.default_paths()
    if file_ok(d1) then return d1, DEFAULT_FACE, true end
    if file_ok(d2) then return d2, DEFAULT_BOLD, true end
    return nil, nil, true
end

local function face_from(S, key)
    if type(S) ~= 'table' then return DEFAULT_FACE end
    return crisp.sanitize_face(S[key])
end

-- 太字オンかつ、その枠がメイリオのときだけ meiryob を使う（選んだ別フォントはそのまま）
local function apply_bold_face(face, use_bold)
    if use_bold and face:lower() == DEFAULT_FACE then return DEFAULT_BOLD end
    return face
end

function crisp.face_key(S)
    -- 0.1.252：選択しない。太字スイッチは meiryob を先に読んであるので再読み込み不要。
    return 'meiryo'
end

function crisp.needs_reload(S)
    if not tried or loaded_key == nil then return false end
    return crisp.face_key(S) ~= loaded_key
end

function crisp.limitations()
    return limitations
end

function crisp.used_merge()
    return used_merge
end

function crisp.ranges_applied()
    return ranges_applied
end

function crisp.split_mode()
    return split_mode
end

-- 設定の 3 枠が違うのに、今の読み込みで分けられていない／一部だけ、を画面に出すため
function crisp.split_state(S)
    if type(S) ~= 'table' then return 'none' end
    local ja = face_from(S, 'font_face_ja'):lower()
    local en = face_from(S, 'font_face_en'):lower()
    local num = face_from(S, 'font_face_num'):lower()
    if ja == en and en == num then return 'same' end
    if crisp.needs_reload(S) then return 'needs_reload' end
    return split_mode
end

local function note(code)
    for i = 1, #limitations do
        if limitations[i] == code then return end
    end
    limitations[#limitations + 1] = code
end

local function load_one_merged(imgui, path_en, path_num, path_ja, px, range_ptrs)
    -- 英字 → 数字を合成 → 日本語を合成。失敗したら nil。
    local cfg_en = font_config(imgui, false, range_ptrs.en)
    local en = add_font(imgui, path_en, px, cfg_en, range_ptrs.en)
    if not en then return nil, false end
    local ok_merge = false
    local cfg_num = font_config(imgui, true, range_ptrs.num)
    if cfg_num then
        pcall(function () cfg_num.DstFont = en end)
        local num = add_font(imgui, path_num, px, cfg_num, range_ptrs.num)
        if num then ok_merge = true end
    else
        note('no_merge')
    end
    local cfg_ja = font_config(imgui, true, range_ptrs.ja)
    if cfg_ja then
        pcall(function () cfg_ja.DstFont = en end)
        local ja = add_font(imgui, path_ja, px, cfg_ja, range_ptrs.ja)
        if ja then ok_merge = true end
    else
        note('no_merge')
    end
    return en, ok_merge
end

local function same_path(a, b)
    if a == b then return true end
    if type(a) ~= 'string' or type(b) ~= 'string' then return false end
    return a:gsub('/', '\\'):lower() == b:gsub('/', '\\'):lower()
end

-- 同梱の Melete Bold（英語見出し専用）。アトラスは読み込み時、大きさごと。失敗しても本体は続ける。
local heading_logged = false
local function heading_debug_path()
    local ad = rawget(_G, 'addon')
    local dir = ad and ad.path
    if type(dir) ~= 'string' or dir == '' then return nil end
    if dir:find('workspace', 1, true) then return nil end
    if dir:sub(-1) ~= '/' and dir:sub(-1) ~= '\\' then
        local sep = dir:find('\\') and '\\' or '/'
        dir = dir .. sep
    end
    return dir .. 'debug_heading_font.txt'
end

local function log_heading(lines, mode)
    local path = heading_debug_path()
    if not path then return end
    if mode ~= 'append' then
        if heading_logged and mode ~= 'replace' then return end
        heading_logged = true
    end
    local f = io.open(path, (mode == 'append') and 'a' or 'w')
    if not f then return end
    f:write(table.concat(lines, '\n') .. '\n')
    f:close()
end

local function measure_w(imgui, s)
    if not imgui or not imgui.CalcTextSize then return nil end
    local ok, a, b = pcall(imgui.CalcTextSize, s)
    if not ok then return nil end
    if type(a) == 'table' then return tonumber(a.x or a[1]) end
    return tonumber(a)
end

local function font_ptr(imgui)
    if not imgui or not imgui.GetFont then return nil end
    local ok, f = pcall(imgui.GetFont)
    if ok then return f end
    return nil
end

local function has_glyph(font, ch)
    if not font then return false end
    local code = (type(ch) == 'number') and ch or (tostring(ch):byte(1) or 65)
    if font.FindGlyph then
        local ok, g = pcall(function () return font:FindGlyph(code) end)
        if ok and g ~= nil then return true end
    end
    if font.FindGlyphNoFallback then
        local ok, g = pcall(function () return font:FindGlyphNoFallback(code) end)
        if ok and g ~= nil then return true end
    end
    return nil
end

local function file_magic(path)
    local f = io.open(path, 'rb')
    if not f then return '' end
    local s = f:read(4) or ''
    f:close()
    return s
end

local function hex_magic(s)
    if type(s) ~= 'string' then return '' end
    local t = {}
    for i = 1, #s do t[#t + 1] = string.format('%02X', s:byte(i)) end
    return table.concat(t, ' ')
end

local function load_heading(imgui)
    heading.tried = true
    heading.ready, heading.pending, heading.dynamic = false, false, false
    heading.font, heading.baked, heading.path = nil, {}, nil
    if heading_path_override == false then
        log_heading({ 'heading load skipped (override false)' })
        return false
    end
    local path = crisp.heading_file()
    heading.path = path
    local magic = path and file_magic(path) or ''
    local function fail(why)
        log_heading({
            'astertrail heading font debug',
            'path_tried=' .. tostring(path or ''),
            'file_ok=' .. tostring(path and file_ok(path) or false),
            'magic=' .. hex_magic(magic),
            'add_font=fail',
            'why=' .. tostring(why or ''),
            'ready=false',
        })
        return false
    end
    if not path or not file_ok(path) then return fail('file_not_found') end
    -- メイリオと同じく範囲を付けずに読む。0.1.265 は 0x20–0x7E を自前で渡していたが、
    -- ImWchar の幅を間違えると英字がフォントに乗らず、成功しても描画はメイリオへ戻って見えた。
    local wchar = detect_wchar_bytes(imgui)
    local probe = add_font(imgui, path, LARGE_PX)
    if not probe then return fail('AddFontFromFileTTF_nil') end
    log_heading({
        'astertrail heading font debug',
        'path_tried=' .. tostring(path),
        'file_ok=true',
        'magic=' .. hex_magic(magic),
        'add_font=ok',
        'dynamic=' .. tostring(is_dynamic(probe)),
        'wchar_bytes=' .. tostring(wchar or ''),
        'ranges=default',
        'why=',
        'ready=pending',
    })
    if is_dynamic(probe) then
        heading.dynamic = true
        heading.font = probe
        heading.pending = true
        return true
    end
    heading.dynamic = false
    for _, px in ipairs(SIZES) do
        local f
        if px == LARGE_PX then
            f = probe
        else
            f = add_font(imgui, path, px, cfg, ok_r and ranges or nil) or add_font(imgui, path, px)
        end
        if f then heading.baked[#heading.baked + 1] = { f, px } end
    end
    if #heading.baked == 0 then return false end
    heading.pending = true
    return true
end

function crisp.load(imgui, S)
    if tried then return ready end
    tried = true
    ready, pending, dynamic = false, false, false
    used_merge, ranges_applied, limitations = false, false, {}
    split_mode = 'none'
    loaded_key = nil
    if type(imgui) ~= 'table' or type(imgui.AddFontFromFileTTF) ~= 'function' then
        return false
    end

    local path_r, path_b
    if path_override then
        path_r, path_b = path_override.regular, path_override.bold
        loaded_key = crisp.face_key(S)
    else
        -- 0.1.252：保存の font_face_* は無視し、いつもメイリオ（太字ファイルも先に読む）
        local d1, d2 = crisp.default_paths()
        local p_ja = select(1, resolve_path(DEFAULT_FACE, d1)) or d1
        path_r, path_b = p_ja, p_ja
        local pb = select(1, resolve_path(DEFAULT_BOLD, d2 or d1))
        if pb then path_b = pb end
        loaded_key = crisp.face_key(S)
        split_mode = 'same'
        if not file_ok(path_b) then path_b = path_r end
    end

    if not file_ok(path_r) then
        if file_ok(path_b) then
            path_r = path_b
        else
            return false
        end
    end
    if not file_ok(path_b) then path_b = path_r end

    -- まず大きめのサイズで読み、動的フォント（任意の大きさで PushFont）にできるか見る
    local probe = add_font(imgui, path_r, LARGE_PX)
    if not probe then return false end

    if is_dynamic(probe) then
        dynamic = true
        fonts.regular = probe
        if path_b ~= path_r then
            fonts.bold = add_font(imgui, path_b, LARGE_PX) or probe
        else
            fonts.bold = probe
        end
        load_heading(imgui)
        pending = true
        ready = false
        return false
    end

    -- 古めの ImGui：決めた大きさだけ焼く。引き伸ばさない。
    dynamic = false
    for _, face in ipairs({ { 'regular', path_r }, { 'bold', path_b } }) do
        local list = baked[face[1]]
        for _, px in ipairs(SIZES) do
            local f
            if px == LARGE_PX and face[1] == 'regular' then
                f = probe
            else
                f = add_font(imgui, face[2], px)
            end
            if f then list[#list + 1] = { f, px } end
        end
    end
    if #baked.bold == 0 then baked.bold = baked.regular end
    if #baked.regular == 0 then return false end
    fonts.regular, fonts.bold = nil, nil
    load_heading(imgui)
    pending = true
    ready = false
    return false
end

-- 毎フレーム、描画の前に呼ぶ。初回に読み、アトラスが載る次のフレームから使える。
function crisp.ensure(imgui, S)
    if not tried then
        crisp.load(imgui, S)
        return false
    end
    if pending then
        pending = false
        if dynamic then
            ready = fonts.regular ~= nil
        else
            ready = baked.regular and #baked.regular > 0
        end
        if heading.pending then
            heading.pending = false
            if heading.dynamic then
                heading.ready = heading.font ~= nil
            else
                heading.ready = heading.baked and #heading.baked > 0
            end
            log_heading({
                '--- after ensure ---',
                'ready=' .. tostring(heading.ready),
                'dynamic=' .. tostring(heading.dynamic),
                'font=' .. tostring(heading.font ~= nil),
                'baked=' .. tostring(heading.baked and #heading.baked or 0),
                'crisp_ready=' .. tostring(ready),
                'font_crisp=' .. tostring(S and S.font_crisp),
                'glyph_A=' .. tostring(has_glyph(heading.font, 65)),
            }, 'append')
        end
    end
    return ready
end

function crisp.ready() return ready end
function crisp.dynamic() return dynamic end
function crisp.tried() return tried end

function crisp.active(S)
    return ready and S ~= nil and S.font_crisp ~= false
end

function crisp.pick_px(base, scale)
    local b = tonumber(base) or DEFAULT_BASE
    if b <= 0 then b = DEFAULT_BASE end
    local s = tonumber(scale) or 1
    local px = b * s
    if px < MIN_PX then px = MIN_PX end
    if px > MAX_PX then px = MAX_PX end
    return px
end

function crisp.pick_static(list, px)
    if type(list) ~= 'table' or #list == 0 then return nil, nil end
    px = tonumber(px) or DEFAULT_BASE
    local best, bd = list[1], math.abs(list[1][2] - px)
    for i = 2, #list do
        local e = list[i]
        local d = math.abs(e[2] - px)
        -- 差が同じなら、少し大きめ（潰しにくい）
        if d < bd or (d == bd and e[2] >= px and best[2] < px) then
            best, bd = e, d
        end
    end
    return best[1], best[2]
end

local function push_font(imgui, font, px)
    if not imgui or type(imgui.PushFont) ~= 'function' or font == nil then return false end
    if px then
        local ok = pcall(function () imgui.PushFont(font, px) end)
        if ok then return true end
    end
    return pcall(function () imgui.PushFont(font) end)
end

function crisp.push(imgui, S, base, scale, opts)
    if not crisp.active(S) then return false end
    local px = crisp.pick_px(base, scale)
    local use_bold = S and S.font_crisp_bold == true
    if type(opts) == 'table' then
        if opts.bold == true then use_bold = true end
        if opts.bold == false then use_bold = false end
    end
    if dynamic then
        local f = use_bold and fonts.bold or fonts.regular
        if not f then return false end
        if push_font(imgui, f, px) then
            if imgui.SetWindowFontScale then pcall(imgui.SetWindowFontScale, 1.0) end
            return true
        end
        return false
    end
    local list = use_bold and baked.bold or baked.regular
    local f = crisp.pick_static(list, px)
    if not f then return false end
    if push_font(imgui, f, nil) then
        if imgui.SetWindowFontScale then pcall(imgui.SetWindowFontScale, 1.0) end
        return true
    end
    return false
end

function crisp.heading_ready()
    return heading.ready == true
end

function crisp.heading_path()
    return heading.path
end

function crisp.heading_dynamic()
    return heading.dynamic == true
end

-- SF の英語見出し。くっきり（メイリオ）のオン／オフとは別に載せる。
-- 0.1.266 の実機ログでは heading.ready=true でも crisp_inactive（font_crisp=false）で押せず、
-- 字間だけ広がった既定フォントに見えた。読めなければ false（呼び出し側が今のフォントへ戻す）。
local heading_push_logged = false
function crisp.push_heading(imgui, S, base, scale)
    local why
    if not heading.ready then why = 'heading_not_ready' end
    local px = crisp.pick_px(base, scale)
    local ok_push, used_dynamic = false, heading.dynamic == true
    if not why then
        if heading.dynamic then
            if heading.font and push_font(imgui, heading.font, px) then
                if imgui.SetWindowFontScale then pcall(imgui.SetWindowFontScale, 1.0) end
                ok_push = true
            else
                why = 'push_font_failed'
            end
        else
            local f = crisp.pick_static(heading.baked, px)
            if not f then
                why = 'no_baked_size'
            elseif push_font(imgui, f, nil) then
                if imgui.SetWindowFontScale then pcall(imgui.SetWindowFontScale, 1.0) end
                ok_push = true
            else
                why = 'push_font_failed'
            end
        end
    end
    if not heading_push_logged then
        heading_push_logged = true
        local cur = font_ptr(imgui)
        local wa = measure_w(imgui, 'A')
        local wlogo = measure_w(imgui, 'ASTERTRAIL')
        log_heading({
            '--- first push_heading ---',
            'ok=' .. tostring(ok_push),
            'why=' .. tostring(why or ''),
            'px=' .. tostring(px),
            'dynamic=' .. tostring(used_dynamic),
            'font_crisp=' .. tostring(S and S.font_crisp),
            'crisp_active=' .. tostring(crisp.active(S)),
            'gate=heading_ready_only',
            'same_font=' .. tostring(cur ~= nil and cur == heading.font),
            'glyph_A=' .. tostring(has_glyph(ok_push and cur or heading.font, 65)),
            'width_A=' .. tostring(wa or ''),
            'width_ASTERTRAIL=' .. tostring(wlogo or ''),
        }, 'append')
    end
    return ok_push
end

function crisp.pop(imgui)
    if imgui and type(imgui.PopFont) == 'function' then
        pcall(imgui.PopFont)
    end
end

local FONT_EXT = { ttf = true, otf = true, ttc = true }

local function take_names(names, into, seen, dir)
    if type(names) ~= 'table' then return 0 end
    local got = 0
    for k, n in pairs(names) do
        if type(n) ~= 'string' and type(k) == 'string' then n = k end
        if type(n) == 'table' then n = n.name or n.Name or n[1] end
        if type(n) == 'string' then
            n = n:match('[^/\\]+$') or n
            local ext = (n:match('%.([^%.]+)$') or ''):lower()
            local key = n:lower()
            if FONT_EXT[ext] and not seen[key] then
                local path = dir .. n
                if file_ok(path) then
                    seen[key] = true
                    into[#into + 1] = n
                    got = got + 1
                end
            end
        end
    end
    return got
end

function crisp.font_list()
    if list_override then return list_override end
    if list_cache.list and os.clock() < list_cache.at then return list_cache.list end
    local dir = win_fonts_dir()
    local list, seen = {}, {}
    local function try_list(fn, tag)
        local ok, names = pcall(fn)
        if ok then take_names(names, list, seen, dir) end
    end
    local vana = rawget(_G, 'vana')
    if vana and vana.fs and type(vana.fs.list) == 'function' then
        try_list(function () return vana.fs.list(dir, '.*\\.[tToO][tT][fFcC]$', 'files') end)
        if #list == 0 then
            try_list(function () return vana.fs.list(dir, '*.ttf', 'files') end)
            try_list(function () return vana.fs.list(dir, '*.otf', 'files') end)
            try_list(function () return vana.fs.list(dir, '*.ttc', 'files') end)
        end
    end
    local ashita = rawget(_G, 'ashita')
    local gd = ashita and ashita.fs and ashita.fs.get_directory
    if #list == 0 and type(gd) == 'function' then
        for _, flt in ipairs({ '.*\\.[tT][tT][fF]$', '.*\\.[oO][tT][fF]$', '.*\\.[tT][tT][cC]$', '*.ttf', '*.otf', '*.ttc' }) do
            try_list(function () return gd(dir, flt) end)
        end
    end
    -- 推奨フォントは、一覧に無くてもファイルがあれば足す
    take_names(RECOMMENDED, list, seen, dir)
    table.sort(list, function (a, b) return a:lower() < b:lower() end)
    list_cache.list = list
    list_cache.at = os.clock() + 5
    return list
end

function crisp.display_name(face)
    face = crisp.sanitize_face(face)
    local pretty = DISPLAY_NAMES[face:lower()]
    if pretty then return pretty .. '（' .. face .. '）' end
    return face
end

function crisp.font_choices(S)
    local list = crisp.font_list()
    local seen = {}
    local choices = {}
    local function add(face)
        face = crisp.sanitize_face(face)
        local k = face:lower()
        if seen[k] then return end
        seen[k] = true
        choices[#choices + 1] = { value = face, label = crisp.display_name(face) }
    end
    -- 推奨を先に（存在する／一覧にあるもの）
    local have = {}
    for _, n in ipairs(list) do have[n:lower()] = n end
    for _, rec in ipairs(RECOMMENDED) do
        local hit = have[rec:lower()]
        if hit then add(hit) end
    end
    for _, n in ipairs(list) do add(n) end
    if S then
        add(face_from(S, 'font_face_ja'))
        add(face_from(S, 'font_face_en'))
        add(face_from(S, 'font_face_num'))
    end
    add(DEFAULT_FACE)
    return choices
end

return crisp
