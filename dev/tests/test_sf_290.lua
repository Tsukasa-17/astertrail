-- 0.1.290：お知らせの内側丸角枠と上の帯を消す。ボタンは明示幅で中央。手順の塗りは枠の内側だけ
require('fake_env')

local theme = require('src.ui.theme')
local app = require('src.app')
eq(app.VERSION, '1.1.324', 'version')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
FAKE.keep_default_look = true
theme.set_look('sf')
frames(1)
check(app.state.ready, 'logged in')
local S = app._settings()
S.look = 'sf'
theme.set_look('sf')

-- --- ソース：内側の丸角枠と上の帯、ボタン、手順の塗り ---
local nsf = io.open(ROOT .. '/src/ui/notices_sf.lua', 'r'):read('*a')
check(nsf:find('W.astral_popup_button', 1, true) ~= nil, 'popup uses the explicit-size Astral button (0.1.291), not W.button')
check(not nsf:find('W.button(', 1, true), 'popup no longer uses W.button (Button {w,0} filled the remaining width)')
check(nsf:find('center_in_popup', 1, true) ~= nil, 'button row still centers with one offset')
check(nsf:find('yw + gap + nw', 1, true) ~= nil, 'two-button row width is yes + gap + no')
check(nsf:find('BTN_MAX', 1, true) ~= nil, 'button width is capped')
check(nsf:find('width = yw', 1, true) ~= nil and nsf:find('width = nw', 1, true) ~= nil,
    'both pin buttons pass an explicit width')
check(nsf:find('width = cw', 1, true) ~= nil, 'close button passes an explicit width')
check(nsf:find('height = bh', 1, true) ~= nil, 'buttons pass an explicit height')

local wdg = io.open(ROOT .. '/src/ui/widgets.lua', 'r'):read('*a')
local i_pb = wdg:find('function W.popup_button', 1, true)
check(i_pb ~= nil, 'W.popup_button exists')
local pb = wdg:sub(i_pb, (wdg:find('function W.', i_pb + 10, true) or (i_pb + 3500)) - 1)
check(pb:find('W._popup_hit', 1, true) ~= nil, 'popup_button hits with InvisibleButton (W._popup_hit, {w,h} table, 0.1.291)')
-- 0.1.291〜：当たり自体が明示幅なので Dummy は重ねない（重ねると IsItemHovered が Dummy を指す）
check(wdg:find('x1 + bw', 1, true) ~= nil, 'drawn button chrome is clamped to the requested width')

local ths = io.open(ROOT .. '/src/ui/theme.lua', 'r'):read('*a')
local i_gl = ths:find('function theme.draw_popup_glass', 1, true)
check(i_gl ~= nil, 'draw_popup_glass exists')
local gl = ths:sub(i_gl, i_gl + 2500)
check(gl:find('theme.is_sf', 1, true) ~= nil and gl:find('return', 1, true) ~= nil,
    'draw_popup_glass is a no-op when the look is Astral (rounded r=16 inner frame)')
check(gl:find('local r = 16', 1, true) ~= nil, 'classic glass still uses rounding 16 after the SF guard')

local sfs = io.open(ROOT .. '/src/ui/sf_style.lua', 'r'):read('*a')
local i_pop = sfs:find('function sf.draw_popup', 1, true)
check(i_pop ~= nil, 'draw_popup exists')
local body = sfs:sub(i_pop, i_pop + 5000)
check(body:find('band = false', 1, true) ~= nil, 'SF popup frame does not draw the top band')
check(not body:find('band = true', 1, true), 'SF popup no longer requests the top band')

local wins = io.open(ROOT .. '/src/ui/window.lua', 'r'):read('*a')
-- 0.1.291〜：SF お知らせは SetNextWindowSize を呼ばない（高さの自動サイズが止まる。test_sf_291）
check(wins:find('popup_outer_w', 1, true) ~= nil, 'forced size uses the frame outer width')

