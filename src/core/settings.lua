--[[
  Astertrail - settings（キャラ別の見た目と設定、4-6 の初期値）
  ファイルの読み書きは storage 経由。ここは値の形と初期値だけを持つ。
]]

local json = require('src.lib.json')
local util = require('src.lib.util')

local SETTINGS_SCHEMA = 1

local settings = {}

local function win(open)
    -- x, y, w, h は未設定（nil）。初回は画面中央付近に既定の大きさで出す
    return { open = open }
end

function settings.defaults()
    return {
        settings_schema = SETTINGS_SCHEMA,
        language = 'ja',
        font_scale = 1.0,          -- その他（設定・必要品まとめ・お知らせ・入口アイコン）
        -- 場所ごとの文字の大きさ。窓の大きさは変えない（SetWindowFontScale だけ）。
        -- list（0.1.209〜）：本の一覧（見出しの木と表）だけ。まだ無い保存は「本」の値
        fonts = { book = 1.0, list = 1.0, detail = 1.0, tracker = 1.0, eminence = 1.0, map = 1.0, overhead_quest = 1.0, overhead_name = 1.0 },
        layout_locked = false,
        theme = 'dark_calm',
        background_alpha = 0.85,
        -- 窓ごとの背景の濃さ（0.1.42）。古い保存は background_alpha を引き継ぐ
        alphas = { book = 0.85, detail = 0.85, tracker = 0.85, eminence = 0.85, map = 0.85, settings = 0.85, other = 0.85 },
        reduce_motion = false,
        windows = {
            book = win(false),
            detail = win(false),
            tracker = win(true),
            settings = win(false),
            map = win(false),
            entry = win(true),
            resume = win(true),
            popup = win(true),
            eminence = win(false),   -- エミネンスの窓（0.1.172〜。出す・隠すは eminence.visible）
            compass = win(false),    -- コンパスの窓（0.1.173〜。出す・隠すは compass.visible）
        },
        entry_icon = { visible = true },
        -- 本と設定を開いたとき、前回の選択・タブ・一覧の位置から始める（初めはオフ＝いちばん上から）
        remember_position = false,
        -- 見た目：'yunaui'（YunaUI 風）／ 'classic'（クラシック）。保存のキーは classic のまま
        -- 0.1.204〜：初期はクラシック（0.1.194 で「これまで」から改名した見た目）
        look = 'classic',
        book = {
            remember_filters = true,
            tab = 'mission',
            -- 一覧の幅の割合（境目をつかんで変える）。タブごと（0.1.192〜）。0.1.208〜は見出しの木＋表
            splits = { mission = 0.56, quest = 0.56, eminence = 0.56 },
            -- 左の見出しの木の幅（窓に対する割合。0.1.208〜）
            tree_splits = { mission = 0.18, quest = 0.18, eminence = 0.18 },
            -- 選んでいる見出し（0.1.208〜）。タブごと。'all' が「すべて」
            last_heading = json.object({}),
            -- 一覧の列の並び（見出しをドラッグで入れ替え。ピンの列はいつも左端）
            columns = { 'no', 'name', 'rewards', 'state' },   -- 0.1.69〜：ピン・番号・名前・報酬・状態（リピートの列は無くした）
            hidden = {},       -- 隠した列（{ rewards = true } のように）
            -- たたんだ見出し（0.1.193〜）。タブごと { [id] = true }。無いものは開いている
            collapsed = json.object({}),
            -- 列の幅（px、0.1.193〜）。タブごと。利用者が動かしたときだけ覚える（文字サイズでは変えない）
            col_widths = json.object({}),
            -- 一覧の縦位置（0.1.203〜）。タブごと。本を開いたとき・タブを戻したときに戻す
            scroll = { mission = 0, quest = 0, eminence = 0 },
            -- 見出しの木の縦位置（0.1.208〜）
            tree_scroll = { mission = 0, quest = 0, eminence = 0 },
            filters = { area = 'all', state = 'all', text = '' },
        },
        tracker = {
            visible = true,
            max_pins = 10,
            show_time_weather = true,
            show_items = true,
            collapsed = false,
            align = 'right',   -- 文字のそろえ方（0.1.62〜）：'right' / 'left'
            show_close = true, -- 右上の × を出す（0.1.170〜）
            view = 'list',     -- 出し方（0.1.170〜）：'list'（全部を縦に）／ 'tabs'（タブで1件ずつ）
            tab_chars = 6,     -- タブの幅（全角の字数、0.1.171〜）。3〜16
        },
        items = { show_possession = true },   -- 手順ごとの所持の欄（(2/5) など）。必要品まとめは 0.1.173 でなくした
        -- コンパス（0.1.173〜、t251）：いまいるエリアで受けられるクエストを近い順に
        -- max_dist：何ヤルム以内を出す（0.1.201〜。5〜100・5きざみ、初期 30）
        compass = { visible = false, max_dist = 30 },
        -- エミネンス・レコード（0.1.172〜、t243）
        eminence = {
            visible = false,        -- 窓を出す
            collapsed = false,      -- ピン留め（0.1.177〜。前の「たたむ」）：★ を付けたものだけ
            filter = 'all',         -- いつも 'all'。'near'（達成間近）は 0.1.177、'area'（このエリア）は 0.1.179 でなくした（'all' に戻す）
            near_pct = 80,          -- 達成間近の目安（目標の数の %）。50〜95
            hide_completed = true,  -- 0.1.203〜：本で達成したもの（くり返せないもの）を隠す。くり返しできる達成は残す。オフなら薄く
            pins = json.object({}), -- ピン { ["12"] = true }
            failed = json.object({}), -- 受けられない・まだ無いと言われた番号 { ["3055"] = { why = 'not_impl', at = ... } }
            book_root = -2,         -- 本で選んだ分類：-2 すべて（0.1.182〜の初期）・-1 分類なし・ほかはいちばん上の分類
            book_state = 'all',     -- 'all' / 'not_accepted' / 'accepted' / 'completed'
            book_text = '',
            favs = json.object({}), -- お気に入り（0.1.182〜、本だけ。★ のピンとは別）{ ["12"] = true }
            book_favs_only = false, -- 本でお気に入りだけ出す（0.1.182〜。前の「★だけ」はなくした）
            -- 本のエミネンスの列（0.1.193〜）。くり返しの列は無し。並びはドラッグで入れ替え
            -- 0.1.203〜 初期の並び：受ける・解除、★、お気に入り、名前、進み、報酬（0.1.209〜 状態の列はなくした）
            columns = { 'action', 'pin', 'fav', 'name', 'progress', 'rewards' },
            hidden = {},
        },
        notify = {
            login_resume = false,  -- 0.1.200〜：新しい導入・未設定はオフ。保存済みのオン／オフはそのまま
            login_resume_seconds = 10,
            popup = true,           -- 受注・完了のお知らせ（0.1.183〜、t295）
            popup_seconds = 8,      -- お知らせが消えるまで（秒）
            sound = true,           -- 受注・完了の効果音
            sound_volume = 70,      -- 効果音の音量（0〜100、10 きざみ）
        },
        backup = { keep = 10 },
        diagnostics = { level = 'minimal' },
        -- 予約（この版では画面に出さない）
        auto_detect = { enabled = false },
        map = { enabled = true },
        marks = {
            -- 表示のオン・オフは4つだけ（0.1.59〜）。それぞれ名前のとおりのものだけを動かす
            show_icons = true,          -- アイコンを表示する（NPC・モンスター・調べるオブジェクトのクエストの目印）
            show_object_names = true,   -- クエストのオブジェクト名を表示する（クエストに関係する調べるオブジェクトの名前）
            zoom_follow = true,   -- ズームに合わせて位置を調整する（試し）
            placement = 'above',
            placement_talk = 'above',
            placement_hunt = 'above',
            placement_examine = 'above',
            placement_guard = 'above',
            show_quest_name = true,
            icon_size = 28,
            -- 近くのオブジェクト名を表示する（0.1.58〜、初期はオフ）。クエストに関係ない近くのオブジェクトの名前
            show_nearby_names = false,
            -- 名声を教えてくれる人のアイコン（0.1.69〜、初期はオン）。いちばん低い優先（ゲートガードより下）
            show_fame_npcs = true,
            -- 頭上の位置の調整（px）。＋で右・下。0 がこれまでの位置。
            -- そのほか（話す相手・討伐対象・ゲートガード）
            mark_dx = 0, mark_dy = 0,     -- マーク（アイコン）
            label_dx = 0, label_dy = 0,   -- クエスト名（0.1.46〜、初めは 0）
            -- 調べるオブジェクト（??? など）。0.1.45 から別。古い保存は上の値を引き継ぐ
            obj_mark_dx = 0, obj_mark_dy = 0,     -- アイコンと名前（??? など）の行
            obj_label_dx = 0, obj_label_dy = 0,   -- クエスト名（0.1.46〜、初めは 0）
            -- 近くのオブジェクト名（0.1.60〜）。クエストのオブジェクト名（上の行）とは別。古い保存は上の行の値を引き継ぐ
            near_name_dx = 0, near_name_dy = 0,
            -- 文字の色（0.1.47〜）。{r, g, b}（0〜255）。グラデーションは左から右へ、終わりの色まで
            label_color = { 248, 244, 232 }, label_grad = false, label_color2 = { 190, 168, 255 },   -- クエスト名（どのアイコンも）
            under_color = { 248, 244, 232 }, under_grad = false, under_color2 = { 120, 200, 255 },   -- オブジェクト名（??? など）
            -- 足元の輪（0.1.171〜）。公式 vana.world.marks で、印を付けた相手の足元に、アイコンと同じ色の光の輪
            show_rings = true, ring_size = 1.0,
            -- 輪の色（種類ごと、{r, g, b} 0〜255）。初期値は今のアイコンの色（theme.palette の ic_* ・mob・gold）
            ring_sub = { 255, 219, 92 }, ring_progress = { 107, 189, 255 }, ring_blocked = { 230, 71, 66 },
            ring_complete = { 92, 214, 117 }, ring_repeat = { 148, 209, 163 }, ring_unavailable = { 230, 71, 66 },
            ring_hunt = { 255, 153, 140 }, ring_main = { 250, 194, 56 }, ring_guard = { 250, 212, 128 },
            ring_fame = { 219, 92, 214 },
        },
        input = { gamepad = true, repeat_ms = 200 },
        -- アップデートのお知らせ（0.1.58〜）。読み込んだあと一回だけ、新しい版があればチャットに1行
        update_notice = { enabled = true },
        -- パッドのショートカット（0.1.57〜）。本を開く／自前のメニューを閉じる。空なら使わない。pass_to_game=ゲームにも渡す
        -- 0.1.61〜：トラッカーの表示／非表示・トラッカーを操作する（初期値は未設定＝オフ）
        -- 0.1.194〜：エミネンス・コンパスの表示／非表示（初期値はなし。古い保存にキーが無くてもなし）
        shortcut = { open_book = json.array({}), tracker_toggle = json.array({}),
            tracker_operate = json.array({}), compass_toggle = json.array({}),
            eminence_toggle = json.array({}), pass_to_game = true },
        -- ゲーム本来のメニュー（vana.gameui）
        gameui = { mission_book = true, config_button = true, capture = true, menus_on_top = true },   -- menus_on_top 0.1.186〜
        -- デバッグ（0.1.187〜、t308）：手で 未受注・受注中・完了 にするボタン。初めは出さない（公開版はいつも出さない）
        debug = { state_buttons = false },
        -- 話して覚えた名声（0.1.66〜）。{ sandoria = { level = 3, at = '2026-11-14T...', npc = 'Namonutice' }, ... }
        fame = json.object({}),
        -- 初期値の改訂（0.1.67 で 2、0.1.69 で 3、0.1.203 で 4 と 5、0.1.204 で 6）。古い保存の「初期値のままの値」を新しい初期値へ移すのに使う
        defaults_rev = 8,
    }
