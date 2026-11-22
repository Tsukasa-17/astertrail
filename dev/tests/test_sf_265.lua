-- 0.1.265：Melete を TTF で読む、17 バイト前置きのアイコン、カードの受注／解除、ハート A
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.300', 'version')

local crisp = require('src.ui.crisp_font')
local item_tip = require('src.ui.item_tip')
local eminence = require('src.ui.eminence')
local theme = require('src.ui.theme')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')

---------------------------------------------------------------------------
-- Melete：TrueType を先に読む（公式 OTF は CFF/OTTO で AddFontFromFileTTF が読めない）
---------------------------------------------------------------------------
local ttf = ROOT .. '/fonts/melete/Melete-Bold.ttf'
local otf = ROOT .. '/fonts/melete/Melete-Bold.otf'
local f = io.open(ttf, 'rb'); check(f ~= nil, 'Melete-Bold.ttf is bundled')
local mag = f and f:read(4) or ''
if f then f:close() end
eq(mag, string.char(0, 1, 0, 0), 'TTF starts with TrueType sfnt (not OTTO)')
f = io.open(otf, 'rb'); check(f ~= nil, 'official OTF is still bundled')
local om = f and f:read(4) or ''
if f then f:close() end
eq(om, 'OTTO', 'official file is still CFF/OTTO')
eq(crisp.heading_rel(), 'fonts/melete/Melete-Bold.ttf', 'heading prefers the TTF')
addon.path = ROOT .. '/'
local hf = crisp.heading_file()
check(type(hf) == 'string' and hf:find('Melete%-Bold%.ttf', 1), 'heading_file finds the TTF: ' .. tostring(hf))

---------------------------------------------------------------------------
-- アイコン：実機と同じ 17 バイト前置き（ImageType + ImageName + DIB）、biClrUsed=32 でも 256 色
---------------------------------------------------------------------------
item_tip.clear_source()
local function u32le(n)
    n = n % 4294967296
    return string.char(n % 256, math.floor(n / 256) % 256, math.floor(n / 65536) % 256, math.floor(n / 16777216) % 256)
end
local prefix = string.char(0x91) .. 'item    item0059'
eq(#prefix, 17, 'ImageType + ImageName is 17 bytes')
local hdr = u32le(40) .. u32le(32) .. u32le(32) .. string.char(1, 0, 8, 0)
    .. string.rep('\0', 16) .. u32le(32) .. u32le(0)  -- biClrUsed=32, like the GAME-PC dump
eq(#hdr, 40, 'BITMAPINFOHEADER is 40 bytes')
local pal = {}
for i = 0, 255 do
    if i == 0 then pal[#pal + 1] = string.char(0, 0, 0, 0)
    elseif i == 1 then pal[#pal + 1] = string.char(0, 0, 255, 0)  -- red in BGRA
    else pal[#pal + 1] = string.char(40, 40, 40, 128)
    end
end
-- 右下（上から見て最後の行の最後＝ボトムアップでは先頭行）を index 1
local pix = string.char(1) .. string.rep('\0', 31) .. string.rep('\0', 32 * 31)
local blob = prefix .. hdr .. table.concat(pal) .. pix
eq(#blob, 2105, 'blob length matches the GAME-PC dump')
local img = item_tip.decode_icon(blob)
check(img ~= nil, '17-byte prefix DIB decodes')
eq(item_tip.last_icon_kind, 'dib17', 'kind is dib17')
eq(img.width, 32, 'width 32')
eq(img.height, 32, 'height 32')
-- ボトムアップ：ファイル先頭行は画像の最下行。index 1 は赤
local r, g, b, a = img.rgba:byte((31 * 32 + 0) * 4 + 1, (31 * 32 + 0) * 4 + 4)
eq(r, 255, 'bottom-left is red (256-color palette, not clipped to 32)')
eq(g, 0, 'red g')
eq(b, 0, 'red b')
eq(a, 255, 'red opaque')

---------------------------------------------------------------------------
-- カード：進行中／未開始は出さず、受注／解除。ハート A を使う
---------------------------------------------------------------------------
local src = io.open(ROOT .. '/src/ui/eminence_sf.lua', 'r'):read('*a')
check(src:find("t%('roe.accept'%)", 1) ~= nil, 'card uses 受注 label')
check(src:find("t%('roe.remove'%)", 1) ~= nil, 'card uses 解除 label')
check(src:find('_heart_round', 1, true) ~= nil, 'SF card draws the compact round heart (0.1.266)')
check(eminence._heart_round ~= nil, 'eminence._heart_round exists')
check(eminence._heart_a ~= nil, 'heart A remains as a function')
-- クラシックの heart 関数自体は残す
check(eminence._heart ~= nil, 'classic heart function remains')
check(eminence._heart ~= eminence._heart_round, 'SF round heart is a separate function')

print('test_sf_265 ok')
