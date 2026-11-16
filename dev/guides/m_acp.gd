# 石の見る夢（0.1.122〜）。基礎シートのミッション一覧 243〜255 行。id の番号はシートの行−242。order は id と同じ（始めるにはだけ 999）
@ mission.acp.001 https://wiki.ffo.jp/html/39143.html
Q To commence ACP | 「石の見る夢」を始めるには…… | no | T obj.245.Tales_Beginning = obj:Tales' Beginning@ジュノ下層 G-9
MN - 999
LK condition:ジュノ下層に入って「後にする」を選んだ
g01 examine - | ジュノ下層(G-9)のTales' Beginningを調べてオープニングのイベントを見ると完了 | 「後にする」を選んだときだけ一覧に出る。このあと「石の見る夢」になる。 | @ジュノ下層 G-9 | T obj.245.Tales_Beginning

@ mission.acp.002 https://wiki.ffo.jp/html/16529.html
Q A Crystalline Prophecy | 石の見る夢 | no
MN ACP1 2
LK condition:追加シナリオ「石の見る夢」を持っている、Lv10以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystalline_Mission_1;Lv10以上でジュノ下層に入るとイベント（FFXIclopedia にこの節の手順はない）
g01 go - | Lv10以上でジュノ下層に入ってイベントを見ると完了 | 「後にする」を選んだときは、ジュノ下層(G-9)のTales' Beginningを調べる。終わると「よみがえりし原初の意志」になる。 | @ジュノ下層

@ mission.acp.003 https://wiki.ffo.jp/html/22023.html
Q The Echo Awakens | よみがえりし原初の意志 | no
MN ACP2 3
LK condition:前節「石の見る夢」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystalline_Mission_2;日光の欠片はジャグナー森林 G-11、月光の欠片はパシュハウ沼 K-10、星彩の欠片はメリファト山地 K-8 あたりの獣人から（FFXIclopedia も同じ）。??? はクフィム島 G-6 の東、2本の岩の柱のあいだ
g01 gather - | ジャグナー森林のオーク族を倒して、だいじなもの「日光の欠片」を手に入れる | ダボイの入口のあたり(G-11)に多い。 | @ジャグナー森林 G-11
g02 gather - | パシュハウ沼のクゥダフ族を倒して、だいじなもの「月光の欠片」を手に入れる | ベドーの入口のあたり(K-10)に多い。 | @パシュハウ沼 K-10
g03 gather - | メリファト山地のヤグード族を倒して、だいじなもの「星彩の欠片」を手に入れる | オズトロヤ城の入口のあたり(K-8)に多い。 | @メリファト山地 K-8
g04 trade - | クフィム島(G-6)の???に3つの欠片をトレードしてイベントを見ると完了 | G-6の東の端、2本の岩の柱のあいだ。先にジュノ港のSquintrox Dryeyesに欠片を渡すと紅玉のカギになるが、その日はミッションが進まなくなる。 | @クフィム島 G-6 | T obj.126.???_G-6 = obj:???@クフィム島 G-6 | K 日光の欠片,月光の欠片,星彩の欠片

