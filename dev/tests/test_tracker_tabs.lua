-- 0.1.170（t227）：トラッカーの × をいつも見せる・× のオンオフ・パッドの2段・タブ表示
require('fake_env')
local imgui = package.loaded['imgui']
local theme = require('src.ui.theme')
local focus = require('src.ui.focus')
local settings = require('src.core.settings')

-- 1文字 7px で幅を測る（名前を「…」で切るのを確かめる）
local function ulen(s) local n = 0; for _ in tostring(s):gmatch('[%z\1-\127\194-\244][\128-\191]*') do n = n + 1 end; return n end
imgui.CalcTextSize = function (s) return ulen((tostring(s):gsub('##.*$', ''))) * 7, 14 end
imgui.GetStyle = function () return { FramePadding = { x = 4, y = 2 }, ItemSpacing = { x = 8, y = 4 } } end
-- 呼んだ順（× が中身の子の窓より前＝動かない所にあるか）
local seq = {}
local old_child = imgui.BeginChild
imgui.BeginChild = function (id, ...) seq[#seq + 1] = 'child:' .. tostring(id); return true end
local old_small = imgui.SmallButton
imgui.SmallButton = function (label) seq[#seq + 1] = 'btn:' .. tostring(label); return old_small(label) end
local tips = {}
imgui.SetTooltip = function (s) tips[#tips + 1] = s end

-- 設定の初期値と直し
local m = settings.merge({})
eq(m.tracker.show_close, true, 'show_close on by default')
eq(m.tracker.view, 'list', 'list view by default')
eq(settings.merge({ tracker = { view = 'bogus' } }).tracker.view, 'list', 'bad view -> list')
eq(settings.merge({ tracker = { view = 'tabs', show_close = false } }).tracker.view, 'tabs', 'tabs kept')
eq(settings.merge({ tracker = { show_close = false } }).tracker.show_close, false, 'show_close off kept')
eq(settings.merge({ tracker = { align = 'left' } }).tracker.align, 'left', 'align still kept')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local tr = require('src.ui.tracker')
FAKE.player = { name = 'Tabber', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local PR = app._progress()
local D = app._data()
S.input.gamepad = true
S.tracker.visible = true; S.tracker.collapsed = false
local QM, QA, QB = 'mission.sandoria.001', 'quest.bastok.005', 'quest.bastok.011'
for _, q in ipairs({ QA, QB, QM }) do app.request('pin', q) end
frame(); frame()

-- (1) × は上の行（中身の子の窓の前）。窓はスクロールしない（中身の子の窓だけ動く）
seq = {}; frame()
local ix, ic
for i, v in ipairs(seq) do
    if v:find('×##hide', 1, true) then ix = ix or i end
    if v == 'child:##astertrail_tracker_body' then ic = ic or i end
end
check(ix and ic and ix < ic, 'close button before the scrolling body: ' .. table.concat(seq, ' | '))
local fl = FAKE.begin_flags and FAKE.begin_flags['Tracker###astertrail_tracker'] or nil
for k, v in pairs(FAKE.begin_flags or {}) do if k:find('###astertrail_tracker', 1, true) then fl = v end end
local nos = theme.C('ImGuiWindowFlags_NoScrollbar')
check(fl and nos and nos > 0 and math.floor(fl / nos) % 2 == 1, 'tracker window itself does not scroll')
-- 名前・ボタンは中身の子の窓の中
local iq
for i, v in ipairs(seq) do if v:find('##prev_' .. QM, 1, true) then iq = i end end
check(iq and iq > ic, 'entries inside the body')

-- × のオンオフ（オフでもショートカット・コマンドで隠せる）
S.tracker.show_close = false; frame()
check(not labeled('×##hide'), 'no × when turned off')
check(labeled('##q_' .. QM), 'entries still drawn')
check(cmd('/astertrail tracker hide'), 'hide command'); frame()
check(not S.tracker.visible, 'hidden by command')
S.tracker.visible = true; S.tracker.show_close = true; frame()
check(labeled('×##hide'), '× back')
-- 設定画面のスイッチと出し方のボタン
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('tracker'); frame(); frame()
check(labeled('##tr_close') or labeled('tr_close'), 'settings: show close switch')
check(labeled('出し方：一覧##tr_view'), 'settings: layout button (list)')
local tabw = false
for _, l in ipairs(FAKE.labels) do if l:find('tr_tabw', 1, true) then tabw = true end end
check(tabw, 'settings: tab width stepper')
FAKE.clicks['##tr_view'] = true; frame(); frame()
eq(S.tracker.view, 'tabs', 'settings: layout switched to tabs')
FAKE.clicks['##tr_view'] = true; frame(); frame()
eq(S.tracker.view, 'list', 'settings: back to list')
app.close_all(); frame()

-- (2) パッドの2段（一覧）
check(app.enter_tracker(), 'enter tracker')
frame()
eq(focus.current('tracker'), 'e_' .. QM, 'starts on the first entry')
eq(app.state.tracker_level, 'entries', 'entries level')
app.input('down', true, 'key'); app.input('down', false, 'key'); frame()
eq(focus.current('tracker'), 'e_' .. QA, 'down: next entry')
app.input('confirm', true, 'key'); app.input('confirm', false, 'key'); frame()
eq(focus.current('tracker'), 'q_' .. QA, 'confirm: inside on the name')
eq(app.state.tracker_level, 'inside', 'inside level')
eq(app.state.tracker_entry, QA, 'inside QA')
app.input('confirm', true, 'key'); app.input('confirm', false, 'key'); frame(); frame()
check(app.state.open.detail and app.state.detail_quest == QA, 'confirm on the name opens detail')
app.input('back', true, 'key'); app.input('back', false, 'key'); frame()
eq(app.state.active, 'tracker', 'detail closed, back to the tracker')
eq(focus.current('tracker'), 'q_' .. QA, 'still inside after detail')
app.input('back', true, 'key'); app.input('back', false, 'key'); frame()
eq(focus.current('tracker'), 'e_' .. QA, 'cancel: back to the entry')
app.input('back', true, 'key'); app.input('back', false, 'key'); frame()
check(app.state.active ~= 'tracker', 'cancel twice: back to the game')
-- 入り直すと、前にいた件から
app.enter_tracker(); frame()
eq(focus.current('tracker'), 'e_' .. QA, 're-enter on the last entry')
app.release(); frame()

-- (3) タブ表示
S.tracker.view = 'tabs'
app.state.tracker_tab = nil
tips = {}
frame()
for _, q in ipairs(PR:pinned_list()) do check(labeled('##tab_' .. q), 'tab for ' .. q) end
check(labeled('##q_' .. QM) and not labeled('##q_' .. QA), 'only the chosen entry is drawn')
check(labeled('×##hide'), '× on the tab row')
-- 長い名前は「…」で切る（固定幅）。乗せると全部（ツールチップ）
local qb = D:quest(QB)
local full = tr.head_text(qb)
local lab
for _, l in ipairs(FAKE.labels) do if l:find('##tab_' .. QB, 1, true) then lab = l end end
check(lab and lab:find('…', 1, true), 'long name cut: ' .. tostring(lab))
local cut, did = tr.fit_label(imgui, full, 6 * 7)
check(did and ulen(cut) <= 7, 'fit_label cuts to the width')
local s2, d2 = tr.fit_label(imgui, 'AB', 100)
check(s2 == 'AB' and not d2, 'short label kept')
-- タブを押すと切り替え
FAKE.clicks['##tab_' .. QB] = true; frame(); frame()
eq(app.state.tracker_tab, QB, 'clicked tab chosen')
check(labeled('##q_' .. QB) and not labeled('##q_' .. QM), 'chosen entry drawn')
-- パッド（0.1.171〜）：タブ表示は件を選ぶ段がなく、出ている件の中の名前から始まる。LB/RB で替えても中のまま
app.enter_tracker(); frame()
eq(focus.current('tracker'), 'q_' .. QB, 'tabs: starts inside the shown entry, on the quest name')
eq(app.state.tracker_level, 'inside', 'tabs: inside level')
check(focus.shows_frame('tracker'), 'tabs: focus frame shown')
app.input('down', true, 'key'); app.input('down', false, 'key'); frame()
check(focus.current('tracker') ~= 'q_' .. QB and focus.current('tracker'):find(QB, 1, true) ~= nil, 'tabs: down moves inside the entry: ' .. tostring(focus.current('tracker')))
app.input('section_next', true, 'key'); app.input('section_next', false, 'key'); frame()
eq(app.state.tracker_tab, QM, 'RB: next tab wraps to the first')
eq(focus.current('tracker'), 'q_' .. QM, 'RB: on the new entry name')
app.input('section_next', true, 'key'); app.input('section_next', false, 'key'); frame()
eq(app.state.tracker_tab, QA, 'RB: next tab')
eq(focus.current('tracker'), 'q_' .. QA, 'RB: stays inside, on the new entry')
app.input('section_prev', true, 'key'); app.input('section_prev', false, 'key'); frame()
eq(app.state.tracker_tab, QM, 'LB: previous tab')
eq(focus.current('tracker'), 'q_' .. QM, 'LB: inside the new entry')
-- キャンセル1回でゲームへ（件を選ぶ段がないので）
app.input('back', true, 'key'); app.input('back', false, 'key'); frame()
check(app.state.active ~= 'tracker', 'tabs: one cancel returns to the game')
-- もう一度入ると、出ている件の名前から
app.enter_tracker(); frame()
eq(focus.current('tracker'), 'q_' .. QM, 'tabs: re-enter on the shown entry name')
app.input('back', true, 'key'); app.input('back', false, 'key'); frame()
-- 一覧の出し方は今までどおり（件を選ぶ段から）
S.tracker.view = 'list'; frame()
app.enter_tracker(); frame()
check(focus.current('tracker'):sub(1, 2) == 'e_', 'list: still starts on the entries level')
app.input('back', true, 'key'); app.input('back', false, 'key'); frame()
check(app.state.active ~= 'tracker', 'list: cancel at entries returns to the game')
S.tracker.view = 'tabs'; frame()
-- 多いときは ◀▶ で並びを送る（0.1.171〜。選んでいる件は替えない。マウスで押せる）
local more = { 'quest.bastok.001', 'quest.bastok.002', 'quest.bastok.003', 'quest.bastok.004', 'quest.bastok.006',
    'quest.bastok.007', 'quest.bastok.008' }
for _, q in ipairs(more) do app.request('pin', q) end
frame(); frame()
check(labeled('◀##tab_prev') and labeled('▶##tab_next'), 'arrows ◀▶ when the tabs do not fit')
check(not labeled('‹##tab_prev') and not labeled('›##tab_next'), 'old ‹ › are gone')
local function drawn_tabs()
    local out = {}
    for _, l in ipairs(FAKE.labels) do
        local q = l:match('##tab_(.+)$')
        if q and q ~= 'next' and q ~= 'prev' then out[#out + 1] = q end
    end
    return out
end
local n_tabs = #drawn_tabs()
check(n_tabs < #PR:pinned_list(), 'only the tabs that fit are drawn: ' .. n_tabs)
local before = app.state.tracker_tab
local first_before = drawn_tabs()[1]
FAKE.clicks['##tab_next'] = true; frame(); frame()
eq(app.state.tracker_tab, before, '▶ scrolls the row, the chosen entry stays')
check(drawn_tabs()[1] ~= first_before, '▶ scrolled the row by one: ' .. tostring(drawn_tabs()[1]))
eq(drawn_tabs()[1], PR:pinned_list()[2], 'row starts at the 2nd pin')
FAKE.clicks['##tab_prev'] = true; frame(); frame()
eq(drawn_tabs()[1], PR:pinned_list()[1], '◀ scrolls back')
-- 端までは送れない（◀ は先頭で押せない）
for _ = 1, 20 do FAKE.clicks['##tab_next'] = true; frame() end
frame()
local pl = PR:pinned_list()
local dt = drawn_tabs()
eq(dt[#dt], pl[#pl], 'scrolled to the end, the last tab is visible')
-- LB/RB で選ぶと、選んだタブが見えるところまで送る
app.enter_tracker(); frame()
for _ = 1, 3 do app.input('section_next', true, 'key'); app.input('section_next', false, 'key'); frame() end
frame()
check(labeled('##tab_' .. app.state.tracker_tab), 'chosen tab stays visible')
app.input('back', true, 'key'); app.input('back', false, 'key'); frame()
-- タブ表示では ▲▼ を出さない（一覧では出す）
check(not labeled('##up_' .. app.state.tracker_tab) and not labeled('##down_' .. app.state.tracker_tab), 'tabs: no ▲▼')
check(labeled('##prev_' .. app.state.tracker_tab) and labeled('##unpin_' .. app.state.tracker_tab), 'tabs: ◀▶ and the pin stay')
S.tracker.view = 'list'; frame()
check(labeled('##up_' .. QM) and labeled('##down_' .. QM), 'list: ▲▼ still there')
S.tracker.view = 'tabs'; frame()
-- タブの幅の設定（全角の字数。初期 6）：長くすると入るタブが減り、短くすると増える
eq(settings.defaults().tracker.tab_chars, 6, 'tab width default 6')
eq(settings.merge({ tracker = { tab_chars = 99 } }).tracker.tab_chars, 16, 'tab width held to 16')
eq(settings.merge({ tracker = { tab_chars = 1 } }).tracker.tab_chars, 3, 'tab width held to 3')
local n6 = #drawn_tabs()
S.tracker.tab_chars = 12; frame(); frame()
local n12 = #drawn_tabs()
S.tracker.tab_chars = 3; frame(); frame()
local n3 = #drawn_tabs()
check(n12 < n6 and n3 > n6, 'tab width changes how many fit: ' .. n3 .. '/' .. n6 .. '/' .. n12)
S.tracker.tab_chars = 6; frame()
-- ピンを外したタブを選んでいたら、残りの先頭へ
local sel = app.state.tracker_tab
app.request('unpin', sel); frame(); frame()
check(app.state.tracker_tab ~= sel and PR:is_pinned(app.state.tracker_tab), 'unpinned tab falls back')

-- 文字の大きさを変えても、自分で決めた窓の大きさは変えない
local ws = S.windows.tracker
local w0, h0 = ws.w, ws.h
S.fonts.tracker = 1.6; frame(); frame()
eq(ws.w, w0, 'font change keeps width'); eq(ws.h, h0, 'font change keeps height')
S.fonts.tracker = 1.0
-- 一覧に戻すと前と同じ（全部の件、右そろえ・手順の数）
S.tracker.view = 'list'; frame()
for _, q in ipairs(PR:pinned_list()) do check(labeled('##q_' .. q), 'list view draws ' .. q) end
check(not labeled('##tab_'), 'no tabs in list view')
FAKE.events.unload()
check(not printed('present:'), 'no present errors')
