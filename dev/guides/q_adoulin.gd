
@ quest.adoulin.001 https://wiki.ffo.jp/html/28416.html
Q I'm on a Boat | 河の流れを読む極意 | no | T npc.262.Choubollet = npc:Choubollet@エヌティエル水林 J-6
RW key_item:携帯ボート
RW key_item:フォードスキル
RW other:同盟戦績500ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/I%27m_on_a_Boat;Choubollet J-6。1つ目のCastoff Point は I-7 の南、2つ目は J-9 の西
g01 talk - | エヌティエル水林のF.ステーション(J-6)のChoubolletに話して受ける | - | @エヌティエル水林 J-6 | T npc.262.Choubollet
g02 trade - | Choubolletにダルメルのなめし革3つ・トウィザリムの鱗粉・アンブリルオイルをトレードし、だいじなもの「携帯ボート」をもらう | まだ完了ではない。 | @エヌティエル水林 J-6 | T npc.262.Choubollet | N ダルメルのなめし革*3,トウィザリムの鱗粉*1,アンブリルオイル*1
g03 examine - | (I-7)のCastoff Pointを調べて「はい」を選び、下流の(J-9)へ流される | 着いた所にアクティブの敵がいるので、先にスニークをかけておくとよい。 | @エヌティエル水林 I-7 | T obj.262.Castoff_Point = obj:Castoff Point@エヌティエル水林 I-7 J-9 | K 携帯ボート
g04 examine - | 着いた所から右の壁ぞいに進み、(J-9)のCastoff Pointを調べて「はい」を選び、対岸へ渡る | 「ボートを操るコツを掴めた気がする……！」と出る。ここにもアクティブの敵がいる。 | @エヌティエル水林 J-9 | T obj.262.Castoff_Point | K 携帯ボート
g05 talk - | 北のF.ステーションのChoubolletに報告して完了 | - | @エヌティエル水林 J-6 | T npc.262.Choubollet

@ quest.adoulin.002 https://wiki.ffo.jp/html/28536.html
Q Unsullied Lands | 清浄な砂浜 | no | T npc.262.Inmot-Pinmot = npc:Inmot-Pinmot@エヌティエル水林 J-10
RW other:経験値（リミットポイント）2000
RW other:同盟戦績200ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Unsullied_Lands;Inmot-Pinmot J-10（F.ビバック#2）。浜は西の木のレイヴを越えず、海岸ぞいに南へ。BG Wiki は受ける条件にフォードスキルを書く
g01 talk - | エヌティエル水林のF.ビバック#2(J-10)のInmot-Pinmotに話して受ける | - | @エヌティエル水林 J-10 | T npc.262.Inmot-Pinmot
g02 examine - | (J-11)の浜のErgon Locus「清浄の浜」を調べ、だいじなもの「清浄なる砂」をもらう | 海岸ぞいに南へ進む。 | @エヌティエル水林 J-11 | T obj.262.Ergon_Locus = obj:Ergon Locus@エヌティエル水林 J-11
g03 talk - | F.ビバック#2のInmot-Pinmotに報告して完了 | - | @エヌティエル水林 J-10 | T npc.262.Inmot-Pinmot | K 清浄なる砂

@ quest.adoulin.003 https://wiki.ffo.jp/html/28366.html
Q Orobon Appetit | 珍味求めて幾年月 | no | T npc.262.Nestroh = npc:Nestroh@エヌティエル水林 H-9
RW key_item:パレジス・リジリアンス
RW other:同盟戦績500ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Orobon_Appetit;Nestroh H-9（F.ビバック#3の近く）。肉は尾・腹・頬・背・肝臓のどれかで、肝臓だけ受け取る
g01 talk - | エヌティエル水林のF.ビバック#3の近く(H-9)のNestrohに話して受ける | 釣竿が要る。 | @エヌティエル水林 H-9 | T npc.262.Nestroh
g02 defeat - | 川でDelectable Orobonを釣って倒し、デレックタブルの肉を手に入れる | 依頼者から右手のCastoff Pointの近くが一番近い釣り場。 | @エヌティエル水林 | T mob.262.Delectable_Orobon = mob:Delectable Orobon@エヌティエル水林
g03 trade - | Nestrohにデレックタブルの肉をトレードする | 肝臓のときだけ完了。ほかの部位なら釣りからやり直す。部位はトレードするまでわからない。 | @エヌティエル水林 H-9 | T npc.262.Nestroh | N デレックタブルの肉*1

@ quest.adoulin.004 https://wiki.ffo.jp/html/28537.html
Q Poisoning the Well | 紫に染まる大河 | no | T npc.262.Fritha = npc:Fritha@エヌティエル水林 J-7
RW other:経験値（リミットポイント）2000
RW other:同盟戦績200ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Poisoning_the_Well;Fritha J-7（F.ステーション）。River Mouth は J-9
g01 talk - | エヌティエル水林のF.ステーション(J-7)のFrithaに話して受ける | - | @エヌティエル水林 J-7 | T npc.262.Fritha
g02 examine - | 南の河口(J-9)のRiver Mouthを調べ、NMのCunning Craklawを出す | フェイスは先に呼んでおく。 | @エヌティエル水林 J-9 | T obj.262.River_Mouth = obj:River Mouth@エヌティエル水林 J-9
g03 defeat - | Cunning Craklawを倒す | 睡眠が効く。 | @エヌティエル水林 J-9 | T mob.262.Cunning_Craklaw = mob:Cunning Craklaw@エヌティエル水林 J-9
g04 examine - | もう一度River Mouthを調べ、だいじなもの「ゾルデフ川の毒水」をもらう | - | @エヌティエル水林 J-9 | T obj.262.River_Mouth
g05 talk - | F.ステーションのFrithaに報告して完了 | - | @エヌティエル水林 J-7 | T npc.262.Fritha | K ゾルデフ川の毒水

@ quest.adoulin.005 https://wiki.ffo.jp/html/29731.html
Q Breaking the Ice | 氷壁破壊の極意 | no | T npc.267.Traiffeaux = npc:Traiffeaux@カミール山麓 K-10
RW key_item:フラグメントスキル
RW key_item:ほかほか耳当て
RW other:同盟戦績500ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Breaking_the_Ice;Traiffeaux K-10（F.ステーション）
g01 talk - | カミール山麓のF.ステーション(K-10)のTraiffeauxに話して受ける | - | @カミール山麓 K-10 | T npc.267.Traiffeaux
g02 trade - | Traiffeauxに野兎の毛皮3枚とラズの牙をトレードして完了 | どちらも競売で買える。カミール山麓の白兎は野兎の毛皮を落とさない。 | @カミール山麓 K-10 | T npc.267.Traiffeaux | N 野兎の毛皮*3,ラズの牙*1

@ quest.adoulin.006 https://wiki.ffo.jp/html/31397.html
Q No Love Lost | 運命と愛の流刑地 | no | T npc.267.Peppe-Aleppe = npc:Peppe-Aleppe@カミール山麓 K-10
RW key_item:ペッペアレッペ油
RW key_item:アルゴル・リジリアンス
RW other:同盟戦績500ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peppe-Aleppe;Peppe-Aleppe K-10（F.ステーション）
g01 talk - | カミール山麓のF.ステーション(K-10)のPeppe-Aleppeに話し、イベントを見て受ける | - | @カミール山麓 K-10 | T npc.267.Peppe-Aleppe
g02 trade - | Peppe-Aleppeにルスゾルの皮をトレードし、イベントを見て完了 | 競売で買える。 | @カミール山麓 K-10 | T npc.267.Peppe-Aleppe | N ルスゾルの皮*1

@ quest.adoulin.007 https://wiki.ffo.jp/html/28067.html
Q Twitherym Dust | とあるトウィザリムの生態 | no | T npc.261.Gurren-Murren = npc:Gurren-Murren@ケイザック古戦場 K-7
RW other:経験値1000
RW other:同盟戦績100ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Twitherym_Dust;Gurren-Murren K-7（F.ステーション）。Twinkling Tree は I-10 の北
g01 talk - | ケイザック古戦場のF.ステーション(K-7)のGurren-Murrenに話して受ける | - | @ケイザック古戦場 K-7 | T npc.261.Gurren-Murren
g02 examine - | 南の(I-10)のTwinkling Treeを調べ、だいじなもの「樹液鱗粉」をもらう | 夜はそばにアンブリル族が出る。 | @ケイザック古戦場 I-10 | T obj.261.Twinkling_Tree = obj:Twinkling Tree@ケイザック古戦場 I-10
g03 talk - | F.ステーションのGurren-Murrenに報告して完了 | - | @ケイザック古戦場 K-7 | T npc.261.Gurren-Murren | K 樹液鱗粉

@ quest.adoulin.008 https://wiki.ffo.jp/html/28068.html
Q Grind to Sawdust | 大木粉砕の心得 | no | T npc.261.Elmric = npc:Elmric@ケイザック古戦場 K-7
RW key_item:ログスキル
RW other:同盟戦績500ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Grind_to_Sawdust;Elmric K-7。レイヴは評価が出れば最後までいなくてよい
g01 talk - | ケイザック古戦場のF.ステーション(K-7)のElmricに話して受ける | 先にレイヴに参加していれば、話すだけで完了する。 | @ケイザック古戦場 K-7 | T npc.261.Elmric
g02 go - | 巨木が道をふさいでいるコロナイズ・レイヴに1回参加する | すぐに離れてもよい。 | @ケイザック古戦場
g03 talk - | F.ステーションのElmricに報告して完了 | - | @ケイザック古戦場 K-7 | T npc.261.Elmric

@ quest.adoulin.009 https://wiki.ffo.jp/html/28225.html
Q To Catch a Predator | 森の死神 | no | T npc.261.Lucretia = npc:Lucretia@ケイザック古戦場 H-9
RW other:経験値（リミットポイント）2000
RW other:同盟戦績200ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/To_Catch_a_Predator;Lucretia H-9（F.ビバック#1）。Fernfelling Chapuli は H-9 の南、Claw Mark は H-8
g01 talk - | ケイザック古戦場のF.ビバック#1(H-9)のLucretiaに話して受ける | - | @ケイザック古戦場 H-9 | T npc.261.Lucretia
g02 defeat - | まわりのFernfelling Chapuliを倒し、だいじなもの「生餌チャプリ」をもらう | - | @ケイザック古戦場 H-9 | T mob.261.Fernfelling_Chapuli = mob:Fernfelling Chapuli@ケイザック古戦場 H-9
g03 examine - | Lucretiaの手前の広場の真ん中(H-8)のClaw Markを調べ、NMのTruculent Mantisを出す | - | @ケイザック古戦場 H-8 | T obj.261.Claw_Mark = obj:Claw Mark@ケイザック古戦場 H-8 | K 生餌チャプリ
g04 defeat - | Truculent Mantisを倒し、だいじなもの「森の死神の鎌」をもらう | まわりのマンティスより少し弱い。 | @ケイザック古戦場 H-8 | T mob.261.Truculent_Mantis = mob:Truculent Mantis@ケイザック古戦場 H-8
g05 talk - | F.ビバック#1のLucretiaに報告して完了 | - | @ケイザック古戦場 H-9 | T npc.261.Lucretia | K 森の死神の鎌

@ quest.adoulin.010 https://wiki.ffo.jp/html/28492.html
Q Empty Nest | 生まれ出ずる悩み | no | T npc.261.Bataron = npc:Bataron@ケイザック古戦場 H-7
RW other:経験値（リミットポイント）2000
RW other:同盟戦績200ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Empty_Nest;Bataron H-7（F.ビバック#2）。経験値が入らない相手でも数える
g01 talk - | ケイザック古戦場のF.ビバック#2(H-7)のBataronに話して受ける | - | @ケイザック古戦場 H-7 | T npc.261.Bataron
g02 defeat - | まわりのBelaboring Waspを8匹倒す | 青い蜂。範囲攻撃でまとめて倒すと1匹分しか数えない。報告の前にエリアを出ると数え直し。 | @ケイザック古戦場 H-7 | T mob.261.Belaboring_Wasp = mob:Belaboring Wasp@ケイザック古戦場 H-7
g03 talk - | F.ビバック#2のBataronに報告して完了 | - | @ケイザック古戦場 H-7 | T npc.261.Bataron

@ quest.adoulin.011 https://wiki.ffo.jp/html/29076.html
Q Hide and Go Peak | ツタ登りの極意 | no | T npc.266.Toppled_Tree = npc:Toppled Tree@マリアミ渓谷 L-7 M-7
RW key_item:クライムスキル
RW key_item:ヴェルクグローブ
RW other:同盟戦績500ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Toppled_Tree;Toppled Tree M-7（用語辞典は L-7）。Velkk Cache は K-10 の東、Scalable Area は K-7・K-8 の境。途中に大岩のレイヴが3つ（デモリシスキルが要る）
g01 talk - | マリアミ渓谷のF.ステーションのToppled Treeに話して受ける | - | @マリアミ渓谷 L-7 M-7 | T npc.266.Toppled_Tree
g02 examine - | 南西のヴェルク族の集落(K-10)のVelkk Cacheを調べ、だいじなもの「ヴェルク族の大きな皮」をもらう | 下の段。途中の大岩のレイヴを越えるにはデモリシスキルが要る。 | @マリアミ渓谷 K-10 | T obj.266.Velkk_Cache = obj:Velkk Cache@マリアミ渓谷 K-10
g03 talk - | F.ステーションのToppled Treeに話す | 「南西にある、ここからいちばん近いツタのところへ行く」と言われる。 | @マリアミ渓谷 L-7 M-7 | T npc.266.Toppled_Tree | K ヴェルク族の大きな皮
g04 examine - | F.ステーションの南西のScalable Areaを調べ、イベントを見て完了 | - | @マリアミ渓谷 K-7 K-8 | T obj.266.Scalable_Area = obj:Scalable Area@マリアミ渓谷 K-7 K-8

@ quest.adoulin.012 https://wiki.ffo.jp/html/29398.html
Q Water, Water, Everywhere | 渓谷を下る水 | no | T npc.266.Jhen_Durheka = npc:Jhen Durheka@マリアミ渓谷 L-10
RW other:経験値（リミットポイント）2000
RW other:同盟戦績1000ベヤルド
LK condition:だいじなもの「クライムスキル」を持っている（「ツタ登りの極意」で覚える）
LK fame:アドゥリンの名声ランク4以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Water,_Water,_Everywhere;名声4以上。??? は K-5（Ergon Locus のそば）、H-10 の川の東、ドーの門 H-9 の川の西。K-5 とドーの門はクライムスキルが要る
g01 talk - | マリアミ渓谷のF.ビバック#1(L-10)のJhen Durhekaに話して受け、だいじなもの「水質調査用試験管」をもらう | - | @マリアミ渓谷 L-10 | T npc.266.Jhen_Durheka
g02 examine - | マリアミ渓谷の2か所の???を調べて水を汲む | (H-10)の川の東は、F.ビバック#2から(J-10)の洞窟を降りる。(K-5)の川の東はErgon Locus「薫風の花」のそばで、F.ステーションから西へ行き、(K-8)(K-6)のツタを上り下りして北へ。 | @マリアミ渓谷 H-10 K-5 | T obj.266.qqq_water = obj:???@マリアミ渓谷 H-10 K-5 | K 水質調査用試験管
g03 examine - | ドーの門(H-9)の川の西の???を調べて水を汲む | マリアミ渓谷のF.ステーションから入るのが近い。まわりに強いヴェルクがいる。3か所はどの順でもよい。 | @ドーの門 H-9 #1 | T obj.272.qqq_water = obj:???@ドーの門 H-9 #1 | K 水質調査用試験管
g04 talk - | F.ビバック#1のJhen Durhekaに報告して完了 | - | @マリアミ渓谷 L-10 | T npc.266.Jhen_Durheka

@ quest.adoulin.013 https://wiki.ffo.jp/html/29397.html
Q It Never Goes Out of Style | 私怨 | yes | T npc.266.Veldeth = npc:Veldeth@マリアミ渓谷 L-7 M-7
RW other:経験値（リミットポイント）500
RW other:同盟戦績300ベヤルド
LK fame:アドゥリンの名声が「あなたのお名前を、よく耳にしております。」であること
XS BG Wiki;https://www.bg-wiki.com/ffxi/It_Never_Goes_Out_of_Style;Veldeth L-7（用語辞典は M-7）。名声5
g01 talk - | マリアミ渓谷のF.ステーションのVeldethに話して受ける | 「ヴェルク特有の不穏な気を感じる」はインカージョンの話なので、お祓いは受けない。 | @マリアミ渓谷 L-7 M-7 | T npc.266.Veldeth
g02 trade - | Veldethにヴェルクの首飾りかヴェルクマスクを、どちらか2個トレードして完了 | 1個ずつでは受け取らない。一度終えれば、あとはトレードだけで何回でもできる。 | @マリアミ渓谷 L-7 M-7 | T npc.266.Veldeth

@ quest.adoulin.014 https://wiki.ffo.jp/html/33951.html
Q The Weatherspoon War | 蝶なる聖戦 | no | T npc.257.Zaffeld = npc:Zaffeld@東アドゥリン J-8 K-8
RW item:バーカロルピアス
RW title:アドゥリンを守りし者
RW other:経験値1000
RW other:同盟戦績1000ベヤルド
LK quest:クエスト「解離」を終えている
LK fame:アドゥリンの名声ランク3以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Zaffeld;Zaffeld J-8（用語辞典は K-8）
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Weatherspoon_War;玉座はF.ビバック#2から南東へ、J-9・J-10 の洞窟を抜けて I-10。ツタを上る
g01 talk - | 東アドゥリンのZaffeldに話す | Waypoint「アドゥリン城門前」が近い。まだオファーリストには出ない。 | @東アドゥリン J-8 K-8 | T npc.257.Zaffeld
g02 go - | ドーの門かウォーの門から歩いてマリアミ渓谷に入り、イベントを見る | ここでオファーリストに出る。 | @マリアミ渓谷
g03 examine - | (I-10)の北西のSeat of Gramk-Droogを調べてイベントを見る | F.ビバック#2から南へ行き、(J-10)の北西の洞窟を抜ける。 | @マリアミ渓谷 I-10 | T obj.266.Seat_of_Gramk-Droog = obj:Seat of Gramk-Droog@マリアミ渓谷 I-10
g04 defeat - | もう一度調べてNMのMligni-Vorgutを出して倒す | 魔法の範囲の弱体が多い。ヒーラーを多めに。 | @マリアミ渓谷 I-10 | T mob.266.Mligni-Vorgut = mob:Mligni-Vorgut@マリアミ渓谷 I-10
g05 examine - | もう一度Seat of Gramk-Droogを調べてイベントを見る | - | @マリアミ渓谷 I-10 | T obj.266.Seat_of_Gramk-Droog
g06 examine - | 西アドゥリン(I-9)のDoor:Hospitalを調べてイベントを見る | - | @西アドゥリン I-9 | T obj.256.Door_Hospital = obj:Door:Hospital@西アドゥリン I-9
g07 talk - | 東アドゥリンのZaffeldに話し、イベントを見て完了 | - | @東アドゥリン J-8 K-8 | T npc.257.Zaffeld

@ quest.adoulin.015 https://wiki.ffo.jp/html/29732.html
Q Did You Feel That? | 這い寄るトゲトゲ | no | T npc.266.Udip_Ferawoh = npc:Udip Ferawoh@マリアミ渓谷 M-7
RW key_item:レストレイン・リジリアンス
RW other:同盟戦績500ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Udip_Ferawoh;Udip Ferawoh M-7（F.ステーション）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Did_You_Feel_That%3F;Spinescent Protuberance は H-10（Riverscum のいる洞窟の先）や L-12（F.ビバック#1から）にもいる
g01 talk - | マリアミ渓谷のF.ステーション(M-7)のUdip Ferawohに話して受ける | MUM.ワークスの生態研究（マリアミ渓谷）を受けていると、完了しないことがある。 | @マリアミ渓谷 M-7 | T npc.266.Udip_Ferawoh
g02 go - | マリアミ渓谷のSpinescent Protuberanceからアムネジアを合わせて5回受ける | (K-9)のあたり。F.ビバック#1から南へ下り、時計回りに進む。数は出ないが、終わると「アムネジアにかかる試練を達成した！」と出る。ドーの門のものは数えない。 | @マリアミ渓谷 K-9
g03 talk - | F.ステーションのUdip Ferawohに報告し、イベントを見て完了 | - | @マリアミ渓谷 M-7 | T npc.266.Udip_Ferawoh

@ quest.adoulin.016 https://wiki.ffo.jp/html/28483.html
Q A Stone's Throw Away | 大岩破壊の極意 | no | T npc.265.Apolliane = npc:Apolliane@モリマー台地 K-10
RW key_item:デモリシスキル
RW other:同盟戦績500ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Stone%27s_Throw_Away;Apolliane K-10。受ける前に掘った結晶質石灰岩でもよい
g01 talk - | モリマー台地のF.ステーション(K-10)のApollianeに話して受ける | - | @モリマー台地 K-10 | T npc.265.Apolliane
g02 gather - | Mining Pointを掘って結晶質石灰岩を手に入れる | 自分で掘ったものだけ受け取る（競売やレイヴのものはだめ）。つるはしは多めに。 | @モリマー台地 H-8 F-10 H-9 E-9 I-10 F-6 | T obj.265.Mining_Point = obj:Mining Point@モリマー台地 H-8 F-10 H-9 E-9 I-10 F-6 | N つるはし*1
g03 trade - | Apollianeに結晶質石灰岩をトレードして完了 | - | @モリマー台地 K-10 | T npc.265.Apolliane | N 結晶質石灰岩*1

@ quest.adoulin.017 https://wiki.ffo.jp/html/28538.html
Q No Rime Like the Present | 氷の衣を纏った木々 | no | T npc.265.Hegnor = npc:Hegnor@モリマー台地 K-10
RW other:経験値（リミットポイント）3000
RW other:同盟戦績300ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/No_Rime_Like_the_Present;Hegnor K-10。??? は K-7・K-8 の木（F.ビバック#1の近く）
g01 talk - | モリマー台地のF.ステーション(K-10)のHegnorに話して受ける | - | @モリマー台地 K-10 | T npc.265.Hegnor
g02 examine - | 天候が雪のときに、(K-8)の木の???を調べ、だいじなもの「樹氷のかけら」をもらう | 天気は東アドゥリン(F-9)のInthiusに聞ける。 | @モリマー台地 K-7 K-8 | T obj.265.qqq_rime = obj:???@モリマー台地 K-7 K-8 | W 雪
g03 talk - | F.ステーションのHegnorに報告して完了 | - | @モリマー台地 K-10 | T npc.265.Hegnor | K 樹氷のかけら

@ quest.adoulin.018 https://wiki.ffo.jp/html/29733.html
Q Talk About Wrinkly Skin | 混浴温泉の心得 | no | T npc.265.Orsa-Porsa = npc:Orsa-Porsa@モリマー台地 K-10
RW key_item:カロル・リジリアンス
RW other:同盟戦績500ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Talk_About_Wrinkly_Skin;Orsa-Porsa K-10。Hot Spring は H-7（F.ビバック#2が近い）
g01 talk - | モリマー台地のF.ステーション(K-10)のOrsa-Porsaに話して受ける | - | @モリマー台地 K-10 | T npc.265.Orsa-Porsa
g02 trade - | Orsa-Porsaにウルガランミルク・アプカルの卵・フィクリカをトレードし、だいじなもの「温泉グルメセット」をもらう | どれも競売で買える。 | @モリマー台地 K-10 | T npc.265.Orsa-Porsa | N ウルガランミルク*1,アプカルの卵*1,フィクリカ*1
g03 examine - | 耳・指・背以外の装備を外して、(H-7)のHot Springを調べ、イベントを見る | 首・腰も外す。F.ビバック#2から右手の壁ぞいに進む。 | @モリマー台地 H-7 | T obj.265.Hot_Spring = obj:Hot Spring@モリマー台地 H-7 G-8 H-8 | K 温泉グルメセット
g04 talk - | F.ステーションのOrsa-Porsaに報告して完了 | - | @モリマー台地 K-10 | T npc.265.Orsa-Porsa

@ quest.adoulin.019 https://wiki.ffo.jp/html/28539.html
Q A Geothermal Expedition | 湯けむり泉質調査旅 | no | T npc.265.Fallion = npc:Fallion@モリマー台地 I-10
RW other:経験値（リミットポイント）3000
RW other:同盟戦績300ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Geothermal_Expedition;Fallion I-10（F.ビバック#3）。天候は関係なく、時刻だけでレポートが変わる
g01 talk - | モリマー台地のF.ビバック#3(I-10)のFallionに話して受ける | - | @モリマー台地 I-10 | T npc.265.Fallion
g02 examine - | (G-8)(H-7)(H-8)のHot Springを時刻を変えて調べ、だいじなもの「温泉レポート1」〜「温泉レポート5」を集める | 時刻でもらえるレポートが変わる。レポート3は(H-7)、4は(H-8)、5は(G-8)だけ。コロナイズ・レイヴの間は(H-7)と(G-8)(H-8)を行き来できない。 | @モリマー台地 G-8 H-7 H-8 | T obj.265.Hot_Spring
g03 talk - | F.ビバック#3のFallionに報告して完了 | - | @モリマー台地 I-10 | T npc.265.Fallion | K 温泉レポート1,温泉レポート2,温泉レポート3,温泉レポート4,温泉レポート5

@ quest.adoulin.020 https://wiki.ffo.jp/html/28522.html
Q Hop to It | チャプリ駆除 | no | T npc.260.Chya_Mindorah = npc:Chya Mindorah@ヤッセの狩り場 I-8
RW other:経験値（リミットポイント）2000
RW other:同盟戦績200ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Hop_to_It;Chya Mindorah I-8（F.ビバック#1）。??? は I-6・I-7 の境
g01 talk - | ヤッセの狩り場のF.ビバック#1(I-8)のChya Mindorahに話して受ける | - | @ヤッセの狩り場 I-8 | T npc.260.Chya_Mindorah
g02 defeat - | 北の(I-6)の???のまわりのCalfcleaving Chapuliを、「あたりに強烈な殺気を感じた！」と出るまで倒す | 10匹ほどで出ることが多い。 | @ヤッセの狩り場 I-6 I-7 | T mob.260.Calfcleaving_Chapuli = mob:Calfcleaving Chapuli@ヤッセの狩り場 I-6 I-7
g03 examine - | ???を調べてNMのBothersome Chapuliを出す | - | @ヤッセの狩り場 I-6 I-7 | T obj.260.qqq_chapuli = obj:???@ヤッセの狩り場 I-6 I-7
g04 defeat - | Bothersome Chapuliを倒し、だいじなもの「チャプリの剣角」をもらう | まわりのチャプリより少し強いくらい。 | @ヤッセの狩り場 I-6 I-7 | T mob.260.Bothersome_Chapuli = mob:Bothersome Chapuli@ヤッセの狩り場 I-6 I-7
g05 talk - | F.ビバック#1のChya Mindorahに報告して完了 | - | @ヤッセの狩り場 I-8 | T npc.260.Chya_Mindorah | K チャプリの剣角

@ quest.adoulin.021 https://wiki.ffo.jp/html/28524.html
Q Boiling Over | マグマ調査 | no | T npc.260.Leautiere = npc:Leautiere@ヤッセの狩り場 G-7
RW other:経験値（リミットポイント）2000
RW other:同盟戦績200ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Boiling_Over;Leautiere G-7（F.ビバック#2）。Magma Vein はモーの門 K-5。モリマー台地のF.ステーションから入るのが早い
g01 talk - | ヤッセの狩り場のF.ビバック#2(G-7)のLeautiereに話して受ける | - | @ヤッセの狩り場 G-7 | T npc.260.Leautiere
g02 examine - | モーの門(K-5)のMagma Veinを調べ、だいじなもの「マグマ調査レポート」をもらう | コロナイズ・レイヴを越え、強い敵の多い所を通るのでインスニを。 | @モーの門 K-5 #1 | T obj.269.Magma_Vein = obj:Magma Vein@モーの門 K-5 #1
g03 talk - | F.ビバック#2のLeautiereに報告して完了 | - | @ヤッセの狩り場 G-7 | T npc.260.Leautiere | K マグマ調査レポート

@ quest.adoulin.022 https://wiki.ffo.jp/html/28228.html
Q The Whole Place Is Abuzz | 息をひそめて蜂を待つ | no | T npc.260.Rumin-Flumin = npc:Rumin-Flumin@ヤッセの狩り場 H-9
RW key_item:トクシン・リジリアンス
RW other:同盟戦績500ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Whole_Place_Is_Abuzz;Rumin-Flumin H-9（F.ビバック#3）。Pollinating Swarm は G-10。Ndah Tolohjin は東アドゥリン G-9
g01 talk - | ヤッセの狩り場のF.ビバック#3(H-9)のRumin-Fluminに話して受け、だいじなもの「はちのすホイホイ」をもらう | - | @ヤッセの狩り場 H-9 | T npc.260.Rumin-Flumin
g02 examine - | 南西の行き止まり(G-10)のPollinating Swarmを調べて、はちのすホイホイを置く | まわりの蜂は絡まない。 | @ヤッセの狩り場 G-10 | T obj.260.Pollinating_Swarm = obj:Pollinating Swarm@ヤッセの狩り場 G-10 | K はちのすホイホイ
g03 go - | その場でヒーリングして、蜂が10匹集まるのを待つ | 10秒ほどで集まる。 | @ヤッセの狩り場 G-10
g04 examine - | もう一度Pollinating Swarmを調べ、だいじなもの「はちのすホイホイMAX」をもらう | Rumin-Fluminへの報告は飛ばしてもよい。 | @ヤッセの狩り場 G-10 | T obj.260.Pollinating_Swarm
g05 talk - | 東アドゥリンのスカウト・ワークスの北東(G-9)のNdah Tolohjinに話し、イベントを見て完了 | - | @東アドゥリン G-9 | T npc.257.Ndah_Tolohjin = npc:Ndah Tolohjin@東アドゥリン G-9 | K はちのすホイホイMAX

@ quest.adoulin.023 https://wiki.ffo.jp/html/28525.html
Q Don't Clam Up on Me Now | 過酷な潮干狩り | no | T npc.260.Oblor = npc:Oblor@ヤッセの狩り場 K-9
RW other:経験値1000
RW other:同盟戦績100ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Don%27t_Clam_Up_on_Me_Now;Oblor K-9（F.ステーション）。浜は東側の K-7・K-8
g01 talk - | ヤッセの狩り場のF.ステーション(K-9)のOblorに話して受ける | - | @ヤッセの狩り場 K-9 | T npc.260.Oblor
g02 examine - | 東の浜のShellfishを調べ、浜辺の貝を5つ集める | 調べると場所が変わる。持ち物にはならないので、エリアを出ると数え直し。(K-7)ではAlluring Orobon、(K-8)ではStartled Uragniteが出ることがあるが、倒さなくてよい。 | @ヤッセの狩り場 K-7 K-8 | T obj.260.Shellfish = obj:Shellfish@ヤッセの狩り場 K-7 K-8
g03 talk - | F.ステーションのOblorに報告して完了 | - | @ヤッセの狩り場 K-9 | T npc.260.Oblor

@ quest.adoulin.024 https://wiki.ffo.jp/html/29400.html
Q Flower Power | ヨルシアに群れる花 | yes | T npc.263.Mano-Amano = npc:Mano-Amano@ヨルシア森林 J-8
RW other:経験値（リミットポイント）500
RW other:同盟戦績300ベヤルド
LK quest:クエスト「穢れた土地」を終えて、エリアを出入りしている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mano-Amano;Mano-Amano J-8（F.ステーション）
g01 talk - | ヨルシア森林のF.ステーション(J-8)のMano-Amanoに話して受ける | - | @ヨルシア森林 J-8 | T npc.263.Mano-Amano
g02 defeat - | ヨルシア森林のNumbing Blossomを3匹倒す | F.ステーションのすぐ北に3匹かたまっている。「穢れた土地」の群生地(I-8)でもよい。ほかのエリアのもの、範囲攻撃でまとめて倒したものは数えない。 | @ヨルシア森林 | T mob.263.Numbing_Blossom = mob:Numbing Blossom@ヨルシア森林
g03 talk - | F.ステーションのMano-Amanoに報告して完了 | エリアを出入りし、コンクエストの集計をまたぐと、また受けられる。 | @ヨルシア森林 J-8 | T npc.263.Mano-Amano

@ quest.adoulin.025 https://wiki.ffo.jp/html/29399.html
Q Dirt Cheap | 穢れた土地 | no | T npc.263.Mano-Amano
RW other:経験値（リミットポイント）1000
RW other:同盟戦績500ベヤルド
XS BG Wiki;https://www.bg-wiki.com/ffxi/Dirt_Cheap;??? は I-8（シルダス洞窟の入口のすぐ西）。F.ビバック#2から北へ行くと早い
g01 talk - | ヨルシア森林のF.ステーション(J-8)のMano-Amanoに話して受ける | 開拓者バッジがなくても受けられる。 | @ヨルシア森林 J-8 | T npc.263.Mano-Amano
g02 examine - | (I-8)の広場の真ん中の???を調べ、だいじなもの「ナム・ブロッサム群生地の土」をもらう | F.ビバック#1が近いがレイヴを越える。F.ビバック#3から回るとレイヴを避けられる。広場の手前の茂みが閉じていたら開くまで待つ。 | @ヨルシア森林 I-8 | T obj.263.qqq_soil = obj:???@ヨルシア森林 I-8
g03 talk - | F.ステーションのMano-Amanoに報告して完了 | - | @ヨルシア森林 J-8 | T npc.263.Mano-Amano | K ナム・ブロッサム群生地の土

@ quest.adoulin.026 https://wiki.ffo.jp/html/31990.html
Q Adoulin Showdown | アドゥリンクイズ | no | T npc.セレニア図書館.Oshasha = npc:Oshasha@セレニア図書館
RW other:アドゥリン英雄伝の書写本を借りられるようになる
LK quest:クエスト「渇欲のストロボ」を終えている
g01 talk - | セレニア図書館のOshashaに話し、クイズを受ける | 全40問の中から14問出る。 | @セレニア図書館 | T npc.セレニア図書館.Oshasha
g02 go - | 14問のうち12問以上正解して完了 | 十二名家の屋敷の場所なども出る。かかった時間が「速答スコア」として出る。 | @セレニア図書館

