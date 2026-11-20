--[[
  Astertrail - アイテムのツールチップ（0.1.262〜、見た目は 0.1.271〜）
  - 名前に乗せたとき、暗い丸角のカードを自分で描く（左に大きいアイコン、右に名前と装備欄）。
  - 名前と説明は、実行時に vana.ashita.item(id, 1) の Name[1] / Description[1]（日本語）を優先する。
  - 取れなければ同梱の vana.gamedata（英語）に戻す。抽出文は同梱しない。
  - 装備はスロット（日本語）・レベル・ジョブ（日本語1文字、全部なら「全ジョブ」）を出す。
  - 装備でない品は、アイコン・名前・説明だけ（ギルはアイテムにしない）。
  - アイコンはこれまでどおり vana.ashita.item_icon。
  - ゲームや他アドオンの描画や画像はコピーしない。アイコンが読めなければ出さない。
  - 数のほうの「場所の内訳」は、これまでどおり別のホバー。
]]

local theme = require('src.ui.theme')
local gil = require('src.core.gil')

local M = {}

-- テスト用：実機の API の代わりに渡す { item=, key_item=, job=, icon=, load_texture= }
local source

function M.set_source(src)
    source = src
end

function M.clear_source()
    source = nil
    M._tex_cache = {}
    M._tex_order = {}
    M._gil_tex = nil
    M._gil_icon_kind = nil
    M.last_icon_kind = nil
    M.last_desc_lang = nil
    M._ja_cache = {}
    M._reset_icon_log()
    M._reset_ja_log()
end

M._tex_cache = {}
M._tex_order = {}
M.TEX_LIMIT = 48
M._ja_cache = {}
local icon_log_written = false
local ja_log_written = false
function M._reset_icon_log()
    icon_log_written = false
end
function M._reset_ja_log()
    ja_log_written = false
end

-- 公式の短いジョブ名が読めないときの控え（id 1〜22。並べはゲームどおり）
local JOB_SHORT = {
    'WAR', 'MNK', 'WHM', 'BLM', 'RDM', 'THF', 'PLD', 'DRK', 'BST', 'BRD',
    'RNG', 'SAM', 'NIN', 'DRG', 'SMN', 'BLU', 'COR', 'PUP', 'DNC', 'SCH',
    'GEO', 'RUN',
}

-- 日本語の1文字（ゲームの装備欄で使う略。リソースに1文字が無ければこれを使う）
local JOB_JA = {
    '戦', 'モ', '白', '黒', '赤', 'シ', 'ナ', '暗', '獣', '詩',
    '狩', '侍', '忍', '竜', '召', '青', 'コ', 'か', '踊', '学',
    '風', '剣',
}
M.JOB_COUNT = 22

-- 装備スロットのビット（公式の並び）と日本語名。耳・指は左右をまとめる
local SLOT_BITS = {
    { 0x0001, 'メイン' }, { 0x0002, 'サブ' }, { 0x0004, '遠隔' }, { 0x0008, '矢弾' },
    { 0x0010, '頭' }, { 0x0020, '胴' }, { 0x0040, '両手' }, { 0x0080, '両脚' },
    { 0x0100, '両足' }, { 0x0200, '首' }, { 0x0400, '腰' },
    { 0x0800, '耳' }, { 0x1000, '耳' }, { 0x2000, '指' }, { 0x4000, '指' },
    { 0x8000, '背' },
}
local SLOT_NAME = {
    main = 'メイン', sub = 'サブ', range = '遠隔', ranged = '遠隔', ammo = '矢弾',
    head = '頭', body = '胴', hands = '両手', hand = '両手', legs = '両脚', leg = '両脚',
    feet = '両足', foot = '両足', neck = '首', waist = '腰', back = '背',
    ear = '耳', earring = '耳', lear = '耳', rear = '耳', ['l.ear'] = '耳', ['r.ear'] = '耳',
    ring = '指', lring = '指', rring = '指', ['l.ring'] = '指', ['r.ring'] = '指',
    ['メイン'] = 'メイン', ['サブ'] = 'サブ', ['遠隔'] = '遠隔', ['矢弾'] = '矢弾',
    ['頭'] = '頭', ['胴'] = '胴', ['両手'] = '両手', ['両脚'] = '両脚', ['両足'] = '両足',
    ['首'] = '首', ['腰'] = '腰', ['耳'] = '耳', ['指'] = '指', ['背'] = '背',
}

local function platform()
    local ok, p = pcall(require, 'src.platform.ashita')
    if ok then return p end
    return nil
end

local function fetch_item(id)
    if source and source.item then return source.item(id) end
    local p = platform()
    if p and p.gamedata_item then return p.gamedata_item(id) end
    return nil
end

local function fetch_key(id)
    if source and source.key_item then return source.key_item(id) end
    local p = platform()
    if p and p.gamedata_key_item then return p.gamedata_key_item(id) end
    return nil
end

local function fetch_job(id)
    if source and source.job then return source.job(id) end
    local p = platform()
    if p and p.gamedata_job then return p.gamedata_job(id) end
    return nil
end

local function fetch_icon(id)
    if source and source.icon then return source.icon(id) end
    local p = platform()
    if p and p.item_icon_bytes then return p.item_icon_bytes(id) end
    return nil
end

local function u16(s, i)
    if i + 1 > #s then return nil end
    local a, b = s:byte(i, i + 1)
    return a + b * 256
end

local function u32(s, i)
    if i + 3 > #s then return nil end
    local a, b, c, d = s:byte(i, i + 3)
    return a + b * 256 + c * 65536 + d * 16777216
end

local function i32(s, i)
    local v = u32(s, i)
    if not v then return nil end
    if v >= 2147483648 then return v - 4294967296 end
    return v
end

-- 説明文が日本語か（ひらがな・カタカナ・漢字があれば ja）
function M.language_of(text)
    if type(text) ~= 'string' or text == '' then return 'unknown' end
    -- UTF-8 のひらがな・カタカナ・CJK
    if text:find('\227[\129\130][\128-\191]') then return 'ja' end -- ひらがな U+3040-309F（概ね）
    if text:find('\227[\131][\128-\191]') then return 'ja' end -- カタカナ
    if text:find('[\227\228\229\230\233][\128-\191][\128-\191]') then
        -- 漢字・その他の CJK を広く拾う（英数字のみならここに来ない）
        if text:find('[\228-\233][\128-\191][\128-\191]') then return 'ja' end
    end
    if text:find('[\65-\90\97-\122]') then return 'en' end
    return 'unknown'
end

-- FFXI の制御コードを落として読める文にする（属性は {Fire} など）
local ELEM_NAME = {
    [0x1F] = 'Fire', [0x20] = 'Ice', [0x21] = 'Wind', [0x22] = 'Earth',
    [0x23] = 'Thunder', [0x24] = 'Water', [0x25] = 'Light', [0x26] = 'Dark',
}

