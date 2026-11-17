--[[
  Astertrail - 頭上マークの対象（描画とゲーム API は含まない）
  見えている相手そのものに印を付ける。固定座標だけには頼らない。
  同名はゾーン＋名前＋座標。動く相手は名前だけで、座標には頼らない。
  「???」は座標が無いと付けない（同名が多いため）。
  マス目はぴったり同じか、その隣（境目で隣のマスに落ちたとき用）。
  ぴったり合う相手がいれば、そちらだけを付ける。
]]

local maps = require('src.core.maps')

local marks = {}

-- 同じ相手に複数の役割があるときの優先（小さいほど先）
marks.ROLE_RANK = { hunt = 1, talk = 2, examine = 3, guard = 4, ['repeat'] = 5, fame = 6 }

--[[
  クエストの状態のアイコン（0.1.63〜）。役割（role：話す・調べる・討伐・ゲートガード）は置き場所と位置の調整に使い、
  見た目は icon で決める。意味は FF14 のジャーナルのアイコンの分け方を参考にしたもの（絵は自作）。
    main        ミッション（まだ始めていない、次のミッション）
    sub         まだ受けていないクエスト。次ではないが、前提と条件を満たして受けられるミッション（0.1.196〜）
    repeat      くり返し受けられるクエスト（まだ受けていない・完了したもの）
    unavailable 受けられない（前提のクエスト・ミッションが済んでいないと分かるもの）
    progress    受注中のクエスト・ミッションの今の手順
    blocked     今の手順を進められない（必要な品が足りないと分かるとき。所持数が読めるようになってから）
    complete    目標達成（最後の手順の相手）
    hunt        討伐の相手（今までどおり）
    guard       ゲートガード（今までどおり）
    fame        名声を教えてくれる人（0.1.69〜）。いちばん下。同じ相手にクエストの印があれば、そちらを出す
  同じ相手に重なったときの優先（小さいほど先）：
]]
marks.ICON_RANK = {
    complete = 1, progress = 2, hunt = 3, blocked = 4, main = 5, sub = 6, ['repeat'] = 7, unavailable = 8, guard = 9,
    fame = 10,
}
marks.ICONS = { 'main', 'sub', 'repeat', 'unavailable', 'progress', 'blocked', 'complete', 'hunt', 'guard', 'fame' }

function marks.rank_of(w)
    if not w then return 99 end
    return marks.ICON_RANK[w.icon or ''] or (10 + (marks.ROLE_RANK[w.role] or 89))
end

-- ミッション番号の並び（SM1-1 → 1, 1）。order があればそれ（0.1.118〜、ジラートなど）。読めなければ大きな値
local function mission_order(q)
    if tonumber(q.order) then return tonumber(q.order) end
    local r, n = tostring(q.mission_no or ''):match('(%d+)%-(%d+)')
    return (tonumber(r) or 99) * 100 + (tonumber(n) or 99)
end

marks.mission_order = mission_order

-- 国ごとの「次のミッション」（まだ完了していない最初のもの）。受注中があればそれが次
-- 0.1.210〜：進み具合が変わったときだけ数え直す（一覧・頭上の印から毎フレーム呼ばれる）
local nm_memo = setmetatable({}, { __mode = 'k' })
function marks.next_missions(data, progress)
    local rev = progress and progress.rev or 0
    local m = progress and nm_memo[progress]
    if m and m.data == data and m.rev == rev then return m.out end
    local out = marks.next_missions_now(data, progress)
    if progress then nm_memo[progress] = { data = data, rev = rev, out = out } end
    return out
end
function marks.next_missions_now(data, progress)
    local best = {}
    for _, q in ipairs(data.quests or {}) do
        if q.kind == 'mission' and progress:state(q.id) ~= 'completed' then
            local cat = q.category or '?'
            local o = mission_order(q)
            if not best[cat] or o < best[cat].o then best[cat] = { o = o, id = q.id } end
        end
    end
    local out = {}
    for _, b in pairs(best) do out[b.id] = true end
    return out
end

-- 名前の照合用（0.1.196〜）。資料の name_ja_ref にある「（ミッション）」「（クエスト）」は、理由の文では付かないことが多い。
-- 中黒は全角・半角・中点が混ざる（モンストロス・プレッジ と モンストロス･プレッジ など）。
local function prereq_name_key(s)
    if type(s) ~= 'string' or s == '' then return s end
    s = s:gsub('（ミッション）$', ''):gsub('（クエスト）$', '')
    s = s:gsub('\239\189\165', '・'):gsub('\194\183', '・')  -- U+FF65 ･, U+00B7 · → U+30FB
    return s
end
marks.prereq_name_key = prereq_name_key

