--[[
  Astertrail - platform: Ashita v4 窓口（VanaCore の Ashita 互換層で動かす前提）
  ゲームや Ashita の API を呼ぶのはこのファイルだけ（VanaCore の追加 API は vanacore_ext.lua だけ）。
  - 受信した情報を改変・遮断しない（packet は扱わない）。
  - 所持は VanaCore の読み取りだけを使う（Ashita の GetInventory は実機で確かめるまで ASHITA_INVENTORY で止めておく）。
  - キーとパッドは、アドオンの画面を操作している時だけ受け取り、その時だけゲームに渡さない。
]]

local platform = {
    name = 'ashita',
}

local app           -- 共通部分（start で受け取る）
local imgui_ok, imgui = pcall(require, 'imgui')
platform.imgui = imgui_ok and imgui or nil

local INV_PACKETS = { [0x01C] = true, [0x01D] = true, [0x01E] = true, [0x01F] = true, [0x020] = true, [0x055] = true }
local ext_ok, ext = pcall(require, 'src.platform.vanacore_ext')
if not ext_ok then ext = nil end

local ffi_ok, ffi = pcall(require, 'ffi')
if not ffi_ok then ffi = nil end

---------------------------------------------------------------------------
-- パス
---------------------------------------------------------------------------

local function with_sep(p)
    if not p or p == '' then return nil end
    if p:sub(-1) ~= '\\' and p:sub(-1) ~= '/' then p = p .. '\\' end
    return p
end

function platform.addon_dir()
    -- Ashita の addon.path は末尾に区切りがある。念のため付け直す
    return with_sep(addon and addon.path) or '.\\'
end

-- 設定の親フォルダ\astertrail\（VanaCore では GetInstallPath が VanaCore のフォルダ）
function platform.config_dir()
    local ok, install = pcall(function () return AshitaCore:GetInstallPath() end)
    if not ok or type(install) ~= 'string' or install == '' then return nil end
    return with_sep(install) .. 'config\\addons\\astertrail\\'
end

-- 作業用（更新の zip など）。設定フォルダには書かない
function platform.temp_dir()
    local t = os.getenv('TEMP') or os.getenv('TMP') or os.getenv('TMPDIR')
    if type(t) ~= 'string' or t == '' then return nil end
    return with_sep(t) .. 'astertrail_update\\'
end

---------------------------------------------------------------------------
-- ファイル（UTF-8 のまま読み書き。パスは ANSI 扱いなので英数字だけにする）
---------------------------------------------------------------------------

local fs = { sep = '\\' }
platform.fs = fs

function fs.read(path)
    local f, err = io.open(path, 'rb')
    if not f then return nil, err end
    local s = f:read('*a')
    f:close()
    return s
end

function fs.write(path, text)
    local f, err = io.open(path, 'wb')
    if not f then return nil, err end
    local ok, werr = f:write(text)
    f:close()
    if not ok then return nil, werr end
    return true
end

function fs.exists(path)
    if ashita and ashita.fs and ashita.fs.exists then
        local ok, r = pcall(ashita.fs.exists, path)
        if ok then return r == true end
    end
    local f = io.open(path, 'rb')
    if f then f:close(); return true end
    return false
end

function fs.remove(path)
    local ok, err = os.remove(path)
    if ok then return true end
    return nil, err
end

function fs.rename(a, b)
    local ok, err = os.rename(a, b)
    if ok then return true end
    return nil, err
end

function fs.mkdir(path)
    if fs.exists(path) then return true end
    if ashita and ashita.fs and ashita.fs.create_directory then
        local ok, r = pcall(ashita.fs.create_directory, path)
        if ok and r ~= false then return true end
    end
    -- 公式 vana.fs.create_dir は親も作る
    if ext and ext.create_dir then
        local ok, r = pcall(ext.create_dir, path)
        if ok and r ~= false then return true end
    end
    return fs.exists(path)
end

function fs.mkdir_p(path)
    if not path or path == '' then return nil end
    local bs = string.char(92)
    path = path:gsub('[' .. bs .. '/]+$', '')
    if fs.exists(path) then return true end
    local acc, sep = '', bs
    if path:find('/', 1, true) and not path:find(bs, 1, true) and not path:match('^%a:') then sep = '/' end
    local i = 1
    if path:match('^%a:[' .. bs .. '/]') then
        acc = path:sub(1, 2)
        i = 3
    elseif path:sub(1, 1) == '/' or path:sub(1, 1) == bs then
        acc = path:sub(1, 1)
        i = 2
    end
    local rest = path:sub(i):gsub(bs, '/')
    for part in rest:gmatch('[^/]+') do
        if acc == '' or acc == '/' or acc:match('^%a:$') then
            acc = acc .. part
        else
            acc = acc .. sep .. part
        end
        if #acc > 0 then fs.mkdir(acc) end
    end
    return fs.exists(path) and true or fs.mkdir(path)
end

function fs.copy(src, dst)
    if not src or not dst then return nil, 'no path' end
    if src == dst then return true end
    local inf, err = io.open(src, 'rb')
    if not inf then return nil, err end
    local out, e2 = io.open(dst, 'wb')
    if not out then inf:close(); return nil, e2 end
    while true do
        local chunk = inf:read(1024 * 256)
        if not chunk then break end
        out:write(chunk)
    end
    inf:close(); out:close()
    return true
end

function fs.list(dir)
    if not (ashita and ashita.fs) then return {} end
    local getter = ashita.fs.get_directory or ashita.fs.get_dir
    if not getter then return {} end
    local ok, r = pcall(getter, dir, '.*\\.json')
    if ok and type(r) == 'table' then return r end
    return {}
end

---------------------------------------------------------------------------
-- 時間・出力
---------------------------------------------------------------------------

function platform.time()
    if imgui and imgui.GetTime then
        local ok, t = pcall(imgui.GetTime)
        if ok and type(t) == 'number' then return t end
    end
    return os.clock()
end

function platform.print(text)
    local s = '[Astertrail] ' .. tostring(text)
    -- ゲームのチャットは Shift-JIS。公式 vana.encoding.to_shift_jis を通す。
    if ext and ext.to_shift_jis then
        local ok, conv = pcall(ext.to_shift_jis, s)
        if ok and type(conv) == 'string' then s = conv end
    end
    print(s)
end

---------------------------------------------------------------------------
-- プレイヤー（読み取りだけ）
---------------------------------------------------------------------------

function platform.player()
    local out = { ready = false }
    local ok = pcall(function ()
        local mm = AshitaCore:GetMemoryManager()
        local party = mm:GetParty()
        local name = party:GetMemberName(0)
        local zone = party:GetMemberZone(0)
        out.name = (type(name) == 'string') and name or nil
        out.zone_id = tonumber(zone)
        out.ready = out.name ~= nil and out.name ~= '' and (out.zone_id or 0) > 0
        -- 戦闘中か（status 1 = 戦闘態勢）。読めなければ false
        local idx = party:GetMemberTargetIndex(0)
        local ent = mm:GetEntity()
        if idx and idx > 0 then
            local st = ent:GetStatus(idx)
            out.in_combat = (st == 1)
        end
        -- 地図の現在地用。Ashita の GetLocalPositionX / Y が水平面、Z は高さ。
        local function take(names, dest)
            if not ent or not idx or idx <= 0 then return end
            for _, n in ipairs(names) do
                if out[dest] == nil then
                    local fn = ent[n]
                    if type(fn) == 'function' then
                        local pok, v = pcall(fn, ent, idx)
                        if pok then
                            v = tonumber(v)
                            if v ~= nil then out[dest] = v end
                        end
                    end
                end
            end
        end
        take({ 'GetLocalPositionX', 'GetPositionX', 'GetX', 'GetLastX' }, 'x')
        take({ 'GetLocalPositionZ', 'GetPositionZ', 'GetZ', 'GetLastZ' }, 'z')
        take({ 'GetLocalPositionY', 'GetPositionY', 'GetY', 'GetLastY' }, 'y')
        -- 向き（0.1.171〜、地図の矢印）。公式 vana.game.entity の heading（ラジアン、0＝東）を先に
        if ext and ext.game_entity and idx and idx > 0 then
            local eok, e = pcall(ext.game_entity, idx)
            if eok and type(e) == 'table' and tonumber(e.heading) then out.heading = tonumber(e.heading) end
        end
        take({ 'GetLocalPositionYaw', 'GetHeading' }, 'heading')
        out.index = idx
    end)
    if not ok then out.ready = false end
    return out
end

-- ジョブ・レベル・所属国・ランク（0.1.65〜、読むだけ）。VanaCore の公式 API を先に、無ければ Ashita の GetPlayer。
-- ログイン前など、まだ届いていないとき（メインジョブのレベルが 0）は nil を返す（＝わからない）
-- ゲームの文字（Shift-JIS）を UTF-8 に（0.1.66〜）。変換できない環境では nil
function platform.text_from_game(raw)
    if not ext or not ext.from_shift_jis then return nil end
    -- 色・自動翻訳などの制御（1E/1F/7F と次の1文字）は先に取る（2バイト目にはならない値）
    local s = tostring(raw or ''):gsub('[\30\31\127].', '')
    local ok, out = pcall(ext.from_shift_jis, s)
    if ok and type(out) == 'string' then return out end
    return nil
end

function platform.player_status()
    local st
    if ext and ext.player_status then
        local ok, r = pcall(ext.player_status)
        if ok and type(r) == 'table' then st = r end
    end
    if not st then
        local ok = pcall(function ()
            local pl = AshitaCore:GetMemoryManager():GetPlayer()
            local function call(n)
                local fn = pl[n]
                if type(fn) ~= 'function' then return nil end
                local pok, v = pcall(fn, pl)
                return pok and tonumber(v) or nil
            end
            st = {
                main_job = call('GetMainJob'), main_job_level = call('GetMainJobLevel'),
                sub_job = call('GetSubJob'), sub_job_level = call('GetSubJobLevel'),
                nation = call('GetNation'), rank = call('GetRank'), rank_points = call('GetRankPoints'),
                source = 'GetPlayer',
            }
        end)
        if not ok then st = nil end
    end
    if not st or not st.main_job_level or st.main_job_level <= 0 or not st.main_job or st.main_job <= 0 then
        return nil
    end
    if st.nation and (st.nation < 0 or st.nation > 2) then st.nation = nil end
    if st.rank and (st.rank < 1 or st.rank > 10) then st.rank = nil end
    return st
end

---------------------------------------------------------------------------
-- 使える機能
---------------------------------------------------------------------------


-- プレイヤーのエンティティ状態（0 待機、1 戦闘、4 イベント）。読めなければ nil
function platform.self_status()
    if ext and ext.self_status then
        local ok, s = pcall(ext.self_status)
        if ok and type(s) == 'number' then return s end
    end
    local st
    local ok = pcall(function ()
        local mm = AshitaCore:GetMemoryManager()
        local party = mm:GetParty()
        local idx = party:GetMemberTargetIndex(0)
        local ent = mm:GetEntity()
        if idx and idx > 0 and ent then
            st = tonumber(ent:GetStatus(idx))
        end
    end)
    if ok then return st end
    return nil
end

function platform.capabilities()
    local pad_note = 'XInput（xinput_state・xinput_button）と DirectInput（dinput_button）。実機で要検証'
    if ext and ext.gamepad_note then
        local ok, n = pcall(ext.gamepad_note)
        if ok and n then pad_note = pad_note .. ' / ' .. n end
    end
    local pok, pnote = platform.project_status and platform.project_status()
    return {
        inventory = platform.can_read_possession(),
        inventory_note = platform.possession_note(),
        gamepad = true,
        gamepad_note = pad_note,
        pad_source = platform.pad_source and platform.pad_source() or nil,   -- ショートカットの読み取り元（nil=まだ届いていない）
        map_image = true,
        map_image_note = 'クライアントの地図DATを実行時に読む。読めなければマス目に戻る',
        marks = true,
        marks_project = pok,
        marks_note = pnote,
    }