@ mission.acp.004 https://wiki.ffo.jp/html/17314.html
Q Gatherer of Light (I) | 神の歌の残響が呼ぶ　その1 | no
MN ACP3 4
LK condition:前節「よみがえりし原初の意志」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystalline_Mission_3;??? はバタリア丘陵 F-5、ロランベリー耕地 D-11、ソロムグ原野 J-9（I/J-9/10 の角。FFXIclopedia も同じ）。どれも崖の上
g01 gather - | バタリア丘陵のゴブリン族を倒して、だいじなもの「ゴブリン風サラダ」を手に入れる | 出る確率は低い。パーティなら全員に出る見込みがある。 | @バタリア丘陵
g02 defeat - | バタリア丘陵(F-5)の???を調べてVegnix Greenthumbを出して倒し、だいじなもの「赤石の欠片」を手に入れる | 崖の上。ボスディン氷河から下りるか、F-5の光る場所に花をトレードして上がる。 | @バタリア丘陵 F-5 | T mob.105.Vegnix_Greenthumb = mob:Vegnix Greenthumb@バタリア丘陵 F-5 | K ゴブリン風サラダ
g03 gather - | ロランベリー耕地のゴブリン族を倒して、だいじなもの「ゴブリンジュース」を手に入れる | - | @ロランベリー耕地
g04 defeat - | ロランベリー耕地(D-11)の???を調べてChuglix Berrypawsを出して倒し、だいじなもの「青石の欠片」を手に入れる | 崖の上。クロウラーの巣から上がる。 | @ロランベリー耕地 D-11 | T mob.110.Chuglix_Berrypaws = mob:Chuglix Berrypaws@ロランベリー耕地 D-11 | K ゴブリンジュース
g05 gather - | ソロムグ原野のゴブリン族を倒して、だいじなもの「ゴブリン風燻製」を手に入れる | - | @ソロムグ原野
g06 defeat - | ソロムグ原野(J-9)の???を調べてDribblix Greasemawを出して倒し、だいじなもの「緑石の欠片」を手に入れる | 崖の上。I/J-9とI/J-10の角あたり。ガルレージュ要塞から上がる。 | @ソロムグ原野 J-9 | T mob.120.Dribblix_Greasemaw = mob:Dribblix Greasemaw@ソロムグ原野 J-9 | K ゴブリン風燻製
g07 examine - | クフィム島(G-6)の???を調べてイベントを見ると完了 | ゴブリンの品は欠片をもらっても消えない。先にジュノ港のSquintrox Dryeyesに渡すと緑玉のカギになるが、その日はNMから欠片がもらえなくなる。 | @クフィム島 G-6 | T obj.126.???_G-6 | K 赤石の欠片,青石の欠片,緑石の欠片

@ mission.acp.005 https://wiki.ffo.jp/html/17315.html
Q Gatherer of Light (II) | 神の歌の残響が呼ぶ　その2 | no | T obj.126.???_G-6
MN ACP4 5
RW key_item:黄玉のカギ
LK condition:前節「神の歌の残響が呼ぶ　その1」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystalline_Mission_4;クフィム島 G-6 の ??? からその場で戦う。Seed Mandragora を計30体（FFXIclopedia は最大5体ずつ・30分）。フェイスは呼べない。勝つと Amber Key
g01 examine - | クフィム島(G-6)の???を調べて、その場の戦いを始める | 30分。フェイスは戦いが始まると消える。パーティのみんなが近くにいるときに始める。 | @クフィム島 G-6 | T obj.126.???_G-6
g02 defeat - | 出てくるSeed Mandragoraを30体倒す | 5体ずつ出てきて、倒すと次が出る。HPが残ったまま長く置くと大きな技を使う。 | @クフィム島 G-6
g03 examine - | もう一度???を調べてイベントを見ると完了 | - | @クフィム島 G-6 | T obj.126.???_G-6

@ mission.acp.006 https://wiki.ffo.jp/html/17336.html
Q Those Who Lurk in Shadows (I) | 廃墟で待つ者は　その1 | no
MN ACP5 6
LK condition:前節「神の歌の残響が呼ぶ　その2」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystalline_Mission_5;フェ・インに入るとイベント（FFXIclopedia も同じ）
g01 go - | フェ・インに入ってイベントを見ると完了 | - | @フェ・イン

