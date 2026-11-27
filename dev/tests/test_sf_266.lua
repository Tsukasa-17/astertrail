-- 0.1.266：Melete は範囲なしで読む、アイテム名ツールチップなし、丸ハート、受注／解除の色
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.327', 'version')

local crisp = require('src.ui.crisp_font')
local eminence = require('src.ui.eminence')
local W = require('src.ui.widgets')
local CT = require('src.ui.colored_text')
local item_tip = require('src.ui.item_tip')
local theme = require('src.ui.theme')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')

---------------------------------------------------------------------------
-- Melete：自前の英字範囲を付けず、メイリオと同じく読む。ログを厚くする
---------------------------------------------------------------------------
local crisp_src = io.open(ROOT .. '/src/ui/crisp_font.lua', 'r'):read('*a')
check(not crisp_src:find('0x0020, 0x007E', 1, true), 'heading load no longer binds a custom Latin range')
check(crisp_src:find('ranges=default', 1, true) ~= nil, 'debug log records default ranges')
check(crisp_src:find('--- after ensure ---', 1, true) ~= nil, 'debug log continues after ensure')
check(crisp_src:find('--- first push_heading ---', 1, true) ~= nil, 'debug log records the first heading push')
check(crisp_src:find('width_A=', 1, true) ~= nil, 'debug log records the width of A')
check(crisp_src:find('same_font=', 1, true) ~= nil, 'debug log records whether GetFont is Melete')
eq(crisp.heading_rel(), 'fonts/melete/Melete-Bold.ttf', 'heading still prefers the TTF')

---------------------------------------------------------------------------
-- アイテム名：ツールチップを再開（0.1.268）。数の場所案内とコピーは残す
---------------------------------------------------------------------------
local wsrc = io.open(ROOT .. '/src/ui/widgets.lua', 'r'):read('*a')
local link = wsrc:match('function W%.link.-\nfunction ')
check(wsrc:find('show_for_need', 1, true) ~= nil, 'W.link can call show_for_need again')

item_tip.clear_source()
item_tip.set_source({
    item = function (id)
        if id == 4155 then
            return { name = '万能薬', description = 'ほとんどの状態異常を治す。', level = 1, flags = 0 }
        end
        return nil
    end,
    icon = function () return nil end,
})

local im = package.loaded['imgui']
local tips, last_btn, hover_pat = {}, nil, nil
local saved_ib = rawget(im, 'InvisibleButton')
im.InvisibleButton = function (label, size)
    last_btn = label
    return saved_ib(label, size)
end
im.IsItemHovered = function ()
    if not hover_pat then return false end
    return type(last_btn) == 'string' and last_btn:find(hover_pat, 1, true) ~= nil
