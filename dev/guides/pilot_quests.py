"""試し書き：三国クエスト10件（手順の文が長かったもの）。出典は各クエストの用語辞典の記事。"""
from common import S, L, T, N, KI, build

CHECKED = '2026-11-14'
G = []

# 帽子屋の宣伝（6575）
qid = 'quest.windurst.035'
bm = 'npc.238.Baren-Moren'
bm_loc = L('ウィンダス水の区', 'H-7')
G.append(build(qid, [
    S('g01', 'talk', 'ウィンダス水の区 南(H-7)の帽子屋のBaren-Morenに話し「帽子屋の新作」を受け取る', None,
      bm_loc, bm, frm=['s01']),
    S('g02', 'talk', '水の区の人に話しかけて新作の帽子を見せる（1人1ポイント）',
      '「帽子屋の新作を見せた。」と出れば1ポイント、そこで話を切ってよい。水の区から出ると最初からやり直し（ホームポイントでの区内移動とログアウトは大丈夫）。後から増えたNPCとウサギは数えない。',
      L('ウィンダス水の区'), None, frm=['s02']),
    S('g03', 'talk', '台詞が変わる8人には最後まで話す（1人で3ポイント分）',
      '南：Honoi-Gomoi(E-7 民家裏の階段の上)・Kenapa-Keppa(J-9)・Bondada(H-7)／北：Kyume-Romeh(F-10)・Tosuka-Porika(G-8)・Clais(G-10)・Pechiru-Mashiru(L-6)・Machitata(L-11)。途中で切ると入らない。Bondadaはほかの10人に見せてから。',
      L('ウィンダス水の区'), None, frm=['s03']),
    S('g04', 'talk', '20ポイント以上ためたらBaren-Morenに話し「やめる」を選んで完了',
      'ポイントで報酬が変わる：20～29で50ギル、30～39で120ギル、40～79で150ギルと風切り帽子、80以上で200ギルと風切り帽子。もう一度は受けられない。',
      bm_loc, bm, frm=['s04']),
], 'https://wiki.ffo.jp/html/6575.html', CHECKED))

# スタンプラリー（6629）
qid = 'quest.bastok.010'
def stamp(key, zone, grid, place, name):
    tid = T('npc.%s.%s' % ({'バストゥーク鉱山区': 234, 'バストゥーク商業区': 235, 'バストゥーク港': 236, '大工房': 237}[zone], name.replace(' ', '_')),
            'npc', name, L(zone, grid))
    return S(key, 'talk', '%s(%s)%sの%sにスタンプを押してもらう' % (zone, grid, place, name),
             '7人は好きな順でよい。' if key == 'g02' else None, L(zone, grid), tid, frm=['s02'])
G.append(build(qid, [
    S('g01', 'talk', 'バストゥーク商業区(J-10)の楽器店のそばのArawnに話してクエストを受ける', None,
      L('バストゥーク商業区', 'J-10'), 'npc.235.Arawn', frm=['s01']),
    stamp('g02', 'バストゥーク鉱山区', 'J-7', ' 地下街封鎖地区', 'Tall Mountain'),
    stamp('g03', 'バストゥーク鉱山区', 'G-8', ' 鉱山側陸橋2F', 'Deadly Spider'),
    stamp('g04', 'バストゥーク商業区', 'E-11', ' 西門', 'Pavel'),
    stamp('g05', 'バストゥーク港', 'J-8', ' 跳ね橋', 'Latifah'),
    stamp('g06', 'バストゥーク港', 'G-5', ' 倉庫下', 'Ehrhard'),
    stamp('g07', '大工房', 'G-8', ' 女神像前', 'Elayne'),
    stamp('g08', '大工房', 'K-9', ' 砲室', 'Romualdo'),
], 'https://wiki.ffo.jp/html/6629.html', CHECKED))

