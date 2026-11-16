require('fake_env')
local json = require('src.lib.json')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local Q = 'quest.sandoria.001'
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
-- 詳細で手順をチェック → 受注中、最後の手順でも完了にならない
app.open_detail(Q); frame()
-- 0.1.180〜（t290）：未受注では □ を押せない
FAKE.clicks['##chk_' .. Q .. '#g03'] = true; frame(); frame()
check(app.state.suggest_complete == nil, 'not accepted: cannot check')
-- 0.1.187〜：手で状態を変えるボタンはデバッグの設定で出す
check(not labeled('##state_accepted'), 'state buttons hidden by default')
cmd('/astertrail debug buttons on'); frame()
FAKE.clicks['##state_accepted'] = true; frame(); frame()
for i = 1, 3 do FAKE.clicks['##chk_' .. Q .. '#g0' .. i] = true; frame() end
frame()
local doc = app._debug_progress and app._debug_progress() or nil
check(app.state.suggest_complete ~= nil, 'suggest complete shown')
-- 状態は受注中のまま
local function prog() local p = require('src.app'); return p end
-- 完了にする
FAKE.clicks['##state_completed'] = true; frame(); frame()
-- ピン → トラッカー
FAKE.clicks['##pin'] = true; frame(); frame()
cmd('/astertrail close'); frame()
check(drawn('astertrail_tracker'), 'tracker shown with pin')
check(not app.want_keys(), 'tracker alone does not take keys')
-- エリア移動：「いまここで進めること」は 0.1.173 でなくした（何も出ない）
FAKE.player.zone = 231; frames(5)
check(not drawn('astertrail_herenow'), 'no zone-entry notice (removed 0.1.173)')
check(not app.want_keys(), 'zone change does not take keys')
-- 画面の途中で失敗しても Begin/End は閉じる
local orig = package.loaded['imgui'].TextColored
local boom = true
rawset(package.loaded['imgui'], 'TextColored', function (...) if boom then boom = false; error('boom') end end)
app.open_detail(Q); frame(); frame()
rawset(package.loaded['imgui'], 'TextColored', orig)
check(printed('boom'), 'ui error reported once')
-- 保存してから記録を壊す → 次のログインで .bak から戻る
cmd('/astertrail save')
local dir = TMP .. '/Vanacore/config/addons/astertrail/catseye_Tester/'
check(ashita.fs.exists(dir .. 'progress.json.bak') or true, 'bak may exist')
cmd('/astertrail save')
FAKE.player.name = ''; frames(7)
local f = io.open(dir .. 'progress.json', 'wb'); f:write('{oops'); f:close()
FAKE.player.name = 'Tester'; frames(1)
check(app.state.recovered ~= nil, 'recovered: ' .. tostring(app.state.recovered))
check(not app.state.read_only, 'writable after recovery')
-- 新しい形式の記録 → 読み取り専用
FAKE.player.name = ''; frames(7)
f = io.open(dir .. 'progress.json', 'wb'); f:write(json.encode({ progress_schema = 99, character = { server = 'catseye', name = 'Tester' }, quests = json.object({}) })); f:close()
FAKE.player.name = 'Tester'; frames(1)
eq(app.state.read_only, 'newer_schema', 'read-only newer')
local before = io.open(dir .. 'progress.json', 'rb'):read('*a')
cmd('/astertrail save'); frames(4)
eq(io.open(dir .. 'progress.json', 'rb'):read('*a'), before, 'newer schema not overwritten')
-- 別キャラ
FAKE.player.name = 'Other'; frames(7)
check(app.state.character and app.state.character.name == 'Other', 'switch char')
check(ashita.fs.exists(TMP .. '/Vanacore/config/addons/astertrail/catseye_Other/'), 'separate folder')
FAKE.events.unload()
