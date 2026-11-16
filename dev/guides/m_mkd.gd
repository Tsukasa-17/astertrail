# 戦慄！モグ祭りの夜（0.1.122〜）。基礎シートのミッション一覧 256〜270 行。id の番号はシートの行−255、order も同じ
@ mission.mkd.001 https://wiki.ffo.jp/html/16528.html
Q A Moogle Kupo d'Etat | 戦慄！モグ祭りの夜 | no
MN MKD1 1
LK condition:追加シナリオ「戦慄！モグ祭りの夜」を持っている、Lv10以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupo_Mission_1;Lv10以上で所属国のモグハウスのモーグリに話すとイベント。レンタルハウスではだめ（FFXIclopedia にこの節の手順はない）
g01 talk - | Lv10以上で所属国のモグハウスに入り、モーグリに話してイベントを見ると完了 | レンタルハウスではイベントにならない。終わると「ぴちょん！始まりは一滴の雨漏り」になる。

@ mission.mkd.002 https://wiki.ffo.jp/html/17681.html
Q Drenched! It Began with a Raindrop | ぴちょん！始まりは一滴の雨漏り | no
MN MKD2 2
LK condition:前節「戦慄！モグ祭りの夜」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupo_Mission_2;Orc. Armor Plate はユグホトの岩屋のオーク族、Quadav Backscale はパルブロ鉱山のクゥダフ族、Yagudo Caulk はギデアスのヤグード族（FFXIclopedia は龍王ランペールの墓・ダングルフの涸れ谷・内ホルトト遺跡のゴブリン族も）。所属国のモグハウスで3つまとめてトレード
g01 gather - | ユグホトの岩屋のオーク族か龍王ランペールの墓のゴブリン族を倒して「オークの装甲板」を手に入れる | 強い敵ほど落としやすいらしい。 | @ユグホトの岩屋
g02 gather - | パルブロ鉱山のクゥダフ族かダングルフの涸れ谷のゴブリン族を倒して「クゥダフの背甲部品」を手に入れる | - | @パルブロ鉱山
g03 gather - | ギデアスのヤグード族か内ホルトト遺跡のゴブリン族を倒して「ヤグードパテ」を手に入れる | - | @ギデアス
g04 trade - | 所属国のモグハウスのモーグリに3つまとめてトレードすると完了 | レンタルハウスではだめ。先にジュノ港のSquintrox Dryeyesに渡すと白珊瑚のカギになるが、集め直しになる。 | N オークの装甲板,クゥダフの背甲部品,ヤグードパテ

@ mission.mkd.003 https://wiki.ffo.jp/html/17682.html
Q Hasten! In a Jam in Jeuno? | いざゆけ！出張モグハウス | no | T obj.244.Inconspicuous_Door = obj:Inconspicuous Door@ジュノ上層 H-8
MN MKD3 3
LK condition:前節「ぴちょん！始まりは一滴の雨漏り」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupo_Mission_3;ジュノ上層 H-8、Durable Shields の向かいの Inconspicuous Door（FFXIclopedia も同じ）
g01 examine - | ジュノ上層(H-8)の防具屋「不朽の盾」の向かいのInconspicuous Doorを調べてイベントを見ると完了 | - | @ジュノ上層 H-8 | T obj.244.Inconspicuous_Door

@ mission.mkd.004 https://wiki.ffo.jp/html/17691.html
Q Welcome! To My Decrepit Domicile | ようこそ！スウィート・モグリハウス | no | T obj.244.Inconspicuous_Door
MN MKD4 4
LK condition:前節「いざゆけ！出張モグハウス」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupo_Mission_4;採掘で sturdy metal strip、伐採で piece of rugged tree bark、収穫で savory lamb roast（FFXIclopedia はオリジナル・ジラートのエリアならどこでも）。3つとも先に集めてよい。1つ渡すごとにイベント
g01 gather - | 採掘でだいじなもの「鋭い金属片」を手に入れる | ツェールン鉱山・パルブロ鉱山・グスゲン鉱山など。カバンをいっぱいにしておくと採掘場所が消えず、同じ場所で続けられる。 | @パルブロ鉱山
g02 gather - | 伐採でだいじなもの「硬い樹皮」を手に入れる | ジャグナー森林・ゲルスバ野営陣など。 | @ゲルスバ野営陣
g03 gather - | 収穫でだいじなもの「皮付き羊肉の燻製」を手に入れる | 西サルタバルタ・ギデアスなど。 | @ギデアス
g04 examine - | ジュノ上層(H-8)のInconspicuous Doorを調べ、3つとも渡し終えると完了 | 1つ渡すごとにイベントがある。 | @ジュノ上層 H-8 | T obj.244.Inconspicuous_Door | K 鋭い金属片,硬い樹皮,皮付き羊肉の燻製