@ mission.acp.007 https://wiki.ffo.jp/html/17337.html
Q Those Who Lurk in Shadows (II) | 廃墟で待つ者は　その2 | no
MN ACP6 7
RW key_item:シードの紋章
LK condition:前節「廃墟で待つ者は　その1」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystalline_Mission_6;Seed Afterglow 9つを30分以内に。赤・橙・黄・緑は1階、白・水色・金・銀は地下（FFXIclopedia も同じ）。黄は大広間か H/I-9 の小さな部屋。集めると Mark of Seed か Azure Key を選ぶ
g01 examine - | フェ・インの9色のSeed Afterglowを30分のうちに全部調べる | 床の小さな光で、ときどき近くへ動く。赤・橙・黄・緑は上の階の大きな広間、白・水色・金・銀は下の階、青は上の階の北西。時間が切れたら、フェ・インを出て入り直すとやり直せる。 | @フェ・イン
g02 examine - | 9つそろったら「シードの紋章」を選んで受け取る | 青玉のカギを選ぶと、カギを使ってリアルの0時を過ぎるまで紋章が取れない。 | @フェ・イン
g03 examine - | ク・ビアの闘技場のBurning Circleを調べてイベントを見ると完了 | - | @ク・ビアの闘技場 | T obj.ク・ビアの闘技場.Burning_Circle = obj:Burning Circle@ク・ビアの闘技場

@ mission.acp.008 https://wiki.ffo.jp/html/17338.html
Q Those Who Lurk in Shadows (III) | 廃墟で待つ者は　その3 | no
MN ACP7 8
RW key_item:白玉のカギ
LK condition:前節「廃墟で待つ者は　その2」クリア、だいじなもの「シードの紋章」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystalline_Mission_7;Burning Circle を調べてもう一度調べると BF。Seed Yagudo・Seed Quadav・Seed Orc・Seed Goblin の4体（FFXIclopedia も同じ）。勝つと Ivory Key
g01 fight - | ク・ビアの闘技場のBurning CircleからBF「廃墟で待つ者は」に入り、4体の敵に勝つと完了 | 6人まで・30分。入ると強化が消える。フェイスを呼べる。睡眠は効かない。Seed Goblinは急に後ろへ回って技を使う。負けたら紋章をまた取ってくる。 | @ク・ビアの闘技場 | T obj.ク・ビアの闘技場.Burning_Circle | K シードの紋章

@ mission.acp.009 https://wiki.ffo.jp/html/17345.html
Q Remember Me in Your Dreams | 再会　時に引き裂かれし絆 | no
MN ACP8 9
LK condition:前節「廃墟で待つ者は　その3」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystalline_Mission_8;ロ・メーヴから神々の間に入るとイベント。ル・オンの庭から入ったときはロ・メーヴに出て入り直す（FFXIclopedia も同じ）
g01 go - | ロ・メーヴから神々の間に入ってイベントを見ると完了 | ル・オンの庭から入ったときは、ロ・メーヴに出て入り直す。 | @神々の間

@ mission.acp.010 https://wiki.ffo.jp/html/17346.html
Q Born of Her Nightmares | 共鳴　悪夢と失われた頌歌と | no
MN ACP9 10
LK condition:前節「再会　時に引き裂かれし絆」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystalline_Mission_9;デルクフの塔下層に入るとイベント（FFXIclopedia も同じ）
g01 go - | デルクフの塔下層に入ってイベントを見ると完了 | - | @デルクフの塔下層