@ quest.adoulin.027 https://wiki.ffo.jp/html/29515.html
Q Geomancy Attire | ジオ装束 | no | T npc.256.Wescolina = npc:Wescolina@西アドゥリン H-7
RW item:ジオガレーロ
RW item:ジオチュニック
RW item:ジオサンダル
LK quest:風水士AFクエスト「鈴は鳴りわたる」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Wescolina;Wescolina は西アドゥリン H-7
g01 talk - | 西アドゥリン(H-7)のWescolinaに話し、欲しい部位を選ぶ | オファーリストには出ない。 | @西アドゥリン H-7 | T npc.256.Wescolina | > a01,b01,c01
a01 trade - | 【頭】Wescolinaに水石墨・ウルンダイ材・赤麻糸・赤漆をトレードし、だいじなもの「お仕立て交換券」をもらう | 同盟戦績12500ベヤルドもかかる。 | @西アドゥリン H-7 | T npc.256.Wescolina | N 水石墨*1,ウルンダイ材*1,赤麻糸*1,赤漆*1 | R 頭 | > g02
b01 trade - | 【胴】Wescolinaに溶岩の宝石・絹布・赤麻布・赤麻糸をトレードし、だいじなもの「お仕立て交換券」をもらう | 同盟戦績15000ベヤルドもかかる。 | @西アドゥリン H-7 | T npc.256.Wescolina | N 溶岩の宝石*1,絹布*1,赤麻布*1,赤麻糸*1 | R 胴 | > g02
c01 trade - | 【両足】Wescolinaに烈風の綿花・大羊のなめし革・ゴールドインゴット・赤麻糸をトレードし、だいじなもの「お仕立て交換券」をもらう | 同盟戦績10000ベヤルドもかかる。 | @西アドゥリン H-7 | T npc.256.Wescolina | N 烈風の綿花*1,大羊のなめし革*1,ゴールドインゴット*1,赤麻糸*1 | R 両足 | > g02
g02 talk - | ヴァナ0時を越えてからWescolinaに話し、選んだ部位をもらう | 次の部位は、受け取ってからヴァナ0時を越え、エリアを出入りしてから頼む。3部位で最低ヴァナ6日かかる。 | @西アドゥリン H-7 | T npc.256.Wescolina | K お仕立て交換券

@ quest.adoulin.028 https://wiki.ffo.jp/html/30727.html
Q Bagua Attire | バグア装束 | no | T npc.セレニア図書館.Hestefa = npc:Hestefa@セレニア図書館
RW item:バグアガレーロ
RW item:バグアチュニック
RW item:バグアミテーヌ
RW item:バグアパンツ
RW item:バグアサンダル
LK condition:ジオアタイアを全部装備している（AF109とAF119の混ぜてもよい）
g01 talk - | ジオアタイアを全部装備して、セレニア図書館のHestefaに話し、だいじなもの「バグア叙景詩」をもらう | - | @セレニア図書館 | T npc.セレニア図書館.Hestefa
g02 talk - | 東アドゥリン(I-7)のNhili Uvolepに話し、バグア叙景詩を渡す | - | @東アドゥリン I-7 | T npc.257.Nhili_Uvolep = npc:Nhili Uvolep@東アドゥリン I-7 | K バグア叙景詩
g03 examine - | 風水士で、ラ・カザナル宮外郭MAP1(L-8)のGeomantic Fumesを調べ、だいじなもの「ソーマの結晶【ユグドラシル】」をもらう | - | @ラ・カザナル宮外郭 L-8 #1 | T obj.274.Geomantic_Fumes = obj:Geomantic Fumes@ラ・カザナル宮外郭 L-8 #1
g04 talk - | 西アドゥリン(H-7)のWescolinaに話し、欲しい部位を選ぶ | 2部位目からはここから始められる。 | @西アドゥリン H-7 | T npc.256.Wescolina = npc:Wescolina@西アドゥリン H-7 | K ソーマの結晶【ユグドラシル】 | > a01,b01,c01,d01,e01
a01 trade - | 【頭】Wescolinaにグリフィンなめし革・赤漆・ラズのなめし革をトレードする | かわりにグリフィンなめし革・クリアソーダと同盟戦績97000ベヤルドでもよい。 | @西アドゥリン H-7 | T npc.256.Wescolina | N グリフィンなめし革*1,赤漆*1,ラズのなめし革*1 | R 頭 | > g05
b01 trade - | 【胴】Wescolinaにグリフィンなめし革・エーテルレザー・赤麻布をトレードする | かわりにグリフィンなめし革・チョコクレープと同盟戦績97000ベヤルドでもよい。 | @西アドゥリン H-7 | T npc.256.Wescolina | N グリフィンなめし革*1,エーテルレザー*1,赤麻布*1 | R 胴 | > g05
c01 trade - | 【両手】Wescolinaにグリフィンなめし革・ビスマス板・赤麻糸をトレードする | かわりにグリフィンなめし革・フロンティアチョコと同盟戦績97000ベヤルドでもよい。 | @西アドゥリン H-7 | T npc.256.Wescolina | N グリフィンなめし革*1,ビスマス板*1,赤麻糸*1 | R 両手 | > g05
d01 trade - | 【両脚】Wescolinaにグリフィンなめし革・エーテルコットン・赤麻布をトレードする | かわりにグリフィンなめし革・カスケードドロップと同盟戦績97000ベヤルドでもよい。 | @西アドゥリン H-7 | T npc.256.Wescolina | N グリフィンなめし革*1,エーテルコットン*1,赤麻布*1 | R 両脚 | > g05
e01 trade - | 【両足】Wescolinaにグリフィンなめし革・エーテルコットン・閃糸をトレードする | かわりにグリフィンなめし革・ジャングルクッキーと同盟戦績97000ベヤルドでもよい。 | @西アドゥリン H-7 | T npc.256.Wescolina | N グリフィンなめし革*1,エーテルコットン*1,閃糸*1 | R 両足 | > g05
g05 talk - | エリアを出入りし、ヴァナ0時を越えてからWescolinaに話して装備をもらう | 受注のときに「お仕立て交換券-太古版」をもらっている。次の部位はすぐ頼める。 | @西アドゥリン H-7 | T npc.256.Wescolina

@ quest.adoulin.029 https://wiki.ffo.jp/html/30726.html
Q Futhark Attire | フサルク装束 | no | T npc.セレニア図書館.Hestefa = npc:Hestefa@セレニア図書館
RW item:フサルクバンド
RW item:フサルクコート
RW item:フサルクミトン
RW item:フサルクトラウザ
RW item:フサルクブーツ
LK condition:ルーニストアタイアを全部装備している（AF109とAF119を混ぜてもよい）
g01 talk - | ルーニストアタイアを全部装備して、セレニア図書館のHestefaに話し、だいじなもの「フサルク理論」をもらう | このあとは装備していなくてよい。 | @セレニア図書館 | T npc.セレニア図書館.Hestefa
g02 examine - | 西アドゥリンのINV.ワークス(J-10)のAmchuchu's Laboratoryを調べる | フサルク理論はなくなる。 | @西アドゥリン J-10 | T obj.256.Amchuchus_Laboratory = obj:Amchuchu's Laboratory@西アドゥリン J-10 | K フサルク理論
g03 examine - | 魔導剣士で、ラ・カザナル宮外郭MAP1(M-6)のMeeting Pointを調べ、だいじなもの「カザナルファイバー」をもらう | Waypointで謎の魔導器へ飛ぶとすぐ近く。選択肢はどちらでもよい。 | @ラ・カザナル宮外郭 M-6 #1 | T obj.274.Meeting_Point = obj:Meeting Point@ラ・カザナル宮外郭 M-6 #1
g04 examine - | 西アドゥリン港の倉庫のあいだ(I-4)のInconspicuous Barrelを調べ、欲しい部位を選ぶ | カザナルファイバーはなくなる。 | @西アドゥリン I-4 | T obj.256.Inconspicuous_Barrel = obj:Inconspicuous Barrel@西アドゥリン I-4 | K カザナルファイバー | > a01,b01,c01,d01,e01
a01 trade - | 【頭】Inconspicuous Barrelにウーツインゴット・シンチレーター・輝白銀をトレードする | かわりにウーツインゴット・おにぎりと同盟戦績97000ベヤルドでもよい。 | @西アドゥリン I-4 | T obj.256.Inconspicuous_Barrel | N ウーツインゴット*1,シンチレーター*1,輝白銀*1 | R 頭 | > g05
b01 trade - | 【胴】Inconspicuous Barrelにウーツインゴット・エーテルレザー・ルーンクロスをトレードする | かわりにウーツインゴット・ソーセージロールと同盟戦績97000ベヤルドでもよい。 | @西アドゥリン I-4 | T obj.256.Inconspicuous_Barrel | N ウーツインゴット*1,エーテルレザー*1,ルーンクロス*1 | R 胴 | > g05
c01 trade - | 【両手】Inconspicuous Barrelにウーツインゴット・ラズのなめし革・ルーンクロスをトレードする | かわりにウーツインゴット・ローストコーンと同盟戦績97000ベヤルドでもよい。 | @西アドゥリン I-4 | T obj.256.Inconspicuous_Barrel | N ウーツインゴット*1,ラズのなめし革*1,ルーンクロス*1 | R 両手 | > g05
d01 trade - | 【両脚】Inconspicuous Barrelにウーツインゴット・ホーリーレザー・ルーンクロスをトレードする | かわりにウーツインゴット・アジェの干物と同盟戦績97000ベヤルドでもよい。 | @西アドゥリン I-4 | T obj.256.Inconspicuous_Barrel | N ウーツインゴット*1,ホーリーレザー*1,ルーンクロス*1 | R 両脚 | > g05
e01 trade - | 【両足】Inconspicuous Barrelにウーツインゴット・ホーリーレザー・閃糸をトレードする | かわりにウーツインゴット・ララブのしっぽと同盟戦績97000ベヤルドでもよい。 | @西アドゥリン I-4 | T obj.256.Inconspicuous_Barrel | N ウーツインゴット*1,ホーリーレザー*1,閃糸*1 | R 両足 | > g05
g05 examine - | ヴァナ0時を越えてからInconspicuous Barrelを調べ、装備をもらう | 受注のときに「未知の魔導剣士装束受注書」をもらっている。次の部位はすぐ頼める。手元にない部位も選択肢に出るので、頼みすぎに気をつける。 | @西アドゥリン I-4 | T obj.256.Inconspicuous_Barrel

@ quest.adoulin.030 https://wiki.ffo.jp/html/29516.html
Q Runeist Attire | ルーニスト装束 | no | T obj.258.Tomato_Vantage_Point = obj:Tomato Vantage Point@ララ水道 E-10
RW item:ルーニストバンド
RW item:ルーニストミトン
RW item:ルーニストブーツ
LK quest:魔導剣士AFクエスト「フォージング＜導きの剣＞」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Forging_New_Bonds;Tomato Vantage Point はララ水道 E-10。西アドゥリンのモグハウスのそばの入口が近い
g01 examine - | ララ水道(E-10)のTomato Vantage Pointを調べ、欲しい部位を選ぶ | 西アドゥリン(J-12)の入口から入る。 | @ララ水道 E-10 | T obj.258.Tomato_Vantage_Point | > a01,b01,c01
a01 trade - | 【頭】Tomato Vantage Pointに腐食した鉱石2つ・ロジウムインゴット・銀朱・ミスラントマトをトレードし、受注書をもらう | 同盟戦績12500ベヤルドもかかる。 | @ララ水道 E-10 | T obj.258.Tomato_Vantage_Point | N 腐食した鉱石*2,ロジウムインゴット*1,銀朱*1,ミスラントマト*1 | R 頭 | > g02
b01 trade - | 【両手】Tomato Vantage Pointにルーンクロス・丈夫な絹糸・ロジウムインゴット・金糸・ミスラントマトをトレードし、受注書をもらう | 同盟戦績10000ベヤルドもかかる。ルーンクロスはINV.ワークスのUgtoorから同盟戦績3000ベヤルドでもらう。 | @ララ水道 E-10 | T obj.258.Tomato_Vantage_Point | N ルーンクロス*1,丈夫な絹糸*1,ロジウムインゴット*1,金糸*1,ミスラントマト*1 | R 両手 | > g02
c01 trade - | 【両足】Tomato Vantage Pointにルーンクロス・丈夫な絹糸・ウラグナイトの殻・黒虎のなめし革・ミスラントマトをトレードし、受注書をもらう | 同盟戦績10000ベヤルドもかかる。 | @ララ水道 E-10 | T obj.258.Tomato_Vantage_Point | N ルーンクロス*1,丈夫な絹糸*1,ウラグナイトの殻*1,黒虎のなめし革*1,ミスラントマト*1 | R 両足 | > g02
g02 examine - | ヴァナ日付が変わってからTomato Vantage Pointを調べ、装備をもらう | - | @ララ水道 E-10 | T obj.258.Tomato_Vantage_Point

@ quest.adoulin.031 https://wiki.ffo.jp/html/31299.html
Q Quiescence | クイエセンス＜裏式＞ | no | T npc.256.Gaddiux = npc:Gaddiux@西アドゥリン J-10
RW item:レクシムブレード
RW key_item:クイエセンス＜裏式＞
LK quest:クエスト「プリオーデイン＜天命の匣＞」を終えている
LK condition:すべてのワークスの個人評価がレジェンド
LK condition:風水士のエルゴンウェポンのクエストを受けていない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Quiescence;Gaddiux J-10、Yorcia の ??? I-8（H-8 の茂みは21:00〜3:00 だけ開く）、Runje Desaali J-11、Coliseum の扉は M-6（Yeggha Dolashi のうしろ）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Runje_Desaali;Runje Desaali は東アドゥリン J-10
g01 talk - | 西アドゥリンのINV.ワークス(J-10)のGaddiuxに話す | まだオファーリストには出ない。魔導剣士でなくてよい。 | @西アドゥリン J-10 | T npc.256.Gaddiux
g02 trade - | ヨルシア森林(I-8)の???につるはしをトレードし、だいじなもの「ナム・ブロッサムの種子」をもらう | 「穢れた土地」と同じ場所。 | @ヨルシア森林 I-8 | T obj.263.qqq_I-8 = obj:???@ヨルシア森林 I-8 | N つるはし*1
g03 trade - | もう一度???につるはしをトレードし、だいじなもの「折れた刺突剣の柄」をもらう | 出るまでくり返す。 | @ヨルシア森林 I-8 | T obj.263.qqq_I-8 | N つるはし*1
g04 talk - | 西アドゥリン(J-10)のGaddiuxに話す | - | @西アドゥリン J-10 | T npc.256.Gaddiux
g05 talk - | 東アドゥリンのRunje Desaaliに話す | - | @東アドゥリン J-10 J-11 | T npc.257.Runje_Desaali = npc:Runje Desaali@東アドゥリン J-10 J-11
g06 trade - | Runje Desaaliに高純度ベヤルド100個を渡し、だいじなもの「真紅の触媒」をもらう | - | @東アドゥリン J-10 J-11 | T npc.257.Runje_Desaali | N 高純度ベヤルド*100
g07 talk - | 魔導剣士で東アドゥリン(I-8)のOctavienに話す | ここでオファーリストに出る。 | @東アドゥリン I-8 | T npc.257.Octavien = npc:Octavien@東アドゥリン I-8 | K 真紅の触媒
g08 examine - | 魔導剣士で、ララ水道(M-6)のEntrance: Coliseumを調べ、BF「クイエセンス＜裏式＞」に入る | 1人だけ、15分。サポートジョブは使えず、フェイスも呼べない。 | @ララ水道 M-6 | T obj.258.Entrance_Coliseum = obj:Entrance: Coliseum@ララ水道 M-6 | K 真紅の触媒
g09 defeat - | Zurko-Bazurkoを倒し、だいじなもの「クイエセンス＜裏式＞」をもらう | 負けても真紅の触媒はなくならない。ランジに気をつける。 | @ララ水道 M-6 | T mob.259.Zurko-Bazurko = mob:Zurko-Bazurko@ララ水道〔Ｕ〕
g10 talk - | 東アドゥリン(I-8)のOctavienに報告する | - | @東アドゥリン I-8 | T npc.257.Octavien | K クイエセンス＜裏式＞
g11 talk - | 西アドゥリン(J-10)のGaddiuxに話して完了 | このあとレクシムブレードはRunje Desaaliにトレードして段階的に強化する。 | @西アドゥリン J-10 | T npc.256.Gaddiux

@ quest.adoulin.032 https://wiki.ffo.jp/html/28487.html
Q Fertile Ground | 野菜と成長促進剤 | no | T npc.258.Chalvava = npc:Chalvava@ララ水道 F-11
RW other:経験値（リミットポイント）500
RW other:同盟戦績300ベヤルド
LK quest:クエスト「商売道具と人助け」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Fertile_Ground;Chalvava F-11。入口は西アドゥリン I-12（レンタルハウスのそば）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Shipilolo;Shipilolo は西アドゥリン J-9
g01 talk - | ララ水道のシビック・アボレタム(F-11)のChalvavaに話して受ける | 西アドゥリン(I-12)の入口が近い。 | @ララ水道 F-11 | T npc.258.Chalvava
g02 talk - | 西アドゥリンのINV.ワークスのShipiloloに話し、だいじなもの「成長促進剤」をもらう | 「眠れる果実」で小さな種をもらってからクリアするまでは進められない。 | @西アドゥリン J-9 J-10 | T npc.256.Shipilolo = npc:Shipilolo@西アドゥリン J-9 J-10
g03 talk - | Chalvavaに報告して完了 | - | @ララ水道 F-11 | T npc.258.Chalvava | K 成長促進剤

@ quest.adoulin.033 https://wiki.ffo.jp/html/28080.html
Q It Sets My Heart Aflutter | 闇への抵抗IV | yes | T npc.258.Saldinor = npc:Saldinor@ララ水道 E-10 F-10
RW other:経験値（リミットポイント）500
RW other:同盟戦績200ベヤルド
RW title:混沌への抵抗者
LK condition:2回目からは「感染する混沌」まで終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/It_Sets_My_Heart_Aflutter;Saldinor F-10。翅はケイザック古戦場 G-10、ヤッセの狩り場 I-8、ラ・カザナル宮外郭MAP1 F-6/G-6 のトウィザリム族
g01 talk - | ララ水道のシビック・アボレタムのSaldinorに話して受ける | 開拓者バッジは要らない。西アドゥリン(I-12)の入口が近い。 | @ララ水道 E-10 F-10 | T npc.258.Saldinor
g02 trade - | Saldinorにトウィザリムの翅を2つトレードして完了 | 競売でも買える。3回クリアすると称号「混沌への抵抗者」。 | @ララ水道 E-10 F-10 | T npc.258.Saldinor | N トウィザリムの翅*2

@ quest.adoulin.034 https://wiki.ffo.jp/html/30694.html
Q Lerene's Lament | 魔力断絶の学識 | no | T npc.274.Lerene = npc:Lerene@ラ・カザナル宮外郭 N-7 #1
RW key_item:レリーン特製呪符
RW key_item:パルバライズスキル
RW other:同盟戦績500ベヤルド
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Lerene%27s_Lament;Lerene N-7。布は K-8 のシャドウ族
XS BG Wiki;https://www.bg-wiki.com/ffxi/Ancestral_Cloth;Shunned Engraver、Shunned Valiant、Shunned Saboteur が落とす
g01 talk - | ラ・カザナル宮外郭MAP1(N-7)のLereneに話して受ける | カミール山麓からの出入口のそば。 | @ラ・カザナル宮外郭 N-7 #1 | T npc.274.Lerene
g02 defeat - | (K-8)のシャドウ族を倒し、アンセスタークロスを2つ集める | Shunned Engraver・Shunned Valiant・Shunned Saboteurが落とす。競売でも買える。 | @ラ・カザナル宮外郭 K-8 #1 | T mob.274.Shunned_Engraver = mob:Shunned Engraver@ラ・カザナル宮外郭 K-8 #1
g03 trade - | Lereneにアンセスタークロスを2つトレードして完了 | - | @ラ・カザナル宮外郭 N-7 #1 | T npc.274.Lerene | N アンセスタークロス*2

@ quest.adoulin.035 https://wiki.ffo.jp/html/35558.html
Q Winds of Eternity | 悠久の風 | yes | T obj.281.Drifting_Feather = obj:Drifting Feather@リファーリア H-7 H-8
RW item:リゲイアサイズ
RW item:リゲイアリング
RW item:リゲイアサッシュ
RW other:10000ベヤルド
RW other:召喚獣セイレーンとの契約
LK quest:クエスト「静かなる森」か「悠久の風」を終え、リアル0時を越えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Winds_of_Eternity;Drifting Feather H-7、相手は Siren Prime。ホラ・デム・メアの結晶を持っていると同じ岩の土は取れない
g01 examine - | リファーリアの北端のDrifting Featherを調べて受ける | テンキー7と8のあいだ。 | @リファーリア H-7 H-8 | T obj.281.Drifting_Feather | > a01,b01,c01
a01 examine - | 【ホラの岩】ラテーヌ高原のホラの岩で、Telepointへの階段の下のErgon Locus ???を調べ、だいじなもの「なじみ深い土地の力」をもらう | 所属国に近い岩へ行く。 | @ラテーヌ高原 | T obj.102.Ergon_Locus = obj:Ergon Locus ???@ラテーヌ高原 | R ホラの岩 | > g02
b01 examine - | 【デムの岩】コンシュタット高地のデムの岩で、Telepointへの階段の下のErgon Locus ???を調べ、だいじなもの「なじみ深い土地の力」をもらう | 所属国に近い岩へ行く。 | @コンシュタット高地 | T obj.108.Ergon_Locus = obj:Ergon Locus ???@コンシュタット高地 | R デムの岩 | > g02
c01 examine - | 【メアの岩】タロンギ大峡谷のメアの岩で、Telepointへの階段の下のErgon Locus ???を調べ、だいじなもの「なじみ深い土地の力」をもらう | 所属国に近い岩へ行く。 | @タロンギ大峡谷 | T obj.117.Ergon_Locus = obj:Ergon Locus ???@タロンギ大峡谷 | R メアの岩 | > g02
g02 examine - | リファーリアのDrifting Featherを調べてBFに入る | なじみ深い土地の力はなくなる。 | @リファーリア H-7 H-8 | T obj.281.Drifting_Feather | K なじみ深い土地の力
g03 defeat - | Siren Primeを倒し、報酬を選んで完了 | もう一度受けるにはリアル0時を越える。 | @リファーリア H-7 H-8 | T mob.281.Siren_Prime = mob:Siren Prime@リファーリア

@ quest.adoulin.036 https://wiki.ffo.jp/html/28078.html
Q Don't Ever Leaf Me | いたいけなモンスター | no | T npc.257.Audibert = npc:Audibert@東アドゥリン F-9
RW other:同盟戦績1200ベヤルド（3回に分けて）
LK condition:だいじなもの「開拓者バッジ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Don%27t_Ever_Leaf_Me;Audibert F-9（SCT.ワークス）。「幻の果実水」を進めていると錆びたつるはしは釣れない
g01 talk - | 東アドゥリンのSCT.ワークス(F-9)のAudibertに話して受ける | 下の3つはどの順でもよい。 | @東アドゥリン F-9 | T npc.257.Audibert
g02 talk - | 東アドゥリンのPCK.ワークス(F-7)のCorpo-Vorpoに話す | - | @東アドゥリン F-7 | T npc.257.Corpo-Vorpo = npc:Corpo-Vorpo@東アドゥリン F-7
g03 examine - | 夜20:00〜4:00に、モリマー台地(K-10)のDaunting Emanationを調べる | F.ステーションから南東。 | @モリマー台地 K-10 | T obj.265.Daunting_Emanation = obj:Daunting Emanation@モリマー台地 K-10 | W 20:00-4:00
g04 talk - | Audibertに報告し、同盟戦績400ベヤルドをもらう | - | @東アドゥリン F-9 | T npc.257.Audibert
g05 talk - | 西アドゥリンのCOU.ワークス(G-7)のDewaltに話す | - | @西アドゥリン G-7 | T npc.256.Dewalt = npc:Dewalt@西アドゥリン G-7
g06 gather - | エヌティエル水林で釣りをして、だいじなもの「錆びたつるはし」を釣る | 淡水で釣れない竿とエサの組み合わせにするとかかりやすい。「幻の果実水」を進めていると釣れない。 | @エヌティエル水林
g07 talk - | Audibertに報告し、同盟戦績700ベヤルドをもらう | - | @東アドゥリン F-9 | T npc.257.Audibert | K 錆びたつるはし
g08 talk - | 西アドゥリンのPIO.ワークス(E-8)のBarenngoに話す | - | @西アドゥリン E-8 | T npc.256.Barenngo = npc:Barenngo@西アドゥリン E-8
g09 examine - | ヤッセの狩り場(J-6)のWindblown Loamを調べる | F.ビバック#1から北へ行き、最初を右に曲がって左の壁ぞいに進む。 | @ヤッセの狩り場 J-6 | T obj.260.Windblown_Loam = obj:Windblown Loam@ヤッセの狩り場 J-6
g10 talk - | Audibertに報告し、同盟戦績100ベヤルドをもらって完了 | - | @東アドゥリン F-9 | T npc.257.Audibert

@ quest.adoulin.037 https://wiki.ffo.jp/html/29082.html
Q Order Up | おつかいやるのん？ | no | T npc.セレニア図書館.Reja_Ygridhi = npc:Reja Ygridhi@セレニア図書館
RW other:経験値（リミットポイント）1000
RW other:同盟戦績500ベヤルド
RW other:セレニア図書館の本が（一部をのぞき）読めるようになる
LK condition:だいじなもの「セレニアメンバーズカード」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Order_Up;カードは東アドゥリン F-9 の SCT.ワークスの Patient Snake から。ハーバートン家は Jozhud のあとに Palomel と書く
g01 talk - | セレニア図書館のReja Ygridhiに話して受け、だいじなもの「十二名家の資料」をもらう | 下の12人はどの順でもよい。 | @セレニア図書館 | T npc.セレニア図書館.Reja_Ygridhi
g02 talk - | 西アドゥリン(D-8)のOka Qhantariに話す（カリエイ家） | PIO.ワークスの西。 | @西アドゥリン D-8 | T npc.256.Oka_Qhantari = npc:Oka Qhantari@西アドゥリン D-8 | K 十二名家の資料
g03 talk - | 西アドゥリン(G-6)のMastanに話す（シュネデック家） | COU.ワークスの裏。 | @西アドゥリン G-6 | T npc.256.Mastan = npc:Mastan@西アドゥリン G-6 | K 十二名家の資料
g04 talk - | 西アドゥリン(H-12)のMarjoirelleに話す（テュランドー家） | モグハウスのそばの南東。 | @西アドゥリン H-12 | T npc.256.Marjoirelle = npc:Marjoirelle@西アドゥリン H-12 | K 十二名家の資料
g05 talk - | 西アドゥリン(I-8)のGrevanに話す（ジャニストン家） | シャニラの泉の北東。 | @西アドゥリン I-8 | T npc.256.Grevan = npc:Grevan@西アドゥリン I-8 | K 十二名家の資料
g06 talk - | 西アドゥリン(K-10)のTerwokに話す（オーヴェイル家） | INV.ワークスの裏。 | @西アドゥリン K-10 | T npc.256.Terwok = npc:Terwok@西アドゥリン K-10 | K 十二名家の資料
g07 talk - | 東アドゥリン(G-7)のOscairnに話す（ヴォーケイン家） | PCK.ワークスの北東。 | @東アドゥリン G-7 | T npc.257.Oscairn = npc:Oscairn@東アドゥリン G-7 | K 十二名家の資料
g08 talk - | 東アドゥリン(G-9)のPalomelに話す（ハーバートン家） | SCT.ワークスの向かい。 | @東アドゥリン G-9 | T npc.257.Palomel = npc:Palomel@東アドゥリン G-9 | K 十二名家の資料
g09 talk - | 東アドゥリン(I-7)のNhili Uvolepに話す（レナイェ家） | Waypoint「スヴェルドリード坂」の近く。 | @東アドゥリン I-7 | T npc.257.Nhili_Uvolep = npc:Nhili Uvolep@東アドゥリン I-7 | K 十二名家の資料
g10 talk - | 東アドゥリン(J-7)のRigobertineに話す（ウェーザースプーン家） | 城門前から北へのびる長い道の先。 | @東アドゥリン J-7 | T npc.257.Rigobertine = npc:Rigobertine@東アドゥリン J-7 | K 十二名家の資料
g11 talk - | 東アドゥリン(K-9)のOingo-Zoingoに話す（ゴーニー家） | 城門前の北のタルタル。 | @東アドゥリン K-9 | T npc.257.Oingo-Zoingo = npc:Oingo-Zoingo@東アドゥリン K-9 | K 十二名家の資料
g12 talk - | 東アドゥリン(K-9)のPloh Trishbahkに話す（アドゥリン家） | アドゥリン城門のガード。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk = npc:Ploh Trishbahk@東アドゥリン K-9 | K 十二名家の資料
g13 talk - | 東アドゥリン(K-10)のChumli-Mojumliに話す（ウォルタリス家） | 城門前の南のタルタル。 | @東アドゥリン K-10 | T npc.257.Chumli-Mojumli = npc:Chumli-Mojumli@東アドゥリン K-10 | K 十二名家の資料
g14 talk - | セレニア図書館のReja Ygridhiに報告して完了 | 七支公討伐などで、あとで追加の報酬ももらえる。 | @セレニア図書館 | T npc.セレニア図書館.Reja_Ygridhi

@ quest.adoulin.038 https://wiki.ffo.jp/html/32647.html
Q Mistress of Ceremonies | イングリッドの儀式 | no | T npc.257.Rigobertine = npc:Rigobertine@東アドゥリン J-7
RW other:経験値12000
RW other:同盟戦績3000ベヤルド
RW item:エリクサータンク
LK quest:クエスト「無慈悲な冷気」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mistress_of_Ceremonies;Rigobertine J-7、Suspicious Roots G-6（澄明の池のそば）。BFの相手は Headless Torturer、Ingrid が倒れると負け
g01 talk - | 東アドゥリン(J-7)のエクソシスト・プライオリーのRigobertineに話し、だいじなもの「穢れ祓いの紫布」をもらう | 一覧の依頼者はMarcellurin。 | @東アドゥリン J-7 | T npc.257.Rigobertine
g02 examine - | ヨルシア森林(G-6)のSuspicious Rootsを調べる | エルゴン・ローカス「澄明の池」のすぐ近く。F.ビバック#1から北西へ。 | @ヨルシア森林 G-6 | T obj.263.Suspicious_Roots = obj:Suspicious Roots@ヨルシア森林 G-6 | K 穢れ祓いの紫布
g03 examine - | もう一度Suspicious Rootsを調べてレイヤーエリアに入る | 負けたらRigobertineに話すと紫布をまたもらえる。 | @ヨルシア森林 G-6 | T obj.263.Suspicious_Roots | K 穢れ祓いの紫布
g04 defeat - | Headless Torturerを倒す | Ingridが倒れると負け。フェイスは呼べる。 | @ヨルシア森林 G-6 | T mob.264.Headless_Torturer = mob:Headless Torturer@ヨルシア森林〔Ｕ〕
g05 examine - | Suspicious Rootsを調べて完了 | - | @ヨルシア森林 G-6 | T obj.263.Suspicious_Roots

@ quest.adoulin.039 https://wiki.ffo.jp/html/29084.html
Q Endeavoring to Awaken | エンデヴァー＜理の覚醒＞ | no | T npc.257.Octavien = npc:Octavien@東アドゥリン I-8
RW other:レベル上限が75になる
RW other:同盟戦績3000ベヤルド
RW key_item:エンデヴァー＜理の覚醒＞
RW title:理の執行者
LK condition:Lv66以上の魔導剣士
LK quest:クエスト「ルーンを識る者」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Endeavoring_to_Awaken;入口はララ水道 M-6（Yeggha Dolashi のうしろの扉、東アドゥリン F-7 から）。本戦の相手を BG Wiki は「Sverdheid ???」と書く
g01 talk - | 魔導剣士で東アドゥリン(I-8)のOctavienに話して受け、だいじなもの「エンデヴァー＜鏡花風月＞」をもらう | スヴェルドリード坂の階段の下。 | @東アドゥリン I-8 | T npc.257.Octavien
g02 examine - | ララ水道(M-6)のEntrance: Coliseumを調べてBFに入る | 東アドゥリン(F-7)の入口が近い。途中のコウモリはアクティブで強い。サポートジョブは使えない。10分。 | @ララ水道 M-6 | T obj.258.Entrance_Coliseum = obj:Entrance: Coliseum@ララ水道 M-6 | K エンデヴァー＜鏡花風月＞
g03 defeat - | 階段の上で出てくるZurko-Bazurkoを倒す | とても弱い。再戦では出てこない。 | @ララ水道 M-6 | T mob.259.Zurko-Bazurko = mob:Zurko-Bazurko@ララ水道〔Ｕ〕
g04 defeat - | 広間のSverdhried ???のHPを8割ほど削る | ノンアクティブ。ランジのマジックバーストに気をつける。 | @ララ水道 M-6 | T mob.259.Sverdhried = mob:Sverdhried ???@ララ水道〔Ｕ〕
g05 talk - | 東アドゥリン(I-8)のOctavienに話して完了 | 負けてもOctavienからまたもらえる（ヴァナ1日に1回は無料）。 | @東アドゥリン I-8 | T npc.257.Octavien

@ quest.adoulin.040 https://wiki.ffo.jp/html/28350.html
Q Cafe...teria | カフェマスターのお願い | yes | T npc.257.Yocile = npc:Yocile@東アドゥリン G-8
RW other:経験値（リミットポイント）500
RW other:同盟戦績300ベヤルド
RW gil:500
RW other:次のコンクェスト集計まで、カフェ『女神の涙』でパームジュースが買える
XS BG Wiki;https://www.bg-wiki.com/ffxi/Cafe...teria;Yocile G-8（Waypoint「女神像広場」のそば）。実はカザムの Ghemi Sinterilo（G-7）で買える
g01 talk - | 東アドゥリンのカフェ『女神の涙』(G-8)のYocileに話して受ける | 開拓者バッジがなくてもよい。コンクェスト集計ごとにまた受けられる。 | @東アドゥリン G-8 | T npc.257.Yocile
g02 trade - | Yocileにエルシモパームの実を2つトレードして完了 | 競売か、カザムの飛空旅行社で買える。 | @東アドゥリン G-8 | T npc.257.Yocile | N エルシモパームの実*2

