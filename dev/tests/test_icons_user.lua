-- 自分のアイコン（0.1.185〜、t301）：assets/marks/ に同じ名前があればそれ、無ければ example/
require('harness')
local ext = require('src.platform.vanacore_ext')

local function read(p) local f = assert(io.open(p, 'rb')); local b = f:read('*a'); f:close(); return b end
local function write(p, b) local f = assert(io.open(p, 'wb')); f:write(b); f:close() end

-- 同梱の絵は example/ にだけある（zip が自分のフォルダに絵を入れない）
local h = io.popen('ls -1 "' .. ROOT .. '/assets/marks"')
local top = {}
for l in h:lines() do top[#top + 1] = l end
h:close()
for _, n in ipairs(top) do check(not n:match('%.png$'), 'no bundled png in the user folder: ' .. n) end
local names = { 'main', 'sub', 'repeat', 'unavailable', 'progress', 'blocked', 'complete', 'talk', 'hunt', 'examine', 'guard', 'fame' }
for _, n in ipairs(names) do
    local f = io.open(ROOT .. '/assets/marks/example/' .. n .. '.png', 'rb')
    check(f ~= nil, 'example has ' .. n); if f then f:close() end
end
check(io.open(ROOT .. '/assets/marks/README.txt', 'rb') ~= nil, 'README in the user folder')

-- 古い同梱の絵の印（大きさ・Adler-32）。0.1.201 で描き直した sub / main / hunt は古い印と違う
-- （assets/marks/ に残った古い同梱の絵は、今までどおり自分の絵にしない）
local redrawn = { sub = true, main = true, hunt = true }
for _, n in ipairs(names) do
    local b = read(ROOT .. '/assets/marks/example/' .. n .. '.png')
    local lg = ext.LEGACY_MARKS[n .. '.png']
    check(lg ~= nil, 'legacy fingerprint exists ' .. n)
    local same = lg[1] == #b and lg[2] == ext._adler32(b)
    if redrawn[n] then
        check(not same, 'updated example differs from leftover legacy ' .. n)
    else
        check(same, 'legacy fingerprint ' .. n)
    end
end
eq(ext._adler32('Wikipedia'), 300286872, 'adler32')

-- 仮のアドオンのフォルダ（Windows の区切り）
local dir = TMP .. '/iconaddon'
os.execute('rm -rf "' .. dir .. '"; mkdir -p "' .. dir .. '/assets/marks/example"')
for _, n in ipairs(names) do write(dir .. '/assets/marks/example/' .. n .. '.png', read(ROOT .. '/assets/marks/example/' .. n .. '.png')) end
ext.set_addon_dir(dir .. '/')
ext.reset_mark_files()
eq(ext.mark_file('talk'), dir .. '/assets/marks/example/talk.png', 'no user file: example')
eq(ext.mark_source('talk'), 'example', 'source example')
-- 前の版が残した同梱の絵（同じ中身）は自分の絵にしない
write(dir .. '/assets/marks/talk.png', read(ROOT .. '/assets/marks/example/talk.png'))
ext.reset_mark_files()
eq(ext.mark_source('talk'), 'example', 'leftover bundled copy is not a user icon')
-- 自分の絵
write(dir .. '/assets/marks/talk.png', 'my own png')
eq(ext.mark_source('talk'), 'example', 'cached until reload')
ext.reset_mark_files()
eq(ext.mark_file('talk'), dir .. '/assets/marks/talk.png', 'user file wins')
eq(ext.mark_source('hunt'), 'example', 'others stay example')
-- 空のファイルは使わない
write(dir .. '/assets/marks/hunt.png', '')
ext.reset_mark_files()
eq(ext.mark_source('hunt'), 'example', 'empty file ignored')

-- VanaCore の箱に渡る名前
local pics = {}
_G.vana = { ui = { image = function (p) pics[#pics + 1] = p; return { set = function () end } end, rect = function () return {} end },
            world = { attach = function () return true end } }
ext.reset_mark_files()
check(ext.attach_available(), 'attach available')

-- 本体のコマンド
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local platform = require('src.platform.ashita')
local r = platform.reload_icons()
check(r and #r.user + #r.example == 12, 'reload lists 12 icons')
FAKE.printed = {}
check(cmd('/astertrail icons'), 'icons command')
check(printed('アイコンを読み直しました') or printed('この環境では'), 'icons command prints')
