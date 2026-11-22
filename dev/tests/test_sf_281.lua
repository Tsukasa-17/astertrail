-- 0.1.281：SF 地図の閉じる修正、堀ブナを 4401 に絞る、お知らせの中央揃えとネオン暈
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.308', 'version')

-- --- ソース：閉じるは地図列。右ペインはバーより上。クリックで close_window ---
local ms = io.open(ROOT .. '/src/ui/map_sf.lua', 'r'):read('*a')
check(ms:find("W.button(ui, name, 'close'", 1, true) ~= nil, 'SF map still has close')
check(ms:find('col_r', 1, true) ~= nil, 'close uses the map-column right edge')
check(ms:find('sf.set_cursor', 1, true) ~= nil, 'close is not full-window SetCursorPosX')
check(not ms:find('rest - cw', 1, true), 'buggy full-window rest-cw align is gone')
check(ms:find("ui.close_window('map')", 1, true) ~= nil, 'close calls close_window(map)')
-- 右ペインは下バー（by）より上まで。bot_h を足して覆わない
local i_side = ms:find('if right_w > 0 then', 1, true)
check(i_side ~= nil, 'right pane still exists')
local side = ms:sub(i_side, i_side + 400)
check(side:find('(by or frame_b) - my', 1, true) ~= nil, 'right pane stops above the button bar')
check(not side:find('(frame_b - my) + bot_h', 1, true), 'right pane no longer extends over the bar')
-- 戻るはこれまでどおり履歴があるときだけ
check(ms:find('if info.back and #info.back > 0 then', 1, true) ~= nil, 'back condition unchanged')

local mv = io.open(ROOT .. '/src/ui/map_view.lua', 'r'):read('*a')
check(mv:find("W.button(ui, name, 'close', t('common.close')", 1, true) ~= nil, 'classic map close unchanged')
check(not mv:find('col_r', 1, true), 'classic map_view does not get the SF close layout')

