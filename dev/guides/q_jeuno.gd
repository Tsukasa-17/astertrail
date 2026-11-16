# ジュノのクエスト（0.1.70〜）。用語辞典の各記事を読んで書き直したもの。番号は基礎シート「クエスト一覧」の行 − 89。
# 座標は基礎シートの BG Wiki 照合（BG Wiki と FFXIclopedia が一致したもの）に合わせた。名声は BG Wiki。

@ quest.jeuno.001 https://wiki.ffo.jp/html/25916.html
Q VW Op. #115: Valkurm Duster | VW作戦第103計画バルクルム砂丘 | no |
LK quest:クエスト「新たなる脅威」をコンプリート（自動で受ける）
LK condition:「しばしの休息」で六芒星の白色のジェイドVIを手に入れている
g01 go - | クエスト「新たなる脅威」を終えると自動で受ける | 進めるには「しばしの休息」で六芒星の白色のジェイドVIを手に入れておく。メインシナリオには関係ない。
g02 fight - | 六芒星の白色のジェイドVIを持って、バルクルム砂丘のヴォイドウォーカー「Ig-Alima」に勝って完了 | 勝つと自動で完了する。 | @バルクルム砂丘 | T mob.103.Ig-Alima = mob:Ig-Alima@バルクルム砂丘

@ quest.jeuno.002 https://wiki.ffo.jp/html/25917.html
Q VW Op. #118: Buburimu Squall | VW作戦第118計画ブブリム半島 | no |
LK quest:クエスト「新たなる脅威」をコンプリート（自動で受ける）
LK condition:「しばしの休息」で六芒星の白色のジェイドVIを手に入れている
g01 go - | クエスト「新たなる脅威」を終えると自動で受ける | 進めるには「しばしの休息」で六芒星の白色のジェイドVIを手に入れておく。メインシナリオには関係ない。
g02 fight - | 六芒星の白色のジェイドVIを持って、ブブリム半島のヴォイドウォーカー「Botulus Rex」に勝って完了 | 勝つと自動で完了する。 | @ブブリム半島 | T mob.118.Botulus_Rex = mob:Botulus Rex@ブブリム半島

@ quest.jeuno.004 https://wiki.ffo.jp/html/15801.html
Q Dancer Attire | ダンサー装束 | - | T npc.244.Olgald = npc:Olgald@ジュノ上層 G-7
RW item:ダンサーティアラ
RW item:ダンサーバングル
RW item:ダンサートーシュー
LK quest:踊り子AFクエスト「追想のポリフォニー」をコンプリート
g01 talk - | ジュノ上層(G-7)の踊り子のガルカOlgaldに話して受ける | オファーリストには載らない。 | @ジュノ上層 G-7 | T npc.244.Olgald
g02 talk - | バストゥーク商業区(J-9)のMatthiasに話し、ほしい部位を選ぶ | 選んだ部位はできあがるまで変えられない。 | @バストゥーク商業区 J-9 | T npc.235.Matthias = npc:Matthias@バストゥーク商業区 J-9
g03 trade - | 選んだ部位の材料3つをMatthiasにトレードする | 頭：アトルガン絹布・ウルフフェルト・シルバーブロケード／両手：カラクール織物・虹布・レインボービロード／両足：ワモーラクロス・モブリン織物・ゴールドブロケード。どれも裁縫で作れる。 | @バストゥーク商業区 J-9 | T npc.235.Matthias
g04 talk - | ヴァナ時間の0時を過ぎてから、エリアを出入りしてMatthiasに話し、その部位を受け取る | 待つだけ・ログアウトだけでは受け取れない（モグハウスに出入りでよい）。3部位なら3回くり返す。 | @バストゥーク商業区 J-9 | T npc.235.Matthias | W ヴァナ時間の0時を過ぎてから

@ quest.jeuno.005 https://wiki.ffo.jp/html/5990.html
Q Regaining Trust | ふたりの想い | no | T npc.244.Luto_Mewrilah = npc:Luto Mewrilah@ジュノ上層 G-8
RW other:フェローのレベル上限が60になる
RW title:心の糧となりし者
LK condition:フェローがLv51以上、親密度55以上
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/Regaining_Trust;Luto Mewrilah の座標 G-8（用語辞典は G-9）
g01 talk - | ジュノ上層(G-8)の民家のLuto Mewrilahに話して受ける | フェローLv51以上・親密度55以上が必要。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g02 talk - | ジュノ上層(G-10)モンブロー医院のMonberauxに話す | - | @ジュノ上層 G-10 | T npc.244.Monberaux = npc:Monberaux@ジュノ上層 G-10
g03 talk - | もう一度Luto Mewrilahに話す | - | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g04 fight - | クフィム島(E-6)の洞窟のGiant Footprintを調べ、巨人族NM「Ingaevon」を倒す | ベヒーモスの縄張りへ向かう洞窟の中。HP約2600、Lv50台後半ならソロでも倒せる。 | @クフィム島 E-6 | T mob.126.Ingaevon = mob:Ingaevon@クフィム島 E-6
g05 talk - | 戦いのあと、その場でフェローに話す | - | @クフィム島 E-6
g06 talk - | ジュノ上層のLuto Mewrilahに話す | - | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g07 talk - | モンブロー医院のMonberauxに話して完了 | フェローのレベル上限が60になる。 | @ジュノ上層 G-10 | T npc.244.Monberaux

@ quest.jeuno.006 https://wiki.ffo.jp/html/4381.html
Q The Kind Cardian | やさしいカカシ | no | T npc.244.Monberaux
RW item:グリーンケープ
RW title:しあわせ宅配人
LK fame:名声ランク4以上
LK quest:クエスト「カカシがいない」をコンプリート
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/The_Kind_Cardian;Apururu の座標 H-9
g01 talk - | ジュノ上層(G-10)モンブロー医院のMonberauxに話して受ける | 依頼者のPanta-Puttaは、実際にはジュノ下層(H-10)の商家にいる。 | @ジュノ上層 G-10 | T npc.244.Monberaux
g02 talk - | ウィンダス森の区(H-9)手の院のApururuに話し、「カップ10のカード」を頼まれる | ウィンダスミッションでApururuが関わる後半を進めている間は、ミッションの話しかせず先へ進めない。 | @ウィンダス森の区 H-9 | T npc.241.Apururu = npc:Apururu@ウィンダス森の区 H-9
g03 gather - | 「カップ10のカード」を用意する | Rare。入手先は記事に書いていない。 | N カップ10のカード*1
g04 trade - | Apururuに「カップ10のカード」をトレードする | これを渡すまで、手の院の連続クエスト（NEWカーディアンくんの誕生など）は出ない。 | @ウィンダス森の区 H-9 | T npc.241.Apururu | N カップ10のカード*1
g05 talk - | ジュノ下層(H-10)の商家のPanta-Puttaに話して完了 | グリーンケープをもらえる。 | @ジュノ下層 H-10 | T npc.245.Panta-Putta = npc:Panta-Putta@ジュノ下層 H-10

@ quest.jeuno.007 https://wiki.ffo.jp/html/5937.html
Q Chameleon Capers | カメレオンのまやかしを | no | T npc.244.Luto_Mewrilah
RW key_item:変装グッズ
RW item:作戦書：防戦／作戦書：力戦／作戦書：持久戦 から1つ
LK condition:フェローとの親密度65以上
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/Chameleon_Capers;Gelzerio の座標 H-7
g01 talk - | ジュノ上層(G-8)のLuto Mewrilahに話して受ける | 親密度65以上が必要。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g02 talk - | ル・ルデの庭(H-7)大公宮2階バルコニーのMuhohoに話を聞く | 清めの薬を買ってきてほしいと頼まれる。 | @ル・ルデの庭 H-7 | T npc.243.Muhoho = npc:Muhoho@ル・ルデの庭 H-7
g03 talk - | バストゥーク鉱山区(H-7)ボイツの何でも屋のGelzerioに話す | 売り切れで、仕入れ先を教えてもらえる。 | @バストゥーク鉱山区 H-7 | T npc.234.Gelzerio = npc:Gelzerio@バストゥーク鉱山区 H-7
g04 talk - | ウィンダス水の区(F-10)ララブのしっぽ亭のChamamaから清めの薬を受け取る | 北側の地図。 | @ウィンダス水の区 F-10 #1 | T npc.238.Chamama | E BG Wiki;https://www.bg-wiki.com/ffxi/Chameleon_Capers;Chamama はウィンダス水の区の北の地図
g05 talk - | ジュノ上層のLuto Mewrilahに話す | デルクフの塔へ行くよう勧められる。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g06 examine - | デルクフの塔下層の???(J-9)、(I-5)の???、(J-9)の池の???の順に調べる | シグナルパールを持って行く（フェローに話すともう一つもらえる）。 | @デルクフの塔下層 J-9 | T obj.184.???_J-9 = obj:???@デルクフの塔下層 J-9 | E BG Wiki;https://www.bg-wiki.com/ffxi/Chameleon_Capers;場所はデルクフの塔下層、調べる順と池の???
g07 fight - | 出てくるマジックポット族NM「Illusory Pot」をフェローと倒す | Lv40台前半でも同じレベルのフェローと倒せるが手ごわい。経験値はない。 | @デルクフの塔下層 J-9 | T mob.184.Illusory_Pot = mob:Illusory Pot@デルクフの塔下層 J-9
g08 examine - | フェローに話したあと、もう一度???を調べて完了 | 変装グッズと、作戦書（防戦・力戦・持久戦）から1つをもらえる。作戦書はランデブーポイントで呼ぶとフェローが覚える。 | @デルクフの塔下層 J-9 | T obj.184.???_J-9

@ quest.jeuno.008 https://wiki.ffo.jp/html/9151.html
Q Candle-making | キャンドルの原料 | no | T npc.244.Rouliette = npc:Rouliette@ジュノ上層 H-9
RW key_item:聖なるキャンドル
RW title:アルタナ教信者
LK quest:クエスト「亡き夫へのキャンドル」を受けていること
g01 talk - | ジュノ上層(H-9)女神聖堂のRoulietteに話して受ける | 「亡き夫へのキャンドル」を受けている間だけ。 | @ジュノ上層 H-9 | T npc.244.Rouliette
g02 gather - | 「ラノリン」を1個用意する | ラテーヌ高原のBattering Ram（雄羊）や、アビセア-ラテーヌの雄羊が落とす。ルフェーゼ野のTavnazian Ramも落とすがLv82〜84と高い。 | N ラノリン*1
g03 trade - | Roulietteに「ラノリン」をトレードして完了 | だいじなもの「聖なるキャンドル」をもらえる。 | @ジュノ上層 H-9 | T npc.244.Rouliette | N ラノリン*1

@ quest.jeuno.009 https://wiki.ffo.jp/html/9139.html
Q Crest of Davoi | ダボイ村の紋章 | no | T npc.244.Baudin
RW key_item:ダボイ村紋章
LK condition:三国ミッション「魔晶石を奪え」でAldoのイベントを済ませた後（銀の鈴を受け取った後）
g01 talk - | ジュノ上層(G-8)のBaudinに話して受ける | 「魔晶石を奪え」でAldoから銀の鈴を受け取ったあとに出る。 | @ジュノ上層 G-8 | T npc.244.Baudin
g02 gather - | 「クァールの肉」を1個用意する | - | N クァールの肉*1
g03 trade - | Baudinに「クァールの肉」をトレードして完了 | だいじなもの「ダボイ村紋章」。「魔晶石を奪え」を進めるのに必要。 | @ジュノ上層 G-8 | T npc.244.Baudin | N クァールの肉*1

@ quest.jeuno.010 https://wiki.ffo.jp/html/11566.html
Q A Clock Most Delicate | デリケートな時計塔 | no | T npc.244.Galmut = npc:Galmut@ジュノ上層 F-7
RW gil:1200ギル
RW item:機工士の軍手
RW title:街一番の油売り
LK fame:名声ランク5以上
LK condition:工房橋(G-7)のColletと話してイベントを見てから
g01 talk - | ジュノ上層(G-7)工房橋のColletに話してイベントを見る | 踊り子の一団の近くの女の子。名声ランク5以上が必要。 | @ジュノ上層 G-7 | T npc.244.Collet = npc:Collet@ジュノ上層 G-7
g02 talk - | ジュノ上層(F-7)の民家のGalmutに話して受ける | 「時計塔の油」を頼まれる。 | @ジュノ上層 F-7 | T npc.244.Galmut
g03 talk - | ジュノ下層(J-7)天晶堂のGarnevに話す | 取引を持ちかけられる（クエスト「天晶堂での取引」）。 | @ジュノ下層 J-7 | T npc.245.Garnev = npc:Garnev@ジュノ下層 J-7
g04 trade - | Garnevに「オークの黄金マスク」をトレードし、「時計塔の油」をもらう | Orcish TrooperやOrcish Overlordなど一部のオークが落とす。 | @ジュノ下層 J-7 | T npc.245.Garnev | N オークの黄金マスク*1
g05 talk - | Galmutに話して完了 | 1200ギルと機工士の軍手。 | @ジュノ上層 F-7 | T npc.244.Galmut | K 時計塔の油

@ quest.jeuno.011 https://wiki.ffo.jp/html/2252.html
Q Borghertz's Sneaky Hands | ボルグヘルツの失われた魔手 ＜ シーフ ＞ | no | T npc.244.Guslam = npc:Guslam@ジュノ上層 H-8
RW item:ローグアームレット
XS 用語辞典;https://wiki.ffo.jp/html/2383.html;報酬「ローグアームレット」は用語辞典で確認
LK quest:シーフのAF連続クエスト第二弾をオファー中かコンプリート
LK condition:同時に複数のジョブでは受けられない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Sneaky_Hands;初回は店内のDeadly Minnowに話してからYin Pocanakhuへ、Torchはズヴァール城外郭の最初の地図
g01 talk - | シーフで、ジュノ上層(H-8)防具屋「不朽の盾」のGuslamに話して受ける | 他のジョブの魔手クエストを途中のままだと受けられない。 | @ジュノ上層 H-8 | T npc.244.Guslam
g02 examine - | 修道窟のTreasure Cofferを開け、だいじなもの「古びた小手」をもらう | カギは「獣人集落の宝のカギ」（修道窟の敵が落とす。星唄の煌めき【二奏】があれば三国のCurio Vendor Moogleで買える）。開けるときのジョブは自由だが、他のジョブでAF3連続を終えてAF防具が出る状態ならシーフで開ける。 | @修道窟 | N 獣人集落の宝のカギ*1 | K 古びた小手
g03 talk - | ジュノ上層のGuslamに話す | 直せないと言われる。 | @ジュノ上層 H-8 | T npc.244.Guslam
g04 talk - | 【初めての魔手クエストのときだけ】不朽の盾のDeadly Minnowに話してから、ジュノ下層(J-8)天晶堂のYin Pocanakhuに話し、1000ギルを払う | 一度でも魔手クエストを終えていればこの手順はない。 | @ジュノ下層 J-8 | T npc.245.Yin_Pocanakhu | E BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Sneaky_Hands;先に Deadly Minnow に話す
g05 examine - | ジュノ港(H-8)免税店前の木箱のあたりの???を調べる | ボルグヘルツの霊に「闇の炎」を頼まれる。 | @ジュノ港 H-8 | T obj.246.???_H-8 = obj:???@ジュノ港 H-8
g06 fight - | ズヴァール城外郭MAP[1](F-8)のTorchを調べ、ボムNM「Dark Spark」を倒す | 自爆されてもよい。シーフでなくてよい。 | @ズヴァール城外郭 F-8 #1 | T mob.161.Dark_Spark = mob:Dark Spark@ズヴァール城外郭 F-8 #1
g07 examine - | もう一度Torchを調べ、だいじなもの「闇の炎」をもらう | - | @ズヴァール城外郭 F-8 #1 | T obj.161.Torch_F-8 = obj:Torch~@ズヴァール城外郭 F-8 #1 | K 闇の炎
g08 examine - | ジュノ港(H-8)の???を調べて完了 | ローグアームレットをもらう。 | @ジュノ港 H-8 | T obj.246.???_H-8 | K 闇の炎

@ quest.jeuno.012 https://wiki.ffo.jp/html/2252.html
Q Borghertz's Stalwart Hands | ボルグヘルツの失われた魔手 ＜ ナイト ＞ | no | T npc.244.Guslam = npc:Guslam@ジュノ上層 H-8
RW item:ガラントガントレ
XS 用語辞典;https://wiki.ffo.jp/html/3063.html;報酬「ガラントガントレ」は用語辞典で確認
LK quest:ナイトのAF連続クエスト第二弾をオファー中かコンプリート
LK condition:同時に複数のジョブでは受けられない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Stalwart_Hands;初回は店内のDeadly Minnowに話してからYin Pocanakhuへ、Torchはズヴァール城外郭の最初の地図
g01 talk - | ナイトで、ジュノ上層(H-8)防具屋「不朽の盾」のGuslamに話して受ける | 他のジョブの魔手クエストを途中のままだと受けられない。 | @ジュノ上層 H-8 | T npc.244.Guslam
g02 examine - | エルディーム古墳のTreasure Cofferを開け、だいじなもの「古びた小手」をもらう | カギは「古墳の宝のカギ」（エルディーム古墳の敵が落とす。星唄の煌めき【二奏】があれば三国のCurio Vendor Moogleで買える）。開けるときのジョブは自由だが、他のジョブでAF3連続を終えてAF防具が出る状態ならナイトで開ける。 | @エルディーム古墳 | N 古墳の宝のカギ*1 | K 古びた小手
g03 talk - | ジュノ上層のGuslamに話す | 直せないと言われる。 | @ジュノ上層 H-8 | T npc.244.Guslam
g04 talk - | 【初めての魔手クエストのときだけ】不朽の盾のDeadly Minnowに話してから、ジュノ下層(J-8)天晶堂のYin Pocanakhuに話し、1000ギルを払う | 一度でも魔手クエストを終えていればこの手順はない。 | @ジュノ下層 J-8 | T npc.245.Yin_Pocanakhu | E BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Stalwart_Hands;先に Deadly Minnow に話す
g05 examine - | ジュノ港(H-8)免税店前の木箱のあたりの???を調べる | ボルグヘルツの霊に「闇の炎」を頼まれる。 | @ジュノ港 H-8 | T obj.246.???_H-8 = obj:???@ジュノ港 H-8
g06 fight - | ズヴァール城外郭MAP[1](F-8)のTorchを調べ、ボムNM「Dark Spark」を倒す | 自爆されてもよい。ナイトでなくてよい。 | @ズヴァール城外郭 F-8 #1 | T mob.161.Dark_Spark = mob:Dark Spark@ズヴァール城外郭 F-8 #1
g07 examine - | もう一度Torchを調べ、だいじなもの「闇の炎」をもらう | - | @ズヴァール城外郭 F-8 #1 | T obj.161.Torch_F-8 = obj:Torch~@ズヴァール城外郭 F-8 #1 | K 闇の炎
g08 examine - | ジュノ港(H-8)の???を調べて完了 | ガラントガントレをもらう。 | @ジュノ港 H-8 | T obj.246.???_H-8 | K 闇の炎

@ quest.jeuno.013 https://wiki.ffo.jp/html/2252.html
Q Borghertz's Striking Hands | ボルグヘルツの失われた魔手 ＜ モンク ＞ | no | T npc.244.Guslam = npc:Guslam@ジュノ上層 H-8
RW item:テンプルグローブ
XS 用語辞典;https://wiki.ffo.jp/html/7459.html;報酬「テンプルグローブ」は用語辞典で確認
LK quest:モンクのAF連続クエスト第二弾をオファー中かコンプリート
LK condition:同時に複数のジョブでは受けられない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Striking_Hands;初回は店内のDeadly Minnowに話してからYin Pocanakhuへ、Torchはズヴァール城外郭の最初の地図
g01 talk - | モンクで、ジュノ上層(H-8)防具屋「不朽の盾」のGuslamに話して受ける | 他のジョブの魔手クエストを途中のままだと受けられない。 | @ジュノ上層 H-8 | T npc.244.Guslam
g02 examine - | クロウラーの巣のTreasure Cofferを開け、だいじなもの「古びた小手」をもらう | カギは「蟲穴の宝のカギ」（クロウラーの巣の敵が落とす。星唄の煌めき【二奏】があれば三国のCurio Vendor Moogleで買える）。開けるときのジョブは自由だが、他のジョブでAF3連続を終えてAF防具が出る状態ならモンクで開ける。 | @クロウラーの巣 | N 蟲穴の宝のカギ*1 | K 古びた小手
g03 talk - | ジュノ上層のGuslamに話す | 直せないと言われる。 | @ジュノ上層 H-8 | T npc.244.Guslam
g04 talk - | 【初めての魔手クエストのときだけ】不朽の盾のDeadly Minnowに話してから、ジュノ下層(J-8)天晶堂のYin Pocanakhuに話し、1000ギルを払う | 一度でも魔手クエストを終えていればこの手順はない。 | @ジュノ下層 J-8 | T npc.245.Yin_Pocanakhu | E BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Striking_Hands;先に Deadly Minnow に話す
g05 examine - | ジュノ港(H-8)免税店前の木箱のあたりの???を調べる | ボルグヘルツの霊に「闇の炎」を頼まれる。 | @ジュノ港 H-8 | T obj.246.???_H-8 = obj:???@ジュノ港 H-8
g06 fight - | ズヴァール城外郭MAP[1](F-8)のTorchを調べ、ボムNM「Dark Spark」を倒す | 自爆されてもよい。モンクでなくてよい。 | @ズヴァール城外郭 F-8 #1 | T mob.161.Dark_Spark = mob:Dark Spark@ズヴァール城外郭 F-8 #1
g07 examine - | もう一度Torchを調べ、だいじなもの「闇の炎」をもらう | - | @ズヴァール城外郭 F-8 #1 | T obj.161.Torch_F-8 = obj:Torch~@ズヴァール城外郭 F-8 #1 | K 闇の炎
g08 examine - | ジュノ港(H-8)の???を調べて完了 | テンプルグローブをもらう。 | @ジュノ港 H-8 | T obj.246.???_H-8 | K 闇の炎

@ quest.jeuno.014 https://wiki.ffo.jp/html/2252.html
Q Borghertz's Loyal Hands | ボルグヘルツの失われた魔手 ＜ 侍 ＞ | no | T npc.244.Guslam = npc:Guslam@ジュノ上層 H-8
RW item:明珍筒篭手
XS 用語辞典;https://wiki.ffo.jp/html/5447.html;報酬「明珍筒篭手」は用語辞典で確認
LK quest:侍のAF連続クエスト第二弾をオファー中かコンプリート
LK condition:同時に複数のジョブでは受けられない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Loyal_Hands;初回は店内のDeadly Minnowに話してからYin Pocanakhuへ、Torchはズヴァール城外郭の最初の地図
g01 talk - | 侍で、ジュノ上層(H-8)防具屋「不朽の盾」のGuslamに話して受ける | 他のジョブの魔手クエストを途中のままだと受けられない。 | @ジュノ上層 H-8 | T npc.244.Guslam
g02 examine - | クフタルの洞門のTreasure Cofferを開け、だいじなもの「古びた小手」をもらう | カギは「クフタルの宝のカギ」（クフタルの洞門の敵が落とす。星唄の煌めき【二奏】があれば三国のCurio Vendor Moogleで買える）。開けるときのジョブは自由だが、他のジョブでAF3連続を終えてAF防具が出る状態なら侍で開ける。 | @クフタルの洞門 | N クフタルの宝のカギ*1 | K 古びた小手
g03 talk - | ジュノ上層のGuslamに話す | 直せないと言われる。 | @ジュノ上層 H-8 | T npc.244.Guslam
g04 talk - | 【初めての魔手クエストのときだけ】不朽の盾のDeadly Minnowに話してから、ジュノ下層(J-8)天晶堂のYin Pocanakhuに話し、1000ギルを払う | 一度でも魔手クエストを終えていればこの手順はない。 | @ジュノ下層 J-8 | T npc.245.Yin_Pocanakhu | E BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Loyal_Hands;先に Deadly Minnow に話す
g05 examine - | ジュノ港(H-8)免税店前の木箱のあたりの???を調べる | ボルグヘルツの霊に「闇の炎」を頼まれる。 | @ジュノ港 H-8 | T obj.246.???_H-8 = obj:???@ジュノ港 H-8
g06 fight - | ズヴァール城外郭MAP[1](F-8)のTorchを調べ、ボムNM「Dark Spark」を倒す | 自爆されてもよい。侍でなくてよい。 | @ズヴァール城外郭 F-8 #1 | T mob.161.Dark_Spark = mob:Dark Spark@ズヴァール城外郭 F-8 #1
g07 examine - | もう一度Torchを調べ、だいじなもの「闇の炎」をもらう | - | @ズヴァール城外郭 F-8 #1 | T obj.161.Torch_F-8 = obj:Torch~@ズヴァール城外郭 F-8 #1 | K 闇の炎
g08 examine - | ジュノ港(H-8)の???を調べて完了 | 明珍筒篭手をもらう。 | @ジュノ港 H-8 | T obj.246.???_H-8 | K 闇の炎

@ quest.jeuno.015 https://wiki.ffo.jp/html/2252.html
Q Borghertz's Calling Hands | ボルグヘルツの失われた魔手 ＜ 召喚士 ＞ | no | T npc.244.Guslam = npc:Guslam@ジュノ上層 H-8
RW item:エボカーブレーサー
XS 用語辞典;https://wiki.ffo.jp/html/7413.html;報酬「エボカーブレーサー」は用語辞典で確認
LK quest:召喚士のAF連続クエスト第二弾をオファー中かコンプリート
LK condition:同時に複数のジョブでは受けられない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Calling_Hands;初回は店内のDeadly Minnowに話してからYin Pocanakhuへ、Torchはズヴァール城外郭の最初の地図
g01 talk - | 召喚士で、ジュノ上層(H-8)防具屋「不朽の盾」のGuslamに話して受ける | 他のジョブの魔手クエストを途中のままだと受けられない。 | @ジュノ上層 H-8 | T npc.244.Guslam
g02 examine - | 海蛇の岩窟のTreasure Cofferを開け、だいじなもの「古びた小手」をもらう | カギは「海蛇の宝のカギ」（海蛇の岩窟の敵が落とす。星唄の煌めき【二奏】があれば三国のCurio Vendor Moogleで買える）。開けるときのジョブは自由だが、他のジョブでAF3連続を終えてAF防具が出る状態なら召喚士で開ける。 | @海蛇の岩窟 | N 海蛇の宝のカギ*1 | K 古びた小手
g03 talk - | ジュノ上層のGuslamに話す | 直せないと言われる。 | @ジュノ上層 H-8 | T npc.244.Guslam
g04 talk - | 【初めての魔手クエストのときだけ】不朽の盾のDeadly Minnowに話してから、ジュノ下層(J-8)天晶堂のYin Pocanakhuに話し、1000ギルを払う | 一度でも魔手クエストを終えていればこの手順はない。 | @ジュノ下層 J-8 | T npc.245.Yin_Pocanakhu | E BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Calling_Hands;先に Deadly Minnow に話す
g05 examine - | ジュノ港(H-8)免税店前の木箱のあたりの???を調べる | ボルグヘルツの霊に「闇の炎」を頼まれる。 | @ジュノ港 H-8 | T obj.246.???_H-8 = obj:???@ジュノ港 H-8
g06 fight - | ズヴァール城外郭MAP[1](F-8)のTorchを調べ、ボムNM「Dark Spark」を倒す | 自爆されてもよい。召喚士でなくてよい。 | @ズヴァール城外郭 F-8 #1 | T mob.161.Dark_Spark = mob:Dark Spark@ズヴァール城外郭 F-8 #1
g07 examine - | もう一度Torchを調べ、だいじなもの「闇の炎」をもらう | - | @ズヴァール城外郭 F-8 #1 | T obj.161.Torch_F-8 = obj:Torch~@ズヴァール城外郭 F-8 #1 | K 闇の炎
g08 examine - | ジュノ港(H-8)の???を調べて完了 | エボカーブレーサーをもらう。 | @ジュノ港 H-8 | T obj.246.???_H-8 | K 闇の炎