end

settings.SCHEMA = SETTINGS_SCHEMA

-- 読み込んだ表を初期値と合わせる。新しい形式なら読み取り専用の印を返す
function settings.merge(loaded)
    local d = settings.defaults()
    if type(loaded) ~= 'table' then return d, nil end
    local schema = tonumber(loaded.settings_schema) or SETTINGS_SCHEMA
    local merged = util.merge_defaults(d, loaded)
    merged.settings_schema = SETTINGS_SCHEMA
    -- 範囲の確認（壊れた値で画面が崩れないように）
    merged.font_scale = util.clamp(tonumber(merged.font_scale) or 1.0, settings.FONT_MIN, settings.FONT_MAX)
    -- 場所ごとの文字の大きさ。まだ無い古い保存は、これまでの共通の文字サイズを引き継ぐ。
    local loaded_fonts = type(loaded.fonts) == 'table' and loaded.fonts or {}
    merged.fonts = {}
    for _, area in ipairs(settings.FONT_AREAS) do
        local lo, hi = settings.font_range(area)
        local v = tonumber(loaded_fonts[area])
        -- 0.1.31 の「頭上の文字」（overhead）は、クエスト名と名前の両方へ引き継ぐ
        if v == nil and (area == 'overhead_quest' or area == 'overhead_name') then
            v = tonumber(loaded_fonts.overhead)
        end
        -- 0.1.177〜：エミネンスの窓の文字サイズ。まだ無い保存はトラッカーの値（今までと同じ見た目）
        if v == nil and area == 'eminence' then v = tonumber(loaded_fonts.tracker) end
        -- 0.1.209〜：一覧の文字サイズ。まだ無い保存は本の値（今までと同じ見た目）
        if v == nil and area == 'list' then v = tonumber(loaded_fonts.book) end
        v = v or merged.font_scale
        merged.fonts[area] = util.clamp(math.floor(v * 100 + 0.5) / 100, lo, hi)
    end
    -- 0.1.192〜：一覧と詳細の境目をタブごと（ミッション・クエスト・エミネンス）に覚える。
    -- 前の共通の book.split は、3つ全部の初期値にする。無いタブだけそれを使う。窓の大きさは変えない。
    do
        local loaded_book = type(loaded.book) == 'table' and loaded.book or {}
        local inherited = tonumber(loaded_book.split)
        local src = type(loaded_book.splits) == 'table' and loaded_book.splits or {}
        merged.book.splits = {}
        for _, tab in ipairs({ 'mission', 'quest', 'eminence' }) do
            merged.book.splits[tab] = util.clamp(tonumber(src[tab]) or inherited or 0.56, 0.2, 0.8)
        end
        merged.book.split = nil
        -- 0.1.203〜：一覧の縦位置をタブごとに覚える
        local src_scroll = type(loaded_book.scroll) == 'table' and loaded_book.scroll or {}
        merged.book.scroll = {}
        for _, tab in ipairs({ 'mission', 'quest', 'eminence' }) do
            local y = tonumber(src_scroll[tab]) or 0
            if y < 0 then y = 0 end
            merged.book.scroll[tab] = y
        end
        -- 0.1.208〜：見出しの木の幅と、選んでいる見出し、木の縦位置
        local src_tree = type(loaded_book.tree_splits) == 'table' and loaded_book.tree_splits or {}
        merged.book.tree_splits = {}
        for _, tab in ipairs({ 'mission', 'quest', 'eminence' }) do
            merged.book.tree_splits[tab] = util.clamp(tonumber(src_tree[tab]) or 0.18, 0.08, 0.45)
        end
        local src_th = type(loaded_book.last_heading) == 'table' and loaded_book.last_heading or {}
        merged.book.last_heading = json.object({})
        for _, tab in ipairs({ 'mission', 'quest', 'eminence' }) do
            local id = src_th[tab]
            if id ~= nil and tostring(id) ~= '' then merged.book.last_heading[tab] = tostring(id) end
        end
        local src_tsc = type(loaded_book.tree_scroll) == 'table' and loaded_book.tree_scroll or {}
        merged.book.tree_scroll = {}
        for _, tab in ipairs({ 'mission', 'quest', 'eminence' }) do
            local y = tonumber(src_tsc[tab]) or 0
            if y < 0 then y = 0 end
            merged.book.tree_scroll[tab] = y
        end
    end
    do
        -- 0.1.69：リピートの列を外す（normalize が知らない列として落とす）。
        -- 前の初期の並びのままだった保存は、新しい初期の並びにする。自分で並べ替えた保存は、その並びのまま
        local lc = type(loaded.book) == 'table' and loaded.book.columns or nil
        if type(lc) == 'table' and (tonumber(loaded.defaults_rev) or 1) < 3 then
            local same = #lc == #settings.OLD_BOOK_COLUMNS
            for i, k in ipairs(settings.OLD_BOOK_COLUMNS) do if lc[i] ~= k then same = false end end
            if same then lc = nil end
        end
        merged.book.columns = settings.normalize_columns(lc)
    end
    merged.book.hidden = settings.normalize_hidden(type(loaded.book) == 'table' and loaded.book.hidden or nil, true)
    merged.book.collapsed = settings.normalize_collapsed(type(loaded.book) == 'table' and loaded.book.collapsed or nil)
    merged.book.col_widths = settings.normalize_col_widths(type(loaded.book) == 'table' and loaded.book.col_widths or nil,
        settings.stale_narrow_w(merged))
    -- 列の幅を自動で合わせる機能（0.1.209〜0.1.210）は 0.1.211 でなくした。保存に残っていても読まない
    merged.book.auto_col_width = nil
    merged.book.fit_w = nil
    merged.background_alpha = util.clamp(tonumber(merged.background_alpha) or 0.85, 0.3, 1.0)
    local loaded_alphas = type(loaded.alphas) == 'table' and loaded.alphas or {}
    merged.alphas = {}
    for _, area in ipairs(settings.ALPHA_AREAS) do
        local v = tonumber(loaded_alphas[area])
        -- 0.1.177〜：エミネンスの窓の背景。まだ無い保存はトラッカーの値
        if v == nil and area == 'eminence' then v = tonumber(loaded_alphas.tracker) end
        v = v or merged.background_alpha
        merged.alphas[area] = util.clamp(math.floor(v * 100 + 0.5) / 100, 0.3, 1.0)
    end
    -- 0.1.173（t251）：必要品まとめ・エリア入場の「いまここで進めること」をなくした。その設定は保存から消す
    for _, k in ipairs({ 'zone_entry', 'zone_entry_wait_seconds', 'zone_entry_max', 'zone_entry_repeat_minutes',
                         'zone_entry_seconds', 'suppress_in_combat', 'muted_zones' }) do
        merged.notify[k] = nil
    end
    -- 0.1.183〜：受注・完了のお知らせと効果音
    do
        local N, DN = merged.notify, settings.defaults().notify
        N.login_resume = (N.login_resume == nil) and DN.login_resume or (N.login_resume == true)
        N.popup = (N.popup == nil) and DN.popup or (N.popup == true)
        N.sound = (N.sound == nil) and DN.sound or (N.sound == true)
        N.popup_seconds = util.clamp(math.floor(tonumber(N.popup_seconds) or DN.popup_seconds), 3, 30)
        N.sound_volume = util.clamp(math.floor(((tonumber(N.sound_volume) or DN.sound_volume) / 10) + 0.5) * 10, 0, 100)
    end
    merged.windows.items, merged.windows.herenow = nil, nil
    merged.compass.visible = merged.compass.visible == true
    do
        local d = tonumber(merged.compass.max_dist)
        if not d then d = 30 end
        d = math.floor((d / 5) + 0.5) * 5
        merged.compass.max_dist = util.clamp(d, 5, 100)
    end
    merged.tracker.max_pins = util.clamp(math.floor(tonumber(merged.tracker.max_pins) or 10), 1, 30)
    merged.backup.keep = util.clamp(math.floor(tonumber(merged.backup.keep) or 10), 1, 100)
    merged.input.repeat_ms = util.clamp(math.floor(tonumber(merged.input.repeat_ms) or 200), 60, 1000)
    do
        local sc = require('src.core.shortcut')
        local ls = type(loaded.shortcut) == 'table' and loaded.shortcut or {}
        local list = (type(ls.open_book) == 'table') and sc.normalize(ls.open_book) or sc.normalize(sc.DEFAULT)
        -- 0.1.67：本を開くの初期値を R1＋△ → なし。改訂前の保存で R1＋△ のままなら なし へ
        -- （保存には「自分で変えたか」の印が無いので、前の初期値と同じ値を「変えていない」とみなす）
        if (tonumber(loaded.defaults_rev) or 1) < 2 and sc.same(list, sc.OLD_DEFAULT) then list = {} end
        merged.shortcut.open_book = json.array(list)
        for _, k in ipairs({ 'tracker_toggle', 'tracker_operate', 'compass_toggle', 'eminence_toggle' }) do
            -- 古い保存にキーが無ければなし（既存の割り当ては触らない）
            merged.shortcut[k] = json.array((type(ls[k]) == 'table') and sc.normalize(ls[k]) or {})
        end
        merged.shortcut.pass_to_game = ls.pass_to_game ~= false
    end
    -- 名声（0.1.66〜）：地域ごとに 1〜9 だけ残す。いつも {}（オブジェクト）で保存する
    do
        local lf = type(loaded.fame) == 'table' and loaded.fame or {}
        local out = json.object({})
        for area, e in pairs(lf) do
            local lv = type(e) == 'table' and tonumber(e.level) or nil
            if type(area) == 'string' and lv and lv >= 1 and lv <= 9 then
                out[area] = { level = math.floor(lv), at = type(e.at) == 'string' and e.at or nil,
                    npc = type(e.npc) == 'string' and e.npc or nil }
            end
        end
        merged.fame = out
    end
    merged.defaults_rev = 8
    if merged.tracker.align ~= 'left' and merged.tracker.align ~= 'right' then merged.tracker.align = 'right' end
    do
        -- エミネンス（0.1.172〜）
        local E = merged.eminence
        E.visible = E.visible == true
        E.collapsed = E.collapsed == true
        -- 0.1.203〜（defaults_rev 5）：「達成済みを非表示」の初期をオンに。
        -- 前の初期値（オフ）のままならオンへ。すでにオンの保存と、改訂後にオフにしたものはそのまま。
        do
            local raw = type(loaded.eminence) == 'table' and loaded.eminence.hide_completed
            if (tonumber(loaded.defaults_rev) or 1) < 5 then
                E.hide_completed = true
            elseif raw == nil then
                E.hide_completed = true
            else
                E.hide_completed = raw == true
            end
        end
        if E.filter ~= 'all' then E.filter = 'all' end   -- 0.1.179〜：このエリアもなくした
        E.near_pct = util.clamp(math.floor(tonumber(E.near_pct) or 80), 50, 95)
        if E.book_state ~= 'all' and E.book_state ~= 'not_accepted' and E.book_state ~= 'accepted' and E.book_state ~= 'completed' then
            E.book_state = 'all'
        end
        E.book_root = math.floor(tonumber(E.book_root) or -2)   -- いちばん上の分類でなければ、画面で「すべて」として出す
        E.book_favs_only = E.book_favs_only == true
        E.book_fav_only = nil   -- 前の「★だけ」（0.1.177〜0.1.181）。お気に入りは空から始める
        -- 0.1.193〜：列の並びと隠す列（くり返しの列は捨てる）
        -- 0.1.203〜：前の初期の並びのままだった保存は、新しい初期の並びにする。自分で並べ替えた保存はそのまま
        local ec = type(loaded.eminence) == 'table' and loaded.eminence.columns or nil
        if type(ec) == 'table' and (tonumber(loaded.defaults_rev) or 1) < 4 then
            local same = #ec == #settings.OLD_EMINENCE_COLUMNS
            for i, k in ipairs(settings.OLD_EMINENCE_COLUMNS) do if ec[i] ~= k then same = false end end
            if same then ec = nil end
        end
        E.columns = settings.normalize_eminence_columns(ec)
        E.hidden = settings.normalize_eminence_hidden(type(loaded.eminence) == 'table' and loaded.eminence.hidden or nil)
        -- 0.1.203〜：本で選んでいたレコード。無い・フィルタで隠れているときは開いたときに先頭へ
        local lid = tonumber(E.last_id)
        E.last_id = (lid and lid >= 1) and math.floor(lid) or nil
        if type(E.book_text) ~= 'string' then E.book_text = '' end
        local function ids(t, keep)
            local out = json.object({})
            if type(t) ~= 'table' then return out end
            for k, v in pairs(t) do
                local n = tonumber(k)
                if n and n >= 1 and n <= 4095 and n == math.floor(n) then
                    local kv = keep(v)
                    if kv ~= nil then out[tostring(n)] = kv end
                end
            end
            return out
        end
        E.pins = ids(E.pins, function (v) return v and true or nil end)
        E.favs = ids(E.favs, function (v) return v and true or nil end)
        E.failed = ids(E.failed, function (v)
            if type(v) ~= 'table' then return nil end
            local why = (v.why == 'unable' or v.why == 'not_impl') and v.why or nil
            if not why then return nil end
            return { why = why, at = type(v.at) == 'string' and v.at or nil }
        end)
    end
    if merged.tracker.view ~= 'list' and merged.tracker.view ~= 'tabs' then merged.tracker.view = 'list' end
    merged.tracker.show_close = merged.tracker.show_close ~= false
    do
        local n = math.floor(tonumber(merged.tracker.tab_chars) or 6)
        merged.tracker.tab_chars = math.max(3, math.min(16, n))
    end
    if merged.language ~= 'ja' and merged.language ~= 'en' then merged.language = 'ja' end
    -- 0.1.204〜（defaults_rev 6）：見た目の初期をクラシックに。
    -- 前の初期値（YunaUI風）のままなら移す。すでにクラシックの保存と、改訂後に YunaUI風へ戻したものはそのまま。
    do
        local raw = type(loaded) == 'table' and loaded.look
        if (tonumber(loaded.defaults_rev) or 1) < 6 then
            merged.look = 'classic'
        elseif raw ~= 'yunaui' and raw ~= 'classic' then
            merged.look = 'classic'
        else
            merged.look = raw
        end
    end
    if merged.book and merged.book.filters and merged.book.filters.state == 'unknown' then
        merged.book.filters.state = 'all'
    end
    if getmetatable(merged.notify.muted_zones) == nil then json.array(merged.notify.muted_zones) end
    -- 以前は予約で enabled=false のまま画面に出していなかった。
    -- 初めて地図を出す版ではオンにする。この版でオフにしたあとは introduced があるので、そのまま。
    local loaded_map = type(loaded) == 'table' and loaded.map
    if type(loaded_map) == 'table' and loaded_map.enabled == false and loaded_map.introduced == nil then
        merged.map.enabled = true
    end
    if merged.map then merged.map.introduced = 1 end
    -- 以前は予約で enabled=false のまま画面に出していなかった。初めて出す版ではオンにする。
    local loaded_marks = type(loaded) == 'table' and loaded.marks
    -- 0.1.58 までの「アイコンを出す」（enabled）は全部の表示のオン・オフだった。オフ（自分で切ったもの）なら4つともオフへ移す。
    -- 予約で enabled=false のまま（introduced なし）だった古い保存は、オンとして扱う（これまでと同じ）。
    local old_all_off = type(loaded_marks) == 'table' and loaded_marks.enabled == false and loaded_marks.introduced ~= nil
    if merged.marks then
        merged.marks.introduced = 1
        -- アイコンの大きさ（px）。16〜64。
        merged.marks.icon_size = util.clamp(math.floor(tonumber(merged.marks.icon_size) or 28), 16, 64)
        -- そのほか：アイコンは今までの値、クエスト名は 0 から（まだ無い古い保存）
        for _, k in ipairs(settings.OFFSET_KEYS) do
            local raw = type(loaded_marks) == 'table' and tonumber(loaded_marks[k]) or nil
            merged.marks[k] = settings.clamp_offset(raw)
        end
        -- 調べるオブジェクトの位置。まだ無い古い保存は、これまでの共通の値を引き継ぐ
        for i, k in ipairs(settings.OBJ_OFFSET_KEYS) do
            local raw = type(loaded_marks) == 'table' and tonumber(loaded_marks[k]) or nil
            -- アイコンの値は古い共通の値を引き継ぐ。クエスト名は 0 から
            if raw == nil and i <= 2 then raw = merged.marks[settings.OFFSET_KEYS[i]] end
            merged.marks[k] = settings.clamp_offset(raw)
        end
        -- 近くのオブジェクト名の位置（0.1.60〜）。まだ無い古い保存は、オブジェクトの行（アイコンと名前）の値を引き継ぐ
        for i, k in ipairs(settings.NEAR_OFFSET_KEYS) do
            local raw = type(loaded_marks) == 'table' and tonumber(loaded_marks[k]) or nil
            if raw == nil then raw = merged.marks[settings.OBJ_OFFSET_KEYS[i]] end
            merged.marks[k] = settings.clamp_offset(raw)
        end
        -- 文字の色。壊れた値は初めの色
        local dm = settings.defaults().marks
        for _, k in ipairs(settings.COLOR_KEYS) do
            merged.marks[k] = settings.normalize_rgb(type(loaded_marks) == 'table' and loaded_marks[k] or nil, dm[k])
        end
        for _, k in ipairs({ 'label_grad', 'under_grad' }) do
            merged.marks[k] = type(loaded_marks) == 'table' and loaded_marks[k] == true or false
        end
        -- 足元の輪（0.1.171〜）：大きさは 0.5〜3 倍（0.1 刻み）
        merged.marks.show_rings = merged.marks.show_rings ~= false
        do
            local v = tonumber(merged.marks.ring_size) or 1
            v = math.floor(v * 10 + 0.5) / 10
            if v < settings.RING_SIZE_MIN then v = settings.RING_SIZE_MIN elseif v > settings.RING_SIZE_MAX then v = settings.RING_SIZE_MAX end
            merged.marks.ring_size = v
        end
        -- 0.1.45 までの「名前の位置」は使わない（名前はアイコンといっしょに動く）
        merged.marks.obj_name_dx, merged.marks.obj_name_dy = nil, nil
        merged.marks.name_dx, merged.marks.name_dy = nil, nil
        local p = merged.marks.placement
        if p ~= 'above_name' and p ~= 'left' then
            merged.marks.placement = 'above'
        end
        -- 種類ごとの位置。まだ無い古い保存は、これまでの共通の位置を引き継ぐ。
        for _, role in ipairs(settings.MARK_ROLES) do
            local key = 'placement_' .. role
            local raw = type(loaded_marks) == 'table' and loaded_marks[key]
            if raw == 'above' or raw == 'above_name' or raw == 'left' then
                merged.marks[key] = raw
            else
                merged.marks[key] = merged.marks.placement
            end
        end
        -- 表示の4つ（0.1.59〜）。新しいキーがあればそのまま、無ければ古い設定から移す
        local lm = type(loaded_marks) == 'table' and loaded_marks or {}
        local function pick(new, fallback)
            if lm[new] == true or lm[new] == false then return lm[new] end
            return fallback
        end
        -- 古い「オブジェクトにアイコンを出す」（show_objects、その前は show_question）→ クエストのオブジェクト名
        local old_obj = true
        if lm.show_objects == false or lm.show_objects == true then old_obj = lm.show_objects
        elseif lm.show_question == false or lm.show_question == true then old_obj = lm.show_question end
        merged.marks.show_icons = pick('show_icons', not old_all_off)
        merged.marks.show_object_names = pick('show_object_names', old_obj and not old_all_off)
        merged.marks.show_nearby_names = (lm.show_nearby_names == true) and not old_all_off
        -- 古いオン・オフは残さない
        merged.marks.enabled, merged.marks.show_objects, merged.marks.show_question = nil, nil, nil
        -- クエスト名の表示。古い位置設定の「右にクエスト名」なら出す。
        local raw_sq
        if type(loaded_marks) == 'table' then
            raw_sq = loaded_marks.show_quest_name
        end
        if old_all_off and lm.show_icons == nil then
            merged.marks.show_quest_name = false
        elseif raw_sq == true or raw_sq == false then
            merged.marks.show_quest_name = raw_sq
        else
            local show = false
            if type(loaded_marks) ~= 'table' then
                show = true
            else
                if merged.marks.placement == 'above_name' then show = true end
                for _, role in ipairs(settings.MARK_ROLES) do
                    if merged.marks['placement_' .. role] == 'above_name' then
                        show = true
                    end
                end
            end
            merged.marks.show_quest_name = show
        end
    end
    return merged, (schema > SETTINGS_SCHEMA) and 'newer_schema' or nil
