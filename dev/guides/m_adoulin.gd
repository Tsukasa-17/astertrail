# アドゥリンの魔境（0.1.124〜）。基礎シートのミッション一覧 287〜390 行と、下に足した 645〜648 行。id の番号はシートの行−286。order は BG Wiki の並び（始めるにはだけ 999）
@ mission.adoulin.001 https://wiki.ffo.jp/html/28112.html
Q Rumors from the West | 西の国の噂 | no | T npc.245.Darcia
MN SoA1-1 1
RW key_item:ロゼッタ石
LK condition:追加ディスク「アドゥリンの魔境」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_1-1;3国の街に入ったときのイベントは見なくてよい。ジュノ下層 H-7 の商工会議所の Darcia に「開拓者に志願したい」でロゼッタ石（FFXIclopedia も同じ。イベントを後にした場合は北サンドリア J-10・バストゥーク商業区 I-8・ウィンダス森の区 J-10 の Tales' Beginning。見逃したイベントは吟遊詩人で見られる）
g01 go - | （してもしなくてもよい）北サンドリア・バストゥーク商業区・ウィンダス森の区のどれかに入ってイベントを見る | 見なくても次に進める。後にしたときは、北サンドリア(J-10)・バストゥーク商業区(I-8)・ウィンダス森の区(J-10)のTales' Beginningを調べる。見逃したイベントは記憶のウタイビトで見られる。
g02 talk - | ジュノ下層(H-7)の商工会議所のDarciaに話し、「開拓者に志願したい」を選んでだいじなもの「ロゼッタ石」をもらうと完了 | 「アドゥリン渡航免状が欲しい」を選んで100万ギル払うと、次の「ロゼッタ石」も済んで「いざ、アドゥリンへ」になる。 | @ジュノ下層 H-7 | T npc.245.Darcia

@ mission.adoulin.359 https://wiki.ffo.jp/html/27641.html
Q The Geomagnetron | ロゼッタ石 | no | T npc.245.Darcia
MN SoA1-2 2
RW key_item:アドゥリン渡航免状
LK condition:前節「西の国の噂」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_1-2;ロゼッタ石を持って、決まったダンジョンのどれか1か所の Geomagnetic Fount を調べ、Darcia に戻ると Adoulinian charter permit。100万ギルで飛ばせる。RoV「The River Runs Red」を済ませていれば Darcia に話すだけ（FFXIclopedia も同じ。グスタフの洞門は1枚目の G-10 の池）
g01 examine - | ロゼッタ石を持って、決まったダンジョンのどれか1か所のGeomagnetic Fountを調べる（例：グスタフの洞門(G-10)の池） | ほかに、ラングモント峠(J-10)・ユグホトの岩屋(J-7)・龍王ランペールの墓(K-6)・修道窟(H-10)・エルディーム古墳(J-10)・オルデール鍾乳洞(F-12)・グスゲン鉱山(G-7)・ダングルフの涸れ谷(E-11)・コロロカの洞門(G-9)・パルブロ鉱山(J-8)・オンゾゾの迷路(J-5)・シャクラミの地下迷宮(K-9)・ガルレージュ要塞(G-8)・クロウラーの巣(F-7)・内ホルトト遺跡(G-7/H-8)・外ホルトト遺跡(G-7)・トライマライ水路(I-6)のどれでもよい。低いレベルならスニークとインビジがあるとよい。 | @グスタフの洞門 G-10 #1 | T obj.212.Geomagnetic_Fount = obj:Geomagnetic Fount@グスタフの洞門 G-10 #1 | K ロゼッタ石
g02 talk - | ジュノ下層(H-7)の商工会議所のDarciaに話し、だいじなもの「アドゥリン渡航免状」をもらうと完了 | 前の節で100万ギル払って渡航免状を買っていれば、この節はもう済んでいる。「The River Runs Red」を済ませていれば、Darciaに話すだけでよい。 | @ジュノ下層 H-7 | T npc.245.Darcia

@ mission.adoulin.002 https://wiki.ffo.jp/html/28113.html
Q Onward to Adoulin | いざ、アドゥリンへ | no | T obj.245.Waypoint = obj:Waypoint@ジュノ下層 H-7
MN SoA1-3 3
LK condition:前節「ロゼッタ石」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_1-3;ジュノ下層 H-7 の Waypoint を調べる（FFXIclopedia も同じ。ケイザック古戦場に飛んでイベント）
g01 examine - | ジュノ下層(H-7)のWaypointを調べてケイザック古戦場へ飛び、イベントを見ると完了 | 選んだ答えでアシェラとの仲が変わるらしい。 | @ジュノ下層 H-7 | T obj.245.Waypoint | K アドゥリン渡航免状

@ mission.adoulin.003 https://wiki.ffo.jp/html/28114.html
Q Heartwings and the Kindhearted | 精霊と少女 | no
MN SoA1-4 4
LK condition:前節「いざ、アドゥリンへ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_1-4;ケイザック古戦場を北東へ進み K-7 から西アドゥリンに入る。マウントが使える（FFXIclopedia は L-7。途中のフロンティア・ステーションの Waypoint を開けておくとよい）
g01 go - | ケイザック古戦場を北東へ進み、(K-7/L-7)から西アドゥリンに入ってイベントを見ると完了 | マウントが使える。途中のフロンティア・ステーションのWaypointを調べておくとよい。ジュノに戻ってWaypointで西アドゥリンへ飛んでもよい。 | @ケイザック古戦場 K-7 L-7

@ mission.adoulin.004 https://wiki.ffo.jp/html/28117.html
Q Pioneer Registration | 開拓者登録 | no | T npc.256.Brenton = npc:Brenton@西アドゥリン E-8
MN SoA1-5 5
RW key_item:開拓者バッジ
RW key_item:アドゥリン地図
RW other:同盟戦績1000ベヤルド
LK condition:前節「精霊と少女」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_1-5;西アドゥリン E-8 の Pioneers' Coalition の Brenton に話す。報酬は Pioneer's Badge・Map of Adoulin・1000 Bayld（FFXIclopedia も同じ）
g01 talk - | 西アドゥリン(E-8)のPIO.ワークス（スコップの看板）のBrentonに話し、イベントを見ると完了 | 話すとすぐ登録まで進む。開拓者バッジがないときしか聞けない台詞もあるので、気になるなら先に街の人と話しておく。終わったらワークスコールを受けておくとよい。 | @西アドゥリン E-8 | T npc.256.Brenton

@ mission.adoulin.005 https://wiki.ffo.jp/html/28118.html
Q Life on the Frontier | 開拓者という生活 | no | T npc.256.Brenton
MN SoA1-6 6
RW key_item:晩餐会への招待状
LK condition:前節「開拓者登録」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_1-6;済ませたワークスコールで使ったチケットの数（名声が高いほど少なくてよい）のあと、Brenton で Dinner invitation（FFXIclopedia は4枚。名声が最高なら1件でよい。2025年9月に条件が軽くなった）
g01 gather - | ワークスコールを受けて済ませ、チケットを使う | 要る枚数はアドゥリンの名声で変わる（名声が高いと少なくてよい）。アドゥリンのクエストもあわせて進めるとよい。
g02 talk - | 西アドゥリン(E-8)のPIO.ワークスのBrentonに話し、だいじなもの「晩餐会への招待状」をもらうと完了 | イベントが起きないときはワークスコールをもう少し済ませる。七支公のどれかを倒してからだと台詞が少し変わる。 | @西アドゥリン E-8 | T npc.256.Brenton

@ mission.adoulin.006 https://wiki.ffo.jp/html/28629.html
Q Meeting of the Minds | 十二家会 | no | T npc.257.Ploh_Trishbahk
MN SoA1-7 7
LK condition:前節「開拓者という生活」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_1-7;ヴァナ時間15:00〜22:00に東アドゥリン K-9 の城門前の Ploh Trishbahk（FFXIclopedia も同じ。招待状を渡す）
g01 talk - | ヴァナ時間15時〜22時に東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、イベントを見ると完了 | 次の節を早く進めるには、ここでクエスト「幻の果実水」を始めてTeodorに会うところまで進めておく。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk | K 晩餐会への招待状

@ mission.adoulin.007 https://wiki.ffo.jp/html/28630.html
Q Arciela Appears Again | 再会 | no | T npc.256.Levil
MN SoA1-8 8
LK condition:前節「十二家会」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_1-8;済ませたワークスコールのチケット数と名声の両方。そのあと Pioneers' Coalition の Levil（FFXIclopedia は翌日を待ってから。チケットは前から使った分も数える）
g01 go - | 前の節からヴァナ時間の0時を過ぎるまで待つ | 待つあいだに次の手順のワークスコールを進めるとよい。 | W ヴァナ時間の0時を過ぎてから
g02 gather - | ワークスコールを済ませてチケットを使う | 要る量は名声で変わり、はっきりしない。前から使ったチケットも数える。名声を上げるならクエストも進める。
g03 talk - | 西アドゥリン(E-8)のPIO.ワークスのLevilに話し、手伝うと答えてイベントを見ると完了 | イベントが起きないときは、ワークスコールかクエストをもう少し済ませる。 | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.008 https://wiki.ffo.jp/html/29067.html
Q Budding Prospects | リフキンを統べるもの | no | T npc.西アドゥリン.Masad
MN SoA2-1 9
LK condition:前節「再会」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-1;Teodor に会っていなければ、西アドゥリン J-9 の Berghent と Mummers' Coalition の Masad で「Flavors of Our Lives」を進め、翌日エリアを移ってから Masad（FFXIclopedia も同じ）
g01 talk - | まだなら、西アドゥリン(J-9)のBerghentに話してクエスト「幻の果実水」を始め、MUM.ワークスのMasadに話してTeodorに会うところまで進める | 前の節より前にここまで済ませていれば飛ばせる。 | @西アドゥリン J-9 | T npc.256.Berghent
g02 talk - | ヴァナ時間の日が変わってからエリアを移り、MUM.ワークスのMasadに話してTeodorのイベントを見ると完了 | クエストの会話が出たら、イベントになるまでもう一度話す。 | @西アドゥリン G-10 | T npc.西アドゥリン.Masad | W ヴァナ時間の日が変わってから

@ mission.adoulin.009 https://wiki.ffo.jp/html/29068.html
Q The Light Shining in Your Eyes | その瞳の輝きゆえに | no | T npc.256.Levil
MN SoA2-1-1 10
LK condition:前節「リフキンを統べるもの」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-1-1;Pioneers' Coalition の Levil に話す（FFXIclopedia も同じ）
g01 talk - | 西アドゥリン(E-8)のPIO.ワークスのLevilに話し、イベントを見ると完了 | | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.010 https://wiki.ffo.jp/html/29069.html
Q The Heirloom | 遺剣の在り処 | no
MN SoA2-1-2 11
LK condition:前節「その瞳の輝きゆえに」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-1-2;東アドゥリンの城門に近づくとイベント（FFXIclopedia も同じ。城門の Waypoint で飛ぶと着いたときに起きる）
g01 go - | 東アドゥリン(K-9)のアドゥリン城門に近づき、イベントを見ると完了 | 城門のWaypointで飛んでくると、着いたときにイベントになる。 | @東アドゥリン K-9

@ mission.adoulin.011 https://wiki.ffo.jp/html/29070.html
Q An Aimless Journey | 標なき旅 | no
MN SoA2-2 12
LK condition:前節「遺剣の在り処」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-2;シルダス洞窟 E-9 の Ergon Locus に近づくとイベント。手前にログスキルの要るコロナイズ・レイヴ（FFXIclopedia も同じ。近くの Augural Conveyor が開いていれば Waypoint から飛べる）
g01 go - | シルダス洞窟へ行く | ケイザック古戦場の南西からシィの門を通って西へ行く道か、ヨルシア森林のフロンティア・ステーションの近くの入口が近い。謎の魔導器が開いていれば、Waypointから飛べる。初めてなら先にシルダス洞窟の地図を取っておくとよい。 | @シルダス洞窟
g02 defeat - | シルダス洞窟(E-9)のErgon Locus（命の聖室）の手前にコロナイズ・レイヴが出ていれば、倒して道を開ける | レイヴが出ていなければ飛ばしてよい。道によってはもう1か所レイヴがある。 | @シルダス洞窟 E-9 #1
g03 go - | シルダス洞窟(E-9)のErgon Locus（命の聖室）に近づき、イベントを見ると完了 | | @シルダス洞窟 E-9 #1 | T obj.270.Ergon_Locus_E-9

