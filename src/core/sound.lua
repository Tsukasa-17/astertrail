--[[
  Astertrail - sound（受注・完了の効果音。0.1.183〜。0.1.198 で明るい長調のファンファーレに作り直し）
  ほかのアドオンやゲームの音は使わない。ここで短いファンファーレを数式から作り、
  WAV（PCM 16bit・モノラル・22050Hz）の文字列にする。既存の曲のメロディは使わない
  （FF の勝利ファンファーレ、ドラクエのレベルアップ、モンハンのクエストクリアなど、よく知られたフレーズは使わない）。
  音量（0〜100）は振幅に掛ける（PlaySound には音量の指定が無いため）。ファイルに書いて鳴らすのは app と platform。
    accept   … 受注：ニ長調。金管風の「出発」の掛け声。I–IV–V–I、短いアルペジオ、約 2.3 秒
    complete … 完了：変ロ長調。より大きな勝利のファンファーレ。ティンパニとシンバル、約 3.8 秒
  VERSION を上げると、設定フォルダの WAV を新しい名前で作り直す。
]]

local sound = {}

sound.RATE = 22050
sound.VERSION = 3
sound.KINDS = { accept = true, complete = true }

-- A4=440。MIDI ノート番号 → 周波数
local function hz(m)
    return 440 * 2 ^ ((m - 69) / 12)
end

-- 決定的な雑音（毎回同じ波。ゲームの音源は使わない）
local function nse(i)
    local x = math.sin(i * 12.9898 + 78.233) * 43758.5453
    return (x - math.floor(x)) * 2 - 1
end

local function u16(n) return string.char(n % 256, math.floor(n / 256) % 256) end
local function u32(n)
    return string.char(n % 256, math.floor(n / 256) % 256, math.floor(n / 65536) % 256, math.floor(n / 16777216) % 256)
end

-- 金管風：鋸波に近い倍音＋フィルターの包絡＋ごく弱いビブラート
local function add_brass(buf, rate, f, t0, dur, amp)
    local lp = 0
    local n = #buf
    local attack = 0.016
    for i = 1, n do
        local t = (i - 1) / rate - t0
        if t >= 0 and t <= dur then
            local env
            if t < attack then
                env = t / attack
            else
                env = math.exp(-(t - attack) * 2.05 / dur)
            end
            local tail = math.min(1, (dur - t) / 0.07)
            local fenv
            if t < 0.045 then
                fenv = 0.38 + 0.55 * (t / 0.045)
            else
                fenv = 0.93 - 0.50 * ((t - 0.045) / math.max(0.02, dur - 0.045))
            end
            if fenv < 0.20 then fenv = 0.20 elseif fenv > 1 then fenv = 1 end
            local vib = 1 + 0.0036 * math.sin(2 * math.pi * 5.4 * t)
            local w = 2 * math.pi * f * vib * t
            -- 倍音（鋸波に近い。高いものはフィルターで落とす）
            local sig = 0
            local harm = { 1.00, 0.58, 0.40, 0.28, 0.20, 0.14, 0.10, 0.07, 0.045 }
            for k = 1, #harm do
                sig = sig + harm[k] * (fenv ^ ((k - 1) * 0.82)) * math.sin(k * w)
            end
            sig = sig / 2.45
            local alpha = 0.16 + 0.72 * fenv
            lp = lp + alpha * (sig - lp)
            buf[i] = buf[i] + amp * env * tail * lp
        end
    end
end

-- ティンパニ：低い正弦と短い打音
local function add_timp(buf, rate, f, t0, dur, amp)
    local n = #buf
    for i = 1, n do
        local t = (i - 1) / rate - t0
        if t >= 0 and t <= dur then
            local env = math.min(1, t / 0.008) * math.exp(-t * 6.2)
            local sig = math.sin(2 * math.pi * f * t)
                + 0.22 * math.sin(2 * math.pi * f * 2 * t) * math.exp(-t * 11)
            local thump = nse(i) * math.exp(-t * 42) * 0.32
            buf[i] = buf[i] + amp * env * (sig + thump)
        end
    end
end

-- シンバル風：高域の雑音と金属寄りの倍音
local function add_cym(buf, rate, t0, dur, amp)
    local n = #buf
    local hp, prev = 0, 0
    for i = 1, n do
        local t = (i - 1) / rate - t0
        if t >= 0 and t <= dur then
            local env = math.min(1, t / 0.010) * math.exp(-t * 3.4)
            local x = nse(i + 17)
            hp = x - prev + 0.91 * hp
            prev = x
            local metal = 0
                + 0.18 * math.sin(2 * math.pi * 2480 * t + 0.4)
                + 0.12 * math.sin(2 * math.pi * 3720 * t + 1.1)
                + 0.08 * math.sin(2 * math.pi * 5310 * t + 2.0)
            metal = metal * math.exp(-t * 5.5)
            buf[i] = buf[i] + amp * env * (hp * 0.55 + metal)
        end
    end