@ quest.adoulin.041 https://wiki.ffo.jp/html/29394.html
Q Forging New Bonds | フォージング＜導きの剣＞ | no | T npc.257.Octavien = npc:Octavien@東アドゥリン I-8
RW item:ベオルクソード
LK condition:Lv90以上の魔導剣士
LK quest:クエスト「エンデヴァー＜理の覚醒＞」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Forging_New_Bonds;Barrel は西アドゥリン I-4、Tomato Vantage Point はララ水道 E-10、Molten Rift はモーの門 K-8（I-7 のレイヴを通る）
g01 talk - | 魔導剣士で東アドゥリン(I-8)のOctavienに話して受ける | 前のクエストから続けるときはエリアを出入りする。 | @東アドゥリン I-8 | T npc.257.Octavien
g02 talk - | 西アドゥリンのINV.ワークス(J-10)のGaddiuxに話す | - | @西アドゥリン J-10 | T npc.256.Gaddiux = npc:Gaddiux@西アドゥリン J-10
g03 examine - | 西アドゥリン(I-4)の倉庫のすきまのInconspicuous Barrelを調べる | - | @西アドゥリン I-4 | T obj.256.Inconspicuous_Barrel = obj:Inconspicuous Barrel@西アドゥリン I-4
g04 talk - | 東アドゥリン(I-8)のOctavienに話す | - | @東アドゥリン I-8 | T npc.257.Octavien
g05 examine - | ララ水道(E-10)のTomato Vantage Pointを調べ、「剣について尋ねる」で凍った炎の大精霊石の話を聞き、だいじなもの「瞬間冷凍ジュース」をもらう | 西アドゥリンのレンタルハウス前のWaypointが近い。 | @ララ水道 E-10 | T obj.258.Tomato_Vantage_Point = obj:Tomato Vantage Point@ララ水道 E-10
g06 trade - | 「剣について尋ねる」でルーンセイバーの話を聞き、Tomato Vantage Pointにソビロクレイモアをトレードして、だいじなもの「ルーンセイバー」をもらう | ソビロクレイモアがなければエリクサー系の薬品でもよい。 | @ララ水道 E-10 | T obj.258.Tomato_Vantage_Point | N ソビロクレイモア*1
g07 trade - | モーの門MAP1(K-8)のMolten Riftに炎将の赤石をトレードする | 瞬間冷凍ジュースはなくなる。 | @モーの門 K-8 #1 | T obj.269.Molten_Rift = obj:Molten Rift@モーの門 K-8 #1 | N 炎将の赤石*1 | K 瞬間冷凍ジュース
g08 examine - | もう一度Molten Riftを調べ、NMのStaumarthを出す | 近くのエフトを巻き込まないように。 | @モーの門 K-8 #1 | T obj.269.Molten_Rift
g09 defeat - | Staumarthを倒し、だいじなもの「凍った炎の大精霊石」をもらう | 物理に強い。火と雷の魔法がよく通る。 | @モーの門 K-8 #1 | T mob.269.Staumarth = mob:Staumarth@モーの門 K-8 #1
g10 examine - | 西アドゥリン(I-4)のInconspicuous Barrelを調べる | ルーンセイバーと凍った炎の大精霊石はなくなる。 | @西アドゥリン I-4 | T obj.256.Inconspicuous_Barrel | K ルーンセイバー,凍った炎の大精霊石
g11 examine - | ヴァナ0時を越えてから、もう一度Inconspicuous Barrelを調べる | - | @西アドゥリン I-4 | T obj.256.Inconspicuous_Barrel
g12 talk - | 東アドゥリン(I-8)のOctavienに話して完了 | - | @東アドゥリン I-8 | T npc.257.Octavien

@ quest.adoulin.042 https://wiki.ffo.jp/html/29396.html
Q Destiny's Device | プリオーデイン＜天命の匣＞ | no | T npc.257.Octavien = npc:Octavien@東アドゥリン I-8
RW item:ルーニストコート
RW title:灼然なる大魔導剣士
LK quest:クエスト「レガシー＜継ぐ識力＞」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Destiny%27s_Device;Yahse Wildflower K-7、マリアミ渓谷の ??? I-8（F.ビバック#2 の東の滝の下）、Bloodstained Glove はエヌティエル水林 J-11
g01 talk - | 魔導剣士で東アドゥリン(I-8)のOctavienに話して受け、だいじなもの「魔導撮像匣」をもらう | - | @東アドゥリン I-8 | T npc.257.Octavien
g02 talk - | 西アドゥリンのINV.ワークス(J-10)のGaddiuxに話す | - | @西アドゥリン J-10 | T npc.256.Gaddiux = npc:Gaddiux@西アドゥリン J-10
g03 examine - | ヤッセの狩り場(K-7)のYahse Wildflowerを調べ、だいじなもの「ヤッセの花弁」をもらう | もう持っていればいらない。 | @ヤッセの狩り場 K-7 | T obj.260.Yahse_Wildflower = obj:Yahse Wildflower@ヤッセの狩り場 K-7
g04 examine - | イグニスを3つかけて、マリアミ渓谷(I-8)の???を調べ、だいじなもの「鮮やかな紅汁」をもらう | F.ビバック#2のすぐ東。 | @マリアミ渓谷 I-8 | T obj.266.qqq_I-8 = obj:???@マリアミ渓谷 I-8
g05 talk - | 西アドゥリン(J-10)のGaddiuxに話す | - | @西アドゥリン J-10 | T npc.256.Gaddiux
g06 talk - | 東アドゥリン(I-8)のOctavienに話す | - | @東アドゥリン I-8 | T npc.257.Octavien
g07 examine - | エヌティエル水林(J-11)の海岸のBloodstained Gloveを調べる | F.ビバック#2の島の、地図に道のない浜。「清浄の浜」と同じ場所。 | @エヌティエル水林 J-11 | T obj.262.Bloodstained_Glove = obj:Bloodstained Glove@エヌティエル水林 J-11
g08 examine - | もう一度Bloodstained Gloveを調べ、NMのInsidioを出す | 雨のときは近くにゲフィルストが出る。 | @エヌティエル水林 J-11 | T obj.262.Bloodstained_Glove
g09 defeat - | Insidioを倒し、だいじなもの「インシディオの消えた提灯」をもらう | メイヘムランターンの魅了に気をつける。 | @エヌティエル水林 J-11 | T mob.262.Insidio = mob:Insidio@エヌティエル水林 J-11
g10 examine - | もう一度Bloodstained Gloveを調べる | - | @エヌティエル水林 J-11 | T obj.262.Bloodstained_Glove
g11 talk - | 東アドゥリン(I-8)のOctavienに話して完了 | - | @東アドゥリン I-8 | T npc.257.Octavien

@ quest.adoulin.043 https://wiki.ffo.jp/html/28507.html
Q Meg-alomaniac | メグちゃんの病気 | no | T npc.257.Sharuru = npc:Sharuru@東アドゥリン F-8
RW other:経験値1000
RW other:同盟戦績500ベヤルド
RW other:3000cp
RW title:シャルルのお気に入り
LK quest:クエスト「西アドゥリンのウェイポイント」「東アドゥリンのウェイポイント」「野菜と成長促進剤」を終えている
LK fame:アドゥリンの名声ランク3以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Meg-alomaniac;西アドゥリンの Waypoint は H-8、E-8、G-10、J-9、F-10、H-11、L-9、H-4、I-5
g01 talk - | 東アドゥリンのPCK.ワークス前(F-8)のSharuruに話し、だいじなもの「ウェイポイント調整キット」をもらう | - | @東アドゥリン F-8 | T npc.257.Sharuru
g02 examine - | 西アドゥリンのWaypoint9か所を全部調べる | (H-8)(E-8)(G-10)(J-9)(F-10)(H-11)(L-9)(H-4)(I-5)。Waypointで飛んでもよい。 | @西アドゥリン | K ウェイポイント調整キット
g03 talk - | Sharuruに報告して完了 | - | @東アドゥリン F-8 | T npc.257.Sharuru

@ quest.adoulin.044 https://wiki.ffo.jp/html/32645.html
Q The Curious Case of Melvien | メルヴィアン殺人事件 | no | T npc.257.Estelle = npc:Estelle@東アドゥリン F-9
RW other:経験値4000
RW other:同盟戦績1250ベヤルド
LK condition:アドゥリンミッション「さらなる加護」まで進めている
LK quest:クエスト「モンストロス･プレッジ」で星辰の指輪をもらい、パシュハウ沼(E-12)のSuspicious Humeに話している
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Curious_Case_of_Melvien;Estelle F-9、木箱 I-9、Storage Container はララ水道 H-6（西アドゥリン K-8 から）。報酬に高純度ベヤルド5個も書く
g01 talk - | 東アドゥリン(F-9)のEstelleに話し、だいじなもの「マルグレートの手紙」をもらう | 一覧の依頼者はMargret。SCT.ワークスの裏。 | @東アドゥリン F-9 | T npc.257.Estelle
g02 examine - | 東アドゥリン(I-9)の高架下の木箱の???を調べ、だいじなもの「メルヴィアンの似顔絵」をもらう | ここでオファーリストに出る。 | @東アドゥリン I-9 | T obj.257.qqq_I-9 = obj:???@東アドゥリン I-9
g03 talk - | 東アドゥリン(K-10)のChumli-Mojumliに話し、「エスティエヌを呼ぶ」を選んで、だいじなもの「豹変したメルヴィアン」をもらう | ウォルタリス家の前。 | @東アドゥリン K-10 | T npc.257.Chumli-Mojumli = npc:Chumli-Mojumli@東アドゥリン K-10
g04 talk - | 西アドゥリン(G-6)のMastanに話し、だいじなもの「メルヴィアンは一度死んでいた？」をもらう | シュネデック家の前。 | @西アドゥリン G-6 | T npc.256.Mastan = npc:Mastan@西アドゥリン G-6
g05 examine - | 東アドゥリン(I-9)の木箱の???を調べ、だいじなもの「マルグレートのメモ」をもらう | - | @東アドゥリン I-9 | T obj.257.qqq_I-9
g06 examine - | ララ水道(H-6)のStorage Containerを調べる | 西アドゥリンのビッグブリッジのそば(K-8)の入口が近い。答えは「財務大臣補佐 エスティエヌ」「鼠騎士モリマー」だが、まちがえても進む。 | @ララ水道 H-6 | T obj.258.Storage_Container = obj:Storage Container@ララ水道 H-6
g07 examine - | 東アドゥリン(I-9)の木箱の???を調べる | - | @東アドゥリン I-9 | T obj.257.qqq_I-9
g08 talk - | 東アドゥリン(F-9)のEstelleに話して完了 | - | @東アドゥリン F-9 | T npc.257.Estelle

@ quest.adoulin.045 https://wiki.ffo.jp/html/28065.html
Q Children of the Rune | ルーンを識る者 | no | T npc.257.Octavien = npc:Octavien@東アドゥリン I-8
RW item:ソビロクレイモア
RW other:魔導剣士になれる
RW title:ルーンを刻みし者
LK condition:Lv30以上
g01 talk - | 東アドゥリン(I-8)のOctavienに話して受ける | スヴェルドリード坂のWaypointから階段を下りた所。 | @東アドゥリン I-8 | T npc.257.Octavien
g02 examine - | ヤッセの狩り場(K-7)のYahse Wildflowerを調べ、だいじなもの「ヤッセの花弁」をもらう | F.ステーションが近い。 | @ヤッセの狩り場 K-7 | T obj.260.Yahse_Wildflower = obj:Yahse Wildflower@ヤッセの狩り場 K-7
g03 talk - | Octavienに話し、「エンチャントルーン：????」を選ぶ | ルーンが出なければもう一度選ぶ。多くても100回までに出る。 | @東アドゥリン I-8 | T npc.257.Octavien | K ヤッセの花弁

@ quest.adoulin.046 https://wiki.ffo.jp/html/29395.html
Q Legacies Lost and Found | レガシー＜継ぐ識力＞ | no | T npc.257.Octavien = npc:Octavien@東アドゥリン I-8
RW item:ルーニストトラウザ
RW other:謎の装置1か所につき2000ベヤルド
LK quest:クエスト「フォージング＜導きの剣＞」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Legacies_Lost_and_Found;Ohruru はウィンダス港 E-7。装置の場所はダングルフの涸れ谷 E-11、グスゲン鉱山MAP2 J-5、クロウラーの巣MAP3 K-8、オルデール鍾乳洞 E-12、エルディーム古墳MAP2 K-13、外ホルトト遺跡MAP5 E-6、ガルレージュ要塞MAP3 K-8、シャクラミの地下迷宮MAP2 L-10 など
g01 talk - | 魔導剣士で東アドゥリン(I-8)のOctavienに話して受け、だいじなもの「オクタヴィアンの手紙」をもらう | 前のクエストから続けるときはエリアを出入りする。 | @東アドゥリン I-8 | T npc.257.Octavien
g02 talk - | ウィンダス港(E-7)の口の院のOhruruに話す | - | @ウィンダス港 E-7 | T npc.240.Ohruru = npc:Ohruru@ウィンダス港 E-7 | K オクタヴィアンの手紙
g03 talk - | エンチャントルーンをかけて、もう一度Ohruruに話す | - | @ウィンダス港 E-7 | T npc.240.Ohruru
g04 examine - | 謎の装置を3か所以上回り、裏のHazy Runeを調べてだいじなもの「ルーン石」をもらう | 装置の属性に強いルーンを3つかけて調べる（エルディーム古墳はイグニス、オルデール鍾乳洞はゲールス、グスゲン鉱山はフラブラ、外ホルトト遺跡はテッルス、クロウラーの巣はスルポール、ダングルフの涸れ谷はウンダ、シャクラミの地下迷宮はルックス、ガルレージュ要塞はテネブレイ）。属性が3つの場所は数に入らない。
g05 talk - | ウィンダス港のOhruruに話し、クイズに全部正解して、だいじなもの「ルーン強化の極意書」をもらう | 1問10秒。「今何問目？」も出るので数えておく。まちがえてもすぐやり直せる。 | @ウィンダス港 E-7 | T npc.240.Ohruru
g06 talk - | 東アドゥリン(I-8)のOctavienに話す | - | @東アドゥリン I-8 | T npc.257.Octavien | K ルーン強化の極意書
g07 examine - | 西アドゥリン(I-4)の倉庫のすきまのInconspicuous Barrelを調べる | - | @西アドゥリン I-4 | T obj.256.Inconspicuous_Barrel = obj:Inconspicuous Barrel@西アドゥリン I-4
g08 examine - | ヴァナ0時を越えてから、もう一度Inconspicuous Barrelを調べて完了 | 回らなかった装置は、あとで行ってもルーン石と戦績がもらえる。 | @西アドゥリン I-4 | T obj.256.Inconspicuous_Barrel

@ quest.adoulin.047 https://wiki.ffo.jp/html/31523.html
Q Geomancerrific | 古の棍 | no | T npc.257.Nhili_Uvolep = npc:Nhili Uvolep@東アドゥリン I-7
RW other:エクズデーションを覚える
LK condition:Lv99の風水士
g01 talk - | 風水士Lv99で東アドゥリン(I-7)のNhili Uvolepに話し、トライアルワンドをもらう | - | @東アドゥリン I-7 | T npc.257.Nhili_Uvolep
g02 go - | トライアルワンドを装備して戦い、300ポイントためる | ほかの潜在消しと同じ数え方。たまるとエクズデーションが使えるようになる。
g03 trade - | Nhili Uvolepにトライアルワンドをトレードして完了 | ためる前にトレードすると進み具合を教えてくれる。 | @東アドゥリン I-7 | T npc.257.Nhili_Uvolep | N トライアルワンド*1

@ quest.adoulin.048 https://wiki.ffo.jp/html/29729.html
Q Velkkovert Operations | 密会 | no | T npc.257.Zaffeld
RW other:経験値500
RW other:同盟戦績1000ベヤルド
LK quest:クエスト「森の帳に潜む罠」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Velkkovert_Operations;Zaffeld J-8。Congregation Site はシルダス洞窟 E-7、Rocky Outcrop はドーの門 G-8。倒すヴェルクは Rocky Outcrop の西のものだけ
g01 talk - | 東アドゥリンのZaffeldに話して受ける | Waypoint「アドゥリン城門前」が近い。依頼者はNashuだが、話すのはZaffeld。 | @東アドゥリン J-8 K-8 | T npc.257.Zaffeld
g02 examine - | シルダス洞窟MAP1(E-7)のCongregation Siteを調べる | テンキー6のあたり。 | @シルダス洞窟 E-7 #1 | T obj.270.Congregation_Site = obj:Congregation Site@シルダス洞窟 E-7 #1
g03 examine - | ドーの門MAP1(G-8)の通路のRocky Outcropを調べる | マリアミ渓谷のF.ステーションが近い。 | @ドーの門 G-8 #1 | T obj.272.Rocky_Outcrop = obj:Rocky Outcrop@ドーの門 G-8 #1
g04 defeat - | まわりのヴェルク族を5体倒す | Rocky Outcropの西にいるものだけ数える。 | @ドーの門 G-8 #1
g05 examine - | もう一度Rocky Outcropを調べて完了 | - | @ドーの門 G-8 #1 | T obj.272.Rocky_Outcrop

@ quest.adoulin.049 https://wiki.ffo.jp/html/33942.html
Q A Thirst Before Time | 幻世の渇愛 | no | T npc.257.Roskin = npc:Roskin@東アドゥリン H-8
RW item:エルデションレンズ
RW other:同盟戦績30000ベヤルド（エルデションレンズとどちらか）
RW title:最高の助手
LK quest:クエスト「渇欲のストロボ」を後日談まで終え、Roskinが図書館の本を書いている
LK quest:クエスト「メルヴィアン殺人事件」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Thirst_Before_Time;Polished Pebble は西アドゥリンのINV.ワークス J-10。Well-Kept Cache はヨルシア森林 I-10（F.ビバック#2のすぐ北）。Palomel はSCT.ワークスの向かい
g01 talk - | 東アドゥリン(H-8)のRoskinに話す | カフェ『女神の涙』のそば。 | @東アドゥリン H-8 | T npc.257.Roskin
g02 talk - | 西アドゥリンのINV.ワークス(J-10)のPolished Pebbleに話す | - | @西アドゥリン J-10 | T npc.256.Polished_Pebble = npc:Polished Pebble@西アドゥリン J-10
g03 talk - | Roskinに話す | 魔導撮像匣Ｓはなくなる。 | @東アドゥリン H-8 | T npc.257.Roskin
g04 examine - | ヨルシア森林(I-10)のWell-Kept Cacheを調べる | F.ビバック#2のすぐ北の通路。 | @ヨルシア森林 I-10 | T obj.263.Well-Kept_Cache = obj:Well-Kept Cache@ヨルシア森林 I-10
g05 defeat - | もう一度調べ、出てくるInquisitor Mortuusを倒して、だいじなもの「烏騎士制式帽子」をもらう | カウントのあとの「閃ッ！！！」の一撃はとても痛い。 | @ヨルシア森林 I-10 | T mob.263.Inquisitor_Mortuus = mob:Inquisitor Mortuus@ヨルシア森林 I-10
g06 examine - | もう一度Well-Kept Cacheを調べ、だいじなもの「失われた記録」をもらう | - | @ヨルシア森林 I-10 | T obj.263.Well-Kept_Cache
g07 go - | 東アドゥリンに入ってイベントを見る | 失われた記録は「＿」に変わる。 | @東アドゥリン
g08 talk - | Roskinに話す | - | @東アドゥリン H-8 | T npc.257.Roskin
g09 talk - | 東アドゥリン(G-9)のPalomelに話す | - | @東アドゥリン G-9 | T npc.257.Palomel
g10 talk - | Roskinに話し、報酬を選んで完了 | 報酬はあとでRoskinに渡すともう一方に替えてもらえる。烏騎士制式帽子はSCT.ワークス(F-9)のWegellionに渡すと、高純度ベヤルド3個と経験値10000ももらえる（しなくてもよい）。 | @東アドゥリン H-8 | T npc.257.Roskin

@ quest.adoulin.050 https://wiki.ffo.jp/html/28081.html
Q The Longest Way Round... | 心臓破りの巡回業務 | no | T npc.257.Vastran = npc:Vastran@東アドゥリン F-8
RW other:経験値1000
RW other:同盟戦績500ベヤルド
LK item:開拓者バッジを持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Longest_Way_Round...;Vastran F-8（Waypoint「PCK.ワークス」の西）。巡回する7人のマスは用語辞典と同じ
g01 talk - | 東アドゥリン(F-8)のVastranに話し、だいじなもの「道順の書かれた紙（東）」をもらう | ビッグブリッジの衛兵。 | @東アドゥリン F-8 | T npc.257.Vastran
g02 talk - | PCK.ワークスの入口(G-7)のFostaigに話す | - | @東アドゥリン G-7 | T npc.257.Fostaig = npc:Fostaig@東アドゥリン G-7
g03 talk - | ヤッセの狩り場行きの船着き場(G-5)のLamaronに話す | - | @東アドゥリン G-5 | T npc.257.Lamaron = npc:Lamaron@東アドゥリン G-5
g04 talk - | 女神像広場(G-8)のIrate Destrierに話す | - | @東アドゥリン G-8 | T npc.257.Irate_Destrier = npc:Irate Destrier@東アドゥリン G-8
g05 talk - | スヴェルドリード坂(I-7)のNhili Uvolepに話す | 風水士だと別の話になることがある。そのときは見回りの話になるまで話す。 | @東アドゥリン I-7 | T npc.257.Nhili_Uvolep
g06 talk - | アドゥリン城門前(K-9)のPloh Trishbahkに話す | - | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk = npc:Ploh Trishbahk@東アドゥリン K-9
g07 talk - | レンタルハウス前(G-11)のCunegondeに話す | - | @東アドゥリン G-11 | T npc.257.Cunegonde = npc:Cunegonde@東アドゥリン G-11
g08 talk - | SCT.ワークス(G-9)のNdah Tolohjinに話す | 順に話す。 | @東アドゥリン G-9 | T npc.257.Ndah_Tolohjin
g09 talk - | Vastranに報告して完了 | - | @東アドゥリン F-8 | T npc.257.Vastran

@ quest.adoulin.051 https://wiki.ffo.jp/html/31101.html
Q The Good, the Bad, the Clement | 悪人か善人か | no | T npc.257.Zaffeld
RW other:経験値500
RW other:同盟戦績1000ベヤルド
LK quest:クエスト「密会」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Good,_the_Bad,_the_Clement;Zaffeld J-8。Occultist Footprints はヨルシア森林の I-6 と J-6 の境目。Hostage Tent はマリアミ渓谷 G-10、Seat of Gramk-Droog は I-10
g01 talk - | 東アドゥリンのZaffeldに話して受ける | 依頼者はNashuだが、話すのはZaffeld。 | @東アドゥリン J-8 K-8 | T npc.257.Zaffeld
g02 examine - | ヨルシア森林のOccultist Footprintsを調べる | F.ステーションの北西。 | @ヨルシア森林 I-6 J-6 | T obj.263.Occultist_Footprints = obj:Occultist Footprints@ヨルシア森林 I-6 J-6
g03 examine - | マリアミ渓谷(G-10)のHostage Tentを調べる | F.ビバック#2から橋を渡り、(J-10)の洞窟へ。出たらツタを登ってヴェルクの集落を抜け、川の裏の洞窟の先。 | @マリアミ渓谷 G-10 | T obj.266.Hostage_Tent = obj:Hostage Tent@マリアミ渓谷 G-10
g04 defeat - | もう一度調べ、出てくるVelkk Sentinelを倒す | まわりのヴェルクと同じくらいの強さ。 | @マリアミ渓谷 G-10 | T mob.266.Velkk_Sentinel = mob:Velkk Sentinel@マリアミ渓谷 G-10
g05 examine - | もう一度Hostage Tentを調べる | - | @マリアミ渓谷 G-10 | T obj.266.Hostage_Tent
g06 examine - | 来た道を戻り、ヴェルクの集落(I-10)のSeat of Gramk-Droogを調べて完了 | 大きな玉座。 | @マリアミ渓谷 I-10 | T obj.266.Seat_of_Gramk-Droog

@ quest.adoulin.052 https://wiki.ffo.jp/html/28485.html
Q A Shot in the Dark | 感染する混沌 | yes | T npc.257.Pudith = npc:Pudith@東アドゥリン F-6
RW other:経験値（リミットポイント）500
RW other:同盟戦績200ベヤルド
LK quest:クエスト「這い寄る混沌」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shot_in_the_Dark;Pudith F-6。アンブリルオイルはシルダス洞窟の東の通路の Bloodmoon Umbril（4匹）か、ケイザック古戦場の Appetent Umbril（夜だけ）から
g01 talk - | 東アドゥリン(F-6)のPudithに話して受ける | 民家の前。 | @東アドゥリン F-6 | T npc.257.Pudith | > a01,b01
a01 gather - | 【シルダス洞窟】東の通路のBloodmoon Umbrilからアンブリルオイルを手に入れる | ヨルシア森林のF.ステーションから南西に入る。 | @シルダス洞窟 | T mob.270.Bloodmoon_Umbril = mob:Bloodmoon Umbril@シルダス洞窟 | R シルダス洞窟 | > g02
b01 gather - | 【ケイザック古戦場】Appetent Umbrilからアンブリルオイルを手に入れる | 夜だけ出る。 | @ケイザック古戦場 | T mob.261.Appetent_Umbril = mob:Appetent Umbril@ケイザック古戦場 | R ケイザック古戦場 | W 夜 | > g02
g02 trade - | Pudithにアンブリルオイルをトレードして完了 | もう一度受けるには「闇への抵抗IV」からやり直す。 | @東アドゥリン F-6 | T npc.257.Pudith | N アンブリルオイル*1

@ quest.adoulin.053 https://wiki.ffo.jp/html/31102.html
Q The Secret to Success | 成功の秘訣 | no | T npc.257.Behsa_Alehgo = npc:Behsa Alehgo@東アドゥリン J-7 J-8
RW other:同盟戦績1000ベヤルド
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Secret_to_Success;Behsa Alehgo は J-8（手順では J-7/J-8）。Suspicious Place は J-8 の南西のすみ、H-9 の南西のすみ、I-8 の南（Numbing Blossom の広場）
g01 talk - | 東アドゥリンのエクソシスト・プライオリーのBehsa Alehgoに話す | 依頼者はErfimiaだが、話すのはBehsa Alehgo。Waypoint「アドゥリン城門前」が近い。 | @東アドゥリン J-7 J-8 | T npc.257.Behsa_Alehgo
g02 talk - | SCT.ワークス(F-9)のWegellionに話す | 帽子を渡す選択肢が出たら、渡してからもう一度話す。 | @東アドゥリン F-9 | T npc.257.Wegellion = npc:Wegellion@東アドゥリン F-9
g03 talk - | ヨルシア森林のF.ステーション(J-8)のEmjook-Renookに話す | - | @ヨルシア森林 J-8 | T npc.263.Emjook-Renook = npc:Emjook-Renook@ヨルシア森林 J-8
g04 examine - | (J-8)のSuspicious Placeを調べる | だいじなもの「新品の開拓者バッジ」がある場所は3か所のどれか。なければ次へ。 | @ヨルシア森林 J-8 | T obj.263.Suspicious_Place_J-8 = obj:Suspicious Place@ヨルシア森林 J-8
g05 examine - | (I-8)のSuspicious Placeを調べる | Numbing Blossomのいる広場。なければ次へ。 | @ヨルシア森林 I-8 | T obj.263.Suspicious_Place_I-8 = obj:Suspicious Place@ヨルシア森林 I-8
g06 examine - | (H-9)のSuspicious Placeを調べる | F.ビバック#2が近いが、コロナイズ・レイヴを越える。 | @ヨルシア森林 H-9 | T obj.263.Suspicious_Place_H-9 = obj:Suspicious Place@ヨルシア森林 H-9
g07 talk - | Emjook-Renookに話す | - | @ヨルシア森林 J-8 | T npc.263.Emjook-Renook | K 新品の開拓者バッジ
g08 talk - | Behsa Alehgoに話して完了 | - | @東アドゥリン J-7 J-8 | T npc.257.Behsa_Alehgo

@ quest.adoulin.054 https://wiki.ffo.jp/html/28506.html
Q Open the Floodgates | 時計仕掛けのララ水道 | no | T npc.257.Risen_Hackles = npc:Risen Hackles@東アドゥリン G-6 G-7
RW other:経験値（リミットポイント）1000
RW other:同盟戦績500ベヤルド
LK fame:アドゥリンの名声ランク3
XS BG Wiki;https://www.bg-wiki.com/ffxi/Open_the_Floodgates;Risen Hackles は G-6（Waypoint「ヤッセの狩り場への渡し」のあたりを歩く）。Yeggha Dolashi はララ水道 M-6
g01 talk - | 東アドゥリンの船着き場前を歩くRisen Hacklesに話して受ける | - | @東アドゥリン G-6 G-7 | T npc.257.Risen_Hackles
g02 talk - | ララ水道(M-6)のYeggha Dolashiに話す | 東アドゥリンの入口から入る。「興醒めの騒動」を終えていると、そちらの話が先に出るので2回話す。 | @ララ水道 M-6 | T npc.258.Yeggha_Dolashi = npc:Yeggha Dolashi@ララ水道 M-6
g03 talk - | Risen Hacklesに報告して完了 | - | @東アドゥリン G-6 G-7 | T npc.257.Risen_Hackles

@ quest.adoulin.055 https://wiki.ffo.jp/html/31519.html
Q A Thirst for the Eons | 更に渇く男 | no | T npc.257.Roskin = npc:Roskin@東アドゥリン H-8
RW other:経験値2000
RW other:同盟戦績1000ベヤルド
RW other:追加報酬：うまくまとめると同盟戦績5000ベヤルド
LK quest:クエスト「渇く男」を終え、追加報酬をもらってからエリアを出入りしている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Thirst_for_the_Eons;Greebly G-6、Amaury J-11、Louisareaux は西アドゥリン F-8、シャニラの泉は H-9、Sivalda はララ水道 F-11、??? はララ水道 M-9 の北東、ウォーの門 F-8、エヌティエル水林 F-7
g01 talk - | 東アドゥリン(H-8)のRoskinに話す | パームジュースを欲しがる。 | @東アドゥリン H-8 | T npc.257.Roskin
g02 trade - | Roskinにパームジュースをトレードして受ける | 「カフェマスターのお願い」を終えた週ならそばのカフェで買える。合成品やHQでもよい。 | @東アドゥリン H-8 | T npc.257.Roskin | N パームジュース*1
g03 examine - | SCT.ワークス(F-9)の本棚の???を調べ、詩集・アドゥリンの母と研究論文「大地の怒り」をもらう | 手がかりを集める順はどれでもよい。 | @東アドゥリン F-9 | T obj.257.qqq_bookshelf = obj:???@東アドゥリン F-9
g04 talk - | 船着き場の近く(G-6)のGreeblyから、名画「神樹伝」を2000ベヤルドで買う | - | @東アドゥリン G-6 | T npc.257.Greebly = npc:Greebly@東アドゥリン G-6
g05 talk - | Runje Desaaliの近く(J-11)のAmauryに話し、ミステリアスな男をもらう | - | @東アドゥリン J-11 | T npc.257.Amaury = npc:Amaury@東アドゥリン J-11
g06 talk - | 西アドゥリン(F-8)のLouisareauxに話し、魔法国家の噂をもらう | PIO.ワークスとCOU.ワークスのあいだ。 | @西アドゥリン F-8 | T npc.256.Louisareaux = npc:Louisareaux@西アドゥリン F-8
g07 examine - | セレニア図書館のGeographyとHistoryを調べ、一夜繁茂の怪と大羊交易の記録をもらう | 「おつかいやるのん？」を終えていないともらえない。 | @セレニア図書館
g08 talk - | ララ水道のシビック・アボレタム(F-11)のSivaldaに話し、アドゥリン農産事情をもらう | 西アドゥリン(J-12)の入口から入る。 | @ララ水道 F-11 | T npc.258.Sivalda = npc:Sivalda@ララ水道 F-11
g09 examine - | ララ水道(M-9)の箱の???を調べ、ウルブカ開拓宣言とララ水道の不思議メモをもらう | 東アドゥリン(F-7)の入口から入り、南へ。 | @ララ水道 M-9 | T obj.258.qqq_box = obj:???@ララ水道 M-9
g10 gather - | ウォーの門MAP1(F-8)の???をつるはしで掘り、なぞの金属棒をもらう | コロナイズ・レイヴを避けるなら、ヨルシア森林かカミール山麓から入る。 | @ウォーの門 F-8 #1 | T obj.273.qqq_rod = obj:???@ウォーの門 F-8 #1 | N つるはし*1
g11 talk - | 西アドゥリンのINV.ワークス(J-10)のPolished Pebbleに話し、なぞの金属棒を錆びた刀にしてもらう | - | @西アドゥリン J-10 | T npc.256.Polished_Pebble = npc:Polished Pebble@西アドゥリン J-10 | K なぞの金属棒
g12 examine - | 西アドゥリンのシャニラの泉(Fontis Xanira)を調べ、スカウトワークス日報の切れ端をもらう | - | @西アドゥリン H-8 H-9 | T obj.256.Fontis_Xanira = obj:Fontis Xanira@西アドゥリン H-8 H-9
g13 talk - | SCT.ワークス(F-9)のWegellionに話す | 日報の切れ端を持って行く。 | @東アドゥリン F-9 | T npc.257.Wegellion = npc:Wegellion@東アドゥリン F-9 | K スカウトワークス日報の切れ端
g14 examine - | エヌティエル水林(F-7)の???を調べ、なぞの記述が浮き出たメモをもらう | テンキー7のあたり。F.ビバック#1の西のレイヴを越えるか、フォードで#4の島より上流へ。 | @エヌティエル水林 F-7 | T obj.262.qqq_memo = obj:???@エヌティエル水林 F-7
g15 talk - | SCT.ワークス前(G-9)のPalomelに話し、錆びた刀のことを聞いてアドゥリン古式刀にしてもらう | 詩集・アドゥリンの母となぞの記述が浮き出たメモを持って行く。メモは取られる。名画「神樹伝」の鑑定はしなくてよい。 | @東アドゥリン G-9 | T npc.257.Palomel | K 詩集・アドゥリンの母,なぞの記述が浮き出たメモ,錆びた刀
g16 talk - | Roskinに話し、情報をまとめて完了 | 大地の怒り・魔法国家の噂・一夜繁茂の怪・大羊交易の記録・ウルブカ開拓宣言を「重要」にする。 | @東アドゥリン H-8 | T npc.257.Roskin
g17 talk - | ヴァナ0時を越え、エリアを出入りしてからRoskinに話し、追加報酬をもらう | ララ水道の不思議メモは手元に残る。 | @東アドゥリン H-8 | T npc.257.Roskin

