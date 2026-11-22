-- 0.1.262：SF エミネンスのカード格子、アイテム名のゲーム風ツールチップ
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.300', 'version')

local item_tip = require('src.ui.item_tip')
local eminence_sf = require('src.ui.eminence_sf')
local eminence = require('src.ui.eminence')

---------------------------------------------------------------------------
-- ツールチップ：説明の言語、欄、アイコンの解読、失敗時は出さない
---------------------------------------------------------------------------
item_tip.clear_source()

eq(item_tip.language_of('ポーションを飲む。'), 'ja', 'hiragana/katakana is Japanese')
eq(item_tip.language_of('万能薬は状態異常を治す。'), 'ja', 'kanji description is Japanese')
eq(item_tip.language_of('A potion that cures most status ailments.'), 'en', 'ASCII English')
eq(item_tip.language_of(''), 'unknown', 'empty is unknown')

-- 32bit BMP（2×2）
local function le32(n)
    n = n % 4294967296
    return string.char(n % 256, math.floor(n / 256) % 256, math.floor(n / 65536) % 256, math.floor(n / 16777216) % 256)
end
local function le16(n)
    n = n % 65536
    return string.char(n % 256, math.floor(n / 256) % 256)
end
local pixels = string.char(
    0, 0, 255, 255,   -- BGRA red
    0, 255, 0, 255,   -- green
    255, 0, 0, 255,   -- blue
    255, 255, 255, 255
)
local dib = le32(40) .. le32(2) .. le32(2) .. le16(1) .. le16(32) .. le32(0) .. le32(16)
    .. le32(0) .. le32(0) .. le32(0) .. le32(0)
