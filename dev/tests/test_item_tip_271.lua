-- 0.1.272：アイテムのポップアップをカード型に。ジョブは日本語1文字。ギルは出さない
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.318', 'version')

local item_tip = require('src.ui.item_tip')
local theme = require('src.ui.theme')
item_tip.clear_source()

-- 略称の控え
eq(item_tip.job_abbrev(1), '戦', 'WAR -> 戦')
eq(item_tip.job_abbrev(2), 'モ', 'MNK -> モ')
eq(item_tip.job_abbrev(3), '白', 'WHM -> 白')
eq(item_tip.job_abbrev(6), 'シ', 'THF -> シ')
eq(item_tip.job_abbrev(7), 'ナ', 'PLD -> ナ')
eq(item_tip.job_abbrev(18), 'か', 'PUP -> か')
eq(item_tip.job_abbrev(21), '風', 'GEO -> 風')
eq(item_tip.job_abbrev(22), '剣', 'RUN -> 剣')
-- ゲームのリソースが1文字の日本語なら、それを使う
eq(item_tip.job_abbrev(1, { short = '戦' }), '戦', 'resource 1-char wins')
eq(item_tip.job_abbrev(1, { short = 'WAR' }), '戦', 'English 3-letter is not used')
eq(item_tip.job_abbrev(22, { name = '魔導剣士' }), '剣', 'full Japanese name is not first-char')

-- スロット：ビットと名前。耳・指はまとめる
eq(item_tip.slot_label(0x0200), '首', 'neck bit')
eq(item_tip.slot_label(0x0010), '頭', 'head bit')
eq(item_tip.slot_label(0x0020), '胴', 'body bit')
eq(item_tip.slot_label(0x0800 + 0x1000), '耳', 'both ears once')
eq(item_tip.slot_label(0x2000 + 0x4000), '指', 'both rings once')
eq(item_tip.slot_label(0x0001 + 0x0002), 'メイン／サブ', 'main and sub')
eq(item_tip.slot_label(nil, 'Neck'), '首', 'English slot name')
eq(item_tip.slot_label(nil, '首'), '首', 'Japanese slot name')

local function le32(n)
    n = n % 4294967296
    return string.char(n % 256, math.floor(n / 256) % 256, math.floor(n / 65536) % 256, math.floor(n / 16777216) % 256)
end
local function le16(n)
    n = n % 65536
    return string.char(n % 256, math.floor(n / 256) % 256)
end
local pixels = string.char(0, 0, 255, 255, 0, 255, 0, 255, 255, 0, 0, 255, 255, 255, 255, 255)
local dib = le32(40) .. le32(2) .. le32(2) .. le16(1) .. le16(32) .. le32(0) .. le32(16)
    .. le32(0) .. le32(0) .. le32(0) .. le32(0)
local bmp = 'BM' .. le32(14 + 40 + 16) .. le32(0) .. le32(14 + 40) .. dib .. pixels

local ALL_BITS = 0
for i = 1, 22 do ALL_BITS = ALL_BITS + 2 ^ i end

item_tip.set_source({
    item = function (id)
        if id == 13083 then
            return {
                name = 'Bone Hairpin',
                description = 'A hairpin carved from bone.',
                level = 7,
                slots = 0x0200, -- 首
                jobs = ALL_BITS,
                flags = 0,
                flag_names = {},
            }
        end
        if id == 16583 then
            return {
                name = 'クレイモア',
                description = '両手剣。',
                level = 10,
                slots = 0x0001,
                jobs = 2 + 4, -- 戦 モ
                damage = 28,
                delay = 444,
                item_level = 0,
                flags = 0,
            }
        end
        if id == 4155 then
            return {
                name = '万能薬',
                description = 'ほとんどの状態異常を治す。',
                level = 1,
                jobs = 0,
                flags = 0xC000,
                flag_names = { 'Rare', 'Ex' },
            }
        end
        return nil
    end,
    job = function (id)
        -- 英語の3文字が来ても、日本語1文字に直す
        return ({ [1] = { short = 'WAR' }, [2] = { short = 'MNK' } })[id]
    end,
    icon = function (id)
        if id == 13083 or id == 4155 then return bmp end
        return nil
    end,
    load_texture = function (img)
        return { _tex = true, w = img.width, h = img.height }
    end,
    live_ja = function (id)
        if id == 13083 then
            return { name = 'ボーンヘアピン', description = '骨で作られたヘアピン。' }
        end
        return nil
    end,
})

-- 装備：名前は日本語、スロット・レベル・全ジョブ
local pin = item_tip.info_for_item(13083)
check(pin and pin.name == 'ボーンヘアピン', 'Japanese name from live_ja')
eq(pin.language, 'ja', 'Japanese description')
eq(pin.equipment, true, 'neck item is equipment')
eq(pin.slot_label, '首', 'slot is 首')
eq(pin.level, 7, 'level 7')
eq(item_tip.meta_line(pin), '首 ・ Lv 7', 'muted line format')
check(pin.all_jobs == true, 'all 22 jobs')
eq(item_tip.jobs_text(pin), '全ジョブ', 'all jobs label')

