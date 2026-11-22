-- 0.1.222〜0.1.223：同じゾーンに同じ名前の LSB の相手が2つ以上あって、マスの真ん中に残っていた場所を、
-- 文（用語辞典の手順）と LSB（台本・見た目・高さ・名前）で1つに決めて、正確な座標を入れる（dev/sources/exact_pos_222.json）
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local maps = require('src.core.maps')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(app.VERSION, '1.1.300', 'version 0.1.251')
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')
local D = app._data()
eq(D.version, '2026.11.20-125', 'data version')

local function near(loc, x, y, what)
    check(loc and loc.pos, what .. ': has pos')
    if not (loc and loc.pos) then return end
    check(math.abs(loc.pos.x - x) < 0.01 and math.abs(loc.pos.y - y) < 0.01, what .. ': pos ' .. loc.pos.x .. ',' .. loc.pos.y)
end
local function pin_grid(loc)
    local floor = maps.pick_floor(D, loc, nil)
    return floor and maps.pin(floor, loc, 512).grid
end
local function no_pos(loc, what) check(loc and not loc.pos, what .. ': left at grid center') end
local function has(s, pat) return (s or ''):find(pat, 1, true) ~= nil end

-- ボヤーダ樹の Mandragora Warden：「1匹だけでいる方」（Left/Right は2匹並んでいる）
near(D:target('npc.153.Mandragora_Warden').location, 81.981, 139.556, 'Mandragora Warden')
near(D:step('mission.tvr.039#g04').location, 81.981, 139.556, 'Mandragora Warden step')
-- クフタルの洞門：崖の上（qm5、高い）と崖の下（qm6、ゴーストを出す）
near(D:target('obj.174.???_H-8_up').location, -29.195, -183.716, 'Kuftal up')
near(D:target('obj.174.???_H-8_down').location, -27.964, -185.768, 'Kuftal down')
near(D:step('mission.bastok.018#g05').location, -27.964, -185.768, 'Kuftal down step')
-- グロウベルグ〔Ｓ〕：Cetus は北東の qm_cetus、ウォークオブエコーズは Conflux のすぐ横の qm_conflux
near(D:target('obj.グロウベルグ〔Ｓ〕.???_Cetus').location, -127.055, 600.212, 'Cetus')
near(D:target('obj.グロウベルグ〔Ｓ〕.???_WoE').location, -140.635, 583.273, 'WoE')
-- アットワ：ヒューム（見た目 race 2）とタルタル（race 5）
near(D:target('npc.215.Resistance_Fighter_Hume').location, 329.565, -112.974, 'Hume fighter')
near(D:target('npc.215.Resistance_Fighter_Taru').location, 326.112, -107.822, 'Taru fighter')
-- 文のテンキーの所にあるのが1つだけ（ピンが本物の位置に出るので、文のテンキーは外す）
near(D:target('obj.253.Fresh_Snowfall_4').location, 426.25, 183.767, 'Fresh Snowfall 4')
local s = D:step('quest.windurst.005#g05')
near(s.location, -137.289, 150.691, 'Toraimarai numpad 9')
eq(s.next_line_ja, 'トライマライ水路MAP[1](H-7)の???を調べる', 'numpad dropped')
-- 手順ごとに場所がちがう相手：ザルカバード(E-8)の???（Unbridled Passion は qm6、The Three Magi は qm1）
near(D:step('quest.windurst.015#g07').location, -254.883, -150.818, 'Unbridled Passion ???')
near(D:step('quest.windurst.072#g03').location, -335.245, -49.19, 'Three Magi ???')
no_pos(D:target('obj.112.???_E-8').location, 'E-8 ??? target (two spots)')
-- アラパゴ暗礁域(H-10)：「コルセアになるクエストと同じ場所」の手順だけ
near(D:step('mission.tvr.022#g03').location, 468.767, 111.817, 'TVR ??? like the corsair quest')
-- 0.1.223〜：同じミッションの続きの手順（g14・tvr.023 g18）も同じ qm6（Tsukasa が確かめた）。相手はほかのクエストの qm10 もあるのでマスの真ん中のまま
near(D:step('mission.tvr.022#g14').location, 468.767, 111.817, 'TVR later ??? (same qm6)')
near(D:step('mission.tvr.023#g18').location, 468.767, 111.817, 'TVR 023 ??? (same qm6)')
eq(D:step('mission.tvr.022#g14').location.grid, 'H-10', 'TVR ??? label H-10')
no_pos(D:target('obj.54.???_H-10').location, 'Arrapago ??? target (two spots by quest)')
-- 決められないものはマスの真ん中のまま
no_pos(D:target('obj.161.Torch_F-8').location, 'Zvahl torches')
no_pos(D:target('obj.200.???_G-8').location, 'Garlaige ??? (LSB script spot elsewhere)')
no_pos(D:target('obj.15.???_KK').location, 'Abyssea pop spots')

-- 0.1.222 で入れた場所はすべて、場所の文字＝ピンのマス（1マス）
local f = io.open(ROOT .. '/dev/sources/exact_pos_222.json', 'r')
local raw = f and f:read('*a') or ''
if f then f:close() end
local n = 0
for tid in raw:gmatch('"target": "([^"]+)"') do
    local t = D:target(tid)
    if t and t.location and t.location.pos then
        local g = pin_grid(t.location)
        if g then
            eq(t.location.grid, g, 'label = pin: ' .. tid)
            n = n + 1
        end
    end
end
for sid in raw:gmatch('"step": "([^"]+)"') do
    local st = D:step(sid)
    check(st and st.location and st.location.pos, 'step has pos: ' .. sid)
    local g = st and st.location and st.location.pos and pin_grid(st.location)
    if g then
        eq(st.location.grid, g, 'label = pin: ' .. sid)
        check(not has(st.next_line_ja, st.location.grid .. ' テンキー'), 'no numpad on exact place: ' .. sid)
        n = n + 1
    end
end
check(n > 350, 'checked labels: ' .. n)
print('test_exact_pos_222 ok', n)