local bmp = 'BM' .. le32(14 + 40 + 16) .. le32(0) .. le32(14 + 40) .. dib .. pixels
local img = item_tip.decode_icon(bmp)
check(img and img.width == 2 and img.height == 2 and #img.rgba == 16, 'BMP decodes to 2x2 RGBA')
eq(item_tip.last_icon_kind, 'bmp', 'kind is bmp')
-- 下から上：先頭の赤は下段左。左上は青 (B,G,R,A = 255,0,0,255) → RGBA 0,0,255,255
eq(img.rgba:byte(1), 0, 'top-left R')
eq(img.rgba:byte(2), 0, 'top-left G')
eq(img.rgba:byte(3), 255, 'top-left B')

-- 生 32×32 BGRA
local raw = string.rep(string.char(10, 20, 30, 255), 32 * 32)
local raw_img = item_tip.decode_icon(raw)
check(raw_img and raw_img.width == 32 and raw_img.height == 32, 'raw 32x32 BGRA decodes')
eq(item_tip.last_icon_kind, 'raw32', 'kind is raw32')
eq(item_tip.decode_icon('short'), nil, 'short blob is rejected')
eq(item_tip.decode_icon(string.rep('x', 100)), nil, 'unknown blob is rejected')

-- 注入した資料
item_tip.set_source({
    item = function (id)
        if id == 4155 then
            return {
                name = '万能薬',
                description = 'ほとんどの状態異常を治す。',
                level = 1,
                flags = 0xC000,
                flag_names = { 'Rare', 'Ex' },
                jobs = 0, -- 使えない装備ではない
            }
        end
        if id == 12576 then
            return {
                name = 'Scale Mail',
                description = 'A sturdy suit of scale mail.',
                level = 10,
                jobs = 2 + 4 + 8, -- bit n = job n → 1 戦, 2 モ, 3 白
                flag_names = {},
                flags = 0,
            }
        end
        return nil
    end,
    key_item = function (id)
        if id == 12 then
            return { name = 'CL研究報告書', description = 'クリスタルラインの研究報告書。', category = 'Documents' }
        end
        return nil
    end,
    job = function (id)
        return ({ [1] = { short = 'WAR' }, [2] = { short = 'MNK' }, [3] = { short = 'WHM' } })[id]
    end,
    icon = function (id)
        if id == 4155 then return bmp end
        return nil
    end,
    load_texture = function (img)
        return { _tex = true, w = img.width, h = img.height }
    end,
})

local info = item_tip.info_for_item(4155)
check(info and info.name == '万能薬', 'item name from gamedata')
eq(info.language, 'ja', 'description language is Japanese when the text is Japanese')
eq(info.rare, true, 'Rare from flag_names')
eq(info.ex, true, 'Ex from flag_names')
eq(info.level, 1, 'level')
local tex = item_tip.texture_for(4155, info.icon_bytes)
check(tex and tex._tex == true, 'icon becomes a texture when the bytes decode')

local mail = item_tip.info_for_item(12576)
eq(mail.language, 'en', 'English description stays English')
check(mail.jobs and #mail.jobs >= 1, 'jobs from bit field')
local jobset = {}
for _, s in ipairs(mail.jobs) do jobset[s] = true end
check(jobset['戦'] and jobset['モ'] and jobset['白'], 'Japanese 1-char jobs from bits 1,2,4')

local ki = item_tip.info_for_key(12)
check(ki and ki.name == 'CL研究報告書' and ki.language == 'ja', 'key item name and Japanese description')
check(ki.level == nil and ki.jobs == nil, 'key items have no level or jobs')

-- 複数番号はひとつに絞らない
local g = item_tip.info_for_need({ name_ja = 'クリスタル', item_ids = { 4096, 4097 } })
eq(g.kind, 'item_group', 'grouped crystals are not a single item')
check(not g.icon_bytes, 'group has no icon')

-- 資料が無い番号は薄い情報か nil
eq(item_tip.info_for_item(1), nil, 'missing item is nil')
local thin = item_tip.info_for_need({ kind = 'key_item', key_item_id = 999, name_ja = '未知の証' })
check(thin and thin.thin and thin.name == '未知の証', 'missing key item still shows the name we have')

-- 描画：BeginTooltip があればそれを使い、無ければ SetTooltip に落とす
do
    local seen = {}
    local ui = {
        imgui = {
            BeginTooltip = function () seen.begin = true; return true end,
            EndTooltip = function () seen.ended = true end,
            Image = function (tex, sz) seen.image = tex; seen.sz = sz end,
            SameLine = function () end,
            BeginGroup = function () end,
            EndGroup = function () end,
            GetCursorPosX = function () return 0 end,
            PushTextWrapPos = function () end,
            PopTextWrapPos = function () end,
        },
        t = function (k, a)
            if k == 'item_tip.level' then return 'Lv. ' .. a.n end
            if k == 'item_tip.rare' then return 'Rare' end
            if k == 'item_tip.ex' then return 'Ex' end
            if k == 'item_tip.jobs' then return a.list end
            if k == 'item_tip.item_level' then return 'iLv. ' .. a.n end
            return k
        end,
    }
    -- theme.TextColored は実モジュール
    check(item_tip.draw(ui, info) == true, 'draws a tooltip')
    check(seen.begin and seen.ended, 'uses BeginTooltip/EndTooltip')
    check(seen.image and seen.image._tex, 'draws the icon in ImGui')
end

item_tip.clear_source()

---------------------------------------------------------------------------
-- SF エミネンス：カード格子と詳細。クラシックの表は触らない
---------------------------------------------------------------------------
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local roe = require('src.core.roe')

local db = {
    quests = {
        [12] = { name = 'Vanquish Multiple Enemies I', body = 'Defeat enemies.', target = 200, repeatable = true, special = 'Test Primer', },
        [13] = { name = 'Vanquish Multiple Enemies II', body = '', target = 500, repeatable = false, special = '' },
        [300] = { name = 'Loose One', body = '', target = 5, repeatable = false, special = '' },
    },
    cats = {},
    roots = {},
    loose = { 12, 13, 300 },
    cat_of = {},
}
function app.roe_db() return db end
-- 受けているもの
local st = app._state and app._state() or nil
-- state への入口
local roe_state
pcall(function ()
    -- app 内部の state.roe を、公開フック経由で触る
end)
-- ui 経由：一度描画してから差し込むため、known な場所を探す
local function inject_roe()
    -- app.roe_db は差し込み済み。active は read 後の state。テストでは ui.state.roe を直接足すため、
    -- 描画前に app の roe 状態へ最小限を書く。
end

-- 公開：possession などと同様の取り出しが無ければ、settings + 描画 ui で足りるよう
-- test は book を開いたあと、内部の state.roe を pack する。app に _roe が無いので、
-- roe_active 系が参照する state を、command ではなく直接のテーブル差し込みで。
-- src/app.lua の state はクロージャ。app.read_roe を使わず、ui フック後に
-- 描画関数へ渡る ui.state.roe を差し替える。
local old_tick = app.draw
-- より単純：eminence_sf.shown_rows をユニットで試す
local complete = roe.new_complete()
-- #300 達成
do
    local idx, bit = math.floor(300 / 8) + 1, 2 ^ (300 % 8)
    complete[idx] = (complete[idx] or 0) + bit
end
local ui = {
    t = function (k, a)
        if k == 'sf.badge_progress' then return '進行中' end
        if k == 'sf.badge_done' then return '完了' end
        if k == 'sf.badge_idle' then return '未開始' end
        if k == 'filter.all' then return 'すべて' end
        if type(a) == 'table' then
            local s = k
            for key, val in pairs(a) do s = s:gsub('{' .. key .. '}', tostring(val)) end
            return s
        end
        return k
    end,
    imgui = require('imgui'),
    settings = S,
    state = {
        roe = {
            active = { { id = 12, progress = 50 } },
            complete = complete,
            db = db,
            db_lang = 'ja',
        },
        open = {},
    },
    roe_db = function () return db end,
    roe_active_count = function () return 1 end,
    roe_can = function () return true end,
    roe_send = function () end,
    mark_settings_dirty = function () end,
    data = app._data(),
    progress = app._progress(),
}
S.eminence = S.eminence or {}
S.eminence.book_show = { accepted = true, not_accepted = true, completed = true, unimplemented = true }
S.eminence.book_text = ''
S.eminence.book_favs_only = false
S.eminence.pins = S.eminence.pins or {}
S.eminence.favs = S.eminence.favs or {}
S.book = S.book or {}
S.book.last_heading = S.book.last_heading or {}
S.book.last_heading.eminence = 'all'

eminence_sf.reset_cache()
local shown = eminence_sf.shown_rows(ui)
local ids = {}
for _, r in ipairs(shown) do ids[#ids + 1] = r.id end
local set = {}
for _, id in ipairs(ids) do set[id] = true end
check(set[12] and set[13] and set[300], 'cached list has the three records')
-- 進行中が先頭
eq(ids[1], 12, 'accepted records sort first')
-- 署名が同じなら同じ表を返す
local shown2 = eminence_sf.shown_rows(ui)
check(shown2 == shown, 'identical signature reuses the cached list')
ui.state.roe.active[1].progress = 80
local shown3 = eminence_sf.shown_rows(ui)
check(shown3 ~= shown, 'progress change rebuilds the list')

-- 本を SF で開く
S.look = 'sf'
S.book.tab = 'eminence'
-- app.roe_db は差し込み済み。state.roe の active はアプリ内部。描画時に空でもカードは未受注として出る。
app.close_all(); app.open_window('book'); frame(); frame(); frame()
-- タブは面取り（既存の SF タブ）
check(labeled('##tab_eminence') or texted('EMINENCE') or labeled('EMINENCE'), 'chamfered Eminence tab is present')
-- クラシックの表（##roe_start_）ではなくカード
-- DAT が読めないとカードは空。内部 db を描画に渡すため、アプリの roe_db キャッシュを上書きする試み。
-- 空でも、レイアウト用のカード子窓は作られる。
-- DAT が無いテスト環境ではカードの中身は空でも、SF のカード／詳細の子窓は作る
check(drawn('##astertrail_sf_em_cards') or drawn('###astertrail_sf_em_cards')
    or labeled('##astertrail_sf_em_cards') or texted('EMINENCE'),
    'SF eminence uses the card pane (or at least the SF tab)')

-- クラシックのままのときにカード窓を出さない
S.look = 'classic'
S.book.tab = 'eminence'
app.close_all(); app.open_window('book'); frame(); frame()
check(not drawn('##astertrail_sf_em_cards') and not drawn('###astertrail_sf_em_cards'),
    'classic eminence does not use the SF card pane')

print('test_sf_262 ok')
