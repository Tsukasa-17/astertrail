-- 0.1.261：だいじなものの印、括弧は (1/1) だけ、必要品の番号、手順チェックで進行中にしない
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.308', 'version')

local poss_ui = require('src.ui.possession_ui')
local data_mod = require('src.core.data')
local poss = require('src.core.possession')
local progress = require('src.core.progress')

local D = data_mod.load(posix_fs(), ROOT .. '/data/')
eq(D.version, '2026.11.20-125', 'data version')

local cl = D:lookup_item_name('CL研究報告書')
check(cl and cl.kind == 'key_item' and cl.key_item_id == 12, 'CL研究報告書 is a key item')

local key = D:lookup_item_name('ダボイ貯蔵庫のカギ')
check(key and key.kind == 'item' and key.item_id == 1103, 'ダボイ貯蔵庫のカギ stays a regular item')

local carp = D:lookup_item_name('堀ブナ')
check(carp and carp.item_id == 4401 and not carp.item_ids, '堀ブナ is the quest id 4401')

local cry = D:lookup_item_name('クリスタル')
check(cry and cry.item_ids and #cry.item_ids == 8, 'クリスタル sums the 8 element crystals')

check(D:lookup_item_name('万能薬') and D:lookup_item_name('万能薬').item_id == 4155, '万能薬 id')
check(D:lookup_item_name('森ブナ') and D:lookup_item_name('森ブナ').item_id == 4289, '森ブナ id')
check(D:lookup_item_name('Delkfutt Chest Key') and D:lookup_item_name('Delkfutt Chest Key').item_id == 1036, 'Delkfutt Chest Key alias')

-- 括弧は (have/need) だけ
do
    local ui = {
        settings = { items = { show_possession = true } },
        t = function (k, args)
            if k == 'sf.poss_held' then return string.format('(%s/%s)', args.have, args.need) end
            if k == 'sf.poss_none_tip' then return '未所持' end
            return k
        end,
        need_possession = function (n)
            if n.kind == 'key_item' or n.key_item_id then
                return { state = 'missing', kind = 'key' }
            end
            return { state = 'short', have = 0, need = n.count or 1, kind = 'item', parts = {}, unknown = {} }
        end,
        data = D,
    }
    local q = D:quest('mission.bastok.004')
    check(q and #q.steps >= 5, 'BM2-1 loaded')
    local s5 = q.steps[5]
    local out, extras = poss_ui.apply_to_step(ui, s5, s5.next_line_ja, q)
    local has_mark
    for _, e in ipairs(extras or {}) do
        if e.kind == 'poss_key_mark' then has_mark = true end
    end
    check(has_mark, 'CL研究報告書 gets a key mark')
    local s3 = q.steps[3]
    local t3 = poss_ui.apply_to_step(ui, s3, s3.next_line_ja, q)
    check(t3:find('変色クリスタル(0/1)', 1, true) ~= nil, 'counts use (0/1) without 所持')
    check(not t3:find('所持)', 1, true), 'no 所持 inside the parentheses')

    local s2 = q.steps[2]
    local t2 = poss_ui.apply_to_step(ui, s2, s2.next_line_ja or '', q)
    check(t2:find('クリスタル(0/1)', 1, true) ~= nil, 'generic クリスタル gets a summed count')

    local q2 = D:quest('quest.sandoria.063')
    local s4 = q2.steps[4]
    local t4 = poss_ui.apply_to_step(ui, s4, s4.next_line_ja, q2)
    check(t4:find('カギ(0/1)', 1, true) ~= nil or t4:find('ダボイ貯蔵庫のカギ(0/1)', 1, true) ~= nil,
        'the key item stays a numbered count, not a ✔')
    local marked
    local _, ex4 = poss_ui.apply_to_step(ui, s4, s4.next_line_ja, q2)
    for _, e in ipairs(ex4 or {}) do
        if e.kind == 'poss_key_mark' and (e.key == 'ダボイ貯蔵庫のカギ' or tostring(e.key):find('カギ')) then marked = true end
    end
    check(not marked, 'Davoi Storage Key is not drawn as a key mark')
end

-- 合言葉 HGSI は必要品にしない
do
    local ui = { settings = { items = { show_possession = true } }, t = function () return '' end, data = D }
    local needs = poss_ui.gather_needs(ui, { needs = {} }, 'ララ水道(C-6)のSluice Gateを調べ、合言葉「HGSI」を入れてイベントを見る')
    local has
    for _, n in ipairs(needs) do
        if (n.name_ja or n.name_en) == 'HGSI' then has = true end
    end
    check(not has, 'password HGSI is not a required item')
end

-- 同じ公式名の複数番号は合算
do
    local snap = { containers = { [0] = { [4401] = 2, [5789] = 1 } }, key = function () return false end }
    local st = poss.need_state(snap, { kind = 'item', item_ids = { 4401, 5789 }, count = 1 })
    eq(st.have, 3, 'need_state still sums a list of official ids')
    eq(st.state, 'enough', 'enough when the sum covers the need')
end

-- 手順チェックで受注中にしない
do
    dofile(ROOT .. '/astertrail.lua')
    FAKE.events.load()
    FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
    frames(1)
    local Q = 'mission.bastok.004'
    local q = app._data():quest(Q)
    local sid = q.steps[1].id
    local PR = app._progress()
    eq(PR:state(Q), 'not_accepted', 'starts not accepted')
    app.PUBLIC = false
    local r = app.request('check_step', Q, sid)
    -- ミッションは未受注でもチェックできるが、状態は変えない
    check(r and (r.ok or r.code == 'not_accepted' or r.code == 'public_build'), 'check_step returns')
    if r and r.ok then
        eq(PR:state(Q), 'not_accepted', 'checking a step does not set accepted')
        check(PR:step_done(Q, sid), 'the check itself is stored')
    end
end

-- 未開始に戻す：ゲームが未受注なら受注中を戻す。受注中のフラグがあるものは触らない
do
    local clock = { now = function () return 0 end, iso = function () return 't' end }
    local P = progress.new({ data = D, clock = clock })
    P:reset({ name = 'Tester' })
    local Q = 'mission.bastok.004'
    -- 手で受注中にしたあとに、ゲームは未受注
    P:set_state(Q, 'accepted')
    eq(P:state(Q), 'accepted', 'manual accepted')
    local res = P:revert_unstarted(function (id)
        if id == Q then return 'not_accepted' end
        return nil
    end, Q)
    check(res.ok and res.reverted == 1, 'reverts when the game flag is unset')
    eq(P:state(Q), 'not_accepted', 'back to not started')

    P:set_state(Q, 'accepted')
    local res2 = P:revert_unstarted(function () return 'accepted' end, Q)
    eq(P:state(Q), 'accepted', 'does not touch one the game says is accepted')
    eq(res2.reverted, 0, 'kept when game says accepted')
end

print('test_sf_261 ok')