@ quest.adoulin.056 https://wiki.ffo.jp/html/28104.html
Q Wes...Eastern Waypoints, Ho! | 東アドゥリンのウェイポイント | no | T npc.257.Sharuru
RW other:経験値1000
RW other:同盟戦績500ベヤルド
RW other:3000cp
XS BG Wiki;https://www.bg-wiki.com/ffxi/Wes...Eastern_Waypoints,_Ho!;東アドゥリンの Waypoint は F-8、G-9、H-8、G-6（ヤッセの狩り場への渡し）、G-11、H-10、I-7、I-9、K-9
g01 talk - | 東アドゥリン(F-8)のSharuruに話して受ける | 先に全部調べてあれば、もう一度話すだけで完了。 | @東アドゥリン F-8 | T npc.257.Sharuru
g02 examine - | 東アドゥリンのWaypointを9つ全部調べる | F-8・G-5かG-6（ヤッセの狩り場への渡し）・G-9・G-11・H-8・H-10・I-7・I-9・K-9。 | @東アドゥリン
g03 talk - | Sharuruに報告して完了 | - | @東アドゥリン F-8 | T npc.257.Sharuru

@ quest.adoulin.057 https://wiki.ffo.jp/html/34775.html
Q In the Land of the Blind | 栄えある称号は | no | T npc.257.Behsa_Alehgo = npc:Behsa Alehgo@東アドゥリン J-7 J-8
RW item:ホミリアリ
RW other:経験値1000
RW other:同盟戦績1000ベヤルド
RW title:ピュラクモンの真実を知る者
LK quest:クエスト「輝く瞳」を終えている
LK fame:アドゥリンの名声ランク3
XS BG Wiki;https://www.bg-wiki.com/ffxi/In_the_Land_of_the_Blind;Suspicious Place はヨルシア森林 I-8 の南（Numbing Blossom の広場）。Pellucid Afflusion は澄明の池 G-6（F.ビバック#1の北西）
g01 talk - | 東アドゥリンのエクソシスト・プライオリーのBehsa Alehgoに話して受ける | - | @東アドゥリン J-7 J-8 | T npc.257.Behsa_Alehgo
g02 go - | セレニア図書館に入ってイベントを見る | - | @セレニア図書館
g03 examine - | ヨルシア森林(I-8)のSuspicious Placeを調べる | Numbing Blossomのいる広場。F.ビバック#3から行くとよい。 | @ヨルシア森林 I-8 | T obj.263.Suspicious_Place_I-8 = obj:Suspicious Place@ヨルシア森林 I-8
g04 defeat - | もう一度調べ、出てくるJovial Ahrimanを倒す | 15分で消える。負けても3分ほど待てばまた出せる。 | @ヨルシア森林 I-8 | T mob.263.Jovial_Ahriman = mob:Jovial Ahriman@ヨルシア森林 I-8
g05 examine - | もう一度Suspicious Placeを調べる | - | @ヨルシア森林 I-8 | T obj.263.Suspicious_Place_I-8
g06 examine - | 澄明の池(G-6)のPellucid Afflusionを調べて完了 | ホミリアリを捨てたら、Behsa Alehgoから10000ベヤルドでもらい直せる。 | @ヨルシア森林 G-6 | T obj.263.Pellucid_Afflusion = obj:Pellucid Afflusion@ヨルシア森林 G-6

@ quest.adoulin.058 https://wiki.ffo.jp/html/29086.html
Q Thorn in the Side | 森の帳に潜む罠 | no | T npc.257.Zaffeld
RW other:同盟戦績1000ベヤルド
LK quest:クエスト「おつかいやるのん？」を終えている
LK fame:アドゥリンの名声ランク3
XS BG Wiki;https://www.bg-wiki.com/ffxi/Thorn_in_the_Side;Zaffeld J-8。Occultist Footprints はヨルシア森林の I-6 と J-6 の境目（F.ステーションが近い）。消化液は Nashu が1つ出すので、渡すのは1つ
g01 talk - | 東アドゥリンのZaffeldに話して受ける | 依頼者はNashuだが、話すのはZaffeld。 | @東アドゥリン J-8 K-8 | T npc.257.Zaffeld
g02 examine - | ヨルシア森林のOccultist Footprintsを調べる | テンキー4のあたり。 | @ヨルシア森林 I-6 J-6 | T obj.263.Occultist_Footprints = obj:Occultist Footprints@ヨルシア森林 I-6 J-6
g03 trade - | Occultist Footprintsにスナップのつる2つとスナップの消化液1つをトレードして完了 | - | @ヨルシア森林 I-6 J-6 | T obj.263.Occultist_Footprints | N スナップのつる*2,スナップの消化液*1

@ quest.adoulin.059 https://wiki.ffo.jp/html/28103.html
Q A Thirst for the Ages | 渇く男 | no | T npc.257.Roskin = npc:Roskin@東アドゥリン H-8
RW other:同盟戦績500ベヤルド
RW other:だいじなものをもらうたびに経験値
RW other:追加報酬：正しくまとめると同盟戦績500ベヤルド
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Thirst_for_the_Ages;クリアソーダは Bernegeois（G-8）。ケイザック古戦場の ??? は E-6 と F-6 の境目（F.ビバック#2が近い）。Javolio はヤッセの狩り場 K-9、Nikkhail は西アドゥリン E-8
g01 talk - | 東アドゥリン(H-8)のRoskinに話す | クリアソーダを欲しがる。 | @東アドゥリン H-8 | T npc.257.Roskin
g02 trade - | Roskinにクリアソーダをトレードして受ける | そばのカフェのBernegeois(G-8)が125ギルで売っている。 | @東アドゥリン H-8 | T npc.257.Roskin | N クリアソーダ*1
g03 gather - | ケイザック古戦場の???をつるはしで掘り、開拓禁止令状をもらう | まわりの敵はアクティブなのでスニークを。 | @ケイザック古戦場 E-6 F-6 | T obj.261.qqq_fiat = obj:???@ケイザック古戦場 E-6 F-6 | N つるはし*1
g04 talk - | ヤッセの狩り場の船着き場(K-9)のJavolioに話し、ウルブカ海路図をもらう | - | @ヤッセの狩り場 K-9 | T npc.260.Javolio = npc:Javolio@ヤッセの狩り場 K-9
g05 examine - | 東アドゥリンのSCT.ワークス(F-9)の本棚の???を調べ、第17回同盟結成委員会議事録と詩集・アドゥリンの母をもらう | - | @東アドゥリン F-9 | T obj.257.qqq_bookshelf = obj:???@東アドゥリン F-9
g06 talk - | 西アドゥリンのPIO.ワークス(E-8)のNikkhailに話し、同盟合意書の写しをもらう | - | @西アドゥリン E-8 | T npc.256.Nikkhail = npc:Nikkhail@西アドゥリン E-8
g07 talk - | Roskinに5つを渡し、まとめて完了 | ウルブカ海路図と詩集・アドゥリンの母は「重要ではない」。最後に「はい」。 | @東アドゥリン H-8 | T npc.257.Roskin
g08 talk - | ヴァナ0時を越えてからRoskinに話し、追加報酬をもらう | - | @東アドゥリン H-8 | T npc.257.Roskin

@ quest.adoulin.060 https://wiki.ffo.jp/html/31873.html
Q A Thirst for Eternity | 渇欲のストロボ | no | T npc.257.Roskin = npc:Roskin@東アドゥリン H-8
RW other:同盟戦績8000ベヤルド
RW title:一千年の旅人
LK quest:クエスト「更に渇く男」を終えている
LK condition:アドゥリンミッションを「不死君バラモア」まで進めている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Thirst_for_Eternity;Quwi Orihbhe はラバオ G-8。Mnemonic Pool はケイザック古戦場 F-6、シルダス洞窟 H-8、ヨルシア森林 J-9、カミール山麓 G-8
g01 talk - | エリアを出入りしてから、東アドゥリン(H-8)のRoskinに話し、だいじなもの「古めかしい木箱」をもらう | - | @東アドゥリン H-8 | T npc.257.Roskin
g02 talk - | 東アドゥリン(G-9)のPalomelに話し、だいじなもの「魔導撮像匣Ｓ」をもらう | - | @東アドゥリン G-9 | T npc.257.Palomel | K 古めかしい木箱
g03 talk - | ラバオ(G-8)のQuwi Orihbheに話す | - | @ラバオ G-8 | T npc.247.Quwi_Orihbhe = npc:Quwi Orihbhe@ラバオ G-8
g04 examine - | ケイザック古戦場(F-6)のMnemonic Poolを調べ、千の光の記録をもらう | 4か所の順はどれでもよい。レイヴを避けるなら、F.ビバック#3から北へ。 | @ケイザック古戦場 F-6 | T obj.261.Mnemonic_Pool = obj:Mnemonic Pool@ケイザック古戦場 F-6
g05 examine - | ヨルシア森林(J-9)のMnemonic Poolを調べ、魔境遊撃戦の記録をもらう | わき道の行き止まり。 | @ヨルシア森林 J-9 | T obj.263.Mnemonic_Pool = obj:Mnemonic Pool@ヨルシア森林 J-9
g06 examine - | シルダス洞窟MAP1(H-8)のMnemonic Poolを調べ、中央洞窟突撃戦の記録をもらう | ヨルシア森林のF.ステーションの西から入る。壁の西側から調べられる。 | @シルダス洞窟 H-8 #1 | T obj.270.Mnemonic_Pool = obj:Mnemonic Pool@シルダス洞窟 H-8 #1
g07 examine - | カミール山麓(G-8)のMnemonic Poolを調べ、黒衣の騎士の記録をもらう | 亀裂の東側。F.ビバック#3から西へ。 | @カミール山麓 G-8 | T obj.267.Mnemonic_Pool = obj:Mnemonic Pool@カミール山麓 G-8
g08 talk - | Roskinに話して完了 | ここで完了になるが、次のクエストにはこのあとの話も要る。 | @東アドゥリン H-8 | T npc.257.Roskin
g09 talk - | Palomelに話す | ここからは後日談。 | @東アドゥリン G-9 | T npc.257.Palomel
g10 talk - | エリアを出入りしてからRoskinに話す | - | @東アドゥリン H-8 | T npc.257.Roskin
g11 examine - | セレニア図書館のHistoryを調べ、クイズで14問中12問正解して、だいじなもの「アドゥリン英雄伝の書写本」をもらう | 1問10秒ほどで時間切れ。失敗したらもう一度調べる。 | @セレニア図書館
g12 talk - | Roskinに話し、アドゥリン英雄伝の書写本を渡す | - | @東アドゥリン H-8 | T npc.257.Roskin | K アドゥリン英雄伝の書写本
g13 talk - | ヴァナ0時を越えてからRoskinに話して終わり | このあと図書館のHistoryにRoskinの本が入る。 | @東アドゥリン H-8 | T npc.257.Roskin

@ quest.adoulin.061 https://wiki.ffo.jp/html/32646.html
Q No Mercy for the Wicked | 無慈悲な冷気 | no | T npc.257.Rigobertine = npc:Rigobertine@東アドゥリン J-7 J-8
RW other:経験値4000
RW other:同盟戦績1000ベヤルド
LK condition:アドゥリンミッションを「さらなる加護」まで進めている
XS BG Wiki;https://www.bg-wiki.com/ffxi/No_Mercy_for_the_Wicked;Rigobertine は J-8（Order of Weatherspoon の外）。Ergon Locus ??? はヨルシア森林 I-8 の南（Numbing Blossom の広場）。2025年8月から茂みはなくなったらしい
g01 talk - | 東アドゥリンのエクソシスト・プライオリーのRigobertineに話す | 依頼者はIngridだが、話すのはRigobertine。 | @東アドゥリン J-7 J-8 | T npc.257.Rigobertine | > a01,b01
a01 examine - | 【I-8】PCK.ワークスの北のOscairnに近づいてから、ヨルシア森林(I-8)のErgon Locus ???を調べる | Numbing Blossomのいる広場。F.ビバック#3から。 | @ヨルシア森林 I-8 | T obj.263.Ergon_Locus_I-8 = obj:Ergon Locus ???@ヨルシア森林 I-8 | R I-8 | > g02
b01 examine - | 【G-6】PCK.ワークスの北のOscairnに近づいてから、ヨルシア森林(G-6)のSuspicious Rootsを調べる | 澄明の池のすぐそば。F.ビバック#1から。中身はどちらも同じ。 | @ヨルシア森林 G-6 | T obj.263.Suspicious_Roots | R G-6 | > g02
g02 talk - | 東アドゥリン(G-7)のOscairnに近づいて完了 | PCK.ワークスの入口から北へ。 | @東アドゥリン G-7 | T npc.257.Oscairn

@ quest.adoulin.062 https://wiki.ffo.jp/html/28505.html
Q Keep Your Bloomers On, Erisa | 眠れる果実 | no | T obj.257.Door_Research_Chamber = obj:Door:Research Chamber@東アドゥリン J-8
RW other:同盟戦績1000ベヤルド
LK item:開拓者バッジを持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Keep_Your_Bloomers_On,_Erisa;Door: Research Chamber は J-8（Waypoint「スヴェルドリード坂」のそば）。Pinetorum は F.ステーションの南 J-9 に5〜6匹。Alluring Plant はララ水道 F-10 の北のもの
g01 examine - | 東アドゥリン(J-8)のDoor:Research Chamberを調べて受ける | Melvortのすぐ横。 | @東アドゥリン J-8 | T obj.257.Door_Research_Chamber
g02 gather - | ヤッセの狩り場のPinetorumからヤッセの腐葉土を手に入れる | F.ステーションの近く。競売でも買える。 | @ヤッセの狩り場 J-9 | T mob.260.Pinetorum = mob:Pinetorum@ヤッセの狩り場 J-9
g03 trade - | Door:Research Chamberにヤッセの腐葉土をトレードする | - | @東アドゥリン J-8 | T obj.257.Door_Research_Chamber | N ヤッセの腐葉土*1
g04 examine - | ララ水道のシビック・アボレタムのAlluring Plantを調べ、だいじなもの「小さな種」をもらう | 「葉は分厚く、実は堅い皮で覆われている」と出るもの。西アドゥリン(I-12)の入口が近い。 | @ララ水道 F-10 F-11 | T obj.258.Alluring_Plant = obj:Alluring Plant@ララ水道 F-10 F-11
g05 examine - | Door:Research Chamberを調べて完了 | - | @東アドゥリン J-8 | T obj.257.Door_Research_Chamber | K 小さな種

@ quest.adoulin.063 https://wiki.ffo.jp/html/32441.html
Q Eye of the Beholder | 輝く瞳 | no | T npc.257.Behsa_Alehgo = npc:Behsa Alehgo@東アドゥリン J-7 J-8
RW other:経験値500
RW other:同盟戦績1000ベヤルド
LK quest:クエスト「成功の秘訣」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Eye_of_the_Beholder;Suspicious Place は J-8 の南西のすみ、I-8 の南、H-9 の南西のすみ
g01 talk - | 東アドゥリンのエクソシスト・プライオリーのBehsa Alehgoに話して受ける | 依頼者はErfimiaだが、話すのはBehsa Alehgo。 | @東アドゥリン J-7 J-8 | T npc.257.Behsa_Alehgo
g02 examine - | ヨルシア森林(J-8)のSuspicious Placeを調べる | F.ステーションから南へ。木のうしろ。 | @ヨルシア森林 J-8 | T obj.263.Suspicious_Place_J-8 = obj:Suspicious Place@ヨルシア森林 J-8
g03 trade - | (I-8)のSuspicious Placeに聖水12個をトレードする | Numbing Blossomのいる広場。 | @ヨルシア森林 I-8 | T obj.263.Suspicious_Place_I-8 = obj:Suspicious Place@ヨルシア森林 I-8 | N 聖水*12
g04 examine - | (H-9)のSuspicious Placeを調べて完了 | 広場を西から出て左の壁ぞいに進む。 | @ヨルシア森林 H-9 | T obj.263.Suspicious_Place_H-9 = obj:Suspicious Place@ヨルシア森林 H-9

@ quest.adoulin.064 https://wiki.ffo.jp/html/28484.html
Q A Good Pair of Crocs | 這い寄る混沌 | yes | T npc.257.Felmsy = npc:Felmsy@東アドゥリン G-5 G-6
RW other:経験値（リミットポイント）500
RW other:同盟戦績200ベヤルド
LK quest:クエスト「闇への抵抗IV」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Good_Pair_of_Crocs;Felmsy は G-6（Waypoint「ヤッセの狩り場への渡し」）。ヴェルクはエヌティエル水林のF.ビバック#3の北東の島（4匹）や、マリアミ渓谷 K-10 の下（クライムスキルとヴェルクの手袋が要る）
g01 talk - | 東アドゥリンの船着き場前のFelmsyに話して受ける | - | @東アドゥリン G-5 G-6 | T npc.257.Felmsy
g02 gather - | ヴェルク族からヴェルクの首飾りかヴェルクマスクを手に入れる | どちらでも報酬は同じ。
g03 trade - | Felmsyにヴェルクの首飾りかヴェルクマスクをトレードして完了 | もう一度受けるには「闇への抵抗IV」からやり直す。 | @東アドゥリン G-5 G-6 | T npc.257.Felmsy

@ quest.adoulin.065 https://wiki.ffo.jp/html/29079.html
Q Wayward Waypoints | 遠い友達 | no | T npc.257.Sharuru
RW other:経験値（リミットポイント）1000
RW other:同盟戦績500ベヤルド
RW other:3000cp
LK quest:クエスト「メグちゃんの病気」を終えている
LK fame:アドゥリンの名声ランク4
XS BG Wiki;https://www.bg-wiki.com/ffxi/Wayward_Waypoints;7つの F.ステーションの Waypoint を開けている必要がある。Shipilolo は西アドゥリン J-9
g01 talk - | 東アドゥリン(F-8)のSharuruに話し、だいじなもの「ウェイポイント調整キット」をもらう | - | @東アドゥリン F-8 | T npc.257.Sharuru
g02 examine - | 7つのF.ステーションのWaypointを調べる | ケイザック古戦場・ヤッセの狩り場・エヌティエル水林・モリマー台地・ヨルシア森林・マリアミ渓谷・カミール山麓。 | K ウェイポイント調整キット
g03 examine - | ジュノ下層のWaypointを調べる | うまく調整できない。 | @ジュノ下層
g04 talk - | Sharuruに話す | ジュノ下層のWaypointで飛ぶと早い。 | @東アドゥリン F-8 | T npc.257.Sharuru
g05 talk - | 西アドゥリンのINV.ワークス前のShipiloloに話し、だいじなもの「ウェイポイント微調整キット」をもらう | - | @西アドゥリン J-9 J-10 | T npc.256.Shipilolo
g06 examine - | ジュノ下層のWaypointを調べる | - | @ジュノ下層 | K ウェイポイント微調整キット
g07 talk - | Sharuruに話して完了 | - | @東アドゥリン F-8 | T npc.257.Sharuru

@ quest.adoulin.066 https://wiki.ffo.jp/html/31396.html
Q Saved by the Bell | 鈴の音色は儚く遠く | no | T npc.257.Nhili_Uvolep
RW item:ノダルワンド
LK quest:クエスト「言霊」を終えている
LK condition:すべてのワークスの評価がレジェンド
LK condition:魔導剣士のエルゴンウェポンのクエストを受けていない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Saved_by_the_Bell;Inlet of Whispers はドーの門 F-12（まわりの Apex は音で絡む）、Runje Desaali は J-11、Geosuke は J-10、Water of Whispers はドーの門 H-7
g01 talk - | 東アドゥリン(I-7)のNhili Uvolepに話し、ドーの門の話を聞く | まだオファーリストには出ない。風水士でなくてよい。 | @東アドゥリン I-7 | T npc.257.Nhili_Uvolep
g02 examine - | ドーの門MAP1(F-12)のInlet of Whispersを調べ、だいじなもの「古びた鈴」をもらう | エヌティエル水林のF.ビバック#4から(D-10)を通って入る。塩清の泉のそば。 | @ドーの門 F-12 #1 | T obj.272.Inlet_of_Whispers = obj:Inlet of Whispers@ドーの門 F-12 #1
g03 talk - | Nhili Uvolepに話す | - | @東アドゥリン I-7 | T npc.257.Nhili_Uvolep | K 古びた鈴
g04 talk - | 東アドゥリンのRunje Desaaliに話し、古びた鈴を預ける | 「クイエセンス＜裏式＞」の折れた刺突剣の柄と同時には預けられない。 | @東アドゥリン J-10 J-11 | T npc.257.Runje_Desaali | K 古びた鈴
g05 trade - | Geosukeに高純度ベヤルドを100個トレードし、だいじなもの「草紋の風水鈴」をもらう | 何回かに分けてもよい。 | @東アドゥリン J-10 | T npc.257.Geosuke = npc:Geosuke@東アドゥリン J-10 | N 高純度ベヤルド*100
g06 talk - | Nhili Uvolepに話して受ける | ここでオファーリストに出る。 | @東アドゥリン I-7 | T npc.257.Nhili_Uvolep | K 草紋の風水鈴
g07 fight - | 風水士で、ドーの門MAP1(H-7)のWater of Whispersを調べてBFに入る | 1人だけ、15分、サポートジョブなし。 | @ドーの門 H-7 #1 | T obj.272.Water_of_Whispers = obj:Water of Whispers@ドーの門 H-7 #1
g08 defeat - | Bygone Geomancerを倒す | 呼び出される羅盤を壊してHPを1まで減らしてから、とどめを刺す。 | @ヨルシア森林〔Ｕ〕 | T mob.264.Bygone_Geomancer = mob:Bygone Geomancer@ヨルシア森林〔Ｕ〕
g09 talk - | Nhili Uvolepに話して完了 | このあとRunje Desaaliにノダルワンドをトレードすると、段階的に鍛えられる。 | @東アドゥリン I-7 | T npc.257.Nhili_Uvolep

@ quest.adoulin.067 https://wiki.ffo.jp/html/29080.html
Q One Good Turn... | 開拓業務のコツ伝授 | no | T npc.257.Chelidoine = npc:Chelidoine@東アドゥリン J-9
RW other:経験値（リミットポイント）500
RW other:同盟戦績300ベヤルド
LK fame:アドゥリンの名声「あなたのお名前を、よく耳にしております。」
LK condition:どれかのワークスのワークスコールを一度終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/One_Good_Turn...;Chelidoine は J-9（Waypoint「太陽の広場」の北東）。待つのは日本時間の0時
g01 talk - | 東アドゥリン(J-9)のChelidoineに話して受ける | オファーリストには出ない。 | @東アドゥリン J-9 | T npc.257.Chelidoine
g02 talk - | 6つの問いに答える | レイヴ→他の開拓者との協力、物資運搬→ウェイポイントを使ってもよい、素材調達→競売所や他開拓者から譲ってもらっても良い、ローカス調査→上手く調べられる位置を探る、レイア・レイヴ→他の開拓者との協力、応援→対象の好みに合わせる。間違えてもすぐやり直せる。 | @東アドゥリン J-9 | T npc.257.Chelidoine
g03 talk - | 日本時間の0時を過ぎてからChelidoineに話して完了 | - | @東アドゥリン J-9 | T npc.257.Chelidoine

@ quest.adoulin.068 https://wiki.ffo.jp/html/37915.html
Q The Silent Forest | 静かなる森 | no | T npc.256.Levil = npc:Levil@西アドゥリン E-8
RW item:リゲイアサイズ
RW item:リゲイアリング
RW item:リゲイアサッシュ
RW other:10000ベヤルド
RW other:召喚獣セイレーンとの契約
RW title:大いなる自然の継承者
LK condition:アドゥリンミッション「若き指導者」を終えている
LK condition:ヴァナ・ディールの星唄第3章「すべてが星の唄となる」を終えている
LK condition:フェイス「アシェラ」を覚えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Silent_Forest;Levil は PIO.ワークス E-8。??? はエスカ-ル・オン H-10（入口の左の階段の上）。Alpine Trail はカミール山麓 H-5（F.ビバック#3から北のトンネル）。Drifting Feather は H-7
g01 talk - | 西アドゥリンのPIO.ワークス(E-8)のLevilに話す | 報酬はひとつ選ぶ。 | @西アドゥリン E-8 | T npc.256.Levil
g02 talk - | 東アドゥリン(K-9)のPloh Trishbahkに話す | ここでオファーリストに出る。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk = npc:Ploh Trishbahk@東アドゥリン K-9
g03 examine - | エスカ-ル・オン(H-10)の???を調べ、だいじなもの「力が失われた鈴」をもらう | 入口の左の階段の上。 | @エスカ-ル・オン H-10 | T obj.289.qqq_bell = obj:???@エスカ-ル・オン H-10
g04 talk - | Ploh Trishbahkに話す | - | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk
g05 examine - | カミール山麓(H-5)のAlpine Trailを調べてカミール山に入る | マップの北の真ん中。F.ビバック#3から北のトンネル。 | @カミール山麓 H-5 | T obj.267.Alpine_Trail = obj:Alpine Trail@カミール山麓 H-5 | > a01,b01,c01
a01 examine - | 【ホラの岩】ラテーヌ高原のホラの岩で、Telepointへの階段の下のErgon Locus ???を調べ、だいじなもの「なじみ深い土地の力」をもらう | 所属国に近い岩へ行く。 | @ラテーヌ高原 | T obj.102.Ergon_Locus | R ホラの岩 | > g06
b01 examine - | 【デムの岩】コンシュタット高地のデムの岩で、Telepointへの階段の下のErgon Locus ???を調べ、だいじなもの「なじみ深い土地の力」をもらう | 所属国に近い岩へ行く。 | @コンシュタット高地 | T obj.108.Ergon_Locus | R デムの岩 | > g06
c01 examine - | 【メアの岩】タロンギ大峡谷のメアの岩で、Telepointへの階段の下のErgon Locus ???を調べ、だいじなもの「なじみ深い土地の力」をもらう | 所属国に近い岩へ行く。 | @タロンギ大峡谷 | T obj.117.Ergon_Locus | R メアの岩 | > g06
g06 go - | リファーリアに入ってイベントを見る | - | @リファーリア
g07 examine - | リファーリアの北端のDrifting Featherを調べる | テンキー7と8のあいだ。力が失われた鈴となじみ深い土地の力はなくなる。 | @リファーリア H-7 H-8 | T obj.281.Drifting_Feather | K 力が失われた鈴,なじみ深い土地の力
g08 fight - | もう一度Drifting Featherを調べてBFに入る | 6人まで、30分。フェイスも呼べる。 | @リファーリア H-7 H-8 | T obj.281.Drifting_Feather
g09 defeat - | Siren Primeを倒し、報酬を選んで完了 | 2回目からは「悠久の風」になる。 | @リファーリア H-7 H-8 | T mob.281.Siren_Prime

@ quest.adoulin.069 https://wiki.ffo.jp/html/34201.html
Q A Barrel of Laughs | あるお笑いパフォーマーの笑止 | no | T obj.256.Mischief_Marker = obj:Mischief Marker@西アドゥリン J-11
RW other:経験値（リミットポイント）1000
RW title:タルタル★ソース・いっぱしマネージャー
RW item:ヒジャピアス、ゲロスピアス、アナスタジピアス、ブラーナピアスのどれか1つ（あとでPeladi Shalmohrからもらう）
LK quest:クエスト「あるチーフマネージャーの笑撃」を終え、ヴァナ0時を越えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Barrel_of_Laughs;BF の相手は Celestin・Fabioso とマネキンの Pupadi Dollmohr。倒すのはマネキンだけ。タルタル2人のどちらかが倒れると負け。ワライツボタケは /laugh のあとに草刈鎌をトレードしてとる
g01 examine - | 西アドゥリン(J-11)のMischief Markerを調べて受ける | 工房区のあたり。 | @西アドゥリン J-11 | T obj.256.Mischief_Marker
g02 examine - | すぐ左のDoor: Depositoryを調べる | - | @西アドゥリン J-11 | T obj.256.Door_Depository = obj:Door: Depository@西アドゥリン J-11
g03 examine - | ララ水道(M-6)のEntrance: Coliseumを調べる | 東アドゥリン(F-7)から入ると近い。Yeggha Dolashiのうしろの扉。 | @ララ水道 M-6 | T obj.258.Entrance_Coliseum = obj:Entrance: Coliseum@ララ水道 M-6
g04 fight - | もう一度調べてBFに入り、マネキンのPupadi Dollmohrを倒す | タルタル2人のどちらかが倒れると負け。負けたら西アドゥリン(J-5)のSauce Barrelを調べ、言われた食べ物を渡してからやり直す。 | @ララ水道 M-6 | T mob.258.Pupadi_Dollmohr = mob:Pupadi Dollmohr@ララ水道 M-6
g05 examine - | 西アドゥリン(I-8)のジャニストン家のDoor: Svenja's Manorを調べる | もう一度調べて門番と話す。 | @西アドゥリン I-8 | T obj.256.Door_Svenjas_Manor = obj:Door: Svenja's Manor@西アドゥリン I-8
g06 gather - | シィの門のHarvesting Pointに/laughをしてから草刈鎌をトレードし、だいじなもの「ワライツボタケ」をもらう | ポイントは(G-9)や(H-6)などに出る。草刈鎌は多めに。 | @シィの門 | N 草刈鎌*1
g07 examine - | 西アドゥリン(I-9)の治療院のDoor: Hospitalを調べる | - | @西アドゥリン I-9 | T obj.256.Door_Hospital = obj:Door: Hospital@西アドゥリン I-9
g08 examine - | Mischief Markerを調べて完了 | このあとMUM.ワークスのPeladi Shalmohrに話すとピアスをもらえる。 | @西アドゥリン J-11 | T obj.256.Mischief_Marker

@ quest.adoulin.070 https://wiki.ffo.jp/html/29393.html
Q All the Way to the Bank | あるチーフマネージャーの笑壁 | no | T npc.256.Peladi_Shalmohr = npc:Peladi Shalmohr@西アドゥリン G-10 G-11
RW other:経験値（リミットポイント）1000
RW title:ブリジッド系マネージャー見習い
LK quest:クエスト「あるチーフマネージャーの笑害」を終え、ヴァナ0時を越えている
LK fame:アドゥリンの名声ランク3
XS BG Wiki;https://www.bg-wiki.com/ffxi/All_the_Way_to_the_Bank;Peladi Shalmohr は G-10 と G-11 の境目。払う店と金額は用語辞典と同じで、合わせて39432ギル。帽子は5つの組から選ぶ
g01 talk - | 西アドゥリンのMUM.ワークスのPeladi Shalmohrに話し、だいじなもの「MUM.ワークス宛の請求書」をもらう | - | @西アドゥリン G-10 G-11 | T npc.256.Peladi_Shalmohr
g02 trade - | 西アドゥリン(I-8)の食堂のFlapanoに5600ギルをトレードする | 5人は好きな順で払える。 | @西アドゥリン I-8 | T npc.256.Flapano = npc:Flapano@西アドゥリン I-8 | N ギル*5600
g03 trade - | 西アドゥリン(I-11)のパン屋のDefliaaに19440ギルをトレードする | - | @西アドゥリン I-11 | T npc.256.Defliaa = npc:Defliaa@西アドゥリン I-11 | N ギル*19440
g04 trade - | 西アドゥリン(H-9)のスィーツ屋のHujetteに3000ギルをトレードする | - | @西アドゥリン H-9 | T npc.256.Hujette = npc:Hujette@西アドゥリン H-9 | N ギル*3000
g05 trade - | 東アドゥリン(G-8)のカフェ『女神の涙』のBernegeoisに4560ギルをトレードする | - | @東アドゥリン G-8 | T npc.257.Bernegeois = npc:Bernegeois@東アドゥリン G-8 | N ギル*4560
g06 trade - | 東アドゥリン(E-8)の魚介屋台のMalgromに6832ギルをトレードし、だいじなもの「MUM.ワークス宛の領収書」をもらう | - | @東アドゥリン E-8 | T npc.257.Malgrom = npc:Malgrom@東アドゥリン E-8 | N ギル*6832
g07 talk - | Peladi Shalmohrに話す | - | @西アドゥリン G-10 G-11 | T npc.256.Peladi_Shalmohr
g08 examine - | 西アドゥリン(J-11)のMischief Markerを調べ、帽子選びに5回成功して完了 | 前衛・中衛・後衛の組と、イベント・モンスターの組を交互に選ぶとよい。失敗すると食べ物を1つ求められる。 | @西アドゥリン J-11 | T obj.256.Mischief_Marker
g09 trade - | 西アドゥリン(I-5)のWesterly Breezeに草粥をトレードし、払ったギルを返してもらう | しなくてもよい。草粥で半分ほど、薬石草粥で全額。 | @西アドゥリン I-5 | T npc.256.Westerly_Breeze = npc:Westerly Breeze@西アドゥリン I-5 | N 草粥*1

@ quest.adoulin.071 https://wiki.ffo.jp/html/28511.html
Q No Laughing Matter | あるチーフマネージャーの笑害 | no | T npc.256.Peladi_Shalmohr
RW other:経験値（リミットポイント）900
RW title:タルタル★ソース・マネージャー見習い
LK other:開拓者バッジはなくてもよい
XS BG Wiki;https://www.bg-wiki.com/ffxi/No_Laughing_Matter;Peladi Shalmohr は G-10 と G-11 の境目。素材の買える店：ポポトイモは西アドゥリン I-11 の Ansegusele、オリーブオイルは西アドゥリン K-8 の Kanil
g01 talk - | 西アドゥリンのMUM.ワークスのPeladi Shalmohrに話して受ける | 話しかけると受けるまで抜けられない。 | @西アドゥリン G-10 G-11 | T npc.256.Peladi_Shalmohr
g02 examine - | 西アドゥリン(J-11)のMischief Markerを調べる | 合成に失敗すると素材がなくなるので多めに持っていく。 | @西アドゥリン J-11 | T obj.256.Mischief_Marker
g03 trade - | Mischief Markerにベークドポポトの素材をトレードする | 余計な素材は渡さなくてよい。 | @西アドゥリン J-11 | T obj.256.Mischief_Marker | N 炎のクリスタル*1,セルビナバター*1,ポポトイモ*1
g04 trade - | ダルメルステーキの素材をトレードする | - | @西アドゥリン J-11 | T obj.256.Mischief_Marker | N 炎のクリスタル*1,ブラックペッパー*1,オリーブオイル*1,ダルメルの肉*1
g05 trade - | 焼きリンゴの素材をトレードして完了 | - | @西アドゥリン J-11 | T obj.256.Mischief_Marker | N 炎のクリスタル*1,セルビナバター*1,メープルシュガー*1,シナモン*1,妖精のリンゴ*1