end

-- 所持数（古い窓口）：使わない。所持は platform.possession() で読む（0.1.184〜）
function platform.inventory_count(item_id)
    return nil
end

--[[
  所持（0.1.184〜、t297）。読むだけ（品を動かす・売る・渡す通信は送らない）。
  - VanaCore：vana.game.container・vana.game.key_items（vanacore_ext。実機で読めることを確かめた）
  - Ashita v4：GetInventory():GetContainerCountMax / GetContainerItem、GetPlayer():HasKeyItem。
    実機で未確認なので ASHITA_INVENTORY が true のときだけ使う（初めは false）。
]]
platform.ASHITA_INVENTORY = false
platform.POSSESSION_CIDS = { 0, 1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 }   -- 3 テンポラリ・17 は読まない

local function ashita_inventory()
    local ok, inv = pcall(function () return AshitaCore:GetMemoryManager():GetInventory() end)
    if ok and inv and type(inv.GetContainerItem) == 'function' and type(inv.GetContainerCountMax) == 'function' then
        return inv
    end
    return nil
end

function platform.possession_source()
    if ext and ext.can_read_containers and ext.can_read_containers() then return 'vanacore' end
    if platform.ASHITA_INVENTORY and ashita_inventory() then return 'ashita' end
    return nil
end

function platform.can_read_possession() return platform.possession_source() ~= nil end

function platform.possession_note()
    local src = platform.possession_source()
    if src == 'vanacore' then return 'vana.game.container・vana.game.key_items で読む（読むだけ）' end
    if src == 'ashita' then return 'Ashita の GetInventory で読む（実機で未確認）' end
    return '所持の読み取りなし（Ashita の読み取りは実機で未確認のため使わない）'
end

local function ashita_read()
    local inv = ashita_inventory()
    if not inv then return nil end
    local out = {}
    for _, cid in ipairs(platform.POSSESSION_CIDS) do
        local okm, max = pcall(inv.GetContainerCountMax, inv, cid)
        max = okm and tonumber(max) or 0
        if max <= 0 then
            out[cid] = false
        else
            local items = {}
            for slot = 0, max do   -- 番号 0 の欄（ギル・空き）は id 65535 なので数えない
                local oki, it = pcall(inv.GetContainerItem, inv, cid, slot)
                if oki and it then
                    local id, n = tonumber(it.Id), tonumber(it.Count)
                    if id and id > 0 and id ~= 65535 and n and n > 0 then items[id] = (items[id] or 0) + n end
                end
            end
            out[cid] = items
        end
    end
    local key
    local okp, pl = pcall(function () return AshitaCore:GetMemoryManager():GetPlayer() end)
    if okp and pl and type(pl.HasKeyItem) == 'function' then
        key = function (id)
            local okk, r = pcall(pl.HasKeyItem, pl, id)
            if not okk or r == nil then return nil end
            return r == true or r == 1
        end
    end
    return { containers = out, key = key, source = 'ashita' }
end

-- 今の所持をまとめて読む（入れ物 16 個で 1 ミリ秒もかからない）。読めない環境は nil
function platform.possession()
    local src = platform.possession_source()
    if src == 'vanacore' then
        local cs = ext.read_containers(platform.POSSESSION_CIDS)
        if not cs then return nil end
        return { containers = cs, key = ext.key_items and ext.key_items() or nil, source = 'vanacore' }
    elseif src == 'ashita' then
        return ashita_read()
    end
    return nil
end

-- 地図 DAT のパス。file_id から実行時に解決する（差し替え済みのファイルも追う）。
-- 機械固有のパスは資料に書かない。API 名が環境で違うことがあるので、いくつか試す。
function platform.get_file_path(file_id)
    file_id = tonumber(file_id)
    if not file_id then return nil, 'no_id' end
    local ok, rm = pcall(function ()
        return AshitaCore and AshitaCore.GetResourceManager and AshitaCore:GetResourceManager()
    end)
    if ok and rm then
        for _, n in ipairs({ 'GetFilePath', 'GetFilePathById', 'GetFilePathFromId' }) do
            local fn = rm[n]
            if type(fn) == 'function' then
                local pok, path = pcall(fn, rm, file_id)
                if pok and type(path) == 'string' and path ~= '' then return path end
            end
        end
    end
    return nil, 'no_path'
end

-- 地図画像のテクスチャ（RGBA → 描画用）。失敗したら nil で、画面は方眼に戻る。
local tex_warned
function platform.load_texture(img)
    if not img or type(img.rgba) ~= 'string' or #img.rgba < 4 then
        return nil, 'no_pixels'
    end
    local w, h = tonumber(img.width), tonumber(img.height)
    if not w or not h or w < 1 or h < 1 then return nil, 'bad_size' end
    if #img.rgba < w * h * 4 then return nil, 'short_pixels' end

    -- imgui に直接渡せる場合
    if imgui then
        for _, n in ipairs({ 'CreateTextureFromRGBA', 'CreateTexture', 'LoadTextureFromMemory' }) do
            local fn = imgui[n]
            if type(fn) == 'function' then
                local ok, tex = pcall(fn, w, h, img.rgba)
                if ok and tex then return tex end
            end
        end
    end

    if not ffi then return nil, 'no_ffi' end

    -- Ashita の d3d8（あれば）
    local dev, d3d8
    local okd, mod = pcall(require, 'd3d8')
    if okd and mod then
        d3d8 = mod
        local ok, d = pcall(function () return mod.get_device and mod.get_device() end)
        if ok and d then dev = d end
    end
    -- VanaCore のデバイス
    if not dev and ext and ext.d3d_device then
        local ok, d = pcall(ext.d3d_device)
        if ok and d then dev = d end
    end
    if not dev then return nil, 'no_device' end

    local D3DFMT_A8R8G8B8 = 21
    local D3DPOOL_MANAGED = 1
    if d3d8 and d3d8.D3DFMT_A8R8G8B8 then D3DFMT_A8R8G8B8 = d3d8.D3DFMT_A8R8G8B8 end
    if ffi.C and ffi.C.D3DFMT_A8R8G8B8 then D3DFMT_A8R8G8B8 = ffi.C.D3DFMT_A8R8G8B8 end
    if ffi.C and ffi.C.D3DPOOL_MANAGED then D3DPOOL_MANAGED = ffi.C.D3DPOOL_MANAGED end

    local tex
    -- 戻り値が (hr, texture) の形と、texture だけの形の両方を試す
    local function try_create()
        local a, b = dev:CreateTexture(w, h, 1, 0, D3DFMT_A8R8G8B8, D3DPOOL_MANAGED)
        if type(a) == 'cdata' or type(a) == 'userdata' then return a end
        if type(b) == 'cdata' or type(b) == 'userdata' then return b end
        if a == 0 and b then return b end
        return b or a
    end
    local okc, got = pcall(try_create)
    if okc and got and got ~= 0 then tex = got end
    if not tex then return nil, 'create_failed' end

    -- 画素を書き込む（D3DFMT_A8R8G8B8 のメモリ順は B,G,R,A）
    local function copy_pixels(bits, pitch)
        local src = img.rgba
        for y = 0, h - 1 do
            local dst = ffi.cast('uint8_t*', bits) + y * pitch
            local so = y * w * 4
            for x = 0, w - 1 do
                local i = so + x * 4 + 1
                local r, g, b, a = src:byte(i, i + 3)
                local o = x * 4
                dst[o] = b; dst[o + 1] = g; dst[o + 2] = r; dst[o + 3] = a
            end
        end
    end
    local written = false
    pcall(function ()
        local hr, rect = tex:LockRect(0, nil, 0)
        local locked = rect
        if type(hr) == 'cdata' or (type(hr) == 'table' and hr.pBits) then locked = hr end
        if locked and locked.pBits then
            copy_pixels(locked.pBits, tonumber(locked.Pitch) or (w * 4))
            tex:UnlockRect(0)
            written = true
        end
    end)
    if not written then return nil, 'lock_failed' end

    if d3d8 and d3d8.gc_safe_release then
        local ok, wrapped = pcall(function ()
            return d3d8.gc_safe_release(ffi.cast('IDirect3DBaseTexture8*', tex))
        end)
        if ok and wrapped then tex = wrapped end
    end
    return tex
end

---------------------------------------------------------------------------
-- 入力（操作中だけ受け取る）
---------------------------------------------------------------------------

-- DirectInput のキー番号 → 動き
local DIK = {
    [0xC8] = 'up', [0xD0] = 'down', [0xCB] = 'left', [0xCD] = 'right',
    [0x1C] = 'confirm', [0x9C] = 'confirm', [0x01] = 'back', [0x0F] = 'tab',
}
local shift_down = false

-- XInput のボタン番号（Ashita の番号）→ 動き
-- アドオンが押下を止めたキー・ボタンだけ、離したのも止める。
-- ゲームが押下を受け取ったキー（ミッションを決定したEnterなど）の「離した」は必ずゲームへ渡す
-- （止めるとゲームは押しっぱなしと思い、次の決定が1回空振りする）。
local held_keys = {}   -- DIK → true（押下を止めた）
local held_pads = {}   -- 画面の操作で押下を止めたボタンの名前（'up' 'cross' など）→ true

local function on_key_data(e)
    if not app then return end
    local k = e.key
    if k == 0x2A or k == 0x36 then shift_down = e.down and true or false; return end
    local action = DIK[k]
    if not action then return end
    if action == 'tab' then action = shift_down and 'section_prev' or 'section_next' end
    if e.down then
        -- 前の「離した」を取りこぼしていても、ここで決め直す（止めっぱなしにしない）
        -- 操作中でなくとも、自分の窓に乗っている／選ばれているときの Esc は閉じる（0.1.282〜）
        local take = app.want_keys()
        if not take and action == 'back' and app.want_esc and app.want_esc() then take = true end
        if take and app.input(action, true, 'key') then
            held_keys[k] = true
            e.blocked = true
            return true
        else
            held_keys[k] = nil
        end
    else
        app.input(action, false, 'key')
        if held_keys[k] then
            held_keys[k] = nil
            e.blocked = true
            return true
        end
    end
end

-- 操作中は、ゲームが毎フレーム読む状態からも、押下を止めたキーを外す
local function on_key_state(e)
    if not app or not ffi or next(held_keys) == nil then return end
    local raw = e.data_raw or e.data
    if type(raw) ~= 'cdata' and type(raw) ~= 'userdata' and type(raw) ~= 'number' then return end
    pcall(function ()
        local p = ffi.cast('uint8_t*', raw)
        for k, _ in pairs(held_keys) do
            -- もう離されていれば覚えを消す（離したのを取りこぼしても止めっぱなしにしない）
            if p[k] == 0 then held_keys[k] = nil else p[k] = 0 end
        end
    end)
end

-- 開発用（テストから読む）
function platform._held_inputs()
    local n = 0
    for _ in pairs(held_keys) do n = n + 1 end
    for _ in pairs(held_pads) do n = n + 1 end
    return n
end

-- パッドのショートカット（0.1.57〜）
-- 読み取り：Ashita v4 の xinput_state（e.state が XINPUT_STATE。中身は Microsoft の XINPUT_GAMEPAD）。
-- xinput_state が読めない環境では、xinput_button（ボタン番号＝wButtons のビットの位置、16・17 はトリガー）から押している集合を作る。
-- XInput が一度も届かないとき（DirectInput のパッド）は、dinput_button（ボタンは 48＋n）から作る（0.1.59〜）。
-- 止め方は VanaCore の説明書 09-input のとおり：イベントで true を返す（Ashita の e.blocked も立てる）、
-- xinput_state は渡された XINPUT_STATE をその場で書き換える。
local shortcut = require('src.core.shortcut')
local XS_T = nil
if ffi then
    pcall(ffi.cdef, [[
        typedef struct {
            uint32_t dwPacketNumber;
            uint16_t wButtons;
            uint8_t  bLeftTrigger;
            uint8_t  bRightTrigger;
            int16_t  sThumbLX, sThumbLY, sThumbRX, sThumbRY;
        } astertrail_xinput_state_t;
    ]])
    local okt = pcall(ffi.typeof, 'astertrail_xinput_state_t*')
    if okt then XS_T = 'astertrail_xinput_state_t*' end
