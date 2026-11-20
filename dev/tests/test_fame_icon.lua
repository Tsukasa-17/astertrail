-- 0.1.69: 名声を教えてくれる7人のアイコン（自作の赤紫のふきだし）・いちばん下の優先・設定のオン／オフ
require('harness')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local marks = require('src.core.marks')
local fame = require('src.core.fame')
local settings = require('src.core.settings')

local fs = posix_fs()
local D = data_mod.load(fs, ROOT .. '/data/')
local P = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
P:reset({ server = 'catseye', name = 'FameIcon' })

-- いちばん下の優先（ゲートガードより下）
check(marks.ICON_RANK.fame > marks.ICON_RANK.guard, 'fame below guard')
for k, v in pairs(marks.ICON_RANK) do
    if k ~= 'fame' then check(v < marks.ICON_RANK.fame, 'fame lowest vs ' .. k) end
end

-- 7人ぶん、ゾーンと名前のとおり
local NAMES = { Namonutice = 230, Flaco = 236, ['Zabirego-Hajigo'] = 238, Mendi = 245, Waylea = 247, ['Ney Hiparujah'] = 250, Vaultimand = 252 }
local got = {}
for _, w in ipairs(marks.wanted(D, P)) do
    if w.role == 'fame' then
        eq(w.icon, 'fame', 'fame icon ' .. w.name)
        eq(w.zone_id, NAMES[w.name], 'zone of ' .. w.name)
        check(w.quest_id == nil, 'fame is not a quest')
        got[w.name] = (got[w.name] or 0) + 1
    end
end
for n in pairs(NAMES) do eq(got[n], 1, 'one fame mark for ' .. n) end
-- 設定でオフ
for _, w in ipairs(marks.wanted(D, P, { fame = false })) do
    check(w.role ~= 'fame', 'fame off: none')
end

-- 名声の人だけなら名声のアイコン
local m = marks.match(marks.in_zone(marks.wanted(D, P), 245), { { index = 7, name = 'Mendi' } }, {})
local mrow
for _, r in ipairs(m) do if r.name == 'Mendi' then mrow = r end end
check(mrow ~= nil, 'Mendi matched in Lower Jeuno')
if mrow then eq(mrow.icon, 'fame', 'Mendi alone: fame icon'); eq(#mrow.wanted, 1, 'one') end
-- ほかのゾーンでは付けない
local m0 = marks.match(marks.in_zone(marks.wanted(D, P), 230), { { index = 7, name = 'Mendi' } }, {})
eq(#m0, 0, 'Mendi not marked in another zone')
-- 同じ人にクエストの印・ゲートガードがあれば、そちらだけ（名声の印は重ねない）
local m1 = marks.match({
    { role = 'fame', icon = 'fame', name = 'Foo' },
    { role = 'talk', icon = 'sub', name = 'Foo', quest_id = 'q' },
}, { { index = 1, name = 'Foo' } }, {})
eq(m1[1].icon, 'sub', 'quest icon wins')
eq(#m1[1].wanted, 1, 'fame dropped under a quest icon')
local m2 = marks.match({
    { role = 'fame', icon = 'fame', name = 'Foo' },
    { role = 'talk', icon = 'unavailable', name = 'Foo', quest_id = 'q' },
}, { { index = 1, name = 'Foo' } }, {})
eq(m2[1].icon, 'unavailable', 'even unavailable wins over fame')
local m3 = marks.match({
    { role = 'guard', icon = 'guard', name = 'Foo' },
    { role = 'fame', icon = 'fame', name = 'Foo' },
}, { { index = 1, name = 'Foo' } }, {})
eq(m3[1].icon, 'guard', 'guard wins over fame')
-- ほかの相手の並びでも、名声だけの相手はいちばん後ろ
local m4 = marks.match({
    { role = 'fame', icon = 'fame', name = 'A' },
    { role = 'guard', icon = 'guard', name = 'B' },
}, { { index = 1, name = 'A' }, { index = 2, name = 'B' } }, {})
eq(m4[1].icon, 'guard', 'guard row first'); eq(m4[2].icon, 'fame', 'fame row last')

-- 設定：初期はオン、保存のオフは残る
local d = settings.merge({})
eq(d.marks.show_fame_npcs, true, 'default on')
eq(settings.merge({ marks = { show_fame_npcs = false } }).marks.show_fame_npcs, false, 'off kept')

-- 絵：自作の PNG と ImGui の形（赤紫のふきだし＋白い星）
local f = io.open(ROOT .. '/assets/marks/example/fame.png', 'rb')
check(f ~= nil, 'fame.png exists'); if f then f:close() end
local ext = require('src.platform.vanacore_ext')
check(ext.mark_file('fame'):find('fame.png', 1, true) ~= nil, 'ext knows fame.png')
local theme = require('src.ui.theme')
theme.set_look('classic')
check(theme.palette.ic_fame ~= nil, 'ic_fame color')
for _, k in ipairs({ 'npc', 'mob', 'obj', 'gold', 'ic_main', 'ic_sub', 'ic_repeat', 'ic_progress', 'ic_done', 'ic_bad' }) do
    local a, b = theme.palette.ic_fame, theme.palette[k]
    if b then
        local dd = math.abs(a[1] - b[1]) + math.abs(a[2] - b[2]) + math.abs(a[3] - b[3])
        check(dd > 0.3, 'fame color differs from ' .. k .. ' (' .. dd .. ')')
    end
end
local ui_marks = require('src.ui.marks')
local calls, fills = 0, {}
local dl = setmetatable({}, { __index = function (_, name)
    return function (_, a, b, c)
        calls = calls + 1
        if name == 'AddConvexPolyFilled' then fills[#fills + 1] = b end
        if name == 'AddCircleFilled' then fills[#fills + 1] = c end
    end
end })
ui_marks.draw_shape(dl, 'fame', 50, 50, 8)
check(calls >= 10, 'fame shape drawn (' .. calls .. ')')
local fame_u = theme.u32('ic_fame', 1)
local has = false; for _, c in ipairs(fills) do if c == fame_u then has = true end end
check(has, 'filled with the fame color')
-- くり返しの印（本）：丸い矢印2本
local pl = 0
local dl2 = setmetatable({}, { __index = function (_, name)
    return function () if name == 'AddPolyline' then pl = pl + 1 end end
end })
ui_marks.draw_cycle(dl2, 10, 10, 5, 0xFFFFFFFF)
eq(pl, 2, 'cycle icon has two arcs')

-- 言葉：ヒントは「名声を教えてくれる」
local function load_json(p)
    local fh = io.open(p, 'rb'); local s = fh:read('*a'); fh:close()
    return require('src.lib.json').decode(s)
end
local ja = load_json(ROOT .. '/locales/ja.json')
check(tostring(ja['marks.tip.fame']):find('名声を教えてくれる', 1, true) ~= nil, 'tip says it tells fame')
check(ja['marks.icon.fame'] ~= nil and ja['settings.marks_show_fame'] ~= nil, 'icon name and switch label')
check(ja['book.repeat_tip'] ~= nil and ja['book.repeat_again_tip'] ~= nil, 'repeat tips')
local en = load_json(ROOT .. '/locales/en.json')
check(en['marks.tip.fame'] ~= nil and en['settings.marks_show_fame'] ~= nil, 'en keys')
print('test_fame_icon ok')