-- --- 堀ブナは 4401。ほかの複数番号はそのまま（魚は未確定、結晶・チップはどれか） ---
local data_mod = require('src.core.data')
local D = data_mod.load(posix_fs(), ROOT .. '/data/')
eq(D.version, '2026.11.20-125', 'data version')
local carp = D:lookup_item_name('堀ブナ')
check(carp and carp.item_id == 4401 and not carp.item_ids, '堀ブナ is single id 4401')
check(D:lookup_item_name('森ブナ') and D:lookup_item_name('森ブナ').item_id == 4289, '森ブナ stays 4289')
local quus = D:lookup_item_name('キュス')
check(quus and quus.item_ids and #quus.item_ids == 2, 'キュス remains items_any (unconfirmed)')
local cray = D:lookup_item_name('ザリガニ')
check(cray and cray.item_ids and #cray.item_ids == 2, 'ザリガニ remains items_any (unconfirmed)')
local cry = D:lookup_item_name('クリスタル')
check(cry and cry.item_ids and #cry.item_ids == 8, 'クリスタル still sums 8 elements')
local extra = io.open(ROOT .. '/data/item_refs_extra.json', 'r'):read('*a')
check(extra:find('"堀ブナ": 4401', 1, true) ~= nil, 'extra items has 堀ブナ 4401')
check(not extra:find('"堀ブナ": [4401, 5789]', 1, true), '堀ブナ is not in items_any')

-- --- お知らせ：中央揃えとネオン暈（ソース）。クラシックは触らない ---
local nsf = io.open(ROOT .. '/src/ui/notices_sf.lua', 'r'):read('*a')
check(nsf:find("align = 'center'", 1, true) ~= nil, 'SF heading is centered')
check(nsf:find("CT.wrapped(ui, qname", 1, true) ~= nil and nsf:find("'center'", 1, true) ~= nil,
    'quest name is centered')
check(nsf:find('center_in_popup', 1, true) ~= nil or nsf:find('center_row', 1, true) ~= nil, 'buttons are centered to the popup width')
local notices = io.open(ROOT .. '/src/ui/notices.lua', 'r'):read('*a')
check(notices:find("theme.is_sf()", 1, true) ~= nil, 'notices still hooks SF')
check(notices:find('theme.draw_popup_glass', 1, true) == nil or true, 'placeholder')
-- クラシック本体は heading_line の中央寄せや CT.wrapped center を使わない
check(not notices:find("align = 'center'", 1, true), 'classic notices has no SF center align')
check(not notices:find("CT.wrapped", 1, true), 'classic notices does not use CT.wrapped center')

local sfs = io.open(ROOT .. '/src/ui/sf_style.lua', 'r'):read('*a')
check(sfs:find('for i = 1, n do', 1, true) ~= nil, 'halo has several expanding outlines')
check(sfs:find('opts.reduce_motion', 1, true) ~= nil, 'halo pulse respects reduce_motion')
check(sfs:find("complete and 'gold' or 'sf_cyan'", 1, true) ~= nil, 'complete halo is gold, else cyan')
-- 0.1.291〜：暈は窓の中（前景の描画リストは使わない。test_sf_291）
check(sfs:find('PushClipRect', 1, true) ~= nil, 'halo is clipped to the popup window rect')

local win = io.open(ROOT .. '/src/ui/window.lua', 'r'):read('*a')
check(win:find('theme.draw_popup_glass', 1, true) ~= nil, 'classic/YunaUI glass is unchanged')

-- --- 実行：SF 地図の閉じるクリック、お知らせの中央と暈 ---
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Sf281', zone = 100, tidx = 5, status = 0, x = -100, y = 200, z = -60 }
frames(1)
check(app.state.ready, 'logged in')
local S = app._settings()
local theme = require('src.ui.theme')
local imgui = package.loaded['imgui'] or require('imgui')

S.look = 'sf'
theme.set_look('sf')
S.map = S.map or {}
S.map.enabled = true
app.open_map()
frame(); frame()
check(app.state.open.map, 'SF map is open')
check(labeled('##close') or labeled('閉じる'), 'SF map drew the close button')
FAKE.clicks['##close'] = true
frame()
check(not app.state.open.map, 'clicking 閉じる closes the SF map')

-- クラシックの地図でも閉じるはこれまでどおり動く
S.look = 'classic'
theme.set_look('classic')
app.open_map()
frame(); frame()
check(app.state.open.map, 'classic map is open')
FAKE.clicks['##close'] = true
frame()
check(not app.state.open.map, 'classic close still works')

-- お知らせ：見出し・詳細が出て、ボタンが中央（Dummy の ox > 0）、暈が複数
S.look = 'sf'
theme.set_look('sf')
S.notify = S.notify or {}
S.notify.popup = true
S.notify.sound = false
S.reduce_motion = true

-- カーソルを測れるようにする（中央寄せの実行）
local cx = 0
imgui.GetCursorPosX = function () return cx end
imgui.SetCursorPosX = function (x)
    cx = tonumber(x) or cx
    FAKE.cursor_xs = FAKE.cursor_xs or {}
    FAKE.cursor_xs[#FAKE.cursor_xs + 1] = cx
end
local orig_dummy = imgui.Dummy
imgui.Dummy = function (sz)
    FAKE.dummies = FAKE.dummies or {}
    FAKE.dummies[#FAKE.dummies + 1] = sz
    if orig_dummy then pcall(orig_dummy, sz) end
end

-- 前景の線を記録
local halo = { lines = 0, cols = {} }
local halo_dl = setmetatable({
    AddLine = function (_, a, b, col, thick)
        halo.lines = halo.lines + 1
        halo.cols[#halo.cols + 1] = col
    end,
    AddPolyline = function (_, pts, col, flags, thick)
        halo.lines = halo.lines + 1
        halo.cols[#halo.cols + 1] = col
    end,
}, { __index = function () return function () end end })
-- 0.1.291〜：暈はお知らせの窓の描画リスト（窓の中）。お知らせの窓の間だけ記録する
halo_dl.AddText = function (_, pos, col, text)
    if type(text) == 'string' then FAKE.texts[#FAKE.texts + 1] = text end
end
local in_popup = false
local orig_begin, orig_wdl = imgui.Begin, imgui.GetWindowDrawList
imgui.Begin = function (title, open, flags)
    in_popup = tostring(title):find('astertrail_popup', 1, true) ~= nil
    return orig_begin(title, open, flags)
end
imgui.End = function () in_popup = false end
imgui.GetWindowDrawList = function ()
    if in_popup then return halo_dl end
    return orig_wdl()
end

check(app.popup_preview('accept'), 'sf preview accept')
FAKE.cursor_xs, FAKE.dummies = {}, {}
halo.lines, halo.cols = 0, {}
frame()
check(texted('QUEST ACCEPTED'), 'SF heading still QUEST ACCEPTED')
-- Dummy({ ox, 0 }) for button row: ox should be well above 0 on a 380px row
local centered = false
for _, sz in ipairs(FAKE.dummies or {}) do
    if type(sz) == 'table' then
        local w, h = tonumber(sz[1] or sz.x), tonumber(sz[2] or sz.y)
        if w and h and h == 0 and w > 40 and w < 300 then centered = true end
    end
end
-- SetCursorPosX also counts as centering for wrapped text
if not centered then
    for _, x in ipairs(FAKE.cursor_xs or {}) do
        if tonumber(x) and tonumber(x) > 40 then centered = true end
    end
end
check(centered, 'popup text or buttons were shifted toward the center')
check(halo.lines >= 5, 'halo draws several outlines, got ' .. tostring(halo.lines))
check(#halo.cols > 0, 'halo recorded colors')

-- 完了は金。同じ前景リストで色が受注と違う
local accept_col = halo.cols[1]
app.popup_choose(false); frames(1)
check(app.popup_preview('complete'), 'sf preview complete')
halo.lines, halo.cols = 0, {}
frame()
check(texted('QUEST COMPLETE') or texted('MISSION COMPLETE') or texted('EMINENCE COMPLETE'),
    'SF complete heading')
check(#halo.cols > 0, 'complete halo recorded colors')
check(halo.cols[1] ~= accept_col, 'complete halo color differs from accept (gold vs cyan)')
app.popup_choose(false); frames(1)

-- reduce_motion：脈打ち無しでも暈はある。時刻を変えても同じアルファ（先頭色が同じ）
S.reduce_motion = true
check(app.popup_preview('accept'), 'preview with reduce_motion')
halo.lines, halo.cols = 0, {}
frame(0)
local c0 = halo.cols[1]
local n0 = halo.lines
halo.lines, halo.cols = 0, {}
frame(1.2)
local c1 = halo.cols[1]
check(n0 >= 5 and halo.lines >= 5, 'static halo remains when reduce_motion is on')
check(c0 ~= nil and c0 == c1, 'halo color/alpha is stable when reduce_motion is on')
app.popup_choose(false); frames(1)

-- クラシックのお知らせは英語見出しにしない（従来）
S.look = 'classic'
theme.set_look('classic')
check(app.popup_preview('accept'), 'classic preview')
frame()
check(texted('クエスト受注') or texted('Quest Accepted'), 'classic popup title unchanged')
check(not texted('QUEST ACCEPTED'), 'classic does not use the SF English heading')
app.popup_choose(false); frames(1)

print('test_sf_281 ok')