@ quest.jeuno.016 https://wiki.ffo.jp/html/2252.html
Q Borghertz's Harmonious Hands | ボルグヘルツの失われた魔手 ＜ 吟遊詩人 ＞ | no | T npc.244.Guslam = npc:Guslam@ジュノ上層 H-8
RW item:コラルカフス
XS 用語辞典;https://wiki.ffo.jp/html/1247.html;報酬「コラルカフス」は用語辞典で確認
LK quest:吟遊詩人のAF連続クエスト第二弾をオファー中かコンプリート
LK condition:同時に複数のジョブでは受けられない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Harmonious_Hands;初回は店内のDeadly Minnowに話してからYin Pocanakhuへ、Torchはズヴァール城外郭の最初の地図
g01 talk - | 吟遊詩人で、ジュノ上層(H-8)防具屋「不朽の盾」のGuslamに話して受ける | 他のジョブの魔手クエストを途中のままだと受けられない。 | @ジュノ上層 H-8 | T npc.244.Guslam
g02 examine - | ズヴァール城外郭のTreasure Cofferを開け、だいじなもの「古びた小手」をもらう | カギは「廃城の宝のカギ」（ズヴァール城外郭の敵が落とす。星唄の煌めき【二奏】があれば三国のCurio Vendor Moogleで買える）。開けるときのジョブは自由だが、他のジョブでAF3連続を終えてAF防具が出る状態なら吟遊詩人で開ける。 | @ズヴァール城外郭 | N 廃城の宝のカギ*1 | K 古びた小手
g03 talk - | ジュノ上層のGuslamに話す | 直せないと言われる。 | @ジュノ上層 H-8 | T npc.244.Guslam
g04 talk - | 【初めての魔手クエストのときだけ】不朽の盾のDeadly Minnowに話してから、ジュノ下層(J-8)天晶堂のYin Pocanakhuに話し、1000ギルを払う | 一度でも魔手クエストを終えていればこの手順はない。 | @ジュノ下層 J-8 | T npc.245.Yin_Pocanakhu | E BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Harmonious_Hands;先に Deadly Minnow に話す
g05 examine - | ジュノ港(H-8)免税店前の木箱のあたりの???を調べる | ボルグヘルツの霊に「闇の炎」を頼まれる。 | @ジュノ港 H-8 | T obj.246.???_H-8 = obj:???@ジュノ港 H-8
g06 fight - | ズヴァール城外郭MAP[1](F-8)のTorchを調べ、ボムNM「Dark Spark」を倒す | 自爆されてもよい。吟遊詩人でなくてよい。 | @ズヴァール城外郭 F-8 #1 | T mob.161.Dark_Spark = mob:Dark Spark@ズヴァール城外郭 F-8 #1
g07 examine - | もう一度Torchを調べ、だいじなもの「闇の炎」をもらう | - | @ズヴァール城外郭 F-8 #1 | T obj.161.Torch_F-8 = obj:Torch~@ズヴァール城外郭 F-8 #1 | K 闇の炎
g08 examine - | ジュノ港(H-8)の???を調べて完了 | コラルカフスをもらう。 | @ジュノ港 H-8 | T obj.246.???_H-8 | K 闇の炎

@ quest.jeuno.017 https://wiki.ffo.jp/html/2252.html
Q Borghertz's Lurking Hands | ボルグヘルツの失われた魔手 ＜ 忍者 ＞ | no | T npc.244.Guslam = npc:Guslam@ジュノ上層 H-8
RW item:乱波手甲
XS 用語辞典;https://wiki.ffo.jp/html/4651.html;報酬「乱波手甲」は用語辞典で確認
LK quest:忍者のAF連続クエスト第二弾をオファー中かコンプリート
LK condition:同時に複数のジョブでは受けられない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Lurking_Hands;初回は店内のDeadly Minnowに話してからYin Pocanakhuへ、Torchはズヴァール城外郭の最初の地図
g01 talk - | 忍者で、ジュノ上層(H-8)防具屋「不朽の盾」のGuslamに話して受ける | 他のジョブの魔手クエストを途中のままだと受けられない。 | @ジュノ上層 H-8 | T npc.244.Guslam
g02 examine - | イフリートの釜のTreasure Cofferを開け、だいじなもの「古びた小手」をもらう | カギは「火口の宝のカギ」（イフリートの釜の敵が落とす。星唄の煌めき【二奏】があれば三国のCurio Vendor Moogleで買える）。開けるときのジョブは自由だが、他のジョブでAF3連続を終えてAF防具が出る状態なら忍者で開ける。 | @イフリートの釜 | N 火口の宝のカギ*1 | K 古びた小手
g03 talk - | ジュノ上層のGuslamに話す | 直せないと言われる。 | @ジュノ上層 H-8 | T npc.244.Guslam
g04 talk - | 【初めての魔手クエストのときだけ】不朽の盾のDeadly Minnowに話してから、ジュノ下層(J-8)天晶堂のYin Pocanakhuに話し、1000ギルを払う | 一度でも魔手クエストを終えていればこの手順はない。 | @ジュノ下層 J-8 | T npc.245.Yin_Pocanakhu | E BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Lurking_Hands;先に Deadly Minnow に話す
g05 examine - | ジュノ港(H-8)免税店前の木箱のあたりの???を調べる | ボルグヘルツの霊に「闇の炎」を頼まれる。 | @ジュノ港 H-8 | T obj.246.???_H-8 = obj:???@ジュノ港 H-8
g06 fight - | ズヴァール城外郭MAP[1](F-8)のTorchを調べ、ボムNM「Dark Spark」を倒す | 自爆されてもよい。忍者でなくてよい。 | @ズヴァール城外郭 F-8 #1 | T mob.161.Dark_Spark = mob:Dark Spark@ズヴァール城外郭 F-8 #1
g07 examine - | もう一度Torchを調べ、だいじなもの「闇の炎」をもらう | - | @ズヴァール城外郭 F-8 #1 | T obj.161.Torch_F-8 = obj:Torch~@ズヴァール城外郭 F-8 #1 | K 闇の炎
g08 examine - | ジュノ港(H-8)の???を調べて完了 | 乱波手甲をもらう。 | @ジュノ港 H-8 | T obj.246.???_H-8 | K 闇の炎

@ quest.jeuno.018 https://wiki.ffo.jp/html/2252.html
Q Borghertz's Warring Hands | ボルグヘルツの失われた魔手 ＜ 戦士 ＞ | no | T npc.244.Guslam = npc:Guslam@ジュノ上層 H-8
RW item:ファイターマフラ
XS 用語辞典;https://wiki.ffo.jp/html/5146.html;報酬「ファイターマフラ」は用語辞典で確認
LK quest:戦士のAF連続クエスト第二弾をオファー中かコンプリート
LK condition:同時に複数のジョブでは受けられない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Warring_Hands;初回は店内のDeadly Minnowに話してからYin Pocanakhuへ、Torchはズヴァール城外郭の最初の地図
g01 talk - | 戦士で、ジュノ上層(H-8)防具屋「不朽の盾」のGuslamに話して受ける | 他のジョブの魔手クエストを途中のままだと受けられない。 | @ジュノ上層 H-8 | T npc.244.Guslam
g02 examine - | エルディーム古墳のTreasure Cofferを開け、だいじなもの「古びた小手」をもらう | カギは「古墳の宝のカギ」（エルディーム古墳の敵が落とす。星唄の煌めき【二奏】があれば三国のCurio Vendor Moogleで買える）。開けるときのジョブは自由だが、他のジョブでAF3連続を終えてAF防具が出る状態なら戦士で開ける。 | @エルディーム古墳 | N 古墳の宝のカギ*1 | K 古びた小手
g03 talk - | ジュノ上層のGuslamに話す | 直せないと言われる。 | @ジュノ上層 H-8 | T npc.244.Guslam
g04 talk - | 【初めての魔手クエストのときだけ】不朽の盾のDeadly Minnowに話してから、ジュノ下層(J-8)天晶堂のYin Pocanakhuに話し、1000ギルを払う | 一度でも魔手クエストを終えていればこの手順はない。 | @ジュノ下層 J-8 | T npc.245.Yin_Pocanakhu | E BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Warring_Hands;先に Deadly Minnow に話す
g05 examine - | ジュノ港(H-8)免税店前の木箱のあたりの???を調べる | ボルグヘルツの霊に「闇の炎」を頼まれる。 | @ジュノ港 H-8 | T obj.246.???_H-8 = obj:???@ジュノ港 H-8
g06 fight - | ズヴァール城外郭MAP[1](F-8)のTorchを調べ、ボムNM「Dark Spark」を倒す | 自爆されてもよい。戦士でなくてよい。 | @ズヴァール城外郭 F-8 #1 | T mob.161.Dark_Spark = mob:Dark Spark@ズヴァール城外郭 F-8 #1
g07 examine - | もう一度Torchを調べ、だいじなもの「闇の炎」をもらう | - | @ズヴァール城外郭 F-8 #1 | T obj.161.Torch_F-8 = obj:Torch~@ズヴァール城外郭 F-8 #1 | K 闇の炎
g08 examine - | ジュノ港(H-8)の???を調べて完了 | ファイターマフラをもらう。 | @ジュノ港 H-8 | T obj.246.???_H-8 | K 闇の炎

@ quest.jeuno.019 https://wiki.ffo.jp/html/2252.html
Q Borghertz's Shadowy Hands | ボルグヘルツの失われた魔手 ＜ 暗黒騎士 ＞ | no | T npc.244.Guslam = npc:Guslam@ジュノ上層 H-8
RW item:カオスガントレット
XS 用語辞典;https://wiki.ffo.jp/html/7425.html;報酬「カオスガントレット」は用語辞典で確認
LK quest:暗黒騎士のAF連続クエスト第二弾をオファー中かコンプリート
LK condition:同時に複数のジョブでは受けられない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Shadowy_Hands;初回は店内のDeadly Minnowに話してからYin Pocanakhuへ、Torchはズヴァール城外郭の最初の地図
g01 talk - | 暗黒騎士で、ジュノ上層(H-8)防具屋「不朽の盾」のGuslamに話して受ける | 他のジョブの魔手クエストを途中のままだと受けられない。 | @ジュノ上層 H-8 | T npc.244.Guslam
g02 examine - | エルディーム古墳のTreasure Cofferを開け、だいじなもの「古びた小手」をもらう | カギは「古墳の宝のカギ」（エルディーム古墳の敵が落とす。星唄の煌めき【二奏】があれば三国のCurio Vendor Moogleで買える）。開けるときのジョブは自由だが、他のジョブでAF3連続を終えてAF防具が出る状態なら暗黒騎士で開ける。 | @エルディーム古墳 | N 古墳の宝のカギ*1 | K 古びた小手
g03 talk - | ジュノ上層のGuslamに話す | 直せないと言われる。 | @ジュノ上層 H-8 | T npc.244.Guslam
g04 talk - | 【初めての魔手クエストのときだけ】不朽の盾のDeadly Minnowに話してから、ジュノ下層(J-8)天晶堂のYin Pocanakhuに話し、1000ギルを払う | 一度でも魔手クエストを終えていればこの手順はない。 | @ジュノ下層 J-8 | T npc.245.Yin_Pocanakhu | E BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Shadowy_Hands;先に Deadly Minnow に話す
g05 examine - | ジュノ港(H-8)免税店前の木箱のあたりの???を調べる | ボルグヘルツの霊に「闇の炎」を頼まれる。 | @ジュノ港 H-8 | T obj.246.???_H-8 = obj:???@ジュノ港 H-8
g06 fight - | ズヴァール城外郭MAP[1](F-8)のTorchを調べ、ボムNM「Dark Spark」を倒す | 自爆されてもよい。暗黒騎士でなくてよい。 | @ズヴァール城外郭 F-8 #1 | T mob.161.Dark_Spark = mob:Dark Spark@ズヴァール城外郭 F-8 #1
g07 examine - | もう一度Torchを調べ、だいじなもの「闇の炎」をもらう | - | @ズヴァール城外郭 F-8 #1 | T obj.161.Torch_F-8 = obj:Torch~@ズヴァール城外郭 F-8 #1 | K 闇の炎
g08 examine - | ジュノ港(H-8)の???を調べて完了 | カオスガントレットをもらう。 | @ジュノ港 H-8 | T obj.246.???_H-8 | K 闇の炎

@ quest.jeuno.020 https://wiki.ffo.jp/html/2252.html
Q Borghertz's Chasing Hands | ボルグヘルツの失われた魔手 ＜ 狩人 ＞ | no | T npc.244.Guslam = npc:Guslam@ジュノ上層 H-8
RW item:ハンターブレーサー
XS 用語辞典;https://wiki.ffo.jp/html/5968.html;報酬「ハンターブレーサー」は用語辞典で確認
LK quest:狩人のAF連続クエスト第二弾をオファー中かコンプリート
LK condition:同時に複数のジョブでは受けられない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Chasing_Hands;初回は店内のDeadly Minnowに話してからYin Pocanakhuへ、Torchはズヴァール城外郭の最初の地図
g01 talk - | 狩人で、ジュノ上層(H-8)防具屋「不朽の盾」のGuslamに話して受ける | 他のジョブの魔手クエストを途中のままだと受けられない。 | @ジュノ上層 H-8 | T npc.244.Guslam
g02 examine - | ガルレージュ要塞のTreasure Cofferを開け、だいじなもの「古びた小手」をもらう | カギは「要塞の宝のカギ」（ガルレージュ要塞の敵が落とす。星唄の煌めき【二奏】があれば三国のCurio Vendor Moogleで買える）。開けるときのジョブは自由だが、他のジョブでAF3連続を終えてAF防具が出る状態なら狩人で開ける。 | @ガルレージュ要塞 | N 要塞の宝のカギ*1 | K 古びた小手
g03 talk - | ジュノ上層のGuslamに話す | 直せないと言われる。 | @ジュノ上層 H-8 | T npc.244.Guslam
g04 talk - | 【初めての魔手クエストのときだけ】不朽の盾のDeadly Minnowに話してから、ジュノ下層(J-8)天晶堂のYin Pocanakhuに話し、1000ギルを払う | 一度でも魔手クエストを終えていればこの手順はない。 | @ジュノ下層 J-8 | T npc.245.Yin_Pocanakhu | E BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Chasing_Hands;先に Deadly Minnow に話す
g05 examine - | ジュノ港(H-8)免税店前の木箱のあたりの???を調べる | ボルグヘルツの霊に「闇の炎」を頼まれる。 | @ジュノ港 H-8 | T obj.246.???_H-8 = obj:???@ジュノ港 H-8
g06 fight - | ズヴァール城外郭MAP[1](F-8)のTorchを調べ、ボムNM「Dark Spark」を倒す | 自爆されてもよい。狩人でなくてよい。 | @ズヴァール城外郭 F-8 #1 | T mob.161.Dark_Spark = mob:Dark Spark@ズヴァール城外郭 F-8 #1
g07 examine - | もう一度Torchを調べ、だいじなもの「闇の炎」をもらう | - | @ズヴァール城外郭 F-8 #1 | T obj.161.Torch_F-8 = obj:Torch~@ズヴァール城外郭 F-8 #1 | K 闇の炎
g08 examine - | ジュノ港(H-8)の???を調べて完了 | ハンターブレーサーをもらう。 | @ジュノ港 H-8 | T obj.246.???_H-8 | K 闇の炎

@ quest.jeuno.021 https://wiki.ffo.jp/html/2252.html
Q Borghertz's Wild Hands | ボルグヘルツの失われた魔手 ＜ 獣使い ＞ | no | T npc.244.Guslam = npc:Guslam@ジュノ上層 H-8
RW item:ビーストグローブ
XS 用語辞典;https://wiki.ffo.jp/html/6014.html;報酬「ビーストグローブ」は用語辞典で確認
LK quest:獣使いのAF連続クエスト第二弾をオファー中かコンプリート
LK condition:同時に複数のジョブでは受けられない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Wild_Hands;初回は店内のDeadly Minnowに話してからYin Pocanakhuへ、Torchはズヴァール城外郭の最初の地図
g01 talk - | 獣使いで、ジュノ上層(H-8)防具屋「不朽の盾」のGuslamに話して受ける | 他のジョブの魔手クエストを途中のままだと受けられない。 | @ジュノ上層 H-8 | T npc.244.Guslam
g02 examine - | クロウラーの巣のTreasure Cofferを開け、だいじなもの「古びた小手」をもらう | カギは「蟲穴の宝のカギ」（クロウラーの巣の敵が落とす。星唄の煌めき【二奏】があれば三国のCurio Vendor Moogleで買える）。開けるときのジョブは自由だが、他のジョブでAF3連続を終えてAF防具が出る状態なら獣使いで開ける。 | @クロウラーの巣 | N 蟲穴の宝のカギ*1 | K 古びた小手
g03 talk - | ジュノ上層のGuslamに話す | 直せないと言われる。 | @ジュノ上層 H-8 | T npc.244.Guslam
g04 talk - | 【初めての魔手クエストのときだけ】不朽の盾のDeadly Minnowに話してから、ジュノ下層(J-8)天晶堂のYin Pocanakhuに話し、1000ギルを払う | 一度でも魔手クエストを終えていればこの手順はない。 | @ジュノ下層 J-8 | T npc.245.Yin_Pocanakhu | E BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Wild_Hands;先に Deadly Minnow に話す
g05 examine - | ジュノ港(H-8)免税店前の木箱のあたりの???を調べる | ボルグヘルツの霊に「闇の炎」を頼まれる。 | @ジュノ港 H-8 | T obj.246.???_H-8 = obj:???@ジュノ港 H-8
g06 fight - | ズヴァール城外郭MAP[1](F-8)のTorchを調べ、ボムNM「Dark Spark」を倒す | 自爆されてもよい。獣使いでなくてよい。 | @ズヴァール城外郭 F-8 #1 | T mob.161.Dark_Spark = mob:Dark Spark@ズヴァール城外郭 F-8 #1
g07 examine - | もう一度Torchを調べ、だいじなもの「闇の炎」をもらう | - | @ズヴァール城外郭 F-8 #1 | T obj.161.Torch_F-8 = obj:Torch~@ズヴァール城外郭 F-8 #1 | K 闇の炎
g08 examine - | ジュノ港(H-8)の???を調べて完了 | ビーストグローブをもらう。 | @ジュノ港 H-8 | T obj.246.???_H-8 | K 闇の炎

@ quest.jeuno.022 https://wiki.ffo.jp/html/2252.html
Q Borghertz's Healing Hands | ボルグヘルツの失われた魔手 ＜ 白魔道士 ＞ | no | T npc.244.Guslam = npc:Guslam@ジュノ上層 H-8
RW item:ヒーラーミトン
XS 用語辞典;https://wiki.ffo.jp/html/4955.html;報酬「ヒーラーミトン」は用語辞典で確認
LK quest:白魔道士のAF連続クエスト第二弾をオファー中かコンプリート
LK condition:同時に複数のジョブでは受けられない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Healing_Hands;初回は店内のDeadly Minnowに話してからYin Pocanakhuへ、Torchはズヴァール城外郭の最初の地図
g01 talk - | 白魔道士で、ジュノ上層(H-8)防具屋「不朽の盾」のGuslamに話して受ける | 他のジョブの魔手クエストを途中のままだと受けられない。 | @ジュノ上層 H-8 | T npc.244.Guslam
g02 examine - | ベドーのTreasure Cofferを開け、だいじなもの「古びた小手」をもらう | カギは「地下都市の宝のカギ」（ベドーの敵が落とす。星唄の煌めき【二奏】があれば三国のCurio Vendor Moogleで買える）。開けるときのジョブは自由だが、他のジョブでAF3連続を終えてAF防具が出る状態なら白魔道士で開ける。 | @ベドー | N 地下都市の宝のカギ*1 | K 古びた小手
g03 talk - | ジュノ上層のGuslamに話す | 直せないと言われる。 | @ジュノ上層 H-8 | T npc.244.Guslam
g04 talk - | 【初めての魔手クエストのときだけ】不朽の盾のDeadly Minnowに話してから、ジュノ下層(J-8)天晶堂のYin Pocanakhuに話し、1000ギルを払う | 一度でも魔手クエストを終えていればこの手順はない。 | @ジュノ下層 J-8 | T npc.245.Yin_Pocanakhu | E BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Healing_Hands;先に Deadly Minnow に話す
g05 examine - | ジュノ港(H-8)免税店前の木箱のあたりの???を調べる | ボルグヘルツの霊に「闇の炎」を頼まれる。 | @ジュノ港 H-8 | T obj.246.???_H-8 = obj:???@ジュノ港 H-8
g06 fight - | ズヴァール城外郭MAP[1](F-8)のTorchを調べ、ボムNM「Dark Spark」を倒す | 自爆されてもよい。白魔道士でなくてよい。 | @ズヴァール城外郭 F-8 #1 | T mob.161.Dark_Spark = mob:Dark Spark@ズヴァール城外郭 F-8 #1
g07 examine - | もう一度Torchを調べ、だいじなもの「闇の炎」をもらう | - | @ズヴァール城外郭 F-8 #1 | T obj.161.Torch_F-8 = obj:Torch~@ズヴァール城外郭 F-8 #1 | K 闇の炎
g08 examine - | ジュノ港(H-8)の???を調べて完了 | ヒーラーミトンをもらう。 | @ジュノ港 H-8 | T obj.246.???_H-8 | K 闇の炎

@ quest.jeuno.023 https://wiki.ffo.jp/html/2252.html
Q Borghertz's Dragon Hands | ボルグヘルツの失われた魔手 ＜ 竜騎士 ＞ | no | T npc.244.Guslam = npc:Guslam@ジュノ上層 H-8
RW item:ドラケンフィンガー
XS 用語辞典;https://wiki.ffo.jp/html/7405.html;報酬「ドラケンフィンガー」は用語辞典で確認
LK quest:竜騎士のAF連続クエスト第二弾をオファー中かコンプリート
LK condition:同時に複数のジョブでは受けられない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Dragon_Hands;初回は店内のDeadly Minnowに話してからYin Pocanakhuへ、Torchはズヴァール城外郭の最初の地図
g01 talk - | 竜騎士で、ジュノ上層(H-8)防具屋「不朽の盾」のGuslamに話して受ける | 他のジョブの魔手クエストを途中のままだと受けられない。 | @ジュノ上層 H-8 | T npc.244.Guslam
g02 examine - | ボヤーダ樹のTreasure Cofferを開け、だいじなもの「古びた小手」をもらう | カギは「ボヤーダの宝のカギ」（ボヤーダ樹の敵が落とす。星唄の煌めき【二奏】があれば三国のCurio Vendor Moogleで買える）。開けるときのジョブは自由だが、他のジョブでAF3連続を終えてAF防具が出る状態なら竜騎士で開ける。 | @ボヤーダ樹 | N ボヤーダの宝のカギ*1 | K 古びた小手
g03 talk - | ジュノ上層のGuslamに話す | 直せないと言われる。 | @ジュノ上層 H-8 | T npc.244.Guslam
g04 talk - | 【初めての魔手クエストのときだけ】不朽の盾のDeadly Minnowに話してから、ジュノ下層(J-8)天晶堂のYin Pocanakhuに話し、1000ギルを払う | 一度でも魔手クエストを終えていればこの手順はない。 | @ジュノ下層 J-8 | T npc.245.Yin_Pocanakhu | E BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Dragon_Hands;先に Deadly Minnow に話す
g05 examine - | ジュノ港(H-8)免税店前の木箱のあたりの???を調べる | ボルグヘルツの霊に「闇の炎」を頼まれる。 | @ジュノ港 H-8 | T obj.246.???_H-8 = obj:???@ジュノ港 H-8
g06 fight - | ズヴァール城外郭MAP[1](F-8)のTorchを調べ、ボムNM「Dark Spark」を倒す | 自爆されてもよい。竜騎士でなくてよい。 | @ズヴァール城外郭 F-8 #1 | T mob.161.Dark_Spark = mob:Dark Spark@ズヴァール城外郭 F-8 #1
g07 examine - | もう一度Torchを調べ、だいじなもの「闇の炎」をもらう | - | @ズヴァール城外郭 F-8 #1 | T obj.161.Torch_F-8 = obj:Torch~@ズヴァール城外郭 F-8 #1 | K 闇の炎
g08 examine - | ジュノ港(H-8)の???を調べて完了 | ドラケンフィンガーをもらう。 | @ジュノ港 H-8 | T obj.246.???_H-8 | K 闇の炎

@ quest.jeuno.024 https://wiki.ffo.jp/html/2252.html
Q Borghertz's Vermillion Hands | ボルグヘルツの失われた魔手 ＜ 赤魔道士 ＞ | no | T npc.244.Guslam = npc:Guslam@ジュノ上層 H-8
RW item:ワーロックグローブ
XS 用語辞典;https://wiki.ffo.jp/html/4566.html;報酬「ワーロックグローブ」は用語辞典で確認
LK quest:赤魔道士のAF連続クエスト第二弾をオファー中かコンプリート
LK condition:同時に複数のジョブでは受けられない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Vermillion_Hands;初回は店内のDeadly Minnowに話してからYin Pocanakhuへ、Torchはズヴァール城外郭の最初の地図
g01 talk - | 赤魔道士で、ジュノ上層(H-8)防具屋「不朽の盾」のGuslamに話して受ける | 他のジョブの魔手クエストを途中のままだと受けられない。 | @ジュノ上層 H-8 | T npc.244.Guslam
g02 examine - | エルディーム古墳のTreasure Cofferを開け、だいじなもの「古びた小手」をもらう | カギは「古墳の宝のカギ」（エルディーム古墳の敵が落とす。星唄の煌めき【二奏】があれば三国のCurio Vendor Moogleで買える）。開けるときのジョブは自由だが、他のジョブでAF3連続を終えてAF防具が出る状態なら赤魔道士で開ける。 | @エルディーム古墳 | N 古墳の宝のカギ*1 | K 古びた小手
g03 talk - | ジュノ上層のGuslamに話す | 直せないと言われる。 | @ジュノ上層 H-8 | T npc.244.Guslam
g04 talk - | 【初めての魔手クエストのときだけ】不朽の盾のDeadly Minnowに話してから、ジュノ下層(J-8)天晶堂のYin Pocanakhuに話し、1000ギルを払う | 一度でも魔手クエストを終えていればこの手順はない。 | @ジュノ下層 J-8 | T npc.245.Yin_Pocanakhu | E BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Vermillion_Hands;先に Deadly Minnow に話す
g05 examine - | ジュノ港(H-8)免税店前の木箱のあたりの???を調べる | ボルグヘルツの霊に「闇の炎」を頼まれる。 | @ジュノ港 H-8 | T obj.246.???_H-8 = obj:???@ジュノ港 H-8
g06 fight - | ズヴァール城外郭MAP[1](F-8)のTorchを調べ、ボムNM「Dark Spark」を倒す | 自爆されてもよい。赤魔道士でなくてよい。 | @ズヴァール城外郭 F-8 #1 | T mob.161.Dark_Spark = mob:Dark Spark@ズヴァール城外郭 F-8 #1
g07 examine - | もう一度Torchを調べ、だいじなもの「闇の炎」をもらう | - | @ズヴァール城外郭 F-8 #1 | T obj.161.Torch_F-8 = obj:Torch~@ズヴァール城外郭 F-8 #1 | K 闇の炎
g08 examine - | ジュノ港(H-8)の???を調べて完了 | ワーロックグローブをもらう。 | @ジュノ港 H-8 | T obj.246.???_H-8 | K 闇の炎

@ quest.jeuno.025 https://wiki.ffo.jp/html/2252.html
Q Borghertz's Sorcerous Hands | ボルグヘルツの失われた魔手 ＜ 黒魔道士 ＞ | no | T npc.244.Guslam = npc:Guslam@ジュノ上層 H-8
RW item:ウィザードグローブ
XS 用語辞典;https://wiki.ffo.jp/html/3630.html;報酬「ウィザードグローブ」は用語辞典で確認
LK quest:黒魔道士のAF連続クエスト第二弾をオファー中かコンプリート
LK condition:同時に複数のジョブでは受けられない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Sorcerous_Hands;初回は店内のDeadly Minnowに話してからYin Pocanakhuへ、Torchはズヴァール城外郭の最初の地図
g01 talk - | 黒魔道士で、ジュノ上層(H-8)防具屋「不朽の盾」のGuslamに話して受ける | 他のジョブの魔手クエストを途中のままだと受けられない。 | @ジュノ上層 H-8 | T npc.244.Guslam
g02 examine - | ガルレージュ要塞のTreasure Cofferを開け、だいじなもの「古びた小手」をもらう | カギは「要塞の宝のカギ」（ガルレージュ要塞の敵が落とす。星唄の煌めき【二奏】があれば三国のCurio Vendor Moogleで買える）。開けるときのジョブは自由だが、他のジョブでAF3連続を終えてAF防具が出る状態なら黒魔道士で開ける。 | @ガルレージュ要塞 | N 要塞の宝のカギ*1 | K 古びた小手
g03 talk - | ジュノ上層のGuslamに話す | 直せないと言われる。 | @ジュノ上層 H-8 | T npc.244.Guslam
g04 talk - | 【初めての魔手クエストのときだけ】不朽の盾のDeadly Minnowに話してから、ジュノ下層(J-8)天晶堂のYin Pocanakhuに話し、1000ギルを払う | 一度でも魔手クエストを終えていればこの手順はない。 | @ジュノ下層 J-8 | T npc.245.Yin_Pocanakhu | E BG Wiki;https://www.bg-wiki.com/ffxi/Borghertz%27s_Sorcerous_Hands;先に Deadly Minnow に話す
g05 examine - | ジュノ港(H-8)免税店前の木箱のあたりの???を調べる | ボルグヘルツの霊に「闇の炎」を頼まれる。 | @ジュノ港 H-8 | T obj.246.???_H-8 = obj:???@ジュノ港 H-8
g06 fight - | ズヴァール城外郭MAP[1](F-8)のTorchを調べ、ボムNM「Dark Spark」を倒す | 自爆されてもよい。黒魔道士でなくてよい。 | @ズヴァール城外郭 F-8 #1 | T mob.161.Dark_Spark = mob:Dark Spark@ズヴァール城外郭 F-8 #1
g07 examine - | もう一度Torchを調べ、だいじなもの「闇の炎」をもらう | - | @ズヴァール城外郭 F-8 #1 | T obj.161.Torch_F-8 = obj:Torch~@ズヴァール城外郭 F-8 #1 | K 闇の炎
g08 examine - | ジュノ港(H-8)の???を調べて完了 | ウィザードグローブをもらう。 | @ジュノ港 H-8 | T obj.246.???_H-8 | K 闇の炎

