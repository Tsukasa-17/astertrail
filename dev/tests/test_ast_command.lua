-- 0.1.196: /ast は /astertrail と同じ。/assist・/as は飲まない。
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
frames(1)

check(app.is_addon_command('/astertrail'), 'full command')
check(app.is_addon_command('/astertrail toggle'), 'full with sub')
check(app.is_addon_command('/AST'), 'case')
check(app.is_addon_command('/ast'), 'short')
check(app.is_addon_command('/ast toggle'), 'short with sub')
check(not app.is_addon_command('/assist'), 'not assist')
check(not app.is_addon_command('/assist Player'), 'not assist with target')
check(not app.is_addon_command('/as'), 'not /as')
check(not app.is_addon_command('/aster'), 'not /aster')
check(not app.is_addon_command('/asts'), 'not /asts')

check(cmd('/ast'), 'short open handled')
frame()
check(app.state.open.book, 'short open book')
check(cmd('/ast close'), 'short close')
frame()
check(not app.state.open.book, 'short close book')
check(cmd('/astertrail'), 'full still works')
frame()
check(app.state.open.book, 'full open book')
cmd('/astertrail close'); frame()

-- イベントでも /assist は止めない
local ev = { command = '/assist Player', blocked = false }
FAKE.events.command(ev)
eq(ev.blocked, false, '/assist not blocked')
ev = { command = '/as', blocked = false }
FAKE.events.command(ev)
eq(ev.blocked, false, '/as not blocked')
ev = { command = '/ast toggle', blocked = false }
FAKE.events.command(ev)
eq(ev.blocked, true, '/ast blocked as addon command')