# 工房長の秘密（10715）
qid = 'quest.bastok.065'
hilda = 'npc.236.Hilda'
G.append(build(qid, [
    S('g01', 'talk', '大工房2F(H-8)のシド研究室でCidからクエストを受ける', '名声ランク4以上が必要。',
      L('大工房', 'H-8'), 'npc.237.Cid', frm=['s01']),
    S('g02', 'talk', 'バストゥーク港(E-6)の酒場「蒸気の羊亭」のHildaに話す',
      '次に「ロランベリー874」の用意。競売で買うか、自分で取るかを選ぶ。', L('バストゥーク港', 'E-6'), hilda,
      frm=['s02'], nxt=['a01', 'b01']),
    S('a01', 'gather', '【競売】「ロランベリー874」を競売などで買う', None, None, None,
      frm=['s03'], nxt=['g03'], route='競売'),
    S('b01', 'trade', '【自分で取る】クロウラーの巣MAP[3](I-8)のカゴの???にロランベリーをトレード',
      'Guardian Crawlerが出るまでくり返す。ロランベリーはジュノ上層などで買える。運しだいなので何ダースか用意。',
      L('クロウラーの巣', 'I-8', 3), T('obj.197.???_I-8', 'obj', '???', L('クロウラーの巣', 'I-8', 3)),
      needs=[N('ロランベリー')], frm=['s03'], route='自分で取る'),
    S('b02', 'defeat', 'Guardian Crawlerを倒して「ロランベリー881」を入手', '必ず落とす。',
      L('クロウラーの巣', 'I-8', 3), T('mob.197.Guardian_Crawler', 'mob', 'Guardian Crawler', L('クロウラーの巣', 'I-8', 3)),
      frm=['s03'], route='自分で取る'),
    S('b03', 'trade', 'MAP[3](G-7)のカゴの???に「ロランベリー881」をトレード',
      'Drone Crawlerが出なければ、前の手順（I-8のカゴ）からやり直し。',
      L('クロウラーの巣', 'G-7', 3), T('obj.197.???_G-7', 'obj', '???', L('クロウラーの巣', 'G-7', 3)),
      needs=[N('ロランベリー881')], frm=['s03'], route='自分で取る'),
    S('b04', 'defeat', 'Drone Crawlerを倒して「ロランベリー874」を入手', '落とさなければ前の手順（I-8のカゴ）からやり直し。',
      L('クロウラーの巣', 'G-7', 3), T('mob.197.Drone_Crawler', 'mob', 'Drone Crawler', L('クロウラーの巣', 'G-7', 3)),
      frm=['s03'], nxt=['g03'], route='自分で取る'),
    S('g03', 'trade', 'Hildaに「ロランベリー874」をトレードし「書きかけの手紙」を受け取る', None,
      L('バストゥーク港', 'E-6'), hilda, needs=[N('ロランベリー874')], frm=['s04']),
    S('g04', 'talk', '大工房に戻り、Cidに話して完了', '報酬はラムマント。', L('大工房', 'H-8'), 'npc.237.Cid', frm=['s05']),
], 'https://wiki.ffo.jp/html/10715.html', CHECKED))

