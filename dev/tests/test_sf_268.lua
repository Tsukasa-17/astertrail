-- 0.1.268：アイテム説明を実行時の日本語でツールチップ再開、手順の折り返し、SF の対象色
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.318', 'version')

local item_tip = require('src.ui.item_tip')
local CT = require('src.ui.colored_text')
local theme = require('src.ui.theme')
local W = require('src.ui.widgets')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')

---------------------------------------------------------------------------
-- ソース：言語 0 は使わない。説明は実行時に取り、同梱しない
---------------------------------------------------------------------------
local tip_src = io.open(ROOT .. '/src/ui/item_tip.lua', 'r'):read('*a')
check(not tip_src:find('item(id, 0)', 1, true), 'live item never uses language 0')
check(not tip_src:find('item(id,0)', 1, true), 'live item never uses language 0 compact')
check(not tip_src:find("ash.item, id, 0", 1, true), 'ashita.item is not called with 0')
check(tip_src:find('ash.item, id, 1', 1, true) ~= nil, 'ashita.item is called with language 1')
check(tip_src:find('Name', 1, true) ~= nil and tip_src:find('[1]', 1, true) ~= nil, 'reads Name/Description index 1')
check(tip_src:find('debug_item_ja.txt', 1, true) ~= nil, 'one-time ja debug file is in the addon folder')
check(tip_src:find("find('workspace'", 1, true) ~= nil, 'debug path still skips workspace trees')

local wsrc = io.open(ROOT .. '/src/ui/widgets.lua', 'r'):read('*a')
check(wsrc:find('show_for_need', 1, true) ~= nil, 'item name hover shows the tip again')

local bsrc = io.open(ROOT .. '/src/ui/book_sf.lua', 'r'):read('*a')
check(bsrc:find('text_col - 12', 1, true) ~= nil, 'SF step wrap leaves the same right pad as the left')
check(bsrc:find('wrap_width = text_avail', 1, true) ~= nil, 'SF steps pass wrap_width into term_line')
check(bsrc:find('hang_x = hang_x', 1, true) ~= nil, 'wrapped step lines still hang under the text start')

---------------------------------------------------------------------------
-- 日本語：SJIS と UTF-8、失敗時は英語資料。番号ごとに覚える
---------------------------------------------------------------------------
local sjis_name = string.char(0x96, 0xEC, 0x93, 0x65, 0x82, 0xCC, 0x93, 0xF7)
local sjis_desc = string.char(0x8F, 0xAC, 0x82, 0xB3, 0x82, 0xC8, 0x96, 0xEC, 0x93, 0x65, 0x82, 0xCC, 0x93, 0xF7, 0x81, 0x42)

item_tip.clear_source()
local calls = 0
item_tip.set_source({
    live_ja = function (id, lang)
        calls = calls + 1
        eq(lang, 1, 'live_ja is asked for language 1')
        check(lang ~= 0, 'live_ja is not asked for language 0')
        if id == 4358 then
            return { name = sjis_name, description = sjis_desc }
        end
        return { name = '', description = '' }
    end,
    item = function (id)
        if id == 4358 then
            return { name = 'Hare Meat', description = 'This meat is from a small wild rabbit.\n' }
        end
        return { name = 'Potion', description = 'This potion restores a bit of HP.\n' }
    end,
})

local info = item_tip.info_for_item(4358)
check(info ~= nil, 'info for 4358')
eq(info.name, '野兎の肉', 'SJIS name becomes UTF-8 Japanese')
eq(info.description, '小さな野兎の肉。', 'SJIS description becomes UTF-8 Japanese')
eq(info.language, 'ja', 'detected as Japanese')
item_tip.info_for_item(4358)
eq(calls, 1, 'live text is cached per item id')

item_tip.clear_source()
item_tip.set_source({
    live_ja = function (id, lang)
        eq(lang, 1, 'utf8 path uses language 1')
        return { name = '野兎の肉', description = '小さな野兎の肉。' }
    end,
    item = function ()
        return { name = 'Hare Meat', description = 'This meat is from a small wild rabbit.\n' }
    end,
})
info = item_tip.info_for_item(4358)
eq(info.name, '野兎の肉', 'already-UTF-8 Japanese is kept')
eq(info.description, '小さな野兎の肉。', 'already-UTF-8 description is kept')
eq(info.language, 'ja', 'utf8 Japanese is detected')

