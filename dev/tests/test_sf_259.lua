-- 0.1.259：カード名の切り詰めと脚注、バッジ、所持の色とツールチップ、並び、地図リンク
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.324', 'version')

local labels = require('src.ui.labels')
local book_sf = require('src.ui.book_sf')
local poss_ui = require('src.ui.possession_ui')
local window = require('src.ui.window')
local CT = require('src.ui.colored_text')

local src = io.open(ROOT .. '/src/ui/book_sf.lua', 'r'):read('*a')
local tr = io.open(ROOT .. '/src/ui/tracker.lua', 'r'):read('*a')
local trs = io.open(ROOT .. '/src/ui/tracker_sf.lua', 'r'):read('*a')
local det = io.open(ROOT .. '/src/ui/detail.lua', 'r'):read('*a')
local bk = io.open(ROOT .. '/src/ui/book.lua', 'r'):read('*a')

-- 長い名前は DrawList に切り詰めて描く（Text だと隣のカードがずれる）
check(src:find('window.clip_line', 1, true) ~= nil, 'card names use clip_line')
check(src:find('labels.display_name(q)', 1, true) ~= nil, 'SF uses display_name')
check(src:find("theme.TextColored(imgui, theme.col(unimplemented and 'muted' or 'text'), shown)", 1, true) ~= nil,
    'card title draws the clipped name as Text')
check(not src:find("theme.TextColored(imgui, theme.col(unimplemented and 'muted' or 'text'), labels.qname(q))", 1, true),
    'card title does not pass the raw unclipped qname')
check(src:find('imgui.Dummy({ cw, 0 })', 1, true) ~= nil, 'each card group keeps a fixed column Dummy')
check(src:find('name_clipped', 1, true) ~= nil, 'full name tooltip when clipped')

-- バッジは測った大きさで描く（1.12 のままにしない）
local badge_at = src:find('枠は 0.68 で測ったので', 1, true)
check(badge_at ~= nil, 'badge font comment present')
local around = src:sub(badge_at, badge_at + 180)
check(around:find('font(ui, win, 0.68, true)', 1, true) ~= nil, 'badge is drawn at 0.68 after the count font')

-- クラシックの一覧は sort_cards を使わない
check(bk:find('book_sf.sort_cards', 1, true) == nil, 'classic list does not call sort_cards')
check(bk:find('filtered_now', 1, true) ~= nil, 'classic list still uses filtered_now')

-- トラッカーから「所持：」行を外し、詳細と同じ所持を手順文へ
check(tr:find('poss_ui.apply_to_step', 1, true) ~= nil, 'classic/Yuna tracker annotates the step text')
check(trs:find('poss_ui.apply_to_step', 1, true) ~= nil, 'SF tracker annotates the step text')
check(tr:find('poss_ui.draw_lines', 1, true) == nil, 'tracker no longer draws the 所持 line')
check(trs:find('poss_ui.draw_lines', 1, true) == nil, 'SF tracker no longer draws the 所持 line')
check(det:find('poss_ui.draw_inline', 1, true) ~= nil, 'classic detail keeps the separate 所持 line')

-- SF 詳細の地図リンク
check(src:find('tracker.has_multi_map_targets', 1, true) ~= nil, 'SF detail uses tracker multi-map targets')
check(src:find('tracker.people_counts', 1, true) ~= nil, 'SF detail uses people-count terms')
check(src:find("t('map.view_short')", 1, true) ~= nil, 'SF detail can show a 地図 link')

-- 表示側だけ脚注を落とす。資料の qname はそのまま
local dirty = '錬成指南 注釈4 2012年3月27日のバージョンアップ 以降 オファー 不可能。'
eq(labels.strip_name_note(dirty), '錬成指南', 'strips 注釈N and the rest')
eq(labels.strip_name_note('山猫の誘惑'), '山猫の誘惑', 'plain names stay')
eq(labels.strip_name_note('注釈だけの題'), '注釈だけの題', '注釈 without a leading space+number stays')
eq(labels.strip_name_note('題 注釈だけ'), '題 注釈だけ', '注釈 without a following number stays')
local q = { id = 'quest.bastok.068', name_ja_ref = dirty, name_en = 'Synergistic Pursuits' }
eq(labels.qname(q), dirty, 'qname keeps the source string for classic')
eq(labels.display_name(q), '錬成指南', 'display_name is the short title')