@ quest.jeuno.026 https://wiki.ffo.jp/html/35480.html
Q Full Speed Ahead! | ライドオン！ | no | T npc.244.Mapitoto = npc:Mapitoto@ジュノ上層 G-7
RW key_item:♪ラプトル
RW key_item:呼子霊笛
LK condition:だいじなもの「チョコボ乗り免許証」「ジュノ周辺地図」所持、メインジョブLv20以上
g01 talk - | ジュノ上層(G-7)チョコボ厩舎のすぐ外のMapitotoに話して受ける | 承諾するとラプトルに乗ってバタリア丘陵へ飛ばされる。 | @ジュノ上層 G-7 | T npc.244.Mapitoto | K チョコボ乗り免許証,ジュノ周辺地図
g02 go - | ラプトルで8か所のうち5か所以上のRaptor's Foodを回り、バタリア丘陵(E-6)のSyrilliaのところへ着く | 餌場は墳墓の玄室の中で、入口に青い光の柱。やる気が0になる・10分を過ぎる・降りると失敗。/cheerで回復（活力が4割ほど貯まってから）。北回り (J-8)→(I-7)→(H-6)→(G-7)北→(F-7)→(E-6) が走りやすい。失敗はその場でやり直せ、難易度も下げられる。 | @バタリア丘陵 E-6 | T npc.105.Syrillia = npc:Syrillia@バタリア丘陵 E-6
g03 talk - | ジュノ上層に戻ったら、Mapitotoに話して完了 | ♪ラプトルと呼子霊笛。 | @ジュノ上層 G-7 | T npc.244.Mapitoto

@ quest.jeuno.027 https://wiki.ffo.jp/html/6991.html
Q A Candlelight Vigil | 亡き夫へのキャンドル | no | T npc.244.Ilumida = npc:Ilumida@ジュノ上層 G-8
RW item:フラワーネックレス
RW title:慈善活動家
LK fame:名声ランク4以上
g01 talk - | ジュノ上層(G-8)の民家のIlumidaに話して受ける | 名声ランク4以上。受けると「キャンドルの原料」も出る。 | @ジュノ上層 G-8 | T npc.244.Ilumida
g02 go - | クエスト「キャンドルの原料」を済ませ、だいじなもの「聖なるキャンドル」を手に入れる | 女神聖堂(H-9)のRoulietteにラノリンを渡す。 | @ジュノ上層 H-9 | T npc.244.Rouliette
g03 talk - | Ilumidaに話して完了 | フラワーネックレス。 | @ジュノ上層 G-8 | T npc.244.Ilumida | K 聖なるキャンドル

@ quest.jeuno.028 https://wiki.ffo.jp/html/5941.html
Q Mirror Images | 伝える言葉 | no | T npc.244.Luto_Mewrilah
RW other:フェローとの信頼関係がさらに深まる
RW other:ピンチのときフェローが「ブレスドレイディアンス」を使うようになる
LK quest:クエスト「天光」をコンプリート
LK condition:フェローとの親密度85以上。イベントにはシグナルパールの所持が必要
g01 talk - | ジュノ上層(G-8)のLuto Mewrilahに話して受ける | 親密度85以上。この先のイベントはシグナルパールを持っていないと見られない（装備は不要）。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g02 fight - | フェ・イン(K-8)からク・ビアの闘技場のバトルフィールドに入り、デーモン族NM「Vassago」を倒す | Lv50制限・15分・1人だけ（フェイス不可）。フェローは中にいる。ブライテッドグルームは空蝉を貫くが、警告のときに後ろへ離れると外れる。フェローを盾にして回復に回るのが楽。薬を数本持って行く。 | @フェ・イン K-8 | T mob.kuhbia.Vassago = mob:Vassago@ク・ビアの闘技場 | E BG Wiki;https://www.bg-wiki.com/ffxi/Mirror_Images;入口はフェ・イン(K-8)
g03 talk - | ジュノ上層のLuto Mewrilahに話す | - | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g04 examine - | ジュノ下層の海神楼に入り、カウンター前（入ってすぐ左の扉）を調べて完了 | - | @ジュノ下層

@ quest.jeuno.029 https://wiki.ffo.jp/html/2725.html
Q Chocobo's Wounds | 傷ついたチョコボ | no | T npc.244.Brutus = npc:Brutus@ジュノ上層 G-7
RW key_item:チョコボ乗り免許証
RW title:チョコボ調教師
LK condition:Lv20以上
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/Chocobo%27s_Wounds;Brutus の座標 G-7
g01 talk - | ジュノ上層(G-7)チョコボ厩舎のBrutusに話して受ける | Lv20以上。先に「逃げだしたチョコボ」のイベントが出たら、終わってからもう一度話す。 | @ジュノ上層 G-7 | T npc.244.Brutus
g02 talk - | 厩舎の奥のOskerに話を聞く | ゴゼビの野草なら食べるかも、と教えてもらえる。 | @ジュノ上層 G-7 | T npc.244.Osker = npc:Osker@ジュノ上層 G-7
g03 gather - | 「ゴゼビの野草」を4個用意する | ダングルフの涸れ谷のWadi Hare、メリファト山地のCrane Flyが落とす。 | N ゴゼビの野草*4
g04 trade - | 厩舎の傷ついたChocoboに「ゴゼビの野草」を1個ずつ4回トレードして完了 | 最初の2回は食べないが無くならない。次のトレードまで地球時間で1分待つ。4回目のあとのイベントで完了。 | @ジュノ上層 G-7 | T npc.244.Chocobo = npc:Chocobo~@ジュノ上層 G-7 | N ゴゼビの野草*4

@ quest.jeuno.030 https://wiki.ffo.jp/html/5958.html
Q Unlisted Qualities | 其の者の名は | no | T npc.244.Luto_Mewrilah
RW item:シルバーインゴット
g01 talk - | ジュノ上層(G-8)のLuto Mewrilahに話し、「はい」で受けて、フェローの種族と名前を選ぶ | 今は条件なし。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g02 talk - | ル・ルデの庭(H-10)のAktaに話して身長を選ぶ | 大きい・普通・小さいの3つ。 | @ル・ルデの庭 H-10 | T npc.243.Akta = npc:Akta@ル・ルデの庭 H-10
g03 talk - | ジュノ下層(H-8)のKuah Dakonsaに話して顔を選ぶ | 選ぶと見本が出るので見比べられる。 | @ジュノ下層 H-8 | T npc.245.Kuah_Dakonsa = npc:Kuah Dakonsa@ジュノ下層 H-8
g04 talk - | ジュノ港(G-8)のRed Ghostに話して性格を選ぶ | 口調の見本は出ない。 | @ジュノ港 G-8 | T npc.246.Red_Ghost = npc:Red Ghost@ジュノ港 G-8
g05 talk - | ジュノ上層(F-5)のBheemに話してイベントを見る | - | @ジュノ上層 F-5 | T npc.244.Bheem = npc:Bheem@ジュノ上層 F-5
g06 talk - | Luto Mewrilahに話して完了 | シルバーインゴット。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah

@ quest.jeuno.031 https://wiki.ffo.jp/html/5938.html
Q Blighted Gloom | 冥闇 | no | T npc.244.Luto_Mewrilah
RW other:フェローの親密度の上限が70になる
LK quest:クエスト「双対の力」をコンプリート
LK condition:フェローとの親密度45以上
g01 talk - | ジュノ上層(G-8)のLuto Mewrilahに話して受ける | 行き先（3か所のどれか）を言われるが、今はどこでも進められる。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g02 fight - | 3か所のどれかの???を調べ、スライム族NM「Metallic Slime」をフェローと倒す | オルデール鍾乳洞(I-5)（ラテーヌ高原(H-7)から入った地図）、コロロカの洞門(F-10)（西アルテパ砂漠から入った地図）、ラングモント峠(I-9)。他の人が倒したあと4〜5分は???が反応しない。Lv40台ならソロで勝てることが多い。 | T mob.metallic_slime = mob:Metallic Slime
g03 examine - | フェローに話してから???を調べ、だいじなもの「宵のみずかね」をもらう | フェローはここで帰る。 | K 宵のみずかね
g04 talk - | ジュノ上層のLuto Mewrilahに話す | - | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g05 examine - | 龍王ランペールの墓から入るジャグナー森林(G-5)の???を調べて完了 | 親密度の上限が70になる。 | @ジャグナー森林 G-5 | T obj.104.???_G-5 = obj:???@ジャグナー森林 G-5

@ quest.jeuno.032 https://wiki.ffo.jp/html/5847.html
Q Past Reflection | 双対の力 | no | T npc.244.Luto_Mewrilah
LK quest:クエスト「導かれるもの」をコンプリート
LK condition:フェローとの親密度30以上
g01 talk - | ジュノ上層(G-8)のLuto Mewrilahに話して受ける | - | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g02 talk - | ウィンダス水の区(G-8)目の院の図書館で、院長Tosuka-Porikaに話す | 研究員Ritopopoから、食べ物6品を頼まれる。 | @ウィンダス水の区 G-8 | T npc.238.Tosuka-Porika
g03 gather - | 白パン・白身魚のシチュー・ウィンダス風サラダ・バイソンステーキ・雪山のロランベリー・サンドリアティーを1個ずつ用意する | お金と手間がかかる。 | N 白パン*1,白身魚のシチュー*1,ウィンダス風サラダ*1,バイソンステーキ*1,雪山のロランベリー*1,サンドリアティー*1
g04 trade - | 6品をすべてTosuka-Porikaに渡す | - | @ウィンダス水の区 G-8 | T npc.238.Tosuka-Porika | N 白パン*1,白身魚のシチュー*1,ウィンダス風サラダ*1,バイソンステーキ*1,雪山のロランベリー*1,サンドリアティー*1
g05 talk - | ジュノ上層のLuto Mewrilahに話す | - | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g06 talk - | ジュノ港(J-8)チョコボサーキット入口前のKhumo Daramastehに話して完了 | - | @ジュノ港 J-8 | T npc.246.Khumo_Daramasteh = npc:Khumo Daramasteh@ジュノ港 J-8

@ quest.jeuno.033 https://wiki.ffo.jp/html/37562.html
Q The Flying Machine of Eld | 古代の飛翔機 | no | T npc.244.Jeridade = npc:Jeridade@ジュノ上層 G-7
RW key_item:♪レヴィデイス
LK quest:クエスト「ライドオン！」をコンプリート
LK condition:ジラートミッション「1万年の夢の終わりに」まで進んでいる
g01 go - | 条件を満たしてジュノ上層(G-7)のチョコボ厩舎へ行き、イベントを見る | 前のクエストのあと、一度エリアを出入りする必要があることがある。 | @ジュノ上層 G-7
g02 fight - | 上位ミッションのバトルフィールド「★宿星の座」で勝ち、だいじなもの「壊れた飛翔機」をもらう | 難易度はどれでもよい。 | K 壊れた飛翔機
g03 talk - | ジュノ上層(G-7)のMapitotoに話す | - | @ジュノ上層 G-7 | T npc.244.Mapitoto
g04 examine - | フェ・インMAP[1](G-6)の謎の装置（Strange Apparatus）を調べる | 地下(H-9)へ降りるか、ホームポイント#2から行き、MAP[2](E-7)から上がって(G/H-6)の幻の壁を抜けた先。 | @フェ・イン G-6 #1 | T obj.204.Strange_Apparatus = obj:Strange Apparatus@フェ・イン G-6 #1 | E BG Wiki;https://www.bg-wiki.com/ffxi/The_Flying_Machine_of_Eld;装置の場所 MAP1 G-6 と行き方
g05 examine - | ヴェ・ルガノン宮殿のTreasure Cofferを開け、だいじなもの「浮遊機関」をもらう | パーティの誰かが開ければ全員もらえるが、開けた人が条件を満たしていない（もう♪レヴィデイスを持っている等）と誰ももらえない。 | @ヴェ・ルガノン宮殿 | K 浮遊機関
g06 examine - | 上級技官以上の資格がある状態で、フェ・インの謎の装置を調べる | 資格はフェ・イン以外の謎の装置で取る。フェ・イン以外の装置にアイテムを渡すと無くなる。 | @フェ・イン G-6 #1 | T obj.204.Strange_Apparatus | E BG Wiki;https://www.bg-wiki.com/ffxi/The_Flying_Machine_of_Eld;資格はフェ・イン以外の装置で取ること、他の装置にトレードすると失う
g07 trade - | 謎の装置に「グリーンチップ」と「インフィニティコア」をトレードする | - | @フェ・イン G-6 #1 | T obj.204.Strange_Apparatus | N グリーンチップ*1,インフィニティコア*1
g08 trade - | 続けて「クリスタルの塊」38個をトレードし、だいじなもの「稼働し始めた浮遊機関」をもらう | 属性は混ざっていてよい。 | @フェ・イン G-6 #1 | T obj.204.Strange_Apparatus | N クリスタルの塊*38 | E BG Wiki;https://www.bg-wiki.com/ffxi/The_Flying_Machine_of_Eld;塊の属性はどれでもよい
g09 talk - | ジュノ上層(G-7)のMapitotoに話して完了 | ♪レヴィデイス。 | @ジュノ上層 G-7 | T npc.244.Mapitoto | K 稼働し始めた浮遊機関

@ quest.jeuno.034 https://wiki.ffo.jp/html/5939.html
Q Blessed Radiance | 天光 | no | T npc.244.Luto_Mewrilah
RW other:フェローの親密度の上限が90になる
LK quest:クエスト「冥闇」をコンプリート
LK condition:フェローとの親密度70以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Blessed_Radiance;親密度の上限が90になる
g01 talk - | ジュノ上層(G-8)のLuto Mewrilahに話して受ける | - | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g02 examine - | ジュノ下層(J-7)海神楼の、入ってすぐ左の扉（Door: Neptune's Spire）を調べる | - | @ジュノ下層 J-7 | T obj.245.Door_Neptunes_Spire = obj:Door: Neptune's Spire@ジュノ下層 J-7
g03 gather - | フェローを呼んだ状態で、シャクラミの地下迷宮のExcavation Pointをつるはしで掘り、だいじなもの「霞のきらら」をもらう | フェローはシグナルパールかタクティクスパールで毎回呼ぶ。マウント・呼び出しチョコボなら消えないが、フィールドのチョコガールで乗ると消える。 | @シャクラミの地下迷宮 | N つるはし*1 | K 霞のきらら
g04 gather - | フェローを呼んだ状態で、ジャグナー森林のLogging Pointをまさかりで切り、だいじなもの「靄の香木」をもらう | - | @ジャグナー森林 | N まさかり*1 | K 靄の香木
g05 gather - | フェローを呼んだ状態で、ギデアスのHarvesting Pointを草刈鎌で刈り、だいじなもの「霧の香草」をもらう | - | @ギデアス | N 草刈鎌*1 | K 霧の香草
g06 examine - | ボスディン氷河に入ってイベントを見たあと、いちばん北の(J-7)のMirror Pondを調べる | 3つのだいじなものがそろっていること。 | @ボスディン氷河 J-7 | T obj.111.Mirror_Pond_J-7 = obj:Mirror Pond@ボスディン氷河 J-7 | K 霞のきらら,靄の香木,霧の香草
g07 examine - | ジュノ下層の海神楼の扉をもう一度調べる | - | @ジュノ下層 J-7 | T obj.245.Door_Neptunes_Spire
g08 talk - | ジュノ上層のLuto Mewrilahに話して完了 | - | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah

@ quest.jeuno.035 https://wiki.ffo.jp/html/18167.html
Q Save My Sister | 姉ちゃんを助けて | no | T npc.244.Baudin
RW gil:3000ギル
RW item:ホーリーメイス
RW title:エクソシスト見習い
LK quest:クエスト「ダボイ村の紋章」をコンプリート
XS BG Wiki;https://www.bg-wiki.com/ffxi/Save_My_Sister;Brazier の座標（F-9→H-7→F-7→H-9）
g01 talk - | ジュノ上層(H-9)のMailloquetatに話す | 受けてもオファーリストには出ない（クリア後はコンプリートに載る）。 | @ジュノ上層 H-9 | T npc.244.Mailloquetat = npc:Mailloquetat@ジュノ上層 H-9
g02 talk - | ジュノ上層(G-8)のBaudinに話す | - | @ジュノ上層 G-8 | T npc.244.Baudin
g03 talk - | ル・ルデの庭(G-7)のNeraf-Najirufに話し、だいじなもの「ジュノ親衛隊のランタン」を借りる | 1回でもらえないときはもう一度話す。 | @ル・ルデの庭 G-7 | T npc.243.Neraf-Najiruf = npc:Neraf-Najiruf@ル・ルデの庭 G-7 | E BG Wiki;https://www.bg-wiki.com/ffxi/Save_My_Sister;2回話す必要があることがある
g04 examine - | バタリア丘陵(I-10)から入るエルディーム古墳で、4つのBrazierを南西(F-9)、北東(H-7)、北西(F-7)、南東(H-9)の順に調べる | 順番を間違えるとランタンに火がつかない。 | @エルディーム古墳 | T obj.195.Brazier = obj:Brazier~@エルディーム古墳 | K ジュノ親衛隊のランタン
g05 talk - | ジュノ上層のBaudinに話して完了 | 3000ギルとホーリーメイス。ランタンはNeraf-Najirufに話すと返せる（返さなくてもよい）。 | @ジュノ上層 G-8 | T npc.244.Baudin

@ quest.jeuno.036 https://wiki.ffo.jp/html/5936.html
Q Mirror, Mirror | 導かれるもの | no | T npc.244.Luto_Mewrilah
RW item:シグナルパール
RW other:フェローを呼び出せるようになる
RW title:導となる者
LK quest:クエスト「少女と鏡」をコンプリートし、エリアチェンジしている
g01 talk - | ジュノ上層(G-8)のLuto Mewrilahに話して受ける | 「少女と鏡」のあと一度エリアを出入りしてから。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g02 talk - | サンドリア港(H-9)のPortaureに話す | - | @サンドリア港 H-9 | T npc.232.Portaure
g03 fight - | ゲルスバ野営陣(F-10)のHut Doorを調べ、バトルフィールドでドラゴン族NM「Carrion Dragon」を倒す | Lv40制限・15分・3人まで、フェイス不可。少し戦うとフェローが助けに来る。レベルが低めでもソロで勝てるが、石化に注意。 | @ゲルスバ野営陣 F-10 | T mob.140.Carrion_Dragon = mob:Carrion Dragon@ゲルスバ野営陣 F-10
g04 talk - | ジュノ上層のLuto Mewrilahに話して完了 | シグナルパールをもらい、フェローを呼べるようになる。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah

@ quest.jeuno.037 https://wiki.ffo.jp/html/5967.html
Q Girl in the Looking Glass | 少女と鏡 | no | T npc.244.Luto_Mewrilah
LK quest:クエスト「其の者の名は」をコンプリートし、エリアチェンジしている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Girl_in_the_Looking_Glass;入口はバタリア丘陵(G-8)、???はエルディーム古墳MAP2の(F-9)
g01 talk - | ジュノ上層(G-8)のLuto Mewrilahに話して受ける | 「其の者の名は」のあと一度エリアを出入りしてから。依頼主はLaurana。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g02 talk - | ジュノ上層(F-5)のBheemに話す | - | @ジュノ上層 F-5 | T npc.244.Bheem
g03 examine - | バタリア丘陵(G-8)からエルディーム古墳に入り、少し進んだ(F-9)の???を調べる | - | @エルディーム古墳 F-9 #2 | T obj.195.???_F-9 = obj:???@エルディーム古墳 F-9 #2
g04 fight - | 出てくるスケルトン族NM「Namorodo」をフェローと倒す | Lv30ほどで倒せる。フェイスは???を調べる前に呼んでおく（パーティに空きがないとフェイスが消える）。 | @エルディーム古墳 F-9 #2 | T mob.195.Namorodo = mob:Namorodo@エルディーム古墳 F-9 #2
g05 talk - | 倒したらすぐにフェローに話す | 話す前にフェローが消えたら、エリアを出入りして???からやり直す。 | @エルディーム古墳 F-9 #2
g06 talk - | ジュノ上層のLuto Mewrilahに話して完了 | - | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah

@ quest.jeuno.038 https://wiki.ffo.jp/html/5044.html
Q Lure of the Wildcat (Jeuno) | 山猫の招待 | no | T npc.244.Ajithaam = npc:Ajithaam@ジュノ上層 F-5
RW key_item:白色の招待券
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/Lure_of_the_Wildcat_(Jeuno);Ajithaam の座標 F-5（用語辞典は G-5）
g01 talk - | ジュノ上層(F-5)工房橋のAjithaamに話して受ける | だいじなもの「白色の山猫バッジ」を付けられる。 | @ジュノ上層 F-5 | T npc.244.Ajithaam
g02 talk - | ジュノ上層の5人に話す：Sibila-Mobla(G-7)、Shiroro(G-8)民家、Luto Mewrilah(G-8)、Hinda(H-9)女神聖堂、Renik(H-9) | Sibila-MoblaとShiroroは歩き回っている。 | @ジュノ上層 G-8
g03 talk - | ル・ルデの庭の5人に話す：Crooked Arrow(G-8)・Adolie(G-7)・Yavoraile(I-6)・Muhoho(H-7)・Albiona(H-9) | Adolieは大公宮1階の詰め所、Yavoraileは1階の客間で歩き回る、Muhohoは2階のベランダ。 | @ル・ルデの庭 H-7
g04 talk - | ジュノ下層の5人に話す：Sutarara(J-7)海神楼・Saprut(I-7)・Bluffnix(H-9)・Naruru(H-10)・Gurdern(G-10) | Bluffnixはジャンク屋マックビクス、Naruruは下の階の民家。 | @ジュノ下層 H-9
g05 talk - | ジュノ港の5人に話す：Red Ghost(G-8)・Karl(H-8)・Shami(H-8)・Rinzei(I-8)・Sagheera(J-8) | Red Ghostは歩き回っている。全員通りにいる。 | @ジュノ港 H-8
g06 talk - | Ajithaamに話して完了 | バッジを返し、だいじなもの「白色の招待券」をもらう。アトルガンで傭兵になるときの報酬が増える。 | @ジュノ上層 F-5 | T npc.244.Ajithaam

@ quest.jeuno.039 https://wiki.ffo.jp/html/13223.html
Q Mixed Signal | 心のシグナル | no | T npc.244.Ratoto = npc:Ratoto@ジュノ上層 I-10
RW other:フェローのレベル上限が65になる
RW title:助け合う者
LK quest:クエスト「ふたりの想い」をコンプリート
LK condition:フェローがLv56以上、親密度80以上、シグナルパールをマイバッグに入れている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mixed_Signal;Raimbroy は E-8 と F-8 の境目（このページは E-8、The Sweetest Things は F-8）
g01 talk - | ジュノ上層(I-10)のRatotoに話して受ける | シグナルパールをマイバッグに入れておく。 | @ジュノ上層 I-10 | T npc.244.Ratoto
g02 talk - | ジュノ上層(G-8)のLuto Mewrilahに話す | - | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g03 talk - | 南サンドリア(E-8/F-8)のRaimbroyに話す | 2マスの境目。 | @南サンドリア E-8/F-8 | T npc.230.Raimbroy
g04 talk - | Luto Mewrilahに話す | - | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g05 examine - | クゥルンの大伽藍(I-7)（いちばん奥から入る側）の???を調べる | 行き方は限界クエスト「風の行方は」のベドー編と同じ。 | @クゥルンの大伽藍 I-7 | T obj.cathedral.???_I-7 = obj:???@クゥルンの大伽藍 I-7
g06 talk - | Luto Mewrilahに話して完了 | フェローのレベル上限が65に。フェローから自家製料理ももらえる。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah

@ quest.jeuno.040 https://wiki.ffo.jp/html/23795.html
Q A Trial in Tandem | 捲土重来 | no | T npc.244.Luto_Mewrilah
RW other:フェローのレベル上限が75になる
LK quest:クエスト「竜虎相搏つ」をコンプリート
LK condition:フェローがLv66以上、メイジャンの試練帖を持っている
g01 talk - | ジュノ上層(G-8)のLuto Mewrilahに話して受ける | だいじなもの「メイジャンからの招待状」をもらう。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g02 talk - | ル・ルデの庭(H-5)のメイジャン・オレンジ（武器のMagian Moogle）に話し、「阿吽の首飾り」を受け取る | 首飾りを無くしたら、ここで話すとまたもらえる（試練は最初から）。 | @ル・ルデの庭 H-5 | T npc.243.Magian_Moogle_Orange = npc:Magian Moogle (Orange)@ル・ルデの庭 H-5
g03 trade - | メイジャン・ブルー（防具のMagian Moogle）に「阿吽の首飾り」をトレードし、試練No.4444を受ける | - | @ル・ルデの庭 H-5 | T npc.243.Magian_Moogle_Blue = npc:Magian Moogle (Blue)@ル・ルデの庭 H-5 | N 阿吽の首飾り*1
g04 defeat - | 「阿吽の首飾り」を装備して、フェローに経験値が入る敵を30体倒す | 首飾りはLv75から装備できる。装備していないと数えられない。 | N 阿吽の首飾り*1
g05 trade - | メイジャン・ブルーに「阿吽の首飾り」をトレードし、「カッパーミード」にしてもらう | - | @ル・ルデの庭 H-5 | T npc.243.Magian_Moogle_Blue | N 阿吽の首飾り*1
g06 trade - | Luto Mewrilahに「カッパーミード」をトレードして完了 | フェローのレベル上限が75に。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah | N カッパーミード*1

@ quest.jeuno.041 https://wiki.ffo.jp/html/11568.html
Q The Clockmaster | 時計塔と青年 | no | T obj.244.Door_House_G-7 = obj:Door: House@ジュノ上層 G-7
RW gil:1200ギル
RW item:タイムハンマー
RW title:時の旅人
LK quest:クエスト「署名を集めろ」をコンプリート
g01 examine - | 「署名を集めろ」のあと、ジュノ上層(G-7)のGalmutの家の扉（Door: House）を調べ、イベントを見て完了 | 1200ギルとタイムハンマー。あとでColletに話すと短いイベントがある。 | @ジュノ上層 G-7 | T obj.244.Door_House_G-7

@ quest.jeuno.042 https://wiki.ffo.jp/html/6551.html
Q Path of the Beastmaster | 獣使いジョブゲット | no | T npc.244.Brutus
RW other:獣使いにジョブチェンジできるようになる
RW title:モンスター調教師
LK quest:クエスト「息子に罪はない」をコンプリート
g01 talk - | ジュノ上層(G-7)チョコボ厩舎のBrutusに話し、イベントを見て完了 | 「逃げだしたチョコボ」の途中だとそちらの話が先に出るので、もう一度話す。獣使いになれる。 | @ジュノ上層 G-7 | T npc.244.Brutus

