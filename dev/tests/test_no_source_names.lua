-- 出典の名前は画面に出さない。ゲーム用データ（data/ の JSON 全部）の文に、出典の欄
-- （source・sources・extra_sources・location_sources・url・urls）以外で BG Wiki・用語辞典・FFXIclopedia・
-- LSB・HorizonXI などの名前が入っていたら落とす。
require('harness')
local json = require('src.lib.json')

local SOURCE_KEYS = { source = true, sources = true, extra_sources = true, location_sources = true, url = true, urls = true }
local PLAIN = { 'BG Wiki', 'BGWiki', 'bg-wiki', 'bgwiki', '用語辞典', 'wiki.ffo.jp', 'FFXIclopedia', 'ffxiclopedia',
                'LandSandBoat', 'HorizonXI', 'horizonxi' }
local WORDS = { 'BG', 'LSB', 'ffo' }   -- 単語として出たときだけ（「Expanding Horizons」などは通す）

local function bad_name(s)
    for _, w in ipairs(PLAIN) do if s:find(w, 1, true) then return w end end
    for _, w in ipairs(WORDS) do if s:find('%f[%w]' .. w .. '%f[%W]') then return w end end
    return nil
end
-- 判定そのものの確かめ
eq(bad_name('座標は BG Wiki に合わせた'), 'BG Wiki', 'detects BG Wiki')
eq(bad_name('（BG ではLv20）'), 'BG', 'detects BG as a word')
eq(bad_name('BFの中身は用語辞典「骨ミッション」の項。'), '用語辞典', 'detects 用語辞典')
eq(bad_name('LSB の値'), 'LSB', 'detects LSB')
eq(bad_name('Expanding Horizons'), nil, 'quest names pass')
eq(bad_name('BGM'), nil, 'other words pass')

local n_strings, found = 0, {}
local function walk(v, path, file)
    local t = type(v)
    if t == 'string' then
        n_strings = n_strings + 1
        local w = bad_name(v)
        if w then found[#found + 1] = file .. ' ' .. path .. ' [' .. w .. '] ' .. v:sub(1, 80) end
    elseif t == 'table' then
        for k, x in pairs(v) do
            if not (type(k) == 'string' and SOURCE_KEYS[k]) then walk(x, path .. '/' .. tostring(k), file) end
        end
    end
end

local h = io.popen('cd "' .. ROOT .. '/data" && find . -name "*.json" | sort')
local n_files = 0
for rel in h:lines() do
    n_files = n_files + 1
    local f = io.open(ROOT .. '/data/' .. rel, 'rb')
    local doc = json.decode(f:read('*a')); f:close()
    walk(doc, '', rel)
end
h:close()
check(n_files >= 10, 'data files scanned: ' .. n_files)
check(n_strings > 10000, 'strings scanned: ' .. n_strings)
eq(#found, 0, 'source names on screen:\n' .. table.concat(found, '\n', 1, math.min(#found, 20)))