-- 切り詰め
do
    local function nchars(s)
        local n = 0
        for _ in tostring(s):gmatch('[%z\1-\127\194-\244][\128-\191]*') do n = n + 1 end
        return n
    end
    local imgui = {
        CalcTextSize = function (s)
            return { x = nchars(s) * 10, y = 14 }
        end,
    }
    local shown, clipped = window.clip_line(imgui, '錬成指南', 200)
    eq(shown, '錬成指南', 'short name fits')
    eq(clipped, false, 'short name is not clipped')
    local long = 'とても長いカードの名前で隣のカードを押してしまう文'
    local cut, was = window.clip_line(imgui, long, 50)
    check(was == true, 'long name is clipped')
    check(cut:sub(-3) == '…' or cut:find('…', 1, true) ~= nil, 'clipped name ends with ellipsis')
    local cw = nchars(cut) * 10
    check(cw <= 50, 'clipped width stays within the budget')
end

-- カード順：進行中 → 未開始 → 完了。同じ組の中は元の順
do
    local ui = {
        progress = {
            state = function (_, id)
                if id == 'a' or id == 'b' then return 'accepted' end
                if id == 'e' or id == 'f' then return 'completed' end
                return 'not_accepted'
            end,
        },
    }
    local list = {
        { id = 'e' }, { id = 'c' }, { id = 'a' }, { id = 'f' }, { id = 'd' }, { id = 'b' },
    }
    local out = book_sf.sort_cards(ui, list)
    local ids = {}
    for i, q in ipairs(out) do ids[i] = q.id end
    eq(table.concat(ids, ','), 'a,b,c,d,e,f', 'accepted, then idle, then completed, stable within a group')
end

-- 必要品の短い名前と所持数を色分けし、持っているときは場所のツールチップ
do
    local ui = {
        settings = { items = { show_possession = true } },
        t = function (k, args)
            if k == 'sf.poss_held' then return string.format('(%s/%s)', args.have, args.need) end
            if k == 'poss.part' then return args.where .. tostring(args.n) end
            if k == 'poss.c0' then return 'かばん' end
            if k == 'poss.c1' then return '金庫' end
            if k == 'poss.sep' then return '・' end
            return k
        end,
        need_possession = function (n)
            if n.name_ja and n.name_ja:find('頭', 1, true) then
                return { state = 'enough', have = 1, need = 1, kind = 'item', parts = { { 0, 1 } }, unknown = {} }
            end
            return { state = 'short', have = 0, need = 1, kind = 'item', parts = {}, unknown = {} }
        end,
    }
    local step = {
        needs = {
            { name_ja = 'クゥダフ人形の頭', kind = 'item', count = 1 },
            { name_ja = 'クゥダフ人形の胴', kind = 'item', count = 1 },
            { name_ja = 'クゥダフ人形の腕', kind = 'item', count = 1 },
            { name_ja = 'クゥダフ人形の足', kind = 'item', count = 1 },
        },
    }
    local text = 'パルブロ鉱山のクゥダフを倒して、クゥダフ人形の頭・胴・腕・足を集める'
    local out, extras = poss_ui.apply_to_step(ui, step, text)
    check(out:find('クゥダフ人形の頭(1/1)', 1, true) ~= nil, 'full name keeps its count')
    check(out:find('胴(0/1)', 1, true) ~= nil, 'short 胴 is colored as a count span')
    check(out:find('腕(0/1)', 1, true) ~= nil, 'short 腕 is colored as a count span')
    check(out:find('足(0/1)', 1, true) ~= nil, 'short 足 is colored as a count span')
    -- 0.1.260 で名前と所持数の言葉は分けた。文面の「(0/1)」は残る。
    check(out:find('クゥダフ人形の頭(1/1)', 1, true) ~= nil, 'annotated text kept')
end

print('test_sf_259 ok')
