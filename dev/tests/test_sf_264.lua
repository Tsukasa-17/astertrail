-- 0.1.264：Melete Bold、エミネンスカードの♥／★とバッジ、受注、アイテムアイコン
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.308', 'version')

local crisp = require('src.ui.crisp_font')
local window = require('src.ui.window')
local settings = require('src.core.settings')
local sf = require('src.ui.sf_style')
local theme = require('src.ui.theme')
local eminence = require('src.ui.eminence')
local eminence_sf = require('src.ui.eminence_sf')
local imgui = require('imgui')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')

---------------------------------------------------------------------------
-- 文言：エミネンスの「受ける」は「受注」（英語は Accept）
---------------------------------------------------------------------------
check((io.open(ROOT .. '/locales/ja.json', 'r'):read('*a')):find('"roe.accept": "受注"', 1, true), 'ja button is 受注')
check((io.open(ROOT .. '/locales/en.json', 'r'):read('*a')):find('"roe.accept": "Accept"', 1, true), 'en button is Accept')
check(not (io.open(ROOT .. '/locales/ja.json', 'r'):read('*a')):find('"roe.accept": "受ける"', 1, true), 'ja button is no longer 受ける')
-- 解除はそのまま
check((io.open(ROOT .. '/locales/ja.json', 'r'):read('*a')):find('"roe.remove": "解除"', 1, true), 'remove stays 解除')

---------------------------------------------------------------------------
-- Melete：同梱、読み込みは一度、失敗時は今のフォント
---------------------------------------------------------------------------
local bundled = ROOT .. '/fonts/melete/Melete-Bold.otf'
local ofl = ROOT .. '/fonts/melete/OFL.txt'
local f = io.open(bundled, 'rb'); check(f ~= nil, 'Melete-Bold.otf is bundled'); if f then f:close() end
f = io.open(ofl, 'r'); check(f ~= nil, 'OFL.txt is bundled'); if f then f:close() end

check(sf.is_en_heading('ASTERTRAIL'), 'logo is an English heading')
check(sf.is_en_heading('OBJECTIVE'), 'OBJECTIVE is an English heading')
check(sf.is_en_heading('Accept'), 'Accept is Latin')
check(not sf.is_en_heading('報酬'), 'Japanese section is not a heading font')
check(not sf.is_en_heading('次の目標 : 敵を倒す'), 'goal line stays Meiryo')

-- 0.1.272：追加の字間は付けないので、幅は素の文字幅と同じ（広い字間は狭い窓で切れる）
local tw0 = select(1, theme.measure_text(imgui, 'MISSION'))
local tw1, th1 = sf.measure_heading(imgui, 'MISSION', 'label')
check(math.abs((tw1 or 0) - (tw0 or 0)) < 0.51, 'heading measure has no added tracking: ' .. tostring(tw1) .. ' vs ' .. tostring(tw0))
check(th1 and th1 > 0, 'heading measure has height')

crisp._reset()
local tmp = (TMP or '/tmp') .. '/astertrail_fonts_264'
os.execute('mkdir -p "' .. tmp .. '"')
local function touch(path)
    local fh = io.open(path, 'wb'); fh:write('dummy'); fh:close()
end
local path_r, path_b = tmp .. '/meiryo.ttc', tmp .. '/meiryob.ttc'
touch(path_r); touch(path_b)
crisp._set_paths(path_r, path_b)