@ mission.mkd.005 https://wiki.ffo.jp/html/17692.html
Q Curses! A Horrifically Harrowing Hex | 恐怖！呪われし悪霊の部屋 | no | T npc.239.Shantotto = npc:Shantotto@ウィンダス石の区 K-7
MN MKD5 5
LK condition:前節「ようこそ！スウィート・モグリハウス」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupo_Mission_5;ウィンダス石の区 K-7 の Shantotto に話すとイベント（FFXIclopedia も同じ）
g01 talk - | ウィンダス石の区(K-7)のShantottoに話してイベントを見ると完了 | 終わると「走れ！解呪の品を求めて」になる。 | @ウィンダス石の区 K-7 | T npc.239.Shantotto

@ mission.mkd.006 https://wiki.ffo.jp/html/17693.html
Q An Errand! The Professor's Price | 走れ！解呪の品を求めて | no
MN MKD6 6
RW key_item:熟れた星の木の実
RW key_item:桃珊瑚のカギ
LK condition:前節「恐怖！呪われし悪霊の部屋」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupo_Mission_6;外ホルトト遺跡のカーディアン族から Orb of Swords・Cups・Batons・Coins。東サルタバルタ H-3 から入ってすぐの H-6 の ??? でその場の戦い（FFXIclopedia は入口の向かいの台の上と書いていて座標はない）。Shantotto に5000ギル
g01 gather - | 外ホルトト遺跡のカーディアン族を倒して、ソード・カップ・バトン・コインの魔導球を集める | 持っていない魔導球の攻撃は効かないので、4つそろえるとよい。アライアンスならみんなに出る。 | @外ホルトト遺跡
g02 examine - | 東サルタバルタ(H-3)から外ホルトト遺跡に入り、すぐ前の(H-6)の???を調べて、その場の戦いを始める | 30分。フェイスとペットは戦いが始まると消える。始めると魔導球は全部なくなる。 | @外ホルトト遺跡 H-6 | T obj.194.???_H-6 = obj:???@外ホルトト遺跡 H-6
g03 defeat - | 出てくるCustom Cardianを全部倒す | 魔導球4つなら5体、3つなら10体、それより少ないと15体。 | @外ホルトト遺跡 H-6
g04 talk - | ウィンダス石の区のShantottoに話して、5000ギルを払う | 払わないとイベントが変わる。エリアを移ってから話し直す。 | @ウィンダス石の区 K-7 | T npc.239.Shantotto
g05 examine - | ジュノ上層(H-8)のInconspicuous Doorを調べてイベントを見ると完了 | - | @ジュノ上層 H-8 | T obj.244.Inconspicuous_Door

@ mission.mkd.007 https://wiki.ffo.jp/html/17698.html
Q Shock! Arrant Abuse of Authority | 愕然！今日から借金王 | no | T obj.244.Inconspicuous_Door
MN MKD7 7
RW key_item:泥だらけの木箱
LK condition:前節「走れ！解呪の品を求めて」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupo_Mission_7;モーグリが言うエリアでチョコボ掘り。掘るたびに方角と近さが出る（FFXIclopedia も同じ。エリアを移ると箱の場所が変わる）。Moldy, worm-eaten chest
g00 go - | モーグリが言ったエリアへ、ギサールの野菜を20〜40個ほど持って行く | 三国とジュノのまわりをのぞく、オリジナルとジラートのエリアのどれか。
g01 gather - | チョコボ掘りでだいじなもの「泥だらけの木箱」を掘り出す | 掘るたびに、どちらの方角か・どれくらい近いかが出る。エリアを移ると箱の場所が変わる。どのエリアか忘れたら、Inconspicuous Doorを調べ直すと教えてくれる。
g02 examine - | ジュノ上層(H-8)のInconspicuous Doorを調べてイベントを見ると完了 | - | @ジュノ上層 H-8 | T obj.244.Inconspicuous_Door | K 泥だらけの木箱

