-- 0.1.193：見出しのたたみと件数、列の幅、エミネンスの行の色、つかめる線
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local book = require('src.ui.book')
local em = require('src.ui.eminence')
local smod = require('src.core.settings')
local theme = require('src.ui.theme')
local imgui = package.loaded['imgui']
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()

-- 見出しの文言
eq(book.heading_label('南サンドリア', 2, 5), '南サンドリア  (2/5)', 'heading count format')
eq(book.heading_label('x', 0, 0), 'x', 'no count when total is 0')

-- たたみの保存
check(not book.is_collapsed(S, 'quest', 'zone_230'), 'open by default')
check(book.set_collapsed(S, 'quest', 'zone_230', true), 'collapse')
check(book.is_collapsed(S, 'quest', 'zone_230'), 'is collapsed')
check(not book.is_collapsed(S, 'mission', 'zone_230'), 'other tab stays open')
check(book.toggle_collapsed(S, 'quest', 'zone_230'), 'toggle opens')
check(not book.is_collapsed(S, 'quest', 'zone_230'), 'opened')

-- 列の幅：タブごと、16〜800、文字サイズでは変えない（値そのものを覚える）
local m = smod.merge({ book = { col_widths = { mission = { name = 120, bogus = 40, no = 10 }, quest = { name = 3000 } } } })
eq(m.book.col_widths.mission.name, 120, 'width kept')
eq(m.book.col_widths.mission.bogus, nil, 'unknown key dropped')
eq(m.book.col_widths.mission.no, nil, 'too small dropped')
eq(m.book.col_widths.quest.name, nil, 'too big dropped')
eq(type(m.book.col_widths.eminence), 'table', 'eminence widths table present')
eq(book.col_width(m, 'mission', 'name'), 120, 'col_width reads saved px')
check(book.col_width(m, 'quest', 'name') == nil, 'unsaved stays nil (font still applies)')