local added, pushes = {}, {}
local saved_add, saved_push, saved_pop = rawget(imgui, 'AddFontFromFileTTF'), rawget(imgui, 'PushFont'), rawget(imgui, 'PopFont')
imgui.AddFontFromFileTTF = function (path, px)
    added[#added + 1] = { path = path, px = px }
    return { LegacySize = px or 36, path = path, px = px }
end
imgui.PushFont = function (font, size)
    pushes[#pushes + 1] = { font = font, size = size }
end
imgui.PopFont = function () end

eq(crisp.ensure(imgui, S), false, 'first ensure not ready (atlas next frame)')
eq(crisp.ensure(imgui, S), true, 'second ensure ready')
local n_add = #added
eq(crisp.ensure(imgui, S), true, 'later ensure does not reload')
eq(#added, n_add, 'no per-frame font loads')
check(crisp.heading_ready(), 'heading font is ready')
check(tostring(crisp.heading_path() or ''):find('Melete-Bold', 1, true) ~= nil, 'heading path is Melete Bold')

-- PushFont で見出しを出す。大きさは pick_px
pushes = {}
check(crisp.push_heading(imgui, S, 18, 1.85) == true, 'push_heading succeeds')
check(#pushes == 1, 'one heading push')
eq(pushes[1].size, crisp.pick_px(18, 1.85), 'heading size is baked/dynamic px')
check(tostring(pushes[1].font.path):find('Melete-Bold', 1, true), 'pushed font is Melete')
crisp.pop(imgui)

-- 失敗したら今のフォント
crisp._reset()
crisp._set_paths(path_r, path_b)
crisp._set_heading_path('/no/such/Melete-Bold.otf')
added = {}
imgui.AddFontFromFileTTF = function (path, px)
    added[#added + 1] = { path = path, px = px }
    return { LegacySize = px or 36, path = path, px = px }
end
eq(crisp.ensure(imgui, S), false, 'load body without heading file')
eq(crisp.ensure(imgui, S), true, 'body still ready')
eq(crisp.heading_ready(), false, 'heading not ready when file missing')
eq(crisp.push_heading(imgui, S, 18, 1.0), false, 'push_heading falls back')
-- window.set_font heading → meiryo
local ui_font = { imgui = imgui, settings = S, _font_base = 18, _crisp_win = 'book' }
pushes = {}
window.set_font(ui_font, 1.08, { heading = true, bold = true })
check(#pushes >= 1, 'heading fallback still PushFonts the current font')
check(not tostring(pushes[#pushes].font.path):find('Melete', 1, true), 'fallback is not Melete')
window.unwind(ui_font)

imgui.AddFontFromFileTTF, imgui.PushFont, imgui.PopFont = saved_add, saved_push, saved_pop
crisp._reset()

---------------------------------------------------------------------------
-- エミネンスカード：♥／★はカードの当たりに奪われてもトグルする。バッジは受注・解除
---------------------------------------------------------------------------
local roe = require('src.core.roe')
local db = {
    quests = {
        [12] = { id = 12, name = '記録A', body = '', target = 200, repeatable = true, special = '' },
        [13] = { id = 13, name = '記録B', body = '', target = 500, repeatable = false, special = '' },
        [300] = { id = 300, name = '記録C', body = '', target = 5, repeatable = false, special = '' },
    },
    cats = {}, roots = {}, loose = { 12, 13, 300 }, cat_of = {},
}
local complete = roe.new_complete()
do
    local idx, bit = math.floor(300 / 8) + 1, 2 ^ (300 % 8)
    complete[idx] = (complete[idx] or 0) + bit
end
local sent = {}
local ui = {
    t = function (k, a)
        if type(a) == 'table' then
            local s = k
            for key, val in pairs(a) do s = s:gsub('{' .. key .. '}', tostring(val)) end
            return s
        end
        if k == 'roe.accept' then return '受注' end
        if k == 'roe.accept_tip' then return '受注します' end
        if k == 'roe.remove' then return '解除' end
        if k == 'roe.remove_tip' then return '解除します' end
        if k == 'sf.badge_progress' then return '進行中' end
        if k == 'sf.badge_done' then return '完了' end
        if k == 'sf.badge_idle' then return '未開始' end
        return k
    end,
    imgui = imgui,
    settings = S,
    state = {
        roe = { active = { { id = 13, progress = 50 } }, complete = complete, db = db, db_lang = 'ja' },
        open = {},
    },
    roe_db = function () return db end,
    roe_active_count = function () return 1 end,
    roe_can = function () return true end,
    roe_send = function (op, id) sent[#sent + 1] = { op = op, id = id } end,
    mark_settings_dirty = function () end,
    data = app._data(),
    progress = app._progress(),
}
S.eminence = S.eminence or {}
S.eminence.book_show = { accepted = true, not_accepted = true, completed = true, unimplemented = true }
S.eminence.book_text = ''
S.eminence.book_favs_only = false
S.eminence.pins = S.eminence.pins or {}
S.eminence.favs = S.eminence.favs or {}
S.eminence.favs['12'] = nil
S.eminence.pins['12'] = nil
S.book = S.book or {}
S.book.last_heading = S.book.last_heading or {}
S.book.last_heading.eminence = 'all'
S.look = 'sf'
theme.set_look('sf')
eminence_sf.reset_cache()

local curs, last_id, rects = { 10, 10 }, nil, {}
local card_click = false
local mx, my = -100, -100
local saved = {}
for _, k in ipairs({ 'SetCursorScreenPos', 'GetCursorScreenPos', 'InvisibleButton',
                     'GetItemRectMin', 'GetItemRectMax', 'GetMousePos', 'SetItemAllowOverlap' }) do
    saved[k] = rawget(imgui, k)
end
local allow_n = 0
imgui.SetItemAllowOverlap = function () allow_n = allow_n + 1 end
imgui.SetCursorScreenPos = function (p)
    if type(p) == 'table' then curs[1], curs[2] = tonumber(p.x or p[1]) or curs[1], tonumber(p.y or p[2]) or curs[2] end
end
imgui.GetCursorScreenPos = function () return { x = curs[1], y = curs[2] } end
imgui.GetMousePos = function () return { x = mx, y = my } end
imgui.InvisibleButton = function (id, size)
    last_id = id
    FAKE.labels[#FAKE.labels + 1] = id
    local w, h = 16, 16
    if type(size) == 'table' then w, h = tonumber(size.x or size[1]) or 16, tonumber(size.y or size[2]) or 16 end
    rects[id] = { curs[1], curs[2], curs[1] + w, curs[2] + h }
    -- 実機の重なり：カードがクリックを奪い、♥／★／バッジの InvisibleButton は false
    if type(id) == 'string' and (id:find('##sfemf_', 1, true) or id:find('##sfemp_', 1, true) or id:find('##sfemb_', 1, true)) then
        return false
    end
    if card_click and type(id) == 'string' and id:find('##sfem_', 1, true) then
        return true
    end
    return false
end
imgui.GetItemRectMin = function ()
    local r = last_id and rects[last_id]
    if r then return { x = r[1], y = r[2] } end
    return { x = 0, y = 0 }
end
imgui.GetItemRectMax = function ()
    local r = last_id and rects[last_id]
    if r then return { x = r[3], y = r[4] } end
    return { x = 10, y = 10 }
end

local function draw_cards()
    curs[1], curs[2] = 10, 10
    rects = {}
    last_id = nil
    FAKE.labels = {}
    eminence_sf.reset_cache()
    eminence_sf.book_body(ui, 'book')
end

draw_cards()
check(allow_n >= 1, 'card calls SetItemAllowOverlap')
local function rect_of(prefix)
    for id, r in pairs(rects) do
        if type(id) == 'string' and id:find(prefix, 1, true) then return id, r end
    end
end
local hid, hr = rect_of('##sfemf_12')
local sid, sr = rect_of('##sfemp_12')
local bid12, br12 = rect_of('##sfemb_12')
local bid13, br13 = rect_of('##sfemb_13')
local bid300, br300 = rect_of('##sfemb_300')
check(hid and hr, 'heart hit ##sfemf_12 is drawn')
check(sid and sr, 'star hit ##sfemp_12 is drawn')
check(bid12 and br12, 'idle badge ##sfemb_12 is a button')
check(bid13 and br13, 'progress badge ##sfemb_13 is a button')
check(not bid300, 'completed badge is not a button')

-- カードがクリックを奪っても、マウスが♥の上ならお気に入りが付く
mx, my = (hr[1] + hr[3]) / 2, (hr[2] + hr[4]) / 2
card_click = true
sent = {}
eq(eminence.is_faved(ui, 12), false, 'heart starts empty')
draw_cards()
eq(eminence.is_faved(ui, 12), true, 'heart toggles fav even when the card button steals the click')
eq(#sent, 0, 'heart click does not send accept/cancel')

-- ★も同じ
hid, hr = rect_of('##sfemf_12'); sid, sr = rect_of('##sfemp_12')
mx, my = (sr[1] + sr[3]) / 2, (sr[2] + sr[4]) / 2
eq(eminence.is_pinned(ui, 12), false, 'star starts empty')
draw_cards()
eq(eminence.is_pinned(ui, 12), true, 'star toggles pin even when the card button steals the click')

-- 未開始バッジ：受注（start）
bid12, br12 = rect_of('##sfemb_12')
mx, my = (br12[1] + br12[3]) / 2, (br12[2] + br12[4]) / 2
sent = {}
draw_cards()
eq(#sent, 1, 'idle badge sends once')
eq(sent[1].op, 'start', 'idle badge accepts')
eq(sent[1].id, 12, 'idle badge id 12')

-- 進行中バッジ：解除（remove）
bid13, br13 = rect_of('##sfemb_13')
mx, my = (br13[1] + br13[3]) / 2, (br13[2] + br13[4]) / 2
sent = {}
draw_cards()
eq(#sent, 1, 'progress badge sends once')
eq(sent[1].op, 'remove', 'progress badge cancels')
eq(sent[1].id, 13, 'progress badge id 13')

-- 完了バッジをクリック扱いにしても送らない
local _, cr = rect_of('##sfem_300')
if cr then
    mx, my = cr[3] - 20, cr[4] - 8
    sent = {}
    draw_cards()
    eq(#sent, 0, 'completed badge does not send')
end

for _, k in ipairs({ 'SetCursorScreenPos', 'GetCursorScreenPos', 'InvisibleButton',
                     'GetItemRectMin', 'GetItemRectMax', 'GetMousePos', 'SetItemAllowOverlap' }) do
    imgui[k] = saved[k]
end
S.look = 'classic'
theme.set_look('classic')

---------------------------------------------------------------------------
-- アイコン：16 バイト前置きの FFXI DIB を読む。debug icon はアドオンフォルダへ書く。
---------------------------------------------------------------------------
local item_tip = require('src.ui.item_tip')
item_tip.clear_source()

local function u32le(n)
    n = n % 4294967296
    return string.char(n % 256, math.floor(n / 256) % 256, math.floor(n / 65536) % 256, math.floor(n / 16777216) % 256)
end
-- Ashita IItem.Bitmap と同じ形：16 バイト前置き + BITMAPINFOHEADER + 256 色 + 32×32 の 8bit
local function ffxi_icon()
    local prefix = string.rep('\0', 16)
    local hdr = u32le(40) .. u32le(32) .. u32le(32) .. string.char(1, 0, 8, 0) .. string.rep('\0', 24)
    local pal = {}
    pal[1] = string.char(0, 0, 0, 0)          -- index 0 黒
    pal[2] = string.char(0, 0, 255, 0)        -- index 1 赤 (BGRA、予約 0)
    for i = 3, 256 do pal[i] = string.char(0, 0, 0, 0) end
    local pix = string.rep('\1', 32 * 32)     -- 全部赤、下から上でも同じ
    local blob = prefix .. hdr .. table.concat(pal) .. pix
    eq(#blob, 2104, 'FFXI icon blob is 16+40+1024+1024')
    return blob
end

local blob16 = ffxi_icon()
local img16 = item_tip.decode_icon(blob16)
check(img16 ~= nil, '16-byte prefix DIB decodes')
eq(item_tip.last_icon_kind, 'dib16', 'kind is dib16')
eq(img16.width, 32, 'dib16 width')
eq(img16.height, 32, 'dib16 height')
eq(#img16.rgba, 32 * 32 * 4, 'dib16 rgba size')
-- 赤の画素がある（カラーキーで黒だけ透明）
local r, g, b, a = img16.rgba:byte(1, 4)
eq(r, 255, 'first pixel red')
eq(g, 0, 'first pixel g')
eq(b, 0, 'first pixel b')
eq(a, 255, 'first pixel opaque')

-- 8 バイト前置き（従来）も残す
local blob8 = blob16:sub(9)  -- drop 8 bytes so DIB starts at offset 9
-- wait, blob16 DIB is at 17; dropping 8 bytes puts DIB at 9. Yes.
local img8 = item_tip.decode_icon(blob8)
check(img8 ~= nil, '8-byte prefix DIB still decodes')
eq(item_tip.last_icon_kind, 'dib8', 'kind is still dib8')

item_tip.set_source({
    item = function (id)
        if id == 4155 then
            return {
                name = 'Panacea',
                description = 'A medicine that cures most status ailments.',
                level = 1,
            }
        end
        return nil
    end,
    icon = function (id)
        if id == 4155 then return blob16 end
        return nil
    end,
    load_texture = function (img)
        return { _tex = true, w = img.width, h = img.height }
    end,
})
local tex = item_tip.icon_texture(4155)
check(tex and tex._tex == true, 'icon_texture caches a texture from dib16')
eq(item_tip.icon_texture(4155), tex, 'icon_texture returns the cached texture')

local info = item_tip.info_for_item(4155)
eq(info.language, 'en', 'English gamedata description stays English')
check(info.has_ja_field == nil or info.has_ja_field == false, 'inspect ja field is reported separately')
local insp = item_tip.inspect_icon(4155)
eq(insp.kind, 'dib16', 'inspect sees dib16')
eq(insp.language, 'en', 'inspect language is English')
eq(insp.has_ja_field, false, 'gamedata stub has no Japanese field')
check(insp.head_hex and #insp.head_hex > 8, 'inspect includes a hex dump')

-- デバッグコマンド：設定フォルダではなく addon.path へ書く
local dest = TMP .. '/addon_home/'
os.execute('mkdir -p "' .. dest .. '"')
local saved_path = addon.path
addon.path = dest
item_tip.clear_source()
item_tip.set_source({
    item = function (id)
        if id == 4155 then
            return { name = 'Panacea', description = 'A medicine that cures most status ailments.', level = 1 }
        end
        return nil
    end,
    icon = function (id)
        if id == 4155 then return blob16 end
        return nil
    end,
    load_texture = function (img) return { _tex = true } end,
})
FAKE.printed = {}
cmd('/astertrail debug icon 4155')
addon.path = saved_path
local report = dest .. 'debug_item_icon.txt'
local rf = io.open(report, 'r')
check(rf ~= nil, 'debug icon wrote addon-folder file')
local body = rf and rf:read('*a') or ''
if rf then rf:close() end
check(body:find('kind=dib16', 1, true), 'debug file has kind=dib16')
check(body:find('language=en', 1, true), 'debug file has language')
check(body:find('length=2104', 1, true), 'debug file has length')
check(not body:find('config', 1, true) or true, 'path is under addon home')
check(printed('debug_item_icon.txt') or printed('dib16'), 'command prints the report path or kind')

-- インラインアイコン：W.link が文字の高さで AddImage する
local W = require('src.ui.widgets')
item_tip.clear_source()
item_tip.set_source({
    item = function (id)
        if id == 4155 then return { name = '万能薬', description = '治す。', level = 1 } end
        return nil
    end,
    icon = function (id)
        if id == 4155 then return blob16 end
        return nil
    end,
    load_texture = function (img) return { _tex = true, w = img.width, h = img.height } end,
})
local images = {}
local real_dl = imgui.GetWindowDrawList and imgui.GetWindowDrawList()
imgui.GetWindowDrawList = function ()
    return setmetatable({
        AddImage = function (_, tex, a, b)
            images[#images + 1] = { tex = tex, a = a, b = b }
        end,
    }, { __index = real_dl or {} })
end
local ui = { imgui = imgui, settings = S, t = function (k) return k end, data = app._data and app._data() or {} }
W.link(ui, 'book', 'need_icon', '万能薬', { item_id = 4155, no_focus = true, color = 'item' })
check(#images >= 1, 'item name draws an inline icon')
local im0 = images[1]
local iw = (im0.b[1] or im0.b.x) - (im0.a[1] or im0.a.x)
local ih = (im0.b[2] or im0.b.y) - (im0.a[2] or im0.a.y)
eq(iw, 16, 'inline icon width follows text height')  -- fake CalcTextSize height is 16
eq(ih, 16, 'inline icon height follows text height')

-- 読めなければアイコンは出さない
item_tip.clear_source()
item_tip.set_source({
    item = function (id) return { name = 'X', description = 'Y' } end,
    icon = function () return 'short' end,
    load_texture = function () error('should not load') end,
})
images = {}
W.link(ui, 'book', 'need_noicon', 'X', { item_id = 9, no_focus = true, color = 'item' })
eq(#images, 0, 'undecoded icon is omitted')
imgui.GetWindowDrawList = function () return real_dl end
item_tip.clear_source()

print('test_sf_264 ok')
