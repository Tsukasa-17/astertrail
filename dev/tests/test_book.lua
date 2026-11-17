-- 本の一覧（1行の表）・本の右側の詳細・ダブルクリックで詳細だけ・出典を出さない・名前の色分け
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local book = require('src.ui.book')
local CT = require('src.ui.colored_text')
local window = require('src.ui.window')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local Q = 'quest.sandoria.001'
local M = 'mission.bastok.001'

-- 既定の大きさは分割に足りる広さ（保存済みの大きさは変えない）
check(window.DEFAULTS.book.w >= 900, 'book default wide enough for split')

-- くり返しの印（0.1.69〜、名前の横の自作の絵）を数える
-- 0.1.173〜：♾️ のような無限の印。0.1.177〜：青い文字の【再】
local cycles = 0
local name_order = {}
do
    local orig = book.repeat_icon
    book.repeat_icon = function (ui, kind) name_order[#name_order + 1] = kind; cycles = cycles + 1; return orig(ui, kind) end
end

for _, use_table in ipairs({ false, true }) do
    FAKE.table = use_table
    book.table_failed = nil
    cmd('/astertrail'); frame()
    -- 0.1.203〜：本は前回のタブを覚える。まだ変えていなければミッション、2周目は閉じる前のクエスト
    if not use_table then
        eq(app._settings().book.tab, 'mission', 'first open is missions')
    else
        eq(app._settings().book.tab, 'quest', 'reopen keeps last tab (0.1.203)')
    end
    app._settings().book.tab = 'quest'; frame(); frame()
    check(app.state.open.book, 'book open')
    -- 見出し・セル（クエストのタブに番号の列は出さない）
    for _, h in ipairs({ 'ピン', '状態', '名前', '報酬' }) do
        check(texted(h) or labeled(h), 'header ' .. h)
    end
    -- リピートの列は無い。詳細の「リピート：可」とは別（0.1.69／0.1.203 で先頭行を選ぶと詳細に出る）
    check(not labeled('リピート'), 'no リピート column (0.1.69)')
    local has_repeat = false
    for _, k in ipairs(S.book.columns or {}) do if k == 'repeat' then has_repeat = true end end
    check(not has_repeat, 'columns do not include repeat')
    check(not texted('番号'), 'no number column on quest tab')
    check(texted('120ギル、ワイルドハンター'), 'rewards cell joined (table=' .. tostring(use_table) .. ')')
    check(texted('商人のお願い'), 'japanese quest name')
    cycles, name_order = 0, {}
    frame()
    check(cycles > 0, 'repeat icon drawn next to names (table=' .. tostring(use_table) .. ')')
    check(#name_order > 0 and name_order[1] == 'yes', 'repeat icon kind yes')
    check(texted('【再】'), 'repeat mark is 【再】 (0.1.177)')
    check(not texted('[品]'), 'no [品] badge in book')
    check(not texted('手順は独自'), 'no source note in UI')
    check(not texted('ピンだけ'), 'no ピンだけ filter')
    check(not texted('次: '), 'no 次 line in book (nothing pinned)')
    -- 0.1.225〜（t497/t498）：ミッション・クエストに地域・状態の選択は無い（地域は木、状態は「表示：」のチェック）
    check(not labeled('##f_area') and not labeled('##f_state'), 'no area/state combos on quest')
    do
        local have = {}
        for _, it in ipairs(require('src.ui.focus').windows.book.list or {}) do have[it.id] = true end
        check(have.show_accepted and have.show_not_accepted and have.show_completed, 'show checks on quest')
    end
    -- 地域がすべてなら、地域ごとの表
    if use_table then
        FAKE.tables = {}
        FAKE.calls.BeginTable = 0
        frame()
        eq(FAKE.calls.BeginTable, 1, 'one table for the whole quest list: ' .. tostring(FAKE.calls.BeginTable))
        local ids = {}
        for _, tb in ipairs(FAKE.tables or {}) do ids[#ids + 1] = tostring(tb.id or '') end
        local joined = table.concat(ids, ',')
        check(joined:find('##astertrail_book_table', 1, true) and not joined:find('zone_230', 1, true),
            'single shared table id: ' .. joined)
        check((FAKE.calls.TableSetupScrollFreeze or 0) >= 1, 'column header is frozen')
        check(labeled('##sec_quest_all') or texted('すべて'), 'all-node at the top of the tree')
        local function zone(region, z)
            return labeled('##sec_quest_' .. region .. '/' .. z) or labeled('##sec_quest_' .. z)
        end
        check(zone('sandoria', 'zone_230') and zone('sandoria', 'zone_231')
            and zone('bastok', 'zone_234') and zone('bastok', 'zone_235')
            and zone('windurst', 'zone_238') and zone('windurst', 'zone_241'),
            'zone headings are in the tree')
        check((texted('南サンドリア') or labeled('南サンドリア')) and (texted('北サンドリア') or labeled('北サンドリア')), 'sandoria zone headings')
        check((texted('バストゥーク鉱山区') or labeled('バストゥーク鉱山区')) and (texted('バストゥーク商業区') or labeled('バストゥーク商業区')), 'bastok zone headings')
        check((texted('ウィンダス森の区') or labeled('ウィンダス森の区')) and (texted('ウィンダス水の区') or labeled('ウィンダス水の区')), 'windurst zone headings')
        for _, tb in ipairs(FAKE.tables or {}) do
            eq(tb.cols, 4, 'quest table has 4 columns (pin name rewards state)')
        end
    end
    -- 地域を絞ると表は一つ、見出しの地域分けはしない
    S.book.filters.area = 'bastok'
    if use_table then FAKE.tables, FAKE.calls.BeginTable = {}, 0 end
    frame()
    if use_table then
        eq(FAKE.calls.BeginTable, 1, 'picked region still uses one table: ' .. tostring(FAKE.calls.BeginTable))
        eq((FAKE.tables[1] or {}).cols, 4, 'still 4 columns')
        check((texted('バストゥーク鉱山区') or labeled('バストゥーク鉱山区')) and (texted('バストゥーク商業区') or labeled('バストゥーク商業区')), 'bastok zone headings when region is picked')
    end
    S.book.filters.area = 'all'
    -- ミッションは番号のセル、地域ごとの表
    S.book.tab = 'mission'
    if use_table then FAKE.tables, FAKE.calls.BeginTable = {}, 0 end
    frame()
    check(texted('番号'), 'number header on mission tab')
    check(texted('BM1-1'), 'mission number cell')
    check(texted('ツェールン鉱山からの報告'), 'japanese mission name')
    check(not texted('BM1-1 ツェールン鉱山からの報告'), 'number and name are separate cells')
    if use_table then
        check(FAKE.calls.BeginTable >= 1, 'mission tables drawn')
        for _, tb in ipairs(FAKE.tables or {}) do
            eq(tb.cols, 5, 'mission tables have 番号 but no リピート column')
        end
    end
    S.book.tab = 'quest'; frame()

    -- 何も選んでいない時は右側に案内
    S.book.last_row = nil; frame()
    check(texted('一覧で選ぶと') or texted('左の一覧で選ぶと'), 'right pane hint')

    -- 1回のクリック（表）／決定（並べたセル）＝ 本の右側に詳細
    if use_table then
        FAKE.clicks['##row_' .. Q] = true; frame(); frame()
    else
        focus.set('book', 'row_' .. Q); press(0x1C); frame(); frame()
    end
    eq(S.book.last_row, Q, 'row selected')
    check(app.state.open.book, 'book stays open')
    check(not app.state.open.detail, 'no separate detail window on single click')
    check(not drawn('###astertrail_detail'), 'detail window not drawn')
    check(labeled('##chk_' .. Q .. '#g01'), 'detail drawn inside the book')
    check(not labeled('##solo'), 'no details-only button')
    check(not labeled('##lock') and not labeled('##cycle'), 'no lock or new-cycle button')
    check(texted('場所: ') and texted('南サンドリア') and texted('E-8'), 'detail heading has start place')
    check(texted('発生NPC: ') and (texted('Parvipon') or labeled('Parvipon')), 'detail heading has start NPC')
    check(texted('リピート：可'), 'repeatable shown as リピート：可')
    check(not texted('資料: リピート'), 'no 資料: リピート label')
    check(not texted('固定する') and not texted('新しい周回') and not texted('詳細だけ表示'), 'removed buttons not shown')
    check(texted('▶ '), 'selected row has a shape mark (not color only)')
    -- 出典は詳細に出さない
    check(not texted('出典'), 'no 出典 heading')
    check(not texted('wiki.ffo.jp'), 'no source url')
    check(not labeled('##copy_'), 'no copy url button')
    -- 手順は本の中で操作できる
    FAKE.clicks['##chk_' .. Q .. '#g01'] = true; frame(); frame()
    check(app.state.open.book and not app.state.open.detail, 'checking a step keeps the split')

    -- ダブルクリック ＝ 詳細だけの窓（本は閉じる）
    if use_table then
        FAKE.double = true; FAKE.clicks['##row_' .. Q] = true; frame(); FAKE.double = false; frame()
    else
        app.open_detail_solo(Q); frame(); frame()
    end
    check(app.state.open.detail, 'standalone detail open')
    check(not app.state.open.book, 'book closed for standalone detail')
    check(drawn('###astertrail_detail'), 'detail window drawn')
    eq(app.state.active, 'detail', 'standalone detail operating')
    check(labeled('##to_book'), 'back-to-book button')
    check(not texted('出典') and not texted('wiki.ffo.jp'), 'no 出典 in standalone detail')
    -- 本に戻る
    FAKE.clicks['##to_book_footer'] = true; frame(); frame()
    check(app.state.open.book and not app.state.open.detail, 'back to book')
    eq(S.book.last_row, Q, 'same quest still selected')
    check(labeled('##chk_' .. Q .. '#g01'), 'detail on the right again')
    -- 詳細だけを閉じると本に戻る（同じものが選ばれた状態）
    app.open_detail_solo(Q); frame(); frame()
    check(app.state.open.detail, 'solo again')
    FAKE.clicks['##back'] = true; frame(); frame()
    check(app.state.open.book and not app.state.open.detail, 'closing standalone returns to the book')
    eq(S.book.last_row, Q, 'same quest still selected after close')
    check(labeled('##chk_' .. Q .. '#g01'), 'detail on the right again')
    eq(app.state.active, 'book', 'book is operating after return')
    -- 詳細だけの窓が出ている時に本を開くと、詳細だけの窓は閉じる
    app.open_detail_solo(Q); frame()
    cmd('/astertrail'); frame()
    check(app.state.open.book and not app.state.open.detail, 'open book closes standalone detail')
    -- 0.1.203〜：開くと前回選んでいた行（またはそのタブの先頭）
    check(S.book.last_row ~= nil, 'a row is selected on open')
    app.select_in_book(Q, true); frame()
    -- 閉じる → トラッカーは残る
    FAKE.clicks['##pin'] = true; frame(); frame()
    FAKE.clicks['##close'] = true; frame(); frame()
    check(not app.state.open.book, 'book closed')
    check(drawn('astertrail_tracker'), 'tracker remains after closing book')
    check(not app.want_keys(), 'tracker alone does not take keys')
    check(not texted('[品]'), 'no [品] on tracker')
    check(texted('商人のお願い') or labeled('商人のお願い'), 'japanese name on tracker')
    -- トラッカーから＝ 詳細だけの窓。閉じても本は開かない
    app.open_detail_solo(M, 'tracker'); frame(); frame()
    check(app.state.open.detail and not app.state.open.book, 'tracker opens standalone detail')
    eq(app.state.detail_quest, M, 'tracker quest in standalone')
    FAKE.clicks['##back'] = true; frame(); frame()
    check(not app.state.open.detail and not app.state.open.book, 'closing tracker-opened detail does not open the book')
    check(not app.want_keys(), 'input released after closing tracker detail')
    app.request('unpin', Q)
    cmd('/astertrail close'); frame()
    S.book.tab = 'quest'
end

-- 表で問題が起きたら、その場で並べたセルに切り替える（Begin/End は崩さない）
FAKE.table = true; FAKE.table_error = true; book.table_failed = nil
cmd('/astertrail'); app._settings().book.tab = 'quest'; frame(); frame()
FAKE.table_error = false
check(book.table_failed ~= nil, 'table failure remembered')
check(texted('120ギル、ワイルドハンター'), 'columns fallback drawn')
cmd('/astertrail close'); frame()
book.table_failed = nil

-- トラッカー：クエスト名は詳細、キャラ名は地図、アイテム名はコピー。行のほかの部分では詳細を開かない。
do
    eq(CT.click_action('npc'), 'map', 'npc click is map')
    eq(CT.click_action('obj'), 'map', 'examine target click is map')
    eq(CT.click_action('object'), 'map', 'object click is map')
    eq(CT.click_action('item'), 'copy', 'item click is copy')
    eq(CT.click_action('key_item'), 'copy', 'key item click is copy')
    eq(CT.click_action('zone'), nil, 'zone is not clickable')
    eq(CT.click_action('mob'), 'map', 'mob click is map (0.1.171〜)')
    local Qm = 'quest.bastok.005'
    local s03 = 'quest.bastok.005#g03'
    app.request('pin', Qm)
    app.request('set_current_step', Qm, s03)
    app.show_tracker(Qm)
    S.tracker.collapsed = false
    S.tracker.visible = true
    frame(); frame()
    check(drawn('astertrail_tracker'), 'mom quest tracker shown')
    check(labeled('ママは冒険者？') or texted('ママは冒険者？'), 'quest name on tracker')
    check(labeled('Roh Latteh'), 'character name is a link')
    check(labeled('カッパーリング'), 'item name is a link')
    -- アイテム名：コピー。詳細は開かない
    app.state.open.detail = false
    app.state.open.map = false
    FAKE.clipboard = nil
    FAKE.clicks['カッパーリング'] = true
    frame()
    eq(FAKE.clipboard, 'カッパーリング', 'item name copied')
    check(not app.state.open.detail, 'item click does not open detail')
    check(not app.state.open.map, 'item click does not open map')
    check(printed('カッパーリング'), 'copied message printed')
    -- キャラ名：地図。詳細は開かない
    app.state.open.detail = false
    app.state.open.map = false
    FAKE.clicks['Roh Latteh'] = true
    frame()
    check(app.state.open.map, 'character click opens map')
    eq(app.state.map and app.state.map.quest, Qm, 'map is this quest')
    eq(app.state.map and app.state.map.step, s03, 'map is this step')
    check(not app.state.open.detail, 'character click does not open detail')
    app.state.open.map = false
    -- クエスト名：詳細
    FAKE.clicks['ママは冒険者？'] = true
    frame()
    check(app.state.open.detail, 'quest name opens detail')
    eq(app.state.detail_quest, Qm, 'detail is this quest')
    check(not app.state.open.book, 'book stays closed')
    FAKE.clicks['##back'] = true; frame(); frame()
    check(not app.state.open.detail, 'closed detail')
    app.request('unpin', Qm)
    cmd('/astertrail close'); frame()
end

-- 調べる対象と ??? は地図。モンスター名は地図を開かない。
do
    local Qe = 'quest.bastok.003'
    local s02 = 'quest.bastok.003#g02'
    app.request('pin', Qe)
    app.request('set_current_step', Qe, s02)
    S.tracker.collapsed = false
    S.tracker.visible = true
    app.state.open.detail = false
    app.state.open.map = false
    frame(); frame()
    check(drawn('astertrail_tracker'), 'examine quest tracker shown')
    check(labeled('???'), '??? is a link')
    FAKE.clicks['???'] = true
    frame()
    check(app.state.open.map, '??? click opens map')
    eq(app.state.map and app.state.map.quest, Qe, 'map is examine quest')
    eq(app.state.map and app.state.map.step, s02, 'map is examine step')
    check(not app.state.open.detail, '??? click does not open detail')
    app.state.open.map = false
    app.request('unpin', Qe)

    local Qh = 'quest.bastok.004'
    local sh = 'quest.bastok.004#g02'
    app.request('pin', Qh)
    app.request('set_current_step', Qh, sh)
    app.state.open.detail = false
    app.state.open.map = false
    frame(); frame()
    check(texted('Greater Quadav') or labeled('Greater Quadav'), 'mob name shown')
    FAKE.clicks['Greater Quadav'] = true
    frame()
    -- 0.1.171〜：モンスター名も地図を開き、近くの同じ名前の相手を探す
    check(app.state.open.map, 'mob click opens the map')
    eq(app.state.map and app.state.map.mob and app.state.map.mob.name, 'Greater Quadav', 'map looks for the monster')
    check(not app.state.open.detail, 'mob click does not open detail')
    app.state.open.map = false
    app.request('unpin', Qh)
    cmd('/astertrail close'); frame()
end

-- ピンがあれば常に表示。隠すのは設定（と同じ内容のコマンド）だけ。
do
    local Qt = 'quest.sandoria.001'
    app.request('pin', Qt)
    S.tracker.visible = true
    frame(); frame()
    check(drawn('astertrail_tracker'), 'pinned tracker always shown')
    S.tracker.visible = false
    frame(); frame()
    check(not drawn('astertrail_tracker'), 'hidden by setting')
    cmd('/astertrail tracker show'); frame(); frame()
    check(S.tracker.visible, 'show sets setting on')
    check(drawn('astertrail_tracker'), 'shown by command')
    cmd('/astertrail tracker hide'); frame(); frame()
    check(not S.tracker.visible, 'hide sets setting off')
    check(not drawn('astertrail_tracker'), 'hidden by command')
    -- 設定をオンに戻しても、ピンが無ければ出ない
    app.request('unpin', Qt)
    S.tracker.visible = true
    frame(); frame()
    check(not drawn('astertrail_tracker'), 'no pins, no tracker')
end

-- 名前の色分け
local D = app._data and app._data() or nil
local data = require('src.core.data')
local fs = posix_fs()
D = data.load(fs, ROOT .. '/data/')
local s2 = D:step(M .. '#g02')
local spans = CT.spans(s2.next_line_ja, CT.step_terms(D, s2))
local got = {}
for _, sp in ipairs(spans) do got[#got + 1] = (sp.color or '-') .. ':' .. sp.text end
eq(table.concat(got, '|'), 'zone:ツェールン鉱山|-:(H-11)の監督官|npc:Makarim|-:に話して報告書を受け取る', 'zone and npc colored')
local s1
for _, st in ipairs(D:quest(Q).steps) do if (st.next_line_ja or ''):find('Parvipon', 1, true) and #st.needs > 0 then s1 = st end end
check(s1, 'step with Parvipon and needs')
spans = CT.spans(s1.next_line_ja, CT.step_terms(D, s1))
got = {}
for _, sp in ipairs(spans) do got[#got + 1] = (sp.color or '-') .. ':' .. sp.text end
check(table.concat(got, '|'):find('item:野兎の毛皮', 1, true), 'item colored: ' .. table.concat(got, '|'))
check(table.concat(got, '|'):find('npc:Parvipon', 1, true), 'npc colored: ' .. table.concat(got, '|'))
-- 名前の無い文はそのまま（付け足さない）
local m1 = D:step(M .. '#g01')
spans = CT.spans(m1.next_line_ja, CT.step_terms(D, m1))
eq(#spans, 1, 'no names -> one plain span'); eq(spans[1].color, nil, 'plain')
eq(spans[1].text, m1.next_line_ja, 'text unchanged')
-- 色の名前は theme にある
local theme = require('src.ui.theme')
for _, k in ipairs({ 'item', 'zone', 'npc' }) do check(theme.palette[k], 'palette ' .. k) end
-- 折り返し（文字の幅が測れる時）
local fake = { CalcTextSize = function (s) local n = 0; for _ in s:gmatch('[%z\1-\127\194-\244][\128-\191]*') do n = n + 1 end; return n * 10, 14 end }
local lines = CT._layout(fake, CT.spans(s2.next_line_ja, CT.step_terms(D, s2)), 100)
check(#lines >= 2, 'wraps')
for _, l in ipairs(lines) do
    local w = 0
    for _, p in ipairs(l) do w = w + fake.CalcTextSize(p.text) end
    check(w <= 100, 'line fits')
end
local joined = {}
for _, l in ipairs(lines) do for _, p in ipairs(l) do joined[#joined + 1] = p.text end end
eq(table.concat(joined), s2.next_line_ja, 'wrap keeps all text')
-- 出典の資料は消していない
check(D:quest(Q).sources and #D:quest(Q).sources > 0, 'sources kept in data')

-- モンスターと調べる場所は、話す NPC とは別の色
local fc = D:quest('quest.bastok.004')
local s_mob
for _, st in ipairs(fc.steps) do
    if (st.next_line_ja or ''):find('Greater Quadav', 1, true) then s_mob = st end
end
check(s_mob, 'step with Greater Quadav')
spans = CT.spans(s_mob.next_line_ja, CT.step_terms(D, s_mob))
got = {}
for _, sp in ipairs(spans) do got[#got + 1] = (sp.color or '-') .. ':' .. sp.text end
local gm = table.concat(got, '|')
check(gm:find('mob:Greater Quadav', 1, true), 'mob has its own color: ' .. gm)
check(gm:find('zone:パルブロ鉱山', 1, true), 'mob step zone colored: ' .. gm)
-- 調べる場所（obj）
local tomb
for _, q in ipairs(D:list()) do
    for _, st in ipairs(q.steps) do
        local tg = D:target(st.target)
        if tg and tg.kind == 'obj' and tg.name_en == 'Tombstone' then
            tomb = st
        end
    end
end
check(tomb, 'step with Tombstone')
local tname = D:target_name(tomb.target)
local tline = '対象: ' .. tname
spans = CT.spans(tline, CT.step_terms(D, tomb))
got = {}
for _, sp in ipairs(spans) do got[#got + 1] = (sp.color or '-') .. ':' .. sp.text end
check(table.concat(got, '|'):find('obj:Tombstone', 1, true), 'obj has its own color: ' .. table.concat(got, '|'))
-- 「???」も調べる対象の色（クリックで地図を開くため）
local qmark
for _, q in ipairs(D:list()) do
    for _, st in ipairs(q.steps) do
        local tg = D:target(st.target)
        if tg and tg.name_en == '???' then qmark = st end
    end
end
check(qmark, 'step with ???')
spans = CT.spans('対象: ??? を調べる', CT.step_terms(D, qmark))
got = {}
for _, sp in ipairs(spans) do got[#got + 1] = (sp.color or '-') .. ':' .. sp.text end
check(table.concat(got, '|'):find('obj:???', 1, true), '??? is obj color: ' .. table.concat(got, '|'))
eq(CT.click_action('obj'), 'map', '??? kind opens map')

-- Orcish Fodder / Ding Bats / Ancient Magical Gizmo に色が付く
local function color_line(sid)
    local st = D:step(sid)
    local q = D:quest_of_step(sid)
    local spans = CT.spans(st.next_line_ja, CT.quest_terms(D, q))
    local got = {}
    for _, sp in ipairs(spans) do got[#got + 1] = (sp.color or '-') .. ':' .. sp.text end
    return table.concat(got, '|'), st.next_line_ja
end
local of, _ = color_line('mission.sandoria.001#g02')
check(of:find('mob:Orcish Fodder', 1, true), 'Orcish Fodder is mob color: ' .. of)
check(of:find('item:オーキシュアクス', 1, true), 'axe colored from later step needs: ' .. of)
local db, _ = color_line('mission.sandoria.002#g03')
check(db:find('mob:Ding Bats', 1, true), 'Ding Bats is mob color: ' .. db)
local ag, _ = color_line('mission.windurst.001#g05')
check(ag:find('obj:Ancient Magical Gizmo', 1, true), 'Ancient Magical Gizmo is obj color: ' .. ag)

-- リピートの列：可、初回クリア後は [再]。ミッション（記載なし）は空
local P = app._progress and app._progress() or nil
-- app may expose progress via state; use a fresh progress if needed
local progress = require('src.core.progress')
local P2 = progress.new({ data = D, max_pins = function () return 10 end })
P2:reset({ server = 'catseye', name = 'Tester' })
eq(book.repeat_cell({ t = function (k) return ({['badge.repeat']='[再]',['book.repeat_yes']='可'})[k] or k end, progress = P2 },
    D:quest('quest.sandoria.001')), '可', 'repeatable shows 可 before clear')
eq(book.repeat_cell({ t = function (k) return ({['badge.repeat']='[再]',['book.repeat_yes']='可'})[k] or k end, progress = P2 },
    D:quest('mission.sandoria.001')), '', 'mission unknown repeat is empty')
P2:set_state('quest.sandoria.001', 'completed')
eq(book.repeat_cell({ t = function (k) return ({['badge.repeat']='[再]',['book.repeat_yes']='可'})[k] or k end, progress = P2 },
    D:quest('quest.sandoria.001')), '[再]', 'repeat mark after first clear')

-- 0.1.69：くり返しの印の種類（資料で可＝yes、初回クリア後＝again、記載なし＝nil）
do
    local P3 = progress.new({ data = D, max_pins = function () return 10 end })
    P3:reset({ server = 'catseye', name = 'Tester3' })
    eq(book.repeat_kind({ progress = P3 }, D:quest('quest.sandoria.001')), 'yes', 'repeat kind yes')
    eq(book.repeat_kind({ progress = P3 }, D:quest('mission.sandoria.001')), nil, 'mission no repeat kind')
    P3:set_state('quest.sandoria.001', 'completed')
    eq(book.repeat_kind({ progress = P3 }, D:quest('quest.sandoria.001')), 'again', 'repeat kind again after clear')
end

-- 選択枠は折り返し分まで足し合わせる
local u = book.union_rect({ 10, 20, 100, 40 }, { 10, 20, 80, 70 })
eq(u[1], 10, 'union x1'); eq(u[2], 20, 'union y1'); eq(u[3], 100, 'union x2'); eq(u[4], 70, 'union y2 taller')
eq(book.union_rect(nil, { 1, 2, 3, 4 })[4], 4, 'union nil')

-- 選択行の背景は行全体に塗る（1行目だけにしない）
FAKE.table = true
FAKE.table_error = false
book.table_failed = nil
if not app.state.open.book then cmd('/astertrail'); frame() end
S.book.last_row = Q
S.book.tab = 'quest'
S.book.filters.area = 'all'
FAKE.calls.TableSetBgColor = 0
FAKE.calls.BeginTable = 0
frame()
check((FAKE.calls.BeginTable or 0) >= 1, 'book table is drawn for row bg test')
check((FAKE.calls.TableSetBgColor or 0) >= 1,
    'selected row uses TableSetBgColor: ' .. tostring(FAKE.calls.TableSetBgColor))

local th_im = {
    CalcTextSize = function (s, a, b, c)
        local n = 0
        for _ in s:gmatch('[%z\1-\127\194-\244][\128-\191]*') do n = n + 1 end
        local wrap = (type(c) == 'number' and c) or (type(b) == 'number' and b) or (type(a) == 'number' and a)
        local line = 14
        if wrap and wrap > 0 then
            local lines = math.max(1, math.ceil((n * 8) / wrap))
            return { x = math.min(n * 8, wrap), y = lines * line }
        end
        return { x = n * 8, y = line }
    end
}
eq(book.text_height(th_im, 'abc', 100), 14, 'short text one line')
check(book.text_height(th_im, string.rep('あいうえお', 20), 80) > 14, 'long text wraps taller')

-- クエスト一覧はリージョンの大枠の中に開始エリア
local ui_g = { settings = { book = { filters = { area = 'all' } }, language = 'ja' }, data = D, t = function (k) return k end }
local glist = D:list('quest')
local gg = book.groups(ui_g, glist)
eq(#gg, 15, 'quests group into 15 regions (0.1.78: アトルガン, 0.1.82: アルタナ, 0.1.93: アビセア, 0.1.102: アドゥリン, 0.1.115: タブナジア)')
eq(gg[1].label, 'サンドリア', 'first region is サンドリア')
eq(gg[2].label, 'バストゥーク', 'second region is バストゥーク')
eq(gg[3].label, 'ウィンダス', 'third region is ウィンダス')
eq(gg[4].label, 'ジュノ', 'fourth region is ジュノ')
eq(gg[5].label, 'セルビナ・マウラ', 'fifth region is セルビナ・マウラ')
eq(gg[6].label, 'ノーグ', 'sixth region is ノーグ')
eq(gg[7].label, 'カザム', 'seventh region is カザム')
eq(gg[8].label, 'ラバオ', 'eighth region is ラバオ')
eq(gg[9].label, 'タブナジア', 'ninth region is タブナジア')
eq(gg[10].label, 'エミネンス・レコード', 'tenth region is エミネンス・レコード')
eq(gg[11].label, 'アトルガン', 'eleventh region is アトルガン')
eq(gg[12].label, 'アルタナ', 'twelfth region is アルタナ')
eq(gg[13].label, 'アビセア', 'thirteenth region is アビセア')
eq(gg[14].label, 'アドゥリン', 'fourteenth region is アドゥリン')
eq(gg[15].label, 'その他', 'fifteenth region is その他')
do local js = {}; for _, a in ipairs(gg[4].children) do js[#js + 1] = a.label end; print('jeuno areas: ' .. table.concat(js, ',')) end
check(#gg[1].children >= 2, 'sandoria has start areas: ' .. tostring(#gg[1].children))
do
    local slabels, south_i, north_i = {}, nil, nil
    for i, a in ipairs(gg[1].children) do
        slabels[#slabels + 1] = a.label
        if a.label == '南サンドリア' then south_i = i end
        if a.label == '北サンドリア' then north_i = i end
    end
    check(south_i and north_i, 'sandoria areas: ' .. table.concat(slabels, ','))
    check(south_i < north_i, 'south before north by zone_id')
end
local alabels = {}
for _, g in ipairs(gg) do
    for _, a in ipairs(g.children or {}) do alabels[#alabels + 1] = a.label end
end
local ajoined = table.concat(alabels, ',')
check(ajoined:find('南サンドリア', 1, true) and ajoined:find('バストゥーク鉱山区', 1, true)
    and ajoined:find('ウィンダス森の区', 1, true), 'area labels: ' .. ajoined)
check(#alabels >= 6, 'start areas in total: ' .. tostring(#alabels))

-- 地域を絞っても、リージョンの枠の中にエリア
ui_g.settings.book.filters.area = 'bastok'
local gb = book.groups(ui_g, (function ()
    local out = {}
    for _, q in ipairs(glist) do if q.category == 'bastok' then out[#out + 1] = q end end
    return out
end)())
eq(#gb, 1, 'one region when filtered')
eq(gb[1].label, 'バストゥーク', 'filtered region label')
check(#gb[1].children >= 2, 'bastok areas: ' .. tostring(#gb[1].children))
do
    local bl = {}
    for _, a in ipairs(gb[1].children) do bl[#bl + 1] = a.label end
    local bj = table.concat(bl, ',')
    check(bj:find('バストゥーク鉱山区', 1, true) and bj:find('バストゥーク商業区', 1, true), 'bastok area labels: ' .. bj)
end

-- 場所と発生NPCの資料
local q1 = D:quest('quest.sandoria.001')
eq(D:start_npc_name(q1), 'Parvipon', 'start NPC English')
eq(D:start_place_text(q1), '南サンドリア (E-8)', 'start place zone and grid')

FAKE.events.unload()
check(not printed('画面の表示で問題'), 'no ui errors: ' .. table.concat(FAKE.printed, ' | '))

-- 0.1.177〜：【再】は青。受けられない理由は ※ に乗せたときだけ（行全体では出さない）
do
    local theme = require('src.ui.theme')
    local hov, drawn_t, tips = false, {}, {}
    local fim = {
        SameLine = function () end,
        TextColored = function (c, s) drawn_t[#drawn_t + 1] = { c = c, s = s } end,
        IsItemHovered = function () return hov end,
        SetTooltip = function (s) tips[#tips + 1] = s end,
    }
    local fui = { imgui = fim, t = function (k) return k end }
    book.repeat_icon(fui, 'yes')
    eq(drawn_t[1].s, 'book.repeat_mark', 'repeat mark text')
    local b = theme.palette.repeat_mark
    check(b and b[3] > b[1] and b[3] > b[2], 'repeat mark color is blue')
    eq(drawn_t[1].c[1], b[1], 'repeat mark drawn in the blue')
    eq(#tips, 0, 'no repeat tooltip without hover')
    drawn_t, tips = {}, {}
    eq(book.cond_icon(fui, { cond = true, tip = { 'A', 'B' } }), false, 'cond mark not hovered')
    eq(drawn_t[1].s, 'book.cond_mark', 'cond mark drawn')
    eq(#tips, 0, 'no reasons without hovering ※')
    hov = true
    eq(book.cond_icon(fui, { cond = true, tip = { 'A', 'B' } }), true, 'cond mark hovered')
    eq(tips[1], 'A\nB', 'reasons on ※ hover')
    drawn_t, tips = {}, {}
    eq(book.cond_icon(fui, { tip = {} }), false, 'no mark without reasons')
    eq(#drawn_t, 0, 'nothing drawn without reasons')
    local src = io.open(ROOT .. '/src/ui/book.lua'):read('*a')
    check(not src:find('row_tooltip', 1, true), 'row-wide reason tooltip removed')
end