@ mission.adoulin.012 https://wiki.ffo.jp/html/29071.html
Q Ortharsyne | オーダーサイン | no
MN SoA2-2-1 13
LK condition:前節「標なき旅」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-2-1;ヨルシア森林に入るとイベント。シルダス洞窟から行くにはフォードとクライムのスキルが要る。前に行ったことがあれば Waypoint やホームポイントでもよい（FFXIclopedia はシルダス洞窟 I-7 の出口）
g01 go - | シルダス洞窟(E-9)のErgon Locus（命の聖室）から、(I-7)のヨルシア森林への出口へ向かう | だいじなもの「フォードスキル」と「クライムスキル」が要る。前にヨルシア森林に行ったことがあれば、この手順は飛ばしてWaypointやホームポイントで入ってもよい。 | @シルダス洞窟 I-7 | K フォードスキル,クライムスキル
g02 go - | ヨルシア森林に入り、イベントを見ると完了 | | @ヨルシア森林

@ mission.adoulin.013 https://wiki.ffo.jp/html/29072.html
Q In the Presence of Royalty | 女王種 | no | T obj.263.Ergon_Locus_I-8
MN SoA2-2-2 14
RW key_item:ロスレーシャの実
RW title:女王の信頼を得し者
LK condition:前節「オーダーサイン」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-2-2;Yorcia's tear は I-8 の南の Ergon Locus ??? か、草刈鎌で Harvesting Point。I-8 の北の Ergon Locus と ??? は違う。G-6 の泉の Pellucid Afflusion で Rosulatia's pome、称号 Queen's Confidante（FFXIclopedia も同じ。茂みの道はヴァナ時間21時に開く）
g01 examine - | ヨルシア森林(I-8)の南側の広場（西から入る）のErgon Locus ???を調べ、だいじなもの「ヨルシアの雫」をもらう | 同じ(I-8)の北側にあるErgon Locusと???は違う。茂みで道がふさがっていることがある。草刈鎌でHarvesting Pointを刈っても手に入るが、出にくい。 | @ヨルシア森林 I-8 | T obj.263.Ergon_Locus_I-8
g02 examine - | ヨルシア森林(G-6)の泉のPellucid Afflusionを調べてイベントを見て、だいじなもの「ロスレーシャの実」をもらうと完了 | | @ヨルシア森林 G-6 | T obj.263.Pellucid_Afflusion = obj:Pellucid Afflusion@ヨルシア森林 G-6 | K ヨルシアの雫

@ mission.adoulin.014 https://wiki.ffo.jp/html/29073.html
Q The Twin World Trees | 双生の世界樹 | no | T npc.257.Oscairn
MN SoA2-3 15
LK condition:前節「女王種」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-3;前の節の翌日まで待ち、東アドゥリン G-7 の Oscairn（PCK.ワークスの入口の北東）に近づくとイベント（FFXIclopedia も同じ）
g01 go - | 前の節からヴァナ時間の0時を過ぎるまで待つ | Oscairnのそばで待っていてもよい。 | W ヴァナ時間の0時を過ぎてから
g02 go - | 東アドゥリン(G-7)のPCK.ワークスの入口の北東にいるOscairnに近づき、イベントを見ると完了 | Oscairnのそばで0時になってもイベントが起きる。 | @東アドゥリン G-7 | T npc.257.Oscairn

@ mission.adoulin.015 https://wiki.ffo.jp/html/29411.html
Q Honor and Audacity | 名誉と意地 | no
MN SoA2-4 16
LK condition:前節「双生の世界樹」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-4;東アドゥリン F-7 からララ水道に入るとイベント（FFXIclopedia も同じ。どの入口でもよいが F-7 が近い）
g01 go - | 東アドゥリン(F-7)の入口からララ水道に入り、イベントを見ると完了 | どの入口から入っても起きるが、次の節にはここが近い。 | @東アドゥリン F-7

@ mission.adoulin.360 https://wiki.ffo.jp/html/28641.html
Q The Watergarden Coliseum | 水園の決闘場 | no | T npc.258.Yeggha_Dolashi
MN SoA2-4-1 17
LK condition:前節「名誉と意地」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-4-1;ララ水道 M-6 の部屋の Yeggha Dolashi。東アドゥリン F-7 の入口が近い（FFXIclopedia も同じ）
g01 talk - | ララ水道(M-6)のYeggha Dolashiに話し、イベントを見ると完了 | 東アドゥリン(F-7)の入口が近い。道中に強いコウモリがいるのでスニークがあるとよい。 | @ララ水道 M-6 | T npc.258.Yeggha_Dolashi

@ mission.adoulin.016 https://wiki.ffo.jp/html/29412.html
Q Friction and Fissures | 同盟の軋轢 | no | T npc.256.Levil
MN SoA2-5 18
LK condition:前節「水園の決闘場」クリア、ヴァナ時間の0時を過ぎた
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-5;翌日まで待って Pioneers' Coalition の Levil（FFXIclopedia も同じ）
g01 go - | 前の節からヴァナ時間の0時を過ぎるまで待つ | | W ヴァナ時間の0時を過ぎてから
g02 talk - | 西アドゥリン(E-8)のPIO.ワークスのLevilに話し、イベントを見ると完了 | | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.017 https://wiki.ffo.jp/html/30101.html
Q The Celennia Memorial Library | セレニア図書館 | no | T npc.257.Eppel-Treppel = npc:Eppel-Treppel@東アドゥリン F-10 G-10
MN SoA2-5-1 19
LK condition:前節「同盟の軋轢」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-5-1;東アドゥリン F-10 の図書館に Eppel-Treppel から入り、棚の History の3つを全部読んで Levil（FFXIclopedia も同じ。Yefafa に話してから。本が読めないときは図書館のクエストが要るとある）
g01 talk - | 東アドゥリン(F-10/G-10)の図書館の階段にいるEppel-Treppelに話して、セレニア図書館に入る | | @東アドゥリン F-10 G-10 | T npc.257.Eppel-Treppel
g02 talk - | 中のYefafaに話してイベントを見る | | @セレニア図書館
g03 examine - | Yefafaの右の棚の「History」を調べ、3つとも読む（「ウルブカ開拓宣言」も読む） | 本が読めないときは、図書館の中のReja Ygridhiのクエストを先に済ませる。 | @セレニア図書館
g04 talk - | 西アドゥリン(E-8)のPIO.ワークスのLevilに話し、イベントを見ると完了 | | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.018 https://wiki.ffo.jp/html/29413.html
Q For Whom Do We Toil? | 我らが仕えし主は…… | no
MN SoA2-5-2 20
RW key_item:開拓反対派の計画の写し
LK condition:前節「セレニア図書館」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-5-2;西アドゥリン F-5 からララ水道に入ってイベント。C-6 の Sluice Gate に合言葉 HGSI（大文字）。答えを間違えたらもう一度 Sluice Gate（FFXIclopedia も同じ。SCT.ワークスの Wegellion のイベントは任意）
g01 go - | 西アドゥリン(F-5)の入口からララ水道に入り、イベントを見る | いちばん近いWaypointはアドゥリン港。 | @西アドゥリン F-5
g02 talk - | （してもしなくてもよい）東アドゥリンのSCT.ワークスのWegellionに話し、合言葉の手がかりのイベントを見る | | @東アドゥリン F-9 | T npc.257.Wegellion
g03 examine - | ララ水道(C-6)のSluice Gateを調べ、合言葉「HGSI」を入れてイベントを見る | 大文字で入れる。イベントの中でもう一度聞かれる。何度も間違えるとしばらく入れられない。 | @ララ水道 C-6 | T obj.258.Sluice_Gate = obj:Sluice Gate@ララ水道 C-6
g04 examine - | だいじなもの「開拓反対派の計画の写し」をもらうと完了。もらえなかったときは、もう一度Sluice Gateを調べてもらう | イベントの中で答えを間違えると、終わったあとにもう一度調べることになる。 | @ララ水道 C-6 | T obj.258.Sluice_Gate

@ mission.adoulin.019 https://wiki.ffo.jp/html/29414.html
Q Aiming for Ygnas | ユグナス暗殺計画 | no | T npc.257.Ploh_Trishbahk
MN SoA2-6 21
LK condition:前節「我らが仕えし主は……」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-6;東アドゥリン K-9 の城門の Ploh Trishbahk。RoV「Tears of the Generals」の途中ならそちらが先に出るので2回話す（FFXIclopedia も同じ）
g01 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、イベントを見ると完了 | ほかのミッションのイベントが先に出たときは、もう一度話す。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk

@ mission.adoulin.020 https://wiki.ffo.jp/html/29415.html
Q Calamity in the Kitchen | 厨房の危機！？ | no | T npc.258.Chalvava
MN SoA2-6-1 22
RW key_item:アドゥリントマト
LK condition:前節「ユグナス暗殺計画」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-6-1;西アドゥリン I-12 の入口からララ水道に入り、F-11 の Chalvava で Box of Adoulinian tomatoes（FFXIclopedia も同じ）
g01 go - | 西アドゥリン(I-12)の入口からララ水道に入り、シビック・アボレタムへ向かう | | @西アドゥリン I-12
g02 talk - | シビック・アボレタム(F-11)のChalvavaに話してイベントを見て、だいじなもの「アドゥリントマト」をもらうと完了 | | @ララ水道 F-11 | T npc.258.Chalvava

@ mission.adoulin.021 https://wiki.ffo.jp/html/29416.html
Q Arciela's Promise | 若姫さまへの贈り物 | no | T npc.257.Ploh_Trishbahk
MN SoA2-6-2 23
LK condition:前節「厨房の危機！？」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-6-2;東アドゥリン K-9 の城門の Ploh Trishbahk（FFXIclopedia も同じ）
g01 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、イベントを見ると完了 | ほかのミッションのイベントが先に出たときは、もう一度話す。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk | K アドゥリントマト

@ mission.adoulin.022 https://wiki.ffo.jp/html/29417.html
Q Predators and Prey | 追われる者と追う者と | no | T obj.258.Sluice_Gate
MN SoA2-7 24
LK condition:前節「若姫さまへの贈り物」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-7;ララ水道 C-6 の Sluice Gate。西アドゥリン F-5 の入口が近い（FFXIclopedia も同じ）
g01 go - | 西アドゥリン(F-5)の入口からララ水道に入る | いちばん近いWaypointはアドゥリン港。 | @西アドゥリン F-5
g02 examine - | 入ってすぐのララ水道(C-6)のSluice Gateを調べ、イベントを見ると完了 | | @ララ水道 C-6 | T obj.258.Sluice_Gate

@ mission.adoulin.023 https://wiki.ffo.jp/html/29418.html
Q Behind the Sluices | 水門の奥へ | no
MN SoA2-7-1 25
LK condition:前節「追われる者と追う者と」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-7-1;ララ水道 H-6 の Storage Container で Waterway facility crank。C-6 の Sluice Gate でイベント、もう一度調べて奥へ、Antiquated Sluice Gate から BF。敵は The Keeper・Mistdagger・The Briars 2体、Arciela が倒れると負け。フェイス可。称号 Princess's Partisan（日本語名はわからない）。FFXIclopedia は Storage Container と Sluice Gate の座標が空欄
g01 examine - | ララ水道(H-6)の通路のStorage Containerを調べ、だいじなもの「水道施設用クランク」をもらう | 西アドゥリン(K-8)のビッグブリッジ近くの入口から入ると近い。スニークがあるとよい。 | @ララ水道 H-6 | T obj.258.Storage_Container = obj:Storage Container@ララ水道 H-6
g02 examine - | ララ水道(C-6)のSluice Gateを調べてイベントを見て、もう一度調べて奥に入る | | @ララ水道 C-6 | T obj.258.Sluice_Gate
g03 fight - | 奥のAntiquated Sluice Gateを調べてBF「水門の奥へ」に入り、The Keeper・Mistdagger・The Briars 2体を倒し、イベントを見ると完了 | アシェラと一緒に戦い、アシェラが倒れると負け。フェイス可。敵はスタンが効かず、いろいろな相手に技を使う。負けたら「水道施設用クランク」をもらい直す。 | K 水道施設用クランク

@ mission.adoulin.024 https://wiki.ffo.jp/html/29419.html
Q The Leafkin Monarch | リフキンの王 | no
MN SoA2-7-2 26
LK condition:前節「水門の奥へ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-7-2;東アドゥリンの城門に近づくとイベント。城門の Waypoint で飛ぶと起きる（FFXIclopedia も同じ）
g01 go - | 東アドゥリン(K-9)のアドゥリン城門に近づき、イベントを見ると完了 | 城門のWaypointで飛んでくると、着いたときにイベントになる。 | @東アドゥリン K-9

