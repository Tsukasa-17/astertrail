-- 手で 未受注・受注中・完了 にするボタンはデバッグ用（0.1.187〜、t308）
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local Q = 'quest.sandoria.001'
FAKE.player = { name = 'Debugger', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
eq(S.debug.state_buttons, false, 'off by default')
app.open_detail_solo(Q); frame(); frame()
for _, s in ipairs({ 'not_accepted', 'accepted', 'completed' }) do
    check(not labeled('##state_' .. s), 'hidden by default: ' .. s)
end
check(labeled('##pin'), 'pin button still there')
-- コマンドで出す・隠す
FAKE.printed = {}
check(cmd('/astertrail debug buttons'), 'toggle command')
check(printed('ボタンを出しました'), 'toggle on message')
eq(app._settings().debug.state_buttons, true, 'flag on')
frame(); frame()
for _, s in ipairs({ 'not_accepted', 'accepted', 'completed' }) do check(labeled('##state_' .. s), 'shown: ' .. s) end
cmd('/astertrail debug buttons off'); frame(); frame()
check(not labeled('##state_accepted'), 'off again')
cmd('/astertrail debug buttons on'); frame(); frame()
check(labeled('##state_accepted'), 'on again')
FAKE.printed = {}
cmd('/astertrail debug')
check(printed('/astertrail debug buttons'), 'debug help')
-- 設定の「デバッグ」の項目（同じ印。保存のタブの中）
app.open_window('settings'); frame()
require('src.ui.settings_ui').select_tab('save'); frame(); frame()
check(labeled('##dbg_state'), 'debug item in settings')
check(texted('デバッグ'), 'debug heading')
app.PUBLIC = true; frame(); frame()
check(not labeled('##dbg_state'), 'public: no debug item')
app.PUBLIC = false
-- 公開版：設定にも出さない・コマンドも効かない・ボタンも出さない
app.PUBLIC = true
app.open_detail_solo(Q); frame(); frame()
check(not labeled('##state_accepted'), 'public: hidden even with the flag')
FAKE.printed = {}
cmd('/astertrail debug buttons on')
check(printed('使えません'), 'public: command refused')
eq(app.state_buttons(), false, 'public: never')
app.PUBLIC = false
-- 古い保存（debug なし）は オフ
local merged = require('src.core.settings').merge({ gameui = { capture = true } })
eq(merged.debug.state_buttons, false, 'old save: off')
