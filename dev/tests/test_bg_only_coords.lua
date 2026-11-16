require('harness')
-- 0.1.55: FFXIclopedia に座標が書いていなかった場所を BG Wiki の座標に（出典はデータの中だけ）
local json = require('src.lib.json')
local data_mod = require('src.core.data')
local D = data_mod.load(posix_fs(), ROOT .. '/data/')
eq(#D.errors, 0, 'data errors')
local function src_ok(list)
    for _, s in ipairs(list or {}) do
        if s.name == 'BG Wiki' and (s.fact_ja or ''):find('FFXIclopedia には座標の記載なし', 1, true) then return true end
    end
    return false
end
local cases = {
    { 'mission.windurst.009#ga01', 'H-8', 'mob.158.Porphyrion', '(H-8)' },
    { 'quest.bastok.045#g06', 'H-9', 'mob.151.Yagudo_Parasite', '(H-9)' },
}
for _, c in ipairs(cases) do
    local s = D:step(c[1])
    check(s, 'step ' .. c[1])
    eq(s.location.grid, c[2], 'grid ' .. c[1])
    check(s.next_line_ja:find(c[4], 1, true), 'line has grid ' .. c[1])
    check(src_ok(s.extra_sources), 'source in data ' .. c[1])
    check(not s.next_line_ja:find('BG Wiki', 1, true), 'no source on screen ' .. c[1])
end
eq(D:target('mob.151.Yagudo_Parasite').location.grid, 'H-9', 'parasite target')
local pv = D:target('mob.193.Polevik')
eq(pv.location.grid, 'H-10', 'polevik target'); check(src_ok(pv.location_sources), 'polevik source')
-- Porphyrion は別のミッション（サンドリア）で FFXIclopedia と食い違うので、対象そのものは変えない
eq(D:target('mob.158.Porphyrion').location.grid, nil, 'porphyrion target unchanged')
-- BG Wiki の座標が別の人・別の場所のものだったので変えない
eq(D:target('npc.天の塔.Kupipi').location.grid, nil, 'kupipi unchanged')