-- 前提のクエスト・ミッション（受けられない理由に「名前」とあり、名前が資料にあるもの）。
-- 「進行中は不可」「受けられない」のような打ち消しの理由は前提にしない。名声・ランク・レベルは読めないので数えない
--
-- 0.1.174〜（t264）：「クエスト「…」」「ミッション「…」」のほか、かっこだけの名前も読む。かっこのすぐあとの言葉で決める：
--   「X」クリア／終了／完了／コンプリート／を終えて／済み／達成／のあと … X が完了していること
--   「X」を受けている／を受ける …… X を受けている（または完了している）こと
--   「A」「B」「C」のどれか〜 ……… A・B・C のどれか1つ（「〜受けている」なら受けているだけでよい）
--   「X」で… 「X」の… 「X」まで… 「X」を持っている など ……… 前提にしない（品の名前やとちゅうの話のため）
--   「1回目の「神威」クリア」のように自分と同じ名前なら、同じ名前のほかの項目（1回目）を前提にする
-- 「クエスト／ミッション」と付いた名前は、あとの言葉が読めなくても前と同じく「完了していること」にする。
-- 返り値：{ { id, ... , accept = true or nil }, ... }（1つの組のどれかが済めばよい）
-- 「2回目からは〜」はくり返しのときだけの条件なので、前提にしない
local NEGATIVE = { '不可', '受けられない', 'でないこと', '2回目から', '2回目以降' }
local DONE_AFTER = { 'クリア', '終了', '完了', 'コンプリート', 'を終え', '終え', '済み', '達成', 'を達成', 'のあと', 'をすべて終え', 'をクリア', 'まで終え' }
local ACCEPT_AFTER = { 'を受けている', 'を受けていること', 'を受けるところ', '受けている', 'まで進' }
-- かっこのあとの、次の「、」「。」「「」までに、これがあれば前提にしない（「受けていない」「受けていたら」「受けている間は」など）
local AFTER_NEGATIVE = { 'ない', 'たら', '間' }
local function starts(s, list)
    for _, w in ipairs(list) do
        if s:sub(1, #w) == w then return true end
    end
    return false
end

-- 1つの理由の文から、かっこの名前の並び（「A」「B」…）ごとに { names = {...}, tagged = {...}, after = あとの文 } を出す
local function name_runs(text)
    local runs, pos = {}, 1
    while true do
        local a, b, name = text:find('「(.-)」', pos)
        if not a then break end
        local run = { names = {}, tagged = {} }
        local function add(n, a0)
            run.names[#run.names + 1] = n
            local pre = text:sub(math.max(1, a0 - 15), a0 - 1)
            run.tagged[#run.tagged + 1] = (pre:sub(-#'クエスト') == 'クエスト') or (pre:sub(-#'ミッション') == 'ミッション')
        end
        add(name, a)
        pos = b + 1
        while true do
            local a2, b2, n2 = text:find('^[・と]?「(.-)」', pos)
            if not a2 then break end
            add(n2, text:find('「', a2, true))
            pos = b2 + 1
        end
        run.after = text:sub(pos, pos + 60)
        local clause = text:sub(pos)
        local cut = #clause + 1
        for _, w in ipairs({ '、', '。', '「' }) do
            local c = clause:find(w, 1, true)
            if c and c < cut then cut = c end
        end
        clause = clause:sub(1, cut - 1)
        run.negative = false
        for _, w in ipairs(AFTER_NEGATIVE) do
            if clause:find(w, 1, true) then run.negative = true end
        end
        runs[#runs + 1] = run
    end
    return runs
end

function marks.prereq_ids(data, q)
    if q._prereq_ids then return q._prereq_ids end
    local out = {}
    if not data._by_name_ja then
        data._by_name_ja = {}
        for _, x in ipairs(data.quests or {}) do
            if x.name_ja_ref then
                local key = prereq_name_key(x.name_ja_ref)
                local l = data._by_name_ja[key] or {}
                l[#l + 1] = x.id
                data._by_name_ja[key] = l
            end
        end
    end
    local function ids_of(name)
        local ids = data._by_name_ja[prereq_name_key(name)]
        local g = {}
        for _, id in ipairs(ids or {}) do if id ~= q.id then g[#g + 1] = id end end
        return g
    end
    for _, r in ipairs(q.lock_reasons or {}) do
        local text = r.text_ja or ''
        local negative = false
        for _, w in ipairs(NEGATIVE) do if text:find(w, 1, true) then negative = true end end
        if not negative then
            for _, run in ipairs(name_runs(text)) do
              if not run.negative then
                local after = run.after
                local any = after:sub(1, #'のどれか') == 'のどれか'
                local rest = any and after:sub(#'のどれか' + 1) or after
                local accept = any and rest:find('受けて', 1, true) ~= nil or starts(rest, ACCEPT_AFTER)
                local done = (not accept) and starts(rest, DONE_AFTER)
                if any and not accept then done = true end
                local group = {}
                for i, name in ipairs(run.names) do
                    if accept or done or run.tagged[i] then
                        local g = ids_of(name)
                        if any then
                            for _, id in ipairs(g) do group[#group + 1] = id end
                        elseif #g > 0 then
                            g.accept = accept or nil
                            out[#out + 1] = g
                        end
                    end
                end
                if any and #group > 0 then
                    group.accept = accept or nil
                    out[#out + 1] = group
                end
              end
            end
        end
    end
    -- 同じ組は1つにする（「クエスト「X」を終えている」「「X」のあとエリアを出入り」など）
    local seen, uniq = {}, {}
    for _, g in ipairs(out) do
        local key = (g.accept and 'A:' or 'C:') .. table.concat(g, '|')
        if not seen[key] then seen[key] = true; uniq[#uniq + 1] = g end
    end
    q._prereq_ids = uniq
    return uniq
end

-- 完了が条件の前提（「を受けている」は連続クエストのつながりにはしない）
function marks.prereq_parents(data, q)
    local out, seen = {}, {}
    if not q then return out end
    for _, group in ipairs(marks.prereq_ids(data, q)) do
        if not group.accept then
            for _, id in ipairs(group) do
                if id and not seen[id] then seen[id] = true; out[#out + 1] = id end
            end
        end
    end
    return out
end

local function start_target_id(data, q)
    if not data or not q then return nil end
    local st = data.start_target and data:start_target(q)
    if not st and q.start then st = data.target and data:target(q.start.target) end
    return st and st.id or nil
end

-- 同じ発生相手での連続クエストの、まだ終わっていない前の段があるか
function marks.has_open_same_npc_ancestor(data, progress, q, target_id)
    if not data or not progress or not q or not target_id then return false end
    local seen = {}
    local function walk(qid)
        if not qid or seen[qid] then return false end
        seen[qid] = true
        local pq = data.quest and data:quest(qid)
        if not pq then return false end
        if start_target_id(data, pq) == target_id then
            if progress:state(qid) ~= 'completed' then return true end
        end
        for _, p in ipairs(marks.prereq_parents(data, pq)) do
            if walk(p) then return true end
        end
        return false
    end
    for _, p in ipairs(marks.prereq_parents(data, q)) do
        if walk(p) then return true end
    end
    return false
end

-- 同じ発生相手の連続クエストで、まだ前の段が残っているあとの段は出さない（0.1.204〜）。
-- 前提が別の相手のクエストだけのものは、これまでどおり残す（受けられない印）。
function marks.keep_current_chain(data, progress, wanted)
    if not wanted or #wanted == 0 or not data or not progress then return wanted end
    local out = {}
    for _, w in ipairs(wanted) do
        local q = w.quest_id and data.quest and data:quest(w.quest_id)
        local tid = w.target_id or (q and start_target_id(data, q))
        -- 受注中の段は出す。まだ受けられないあとの段だけ隠す
        if q and tid and progress:state(q.id) ~= 'accepted'
            and marks.has_open_same_npc_ancestor(data, progress, q, tid) then
            -- あとの段：出さない
        else
            out[#out + 1] = w
        end
    end
    return out
end

-- 前提が済んでいないと分かるか（同じ名前が複数あれば、どれかが完了していればよい。accept の組は受けていてもよい）
function marks.prereq_unmet(data, progress, q)
    for _, group in ipairs(marks.prereq_ids(data, q)) do
        local ok = false
        for _, id in ipairs(group) do
            local st = progress:state(id)
            if st == 'completed' or (group.accept and st == 'accepted') then ok = true; break end
        end
        if not ok then return true end
    end
    return false
end

-- 今の手順を進められないと分かるか：必要な品の所持数が読めて、足りないとき（読めなければ false）
-- だいじなもの（key_item_id、0.1.184〜）は持っていれば 1・持っていなければ 0 を have が返す
function marks.step_blocked(step, have)
    if not step or type(have) ~= 'function' then return false end
    for _, n in ipairs(step.needs or {}) do
        local id = n.item_id or n.key_item_id
        if id then
            local c = have(id, n)
            if c ~= nil and tonumber(c) and tonumber(c) < (tonumber(n.count) or 1) then return true end
        end
    end
    return false
end

--[[
  受ける条件のうち、実行時に読めるもの（0.1.65〜）：レベル・ジョブ（vana.game.player / Ashita の GetPlayer）、
  所属国とランク（同じ）。名声は読めないので数えない。読めない値（nil）のときは条件を満たしていないことにしない。
  status: { main_job = ジョブの番号, main_job_level = n, nation = 0 サンドリア / 1 バストゥーク / 2 ウィンダス, rank = n }
]]
marks.NATION_OF = { [0] = 'sandoria', [1] = 'bastok', [2] = 'windurst' }
-- ジョブの名前（資料の書き方）→ ジョブの番号（VanaCore の説明書の表と同じ）
marks.JOB_JA = {
    { '戦士', 1 }, { 'モンク', 2 }, { '白魔道士', 3 }, { '黒魔道士', 4 }, { '赤魔道士', 5 }, { 'シーフ', 6 },
    { 'ナイト', 7 }, { '暗黒騎士', 8 }, { '獣使い', 9 }, { '吟遊詩人', 10 }, { '狩人', 11 }, { '侍', 12 },
    { '忍者', 13 }, { '竜騎士', 14 }, { '召喚士', 15 }, { '青魔道士', 16 }, { 'コルセア', 17 }, { 'からくり士', 18 },
    { '踊り子', 19 }, { '学者', 20 }, { '風水士', 21 }, { '魔導剣士', 22 },
}

-- 受けられない理由の文から、レベルの条件を拾う。{ { job = 番号 or nil, level = n }, ... }
-- 「モンクLv40以上」「Lv50以上の暗黒騎士」はそのジョブ（メインジョブ）で、「Lv5以上」「レベル30以上」はどのジョブでも
function marks.level_reqs(q)
    if q._level_reqs then return q._level_reqs end
    local out = {}
    for _, r in ipairs(q.lock_reasons or {}) do
        local text = r.text_ja or ''
        if not text:find('不可', 1, true) then
            for _, j in ipairs(marks.JOB_JA) do
                local name, id = j[1], j[2]
                local n = text:match(name .. 'Lv(%d+)以上') or text:match('Lv(%d+)以上の' .. name)
                if n then
                    out[#out + 1] = { job = id, level = tonumber(n) }
                    text = text:gsub(name .. 'Lv%d+以上', ''):gsub('Lv%d+以上の' .. name, '')
                end
            end
            for n in text:gmatch('Lv(%d+)以上') do out[#out + 1] = { level = tonumber(n) } end
            for n in text:gmatch('レベル(%d+)以上') do out[#out + 1] = { level = tonumber(n) } end
        end
    end
    q._level_reqs = out
    return out
end

-- 国のミッションのランク（SM2-1 → 2）と国。国のミッションでなければ nil（0.1.118〜、ジラートなどは nil）
local NATION_CAT = { sandoria = true, bastok = true, windurst = true }
function marks.mission_rank(q)
    if not q or q.kind ~= 'mission' then return nil end
    -- 国のミッション以外（0.1.119〜）：資料に所属国ランクの条件があるものだけ（need_rank）
    if not NATION_CAT[q.category or ''] then return tonumber(q.need_rank), q.category end
    local r = tostring(q.mission_no or ''):match('(%d+)%-%d+')
    return tonumber(r), q.category
end

-- 読めた値で、受ける条件を満たしていないと分かるか（読めない値の条件は数えない）
function marks.reqs_unmet(q, status)
    if type(status) ~= 'table' then return false end
    local lv, job = tonumber(status.main_job_level), tonumber(status.main_job)
    if lv and lv > 0 then
        for _, rq in ipairs(marks.level_reqs(q)) do
            if rq.job then
                if job and job > 0 and (job ~= rq.job or lv < rq.level) then return true end
            elseif lv < rq.level then
                return true
            end
        end
    end
    local need, cat = marks.mission_rank(q)
    if need then
        local nation = marks.NATION_OF[tonumber(status.nation) or -1]
        local rank = tonumber(status.rank)
        if NATION_CAT[cat or ''] then
            if nation and cat and nation ~= cat then return true end   -- ほかの国のミッションは受けられない
            if nation and nation == cat and rank and rank > 0 and rank < need then return true end
        elseif rank and rank > 0 and rank < need then
            return true   -- 所属国ランクが足りない（ジラートの最初など。読めないランクでは止めない）
        end
    end
    -- 名声（0.1.66〜）：名声を教えてくれる人の返事で覚えたランクだけで判断する。覚えていない地域は止めない
    if require('src.core.fame').unmet(q, status.fame) then return true end
    return false
end

-- クエスト・ミッション1件のアイコン（本・トラッカーと相手の印で同じ）。出さないときは nil
-- opts: { have = function(item_id, need) → 所持数 or nil, next_missions = 表, status = 上の表 or nil }
function marks.quest_icon(data, progress, q, opts)
    if not q then return nil end
    opts = opts or {}
    local st = progress:state(q.id)
    if st == 'accepted' then
        local step = progress:current_step(q.id)
        if not step then return 'complete' end   -- 手順は全部済み（完了にするのを待っている）
        if data:is_last_step(step) then return 'complete' end
        if marks.step_blocked(step, opts.have) then return 'blocked' end
        return 'progress'
    end
    if st == 'completed' then
        return (q.repeatable == 'yes') and 'repeat' or nil
    end
    -- まだ受けていない
    if marks.prereq_unmet(data, progress, q) then return 'unavailable' end
    if marks.reqs_unmet(q, opts.status) then return 'unavailable' end
    if q.kind == 'mission' then
        -- 次のミッションは main。後のものでも、前提と条件を満たしていれば受けられる（省略可など）。
        -- 次かどうかだけで受けられないにはしない（0.1.196〜）
        local nm = opts.next_missions or marks.next_missions(data, progress)
        return nm[q.id] and 'main' or 'sub'
    end
    if q.repeatable == 'yes' then return 'repeat' end
    return 'sub'
end

local HUNT_TYPES = { defeat = true, hunt = true, fight = true, kill = true }
local EXAMINE_TYPES = { examine = true, inspect = true }
local TALK_TYPES = { talk = true, trade = true, cs = true }

local function trim(s)
    if type(s) ~= 'string' then return nil end
    local t = s:match('^%s*(.-)%s*$')
    if not t or t == '' then return nil end
    return t
end

-- 全角の「？？？」も半角の ??? と同じ相手とみなす。
-- 名前の後ろに終端のゴミが付いているときは先に落とす。
function marks.norm_name(s)
    if type(s) ~= 'string' then return nil end
    local z = s:find('\0', 1, true)
    if z then s = s:sub(1, z - 1) end
    s = trim(s)
    if not s then return nil end
    if s == '？？？' then return '???' end
    local rest, n_fw = s:gsub('？', '')
    local rest2, n_ascii = rest:gsub('%?', '')
    if rest2 == '' and ((n_fw or 0) + (n_ascii or 0)) >= 2 then
        return '???'
    end
    return s
end

-- 調べる対象（obj）は、名前の有無に関係なく本体の位置に印を出す。
-- 名前が ??? のときも同じ（役割が分からなくても本体へ）。
function marks.on_body(name, role)
    if role == 'examine' then return true end
    return marks.norm_name(name) == '???'
end

function marks.same_name(a, b)
    a, b = marks.norm_name(a), marks.norm_name(b)
    return a ~= nil and a == b
end

-- 名前に付ける相手と、本体の位置に出す相手（調べる対象・???）に分ける
function marks.split_for_draw(matched)
    local on_name, on_body = {}, {}
    for _, row in ipairs(matched or {}) do
        local name = row.name
        if (not name or name == '') and row.entity then
            name = row.entity.name
        end
        local role = row.role
        if (not role) and row.wanted and row.wanted[1] then
            role = row.wanted[1].role
        end
        if marks.on_body(name, role) then
            on_body[#on_body + 1] = row
        else
            on_name[#on_name + 1] = row
        end
    end
    return on_name, on_body
end

function marks.same_grid(a, b)
    local d = marks.grid_dist(a, b)
    return d == 0
end

-- マス目どうしの距離（縦横と斜めは同じ1。調べられないときは nil）。
-- 境界の2マス（"F-6/G-6"）は、どちらかのマスとの近いほう。
function marks.grid_dist(a, b)
    if type(a) ~= 'string' or type(b) ~= 'string' then return nil end
    local ca = maps.grid_cells(a)
    local cb = maps.grid_cells(b)
    if ca == nil or cb == nil then return nil end
    local best = nil
    for _, x in ipairs(ca) do
        for _, y in ipairs(cb) do
            local dc = math.abs(x.col - y.col)
            local dr = math.abs(x.row - y.row)
            local d = dc > dr and dc or dr
            if best == nil or d < best then best = d end
        end
    end
    return best
end

-- 同じマス、または隣（境目用。斜め隣も含む）。
function marks.near_grid(a, b)
    local d = marks.grid_dist(a, b)
    return d ~= nil and d <= 1
end

-- 実座標からマス目。preferred_map_n があればその MAP を使う。
-- 複数 MAP でマス目が食い違う（別階層）ときは、指定が無ければ nil。
function marks.grid_of(data, zone_id, world_x, world_y, preferred_map_n)
    world_x, world_y = tonumber(world_x), tonumber(world_y)
    if not data or zone_id == nil or world_x == nil or world_y == nil then return nil end
    local function on_floor(floor)
        if not floor then return nil, true end
        local bx, by = maps.world_px(floor, world_x, world_y)
        if not bx then return nil, true end
        local off = (bx < -32 or by < -32 or bx > maps.BASE + 32 or by > maps.BASE + 32)
        if off then return nil, true end
        return maps.grid_name(bx, by), false
    end
    if preferred_map_n then
        local g = on_floor(maps.floor(data, zone_id, preferred_map_n))
        return g
    end
    local floors = maps.floors(data, zone_id) or {}
    if #floors <= 1 then
        local g = on_floor(floors[1])
        return g
    end
    local found, conflict = nil, false
    for _, floor in ipairs(floors) do
        local g, off = on_floor(floor)
        if g and not off then
            if found and found ~= g then conflict = true end
            found = found or g
        end
    end
    if conflict then return nil end
    return found
end

local function role_of(step, tg)
    -- 0.1.214〜：BF の戦いの手順の相手は入口（entrance）。戦う相手ではないので、入口の種類で決める
    if step and step.entrance and tg then
        return (tg.kind == 'obj') and 'examine' or 'talk'
    end
    local t = step and step.type
    if t and HUNT_TYPES[t] then return 'hunt' end
    if t and EXAMINE_TYPES[t] then return 'examine' end
    if t and TALK_TYPES[t] then return 'talk' end
    if tg then
        if tg.kind == 'mob' then return 'hunt' end
        if tg.kind == 'obj' then return 'examine' end
        if tg.kind == 'npc' then return 'talk' end
    end
    return nil
end

local function wanted_from_target(tg, role, q, step)
    if not tg or not tg.name_en then return nil end
    -- 手順にマスが無くても、同じゾーンの対象に分かっているマスがあればそれを使う
    local sloc = step and step.location
    local tloc = tg.location
    local loc = sloc or tloc
    if sloc and tloc then
        local same = (sloc.zone_id and tloc.zone_id and sloc.zone_id == tloc.zone_id)
            or (sloc.zone_name and tloc.zone_name and sloc.zone_name == tloc.zone_name)
        if same and not sloc.grid and tloc.grid then
            loc = {
                zone_id = sloc.zone_id or tloc.zone_id,
                zone_name = sloc.zone_name or tloc.zone_name,
                grid = tloc.grid,
                map = sloc.map or tloc.map,
            }
        end
    end
    local grid = loc and loc.grid
    local map_n = loc and loc.map and loc.map.kind == 'number' and loc.map.n or nil
    local moves = tg.moves == true
    local same = tg.same_name == true
    local name = marks.norm_name(tg.name_en)
    -- 0.1.213〜：サーバーの番号が分かっている相手（場所が変わる ??? など）は番号だけで見分ける。マスは見ない
    local server_id = tonumber(tg.server_id)
    local require_grid = (not server_id) and ((name == '???') or (same and not moves))
    return {
        role = role,
        name = name,
        zone_id = loc and loc.zone_id or nil,
        grid = grid,
        map_n = map_n,
        moves = moves,
        same_name = same,
        require_grid = require_grid and true or false,
        quest_id = q and q.id or nil,
        step_id = step and step.id or nil,
        target_id = tg.id,
        server_id = server_id,
    }
end

-- 発生の相手（話して受ける・調べて受ける）の印。0.1.81〜：
-- 物（??? など）は「調べる」、それ以外は「話す」。手順1が別の相手なら、発生の相手自身の場所を使う。
local function wanted_from_start(tg, q, step0)
    if not tg then return nil end
    local role = (tg.kind == 'obj') and 'examine' or 'talk'
    if step0 and step0.target ~= tg.id and tg.location and tg.location.grid then step0 = nil end
    return wanted_from_target(tg, role, q, step0)
end

-- 手順の文に書いてある、落とすモンスター（名前）と種族（0.1.190〜、t321・t322）。
-- 名前が書いてあれば名前だけ（種族は使わない。データを作るときに決めてある）。「〜は落とさない」の名前は外す。
-- ゾーンが分かっていればそのゾーンだけ、分からなければどのゾーンでも（今いるゾーンの、その種族の相手）。
function marks.add_step_mobs(data, q, step, add)
    local sm = data and data.step_mobs and data:step_mobs(step.id)
    if not sm then return end
    local key = data.mob_key or function (n) return n end
    local ex = {}
    for _, n in ipairs(sm.exclude or {}) do local k = key(n); if k then ex[k] = true end end
    local function zones_of(e)
        local zl = {}
        for _, z in ipairs(type(e.zones) == 'table' and e.zones or {}) do
            if tonumber(z) then zl[#zl + 1] = tonumber(z) end
        end
        if #zl == 0 then zl[1] = false end
        return zl
    end
    -- 手順の相手（target）と同じ名前は、相手のほう（場所・マスの決まり）を使う
    local tg = step.target and data.target and data:target(step.target)
    local tkey = tg and tg.name_en and key(tg.name_en)
    for _, n in ipairs(sm.names or {}) do
        local name = marks.norm_name(n.name)
        if name and not ex[key(name)] and key(name) ~= tkey then
            for _, z in ipairs(zones_of(n)) do
                add({
                    role = 'hunt', icon = 'hunt', name = name, loose = true, drop = true,
                    zone_id = z or nil, moves = true, same_name = false, require_grid = false,
                    quest_id = q.id, step_id = step.id,
                    target_id = 'drop:' .. name .. '@' .. tostring(z),
                })
            end
        end
    end
    if sm.names and #sm.names > 0 then return end
    for _, f in ipairs(sm.families or {}) do
        if type(f.family) == 'string' then
            for _, z in ipairs(zones_of(f)) do
                add({
                    role = 'hunt', icon = 'hunt', family = f.family, exclude = ex,
                    zone_id = z or nil, moves = true, same_name = false, require_grid = false,
                    quest_id = q.id, step_id = step.id,
                    in_family = function (zone_id, name) return data:mob_in_family(f.family, zone_id, name) end,
                    target_id = 'family:' .. f.family .. '@' .. tostring(z),
                })
            end
        end
    end
end

-- 手順の相手がほかにもいるとき（extra_targets、0.1.214〜）。「8人に話す」「各地の Stone Monument」など。
-- それぞれ自分の場所（ゾーン・マス）で探す。手順の場所は使わない（ゾーンがちがうことがある）。
function marks.add_extra_targets(data, q, step, icon, add, with_icon)
    if type(step.extra_targets) ~= 'table' then return end
    for _, tid in ipairs(step.extra_targets) do
        local tg = data:target(tid)
        local role = tg and role_of(step, tg)
        -- 手順の場所は、相手にゾーンが無いときだけ使う（各地の Stone Monument などゾーンが違う相手は自分の場所のまま）
        local w = role and wanted_from_target(tg, role, q, nil)
        if w then
            w.step_id = step.id
            if not w.zone_id and step.location and step.location.zone_id then
                w.zone_id = step.location.zone_id
            end
            add(with_icon and with_icon(w, icon) or w)
        end
    end
end

-- 探したい相手の一覧（未受注・受注中の今の手順の相手、とゲートガード）
-- 未受注は、今の手順に相手がいなくても発生NPCに印を出す（「話して受ける」相手）。
-- 0.1.63〜：それぞれにアイコン（icon）を付ける。完了したくり返しのクエストは発生NPCにくり返しの印。
-- opts: { have = function(item_id) → 所持数 or nil, fame = false なら名声を教えてくれる人の印を出さない（0.1.69〜）,
--         debug = true なら完了していても選んだ「今」の手順に印を出す（0.1.191〜。ふだんは受注中だけ） }
function marks.wanted(data, progress, opts)
    local out = {}
    if not data or not progress then return out end
    opts = opts or {}
    local nm = marks.next_missions(data, progress)
    local iopts = { have = opts.have, next_missions = nm, status = opts.status }
    -- 国ごとの、いま受けられる次のミッション（ゲートガードの印に使う。0.1.65〜）
    local main_of = {}
    for qid in pairs(nm) do
        local mq = data:quest(qid)
        if mq and marks.quest_icon(data, progress, mq, iopts) == 'main' then main_of[mq.category or '?'] = mq end
    end
    -- 0.1.210〜：同じものは表で弾く（前は毎回全部と比べていた）
    local seen = {}
    for _, e in ipairs(out) do
        seen[tostring(e.quest_id) .. '\0' .. tostring(e.target_id) .. '\0' .. tostring(e.role)] = true
    end
    local function add_wanted(w)
        if not w then return end
        local k = tostring(w.quest_id) .. '\0' .. tostring(w.target_id) .. '\0' .. tostring(w.role)
        if seen[k] then return end
        seen[k] = true
        out[#out + 1] = w
    end
    local function with_icon(w, icon)
        if not w then return nil end
        -- 討伐の相手はいつも討伐の印（今までどおり）
        w.icon = (w.role == 'hunt') and 'hunt' or icon
        return w
    end
    for _, q in ipairs(data.quests or {}) do
        local st = progress:state(q.id)
        local icon = marks.quest_icon(data, progress, q, iopts)
        if st == 'accepted' or st == 'not_accepted' then
            local step = progress:current_step(q.id)
            if step and step.target then
                local tg = data:target(step.target)
                local role = role_of(step, tg)
                add_wanted(role and with_icon(wanted_from_target(tg, role, q, step), icon))
            end
            if step then marks.add_extra_targets(data, q, step, icon, add_wanted, with_icon) end
            -- 受注中の今の手順の文に書いてある、落とすモンスター・種族（0.1.190〜）
            if st == 'accepted' and step then
                marks.add_step_mobs(data, q, step, add_wanted)
            end
            -- 未受注：今の手順が「品を用意する」など相手なしでも、発生NPCには付ける
            if st == 'not_accepted' then
                local tg = data.start_target and data:start_target(q)
                if not tg and q.start then
                    tg = data:target(q.start.target)
                end
                if tg then
                    local step0 = q.steps and q.steps[1] or nil
                    add_wanted(with_icon(wanted_from_start(tg, q, step0), icon))
                end
            end
        elseif st == 'completed' then
            if icon == 'repeat' then
                -- 完了したくり返しのクエスト：発生NPCにくり返しの印（0.1.63〜）
                local tg = data.start_target and data:start_target(q)
                if not tg and q.start then tg = data:target(q.start.target) end
                if tg then
                    add_wanted(with_icon(wanted_from_start(tg, q, q.steps and q.steps[1] or nil), 'repeat'))
                end
            end
            -- デバッグONのとき、完了していても選んだ「今」の手順に印を出す（0.1.191〜）
            if opts.debug then
                local step = progress:current_step(q.id)
                if step then
                    if step.target then
                        local tg = data:target(step.target)
                        local role = role_of(step, tg)
                        add_wanted(role and with_icon(wanted_from_target(tg, role, q, step), icon))
                    end
                    marks.add_extra_targets(data, q, step, icon, add_wanted, with_icon)
                    marks.add_step_mobs(data, q, step, add_wanted)
                end
            end
        end
    end
    for _, g in ipairs(data.guards or {}) do
        local name = trim(g.name_en)
        if name then
            local loc = g.location
            -- 所属国に次のミッションがあれば、盾ではなくミッションの印（そのミッションの名前も出せる）
            local nm_q = g.nation and main_of[g.nation] or nil
            out[#out + 1] = {
                role = 'guard',
                icon = nm_q and 'main' or 'guard',
                next_mission = nm_q and nm_q.id or nil,
                name = name,
                zone_id = loc and loc.zone_id or nil,
                grid = loc and loc.grid or nil,
                map_n = loc and loc.map and loc.map.kind == 'number' and loc.map.n or nil,
                moves = g.moves == true,
                same_name = g.same_name == true,
                require_grid = (g.same_name == true and g.moves ~= true) and true or false,
                quest_id = nil,
                step_id = nil,
                target_id = g.id,
                nation = g.nation,
            }
        end
    end
    -- 名声を教えてくれる人（0.1.69〜）：7人。名前はそのゾーンで一人だけなので、名前で付ける
    if opts.fame ~= false then
        local ok, fame = pcall(require, 'src.core.fame')
        if ok and fame and fame.NPC_BY_ZONE then
            local zids = {}
            for zid in pairs(fame.NPC_BY_ZONE) do zids[#zids + 1] = zid end
            table.sort(zids)
            for _, zid in ipairs(zids) do
                local spec = fame.NPC_BY_ZONE[zid]
                out[#out + 1] = {
                    role = 'fame', icon = 'fame', name = spec.npc, zone_id = zid,
                    area = spec.area, moves = false, same_name = false, require_grid = false,
                    target_id = 'fame.' .. spec.area,
                }
            end
        end
    end
    -- 同じ相手の連続クエストは、いま受けられる／進めているものだけ（0.1.204〜）
    return marks.keep_current_chain(data, progress, out)
end

-- 1つの手順の相手（0.1.217〜）。地図で見ている手順が「今」の手順でないときも、
-- 頭上の印と同じ見分け方（番号・名前・マス）で、読み込まれている本物を探せるように。印には使わない。
function marks.wanted_for_step(data, step)
    if not step or not step.target or not data or not data.target then return nil end
    local tg = data:target(step.target)
    if not tg then return nil end
    local role = role_of(step, tg)
    if not role then return nil end
    return wanted_from_target(tg, role, nil, step)
end

-- このゾーンで探す相手だけに絞る（ゾーン不明のガードは残す）
function marks.in_zone(wanted_list, zone_id)
    local out = {}
    zone_id = tonumber(zone_id)
    for _, w in ipairs(wanted_list or {}) do
        if w.zone_id == nil or zone_id == nil or tonumber(w.zone_id) == zone_id then
            out[#out + 1] = w
        end
    end
    return out
end

local function loose_key(n)
    n = marks.norm_name(n)
    if not n then return nil end
    return (n:gsub("['’]", ''):lower())
end

local function entity_ok_for(w, ent)
    if not ent then return false end
    if w.loose then
        -- 文の名前（0.1.190〜）：大文字・小文字と ' は見ない。NPC・PC には付けない
        if ent.kind == 'npc' or ent.kind == 'pc' then return false end
        local a, b = loose_key(w.name), loose_key(ent.name)
        if not a or a ~= b then return false end
    elseif not marks.same_name(w.name, ent.name) then
        return false
    end
    if w.role == 'hunt' and ent.dead then return false end
    return true
end

-- 種族の相手か（0.1.190〜）：今いるゾーンの、その種族の名前の一覧にある、生きているモンスター
local function family_ok(w, ent, zone_id)
    if not ent or ent.dead then return false end
    if ent.kind == 'npc' or ent.kind == 'pc' then return false end
    local k = loose_key(ent.name)
    if not k or k == '???' then return false end
    if w.exclude and w.exclude[k] then return false end
    return w.in_family ~= nil and w.in_family(zone_id, ent.name) == true
end
marks._family_ok = family_ok

-- サーバーの番号（0.1.213〜）。NPC・物の番号は 0x01000000 + ゾーン×0x1000 + 読み込みの番号（下の 12 ビット）。
-- 相手の server_id が読めればそれで比べ、読めないときだけ、ゾーンと読み込みの番号で比べる。
function marks.same_server_id(id, ent, zone_id)
    id = tonumber(id)
    if not id or not ent then return false end
    local sid = tonumber(ent.server_id)
    if sid and sid ~= 0 then return sid == id end
    local idx = tonumber(ent.index)
    zone_id = tonumber(zone_id)
    if not idx or not zone_id then return false end
    local want_idx = id % 0x1000
    local want_zone = math.floor(id / 0x1000) % 0x1000
    return idx == want_idx and zone_id == want_zone
end

-- 場所の候補（0.1.213〜）。場所が変わる ??? などで、出るかもしれない場所の一覧。
-- 手順の location.candidates が先、なければ相手の candidates。ゾーンがちがう候補は使わない。
function marks.candidates_for(data, step)
    if not step then return nil end
    local loc = step.location
    local list = loc and loc.candidates
    local tg = step.target and data and data.target and data:target(step.target) or nil
    if type(list) ~= 'table' or #list == 0 then list = tg and tg.candidates end
    if type(list) ~= 'table' or #list == 0 then return nil end
    local zone = tonumber(loc and loc.zone_id) or tonumber(tg and tg.location and tg.location.zone_id)
    local out = {}
    for _, c in ipairs(list) do
        local pos = type(c) == 'table' and c.pos
        if type(pos) == 'table' and tonumber(pos.x) and tonumber(pos.y) then
            local cz = tonumber(c.zone_id) or zone
            if zone == nil or cz == zone then
                out[#out + 1] = { x = tonumber(pos.x), y = tonumber(pos.y), z = tonumber(pos.z),
                                  grid = c.grid, zone_id = cz }
            end
        end
    end
    if #out == 0 then return nil end
    return out
end

-- 見えている相手と照合する。画面外は呼び出し側で落とす。
-- ctx: { zone_id, grid_of(ent, wanted) -> grid or nil }
function marks.match(wanted_list, entities, ctx)
    ctx = ctx or {}
    local placed = {} -- key=entity identity -> { entity, roles = {wanted...}, rank }
    local function key_of(ent)
        return ent.index or ent.id or ent
    end
    local function add(ent, w)
        local k = key_of(ent)
        local row = placed[k]
        if not row then
            row = { entity = ent, wanted = { w }, rank = marks.rank_of(w) }
            placed[k] = row
        else
            row.wanted[#row.wanted + 1] = w
            local r = marks.rank_of(w)
            if r < row.rank then row.rank = r end
        end
    end

    -- 名前ごとに、見える相手を先に集める
    local ents_by_name = {}
    for _, ent in ipairs(entities or {}) do
        local n = marks.norm_name(ent.name)
        if n then
            ents_by_name[n] = ents_by_name[n] or {}
            ents_by_name[n][#ents_by_name[n] + 1] = ent
        end
    end

    local ents_by_key = nil
    for _, w in ipairs(wanted_list or {}) do
        local cands = {}
        if w.server_id then
            -- サーバーの番号で見分ける（0.1.213〜）。同じゾーンのほかの ??? には付けない
            for _, ent in ipairs(entities or {}) do
                if marks.same_server_id(w.server_id, ent, ctx.zone_id) then
                    if not (w.role == 'hunt' and ent.dead) then add(ent, w) end
                end
            end
        elseif w.family then
            -- 種族（0.1.190〜）：名前はその相手の名前にして付ける（ヒントに出す）
            for _, ent in ipairs(entities or {}) do
                if family_ok(w, ent, ctx.zone_id) then
                    local w2 = {}
                    for k, v in pairs(w) do w2[k] = v end
                    w2.name = marks.norm_name(ent.name)
                    add(ent, w2)
                end
            end
        elseif w.loose then
            if not ents_by_key then
                ents_by_key = {}
                for _, ent in ipairs(entities or {}) do
                    local k = loose_key(ent.name)
                    if k then
                        ents_by_key[k] = ents_by_key[k] or {}
                        ents_by_key[k][#ents_by_key[k] + 1] = ent
                    end
                end
            end
            for _, ent in ipairs(ents_by_key[loose_key(w.name) or ''] or {}) do
                if entity_ok_for(w, ent) then cands[#cands + 1] = ent end
            end
        else
            for _, ent in ipairs(ents_by_name[w.name] or {}) do
                if entity_ok_for(w, ent) then
                    cands[#cands + 1] = ent
                end
            end
        end
        if w.require_grid then
            if not w.grid then
                cands = {}
            else
                local exact, near = {}, {}
                for _, ent in ipairs(cands) do
                    local g = nil
                    if ctx.grid_of then
                        g = ctx.grid_of(ent, w)
                    elseif ent.grid then
                        g = ent.grid
                    end
                    local d = marks.grid_dist(g, w.grid)
                    if d == 0 then
                        exact[#exact + 1] = ent
                    elseif d == 1 then
                        near[#near + 1] = ent
                    end
                end
                -- ぴったりがいればそれだけ。境目で隣のマスに落ちたときだけ隣も認める。
                if #exact > 0 then
                    cands = exact
                else
                    cands = near
                end
            end
        elseif w.same_name and not w.moves and w.grid then
            -- 同名で座標がある（require_grid と同じだが、上で既に処理）
        end
        -- 調べる対象：名前で見つからなければ、同じマス（と隣）の名前が出ない相手も候補にする
        if w.role == 'examine' and #cands == 0 and w.grid and not w.server_id then
            local exact, near = {}, {}
            for _, ent in ipairs(entities or {}) do
                local n = marks.norm_name(ent and ent.name)
                if n == nil or n == '???' then
                    local g = nil
                    if ctx.grid_of then
                        g = ctx.grid_of(ent, w)
                    elseif ent.grid then
                        g = ent.grid
                    end
                    local d = marks.grid_dist(g, w.grid)
                    if d == 0 then
                        exact[#exact + 1] = ent
                    elseif d == 1 then
                        near[#near + 1] = ent
                    end
                end
            end
            if #exact > 0 then
                cands = exact
            else
                cands = near
            end
        end
        -- 動く相手・名前が唯一の相手は、候補をすべて付ける（付いてくる）
        for _, ent in ipairs(cands) do
            add(ent, w)
        end
    end

    local out = {}
    for _, row in pairs(placed) do
        -- 表示の役割は、いちばん優先のものを使う
        table.sort(row.wanted, function (a, b)
            local ra, rb = marks.rank_of(a), marks.rank_of(b)
            if ra ~= rb then return ra < rb end
            return tostring(a.quest_id) < tostring(b.quest_id)
        end)
        -- 受けられない印は、ほかの印がある相手には出さず、一つだけにする（重ねすぎない）
        do
            local kept, has_other, has_un = {}, false, false
            for _, w in ipairs(row.wanted) do if w.icon ~= 'unavailable' and w.role ~= 'fame' then has_other = true end end
            for _, w in ipairs(row.wanted) do
                if w.icon == 'unavailable' then
                    if not has_other and not has_un then kept[#kept + 1] = w; has_un = true end
                else
                    kept[#kept + 1] = w
                end
            end
            -- 名声を教えてくれる人の印（0.1.69〜）は、ほかの印（クエスト・ゲートガード）がある相手には出さない
            local only_fame = true
            for _, w in ipairs(kept) do if w.role ~= 'fame' then only_fame = false end end
            if not only_fame then
                local k2 = {}
                for _, w in ipairs(kept) do if w.role ~= 'fame' then k2[#k2 + 1] = w end end
                kept = k2
            end
            row.wanted = kept
            row.rank = marks.rank_of(kept[1])
        end
        row.role = row.wanted[1] and row.wanted[1].role
        row.icon = row.wanted[1] and row.wanted[1].icon
        row.name = row.entity.name
        out[#out + 1] = row
    end
    table.sort(out, function (a, b)
        if a.rank ~= b.rank then return a.rank < b.rank end
        return tostring(a.name) < tostring(b.name)
    end)
    return out
end

-- 近くの調べるオブジェクト（0.1.58〜、設定でオン）。クエストに関係ないものにも名前だけを出す。
-- 対象：読み込まれている NPC のうち、??? か、動かない見た目の相手（type 2）・扉など（type 3）。
-- type は VanaCore の vana.game.entity の type（docs/addons/04-game-data.md）。Ashita の GetType も同じ値。
-- 印を付けている相手、死んでいる相手、モンスター・PC、名前の無い相手、遠い相手は外す。
-- opts: { skip = { [index] = true }, px, py（自分の位置）, radius（ヤルム）, info = function(ent) → { type, targetable, name_shown } }
marks.NEARBY_RADIUS = 30
marks.NEARBY_MAX = 24
function marks.nearby_objects(ents, opts)
    opts = opts or {}
    local skip = opts.skip or {}
    local radius = tonumber(opts.radius) or marks.NEARBY_RADIUS
    local px, py = tonumber(opts.px), tonumber(opts.py)
    local out = {}
    for _, ent in ipairs(ents or {}) do
        local idx = ent.index
        local name = marks.norm_name(ent.name)
        local ok = idx ~= nil and not skip[idx] and name ~= nil and not ent.dead
            and ent.kind ~= 'mob' and ent.kind ~= 'pc'
            and tonumber(idx) < 0x400
            and ent.x ~= nil and ent.y ~= nil
        local d2
        if ok and px and py then
            local dx, dy = ent.x - px, ent.y - py
            d2 = dx * dx + dy * dy
            if d2 > radius * radius then ok = false end
        end
        if ok then
            local info = opts.info and opts.info(ent) or nil
            local etype = tonumber(info and info.type) or tonumber(ent.entity_type)
            local object_like = (name == '???') or etype == 2 or etype == 3
            if not object_like then ok = false end
            -- 調べられない（ターゲットできない）相手は外す。分からなければ残す
            if ok and info and info.targetable == false then ok = false end
            -- ゲームがもう名前を出している相手には重ねない
            if ok and info and info.name_shown == true then ok = false end
        end
        if ok then
            out[#out + 1] = { entity = ent, name = name, d2 = d2 or 0 }
        end
    end
    table.sort(out, function (a, b)
        if a.d2 ~= b.d2 then return a.d2 < b.d2 end
        return a.entity.index < b.entity.index
    end)
    while #out > marks.NEARBY_MAX do table.remove(out) end
    return out
end

return marks