local function strip_ffxi_controls(s)
    if type(s) ~= 'string' or s == '' then return s or '' end
    local out, i, n = {}, 1, #s
    while i <= n do
        local c = s:byte(i)
        if c == 0xEF and i < n then
            local n2 = s:byte(i + 1)
            local el = ELEM_NAME[n2]
            if el then
                out[#out + 1] = '{' .. el .. '}'
                i = i + 2
            elseif n2 and n2 >= 0x27 and n2 <= 0x2E then
                -- 自動翻訳の括弧、ON/OFF など
                i = i + 2
            elseif n2 and n2 < 0x80 then
                -- 未知の 0xEF 制御は1組で落とす（UTF-8 の続きバイトは 0x80 以上）
                i = i + 2
            else
                -- UTF-8 の3バイト文字（全角Ｄは EF BC A4）や、Shift_JIS の 0xEF 始まりはそのまま
                out[#out + 1] = s:sub(i, i)
                i = i + 1
            end
        elseif c == 0x82 and i < n and s:byte(i + 1) == 0x63 then
            -- 日本語アイテム DAT のダメージ記号「Ｄ」（Shift_JIS 0x82 0x63）。字体に無く ?? と出るので D にする
            out[#out + 1] = 'D'
            i = i + 2
        elseif c == 0xFD then
            local j = i + 1
            while j <= n and j <= i + 5 and s:byte(j) ~= 0xFD do j = j + 1 end
            if j <= n and s:byte(j) == 0xFD then i = j + 1 else i = i + 1 end
        elseif c == 10 or c == 13 then
            if c == 10 or (c == 13 and (i == n or s:byte(i + 1) ~= 10)) then
                out[#out + 1] = '\n'
            end
            i = i + 1
        elseif c == 9 or (c >= 32 and c ~= 127) then
            out[#out + 1] = s:sub(i, i)
            i = i + 1
        else
            i = i + 1
        end
    end
    local text = table.concat(out):gsub('\n+$', '')
    return text
end

-- 変換後の全角Ｄ（U+FF24）や、字体が出せず残った ?? を ASCII の D にする
local function map_damage_glyph(s)
    if type(s) ~= 'string' or s == '' then return s or '' end
    -- UTF-8 の Ｄ (EF BC A4) と、そのまま残った Shift_JIS 0x82 0x63
    s = s:gsub('\239\188\164', 'D')
    s = s:gsub(string.char(0x82, 0x63), 'D')
    return s
end

-- ダメージと隔は別行で出すので、説明の先頭の重複（D38 隔236 / ??38 隔236）を除く
local function strip_leading_dmg_delay(s)
    if type(s) ~= 'string' or s == '' then return s or '' end
    s = map_damage_glyph(s)
    s = s:gsub('^[ \t\r\n]+', '')
    local n
    s, n = s:gsub('^[DＤ](%d+)%s*隔%s*:?%s*%d+[ \t]*', '', 1)
    if n == 0 then
        s, n = s:gsub('^%?%?(%d+)%s*隔%s*:?%s*%d+[ \t]*', '', 1)
    end
    if n == 0 then
        s, n = s:gsub('^DMG:%s*%d+%s*Delay:%s*%d+[ \t]*\n?', '', 1)
    end
    s = s:gsub('^[ \t\r\n]+', '')
    return s
end

local function looks_utf8(s)
    if type(s) ~= 'string' then return false end
    local i, n = 1, #s
    while i <= n do
        local c = s:byte(i)
        if c < 0x80 then
            i = i + 1
        elseif c >= 0xC2 and c <= 0xDF and i + 1 <= n then
            local a = s:byte(i + 1)
            if a < 0x80 or a > 0xBF then return false end
            i = i + 2
        elseif c >= 0xE0 and c <= 0xEF and i + 2 <= n then
            local a, b = s:byte(i + 1, i + 2)
            if a < 0x80 or a > 0xBF or b < 0x80 or b > 0xBF then return false end
            if c == 0xE0 and a < 0xA0 then return false end
            if c == 0xED and a > 0x9F then return false end
            i = i + 3
        elseif c >= 0xF0 and c <= 0xF4 and i + 3 <= n then
            local a, b, d = s:byte(i + 1, i + 3)
            if a < 0x80 or a > 0xBF or b < 0x80 or b > 0xBF or d < 0x80 or d > 0xBF then return false end
            i = i + 4
        else
            return false
        end
    end
    return true
end

local function to_utf8(s)
    if type(s) ~= 'string' or s == '' then return s or '', 'empty' end
    s = strip_ffxi_controls(s)
    if s == '' then return '', 'empty' end
    if looks_utf8(s) then return map_damage_glyph(s), 'utf8' end
    local p = platform()
    if p and p.text_from_game then
        local ok, out = pcall(p.text_from_game, s)
        if ok and type(out) == 'string' and out ~= '' then
            return map_damage_glyph(strip_ffxi_controls(out)), 'sjis'
        end
    end
    local ok, ext = pcall(require, 'src.platform.vanacore_ext')
    if ok and ext and ext.from_shift_jis then
        local ok2, out = pcall(ext.from_shift_jis, s)
        if ok2 and type(out) == 'string' and out ~= '' then
            return map_damage_glyph(strip_ffxi_controls(out)), 'sjis'
        end
    end
    -- 公式の変換が無いとき（テストや保険）
    local okc, cp = pcall(require, 'src.platform.cp932')
    if okc and cp and cp.to_utf8 then
        local ok2, out = pcall(cp.to_utf8, s)
        if ok2 and type(out) == 'string' and out ~= '' and looks_utf8(out) then
            return map_damage_glyph(strip_ffxi_controls(out)), 'sjis'
        end
    end
    return map_damage_glyph(s), 'raw'
end

local function nonempty(s)
    return type(s) == 'string' and s:match('%S') ~= nil
end

local function cstr_at(obj, field, index)
    if obj == nil or index == nil or index == 0 then return nil end
    local slot
    if type(obj) == 'table' then
        slot = obj[field]
    else
        local ok, v = pcall(function () return obj[field] end)
        if ok then slot = v end
    end
    if slot == nil then return nil end
    local raw
    if type(slot) == 'string' then
        raw = slot
    elseif type(slot) == 'table' then
        -- C 配列は 0=既定, 1=日本語。Lua 表なら 2 が日本語のこともあるので 1 を優先し、0 は使わない。
        raw = slot[index]
    else
        local ok, v = pcall(function () return slot[index] end)
        if ok then raw = v end
    end
    if raw == nil then return nil end
    if type(raw) == 'string' then return raw end
    local ok, ffi = pcall(require, 'ffi')
    if ok and ffi and ffi.string then
        local oks, s = pcall(ffi.string, raw)
        if oks and type(s) == 'string' then return s end
    end
    return nil
end

local item_cdef_ok
local function ensure_item_cdef()
    if item_cdef_ok ~= nil then return item_cdef_ok end
    local ok, ffi = pcall(require, 'ffi')
    if not ok or not ffi then item_cdef_ok = false; return false end
    local cdef = [[
typedef struct { uint16_t AbilityId; int8_t Level; uint8_t Unknown0000; } at_IMonAbility;
typedef struct {
    uint32_t Id; uint16_t Flags; uint16_t StackSize; uint16_t Type; uint16_t ResourceId; uint16_t Targets;
    uint16_t Level; uint16_t Slots; uint16_t Races; uint32_t Jobs; uint16_t SuperiorLevel; uint16_t ShieldSize;
    uint8_t MaxCharges; uint16_t CastTime; uint16_t CastDelay; uint32_t RecastDelay; uint16_t BaseItemId;
    uint16_t ItemLevel; uint16_t Damage; uint16_t Delay; uint16_t DPS; uint8_t Skill; uint8_t JugSize;
    uint32_t WeaponUnknown0000; uint8_t Range; uint8_t AreaRange; uint8_t AreaShapeType; uint8_t AreaCursorTargetType;
    uint16_t Element; uint32_t Storage; uint32_t AttachmentFlags;
    uint16_t InstinctCost;
    uint16_t MonstrosityId; char MonstrosityName[0x20]; uint8_t MonstrosityData[0x0A];
    at_IMonAbility MonstrosityAbilities[0x10];
    uint16_t PuppetSlotId; uint32_t PuppetElements;
    uint8_t SlipData[0x46];
    uint16_t UsableData0000; uint32_t UsableData0001; uint32_t UsableData0002;
    uint32_t Article;
    const char* Name[3]; const char* Description[3]; const char* LogNameSingular[3]; const char* LogNamePlural[3];
    uint32_t ImageSize; uint8_t ImageType; uint8_t ImageName[0x10]; uint8_t Bitmap[0x980];
} at_IItem;
]]
    local okc = pcall(ffi.cdef, cdef)
    item_cdef_ok = okc and true or false
    return item_cdef_ok
end

local function read_item_lang1(it)
    if it == nil then return nil, nil, 'nil' end
    local name = cstr_at(it, 'Name', 1)
    local desc = cstr_at(it, 'Description', 1)
    if nonempty(name) or nonempty(desc) then
        return name or '', desc or '', 'fields'
    end
    local ok, ffi = pcall(require, 'ffi')
    if not ok or not ffi or not ensure_item_cdef() then
        return nil, nil, 'no_ffi'
    end
    local ptr
    if type(it) == 'cdata' then
        ptr = it
    else
        local okc, p = pcall(ffi.cast, 'at_IItem*', it)
        if okc then ptr = p end
    end
    if ptr == nil then return nil, nil, 'no_ptr' end
    local function at(arr)
        local okv, v = pcall(function () return arr[1] end)
        if not okv or v == nil then return nil end
        local oks, s = pcall(ffi.string, v)
        if oks and type(s) == 'string' then return s end
        return nil
    end
    local okp, nm, ds
    okp, nm = pcall(at, ptr.Name)
    local okd
    okd, ds = pcall(at, ptr.Description)
    if nonempty(nm) or nonempty(ds) then
        return nm or '', ds or '', 'ffi'
    end
    return nil, nil, 'empty'
end

local function vana_of()
    local v = rawget(_G, 'vana')
    if type(v) == 'table' then return v end
    return nil
end

-- 日本語の名前と説明。言語は必ず 1。0 は使わない。番号ごとに覚える。
function M.clean_description(s)
    local text = to_utf8(s)
    return strip_leading_dmg_delay(text)
end

function M.live_ja(id)
    id = tonumber(id)
    if not id then return nil end
    if M._ja_cache[id] ~= nil then return M._ja_cache[id] end
    local rec = { id = id, name = '', description = '', encoding = '', how = '', why = '' }
    if source and source.live_ja then
        local ok, got = pcall(source.live_ja, id, 1)
        if ok and type(got) == 'table' then
            rec.name = got.name or got.Name or ''
            rec.description = got.description or got.Description or got.desc or ''
            rec.how = 'source'
        else
            rec.why = 'source_failed'
        end
    else
        local v = vana_of()
        local ash = v and v.ashita
        if not ash or type(ash.item) ~= 'function' then
            rec.why = 'no_api'
        else
            local ok, it = pcall(ash.item, id, 1)
            if not ok then
                rec.why = 'item_error'
            elseif it == nil then
                rec.why = 'item_nil'
            else
                local nm, ds, how = read_item_lang1(it)
                rec.how = how or ''
                rec.name = nm or ''
                rec.description = ds or ''
                if rec.name == '' and rec.description == '' then rec.why = rec.why ~= '' and rec.why or 'empty' end
            end
        end
        -- だいじなものなど、文字列表があれば同じ言語 1 で補う
        if rec.name == '' and ash and type(ash.string) == 'function' then
            local oks, ns = pcall(ash.string, 'keyitems.names', id, 1)
            if oks and nonempty(ns) then rec.name, rec.how = ns, 'string' end
            local okd, ds = pcall(ash.string, 'keyitems.descriptions', id, 1)
            if okd and nonempty(ds) then rec.description = ds end
        end
    end
    local enc
    rec.name, enc = to_utf8(rec.name)
    rec.description, rec.encoding = to_utf8(rec.description)
    rec.description = strip_leading_dmg_delay(rec.description)
    if rec.name ~= '' and enc and rec.encoding == 'empty' then rec.encoding = enc end
    rec.language = M.language_of(rec.description ~= '' and rec.description or rec.name)
    M._ja_cache[id] = rec
    if id == 4358 then pcall(M.log_ja_debug, rec) end
    if rec.name == '' and rec.description == '' then return nil end
    return rec
end

local function icon_size_px(imgui)
    local th = 14
    if imgui then
        local tw, item_h = theme.measure_text(imgui, 'M')
        if item_h and item_h > 0 then th = item_h end
    end
    return math.max(8, math.floor(th + 0.5))
end

-- 手順の折り返し用：アイテム名の左に出すアイコンの幅（文字の高さ + 余白）
-- 金額の「○ギル」も、左のコイン分を予約する（所持数やツールチップは付けない）
function M.icon_reserve_width(imgui, piece)
    if not piece then return 0 end
    local th = icon_size_px(imgui)
    if piece.kind == 'gil' then
        return th + 3
    end
    if piece.kind == 'key_item' then return 0 end
    local iid = tonumber(piece.item_id)
    if not iid then
        local ids = piece.item_ids
        if type(ids) == 'table' and #ids == 1 then iid = tonumber(ids[1]) end
    end
    if not iid then return 0 end
    if gil.is_gil_id(iid) then return 0 end
    -- 実際にアイコンを描くときだけ幅を予約する（無いときに右そろえがずれる）
    if not M.icon_texture(iid) then return 0 end
    return th + 3
end

local function pack_rgba(r, g, b, a)
    return string.char(r, g, b, a)
end

-- BITMAPINFOHEADER から RGBA を組み立てる（FFXI のアイコンでよくある 32×32、8bit / 32bit）
local function rgba_from_dib(blob, off, kind)
    local biSize = u32(blob, off)
    if not biSize or biSize < 16 or biSize > 124 then return nil end
    local width = i32(blob, off + 4)
    local height = i32(blob, off + 8)
    local planes = u16(blob, off + 12)
    local bits = u16(blob, off + 14)
    if not width or not height or not bits then return nil end
    local top_down = height < 0
    if top_down then height = -height end
    if width < 1 or height < 1 or width > 128 or height > 128 then return nil end
    if planes and planes ~= 0 and planes ~= 1 then return nil end
    if bits ~= 8 and bits ~= 32 and bits ~= 24 then return nil end
    local data_off = off + biSize
    local palette = {}
    if bits == 8 then
        -- パレットはヘッダの直後（BGRA×256 を上限）
        local colors = 256
        local used = u32(blob, off + 32)
        if used and used > 0 and used <= 256 then colors = used end
        -- 実機は biClrUsed=32 でも、残りが 256 色＋32×32 の長さ（2048）になる
        local remain = #blob - (data_off - 1)
        local pix = width * height
        local pix_pad = math.floor((width + 3) / 4) * 4 * height
        if remain >= 256 * 4 + pix or remain >= 256 * 4 + pix_pad then
            colors = 256
        end
        for i = 0, colors - 1 do
            local p = data_off + i * 4
            if p + 3 > #blob then break end
            local b, g, r, a = blob:byte(p, p + 3)
            if a == 0 then a = 255 end
            palette[i] = pack_rgba(r, g, b, a)
        end
        data_off = data_off + colors * 4
    end
    local row_bytes
    if bits == 8 then
        row_bytes = math.floor((width + 3) / 4) * 4
    elseif bits == 24 then
        row_bytes = math.floor((width * 3 + 3) / 4) * 4
    else
        row_bytes = width * 4
    end
    if data_off + row_bytes * height - 1 > #blob then
        -- パディング無しの短い列も許す
        local tight = width * math.floor(bits / 8)
        if data_off + tight * height - 1 <= #blob then
            row_bytes = tight
        else
            return nil
        end
    end
    local out = {}
    for y = 0, height - 1 do
        local sy = top_down and y or (height - 1 - y)
        local row = data_off + sy * row_bytes
        for x = 0, width - 1 do
            if bits == 8 then
                local idx = blob:byte(row + x)
                out[#out + 1] = palette[idx] or pack_rgba(0, 0, 0, 0)
            elseif bits == 24 then
                local i = row + x * 3
                local b, g, r = blob:byte(i, i + 2)
                out[#out + 1] = pack_rgba(r, g, b, 255)
            else
                local i = row + x * 4
                local b, g, r, a = blob:byte(i, i + 3)
                if a == 0 and (r > 0 or g > 0 or b > 0) then a = 255 end
                out[#out + 1] = pack_rgba(r, g, b, a or 0)
            end
        end
    end
    return { rgba = table.concat(out), width = width, height = height, kind = kind }
end

-- 真っ黒の背景を透明にする（D3DX のカラーキー 0xFF000000 と同じ。色のある黒以外の画素が残るときだけ）
local function apply_black_key(img)
    if not img or type(img.rgba) ~= 'string' then return img end
    local s = img.rgba
    local n = #s
    if n < 4 then return img end
    local out, colored, keyed = {}, false, false
    for i = 1, n, 4 do
        local r, g, b, a = s:byte(i, i + 3)
        if r == 0 and g == 0 and b == 0 and a and a > 0 then
            out[#out + 1] = pack_rgba(0, 0, 0, 0)
            keyed = true
        else
            if (r and r > 0) or (g and g > 0) or (b and b > 0) then colored = true end
            out[#out + 1] = pack_rgba(r or 0, g or 0, b or 0, a or 0)
        end
    end
    if keyed and colored then img.rgba = table.concat(out) end
    return img
end

-- vana.ashita.item_icon の戻り（バイト列）を RGBA にする。形式が分からなければ nil。
-- 実機のアイコンは、Ashita の IItem.Bitmap と同じく 16 バイトの前置き＋BITMAPINFOHEADER＋
-- 256 色パレット＋32×32 の 8bit（下から上、最短 2104 バイト）が多い。0.1.262 は 8 バイト前置きだけを見ていた。
function M.decode_icon(blob)
    M.last_icon_kind = nil
    if type(blob) ~= 'string' or #blob < 16 then return nil end
    -- 標準 BMP
    if blob:sub(1, 2) == 'BM' then
        local offBits = u32(blob, 11)
        local img = rgba_from_dib(blob, 15, 'bmp')
        if img then apply_black_key(img); M.last_icon_kind = 'bmp'; return img end
        if offBits and offBits >= 14 then
            img = rgba_from_dib(blob, offBits + 1, 'bmp')
            if img then apply_black_key(img); M.last_icon_kind = 'bmp'; return img end
        end
    end
    local tried = {}
    local function try_off(off, kind)
        if not off or off < 1 or tried[off] then return nil end
        if off + 15 > #blob then return nil end
        tried[off] = true
        if u32(blob, off) ~= 40 then return nil end
        local img = rgba_from_dib(blob, off, kind)
        if not img then return nil end
        apply_black_key(img)
        img.kind = kind
        M.last_icon_kind = kind
        return img
    end
    -- よくある位置。実機の vana.ashita.item_icon は
    -- ImageType(1)＋ImageName(16)＋DIB で、DIB は 1-based 18（17 バイト前置き）。
    local img = try_off(1, 'dib') or try_off(9, 'dib8') or try_off(15, 'dib14')
        or try_off(17, 'dib16') or try_off(18, 'dib17') or try_off(513, 'dib512')
    if img then return img end
    local max = math.min(#blob - 16, 80)
    for off = 1, max do
        img = try_off(off, 'dib@' .. tostring(off - 1))
        if img then return img end
    end
    -- 生の 32×32 BGRA / RGBA（長さがぴったり）
    if #blob == 32 * 32 * 4 then
        local out = {}
        for i = 1, #blob, 4 do
            local b, g, r, a = blob:byte(i, i + 3)
            -- アルファが全部 0 で色があるなら BGRA とみなす
            out[#out + 1] = pack_rgba(r, g, b, (a == 0 and (r > 0 or g > 0 or b > 0)) and 255 or a)
        end
        img = { rgba = table.concat(out), width = 32, height = 32, kind = 'raw32' }
        apply_black_key(img)
        M.last_icon_kind = 'raw32'
        return img
    end
    return nil
end

local function hex_of(s, n)
    if type(s) ~= 'string' then return '' end
    n = math.min(n or 64, #s)
    local t = {}
    for i = 1, n do
        t[#t + 1] = string.format('%02X', s:byte(i))
    end
    return table.concat(t, ' ')
end

-- 実機のアイコンバイト列と gamedata の欄を調べる（デバッグコマンド用）
function M.inspect_icon(id)
    id = tonumber(id)
    local out = {
        id = id,
        blob_type = 'nil',
        length = 0,
        head_hex = '',
        magic = '',
        biSize = {},
        kind = nil,
        width = nil,
        height = nil,
        item_keys = {},
        name = nil,
        description = nil,
        language = nil,
        why = nil,
    }
    if not id then out.why = 'no_id'; return out end
    local row = fetch_item(id)
    if type(row) == 'table' then
        local keys = {}
        for k in pairs(row) do keys[#keys + 1] = tostring(k) end
        table.sort(keys)
        out.item_keys = keys
        out.name = row.name or row.log_name
        out.description = row.description or row.desc or ''
        out.language = M.language_of(out.description)
        -- 日本語専用の欄があるか（公式の表には name / description のみ）
        out.has_ja_field = false
        for _, k in ipairs(keys) do
            local s = k:lower()
            if s:find('ja', 1, true) or s:find('jp', 1, true) or s == 'description_j' or s == 'name_j' then
                out.has_ja_field = true
            end
        end
    else
        out.why = 'no_gamedata'
    end
    local blob = fetch_icon(id)
    out.blob_type = type(blob)
    if type(blob) == 'string' then
        out.length = #blob
        out.head_hex = hex_of(blob, 256)
        out.magic = blob:sub(1, 4)
        for _, off in ipairs({ 1, 9, 15, 17, 513 }) do
            out.biSize['off_' .. tostring(off)] = u32(blob, off)
        end
        local img = M.decode_icon(blob)
        if img then
            out.kind = img.kind or M.last_icon_kind
            out.width = img.width
            out.height = img.height
        else
            out.kind = nil
            if not out.why then out.why = 'undecoded' end
        end
    elseif blob == nil then
        if not out.why then out.why = 'no_icon' end
    else
        out.why = 'icon_not_string'
    end
    return out
end

function M.inspect_icon_text(id)
    local r = M.inspect_icon(id)
    local lines = {
        'astertrail item icon debug',
        'id=' .. tostring(r.id or ''),
        'blob_type=' .. tostring(r.blob_type),
        'length=' .. tostring(r.length),
        'magic=' .. tostring(r.magic):gsub('[^%w%p ]', '?'),
        'kind=' .. tostring(r.kind or 'none'),
        'width=' .. tostring(r.width or ''),
        'height=' .. tostring(r.height or ''),
        'why=' .. tostring(r.why or ''),
        'name=' .. tostring(r.name or ''),
        'language=' .. tostring(r.language or ''),
        'has_ja_field=' .. tostring(r.has_ja_field),
        'item_keys=' .. table.concat(r.item_keys or {}, ','),
        'description=' .. tostring(r.description or ''),
        'head_hex=' .. tostring(r.head_hex or ''),
    }
    local bits = r.biSize or {}
    local keys = {}
    for k in pairs(bits) do keys[#keys + 1] = k end
    table.sort(keys)
    for _, k in ipairs(keys) do
        lines[#lines + 1] = k .. '=' .. tostring(bits[k])
    end
        return table.concat(lines, '\n') .. '\n', r
end

-- アドオンフォルダへ書く（設定フォルダには書かない）
function M.write_icon_debug(id, path)
    if type(path) ~= 'string' or path == '' then return nil, 'no_path' end
    local text, meta = M.inspect_icon_text(id)
    local f, err = io.open(path, 'w')
    if not f then return nil, tostring(err or 'open_failed') end
    f:write(text)
    f:close()
    return path, meta
end

local function addon_debug_path(name)
    local ad = rawget(_G, 'addon')
    local dir = ad and ad.path
    if type(dir) ~= 'string' or dir == '' then
        local ok, plat = pcall(require, 'src.platform.ashita')
        if ok and plat and plat.addon_dir then
            local okd, d = pcall(plat.addon_dir)
            if okd then dir = d end
        end
    end
    if type(dir) ~= 'string' or dir == '' then return nil end
    -- 開発ツリーには書かない
    if dir:find('workspace', 1, true) then return nil end
    if dir:sub(-1) ~= '/' and dir:sub(-1) ~= '\\' then
        local sep = dir:find('\\') and '\\' or '/'
        dir = dir .. sep
    end
    return dir .. name
end

-- セッション最初の1回、アドオンフォルダへ調べを書く（設定フォルダには書かない）
function M.log_ja_debug(rec)
    if ja_log_written then return end
    local path = addon_debug_path('debug_item_ja.txt')
    if not path then return end
    ja_log_written = true
    rec = rec or {}
    local lines = {
        'astertrail item ja debug',
        'id=' .. tostring(rec.id or 4358),
        'lang_arg=1',
        'how=' .. tostring(rec.how or ''),
        'why=' .. tostring(rec.why or ''),
        'encoding=' .. tostring(rec.encoding or ''),
        'language=' .. tostring(rec.language or ''),
        'name=' .. tostring(rec.name or ''),
        'description=' .. tostring(rec.description or ''),
    }
    local f = io.open(path, 'w')
    if not f then return end
    f:write(table.concat(lines, '\n') .. '\n')
    f:close()
end

function M.log_icon_debug(id)
    if icon_log_written then return end
    local path = addon_debug_path('debug_item_icon.txt')
    if not path then return end
    icon_log_written = true
    pcall(M.write_icon_debug, id, path)
end

-- 見える行だけ呼ぶ。番号ごとのテクスチャを覚える。
function M.icon_texture(id)
    id = tonumber(id)
    if not id then return nil end
    local e = M._tex_cache[id]
    if e then return e.tex end
    if source == nil then pcall(M.log_icon_debug, id) end
    return M.texture_for(id, fetch_icon(id))
end

local function evict_tex()
    local n = #M._tex_order
    if n <= M.TEX_LIMIT then return end
    local drop = math.floor(n / 3)
    for i = 1, drop do
        local id = M._tex_order[i]
        M._tex_cache[id] = nil
    end
    local rest = {}
    for i = drop + 1, n do rest[#rest + 1] = M._tex_order[i] end
    M._tex_order = rest
end

function M.texture_for(id, blob)
    id = tonumber(id)
    if not id then return nil end
    local e = M._tex_cache[id]
    if e then return e.tex end
    local img = M.decode_icon(blob)
    if not img then
        M._tex_cache[id] = { tex = nil }
        M._tex_order[#M._tex_order + 1] = id
        evict_tex()
        return nil
    end
    local loader = source and source.load_texture or nil
    if not loader then
        local p = platform()
        if p and p.load_texture then loader = p.load_texture end
    end
    local tex = nil
    if loader then
        local ok, got = pcall(loader, img)
        if ok then tex = got end
    end
    M._tex_cache[id] = { tex = tex, img = img }
    M._tex_order[#M._tex_order + 1] = id
    evict_tex()
    return tex
end

-- 自前の小さなコイン（ゲームの画像は同梱しない）。RGBA 32×32
local function make_gil_coin_rgba()
    local w, h = 32, 32
    local cx, cy, r = 15.5, 15.5, 13.2
    local out = {}
    for y = 0, h - 1 do
        for x = 0, w - 1 do
            local dx, dy = x - cx, y - cy
            local d = math.sqrt(dx * dx + dy * dy)
            local a, cr, cg, cb = 0, 0, 0, 0
            if d <= r then
                local t = d / r
                -- 金色。中央は明るく、縁は少し暗い
                cr = math.floor(230 - t * 50 + 0.5)
                cg = math.floor(190 - t * 70 + 0.5)
                cb = math.floor(70 - t * 20 + 0.5)
                a = 255
                if d > r - 1.4 then
                    cr, cg, cb = 196, 150, 48
                end
                -- 左上のハイライト
                local hx, hy = dx + 5, dy + 5
                if math.sqrt(hx * hx + hy * hy) < 5.5 and d < r - 2 then
                    cr, cg, cb = 255, 236, 150
                end
                -- 内側の輪
                if d > r - 3.2 and d < r - 1.6 then
                    cr, cg, cb = 168, 118, 28
                end
            elseif d < r + 1.1 then
                local f = 1 - (d - r) / 1.1
                cr, cg, cb, a = 196, 150, 48, math.floor(200 * f + 0.5)
            end
            if cr < 0 then cr = 0 elseif cr > 255 then cr = 255 end
            if cg < 0 then cg = 0 elseif cg > 255 then cg = 255 end
            if cb < 0 then cb = 0 elseif cb > 255 then cb = 255 end
            out[#out + 1] = pack_rgba(cr, cg, cb, a)
        end
    end
    return { rgba = table.concat(out), width = w, height = h, kind = 'coin' }
end

local function raw32_from_rgba(img)
    -- decode_icon の生 32×32 は BGRA として読む
    local rgba = img.rgba
    local out = {}
    for i = 1, #rgba, 4 do
        local r, g, b, a = rgba:byte(i, i + 3)
        out[#out + 1] = string.char(b, g, r, a)
    end
    return table.concat(out)
end

-- 金額の左に出すコイン。先に vana.ashita.item_icon(65535) を試し、読めればそれを使う。
-- 番号の照合やツールチップには使わない。
function M.gil_icon_texture()
    if M._gil_tex ~= nil then
        if M._gil_tex == false then return nil end
        return M._gil_tex
    end
    local blob
    local ok, b = pcall(fetch_icon, gil.SENTINEL_ID)
    if ok then blob = b end
    if type(blob) == 'string' and blob ~= '' then
        local tex = M.texture_for(-gil.SENTINEL_ID, blob)
        if tex then
            M._gil_tex = tex
            M._gil_icon_kind = 'game'
            return tex
        end
    end
    local img = make_gil_coin_rgba()
    local loader = source and source.load_texture or nil
    if not loader then
        local p = platform()
        if p and p.load_texture then loader = p.load_texture end
    end
    local tex = nil
    if loader then
        local okt, got = pcall(loader, img)
        if okt then tex = got end
    end
    if not tex then
        tex = M.texture_for(-gil.SENTINEL_ID - 1, raw32_from_rgba(img))
    end
    M._gil_tex = tex or false
    M._gil_icon_kind = 'drawn'
    M.last_icon_kind = 'coin'
    if M._gil_tex == false then return nil end
    return M._gil_tex
end

function M.gil_icon_kind()
    return M._gil_icon_kind
end

function M.draw_gil_icon(imgui, x, y, size)
    size = tonumber(size) or 14
    if not imgui or x == nil or y == nil or size < 4 then return false end
    local tex = M.gil_icon_texture()
    local dl = imgui.GetWindowDrawList and imgui.GetWindowDrawList()
    if tex and dl and dl.AddImage then
        local ok = pcall(dl.AddImage, dl, tex, { x, y }, { x + size, y + size })
        if ok then return true end
    end
    -- テクスチャが無いときは、その場で小さなコインを描く
    if dl and (dl.AddCircleFilled or dl.AddCircle) then
        local cx, cy, r = x + size * 0.5, y + size * 0.5, size * 0.42
        local gold = theme.rgba(230, 186, 64, 1)
        local rim = theme.rgba(168, 118, 28, 1)
        local hi = theme.rgba(255, 236, 150, 1)
        pcall(function ()
            if dl.AddCircleFilled then
                dl:AddCircleFilled({ cx, cy }, r, gold, 16)
                if size >= 10 then dl:AddCircleFilled({ cx - r * 0.28, cy - r * 0.28 }, r * 0.28, hi, 10) end
            end
            if dl.AddCircle then dl:AddCircle({ cx, cy }, r, rim, 16, 1.4) end
        end)
        return true
    end
    return false
end

local function utf8_chars(s)
    s = tostring(s or '')
    local n, i = 0, 1
    while i <= #s do
        local b = s:byte(i)
        if not b then break end
        local step = (b < 128 and 1) or (b < 224 and 2) or (b < 240 and 3) or 4
        n = n + 1
        i = i + step
    end
    return n
end

-- ゲームの日本語リソースが、略として1文字だけ返したときだけそれを使う
local function is_ja_abbrev(s)
    if type(s) ~= 'string' or s == '' then return false end
    if s:byte(1) < 128 then return false end
    return utf8_chars(s) == 1
end

function M.job_abbrev(id, j)
    id = tonumber(id)
    if j and type(j) == 'table' then
        for _, key in ipairs({ 'short_ja', 'abbrev_ja', 'abbrev', 'short', 'name_ja', 'name' }) do
            local v = j[key]
            if is_ja_abbrev(v) then return v end
        end
    end
    if id and JOB_JA[id] then return JOB_JA[id] end
    if j and type(j) == 'table' then
        return j.short or j.name or (id and JOB_SHORT[id]) or tostring(id or '')
    end
    return (id and (JOB_JA[id] or JOB_SHORT[id])) or tostring(id or '')
end

local function job_resource_abbrev(id)
    if source and source.job_abbrev then
        local ok, v = pcall(source.job_abbrev, id)
        if ok and is_ja_abbrev(v) then return v end
    end
    if source then return nil end
    local v = vana_of()
    local ash = v and v.ashita
    if ash and type(ash.string) == 'function' then
        for _, key in ipairs({ 'jobs.abbreviations', 'jobs.shorts', 'jobs.short_names' }) do
            local ok, s = pcall(ash.string, key, id, 1)
            if ok and is_ja_abbrev(s) then return s end
        end
    end
    return nil
end

local function num_field(obj, keys)
    if obj == nil then return nil end
    for _, k in ipairs(keys) do
        local ok, v = pcall(function () return obj[k] end)
        if ok then
            if type(v) == 'number' then return v end
            if type(v) == 'string' then
                local n = tonumber(v)
                if n then return n end
            end
        end
    end
    return nil
end

function M.slot_label(slots, name)
    local seen, out = {}, {}
    local function add(label)
        if not label or label == '' or seen[label] then return end
        seen[label] = true
        out[#out + 1] = label
    end
    if type(name) == 'string' and name ~= '' then
        for part in name:gmatch('[^,/|]+') do
            part = part:match('^%s*(.-)%s*$') or part
            local mapped = SLOT_NAME[part] or SLOT_NAME[part:lower()]
            if mapped then
                add(mapped)
            elseif is_ja_abbrev(part) or SLOT_NAME[part] then
                add(mapped or part)
            end
        end
    elseif type(name) == 'table' then
        for _, v in ipairs(name) do
            if type(v) == 'string' then
                add(SLOT_NAME[v] or SLOT_NAME[tostring(v):lower()] or nil)
            elseif type(v) == 'number' then
                -- fall through via bits below
            end
        end
    end
    local bits = tonumber(slots)
    if bits and bits > 0 then
        for _, row in ipairs(SLOT_BITS) do
            if math.floor(bits / row[1]) % 2 == 1 then add(row[2]) end
        end
    end
    if #out == 0 then return nil end
    return table.concat(out, '／')
end

function M.is_equipment(info)
    if not info or type(info) ~= 'table' then return false end
    if info.equipment == true then return true end
    local slots = tonumber(info.slots)
    if slots and slots > 0 then return true end
    if type(info.slot_label) == 'string' and info.slot_label ~= '' then return true end
    return false
end

function M.meta_line(info)
    if not info then return nil end
    local slot = info.slot_label
    local lv = tonumber(info.level)
    if slot and slot ~= '' and lv and lv > 0 then
        return slot .. ' ・ Lv ' .. tostring(lv)
    end
    if slot and slot ~= '' then return slot end
    if lv and lv > 0 then return 'Lv ' .. tostring(lv) end
    return nil
end

function M.jobs_text(info, all_label)
    if not info or not info.jobs or #info.jobs == 0 then return nil end
    if info.all_jobs or #info.jobs >= M.JOB_COUNT then
        return all_label or '全ジョブ'
    end
    return table.concat(info.jobs, ' ')
end

function M.live_fields(id)
    id = tonumber(id)
    if not id then return nil end
    if source and source.live_fields then
        local ok, got = pcall(source.live_fields, id)
        if ok and type(got) == 'table' then return got end
        return nil
    end
    if source then return nil end
    local v = vana_of()
    local ash = v and v.ashita
    if not ash or type(ash.item) ~= 'function' then return nil end
    local ok, it = pcall(ash.item, id, 1)
    if not ok or it == nil then return nil end
    local jobs = num_field(it, { 'Jobs', 'jobs' })
    return {
        level = num_field(it, { 'Level', 'level' }),
        item_level = num_field(it, { 'ItemLevel', 'item_level' }),
        slots = num_field(it, { 'Slots', 'slots' }),
        jobs = jobs,
        damage = num_field(it, { 'Damage', 'damage' }),
        delay = num_field(it, { 'Delay', 'delay' }),
    }
end

local function flag_has(names, flags, key, bitv)
    if type(names) == 'table' then
        for _, n in ipairs(names) do
            local s = tostring(n or ''):lower()
            if s == key or s == key:lower() then return true end
        end
        -- よくある別名
        if key == 'ex' then
            for _, n in ipairs(names) do
                local s = tostring(n or ''):lower()
                if s == 'exclusive' or s == 'ex' then return true end
            end
        end
    end
    flags = tonumber(flags)
    if flags and bitv and math.floor(flags / bitv) % 2 == 1 then return true end
    return false
end

local function job_list(row)
    local ids = {}
    if type(row.job_ids) == 'table' then
        for _, id in ipairs(row.job_ids) do
            id = tonumber(id)
            if id then ids[#ids + 1] = id end
        end
    elseif type(row.jobs) == 'table' and not row.jobs[1] then
        -- { [job id] = level } の形（呪文と同じ）
        local keys = {}
        for k in pairs(row.jobs) do
            k = tonumber(k)
            if k then keys[#keys + 1] = k end
        end
        table.sort(keys)
        ids = keys
    else
        local bits = tonumber(row.jobs)
        if bits then
            for i = 1, 22 do
                local bitv = 2 ^ i -- bit n = job n（公式）
                if math.floor(bits / bitv) % 2 == 1 then ids[#ids + 1] = i end
            end
        end
    end
    local names = {}
    for _, id in ipairs(ids) do
        local from_res = job_resource_abbrev(id)
        if from_res then
            names[#names + 1] = from_res
        else
            names[#names + 1] = M.job_abbrev(id, fetch_job(id))
        end
    end
    return names, ids
end

function M.info_for_item(id)
    id = tonumber(id)
    if not id then return nil end
    local row = fetch_item(id)
    local ja = M.live_ja(id)
    if type(row) ~= 'table' and not (ja and (ja.name ~= '' or ja.description ~= '')) then return nil end
    row = row or {}
    local jobs, job_ids = job_list(row)
    local desc = (ja and ja.description ~= '' and ja.description) or (row.description or row.desc or '')
    desc = M.clean_description(desc)
    local name = (ja and ja.name ~= '' and ja.name) or (row.name or row.log_name or '')
    local lang = M.language_of(desc ~= '' and desc or name)
    M.last_desc_lang = lang
    local level = tonumber(row.level or row.Level)
    local item_level = tonumber(row.item_level or row.ItemLevel)
    local slots = num_field(row, { 'slots', 'Slots' })
    local slot_label = M.slot_label(slots, row.slot or row.slot_name or row.slots_name)
    local damage = num_field(row, { 'damage', 'Damage' })
    local delay = num_field(row, { 'delay', 'Delay' })
    local live = M.live_fields(id)
    if live then
        if not level or level == 0 then level = live.level or level end
        if not item_level or item_level == 0 then item_level = live.item_level or item_level end
        if not slots or slots == 0 then slots = live.slots or slots end
        if (not slot_label or slot_label == '') and live.slots then
            slot_label = M.slot_label(live.slots)
        end
        if (not jobs or #jobs == 0) and live.jobs then
            jobs, job_ids = job_list({ jobs = live.jobs })
        end
        if not damage or damage == 0 then damage = live.damage or damage end
        if not delay or delay == 0 then delay = live.delay or delay end
    end
    if (not slot_label or slot_label == '') and slots then
        slot_label = M.slot_label(slots)
    end
    local all_jobs = (job_ids and #job_ids >= M.JOB_COUNT) and true or false
    return {
        kind = 'item',
        id = id,
        name = name,
        description = desc,
        language = lang,
        level = level,
        item_level = item_level,
        jobs = jobs,
        job_ids = job_ids,
        all_jobs = all_jobs,
        slots = slots,
        slot_label = slot_label,
        damage = damage,
        delay = delay,
        equipment = M.is_equipment({ slots = slots, slot_label = slot_label }),
        rare = flag_has(row.flag_names, row.flags, 'rare', 0x8000),
        ex = flag_has(row.flag_names, row.flags, 'ex', 0x4000),
        icon_bytes = (function ()
            local ok, b = pcall(fetch_icon, id)
            if ok then return b end
            return nil
        end)(),
    }
end

function M.info_for_key(id)
    id = tonumber(id)
    if not id then return nil end
    local row = fetch_key(id)
    local ja = M.live_ja(id)
    if type(row) ~= 'table' and not (ja and (ja.name ~= '' or ja.description ~= '')) then return nil end
    row = row or {}
    local desc = (ja and ja.description ~= '' and ja.description) or (row.description or row.desc or '')
    desc = M.clean_description(desc)
    local name = (ja and ja.name ~= '' and ja.name) or (row.name or '')
    local lang = M.language_of(desc ~= '' and desc or name)
    M.last_desc_lang = lang
    return {
        kind = 'key_item',
        id = id,
        name = name,
        description = desc,
        language = lang,
        category = row.category,
        -- だいじなものにレベル・ジョブ・Rare/Ex・アイコンの公式欄は無い
    }
end

-- 必要品（単一番号だけ詳細。複数番号はグループとして名前だけ）
function M.info_for_need(need)
    if not need or type(need) ~= 'table' then return nil end
    if need.kind == 'key_item' or need.key_item_id or need.key_item_ids then
        local ids = need.key_item_ids
        if not ids and need.key_item_id then ids = { need.key_item_id } end
        if not ids or #ids == 0 then return nil end
        if #ids == 1 then
            local info = M.info_for_key(ids[1])
            if info then return info end
            -- 資料が無いときは名前だけ（出せるものを出す。無ければスキップ）
            return { kind = 'key_item', id = ids[1], name = need.name_ja or need.name_en or '', description = '', thin = true }
        end
        return {
            kind = 'key_item_group',
            name = need.name_ja or need.name_en or '',
            ids = ids,
        }
    end
    local ids = need.item_ids
    if not ids and need.item_id then ids = { need.item_id } end
    if not ids or #ids == 0 then return nil end
    if #ids == 1 then
        local info = M.info_for_item(ids[1])
        if info then return info end
        return { kind = 'item', id = ids[1], name = need.name_ja or need.name_en or '', description = '', thin = true }
    end
    return {
        kind = 'item_group',
        name = need.name_ja or need.name_en or '',
        ids = ids,
    }
end

function M.lines(ui, info)
    if not info then return {} end
    local t = ui and ui.t or function (k, a)
        if k == 'item_tip.level' then return 'Lv. ' .. tostring(a.n)
        elseif k == 'item_tip.item_level' then return 'iLv. ' .. tostring(a.n)
        elseif k == 'item_tip.jobs' then return a.list
        elseif k == 'item_tip.all_jobs' then return '全ジョブ'
        elseif k == 'item_tip.damage' then return 'ダメージ ' .. tostring(a.n)
        elseif k == 'item_tip.delay' then return '隔 ' .. tostring(a.n)
        elseif k == 'item_tip.group' then return a.name
        elseif k == 'item_tip.rare' then return 'Rare'
        elseif k == 'item_tip.ex' then return 'Ex'
        elseif k == 'item_tip.copy' then return nil
        else return k end
    end
    local out = {}
    if info.name and info.name ~= '' then out[#out + 1] = { text = info.name, heading = true } end
    local tags = {}
    if info.rare then tags[#tags + 1] = t('item_tip.rare') or 'Rare' end
    if info.ex then tags[#tags + 1] = t('item_tip.ex') or 'Ex' end
    if #tags > 0 then out[#out + 1] = { text = table.concat(tags, ' / '), tags = true } end
    local equip = M.is_equipment(info)
    if equip then
        local meta = M.meta_line(info)
        if meta then out[#out + 1] = { text = meta, meta = true } end
        local jobs = M.jobs_text(info, t('item_tip.all_jobs'))
        if jobs then out[#out + 1] = { text = t('item_tip.jobs', { list = jobs }), jobs = true } end
        if info.item_level and info.item_level > 0 then
            out[#out + 1] = { text = t('item_tip.item_level', { n = tostring(info.item_level) }), stat = true }
        end
        if info.damage and info.damage > 0 then
            out[#out + 1] = { text = t('item_tip.damage', { n = tostring(info.damage) }), stat = true }
        end
        if info.delay and info.delay > 0 then
            out[#out + 1] = { text = t('item_tip.delay', { n = tostring(info.delay) }), stat = true }
        end
    end
    if info.category and tostring(info.category) ~= '' then
        out[#out + 1] = { text = tostring(info.category) }
    end
    if info.description and info.description ~= '' then
        out[#out + 1] = { text = info.description, desc = true }
    end
    if info.kind == 'item_group' or info.kind == 'key_item_group' then
        out[#out + 1] = { text = t('item_tip.group', { name = info.name or '', n = tostring(#(info.ids or {})) }) }
    end
    return out
end

local function begin_tip(imgui)
    if imgui.BeginTooltip then
        local ok, opened = pcall(imgui.BeginTooltip)
        return ok and opened ~= false, true
    end
    return false, false
end

local function end_tip(imgui)
    if imgui.EndTooltip then pcall(imgui.EndTooltip) end
end

local ICON = 48
local ICON_BOX = 54

local function cursor_xy(imgui)
    if not imgui.GetCursorScreenPos then return nil, nil end
    local ok, a, b = pcall(imgui.GetCursorScreenPos)
    if not ok then return nil, nil end
    if type(a) == 'table' then
        return tonumber(a[1] or a.x), tonumber(a[2] or a.y)
    end
    return tonumber(a), tonumber(b)
end

local function set_cursor_xy(imgui, x, y)
    if not imgui.SetCursorScreenPos or x == nil or y == nil then return end
    if pcall(imgui.SetCursorScreenPos, { x, y }) then return end
    pcall(imgui.SetCursorScreenPos, { x = x, y = y })
end

local function push_card_style(imgui)
    local n_col, n_var = 0, 0
    local function col(name, rgba)
        if not imgui.PushStyleColor then return end
        if pcall(imgui.PushStyleColor, theme.C(name), rgba) then n_col = n_col + 1 end
    end
    local function var(name, v, named_only)
        if not imgui.PushStyleVar then return end
        local id = named_only and theme.C_opt(name) or theme.C(name)
        if id == nil then return end
        if pcall(imgui.PushStyleVar, id, v) then n_var = n_var + 1 end
    end
    local bg, border
    if theme.is_sf() then
        bg = { 0.035, 0.055, 0.08, 0.97 }
        border = theme.col('sf_cyan', 0.90)
    elseif theme.look == 'yunaui' then
        bg = { 0.068, 0.066, 0.088, 0.97 }
        border = theme.col('accent', 0.85)
    else
        bg = { 0.07, 0.07, 0.09, 0.97 }
        border = theme.col('accent', 0.90)
    end
    col('ImGuiCol_PopupBg', bg)
    col('ImGuiCol_WindowBg', bg)
    col('ImGuiCol_Border', border)
    var('ImGuiStyleVar_WindowRounding', 8)
    var('ImGuiStyleVar_PopupRounding', 8, true)
    var('ImGuiStyleVar_WindowBorderSize', 1)
    var('ImGuiStyleVar_WindowPadding', { 10, 10 })
    return function ()
        for _ = 1, n_var do pcall(imgui.PopStyleVar, 1) end
        for _ = 1, n_col do pcall(imgui.PopStyleColor, 1) end
    end
end

local function draw_icon_square(imgui, tex)
    local x, y = cursor_xy(imgui)
    local dl = imgui.GetWindowDrawList and imgui.GetWindowDrawList()
    local accent = theme.is_sf() and 'sf_cyan' or 'accent'
    if x and y and dl then
        local bg = theme.is_sf() and theme.rgba(8, 16, 22, 0.95) or theme.rgba(16, 16, 18, 0.95)
        pcall(function ()
            if dl.AddRectFilled then dl:AddRectFilled({ x, y }, { x + ICON_BOX, y + ICON_BOX }, bg, 4) end
            if dl.AddRect then dl:AddRect({ x, y }, { x + ICON_BOX, y + ICON_BOX }, theme.u32(accent, 0.70), 4, 0, 1.0) end
        end)
    end
    local pad = (ICON_BOX - ICON) / 2
    if x and y then set_cursor_xy(imgui, x + pad, y + pad) end
    if tex and imgui.Image then
        pcall(imgui.Image, tex, { ICON, ICON })
    elseif imgui.Dummy then
        pcall(imgui.Dummy, { ICON, ICON })
    end
    if x and y then
        set_cursor_xy(imgui, x, y)
        if imgui.Dummy then pcall(imgui.Dummy, { ICON_BOX, ICON_BOX }) end
    end
    if imgui.SameLine then pcall(imgui.SameLine, 0, 10) end
end

local function draw_wrapped(imgui, col, text)
    if imgui.PushTextWrapPos then
        local w = 300
        local cx = 0
        if imgui.GetCursorPosX then
            local ok, v = pcall(imgui.GetCursorPosX)
            if ok then cx = tonumber(v) or 0 end
        end
        pcall(imgui.PushTextWrapPos, cx + w)
        theme.TextColored(imgui, col, text)
        pcall(imgui.PopTextWrapPos)
    else
        theme.TextColored(imgui, col, text)
    end
end

-- すでにホバー中のときだけ描く（呼び出し側が IsItemHovered を見る）
function M.draw(ui, info)
    if not info or not ui or not ui.imgui then return false end
    local imgui = ui.imgui
    local lines = M.lines(ui, info)
    if #lines == 0 and info.name and info.name ~= '' then
        lines = { { text = info.name, heading = true } }
    end
    if #lines == 0 then return false end
    local function text_only()
        if imgui.SetTooltip then
            local text = {}
            for _, ln in ipairs(lines) do text[#text + 1] = ln.text end
            if #text == 0 and info.name then text[1] = info.name end
            pcall(imgui.SetTooltip, table.concat(text, '\n'))
            return true
        end
        return false
    end
    local pop_style = push_card_style(imgui)
    local opened, has = begin_tip(imgui)
    if not opened then
        pop_style()
        return text_only()
    end
    local ok = pcall(function ()
        local tex
        if info.kind == 'item' and info.id and info.icon_bytes then
            if source == nil then pcall(M.log_icon_debug, info.id) end
            local okt, got = pcall(M.texture_for, info.id, info.icon_bytes)
            if okt then tex = got end
        end
        local has_icon = tex and imgui.Image
        if has_icon or (info.kind == 'item' and info.icon_bytes) then
            draw_icon_square(imgui, tex)
        end
        if imgui.BeginGroup then imgui.BeginGroup() end
        for _, ln in ipairs(lines) do
            if ln.heading then
                if imgui.SetWindowFontScale then pcall(imgui.SetWindowFontScale, 1.18) end
                theme.TextColored(imgui, theme.col('heading'), ln.text)
                if imgui.SetWindowFontScale then pcall(imgui.SetWindowFontScale, 1.0) end
            elseif ln.tags then
                local tag = theme.is_sf() and (theme.col('sf_cyan') or theme.col('accent')) or theme.col('accent')
                theme.TextColored(imgui, tag, ln.text)
            elseif ln.meta or ln.jobs then
                theme.TextColored(imgui, theme.col('muted'), ln.text)
            elseif ln.stat then
                theme.TextColored(imgui, theme.col('muted'), ln.text)
            elseif ln.desc then
                draw_wrapped(imgui, theme.col('text'), ln.text)
            else
                theme.TextColored(imgui, theme.col('text'), ln.text)
            end
        end
        if imgui.EndGroup then imgui.EndGroup() end
    end)
    if has then end_tip(imgui) end
    pop_style()
    if not ok then return text_only() end
    return true
end

-- 番号が無いときは、資料の名前表から公式名で補う（推測はしない。ちょうど一致だけ）
function M.fill_need_ids(need, data)
    if not need or not data or type(data.lookup_item_name) ~= 'function' then return need end
    if gil.is_gil_need(need) then
        need.item_id, need.item_ids = nil, nil
        if need.kind == 'item' then need.kind = 'gil' end
        return need
    end
    if need.item_id or need.item_ids or need.key_item_id or need.key_item_ids then return need end
    local name = need.name_ja or need.name_en
    if not name or name == '' then return need end
    local ok, hit = pcall(data.lookup_item_name, data, name)
    if not ok or type(hit) ~= 'table' then return need end
    if hit.kind == 'key_item' or hit.key_item_id or hit.key_item_ids then
        need.kind = 'key_item'
        need.key_item_id = hit.key_item_id
        need.key_item_ids = hit.key_item_ids or (hit.key_item_id and { hit.key_item_id } or nil)
    else
        need.item_id = hit.item_id
        need.item_ids = hit.item_ids or (hit.item_id and { hit.item_id } or nil)
        if not need.kind then need.kind = 'item' end
    end
    return need
end

function M.show_for_need(ui, need)
    if gil.is_gil_need(need) then return false end
    local function run()
        if ui and ui.data then M.fill_need_ids(need, ui.data) end
        local info = M.info_for_need(need)
        local fallback = need and (need.name_ja or need.name_en) or ''
        if not info then
            if fallback == '' then return false end
            -- 資料やアイコンが取れなくても、名前は出す
            info = { kind = (need and need.kind) or 'item', name = fallback, description = '', thin = true }
        elseif (not info.name or info.name == '') and fallback ~= '' then
            info.name = fallback
        end
        if (not info.name or info.name == '') and (not info.description or info.description == '') then
            return false
        end
        return M.draw(ui, info)
    end
    local ok, shown = pcall(run)
    if ok then return shown and true or false end
    local name = need and (need.name_ja or need.name_en)
    if name and name ~= '' and ui and ui.imgui and ui.imgui.SetTooltip then
        pcall(ui.imgui.SetTooltip, name)
        return true
    end
    return false
end

-- extras / piece から必要品の形を復元
function M.need_from_piece(piece)
    if not piece then return nil end
    if piece.kind == 'gil' or gil.is_gil_name(piece.copy_text or piece.text) then return nil end
    local n = {
        name_ja = piece.copy_text or piece.text,
        name_en = piece.copy_text or piece.text,
        kind = (piece.kind == 'key_item' or piece.kind == 'key_item_group') and 'key_item' or 'item',
        item_id = piece.item_id,
        item_ids = piece.item_ids,
        key_item_id = piece.key_item_id,
        key_item_ids = piece.key_item_ids,
    }
    if not n.item_id and not n.item_ids and not n.key_item_id and not n.key_item_ids then
        return nil
    end
    return n
end

return M
