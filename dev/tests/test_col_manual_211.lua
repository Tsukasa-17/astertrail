-- 0.1.211：列の幅を自動で合わせる機能をなくし、列の幅は手で変えるだけにした。
-- 行のクリックや窓の中のドラッグで列の幅が変わらない・境をつかんで離したときだけ覚える・表は作り直さない。
-- 0.1.209〜0.1.210 から残すもの：エミネンスの状態の列をなくす・一覧の文字サイズ（表の中でも）・文字サイズの上限は倍
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local book = require('src.ui.book')
local em = require('src.ui.eminence')
local smod = require('src.core.settings')
local imgui = package.loaded['imgui']
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()

rawset(imgui, 'TableSetColumnWidth', false)
rawset(imgui, 'TableGetColumnWidth', false)

-- 自動で合わせる設定は無い。古い保存のキーは読まない
do
    local d = smod.defaults()
    eq(d.book.auto_col_width, nil, 'no auto_col_width default')
    eq(d.book.fit_w, nil, 'no fit_w default')
    local m = smod.merge({ defaults_rev = 8, book = { auto_col_width = true, fit_w = { quest = 500 }, col_widths = { quest = { name = 300 } } } })
    eq(m.book.auto_col_width, nil, 'old auto_col_width ignored')
    eq(m.book.fit_w, nil, 'old fit_w ignored')
    eq(m.book.col_widths.quest.name, 300, 'manual widths kept')
    eq(book.auto_fit_step, nil, 'auto-fit code removed')
    eq(book.dbl_fit_step, nil, 'border double-click fit removed')
    eq(book.sync_col_widths, nil, 'no table rebuild to apply widths')
    eq(app.t('settings.auto_col_width'), 'settings.auto_col_width', 'setting label removed')
end

-- エミネンスの状態の列：並び・隠す・幅から消える
do
    local m = smod.merge({ defaults_rev = 6, eminence = {
        columns = { 'state', 'name', 'action', 'pin', 'fav', 'progress', 'rewards' },
        hidden = { state = true, rewards = true },
    }, book = { col_widths = { eminence = { state = 90, name = 220, action = 80 } } } })
    eq(table.concat(m.eminence.columns, ','), 'name,action,pin,fav,progress,rewards', 'state dropped, custom order kept')
    eq(m.eminence.hidden.state, nil, 'state hidden flag dropped')
    eq(m.eminence.hidden.rewards, true, 'other hidden flag kept')
    eq(m.book.col_widths.eminence.state, nil, 'state width dropped')
    eq(m.book.col_widths.eminence.name, 220, 'name width kept')
    eq(table.concat(smod.defaults().eminence.columns, ','), 'action,pin,fav,name,progress,rewards', 'new default order')
    -- 状態だけ出していた保存：全部隠れたので全部出す
    local only = smod.merge({ eminence = { hidden = { action = true, pin = true, fav = true, name = true, progress = true, rewards = true } } })
    check(next(only.eminence.hidden) == nil, 'all hidden after removal -> show all')
    local keys = em.column_keys(m)
    for _, k in ipairs(keys) do check(k ~= 'state', 'no state key in shown columns') end
end

-- 文字サイズの上限は前の倍、下限と初期値はそのまま
do
    local want = { book = 4.0, list = 3.0, detail = 4.0, tracker = 4.0, eminence = 4.0, map = 4.0, overhead_quest = 3.2, overhead_name = 3.2 }
    local lows = { overhead_quest = 0.8, overhead_name = 0.8 }
    for _, a in ipairs(smod.FONT_AREAS) do
        local lo, hi = smod.font_range(a)
        eq(hi, want[a], 'max doubled: ' .. a)
        eq(lo, lows[a] or 0.7, 'min unchanged: ' .. a)
        eq(smod.defaults().fonts[a], 1.0, 'default unchanged: ' .. a)
        eq(smod.merge({ fonts = { [a] = 9 } }).fonts[a], want[a], 'clamped to the new max: ' .. a)
    end
    eq(smod.FONT_MAX, 4.0, 'other (font_scale) max 400%')
    eq(smod.merge({ font_scale = 3.5 }).font_scale, 3.5, 'other 350% kept')
    eq(smod.merge({ font_scale = 9 }).font_scale, 4.0, 'other clamped to 400%')
    eq(smod.defaults().font_scale, 1.0, 'other default unchanged')
    -- 大きな文字のときの幅：上限 2400、狭い列の目安も文字に合わせる
    eq(smod.COL_WIDTH_MAX, 2400, 'width max raised')
    local big = smod.merge({ fonts = { list = 3.0 }, book = { col_widths = { eminence = { action = 230, pin = 110, name = 1500 } } } })
    eq(big.book.col_widths.eminence.action, 230, 'wide action at 300% is not stale')
    eq(big.book.col_widths.eminence.name, 1500, 'wide name kept')
    local small = smod.merge({ book = { col_widths = { eminence = { action = 230, name = 300 } } } })
    eq(small.book.col_widths.eminence.action, nil, 'at 100% a 230px action still looks stale')
