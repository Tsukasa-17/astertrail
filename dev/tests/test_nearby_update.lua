-- 0.1.58: 近くのオブジェクトの名前（名前だけ）と、アップデートのお知らせ
require('fake_env')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local marks = require('src.core.marks')
local settings = require('src.core.settings')
local update = require('src.core.update')

-- 近くのオブジェクトを選ぶ
local ents = {
    { index = 11, name = '???', x = 50, y = 60, z = 4, kind = 'npc' },
    { index = 20, name = 'Signpost', x = 55, y = 60, z = 4, kind = 'npc', entity_type = 2 },
    { index = 21, name = 'Rusty Guard', x = 52, y = 60, kind = 'npc', entity_type = 1 },
    { index = 22, name = 'Goblin Thug', x = 51, y = 60, kind = 'mob', entity_type = 1 },
    { index = 23, name = 'Door', x = 150, y = 60, kind = 'npc', entity_type = 3 },
    { index = 24, name = 'Tombstone', x = 53, y = 61, kind = 'npc', entity_type = 2 },
    { index = 25, name = 'Gate', x = 49, y = 59, kind = 'npc', entity_type = 3, dead = true },
    { index = 1100, name = 'Somebody', x = 50, y = 60, kind = 'npc', entity_type = 2 },
    { index = 26, name = 'Lever', x = 48, y = 60, kind = 'npc', entity_type = 3 },
}
local near = marks.nearby_objects(ents, { px = 50, py = 60 })
local names = {}
for _, n in ipairs(near) do names[#names + 1] = n.name end
eq(table.concat(names, ','), '???,Lever,Tombstone,Signpost', 'nearby picks objects, nearest first')
near = marks.nearby_objects(ents, { px = 50, py = 60, skip = { [11] = true },
    info = function (e)
        if e.index == 24 then return { type = 2, name_shown = true } end
        if e.index == 26 then return { type = 3, targetable = false } end
        if e.index == 21 then return { type = 2 } end   -- 公式の type を先に見る
        return nil
    end })
names = {}
for _, n in ipairs(near) do names[#names + 1] = n.name end
eq(table.concat(names, ','), 'Rusty Guard,Signpost', 'skip marked, name shown, untargetable')
eq(#marks.nearby_objects(ents, {}), 5, 'no player position: no distance limit')

-- 設定：初期はオフ
eq(settings.defaults().marks.show_nearby_names, false, 'default off')
eq(settings.merge({}).marks.show_nearby_names, false, 'merge default off')
eq(settings.merge({ marks = { show_nearby_names = true } }).marks.show_nearby_names, true, 'kept on')
eq(settings.merge({ marks = { show_nearby_names = 'yes' } }).marks.show_nearby_names, false, 'bad value off')
eq(settings.defaults().update_notice.enabled, true, 'update notice default on')

-- 描画：名前だけの箱（アイコン・クエスト名なし、オブジェクト名の色、調べるオブジェクト用の位置）
do
    local D = data_mod.load(posix_fs(), ROOT .. '/data/')
    local P = progress.new({ data = D, max_pins = function () return 10 end, on_change = function () end })
    P:reset({ server = 'catseye', name = 'Test' })
    local marks_ui = require('src.ui.marks')
    local placed = nil
    local S = settings.defaults()
    S.marks.show_icons = true
    S.marks.obj_mark_dx, S.marks.obj_mark_dy = 6, -10
    S.marks.near_name_dx, S.marks.near_name_dy = 8, -12   -- 0.1.60〜：近くのオブジェクト名は別の位置
    S.marks.under_color = { 10, 20, 30 }
    local scene = {
        { index = 11, name = '???', x = 50, y = 60, z = 4, model_size = 2.5, grid = 'J-5', kind = 'npc' },
        { index = 20, name = 'Signpost', x = 55, y = 60, z = 4, model_size = 2, kind = 'npc', entity_type = 2 },
        { index = 21, name = 'Rusty Guard', x = 52, y = 60, z = 4, kind = 'npc', entity_type = 1 },
    }
    local ui = {
        settings = S, state = { ready = true },
        player = { zone_id = 191, x = 50, y = 60 },
        data = D, progress = P,
        platform = {
            visible_entities = function () return scene end,
            attach_available = function () return true end,
            set_name_marks = function () return true end,
            clear_name_marks = function () end,
            place_available = function () return true end,
            set_world_marks = function (items) placed = items; return true, #items end,
            clear_world_marks = function () end,
            object_info = function (e) return { type = e.entity_type, name_shown = false } end,
        },
        imgui = { GetBackgroundDrawList = function () return setmetatable({}, { __index = function () return function () end end }) end },
    }
    -- オフ：クエストに関係ないものには出さない
    local info = marks_ui.draw(ui)
    check(placed == nil or #placed == 0, 'off: nothing placed')
    -- オン
    S.marks.show_nearby_names = true
    info = marks_ui.draw(ui)
    eq(#placed, 2, 'on: ??? and Signpost')
    eq(info.nearby, 2, 'nearby count')
    local by = {}
    for _, it in ipairs(placed) do by[it.under] = it end
    local sp = by['Signpost']
    check(sp and sp.name_only == true, 'name only')
    eq(sp.label, nil, 'no quest name')
    eq(sp.under_color[1], 10, 'object name colour')
    eq(sp.name_dx, 8, 'nearby name position x'); eq(sp.name_dy, -12, 'nearby name position y')
    eq(sp.x, 55, 'at the object')
    check(by['???'] and by['???'].name_only, '??? name only')
    check(not by['Rusty Guard'], 'person not included')
    -- クエストの ??? は今までどおり（アイコンあり）、名前だけの方には重ねない
    P:set_state('quest.bastok.003', 'accepted')
    P:set_current_step('quest.bastok.003', 'quest.bastok.003#g02')
    info = marks_ui.draw(ui)
    local q, n = 0, 0
    for _, it in ipairs(placed) do
        if it.name_only then n = n + 1 else q = q + 1 end
        if it.name_only then check(it.index ~= 11, 'quest ??? not duplicated') end
    end
    eq(q, 1, 'quest mark kept'); eq(n, 1, 'signpost only')
    -- place が使えないときは名前だけは出さない（エラーにしない）
    ui.platform.place_available = function () return false end
    local ok = pcall(marks_ui.draw, ui)
    check(ok, 'no place: no error')
end

-- 版の比べ方
check(update.newer('0.1.60', '0.1.58'), 'newer')
check(update.newer('0.2.0', '0.1.58'), 'newer minor')
check(not update.newer('0.1.58', '0.1.58'), 'same')
check(not update.newer('0.1.9', '0.1.58'), 'older')
check(update.newer('0.1.58.1', '0.1.58'), 'longer')
eq(update.version_in('{"version": "0.1.61", "url": "x"}'), '0.1.61', 'json version')
eq(update.version_in('{"latest":"v0.1.62"}'), '0.1.62', 'json latest')
eq(update.version_in('0.1.66\n'), '0.1.66', 'plain')
eq(update.version_in('<html>nope</html>'), nil, 'garbage')
eq(update.version_in(nil), nil, 'nil')
eq(update.URL, 'https://raw.githubusercontent.com/Tsukasa-17/astertrail/main/version.json', 'url is the repo version.json')
check(update.configured(update.URL), 'release url configured')
update.URL = ''   -- ここから下は、空のときの動きと差し替えた先で見る
check(not update.configured(''), 'empty not configured')
check(update.configured('https://example.com/v.txt'), 'https configured')

-- VanaCore の vana.http.get（公式）を通る形
do
    local ext = require('src.platform.vanacore_ext')
    check(ext.http_get('https://x', function () end) == false, 'no vana: false')
    local got, calls = 'unset', 0
    _G.vana = { http = { get = function (url, opts, cb) calls = calls + 1; check(opts.timeout and opts.max_time, 'timeouts'); cb({ ok = true, body = '0.2.0' }) end } }
    check(ext.http_get('https://x', function (b) got = b end), 'started')
    eq(got, '0.2.0', 'body handed over')
    _G.vana.http.get = function (url, opts, cb) cb(nil, { code = 'dns', message = 'no' }) end
    ext.http_get('https://x', function (b) got = b end)
    eq(got, nil, 'network error: nil')
    _G.vana.http.get = function (url, opts, cb) cb({ ok = false, status = 404, body = '0.9.9' }) end
    got = 'unset'; ext.http_get('https://x', function (b) got = b end)
    eq(got, nil, '404: nil')
    _G.vana.http.get = function () error('boom') end
    check(ext.http_get('https://x', function () end) == false, 'raises: false, no error')
    _G.vana = nil
end

-- アドオンに通す
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local platform = require('src.platform.ashita')
local http_calls = {}
platform.http_get = function (url, cb) http_calls[#http_calls + 1] = url; FAKE.http_cb = cb; return true end
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
check(app.state.ready, 'ready')
check(app.state.update_checked, 'checked once after load')
eq(#http_calls, 0, 'empty url: no request')
check(not printed('新しい版'), 'no message')
local S = app._settings()
eq(app.VERSION, '1.1.285', 'version 0.1.274')
eq(addon.version, app.VERSION, 'astertrail.lua matches app.lua')

local function recheck(url)
    app.state.update_checked = false
    app._update_url = url
    FAKE.http_cb = nil
    frame()
end
recheck('https://example.com/astertrail/version.json')
eq(#http_calls, 1, 'one request')
check(FAKE.http_cb ~= nil, 'callback kept')
FAKE.http_cb('{"version":"1.1.286"}')
check(printed('新しい版 1.1.286 があります（いまは 1.1.285）。'), 'one line in chat')
frame(); frame()
eq(#http_calls, 1, 'not again in later frames')
FAKE.printed = {}
recheck('https://example.com/astertrail/version.json')
FAKE.http_cb('1.1.285')
check(not printed('新しい版'), 'same version: silent')
recheck('https://example.com/astertrail/version.json')
FAKE.http_cb(nil)
check(not printed('新しい版'), 'offline: silent')
S.update_notice.enabled = false
recheck('https://example.com/astertrail/version.json')
eq(#http_calls, 3, 'off: no request')
S.update_notice.enabled = true
platform.http_get = function () error('boom') end
recheck('https://example.com/astertrail/version.json')
check(app.state.update_checked, 'error: still once, silent')
app._update_url = nil

-- 設定の「このアドオンについて」
local function seen(pat)
    for _, l in ipairs(FAKE.labels) do if l:find(pat, 1, true) then return true end end
    for _, l in ipairs(FAKE.texts) do if l:find(pat, 1, true) then return true end end
    return false
end
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('about'); frame(); frame()
check(seen('Based on YunaUI by Yunas'), 'yunaui credit kept')
check(seen('ライセンス'), 'license kept')
check(seen('版 1.1.285'), 'version kept')
check(not seen('非公式のファンメイド'), 'unofficial line removed')
check(not seen('クエスト一覧の参照元'), 'source line removed')
check(seen('アップデートのお知らせ'), 'update toggle')
FAKE.clicks['##update_notice'] = true; frame(); frame()
eq(S.update_notice.enabled, false, 'toggle off')
-- アイコンのタブ
require('src.ui.settings_ui').select_tab('marks'); frame(); frame()
check(seen('近くのオブジェクト名を表示する'), 'nearby toggle')
check(seen('クエストのオブジェクト名を表示する'), 'renamed objects toggle')
check(seen('クエスト名を表示する'), 'renamed quest toggle')
FAKE.clicks['##marks_nearby'] = true; frame(); frame()
eq(S.marks.show_nearby_names, true, 'nearby toggled on')
app.close_all(); frame()
