-- 所持（0.1.184〜、t297/t299）：必要な品をすべての入れ物で数える。未確認の入れ物は空にしない
require('fake_env')
local poss = require('src.core.possession')
local data_mod = require('src.core.data')
local i18n = require('src.core.i18n')
local I = i18n.new(posix_fs(), ROOT .. '/locales/')
local t = function (k, v) return I:t(k, v) end

-- 数え方
local all = {}
for _, cid in ipairs(poss.CONTAINERS) do all[cid] = {} end
all[0] = { [1127] = 2 }
all[1] = { [1127] = 3 }
all[3] = { [1127] = 50 }   -- テンポラリ（数えない入れ物）は表に無いので読まれない
local snap = { containers = all, key = function (id) if id == 1091 then return true end return false end }
local need5 = { kind = 'item', item_id = 1127, count = 5, name_ja = '獣神印章' }
local s = poss.need_state(snap, need5)
eq(s.state, 'enough', 'bag 2 + safe 3 = enough'); eq(s.have, 5, 'total 5')
eq(poss.text(t, s), '○', 'enough mark')
eq(poss.where(t, s), 'かばん2・金庫3', 'where tooltip')
check(not poss.CONTAINERS[3] or true, 'list ok')
for _, cid in ipairs(poss.CONTAINERS) do check(cid ~= 3 and cid ~= 17, 'no temporary / recycle: ' .. cid) end
eq(#poss.CONTAINERS, 16, '16 containers (bag, safes, storage, locker, satchel, sack, case, wardrobes 1-8)')

local need10 = { kind = 'item', item_id = 1127, count = 10 }
s = poss.need_state(snap, need10)
eq(s.state, 'short', 'short'); eq(poss.text(t, s), '5/10', 'have/need')
eq(poss.known_count(snap, need10), 5, 'all read: known count')

-- 読めていない入れ物（金庫2・モグロッカー）は空にしない
local part = {}
for k, v in pairs(all) do part[k] = v end
part[9] = false; part[4] = false
local snap2 = { containers = part }
s = poss.need_state(snap2, need10)
eq(s.state, 'short', 'short with unknown')
eq(poss.text(t, s), '5/10（未確認あり）', 'partial text')
eq(poss.where(t, s), 'かばん2・金庫3・金庫2未確認・モグロッカー未確認', 'tooltip shows unloaded as unknown')
eq(poss.known_count(snap2, need10), nil, 'unknown containers: not blocked')
eq(poss.known_count(snap2, need5), 5, 'enough even with unknown parts')
-- 持っていなくて全部読めている：内訳なし
s = poss.need_state(snap, { kind = 'item', item_id = 999, count = 1 })
eq(s.state, 'short', 'none held'); eq(poss.where(t, s), nil, 'no tooltip when not held and all read')
-- 何も読めていない
s = poss.need_state({ containers = {} }, need5)
eq(s.state, 'unknown', 'nothing read: unknown'); eq(poss.text(t, s), '未確認', 'unknown text')
eq(poss.need_state(nil, need5).state, 'unknown', 'no snapshot')
eq(poss.need_state(snap, { kind = 'item', count = 1 }).state, 'unknown', 'no id: unknown (no guess)')
-- だいじなもの
eq(poss.need_state(snap, { kind = 'key_item', key_item_id = 1091 }).state, 'owned', 'key owned')
eq(poss.text(t, poss.need_state(snap, { kind = 'key_item', key_item_id = 5 })), '未所持', 'key missing')
eq(poss.need_state({ containers = all }, { kind = 'key_item', key_item_id = 5 }).state, 'unknown', 'no key data')
eq(poss.known_count(snap, { kind = 'key_item', key_item_id = 5 }), 0, 'key missing = 0')

-- 資料：名前 → 番号（ゲームの DAT から作った data/item_refs.json）
local D = data_mod.load(posix_fs(), ROOT .. '/data/')
check((D.item_ref_count or 0) > 1500, 'needs resolved: ' .. tostring(D.item_ref_count))
local q = D:quest('quest.jeuno.116')
eq(q.steps[1].needs[1].item_id, 1127, '獣神印章 = 1127')
local m = D:quest('mission.acp.008')
eq(m.steps[1].needs[1].key_item_id, 1091, 'シードの紋章 key item')
eq(m.steps[1].needs[1].item_id, nil, 'key item has no item id')
-- 報酬は結ばない
for _, r in ipairs(q.rewards or {}) do eq(r.item_id, nil, 'rewards untouched') end

-- VanaCore の窓口（vana.game.container・key_items）
local ext = require('src.platform.vanacore_ext')
local calls = 0
local function cont(cap, slots)
    local c = { capacity = cap }
    for i, v in pairs(slots or {}) do c[i] = { id = v[1], count = v[2], flags = 0, index = i } end
    return c
end
local CONT = {
    [0] = cont(81, { [0] = { 65535, 123456 }, [1] = { 1127, 2 }, [5] = { 4097, 12 } }),
    [1] = cont(51, { [0] = { 65535, 0 }, [3] = { 1127, 3 } }),
    [2] = cont(1), [3] = cont(51, { [1] = { 1127, 40 } }), [4] = cont(0), [5] = cont(81),
    [6] = cont(1), [7] = cont(81), [8] = cont(81), [9] = cont(51),
    [17] = cont(11, { [1] = { 1127, 9 } }),
}
for i = 10, 16 do CONT[i] = cont(81) end
local bits = {}
for i = 1, 512 do bits[i] = 0 end
bits[math.floor(1091 / 8) + 1] = 2 ^ (1091 % 8)
_G.vana = _G.vana or {}
_G.vana.game = _G.vana.game or {}
_G.vana.game.container = function (i) calls = calls + 1; return CONT[i] end
_G.vana.game.key_items = function () return string.char(unpack(bits)) end
check(ext.can_read_containers(), 'vana container readable')
local cs = ext.read_containers({ 0, 1, 2, 4 })
eq(cs[0][1127], 2, 'bag counted'); eq(cs[0][65535], nil, 'gil slot not counted'); eq(cs[1][1127], 3, 'safe counted')
eq(type(cs[2]), 'table', 'capacity 1: read, no slots'); eq(cs[4], false, 'capacity 0: not loaded (unknown)')
local kf = ext.key_items()
eq(kf(1091), true, 'key bit set'); eq(kf(1090), false, 'key bit clear')
_G.vana.game.key_items = function () return string.rep('\0', 512) end
eq(ext.key_items(), nil, 'all zero: not received yet')
_G.vana.game.key_items = function () return string.char(unpack(bits)) end

-- 本体：毎フレームは読まない。通信が届いたら少し後に 1 回
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local platform = require('src.platform.ashita')
eq(platform.possession_source(), 'vanacore', 'VanaCore source')
check(platform.capabilities().inventory, 'caps inventory on with VanaCore')
FAKE.player = { name = 'Possess', zone = 246, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local snapA = app.possession()
check(snapA ~= nil, 'read once')
eq(snapA.containers[3], nil, 'temporary never read')
eq(snapA.containers[17], nil, 'recycle never read')
local st = app.need_possession({ kind = 'item', item_id = 1127, count = 6 })
eq(st.have, 5, 'bag + safe, not temporary / recycle'); eq(st.state, 'short', 'locker unknown, not enough')
eq(poss.where(t, st), 'かばん2・金庫3・モグロッカー未確認', 'tooltip from live read')
local c0 = calls
frames(2)
eq(calls, c0, 'no per-frame scans')
FAKE.events.packet_in({ id = 0x020, data = string.rep('\0', 20) })
frame(0.1)
eq(calls, c0, 'debounced')
CONT[4] = cont(81, { [2] = { 1127, 1 } })
frames(1)
check(calls > c0, 'rescan after inventory packet')
st = app.need_possession({ kind = 'item', item_id = 1127, count = 6 })
eq(st.state, 'enough', 'locker loaded: enough'); eq(poss.where(t, st), 'かばん2・金庫3・モグロッカー1', 'locker part')
local c1 = calls
frames(6)
check(calls > c1 and calls <= c1 + 16 * 2, 'slow refresh only (every few seconds)')
-- 持っているだけでは済みにしない
local PR = app._progress()
check(app.request('set_state', 'quest.jeuno.116', 'accepted').ok, 'accept')
local cur = PR:current_step('quest.jeuno.116')
CONT[0] = cont(81, { [1] = { 1127, 99 } })
app.on_inventory_packet(0x01F)
frames(2)
eq(PR:current_step('quest.jeuno.116').id, cur.id, 'possession does not advance or complete the step')
eq(PR:state('quest.jeuno.116'), 'accepted', 'still accepted')

-- 詳細：所持の欄と内訳（乗せたとき）
local hovered = true
local imgui = require('imgui')
local saved_hover = imgui.IsItemHovered
local tips = {}
imgui.IsItemHovered = function () return hovered end
imgui.SetTooltip = function (s) tips[#tips + 1] = s end
app.open_detail_solo('quest.jeuno.116'); frame(); frame()
check(texted('所持: '), 'possession label')
check(texted('所持)') or texted('/5所持'), 'enough shows have/need in detail')
local found = false
for _, s2 in ipairs(tips) do if s2:find('かばん99', 1, true) then found = true end end
check(found, 'hover tooltip shows where')
-- 足りない
CONT[0] = cont(81, { [1] = { 1127, 1 } }); CONT[1] = cont(51); CONT[4] = cont(81)
app.on_inventory_packet(0x01F); frames(1); tips = {}
frame(); frame()
check(texted('1/5'), 'have/need in detail')
found = false
for _, s2 in ipairs(tips) do if s2 == 'かばん1' then found = true end end
check(found, 'tooltip when held but short')
-- 設定で消す
S.items.show_possession = false
frame(); frame()
check(not texted('所持: '), 'show_possession off hides it')
S.items.show_possession = true
-- トラッカーにも出る
app.request('pin', 'quest.jeuno.116')
S.tracker.visible = true
frame(); frame()
check(texted('1/5所持') or texted('(1/5所持)'), 'tracker shows inline have/need')
-- アイコン：全部読めていて足りないときだけ「進めない」
local marks_core = require('src.core.marks')
eq(marks_core.quest_icon(app._data(), PR, app._data():quest('quest.jeuno.116'), { have = app.have_for_need }), 'blocked', 'short: blocked icon')
CONT[4] = cont(0)
app.on_inventory_packet(0x01C); frames(1)
eq(marks_core.quest_icon(app._data(), PR, app._data():quest('quest.jeuno.116'), { have = app.have_for_need }), 'progress', 'unknown part: not blocked')
imgui.IsItemHovered = saved_hover
