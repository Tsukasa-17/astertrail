-- 0.1.314：SF 地図で階タブを押したフレームに「map_sf.lua:697: attempt to index field 'view' (a nil value)」が出た
-- （階を変えると見え方 info.view を nil にしていたのに、同じフレームの下バーで info.view.z を読んでいた）。
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
local app = require('src.app')
eq(app.VERSION, '1.1.314', 'version')
FAKE.events.load()
FAKE.player = { name = 'Map314', zone = 9, tidx = 5, status = 0, x = 0, y = 0, z = 0 }
frames(1)
check(app.state.ready, 'logged in')
local S = app._settings()
local theme = require('src.ui.theme')
S.look = 'sf'
theme.set_look('sf')
S.map = S.map or {}
S.map.enabled = true
app.open_map(nil, nil, nil, { here = true })
frame(); frame()
check(app.state.open.map, 'SF map is open')
local tabs = {}
for _, l in ipairs(FAKE.labels) do
    local n = l:match('^##sffloor_(%d+)$')
    if n and not tabs[n] then tabs[n] = true; tabs[#tabs + 1] = n end
end
check(#tabs >= 2, 'zone 9 has several floor tabs')
local function errors()
    for _, line in ipairs(FAKE.printed) do
        if tostring(line):find('問題が起きました', 1, true) or tostring(line):find('nil value', 1, true) then return line end
    end
    return nil
end
FAKE.printed = {}
for _, n in ipairs(tabs) do
    FAKE.clicks['##sffloor_' .. n] = true
    frame()
    eq(errors(), nil, 'no draw error after clicking floor ' .. n)
    frame()
end
-- 拡大したあとに階を変えても、見え方は 1 倍に戻る（nil にはならない）
FAKE.clicks['##zoom_in'] = true; frame(); frame()
FAKE.clicks['##sffloor_' .. tabs[1]] = true; frame()
FAKE.clicks['##sffloor_' .. tabs[2]] = true; frame()
eq(errors(), nil, 'no draw error after zoom + floor change')
print('test_314_map_floor ok')
