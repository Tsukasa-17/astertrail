--[[
  Astertrail - 日本語入力（0.1.309〜。0.1.314〜 汎用プラグイン japanese_ime の決まりで話す）
  プラグイン japanese_ime が受け取った日本語入力の文字を、Astertrail の入力欄に入れる。
  - Astertrail の入力欄が選ばれている間だけ、プラグインに取得オンを頼む（plugin_event 'japanese_ime_ctl' "on astertrail"／"off astertrail"）。
    プラグインが読み込まれていなければ何もしない（チャットにも出さない）。
  - 確定した文字（'japanese_ime_text' "astertrail\t文字"）は、ImGui の入力に足す（io:AddInputCharactersUTF8。カーソルの位置に入る）。
    それが無い環境では欄の文字の後ろに足し、ImGui が持っている文字に戻されないよう 1 フレームだけ別の ID で描く。
  - 変換中の文字（'japanese_ime_comp' "astertrail\t文字"、空なら終わり）は、欄の文字のすぐ後ろに薄く下線付きで出す。
  - ほかのアドオンあて（ID が astertrail でない）の文字は使わない。
]]

local M = {}

M.ID        = 'astertrail'      -- japanese_ime に名乗るアドオンの ID（0.1.314〜）
M.EV_RESULT = 'japanese_ime_text'
M.EV_COMP   = 'japanese_ime_comp'
M.EV_CTL    = 'japanese_ime_ctl'
M.EV_STATE  = 'japanese_ime_state'
M.PLUGIN    = 'japaneseime'     -- 名前を小文字にして _ と空白を除いたもの
M.RECHECK   = 2                 -- 選んでいる間、プラグインが読み込まれたかを見直す間隔（秒）
M.ANSWER_WAIT = 1               -- on の知らせに返事が無いとき、コマンドに切りかえるまで（秒）
M.AFTER_COMP = 0.4              -- 変換が終わってからも変換中として扱う間（確定の Enter を止める。秒）
M.CMD_ON    = '/jime addon on astertrail'   -- プラグインの黙った切りかえ（チャットに何も出ない。0.1.310〜）
M.CMD_OFF   = '/jime addon off astertrail'

local st

function M.reset()
    st = {
        pending = {},      -- 届いた確定の文字（次に欄を描くときに入れる）
        comp = '',         -- 変換中の文字
        active_id = nil,   -- 前のフレームで選ばれていた欄
        seen = nil,        -- このフレームで選ばれている欄
        on = false,        -- プラグインに取得オンを頼んでいるか
        loaded = nil,      -- プラグインが読み込まれているか（nil は未確認）
        checked_at = nil,
        plugin_on = nil,   -- プラグインの返事（'astertrail_ime_state'）
        reid = nil, reid_next = nil,
        on_at = nil,       -- on を頼んだ時刻
        via_cmd = false,   -- 返事が無いので、黙ったコマンド（/atime addon on）でも頼んだ
        logged_loaded = nil,
        comp_end_at = nil, -- 変換が終わった（確定・取り消し）時刻
        last_text = {},    -- 欄の ID → 選ばれていた間の最後の文字（Esc で戻されたら、これに戻す。0.1.312〜）
        fed = 0, appended = 0,
    }
end
M.reset()
function M.state() return st end

-- UTF-8 の途中で切らずに max バイトまで
local function clip_utf8(s, max)
    if #s <= max then return s end
    local cut = max
    while cut > 0 do
        local b = s:byte(cut + 1)
        if not b or b < 0x80 or b >= 0xC0 then break end
        cut = cut - 1
    end
    return s:sub(1, cut)
end
M._clip_utf8 = clip_utf8

