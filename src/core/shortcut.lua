--[[
  Astertrail - core: パッドのショートカット（本を開く・自前のメニューを閉じる）
  入力の読み取りは platform（Ashita の xinput_state / xinput_button）。ここは押している組み合わせの判定だけ。
  ボタンの名前は PlayStation の表記（△○×□・L1/R1 など）。中身は XInput の XINPUT_GAMEPAD（Microsoft の定義）。
]]

local shortcut = {}

-- XInput の wButtons のビット（Microsoft の XINPUT_GAMEPAD の定義）と、PS 表記の名前
-- L2/R2 は wButtons ではなくトリガーの値（bLeftTrigger / bRightTrigger）
shortcut.BUTTONS = {
    { key = 'l1',       bit = 0x0100, label = 'L1' },
    { key = 'l2',       trigger = 'left',  label = 'L2' },
    { key = 'r1',       bit = 0x0200, label = 'R1' },
    { key = 'r2',       trigger = 'right', label = 'R2' },
    { key = 'triangle', bit = 0x8000, label = '△' },
    { key = 'circle',   bit = 0x2000, label = '○' },
    { key = 'cross',    bit = 0x1000, label = '×' },
    { key = 'square',   bit = 0x4000, label = '□' },
    { key = 'up',       bit = 0x0001, label = '↑' },
    { key = 'down',     bit = 0x0002, label = '↓' },
    { key = 'left',     bit = 0x0004, label = '←' },
    { key = 'right',    bit = 0x0008, label = '→' },
    { key = 'l3',       bit = 0x0040, label = 'L3' },
    { key = 'r3',       bit = 0x0080, label = 'R3' },
    { key = 'share',    bit = 0x0020, label = 'SHARE' },
    { key = 'options',  bit = 0x0010, label = 'OPTIONS' },
}
shortcut.BY_KEY = {}
shortcut.ORDER = {}
for i, b in ipairs(shortcut.BUTTONS) do
    shortcut.BY_KEY[b.key] = b
    shortcut.ORDER[b.key] = i
end
-- XInput のトリガーを「押した」とみなす値（Microsoft の XINPUT_GAMEPAD_TRIGGER_THRESHOLD）
shortcut.TRIGGER_THRESHOLD = 30
-- おすすめ（初期値）
shortcut.DEFAULT = {}   -- 0.1.67〜：初めは なし
-- 0.1.66 までの初期値（保存がこれのままなら、自分で決めたものではないとみなして なし にする）
shortcut.OLD_DEFAULT = { 'r1', 'triangle' }

-- xinput_button のボタン番号 → 名前。0〜15 は wButtons のビットの位置、16 は LT（L2）、17 は RT（R2）
-- （VanaCore の説明書 09-input「Controllers」の表と同じ番号。トリガーは state が 0〜255）
function shortcut.key_of_button_id(id)
    id = tonumber(id)
    if id == 16 then return 'l2' end
    if id == 17 then return 'r2' end
    if not id or id < 0 or id > 15 then return nil end
    local bit = 2 ^ id
    for _, b in ipairs(shortcut.BUTTONS) do
        if b.bit == bit then return b.key end
    end
    return nil
end

-- xinput_button の state が「押している」か。ボタンは 0/1、トリガー（16・17）は 0〜255 なのでしきい値で見る
function shortcut.button_down(id, st)
    st = tonumber(st) or 0
    id = tonumber(id)
    if id == 16 or id == 17 then return st > shortcut.TRIGGER_THRESHOLD end
    return st ~= 0
end

-- DirectInput のパッド（XInput でないもの）。dinput_button の button は DirectInput のデータの位置で、
-- ボタンは 48＋n（説明書 09-input）。n の並びはパッドしだいなので、PlayStation のパッド（DUALSHOCK 4 など）の
-- よくある並びを使う：0 □、1 ×、2 ○、3 △、4 L1、5 R1、6 L2、7 R2、8 SHARE、9 OPTIONS、10 L3、11 R3。
-- 十字キーは DirectInput ではボタンではなく POV（0.1.68〜 platform が読む。下の DINPUT_POV）。
shortcut.DINPUT_ORDER = { [0] = 'square', 'cross', 'circle', 'triangle', 'l1', 'r1', 'l2', 'r2', 'share', 'options', 'l3', 'r3' }
shortcut.DINPUT_BUTTON0 = 48
-- 十字キー（POV）の dinput_button の button：DIJOYSTATE の rgdwPOV[0] の位置 32。state は角度×100（0 上、9000 右、18000 下、27000 左）、
-- 真ん中は 0xFFFFFFFF（-1・65535 のことも）
shortcut.DINPUT_POV = 32
function shortcut.key_of_dinput(offset)
    offset = tonumber(offset)
    if not offset then return nil end
    return shortcut.DINPUT_ORDER[offset - shortcut.DINPUT_BUTTON0]
end
function shortcut.dinput_down(st)
    return math.floor(tonumber(st) or 0) >= 0x80
end