@ quest.adoulin.072 https://wiki.ffo.jp/html/31521.html
Q To Laugh Is to Love | あるチーフマネージャーの笑撃 | no | T npc.256.Peladi_Shalmohr
RW other:経験値（リミットポイント）1000
RW title:ラブラブウォッチャー
LK quest:クエスト「あるチーフマネージャーの笑壁」を終え、ヴァナ0時を越えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/To_Laugh_Is_to_Love;Peladi Shalmohr は G-10。Malgrom は東アドゥリン F-8 の東の端（用語辞典の別の記事では E-8）
g01 talk - | 西アドゥリン(G-10)のMUM.ワークスのPeladi Shalmohrに話して受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Peladi_Shalmohr
g02 examine - | 西アドゥリン(J-11)のMischief Markerを調べ、衣装・口説き文句・決めポーズ・プレゼントを選ぶ | 決めたらやり直せない。例：キキルンフード→手料理→ジグ→センロー風海の串焼。 | @西アドゥリン J-11 | T obj.256.Mischief_Marker
g03 gather - | 選んだプレゼントを買う | センロー風海の串焼は東アドゥリンのMalgrom、パームジュースはカフェ『女神の涙』で買える。
g04 trade - | Mischief Markerに選んだプレゼントをトレードして完了 | 組み合わせが違うと最初からやり直し。 | @西アドゥリン J-11 | T obj.256.Mischief_Marker

@ quest.adoulin.073 https://wiki.ffo.jp/html/29078.html
Q Granddaddy Dearest | じじいへの差し入れ | yes | T npc.256.Alienor = npc:Alienor@西アドゥリン E-8
RW other:経験値（リミットポイント）500
RW other:同盟戦績300ベヤルド
RW other:1500cp
LK quest:ジュノのクエスト「西の国からの調査団」を終えている
LK quest:クエスト「西アドゥリンのウェイポイント」を終えている
LK fame:アドゥリンの名声ランク3
XS BG Wiki;https://www.bg-wiki.com/ffxi/Granddaddy_Dearest;Alienor E-8、Anastase はル・ルデの庭 G-9。会う調査団員の場所は用語辞典と同じ
g01 talk - | 西アドゥリン(E-8)のAlienorに話し、だいじなもの「アリエノールからの差し入れ」をもらう | Waypoint「PIO.ワークス」の横。コンクエストの集計ごとにまた受けられる。 | @西アドゥリン E-8 | T npc.256.Alienor
g02 talk - | ル・ルデの庭(G-9)のAnastaseに話し、だいじなもの「アナスタズからのお裾分け」をもらう | 会いに行く調査団員はそのたびに変わる。 | @ル・ルデの庭 G-9 | T npc.243.Anastase = npc:Anastase@ル・ルデの庭 G-9 | > a01,b01,c01,d01
a01 talk - | 【セルビナ】セルビナ(G-10)のJilliaにお裾分けを渡す | - | @セルビナ G-10 | T npc.248.Jillia = npc:Jillia@セルビナ G-10 | R セルビナ | > g03
b01 talk - | 【マウラ】マウラ(I-8)のZurko-Bazurkoにお裾分けを渡す | 何度か話す必要があることがある。 | @マウラ I-8 | T npc.249.Zurko-Bazurko = npc:Zurko-Bazurko@マウラ I-8 | R マウラ | > g03
c01 talk - | 【ラバオ】ラバオ(G-8)のQuwi Orihbheにお裾分けを渡す | - | @ラバオ G-8 | T npc.247.Quwi_Orihbhe = npc:Quwi Orihbhe@ラバオ G-8 | R ラバオ | > g03
d01 talk - | 【ノーグ】ノーグ(G-7)のWistful Bisonにお裾分けを渡す | - | @ノーグ G-7 | T npc.252.Wistful_Bison = npc:Wistful Bison@ノーグ G-7 | R ノーグ | > g03
g03 talk - | Anastaseに話す | - | @ル・ルデの庭 G-9 | T npc.243.Anastase
g04 talk - | Alienorに話して完了 | - | @西アドゥリン E-8 | T npc.256.Alienor

@ quest.adoulin.074 https://wiki.ffo.jp/html/28486.html
Q "Always more," Quoth the Ravenous | ただの食いしん坊のごとく | no | T npc.256.Westerly_Breeze
RW other:経験値（リミットポイント）1500
RW other:同盟戦績1000ベヤルド
RW title:食いしん坊の友
LK quest:クエスト「腹が減ったはただの建前」を終え、ヴァナ日付が変わっている
LK fame:アドゥリンの名声ランク3
XS BG Wiki;https://www.bg-wiki.com/ffxi/%22Always_more,%22_Quoth_the_Ravenous;Westerly Breeze I-5
g01 talk - | 西アドゥリン(I-5)のWesterly Breezeに話して受ける | アドゥリン港。 | @西アドゥリン I-5 | T npc.256.Westerly_Breeze
g02 trade - | 呪われた飲料をトレードして完了 | ほかの飲み物は飲まれてなくなる。 | @西アドゥリン I-5 | T npc.256.Westerly_Breeze | N 呪われた飲料*1

@ quest.adoulin.075 https://wiki.ffo.jp/html/28508.html
Q A Certain Substitute Patrolman | とある衛兵の巡回業務 | no | T npc.256.Rising_Solstice = npc:Rising Solstice@西アドゥリン D-9
RW other:経験値1000
RW other:同盟戦績500ベヤルド
LK item:開拓者バッジを持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Certain_Substitute_Patrolman;巡回する7人のマスは用語辞典と同じ。それぞれ決まったせりふをくり返すまで話す（Dangueubert はモグガーデンのメニューが出るまで）
g01 talk - | 西アドゥリン(D-9)のRising Solsticeに話し、だいじなもの「道順の書かれた紙（西）」をもらう | ジョリウスの門の前。 | @西アドゥリン D-9 | T npc.256.Rising_Solstice
g02 talk - | PIO.ワークス前(E-8)のZaosoに話す | 順に話す。同じせりふになるまで話す。 | @西アドゥリン E-8 | T npc.256.Zaoso = npc:Zaoso@西アドゥリン E-8
g03 talk - | COU.ワークス前(G-8)のClemmarに話す | - | @西アドゥリン G-8 | T npc.256.Clemmar = npc:Clemmar@西アドゥリン G-8
g04 talk - | アドゥリン港(I-5)のKongrammに話す | - | @西アドゥリン I-5 | T npc.256.Kongramm = npc:Kongramm@西アドゥリン I-5
g05 talk - | 凱旋広場(H-8)のVirsaintに話す | - | @西アドゥリン H-8 | T npc.256.Virsaint = npc:Virsaint@西アドゥリン H-8
g06 talk - | INV.ワークス前(J-9)のShipiloloに話す | - | @西アドゥリン J-9 | T npc.256.Shipilolo
g07 talk - | レンタルハウス前(H-11)のDangueubertに話す | モグガーデンのメニューが出るまで話す。 | @西アドゥリン H-11 | T npc.256.Dangueubert = npc:Dangueubert@西アドゥリン H-11
g08 talk - | MUM.ワークス前(H-10)のNyleneに話す | - | @西アドゥリン H-10 | T npc.256.Nylene = npc:Nylene@西アドゥリン H-10
g09 talk - | Rising Solsticeに報告して完了 | - | @西アドゥリン D-9 | T npc.256.Rising_Solstice

@ quest.adoulin.076 https://wiki.ffo.jp/html/29094.html
Q Vegetable Vegetable Evolution | ベジタブルエボリューション | no | T obj.256.Amchuchus_Laboratory
RW item:ララブのしっぽ*12
RW other:同盟戦績2000ベヤルド
RW title:ベジタブルエボリューションヘルパー
LK quest:クエスト「ベジタブルレボリューション」を終え、ヴァナ0時を越えている
LK other:アドゥリンミッションが「リフキンを統べるもの」まで進んでいる
XS BG Wiki;https://www.bg-wiki.com/ffxi/Vegetable_Vegetable_Evolution;ヨルシア森林の ??? は I-7 と I-8 の境目近く（Ergon Locus「Bryophitic Boulder」のそば）。Numbing Blossom の広場のものではない。三国のどれかでランク4のミッション「マジックサイト」を終えている必要がある
g01 examine - | 西アドゥリン(J-10)のINV.ワークスの奥のAmchuchu's Laboratoryを調べ、「はい」を選んで受ける | - | @西アドゥリン J-10 | T obj.256.Amchuchus_Laboratory
g02 examine - | ヨルシア森林(I-8)の???を調べ、だいじなもの「ミドラスの爆薬サンプル」と「ミドラスの爆薬解説書」をもらう | テンキー8のあたり。F.ステーションから北へ。 | @ヨルシア森林 I-7 I-8 | T obj.263.Qm_Midras = obj:???@ヨルシア森林 I-7 I-8
g03 examine - | ジュノ下層(J-7)の天晶堂の入口のDoor: Neptune's Spireを調べる | - | @ジュノ下層 J-7 | T obj.245.Door_Neptunes_Spire = obj:Door: Neptune's Spire@ジュノ下層 J-7
g04 examine - | Amchuchu's Laboratoryを調べて完了 | - | @西アドゥリン J-10 | T obj.256.Amchuchus_Laboratory

@ quest.adoulin.077 https://wiki.ffo.jp/html/31520.html
Q Vegetable Vegetable Crisis | ベジタブルカリカリクライシス | no | T obj.256.Amchuchus_Laboratory
RW item:ララブのしっぽ*12
RW other:同盟戦績2000ベヤルド
RW title:INV.ワークスツカイッパー
LK quest:クエスト「ベジタブルエボリューション」を終え、ヴァナ0時を越えている
LK quest:クエスト「興醒めの騒動」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Vegetable_Vegetable_Crisis;Chanteillie が「準備ができた」と言わないときは、ヴァナ日付が変わってから戻る
g01 examine - | 西アドゥリン(J-10)のAmchuchu's Laboratoryを調べて受ける | - | @西アドゥリン J-10 | T obj.256.Amchuchus_Laboratory
g02 trade - | すぐ近くのChanteillieに素材をトレードする | どれも競売で買える。 | @西アドゥリン J-10 | T npc.256.Chanteillie = npc:Chanteillie@西アドゥリン J-10 | N ミドリウムブラス*1,ウルンダイ材*1,ラズのなめし革*1
g03 examine - | ヴァナ0時を越えてからAmchuchu's Laboratoryを調べ、だいじなもの「アムチュチュの手紙」をもらう | - | @西アドゥリン J-10 | T obj.256.Amchuchus_Laboratory | W ヴァナ0時を越えてから
g04 talk - | 大工房(H-8)のCidに話す | - | @大工房 H-8 | T npc.237.Cid = npc:Cid@大工房 H-8
g05 examine - | Amchuchu's Laboratoryを調べて完了 | - | @西アドゥリン J-10 | T obj.256.Amchuchus_Laboratory

@ quest.adoulin.078 https://wiki.ffo.jp/html/35012.html
Q Vegetable Vegetable Frustration | ベジタブルカリカリセンセーション | no | T obj.256.Amchuchus_Laboratory
RW other:同盟戦績2000ベヤルド
RW item:ミドラスヘルム+1（あとでAmchuchu's Laboratoryを調べてもらう）
LK quest:バストゥークのクエスト「常連客」を終えている
LK quest:クエスト「ベジタブルカリカリクライシス」を終え、ヴァナ0時を越えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Vegetable_Vegetable_Frustration;Raibaht は大工房 G-8、Peculiar Fissure はパルブロ鉱山 MAP3 G-8、Contemplation Site は西アドゥリン I-5。Incensed Pineapple に自爆されると失敗
g01 examine - | 西アドゥリン(J-10)のAmchuchu's Laboratoryを調べて受ける | - | @西アドゥリン J-10 | T obj.256.Amchuchus_Laboratory
g02 talk - | 大工房(G-8)のRaibahtに話す | - | @大工房 G-8 | T npc.237.Raibaht = npc:Raibaht@大工房 G-8
g03 examine - | パルブロ鉱山MAP3(G-8)のPeculiar Fissureを調べる | テンキー7のあたり。 | @パルブロ鉱山 G-8 #3 | T obj.143.Peculiar_Fissure = obj:Peculiar Fissure@パルブロ鉱山 G-8 #3
g04 talk - | Raibahtに話す | - | @大工房 G-8 | T npc.237.Raibaht
g05 examine - | 西アドゥリン(I-5)のContemplation Siteを調べる | アドゥリン港。 | @西アドゥリン I-5 | T obj.256.Contemplation_Site = obj:Contemplation Site@西アドゥリン I-5
g06 trade - | Contemplation Siteにさびき針をトレードし、だいじなもの「ミドラスお手製爆薬」をもらう | - | @西アドゥリン I-5 | T obj.256.Contemplation_Site | N さびき針*1
g07 examine - | Peculiar Fissureを調べる | - | @パルブロ鉱山 G-8 #3 | T obj.143.Peculiar_Fissure
g08 defeat - | もう一度調べ、出てくるIncensed Pineappleを自爆される前に倒す | バーサクを消すと自爆されにくい。失敗したらContemplation Siteにさびき針を渡すところからやり直す。 | @パルブロ鉱山 G-8 #3 | T mob.143.Incensed_Pineapple = mob:Incensed Pineapple@パルブロ鉱山 G-8 #3
g09 examine - | Peculiar Fissureを調べ、だいじなもの「古びた指輪」と「古びたロケット」をもらう | - | @パルブロ鉱山 G-8 #3 | T obj.143.Peculiar_Fissure
g10 talk - | Raibahtに話す | - | @大工房 G-8 | T npc.237.Raibaht
g11 examine - | Contemplation Siteを調べて完了 | このあとAmchuchu's Laboratoryを調べるとミドラスヘルム+1をもらえる。 | @西アドゥリン I-5 | T obj.256.Contemplation_Site

@ quest.adoulin.079 https://wiki.ffo.jp/html/28515.html
Q Vegetable Vegetable Revolution | ベジタブルレボリューション | no | T obj.256.Amchuchus_Laboratory
RW item:ララブのしっぽ*12
RW other:同盟戦績2000ベヤルド
RW title:ベジタブルレボリューションヘルパー
LK other:開拓者バッジはなくてもよい
XS BG Wiki;https://www.bg-wiki.com/ffxi/Vegetable_Vegetable_Revolution;Cid は大工房 H-8。シィの門へはエヌティエル水林の F.ステーションから北へ行き J-5 から入る。??? は K-8 の小さな丸い部屋
g01 examine - | 西アドゥリン(J-10)のINV.ワークスの奥のAmchuchu's Laboratoryを調べ、「はい」を選んで受ける | - | @西アドゥリン J-10 | T obj.256.Amchuchus_Laboratory
g02 examine - | シィの門MAP1(K-8)の???を調べ、だいじなもの「ミドラスのメモ」をもらう | (I-8)のコロナイズ・レイヴを越えて行く。まわりはアクティブな敵ばかり。 | @シィの門 K-8 #1 | T obj.268.Qm_Midras = obj:???@シィの門 K-8 #1
g03 talk - | 大工房2階のCidに話し、だいじなもの「シドの薬品」をもらう | - | @大工房 G-8 H-8 | T npc.237.Cid
g04 examine - | もう一度シィの門の???を調べ、だいじなもの「乳白色の鉱石」をもらう | - | @シィの門 K-8 #1 | T obj.268.Qm_Midras
g05 examine - | Amchuchu's Laboratoryを調べて完了 | - | @西アドゥリン J-10 | T obj.256.Amchuchus_Laboratory

@ quest.adoulin.080 https://wiki.ffo.jp/html/28509.html
Q The Old Man and the Harpoon | 商売道具と人助け | no | T npc.256.Jorin = npc:Jorin@西アドゥリン J-4
RW other:経験値500
RW other:同盟戦績300ベヤルド
LK item:開拓者バッジを持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Old_Man_and_the_Harpoon;Jorin J-4（Waypoint「アドゥリン港」の近く）。Shipilolo は J-9
g01 talk - | 西アドゥリン(J-4)のJorinに話し、だいじなもの「壊れたモリ」をもらう | アドゥリン港。 | @西アドゥリン J-4 | T npc.256.Jorin
g02 talk - | INV.ワークスの入口のShipiloloに話し、だいじなもの「新しいモリ」をもらう | - | @西アドゥリン J-9 J-10 | T npc.256.Shipilolo
g03 talk - | Jorinに話して完了 | - | @西アドゥリン J-4 | T npc.256.Jorin

@ quest.adoulin.081 https://wiki.ffo.jp/html/29087.html
Q Flavors of Our Lives | 幻の果実水 | no | T npc.256.Berghent = npc:Berghent@西アドゥリン J-9
RW other:経験値（リミットポイント）500
RW other:同盟戦績300ベヤルド
RW title:ドリンクエクスプローラー
XS BG Wiki;https://www.bg-wiki.com/ffxi/Flavors_of_Our_Lives;グリーンアイズベリーは、ヤッセの狩り場の Waypoint #3 の近くの採集ポイントでとるとよい
g01 talk - | 西アドゥリン(J-9)のBerghentに話して受ける | ビッグブリッジへの通り。受けてMasadの話を聞かないと、アドゥリンミッション「リフキンを統べるもの」が進まない。 | @西アドゥリン J-9 | T npc.256.Berghent
g02 talk - | MUM.ワークスの中(G-10)のMasadに話す | - | @西アドゥリン G-10 | T npc.西アドゥリン.Masad = npc:Masad@西アドゥリン G-10
g03 talk - | COU.ワークスの中(G-7)のDewaltに話す | - | @西アドゥリン G-7 | T npc.256.Dewalt
g04 talk - | ララ水道(F-11)のChalvavaに話す | モグハウス側から入ると近い。 | @ララ水道 F-11 | T npc.ララ水道.Chalvava = npc:Chalvava@ララ水道 F-11
g05 gather - | ヤッセの狩り場で草刈鎌を使い、だいじなもの「グリーンアイズベリー」をとる | 草刈鎌は多めに。 | @ヤッセの狩り場 | N 草刈鎌*1
g06 talk - | Berghentに話して完了 | - | @西アドゥリン J-9 | T npc.256.Berghent

@ quest.adoulin.082 https://wiki.ffo.jp/html/28512.html
Q Transporting | 怪しい届け物 | no | T npc.256.Vaulois = npc:Vaulois@西アドゥリン H-6
RW other:経験値1000
RW other:同盟戦績300ベヤルド
LK fame:アドゥリンの名声ランク2
XS BG Wiki;https://www.bg-wiki.com/ffxi/Transporting;Vaulois H-6、Kongramm I-5。ララ水道へは西アドゥリン F-5 から入り、C-6 の水門の入口のそばの ??? を調べる
g01 talk - | 西アドゥリン(H-6)のVauloisに話し、だいじなもの「間違えられた物資」をもらう | 飛空艇発着所への道の入口。 | @西アドゥリン H-6 | T npc.256.Vaulois
g02 talk - | アドゥリン港(I-5)のKongrammに話す | - | @西アドゥリン I-5 | T npc.256.Kongramm
g03 examine - | 西アドゥリン(F-5)からララ水道に入り、すぐ南(C-6)の???を調べて物資を置く | テンキー7のあたり。 | @ララ水道 C-6 | T obj.258.Qm_Transporting = obj:???@ララ水道 C-6
g04 talk - | Vauloisに報告して完了 | - | @西アドゥリン H-6 | T npc.256.Vaulois

@ quest.adoulin.083 https://wiki.ffo.jp/html/29081.html
Q F.A.I.L.ure Is Not an Option | 憧れの開拓者 | no | T npc.256.Clautaire = npc:Clautaire@西アドゥリン I-12
RW other:経験値（リミットポイント）1000
RW other:同盟戦績500ベヤルド
LK quest:クエスト「開拓支援の不思議な力」を終えている
LK fame:アドゥリンの名声「あなたのお名前を、よく耳にしております。」
XS BG Wiki;https://www.bg-wiki.com/ffxi/F.A.I.L.ure_Is_Not_an_Option;地層の刻まれた石はモグガーデンの鉱脈を掘ってとる。初めてのときは Green Thumb Moogle の案内を先に済ませる
g01 talk - | 西アドゥリン(I-12)のClautaireに話して受ける | テュランドー家の前。 | @西アドゥリン I-12 | T npc.256.Clautaire
g02 gather - | モグガーデンの鉱脈を掘り、だいじなもの「地層の刻まれた石」をとる | もう掘れないときは、また掘れるようになるまで待つ。
g03 talk - | Clautaireに話して完了 | - | @西アドゥリン I-12 | T npc.256.Clautaire

@ quest.adoulin.084 https://wiki.ffo.jp/html/28079.html
Q Scaredy-Cats | 深淵の森 | no | T npc.256.Eamonn = npc:Eamonn@西アドゥリン E-8
RW other:同盟戦績1000ベヤルド
RW key_item:レイヴコンビネーション
LK item:開拓者バッジを持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scaredy-Cats;Earthen Mound はケイザック古戦場 G-8 の東側（F.ビバック#2のすぐ南）。シィの門へはケイザック古戦場 E-10 から入り、E-6 の Foreboding Presence へ
g01 go - | 西アドゥリン(E-8)のPIO.ワークスに入ってイベントを見る | 断ったときは中のEamonnに話す。 | @西アドゥリン E-8 | T npc.256.Eamonn
g02 examine - | ケイザック古戦場(G-8)の東側のEarthen Moundを調べる | F.ビバック#2のすぐ南。 | @ケイザック古戦場 G-8 | T obj.261.Earthen_Mound = obj:Earthen Mound@ケイザック古戦場 G-8
g03 examine - | ケイザック古戦場(E-10)からシィの門に入り、MAP1(E-6)のForeboding Presenceを調べる | - | @シィの門 E-6 #1 | T obj.268.Foreboding_Presence = obj:Foreboding Presence@シィの門 E-6 #1
g04 defeat - | もう一度調べ、出てくるFomor Pioneerを倒す | ケアルIVやVを使う。長引くと強くなる。 | @シィの門 E-6 #1 | T mob.268.Fomor_Pioneer = mob:Fomor Pioneer@シィの門 E-6 #1
g05 examine - | Foreboding Presenceを調べ、だいじなもの「レイヴコンビネーション」をもらう | - | @シィの門 E-6 #1 | T obj.268.Foreboding_Presence
g06 go - | PIO.ワークスに入って完了 | - | @西アドゥリン E-8

@ quest.adoulin.085 https://wiki.ffo.jp/html/28299.html
Q The Starving | 腹が減ったはただの建前 | no | T npc.256.Westerly_Breeze
RW other:経験値（リミットポイント）1000
RW other:同盟戦績500ベヤルド
LK quest:クエスト「腹が減っては仕事ができぬ」を終え、ヴァナ0時を越えている
LK fame:アドゥリンの名声ランク2
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Starving;Westerly Breeze I-5
g01 talk - | 西アドゥリン(I-5)のWesterly Breezeに話して受ける | アドゥリン港。 | @西アドゥリン I-5 | T npc.256.Westerly_Breeze
g02 trade - | ゴブリンドリンクをトレードして完了 | ほかの飲み物は飲まれてなくなる。 | @西アドゥリン I-5 | T npc.256.Westerly_Breeze | N ゴブリンドリンク*1

@ quest.adoulin.086 https://wiki.ffo.jp/html/28284.html
Q Hunger Strikes | 腹が減っては仕事ができぬ | no | T npc.256.Westerly_Breeze
RW other:経験値（リミットポイント）1000
RW other:同盟戦績500ベヤルド
LK item:開拓者バッジを持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Hunger_Strikes;Westerly Breeze I-5
g01 talk - | 西アドゥリン(I-5)のWesterly Breezeに話して受ける | アドゥリン港。 | @西アドゥリン I-5 | T npc.256.Westerly_Breeze
g02 trade - | 知恵のスープをトレードして完了 | NQの石のスープでは終わらない。 | @西アドゥリン I-5 | T npc.256.Westerly_Breeze | N 知恵のスープ*1

@ quest.adoulin.087 https://wiki.ffo.jp/html/28596.html
Q Exotic Delicacies | 自慢の料理 | no | T npc.256.Flapano
RW other:経験値（リミットポイント）1000
RW other:同盟戦績500ベヤルド
RW item:フラパノパエリア
LK other:開拓者バッジはなくてもよい
XS BG Wiki;https://www.bg-wiki.com/ffxi/Exotic_Delicacies;サフランはエヌティエル水林で採集できるサフランの花3つから合成。バーナクルはララ水道のカニの甲羅から合成するか、西アドゥリンで釣る。ムセルはエヌティエル水林の隠れた浜で釣る
g01 talk - | 西アドゥリン(I-8)のFlapanoに話して受ける | 食堂。「いいえ」を選んでもエリアを出入りすればまた頼まれる。 | @西アドゥリン I-8 | T npc.256.Flapano
g02 trade - | 素材をトレードして完了 | - | @西アドゥリン I-8 | T npc.256.Flapano | N バーナクル*2,ムセル*1,サフラン*1

@ quest.adoulin.088 https://wiki.ffo.jp/html/28074.html
Q Raptor Rapture | 興醒めの騒動 | no | T npc.256.Pagnelle = npc:Pagnelle@西アドゥリン G-10
RW other:同盟戦績1000ベヤルド
LK other:開拓者バッジはなくてもよい
XS BG Wiki;https://www.bg-wiki.com/ffxi/Raptor_Rapture;ロックベリーの房はケイザック古戦場の採集ポイントでとれる（E-8とF-8・G-8とH-8の境目の三叉路、F-9 の F.ビバック#3、F-6、E-10 など）。ララ水道へは西アドゥリン J-12 から入る
g01 talk - | 西アドゥリン(G-10)のMUM.ワークスの前のPagnelleに話して受ける | - | @西アドゥリン G-10 | T npc.256.Pagnelle
g02 talk - | 西アドゥリン(H-12)のGontrainに話す | イルニーとは直接話せない。 | @西アドゥリン H-12 | T npc.256.Gontrain = npc:Gontrain@西アドゥリン H-12
g03 talk - | Pagnelleに報告する | ロックベリーを3つ頼まれる。 | @西アドゥリン G-10 | T npc.256.Pagnelle
g04 gather - | ケイザック古戦場などの採集ポイントに草刈鎌をトレードし、だいじなもの「ロックベリーの房」を3つとる | ヤッセの狩り場やエヌティエル水林でもとれる。草刈鎌は多めに。 | @ケイザック古戦場 | N 草刈鎌*1
g05 talk - | Pagnelleに報告する | - | @西アドゥリン G-10 | T npc.256.Pagnelle
g06 go - | 西アドゥリン(I-12)からララ水道に入り、シビック・アボレタムの南西のPCK.ワークス詰所(E-11)に近づく | イベントになる。 | @ララ水道 E-11
g07 talk - | Pagnelleに報告して完了 | このあとララ水道(M-6)のYeggha Dolashiに話すと後日談が見られる。 | @西アドゥリン G-10 | T npc.256.Pagnelle

@ quest.adoulin.089 https://wiki.ffo.jp/html/28110.html
Q Western Waypoints, Ho! | 西アドゥリンのウェイポイント | no | T npc.256.Alienor
RW other:経験値1000
RW other:同盟戦績500ベヤルド
RW other:3000cp
XS BG Wiki;https://www.bg-wiki.com/ffxi/Western_Waypoints,_Ho!;9つの Waypoint のマスは用語辞典と同じ
g01 talk - | 西アドゥリン(E-8)のAlienorに話して受ける | PIO.ワークスの前。 | @西アドゥリン E-8 | T npc.256.Alienor
g02 examine - | 西アドゥリンの9つのWaypointをすべて調べる | (E-8)PIO.ワークス、(F-10)競売所前、(G-10)MUM.ワークス、(H-4)飛空艇発着所前、(H-8)凱旋広場、(H-11)レンタルハウス前、(I-5)アドゥリン港、(J-9)INV.ワークス、(L-9)ビッグブリッジ前。 | @西アドゥリン
g03 talk - | Alienorに話して完了 | 調べていないWaypointがあれば教えてくれる。 | @西アドゥリン E-8 | T npc.256.Alienor

@ quest.adoulin.090 https://wiki.ffo.jp/html/28226.html
Q A Pioneer's Best (Imaginary) Friend | 開拓支援の不思議な力 | no | T npc.256.Merleg = npc:Merleg@西アドゥリン H-11
RW key_item:下町少年自警団バッジ
RW other:経験値500
RW other:同盟戦績200ベヤルド
LK item:開拓者バッジを持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Pioneer's_Best_(Imaginary)_Friend;Merleg H-11（Waypoint「レンタルハウス前」の近く）、Fleuricette D-8（Waypoint「PIO.ワークス」の近く）
g01 talk - | 西アドゥリン(H-11)のMerlegに話して受ける | アドゥリン・アリー。 | @西アドゥリン H-11 | T npc.256.Merleg
g02 talk - | 西アドゥリン(D-8)のFleuricetteに話し、イオニスをかけてもらう | 同盟戦績10ベヤルドかかる。東アドゥリン(G-6)のQuiri-Aliriでもよい。 | @西アドゥリン D-8 | T npc.256.Fleuricette = npc:Fleuricette@西アドゥリン D-8
g03 talk - | Merlegに話して完了 | イオニスがかかったまま話すと、すぐに終わる。 | @西アドゥリン H-11 | T npc.256.Merleg

@ quest.adoulin.091 https://wiki.ffo.jp/html/29085.html
Q Flowers for Svenja | よすが人 | no | T obj.256.Door_Svenjas_Manor = obj:Door: Svenja's Manor@西アドゥリン I-8
RW other:同盟戦績1000ベヤルド
XS BG Wiki;https://www.bg-wiki.com/ffxi/Flowers_for_Svenja;図書館へは東アドゥリン G-10 の Eppel-Treppel に話して入る。エヌティエル草は草刈鎌でもワークス製の鎌でもとれる。かばんを埋めておくと採集ポイントがなくなりにくい
g01 examine - | 西アドゥリン(I-8)のDoor: Svenja's Manorを調べて受ける | ジャニストン家。凱旋広場のWaypointが近い。 | @西アドゥリン I-8 | T obj.256.Door_Svenjas_Manor
g02 go - | 東アドゥリンからセレニア図書館に入ってイベントを見る | 入口はEppel-Treppelのところ。 | @東アドゥリン F-10 G-10
g03 gather - | エヌティエル水林の採集ポイントに草刈鎌をトレードし、だいじなもの「エヌティエル草」をとる | 必ずとれるわけではない。草刈鎌は多めに。 | @エヌティエル水林 | N 草刈鎌*1
g04 examine - | Door: Svenja's Manorを調べて完了 | - | @西アドゥリン I-8 | T obj.256.Door_Svenjas_Manor

@ quest.adoulin.092 https://wiki.ffo.jp/html/33028.html
Q Epiphany | エピファニー＜真意＞ | no | T npc.256.Octavernost = npc:Octavernost@西アドゥリン K-9
RW item:エリラズサーコート
LK other:メインジョブが魔導剣士
LK quest:クエスト「プリオーデイン＜天命の匣＞」を終えている
LK other:フサルク装束をもらうイベントで、Yestinobestinに「カザナルファイバー」を渡している
XS BG Wiki;https://www.bg-wiki.com/ffxi/Epiphany;Meeting Point はラ・カザナル宮外郭 M-6（Enigmatic Device のそば）。龍王ランペールの墓は H-10 の ??? から MAP2 に入り、北西の隅 E-8 の偽の壁の奥。フェ・インは G-9 で MAP2、E-7 で MAP1 に戻り G-6。Hazy Rune は Strange Apparatus のうしろ
g01 talk - | 西アドゥリン(K-9)のOctavernostに魔導剣士で話して受ける | ビッグブリッジ前。 | @西アドゥリン K-9 | T npc.256.Octavernost
g02 examine - | ラ・カザナル宮外郭MAP1(M-6)のMeeting Pointを調べ、だいじなもの「カザナルファイバーγ」をもらう | 謎の魔導器のすぐ近く。 | @ラ・カザナル宮外郭 M-6 #1 | T obj.274.Meeting_Point
g03 talk - | Octavernostに話し、コアを1つ選んでもらう | CL135の「イリダルコア【峠】」は空白の選択肢。 | @西アドゥリン K-9 | T npc.256.Octavernost | > a01,b01,c01
a01 examine - | 【CL109】龍王ランペールの墓MAP2(E-8)の謎の装置のうしろのHazy Runeを調べる | だいじなもの「イリダルコア【龍王】」を使う。(H-10)の???からMAP2へ。 | @龍王ランペールの墓 E-8 #2 | T obj.190.Hazy_Rune = obj:Hazy Rune@龍王ランペールの墓 E-8 #2 | R CL109 | > g04
b01 examine - | 【CL125】フェ・インMAP1(G-6)の謎の装置のうしろのHazy Runeを調べる | だいじなもの「イリダルコア【廃墟】」を使う。 | @フェ・イン G-6 #1 | T obj.204.Hazy_Rune = obj:Hazy Rune@フェ・イン G-6 #1 | R CL125 | > g04
c01 examine - | 【CL135】ラングモント峠の謎の装置のうしろのHazy Runeを調べる | だいじなもの「イリダルコア【峠】」を使う。魔導剣士のソロでフェイスは呼べない。 | @ラングモント峠 | T obj.166.Hazy_Rune = obj:Hazy Rune@ラングモント峠 | R CL135 | > g04
g04 defeat - | もう一度調べ、出てくるArcus Bladesを倒して、だいじなもの「アークスファイバー」をもらう | 強化を消され、曜日の属性の魔法を使う。 | T mob.Arcus_Blades = mob:Arcus Blades
g05 talk - | Octavernostに話す | - | @西アドゥリン K-9 | T npc.256.Octavernost
g06 examine - | 西アドゥリン(J-10)のAmchuchu's Laboratoryを調べる | - | @西アドゥリン J-10 | T obj.256.Amchuchus_Laboratory
g07 talk - | Octavernostに話す | - | @西アドゥリン K-9 | T npc.256.Octavernost
g08 talk - | ヴァナ0時を越えてからOctavernostに話し、エリラズサーコートをもらって完了 | ほかの部位はこのあと素材を渡して作ってもらう。 | @西アドゥリン K-9 | T npc.256.Octavernost | W ヴァナ0時を越えてから

@ quest.adoulin.093 https://wiki.ffo.jp/html/29391.html
Q The Bloodline of Zacariah | ザカライアの一族 | no | T npc.256.Sylvie = npc:Sylvie@西アドゥリン I-5
RW item:ジオミテーヌ
LK other:風水士である
LK quest:クエスト「鈴は鳴りわたる」を終え、ヴァナ日付が変わっている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Bloodline_of_Zacariah;Overgrown Grave はシルダス洞窟 M-8 と M-9 の境目（Ergon Locus の右の地面）。Nhili Uvolep は東アドゥリン I-7
g01 talk - | 西アドゥリン(I-5)のSylvieに話して受ける | アドゥリン港のWaypointのそば。 | @西アドゥリン I-5 | T npc.256.Sylvie
g02 trade - | Sylvieにアクエフの鉱石を3つトレードする | シルダス洞窟のアクエフから手に入る。 | @西アドゥリン I-5 | T npc.256.Sylvie | N アクエフの鉱石*3
g03 examine - | シルダス洞窟MAP1(M-8)のOvergrown Graveを調べる | Ergon Locus「土の地瘤」のすぐそば。コロナイズ・レイヴを越えて行く。 | @シルダス洞窟 M-8 M-9 #1 | T obj.270.Overgrown_Grave = obj:Overgrown Grave@シルダス洞窟 M-8 M-9 #1
g04 talk - | 東アドゥリン(I-7)のNhili Uvolepに話して完了 | - | @東アドゥリン I-7 | T npc.257.Nhili_Uvolep = npc:Nhili Uvolep@東アドゥリン I-7

