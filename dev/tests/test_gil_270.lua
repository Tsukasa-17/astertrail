-- 0.1.272：ギルはアイテムではない。金額だけ色を付け、ギルドには合わせない
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.285', 'version')

local gil = require('src.core.gil')
local CT = require('src.ui.colored_text')
local poss_ui = require('src.ui.possession_ui')
local poss = require('src.core.possession')
local data_mod = require('src.core.data')
local item_tip = require('src.ui.item_tip')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')

-- 金額の切り出し
local function amt(s, pos)
    local a, b = gil.find_amount(s, pos or 1)
    if not a then return nil end
    return s:sub(a, b)
end
eq(amt('5ギル'), '5ギル', 'plain 5ギル')
eq(amt('100ギル'), '100ギル', '100ギル')
eq(amt('2,000ギル'), '2,000ギル', 'comma 2,000ギル')
eq(amt('10万ギル'), '10万ギル', '10万ギル')
eq(amt('Varchetに5ギルをトレード'), '5ギル', 'amount inside a sentence')
eq(amt('勝つと10ギルもらえる。'), '10ギル', '10ギル in reward sentence')
eq(amt('木工ギルド前'), nil, 'ギルド is not a gil amount')
eq(amt('北サンドリア(F-3)木工ギルド前のAurege'), nil, 'location ギルド is not gil')
eq(amt('エギルの松明'), nil, 'ギル inside another item name is not an amount')
eq(amt('魚に応じたギル'), nil, 'ギル without a leading number is not an amount')
eq(amt('ギルド'), nil, 'ギルド alone')
check(gil.is_gil_need({ kind = 'item', name_ja = 'ギル', count = 5 }), 'need named ギル is gil')
check(gil.is_gil_need({ kind = 'gil', name_ja = '5,000ギル' }), 'kind gil')
check(gil.is_gil_need({ kind = 'item', item_id = 65535, name_ja = 'ギル' }), 'sentinel id is gil')
check(not gil.is_gil_need({ kind = 'item', name_ja = '万能薬', item_id = 4155 }), 'real item is not gil')

-- 色分け：金額は gil、ギルドは素の文字。アイテム番号は付けない
local terms = CT.step_terms(nil, {
    needs = { { kind = 'item', name_ja = 'ギル', count = 5, item_id = 65535 } },
    location = { zone_name = '北サンドリア' },
})
for _, t in ipairs(terms) do
    check(t.s ~= 'ギル', 'step_terms does not add ギル as an item term')
    check(t.kind ~= 'item' or t.s ~= 'ギル', 'no item term ギル')
end

