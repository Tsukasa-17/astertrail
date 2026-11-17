--[[
  Astertrail - platform: VanaCore の追加窓口（読み取りだけ。送るのはエミネンスの受ける・外すのボタンを押したときの 1 回だけ）
  VanaCore の API（vana.*）を呼ぶのはこのファイルだけ。
  メインのファイルに vana. と書くと VanaCore 形式のアドオンと判定されるため、ここに分けている。
  無い・失敗した時は何もしない（本体は Ashita 窓口だけで動く）。
]]

local ext = {}

local function V()
    local v = rawget(_G, 'vana')
    if type(v) == 'table' then return v end
    return nil
end

function ext.available()
    return V() ~= nil
end

-- チャットへ出す文字。Lua は UTF-8、ゲームのチャットは Shift-JIS。
-- 公式：vana.encoding.to_shift_jis（docs/addons/05-chat-and-commands.md）
function ext.to_shift_jis(s)
    s = tostring(s or '')
    local v = V()
    if v and type(v.encoding) == 'table' and type(v.encoding.to_shift_jis) == 'function' then
        local ok, out = pcall(v.encoding.to_shift_jis, s)
        if ok and type(out) == 'string' then return out end
    end
    return s
end

-- ゲームの文字（Shift-JIS）→ UTF-8（0.1.66〜、名声の返事を読む用）。公式 vana.encoding.from_shift_jis
-- （docs/addons/05-chat-and-commands.md）。無いときは nil（読まない）。
function ext.from_shift_jis(s)
    local v = V()
    if v and type(v.encoding) == 'table' and type(v.encoding.from_shift_jis) == 'function' then
        local ok, out = pcall(v.encoding.from_shift_jis, tostring(s or ''))
        if ok and type(out) == 'string' then return out end
    end
    return nil
end

-- アップデートのお知らせ用（0.1.58〜）。公式 vana.http.get（docs/addons/17-http-and-websockets.md）。
-- 通信は VanaCore の別のスレッドで行われ、ゲームは止まらない。答えは次のフレーム以降に cb(body) で返す。
-- 失敗・つながらない・200 番台でないときは cb(nil)。vana.http が無ければ false（何もしない）。
function ext.http_get(url, cb)
    local v = V()
    if not v or type(v.http) ~= 'table' or type(v.http.get) ~= 'function' then return false end
    local ok = pcall(v.http.get, url, { timeout = 10, max_time = 20, max_size = 65536 }, function (res, err)
        if err or type(res) ~= 'table' or not res.ok then
            pcall(cb, nil)
            return
        end
        pcall(cb, res.body)
    end)
    return ok
end

-- 効果音（0.1.183〜、t295）。VanaCore の vana.system.play_sound(path)（Windows の PlaySound でファイルを鳴らす）。
-- 無い・失敗したら false
function ext.can_play_sound()
    local v = V()
    return v ~= nil and type(v.system) == 'table' and type(v.system.play_sound) == 'function'
end

function ext.play_sound(path)
    if not ext.can_play_sound() then return false end
    local ok = pcall(V().system.play_sound, path)
    return ok
end

-- 所持（0.1.184〜、t297）。vana.game.container(番号) → { capacity = n, [0..n-1] = { id, count, ... } }。
-- 実機（VanaCore の MCP で読むだけ）で確かめたこと：0〜17 が読める。番号 0 の欄は本物の品ではない
-- （かばんはギル、ほかは id 65535）。capacity が 0 のものはまだ届いていない（未確認）。
function ext.can_read_containers()
    local v = V()
    return v ~= nil and type(v.game) == 'table' and type(v.game.container) == 'function'
end

-- cids の入れ物を読む。戻り値: { [番号] = { [品の番号] = 個数 } または false（未確認） }。読めない環境は nil
function ext.read_containers(cids)
    if not ext.can_read_containers() then return nil end
    local fn = V().game.container
    local out = {}
    for _, cid in ipairs(cids) do
        local ok, c = pcall(fn, cid)
        local cap = ok and type(c) == 'table' and tonumber(c.capacity) or nil
        if not cap or cap <= 0 then
            out[cid] = false
        else
            local items = {}
            for slot = 1, cap - 1 do
                local it = c[slot]
                if type(it) == 'table' then
                    local id, n = tonumber(it.id), tonumber(it.count)
                    if id and id > 0 and id ~= 65535 and n and n > 0 then items[id] = (items[id] or 0) + n end
                end
            end
            out[cid] = items
        end
    end
    return out
end

-- だいじなもの：vana.game.key_items() → 512 バイト（番号 n は n/8 バイト目の下から n%8 ビット目）。
-- 届く前（nil・全部 0）は nil。戻り値: function(id) → true/false/nil
function ext.key_items()
    local v = V()
    if not v or type(v.game) ~= 'table' or type(v.game.key_items) ~= 'function' then return nil end
    local ok, bits = pcall(v.game.key_items)
    if not ok or type(bits) ~= 'string' or #bits == 0 or not bits:find('[^%z]') then return nil end
    return function (id)
        id = tonumber(id)
        if not id or id < 0 then return nil end
        local b = bits:byte(math.floor(id / 8) + 1)
        if not b then return nil end
        return math.floor(b / 2 ^ (id % 8)) % 2 == 1
    end
end

