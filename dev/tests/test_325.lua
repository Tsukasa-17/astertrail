-- 0.1.325：クエスト名とオブジェクト名のフォントを別々に。背景グラデーションの向き。
require('harness')
local settings = require('src.core.settings')
local ext = require('src.platform.vanacore_ext')
local app = require('src.app')
eq(app.VERSION, '1.1.327', 'version')

local d = settings.defaults()
eq(d.marks.under_font, '', 'default under font is the usual one')
eq(d.marks.label_bg_grad_dir, 'across', 'default bg dir label')
eq(d.marks.under_bg_grad_dir, 'across', 'default bg dir under')

-- 古い保存（label_font だけ）：両方へ引き継ぐ（見た目が変わらない）
local old = settings.merge({ marks = { label_font = 'Yu Gothic UI' } })
eq(old.marks.label_font, 'Yu Gothic UI', 'old label font kept')
eq(old.marks.under_font, 'Yu Gothic UI', 'old label font inherited by object names')
eq(old.marks.label_bg_grad_dir, 'across', 'old save keeps bg left to right')

-- 新しい保存：別々の値を保つ
local split = settings.merge({ marks = { label_font = 'Meiryo', under_font = 'Yu Gothic UI' } })
eq(split.marks.label_font, 'Meiryo', 'quest font kept')
eq(split.marks.under_font, 'Yu Gothic UI', 'object font kept')

-- under_font が空文字なら、空のまま（「いつもの」に戻した）。label_font は引き継がない
local emptied = settings.merge({ marks = { label_font = 'Meiryo', under_font = '' } })
eq(emptied.marks.label_font, 'Meiryo', 'quest font still set')
eq(emptied.marks.under_font, '', 'explicit empty object font is kept')

local st_l = settings.label_style(split.marks, 'label')
local st_u = settings.label_style(split.marks, 'under')
eq(st_l.font, 'Meiryo', 'style quest font')
eq(st_u.font, 'Yu Gothic UI', 'style object font')
eq(st_l.bg_dir, 'across', 'style default bg dir')

local bg = settings.merge({ marks = { label_bg_grad = true, label_bg_grad_dir = 'down',
    under_bg_grad_dir = 'sideways' } }).marks
eq(bg.label_bg_grad_dir, 'down', 'down kept for quest bg')
eq(bg.under_bg_grad_dir, 'across', 'unknown bg dir')
eq(settings.label_style(bg, 'label').bg_dir, 'down', 'style carries bg dir')

-- 背景グラデの BMP：左から右は今までと同じファイル名、上から下は別
ext.set_addon_dir(TMP .. '/')
local c1, c2 = { 10, 20, 30 }, { 200, 10, 5 }
local p_h, sw_h, sh_h = ext._gradient_file(c1, c2, 80, 18)
local p_h2 = ext._gradient_file(c1, c2, 80, 18, 'across')
check(p_h ~= nil, 'horizontal gradient file')
eq(p_h, p_h2, 'nil dir is left to right, same file as across')
eq(sw_h, ext.GRAD_SRC_W, 'horizontal src width')
eq(sh_h, ext.GRAD_SRC_H, 'horizontal src height')

local p_v, sw_v, sh_v = ext._gradient_file(c1, c2, 80, 18, 'down')
check(p_v ~= nil, 'vertical gradient file')
check(p_v ~= p_h, 'vertical is a different file')
eq(sw_v, ext.GRAD_SRC_H, 'vertical src width swapped')
eq(sh_v, ext.GRAD_SRC_W, 'vertical src height swapped')
check(p_v:find('v_', 1, true) ~= nil, 'vertical file name has v_')
check(p_h:find('v_', 1, true) == nil, 'horizontal file name has no v_')

-- BMP の端の色：横は左が始め、縦は上が始め（BMP は下が先の行）
local function px_corners(path, w, h)
    local f = assert(io.open(path, 'rb'))
    local raw = f:read('*a'); f:close()
    local function at(x, y)
        -- y=0 が一番下の行
        local row_raw = w * 3
        local pad = (4 - (row_raw % 4)) % 4
        local row = row_raw + pad
        local off = 54 + y * row + x * 3
        local b, g, r = raw:byte(off + 1, off + 3)
        return { r, g, b }
    end
    return at(0, h - 1), at(w - 1, h - 1), at(0, 0)
end
local tl, tr, bl = px_corners(p_h, sw_h, sh_h)
eq(tl[1], 10, 'H top-left R is start')
eq(tr[1], 200, 'H top-right R is end')
eq(bl[1], 10, 'H bottom-left R is start')
tl, tr, bl = px_corners(p_v, sw_v, sh_v)
eq(tl[1], 10, 'V top-left R is start')
eq(tr[1], 10, 'V top-right R is start')
eq(bl[1], 200, 'V bottom-left R is end')

-- 設定画面：2 つのフォント行、背景グラデの向き
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local theme = require('src.ui.theme')
local sui = require('src.ui.settings_ui')
sui._reset_font_choices()
local S = app._settings()
S.look = 'sf'; theme.set_look('sf')
app.close_all(); frame()
app.open_window('settings'); frame(); frame()
sui.select_tab('marks'); frame(); frame()
check(texted('クエスト名のフォント') or labeled('クエスト名のフォント'), 'quest font row')
check(texted('オブジェクト名のフォント') or labeled('オブジェクト名のフォント'), 'object font row')
check(not texted('クエスト名・オブジェクト名のフォント') and not labeled('クエスト名・オブジェクト名のフォント'),
    'old combined font label is gone')

S.marks.label_bg_grad = false; frame(); frame()
-- 文字グラデがオフなら、向きの行は背景がオンのときだけ
S.marks.label_grad = false; frame(); frame()
check(not texted('グラデーションの向き') and not labeled('グラデーションの向き'), 'no dir row when both grads off')
S.marks.label_bg_grad = true; frame(); frame()
check(texted('グラデーションの向き') or labeled('グラデーションの向き'), 'bg dir row')
check(texted('左から右') or labeled('左から右'), 'bg dir default across')
FAKE.clicks['##marks_label_bg_grad_dir'] = true; frame(); frame()
eq(S.marks.label_bg_grad_dir, 'down', 'switched bg dir to down')
FAKE.clicks['##marks_label_all_reset'] = true; frame(); frame()
eq(S.marks.label_bg_grad_dir, 'across', 'reset bg dir')
eq(S.marks.label_bg_grad, false, 'reset bg grad')

-- ソース：0.1.326〜 font_row は color_main（LABEL／OBJECT）。DISPLAY には無い
local src = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a')
local a = src:find("id = 'mk_display'", 1, true)
local b = src:find("id = 'mk_position'", 1, true)
local cm = src:find('local function color_main', 1, true)
local cd = src:find('local function color_detail', 1, true)
local f = src:find('font_row(ui, name, which)', cm, true)
check(cm and cd and f and f > cm and f < cd, 'font_row is inside color_main')
check(a and b and not src:sub(a, b):find('font_row', 1, true), 'no font_row in DISPLAY')
app.close_all(); frame()
print('test_325 ok')
