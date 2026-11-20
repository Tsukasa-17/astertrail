--[[
  Astertrail - 所持（0.1.184〜、t297）：手順の「必要な品」をいくつ持っているか。
  読むのは platform（VanaCore の vana.game.container / key_items、Ashita の GetInventory）。ここは数えて書くだけ。
  決まり：
  - かばん・金庫・金庫2・モグ収納・モグロッカー・サッチェル・サック・ケース・ワードローブ1〜8 を全部数える。
    テンポラリ（3）とごみ箱（17）は数えない。
  - まだ届いていない・読めていない入れ物は「空」にしない（その分は未確認）。
  - 持っているだけで手順を済みにはしない（ここは表示用の数だけ）。
  - 報酬は数えない（必要な品だけ）。
  snapshot = { containers = { [番号] = { [品の番号] = 個数 } または false（未確認） }, key = function(id) → true/false/nil }
]]

local gil = require('src.core.gil')
local possession = {}

-- 数える入れ物（並びは画面の内訳の順）
possession.CONTAINERS = { 0, 1, 9, 2, 4, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 16 }
possession.SKIP = { [3] = true, [17] = true }   -- テンポラリ・ごみ箱

-- 1つの品の数。{ total = n, parts = { {cid, n}, ... }, unknown = { cid, ... } }
function possession.count(snap, item_id)
    local r = { total = 0, parts = {}, unknown = {} }
    local cs = snap and snap.containers
    for _, cid in ipairs(possession.CONTAINERS) do
        local c = cs and cs[cid]
        if type(c) ~= 'table' then
            r.unknown[#r.unknown + 1] = cid
        else
            local n = tonumber(c[item_id]) or 0
            if n > 0 then
                r.total = r.total + n
                r.parts[#r.parts + 1] = { cid, n }
            end
        end
    end
    return r
end

-- 必要の欄 1 つの状態。
--   { state = 'unknown' }                         … 番号が分からない・何も読めない
--   { state = 'enough' | 'short', have, need, parts, unknown, kind = 'item' }
--   { state = 'owned' | 'missing' | 'unknown', kind = 'key' }
function possession.count_many(snap, ids)
    local r = { total = 0, parts = {}, unknown = {} }
    local unk_seen, part_idx = {}, {}
    for _, id in ipairs(ids or {}) do
        local c = possession.count(snap, tonumber(id))
        r.total = r.total + (c.total or 0)
        for _, p in ipairs(c.parts or {}) do
            local k = p[1]
            if part_idx[k] then
                local e = r.parts[part_idx[k]]
                e[2] = e[2] + p[2]
            else
                r.parts[#r.parts + 1] = { p[1], p[2] }
                part_idx[k] = #r.parts
            end
        end
        for _, cid in ipairs(c.unknown or {}) do
            if not unk_seen[cid] then
                unk_seen[cid] = true
                r.unknown[#r.unknown + 1] = cid
            end
        end
    end
    return r
end

function possession.need_state(snap, n)
    if type(n) ~= 'table' then return { state = 'unknown' } end
    if gil.is_gil_need(n) then return { state = 'unknown', kind = 'gil' } end
    local key_ids = n.key_item_ids
    if type(key_ids) ~= 'table' or #key_ids == 0 then
        if n.kind == 'key_item' or n.key_item_id ~= nil then
            key_ids = { n.key_item_id }
        end
    end
    if type(key_ids) == 'table' and #key_ids > 0 then
        if not snap or type(snap.key) ~= 'function' then return { state = 'unknown', kind = 'key' } end
        local any, saw_unknown, saw_false = false, false, false
        for _, id in ipairs(key_ids) do
            local kid = tonumber(id)
            if not kid then saw_unknown = true
            else
                local ok, has = pcall(snap.key, kid)
                if not ok or has == nil then saw_unknown = true
                elseif has then any = true
                else saw_false = true end
            end
        end
        if any then return { state = 'owned', kind = 'key' } end
        if saw_unknown then return { state = 'unknown', kind = 'key' } end
        if saw_false then return { state = 'missing', kind = 'key' } end
        return { state = 'unknown', kind = 'key' }
    end
    local ids = n.item_ids
    if type(ids) ~= 'table' or #ids == 0 then
        if n.item_id then ids = { n.item_id } end
    end
    if type(ids) ~= 'table' or #ids == 0 or not snap or type(snap.containers) ~= 'table' then
        return { state = 'unknown', kind = 'item' }
    end
    local c = possession.count_many(snap, ids)
    local need = math.max(1, tonumber(n.count) or 1)
    local r = { kind = 'item', have = c.total, need = need, parts = c.parts, unknown = c.unknown }
    if c.total >= need then
        r.state = 'enough'
    elseif #c.unknown == #possession.CONTAINERS then
        r.state = 'unknown'
    else
        r.state = 'short'
    end
    return r
end

-- 手順が「足りない」と言い切れるときだけ、その数（足りるか、未確認の入れ物があれば nil）
function possession.known_count(snap, n)
    local s = possession.need_state(snap, n)
    if s.kind == 'key' then
        if s.state == 'owned' then return 1 elseif s.state == 'missing' then return 0 end
        return nil
    end
    if s.state == 'enough' then return s.have end
    if s.state == 'short' and #s.unknown == 0 then return s.have end
    return nil
end

-- 画面の文（例：「○」「2/5」「2/5（未確認あり）」「未所持」「未確認」）
function possession.text(t, s)
    if s.state == 'enough' or s.state == 'owned' then return t('poss.enough') end
    if s.state == 'missing' then return t('poss.key_missing') end
    if s.state == 'short' then
        local base = t('poss.count', { have = s.have, need = s.need })
        if #s.unknown > 0 then base = t('poss.count_partial', { text = base }) end
        return base
    end
    return t('poss.unknown')
end

-- 色の名前（theme）
function possession.color(s)
    if s.state == 'enough' or s.state == 'owned' then return 'good' end
    if s.state == 'short' or s.state == 'missing' then return 'warn' end
    return nil
end

-- どこにいくつ（例：「かばん2・金庫3・モグロッカー未確認」）。持っていて、または未確認があるとき。なければ nil
function possession.where(t, s)
    if s.kind ~= 'item' or not s.parts then return nil end
    if (s.have or 0) <= 0 and #(s.unknown or {}) == 0 then return nil end
    local out = {}
    for _, p in ipairs(s.parts) do
        out[#out + 1] = t('poss.part', { where = t('poss.c' .. p[1]), n = p[2] })
    end
    if #s.unknown == #possession.CONTAINERS then
        out[#out + 1] = t('poss.all_unknown')
    else
        for _, cid in ipairs(s.unknown) do
            out[#out + 1] = t('poss.part_unknown', { where = t('poss.c' .. cid) })
        end
    end
    return table.concat(out, t('poss.sep'))
end

return possession
