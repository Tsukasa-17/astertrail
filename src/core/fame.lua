--[[
  Astertrail - fame（名声を教えてくれる人の返事から、名声ランク 1〜9 を読む。0.1.66〜）
  ゲームに名声を読む API は無い。名声を教えてくれる人に話しかけたときの返事（チャット欄の行）を見る。
  返事の決まり文句は、ゲームの日本語版の会話データ（各ゾーンの会話の DAT）で確かめたものだけを入れる。
  英語版の同じ番号の行と BG Wiki の各 NPC のページ（ランク別の返事）で、ランクの順番を合わせた。
  ここは文字の照合だけ。チャットの読み取りと保存は app と platform。
]]

local fame = {}

-- 名声の地域（保存のキー）と、表示の順番
fame.AREAS = { 'sandoria', 'bastok', 'windurst', 'jeuno', 'norg', 'rabao', 'kazham' }

-- ゾーン番号 → 名声を教えてくれる人（名前は英語のまま）
fame.NPC_BY_ZONE = {
    [230] = { area = 'sandoria', npc = 'Namonutice' },       -- 南サンドリア K-6
    [236] = { area = 'bastok',   npc = 'Flaco' },            -- バストゥーク港 E-6
    [238] = { area = 'windurst', npc = 'Zabirego-Hajigo' },  -- ウィンダス水の区 北F-10
    [245] = { area = 'jeuno',    npc = 'Mendi' },            -- ジュノ下層 H-8
    [247] = { area = 'rabao',    npc = 'Waylea' },           -- ラバオ G-9（セルビナと共通）
    [250] = { area = 'kazham',   npc = 'Ney Hiparujah' },    -- カザム I-11
    [252] = { area = 'norg',     npc = 'Vaultimand' },       -- ノーグ H-8（天晶堂）
}

-- 地域ごとの決まり文句（改行と空白を取ったあとの文字の一部）。上のランクから順に照合する。
-- 会話データの番号：サンドリア 230 番ゾーン 8922〜8937・9260、バストゥーク 236 番 7766〜7783、
-- ウィンダス 238 番 9209〜9224・9606、ジュノ 245 番 7817〜7831・8066、ラバオ 247 番 10063〜10081、
-- カザム 250 番 10456〜10474、ノーグ 252 番 10416〜10434。
fame.PHRASES = {
    sandoria = {
        { 9, 'この国の庶民にとっては、まさに英雄だ' },
        { 8, '御活躍のうわさは、いろいろと耳に入ってきておりますぞ' },
        { 7, 'この国のほぼ全員が知っておりますよ' },
        { 6, 'この国のほとんどの民が知ってますよ' },
        { 5, 'この国ではもうかなり知られるようになってきたぞ' },
        { 4, 'この国ではそこそこ知られるようになってきたようだぞ' },
        { 3, 'その名は聞いた覚えがあるぞ' },
        { 2, 'その名はどこかで聞いた覚えがあるような、ないような' },
        { 1, '残念だが、聞いたことはないな' },
    },
    bastok = {
        { 9, 'あなたという存在はわたしにとって英雄' },
        { 8, 'この国の庶民にとっては、まさに英雄ですよ' },
        { 7, 'この国のみんなが知っております' },
        { 6, 'この国のほとんどみんなが知ってますよ' },
        { 5, 'この国ではもうかなり知られるようになってきたぞ' },
        { 4, 'この国ではそこそこ知られるようになってきたようだぞ' },
        { 3, 'その名は聞いた覚えがあるぞ' },
        { 2, 'その名はどこかで聞いた覚えがあるような、ないような' },
        { 1, '残念だが、聞いたことはないな' },
    },
    windurst = {
        { 9, 'まさに英雄！その勇名は' },
        { 8, 'ご活躍のうわさ、いろいろと耳に入ってきています' },
        { 7, 'この国のみんなが知っております' },
        { 6, 'この国のほとんどみんなが知ってますよ' },
        { 5, '君の名がかなり知られるようになってきたぞ' },
        { 4, 'この国ではそこそこ知られるようになってきたようだね' },
        { 3, 'その名は聞いた覚えがあるぞ' },
        { 2, 'その名はどこかで聞いた覚えがあるような、そうでもないような' },
        { 1, '残念だけど、聞いたことはないよ' },
    },
    jeuno = {
        { 9, 'まさに英雄です！その勇名は' },
        { 8, '御活躍のうわさは、いろいろと耳に入ってきておりますぞ' },
        { 7, 'ここではほとんどの人があなたの名を知っているでしょう' },
        { 6, 'この国のそこかしこに広まっていますよ' },
        { 5, 'この国ではもうかなり知られるようになってきたぞ' },
        { 4, 'ここでも君の名をそこそこ聞くようになってきた' },
        { 3, 'その名は聞き覚えがあるな' },
        { 2, 'その名をどこかで聞いたことがあるような、ないような' },
        { 1, '残念だが、私は聞いたことはないな' },
    },
    rabao = {
        { 9, 'あなたという存在はあたしにとって英雄' },
        { 8, '近隣諸国でのあなたの活躍のうわさ' },
        { 7, 'あなたのことを知らない人はいないんだから' },
        { 6, 'ここにいるほとんどの人が知ってるみたいなの' },
        { 5, '最近君のことをよくきくようになったよ' },
        { 4, 'ここじゃそこそこ知られるようになってきたみたいだよ' },
        { 3, 'その名前はきいた覚えがあるよ' },
        { 2, 'どこかできいた覚えがあるような' },
        { 1, '一度もきいたことないなぁ' },
    },
    kazham = {
        { 9, 'このカザムにも、海の向こうのウィンダスにも' },
        { 8, 'なんてすばらしい活躍をしてるんだろう' },
        { 7, 'この村のみんな、ウィンダスのみんなが' },
        { 6, '住人のほとんどが知っているよ' },
        { 5, 'あんたの名前、かなり知られるようになってきたよ' },
        { 4, 'あんたの名前、あたしがみんなに宣伝しておいたよ' },
        { 3, 'やっと、あんたの名前を覚えたよ' },
        { 2, 'あまり聞いたことないねぇ' },
        { 1, 'わりぃけど、知らないねぇ' },
    },
    norg = {
        { 9, '英雄的存在です' },
        { 8, 'ご活躍のうわさをまた耳にしましたよ' },
        { 7, 'もうここじゃ知らない人はいないよ' },
        { 6, 'ここじゃもうあんたを知らないやつはほとんどいないぜ' },
        { 5, 'ここじゃあかなり知られてるぜ' },
        { 4, '最近よくあんたの名前を聞くぜ' },
        { 3, 'その名前には聞き覚えがあるぜ' },
        { 2, 'どこかで聞いた覚えがあるようなないような' },
        { 1, '聞いたことねぇな' },
    },
}