-- パッドの様子（設定画面の表示用。入力の受け取りには使わない）
function ext.gamepad_note()
    local v = V()
    if not v or type(v.gamepad) ~= 'table' then return nil end
    local parts = {}
    if v.gamepad.state then
        local ok, st = pcall(v.gamepad.state)
        if ok and type(st) == 'table' then
            parts[#parts + 1] = st.present and 'パッド検出あり' or 'パッド検出なし'
        end
    end
    if v.gamepad.disabled then
        local ok, d = pcall(v.gamepad.disabled)
        if ok and d then parts[#parts + 1] = 'ゲーム側で無効' end
    end
    if #parts == 0 then return nil end
    return table.concat(parts, '・')
end



-- 地図テクスチャ用。VanaCore が持っている描画デバイス（無ければ nil）

function ext.d3d_device()
    local v = V()
    if not v or type(v.ashita) ~= 'table' or type(v.ashita.object) ~= 'function' then
        return nil
    end
    local ok, raw = pcall(v.ashita.object, 'device')
    if ok and raw ~= nil then return raw end
    return nil
end

-- 頭上マーク用。VanaCore 公式 API（docs/addons/18-widgets.md）だけを使う。
--   vana.world.name_at(index) → x, top, bottom
--     名前の画面位置（vana.ui.screen のピクセル）。印は top のすぐ上に置く。
--     名前が出ていない（遠い、設定で非表示など）ときは nil。
--   vana.game.entity(index) の name_x / name_top / name_bottom は同じ値（0.8.224+）。
--   vana.world.to_screen(x, y, z) → sx, sy, distance
--     x, y は地面、z は高さ。上は z が小さい（頭は足元の z から高さを引く）。
-- 引数の順番を当てずっぽうで試さない。名前位置の API に世界座標を渡さない。

-- プレイヤーのジョブ・レベル・所属国・ランク（0.1.65〜、公式 vana.game.player）。読めなければ nil
-- 説明書（04-game-data）：main_job / main_job_level / nation（0 サンドリア 1 バストゥーク 2 ウィンダス）/ rank / rank_points
function ext.player_status()
    local v = V()
    if not v or type(v.game) ~= 'table' or type(v.game.player) ~= 'function' then return nil end
    local ok, p = pcall(v.game.player)
    if not ok or type(p) ~= 'table' then return nil end
    local function num(k)
        local ok2, x = pcall(function () return p[k] end)
        return ok2 and tonumber(x) or nil
    end
    return {
        main_job = num('main_job'), main_job_level = num('main_job_level'),
        sub_job = num('sub_job'), sub_job_level = num('sub_job_level'),
        nation = num('nation'), rank = num('rank'), rank_points = num('rank_points'),
        source = 'vana.game.player',
    }
end

-- 今のミッション（0.1.169〜、公式 vana.game.missions。説明書 04-game-data）。サーバーから届く前は nil。
-- 値はサーバーの数え方のまま（adoulin・rhapsodies は 0x056 と同じ生の値）。
function ext.missions()
    local v = V()
    if not v or type(v.game) ~= 'table' or type(v.game.missions) ~= 'function' then return nil end
    local ok, m = pcall(v.game.missions)
    if not ok or type(m) ~= 'table' then return nil end
    local function num(k)
        local ok2, x = pcall(function () return m[k] end)
        return ok2 and tonumber(x) or nil
    end
    return {
        nation = num('nation'), nation_mission = num('nation_mission'), zilart = num('zilart'),
        cop = num('promathia'), soa_raw = num('adoulin'), rov_raw = num('rhapsodies'),
        acp = num('crystalline_prophecy'), amk = num('moogle_kupo_detat'), asa = num('shantotto_ascension'),
        declined = num('declined'), source = 'vana.game.missions',
    }
end

function ext.ui_screen()
    local v = V()
    if not v or type(v.ui) ~= 'table' or type(v.ui.screen) ~= 'function' then
        return nil
    end
    local ok, w, h = pcall(v.ui.screen)
    w, h = tonumber(w), tonumber(h)
    if ok and w and h and w > 0 and h > 0 then
        return w, h
    end
    return nil
end

function ext.entity_screen(index)
    index = tonumber(index)
    if not index then return nil end
    local v = V()
    if not v then return nil end

    local world = v.world
    if type(world) == 'table' and type(world.name_at) == 'function' then
        -- 公式どおり、引数はエンティティの index だけ。
        local ok, x, top, bottom = pcall(world.name_at, index)
        x, top = tonumber(x), tonumber(top)
        if ok and x and top then
            return x, top, 'name_at', tonumber(bottom)
        end
    end

    -- name_at が無い・nil のとき、同じ値をエンティティから読む（関数呼び出し）。
    local game = v.game
    if type(game) == 'table' and type(game.entity) == 'function' then
        local ok, e = pcall(game.entity, index)
        if ok and type(e) == 'table' then
            local x, top = tonumber(e.name_x), tonumber(e.name_top)
            if x and top then
                return x, top, 'name_x', tonumber(e.name_bottom)
            end
        end
    end
    return nil
end

function ext.world_screen(x, y, z)
    x, y, z = tonumber(x), tonumber(y), tonumber(z)
    if x == nil or y == nil or z == nil then return nil end
    local v = V()
    if not v or type(v.world) ~= 'table' or type(v.world.to_screen) ~= 'function' then
        return nil
    end
    -- 公式どおり (x, y, z)。name_at は呼ばない。
    local ok, sx, sy, dist = pcall(v.world.to_screen, x, y, z)
    sx, sy = tonumber(sx), tonumber(sy)
    if ok and sx and sy then
        return sx, sy, 'to_screen', tonumber(dist)
    end
    return nil
end

-- ズームに合わせた位置（試し）：こちらで足す px（名前との隙間・重ねる段・??? の積み・設定の位置調整）に、
-- 名前（または点）の縮み具合 f を掛ける。箱そのものは VanaCore が距離で縮めるので、隙間も同じ比率にそろえる。
--   名前に付ける相手：名前の高さ（name_at の bottom - top）÷ この読み込み中に見た一番高い名前（近いときの大きさ）
--   ??? など点に置く相手：place に渡す distance（16）÷ to_screen の距離（16 より近ければ 1）
-- 名前の f は 0.3〜1（設定より広げない）。点の f は 0.1〜4（箱と同じく近いと広がる）。オフ、または測れないときは 1（これまでどおり）。
ext.ZOOM_MIN, ext.ZOOM_MAX = 0.3, 1.0
-- 点に置く箱は VanaCore が distance=16 で「16 ÷ 距離」に拡大・縮小する（近いと 1 より大きくなる）。
-- 0.1.38 のスクショで、近い・中・遠いの箱の大きさが 約 3.0・1.4・0.75 倍（印 28px 基準）、
-- こちらの間隔は 1・1・0.8 で、近いと重なり、遠いと離れていた。間隔も箱と同じ比率にそろえる。
ext.PLACE_ZOOM_MIN, ext.PLACE_ZOOM_MAX = 0.1, 4.0
ext.PLACE_REF_DISTANCE = 16
local zoom_ref_h = nil
local zoom_last = { name = nil, place = nil }

local function clamp_zoom(f)
    if f ~= f or f == nil then return 1 end
    if f < ext.ZOOM_MIN then return ext.ZOOM_MIN end
    if f > ext.ZOOM_MAX then return ext.ZOOM_MAX end
    return f
end

-- 名前の高さから。戻り値: f, 名前の高さ, 基準の高さ（測れなければ nil）
function ext.name_zoom(index)
    local _, top, _, bottom = ext.entity_screen(index)
    top, bottom = tonumber(top), tonumber(bottom)
    if not top or not bottom then return nil end
    local h = bottom - top
    if h <= 1 then return nil end
    if not zoom_ref_h or h > zoom_ref_h then zoom_ref_h = h end
    return clamp_zoom(h / zoom_ref_h), h, zoom_ref_h
end

-- 点の距離から。戻り値: f, 距離
function ext.place_zoom(x, y, z)
    local _, _, _, d = ext.world_screen(x, y, z)
    d = tonumber(d)
    if not d or d <= 0 then return nil end
    local f = ext.PLACE_REF_DISTANCE / d
    if f < ext.PLACE_ZOOM_MIN then f = ext.PLACE_ZOOM_MIN elseif f > ext.PLACE_ZOOM_MAX then f = ext.PLACE_ZOOM_MAX end
    return f, d
end

function ext._reset_zoom() zoom_ref_h = nil; zoom_last = { name = nil, place = nil } end
function ext.zoom_last() return zoom_last end


-- 名前に印を付ける（公式 vana.world.attach）。
-- 箱は名前と同じ描画パスに乗るので、カメラを動かしても名前と一緒に動く。
-- 地面の光の輪（vana.world.marks）は使わない。

local addon_dir = nil
local last_kind = nil
local last_place_kind = nil
local last_place_err = nil
local slots = {} -- { box, index, role, attached, keep }  名前に付ける
local world_slots = {} -- { box, key, role, placed, keep }  本体の位置に置く
local BOX_W, BOX_H = 28, 28 -- 設定のアイコンの大きさ（px）で変わる

local ROLE_FILE = {
    talk = 'talk.png',
    hunt = 'hunt.png',
    examine = 'examine.png',
    guard = 'guard.png',
    ['repeat'] = 'repeat.png',
    -- クエストの状態のアイコン（0.1.63〜、自作の絵）
    main = 'main.png',
    sub = 'sub.png',
    unavailable = 'unavailable.png',
    progress = 'progress.png',
    blocked = 'blocked.png',
    complete = 'complete.png',
    fame = 'fame.png',   -- 名声を教えてくれる人（0.1.69〜、自作の絵）
}

function ext.set_addon_dir(dir)
    if type(dir) == 'string' and dir ~= '' then
        addon_dir = dir
    end
end

function ext.attach_available()
    local v = V()
    if not v then return false end
    if type(v.world) ~= 'table' or type(v.world.attach) ~= 'function' then return false end
    if type(v.ui) ~= 'table' then return false end
    -- 公式の箱は vana.ui.image / vana.ui.rect / vana.ui.text（picture という名前ではない）
    if type(v.ui.image) == 'function' or type(v.ui.rect) == 'function' then
        return true
    end
    return false
end

--[[ アイコンの差し替え（0.1.185〜、t301）
  assets/marks/<名前>.png（自分の絵）があればそれを、無ければ assets/marks/example/<名前>.png（同梱）を使う。
  更新の zip は example/ と README.txt だけを入れるので、自分の絵は上書きされない。
  0.1.184 までは同梱の絵を assets/marks/ に直接置いていた。そのまま残った古い同梱の絵（大きさと Adler-32 が同じもの）は
  自分の絵とみなさない（example を使う）。 ]]
ext.LEGACY_MARKS = {
    ['blocked.png'] = { 6038, 1763959882 }, ['complete.png'] = { 6914, 1885749794 },
    ['examine.png'] = { 1098, 2259484825 }, ['fame.png'] = { 4565, 1134921073 },
    ['guard.png'] = { 3148, 2619221342 }, ['hunt.png'] = { 4052, 2253377771 },
    ['main.png'] = { 4560, 3875730636 }, ['progress.png'] = { 6377, 963856230 },
    ['repeat.png'] = { 7600, 3575885646 }, ['sub.png'] = { 6312, 2521044110 },
    ['talk.png'] = { 6293, 2857235106 }, ['unavailable.png'] = { 6393, 2838905319 },
}

local function adler32(b)
    local a, c = 1, 0
    for i = 1, #b do
        a = (a + b:byte(i)) % 65521
        c = (c + a) % 65521
    end
    return c * 65536 + a
end
ext._adler32 = adler32

local function dir_with_sep(dir)
    if type(dir) ~= 'string' or dir == '' then return nil, '/' end
    local last = dir:sub(-1)
    if last == '/' or last == '\\' then return dir, last end
    local sep = dir:find('\\') and '\\' or '/'
    return dir .. sep, sep
end

local mark_pick = {}   -- 名前 → 'user' | 'example'（読み込み直すまで覚える）
function ext.reset_mark_files() mark_pick = {} end

-- 自分の絵か。無い・読めない・古い同梱の絵なら false
local function user_mark(path, name)
    local ok, f = pcall(io.open, path, 'rb')
    if not ok or not f then return false end
    local okr, b = pcall(f.read, f, '*a')
    pcall(f.close, f)
    if not okr or type(b) ~= 'string' or #b == 0 then return false end
    local lg = ext.LEGACY_MARKS[name]
    if lg and #b == lg[1] and adler32(b) == lg[2] then return false end
    return true
end

local function mark_file(role)
    local name = ROLE_FILE[role] or ROLE_FILE.talk
    local dir, sep = dir_with_sep(addon_dir)
    local base = (dir or '') .. 'assets' .. sep .. 'marks' .. sep
    local pick = mark_pick[name]
    if pick == nil then
        pick = user_mark(base .. name, name) and 'user' or 'example'
        mark_pick[name] = pick
    end
    if pick == 'user' then return base .. name end
    return base .. 'example' .. sep .. name
end

-- どちらを使っているか（設定の表示・試験用）
function ext.mark_source(role)
    mark_file(role)
    return mark_pick[ROLE_FILE[role] or ROLE_FILE.talk]
end

-- 試験からも見る（パスの組み立て）
function ext.mark_file(role)
    return mark_file(role)
end

-- 公式の箱は userdata のことがある。table かどうかで断らない。
local function box_set(box, props)
    if box == nil or type(props) ~= 'table' then return end
    local ok = pcall(function ()
        box:set(props)
    end)
    if ok then return end
    for k, val in pairs(props) do
        pcall(function ()
            box[k] = val
        end)
    end
end

-- 箱ごとの「今出しているか」（0.1.210〜）。同じなら毎フレーム出し直さない
local box_shown = setmetatable({}, { __mode = 'k' })
local function same_c(a, b)
    if a == b then return true end
    if type(a) ~= 'table' or type(b) ~= 'table' then return false end
    return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
end
local function box_show(box, on)
    if box == nil then return end
    on = on and true or false
    if box_shown[box] == on then return end
    box_shown[box] = on
    box_set(box, { visible = on and true or false })
    pcall(function ()
        box.visible = on and true or false
    end)
    if on then
        pcall(function ()
            if box.show then box:show() end
        end)
    else
        pcall(function ()
            if box.hide then box:hide() end
        end)
    end
end

local ROLE_COLOR = {
    talk = '#B8B2FFFF',
    hunt = '#FF998CFF',
    examine = '#9ECCFFFF',
    guard = '#FAD480FF',
    ['repeat'] = '#94D1A3FF',
    main = '#FAC238FF',
    sub = '#FFDB5CFF',
    unavailable = '#E64742FF',
    progress = '#6BBDFFFF',
    blocked = '#E64742FF',
    complete = '#5CD675FF',
    fame = '#DB5CD6FF',
}

local ROLE_GLYPH = {
    talk = '●',
    hunt = '▲',
    examine = '■',
    guard = '◆',
    ['repeat'] = '◎',
    main = '◆',
    sub = '!',
    unavailable = '!',
    progress = '▶',
    blocked = '‖',
    complete = '✓',
    fame = '★',
}

local function rect_radius(role)
    if role == 'examine' then return 2 end
    return BOX_H / 2
end

-- この版では用意した PNG を先に試す（公式 vana.ui.image）。
-- 画像が作れないときだけ、色付きの丸／四角、その次に文字の印へ戻す。
local function make_image_box(role)
    local v = V()
    if not v or type(v.ui) ~= 'table' or type(v.ui.image) ~= 'function' then
        return nil
    end
    local full = mark_file(role)
    local files = {}
    if type(full) == 'string' and full ~= '' then
        files[#files + 1] = full
        local fwd = full:gsub('\\', '/')
        if fwd ~= full then
            files[#files + 1] = fwd
        end
    end
    -- アドオンのフォルダからの相対（同じ側：自分の絵か example）
    local name = ROLE_FILE[role] or ROLE_FILE.talk
    files[#files + 1] = (ext.mark_source(role) == 'user') and ('assets/marks/' .. name) or ('assets/marks/example/' .. name)
    local seen = {}
    for _, file in ipairs(files) do
        if file and file ~= '' and not seen[file] then
            seen[file] = true
            local ok, box = pcall(v.ui.image, {
                file = file,
                width = BOX_W,
                height = BOX_H,
                visible = true,
            })
            if ok and box ~= nil then
                return box
            end
        end
    end
    return nil
end

local function make_rect_box(role)
    local v = V()
    if not v or type(v.ui) ~= 'table' or type(v.ui.rect) ~= 'function' then
        return nil
    end
    local ok, box = pcall(v.ui.rect, {
        width = BOX_W,
        height = BOX_H,
        radius = rect_radius(role),
        color = ROLE_COLOR[role] or ROLE_COLOR.talk,
        visible = true,
    })
    if ok and box ~= nil then return box end
    return nil
end

local function make_glyph_box(role)
    local v = V()
    if not v or type(v.ui) ~= 'table' or type(v.ui.text) ~= 'function' then
        return nil
    end
    local ok, box = pcall(v.ui.text, {
        text = ROLE_GLYPH[role] or '●',
        size = math.floor(BOX_H * 0.8 + 0.5),
        color = ROLE_COLOR[role] or ROLE_COLOR.talk,
        background = '#00000000',
        visible = true,
    })
    if ok and box ~= nil then return box end
    return nil
end

local function make_box(role)
    local box = make_image_box(role)
    if box then return box, 'image' end
    box = make_rect_box(role)
    if box then return box, 'rect' end
    box = make_glyph_box(role)
    if box then return box, 'text' end
    return nil, nil
end

-- 頭上のクエスト名は、本やトラッカーと同じフォントにする。
-- メニューは ImGui で、クライアントの [client] imgui.font（ファイル名）を使う。
-- 公式の文字の箱（vana.ui.text）の font はフォント名なので、そのファイルの家族名を渡す。
-- 指定が無いときだけ、以前の Windows のフォント名へ戻す。
local LABEL_FONTS = {
    'Yu Gothic UI', 'Yu Gothic', 'Meiryo UI', 'Meiryo', 'MS UI Gothic',
}

local install_dir = nil
local menu_font_cache = nil
local menu_font_setting_cache = false

function ext.set_install_dir(dir)
    if type(dir) == 'string' and dir ~= '' then
        install_dir = dir
    else
        install_dir = nil
    end
    menu_font_cache = nil
    menu_font_setting_cache = false
end

function ext.clear_menu_font_cache()
    menu_font_cache = nil
    menu_font_setting_cache = false
end

local function path_sep(p)
    if type(p) == 'string' and p:find('\\', 1, true) then return '\\' end
    return '/'
end

local function path_join(dir, part)
    if type(dir) ~= 'string' or dir == '' then return part end
    local sep = path_sep(dir)
    local last = dir:sub(-1)
    if last == '/' or last == '\\' then
        return dir .. part
    end
    return dir .. sep .. part
end

local function path_parent(p, n)
    p = tostring(p or '')
    n = n or 1
    for _ = 1, n do
        p = p:gsub('[/\\]+$', '')
        local parent = p:match('^(.*)[/\\][^/\\]+$')
        if not parent or parent == '' then return p end
        p = parent
    end
    return p
end

local function file_exists(p)
    if type(p) ~= 'string' or p == '' then return false end
    local f = io.open(p, 'rb')
    if not f then return false end
    f:close()
    return true
end

local function read_all(p)
    if type(p) ~= 'string' or p == '' then return nil end
    local f = io.open(p, 'rb')
    if not f then return nil end
    local s = f:read('*a')
    f:close()
    if type(s) == 'string' then return s end
    return nil
end

local function resolve_install_dir()
    if type(install_dir) == 'string' and install_dir ~= '' then
        return install_dir
    end
    local ok, p = pcall(function ()
        return AshitaCore:GetInstallPath()
    end)
    if ok and type(p) == 'string' and p ~= '' then
        return p
    end
    -- addon_dir は Vanacore\addons\vanacore\astertrail
    if type(addon_dir) == 'string' and addon_dir ~= '' then
        return path_parent(addon_dir, 3)
    end
    return nil
end

-- vanacore.ini の [client] imgui.font。テストからも見る。
function ext.parse_imgui_font(ini)
    if type(ini) ~= 'string' or ini == '' then return nil end
    if ini:sub(1, 3) == '\239\187\191' then
        ini = ini:sub(4)
    end
    -- UTF-16 LE のとき、ASCII 範囲だけ取り出して読む
    if ini:sub(1, 2) == '\255\254' then
        local bytes = {}
        local i = 3
        while i <= #ini do
            local lo, hi = ini:byte(i, i + 1)
            if not lo then break end
            hi = hi or 0
            if hi == 0 and lo < 128 then
                bytes[#bytes + 1] = string.char(lo)
            elseif lo == 0 and hi == 0 then
                bytes[#bytes + 1] = '\n'
            end
            i = i + 2
        end
        ini = table.concat(bytes)
    end
    local section = ''
    for line in ini:gmatch('([^\r\n]+)') do
        line = line:match('^%s*(.-)%s*$') or ''
        local first = line:sub(1, 1)
        if line ~= '' and first ~= ';' and first ~= '#' then
            local sec = line:match('^%[(.-)%]$')
            if sec then
                section = string.lower(sec)
            else
                local k, v = line:match('^([^=]+)=(.*)$')
                if k and v and section == 'client' then
                    k = string.lower((k:match('^%s*(.-)%s*$') or ''))
                    v = v:match('^%s*(.-)%s*$') or ''
                    v = v:gsub('^"(.*)"$', '%1')
                    v = v:gsub("^'(.*)'$", '%1')
                    if k == 'imgui.font' and v ~= '' then
                        return v
                    end
                end
            end
        end
    end
    return nil
end

local function u16(s, i)
    local a, b = s:byte(i, i + 1)
    if not a or not b then return nil end
    return a * 256 + b
end

local function u32(s, i)
    local a, b, c, d = s:byte(i, i + 3)
    if not d then return nil end
    return ((a * 256 + b) * 256 + c) * 256 + d
end

local function utf8_char(cp)
    if cp < 0x80 then return string.char(cp) end
    if cp < 0x800 then
        return string.char(0xC0 + math.floor(cp / 0x40), 0x80 + (cp % 0x40))
    end
    if cp < 0x10000 then
        return string.char(
            0xE0 + math.floor(cp / 0x1000),
            0x80 + (math.floor(cp / 0x40) % 0x40),
            0x80 + (cp % 0x40)
        )
    end
    return string.char(
        0xF0 + math.floor(cp / 0x40000),
        0x80 + (math.floor(cp / 0x1000) % 0x40),
        0x80 + (math.floor(cp / 0x40) % 0x40),
        0x80 + (cp % 0x40)
    )
end

local function utf16be_to_utf8(s)
    if type(s) ~= 'string' or s == '' then return nil end
    local out = {}
    local i = 1
    while i < #s do
        local cp = u16(s, i)
        if not cp then break end
        i = i + 2
        if cp >= 0xD800 and cp <= 0xDBFF and i < #s then
            local low = u16(s, i)
            if low and low >= 0xDC00 and low <= 0xDFFF then
                cp = 0x10000 + (cp - 0xD800) * 0x400 + (low - 0xDC00)
                i = i + 2
            end
        elseif cp >= 0xDC00 and cp <= 0xDFFF then
            -- 単独の下位サロゲートは飛ばす
            cp = nil
        end
        if cp and cp ~= 0 then
            out[#out + 1] = utf8_char(cp)
        end
    end
    local t = table.concat(out)
    if t == '' then return nil end
    return t
end

local function macroman_to_utf8(s)
    if type(s) ~= 'string' or s == '' then return nil end
    for i = 1, #s do
        if s:byte(i) >= 128 then return nil end
    end
    return s
end

local function add_name(list, seen, s)
    if type(s) ~= 'string' then return end
    s = s:match('^%s*(.-)%s*$') or ''
    if s == '' or seen[s] then return end
    seen[s] = true
    list[#list + 1] = s
end

-- フォントファイル（TTF / OTF / TTC）の家族名。テストからも見る。
function ext.font_family_names(path)
    local data = read_all(path)
    if not data or #data < 16 then return {} end
    local font_off = 0
    local magic = data:sub(1, 4)
    if magic == 'ttcf' then
        local first = u32(data, 13)
        if not first then return {} end
        font_off = first
    end
    local base = font_off + 1
    if base + 12 > #data then return {} end
    local ntab = u16(data, base + 4)
    if not ntab or ntab <= 0 or ntab > 80 then return {} end
    local name_off, name_len
    for i = 0, ntab - 1 do
        local rec = base + 12 + i * 16
        local tag = data:sub(rec, rec + 3)
        if tag == 'name' then
            name_off = u32(data, rec + 8)
            name_len = u32(data, rec + 12)
            break
        end
    end
    if not name_off or not name_len or name_len < 6 then return {} end
    local name = data:sub(name_off + 1, name_off + name_len)
    if #name < 6 then return {} end
    local count = u16(name, 3)
    local str_off = u16(name, 5)
    if not count or not str_off or count > 200 then return {} end
    -- nameID 16（タイポグラフィの家族名）を先に、その次が 1（家族名）
    local buckets = { [16] = {}, [1] = {} }
    local seen = { [16] = {}, [1] = {} }
    for i = 0, count - 1 do
        local r = 7 + i * 12
        local platform = u16(name, r)
        local encoding = u16(name, r + 2)
        local language = u16(name, r + 4)
        local name_id = u16(name, r + 6)
        local length = u16(name, r + 8)
        local off = u16(name, r + 10)
        if (name_id == 1 or name_id == 16) and length and off and length > 0 then
            local start = str_off + 1 + off
            local raw = name:sub(start, start + length - 1)
            local decoded
            if platform == 3 or platform == 0 then
                decoded = utf16be_to_utf8(raw)
            elseif platform == 1 then
                decoded = macroman_to_utf8(raw)
            end
            if decoded then
                -- 英語を先、日本語、そのほか
                local rank = 3
                if language == 0x0409 or language == 0 or language == 0x0000 then
                    rank = 1
                elseif language == 0x0411 then
                    rank = 2
                end
                add_name(buckets[name_id], seen[name_id], decoded)
                -- 順序：英語を先にするために、あとで並べ直すのではなく、
                -- 取り出し時に rank 付きで入れる
                -- 上の add_name は出現順。record の順は決まっていないので rank で貯める
                seen[name_id][decoded] = rank
            end
        end
    end
    local function ordered(id)
        local items = {}
        for s, _ in pairs(seen[id]) do
            if type(seen[id][s]) == 'number' then
                items[#items + 1] = { s = s, r = seen[id][s] }
            end
        end
        table.sort(items, function (a, b)
            if a.r ~= b.r then return a.r < b.r end
            return a.s < b.s
        end)
        local out = {}
        for _, it in ipairs(items) do
            out[#out + 1] = it.s
        end
        return out
    end
    local list, have = {}, {}
    for _, s in ipairs(ordered(16)) do
        add_name(list, have, s)
    end
    for _, s in ipairs(ordered(1)) do
        add_name(list, have, s)
    end
    return list
end

local function file_stem(name)
    if type(name) ~= 'string' then return nil end
    name = name:gsub('^.*[/\\]', '')
    name = name:match('^(.*)%.[^%.]+$') or name
    if name == '' then return nil end
    return name
end

local function resolve_font_file(root, setting)
    if type(setting) ~= 'string' or setting == '' then return nil end
    -- 絶対パス（Windows の C:\ や \\、POSIX の /）
    local abs = setting
    if abs:match('^%a:[/\\]') or abs:sub(1, 1) == '/' or abs:sub(1, 2) == '\\\\' then
        if file_exists(abs) then return abs end
    end
    local names = { setting }
    if not setting:lower():match('%.%a+$') then
        names[#names + 1] = setting .. '.ttf'
        names[#names + 1] = setting .. '.otf'
        names[#names + 1] = setting .. '.ttc'
    end
    local dirs = {}
    if type(root) == 'string' and root ~= '' then
        dirs[#dirs + 1] = path_join(root, 'fonts')
        dirs[#dirs + 1] = path_join(path_join(root, 'fonts'), 'imgui')
    end
    local windir = os.getenv('WINDIR') or os.getenv('SystemRoot')
    if type(windir) == 'string' and windir ~= '' then
        dirs[#dirs + 1] = path_join(windir, 'Fonts')
    end
    local localapp = os.getenv('LOCALAPPDATA')
    if type(localapp) == 'string' and localapp ~= '' then
        dirs[#dirs + 1] = path_join(path_join(path_join(localapp, 'Microsoft'), 'Windows'), 'Fonts')
    end
    for _, d in ipairs(dirs) do
        for _, n in ipairs(names) do
            -- n が fonts\foo.ttf のような相対のとき
            local p
            if n:find('[/\\]') then
                p = path_join(root, n)
                if file_exists(p) then return p end
            end
            p = path_join(d, n:gsub('^.*[/\\]', ''))
            if file_exists(p) then return p end
        end
    end
    return nil
end

-- メニューのフォント設定（[client] imgui.font）。
-- 実機では vanacore.ini ではなく vanacore.<id>.ini にあることがあるので、
-- 公式の vana.config.get を先に使う。ファイルを読むのは、それが無いときだけ。

local function setting_from_config()
    local v = V()
    if not v or type(v.config) ~= 'table' or type(v.config.get) ~= 'function' then
        return nil
    end
    local ok, val = pcall(function ()
        return v.config.get('client', 'imgui.font')
    end)
    if not ok or type(val) ~= 'string' then return nil end
    val = val:match('^%s*(.-)%s*$') or ''
    if val == '' then return nil end
    return val
end

local function ini_file_names(root)
    local names = { 'vanacore.ini' }
    local v = V()
    local list
    if v and type(v.fs) == 'table' and type(v.fs.list) == 'function' then
        local ok, got = pcall(v.fs.list, root)
        if ok then list = got end
    end
    if type(list) ~= 'table' then return names end
    -- list はファイル名の配列、または { name = ... } の配列
    local function consider(name)
        if type(name) ~= 'string' then return end
        name = name:gsub('^.*[/\\]', '')
        local lower = string.lower(name)
        if lower:match('^vanacore%.[0-9a-f]+%.ini$') then
            names[#names + 1] = name
        end
    end
    for i = 1, #list do
        local item = list[i]
        if type(item) == 'string' then
            consider(item)
        elseif type(item) == 'table' then
            consider(item.name or item.file or item[1])
        end
    end
    -- pairs だけの連想配列にも対応
    if #list == 0 then
        for k, item in pairs(list) do
            if type(k) == 'string' then consider(k) end
            if type(item) == 'string' then consider(item) end
        end
    end
    return names
end

local function setting_from_files(root)
    if type(root) ~= 'string' or root == '' then return nil end
    for _, name in ipairs(ini_file_names(root)) do
        local s = ext.parse_imgui_font(read_all(path_join(root, name)))
        if s then return s end
    end
    return nil
end

function ext.menu_font_setting()
    ext.menu_font_names()
    if menu_font_setting_cache == false then return nil end
    return menu_font_setting_cache
end

-- メニューと同じフォントの名前（家族名、その次にファイル名）。見つからなければ空。
function ext.menu_font_names()
    if menu_font_cache then return menu_font_cache end
    local names, seen = {}, {}
    local root = resolve_install_dir()
    local setting = setting_from_config() or setting_from_files(root)
    menu_font_setting_cache = setting or nil
    if setting then
        local file = resolve_font_file(root, setting)
        if file then
            for _, s in ipairs(ext.font_family_names(file)) do
                add_name(names, seen, s)
            end
        end
        add_name(names, seen, file_stem(setting))
    end
    menu_font_cache = names
    return names
end

local function make_label_box(text)
    local v = V()
    if not v or type(v.ui) ~= 'table' or type(v.ui.text) ~= 'function' then
        return nil
    end
    text = text or ''
    local function try(props)
        local ok, box = pcall(v.ui.text, props)
        if ok and box ~= nil then return box end
        return nil
    end
    local bases = {
        { text = text, size = 16, color = '#F8F4E8FF', background = '#000000CC', outline = true, color_codes = true, visible = true },
        { text = text, size = 16, color = '#F8F4E8FF', background = '#000000CC', visible = true },
        { text = text, size = 16, color = '#F8F4E8FF', visible = true },
    }
    local fonts = {}
    local seen = {}
    for _, f in ipairs(ext.menu_font_names()) do
        add_name(fonts, seen, f)
    end
    -- メニューのフォントが取れないときだけ、以前の指定へ戻す
    if #fonts == 0 then
        for _, f in ipairs(LABEL_FONTS) do
            add_name(fonts, seen, f)
        end
    end
    for _, font in ipairs(fonts) do
        for _, b in ipairs(bases) do
            local props = {}
            for k, val in pairs(b) do props[k] = val end
            props.font = font
            local box = try(props)
            if box then return box, b.color_codes == true end
        end
    end
    for _, b in ipairs(bases) do
        local box = try(b)
        if box then return box, b.color_codes == true end
    end
    return nil
end

-- 文字の色（設定の色、0〜255 の {r, g, b}）。無ければ今までの色
local LABEL_RGB = { 248, 244, 232 }
local function rgb_of(c)
    if type(c) ~= 'table' then return nil end
    local out = {}
    for i = 1, 3 do
        local v = math.floor((tonumber(c[i]) or -1) + 0.5)
        if v < 0 or v > 255 then return nil end
        out[i] = v
    end
    return out
end
local function hex_of(c)
    c = rgb_of(c) or LABEL_RGB
    return string.format('#%02X%02X%02XFF', c[1], c[2], c[3])
end
ext.hex_of = hex_of

-- 左から右へのグラデーション：一文字ずつ色の印（\cs(r,g,b)）を付ける。空白には付けない
function ext.gradient_text(text, c1, c2)
    text = tostring(text or '')
    c1, c2 = rgb_of(c1) or LABEL_RGB, rgb_of(c2)
    if not c2 then return text end
    local chars = {}
    for ch in text:gmatch('[%z\1-\127\194-\244][\128-\191]*') do chars[#chars + 1] = ch end
    local n = #chars
    if n == 0 then return text end
    local out = {}
    for i, ch in ipairs(chars) do
        if ch == ' ' then
            out[#out + 1] = ch
        else
            local t = (n == 1) and 0 or (i - 1) / (n - 1)
            local r = math.floor(c1[1] + (c2[1] - c1[1]) * t + 0.5)
            local g = math.floor(c1[2] + (c2[2] - c1[2]) * t + 0.5)
            local b = math.floor(c1[3] + (c2[3] - c1[3]) * t + 0.5)
            out[#out + 1] = string.format('\\cs(%d,%d,%d)', r, g, b) .. ch
        end
    end
    out[#out + 1] = '\\cr'
    return table.concat(out)
end

-- 頭上の文字の背景（0.1.215〜）。初期 0.8 は今までの #000000CC
local LABEL_BG_DEFAULT = 0.8
local function bg_hex(alpha)
    alpha = tonumber(alpha)
    if alpha == nil then alpha = LABEL_BG_DEFAULT end
    if alpha < 0 then alpha = 0 elseif alpha > 1 then alpha = 1 end
    local a = math.floor(alpha * 255 + 0.5)
    if a < 0 then a = 0 elseif a > 255 then a = 255 end
    return string.format('#000000%02X', a)
end
ext._bg_hex = bg_hex

-- 文字の箱に文と色を入れる。グラデーションは色の印が使える箱だけ（使えなければ始めの色だけ）
-- bg_alpha があれば背景の濃さも入れる（無いときは今までの箱の背景のまま）
local function label_props(slot, text, c1, c2, bg_alpha)
    local props = { text = text, color = hex_of(c1) }
    if c2 and slot and slot.codes then
        props.text = ext.gradient_text(text, c1, c2)
        props.color = '#FFFFFFFF'
    end
    if bg_alpha ~= nil then
        props.background = bg_hex(bg_alpha)
    end
    return props
end
ext._label_props = label_props

local function apply_label_text(slot, text, c1, c2, bg_alpha)
    if bg_alpha == nil then bg_alpha = LABEL_BG_DEFAULT end
    if slot._lbl ~= text or not same_c(slot._c1, c1) or not same_c(slot._c2, c2) or slot._bg ~= bg_alpha then
        box_set(slot.box, label_props(slot, text, c1, c2, bg_alpha))
        slot._lbl, slot._c1, slot._c2, slot._bg = text, c1, c2, bg_alpha
    end
end

-- 印は PNG（または色付きの箱）のまま。クエスト名と対象の名前は別の文字の箱。
-- 公式に画像と文字を一つにする入れ物は無いので、箱は分け、位置で重ねないようにする。
-- 話す相手：印は名前の横（左）、クエスト名はその上。
-- 調べる対象（0.1.45〜）：対象の名前（???など）の左横に印を並べた行、その上にクエスト名。
--   クエスト名を出さない設定なら、印と名前の横並びだけ。

-- 印・クエスト名・対象名のあいだの隙間は同じ（pivot=bottom）。
local STACK_GAP = 24
-- 印と対象の名前を横に並べるときの隙間（px）
local ROW_GAP = 8

local function has_label_text(it)
    local label = it and it.label
    return type(label) == 'string' and label ~= ''
end

local function has_under_text(it)
    local under = it and it.under
    return type(under) == 'string' and under ~= ''
end

local function apply_role(slot, role)
    if not slot or not slot.box then return end
    local kind = slot.kind
    if kind == 'rect' then
        box_set(slot.box, {
            color = ROLE_COLOR[role] or ROLE_COLOR.talk,
            radius = rect_radius(role),
        })
    elseif kind == 'text' and slot.part ~= 'label' and slot.part ~= 'under' then
        box_set(slot.box, {
            text = ROLE_GLYPH[role] or '●',
            color = ROLE_COLOR[role] or ROLE_COLOR.talk,
        })
    elseif kind == 'image' then
        box_set(slot.box, { file = mark_file(role) })
    end
    slot.role = role
end

local function world()
    local v = V()
    if v and type(v.world) == 'table' then return v.world end
    return nil
end

local function estimate_text_height(box)
    local h = box and tonumber(box.height)
    if h and h > 1 then return h end
    return 18
end

-- 文字の箱の幅（px）。箱が幅を教えてくれなければ、文字数から見積もる（16px の字：英数 9、ほか 16、余白 8）
local function estimate_text_width(box, text)
    local w = box and tonumber(box.width)
    if w and w > 1 then return w end
    local n = 0
    for ch in tostring(text or ''):gmatch('[%z\1-\127\194-\244][\128-\191]*') do
        n = n + ((#ch == 1) and 9 or 16)
    end
    return n + 8
end

local function layer_of(it)
    local n = math.floor(tonumber(it and it.layer) or 0)
    if n < 0 then n = 0 end
    return n
end

-- 設定のアイコンの大きさ。変わったら、作ってある印の箱を作り直す。
local function icon_of(items)
    for _, it in ipairs(items or {}) do
        local n = tonumber(it.icon)
        if n then
            n = math.floor(n)
            if n < 16 then n = 16 elseif n > 64 then n = 64 end
            return n
        end
    end
    return nil
end

local function apply_icon_size(items)
    local n = icon_of(items)
    if not n or n == BOX_W then return end
    if ext.clear_name_marks then ext.clear_name_marks() end
    if ext.clear_world_marks then ext.clear_world_marks() end
    BOX_W, BOX_H = n, n
end

function ext.icon_size()
    return BOX_W
end

-- 話す相手：印は名前の横、クエスト名は名前の上。複数クエストはその上に重ねる。
-- 印は設定の px のまま（文字の大きさでは変えない）。クエスト名は文字の大きさに合わせる。
local function attach_opts(it, part, f)
    f = tonumber(f) or 1
    local scale = tonumber(it and it.scale) or 1
    if scale < 0.8 then scale = 0.8 elseif scale > 3.2 then scale = 3.2 end   -- 0.1.210〜：上限 320%
    local layer = layer_of(it)
    local row_h = math.max(BOX_H, 28 * scale) + 4 * scale
    local y_stack = -layer * row_h
    if part == 'label' then
        return {
            side = 'above',
            -- 設定の「クエスト名の位置」（px）
            x = (tonumber(it and it.label_dx) or 0) * f,
            y = (-2 + y_stack + (tonumber(it and it.label_dy) or 0)) * f,
            scale = scale,
            distance = true,
            walls = true,
        }
    end
    -- 公式の例：side='left', x=-4（名前の左に少し隙間）。設定の位置の調整（px）を足す。
    return {
        side = 'left',
        x = (-4 + (tonumber(it and it.mark_dx) or 0)) * f,
        y = (y_stack + (tonumber(it and it.mark_dy) or 0)) * f,
        scale = 1,
        distance = true,
        walls = true,
    }
end

local function find_slot(index, part, layer)
    layer = tonumber(layer) or 0
    for _, s in ipairs(slots) do
        if (not s.keep) and s.index == index and s.part == part and (tonumber(s.layer) or 0) == layer then
            return s
        end
    end
    for _, s in ipairs(slots) do
        if (not s.keep) and (not s.attached) and s.part == part then
            return s
        end
    end
    for _, s in ipairs(slots) do
        if (not s.keep) and s.part == part then
            return s
        end
    end
    return nil
end

local function place_box(slot, index, opts)
    local w = world()
    local ok = false
    if slot.attached and slot.index == index and w and type(w.update) == 'function' then
        -- 同じ相手に付いたままなら、置き直しではなく更新（公式の安いやり方）。
        -- 0.1.210〜：位置の指定が前と同じなら何もしない（付いた箱は相手について動く）
        local o = slot._opts
        if o and o.side == opts.side and o.x == opts.x and o.y == opts.y and o.scale == opts.scale
            and o.distance == opts.distance and o.walls == opts.walls then
            return true
        end
        ok = pcall(w.update, slot.box, opts)
        if ok then slot._opts = opts end
    elseif w and type(w.attach) == 'function' then
        ok = pcall(w.attach, slot.box, index, opts)
        if ok then
            slot.attached = true
            slot.index = index
            slot._opts = opts
        end
    end
    if ok then
        box_show(slot.box, true)
    end
    return ok
end

function ext.set_name_marks(items)
    if not ext.attach_available() then return false end
    items = items or {}
    apply_icon_size(items)
    for _, s in ipairs(slots) do
        s.keep = false
    end

    for _, it in ipairs(items) do
        local index = tonumber(it.index)
        if index then
            -- 見た目は状態のアイコン（look）を先に。無ければ役割
            local role = (it.look and ROLE_FILE[it.look] and it.look) or it.role or 'talk'
            if not ROLE_FILE[role] then role = 'talk' end
            local layer = layer_of(it)

            local f = 1
            if it.zoom_follow then
                local zf, h, ref = ext.name_zoom(index)
                if zf then f = zf; zoom_last.name = { index = index, f = zf, h = h, ref = ref } end
            end

            -- 「アイコンを表示する」がオフなら印の箱は使わない（クエスト名だけ）
            local slot = (not it.no_icon) and find_slot(index, 'mark', layer) or nil
            if not slot and not it.no_icon then
                local box, kind = make_box(role)
                if box then
                    slot = { box = box, kind = kind, part = 'mark', layer = layer, attached = false, role = role }
                    slots[#slots + 1] = slot
                end
            end
            if slot then
                if slot.role ~= role then
                    apply_role(slot, role)
                elseif slot.role == nil then
                    slot.role = role
                end
                slot.keep = true
                slot.part = 'mark'
                slot.layer = layer
                place_box(slot, index, attach_opts(it, 'mark', f))
            end

            if has_label_text(it) then
                local lslot = find_slot(index, 'label', layer)
                if not lslot then
                    local box, codes = make_label_box(it.label)
                    if box then
                        lslot = { box = box, kind = 'text', part = 'label', layer = layer, attached = false, role = role, codes = codes }
                        slots[#slots + 1] = lslot
                    end
                end
                if lslot then
                    -- 0.1.210〜：文字と色が前と同じなら設定し直さない（色の段階の文字を毎フレーム作らない）
                    apply_label_text(lslot, it.label, it.label_color, it.label_color2, it.label_bg_alpha)
                    lslot.keep = true
                    lslot.part = 'label'
                    lslot.layer = layer
                    lslot.role = role
                    lslot.label = it.label
                    place_box(lslot, index, attach_opts(it, 'label', f))
                end
            end
        end
    end

    local w = world()
    for _, s in ipairs(slots) do
        if not s.keep then
            if s.attached and w and type(w.detach) == 'function' then
                pcall(w.detach, s.box)
            end
            s.attached = false
            s.index = nil
            s._opts = nil
            if s.box then
                box_show(s.box, false)
            end
        end
    end
    local kind
    for _, s in ipairs(slots) do
        if s.keep and s.part == 'mark' and s.kind then
            kind = s.kind
            break
        end
    end
    last_kind = kind
    return true
end

function ext.attach_kind()
    return last_kind
end

function ext.clear_name_marks()
    local w = world()
    for _, s in ipairs(slots) do
        if s.attached and w and type(w.detach) == 'function' then
            pcall(w.detach, s.box)
        end
        if s.box and type(s.box.destroy) == 'function' then
            pcall(s.box.destroy, s.box)
        end
    end
    slots = {}
    last_kind = nil
end


-- 名前が出ない相手用。公式 vana.world.place(box, x, y, z, opts)。
-- 置く点は、読み込まれている本体の座標（vana.game.entity と同じ x, y, z）。
-- マス目の中央などの固定座標には置かない。地面の光の輪（vana.world.marks）は使わない。
-- 公式：上は z が小さい。up に高さを渡すと、足元からその分だけ上に出る。

function ext.place_available()
    local v = V()
    if not v then return false end
    if type(v.world) ~= 'table' or type(v.world.place) ~= 'function' then return false end
    if type(v.ui) ~= 'table' then return false end
    if type(v.ui.image) == 'function' or type(v.ui.rect) == 'function' then
        return true
    end
    return false
end

function ext.game_entity(index)
    index = tonumber(index)
    if not index then return nil end
    local v = V()
    if not v or type(v.game) ~= 'table' or type(v.game.entity) ~= 'function' then
        return nil
    end
    local ok, e = pcall(v.game.entity, index)
    if ok and type(e) == 'table' then return e end
    return nil
end

function ext.entity_count()
    local v = V()
    if not v or type(v.game) ~= 'table' or type(v.game.entity_count) ~= 'function' then
        return nil
    end
    local ok, n = pcall(v.game.entity_count)
    n = tonumber(n)
    if ok and n and n > 0 then return n end
    return nil
end

-- 公式 vana.game.world() の weather（天候の番号）。読めなければ nil。
function ext.game_weather()
    local v = V()
    if not v or type(v.game) ~= 'table' or type(v.game.world) ~= 'function' then
        return nil
    end
    local ok, w = pcall(v.game.world)
    if not ok or type(w) ~= 'table' then return nil end
    local n = tonumber(w.weather)
    if n and n >= 0 and n <= 19 then return math.floor(n) end
    return nil
end

-- 公式 vana.game.target()。index が 0、または active が false ならターゲットなし。
function ext.game_target()
    local v = V()
    if not v or type(v.game) ~= 'table' or type(v.game.target) ~= 'function' then
        return nil
    end
    local ok, t = pcall(v.game.target)
    if ok and type(t) == 'table' then return t end
    return nil
end

-- 調べる対象：対象の名前の左横に印（同じ行）、その上にクエスト名。y は下向き（負で上へ）。
-- pivot=bottom なので、各箱の下端がこの y（横は真ん中）。複数クエストは上に重ねる（??? は一番下の1つだけ）。
-- under_width は対象の名前の箱の幅（px、文字の倍率込み）。
local function world_place_opts(it, up, part, label_height, under_height, f, under_width)
    f = tonumber(f) or 1
    local scale = tonumber(it and it.scale) or 1
    if scale < 0.8 then scale = 0.8 elseif scale > 3.2 then scale = 3.2 end   -- 0.1.210〜：上限 320%
    local label_h = 0
    if has_label_text(it) then
        label_h = tonumber(label_height) or 0
        if label_h <= 1 then label_h = 18 end
    end
    local under_h = 0
    if has_under_text(it) then
        under_h = tonumber(under_height) or 0
        if under_h <= 1 then under_h = 18 end
    end
    local x, y = 0, 0
    if has_under_text(it) then
        -- 印と名前の行（真ん中が本体の上）。行の高さは高いほうに合わせ、低いほうを縦の真ん中へ
        local uw = tonumber(under_width) or 0
        if uw <= 1 then uw = 35 end
        local row_h = math.max(BOX_H, under_h)
        local total = BOX_W + ROW_GAP + uw
        -- 名前だけ（近くのオブジェクト）：アイコンの分を空けず、名前を真ん中に
        -- アイコンを出さないとき（名前だけ・アイコンを表示しない）は、アイコンの分を空けない
        if it and (it.name_only or it.no_icon) then total = uw; row_h = under_h end
        if part == 'mark' then
            x = -total / 2 + BOX_W / 2
            y = -(row_h - BOX_H) / 2
        elseif part == 'under' then
            x = total / 2 - uw / 2
            y = -(row_h - under_h) / 2
        else
            y = -(row_h + STACK_GAP)
        end
    else
        if part == 'mark' and has_label_text(it) then
            -- 印の下にクエスト名（名前の無い上の層など）
            y = -(label_h + STACK_GAP)
        end
    end
    local layer = layer_of(it)
    if layer > 0 then
        -- 下の層の上へ。??? の行がある相手は、その行（とクエスト名）の分も上げる
        local row = BOX_H + STACK_GAP
        if has_label_text(it) then
            row = row + label_h + STACK_GAP
        end
        if it and it.stacked_on_under then
            local base = math.max(BOX_H, 18) + STACK_GAP
            if has_label_text(it) then base = base + label_h + STACK_GAP end
            y = y - base - (layer - 1) * row
        else
            y = y - layer * row
        end
    end
    -- 設定の位置の調整（px、＋で右・下）。マーク、クエスト名、調べる対象の名前。
    local dx = x
    if part == 'mark' then
        dx = dx + (tonumber(it and it.mark_dx) or 0)
        y = y + (tonumber(it and it.mark_dy) or 0)
    elseif part == 'label' then
        -- クエスト名（調べるオブジェクトの設定。アイコンの分も含めて渡される）
        dx = dx + (tonumber(it and it.label_dx) or 0)
        y = y + (tonumber(it and it.label_dy) or 0)
    elseif part == 'under' then
        dx = dx + (tonumber(it and it.name_dx) or 0)
        y = y + (tonumber(it and it.name_dy) or 0)
        local us = tonumber(it and it.under_scale)
        if us then
            if us < 0.8 then us = 0.8 elseif us > 1.6 then us = 1.6 end
            scale = us
        end
    end
    return {
        up = up,
        pivot = 'bottom',
        facing = 'camera',
        walls = false,
        scale = (part == 'mark') and 1 or scale,
        over_ui = false,
        distance = 16,
        x = dx * f,
        y = y * f,
    }
end

local function find_world_slot(key, part)
    part = part or 'mark'
    for _, s in ipairs(world_slots) do
        if (not s.keep) and s.key == key and (s.part or 'mark') == part then
            return s
        end
    end
    for _, s in ipairs(world_slots) do
        if (not s.keep) and (not s.placed) and (s.part or 'mark') == part then
            return s
        end
    end
    for _, s in ipairs(world_slots) do
        if (not s.keep) and (s.part or 'mark') == part then
            return s
        end
    end
    return nil
end

local function world_put(w, slot, x, y, z, opts)
    local ok = false
    local p = slot._put
    if slot.placed and p and p.x == x and p.y == y and p.z == z and p.up == opts.up and p.scale == opts.scale
        and p.ox == opts.x and p.oy == opts.y and p.pivot == opts.pivot then
        return true   -- 0.1.210〜：前と同じ所なら置き直さない
    end
    if slot.placed and w and type(w.update) == 'function' then
        ok = pcall(w.update, slot.box, {
            at = { x = x, y = y, z = z },
            up = opts.up,
            pivot = opts.pivot,
            walls = opts.walls,
            scale = opts.scale,
            facing = opts.facing,
            distance = opts.distance,
            over_ui = opts.over_ui,
            x = opts.x,
            y = opts.y,
        })
    end
    if (not ok) and w and type(w.place) == 'function' then
        ok = pcall(w.place, slot.box, x, y, z, opts)
        if ok then slot.placed = true end
    end
    if ok then
        slot._put = { x = x, y = y, z = z, up = opts.up, scale = opts.scale, ox = opts.x, oy = opts.y, pivot = opts.pivot }
        box_show(slot.box, true)
    else
        last_place_err = 'place_failed'
        slot.placed = false
        slot._put = nil
    end
    return ok
end

function ext.set_world_marks(items)
    last_place_err = nil
    if not ext.place_available() then
        last_place_err = 'no_place'
        return false
    end
    items = items or {}
    apply_icon_size(items)
    for _, s in ipairs(world_slots) do
        s.keep = false
    end
    local w = world()
    local placed = 0
    for _, it in ipairs(items) do
        local x, y, z = tonumber(it.x), tonumber(it.y), tonumber(it.z)
        if x and y then
            z = z or 0
            local up = tonumber(it.up)
            if not up or up < 0.8 then up = 0.8 end
            local role = (it.look and ROLE_FILE[it.look] and it.look) or it.role or 'examine'
            if not ROLE_FILE[role] then role = 'examine' end
            local key = it.key
            if key == nil then
                key = tostring(it.index or (tostring(x) .. ',' .. tostring(y)))
            end
            local layer = layer_of(it)
            local show_under = has_under_text(it) and layer == 0
            local it_under = it
            if has_under_text(it) and not show_under then
                -- 上の層には ??? を重ねない（一番下の1つだけ）。
                it_under = {}
                for k, val in pairs(it) do it_under[k] = val end
                it_under.under = nil
                it_under.stacked_on_under = true
            end

            local iconless = it.name_only or it.no_icon
            local mark = (not iconless) and find_world_slot(key, 'mark') or nil
            if not mark and not iconless then
                local box, kind = make_box(role)
                if box then
                    mark = { box = box, kind = kind, part = 'mark', placed = false, role = role, key = key }
                    world_slots[#world_slots + 1] = mark
                end
            end
            local label_slot, under_slot
            local label_h, under_h, under_w
            if has_label_text(it) then
                label_slot = find_world_slot(key, 'label')
                if not label_slot then
                    local box, codes = make_label_box(it.label)
                    if box then
                        label_slot = { box = box, kind = 'text', part = 'label', placed = false, role = role, key = key, codes = codes }
                        world_slots[#world_slots + 1] = label_slot
                    end
                end
                if label_slot then
                    apply_label_text(label_slot, it.label, it.label_color, it.label_color2, it.label_bg_alpha)
                    label_h = estimate_text_height(label_slot.box)
                end
            end
            if show_under then
                under_slot = find_world_slot(key, 'under')
                if not under_slot then
                    local box, codes = make_label_box(it.under)
                    if box then
                        under_slot = { box = box, kind = 'text', part = 'under', placed = false, role = role, key = key, codes = codes }
                        world_slots[#world_slots + 1] = under_slot
                    end
                end
                if under_slot then
                    apply_label_text(under_slot, it.under, it.under_color, it.under_color2, it.under_bg_alpha)
                    under_h = estimate_text_height(under_slot.box)
                    local us = tonumber(it.under_scale) or tonumber(it.scale) or 1
                    if us < 0.8 then us = 0.8 elseif us > 1.6 then us = 1.6 end
                    under_w = estimate_text_width(under_slot.box, it.under) * us
                end
            end

            local pf = 1
            if it.zoom_follow then
                -- 印を置く高さ（足元から up だけ上。上は z が小さい）の距離で測る
                local zf, d = ext.place_zoom(x, y, z - up)
                if zf then pf = zf; zoom_last.place = { key = key, f = zf, d = d } end
            end
            local any = false
            if mark then
                if mark.role ~= role then
                    apply_role(mark, role)
                end
                mark.keep = true
                mark.key = key
                mark.part = 'mark'
                if world_put(w, mark, x, y, z, world_place_opts(it_under, up, 'mark', label_h, under_h, pf, under_w)) then
                    any = true
                end
            end
            if label_slot then
                label_slot.keep = true
                label_slot.key = key
                label_slot.part = 'label'
                label_slot.role = role
                label_slot.label = it.label
                if world_put(w, label_slot, x, y, z, world_place_opts(it_under, up, 'label', label_h, under_h, pf, under_w)) then
                    any = true
                end
            end
            if under_slot then
                under_slot.keep = true
                under_slot.key = key
                under_slot.part = 'under'
                under_slot.role = role
                under_slot.under = it.under
                if world_put(w, under_slot, x, y, z, world_place_opts(it_under, up, 'under', label_h, under_h, pf, under_w)) then
                    any = true
                end
            end
            if any then
                placed = placed + 1
            end
        else
            last_place_err = last_place_err or 'no_pos'
        end
    end
    for _, s in ipairs(world_slots) do
        if not s.keep then
            if s.placed and w and type(w.detach) == 'function' then
                pcall(w.detach, s.box)
            end
            s.placed = false
            s.key = nil
            s._put = nil
            if s.box then
                box_show(s.box, false)
            end
        end
    end
    local kind
    for _, s in ipairs(world_slots) do
        if s.keep and s.kind and (s.part or 'mark') == 'mark' then
            kind = s.kind
            break
        end
    end
    last_place_kind = kind
    if #items == 0 then
        return true, 0
    end
    return placed > 0, placed
end


function ext.place_kind()
    return last_place_kind
end

function ext.place_error()
    return last_place_err
end

function ext.clear_world_marks()
    local w = world()
    for _, s in ipairs(world_slots) do
        if s.placed and w and type(w.detach) == 'function' then
            pcall(w.detach, s.box)
        end
        if s.box and type(s.box.destroy) == 'function' then
            pcall(s.box.destroy, s.box)
        end
    end
    world_slots = {}
    last_place_kind = nil
    last_place_err = nil
end


---------------------------------------------------------------------------
-- 足元の輪（0.1.171〜、t227-map）：公式 vana.world.marks（地面に沿う光の輪。手前の物にかくれる）。
-- 渡すのはこのアドオンの輪の全部（毎回）。空・nil で全部消える。読み込み解除でも消える。
---------------------------------------------------------------------------

local rings_on = false
local last_rings = nil
function ext.rings_available()
    local w = world()
    return w ~= nil and type(w.marks) == 'function'
end

-- シーンの効果で描けるか（vana.graphics.info().active）。false ならアドオンが画面に描く
local rn_at, rn_val = -1, nil
function ext.clear_rings_native_cache() rn_at, rn_val = -1, nil end
function ext.rings_native()
    -- 0.1.210〜：1 秒に 1 回だけ聞く
    local now = os.clock()
    if rn_at >= 0 and now - rn_at < 1 and now >= rn_at then return rn_val end
    rn_at = now
    rn_val = ext._rings_native()
    return rn_val
end
function ext._rings_native()
    local v = V()
    local g = v and type(v.graphics) == 'table' and v.graphics or nil
    if not g or type(g.info) ~= 'function' then return nil end
    local ok, i = pcall(g.info)
    if ok and type(i) == 'table' then return i.active == true end
    return nil
end

-- items: { { x, y, z, radius, color = '#RRGGBB', strength }, ... }
function ext.set_ground_rings(items)
    local w = world()
    if not w or type(w.marks) ~= 'function' then return false, 'no_api' end
    if not items or #items == 0 then
        if rings_on then pcall(w.marks); rings_on = false end
        last_rings = nil
        return true, 0
    end
    -- 0.1.210〜：前と同じ輪なら渡し直さない（毎フレーム全部を渡していた）
    if rings_on and last_rings and #last_rings == #items then
        local same = true
        for i, it in ipairs(items) do
            local o = last_rings[i]
            if o.x ~= it.x or o.y ~= it.y or o.z ~= it.z or o.radius ~= it.radius or o.color ~= it.color
                or o.strength ~= it.strength then
                same = false
                break
            end
        end
        if same then return true, #items end
    end
    local ok, err = pcall(w.marks, items)
    if not ok then last_rings = nil; return false, tostring(err) end
    rings_on = true
    last_rings = items
    return true, #items
end

function ext.clear_ground_rings()
    last_rings = nil
    local w = world()
    if rings_on and w and type(w.marks) == 'function' then pcall(w.marks) end
    rings_on = false
end


---------------------------------------------------------------------------
-- 階の判定に使う窓口（読むだけ）
-- 公式 vana.memory（find / read_uint32 / module）と vana.game.zoning。
-- ゲームの関数を呼ぶ部分は ashita.lua にある（ここはメモリの窓口だけ）。
---------------------------------------------------------------------------

-- 戻り値: { find(module, pattern, offset, nth), read_u32(addr), module_range(module), source } または nil
function ext.memory()
    local v = V()
    local m = v and type(v.memory) == 'table' and v.memory or nil
    if not m or type(m.find) ~= 'function' or type(m.read_uint32) ~= 'function' then
        return nil
    end
    return {
        source = 'vana.memory',
        find = function (module, pattern, offset, nth)
            -- 2つ目を探すときだけ 5 番目（何番目の一致か）を渡す
            if (nth or 0) == 0 then return m.find(module, 0, pattern, offset or 0) end
            return m.find(module, 0, pattern, offset or 0, nth)
        end,
        read_u32 = function (addr) return m.read_uint32(addr) end,
        module_range = function (module)
            if type(m.module) ~= 'function' then return nil, nil end
            local ok, base, size = pcall(m.module, module)
            if not ok then return nil, nil end
            return tonumber(base), tonumber(size)
        end,
    }
end

-- 通信（0.1.172〜、エミネンス）。公式 vana.packets（docs/addons/10-packets.md）
-- 最後に届いた（incoming=true）・送った通信。頭 4 バイトから。無ければ nil
function ext.last_packet(incoming, id)
    local v = V()
    local p = v and type(v.packets) == 'table' and v.packets or nil
    if not p or type(p.last) ~= 'function' then return nil end
    local ok, s = pcall(p.last, incoming and true or false, id)
    if ok and type(s) == 'string' then return s end
    return nil
end

function ext.can_inject()
    local v = V()
    return v ~= nil and type(v.packets) == 'table' and type(v.packets.inject) == 'function'
end

-- 送る（ボタンを押したときに app → platform から 1 回だけ）。頭 4 バイトは VanaCore が入れる
function ext.inject_packet(incoming, id, data)
    local v = V()
    if not v or type(v.packets) ~= 'table' or type(v.packets.inject) ~= 'function' then return false, 'no_api' end
    local ok, err = pcall(v.packets.inject, incoming and true or false, id, data)
    if not ok then return false, tostring(err) end
    return true
end

-- ゾーン移動中か（公式 vana.game.zoning）。分からなければ nil。
function ext.zoning()
    local v = V()
    if not v or type(v.game) ~= 'table' or type(v.game.zoning) ~= 'function' then
        return nil
    end
    local ok, z = pcall(v.game.zoning)
    if not ok then return nil end
    return z and true or false
end


---------------------------------------------------------------------------
-- ゲーム本来のメニュー（公式 vana.gameui）
-- 使うのは: watch / unwatch（窓が開いた・閉じたを見るだけ）、add / remove（コンフィグに自分のボタン1つ）、
-- catch / off（本を操作しているあいだだけ、ゲームのメニューに入力を渡さない）。
-- hide / move / replace / image / press は使わない。
---------------------------------------------------------------------------

local function gameui()
    local v = V()
    if v and type(v.gameui) == 'table' then return v.gameui end
    return nil
end

function ext.gameui_available()
    return gameui() ~= nil
end

--[[ ゲームのメニュー・会話の選択肢が開いているか（0.1.186〜、t302）。読むだけ。
  説明書（04-game-data / 07-game-interface）：vana.game.target().menu_open（ゲームのメニューが開いている）、
  vana.gameui.windows()（出ている窓の名前）と vana.gameui.window(名前).focused（キーが行く窓）。
  どちらかが真なら「開いている」。両方とも読めなければ nil。
  戻り値: open（true/false/nil）, { flag = bool|nil, focused = { 名前... } } ]]
-- いつも出ている窓（メニューではない。0.1.186 で読んだ、何も開いていないときの窓）。重なりを見るときに外す（0.1.189〜）
ext.HUD_WINDOWS = { helpwind = true, titlewin = true, partywin = true, netstat = true, buff = true, logwindo = true }
-- これより小さい窓は中身が無い（VanaCore の説明書：16 未満は貼り直さない）
ext.MENU_MIN_SIZE = 16

function ext.game_menu_state()
    local v = V()
    if not v then return nil, {} end
    local info = { focused = {}, rects = {} }
    if type(v.game) == 'table' and type(v.game.target) == 'function' then
        local ok, t = pcall(v.game.target)
        if ok and type(t) == 'table' and t.menu_open ~= nil then info.flag = t.menu_open and true or false end
    end
    local g = gameui()
    local listed = false
    if g and type(g.windows) == 'function' and type(g.window) == 'function' then
        local ok, names = pcall(g.windows)
        if ok and type(names) == 'table' then
            listed = true
            for _, n in ipairs(names) do
                local okw, w = pcall(g.window, n)
                if okw and type(w) == 'table' and w.focused == true and w.closing ~= true and w.hidden ~= true then
                    info.focused[#info.focused + 1] = tostring(n)
                end
                -- 0.1.189〜（t315）：メニューの窓の場所（画面の点。重なったこちらの窓を引っ込めるため）
                if okw and type(w) == 'table' and w.closing ~= true and w.hidden ~= true and w.drawn ~= false
                    and not ext.HUD_WINDOWS[tostring(n)] then
                    local x, y, ww, hh = tonumber(w.x), tonumber(w.y), tonumber(w.w), tonumber(w.h)
                    if x and y and ww and hh and ww >= ext.MENU_MIN_SIZE and hh >= ext.MENU_MIN_SIZE then
                        info.rects[#info.rects + 1] = { name = tostring(n), x = x, y = y, w = ww, h = hh }
                    end
                end
            end
        end
    end
    if info.flag == nil and not listed then return nil, info end
    return (info.flag == true) or #info.focused > 0, info
end

-- ゲームの窓を、この アドオンの ImGui の窓より前に出す（公式 vana.ui.game_on_top。アンロードで外れる）。
-- 使えなければ false
function ext.can_game_on_top()
    local v = V()
    return v ~= nil and type(v.ui) == 'table' and type(v.ui.game_on_top) == 'function'
end

function ext.set_game_on_top(on)
    if not ext.can_game_on_top() then return false end
    local ok = pcall(V().ui.game_on_top, on and true or false)
    return ok
end

-- チャット入力が開いているか（公式 vana.game.world().chat_open）。分からなければ nil
function ext.chat_open()
    local v = V()
    if not v or type(v.game) ~= 'table' or type(v.game.world) ~= 'function' then return nil end
    local ok, w = pcall(v.game.world)
    if not ok or type(w) ~= 'table' then return nil end
    if w.chat_open == nil then return nil end
    return w.chat_open and true or false
end

-- 窓を見る。fn(what, name, closing)。戻り値: id または nil, 理由
function ext.watch_windows(names, fn)
    local g = gameui()
    if not g or type(g.watch) ~= 'function' then return nil, 'no_watch' end
    local ok, id = pcall(g.watch, names, function (e)
        if type(e) ~= 'table' then return end
        local closing = false
        if type(e.window) == 'table' and e.window.closing == true then closing = true end
        pcall(fn, tostring(e.what or ''), tostring(e.name or ''), closing)
    end)
    if not ok then return nil, tostring(id) end
    return id
end

function ext.unwatch(id)
    local g = gameui()
    if g and id ~= nil and type(g.unwatch) == 'function' then pcall(g.unwatch, id) end
end

-- コンフィグメニューに自分のボタンを足す。labels を順に試す。戻り値: 使えたラベル または nil, 理由
function ext.add_config_button(labels, fn)
    local g = gameui()
    if not g or type(g.add) ~= 'function' then return nil, 'no_add' end
    local why = 'failed'
    for _, label in ipairs(labels) do
        local ok, r, r2 = pcall(g.add, 'config_menu', label, fn)
        if ok and r ~= false then return label end
        why = ok and tostring(r2 or 'refused') or tostring(r)
        -- 失敗したら、半端に残らないよう外してから次を試す
        if type(g.remove) == 'function' then pcall(g.remove, 'config_menu') end
    end
    return nil, why
end

function ext.remove_config_button()
    local g = gameui()
    if g and type(g.remove) == 'function' then pcall(g.remove, 'config_menu') end
end

-- 本を操作しているあいだ、ゲームのメニューの入力を止める（公式 catch。全部のメニュー・全部の入力）
function ext.catch_menus()
    local g = gameui()
    if not g or type(g.catch) ~= 'function' then return nil, 'no_catch' end
    local ok, id = pcall(g.catch, '*', '*', function () end)
    if not ok or id == nil then return nil, tostring(id) end
    return id
end

function ext.release_menus(id)
    local g = gameui()
    if g and id ~= nil and type(g.off) == 'function' then pcall(g.off, id) end
end


return ext