end

settings.MARK_ROLES = { 'talk', 'hunt', 'examine', 'guard' }

-- アイコンのタブの表示のオン・オフ（この順番で画面に出す）
settings.MARK_SWITCHES = { 'show_icons', 'show_quest_name', 'show_object_names', 'show_nearby_names' }

-- 4つのうち一つでもオンなら、目印を描く
function settings.marks_active(S)
    local m = S and S.marks
    if type(m) ~= 'table' then return false end
    return m.show_icons ~= false or m.show_quest_name == true or m.show_object_names ~= false or m.show_nearby_names == true
end

-- 文字の大きさを分けている場所（それ以外の窓は font_scale）
-- 背景の濃さの場所。ここに無い窓（必要品まとめ・お知らせ・入口）は「その他」
settings.ALPHA_AREAS = { 'book', 'detail', 'tracker', 'eminence', 'map', 'settings', 'other' }
settings.ALPHA_OF = { book = 'book', detail = 'detail', tracker = 'tracker', map = 'map', settings = 'settings', eminence = 'eminence', compass = 'tracker' }   -- コンパス（0.1.173〜）はトラッカーと同じ。エミネンスは 0.1.177〜 自分の値
function settings.alpha_for(S, win)
    local area = settings.ALPHA_OF[win] or 'other'
    local a = type(S.alphas) == 'table' and tonumber(S.alphas[area]) or nil
    if a == nil and area == 'eminence' and type(S.alphas) == 'table' then a = tonumber(S.alphas.tracker) end
    return a or tonumber(S.background_alpha) or 0.85