@ mission.adoulin.361 https://wiki.ffo.jp/html/27243.html
Q Yggdrasil | ユグドラシル | no | T npc.256.Levil
MN SoA2-7-3 27
LK condition:前節「リフキンの王」クリア、ヴァナ時間の0時を過ぎた
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-7-3;城のイベントの翌日に Pioneers' Coalition の Levil。チケット数と名声の条件があることがある（FFXIclopedia も同じ。イベントが起きないときはワークスコールを済ませる。2025年9月に軽くなった）
g01 go - | 前の節からヴァナ時間の0時を過ぎるまで待つ | | W ヴァナ時間の0時を過ぎてから
g02 talk - | 西アドゥリン(E-8)のPIO.ワークスのLevilに話し、イベントを見ると完了 | 答えはどれでもよい。イベントが起きないときは、ワークスコールをもう少し済ませる。 | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.025 https://wiki.ffo.jp/html/29714.html
Q Return of the Exorcist | エクソシスト帰る | no
MN SoA3-1 28
LK condition:前節「ユグドラシル」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-1;西アドゥリン H-4 の飛空艇乗り場（Waypoint 8）に行くとイベント（FFXIclopedia も同じ）
g01 go - | 西アドゥリン(H-4)の飛空艇乗り場に行き、イベントを見ると完了 | Waypointで飛んでもよい。 | @西アドゥリン H-4

@ mission.adoulin.026 https://wiki.ffo.jp/html/30970.html
Q The Merciless One | イングリッド | no
MN SoA3-1-1 29
LK condition:前節「エクソシスト帰る」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-1-1;東アドゥリンの城門に近づくとイベント。このあと東アドゥリン J-7 の Rigobertine に2回話すとフェイス Ingrid（FFXIclopedia も同じ。「魔物にさらわれし姫君」から「遺剣の導く先」までは取れない）
g01 go - | 東アドゥリン(K-9)のアドゥリン城門に近づき、イベントを見ると完了 | 城門のWaypointで飛んできてもよい。このあと東アドゥリン(J-7)のRigobertineに話すと、フェイスのイングリッドがもらえる（「魔物にさらわれし姫君」から「遺剣の導く先」までのあいだはもらえない）。 | @東アドゥリン K-9

@ mission.adoulin.027 https://wiki.ffo.jp/html/29716.html
Q A Curse from the Past | 呪い | no | T npc.257.Ploh_Trishbahk
MN SoA3-1-2 30
LK condition:前節「イングリッド」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-1-2;Ploh Trishbahk K-9、Rigobertine J-7 で Eternal flame、Fontis Xanira（H-8/9）で Vial of untainted holy water、Sunrise Beacon J-4 で Piece of a stone wall、最後に Erminold J-10 で Weather vane wings（FFXIclopedia も同じ。Fontis Xanira は H-8）
g01 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、要る品を聞く | | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk
g02 talk - | 東アドゥリン(J-7)のRigobertineに話し、だいじなもの「永遠の炎」をもらう | 城門前の広場から北の路地の奥。このイベントを見ないとほかの品はもらえない。 | @東アドゥリン J-7 | T npc.257.Rigobertine
g03 examine - | 西アドゥリン(J-4)のアドゥリン港の灯台のSunrise Beaconを調べ、だいじなもの「石壁の欠片」をもらう | 先に西アドゥリン(I-5)のKongrammに話すとヒントが聞ける。次の手順と順番は逆でもよい。 | @西アドゥリン J-4 | T obj.256.Sunrise_Beacon = obj:Sunrise Beacon@西アドゥリン J-4
g04 examine - | 西アドゥリン(H-8/H-9)の凱旋広場の泉のFontis Xaniraを調べ、だいじなもの「清められた水」をもらう | | @西アドゥリン H-8 H-9 | T obj.256.Fontis_Xanira
g05 talk - | （してもしなくてもよい）東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話す | | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk
g06 talk - | 東アドゥリン(J-10)のErminoldに話し、だいじなもの「風見鶏の羽」をもらうと完了 | 前の3つがそろっていないともらえない。 | @東アドゥリン J-10 | T npc.257.Erminold = npc:Erminold@東アドゥリン J-10 | K 永遠の炎,石壁の欠片,清められた水

@ mission.adoulin.028 https://wiki.ffo.jp/html/29718.html
Q The Purgation | 穢れ祓い | no
MN SoA3-1-3 31
LK condition:前節「呪い」で4つの品をそろえた
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-1-3;4つのだいじなものを持って東アドゥリンの城門に近づくとイベント（FFXIclopedia も同じ）
g01 go - | 4つの品を持って東アドゥリン(K-9)のアドゥリン城門に近づき、イベントを見ると完了 | | @東アドゥリン K-9 | K 永遠の炎,石壁の欠片,清められた水,風見鶏の羽

@ mission.adoulin.029 https://wiki.ffo.jp/html/29719.html
Q The Key | 導く鍵 | no | T npc.256.Levil
MN SoA3-1-4 32
LK condition:前節「穢れ祓い」クリア、ヴァナ時間の0時を過ぎた
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-1-4;翌日まで待って Pioneers' Coalition の Levil（FFXIclopedia も同じ）
g01 go - | 前の節からヴァナ時間の0時を過ぎるまで待つ | | W ヴァナ時間の0時を過ぎてから
g02 talk - | 西アドゥリン(E-8)のPIO.ワークスのLevilに話し、イベントを見ると完了 | | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.030 https://wiki.ffo.jp/html/29720.html
Q The Princess's Dilemma | 若き姫の悩み | no | T npc.257.Eppel-Treppel
MN SoA3-2 33
LK condition:前節「導く鍵」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-2;セレニア図書館に入るとイベント。2つめの「甘いものは好き？」を選ぶ（FFXIclopedia も同じ。RoV の Solemnity が先に出たら、出入りしてもう一度）
g01 go - | 東アドゥリン(F-10/G-10)のEppel-Treppelに話してセレニア図書館に入り、イベントを見ると完了 | 答えは2つめ（甘いもの）を選ぶ。ほかのミッションのイベントが先に出たときは、外に出てもう一度入る。 | @東アドゥリン F-10 G-10 | T npc.257.Eppel-Treppel

@ mission.adoulin.031 https://wiki.ffo.jp/html/29721.html
Q Dark Clouds Ahead | 晴れぬ戸惑い | no | T npc.256.Levil
MN SoA3-2-1 34
LK condition:前節「若き姫の悩み」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-2-1;Pioneers' Coalition の Levil（FFXIclopedia も同じ）
g01 talk - | 西アドゥリン(E-8)のPIO.ワークスのLevilに話し、イベントを見ると完了 | | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.032 https://wiki.ffo.jp/html/29722.html
Q The Smallest of Favors | 小さなお願い | no
MN SoA3-2-2 35
LK condition:前節「晴れぬ戸惑い」クリア、ヴァナ時間の0時を過ぎた
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-2-2;翌日まで待ち、西アドゥリンから歩いてケイザック古戦場に入る。Waypoint は不可（FFXIclopedia も同じ）
g01 go - | 前の節からヴァナ時間の0時を過ぎるまで待つ | | W ヴァナ時間の0時を過ぎてから
g02 go - | 西アドゥリンから歩いてケイザック古戦場に入り、イベントを見ると完了 | Waypointで飛んだときや、ヤッセの狩り場から入ったときは起きない。 | @ケイザック古戦場

@ mission.adoulin.033 https://wiki.ffo.jp/html/29723.html
Q Summoned by Spirits | 精霊に呼ばれし娘 | no | T npc.257.Eppel-Treppel
MN SoA3-3 36
LK condition:前節「小さなお願い」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-3;セレニア図書館に入るとイベント（FFXIclopedia も同じ。入口は Eppel-Treppel）
g01 go - | 東アドゥリン(F-10/G-10)のEppel-Treppelに話してセレニア図書館に入り、イベントを見ると完了 | | @東アドゥリン F-10 G-10 | T npc.257.Eppel-Treppel

@ mission.adoulin.034 https://wiki.ffo.jp/html/29724.html
Q Evil Entities | 悪霊憑き | no | T npc.261.Elmric
MN SoA3-3-1 37
LK condition:前節「精霊に呼ばれし娘」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-3-1;ケイザック古戦場のフロンティア・ステーションの Elmric（FFXIclopedia も同じ）
g01 talk - | ケイザック古戦場(K-7)のフロンティア・ステーションのElmricに話し、イベントを見ると完了 | | @ケイザック古戦場 K-7 | T npc.261.Elmric

@ mission.adoulin.035 https://wiki.ffo.jp/html/29725.html
Q Adoulin Calling | Calling | no | T obj.257.Door_Boarding_House = obj:Door: Boarding House@東アドゥリン H-9
MN SoA3-3-2 38
LK condition:前節「悪霊憑き」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-3-2;東アドゥリン H-9 の女神像（Waypoint 3）の近くの Door: Boarding House。イベントはとても長い（FFXIclopedia も同じ）
g01 examine - | 東アドゥリン(H-9)の女神像の近くのDoor: Boarding Houseを調べ、イベントを見ると完了 | イベントはとても長い。 | @東アドゥリン H-9 | T obj.257.Door_Boarding_House

@ mission.adoulin.036 https://wiki.ffo.jp/html/29726.html
Q The Disappearance of Nyline | 精霊 | no
MN SoA3-3-3 39
LK condition:前節「Calling」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-3-3;エヌティエル水林 J-7/K-7 の Ergon Locus（Torchbloom）に近づくとイベント。フロンティア・ステーションの Waypoint が近い（FFXIclopedia も同じ）
g01 go - | エヌティエル水林のフロンティア・ステーションから東の壁沿いに南へ進む | マウントに乗っていればスニークは要らない。 | @エヌティエル水林
g02 go - | (J-7/K-7)のエルゴン・ローカス「灯の花」に近づいてイベントを見ると完了 | イベントのあとは同じマウントに乗った状態に戻る。 | @エヌティエル水林 J-7 K-7 | T obj.262.Ergon_Locus_J-7

@ mission.adoulin.037 https://wiki.ffo.jp/html/29727.html
Q Shared Consciousness | 意識の共有 | no | T obj.257.Door_Boarding_House
MN SoA3-3-4 40
RW title:雲飛ばす東風
RW exp:1000
RW other:同盟戦績1,000ベヤルド
LK condition:前節「精霊」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-3-4;東アドゥリン H-9 の Door: Boarding House でイベント。称号 Sunshine Cadet、経験値1000、1000 Bayld（FFXIclopedia も同じ）
g01 examine - | 東アドゥリン(H-9)の女神像の近くのDoor: Boarding Houseをもう一度調べ、イベントを見ると完了 | | @東アドゥリン H-9 | T obj.257.Door_Boarding_House

@ mission.adoulin.038 https://wiki.ffo.jp/html/29728.html
Q Clear Skies | 澄み渡る空 | no | T npc.256.Levil
MN SoA3-3-5 41
RW other:同盟戦績100ベヤルド
LK condition:前節「意識の共有」クリア、ヴァナ時間の0時を過ぎた
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-3-5;翌日まで待って Pioneers' Coalition の Levil で 100 Bayld（FFXIclopedia も同じ。アドゥリンの外に一度出る必要があるとある）
g01 go - | 前の節からヴァナ時間の0時を過ぎるまで待つ | | W ヴァナ時間の0時を過ぎてから
g02 talk - | 西アドゥリン(E-8)のPIO.ワークスのLevilに話し、「人を捜している」を選ぶと完了 | イベントが起きないときは、一度アドゥリンの外に出てから話す。 | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.039 https://wiki.ffo.jp/html/30695.html
Q The Man in Black | 気晴らしのススメ | no | T npc.西アドゥリン.Masad
MN SoA3-4 42
LK condition:前節「澄み渡る空」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-4;Mummers' Coalition の Masad で Teodor のイベント。Rhapsody in Azure があれば Curio Vendor Moogle で Card Jailer Teodor を1,000ギルで買い、次のミニゲームを飛ばせる（FFXIclopedia は Masad を G-11 とする）
g01 talk - | 西アドゥリン(G-10)のMUM.ワークスのMasadに話し、Teodorのイベントを見ると完了 | だいじなもの「星唄の煌めき【三奏】」があれば、Curio Vendor Moogleで「これであなたも『お遊戯王』」を買うと次のミニゲームを飛ばせる。ただし先に買うと会話がつながらなくなる。 | @西アドゥリン G-10 | T npc.西アドゥリン.Masad

@ mission.adoulin.040 https://wiki.ffo.jp/html/30696.html
Q To the Victor... | 王の見つめし先は | no | T npc.西アドゥリン.Masad
MN SoA3-4-1 43
RW title:お遊戯王
LK condition:前節「気晴らしのススメ」のイベントで始まる
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-4-1;Teodor にミニゲーム Boom or Bust で3回勝つ。負けたら Masad に2回話して再戦。称号 Boomy and Busty（FFXIclopedia も同じ。合計11を超えると負け。Card Jailer Teodor があれば自動で勝つ）
g01 talk - | 西アドゥリン(G-10)のMUM.ワークスのMasadに話して「勝負する！」を選び、Teodorとバーサスロール11で勝負する | 「これであなたも『お遊戯王』」を持っていれば勝負しなくてよい。 | @西アドゥリン G-10 | T npc.西アドゥリン.Masad
g02 talk - | 先に3回勝つまで勝負し、イベントを見ると完了 | 合計が11を超えるとバストで負け。トリック（相手の目を見る・目を入れ替える・振り直させる）は1回の勝負に1つ使える。負けたらMasadに話してすぐやり直せる。 | @西アドゥリン G-10 | T npc.西アドゥリン.Masad

