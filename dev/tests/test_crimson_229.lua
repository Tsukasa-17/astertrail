-- 0.1.229：赤き試練（Sharzalion）手順4の必要品と、ダボイ Storage Hole の LSB 座標
require('harness')
local data_mod = require('src.core.data')
local marks = require('src.core.marks')

local D = data_mod.load(posix_fs(), ROOT .. '/data/')
eq(#D.errors, 0, 'data errors')

local q = D:quest('quest.sandoria.063')
eq(q.name_en, 'The Crimson Trial', 'English name')
eq(q.name_ja_ref, '赤き試練', 'Japanese name')
eq(q.start.target, 'npc.230.Sharzalion', 'starts at Sharzalion')

local s = D:step('quest.sandoria.063#g04')
eq(s.type, 'trade', 'step 4 is a trade')
eq(s.target, 'npc.149.Storage_Hole', 'Storage Hole')
eq(#s.needs, 1, 'one required item')
eq(s.needs[1].name_ja, 'ダボイ貯蔵庫のカギ', 'official JP name from 用語辞典 / DAT')
eq(s.needs[1].item_id, 1103, 'item id from Japanese item DAT')
eq(s.needs[1].kind, 'item', 'regular item (not the key item you receive)')
-- 入手するのはだいじなもの（必要品ではない）
check(s.next_line_ja:find('オーキシュ・ドライフード', 1, true), 'reward key item named in the text')
check(not s.next_line_ja:find('オーキッシュ・ドライフード', 1, true), 'no extra small tsu')

local tg = D:target('npc.149.Storage_Hole')
check(tg ~= nil, 'Storage Hole target exists')
eq(tg.server_id, 17388026, 'LSB npc id')
eq(tg.moves, true, 'moves each game day')
local c = (s.location and s.location.candidates) or (tg.location and tg.location.candidates)
eq(#c, 15, '15 LSB daily positions (not the yaml default at)')
local grids = {}
for _, x in ipairs(c) do
    check(x.pos and x.pos.x ~= nil and x.pos.y ~= nil, 'each candidate has exact pos')
    check(x.grid ~= nil, 'grid from the map, not guessed')
    grids[#grids + 1] = x.grid
end
-- 代表：Zone.lua 先頭と、yaml 初期座標は候補に入れない
eq(c[1].grid, 'E-10', 'first LSB slot is E-10')
eq(c[1].pos.x, -177.925, 'first x')
eq(c[1].pos.y, -255.699, 'first y is FFXI z')
local yaml_default = false
for _, x in ipairs(c) do
    if math.abs((x.pos.x or 0) + 21.260) < 0.01 and math.abs((x.pos.y or 0) + 197.125) < 0.01 then
        yaml_default = true
    end
end
check(not yaml_default, 'yaml initial at is not in the daily list')

local cand = marks.candidates_for(D, s)
eq(cand and #cand, 15, 'map candidates for the step')