end

-- 見出しのセルで幅を測る（VanaCore の ImGui には TableGetColumnWidth が無い）
local hdr_w = { [0] = 40, [1] = 300, [2] = 150, [3] = 90 }
local col_now = 0
local saved = {}
for _, k in ipairs({ 'TableSetColumnIndex', 'GetContentRegionAvail', 'GetCursorScreenPos', 'IsMouseDown', 'IsMouseDragging', 'GetMousePos', 'IsMouseDoubleClicked' }) do saved[k] = rawget(imgui, k) end
imgui.TableSetColumnIndex = function (i) col_now = i end
imgui.GetCursorScreenPos = function () return 10 + col_now * 1000, 20 end
local in_table = false
imgui.GetContentRegionAvail = function ()
    if in_table then return hdr_w[col_now] or 50, 200 end
    return 700, 260
end
local dirty = 0
local ui = { imgui = imgui, settings = S, t = function (k) return k end, mark_settings_dirty = function () dirty = dirty + 1 end }
local keys = { 'pin', 'name', 'rewards', 'state' }
in_table = true
book.draw_headers(ui, { 'name', 'rewards', 'state' })
in_table = false
local got = book.read_table_col_widths(imgui, keys)
eq(got.pin, 40, 'pin width read from the header cell')
eq(got.name, 300, 'name width read')

-- 行のクリック・窓の中のドラッグ（境をつかんでいない）では覚えない
do
    S.book.col_widths.quest = { name = 222 }
    imgui.IsMouseDown = function () return true end
    imgui.IsMouseDragging = function () return true end
    imgui.GetMousePos = function () return 500, 300 end   -- 境から遠い（行の上）
    for _ = 1, 3 do
        book.paint_col_resize_rails(ui, 4, 10, 20)
        check(not book.capture_col_widths(ui, 'quest', keys), 'click/drag on a row: nothing captured')
    end
    imgui.IsMouseDown = function () return false end
    imgui.IsMouseDragging = function () return false end
    book.paint_col_resize_rails(ui, 4, 10, 20)
    check(not book.capture_col_widths(ui, 'quest', keys), 'release after a row click: nothing captured')
    eq(S.book.col_widths.quest.name, 222, 'saved width untouched by row clicks')
    eq(S.book.col_widths.quest.rewards, nil, 'no new widths from row clicks')
end

-- 境をつかんで動かし、離したときに1回だけ覚える（最後の列は覚えない）
do
    S.book.col_widths.quest = {}
    imgui.IsMouseDown = function () return true end
    imgui.GetMousePos = function () return 10 + 1000 + 300 + 4, 30 end   -- name の右の境
    book.paint_col_resize_rails(ui, 4, 10, 20)
    check(not book.capture_col_widths(ui, 'quest', keys), 'nothing saved while dragging')
    hdr_w[1] = 333
    in_table = true; book.draw_headers(ui, { 'name', 'rewards', 'state' }); in_table = false
    book.capture_col_widths(ui, 'quest', keys)
    imgui.IsMouseDown = function () return false end
    book.paint_col_resize_rails(ui, 4, 10, 20)
    check(book.capture_col_widths(ui, 'quest', keys), 'saved on release')
    eq(S.book.col_widths.quest.name, 333, 'dragged width saved')
    eq(S.book.col_widths.quest.pin, 40, 'other columns saved as they are')
    eq(S.book.col_widths.quest.state, nil, 'last (stretch) column not saved')
    check(not book.capture_col_widths(ui, 'quest', keys), 'only once')
    -- 境のダブルクリックでも自前では幅を変えない
    imgui.IsMouseDoubleClicked = function () return true end
    book.paint_col_resize_rails(ui, 4, 10, 20)
    eq(S.book.col_widths.quest.name, 333, 'double-click on a border changes nothing by itself')
    imgui.IsMouseDoubleClicked = function () return false end
    check(book.near_col_edge(imgui, { 100, 0, 1314, 20 }), 'near an edge: header double-click does not reset the order')