@ quest.adoulin.094 https://wiki.ffo.jp/html/31522.html
Q Sick and Tired | 侵食 | no | T obj.256.Door_Svenjas_Manor
RW other:同盟戦績1000ベヤルド
LK quest:クエスト「淀み」を終え、エリアを出入りしてヴァナ0時を越えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Sick_and_Tired;Fritha に話す前はエヌティエル草がとれない。折れた短剣は話が少し変わるだけ
g01 examine - | 西アドゥリン(I-8)のDoor: Svenja's Manorを調べて受ける | - | @西アドゥリン I-8 | T obj.256.Door_Svenjas_Manor
g02 talk - | ヨルシア森林のF.ステーション(J-8)のEmjook-Renookに話す | - | @ヨルシア森林 J-8 | T npc.263.Emjook-Renook = npc:Emjook-Renook@ヨルシア森林 J-8
g03 talk - | エヌティエル水林のF.ステーション(J-7)のFrithaに話す | - | @エヌティエル水林 J-7 | T npc.262.Fritha = npc:Fritha@エヌティエル水林 J-7
g04 gather - | エヌティエル水林の採集ポイントに草刈鎌をトレードし、だいじなもの「エヌティエル草」をとる | 「折れた短剣」もとれることがある。必ずとれるわけではない。 | @エヌティエル水林 | N 草刈鎌*1
g05 talk - | Frithaに話す | - | @エヌティエル水林 J-7 | T npc.262.Fritha
g06 examine - | Door: Svenja's Manorを調べて完了 | - | @西アドゥリン I-8 | T obj.256.Door_Svenjas_Manor

@ quest.adoulin.095 https://wiki.ffo.jp/html/31524.html
Q Rune Fencing the Night Away | 先の剣 | no | T npc.256.Gaddiux = npc:Gaddiux@西アドゥリン J-10
RW other:ウェポンスキル「デミディエーション」
RW other:同盟戦績300ベヤルド
LK other:魔導剣士Lv99
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rune_Fencing_the_Night_Away;Gaddiux は西アドゥリン J-10（INV.ワークスのそば）
g01 talk - | 魔導剣士Lv99で西アドゥリン(J-10)のGaddiuxに話し、トライアルブレードをもらう | INV.ワークスの中。 | @西アドゥリン J-10 | T npc.256.Gaddiux
g02 defeat - | トライアルブレードを装備して敵を倒し、300ポイントためる | デミディエーションが使えるようになればたまっている。Gaddiuxにトレードすると進み具合を教えてくれる。
g03 trade - | Gaddiuxにトライアルブレードをトレードして完了 | - | @西アドゥリン J-10 | T npc.256.Gaddiux | N トライアルブレード*1

@ quest.adoulin.096 https://wiki.ffo.jp/html/33027.html
Q Treasures of the Earth | 大地の忘れ形見 | no | T npc.256.Sylvie
RW item:アジムスコート
RW other:経験値15000
LK other:メインジョブが風水士
LK quest:クエスト「言霊」を終えている
LK other:バグア装束をもらうイベントで、Wescolinaに「ソーマの結晶【ユグドラシル】」を渡している
XS BG Wiki;https://www.bg-wiki.com/ffxi/Treasures_of_the_Earth;モリマー台地の2つ目の ??? は H-6 と H-7 の境目（温泉の北西の Scalable Area を登って東、崖の張り出しの下）。テレポイントの岩はラテーヌ高原 K-8、コンシュタット高地 I-6、タロンギ大峡谷 I-6。相手は Otherworldly Rimester
g01 talk - | 西アドゥリン(I-5)のSylvieに風水士で話して受ける | 風水鈴の話になったら、もう一度話す。 | @西アドゥリン I-5 | T npc.256.Sylvie
g02 examine - | モリマー台地(J-6)のErgon Locus ???を調べる | F.ビバック#2から北東へ。 | @モリマー台地 J-6 | T obj.265.Ergon_Locus_J-6 = obj:Ergon Locus ???@モリマー台地 J-6
g03 examine - | モリマー台地(H-7)の温泉の北から崖を登って東へ行き、Ergon Locus「氷点の花」の南の下の???を調べる | F.ビバック#5から(G-6)、(H-6)のScalable Areaを使うと近い。 | @モリマー台地 H-6 H-7 | T obj.265.Qm_Treasures = obj:???@モリマー台地 H-6 H-7
g04 talk - | Sylvieに話し、結晶を1つ選んでもらう | CL135の「闇炎の結晶【メア】」は空白の選択肢。 | @西アドゥリン I-5 | T npc.256.Sylvie | > a01,b01,c01
a01 examine - | 【CL109】ラテーヌ高原のホラの岩で、テレポイントの下のErgon Locus ???を調べる | だいじなもの「突風の結晶【ホラ】」を使う。 | @ラテーヌ高原 K-8 | T obj.102.Ergon_Locus | R CL109 | > g05
b01 examine - | 【CL125】コンシュタット高地のデムの岩で、テレポイントの下のErgon Locus ???を調べる | だいじなもの「砂塵の結晶【デム】」を使う。 | @コンシュタット高地 I-6 | T obj.108.Ergon_Locus | R CL125 | > g05
c01 examine - | 【CL135】タロンギ大峡谷のメアの岩で、テレポイントの下のErgon Locus ???を調べる | だいじなもの「闇炎の結晶【メア】」を使う。風水士のソロでフェイスは呼べない。 | @タロンギ大峡谷 I-6 | T obj.117.Ergon_Locus | R CL135 | > g05
g05 defeat - | 出てくるOtherworldly Rimesterを倒し、だいじなもの「ダスターの碧布」をもらう | 物理に強いので魔法で倒す。負けたらSylvieからまた結晶をもらう。 | T mob.Otherworldly_Rimester = mob:Otherworldly Rimester
g06 talk - | Sylvieに話し、だいじなもの「アジムス製法」をもらう | - | @西アドゥリン I-5 | T npc.256.Sylvie
g07 talk - | 西アドゥリン(H-7)のWescolinaに話す | - | @西アドゥリン H-7 | T npc.256.Wescolina = npc:Wescolina@西アドゥリン H-7
g08 talk - | セルビナの織工ギルドのHelinaに話す | - | @セルビナ H-9 | T npc.248.Helina = npc:Helina@セルビナ H-9
g09 talk - | ヴァナ0時を越えてからHelinaに話し、アジムスコートをもらって完了 | ほかの部位はこのあと素材を渡して作ってもらう。 | @セルビナ H-9 | T npc.248.Helina | W ヴァナ0時を越えてから

@ quest.adoulin.097 https://wiki.ffo.jp/html/32763.html
Q Not-So-Clean Bill | 彼の日の軌跡 | no | T obj.256.Door_Svenjas_Manor
RW item:朝露の耳飾
RW other:同盟戦績1000ベヤルド
RW other:経験値（リミットポイント）1000
RW title:アドゥリンの露騎士候補
LK quest:クエスト「侵食」を終え、ヴァナ0時を越えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Not-So-Clean_Bill;Foreboding Vineprints はエヌティエル水林 J-10（F.ビバック#2の西）。朝露の耳飾をなくしたら、ヴァナ日付が変わってからDoor: Svenja's Manorを調べ、10000ベヤルドで受け取り直せる
g01 examine - | 西アドゥリン(I-8)のDoor: Svenja's Manorを調べて受ける | - | @西アドゥリン I-8 | T obj.256.Door_Svenjas_Manor
g02 talk - | モリマー台地のF.ステーション(K-10)のBorghestに話す | - | @モリマー台地 K-10 | T npc.265.Borghest = npc:Borghest@モリマー台地 K-10
g03 talk - | エヌティエル水林のF.ステーション(J-7)のFrithaに話す | - | @エヌティエル水林 J-7 | T npc.262.Fritha
g04 examine - | エヌティエル水林(J-10)のForeboding Vineprintsを調べる | F.ビバック#2のすぐ近く。 | @エヌティエル水林 J-10 | T obj.262.Foreboding_Vineprints = obj:Foreboding Vineprints@エヌティエル水林 J-10
g05 defeat - | もう一度調べ、出てくるPungent Patriciaを倒す | まわりにアクティブなクラックローがいる。死の宣告は倒せば消える。 | @エヌティエル水林 J-10 | T mob.262.Pungent_Patricia = mob:Pungent Patricia@エヌティエル水林 J-10
g06 examine - | Foreboding Vineprintsを調べる | - | @エヌティエル水林 J-10 | T obj.262.Foreboding_Vineprints
g07 examine - | 西アドゥリン(I-9)のDoor: Hospitalを調べて完了 | - | @西アドゥリン I-9 | T obj.256.Door_Hospital

@ quest.adoulin.098 https://wiki.ffo.jp/html/29730.html
Q Do Not Go Into the Light | 快気の光 | no | T obj.256.Door_Svenjas_Manor
RW other:同盟戦績1000ベヤルド
LK quest:クエスト「よすが人」を終え、エリアを出入りしてヴァナ0時を越えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Do_Not_Go_Into_the_Light;Door: Hospital は屋敷を出て左の扉（I-9）。Borghest はモリマー台地の F.ステーション
g01 examine - | 西アドゥリン(I-8)のDoor: Svenja's Manorを調べて受ける | 凱旋広場の北東。 | @西アドゥリン I-8 | T obj.256.Door_Svenjas_Manor
g02 examine - | 西アドゥリン(I-9)のDoor: Hospitalを調べる | - | @西アドゥリン I-9 | T obj.256.Door_Hospital
g03 talk - | モリマー台地のF.ステーション(K-10)のBorghestに話す | - | @モリマー台地 K-10 | T npc.265.Borghest = npc:Borghest@モリマー台地 K-10
g04 trade - | 西アドゥリン(J-10)のINV.ワークスのChanteillieに素材をトレードし、だいじなもの「特注つるはし～INV.ワークス製」をもらう | 「ベジタブルカリカリクライシス」の素材を頼まれているときは、そちらを先に渡す。 | @西アドゥリン J-10 | T npc.256.Chanteillie | N ウルンダイ材*1,ダマスクインゴット*1,炎のクリスタル*1
g05 examine - | Door: Hospitalを調べて完了 | - | @西アドゥリン I-9 | T obj.256.Door_Hospital

@ quest.adoulin.099 https://wiki.ffo.jp/html/29083.html
Q Elementary, My Dear Sylvie | 残された時間 | no | T npc.256.Sylvie
RW other:レベル上限が75になる
RW other:同盟戦績3000ベヤルド
RW title:自然の理解者
LK other:風水士Lv66以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Elementary,_My_Dear_Sylvie;Dabnorrin はモリマー台地 J-8（F.ビバック#1）。Primordial Convergence は K-6 で、入口は J-6 から。報酬はレベル上限75（「新たなる世界」を終えていればしなくてよい）
g01 talk - | 風水士Lv66以上で西アドゥリン(I-5)のSylvieに話して受ける | - | @西アドゥリン I-5 | T npc.256.Sylvie
g02 talk - | モリマー台地のF.ビバック#1(J-8)のDabnorrinに話し、だいじなもの「原初の呼び水」をもらう | - | @モリマー台地 J-8 | T npc.265.Dabnorrin = npc:Dabnorrin@モリマー台地 J-8
g03 examine - | 風水士でモリマー台地(K-6)のPrimordial Convergenceを調べ、「はい」を選ぶ | 地図にない場所。(K-6)のテンキー2〜3のあたりから東へ入る。 | @モリマー台地 K-6 | T obj.265.Primordial_Convergence = obj:Primordial Convergence@モリマー台地 K-6
g04 defeat - | 出てくるBurgeoning Flamesを倒す | ひとりで、サポートジョブなし、10分。強化は出してから。負けたらDabnorrinから呼び水をもらい直す。 | @モリマー台地 K-6 | T mob.265.Burgeoning_Flames = mob:Burgeoning Flames@モリマー台地 K-6
g05 examine - | もう一度Primordial Convergenceを調べて完了 | - | @モリマー台地 K-6 | T obj.265.Primordial_Convergence

@ quest.adoulin.100 https://wiki.ffo.jp/html/30453.html
Q Hypocritical Oath | 淀み | no | T obj.256.Door_Svenjas_Manor
RW other:同盟戦績1000ベヤルド
LK quest:クエスト「快気の光」を終え、ヴァナ0時を越えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Hypocritical_Oath;シモカブはカミール山麓やウルガラン山脈の兎が落とす。シモカブとスライムオイルはモグガーデンの Green Thumb Moogle から買えることもある
g01 examine - | 西アドゥリン(I-8)のDoor: Svenja's Manorを調べて受ける | - | @西アドゥリン I-8 | T obj.256.Door_Svenjas_Manor
g02 talk - | 東アドゥリンのSCT.ワークス(F-9)のWegellionに話す | - | @東アドゥリン F-9 | T npc.257.Wegellion = npc:Wegellion@東アドゥリン F-9
g03 trade - | Wegellionにシモカブとスライムオイルをトレードする | - | @東アドゥリン F-9 | T npc.257.Wegellion | N シモカブ*1,スライムオイル*1
g04 examine - | Door: Svenja's Manorを調べて完了 | - | @西アドゥリン I-8 | T obj.256.Door_Svenjas_Manor

@ quest.adoulin.101 https://wiki.ffo.jp/html/32440.html
Q The Weatherspoon Inquisition | 解離 | no
RW other:経験値500
RW other:同盟戦績1000ベヤルド
LK quest:クエスト「悪人か善人か」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Weatherspoon_Inquisition;Occultist Footprints は J-6 の西側。モーの門の Ergon Locus は K-6 と K-7 の境目、ドーの門は F-12 と G-12 の境目。Hiding Place はシルダス洞窟 K-7 の南東の隅
g01 go - | ケイザック古戦場から歩いて西アドゥリンに入り、イベントを見る | 依頼者はNashu。 | @西アドゥリン
g02 examine - | ヨルシア森林(J-6)のOccultist Footprintsを調べ、だいじなもの「丈夫な革袋」をもらう | F.ステーションから北へ。 | @ヨルシア森林 J-6 | T obj.263.Occultist_Footprints
g03 examine - | もう一度Occultist Footprintsを調べる | - | @ヨルシア森林 J-6 | T obj.263.Occultist_Footprints
g04 examine - | シィの門MAP1(K-7)のErgon Locus「光滴の池」を調べる | コロナイズ・レイヴを越えて行く。3か所は好きな順でよい。 | @シィの門 K-7 #1 | T obj.268.Ergon_Locus_K-7 = obj:Ergon Locus@シィの門 K-7 #1
g05 examine - | モーの門MAP1(K-6)のErgon Locus「温湿の泉」を調べる | モリマー台地のF.ステーションから南東へ。 | @モーの門 K-6 K-7 #1 | T obj.269.Ergon_Locus_K-6 = obj:Ergon Locus@モーの門 K-6 K-7 #1
g06 examine - | ドーの門MAP1(G-12)のErgon Locus「塩清の泉」を調べる | エヌティエル水林の(E-10)から入る。 | @ドーの門 F-12 G-12 #1 | T obj.272.Ergon_Locus_G-12 = obj:Ergon Locus@ドーの門 F-12 G-12 #1
g07 go - | シルダス洞窟に入ってイベントを見る | 謎の魔導器でワープしてもよい。 | @シルダス洞窟
g08 examine - | シルダス洞窟MAP1(K-7)のHiding Placeを調べて完了 | テンキー3のあたり。 | @シルダス洞窟 K-7 #1 | T obj.270.Hiding_Place = obj:Hiding Place@シルダス洞窟 K-7 #1

@ quest.adoulin.102 https://wiki.ffo.jp/html/29392.html
Q The Communion | 言霊 | no | T npc.256.Sylvie
RW item:ジオパンツ
RW title:深淵なる大風水士
LK other:風水士である
LK quest:クエスト「ザカライアの一族」を終え、ヴァナ日付が変わっている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Communion;Overgrown Grave はシルダス洞窟 M-8 と M-9 の境目。相手の Ancestral Rage は土と闇のエレメンタルで、物理に強い
g01 talk - | 西アドゥリン(I-5)のSylvieに話して受ける | - | @西アドゥリン I-5 | T npc.256.Sylvie
g02 talk - | 東アドゥリン(I-7)のNhili Uvolepに話し、だいじなもの「ライソの鈴」をもらう | ほかの話になったら、もう一度話す。 | @東アドゥリン I-7 | T npc.257.Nhili_Uvolep
g03 examine - | シルダス洞窟MAP1(M-8)のOvergrown Graveを調べる | - | @シルダス洞窟 M-8 M-9 #1 | T obj.270.Overgrown_Grave
g04 defeat - | もう一度調べ、出てくるAncestral Rageを倒す | 物理に強いので属性のダメージで。 | @シルダス洞窟 M-8 M-9 #1 | T mob.270.Ancestral_Rage = mob:Ancestral Rage@シルダス洞窟 M-8 M-9 #1
g05 examine - | Overgrown Graveを調べる | - | @シルダス洞窟 M-8 M-9 #1 | T obj.270.Overgrown_Grave
g06 talk - | Sylvieに話して完了 | - | @西アドゥリン I-5 | T npc.256.Sylvie

@ quest.adoulin.103 https://wiki.ffo.jp/html/29390.html
Q For Whom the Bell Tolls | 鈴は鳴りわたる | no | T npc.256.Sylvie
RW item:ダウザーワンド
RW item:フィリエベル
LK quest:クエスト「残された時間」を終えている
LK other:メインジョブが風水士（Lv90以上）で受ける
XS BG Wiki;https://www.bg-wiki.com/ffxi/For_Whom_the_Bell_Tolls;Vestavius はモリマー台地 K-10（F.ステーション）。Ergon Locus ??? は J-6 の北西の隅で、大きな岩の南（光っていない）。F.ビバック#2から東へ
g01 talk - | 風水士で西アドゥリン(I-5)のSylvieに話して受ける | 受けたあとはジョブを変えてよい。 | @西アドゥリン I-5 | T npc.256.Sylvie
g02 talk - | 東アドゥリン(I-7)のNhili Uvolepに話す | ほかの話になったら、もう一度話す。 | @東アドゥリン I-7 | T npc.257.Nhili_Uvolep
g03 talk - | モリマー台地のF.ステーション(K-10)のVestaviusに話す | - | @モリマー台地 K-10 | T npc.265.Vestavius = npc:Vestavius@モリマー台地 K-10
g04 examine - | モリマー台地(J-6)のErgon Locus ???を調べ、だいじなもの「銀色の羅盤」をもらう | F.ビバック#2の北東。テンキー7のあたり。 | @モリマー台地 J-6 | T obj.265.Ergon_Locus_J-6
g05 defeat - | もう一度調べ、出てくるDeranged Ameretatを倒す | 弱体のジオ系を置くと生臭い息を封じられる。夜はアンブリルが出るので昼がよい。 | @モリマー台地 J-6 | T mob.265.Deranged_Ameretat = mob:Deranged Ameretat@モリマー台地 J-6
g06 examine - | Ergon Locus ???を調べる | - | @モリマー台地 J-6 | T obj.265.Ergon_Locus_J-6
g07 talk - | Sylvieに話して完了 | - | @西アドゥリン I-5 | T npc.256.Sylvie

@ quest.adoulin.104 https://wiki.ffo.jp/html/28064.html
Q Dances with Luopans | 風水学入門 | no | T npc.256.Sylvie
RW other:風水士になれる
RW item:インデポイズン
RW item:マータレベル
RW title:見習い風水士
LK other:Lv30以上で話しかける
XS BG Wiki;https://www.bg-wiki.com/ffxi/Dances_with_Luopans;テレポイントの岩はラテーヌ高原 K-8、タロンギ大峡谷 I-6。羅盤をためる Ergon Locus はケイザック古戦場 K-10（F.ステーション）・I-8（F.ビバック#2）、ヤッセの狩り場 F-6（F.ビバック#2）
g01 talk - | Lv30以上で西アドゥリン(I-5)のSylvieに話して受ける | - | @西アドゥリン I-5 | T npc.256.Sylvie | > a01,b01,c01
a01 examine - | 【ホラの岩】ラテーヌ高原のテレポイントの下のErgon Locus ???を調べ、だいじなもの「なじみ深い土地の土」をもらう | 所属国にいちばん近い岩へ行く。 | @ラテーヌ高原 K-8 | T obj.102.Ergon_Locus | R ホラの岩 | > g02
b01 examine - | 【デムの岩】コンシュタット高地のテレポイントの下のErgon Locus ???を調べ、だいじなもの「なじみ深い土地の土」をもらう | 所属国にいちばん近い岩へ行く。 | @コンシュタット高地 I-6 | T obj.108.Ergon_Locus | R デムの岩 | > g02
c01 examine - | 【メアの岩】タロンギ大峡谷のテレポイントの下のErgon Locus ???を調べ、だいじなもの「なじみ深い土地の土」をもらう | 所属国にいちばん近い岩へ行く。 | @タロンギ大峡谷 I-6 | T obj.117.Ergon_Locus | R メアの岩 | > g02
g02 trade - | Sylvieに埋れ木をトレードし、だいじなもの「羅盤」をもらう | 土を持ったまま渡す。 | @西アドゥリン I-5 | T npc.256.Sylvie | N 埋れ木*1 | > d01,e01,f01
d01 go - | 【ケイザックK-10】ケイザック古戦場(K-10)の浅瀬の先の小島のErgon Locusでヒーリングする | 「体が熱くなった感じがする……！」と出るまで。アドゥリンからいちばん近く安全。 | @ケイザック古戦場 K-10 | T obj.261.Ergon_Locus_K-10 = obj:Ergon Locus@ケイザック古戦場 K-10 | R ケイザックK-10 | > g03
e01 go - | 【ケイザックI-8】ケイザック古戦場(I-8)の袋小路のErgon Locusでヒーリングする | F.ビバック#2から右手沿いに東へ。 | @ケイザック古戦場 I-8 | T obj.261.Ergon_Locus_I-8 = obj:Ergon Locus@ケイザック古戦場 I-8 | R ケイザックI-8 | > g03
f01 go - | 【ヤッセ】ヤッセの狩り場のErgon Locusでヒーリングする | F.ビバック#2が近い。 | @ヤッセの狩り場 F-5 F-6 | T obj.260.Ergon_Locus = obj:Ergon Locus@ヤッセの狩り場 F-5 F-6 | R ヤッセ | > g03
g03 talk - | Sylvieに報告して完了 | - | @西アドゥリン I-5 | T npc.256.Sylvie
@ quest.adoulin.105 https://wiki.ffo.jp/html/28650.html
Q Patrol: Woh Gates | 巡回警備:ウォーの門 | yes | T npc.257.Task_Delegator_Peacekeepers = npc:Task Delegator~@東アドゥリン F-7
RW other:経験値と同盟戦績 6000（コールチケット2枚で10800、3枚で14400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がマイスター以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Magnate、報酬はチケット1〜3枚で 6000/10800/14400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「巡回警備:ウォーの門」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | ウォーの門でアクエフ族を3体倒して完了 | ヨルシア森林のF.ビバック#3かカミール山麓のF.ステーションから入る。リンクに注意。範囲攻撃でまとめて倒すと1体分しか数えない。 | @ウォーの門

@ quest.adoulin.106 https://wiki.ffo.jp/html/28663.html
Q Survey: Foret de Hennetiel | 地脈調査:エヌティエル水林 | yes | T npc.257.Task_Delegator_Scouts = npc:Task Delegator~@東アドゥリン F-9
RW other:経験値と同盟戦績 1500（コールチケット2枚で2700、3枚で3600）（行き先が遠いほど上乗せ）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がパートナー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Disciple、報酬はチケット1〜3枚で 1500/2700/3600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「地脈調査:エヌティエル水林」を受ける | 距離はヴァナ時間で変わる。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | > a01,b01,c01,d01
a01 examine - | 【灯の花】エヌティエル水林(J-7)のErgon Locus「灯の花」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ステーションからいちばん近い。ボートもレイヴも要らない。 | @エヌティエル水林 J-7 K-7 | T obj.262.Ergon_Locus_J-7 = obj:Ergon Locus@エヌティエル水林 J-7 K-7 | R 灯の花 | >
b01 examine - | 【清浄の浜】エヌティエル水林(J-11)のErgon Locus「清浄の浜」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ビバック#2から。 | @エヌティエル水林 J-11 | T obj.262.Ergon_Locus | R 清浄の浜 | >
c01 examine - | 【龍の流木】エヌティエル水林(E-11)のErgon Locus「龍の流木」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ビバック#4から。報酬が高い。 | @エヌティエル水林 E-11 | T obj.262.Ergon_Locus_E-11 = obj:Ergon Locus@エヌティエル水林 E-11 | R 龍の流木 | >
d01 examine - | 【肥沃の実】エヌティエル水林(F-5)のErgon Locus「肥沃の実」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ビバック#4から。フォードスキルが要る。 | @エヌティエル水林 F-5 | T obj.262.Ergon_Locus_F-5 = obj:Ergon Locus@エヌティエル水林 F-5 | R 肥沃の実 | >

@ quest.adoulin.107 https://wiki.ffo.jp/html/28662.html
Q Support: Foret de Hennetiel | 戦線物資:エヌティエル水林 | yes | T npc.256.Task_Delegator_Couriers = npc:Task Delegator~@西アドゥリン G-7
RW other:経験値と同盟戦績 1500（コールチケット2枚で2700、3枚で3600）（行き先が遠いほど上乗せ）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がパートナー以上
LK other:エヌティエル水林のF.ステーションが建っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Disciple、報酬はチケット1〜3枚で 1500/2700/3600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「戦線物資:エヌティエル水林」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | エヌティエル水林のF.ビバックのどれかに設営物資を届けて完了 | 番号は問わない。奥のほうが報酬が高い。(I-7)のCastoff Pointからボートで#2(J-10)か#3(H-9)へ行くのが近い。#3はフォードスキルが要る。 | @エヌティエル水林

@ quest.adoulin.108 https://wiki.ffo.jp/html/28651.html
Q Provide: Foret de Hennetiel | 拠点物資:エヌティエル水林 | yes | T npc.256.Task_Delegator_Couriers
RW other:経験値と同盟戦績 1250（コールチケット2枚で2250、3枚で3000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がスタッフ以上
LK other:エヌティエル水林のF.ステーションがまだ建っていない（今はどこも建っているので受けられない）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Probationer、報酬はチケット1〜3枚で 1250/2250/3000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「拠点物資:エヌティエル水林」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | エヌティエル水林(J-7)のF.ステーション建設予定地に建築資材を届けて完了 | ケイザック古戦場(L-7)から海沿いに南へ、(H-11)からシィの門に入り、(H-11)からエヌティエル水林に出る。 | @エヌティエル水林 J-7

@ quest.adoulin.109 https://wiki.ffo.jp/html/28676.html
Q Preserve: Foret de Hennetiel | 治安維持:エヌティエル水林 | yes | T npc.257.Task_Delegator_Peacekeepers
RW other:経験値と同盟戦績 3250（コールチケット2枚で5850、3枚で7800）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がパートナー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Disciple、報酬はチケット1〜3枚で 3250/5850/7800
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「治安維持:エヌティエル水林」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | エヌティエル水林のレイア・レイヴ（魔物の巣）に加わって、巣を壊して完了 | 場所はI-7/J-7・G-7/G-8・F-8/F-9・H-10。巣を壊すと15分でまた出る。 | @エヌティエル水林

@ quest.adoulin.110 https://wiki.ffo.jp/html/28655.html
Q Deliver: Foret de Hennetiel | 資材宅配:エヌティエル水林 | yes | T npc.256.Task_Delegator_Couriers
RW other:経験値と同盟戦績 2000（コールチケット2枚で3600、3枚で4800）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がアドバイザー以上
LK other:エヌティエル水林のF.ステーションが建っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Contributor、報酬はチケット1〜3枚で 2000/3600/4800
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「資材宅配:エヌティエル水林」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | エヌティエル水林(J-7)のF.ステーションへ行き、採集資材を受け取る | ウェイポイントが通っていればすぐ。 | @エヌティエル水林 J-7
g03 talk - | Task Delegatorに採集資材を届けて完了 | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers

@ quest.adoulin.111 https://wiki.ffo.jp/html/28648.html
Q Procure: Foret de Hennetiel | 資材調達:エヌティエル水林 | yes | T npc.256.Task_Delegator_Pioneers = npc:Task Delegator~@西アドゥリン E-8
RW other:経験値と同盟戦績 2000（コールチケット2枚で3600、3枚で4800）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がパートナー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Disciple、報酬はチケット1〜3枚で 2000/3600/4800
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「資材調達:エヌティエル水林」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 gather - | エヌティエル水林の収穫ポイントで収穫して、5個とって完了 | 鎌が要る（パイオニア・ワークスのFloralieで買える）。とった物は納めなくてよいが、このエリアでとらないと数えない。 | @エヌティエル水林

@ quest.adoulin.112 https://wiki.ffo.jp/html/28649.html
Q Clear: Foret de Hennetiel | 進路確保:エヌティエル水林 | yes | T npc.256.Task_Delegator_Pioneers
RW other:経験値と同盟戦績 2500（コールチケット2枚で4500、3枚で6000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がスタッフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Probationer、報酬はチケット1〜3枚で 2500/4500/6000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「進路確保:エヌティエル水林」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 defeat - | エヌティエル水林のコロナイズ・レイヴ（道をふさぐ障害物）に加わって、障害物を壊して完了 | 場所はG-6・E-8・H-7・G-9/G-10・I-10。壊すと1時間（一部は15分）で元に戻るので、戻るのを待つか別の場所へ。 | @エヌティエル水林

@ quest.adoulin.113 https://wiki.ffo.jp/html/28666.html
Q Recover: Foret de Hennetiel | 物品捜索:エヌティエル水林 | yes | T npc.256.Task_Delegator_Mummers = npc:Task Delegator~@西アドゥリン G-10 G-11
RW other:経験値と同盟戦績 2000（コールチケット2枚で3600、3枚で4800）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がパートナー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Disciple、報酬はチケット1〜3枚で 2000/3600/4800
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「物品捜索:エヌティエル水林」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 examine - | エヌティエル水林かシィの門で、地面が光るLost Articleを探して調べて完了 | 広域スキャンに出ない。出る場所は次のどれか1つ：エヌティエル水林 D-8・E-8・F-9・H-6・H-7・J-8、シィの門 F-10・H-7・I-7・I-8・J-11。 | @エヌティエル水林

@ quest.adoulin.114 https://wiki.ffo.jp/html/28667.html
Q Research: Foret de Hennetiel | 生態研究:エヌティエル水林 | yes | T npc.256.Task_Delegator_Mummers
RW other:経験値と同盟戦績 4000（コールチケット2枚で7200、3枚で9600）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がアドバイザー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Contributor、報酬はチケット1〜3枚で 4000/7200/9600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「生態研究:エヌティエル水林」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 go - | エヌティエル水林かシィの門でクラックロー族の「サンダリングスニップ」を受けて完了 | F.ビバック#4から南へ行くと4匹いる。倒さなくてよい。回避・空蝉・盾で防ぐと数えない。 | @エヌティエル水林

@ quest.adoulin.115 https://wiki.ffo.jp/html/28668.html
Q Boost: Foret de Hennetiel | 開拓応援:エヌティエル水林 | yes | T npc.256.Task_Delegator_Mummers
RW other:経験値と同盟戦績 1750（コールチケット2枚で3150、3枚で4200）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がスタッフ以上
LK other:エヌティエル水林のF.ステーションが建っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Probationer、報酬はチケット1〜3枚で 1750/3150/4200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「開拓応援:エヌティエル水林」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 talk - | エヌティエル水林かモリマー台地のF.ステーションのStation Workerに話し、正しい向きと感情表現を選んで完了 | 正解はエリアとヴァナ時間で決まる。何度でもやり直せる。向きか表現のどちらかを当てたら固定し、もう一方を変えていく。 | @エヌティエル水林

@ quest.adoulin.116 https://wiki.ffo.jp/html/28663.html
Q Survey: Kamihr Drifts | 地脈調査:カミール山麓 | yes | T npc.257.Task_Delegator_Scouts
RW other:経験値と同盟戦績 3500（コールチケット2枚で6300、3枚で8400）（行き先が遠いほど上乗せ）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がマイスター以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Magnate、報酬はチケット1〜3枚で 3500/6300/8400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「地脈調査:カミール山麓」を受ける | 距離はヴァナ時間で変わる。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | > a01,b01,c01
a01 examine - | 【融氷の湖】カミール山麓(J-8)のErgon Locus「融氷の湖」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ステーションから。 | @カミール山麓 J-8 | T obj.267.Ergon_Locus_J-8 = obj:Ergon Locus@カミール山麓 J-8 | R 融氷の湖 | >
b01 examine - | 【光垂の柱】カミール山麓(J-11)のErgon Locus「光垂の柱」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ビバック#2から。 | @カミール山麓 J-11 | T obj.267.Ergon_Locus_J-11 = obj:Ergon Locus@カミール山麓 J-11 | R 光垂の柱 | >
c01 examine - | 【衝天の氷爪】カミール山麓(G-11)のErgon Locus「衝天の氷爪」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ビバック#2から。谷底で、(H-11)から洞窟に入る。 | @カミール山麓 G-11 | T obj.267.Ergon_Locus_G-11 = obj:Ergon Locus@カミール山麓 G-11 | R 衝天の氷爪 | >

@ quest.adoulin.117 https://wiki.ffo.jp/html/28662.html
Q Support: Kamihr Drifts | 戦線物資:カミール山麓 | yes | T npc.256.Task_Delegator_Couriers
RW other:経験値と同盟戦績 3500（コールチケット2枚で6300、3枚で8400）（行き先が遠いほど上乗せ）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がマイスター以上
LK other:カミール山麓のF.ステーションが建っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Magnate、報酬はチケット1〜3枚で 3500/6300/8400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「戦線物資:カミール山麓」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | カミール山麓のF.ビバックのどれかに設営物資を届けて完了 | 番号は問わない。奥のほうが報酬が高い。#1と#2はレイヴを避けて行ける。#3・#4はレイヴを越える。 | @カミール山麓

