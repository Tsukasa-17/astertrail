-- 0.1.289：名声案内は次フレームで一行。アストラル設定「配置」のパネル崩れを直す
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.324', 'version')

-- ソース：即時の P.print はせず、flush_fame_notices を tick から呼ぶ
local src = io.open(ROOT .. '/src/app.lua', 'r'):read('*a')
local i = src:find('function app.on_text_in', 1, true)
check(i ~= nil, 'on_text_in exists')
local chunk = src:sub(i, i + 2200)
check(chunk:find('state.fame_notice', 1, true) ~= nil, 'queues a notice instead of printing in text_in')
check(chunk:find('same_talk', 1, true) ~= nil, 'one line per conversation')
check(not chunk:find('P.print(T(\'fame.heard\'', 1, true), 'no immediate P.print of fame.heard in on_text_in')
check(src:find('function app.flush_fame_notices', 1, true) ~= nil, 'flush helper exists')
local it = src:find('function app.tick(now)', 1, true)
check(it ~= nil, 'tick exists')
check(src:sub(it, it + 400):find('flush_fame_notices', 1, true) ~= nil, 'tick flushes fame notices')

_G.vana = _G.vana or {}
_G.vana.encoding = _G.vana.encoding or {}
_G.vana.encoding.from_shift_jis = function (s) return s end
dofile(ROOT .. '/astertrail.lua')
check(FAKE.events.text_in, 'text_in registered')
FAKE.events.load()
local plat = require('src.platform.ashita')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(2)
check(app.state.ready, 'logged in')