@ mission.acp.011 https://wiki.ffo.jp/html/17347.html
Q Banishing the Echo | 残響を打ち消す者 | no
MN ACP10 11
RW key_item:輝ける石
LK condition:前節「共鳴　悪夢と失われた頌歌と」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystalline_Mission_10;各塔の入口の Seed Fragment で Lv30 の制限。石の場所は 1階 J-10（FFXIclopedia は J-11）、2階 H-7、3階 I-9、4階 H-10、5階 G-7、6階 F-8、7階 H-9、8階 I-8、9階 G-8、10階 G-9、11階 H-7、12階 H-7（ほかは FFXIclopedia も同じ）。天輪の場の Seed Fragment で Omnis Stone
g01 examine - | デルクフの塔下層の入口のSeed Fragmentを調べてLv30の制限を受ける | 塔の下層・中層・上層を移るたびに制限が切れるので、そのつど入口のSeed Fragmentを調べ直す。制限なしで光を調べても石は取れない。 | @デルクフの塔下層
g02 examine - | 下層の3つのSeed Afterglowを調べて「友愛の石」(1階 J-10/J-11)「誠実の石」(2階 H-7)「聡明の石」(3階 I-9)を手に入れる | 光のまわりは見て気づく敵が多い。インビジ・スニークを用意する。制限のあいだは倒されても経験値は減らず、集めた石も残る。 | @デルクフの塔下層
g03 examine - | 中層の6つのSeed Afterglowを調べて「清浄の石」(4階 H-10)「幸福の石」(5階 G-7)「富貴の石」(6階 F-8)「熱情の石」(7階 H-9)「恋愛の石」(8階 I-8)「慈愛の石」(9階 G-8)を手に入れる | 中層の入口のSeed Fragmentで制限をかけ直してから。 | @デルクフの塔中層
g04 examine - | 上層の3つのSeed Afterglowを調べて「忍耐の石」(10階 G-9)「希望の石」(11階 H-7)「繁栄の石」(12階 H-7)を手に入れる | 上層の入口のSeed Fragmentで制限をかけ直してから。 | @デルクフの塔上層
g05 examine - | 12の石を持って天輪の場のSeed Fragmentを調べ、だいじなもの「輝ける石」を手に入れると完了 | - | @天輪の場 | K 友愛の石,誠実の石,聡明の石,清浄の石,幸福の石,富貴の石,熱情の石,恋愛の石,慈愛の石,忍耐の石,希望の石,繁栄の石

@ mission.acp.012 https://wiki.ffo.jp/html/17348.html
Q Ode of Life Bestowing | 天よ聴け　魂の返歌 | no | T obj.天輪の場.Qe_Iov_Gate = obj:Qe'Iov Gate@天輪の場
MN ACP11 12
RW key_item:黒玉のカギ
RW key_item:虹玉のカギ
RW title:神の頌歌に返せる者
LK condition:だいじなもの「輝ける石」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystalline_Mission_11;Qe'Iov Gate を調べてイベント、もう一度調べて BF。相手は Seed Crystal（FFXIclopedia も同じ。6人・30分・レベル制限なし）。称号 Silencer of the Echo、Ebon Key・Prismatic Key
g01 examine - | 天輪の場のQe'Iov Gateを調べてイベントを見る | - | @天輪の場 | T obj.天輪の場.Qe_Iov_Gate
g02 fight - | もう一度Qe'Iov GateからBFに入り、Seed Crystalに勝つ | 6人まで・30分・レベル制限なし。経験値は減らない。輝ける石は入ると消える。広い範囲の技と、ジョブアビリティの再使用時間を戻す技がある。 | @天輪の場 | T obj.天輪の場.Qe_Iov_Gate | K 輝ける石
g03 go - | イベントを見て虹玉のカギを受け取ると完了 | このあと一覧の名前が「石の見る夢＜完＞」になる。 | @天輪の場

@ mission.acp.013 https://wiki.ffo.jp/html/17370.html
Q A Crystalline Prophecy (Fin.) | 石の見る夢＜完＞ | no
MN ACP12 13
LK condition:「天よ聴け　魂の返歌」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystalline_Mission_12;ジュノ下層の天晶堂の宝箱（FFXIclopedia は Treasure Coffer）を調べると、Mirke Wardecors・Nuevo Coselete・Royal Redingote のどれか。BG Wiki はカギの宝箱をジュノ下層 J-8 と書いている
g01 examine - | ジュノ下層の天晶堂の中のTreasure Cofferを調べ、ロイヤルルダンゴト・マルクワルドコル・ヌエボコセレーテから1つ選んで受け取ると完了 | どれか1つしか持てない。選び直すときは持っているものを捨てて、最後の戦いをもう一度勝つ。 | @ジュノ下層 J-8
