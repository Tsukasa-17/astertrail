--[[
  Astertrail - アプリ本体（共通部分）
  - platform（環境ごとの窓口）から渡された機能だけを使う。ゲームの API を直接呼ばない。
  - 進行の変更は progress の依頼だけ。保存は storage の手順で、キャラ名が分かってから。
]]

local json        = require('src.lib.json')
local util        = require('src.lib.util')
local data_mod    = require('src.core.data')
local progress_mod = require('src.core.progress')
local storage     = require('src.core.storage')
local settings_mod = require('src.core.settings')
local perf        = require('src.core.perf')
local i18n_mod    = require('src.core.i18n')
local diag        = require('src.core.diagnostics')
local fame_mod    = require('src.core.fame')
local focus       = require('src.ui.focus')
local settings_ui_mod = require('src.ui.settings_ui')
local window      = require('src.ui.window')
local W           = require('src.ui.widgets')
local maps_mod    = require('src.core.maps')
local exits_mod   = require('src.core.exits')
local zonedat_mod = require('src.core.zonedat')
local map_dat_mod = require('src.core.map_dat')
local marks_ui    = require('src.ui.marks')
local shortcut_mod = require('src.core.shortcut')
local update_mod  = require('src.core.update')
local game_log    = require('src.core.game_log')
local roe_mod     = require('src.core.roe')
local compass_mod = require('src.core.compass')
local build_flags = require('src.build_flags')
local marks_core  = require('src.core.marks')
local sound_mod   = require('src.core.sound')
local poss_mod    = require('src.core.possession')
local layouts_mod = require('src.core.layouts')

local app = {
    VERSION = '1.1.260',
    FLOOR_INTERVAL = 1.0,     -- いまいる階の確認（秒）。毎フレームは呼ばない
    FLOOR_AFTER_ZONE = 2.0,   -- ゾーンに入ってすぐは呼ばない（秒）
    SERVER = 'catseye',
    SAVE_DELAY = 3.0,
    REPEAT_DELAY = 0.35,
    SLIDER_SPEED = 2,         -- スライダーを左右で押し続けたときは、くり返しを2倍の速さに
    GAMELOG_AFTER_ZONE = 5.0, -- ゾーンに入ってから、ゲームの記録を読み直すまで（秒。0x056 が届き終わるのを待つ）
    GAMELOG_DEBOUNCE = 0.5,   -- 0x056 が届いてから当てるまで（続けて届く分をまとめる）
    ROE_BUSY = 5.0,           -- エミネンスの受ける・解除を押してから、答え（0x111・0x029）が届くまで同じ番号を押せない間の上限（秒。二度押しで二度送らない）
    ROE_AFTER = 1.0,          -- 答えが届いてからも、同じ番号を押せない間（秒、0.1.178〜。連打で逆の操作を送らない）
    ROE_UNABLE_WINDOW = 15.0, -- 番号の無い「受けられない」を、直前に押した番号のものとみなす間（秒）
    POPUP_MAX = 6,            -- 受注・完了のお知らせをためる数（0.1.183〜。あふれた分は出さない）
    POPUP_BULK = 3,           -- 1 回の当てで、これより多く変わったらまとめての読み直しとみなし、お知らせを出さない
    POPUP_AFTER_LOGIN = 15.0, -- ログイン・読み込みから、お知らせを出さない間（秒。最初の記録の当てで出さない）
    POPUP_FADE = 0.35,        -- お知らせの出現・消滅（秒。イーズアウト。0.1.197〜）
    PUBLIC = build_flags.public == true,   -- 公開版（t225：手で状態・手順を変える操作を出さない）
}

local P            -- platform
local D            -- data
local PR           -- progress
local I            -- i18n
local LAY          -- マイレイアウトのスロット（0.1.194〜。キャラの config に layouts.json）
local S            -- settings（今のキャラ、または初期値）
local T            -- 翻訳関数

local state = {
    poss = { snap = nil, due = nil, scans = 0 },   -- 所持（0.1.184〜。入れ物を読んだ結果のまとめ）
    ready = false,            -- キャラが分かり、記録を読み終えた
    character = nil,          -- { server, name }
    char_folder = nil,
    char_dir = nil,
    open = { book = false, detail = false, settings = false, map = false },  -- detail は「詳細だけ」の窓
    active = nil,             -- 操作中の窓（キー・パッドを受け取る）
    stack = {},               -- 開いた窓の重なり（操作した順。閉じたら下へ戻る）
    detail_quest = nil,
    detail_from = nil,
    resume = nil,
    compass = nil,        -- コンパスの行（0.1.173〜。app.tick_compass が作る）
    compass_due = 0,
    confirm = nil,
    suggest_complete = nil,
    branch = nil,
    flash = nil,
    save_error = nil,
    recovered = nil,
    read_only = nil,
    progress_due = nil,
    settings_due = nil,
    -- ゲームのメニュー（vana.gameui）
    missionm_open = false,    -- ミッションの窓が開いている（閉じる途中のちらつきは数えない）
    missionm_closed_at = nil,
    pending_book = nil,       -- 次の tick で本を開く（'mission' / 'toggle'）
    menu_captured = false,    -- ゲームのメニューへの入力を止めている
    book_hidden_for_menu = false, -- ゲームのメニューが開いている間、本を一時的に隠している（0.1.231〜）
    book_keep_over_menu = false, -- メニューがすでに開いているときに本／設定を出した（0.1.233〜）。隠さない・入力を取る
    menu_resume_active = nil, -- メニューが閉じたら戻す操作先（本・設定・トラッカーなど）
    chat_open = false,
    gameui_note = nil,        -- コンフィグのボタンの様子（設定画面に出す）
    last_zone = nil,
    first_zone_pending = false,
    zone_entered_at = {},
    held = nil,
    text_active = false,
    now = 0,
    last_poll = -1,
    player = nil,
    floor = nil,              -- いまいる階 { zone_id, floor_id, map_n, why }
    floor_at = nil,
    -- ゲームのクエスト・ミッションの記録（0.1.169〜、t223）
    glog = { snap = nil, mem_due = nil, due = nil, packets = 0, syncs = 0, changed = 0, last = nil, why = nil,
             based = false, login_at = nil },
    -- 受注・完了のお知らせ（0.1.183〜、t295）。先頭だけ出す { kind, quest, next, shown_at, hide_at }
    popups = {},
    popup_back = nil,         -- お知らせを操作する前に操作していた窓
    -- エミネンス・レコード（0.1.172〜、t243）
    roe = { db = nil, db_lang = nil, db_why = nil, active = nil, complete = nil, parts = {}, src = nil,
            mem_due = nil, packets = 0, sent = {}, last_send = nil, game_sent = nil,
            unity = nil, leader = nil },   -- 0.1.224〜：0x110 の組・週 { shared, week, day_at, week_at }、0x061 のリーダー
}
app.state = state
local SC = shortcut_mod.new()   -- パッドのショートカットの判定（本を開く）
-- 0.1.61〜：ショートカットは3つ。それぞれ判定を持つ（ボタン待ちは一度に一つだけ）
local SC_KEYS = { 'open_book', 'tracker_toggle', 'tracker_operate', 'eminence_toggle', 'compass_toggle' }
local SCS = {
    open_book = SC, tracker_toggle = shortcut_mod.new(), tracker_operate = shortcut_mod.new(),
    eminence_toggle = shortcut_mod.new(), compass_toggle = shortcut_mod.new(),
}
app.SHORTCUT_KEYS = SC_KEYS

local OPERABLE = { book = true, detail = true, settings = true, tracker = true, resume = true, map = true, popup = true, compass = true }

-- 窓の重なり（操作した順）。閉じたら、その下の開いている窓へ操作を戻す
local STACKABLE = { book = true, detail = true, settings = true, map = true }

local function stack_remove(name)
    local st = state.stack
    for i = #st, 1, -1 do if st[i] == name then table.remove(st, i) end end
end


---------------------------------------------------------------------------
-- 起動
---------------------------------------------------------------------------

function app.init(platform)
    P = platform
    local base = P.addon_dir()
    D = data_mod.load(P.fs, base .. 'data' .. P.fs.sep)
    I = i18n_mod.new(P.fs, base .. 'locales' .. P.fs.sep)
    T = I:fn()
    S = settings_mod.defaults()
    PR = progress_mod.new({
        data = D,
        clock = { now = os.time, iso = util.iso_time },
        max_pins = function () return S.tracker.max_pins end,
        addon_version = app.VERSION,
        on_change = function () app.schedule_progress_save() end,
    })
    for _, e in ipairs(D.errors) do diag.log('data', e.file .. ': ' .. tostring(e.why)) end
    for _, w in ipairs(D.warnings) do diag.log('data', w) end
    local caps = P.capabilities()
    diag.set_capability('inventory', caps.inventory, caps.inventory_note)
    diag.set_capability('gamepad', caps.gamepad, caps.gamepad_note)
    return app
end

function app.t(key, params) return T(key, params) end
function app._settings() return S end   -- 開発用（テストから読む）
function app._progress() return PR end   -- 開発用（テストから読む）
function app._data() return D end   -- 開発用（テストから読む）

---------------------------------------------------------------------------
-- キャラ別の読み込み・保存
---------------------------------------------------------------------------

local function char_paths()
    local root = P.config_dir()
    if not root or not state.char_folder then return nil end
    local sep = P.fs.sep
    local dir = root .. state.char_folder .. sep
    return {
        root = root, dir = dir,
        progress = dir .. 'progress.json',
        settings = dir .. 'settings.json',
        backups = dir .. 'backups' .. sep,
    }
end

function app.on_login(name)
    state.character = { server = app.SERVER, name = name }
    state.char_folder = app.SERVER .. '_' .. util.safe_name(name)
    state.read_only = nil
    state.recovered = nil
    state.save_error = nil
    local paths = char_paths()
    if not paths then
        -- 設定の親フォルダが分からない時は保存しない（読み込みもしない）
        state.read_only = 'no_config_dir'
        PR:reset(state.character)
        PR:set_read_only('no_config_dir')
        state.ready = true
        diag.log('save', 'config dir unknown')
        return
    end
    P.fs.mkdir(paths.root)
    P.fs.mkdir(paths.dir)

    -- 設定
    local sv, sinfo = storage.load_json(P.fs, paths.settings, nil, nil, util.stamp())
    local merged, snote = settings_mod.merge(sv)
    S = merged
    if not S.book.remember_filters then
        S.book.filters = settings_mod.defaults().book.filters
    end
    if snote == 'newer_schema' then state.settings_read_only = true end
    I:set_language(S.language)
    window.reapply()
    require('src.ui.book').reset_search()
    app.load_layouts()

    -- 進行
    PR:reset(state.character)
    local pv, pinfo = storage.load_json(P.fs, paths.progress, paths.backups, 'progress-', util.stamp())
    if pv then
        local ok, why = PR:adopt(pv, state.character)
        if not ok then
            if why == 'character_mismatch' then
                PR:reset(state.character)
                PR:set_read_only('character_mismatch')
                state.read_only = 'character_mismatch'
            else
                PR:reset(state.character)
                PR:set_read_only('broken')
                state.read_only = 'broken'
            end
        elseif why == 'newer_schema' then
            state.read_only = 'newer_schema'
        end
        if ok and PR.steps_migrated then
            -- 0.1.189〜：完了しているものの手順を全部チェック済みにした（1回だけ）。印を残すため保存する
            diag.log('save', 'checked steps of completed on load: ' .. tostring(PR.steps_done_on_load or 0))
            app.schedule_progress_save()
        end
        if ok and (PR.unpinned_on_load or 0) > 0 then
            diag.log('save', 'unpinned completed on load: ' .. tostring(PR.unpinned_on_load))
            app.schedule_progress_save()
        end
        if pinfo.source ~= 'main' then
            state.recovered = pinfo.source
            diag.log('save', 'recovered from ' .. tostring(pinfo.source))
        end
    elseif pinfo.source == 'none' then
        -- どれも読めない：読み取り専用で起動し、上書きしない
        PR:set_read_only('all_broken')
        state.read_only = 'all_broken'
        for _, e in ipairs(pinfo.errors or {}) do diag.log('save', e) end
    end
    state.ready = true
    state.first_zone_pending = true
    state.glog.mem_due = state.now   -- 読み込み・ログインのとき、ゲームの記録を読み直す
    state.glog.based, state.glog.login_at = false, state.now   -- 最初の当ての分ではお知らせを出さない（0.1.183〜）
    state.popups, state.popup_back = {}, nil
    state.roe.mem_due = state.now    -- エミネンスも（0.1.172〜）
    diag.log('session', 'login ' .. state.char_folder)
end

function app.on_logout()
    app.save_all('logout')
    state.ready = false
    state.character = nil
    state.char_folder = nil
    state.resume, state.confirm, state.branch = nil, nil, nil
    state.last_zone = nil
    state.glog.snap, state.glog.mem_due, state.glog.due = nil, nil, nil
    state.glog.based = false
    state.popups, state.popup_back = {}, nil
    state.roe.active, state.roe.complete, state.roe.parts, state.roe.mem_due = nil, nil, {}, nil
    state.roe.sent, state.roe.last_send = {}, nil
    PR:reset(nil)
    S = settings_mod.defaults()
    LAY = layouts_mod.empty_slots()
    I:set_language(S.language)
    window.reapply()
    app.release()
end

function app.schedule_progress_save()
    state.progress_due = state.now + app.SAVE_DELAY
end

function app.mark_settings_dirty()
    if not state.settings_due then state.settings_due = state.now + app.SAVE_DELAY end
end

function app.save_progress(reason)
    state.progress_due = nil
    if not state.ready or not state.character then return false end
    if PR.read_only then return false end
    local paths = char_paths()
    if not paths then return false end
    local ok, why = storage.save_json(P.fs, paths.progress, PR:snapshot())
    if ok then
        state.save_error = nil
        storage.daily_backup(P.fs, paths.progress, paths.backups, 'progress-', S.backup.keep)
    else
        -- 一度だけ知らせ、内容はメモリに残して次の機会に再試行
        if not state.save_error then app.flash(T('save.failed_once')) end
        state.save_error = why
        diag.log('save', 'progress failed: ' .. tostring(why))
    end
    return ok
end

function app.save_settings()
    state.settings_due = nil
    if not state.ready or not state.character or state.settings_read_only then return false end
    local paths = char_paths()
    if not paths then return false end
    local ok, why = storage.save_json(P.fs, paths.settings, S)
    if not ok then diag.log('save', 'settings failed: ' .. tostring(why)) end
    return ok
end

function app.save_all(reason)
    if state.progress_due or reason == 'zone' or reason == 'unload' or reason == 'logout' or reason == 'manual' then
        app.save_progress(reason)
    end
    if state.settings_due or reason == 'unload' or reason == 'logout' or reason == 'manual' then
        app.save_settings()
    end
end

---------------------------------------------------------------------------
-- マイレイアウト（0.1.194〜）。キャラのフォルダの layouts.json。進行・ピンなどは入れない
---------------------------------------------------------------------------

local function layouts_file()
    local paths = char_paths()
    if not paths then return nil end
    return paths.dir .. layouts_mod.FILE
end

function app.load_layouts()
    LAY = layouts_mod.empty_slots()
    local path = layouts_file()
    if not path then return LAY end
    local v = storage.load_json(P.fs, path, nil, nil, util.stamp())
    LAY = layouts_mod.normalize(v).slots
    return LAY
end

function app.layout_slots()
    if not LAY then LAY = layouts_mod.empty_slots() end
    return LAY
end

function app.save_layouts()
    local paths = char_paths()
    if not paths or state.settings_read_only then return false end
    P.fs.mkdir(paths.root)
    P.fs.mkdir(paths.dir)
    if not LAY then LAY = layouts_mod.empty_slots() end
    local ok, why = storage.save_json(P.fs, paths.dir .. layouts_mod.FILE, layouts_mod.file_of(LAY))
    if not ok then diag.log('save', 'layouts failed: ' .. tostring(why)) end
    return ok
end

function app.set_layout_name(i, name)
    local slots = app.layout_slots()
    local s = slots[tonumber(i)]
    if not s then return false end
    name = layouts_mod.clean_name(name)
    if s.name == name then return false end
    s.name = name
    app.save_layouts()
    return true
end

function app.save_layout(i)
    local slots = app.layout_slots()
    i = tonumber(i)
    local s = slots[i]
    if not s then return false, 'bad_slot' end
    if not char_paths() then return false, 'no_dir' end
    s.saved = true
    s.at = util.stamp()
    s.settings = layouts_mod.capture_settings(S)
    s.open = layouts_mod.capture_open(state, S)
    if not app.save_layouts() then return false, 'write' end
    return true
end