# 誓いの剣（8384）
qid = 'quest.sandoria.025'
vem = 'npc.230.Vemalpeau'
well = T('obj.149.Village_Well', 'obj', 'Village Well', L('ダボイ', 'G-9'))
G.append(build(qid, [
    S('g01', 'talk', '南サンドリア(M-7)の民家のVemalpeauに話す', '前のクエスト「小公望」で「受ける」を選ぶと始まっている。',
      L('南サンドリア', 'M-7'), vem, frm=['s01']),
    S('g02', 'talk', '南サンドリア(K-6)の酒場のNajjarに話す', None,
      L('南サンドリア', 'K-6'), T('npc.230.Najjar', 'npc', 'Najjar', L('南サンドリア', 'K-6')), frm=['s01']),
    S('g03', 'talk', '南サンドリア(B-6)のカッファル伯爵邸のUllasaに話す', None,
      L('南サンドリア', 'B-6'), T('npc.230.Ullasa', 'npc', 'Ullasa', L('南サンドリア', 'B-6')), frm=['s01']),
    S('g04', 'gather', 'ズヴァール城のTreasure Cofferを開けて「ミックの絵筆」を入手',
      'ナイト以外でも取れる。ただし、そのジョブのAFがズヴァール城外郭で出る状態ならAFのほうが出る。',
      L('ズヴァール城'), 'npc.Treasure_Coffer', frm=['s02']),
    S('g05', 'talk', '南サンドリアのVemalpeauにもう一度話す', None, L('南サンドリア', 'M-7'), vem, frm=['s03']),
    S('g06', 'examine', 'その家の2階で、壁の額縁の裏を調べて「不思議な紙」を入手', None,
      L('南サンドリア', 'M-7'), None, frm=['s03']),
    S('g07', 'talk', '南サンドリア(K-7)のExorocheに話す', 'ダボイの井戸水で文字が読めると教えてもらえる。',
      L('南サンドリア', 'K-7'), 'npc.230.Exoroche', frm=['s03']),
    S('g08', 'defeat', 'ダボイ(G-9)のVillage Wellを調べ、出てきたNM2体を倒す',
      'One-eyed Gwajboj（ナイト）とThree-eyed Prozpuz（狩人）。どちらも強い。スリプル・リポーズ・サイレスが効かず、近くのオークがリンクするので先に片付ける。Prozpuzから倒すとよい（イーグルアイに注意）。',
      L('ダボイ', 'G-9'), T('mob.149.One-eyed_Gwajboj', 'mob', 'One-eyed Gwajboj', L('ダボイ', 'G-9')), frm=['s04']),
    S('g09', 'trade', '「井戸のオモリ」をVillage Wellにトレードし「騎士の告白文」を入手',
      'One-eyed Gwajbojが落とす。トレードの前に井戸を調べると、NMがまた出ることがある。', L('ダボイ', 'G-9'), well,
      needs=[N('井戸のオモリ')], frm=['s04']),
    S('g10', 'talk', '北サンドリアのAilbecheに話す', None, L('北サンドリア'), 'npc.231.Ailbeche', frm=['s05']),
    S('g11', 'go', 'ジャグナー森林(E-6)の池のほとりへ行くとイベント', None, L('ジャグナー森林', 'E-6'), None, frm=['s05']),
    S('g12', 'examine', 'ドラギーユ城のDoor:Prince Royal\'s Rmを調べてイベント、完了', '報酬はガラントサーコート。',
      L('ドラギーユ城'), 'obj.233.Door_Prince_Royals_Rm', frm=['s06']),
], 'https://wiki.ffo.jp/html/8384.html', CHECKED))

# 芸術家によるラプソディ（5988）
qid = 'quest.windurst.041'
ang = 'npc.238.Angelica'
G.append(build(qid, [
    S('g01', 'talk', 'ウィンダス水の区のララブのしっぽ亭2階のAngelicaに話してクエストを受ける',
      '今のジョブの指定装備を着ていないときに受けられる。', L('ウィンダス水の区'), ang, frm=['s01']),
    S('g02', 'talk', 'Angelicaにもう2回話し、足りない装備を聞く', '聞かずに着替えて話すと失敗になる。',
      L('ウィンダス水の区'), ang, frm=['s02']),
    S('g03', 'gather', '言われた胴装備を買って着る',
      '戦ナ暗竜コ剣はブロンズハーネス、忍侍は拳法着（ウィンダス港(H-7)のRyan）。モ吟青はローブ、シ獣狩踊はレザーベスト、白黒赤召か学風はチュニック（ウィンダス港(H-9)の仕立のグルナマグルナ）。',
      L('ウィンダス港'), None, frm=['s03']),
    S('g04', 'talk', 'すぐにAngelicaに話して完了', '時間を置きすぎると失敗。受け直すにはエリアチェンジが必要。',
      L('ウィンダス水の区'), ang, frm=['s04']),
], 'https://wiki.ffo.jp/html/5988.html', CHECKED))

# 侯国の栄光（8386）
qid = 'quest.windurst.010'
nanaa = 'npc.241.Nanaa_Mihgo'
hag = 'npc.249.Hagain'
def smoke(key, n, spot, where, flee, extra=None):
    grid = spot.split(' ')[0]
    text = '%s。ボムが%s。' % (where, flee)
    if extra:
        text = extra + text
    tid = 'obj.200.???_%s%s' % (grid, '_E' if n == 4 else '')
    return S(key, 'examine', 'ガルレージュ要塞(%s)の???を調べて、いぶし香を使う（%d/7）' % (spot, n), text,
             L('ガルレージュ要塞', grid), T(tid, 'obj', '???', L('ガルレージュ要塞', grid)),
             needs=[KI('ボムいぶし香')] if n == 1 else None, frm=['s04'])