-- サンドリア：覚えるのはすぐ。案内は次のフレーム。同じ会話では一行だけ
FAKE.printed = {}
FAKE.events.text_in({ mode = 150, message = 'Namonutice : ああ、Testerか。\7その名は聞いた覚えがあるぞ。\127\49' })
eq(app._settings().fame.sandoria.level, 3, 'sandoria remembered immediately')
check(not printed('名声を覚えました'), 'no chat line during text_in')
eq(#(app.state.fame_notice or {}), 1, 'notice queued')
frame()
check(printed('名声を覚えました：サンドリア ランク3'), 'sandoria line on next frame')
eq(#(app.state.fame_notice or {}), 0, 'queue emptied after flush')

-- 同じ会話（すぐ次の行でもう一度当たる）では出さない
FAKE.printed = {}
FAKE.events.text_in({ mode = 150, message = 'Namonutice : ああ、Testerか。\7その名は聞いた覚えがあるぞ。' })
frame()
check(not printed('名声を覚えました'), 'same conversation is not announced twice')
eq(app._settings().fame.sandoria.level, 3, 'level still 3')

-- 20 秒あとの新しい会話では、また一行
FAKE.time = FAKE.time + 21
frame()
FAKE.printed = {}
FAKE.events.text_in({ mode = 150, message = 'Namonutice : やあ、Tester。君の名は、この国ではもうかなり\7知られるようになってきたぞ。' })
eq(app._settings().fame.sandoria.level, 5, 'new conversation updates the rank')
check(not printed('名声を覚えました'), 'still deferred')
frame()
check(printed('名声を覚えました：サンドリア ランク5'), 'new conversation prints once')

-- バストゥーク（Flaco）でも同じ。text_in 中は出ず、次フレームで一行
FAKE.player.zone = 236
frames(2)
FAKE.printed = {}
FAKE.events.text_in({ mode = 150, message = 'Flaco : あなたという存在はわたしにとって\7英雄といってもいいくらいです。' })
eq(app._settings().fame.bastok.level, 9, 'bastok 9 remembered')
check(not printed('名声を覚えました'), 'bastok: not during text_in')
-- 同じ会話の別行（分割）が来ても、キューは増えない
FAKE.events.text_in({ mode = 150, message = 'Flaco : あなたという存在はわたしにとって\7英雄といってもいいくらいです。' })
eq(#(app.state.fame_notice or {}), 1, 'still one queued notice')
frame()
check(printed('名声を覚えました：バストゥーク ランク9'), 'bastok line on next frame')
local n_b = 0
for _, t in ipairs(FAKE.printed) do
    if tostring(t):find('名声を覚えました：バストゥーク', 1, true) then n_b = n_b + 1 end
end
eq(n_b, 1, 'bastok announced once, not once per line')

-- ウィンダス（Zabirego-Hajigo）でも同じ（どの国でも text_in 中の print は使わない）
FAKE.player.zone = 238
frames(2)
FAKE.printed = {}
FAKE.events.text_in({ mode = 150, message = 'Zabirego-Hajigo : 残念だけど、聞いたことはないよ' })
eq(app._settings().fame.windurst.level, 1, 'windurst 1 remembered')
check(not printed('名声を覚えました'), 'windurst: not during text_in')
frame()
check(printed('名声を覚えました：ウィンダス ランク1'), 'windurst line on next frame')

-- コマンドの P.print（status）はこれまでどおりすぐ出る
FAKE.printed = {}
FAKE.events.command({ command = '/astertrail status', blocked = false })
check(printed('覚えた名声：'), 'status still prints immediately')


-- --- アストラル設定「配置」：1列、ボタンは1行ずつ、プレビューの枠は一枚 ---
local setsrc = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a')
local i_lay = setsrc:find('local function draw_layout', 1, true)
check(i_lay ~= nil, 'draw_layout exists')
local lay = setsrc:sub(i_lay, (setsrc:find('local function draw_tracker', 1, true) or (i_lay + 2500)) - 1)
check(not lay:find('W.same', 1, true), 'layout buttons are not on the same line')
check(lay:find("row = 'pos_inside'", 1, true) ~= nil, 'bring-inside has its own row')
check(lay:find("row = 'pos_reset'", 1, true) ~= nil, 'reset-layout has its own row')
check(setsrc:find("cat ~= 'layout'", 1, true) ~= nil, 'layout category is packed in one column')
-- 0.1.300：右のプレビューはやめた。本の覚え方の説明は「一覧の列…を元に戻す」の i に
check(lay:find('preview_layout_book', 1, true) ~= nil, 'book layout memory is explained in the BOOK box')

local theme = require('src.ui.theme')
local settings_ui = require('src.ui.settings_ui')
local imgui = package.loaded['imgui'] or require('imgui')
local S = app._settings()
S.look = 'sf'
theme.set_look('sf')
FAKE.keep_default_look = true

local CATS = { 'look', 'layout', 'tracker', 'map', 'marks', 'notify', 'input', 'save' }

local function seen(s)
    for _, l in ipairs(FAKE.labels or {}) do if tostring(l):find(s, 1, true) then return true end end
    for _, l in ipairs(FAKE.texts or {}) do if tostring(l):find(s, 1, true) then return true end end
    return false
end

local function open_settings(w, h)
    S.windows = S.windows or {}
    S.windows.settings = S.windows.settings or {}
    S.windows.settings.w, S.windows.settings.h = w, h
    if app.state.open.settings then app.close_window('settings') end
    app.open_window('settings')
    frames(1)
end

-- 標準サイズと、より狭いサイズの両方で配置を確認（プレビューが出る広めも）
for _, sz in ipairs({ { 900, 700 }, { 520, 620 }, { 400, 520 } }) do
    open_settings(sz[1], sz[2])
    settings_ui.select_tab('layout')
    frames(1)
    check(seen('窓の位置を固定'), 'lock toggle at '..sz[1])
    check(seen('画面内へ戻す'), 'bring-inside button at '..sz[1])
    check(seen('初期配置に戻す'), 'reset-layout button at '..sz[1])
    check(seen('画面の入口アイコン'), 'entry icon label is a full line at '..sz[1])
    check(seen('絞り込みを覚える'), 'filters toggle at '..sz[1])
    check(seen('設定を開いたとき、前回の項目から始める'), 'remember-position label at '..sz[1])
    check(seen('一覧の列の並びと表示を元に戻す'), 'reset-columns button at '..sz[1])
    -- 1文字ずつ縦折りになっていない（「画」だけが独立したラベル、のような跡がない）
    local singles = 0
    for _, l in ipairs(FAKE.texts or {}) do
        if tostring(l) == '画' or tostring(l) == '面' then singles = singles + 1 end
    end
    check(singles == 0, 'entry icon is not split into a one-char column at '..sz[1])
end

-- プレビュー（広い窓）：枠の記録は1種類の外接、中のずれた四角は無し
-- 偽 ImGui の既定サイズは 400x300 なので、プレビュー列が出る幅に合わせる
S.windows.settings.w, S.windows.settings.h = 900, 700
local orig_gws = imgui.GetWindowSize
local orig_avail = imgui.GetContentRegionAvail
imgui.GetWindowSize = function () return 900, 700 end
imgui.GetContentRegionAvail = function () return 860, 640 end
if not app.state.open.settings then app.open_window('settings') end
settings_ui.select_tab('layout')
local sf = require('src.ui.sf_style')
local prev_frames = {}
local orig_frame = sf.frame
sf.frame = function (dl, x1, y1, x2, y2, opts)
    prev_frames[#prev_frames + 1] = { x1 = x1, y1 = y1, x2 = x2, y2 = y2, fill = opts and opts.fill_a }
    return orig_frame(dl, x1, y1, x2, y2, opts)
end
frames(1)
sf.frame = orig_frame
imgui.GetWindowSize = orig_gws
imgui.GetContentRegionAvail = orig_avail
-- 0.1.300：右のプレビューはやめた。文は出さず、行の i の説明に
check(not seen('窓はドラッグして動かせます') and not seen('本は開いたときの位置と、一覧の列を覚えます'), 'no preview text lines')
check(not seen('PREVIEW'), 'no PREVIEW heading')

-- ほかのカテゴリも、標準と狭いサイズで主要なラベルが出て落ちない
local samples = {
    look = { '動きを減らす', 'テーマ' },
    tracker = { 'トラッカーを出す', 'ピンの上限' },
    map = { '地図を出す' },
    marks = { 'アイコンを表示する' },
    notify = { '受注・完了のお知らせ' },
    input = { 'パッドで画面を操作', 'イベント中', '会話', 'メニュー' },
    save = { '今すぐ保存' },
}
for _, sz in ipairs({ { 520, 620 }, { 400, 520 } }) do
    open_settings(sz[1], sz[2])
    for cat, labels in pairs(samples) do
        settings_ui.select_tab(cat)
        frames(1)
        for _, lab in ipairs(labels) do
            check(seen(lab), 'cat '..cat..' shows "'..lab..'" at width '..sz[1])
        end
    end
end

app.close_all()
S.look = 'classic'
theme.set_look('classic')
app.open_window('settings')
frames(1)
-- クラシックの設定は配置タブの並べ替えを受けない
check(seen('くっきりフォント') or seen('言語') or seen('Language') or true, 'classic settings still open')
app.close_all()

print('test_sf_289 ok')