-- その名前のボタンが組み合わせに入っているか（2つ以上の組み合わせのときだけ true）
function shortcut.in_combo(combo, key)
    combo = shortcut.normalize(combo)
    if #combo < 2 or key == nil then return false end
    for _, k in ipairs(combo) do if k == key then return true end end
    return false
end

-- 押しているボタンの集合（key → true）
function shortcut.held_from_state(buttons, lt, rt)
    local held = {}
    buttons = math.floor(tonumber(buttons) or 0)
    for _, b in ipairs(shortcut.BUTTONS) do
        if b.bit then
            if math.floor(buttons / b.bit) % 2 == 1 then held[b.key] = true end
        elseif b.trigger == 'left' then
            if (tonumber(lt) or 0) > shortcut.TRIGGER_THRESHOLD then held[b.key] = true end
        elseif b.trigger == 'right' then
            if (tonumber(rt) or 0) > shortcut.TRIGGER_THRESHOLD then held[b.key] = true end
        end
    end
    return held
end

-- 名前の並びを決まった順にそろえる（知らない名前・重なりは外す）
function shortcut.normalize(list)
    local out, seen = {}, {}
    if type(list) ~= 'table' then return out end
    for _, k in ipairs(list) do
        if type(k) == 'string' and shortcut.BY_KEY[k] and not seen[k] then
            seen[k] = true
            out[#out + 1] = k
        end
    end
    table.sort(out, function (a, b) return shortcut.ORDER[a] < shortcut.ORDER[b] end)
    return out
end

function shortcut.from_set(set)
    local list = {}
    for k, on in pairs(set or {}) do if on then list[#list + 1] = k end end
    return shortcut.normalize(list)
end

-- 「R1＋△」。空なら nil
function shortcut.label(list)
    list = shortcut.normalize(list)
    if #list == 0 then return nil end
    local parts = {}
    for _, k in ipairs(list) do parts[#parts + 1] = shortcut.BY_KEY[k].label end
    return table.concat(parts, '＋')
end

function shortcut.same(a, b)
    a, b = shortcut.normalize(a), shortcut.normalize(b)
    if #a ~= #b then return false end
    for i = 1, #a do if a[i] ~= b[i] then return false end end
    return true
end

---------------------------------------------------------------------------
-- 判定（押している集合を毎回渡す）
---------------------------------------------------------------------------

local Det = {}
Det.__index = Det

function shortcut.new()
    return setmetatable({
        was_full = false,    -- 前回、組み合わせを全部押していた
        fires = 0,           -- 発動した回数（組み合わせの途中で押したボタンの画面操作を取り消すのに使う）
        latched = {},        -- 発動のあと、ゲームに渡さないボタン（離すまで）
        capture = nil,       -- ボタン待ち：{ phase = 'release'|'collect', got = {} }
    }, Det)
end

-- ボタン待ちを始める。押したままのボタン（決定に使った × など）は、一度全部離すまで数えない
function Det:start_capture()
    self.capture = { phase = 'release', got = {} }
    self.was_full = true   -- 待ちのあいだ・直後は発動させない
end

function Det:cancel_capture()
    self.capture = nil
end

function Det:capturing() return self.capture ~= nil end

-- 待っているあいだに集めたボタン
function Det:captured_so_far()
    if not self.capture then return {} end
    return shortcut.from_set(self.capture.got)
end

--[[
  held: 押しているボタンの集合。combo: 設定の組み合わせ。
  戻り値: { fire = true } 発動 / { captured = list } ボタン待ちで決まった / {}
  block: ゲームに渡さないボタンの集合（pass_to_game=false の発動後と、ボタン待ちのあいだ）
]]
function Det:update(held, combo, pass_to_game)
    held = held or {}
    local out = {}
    local any = next(held) ~= nil
    -- 離したボタンは止めるのをやめる
    for k in pairs(self.latched) do
        if not held[k] then self.latched[k] = nil end
    end
    local cap = self.capture
    if cap then
        if cap.phase == 'release' then
            if not any then cap.phase = 'collect' end
        else
            for k in pairs(held) do cap.got[k] = true end
            if not any and next(cap.got) ~= nil then
                out.captured = shortcut.from_set(cap.got)
                self.capture = nil
            end
        end
        -- 待っているあいだは全部止める（キャラが動かないように）
        for k in pairs(held) do self.latched[k] = true end
        -- 決まったときは全部離している。次にそろえたら発動する
        self.was_full = (self.capture ~= nil)
        out.block = self.latched
        return out
    end
    combo = shortcut.normalize(combo)
    local full = #combo > 0
    for _, k in ipairs(combo) do if not held[k] then full = false end end
    if full and not self.was_full then
        out.fire = true
        self.fires = self.fires + 1
        if not pass_to_game then
            for _, k in ipairs(combo) do self.latched[k] = true end
        end
    end
    self.was_full = full
    out.block = self.latched
    return out
end

function Det:blocking(key)
    return key ~= nil and self.latched[key] == true
end

return shortcut
