-- 0.1.210：何も開いていなくても重かった分の直し。
-- 頭上の印の「探す相手」を毎フレーム作らない・4096 件の相手を毎フレーム歩かない・一覧は見えている行だけ描く・重さの計測
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local book = require('src.ui.book')
local perf = require('src.core.perf')
local P = require('src.platform.ashita')
local marks_core = require('src.core.marks')
local marks_ui = require('src.ui.marks')
local imgui = package.loaded['imgui']
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()

-- 計測は初期は切ってある。コマンドで入れる・出す
do
    eq(perf.enabled, false, 'perf off by default')
    check(perf.start() == nil, 'no timing while off')
    cmd('/astertrail debug perf on')
    eq(perf.enabled, true, 'perf on by command')
    for _ = 1, 5 do frame() end
    check(perf.sec.frame and perf.sec.frame.n == 5, 'frames timed')
    check(perf.sec.tick ~= nil, 'tick timed')
    local s = perf.summary()
    check(s:find('frame', 1, true) and s:find('5 frames', 1, true), 'summary: ' .. s)
    FAKE.printed = {}
    cmd('/astertrail debug perf show')
    check(FAKE.printed[#FAKE.printed]:find('[perf]', 1, true), 'show prints the summary')
    cmd('/astertrail debug perf off')
    eq(perf.enabled, false, 'perf off by command')
    local joined = table.concat(FAKE.printed, '\n')
    check(joined:find('[perf]', 1, true), 'off prints the summary')
end

-- 探す相手の一覧は、変わったときだけ作り直す
do
    local real = marks_core.wanted
    local n = 0
    marks_core.wanted = function (...) n = n + 1; return real(...) end
    marks_ui.clear_wanted_cache()
    for _ = 1, 30 do frame() end
    check(n <= 1, 'wanted built at most once over 30 idle frames: ' .. n)
    local before = n
    local PR = app._progress()
    PR:_changed('test', nil)
    frame()
    eq(n, before + 1, 'progress change rebuilds once')
    for _ = 1, 10 do frame() end
    eq(n, before + 1, 'and then stays cached')
    FAKE.player.zone = 231
    frame()
    eq(n, before + 2, 'zone change rebuilds')
    FAKE.player.zone = 230
    frame()
    marks_core.wanted = real
end

-- 4096 件の相手を歩くのは 0.25 秒ごと。その間は見つけた相手だけ読み直す
do
    local names = { [10] = 'Ephinaud', [11] = 'Rongelouts', [300] = '???' }
    local get_name = 0
    local pos = { [10] = 1, [11] = 2, [300] = 3 }
    local ent = {
        GetName = function (_, i) get_name = get_name + 1; return names[i] end,
        GetSpawnFlags = function (_, i) return names[i] and 2 or 0 end,
        GetHealthPercent = function () return 100 end,
        GetStatus = function () return 0 end,
        GetLocalPositionX = function (_, i) return pos[i] end,
        GetLocalPositionY = function () return 0 end,
        GetLocalPositionZ = function () return 0 end,
        GetDistance = function () return 5 end,
    }
    local real_mm = AshitaCore.GetMemoryManager
    AshitaCore.GetMemoryManager = function () return { GetEntity = function () return ent end } end
    P.clear_entity_cache()
    local rows = P.visible_entities()
    eq(#rows, 3, 'full scan finds 3')
    check(get_name >= 4096, 'full scan walks every index: ' .. get_name)
    get_name = 0
    pos[10] = 42
    local rows2 = P.visible_entities()
    eq(get_name, 3, 'between scans only the known rows are read')
    local e10
    for _, r in ipairs(rows2) do if r.index == 10 then e10 = r end end
    eq(e10 and e10.x, 42, 'positions still update every frame')
    names[11] = nil
    rows2 = P.visible_entities()
    eq(#rows2, 2, 'a row that went away is dropped at once')
    FAKE.time = FAKE.time + 0.3
    get_name = 0
    P.visible_entities()
    check(get_name >= 4096, 'full scan again after 0.25s')
    AshitaCore.GetMemoryManager = real_mm
    P.clear_entity_cache()
end

-- 見えている行だけ描く（ImGuiListClipper が無い VanaCore 向け）
do
    -- 表を真似る：行の高さ = max(要求 + 4, 中身 + 4)。カーソルは行の上端 + 2
    local sim = { y = 0, top = nil, minh = 0, content = 0, rows = 0, scroll = 0, view = 300 }
    local function finish()
        if sim.top then sim.y = sim.top + math.max(sim.minh + 4, sim.content + 4) end
    end
    local fake = {
        GetCursorPosY = function () return (sim.top or sim.y) + 2 end,
        GetScrollY = function () return sim.scroll end,
        GetWindowHeight = function () return sim.view end,
        GetFrameHeightWithSpacing = function () return 24 end,
        TableNextRow = function (_, minh)
            finish()
            sim.top = sim.y; sim.minh = tonumber(minh) or 0; sim.content = 0
            sim.rows = sim.rows + 1
        end,
        TableSetColumnIndex = function () end,
    }
    local heights = {}
    for i = 1, 2000 do heights[i] = (i % 7 == 0) and 40 or 20 end
    local function run(scroll, force)
        sim.y, sim.top, sim.rows, sim.scroll = 0, nil, 0, scroll
        local drawn, stripe_ok = {}, true
        book.for_clipped_rows(fake, #heights, function (i)
            book.next_row(fake)
            -- 縞：この行より前に出した行の数の偶奇が、全部描いたときと同じ
            if (sim.rows - 1) % 2 ~= (i - 1) % 2 then stripe_ok = false end
            sim.content = heights[i] - 4
            drawn[#drawn + 1] = i
        end, { key = 'test', sig = 's', scrolling = true, min = 80, force = force })
        finish()
        return drawn, sim.y, stripe_ok
    end
    local total = 0
    for i = 1, #heights do total = total + heights[i] end
    local drawn, h, stripes = run(0)
    check(#drawn < 60, 'only a screenful drawn: ' .. #drawn)
    check(stripes, 'stripe parity kept at the top')
    -- 何度か回すと、測った高さで全体の高さが合う
    for s = 0, total, 300 do run(s) end
    drawn, h, stripes = run(15000)
    check(#drawn < 60, 'only a screenful drawn in the middle: ' .. #drawn)
    check(stripes, 'stripe parity kept in the middle')
    check(math.abs(h - total) <= 2, 'total height matches the full list: ' .. h .. ' vs ' .. total)
    local first = drawn[1]
    local acc = 0
    for i = 1, first - 1 do acc = acc + heights[i] end
    check(acc <= 15000 and acc >= 15000 - 400, 'first drawn row is near the scroll position: ' .. acc)
    -- フォーカスの行（と前後）は、見えていなくても元の場所に描く
    drawn = run(0, { 1500 })
    local has = {}
    for _, i in ipairs(drawn) do has[i] = true end
    check(has[1500] and has[1499] and has[1501], 'focused row and neighbours drawn')
    drawn, h = run(0, { 1500 })
    check(math.abs(h - total) <= 2, 'forced rows keep the total height: ' .. h)
    -- 縦に動かない表・少ない行は全部描く
    local n = 0
    book.for_clipped_rows(fake, 50, function () n = n + 1 end, { key = 'test2', scrolling = true })
    eq(n, 50, 'short lists draw all rows')
    n = 0
    book.for_clipped_rows(fake, 500, function () n = n + 1 end, { key = 'test3', scrolling = false })
    eq(n, 500, 'non-scrolling tables draw all rows')
end

print('test_perf_210 ok')
