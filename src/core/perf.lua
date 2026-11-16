-- 1フレームの重さを測る（0.1.210〜）。/astertrail debug perf で入れる。初期は切ってあり、切っている間は何もしない
local perf = {}

perf.enabled = false
perf.sec = {}      -- name -> { n, sum, max, last }
perf.cnt = {}      -- name -> 回数（入れてから）
perf.frames = 0
perf.started = nil

local clock = os.clock
do
    local ok, ffi = pcall(require, 'ffi')
    if ok and ffi and ffi.os == 'Windows' then
        local okd = pcall(ffi.cdef, [[
            int QueryPerformanceCounter(int64_t *c);
            int QueryPerformanceFrequency(int64_t *f);
        ]])
        local okk, k32 = pcall(ffi.load, 'kernel32')
        if okk and k32 then
            local f = ffi.new('int64_t[1]')
            local c = ffi.new('int64_t[1]')
            local okf = pcall(function () return k32.QueryPerformanceFrequency(f) end)
            local freq = okf and tonumber(f[0]) or 0
            if freq > 0 then
                clock = function ()
                    k32.QueryPerformanceCounter(c)
                    return tonumber(c[0]) / freq
                end
            end
        end
        local _ = okd
    end
end
perf.clock = clock

function perf.set(on)
    perf.enabled = on and true or false
    perf.reset()
end

function perf.reset()
    perf.sec, perf.cnt, perf.frames = {}, {}, 0
    perf.started = clock()
end

-- 測り始め。戻り値を stop に渡す。切っているときは nil
function perf.start()
    if not perf.enabled then return nil end
    return clock()
end

function perf.stop(name, t0)
    if not t0 then return end
    local ms = (clock() - t0) * 1000
    local s = perf.sec[name]
    if not s then s = { n = 0, sum = 0, max = 0, last = 0 }; perf.sec[name] = s end
    s.n = s.n + 1
    s.sum = s.sum + ms
    s.last = ms
    if ms > s.max then s.max = ms end
end

function perf.count(name, n)
    if not perf.enabled then return end
    perf.cnt[name] = (perf.cnt[name] or 0) + (n or 1)
end

function perf.frame()
    if perf.enabled then perf.frames = perf.frames + 1 end
end

-- 平均の短い一覧（チャットに出す・MCP で読む）
function perf.summary()
    local names = {}
    for k in pairs(perf.sec) do names[#names + 1] = k end
    table.sort(names, function (a, b) return perf.sec[a].sum > perf.sec[b].sum end)
    local parts = {}
    for _, k in ipairs(names) do
        local s = perf.sec[k]
        parts[#parts + 1] = string.format('%s %.2fms(max %.1f)', k, s.sum / math.max(1, s.n), s.max)
    end
    local f = math.max(1, perf.frames)
    local cn = {}
    for k in pairs(perf.cnt) do cn[#cn + 1] = k end
    table.sort(cn)
    for _, k in ipairs(cn) do
        parts[#parts + 1] = string.format('%s %.1f/f', k, perf.cnt[k] / f)
    end
    local secs = perf.started and (clock() - perf.started) or 0
    return string.format('[perf] %d frames / %.0fs: ', perf.frames, secs) .. table.concat(parts, ', ')
end

return perf