function app.load_layout(i)
    local slots = app.layout_slots()
    local s = slots[tonumber(i)]
    if not s or not s.saved or type(s.settings) ~= 'table' then return false, 'empty' end
    local keep_settings = state.open and state.open.settings == true
    layouts_mod.apply_settings(S, s.settings)
    if I and S.language then I:set_language(S.language) end
    window.reapply()
    local open = type(s.open) == 'table' and s.open or {}
    app.set_tracker_visible(open.tracker == true)
    app.set_eminence_visible(open.eminence == true)
    app.set_compass_visible(open.compass == true)
    if S.entry_icon then S.entry_icon.visible = open.entry == true end
    if open.detail == true then app.open_window('detail') else app.close_window('detail') end
    if open.map == true then app.open_window('map') else app.close_window('map') end
    if keep_settings then
        if not state.open.book then app.open_window('book') end
        if not state.open.settings then app.open_window('settings') end
    elseif open.book == true then
        if not state.open.book then app.open_window('book') end
    else
        if state.open.book then app.close_window('book') end
    end
    app.mark_settings_dirty()
    return true
end

---------------------------------------------------------------------------
-- 依頼（画面 → progress）
---------------------------------------------------------------------------

function app.flash(text)
    state.flash = { text = text, until_t = state.now + 4 }
end

local CODE_MSG = {
    read_only = 'msg.read_only', no_character = 'status.waiting', unknown_quest = 'msg.unknown_quest',
    unknown_step = 'msg.unknown_step', locked = 'msg.locked', pin_limit = 'msg.pin_limit',
    unimplemented = 'msg.unimplemented',
    no_completion = 'msg.no_completion', not_pinned = 'msg.not_pinned', bad_state = 'msg.unknown_quest',
    not_accepted = 'msg.step_not_accepted',   -- 0.1.180〜：未受注のクエストの手順はチェックできない
}

-- 手で状態・手順を変える操作（公開版では受けない。t225）
-- 手順の「今の手順」を選ぶ・◀▶ は案内なので残す（前の手順へのチェックはそれに付いてくる）。
app.MANUAL_ACTIONS = { set_state = true, check_step = true, uncheck_step = true, start_cycle = true }

function app.manual_checks()
    return not app.PUBLIC
end

-- 手で状態を変えるボタン（未受注・受注中・完了）を出すか（0.1.187〜、t308。デバッグ用。公開版はいつも出さない）
function app.state_buttons()
    return not app.PUBLIC and S ~= nil and type(S.debug) == 'table' and S.debug.state_buttons == true
end

function app.set_state_buttons(on)
    if app.PUBLIC or not S then return false end
    S.debug = S.debug or {}
    S.debug.state_buttons = on and true or false
    app.mark_settings_dirty()
    return true
end

function app.request(action, qid, arg, confirmed)
    local r
    if app.PUBLIC and app.MANUAL_ACTIONS[action] then return { ok = false, code = 'public_build' } end
    if action == 'set_state' then r = PR:set_state(qid, arg)
    -- 0.1.60〜：チェックは前の手順にも付け、外すときはそこから後も外す。決定は前を全部チェックしてそこへ戻る
    elseif action == 'check_step' then r = PR:check_through(qid, arg)
    elseif action == 'uncheck_step' then r = PR:uncheck_from(qid, arg)
    elseif action == 'set_current_step' then r = PR:decide_step(qid, arg)
    -- トラッカーの ◀▶（0.1.61〜）：決定と同じ。前へ戻るときも「たどれない」とは言わない
    elseif action == 'go_step' then
        r = PR:decide_step(qid, arg)
        if r.ok and r.code == 'not_reachable' then r.code = 'ok' end
    elseif action == 'set_route' then r = PR:set_route(qid, arg)
    elseif action == 'pin' then
        if require('src.ui.book').is_marked_unimplemented(S, qid) then
            r = { ok = false, code = 'unimplemented' }
        else
            r = PR:pin(qid)
        end
    elseif action == 'unpin' then r = PR:unpin(qid)
    elseif action == 'move_pin' then r = PR:move_pin(qid, arg)
    elseif action == 'lock' then r = PR:lock(qid, true)
    elseif action == 'unlock' then r = PR:unlock(qid)
    elseif action == 'start_cycle' then r = PR:start_cycle(qid, confirmed)
    else return { ok = false, code = 'bad_action' } end

    if not r.ok then
        if r.code == 'public_build' then
            -- 公開版では出していない操作（知らせない）
        elseif r.code == 'need_confirm' then
            state.confirm = { quest = qid, action = 'start_cycle', text = T('detail.cycle_confirm') }
        else
            app.flash(T(CODE_MSG[r.code] or 'msg.failed', { limit = r.limit }))
        end
        return r
    end
    if action == 'set_state' and arg == 'completed' then state.suggest_complete = nil end
    if r.unpinned then app.flash(T('msg.auto_unpinned')) end
    if r.kept_by_lock then app.flash(T('msg.kept_by_lock')) end
    if r.promoted then app.flash(T('msg.promoted')) end
    if r.suggest_complete then state.suggest_complete = qid end
    if r.code == 'not_reachable' then app.flash(T('msg.not_reachable')) end
    return r
end

-- トラッカーのチェック：次が1つならそこを今の手順に。分岐なら選ぶまで待つ
function app.tracker_check(qid, sid)
    local r = app.request('check_step', qid, sid)
    if not r.ok then return end
    local s = D:step(sid)
    if s and #s.next == 1 then
        PR:set_current_step(qid, s.next[1])
    elseif s and #s.next > 1 then
        state.branch = { quest = qid, options = s.next }
    end
end

-- トラッカーの ◀（dir<0）▶（dir>0）（0.1.61〜）
-- ▶：次が1つならそこを決定（前の手順に自動でチェック）。分岐でルート未定なら選ぶ行を出す。
--     最後の手順なら、その手順にチェックを付けて「完了にするなら詳細から」と知らせる（自動で完了にはしない）。
-- ◀：前の手順を決定（その手順から後のチェックは外れる）。全部済みなら最後の手順へ戻る。
function app.tracker_step(qid, dir)
    if not PR then return nil end
    local nav = PR:step_nav(qid)
    state.branch = nil
    if dir < 0 then
        if nav.prev then
            state.suggest_complete = nil
            return app.request('go_step', qid, nav.prev.id)
        end
        return nil
    end
    if nav.done or not nav.cur then return nil end
    if nav.branch then
        state.branch = { quest = qid, options = nav.branch }
        return { ok = true, code = 'branch' }
    end
    if nav.last then
        if app.PUBLIC then return nil end   -- 公開版：完了はゲームの記録から
        if PR:steps_locked(qid) then return nil end   -- 未受注のクエスト：最後の手順にチェックを付けない（0.1.180〜）
        return app.request('check_step', qid, nav.cur.id)
    end
    if nav.next then return app.request('go_step', qid, nav.next.id) end
    return nil
end

---------------------------------------------------------------------------
-- 窓と操作モード
---------------------------------------------------------------------------

-- from：どこから開いたか（今は使っていない。0.1.173 で必要品まとめをなくした）
function app.open_window(name, from)
    if name == 'tracker' then
        -- 表示は設定とピン。ここでは何もしない。
        return
    end
    -- 設定（0.1.175〜）：別の窓は作らず、本の一覧と詳細の場所に出す。本が閉じていれば先に開く
    if name == 'settings' and not state.open.book then app.open_window('book') end
    -- 本を開き直したら（ショートカット・ミッションの窓から等）、設定は閉じて一覧に戻す
    if name == 'book' and state.open.settings then
        state.open.settings = false
        stack_remove('settings')
        if state.active == 'settings' then state.active = 'book' end
    end
    local was_open = state.open[name] == true
    state.open[name] = true
    -- 設定：オフなら開くたびに最初のタブから。本はいつも前回のタブ・行・一覧の位置に戻す（0.1.203〜）
    if not was_open and not S.remember_position then
        if name == 'settings' then
            focus.reset('settings')
            settings_ui_mod.reset_tab()
        end
    end
    if name == 'book' then
        -- すでに開いているときに開くだけ呼ばれても、選択やフォーカスは動かさない（受ける／解除のあとなど）
        if not was_open then
            focus.reset('book')
            state.book_restore_scroll = true
        end
        -- 本には右側に詳細があるので、詳細だけの窓は閉じる（二つ並べない）
        if state.open.detail then state.open.detail = false; state.confirm = nil end
        -- ゲームのメニューがすでに開いているときに出した本は隠さない（メインメニューの項目など。0.1.233〜）。
        -- 先に本が出ていて、そのあとメニューを開いたときだけ隠す（0.1.231）。
        if state.game_menu_open == true then
            local was_hidden = state.book_hidden_for_menu == true
            state.book_hidden_for_menu = false
            state.book_keep_over_menu = true
            if was_hidden then
                window.reapply('book')
                state.book_restore_scroll = true
            end
        end
    end
    app.activate(name)
end

function app.close_window(name)
    -- 本を閉じるときは、中に出していた設定も閉じる
    if name == 'book' and state.open.settings then app.close_window('settings') end
    if name == 'book' then
        -- メニューが開いているあいだに本を閉じたら、メニューを閉じても出さない（0.1.231〜）
        state.book_hidden_for_menu = false
        state.book_keep_over_menu = false
        if state.menu_resume_active == 'book' or state.menu_resume_active == 'settings' then
            state.menu_resume_active = nil
        end
    end
    -- 本から開いた詳細だけを閉じるときは、本に戻る（トラッカーから開いたときは戻さない）
    local reopen_qid = nil
    if name == 'detail' and state.detail_return_book and state.detail_quest then
        reopen_qid = state.detail_quest
    end
    if name == 'tracker' then
        -- 表示は設定で決める。操作中なら終えるだけ。
        if state.active == 'tracker' then app.release() end
        return
    else
        state.open[name] = false
    end
    if name == 'detail' then
        state.confirm = nil
        state.detail_return_book = nil
    end
    local map_back = nil
    if name == 'map' then
        map_back = state.map_from or (state.map and state.map.from)
        state.map = nil
        state.map_from = nil
    end
    if reopen_qid then
        app.select_in_book(reopen_qid)
        return
    end
    if state.active ~= name then stack_remove(name) end
    if state.active == name then
        -- 一つ前の画面へ戻る（なければ操作を終えて入力をゲームへ返す）
        local back = nil
        if name == 'detail' and state.detail_from and (state.open[state.detail_from] or
            (state.detail_from == 'tracker' and app.tracker_on())) then back = state.detail_from
        elseif name == 'map' and map_back and (state.open[map_back] or (map_back == 'tracker' and app.tracker_on())) then back = map_back
        end
        stack_remove(name)
        if not back then
            -- 下に開いている窓があれば、そこへ戻す（設定→本を開く→本を閉じる＝設定へ）
            local st = state.stack
            for i = #st, 1, -1 do
                local w = st[i]
                if state.open[w] then back = w break end
                table.remove(st, i)
            end
        end
        if back then app.activate(back) else app.release() end
    end
end

function app.close_all()
    for k in pairs(state.open) do state.open[k] = false end
    -- トラッカーは HUD なので残す（隠すのは設定の「トラッカーを出す」か /astertrail tracker hide）
    state.resume = nil
    state.map, state.map_from = nil, nil
    state.stack = {}
    -- メニューが開いているあいだに自分で閉じたら、メニューを閉じても本は出さない（0.1.231〜）
    state.book_hidden_for_menu = false
    state.book_keep_over_menu = false
    if state.menu_resume_active == 'book' or state.menu_resume_active == 'settings' then
        state.menu_resume_active = nil
    end
    app.release()
end

-- 本を開き、その項目を選んで右側に詳細を出す（トラッカー・お知らせ・必要品まとめからも）
-- from_book=true は本の一覧で選んだ時（選択の位置はそのまま）
function app.select_in_book(qid, from_book)
    local q = D:quest(qid)
    if not q then return end
    if S.book.last_row ~= qid then
        S.book.last_row = qid
        app.mark_settings_dirty()
    end
    state.suggest_complete = (state.suggest_complete == qid) and qid or nil
    if state.confirm and state.confirm.quest ~= qid then state.confirm = nil end
    if from_book and state.open.book then
        focus.set('book', 'row_' .. qid, false)
        app.activate('book')
        return
    end
    app.open_window('book')
    -- 決まったクエストを出すときは、覚えていた位置ではなくその項目へ（トラッカー・コンパスからなど）
    state.book_fresh = false
    state.book_restore_scroll = false
    state.book_expand_path = true
    state.book_scroll_to_sel = true
    state.book_jump_row = true
    if S.book.tab ~= q.kind then S.book.tab = q.kind; app.mark_settings_dirty() end
    focus.set('book', 'row_' .. qid, true)
end

-- 詳細だけの窓（本の一覧でダブルクリック／「詳細だけ表示」、トラッカーのクリック）。本は閉じる
-- from == 'tracker' / 'compass' のときは、閉じても本は開かない
function app.open_detail_solo(qid, from)
    if not D:quest(qid) then return end
    if S.book.last_row ~= qid then
        S.book.last_row = qid
        app.mark_settings_dirty()
    end
    state.open.book = false
    if state.open.settings then state.open.settings = false; stack_remove('settings') end   -- 設定は本の中（0.1.175〜）
    if state.detail_quest ~= qid then focus.reset('detail') end
    state.detail_quest = qid
    -- トラッカーをパッドで操作中に開いたら、閉じたときトラッカーの操作へ戻る（0.1.61〜）
    state.detail_from = (from == 'tracker' and state.active == 'tracker') and 'tracker' or nil
    -- トラッカー・コンパス（0.1.177〜）から開いたときは、閉じても本は開かない
    state.detail_return_book = (from ~= 'tracker' and from ~= 'compass')
    state.open.detail = true
    state.suggest_complete = (state.suggest_complete == qid) and qid or nil
    app.activate('detail')
end

-- 以前の呼び方（from は使わない）：本の右側に出す
function app.open_detail(qid, from)
    app.select_in_book(qid)
end

-- 地図の窓。qid / step_id があればその場所、なければ選んでいる項目、それもなければ今いるエリア
-- opts.mob（0.1.171〜）：モンスターの相手の id。地図で、近くにいる同じ名前の相手を探して出す
function app.open_map(qid, step_id, loc, opts)
    if S.map and S.map.enabled == false then
        P.print(T('map.disabled'))
        return
    end
    local q = qid and D:quest(qid) or nil
    if not q then
        local fallback = state.detail_quest or (S.book and S.book.last_row)
        q = fallback and D:quest(fallback)
    end
    local location, step
    if loc then
        location = loc
    else
        location, step = maps_mod.location_for(D, PR, q, step_id)
    end
    if not location and state.player and state.player.zone_id then
        location = {
            zone_id = state.player.zone_id,
            zone_name = D:zone_name(state.player.zone_id),
        }
    end
    state.map = {
        quest = q and q.id or nil,
        step = step_id or (step and step.id) or nil,
        -- クエストも場所も無いときは、いまいるエリア（0.1.171〜。前は場所なしで開いていた）
        loc = loc or ((not q) and location or nil),
        map_n = nil,
        from = state.active,
    }
    local mtg = opts and opts.mob and D:target(opts.mob)
    if mtg and mtg.name_en then state.map.mob = { target = mtg.id, name = mtg.name_en } end
    state.map_from = state.active
    state.open.map = true
    app.activate('map')
end

-- 表示されている名前をクリップボードへ（アイテム名のクリックなど）
function app.copy_to_clipboard(text)
    text = tostring(text or '')
    if text == '' then return false end
    local imgui = package.loaded['imgui']
    local ok = false
    if imgui and imgui.SetClipboardText then
        ok = pcall(function () imgui.SetClipboardText(text) end)
    end
    if ok then
        P.print(T('tracker.copied', { name = text }))
        return true
    end
    P.print(T('tracker.copy_failed', { name = text }))
    return false
end

-- ピンがあり、設定で出すになっているときだけ真。
function app.tracker_on()
    return S and S.tracker and S.tracker.visible == true
        and PR and #PR:pinned_list() > 0
end

function app.set_tracker_visible(on)
    on = on and true or false
    if not S or not S.tracker then return end
    if S.tracker.visible ~= on then
        S.tracker.visible = on
        app.mark_settings_dirty()
    end
    if not on and state.active == 'tracker' then app.release() end
end

-- 本のボタンから：トラッカーを出す・隠す（0.1.62〜）。ピンが無ければ出しても見えないので知らせる
function app.toggle_tracker()
    local on = not (S.tracker.visible == true)
    app.set_tracker_visible(on)
    if on and PR and #PR:pinned_list() == 0 then
        app.flash(T('msg.tracker_shown_no_pins'))
    else
        app.flash(T(on and 'msg.tracker_shown' or 'msg.tracker_hidden'))
    end
    return on
end

