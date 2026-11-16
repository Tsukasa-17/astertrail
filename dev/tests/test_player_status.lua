-- 0.1.65: ジョブ・レベル・所属国・ランクを読む（VanaCore の vana.game.player、無ければ Ashita の GetPlayer）
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local plat = require('src.platform.ashita')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }

-- ログイン前（0）は読めないことにする
frames(1)
eq(app.state.pstat, nil, 'zero level: not read')
eq(plat.player_status(), nil, 'platform nil before data')

-- Ashita の GetPlayer
FAKE.pstat = { job = 2, level = 40, nation = 1, rank = 3 }
frame()
local ps = app.state.pstat
check(ps ~= nil, 'read after login')
eq(ps.main_job, 2, 'job'); eq(ps.main_job_level, 40, 'level'); eq(ps.nation, 1, 'nation'); eq(ps.rank, 3, 'rank')
eq(ps.source, 'GetPlayer', 'from Ashita')
FAKE.pstat = { job = 2, level = 40, nation = 7, rank = 0 }
ps = plat.player_status()
eq(ps.nation, nil, 'bad nation dropped'); eq(ps.rank, nil, 'rank 0 dropped')

-- VanaCore の公式 API を先に
_G.vana = _G.vana or {}
_G.vana.game = _G.vana.game or {}
local saved = _G.vana.game.player
_G.vana.game.player = function () return { main_job = 4, main_job_level = 12, nation = 2, rank = 1, rank_points = 5 } end
ps = plat.player_status()
eq(ps.source, 'vana.game.player', 'from VanaCore')
eq(ps.main_job, 4, 'vana job'); eq(ps.nation, 2, 'vana nation'); eq(ps.rank, 1, 'vana rank')
_G.vana.game.player = function () return nil end
ps = plat.player_status()
eq(ps.source, 'GetPlayer', 'vana nil: falls back')
_G.vana.game.player = saved

-- /astertrail status に読めた値
FAKE.pstat = { job = 2, level = 40, nation = 1, rank = 3 }
frame()
FAKE.printed = {}
FAKE.events.command({ command = '/astertrail status', blocked = false })
local hit = false
for _, l in ipairs(FAKE.printed) do if l:find('レベル 40', 1, true) and l:find('バストゥーク', 1, true) then hit = true end end
check(hit, 'status shows the read values')
