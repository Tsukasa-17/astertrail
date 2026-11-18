--[[
  Astertrail - マイレイアウト（0.1.194〜）
  各窓の位置・大きさ・出す／隠すと、見た目や列などの設定をスロットに覚える。
  進行・ピン・お気に入り・名声・デバッグは入れない。YunaUI のコードは写していない。
]]

local json = require('src.lib.json')
local util = require('src.lib.util')
local settings_mod = require('src.core.settings')

local layouts = {
    COUNT = 5,
    SCHEMA = 1,
    KIND = 'astertrail_layouts',
    FILE = 'layouts.json',
}

-- スナップショットに入れる設定（これ以外は今の値のまま）
layouts.KEYS = {
    'language', 'font_scale', 'font_outline', 'font_outline_alpha',
    'font_shadow', 'font_shadow_color', 'font_shadow_distance', 'font_shadow_alpha', 'font_body_fx',
    'fonts', 'layout_locked', 'theme', 'background_alpha', 'alphas',
    'reduce_motion', 'windows', 'entry_icon', 'remember_position', 'look', 'book',
    'tracker', 'items', 'compass', 'notify', 'backup', 'diagnostics', 'auto_detect',
    'map', 'marks', 'input', 'update_notice', 'shortcut', 'gameui',
}

-- エミネンス：ピン・お気に入り・受けられなかった記憶は入れない
layouts.EMINENCE_KEYS = {
    'visible', 'collapsed', 'filter', 'near_pct',
    'book_root', 'book_state', 'book_show', 'book_text', 'book_favs_only', 'columns', 'hidden',
}

function layouts.clean_name(s)
    if type(s) ~= 'string' then return '' end
    s = s:gsub('[\r\n\t]', ' '):gsub(' +', ' '):gsub('^%s+', ''):gsub('%s+$', '')
    if #s > 60 then s = s:sub(1, 60) end
    return s
end

function layouts.empty_slot()
    return { name = '', saved = false }
end

function layouts.empty_slots()
    local out = json.array({})
    for i = 1, layouts.COUNT do out[i] = layouts.empty_slot() end
    return out
end

function layouts.capture_settings(S)
    local out = {}
    if type(S) ~= 'table' then return out end
    for _, k in ipairs(layouts.KEYS) do
        out[k] = util.deep_copy(S[k])
    end
    out.eminence = json.object({})
    local E = type(S.eminence) == 'table' and S.eminence or {}
    for _, k in ipairs(layouts.EMINENCE_KEYS) do
        out.eminence[k] = util.deep_copy(E[k])
    end
    out.settings_schema = settings_mod.SCHEMA
    return out
end

function layouts.capture_open(state, S)
    state = state or {}
    local open = type(state.open) == 'table' and state.open or {}
    S = S or {}
    return {
        book = open.book == true,
        detail = open.detail == true,
        map = open.map == true,
        tracker = S.tracker and S.tracker.visible == true or false,
        eminence = S.eminence and S.eminence.visible == true or false,
        compass = S.compass and S.compass.visible == true or false,
        entry = S.entry_icon and S.entry_icon.visible == true or false,
    }
end

-- 欠け・古いキーは settings.merge で補う。ピン・お気に入り・名声・デバッグは触らない
function layouts.apply_settings(S, snap)
    if type(S) ~= 'table' then return false end
    local merged = settings_mod.merge(type(snap) == 'table' and snap or {})
    for _, k in ipairs(layouts.KEYS) do
        S[k] = util.deep_copy(merged[k])
    end
    S.eminence = S.eminence or {}
    for _, k in ipairs(layouts.EMINENCE_KEYS) do
        S.eminence[k] = util.deep_copy(merged.eminence[k])
    end
    -- スナップに見た目があるときはそのまま使う（defaults_rev が無い古い枠でも、保存した見た目を移さない）
    local look = type(snap) == 'table' and snap.look
    if look == 'yunaui' or look == 'classic' then S.look = look end
    return true
end

local function slot_from(raw)
    local s = layouts.empty_slot()
    if type(raw) ~= 'table' then return s end
    s.name = layouts.clean_name(raw.name)
    if raw.saved == true and type(raw.settings) == 'table' then
        s.saved = true
        s.settings = raw.settings
        if type(raw.open) == 'table' then s.open = raw.open end
        if type(raw.at) == 'string' then s.at = raw.at end
    end
    return s
end

function layouts.normalize(raw)
    local slots = layouts.empty_slots()
    local src = type(raw) == 'table' and (raw.slots or raw)
    if type(src) == 'table' then
        for i = 1, layouts.COUNT do
            slots[i] = slot_from(src[i])
        end
    end
    return {
        data_kind = layouts.KIND,
        schema = layouts.SCHEMA,
        slots = slots,
    }
end

function layouts.file_of(slots)
    slots = layouts.normalize({ slots = slots }).slots
    return {
        data_kind = layouts.KIND,
        schema = layouts.SCHEMA,
        slots = slots,
    }
end

return layouts
