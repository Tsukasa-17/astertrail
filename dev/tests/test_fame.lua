-- 0.1.66: 名声を教えてくれる人の返事（チャット欄の行）から名声ランクを覚え、受ける条件に使う
require('harness')
local fame = require('src.core.fame')
local marks = require('src.core.marks')
local json = require('src.lib.json')
local settings_mod = require('src.core.settings')

-- 決まり文句（改行 07・色 1E 01・終わり 7F 31・全角空白が入っても読める）
eq(fame.read('sandoria', 'うむ、Tester\7だと……？\7残念だが、聞いたことはないな、\7そのような名は。\127\49'), 1, 'sandoria 1')
eq(fame.read('sandoria', '……？ふーむ、その名はどこかで聞いた覚えが\7あるような、ないような……。'), 2, 'sandoria 2 across break')
eq(fame.read('sandoria', 'ああ、Testerか。\7その名は聞いた覚えがあるぞ。'), 3, 'sandoria 3')
eq(fame.read('sandoria', '\30\1Namonutice : やあ、Tester。君の名も、この国ではそこそこ\7知られるようになってきたようだぞ。'), 4, 'sandoria 4 with color code')
eq(fame.read('sandoria', 'Tester殿！御活躍のうわさは、いろいろと耳に入って\7きておりますぞ。あなたの名を知らぬ者は、'), 8, 'sandoria 8')
eq(fame.read('sandoria', 'Tester殿！あなたは、この国の庶民にとっては、\7まさに英雄だ。あなたの名を知らぬ者は、'), 9, 'sandoria 9 before 8')
eq(fame.read('bastok', 'Tester殿！あなたは、この国の庶民にとっては、\7まさに英雄ですよ。'), 8, 'bastok hero is 8')
eq(fame.read('bastok', 'あなたという存在はわたしにとって\7英雄といってもいいくらいです。'), 9, 'bastok 9')
eq(fame.read('bastok', 'Testerさん。あなたの名は、もうこの国のほとんど\7みんなが知ってますよ。'), 6, 'bastok 6')
eq(fame.read('bastok', 'Testerさん。あなたの名は、もうこの国のみんなが\7知っております。'), 7, 'bastok 7')
eq(fame.read('windurst', 'ご活躍のうわさ、いろいろと\7耳に入ってきています。'), 8, 'windurst 8')
eq(fame.read('windurst', 'その名はどこかで聞いた覚えがあるような、\7そうでもないような……。'), 2, 'windurst 2')
eq(fame.read('jeuno', 'Testerさん！あなたの名は、もうこの国のそこかしこに\7広まっていますよ。'), 6, 'jeuno 6')
eq(fame.read('jeuno', 'Testerさん。ここではほとんどの人があなたの名を\7知っているでしょう。'), 7, 'jeuno 7')
eq(fame.read('norg', 'あぁ、誰だてめぇ？Testerだ？　聞いたことねぇな。'), 1, 'norg 1 with wide space')
eq(fame.read('norg', 'おー、Tester。最近よくあんたの名前を聞くぜ。'), 4, 'norg 4')
eq(fame.read('norg', 'Testerさん。あんた、いやあなたの名前は\7もうここじゃ知らない人はいないよ。'), 7, 'norg 7')
eq(fame.read('rabao', 'うん？　Tester？その名前はきいた覚えがあるよ～。'), 3, 'rabao 3')
eq(fame.read('rabao', '……Tester？んー、どこかできいた覚えがあるような。'), 2, 'rabao 2')
eq(fame.read('kazham', 'あんたの名前は、\7住人のほとんどが知っているよ。'), 6, 'kazham 6')
eq(fame.read('sandoria', 'まあ、この国の庶民のために骨を折って頑張っていれば'), nil, 'follow-up line not read')
eq(fame.read('nowhere', 'その名は聞いた覚えがあるぞ'), nil, 'unknown area')
-- どの地域も 1〜9 がそろっていて、同じ地域で同じ文句が二つのランクに当たらない
for _, area in ipairs(fame.AREAS) do
    local list = fame.PHRASES[area]
    eq(#list, 9, 'nine phrases ' .. area)
    for i, p in ipairs(list) do
        eq(p[1], 10 - i, 'order ' .. area .. ' ' .. i)
        eq(fame.read(area, p[2]), p[1], 'self ' .. area .. ' ' .. p[1])
    end
end
local zones = 0
for _, spec in pairs(fame.NPC_BY_ZONE) do zones = zones + 1; check(fame.PHRASES[spec.area], 'phrases for ' .. spec.area) end
eq(zones, 7, 'seven fame NPCs')
-- 返事らしさ：ゾーンと、ターゲットの名前か行の中の名前
check(fame.context(230, 'Namonutice', 'x'), 'context by target')
check(fame.context(230, nil, 'Namonutice : x'), 'context by line')
check(not fame.context(230, 'Someone', 'x'), 'not other npc')
check(not fame.context(231, 'Namonutice', 'x'), 'not other zone')

-- 受けられない理由の文から名声の条件
local function lr(text, cat) return { category = cat, lock_reasons = { { type = 'fame', text_ja = text } } } end
local r = fame.reqs(lr('名声ランク3（「聞いた覚えがあるぞ」）以上', 'sandoria'))
eq(#r, 1, 'one req'); eq(r[1].area, 'sandoria', 'area from category'); eq(r[1].level, 3, 'level 3')
r = fame.reqs(lr('バストゥークの名声ランク4（そこそこ知られる）以上', 'bastok')); eq(r[1].area, 'bastok', 'bastok prefix'); eq(r[1].level, 4, 'b4')
r = fame.reqs(lr('サンドリア名声ランク5（「かなり知られる」）以上', 'sandoria')); eq(r[1].level, 5, 's5')
r = fame.reqs(lr('クエスト「魔法の水」クリア後エリアチェンジ、名声5（「かなり知られる」）以上', 'windurst')); eq(r[1].level, 5, 'w5 without ランク')
r = fame.reqs(lr('名声「ほとんど知っている」', 'sandoria')); eq(r[1].level, 6, 'almost everyone = 6')
eq(#fame.reqs(lr('天晶堂の名声ランク一定以上', 'bastok')), 0, 'no number: not judged')
eq(#fame.reqs(lr('名声がある程度以上', 'windurst')), 0, 'vague: not judged')
eq(#fame.reqs(lr('名声ランク3以上', nil)), 0, 'no area: not judged')

-- 実データ：77件のうち数のある条件は拾える
local D = require('src.core.data').load(posix_fs(), ROOT .. '/data/')
local q = D:quest('quest.sandoria.004')
check(q, 'data quest')
check(marks.reqs_unmet(q, { fame = { sandoria = { level = 2 } } }), 'sandoria 2 < 3: unavailable')
check(not marks.reqs_unmet(q, { fame = { sandoria = { level = 3 } } }), 'rank 3 ok')
check(not marks.reqs_unmet(q, { fame = { bastok = { level = 1 } } }), 'other area unknown: not blocked')
check(not marks.reqs_unmet(q, { main_job = 1, main_job_level = 75 }), 'no fame: not blocked')
local counted = 0
for _, kind in ipairs({ 'sandoria', 'bastok', 'windurst' }) do
    for i = 1, 99 do
        local qq = D:quest(string.format('quest.%s.%03d', kind, i))
        if qq and #fame.reqs(qq) > 0 then counted = counted + 1 end
    end
end
check(counted >= 60, 'most fame reqs parsed: ' .. counted)

-- 設定：覚えた名声は 1〜9 だけ残し、{} で保存する
local m = settings_mod.merge({ fame = { sandoria = { level = 3, at = '2026-11-14T10:00:00+09:00', npc = 'Namonutice' }, bastok = { level = 12 }, x = 'bad' } })
eq(m.fame.sandoria.level, 3, 'kept'); eq(m.fame.bastok, nil, 'out of range dropped'); eq(m.fame.x, nil, 'bad dropped')
check(json.encode(settings_mod.defaults().fame):find('{', 1, true), 'empty fame saved as object')
local m2 = settings_mod.merge(json.decode(json.encode(settings_mod.merge(json.decode('{"fame":[]}')))))
m2.fame.jeuno = { level = 5 }
check(json.encode(m2.fame):find('jeuno', 1, true), 'keys survive after empty round trip')

-- アドオンを通して：チャット欄の行 → 覚える → status に出る → 条件に使う
require('fake_env')
_G.vana = _G.vana or {}
_G.vana.encoding = _G.vana.encoding or {}
_G.vana.encoding.from_shift_jis = function (s) return s end   -- テストでは UTF-8 のまま
dofile(ROOT .. '/astertrail.lua')
check(FAKE.events.text_in, 'text_in registered')
FAKE.events.load()
local app = require('src.app')
local plat = require('src.platform.ashita')
FAKE.player = { name = 'Tester', zone = 230, tidx = 5, status = 0 }
frames(2)
FAKE.printed = {}
FAKE.events.command({ command = '/astertrail status', blocked = false })
check(printed('名声はまだ覚えていません'), 'status: none yet')
-- ほかの人の行は読まない
FAKE.events.text_in({ mode = 150, message = 'Someone : その名は聞いた覚えがあるぞ。', blocked = false })
eq(app._settings().fame.sandoria, nil, 'other npc ignored')
-- 自分の出した行（injected）は読まない
FAKE.events.text_in({ mode = 150, message = 'Namonutice : その名は聞いた覚えがあるぞ。', injected = true })
eq(app._settings().fame.sandoria, nil, 'injected ignored')
FAKE.printed = {}
FAKE.events.text_in({ mode = 150, message = 'Namonutice : ああ、Testerか。\7その名は聞いた覚えがあるぞ。\127\49', blocked = false })
local e = app._settings().fame.sandoria
check(e and e.level == 3, 'remembered sandoria 3')
check(e and e.at and e.at:match('^%d%d%d%d%-%d%d%-%d%d'), 'with date')
check(not printed('名声を覚えました'), 'not printed inside text_in (would be swallowed in-game)')
frame()
check(printed('名声を覚えました：サンドリア ランク3'), 'told in chat on the next frame')
-- 続きの行は記録しない、関係ない返事は記録する
local log = TMP .. '/Vanacore/config/addons/astertrail/catseye_Tester/fame_unmatched.log'
FAKE.events.text_in({ mode = 150, message = 'Namonutice : 評判もまあまあと言ったところか。' })
check(not ashita.fs.exists(log), 'follow-up not logged')
FAKE.time = FAKE.time + 30; frame()
FAKE.events.text_in({ mode = 150, message = 'Namonutice : \30\1見たことのない返事\7です。' })
check(ashita.fs.exists(log), 'unmatched logged')
local f = io.open(log, 'rb'); local body = f and f:read('*a') or ''; if f then f:close() end
check(body:find('area=sandoria', 1, true) and body:find('見たことのない返事', 1, true), 'log line: ' .. body)
-- ターゲットの名前でも読む
local saved_target = plat.current_target
plat.current_target = function () return { name = 'Namonutice', index = 9 } end
FAKE.events.text_in({ mode = 150, message = 'やあ、Tester。君の名は、この国ではもうかなり\7知られるようになってきたぞ。' })
eq(app._settings().fame.sandoria.level, 5, 'by target name')
plat.current_target = saved_target
-- status に出る
FAKE.printed = {}
FAKE.events.command({ command = '/astertrail status', blocked = false })
check(printed('覚えた名声：サンドリア 5'), 'status shows fame: ' .. table.concat(FAKE.printed, ' | '))
-- 条件の判定に渡る（ジョブ等が読めなくても名声だけで）
frame()
local rs = app.state.rstat
check(rs and rs.fame and rs.fame.sandoria.level == 5, 'rstat carries fame')
local q38 = app._data():quest('quest.sandoria.038')   -- 名声ランク5以上
check(not marks.reqs_unmet(q38, rs), 'rank5 quest ok at 5')
app._settings().fame.sandoria.level = 4
check(marks.reqs_unmet(q38, app.state.rstat), 'rank5 quest unavailable at 4')
-- ほかのゾーンでは読まない
FAKE.player.zone = 231; frames(2)
FAKE.events.text_in({ mode = 150, message = 'Namonutice : 残念だが、聞いたことはないな' })
eq(app._settings().fame.sandoria.level, 4, 'other zone ignored')
-- 保存される
cmd('/astertrail save')
local sf = io.open(TMP .. '/Vanacore/config/addons/astertrail/catseye_Tester/settings.json', 'rb')
local sj = sf and sf:read('*a') or ''; if sf then sf:close() end
check(sj:find('"fame"', 1, true) and sj:find('Namonutice', 1, true), 'fame saved in settings')
FAKE.events.unload()
check(not printed('present:'), 'no present errors')
io.write('test_fame done\n')