end

-- 鈴・きらめき（長和音の上に置く。減衰は長め）
local function add_bell(buf, rate, f, t0, dur, amp)
    local n = #buf
    for i = 1, n do
        local t = (i - 1) / rate - t0
        if t >= 0 and t <= dur then
            local env = math.min(1, t / 0.006) * math.exp(-t * 3.0)
            local tail = math.min(1, (dur - t) / 0.10)
            local w = 2 * math.pi * f * t
            local sig = math.sin(w)
                + 0.32 * math.sin(2 * w) * math.exp(-t * 4)
                + 0.12 * math.sin(3 * w) * math.exp(-t * 6)
                + 0.08 * math.sin(2 * math.pi * f * 5.04 * t) * math.exp(-t * 8)
            buf[i] = buf[i] + amp * env * tail * sig / 1.4
        end
    end
end

-- 残響（ディレイの重ね）
local function reverb(buf, rate, tail)
    local delays = { 0.027, 0.043, 0.068, 0.097, 0.133, 0.181 }
    local gains  = { 0.34, 0.27, 0.21, 0.16, 0.11, 0.07 }
    local n = #buf
    local extra = math.floor(tail * rate)
    local out = {}
    for i = 1, n + extra do out[i] = buf[i] or 0 end
    for d = 1, #delays do
        local off = math.floor(delays[d] * rate)
        local g = gains[d]
        for i = 1, n do
            local j = i + off
            if j <= #out then out[j] = out[j] + (buf[i] or 0) * g end
        end
    end
    local fade = math.max(1, math.floor(0.24 * rate))
    for i = #out - fade + 1, #out do
        if i > 0 then out[i] = out[i] * ((#out - i + 1) / fade) end
    end
    return out
end

-- 自作のモチーフ（長調。短2度や暗い響きは使わない）
-- typ: brass / timp / cym / bell。midi は cym では使わない
local EVENTS = {
    -- ニ長調。短い「出発」の掛け声（I–IV–V–I）
    accept = {
        { typ = 'timp', midi = 38, t = 0.00, dur = 0.48, amp = 0.82 },
        { typ = 'cym',             t = 0.00, dur = 0.55, amp = 0.38 },
        { typ = 'brass', midi = 50, t = 0.00, dur = 0.46, amp = 0.42 },
        { typ = 'brass', midi = 57, t = 0.00, dur = 0.46, amp = 0.50 },
        { typ = 'brass', midi = 62, t = 0.00, dur = 0.46, amp = 0.62 },
        { typ = 'brass', midi = 66, t = 0.00, dur = 0.46, amp = 0.70 },
        { typ = 'brass', midi = 69, t = 0.08, dur = 0.13, amp = 0.92 },
        { typ = 'brass', midi = 74, t = 0.20, dur = 0.22, amp = 1.00 },
        { typ = 'brass', midi = 55, t = 0.30, dur = 0.42, amp = 0.40 },
        { typ = 'brass', midi = 62, t = 0.30, dur = 0.42, amp = 0.52 },
        { typ = 'brass', midi = 67, t = 0.30, dur = 0.42, amp = 0.66 },
        { typ = 'brass', midi = 71, t = 0.30, dur = 0.42, amp = 0.58 },
        { typ = 'brass', midi = 66, t = 0.32, dur = 0.10, amp = 0.86 },
        { typ = 'brass', midi = 69, t = 0.42, dur = 0.10, amp = 0.90 },
        { typ = 'brass', midi = 74, t = 0.52, dur = 0.20, amp = 1.00 },
        { typ = 'brass', midi = 57, t = 0.62, dur = 0.42, amp = 0.40 },
        { typ = 'brass', midi = 64, t = 0.62, dur = 0.42, amp = 0.54 },
        { typ = 'brass', midi = 69, t = 0.62, dur = 0.42, amp = 0.66 },
        { typ = 'brass', midi = 73, t = 0.62, dur = 0.42, amp = 0.60 },
        { typ = 'brass', midi = 76, t = 0.64, dur = 0.11, amp = 0.88 },
        { typ = 'brass', midi = 73, t = 0.75, dur = 0.11, amp = 0.86 },
        { typ = 'brass', midi = 74, t = 0.86, dur = 0.58, amp = 1.00 },
        { typ = 'brass', midi = 50, t = 0.86, dur = 0.95, amp = 0.38 },
        { typ = 'brass', midi = 57, t = 0.86, dur = 0.95, amp = 0.46 },
        { typ = 'brass', midi = 62, t = 0.86, dur = 0.95, amp = 0.58 },
        { typ = 'brass', midi = 66, t = 0.86, dur = 0.95, amp = 0.70 },
        { typ = 'brass', midi = 69, t = 0.86, dur = 0.95, amp = 0.62 },
        { typ = 'brass', midi = 74, t = 0.86, dur = 0.95, amp = 0.55 },
        { typ = 'brass', midi = 62, t = 0.90, dur = 0.08, amp = 0.48 },
        { typ = 'brass', midi = 66, t = 0.97, dur = 0.08, amp = 0.52 },
        { typ = 'brass', midi = 69, t = 1.04, dur = 0.08, amp = 0.56 },
        { typ = 'brass', midi = 74, t = 1.11, dur = 0.08, amp = 0.60 },
        { typ = 'brass', midi = 78, t = 1.18, dur = 0.16, amp = 0.64 },
        { typ = 'bell',  midi = 81, t = 1.24, dur = 0.85, amp = 0.36 },
        { typ = 'bell',  midi = 86, t = 1.30, dur = 0.85, amp = 0.30 },
        { typ = 'bell',  midi = 90, t = 1.36, dur = 0.80, amp = 0.22 },
    },
    -- 変ロ長調。より長く、勝利の響き（I–IV–V–I＋広いアルペジオ）
    complete = {
        { typ = 'timp', midi = 34, t = 0.00, dur = 0.70, amp = 0.90 },
        { typ = 'timp', midi = 46, t = 0.00, dur = 0.55, amp = 0.62 },
        { typ = 'cym',             t = 0.00, dur = 0.90, amp = 0.50 },
        { typ = 'brass', midi = 46, t = 0.00, dur = 0.58, amp = 0.40 },
        { typ = 'brass', midi = 53, t = 0.00, dur = 0.58, amp = 0.48 },
        { typ = 'brass', midi = 58, t = 0.00, dur = 0.58, amp = 0.58 },
        { typ = 'brass', midi = 62, t = 0.00, dur = 0.58, amp = 0.66 },
        { typ = 'brass', midi = 65, t = 0.00, dur = 0.58, amp = 0.72 },
        { typ = 'brass', midi = 65, t = 0.12, dur = 0.16, amp = 0.90 },
        { typ = 'brass', midi = 70, t = 0.28, dur = 0.20, amp = 0.96 },
        { typ = 'brass', midi = 74, t = 0.48, dur = 0.26, amp = 1.00 },
        { typ = 'brass', midi = 51, t = 0.62, dur = 0.52, amp = 0.40 },
        { typ = 'brass', midi = 58, t = 0.62, dur = 0.52, amp = 0.50 },
        { typ = 'brass', midi = 63, t = 0.62, dur = 0.52, amp = 0.64 },
        { typ = 'brass', midi = 67, t = 0.62, dur = 0.52, amp = 0.60 },
        { typ = 'brass', midi = 75, t = 0.66, dur = 0.14, amp = 0.92 },
        { typ = 'brass', midi = 74, t = 0.80, dur = 0.10, amp = 0.88 },
        { typ = 'brass', midi = 72, t = 0.90, dur = 0.10, amp = 0.88 },
        { typ = 'brass', midi = 70, t = 1.00, dur = 0.18, amp = 0.92 },
        { typ = 'brass', midi = 53, t = 1.10, dur = 0.58, amp = 0.40 },
        { typ = 'brass', midi = 60, t = 1.10, dur = 0.58, amp = 0.52 },
        { typ = 'brass', midi = 65, t = 1.10, dur = 0.58, amp = 0.64 },
        { typ = 'brass', midi = 69, t = 1.10, dur = 0.58, amp = 0.62 },
        { typ = 'brass', midi = 65, t = 1.14, dur = 0.10, amp = 0.84 },
        { typ = 'brass', midi = 69, t = 1.24, dur = 0.10, amp = 0.88 },
        { typ = 'brass', midi = 72, t = 1.34, dur = 0.14, amp = 0.92 },
        { typ = 'brass', midi = 77, t = 1.48, dur = 0.30, amp = 1.00 },
        { typ = 'cym',             t = 1.70, dur = 0.70, amp = 0.28 },
        { typ = 'timp', midi = 46, t = 1.70, dur = 0.50, amp = 0.55 },
        { typ = 'brass', midi = 46, t = 1.70, dur = 1.40, amp = 0.36 },
        { typ = 'brass', midi = 53, t = 1.70, dur = 1.40, amp = 0.44 },
        { typ = 'brass', midi = 58, t = 1.70, dur = 1.40, amp = 0.54 },
        { typ = 'brass', midi = 62, t = 1.70, dur = 1.40, amp = 0.62 },
        { typ = 'brass', midi = 65, t = 1.70, dur = 1.40, amp = 0.70 },
        { typ = 'brass', midi = 70, t = 1.70, dur = 1.40, amp = 0.66 },
        { typ = 'brass', midi = 74, t = 1.70, dur = 1.40, amp = 0.58 },
        { typ = 'brass', midi = 77, t = 1.70, dur = 1.40, amp = 0.50 },
        { typ = 'brass', midi = 58, t = 1.76, dur = 0.08, amp = 0.46 },
        { typ = 'brass', midi = 62, t = 1.84, dur = 0.08, amp = 0.50 },
        { typ = 'brass', midi = 65, t = 1.92, dur = 0.08, amp = 0.54 },
        { typ = 'brass', midi = 70, t = 2.00, dur = 0.08, amp = 0.58 },
        { typ = 'brass', midi = 74, t = 2.08, dur = 0.08, amp = 0.62 },
        { typ = 'brass', midi = 77, t = 2.16, dur = 0.10, amp = 0.66 },
        { typ = 'brass', midi = 82, t = 2.26, dur = 0.85, amp = 0.80 },
        { typ = 'bell',  midi = 82, t = 2.20, dur = 1.10, amp = 0.38 },
        { typ = 'bell',  midi = 86, t = 2.28, dur = 1.05, amp = 0.32 },
        { typ = 'bell',  midi = 89, t = 2.36, dur = 1.00, amp = 0.26 },
        { typ = 'bell',  midi = 94, t = 2.44, dur = 0.95, amp = 0.20 },
    },
}

function sound.samples(kind)
    local ev = EVENTS[kind]
    if not ev then return nil end
    local total = 0
    for _, e in ipairs(ev) do total = math.max(total, e.t + e.dur) end
    local tail = (kind == 'complete') and 0.58 or 0.32
    local count = math.floor(total * sound.RATE) + 1
    local dry = {}
    for i = 1, count do dry[i] = 0 end
    for _, e in ipairs(ev) do
        if e.typ == 'brass' then
            add_brass(dry, sound.RATE, hz(e.midi), e.t, e.dur, e.amp)
        elseif e.typ == 'timp' then
            add_timp(dry, sound.RATE, hz(e.midi), e.t, e.dur, e.amp)
        elseif e.typ == 'cym' then
            add_cym(dry, sound.RATE, e.t, e.dur, e.amp)
        elseif e.typ == 'bell' then
            add_bell(dry, sound.RATE, hz(e.midi), e.t, e.dur, e.amp)
        end
    end
    local out = reverb(dry, sound.RATE, tail)
    local peak = 0
    for i = 1, #out do
        local a = math.abs(out[i])
        if a > peak then peak = a end
    end
    -- ピークを揃えて、割れないように少し余裕を残す
    local gain = (peak > 0) and (0.84 / peak) or 0
    for i = 1, #out do out[i] = out[i] * gain end
    return out
end

function sound.level(volume)
    local v = math.floor((tonumber(volume) or 0) / 10 + 0.5) * 10
    if v < 0 then v = 0 elseif v > 100 then v = 100 end
    return v
end

function sound.wav(kind, volume)
    local s = sound.samples(kind)
    if not s then return nil end
    local lv = sound.level(volume)
    if lv <= 0 then return nil end
    local gain = (lv / 100) ^ 1.5
    local parts = {}
    for i, v in ipairs(s) do
        local x = math.floor(v * gain * 32767 + 0.5)
        if x > 32767 then x = 32767 elseif x < -32768 then x = -32768 end
        if x < 0 then x = x + 65536 end
        parts[i] = u16(x)
    end
    local data = table.concat(parts)
    local rate = sound.RATE
    return 'RIFF' .. u32(36 + #data) .. 'WAVE'
        .. 'fmt ' .. u32(16) .. u16(1) .. u16(1) .. u32(rate) .. u32(rate * 2) .. u16(2) .. u16(16)
        .. 'data' .. u32(#data) .. data
end

function sound.file_name(kind, volume)
    return 'astertrail_' .. tostring(kind) .. '_v' .. tostring(sound.level(volume)) .. '_' .. tostring(sound.VERSION) .. '.wav'
end

return sound