-- チャットの行を照合しやすい形に：色・自動翻訳などの制御（1E/1F/7F と次の1文字）、改行、空白、全角空白を取る
function fame.normalize(text)
    local s = tostring(text or '')
    s = s:gsub('[\30\31\127].', '')
    s = s:gsub('[%c ]', '')
    s = s:gsub('\227\128\128', '')   -- 全角空白（U+3000）
    return s
end

-- 地域の返事から名声ランクを読む。分からなければ nil
function fame.read(area, text)
    local list = fame.PHRASES[area]
    if not list then return nil end
    local s = fame.normalize(text)
    if s == '' then return nil end
    for _, p in ipairs(list) do
        if s:find(p[2], 1, true) then return p[1] end
    end
    return nil
end

-- この行が、名声を教えてくれる人の返事らしいか（ゾーンと、ターゲットの名前か行の中の名前）
function fame.context(zone_id, target_name, text)
    local spec = fame.NPC_BY_ZONE[tonumber(zone_id) or -1]
    if not spec then return nil end
    if target_name and target_name == spec.npc then return spec end
    if text and tostring(text):find(spec.npc, 1, true) then return spec end
    return nil
end

---------------------------------------------------------------------------
-- 受けられない理由の文から、名声の条件を拾う。{ { area = 'sandoria', level = n }, ... }
-- 「名声ランク3」「名声5」「名声「ほとんど知っている」」（ランク6、用語辞典の表）だけ。
-- 「一定以上」「ある程度」「程度」のように数が無いものは数えない（読めない条件は止めない）。
---------------------------------------------------------------------------

local AREA_WORDS = {
    { '天晶堂', 'norg' }, { 'サンドリア', 'sandoria' }, { 'バストゥーク', 'bastok' },
    { 'ウィンダス', 'windurst' }, { 'ジュノ', 'jeuno' }, { 'ラバオ', 'rabao' }, { 'カザム', 'kazham' }, { 'ノーグ', 'norg' },
}
local HOME = { sandoria = true, bastok = true, windurst = true, jeuno = true }

function fame.reqs(q)
    if q._fame_reqs then return q._fame_reqs end
    local out = {}
    for _, r in ipairs(q.lock_reasons or {}) do
        if r.type == 'fame' then
            local text = r.text_ja or ''
            local area
            for _, w in ipairs(AREA_WORDS) do
                if text:find(w[1] .. 'の名声', 1, true) or text:find(w[1] .. '名声', 1, true) then area = w[2]; break end
            end
            if not area and HOME[q.category] then area = q.category end
            local n = tonumber(text:match('名声ランク(%d+)') or text:match('名声(%d+)'))
            if not n and text:find('名声「ほとんど知っている」', 1, true) then n = 6 end
            if area and n and n >= 1 and n <= 9 then out[#out + 1] = { area = area, level = n } end
        end
    end
    q._fame_reqs = out
    return out
end

-- 覚えた名声（{ area = { level = n, at = '...' } }）で、足りないと分かるか
function fame.unmet(q, known)
    if type(known) ~= 'table' then return false end
    for _, rq in ipairs(fame.reqs(q)) do
        local e = known[rq.area]
        local lv = type(e) == 'table' and tonumber(e.level) or nil
        if lv and lv < rq.level then return true end
    end
    return false
end

return fame
