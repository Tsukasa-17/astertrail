-- 0.1.277：SF 地図のゾーン名と階タブをずらす。目盛りは枠付きの帯。アイテム説明のダメージ「Ｄ」を D にし、重複を除く
require('fake_env')
local imgui = package.loaded['imgui'] or require('imgui')

local app = require('src.app')
eq(app.VERSION, '1.1.318', 'version')

local tip = require('src.ui.item_tip')
local theme = require('src.ui.theme')

-- 日本語 DAT（ROM/0/6.DAT、トライアルサパラ 17654）の説明は Shift_JIS 0x82 0x63 で始まる（全角Ｄ）
local raw = string.char(0x82, 0x63) .. '38 隔236 潜在能力:HP+20 耐火+10 耐風+10'
local out = tip.clean_description(raw)
check(not out:find('38 隔236', 1, true), 'leading D38 隔236 is stripped: ' .. out)
check(out:find('潜在能力:HP+20', 1, true) ~= nil, 'latent text is kept')
check(out:find('耐火+10', 1, true) ~= nil and out:find('耐風+10', 1, true) ~= nil, 'resists are kept')
check(not out:find('??', 1, true), 'no replacement marks remain')
check(not out:find('Ｄ', 1, true), 'fullwidth D does not remain')

-- 変換だけ（隔の組が無いとき）は D になる
eq(tip.clean_description(string.char(0x82, 0x63) .. 'X'), 'DX', 'SJIS 0x8263 becomes ASCII D')
eq(tip.clean_description('Ｄ38 隔236 潜在能力:HP+20'), '潜在能力:HP+20', 'UTF-8 fullwidth D is mapped and stripped')
eq(tip.clean_description('??38 隔236 潜在能力:HP+20'), '潜在能力:HP+20', 'already-garbled ?? is also stripped')
eq(tip.clean_description('A' .. string.char(0xEF, 0x1F) .. 'B'), 'A{Fire}B', 'element icons stay {Fire}')
eq(tip.clean_description('D82 隔480 潜在能力:HP+20 耐雷+10'), '潜在能力:HP+20 耐雷+10', 'trial scythe style is stripped')

-- 地図：タイトル幅を測ってからタブを置く。目盛りは帯と仕切り
local ms = io.open(ROOT .. '/src/ui/map_sf.lua', 'r'):read('*a')
check(ms:find('SCALE_BAND', 1, true) ~= nil, 'scale band size is shared')
check(ms:find('measure_text(imgui, title_s)', 1, true) ~= nil, 'title width is measured')
check(ms:find('font(ui, name, 1.28, false)', 1, true) ~= nil, 'title font is applied')
-- 測るのは字体を戻すより前
local i_meas = ms:find('measure_text(imgui, title_s)', 1, true)
local i_reset = ms:find("font(ui, name, 1, false)", i_meas or 1, true)
check(i_meas and i_reset and i_meas < i_reset, 'title is measured with the title font, before reset')
check(ms:find('hx + nw + 16', 1, true) ~= nil, 'tabs start after title width plus gap')
check(ms:find('AddRect', 1, true) ~= nil, 'scale strips have an outline')
check(ms:find('by1, by2', 1, true) ~= nil or ms:find('r2 - band', 1, true) ~= nil, 'letter strip sits above the frame')
check(ms:find('r1 - band', 1, true) ~= nil, 'number strip sits left of the frame')
check(ms:find('x_center', 1, true) ~= nil and ms:find('y_center', 1, true) ~= nil, 'labels are centered in grid cells')
check(ms:find('tw * 0.5', 1, true) ~= nil and ms:find('th * 0.5', 1, true) ~= nil, 'text is centered in the band cell')
-- クラシックの地図は触らない
local mv = io.open(ROOT .. '/src/ui/map_view.lua', 'r'):read('*a')
check(not mv:find('SCALE_BAND', 1, true), 'classic map_view has no SF scale band')

print('test_sf_277 ok')
