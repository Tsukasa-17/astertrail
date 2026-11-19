-- 0.1.35: ゲーム本来のメニュー（ミッションで本も開く・コンフィグの設定ボタン・本の操作中の入力止め）
require('fake_env')

local G = { watches = {}, adds = {}, removes = 0, catches = {}, offs = {}, next_id = 0, chat = false,
            refuse_ja = false, forbidden = {} }
local function nid() G.next_id = G.next_id + 1; return G.next_id end
local gameui = {
    watch = function (names, fn) local id = nid(); G.watches[id] = { names = names, fn = fn }; return id end,
    unwatch = function (id) G.watches[id] = nil end,
    add = function (menu, label, fn)
        G.adds[#G.adds + 1] = { menu = menu, label = label }
        if G.refuse_ja and label:find('[\128-\255]') then return false, 'label' end
        G.button = fn
        return true
    end,
    remove = function (menu) G.removes = G.removes + 1; G.button = nil; return true end,
    catch = function (menu, event, fn)
        local id = nid(); G.catches[id] = { menu = menu, event = event }; return id
    end,
    off = function (id) G.catches[id] = nil; G.offs[#G.offs + 1] = id end,
}
-- 使ってはいけないもの（呼ばれたら記録）
for _, k in ipairs({ 'hide', 'show', 'move', 'replace', 'image', 'press', 'on' }) do
    gameui[k] = function () G.forbidden[#G.forbidden + 1] = k end
end
_G.vana = { gameui = gameui, game = { world = function () return { chat_open = G.chat } end } }

local function nwatch() local n = 0 for _ in pairs(G.watches) do n = n + 1 end return n end
local function ncatch() local n = 0 for _ in pairs(G.catches) do n = n + 1 end return n end
local function fire(what, name, closing)
    for _, w in pairs(G.watches) do
        w.fn({ what = what, name = name, window = (what ~= 'close') and { closing = closing } or nil })
    end
end

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local function is_open(n) return app.state.open[n] == true end
local function close_book()
    -- 0.1.204〜：行や中の見出しなら数回、いちばん上の見出しなら1回で閉じる
    for _ = 1, 6 do
        if not app.state.open.book or app.state.active ~= 'book' then return end
        press(0x01); frame()
    end
end
local function S() return app._settings() end
local function set(k, v) S().gameui[k] = v end

-- 見張りは missionm だけ、ボタンは日本語のラベルでコンフィグに1つ
eq(nwatch(), 1, 'one watch')
local _, w = next(G.watches)
eq(w.names[1], 'missionm', 'watches missionm')
eq(#G.adds, 1, 'one add')
eq(G.adds[1].menu, 'config_menu', 'config menu')
eq(G.adds[1].label, '冒険の本の設定', 'ja label first')
check(#G.adds[1].label > 0, 'label not empty')
eq(ncatch(), 0, 'no capture while nothing is operated')

-- ミッションを開く → 本がミッションの欄で開き、入力止めが付く
fire('open', 'missionm', false); frame()
eq(is_open('book'), true, 'book opened with missions')
eq(app.state.active, 'book', 'book active')
eq(S().book.tab, 'mission', 'mission tab')
eq(ncatch(), 1, 'menus caught while book is operated')
local _, c = next(G.catches)
eq(c.menu, '*', 'every menu'); eq(c.event, '*', 'every event')

-- 本の操作キーはゲームに渡らない
eq(press(0xD0), true, 'down blocked')
eq(pad(1, 1), true, 'pad down blocked'); pad(1, 0)

-- 開いたまま変化が続いても、本を閉じたら開き直さない
close_book()
eq(is_open('book'), false, 'book closed by cancel')
for _ = 1, 5 do fire('change', 'missionm', false); frame() end
eq(is_open('book'), false, 'not reopened while missionm stays')
eq(ncatch(), 0, 'capture released when book closed')
eq(press(0xD0), false, 'down reaches the game after close')

-- 閉じる途中のちらつき（closing=true の open/close の繰り返し）では開かない
fire('change', 'missionm', true); fire('close', 'missionm')
for _ = 1, 10 do fire('open', 'missionm', true); fire('close', 'missionm'); frame() end
eq(is_open('book'), false, 'closing flicker ignored')

-- 次にちゃんと開いたら、また開く
frames(0.5)
fire('open', 'missionm', false); frame()
eq(is_open('book'), true, 'opened again on next missions')
eq(ncatch(), 1, 'caught again')

-- チャット入力中は止めない（キーも窓も）
G.chat = true; frame()
eq(ncatch(), 0, 'no capture while chat is open')
eq(press(0xD0), false, 'keys reach chat')
G.chat = false; frame()
eq(ncatch(), 1, 'capture back after chat')

-- 本の外をクリック（操作をやめる）と外れる
app.release(); frame()
eq(ncatch(), 0, 'released when not operating')
app.close_window('book'); frame()

-- コンフィグのボタン → 本を設定の表示で開く（0.1.175〜。設定の窓は別に無い）
G.button(); frame()
eq(is_open('settings'), true, 'config button opens settings')
eq(is_open('book'), true, 'settings are shown in the book')
app.close_window('book'); frame()
eq(is_open('settings'), false, 'closing the book closes the settings')
G.button(); frame(); G.button(); frame()
eq(is_open('settings'), false, 'config button toggles settings')
eq(is_open('book'), false, 'config button toggles the book too')

-- 設定でオフ → 外れる。オンで戻る
set('mission_book', false); frame()
eq(nwatch(), 0, 'watch removed by setting')
fire('open', 'missionm', false); frame()
eq(is_open('book'), false, 'no auto open when off')
set('config_button', false); frame()
eq(G.button, nil, 'button removed by setting')
set('config_button', true); set('mission_book', true); frame()
eq(nwatch(), 1, 'watch back')
check(G.button ~= nil, 'button back')

-- 読み込み解除でぜんぶ外れる
app.open_window('book'); frame()
eq(ncatch(), 1, 'caught before unload')
FAKE.events.unload()
eq(ncatch(), 0, 'catch released on unload')
eq(nwatch(), 0, 'watch released on unload')
eq(G.button, nil, 'button removed on unload')
eq(#G.forbidden, 0, 'no forbidden gameui calls')

-- 日本語のラベルが断られたら Astertrail
package.loaded['src.app'] = nil
G = { watches = {}, adds = {}, removes = 0, catches = {}, offs = {}, next_id = 100, chat = false, refuse_ja = true, forbidden = {} }
_G.vana.game.world = function () return { chat_open = false } end
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(#G.adds, 2, 'tried twice')
eq(G.adds[2].label, 'Astertrail', 'fallback label')
check(G.button ~= nil, 'fallback button works')
FAKE.events.unload()

-- 0.1.36: ゲームが受け取った押下の「離した」は止めない（決定が2回要る不具合）
do
    package.loaded['src.app'] = nil
    G = { watches = {}, adds = {}, removes = 0, catches = {}, offs = {}, next_id = 200, chat = false, forbidden = {} }
    _G.vana.game.world = function () return { chat_open = G.chat } end
    dofile(ROOT .. '/astertrail.lua')
    FAKE.events.load()
    local app2 = require('src.app')
    local focus = require('src.ui.focus')
    FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
    frames(1)
    local P2 = app2._platform and app2._platform() or nil
    -- ゲームで Enter を押して（ゲームへ）ミッションが開き、本が開く
    eq(key(0x1C, true), false, 'enter down reaches game')
    fire('open', 'missionm', false); frame()
    eq(app2.state.open.book, true, 'book with missions')
    eq(key(0x1C, false), false, 'enter release reaches game (not stuck)')
    -- パッドも同じ
    app2.close_window('book'); frame()
    eq(pad(12, 1), false, 'A down reaches game')
    app2.open_window('book'); frame()
    eq(pad(12, 0), false, 'A release reaches game')
    -- 本の中で押したものは、押下も離したのも止める
    eq(key(0xD0, true), true, 'down blocked'); eq(key(0xD0, false), true, 'its release blocked')
    -- Esc で閉じる：その場で止めが外れ、次の Enter は1回で届く
    eq(ncatch(), 1, 'caught while book')
    -- 見出しの階層を上がって閉じる（キャプチャは閉じたその押下で外れる）
    local focus = require('src.ui.focus')
    local closed_here = false
    for _ = 1, 6 do
        if not app2.state.open.book then closed_here = true; break end
        eq(key(0x01, true), true, 'esc still captured while the book is open')
        if not app2.state.open.book then
            eq(key(0x01, false), true, 'esc release blocked too')
            closed_here = true
            break
        end
        key(0x01, false); frame()
    end
    eq(app2.state.open.book, false, 'book closed')
    eq(ncatch(), 0, 'capture released on the same press')
    eq(press(0x1C), false, 'first enter after close reaches game')
    -- パッド B でも
    app2.open_window('book'); frame(); frame()
    local closed_by_b = false
    for i = 1, 6 do
        local took = pad(13, 1)
        pad(13, 0); frame()
        if not app2.state.open.book then
            eq(took, true, 'B closes')
            eq(ncatch(), 0, 'released at once')
            closed_by_b = true
            break
        end
    end
    check(closed_by_b, 'B closes the book')
    eq(pad(12, 1), false, 'first A after close reaches game'); pad(12, 0)

    -- スライダー：1回目のキャンセルで ↺、次で見出しへ、見出しでキャンセルすると閉じる（0.1.239〜）
    app2.open_window('settings'); frame(); frame()
    focus.set('settings', 'font_book'); frame()
    check(focus.is_adjust('settings'), 'on slider')
    press(0x01); frame()
    eq(focus.current('settings'), 'font_book_reset', 'first cancel goes to reset')
    eq(app2.state.open.settings, true, 'settings still open')
    press(0xCD); frame()
    eq(focus.current('settings'), 'font_book', 'right goes back to slider')
    press(0xD0); frame()
    check(focus.current('settings') ~= 'font_book', 'down leaves slider row')
    focus.set('settings', 'font_book'); frame()
    press(0x01); frame()
    eq(focus.current('settings'), 'font_book_reset', 'cancel from slider still goes to reset')
    press(0x01); frame()
    eq(focus.current('settings'), 'fold_look_fonts', 'cancel from inside goes to heading')
    eq(app2.state.open.settings, true, 'settings still open on heading')
    press(0x01); frame()
    eq(app2.state.open.settings, false, 'cancel on heading closes')
    FAKE.events.unload()
    eq(ncatch(), 0, 'nothing caught after unload')
end

print('test_gameui ok')