end
for k, v in pairs(saved) do imgui[k] = v end

-- 画面で：行をクリックしても表は作り直さない（ID が変わらない）・幅も変わらない
do
    app.open_window('book')
    FAKE.table = true
    for _, tab in ipairs({ 'mission', 'quest', 'eminence' }) do
        S.book.tab = tab
        S.book.col_widths[tab] = { name = 210 }
        local before = smod.merge({ book = S.book }).book.col_widths[tab]
        FAKE.tables = {}
        frame(); frame()
        local id0 = FAKE.tables[#FAKE.tables] and FAKE.tables[#FAKE.tables].id
        local real_down, real_drag = rawget(imgui, 'IsMouseDown'), rawget(imgui, 'IsMouseDragging')
        for i = 1, 6 do
            imgui.IsMouseDown = function () return i % 2 == 1 end
            imgui.IsMouseDragging = function () return i % 2 == 1 end
            FAKE.mouse_clicked = (i % 2 == 1)
            frame()
        end
        FAKE.mouse_clicked = false
        imgui.IsMouseDown, imgui.IsMouseDragging = real_down, real_drag
        frame()
        local id1 = FAKE.tables[#FAKE.tables] and FAKE.tables[#FAKE.tables].id
        eq(id1, id0, tab .. ': same table id after clicks')
        eq(S.book.col_widths[tab].name, 210, tab .. ': width unchanged by clicks')
        local _ = before
    end
    app.close_window('book')
end

-- 画面で：表の中で一覧の文字の大きさを決める（ImGui の中の子の窓）
do
    for k, v in pairs(saved) do imgui[k] = v end
    rawset(imgui, 'TableSetColumnIndex', nil)
    local after_table, seen = false, {}
    local real_bt = rawget(imgui, 'BeginTable')
    imgui.BeginTable = function (...)
        local r = real_bt(...)
        after_table = true
        return r
    end
    imgui.SetWindowFontScale = function (v) if after_table then seen[#seen + 1] = v end end
    imgui.EndTable = function () after_table = false end
    app.open_window('book')
    FAKE.table = true
    S.book.tab = 'quest'
    S.fonts.book = 1.0
    S.fonts.list = 2.5
    frame(); frame()
    local hit = false
    for _, v in ipairs(seen) do if math.abs(v - 2.5) < 0.001 then hit = true end end
    check(hit, 'list font is set inside the table (rows and header follow it)')
    seen = {}
    S.book.tab = 'eminence'
    frame(); frame()
    local any_roe = false
    for _, tb in ipairs(FAKE.tables or {}) do if tostring(tb.id):find('roe_table', 1, true) then any_roe = true end end
    if any_roe then
        hit = false
        for _, v in ipairs(seen) do if math.abs(v - 2.5) < 0.001 then hit = true end end
        check(hit, 'eminence table gets the list font too')
    end
    -- 400% の本・300% の一覧でもこわれない
    S.fonts.book, S.fonts.list = 4.0, 3.0
    S.book.tab = 'mission'
    frame(); frame()
    S.book.tab = 'quest'
    frame(); frame()
    check(book.table_failed == nil, 'big fonts: table still draws')
    imgui.BeginTable = real_bt
    imgui.SetWindowFontScale = nil
    imgui.EndTable = nil
    S.fonts.book, S.fonts.list = 1.0, 1.0
end