@ quest.jeuno.043 https://wiki.ffo.jp/html/15315.html
Q Clash of the Comrades | 竜虎相搏つ | no | T npc.244.Luto_Mewrilah
RW other:フェローのレベル上限が70になる
RW title:高め合う者
LK quest:クエスト「心のシグナル」をコンプリート
LK condition:フェローがLv61以上、親密度100
g01 talk - | ジュノ上層(G-8)のLuto Mewrilahに話し、依頼を承諾して受ける | イベントが出ないときはAjahkeemにも話してみる。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah | E BG Wiki;https://www.bg-wiki.com/ffxi/Clash_of_the_Comrades;イベントが出ないときはAjahkeemに話す
g02 fight - | フェ・イン(K-8)からク・ビアの闘技場に入り、自分のフェローと一騎打ちで勝って完了 | 1人・10分・レベル制限なし・強化の持ち込み不可。相手はLv75くらいの強さで、自分のジョブで相手のジョブが決まる。1発のダメージは200くらいで止まるので多段攻撃が有効。HPが減ると相手もSPアビを使う。 | @フェ・イン K-8 | T mob.kuhbia.Fellow = mob:Fellow~@ク・ビアの闘技場

@ quest.jeuno.044 https://wiki.ffo.jp/html/7034.html
Q Chocobo on the Loose! | 逃げだしたチョコボ | no | T npc.244.Brutus
RW item:チョコボの卵（わずかに温かい）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Chocobo_on_the_Loose!;Chocobo Tracks は (E-5) の北西の端、(E-4) のすぐ南
g01 talk - | ジュノ上層(G-7)チョコボ厩舎のBrutusに話し、「はい」を選んで受ける | 育成は三国のVCS上級調教師からでも始められるので、卵のあてがない人向け。 | @ジュノ上層 G-7 | T npc.244.Brutus
g02 examine - | ラテーヌ高原の北西、山肌沿いの(E-4/E-5)にあるChocobo Tracksを調べる | アビセア-ラテーヌへの転送の近く。 | @ラテーヌ高原 E-4/E-5 | T obj.102.Chocobo_Tracks = obj:Chocobo Tracks@ラテーヌ高原 E-4/E-5
g03 talk - | ジュノ上層のBrutusに話す | - | @ジュノ上層 G-7 | T npc.244.Brutus
g04 talk - | 南サンドリア(I-11)のHantileonに話し、「サンドリアとジュノのチョコボを引き合わせる」を選ぶ | 最初は他の選択肢を一通り選ばされる。 | @南サンドリア I-11 | T npc.230.Hantileon = npc:Hantileon@南サンドリア I-11
g05 talk - | ジュノ上層のBrutusに話す | ここで卵をもらえて完了することもある。 | @ジュノ上層 G-7 | T npc.244.Brutus
g06 talk - | ヴァナ時間の0時を過ぎてからエリアを出入りし、Brutusに話してチョコボの卵をもらう | 前の手順で完了していればこの手順はない。ログアウトし直しでは出ない。 | @ジュノ上層 G-7 | T npc.244.Brutus | W ヴァナ時間の0時を過ぎてから

@ quest.jeuno.045 https://wiki.ffo.jp/html/5049.html
Q Scattered into Shadow | 闇に散りしものたち | no | T npc.244.Brutus
RW item:ビーストゲートル
LK quest:クエスト「黄金の羽根を残して」をコンプリート
g01 talk - | ジュノ上層(G-7)チョコボ厩舎のBrutusに話して受ける | だいじなもの「水中花」を3個預かる。 | @ジュノ上層 G-7 | T npc.244.Brutus
g02 examine - | フェ・イン地下の(H-5)と(H-8)の池を調べる | 順番は自由。 | @フェ・イン H-5 | T obj.204.Pool = obj:Pool~@フェ・イン | K 水中花
g03 fight - | フェ・イン地下の(F-5)の池を調べ、ゴースト族NM「Dabotz's Ghost」を倒す | 闇とサイレスに強い。スニークで調べると絡まれないが、低い位置に出るので近づくと絡んでくる。Lv75ほどのソロ向きジョブなら勝てる。 | @フェ・イン F-5 | T mob.204.Dabotzs_Ghost = mob:Dabotz's Ghost@フェ・イン F-5
g04 examine - | (F-5)の池をもう一度調べる | - | @フェ・イン F-5 | T obj.204.Pool
g05 talk - | ジュノ上層のBrutusに報告する | 次はオズトロヤ城のオポオポの霊を頼まれる。 | @ジュノ上層 G-7 | T npc.244.Brutus
g06 gather - | オズトロヤ城のTreasure Chestを開けて「獣の首輪」を手に入れる | 獣人城塞の箱のカギはYagudo Zealot・Yagudo Lutenist・Yagudo Conquistador・Yagudo Priorが落とす。星唄の煌めき【一奏】があれば三国のCurio Vendor Moogleでも買える。獣使いでなくてよい。 | @オズトロヤ城 | N 獣人城塞の箱のカギ*1
g07 trade - | オズトロヤ城MAP[1](G-8)あたりを歩くオポオポのTebhiに「獣の首輪」をトレードする | 1階(J-8)→2階(G-7)→2階テラス(I-7)と進んだ先。渡すと消えるので、先を越されたら次に出るまで待つ。 | @オズトロヤ城 G-8 #1 | T npc.151.Tebhi = npc:Tebhi!@オズトロヤ城 G-8 #1 | N 獣の首輪*1
g08 talk - | ジュノ上層のBrutusに報告して完了 | ビーストゲートル。 | @ジュノ上層 G-7 | T npc.244.Brutus

@ quest.jeuno.046 https://wiki.ffo.jp/html/25903.html
Q A Trial in Tandem Revisited | 阿吽の試練・伍式 | no | T npc.244.Luto_Mewrilah
RW other:フェローのレベル上限が99になる
LK quest:クエスト「阿吽の試練・肆式」をコンプリート
LK condition:フェローがLv86以上、メイジャンの試練帖を持っている
g01 talk - | ジュノ上層(G-8)のLuto Mewrilahに話して受ける | だいじなもの「メイジャンからの招待状」をもらう。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g02 talk - | ル・ルデの庭(H-5)のメイジャン・オレンジに話し、「阿吽の首飾り・伍式」を受け取る | - | @ル・ルデの庭 H-5 | T npc.243.Magian_Moogle_Orange
g03 trade - | メイジャン・ブルーに「阿吽の首飾り・伍式」をトレードし、試練No.5054を受ける | - | @ル・ルデの庭 H-5 | T npc.243.Magian_Moogle_Blue | N 阿吽の首飾り・伍式*1
g04 defeat - | 「阿吽の首飾り・伍式」を装備して、アンデッド類でフェローに経験値が入る敵に、フェローがウェポンスキルを30回使う | 1回で2回分数えられることがある。 | N 阿吽の首飾り・伍式*1
g05 trade - | メイジャン・ブルーに「阿吽の首飾り・伍式」をトレードし、「ゴールドミード」にしてもらう | - | @ル・ルデの庭 H-5 | T npc.243.Magian_Moogle_Blue | N 阿吽の首飾り・伍式*1
g06 trade - | Luto Mewrilahに「ゴールドミード」と「魔人印章」20個を一緒にトレードして完了 | フェローのレベル上限が99に。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah | N ゴールドミード*1,魔人印章*20

@ quest.jeuno.047 https://wiki.ffo.jp/html/23831.html
Q Yet Another Trial in Tandem | 阿吽の試練・参式 | no | T npc.244.Luto_Mewrilah
RW other:フェローのレベル上限が85になる
LK quest:クエスト「阿吽の試練・弐式」をコンプリート
LK condition:フェローがLv76以上、メイジャンの試練帖を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Yet_Another_Trial_in_Tandem;試練No.4446の目標
g01 talk - | ジュノ上層(G-8)のLuto Mewrilahに話して受ける | だいじなもの「メイジャンからの招待状」をもらう。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g02 talk - | ル・ルデの庭(H-5)のメイジャン・オレンジに話し、「阿吽の首飾り・参式」を受け取る | - | @ル・ルデの庭 H-5 | T npc.243.Magian_Moogle_Orange
g03 trade - | メイジャン・ブルーに「阿吽の首飾り・参式」をトレードし、試練No.4446を受ける | - | @ル・ルデの庭 H-5 | T npc.243.Magian_Moogle_Blue | N 阿吽の首飾り・参式*1
g04 defeat - | 「阿吽の首飾り・参式」を装備して、フェローに経験値が入る敵に、フェローがウェポンスキルを20回当てる | 当たらないと数えない。ムーンライト・スターライトは数えないので、フェローに片手棍を持たせない。 | N 阿吽の首飾り・参式*1 | E BG Wiki;https://www.bg-wiki.com/ffxi/Yet_Another_Trial_in_Tandem;試練の目標
g05 trade - | メイジャン・ブルーに「阿吽の首飾り・参式」をトレードし、「ミスリルミード」にしてもらう | - | @ル・ルデの庭 H-5 | T npc.243.Magian_Moogle_Blue | N 阿吽の首飾り・参式*1
g06 trade - | Luto Mewrilahに「ミスリルミード」をトレードして完了 | フェローのレベル上限が85に。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah | N ミスリルミード*1

@ quest.jeuno.048 https://wiki.ffo.jp/html/23830.html
Q A Trial in Tandem, Redux | 阿吽の試練・弐式 | no | T npc.244.Luto_Mewrilah
RW other:フェローのレベル上限が80になる
LK quest:クエスト「捲土重来」をコンプリート
LK condition:フェローがLv71以上、メイジャンの試練帖を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Trial_in_Tandem,_Redux;試練No.4445の目標
g01 talk - | ジュノ上層(G-8)のLuto Mewrilahに話して受ける | だいじなもの「メイジャンからの招待状」をもらう。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g02 talk - | ル・ルデの庭(H-5)のメイジャン・オレンジに話し、「阿吽の首飾り・弐式」を受け取る | - | @ル・ルデの庭 H-5 | T npc.243.Magian_Moogle_Orange
g03 trade - | メイジャン・ブルーに「阿吽の首飾り・弐式」をトレードし、試練No.4445を受ける | - | @ル・ルデの庭 H-5 | T npc.243.Magian_Moogle_Blue | N 阿吽の首飾り・弐式*1
g04 defeat - | 「阿吽の首飾り・弐式」を装備して、フェローに経験値が入る鳥類の敵を25体倒す | フェローを連れていること。 | N 阿吽の首飾り・弐式*1 | E BG Wiki;https://www.bg-wiki.com/ffxi/A_Trial_in_Tandem,_Redux;試練の目標
g05 trade - | メイジャン・ブルーに「阿吽の首飾り・弐式」をトレードし、「シルバーミード」にしてもらう | - | @ル・ルデの庭 H-5 | T npc.243.Magian_Moogle_Blue | N 阿吽の首飾り・弐式*1
g06 trade - | Luto Mewrilahに「シルバーミード」をトレードして完了 | フェローのレベル上限が80に。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah | N シルバーミード*1

@ quest.jeuno.049 https://wiki.ffo.jp/html/24834.html
Q A Quaternary Trial in Tandem | 阿吽の試練・肆式 | no | T npc.244.Luto_Mewrilah
RW other:フェローのレベル上限が90になる
LK quest:クエスト「阿吽の試練・参式」をコンプリート
LK condition:フェローがLv81以上、メイジャンの試練帖を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Quaternary_Trial_in_Tandem;試練No.4449の目標
g01 talk - | ジュノ上層(G-8)のLuto Mewrilahに話して受ける | だいじなもの「メイジャンからの招待状」をもらう。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah
g02 talk - | ル・ルデの庭(H-5)のメイジャン・オレンジに話し、「阿吽の首飾り・肆式」を受け取る | - | @ル・ルデの庭 H-5 | T npc.243.Magian_Moogle_Orange
g03 trade - | メイジャン・ブルーに「阿吽の首飾り・肆式」をトレードし、試練No.4449を受ける | - | @ル・ルデの庭 H-5 | T npc.243.Magian_Moogle_Blue | N 阿吽の首飾り・肆式*1
g04 defeat - | 「阿吽の首飾り・肆式」を装備して、フェローに経験値が入る虫類（Vermin）の敵に、フェローがウェポンスキルを20回当てる | 当たらないと数えない。ムーンライト・スターライトは数えない。 | N 阿吽の首飾り・肆式*1 | E BG Wiki;https://www.bg-wiki.com/ffxi/A_Quaternary_Trial_in_Tandem;試練の目標
g05 trade - | メイジャン・ブルーに「阿吽の首飾り・肆式」をトレードし、「ダークミード」にしてもらう | - | @ル・ルデの庭 H-5 | T npc.243.Magian_Moogle_Blue | N 阿吽の首飾り・肆式*1
g06 trade - | Luto Mewrilahに「ダークミード」をトレードして完了 | フェローのレベル上限が90に。 | @ジュノ上層 G-8 | T npc.244.Luto_Mewrilah | N ダークミード*1

@ quest.jeuno.050 https://wiki.ffo.jp/html/8573.html
Q Wings of Gold | 黄金の羽根を残して | no | T npc.244.Brutus
RW item:バルバロイアクス
LK condition:獣使いLv40以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Wings_of_Gold;箱はデルクフの塔上層、カギを落とす敵
g01 talk - | 獣使いLv40以上で、ジュノ上層(G-7)チョコボ厩舎のBrutusに話して受ける | 獣使いである必要があるのは受けるときだけ。「逃げだしたチョコボ」の途中ならもう一度話す。 | @ジュノ上層 G-7 | T npc.244.Brutus
g02 gather - | デルクフの塔上層（7〜10階）の敵を倒して「Delkfutt Chest Key」を手に入れる | Gigas Wallwatcher・Gigas Kettlemaster・Evil Spirit・Gigas Spirekeeper・Gigas Torturer・Gigas Bonecutterが落とす。Curio Vendor Moogleでも買える。 | @デルクフの塔上層 | N Delkfutt Chest Key*1 | T mob.158.Gigas_Wallwatcher = mob:Gigas Wallwatcher@デルクフの塔上層 | E BG Wiki;https://www.bg-wiki.com/ffxi/Wings_of_Gold;カギを落とす敵と階
g03 examine - | デルクフの塔上層のTreasure Chestを開け、だいじなもの「迷わずの鈴」をもらう | Lv40そこそこだと大変なので、他のジョブで行ってもよい。 | @デルクフの塔上層 | K 迷わずの鈴
g04 talk - | ジュノ上層のBrutusに話して完了 | バルバロイアクス。 | @ジュノ上層 G-7 | T npc.244.Brutus

@ quest.jeuno.051 https://wiki.ffo.jp/html/6992.html
Q Never to Return | なくしものはなんですか | yes | T npc.245.Kurou-Morou = npc:Kurou-Morou@ジュノ下層 I-7
RW gil:1200ギル
RW item:ガーネットリング
LK fame:名声ランク5以上
LK quest:クエスト「マイ占い玉を作ろう！」クリア
LK condition:Kurou-Morouの占いをヴァナ時間で1日1回、3日に分けて3回以上受ける
XS BG Wiki;https://www.bg-wiki.com/ffxi/Never_to_Return;名声ランク5（用語辞典に記載なし）
g01 talk - | ジュノ下層(I-7)2階の占い屋のKurou-Morouに占ってもらう | ヴァナ時間で1日1回。日を変えて3回受ける。 | @ジュノ下層 I-7 | T npc.245.Kurou-Morou
g02 talk - | ヴァナ時間の日付が変わってからKurou-Morouに話して受ける | ゴミの日に「角の髪飾り」を捨ててしまったらしい。 | @ジュノ下層 I-7 | T npc.245.Kurou-Morou | W ヴァナ時間の日付が変わってから
g03 gather - | 頭装備「角の髪飾り」を1個用意する | 合成でしか作れないが競売にも出る。HQの角の髪飾り+1は受け取ってもらえない。 | N 角の髪飾り*1 | E BG Wiki;https://www.bg-wiki.com/ffxi/Never_to_Return;合成品で競売でも買える
g04 trade - | Kurou-Morouに「角の髪飾り」をトレードして完了 | 1200ギルとガーネットリング。 | @ジュノ下層 I-7 | T npc.245.Kurou-Morou | N 角の髪飾り*1

@ quest.jeuno.052 https://wiki.ffo.jp/html/6100.html
Q Wonder Magic Set | ひみつ魔術セット | no | T npc.245.Panta-Putta
RW item:ミスリルピアス
LK fame:名声ランク4以上
g01 talk - | ジュノ下層(H-10)の商家のPanta-Puttaに話して受ける | 家族には内緒にしてほしいらしい。 | @ジュノ下層 H-10 | T npc.245.Panta-Putta
g02 talk - | ジュノ港のKarlからクエスト「子供との取引」を受けて進め、だいじなもの「ひみつ魔術セット」を手に入れる | - | @ジュノ港 H-8 | T npc.246.Karl | K ひみつ魔術セット
g03 talk - | Panta-Puttaに話して完了 | ミスリルピアス。続きは「子供との取引」。 | @ジュノ下層 H-10 | T npc.245.Panta-Putta | K ひみつ魔術セット

@ quest.jeuno.053 https://wiki.ffo.jp/html/4021.html
Q The Road to Aht Urhgan | アトルガン皇国へ | no | T npc.245.Faursel = npc:Faursel@ジュノ下層 J-8
RW key_item:渡航免状
RW other:ギル払いのときはワジャーム樹林へのテレポと、だいじなもの「ワジャーム樹林地図」も
LK condition:アトルガンの秘宝の拡張コンテンツ登録が済んでいる
LK quest:クエスト「天晶堂入会」クリア（Faurselは天晶堂の中にいる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Road_to_Aht_Urhgan;Faursel の座標 J-8（用語辞典は J-7）
g01 talk - | 天晶堂(J-8)のFaurselに話して受け、「下級」「中級」「上級」「ギル」から1つ選ぶ | 星唄ミッション第2章「逃れられぬ運命」を受けていれば「テンゼンは？」も選べる。 | @ジュノ下層 J-8 | T npc.245.Faursel | > a01,b01,c01,d01,e01
a01 gather - | 【下級】「ガガンボの腹虫」「陸ガニのふんどし」「呪われたサレコウベ」「野兎の尻尾」「ダルメルの唾液」「血染めの衣」を1個ずつ用意する | 目安Lv18〜。サポートジョブのクエストと同じ品。サレコウベと衣はグスゲン鉱山がよい。 | N ガガンボの腹虫*1,陸ガニのふんどし*1,呪われたサレコウベ*1,野兎の尻尾*1,ダルメルの唾液*1,血染めの衣*1 | R 下級
a02 trade - | Faurselに6つの品をトレードする | - | @ジュノ下層 J-8 | T npc.245.Faursel | N ガガンボの腹虫*1,陸ガニのふんどし*1,呪われたサレコウベ*1,野兎の尻尾*1,ダルメルの唾液*1,血染めの衣*1 | R 下級 | > g02
b01 gather - | 【中級】「翠の色報石」「銀の字刻板」「十三結節のキープス」を1個ずつ用意する | 目安Lv30〜。各獣人拠点の獣人（Lv32〜38ほど）が落とす。 | N 翠の色報石*1,銀の字刻板*1,十三結節のキープス*1 | R 中級
b02 trade - | Faurselに3つの品をトレードする | - | @ジュノ下層 J-8 | T npc.245.Faursel | N 翠の色報石*1,銀の字刻板*1,十三結節のキープス*1 | R 中級 | > g02
c01 gather - | 【上級】獣人拠点の宝のカギ1個、偉大なジョブの証1個、またはカーマイン・シアン・グレーのチップ3枚のどれかを用意する | 目安Lv55〜。宝のカギは星唄の煌めき【二奏】があればCurio Vendor Moogleで買える。証は使用済みでもよい。チップはボスディン氷河の魔法塔(I-7/G-9/H-10)。 | R 上級
c02 trade - | Faurselに用意した品をトレードする | - | @ジュノ下層 J-8 | T npc.245.Faursel | R 上級 | > g02
d01 trade - | 【ギル】Faurselに500,000ギルを渡す | このときだけワジャーム樹林へのテレポと「ワジャーム樹林地図」もつく。 | @ジュノ下層 J-8 | T npc.245.Faursel | R ギル | > g02
e01 talk - | 【テンゼン】Faurselに話して「テンゼンは？」を選び、その場で渡航免状をもらう | 星唄ミッション第2章を受けているときだけ。品もギルもいらない。 | @ジュノ下層 J-8 | T npc.245.Faursel | R テンゼン | >
g02 talk - | エリアを出入りし、ヴァナ時間の0時を過ぎてからFaurselに話して完了 | だいじなもの「渡航免状」。マウラの兵員輸送船でアルザビへ行けるようになる。 | @ジュノ下層 J-8 | T npc.245.Faursel | W ヴァナ時間の0時を過ぎてから | R 下級/中級/上級/ギル

@ quest.jeuno.054 https://wiki.ffo.jp/html/14360.html
Q The Lost Cardian | カカシがいない | no | T npc.245.Panta-Putta
RW gil:2100ギル（「はい」を選んだとき）
RW key_item:Two of Swords（カーディアン）
RW title:第一発見者
LK fame:名声ランク4以上
LK quest:クエスト「主婦のこだわり」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Lost_Cardian;名声ランク4、Teigero-Bangero の座標 H-10（用語辞典は G-10）
g01 talk - | ジュノ下層(H-10)の商家のTeigero-Bangeroに話す | Panta-Puttaの父親。オファーリストには載らない。 | @ジュノ下層 H-10 | T npc.245.Teigero-Bangero = npc:Teigero-Bangero@ジュノ下層 H-10
g02 talk - | ジュノ上層(G-10)の診療所の医師Monberauxに話して完了 | トゥーの行方がわかる。イベントが出なければもう一度話す。 | @ジュノ上層 G-10 | T npc.244.Monberaux | E BG Wiki;https://www.bg-wiki.com/ffxi/The_Lost_Cardian;イベントが出るまで何度か話すことがある

@ quest.jeuno.055 https://wiki.ffo.jp/html/1546.html
Q The Gobbiebag Part X | ゴウツバクリのかばん | no | T npc.245.Bluffnix
RW other:マイバッグの最大収納数が計80個になる
RW title:ゴウツバクリ
RW other:3国の名声が上がる
LK fame:名声ランク5以上
LK quest:クエスト「ヨバクリのかばん 4」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Gobbiebag_Part_X;名声ランク5（用語辞典の表はランク4）
g01 talk - | ジュノ下層(H-9)ジャンク屋マックビクスのBluffnixに話して受ける | 最初の話は禁断の口のこと。もう一度話すとかばんの話になる。オファーなしでトレードだけでも完了できる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | > a01,b01
a01 gather - | 「モリブデインゴット」「グリフィンなめし革」「フーラード」「エンゼルオーブ」を1個ずつ用意する | どれも競売で買える。 | N モリブデインゴット*1,グリフィンなめし革*1,フーラード*1,エンゼルオーブ*1 | R 素材
a02 trade - | Bluffnixに4つの素材をトレードして完了 | マイバッグが計80個になる。モグサッチェルも同じ数になる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N モリブデインゴット*1,グリフィンなめし革*1,フーラード*1,エンゼルオーブ*1 | R 素材 | >
b01 trade - | Bluffnixに「ゴブリンシチュー880」を1個トレードして完了 | 4つの素材の代わりになる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N ゴブリンシチュー880*1 | R シチュー | >

@ quest.jeuno.056 https://wiki.ffo.jp/html/1546.html
Q The Gobbiebag Part I | ゴブリンのかばん 1 | no | T npc.245.Bluffnix = npc:Bluffnix@ジュノ下層 H-9
RW other:マイバッグの最大収納数が計35個になる
RW other:3国の名声が上がる
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Gobbiebag_Part_I;名声ランク1（用語辞典の表はランク2）
g01 talk - | ジュノ下層(H-9)ジャンク屋マックビクスのBluffnixに話して受ける | 最初の話は禁断の口のこと。もう一度話すとかばんの話になる。オファーなしでトレードだけでも完了できる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | > a01,b01
a01 gather - | 「スチールインゴット」「ダルメルのなめし革」「亜麻布」「ペリドット」を1個ずつ用意する | どれも競売で買える。 | N スチールインゴット*1,ダルメルのなめし革*1,亜麻布*1,ペリドット*1 | R 素材
a02 trade - | Bluffnixに4つの素材をトレードして完了 | マイバッグが計35個になる。モグサッチェルも同じ数になる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N スチールインゴット*1,ダルメルのなめし革*1,亜麻布*1,ペリドット*1 | R 素材 | >
b01 trade - | Bluffnixに「ゴブリンシチュー880」を1個トレードして完了 | 4つの素材の代わりになる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N ゴブリンシチュー880*1 | R シチュー | >

@ quest.jeuno.057 https://wiki.ffo.jp/html/1546.html
Q The Gobbiebag Part II | ゴブリンのかばん 2 | no | T npc.245.Bluffnix
RW other:マイバッグの最大収納数が計40個になる
RW other:3国の名声が上がる
LK quest:クエスト「ゴブリンのかばん 1」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Gobbiebag_Part_II;名声ランク1（用語辞典の表はランク2）
g01 talk - | ジュノ下層(H-9)ジャンク屋マックビクスのBluffnixに話して受ける | 最初の話は禁断の口のこと。もう一度話すとかばんの話になる。オファーなしでトレードだけでも完了できる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | > a01,b01
a01 gather - | 「ミスリルインゴット」「雄羊のなめし革」「毛織物」「ターコイズ」を1個ずつ用意する | どれも競売で買える。 | N ミスリルインゴット*1,雄羊のなめし革*1,毛織物*1,ターコイズ*1 | R 素材
a02 trade - | Bluffnixに4つの素材をトレードして完了 | マイバッグが計40個になる。モグサッチェルも同じ数になる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N ミスリルインゴット*1,雄羊のなめし革*1,毛織物*1,ターコイズ*1 | R 素材 | >
b01 trade - | Bluffnixに「ゴブリンシチュー880」を1個トレードして完了 | 4つの素材の代わりになる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N ゴブリンシチュー880*1 | R シチュー | >

@ quest.jeuno.058 https://wiki.ffo.jp/html/1546.html
Q The Gobbiebag Part III | ゴブリンのかばん 3 | no | T npc.245.Bluffnix
RW other:マイバッグの最大収納数が計45個になる
RW other:3国の名声が上がる
LK quest:クエスト「ゴブリンのかばん 2」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Gobbiebag_Part_III;名声ランク1（用語辞典の表はランク2）
g01 talk - | ジュノ下層(H-9)ジャンク屋マックビクスのBluffnixに話して受ける | 最初の話は禁断の口のこと。もう一度話すとかばんの話になる。オファーなしでトレードだけでも完了できる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | > a01,b01
a01 gather - | 「ゴールドインゴット」「黒虎のなめし革」「ビロード」「ペイナイト」を1個ずつ用意する | どれも競売で買える。 | N ゴールドインゴット*1,黒虎のなめし革*1,ビロード*1,ペイナイト*1 | R 素材
a02 trade - | Bluffnixに4つの素材をトレードして完了 | マイバッグが計45個になる。モグサッチェルも同じ数になる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N ゴールドインゴット*1,黒虎のなめし革*1,ビロード*1,ペイナイト*1 | R 素材 | >
b01 trade - | Bluffnixに「ゴブリンシチュー880」を1個トレードして完了 | 4つの素材の代わりになる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N ゴブリンシチュー880*1 | R シチュー | >

@ quest.jeuno.059 https://wiki.ffo.jp/html/1546.html
Q The Gobbiebag Part IV | ゴブリンのかばん 4 | no | T npc.245.Bluffnix
RW other:マイバッグの最大収納数が計50個になる
RW other:3国の名声が上がる
LK quest:クエスト「ゴブリンのかばん 3」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Gobbiebag_Part_IV;名声ランク1（用語辞典の表はランク2）
g01 talk - | ジュノ下層(H-9)ジャンク屋マックビクスのBluffnixに話して受ける | 最初の話は禁断の口のこと。もう一度話すとかばんの話になる。オファーなしでトレードだけでも完了できる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | > a01,b01
a01 gather - | 「ダークインゴット」「絹布」「ゴシェナイト」「サーメットチップス」を1個ずつ用意する | どれも競売で買える。 | N ダークインゴット*1,絹布*1,ゴシェナイト*1,サーメットチップス*1 | R 素材
a02 trade - | Bluffnixに4つの素材をトレードして完了 | マイバッグが計50個になる。モグサッチェルも同じ数になる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N ダークインゴット*1,絹布*1,ゴシェナイト*1,サーメットチップス*1 | R 素材 | >
b01 trade - | Bluffnixに「ゴブリンシチュー880」を1個トレードして完了 | 4つの素材の代わりになる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N ゴブリンシチュー880*1 | R シチュー | >