local lines = item_tip.lines({ t = function (k, a)
    if k == 'item_tip.all_jobs' then return '全ジョブ' end
    if k == 'item_tip.jobs' then return a.list end
    if k == 'item_tip.damage' then return 'ダメージ ' .. a.n end
    if k == 'item_tip.delay' then return '隔 ' .. a.n end
    if k == 'item_tip.item_level' then return 'iLv. ' .. a.n end
    if k == 'item_tip.rare' then return 'Rare' end
    if k == 'item_tip.ex' then return 'Ex' end
    return k
end }, pin)
local texts = {}
for _, ln in ipairs(lines) do texts[#texts + 1] = ln.text end
local joined = table.concat(texts, '|')
check(joined:find('ボーンヘアピン', 1, true), 'name in lines')
check(joined:find('首 ・ Lv 7', 1, true), 'slot and level in lines')
check(joined:find('全ジョブ', 1, true), '全ジョブ in lines')
check(joined:find('骨で作られたヘアピン。', 1, true), 'description in lines')
check(not joined:find('WAR', 1, true), 'no English job codes')

-- 一部ジョブの武器：ダメージと隔。戦 モ
local sword = item_tip.info_for_item(16583)
eq(sword.equipment, true, 'weapon is equipment')
eq(sword.slot_label, 'メイン', 'main slot')
eq(item_tip.meta_line(sword), 'メイン ・ Lv 10', 'weapon meta')
eq(item_tip.jobs_text(sword), '戦 モ', 'two jobs in Japanese')
eq(sword.damage, 28, 'damage from data')
eq(sword.delay, 444, 'delay from data')
local slines = item_tip.lines(nil, sword)
local sjoin = {}
for _, ln in ipairs(slines) do sjoin[#sjoin + 1] = ln.text end
sjoin = table.concat(sjoin, '|')
check(sjoin:find('ダメージ 28', 1, true), 'damage row: ' .. sjoin)
check(sjoin:find('隔 444', 1, true), 'delay row')
check(sjoin:find('戦 モ', 1, true), 'jobs row')

-- 装備でない品：レベルやジョブ、所持欄は出さない（Rare/Ex と説明は出す）
local pot = item_tip.info_for_item(4155)
eq(pot.equipment, false, 'medicine is not equipment')
eq(pot.level, 1, 'level may exist in data')
local plines = item_tip.lines(nil, pot)
local pjoin, has_lv, has_job = {}, false, false
for _, ln in ipairs(plines) do
    pjoin[#pjoin + 1] = ln.text
    if tostring(ln.text):find('Lv', 1, true) then has_lv = true end
    if ln.jobs or ln.meta then has_job = true end
end
pjoin = table.concat(pjoin, '|')
check(pjoin:find('万能薬', 1, true), 'potion name')
check(pjoin:find('ほとんどの状態異常を治す。', 1, true), 'potion description')
check(pjoin:find('Rare', 1, true) and pjoin:find('Ex', 1, true) or pjoin:find('Rare / Ex', 1, true), 'Rare/Ex kept: ' .. pjoin)
check(not has_lv, 'non-equipment hides level: ' .. pjoin)
check(not has_job, 'non-equipment hides jobs')

-- 描画：丸角カードのスタイル、大きいアイコン、SF でも落ちない
local function draw_ui(look)
    theme.set_look(look)
    local seen = { texts = {}, style_col = 0, style_var = 0, rects = 0 }
    local ui = {
        imgui = {
            BeginTooltip = function () seen.begin = true; return true end,
            EndTooltip = function () seen.ended = true end,
            Image = function (tex, sz) seen.image = tex; seen.sz = sz end,
            SameLine = function () end,
            BeginGroup = function () end,
            EndGroup = function () end,
            GetCursorPosX = function () return 0 end,
            GetCursorScreenPos = function () return 10, 20 end,
            SetCursorScreenPos = function () end,
            Dummy = function () seen.dummy = true end,
            PushTextWrapPos = function () end,
            PopTextWrapPos = function () end,
            PushStyleColor = function () seen.style_col = seen.style_col + 1 end,
            PopStyleColor = function () end,
            PushStyleVar = function () seen.style_var = seen.style_var + 1 end,
            PopStyleVar = function () end,
            SetWindowFontScale = function (s) seen.font = s end,
            GetWindowDrawList = function ()
                return {
                    AddRectFilled = function () seen.rects = seen.rects + 1 end,
                    AddRect = function () seen.rects = seen.rects + 1 end,
                }
            end,
        },
        t = function (k, a)
            if k == 'item_tip.all_jobs' then return '全ジョブ' end
            if k == 'item_tip.jobs' then return a and a.list end
            return k
        end,
    }
    check(item_tip.draw(ui, pin) == true, 'draws card in ' .. look)
    check(seen.begin and seen.ended, 'BeginTooltip in ' .. look)
    check(seen.image and seen.image._tex, 'icon in ' .. look)
    check(seen.sz and seen.sz[1] == 48 and seen.sz[2] == 48, 'large 48px icon in ' .. look)
    check(seen.style_col >= 1 and seen.style_var >= 1, 'card style in ' .. look)
    check(seen.rects >= 1, 'icon square border in ' .. look)
    return seen
end

draw_ui('classic')
draw_ui('yunaui')
draw_ui('sf')
theme.set_look('classic')

-- ギルはツールチップを出さない
local gil_need = { kind = 'item', name_ja = 'ギル', count = 5 }
eq(item_tip.show_for_need({ imgui = {} }, gil_need), false, 'gil is not an item tooltip')
eq(item_tip.need_from_piece({ kind = 'gil', text = '5ギル' }), nil, 'gil piece is not a need')
local n = { kind = 'item', name_ja = 'ギル', count = 5, item_id = 65535 }
local got = item_tip.fill_need_ids(n, { lookup_item_name = function () return { item_id = 65535 } end })
eq(got.kind, 'gil', 'fill_need_ids marks gil')
eq(got.item_id, nil, 'fill_need_ids clears gil item id')

item_tip.clear_source()
print('test_item_tip_271 ok')
