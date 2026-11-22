--[[
  Astertrail - エミネンスの「くり返し」「日・週・月で受け直せる」目標（0.1.293〜）
  - 番号の印は data/roe_cycles.json（dev/build_roe_cycles.py が LSB の roe_records.lua の flags から作る）。
    無い番号・ファイルが無いときは、クライアント DAT のくり返しの印だけを使う（推測しない）。
  - 達成が消える時刻（サーバーと同じ、すべて JST）：
      daily / unity … 毎日 0:00、weekly … 毎週月曜 0:00、monthly … 毎月 1 日 0:00（LSB の決め方）
  - 日替わり・週替わりの組（ユニティ）は src/core/roe.lua の rotation_block で見る（呼ぶ側が時刻つきで渡す）。
  - 状態：
      active … 受けている
      open   … いま受けられる（くり返しできる達成も含む）
      wait   … いまは受けられない（期間外）。at は次に受けられる時刻（分かるときだけ）
      done   … 達成済みで、くり返しも受け直しもできない
]]

local roe = require('src.core.roe')

local M = {}

M.DAY = 86400
M.JST = 9 * 3600
M.SEARCH_DAYS = 62

local sets = nil

local function to_set(list)
    local s = {}
    for _, v in ipairs(type(list) == 'table' and list or {}) do
        local n = tonumber(v)
        if n then s[n] = true end
    end
    return s
end

-- doc: data/roe_cycles.json を読んだ表（nil で外す）
function M.bind(doc)
    if type(doc) ~= 'table' or type(doc.known) ~= 'table' then sets = nil; return false end
    sets = {
        known = to_set(doc.known), ['repeat'] = to_set(doc['repeat']),
        daily = to_set(doc.daily), weekly = to_set(doc.weekly), monthly = to_set(doc.monthly),
        unity = to_set(doc.unity), timed = to_set(doc.timed),
    }
    -- 期間限定の入れ替え表（0.1.294〜）：[曜日 日=1〜土=7][枠 1〜6]（JST の 0・4・8・12・16・20 時から 4 時間）
    local ts = doc.timed_schedule
    if type(ts) == 'table' and #ts == 7 then
        local ok = true
        for d = 1, 7 do if type(ts[d]) ~= 'table' or #ts[d] ~= 6 then ok = false end end
        sets.timed_schedule = ok and ts or nil
    end
    return true
end

-- サーバーに入っていないと分かっている番号（0.1.294〜。data/roe_unimplemented.json の missing）
local missing = nil

function M.bind_missing(doc)
    if type(doc) ~= 'table' or type(doc.missing) ~= 'table' then missing = nil; return false end
    missing = to_set(doc.missing)
    return true
end

function M.known_missing(id)
    id = tonumber(id)
    return missing ~= nil and id ~= nil and missing[id] == true
end

function M.missing_loaded() return missing ~= nil end

function M.load(fs, base, json)
    if not (fs and fs.read) then sets = nil; missing = nil; return false end
    local t = fs.read(base .. 'roe_cycles.json')
    local doc = t and json and json.decode(t) or nil
    local u = fs.read(base .. 'roe_unimplemented.json')
    M.bind_missing(u and json and json.decode(u) or nil)
    return M.bind(doc)
end

function M.loaded() return sets ~= nil end

-- 達成が消える区切り：'daily' / 'weekly' / 'monthly' / 'unity'、無ければ nil
function M.kind(id)
    id = tonumber(id)
    if not (sets and id) then return nil end
    if sets.daily[id] then return 'daily' end
    if sets.weekly[id] then return 'weekly' end
    if sets.monthly[id] then return 'monthly' end
    if sets.unity[id] then return 'unity' end
    return nil
end

-- くり返しできるか。LSB に載っている番号はその印、載っていなければ DAT の印
function M.repeatable(id, dat_flag)
    id = tonumber(id)
    if sets and id and sets.known[id] then return sets['repeat'][id] == true end
    return dat_flag == true
end

---------------------------------------------------------------------------
-- 時刻（JST。端末の時間帯は使わない）
---------------------------------------------------------------------------

-- その日の 0:00 JST（roe.EPOCH からの日数 d）
local function midnight(d) return roe.EPOCH + d * M.DAY end

function M.next_midnight(now)
    return midnight(roe.days_since(now) + 1)
end

-- 月曜 0:00 JST（2002-01-01 は火曜。月曜を 0 とした曜日 = (d + 1) % 7）
function M.weekday(now)
    return (roe.days_since(now) + 1) % 7
end

function M.next_monday(now)
    local d = roe.days_since(now)
    return midnight(d + 7 - (d + 1) % 7)
end

-- 1970-01-01 からの日数（グレゴリオ暦）
local function days_from_civil(y, m, d)
    if m <= 2 then y = y - 1 end
    local era = math.floor(y / 400)
    local yoe = y - era * 400
    local mp = (m + 9) % 12
    local doy = math.floor((153 * mp + 2) / 5) + d - 1
    local doe = yoe * 365 + math.floor(yoe / 4) - math.floor(yoe / 100) + doy
    return era * 146097 + doe - 719468