end

-- 一覧の列（ピン以外）。壊れた並びや足りない列は、決まった並びで補う
-- 0.1.69〜：リピートの列は無し（くり返しは名前の横の印）。初期の並びは 番号・名前・報酬・状態
settings.BOOK_COLUMNS = { 'no', 'name', 'rewards', 'state' }
-- 0.1.68 までの初期の並び（変えていない保存を新しい初期の並びへ移す）
settings.OLD_BOOK_COLUMNS = { 'state', 'repeat', 'no', 'name', 'rewards' }
function settings.normalize_columns(list)
    local known, seen, out = {}, {}, {}
    for _, k in ipairs(settings.BOOK_COLUMNS) do known[k] = true end
    if type(list) == 'table' then
        for _, k in ipairs(list) do
            if known[k] and not seen[k] then seen[k] = true; out[#out + 1] = k end
        end
    end
    for _, k in ipairs(settings.BOOK_COLUMNS) do
        if not seen[k] then out[#out + 1] = k end
    end
    return out
end

-- 隠した列。知らない列は捨て、全部隠れていたら全部出す
function settings.normalize_hidden(h, with_no)
    local out = {}
    if type(h) ~= 'table' then return out end
    local any_shown = false
    for _, k in ipairs(settings.BOOK_COLUMNS) do
        if h[k] == true then out[k] = true
        elseif k ~= 'no' or with_no then any_shown = true end
    end
    if not any_shown then return {} end
    return out
end

-- エミネンスの列（0.1.193〜）。くり返しは使わない
-- 0.1.203〜 初期の並び：受ける・解除、★、お気に入り、名前、進み、報酬。
-- 0.1.209〜：状態の列はなくした。保存の並び・隠す列・幅に残った 'state' は、知らない列として捨てる
settings.EMINENCE_COLUMNS = { 'action', 'pin', 'fav', 'name', 'progress', 'rewards' }
-- 0.1.202 までの初期の並び（変えていない保存を新しい初期の並びへ移す）
settings.OLD_EMINENCE_COLUMNS = { 'state', 'name', 'progress', 'rewards', 'pin', 'fav', 'action' }
function settings.normalize_eminence_columns(list)
    local known, seen, out = {}, {}, {}
    for _, k in ipairs(settings.EMINENCE_COLUMNS) do known[k] = true end
    if type(list) == 'table' then
        for _, k in ipairs(list) do
            if known[k] and not seen[k] then seen[k] = true; out[#out + 1] = k end
        end
    end
    for _, k in ipairs(settings.EMINENCE_COLUMNS) do
        if not seen[k] then out[#out + 1] = k end
    end
    return out
end

function settings.normalize_eminence_hidden(h)
    local out = {}
    if type(h) ~= 'table' then return out end
    local any_shown = false
    for _, k in ipairs(settings.EMINENCE_COLUMNS) do
        if h[k] == true then out[k] = true else any_shown = true end
    end
    if not any_shown then return {} end
    return out
end

-- たたんだ見出し（タブごと）。true だけ残す
function settings.normalize_collapsed(src)
    local out = json.object({})
    for _, tab in ipairs({ 'mission', 'quest', 'eminence' }) do
        local t = json.object({})
        local s = type(src) == 'table' and src[tab]
        if type(s) == 'table' then
            for k, v in pairs(s) do
                if v == true and k ~= nil then t[tostring(k)] = true end
            end
        end
        out[tab] = t
    end
    return out
end

-- 列の幅（px、タブごと）。16〜COL_WIDTH_MAX。知っている列だけ。
-- 0.1.210〜：文字サイズの上限を倍にしたので、幅の上限も 800 → 2400、
-- 「狭い列なのに広すぎる（昔の並び変更の名残）」の目安も一覧の文字サイズに合わせる（100% で 160px）
settings.COL_WIDTH_MAX = 2400
function settings.stale_narrow_w(S)
    local f = settings.font_for(S, 'list')
    if f < 1 then f = 1 end
    return 160 * f
end
settings.COL_WIDTH_KEYS = {
    mission = { 'pin', 'no', 'name', 'rewards', 'state' },
    quest = { 'pin', 'name', 'rewards', 'state' },
    eminence = { 'action', 'pin', 'fav', 'name', 'progress', 'rewards' },
}
function settings.normalize_col_widths(src, narrow_max)
    narrow_max = tonumber(narrow_max) or 160
    local out = json.object({})
    for _, tab in ipairs({ 'mission', 'quest', 'eminence' }) do
        local t = json.object({})
        local s = type(src) == 'table' and src[tab]
        local known = {}
        for _, k in ipairs(settings.COL_WIDTH_KEYS[tab]) do known[k] = true end
        if type(s) == 'table' then
            for k, v in pairs(s) do
                local w = tonumber(v)
                if known[k] and w and w >= 16 and w <= settings.COL_WIDTH_MAX then t[k] = math.floor(w + 0.5) end
            end
        end
        -- 狭い列に大きな幅が残っているのは、昔の並び変更の名残。そのタブは初期値に戻す
        local stale = false
        local narrow = { pin = true, fav = true, action = true, no = true, progress = true }
        for k, w in pairs(t) do
            if narrow[k] and w >= narrow_max then stale = true end
        end
        if stale then t = json.object({}) end
        out[tab] = t
    end
    return out
end

settings.FONT_AREAS = { 'book', 'list', 'detail', 'tracker', 'eminence', 'map', 'overhead_quest', 'overhead_name' }

-- 頭上の位置の調整（px）
settings.OFFSET_KEYS = { 'mark_dx', 'mark_dy', 'label_dx', 'label_dy' }          -- そのほか
settings.OBJ_OFFSET_KEYS = { 'obj_mark_dx', 'obj_mark_dy', 'obj_label_dx', 'obj_label_dy' }   -- 調べるオブジェクト
settings.NEAR_OFFSET_KEYS = { 'near_name_dx', 'near_name_dy' }   -- 近くのオブジェクト名（0.1.60〜）
-- 近くのオブジェクト名の位置
function settings.near_offsets(marks)
    marks = marks or {}
    local c = settings.clamp_offset
    return { name_dx = c(marks.near_name_dx), name_dy = c(marks.near_name_dy) }
end
-- 役割ごとの位置の調整（examine＝調べるオブジェクト、ほかは「そのほか」）
-- アイコンの値はアイコン（と、本体の位置に出す名前。同じ行でいっしょに動く）、クエスト名の値はクエスト名だけ
function settings.offsets_for(marks, role)
    marks = marks or {}
    local c = settings.clamp_offset
    local keys = (role == 'examine') and settings.OBJ_OFFSET_KEYS or settings.OFFSET_KEYS
    local mx, my = c(marks[keys[1]]), c(marks[keys[2]])
    return {
        mark_dx = mx, mark_dy = my, name_dx = mx, name_dy = my,
        label_dx = c(marks[keys[3]]), label_dy = c(marks[keys[4]]),
    }
end
settings.OFFSET_MIN, settings.OFFSET_MAX, settings.OFFSET_STEP = -256, 256, 2
-- 文字の色
settings.COLOR_KEYS = { 'label_color', 'label_color2', 'under_color', 'under_color2' }
-- 足元の輪の種類（0.1.171〜）。設定の並び：未受注・進行中・進行できない・目標達成・くり返し・受注できない・討伐・ミッション・ゲートガード・名声
settings.RING_KINDS = { 'sub', 'progress', 'blocked', 'complete', 'repeat', 'unavailable', 'hunt', 'main', 'guard', 'fame' }
settings.RING_SIZE_MIN, settings.RING_SIZE_MAX = 0.5, 3.0
for _, k in ipairs(settings.RING_KINDS) do settings.COLOR_KEYS[#settings.COLOR_KEYS + 1] = 'ring_' .. k end
-- その種類の輪の色 {r, g, b}
-- 初期値の印の設定（読むだけ。毎回 defaults() を作らない。0.1.210〜）
local marks_defaults_cache
function settings.marks_defaults()
    if not marks_defaults_cache then marks_defaults_cache = settings.defaults().marks end
    return marks_defaults_cache
end
function settings.ring_color(marks, kind)
    local d = settings.marks_defaults()
    local key = 'ring_' .. tostring(kind)
    if not d[key] then return nil end
    return settings.normalize_rgb((marks or {})[key], d[key])
end
function settings.normalize_rgb(c, def)
    def = def or { 248, 244, 232 }
    if type(c) ~= 'table' then return { def[1], def[2], def[3] } end
    local out = {}
    for i = 1, 3 do
        local v = tonumber(c[i])
        if not v then return { def[1], def[2], def[3] } end
        v = math.floor(v + 0.5)
        if v < 0 then v = 0 elseif v > 255 then v = 255 end
        out[i] = v
    end
    return out
end
-- 文字の色を絵に渡す形に：c1（始め）と、グラデーションのときだけ c2（終わり）
function settings.text_colors(marks, which)
    marks = marks or {}
    local d = settings.marks_defaults()
    local c1 = settings.normalize_rgb(marks[which .. '_color'], d[which .. '_color'])
    local c2 = nil
    if marks[which .. '_grad'] == true then
        c2 = settings.normalize_rgb(marks[which .. '_color2'], d[which .. '_color2'])
    end
    return c1, c2
end
function settings.clamp_offset(v)
    v = math.floor((tonumber(v) or 0) + 0.5)
    if v < settings.OFFSET_MIN then v = settings.OFFSET_MIN elseif v > settings.OFFSET_MAX then v = settings.OFFSET_MAX end
    return v
end

-- 0.1.210〜：4K の画面でも足りるように、どの場所も上限を前の倍に（下限と初期値はそのまま）。
-- 頭上の文字は 0.8〜3.2（前は 1.6）、一覧は 0.7〜3.0（前は 1.5）、窓とその他は 0.7〜4.0（前は 2.0）。
settings.FONT_MIN, settings.FONT_MAX = 0.7, 4.0
settings.OVERHEAD_FONT_MIN, settings.OVERHEAD_FONT_MAX = 0.8, 3.2
settings.LIST_FONT_MAX = 3.0
function settings.font_range(area)
    if area == 'overhead_quest' or area == 'overhead_name' then return settings.OVERHEAD_FONT_MIN, settings.OVERHEAD_FONT_MAX end
    if area == 'list' then return settings.FONT_MIN, settings.LIST_FONT_MAX end
    return settings.FONT_MIN, settings.FONT_MAX
end

-- その場所の文字の大きさ。分けていない場所や古い形は共通の font_scale。
function settings.font_for(S, area)
    if type(S) ~= 'table' then return 1.0 end
    local fonts = type(S.fonts) == 'table' and S.fonts or {}
    local f = tonumber(fonts[area])
    if f then return f end
    if area == 'overhead_quest' or area == 'overhead_name' then
        f = tonumber(fonts.overhead)
        if f then return f end
    end
    if area == 'eminence' then
        f = tonumber(fonts.tracker)
        if f then return f end
    end
    if area == 'list' then
        f = tonumber(fonts.book)
        if f then return math.max(settings.FONT_MIN, math.min(settings.LIST_FONT_MAX, f)) end
    end
    return tonumber(S.font_scale) or 1.0
end

function settings.normalize_placement(p)
    if p == 'above_name' or p == 'left' or p == 'above' then return p end
    return 'above'
end

-- その種類のマーク位置。種類の指定が無ければ、共通の位置（古い保存）に戻す。
function settings.placement_for(marks, role)
    if type(marks) ~= 'table' then return 'above' end
    local p
    if role then
        p = marks['placement_' .. tostring(role)]
    end
    if p ~= 'above' and p ~= 'above_name' and p ~= 'left' then
        p = marks.placement
    end
    return settings.normalize_placement(p)
end

return settings