@ quest.adoulin.118 https://wiki.ffo.jp/html/28651.html
Q Provide: Kamihr Drifts | 拠点物資:カミール山麓 | yes | T npc.256.Task_Delegator_Couriers
RW other:経験値と同盟戦績 3500（コールチケット2枚で6300、3枚で8400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がマイスター以上
LK other:カミール山麓のF.ステーションがまだ建っていない（今はどこも建っているので受けられない）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Magnate、報酬はチケット1〜3枚で 3500/6300/8400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「拠点物資:カミール山麓」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | カミール山麓(K-10)のF.ステーション建設予定地に建築資材を届けて完了 | マリアミ渓谷から(B-5)でウォーの門、エスケプでヨルシア森林に出てからまたウォーの門を北へ。 | @カミール山麓 K-10

@ quest.adoulin.119 https://wiki.ffo.jp/html/28676.html
Q Preserve: Kamihr Drifts | 治安維持:カミール山麓 | yes | T npc.257.Task_Delegator_Peacekeepers
RW other:経験値と同盟戦績 6000（コールチケット2枚で10800、3枚で14400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がマイスター以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Magnate、報酬はチケット1〜3枚で 6000/10800/14400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「治安維持:カミール山麓」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | カミール山麓のレイア・レイヴ（魔物の巣）に加わって、巣を壊して完了 | 場所はI-11・G-10/H-10・I-8・H-7・H-6。巣を壊すと5分でまた出る。 | @カミール山麓

@ quest.adoulin.120 https://wiki.ffo.jp/html/28667.html
Q Research: Kamihr Drifts | 生態研究:カミール山麓 | yes | T npc.256.Task_Delegator_Mummers
RW other:経験値と同盟戦績 8000（コールチケット2枚で14400、3枚で19200）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がレジェンド以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Legend、報酬はチケット1〜3枚で 8000/14400/19200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「生態研究:カミール山麓」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 go - | カミール山麓でラズ族の「スイープガウジ」を受けて完了 | F.ビバック#3から南へ行くと3匹いる。倒さなくてよい。回避・空蝉・盾で防ぐと数えない。 | @カミール山麓

@ quest.adoulin.121 https://wiki.ffo.jp/html/28655.html
Q Deliver: Kamihr Drifts | 資材宅配:カミール山麓 | yes | T npc.256.Task_Delegator_Couriers
RW other:経験値と同盟戦績 4500（コールチケット2枚で8100、3枚で10800）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がレジェンド以上
LK other:カミール山麓のF.ステーションが建っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Legend、報酬はチケット1〜3枚で 4500/8100/10800
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「資材宅配:カミール山麓」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | カミール山麓(K-10)のF.ステーションへ行き、採集資材を受け取る | ウェイポイントが通っていればすぐ。 | @カミール山麓 K-10
g03 talk - | Task Delegatorに採集資材を届けて完了 | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers

@ quest.adoulin.122 https://wiki.ffo.jp/html/28648.html
Q Procure: Kamihr Drifts | 資材調達:カミール山麓 | yes | T npc.256.Task_Delegator_Pioneers
RW other:経験値と同盟戦績 4500（コールチケット2枚で8100、3枚で10800）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がマイスター以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Magnate、報酬はチケット1〜3枚で 4500/8100/10800
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「資材調達:カミール山麓」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 gather - | カミール山麓の採掘ポイントで採掘して、5個とって完了 | つるはしが要る（パイオニア・ワークスのFloralieで買える）。とった物は納めなくてよいが、このエリアでとらないと数えない。 | @カミール山麓

@ quest.adoulin.123 https://wiki.ffo.jp/html/28649.html
Q Clear: Kamihr Drifts | 進路確保:カミール山麓 | yes | T npc.256.Task_Delegator_Pioneers
RW other:経験値と同盟戦績 6000（コールチケット2枚で10800、3枚で14400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がマイスター以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Magnate、報酬はチケット1〜3枚で 6000/10800/14400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「進路確保:カミール山麓」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 defeat - | カミール山麓のコロナイズ・レイヴ（道をふさぐ障害物）に加わって、障害物を壊して完了 | 場所はH-10・I-9・G-8・F-7。壊すと1時間（一部は15分）で元に戻るので、戻るのを待つか別の場所へ。 | @カミール山麓

@ quest.adoulin.124 https://wiki.ffo.jp/html/28668.html
Q Boost: Kamihr Drifts | 開拓応援:カミール山麓 | yes | T npc.256.Task_Delegator_Mummers
RW other:経験値と同盟戦績 5000（コールチケット2枚で9000、3枚で12000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がマイスター以上
LK other:カミール山麓のF.ステーションが建っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Magnate、報酬はチケット1〜3枚で 5000/9000/12000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「開拓応援:カミール山麓」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 talk - | カミール山麓のF.ステーションのStation Workerに話し、正しい向きと感情表現を選んで完了 | 正解はエリアとヴァナ時間で決まる。何度でもやり直せる。向きか表現のどちらかを当てたら固定し、もう一方を変えていく。 | @カミール山麓

@ quest.adoulin.125 https://wiki.ffo.jp/html/28666.html
Q Recover: Kamihr Drifts | 物品捜索:カミール山麓 | yes | T npc.256.Task_Delegator_Mummers
RW other:経験値と同盟戦績 5250（コールチケット2枚で9450、3枚で12600）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がレジェンド以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Legend、報酬はチケット1〜3枚で 5250/9450/12600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「物品捜索:カミール山麓」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 examine - | カミール山麓かウォーの門で、地面が光るLost Articleを探して調べて完了 | 広域スキャンに出ない。出る場所は次のどれか1つ：カミール山麓 G-6・G-10・H-7・H-9・I-7・J-10、ウォーの門 F-7・G-7・I-6・I-9・I-12・J-6。 | @カミール山麓

@ quest.adoulin.126 https://wiki.ffo.jp/html/28676.html
Q Preserve: Ceizak Battlegrounds | 治安維持:ケイザック古戦場 | yes | T npc.257.Task_Delegator_Peacekeepers
RW other:経験値と同盟戦績 1750（コールチケット2枚で3150、3枚で4200）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がルーキー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Petitioner、報酬はチケット1〜3枚で 1750/3150/4200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「治安維持:ケイザック古戦場」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | ケイザック古戦場のレイア・レイヴ（魔物の巣）に加わって、巣を壊して完了 | 場所はE-7/F-7・F-8/F-9・H-6/H-7・H-10/H-11・J-6。巣を壊すと15分でまた出る。 | @ケイザック古戦場

@ quest.adoulin.127 https://wiki.ffo.jp/html/28663.html
Q Survey: Ceizak Battlegrounds | 地脈調査:ケイザック古戦場 | yes | T npc.257.Task_Delegator_Scouts
RW other:経験値と同盟戦績 1000（コールチケット2枚で1800、3枚で2400）（行き先が遠いほど上乗せ）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がルーキー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Petitioner、報酬はチケット1〜3枚で 1000/1800/2400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「地脈調査:ケイザック古戦場」を受ける | 距離はヴァナ時間で変わる。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | > a01,b01,c01,d01
a01 examine - | 【虫酔いの花】ケイザック古戦場(I-8)のErgon Locus「虫酔いの花」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ビバック#2から。インビジが要る。 | @ケイザック古戦場 I-8 | T obj.261.Ergon_Locus_I-8 | R 虫酔いの花 | >
b01 examine - | 【健常の島】ケイザック古戦場(K-10)のErgon Locus「健常の島」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ステーションから海岸沿い。インビジが要る。 | @ケイザック古戦場 K-10 | T obj.261.Ergon_Locus_K-10 | R 健常の島 | >
c01 examine - | 【光浴の島】ヤッセの狩り場(K-8)のErgon Locus「光浴の島」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ステーションから。フォードスキルが要る。 | @ヤッセの狩り場 K-8 | T obj.260.Ergon_Locus_K-8 = obj:Ergon Locus@ヤッセの狩り場 K-8 | R 光浴の島 | >
d01 examine - | 【不落の岩】ヤッセの狩り場(F-5)のErgon Locus「不落の岩」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ビバック#2から。インビジとスニークが要る。見破りのパノプト族が多い。 | @ヤッセの狩り場 F-5 F-6 | T obj.260.Ergon_Locus | R 不落の岩 | >

@ quest.adoulin.128 https://wiki.ffo.jp/html/28662.html
Q Support: Ceizak Battlegrounds | 戦線物資:ケイザック古戦場 | yes | T npc.256.Task_Delegator_Couriers
RW other:経験値と同盟戦績 1000（コールチケット2枚で1800、3枚で2400）（行き先が遠いほど上乗せ）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がルーキー以上
LK other:ケイザック古戦場のF.ステーションが建っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Petitioner、報酬はチケット1〜3枚で 1000/1800/2400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「戦線物資:ケイザック古戦場」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | ケイザック古戦場かヤッセの狩り場のF.ビバックのどれかに設営物資を届けて完了 | 番号は問わない。奥のほうが報酬が高い。ケイザック古戦場(H-9)とヤッセの狩り場(I-8)のF.ビバック#1が近い。 | @ケイザック古戦場

@ quest.adoulin.129 https://wiki.ffo.jp/html/28666.html
Q Recover: Ceizak Battlegrounds | 物品捜索:ケイザック古戦場 | yes | T npc.256.Task_Delegator_Mummers
RW other:経験値と同盟戦績 1500（コールチケット2枚で2700、3枚で3600）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がルーキー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Petitioner、報酬はチケット1〜3枚で 1500/2700/3600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「物品捜索:ケイザック古戦場」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 examine - | ケイザック古戦場かヤッセの狩り場で、地面が光るLost Articleを探して調べて完了 | 広域スキャンに出ない。出る場所は次のどれか1つ：ケイザック古戦場 F-7・F-10・G-8・H-6・H-8・H-10・I-11、ヤッセの狩り場 F-6・F-8・G-9・H-6・H-7・H-10・J-6。 | @ケイザック古戦場

@ quest.adoulin.130 https://wiki.ffo.jp/html/28667.html
Q Research: Ceizak Battlegrounds | 生態研究:ケイザック古戦場 | yes | T npc.256.Task_Delegator_Mummers
RW other:経験値と同盟戦績 2500（コールチケット2枚で4500、3枚で6000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がスタッフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Probationer、報酬はチケット1〜3枚で 2500/4500/6000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「生態研究:ケイザック古戦場」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 go - | ケイザック古戦場かヤッセの狩り場でチャプリ族の「サングインスラッシュ」を受けて完了 | ケイザック古戦場のF.ビバック#1のまわりに多い。倒さなくてよい。回避・空蝉・盾で防ぐと数えない。 | @ケイザック古戦場

@ quest.adoulin.131 https://wiki.ffo.jp/html/28648.html
Q Procure: Ceizak Battlegrounds | 資材調達:ケイザック古戦場 | yes | T npc.256.Task_Delegator_Pioneers
RW other:経験値と同盟戦績 1500（コールチケット2枚で2700、3枚で3600）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がルーキー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Petitioner、報酬はチケット1〜3枚で 1500/2700/3600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「資材調達:ケイザック古戦場」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 gather - | ケイザック古戦場かヤッセの狩り場の伐採ポイントで伐採して、5個とって完了 | 斧が要る（パイオニア・ワークスのFloralieで買える）。とった物は納めなくてよいが、このエリアでとらないと数えない。 | @ケイザック古戦場

@ quest.adoulin.132 https://wiki.ffo.jp/html/28649.html
Q Clear: Ceizak Battlegrounds | 進路確保:ケイザック古戦場 | yes | T npc.256.Task_Delegator_Pioneers
RW other:経験値と同盟戦績 1750（コールチケット2枚で3150、3枚で4200）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がルーキー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Petitioner、報酬はチケット1〜3枚で 1750/3150/4200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「進路確保:ケイザック古戦場」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 defeat - | ケイザック古戦場かヤッセの狩り場のコロナイズ・レイヴ（道をふさぐ障害物）に加わって、障害物を壊して完了 | 場所はF-7/G-7・G-8・G-9・I-8。ヤッセの狩り場ならH-7・H-8・J-8・G-9・I-9。壊すと1時間（一部は15分）で元に戻るので、戻るのを待つか別の場所へ。 | @ケイザック古戦場

@ quest.adoulin.133 https://wiki.ffo.jp/html/28650.html
Q Patrol: Sih Gates | 巡回警備:シィの門 | yes | T npc.257.Task_Delegator_Peacekeepers
RW other:経験値と同盟戦績 2500（コールチケット2枚で4500、3枚で6000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がスタッフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Probationer、報酬はチケット1〜3枚で 2500/4500/6000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「巡回警備:シィの門」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | シィの門でトウィザリム族を5体倒して完了 | MAP1の東側に多い。範囲攻撃でまとめて倒すと1体分しか数えない。 | @シィの門 #1

@ quest.adoulin.134 https://wiki.ffo.jp/html/28663.html
Q Survey: Sih Gates | 地脈調査:シィの門 | yes | T npc.257.Task_Delegator_Scouts
RW other:経験値と同盟戦績 1250（コールチケット2枚で2250、3枚で3000）（行き先が遠いほど上乗せ）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がスタッフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Probationer、報酬はチケット1〜3枚で 1250/2250/3000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「地脈調査:シィの門」を受ける | 距離はヴァナ時間で変わる。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | > a01,b01,c01,d01
a01 examine - | 【風の地瘤】シィの門(K-11)のErgon Locus「風の地瘤」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。エヌティエル水林のF.ステーションから北へ入り右手沿い。フォードスキルが要る。 | @シィの門 K-11 #1 | T obj.268.Ergon_Locus_K-11 = obj:Ergon Locus@シィの門 K-11 #1 | R 風の地瘤 | >
b01 examine - | 【光滴の池】シィの門(K-7)のErgon Locus「光滴の池」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。コロナイズ・レイヴを越えて行く。 | @シィの門 K-7 #1 | T obj.268.Ergon_Locus_K-7 | R 光滴の池 | >
c01 examine - | 【温湿の泉】モーの門(K-6)のErgon Locus「温湿の泉」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。モリマー台地のF.ステーションから。コロナイズ・レイヴを越えて行く。 | @モーの門 K-6 #1 | T obj.269.Ergon_Locus_K-6 | R 温湿の泉 | >
d01 examine - | 【火の地瘤】モーの門(K-10)のErgon Locus「火の地瘤」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。モリマー台地のF.ステーションから。クライムスキルが要る。見破りのパノプト族がいる。 | @モーの門 K-10 | T obj.269.Ergon_Locus_K-10 = obj:Ergon Locus@モーの門 K-10 | R 火の地瘤 | >

@ quest.adoulin.135 https://wiki.ffo.jp/html/28663.html
Q Survey: Cirdas Caverns | 地脈調査:シルダス洞窟 | yes | T npc.257.Task_Delegator_Scouts
RW other:経験値と同盟戦績 2000（コールチケット2枚で3600、3枚で4800）（行き先が遠いほど上乗せ）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がアドバイザー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Contributor、報酬はチケット1〜3枚で 2000/3600/4800
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「地脈調査:シルダス洞窟」を受ける | 距離はヴァナ時間で変わる。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | > a01,b01
a01 examine - | 【命の聖室】シルダス洞窟(E-9)のErgon Locus「命の聖室」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。謎の魔導器から。手前のコロナイズ・レイヴを越える。 | @シルダス洞窟 E-9 | T obj.270.Ergon_Locus_E-9 = obj:Ergon Locus@シルダス洞窟 E-9 | R 命の聖室 | >
b01 examine - | 【土の地瘤】シルダス洞窟(M-9)のErgon Locus「土の地瘤」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。謎の魔導器から。手前のコロナイズ・レイヴを越える。 | @シルダス洞窟 M-9 #1 | T obj.270.Ergon_Locus_M-9 = obj:Ergon Locus@シルダス洞窟 M-9 #1 | R 土の地瘤 | >

@ quest.adoulin.136 https://wiki.ffo.jp/html/28650.html
Q Patrol: Cirdas Caverns | 巡回警備:シルダス洞窟 | yes | T npc.257.Task_Delegator_Peacekeepers
RW other:経験値と同盟戦績 4250（コールチケット2枚で7650、3枚で10200）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がアーティスト以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Partner、報酬はチケット1〜3枚で 4250/7650/10200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「巡回警備:シルダス洞窟」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | シルダス洞窟でマロリス族を3体倒して完了 | (H-3)の謎の魔導器から、(F-5)の小部屋か(K-5)の三叉路が近い。2体ずつなので再ポップを待つ。MAP2のマロリスは数えない。範囲攻撃でまとめて倒すと1体分しか数えない。 | @シルダス洞窟 #1

@ quest.adoulin.137 https://wiki.ffo.jp/html/28676.html
Q Preserve: Cirdas Caverns | 治安維持:シルダス洞窟 | yes | T npc.257.Task_Delegator_Peacekeepers
RW other:経験値と同盟戦績 4000（コールチケット2枚で7200、3枚で9600）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がアドバイザー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Contributor、報酬はチケット1〜3枚で 4000/7200/9600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「治安維持:シルダス洞窟」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | シルダス洞窟のレイア・レイヴ（魔物の巣）に加わって、巣を壊して完了 | 場所はI-5・G-7・I-10・H-11。巣を壊すと15分でまた出る。 | @シルダス洞窟

@ quest.adoulin.138 https://wiki.ffo.jp/html/28648.html
Q Procure: Cirdas Caverns | 資材調達:シルダス洞窟 | yes | T npc.256.Task_Delegator_Pioneers
RW other:経験値と同盟戦績 2500（コールチケット2枚で4500、3枚で6000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がアドバイザー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Contributor、報酬はチケット1〜3枚で 2500/4500/6000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「資材調達:シルダス洞窟」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 gather - | シルダス洞窟の採掘ポイントで採掘して、5個とって完了 | つるはしが要る（パイオニア・ワークスのFloralieで買える）。とった物は納めなくてよいが、このエリアでとらないと数えない。 | @シルダス洞窟

@ quest.adoulin.139 https://wiki.ffo.jp/html/28649.html
Q Clear: Cirdas Caverns | 進路確保:シルダス洞窟 | yes | T npc.256.Task_Delegator_Pioneers
RW other:経験値と同盟戦績 4000（コールチケット2枚で7200、3枚で9600）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がアドバイザー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Contributor、報酬はチケット1〜3枚で 4000/7200/9600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「進路確保:シルダス洞窟」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 defeat - | シルダス洞窟のコロナイズ・レイヴ（道をふさぐ障害物）に加わって、障害物を壊して完了 | 場所はMAP1のI-6・I-8・F-8・J-9・H-10・F-9。壊すと1時間（一部は15分）で元に戻るので、戻るのを待つか別の場所へ。 | @シルダス洞窟

@ quest.adoulin.140 https://wiki.ffo.jp/html/28663.html
Q Survey: Dho Gates | 地脈調査:ドーの門 | yes | T npc.257.Task_Delegator_Scouts
RW other:経験値と同盟戦績 2500（コールチケット2枚で4500、3枚で6000）（行き先が遠いほど上乗せ）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がアーティスト以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Partner、報酬はチケット1〜3枚で 2500/4500/6000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「地脈調査:ドーの門」を受ける | 距離はヴァナ時間で変わる。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | > a01,b01,c01,d01
a01 examine - | 【塩清の泉】ドーの門(F-12)のErgon Locus「塩清の泉」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。エヌティエル水林のF.ビバック#4から。コロナイズ・レイヴを越える。 | @ドーの門 F-12 G-12 #1 | T obj.272.Ergon_Locus_G-12 | R 塩清の泉 | >
b01 examine - | 【水の地瘤】ドーの門(E-10)のErgon Locus「水の地瘤」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。マリアミ渓谷のF.ステーションから。クライムスキルが要る。 | @ドーの門 E-10 | T obj.272.Ergon_Locus_E-10 = obj:Ergon Locus@ドーの門 E-10 | R 水の地瘤 | >
c01 examine - | 【氷の地瘤】ウォーの門(G-11)のErgon Locus「氷の地瘤」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。マリアミ渓谷のF.ビバック#4から。レイヴとクライムスキル。 | @ウォーの門 G-11 | T obj.273.Ergon_Locus_G-11 = obj:Ergon Locus@ウォーの門 G-11 | R 氷の地瘤 | >
d01 examine - | 【静謐の氷瀑】ウォーの門(H-5)のErgon Locus「静謐の氷瀑」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。カミール山麓のF.ステーションから、レイヴなしで行ける。 | @ウォーの門 H-5 | T obj.273.Ergon_Locus_H-5 = obj:Ergon Locus@ウォーの門 H-5 | R 静謐の氷瀑 | >

@ quest.adoulin.141 https://wiki.ffo.jp/html/28650.html
Q Patrol: Dho Gates | 巡回警備:ドーの門 | yes | T npc.257.Task_Delegator_Peacekeepers
RW other:経験値と同盟戦績 4250（コールチケット2枚で7650、3枚で10200）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がアーティスト以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Partner、報酬はチケット1〜3枚で 4250/7650/10200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「巡回警備:ドーの門」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | ドーの門でエフト族を3体倒して完了 | マリアミ渓谷(M-5)から入った先。西側のクライムスキルのポイント2か所に2体ずつ。範囲攻撃でまとめて倒すと1体分しか数えない。 | @ドーの門

@ quest.adoulin.142 https://wiki.ffo.jp/html/28663.html
Q Survey: Marjami Ravine | 地脈調査:マリアミ渓谷 | yes | T npc.257.Task_Delegator_Scouts
RW other:経験値と同盟戦績 3000（コールチケット2枚で5400、3枚で7200）（行き先が遠いほど上乗せ）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がチーフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Advisor、報酬はチケット1〜3枚で 3000/5400/7200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「地脈調査:マリアミ渓谷」を受ける | 距離はヴァナ時間で変わる。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | > a01,b01,c01
a01 examine - | 【薫風の花】マリアミ渓谷(K-5)のErgon Locus「薫風の花」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ステーションから。クライムスキルが要る。 | @マリアミ渓谷 K-5 | T obj.266.Ergon_Locus_K-5 = obj:Ergon Locus@マリアミ渓谷 K-5 | R 薫風の花 | >
b01 examine - | 【飛沫の大木】マリアミ渓谷(H-11)のErgon Locus「飛沫の大木」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ビバック#2から。道が長い。報酬がいちばん高い。 | @マリアミ渓谷 H-11 | T obj.266.Ergon_Locus_H-11 = obj:Ergon Locus@マリアミ渓谷 H-11 | R 飛沫の大木 | >
c01 examine - | 【三巴の岩】マリアミ渓谷(C-8)のErgon Locus「三巴の岩」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ビバック#4から東へ、(E-6)でツタを下りる。クライムスキルが要る。 | @マリアミ渓谷 C-8 | T obj.266.Ergon_Locus_C-8 = obj:Ergon Locus@マリアミ渓谷 C-8 | R 三巴の岩 | >

@ quest.adoulin.143 https://wiki.ffo.jp/html/28662.html
Q Support: Marjami Ravine | 戦線物資:マリアミ渓谷 | yes | T npc.256.Task_Delegator_Couriers
RW other:経験値と同盟戦績 3000（コールチケット2枚で5400、3枚で7200）（行き先が遠いほど上乗せ）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がチーフ以上
LK other:マリアミ渓谷のF.ステーションが建っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Advisor、報酬はチケット1〜3枚で 3000/5400/7200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「戦線物資:マリアミ渓谷」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | マリアミ渓谷のF.ビバックのどれかに設営物資を届けて完了 | 番号は問わない。奥のほうが報酬が高い。クライムスキルがあれば、どのF.ビバックへもレイヴを越えずに行ける。 | @マリアミ渓谷

@ quest.adoulin.144 https://wiki.ffo.jp/html/28651.html
Q Provide: Marjami Ravine | 拠点物資:マリアミ渓谷 | yes | T npc.256.Task_Delegator_Couriers
RW other:経験値と同盟戦績 2500（コールチケット2枚で4500、3枚で6000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がアーティスト以上
LK other:マリアミ渓谷のF.ステーションがまだ建っていない（今はどこも建っているので受けられない）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Partner、報酬はチケット1〜3枚で 2500/4500/6000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「拠点物資:マリアミ渓谷」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | マリアミ渓谷(M-7)のF.ステーション建設予定地に建築資材を届けて完了 | エヌティエル水林(E-10)からドーの門、(F-6)からマリアミ渓谷に出る。フォードスキルが要る。 | @マリアミ渓谷 M-7

@ quest.adoulin.145 https://wiki.ffo.jp/html/28676.html
Q Preserve: Marjami Ravine | 治安維持:マリアミ渓谷 | yes | T npc.257.Task_Delegator_Peacekeepers
RW other:経験値と同盟戦績 5000（コールチケット2枚で9000、3枚で12000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がチーフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Advisor、報酬はチケット1〜3枚で 5000/9000/12000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「治安維持:マリアミ渓谷」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | マリアミ渓谷のレイア・レイヴ（魔物の巣）に加わって、巣を壊して完了 | 場所はK-12・I-8・E-10・F-7・C-7。巣を壊すと5分でまた出る。 | @マリアミ渓谷

@ quest.adoulin.146 https://wiki.ffo.jp/html/28667.html
Q Research: Marjami Ravine | 生態研究:マリアミ渓谷 | yes | T npc.256.Task_Delegator_Mummers
RW other:経験値と同盟戦績 5000（コールチケット2枚で9000、3枚で12000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がチーフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Advisor、報酬はチケット1〜3枚で 5000/9000/12000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「生態研究:マリアミ渓谷」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 go - | マリアミ渓谷でトゥルフェイア族の「モルトプルメイジ」を受けて完了 | F.ステーションから南へ行くと3匹いる。倒さなくてよい。回避・空蝉・盾で防ぐと数えない。 | @マリアミ渓谷

@ quest.adoulin.147 https://wiki.ffo.jp/html/28655.html
Q Deliver: Marjami Ravine | 資材宅配:マリアミ渓谷 | yes | T npc.256.Task_Delegator_Couriers
RW other:経験値と同盟戦績 2500（コールチケット2枚で4500、3枚で6000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がチーフ以上
LK other:マリアミ渓谷のF.ステーションが建っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Advisor、報酬はチケット1〜3枚で 2500/4500/6000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「資材宅配:マリアミ渓谷」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | マリアミ渓谷(M-7)のF.ステーションへ行き、採集資材を受け取る | ウェイポイントが通っていればすぐ。 | @マリアミ渓谷 M-7
g03 talk - | Task Delegatorに採集資材を届けて完了 | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers

@ quest.adoulin.148 https://wiki.ffo.jp/html/28648.html
Q Procure: Marjami Ravine | 資材調達:マリアミ渓谷 | yes | T npc.256.Task_Delegator_Pioneers
RW other:経験値と同盟戦績 3000（コールチケット2枚で5400、3枚で7200）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がアーティスト以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Partner、報酬はチケット1〜3枚で 3000/5400/7200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「資材調達:マリアミ渓谷」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 gather - | マリアミ渓谷の採掘ポイントで採掘して、5個とって完了 | つるはしが要る（パイオニア・ワークスのFloralieで買える）。とった物は納めなくてよいが、このエリアでとらないと数えない。 | @マリアミ渓谷

@ quest.adoulin.149 https://wiki.ffo.jp/html/28649.html
Q Clear: Marjami Ravine | 進路確保:マリアミ渓谷 | yes | T npc.256.Task_Delegator_Pioneers
RW other:経験値と同盟戦績 4250（コールチケット2枚で7650、3枚で10200）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がアーティスト以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Partner、報酬はチケット1〜3枚で 4250/7650/10200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「進路確保:マリアミ渓谷」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 defeat - | マリアミ渓谷のコロナイズ・レイヴ（道をふさぐ障害物）に加わって、障害物を壊して完了 | 場所はL-9・K-8・J-10/J-11・F-10・D-7/D-8・G-11・I-11。壊すと1時間（一部は15分）で元に戻るので、戻るのを待つか別の場所へ。 | @マリアミ渓谷

@ quest.adoulin.150 https://wiki.ffo.jp/html/28666.html
Q Recover: Marjami Ravine | 物品捜索:マリアミ渓谷 | yes | T npc.256.Task_Delegator_Mummers
RW other:経験値と同盟戦績 3000（コールチケット2枚で5400、3枚で7200）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がアーティスト以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Partner、報酬はチケット1〜3枚で 3000/5400/7200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「物品捜索:マリアミ渓谷」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 examine - | マリアミ渓谷かドーの門で、地面が光るLost Articleを探して調べて完了 | 広域スキャンに出ない。出る場所は次のどれか1つ：マリアミ渓谷 E-6・G-7・G-9・H-9・I-9・K-9・K-12、ドーの門 E-7・F-7・H-9・J-7・J-9・J-11。 | @マリアミ渓谷

@ quest.adoulin.151 https://wiki.ffo.jp/html/28668.html
Q Boost: Marjami Ravine | 開拓応援:マリアミ渓谷 | yes | T npc.256.Task_Delegator_Mummers
RW other:経験値と同盟戦績 3500（コールチケット2枚で6300、3枚で8400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がアーティスト以上
LK other:マリアミ渓谷のF.ステーションが建っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Partner、報酬はチケット1〜3枚で 3500/6300/8400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「開拓応援:マリアミ渓谷」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 talk - | マリアミ渓谷かヨルシア森林のF.ステーションのStation Workerに話し、正しい向きと感情表現を選んで完了 | 正解はエリアとヴァナ時間で決まる。何度でもやり直せる。向きか表現のどちらかを当てたら固定し、もう一方を変えていく。 | @マリアミ渓谷

@ quest.adoulin.152 https://wiki.ffo.jp/html/28663.html
Q Survey: Morimar Basalt Fields | 地脈調査:モリマー台地 | yes | T npc.257.Task_Delegator_Scouts
RW other:経験値と同盟戦績 1500（コールチケット2枚で2700、3枚で3600）（行き先が遠いほど上乗せ）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がパートナー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Disciple、報酬はチケット1〜3枚で 1500/2700/3600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「地脈調査:モリマー台地」を受ける | 距離はヴァナ時間で変わる。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | > a01,b01,c01
a01 examine - | 【雪精の木】モリマー台地(K-6)のErgon Locus「雪精の木」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ビバック#1から北東。(J-6)の南のあたりから地図にない道を東へ。 | @モリマー台地 K-6 | T obj.265.Ergon_Locus_K-6 = obj:Ergon Locus@モリマー台地 K-6 | R 雪精の木 | >
b01 examine - | 【栄華の泉】モリマー台地(E-6)のErgon Locus「栄華の泉」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ビバック#4から。フォードスキルが要る。 | @モリマー台地 E-6 | T obj.265.Ergon_Locus_E-6 = obj:Ergon Locus@モリマー台地 E-6 | R 栄華の泉 | >
c01 examine - | 【氷点の花】モリマー台地(H-6)のErgon Locus「氷点の花」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ビバック#5から。クライムスキルが要る。 | @モリマー台地 H-6 | T obj.265.Ergon_Locus_H-6 = obj:Ergon Locus@モリマー台地 H-6 | R 氷点の花 | >

@ quest.adoulin.153 https://wiki.ffo.jp/html/28662.html
Q Support: Morimar Basalt Fields | 戦線物資:モリマー台地 | yes | T npc.256.Task_Delegator_Couriers
RW other:経験値と同盟戦績 1500（コールチケット2枚で2700、3枚で3600）（行き先が遠いほど上乗せ）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がパートナー以上
LK other:モリマー台地のF.ステーションが建っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Disciple、報酬はチケット1〜3枚で 1500/2700/3600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「戦線物資:モリマー台地」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | モリマー台地のF.ビバックのどれかに設営物資を届けて完了 | 番号は問わない。奥のほうが報酬が高い。F.ステーションから右手沿いに進んだ(J-8)の#1がいちばん近い。 | @モリマー台地

@ quest.adoulin.154 https://wiki.ffo.jp/html/28651.html
Q Provide: Morimar Basalt Fields | 拠点物資:モリマー台地 | yes | T npc.256.Task_Delegator_Couriers
RW other:経験値と同盟戦績 1250（コールチケット2枚で2250、3枚で3000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がスタッフ以上
LK other:モリマー台地のF.ステーションがまだ建っていない（今はどこも建っているので受けられない）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Probationer、報酬はチケット1〜3枚で 1250/2250/3000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「拠点物資:モリマー台地」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | モリマー台地(K-10)のF.ステーション建設予定地に建築資材を届けて完了 | 東アドゥリン(G-6)から船でヤッセの狩り場へ、(H-5)からモーの門、(G-5)からモリマー台地に出る。 | @モリマー台地 K-10

@ quest.adoulin.155 https://wiki.ffo.jp/html/28676.html
Q Preserve: Morimar Basalt Fields | 治安維持:モリマー台地 | yes | T npc.257.Task_Delegator_Peacekeepers
RW other:経験値と同盟戦績 3250（コールチケット2枚で5850、3枚で7800）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がパートナー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Disciple、報酬はチケット1〜3枚で 3250/5850/7800
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「治安維持:モリマー台地」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | モリマー台地のレイア・レイヴ（魔物の巣）に加わって、巣を壊して完了 | 場所はF-6・G-7・G-9/H-9・I-7・E-9。巣を壊すと15分でまた出る。 | @モリマー台地

@ quest.adoulin.156 https://wiki.ffo.jp/html/28655.html
Q Deliver: Morimar Basalt Fields | 資材宅配:モリマー台地 | yes | T npc.256.Task_Delegator_Couriers
RW other:経験値と同盟戦績 2000（コールチケット2枚で3600、3枚で4800）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がアドバイザー以上
LK other:モリマー台地のF.ステーションが建っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Contributor、報酬はチケット1〜3枚で 2000/3600/4800
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「資材宅配:モリマー台地」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | モリマー台地(K-10)のF.ステーションへ行き、採集資材を受け取る | ウェイポイントが通っていればすぐ。 | @モリマー台地 K-10
g03 talk - | Task Delegatorに採集資材を届けて完了 | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers

@ quest.adoulin.157 https://wiki.ffo.jp/html/28648.html
Q Procure: Morimar Basalt Fields | 資材調達:モリマー台地 | yes | T npc.256.Task_Delegator_Pioneers
RW other:経験値と同盟戦績 2000（コールチケット2枚で3600、3枚で4800）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がパートナー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Disciple、報酬はチケット1〜3枚で 2000/3600/4800
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「資材調達:モリマー台地」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 gather - | モリマー台地の採掘ポイントで採掘して、5個とって完了 | つるはしが要る（パイオニア・ワークスのFloralieで買える）。とった物は納めなくてよいが、このエリアでとらないと数えない。 | @モリマー台地

