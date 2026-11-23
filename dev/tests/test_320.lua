-- 0.1.322：ミッション・クエストのカードの色を状態で分ける（進行中＝やわらかい紫ピンク、未開始＝今まで、完了＝金）
require('fake_env')
local app = require('src.app')
eq(app.VERSION, '1.1.324', 'version')
local theme = require('src.ui.theme')
local sf = require('src.ui.sf_style')
local book_sf = require('src.ui.book_sf')

dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'T320', zone = 230, tidx = 5, status = 0 }
frames(1)
local S = app._settings()
local P = app._progress()

-- 1) 色の決まり
theme.set_look('sf')
local v = theme.palette.sf_violet
check(v and math.abs(v[1] - 0.85) < 0.02 and math.abs(v[2] - 0.65) < 0.02 and math.abs(v[3] - 0.91) < 0.02, 'violet about #D9A6E8')
eq(book_sf.card_line_key, nil, 'no per-state card line (0.1.319 reverted)')
local tt = function (k) return k end
eq(select(2, book_sf._badge_of(tt, 'accepted')), 'sf_violet', 'progress badge')
eq(select(2, book_sf._badge_of(tt, 'completed')), 'sf_amber', 'done badge (as before)')
eq(select(2, book_sf._badge_of(tt, 'not_accepted')), 'muted', 'idle badge (as before)')

-- 2) 実際のカード：外枠・札の枠・札の文字の色を記録する
local frames_log, texts_log = {}, {}
local real_frame, real_text = sf.frame, sf.add_text
sf.frame = function (dl, x1, y1, x2, y2, o)
    frames_log[#frames_log + 1] = { cut = o and o.cut, line = o and o.line, glow_col = o and o.glow_col, glow = o and o.glow, thick = o and o.thick, brackets = o and o.brackets, line_a = o and o.line_a }
    return real_frame(dl, x1, y1, x2, y2, o)
end
sf.add_text = function (dl, x, y, col, text)
    texts_log[#texts_log + 1] = { col = col, text = text, n = #frames_log }
    return real_text(dl, x, y, col, text)
end
local A, C, I = 'mission.bastok.001', 'mission.bastok.002', 'mission.bastok.003'
P:set_state(A, 'accepted'); P:set_state(C, 'completed'); P:set_state(I, 'not_accepted')
for _, kind in ipairs({ 'mission', 'quest' }) do
    S.look = 'sf'; theme.set_look('sf')
    S.book.tab = kind
    app.close_all(); app.open_window('book'); frame(); frame()
    frames_log, texts_log = {}, {}
    frame()
    -- 札の文字ごとに、直前のカードの外枠（cut 8）と札の枠（cut 3）を見る
    local seen = {}
    for _, tx in ipairs(texts_log) do
        local key = (tx.text == '進行中' and 'accepted') or (tx.text == '完了' and 'completed') or (tx.text == '未開始' and 'idle') or nil
        if key and not seen[key] then
            local card, badge
            for i = tx.n, 1, -1 do
                local f = frames_log[i]
                if f.cut == 3 and not badge then badge = f end
                if f.cut == 8 then card = f; break end
            end
            seen[key] = { card = card, badge = badge, col = tx.col }
        end
    end
    local function want(key, color, a_line)
        local s = seen[key]
        if not s then return end
        if color then
            eq(s.col, theme.u32(color, 1.0), kind .. ' ' .. key .. ': badge text color')
            eq(s.badge.line, theme.u32(color, 0.95), kind .. ' ' .. key .. ': badge frame color')
            eq(s.card.line, nil, kind .. ' ' .. key .. ': card line is the common default')
        end
    end
    if kind == 'mission' then
        check(seen.accepted and seen.completed and seen.idle, 'mission: all three states drawn')
    end
    want('accepted', 'sf_violet')
    want('completed', 'sf_amber')
    if seen.idle then
        eq(seen.idle.card.line, nil, kind .. ' idle: card line default (unchanged)')
        eq(seen.idle.col, theme.u32('muted', 1.0), kind .. ' idle: badge text unchanged')
    end
end
-- 3) 選んだカードの光り・外枠は 0.1.318 と同じ（状態によらない）
S.book.tab = 'mission'
app.close_all(); app.open_window('book'); frame(); frame()
FAKE.clicks['##sfcard_' .. A] = true; frame()
frames_log, texts_log = {}, {}
frame()
local sel = nil
for _, f in ipairs(frames_log) do if f.cut == 8 and f.glow == 1 then sel = f end end
check(sel ~= nil, 'selected card drawn')
eq(sel.glow_col, theme.u32('sf_cyan', 0.80), 'selected glow stays cyan')
eq(sel.line, nil, 'selected in-progress card line is the common default')
check(sel.thick == 1.9 and sel.brackets == true and sel.line_a == 1.0, 'selected frame as in 0.1.318')
sf.frame, sf.add_text = real_frame, real_text

-- 4) ほかの見た目ではカードを描かない（崩れない）
for _, look in ipairs({ 'classic', 'yunaui' }) do
    S.look = look; theme.set_look(look)
    app.close_all(); app.open_window('book'); frame(); frame()
    check(labeled('ミッション') or texted('ミッション'), look .. ': book still drawn')
end
S.look = 'sf'; theme.set_look('sf')
print('test_320 ok')