local bsf = io.open(ROOT .. '/src/ui/book_sf.lua', 'r'):read('*a')
local step_loop = bsf:sub(bsf:find('local DOT_R, COL, ROW_GAP', 1, true) or 1,
    bsf:find('if hidden > 0 then', 1, true) or #bsf)
-- 早期の guessed 塗りはチェック前の frame_x を使うので消す
local i_chk = step_loop:find('frame_x = chk_x2 + FRAME_GAP', 1, true)
local i_fill = step_loop:find('sf.fill_cut', 1, true)
local i_frame = step_loop:find('sf.frame(', 1, true)
check(i_chk ~= nil, 'frame_x is measured from the checkbox right edge')
check(i_fill ~= nil, 'selected-step fill still exists')
check(i_frame ~= nil, 'selected-step frame still exists')
check(i_chk < i_fill, 'fill is drawn after the checkbox is measured, not before')
check(i_fill < i_frame, 'fill is drawn with the same final rect as the frame')
check(step_loop:find('x1 + thick', 1, true) ~= nil and step_loop:find('x2 - thick', 1, true) ~= nil,
    'fill is inset by the border thickness')
check(step_loop:find('cut - thick', 1, true) ~= nil, 'fill cut is inset by the corner cut / thickness')
check(step_loop:find('ay + guessed', 1, true) == nil, 'fill no longer uses the guessed height ahead of the frame')
check(step_loop:find('ImGuiCol_ButtonHovered', 1, true) ~= nil, 'full-row hit hides Button hover fill')
check(step_loop:find('ImGuiCol_HeaderHovered', 1, true) ~= nil, 'full-row hit hides Header hover fill')
check(step_loop:find('PopStyleColor', 1, true) ~= nil, 'hit chrome styles are popped before the checkbox is drawn')
check(step_loop:find("'##sfstep_' .. s.id", 1, true) ~= nil, 'full-row ##sfstep_ hit remains')

-- --- 実行：glass は SF では描かない。帯も出さない。ボタンは明示幅 ---
local sf = require('src.ui.sf_style')
local imgui = package.loaded['imgui'] or require('imgui')

-- draw_popup_glass must not emit rounded rects while look is sf
local rects = 0
local fake_dl = {
    AddRect = function () rects = rects + 1 end,
    AddRectFilled = function () rects = rects + 1 end,
    AddRectFilledMultiColor = function () rects = rects + 1 end,
    AddLine = function () end,
    AddCircleFilled = function () end,
}
local saved_gwd = imgui.GetWindowDrawList
imgui.GetWindowDrawList = function () return fake_dl end
imgui.GetWindowPos = function () return 10, 10 end
imgui.GetWindowSize = function () return 400, 200 end
theme.set_look('sf')
rects = 0
theme.draw_popup_glass(imgui, 'complete', { scale = 1, alpha = 1, reduce_motion = true })
eq(rects, 0, 'draw_popup_glass draws nothing when look is sf')
theme.set_look('classic')
rects = 0
theme.draw_popup_glass(imgui, 'complete', { scale = 1, alpha = 1, reduce_motion = true })
check(rects > 0, 'draw_popup_glass still draws the rounded glass for classic')
theme.set_look('sf')
if saved_gwd then imgui.GetWindowDrawList = saved_gwd end

-- popup preview: record InvisibleButton sizes, Dummy sizes, bands, glass calls
S.notify = S.notify or {}
S.notify.popup = true
S.notify.sound = false
S.reduce_motion = true

local inv_btns = {}
local orig_inv = imgui.InvisibleButton
imgui.InvisibleButton = function (label, a, b)
    local w, h = nil, nil
    if type(a) == 'number' then w, h = a, tonumber(b) end
    if type(a) == 'table' then w, h = tonumber(a[1] or a.x), tonumber(a[2] or a.y) end
    inv_btns[#inv_btns + 1] = { label = tostring(label or ''), w = w, h = h }
    if orig_inv then return orig_inv(label, a, b) end
    return false
end
local orig_btn = imgui.Button
local filled_btns = {}
imgui.Button = function (label, a, b)
    local w
    if type(a) == 'table' then w = tonumber(a[1] or a.x) end
    if type(a) == 'number' then w = a end
    filled_btns[#filled_btns + 1] = { label = tostring(label or ''), w = w }
    if orig_btn then return orig_btn(label, a, b) end
    return false
end
local orig_glass = theme.draw_popup_glass
local glass_n = 0
theme.draw_popup_glass = function (...)
    glass_n = glass_n + 1
    return orig_glass(...)
end
local orig_frame = sf.frame
local bands = 0
local frame_fill_a = {}
sf.frame = function (dl, x1, y1, x2, y2, opts)
    opts = opts or {}
    if sf._in_draw_popup and opts.band ~= false then bands = bands + 1 end
    if sf._in_draw_popup then frame_fill_a[#frame_fill_a + 1] = opts.band end
    return orig_frame(dl, x1, y1, x2, y2, opts)
end
local orig_draw = sf.draw_popup
sf.draw_popup = function (im, kind, opts)
    sf._in_draw_popup = true
    local ok, r = pcall(orig_draw, im, kind, opts)
    sf._in_draw_popup = false
    if not ok then error(r) end
    return r
end
local center_calls = {}
local orig_center = sf.center_in_popup
sf.center_in_popup = function (im, width, inner)
    local ox = orig_center(im, width, inner)
    center_calls[#center_calls + 1] = { width = width, inner = inner or sf.POPUP_INNER_W, ox = ox }
    return ox
end

check(app.popup_preview('accept'), 'sf preview accept')
inv_btns, filled_btns, glass_n, bands, frame_fill_a, center_calls = {}, {}, 0, 0, {}, {}
frame()
check(texted('QUEST ACCEPTED'), 'SF heading still QUEST ACCEPTED')
eq(glass_n, 0, 'classic draw_popup_glass is not called for an Astral popup')
eq(bands, 0, 'popup sf.frame does not draw the top band')
check(#inv_btns >= 2, 'accept popup uses InvisibleButton for both actions: ' .. tostring(#inv_btns))
local function find_btn(part)
    for _, b in ipairs(inv_btns) do
        if b.label:find(part, 1, true) then return b end
    end
end
local yes_b = find_btn('pin_yes')
local no_b = find_btn('pin_no')
check(yes_b ~= nil, 'ピン留めする uses InvisibleButton')
check(no_b ~= nil, 'しない uses InvisibleButton')
check(yes_b.w and yes_b.w > 0 and yes_b.w <= 200, 'yes width is explicit and capped, not remaining/inner width: ' .. tostring(yes_b.w))
check(no_b.w and no_b.w > 0 and no_b.w <= 200, 'no width is explicit and capped: ' .. tostring(no_b.w))
check(yes_b.w ~= sf.POPUP_INNER_W and no_b.w ~= sf.POPUP_INNER_W, 'neither button uses the full inner width')
check(#center_calls >= 1, 'two-button row is centered once')
local cc = center_calls[1]
eq(cc.inner, 560, 'centering uses inner width 560')
eq(cc.width, yes_b.w + 14 + no_b.w, 'centered width is yes + gap + no')
eq(cc.ox, (560 - cc.width) / 2, 'cursor X offset is (inner_w - total) / 2')
-- W.button path should not have been used (imgui.Button with width 0)
local zero_w = 0
for _, b in ipairs(filled_btns) do
    if b.label:find('pin_yes', 1, true) or b.label:find('pin_no', 1, true) then
        if not b.w or b.w == 0 then zero_w = zero_w + 1 end
    end
end
eq(zero_w, 0, 'pin buttons are not imgui.Button with width 0 (that fills remaining width)')

app.popup_choose(false); frames(1)
check(app.popup_preview('complete'), 'sf preview complete')
inv_btns, glass_n, bands, center_calls = {}, 0, 0, {}
frame()
check(texted('QUEST COMPLETE') or texted('MISSION COMPLETE') or texted('EMINENCE COMPLETE'),
    'SF complete heading')
eq(glass_n, 0, 'complete also skips draw_popup_glass')
eq(bands, 0, 'complete also has no top band')
local close_b = find_btn('dismiss')
check(close_b ~= nil, '閉じる uses InvisibleButton')
check(close_b.w and close_b.w > 0 and close_b.w <= 200, 'close width is explicit and capped: ' .. tostring(close_b.w))
check(#center_calls >= 1, 'close button is centered')
eq(center_calls[1].width, close_b.w, 'close centering uses the same explicit width')
app.popup_choose(false); frames(1)

-- --- 実行：今の手順の塗りは枠と同じ矩形の内側 ---
local Q = 'quest.bastok.011'
local q = app._data():quest(Q)
if not q or not q.steps or #q.steps < 2 then
    Q = 'quest.windurst.013'
    q = app._data():quest(Q)
end
if not q or not q.steps or #q.steps < 2 then
    Q = 'quest.sandoria.020'
    q = app._data():quest(Q)
end
check(q and q.steps and #q.steps >= 2, 'test quest has at least two steps: ' .. tostring(Q))
app._progress():set_state(Q, 'accepted')
eq(app._progress():state(Q), 'accepted', 'accept the quest')
local sid = q.steps[2] and q.steps[2].id or q.steps[1].id
app.request('set_current_step', Q, sid)

local fills, frames_r = {}, {}
local orig_fill = sf.fill_cut
sf.fill_cut = function (dl, x1, y1, x2, y2, cut, col)
    fills[#fills + 1] = { x1 = x1, y1 = y1, x2 = x2, y2 = y2, cut = cut }
    return orig_fill(dl, x1, y1, x2, y2, cut, col)
end
sf.frame = function (dl, x1, y1, x2, y2, opts)
    frames_r[#frames_r + 1] = { x1 = x1, y1 = y1, x2 = x2, y2 = y2, opts = opts or {} }
    return orig_frame(dl, x1, y1, x2, y2, opts)
end

app.open_detail_solo(Q)
fills, frames_r = {}, {}
frame(); frame(); frame()
check(app.state.open.detail, 'standalone Astral detail opens')
-- 今の手順の枠（fill_a=0, glow=1, brackets=false）に対応する塗りがある
local cur_fr
for _, r in ipairs(frames_r) do
    if r.opts and r.opts.glow == 1 and r.opts.fill_a == 0 and r.opts.brackets == false then
        cur_fr = r
    end
end
check(cur_fr ~= nil, 'current-step glowing frame was drawn')
-- sf.frame(fill_a=0) still calls fill_cut on the exact frame rect (transparent).
-- The highlight is the strictly inset fill (thickness 1.4 on each side).
local thick = 1.4
local function near(a, b)
    return math.abs((tonumber(a) or 0) - (tonumber(b) or 0)) < 0.05
end
local inset_fill
for _, f in ipairs(fills) do
    if near(f.x1, cur_fr.x1 + thick) and near(f.y1, cur_fr.y1 + thick)
        and near(f.x2, cur_fr.x2 - thick) and near(f.y2, cur_fr.y2 - thick) then
        inset_fill = f
    end
end
check(inset_fill ~= nil, 'selected fill uses the frame rect inset by the border thickness')
eq(tonumber(string.format('%.2f', inset_fill.x1)), tonumber(string.format('%.2f', cur_fr.x1 + thick)),
    'fill left is frame left + thickness')
eq(tonumber(string.format('%.2f', inset_fill.x2)), tonumber(string.format('%.2f', cur_fr.x2 - thick)),
    'fill right is frame right - thickness')
eq(tonumber(string.format('%.2f', inset_fill.y1)), tonumber(string.format('%.2f', cur_fr.y1 + thick)),
    'fill top is frame top + thickness')
eq(tonumber(string.format('%.2f', inset_fill.y2)), tonumber(string.format('%.2f', cur_fr.y2 - thick)),
    'fill bottom is frame bottom - thickness')

-- hooks back
imgui.InvisibleButton = orig_inv
imgui.Button = orig_btn
theme.draw_popup_glass = orig_glass
sf.frame = orig_frame
sf.draw_popup = orig_draw
sf.center_in_popup = orig_center
sf.fill_cut = orig_fill

print('test_sf_290 ok')