@ mission.adoulin.041 https://wiki.ffo.jp/html/30697.html
Q An Extraordinary Gentleman | 王の見つめし先は～紳士の導き | no | T npc.256.Levil
MN SoA3-4-2 44
LK condition:前節「王の見つめし先は」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-4-2;Pioneers' Coalition の Levil で1つめの「Ortharsyne」を選ぶ。イベントが起きないときは Masad にもう一度話す（FFXIclopedia も同じ）
g01 talk - | （してもしなくてもよい）前の節を「これであなたも『お遊戯王』」で飛ばしたときは、西アドゥリン(G-10)のMUM.ワークスのMasadに一度話す | 勝負して勝ったときは要らない。 | | @西アドゥリン G-10 | T npc.西アドゥリン.Masad
g02 talk - | 西アドゥリン(E-8)のPIO.ワークスのLevilに話し、「オーダーサイン」を選ぶと完了 | イベントが起きないときは、Masadに話してからもう一度。 | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.042 https://wiki.ffo.jp/html/30698.html
Q The Order's Treasures | 英知の宝庫 | no | T npc.257.Eppel-Treppel
MN SoA3-4-3 45
LK condition:前節「王の見つめし先は～紳士の導き」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-4-3;セレニア図書館に入るとイベント（FFXIclopedia も同じ）
g01 go - | 東アドゥリン(F-10/G-10)のEppel-Treppelに話してセレニア図書館に入り、イベントで答えを全部選ぶと完了 | 選ぶ順番はどれでもよい。 | @東アドゥリン F-10 G-10 | T npc.257.Eppel-Treppel

@ mission.adoulin.043 https://wiki.ffo.jp/html/30699.html
Q August's Heirloom | オーグスト王と残されし剣 | no | T npc.257.Ploh_Trishbahk
MN SoA3-4-4 46
LK condition:前節「英知の宝庫」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-4-4;東アドゥリン K-9 の城門の Ploh Trishbahk（FFXIclopedia も同じ）
g01 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、イベントを見ると完了 | 答えはどれでもよい。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk

@ mission.adoulin.044 https://wiki.ffo.jp/html/30701.html
Q Beauty and the Beast | 魔物にさらわれし姫君 | no | T obj.261.Signs_of_a_Struggle = obj:Signs of a Struggle@ケイザック古戦場 J-8
MN SoA3-5 47
RW key_item:アシェラのボンネ
LK condition:前節「オーグスト王と残されし剣」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-5;ケイザック古戦場 I-7/J-8 の分かれ道の Signs of Struggle で Pristine hair ribbon。フロンティア・ステーションの南西（FFXIclopedia は J-8 の木のそば）
g01 go - | ケイザック古戦場のフロンティア・ステーションから右の壁沿いに南へ進む | 夜はアンブリル族が出るので、インビジかマウントがあるとよい。 | @ケイザック古戦場
g02 examine - | (J-8)の木のそばのSigns of a Struggleを調べてイベントを見て、だいじなもの「アシェラのボンネ」をもらうと完了 | この節を始めると、「遺剣の導く先」まではフェイスのイングリッドがもらえない。 | @ケイザック古戦場 J-8 | T obj.261.Signs_of_a_Struggle

@ mission.adoulin.045 https://wiki.ffo.jp/html/30702.html
Q Wildcat with a Gold Pelt | 金虎 | no
MN SoA3-5-1 48
LK condition:前節「魔物にさらわれし姫君」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-5-1;東アドゥリンの城門に近づくとイベント（FFXIclopedia も同じ。Ploh Trishbahk のイベントは次の節の任意のもの）
g01 go - | 東アドゥリン(K-9)のアドゥリン城門に近づき、イベントを見ると完了 | 答えはどれでもよい。 | @東アドゥリン K-9

@ mission.adoulin.046 https://wiki.ffo.jp/html/30704.html
Q In Search of Arciela | アシェラ捜索隊 | no | T npc.256.Levil
MN SoA3-5-2 49
LK condition:前節「金虎」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-5-2;Pioneers' Coalition の Levil（FFXIclopedia も同じ。その前に Ploh Trishbahk に話すと任意のイベント）
g01 talk - | （してもしなくてもよい）東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、イングリッドのイベントを見る | 見なくても記憶のウタイビトで見られる。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk
g02 talk - | 西アドゥリン(E-8)のPIO.ワークスのLevilに話し、「金色の虎のこと」を選ぶと完了 | | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.047 https://wiki.ffo.jp/html/30705.html
Q Looking For Leads | 情報のことなら…… | no | T npc.257.Wegellion
MN SoA3-5-3 50
RW key_item:誘獣の鈴
LK condition:前節「アシェラ捜索隊」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-5-3;Scouts' Coalition（Waypoint 2）の Wegellion に近づくとイベントで Tintinnabulum（FFXIclopedia にこの節のページがない）
g01 go - | 東アドゥリン(F-9)のSCT.ワークスのWegellionに近づき、イベントを見て、だいじなもの「誘獣の鈴」をもらうと完了 | | @東アドゥリン F-9 | T npc.257.Wegellion

@ mission.adoulin.048 https://wiki.ffo.jp/html/30706.html
Q Drifting Northwest | 北西の地カミール | no
MN SoA3-6 51
RW title:絶零の開拓者
LK condition:前節「情報のことなら……」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-6;カミール山麓に入るとイベント。ウォーの門・ホームポイント・Waypoint のどれでもよい。称号 Weatherer of Brumal Climes（FFXIclopedia も同じ。初めてはヨルシア森林からウォーの門を通る）
g01 go - | カミール山麓に入り、イベントを見ると完了 | 初めてのときは、ヨルシア森林からウォーの門を通って入る。前に行ったことがあればホームポイントやWaypointでもよい。次の節にはフロンティア・ビバック#2が近い。 | @カミール山麓

@ mission.adoulin.049 https://wiki.ffo.jp/html/30707.html
Q Kumhau, the Flashfrost Naakual | 絶零公クムハウ | no | T obj.267.Crawling_Cave = obj:Crawling Cave@カミール山麓 F-11
MN SoA3-6-1 52
RW key_item:金色の毛
LK condition:前節「北西の地カミール」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-6-1;カミール山麓 F-11 の Crawling Cave で Aureate ball of fur。フロンティア・ビバック#2 から西のトンネルを出て北、G-10 の北の洞窟を抜ける（FFXIclopedia も同じ）
g01 go - | （してもしなくてもよい）東アドゥリン(K-9)のアドゥリン城門に近づいてイベントを見る | 記憶のウタイビトで見られる。 | @東アドゥリン K-9
g02 talk - | （してもしなくてもよい）西アドゥリン(E-8)のPIO.ワークスのLevilに話してイベントを見る | 記憶のウタイビトで見られる。 | @西アドゥリン E-8 | T npc.256.Levil
g03 examine - | カミール山麓(F-11)のCrawling Caveを調べてイベントを見て、だいじなもの「金色の毛」をもらうと完了 | フロンティア・ビバック#2から西のトンネルを出て北へ進み、(G-10)の北の洞窟を抜けて南西へ。答えはどれでもよい。 | @カミール山麓 F-11 | T obj.267.Crawling_Cave

@ mission.adoulin.050 https://wiki.ffo.jp/html/30708.html
Q Soul Siphon | 吸魂石 | no | T obj.267.Hollowed_Pathway = obj:Hollowed Pathway@カミール山麓 G-11
MN SoA3-6-2 53
LK condition:前節「絶零公クムハウ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-6-2;カミール山麓 G-11 の南西の Hollowed Pathway で「Proceed」を選ぶとイベント（BF には入らない。FFXIclopedia も同じ。シルダス洞窟に移ってイベントのあと戻る）
g01 go - | 前の節のCrawling Caveから右の壁沿いに回り、カミール山麓(G-11)の南西の壁のHollowed Pathwayへ行く | マウントで回るとよい。 | @カミール山麓 G-11
g02 examine - | Hollowed Pathwayを調べ、「先へ進みますか？」で「はい」を選んでイベントを見ると完了 | ここではまだ戦わない。 | @カミール山麓 G-11 | T obj.267.Hollowed_Pathway

@ mission.adoulin.051 https://wiki.ffo.jp/html/30709.html
Q Stonewalled | 第三の敵 | no | T obj.267.Hollowed_Pathway
MN SoA3-6-3 54
RW key_item:吸魂石
LK condition:前節「吸魂石」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-6-3;Hollowed Pathway をもう一度調べて BF「Stonewalled」。30分、フェイス可。Primogenial Marolith だけ倒せば勝ち、Gargouille Drudge が次々に来る。負けたら Crawling Cave で Aureate ball of fur を取り直す（FFXIclopedia も同じ）
g01 examine - | カミール山麓(G-11)のHollowed Pathwayをもう一度調べる | | @カミール山麓 G-11 | T obj.267.Hollowed_Pathway
g02 fight - | BF「第三の敵」に入り、Primogenial Marolithを倒してイベントを見て、だいじなもの「吸魂石」をもらうと完了 | 30分・フェイス可。入ると食事以外の強化が消える。Gargouille Drudgeが次々に来るが、倒すのはMarolithだけでよい。負けたらカミール山麓(F-11)のCrawling Caveで「金色の毛」をもらい直す。 | K 金色の毛

@ mission.adoulin.052 https://wiki.ffo.jp/html/30710.html
Q Salvation | アシェラの下へ | no | T obj.267.Crawling_Cave
MN SoA3-6-4 55
RW title:姫を救いし勇者
LK condition:前節「第三の敵」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-6-4;カミール山麓 F-11 の Crawling Cave でイベント。3つめの答えを選ぶ。称号 White Knight（FFXIclopedia も同じ）
g01 examine - | カミール山麓(F-11)のCrawling Caveを調べ、イベントを見ると完了 | 答えは3つめ（剣を握る手）を選ぶ。BFのあとワープしないでそのまま向かうと近い。 | @カミール山麓 F-11 | T obj.267.Crawling_Cave | K 吸魂石

@ mission.adoulin.053 https://wiki.ffo.jp/html/30711.html
Q Glimmer of Portent | 遺剣の導く先 | no | T npc.256.Levil
MN SoA3-6-5 56
LK condition:前節「アシェラの下へ」クリア、ヴァナ時間の0時を過ぎた
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_3-6-5;翌日まで待って Pioneers' Coalition の Levil。フェイス Ingrid をまだもらっていなければ、東アドゥリン J-7 の Rigobertine でもらえるようになる（FFXIclopedia も同じ。名声が要ることがある）
g01 go - | 前の節からヴァナ時間の0時を過ぎるまで待つ | | W ヴァナ時間の0時を過ぎてから
g02 talk - | 西アドゥリン(E-8)のPIO.ワークスのLevilに話し、イベントを見ると完了 | イベントが起きないときは、名声をもう少し上げる。フェイスのイングリッドをまだもらっていなければ、東アドゥリン(J-7)のRigobertineでもらえる。 | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.055 https://wiki.ffo.jp/html/31301.html
Q ...Into the Fire | 新たな問題 | no | T npc.256.Kipligg = npc:Kipligg@西アドゥリン G-7
MN SoA4-1 57
LK condition:前節「遺剣の導く先」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-1;Couriers' Coalition の入口の Kipligg。アドゥリン港へ行くよう頼まれる（FFXIclopedia は G-7）
g01 talk - | 西アドゥリン(G-7)のCOU.ワークスの入口のKipliggに話し、イベントを見ると完了 | | @西アドゥリン G-7 | T npc.256.Kipligg

@ mission.adoulin.362 https://wiki.ffo.jp/html/28636.html
Q Melvien de Malecroix | メルヴィアン | no | T obj.256.Port_Storage = obj:Port Storage@西アドゥリン J-4
MN SoA4-1-1 58
LK condition:前節「新たな問題」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-1-1;アドゥリン港（Waypoint 9）の J-4 の Port Storage でイベント。持ってくる品が言われる（FFXIclopedia は座標が空欄）
g01 examine - | 西アドゥリン(J-4)のアドゥリン港のPort Storageを調べ、イベントを見ると完了 | アドゥリン港のWaypointが近い。イベントで次に持ってくる品を言われる。 | @西アドゥリン J-4 | T obj.256.Port_Storage