@ quest.jeuno.060 https://wiki.ffo.jp/html/1546.html
Q The Gobbiebag Part V | ゴブリンのかばん 5 | no | T npc.245.Bluffnix
RW other:マイバッグの最大収納数が計55個になる
RW title:ヨバクリ
RW other:3国の名声が上がる
LK fame:名声ランク3以上
LK quest:クエスト「ゴブリンのかばん 4」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Gobbiebag_Part_V;名声ランク3（用語辞典の表はランク3）
g01 talk - | ジュノ下層(H-9)ジャンク屋マックビクスのBluffnixに話して受ける | 最初の話は禁断の口のこと。もう一度話すとかばんの話になる。オファーなしでトレードだけでも完了できる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | > a01,b01
a01 gather - | 「パクタンインゴット」「ブガードのなめし革」「モブリン織物」「ロードナイト」を1個ずつ用意する | どれも競売で買える。 | N パクタンインゴット*1,ブガードのなめし革*1,モブリン織物*1,ロードナイト*1 | R 素材
a02 trade - | Bluffnixに4つの素材をトレードして完了 | マイバッグが計55個になる。モグサッチェルも同じ数になる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N パクタンインゴット*1,ブガードのなめし革*1,モブリン織物*1,ロードナイト*1 | R 素材 | >
b01 trade - | Bluffnixに「ゴブリンシチュー880」を1個トレードして完了 | 4つの素材の代わりになる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N ゴブリンシチュー880*1 | R シチュー | >

@ quest.jeuno.061 https://wiki.ffo.jp/html/8125.html
Q Rubbish Day | ゴミのおつかい | yes | T npc.245.Chululu = npc:Chululu@ジュノ下層 I-8
RW item:チェーンチョーカー
RW gil:6,000ギル
RW title:街の掃除人
LK fame:名声ランク4以上
LK quest:クエスト「タルットカード収集」クリア
LK condition:Chululuの占いをヴァナ時間で1日1回、3日に分けて3回以上受ける
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rubbish_Day;名声ランク4（用語辞典に記載なし）
g01 talk - | ジュノ下層(I-8)2階の占い屋のChululuに話して受け、だいじなもの「魔法廃棄物」を預かる | 「占い普及大作戦！」の話なら断ってもう一度話す。 | @ジュノ下層 I-8 | T npc.245.Chululu | E BG Wiki;https://www.bg-wiki.com/ffxi/Rubbish_Day;別のクエストの話のときは断って話し直す
g02 fight - | ガルレージュ要塞のFallen Evacueeを倒して「ガルレージュのカギ」を手に入れる | 入口近くの部屋（MAP1）にいる。 | @ガルレージュ要塞 - #1 | T mob.200.Fallen_Evacuee = mob:Fallen Evacuee@ガルレージュ要塞 #1 | E BG Wiki;https://www.bg-wiki.com/ffxi/Rubbish_Day;カギは入口近くのFallen Evacueeが落とす
g03 trade - | 2つの門を抜け、ガルレージュ要塞(I-7)のCrematory Hatchに「ガルレージュのカギ」をトレードして魔法焼却場に入る | 2つ目のBanishing Gateの先。 | @ガルレージュ要塞 I-7 #3 | T obj.200.Crematory_Hatch = obj:Crematory Hatch@ガルレージュ要塞 I-7 #3 | N ガルレージュのカギ*1 | E BG Wiki;https://www.bg-wiki.com/ffxi/Rubbish_Day;2つ目のBanishing Gateの先、MAP3
g04 talk - | 魔法焼却場のMashiraに話し、「魔法廃棄物を捨てたい」を選ぶ | - | @ガルレージュ要塞 I-7 #3 | T npc.Mashira | K 魔法廃棄物
g05 talk - | ジュノ下層のChululuに話して完了 | チェーンチョーカーと6,000ギル。 | @ジュノ下層 I-8 | T npc.245.Chululu

@ quest.jeuno.062 https://wiki.ffo.jp/html/7739.html
Q Collect Tarut Cards | タルットカード収集 | no | T npc.245.Chululu
RW other:Chululuに相性占いをしてもらえる
RW title:カードコレクター
RW other:3国の名声が1.6上がる
LK fame:名声ランク2以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Collect_Tarut_Cards;名声ランク2（用語辞典はランク3）
g01 talk - | ジュノ下層(I-8)2階の占い屋のChululuに話して受け、タルットカード5枚をもらう | 愚者・亡者・王者・隠者のどれか1種類が5枚。 | @ジュノ下層 I-8 | T npc.245.Chululu
g02 gather - | ほかの冒険者とトレードするか、地球時間の0時を過ぎてからChululuにまたもらい、4種類を1枚ずつそろえる | 同じアカウントの別キャラにも宅配できない。最初のトレードは2枚と2枚の交換がよい。 | W 地球時間の0時を過ぎてから（もらい直すとき）
g03 trade - | Chululuに4種類のタルットカードをトレードして完了 | 余ったカードは「占い普及大作戦！」で使える。 | @ジュノ下層 I-8 | T npc.245.Chululu | N タルットカード愚者*1,タルットカード亡者*1,タルットカード王者*1,タルットカード隠者*1

@ quest.jeuno.063 https://wiki.ffo.jp/html/19396.html
Q Mysteries of Beadeaux I | ベドーの謎その1 | no | T npc.245.Sattal-Mansal
RW key_item:妖光の数珠
LK condition:三国ミッション「魔晶石を奪え」を受けている
g01 talk - | 天晶堂(J-8)のSattal-Mansalに話して受ける | 「ベドーの謎その2」と合わせて、クゥルンの大伽藍の奥へ入れるようになる。 | @ジュノ下層 J-8 | T npc.245.Sattal-Mansal
g02 fight - | ベドー(I-9)のクゥダフ族NM「De'Vyu Headhunter」を倒して「クゥダフの呪符」を手に入れる | - | @ベドー I-9 | T mob.147.DeVyu_Headhunter
g03 trade - | Sattal-Mansalに「クゥダフの呪符」をトレードして完了 | だいじなもの「妖光の数珠」。 | @ジュノ下層 J-8 | T npc.245.Sattal-Mansal | N クゥダフの呪符*1

@ quest.jeuno.064 https://wiki.ffo.jp/html/19397.html
Q Mysteries of Beadeaux II | ベドーの謎その2 | no | T npc.245.Sattal-Mansal
RW key_item:漆黒のマチネー
LK condition:三国ミッション「魔晶石を奪え」を受けている
g01 talk - | 天晶堂(J-8)のSattal-Mansalに話して受ける | - | @ジュノ下層 J-8 | T npc.245.Sattal-Mansal
g02 fight - | ベドー(F-6)のクゥダフ族NM「Go'Bhu Gascon」を倒して「クゥダフの卜占甲」を手に入れる | Exではないのでバザーで買ってもよい。 | @ベドー F-6 | T mob.147.GoBhu_Gascon
g03 trade - | Sattal-Mansalに「クゥダフの卜占甲」をトレードして完了 | だいじなもの「漆黒のマチネー」。 | @ジュノ下層 J-8 | T npc.245.Sattal-Mansal | N クゥダフの卜占甲*1

@ quest.jeuno.065 https://wiki.ffo.jp/html/5214.html
Q Your Crystal Ball | マイ占い玉を作ろう！ | no | T npc.245.Kurou-Morou
RW other:Kurou-Morouに占いをしてもらえる
RW title:見習い占い師
RW other:3国の名声が1.6上がる
LK fame:名声ランク2以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Your_Crystal_Ball;名声ランク2（用語辞典はランク3）
g01 talk - | ジュノ下層(I-7)2階の占い屋のKurou-Morouに話して受ける | - | @ジュノ下層 I-7 | T npc.245.Kurou-Morou
g02 fight - | Evil Eye系の敵を倒して「アーリマンのレンズ」を手に入れる | Exなので競売にはない。ラングモント峠・ボスディン氷河・ザルカバードなどにいる。 | T mob.evil_eye = mob:Evil Eye | E BG Wiki;https://www.bg-wiki.com/ffxi/Your_Crystal_Ball;アーリマンのレンズはEvil Eye系が落とす
g03 trade - | タロンギ大峡谷側から入り、シャクラミの地下迷宮(G-5)のRockwellに「アーリマンのレンズ」をトレードする | ブブリム半島側からは行けない。テンキー9のあたり。 | @シャクラミの地下迷宮 G-5 #2 | T obj.198.Rockwell = obj:Rockwell@シャクラミの地下迷宮 G-5 #2 | N アーリマンのレンズ*1
g04 examine - | 地球時間で1分待ち、Rockwellを調べて「占い玉」を手に入れる | 待つあいだにエリアを出たりログアウトしてもよい。 | @シャクラミの地下迷宮 G-5 #2 | T obj.198.Rockwell | W 地球時間で1分たってから
g05 trade - | Kurou-Morouに「占い玉」をトレードして完了 | 以後占ってもらえる。 | @ジュノ下層 I-7 | T npc.245.Kurou-Morou | N 占い玉*1

@ quest.jeuno.066 https://wiki.ffo.jp/html/1546.html
Q The Gobbiebag Part VI | ヨバクリのかばん 1 | no | T npc.245.Bluffnix
RW other:マイバッグの最大収納数が計60個になる
RW other:3国の名声が上がる
LK fame:名声ランク3以上
LK quest:クエスト「ゴブリンのかばん 5」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Gobbiebag_Part_VI;名声ランク3（用語辞典の表はランク3）
g01 talk - | ジュノ下層(H-9)ジャンク屋マックビクスのBluffnixに話して受ける | 最初の話は禁断の口のこと。もう一度話すとかばんの話になる。オファーなしでトレードだけでも完了できる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | > a01,b01
a01 gather - | 「赤銅の鋳塊」「上質なエフトの皮」「バルーンクロス」「アイオライト」を1個ずつ用意する | どれも競売で買える。 | N 赤銅の鋳塊*1,上質なエフトの皮*1,バルーンクロス*1,アイオライト*1 | R 素材
a02 trade - | Bluffnixに4つの素材をトレードして完了 | マイバッグが計60個になる。モグサッチェルも同じ数になる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N 赤銅の鋳塊*1,上質なエフトの皮*1,バルーンクロス*1,アイオライト*1 | R 素材 | >
b01 trade - | Bluffnixに「ゴブリンシチュー880」を1個トレードして完了 | 4つの素材の代わりになる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N ゴブリンシチュー880*1 | R シチュー | >

@ quest.jeuno.067 https://wiki.ffo.jp/html/1546.html
Q The Gobbiebag Part VII | ヨバクリのかばん 2 | no | T npc.245.Bluffnix
RW other:マイバッグの最大収納数が計65個になる
RW other:3国の名声が上がる
LK fame:名声ランク4以上
LK quest:クエスト「ヨバクリのかばん 1」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Gobbiebag_Part_VII;名声ランク4（用語辞典の表はランク3）
g01 talk - | ジュノ下層(H-9)ジャンク屋マックビクスのBluffnixに話して受ける | 最初の話は禁断の口のこと。もう一度話すとかばんの話になる。オファーなしでトレードだけでも完了できる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | > a01,b01
a01 gather - | 「アダマンインゴット」「リンクスの革」「虹布」「デスストーン」を1個ずつ用意する | どれも競売で買える。 | N アダマンインゴット*1,リンクスの革*1,虹布*1,デスストーン*1 | R 素材
a02 trade - | Bluffnixに4つの素材をトレードして完了 | マイバッグが計65個になる。モグサッチェルも同じ数になる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N アダマンインゴット*1,リンクスの革*1,虹布*1,デスストーン*1 | R 素材 | >
b01 trade - | Bluffnixに「ゴブリンシチュー880」を1個トレードして完了 | 4つの素材の代わりになる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N ゴブリンシチュー880*1 | R シチュー | >

@ quest.jeuno.068 https://wiki.ffo.jp/html/1546.html
Q The Gobbiebag Part VIII | ヨバクリのかばん 3 | no | T npc.245.Bluffnix
RW other:マイバッグの最大収納数が計70個になる
RW other:3国の名声が上がる
LK fame:名声ランク4以上
LK quest:クエスト「ヨバクリのかばん 2」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Gobbiebag_Part_VIII;名声ランク4（用語辞典の表はランク3）
g01 talk - | ジュノ下層(H-9)ジャンク屋マックビクスのBluffnixに話して受ける | 最初の話は禁断の口のこと。もう一度話すとかばんの話になる。オファーなしでトレードだけでも完了できる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | > a01,b01
a01 gather - | 「エレクトラム」「スミロドンの革」「シリス」「エンジェルストーン」を1個ずつ用意する | どれも競売で買える。 | N エレクトラム*1,スミロドンの革*1,シリス*1,エンジェルストーン*1 | R 素材
a02 trade - | Bluffnixに4つの素材をトレードして完了 | マイバッグが計70個になる。モグサッチェルも同じ数になる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N エレクトラム*1,スミロドンの革*1,シリス*1,エンジェルストーン*1 | R 素材 | >
b01 trade - | Bluffnixに「ゴブリンシチュー880」を1個トレードして完了 | 4つの素材の代わりになる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N ゴブリンシチュー880*1 | R シチュー | >

@ quest.jeuno.069 https://wiki.ffo.jp/html/1546.html
Q The Gobbiebag Part IX | ヨバクリのかばん 4 | no | T npc.245.Bluffnix
RW other:マイバッグの最大収納数が計75個になる
RW other:3国の名声が上がる
LK fame:名声ランク5以上
LK quest:クエスト「ヨバクリのかばん 3」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Gobbiebag_Part_IX;名声ランク5（用語辞典の表はランク4）
g01 talk - | ジュノ下層(H-9)ジャンク屋マックビクスのBluffnixに話して受ける | 最初の話は禁断の口のこと。もう一度話すとかばんの話になる。オファーなしでトレードだけでも完了できる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | > a01,b01
a01 gather - | 「オリハルコン」「ペイストの革」「オイルクロス」「オックスオーブ」を1個ずつ用意する | どれも競売で買える。 | N オリハルコン*1,ペイストの革*1,オイルクロス*1,オックスオーブ*1 | R 素材
a02 trade - | Bluffnixに4つの素材をトレードして完了 | マイバッグが計75個になる。モグサッチェルも同じ数になる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N オリハルコン*1,ペイストの革*1,オイルクロス*1,オックスオーブ*1 | R 素材 | >
b01 trade - | Bluffnixに「ゴブリンシチュー880」を1個トレードして完了 | 4つの素材の代わりになる。 | @ジュノ下層 H-9 | T npc.245.Bluffnix | N ゴブリンシチュー880*1 | R シチュー | >

@ quest.jeuno.070 https://wiki.ffo.jp/html/14359.html
Q Cook's Pride | 主婦のこだわり | no | T npc.245.Naruru
RW item:ミスリルリング
RW gil:3000ギル
RW title:上級ツカイッパー
LK fame:名声ランク4以上
LK quest:クエスト「子供との取引」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Cook%27s_Pride;名声ランク4、Naruru の座標 H-10
g01 talk - | ジュノ下層(H-10)の商家のNaruruに話して受ける | 愛用のお鍋が見当たらないらしい。 | @ジュノ下層 H-10 | T npc.245.Naruru
g02 talk - | ウィンダスの調理ギルドでクエスト「ロイヤルお鍋」を進め、だいじなもの「特製お鍋」をもらう | このクエストを受けると「ロイヤルお鍋」が受けられる。 | K 特製お鍋
g03 talk - | Naruruに話して完了 | ミスリルリングと3000ギル。 | @ジュノ下層 H-10 | T npc.245.Naruru | K 特製お鍋

@ quest.jeuno.071 https://wiki.ffo.jp/html/4355.html
Q The Goblin Tailor | 仕立て屋ゴブリン | no | T npc.245.Guttrix = npc:Guttrix@ジュノ下層 H-10
RW item:自分の種族の高級装束（4部位から1つ）
RW title:ゴブリン専属モデル
LK fame:名声ランク3以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Goblin_Tailor;名声ランク3（用語辞典に記載なし）
g01 talk - | ジュノ下層(H-10)ゴブリンズゴブレットのGuttrixに話し、今週の場所と種族を聞く | 場所と種族はヴァナ時間の1週間ごとに順に変わる。 | @ジュノ下層 H-10 | T npc.245.Guttrix
g02 gather - | その週のダンジョンの箱のカギを用意する | オルデール鍾乳洞・グスゲン鉱山・シャクラミの地下迷宮のどれか。星唄の煌めき【一奏】があればCurio Vendor Moogleで2500ギルで買える。
g03 examine - | 該当する種族のキャラで、そのダンジョンのTreasure Chestを開けてだいじなもの「魔法の型紙」を手に入れる | 1枚しか持てない。シーフならスケルトンキーでも開けられる。 | K 魔法の型紙
g04 talk - | Guttrixに話し、4部位から1つ選んで完了 | 同じ部位は二度選べない。ほかの部位はまた型紙を取ってくる。 | @ジュノ下層 H-10 | T npc.245.Guttrix | K 魔法の型紙

@ quest.jeuno.072 https://wiki.ffo.jp/html/8572.html
Q Painful Memory | 傷ついたもの | no | T npc.245.Mertaire = npc:Mertaire@ジュノ下層 I-8
RW item:ペーパーナイフ
g01 talk - | ジュノ下層(I-8)吟遊詩人の酒場のMertaireに話して受け、だいじなもの「想い出の腕輪」を受け取る | 吟遊詩人のAF1つ目。 | @ジュノ下層 I-8 | T npc.245.Mertaire
g02 examine - | ラングモント峠(D-5)のWaters of Oblivionを調べる | 頭足族NM「Tros」が出る。 | @ラングモント峠 D-5 | T obj.166.Waters_of_Oblivion = obj:Waters of Oblivion@ラングモント峠 D-5 | K 想い出の腕輪
g03 fight - | Trosを倒す | - | @ラングモント峠 D-5 | T mob.166.Tros = mob:Tros@ラングモント峠 D-5
g04 examine - | もう一度Waters of Oblivionを調べ、イベントを見て完了 | ペーパーナイフ。 | @ラングモント峠 D-5 | T obj.166.Waters_of_Oblivion

@ quest.jeuno.073 https://wiki.ffo.jp/html/24409.html
Q All in the Cards | 占い普及大作戦！ | yes | T npc.245.Chululu
RW gil:600ギル
RW title:カードコレクター
RW other:3国の名声が1.6上がる
LK fame:名声ランク5以上
LK quest:クエスト「タルットカード収集」クリア
LK condition:前のクリアから地球時間の0時を過ぎている
XS BG Wiki;https://www.bg-wiki.com/ffxi/All_in_the_Cards;名声ランク5（用語辞典に記載なし）
g01 talk - | ジュノ下層(I-8)2階の占い屋のChululuに話して受け、タルットカード5枚をもらう | 4種類のどれか1種類が5枚。 | @ジュノ下層 I-8 | T npc.245.Chululu | W 地球時間の0時を過ぎてから
g02 gather - | ほかの3種類のカードを、トレードや地球時間の0時越えでのもらい直しでそろえる | - | W 地球時間の0時を過ぎてから（もらい直すとき）
g03 trade - | Chululuに4種類のタルットカードをトレードして完了 | 600ギル。 | @ジュノ下層 I-8 | T npc.245.Chululu | N タルットカード愚者*1,タルットカード亡者*1,タルットカード王者*1,タルットカード隠者*1

@ quest.jeuno.074 https://wiki.ffo.jp/html/11567.html
Q Deal with Tenshodo | 天晶堂での取引 | no | T npc.245.Garnev
RW key_item:時計塔の油
RW title:名トレーダー
LK quest:「デリケートな時計塔」を受けている
g01 talk - | 天晶堂(J-7)のGarnevに話して取引の話を聞く | 「時計塔の油」とオークの黄金マスクを交換してくれる。 | @ジュノ下層 J-7 | T npc.245.Garnev
g02 fight - | Orcish TrooperやOrcish Overlordを倒して「オークの黄金マスク」を手に入れる | - | T mob.orcish_trooper = mob:Orcish Trooper
g03 trade - | Garnevに「オークの黄金マスク」をトレードして完了 | だいじなもの「時計塔の油」。次は「デリケートな時計塔」を終わらせる。 | @ジュノ下層 J-7 | T npc.245.Garnev | N オークの黄金マスク*1

@ quest.jeuno.075 https://wiki.ffo.jp/html/12913.html
Q Tenshodo Membership | 天晶堂入会 | no | T npc.245.Ghebi_Damomohe = npc:Ghebi Damomohe@ジュノ下層 I-7
RW key_item:天晶堂会員証
RW item:天晶堂への紹介状
RW title:天晶堂会員
RW other:天晶堂・ノーグの名声が6.0上がる
LK fame:名声ランク3以上（紹介状をトレードするなら不要）
g01 talk - | ジュノ下層(I-7)海神楼入口のGhebi Damomoheに話し、「今はいい」の下の空欄を選んで受ける | 紹介状を持っているならこの手順はいらない。 | @ジュノ下層 I-7 | T npc.245.Ghebi_Damomohe | > a01,b01
a01 talk - | バストゥーク港(F-6)の倉庫にいる天晶堂の店員Jabbarに話して、だいじなもの「天晶堂入会申込書」をもらう | 無料。Silver Owlでもよい。 | @バストゥーク港 F-6 | T npc.236.Jabbar = npc:Jabbar@バストゥーク港 F-6 | R 申込書
a02 talk - | Ghebi Damomoheに話して完了 | 天晶堂会員証と紹介状。 | @ジュノ下層 I-7 | T npc.245.Ghebi_Damomohe | K 天晶堂入会申込書 | R 申込書 | >
b01 gather - | 競売（雑貨）で「天晶堂への紹介状」を買う | 高いときや出品がないときもある。 | N 天晶堂への紹介状*1 | R 紹介状
b02 trade - | Ghebi Damomoheに「天晶堂への紹介状」をトレードして完了 | オファーなしでもよく、名声もいらない。紹介状がまたもらえる。 | @ジュノ下層 I-7 | T npc.245.Ghebi_Damomohe | N 天晶堂への紹介状*1 | R 紹介状 | >

@ quest.jeuno.076 https://wiki.ffo.jp/html/5500.html
Q Save My Son | 息子に罪はない | no | T obj.245.Door_Merchants_House = obj:Door:Merchant's House@ジュノ下層 G-11
RW item:獣使いの呼び子
RW gil:2,100ギル
RW title:命の恩人
LK quest:クエスト「傷ついたチョコボ」クリア
LK condition:レベル30以上
g01 examine - | ジュノ下層(G-11)チョコボ厩舎の上のDoor:Merchant's Houseを調べて受ける | - | @ジュノ下層 G-11 | T obj.245.Door_Merchants_House
g02 examine - | クフィム島(F-8)の崖下へ下り、夜にNightflowersを調べる | 近くにアクティブのKraken（Lv38ほど）とGoblin Bounty Hunter。スニークとインビジで。 | @クフィム島 F-8 | T obj.126.Nightflowers = obj:Nightflowers@クフィム島 F-8 | W ヴァナ時間21:30〜5:00ごろ
g03 examine - | ジュノ下層(G-11)のDoor:Merchant's Houseを調べて完了 | 獣使いの呼び子と2,100ギル。次は「獣使いジョブゲット」。 | @ジュノ下層 G-11 | T obj.245.Door_Merchants_House

@ quest.jeuno.077 https://wiki.ffo.jp/html/8393.html
Q A New Dawn | 新たなる朝 | no | T obj.245.Door_Merchants_House
RW item:ビーストトラウザ
RW title:熾烈なる大獣使い
LK quest:クエスト「闇に散りしものたち」クリア
LK condition:獣使いで調べる
g01 examine - | 獣使いでジュノ下層(G-11)のDoor:Merchant's Houseを調べて受ける | 調教師の笛をOskerからもらうように言われる。 | @ジュノ下層 G-11 | T obj.245.Door_Merchants_House
g02 trade - | ジュノ上層(G-7)チョコボ厩舎のOskerに「マホガニー材」をトレードして「調教師の笛」をもらう | - | @ジュノ上層 G-7 | T npc.244.Osker | N マホガニー材*1
g03 go - | バタリア丘陵(F-5)からエルディーム古墳に入る | ボスディン氷河を抜けるか、不思議な煌きで段差を越える。 | @バタリア丘陵 F-5
g04 examine - | エルディーム古墳(D-4)のSarcophagusを調べ、Sturm・Taifun・Trombeを出す | 剣虎2匹はあやつれる。Sturmの攻撃が強い。 | @エルディーム古墳 D-4 #3 | T obj.195.Sarcophagus = obj:Sarcophagus@エルディーム古墳 D-4 #3
g05 fight - | 屍犬Sturmを倒す | レベルが高ければSturmだけ倒すと残りは消える。 | @エルディーム古墳 D-4 #3 | T mob.195.Sturm = mob:Sturm@エルディーム古墳 D-4 #3
g06 examine - | もう一度Sarcophagusを調べ、イベントを見て完了 | ビーストトラウザ。 | @エルディーム古墳 D-4 #3 | T obj.195.Sarcophagus

@ quest.jeuno.078 https://wiki.ffo.jp/html/31103.html
Q To Kill Mocking Birds | 核熱エミネンス | no | T npc.245.Nantoto = npc:Nantoto@ジュノ下層 H-8
RW item:互助会引換券・銅*12
RW title:一天地六の観測者（後日談のあと）
LK quest:クエスト「錯綜メモリアル」クリア後、エリアを出入りする
LK condition:エミネンス・レコードを150個以上達成している
g01 talk - | ジュノ下層(H-8)吟遊詩人の酒場前のNantotoに話して受ける | - | @ジュノ下層 H-8 | T npc.245.Nantoto
g02 go - | エミネンス・レコードの目標『不倶戴天』を受ける | -
g03 fight - | オズトロヤ城の最深部にいるYagudo High Priestを倒す | 倒すと『不倶戴天』が達成される。 | @オズトロヤ城 | T mob.151.Yagudo_High_Priest = mob:Yagudo High Priest@オズトロヤ城
g04 talk - | Nantotoに話して完了 | 互助会引換券・銅12枚。 | @ジュノ下層 H-8 | T npc.245.Nantoto
g05 talk - | 西アドゥリン(H-11)のDuberassonに話して後日談を聞く | 称号「一天地六の観測者」。しなくてもよい。

@ quest.jeuno.079 https://wiki.ffo.jp/html/28346.html
Q Now Recording... | 磁場記録代行 | yes | T npc.245.Darcia = npc:Darcia@ジュノ下層 H-7
RW gil:300ギル
RW other:経験値（場所によって200〜500）
LK quest:アドゥリンミッション「ロゼッタ石」クリア（アドゥリン渡航免状がある）
LK condition:前のクリアから地球時間の0時を過ぎている
g01 talk - | ジュノ下層(H-7)商工会議所のDarciaに話し、「仕事を受けたい」を選んで「代行用・ロゼッタ石」をもらう | - | @ジュノ下層 H-7 | T npc.245.Darcia | W 地球時間の0時を過ぎてから
g02 examine - | 指定された場所のGeomagnetic Fountを調べる | その場で経験値が入る。場所は「ロゼッタ石」と同じ。 | K 代行用・ロゼッタ石
g03 talk - | Darciaに話して完了 | 300ギル。 | @ジュノ下層 H-7 | T npc.245.Darcia