end

local pad_source = nil          -- 'state'（xinput_state が読めた）/ 'button'（xinput_button から）/ 'dinput'（dinput_button から）
local held_by_button = {}       -- xinput_button から作った押している集合
local held_by_dinput = {}       -- dinput_button から作った押している集合
local deferred = {}             -- 組み合わせに入っているボタン → { action, fires }（画面の操作は離したときに）

-- XINPUT_STATE を読む（表・ポインタのどちらでも）。読めなければ nil
local function read_xstate(st)
    if st == nil then return nil end
    if type(st) == 'table' then
        local g = st.Gamepad or st.gamepad or st
        local b = tonumber(g.wButtons or g.buttons)
        if not b then return nil end
        return b, tonumber(g.bLeftTrigger or g.left_trigger) or 0, tonumber(g.bRightTrigger or g.right_trigger) or 0,
            tonumber(g.sThumbLX or g.thumb_lx) or 0, tonumber(g.sThumbLY or g.thumb_ly) or 0
    end
    if not (ffi and XS_T) then return nil end
    local t = type(st)
    if t ~= 'cdata' and t ~= 'userdata' and t ~= 'number' then return nil end
    local ok, b, lt, rt, lx, ly = pcall(function ()
        local p = ffi.cast(XS_T, st)
        return tonumber(p.wButtons), tonumber(p.bLeftTrigger), tonumber(p.bRightTrigger),
            tonumber(p.sThumbLX), tonumber(p.sThumbLY)
    end)
    if ok then return b, lt, rt, lx, ly end
    return nil
end

-- トラッカーを操作しているあいだ（0.1.61〜）：ボタン・トリガー・スティックを全部ゲームに渡さない
local function strip_xstate_all(st)
    if st == nil then return end
    if type(st) == 'table' then
        local g = st.Gamepad or st.gamepad or st
        if g.wButtons ~= nil then g.wButtons = 0 elseif g.buttons ~= nil then g.buttons = 0 end
        g.bLeftTrigger = 0; g.bRightTrigger = 0
        g.sThumbLX = 0; g.sThumbLY = 0; g.sThumbRX = 0; g.sThumbRY = 0
        return
    end
    if not (ffi and XS_T) then return end
    pcall(function ()
        local p = ffi.cast(XS_T, st)
        p.wButtons = 0; p.bLeftTrigger = 0; p.bRightTrigger = 0
        p.sThumbLX = 0; p.sThumbLY = 0; p.sThumbRX = 0; p.sThumbRY = 0
    end)
end

-- ゲームに渡さないボタンを外す（state_modified に書く）
local function strip_xstate(st, block)
    if st == nil or next(block) == nil then return end
    local mask, lt, rt = 0, false, false
    for k in pairs(block) do
        local b = shortcut.BY_KEY[k]
        if b and b.bit then mask = mask + b.bit
        elseif b and b.trigger == 'left' then lt = true
        elseif b and b.trigger == 'right' then rt = true end
    end
    if type(st) == 'table' then
        local g = st.Gamepad or st.gamepad or st
        local v = tonumber(g.wButtons or g.buttons)
        if v then
            local out = 0
            for _, b in ipairs(shortcut.BUTTONS) do
                if b.bit and math.floor(v / b.bit) % 2 == 1 and math.floor(mask / b.bit) % 2 == 0 then out = out + b.bit end
            end
            if g.wButtons ~= nil then g.wButtons = out else g.buttons = out end
        end
        if lt then g.bLeftTrigger = 0 end
        if rt then g.bRightTrigger = 0 end
        return
    end
    if not (ffi and XS_T) then return end
    pcall(function ()
        local p = ffi.cast(XS_T, st)
        local bitlib = require('bit')
        p.wButtons = bitlib.band(tonumber(p.wButtons), bitlib.bnot(mask))
        if lt then p.bLeftTrigger = 0 end
        if rt then p.bRightTrigger = 0 end
    end)
end

-- 画面の操作に使うボタン（ボタンの名前 → 操作）。XInput・DirectInput のどちらも同じ名前で扱う（0.1.68〜）
local KEY_ACTION = {
    up = 'up', down = 'down', left = 'left', right = 'right',
    cross = 'confirm', circle = 'back', l1 = 'section_prev', r1 = 'section_next',
}
platform.KEY_ACTION = KEY_ACTION

-- ボタン1つの押した・離した（0.1.68〜。前は xinput_button の中だけにあった）。戻り値 true：ゲームに渡さない
-- held_pads・deferred はボタンの名前で覚える（どこから読んでも同じ）
local function pad_edge(key, down)
    local action = KEY_ACTION[key]
    if not action then return false end
    if down then
        if deferred[key] or held_pads[key] then return true end   -- もう押している（二重に数えない）
        if app.want_pad() and app.pad_in_combo and app.pad_in_combo(key) then
            -- ショートカットの組み合わせに入っているボタンは、押した時点では動かさない。
            -- 離したときに、そのあいだにショートカットが発動していなければ、いつもの操作をする
            deferred[key] = { action = action, fires = app.pad_fires and app.pad_fires() or 0 }
            held_pads[key] = true
            return true
        elseif app.want_pad() and app.input(action, true, 'pad') then
            held_pads[key] = true
            return true
        end
        return false
    end
    local d = deferred[key]
    if d then
        deferred[key] = nil
        local fired = (app.pad_fires and app.pad_fires() or 0) ~= d.fires
        if not fired and app.want_pad() then
            app.input(d.action, true, 'pad')
        end
    end
    app.input(action, false, 'pad')
    if held_pads[key] then
        held_pads[key] = nil
        return true
    end
    return false
end

-- 押している集合の変わったところだけ pad_edge に渡す（押しっぱなしは1回。くり返しは app の held）
local function pad_edges(prev, held)
    for key in pairs(KEY_ACTION) do
        local was, now = prev[key] == true, held[key] == true
        if now ~= was then pad_edge(key, now) end
    end
end

local game_saw = { x = {}, d = {} }   -- イベントの種類 → ボタン番号・データの位置 → true（ゲームが押下を見た）
local last_state_held = {}   -- xinput_state で前に読んだ押している集合（画面の操作の分）

-- xinput_state（毎回の XInputGetState）：書き換える前の値から、ショートカットと画面の操作の両方を読む（0.1.68〜）。
-- 0.1.67 までは画面の操作を xinput_button だけで読んでいた。トラッカーの操作中は、ここで XINPUT_STATE を全部 0 に
-- 書き換えるため、それをもとに作られる xinput_button が届かず、十字キー・×・○ が一つも効かなかった。
-- 0.1.226〜：画面の操作は十字キーだけ（左スティックでは動かさない）
local function on_xinput_state(e)
    if not app or not app.pad_held then return end
    local u = tonumber(e.user)
    if u and u ~= 0 then return end   -- 1台目のパッドだけ
    local b, lt, rt = read_xstate(e.state)
    if not b then return end
    pad_source = 'state'
    local held = shortcut.held_from_state(b, lt, rt)
    local block = app.pad_held(held) or {}
    local nav = held
    if not (app.pad_capturing and app.pad_capturing()) then
        nav = {}
        for k in pairs(held) do nav[k] = true end
        pad_edges(last_state_held, nav)
    end
    last_state_held = nav
    -- 画面の操作に使っている（押下を止めた）ボタンは、離すまでゲームにも見せない
    for key in pairs(held_pads) do if type(key) == 'string' then block[key] = true end end
    -- state_modified は state と同じ場所（説明書 09-input）。無い環境では state を書き換える
    if app.pad_block_all and app.pad_block_all() then
        strip_xstate_all(e.state_modified or e.state)
    elseif next(block) ~= nil then strip_xstate(e.state_modified or e.state, block) end
end

function platform.pad_source() return pad_source end
function platform._reset_pad_source()   -- 開発用
    pad_source = nil; held_by_button = {}; held_by_dinput = {}; deferred = {}; last_state_held = {}
    if game_saw then game_saw.x = {}; game_saw.d = {} end
    for k in pairs(held_pads) do held_pads[k] = nil end
end

--[[ ゲームが押したと見たボタンの「離した」は、必ずゲームへ渡す（0.1.188〜、t310）
  0.1.187 までは、トラッカーの操作中（pad_block_all）や、ショートカットの「ゲームに渡さない」（pad_blocking）、
  画面の操作で止めたボタン（held_pads）のとき、ボタンの出入りのイベントを「離した」も含めて全部止めていた。
  操作に入る前にゲームが押下を見ていたボタン（入るのに使った R1 などの組み合わせ）は、離したのが届かず、
  ゲームは押しっぱなしと思ったまま（R1 などを押したままの扱いで、決定・キャンセルなどが効かない）になっていた。
  xinput_state を 0 に書き換えると、そこから作られる「離した」も止めていたので、XInput でも同じ。
  ここで、ゲームに渡した押下を覚え、その「離した」（トリガーは 0、十字キーは真ん中）は止めない。 ]]

-- 戻り値：このイベントを止めるか（blocked は止めたいか）。active=押している・真ん中でない
local function settle(kind, id, active, blocked)
    if id == nil then return blocked end
    local seen = game_saw[kind]
    if active then
        if not blocked then seen[id] = true end
        return blocked
    end
    -- 離した：ゲームが押下を見ていれば必ず渡す
    if seen[id] then
        seen[id] = nil
        return false
    end
    return blocked
end
platform._game_saw = function () return game_saw end   -- 開発用（テストから読む）

-- 開発用・診断：ゲームが押していると思っているボタンの数
function platform.game_held_count()
    local n = 0
    for _, t in pairs(game_saw) do for _ in pairs(t) do n = n + 1 end end
    return n
end

local function on_xinput_button(e)
    if not app then return end
    local b = e.button
    local key = shortcut.key_of_button_id(b)
    local down = shortcut.button_down(b, e.state)
    -- ボタン待ちの間は、画面の操作にもゲームにも使わない
    if app.pad_capturing and app.pad_capturing() and pad_source == 'state' then
        if not settle('x', tonumber(b), (tonumber(e.state) or 0) ~= 0, true) then e.blocked = false; return end
        e.blocked = true
        return true
    end
    -- xinput_state が読めないときは、ボタンの出入りから押している集合を作り、画面の操作もここで読む
    if pad_source ~= 'state' and key and app.pad_held then
        pad_source = 'button'
        local prev = {}
        for k in pairs(held_by_button) do prev[k] = true end
        held_by_button[key] = down or nil
        local copy = {}
        for k in pairs(held_by_button) do copy[k] = true end
        app.pad_held(copy)
        if app.pad_capturing and app.pad_capturing() then
            if not settle('x', tonumber(b), (tonumber(e.state) or 0) ~= 0, true) then e.blocked = false; return end
            e.blocked = true
            return true
        end
        if KEY_ACTION[key] and pad_edge(key, down) then e.blocked = true end
    elseif key and KEY_ACTION[key] and (held_pads[key] or (down and app.want_pad())) then
        -- xinput_state で読む操作のボタン：ここでもゲームに渡さない（操作は xinput_state の方だけ。二重にしない）
        e.blocked = true
    end
    -- 「ゲームに渡さない」のショートカットは、離すまでゲームへ渡さない
    if key and app.pad_blocking and app.pad_blocking(key) then e.blocked = true end
    -- トラッカーを操作しているあいだは、どのボタンもゲームに渡さない
    if app.pad_block_all and app.pad_block_all() then e.blocked = true end
    -- ただし、ゲームが押下を見たボタンの「離した」は渡す（0.1.188〜）
    local active = (tonumber(e.state) or 0) ~= 0
    if not settle('x', tonumber(b), active, e.blocked == true) then
        e.blocked = false
        return
    end
    if e.blocked == true then return true end
