-- 0.1.173（t251）：コンパス・本の上の行の絵のボタン（コンパス・トラッカー・⚙️）・♾️・必要品まとめと「いまここで」をなくした
require('fake_env')
local json = require('src.lib.json')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local compass = require('src.core.compass')
local maps = require('src.core.maps')
local settings = require('src.core.settings')
local D = data_mod.load(posix_fs(), ROOT .. '/data/')

-- マス目の中央 → ゲームの座標は、地図の位置の逆（行って戻ると同じマス）
do
    local floor = maps.floors(D, 230)[1]
    check(floor ~= nil, 'south sandoria floor')
    local x, y = compass.grid_world(floor, { grid = 'J-8' })
    local bx, by = maps.world_px(floor, x, y)
    eq(maps.grid_name(bx, by), 'J-8', 'grid -> world -> grid')
    eq(compass.grid_world(floor, { grid = 'bad' }), nil, 'bad grid')
end

-- 行：いまいるエリアで受けられるものだけ、近い順
local P = progress.new({ data = D })
P:reset({ server = 'catseye', name = 'Test' })
local rows = compass.rows(D, P, { zone_id = 230, x = 0, y = 0 }, {}, {})
check(#rows > 5, 'rows in south sandoria: ' .. #rows)
for i = 2, #rows do
    check(rows[i - 1].dist == nil or rows[i].dist == nil or rows[i - 1].dist <= rows[i].dist, 'sorted by distance')
end
for _, r in ipairs(rows) do
    local q = D:quest(r.qid)
    eq(D:start_zone(q), 230, 'giver in this zone ' .. r.qid)
    check(q.kind ~= 'mission', 'quests only')
    check(r.icon == 'sub' or r.icon == 'repeat', 'takeable icon')
end
local first = rows[1]
check(first.npc and first.npc ~= '', 'giver name')
check(first.approx == true, 'from the grid: approx')
-- 受注中・くり返せない完了は出さない。くり返せる完了は出す
do
    P:set_state(first.qid, 'accepted')
    local r2 = compass.rows(D, P, { zone_id = 230, x = 0, y = 0 }, {}, {})
    for _, r in ipairs(r2) do check(r.qid ~= first.qid, 'accepted not shown') end
    P:set_state(first.qid, 'completed')
    local q = D:quest(first.qid)
    local shown = false
    for _, r in ipairs(compass.rows(D, P, { zone_id = 230, x = 0, y = 0 }, {}, {})) do if r.qid == first.qid then shown = true end end
    eq(shown, q.repeatable == 'yes', 'completed shown only when repeatable')
    P:set_state(first.qid, 'not_accepted')
end
-- 見えている相手がいればその位置（約ではない）
do
    local ents = { { name = first.npc, x = 3, y = 4, dead = false }, { name = first.npc, x = 300, y = 0 } }
    local r3 = compass.rows(D, P, { zone_id = 230, x = 0, y = 0 }, ents, {})
    local hit
    for _, r in ipairs(r3) do if r.qid == first.qid then hit = r end end
    eq(hit.dist, 5, 'nearest visible giver'); eq(hit.approx, false, 'exact'); eq(hit.seen, true, 'seen')
    eq(r3[1].qid, first.qid, 'now first')
    local tt = function (k, p) return k .. (p and p.n and (':' .. p.n) or '') end
    eq(compass.dist_text(tt, hit), 'compass.dist:5', 'exact text')
    eq(compass.dist_text(tt, { dist = 82.4, approx = true }), 'compass.dist_approx:82', 'approx text')
    eq(compass.dist_text(tt, {}), 'compass.dist_unknown', 'unknown text')
end
-- 位置が読めなければ距離なし（行は出す）
do
    local r4 = compass.rows(D, P, { zone_id = 230 }, {}, {})
    eq(#r4, #rows, 'same rows without position')
    eq(r4[1].dist, nil, 'no distance without position')
end
eq(#compass.rows(D, P, { zone_id = nil }, {}, {}), 0, 'no zone, no rows')

-- 表示距離（0.1.201〜）：初期 30 ヤルム。指定した距離以内だけ出す
eq(compass.RANGE_DEFAULT, 30, 'default range 30')
eq(compass.clamp_range(nil), 30, 'nil -> 30')
eq(compass.clamp_range('x'), 30, 'bad -> 30')
eq(compass.clamp_range(7), 5, '7 rounds to 5')
eq(compass.clamp_range(32), 30, '32 rounds to 30')
eq(compass.clamp_range(33), 35, '33 rounds to 35')
eq(compass.clamp_range(1), 5, 'below min')
eq(compass.clamp_range(200), 100, 'above max')
do
    local all = compass.rows(D, P, { zone_id = 230, x = 0, y = 0 }, {}, {})
    local near = compass.rows(D, P, { zone_id = 230, x = 0, y = 0 }, {}, { max_dist = 30 })
    check(#near <= #all, 'range is a subset')
    check(#all > #near, '30 yalms hides some of the zone')
    for _, r in ipairs(near) do
        check(r.dist ~= nil and r.dist <= 30, 'row within 30: ' .. tostring(r.dist))
    end
    -- 距離不明は範囲指定があると出さない
    local none = compass.rows(D, P, { zone_id = 230 }, {}, { max_dist = 30 })
    eq(#none, 0, 'no position: nothing within range')
    -- 見えている相手が近ければ、遠くの資料座標でも出す
    local far
    for _, r in ipairs(all) do if r.dist and r.dist > 30 then far = r; break end end
    check(far ~= nil, 'a quest farther than 30 exists in the zone')
    local close = compass.rows(D, P, { zone_id = 230, x = 0, y = 0 },
        { { name = far.npc, x = 8, y = 0, dead = false } }, { max_dist = 30 })
    local hit
    for _, r in ipairs(close) do if r.qid == far.qid then hit = r end end
    check(hit and hit.dist == 8, 'visible nearby giver is listed even if the recorded point is far')
end

-- 設定：コンパスの窓、なくした設定は保存から消す
do
    local m = settings.merge({ notify = { zone_entry = true, muted_zones = { 230 }, login_resume = false, suppress_in_combat = true },
        windows = { items = { x = 1 }, herenow = { x = 2 } }, compass = { visible = 'yes' } })
    eq(m.notify.zone_entry, nil, 'zone_entry gone'); eq(m.notify.muted_zones, nil, 'muted zones gone')
    eq(m.notify.suppress_in_combat, nil, 'combat switch gone')
    eq(m.notify.login_resume, false, 'login resume kept')
    eq(m.windows.items, nil, 'items window gone'); eq(m.windows.herenow, nil, 'herenow window gone')
    eq(m.compass.visible, false, 'compass visible needs true')
    eq(m.compass.max_dist, 30, 'missing range becomes 30')
    eq(settings.defaults().compass.visible, false, 'compass hidden at first')
    eq(settings.defaults().compass.max_dist, 30, 'default range 30')
    eq(settings.merge({ compass = { visible = true, max_dist = 47 } }).compass.max_dist, 45, '47 rounds to 45')
    eq(settings.merge({ compass = { max_dist = 0 } }).compass.max_dist, 5, '0 clamps to 5')
    eq(settings.merge({ compass = { max_dist = 999 } }).compass.max_dist, 100, '999 clamps to 100')
    eq(settings.defaults().items.show_possession, true, 'possession (2/5) kept')
end

---------------------------------------------------------------------------
-- 本体
---------------------------------------------------------------------------
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local platform = require('src.platform.ashita')
local ents = {}
platform.visible_entities = function () return ents end
FAKE.player = { name = 'Compass', zone = 230, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
frames(1)
local S = app._settings()
check(app.state.ready, 'ready')
eq(S.compass.max_dist, 30, 'app default range 30')
check(not drawn('###astertrail_compass'), 'hidden at first')
-- 既存の一覧の確認は、今までどおりエリア全体が見えるよう一時的に上限を広げる
S.compass.max_dist = 100

-- 本の上の行：コンパス → トラッカー → エミネンス（0.1.177〜）→ ⚙️ → 閉じる（絵だけで、文字は無い）
app.open_window('book'); frame()
for _, id in ipairs({ '##compass_toggle', '##tracker_toggle', '##eminence_toggle', '##open_settings' }) do check(labeled(id), 'icon button ' .. id) end
check(not labeled('必要品まとめ'), 'no items summary button')
check(not labeled('● トラッカー') and not labeled('○ トラッカー'), 'old text tracker button gone')
-- 絵は自分で描く
local icons = require('src.ui.icons')
local drew = {}
for _, k in ipairs({ 'gear', 'compass', 'star', 'checklist' }) do
    local orig = icons[k]
    icons[k] = function (...) drew[k] = (drew[k] or 0) + 1; return orig(...) end
end
frame()
-- 0.1.177〜：トラッカーは金色の星、エミネンスはチェックの紙
check(drew.gear and drew.compass and drew.star and drew.checklist, 'gear, compass, star and checklist drawn')
-- コンパスのボタン
FAKE.clicks['##compass_toggle'] = true; frame(); frame()
eq(S.compass.visible, true, 'compass on from the book')
frames(1.2)
check(drawn('###astertrail_compass'), 'compass window drawn')
check(app.state.compass and #app.state.compass > 0, 'rows built')
local r1 = app.state.compass[1]
check(texted(r1.npc) or labeled(r1.npc), 'giver name shown')
check(texted('約') or texted('~'), 'distance shown')
-- 0.1.177〜：1行目にクエスト名、2行目に依頼者と距離（字下げ）。狭いときは横のスクロールバー
do
    local fl
    for title, f in pairs(FAKE.begin_flags or {}) do if tostring(title):find('###astertrail_compass', 1, true) then fl = f end end
    check(fl and math.floor(fl / 2048) % 2 == 1, 'compass window has a horizontal scrollbar')
    local i0 = FAKE.calls.Indent or 0
    frame()
    check((FAKE.calls.Indent or 0) - i0 >= #app.state.compass, 'second line indented per row')
end
-- 1 秒ごとに作り直す。見えている相手で近くなる
ents = { { name = r1.npc, x = 1, y = 0, dead = false } }
frames(1.2)
eq(app.state.compass[1].dist, 1, 'visible giver used')
-- 距離の設定を変えると、待ち時間を待たずに作り直す
do
    local n100 = #app.state.compass
    S.compass.max_dist = 30
    frame(); frame()
    check(#app.state.compass <= n100, 'tightening the range does not add rows')
    for _, r in ipairs(app.state.compass) do
        check(r.dist ~= nil and r.dist <= 30, 'app rows within 30')
    end
    -- いちばん近い相手（距離 1）は残る
    eq(app.state.compass[1].dist, 1, 'nearest stays after tightening')
    S.compass.max_dist = 100
    frame(); frame()
    eq(#app.state.compass, n100, 'widening the range restores the list')
end
-- 名前を押すと詳細
local q = app._data():quest(app.state.compass[1].qid)
FAKE.clicks[require('src.ui.labels').qname(q)] = true; frame(); frame()
check(app.state.open.detail, 'detail opened from compass')
app.close_window('detail'); frame()
-- 0.1.177〜：コンパスから開いた詳細を閉じても、本は開かない
check(not app.state.open.book, 'closing a detail from the compass does not open the book')
-- 依頼者を押すと、その人の場所の地図（0.1.202〜。本・詳細と同じ）
do
    local row = app.state.compass[1]
    local dq = app._data():quest(row.qid)
    local sl = app._data():start_location(dq)
    check(row.npc and sl and sl.zone_id, 'first row has a giver location')
    check(labeled(row.npc), 'giver name is a link')
    app.state.open.map = false
    FAKE.clicks[row.npc] = true; frame(); frame()
    check(app.state.open.map, 'map opened from giver')
    eq(app.state.map and app.state.map.quest, row.qid, 'map is this quest')
    eq(app.state.map and app.state.map.loc and app.state.map.loc.zone_id, sl.zone_id, 'map uses the giver location')
    check(not app.state.open.detail, 'giver click does not open detail')
    app.close_window('map'); frame()
    check(not app.state.open.map, 'map closed')
    -- 地図がオフのときは、押しても開かない
    S.map.enabled = false; frame(); frame()
    FAKE.clicks[row.npc] = true; frame(); frame()
    check(not app.state.open.map, 'map disabled: giver click does nothing')
    S.map.enabled = true; frame(); frame()
    -- パッド：コンパスを操作中にして、依頼者で決定すると地図
    local focus = require('src.ui.focus')
    app.activate('compass'); frame()
    check(app.operating(), 'compass is operable')
    focus.set('compass', 'npc_' .. row.qid, true)
    press(0x1C); frame(); frame()
    check(app.state.open.map, 'pad confirm on giver opens map')
    eq(app.state.map and app.state.map.quest, row.qid, 'pad map is this quest')
    eq(app.state.map and app.state.map.loc and app.state.map.loc.zone_id, sl.zone_id, 'pad map uses the giver location')
    app.close_window('map'); frame()
    -- キャンセルでゲームに戻る（コンパス自体は出したまま）
    app.activate('compass'); frame()
    press(0x01); frame(); frame()
    check(not app.operating(), 'cancel releases compass')
    eq(S.compass.visible, true, 'cancel does not hide the compass')
end
-- エリアが変わるとすぐ作り直す
FAKE.player.zone = 231; frame(); frame()
for _, r in ipairs(app.state.compass) do eq(app._data():start_zone(app._data():quest(r.qid)), 231, 'rows for the new zone') end
-- コマンド
app.command('/astertrail compass hide'); frame()
eq(S.compass.visible, false, 'hide by command')
check(not drawn('###astertrail_compass'), 'not drawn')
-- 隠しているあいだは作らない
local before = app.state.compass
ents = {}
frames(2)
check(app.state.compass == before, 'not rebuilt while hidden')
app.command('/astertrail compass'); frame()
eq(S.compass.visible, true, 'toggle by command')
-- 窓の大きさは文字の大きさで変わらない
frames(1.2)
local ws = S.windows.compass
local w0, h0 = ws.w, ws.h
S.fonts.tracker = 1.7; frame(); frame()
eq(ws.w, w0, 'width kept'); eq(ws.h, h0, 'height kept')
S.fonts.tracker = 1.0
-- 必要品まとめ・いまここで はもう無い
app.command('/astertrail items'); frame()
check(not drawn('astertrail_items'), 'no items window')
check(app.state.open.items == nil, 'no items state')
check(not drawn('astertrail_herenow'), 'no herenow')
-- ⚙️ で設定
app.open_window('book'); frame()
FAKE.clicks['##open_settings'] = true; frame(); frame()
check(app.state.open.settings, 'gear opens settings')
