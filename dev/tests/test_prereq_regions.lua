-- 0.1.174: t261（ランクポイントの条件を外す）・t262（件数0の地域を出さない）・t264（前提の読み取りを広げる）
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local book = require('src.ui.book')
local marks = require('src.core.marks')
local progress = require('src.core.progress')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local D = app.state.data or app._data and app._data()
if not D then D = require('src.core.data').load(posix_fs(), ROOT .. '/data/') end

-- t261：受けられない理由に「ガードにクリスタルをトレード」「ランクポイント」は無い。前のミッションの終了は残す
local hits = 0
for _, q in ipairs(D.quests) do
    for _, r in ipairs(q.lock_reasons or {}) do
        local tx = r.text_ja or ''
        if tx:find('ランクポイント', 1, true) or (tx:find('クリスタル', 1, true) and tx:find('トレード', 1, true)) then
            hits = hits + 1; print('left: ' .. q.id .. ' ' .. tx)
        end
    end
end
eq(hits, 0, 'no crystal-trade / rank-point lock reasons')
eq((D:quest('mission.sandoria.004').lock_reasons[1] or {}).text_ja, '「子供の救助」終了後', 'prereq phrase kept')
eq(#D:quest('mission.bastok.004').lock_reasons, 0, 'reason with only the trade is gone')

-- t264：前提の読み取り
local P = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
P:reset({ server = 'catseye', name = 'Test' })
local function ids(q)
    local out = {}
    for _, g in ipairs(marks.prereq_ids(D, q)) do out[#out + 1] = (g.accept and 'A:' or 'C:') .. table.concat(g, '|') end
    return table.concat(out, ';')
end
local q54 = D:quest('quest.misc.054')
eq(ids(q54), 'C:quest.misc.053', '1回目の「神威」クリア -> 053')
eq(marks.quest_icon(D, P, q54), 'unavailable', 'repeat entry unavailable before the first')
P:set_state('quest.misc.053', 'completed')
eq(marks.quest_icon(D, P, q54), 'repeat', 'repeat icon after the first is done')
P:set_state('quest.misc.053', 'not_accepted')
-- 受けているだけでよい前提
local q53 = D:quest('quest.misc.053')
eq(ids(q53), 'A:mission.zilart.013', 'accepted (or done) is enough')
eq(marks.quest_icon(D, P, q53), 'unavailable', 'not accepted yet')
P:set_state('mission.zilart.013', 'accepted')
check(marks.quest_icon(D, P, q53) ~= 'unavailable', 'available while the mission is accepted')
P:set_state('mission.zilart.013', 'not_accepted')
-- 名前を並べたもの・どれか・打ち消し・2回目から
eq(ids(D:quest('quest.jeuno.132')), 'C:quest.jeuno.027;C:quest.jeuno.061;C:quest.jeuno.051', 'three listed names')
check(ids(D:quest('quest.altana.018')):match('^C:[^;]+|[^;]+|[^;]+$') ~= nil, 'any-of group: ' .. ids(D:quest('quest.altana.018')))
eq(ids(D:quest('quest.windurst.056')), '', '「を受けていないこと」 is not a prereq')
eq(ids(D:quest('quest.selbina_mhaura.012')), '', '「受けていない・クリアしていない」 is not a prereq')
eq(ids(D:quest('quest.bastok.008')), '', '「進行中は受けられない」 is not a prereq')
eq(ids(D:quest('quest.jeuno.134')), '', '「を受けていたら」 is not a prereq')
eq(ids(D:quest('quest.adoulin.033')), '', '「2回目からは」 is not a prereq')
local fake = { id = 'zz', lock_reasons = { { type = 'quest', text_ja = '「' .. q53.name_ja_ref .. '」を持っている' } } }
eq(#marks.prereq_ids(D, fake), 0, 'item-like 「X」を持っている is not a prereq')
local fake2 = { id = 'zz2', lock_reasons = { { type = 'quest', text_ja = '前節「' .. D:quest('mission.sandoria.001').name_ja_ref .. '」クリア' } } }
eq(ids(fake2), 'C:mission.sandoria.001', 'plain brackets + クリア')

-- t262：地域の一覧は、そのタブに1件もない地域を出さない
local cq, cm = book.category_counts(D, 'quest'), book.category_counts(D, 'mission')
check(cq.jeuno and not cm.jeuno, 'jeuno has quests but no missions')
check(cm.promathia and not cq.promathia, 'promathia has missions but no quests')
local function n_with(c) local n = 0; for _, x in ipairs(D.categories) do if c[x.id] then n = n + 1 end end; return n end
app.open_window('book'); frame(); frame()
for _, tab in ipairs({ 'quest', 'mission' }) do
    S.book.tab = tab; S.book.filters.area = 'all'; frame()
    focus.set('book', 'f_area'); frame()
    press(0x1C); frame()
    local dd = focus.dropdown('book')
    check(dd ~= nil, 'area dropdown open on ' .. tab)
    eq(dd and dd.n, 1 + n_with(tab == 'quest' and cq or cm), 'area choices on ' .. tab)
    check(dd and dd.n < 1 + #D.categories, 'some regions hidden on ' .. tab)
    press(0x01); frame()
end
-- 選んでいた地域がこのタブに無ければ「すべて」に戻る
S.book.tab = 'mission'; S.book.filters.area = 'promathia'; frame()
eq(S.book.filters.area, 'promathia', 'kept where it has entries')
S.book.tab = 'quest'; frame()
eq(S.book.filters.area, 'all', 'reset to all on a tab without entries')

-- t265：依頼者の場所（用語辞典の依頼者の行・ゲームのゾーン一覧の名前から）
local function start_loc(qid)
    local q = D:quest(qid); local t = q and q.start and D:target(q.start.target)
    return t and t.location
end
eq((start_loc('quest.sandoria.020') or {}).zone_id, 232, 'Regine: サンドリア港')
eq((start_loc('quest.sandoria.020') or {}).grid, 'J-8', 'Regine: J-8')
eq((start_loc('quest.windurst.005') or {}).zone_id, 242, 'Chumimi: 天の塔')
eq((start_loc('quest.adoulin.028') or {}).zone_id, 284, 'Hestefa: セレニア図書館')
eq((start_loc('quest.windurst.062') or {}).zone_id, 239, 'House of the Hero: ウィンダス石の区')
eq((start_loc('quest.misc.054') or {}).zone_id, 178, '神威 (repeat) giver: ル・アビタウ神殿')
eq(D:zone_name(242), '天の塔', 'zone name for 242')
local nozone = 0
for _, q in ipairs(D.quests) do
    local l = q.kind == 'quest' and start_loc(q.id)
    if l and not l.zone_id then nozone = nozone + 1 end
end
eq(nozone, 0, 'every quest giver with a location has a zone id')
