require('harness')
-- 境界の2マス（"H-7/H-8"）: 0.1.53 から。BG Wiki が境界と書いている場所は両方のマスを入れる。
local maps = require('src.core.maps')
local marks = require('src.core.marks')
local data_mod = require('src.core.data')

local c, r = maps.parse_grid('H-8')
eq(c, 7, 'single col'); eq(r, 8, 'single row')
local cells = maps.grid_cells('H-7/H-8')
eq(#cells, 2, 'two cells')
eq(cells[1].col, 7); eq(cells[1].row, 7); eq(cells[2].row, 8)
c, r = maps.parse_grid('H-7/H-8')
eq(c, 7, 'border first col'); eq(r, 7, 'border first row')
check(maps.grid_cells('H-7/xx') == nil, 'bad part -> nil')
check(maps.grid_cells(nil) == nil, 'nil -> nil')

-- 距離はどちらかのマスとの近いほう（周りの8マスまで広げなくても当たる）
eq(marks.grid_dist('H-7/H-8', 'H-8'), 0, 'in second cell')
eq(marks.grid_dist('H-7/H-8', 'H-7'), 0, 'in first cell')
eq(marks.grid_dist('H-7/H-8', 'H-9'), 1, 'next to second')
eq(marks.grid_dist('H-7/H-8', 'H-10'), 2, 'two away')
check(marks.same_grid('H-8', 'H-7/H-8'), 'same either way')

-- ピンは2マスの境目
local p1 = maps.pin(nil, { grid = 'H-7' }, maps.BASE)
local p2 = maps.pin(nil, { grid = 'H-8' }, maps.BASE)
local pb = maps.pin(nil, { grid = 'H-7/H-8' }, maps.BASE)
eq(pb.base_x, p1.base_x, 'border pin x')
eq(pb.base_y, (p1.base_y + p2.base_y) / 2, 'border pin y between')

-- データ: パルブロ鉱山の Old Toolbox は境界（BG Wiki と FFXIclopedia が一致）。
-- 0.1.221〜：正確な座標があるので、その座標のマス H-8 だけになった。座標の無い境界はそのまま（G-8/H-8）
local fs = posix_fs()
local D = data_mod.load(fs, ROOT .. '/data/')
eq(#D.errors, 0, 'data errors')
local s = D:step('quest.bastok.044#g02')
eq(s.location.grid, 'H-8', 'old toolbox: exact square (0.1.221〜)')
local s2 = D:step('quest.aht_urhgan.013#g04')
eq(s2.location.pos, nil, 'no exact pos')
eq(s2.location.grid, 'G-8/H-8', 'border grid kept without exact pos')
