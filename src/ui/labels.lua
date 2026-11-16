-- Astertrail - 状態などの表示（文字と形を併用。色だけに頼らない）

local labels = {}

-- 形（JIS の記号だけを使う）
labels.STATE_SHAPE = {
    not_accepted = '□',
    accepted = '△',
    completed = '●',
}

function labels.state(t, st)
    if st == 'unknown' or not labels.STATE_SHAPE[st] then st = 'not_accepted' end
    return labels.STATE_SHAPE[st] .. ' ' .. t('state.' .. st)
end

function labels.state_color(st)
    if st == 'accepted' then return 'accent' end
    if st == 'completed' then return 'good' end
    return 'muted'
end

-- 画面に出すクエスト／ミッション名：資料の日本語名。無ければ英語のまま（作らない）
function labels.qname(q)
    if not q then return '' end
    local n = q.name_ja_ref
    if type(n) == 'string' and n ~= '' then return n end
    return q.name_en or q.id or ''
end

-- 本の報酬の列：資料の日本語名を「、」でつなぐ（無ければ空）
function labels.rewards_cell(q)
    local parts = {}
    for _, r in ipairs(q and q.rewards or {}) do
        local n = r.name_ja or r.name_en
        if n and n ~= '' then parts[#parts + 1] = n end
    end
    return table.concat(parts, '、')
end

function labels.reward(t, r)
    if r.kind == 'title' then return t('reward.title', { name = r.name_ja or r.name_en or '?' }) end
    if r.kind == 'key_item' then return t('reward.key_item', { name = r.name_ja or r.name_en or '?' }) end
    return r.name_ja or r.name_en or '?'
end

function labels.need(t, n)
    local name = n.name_ja or n.name_en or '?'
    local s = t('need.count', { name = name, count = n.count or 1 })
    if n.kind == 'key_item' then s = t('need.key_item', { text = s }) end
    return s
end

-- 天候の指定がある書き方か（時間帯だけなら false）
local WEATHER_WORDS = { '晴', '曇', '霧', '熱波', '雨', 'スコール', '砂', '風', '雪', '吹雪', '雷', 'オーロラ', '神光', '闇' }
function labels.has_weather(text)
    if type(text) ~= 'string' or text == '' then return false end
    for _, w in ipairs(WEATHER_WORDS) do
        if text:find(w, 1, true) then return true end
    end
    return false
end

-- 時間帯・天候の1行。天候の指定があって、いまの天候が読めれば（現在: ○○）を足す
function labels.time_weather(t, text, weather_id)
    if labels.has_weather(text) and type(weather_id) == 'number' and weather_id >= 0 and weather_id <= 19 then
        return t('detail.time_weather_now', { text = text, now = t('weather.' .. weather_id) })
    end
    return t('detail.time_weather', { text = text })
end

return labels