@ mission.mkd.008 https://wiki.ffo.jp/html/17699.html
Q Lender Beware! Read the Fine Print | モグ金！ご利用は計画的に | no | T obj.176.Shady_Sconce = obj:Shady Sconce@海蛇の岩窟 C-5
MN MKD8 8
LK condition:前節「愕然！今日から借金王」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupo_Mission_8;Shady Sconce は海蛇の岩窟 C-5（C-8 の隠し部屋の奥。FFXIclopedia も同じ）。J-11 の Ornamented Door をサハギンのカギで抜け、Waterfall Basin は H-6（BG Wiki は Map 5）
g01 examine - | 海蛇の岩窟の(C-8)からひびの入った壁を抜けて隠し部屋に入り、奥の(C-5)のShady Sconceを調べてイベントを見る | イベントにならないときは2回調べる。 | @海蛇の岩窟 C-5 | T obj.176.Shady_Sconce
g02 examine - | (J-11)のOrnamented Doorをサハギンのカギで抜け、橋を渡って(H-6)のWaterfall Basinを調べてイベントを見る | 扉は向こうからは開かないので、帰る手段を用意する。扉の先はスニークを。近くの???と間違えないように。 | @海蛇の岩窟 H-6 | T obj.176.Waterfall_Basin = obj:Waterfall Basin@海蛇の岩窟 H-6 | N サハギンのカギ
g03 examine - | ジュノ上層(H-8)のInconspicuous Doorを調べてイベントを見ると完了 | - | @ジュノ上層 H-8 | T obj.244.Inconspicuous_Door

@ mission.mkd.009 https://wiki.ffo.jp/html/17704.html
Q Rescue! A Moogle's Labor of Love | 焦燥！愛しいあの子はいずこ | no | T npc.208.Goblin_Geologist = npc:Goblin Geologist@流砂洞 J-11
MN MKD9 9
RW key_item:九曜星の数珠
LK condition:前節「モグ金！ご利用は計画的に」クリア、だいじなもの「流砂洞地図」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupo_Mission_9;西アルテパ砂漠 D-12 から入った流砂洞の Goblin Geologist は J-11（FFXIclopedia は座標なし）。??? 9か所は人によって違い、地図の緑のマーカーに出る。宣託の間の Shimmering Circle でイベント
g01 talk - | 西アルテパ砂漠(D-12)の奥から流砂洞に入り、(J-11)のGoblin Geologistに話す | 「流砂洞地図」がないと先へ進めない。 | @流砂洞 J-11 | T npc.208.Goblin_Geologist | K 流砂洞地図
g02 examine - | 地図に出た9か所の???を回って、9つの石を集める | 場所は人によって違う。地図の「他のエリア」で先に場所を見ておくと早い。取ってもマーカーは消えない。 | @流砂洞
g03 talk - | Goblin Geologistにもう一度話して、だいじなもの「九曜星の数珠」を受け取る | - | @流砂洞 J-11 | T npc.208.Goblin_Geologist
g04 examine - | 宣託の間のShimmering Circleを調べてイベントを見ると完了 | 流砂洞のHome Point #1が宣託の間のすぐそば。 | @宣託の間 | T obj.宣託の間.Shimmering_Circle = obj:Shimmering Circle@宣託の間