end
im.SetTooltip = function (s)
    tips[#tips + 1] = tostring(s or '')
end
im.BeginTooltip = function () return false end
im.EndTooltip = function () end

local function has_tip(pat)
    for _, s in ipairs(tips) do
        if tostring(s):find(pat, 1, true) then return true end
    end
    return false
end

local S = app._settings()
local function ui_of()
    return {
        imgui = im, settings = S, data = app._data(),
        t = function (k) return k end, mark_settings_dirty = function () end,
    }
end

local terms = {}
CT.add(terms, '万能薬', 'item', { item_id = 4155, copy_text = '万能薬' })
CT.add(terms, '0/1', 'poss_count', { tip = 'かばん1', copy_text = '万能薬', dup = true, once = true, key = '万能薬' })

tips = {}
hover_pat = '万能薬##need_1_item'
local clicked = W.term_line(ui_of(), 'detail', 'need_1', '万能薬を持っていく (0/1)', terms, {
    color = nil, muted = false, no_focus = true, focus_acts = {},
})
check(has_tip('万能薬'), 'item name hover shows the name')
check(has_tip('ほとんどの状態異常'), 'item name hover shows the description')
check(not has_tip('かばん1'), 'item hover does not show the location tip')
eq(clicked, nil, 'hover alone does not copy')

tips = {}
hover_pat = '0/1##need_1_poss_count'
clicked = W.term_line(ui_of(), 'detail', 'need_1', '万能薬を持っていく (0/1)', terms, {
    color = nil, muted = false, no_focus = true, focus_acts = {},
})
check(has_tip('かばん1'), 'count hover still shows the location tip')
check(not has_tip('ほとんどの状態異常'), 'count hover does not show the item description')

---------------------------------------------------------------------------
-- ハート：コンパクトな丸。高さは 2r 以内。SF だけ差し替え
---------------------------------------------------------------------------
check(eminence._heart_round ~= nil, 'round heart exists')
check(eminence._heart ~= nil, 'classic heart remains')
check(eminence._heart_a ~= nil, 'shape A remains unused by SF')
local sfsrc = io.open(ROOT .. '/src/ui/eminence_sf.lua', 'r'):read('*a')
check(sfsrc:find('_heart_round', 1, true) ~= nil, 'SF uses _heart_round')
check(not sfsrc:find('_heart_a', 1, true), 'SF no longer draws shape A')
local clsrc = io.open(ROOT .. '/src/ui/eminence.lua', 'r'):read('*a')
-- クラシックの描画呼び出しは _heart( のまま（_heart_round / _heart_a の定義は同ファイル）
check(clsrc:find('eminence._heart = heart', 1, true) ~= nil, 'classic still exports the original heart')
check(clsrc:find('local function heart(', 1, true) ~= nil, 'classic heart function remains in place')

-- 形状の高さ
local function bbox_h(r)
    local raw = {}
    local n = 64
    for i = 0, n - 1 do
        local a = (i / n) * math.pi * 2
        local sx = math.sin(a)
        local x = 16 * sx * sx * sx
        local y = 13 * math.cos(a) - 5 * math.cos(2 * a) - 2 * math.cos(3 * a) - math.cos(4 * a)
        if y < 0 then y = y * 0.52 end
        raw[#raw + 1] = { x, y }
    end
    local minx, miny, maxx, maxy = raw[1][1], raw[1][2], raw[1][1], raw[1][2]
    for _, p in ipairs(raw) do
        if p[1] < minx then minx = p[1] end
        if p[1] > maxx then maxx = p[1] end
        if p[2] < miny then miny = p[2] end
        if p[2] > maxy then maxy = p[2] end
    end
    local bw, bh = maxx - minx, maxy - miny
    local sc = math.min((r * 2 * 0.92) / bh, (r * 3 * 0.90) / bw)
    return bw * sc, bh * sc
end
local w6, h6 = bbox_h(6)
check(h6 <= 12 + 1e-6, 'heart height stays within the star height at r=6: ' .. tostring(h6))
check(w6 <= 18 + 1e-6, 'heart width stays within the 18px cell: ' .. tostring(w6))

---------------------------------------------------------------------------
-- 受注／解除：SF だけ色分け（カードと詳細）
---------------------------------------------------------------------------
check(sfsrc:find('paint_action', 1, true) ~= nil, 'SF paints accept/remove with a dedicated helper')
check(sfsrc:find("action = op", 1, true) ~= nil, 'detail pane passes the action to the chip')
-- 0.1.322〜：受注＝#80ADC7、解除（受注中）＝紫ピンク（状態の札の色分け）
check(sfsrc:find("'roe_st_open'", 1, true) ~= nil, 'accept uses the open state color (0.1.322)')
check(sfsrc:find("'roe_st_active'", 1, true) ~= nil, 'remove uses the active state color (0.1.322)')
check(sfsrc:find('hover and', 1, true) ~= nil, 'accept/remove still have a hover shade')
-- クラシックの操作ボタンは従来の色のまま（この版では触らない）
check(clsrc:find('roe_take', 1, true) ~= nil, 'classic still has teal take colors')

print('test_sf_266 ok')
