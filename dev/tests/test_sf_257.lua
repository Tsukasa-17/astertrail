-- 0.1.257：SF 詳細の余白・折り返し・丸の数字・所持・カードのバッジ
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.292', 'version')

local book_sf = require('src.ui.book_sf')
local src = io.open(ROOT .. '/src/ui/book_sf.lua', 'r'):read('*a')
local ct = io.open(ROOT .. '/src/ui/colored_text.lua', 'r'):read('*a')
local tr = io.open(ROOT .. '/src/ui/tracker_sf.lua', 'r'):read('*a')

check(src:find('##astertrail_sf_detail_inner', 1, true) ~= nil, 'detail uses an inner padded child')
check(src:find('hang_x', 1, true) ~= nil, 'step text passes hang_x')
check(ct:find('opts.hang_x', 1, true) ~= nil, 'colored text honors hang_x')
check(src:find('DOT_R, COL, ROW_GAP = 13', 1, true) ~= nil, 'step circles are larger')
check(src:find('copy_to_clipboard', 1, true) ~= nil, 'SF book restores item copy')
check(src:find('sf.break_row(imgui)', 1, true) ~= nil and src:find('Dummy({ 1, math.max(1, h) })', 1, true) ~= nil,
    'filter chips advance a full row')
check(src:find('local h = 108', 1, true) ~= nil, 'cards are tall enough for the badge row')
check(tr:find('Dummy({ 8, 1 })', 1, true) ~= nil, 'tracker leaves space before the prev button')

-- 文中にフルネームが無い必要品でも所持を付ける
do
    local ui = {
        settings = { items = { show_possession = true } },
        t = function (k, args)
            if k == 'sf.poss_held' then return string.format('(%s/%s)', args.have, args.need) end
            return k
        end,
        need_possession = function (n)
            return { state = 'short', have = 0, need = n.count or 1, kind = 'item' }
        end,
    }
    local s = {
        needs = {
            { name_ja = 'クゥダフ人形の頭', kind = 'item', count = 1 },
            { name_ja = 'クゥダフ人形の胴', kind = 'item', count = 1 },
            { name_ja = 'クゥダフ人形の腕', kind = 'item', count = 1 },
            { name_ja = 'クゥダフ人形の足', kind = 'item', count = 1 },
        },
    }
    local text = 'パルブロ鉱山のクゥダフを倒して、クゥダフ人形の頭・胴・腕・足を集める'
    local out = book_sf._step_text_with_poss(ui, s, text)
    check(out:find('クゥダフ人形の頭(0/1)', 1, true) ~= nil, 'full name keeps its count')
    check(out:find('胴(0/1)', 1, true) ~= nil, 'short 胴 gets a count')
    check(out:find('腕(0/1)', 1, true) ~= nil, 'short 腕 gets a count')
    check(out:find('足(0/1)', 1, true) ~= nil, 'short 足 gets a count')
    -- 文に全く出ない必要品は末尾へ
    local s2 = { needs = { { name_ja = 'ジュノ大公面会許可証', kind = 'key_item', count = 1 } } }
    ui.need_possession = function () return { state = 'missing', kind = 'key' } end
    ui.t = function (k)
        if k == 'sf.poss_key_missing' then return '（未所持）' end
        return k
    end
    local out2 = book_sf._step_text_with_poss(ui, s2, '大公宮のDoor:Audience Chamberを調べてイベント')
    local slot = require('src.ui.possession_ui').KEY_MARK_SLOT
    check(out2:find('ジュノ大公面会許可証(' .. slot .. ')', 1, true) ~= nil, 'unwritten need is appended')
end

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()

-- クラシックはこれまでどおり
S.look = 'classic'
app.close_all(); app.open_window('book'); frame(); frame()
check(labeled('ミッション') or texted('ミッション'), 'classic tab unchanged')
check(not texted('ASTERTRAIL'), 'classic has no logo')

S.look = 'sf'
S.book.tab = 'mission'
S.items.show_possession = true
app.close_all(); app.open_window('book'); frame(); frame(); frame()
check(texted('ASTERTRAIL'), 'SF logo')
FAKE.clicks['##sfcard_mission.bastok.003'] = true
frame(); frame()
check(texted('終わらぬ戦い') or labeled('終わらぬ戦い'), 'BM1-3 detail')
check(texted('OBJECTIVE') or labeled('OBJECTIVE'), 'OBJECTIVE heading')
check(texted('REWARD') or labeled('REWARD'), 'REWARD heading')

-- バッジ用の文言はカードにも出る
check(texted('完了') or texted('進行中') or texted('未開始')
    or labeled('完了') or labeled('進行中') or labeled('未開始'), 'status badge labels remain')

print('test_sf_257 ok')