@ mission.mkd.010 https://wiki.ffo.jp/html/17705.html
Q Roar! A Cat Burglar Bares Her Fangs | 吠えよ！やとわれ用心棒 | no | T obj.宣託の間.Shimmering_Circle
MN MKD10 10
RW key_item:紅珊瑚のカギ
LK condition:だいじなもの「九曜星の数珠」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupo_Mission_10;Shimmering Circle から BF。Nanaa Mihgo を倒せば勝ち（FFXIclopedia も同じ。ゴブリン3体と、途中でミスラ2人が出る）
g01 fight - | 宣託の間のShimmering CircleからBFに入り、用心棒たちに勝つと完了 | 6人まで・30分・レベル制限なし。経験値は減らない。フェイスを呼べる。Nanaa Mihgoを倒せば勝ち。睡眠が効く。九曜星の数珠は入ると消える。 | @宣託の間 | T obj.宣託の間.Shimmering_Circle | K 九曜星の数珠

@ mission.mkd.011 https://wiki.ffo.jp/html/17749.html
Q Relief! A Triumphant Return | 帰還！ふたりの家路 | no | T obj.244.Inconspicuous_Door
MN MKD11 11
LK condition:前節「吠えよ！やとわれ用心棒」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupo_Mission_11;ジュノ上層 H-8 の Inconspicuous Door（FFXIclopedia も同じ）
g01 examine - | ジュノ上層(H-8)のInconspicuous Doorを調べてイベントを見ると完了 | 終わると「歓喜！モグ祭りへの招待状」になる。 | @ジュノ上層 H-8 | T obj.244.Inconspicuous_Door

@ mission.mkd.012 https://wiki.ffo.jp/html/17750.html
Q Joy! Summoned to a Fabulous Fete | 歓喜！モグ祭りへの招待状 | no
MN MKD12 12
LK condition:前節「帰還！ふたりの家路」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupo_Mission_12;ズヴァール城外郭に入るとイベント（FFXIclopedia も同じ）
g01 go - | ズヴァール城外郭に入ってイベントを見ると完了 | Survival Guideで飛ぶと早い。 | @ズヴァール城外郭