G.append(build(qid, [
    S('g01', 'talk', 'シーフでNanaa Mihgoに話し「泥棒ミスラのメモ」を受け取る',
      'YatnielとHagainの依頼はどちらから進めてもよい。', L('ウィンダス森の区'), nanaa, frm=['s01']),
    S('g02', 'talk', 'ジュノ下層(G-10)「宝石店のクシャマ」前のYatnielに話して依頼を受ける', None,
      L('ジュノ下層', 'G-10'), 'npc.245.Yatniel', frm=['s02']),
    S('g03', 'trade', 'Yatnielに「震天雷」を4個トレード', None, L('ジュノ下層', 'G-10'), 'npc.245.Yatniel',
      needs=[N('震天雷', 4)], frm=['s02']),
    S('g04', 'talk', 'マウラ(I-8)の宿屋「船乗りの宿」のHagainに話し「ボムいぶし香」を受け取る', None,
      L('マウラ', 'I-8'), hag, frm=['s03']),
    smoke('g05', 1, 'I-9', '第一魔防門の前のマップ。天井に穴がある所', '西へ逃げる',
          '7か所を順番に回る。途中でエリアチェンジするとやり直し。???は少し離れてタゲってから近づき、主観にしてロックして調べるとうまくいく。'),
    smoke('g06', 2, 'H-9', '第一魔防門の前のマップ', '南へ逃げる'),
    smoke('g07', 3, 'F-9 十字路の西側', '第一魔防門の先のマップ。門は4人以上か「程よい重さの石」で越える', '東へ逃げる'),
    smoke('g08', 4, 'F-9 十字路の東側', '第一魔防門の先のマップ', '東へ逃げる'),
    smoke('g09', 5, 'G-8 四角いエリアの南端', '第一魔防門の先のマップ', '北へ逃げる'),
    smoke('g10', 6, 'G-7 四角いエリアの北端', '第一魔防門の先のマップ', '東へ逃げる'),
    S('g11', 'examine', 'ガルレージュ要塞(I-6)北東の行き止まりの???を調べて、いぶし香を使う（7/7）',
      'ボムのNM「Chandelier」が出る。', L('ガルレージュ要塞', 'I-6'),
      T('obj.200.???_I-6', 'obj', '???', L('ガルレージュ要塞', 'I-6')), frm=['s04']),
    S('g12', 'defeat', 'Chandelierを倒して「シャンデリアの灰」を入手',
      '戦いを始めるときの条件を満たして勝たないと灰が出ない。',
      L('ガルレージュ要塞', 'I-6'), T('mob.200.Chandelier', 'mob', 'Chandelier', L('ガルレージュ要塞', 'I-6')), frm=['s05']),
    S('g13', 'trade', 'マウラのHagainに「シャンデリアの灰」をトレード', None, L('マウラ', 'I-8'), hag,
      needs=[N('シャンデリアの灰')], frm=['s06']),
    S('g14', 'talk', 'Nanaa Mihgoに話す', '選択肢の正解は「空白」。間違えても進む。', L('ウィンダス森の区'), nanaa, frm=['s07']),
    S('g15', 'trade', 'ラテーヌ高原(H-10)南西の崖下の???に「つるはし」をトレードして完了',
      'オルデール鍾乳洞を抜けた先。Morbolgerが出る部屋の脇を過ぎ、水の祈りの石碑の少し手前。Proto-Waypointが近い。報酬はローグプーレーヌ。',
      L('ラテーヌ高原', 'H-10'), T('obj.102.???_H-10', 'obj', '???', L('ラテーヌ高原', 'H-10')),
      needs=[N('つるはし')], frm=['s08']),
], 'https://wiki.ffo.jp/html/8386.html', CHECKED))

