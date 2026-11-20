-- 0.1.255：SF 本のタブ基準線・絞り込み折り返し・相手/所持の行、カーソル復帰
require('fake_env')

local theme = require('src.ui.theme')
local sf = require('src.ui.sf_style')
local app = require('src.app')
eq(app.VERSION, '1.1.285', 'version')

-- sf.text_at は ImVec2 風の表でもカーソルを戻す
do
    local cur = { x = 40, y = 80 }
    local im = {
        GetCursorScreenPos = function () return cur end,
        SetCursorScreenPos = function (p)
            if type(p) == 'table' then cur = { x = p.x or p[1], y = p.y or p[2] } end
        end,
    }
    sf.text_at(im, 100, 200, function ()
        eq(cur.x, 100, 'text_at moves x')
        eq(cur.y, 200, 'text_at moves y')
    end)
    eq(cur.x, 40, 'text_at restores x')
    eq(cur.y, 80, 'text_at restores y')
end

-- userdata / cdata（実機の ImVec2）でも戻す
do
    local ok, ffi = pcall(require, 'ffi')
    if ok and ffi then
        pcall(function ()
            ffi.cdef('typedef struct { double x; double y; } AT_ImVec2;')
        end)
        local v = ffi.new('AT_ImVec2')
        v.x, v.y = 11, 22
        local cur = v
        local im = {
            GetCursorScreenPos = function () return cur end,
            SetCursorScreenPos = function (p)
                local x = type(p) == 'table' and (p.x or p[1]) or p
                local y = type(p) == 'table' and (p.y or p[2]) or nil
                cur = ffi.new('AT_ImVec2')
                cur.x, cur.y = x, y
            end,
        }
        sf.text_at(im, 5, 6, function () end)
        eq(tonumber(cur.x), 11, 'text_at restores userdata x')
        eq(tonumber(cur.y), 22, 'text_at restores userdata y')
    end
end

-- 光りは 2 重まで
local glow_src = io.open(ROOT .. '/src/ui/sf_style.lua', 'r'):read('*a')
check(glow_src:find('if glow_n > 2 then glow_n = 2 end', 1, true) ~= nil, 'glow layers capped at 2')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local D = app._data()

local function pick_quest()
    for _, q in ipairs(D:list('quest') or {}) do
        for _, s in ipairs(q.steps or {}) do
            if s.target and (s.next_line_ja or '') ~= '' then return q end
        end
    end
    return D:quest('quest.bastok.028')
end
local q = pick_quest()
check(q ~= nil, 'found a quest with a target step')

-- クラシック：相手：の行は残る
S.look = 'classic'
S.book.tab = 'quest'
S.book.last_row = q.id
app.close_all(); app.open_window('book'); frame(); frame(); frame()
check(texted('相手:') or texted('相手：') or labeled('相手:'), 'classic keeps 相手 line')

-- SF：相手：と 所持：の別行は出ない。タブと絞り込みはある
S.look = 'sf'
app.close_all(); app.open_window('book'); frame(); frame(); frame()
check(texted('ASTERTRAIL'), 'SF logo')
check(texted('MISSION') and texted('QUEST') and texted('EMINENCE'), 'SF tabs')
check(texted('絞り込み') or labeled('絞り込み'), 'filter button')
FAKE.clicks['##sfcard_' .. q.id] = true
frame(); frame()
check(texted('OBJECTIVE') or labeled('OBJECTIVE'), 'SF detail after card click')
check(not texted('相手:'), 'SF has no 相手: line')
check(not texted('相手：'), 'SF has no 相手： line')
check(not texted('所持:'), 'SF has no 所持: line')
check(not texted('所持：'), 'SF has no 所持： line')

-- 絞り込みを開くと地域名が出て、NewLine で折り返す
local imgui = package.loaded['imgui']
local nl = 0
local old_nl = imgui.NewLine
imgui.NewLine = function (...)
    nl = nl + 1
    if old_nl then return old_nl(...) end
end
FAKE.clicks['##sfchip_filters'] = true
frame(); frame()
check(texted('サンドリア') or labeled('サンドリア') or texted('バストゥーク') or labeled('バストゥーク'),
    'area chips appear when filters open')
check(nl >= 1, 'opening filters still uses NewLine (wrap / break_row)')
imgui.NewLine = old_nl

-- クラシックに戻すとロゴは消え、相手：が戻る
S.look = 'classic'
S.book.tab = 'quest'
S.book.last_row = q.id
app.close_all(); app.open_window('book'); frame(); frame()
check(not texted('ASTERTRAIL'), 'logo gone in classic')
check(texted('相手:') or texted('相手：') or labeled('相手:'), 'classic 相手 line still there')

print('test_sf_255 ok')
