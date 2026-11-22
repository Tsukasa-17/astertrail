-- 0.1.280：SF の受注・完了お知らせの見た目と、同梱のオリジナル効果音
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.300', 'version')

local notices = io.open(ROOT .. '/src/ui/notices.lua', 'r'):read('*a')
check(notices:find("theme.is_sf()", 1, true) ~= nil, 'classic notices hook SF look')
check(notices:find("require('src.ui.notices_sf')", 1, true) ~= nil, 'SF popup is drawn in notices_sf')
check(notices:find("popup.title_quest_accept", 1, true) ~= nil, 'classic Japanese/English titles remain')
check(notices:find('theme.popup_text', 1, true) ~= nil, 'classic popup typography remains')

local ns = io.open(ROOT .. '/src/ui/notices_sf.lua', 'r'):read('*a')
check(ns:find("popup.sf_title_quest_accept", 1, true) ~= nil, 'QUEST ACCEPTED heading key')
check(ns:find("popup.sf_title_quest_complete", 1, true) ~= nil, 'QUEST COMPLETE heading key')
check(ns:find("popup.sf_title_mission_accept", 1, true) ~= nil, 'MISSION ACCEPTED heading key')
check(ns:find("popup.sf_title_eminence_accept", 1, true) ~= nil, 'EMINENCE heading key')
check(ns:find('heading = true', 1, true) ~= nil, 'English heading uses Melete')
check(ns:find("window.set_font(ui, base * 1.28, {})", 1, true) ~= nil, 'Japanese name is not Melete')
check(ns:find("complete and 'gold'", 1, true) ~= nil, 'complete uses a gold accent')
check(ns:find('ui.popup_anim', 1, true) ~= nil, 'slide/fade uses popup_anim')
check(ns:find('reduce_motion', 1, true) ~= nil, 'reduce_motion is respected')
check(ns:find("name, 'pin_yes'", 1, true) ~= nil and ns:find("name, 'dismiss'", 1, true) ~= nil,
    'pin and close actions are kept')

local win = io.open(ROOT .. '/src/ui/window.lua', 'r'):read('*a')
check(win:find("draw_popup(imgui, opts.glass_kind", 1, true) ~= nil, 'SF glass uses sf.draw_popup')
check(win:find('theme.draw_popup_glass', 1, true) ~= nil, 'classic/YunaUI glass is unchanged')

local sfs = io.open(ROOT .. '/src/ui/sf_style.lua', 'r'):read('*a')
check(sfs:find('function sf.draw_popup', 1, true) ~= nil, 'sf.draw_popup exists')
check(sfs:find('brackets = true', 1, true) ~= nil, 'corner accents')
check(sfs:find("theme.u32('sf_cyan'", 1, true) ~= nil, 'cyan glass')

local sound_src = io.open(ROOT .. '/src/core/sound.lua', 'r'):read('*a')
check(sound_src:find('function sound.wav', 1, true) ~= nil, 'classic synth remains')
check(sound_src:find('function sound.sf_path', 1, true) ~= nil, 'SF bundled path helper')
check(sound_src:find('function sound.wav_apply_volume', 1, true) ~= nil, 'volume is applied to the bundled wav')
check(sound_src:find('assets/sounds/sf_accept.wav', 1, true) ~= nil, 'accept wav path')
check(sound_src:find('assets/sounds/sf_complete.wav', 1, true) ~= nil, 'complete wav path')

local app_src = io.open(ROOT .. '/src/app.lua', 'r'):read('*a')
check(app_src:find("S.look == 'sf'", 1, true) ~= nil, 'SF sounds only when the look is SF')
check(app_src:find('play_sf_sound', 1, true) ~= nil, 'SF play path')
check(app_src:find('sound_mod.file_name(kind, lv)', 1, true) ~= nil, 'classic sound path remains')
check(app_src:find('config_dir', 1, true) ~= nil, 'classic still uses the settings folder for its wav')

-- ロケール
local function load_json(path)
    local raw = io.open(path, 'r'):read('*a')
    return raw
end
local ja = load_json(ROOT .. '/locales/ja.json')
local en = load_json(ROOT .. '/locales/en.json')
check(ja:find('"QUEST ACCEPTED"', 1, true) ~= nil and en:find('"QUEST ACCEPTED"', 1, true) ~= nil,
    'both locales have QUEST ACCEPTED')
check(ja:find('"popup.title_quest_accept"', 1, true) ~= nil, 'classic ja titles kept')

-- 同梱 WAV：オリジナル、0.5〜1.2 秒、割れない
local function wav_info(path)
    local f = io.open(path, 'rb')
    check(f ~= nil, 'wav exists: ' .. path)
    local raw = f:read('*a'); f:close()
    eq(raw:sub(1, 4), 'RIFF', 'riff ' .. path)
    eq(raw:sub(9, 12), 'WAVE', 'wave ' .. path)
    local function u16(i) return raw:byte(i) + raw:byte(i + 1) * 256 end
    local function u32(i) return u16(i) + u16(i + 2) * 65536 end
    local rate, bits, ch, data_sz
    local i = 13
    while i + 8 <= #raw do
        local id = raw:sub(i, i + 3)
        local sz = u32(i + 4)
        if id == 'fmt ' then
            ch = u16(i + 10)
            rate = u32(i + 12)
            bits = u16(i + 22)
        elseif id == 'data' then
            data_sz = sz
            local peak = 0
            for k = 0, math.floor(sz / 2) - 1 do
                local v = raw:byte(i + 8 + k * 2) + raw:byte(i + 8 + k * 2 + 1) * 256
                if v >= 32768 then v = v - 65536 end
                if v < 0 then v = -v end
                if v > peak then peak = v end
            end
            return { raw = raw, rate = rate, bits = bits, ch = ch, seconds = (sz / 2) / rate, peak = peak }
        end
        i = i + 8 + sz + (sz % 2)
    end
    return nil