# 競売所の手紙（6577）
qid = 'quest.windurst.068'
amb = 'npc.239.Ambrosius'
G.append(build(qid, [
    S('g01', 'talk', 'ウィンダス石の区(J-12)の競売所前のAmbrosiusに話してクエストを受ける',
      '手紙は4種類。全部そろわなくても渡せる。', L('ウィンダス石の区', 'J-12'), amb, frm=['s01']),
    S('g02', 'defeat', '東サルタバルタのSavanna Rarabを倒して「泥だらけの請求書」を入手', None,
      L('東サルタバルタ'), T('mob.116.Savanna_Rarab', 'mob', 'Savanna Rarab', L('東サルタバルタ'), moves=True), frm=['s02']),
    S('g03', 'defeat', '西サルタバルタのSavanna Rarabを倒して「破れたラブレター」を入手', None,
      L('西サルタバルタ'), T('mob.115.Savanna_Rarab', 'mob', 'Savanna Rarab', L('西サルタバルタ'), moves=True), frm=['s02']),
    S('g04', 'defeat', 'タロンギ大峡谷のCanyon Rarabを倒して「怪しいカード」と「しめった封筒」を入手',
      'ヒントに出るSavanna Dhalmelは今はいないので無視してよい。', L('タロンギ大峡谷'),
      T('mob.117.Canyon_Rarab', 'mob', 'Canyon Rarab', L('タロンギ大峡谷'), moves=True), frm=['s02']),
    S('g05', 'trade', 'Ambrosiusに手紙をまとめてトレードして完了',
      '同時に渡した数で報酬が変わる：1通50ギル・2通150ギル・3通250ギル・4通500ギル。くり返し受けられる。',
      L('ウィンダス石の区', 'J-12'), amb, frm=['s03']),
], 'https://wiki.ffo.jp/html/6577.html', CHECKED))

# 力と覚悟（10167）
qid = 'quest.bastok.013'
sham = 'npc.235.Shamarhaan'
G.append(build(qid, [
    S('g01', 'talk', 'からくり士Lv66以上で商業区(F-9)のShamarhaanに話してクエストを受ける',
      'アトルガンクエスト「「何もできない」だなんて言わせない」を済ませておく。', L('バストゥーク商業区', 'F-9'), sham, frm=['s01']),
    S('g02', 'defeat', 'からくり士タイプのトロールを倒して「偉大な絡繰士の証」を入手',
      '一定Lv以上のトロール。Troll Stoneworker（モンク）から出た報告もある。', None, None, frm=['s02']),
    S('g03', 'trade', 'Shamarhaanに「偉大な絡繰士の証」をトレードしてナバゴ処刑場へ移る', None,
      L('バストゥーク商業区', 'F-9'), sham, needs=[N('偉大な絡繰士の証')], frm=['s03']),
    S('g04', 'trade', 'Decorative Bronze Gateに証をトレードしてBFに入る',
      '1人・サポートジョブ無効・10分まで。強化とTPは持ち込めない。',
      L('ナバゴ処刑場'), T('obj.ナバゴ処刑場.Decorative_Bronze_Gate', 'obj', 'Decorative Bronze Gate', L('ナバゴ処刑場')),
      needs=[N('偉大な絡繰士の証')], frm=['s04']),
    S('g05', 'fight', 'ShamarhaanのHPを7割以上減らして勝ち、完了',
      'オートマトンValkengはスタンやパライズを使うので万能薬などを持っていく。負けても同じ証で3回まで挑める。',
      L('ナバゴ処刑場'), None, frm=['s04']),
], 'https://wiki.ffo.jp/html/10167.html', CHECKED))