@ mission.adoulin.056 https://wiki.ffo.jp/html/31302.html
Q Courier Catastrophe | 足りない品は…… | no | T obj.256.Port_Storage
MN SoA4-1-2 59
LK condition:前節「メルヴィアン」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-1-2;言われた品（Eft Skin 5・Manticore Hair 4・Buffalo Horn・Manticore Leather・Buffalo Leather のどれか。アシェラとの仲で決まり、Buffalo Horn がいちばん低い）を Port Storage にトレード（FFXIclopedia も同じ。競売で買える）
g01 gather - | 前の節のイベントで言われた品を用意する（エフトの皮5枚・有翼獅子のたてがみ4つ・野牛の角1つ・有翼獅子のなめし革1枚・野牛のなめし革1枚のどれか） | どれになるかはアシェラとの仲で決まる。どれも競売で買える。
g02 trade - | 西アドゥリン(J-4)のアドゥリン港のPort Storageに品をトレードし、イベントを見ると完了 | | @西アドゥリン J-4 | T obj.256.Port_Storage

@ mission.adoulin.057 https://wiki.ffo.jp/html/31303.html
Q Done and Delivered | 納品完了 | no | T npc.256.Kipligg
MN SoA4-1-3 60
LK condition:前節「足りない品は……」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-1-3;Couriers' Coalition の入口の Kipligg（FFXIclopedia も同じ）
g01 talk - | 西アドゥリン(G-7)のCOU.ワークスの入口のKipliggに話し、イベントを見ると完了 | | @西アドゥリン G-7 | T npc.256.Kipligg

@ mission.adoulin.058 https://wiki.ffo.jp/html/31304.html
Q Ministerial Whispers | 財務大臣の噂 | no | T npc.256.Levil
MN SoA4-1-4 61
RW other:同盟戦績500ベヤルド
LK condition:前節「納品完了」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-1-4;Pioneers' Coalition の Levil で 500 Bayld（FFXIclopedia も同じ）
g01 talk - | 西アドゥリン(E-8)のPIO.ワークスのLevilに話し、イベントを見ると完了 | | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.059 https://wiki.ffo.jp/html/31308.html
Q A Day in the Life of a Pioneer | とある開拓の日常 | no | T npc.256.Levil
MN SoA4-1-5 62
LK condition:前節「財務大臣の噂」クリア、ヴァナ時間の0時を過ぎた
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-1-5;エリアを移って翌日まで待ち、Pioneers' Coalition の Levil。選択肢は「What happened after that?」（FFXIclopedia も同じ）
g01 go - | 前の節からヴァナ時間の0時を過ぎるまで待ち、エリアを出入りする | | W ヴァナ時間の0時を過ぎてエリアを出入りしてから
g02 talk - | 西アドゥリン(E-8)のPIO.ワークスのLevilに話し、イベントを見ると完了 | 選択肢は話の続きを聞くほうを選ぶ。 | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.060 https://wiki.ffo.jp/html/31310.html
Q Lighting the Way | 光の道 | no | T obj.267.Alpine_Trail
MN SoA4-2 63
RW title:無知なる知者
LK condition:前節「とある開拓の日常」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-2;カミール山麓 H-5 の Alpine Trail を調べてカミール山へ。フロンティア・ビバック#3 から北のトンネルを左の壁沿い。ホームポイントも近い。称号 Knower of Untruths（FFXIclopedia は座標が空欄。イベントのあとはカミール山麓に戻される）
g01 go - | カミール山麓のフロンティア・ビバック#3から北のトンネルに入り、左の壁沿いに北へ進む | カミール山麓のホームポイントからも近い。 | @カミール山麓
g02 examine - | カミール山麓(H-5)のAlpine Trailを調べて「はい」を選び、カミール山でイベントを見ると完了 | マップの北の真ん中。イベントのあとはカミール山麓に戻される。 | @カミール山麓 H-5 | T obj.267.Alpine_Trail

@ mission.adoulin.061 https://wiki.ffo.jp/html/31313.html
Q Sajj'aka | ハーサーカ | no | T npc.257.Eppel-Treppel
MN SoA4-2-1 64
LK condition:前節「光の道」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-2-1;セレニア図書館に入るとイベント。イベントの中の話を全部読む（FFXIclopedia にこの節のページがない）
g01 go - | 東アドゥリン(F-10/G-10)のEppel-Treppelに話してセレニア図書館に入り、イベントを見ると完了 | イベントの中で話を全部選んで読む。 | @東アドゥリン F-10 G-10 | T npc.257.Eppel-Treppel

@ mission.adoulin.062 https://wiki.ffo.jp/html/31316.html
Q Studying Up | 図書館にて | no | T obj.267.Alpine_Trail
MN SoA4-2-2 65
LK condition:前節「ハーサーカ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-2-2;Alpine Trail をもう一度調べてイベント。答えは Yorcia Weald・Morimar・The Serpentine Labyrinth、そのあと Yes it does.・Who are "They"?・Unleash a feral scream.・What are you proposing?（FFXIclopedia は最初の3つだけ）
g01 examine - | カミール山麓(H-5)のAlpine Trailをもう一度調べて「はい」を選び、イベントを見る | フロンティア・ビバック#3から北のトンネルを左の壁沿い。 | @カミール山麓 H-5 | T obj.267.Alpine_Trail
g02 examine - | ハーサーカの問いに全部正しく答え、イベントを見ると完了 | 答えは「ヨルシア森林」「モリマー」「大冥宮」。そのあとの問いも続くので、話を進めるほうを選ぶ。 | @カミール山麓 H-5 | T obj.267.Alpine_Trail

@ mission.adoulin.063 https://wiki.ffo.jp/html/31321.html
Q A Vow of Truth | 誓いの真実と汚された鱗 | no
MN SoA4-2-3 66
LK condition:前節「図書館にて」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-2-3;どの入口からでもウォーの門に入るとイベント。カミール山麓のフロンティア・ステーションから南の K-11 の入口が近い。街からならマリアミ渓谷の Waypoint 4 から北西（FFXIclopedia も同じ）
g01 go - | ウォーの門に入り、イベントを見ると完了 | どの入口からでもよい。カミール山麓のフロンティア・ステーションから南へ行った(K-11)の入口が近く、次の節にも行きやすい。 | @ウォーの門

@ mission.adoulin.064 https://wiki.ffo.jp/html/31325.html
Q Darrcuiln | ダラクァルンの導き | no | T obj.273.Darkened_Crevice = obj:Darkened Crevice@ウォーの門 G-7 G-8 #1
MN SoA4-2-4 67
RW key_item:金色の髭
LK condition:前節「誓いの真実と汚された鱗」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-2-4;ウォーの門 G-7/G-8 の境のトンネルの少し中の Darkened Crevice で Tuft of golden fur。カミール山麓側からは I-5・H-6 で飛び降りる。マリアミ渓谷側からは左の壁沿いで H-7 のコロナイズ・レイヴを抜ける。大部屋の手前でスニーク・インビジ（FFXIclopedia は 4-3 で G-8）
g01 go - | ウォーの門MAP1の大部屋を通って、(G-7/G-8)の境のトンネルへ向かう | カミール山麓側から入ったら(I-5)と(H-6)で飛び降りる。マリアミ渓谷側から入ったら左の壁沿いに進み、(H-7)のコロナイズ・レイヴを抜ける。大部屋の手前で、離れたところからスニークとインビジをかけておく。 | @ウォーの門 G-7 G-8 #1
g02 examine - | (G-7/G-8)の境のDarkened Creviceを調べてイベントを見て、だいじなもの「金色の髭」をもらうと完了 | トンネルの少し中、下り坂の手前。 | @ウォーの門 G-7 G-8 #1 | T obj.273.Darkened_Crevice

@ mission.adoulin.065 https://wiki.ffo.jp/html/26400.html
Q The Gates | 門 | no | T obj.273.Darkened_Crevice
MN SoA4-3 68
LK condition:前節「ダラクァルンの導き」で「金色の髭」をもらった
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-3;ウォーの門 G-8 の Darkened Crevice から BF「The Gates」。アンブリル族の群れと戦い、Arciela・Darrcuiln・Noble Warrior・Resolute Leafkin のだれかが倒れると負け。ソロ可、約1分で始まる。FFXIclopedia：Tuft of golden fur は入ると消え、負けたらウォーの門 K-8/K-9 の Large Animal Track で取り直す。称号 Ulbukan Understudy（シートには称号の記載なし）
g01 examine - | だいじなもの「金色の髭」を持って、ウォーの門(G-8)のDarkened Creviceを調べる | | @ウォーの門 G-7 G-8 #1 | T obj.273.Darkened_Crevice | K 金色の髭
g02 fight - | BF「門」に入り、アンブリル族の群れを倒してイベントを見ると完了 | フェイス可・30分。入って約1分で始まるので、すぐにフェイスを呼ぶ。味方のアシェラ・ダラクァルン・モリマー・リフキンのだれかが倒れると負け。入ると「金色の髭」はなくなり、負けたらウォーの門(K-8/K-9)のLarge Animal Trackで取り直す。 | K 金色の髭

@ mission.adoulin.066 https://wiki.ffo.jp/html/31333.html
Q Morimar | モリマー | no | T obj.267.Alpine_Trail
MN SoA4-3-1 69
RW key_item:ハーサーカの加護
LK condition:前節「門」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-3-1;カミール山麓 H-5 の Alpine Trail をもう一度調べる。Sajj'aka's protective ward（FFXIclopedia にこの節のページがない）
g01 examine - | カミール山麓(H-5)のAlpine Trailをもう一度調べて「はい」を選び、イベントを見て、だいじなもの「ハーサーカの加護」をもらうと完了 | フロンティア・ビバック#3から北のトンネルを左の壁沿い。 | @カミール山麓 H-5 | T obj.267.Alpine_Trail

@ mission.adoulin.067 https://wiki.ffo.jp/html/31334.html
Q A New Force Arises | 新しき力 | no | T obj.267.Liseran_Door_Entrance = obj:Liseran Door: Entrance@カミール山麓 F-8
MN SoA4-3-2 70
RW key_item:世界樹の若木
LK condition:前節「モリマー」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-3-2;カミール山麓 F-8 の Liseran Door: Entrance からラ・カザナル宮外郭へ。Upstairs（Map 1）I-11 の Effigy of Sealing で Starblessed scale、C-7 で Silvery plate（I-6 のエレベーターに要る）、H-2 の Effigy of Sealing で Moontouched scale、Basement（Map 2）C-8 の Demonic Architrave で Sunkissed scale。途中のコロナイズ・レイヴには Lerene のクエストの Pulverize が要る。1つ取るたびに Alpine Trail と図書館で任意のイベント（FFXIclopedia も同じ）
g01 go - | カミール山麓(F-8)のLiseran Door: Entranceからラ・カザナル宮外郭に入る | 謎の魔導器が開いていればWaypointから飛べる。途中のコロナイズ・レイヴにはだいじなもの「パルバライズスキル」が要る。ないときは、ラ・カザナル宮外郭(N-7)のLereneのクエスト「魔力断絶の学識」で手に入れる。 | @カミール山麓 F-8 | T obj.267.Liseran_Door_Entrance
g02 examine - | ラ・カザナル宮外郭(I-11)の上層のEffigy of Sealingを調べ、だいじなもの「星の鱗」をもらう | 上層(L-8)のEntwined Rootsから下層へ降り、(J-10)のレイヴを抜けて(H-9)のVertical Transit Deviceで上層へ上がる。 | @ラ・カザナル宮外郭 I-11 #1 | T obj.274.Effigy_of_Sealing_I-11 = obj:Effigy of Sealing@ラ・カザナル宮外郭 I-11 #1 | K パルバライズスキル
g03 examine - | ラ・カザナル宮外郭(C-7)の上層のSilvery Plateを調べ、だいじなもの「銀白色の札」をもらう | 次の鱗へ行く前に取っておく。最後の鱗へ行くエレベーターに要る。 | @ラ・カザナル宮外郭 C-7 #1 | T obj.274.Silvery_Plate = obj:Silvery Plate@ラ・カザナル宮外郭 C-7 #1
g04 examine - | ラ・カザナル宮外郭(H-2)の上層のEffigy of Sealingを調べ、だいじなもの「月の鱗」をもらう | 上層(E-8)のEntwined Rootsから下層へ降り、(H-8)の西のVertical Transit Deviceで上層へ上がる。 | @ラ・カザナル宮外郭 H-2 #1 | T obj.274.Effigy_of_Sealing_H-2 = obj:Effigy of Sealing@ラ・カザナル宮外郭 H-2 #1
g05 examine - | 上層(I-6)のVertical Transit Deviceで下層へ降り、ラ・カザナル宮外郭(C-8)の下層のDemonic Architraveを調べ、だいじなもの「太陽の鱗」をもらう | 下層(F-6/G-6)のレイヴを抜ける。鱗を1つ取るたびに、Alpine Trailとセレニア図書館で短いイベントが見られる（見なくてもよい）。 | @ラ・カザナル宮外郭 C-8 #2 | T obj.274.Demonic_Architrave = obj:Demonic Architrave@ラ・カザナル宮外郭 C-8 #2 | K 銀白色の札
g06 examine - | カミール山麓(H-5)のAlpine Trailを調べて「はい」を選び、イベントを見て、だいじなもの「世界樹の若木」をもらうと完了 | フロンティア・ビバック#3かホームポイントが近い。 | @カミール山麓 H-5 | T obj.267.Alpine_Trail | K 星の鱗,月の鱗,太陽の鱗