end

-- DirectInput の十字キー（POV、0.1.68〜）。shortcut.DINPUT_POV（データの位置 32）、state は角度×100
local function pov_held(st)
    st = tonumber(st)
    local out = {}
    if not st or st < 0 or st >= 36000 then return out end
    local a = st / 100
    if a >= 292.5 or a < 67.5 then out.up = true end
    if a >= 22.5 and a < 157.5 then out.right = true end
    if a >= 112.5 and a < 247.5 then out.down = true end
    if a >= 202.5 and a < 337.5 then out.left = true end
    return out
end
platform._pov_held = pov_held   -- 開発用

-- DirectInput のパッド（0.1.59〜）。XInput が届いているときは使わない（二重に数えない）
-- 0.1.68〜：十字キー（POV）と ×・○・L1・R1 で、画面の操作もする（前はショートカットだけだった）
local function on_dinput_button(e)
    if not app or not app.pad_held then return end
    if pad_source == 'state' or pad_source == 'button' then return end
    local off = tonumber(e.button)
    local prev = {}
    for k in pairs(held_by_dinput) do prev[k] = true end
    local mine = false
    if off == shortcut.DINPUT_POV then
        for _, k in ipairs({ 'up', 'down', 'left', 'right' }) do held_by_dinput[k] = nil end
        for k in pairs(pov_held(e.state)) do held_by_dinput[k] = true end
        mine = true
    else
        local key = shortcut.key_of_dinput(off)
        if not key then return end
        held_by_dinput[key] = shortcut.dinput_down(e.state) or nil
        mine = true
    end
    if not mine then return end
    pad_source = 'dinput'
    local copy = {}
    for k in pairs(held_by_dinput) do copy[k] = true end
    app.pad_held(copy)
    -- ゲームが押下を見たか（0.1.188〜）：十字キーは真ん中でないこと、ボタンは押していること
    local d_active
    if off == shortcut.DINPUT_POV then d_active = next(pov_held(e.state)) ~= nil
    else d_active = shortcut.dinput_down(e.state) and true or false end
    if app.pad_capturing and app.pad_capturing() then
        if not settle('d', off, d_active, true) then e.blocked = false; return end
        e.blocked = true
        return true
    end
    local blocked = false
    for key in pairs(KEY_ACTION) do
        local was, now = prev[key] == true, copy[key] == true
        if now ~= was and pad_edge(key, now) then blocked = true end
    end
    for k in pairs(copy) do
        if held_pads[k] or (app.pad_blocking and app.pad_blocking(k)) then blocked = true end
    end
    blocked = blocked or (app.pad_block_all and app.pad_block_all()) or false
    if settle('d', off, d_active, blocked) then
        e.blocked = true
        return true
    end
    e.blocked = false
end

---------------------------------------------------------------------------
-- 見えている相手と、画面上の位置（頭上マーク用。読み取りだけ）
---------------------------------------------------------------------------

local ENTITY_MAX = 4095
local SPAWN_MOB = 0x10
local SPAWN_NPC = 0x02
local SPAWN_PC  = 0x01

local function band(a, b)
    a, b = tonumber(a) or 0, tonumber(b) or 0
    if bit and bit.band then return bit.band(a, b) end
    -- LuaJIT 以外のときの粗い代替
    local r, bitv = 0, 1
    while a > 0 or b > 0 do
        if a % 2 == 1 and b % 2 == 1 then r = r + bitv end
        a, b, bitv = math.floor(a / 2), math.floor(b / 2), bitv * 2
    end
    return r
end

-- 名前の候補（毎回表を作らない。0.1.210〜）
local EN_DISTANCE = { 'GetDistance' }
local EN_ENTITYTYPE = { 'GetEntityType', 'GetType' }
local EN_HEALTHPERCENT = { 'GetHealthPercent', 'GetHPP' }
local EN_LOCALPOSITIONX = { 'GetLocalPositionX', 'GetPositionX', 'GetX' }
local EN_LOCALPOSITIONY = { 'GetLocalPositionY', 'GetPositionY', 'GetY' }
local EN_LOCALPOSITIONZ = { 'GetLocalPositionZ', 'GetPositionZ', 'GetZ' }
local EN_MODELSIZE = { 'GetModelSize' }
local EN_NAME = { 'GetName' }
local EN_SERVERID = { 'GetServerId', 'GetServerID' }
local EN_SPAWNFLAGS = { 'GetSpawnFlags' }
local EN_STATUS = { 'GetStatus' }
local EN_RENDERFLAGS = { 'GetRenderFlags0' }

local function ent_call(ent, names, index)
    for _, n in ipairs(names) do
        local fn = ent[n]
        if type(fn) == 'function' then
            local ok, v = pcall(fn, ent, index)
            if ok and v ~= nil then return v end
        end
    end
    return nil
end

local function kind_of(flags, etype)
    flags = tonumber(flags) or 0
    if band(flags, SPAWN_MOB) ~= 0 then return 'mob' end
    if band(flags, SPAWN_NPC) ~= 0 then return 'npc' end
    if band(flags, SPAWN_PC) ~= 0 then return 'pc' end
    etype = tonumber(etype)
    if etype == 2 then return 'mob' end
    if etype == 1 then return 'npc' end
    if etype == 0 then return 'pc' end
    return 'other'
end

-- 名前の後ろに終端のゴミが付いていることがあるので、先に落とす。
local function clean_name(name)
    if type(name) ~= 'string' then return nil end
    local z = name:find('\0', 1, true)
    if z then name = name:sub(1, z - 1) end
    name = name:match('^%s*(.-)%s*$')
    if not name or name == '' then return nil end
    return name
end

-- 0.1.213〜：いま出ている（描かれている）相手か。render の 0x200 が「描かれている」の印。
-- 読めない（nil）ときは分からない（nil）を返す。
local RENDER_SHOWN = 0x200
local function render_shown(render)
    render = tonumber(render)
    if render == nil then return nil end
    return band(render, RENDER_SHOWN) ~= 0
end
platform._render_shown = render_shown
-- render の印が使えるか（全体の読み直しのたびに決める）。だれか1人（自分など）に印があれば使える。
-- 印がだれにも無いときは、読み方が合っていないとみなして、前のやり方（spawn の値）に戻す。
local render_usable = false

local function is_question_name(name)
    if name == '???' or name == '？？？' then return true end
    if type(name) ~= 'string' or name == '' then return false end
    local rest, n_fw = name:gsub('？', '')
    local rest2, n_ascii = rest:gsub('%?', '')
    return rest2 == '' and ((n_fw or 0) + (n_ascii or 0)) >= 2
end

local nameless_scan_at = -1
local nameless_indexes = {}