-- トラッカーの操作に入る（0.1.170〜：1段目＝件を選ぶところから。前に件の中にいたら、その件）
function app.enter_tracker()
    if not app.tracker_on() then return false end
    if state.active ~= 'tracker' and PR then
        local tr = require('src.ui.tracker')
        local pins = PR:pinned_list()
        if S.tracker.view == 'tabs' then pins = { tr.current_tab({ state = state }, pins) } end
        -- 前に操作していた件（操作していないあいだはマウスで選択が動くので、そちらは見ない）
        local owner
        for _, q in ipairs(pins) do if q == state.tracker_last then owner = q end end
        local first = owner or pins[1]
        -- タブ表示（0.1.171〜）：件を選ぶ段は飛ばし、出ている件の中の名前から
        if first then focus.set('tracker', (S.tracker.view == 'tabs' and 'q_' or 'e_') .. first, true) end
    end
    app.activate('tracker')
    return true
end

function app.show_tracker(qid)
    -- 表示は設定とピン。ここでは選択位置だけ。
    if qid then focus.set('tracker', 'q_' .. qid, true) end
end

function app.activate(name)
    -- 設定は本の中に出す（0.1.175〜）。設定を出している本を押したら、操作は設定のまま
    if name == 'book' and state.open.settings and state.open.book then name = 'settings' end
    if OPERABLE[name] then
        -- ゲームのメニューが開いているあいだは操作を始めない（入力をゲームに渡す。0.1.231〜）。
        -- メニューの上に本を出しているときは操作する（0.1.233〜）。
        if state.game_menu_open == true and state.book_keep_over_menu ~= true then
            state.menu_resume_active = name
            state.active = nil
            state.held = nil
            app.sync_capture()
            return
        end
        state.active = name
        if STACKABLE[name] then
            stack_remove(name)
            state.stack[#state.stack + 1] = name
        end
    end
    app.sync_capture()
end

function app.release()
    state.active = nil
    state.held = nil
    app.sync_capture()
end

function app.operating()
    local a = state.active
    if not a then return false end
    if a == 'tracker' then return app.tracker_on() end
    if a == 'resume' then return state.resume ~= nil end
    if a == 'popup' then return state.popups[1] ~= nil end
    if a == 'compass' then return S and S.compass and S.compass.visible == true end
    return state.open[a] == true
end

-- 本を画面に出すか（開いていて、ゲームのメニューのせいで隠していない。0.1.231〜）
function app.book_visible()
    return state.open.book == true and state.book_hidden_for_menu ~= true
end

-- ゲームのメニューに入力を渡すか（本をメニューの上に出しているときは渡さない。0.1.233〜）
function app.menu_takes_input()
    return state.game_menu_open == true and state.book_keep_over_menu ~= true
end

-- platform から：キーを受け取りたいか（操作中で、文字入力中でない）
function app.want_keys()
    if app.menu_takes_input() then return false end
    return app.operating() and not state.text_active and not state.chat_open
end

-- 受注・完了のお知らせが出ているか（消えかけも含む。0.1.197〜）
function app.popup_visible()
    local p = state.popups[1]
    if not p or not p.shown_at then return false end
    return (S and S.notify and S.notify.popup == true) or p.preview == true
end

-- platform から：パッドを受け取りたいか（操作中で、設定でオン）
-- お知らせが出ている間は、遊んでいるときでも十字キー・スティックと決定・キャンセルで選べる（0.1.197〜）
function app.want_pad()
    if not (S and S.input and S.input.gamepad == true) or state.text_active or state.chat_open then return false end
    -- ゲームのメニューが開いているあいだは、パッドをゲームに渡す（0.1.231〜）。
    -- メニューの上に本を出しているときは本へ（0.1.233〜）。
    if app.menu_takes_input() then return false end
    return app.operating() or app.popup_visible()
end

local DIRS = { up = true, down = true, left = true, right = true }

-- 左右で、いま選んでいるのがスライダーか（押し続けを速くする）
function app.slider_held(action)
    local win = state.active
    -- 色えらびの中は、上下左右と LB/RB を速く
    if win ~= nil and focus.picker(win) then
        return DIRS[action] == true or action == 'section_next' or action == 'section_prev'
    end
    if action ~= 'left' and action ~= 'right' then return false end
    return win ~= nil and focus.is_adjust(win)
end

-- トラッカー（0.1.170〜）：決定で件の中へ、キャンセルで件へ戻る（もう一度でゲームへ）。タブ表示の LB/RB はタブを替える。
-- 使ったら true（使わなければ、いつもの動き）
function app.tracker_action(action)
    if not PR then return false end
    local tr = require('src.ui.tracker')
    local pins = PR:pinned_list()
    local tabs = S.tracker.view == 'tabs'
    if tabs and (action == 'section_next' or action == 'section_prev') then
        tr.step_tab({ state = state, settings = S }, pins, action == 'section_next' and 1 or -1)
        state.held = nil
        return true
    end
    local cur = focus.current('tracker')
    local owner, is_entry = tr.owner_of(cur, pins)
    if action == 'confirm' and owner and is_entry then
        focus.set('tracker', 'q_' .. owner, true)
        return true
    end
    -- タブ表示は件を選ぶ段がないので、キャンセルはそのままゲームへ（いつもの動き）
    if action == 'back' and owner and not is_entry and not tabs then
        focus.set('tracker', 'e_' .. owner, true)
        state.branch = nil
        return true
    end
    return false
end

-- 本（0.1.204〜）：一覧の見出しを階層で選び、キャンセルで一段上へ。いちばん上でキャンセルすると本を閉じる。
-- タブ（ミッション／クエスト／エミネンス）は 0.1.202 どおり上の行。肩ボタンで場所を回る。
function app.book_action(action)
    if state.open.settings then return false end
    local book = require('src.ui.book')
    if book.nav_action then return book.nav_action(action) end
    return false
end

local function do_action(action, win)
    win = win or state.active
    if not win then return end
    -- 色えらびが開いていれば、その中だけで動かす（キャンセルは色えらびだけ閉じる）
    if focus.picker_action(win, action) then
        if action == 'confirm' or action == 'back' then state.held = nil end
        return
    end
    -- プルダウンが開いていれば、その中だけで動かす（キャンセルは一覧だけ閉じる）
    if focus.dropdown_action(win, action) then
        if action ~= 'up' and action ~= 'down' then state.held = nil end
        return
    end
    if action == 'back' and win and focus.back_from_adjust(win) then
        -- スライダーの上では、まず同じ行の ↺ へ戻る（折りたたみのキャンセルより先）
        return
    end
    if win == 'settings' and (action == 'section_next' or action == 'section_prev')
        and settings_ui_mod.cycle_tab(action == 'section_next' and 1 or -1) then
        -- 設定の LB/RB（Tab/Shift+Tab）はタブを替える
        state.held = nil
    elseif win == 'settings' and settings_ui_mod.nav_action and settings_ui_mod.nav_action(action) then
        -- 設定の折りたたみ見出し（0.1.239〜）：左右で開閉、決定で中へ、キャンセルで見出しへ
        if action == 'confirm' or action == 'back' then state.held = nil end
    elseif win == 'tracker' and app.tracker_action(action) then
        -- トラッカーの2段の操作・タブの切り替え（0.1.170〜）
    elseif win == 'book' and app.book_action(action) then
        -- 本の見出しの階層操作（0.1.204〜）
    elseif DIRS[action] or action == 'section_next' or action == 'section_prev' then
        focus.move(win, action)
    elseif action == 'confirm' then
        focus.activate(win)
    elseif action == 'back' then
        -- スライダーの上では、まず同じ行の ↺ へ戻る（もう一度で閉じる）
        if focus.back_from_adjust(win) then return end
        if win == 'tracker' then app.release()
        elseif win == 'resume' then state.resume = nil; app.release()
        elseif win == 'popup' then app.popup_choose(false)
        elseif win == 'compass' then app.release()
        else app.close_window(win) end
    end
end

-- platform から：入力（action, pressed）。戻り値 true でゲームに渡さない
function app.input(action, pressed, source)
    -- ボタン待ちの間は、キーの「戻る」（Esc）で待つのをやめる
    if app.pad_capturing() and source == 'key' then
        if pressed and action == 'back' then app.shortcut_capture_cancel() end
        return app.operating()
    end
    local win = state.active
    if not app.operating() then
        -- 遊んでいるときに出たお知らせ：パッドだけ受け取る（キーは /astertrail notice か、ほかの窓の操作中）
        if source == 'pad' and app.want_pad() and app.popup_visible() then
            win = 'popup'
        else
            return false
        end
    end
    if source == 'pad' and not app.want_pad() then return false end
    if source == 'key' and not app.want_keys() then return false end
    if pressed then
        do_action(action, win)
        -- 閉じたなら、その場でゲームのメニューへ戻す
        if not app.operating() and not app.popup_visible() then app.sync_capture() end
        if DIRS[action] then
            local delay = app.REPEAT_DELAY
            if app.slider_held(action) then delay = delay / app.SLIDER_SPEED end
            state.held = { action = action, next_at = state.now + delay }
        end
    else
        if state.held and state.held.action == action then state.held = nil end
    end
    return true
end

---------------------------------------------------------------------------
-- パッドのショートカット（0.1.57〜。設定の「ショートカット設定」）
-- platform が XInput の押している集合を渡す。本が閉じていれば開き、自前のメニューが開いていればトラッカー以外を閉じる
---------------------------------------------------------------------------

state.pad_seen = false        -- パッドの入力が一度でも届いた
state.pending_shortcut = false

function app._shortcut() return SC end   -- 開発用（テストから読む）

-- 自前のメニュー（トラッカー以外）が開いているか
function app.own_menu_open()
    for _, on in pairs(state.open) do if on then return true end end
    return state.resume ~= nil or state.map ~= nil
end

-- which: 'open_book' / 'tracker_toggle' / 'tracker_operate' / 'eminence_toggle' / 'compass_toggle'（0.1.194〜）
function app.shortcut_run(which)
    which = which or 'open_book'
    if which == 'tracker_toggle' then
        local on = not (S.tracker.visible == true)
        app.set_tracker_visible(on)
        app.flash(T(on and 'msg.tracker_shown' or 'msg.tracker_hidden'))
        return
    end
    if which == 'eminence_toggle' then
        app.toggle_eminence()
        return
    end
    if which == 'compass_toggle' then
        app.toggle_compass()
        return
    end
    if which == 'tracker_operate' then
        -- 受注・完了のお知らせで選ぶものが出ていれば、先にそれを操作する（0.1.183〜）
        if state.popups[1] and S.notify.popup and app.popup_target() and state.active ~= 'popup' then
            state.popup_back = nil
            app.activate('popup')
            return
        end
        -- 操作中にもう一度押したら、操作をゲームに戻す
        if state.active == 'tracker' and app.operating() then
            app.release()
            return
        end
        if not PR or #PR:pinned_list() == 0 then
            app.flash(T('msg.tracker_no_pins'))
            return
        end
        -- 隠れていたら出してから。本・詳細などが開いていたら閉じて、トラッカーだけを操作する（ぶつからないように）
        if S.tracker.visible ~= true then app.set_tracker_visible(true) end
        if app.own_menu_open() then app.close_all() end
        app.enter_tracker()
        return
    end
    if app.own_menu_open() then
        app.close_all()
    else
        app.open_window('book')
    end
end

-- ほかのショートカットに同じ組み合わせが入っているか（入っていればその名前）
function app.shortcut_conflict(which, list)
    if not S or not S.shortcut or #shortcut_mod.normalize(list) == 0 then return nil end
    for _, k in ipairs(SC_KEYS) do
        if k ~= which and shortcut_mod.same(S.shortcut[k] or {}, list) then return k end
    end
    return nil
end

-- 設定に入れる。同じ組み合わせがほかにあれば知らせて入れない。戻り値: 入れたか
function app.shortcut_set(which, list)
    list = shortcut_mod.normalize(list)
    local other = app.shortcut_conflict(which, list)
    if other then
        app.flash(T('msg.shortcut_dup', { v = shortcut_mod.label(list) or '', other = T('settings.shortcut_name_' .. other) }))
        return false
    end
    S.shortcut[which] = json.array(list)
    app.mark_settings_dirty()
    return true
end

-- platform から：押しているボタンの集合（key → true）。戻り値はゲームに渡さないボタンの集合
function app.pad_held(held)
    state.pad_seen = true
    local sc = S and S.shortcut or {}
    local pass = sc.pass_to_game ~= false
    -- ボタン待ち：待っている一つだけを動かす（ほかは発動させない）
    for _, k in ipairs(SC_KEYS) do
        local det = SCS[k]
        if det:capturing() then
            local r = det:update(held, sc[k], pass)
            if r.captured and S then
                if app.shortcut_set(k, r.captured) then
                    app.flash(T('msg.shortcut_set', { v = shortcut_mod.label(r.captured) or '' }))
                end
            end
            return r.block
        end
    end
    local block = {}
    for _, k in ipairs(SC_KEYS) do
        local r = SCS[k]:update(held, sc[k], pass)
        if r.fire and S and S.input.gamepad ~= false and not state.chat_open and not state.text_active then
            -- 設定の「パッドで画面を操作」がオフのときは動かさない（設計の決定）
            -- 窓の開け閉めは次の tick で（入力のイベントの中ではしない）
            state.pending_shortcut = state.pending_shortcut or {}
            if type(state.pending_shortcut) ~= 'table' then state.pending_shortcut = {} end
            state.pending_shortcut[#state.pending_shortcut + 1] = k
        end
        for b in pairs(r.block or {}) do block[b] = true end
    end
    return block
end

-- platform から：ボタン待ちの間は、パッドの入力を全部止める（画面の操作にも使わない）
function app.pad_capturing()
    for _, k in ipairs(SC_KEYS) do if SCS[k]:capturing() then return true end end
    return false
end
function app.pad_blocking(key)
    for _, k in ipairs(SC_KEYS) do if SCS[k]:blocking(key) then return true end end
    return false
end
-- platform から：そのボタンがショートカットの組み合わせに入っているか（入っていれば、画面の操作は離したときにする）
function app.pad_in_combo(key)
    local sc = S and S.shortcut or {}
    for _, k in ipairs(SC_KEYS) do
        if shortcut_mod.in_combo(sc[k], key) then return true end
    end
    return false
end
-- platform から：ショートカットが発動した回数（押してから離すまでに発動したら、そのボタンの画面の操作はしない）
function app.pad_fires()
    local n = 0
    for _, k in ipairs(SC_KEYS) do n = n + (SCS[k].fires or 0) end
    return n
end
-- platform から：トラッカーやお知らせを操作しているあいだは、パッドの入力を全部ゲームに渡さない
-- （0.1.61〜 トラッカー。0.1.197〜 お知らせ。ゲームが見た押下の「離した」は platform の settle で必ず渡す）
function app.pad_block_all()
    if not app.want_pad() then return false end
    if state.active == 'tracker' and app.operating() then return true end
    if app.popup_visible() then return true end
    return false
end

function app.shortcut_capture_start(which)
    which = SCS[which] and which or 'open_book'
    for _, k in ipairs(SC_KEYS) do SCS[k]:cancel_capture() end
    state.capture_which = which
    SCS[which]:start_capture()
end
function app.shortcut_capture_cancel()
    for _, k in ipairs(SC_KEYS) do SCS[k]:cancel_capture() end
    state.capture_which = nil
end

function app.shortcut_info()
    local which = nil
    for _, k in ipairs(SC_KEYS) do if SCS[k]:capturing() then which = k end end
    local labels_ = {}
    for _, k in ipairs(SC_KEYS) do labels_[k] = shortcut_mod.label(S.shortcut[k]) end
    return {
        capturing = which ~= nil,
        which = which,
        so_far = which and shortcut_mod.label(SCS[which]:captured_so_far()) or nil,
        label = labels_.open_book,
        labels = labels_,
        pad_seen = state.pad_seen,
    }
end

---------------------------------------------------------------------------
-- アップデートのお知らせ（0.1.58〜。設定の「このアドオンについて」）
-- 読み込んで記録を読み終えたあと、一回だけ裏で調べる。調べる先が空・オフ・つながらないときは黙って何もしない
---------------------------------------------------------------------------

state.update_checked = false
state.update_found = nil

function app.update_url() return update_mod.URL end   -- 開発用（テストで差し替える）
app._update_url = nil

function app.check_update()
    if state.update_checked then return false end
    if not (S and S.update_notice and S.update_notice.enabled ~= false) then return false end
    state.update_checked = true
    local url = app._update_url or update_mod.URL
    if not update_mod.configured(url) then return false end
    if not P.http_get then return false end
    local current = app.VERSION
    local ok, started = pcall(P.http_get, url, function (body)
        local v = update_mod.version_in(body)
        if v and update_mod.newer(v, current) then
            state.update_found = v
            pcall(P.print, T('msg.update_available', { v = v, cur = current }))
        end
    end)
    return ok and started == true
end

---------------------------------------------------------------------------
-- 通知（ログイン時の続き／エリア入場）
---------------------------------------------------------------------------

local function show_resume()
    if not S.notify.login_resume then return end
    local lf = PR:last_focus()
    if not lf or not lf.quest or PR:state(lf.quest) ~= 'accepted' then return end
    state.resume = { quest = lf.quest, hide_at = state.now + S.notify.login_resume_seconds }
end

local function on_zone(zone_id)
    -- トラッカー・お知らせの操作中にエリアが変わったら、操作をゲームに戻す（0.1.188〜、t310）
    if state.active == 'tracker' or state.active == 'popup' then
        state.popup_back = nil
        app.release()
    end
    local first = state.first_zone_pending
    state.first_zone_pending = false
    state.zone_entered_at[zone_id] = state.now
    state.exit_learned_zone = nil   -- 出口の階は、入るたびに（覚えていないものだけ）調べる
    -- ゾーンが変わるたびに読み直す（ログインのすぐ読む予定は遅らせない）
    local due = state.now + app.GAMELOG_AFTER_ZONE
    state.glog.mem_due = state.glog.mem_due and math.min(state.glog.mem_due, due) or due
    state.roe.mem_due = state.roe.mem_due and math.min(state.roe.mem_due, due) or due
    state.compass_due = state.now   -- コンパスはゾーンが変わったらすぐ作り直す（0.1.173〜）
    if first then
        -- ログイン直後の最初のゾーンは「続き」を出す
        show_resume()
        return
    end
    app.save_all('zone')
    -- エリアに入ったときの「いまここで進めること」は 0.1.173 でなくした（t251）
end

---------------------------------------------------------------------------
-- 毎フレーム
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- 名声（0.1.66〜）：名声を教えてくれる人の返事（チャット欄の行）からランクを覚える
---------------------------------------------------------------------------

app.FAME_LOG_MAX = 65536   -- 読めなかった返事の記録の上限（バイト）

local function fame_log_unmatched(spec, zone, text)
    local paths = char_paths()
    if not paths or state.read_only then return end
    local path = paths.dir .. 'fame_unmatched.log'
    local old = P.fs.read(path) or ''
    if #old >= app.FAME_LOG_MAX then return end
    local line = string.format('%s\tzone=%s\tarea=%s\tnpc=%s\t%s\n', util.iso_time(), tostring(zone),
        spec.area, spec.npc, (tostring(text):gsub('[%c]', ' ')))
    P.fs.write(path, old .. line)
    state.fame_unmatched = (state.fame_unmatched or 0) + 1
end

function app.on_text_in(text, mode)
    if not state.ready or not state.character or not S then return end
    -- エミネンス：「The record #N is not implemented at this time.」（0.1.172〜）
    local nid = roe_mod.not_implemented_id(text)
    if nid then app.roe_mark_failed(nid, 'not_impl'); return end
    local pl = state.player
    local zone = pl and tonumber(pl.zone_id)
    if not zone or not fame_mod.NPC_BY_ZONE[zone] then return end
    local tgt = P.current_target and P.current_target() or nil
    local spec = fame_mod.context(zone, tgt and tgt.name, text)
    if not spec then return end
    local lv = fame_mod.read(spec.area, text)
    state.fame_heard = state.fame_heard or {}
    if lv then
        S.fame = S.fame or {}
        S.fame[spec.area] = { level = lv, at = util.iso_time(), npc = spec.npc }
        state.fame_heard[spec.area] = state.now
        app.mark_settings_dirty()
        P.print(T('fame.heard', { area = T('fame.area.' .. spec.area), level = tostring(lv) }))
        diag.log('fame', spec.area .. ' ' .. tostring(lv))
        return
    end
    -- 同じ人の続きの行（ランクを読んだ直後）は記録しない
    local at = state.fame_heard[spec.area]
    if at and state.now - at < 20 then return end
    fame_log_unmatched(spec, zone, text)
end

-- /astertrail status の名声の行
function app.fame_line()
    local fm = S and S.fame
    local parts = {}
    for _, area in ipairs(fame_mod.AREAS) do
        local e = type(fm) == 'table' and fm[area]
        if type(e) == 'table' and tonumber(e.level) then
            local day = tostring(e.at or ''):match('^%d+%-(%d+%-%d+)') or '?'
            parts[#parts + 1] = T('fame.item', { area = T('fame.area.' .. area), level = tostring(e.level), day = (day:gsub('%-', '/')) })
        end
    end
    if #parts == 0 then return T('cmd.fame_none') end
    return T('cmd.fame', { v = table.concat(parts, T('fame.sep')) })
end

---------------------------------------------------------------------------
-- ゲームのクエスト・ミッションの記録（0.1.169〜、t223）
-- 受注・完了はゲームの記録を正しいものとして当てる。手順のチェックは消さない。
-- 読み込み・ログイン・ゾーンが変わったときはゲームが写した場所から全部読み直し、
-- 0x056 が届いたらその分をすぐ当てる（読むだけ。通信は送らない）。
---------------------------------------------------------------------------

-- 1 回当てる。戻り値: 変えた件数
function app.sync_game_log(why)
    local g = state.glog
    if not g.snap or not state.ready or not PR or PR.read_only or not D or not D.game_refs then return 0 end
    local n, names, events = 0, {}, {}
    for qid, ref in pairs(D.game_refs) do
        local info = ref[1] == 'm' and D.game_mission_info[tonumber(ref[2])] or nil
        local st = game_log.state_of(g.snap, ref, info)
        if st then
            local changed, before = PR:apply_game(qid, st)
            if changed and before ~= st then
                n = n + 1
                if #names < 3 then names[#names + 1] = { qid = qid, to = st } end
                events[#events + 1] = { qid = qid, from = before, to = st }
            end
        end
    end
    -- 受注・完了のお知らせ（0.1.183〜）：遊んでいる間に届いた通信で変わった分だけ
    if app.popup_live(why, n) then
        table.sort(events, function (a, b) return a.qid < b.qid end)
        for _, e in ipairs(events) do
            if e.to == 'accepted' then app.popup_push('accept', e.qid)
            elseif e.to == 'completed' then app.popup_push('complete', e.qid) end
        end
    end
    -- 最初の当て（読み込み・ログインの読み直し、届いた通信のどちらでも）が済んだら、次からを遊んでいる間の変化とみなす
    g.based = true
    g.syncs = g.syncs + 1
    g.changed = g.changed + n
    g.last = { why = why, n = n, at = state.now, ports = game_log.port_count(g.snap), source = g.snap.source }
    if n > 0 then
        diag.log('gamelog', tostring(why) .. ' ' .. n)
    end
    -- 知らせるのは届いた通信で変わったときだけ（読み込み・ゾーン移動の読み直しでは出さない）
    if n > 0 and why == 'packet' then
        if n == 1 then
            local q = D:quest(names[1].qid)
            app.flash(T('glog.one', { name = q and ((S.language == 'en' and q.name_en) or q.name_ja_ref or q.name_en) or names[1].qid, state = T('state.' .. names[1].to) }))
        else
            app.flash(T('glog.many', { n = tostring(n) }))
        end
    end
    return n
end

---------------------------------------------------------------------------
-- 受注・完了のお知らせと効果音（0.1.183〜、t295）
-- 出すのは、遊んでいる間に届いた通信（0x056）で変わったときだけ。読み込み・ログイン・ゾーン移動の読み直し、
-- ログインから少しの間、まとめて変わったとき（POPUP_BULK より多い）は出さない。
-- 手で「受注中」「完了」にしたときは出さない（押した本人に知らせなくてよいので。画面の表示はいつもどおり）。
-- 先頭だけ出し、ほかは並べて待つ。出たときに効果音を鳴らす。
---------------------------------------------------------------------------

function app.popup_live(why, n)
    local g = state.glog
    if why ~= 'packet' or not g.based or g.mem_due then return false end
    if (n or 0) < 1 or n > app.POPUP_BULK then return false end
    if g.login_at and state.now - g.login_at < app.POPUP_AFTER_LOGIN then return false end
    return S.notify.popup == true or S.notify.sound == true
end

-- 完了の次（連続クエスト・次のミッション）。無ければ nil
-- クエスト：前提（受けられない理由に名前が出るもの）に、このクエストの完了があるクエストで、まだ受けておらず、ほかの前提も済んでいるもの
-- ミッション：同じ分類で、並び（番号）がすぐ後の、まだ完了していないもの（アサルト・カンパニエは順番が無いので出さない）
local NO_NEXT_CATS = { assault = true, campaign = true }
function app.next_of(qid)
    if not D or not PR then return nil end
    local q = D:quest(qid)
    if not q then return nil end
    if q.kind == 'mission' then
        if NO_NEXT_CATS[q.category or ''] then return nil end
        local o = marks_core.mission_order(q)
        if o >= 9999 then return nil end
        local best, bo = nil, nil
        for _, x in ipairs(D.quests or {}) do
            if x.kind == 'mission' and x.category == q.category and x.id ~= q.id and x.repeatable ~= true then
                local xo = marks_core.mission_order(x)
                if xo > o and xo < 9999 and (not bo or xo < bo) and PR:state(x.id) ~= 'completed' then best, bo = x.id, xo end
            end
        end
        return best
    end
    for _, x in ipairs(D.quests or {}) do
        if x.kind == 'quest' and x.id ~= q.id and PR:state(x.id) == 'not_accepted' then
            for _, group in ipairs(marks_core.prereq_ids(D, x)) do
                if not group.accept then
                    local hit = false
                    for _, id in ipairs(group) do if id == qid then hit = true end end
                    if hit and not marks_core.prereq_unmet(D, PR, x) then return x.id end
                end
            end
        end
    end
    return nil
end

function app.popup_push(kind, qid)
    if not S.notify.popup and not S.notify.sound then return false end
    local list = state.popups
    if #list >= app.POPUP_MAX then return false end
    for _, p in ipairs(list) do if p.kind == kind and p.quest == qid then return false end end
    local item = { kind = kind, quest = qid }
    if kind == 'complete' then
        item.next = app.next_of(qid)
        if item.next and PR:is_pinned(item.next) then item.next = nil end
    elseif PR:is_pinned(qid) then
        item.pinned = true   -- もうピン留めしているなら聞かない
    end
    list[#list + 1] = item
    return true
end

-- 選ぶもの（ピン留めするクエスト・ミッション）。無ければ nil（お知らせだけ）
function app.popup_target(p)
    p = p or state.popups[1]
    if not p then return nil end
    if p.kind == 'accept' then return (not p.pinned) and p.quest or nil end
    return p.next
end

-- ふわっと出る／消える（alpha, 下からのずれ, 拡大, 位置を固定するか）
function app.popup_anim(p, now, reduce)
    now = tonumber(now) or 0
    local fade = tonumber(app.POPUP_FADE) or 0.35
    local function ease(t)
        t = math.max(0, math.min(1, t))
        return 1 - (1 - t) ^ 3
    end
    if reduce or fade <= 0 then
        if p and p.closing_at then return 0, 0, 1, false end
        return 1, 0, 1, false
    end
    if not p or not p.shown_at then return 0, 16, 0.94, true end
    if p.closing_at then
        local u = ease((now - p.closing_at) / fade)
        return 1 - u, 14 * u, 1 - 0.06 * u, true
    end
    local u = ease((now - p.shown_at) / fade)
    return u, 16 * (1 - u), 0.94 + 0.06 * u, u < 0.999
end

function app.popup_request_close()
    local p = state.popups[1]
    if not p then return end
    if S.reduce_motion or (tonumber(app.POPUP_FADE) or 0) <= 0 then
        app.popup_close()
        return
    end
    if not p.closing_at then
        p.closing_at = state.now or 0
        p.hovered = false
    end
end

-- 設定の試すボタン用。進行は変えない。表示と音だけ
function app.popup_sample_quest()
    if not D then return nil end
    local id = S and S.book and S.book.last_row
    if type(id) == 'string' and D:quest(id) then return id end
    for _, q in ipairs(D.quests or {}) do
        if q.kind == 'quest' then return q.id end
    end
    return D.quests and D.quests[1] and D.quests[1].id or nil
end

function app.popup_preview(kind)
    if not sound_mod.KINDS[kind] or not D then return false end
    local qid = app.popup_sample_quest()
    if not qid then return false end
    local list = state.popups
    local i = 1
    while list[i] do
        if list[i].preview then table.remove(list, i) else i = i + 1 end
    end
    if #list >= app.POPUP_MAX then return false end
    local item = { kind = kind, quest = qid, preview = true }
    if kind == 'complete' then item.next = app.next_of(qid) end
    list[#list + 1] = item
    return true
end

-- 効果音のファイル（設定のフォルダの sounds\。音量ごとに一度だけ作る）
local sound_files = {}
-- force：設定の「試しに鳴らす」（効果音がオフでも鳴らす）
function app.play_sound(kind, force)
    if (not S.notify.sound and not force) or not P.play_sound or not sound_mod.KINDS[kind] then return false end
    local lv = sound_mod.level(S.notify.sound_volume)
    if lv <= 0 then return false end
    local name = sound_mod.file_name(kind, lv)
    local path = sound_files[name]
    if not path then
        local root = P.config_dir and P.config_dir()
        if not root then return false end
        local dir = root .. 'sounds' .. P.fs.sep
        P.fs.mkdir(root)
        P.fs.mkdir(dir)
        path = dir .. name
        if not P.fs.exists(path) then
            local wav = sound_mod.wav(kind, lv)
            if not wav or not P.fs.write(path, wav) then
                diag.log('sound', 'write failed ' .. name)
                return false
            end
        end
        sound_files[name] = path
    end
    local ok = P.play_sound(path)
    if not ok then diag.log('sound', 'play failed') end
    return ok
end

-- 先頭を出したとき：時間を決め、効果音。お知らせを出さない設定なら、音だけ鳴らして捨てる
local function popup_tick(now)
    local list = state.popups
    while list[1] do
        local p = list[1]
        if not p.shown_at then
            p.shown_at = now
            p.hide_at = now + (tonumber(S.notify.popup_seconds) or 8)
            app.play_sound(p.kind, p.preview)
            -- ピンのボタンへ最初の選択を置く（十字・スティックで動かせるように）
            if S.notify.popup or p.preview then
                if app.popup_target(p) then
                    focus.set('popup', 'pin_yes', true)
                else
                    focus.set('popup', 'dismiss', true)
                end
            end
            -- 操作中なら、そのままお知らせを操作できるように（閉じたら前の窓へ戻す）
            if (S.notify.popup or p.preview) and app.popup_target(p) and state.active and state.active ~= 'popup' and app.operating() then
                state.popup_back = state.active
                app.activate('popup')
            end
        end
        -- 試し表示は、お知らせオフでも窓を出す
        if not S.notify.popup and not p.preview then
            table.remove(list, 1)
        elseif p.closing_at and (S.reduce_motion or now >= (p.closing_at + (app.POPUP_FADE or 0.35))) then
            app.popup_close()
        elseif now >= p.hide_at and not p.hovered and state.active ~= 'popup' and not p.closing_at then
            app.popup_request_close()
            if p.closing_at and (S.reduce_motion or now >= (p.closing_at + (app.POPUP_FADE or 0.35))) then
                app.popup_close()
            else
                break
            end
        else
            break
        end
    end
end
app._popup_tick = popup_tick

function app.popup_close()
    table.remove(state.popups, 1)
    state.held = nil
    if state.active == 'popup' then
        local back = state.popup_back
        state.popup_back = nil
        -- 次のお知らせも選ぶものなら、続けて操作する
        if state.popups[1] and app.popup_target(state.popups[1]) then
            state.popups[1].shown_at = nil
            state.popup_back = back
            return
        end
        if back and app.operating_name(back) then app.activate(back) else app.release() end
    else
        -- 遊んでいるときに出ていた分も、入力止めをその場で外す（0.1.197〜）
        app.sync_capture()
    end
end

-- 窓が開いていて操作できるか（お知らせから戻る先）
function app.operating_name(name)
    if name == 'tracker' then return app.tracker_on() end
    if name == 'resume' then return state.resume ~= nil end
    return state.open[name] == true
end

-- 選んだら、すぐ閉じる。pin が true ならピン留め（上限などで留められなければ、いつもの知らせ）
function app.popup_choose(pin)
    local p = state.popups[1]
    if not p or p.closing_at then return end
    local target = app.popup_target(p)
    if pin and target and not p.preview then
        local r = app.request('pin', target)
        if r and r.ok then app.flash(T('popup.pinned')) end
    end
    app.popup_request_close()
end

-- ゲームが写した場所から全部読む（読み込み・ログイン・ゾーンが変わった後）
function app.read_game_log(why)
    local g = state.glog
    if not P.quest_log_snapshot then g.why = 'no_platform'; return 0 end
    local ok, snap, info = pcall(P.quest_log_snapshot)
    if not ok or not snap then g.why = ok and tostring(info) or tostring(snap); return 0 end
    g.why = nil
    -- 届いた通信の分で、写した場所から読めなかったものは残す
    if g.snap then
        for i = 0, game_log.QUEST_LOGS - 1 do
            snap.cur[i] = snap.cur[i] or g.snap.cur[i]
            snap.done[i] = snap.done[i] or g.snap.done[i]
        end
        for i = 0, 3 do snap.mdone[i] = snap.mdone[i] or g.snap.mdone[i] end
        snap.main = snap.main or g.snap.main
        for k in pairs(g.snap.ports) do snap.ports[k] = true end
    end
    g.snap = snap
    g.mask = info
    return app.sync_game_log(why)
end

--[[ 所持（0.1.184〜、t297）
  毎フレームは読まない。品・だいじなものの通信（0x01C〜0x020・0x055）が届いたら「変わった」にして、
  POSS_DEBOUNCE 秒たってから 1 回読み直す。届かない環境のため POSS_EVERY 秒ごとにも読み直す（どちらも 1 ミリ秒未満）。
  持っているだけで手順を済みにはしない（表示と「足りない」アイコンだけ）。 ]]
app.POSS_DEBOUNCE = 0.5
app.POSS_EVERY = 5
function app.on_inventory_packet(id)
    local ps = state.poss
    local due = (state.now or 0) + app.POSS_DEBOUNCE
    if not ps.due or ps.due > due then ps.due = due end
end

function app.tick_possession()
    local ps = state.poss
    local now = state.now or 0
    if ps.due and now < ps.due then return end
    ps.due = now + app.POSS_EVERY
    if not P.possession then ps.snap = nil; return end
    local ok, snap = pcall(P.possession)
    ps.snap = (ok and type(snap) == 'table') and snap or nil
    ps.scans = ps.scans + 1
    if not ok then diag.log('possession', snap) end
end

function app.possession() return state.poss.snap end

-- 必要の欄 1 つの所持（poss_mod.need_state の形）
function app.need_possession(n) return poss_mod.need_state(state.poss.snap, n) end

-- 「足りない」と言い切れる時だけの数（アイコン用。未確認なら nil）
function app.have_for_need(_, n) return poss_mod.known_count(state.poss.snap, n) end

-- 届いた 0x056（platform の packet_in から。読むだけ）
function app.on_quest_packet(data)
    local port, words = game_log.parse_packet(data)
    if not port then return end
    local g = state.glog
    g.snap = g.snap or game_log.new_snapshot()
    g.snap.source = g.snap.source or 'packet'
    if game_log.apply_port(g.snap, port, words) then
        g.packets = g.packets + 1
        g.due = state.now + app.GAMELOG_DEBOUNCE
    end
end

local function tick_game_log()
    local g = state.glog
    if not state.ready then return end
    if g.mem_due and state.now >= g.mem_due then
        g.mem_due = nil
        g.due = nil
        app.read_game_log('memory')
    elseif g.due and state.now >= g.due then
        g.due = nil
        app.sync_game_log('packet')
    end
end

---------------------------------------------------------------------------
-- エミネンス・レコード（0.1.172〜、t243）
-- 名前・目標の数は手元の DAT から（開いたときに一度だけ読む）。受けているもの・達成はゲームが写した場所と、届いた
-- 0x111・0x112 から（読むだけ）。送るのは、窓・本の「受ける」「外す」を押したときに 1 回だけ（やり直さない・ためない）。
---------------------------------------------------------------------------

-- DAT を読む（言語ごとに一度。失敗も覚え、言語を変えるか /astertrail roe reload まで読み直さない）
function app.roe_db()
    local r = state.roe
    local lang = (S and S.language == 'en') and 'en' or 'ja'
    if r.db_lang == lang and (r.db or r.db_why) then return r.db, r.db_why end
    r.db_lang, r.db, r.db_why = lang, nil, nil
    local ids = roe_mod.DAT_IDS[lang]
    if not P.read_dat then r.db_why = 'no_platform'; return nil, r.db_why end
    local qraw, qwhy = P.read_dat(ids.quest)
    local craw, cwhy = P.read_dat(ids.category)
    if not qraw then r.db_why = 'quest_' .. tostring(qwhy); return nil, r.db_why end
    local function conv(sj)
        if not sj:find('[\128-\255]') then return sj end
        local u = P.text_from_game and P.text_from_game(sj)
        return u or ''   -- 変えられない字は出さない（空なら番号で出す）
    end
    local quests, n, why = roe_mod.parse_quests(qraw, conv, lang)
    qraw = nil
    if not quests then r.db_why = 'quest_' .. tostring(why); return nil, r.db_why end
    local cats = craw and roe_mod.parse_categories(craw, conv) or nil
    r.db = roe_mod.build(quests, cats)
    r.db.cat_why = (not craw and cwhy) or (craw and not cats and 'parse') or nil
    diag.log('roe', 'dat ' .. lang .. ' ' .. tostring(n) .. ' cats ' .. tostring(#r.db.roots))
    return r.db
end

function app.roe_reload_db()
    state.roe.db, state.roe.db_lang, state.roe.db_why = nil, nil, nil
    return app.roe_db()
end

-- ゲームが写した場所から読む（読み込み・ログイン・ゾーンが変わった後）。読めなければ最後に届いた 0x111
function app.read_roe(why)
    local r = state.roe
    local snap, swhy
    if P.roe_snapshot then
        local ok, a, b = pcall(P.roe_snapshot)
        if ok then snap, swhy = a, b else swhy = tostring(a) end
    end
    r.mem_why = swhy
    if snap and snap.words then
        r.active = roe_mod.active_from_words(snap.words)
        r.src, r.at = 'memory', state.now
    elseif not r.active and P.last_packet then
        local p = P.last_packet(roe_mod.PKT_ACTIVE)
        local act = p and roe_mod.parse_active(p)
        if act then r.active, r.src, r.at = act, 'last_packet', state.now end
    end
    -- 日・週で替わる目標の組・週・リーダー（0.1.224〜）：まだ届いていなければ最後に届いたものを読む
    if P.last_packet then
        if not r.unity then
            local p = P.last_packet(roe_mod.PKT_UNITY)
            if p then app.on_roe_packet(roe_mod.PKT_UNITY, p) end
        end
        if r.leader == nil then
            local p = P.last_packet(roe_mod.PKT_STATUS)
            if p then app.on_roe_packet(roe_mod.PKT_STATUS, p) end
        end
    end
    if snap and snap.complete then
        r.complete = snap.complete
        r.parts = { [0] = true, true, true, true }
    end
    r.last_read = why
    return snap ~= nil
end

function app.tick_roe()
    local r = state.roe
    if not state.ready then return end
    if r.mem_due and state.now >= r.mem_due then
        r.mem_due = nil
        app.read_roe('memory')
    end
end

local function roe_name(id)
    local db = state.roe.db
    local q = db and db.quests[id]
    if q and q.name and q.name ~= '' then return q.name end
    return '#' .. tostring(id)
end
app.roe_name = roe_name

-- 受けられない・まだ無いと言われた番号を覚える（キャラごと、設定に保存）
function app.roe_mark_failed(id, why)
    id = tonumber(id)
    if not id or id < 1 or id > 4095 or not S or not S.eminence then return end
    S.eminence.failed = S.eminence.failed or {}
    local key = tostring(id)
    local cur = S.eminence.failed[key]
    -- 未実装のほうが具体的。742 が後から来ても not_impl をunableで上書きしない（742 のお知らせ自体は残す）
    if cur and cur.why == 'not_impl' and why == 'unable' then
        -- answered_at だけ下で付ける
    else
        S.eminence.failed[key] = { why = why, at = util.iso_time() }
        app.mark_settings_dirty()
    end
    -- 断られたのも答え：少し後に押せるようにする（すぐ消すと連打でまた送る。0.1.178〜）
    local s = state.roe.sent[id]
    if s and not s.answered_at then s.answered_at = state.now end
    diag.log('roe', 'failed ' .. tostring(id) .. ' ' .. tostring(why))
end

function app.roe_failed(id)
    id = tonumber(id)
    if not id then return nil end
    local key = tostring(id)
    local E = S and S.eminence
    local f = E and E.failed
    if f and f[key] then return f[key] end
    -- サーバーが受け付けたことがあれば、既知の未実装リストは使わない
    if E and E.impl_ok and E.impl_ok[key] then return nil end
    if roe_mod.is_known_unimplemented and roe_mod.is_known_unimplemented(id) then
        return { why = 'not_impl' }
    end
    return nil
end

-- いまの時刻（秒）。日・週で替わる目標の組を進めるのに使う（テストで差し替える）
function app.epoch_now() return os.time() end

-- 日・週で替わる目標の、いまの組・週・リーダー。戻り値: { shared, week, leader } または nil
function app.roe_rotation_now()
    local r = state.roe
    local cur = roe_mod.rotation_now(r.unity, app.epoch_now()) or {}
    cur.leader = r.leader
    return cur
end

-- いま受けられない理由（受けている目標・分からないときは nil）。戻り値: 理由, 今日の組の字
function app.roe_rotation(id)
    id = tonumber(id)
    if not id or app.roe_active_entry(id) then return nil end
    local cur = app.roe_rotation_now()
    return roe_mod.rotation_block(id, cur, cur.leader)
end

-- 押せない理由の文（ボタンの説明・お知らせ）
function app.roe_why_text(why, id)
    local cur = app.roe_rotation_now()
    local today = cur.shared and roe_mod.BLOCKS[cur.shared + 1] or '?'
    local first = cur.shared and (roe_mod.SHARED_FIRST + cur.shared * 9) or 0
    return T('roe.msg.' .. tostring(why), { name = id and roe_name(id) or '', today = today,
        from = tostring(first), to = tostring(first + 8) })
end

-- 届いた 0x111・0x112・0x029・0x110・0x061（platform の packet_in から。読むだけ）
function app.on_roe_packet(id, data)
    local r = state.roe
    if id == roe_mod.PKT_UNITY then
        local u = roe_mod.parse_unity(data)
        if not u then return end
        local now = app.epoch_now()
        r.unity = { shared = u.shared, week = u.week, day_at = roe_mod.days_since(now), week_at = roe_mod.weeks_since(now) }
        return
    elseif id == roe_mod.PKT_STATUS then
        local l = roe_mod.parse_leader(data)
        if l ~= nil then r.leader = l end
        return
    end
    if id == roe_mod.PKT_ACTIVE then
        local act = roe_mod.parse_active(data)
        if not act then return end
        r.active, r.src, r.at = act, 'packet', state.now
        r.packets = r.packets + 1
        -- 一覧が描き直されても、覚えていた縦位置を戻す（0.1.203〜）
        state.book_restore_scroll = true
        -- 送った番号の「送り中」は、その番号の答え（受けた＝並びにある・解除した＝並びに無い）が届いたら、少し後に解く。
        -- 進みだけの 0x111 では解かない（0.1.178〜、t287）
        local in_act = {}
        for _, e in ipairs(act) do in_act[e.id] = true end
        for sid, s in pairs(r.sent) do
            if not s.answered_at and ((s.op == 'start') == (in_act[sid] == true)) then s.answered_at = state.now end
        end
    elseif id == roe_mod.PKT_LOG then
        local part, bytes = roe_mod.parse_log(data)
        if not part then return end
        if part == 0 or not r.building then r.building = roe_mod.new_complete(); r.building_parts = {} end
        roe_mod.apply_log(r.building, part, bytes)
        r.building_parts[part] = true
        r.packets = r.packets + 1
        local all = true
        for i = 0, 3 do if not r.building_parts[i] then all = false end end
        if all then
            r.complete, r.parts = r.building, { [0] = true, true, true, true }
            r.building, r.building_parts = nil, nil
        end
    elseif id == roe_mod.PKT_MESSAGE then
        local kind, p1 = roe_mod.parse_message(data)
        if not kind then return end
        local rid = tonumber(p1)
        local ls = r.last_send
        if not rid or rid < 1 or rid > 4095 then
            rid = (ls and state.now - ls.at <= app.ROE_UNABLE_WINDOW) and ls.id or nil
        end
        if not rid then return end
        if kind == 'unable' then
            local s = r.sent[rid]
            -- 日・週で替わる目標は「受けられなかった」を覚えない（次の日・週には受けられる）。わけを名前つきで出す（0.1.224〜）
            -- 未実装（既知、またはチャットで覚えた）も unable では上書きしない。742 のお知らせは出す。
            if roe_mod.is_rotating(rid) then
                diag.log('roe', 'unable (rotating) ' .. tostring(rid))
            elseif app.roe_failed(rid) and app.roe_failed(rid).why == 'not_impl' then
                diag.log('roe', 'unable (not_impl) ' .. tostring(rid))
            else
                app.roe_mark_failed(rid, 'unable')
            end
            if s and not s.answered_at then s.answered_at = state.now end   -- 断られたのも答え
            if ls and ls.id == rid and state.now - ls.at <= app.ROE_UNABLE_WINDOW then
                app.flash(T(roe_mod.is_rotating(rid) and 'roe.msg.unable_rotating' or 'roe.msg.unable_named',
                    { name = roe_name(rid) }))
            end
        elseif kind == 'start' then
            local E = S and S.eminence
            local f = E and E.failed
            local changed = false
            if f and f[tostring(rid)] then f[tostring(rid)] = nil; changed = true end
            if E then
                E.impl_ok = E.impl_ok or {}
                if not E.impl_ok[tostring(rid)] then E.impl_ok[tostring(rid)] = true; changed = true end
            end
            if changed then app.mark_settings_dirty() end
        end
    end
end

-- ゲームのメニューが送った 0x10C・0x10D（覚えて比べるだけ）
function app.on_roe_game_sent(pid, data)
    local r = state.roe
    local id = data:byte(5) and (data:byte(5) + (data:byte(6) or 0) * 256) or nil
    local _, ours = roe_mod.build_packet(pid == roe_mod.PKT_START and 'start' or 'remove', id)
    local hex = {}
    for i = 1, math.min(#data, 16) do hex[#hex + 1] = string.format('%02X', data:byte(i)) end
    -- 頭の 2 バイト（番号と長さ）と中身を比べる（3〜4 バイト目は順番の数なので見ない）
    local same = ours ~= nil and #data == #ours and data:sub(5) == ours:sub(5)
        and (data:byte(1) + (data:byte(2) % 2) * 256) == pid and math.floor(data:byte(2) / 2) == #ours / 4
    r.game_sent = { pid = pid, id = id, hex = table.concat(hex, ' '), same = same, at = state.now }
    diag.log('roe', string.format('game sent %03X %s same=%s', pid, r.game_sent.hex, tostring(same)))
end

function app.roe_active_entry(id)
    local act = state.roe.active
    if not act then return nil end
    for _, e in ipairs(act) do if e.id == id then return e end end
    return nil
end

function app.roe_active_count()
    local n = 0
    for _, e in ipairs(state.roe.active or {}) do if not e.timed then n = n + 1 end end
    return n
end

-- ボタンを押せるか。戻り値: ok, 理由
function app.roe_can(op, id)
    local r = state.roe
    if not (P.roe_send and P.roe_status) then return false, 'no_api' end
    local st = P.roe_status()
    if not st.can_send then return false, 'no_api' end
    if not r.active then return false, 'unknown' end
    -- 番号ごとの押せない間（0.1.178〜、t287）：答えが届くまで（上限 ROE_BUSY 秒）＋届いてから ROE_AFTER 秒
    local sent = r.sent[id]
    if sent then
        if sent.answered_at then
            if state.now - sent.answered_at < app.ROE_AFTER then return false, 'busy' end
        elseif state.now - sent.at < app.ROE_BUSY then
            return false, 'busy'
        end
    end
    local e = app.roe_active_entry(id)
    if op == 'start' then
        if e then return false, 'already' end
        -- 未実装（0.1.228〜：3055〜3060 と、チャットで覚えた番号）
        local failed = app.roe_failed(id)
        if failed and failed.why == 'not_impl' then return false, 'not_impl' end
        -- 日・週で替わる目標・期間限定（0.1.224〜、t496）
        local rot = app.roe_rotation(id)
        if rot then return false, rot end
        if app.roe_active_count() >= roe_mod.MAX_ACTIVE then return false, 'full' end
        local db = app.roe_db()
        local q = db and db.quests[id]
        if roe_mod.is_complete(r.complete, id) and not (q and q.repeatable) then return false, 'completed' end
        return true
    elseif op == 'remove' then
        if not e then return false, 'not_active' end
        if e.timed then return false, 'timed' end
        return true
    end
    return false, 'bad_op'
end

-- 押したときに 1 回だけ送る。戻り値: { ok, code }
function app.roe_send(op, id)
    id = tonumber(id)
    local can, why = app.roe_can(op, id)
    if not can then
        app.flash(app.roe_why_text(why, id))
        return { ok = false, code = why }
    end
    local pid, data = roe_mod.build_packet(op, id)
    if not pid then return { ok = false, code = data } end
    local ok, via = P.roe_send(pid, data)
    local r = state.roe
    if not ok then
        app.flash(T('roe.msg.send_failed', { name = roe_name(id) }))
        diag.log('roe', 'send failed ' .. tostring(via))
        return { ok = false, code = 'send_failed' }
    end
    r.sent[id] = { op = op, at = state.now }
    r.last_send = { op = op, id = id, at = state.now, via = via }
    diag.log('roe', string.format('sent %03X %d via %s', pid, id, tostring(via)))
    app.flash(T(op == 'start' and 'roe.msg.sent_start' or 'roe.msg.sent_remove', { name = roe_name(id) }))
    return { ok = true, code = 'sent' }
end

-- 窓を出す・隠す
function app.set_eminence_visible(on)
    on = on and true or false
    if S.eminence.visible ~= on then
        S.eminence.visible = on
        app.mark_settings_dirty()
    end
    if on and not state.roe.active then state.roe.mem_due = state.now end
end

function app.toggle_eminence()
    app.set_eminence_visible(not S.eminence.visible)
    app.flash(T(S.eminence.visible and 'msg.eminence_shown' or 'msg.eminence_hidden'))
    return S.eminence.visible
end

---------------------------------------------------------------------------
-- コンパス（0.1.173〜、t251）：いまいるエリアで受けられるクエストを近い順に。出しているあいだだけ 1 秒ごとに作る
---------------------------------------------------------------------------
app.COMPASS_EVERY = 1.0

function app.tick_compass()
    if not (state.ready and S and S.compass and S.compass.visible) then return end
    local range = compass_mod.clamp_range(S.compass.max_dist)
    -- 距離の設定を変えたら、待ち時間を待たずにすぐ作り直す
    if state.now < (state.compass_due or 0) and state.compass_range == range then return end
    state.compass_due = state.now + app.COMPASS_EVERY
    state.compass_range = range
    local ents
    if P.visible_entities then
        local ok, e = pcall(P.visible_entities)
        if ok and type(e) == 'table' then ents = e end
    end
    local ok, rows = pcall(compass_mod.rows, D, PR, state.player, ents,
        { status = state.rstat, have = app.have_for_need, max_dist = range })
    if ok then state.compass = rows else diag.log('compass', rows); state.compass = {} end
end

function app.set_compass_visible(on)
    on = on and true or false
    if S.compass.visible ~= on then
        S.compass.visible = on
        app.mark_settings_dirty()
    end
    if on then state.compass_due = state.now
    elseif state.active == 'compass' then app.release() end
end

function app.toggle_compass()
    app.set_compass_visible(not S.compass.visible)
    app.flash(T(S.compass.visible and 'msg.compass_shown' or 'msg.compass_hidden'))
    return S.compass.visible
end

local function poll_player()
    local pl = P.player()
    state.player = pl
    -- ジョブ・レベル・所属国・ランク（0.1.65〜）。読めなければ nil（受ける条件の判定に使わない）
    -- 0.1.210〜：毎フレームは読まない（1 秒ごと。ログイン・ゾーンの直後はすぐ）
    if not pl.ready then
        state.pstat, state.pstat_at = nil, nil
    elseif P.player_status and (not state.pstat or not state.pstat_at or state.now - state.pstat_at >= 1
        or state.now < state.pstat_at or state.pstat_zone ~= pl.zone_id) then
        state.pstat_at, state.pstat_zone = state.now, pl.zone_id
        state.pstat = nil
        local ok, st = pcall(P.player_status)
        if ok and type(st) == 'table' then state.pstat = st end
    end
    -- 受ける条件の判定に渡す値：読めた値と、話して覚えた名声（0.1.66〜）
    local fm = state.character and S and S.fame
    if fm and next(fm) == nil then fm = nil end
    if state.pstat then
        state.pstat.fame = fm
        state.rstat = state.pstat
    else
        state.rstat = fm and { fame = fm } or nil
    end
    if pl.ready and pl.name and pl.name ~= '' then
        if not state.character or state.character.name ~= pl.name then
            if state.character then app.on_logout() end
            app.on_login(pl.name)
        end
        if pl.zone_id and pl.zone_id > 0 and pl.zone_id ~= state.last_zone then
            state.last_zone = pl.zone_id
            on_zone(pl.zone_id)
        end
        state.not_ready_since = nil
    elseif state.character then
        -- ゾーン移動中などに一瞬読めないことがあるので、少し続いた時だけログアウト扱い
        state.not_ready_since = state.not_ready_since or state.now
        if state.now - state.not_ready_since >= 5 then
            state.not_ready_since = nil
            app.on_logout()
        end
    end
end

-- 出口の階を覚える（0.1.171〜、t227-map）。複数 MAP のゾーンに入って少ししてから一度だけ、
-- 出口と「来たときに立つ位置」の階をゲームの階の関数で調べる（読むだけ）。全キャラ共通で exit_floors.json に残す。
function app.exit_floors()
    if state.exit_floors then return state.exit_floors end
    state.exit_floors = {}
    local root = P.config_dir and P.config_dir()
    if root then
        local v = storage.load_json(P.fs, root .. 'exit_floors.json', nil, nil, util.stamp())
        if type(v) == 'table' and type(v.zones) == 'table' then state.exit_floors = v.zones end
    end
    return state.exit_floors
end

app.EXIT_RETRIES = 3        -- 出口の階を調べ直す回数（同じ滞在のうち）
app.EXIT_RETRY_GAP = 20     -- 調べ直す間（秒）

function app.learn_exit_floors()
    if not state.ready or not P.floor_at then return 0 end
    local pl = state.player
    local zone = pl and pl.ready and tonumber(pl.zone_id)
    if not zone or zone <= 0 then return 0 end
    if state.exit_learned_zone == zone then
        -- 調べきれなかった点があれば、同じ滞在のうちに間をあけて調べ直す（0.1.175〜。入った直後は地図がまだのことがある）
        local r = state.exit_retry
        if not (r and r.zone == zone and r.left > 0 and state.now >= r.at) then return 0 end
        r.left = r.left - 1
        r.at = state.now + app.EXIT_RETRY_GAP
    else
        local entered = state.zone_entered_at[zone]
        if entered and state.now - entered < app.FLOOR_AFTER_ZONE then return 0 end
        state.exit_learned_zone = zone
        state.exit_retry = { zone = zone, left = app.EXIT_RETRIES, at = state.now + app.EXIT_RETRY_GAP }
    end
    local learned = app.exit_floors()
    local n = exits_mod.learn(D, maps_mod, learned, zone, P.floor_at)
    if exits_mod.unlearned(D, maps_mod, learned, zone) == 0 then state.exit_retry = nil end
    if n > 0 then
        local root = P.config_dir and P.config_dir()
        if root then storage.save_json(P.fs, root .. 'exit_floors.json', { data_kind = 'exit_floors', zones = learned }) end
        diag.log('exits', 'learned ' .. n .. ' in zone ' .. zone)
    end
    return n
end

-- DAT から出口の階を出す（0.1.176〜、t266）。まだ入ったことのない複数 MAP のゾーンでも、
-- 地図を開いたときに、そのゾーンの 3D の DAT を読んで（読むだけ）出口と「来たときに立つ位置」の MAP を出す。
-- 同梱しない・保存しない（その回だけ覚える）。1 フレームに少しずつ調べる。
app.DAT_POINTS_PER_TICK = 8

function app.dat_floors()
    state.dat_floors = state.dat_floors or {}
    return state.dat_floors
end

-- 地図の窓から呼ぶ。複数 MAP のゾーンだけ、まだなら順番待ちに入れる
function app.want_dat_floors(zone_id)
    zone_id = tonumber(zone_id)
    if not zone_id or not P.read_dat then return false end
    if #maps_mod.floors(D, zone_id) <= 1 then return false end
    local done = app.dat_floors()
    state.dat_status = state.dat_status or {}
    if done[zone_id] or state.dat_status[zone_id] then return false end
    if #exits_mod.dat_points(D, zone_id) == 0 then return false end
    state.dat_status[zone_id] = 'queued'
    state.dat_queue = state.dat_queue or {}
    state.dat_queue[#state.dat_queue + 1] = zone_id
    return true
end

function app.tick_dat_floors()
    local job = state.dat_job
    if not job then
        local q = state.dat_queue
        if not q or #q == 0 then return end
        local zone_id = table.remove(q, 1)
        local fid = zonedat_mod.file_id(zone_id)
        local raw, why = nil, 'no_id'
        if fid then raw, why = P.read_dat(fid) end
        local z
        if raw then z, why = zonedat_mod.open(raw) end
        if not z then
            state.dat_status[zone_id] = 'failed'
            diag.log('exits', 'dat ' .. zone_id .. ' ' .. tostring(why))
            return
        end
        state.dat_job = { zone = zone_id, z = z, pts = exits_mod.dat_points(D, zone_id), next = 1, out = {} }
        state.dat_status[zone_id] = 'reading'
        return
    end
    job.next = exits_mod.dat_step(D, maps_mod, job.zone, job.pts, job.z, zonedat_mod.floor_at, job.out,
        job.next, app.DAT_POINTS_PER_TICK)
    if job.next == nil then
        app.dat_floors()[job.zone] = job.out
        state.dat_status[job.zone] = 'done'
        local n = 0
        for _, v in pairs(job.out) do if v then n = n + 1 end end
        diag.log('exits', 'dat ' .. job.zone .. ' placed ' .. n .. '/' .. #job.pts)
        state.dat_job = nil
    end
end

-- いまいる階（FloorId）→ MAP 番号。地図の窓が開いていて、複数 MAP のゾーンのときだけ、1秒ごと。
-- force=true（/astertrail floor）は間隔とゾーン直後の待ちを見ずに、すぐ確かめる。
function app.poll_floor(force)
    if not P or not P.current_floor_id then return nil end
    if not force then
        if not state.open.map then return nil end
        if state.floor_at and state.now - state.floor_at < app.FLOOR_INTERVAL then return state.floor end
    end
    state.floor_at = state.now
    local pl = state.player
    local zone = pl and tonumber(pl.zone_id)
    if not zone or zone <= 0 then state.floor = nil; return nil end
    if not force then
        if #maps_mod.floors(D, zone) <= 1 then state.floor = { zone_id = zone, why = 'single_map' }; return state.floor end
        local entered = state.zone_entered_at[zone]
        if entered and state.now - entered < app.FLOOR_AFTER_ZONE then
            state.floor = { zone_id = zone, why = 'just_zoned' }
            return state.floor
        end
    end
    local ok, fid, why = pcall(P.current_floor_id)
    if not ok then
        diag.log('floor', fid)
        state.floor = { zone_id = zone, why = 'error' }
        return state.floor
    end
    local map_n = fid and maps_mod.map_n_for_floor(D, zone, fid) or nil
    if fid and not map_n then why = why or 'not_in_table' end
    state.floor = { zone_id = zone, floor_id = fid, map_n = map_n, why = why }
    return state.floor
end

---------------------------------------------------------------------------
-- ゲーム本来のメニュー（ミッションで本も開く・コンフィグのボタン・操作の横取り）
---------------------------------------------------------------------------

app.CONFIG_LABELS = { '冒険の本の設定', 'Astertrail' }
app.MISSIONM_REOPEN_GAP = 0.3   -- 閉じてすぐの「開いた」はちらつきとして数えない（秒）

-- platform から：見ている窓が開いた・変わった・閉じた（closing は閉じる途中か）
function app.game_window(what, name, closing)
    if name ~= 'missionm' then return end
    if what == 'open' then
        if closing then return end  -- 閉じる途中は毎フレーム開く・閉じるを繰り返すので無視
        if state.missionm_open then return end
        local gap = state.missionm_closed_at and state.now and (state.now - state.missionm_closed_at) or nil
        if gap and gap >= 0 and gap < app.MISSIONM_REOPEN_GAP then return end
        state.missionm_open = true
        if S.gameui.mission_book then state.pending_book = 'mission' end
    elseif what == 'close' then
        if state.missionm_open then state.missionm_closed_at = state.now end
        state.missionm_open = false
    end
end

-- platform から：コンフィグに足したボタンが押された（本を設定の表示で開く・閉じる。0.1.175〜）
function app.config_pressed()
    state.pending_book = 'settings'
end

local function apply_pending_book()
    local p = state.pending_book
    if not p then return end
    state.pending_book = nil
    if p == 'mission' then
        -- ゲームのミッションメニューから開くときも、前回のタブ・行・縦位置に戻す（0.1.206〜。以前は閉じてから開くとミッションのタブへしていた）
        app.open_window('book')
    elseif p == 'settings' then
        -- 設定を出していれば本ごと閉じる（前の設定の窓と同じ、押すたびに出す・消す）
        if state.open.settings then app.close_window('book') else app.open_window('settings') end
    end
end

-- 設定に合わせて、見張り・ボタン・入力止めを付け外しする（毎 tick。変わったときだけ動く）
function app.sync_gameui()
    -- チャット欄は毎フレーム見る（遅れると打った文字を取ってしまう）
    if P.chat_open then
        local c = P.chat_open()
        state.chat_open = c == true
    end
    if P.watch_game_windows then
        P.watch_game_windows(S.gameui.mission_book == true, app.game_window)
        if not S.gameui.mission_book then state.missionm_open = false end
    end
    if P.config_button then
        if S.gameui.config_button then
            local label, why = P.config_button(true, app.CONFIG_LABELS, app.config_pressed)
            -- 0.1.210〜：文は変わったときだけ作る
            local nk = label and ('ok:' .. tostring(label)) or (why and ('ng:' .. tostring(why))) or nil
            if nk and nk ~= state.gameui_note_key then
                state.gameui_note_key = nk
                if label then state.gameui_note = T('settings.config_button_ok', { v = label })
                else state.gameui_note = T('settings.config_button_ng', { v = tostring(why) }) end
            end
        else
            P.config_button(false)
            state.gameui_note = nil
            state.gameui_note_key = nil
        end
    end
    app.sync_capture()
end

-- ゲームのメニューへの入力止めを、今の状態に合わせる。閉じた・操作をやめたその場で呼ぶ（1フレーム遅らせない）
function app.sync_capture()
    if not P or not P.menu_capture or not S then return end
    local want = S.gameui.capture == true and app.operating() and not state.text_active and not state.chat_open
        and not app.menu_takes_input()
    if want ~= state.menu_captured then
        pcall(P.menu_capture, want)
        state.menu_captured = want
    end
end

--[[ ゲームのメニューを前に（0.1.186〜、t302）
  ImGui はゲームのあとに描くので、本・トラッカーなどがホームポイント・店・選択肢などのメニューを隠してしまう。
  メニューが開いている間だけ vana.ui.game_on_top(true)（重なった所だけゲームの窓を上に貼り直す）。閉じたら false
  （いつもオンだと、チャット欄やパーティリストもトラッカーの上に出てしまうため）。
  0.1 秒ごとに読む（窓の一覧と focused を読むだけ。1 回 0.05 ms ほど）。 ]]
app.GAME_MENU_EVERY = 0.1
function app.tick_game_menus()
    if not (P and P.game_menu_state and S) then return end
    local now = state.now or 0
    -- 窓の一覧を読むのは 0.1 秒に 1 回。隠す・入力を返す判断は毎フレーム
    -- （先に出ていた本はすぐ隠す。メニューの上から出した本は隠さない。0.1.233〜）
    if not (state.gm_due and now < state.gm_due) then
        state.gm_due = now + app.GAME_MENU_EVERY
        local open, info = P.game_menu_state()
        state.game_menu_open, state.game_menu_info = open, info
        local want = S.gameui.menus_on_top ~= false and open == true
        -- 0.1.189〜（t315）：メニューの窓と重なるこちらの窓は、その間だけ引っ込める（透明・マウスを通す）。
        -- game_on_top は貼り直す窓が 8 つまでで、チャット欄・ヘルプの行などで埋まると、メニューが後ろに残るため
        state.game_menu_rects = (want and type(info) == 'table' and type(info.rects) == 'table' and #info.rects > 0) and info.rects or nil
        if want ~= (state.game_on_top == true) then
            local ok = P.set_game_on_top and P.set_game_on_top(want)
            state.game_on_top = want and ok and true or false
            if not want then state.game_on_top = false end
        end
    end
    app.sync_menu_suspend()
end

--[[ ゲームのメニューが開いているあいだ、本を隠して入力をゲームに渡す（0.1.231〜）。
  本は閉じない（開いている印はそのまま）。タブ・見出し・選んでいる行・一覧の位置・窓の大きさは残る。
  メニューを閉じたら本を出し、隠す前に操作していた窓（本・設定・トラッカーなど）の操作に戻す。
  メニューが開いているあいだに本を自分で閉じたら、メニューを閉じても出さない。
  トラッカーは出しておく（重なっていれば 0.1.189 どおり透明）。操作中なら入力だけゲームに渡す。
  0.1.233〜：メニューがすでに開いているときに本や設定を出したときは隠さず、操作も渡す
  （メインメニューの「ミッション」や設定の項目から出したとき）。 ]]
function app.sync_menu_suspend()
    local menu = state.game_menu_open == true
    if menu then
        if state.book_keep_over_menu then
            return
        end
        if state.open.book and not state.book_hidden_for_menu then
            state.book_hidden_for_menu = true
        end
        if app.operating() then
            if state.active and state.menu_resume_active == nil then
                state.menu_resume_active = state.active
            end
            app.release()
        end
        return
    end
    local resume = state.menu_resume_active
    state.menu_resume_active = nil
    state.book_keep_over_menu = false
    if state.book_hidden_for_menu then
        state.book_hidden_for_menu = false
        if state.open.book then
            -- 描いていなかった間に ImGui が窓を忘れるので、保存してある位置・大きさで出し直す（大きさを変えたりはしない）
            window.reapply('book')
            state.book_restore_scroll = true
        end
    end
    if resume then app.resume_after_menu(resume) end
end

function app.resume_after_menu(name)
    if name == 'book' or name == 'settings' then
        if state.open.book then app.activate(name) end
    elseif name == 'tracker' then
        if app.tracker_on() then app.activate('tracker') end
    elseif name == 'popup' then
        if app.popup_visible() then app.activate('popup') end
    elseif name == 'compass' then
        if S and S.compass and S.compass.visible then app.activate('compass') end
    elseif name == 'map' then
        if state.open.map then app.activate('map') end
    elseif name == 'detail' then
        if state.open.detail then app.activate('detail') end
    elseif name == 'resume' then
        if state.resume then app.activate('resume') end
    end
end

function app.release_gameui()
    state.menu_captured = false
    state.game_on_top = false
    state.game_menu_rects = nil
    state.pending_book = nil
    state.book_hidden_for_menu = false
    state.book_keep_over_menu = false
    state.menu_resume_active = nil
    if P and P.release_gameui then pcall(P.release_gameui) end
end

function app.tick(now)
    state.now = now
    -- 現在地のピンが遅れないよう、位置は毎フレーム取る
    local ok, err = pcall(poll_player)
    if not ok then diag.log('platform', err) end
    local fok, ferr = pcall(app.poll_floor, false)
    if not fok then diag.log('floor', ferr) end
    local xok, xerr = pcall(app.learn_exit_floors)
    if not xok then diag.log('exits', xerr) end
    local dok, derr = pcall(app.tick_dat_floors)
    if not dok then
        diag.log('exits', derr)
        if state.dat_job then
            state.dat_status[state.dat_job.zone] = 'failed'
            state.dat_job = nil
        end
    end
    if state.progress_due and now >= state.progress_due then app.save_progress('timer') end
    if state.settings_due and now >= state.settings_due then app.save_settings() end
    local pok, perr = pcall(app.tick_possession)
    if not pok then diag.log('possession', perr) end
    app.tick_compass()
    local glok, glerr = pcall(tick_game_log)
    if not glok then diag.log('gamelog', glerr) end
    local rok, rerr = pcall(app.tick_roe)
    if not rok then diag.log('roe', rerr) end
    pcall(apply_pending_book)
    if state.ready and not state.update_checked then
        local uok, uerr = pcall(app.check_update)
        if not uok then state.update_checked = true; diag.log('update', uerr) end
    end
    if state.pending_shortcut then
        local list = state.pending_shortcut
        state.pending_shortcut = false
        if type(list) ~= 'table' then list = { 'open_book' } end
        for _, k in ipairs(list) do
            local sok, serr = pcall(app.shortcut_run, k)
            if not sok then diag.log('shortcut', serr) end
        end
    end
    -- 操作の相手が消えたまま（ピンが無くなった・お知らせが消えた）なら、操作の印も外す（0.1.188〜、t310）。
    -- 残しておくと、次にピン・お知らせが出たとき、知らないうちに操作中に戻って入力を取ってしまう
    if (state.active == 'tracker' or state.active == 'popup') and not app.operating() then
        state.popup_back = nil
        app.release()
    end
    local mok, merr = pcall(app.tick_game_menus)
    if not mok then diag.log('gameui', merr) end
    local gok, gerr = pcall(app.sync_gameui)
    if not gok then diag.log('gameui', gerr) end
    -- 押し続けた方向の繰り返し
    local h = state.held
    if h then
        if not app.operating() then
            state.held = nil
        elseif now >= h.next_at then
            do_action(h.action)
            local every = (S.input.repeat_ms or 200) / 1000
            if app.slider_held(h.action) then every = every / app.SLIDER_SPEED end
            h.next_at = now + every
        end
    end
    if state.flash and now > state.flash.until_t then state.flash = nil end
    popup_tick(now)
end

-- 画面の文脈（ui）を組み立てる
-- クライアントの地図 DAT を読み、テクスチャにする（失敗は方眼へ）。成功と形式エラーは覚え、パスやデバイスの失敗はやり直す。
local map_images = {}

function app.load_map_image(file_id)
    file_id = tonumber(file_id)
    if not file_id then return nil, 'no_id' end
    local hit = map_images[file_id]
    if hit then
        if hit.tex then return hit end
        if hit.err and hit.err ~= 'no_path' and hit.err ~= 'no_device' and hit.err ~= 'no_texture' and hit.err ~= 'create_failed' and hit.err ~= 'lock_failed' then
            return nil, hit.err
        end
    end
    if not P.get_file_path then
        map_images[file_id] = { err = 'no_path' }
        return nil, 'no_path'
    end
    local path, why = P.get_file_path(file_id)
    if not path then
        return nil, why or 'no_path'
    end
    local img, dwhy = map_dat_mod.decode_file(path, P.fs)
    if not img then
        map_images[file_id] = { err = dwhy or 'decode' }
        return nil, dwhy or 'decode'
    end
    if not P.load_texture then
        return nil, 'no_texture'
    end
    local tex, tw = P.load_texture(img)
    if not tex then
        return nil, tw or 'no_texture'
    end
    local out = { tex = tex, width = img.width, height = img.height }
    map_images[file_id] = out
    return out
end

local function make_ui(imgui)
    -- 0.1.245：見た目の縁取り・影は使わない。set_text_fx は保存値で落ちないようにするだけ。
    -- wrap_imgui は使わない。描画中に公式の文字箱（spawn）は作らない。
    local theme = require('src.ui.theme')
    theme.set_text_fx(S)
    local ui = {
        imgui = imgui, t = T, data = D, progress = PR, settings = S, state = state,
        reduce_motion = S.reduce_motion, addon_version = app.VERSION,
        player = state.player, hovered_any = false, text_active = false,
    }
    ui.activate = app.activate
    ui.release = app.release
    ui.mark_settings_dirty = app.mark_settings_dirty
    ui.request = app.request
    ui.possession = app.possession
    ui.tracker_check = app.tracker_check
    ui.tracker_step = app.tracker_step
    ui.manual_checks = app.manual_checks
    ui.state_buttons = app.state_buttons
    ui.open_detail = app.open_detail
    ui.select_in_book = app.select_in_book
    ui.open_detail_solo = app.open_detail_solo
    ui.open_map = app.open_map
    ui.copy_to_clipboard = app.copy_to_clipboard
    ui.current_weather = function ()
        if not P.current_weather then return nil end
        local ok, n = pcall(P.current_weather)
        if ok then return n end
        return nil
    end
    ui.load_map_image = app.load_map_image
    ui.exit_floors = app.exit_floors
    ui.dat_floors = app.dat_floors
    ui.want_dat_floors = app.want_dat_floors
    ui.log = diag.log
    ui.open_window = app.open_window
    ui.close_window = app.close_window
    ui.show_tracker = app.show_tracker
    ui.popup_choose = app.popup_choose
    ui.popup_preview = app.popup_preview
    ui.popup_anim = app.popup_anim
    ui.play_sound = function (kind) return app.play_sound(kind, true) end
    ui.can_play_sound = function () return P.can_play_sound ~= nil and P.can_play_sound() == true end
    ui.popup_target = app.popup_target
    ui.set_tracker_visible = app.set_tracker_visible
    ui.toggle_tracker = app.toggle_tracker
    ui.flash = app.flash
    -- エミネンス（0.1.172〜）
    ui.roe_db = app.roe_db
    ui.roe_send = app.roe_send
    ui.roe_can = app.roe_can
    ui.roe_failed = app.roe_failed
    ui.roe_rotation = app.roe_rotation
    ui.roe_why_text = app.roe_why_text
    ui.roe_active_entry = app.roe_active_entry
    ui.roe_active_count = app.roe_active_count
    ui.toggle_eminence = app.toggle_eminence
    ui.set_eminence_visible = app.set_eminence_visible
    ui.toggle_compass = app.toggle_compass
    ui.set_compass_visible = app.set_compass_visible
    ui.save_now = function () app.save_all('manual'); app.flash(T('msg.saved')) end
    ui.layout_slots = app.layout_slots
    ui.set_layout_name = app.set_layout_name
    ui.save_layout = function (i)
        local ok, why = app.save_layout(i)
        if ok then app.flash(T('settings.layout_saved'))
        elseif why == 'no_dir' then app.flash(T('settings.layout_no_dir')) end
        return ok
    end
    ui.load_layout = function (i)
        local ok, why = app.load_layout(i)
        if ok then app.flash(T('settings.layout_loaded'))
        elseif why == 'empty' then app.flash(T('settings.layout_empty')) end
        return ok
    end
    ui.set_language = function (lang) I:set_language(lang) end
    ui.capabilities = P.capabilities
    ui.shortcut_info = app.shortcut_info
    ui.shortcut_capture_start = app.shortcut_capture_start
    ui.shortcut_capture_cancel = app.shortcut_capture_cancel
    ui.shortcut_set = app.shortcut_set
    ui.platform = P
    ui.inventory_count = app.have_for_need
    ui.need_possession = app.need_possession
    ui.player_status = function () return state.rstat end
    ui.bring_inside = function ()
        local dw, dh = window.display_size(imgui)
        for _, ws in pairs(S.windows) do
            if ws.x then ws.x = math.max(0, math.min(ws.x, dw - 80)) end
            if ws.y then ws.y = math.max(0, math.min(ws.y, dh - 60)) end
        end
        window.reapply()
        app.mark_settings_dirty()
    end
    ui.reset_layout = function ()
        for _, ws in pairs(S.windows) do ws.x, ws.y, ws.w, ws.h = nil, nil, nil, nil end
        window.reapply()
        app.mark_settings_dirty()
    end
    ui.status_line = function ()
        if not state.ready then
            W.colored(ui, 'warn', T('status.waiting'))
        elseif state.read_only then
            W.colored(ui, 'warn', T('status.read_only.' .. state.read_only))
        end
        if state.recovered then W.colored(ui, 'warn', T('status.recovered', { src = state.recovered })) end
        -- 緑色の短い案内は窓の見出しの帯へ移した（0.1.233〜）。ここでは出さない（中身がずれないように）。
    end
    return ui
end

local screens
local perf_names = {}

function app.present()
    local imgui = P.imgui
    if not imgui then return end
    local t_frame = perf.start()
    perf.frame()
    local now = P.time()
    local t_tick = perf.start()
    app.tick(now)
    perf.stop('tick', t_tick)
    -- 0.1.246：フォントの読み込みは描画の前に一度だけ（描画の途中では足さない）
    -- 0.1.250：選んだ日本語・英字・数字のフォントをここで読む
    -- 0.1.251：tick（ログイン）のあと。先に初期値のメイリオで読むと、保存した選択に切り替えられない。
    if state.ready then
        require('src.ui.crisp_font').ensure(imgui, S)
    end
    if not screens then
        screens = {
            book = require('src.ui.book'), detail = require('src.ui.detail'),
            tracker = require('src.ui.tracker'), compass = require('src.ui.compass'),
            entry = require('src.ui.entry'),
            notices = require('src.ui.notices'), map_view = require('src.ui.map_view'),
            eminence = require('src.ui.eminence'),
        }
        perf_names = {}
        for k, m in pairs(screens) do
            if type(m.draw) == 'function' then perf_names[m.draw] = k end
        end
        perf_names[screens.notices.draw_resume] = 'resume'
        perf_names[screens.notices.draw_popup] = 'popup'
    end
    local ui = make_ui(imgui)
    local theme = require('src.ui.theme')
    if theme.body_fx_stats_reset then theme.body_fx_stats_reset() end
    W.frame_start(imgui)

    local function guarded(fn, ...)
        local t0 = perf.start()
        local ok, err = pcall(fn, ...)
        if t0 then perf.stop(perf_names[fn] or 'other', t0) end
        if not ok then
            window.unwind(ui)
            diag.log('ui', err)
            if tostring(err) ~= state.last_ui_err then
                state.last_ui_err = tostring(err)
                P.print('画面の表示で問題が起きました: ' .. state.last_ui_err)
            end
        end
        if ui._stack and #ui._stack > 0 then
            window.unwind(ui)
            diag.log('ui', 'unbalanced begin/end')
        end
    end

    -- 頭上の印は窓より後ろ（ゲーム画面の上）に出す
    do
        local t_marks = perf.start()
        local ok, res = pcall(marks_ui.draw, ui)
        perf.stop('marks', t_marks)
        if ok and type(res) == 'table' then
            state.last_marks = res
        elseif not ok then
            state.last_marks = { err = tostring(res) }
            diag.log('marks', res)
        end
    end

    if S.entry_icon.visible and not state.open.book then guarded(screens.entry.draw, ui) end
    if screens.tracker.visible(ui) then guarded(screens.tracker.draw, ui) end
    if app.book_visible() then guarded(screens.book.draw, ui) end
    if state.open.detail then guarded(screens.detail.draw, ui) end
    if state.open.map then guarded(screens.map_view.draw, ui) end
    if state.ready and S.eminence.visible then guarded(screens.eminence.draw, ui) end
    if state.ready and S.compass.visible then guarded(screens.compass.draw, ui) end
    guarded(screens.notices.draw_resume, ui, now)
    if S.notify.popup then guarded(screens.notices.draw_popup, ui, now) end

    state.text_active = ui.text_active
    -- デバッグがオンのときだけ、本文の重ね描き回数を VanaCore のログへ 1 回出す
    if not state.body_fx_logged and theme.body_fx_stats and S and S.debug and S.debug.state_buttons == true then
        local st = theme.body_fx_stats()
        state.body_fx_logged = true
        P.print(string.format('body fx: on=%s calls=%s adds=%s area=%s outline=%s shadow=%s',
            tostring(st.on), tostring(st.calls), tostring(st.adds), tostring(st.area or '-'),
            tostring(S.font_outline), tostring(S.font_shadow_color)))
    end
    perf.stop('frame', t_frame)
    -- 自分の窓の外（ゲーム画面）をクリックしたら操作を終え、入力をゲームへ返す
    if state.active and imgui.IsMouseClicked(0) and not ui.hovered_any then
        app.release()
    end
end

---------------------------------------------------------------------------
-- コマンド
---------------------------------------------------------------------------

local function fmt_coord(v)
    v = tonumber(v)
    if v == nil then return '-' end
    return string.format('%.2f', v)
end

-- ターゲットのマス目。複数 MAP で食い違うときだけ MAP 番号も出す。
local function target_grid_text(tgt)
    local core = marks_ui.core
    if not core or not D or not tgt or tgt.x == nil or tgt.y == nil then
        return '-'
    end
    local player = P.player and P.player()
    local zone_id = player and player.zone_id
    local floors = maps_mod.floors(D, zone_id) or {}
    if #floors == 0 then
        return core.grid_of(D, zone_id, tgt.x, tgt.y) or '-'
    end
    local parts, first, all_same = {}, nil, true
    for _, floor in ipairs(floors) do
        local g = core.grid_of(D, zone_id, tgt.x, tgt.y, floor.map_n)
        if g then
            parts[#parts + 1] = { g = g, n = floor.map_n }
            if first == nil then
                first = g
            elseif first ~= g then
                all_same = false
            end
        end
    end
    if #parts == 0 then return '-' end
    if all_same then return first end
    local bits = {}
    for _, r in ipairs(parts) do
        bits[#bits + 1] = 'MAP ' .. tostring(r.n) .. ':' .. r.g
    end
    return table.concat(bits, '、')
end

local function target_want_note(name, grid_text)
    local core = marks_ui.core
    if not core or not D or not PR or not name then return '' end
    local player = P.player and P.player()
    local zone_id = player and player.zone_id
    local wanted = core.in_zone(core.wanted(D, PR, { status = state.rstat, debug = app.state_buttons() }), zone_id)
    local computed = grid_text
    if type(computed) == 'string' and computed:find(':', 1, true) then
        computed = computed:match(':([A-Za-z]%-?%d+)')
    end
    if computed == '-' then computed = nil end
    for _, w in ipairs(wanted) do
        if core.same_name(w.name, name) and w.grid then
            local d = computed and core.grid_dist(computed, w.grid) or nil
            local rel
            if d == 0 then
                rel = T('cmd.target_exact')
            elseif d == 1 then
                rel = T('cmd.target_near')
            elseif d then
                rel = T('cmd.target_far')
            else
                rel = T('cmd.target_grid_unknown')
            end
            return T('cmd.target_note', { grid = w.grid, rel = rel })
        end
    end
    return ''
end

-- /astertrail と短い /ast（0.1.196〜）。/assist や /as には合わせない

-- ターゲット（いなければ自分）の ID・読み込み番号・「出ている」合図（0.1.215〜）
local function target_id_line(tgt)
    local idx = tgt and tonumber(tgt.index) or nil
    local e
    if idx and P.game_entity then
        local ok, r = pcall(P.game_entity, idx)
        if ok and type(r) == 'table' then e = r end
    end
    local id = (e and tonumber(e.id)) or tonumber(tgt and tgt.id) or tonumber(tgt and tgt.server_id)
    local render = (e and tonumber(e.render_flags)) or tonumber(tgt and tgt.render_flags)
    local shown
    if P._render_shown then
        shown = P._render_shown(render)
    end
    local shown_text = '?'
    if shown == true then
        shown_text = T('cmd.target_shown')
    elseif shown == false then
        shown_text = T('cmd.target_hidden')
    end
    local id_text, idx_text, flags_text = '?', '?', '?'
    if id then id_text = tostring(math.floor(id)) end
    if idx then idx_text = tostring(math.floor(idx)) end
    if render then flags_text = string.format('0x%X', math.floor(render)) end
    return T('cmd.target_id', { id = id_text, index = idx_text, shown = shown_text, flags = flags_text })
end

function app.is_addon_command(text)
    local head = util.lower((util.split_words(text or '')[1]) or '')
    return head == '/astertrail' or head == '/ast'
end

function app.command(text)
    local args = util.split_words(text)
    local head = util.lower(args[1] or '')
    if not app.is_addon_command(text) then return false end
    local sub = util.lower(args[2] or '')
    local arg = util.lower(args[3] or '')
    if sub == '' or sub == 'open' or sub == 'book' then
        app.open_window('book')
    elseif sub == 'toggle' then
        if state.open.book then app.close_window('book') else app.open_window('book') end
    elseif sub == 'close' then
        app.close_all()
    elseif sub == 'tracker' then
        if arg == 'hide' then app.set_tracker_visible(false)
        elseif arg == 'focus' then
            app.enter_tracker()
        else app.set_tracker_visible(true) end
    elseif sub == 'compass' then
        if arg == 'show' then app.set_compass_visible(true)
        elseif arg == 'hide' then app.set_compass_visible(false)
        else app.toggle_compass() end
    elseif sub == 'settings' or sub == 'config' then
        app.open_window('settings')
    elseif sub == 'map' then
        app.open_map()
    elseif sub == 'focus' then
        for _, n in ipairs({ 'detail', 'book', 'settings' }) do
            if state.open[n] then app.activate(n); return true end
        end
        app.enter_tracker()
    elseif sub == 'notice' then
        -- 受注・完了のお知らせ（0.1.183〜）を先に。キー・パッドで選べる
        if state.popups[1] and S.notify.popup then
            if state.active ~= 'popup' then state.popup_back = state.active end
            app.activate('popup')
        elseif state.resume then app.activate('resume') end
    elseif sub == 'release' then
        app.release()
    elseif sub == 'save' then
        app.save_all('manual')
        P.print(T('msg.saved'))
    elseif sub == 'debug' then
        -- /astertrail debug buttons [on|off]（0.1.187〜、t308）：手で状態を変えるボタンを出す・隠す
        local what, onoff = arg, util.lower(args[4] or '')
        if what == 'perf' then
            -- /astertrail debug perf [on|off|show]（0.1.210〜）：1フレームの重さを測る。公開版でも使える
            if onoff == 'show' then
                P.print(perf.summary())
            else
                local on
                if onoff == 'on' then on = true elseif onoff == 'off' then on = false else on = not perf.enabled end
                if not on and perf.enabled then P.print(perf.summary()) end
                perf.set(on)
                P.print(T(on and 'cmd.debug_perf_on' or 'cmd.debug_perf_off'))
            end
        elseif app.PUBLIC then
            P.print(T('cmd.debug_public'))
        elseif what == 'buttons' then
            local on
            if onoff == 'on' then on = true elseif onoff == 'off' then on = false else on = not app.state_buttons() end
            app.set_state_buttons(on)
            P.print(T(on and 'cmd.debug_buttons_on' or 'cmd.debug_buttons_off'))
        else
            P.print(T('cmd.debug_help'))
        end
    elseif sub == 'menus' then
        -- ゲームのメニューの読み取りの様子（0.1.186〜。ホームポイントなどを開いたまま打って確かめる）
        local open, info = nil, {}
        if P.game_menu_state then open, info = P.game_menu_state() end
        info = info or {}
        local function yn(v) if v == nil then return '-' end return v and T('common.yes') or T('common.no') end
        P.print(T('cmd.menus', {
            open = yn(open), flag = yn(info.flag),
            focused = (info.focused and #info.focused > 0) and table.concat(info.focused, ', ') or '-',
            top = yn(state.game_on_top == true), can = yn(P.can_game_on_top and P.can_game_on_top()),
        }))
        -- 0.1.189〜：メニューの窓と、それに重なって引っ込めているこちらの窓
        local rn = {}
        for _, r in ipairs(info.rects or {}) do rn[#rn + 1] = r.name end
        local yw = {}
        for _, n in ipairs(require('src.ui.window').yielding()) do yw[#yw + 1] = T('cmd.menus_win_' .. n) end
        P.print(T('cmd.menus_yield', { menus = #rn > 0 and table.concat(rn, ', ') or '-',
            wins = #yw > 0 and table.concat(yw, '・') or '-' }))
    elseif sub == 'icons' then
        -- 自分のアイコン（assets/marks/）を読み直す（0.1.185〜、t301）
        local r = P.reload_icons and P.reload_icons() or nil
        if not r then
            P.print(T('cmd.icons_none'))
        else
            P.print(T('cmd.icons', { user = #r.user > 0 and table.concat(r.user, ', ') or T('cmd.icons_user_none'),
                n = #r.example }))
        end
    elseif sub == 'marks' then
        S.marks = S.marks or {}
        -- 0.1.59〜：表示の4つをまとめて切り替える。オンはいつもの見た目（近くのオブジェクト名はそのまま）、オフは4つともオフ
        local turn_on
        if arg == 'on' or arg == 'off' then
            turn_on = (arg == 'on')
        else
            turn_on = not require('src.core.settings').marks_active(S)
        end
        if turn_on then
            S.marks.show_icons, S.marks.show_quest_name, S.marks.show_object_names = true, true, true
        else
            S.marks.show_icons, S.marks.show_quest_name, S.marks.show_object_names, S.marks.show_nearby_names = false, false, false, false
        end
        app.mark_settings_dirty()
        local m = state.last_marks or {}
        local pok, pnote = P.project_status and P.project_status()
        local note = ''
        if m.how then
            note = ' [' .. tostring(m.how) .. ']'
        end
        if m.err then
            note = note .. T('cmd.marks_note', { text = m.err })
        elseif pnote then
            note = note .. T('cmd.marks_note', { text = pnote })
        end
        if m.who and m.who ~= '' then
            note = note .. ' ' .. m.who
        end
        if m.detail and m.detail ~= '' then
            note = note .. T('cmd.marks_note', { text = m.detail })
        end
        P.print(T('cmd.marks', {
            state = require('src.core.settings').marks_active(S) and T('cmd.marks_on') or T('cmd.marks_off'),
            ents = tostring(m.entities or '-'),
            matched = tostring(m.matched or '-'),
            drawn = tostring(m.drawn or '-'),
            note = note,
        }))
    elseif sub == 'status' then
        P.print(T('cmd.status', {
            ver = app.VERSION, data = D.version or '?',
            char = state.char_folder or T('status.waiting'),
            ro = state.read_only or '-',
            op = state.active or '-',
        }))
        -- 読めたジョブ・レベル・所属国・ランク（0.1.65〜）と、話して覚えた名声（0.1.66〜）
        do
            local ps = state.pstat
            if ps then
                local nat = ({ [0] = T('nation.sandoria'), [1] = T('nation.bastok'), [2] = T('nation.windurst') })[ps.nation or -1]
                P.print(T('cmd.player_status', {
                    job = tostring(ps.main_job or '-'), level = tostring(ps.main_job_level or '-'),
                    nation = nat or '-', rank = tostring(ps.rank or '-'), src = tostring(ps.source or '-'),
                }))
            else
                P.print(T('cmd.player_status_none'))
            end
            -- 話して覚えた名声（0.1.66〜）
            P.print(app.fame_line())
        end
        local m = state.last_marks or {}
        local pok, pnote = P.project_status and P.project_status()
        local note = ''
        if m.how then
            note = ' [' .. tostring(m.how) .. ']'
        end
        if m.err then
            note = note .. T('cmd.marks_note', { text = m.err })
        elseif pnote then
            note = note .. T('cmd.marks_note', { text = pnote })
        elseif pok == false then
            note = note .. T('cmd.marks_note', { text = T('settings.marks_no_project') })
        end
        if m.who and m.who ~= '' then
            note = note .. ' ' .. m.who
        end
        if m.detail and m.detail ~= '' then
            note = note .. T('cmd.marks_note', { text = m.detail })
        end
        P.print(T('cmd.marks', {
            state = require('src.core.settings').marks_active(S) and T('cmd.marks_on') or T('cmd.marks_off'),
            ents = tostring(m.entities or '-'),
            matched = tostring(m.matched or '-'),
            drawn = tostring(m.drawn or '-'),
            note = note,
        }))
    elseif sub == 'target' or sub == 'pos' then
        local tgt = P.current_target and P.current_target()
        if type(tgt) ~= 'table' then
            -- ターゲットがいないときは自分の座標と ID を出す（0.1.215〜）
            local pl = P.player and P.player()
            if type(pl) == 'table' and (pl.ready == true or (pl.name and pl.name ~= '') or pl.x ~= nil) then
                tgt = {
                    name = pl.name, x = pl.x, y = pl.y, z = pl.z,
                    index = pl.index, id = pl.id, server_id = pl.server_id,
                    render_flags = pl.render_flags,
                }
            end
        end
        if type(tgt) ~= 'table' then
            P.print(T('cmd.target_none'))
        else
            local name = tgt.name
            if marks_ui.norm_name then
                name = marks_ui.norm_name(name) or name
            end
            if not name or name == '' then name = '-' end
            local grid = target_grid_text(tgt)
            P.print(T('cmd.target', {
                name = name,
                x = fmt_coord(tgt.x),
                y = fmt_coord(tgt.y),
                z = fmt_coord(tgt.z),
                grid = grid,
                note = target_want_note(name, grid),
            }))
            P.print(target_id_line(tgt))
            -- アイコンのズーム合わせ（試し）の縮み具合
            if P.zoom_info and tgt.index then
                local f, h, ref = P.zoom_info(tgt.index)
                if f then
                    P.print(T('cmd.target_zoom', { f = string.format('%.2f', f), h = string.format('%.1f', h or 0),
                        ref = string.format('%.1f', ref or 0), state = (S.marks.zoom_follow ~= false) and T('common.on') or T('common.off') }))
                elseif P.place_zoom_info and tgt.x and tgt.y then
                    -- 名前の出ない相手（??? など）は点の距離で
                    local pf, d = P.place_zoom_info(tgt.x, tgt.y, tgt.z or 0)
                    if pf then
                        P.print(T('cmd.target_zoom_place', { f = string.format('%.2f', pf), d = string.format('%.1f', d or 0),
                            ref = tostring(P.place_ref_distance and P.place_ref_distance() or '?'),
                            state = (S.marks.zoom_follow ~= false) and T('common.on') or T('common.off') }))
                    else
                        P.print(T('cmd.target_zoom_none'))
                    end
                else
                    P.print(T('cmd.target_zoom_none'))
                end
            end
        end
    elseif sub == 'floor' then
        local f = app.poll_floor(true) or {}
        local zone = f.zone_id or (state.player and state.player.zone_id)
        local st = P.floor_status and P.floor_status() or {}
        local bits = {}
        if f.why then bits[#bits + 1] = tostring(f.why) end
        if st.source then bits[#bits + 1] = tostring(st.source) end
        P.print(T('cmd.floor', {
            zone = tostring(zone or '-'),
            zone_name = (zone and D:zone_name(zone)) or '-',
            fid = f.floor_id ~= nil and tostring(f.floor_id) or T('cmd.floor_unknown'),
            map = f.map_n ~= nil and tostring(f.map_n) or T('cmd.floor_unknown'),
            note = (#bits > 0) and (' [' .. table.concat(bits, ' / ') .. ']') or '',
        }))
    elseif sub == 'gamelog' then
        -- ゲームの記録の読み取りの様子（0.1.169〜）。arg が read なら今すぐ読み直す（読むだけ）
        if arg == 'read' then app.read_game_log('command') end
        local g = state.glog
        local st = P.quest_log_status and P.quest_log_status() or {}
        P.print(T('cmd.gamelog', {
            mem = st.found and T('cmd.gamelog_ok') or (T('cmd.gamelog_ng') .. (st.why and (' ' .. tostring(st.why)) or '')),
            pk = st.packets and T('cmd.gamelog_ok') or T('cmd.gamelog_ng'),
            ports = tostring(g.snap and game_log.port_count(g.snap) or 0),
            packets = tostring(g.packets),
            refs = tostring(D.game_ref_count or 0),
            changed = tostring(g.changed),
            last = g.last and (tostring(g.last.why) .. ' ' .. tostring(g.last.n)) or '-',
        }))
    elseif sub == 'eminence' or sub == 'roe' then
        -- エミネンス（0.1.172〜）：eminence で窓を出す・隠す（show / hide）。roe は様子（reload で DAT を読み直す、read で場所を読み直す）
        if sub == 'eminence' and arg ~= 'status' then
            if arg == 'show' then app.set_eminence_visible(true)
            elseif arg == 'hide' then app.set_eminence_visible(false)
            else app.toggle_eminence() end
            return true
        end
        if arg == 'reload' then app.roe_reload_db() end
        if arg == 'read' then app.read_roe('command') end
        local r = state.roe
        local st = P.roe_status and P.roe_status() or {}
        local db = app.roe_db()
        local nf = 0
        for _ in pairs(S.eminence.failed or {}) do nf = nf + 1 end
        P.print(T('cmd.roe', {
            mem = st.found and T('cmd.gamelog_ok') or (T('cmd.gamelog_ng') .. (st.why and (' ' .. tostring(st.why)) or '')),
            pk = st.packets and T('cmd.gamelog_ok') or T('cmd.gamelog_ng'),
            send = st.can_send and T('cmd.gamelog_ok') or T('cmd.gamelog_ng'),
            active = r.active and tostring(app.roe_active_count()) or '-',
            done = r.complete and T('cmd.gamelog_ok') or '-',
            dat = db and tostring(db.count) or ('- ' .. tostring(r.db_why or '')),
            failed = tostring(nf),
        }))
        local gs = r.game_sent
        if gs then
            P.print(T('cmd.roe_game_sent', { pid = string.format('0x%03X', gs.pid), id = tostring(gs.id or '-'),
                hex = gs.hex, same = gs.same and T('cmd.roe_same') or T('cmd.roe_diff') }))
        end
        if r.last_send then
            P.print(T('cmd.roe_last_send', { op = r.last_send.op, id = tostring(r.last_send.id), name = roe_name(r.last_send.id) }))
        end
    elseif sub == 'resetlayout' then
        for _, ws in pairs(S.windows) do ws.x, ws.y, ws.w, ws.h = nil, nil, nil, nil end
        window.reapply()
        app.mark_settings_dirty()
    else
        P.print(T('cmd.help'))
    end
    return true
end

function app.unload()
    if P.clear_name_marks then pcall(P.clear_name_marks) end
    if P.clear_ground_rings then pcall(P.clear_ground_rings) end
    app.release()
    app.release_gameui()
    app.save_all('unload')
end

return app