@ mission.adoulin.068 https://wiki.ffo.jp/html/31336.html
Q The Sacred Sapling | 世界樹の若木 | no | T npc.257.Ploh_Trishbahk
MN SoA4-3-3 71
LK condition:前節「新しき力」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-3-3;城門の Ploh Trishbahk（BG Wiki は L-9）。選択肢は Tree Grafting（FFXIclopedia も同じ）
g01 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、「ツギキ」を選んでイベントを見ると完了 | | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk | K 世界樹の若木

@ mission.adoulin.069 https://wiki.ffo.jp/html/31337.html
Q Tree Grafting | 接ぎ木 | no | T npc.256.Levil
MN SoA4-3-4 72
LK condition:前節「世界樹の若木」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-3-4;Pioneers' Coalition の Levil（FFXIclopedia も同じ）
g01 talk - | 西アドゥリン(E-8)のPIO.ワークスのLevilに話し、イベントを見ると完了 | | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.070 https://wiki.ffo.jp/html/31341.html
Q A Shrouded Canopy | 幻の森 | no | T obj.267.Blockaded_Path = obj:Blockaded Path@カミール山麓 G-11
MN SoA4-3-5 73
LK condition:前節「接ぎ木」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-3-5;カミール山麓 G-11（F-11 寄り）の Blockaded Path を調べてリファーリアへ。フロンティア・ビバック#2 が近い。Hollowed Pathway の南東（FFXIclopedia は北）
g01 go - | カミール山麓のフロンティア・ビバック#2から北へ進み、(G-11)の西へ向かう | 「第三の敵」のHollowed Pathwayのすぐ近く。 | @カミール山麓 G-11
g02 examine - | (G-11)のBlockaded Pathを調べてリファーリアに入り、イベントを見ると完了 | 岩でふさがれた小さな道。 | @カミール山麓 G-11 | T obj.267.Blockaded_Path

@ mission.adoulin.071 https://wiki.ffo.jp/html/31346.html
Q Leafallia | リファーリア | no | T obj.281.Aged_Stump = obj:Aged Stump@リファーリア H-8
MN SoA4-3-6 74
LK condition:前節「幻の森」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-3-6;リファーリア H-8 の Aged Stump（FFXIclopedia にこの節のページがない）
g01 examine - | リファーリア(H-8)の北西のAged Stumpを調べ、イベントを見ると完了 | | @リファーリア H-8 | T obj.281.Aged_Stump

@ mission.adoulin.072 https://wiki.ffo.jp/html/31348.html
Q Rosulatia's Promise | ロスレーシャ、再び | no | T obj.281.Heroic_Footprints = obj:Heroic Footprints@リファーリア H-8
MN SoA4-3-7 75
RW title:ウルブカの守護者
LK condition:前節「リファーリア」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-3-7;Aged Stump の向かい、小川を渡った木のそばの Heroic Footprints。長いイベント。称号 Keeper of Ulbuka（FFXIclopedia も同じ。もう一度調べると Morimar の短いイベント）
g01 examine - | リファーリア(H-8)のHeroic Footprintsを調べ、イベントを見ると完了 | Aged Stumpに向いて後ろ、小川を渡った木のそば。イベントは長い。答えはどちらでもよい。 | @リファーリア H-8 | T obj.281.Heroic_Footprints

@ mission.adoulin.073 https://wiki.ffo.jp/html/31349.html
Q The Lightsland | 再生 | no | T npc.257.Ploh_Trishbahk
MN SoA4-3-8 76
RW item:レフージネックレス／リゾールブマフラー／グレースカラー のどれか1つ
RW exp:500
RW title:暁の光
LK condition:前節「ロスレーシャ、再び」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-3-8;城門の Ploh Trishbahk で首装備を1つ選ぶ（Adoulin's Refuge・Arciela's Grace・Ygnas's Resolve）。FFXIclopedia：経験値500、称号 Radiance of Daybreak。捨てると「悲劇の後」が進められない
g01 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、イベントで首装備を1つ選んでもらうと完了 | もらった首装備は捨てない。あとの「悲劇の後」で要る。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk

@ mission.adoulin.074 https://wiki.ffo.jp/html/31350.html
Q The Light of Dawn Comes from the East | 暁の光は東より来たる | no | T npc.256.Levil
MN SoA4-3-9 77
LK condition:前節「再生」クリア、ヴァナ時間の0時を過ぎた
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-3-9;翌日まで待って Pioneers' Coalition の Levil。次の節が自動で始まる。BG Wiki は報酬を経験値500とする（シートは前節）
g01 examine - | （してもしなくてもよい）リファーリア(H-8)のHeroic Footprintsをもう一度調べ、モリマーのイベントを見る | | @リファーリア H-8 | T obj.281.Heroic_Footprints
g02 go - | 前の節からヴァナ時間の0時を過ぎるまで待つ | | W ヴァナ時間の0時を過ぎてから
g03 talk - | 前の節でもらった首装備を持って、西アドゥリン(E-8)のPIO.ワークスのLevilに話し、イベントを見ると完了 | | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.075 https://wiki.ffo.jp/html/31706.html
Q Cries from the Deep | 冥宮からの声 | no
MN SoA4-4 78
LK condition:前節「暁の光は東より来たる」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-4;東アドゥリン K-9 の城門に近づくとイベント（FFXIclopedia も同じ）
g01 go - | 東アドゥリン(K-9)のアドゥリン城門に近づき、イベントを見ると完了 | 城門のWaypointで飛んできてもよい。 | @東アドゥリン K-9

@ mission.adoulin.076 https://wiki.ffo.jp/html/31707.html
Q Seeds of Doubt | 陰謀の疑惑 | no | T npc.258.Chalvava
MN SoA4-4-1 79
LK condition:前節「冥宮からの声」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-4-1;西アドゥリン I-12 の入口からララ水道に入り、F-11 の Chalvava。Waypoint #6（Rent-a-Room）が近い（FFXIclopedia は F-10/F-11）
g01 go - | 西アドゥリン(I-12)の入口からララ水道に入り、シビック・アボレタムへ向かう | いちばん近いWaypointはレンタルハウス前。 | @西アドゥリン I-12
g02 talk - | シビック・アボレタム(F-11)のChalvavaに話し、イベントを見ると完了 | 入口から少し歩いたところ。 | @ララ水道 F-11 | T npc.258.Chalvava

@ mission.adoulin.077 https://wiki.ffo.jp/html/31708.html
Q The Tomatoes of Wrath | 瑞々しいトマトたち | no | T npc.257.Ploh_Trishbahk
MN SoA4-4-2 80
LK condition:前節「陰謀の疑惑」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-4-2;城門の Ploh Trishbahk で長いイベント（FFXIclopedia にこの節のページがない）
g01 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、イベントを見ると完了 | イベントは長い。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk

@ mission.adoulin.078 https://wiki.ffo.jp/html/31709.html
Q A Grave Mistake | 墓所の秘密 | no | T npc.257.Ploh_Trishbahk
MN SoA4-4-3 81
LK condition:前節「瑞々しいトマトたち」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-4-3;ララ水道の3か所（Sainene N-7・Waterway Overlook I-6・Stout Weir D-8）はどの順でもよい。Stout Weir で Broken fuse。東アドゥリン F-7 の入口から入ると K-5 に出て、2か所が近い（FFXIclopedia も I-6。シートは Waterways Overlook を J-6 と I-6 の境とする）
g01 go - | 東アドゥリン(F-7)の入口からララ水道に入る | 入ると(K-5)に出て、Waterways OverlookとSaineneが近い。 | @東アドゥリン F-7
g02 examine - | ララ水道(I-6)の行き止まりのWaterways Overlookを調べる | この手順と次の2つの手順は、どの順でもよい。 | @ララ水道 I-6 | T obj.258.Waterways_Overlook = obj:Waterways Overlook@ララ水道 I-6
g03 talk - | ララ水道(N-7)のSaineneに話す | 近くにクモがいるので気をつける。 | @ララ水道 N-7 | T npc.258.Sainene = npc:Sainene@ララ水道 N-7
g04 talk - | ララ水道(D-8)のStout Weirに話し、だいじなもの「信管の破片」をもらう | 西アドゥリン(I-12)の入口からも近い。 | @ララ水道 D-8 | T npc.258.Stout_Weir = npc:Stout Weir@ララ水道 D-8
g05 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、イベントを見ると完了 | | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk

@ mission.adoulin.079 https://wiki.ffo.jp/html/31710.html
Q An Emergency Convocation | 緊急十二家会 | no | T npc.257.Ploh_Trishbahk
MN SoA4-4-4 82
LK condition:前節「墓所の秘密」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-4-4;東アドゥリンを出入りしてから城門の Ploh Trishbahk で長いイベント（FFXIclopedia も同じ）
g01 go - | 東アドゥリンからいったん別のエリアへ出て、もう一度入る | | @東アドゥリン
g02 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、イベントを見ると完了 | イベントはとても長い（10分以上）ので、時間のあるときに。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk

@ mission.adoulin.080 https://wiki.ffo.jp/html/31711.html
Q Balamor, the Deathborne Xol | 不死君バラモア | no | T npc.257.Ploh_Trishbahk
MN SoA4-5 83
LK condition:前節「緊急十二家会」クリア、ヴァナ時間の0時を過ぎた
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-5;翌日まで待って Ploh Trishbahk。エリアの出入りは要らない（FFXIclopedia も同じ）
g01 go - | 前の節からヴァナ時間の0時を過ぎるまで待つ | エリアを出入りしなくてよい。 | W ヴァナ時間の0時を過ぎてから
g02 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、イベントを見ると完了 | | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk

@ mission.adoulin.081 https://wiki.ffo.jp/html/31712.html
Q Anagnorisis | 悲劇の後 | no | T npc.257.Ploh_Trishbahk
MN SoA4-5-1 84
LK condition:前節「不死君バラモア」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-5-1;「再生」でもらった首装備（Adoulin's Refuge・Arciela's Grace・Ygnas's Resolve）を Ploh Trishbahk にトレード。捨ててしまったときは話せば進む（FFXIclopedia は GM に頼むと書く古い記述）
g01 trade - | 「再生」でもらった首装備（レフージネックレス・リゾールブマフラー・グレースカラーのどれか）を、東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkにトレードすると完了 | 首装備を捨ててしまったときは、Ploh Trishbahkに話せば進む。2つ持っているときは、1つ捨ててからトレードする。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk

@ mission.adoulin.082 https://wiki.ffo.jp/html/31713.html
Q Just the Thing | アシェラの好きなもの | no | T npc.セレニア図書館.Andreine = npc:Andreine@セレニア図書館
MN SoA4-5-2 85
RW key_item:ハッピー☆になるお菓子の本
LK condition:前節「悲劇の後」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-5-2;東アドゥリンのセレニア図書館の Andreine で "Suffering Sacchariferous"（FFXIclopedia も同じ。Waypoint は Scouts' Coalition が近い）
g01 go - | 東アドゥリン(F-10/G-10)のEppel-Treppelに話して、セレニア図書館に入る | | @東アドゥリン F-10 G-10 | T npc.257.Eppel-Treppel
g02 talk - | セレニア図書館のAndreineに話してイベントを見て、だいじなもの「ハッピー☆になるお菓子の本」をもらうと完了 | | @セレニア図書館 | T npc.セレニア図書館.Andreine

@ mission.adoulin.083 https://wiki.ffo.jp/html/31714.html
Q Sugarcoated Salvation | スィーツの魔力 | no | T npc.257.Ploh_Trishbahk
MN SoA4-5-3 86
RW key_item:王墓の紋章
RW title:悲嘆の淵の救済者
LK condition:前節「アシェラの好きなもの」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-5-3;Ploh Trishbahk でイベント、Sepulcher ensign。称号 Lifter of Spirits。FFXIclopedia：選択肢は1つずつ全部選ぶ。「.....」の3つの答えはどれでも同じ
g01 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話してイベントを見て、だいじなもの「王墓の紋章」をもらうと完了 | 選択肢が出たら、1つずつ全部選ぶ。「……」の3つの答えはどれでもよい。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk | K ハッピー☆になるお菓子の本