local function add_official_question(i, by_index, out)
    if not ext or not ext.game_entity then return nil end
    local ok_e, e = pcall(ext.game_entity, i)
    if not (ok_e and type(e) == 'table') then return nil end
    local name = clean_name(e.name)
    if not (name and is_question_name(name)) then return nil end
    -- 0.1.213〜：消えた ??? は足さない（前は出ていなくても足していて、天気で消えた ??? の印が残った）
    if render_usable and render_shown(e.render_flags) == false then return nil end
    local row = {
        index = i,
        name = name,
        x = tonumber(e.x), y = tonumber(e.y), z = tonumber(e.z),
        hpp = tonumber(e.hpp),
        dead = (tonumber(e.hpp) == 0),
        spawn_flags = tonumber(e.spawn_flags) or 0,
        entity_type = tonumber(e.type),
        model_size = tonumber(e.model_size),
        distance = tonumber(e.distance),
        server_id = tonumber(e.id),
        render_flags = tonumber(e.render_flags),
        kind = 'other',
        _official = true,
    }
    out[#out + 1] = row
    by_index[i] = row
    return row
end

local function scan_entities_full()
    local out = {}
    local ok, ent = pcall(function ()
        return AshitaCore:GetMemoryManager():GetEntity()
    end)
    if not ok or not ent then return out end
    -- 0.1.213〜：いま出ている相手だけ。render の 0x200（描かれている）で見る。
    -- 前は「??? は名前が出なくてもメモリ上にいることがある」ので spawn の値が 0 でも ??? を残していたが、
    -- 消えた（天気・時間で消えた、別の場所に移った）??? も残り、古い場所に印が出たままになっていた。
    -- render が読めないときだけ、前のやり方（spawn が 0 の相手は外す。??? だけは残す）に戻す。
    local raw = {}
    local any_shown = false
    for i = 0, ENTITY_MAX do
        local pok, row = pcall(function ()
            local name = clean_name(ent_call(ent, EN_NAME, i))
            if not name then return nil end
            local flags = tonumber(ent_call(ent, EN_SPAWNFLAGS, i)) or 0
            local render = tonumber(ent_call(ent, EN_RENDERFLAGS, i))
            local shown = render_shown(render)
            if shown then any_shown = true end
            -- どちらのやり方でも残らない相手は、ここで外す（残りは下で、render が使えるかを見てから決める）
            if shown ~= true and flags == 0 and not is_question_name(name) then return nil end
            local hpp = tonumber(ent_call(ent, EN_HEALTHPERCENT, i))
            local status = tonumber(ent_call(ent, EN_STATUS, i))
            -- 状態 2 は死亡（よく使われる値）。hpp 0 も死亡とみなす。
            local dead = (hpp == 0) or (status == 2)
            local x = tonumber(ent_call(ent, EN_LOCALPOSITIONX, i))
            local y = tonumber(ent_call(ent, EN_LOCALPOSITIONY, i))
            local z = tonumber(ent_call(ent, EN_LOCALPOSITIONZ, i))
            return {
                index = i,
                name = name,
                x = x, y = y, z = z,
                hpp = hpp,
                status = status,
                dead = dead,
                spawn_flags = flags,
                entity_type = tonumber(ent_call(ent, EN_ENTITYTYPE, i)),
                model_size = tonumber(ent_call(ent, EN_MODELSIZE, i)),
                distance = tonumber(ent_call(ent, EN_DISTANCE, i)),
                server_id = tonumber(ent_call(ent, EN_SERVERID, i)),
                render_flags = render,
                kind = kind_of(flags, ent_call(ent, EN_ENTITYTYPE, i)),
            }
        end)
        if pok and row then raw[#raw + 1] = row end
    end
    render_usable = any_shown
    for _, row in ipairs(raw) do
        if render_usable then
            if render_shown(row.render_flags) ~= false then out[#out + 1] = row end
        elseif row.spawn_flags ~= 0 or is_question_name(row.name) then
            out[#out + 1] = row
        end
    end
    -- 公式 vana.game.entity で、位置が無い相手を補い、Ashita が見逃した ??? を足す。
    if ext and ext.game_entity then
        local by_index = {}
        for _, row in ipairs(out) do
            if row.index ~= nil then by_index[row.index] = row end
        end
        for _, row in ipairs(out) do
            if row.index ~= nil and (row.x == nil or row.y == nil or row.z == nil or row.model_size == nil) then
                local ok_e, e = pcall(ext.game_entity, row.index)
                if ok_e and type(e) == 'table' then
                    if row.x == nil then row.x = tonumber(e.x) end
                    if row.y == nil then row.y = tonumber(e.y) end
                    if row.z == nil then row.z = tonumber(e.z) end
                    if row.model_size == nil then row.model_size = tonumber(e.model_size) end
                end
            end
        end
        -- 全部を毎フレーム歩くのは重いので、未発見の ??? の探索は少し間隔を空ける。
        -- すでに見つけた index は毎フレーム位置だけ更新する。
        local n = ext.entity_count and ext.entity_count()
        n = tonumber(n)
        if n then
            if n > ENTITY_MAX then n = ENTITY_MAX + 1 end
            local now = (platform.time and platform.time()) or 0
            if nameless_scan_at < 0 or (now - nameless_scan_at) >= 0.25 then
                nameless_scan_at = now
                nameless_indexes = {}
                for i = 0, n - 1 do
                    if not by_index[i] then
                        local row = add_official_question(i, by_index, out)
                        if row then
                            nameless_indexes[#nameless_indexes + 1] = i
                        end
                    end
                end
            else
                for _, i in ipairs(nameless_indexes) do
                    if not by_index[i] then
                        add_official_question(i, by_index, out)
                    end
                end
            end
        end
    end
    return out
end

-- 0.1.210〜：4096 件を歩くのは ENTITY_SCAN_EVERY 秒ごと。その間は見つけた相手の位置・HP だけ読み直す
-- （前は毎フレーム全部を歩いて名前を作っていて、それだけでフレームが重くなっていた）
platform.ENTITY_SCAN_EVERY = 0.25
local ent_cache = { rows = nil, at = -1 }

-- render の印で「いま出ているか」を見ているか（/astertrail status・確認用）
function platform.entity_render_usable()
    return render_usable
end

function platform.clear_entity_cache()
    ent_cache.rows, ent_cache.at = nil, -1
end

local function refresh_row(ent, row)
    if row._official then
        if not (ext and ext.game_entity) then return true end
        local ok_e, e = pcall(ext.game_entity, row.index)
        if not (ok_e and type(e) == 'table') then return false end
        if clean_name(e.name) ~= row.name then return false end
        -- 0.1.213〜：消えたらすぐ外す（次の全体の読み直しを待たない）
        if render_usable and render_shown(e.render_flags) == false then return false end
        row.x, row.y, row.z = tonumber(e.x), tonumber(e.y), tonumber(e.z)
        row.hpp = tonumber(e.hpp)
        row.dead = (row.hpp == 0)
        row.distance = tonumber(e.distance)
        return true
    end
    local i = row.index
    local name = clean_name(ent_call(ent, EN_NAME, i))
    if name ~= row.name then return false end
    -- 0.1.213〜：消えたらすぐ外す（次の全体の読み直しを待たない）
    if render_usable then
        local render = tonumber(ent_call(ent, EN_RENDERFLAGS, i))
        if render_shown(render) == false then return false end
        row.render_flags = render
    end
    local hpp = tonumber(ent_call(ent, EN_HEALTHPERCENT, i))
    local status = tonumber(ent_call(ent, EN_STATUS, i))
    row.hpp, row.status = hpp, status
    row.dead = (hpp == 0) or (status == 2)
    local x = tonumber(ent_call(ent, EN_LOCALPOSITIONX, i))
    local y = tonumber(ent_call(ent, EN_LOCALPOSITIONY, i))
    local z = tonumber(ent_call(ent, EN_LOCALPOSITIONZ, i))
    if x ~= nil then row.x = x end
    if y ~= nil then row.y = y end
    if z ~= nil then row.z = z end
    row.distance = tonumber(ent_call(ent, EN_DISTANCE, i))
    return true
end

function platform.visible_entities()
    local now = (platform.time and platform.time()) or 0
    local c = ent_cache
    if not c.rows or c.at < 0 or now - c.at >= platform.ENTITY_SCAN_EVERY or now < c.at then
        c.rows = scan_entities_full()
        c.at = now
        return c.rows
    end
    local ok, ent = pcall(function ()
        return AshitaCore:GetMemoryManager():GetEntity()
    end)
    if not ok or not ent then return c.rows end
    local gone = false
    for _, row in ipairs(c.rows) do
        local okr, alive = pcall(refresh_row, ent, row)
        if not (okr and alive) then row._gone = true; gone = true end
    end
    if gone then
        -- 消えた・入れ替わった相手は次の全体の読み直しまで外す
        local keep = {}
        for _, row in ipairs(c.rows) do if not row._gone then keep[#keep + 1] = row end end
        c.rows = keep
    end
    return c.rows
end

-- 投影の診断（設定や /astertrail status 用）
local project_note = nil
local project_ok = nil
local project_tried_at = 0
local cached_view, cached_proj, cached_vp, cached_at = nil, nil, nil, -1

function platform.project_status()
    return project_ok, project_note
end

local function viewport()
    local vp = { x = 0, y = 0, w = 0, h = 0 }
    if imgui and imgui.GetIO then
        local ok, io = pcall(imgui.GetIO)
        if ok and io and io.DisplaySize then
            vp.w = tonumber(io.DisplaySize.x) or 0
            vp.h = tonumber(io.DisplaySize.y) or 0
        end
    end
    local okd, d3d8 = pcall(require, 'd3d8')
    if okd and d3d8 and d3d8.get_device then
        local ok, dev = pcall(d3d8.get_device)
        if ok and dev and dev.GetViewport then
            local r1, r2 = dev:GetViewport()
            local v = (type(r1) == 'table' and r1.Width) and r1 or r2
            if type(v) == 'table' then
                vp.x = tonumber(v.X or v.x) or vp.x
                vp.y = tonumber(v.Y or v.y) or vp.y
                vp.w = tonumber(v.Width or v.w) or vp.w
                vp.h = tonumber(v.Height or v.h) or vp.h
            end
        end
    end
    if vp.w <= 0 or vp.h <= 0 then return nil end
    return vp
end

local function as_matrix(m)
    local project = require('src.core.project')
    return project.matrix(m)
end

local function read_transform(dev, state)
    if not dev or not dev.GetTransform then return nil end
    local ok, a, b = pcall(dev.GetTransform, dev, state)
    if not ok then return nil end
    local m = as_matrix(a) or as_matrix(b)
    if m then return m end
    -- 戻りが userdata / cdata のとき、フィールドを読む
    local src = (type(a) == 'table' or type(a) == 'cdata' or type(a) == 'userdata') and a or b
    if src == nil then return nil end
    local ok2, tabulated = pcall(function ()
        local t = {}
        for i = 1, 16 do
            local v = src[i] or (src.m and src.m[i])
            if v == nil and src._11 then
                return {
                    src._11, src._12, src._13, src._14,
                    src._21, src._22, src._23, src._24,
                    src._31, src._32, src._33, src._34,
                    src._41, src._42, src._43, src._44,
                }
            end
            t[i] = tonumber(v)
        end
        return t
    end)
    if ok2 then return as_matrix(tabulated) end
    return nil
end

local D3DTS_VIEW, D3DTS_PROJECTION = 2, 3

local function refresh_matrices(now)
    now = now or (platform.time and platform.time()) or 0
    if cached_at == now and cached_view then return cached_view, cached_proj, cached_vp end
    cached_view, cached_proj, cached_vp, cached_at = nil, nil, viewport(), now
    local dev
    local okd, d3d8 = pcall(require, 'd3d8')
    if okd and d3d8 and d3d8.get_device then
        local ok, d = pcall(d3d8.get_device)
        if ok then dev = d end
    end
    if not dev and ext and ext.d3d_device then
        local ok, d = pcall(ext.d3d_device)
        if ok then dev = d end
    end
    if dev then
        cached_view = read_transform(dev, (d3d8 and d3d8.D3DTS_VIEW) or D3DTS_VIEW)
        cached_proj = read_transform(dev, (d3d8 and d3d8.D3DTS_PROJECTION) or D3DTS_PROJECTION)
    end
    return cached_view, cached_proj, cached_vp
end

-- 水平 X / Y、高さ Z（地図と同じ）。画面外・カメラの後ろは nil。
-- VanaCore があるときは公式の to_screen / name_at だけを使い、自前の行列には落とさない。

local function map_ui_to_imgui(sx, sy)
    if not ext or not ext.ui_screen then return sx, sy end
    local ok, uw, uh = pcall(ext.ui_screen)
    uw, uh = tonumber(uw), tonumber(uh)
    if not ok or not uw or not uh or uw <= 0 or uh <= 0 then return sx, sy end
    local vp = viewport()
    if not vp or not vp.w or not vp.h or vp.w <= 0 or vp.h <= 0 then return sx, sy end
    if uw == vp.w and uh == vp.h then return sx, sy end
    return sx * (vp.w / uw), sy * (vp.h / uh)
end

function platform.world_to_screen(world_x, world_y, world_z)
    world_x, world_y, world_z = tonumber(world_x), tonumber(world_y), tonumber(world_z)
    if world_x == nil or world_y == nil then return nil end
    world_z = world_z or 0

    if ext and ext.world_screen then
        local ok, sx, sy, how = pcall(ext.world_screen, world_x, world_y, world_z)
        if ok and type(sx) == 'number' and type(sy) == 'number' then
            sx, sy = map_ui_to_imgui(sx, sy)
            project_ok, project_note = true, 'vanacore:' .. tostring(how or 'to_screen')
            return sx, sy, how
        end
        -- VanaCore があるときは、当たっていない行列計算に落とさない（ずれの原因だった）。
        if ext.available and ext.available() then
            return nil
        end
    end

    local view, proj, vp = refresh_matrices()
    if view and proj and vp then
        local project = require('src.core.project')
        -- Ashita 単独向けの控え。VanaCore では使わない。
        local r = project.screen(world_x, world_z, world_y, view, proj, vp)
        if r and r.visible then
            project_ok, project_note = true, 'd3d'
            return r.x, r.y, 'd3d'
        end
        if r and r.behind then
            return nil
        end
        if r and not r.visible then return nil end
    end

    if project_ok == nil then
        project_ok = false
        if not view or not proj then
            project_note = 'no_matrix'
        else
            project_note = 'not_on_screen'
        end
    end
    return nil
end

function platform.entity_screen(ent)
    if not ent then return nil end
    local index = ent.index
    -- 公式：vana.world.name_at(index)。名前が出ている相手の、名前の上端。
    if ext and ext.entity_screen and index ~= nil then
        local ok, sx, sy, how = pcall(ext.entity_screen, index)
        if ok and type(sx) == 'number' and type(sy) == 'number' then
            sx, sy = map_ui_to_imgui(sx, sy)
            project_ok, project_note = true, 'vanacore:' .. tostring(how or 'name_at')
            return sx, sy, how
        end
    end
    -- 名前が出ていないとき：公式 to_screen。上は z が小さいので、頭は足元から高さを引く。
    if ext and ext.world_screen and ext.available and ext.available()
        and ent.x ~= nil and ent.y ~= nil then
        local height = tonumber(ent.model_size) or 1.5
        if height < 0.4 then height = 0.4 end
        local hz = (tonumber(ent.z) or 0) - height
        local ok, sx, sy, how = pcall(ext.world_screen, ent.x, ent.y, hz)
        if ok and type(sx) == 'number' and type(sy) == 'number' then
            sx, sy = map_ui_to_imgui(sx, sy)
            project_ok, project_note = true, 'vanacore:' .. tostring(how or 'to_screen')
            return sx, sy, how
        end
        return nil
    end
    if ent.x ~= nil and ent.y ~= nil then
        -- Ashita 単独向けの控え（上向きが +Z の仮定）。VanaCore では上には来ない。
        local hz = (tonumber(ent.z) or 0) + (tonumber(ent.model_size) or 1) * 1.15
        return platform.world_to_screen(ent.x, ent.y, hz)
    end
    return nil
end


-- 名前ではなく本体の位置（公式 to_screen）。??? のように名前が出ない相手用。
-- 毎フレーム呼び、カメラに合わせて更新する。name_at は使わない。
function platform.entity_world_screen(ent)
    if not ent then return nil end
    if ext and ext.world_screen and ext.available and ext.available()
        and ent.x ~= nil and ent.y ~= nil then
        local height = tonumber(ent.model_size) or 1.5
        if height < 0.4 then height = 0.4 end
        -- 公式：上は z が小さい。頭は足元から高さを引く。
        local hz = (tonumber(ent.z) or 0) - height
        local ok, sx, sy, how = pcall(ext.world_screen, ent.x, ent.y, hz)
        if ok and type(sx) == 'number' and type(sy) == 'number' then
            sx, sy = map_ui_to_imgui(sx, sy)
            project_ok, project_note = true, 'vanacore:' .. tostring(how or 'to_screen')
            return sx, sy, how or 'to_screen'
        end
        return nil
    end
    if ent.x ~= nil and ent.y ~= nil then
        -- Ashita 単独向けの控え（上向きが +Z の仮定）。VanaCore では上には来ない。
        local hz = (tonumber(ent.z) or 0) + (tonumber(ent.model_size) or 1) * 1.15
        return platform.world_to_screen(ent.x, ent.y, hz)
    end
    return nil
end

---------------------------------------------------------------------------
-- 起動（イベントの登録）
---------------------------------------------------------------------------

function platform.attach_available()
    return ext and ext.attach_available and ext.attach_available() or false
end

function platform.set_name_marks(items)
    if ext and ext.set_addon_dir then
        pcall(ext.set_addon_dir, platform.addon_dir())
    end
    if not ext or not ext.set_name_marks then return false end
    local ok, r = pcall(ext.set_name_marks, items)
    if ok and r ~= false then
        local kind = ext.attach_kind and ext.attach_kind()
        local note = 'vanacore:attach'
        if type(kind) == 'string' and kind ~= '' then
            note = note .. ':' .. kind
        end
        project_ok, project_note = true, note
        return true, kind
    end
    return false
end

function platform.attach_kind()
    return ext and ext.attach_kind and ext.attach_kind() or nil
end

function platform.clear_name_marks()
    if ext and ext.clear_name_marks then
        pcall(ext.clear_name_marks)
    end
    if ext and ext.clear_world_marks then
        pcall(ext.clear_world_marks)
    end
end

function platform.place_available()
    return ext and ext.place_available and ext.place_available() or false
end

function platform.game_entity(index)
    if not ext or not ext.game_entity then return nil end
    local ok, e = pcall(ext.game_entity, index)
    if ok then return e end
    return nil
end

function platform.entity_count()
    if not ext or not ext.entity_count then return nil end
    local ok, n = pcall(ext.entity_count)
    if ok then return n end
    return nil
end

-- いまの天候の番号（0〜19。読み取りだけ）。読めなければ nil。
function platform.current_weather()
    if not ext or not ext.game_weather then return nil end
    local ok, n = pcall(ext.game_weather)
    if ok then return n end
    return nil
end

-- いまのターゲット（読み取りだけ。公式 vana.game.target）。いなければ nil。
function platform.current_target()
    if not ext or not ext.game_target then return nil end
    local ok, t = pcall(ext.game_target)
    if not ok or type(t) ~= 'table' then return nil end
    local idx = tonumber(t.index)
    if not idx or idx == 0 or t.active == false then
        return nil
    end
    local e = platform.game_entity(idx)
    local name, x, y, z, model_size, id, render_flags
    if type(e) == 'table' then
        name = clean_name(e.name)
        x, y, z = tonumber(e.x), tonumber(e.y), tonumber(e.z)
        model_size = tonumber(e.model_size)
        id = tonumber(e.id)
        render_flags = tonumber(e.render_flags)
    end
    return {
        index = idx,
        id = id or t.id,
        name = name,
        x = x, y = y, z = z,
        model_size = model_size,
        render_flags = render_flags,
    }
end

-- 名前が出ない相手を、本体の世界座標に公式 vana.world.place で置く。
-- 裏で一回だけ読む（アップデートのお知らせ用）。VanaCore の vana.http があるときだけ。
-- Ashita だけの環境では読まない（同梱の LuaSocket は読み終わるまでゲームを止めるため使わない）。
function platform.http_get(url, cb)
    if not ext or not ext.http_get then return false end
    local ok, r = pcall(ext.http_get, url, cb)
    return ok and r == true
end

function platform.http_download(url, path, cb, opts)
    if not ext or not ext.http_download then return false end
    local ok, r = pcall(ext.http_download, url, path, cb, opts)
    return ok and r == true
end

function platform.chat_run(line)
    if not ext or not ext.chat_run then return false end
    local ok, r = pcall(ext.chat_run, line)
    return ok and r == true
end

-- 効果音（0.1.183〜、t295）。WAV のファイルを鳴らす。VanaCore の vana.system.play_sound を先に、
-- 無ければ Ashita v4 の ashita.misc.play_sound。どちらも無ければ false（鳴らさない）
function platform.can_play_sound()
    if ext and ext.can_play_sound and ext.can_play_sound() then return true end
    return ashita ~= nil and type(ashita.misc) == 'table' and type(ashita.misc.play_sound) == 'function'
end

function platform.play_sound(path)
    if type(path) ~= 'string' or path == '' then return false end
    if ext and ext.play_sound and ext.play_sound(path) then return true end
    if ashita and type(ashita.misc) == 'table' and type(ashita.misc.play_sound) == 'function' then
        local ok = pcall(ashita.misc.play_sound, path)
        return ok
    end
    return false
end

-- 近くのオブジェクトの名前用（0.1.58〜）。公式 vana.game.entity の type・valid_target・name_x を返す。
-- 読めなければ nil（呼ぶ側は Ashita の値だけで決める）
function platform.object_info(ent)
    if not ent or ent.index == nil or not ext or not ext.game_entity then return nil end
    local ok, e = pcall(ext.game_entity, ent.index)
    if not ok or type(e) ~= 'table' then return nil end
    local info = { type = tonumber(e.type) }
    if e.valid_target ~= nil then info.targetable = e.valid_target == true end
    -- name_x は、ゲームがその名前を画面に描いているときだけある（0.8.224+）
    info.name_shown = (e.name_x ~= nil)
    return info
end

function platform.set_world_marks(items)
    if ext and ext.set_addon_dir then
        pcall(ext.set_addon_dir, platform.addon_dir())
    end
    if not ext or not ext.set_world_marks then return false end
    local ok, r, n = pcall(ext.set_world_marks, items)
    if ok and r ~= false then
        local kind = ext.place_kind and ext.place_kind()
        local note = 'vanacore:place'
        if type(kind) == 'string' and kind ~= '' then
            note = note .. ':' .. kind
        end
        project_ok, project_note = true, note
        return true, n, kind
    end
    if ext.place_error then
        project_ok, project_note = false, 'vanacore:' .. tostring(ext.place_error() or 'place_failed')
    end
    return false
end

function platform.place_kind()
    return ext and ext.place_kind and ext.place_kind() or nil
end

function platform.place_error()
    return ext and ext.place_error and ext.place_error() or nil
end

-- 足元の輪（0.1.171〜）。ext が無いときは何もしない
function platform.set_ground_rings(items)
    if not ext or not ext.set_ground_rings then return false, 'no_api' end
    local ok, r, n = pcall(ext.set_ground_rings, items)
    if not ok then return false, tostring(r) end
    return r, n
end
function platform.clear_ground_rings()
    if ext and ext.clear_ground_rings then pcall(ext.clear_ground_rings) end
end
function platform.rings_available()
    return ext and ext.rings_available and ext.rings_available() or false
end
function platform.rings_native()
    if not ext or not ext.rings_native then return nil end
    return ext.rings_native()
end

-- 頭上のアイコンの絵を読み直す（0.1.185〜、t301）。戻り値: { user = {名前...}, example = {名前...} } または nil（VanaCore の絵が無い環境）
function platform.reload_icons()
    if not (ext and ext.reset_mark_files and ext.mark_source) then return nil end
    pcall(ext.reset_mark_files)
    pcall(platform.clear_name_marks)
    local out = { user = {}, example = {} }
    for _, role in ipairs({ 'main', 'sub', 'repeat', 'unavailable', 'progress', 'blocked', 'complete',
                            'talk', 'hunt', 'examine', 'guard', 'fame' }) do
        local ok, src = pcall(ext.mark_source, role)
        local list = (ok and src == 'user') and out.user or out.example
        list[#list + 1] = role .. '.png'
    end
    return out
end

function platform.clear_world_marks()
    if ext and ext.clear_world_marks then
        pcall(ext.clear_world_marks)
    end
end

---------------------------------------------------------------------------
-- いまいる階（FloorId）。ゲーム本体の階の判定関数を、読むだけの使い方で呼ぶ。
-- 関数と、地図の管理役（ゾーンの地図をまとめる物）の場所は、Ashita 公式 Discord で公開されている
-- 探し方（バイト列）を目印に、FFXiMain.dll の中から探す。コードは自前。
--   関数: 8B542408568D4424108BF18B4C2410508B44240C（一致した先頭が関数）
--   管理役: 8B7424148B4424108B7C240C8B0D（0x0E 先に、管理役を入れておく場所の番地）
-- 呼び方は __thiscall（ecx に管理役）。引数は x, 高さ, y の順（Ashita の Y と Z が入れ替わる）。
-- 見つからない・二つ以上ある・呼べないときは nil（地図はこれまでどおりの動きに戻る）。
---------------------------------------------------------------------------

local FLOOR_FUNC_SIG = '8B542408568D4424108BF18B4C2410508B44240C'
local FLOOR_OWNER_SIG = '8B7424148B4424108B7C240C8B0D'
local FLOOR_OWNER_OFFSET = 0x0E
local GAME_MODULE = 'FFXiMain.dll'

local floor = { tried = false }
platform._floor = floor   -- 開発用（テストから読む）

-- Ashita 公式の ashita.memory（VanaCore では互換層）。vana.memory が無いときだけ使う。
local function ashita_memory()
    local m = rawget(_G, 'ashita') and ashita.memory
    if type(m) ~= 'table' or type(m.find) ~= 'function' or type(m.read_uint32) ~= 'function' then
        return nil
    end
    return {
        source = 'ashita.memory',
        find = function (module, pattern, offset, nth)
            -- 2つ目を探すときだけ 5 番目（何番目の一致か）を渡す
            if (nth or 0) == 0 then return m.find(module, 0, pattern, offset or 0) end
            return m.find(module, 0, pattern, offset or 0, nth)
        end,
        read_u32 = function (addr) return m.read_uint32(addr) end,
        module_range = function (module)
            local base = type(m.get_base) == 'function' and tonumber(m.get_base(module)) or nil
            local size = type(m.get_size) == 'function' and tonumber(m.get_size(module)) or nil
            return base, size
        end,
    }
end

-- "8B54.." → "8B 54 .."（どちらの書き方でも探せるように）
local function spaced(sig)
    return (sig:gsub('(%x%x)', '%1 '):gsub('%s+$', ''))
end

local function in_module(addr, base, size)
    if not base or not size or base == 0 or size <= 0 then return true end  -- 範囲が分からなければ見ない
    return addr >= base and addr < base + size
end

-- 一つだけ見つかったときの番地。二つ目が別の場所にあれば使わない。
local function find_one(mem, sig, offset)
    for _, pat in ipairs({ sig, spaced(sig) }) do
        local ok, a = pcall(mem.find, GAME_MODULE, pat, offset, 0)
        a = ok and tonumber(a) or 0
        if a ~= 0 then
            local ok2, b = pcall(mem.find, GAME_MODULE, pat, offset, 1)
            b = ok2 and tonumber(b) or 0
            if b ~= 0 and b ~= a then return nil, 'ambiguous' end
            return a
        end
    end
    return nil, 'not_found'
end

-- 見つけるのは一度だけ（毎回は探さない）
local function resolve_floor()
    if floor.tried then return floor.fn ~= nil end
    floor.tried = true
    local f = platform._ffi or ffi
    if not f then floor.why = 'no_ffi'; return false end
    local list = {}
    local vm = ext and ext.memory and ext.memory()
    if vm then list[#list + 1] = vm end
    local am = ashita_memory()
    if am then list[#list + 1] = am end
    if #list == 0 then floor.why = 'no_memory'; return false end
    local why = 'not_found'
    for _, mem in ipairs(list) do
        local fa, w1 = find_one(mem, FLOOR_FUNC_SIG, 0)
        local oa, w2 = find_one(mem, FLOOR_OWNER_SIG, FLOOR_OWNER_OFFSET)
        if fa and oa then
            local base, size = mem.module_range(GAME_MODULE)
            local gok, slot = pcall(mem.read_u32, oa)
            slot = gok and tonumber(slot) or 0
            if not in_module(fa, base, size) or not in_module(oa, base, size) then
                why = 'out_of_module'
            elseif slot == 0 or not in_module(slot, base, size) then
                why = 'bad_owner_slot'
            else
                local cok, fn = pcall(function ()
                    return f.cast(f.typeof('int32_t (__thiscall *)(void *, float, float, float)'), fa)
                end)
                if cok and fn then
                    floor.fn, floor.slot, floor.mem, floor.source = fn, slot, mem, mem.source
                    floor.func_addr = fa
                    floor.why = nil
                    return true
                end
                why = 'cast_failed'
            end
        else
            why = w1 or w2 or why
        end
    end
    floor.why = why
    return false
end

-- 戻り値: floor_id（数）または nil, 理由
function platform.current_floor_id()
    if ext and ext.zoning and ext.zoning() == true then return nil, 'zoning' end
    if not resolve_floor() then return nil, floor.why end
    local pl = platform.player()
    if not pl.ready or pl.x == nil or pl.y == nil or pl.z == nil then return nil, 'no_position' end
    local ok, obj = pcall(floor.mem.read_u32, floor.slot)
    obj = ok and tonumber(obj) or 0
    if obj == 0 then return nil, 'no_zone_map' end
    local f = platform._ffi or ffi
    local cok, r = pcall(function ()
        return floor.fn(f.cast('void *', obj), pl.x, pl.z, pl.y)
    end)
    if not cok then
        -- 一度失敗したら、この読み込みのあいだは呼ばない
        floor.fn = nil
        floor.why = 'call_failed'
        return nil, 'call_failed'
    end
    r = tonumber(r)
    if r == nil or r < 0 then return nil, 'no_floor' end
    return r
end

-- いまいるゾーンの、ある点の階（0.1.171〜、出口の階を覚えるのに使う）。x, y は水平面、z は高さ。
-- 呼び方は current_floor_id と同じ（x, 高さ, y の順）。読むだけ。
function platform.floor_at(x, y, z)
    x, y, z = tonumber(x), tonumber(y), tonumber(z)
    if x == nil or y == nil then return nil, 'no_position' end
    if ext and ext.zoning and ext.zoning() == true then return nil, 'zoning' end
    if not resolve_floor() then return nil, floor.why end
    local ok, obj = pcall(floor.mem.read_u32, floor.slot)
    obj = ok and tonumber(obj) or 0
    if obj == 0 then return nil, 'no_zone_map' end
    local f = platform._ffi or ffi
    local cok, r = pcall(function ()
        return floor.fn(f.cast('void *', obj), x, z or 0, y)
    end)
    if not cok then
        floor.fn = nil
        floor.why = 'call_failed'
        return nil, 'call_failed'
    end
    r = tonumber(r)
    if r == nil or r < 0 then return nil, 'no_floor' end
    return r
end

-- 調べもの用（/astertrail floor）
function platform.floor_status()
    return { tried = floor.tried, found = floor.fn ~= nil, why = floor.why, source = floor.source }
end


---------------------------------------------------------------------------
-- クエスト・ミッションの記録（0.1.169〜、t223。読むだけ。通信は送らない・変えない・止めない）
-- ゲームは届いた 0x056 の中身を FFXiMain.dll の中に写している。その場所を 0x056 の処理の命令から探す
-- （2026-11-16、GAME-PC で処理を読んで確かめた。どれも一致は 1 つ）。
---------------------------------------------------------------------------

local game_log = require('src.core.game_log')

local QLOG = {
    -- 受注中クエストの先頭：Port 0x50〜0x88 を写す所の lea esi,[eax*4+番地]
    cur_sig = '83 F8 50 7C ?? 3D 90 00 00 00 7D ?? 83 C0 B0 8B C8 8D 34 85', cur_off = 0x14,
    -- 完了クエストの先頭（Port 0x90〜）と、ミッション完了の先頭（Port 0xD0〜）
    done_sig = '05 70 FF FF FF 8B F0 8D 0C 85', done_off = 10,
    mdone_sig = '05 30 FF FF FF 8B F0 8D 0C 85', mdone_off = 10,
    -- 届いた印
    mask_sig = '81 3D ?? ?? ?? ?? FF FF FF 83 75', mask_off = 2,
}
local qlog = { tried = false }
platform._qlog = qlog   -- 開発用（テストから読む）

local function resolve_qlog()
    if qlog.tried then return qlog.cur ~= nil end
    qlog.tried = true
    local list = {}
    local vm = ext and ext.memory and ext.memory()
    if vm then list[#list + 1] = vm end
    local am = ashita_memory()
    if am then list[#list + 1] = am end
    if #list == 0 then qlog.why = 'no_memory'; return false end
    local why = 'not_found'
    for _, mem in ipairs(list) do
        local function addr_at(sig, off)
            local a, w = find_one(mem, sig, off)
            if not a then return nil, w end
            local ok, v = pcall(mem.read_u32, a)
            v = ok and tonumber(v) or 0
            if v == 0 then return nil, 'bad_slot' end
            return v
        end
        local c, w1 = addr_at(QLOG.cur_sig, QLOG.cur_off)
        local p, w2 = addr_at(QLOG.done_sig, QLOG.done_off)
        local m, w3 = addr_at(QLOG.mdone_sig, QLOG.mdone_off)
        local k, w4 = addr_at(QLOG.mask_sig, QLOG.mask_off)
        if c and p and m and k then
            local base, size = mem.module_range(GAME_MODULE)
            -- 並びが確かめたとおりか（違えば使わない）
            if p - c ~= 0x160 or m - p ~= 0x160 or k - m ~= 0xA4 then
                why = 'layout'
            elseif not in_module(c, base, size) or not in_module(k, base, size) then
                why = 'out_of_module'
            else
                qlog.cur, qlog.mem, qlog.source, qlog.why = c, mem, mem.source, nil
                return true
            end
        else
            why = w1 or w2 or w3 or w4 or why
        end
    end
    qlog.why = why
    return false
end

-- 戻り値: snap（game_log の形）, mask または nil, 理由
function platform.quest_log_snapshot()
    local snap, mask
    if resolve_qlog() then
        local mem = qlog.mem
        local ok, s, mk = pcall(game_log.from_memory, function (a)
            local rok, v = pcall(mem.read_u32, a)
            return rok and tonumber(v) or nil
        end, qlog.cur)
        if ok and s then snap, mask = s, mk end
    end
    -- 今のミッションは公式の vana.game.missions でも読める（写した場所が見つからないとき）
    if (not snap or not snap.main) and ext and ext.missions then
        local mok, mm = pcall(ext.missions)
        if mok and type(mm) == 'table' and mm.nation then
            snap = snap or game_log.new_snapshot()
            snap.source = snap.source or 'missions'
            snap.main = mm
            snap.ports[game_log.MAIN_PORT] = true
        end
    end
    if not snap then return nil, qlog.why or 'none' end
    return snap, mask
end

---------------------------------------------------------------------------
-- エミネンス・レコード（0.1.172〜、t243）。ゲームが 0x111・0x112 を写した場所を読む（読むだけ）
-- 0x111 の処理：64 個の u32 を写す mov eax,番地（＋5）、終わりの cmp eax,番地＋0x100（＋23）、届いた印（＋31）
-- 0x112 の処理：128 バイトを [ecx+eax+番地] へ写す（＋36）。2026-11-16、GAME-PC で処理を読んで確かめた（どれも一致は 1 つ）
-- 印のビット 2 は 0x111 が届いた、ビット 4 は 0x112 が 4 つ届いた（0 番目が来ると落ちる）
---------------------------------------------------------------------------

local ROE = {
    act_sig = '8B 4C 24 0C B8 ?? ?? ?? ?? 83 C1 04 8B 11 83 C1 04 89 10 83 C0 04 3D ?? ?? ?? ?? 7C EF 8B 15 ?? ?? ?? ?? A1 ?? ?? ?? ?? 83 CA 02',
    act_off = 5, act_end_off = 23, act_flag_off = 31,
    done_sig = '66 8B 86 84 00 00 00 66 3D 04 00 72 04 32 C0 5E C3 25 FF FF 00 00 C1 E0 07 8B C8 33 C0 8A 54 06 04 88 94 01',
    done_off = 36,
}
local roe_mem = { tried = false }
platform._roe_mem = roe_mem   -- 開発用（テストから読む）

local function resolve_roe()
    if roe_mem.tried then return roe_mem.active ~= nil end
    roe_mem.tried = true
    local list = {}
    local vm = ext and ext.memory and ext.memory()
    if vm then list[#list + 1] = vm end
    local am = ashita_memory()
    if am then list[#list + 1] = am end
    if #list == 0 then roe_mem.why = 'no_memory'; return false end
    local why = 'not_found'
    for _, mem in ipairs(list) do
        local function at(addr)
            local ok, v = pcall(mem.read_u32, addr)
            return ok and tonumber(v) or nil
        end
        local s = find_one(mem, ROE.act_sig, 0)
        local d = find_one(mem, ROE.done_sig, 0)
        if s and d then
            local a, e, f, c = at(s + ROE.act_off), at(s + ROE.act_end_off), at(s + ROE.act_flag_off), at(d + ROE.done_off)
            local base, size = mem.module_range(GAME_MODULE)
            if not a or a == 0 or e ~= a + 0x100 or c ~= a + 0x100 or f ~= a + 0x30C then
                why = 'layout'
            elseif not in_module(a, base, size) then
                why = 'out_of_module'
            else
                roe_mem.active, roe_mem.complete, roe_mem.flag = a, c, f
                roe_mem.mem, roe_mem.source, roe_mem.why = mem, mem.source, nil
                return true
            end
        else
            why = (not s and 'not_found_active') or 'not_found_log'
        end
    end
    roe_mem.why = why
    return false
end

-- 戻り値: { words = u32 の 64 個（0x111 が届いていれば）, complete = 512 バイトの表（4 つそろっていれば）, flags } または nil, 理由
function platform.roe_snapshot()
    if not resolve_roe() then return nil, roe_mem.why end
    local mem = roe_mem.mem
    local function rd(addr)
        local ok, v = pcall(mem.read_u32, addr)
        return ok and tonumber(v) or nil
    end
    local flags = rd(roe_mem.flag)
    if not flags then return nil, 'read' end
    local out = { flags = flags }
    if math.floor(flags / 2) % 2 == 1 then
        local w = {}
        for i = 1, 64 do
            local v = rd(roe_mem.active + (i - 1) * 4)
            if not v then return nil, 'read' end
            w[i] = v
        end
        out.words = w
    end
    if math.floor(flags / 4) % 2 == 1 then
        local c = {}
        for i = 0, 127 do
            local v = rd(roe_mem.complete + i * 4)
            if not v then return nil, 'read' end
            c[i * 4 + 1] = v % 256
            c[i * 4 + 2] = math.floor(v / 256) % 256
            c[i * 4 + 3] = math.floor(v / 65536) % 256
            c[i * 4 + 4] = math.floor(v / 16777216) % 256
        end
        out.complete = c
    end
    return out
end

function platform.roe_status()
    return { tried = roe_mem.tried, found = roe_mem.active ~= nil, why = roe_mem.why, source = roe_mem.source,
             packets = platform.packet_hooked == true, out_hooked = platform.packet_out_hooked == true,
             can_send = (ext and ext.can_inject and ext.can_inject()) or platform.ashita_can_send() }
end

-- 最後に届いた通信（読み込んだ直後、写した場所が読めないとき用）。公式 vana.packets.last
function platform.last_packet(id)
    if not ext or not ext.last_packet then return nil end
    local ok, p = pcall(ext.last_packet, true, id)
    if ok and type(p) == 'string' then return p end
    return nil
end

-- クライアントの DAT を読む（ファイル番号から）。戻り値: 中身, または nil, 理由
function platform.read_dat(file_id)
    local path, why = platform.get_file_path(file_id)
    if not path then return nil, why or 'no_path' end
    local raw = platform.fs.read(path)
    if type(raw) ~= 'string' then return nil, 'read' end
    return raw
end

-- Ashita の送る窓口（VanaCore の公式が無いときだけ）
local function ashita_packet_manager()
    local ok, pm = pcall(function ()
        return AshitaCore and AshitaCore.GetPacketManager and AshitaCore:GetPacketManager()
    end)
    if ok and pm and type(pm.AddOutgoingPacket) == 'function' then return pm end
    return nil
end
function platform.ashita_can_send() return ashita_packet_manager() ~= nil end

-- 受ける・外す（エミネンスの窓・本のボタンを押したときだけ、app から 1 回呼ぶ）。やり直さない・ためない
-- 戻り値: true, 送った窓口 / false, 理由
function platform.roe_send(pid, data)
    if type(data) ~= 'string' or #data ~= 8 or (pid ~= 0x10C and pid ~= 0x10D) then return false, 'bad_packet' end
    if ext and ext.can_inject and ext.can_inject() then
        local ok, why = ext.inject_packet(false, pid, data)
        if ok then return true, 'vanacore' end
        return false, why or 'inject_failed'
    end
    local pm = ashita_packet_manager()
    if pm then
        local bytes = { data:byte(1, -1) }
        -- Ashita の窓口は頭の番号と長さもこちらで入れる（順番の数はゲーム側）
        bytes[1] = pid % 256
        bytes[2] = math.floor(pid / 256) + (#data / 4) * 2
        local ok, err = pcall(pm.AddOutgoingPacket, pm, pid, bytes)
        if ok then return true, 'ashita' end
        return false, tostring(err)
    end
    return false, 'no_api'
end

-- 調べもの用（/astertrail gamelog）
function platform.quest_log_status()
    return { tried = qlog.tried, found = qlog.cur ~= nil, why = qlog.why, source = qlog.source,
             packets = platform.packet_hooked == true }
end


---------------------------------------------------------------------------
-- ゲーム本来のメニュー（VanaCore の vana.gameui。中身は vanacore_ext.lua）
---------------------------------------------------------------------------

local gm = { watch_id = nil, button = nil, button_tried = false, catch_id = nil }
platform._gameui = gm   -- 開発用（テストから読む）

-- ズームの縮み具合（/astertrail target 用）。戻り値: f, 名前の高さ, 基準の高さ
function platform.zoom_info(index)
    if not ext or not ext.name_zoom then return nil end
    local ok, f, h, ref = pcall(ext.name_zoom, index)
    if ok then return f, h, ref end
    return nil
end

function platform.place_zoom_info(x, y, z)
    if not ext or not ext.place_zoom then return nil end
    local ok, f, d = pcall(ext.place_zoom, x, y, z)
    if ok then return f, d end
    return nil
end

function platform.place_ref_distance()
    return ext and ext.PLACE_REF_DISTANCE or nil
end

function platform.chat_open()
    if not ext or not ext.chat_open then return nil end
    local ok, r = pcall(ext.chat_open)
    if ok then return r end
    return nil
end

-- missionm（メインメニュー > ミッション）を見る。on=false で止める。fn(what, name, closing)
function platform.watch_game_windows(on, fn)
    if not ext or not ext.watch_windows then return false end
    if on then
        if gm.watch_id ~= nil then return true end
        local id, why = ext.watch_windows({ 'missionm' }, fn)
        gm.watch_id = id
        gm.watch_why = why
        return id ~= nil
    end
    if gm.watch_id ~= nil then ext.unwatch(gm.watch_id); gm.watch_id = nil end
    return true
end

-- コンフィグのボタン。on=true で一度だけ試す（失敗したら、この読み込み中はもう試さない）
function platform.config_button(on, labels, fn)
    if not ext or not ext.add_config_button then return nil end
    if on then
        if gm.button then return gm.button end
        if gm.button_tried then return nil, gm.button_why end
        gm.button_tried = true
        local label, why = ext.add_config_button(labels, fn)
        gm.button, gm.button_why = label, why
        return label, why
    end
    if gm.button then ext.remove_config_button() end
    gm.button = nil
    gm.button_tried = false
    return nil
end

-- 本の操作中、ゲームのメニューに入力を渡さない（公式 catch）。on=false で必ず外す
function platform.menu_capture(on)
    if not ext or not ext.catch_menus then return false end
    if on then
        if gm.catch_id ~= nil then return true end
        local id = ext.catch_menus()
        gm.catch_id = id
        return id ~= nil
    end
    if gm.catch_id ~= nil then ext.release_menus(gm.catch_id); gm.catch_id = nil end
    return true
end

-- ゲームのメニューが開いているか（0.1.186〜）。VanaCore だけ（Ashita v4 だけの環境には読む窓口が無いので nil）
function platform.game_menu_state()
    if ext and ext.game_menu_state then
        local ok, open, info = pcall(ext.game_menu_state)
        if ok then return open, info end
    end
    return nil, {}
end

function platform.can_game_on_top() return (ext and ext.can_game_on_top and ext.can_game_on_top()) and true or false end

function platform.set_game_on_top(on)
    if ext and ext.set_game_on_top then return ext.set_game_on_top(on) end
    return false
end

function platform.release_gameui()
    pcall(platform.set_game_on_top, false)
    pcall(platform.menu_capture, false)
    pcall(platform.watch_game_windows, false)
    pcall(platform.config_button, false)
end


function platform.start(the_app)
    app = the_app
    if ext and ext.set_addon_dir then
        pcall(ext.set_addon_dir, platform.addon_dir())
    end
    local ev = ashita.events
    ev.register('load', 'astertrail_load', function ()
        -- 起動処理は start の時点で済んでいる
    end)
    ev.register('unload', 'astertrail_unload', function ()
        -- 名前に付けた箱を外してから保存する
        pcall(platform.clear_name_marks)
        -- ゲームのメニューへの入力止め・ボタン・見張りを必ず外す
        pcall(platform.release_gameui)
        for k in pairs(held_keys) do held_keys[k] = nil end
        for b in pairs(held_pads) do held_pads[b] = nil end
        local ok, err = pcall(app.unload)
        if not ok then platform.print('unload: ' .. tostring(err)) end
        app = nil
    end)
    ev.register('command', 'astertrail_command', function (e)
        if not app then return end
        local cmd = e.command or ''
        -- /astertrail または /ast（単語ごと。/assist・/as は飲まない）
        local head = cmd:lower():match('^(%S+)') or ''
        if head ~= '/astertrail' and head ~= '/ast' then return end
        local ok, handled = pcall(app.command, cmd)
        if not ok then platform.print('command: ' .. tostring(handled)); e.blocked = true; return end
        if handled then e.blocked = true end
    end)
    local last_err
    ev.register('d3d_present', 'astertrail_present', function ()
        if not app then return end
        local ok, err = pcall(app.present)
        if not ok and tostring(err) ~= last_err then
            last_err = tostring(err)
            platform.print('present: ' .. last_err)
        end
    end)
    -- 入力のイベントは、無い環境でも本体は動くように個別に登録する
    platform.input_events = {}
    local function try(name, alias, fn)
        -- 戻り値も返す（VanaCore では true で「ゲームに渡さない」。説明書 09-input）
        local ok = pcall(ev.register, name, alias, function (e)
            local okf, r = pcall(fn, e)
            if okf then return r end
        end)
        platform.input_events[name] = ok
    end
    try('key_data', 'astertrail_key_data', on_key_data)
    try('key_state', 'astertrail_key_state', on_key_state)
    try('xinput_button', 'astertrail_xinput', on_xinput_button)
    try('xinput_state', 'astertrail_xinput_state', on_xinput_state)
    try('dinput_button', 'astertrail_dinput', on_dinput_button)
    -- 届いた通信（0.1.169〜、0x056 クエスト・ミッションのログだけ見る。読むだけ：変えない・止めない・送らない）
    -- 0.1.172〜：エミネンスの 0x111・0x112・0x029（受けた・受けられないの文）も読む
    platform.packet_hooked = pcall(ev.register, 'packet_in', 'astertrail_packet_in', function (e)
        if not app or type(e) ~= 'table' or e.injected then return end
        local id = tonumber(e.id)
        -- 所持の変わり目（0.1.184〜）：0x01C 入れ物の大きさ・0x01D 読み終わり・0x01E/0x01F/0x020 品・0x055 だいじなもの
        if INV_PACKETS[id] then
            if app.on_inventory_packet then pcall(app.on_inventory_packet, id) end
            return
        end
        -- 0.1.305〜：0x008（行ったエリアの表）も読む（エミネンスの、ゲームでまだ出ていない目標を隠すのに使う）
        if id == 0x008 then
            if app.on_visited_packet and type(e.data) == 'string' then pcall(app.on_visited_packet, e.data, 'packet') end
            return
        end
        -- 0.1.224〜：0x110（ユニティの今日の組・今週）・0x061（自分のユニティのリーダー）も読む
        if id ~= 0x056 and id ~= 0x111 and id ~= 0x112 and id ~= 0x029 and id ~= 0x110 and id ~= 0x061 then return end
        local d = e.data
        if type(d) ~= 'string' then return end
        if id == 0x056 then
            if app.on_quest_packet then pcall(app.on_quest_packet, d) end
        elseif app.on_roe_packet then
            pcall(app.on_roe_packet, id, d)
        end
    end)
    -- ゲームのメニューが送った 0x10C・0x10D を覚えるだけ（0.1.172〜、作る形と同じかを /astertrail roe で見る。変えない・止めない）
    platform.packet_out_hooked = pcall(ev.register, 'packet_out', 'astertrail_packet_out', function (e)
        if not app or not app.on_roe_game_sent or type(e) ~= 'table' or e.injected then return end
        local id = tonumber(e.id)
        if id ~= 0x10C and id ~= 0x10D then return end
        if type(e.data) == 'string' then pcall(app.on_roe_game_sent, id, e.data) end
    end)
    -- チャット欄に届く行（0.1.66〜、名声を教えてくれる人の返事を読むだけ。行は変えない・止めない）
    pcall(ev.register, 'text_in', 'astertrail_text_in', function (e)
        if not app or not app.on_text_in or type(e) ~= 'table' or e.injected then return end
        local raw = e.message
        if type(raw) ~= 'string' or raw == '' then return end
        local text = platform.text_from_game(raw)
        if text then pcall(app.on_text_in, text, e.mode) end
    end)
end

-- 品の静的資料とアイコン（0.1.262〜）。ゲームの API が無いときは nil。
function platform.gamedata_item(id)
    if ext and ext.gamedata_item then return ext.gamedata_item(id) end
    return nil
end

function platform.gamedata_key_item(id)
    if ext and ext.gamedata_key_item then return ext.gamedata_key_item(id) end
    return nil
end

function platform.gamedata_job(id)
    if ext and ext.gamedata_job then return ext.gamedata_job(id) end
    return nil
end

function platform.item_icon_bytes(id)
    if ext and ext.item_icon_bytes then return ext.item_icon_bytes(id) end
    return nil
end


return platform