item_tip.clear_source()
item_tip.set_source({
    live_ja = function ()
        error('no api')
    end,
    item = function ()
        return { name = 'Hare Meat', description = 'This meat is from a small wild rabbit.\n' }
    end,
})
info = item_tip.info_for_item(4358)
eq(info.name, 'Hare Meat', 'falls back to English name when live ja fails')
eq(info.language, 'en', 'fallback description is English')

item_tip.clear_source()
item_tip.set_source({
    live_ja = function ()
        return { name = 'A' .. string.char(0xEF, 0x1F) .. 'B', description = 'ok' }
    end,
})
info = item_tip.info_for_item(1)
eq(info.name, 'A{Fire}B', 'FFXI element control codes become readable tags')

---------------------------------------------------------------------------
-- 折り返し：文字だけなら1行、アイコン幅を足すと折る。指定幅を使う
---------------------------------------------------------------------------
local imgui = package.loaded['imgui']
local old_tex = item_tip.icon_texture
item_tip.icon_texture = function (id) return id and 'tex' or nil end
local spans_plain = {
    { text = 'XXXX' },
    { text = 'ITEMNAME', kind = 'item', color = 'item', item_id = 4358 },
}
-- 文字幅：XXXX=32、ITEMNAME=64、合計 96。アイコン予約は 16+3=19、合計 115
local lines_text = CT._layout(imgui, {
    { text = 'XXXX' },
    { text = 'ITEMNAME', kind = 'item', color = 'item' },
}, 100)
eq(#lines_text, 1, 'text alone still fits on one line')

local lines_icon = CT._layout(imgui, spans_plain, 100)
check(#lines_icon >= 2, 'reserving the inline icon width wraps before the pane edge')
local first = ''
for _, p in ipairs(lines_icon[1]) do first = first .. p.text end
local second = ''
for _, p in ipairs(lines_icon[2]) do second = second .. p.text end
check(first:find('ITEMNAME', 1, true) == nil, 'the item name does not overflow the first line')
check(second:find('ITEMNAME', 1, true) ~= nil, 'the item name starts the hanging second line')

-- 右余白 12：avail 相当を wrap_width で渡す
local csrc = io.open(ROOT .. '/src/ui/colored_text.lua', 'r'):read('*a')
check(csrc:find('wrap_pad) or 4', 1, true) ~= nil, 'default wrap pad stays 4 for classic/tracker')
check(csrc:find('opts.wrap_width', 1, true) ~= nil, 'layout honors an explicit wrap width')
check(csrc:find('icon_reserve_width', 1, true) ~= nil, 'layout asks item_tip for icon reserve width')

item_tip.icon_texture = old_tex

---------------------------------------------------------------------------
-- SF の対象色：ピンクマゼンタ。NPC はより鮮やかな紫。クラシックはそのまま
---------------------------------------------------------------------------
local prev = theme.look
theme.set_look('classic')
local c_obj = { theme.palette.obj[1], theme.palette.obj[2], theme.palette.obj[3] }
local c_npc = { theme.palette.npc[1], theme.palette.npc[2], theme.palette.npc[3] }
eq(c_obj[1], 0.62, 'classic object stays sky blue')
theme.set_look('sf')
local s_obj = theme.palette.obj
local s_npc = theme.palette.npc
local s_text = theme.palette.text
check(s_obj[1] >= 0.95 and s_obj[2] <= 0.55 and s_obj[3] >= 0.70, 'SF object is pink-magenta')
check(s_obj[1] ~= s_text[1] or s_obj[2] ~= s_text[2] or s_obj[3] ~= s_text[3], 'SF object is not body text')
check(s_npc[1] >= 0.75 and s_npc[3] >= 0.95, 'SF NPC is a vivid purple')
check(s_npc[1] > c_npc[1] or s_npc[3] >= c_npc[3], 'SF NPC is at least as vivid as classic')
-- 既存の色分けと違う
local function same3(a, b)
    return math.abs(a[1]-b[1]) < 0.02 and math.abs(a[2]-b[2]) < 0.02 and math.abs(a[3]-b[3]) < 0.02
end
check(not same3(s_obj, theme.palette.item), 'object is not item amber')
check(not same3(s_obj, theme.palette.zone), 'object is not zone green')
check(not same3(s_obj, theme.palette.npc), 'object is not NPC purple')
check(not same3(s_obj, theme.palette.mob), 'object is not monster salmon')
check(wsrc:find('ホバーで下線', 1, true) ~= nil, 'SF map links can underline on hover')
theme.set_look(prev)

print('test_sf_268 ok')