@ mission.adoulin.084 https://wiki.ffo.jp/html/31715.html
Q Arciela's Resolve | 姫の決意 | no | T obj.258.Royal_Sepulcher = obj:Royal Sepulcher@ララ水道 N-10
MN SoA4-5-4 87
LK condition:前節「スィーツの魔力」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-5-4;東アドゥリン F-7 の入口からララ水道に入り、N-10（いちばん南東）の Royal Sepulcher（FFXIclopedia も同じ。近くの名前のない調べる所は合言葉を聞かれ、間違えると東アドゥリンへ出される。このミッションには要らない）
g01 go - | 東アドゥリン(F-7)の入口からララ水道に入る | | @東アドゥリン F-7
g02 examine - | ララ水道(N-10)のRoyal Sepulcherを調べ、イベントを見ると完了 | マップのいちばん南東。 | @ララ水道 N-10 | T obj.258.Royal_Sepulcher

@ mission.adoulin.085 https://wiki.ffo.jp/html/31716.html
Q Balamor's Ruse | バラモアのゲーム | no | T obj.258.Augural_Conveyor = obj:Augural Conveyor@ララ水道 B-6
MN SoA4-6 88
RW title:ゲームの勝者
LK condition:前節「姫の決意」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-6;ララ水道の敵から Consummate simulacrum（New Moon Bats がよく落とす。済ませた人が倒してもよい）。B-6 の Augural Conveyor から BF「The Charlatan」（入る前のイベントなし）。Balamor と Dullahan 3体、Arciela が倒れると負け、Balamor だけ倒せばよい。入るとリーダーだけ KI がなくなる。称号 Shedder of Harlequin Tears。FFXIclopedia：Spoutdrenched Toad・Rustwater Toad・New Moon Bats・Duskbringer Bat・Skittering Spider が落とす
g01 defeat - | ララ水道の敵を倒し、だいじなもの「完全なるシミューラクラム」を手に入れる | New Moon Bats・Duskbringer Bat・Spoutdrenched Toadなどが落とす。東アドゥリン(F-7)の入口の近くのNew Moon Batsがよく落とす。パーティの中で、もう済ませた人が倒してもよい。 | @ララ水道
g02 examine - | ララ水道(B-6)のAugural Conveyorを調べてBFに入る | 西アドゥリン(F-5)の入口が近い。入る前のイベントはない。まだ済ませていない人はみな「完全なるシミューラクラム」が要る。 | @ララ水道 B-6 | T obj.258.Augural_Conveyor | K 完全なるシミューラクラム
g03 fight - | BFでBalamorを倒し、イベントを見ると完了 | フェイス可（入ってから呼ぶ）。味方のアシェラが倒れると負け。倒すのはBalamorだけでよく、HPが少なくなると降参する。Regicidal Dullahanはずっとアシェラを狙う。入ると「完全なるシミューラクラム」はリーダーだけなくなり、負けたら取り直す。 | K 完全なるシミューラクラム

@ mission.adoulin.086 https://wiki.ffo.jp/html/31717.html
Q The Charlatan | トリックスター | no | T npc.257.Ploh_Trishbahk
MN SoA4-6-1 89
RW item:レフジネックレス+1／リゾルブマフラー+1／グレースカラー+1 のどれか1つ
RW exp:500
RW title:暁の輝き
LK condition:前節「バラモアのゲーム」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-6-1;Ploh Trishbahk で +1 の首装備を1つ選ぶ（前に選んだものと違ってもよい。取り直せない）。経験値500。称号 Hope for the Future。迷うと答えると出て、もう一度話せば選び直せる。RoV「Solemnity」の途中だと先にそちらを済ませる（FFXIclopedia も同じ）
g01 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、イベントで首装備を1つ選んでもらうと完了 | 前に選んだものと違ってもよい。一度もらうと取り直せないので、よく考えて選ぶ。かばんがいっぱいだと受け取れない。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk

@ mission.adoulin.087 https://wiki.ffo.jp/html/31718.html
Q Royal Blessings | さらなる加護 | no | T npc.256.Levil
MN SoA4-6-2 90
LK condition:前節「トリックスター」クリア、ヴァナ時間の0時を過ぎた
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_4-6-2;翌日まで待って Pioneers' Coalition の Levil。選択肢は "'Strange'? Can you be more specific?" のあと "Of course they will!"（FFXIclopedia も同じ）
g01 go - | 前の節からヴァナ時間の0時を過ぎるまで待つ | | W ヴァナ時間の0時を過ぎてから
g02 talk - | 西アドゥリン(E-8)のPIO.ワークスのLevilに話し、イベントを見ると完了 | 選択肢は2回とも、話を続けるほうを選ぶ。 | @西アドゥリン E-8 | T npc.256.Levil

@ mission.adoulin.089 https://wiki.ffo.jp/html/39145.html
Q To begin SoA... | 「アドゥリンの魔境」を始めるには…… | no | T obj.231.Tales_Beginning = obj:Tales' Beginning@北サンドリア J-10
MN - 999
LK condition:北サンドリア・バストゥーク商業区・ウィンダス森の区のどれかに入って「後にする」を選んだ
g01 go - | 北サンドリア・バストゥーク商業区・ウィンダス森の区のどれかへ行く | 入ったときに「後にする」を選んだときだけ一覧に出る。始めずに飛ばすときは、ジュノ下層(H-7)のDarciaに話して「開拓者に志願したい」を選ぶか、「アドゥリン渡航免状」を買う。 | > a01,b01,c01
a01 examine - | 【北サンドリア】北サンドリア(J-10)のTales' Beginningを調べてオープニングのイベントを見ると完了 | このあと「西の国の噂」になる。 | @北サンドリア J-10 | T obj.231.Tales_Beginning | R 北サンドリア | >
b01 examine - | 【バストゥーク商業区】バストゥーク商業区(I-8)のTales' Beginningを調べてオープニングのイベントを見ると完了 | このあと「西の国の噂」になる。 | @バストゥーク商業区 I-8 | T obj.235.Tales_Beginning = obj:Tales' Beginning@バストゥーク商業区 I-8 | R バストゥーク商業区 | >
c01 examine - | 【ウィンダス森の区】ウィンダス森の区(J-10)のTales' Beginningを調べてオープニングのイベントを見ると完了 | このあと「西の国の噂」になる。 | @ウィンダス森の区 J-10 | T obj.241.Tales_Beginning = obj:Tales' Beginning@ウィンダス森の区 J-10 | R ウィンダス森の区 | >

@ mission.adoulin.090 https://wiki.ffo.jp/html/32104.html
Q Arboreal Rumors | 奇妙な森の噂 | no | T npc.257.Ploh_Trishbahk
MN SoA5-1 91
RW key_item:アドゥリン家の紋章入り便せん
LK condition:前節「さらなる加護」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_5-1;城門の Ploh Trishbahk（K-9）で Hastily scribbled note。選択肢は "I just want to see Arciela."（FFXIclopedia も同じ）
g01 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話してイベントを見て、だいじなもの「アドゥリン家の紋章入り便せん」をもらうと完了 | 選択肢は、アシェラに会いたいと答えるほうを選ぶ。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk

@ mission.adoulin.091 https://wiki.ffo.jp/html/32115.html
Q Arciela's Missive | アシェラからの伝言 | no | T obj.256.Sunrise_Beacon
MN SoA5-1-1 92
LK condition:前節「奇妙な森の噂」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_5-1-1;一時的に所持するだいじなものの Hastily scribbled note を読む（読まないと Sunrise Beacon で何も起きない）。西アドゥリン J-4（Waypoint #9 の波止場の北の端）の Sunrise Beacon（FFXIclopedia も同じ）
g01 go - | メニューの「だいじなもの」の「一時的に所持するもの」から「アドゥリン家の紋章入り便せん」を開いて読む | 読まないと、次の手順で調べても何も起きない。 | K アドゥリン家の紋章入り便せん
g02 examine - | 西アドゥリン(J-4)のアドゥリン港のSunrise Beaconを調べ、イベントを見ると完了 | 波止場の北の端。アドゥリン港のWaypointが近い。 | @西アドゥリン J-4 | T obj.256.Sunrise_Beacon

@ mission.adoulin.092 https://wiki.ffo.jp/html/32116.html
Q Heroes, Unite! | 集え、英雄の下へ | no | T obj.267.Alpine_Trail
MN SoA5-1-2 93
LK condition:前節「アシェラからの伝言」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_5-1-2;カミール山麓 H-5 の Alpine Trail。フロンティア・ビバック#3 かホームポイントが近い（FFXIclopedia も同じ。リファーリアの Heroic Footprints の任意のイベントはシートだけ）
g01 examine - | （してもしなくてもよい）リファーリア(H-8)のHeroic Footprintsを調べてイベントを見る | | @リファーリア H-8 | T obj.281.Heroic_Footprints
g02 go - | カミール山麓のフロンティア・ビバック#3から北のトンネルに入り、左の壁沿いに北へ進む | カミール山麓のホームポイントからも近い。 | @カミール山麓
g03 examine - | カミール山麓(H-5)のAlpine Trailを調べて先へ進み、イベントを見ると完了 | | @カミール山麓 H-5 | T obj.267.Alpine_Trail

@ mission.adoulin.093 https://wiki.ffo.jp/html/32117.html
Q A Portent Most Ominous | 凶兆か、吉兆か…… | no | T obj.281.Aged_Stump
MN SoA5-1-3 94
RW key_item:青色のロスレーシャの実
RW key_item:黄色のロスレーシャの実
LK condition:前節「集え、英雄の下へ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_5-1-3;カミール山麓 G-11 の Blockaded Path かホームポイントからリファーリアに入り、Aged Stump で Sky blue pome と Sun yellow pome（FFXIclopedia も同じ）
g01 examine - | カミール山麓(G-11)のBlockaded Pathを調べて、リファーリアに入る | フロンティア・ビバック#2が近い。リファーリアのホームポイントがあれば飛んでもよい。 | @カミール山麓 G-11 | T obj.267.Blockaded_Path
g02 examine - | リファーリア(H-8)のAged Stumpを調べてイベントを見て、だいじなもの「青色のロスレーシャの実」と「黄色のロスレーシャの実」をもらうと完了 | | @リファーリア H-8 | T obj.281.Aged_Stump

@ mission.adoulin.094 https://wiki.ffo.jp/html/32118.html
Q Yggdrasil Beckons | 世界樹の導き | no | T obj.270.Wavering_Flux = obj:Wavering Flux@シルダス洞窟 K-11 #1
MN SoA5-2 95
RW key_item:冥王の聖痕【変妖君】
RW key_item:冥王の聖痕【怪霊君】
RW title:変妖を討滅せし者
RW title:怪霊を討滅せし者
LK condition:前節「凶兆か、吉兆か……」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_5-2;BF が2つでどちらが先でもよい。シルダス洞窟 K-11 の Wavering Flux で Dhokmak と Malignant Acuex 3体（Darrcuiln が倒れると負け）、ヨルシア森林 H-6 の南東の Wavering Flux で Ashrakk（Morimar が倒れると負け）。どちらも HP を10%まで減らせば勝ち。武器を構えるとすぐ始まる。負けたらリファーリアの Aged Stump で KI を取り直す。称号 Vanquisher of Dhokmak・Vanquisher of Ashrakk。FFXIclopedia：入るとヨルシア森林は Sky blue pome、シルダス洞窟は Sun yellow pome がなくなる
g01 go - | シルダス洞窟MAP1の(K-11)へ向かう | ケイザック古戦場のフロンティア・ビバック#3からシィの門に入り、シィの門(D-5)の入口からシルダス洞窟に入ると早い。この手順から3つと、そのあとの3つは、どちらを先にしてもよい。 | @シルダス洞窟 K-11 #1
g02 examine - | シルダス洞窟(K-11)のWavering Fluxを調べてイベントを見て、もう一度調べてBFに入る | 武器を構えるとすぐ戦いが始まる。 | @シルダス洞窟 K-11 #1 | T obj.270.Wavering_Flux | K 黄色のロスレーシャの実
g03 fight - | BFで変妖君ドクマクのHPを1割まで減らして倒し、だいじなもの「冥王の聖痕【変妖君】」をもらう | フェイス可。味方のダラクァルンが倒れると負け。負けたらリファーリアのAged Stumpを調べれば、入るのに要るだいじなものがすぐもらえる。 | K 黄色のロスレーシャの実
g04 go - | ヨルシア森林のフロンティア・ビバック#1から、右の壁沿いに(H-6)の南東へ進む | #1がないときは、フロンティア・ステーションから北へ行き西へ向かう。 | @ヨルシア森林 H-6
g05 examine - | ヨルシア森林(H-6)の南東のWavering Fluxを調べてイベントを見て、もう一度調べてBFに入る | 武器を構えるとすぐ戦いが始まる。 | @ヨルシア森林 H-6 | T obj.263.Wavering_Flux = obj:Wavering Flux@ヨルシア森林 H-6 | K 青色のロスレーシャの実
g06 fight - | BFで怪霊君アシュラックのHPを1割まで減らして倒し、だいじなもの「冥王の聖痕【怪霊君】」をもらう。2つとも倒すと完了 | フェイス可。味方のモリマーが倒れると負け。HPが減ると敵が1体増える。負けたらリファーリアのAged Stumpを調べて、入るのに要るだいじなものを取り直す。 | K 青色のロスレーシャの実

