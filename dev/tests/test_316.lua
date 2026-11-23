-- 0.1.316：上から下のグラデーションが実際の頭上の文字に効く（実機の文字の箱は gradient を読み返さない）。
-- フォント選びの行は DISPLAY に移した（保存のキー marks.label_font はそのまま）。
require('harness')
local settings = require('src.core.settings')
local ext = require('src.platform.vanacore_ext')
local app = require('src.app')
eq(app.VERSION, '1.1.324', 'version')

-- 実機に近い箱：知っている名前は set できるが、gradient は読み返しても nil
local KNOWN = { text = true, color = true, background = true, outline = true, stroke = true, stroke_color = true,
    italic = true, font = true, color_codes = true, gradient = true, gradient_from = true, gradient_to = true,
    visible = true, size = true }
local function real_box()
    local store, sets = {}, 0
    local box = setmetatable({}, {
        __index = function (_, k)
            if k == 'set' then return function (_, props)
                for kk in pairs(props) do if not KNOWN[kk] then error('unknown property ' .. kk) end end
                for kk, vv in pairs(props) do store[kk] = vv end
                sets = sets + 1
            end end
            if k == 'gradient' or k == 'gradient_from' or k == 'gradient_to' then return nil end
            return store[k]
        end,
        __newindex = function (_, k, v) if not KNOWN[k] then error('unknown property ' .. k) end store[k] = v end,
    })
    return box, store, function () return sets end
end

ext.native_gradient = nil
local box, store, nsets = real_box()
local slot = { box = box, codes = true }
local M = settings.merge({ marks = { label_grad = true, label_grad_dir = 'down',
    label_color = { 255, 0, 0 }, label_color2 = { 0, 0, 255 } } }).marks
local c1, c2 = settings.text_colors(M, 'label')
local st = settings.label_style(M, 'label')
eq(st.text_dir, 'down', 'style says down')
ext._apply_label_text(slot, 'Ghebi Damomohe', c1, c2, 0.8, st)
eq(ext.native_gradient, true, 'gradient usable although it does not read back')
eq(store.gradient, 'down', 'box got down')
eq(store.gradient_from, '#FF0000FF', 'from = start color')
eq(store.gradient_to, '#0000FFFF', 'to = end color')
eq(store.text, 'Ghebi Damomohe', 'plain text, no color codes')
eq(store.color_codes, false, 'color codes off while the native gradient is used')
-- 次のフレームも同じなら入れ直さない、左から右に戻すと印に戻る
local n = nsets()
ext._apply_label_text(slot, 'Ghebi Damomohe', c1, c2, 0.8, st)
eq(nsets(), n, 'no re-set for the same look')
local st2 = settings.label_style(settings.merge({ marks = { label_grad = true } }).marks, 'label')
ext._apply_label_text(slot, 'Ghebi Damomohe', c1, c2, 0.8, st2)
eq(store.gradient, 'none', 'native gradient off when back to left to right')
eq(store.color_codes, true, 'codes back on')
check(store.text:find('\\cs(', 1, true) ~= nil, 'left to right uses codes as before')

-- 新しく作った箱（作り直し）も上から下
local box2, store2 = real_box()
ext._apply_label_text({ box = box2, codes = true }, '???', c1, c2, 0.8, st)
eq(store2.gradient, 'down', 'a new box also gets down')

-- まとめての set が別の名前で落ちても、gradient だけ渡せれば使える
ext.native_gradient = nil
local box3, store3 = real_box()
KNOWN.stroke_color = nil
ext._apply_label_text({ box = box3, codes = true }, 'AB', c1, c2, 0.8, { text_dir = 'down', stroke = 1, stroke_alpha = 0.5 })
KNOWN.stroke_color = true
eq(ext.native_gradient, true, 'gradient checked on its own')
eq(store3.gradient, 'down', 'down set by the per-key fallback')

-- 前の設定（グラデーションなし・左から右）は今までどおり：gradient も color_codes も渡さない
ext.native_gradient = nil
local box4, store4 = real_box()
local Mold = settings.merge({ marks = { label_grad = true } }).marks
local o1, o2 = settings.text_colors(Mold, 'label')
ext._apply_label_text({ box = box4, codes = true }, 'AB', o1, o2, 0.8, settings.label_style(Mold, 'label'))
eq(store4.gradient, nil, 'no gradient for the old look')
eq(store4.color_codes, nil, 'color codes untouched for the old look')
eq(ext.native_gradient, nil, 'nothing checked for the old look')

-- フォントの行は DISPLAY のまとまりにある（LABEL には無い）
local src = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a')
local a = src:find("id = 'mk_display'", 1, true)
local b = src:find("id = 'mk_position'", 1, true)
local l1 = src:find("id = 'mk_label'", 1, true)
local l2 = src:find("id = 'mk_object'", 1, true)
local f = src:find('\n%s+font_row%(ui, name%)\n')
check(a and b and f and f > a and f < b, 'font row inside DISPLAY')
local f2 = src:find('\n%s+font_row%(ui, name%)\n', f + 1)
eq(f2, nil, 'only one font row')
check(not (f > l1 and f < l2), 'not in LABEL')
-- 保存のキーは同じ。前の選択はそのまま読む
eq(settings.merge({ marks = { label_font = 'Yu Gothic UI' } }).marks.label_font, 'Yu Gothic UI', 'saved font kept')
print('test_316 ok')
