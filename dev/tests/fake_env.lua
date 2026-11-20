-- ゲームなしで本体を動かすための偽の環境（Ashita 互換層と imgui の最小限）
local H = require('harness')
install_backslash_io()

FAKE = { events = {}, printed = {}, clicks = {}, drawn = {}, labels = {}, texts = {}, time = 0, table = false, double = false,
         player = { name = '', zone = 0, tidx = 0, status = 0 }, calls = {} }

local function vec2(x, y) return function () return x, y end end
local dl = setmetatable({
    AddText = function (_, pos, col, text)
        if type(text) == 'string' then FAKE.texts[#FAKE.texts + 1] = text end
    end,
}, { __index = function () return function () end end })
local imgui = {
    GetTime = function () return FAKE.time end,
    GetIO = function () return { DisplaySize = { x = 1920, y = 1080 } } end,
    Begin = function (title, open, flags)
        FAKE.drawn[#FAKE.drawn + 1] = title
        -- 実機は open が nil だと flags を無視して見出しの帯を出す（0.1.63 の「▼ トラッカー（3）」）
        check(type(open) == 'table', 'Begin open must be a table (nil drops the flags): ' .. tostring(title))
        FAKE.begin_flags = FAKE.begin_flags or {}
        FAKE.begin_flags[title] = flags
        return true
    end,
    BeginChild = function (id, size, border, flags)
        FAKE.child = id or '_child'
        FAKE.scroll_y = FAKE.scroll_y or {}
        if FAKE.scroll_y[FAKE.child] == nil then FAKE.scroll_y[FAKE.child] = 0 end
        FAKE.child_calls = FAKE.child_calls or {}
        FAKE.child_calls[#FAKE.child_calls + 1] = { id = id, size = size, border = border, flags = flags }
        return true
    end,
    EndChild = function () FAKE.child = nil end,
    GetScrollY = function ()
        FAKE.scroll_y = FAKE.scroll_y or {}
        return FAKE.scroll_y[FAKE.child or '_win'] or 0
    end,
    SetScrollY = function (y)
        FAKE.scroll_y = FAKE.scroll_y or {}
        FAKE.scroll_y[FAKE.child or '_win'] = tonumber(y) or 0
    end,
    SetScrollHereY = function () end,
    GetWindowPos = vec2(100, 100), GetWindowSize = vec2(400, 300),
    GetContentRegionAvail = vec2(380, 260), GetMousePos = vec2(-100, -100),
    GetCursorScreenPos = vec2(10, 10), GetItemRectMin = vec2(0, 0), GetItemRectMax = vec2(10, 10),
    GetFontSize = function () return 16 end,
    -- 幅は文字単位（UTF-8。ASCII は半分）。バイト数だと日本語が広すぎて、折り返しのテストが切れる
    CalcTextSize = function (text, _end, hide, wrap_w)
        text = tostring(text or '')
        local w, i, n = 0, 1, #text
        while i <= n do
            local b = text:byte(i)
            if not b then break end
            local step = (b < 128 and 1) or (b < 224 and 2) or (b < 240 and 3) or 4
            w = w + ((b < 128) and 8 or 16)
            i = i + step
        end
        if w < 1 and text ~= '' then w = 8 end
        local h = 16
        wrap_w = tonumber(wrap_w)
        if wrap_w and wrap_w > 0 and w > wrap_w then
            h = 16 * math.ceil(w / wrap_w)
            w = wrap_w
        end
        return { x = w, y = h }
    end,
    GetFrameHeightWithSpacing = function () return 24 end,
    GetWindowDrawList = function () return dl end,
    InputTextWithHint = function (label, hint, buf, size)
        check(type(buf) == 'table' and type(buf[1]) == 'string', 'input buffer'); return false end,
    IsMouseClicked = function () return FAKE.mouse_clicked or false end,
    IsWindowHovered = function () return false end,
    IsItemHovered = function () return false end,
    IsItemClicked = function () return false end,
    IsItemActive = function () return false end,
    IsMouseDoubleClicked = function () return FAKE.double end,
    BeginTable = function (id, cols, flags)
        if FAKE.table_error then error('fake table error') end
        FAKE.calls.BeginTable = (FAKE.calls.BeginTable or 0) + 1
        FAKE.tables = FAKE.tables or {}
        FAKE.tables[#FAKE.tables + 1] = { id = id, cols = cols, flags = flags }
        return FAKE.table
    end,
    TableSetupScrollFreeze = function (cols, rows)
        FAKE.calls.TableSetupScrollFreeze = (FAKE.calls.TableSetupScrollFreeze or 0) + 1
        FAKE.scroll_freeze = { cols = cols, rows = rows }
    end,
    ImGuiListClipper = function ()
        return {
            DisplayStart = 0, DisplayEnd = 0, _n = 0, _stepped = false,
            Begin = function (self, n) self._n = tonumber(n) or 0; self._stepped = false end,
            Step = function (self)
                if self._stepped then return false end
                self.DisplayStart, self.DisplayEnd, self._stepped = 0, self._n, true
                return true
            end,
            End = function () end,
        }
    end,
}
local function clickable(label)
    FAKE.labels[#FAKE.labels + 1] = label
    for pat, _ in pairs(FAKE.clicks) do
        if type(label) == 'string' and label:find(pat, 1, true) then FAKE.clicks[pat] = nil; return true end
    end
    return false
end
imgui.Button = function (label) return clickable(label) end
imgui.SmallButton = function (label) return clickable(label) end
imgui.InvisibleButton = function (label) return clickable(label) end
imgui.Selectable = function (label) return clickable(label) end
imgui.BeginCombo = function (label, preview)
    FAKE.labels[#FAKE.labels + 1] = label
    if type(preview) == 'string' then FAKE.texts[#FAKE.texts + 1] = preview end
    FAKE.calls.BeginCombo = (FAKE.calls.BeginCombo or 0) + 1
    return true
end
imgui.EndCombo = function () end
FAKE.popups = {}
imgui.OpenPopup = function (id) FAKE.popups[id] = true end
imgui.BeginPopup = function (id) return FAKE.popups[id] == true end
imgui.EndPopup = function () end
imgui.CloseCurrentPopup = function () FAKE.popups = {} end
-- タブ：最初のタブか、SetSelected（2）で選ばれたタブだけ中身を出す
imgui.BeginTabBar = function (id, flags) FAKE.tab_first = true; FAKE.calls.BeginTabBar = (FAKE.calls.BeginTabBar or 0) + 1; return true end
imgui.EndTabBar = function () end
imgui.BeginTabItem = function (label, p_open, flags)
    FAKE.labels[#FAKE.labels + 1] = label
    if flags and flags ~= 0 then FAKE.tab_selected = label end
    if not FAKE.tab_selected then FAKE.tab_selected = label end
    return FAKE.tab_selected == label
end
imgui.EndTabItem = function () end
imgui.SetClipboardText = function (s) FAKE.clipboard = s end
setmetatable(imgui, { __index = function (_, k)
    return function (...)
        FAKE.calls[k] = (FAKE.calls[k] or 0) + 1
        for i = 1, select('#', ...) do
            local a = select(i, ...)
            check(type(a) ~= 'function', 'no function args to ' .. k)
            if type(a) == 'string' and (k:find('^Text') or k == 'TableSetupColumn') then FAKE.texts[#FAKE.texts + 1] = a end
        end
        return nil
    end
end })
package.loaded['imgui'] = imgui
package.loaded['ffi'] = nil

ashita = {
    events = { register = function (name, alias, fn) FAKE.events[name] = fn end },
    fs = {
        exists = function (p) local f = io.open(p, 'rb'); if f then f:close(); return true end
                 local r = os.execute('test -d "' .. H.fix(p) .. '"'); return r == 0 or r == true end,
        create_directory = function (p) os.execute('mkdir -p "' .. H.fix(p) .. '"'); return true end,
        get_directory = function (p, filter)
            local out = {}
            local h = io.popen('ls -1 "' .. H.fix(p) .. '" 2>/dev/null')
            for line in h:lines() do if line:match('%.json$') then out[#out + 1] = line end end
            h:close(); return out end,
    },
}
AshitaCore = {
    GetInstallPath = function () return TMP .. '/Vanacore\\' end,
    GetMemoryManager = function ()
        return {
            GetParty = function () return {
                GetMemberName = function (_, i) return FAKE.player.name end,
                GetMemberZone = function (_, i) return FAKE.player.zone end,
                GetMemberTargetIndex = function (_, i) return FAKE.player.tidx end,
            } end,
            -- ジョブ・レベル・所属国・ランク（0.1.65〜）。FAKE.pstat が無ければログイン前と同じ 0
            GetPlayer = function () local ps = FAKE.pstat or {}; return {
                GetMainJob = function () return ps.job or 0 end,
                GetMainJobLevel = function () return ps.level or 0 end,
                GetSubJob = function () return 0 end, GetSubJobLevel = function () return 0 end,
                GetNation = function () return ps.nation or 0 end,
                GetRank = function () return ps.rank or 0 end,
                GetRankPoints = function () return 0 end,
            } end,
            GetEntity = function () return {
                GetStatus = function (_, i) return FAKE.player.status end,
                GetLocalPositionX = function (_, i) return FAKE.player.x end,
                GetLocalPositionY = function (_, i) return FAKE.player.y end,
                GetLocalPositionZ = function (_, i) return FAKE.player.z end,
            } end,
        }
    end,
}
_G.print = function (s) FAKE.printed[#FAKE.printed + 1] = tostring(s) end
addon = { path = ROOT .. '/' }

-- 1.1.285〜：本番の初期見た目はアストラル。既存テストの多くはクラシック前提なので、
-- 明示しない限りクラシックにする。初期値そのものを見るテストは先に FAKE.keep_default_look = true。
local function apply_test_look()
    if FAKE._look_applied or FAKE.keep_default_look == true then return end
    local app = package.loaded['src.app']
    if not (app and app.state and app.state.ready and app._settings) then return end
    local S = app._settings()
    if not S then return end
    S.look = 'classic'
    local th = package.loaded['src.ui.theme']
    if th and th.set_look then th.set_look('classic') end
    FAKE._look_applied = true
end

function frame(dt)
    FAKE.time = FAKE.time + (dt or 0.016)
    FAKE.drawn = {}; FAKE.labels = {}; FAKE.texts = {}; FAKE.child_calls = {}
    apply_test_look()
    FAKE.events.d3d_present()
end
function frames(seconds) local n = math.floor(seconds / 0.1) for _ = 1, n do frame(0.1) end end
function cmd(text) local e = { command = text, blocked = false }; FAKE.events.command(e); return e.blocked end
function key(k, down) local e = { key = k, down = down, blocked = false }; FAKE.events.key_data(e); return e.blocked end
function press(k) local b = key(k, true); key(k, false); return b end
function pad(b, st) local e = { button = b, state = st, blocked = false }; FAKE.events.xinput_button(e); return e.blocked end
function drawn(pat) for _, t in ipairs(FAKE.drawn) do if t:find(pat, 1, true) then return true end end return false end
function texted(pat)
    for _, t in ipairs(FAKE.texts) do if t:find(pat, 1, true) then return true end end
    -- 折り返しや改行で分かれていても、続きとして探す（0.1.197〜。CalcTextSize で自前折り返しするため）
    local all = table.concat(FAKE.texts, '')
    if all:find(pat, 1, true) then return true end
    if table.concat(FAKE.texts, '\n'):find(pat, 1, true) then return true end
    return false
end
function labeled(pat) for _, t in ipairs(FAKE.labels) do if t:find(pat, 1, true) then return true end end return false end
function printed(pat) for _, t in ipairs(FAKE.printed) do if t:find(pat, 1, true) then return true end end return false end