@ mission.adoulin.095 https://wiki.ffo.jp/html/32119.html
Q Returning to the Trees | 帰路、リファーリアへ | no | T obj.267.Blockaded_Path
MN SoA5-2-1 96
LK condition:前節「世界樹の導き」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_5-2-1;リファーリアに入るとイベント。選択肢は "Ask for forgiveness." のあと "I promise."（FFXIclopedia も同じ）
g01 examine - | カミール山麓(G-11)のBlockaded Pathを調べてリファーリアに入り、イベントを見ると完了 | リファーリアのホームポイントがあれば飛んでもよい。選択肢は、あやまるほうを選び、次は約束するほうを選ぶ。 | @カミール山麓 G-11 | T obj.267.Blockaded_Path

@ mission.adoulin.096 https://wiki.ffo.jp/html/32120.html
Q The Key to the Turris | 天守へ至る鍵 | no | T obj.ラ・カザナル宮天守.Ominous_Postern = obj:Ominous Postern@ラ・カザナル宮天守
MN SoA5-2-2 97
RW title:英霊の加護ありし者
LK condition:前節「帰路、リファーリアへ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_5-2-2;ラ・カザナル宮天守のいちばん下の Ominous Postern で長いイベント、そのあとカミール山麓 F-8 に出る。内郭のホームポイント#1があれば飛んで Vertical Transit Device から天守へ。ないときは外郭から通るか、七支公の Naakual crest があれば各地の結晶から近道（7つの道）。称号 Protected by Ulbukan Spirits（FFXIclopedia も同じ）
g01 go - | ラ・カザナル宮内郭へ行く | ラ・カザナル宮内郭のホームポイントがあれば飛ぶ。ないときはラ・カザナル宮外郭から通る（途中にコロナイズ・レイヴがある）。七支公を倒していれば、各地の結晶から近道できる。 | @ラ・カザナル宮内郭
g02 examine - | ラ・カザナル宮内郭MAP2(I-8)のいちばん奥のVertical Transit Deviceを調べ、ラ・カザナル宮天守に入る | そばのホームポイントに触れておく。次からはここに飛べる。 | @ラ・カザナル宮内郭 I-8 #2 | T obj.276.Vertical_Transit_Device = obj:Vertical Transit Device@ラ・カザナル宮内郭 I-8 #2
g03 examine - | ラ・カザナル宮天守の坂を下りた奥のOminous Posternを調べ、イベントを見る | イベントは長い。 | @ラ・カザナル宮天守 | T obj.ラ・カザナル宮天守.Ominous_Postern
g04 go - | カミール山麓に出されて、イベントを見ると完了 | ラ・カザナル宮外郭の入口(F-8)に出る。 | @カミール山麓 F-8

@ mission.adoulin.097 https://wiki.ffo.jp/html/32121.html
Q Teodor's Summons | 黒衣の紳士の招待 | no | T obj.267.Alpine_Trail
MN SoA5-3 98
RW key_item:ルーンの字刻板
LK condition:前節「天守へ至る鍵」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_5-3;カミール山麓 H-5 の Alpine Trail でイベント、Ash runic board。選択肢は "I thought he was a libertine, myself."（FFXIclopedia も同じ）
g01 go - | カミール山麓のフロンティア・ビバック#3から北のトンネルに入り、左の壁沿いに北へ進む | カミール山麓のホームポイントからも近い。 | @カミール山麓
g02 examine - | カミール山麓(H-5)のAlpine Trailを調べてカミール山でイベントを見て、だいじなもの「ルーンの字刻板」をもらうと完了 | | @カミール山麓 H-5 | T obj.267.Alpine_Trail

@ mission.adoulin.098 https://wiki.ffo.jp/html/32122.html
Q The Seventh Guardian | 七番目の守護者 | no | T npc.258.Yeggha_Dolashi
MN SoA5-3-1 99
LK condition:前節「黒衣の紳士の招待」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_5-3-1;東アドゥリン F-7 の入口からララ水道に入り、M-6 の Yeggha Dolashi（FFXIclopedia も同じ。シートは入口を E-7 とする）
g01 go - | 東アドゥリン(F-7)の入口からララ水道に入る | 東アドゥリンのWaypointが近い。 | @東アドゥリン F-7
g02 talk - | ララ水道(M-6)の水園の決闘場の前のYeggha Dolashiに話し、イベントを見ると完了 | | @ララ水道 M-6 | T npc.258.Yeggha_Dolashi

@ mission.adoulin.099 https://wiki.ffo.jp/html/32123.html
Q Watery Grave | 水園の決闘 | no | T obj.258.Entrance_Coliseum
MN SoA5-3-2 100
RW key_item:古ぼけた紋章-不死公
RW key_item:冥王の聖痕【不死君】
RW key_item:タルタロスの魂魄
RW title:聖痕の受難者
LK condition:前節「七番目の守護者」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_5-3-2;ララ水道 M-6 の Entrance: Coliseum から BF。Teodor は HP10%で降参。Dread Spikes に気をつける。入ると Ash runic board が Blank ash runic board になり、負けたら翌日まで待ってララ水道に入り直すと戻る。称号 Receiver of Sigils（FFXIclopedia も同じ）
g01 examine - | ララ水道(M-6)のEntrance: Coliseumを調べ、「水園の決闘」を選んでBFに入る | | @ララ水道 M-6 | T obj.258.Entrance_Coliseum | K ルーンの字刻板
g02 fight - | BFでTeodorのHPを1割まで減らして倒し、イベントを見ると完了 | フェイス可。いつも範囲で攻撃してくる。ドレッドスパイクは消してから殴る。負けたら、ヴァナ時間の0時を過ぎてからララ水道に入り直すと「ルーンの字刻板」が戻る。 | K ルーンの字刻板

@ mission.adoulin.100 https://wiki.ffo.jp/html/32124.html
Q Blood for Blood | ときの声 | no | T obj.ラ・カザナル宮天守.Ominous_Postern
MN SoA5-3-3 101
LK condition:前節「水園の決闘」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_5-3-3;ラ・カザナル宮天守のいちばん下の Ominous Postern でイベント。内郭のホームポイント#1が入口のすぐそば（FFXIclopedia も同じ。Aged Stump と Alpine Trail の任意のイベントはシートだけ）
g01 examine - | （してもしなくてもよい）リファーリア(H-8)のAged Stumpを調べ、ダラクァルンのイベントを見る | | @リファーリア H-8 | T obj.281.Aged_Stump
g02 examine - | （してもしなくてもよい）カミール山麓(H-5)のAlpine Trailを調べ、ハーサーカのイベントを見る | | @カミール山麓 H-5 | T obj.267.Alpine_Trail
g03 examine - | ラ・カザナル宮内郭のホームポイントに飛び、MAP2(I-8)のVertical Transit Deviceを調べてラ・カザナル宮天守に入る | | @ラ・カザナル宮内郭 I-8 #2 | T obj.276.Vertical_Transit_Device
g04 examine - | ラ・カザナル宮天守の坂を下りた奥のOminous Posternを調べ、イベントを見ると完了 | | @ラ・カザナル宮天守 | T obj.ラ・カザナル宮天守.Ominous_Postern

@ mission.adoulin.101 https://wiki.ffo.jp/html/32125.html
Q Reckoning | 天守に座すモノ | no | T obj.ラ・カザナル宮天守.Ominous_Postern
MN SoA5-4 102
RW key_item:タルタロスの魂魄醒
RW title:冥王を討ちし者
LK condition:前節「ときの声」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_5-4;Ominous Postern から BF でハデス（1つめの姿）。Arciela が倒れると負け。武器を構えるとすぐ始まる。勝つとイベントで Awakened crystallized psyche。負けたら内郭に入り直すと Crystallized psyche が戻る。称号 Destroyer of Hades。FFXIclopedia：30分、薬は次の戦いのために残す
g01 examine - | ラ・カザナル宮天守のOminous Posternを調べてBFに入る | | @ラ・カザナル宮天守 | T obj.ラ・カザナル宮天守.Ominous_Postern | K タルタロスの魂魄
g02 fight - | BFでハデスを倒してイベントを見て、だいじなもの「タルタロスの魂魄醒」をもらうと完了 | フェイス可・30分。味方のアシェラが倒れると負け。武器を構えるとすぐ始まるので、強化を済ませてから。薬は次の戦いのために残しておく。負けたらエリアに入り直すと「タルタロスの魂魄」が戻る。 | K タルタロスの魂魄

@ mission.adoulin.102 https://wiki.ffo.jp/html/32242.html
Q Abomination | 神の化身 | no | T obj.ラ・カザナル宮天守.Ominous_Postern
MN SoA5-4-1 103
RW title:暁の先導者
LK condition:前節「天守に座すモノ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_5-4-1;Ominous Postern から BF でハデス（2つめの姿）。Arciela か Teodor が倒れると負け。HP の表示は出ない。勝つとイベントのあとケイザック古戦場に出る。負けたら内郭に入り直すと KI が戻る。称号 Bringer of the Dawn。FFXIclopedia：石化の技があるので、ストナを使える人を入れる
g01 examine - | ラ・カザナル宮天守のOminous Posternを調べてBFに入る | 前の戦いのあと、休んでから入ってよい。 | @ラ・カザナル宮天守 | T obj.ラ・カザナル宮天守.Ominous_Postern | K タルタロスの魂魄醒
g02 fight - | BFでハデスを倒してイベントを見ると完了 | フェイス可。味方のアシェラかテオドールが倒れると負け。ハデスのHPは見えない。石化させる技があるので、ストナを使える人がいるとよい。終わるとケイザック古戦場に出る。負けたらエリアに入り直すと「タルタロスの魂魄醒」が戻る。 | K タルタロスの魂魄醒

@ mission.adoulin.103 https://wiki.ffo.jp/html/32243.html
Q Undying Light | 降り注ぐ、奇跡の煌めき | no | T npc.257.Ploh_Trishbahk
MN SoA5-5 104
RW title:アドゥリンの真なる開拓者
LK condition:前節「神の化身」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_5-5;ケイザック古戦場から西アドゥリンに入るとイベント（FFXIclopedia：ワープでは起きない。ほかの方法で来たら、ケイザック古戦場に出て入り直す）。そのあと城門の Ploh Trishbahk で長いイベント
g01 go - | ケイザック古戦場から歩いて西アドゥリンに入り、イベントを見る | ワープで西アドゥリンに入ったときは起きないので、一度ケイザック古戦場に出て、歩いて入り直す。 | @ケイザック古戦場
g02 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、イベントを見ると完了 | イベントは長い。選択肢はどれを選んでもよい。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk

@ mission.adoulin.104 https://wiki.ffo.jp/html/32244.html
Q The Light Within | 若き指導者 | no | T npc.257.Ploh_Trishbahk
MN SoA5-5-1 105
RW key_item:アシェラのスカート
RW item:カウンセラーガーブ
RW item:カウンセラーカフス
RW exp:1000
RW title:希望の先導者
RW item:アドゥリンリング／ウォルタリスリング／ウェーザーリング／ジャニストンリング／レナイェリング／ゴーニーリング／ハーバートンリング／カリエイリング／ヴォーケインリング／テュランドーリング／シュネデックリング／オーヴェイルリング のどれか1つ
LK condition:前節「降り注ぐ、奇跡の煌めき」のイベントからヴァナ時間の0時を過ぎた
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_5-5-1;翌日まで待ってケイザック古戦場に入るととても長いイベント（FFXIclopedia：西アドゥリンから入る）。城門の Ploh Trishbahk でガーブ・カフス・指輪を1つ。300,000ベヤルドで指輪を替えられる。FFXIclopedia：ケイザック古戦場 J-10 の Sandy Overlook でフェイスのアシェラ。60fps のままだとイベントの終わりで止まることがある
g01 go - | 前の節のイベントからヴァナ時間の0時を過ぎるまで待つ | | W ヴァナ時間の0時を過ぎてから
g02 go - | 西アドゥリンからケイザック古戦場に入り、エンディングのイベントを見て、だいじなもの「アシェラのスカート」をもらう | イベントはとても長い（約15分）。フレームレートを30に戻しておく。 | @ケイザック古戦場
g03 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、指輪を1つ選んでもらうと完了 | 指輪は、あとで300,000ベヤルドを払えば替えられる。アシェラに「返す物がありませんか？」と聞かれて「なんのこと？」を選び続けると「アシェラのボンネ【スペア】」ももらえるが、アシェラとの仲がいちばん下になる。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk
