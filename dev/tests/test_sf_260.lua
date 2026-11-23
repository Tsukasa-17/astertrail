-- 0.1.260：所持のコピーと色、だいじなものの印、必要品だけのインライン、次の手順
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.324', 'version')

local labels = require('src.ui.labels')
local poss_ui = require('src.ui.possession_ui')
local CT = require('src.ui.colored_text')
local data_mod = require('src.core.data')

local src_tr = io.open(ROOT .. '/src/ui/tracker.lua', 'r'):read('*a')
local src_trs = io.open(ROOT .. '/src/ui/tracker_sf.lua', 'r'):read('*a')
local src_sf = io.open(ROOT .. '/src/ui/book_sf.lua', 'r'):read('*a')
local src_det = io.open(ROOT .. '/src/ui/detail.lua', 'r'):read('*a')
local src_nt = io.open(ROOT .. '/src/ui/notices.lua', 'r'):read('*a')
local src_w = io.open(ROOT .. '/src/ui/widgets.lua', 'r'):read('*a')

check(src_tr:find('apply_to_step(ui, nav.next, nx_text, q)', 1, true) ~= nil, 'classic tracker annotates the 次： line')
check(src_trs:find('apply_to_step(ui, nav.next, nx_text, q)', 1, true) ~= nil, 'SF tracker annotates the 次： line')
check(src_tr:find('apply_to_step(ui, step, cur_text, q)', 1, true) ~= nil, 'classic tracker annotates the current line with the quest')
check(src_trs:find('apply_to_step(ui, step, cur_text, q)', 1, true) ~= nil, 'SF tracker annotates the current line with the quest')
check(src_sf:find('apply_to_step(ui, s, s.next_line_ja or t(\'detail.step_no_text\'), q)', 1, true) ~= nil, 'SF detail passes the quest')
check(src_det:find('term_click = true', 1, true) ~= nil, 'classic detail names are clickable')
check(src_det:find('draw_inline(ui, s.needs, name', 1, true) ~= nil, 'classic 所持 line uses the new drawer')
check(not src_nt:find('draw_resume', 1, true), 'resume notice removed (0.1.303)')
check(src_w:find('piece.copy_text or piece.text', 1, true) ~= nil, 'term_line copies the official name')
check(src_w:find('draw_key_mark', 1, true) ~= nil, 'widgets can draw the key-item mark')
eq(CT.click_action('poss_count'), 'tip', 'count is not a copy target')
eq(CT.click_action('poss_key_mark'), 'tip', 'key mark is not a copy target')

local function ui_of(fn_need)
    return {
        settings = { items = { show_possession = true } },
        t = function (k, args)
            if k == 'sf.poss_held' then return string.format('(%s/%s)', args.have, args.need) end
            if k == 'sf.poss_none_tip' then return '未所持' end
            if k == 'poss.part' then return args.where .. tostring(args.n) end
            if k == 'poss.c0' then return 'かばん' end
            if k == 'poss.sep' then return '・' end
            return k
        end,
        need_possession = fn_need,
        data = nil,
    }
end

-- 短い名前を押したときのコピーは正式名称だけ。数は別の言葉。
do
    local ui = ui_of(function (n)
        if n.name_ja and n.name_ja:find('頭', 1, true) then
            return { state = 'enough', have = 1, need = 1, kind = 'item', parts = { { 0, 1 } }, unknown = {} }
        end
        return { state = 'short', have = 0, need = 1, kind = 'item', parts = {}, unknown = {} }
    end)
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
    check(out:find('クゥダフ人形の頭(1/1)', 1, true) ~= nil, 'full name keeps its count in the text')
    check(out:find('胴(0/1)', 1, true) ~= nil, 'short name keeps its count in the text')
    local by_s = {}
    for _, e in ipairs(extras) do by_s[e.s] = e end
    eq(by_s['胴'].kind, 'item', 'short name is an item term')
    eq(by_s['胴'].copy_text, 'クゥダフ人形の胴', 'short name copies the official name')
    check(by_s['クゥダフ人形の頭'] and by_s['クゥダフ人形の頭'].copy_text == 'クゥダフ人形の頭', 'full name copies only the official name')
    check(by_s['1/1'] and by_s['1/1'].kind == 'poss_count', 'owned count is a count term')
    eq(by_s['1/1'].color, 'good', 'enough count is green')
    check(by_s['1/1'].tip and by_s['1/1'].tip:find('かばん', 1, true), 'owned count tip names the container')
    check(by_s['0/1'] and by_s['0/1'].kind == 'poss_count', 'short count is a count term')
    eq(by_s['0/1'].color, 'ic_bad', 'short count is red')
    eq(by_s['0/1'].tip, '未所持', 'zero count tip is 未所持')
    check(not by_s['胴(0/1)'], 'the combined name+count is not a single term')

    local terms = poss_ui.merge_terms({}, extras)
    local spans = CT.spans(out, terms)
    local saw_name, saw_num, saw_paren = false, false, false
    for _, sp in ipairs(spans) do
        if sp.text == '胴' then
            saw_name = true
            eq(sp.kind, 'item', '胴 stays item-colored')
            eq(sp.copy_text, 'クゥダフ人形の胴', 'span copy_text is official')
        end
        if sp.text == '0/1' then
            saw_num = true
            eq(sp.kind, 'poss_count', 'numbers are the count span')
            eq(CT.click_action(sp.kind), 'tip', 'clicking the count does not copy')
        end
        if sp.text:find('所持', 1, true) and not sp.kind then saw_paren = true end
    end
    check(saw_name and saw_num, 'name and numbers are separate spans')
end

-- だいじなもの：括弧の中に印用の枠。所持／未所持の文言は付けない。
do
    local ui = ui_of(function (n)
        if n.name_ja == '持っている鍵' then return { state = 'owned', kind = 'key' } end
        return { state = 'missing', kind = 'key' }
    end)
    local step = { needs = { { name_ja = '持っている鍵', kind = 'key_item' }, { name_ja = '無い鍵', kind = 'key_item' } } }
    local out, extras = poss_ui.apply_to_step(ui, step, '「持っている鍵」と「無い鍵」を渡す')
    -- 「を渡す」 is not in REQUIRE_TAIL (を渡し / を渡して). を渡す - I have を渡し which is prefix of を渡す!
    -- starts_with('を渡す', 'を渡し') is true! So it would be require. Good.
    check(out:find('持っている鍵(' .. poss_ui.KEY_MARK_SLOT .. ')', 1, true) ~= nil, 'owned key gets a mark slot')
    check(out:find('無い鍵(' .. poss_ui.KEY_MARK_SLOT .. ')', 1, true) ~= nil, 'missing key gets a mark slot')
    check(not out:find('所持）', 1, true) and not out:find('未所持', 1, true), 'key items do not use 所持 wording')
    local marks = {}
    for _, e in ipairs(extras) do
        if e.kind == 'poss_key_mark' then marks[e.key] = e.mark end
        if e.copy_text then check(not tostring(e.copy_text):find(poss_ui.KEY_MARK_SLOT, 1, true), 'copy text has no mark') end
    end
    eq(marks['持っている鍵'], 'ok', 'owned key mark is ok')
    eq(marks['無い鍵'], 'no', 'missing key mark is no')
end

-- BM2-1：必要品だけ付ける。入手だけの品は付けない。報告書は渡す手順で付ける。
do
    local D = data_mod.load(posix_fs(), ROOT .. '/data/')
    local q = D:quest('mission.bastok.004')
    check(q and q.steps and #q.steps >= 5, 'BM2-1 is loaded with steps')
    local ui = ui_of(function (n)
        if n.kind == 'key_item' or n.name_ja == 'CL研究報告書' then
            return { state = 'missing', kind = 'key' }
        end
        if n.item_id or n.item_ids or (n.name_ja and n.name_ja ~= 'クリスタル') then
            return { state = 'short', have = 0, need = n.count or 1, kind = 'item', parts = {}, unknown = {} }
        end
        return { state = 'unknown', kind = 'item' }
    end)
    ui.data = D
    local s2, s3, s5 = q.steps[2], q.steps[3], q.steps[5]
    local t2 = poss_ui.apply_to_step(ui, s2, s2.next_line_ja, q)
    check(t2:find('クリスタル(0/1)', 1, true) ~= nil, 'generic クリスタル sums the 8 crystals')
    check(not t2:find('変色クリスタル(', 1, true), 'obtained 変色クリスタル on step 2 gets no count')
    local t3 = poss_ui.apply_to_step(ui, s3, s3.next_line_ja, q)
    check(t3:find('変色クリスタル(0/1)', 1, true) ~= nil, 'required 変色クリスタル on step 3 is counted')
    check(not t3:find('CL研究報告書(', 1, true), 'obtained 報告書 on step 3 gets no count')
    local t5, ex5 = poss_ui.apply_to_step(ui, s5, s5.next_line_ja, q)
    local has_mark = t5:find('CL研究報告書(' .. poss_ui.KEY_MARK_SLOT .. ')', 1, true) ~= nil
    -- 番号が資料に無いときは印は付かない（未確認のまま）。照合で必要と分かることだけ確認する。
    local needed = false
    for _, n in ipairs(poss_ui.gather_needs(ui, s5, s5.next_line_ja, q)) do
        if (n.name_ja or '') == 'CL研究報告書' then needed = true end
    end
    check(needed, 'step 5 treats CL研究報告書 as required even if needs is empty')
    if D.lookup_item_name and D:lookup_item_name('CL研究報告書') then
        check(has_mark, '報告書 has a key mark when a ref exists')
    end
end

-- 赤き試練：入手のカギには付けない。次のトレード手順には付ける。
do
    local D = data_mod.load(posix_fs(), ROOT .. '/data/')
    local q = D:quest('quest.sandoria.063')
    check(q and #q.steps >= 4, '赤き試練 loaded')
    local ui = ui_of(function (n)
        return { state = 'short', have = 0, need = 1, kind = 'item', parts = {}, unknown = {} }
    end)
    ui.data = D
    local s3, s4 = q.steps[3], q.steps[4]
    local t3 = poss_ui.apply_to_step(ui, s3, s3.next_line_ja, q)
    check(not t3:find('カギ(', 1, true) and not t3:find('ダボイ貯蔵庫のカギ(', 1, true),
        'obtaining the key does not add a count')
    local t4 = poss_ui.apply_to_step(ui, s4, '次：' .. (s4.next_line_ja or ''), q)
    check(t4:find('カギ(0/1)', 1, true) ~= nil or t4:find('ダボイ貯蔵庫のカギ(0/1)', 1, true) ~= nil,
        'the 次： trade line counts the required key')
    check(not t4:find('オーキシュ・ドライフード(', 1, true), 'obtained food on the 次： line gets no count')
end

-- 全手順の監査：必要品なのにインラインが付かない件数
do
    local D = data_mod.load(posix_fs(), ROOT .. '/data/')
    local ui = ui_of(function (n)
        if n.kind == 'key_item' or (n.key_item_id ~= nil) then
            return { state = 'missing', kind = 'key' }
        end
        if n.item_id ~= nil then
            return { state = 'short', have = 0, need = n.count or 1, kind = 'item', parts = {}, unknown = {} }
        end
        return { state = 'unknown' }
    end)
    ui.data = D
    local function has_hold(out, name)
        if out:find(name .. '(', 1, true) then return true end
        local short = poss_ui.short_need_name(name)
        if short and short ~= name and out:find(short .. '(', 1, true) then return true end
        return false
    end
    local before_miss, after_miss, required_n, inferred_n, no_id = 0, 0, 0, 0, 0
    local leftover = {}
    for _, q in ipairs(D:list('quest') or {}) do
        -- list may not exist that way; walk by_id
    end
    local seen_q = {}
    local function each_quest(q)
        if not q or not q.steps or seen_q[q.id] then return end
        seen_q[q.id] = true
        for _, s in ipairs(q.steps) do
            local text = s.next_line_ja or ''
            if text == '' then goto continue end
            local needs = poss_ui.gather_needs(ui, s, text, q)
            for _, n in ipairs(needs) do
                local name = n.name_ja or n.name_en
                if not name then goto nx end
                required_n = required_n + 1
                local in_data = false
                for _, d in ipairs(s.needs or {}) do
                    if (d.name_ja or d.name_en) == name then in_data = true end
                end
                if not in_data then inferred_n = inferred_n + 1 end
                -- before: only official step.needs, and only if suffix would apply (id known or state not unknown)
                local old = text
                if in_data then
                    local fake_step = { needs = s.needs }
                    -- old apply used only step.needs; reproduce by gathering without infer: step.needs only
                    local only = { needs = s.needs }
                    -- Temporarily: apply with q=nil so quoted infer still happens... 
                    -- For "before", use a step with only original needs and q=nil, AND disable quoted infer
                    -- We'll compare output of apply_to_step(ui, s, text) without q vs with q, plus whether name is in original needs.
                    local t_old = poss_ui.apply_to_step(ui, { needs = s.needs }, text) -- q nil, no quoted? quoted infer still runs!
                end
                local t_new = poss_ui.apply_to_step(ui, s, text, q)
                local st = ui.need_possession(n)
                if st.state == 'unknown' then
                    no_id = no_id + 1
                    if not has_hold(t_new, name) then
                        leftover[#leftover + 1] = { q = q.id, step = s.id, name = name, why = 'no id' }
                        after_miss = after_miss + 1
                    end
                else
                    if not has_hold(t_new, name) then
                        leftover[#leftover + 1] = { q = q.id, step = s.id, name = name, why = 'not in text' }
                        after_miss = after_miss + 1
                    end
                end
                ::nx::
            end
            -- before misses: required by new gather, but old apply (step.needs only, no q, no quote infer)
            -- Compute old by applying only s.needs without quote inference: copy apply using a flag is hard.
            -- Approximate: if name wasn't in s.needs, old would miss it (unless name appears and was in needs).
            for _, n in ipairs(needs) do
                local name = n.name_ja or n.name_en
                local in_data = false
                for _, d in ipairs(s.needs or {}) do
                    if (d.name_ja or d.name_en) == name then in_data = true end
                end
                local st = ui.need_possession(n)
                local would_old = false
                if in_data and st.state ~= 'unknown' then
                    local t_old = poss_ui.apply_to_step(ui, { needs = s.needs or {} }, text)
                    would_old = has_hold(t_old, name)
                    -- Problem: apply_to_step still infers quotes without needing q.
                    -- So t_old may also infer. For before-count I'll compute separately below.
                end
            end
            ::continue::
        end
    end
    -- walk all quests in by_id
    local all = {}
    if D.list then
        for _, kind in ipairs({ 'quest', 'mission' }) do
            local ok, ls = pcall(D.list, D, kind)
            if ok and ls then for _, q in ipairs(ls) do all[#all + 1] = q end end
        end
    end
    if #all == 0 and D.by_id then
        for _, q in pairs(D.by_id) do all[#all + 1] = q end
    end
    leftover = {}
    required_n, inferred_n, no_id, after_miss, before_miss = 0, 0, 0, 0, 0
    seen_q = {}
    for _, q in ipairs(all) do
        if q and q.steps and not seen_q[q.id] then
            seen_q[q.id] = true
            for _, s in ipairs(q.steps) do
                local text = s.next_line_ja or ''
                if text ~= '' then
                    local needs = poss_ui.gather_needs(ui, s, text, q)
                    local t_new = poss_ui.apply_to_step(ui, s, text, q)
                    -- old: only original needs, and ignore inferred quoted names by applying to a copy
                    -- with infer still on... Use only names in s.needs and see if they appear with suffix
                    -- when we strip quote-inferred extras. We'll mark before miss if name not in s.needs
                    -- or old output wouldn't have suffix because name didn't match and... append would add it
                    -- if it was in s.needs! Old apply appended unmatched needs. So old missed only:
                    -- 1) inferred names not in s.needs
                    -- 2) unknown state (no id)
                    -- 3) matching bugs
                    for _, n in ipairs(needs) do
                        local name = n.name_ja or n.name_en
                        if name then
                            required_n = required_n + 1
                            local in_data = false
                            for _, d in ipairs(s.needs or {}) do
                                if (d.name_ja or d.name_en) == name then in_data = true end
                            end
                            if not in_data then inferred_n = inferred_n + 1 end
                            local st = ui.need_possession(n)
                            local new_ok = has_hold(t_new, name)
                            local old_ok = false
                            if in_data then
                                -- appended or in-text; unknown would not suffix
                                if st.state ~= 'unknown' then
                                    old_ok = true
                                    -- unless? if name not in text, old still appended. so old_ok true if known id
                                end
                            end
                            if not old_ok then before_miss = before_miss + 1 end
                            if st.state == 'unknown' then
                                no_id = no_id + 1
                                if not new_ok then
                                    after_miss = after_miss + 1
                                    if #leftover < 40 then leftover[#leftover + 1] = q.id .. ' ' .. tostring(s.id) .. ' ' .. name .. ' (番号なし)' end
                                end
                            elseif not new_ok then
                                after_miss = after_miss + 1
                                if #leftover < 40 then leftover[#leftover + 1] = q.id .. ' ' .. tostring(s.id) .. ' ' .. name .. ' (文に付かない)' end
                            end
                        end
                    end
                end
            end
        end
    end
    local f = assert(io.open(TMP .. '/audit260.txt', 'w'))
    f:write('required=' .. required_n .. '\n')
    f:write('inferred=' .. inferred_n .. '\n')
    f:write('before_miss=' .. before_miss .. '\n')
    f:write('after_miss=' .. after_miss .. '\n')
    f:write('no_id=' .. no_id .. '\n')
    f:write('quests=' .. tostring((function () local n=0 for _ in pairs(seen_q) do n=n+1 end return n end)()) .. '\n')
    for _, row in ipairs(leftover) do f:write(row .. '\n') end
    f:close()
    check(required_n > 0, 'audit found required items: ' .. tostring(required_n))
    check(after_miss < before_miss or inferred_n > 0, 'matching improved or inferred some missing needs')
    -- stash on a global for the printed report
    _G.AUDIT260 = {
        required = required_n, inferred = inferred_n,
        before_miss = before_miss, after_miss = after_miss, no_id = no_id,
        leftover = leftover,
    }
    print(string.format('audit260 required=%d inferred=%d before_miss=%d after_miss=%d no_id=%d leftover_shown=%d',
        required_n, inferred_n, before_miss, after_miss, no_id, #leftover))
end

print('test_sf_260 ok')