-- 古いエミネンスの並びに くり返し があっても捨てる
local me = smod.merge({ eminence = { columns = { 'repeat', 'name', 'state' }, hidden = { ['repeat'] = true, name = true } } })
check(me.eminence.columns[1] ~= 'repeat', 'repeat column dropped from order')
local has_repeat = false
for _, k in ipairs(me.eminence.columns) do if k == 'repeat' then has_repeat = true end end
check(not has_repeat, 'no repeat in normalized order')
eq(#me.eminence.columns, 6, 'all eminence columns present (state column removed in 0.1.209)')
eq(me.eminence.hidden['repeat'], nil, 'repeat hidden flag dropped')
eq(me.eminence.hidden.name, true, 'name hidden kept')

-- 0.1.203：エミネンスの初期の並び（受ける・解除、★、お気に入り、名前、進み、報酬、状態）
do
    local want = 'action,pin,fav,name,progress,rewards'
    eq(table.concat(smod.defaults().eminence.columns, ','), want, 'default eminence column order')
    eq(table.concat(smod.EMINENCE_COLUMNS, ','), want, 'EMINENCE_COLUMNS matches default')
    eq(table.concat(smod.merge({}).eminence.columns, ','), want, 'merge empty uses new default')
    local old_def = { 'state', 'name', 'progress', 'rewards', 'pin', 'fav', 'action' }
    local a = smod.merge({ defaults_rev = 3, eminence = { columns = old_def } })
    eq(table.concat(a.eminence.columns, ','), want, 'old default order migrated')
    eq(a.defaults_rev, 8, 'defaults_rev 8 after merge')
    local custom = { 'name', 'state', 'progress', 'rewards', 'pin', 'fav', 'action' }
    local b = smod.merge({ defaults_rev = 3, eminence = { columns = custom } })
    eq(table.concat(b.eminence.columns, ','), 'name,progress,rewards,pin,fav,action', 'dragged order kept (without state)')
    local c = smod.merge({ defaults_rev = 4, eminence = { columns = old_def } })
    eq(table.concat(c.eminence.columns, ','), 'name,progress,rewards,pin,fav,action', 'rev4 old order kept as chosen (without state)')
    local d = smod.merge({ defaults_rev = 3, eminence = { columns = old_def, hidden = { state = true } } })
    eq(table.concat(d.eminence.columns, ','), want, 'migrated order even if a column is hidden')
    eq(d.eminence.hidden.state, nil, 'hidden flag of the removed state column dropped')
    local T = smod.merge({ eminence = { columns = custom, hidden = { rewards = true } } })
    check(em.reset_columns(T), 'reset changed')
    eq(table.concat(T.eminence.columns, ','), want, 'reset returns to new default')
    check(next(T.eminence.hidden) == nil, 'reset clears hidden')
    check(not em.reset_columns(T), 'reset again unchanged')
    eq(table.concat(smod.defaults().book.columns, ','), 'no,name,rewards,state', 'quest/mission columns unchanged')
end

-- 0.1.203：達成済みを非表示は初期オン。前の初期値（オフ）はオンへ。改訂後のオフはそのまま
do
    eq(smod.defaults().eminence.hide_completed, true, 'default hide_completed on')
    eq(smod.merge({}).eminence.hide_completed, true, 'merge empty is on')
    local a = smod.merge({ defaults_rev = 4, eminence = { hide_completed = false } })
    eq(a.eminence.hide_completed, true, 'old default off migrated to on')
    local b = smod.merge({ defaults_rev = 4, eminence = { hide_completed = true } })
    eq(b.eminence.hide_completed, true, 'already on kept')
    local c = smod.merge({ defaults_rev = 5, eminence = { hide_completed = false } })
    eq(c.eminence.hide_completed, false, 'rev5 off kept as chosen')
    local d = smod.merge({ defaults_rev = 5, eminence = { hide_completed = true } })
    eq(d.eminence.hide_completed, true, 'rev5 on kept')
end

-- 受けている行の文字は全部青
eq(em.row_ink('accepted', nil), 'ic_progress', 'accepted ink is blue')
eq(em.row_ink('completed', nil), 'muted', 'completed stays muted')
eq(em.row_ink('not_accepted', nil), 'text', 'not accepted is regular')
eq(em.row_ink('accepted', { why = 'x' }), 'ic_progress', 'accepted stays blue even if failed flag')

-- つかめる線：乗ると左右リサイズのカーソル
do
    local cursors = {}
    local saved = rawget(imgui, 'SetMouseCursor')
    imgui.SetMouseCursor = function (c) cursors[#cursors + 1] = c end
    theme.draw_resize_rail(imgui, 10, 0, 100, true, false)
    check(#cursors > 0, 'hover sets a cursor')
    eq(cursors[1], theme.C('ImGuiMouseCursor_ResizeEW'), 'hover uses ResizeEW')
    cursors = {}
    theme.draw_resize_rail(imgui, 10, 0, 100, false, false)
    eq(#cursors, 0, 'idle does not change the cursor')
    imgui.SetMouseCursor = saved
end

-- 0.1.204：一覧と詳細の境目。GetCursorScreenPos が x, y の2値でも線が出る（y を落とすと線が消えていた）
-- ドラッグ中に当たりを外れても、つかんでいる間は目立つ線のまま。クラシック／YunaUI風の両方
do
    local imgui = package.loaded['imgui']
    local saved = {}
    for _, k in ipairs({
        'GetCursorScreenPos', 'GetItemRectMin', 'GetItemRectMax', 'IsItemHovered', 'IsItemActive',
        'IsMouseDown', 'SetMouseCursor', 'InvisibleButton', 'GetMousePos', 'GetWindowDrawList',
        'GetForegroundDrawList', 'IsMouseDoubleClicked',
    }) do saved[k] = rawget(imgui, k) end
    local function with_look(look, label)
        theme.set_look(look)
        local fills, cursors = {}, {}
        local dl = { AddRectFilled = function (_, a, b, col) fills[#fills + 1] = { a, b, col } end }
        imgui.GetForegroundDrawList = function () return dl end
        imgui.GetWindowDrawList = function () return dl end
        imgui.SetMouseCursor = function (c) cursors[#cursors + 1] = c end
        imgui.InvisibleButton = function () return false end
        imgui.IsMouseDoubleClicked = function () return false end
        imgui.GetMousePos = function () return 500, 200 end
        -- 2値（実機・偽環境と同じ）。表だけ取ると y が無く、線が出なかった
        imgui.GetCursorScreenPos = function () return 400, 80 end
        imgui.GetItemRectMin = function () return nil end
        imgui.GetItemRectMax = function () return nil end
        imgui.IsItemHovered = function () return false end
        imgui.IsItemActive = function () return false end
        imgui.IsMouseDown = function () return false end
        fills = {}
        book.splitter({ imgui = imgui, settings = S, mark_settings_dirty = function () end }, S, 1000, 560, 400)
        check(#fills > 0, 'idle splitter draws a line (' .. label .. ')')
        -- ホバー
        imgui.IsItemHovered = function () return true end
        fills, cursors = {}, {}
        book.splitter({ imgui = imgui, settings = S, mark_settings_dirty = function () end }, S, 1000, 560, 400)
        check(#fills >= 2, 'hover draws highlight and line (' .. label .. ')')
        eq(cursors[1], theme.C('ImGuiMouseCursor_ResizeEW'), 'hover cursor (' .. label .. ')')
        -- ドラッグ中、マウスは当たりの外
        imgui.IsItemHovered = function () return false end
        imgui.IsItemActive = function () return true end
        imgui.IsMouseDown = function () return true end
        imgui.GetMousePos = function () return 800, 200 end
        fills, cursors = {}, {}
        book.splitter({ imgui = imgui, settings = S, mark_settings_dirty = function () end }, S, 1000, 560, 400)
        check(#fills >= 2, 'drag draws highlight even off the hit area (' .. label .. ')')
        eq(cursors[1], theme.C('ImGuiMouseCursor_ResizeEW'), 'drag cursor (' .. label .. ')')
        -- ボタンの矩形があれば、その中央に描く
        imgui.GetItemRectMin = function () return 397, 80 end
        imgui.GetItemRectMax = function () return 403, 480 end
        fills = {}
        book.splitter({ imgui = imgui, settings = S, mark_settings_dirty = function () end }, S, 1000, 560, 400)
        local mid
        for _, f in ipairs(fills) do
            local x1, x2 = f[1][1], f[2][1]
            if math.abs((x1 + x2) / 2 - 400) < 0.6 then mid = true end
        end
        check(mid, 'rail is centered on the splitter (' .. label .. ')')
        imgui.IsItemActive = function () return false end
        imgui.IsMouseDown = function () return false end
        book.splitter({ imgui = imgui, settings = S, mark_settings_dirty = function () end }, S, 1000, 560, 400)
    end
    local prev = theme.look
    with_look('classic', 'classic')
    with_look('yunaui', 'yunaui')
    theme.set_look(prev)
    for k, v in pairs(saved) do imgui[k] = v end
end

-- 列の境：表を閉じたあとに描く。ドラッグ中は当たりを外れてもハイライトを保つ
do
    local imgui = package.loaded['imgui']
    local saved = {}
    for _, k in ipairs({ 'TableGetColumnWidth', 'GetCursorScreenPos', 'GetMousePos', 'IsMouseDown', 'GetForegroundDrawList', 'GetWindowDrawList', 'SetMouseCursor' }) do
        saved[k] = rawget(imgui, k)
    end
    local fills = {}
    local dl = { AddRectFilled = function (_, a, b, col) fills[#fills + 1] = { a, b, col } end }
    imgui.GetForegroundDrawList = function () return dl end
    imgui.GetWindowDrawList = function () return dl end
    imgui.SetMouseCursor = function () end
    imgui.TableGetColumnWidth = function (i) return 80 end
    imgui.GetCursorScreenPos = function () return 10, 300 end
    imgui.GetMousePos = function () return 90, 50 end   -- 最初の境（ox=10 + 80）の上
    imgui.IsMouseDown = function () return true end
    fills = {}
    book.paint_col_resize_rails({ imgui = imgui }, 3, 10, 20)
    eq(#fills, 0, 'column rails are not drawn while the table is open')
    book.flush_col_resize_rails({ imgui = imgui })
    check(#fills >= 2, 'column rails drawn after the table is closed')
    -- マウスを境から外しても、ボタンを離すまではハイライト
    imgui.GetMousePos = function () return 400, 50 end
    imgui.IsMouseDown = function () return true end
    fills = {}
    book.paint_col_resize_rails({ imgui = imgui }, 3, 10, 20)
    book.flush_col_resize_rails({ imgui = imgui })
    check(#fills >= 2, 'column rail stays highlighted during drag off the border')
    imgui.IsMouseDown = function () return false end
    fills = {}
    book.paint_col_resize_rails({ imgui = imgui }, 3, 10, 20)
    book.flush_col_resize_rails({ imgui = imgui })
    -- 離したあとは細い線だけ（ハイライトの下地なしでも線はある）
    check(#fills >= 1, 'idle column rail still draws a line')
    for k, v in pairs(saved) do imgui[k] = v end
end

-- 本の画面：見出しに件数、たためる、列幅をドラッグで覚える
app.open_window('book')
S.book.tab = 'quest'
FAKE.table = true
FAKE.texts, FAKE.labels = {}, {}
frame(); frame()
do
    local has_count
    for _, l in ipairs(FAKE.labels) do
        if l:find('南サンドリア', 1, true) and l:find('%(%d+/%d+%)') then has_count = true end
    end
    for _, l in ipairs(FAKE.texts) do
        if l:find('南サンドリア', 1, true) and l:find('%(%d+/%d+%)') then has_count = true end
    end
    check(has_count, 'quest heading has a count')
end
-- 地域見出しを閉じると、木の下のエリア見出しが隠れ、表は1つのまま
local function count_pat(pat)
    local n = 0
    for _, l in ipairs(FAKE.labels or {}) do
        if type(l) == 'string' and l:find(pat, 1, true) then n = n + 1 end
    end
    return n
end
check(labeled('##sec_quest_sandoria'), 'region heading in the tree')
check(labeled('##sec_quest_sandoria/zone_230') or labeled('##sec_quest_zone_230'), 'area heading in the tree when open')
local twist
for _, l in ipairs(FAKE.labels) do
    if l:find('##tw_sec_quest_sandoria', 1, true) then twist = l; break end
end
check(twist ~= nil, 'region has a twist button: looked in labels')
local zones_open = count_pat('/zone_') + count_pat('##sec_quest_zone_')
FAKE.clicks['##tw_sec_quest_sandoria'] = true; frame(); frame()
if not book.is_collapsed(S, 'quest', 'sandoria') then
    book.set_collapsed(S, 'quest', 'sandoria', true)
end
FAKE.tables, FAKE.labels = {}, {}; frame()
eq(S.book.collapsed.quest['sandoria'], true, 'collapsed state saved')
local ntab, tid
for _, tb in ipairs(FAKE.tables or {}) do
    if type(tb.id) == 'string' and tb.id:find('##astertrail_book_table', 1, true) then
        ntab = (ntab or 0) + 1; tid = tb.id
    end
end
eq(ntab, 1, 'still one shared table after collapse')
check(tid == '##astertrail_book_table' or (tid and tid:find('##astertrail_book_table_g', 1, true)),
    'table id stays the shared one: ' .. tostring(tid))
check(labeled('##sec_quest_sandoria'), 'collapsed heading remains')
check(not labeled('##sec_quest_sandoria/zone_230'), 'child area headings hide in the tree')
local zones_closed = count_pat('/zone_') + count_pat('##sec_quest_zone_')
check(zones_closed < zones_open, 'closed region hides its area headings: ' .. tostring(zones_closed) .. ' < ' .. tostring(zones_open))
FAKE.clicks['##tw_sec_quest_sandoria'] = true; frame(); frame()
eq(S.book.collapsed.quest['sandoria'], nil, 'opened again clears the flag')

-- 列の幅：境をつかんで離したときだけ覚える（0.1.211〜）。文字サイズを変えても、覚えたピクセルはそのまま
S.book.tab = 'mission'
do
    local real = {}
    for _, k in ipairs({ 'IsMouseDown', 'IsMouseDragging', 'GetMousePos', 'GetCursorScreenPos', 'TableGetColumnWidth' }) do real[k] = rawget(imgui, k) end
    imgui.TableGetColumnWidth = function (i) return 80 + i * 10 end
    imgui.GetCursorScreenPos = function () return 0, 200 end
    S.book.col_widths = S.book.col_widths or {}
    S.book.col_widths.mission = {}
    S.book.col_widths.quest = {}
    local u = { imgui = imgui, settings = S, mark_settings_dirty = function () end }
    local keys = { 'pin', 'no', 'name' }
    -- 行の上のドラッグでは覚えない
    imgui.IsMouseDown = function () return true end
    imgui.IsMouseDragging = function () return true end
    imgui.GetMousePos = function () return 400, 50 end
    book.paint_col_resize_rails(u, 3, 0, 0)
    book.capture_col_widths(u, 'mission', keys)
    imgui.IsMouseDown = function () return false end
    imgui.IsMouseDragging = function () return false end
    book.capture_col_widths(u, 'mission', keys)
    eq(S.book.col_widths.mission.pin, nil, 'drag on a row: nothing saved')
    -- 1本目の境（x = 80）をつかんで離す
    imgui.IsMouseDown = function () return true end
    imgui.GetMousePos = function () return 80, 10 end
    book.paint_col_resize_rails(u, 3, 0, 0)
    book.capture_col_widths(u, 'mission', keys)
    eq(S.book.col_widths.mission.pin, nil, 'nothing saved while still dragging')
    imgui.IsMouseDown = function () return false end
    book.capture_col_widths(u, 'mission', keys)
    eq(S.book.col_widths.mission.pin, 80, 'pin width saved on release')
    eq(S.book.col_widths.mission.no, 90, 'no width saved')
    eq(S.book.col_widths.mission.name, nil, 'last (stretch) column not saved')
    S.fonts.book = 1.5
    eq(book.col_width(S, 'mission', 'no'), 90, 'font scale does not change saved px')
    eq(book.col_width(S, 'quest', 'name'), nil, 'other tab unsaved')
    for k, v in pairs(real) do imgui[k] = v end
    book.paint_col_resize_rails(u, 3, 0, 0)
end

-- エミネンス：列チップと同じ行、受けている行の色、分類ごとの表
S.book.tab = 'eminence'
S.eminence.book_root = -2
S.eminence.book_text = ''
S.eminence.book_favs_only = false
em.reset_search()
FAKE.tables, FAKE.texts, FAKE.labels = {}, {}, {}
frame(); frame()
local nroe = 0
for _, tb in ipairs(FAKE.tables or {}) do
    if type(tb.id) == 'string' and tb.id:find('##astertrail_roe_table', 1, true) then
        nroe = nroe + 1
        eq(tb.cols, 6, 'eminence table has 6 columns')
    end
end
-- DAT が無い環境では表は出ない（表の形は test_eminence で見る）
do
    local focus = require('src.ui.focus')
    local function has(id)
        for _, it in ipairs((focus.windows.book and focus.windows.book.list) or {}) do
            if it.id == id then return true end
        end
    end
    check(has('roe_favs_only') and has('roe_hide_done') and has('roe_col_name'), 'view and column chips together')
    local same_row = true
    local rows = {}
    for _, it in ipairs((focus.windows.book and focus.windows.book.list) or {}) do
        if it.id == 'roe_favs_only' or it.id == 'roe_col_name' then rows[#rows+1] = it.row end
    end
    eq(rows[1], 'f2', 'favorites chip on f2')
    eq(rows[2], 'f2', 'column chip on the same row')
end

-- たたんだ分類は保存される（設定の関数。画面の見出しは test_eminence）
check(book.set_collapsed(S, 'eminence', 0xF210, true), 'eminence collapse')
eq(S.book.collapsed.eminence[tostring(0xF210)], true, 'eminence collapse saved')
check(book.set_collapsed(S, 'eminence', 0xF210, false), 'eminence open')
eq(S.book.collapsed.eminence[tostring(0xF210)], nil, 'eminence collapse cleared')
local mcol = smod.merge({ book = { collapsed = { eminence = { ['62000'] = true, skip = false } } } })
eq(mcol.book.collapsed.eminence['62000'], true, 'collapsed migrates')
eq(mcol.book.collapsed.eminence.skip, nil, 'non-true dropped')
eq(type(mcol.book.collapsed.mission), 'table', 'mission collapsed table present')

-- 0.1.205：列幅は列の ID で共有。初期値は名前と報酬が残りを分け、表は一覧の幅に合う
do
    local keys = { 'action', 'pin', 'fav', 'name', 'progress', 'rewards', 'state' }
    local empty = { book = { col_widths = { eminence = {} } } }
    local w = book.plan_col_widths(empty, 'eminence', keys, 640, 1)
    local sum = 0
    for _, k in ipairs(keys) do
        check(type(w[k]) == 'number' and w[k] >= 16, k .. ' has a width')
        sum = sum + w[k]
    end
    check(sum >= 620 and sum <= 640, 'default eminence widths fill the list: ' .. tostring(sum))
    eq(w.action, 76, 'action default is a narrow fixed width')
    eq(w.pin, 36, 'star default is narrow')
    eq(w.fav, 36, 'heart default is narrow')
    eq(w.progress, 58, 'progress default is narrow')
    check(w.name > w.rewards, 'name gets more stretch than rewards')
    check(w.name > 150, 'name is wide')
    check(w.action < 100 and w.pin < 50 and w.fav < 50 and w.progress < 80, 'button columns stay narrow')
    -- どの表でも同じ計算（基礎編と応用編が揃う）
    local w2 = book.plan_col_widths(empty, 'eminence', keys, 640, 1)
    for _, k in ipairs(keys) do eq(w[k], w2[k], 'same plan for every eminence table: ' .. k) end
    -- 保存は列の ID。並びが変わっても名前の幅は名前のまま
    empty.book.col_widths.eminence = { name = 240, action = 80 }
    local w3 = book.plan_col_widths(empty, 'eminence', keys, 640, 1)
    eq(w3.name, 240, 'saved name width stays on name after reorder')
    eq(w3.action, 80, 'saved action width stays on action')
    check(w3.pin == 36 and w3.fav == 36, 'unsaved fixed columns keep defaults')
    -- ミッション・クエストも、名前と報酬が残りを分け、ピンは狭い
    local qkeys = { 'pin', 'name', 'rewards', 'state' }
    local qw = book.plan_col_widths({ book = { col_widths = { quest = {} } } }, 'quest', qkeys, 500, 1)
    eq(qw.pin, 36, 'quest pin is narrow')
    check(qw.state >= 48, 'quest last column (state) fills the remainder')
    check(qw.name > qw.rewards, 'quest name wider than rewards')
    local qsum = qw.pin + qw.name + qw.rewards + qw.state
    check(qsum >= 480 and qsum <= 500, 'quest widths fill the list: ' .. tostring(qsum))
    -- 初期値に戻すと保存は消え、同じ初期幅に戻る
    S.book.col_widths = S.book.col_widths or {}
    S.book.col_widths.eminence = { name = 320, pin = 320 }
    local before_gen = book.col_width_gen('eminence')
    check(book.reset_col_widths(S, 'eminence'), 'reset clears saved eminence widths')
    eq(book.col_width(S, 'eminence', 'name'), nil, 'name width cleared')
    eq(book.col_width(S, 'eminence', 'pin'), nil, 'pin width cleared')
    check(book.col_width_gen('eminence') == before_gen + 1, 'reset bumps table id gen')
    check(book.table_id('##astertrail_roe_table', 'eminence'):find('_g', 1, true),
        'reset changes the table id so ImGui drops stale widths')
    local wr = book.plan_col_widths(S, 'eminence', keys, 640, 1)
    eq(wr.pin, 36, 'after reset star is narrow again')
    check(wr.name > 150 and wr.name ~= 320, 'after reset name is not the old star-sized width')
    -- 覚えた幅（境のドラッグで保存したもの）は、どの表の計算にも同じ値が入る
    S.book.col_widths.eminence = { name = 220, pin = 36 }
    local a = book.plan_col_widths(S, 'eminence', keys, 640, 1)
    local b = book.plan_col_widths(S, 'eminence', keys, 640, 1)
    check(a.name >= 220, 'name keeps the dragged width (leftover may be added to fill the list)')
    eq(a.name, b.name, 'two category tables get the same dragged width')
    eq(a.pin, 36, 'shared store applies pin to every table')
    eq(book.apply_col_widths, nil, '0.1.211: widths are never pushed into ImGui')
end

-- 0.1.205：分類の枠は、閉じたあとも一覧の幅いっぱいにする
do
    local r = { 20, 40, 20 + 250, 80 }   -- 見出しだけの狭いグループ
    local x1, y1, x2, y2 = book.section_bounds(r, 20, 500)
    eq(x1, 20, 'section left is the list pane')
    eq(x2, 520, 'section right spans the full list width, not the heading')
    eq(y1, 40, 'section top from the group')
    eq(y2, 80, 'section bottom from the group')
    local a, _, b, _ = book.section_bounds(r, nil, nil)
    eq(a, 20, 'without a pane width, falls back to the group rect')
    eq(b, 270, 'fallback right')
end

-- 0.1.207：表はタブに1つなので、幅は初めから共有。おかしな保存幅は捨てて初期値へ
do
    local keys = { 'action', 'pin', 'fav', 'name', 'progress', 'rewards', 'state' }
    local stale = { book = { col_widths = { eminence = { pin = 320, name = 80, action = 200, progress = 180 } } } }
    check(book.widths_look_stale(stale, 'eminence', keys), 'narrow columns saved at 160px+ look stale')
    local okw = { book = { col_widths = { eminence = { pin = 36, name = 240, action = 80 } } } }
    check(not book.widths_look_stale(okw, 'eminence', keys), 'reasonable saved widths are kept')
    local merged = smod.merge({ book = { col_widths = { eminence = { pin = 320, name = 80, action = 200 } } } })
    eq(merged.book.col_widths.eminence.pin, nil, 'stale pin width is dropped on load')
    eq(merged.book.col_widths.eminence.action, nil, 'stale action width is dropped on load')
    eq(merged.book.col_widths.eminence.name, nil, 'whole tab falls back to defaults when stale')
    local keep = smod.merge({ book = { col_widths = { eminence = { pin = 40, name = 220 } } } })
    eq(keep.book.col_widths.eminence.pin, 40, 'valid pin width migrates')
    eq(keep.book.col_widths.eminence.name, 220, 'valid name width migrates')
    -- 境をつかんで離したときに覚え、表 ID は変えない（0.1.211〜）
    S.book.col_widths = S.book.col_widths or {}
    S.book.col_widths.eminence = {}
    local u = { imgui = imgui, settings = S, mark_settings_dirty = function () end }
    local saved_pos, saved_cur = rawget(imgui, 'GetMousePos'), rawget(imgui, 'GetCursorScreenPos')
    imgui.GetCursorScreenPos = function () return 0, 200 end
    imgui.TableGetColumnWidth = function (i) return ({ 80, 36, 36, 250, 90, 120, 70 })[i + 1] end
    imgui.IsMouseDown = function () return true end
    imgui.IsMouseDragging = function () return true end
    imgui.GetMousePos = function () return 492, 10 end   -- 進みの右の境
    book.paint_col_resize_rails(u, #keys, 0, 0)
    check(not book.capture_col_widths(u, 'eminence', keys), 'not saved while dragging')
    imgui.IsMouseDown = function () return false end
    imgui.IsMouseDragging = function () return false end
    local dirty = book.capture_col_widths(u, 'eminence', keys)
    check(dirty, 'drag is saved on release')
    eq(S.book.col_widths.eminence.progress, 90, 'changed 進み is stored by column id')
    eq(S.book.col_widths.eminence.name, 250, 'name width stored by id')
    eq(S.book.col_widths.eminence.state, nil, 'last column is not stored')
    eq(book.table_id('##astertrail_roe_table', 'eminence'):find('_w', 1, true), nil, 'drag does not rewrite the table id')
    local plan = book.plan_col_widths(S, 'eminence', keys, 640, 1)
    eq(plan.progress, 90, 'the same table plans the dragged 進み width')
    eq(plan.name, 250, 'the same table plans the dragged name width')
    local before = S.book.col_widths.eminence.name
    imgui.TableGetColumnWidth = function (i) return 300 end
    check(not book.capture_col_widths(u, 'eminence', keys), 'nothing after release')
    eq(S.book.col_widths.eminence.name, before, 'name stays after release')
    book.paint_col_resize_rails(u, #keys, 0, 0)
    imgui.GetMousePos, imgui.GetCursorScreenPos = saved_pos, saved_cur
    imgui.TableGetColumnWidth = function (i) return 80 + i * 10 end
end


-- 0.1.208：見出しの木と、見出しの下の項目
do
    app.open_window('book')
    S.book.tab = 'quest'
    S.book.collapsed = S.book.collapsed or {}
    S.book.collapsed.quest = {}
    local ui = {
        settings = S,
        data = app._data(),
        progress = app._progress(),
        imgui = imgui,
        t = function (k) return k == 'filter.all' and 'すべて' or k end,
        mark_settings_dirty = function () end,
    }
    local list = book.filtered(ui)
    check(#list > 0, 'quest list is not empty')
    local nodes = book.tree_nodes(ui)
    eq(nodes[1] and nodes[1].is_all, true, 'tree starts with すべて')
    local sand, zone
    for _, n in ipairs(nodes) do
        if n.id == 'sandoria' then sand = n end
    end
    for _, ch in ipairs((sand and sand.children) or {}) do
        if ch.id == 'zone_230' or ch.id == 'sandoria/zone_230' or tostring(ch.id):find('zone_230', 1, true) then zone = ch end
    end
    check(sand ~= nil, "San d'Oria region in the tree")
    check(zone ~= nil, 'zone 230 under a region')
    check((zone.indent or 0) > 0, 'area heading is indented')
    local all_rows = book.entries_under_heading(ui, 'all', list)
    eq(#all_rows, #list, 'すべて lists every filtered entry')
    local under = book.entries_under_heading(ui, 'sandoria', list)
    check(#under > 0 and #under <= #list, 'region entries are a subset')
    local zrows = book.entries_under_heading(ui, zone and zone.id or 'sandoria/zone_230', list)
    check(#zrows > 0 and #zrows <= #under, 'area entries are a subset of the region')
    -- 親を選ぶと子の分も含む
    local zset = {}
    for _, q in ipairs(zrows) do zset[q.id] = true end
    local found_child = false
    for _, q in ipairs(under) do if zset[q.id] then found_child = true end end
    check(found_child, 'parent heading includes child entries')
end

app.close_window('book'); frame()
print('test_book_list_193 ok')
