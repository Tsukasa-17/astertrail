-- 受注・完了のお知らせと効果音（0.1.183〜、t295。0.1.198〜は明るいファンファーレ・中央の豪華ボタン）
require('fake_env')
local gl = require('src.core.game_log')
local sound = require('src.core.sound')

local function words_with(bits)
    local w = { 0, 0, 0, 0, 0, 0, 0, 0 }
    for _, n in ipairs(bits or {}) do
        local i = math.floor(n / 32) + 1
        w[i] = w[i] + 2 ^ (n % 32)
    end
    return w
end
local function u32s(v)
    v = v % 4294967296
    return string.char(v % 256, math.floor(v / 256) % 256, math.floor(v / 65536) % 256, math.floor(v / 16777216) % 256)
end
local function packet(port, words)
    local s = string.char(0x56, 0x14, 0x01, 0x00)
    for i = 1, 8 do s = s .. u32s(words[i] or 0) end
    return s .. string.char(port % 256, math.floor(port / 256)) .. string.char(0, 0)
end
local function rd16(s, i) return s:byte(i) + s:byte(i + 1) * 256 end
local function rd32(s, i) return rd16(s, i) + rd16(s, i + 2) * 65536 end

-- 効果音：自分で作る WAV（PCM 16bit・モノラル・22050Hz）
do
    local a = sound.wav('accept', 70)
    local c = sound.wav('complete', 70)
    eq(a:sub(1, 4), 'RIFF', 'riff'); eq(a:sub(9, 16), 'WAVEfmt ', 'wave fmt')
    eq(rd16(a, 21), 1, 'pcm'); eq(rd16(a, 23), 1, 'mono'); eq(rd32(a, 25), 22050, 'rate'); eq(rd16(a, 35), 16, '16 bit')
    eq(a:sub(37, 40), 'data', 'data chunk'); eq(rd32(a, 41), #a - 44, 'data size'); eq(rd32(a, 5), #a - 8, 'riff size')
    check(#a > 44 + 22050 * 2 * 1.8 and #a < 44 + 22050 * 2 * 2.7, 'accept is a short fanfare')
    check(#c > 44 + 22050 * 2 * 3.0 and #c < 44 + 22050 * 2 * 4.2, 'complete is a bigger fanfare')
    check(#c > #a, 'complete is longer')
    check(a ~= c, 'two different sounds')
    eq(sound.wav('accept', 0), nil, 'volume 0: no sound')
    eq(sound.wav('nope', 50), nil, 'unknown kind')
    eq(sound.level(64), 60, 'volume steps of 10'); eq(sound.level(140), 100, 'volume max'); eq(sound.level(-5), 0, 'volume min')
    -- 音量で振幅が変わる（大きいほど大きい）
    local function peak(s)
        local m = 0
        for i = 45, #s - 1, 2 do
            local v = rd16(s, i); if v >= 32768 then v = v - 65536 end
            if math.abs(v) > m then m = math.abs(v) end
        end
        return m
    end
    local p30, p100 = peak(sound.wav('accept', 30)), peak(sound.wav('accept', 100))
    check(p30 > 0 and p30 < p100 and p100 <= 32767, 'volume scales the wave')
    check(sound.file_name('accept', 64):match('^[%w_%.]+$') ~= nil, 'ascii file name')
    check(sound.file_name('accept', 70):find('_' .. tostring(sound.VERSION) .. '.wav', 1, true), 'version in file name')
end

-- 鳴らした音（ashita.misc.play_sound）
local played = {}
ashita.misc = { play_sound = function (p) played[#played + 1] = p end }

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local platform = require('src.platform.ashita')
local mem_cur, mem_done = {}, { 52 }
platform.quest_log_snapshot = function ()
    local s = gl.new_snapshot(); s.source = 'memory'
    gl.apply_port(s, 0x58, words_with(mem_cur))
    gl.apply_port(s, 0x98, words_with(mem_done))
    return s, gl.ALL_RECEIVED
end
FAKE.player = { name = 'Popup', zone = 234, tidx = 5, status = 0 }
frames(1)
check(app.state.ready, 'logged in')
local PR = app._progress()
local D = app._data()
local S = app._settings and app._settings() or nil
local function qid_of(log, bit)
    for qid, r in pairs(D.game_refs) do if r[1] == 'q' and r[2] == log and r[3] == bit then return qid end end
end
local q14, q15 = qid_of(1, 14), qid_of(1, 15)
check(q14 and q15, 'two mapped bastok quests')
eq(#app.state.popups, 0, 'no popup on login read')
eq(#played, 0, 'no sound on login read')

-- ログインのすぐ後に届いた通信では出さない
FAKE.events.packet_in({ id = 0x056, data = packet(0x58, words_with({ 14 })) })
frames(1)
eq(PR:state(q14), 'accepted', 'applied')
eq(#app.state.popups, 0, 'no popup right after login')
-- 戻して、しばらく遊んでから
FAKE.events.packet_in({ id = 0x056, data = packet(0x58, words_with({})) })
frames(16)
eq(#app.state.popups, 0, 'cancel shows nothing')
played = {}

-- 受注：お知らせ・受注の音・ピン留めするか
FAKE.events.packet_in({ id = 0x056, data = packet(0x58, words_with({ 14 })) })
frames(1)
eq(#app.state.popups, 1, 'accept popup')
eq(#played, 1, 'one sound'); check(played[1]:find('accept', 1, true), 'accept sound')
local f = io.open(played[1], 'rb'); check(f ~= nil, 'sound file written')
if f then eq(f:read(4), 'RIFF', 'sound file is wav'); f:close() end
frame()
check(texted('クエスト受注') or texted('Quest Accepted'), 'accepted title')
check(labeled('##pin_yes') and labeled('##pin_no'), 'pin choices')
check(labeled('ピン留めする##pin_yes') or labeled('Pin##pin_yes'), 'pin label')
eq(app.state.active, nil, 'does not take keys while playing')
FAKE.clicks['##pin_yes'] = true; frame(); FAKE.clicks['##pin_yes'] = nil
check(PR:is_pinned(q14), 'pinned from popup')
check(app.state.popups[1] and app.state.popups[1].closing_at, 'starts fading on choice')
frames(1)
eq(#app.state.popups, 0, 'closed after fade')
frame()
check(not labeled('##pin_yes'), 'not drawn after choice')

-- 時間で消える（ピン留めしない）
local secs = app._settings and app._settings().notify.popup_seconds or 8
FAKE.events.packet_in({ id = 0x056, data = packet(0x58, words_with({ 14, 15 })) })
frames(1)
eq(#app.state.popups, 1, 'second accept popup')
frames(secs - 2)
eq(#app.state.popups, 1, 'still shown before the time')
frames(3)
eq(#app.state.popups, 0, 'auto closed')
check(not PR:is_pinned(q15), 'not pinned when it timed out')

-- 完了：別の音。続きが無ければお知らせだけ
played = {}
local nxt = app.next_of(q15)
FAKE.events.packet_in({ id = 0x056, data = packet(0x98, words_with({ 52, 15 })) })
FAKE.events.packet_in({ id = 0x056, data = packet(0x58, words_with({ 14 })) })
frames(1)
eq(PR:state(q15), 'completed', 'completed by game')
eq(#app.state.popups, 1, 'complete popup')
check(played[1] and played[1]:find('complete', 1, true), 'complete sound (different file)')
frame()
check(texted('クエスト完了') or texted('Quest Complete'), 'completed title')
if nxt then
    check(labeled('##pin_yes'), 'asks to pin the next quest')
else
    check(not labeled('##pin_yes') and labeled('##dismiss'), 'only the notice when there is no next')
end
app.popup_choose(false); frames(1)
eq(#app.state.popups, 0, 'closed')

-- 続きのクエスト：前提にこの完了があるクエスト
do
    local marks_core = require('src.core.marks')
    local found, prev
    for _, x in ipairs(D.quests) do
        if x.kind == 'quest' and PR:state(x.id) == 'not_accepted' then
            local g = marks_core.prereq_ids(D, x)
            if #g == 1 and #g[1] == 1 and not g[1].accept and PR:state(g[1][1]) ~= 'completed' then found, prev = x.id, g[1][1]; break end
        end
    end
    check(found ~= nil, 'a chained quest in the data')
    eq(app.next_of(prev), nil, 'no next while its prerequisite is not done')
    PR:apply_game(prev, 'completed')
    local n = app.next_of(prev)
    check(n ~= nil, 'next quest found after completion')
    local ok = false
    for _, g in ipairs(marks_core.prereq_ids(D, D:quest(n))) do for _, id in ipairs(g) do if id == prev then ok = true end end end
    check(ok, 'next quest needs the completed one')
    app.popup_push('complete', prev); frames(1)
    eq(app.state.popups[1].next, n, 'complete popup asks for the next quest'); frame()
    check(texted('続きのクエスト') or texted('next quest'), 'next quest question')
    FAKE.clicks['##pin_yes'] = true; frame(); FAKE.clicks['##pin_yes'] = nil
    check(PR:is_pinned(n), 'next quest pinned')
    frames(1)
    eq(#app.state.popups, 0, 'closed after pinning the next')
end

-- 次のミッション：同じ分類の次の番号。アサルトなど順番の無いものは無し
do
    local m1
    for _, x in ipairs(D.quests) do if x.kind == 'mission' and x.category == 'bastok' then m1 = m1 or x end end
    local n = app.next_of(m1.id)
    check(n ~= nil and D:quest(n).category == 'bastok' and n ~= m1.id, 'next bastok mission')
    local as
    for _, x in ipairs(D.quests) do if x.category == 'assault' then as = as or x end end
    if as then eq(app.next_of(as.id), nil, 'assault has no next') end
end

-- 並べて待つ：先頭だけ出し、閉じたら次（次も音）
played = {}
app.popup_push('accept', q15)
app.popup_push('complete', q15)
frames(1)
eq(#app.state.popups, 2, 'queued'); eq(#played, 1, 'sound only for the shown one')
frame()
check(texted('ほかに 1 件') or texted('1 more'), 'more waiting')
check(texted('クエスト受注') or texted('Quest Accepted'), 'first one shown')
app.popup_choose(false); frames(1)
eq(#app.state.popups, 1, 'next one'); eq(#played, 2, 'its sound when shown')
app.popup_choose(false)
for _ = 1, 10 do app.popup_push('accept', q15 .. '') end
check(#app.state.popups <= app.POPUP_MAX, 'queue is capped / no duplicates')
app.state.popups = {}

-- まとめて変わったとき（読み直しのような）は出さない
played = {}
FAKE.events.packet_in({ id = 0x056, data = packet(0x58, words_with({ 14, 16, 17, 18, 19 })) })
frames(1)
eq(#app.state.popups, 0, 'bulk change: no popup'); eq(#played, 0, 'bulk change: no sound')
-- ゾーン移動の読み直しでは出さない
mem_cur = { 14, 20 }
FAKE.player.zone = 235
frames(7)
eq(#app.state.popups, 0, 'zone re-read: no popup')
frames(16)

-- 手で受注中にしたときは出さない
local qm = qid_of(1, 21)
check(app.request('set_state', qm, 'accepted').ok, 'manual accept')
frames(1)
eq(#app.state.popups, 0, 'manual press: no popup')

-- 操作中に出たら、キー・パッドで選べる。選んだら前の窓へ戻る
app.open_window('book'); frame()
eq(app.state.active, 'book', 'operating the book')
app.popup_push('accept', qid_of(1, 22)); frames(1)
eq(app.state.active, 'popup', 'popup takes keys while operating')
app.input('confirm', true, 'key'); app.input('confirm', false, 'key'); frame()
check(PR:is_pinned(qid_of(1, 22)), 'pinned with the key')
frames(1)
eq(#app.state.popups, 0, 'closed by the key')
eq(app.state.active, 'book', 'back to the book')
app.close_window('book'); app.release(); frame()
-- 遊んでいる間は /astertrail notice で操作。キャンセルは「しない」と同じ
app.popup_push('accept', qid_of(1, 23)); frames(1)
eq(app.state.active, nil, 'not taken while playing')
check(cmd('/astertrail notice'), 'notice command')
eq(app.state.active, 'popup', 'notice operates the popup')
app.input('back', true, 'key'); app.input('back', false, 'key')
frames(1)
eq(#app.state.popups, 0, 'back closes'); check(not PR:is_pinned(qid_of(1, 23)), 'back does not pin')
eq(app.state.active, nil, 'released after')

-- 設定：お知らせを消すと音だけ。音を消すと鳴らない
local N = require('src.core.settings').defaults().notify
eq(N.popup, true, 'popup on by default'); eq(N.sound, true, 'sound on by default'); eq(N.popup_seconds, 8, 'popup seconds')
eq(N.login_resume, false, 'login resume off by default')
local m = require('src.core.settings').merge({ notify = { popup_seconds = 100, sound_volume = 64, popup = 'x' } })
eq(m.notify.popup_seconds, 30, 'seconds clamped'); eq(m.notify.sound_volume, 60, 'volume step'); eq(m.notify.popup, true, 'bad popup value: default')
eq(m.notify.login_resume, false, 'unset login resume stays off')
local m2 = require('src.core.settings').merge({ notify = { login_resume = true } })
eq(m2.notify.login_resume, true, 'saved login resume kept')
local m3 = require('src.core.settings').merge({ notify = { login_resume = false } })
eq(m3.notify.login_resume, false, 'saved off kept')
local SS = app._settings()
SS.notify.popup = false; played = {}
app.popup_push('accept', qid_of(1, 24)); frames(1)
eq(#played, 1, 'sound without popup'); eq(#app.state.popups, 0, 'no popup kept'); check(not labeled('##pin_yes'), 'no popup drawn')
SS.notify.popup = true; SS.notify.sound = false; played = {}
app.popup_push('accept', qid_of(1, 25)); frames(1)
eq(#played, 0, 'sound off'); eq(#app.state.popups, 1, 'popup still')
app.popup_choose(false)
SS.notify.sound = true; SS.notify.sound_volume = 0; played = {}
app.popup_push('accept', qid_of(1, 26)); frames(1)
eq(#played, 0, 'volume 0: silent'); app.popup_choose(false)
SS.notify.sound_volume = 70
-- 設定の「お知らせ」タブ
local sui = require('src.ui.settings_ui')
app.open_window('settings'); frame()
sui.select_tab('notify'); frame(); frame()
check(labeled('##n_popup') and labeled('##n_sound'), 'popup and sound switches')
check(labeled('##n_popup_s') or texted('お知らせの表示秒数'), 'popup seconds')
check(labeled('##n_sound_v') or texted('効果音の音量') or texted('Sound volume'), 'volume stepper')
played = {}
local st_before = PR:state(q14)
FAKE.clicks['##n_popup_try2'] = true; frame(); FAKE.clicks['##n_popup_try2'] = nil
frames(1)
check(played[1] and played[1]:find('complete', 1, true), 'try the complete notice sound')
eq(#app.state.popups, 1, 'try complete shows a popup')
check(app.state.popups[1].preview, 'try is a preview')
check(texted('クエスト完了') or texted('ミッション完了') or texted('Quest Complete') or texted('Mission Complete'), 'preview title')
eq(PR:state(q14), st_before, 'preview does not change progress')
local tgt = app.popup_target()
local was_pin = tgt and PR:is_pinned(tgt)
app.popup_choose(true); frames(1)
eq(#app.state.popups, 0, 'preview closed')
if tgt then eq(PR:is_pinned(tgt), was_pin and true or false, 'preview pin does not change pins') end
-- 受注時を試す
played = {}
FAKE.clicks['##n_popup_try'] = true; frame(); FAKE.clicks['##n_popup_try'] = nil
frames(1)
check(played[1] and played[1]:find('accept', 1, true), 'try the accept notice sound')
eq(#app.state.popups, 1, 'try accept shows a popup')
eq(PR:state(q14), st_before, 'accept preview does not change progress')
app.popup_choose(false); frames(1)
-- 試すボタンも、いまの音量設定で鳴らす（0 なら無音。PlaySound に音量指定が無いので、きざみごとの WAV を使う）
SS.notify.sound_volume = 40
played = {}
FAKE.clicks['##n_popup_try'] = true; frame(); FAKE.clicks['##n_popup_try'] = nil
frames(1)
check(played[1] and played[1]:find('_v40_', 1, true), 'try accept uses the volume setting')
check(played[1]:find('accept', 1, true), 'try accept file is accept')
app.popup_choose(false); frames(1)
SS.notify.sound_volume = 80
played = {}
FAKE.clicks['##n_popup_try2'] = true; frame(); FAKE.clicks['##n_popup_try2'] = nil
frames(1)
check(played[1] and played[1]:find('_v80_', 1, true), 'try complete uses the volume setting')
check(played[1]:find('complete', 1, true), 'try complete file is complete')
app.popup_choose(false); frames(1)
SS.notify.sound_volume = 0
played = {}
FAKE.clicks['##n_popup_try'] = true; frame(); FAKE.clicks['##n_popup_try'] = nil
frames(1)
eq(#played, 0, 'try at volume 0 is silent')
eq(#app.state.popups, 1, 'try still shows the popup at volume 0')
app.popup_choose(false); frames(1)
SS.notify.sound_volume = 70
app.close_window('settings'); frame()
-- 鳴らせない環境
ashita.misc = nil
check(not platform.can_play_sound(), 'no sound api')
eq(platform.play_sound('x.wav'), false, 'cannot play')
