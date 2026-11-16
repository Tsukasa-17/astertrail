-- 0.1.45〜46: アイコンの位置の調整を、調べるオブジェクトとそのほかで分ける。二つめの組はクエスト名
require('fake_env')
local settings = require('src.core.settings')
-- 古い保存：アイコンの値は両方へ。クエスト名は 0 から。古い名前の値は捨てる
local m = settings.merge({ marks = { mark_dx = 10, mark_dy = -6, name_dx = 4, name_dy = 2 } })
eq(m.marks.obj_mark_dx, 10, 'migrated obj mark dx'); eq(m.marks.obj_mark_dy, -6, 'migrated obj mark dy')
eq(m.marks.mark_dx, 10, 'other kept'); eq(m.marks.mark_dy, -6, 'other kept y')
for _, k in ipairs({ 'obj_label_dx', 'obj_label_dy', 'label_dx', 'label_dy' }) do eq(m.marks[k], 0, k .. ' starts at 0') end
eq(m.marks.name_dx, nil, 'old name offset dropped'); eq(m.marks.obj_name_dx, nil, 'old obj name dropped')
-- 0.1.45 の保存（obj_name あり）でも、クエスト名は 0 から
local m45 = settings.merge({ marks = { obj_mark_dx = 4, obj_name_dx = 30, obj_name_dy = 30 } })
eq(m45.marks.obj_mark_dx, 4, '0.1.45 obj icon kept'); eq(m45.marks.obj_label_dx, 0, 'quest name 0')
-- 保存済みの値はそのまま（範囲外は丸める）
local m2 = settings.merge({ marks = { mark_dx = 10, obj_mark_dx = -20, obj_label_dy = 999, label_dx = -6 } })
eq(m2.marks.obj_mark_dx, -20, 'own obj value'); eq(m2.marks.obj_label_dy, 256, 'clamped'); eq(m2.marks.label_dx, -6, 'other label kept')
eq(settings.defaults().marks.obj_mark_dx, 0, 'default 0')
-- 役割で選ぶ。名前はアイコンといっしょ、クエスト名は別
local M = { mark_dx = 1, label_dx = 3, obj_mark_dx = 2, obj_label_dy = 4 }
local o = settings.offsets_for(M, 'examine')
eq(o.mark_dx, 2, 'examine uses obj'); eq(o.name_dx, 2, 'name with icon'); eq(o.label_dy, 4, 'examine quest name'); eq(o.label_dx, 0, 'no leak')
for _, r in ipairs({ 'talk', 'hunt', 'guard' }) do
    local p = settings.offsets_for(M, r)
    eq(p.mark_dx, 1, r .. ' uses other'); eq(p.label_dx, 3, r .. ' quest name')
end

-- 設定の アイコン タブに見出し二つと、8 本のスライダー
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
FAKE.texts = {}; FAKE.labels = {}
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('marks'); frame(); frame()
local function seen(pat)
    for _, x in ipairs(FAKE.texts) do if x:find(pat, 1, true) then return true end end
    for _, x in ipairs(FAKE.labels) do if x:find(pat, 1, true) then return true end end
    return false
end
check(seen('位置の調整：調べるオブジェクト'), 'object heading')
check(seen('位置の調整：そのほか'), 'other heading')
check(seen('クエスト名の位置（左右）'), 'quest name slider label')
check(seen('アイコンの位置（上下）'), 'object row slider label')
check(not seen('アイコンと名前の位置'), 'old row label gone (0.1.58)')
local focus = require('src.ui.focus')
for _, k in ipairs({ 'obj_mark_dx', 'obj_mark_dy', 'obj_label_dx', 'obj_label_dy', 'mark_dx', 'mark_dy', 'label_dx', 'label_dy' }) do
    focus.set('settings', 'marks_' .. k); frame()
    eq(focus.current('settings'), 'marks_' .. k, 'slider ' .. k)
end
-- 右で obj だけ動く
S.marks.obj_mark_dx, S.marks.mark_dx = 0, 0
focus.set('settings', 'marks_obj_mark_dx'); frame()
press(0xCD); frame(); frame()
check(S.marks.obj_mark_dx > 0, 'obj slider moved')
eq(S.marks.mark_dx, 0, 'other untouched')
-- 位置を元に戻す：両方 0
S.marks.mark_dx, S.marks.obj_label_dy, S.marks.label_dx = 8, -8, 6
require('src.ui.settings_ui')
FAKE.clicks['##marks_pos_reset'] = true; frame(); frame()
eq(S.marks.mark_dx, 0, 'reset other'); eq(S.marks.obj_label_dy, 0, 'reset obj'); eq(S.marks.label_dx, 0, 'reset other label'); eq(S.marks.obj_mark_dx, 0, 'reset obj mark')
-- 0.1.46：設定のタブはいつも見える（中身だけが子の窓の中で動く）。本と設定の窓そのものは動かない
local order = {}
local imgui = package.loaded['imgui']
local ob, obtn, obeg = rawget(imgui, 'BeginChild'), rawget(imgui, 'Button'), rawget(imgui, 'Begin')
local flags_of = {}
rawset(imgui, 'BeginChild', function (id, ...) order[#order + 1] = 'child:' .. tostring(id); return true end)
rawset(imgui, 'Button', function (label, ...) order[#order + 1] = 'btn:' .. tostring(label); return obtn(label, ...) end)
rawset(imgui, 'Begin', function (title, open, flags) flags_of[title] = flags; return obeg(title, open, flags) end)
frame()
rawset(imgui, 'BeginChild', ob); rawset(imgui, 'Button', obtn); rawset(imgui, 'Begin', obeg)
local i_tab, i_child, i_close
for i, x in ipairs(order) do
    if x:find('##st_marks', 1, true) then i_tab = i end
    if x == 'child:##astertrail_settings_body' then i_child = i end
    if x:find('##close', 1, true) then i_close = i end
end
check(i_tab and i_child and i_close, 'tabs, body, close')
check(i_tab < i_child and i_child < i_close, 'tabs above the scrolling body, close below')
local theme = require('src.ui.theme')
local NS = theme.C('ImGuiWindowFlags_NoScrollWithMouse')
for title, f in pairs(flags_of) do
    if title:find('astertrail_settings', 1, true) then check(math.floor(f / NS) % 2 == 1, 'settings window itself does not scroll') end
end
print('test_obj_offsets ok')
