-- 0.1.259：グラデ板のフォルダ作成とパス探索は、色キーが分かっていれば繰り返さない
require('harness')
local ext = require('src.platform.vanacore_ext')
local app = require('src.app')

eq(app.VERSION, '1.1.324', 'version')

ext.set_addon_dir(TMP .. '/')

local execs = {}
local real_exec = os.execute
os.execute = function (cmd)
    execs[#execs + 1] = tostring(cmd)
    return real_exec(cmd)
end

local c1, c2 = { 10, 20, 30 }, { 200, 100, 50 }
local p1 = ext._gradient_file(c1, c2, 80, 18)
check(p1 ~= nil, 'wrote first plate')
local mkdir_n = 0
for _, c in ipairs(execs) do
    if c:find('mkdir', 1, true) then mkdir_n = mkdir_n + 1 end
end
check(mkdir_n <= 1, 'mkdir ran at most once on the first miss: ' .. tostring(mkdir_n))
local after_first = #execs

local p2 = ext._gradient_file(c1, c2, 240, 60)
eq(p1, p2, 'same color pair still shares one file')
eq(#execs, after_first, 'cached color key does not call os.execute again')

local c3, c4 = { 1, 2, 3 }, { 4, 5, 6 }
local p3 = ext._gradient_file(c3, c4, 80, 18)
check(p3 ~= nil and p3 ~= p1, 'a new color pair writes its own plate')
local mkdir2 = 0
for _, c in ipairs(execs) do
    if c:find('mkdir', 1, true) then mkdir2 = mkdir2 + 1 end
end
eq(mkdir2, mkdir_n, 'a new color still uses the cached cache dir (no second mkdir)')

-- ソース：先に色キーを見て、当たれば cache_dir に進まない
local src = io.open(ROOT .. '/src/platform/vanacore_ext.lua', 'r'):read('*a')
check(src:find('if cache_dir_ready then return cache_dir_ready end', 1, true) ~= nil, 'cache_dir returns the remembered path')
check(src:find('local hit = grad_path_by_key[key]', 1, true) ~= nil, 'color key is looked up first')
check(src:find('if hit then return hit, ext.GRAD_SRC_W, ext.GRAD_SRC_H end', 1, true) ~= nil, 'hit returns before cache_dir')

os.execute = real_exec
print('test_grad_259 ok')