end
M._days_from_civil = days_from_civil

-- JST の年・月・日・時・分
function M.jst_parts(t)
    local d = os.date('!*t', math.floor(tonumber(t) or 0) + M.JST)
    return d.year, d.month, d.day, d.hour, d.min
end

function M.next_month(now)
    local y, m = M.jst_parts(now)
    m = m + 1
    if m > 12 then m, y = 1, y + 1 end
    return days_from_civil(y, m, 1) * M.DAY - M.JST
end

-- 達成が消える次の時刻（区切りが無ければ nil）
function M.reset_after(kind, now)
    if kind == 'daily' or kind == 'unity' then return M.next_midnight(now) end
    if kind == 'weekly' then return M.next_monday(now) end
    if kind == 'monthly' then return M.next_month(now) end
    return nil
end

-- JST の曜日（日=0〜土=6。2002-01-01 は火曜）
function M.jst_weekday_sun0(now)
    return (roe.days_since(now) + 2) % 7
end

-- 期間限定の番号が次にゲームから入る時刻（入れ替え表が無い・載っていなければ nil）
-- いまの枠に入っている番号は「いま」ではなく次に入る時刻（受けていなければ、もう入れ替わったあと）
function M.next_timed(id, now)
    id = tonumber(id)
    local ts = sets and sets.timed_schedule
    if not (ts and id) then return nil end
    local d0 = roe.days_since(now)
    local blk = math.floor(((tonumber(now) or 0) - midnight(d0)) / (4 * 3600))
    for k = 1, 7 * 6 + 1 do
        local b = blk + k
        local d = d0 + math.floor(b / 6)
        local slot = b % 6
        local wd = (d + 2) % 7
        if tonumber(ts[wd + 1][slot + 1]) == id then
            return midnight(d) + slot * 4 * 3600
        end
    end
    return nil
end

-- 残り時間（秒 → 時間・分。分は切り上げ）
function M.remain_parts(at, now)
    local sec = math.max(0, math.floor((tonumber(at) or 0) - (tonumber(now) or 0)))
    local mins = math.ceil(sec / 60)
    return math.floor(mins / 60), mins % 60
end

-- 表示用「11/23 0:00」（JST）
function M.format_when(t)
    if not t then return nil end
    local _, mo, d, h, mi = M.jst_parts(t)
    return string.format('%d/%d %d:%02d', mo, d, h, mi)
end

---------------------------------------------------------------------------
-- 状態
---------------------------------------------------------------------------

-- 組・週で止まる理由のうち、待てば受けられるもの
local WAITABLE = { not_today = true, not_this_week = true }

-- 0:00 JST の区切りを順に見て、after 以降で組・週の止めが無くなる最初の時刻
local function first_open(id, now, after, rotation_at)
    local d0 = roe.days_since(now)
    for k = 1, M.SEARCH_DAYS do
        local t = midnight(d0 + k)
        if (not after or t >= after) and not (rotation_at and rotation_at(id, t)) then return t end
    end
    return nil
end

-- o = { st, dat_repeat, now, seen_at, rotation_at = function (id, t) -> 理由 or nil }
-- 戻り値: { mode, reason, at, kind, repeat }
function M.status(id, o)
    o = o or {}
    local now = tonumber(o.now) or os.time()
    local st = o.st or 'not_accepted'
    local rep = M.repeatable(id, o.dat_repeat)
    local kind = M.kind(id)
    if st == 'accepted' then return { mode = 'active', kind = kind, ['repeat'] = rep } end
    local after
    if st == 'completed' and not rep then
        if not kind then return { mode = 'done', ['repeat'] = false } end
        -- 達成を見た時刻から次の区切りまでは期間外。区切りを過ぎたら（サーバーが消すはず）受けられる扱い
        local reset = M.reset_after(kind, tonumber(o.seen_at) or now)
        if reset and now < reset then
            local at = first_open(id, now, reset, o.rotation_at)
            return { mode = 'wait', reason = 'cycle_' .. kind, at = at, kind = kind, ['repeat'] = false }
        end
    end
    local why = o.rotation_at and o.rotation_at(id, now) or nil
    if why then
        local at = WAITABLE[why] and first_open(id, now, after, o.rotation_at) or nil
        if why == 'timed_auto' then at = M.next_timed(id, now) end
        return { mode = 'wait', reason = why, at = at, kind = kind, ['repeat'] = rep }
    end
    return { mode = 'open', kind = kind, ['repeat'] = rep }
end

-- 一覧の並び：受注中 1、受けられる 2、期間外 3、未実装 4、達成 5（0.1.294〜 未実装を足した）
M.RANK = { active = 1, open = 2, wait = 3, unimplemented = 4, done = 5 }

return M