local function kinds(spans)
    local out = {}
    for _, s in ipairs(spans) do
        out[#out + 1] = (s.kind or '-') .. ':' .. s.text
    end
    return table.concat(out, '|')
end

local s1 = CT.spans('南サンドリア(L-6)噴水前のVarchetに5ギルをトレードして賭けをする', terms)
local joined = kinds(s1)
check(joined:find('gil:5ギル', 1, true), '5ギル is a gil span: ' .. joined)
for _, s in ipairs(s1) do
    eq(s.item_id, nil, 'gil span has no item_id (' .. tostring(s.text) .. ')')
    eq(s.kind == 'item' and s.text:find('ギル') ~= nil, false, 'no item kind on a ギル piece')
end

local s2 = CT.spans('北サンドリア(F-3)木工ギルド前のAuregeとGuilberdrierに話す', CT.quest_terms(nil, {
    steps = {
        { next_line_ja = '木工ギルド前', needs = {}, location = { zone_name = '北サンドリア' } },
        { needs = { { kind = 'item', name_ja = 'ギル', count = 5 } } },
    },
}))
local t2 = ''
for _, s in ipairs(s2) do t2 = t2 .. s.text; check(s.kind ~= 'gil' and s.kind ~= 'item' or not tostring(s.text):find('ギル'), 'ギルド is not painted as gil/item: ' .. tostring(s.kind) .. '/' .. s.text) end
check(t2:find('木工ギルド前', 1, true), 'guild text stays intact')

-- 空の terms でも金額は拾う
local s3 = CT.spans('勝つと10ギルもらえる。', {})
check(kinds(s3):find('gil:10ギル', 1, true), 'amount is found without item terms')

-- 所持は付けない
local ui = {
    settings = { items = { show_possession = true } },
    t = function (k, args)
        if k == 'sf.poss_held' then return string.format('(%s/%s)', args.have, args.need) end
        return k
    end,
    need_possession = function (n)
        return { state = 'short', have = 0, need = n.count or 1, kind = 'item', parts = {}, unknown = {} }
    end,
}
local step = {
    needs = { { kind = 'item', name_ja = 'ギル', count = 5, item_id = 65535 } },
    next_line_ja = '南サンドリア(L-6)噴水前のVarchetに5ギルをトレードして賭けをする',
}
local out, extras = poss_ui.apply_to_step(ui, step, step.next_line_ja, { steps = { step } })
check(not out:find('0/5', 1, true), 'no possession count on 5ギル: ' .. out)
check(not out:find('(0/', 1, true), 'no (0/n) suffix')
eq(#extras, 0, 'no item/poss extras for gil')
local segs = poss_ui.segments(ui, step.needs)
eq(#segs, 0, 'draw_inline segments skip gil')
local st = poss.need_state({}, step.needs[1])
eq(st.kind, 'gil', 'possession.need_state is gil')
eq(st.state, 'unknown', 'gil has no inventory count')

eq(item_tip.need_from_piece({ kind = 'gil', text = '5ギル' }), nil, 'need_from_piece ignores gil')
eq(item_tip.show_for_need({ imgui = {} }, { kind = 'item', name_ja = 'ギル', count = 5 }), false, 'no gil tooltip')

-- 実データ：勝負師は何処に
local D = data_mod.load(posix_fs(), ROOT .. '/data/')
eq(D:lookup_item_name('ギル'), nil, 'lookup_item_name does not return the 65535 sentinel')
check(D:lookup_item_name('エギルの松明') ~= nil, 'エギルの松明 still looks up as an item')
check(D:lookup_item_name('万能薬') and D:lookup_item_name('万能薬').item_id == 4155, 'real items still look up')

local q = D:quest('quest.sandoria.032')
check(q and q.steps and #q.steps >= 3, 'Exit the Gambler loaded')
local terms_q = CT.quest_terms(D, q)
local g01, g02
for _, s in ipairs(q.steps) do
    if s.id == 'quest.sandoria.032#g01' then g01 = s end
    if s.id == 'quest.sandoria.032#g02' then g02 = s end
end
check(g01 and g02, 'g01 and g02 present')
-- 資料上は kind=item のまま（保存形式は変えない）
check(g02.needs and g02.needs[1] and g02.needs[1].name_ja == 'ギル', 'source need is still named ギル')
eq(g02.needs[1].item_id, nil, 'loader does not stamp 65535 onto gil needs')

local line1 = g01.next_line_ja or ''
check(line1:find('ギルド', 1, true), 'g01 mentions ギルド')
local sp01 = CT.spans(line1, terms_q)
for _, s in ipairs(sp01) do
    check(s.kind ~= 'gil' and s.kind ~= 'item' or not tostring(s.text):find('ギル'), 'g01 ギルド is not an item/gil span')
    eq(s.item_id, nil, 'g01 spans have no gil item id')
end
local out01 = poss_ui.apply_to_step(ui, g01, line1, q)
check(not tostring(out01):find('0/', 1, true), 'g01 no possession on ギルド')

local line2 = g02.next_line_ja or ''
check(line2:find('5ギル', 1, true), 'g02 mentions 5ギル')
local sp02 = CT.spans(line2, terms_q)
local saw_amt
for _, s in ipairs(sp02) do
    if s.text == '5ギル' then
        saw_amt = true
        eq(s.kind, 'gil', '5ギル kind is gil')
        eq(s.item_id, nil, '5ギル has no item_id')
    end
end
check(saw_amt, '5ギル span found')
local out02, ex02 = poss_ui.apply_to_step(ui, g02, line2, q)
check(not out02:find('0/5', 1, true), 'g02 no (0/5): ' .. out02)
check(not out02:find('(0/', 1, true), 'g02 no possession suffix')
eq(#(ex02 or {}), 0, 'g02 no poss extras')

-- 手順文の「10ギル」も金額だけ
local sp_txt = CT.spans(g02.text_ja or '', terms_q)
local saw10
for _, s in ipairs(sp_txt) do
    if s.text == '10ギル' then saw10 = true; eq(s.kind, 'gil', '10ギル is gil') end
end
check(saw10, '10ギル in step text is a gil span')

print('test_gil_270 ok')