@ quest.jeuno.080 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Puppetmaster) | 神器 ＜ からくり士 ＞ | no | T npc.245.Zalsuhm = npc:Zalsuhm@ジュノ下層 H-9
RW other:からくり士のミシックWSを覚える
LK condition:からくり士の鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | からくり士の鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.081 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Corsair) | 神器 ＜ コルセア ＞ | no | T npc.245.Zalsuhm
RW other:コルセアのミシックWSを覚える
LK condition:コルセアの鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | コルセアの鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.082 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Thief) | 神器 ＜ シーフ ＞ | no | T npc.245.Zalsuhm
RW other:シーフのミシックWSを覚える
LK condition:シーフの鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | シーフの鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.083 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Paladin) | 神器 ＜ ナイト ＞ | no | T npc.245.Zalsuhm
RW other:ナイトのミシックWSを覚える
LK condition:ナイトの鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | ナイトの鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.084 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Monk) | 神器 ＜ モンク ＞ | no | T npc.245.Zalsuhm
RW other:モンクのミシックWSを覚える
LK condition:モンクの鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | モンクの鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.085 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Samurai) | 神器 ＜ 侍 ＞ | no | T npc.245.Zalsuhm
RW other:侍のミシックWSを覚える
LK condition:侍の鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | 侍の鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.086 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Summoner) | 神器 ＜ 召喚士 ＞ | no | T npc.245.Zalsuhm
RW other:召喚士のミシックWSを覚える
LK condition:召喚士の鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | 召喚士の鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.087 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Bard) | 神器 ＜ 吟遊詩人 ＞ | no | T npc.245.Zalsuhm
RW other:吟遊詩人のミシックWSを覚える
LK condition:吟遊詩人の鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | 吟遊詩人の鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.088 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Scholar) | 神器 ＜ 学者 ＞ | no | T npc.245.Zalsuhm
RW other:学者のミシックWSを覚える
LK condition:学者の鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | 学者の鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.089 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Ninja) | 神器 ＜ 忍者 ＞ | no | T npc.245.Zalsuhm
RW other:忍者のミシックWSを覚える
LK condition:忍者の鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | 忍者の鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.090 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Warrior) | 神器 ＜ 戦士 ＞ | no | T npc.245.Zalsuhm
RW other:戦士のミシックWSを覚える
LK condition:戦士の鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | 戦士の鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.091 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Dark Knight) | 神器 ＜ 暗黒騎士 ＞ | no | T npc.245.Zalsuhm
RW other:暗黒騎士のミシックWSを覚える
LK condition:暗黒騎士の鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | 暗黒騎士の鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.092 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Ranger) | 神器 ＜ 狩人 ＞ | no | T npc.245.Zalsuhm
RW other:狩人のミシックWSを覚える
LK condition:狩人の鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | 狩人の鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.093 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Beastmaster) | 神器 ＜ 獣使い ＞ | no | T npc.245.Zalsuhm
RW other:獣使いのミシックWSを覚える
LK condition:獣使いの鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | 獣使いの鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.094 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (White Mage) | 神器 ＜ 白魔道士 ＞ | no | T npc.245.Zalsuhm
RW other:白魔道士のミシックWSを覚える
LK condition:白魔道士の鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | 白魔道士の鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.095 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Dragoon) | 神器 ＜ 竜騎士 ＞ | no | T npc.245.Zalsuhm
RW other:竜騎士のミシックWSを覚える
LK condition:竜騎士の鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | 竜騎士の鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.096 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Red Mage) | 神器 ＜ 赤魔道士 ＞ | no | T npc.245.Zalsuhm
RW other:赤魔道士のミシックWSを覚える
LK condition:赤魔道士の鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | 赤魔道士の鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.097 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Dancer) | 神器 ＜ 踊り子 ＞ | no | T npc.245.Zalsuhm
RW other:踊り子のミシックWSを覚える
LK condition:踊り子の鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | 踊り子の鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.098 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Blue Mage) | 神器 ＜ 青魔道士 ＞ | no | T npc.245.Zalsuhm
RW other:青魔道士のミシックWSを覚える
LK condition:青魔道士の鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | 青魔道士の鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.099 https://wiki.ffo.jp/html/15865.html
Q Unlocking a Myth (Black Mage) | 神器 ＜ 黒魔道士 ＞ | no | T npc.245.Zalsuhm
RW other:黒魔道士のミシックWSを覚える
LK condition:黒魔道士の鎮魂武器（ナイズル島で手に入る武器）を装備して話す
g01 talk - | 黒魔道士の鎮魂武器を装備して、ジュノ下層(H-9)ジャンク屋マックビクスのZalsuhmに話して受ける | トレードではなく装備して話す。「武器を掲げない」を選ぶとエリアを出入りするまで受けられない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g02 fight - | 鎮魂武器を装備したまま、ウェポンスキルで敵を倒して250ポイントためる | トライアルウェポンと同じ潜在消し。ナイズル島でなくてよい。途中でGhanraamに武器を預けると記録が消える。
g03 trade - | Zalsuhmに鎮魂武器をトレードし、ためぐあいを聞く | 「見事なまでに器気があふれだしている」ならたまっている。ミシックWSが撃てるようになっていれば確かめられる。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm
g04 trade - | ポイントがたまったら、Zalsuhmに鎮魂武器をトレードして完了 | ミシックWSを覚え、ほかの武器でも撃てるようになる。武器はなくならない。 | @ジュノ下層 H-9 | T npc.245.Zalsuhm

@ quest.jeuno.100 https://wiki.ffo.jp/html/4719.html
Q Save the Clock Tower | 署名を集めろ | no | T npc.245.Derrick = npc:Derrick@ジュノ下層 H-7
RW title:時計塔保存嘆願者
LK fame:名声ランク5以上
LK quest:クエスト「デリケートな時計塔」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Save_the_Clock_Tower;名声ランク5（用語辞典はランク4）
g01 talk - | ジュノ下層(H-7)商工会議所のDerrickに話して受け、「時計塔保存の嘆願書」をもらう | - | @ジュノ下層 H-7 | T npc.245.Derrick
g02 trade - | ジュノ港(H-7)のPitantimandに嘆願書をトレードして署名をもらう | サンドリア行き飛空艇乗り場の出口の中。 | @ジュノ港 H-7 | T npc.246.Pitantimand = npc:Pitantimand@ジュノ港 H-7 | N 時計塔保存の嘆願書*1
g03 trade - | ジュノ下層(H-10)のTeigero-Bangeroに嘆願書をトレードする | - | @ジュノ下層 H-10 | T npc.245.Teigero-Bangero | N 時計塔保存の嘆願書*1
g04 trade - | ジュノ下層(I-6)のZaukoに嘆願書をトレードする | - | @ジュノ下層 I-6 | T npc.245.Zauko = npc:Zauko@ジュノ下層 I-6 | N 時計塔保存の嘆願書*1
g05 trade - | ジュノ上層(G-8)のBaudinに嘆願書をトレードする | - | @ジュノ上層 G-8 | T npc.244.Baudin | N 時計塔保存の嘆願書*1
g06 trade - | ジュノ上層(G-7)のColletに嘆願書をトレードする | - | @ジュノ上層 G-7 | T npc.244.Collet | N 時計塔保存の嘆願書*1
g07 trade - | ジュノ上層(G-9)診療所のConstanceに嘆願書をトレードする | - | @ジュノ上層 G-9 | T npc.244.Constance = npc:Constance@ジュノ上層 G-9 | N 時計塔保存の嘆願書*1
g08 trade - | 同じ診療所のSourenに嘆願書をトレードする | - | @ジュノ上層 G-9 | T npc.244.Souren = npc:Souren@ジュノ上層 G-9 | N 時計塔保存の嘆願書*1
g09 trade - | ジュノ上層(G-10)のMonberauxに嘆願書をトレードする | - | @ジュノ上層 G-10 | T npc.244.Monberaux | N 時計塔保存の嘆願書*1
g10 trade - | ジュノ上層(F-7)マーブルブリッジのZuberに嘆願書をトレードする | ジョブや種族で入れないことがある。 | @ジュノ上層 F-7 | T npc.244.Zuber = npc:Zuber@ジュノ上層 F-7 | N 時計塔保存の嘆願書*1
g11 trade - | ル・ルデの庭(H-9)のRadeivepartに嘆願書をトレードする | - | @ル・ルデの庭 H-9 | T npc.243.Radeivepart = npc:Radeivepart@ル・ルデの庭 H-9 | N 時計塔保存の嘆願書*1
g12 trade - | 10人の署名が集まったら、Derrickに嘆願書をトレードして完了 | 次は「時計塔と青年」。 | @ジュノ下層 H-7 | T npc.245.Derrick | N 時計塔保存の嘆願書*1

@ quest.jeuno.101 https://wiki.ffo.jp/html/6424.html
Q Fistful of Fury | 腕におぼえあり！ | no | T npc.245.Vola = npc:Vola@ジュノ下層 J-8
RW item:茶帯
RW title:茶帯の有段者
LK quest:バストゥークのクエスト「猛き獣の拳を」クリア
LK fame:天晶堂の名声ランクが一定（3〜4ほど）以上
g01 talk - | 天晶堂(J-8)のVolaに話して受ける | 茶帯は黒帯のクエストでも使うので取っておく。 | @ジュノ下層 J-8 | T npc.245.Vola
g02 fight - | オルデール鍾乳洞のMorbolgerを倒して「モルボルガーのつる」を手に入れる | 獣神印章30BF『屍臭病予防』でもよい。 | @オルデール鍾乳洞 | T mob.193.Morbolger = mob:Morbolger@オルデール鍾乳洞 | E BG Wiki;https://www.bg-wiki.com/ffxi/Fistful_of_Fury;Morbolger はオルデール鍾乳洞
g03 fight - | ソロムグ原野のDeadly Dodoを倒して「ドードーの皮」を手に入れる | 獣神印章30BF『恐鳥の歌』でもよい。 | @ソロムグ原野 | T mob.120.Deadly_Dodo = mob:Deadly Dodo@ソロムグ原野 | E BG Wiki;https://www.bg-wiki.com/ffxi/Fistful_of_Fury;Deadly Dodo はソロムグ原野
g04 fight - | ボスディン氷河のNueを倒して「ヌエの牙」を手に入れる | 獣人印章50BF『虎視眈眈』（Lv50制限）でもよい。 | @ボスディン氷河 | T mob.111.Nue = mob:Nue@ボスディン氷河 | E BG Wiki;https://www.bg-wiki.com/ffxi/Fistful_of_Fury;Nue はボスディン氷河
g05 trade - | Volaに3つの品をトレードして完了 | 茶帯。 | @ジュノ下層 J-8 | T npc.245.Vola | N モルボルガーのつる*1,ドードーの皮*1,ヌエの牙*1

@ quest.jeuno.102 https://wiki.ffo.jp/html/3728.html
Q A Minstrel in Despair | 自暴自棄の吟遊詩人 | no | T npc.245.Mertaire
RW gil:2100ギル
LK quest:「古い歌碑」クリア
g01 gather - | クエスト「古い歌碑」で「詩が記された羊皮紙」を手に入れる | オファーリストには載らない。 | N 詩が記された羊皮紙*1
g02 trade - | ジュノ下層(I-8)吟遊詩人の酒場のMertaireに羊皮紙をトレードして完了 | 2100ギル。次は「吟遊詩人ジョブゲット」。 | @ジュノ下層 I-8 | T npc.245.Mertaire | N 詩が記された羊皮紙*1

@ quest.jeuno.103 https://wiki.ffo.jp/html/13283.html
Q Community Service | 街燈ボランティア | yes | T npc.245.Zauko
RW title:ともし火ランナー
RW key_item:街の灯火を守る会会員証（2回目の完了で）
RW other:3国の名声が0.5ずつ上がる
LK condition:ヴァナ時間の1日に1人だけ受けられる
g01 talk - | ヴァナ時間18:00〜20:00にジュノ下層(I-6)のZaukoに話して受ける | 名声は初めからでよい。ギルなどの報酬はない。 | @ジュノ下層 I-6 | T npc.245.Zauko | W ヴァナ時間18:00〜20:00
g02 examine - | ジュノ下層にある12個のStreetlampをすべて調べて灯をつける | ヴァナ時間の1:00までに。 | @ジュノ下層 | T obj.245.Streetlamp = obj:Streetlamp~@ジュノ下層 | W ヴァナ時間の1:00まで
g03 talk - | Zaukoに話して完了 | - | @ジュノ下層 I-6 | T npc.245.Zauko

@ quest.jeuno.104 https://wiki.ffo.jp/html/8398.html
Q The Requiem | 誰がための鎮魂歌 | no | T npc.245.Bki_Tbujhja = npc:Bki Tbujhja@ジュノ下層 H-8
RW item:コラルスリッパー
LK quest:クエスト「傷ついたもの」クリア
LK condition:吟遊詩人Lv50以上
g01 trade - | ジュノ下層(H-8)吟遊詩人の酒場のBki Tbujhjaに「聖水」をトレードして受ける | 聖水は返される。 | @ジュノ下層 H-8 | T npc.245.Bki_Tbujhja | N 聖水*1
g02 go - | バタリア丘陵(F-5)からエルディーム古墳に入る | ジュノからは不思議な煌きで段差を越えるか、ボスディン氷河側から行く。 | @バタリア丘陵 F-5
g03 trade - | エルディーム古墳(D-4)のSarcophagusに「聖水」をトレードし、スケルトン族NM3体を出す | 入って左手沿いに進む。テンキー3のあたり。 | @エルディーム古墳 D-4 #3 | T obj.195.Sarcophagus | N 聖水*1
g04 fight - | Yum Kimil・Dog Guardian・Owl Guardianの3体を倒す | 1体でも他の人に倒されたらやり直し。スリプルは効かない。Yum Kimilから倒すとよい。 | @エルディーム古墳 D-4 #3 | T mob.195.Yum_Kimil = mob:Yum Kimil@エルディーム古墳 D-4 #3
g05 examine - | もう一度Sarcophagusを調べ、だいじなもの「星の指輪」を手に入れる | ほかのメンバーが出した場合は聖水をトレードする。 | @エルディーム古墳 D-4 #3 | T obj.195.Sarcophagus
g06 talk - | Bki Tbujhjaに話して完了 | コラルスリッパー。 | @ジュノ下層 H-8 | T npc.245.Bki_Tbujhja | K 星の指輪

@ quest.jeuno.105 https://wiki.ffo.jp/html/30320.html
Q Shifty Shades of Prey | 錯綜メモリアル | no | T npc.245.Nantoto
RW item:互助会引換券・銅*5
LK quest:クエスト「黄昏テレポート」クリア後、エリアを出入りする
LK condition:エミネンス・レコードを100個以上達成している
g01 talk - | ジュノ下層(H-8)のNantotoに話してイベントを見る | 条件を満たすとジュノ下層に入ったときにログが出る。 | @ジュノ下層 H-8 | T npc.245.Nantoto
g02 go - | エミネンス・レコードの目標「闇狩り」を受ける | その他＞エミネンス・レコードクエストの中。
g03 fight - | エルディーム古墳でシャドウ族を10体倒す | 経験値が入らなくてもよい。MAP2の東西南北の広間のKaやDark Stalker、西の広場から落ちた先のSprigganなど。 | @エルディーム古墳 - #2
g04 talk - | Nantotoに話して完了 | 互助会引換券・銅5枚。 | @ジュノ下層 H-8 | T npc.245.Nantoto

@ quest.jeuno.106 https://wiki.ffo.jp/html/15355.html
Q "Data Analyzer and Logger EX" | 魔法人形「みとどけくん」 | no | T npc.245.Rakuru-Rakoru = npc:Rakuru-Rakoru@ジュノ下層
RW gil:59630ギル
LK condition:Lv75以上のジョブで話す
g01 talk - | ジュノ下層の競売前の噴水（聖オーエン広場）のRakuru-Rakoruに話して受け、だいじなもの「魔法人形「みとどけくん」」をもらう | 以後話すと討伐の残りを見せてくれる。ナイズル島のNMは数えない。 | @ジュノ下層 | T npc.245.Rakuru-Rakoru
g02 fight - | ラテーヌ高原(K-6)のNM「Tumbling Truffle」を倒す | 倒すと戦闘データが記録される。 | @ラテーヌ高原 K-6 | T mob.102.Tumbling_Truffle = mob:Tumbling Truffle@ラテーヌ高原 K-6 | K 魔法人形「みとどけくん」
g03 fight - | バタリア丘陵(G-6/G-7/H-6)のNM「Tottering Toby」を倒す | 倒すと戦闘データが記録される。 | @バタリア丘陵 G-6/G-7/H-6 | T mob.105.Tottering_Toby = mob:Tottering Toby@バタリア丘陵 G-6/G-7/H-6 | K 魔法人形「みとどけくん」
g04 fight - | ダボイ(E-10)のNM「Blubbery Bulge」を倒す | ナイトのジョブ取得クエストの井戸の近く。 | @ダボイ E-10 | T mob.149.Blubbery_Bulge = mob:Blubbery Bulge@ダボイ E-10 | K 魔法人形「みとどけくん」
g05 fight - | ロランベリー耕地(H-9/I-9/I-10)のNM「Black Triple Stars」を倒す | ヴァナ時間18:00〜5:00だけ出る。 | @ロランベリー耕地 H-9/I-9/I-10 | T mob.110.Black_Triple_Stars = mob:Black Triple Stars@ロランベリー耕地 H-9/I-9/I-10 | K 魔法人形「みとどけくん」
g06 fight - | ロランベリー耕地(D-11)のNM「Drooling Daisy」を倒す | クロウラーの巣を抜けた先。 | @ロランベリー耕地 D-11 | T mob.110.Drooling_Daisy = mob:Drooling Daisy@ロランベリー耕地 D-11 | K 魔法人形「みとどけくん」
g07 fight - | パシュハウ沼(H-7/I-7/I-8/J-8)のNM「Jolly Green」を倒す | 倒すと戦闘データが記録される。 | @パシュハウ沼 H-7/I-7/I-8/J-8 | T mob.109.Jolly_Green = mob:Jolly Green@パシュハウ沼 H-7/I-7/I-8/J-8 | K 魔法人形「みとどけくん」
g08 fight - | 東サルタバルタ(I-11/J-11)のNM「Sharp-Eared Ropipi」を倒す | J-7のあたりに出ることもある。 | @東サルタバルタ I-11/J-11 | T mob.116.Sharp-Eared_Ropipi = mob:Sharp-Eared Ropipi@東サルタバルタ I-11/J-11 | K 魔法人形「みとどけくん」
g09 fight - | ブブリム半島(K-7)のNM「Buburimboo」を倒す | 倒すと戦闘データが記録される。 | @ブブリム半島 K-7 | T mob.118.Buburimboo = mob:Buburimboo@ブブリム半島 K-7 | K 魔法人形「みとどけくん」
g10 fight - | メリファト山地(K-10/K-11)のNM「Daggerclaw Dracos」を倒す | 倒すと戦闘データが記録される。 | @メリファト山地 K-10/K-11 | T mob.119.Daggerclaw_Dracos = mob:Daggerclaw Dracos@メリファト山地 K-10/K-11 | K 魔法人形「みとどけくん」
g11 fight - | クフィム島(G-6/G-7)のNM「Trickster Kinetix」を倒す | 倒すと戦闘データが記録される。 | @クフィム島 G-6/G-7 | T mob.126.Trickster_Kinetix = mob:Trickster Kinetix@クフィム島 G-6/G-7 | K 魔法人形「みとどけくん」
g12 fight - | デルクフの塔上層(F-6)のNM「Ixtab」を倒す | 11階か12階。 | @デルクフの塔上層 F-6 | T mob.158.Ixtab = mob:Ixtab@デルクフの塔上層 F-6 | K 魔法人形「みとどけくん」
g13 fight - | ボスディン氷河(I-8/J-8)のNM「Gargantua」を倒す | 倒すと戦闘データが記録される。 | @ボスディン氷河 I-8/J-8 | T mob.111.Gargantua = mob:Gargantua@ボスディン氷河 I-8/J-8 | K 魔法人形「みとどけくん」
g14 fight - | ザルカバード(E-7/E-8)のNM「Shadow Eye」を倒す | 倒すと戦闘データが記録される。 | @ザルカバード E-7/E-8 | T mob.112.Shadow_Eye = mob:Shadow Eye@ザルカバード E-7/E-8 | K 魔法人形「みとどけくん」
g15 fight - | ザルカバード(J-6)のNM「Boreal Coeurl」を倒す | 限界突破クエスト「すべての高い山に登れ」のNM。 | @ザルカバード J-6 | T mob.112.Boreal_Coeurl = mob:Boreal Coeurl@ザルカバード J-6 | K 魔法人形「みとどけくん」
g16 fight - | ザルカバード(G-10)のNM「Boreal Hound」を倒す | 「すべての高い山に登れ」のNM。 | @ザルカバード G-10 | T mob.112.Boreal_Hound = mob:Boreal Hound@ザルカバード G-10 | K 魔法人形「みとどけくん」
g17 fight - | ザルカバード(I-5)のNM「Boreal Tiger」を倒す | 「すべての高い山に登れ」のNM。 | @ザルカバード I-5 | T mob.112.Boreal_Tiger = mob:Boreal Tiger@ザルカバード I-5 | K 魔法人形「みとどけくん」
g18 talk - | 16体を倒したらRakuru-Rakoruに話して完了 | 59630ギル。 | @ジュノ下層 | T npc.245.Rakuru-Rakoru

@ quest.jeuno.107 https://wiki.ffo.jp/html/30319.html
Q Teleports by Twilight | 黄昏テレポート | no | T npc.245.Nantoto
RW item:互助会引換券・銅*3
LK condition:エミネンス・レコードを50個以上達成している
g01 talk - | ジュノ下層(H-8)のNantotoに話してイベントを見る | 条件を満たすとジュノ下層に入ったときにログが出る。 | @ジュノ下層 H-8 | T npc.245.Nantoto
g02 go - | エミネンス・レコードの目標「テレポイント巡り」を受ける | その他＞エミネンス・レコードクエストの中。
g03 examine - | ラテーヌ高原(K-8)のホラのゲートクリスタルを調べる | 6か所はどの順でもよい。 | @ラテーヌ高原 K-8
g04 examine - | コンシュタット高地(I-6)のデムのゲートクリスタルを調べる | - | @コンシュタット高地 I-6
g05 examine - | タロンギ大峡谷(I-6)のメアのゲートクリスタルを調べる | - | @タロンギ大峡谷 I-6
g06 examine - | ヨアトル大森林(F-9)のヨトのゲートクリスタルを調べる | - | @ヨアトル大森林 F-9
g07 examine - | 東アルテパ砂漠(G-7)のルテのゲートクリスタルを調べる | - | @東アルテパ砂漠 G-7
g08 examine - | ザルカバード(H-8)のヴァズのゲートクリスタルを調べる | 6か所で「テレポイント巡り」が達成される。 | @ザルカバード H-8
g09 talk - | Nantotoに話して完了 | 互助会引換券・銅3枚。 | @ジュノ下層 H-8 | T npc.245.Nantoto

@ quest.jeuno.108 https://wiki.ffo.jp/html/3810.html
Q The Antique Collector | アンチーク・コレクター | no | T npc.246.Imasuke = npc:Imasuke@ジュノ港 E-6
RW key_item:デルクフの塔地図（持っていない場合）
RW gil:2000ギル
RW other:経験値2000
RW title:お宝出品人
LK fame:名声ランク2以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Antique_Collector;名声ランク（用語辞典はランク3）
g01 talk - | ジュノ港(E-6)クフィム島への出口近くのImasukeに話して受ける | - | @ジュノ港 E-6 | T npc.246.Imasuke
g02 gather - | 「カイザーソード」を1本用意する | クフィム島のDancing Weaponが落とす。競売にも出ることがある。 | N カイザーソード*1 | T mob.126.Dancing_Weapon = mob:Dancing Weapon@クフィム島
g03 trade - | Imasukeに「カイザーソード」をトレードして完了 | 2000ギルと経験値2000。デルクフの塔地図を持っていなければ地図ももらえる。 | @ジュノ港 E-6 | T npc.246.Imasuke | N カイザーソード*1

@ quest.jeuno.109 https://wiki.ffo.jp/html/48.html
Q Pretty Little Things | キレイな石ころりんなのにゃ | no | T npc.246.Zona_Shodhun = npc:Zona Shodhun@ジュノ港 E-8
RW other:モグハウスから出るエリアを選べるようになる
g01 talk - | ジュノ港(E-8)モグハウス前のZona Shodhunに話して受ける | 名声は初めからでよい。黄色い石がほしいらしい。 | @ジュノ港 E-8 | T npc.246.Zona_Shodhun
g02 trade - | Zona Shodhunに「黄石」をトレードして完了 | 黄石は競売（素材>彫金）や、土曜日にグスゲン鉱山・ユグホトの岩屋の採掘で手に入る。 | @ジュノ港 E-8 | T npc.246.Zona_Shodhun | N 黄石*1 | E BG Wiki;https://www.bg-wiki.com/ffxi/Pretty_Little_Things;黄石の入手先

@ quest.jeuno.110 https://wiki.ffo.jp/html/14358.html
Q Child's Play | 子供との取引 | no | T npc.246.Karl = npc:Karl@ジュノ港 H-8
RW key_item:ひみつ魔術セット
RW title:迷トレーダー
LK quest:クエスト「ひみつ魔術セット」を受けていること
g01 talk - | ジュノ港(H-8)のKarlに話して受ける | 「ひみつ魔術セット」を受けてから。 | @ジュノ港 H-8 | T npc.246.Karl
g02 trade - | Karlに「白石」をトレードして完了 | だいじなもの「ひみつ魔術セット」をもらう。 | @ジュノ港 H-8 | T npc.246.Karl | N 白石*1

@ quest.jeuno.111 https://wiki.ffo.jp/html/8399.html
Q The Circle of Time | 時の輪の交わる処 | no | T npc.246.Imasuke
RW item:コラルジュストコル
RW title:典麗なる大吟遊詩人
LK quest:クエスト「誰がための鎮魂歌」をコンプリート
LK condition:吟遊詩人で話す。ドラギーユ城に入れること
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Circle_of_Time;修道窟へはダボイ(H-11)から、話したあとはジョブを変えてよい
g01 talk - | 吟遊詩人で、ジュノ港(E-6)のImasukeに話して受ける | 話したあとはジョブを変えてよい。 | @ジュノ港 E-6 | T npc.246.Imasuke
g02 examine - | ザルカバード(I-10)の短い洞窟の奥のPerennial Snowを調べる | 指輪を埋める。 | @ザルカバード I-10 | T obj.112.Perennial_Snow = obj:Perennial Snow@ザルカバード I-10
g03 examine - | 地球時間で1分ほど待ってからPerennial Snowをもう一度調べ、だいじなもの「星の指輪」をもらう | - | @ザルカバード I-10 | T obj.112.Perennial_Snow
g04 talk - | ジュノ港のImasukeに話す | - | @ジュノ港 E-6 | T npc.246.Imasuke
g05 talk - | ドラギーユ城(F-7)のChalvatotに話し、だいじなもの「月の指輪」をもらう | ドラギーユ城に入れるランクが要る。 | @ドラギーユ城 F-7 | T npc.233.Chalvatot
g06 fight - | ダボイ(H-11)から修道窟へ入り、(I-8)の丸い部屋のAltarを調べ、ゴースト族NM「Bugaboo」を倒す | 近くに見破りのOrcish Warlord（Lv99でも絡む）がいるので先に倒しておく。通常攻撃に強いHP吸収。空蝉を張って戦う。 | @修道窟 I-8 | T mob.150.Bugaboo = mob:Bugaboo@修道窟 I-8
g07 examine - | Altarをもう一度調べてイベントを見る | - | @修道窟 I-8 | T obj.150.Altar = obj:Altar@修道窟 I-8
g08 talk - | ドラギーユ城のChalvatotに話して完了 | コラルジュストコル。 | @ドラギーユ城 F-7 | T npc.233.Chalvatot


@ quest.jeuno.112 https://wiki.ffo.jp/html/25828.html
Q Prelude to Puissance | ある食客のメッセージ | no | T npc.243.Nomad_Moogle = npc:Nomad Moogle@ル・ルデの庭 H-5
RW key_item:宝珠の鉤
LK condition:Lv91以上
LK quest:クエスト「東方の秘術！」をコンプリート
XS BG Wiki;https://www.bg-wiki.com/ffxi/Prelude_to_Puissance;報酬は Soul gem clasp（用語辞典の「最後の試練！」の記事で だいじなもの「宝珠の鉤」）。香味石は Lv90以上のふつうの敵（アビセアの外）が落とし、ログインポイント5点でも交換できる。Nomad Moogle は Maat の隣
g01 talk - | Lv91以上でル・ルデの庭(H-5)大公私邸前のNomad Moogleに話してイベントを見る | Maatのとなりにいる。 | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle
g02 gather - | 「香味石」を1個用意する | Lv90以上のふつうの敵（アビセアの外）が落とす。ログインポイント5点でも交換できる。 | N 香味石*1
g03 trade - | Nomad Moogleに「香味石」をトレードして完了 | だいじなもの「宝珠の鉤」をもらい、次の「最後の試練！」へ進める。 | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle | N 香味石*1

@ quest.jeuno.113 https://wiki.ffo.jp/html/7.html
Q Atop the Highest Mountains | すべての高い山に登れ | no | T npc.243.Maat = npc:Maat@ル・ルデの庭 H-5
RW other:レベル上限が60になる
RW title:山の頂に立つ者
LK quest:クエスト「限界への挑戦」をコンプリート
LK condition:Lv51以上
g01 talk - | Lv51以上でル・ルデの庭(H-5)大公私邸前のMaatに話して受ける | - | @ル・ルデの庭 H-5 | T npc.243.Maat
g02 examine - | ザルカバード(J-6)のBoreal Coeurlの洞窟の奥の???を調べ、だいじなもの「四角い氷石」を手に入れる | NMは倒さなくてよい。インスニを見破るので、マウントで入ってNMが???から離れたすきに降りて調べると楽。 | @ザルカバード J-6 | T obj.112.qqq_Square_Frigicite = obj:???~@ザルカバード J-6
g03 examine - | ザルカバード(G-10)のBoreal Houndの洞窟の奥の???を調べ、だいじなもの「六角形の氷石」を手に入れる | - | @ザルカバード G-10 | T obj.112.qqq_Triangular_Frigicite = obj:???~@ザルカバード G-10
g04 examine - | ザルカバード(I-5)のBoreal Tigerの洞窟の奥の???を調べ、だいじなもの「丸い氷石」を手に入れる | - | @ザルカバード I-5 | T obj.112.qqq_Round_Frigicite = obj:???~@ザルカバード I-5
g05 talk - | 3つの氷石を持ってMaatに話して完了 | - | @ル・ルデの庭 H-5 | T npc.243.Maat | K 四角い氷石,六角形の氷石,丸い氷石

