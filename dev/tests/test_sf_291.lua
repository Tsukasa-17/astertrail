-- 0.1.291：アストラルのお知らせ。マウスで押せる・高さは自動・スクロールなし・枠と暈は窓の中に一枚
require('fake_env')

-- 実機の Binding をまねる：ImVec2 は表でしか受けない。数値は「省略」＝ (0,0)。
-- ImGui は InvisibleButton の大きさ 0 で check に落ち、当たりが無い（0.1.290 で押せなかった原因）
local imgui = package.loaded['imgui']
local hit_calls, bad_hits = {}, {}
local orig_hit = imgui.InvisibleButton
imgui.InvisibleButton = function (label, size, flags)
    hit_calls[#hit_calls + 1] = label
    local w = type(size) == 'table' and tonumber(size[1] or size.x) or 0
    local h = type(size) == 'table' and tonumber(size[2] or size.y) or 0
    if not (w and h and w > 0 and h > 0) then
        bad_hits[#bad_hits + 1] = tostring(label)
        return false
    end
    return orig_hit(label)
end
-- 窓の大きさ指定と前景の描画リストを記録する
local size_calls, fg_calls = {}, 0
imgui.SetNextWindowSize = function (sz, cond) size_calls[#size_calls + 1] = sz end
imgui.GetForegroundDrawList = function () fg_calls = fg_calls + 1; return imgui.GetWindowDrawList() end

local theme = require('src.ui.theme')
local sf = require('src.ui.sf_style')
local app = require('src.app')
eq(app.VERSION, '1.1.318', 'version')
dofile(ROOT .. '/astertrail.lua')
FAKE.keep_default_look = true
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
frames(1)
local S = app._settings()
S.look = 'sf'; theme.set_look('sf')
S.reduce_motion = true

local qid = app.popup_sample_quest()
check(qid ~= nil, 'sample quest')

local function popup_frame()
    size_calls, fg_calls, hit_calls, bad_hits = {}, 0, {}, {}
    frame()
end

-- --- 受注：ピン留めする をマウスで押すと、選んだ処理が動く ---
app.state.popups = {}
check(app.popup_push('accept', qid), 'accept popup queued')
frames(1)
popup_frame()
check(#hit_calls >= 2, 'pin buttons have hit areas')
eq(#bad_hits, 0, 'every InvisibleButton gets a non-zero {w,h} table (numbers become size 0 on the real binding)')
eq(#size_calls, 0, 'no SetNextWindowSize for the SF popup (it freezes AlwaysAutoResize height)')
local flags
for t, f in pairs(FAKE.begin_flags or {}) do if t:find('astertrail_popup', 1, true) then flags = f end end
check(flags ~= nil, 'popup window begun')
local band = bit and bit.band or function (a, b)
    local r, m = 0, 1
    while a > 0 and b > 0 do
        if a % 2 == 1 and b % 2 == 1 then r = r + m end
        a, b, m = math.floor(a / 2), math.floor(b / 2), m * 2
    end
    return r
end
for _, k in ipairs({ 'NoTitleBar', 'NoScrollbar', 'NoScrollWithMouse', 'NoBackground', 'AlwaysAutoResize' }) do
    local v = theme.C('ImGuiWindowFlags_' .. k)
    check(flags and band(flags, v) ~= 0, 'popup flag ' .. k)
end
local mouse = theme.C('ImGuiWindowFlags_NoMouseInputs')
check(flags and band(flags, mouse) == 0, 'popup takes mouse input')

local orig_choose = app.popup_choose
local yes_calls = 0
app.popup_choose = function (pin) yes_calls = yes_calls + 1; return orig_choose(pin) end
FAKE.clicks['##pin_yes'] = true
frame()
FAKE.clicks['##pin_yes'] = nil
app.popup_choose = orig_choose
check(yes_calls >= 1, 'click handler fires for ピン留めする')
check(app.state.popups[1] == nil or app.state.popups[1].closing_at ~= nil, 'mouse click on ピン留めする closes the popup')
frames(1)
eq(#app.state.popups, 0, 'popup gone after choosing')

-- --- しない も押せる ---
app.state.popups = { { kind = 'accept', quest = qid } }
frames(1)
popup_frame()
check(labeled('##pin_no'), 'しない is drawn')
eq(#bad_hits, 0, 'しない hit area has a size')
local no_calls = 0
app.popup_choose = function (pin) no_calls = no_calls + 1; eq(pin, false, 'しない passes false'); return orig_choose(pin) end
FAKE.clicks['##pin_no'] = true
frame()
FAKE.clicks['##pin_no'] = nil
app.popup_choose = orig_choose
check(no_calls >= 1, 'click handler fires for しない')
frames(1)
eq(#app.state.popups, 0, 'mouse click on しない closes the popup')

-- --- 完了：閉じる も押せる（クリックの処理が呼ばれる）---
app.state.popups = {}
local calls = 0
app.popup_choose = function (pin) calls = calls + 1; return orig_choose(pin) end
app.state.popups[1] = { kind = 'complete', quest = qid, next = nil }
frames(1)
popup_frame()
eq(#bad_hits, 0, 'close button hit area has a size')
FAKE.clicks['##dismiss'] = true
frame()
FAKE.clicks['##dismiss'] = nil
check(calls >= 1, 'click handler fires for 閉じる')
app.popup_choose = orig_choose
frames(1)

-- --- 枠：窓から暈の幅だけ内側、拡大縮小しても窓の外に出ない ---
local g = sf.POPUP_GLOW
check(g and g >= 6, 'glow margin')
local x1, y1, x2, y2 = sf.popup_frame_rect(100, 100, sf.popup_outer_w(), 300, 1)
eq(x1, 100 + g, 'frame left inset by glow'); eq(y1, 100 + g, 'frame top inset by glow')
eq(x2, 100 + sf.popup_outer_w() - g, 'frame right inset by glow'); eq(y2, 400 - g, 'frame bottom inset by glow')
local px, py = sf.popup_pad()
-- sf.draw_popup は前景の描画リストを使わず、窓の描画リストに窓の矩形のクリップで描く
do
    local used_fg, clip = false, nil
    local wdl = setmetatable({
        PushClipRect = function (_, a, b) clip = { a[1], a[2], b[1], b[2] } end,
    }, { __index = function () return function () end end })
    local fake = {
        GetWindowDrawList = function () return wdl end,
        GetForegroundDrawList = function () used_fg = true; return wdl end,
        GetWindowPos = function () return 300, 200 end,
        GetWindowSize = function () return sf.popup_outer_w(), 260 end,
        GetTime = function () return 0 end,
    }
    local fx1, fy1, fx2, fy2 = sf.draw_popup(fake, 'accept', { alpha = 1, scale = 1 })
    check(not used_fg, 'draw_popup does not touch the foreground draw list')
    check(clip and clip[1] == 300 and clip[2] == 200 and clip[3] == 300 + sf.popup_outer_w() and clip[4] == 460,
        'frame and glow clip to the popup window rect')
    eq(fx1, 300 + g, 'drawn frame is inset by the glow margin')
end
eq(sf.popup_outer_w(), sf.POPUP_INNER_W + px * 2, 'outer width = inner + padding (incl. glow)')
check(px - g >= 20 and py - g >= 16, 'text padding inside the frame')
local a1, b1, a2, b2 = sf.popup_frame_rect(100, 100, 600, 300, 1.2)
check(a1 >= 100 + g - 0.01 and a2 <= 700 - g + 0.01, 'scale > 1 is clamped inside the window')

-- --- ソース：クラシックの金ボタン・ガラスはアストラルで描かない ---
local nsf = io.open(ROOT .. '/src/ui/notices_sf.lua', 'r'):read('*a')
check(nsf:find('W.astral_popup_button', 1, true) ~= nil, 'SF popup uses the Astral button')
check(not nsf:find('W.popup_button(', 1, true), 'SF popup does not use the classic gold button')
local wdg = io.open(ROOT .. '/src/ui/widgets.lua', 'r'):read('*a')
check(not wdg:find('InvisibleButton, bid, bw, bh', 1, true), 'no numeric-size InvisibleButton call')
local i_ab = wdg:find('function W.astral_popup_button', 1, true)
local ab = wdg:sub(i_ab, wdg:find('\nend\n', i_ab, true))
check(not ab:find('draw_popup_button', 1, true), 'Astral button never draws the classic chrome')
local sfs = io.open(ROOT .. '/src/ui/sf_style.lua', 'r'):read('*a')
local i_dp = sfs:find('function sf.draw_popup(', 1, true)
local dp = sfs:sub(i_dp, sfs:find('\nend\n', i_dp, true))
check(not dp:find('GetForegroundDrawList', 1, true), 'SF popup frame/glow is not drawn on the foreground list')

-- --- クラシックのお知らせボタンも押せる（同じ当たり）---
S.look = 'classic'; theme.set_look('classic')
app.state.popups = {}
app.state.popups[1] = { kind = 'complete', quest = qid, next = nil }
frames(1)
popup_frame()
eq(#bad_hits, 0, 'classic popup buttons also get a {w,h} table')
FAKE.clicks['##dismiss'] = true
frame()
FAKE.clicks['##dismiss'] = nil
frames(1)
eq(#app.state.popups, 0, 'classic 閉じる works with the mouse')