end

local acc = wav_info(ROOT .. '/assets/sounds/sf_accept.wav')
local cmp = wav_info(ROOT .. '/assets/sounds/sf_complete.wav')
check(acc and cmp, 'both wavs parsed')
eq(acc.ch, 1, 'accept mono'); eq(cmp.ch, 1, 'complete mono')
eq(acc.bits, 16, 'accept 16-bit'); eq(cmp.bits, 16, 'complete 16-bit')
check(acc.seconds >= 0.5 and acc.seconds <= 1.2, 'accept length 0.5-1.2s (' .. string.format('%.3f', acc.seconds) .. ')')
check(cmp.seconds >= 0.5 and cmp.seconds <= 1.2, 'complete length 0.5-1.2s (' .. string.format('%.3f', cmp.seconds) .. ')')
check(acc.peak > 0 and acc.peak <= 32767, 'accept no clip')
check(cmp.peak > 0 and cmp.peak <= 32767, 'complete no clip')
check(acc.raw ~= cmp.raw, 'accept and complete are different')
local gen = io.open(ROOT .. '/dev/gen_sf_sounds.py', 'r')
check(gen ~= nil, 'generator script lives under dev/')
if gen then gen:close() end

-- 音量の掛け算（同梱 WAV、設定フォルダには書かない）
local sound = require('src.core.sound')
eq(sound.wav_apply_volume(acc.raw, 0), nil, 'volume 0: no wav')
eq(sound.wav_apply_volume(acc.raw, 100), acc.raw, 'volume 100: original bytes')
local a40 = sound.wav_apply_volume(acc.raw, 40)
local a70 = sound.wav_apply_volume(acc.raw, 70)
check(a40 and a70 and a40 ~= a70 and a40 ~= acc.raw, 'volume scales the bundled wav')

-- 生成スクリプトと README がある
check(io.open(ROOT .. '/assets/sounds/README.txt', 'r') ~= nil, 'sounds README')

-- 実行：SF では同梱 WAV、クラシックでは従来どおり
ashita.misc = { play_sound = function (p) FAKE.played = FAKE.played or {}; FAKE.played[#FAKE.played + 1] = p end }
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'SfNotice', zone = 234, tidx = 5, status = 0 }
frames(1)
check(app.state.ready, 'logged in')
local S = app._settings()
local theme = require('src.ui.theme')
S.notify.popup = true
S.notify.sound = true
S.notify.sound_volume = 70

local function played() return FAKE.played or {} end

-- クラシック：従来のファンファーレ（設定フォルダ）
S.look = 'classic'
theme.set_look('classic')
FAKE.played = {}
check(app.popup_preview('accept'), 'classic preview accept')
frames(1)
check(played()[1] and played()[1]:find('astertrail_accept', 1, true), 'classic uses generated accept wav')
check(not (played()[1] and played()[1]:find('sf_accept', 1, true)), 'classic does not use the SF wav')
check(texted('クエスト受注') or texted('Quest Accepted'), 'classic title remains')
app.popup_choose(false); frames(1)

-- SF：同梱 WAV と英語見出し
S.look = 'sf'
theme.set_look('sf')
FAKE.played = {}
check(app.popup_preview('accept'), 'sf preview accept')
frames(1)
check(played()[1] and played()[1]:find('sf_accept', 1, true), 'SF uses bundled accept wav')
check(texted('QUEST ACCEPTED'), 'SF heading is QUEST ACCEPTED')
check(not texted('クエスト受注'), 'SF does not use the classic Japanese title')
app.popup_choose(false); frames(1)

FAKE.played = {}
check(app.popup_preview('complete'), 'sf preview complete')
frames(1)
check(played()[1] and played()[1]:find('sf_complete', 1, true), 'SF uses bundled complete wav')
check(texted('QUEST COMPLETE') or texted('MISSION COMPLETE') or texted('EMINENCE COMPLETE'),
    'SF complete heading is English')
app.popup_choose(false); frames(1)

-- 音量 40：TEMP に掛けたコピー。設定フォルダの sounds\\ には書かない
S.notify.sound_volume = 40
FAKE.played = {}
check(app.popup_preview('accept'), 'sf preview at vol 40')
frames(1)
local p40 = played()[1]
check(p40 and p40:find('_v40', 1, true), 'SF volume setting is applied in the file name')
check(p40:find('sf_accept', 1, true) or p40:find('astertrail_sf_accept', 1, true), 'vol 40 file is still the SF accept sound')
check(not (p40:find('config', 1, true) and p40:find('sounds', 1, true)), 'SF volume copy is not in the settings folder')
app.popup_choose(false); frames(1)

S.notify.sound_volume = 0
FAKE.played = {}
check(app.popup_preview('accept'), 'sf preview at vol 0')
frames(1)
eq(#played(), 0, 'SF volume 0 is silent')
eq(#app.state.popups, 1, 'popup still shows at volume 0')
app.popup_choose(false); frames(1)
S.notify.sound_volume = 70

S.notify.sound = false
FAKE.played = {}
check(app.popup_preview('accept'), 'sf preview sound off (force via preview)')
frames(1)
-- preview は play_sound(kind, preview) で force=true なので鳴る
check(#played() >= 1, 'preview still plays when testing (force)')
app.popup_choose(false); frames(1)
S.notify.sound = true

print('test_sf_280 ok')