@ quest.jeuno.114 https://wiki.ffo.jp/html/27539.html
Q Beam Me Up...No, Not There! | ストレンジワープ | yes | T npc.243.Anastase = npc:Anastase@ル・ルデの庭 G-9
RW other:経験値（ふつう400／難しい750〜1500／激ヤバ1500〜2000）
RW other:個人戦績（ふつう200／難しい400／激ヤバ800〜1000）
RW item:ジャングルクッキー（ふつう3枚／難しい6枚／激ヤバ12枚。補正せずに報告すると1枚）
LK quest:クエスト「危険地帯の磁場調査」をクリアしてエリアを出入りする（2回目からは出入りしなくてよい）
g01 talk - | ル・ルデの庭(G-9)の街路のAnastaseに話し、選択肢の空欄を選んで受ける | 2回目からは「例のアレを頼む」。 | @ル・ルデの庭 G-9 | T npc.243.Anastase
g02 talk - | 「ふつう」「難しい」「激ヤバ」から選び、ランダムなエリアのふつうでない場所へ飛ばされる | 初回はだいじなもの「磁場コンパス」をもらう。ふつう：タロンギ・コンシュタット・メリファト・パシュハウ／難しい：海蛇の岩窟・ムバルポロス旧市街・リヴェーヌ岩塊群サイトB01（巨大な鱗2枚）・ジャグナー／激ヤバ：アットワ地溝（Tiamatの広場）・流砂洞・ウルガラン山脈。 | @ル・ルデの庭 G-9 | T npc.243.Anastase
g03 examine - | 飛ばされたエリアの正しいGeomagnetic Fountまで行って調べ、記録を補正する | ここで経験値をもらえる。Lv99でも着いたとたんに絡まれることがある。
g04 talk - | Anastaseに報告して完了 | - | @ル・ルデの庭 G-9 | T npc.243.Anastase

@ quest.jeuno.115 https://wiki.ffo.jp/html/27530.html
Q Middle Lands Investigation | 中の国の磁場調査 | no | T npc.243.Anastase
RW item:ジャングルクッキー6枚
RW other:個人戦績2000
RW other:各磁場を記録したときに経験値
LK quest:クエスト「西の国からの調査団」をクリアしてエリアを出入りする
g01 talk - | ル・ルデの庭(G-9)のAnastaseに話して受ける | 欠けたロゼッタ石があれば、受ける前から記録できる。順番は自由。 | @ル・ルデの庭 G-9 | T npc.243.Anastase
g02 examine - | 西ロンフォール(E-8)のGeomagnetic Fountを調べる | ボストーニュ監獄を通って行く。経験値900。 | @西ロンフォール E-8 | T obj.100.Geomagnetic_Fount = obj:Geomagnetic Fount@西ロンフォール E-8
g03 examine - | 北グスタベルグ(D-8)のGeomagnetic Fountを調べる | 経験値750。 | @北グスタベルグ D-8 | T obj.106.Geomagnetic_Fount = obj:Geomagnetic Fount@北グスタベルグ D-8
g04 examine - | 西サルタバルタ(F-4)のGeomagnetic Fountを調べる | 経験値320。 | @西サルタバルタ F-4 | T obj.115.Geomagnetic_Fount = obj:Geomagnetic Fount@西サルタバルタ F-4
g05 examine - | ラテーヌ高原(H-10)のGeomagnetic Fountを調べる | 経験値600。 | @ラテーヌ高原 H-10 | T obj.102.Geomagnetic_Fount = obj:Geomagnetic Fount@ラテーヌ高原 H-10
g06 examine - | コンシュタット高地(L-5)のGeomagnetic Fountを調べる | 経験値500。 | @コンシュタット高地 L-5 | T obj.108.Geomagnetic_Fount = obj:Geomagnetic Fount@コンシュタット高地 L-5
g07 examine - | タロンギ大峡谷(I-9)テンキー7のGeomagnetic Fountを調べる | 経験値500。 | @タロンギ大峡谷 I-9 | T obj.117.Geomagnetic_Fount = obj:Geomagnetic Fount@タロンギ大峡谷 I-9
g08 examine - | ジャグナー森林(G-5)テンキー5のGeomagnetic Fountを調べる | 経験値750。 | @ジャグナー森林 G-5 | T obj.104.Geomagnetic_Fount = obj:Geomagnetic Fount@ジャグナー森林 G-5
g09 examine - | パシュハウ沼(I-7)テンキー3のGeomagnetic Fountを調べる | 経験値500。 | @パシュハウ沼 I-7 | T obj.109.Geomagnetic_Fount = obj:Geomagnetic Fount@パシュハウ沼 I-7
g10 examine - | メリファト山地(G-8)テンキー9のGeomagnetic Fountを調べる | 経験値500。 | @メリファト山地 G-8 | T obj.119.Geomagnetic_Fount = obj:Geomagnetic Fount@メリファト山地 G-8
g11 examine - | アットワ地溝(J-8)テンキー2のGeomagnetic Fountを調べる | プロマシアの呪縛が必要。経験値900。 | @アットワ地溝 J-8 | T obj.7.Geomagnetic_Fount = obj:Geomagnetic Fount@アットワ地溝 J-8
g12 examine - | ウルガラン山脈(H-7)のGeomagnetic Fountを調べる | 晴れのときだけ(H-8)から入れる通路の中。プロマシアの呪縛が必要。経験値2000。 | @ウルガラン山脈 H-7 | T obj.5.Geomagnetic_Fount = obj:Geomagnetic Fount@ウルガラン山脈 H-7 | W 晴れ
g13 talk - | 11か所を記録したらAnastaseに話して完了 | - | @ル・ルデの庭 G-9 | T npc.243.Anastase

@ quest.jeuno.116 https://wiki.ffo.jp/html/20006.html
Q New Worlds Await | 人体強化の術！ | no | T npc.243.Nomad_Moogle
RW other:レベル上限が80になる
LK condition:Lv75でリミットブレーカーを受け取っている
g01 gather - | 「獣神印章」5個とメリットポイント3ポイント以上を用意する | ジュノ港のShamiに預けた印章も返してもらえる。 | N 獣神印章*5
g02 talk - | ル・ルデの庭(H-5)のNomad Moogleに話し、限界について聞いて「挑戦する！」を選ぶ | - | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle
g03 trade - | Nomad Moogleに「獣神印章」5個をトレードして完了 | メリットポイント3も使う。イベントのあとレベル上限が80になる。 | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle | N 獣神印章*5

@ quest.jeuno.117 https://wiki.ffo.jp/html/3820.html
Q Northward | 北の地への導き | no | T npc.243.Radeivepart
RW gil:2,000ギル
RW other:経験値（リミットポイント）2000
RW title:北への使者
RW key_item:ズヴァール城地図
LK fame:ジュノの名声ランク4以上
g01 talk - | ル・ルデの庭(H-9)記念碑のそばのRadeivepartに話して受ける | - | @ル・ルデの庭 H-9 | T npc.243.Radeivepart
g02 gather - | 「フレイムデーゲン」を1本用意する | 錬金術で作る、オルデール鍾乳洞のボム族「Napalm」がまれに落とす、エミネンスで交換する。HQは不可。 | N フレイムデーゲン*1
g03 trade - | Radeivepartに「フレイムデーゲン」をトレードして完了 | ズヴァール城地図を持っていれば地図はもらえない。 | @ル・ルデの庭 H-9 | T npc.243.Radeivepart | N フレイムデーゲン*1

@ quest.jeuno.118 https://wiki.ffo.jp/html/27538.html
Q Further Founts | 危険地帯の磁場調査 | no | T npc.243.Anastase
RW item:ジャングルクッキー12枚
RW other:個人戦績3000
RW other:各磁場を記録したときに経験値
LK quest:クエスト「中の国の磁場調査」をクリアしてエリアを出入りする
XS BG Wiki;https://www.bg-wiki.com/ffxi/Further_Founts;Giant Scale の座標 C-10
g01 talk - | ル・ルデの庭(G-9)のAnastaseに話して受ける | 受ける前から記録できる。順番は自由。Lv75以上なら、流砂洞・ボヤーダ樹・ムバルポロス旧市街・海蛇の岩窟（NMがいるとき）のほかは絡まれずに行ける。 | @ル・ルデの庭 G-9 | T npc.243.Anastase
g02 examine - | ダボイ(I-8)テンキー8のGeomagnetic Fountを調べる | - | @ダボイ I-8 | T obj.149.Geomagnetic_Fount = obj:Geomagnetic Fount@ダボイ I-8
g03 examine - | ベドーMAP2(G-7)テンキー9のGeomagnetic Fountを調べる | 地下のThe Muteのすぐ後ろ。 | @ベドー G-7 #2 | T obj.147.Geomagnetic_Fount = obj:Geomagnetic Fount@ベドー G-7 #2
g04 examine - | オズトロヤ城(G-8)テンキー3のGeomagnetic Fountを調べる | - | @オズトロヤ城 G-8 | T obj.151.Geomagnetic_Fount = obj:Geomagnetic Fount@オズトロヤ城 G-8
g05 examine - | 流砂洞(F-7)のGeomagnetic Fountを調べる | 西アルテパ砂漠(D-12)から入ったマップの、重量扉の奥。 | @流砂洞 F-7 | T obj.208.Geomagnetic_Fount = obj:Geomagnetic Fount@流砂洞 F-7
g06 examine - | 海蛇の岩窟MAP3(J-5)のGeomagnetic Fountを調べる | 獣人ミスリル貨で開く扉の先。 | @海蛇の岩窟 J-5 #3 | T obj.176.Geomagnetic_Fount = obj:Geomagnetic Fount@海蛇の岩窟 J-5 #3
g07 examine - | ウガレピ寺院MAP2(H-8)テンキー5のGeomagnetic Fountを調べる | - | @ウガレピ寺院 H-8 #2 | T obj.159.Geomagnetic_Fount = obj:Geomagnetic Fount@ウガレピ寺院 H-8 #2
g08 examine - | ボヤーダ樹(D-4)テンキー3のGeomagnetic Fountを調べる | - | @ボヤーダ樹 D-4 | T obj.153.Geomagnetic_Fount = obj:Geomagnetic Fount@ボヤーダ樹 D-4
g09 examine - | ムバルポロス旧市街(K-11)のGeomagnetic Fountを調べる | 南側の跳ね橋のレバーのそば。 | @ムバルポロス旧市街 K-11 | T obj.11.Geomagnetic_Fount = obj:Geomagnetic Fount@ムバルポロス旧市街 K-11
g10 examine - | リヴェーヌ岩塊群サイトB01(C-10)のGeomagnetic Fountを調べる | 「巨大な鱗」2枚がいる。プロマシアミッション「猛き者たちよ」まで進めていないと入れない。 | @リヴェーヌ岩塊群サイトB01 C-10 | T obj.29.Geomagnetic_Fount = obj:Geomagnetic Fount@リヴェーヌ岩塊群サイトB01 C-10 | N 巨大な鱗*2
g11 examine - | ズヴァール城内郭(H-8)テンキー1のGeomagnetic Fountを調べる | - | @ズヴァール城内郭 H-8 | T obj.162.Geomagnetic_Fount = obj:Geomagnetic Fount@ズヴァール城内郭 H-8
g12 talk - | 10か所を記録したらAnastaseに話して完了 | - | @ル・ルデの庭 G-9 | T npc.243.Anastase

@ quest.jeuno.119 https://wiki.ffo.jp/html/12.html
Q Riding on the Clouds | 天かける雲のごとく | no | T npc.243.Maat
RW other:レベル上限が70になる
RW title:雲入道
LK quest:クエスト「風の行方は」をコンプリート
LK condition:Lv61以上
g01 talk - | Lv61以上でル・ルデの庭(H-5)のMaatに話して受け、4人のヒントを聞く | 4人はサンドリア・バストゥーク・ウィンダス・セルビナかマウラから1人ずつ、ランダムに決まる。 | @ル・ルデの庭 H-5 | T npc.243.Maat
g02 gather - | 「獣神印章」を4個用意する | ジュノ港のShamiに預けた印章も返してもらえる。 | N 獣神印章*4
g03 trade - | ヒントに合うサンドリアの人に「獣神印章」をトレードし、だいじなもの「人面石」をもらう | 候補：Raminel（南サンドリア・巡回）・Sobane（南D-6）・Taurette（北F-7）・Maloquedil（北J-8）・Sheridan（港H-10）・Fontoumant（港H-10）・Brifalien（港H-8）・Rugiette（港J-8）。まちがえても印章は減らない。 | N 獣神印章*1
g04 trade - | ヒントに合うバストゥークの人に「獣神印章」をトレードし、「人面石」をもらう | 候補：Babenn（鉱山区J-6）・Gwill（商業区E-11）・Brygid（商業区K-9）・Kaede（港J-5）・Hilda（港E-6）・Naji（大工房J-8）・Raibaht（大工房G-8）・Lucius（大工房I-9）。 | N 獣神印章*1
g05 trade - | ヒントに合うウィンダスの人に「獣神印章」をトレードし、「人面石」をもらう | 候補：Koru-Moru（石の区E-7）・Koko Lihzeh（水の区北K-6）・Naiko-Paneiko（水の区南C-11）・Kerutoto（水の区南J-8）・Shanruru（港H-5）・Boizo-Naizo（森の区H-10）・Sola Jaab（森の区K-10）・Kupipi（天の塔）。 | N 獣神印章*1
g06 trade - | ヒントに合うセルビナかマウラの人に「獣神印章」をトレードし、「人面石」をもらう | 候補：Mathilde（セルビナH-9）・Vobo（I-7）・Melyon（I-9）・Gabwaleid（H-9）・Celestina（マウラG-8）・Ekokoko（F-9）・Bihoro-Guhoro（G-9）・Jikka-Abukka（H-9）。 | N 獣神印章*1
g07 talk - | 4つの「人面石」を持ってMaatに話して完了 | - | @ル・ルデの庭 H-5 | T npc.243.Maat

@ quest.jeuno.120 https://wiki.ffo.jp/html/25729.html
Q Martial Mastery | 契約と覚悟、武の道程 | no | T npc.243.Nomad_Moogle
RW other:メリットポイントに「ウェポンスキル」のカテゴリーが増える
RW key_item:武の記憶
RW title:武神流免許皆伝
LK condition:Lv96以上
LK quest:クエスト「最後の試練！」をコンプリート
g01 talk - | Lv96以上でル・ルデの庭(H-5)のMaatのとなりのNomad Moogleに話して受ける | 形のうえの依頼者はアトリトゥトリだが、本人はいない。 | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle
g02 go - | メリットポイントを15ポイント以上ためる | -
g03 talk - | もう一度Nomad Moogleに話して完了 | メリットポイント15を使う。覚えたウェポンスキルを使うには、さらにメリットポイントの割り振りと武器スキル357以上がいる。 | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle

@ quest.jeuno.121 https://wiki.ffo.jp/html/1002.html
Q Shattering Stars | 星の輝きを手に | yes | T npc.243.Maat
RW other:レベル上限が75になる
RW title:マート マッシャー（BFで勝ったとき）
RW title:ヴァナ・ディールのスター（報告したとき）
LK quest:クエスト「天かける雲のごとく」をコンプリート
LK condition:Lv66以上（受けたジョブでなくても、Lv66以上ならクリアできる）
g01 talk - | ル・ルデの庭(H-5)のMaatに話して受ける | ジラートの幻影までの15ジョブ用。ジョブで中身が変わる。 | @ル・ルデの庭 H-5 | T npc.243.Maat
g02 gather - | 挑むジョブの「偉大な ＜ジョブ名＞ の証」を手に入れる | 一定のレベル以上の獣人などが落とす。前もって手に入れておいてもよい。
g03 trade - | Maatに証をトレードし、ジョブごとのBFの前へ送ってもらう | ホルレーの岩峰＝戦黒狩、ワールンの祠＝赤シ獣、バルガの舞台＝モ白召、ク・ビアの闘技場＝ナ暗吟、宣託の間＝侍忍竜。 | @ル・ルデの庭 H-5 | T npc.243.Maat
g04 fight - | BFに証をトレードし、Maatとの一騎打ちに勝つ | 10分、サポートジョブなし。HPを7〜8割削るか、ジョブごとの降参の条件を満たすと勝ち。時間をかけると夢想阿修羅拳を連発する。同じ証で3回まで挑める。 | T mob.Maat = mob:Maat
g05 talk - | ジュノに戻ってMaatに報告して完了 | - | @ル・ルデの庭 H-5 | T npc.243.Maat

@ quest.jeuno.122 https://wiki.ffo.jp/html/25735.html
Q Beyond Infinity | 最後の試練！ | no | T npc.243.Nomad_Moogle
RW other:レベル上限が99になる
RW title:武神の門出に立つ者
RW other:このあとジュノ下層(J-7)天晶堂入口のDomenicがギルでBFへ送ってくれる
LK quest:クエスト「ある食客のメッセージ」をクリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Beyond_Infinity;Olde Rarab Tail（しっぽ亭の特製漬物）の座標 I-10
g01 talk - | 「ある食客のメッセージ」で香味石を渡したあと、Nomad Moogleに話してイベントを見る | - | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle
g02 trade - | バストゥーク商業区(I-10)のDegenhardに「香味石」「骨の化石」「牙の化石」をトレードして「しっぽ亭の特製漬物」をもらう | しなくてもよいが、とても楽になる（90秒テラーとダメージの上限の解除）。3つの品は各国のGreeter Moogleで5ポイントずつ交換できる。 | @バストゥーク商業区 I-10 | T npc.235.Degenhard | N 香味石*1,骨の化石*1,牙の化石*1
g03 talk - | Nomad Moogleに話して「準備できた！」を選び、BFの入口へ送ってもらう | ホルレーの岩峰・ワールンの祠・バルガの舞台・ク・ビアの闘技場のどれか。 | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle
g04 fight - | BFでAtori-Tutoriを倒す | 6人・10分・フェイス可。強化は持ちこめず、フェイスは中に入ってから呼ぶ。負けたら魔王印章5個かメリットポイント1でNomad Moogleから宝珠の鉤をもらい直せる。 | T mob.Atori-Tutori = mob:Atori-Tutori | K 宝珠の鉤
g05 talk - | ジュノに戻ってNomad Moogleに話して完了 | - | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle

@ quest.jeuno.123 https://wiki.ffo.jp/html/24818.html
Q Dormant Powers Dislodged | 東方の秘術！ | no | T npc.243.Nomad_Moogle
RW other:レベル上限が95になる
RW key_item:魂の宝珠
LK condition:Lv86以上
LK quest:クエスト「真・人体強化の術！」をコンプリート
g01 go - | メリットポイントを10ポイント以上ためる | -
g02 talk - | ル・ルデの庭(H-5)のNomad Moogleに話し、アトリトゥトリと契約する | ここで持ってくる品がランダムに決まる。 | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle
g03 trade - | Nomad Moogleに「魔人印章」1個と指定の品をトレードする | 指定の品はセイレーンの涙・ダングルフの奇岩石・バルクルムの太陽砂・オークの装甲板・クゥダフの背甲部品・ヤグードパテ・オーキシュアクス・呪われたサレコウベ・変色クリスタル・ダルメルの唾液などのどれか。 | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle | N 魔人印章*1
g04 talk - | ミニゲームで「ここからクポ！」のあと約10秒で「気合を入れる！」を選んで完了 | 失敗してもすぐやり直せて、品は取り直さなくてよい。回を重ねると目安のログが増える。 | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle

@ quest.jeuno.124 https://wiki.ffo.jp/html/22245.html
Q Beyond the Stars | 真・人体強化の術！ | no | T npc.243.Nomad_Moogle
RW other:レベル上限が90になる
LK condition:Lv81以上
LK quest:クエスト「続・人体強化の術！」をコンプリート
g01 gather - | 「魔人印章」10個とメリットポイント5ポイント以上を用意する | - | N 魔人印章*10
g02 talk - | ル・ルデの庭(H-5)のNomad Moogleに話し、限界突破に「挑戦する」を選ぶ | - | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle
g03 trade - | Nomad Moogleに「魔人印章」10個をトレードしてミニゲームを始める | - | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle | N 魔人印章*10
g04 talk - | じゃんけんのような5回勝負で5勝して完了 | 5敗で失敗。やり直すたびに要る勝ち数が1つずつ減り、ペナルティはない。 | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle

@ quest.jeuno.125 https://wiki.ffo.jp/html/21136.html
Q Expanding Horizons | 続・人体強化の術！ | no | T npc.243.Nomad_Moogle
RW other:レベル上限が85になる
LK condition:Lv76以上
LK quest:クエスト「人体強化の術！」をコンプリート
g01 gather - | 「魔人印章」5個とメリットポイント4ポイント以上を用意する | - | N 魔人印章*5
g02 talk - | ル・ルデの庭(H-5)のNomad Moogleに話し、限界について聞いて「挑戦する！」を選ぶ | - | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle
g03 trade - | Nomad Moogleに「魔人印章」5個をトレードして完了 | メリットポイント4も使う。 | @ル・ルデの庭 H-5 | T npc.243.Nomad_Moogle | N 魔人印章*5

@ quest.jeuno.126 https://wiki.ffo.jp/html/27529.html
Q Researchers from the West | 西の国からの調査団 | no | T npc.243.Anastase
RW item:ジャングルクッキー3枚
RW other:個人戦績400
RW other:各地のProto-Waypointでワープできるようになる
g01 talk - | ル・ルデの庭(G-9)ホームポイント#1の近くのAnastaseに話し、だいじなもの「欠けたロゼッタ石」をもらう | - | @ル・ルデの庭 G-9 | T npc.243.Anastase
g02 talk - | セルビナ(G-10)のJilliaに話して磁場を記録する | 記録したときからワープできる（cpがいる）。 | @セルビナ G-10 | T npc.248.Jillia = npc:Jillia@セルビナ G-10
g03 talk - | マウラ(I-8)のZurko-Bazurkoに話して磁場を記録する | - | @マウラ I-8 | T npc.249.Zurko-Bazurko = npc:Zurko-Bazurko@マウラ I-8
g04 talk - | ラバオ(G-8)のQuwi Orihbheに話して磁場を記録する | ジラートの幻影が必要。 | @ラバオ G-8 | T npc.247.Quwi_Orihbhe = npc:Quwi Orihbhe@ラバオ G-8
g05 talk - | ノーグ(G-7)のWistful Bisonに話して磁場を記録する | ジラートの幻影が必要。 | @ノーグ G-7 | T npc.252.Wistful_Bison = npc:Wistful Bison@ノーグ G-7
g06 talk - | 4か所を記録したらAnastaseに話して完了 | - | @ル・ルデの庭 G-9 | T npc.243.Anastase

@ quest.jeuno.127 https://wiki.ffo.jp/html/5.html
Q In Defiant Challenge | 限界への挑戦 | no | T npc.243.Maat
RW other:レベル上限が55になる
RW title:オーバー・ザ・トップ
LK condition:Lv50
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/In_Defiant_Challenge;Maat H-5
g01 talk - | Lv50でル・ルデの庭(H-5)のMaatに話して受ける | 3つの品はどれもRare Exで、本人が集める。 | @ル・ルデの庭 H-5 | T npc.243.Maat
g02 defeat - | エルディーム古墳のLichを倒して「古代魔法のパピルス」を手に入れる | 倒さずに、MAP2(H-9)(F-9)(F-7)の???で紙片を3つ集めてもよい。だいじなもの「魔法の天文盤」があると扉が楽。 | @エルディーム古墳 | T mob.195.Lich = mob:Lich@エルディーム古墳
g03 defeat - | クロウラーの巣のExorayを倒して「エクソレイの粘菌」を手に入れる | 倒さずに、MAP2(I-10)・MAP4(I-6)・MAP3(G-10)の???で断片を3つ集めてもよい。ボムと蜂は見て気づく。 | @クロウラーの巣 | T mob.197.Exoray = mob:Exoray@クロウラーの巣
g04 defeat - | ガルレージュ要塞のExplosureを倒して「ボムの炭」を手に入れる | 第一魔防門の奥にいるので、先にMAP1(G-8)の小部屋で「程よい重さの石」を取る。倒さずに、MAP2(I-8)(H-7)(G-6)の???で小片を3つ集めてもよい。 | @ガルレージュ要塞 | T mob.200.Explosure = mob:Explosure@ガルレージュ要塞
g05 trade - | Maatに3つの品をトレードして完了 | - | @ル・ルデの庭 H-5 | T npc.243.Maat | N 古代魔法のパピルス*1,エクソレイの粘菌*1,ボムの炭*1

@ quest.jeuno.128 https://wiki.ffo.jp/html/10.html
Q Whence Blows the Wind | 風の行方は | no | T npc.243.Maat
RW other:レベル上限が65になる
RW title:風来坊
LK quest:クエスト「すべての高い山に登れ」をコンプリート
LK condition:Lv56以上
LK condition:深紅のオーブのほかのだいじなものは、三国ミッション「魔晶石を奪え」まで進めないと手に入らない（持っている人と一緒なら通れる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Whence_Blows_the_Wind;Orcish crest の場所 ダボイ H-11（修道窟の入口）、Quadav crest の場所 ベドー K-6（地下道の入口）
g01 talk - | Lv56以上でル・ルデの庭(H-5)のMaatに話して受ける | - | @ル・ルデの庭 H-5 | T npc.243.Maat
g02 examine - | ダボイ(H-11)から修道窟を通って中央の島へ行き、(J-9)のWall of Banishingを「深紅のオーブ」で通る | 深紅のオーブは、結界を2回調べたあとダボイ(J-8)のSedal-Godjalに話すともらえる。 | @修道窟 J-9 | T obj.150.Wall_of_Banishing = obj:Wall of Banishing@修道窟 J-9 | K 深紅のオーブ
g03 examine - | 奥の修道の広場を左手の壁ぞいに進み、(J-6)テンキー1の???を調べて「オークの紋章」を手に入れる | 段差を降りる前に取る。奥には見破るNMがいる。 | @修道窟 J-6 | T obj.150.qqq_Orcish_Crest = obj:???~@修道窟 J-6
g04 go - | ベドーの高台から(K-6)の地下道へ行き、(M-8)からクゥルンの大伽藍に入る | - | @ベドー K-6
g05 examine - | 「漆黒のマチネー」と「妖光の数珠」でDoorを開ける | - | @クゥルンの大伽藍 | T obj.148.Door = obj:Door~@クゥルンの大伽藍 | K 漆黒のマチネー,妖光の数珠
g06 examine - | 中枢の奥の岸の中央の???を調べて「クゥダフの紋章」を手に入れる | - | @クゥルンの大伽藍 | T obj.148.qqq_Quadav_Crest = obj:???~@クゥルンの大伽藍
g07 go - | 「ヤグードの松明」を持ってオズトロヤ城へ行き、1階の暗号の部屋(H-9テンキー9)と2階の隠し部屋(I-10)のレバーの並び、暗号の部屋(I-8テンキー7)を確かめる | オズトロヤの仕掛けはヴァナ時間の0時で変わる。暗号の候補はDeggi・Haqa・Mjuu・Puqu・Ouzi・Duzu・Gadu・Mong・Buxu・Xicu（先頭は大文字、順は問わない）。 | @オズトロヤ城 | K ヤグードの松明
g08 go - | (G-8)のレバーで3階へ上がる | - | @オズトロヤ城 G-8
g09 examine - | 4階の燭台に灯りをつけて(H-7)テンキー1の扉を開け、奥の装置に暗号を3つ入れて落とし穴へ降りる | - | @オズトロヤ城 H-7
g10 examine - | 高台の中央（H-6のテンキー4と7の境目）の???を調べて「ヤグードの紋章」を手に入れる | 最深部からはデジョンなどで出ると楽。 | @オズトロヤ城 H-6 | T obj.151.qqq_Yagudo_Crest = obj:???~@オズトロヤ城 H-6
g11 talk - | 3つの紋章を持ってMaatに話して完了 | - | @ル・ルデの庭 H-5 | T npc.243.Maat | K オークの紋章,クゥダフの紋章,ヤグードの紋章

