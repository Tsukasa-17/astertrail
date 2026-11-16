require('harness')
local ext = require('src.platform.vanacore_ext')
local marks_ui = require('src.ui.marks')

-- VanaCore が無いときは何も返さない
eq(ext.available(), false, 'no vana')
eq(ext.entity_screen(1), nil, 'no entity without vana')
eq(ext.world_screen(1, 2, 3), nil, 'no world without vana')
eq(ext.ui_screen(), nil, 'no ui without vana')

-- 公式どおりの呼び出しだけを使う
local name_at_calls = {}
local to_screen_calls = {}
local entity_calls = {}

_G.vana = {
    world = {
        name_at = function (index)
            name_at_calls[#name_at_calls + 1] = { index = index, n = select('#', index) }
            -- 世界座標で呼ばれたら分かるように、数値が3つ来たら記録する（来ないはず）
            if select('#', index) ~= 1 or type(index) ~= 'number' then
                name_at_calls[#name_at_calls].bad = true
            end
            if index == 7 then return 120, 80, 110 end
            return nil
        end,
        to_screen = function (x, y, z)
            to_screen_calls[#to_screen_calls + 1] = { x = x, y = y, z = z }
            return 10, 20, 5
        end,
    },
    game = {
        entity = function (index)
            entity_calls[#entity_calls + 1] = index
            return { name_x = 200, name_top = 60, name_bottom = 95, name = 'Aquillina' }
        end,
    },
    ui = {
        screen = function () return 3440, 1440 end,
    },
}

eq(ext.available(), true, 'vana present')

local x, top, how, bottom = ext.entity_screen(7)
eq(x, 120, 'name_at x')
eq(top, 80, 'name_at top')
eq(how, 'name_at', 'how name_at')
eq(bottom, 110, 'name_at bottom')
eq(#name_at_calls, 1, 'name_at once')
eq(name_at_calls[1].index, 7, 'name_at index')
eq(name_at_calls[1].n, 1, 'name_at one arg')
check(not name_at_calls[1].bad, 'name_at not given world coords')
eq(#entity_calls, 0, 'entity unused when name_at works')

-- name_at が nil のときは entity(index) の name_x / name_top
local x2, top2, how2, bottom2 = ext.entity_screen(8)
eq(x2, 200, 'name_x fallback')
eq(top2, 60, 'name_top fallback')
eq(how2, 'name_x', 'how name_x')
eq(bottom2, 95, 'name_bottom')
eq(#entity_calls, 1, 'entity used as fallback')
eq(entity_calls[1], 8, 'entity called with index')

-- world_screen は to_screen(x, y, z) だけ。name_at は呼ばない
local n_name = #name_at_calls
local sx, sy, whow, dist = ext.world_screen(1.5, 2.5, 3.5)
eq(sx, 10, 'to_screen x')
eq(sy, 20, 'to_screen y')
eq(whow, 'to_screen', 'how to_screen')
eq(dist, 5, 'distance')
eq(#to_screen_calls, 1, 'to_screen once')
eq(to_screen_calls[1].x, 1.5, 'to_screen arg x')
eq(to_screen_calls[1].y, 2.5, 'to_screen arg y')
eq(to_screen_calls[1].z, 3.5, 'to_screen arg z')
eq(#name_at_calls, n_name, 'world_screen does not call name_at')

-- 欠けた引数は呼ばない
eq(ext.world_screen(1, 2, nil), nil, 'missing z')
eq(#to_screen_calls, 1, 'to_screen not called without z')
eq(ext.entity_screen(nil), nil, 'missing index')

local uw, uh = ext.ui_screen()
eq(uw, 3440, 'ui width')
eq(uh, 1440, 'ui height')

-- 印の位置：名前の上端のすぐ上。頭の高さは z から引く（上が小さい）
eq(marks_ui.anchor_y(80, 'name_at', 7), 80 - 7 - 4, 'anchor just over name')
eq(marks_ui.anchor_y(80, 'name_x', 7), 80 - 7 - 4, 'anchor name_x')
eq(marks_ui.anchor_y(80, 'to_screen', 7), 80 - 7 - 8, 'anchor to_screen')
eq(marks_ui.head_z(10, 2), 8, 'head is foot minus height')
eq(marks_ui.head_z(10, nil), 10 - 1.5, 'default height')

-- game.entity がテーブル添え字だけ、という古い呼び方は使わない
_G.vana.world.name_at = nil
_G.vana.game.entity = { [8] = { name_x = 1, name_top = 2 } }
eq(ext.entity_screen(8), nil, 'table-index entity is ignored')



-- 名前に箱を付ける（公式 vana.world.attach）。LSパールと同じ仕組み。
local pictures, attaches, updates, detaches, destroys = {}, {}, {}, {}, {}

_G.vana.ui = _G.vana.ui or {}
_G.vana.ui.image = function (opts)
    local box = {
        file = opts.file, width = opts.width, height = opts.height,
        visible = opts.visible,
    }
    function box:set(t)
        for k, v in pairs(t) do self[k] = v end
    end
    function box:destroy()
        destroys[#destroys + 1] = self
        self.destroyed = true
    end
    pictures[#pictures + 1] = box
    return box
end
_G.vana.world.attach = function (box, index, opts)
    attaches[#attaches + 1] = { box = box, index = index, opts = opts }
    box.att_index = index
end
_G.vana.world.update = function (box, opts)
    updates[#updates + 1] = { box = box, opts = opts }
end
_G.vana.world.detach = function (box)
    detaches[#detaches + 1] = box
end

eq(ext.attach_available(), true, 'attach available')
ext.set_addon_dir('C:/addon/astertrail/')
local f = ext.mark_file('talk')
check(string.find(f, 'talk.png', 1, true), 'talk file name')
check(string.find(f, 'astertrail', 1, true), 'uses addon dir')
check(string.find(f, 'assets', 1, true), 'assets folder')

local n_name = #name_at_calls
eq(ext.set_name_marks({ { index = 7, role = 'talk', scale = 1 } }), true, 'set marks')
eq(#pictures, 1, 'one picture')
eq(#attaches, 1, 'attached once')
eq(attaches[1].index, 7, 'index 7')
eq(attaches[1].opts.side, 'left', 'side left')
eq(attaches[1].opts.x, -4, 'left gap')
eq(attaches[1].opts.walls, true, 'walls')
eq(attaches[1].opts.distance, true, 'follows name size')
eq(attaches[1].opts.y, 0, 'at the name')
eq(pictures[1].visible, true, 'visible')
check(string.find(pictures[1].file or '', 'talk.png', 1, true), 'talk png')
eq(#name_at_calls, n_name, 'attach path does not call name_at')

-- 同じ相手の次のフレーム：指定が同じなら何もしない（0.1.210〜）。変わったら update（公式の安いやり方）。新しい箱は作らない。
eq(ext.set_name_marks({ { index = 7, role = 'talk', scale = 1 } }), true, 'set again')
eq(#attaches, 1, 'no second attach')
eq(#updates, 0, 'same opts: no update call')
eq(ext.set_name_marks({ { index = 7, role = 'talk', scale = 1, mark_dy = 6 } }), true, 'set with a new offset')
eq(#attaches, 1, 'still no second attach')
eq(#updates, 1, 'updated')
eq(#pictures, 1, 'reused picture')

-- 別の相手へ。同じ箱を付け替える（attach し直し。detach は不要）
eq(ext.set_name_marks({ { index = 12, role = 'talk', scale = 1 } }), true, 'switch target')
eq(#attaches, 2, 'attached to new index')
eq(attaches[2].index, 12, 'index 12')
eq(#pictures, 1, 'still one box')

-- 対象が消えたら外して隠す
eq(ext.set_name_marks({}), true, 'clear list')
eq(#detaches, 1, 'detached when empty')
eq(pictures[1].visible, false, 'hidden')

-- 再利用、役割が変わったら画像を差し替える
eq(ext.set_name_marks({ { index = 3, role = 'hunt', scale = 1 } }), true, 'hunt mark')
eq(#pictures, 1, 'reused after empty')
eq(#attaches, 3, 'attached hunt')
check(string.find(pictures[1].file or '', 'hunt.png', 1, true), 'hunt png')

ext.clear_name_marks()
eq(#destroys, 1, 'destroyed on clear')
eq(ext.set_name_marks(nil), true, 'nil items ok')

-- 公式の文字コード変換（チャットは Shift-JIS）
_G.vana.encoding = {
    to_shift_jis = function (s) return 'SJIS:' .. s end,
}
eq(ext.to_shift_jis('頭上'), 'SJIS:頭上', 'uses official to_shift_jis')
_G.vana.encoding = nil
eq(ext.to_shift_jis('頭上'), '頭上', 'passthrough without encoding')

-- 公式に picture は無い。image も rect も無いときは付けられない
_G.vana.ui.image = nil
_G.vana.ui.rect = nil
_G.vana.ui.picture = function () return {} end
eq(ext.attach_available(), false, 'picture is not official')

-- image が無くても rect で名前に付けられる
local rects = {}
_G.vana.ui.picture = nil
_G.vana.ui.rect = function (opts)
    local box = {
        color = opts.color, radius = opts.radius,
        width = opts.width, height = opts.height, visible = opts.visible,
    }
    function box:set(t)
        for k, v in pairs(t) do self[k] = v end
    end
    function box:destroy() end
    rects[#rects + 1] = box
    return box
end
eq(ext.attach_available(), true, 'rect is enough')
eq(ext.set_name_marks({ { index = 1, role = 'talk', scale = 1 } }), true, 'rect mark')
eq(#rects, 1, 'one rect')
eq(rects[1].color, '#B8B2FFFF', 'talk color')
check(rects[1].radius and rects[1].radius >= 10, 'circle-ish for talk')
eq(ext.attach_kind(), 'rect', 'kind is rect')
ext.clear_name_marks()

-- 画像と丸の両方があるときは、用意した PNG を先に使う（この版の表示テスト）
local n_img = 0
_G.vana.ui.image = function (opts)
    n_img = n_img + 1
    local box = { file = opts and opts.file, width = 28, height = 28, visible = true }
    function box:set(t) for k, v in pairs(t) do self[k] = v end end
    function box:destroy() end
    return box
end
local rect_before = #rects
eq(ext.set_name_marks({ { index = 9, role = 'talk', scale = 1 } }), true, 'prefers image')
eq(n_img >= 1, true, 'image used when it works')
eq(#rects, rect_before, 'rect not used when image works')
eq(ext.attach_kind(), 'image', 'prefer image kind')
ext.clear_name_marks()

-- 画像が作れないときは丸に戻す
_G.vana.ui.image = function () return nil end
local rb = #rects
eq(ext.set_name_marks({ { index = 4, role = 'talk', scale = 1 } }), true, 'image fails')
eq(#rects, rb + 1, 'fell back to rect')
eq(ext.attach_kind(), 'rect', 'fallback kind')
ext.clear_name_marks()

-- 名前の左に付ける
_G.vana.ui.image = function (opts)
    local box = { file = opts and opts.file, width = 28, height = 28, visible = true }
    function box:set(t) for k, v in pairs(t) do self[k] = v end end
    function box:destroy() end
    return box
end
attaches, updates, detaches = {}, {}, {}
eq(ext.set_name_marks({ { index = 5, role = 'talk', scale = 1, placement = 'left' } }), true, 'left place')
eq(#attaches, 1, 'left attached')
eq(attaches[1].opts.side, 'left', 'side left')
eq(attaches[1].opts.x, -4, 'left gap')
eq(attaches[1].opts.y, 0, 'left y')
ext.clear_name_marks()

-- クエスト名は名前の上、印は名前の横（PNG）
local texts = {}
_G.vana.ui.text = function (opts)
    local box = {
        text = opts.text, size = opts.size, width = 80, height = 18,
        visible = opts.visible, font = opts.font,
    }
    function box:set(t) for k, v in pairs(t) do self[k] = v end end
    function box:destroy() end
    texts[#texts + 1] = box
    return box
end
local function attach_by_side(list)
    local out = {}
    for _, a in ipairs(list) do
        local side = a.opts and a.opts.side
        if side then
            if not out[side] then out[side] = {} end
            out[side][#out[side] + 1] = a
        end
    end
    return out
end
attaches, updates, detaches = {}, {}, {}
eq(ext.set_name_marks({
    { index = 6, role = 'talk', scale = 1, label = 'カマドに火をつけて' },
}), true, 'label')
eq(#attaches, 2, 'mark and quest name')
local sides = attach_by_side(attaches)
eq(#(sides.left or {}), 1, 'mark on the left')
eq(#(sides.above or {}), 1, 'quest name above')
eq(sides.left[1].opts.x, -4, 'mark gap')
eq(sides.above[1].opts.x, 0, 'quest name centered')
eq(sides.above[1].opts.y, -2, 'quest name a little above')
eq(#texts, 1, 'one text box')
eq(texts[1].text, 'カマドに火をつけて', 'quest name only, no glyph')
eq(texts[1].font, 'Yu Gothic UI', 'fallback font without menu setting')
check(sides.left[1].box.file and sides.left[1].box.file:find('talk.png', 1, true), 'png mark beside the name')
updates = {}
eq(ext.set_name_marks({
    { index = 6, role = 'talk', scale = 1, label = 'カマドに火をつけて' },
}), true, 'label again')
eq(#attaches, 2, 'no new attach')
eq(#updates, 0, 'nothing changed: no update calls (0.1.210)')

-- クエスト名を外したら文字の箱は外し、印は残す
attaches, updates, detaches = {}, {}, {}
eq(ext.set_name_marks({ { index = 6, role = 'talk', scale = 1 } }), true, 'hide quest name')
eq(#detaches, 1, 'label detached')
eq(#attaches, 0, 'mark already attached')
eq(#updates, 0, 'mark kept as is (same opts, 0.1.210)')
ext.clear_name_marks()

-- 同じ人の2件：印は横に重ね、クエスト名は上に重ね
attaches, updates, detaches, texts = {}, {}, {}, {}
eq(ext.set_name_marks({
    { index = 8, role = 'talk', scale = 1, label = 'カマドに火をつけて', layer = 0 },
    { index = 8, role = 'hunt', scale = 1, label = 'ダングルフの奇岩', layer = 1 },
}), true, 'two layers')
eq(#attaches, 4, 'two marks and two names')
eq(#texts, 2, 'two text boxes')
eq(texts[1].text, 'カマドに火をつけて', 'first quest')
eq(texts[2].text, 'ダングルフの奇岩', 'second quest')
local sides = attach_by_side(attaches)
eq(#(sides.left or {}), 2, 'two marks on the left')
eq(#(sides.above or {}), 2, 'two names above')
eq(sides.left[1].opts.x, -4, 'mark x')
eq(sides.above[1].opts.x, 0, 'name x')
check(sides.left[2].opts.y < sides.left[1].opts.y, 'second mark is higher')
check(sides.above[2].opts.y < sides.above[1].opts.y, 'second name is higher')
eq(sides.above[1].opts.y, -2, 'first name at base y')
-- 1件に戻したら上の層は外す
attaches, updates, detaches = {}, {}, {}
eq(ext.set_name_marks({
    { index = 8, role = 'talk', scale = 1, label = 'カマドに火をつけて', layer = 0 },
}), true, 'back to one')
eq(#detaches, 2, 'upper mark and name detached')
ext.clear_name_marks()

-- マークのみでも、複数は上に重ねる
attaches, updates, detaches = {}, {}, {}
eq(ext.set_name_marks({
    { index = 11, role = 'talk', scale = 1, layer = 0 },
    { index = 11, role = 'hunt', scale = 1, layer = 1 },
}), true, 'stack marks only')
eq(#attaches, 2, 'two marks')
eq(attaches[1].opts.side, 'left', 'mark beside the name')
eq(attaches[1].opts.x, -4, 'mark gap')
eq(attaches[2].opts.x, -4, 'upper mark gap')
check(attaches[2].opts.y < attaches[1].opts.y, 'upper mark is higher')
ext.clear_name_marks()

-- 0.1.59：「アイコンを表示する」がオフ（no_icon）なら、印は付けずクエスト名だけ
attaches, updates, detaches, texts = {}, {}, {}, {}
local n_pics = #pictures
eq(ext.set_name_marks({ { index = 13, role = 'talk', scale = 1, label = 'Q1', no_icon = true } }), true, 'no icon label')
eq(#attaches, 1, 'only the quest name attached')
eq(#texts, 1, 'one text box'); eq(texts[1].text, 'Q1', 'quest name')
for _, a in ipairs(attaches) do check(not (a.box.file and a.box.file:find('.png', 1, true)), 'no icon picture attached') end
-- 前のフレームの印は外す
eq(ext.set_name_marks({ { index = 13, role = 'talk', scale = 1, label = 'Q1' } }), true, 'icon back')
local had_png = false
for _, a in ipairs(attaches) do if a.box.file and a.box.file:find('.png', 1, true) then had_png = true end end
check(had_png, 'icon attached again')
detaches = {}
eq(ext.set_name_marks({ { index = 13, role = 'talk', scale = 1, label = 'Q1', no_icon = true } }), true, 'icon off again')
eq(#detaches, 1, 'icon detached')
ext.clear_name_marks()


-- 公式 vana.world.place：本体の世界座標に箱を置く
local world_pics, places, place_updates = {}, {}, {}
_G.vana.ui.image = function (opts)
    local box = {
        file = opts and opts.file, width = opts and opts.width, height = opts and opts.height,
        visible = opts and opts.visible,
    }
    function box:set(t)
        for k, v in pairs(t) do self[k] = v end
    end
    function box:destroy()
        destroys[#destroys + 1] = self
        self.destroyed = true
    end
    world_pics[#world_pics + 1] = box
    return box
end
_G.vana.world.place = function (box, x, y, z, opts)
    places[#places + 1] = { box = box, x = x, y = y, z = z, opts = opts }
    box.placed_at = { x, y, z }
end
local old_update = _G.vana.world.update
_G.vana.world.update = function (box, opts)
    old_update(box, opts)
    if opts and opts.at then
        place_updates[#place_updates + 1] = { box = box, opts = opts }
    end
end

eq(ext.place_available(), true, 'place available')
ext.clear_name_marks()
ext.clear_world_marks()
-- クロージャが参照する表は中を空にする（新しい表に差し替えない）
for i = #world_pics, 1, -1 do world_pics[i] = nil end
for i = #places, 1, -1 do places[i] = nil end
for i = #place_updates, 1, -1 do place_updates[i] = nil end
for i = #attaches, 1, -1 do attaches[i] = nil end
for i = #detaches, 1, -1 do detaches[i] = nil end
for i = #destroys, 1, -1 do destroys[i] = nil end

eq(ext.set_world_marks({
    { x = 10, y = 20, z = 3, up = 2, role = 'examine', scale = 1, key = 11, index = 11 },
}), true, 'set world mark')
eq(#places, 1, 'placed once')
eq(places[1].x, 10, 'place x')
eq(places[1].y, 20, 'place y')
eq(places[1].z, 3, 'place z')
eq(places[1].opts.up, 2, 'place up')
eq(places[1].opts.pivot, 'bottom', 'pivot bottom')
eq(places[1].opts.facing, 'camera', 'facing camera')
eq(places[1].opts.walls, false, 'walls off so the rock does not hide it')
eq(#world_pics, 1, 'one world picture')
eq(world_pics[1].visible, true, 'world mark visible')
check(string.find(world_pics[1].file or '', 'examine.png', 1, true), 'examine png')
eq(#attaches, 0, 'place does not attach to a name')

-- 次のフレームは update（at で位置を変える）。新しい箱は作らない。
eq(ext.set_world_marks({
    { x = 12, y = 22, z = 4, up = 2, role = 'examine', scale = 1, key = 11, index = 11 },
}), true, 'set world again')
eq(#places, 1, 'no second place')
eq(#place_updates, 1, 'updated at')
eq(place_updates[1].opts.at.x, 12, 'update at x')
eq(place_updates[1].opts.at.y, 22, 'update at y')
eq(place_updates[1].opts.at.z, 4, 'update at z')
eq(#world_pics, 1, 'reused world picture')

-- 空にすると外して隠す
local n_det = #detaches
eq(ext.set_world_marks({}), true, 'clear world list')
eq(#detaches, n_det + 1, 'detached world box')
eq(world_pics[1].visible, false, 'world mark hidden')

-- 0.1.59：no_icon なら印の絵は置かず、名前だけ
do
    local np = #places
    local npic = #world_pics
    eq(ext.set_world_marks({
        { x = 10, y = 20, z = 3, up = 2, role = 'examine', scale = 1, key = 31, index = 31, under = '???', no_icon = true },
    }), true, 'no icon world mark')
    local png = 0
    for i = np + 1, #places do
        local f = places[i].box.file
        if f and f:find('.png', 1, true) then png = png + 1 end
    end
    eq(png, 0, 'no icon picture placed')
    check(#places > np, 'name placed')
    ext.set_world_marks({})
end

-- 名前の印と本体の印は別の箱。互いに消さない。
ext.clear_name_marks()
ext.clear_world_marks()
for i = #world_pics, 1, -1 do world_pics[i] = nil end
for i = #places, 1, -1 do places[i] = nil end
for i = #place_updates, 1, -1 do place_updates[i] = nil end
for i = #attaches, 1, -1 do attaches[i] = nil end
for i = #detaches, 1, -1 do detaches[i] = nil end
for i = #destroys, 1, -1 do destroys[i] = nil end

eq(ext.set_name_marks({ { index = 7, role = 'talk', scale = 1 } }), true, 'name mark with world')
eq(ext.set_world_marks({
    { x = 1, y = 2, z = 3, up = 1.5, role = 'examine', scale = 1, key = 11 },
}), true, 'world mark with name')
eq(#attaches, 1, 'name attached')
eq(#places, 1, 'world placed')
eq(#world_pics, 2, 'two separate boxes')
-- 名前だけ空にしても本体は残る
eq(ext.set_name_marks({}), true, 'clear names only')
eq(#places, 1, 'world place untouched')
eq(world_pics[2].visible, true, 'world mark still visible')
eq(ext.set_world_marks({}), true, 'clear world only')
eq(world_pics[2].visible, false, 'world hidden')

-- 位置が無いときは置かない
eq(ext.set_world_marks({ { role = 'examine', key = 99 } }), false, 'no position')
eq(ext.place_error(), 'no_pos', 'no_pos error')

-- 高さが小さすぎるときは最低 0.8
for i = #places, 1, -1 do places[i] = nil end
ext.clear_world_marks()
eq(ext.set_world_marks({
    { x = 1, y = 2, z = 0, up = 0.1, role = 'examine', scale = 1, key = 1 },
}), true, 'tiny height')
eq(places[1].opts.up, 0.8, 'up floored to 0.8')

local n_des = #destroys
ext.clear_world_marks()
check(n_des >= 1 or #destroys >= 1, 'world boxes destroyed on clear')

-- game_entity / entity_count
_G.vana.game.entity_count = function () return 4 end
_G.vana.game.entity = function (index)
    if index == 2 then
        return { name = '???', x = 8, y = 9, z = 1, model_size = 1.2, spawn_flags = 2 }
    end
    return nil
end
local e = ext.game_entity(2)
eq(e.x, 8, 'game_entity x')
eq(e.name, '???', 'game_entity name')
eq(ext.game_entity(3), nil, 'missing entity')
eq(ext.entity_count(), 4, 'entity_count')
eq(ext.game_entity(nil), nil, 'nil index')


-- game_target（公式 vana.game.target）
_G.vana.game.target = function ()
    return { index = 2, id = 99, active = true }
end
local tgt = ext.game_target()
eq(tgt.index, 2, 'game_target index')
eq(tgt.active, true, 'game_target active')
_G.vana.game.target = function ()
    return { index = 0, id = 0, active = false }
end
eq(ext.game_target().active, false, 'game_target none')
_G.vana.game.target = nil
eq(ext.game_target(), nil, 'game_target missing api')

-- 本体の印にクエスト名。上に印（PNG）、その下にクエスト名。
for i = #places, 1, -1 do places[i] = nil end
for i = #place_updates, 1, -1 do place_updates[i] = nil end
for i = #texts, 1, -1 do texts[i] = nil end
for i = #world_pics, 1, -1 do world_pics[i] = nil end
ext.clear_world_marks()
local function world_parts(list)
    local mark, label, under
    for _, p in ipairs(list) do
        local box = p.box or {}
        if box.file then
            mark = p
        elseif box.text == '???' then
            under = p
        elseif type(box.text) == 'string' and box.text ~= '' then
            label = p
        end
    end
    return mark, label, under
end
eq(ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 11,
      label = 'ダングルフの奇岩' },
}), true, 'world mark with quest name')
eq(#places, 2, 'mark and quest name')
eq(places[1].x, 5, 'at body x')
eq(places[1].y, 6, 'at body y')
eq(places[1].z, 1, 'at body z')
eq(places[1].opts.x, 0, 'centered')
eq(places[1].opts.walls, false, 'walls off')
eq(#texts, 1, 'one world text box')
eq(texts[1].text, 'ダングルフの奇岩', 'world quest name')
local wm, wl = world_parts(places)
check(wm and wl, 'mark and name both placed')
check(wm.box.file and wm.box.file:find('examine.png', 1, true), 'png mark')
check(wm.opts.y < wl.opts.y, 'mark is above quest name')
eq(wl.opts.y, 0, 'quest name at base when no ???')
local _, n_placed = ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 11,
      label = 'ダングルフの奇岩' },
})
eq(n_placed, 1, 'placed count is one item')
eq(#places, 2, 'no new place on second frame')
eq(#place_updates, 0, 'same spot: not placed again (0.1.210)')
local _, n_moved = ext.set_world_marks({
    { x = 5.5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 11,
      label = 'ダングルフの奇岩' },
})
eq(n_moved, 1, 'moved: still one item')
eq(#place_updates, 2, 'moved: both updated')
eq(place_updates[1].opts.at.x, 5.5, 'update at body')

-- クエスト名が無ければ印だけ
for i = #places, 1, -1 do places[i] = nil end
for i = #place_updates, 1, -1 do place_updates[i] = nil end
ext.clear_world_marks()
eq(ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 11 },
}), true, 'world mark only')
eq(#places, 1, 'mark only')
eq(places[1].opts.x, 0, 'mark at center')
eq(places[1].opts.y, 0, 'mark at base')

-- ??? は印の下（印を上げて、本体に食い込まない）
for i = #places, 1, -1 do places[i] = nil end
for i = #place_updates, 1, -1 do place_updates[i] = nil end
for i = #texts, 1, -1 do texts[i] = nil end
ext.clear_world_marks()
eq(ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 11,
      under = '???' },
}), true, 'world mark with ??? under')
eq(#places, 2, 'mark and ???')
eq(places[1].x, 5, 'at body')
eq(#texts, 1, 'one ??? text box')
eq(texts[1].text, '???', '??? caption')
local wm, _, wu = world_parts(places)
check(wm and wu, 'mark and ??? both placed')
-- 0.1.45：印は ??? の左横（同じ行）。行は本体の上の真ん中。??? の箱の幅は 80（偽の箱）
eq(wm.opts.x, -(28 + 8 + 80) / 2 + 14, 'mark left of ???')
eq(wu.opts.x, (28 + 8 + 80) / 2 - 40, '??? right of mark')
eq(wm.opts.x + 14 + 8, wu.opts.x - 40, 'gap between mark and ???')
eq(wm.opts.y, 0, 'mark on the same row')
eq(wu.opts.y, -(28 - 18) / 2, '??? vertically centered on the mark')
local _, n_under = ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 11,
      under = '???' },
})
eq(n_under, 1, 'counts as one mark')
eq(#places, 2, 'no new place on second under frame')
eq(#place_updates, 0, 'same spot: kept as is (0.1.210)')

-- クエスト名付きのときは、上に印、中にクエスト名、下に ???
for i = #places, 1, -1 do places[i] = nil end
for i = #place_updates, 1, -1 do place_updates[i] = nil end
for i = #texts, 1, -1 do texts[i] = nil end
ext.clear_world_marks()
eq(ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 11,
      label = 'ダングルフの奇岩', under = '???' },
}), true, 'quest name and ??? under')
eq(#places, 3, 'mark, quest name, and ???')
eq(#texts, 2, 'quest name and ??? boxes')
local name_box, under_box
for _, tb in ipairs(texts) do
    if tb.text == '???' then
        under_box = tb
    elseif tb.text == 'ダングルフの奇岩' then
        name_box = tb
    end
end
check(name_box, 'quest name text')
check(under_box, '??? under text')
local wm, wl, wu = world_parts(places)
check(wm and wl and wu, 'all three placed')
-- 0.1.45：クエスト名は、印と ??? の行の上（真ん中）
check(wl.opts.y < wu.opts.y and wl.opts.y < wm.opts.y, 'quest name is above the row')
eq(wl.opts.y, -(28 + 24), 'quest name over the row')
eq(wl.opts.x, 0, 'quest name centered')
eq(wm.opts.y, 0, 'mark on the row'); check(wm.opts.x < 0 and wu.opts.x > 0, 'mark left, ??? right')


-- アイコンの大きさ（設定の px）。変わったら作り直し、印は文字の大きさで変えない。
for i = #places, 1, -1 do places[i] = nil end
for i = #world_pics, 1, -1 do world_pics[i] = nil end
ext.clear_world_marks()
eq(ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1.4, key = 11, icon = 48 },
}), true, 'icon 48')
eq(ext.icon_size(), 48, 'size applied')
eq(world_pics[#world_pics].width, 48, 'image width 48')
eq(world_pics[#world_pics].height, 48, 'image height 48')
eq(places[#places].opts.scale, 1, 'mark not scaled by font size')
local before = #world_pics
ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 11, icon = 48 },
})
eq(#world_pics, before, 'same size keeps box')
ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 11, icon = 200 },
})
eq(ext.icon_size(), 64, 'clamped to 64')
eq(world_pics[#world_pics].width, 64, 'recreated at 64')
ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 11, icon = 28 },
})
eq(ext.icon_size(), 28, 'back to default')
ext.clear_world_marks()

-- 位置の調整（px）：マークと調べる対象の名前だけ動く。クエスト名は動かない。名前は別の大きさ。
for i = #places, 1, -1 do places[i] = nil end
ext.clear_world_marks()
eq(ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1.2, under_scale = 1.5, key = 11,
      label = 'Q', under = '???', mark_dx = 6, mark_dy = -10, name_dx = -8, name_dy = 4, label_dx = 12, label_dy = -6 },
}), true, 'offset place')
local om, ol, ou = world_parts(places)
check(om and ol and ou, 'offset parts')
-- 名前は 1.5 倍なので幅 120。行の幅 28 + 8 + 120
eq(om.opts.x, -(28 + 8 + 120) / 2 + 14 + 6, 'mark dx'); eq(om.opts.y, 0 - 10, 'mark dy')
eq(ol.opts.x, 12, 'quest name dx'); eq(ol.opts.y, -(28 + 24) - 6, 'quest name dy')
eq(ou.opts.x, (28 + 8 + 120) / 2 - 60 - 8, 'name dx'); eq(ou.opts.y, -(28 - 18) / 2 + 4, 'name dy')
eq(ol.opts.scale, 1.2, 'quest name scale'); eq(ou.opts.scale, 1.5, 'name own scale')
eq(om.opts.scale, 1, 'mark not scaled')
ext.clear_world_marks()
for i = #places, 1, -1 do places[i] = nil end
-- 0 ならこれまでどおり
ext.set_world_marks({ { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 11, under = '???',
    mark_dx = 0, mark_dy = 0, name_dx = 0, name_dy = 0 } })
local zm, _, zu = world_parts(places)
eq(zm.opts.x, -(28 + 8 + 80) / 2 + 14, 'zero dx'); eq(zm.opts.y, 0, 'zero dy'); eq(zu.opts.y, -(28 - 18) / 2, 'zero name')
ext.clear_world_marks()
-- 名前に付ける印（attach）もマークだけ動く
ext.clear_name_marks()
for i = #attaches, 1, -1 do attaches[i] = nil end
ext.set_name_marks({ { index = 7, role = 'talk', scale = 1, label = 'Q', mark_dx = 6, mark_dy = -10, label_dx = 5, label_dy = -3 } })
local am, al
for _, at in ipairs(attaches) do if at.opts.side == 'left' then am = at else al = at end end
check(am and al, 'attach mark and label')
eq(am.opts.x, -4 + 6, 'attach mark dx'); eq(am.opts.y, -10, 'attach mark dy')
eq(al.opts.x, 5, 'attach quest name dx'); eq(al.opts.y, -2 - 3, 'attach quest name dy')
ext.clear_name_marks()

-- 0.1.45：??? に二つのクエスト。上の層は、印と ??? の行・クエスト名の上へ（重ならない）
for i = #places, 1, -1 do places[i] = nil end
ext.clear_world_marks()
ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = '11:0', layer = 0, label = 'Q1', under = '???' },
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = '11:1', layer = 1, label = 'Q2', under = '???' },
})
local l0, l1, m1
for _, p in ipairs(places) do
    local b = p.box or {}
    if b.text == 'Q1' then l0 = p elseif b.text == 'Q2' then l1 = p elseif b.file and p.opts.y < -40 then m1 = p end
end
check(l0 and l1 and m1, 'two layers placed')
-- 層0：クエスト名は -(28+24)。層1：その上（行 28+24 ＋ 名前 18+24）、印はクエスト名の上
eq(l1.opts.y, -(28 + 24 + 18 + 24), 'second quest name above the first')
check(m1.opts.y < l1.opts.y, 'second mark above its quest name')
eq(m1.opts.x, 0, 'upper layer mark centered')
local qd = 0
for _, p in ipairs(places) do if (p.box or {}).text == '???' then qd = qd + 1 end end
eq(qd, 1, 'only one ??? row')
ext.clear_world_marks()

-- 0.1.47：文字の色。クエスト名は単色、??? はグラデーション（色の印つき）
for i = #places, 1, -1 do places[i] = nil end
for i = #texts, 1, -1 do texts[i] = nil end
ext.clear_world_marks()
ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 'c1', label = 'Q', under = '???',
      label_color = { 255, 0, 0 }, under_color = { 0, 0, 0 }, under_color2 = { 200, 100, 0 } },
})
local qb, ub
for _, tb in ipairs(texts) do
    if tb.text == 'Q' then qb = tb elseif type(tb.text) == 'string' and tb.text:find('cs(', 1, true) then ub = tb end
end
check(qb and qb.color == '#FF0000FF', 'quest name color')
check(ub and ub.text == '\\cs(0,0,0)?\\cs(100,50,0)?\\cs(200,100,0)?\\cr', 'object name gradient: ' .. tostring(ub and ub.text))
ext.clear_world_marks()
-- 名前に付けるクエスト名（話す相手）も同じ色
for i = #texts, 1, -1 do texts[i] = nil end
ext.clear_name_marks()
ext.set_name_marks({ { index = 7, role = 'talk', scale = 1, label = 'Q', label_color = { 0, 255, 0 } } })
local nb
for _, tb in ipairs(texts) do if tb.text == 'Q' then nb = tb end end
check(nb and nb.color == '#00FF00FF', 'npc quest name color')
ext.clear_name_marks()


-- クライアントのメニューフォント（imgui.font）を頭上の文字に使う
eq(ext.parse_imgui_font('[client]\r\nimgui.font=azukiLP.ttf\r\n'), 'azukiLP.ttf', 'ini crlf')
eq(ext.parse_imgui_font('[graphics]\nimgui.font=skip.ttf\n[Client]\n; imgui.font=old.ttf\nImGui.Font = "foo.otf"\n'), 'foo.otf', 'section and quotes')
eq(ext.parse_imgui_font('[client]\nimgui.font=\n'), nil, 'empty value')
eq(ext.parse_imgui_font('[client]\nfoo=1\n'), nil, 'no font key')

local function u16le_ascii(s)
    local out = { '\255\254' }
    for i = 1, #s do
        out[#out + 1] = s:sub(i, i)
        out[#out + 1] = '\0'
    end
    return table.concat(out)
end
eq(ext.parse_imgui_font(u16le_ascii('[client]\nimgui.font=azukiLP.ttf\n')), 'azukiLP.ttf', 'utf16le ini')

local function be16(n)
    n = n % 65536
    return string.char(math.floor(n / 256), n % 256)
end
local function be32(n)
    n = n % 4294967296
    return be16(math.floor(n / 65536)) .. be16(n % 65536)
end
local function utf16be(s)
    local out = {}
    for _, cp in utf8.codes(s) do
        if cp < 0x10000 then
            out[#out + 1] = be16(cp)
        else
            local u = cp - 0x10000
            out[#out + 1] = be16(0xD800 + math.floor(u / 0x400))
            out[#out + 1] = be16(0xDC00 + (u % 0x400))
        end
    end
    return table.concat(out)
end

-- LuaJIT 2.1 には utf8.codes が無いことがあるので、UTF-8 を自分で読む
local function utf16be(s)
    local out = {}
    local i = 1
    while i <= #s do
        local b = s:byte(i)
        local cp, n
        if b < 0x80 then
            cp, n = b, 1
        elseif b < 0xE0 then
            cp = (b - 0xC0) * 0x40 + (s:byte(i + 1) - 0x80)
            n = 2
        elseif b < 0xF0 then
            cp = (b - 0xE0) * 0x1000 + (s:byte(i + 1) - 0x80) * 0x40 + (s:byte(i + 2) - 0x80)
            n = 3
        else
            cp = (b - 0xF0) * 0x40000 + (s:byte(i + 1) - 0x80) * 0x1000 + (s:byte(i + 2) - 0x80) * 0x40 + (s:byte(i + 3) - 0x80)
            n = 4
        end
        if cp < 0x10000 then
            out[#out + 1] = be16(cp)
        else
            local u = cp - 0x10000
            out[#out + 1] = be16(0xD800 + math.floor(u / 0x400))
            out[#out + 1] = be16(0xDC00 + (u % 0x400))
        end
        i = i + n
    end
    return table.concat(out)
end

local function make_ttf(entries)
    -- entries: { platform, encoding, language, name_id, text }
    local recs, str, n = {}, {}, 0
    for _, e in ipairs(entries) do
        local raw = utf16be(e[5])
        recs[#recs + 1] = be16(e[1]) .. be16(e[2]) .. be16(e[3]) .. be16(e[4]) .. be16(#raw) .. be16(#table.concat(str))
        -- #table.concat(str) is current offset; but concatenating every time is ok for small
        str[#str + 1] = raw
        n = n + 1
    end
    -- 上の offset 計算が各回 table.concat しているので正しい（その時点までの長さ）
    local records = table.concat(recs)
    local strings = table.concat(str)
    local count = #entries
    local name = be16(0) .. be16(count) .. be16(6 + 12 * count) .. records .. strings
    local off_table = be32(0x00010000) .. be16(1) .. be16(16) .. be16(0) .. be16(0)
    local name_off = 28
    local rec = 'name' .. be32(0) .. be32(name_off) .. be32(#name)
    return off_table .. rec .. name
end

local ttf = make_ttf({
    { 3, 1, 0x0411, 1, 'あずきテスト' },
    { 3, 1, 0x0409, 1, 'AzukiTest' },
    { 3, 1, 0x0409, 16, 'AzukiTypo' },
    { 1, 0, 0, 1, 'MacFamily' },  -- Mac Roman: our writer emits UTF-16BE, skip this or write ASCII raw
})
-- Mac record は UTF-16BE で書いているのでデコードできない。ASCII 専用レコードは別途。
-- 上の MacFamily は platform 1 で UTF-16BE になるので無視される。家族名の確認には Windows レコードだけで足りる。

local names = {}
-- ファイルに書いて読む
check(type(TMP) == 'string' and TMP ~= '', 'TMP is set')
os.execute('mkdir -p "' .. TMP .. '/fonts"')
local tf = io.open(TMP .. '/fonts/_family.ttf', 'wb')
tf:write(ttf)
tf:close()
local families = ext.font_family_names(TMP .. '/fonts/_family.ttf')
eq(families[1], 'AzukiTypo', 'typographic family first')
-- 英語の家族名が日本語より先
local has_en, has_ja, i_en, i_ja = false, false, 0, 0
for i, s in ipairs(families) do
    if s == 'AzukiTest' then has_en, i_en = true, i end
    if s == 'あずきテスト' then has_ja, i_ja = true, i end
end
check(has_en, 'english family')
check(has_ja, 'japanese family')
check(i_en < i_ja, 'english family before japanese')

-- インストール先の ini と fonts\azukiLP.ttf から、頭上の文字に同じフォントを渡す
local vf = io.open(TMP .. '/fonts/azukiLP.ttf', 'wb')
vf:write(ttf)
vf:close()
local inf = io.open(TMP .. '/vanacore.ini', 'wb')
inf:write('[client]\nimgui.font=azukiLP.ttf\n')
inf:close()
ext.set_install_dir(TMP)
local menu = ext.menu_font_names()
eq(menu[1], 'AzukiTypo', 'menu font from client setting')
check(menu[#menu] == 'azukiLP' or (function()
    for _, s in ipairs(menu) do if s == 'azukiLP' then return true end end
    return false
end)(), 'file stem is also tried')

ext.clear_name_marks()
ext.clear_world_marks()
for i = #texts, 1, -1 do texts[i] = nil end
attaches = {}
eq(ext.set_name_marks({
    { index = 6, role = 'talk', scale = 1, label = 'カマドに火をつけて' },
}), true, 'label with menu font')
eq(#texts, 1, 'one menu-font text box')
eq(texts[1].font, 'AzukiTypo', 'overhead text uses menu font')
check(texts[1].text:find('カマドに火をつけて', 1, true) ~= nil, 'quest name still set')

-- ??? も同じ
for i = #texts, 1, -1 do texts[i] = nil end
for i = #places, 1, -1 do places[i] = nil end
eq(ext.set_world_marks({
    { x = 5, y = 6, z = 1, up = 2, role = 'examine', scale = 1, key = 21,
      under = '???' },
}), true, '??? with menu font')
local under_font
for _, t in ipairs(texts) do
    if t.text and t.text:find('???', 1, true) then under_font = t.font end
end
eq(under_font, 'AzukiTypo', '??? uses menu font')
ext.clear_world_marks()
ext.clear_name_marks()

-- 公式の vana.config.get を優先（実機は vanacore.<id>.ini。vanacore.ini だけだと取れない）
local decoy = io.open(TMP .. '/vanacore.ini', 'wb')
decoy:write('[client]\nimgui.font=Other.ttf\n')
decoy:close()
_G.vana.config = {
    get = function (section, key)
        if section == 'client' and key == 'imgui.font' then
            return 'azukiLP.ttf'
        end
        return nil
    end,
}
ext.set_install_dir(TMP)
eq(ext.menu_font_setting(), 'azukiLP.ttf', 'setting from vana.config.get')
eq(ext.menu_font_names()[1], 'AzukiTypo', 'family via config.get, not decoy ini')

os.remove(TMP .. '/vanacore.ini')
ext.clear_menu_font_cache()
eq(ext.menu_font_setting(), 'azukiLP.ttf', 'config works without vanacore.ini')

-- config が無いときは、vanacore.<id>.ini を公式のファイル一覧から読む
_G.vana.config = nil
_G.vana.fs = {
    list = function (dir)
        return { 'vanacore.40fc6718a81f.ini', 'vanacore.example.ini', 'readme.txt' }
    end,
}
local hf = io.open(TMP .. '/vanacore.40fc6718a81f.ini', 'wb')
hf:write('[client]\nimgui.font=azukiLP.ttf\n')
hf:close()
ext.set_install_dir(TMP)
eq(ext.menu_font_setting(), 'azukiLP.ttf', 'setting from hashed ini')
eq(ext.menu_font_names()[1], 'AzukiTypo', 'family from hashed ini')

for i = #texts, 1, -1 do texts[i] = nil end
eq(ext.set_name_marks({
    { index = 6, role = 'talk', scale = 1, label = 'カマドに火をつけて' },
}), true, 'label after hashed ini')
eq(texts[1].font, 'AzukiTypo', 'overhead text after official config path')
ext.clear_name_marks()
ext.set_install_dir(nil)
_G.vana.config = nil
_G.vana.fs = nil

-- 0.1.37 ズームに合わせた位置（試し）
do
    ext.clear_name_marks()
    ext._reset_zoom()
    local H = 30
    _G.vana.world.name_at = function (index) return 100, 50, 50 + H end
    for i = #attaches, 1, -1 do attaches[i] = nil end
    for i = #updates, 1, -1 do updates[i] = nil end
    local function last_opts()
        local u = updates[#updates]; local a = attaches[#attaches]
        if u and (not a or #updates > 0) then return u.opts end
        return a and a.opts
    end
    local item = { index = 21, role = 'talk', scale = 1, mark_dx = 10, mark_dy = -20, zoom_follow = true }
    ext.set_name_marks({ item })
    local o = attaches[#attaches].opts
    eq(o.x, 6, 'near: offsets as set')        -- (-4 + 10) * 1
    eq(o.y, -20, 'near: y as set')
    H = 15
    ext.set_name_marks({ item })
    o = updates[#updates].opts
    eq(o.x, 3, 'far: half')                    -- 名前が半分 → 隙間も半分
    eq(o.y, -10, 'far: y half')
    local f, h, ref = ext.name_zoom(21)
    eq(f, 0.5, 'zoom f'); eq(h, 15, 'zoom h'); eq(ref, 30, 'zoom ref')
    H = 3
    eq((ext.name_zoom(21)), ext.ZOOM_MIN, 'clamped min')
    H = 15
    -- オフはこれまでどおり（名前の高さを見ない）
    local off = { index = 21, role = 'talk', scale = 1, mark_dx = 10, mark_dy = -20 }
    ext.set_name_marks({ off })
    o = updates[#updates].opts
    eq(o.x, 6, 'off: unchanged x'); eq(o.y, -20, 'off: unchanged y')
    -- 近づいて名前が大きくなっても、設定より広げない
    H = 60
    ext.set_name_marks({ item })
    o = updates[#updates].opts
    eq(o.x, 6, 'never wider than set')
    ext.clear_name_marks()
    ext._reset_zoom()
end

-- ??? など点に置く相手：距離 32（基準 16 の倍）なら積みの間隔も半分
do
    local places = {}
    local saved_place, saved_update, saved_ts = _G.vana.world.place, _G.vana.world.update, _G.vana.world.to_screen
    _G.vana.world.place = function (box, x, y, z, opts) places[#places + 1] = { box = box, opts = opts } end
    _G.vana.world.update = function () error('no update in this test') end
    _G.vana.world.to_screen = function () return 10, 20, 32 end
    local function run(zf)
        for i = #places, 1, -1 do places[i] = nil end
        if ext.clear_world_marks then ext.clear_world_marks() end
        ext.set_world_marks({ { key = 'k', x = 1, y = 2, z = 3, up = 2, role = 'examine', under = '???', label = 'Q', scale = 1, mark_dy = -10, zoom_follow = zf } })
        local ys = {}
        for _, p in ipairs(places) do ys[#ys + 1] = p.opts.y end
        return ys
    end
    local off = run(nil)
    local on = run(true)
    check(#off >= 2 and #off == #on, 'placed parts ' .. #off)
    local any_nonzero = false
    for i = 1, #off do
        eq(on[i], off[i] * 0.5, 'place y scaled ' .. i)
        if off[i] ~= 0 then any_nonzero = true end
    end
    check(any_nonzero, 'some stacked offsets')
    if ext.clear_world_marks then ext.clear_world_marks() end
    _G.vana.world.place, _G.vana.world.update, _G.vana.world.to_screen = saved_place, saved_update, saved_ts
end

-- 0.1.39: 点の縮み具合は箱と同じ 16 ÷ 距離（近いと 1 より大きい）
do
    local saved_ts = _G.vana.world.to_screen
    local D = 8
    _G.vana.world.to_screen = function () return 10, 20, D end
    eq((ext.place_zoom(1, 2, 3)), 2, 'near: 2x like the boxes')
    D = 4; eq((ext.place_zoom(1, 2, 3)), 4, 'very near: 4x')
    D = 2; eq((ext.place_zoom(1, 2, 3)), ext.PLACE_ZOOM_MAX, 'clamped max')
    D = 64; eq((ext.place_zoom(1, 2, 3)), 0.25, 'far: quarter')
    D = 1000; eq((ext.place_zoom(1, 2, 3)), ext.PLACE_ZOOM_MIN, 'clamped min')
    _G.vana.world.to_screen = saved_ts
end

print('test_vanacore_ext ok')
