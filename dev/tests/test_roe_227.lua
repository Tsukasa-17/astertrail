-- 0.1.227：ユニティ共通の「フェイスと討伐A〜F」は 3055〜3060。
-- クライアント DAT では日替わりの印（kind 6、値 0〜5）が付くが、
-- LSB の IsUnitySharedRecordAvailable は 3000〜3053 の外を制限しない（毎日受けられる）。
-- サーバーに合わせて灰色にしない。ほかの見出しに同様の外れはない。
require('fake_env')
local roe = require('src.core.roe')

eq(roe.SHARED_FIRST, 3000, 'shared first')
eq(roe.SHARED_LAST, 3053, 'shared last still 3053 (9×6)')
eq(roe.SHARED_FACE_FIRST, 3055, 'face A')
eq(roe.SHARED_FACE_LAST, 3060, 'face F')

-- A=3055 … F=3060。今日が D（shared=3）でも、サーバーは止めない
local cur = { shared = 3, week = 2 }
for i = 0, 5 do
    local id = 3055 + i
    local letter = string.char(65 + i)
    eq(roe.is_rotating(id), false, 'face ' .. letter .. ' is outside LSB shared range')
    eq(roe.rotation_block(id, cur, 4), nil, 'face ' .. letter .. ' not blocked when today is D')
end

-- 対照：同じ日の組に入っている 3000〜3053 は、今日でなければ止まる
eq(roe.rotation_block(3000, cur, 4), 'not_today', 'A first still blocked')
eq(roe.rotation_block(3008, cur, 4), 'not_today', 'A last of 9 still blocked')
local why, letter = roe.rotation_block(3000, cur, 4)
eq(why, 'not_today', 'why is not_today')
eq(letter, 'D', 'letter is today D')
eq(roe.rotation_block(3027, cur, 4), nil, 'D first still ok')
eq(roe.rotation_block(3053, cur, 4), 'not_today', 'F last of 9 still blocked')

-- 今日が A（shared=0）でも、フェイス B〜F は止めない（サーバーは毎日可）
local cur_a = { shared = 0, week = 0 }
eq(roe.rotation_block(3055, cur_a, 4), nil, 'face A not treated as rotating even on A day')
eq(roe.rotation_block(3060, cur_a, 4), nil, 'face F not blocked on A day')
eq(roe.rotation_block(3000, cur_a, 4), nil, 'shared A still ok on A day')
eq(roe.rotation_block(3009, cur_a, 4), 'not_today', 'shared B still blocked on A day')

-- 3054 は欠番（DAT に名前が無い）。範囲にもフェイスにも入れない
eq(roe.is_rotating(3054), false, 'gap 3054 is not rotating')
eq(roe.rotation_block(3054, cur, 4), nil, 'gap 3054 not blocked')

-- リーダー週替わりの範囲はこれまでどおり。その直後は対象外
check(roe.is_rotating(3488) and roe.is_rotating(3707), 'leader range ends still rotate')
eq(roe.is_rotating(3708), false, 'after leader range is not rotating')
eq(roe.rotation_block(3708, cur, 4), nil, 'after leader range not blocked')