# 暗黒の虜囚（8387）
qid = 'quest.bastok.066'
G.append(build(qid, [
    S('g01', 'talk', 'Lv50以上の暗黒騎士で、大工房のシド研究室のCidに話す', '前のクエスト「黒の伝承」を済ませておく。',
      L('大工房', 'H-8'), 'npc.237.Cid', frm=['s01']),
    S('g02', 'go', 'オルデール鍾乳洞に入ってイベント', 'サバイバルガイドあり。', L('オルデール鍾乳洞'), None, frm=['s02']),
    S('g03', 'trade', 'map[4](I-8 テンキー1)の???に「ダークインゴット」をトレード',
      'サバイバルガイドから来たら東へ進み、南へ下りる。', L('オルデール鍾乳洞', 'I-8', 4),
      T('obj.193.???_I-8', 'obj', '???', L('オルデール鍾乳洞', 'I-8', 4)), needs=[N('ダークインゴット')], frm=['s03']),
    S('g04', 'defeat', "出てきたGerwitz's Axeを倒して「ゲーヴィッツの斧」を入手",
      '3体の中でいちばん強い。命中が高く、TPを吸う。空蝉があると安全。', L('オルデール鍾乳洞', 'I-8', 4),
      T("mob.193.Gerwitzs_Axe", 'mob', "Gerwitz's Axe", L('オルデール鍾乳洞', 'I-8', 4)), frm=['s03']),
    S('g05', 'go', 'すぐ西の(H-9)からmap[1]へ出て、南東の穴(H-12)から落ちる',
      '落ちるとmap[4]の(H-12)に出る。', L('オルデール鍾乳洞', 'H-9', 4), None, frm=['s04']),
    S('g05b', 'go', 'map[4]の(I-11)から東の階段を上ってmap[2]へ', None, L('オルデール鍾乳洞', 'I-11', 4), None, frm=['s04']),
    S('g06', 'trade', 'map[2](H-8)の???に「ゲーヴィッツの斧」をトレード', None, L('オルデール鍾乳洞', 'H-8', 2),
      T('obj.193.???_H-8', 'obj', '???', L('オルデール鍾乳洞', 'H-8', 2)), needs=[N('ゲーヴィッツの斧')], frm=['s04']),
    S('g07', 'defeat', "出てきたGerwitz's Swordを倒して「ゲーヴィッツの剣」を入手",
      '1体目より弱い。フェイスがついて来ているか確かめてから戦う。', L('オルデール鍾乳洞', 'H-8', 2),
      T("mob.193.Gerwitzs_Sword", 'mob', "Gerwitz's Sword", L('オルデール鍾乳洞', 'H-8', 2)), frm=['s04']),
    S('g08', 'trade', '通路を進み、(H-10)の部屋の???に「ゲーヴィッツの剣」をトレード', 'Morbolgerが出る部屋。',
      L('オルデール鍾乳洞', 'H-10'), T('obj.193.???_H-10', 'obj', '???', L('オルデール鍾乳洞', 'H-10')),
      needs=[N('ゲーヴィッツの剣')], frm=['s05']),
    S('g09', 'defeat', "出てきたGerwitz's Soulを倒す",
      'サイレスが効かず、アイススパイクの麻痺がやっかい。この1体だけ倒せば全員進む。', L('オルデール鍾乳洞', 'H-10'),
      T("mob.193.Gerwitzs_Soul", 'mob', "Gerwitz's Soul", L('オルデール鍾乳洞', 'H-10')), frm=['s05']),
    S('g10', 'go', '(G-10)から歩いて谷底（古代ジラートの石碑）へ出て、報酬を受け取る',
      '外に出るときにイベントがあり、その場で完了。デジョンなどで出るとイベントが起きない。最初の入口へ歩いて出てしまっても、あとで正しい場所へ行けば受け取れる。報酬はカオスソルレット。',
      L('オルデール鍾乳洞', 'G-10'), None, frm=['s06']),
], 'https://wiki.ffo.jp/html/8387.html', CHECKED))

# 知識の守り手（4439）
qid = 'quest.windurst.039'
fur = T('npc.238.Furakku-Norakku', 'npc', 'Furakku-Norakku', L('ウィンダス水の区', 'G-8'))
G.append(build(qid, [
    S('g01', 'talk', 'ウィンダス水の区 北(G-8)の目の院でTosuka-Porikaからクエストを受ける',
      '「古文書の解読」から続けて受けるときは、いったんエリアチェンジ。', L('ウィンダス水の区', 'G-8'), 'npc.238.Tosuka-Porika', frm=['s01']),
    S('g02', 'talk', 'すぐそばのカウンターの中のFurakku-Norakkuに話し「魔法図書館催促状」を受け取る', None,
      L('ウィンダス水の区', 'G-8'), fur, frm=['s02']),
    S('g03', 'talk', 'ウィンダス水の区 北(F-10)の2FにいるOrnに話す', None,
      L('ウィンダス水の区', 'F-10'), T('npc.238.Orn', 'npc', 'Orn', L('ウィンダス水の区', 'F-10')), frm=['s03']),
    S('g04', 'gather', '「獣人銀貨」を手に入れる',
      'Yagudo Mendicant・Persecutor・Piperが落とす（ギデアス以外で倒しても出る）。', None, None, frm=['s04']),
    S('g05', 'trade', 'ギデアス(G-6)の宝物庫のQuu Bokyeに獣人銀貨を渡し「みんなの美術」を受け取る',
      '地下のマップ。先に話しかけてから交換する。',
      L('ギデアス', 'G-6'), 'npc.145.Quu_Bokye', needs=[N('獣人銀貨')], frm=['s04']),
    S('g06', 'talk', 'Furakku-Norakkuに話して完了', '報酬は1,500ギル。', L('ウィンダス水の区', 'G-8'), fur, frm=['s05']),
], 'https://wiki.ffo.jp/html/4439.html', CHECKED))