@ mission.mkd.013 https://wiki.ffo.jp/html/17751.html
Q A Challenge! You Could Be a Winner | めざせ！超モグボナンザ抽選会 | no | T obj.111.Lonely_Evergreen = obj:Lonely Evergreen@ボスディン氷河 G-7
MN MKD13 13
RW key_item:超モグボナンザ参加券
LK condition:前節「歓喜！モグ祭りへの招待状」クリア、だいじなもの「雪原エリア地図」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupo_Mission_13;最初にズヴァール城外郭 J-8 の Shadowy Pillar を調べる（FFXIclopedia も同じ）。Lonely Evergreen G-7、Goblin Grenadier H-8（FFXIclopedia は H-8/H-9）。Option One G/H-8（FFXIclopedia は H-8）・Two G-9・Three G-8。Flame of Fate は外郭の2枚目 G-8。Ominous Pillar は内郭に入ってすぐ
g01 examine - | ズヴァール城外郭(J-8)のShadowy Pillarを調べてイベントを見る | ボスディン氷河へ行くように言われる。 | @ズヴァール城外郭 J-8 | T obj.161.Shadowy_Pillar = obj:Shadowy Pillar@ズヴァール城外郭 J-8
g02 examine - | ボスディン氷河(G-7)のLonely Evergreenを調べてイベントを見る | - | @ボスディン氷河 G-7 | T obj.111.Lonely_Evergreen
g03 talk - | (H-8/H-9)のGoblin Grenadierに話し、まわりの6つのPipを調べる | Pipを調べると地図に属性が出る。ボスディン氷河から出ると最初からになる。 | @ボスディン氷河 H-8 H-9 | T npc.111.Goblin_Grenadier = npc:Goblin Grenadier@ボスディン氷河 H-8 H-9 | K 雪原エリア地図
g04 talk - | 曜日で隣りあう属性のPipを縦と横だけで線でつなぎ、できた数字(0～9)をGoblin Grenadierに答えて、だいじなもの「魅惑のきらきら爆弾」をもらう | 曜日の順は火・土・水・風・氷・雷・光・闇で、闇と火も隣。ヒントは2回まで聞ける。答えられるのは1回。 | @ボスディン氷河 H-8 H-9 | T npc.111.Goblin_Grenadier
g05 examine - | Lonely Evergreenを調べて、だいじなもの「ヴリトラクイズ参加券」をもらう | - | @ボスディン氷河 G-7 | T obj.111.Lonely_Evergreen | K 魅惑のきらきら爆弾
g06 examine - | ザルカバードのOption One・Option Two・Option Threeを使うクイズに3問続けて正解して、だいじなもの「肝試し大会参加券」をもらう | 自分のステータスや戦績を2択で答える。大きいほうが小さいほうのおよそ2倍なら大きいほう、1.5倍ほどなら小さいほうが正解。 | @ザルカバード G-8 G-9 H-8 | K ヴリトラクイズ参加券
g07 examine - | ズヴァール城外郭(J-8)のShadowy Pillarを調べ、Lv1の制限とインビジ・スニーク・デオードがかかったら、8分のうちに2枚目(G-8)のFlame of Fateを調べて、だいじなもの「モグ祭り露店クーポン券」をもらう | 魔法は途中で切れることがあるので、プリズムパウダーとサイレントオイルを持っていく。ズヴァール城内郭に入らないように。 | @ズヴァール城外郭 G-8 #2 | T obj.161.Flame_of_Fate = obj:Flame of Fate@ズヴァール城外郭 G-8 #2 | K 肝試し大会参加券
g08 examine - | ズヴァール城内郭(H-8)のOminous Pillarを調べ、転送の先の部屋ごとにCraggy Pillarを調べて、だいじなもの「超モグボナンザ参加券」をもらう | 正解のCraggy Pillarは人ごとに違う。王の間に入らないように。 | @ズヴァール城内郭 H-8 | T obj.162.Ominous_Pillar = obj:Ominous Pillar@ズヴァール城内郭 H-8 | K モグ祭り露店クーポン券
g09 examine - | 王の間のThrone Roomを調べてイベントを見ると完了 | - | @王の間 | T obj.王の間.Throne_Room = obj:Throne Room@王の間

@ mission.mkd.014 https://wiki.ffo.jp/html/17752.html
Q Smash! A Malevolent Menace | 砕け！邪なる者の野望 | no | T obj.王の間.Throne_Room
MN MKD14 14
RW key_item:ボケ珊瑚のカギ
RW key_item:血赤珊瑚のカギ
RW title:モグハウス・キーパー
LK condition:だいじなもの「超モグボナンザ参加券」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupo_Mission_14;Throne Room から BF、相手は Riko Kupenreich（FFXIclopedia も同じ。称号 Mog House Handyperson）。負けたらボスディン氷河の Lonely Evergreen からやり直す
g01 fight - | 王の間のThrone RoomからBFに入り、Riko Kupenreichに勝つと完了 | 6人まで・30分・レベル制限なし。経験値は減らない。フェイスを呼べる。HPが減ると玉座へ下がって手下を呼び、回復する。負けたらボスディン氷河のLonely Evergreenから参加券を取り直す。 | @王の間 | T obj.王の間.Throne_Room | K 超モグボナンザ参加券

@ mission.mkd.015 https://wiki.ffo.jp/html/17753.html
Q A Moogle Kupo d'Etat (Fin.) | 戦慄！モグ祭りの夜＜完＞ | no
MN MKD15 15
LK condition:「砕け！邪なる者の野望」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupo_Mission_15;ジュノ下層の天晶堂の宝箱（FFXIclopedia は Treasure Coffer）を調べると、Anwig Salade・Champion's Galea・Selenian Cap のどれか。BG Wiki はカギの宝箱をジュノ下層 J-8 と書いている
g01 examine - | ジュノ下層の天晶堂の中のTreasure Cofferを調べ、ナイトの兜・ダイアの冑・魔人の帽子から1つ選んで受け取ると完了 | どれか1つしか持てない。選び直すときは持っているものを捨てて、最後の戦いをもう一度勝つ。 | @ジュノ下層 J-8
