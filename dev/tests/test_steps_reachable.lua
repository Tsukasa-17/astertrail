-- 手順のつながり：どの手順も、前の手順の next からたどれる（0.1.84〜）
-- ルートの分かれ目の手順は、全部のルートの最初の手順を next に持つ
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local D = app._data()
local n = 0
for _, kind in ipairs({ 'quest', 'mission' }) do
    for _, q in ipairs(D:list(kind)) do
        local steps = q.steps or {}
        if #steps > 1 then
            local reach = {}
            for _, s in ipairs(steps) do
                for _, nid in ipairs(s.next or {}) do reach[nid] = true end
            end
            for i = 2, #steps do
                check(reach[steps[i].id], 'unreachable step ' .. steps[i].id)
            end
            n = n + 1
        end
    end
end
check(n > 500, 'guides checked ' .. n)
-- 例：朔北の爪牙の分かれ目（手順3）から3つのルートへ
local s = D:step('quest.altana.014#g03')
eq(#s.next, 3, 'altana.014 g03 branches')