@ quest.jeuno.129 https://wiki.ffo.jp/html/3729.html
Q The Old Monument | 古い歌碑 | no | T npc.245.Mertaire = npc:Mertaire@ジュノ下層 I-8
RW item:詩が記された羊皮紙
RW title:古典研究家
LK condition:Lv30以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Old_Monument;羊皮紙はマウラ(G-9)の倉庫の Pikini-Mikini でも買える。歌碑へはマウラの西の浜(H-9)から入り、南西の隅の水中のトンネルを抜ける
g01 talk - | ジュノ下層(I-8)の吟遊詩人の酒場でMertaireに話す | オファーリストには載らない。「マリーベル」という名前が出れば受けている。 | @ジュノ下層 I-8 | T npc.245.Mertaire
g02 gather - | 「羊皮紙」を1枚用意する | 競売のほか、マウラ(G-9)の倉庫でも買える。 | N 羊皮紙*1
g03 examine - | ブブリム半島(G-9)のSong Runesを調べてイベントを見る | ビビキー湾の入口の手前の海岸。マウラの西の浜(H-9)から南西の隅の水中のトンネルを抜けて行く。 | @ブブリム半島 G-9 | T obj.118.Song_Runes = obj:Song Runes@ブブリム半島 G-9
g04 trade - | Song Runesに羊皮紙をトレードし、「詩が記された羊皮紙」をもらって完了 | 次は「自暴自棄の吟遊詩人」。 | @ブブリム半島 G-9 | T obj.118.Song_Runes | N 羊皮紙*1

@ quest.jeuno.130 https://wiki.ffo.jp/html/7631.html
Q Path of the Bard | 吟遊詩人ジョブゲット | no | T obj.103.Song_Runes = obj:Song Runes@バルクルム砂丘 B-7
RW other:吟遊詩人にジョブチェンジできるようになる
RW gil:3000ギル
RW title:心の歌うたい
LK quest:「自暴自棄の吟遊詩人」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Path_of_the_Bard;依頼者は Bki Tbujhja（ジュノ下層 H-8）とある（用語辞典は Lewenhart）。Song Runes へはバルクルム砂丘(C-6)のトンネルを抜けた隠し海岸
g01 talk - | ジュノ下層(H-8)の吟遊詩人の酒場でBki Tbujhjaに話し、次に行く場所を聞く | オファーリストには載らない。 | @ジュノ下層 H-8 | T npc.245.Bki_Tbujhja
g02 examine - | バルクルム砂丘(C-6)のトンネルを抜けて西の隠し海岸へ行き、(B-7)のSong Runesを調べてイベントを見て完了 | グスタフの洞門のサバイバルガイドからバルクルム砂丘に出ると近い。 | @バルクルム砂丘 B-7 | T obj.103.Song_Runes

@ quest.jeuno.131 https://wiki.ffo.jp/html/2931.html
Q Axe the Competition | 信じるは己の腕 | no | T npc.244.Brutus
RW other:ウェポンスキル「デシメーション」を覚える
LK condition:Lv71以上の戦・暗・獣・狩・剣で、片手斧スキル240以上
LK condition:ほかのウェポンスキルのクエストを進めていない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Axe_the_Competition;Brutus は ジュノ上層(G-7)、???は ウガレピ寺院 MAP3 (G-9)
g01 talk - | 条件を満たしてジュノ上層(G-7)チョコボ厩舎のBrutusに話して受け、「トライアルピック」とだいじなもの「修行の書」をもらう | - | @ジュノ上層 G-7 | T npc.244.Brutus
g02 fight - | トライアルピックをメインに装備して、ウェポンスキルで敵を倒し、潜在能力を消す | - | N トライアルピック*1
g03 trade - | Brutusに「トライアルピック」をトレードし、だいじなもの「試練の地図」をもらう | - | @ジュノ上層 G-7 | T npc.244.Brutus | N トライアルピック*1
g04 examine - | ウガレピ寺院MAP3(G-9)の???を調べる | MAP3 へは、ヨアトル大森林(J-12)から寺院に入り(J-7)の北の隠し通路でヨアトル大森林(J-9)へ出て入り直すか、ヨアトル大森林(K-7)から怨念洞MAP7を抜ける。 | @ウガレピ寺院 G-9 #3 | T obj.159.???_G-9 = obj:???@ウガレピ寺院 G-9 #3
g05 fight - | 出てきた樹人族NM「Yallery Brown」を倒す | グーグーパウダーの範囲がとても広く、まず全員が眠らされる（服毒しておくとよい）。昼は強いリジェネがある。 | @ウガレピ寺院 G-9 #3 | T mob.159.Yallery_Brown = mob:Yallery Brown@ウガレピ寺院 G-9 #3
g06 examine - | もう一度???を調べ、だいじなもの「試練の書」を手に入れる | - | @ウガレピ寺院 G-9 #3 | T obj.159.???_G-9
g07 talk - | ジュノ上層のBrutusに話して完了 | - | @ジュノ上層 G-7 | T npc.244.Brutus | K 試練の書

@ quest.jeuno.132 https://wiki.ffo.jp/html/8164.html
Q Searching for the Right Words | 君への忘れもの | no | T npc.244.Ilumida
RW item:スリプガIIのスクロール
RW gil:3,000ギル
LK fame:ジュノの名声ランク6以上
LK quest:「亡き夫へのキャンドル」「ゴミのおつかい」「なくしものはなんですか」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Searching_for_the_Right_Words;FLevel=6（用語辞典は「ある程度の名声」とだけ）。Ilumida は ジュノ上層(G-8)、???は ボヤーダ樹 MAP2 (H-8)、19:00〜4:00
g01 talk - | ジュノ下層(I-7)占い屋のKurou-Morouに話してイベント | これでオファーの準備ができる。 | @ジュノ下層 I-7 | T npc.245.Kurou-Morou
g02 talk - | ジュノ上層(G-8)のIlumidaに話し、「引き受ける」を選んで受ける | - | @ジュノ上層 G-8 | T npc.244.Ilumida
g03 examine - | 新月以外のヴァナ時間19:00〜4:00に、ボヤーダ樹MAP2(H-8)の???を調べる | 周りのアクティブなカニに気をつける。 | @ボヤーダ樹 H-8 #2 | T obj.153.???_H-8 = obj:???@ボヤーダ樹 H-8 #2 | W 19:00〜4:00（新月以外）
g04 fight - | 出てきたアーリマン族NM「Agas」を倒す | スリプガIIとレベル5ペトロに気をつける。 | @ボヤーダ樹 H-8 #2 | T mob.153.Agas = mob:Agas@ボヤーダ樹 H-8 #2
g05 examine - | 19:00〜4:00のうちにもう一度???を調べ、だいじなもの「月の雫」を手に入れる | 4:00を過ぎていたら19:00まで待つ（NMはもう出ない）。 | @ボヤーダ樹 H-8 #2 | T obj.153.???_H-8 | W 19:00〜4:00
g06 talk - | ジュノ上層のIlumidaに話して完了 | 完了後にKurou-Morouに話すと、短いイベントがある。 | @ジュノ上層 G-8 | T npc.244.Ilumida | K 月の雫

@ quest.jeuno.133 https://wiki.ffo.jp/html/1983.html
Q Beat Around the Bushin | 武に賭けた想い | no | T npc.245.Vola
RW item:黒帯
RW title:黒帯の有段者
LK fame:天晶堂の名声ランク6以上
LK condition:モンクLv71以上
LK quest:「腕におぼえあり！」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Beat_Around_the_Bushin;Vola は ジュノ下層(J-8)、Degenhard は バストゥーク商業区(I-10)、Maat は ル・ルデの庭(H-5)
g01 talk - | モンクLv71以上で、ジュノ下層(J-8)天晶堂のVolaに話してイベント | - | @ジュノ下層 J-8 | T npc.245.Vola
g02 examine - | 海神楼へ戻る階段を上った(J-7)のDoor:Neptune's Spireを調べて受ける | (J-7)に扉は4つあるが、どれも天晶堂と海神楼の間の扉。 | @ジュノ下層 J-7 | T obj.245.Door_Neptunes_Spire
g03 trade - | 扉に「ウィルムの逆鱗」をトレードしてイベント | Nidhogg か BF「真龍」で手に入る（Rare Ex）。 | @ジュノ下層 J-7 | T obj.245.Door_Neptunes_Spire | N ウィルムの逆鱗*1
g04 talk - | バストゥーク商業区(I-10)のDegenhardに話す | ホームポイント#4が近い。 | @バストゥーク商業区 I-10 | T npc.235.Degenhard
g05 trade - | ジュノ下層の扉に「ベヒーモスの舌」をトレードしてイベント | King Behemoth か BF「戦慄の角」で手に入る（Rare Ex）。 | @ジュノ下層 J-7 | T obj.245.Door_Neptunes_Spire | N ベヒーモスの舌*1
g06 talk - | ル・ルデの庭(H-5)のMaatに話す | - | @ル・ルデの庭 H-5 | T npc.243.Maat
g07 trade - | ジュノ下層の扉に「アダマンタスの卵」をトレードしてイベント | Aspidochelone か BF「動く島」で手に入る（Rare Ex）。 | @ジュノ下層 J-7 | T obj.245.Door_Neptunes_Spire | N アダマンタスの卵*1
g08 trade - | 扉に「茶帯」をトレードしてイベント、完了 | 茶帯は「腕におぼえあり！」の報酬。 | @ジュノ下層 J-7 | T obj.245.Door_Neptunes_Spire | N 茶帯*1

@ quest.jeuno.134 https://wiki.ffo.jp/html/6040.html
Q Beyond the Sun | 光とともにあれ | no | T npc.243.Maat
RW item:マートキャップ
RW title:天下無双魔阿斗戦覇者
LK quest:「星の輝きを手に」で、ジラートまでの15ジョブすべてでMaatに勝つ（オファーリストには載らない）
LK quest:「最後の試練！」を受けていたら、先に終える
XS BG Wiki;https://www.bg-wiki.com/ffxi/Beyond_the_Sun;Maat は ル・ルデの庭(H-5)。FLevel は空。勝ったジョブは、魂の聖櫃の Teyrnon でジョブの知識の交換値が 10000 から 5000 に下がっているかで分かる
g01 fight - | ジラートまでの15ジョブそれぞれをLv66以上にし、「星の輝きを手に」でMaatに勝つ | 戦・モ・白・黒・赤・シ・ナ・暗・獣・詩・狩・侍・忍・竜・召。1回目に勝ったあとは、戦闘不能で経験値が減る。シーフは盗むではなく倒す。 | T mob.Maat
g02 talk - | 15ジョブのどれかで、ル・ルデの庭(H-5)のMaatに話してイベント、完了 | - | @ル・ルデの庭 H-5 | T npc.243.Maat

@ quest.jeuno.135 https://wiki.ffo.jp/html/12414.html
Q A Chocobo's Tale | 消えた銀星号 | no | T npc.244.Nevela = npc:Nevela@ジュノ上層 G-7
RW gil:5200ギル
RW title:チョコボの愛を解いた者
LK quest:プロマシアミッション第3章「主のなき都」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Chocobo%27s_Tale;Fame=Jeuno、FLevel は空（用語辞典にも名声の条件はない。FFXIclopedia は「Jeuno Reputation ?」）。Quest Reqs=Promathia Mission 3-2。Wobke は バストゥーク鉱山区(I-9)、降魔の油はベドーの Emerald Quadav、???は バタリア丘陵(H-6)の墓石、Badshah 5匹。Outpost Gate の場所は用語辞典の パシュハウ沼(K-6)
g01 talk - | ジュノ上層(G-7)のNevelaに話して受ける | - | @ジュノ上層 G-7 | T npc.244.Nevela
g02 talk - | バストゥーク鉱山区(I-9)のチョコボ厩舎のWobkeに話す | - | @バストゥーク鉱山区 I-9 | T npc.234.Wobke = npc:Wobke@バストゥーク鉱山区 I-9
g03 examine - | パシュハウ沼(K-6)のアウトポストのOutpost Gateを調べてイベント | - | @パシュハウ沼 K-6 | T obj.109.Outpost_Gate = obj:Outpost Gate@パシュハウ沼 K-6
g04 gather - | ベドーのEmerald Quadavを倒して「降魔の油」を3個集める | 渡すまでの期限はない。 | N 降魔の油*3
g05 trade - | Outpost Gateに「降魔の油」3個をトレードしてイベント | - | @パシュハウ沼 K-6 | T obj.109.Outpost_Gate | N 降魔の油*3
g06 talk - | バストゥーク鉱山区のWobkeに話す | - | @バストゥーク鉱山区 I-9 | T npc.234.Wobke
g07 examine - | バタリア丘陵(H-6)の丘の墓石にある???を調べる | - | @バタリア丘陵 H-6 | T obj.105.???_H-6 = obj:???@バタリア丘陵 H-6
g08 fight - | 出てきた剣虎族NM「Badshah」5匹を倒す | - | @バタリア丘陵 H-6 | T mob.105.Badshah = mob:Badshah@バタリア丘陵 H-6
g09 examine - | もう一度???を調べて「銀星号の首輪」を手に入れる | - | @バタリア丘陵 H-6 | T obj.105.???_H-6
g10 talk - | ジュノ上層のNevelaに話して完了 | - | @ジュノ上層 G-7 | T npc.244.Nevela | K 銀星号の首輪

@ quest.jeuno.136 https://wiki.ffo.jp/html/10371.html
Q A Reputation in Ruins | 謎の遺跡ソ・ジヤ | no | T npc.244.Migliorozz = npc:Migliorozz@ジュノ上層 H-9
RW gil:3,500ギル
LK fame:ジュノの名声がある程度いる（段階は資料にない）
LK quest:プロマシアミッション3-3「ふたつの道」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Reputation_in_Ruins;Fame=Jeuno、FLevel は空（用語辞典は「ある程度のジュノの名声」で段階なし）。Quest Reqs=Promathia Mission 3-3。ボスディン氷河(G-9)の塔からソ・ジヤに入る。???は(I-8)と(H-7)、青い扉は(H-9)、Crystal Receptor は(G-8)、足場は120秒で消える、エレベーターは(H-8)。腕輪は2つとも残る（FFXIclopedia も同じマス）
g01 talk - | ジュノ上層(H-9)女神聖堂のMigliorozzに話して受け、だいじなもの「鳳凰の腕輪」（「神を名乗りて」を終えていれば「鳳凰の宝珠」）をもらう | どちらでも進め方は同じ。 | @ジュノ上層 H-9 | T npc.244.Migliorozz
g02 examine - | ボスディン氷河(G-9)の塔からソ・ジヤに入り、階段を上った(I-8)の小部屋の???を調べる | 調べると部屋の扉が閉まるので、全員入ってから調べる。 | @ソ・ジヤ I-8 | T obj.9.???_I-8 = obj:???@ソ・ジヤ I-8
g03 fight - | 出てきたNM「Gargoyle-Iota」と「Gargoyle-Kappa」を倒す | 物理が効かない時と魔法が効きにくい時が入れ替わり、青か黄色に光る。 | @ソ・ジヤ I-8 | T mob.9.Gargoyle-Iota = mob:Gargoyle-Iota@ソ・ジヤ I-8
g04 examine - | もう一度???を調べ、だいじなもの「青く光る腕輪」を手に入れる | - | @ソ・ジヤ I-8 | T obj.9.???_I-8
g05 examine - | (H-9)の青い扉を通って穴を降り、(H-7)の小部屋の???を調べる | - | @ソ・ジヤ H-7 | T obj.9.???_H-7 = obj:???@ソ・ジヤ H-7 | K 青く光る腕輪
g06 fight - | 出てきたNM「Gargoyle-Lambda」と「Gargoyle-Mu」を倒す | 1組目と同じ。 | @ソ・ジヤ H-7 | T mob.9.Gargoyle-Lambda = mob:Gargoyle-Lambda@ソ・ジヤ H-7
g07 examine - | もう一度???を調べ、だいじなもの「緑に輝く腕輪」を手に入れる | - | @ソ・ジヤ H-7 | T obj.9.???_H-7
g08 examine - | 入口近くの(I-8)から階段を上がり、緑の扉の先の(G-8)のCrystal Receptorを調べる | 足場が出ているのは120秒だけ。 | @ソ・ジヤ G-8 | T obj.9.Crystal_Receptor = obj:Crystal Receptor@ソ・ジヤ G-8 | K 緑に輝く腕輪
g09 go - | 急いで(H-9)の穴から降り、西から北へ足場を渡って(H-8)のエレベーターで下りる | 下の敵は音に反応する。 | @ソ・ジヤ H-8
g10 examine - | 下の円い部屋の西のAvatar Gateを調べてイベント | - | @ソ・ジヤ | T obj.9.Avatar_Gate = obj:Avatar Gate@ソ・ジヤ
g11 talk - | ジュノ上層のMigliorozzに話して完了 | 腕輪は2つとも残る。 | @ジュノ上層 H-9 | T npc.244.Migliorozz

@ quest.jeuno.137 https://wiki.ffo.jp/html/13427.html
Q Hook, Line, and Sinker | 冤罪 | no | T npc.245.Omer = npc:Omer@ジュノ下層 G-10
RW gil:3000ギル
RW title:勝訴の支援者
LK quest:プロマシアミッション第3章「主のなき都」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Hook,_Line,_and_Sinker;Fame=Jeuno、FLevel は空（用語辞典にも名声の条件はない）。Quest Reqs=Promathia Mission 3-2。イーグレットの釣竿はクフィム島で釣れる Kraken が落とす（釣りスキルはいらない）。フレームレートが60だとイベントで止まる
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/Hook,_Line,_and_Sinker;Sea Bishop も落とす。最初のイベントは既定の30Hzで見る
g01 talk - | ジュノ下層(G-10)市場橋のOmerに話して受ける | 最初のイベントは、フレームレートを既定の30にしておかないと止まることがある。 | @ジュノ下層 G-10 | T npc.245.Omer
g02 gather - | クフィム島で釣れるクラーケン族を倒して「イーグレットの釣竿」を手に入れる | 釣りスキルはいらない。 | @クフィム島 | N イーグレットの釣竿*1
g03 trade - | Omerに「イーグレットの釣竿」をトレードして完了 | - | @ジュノ下層 G-10 | T npc.245.Omer | N イーグレットの釣竿*1

@ quest.jeuno.138 https://wiki.ffo.jp/html/13425.html
Q In the Mood for Love | 本当の愛を求めて | no | T npc.245.Odasel = npc:Odasel@ジュノ下層 H-9
RW gil:4800ギル
RW title:ナンパな愛を解いた者
LK quest:プロマシアミッション第3章「主のなき都」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/In_the_Mood_for_Love;Fame=Jeuno、FLevel は空（用語辞典にも名声の条件はない）。Quest Reqs=Promathia Mission 3-2。Odasel は ジュノ下層(H-9)の宝石店の前。カメレオンダイヤはルフェーゼ野の巨人族。終えたあと店の中の Matoaka に話すとイベント
g01 talk - | ジュノ下層(H-9)宝石店クシャマの前のOdaselに話して受ける | - | @ジュノ下層 H-9 | T npc.245.Odasel
g02 gather - | ルフェーゼ野の巨人族を倒して「カメレオンダイヤ」を手に入れる | - | @ルフェーゼ野 | N カメレオンダイヤ*1
g03 trade - | Odaselに「カメレオンダイヤ」をトレードして完了 | 店の中のMatoakaに話すと続きのイベントがある。 | @ジュノ下層 H-9 | T npc.245.Odasel | N カメレオンダイヤ*1

@ quest.jeuno.139 https://wiki.ffo.jp/html/1216.html
Q Storms of Fate | 日輪を担いて | no | T npc.243.Eshantarl = npc:Esha'ntarl@ル・ルデの庭 H-7
RW key_item:龍王の息吹
RW title:人の系譜を開く者
LK quest:プロマシアミッション「暁」クリアし、イベント「呪縛ほどけるとき」を見ている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Storms_of_Fate;Fame=Jeuno、FLevel は空、Repeatable=No、Quest Reqs=Promathia Mission 8-4。ミザレオ海岸 (F-7) の Dilapidated Gate、サイトB01 (E-7) の Unstable Displacement、BF は Bahamut
g01 go - | ル・ルデの庭(H-7)の大公宮に入ってイベント | フェイス「プリッシュ」を持っていないと、「亡者の影」を終えるまでもらえない。 | @ル・ルデの庭 H-7
g02 examine - | ミザレオ海岸(F-7)のDilapidated Gateを調べてイベント | - | @ミザレオ海岸 F-7 | T obj.25.Dilapidated_Gate = obj:Dilapidated Gate@ミザレオ海岸 F-7
g03 examine - | リヴェーヌ岩塊群サイトB01(E-7)のUnstable Displacementを調べてイベント | ホームポイントから北東の渦で島へ渡る。真上に立つまで緑にならない。歩いて行くなら巨大な鱗が1枚いる。 | @リヴェーヌ岩塊群サイトB01 E-7 | T obj.29.Unstable_Displacement_E-7 = obj:Unstable Displacement@リヴェーヌ岩塊群サイトB01 E-7
g04 fight - | もう一度調べてBFに入り、Bahamutに勝ってだいじなもの「龍王の息吹」を手に入れる | 18人まで、Lv制限はない。 | @リヴェーヌ岩塊群サイトB01 E-7 | T mob.Bahamut = mob:Bahamut@リヴェーヌ岩塊群サイトB01 | K 龍王の息吹
g05 go - | ル・ルデの庭の大公宮に入ってイベントを見て完了 | 次は「亡者の影」。 | @ル・ルデの庭 H-7

@ quest.jeuno.140 https://wiki.ffo.jp/html/5557.html
Q Shadows of the Departed | 亡者の影 | no | T npc.243.Eshantarl
RW other:「世界に在りて君は何を想うのか？」へ続く
LK quest:ジラートミッション「1万年の夢の終わりに」とクエスト「日輪を担いて」クリア後、ヴァナ時間0時を越えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Shadows_of_the_Departed;Fame=Jeuno、FLevel は空。Memory Flux はホラ (J-8)・デム (K-4)・メア (K-6) の第4層（用語辞典はホラが J-10）
g01 go - | ル・ルデの庭の大公宮に入ってイベントを見て、だいじなもの「エシャンタールメモ」をもらう | 前のクエストを終えたら、次の日まで待つ。 | @ル・ルデの庭 H-7 | K エシャンタールメモ
g02 examine - | プロミヴォン-ホラの第4層のMemory Fluxを調べる | 3つは順不同。マスは(J-10)とも(J-8)とも書かれている。 | @プロミヴォン-ホラ J-10 | T obj.16.Memory_Flux = obj:Memory Flux@プロミヴォン-ホラ J-10
g03 examine - | プロミヴォン-デムの第4層(K-4)のMemory Fluxを調べる | - | @プロミヴォン-デム K-4 | T obj.18.Memory_Flux = obj:Memory Flux@プロミヴォン-デム K-4
g04 examine - | プロミヴォン-メアの第4層(K-6)のMemory Fluxを調べる | - | @プロミヴォン-メア K-6 | T obj.20.Memory_Flux = obj:Memory Flux@プロミヴォン-メア K-6
g05 go - | ル・ルデの庭の大公宮に入ってイベントを見て完了 | 次は「世界に在りて君は何を想うのか？」。 | @ル・ルデの庭 H-7

@ quest.jeuno.141 https://wiki.ffo.jp/html/7291.html
Q Apocalypse Nigh | 世界に在りて君は何を想うのか？ | yes | T npc.243.Eshantarl
RW item:電界の耳・磁界の耳・虚界の耳・幽界の耳から1つ
RW title:呪縛を葬りし者
LK quest:「亡者の影」クリア後、ヴァナ時間0時を越えてからエリアチェンジ
XS BG Wiki;https://www.bg-wiki.com/ffxi/Apocalypse_Nigh;Fame=Jeuno、FLevel は空、Repeatable=Yes、Quest Reqs=Zilart Mission 17, Promathia Mission 8-4。海獅子の巣窟で Sueleen、フ・ゾイの王宮の Gate of the Gods、天象の鎖の Transcendental Radiance、BF は Kam'lanaut と Eald'narche（フェイス可）
g01 go - | ル・ルデの庭の大公宮に入ってイベント | - | @ル・ルデの庭 H-7
g02 talk - | 海獅子の巣窟に入ってイベントを見て、Sueleenに話してアル・タユへ行く | ちがうイベントになったら、タブナジア地下壕に出て入り直す。 | @海獅子の巣窟 | T npc.32.Sueleen = npc:Sueleen@海獅子の巣窟
g03 examine - | フ・ゾイの王宮MAP1(H-8)のGate of the Godsを調べてイベントを見て、ル・メトの園へ行く | - | @フ・ゾイの王宮 H-8 #1 | T obj.34.Gate_of_the_Gods = obj:Gate of the Gods@フ・ゾイの王宮 H-8 #1
g04 go - | ル・メトの園(H-8)の中央のエレベーターで「下へ行く」を選び、天象の鎖へ行く | - | @ル・メトの園 H-8
g05 examine - | 天象の鎖のTranscendental Radianceを調べてイベント | - | T obj.Transcendental_Radiance = obj:Transcendental Radiance@天象の鎖
g06 fight - | もう一度調べてBFに入り、Kam'lanautとEald'narcheに勝つ | 6人まで、Lv制限はない。勝つとアル・タユへ飛ばされる。 | T mob.Kamlanaut = mob:Kam'lanaut@天象の鎖
g07 talk - | ジュノ下層(J-8)の天晶堂の奥のAldoに話してイベント | - | @ジュノ下層 J-8 | T npc.245.Aldo = npc:Aldo@ジュノ下層 J-8
g08 talk - | ヴァナ時間0時を過ぎてから、ノーグ(L-8)のGilgameshに話し、耳を選んで完了 | 耳を取り直すときは、耳を捨てて天象の鎖の???で記憶を消し、「亡者の影」からやり直す。 | @ノーグ L-8 | T npc.252.Gilgamesh

@ quest.jeuno.142 https://wiki.ffo.jp/html/7138.html
Q Ducal Hospitality | 故郷に錦を | yes | T npc.243.Taillegeas = npc:Taillegeas@ル・ルデの庭 I-7
RW gil:4000
RW title:搾取される弱者
LK quest:プロマシアミッション「主のなき都」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Ducal_Hospitality;Fame=Jeuno、FLevel は空、Repeatable=Yes、Quest Reqs=Promathia Mission 3-2。Taillegeas (I-7)。頼まれる品は20種類から決まった組
g01 talk - | ル・ルデの庭(I-7)のオーロラ宮殿の食堂のTaillegeasに話して受ける | - | @ル・ルデの庭 I-7 | T npc.243.Taillegeas
g02 gather - | 言われた品をすべて集める | 5つの組からランダムに決まる。たとえばゴブリンパン・ゴブリンパイ・ゴブリン風キノコ鍋・ゴブリン人形・ゴブリンの贋ギル。
g03 trade - | Taillegeasに集めた品をトレードして完了 | - | @ル・ルデの庭 I-7 | T npc.243.Taillegeas

@ quest.jeuno.143 https://wiki.ffo.jp/html/11501.html
Q Empty Memories | 虚ろなる記憶 | yes | T npc.243.Harith = npc:Harith@ル・ルデの庭 H-5
RW item:驚のアニマ・迷のアニマ・脅のアニマ・破魔弓・ディアワンド・ストーンゴルゲットのどれか
LK other:プロミヴォンに入ったことがある
XS BG Wiki;https://www.bg-wiki.com/ffxi/Empty_Memories;Fame=1、FLevel は空、Repeatable=Yes。Harith (H-5)。アニマの3つは記憶の一塊と 2,000 ギル、ほかの3つは記憶の一塊だけ（用語辞典は全部 2,000 ギル）
g01 talk - | ル・ルデの庭(H-5)の大公私邸のHarithに話して受ける | Venessaとまちがえない。 | @ル・ルデの庭 H-5 | T npc.243.Harith
g02 gather - | プロミヴォンのエンプティから記憶の一塊を手に入れる | 恐ろしき・悩ましき・疾しき・苦苦しき・忌忌しき・禍禍しきの6種類。どれを渡すかで報酬が決まる。 | @プロミヴォン-ホラ
g03 trade - | Harithに記憶の一塊をトレードし、品をもらって完了 | アニマの3つは2,000ギルもいっしょに渡す。アニマは同じものを1つしか持てない。 | @ル・ルデの庭 H-5 | T npc.243.Harith | N ギル*2000
