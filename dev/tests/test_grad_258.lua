-- 0.1.258：頭上グラデ板は色の組ごとに小さい一枚を伸ばし、板を先・文字を後、変わらなければ置き直さない
require('harness')
local ext = require('src.platform.vanacore_ext')
local app = require('src.app')

eq(app.VERSION, '1.1.318', 'version')

local qw, qh = ext._quantize_box(80, 18)
eq(qw, 80, '80 already aligned')
eq(qh, 20, '18 ceils to 20')
local qw2, qh2 = ext._quantize_box(81, 19)
eq(qw2, 84, '81 ceils to 84')
eq(qh2, 20, '19 ceils to 20')
local qw3, qh3 = ext._quantize_box(83, 17)
eq(qw3, 84, '83 and 81 share a bucket')
eq(qh3, 20, '17 ceils to 20')

ext.set_addon_dir(TMP .. '/')
local c1, c2 = { 10, 20, 30 }, { 200, 100, 50 }
local p1, sw, sh = ext._gradient_file(c1, c2, 80, 18)
local p2 = ext._gradient_file(c1, c2, 240, 60)
check(p1 ~= nil, 'wrote gradient')
eq(p1, p2, 'same color pair shares one file')
check(not tostring(p1):find('_%d+x%d+%.bmp', 1), 'filename has no size: ' .. tostring(p1))
check(tostring(p1):find('bg_0a141e_c86432.bmp', 1, true) or tostring(p1):lower():find('bg_0a141e_c86432.bmp', 1, true),
    'color-pair name: ' .. tostring(p1))
eq(sw, ext.GRAD_SRC_W, 'src width small')
eq(sh, ext.GRAD_SRC_H, 'src height small')
check(ext.GRAD_SRC_W <= 64 and ext.GRAD_SRC_H <= 16, 'src is a small plate')
local f = assert(io.open(p1, 'rb'))
local raw = f:read('*a'); f:close()
local sz = #raw
local p3 = ext._gradient_file(c1, c2, 1000, 200)
eq(p3, p1, 'large request still same file')
local f2 = assert(io.open(p3, 'rb'))
local raw2 = f2:read('*a'); f2:close()
eq(#raw2, sz, 'did not rewrite a larger bmp')

-- 配置順：板を先、文字を後。2フレーム目は付け直さない
local attaches, updates, detaches, places = {}, {}, {}, {}
_G.vana = {
    world = {
        attach = function (box, index, opts)
            attaches[#attaches + 1] = { box = box, index = index, opts = opts, part = box._part }
        end,
        update = function (box, opts)
            updates[#updates + 1] = { box = box, opts = opts }
        end,
        detach = function (box)
            detaches[#detaches + 1] = box
        end,
        place = function (box, x, y, z, opts)
            places[#places + 1] = { box = box, x = x, y = y, z = z, opts = opts, part = box._part }
        end,
    },
    ui = {
        text = function (opts)
            local box = {
                text = opts.text, size = opts.size,
                width = 80, height = 18,
                visible = opts.visible, _part = 'text',
            }
            function box:set(t)
                for k, v in pairs(t) do self[k] = v end
            end
            return box
        end,
        image = function (opts)
            local box = {
                file = opts.file, width = opts.width, height = opts.height,
                visible = opts.visible, opacity = opts.opacity, layer = opts.layer, _part = 'image',
            }
            function box:set(t)
                for k, v in pairs(t) do self[k] = v end
            end
            return box
        end,
    },
}

eq(ext.attach_available(), true, 'attach available')
local style = { grad = true, color = { 0, 0, 0 }, color2 = { 190, 168, 255 }, alpha = 0.8, stroke = 1, stroke_alpha = 1 }
local item = { index = 11, role = 'talk', scale = 1, label = '完成品のイメージ', no_icon = true, label_style = style, label_bg_alpha = 0.8 }
attaches, updates, detaches = {}, {}, {}
eq(ext.set_name_marks({ item }), true, 'name marks with grad')

local kinds = {}
for _, a in ipairs(attaches) do
    kinds[#kinds + 1] = a.box._part or (a.box.file and 'image' or 'text')
end
-- 板（image）が先、文字（text）が後。印は no_icon で無し
local joined = table.concat(kinds, ',')
check(joined:find('image', 1, true), 'plate attached: ' .. joined)
check(joined:find('text', 1, true), 'text attached: ' .. joined)
local i_img, i_txt
for i, k in ipairs(kinds) do
    if k == 'image' and not i_img then i_img = i end
    if k == 'text' then i_txt = i end
end
check(i_img and i_txt and i_img < i_txt, 'plate before text: ' .. joined)

-- 板は小さいソースを、丸めた箱サイズへ伸ばす
local plate
for _, a in ipairs(attaches) do
    if a.box._part == 'image' then plate = a.box end
end
check(plate ~= nil, 'found plate box')
eq(plate.width, 80, 'stretched width quantized')
eq(plate.height, 20, 'stretched height quantized')
check(plate.file and not tostring(plate.file):find('_%d+x%d+%.bmp', 1), 'plate file has no size suffix')
eq(plate.layer, -1, 'plate layer behind')

local n_att = #attaches
updates, attaches, detaches = {}, {}, {}
eq(ext.set_name_marks({ item }), true, 'second frame unchanged')
eq(#attaches, 0, 'no re-attach when nothing changed')
eq(#updates, 0, 'no update when nothing changed')
eq(#detaches, 0, 'no detach when nothing changed')

-- 大きさが 1px だけ揺れて同じ丸めなら、書き直し・置き直しなし
item = { index = 11, role = 'talk', scale = 1, label = '完成品のイメージ', no_icon = true, label_style = style, label_bg_alpha = 0.8 }
-- 箱の width は make 済みの 80 のまま（公式箱は既にある）。apply_plate も同じ。
updates, attaches = {}, {}
eq(ext.set_name_marks({ item }), true, 'third frame still same')
eq(#attaches, 0, 'still no attach')
eq(#updates, 0, 'still no update')