-- プラグインからの知らせ（platform の plugin_event から）
function M.on_event(name, data)
    data = type(data) == 'string' and data or ''
    if name == M.EV_RESULT or name == M.EV_COMP then
        -- "<アドオンID>\t<文字>"：自分あてだけ使う
        local owner, text = data:match('^([^\t]*)\t(.*)$')
        if owner ~= M.ID then return true end
        data = text
    end
    if name == M.EV_RESULT then
        if st.active_id and data ~= '' then st.pending[#st.pending + 1] = data end
        st.comp_end_at = M.now()
        return true
    elseif name == M.EV_COMP then
        if st.comp ~= '' and data == '' then st.comp_end_at = M.now() end
        st.comp = st.active_id and data or ''
        return true
    elseif name == M.EV_STATE then
        st.plugin_on = (data == 'on ' .. M.ID)
        return true
    end
    return false
end

function M.now()
    local P = st.P
    if P and P.time then
        local ok, t = pcall(P.time)
        if ok and tonumber(t) then return tonumber(t) end
    end
    return nil
end

-- 日本語の変換中か、終わった直後か（キーをゲームにも Astertrail の操作にも渡さない）
function M.composing(now)
    if not st.on then return false end
    if st.comp ~= '' then return true end
    now = tonumber(now) or M.now()
    if st.comp_end_at and now and now >= st.comp_end_at and now - st.comp_end_at < M.AFTER_COMP then return true end
    return false
end

-- 欄を描くときのラベル（足した文字を ImGui に読み直させるフレームだけ別の ID）
function M.label(id)
    if st.reid == id then return id .. '_ime' end
    return id
end

-- ImGui の入力として渡す（選ばれている欄のカーソルの位置に入る）。できなければ false
function M.feed(imgui, text)
    if not imgui or type(imgui.GetIO) ~= 'function' then return false end
    local ok, io = pcall(imgui.GetIO)
    if not ok or io == nil then return false end
    local okf, fn = pcall(function () return io.AddInputCharactersUTF8 end)
    if not okf or type(fn) ~= 'function' then return false end
    return (pcall(fn, io, text))
end

local function draw_comp(ui, imgui, buf, text)
    local okr, x1, y1 = pcall(imgui.GetItemRectMin)
    local okr2, x2, y2 = pcall(imgui.GetItemRectMax)
    if not okr or not okr2 or type(x1) ~= 'number' or type(x2) ~= 'number' then return end
    local function width(s)
        local ok, w = pcall(imgui.CalcTextSize, s)
        if not ok then return 0 end
        if type(w) == 'table' then return tonumber(w.x or w[1]) or 0 end
        return tonumber(w) or 0
    end
    local fs = 16
    local okf, f = pcall(imgui.GetFontSize)
    if okf and tonumber(f) then fs = tonumber(f) end
    local pad_y = math.max(0, ((y2 - y1) - fs) / 2)
    local pad_x = pad_y > 0 and math.min(pad_y, 8) or 4
    local cw = width(text)
    local x = x1 + pad_x + width(buf[1] or '')
    if x + cw > x2 - pad_x then x = math.max(x1 + pad_x, x2 - pad_x - cw) end
    local y = y1 + pad_y
    local dl
    for _, fname in ipairs({ 'GetForegroundDrawList', 'GetWindowDrawList' }) do
        if type(imgui[fname]) == 'function' then
            local ok, v = pcall(imgui[fname])
            if ok and (type(v) == 'table' or type(v) == 'userdata') then dl = v; break end
        end
    end
    if not dl then return end
    local theme = require('src.ui.theme')
    local okb, bg = pcall(theme.u32, 'bg', 0.92)
    local okt, fg = pcall(theme.u32, 'text', 0.6)
    bg = okb and bg or 0xEB1E1E1E
    fg = okt and fg or 0x99FFFFFF
    pcall(function ()
        dl:AddRectFilled({ x - 2, y1 + 2 }, { x + cw + 2, y2 - 2 }, bg, 2)
        dl:AddText({ x, y }, fg, text)
        dl:AddLine({ x, y + fs }, { x + cw, y + fs }, fg, 1)
    end)
    st.comp_drawn = text
end

-- 入力欄（InputText*）のすぐ後に呼ぶ。id は欄の ID（ラベル）、buf は { 文字 }、size は InputText に渡した大きさ。
-- 欄の文字を変えたら true（呼んだ側は、打ったときと同じに扱う）
function M.field(ui, imgui, id, buf, size)
    if not imgui or type(buf) ~= 'table' then return false end
    local ok, a = pcall(imgui.IsItemActive)
    if not ok or a ~= true then
        -- 0.1.312〜：欄を抜けたとき。ImGui は Esc で選ぶ前の文字に戻すので、抜ける直前の文字に戻す（Esc＝今の文字で確定して抜ける）
        local last = st.last_text[id]
        if last ~= nil and st.reid ~= id then
            st.last_text[id] = nil
            if buf[1] ~= last then
                buf[1] = last
                return true
            end
        end
        return false
    end
    st.seen = id
    local changed = false
    if st.active_id ~= id then
        st.last_text[id] = buf[1] or ''
        return false
    end
    if #st.pending > 0 then
        local text = table.concat(st.pending)
        st.pending = {}
        if M.feed(imgui, text) then
            st.fed = st.fed + 1
        else
            local nb = clip_utf8((buf[1] or '') .. text, (tonumber(size) or 64) - 1)
            if nb ~= buf[1] then buf[1] = nb; changed = true end
            st.last_text[id] = nb
            st.appended = st.appended + 1
            st.reid_next = id
        end
    end
    if st.comp ~= '' then draw_comp(ui, imgui, buf, st.comp) end
    if not st.reid_next then st.last_text[id] = buf[1] or '' end
    return changed
end

-- 窓をすべて描いたあとに 1 回。P は platform（plugin_loaded・plugin_raise）、now は秒
-- paused（0.1.313〜）：ゲームのチャット欄が開いている間は取得を頼まない（チャットの日本語入力をじゃましない）
function M.frame_end(P, now, paused)
    st.P = P
    st.active_id = st.seen
    st.seen = nil
    st.reid = st.reid_next
    st.reid_next = nil
    local want = st.active_id ~= nil and paused ~= true
    if not want then
        st.pending = {}
        st.comp = ''
        st.loaded = nil
        st.checked_at = nil
    elseif P and P.plugin_loaded then
        now = tonumber(now) or 0
        if st.loaded == nil or st.checked_at == nil or now - st.checked_at >= M.RECHECK or now < st.checked_at then
            st.checked_at = now
            local okl, r = pcall(P.plugin_loaded, M.PLUGIN)
            st.loaded = okl and r == true
        end
    end
    if want and st.loaded ~= st.logged_loaded then
        st.logged_loaded = st.loaded
        M.log(P, 'box active, plugin loaded=' .. tostring(st.loaded))
    elseif not want then
        st.logged_loaded = nil
    end
    local target = want and st.loaded == true
    now = tonumber(now) or 0
    if target ~= st.on then
        st.on = target
        if target then
            st.plugin_on = nil
            st.on_at = now
            st.via_cmd = false
            if P and P.plugin_raise then pcall(P.plugin_raise, M.EV_CTL, 'on ' .. M.ID) end
            M.log(P, 'capture on (event)')
        else
            if P and P.plugin_raise then pcall(P.plugin_raise, M.EV_CTL, 'off ' .. M.ID) end
            if st.via_cmd and P and P.chat_run then pcall(P.chat_run, M.CMD_OFF) end
            M.log(P, 'capture off' .. (st.via_cmd and ' (event + command)' or ' (event)'))
            st.via_cmd = false
            st.on_at = nil
            st.comp = ''
        end
    elseif target and not st.via_cmd and st.plugin_on ~= true and st.on_at and now - st.on_at >= M.ANSWER_WAIT then
        -- 知らせが届かない環境（古いプラグインなど）：黙ったコマンドで頼む
        st.via_cmd = true
        if P and P.chat_run then pcall(P.chat_run, M.CMD_ON) end
        M.log(P, 'no answer to the event, capture on (command)')
    end
end

-- VanaCore の記録だけに 1 行（チャットには出さない）
function M.log(P, text)
    if P and P.log_only then pcall(P.log_only, 'ime: ' .. tostring(text)) end
end

-- 閉じるとき（取得オンを頼んだままにしない）
function M.shutdown(P)
    if st.on and P and P.plugin_raise then pcall(P.plugin_raise, M.EV_CTL, 'off ' .. M.ID) end
    if st.on and st.via_cmd and P and P.chat_run then pcall(P.chat_run, M.CMD_OFF) end
    M.reset()
end

return M