@ quest.adoulin.158 https://wiki.ffo.jp/html/28649.html
Q Clear: Morimar Basalt Fields | 進路確保:モリマー台地 | yes | T npc.256.Task_Delegator_Pioneers
RW other:経験値と同盟戦績 2500（コールチケット2枚で4500、3枚で6000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がスタッフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Probationer、報酬はチケット1〜3枚で 2500/4500/6000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「進路確保:モリマー台地」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 defeat - | モリマー台地のコロナイズ・レイヴ（道をふさぐ障害物）に加わって、障害物を壊して完了 | 場所はH-8・I-8・H-10・G-11・F-9・F-6。壊すと1時間（一部は15分）で元に戻るので、戻るのを待つか別の場所へ。 | @モリマー台地

@ quest.adoulin.159 https://wiki.ffo.jp/html/28666.html
Q Recover: Morimar Basalt Fields | 物品捜索:モリマー台地 | yes | T npc.256.Task_Delegator_Mummers
RW other:経験値と同盟戦績 2000（コールチケット2枚で3600、3枚で4800）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がパートナー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Disciple、報酬はチケット1〜3枚で 2000/3600/4800
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「物品捜索:モリマー台地」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 examine - | モリマー台地かモーの門で、地面が光るLost Articleを探して調べて完了 | 広域スキャンに出ない。出る場所は次のどれか1つ：モリマー台地 E-7・F-8・H-10・I-7・I-9・K-9、モーの門 G-6・G-9・I-9・K-5・K-8。 | @モリマー台地

@ quest.adoulin.160 https://wiki.ffo.jp/html/28667.html
Q Research: Morimar Basalt Fields | 生態研究:モリマー台地 | yes | T npc.256.Task_Delegator_Mummers
RW other:経験値と同盟戦績 4000（コールチケット2枚で7200、3枚で9600）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がアドバイザー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Contributor、報酬はチケット1〜3枚で 4000/7200/9600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「生態研究:モリマー台地」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 go - | モリマー台地かモーの門でマタマタ族の「テイルスワック」を受けて完了 | F.ビバック#3から南へ行くと何匹かいる。倒さなくてよい。回避・空蝉・盾で防ぐと数えない。 | @モリマー台地

@ quest.adoulin.161 https://wiki.ffo.jp/html/28650.html
Q Patrol: Moh Gates | 巡回警備:モーの門 | yes | T npc.257.Task_Delegator_Peacekeepers
RW other:経験値と同盟戦績 2500（コールチケット2枚で4500、3枚で6000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がスタッフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Probationer、報酬はチケット1〜3枚で 2500/4500/6000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「巡回警備:モーの門」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | モーの門でラプトル族を5体倒して完了 | モリマー台地のF.ステーションから入るのが近い。範囲攻撃でまとめて倒すと1体分しか数えない。 | @モーの門

@ quest.adoulin.162 https://wiki.ffo.jp/html/28676.html
Q Preserve: Yahse Hunting Grounds | 治安維持:ヤッセの狩り場 | yes | T npc.257.Task_Delegator_Peacekeepers
RW other:経験値と同盟戦績 1750（コールチケット2枚で3150、3枚で4200）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がルーキー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Petitioner、報酬はチケット1〜3枚で 1750/3150/4200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「治安維持:ヤッセの狩り場」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | ヤッセの狩り場のレイア・レイヴ（魔物の巣）に加わって、巣を壊して完了 | 場所はF-7・F-8・H-9・I-6・J-6。巣を壊すと15分でまた出る。 | @ヤッセの狩り場

@ quest.adoulin.163 https://wiki.ffo.jp/html/28663.html
Q Survey: Yorcia Weald | 地脈調査:ヨルシア森林 | yes | T npc.257.Task_Delegator_Scouts
RW other:経験値と同盟戦績 3000（コールチケット2枚で5400、3枚で7200）（行き先が遠いほど上乗せ）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がチーフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Advisor、報酬はチケット1〜3枚で 3000/5400/7200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「地脈調査:ヨルシア森林」を受ける | 距離はヴァナ時間で変わる。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | > a01,b01,c01
a01 examine - | 【澄明の池】ヨルシア森林(G-6)のErgon Locus「澄明の池」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ビバック#1から。 | @ヨルシア森林 G-6 | T obj.263.Ergon_Locus_G-6 = obj:Ergon Locus@ヨルシア森林 G-6 | R 澄明の池 | >
b01 examine - | 【蘇苔の岩】ヨルシア森林(I-7)のErgon Locus「蘇苔の岩」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ステーションから北西。 | @ヨルシア森林 I-7 I-8 | T obj.263.Ergon_Locus_I-7 = obj:Ergon Locus@ヨルシア森林 I-7 I-8 | R 蘇苔の岩 | >
c01 examine - | 【繋茂の木】ヨルシア森林(K-10)のErgon Locus「繋茂の木」を正しい距離から調べて完了 | くっついてから少しずつ下がって調べる。F.ビバック#2から。 | @ヨルシア森林 K-10 | T obj.263.Ergon_Locus_K-10 = obj:Ergon Locus@ヨルシア森林 K-10 | R 繋茂の木 | >

@ quest.adoulin.164 https://wiki.ffo.jp/html/28662.html
Q Support: Yorcia Weald | 戦線物資:ヨルシア森林 | yes | T npc.256.Task_Delegator_Couriers
RW other:経験値と同盟戦績 3000（コールチケット2枚で5400、3枚で7200）（行き先が遠いほど上乗せ）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がチーフ以上
LK other:ヨルシア森林のF.ステーションが建っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Advisor、報酬はチケット1〜3枚で 3000/5400/7200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「戦線物資:ヨルシア森林」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | ヨルシア森林のF.ビバックのどれかに設営物資を届けて完了 | 番号は問わない。奥のほうが報酬が高い。ウォーの門からエスケプでヨルシア森林に出ると、南にすぐ#3がある。 | @ヨルシア森林

@ quest.adoulin.165 https://wiki.ffo.jp/html/28651.html
Q Provide: Yorcia Weald | 拠点物資:ヨルシア森林 | yes | T npc.256.Task_Delegator_Couriers
RW other:経験値と同盟戦績 2500（コールチケット2枚で4500、3枚で6000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がアーティスト以上
LK other:ヨルシア森林のF.ステーションがまだ建っていない（今はどこも建っているので受けられない）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Partner、報酬はチケット1〜3枚で 2500/4500/6000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「拠点物資:ヨルシア森林」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | ヨルシア森林(J-7)のF.ステーション建設予定地に建築資材を届けて完了 | ヤッセの狩り場からモーの門、シルダス洞窟を通って入る。フォードとクライムのスキルが要る。 | @ヨルシア森林 J-7

@ quest.adoulin.166 https://wiki.ffo.jp/html/28676.html
Q Preserve: Yorcia Weald | 治安維持:ヨルシア森林 | yes | T npc.257.Task_Delegator_Peacekeepers
RW other:経験値と同盟戦績 5000（コールチケット2枚で9000、3枚で12000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がチーフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Advisor、報酬はチケット1〜3枚で 5000/9000/12000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「治安維持:ヨルシア森林」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | ヨルシア森林のレイア・レイヴ（魔物の巣）に加わって、巣を壊して完了 | 場所はJ-6/K-6・H-6/I-6・K-9・J-11・G-7。巣を壊すと5分でまた出る。 | @ヨルシア森林

@ quest.adoulin.167 https://wiki.ffo.jp/html/28667.html
Q Research: Yorcia Weald | 生態研究:ヨルシア森林 | yes | T npc.256.Task_Delegator_Mummers
RW other:経験値と同盟戦績 6000（コールチケット2枚で10800、3枚で14400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がマイスター以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Magnate、報酬はチケット1〜3枚で 6000/10800/14400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「生態研究:ヨルシア森林」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 go - | ヨルシア森林でスナップウィード族の「ティックルテンドリル」を受けて完了 | F.ステーションから北西へ行くと何匹かいる。倒さなくてよい。回避・空蝉・盾で防ぐと数えない。 | @ヨルシア森林

@ quest.adoulin.168 https://wiki.ffo.jp/html/28655.html
Q Deliver: Yorcia Weald | 資材宅配:ヨルシア森林 | yes | T npc.256.Task_Delegator_Couriers
RW other:経験値と同盟戦績 2500（コールチケット2枚で4500、3枚で6000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:クーリエ・ワークスの個人評価がチーフ以上
LK other:ヨルシア森林のF.ステーションが建っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Couriers'_Coalition;Task Delegator は西アドゥリン G-7（Waypoint #1 のそば）。必要な評価は Advisor、報酬はチケット1〜3枚で 2500/4500/6000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-7)のクーリエ・ワークスのTask Delegatorに話し、ワークスコール「資材宅配:ヨルシア森林」を受ける | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers
g02 go - | ヨルシア森林(J-7)のF.ステーションへ行き、採集資材を受け取る | ウェイポイントが通っていればすぐ。 | @ヨルシア森林 J-7
g03 talk - | Task Delegatorに採集資材を届けて完了 | - | @西アドゥリン G-7 | T npc.256.Task_Delegator_Couriers

@ quest.adoulin.169 https://wiki.ffo.jp/html/28648.html
Q Procure: Yorcia Weald | 資材調達:ヨルシア森林 | yes | T npc.256.Task_Delegator_Pioneers
RW other:経験値と同盟戦績 3750（コールチケット2枚で6750、3枚で9000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がチーフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Advisor、報酬はチケット1〜3枚で 3750/6750/9000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「資材調達:ヨルシア森林」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 gather - | ヨルシア森林の伐採ポイントで伐採して、5個とって完了 | 斧が要る（パイオニア・ワークスのFloralieで買える）。とった物は納めなくてよいが、このエリアでとらないと数えない。 | @ヨルシア森林

@ quest.adoulin.170 https://wiki.ffo.jp/html/28649.html
Q Clear: Yorcia Weald | 進路確保:ヨルシア森林 | yes | T npc.256.Task_Delegator_Pioneers
RW other:経験値と同盟戦績 5000（コールチケット2枚で9000、3枚で12000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がチーフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Advisor、報酬はチケット1〜3枚で 5000/9000/12000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「進路確保:ヨルシア森林」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 defeat - | ヨルシア森林のコロナイズ・レイヴ（道をふさぐ障害物）に加わって、障害物を壊して完了 | 場所はI-6・G-7・J-9・H-9。壊すと1時間（一部は15分）で元に戻るので、戻るのを待つか別の場所へ。 | @ヨルシア森林

@ quest.adoulin.171 https://wiki.ffo.jp/html/28666.html
Q Recover: Yorcia Weald | 物品捜索:ヨルシア森林 | yes | T npc.256.Task_Delegator_Mummers
RW other:経験値と同盟戦績 3750（コールチケット2枚で6750、3枚で9000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がチーフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Advisor、報酬はチケット1〜3枚で 3750/6750/9000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「物品捜索:ヨルシア森林」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 examine - | ヨルシア森林かシルダス洞窟で、地面が光るLost Articleを探して調べて完了 | 広域スキャンに出ない。出る場所は次のどれか1つ：ヨルシア森林 G-8・H-6・H-8・H-9・J-6・J-9、シルダス洞窟 F-9・H-6・H-11・I-13・J-12・K-7。 | @ヨルシア森林

@ quest.adoulin.172 https://wiki.ffo.jp/html/28650.html
Q Patrol: Rala Waterways | 巡回警備:ララ水道 | yes | T npc.257.Task_Delegator_Peacekeepers
RW other:経験値と同盟戦績 2500（コールチケット2枚で4500、3枚で6000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がスタッフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Probationer、報酬はチケット1〜3枚で 2500/4500/6000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「巡回警備:ララ水道」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | ララ水道でトード族を5体倒して完了 | シビック・アボレタムの奥（西アドゥリン(I-12)から入る）に多い。謎の魔導器から行くのも近い。範囲攻撃でまとめて倒すと1体分しか数えない。 | @ララ水道

@ quest.adoulin.173 https://wiki.ffo.jp/html/28667.html
Q Research: Rala Waterways | 生態研究:ララ水道 | yes | T npc.256.Task_Delegator_Mummers
RW other:経験値と同盟戦績 1750（コールチケット2枚で3150、3枚で4200）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:マッマーズ・ワークスの個人評価がルーキー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mummers'_Coalition;Task Delegator は西アドゥリン G-11（Waypoint #3 のそば）。同じページの場所欄は G-10。必要な評価は Petitioner、報酬はチケット1〜3枚で 1750/3150/4200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(G-10・G-11)のマッマーズ・ワークスのTask Delegatorに話し、ワークスコール「生態研究:ララ水道」を受ける | - | @西アドゥリン G-10 G-11 | T npc.256.Task_Delegator_Mummers
g02 go - | ララ水道でスラッグ族の「ファスカスウーズ」を受けて完了 | 水園の決闘場のさらに南（東アドゥリン(E-7)から入る）にいる。受けると装備を1分ほど変えられない。倒さなくてよい。回避・空蝉・盾で防ぐと数えない。 | @ララ水道

@ quest.adoulin.174 https://wiki.ffo.jp/html/28650.html
Q Patrol: Outer Ra'Kaznar | 巡回警備:ラ・カザナル宮外郭 | yes | T npc.257.Task_Delegator_Peacekeepers
RW other:経験値と同盟戦績 8000（コールチケット2枚で14400、3枚で19200）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がレジェンド以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Legend、報酬はチケット1〜3枚で 8000/14400/19200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「巡回警備:ラ・カザナル宮外郭」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | ラ・カザナル宮外郭で鉄巨人族を3体倒して完了 | 謎の魔導器から(L-8)のツタを下りたMAP2(L-12)の広場にいる。リンクに注意。奥のApex Ironcladは強い。範囲攻撃でまとめて倒すと1体分しか数えない。 | @ラ・カザナル宮外郭 L-12 #2

@ quest.adoulin.175 https://wiki.ffo.jp/html/28648.html
Q Procure: Outer Ra'Kaznar | 資材調達:ラ・カザナル宮外郭 | yes | T npc.256.Task_Delegator_Pioneers
RW other:経験値と同盟戦績 6000（コールチケット2枚で10800、3枚で14400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がレジェンド以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Legend、報酬はチケット1〜3枚で 6000/10800/14400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「資材調達:ラ・カザナル宮外郭」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 gather - | ラ・カザナル宮外郭の採掘ポイントで採掘して、5個とって完了 | つるはしが要る（パイオニア・ワークスのFloralieで買える）。とった物は納めなくてよいが、このエリアでとらないと数えない。 | @ラ・カザナル宮外郭

@ quest.adoulin.176 https://wiki.ffo.jp/html/28676.html
Q Preserve: Outer Ra'Kaznar | 治安維持:ラ・カザナル宮外郭 | yes | T npc.257.Task_Delegator_Peacekeepers
RW other:経験値と同盟戦績 7000（コールチケット2枚で12600、3枚で16800）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:ピースキーパー・ワークスの個人評価がレジェンド以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Peacekeepers'_Coalition;Task Delegator は東アドゥリン F-7（Waypoint #1 のそば）。必要な評価は Legend、報酬はチケット1〜3枚で 7000/12600/16800
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-7)のピースキーパー・ワークスのTask Delegatorに話し、ワークスコール「治安維持:ラ・カザナル宮外郭」を受ける | - | @東アドゥリン F-7 | T npc.257.Task_Delegator_Peacekeepers
g02 defeat - | ラ・カザナル宮外郭かラ・カザナル宮内郭のレイア・レイヴ（魔物の巣）に加わって、巣を壊して完了 | 場所はMAP1のJ-6・J-8・H-8・H-6。内郭ならMAP2のH-6・E-6・D-8・H-11。巣を壊すと5分でまた出る。 | @ラ・カザナル宮外郭

@ quest.adoulin.177 https://wiki.ffo.jp/html/28649.html
Q Clear: Outer Ra'Kaznar | 進路確保:ラ・カザナル宮外郭 | yes | T npc.256.Task_Delegator_Pioneers
RW other:経験値と同盟戦績 7000（コールチケット2枚で12600、3枚で16800）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:パイオニア・ワークスの個人評価がレジェンド以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pioneers'_Coalition;Task Delegator は西アドゥリン E-8（Waypoint #2 のそば）。必要な評価は Legend、報酬はチケット1〜3枚で 7000/12600/16800
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(E-8)のパイオニア・ワークスのTask Delegatorに話し、ワークスコール「進路確保:ラ・カザナル宮外郭」を受ける | - | @西アドゥリン E-8 | T npc.256.Task_Delegator_Pioneers
g02 defeat - | ラ・カザナル宮外郭かラ・カザナル宮内郭のコロナイズ・レイヴ（道をふさぐ障害物）に加わって、障害物を壊して完了 | 場所はMAP2のJ-10/K-10・F-10・F-6/G-6・J-6/J-7。内郭ならMAP2のK-11・K-6・F-6・F-11。壊すと1時間（一部は15分）で元に戻るので、戻るのを待つか別の場所へ。 | @ラ・カザナル宮外郭

@ quest.adoulin.178 https://wiki.ffo.jp/html/28664.html
Q Analyze: Foret de Hennetiel | 素材探究:エヌティエル水林 | yes | T npc.257.Task_Delegator_Scouts
RW other:経験値と同盟戦績 2250（コールチケット2枚で4050、3枚で5400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がアドバイザー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Contributor、報酬はチケット1〜3枚で 2250/4050/5400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「素材探究:エヌティエル水林」を受ける | - | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts
g02 trade - | Task Delegatorにナットベインを1個納めて完了 | エヌティエル水林で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | N ナットベイン*1

@ quest.adoulin.179 https://wiki.ffo.jp/html/28664.html
Q Analyze: Kamihr Drifts | 素材探究:カミール山麓 | yes | T npc.257.Task_Delegator_Scouts
RW other:経験値と同盟戦績 4750（コールチケット2枚で8550、3枚で11400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がレジェンド以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Legend、報酬はチケット1〜3枚で 4750/8550/11400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「素材探究:カミール山麓」を受ける | - | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts
g02 trade - | Task Delegatorに氷晶石を1個納めて完了 | カミール山麓で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | N 氷晶石*1

@ quest.adoulin.180 https://wiki.ffo.jp/html/28664.html
Q Analyze: Cirdas Caverns | 素材探究:シルダス洞窟 | yes | T npc.257.Task_Delegator_Scouts
RW other:経験値と同盟戦績 2750（コールチケット2枚で4950、3枚で6600）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がアーティスト以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Partner、報酬はチケット1〜3枚で 2750/4950/6600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「素材探究:シルダス洞窟」を受ける | - | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts
g02 trade - | Task Delegatorに水石を1個納めて完了 | シルダス洞窟で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | N 水石*1

@ quest.adoulin.181 https://wiki.ffo.jp/html/28664.html
Q Analyze: Marjami Ravine | 素材探究:マリアミ渓谷 | yes | T npc.257.Task_Delegator_Scouts
RW other:経験値と同盟戦績 4000（コールチケット2枚で7200、3枚で9600）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がマイスター以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Magnate、報酬はチケット1〜3枚で 4000/7200/9600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「素材探究:マリアミ渓谷」を受ける | - | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts
g02 trade - | Task Delegatorにウーツ鉱を1個納めて完了 | マリアミ渓谷で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | N ウーツ鉱*1

@ quest.adoulin.182 https://wiki.ffo.jp/html/28664.html
Q Analyze: Morimar Basalt Fields | 素材探究:モリマー台地 | yes | T npc.257.Task_Delegator_Scouts
RW other:経験値と同盟戦績 2250（コールチケット2枚で4050、3枚で5400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がアドバイザー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Contributor、報酬はチケット1〜3枚で 2250/4050/5400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「素材探究:モリマー台地」を受ける | - | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts
g02 trade - | Task Delegatorに結晶質石灰岩を1個納めて完了 | モリマー台地で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | N 結晶質石灰岩*1

@ quest.adoulin.183 https://wiki.ffo.jp/html/28664.html
Q Analyze: Yorcia Weald | 素材探究:ヨルシア森林 | yes | T npc.257.Task_Delegator_Scouts
RW other:経験値と同盟戦績 4000（コールチケット2枚で7200、3枚で9600）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がマイスター以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Magnate、報酬はチケット1〜3枚で 4000/7200/9600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「素材探究:ヨルシア森林」を受ける | - | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts
g02 trade - | Task Delegatorにガタンブ原木を1個納めて完了 | ヨルシア森林で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | N ガタンブ原木*1

@ quest.adoulin.184 https://wiki.ffo.jp/html/28664.html
Q Analyze: Outer Ra'Kaznar | 素材探究:ラ・カザナル宮外郭 | yes | T npc.257.Task_Delegator_Scouts
RW other:経験値と同盟戦績 5500（コールチケット2枚で9900、3枚で13200）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:スカウト・ワークスの個人評価がレジェンド以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Scouts'_Coalition;Task Delegator は東アドゥリン F-9（Waypoint #2 のそば）。必要な評価は Legend、報酬はチケット1〜3枚で 5500/9900/13200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 東アドゥリン(F-9)のスカウト・ワークスのTask Delegatorに話し、ワークスコール「素材探究:ラ・カザナル宮外郭」を受ける | - | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts
g02 trade - | Task Delegatorにバナジウム鉱を1個納めて完了 | ラ・カザナル宮外郭で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @東アドゥリン F-9 | T npc.257.Task_Delegator_Scouts | N バナジウム鉱*1

@ quest.adoulin.185 https://wiki.ffo.jp/html/28665.html
Q Gather: Woh Gates | 素材調達:ウォーの門 | yes | T npc.256.Task_Delegator_Inventors = npc:Task Delegator~@西アドゥリン J-10
RW other:経験値と同盟戦績 4000（コールチケット2枚で7200、3枚で9600）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:インベンター・ワークスの個人評価がマイスター以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Inventors'_Coalition;Task Delegator は西アドゥリン J-10（Waypoint #4 のそば）。必要な評価は Magnate、報酬はチケット1〜3枚で 4000/7200/9600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(J-10)のインベンター・ワークスのTask Delegatorに話し、ワークスコール「素材調達:ウォーの門」を受ける | - | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors
g02 trade - | Task Delegatorにスノールのうでを3個納めて完了 | ウォーの門で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors | N スノールのうで*3

@ quest.adoulin.186 https://wiki.ffo.jp/html/28665.html
Q Gather: Foret de Hennetiel | 素材調達:エヌティエル水林 | yes | T npc.256.Task_Delegator_Inventors
RW other:経験値と同盟戦績 1750（コールチケット2枚で3150、3枚で4200）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:インベンター・ワークスの個人評価がパートナー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Inventors'_Coalition;Task Delegator は西アドゥリン J-10（Waypoint #4 のそば）。必要な評価は Disciple、報酬はチケット1〜3枚で 1750/3150/4200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(J-10)のインベンター・ワークスのTask Delegatorに話し、ワークスコール「素材調達:エヌティエル水林」を受ける | - | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors
g02 trade - | Task Delegatorにクラックローの鋏を3個納めて完了 | エヌティエル水林で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors | N クラックローの鋏*3

@ quest.adoulin.187 https://wiki.ffo.jp/html/28665.html
Q Gather: Kamihr Drifts | 素材調達:カミール山麓 | yes | T npc.256.Task_Delegator_Inventors
RW other:経験値と同盟戦績 4000（コールチケット2枚で7200、3枚で9600）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:インベンター・ワークスの個人評価がマイスター以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Inventors'_Coalition;Task Delegator は西アドゥリン J-10（Waypoint #4 のそば）。必要な評価は Magnate、報酬はチケット1〜3枚で 4000/7200/9600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(J-10)のインベンター・ワークスのTask Delegatorに話し、ワークスコール「素材調達:カミール山麓」を受ける | - | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors
g02 trade - | Task Delegatorにラズの牙を3個納めて完了 | カミール山麓で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors | N ラズの牙*3

@ quest.adoulin.188 https://wiki.ffo.jp/html/28665.html
Q Gather: Ceizak Battlegrounds | 素材調達:ケイザック古戦場 | yes | T npc.256.Task_Delegator_Inventors
RW other:経験値と同盟戦績 1000（コールチケット2枚で1800、3枚で2400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:インベンター・ワークスの個人評価がルーキー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Inventors'_Coalition;Task Delegator は西アドゥリン J-10（Waypoint #4 のそば）。必要な評価は Petitioner、報酬はチケット1〜3枚で 1000/1800/2400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(J-10)のインベンター・ワークスのTask Delegatorに話し、ワークスコール「素材調達:ケイザック古戦場」を受ける | - | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors
g02 trade - | Task Delegatorにチャプリの翅を5個納めて完了 | ケイザック古戦場で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors | N チャプリの翅*5

@ quest.adoulin.189 https://wiki.ffo.jp/html/28665.html
Q Gather: Sih Gates | 素材調達:シィの門 | yes | T npc.256.Task_Delegator_Inventors
RW other:経験値と同盟戦績 1250（コールチケット2枚で2250、3枚で3000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:インベンター・ワークスの個人評価がスタッフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Inventors'_Coalition;Task Delegator は西アドゥリン J-10（Waypoint #4 のそば）。必要な評価は Probationer、報酬はチケット1〜3枚で 1250/2250/3000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(J-10)のインベンター・ワークスのTask Delegatorに話し、ワークスコール「素材調達:シィの門」を受ける | - | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors
g02 trade - | Task Delegatorにアクエフの毒薬を3個納めて完了 | シィの門で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors | N アクエフの毒薬*3

@ quest.adoulin.190 https://wiki.ffo.jp/html/28665.html
Q Gather: Cirdas Caverns | 素材調達:シルダス洞窟 | yes | T npc.256.Task_Delegator_Inventors
RW other:経験値と同盟戦績 2250（コールチケット2枚で4050、3枚で5400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:インベンター・ワークスの個人評価がアドバイザー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Inventors'_Coalition;Task Delegator は西アドゥリン J-10（Waypoint #4 のそば）。必要な評価は Contributor、報酬はチケット1〜3枚で 2250/4050/5400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(J-10)のインベンター・ワークスのTask Delegatorに話し、ワークスコール「素材調達:シルダス洞窟」を受ける | - | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors
g02 trade - | Task Delegatorにアンブリルオイルを3個納めて完了 | シルダス洞窟で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors | N アンブリルオイル*3

@ quest.adoulin.191 https://wiki.ffo.jp/html/28665.html
Q Gather: Dho Gates | 素材調達:ドーの門 | yes | T npc.256.Task_Delegator_Inventors
RW other:経験値と同盟戦績 2750（コールチケット2枚で4950、3枚で6600）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:インベンター・ワークスの個人評価がアーティスト以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Inventors'_Coalition;Task Delegator は西アドゥリン J-10（Waypoint #4 のそば）。必要な評価は Partner、報酬はチケット1〜3枚で 2750/4950/6600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(J-10)のインベンター・ワークスのTask Delegatorに話し、ワークスコール「素材調達:ドーの門」を受ける | - | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors
g02 trade - | Task Delegatorにスラッグの眼を3個納めて完了 | ドーの門で手に入る。どこで手に入れてもよく、競売で買ってもよい。ドーの門MAP2のSlinking Slugを倒すと集めやすい。 | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors | N スラッグの眼*3

@ quest.adoulin.192 https://wiki.ffo.jp/html/28665.html
Q Gather: Marjami Ravine | 素材調達:マリアミ渓谷 | yes | T npc.256.Task_Delegator_Inventors
RW other:経験値と同盟戦績 2750（コールチケット2枚で4950、3枚で6600）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:インベンター・ワークスの個人評価がアーティスト以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Inventors'_Coalition;Task Delegator は西アドゥリン J-10（Waypoint #4 のそば）。必要な評価は Partner、報酬はチケット1〜3枚で 2750/4950/6600
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(J-10)のインベンター・ワークスのTask Delegatorに話し、ワークスコール「素材調達:マリアミ渓谷」を受ける | - | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors
g02 trade - | Task Delegatorにトゥルフェイアの羽を3個納めて完了 | マリアミ渓谷で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors | N トゥルフェイアの羽*3

@ quest.adoulin.193 https://wiki.ffo.jp/html/28665.html
Q Gather: Morimar Basalt Fields | 素材調達:モリマー台地 | yes | T npc.256.Task_Delegator_Inventors
RW other:経験値と同盟戦績 1750（コールチケット2枚で3150、3枚で4200）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:インベンター・ワークスの個人評価がパートナー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Inventors'_Coalition;Task Delegator は西アドゥリン J-10（Waypoint #4 のそば）。必要な評価は Disciple、報酬はチケット1〜3枚で 1750/3150/4200
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(J-10)のインベンター・ワークスのTask Delegatorに話し、ワークスコール「素材調達:モリマー台地」を受ける | - | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors
g02 trade - | Task Delegatorにペイストの毒針を3個納めて完了 | モリマー台地で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors | N ペイストの毒針*3

@ quest.adoulin.194 https://wiki.ffo.jp/html/28665.html
Q Gather: Moh Gates | 素材調達:モーの門 | yes | T npc.256.Task_Delegator_Inventors
RW other:経験値と同盟戦績 1250（コールチケット2枚で2250、3枚で3000）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:インベンター・ワークスの個人評価がスタッフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Inventors'_Coalition;Task Delegator は西アドゥリン J-10（Waypoint #4 のそば）。必要な評価は Probationer、報酬はチケット1〜3枚で 1250/2250/3000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(J-10)のインベンター・ワークスのTask Delegatorに話し、ワークスコール「素材調達:モーの門」を受ける | - | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors
g02 trade - | Task Delegatorにマタマタの甲羅を3個納めて完了 | モーの門で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors | N マタマタの甲羅*3

@ quest.adoulin.195 https://wiki.ffo.jp/html/28665.html
Q Gather: Yahse Hunting Grounds | 素材調達:ヤッセの狩り場 | yes | T npc.256.Task_Delegator_Inventors
RW other:経験値と同盟戦績 1000（コールチケット2枚で1800、3枚で2400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:インベンター・ワークスの個人評価がルーキー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Inventors'_Coalition;Task Delegator は西アドゥリン J-10（Waypoint #4 のそば）。必要な評価は Petitioner、報酬はチケット1〜3枚で 1000/1800/2400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(J-10)のインベンター・ワークスのTask Delegatorに話し、ワークスコール「素材調達:ヤッセの狩り場」を受ける | - | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors
g02 trade - | Task Delegatorにトウィザリムの翅を5個納めて完了 | ヤッセの狩り場で手に入る。どこで手に入れてもよく、競売で買ってもよい。南東に多い。F.ビバック#1の近くがねらいやすい。 | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors | N トウィザリムの翅*5

@ quest.adoulin.196 https://wiki.ffo.jp/html/28665.html
Q Gather: Yorcia Weald | 素材調達:ヨルシア森林 | yes | T npc.256.Task_Delegator_Inventors
RW other:経験値と同盟戦績 3250（コールチケット2枚で5850、3枚で7800）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:インベンター・ワークスの個人評価がチーフ以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Inventors'_Coalition;Task Delegator は西アドゥリン J-10（Waypoint #4 のそば）。必要な評価は Advisor、報酬はチケット1〜3枚で 3250/5850/7800
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(J-10)のインベンター・ワークスのTask Delegatorに話し、ワークスコール「素材調達:ヨルシア森林」を受ける | - | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors
g02 trade - | Task Delegatorにスナップのつるを3個納めて完了 | ヨルシア森林で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors | N スナップのつる*3

@ quest.adoulin.197 https://wiki.ffo.jp/html/28665.html
Q Gather: Rala Waterways | 素材調達:ララ水道 | yes | T npc.256.Task_Delegator_Inventors
RW other:経験値と同盟戦績 1000（コールチケット2枚で1800、3枚で2400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:インベンター・ワークスの個人評価がルーキー以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Inventors'_Coalition;Task Delegator は西アドゥリン J-10（Waypoint #4 のそば）。必要な評価は Petitioner、報酬はチケット1〜3枚で 1000/1800/2400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(J-10)のインベンター・ワークスのTask Delegatorに話し、ワークスコール「素材調達:ララ水道」を受ける | - | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors
g02 trade - | Task Delegatorに血糸を3個納めて完了 | ララ水道で手に入る。どこで手に入れてもよく、競売で買ってもよい。ララ水道のダイアマイト族は(D-5)のあたりにいる。 | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors | N 血糸*3

@ quest.adoulin.198 https://wiki.ffo.jp/html/28665.html
Q Gather: Ra'Kaznar Inner Court | 素材調達:ラ・カザナル宮内郭 | yes | T npc.256.Task_Delegator_Inventors
RW other:経験値と同盟戦績 4750（コールチケット2枚で8550、3枚で11400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:インベンター・ワークスの個人評価がレジェンド以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Inventors'_Coalition;Task Delegator は西アドゥリン J-10（Waypoint #4 のそば）。必要な評価は Legend、報酬はチケット1〜3枚で 4750/8550/11400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(J-10)のインベンター・ワークスのTask Delegatorに話し、ワークスコール「素材調達:ラ・カザナル宮内郭」を受ける | - | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors
g02 trade - | Task Delegatorに夜光布を3個納めて完了 | ラ・カザナル宮内郭で手に入る。どこで手に入れてもよく、競売で買ってもよい。内郭のゴースト族は2体だけなので、ほかのエリアのゴーストを狩るとよい。 | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors | N 夜光布*3

@ quest.adoulin.199 https://wiki.ffo.jp/html/28665.html
Q Gather: Outer Ra'Kaznar | 素材調達:ラ・カザナル宮外郭 | yes | T npc.256.Task_Delegator_Inventors
RW other:経験値と同盟戦績 4750（コールチケット2枚で8550、3枚で11400）
LK condition:だいじなもの「開拓者バッジ」を持っている
LK other:インベンター・ワークスの個人評価がレジェンド以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Inventors'_Coalition;Task Delegator は西アドゥリン J-10（Waypoint #4 のそば）。必要な評価は Legend、報酬はチケット1〜3枚で 4750/8550/11400
XS BG Wiki;https://www.bg-wiki.com/ffxi/Coalition_Assignments;ワークスコールは開拓者バッジ（Pioneer's Badge）が要り、受けるたびにコールチケット（Imprimatur）を使う。チケットは3時間に1枚もらえ（最大15枚）、あるかぎり何度でも受けられる
g01 talk - | 西アドゥリン(J-10)のインベンター・ワークスのTask Delegatorに話し、ワークスコール「素材調達:ラ・カザナル宮外郭」を受ける | - | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors
g02 trade - | Task Delegatorにデュラハンの鎧を1個納めて完了 | ラ・カザナル宮外郭で手に入る。どこで手に入れてもよく、競売で買ってもよい。 | @西アドゥリン J-10 | T npc.256.Task_Delegator_Inventors | N デュラハンの鎧*1

