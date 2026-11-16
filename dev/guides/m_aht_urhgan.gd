# アトルガンミッション（0.1.120〜）。基礎シートのミッション一覧 141〜188 行。id の番号はシートの行−140、order も同じ
@ mission.aht_urhgan.001 https://wiki.ffo.jp/html/4610.html
Q Land of Sacred Serpents | 聖蛇の国 | no | T npc.アトルガン白門.Naja_Salaheem
MN ToAU1 1
LK quest:ジュノのクエスト「アトルガン皇国へ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Land_of_Sacred_Serpents;Naja Salaheem アトルガン白門 I-10（建物の上の階）。ユニティワープ（ワジャーム樹林）からも行ける
g01 go - | ジュノ下層のクエスト「アトルガン皇国へ」を終え、マウラから船でアトルガン白門へ渡る | 乗船券があれば、ユニティワープでワジャーム樹林へ飛んで歩いてもよい。 | @アトルガン白門
g02 talk - | アトルガン白門(I-10)のサラヒム・センチネルに入り、Naja Salaheemに近づいてイベントを見ると完了 | 建物の上の階。近くのHome Point #1も開けておく。 | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem

@ mission.aht_urhgan.002 https://wiki.ffo.jp/html/4611.html
Q Immortal Sentries | 不滅の防人 | no | T npc.アトルガン白門.Naja_Salaheem
MN ToAU2 2
RW key_item:山猫二等傭兵バッジ
RW other:皇国軍戦績150
LK condition:前節「聖蛇の国」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Immortal_Sentries;差し入れはナイズル島以外の監視哨のどれか1つへ。届ける前に移送の幻灯を調べると白門に戻されてしまう。モグロッカー・サンクション・アサルトが使えるようになる
g01 talk - | アトルガン白門(I-10)のNaja Salaheemに話してイベントを見て、差し入れを受け取る | 選ぶものはどれでもよい。 | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem
g02 go - | 5つの監視哨のどれか1つへ行く | アズーフ島監視哨（カダーバの浮沼）、マムージャ監視哨（バフラウ段丘）、ハルブーン監視哨（ゼオルム火山）、ドゥブッカ島監視哨（カダーバの浮沼）、イルルシ環礁監視哨（アラパゴ暗礁域）。いずれ全部開ける。
g03 talk - | 監視哨の中の不滅隊に話して、差し入れを渡す | 移送の幻灯（Runic Portal）より先に話す。
g04 examine - | 監視哨の移送の幻灯（Runic Portal）を調べて、アトルガン白門の六門院へ戻る | -
g05 talk - | アトルガン白門(I-10)のNaja Salaheemに話してイベントを見ると完了 | - | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem

@ mission.aht_urhgan.003 https://wiki.ffo.jp/html/4623.html
Q President Salaheem | 山猫の社長 | no | T npc.アトルガン白門.Naja_Salaheem
MN ToAU3 3
RW other:アサルトに参加できる
LK condition:前節「不滅の防人」クリア後にエリアを出入りする
XS BG Wiki;https://www.bg-wiki.com/ffxi/President_Salaheem;エリアを出入りしてから Naja Salaheem に2回話す。Rytaal K-10（公務代理店）、Fubruhn F-11 は話さなくてもよい（FFXIclopedia も K-10・F-11）
g01 go - | 前節のあと、一度エリアを出て入り直す | 社屋の西の階段下からワジャーム樹林へ出られる。 | @アトルガン白門
g02 talk - | アトルガン白門(I-10)のNaja Salaheemに、イベントが出るまで何度か話す | 先に公務代理店(K-10)のRytaalに話してアサルトの説明を聞いてもよい。 | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem
g03 talk - | もう一度Naja Salaheemに話してイベントを見ると完了 | - | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem

@ mission.aht_urhgan.004 https://wiki.ffo.jp/html/4627.html
Q Knight of Gold | 黄金の騎士 | no | T npc.アトルガン白門.Cacaroon
MN ToAU4 4
RW key_item:ライファルの書状
LK condition:前節「山猫の社長」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Knight_of_Gold;Cacaroon G-11（モグハウスの向かい）、ワラーラ寺院 K-8、茶屋シャララト K-12（FFXIclopedia も同じ）。イベントは「Cacaroon got cheeep info」で始まるもの
g01 talk - | アトルガン白門(G-11)のCacaroonに話してイベントを見る | ほかのクエストの話が出たら、もう一度話す。 | @アトルガン白門 G-11 | T npc.アトルガン白門.Cacaroon
g02 trade - | Cacaroonにアトルガン青銅貨1枚か1000ギルをトレードしてイベントを見る | ギルも自分でトレードする。 | @アトルガン白門 G-11 | T npc.アトルガン白門.Cacaroon | N アトルガン青銅貨*1
g03 go - | アトルガン白門(K-8)のワラーラ寺院に入ってイベントを見る | - | @アトルガン白門 K-8
g04 go - | アトルガン白門(K-12)の茶屋シャララトの2階に入ってイベントを見ると完了 | 「秘密？」の問いでは3番目を選ぶ。 | @アトルガン白門 K-12

@ mission.aht_urhgan.005 https://wiki.ffo.jp/html/4632.html
Q Confessions of Royalty | 王子の告白 | no | T npc.233.Halver
MN ToAU5 5
LK condition:前節「黄金の騎士」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Confessions_of_Royalty;ドラギーユ城の Halver I-9（FFXIclopedia も I-9）。城に入れないときは北サンドリア I-7 の Guilerme か Bacherume に話す
g01 talk - | ドラギーユ城(I-9)のHalverに話してイベントを見ると完了 | 城に入れないときは、北サンドリア(I-7)の門番Guilermeに話す。Home Point #2が近い。 | @ドラギーユ城 I-9 | T npc.233.Halver

@ mission.aht_urhgan.006 https://wiki.ffo.jp/html/4636.html
Q Easterly Winds | 東風 | no
MN ToAU6 6
RW item:アトルガン青銅貨×10（「はい」を選んだとき）
LK condition:前節「王子の告白」クリアから1分たつ
XS BG Wiki;https://www.bg-wiki.com/ffxi/Easterly_Winds;前節から1分待つ。最初の問いで「はい」、3つ目で「そのために来た」（どちらも1番目）を選ぶと青銅貨10枚
g01 go - | 前節から1分たってから、ル・ルデの庭(H-7)のオーロラ宮殿に入ってイベントを見ると完了 | 1つ目と3つ目の問いで1番目を選ぶと、アトルガン青銅貨10枚がもらえる。 | @ル・ルデの庭 H-7

@ mission.aht_urhgan.007 https://wiki.ffo.jp/html/4638.html
Q Westerly Winds | 西風 | no
MN ToAU7 7
RW key_item:ライファルの書置き
RW item:アトルガン白銀貨×2
RW title:アルタナ同盟エージェント
LK condition:前節「東風」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Westerly_Winds;茶屋シャララトは BG Wiki K-11・FFXIclopedia と用語辞典 K-12。白銀貨は茶屋と Naja Salaheem で1枚ずつ
g01 go - | アトルガン白門(K-12)の茶屋シャララトに入ってイベントを見る | 選ぶものはどれでもよい。アトルガン白銀貨が1枚もらえる。 | @アトルガン白門 K-11 K-12
g02 talk - | アトルガン白門(I-10)のNaja Salaheemに話してイベントを見ると完了 | インプの羽を求められたら、昇進のクエストのもの。渡せば続く。 | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem

@ mission.aht_urhgan.008 https://wiki.ffo.jp/html/4642.html
Q A Mercenary Life | 傭兵のつとめ | no
MN ToAU8 8
LK condition:前節「西風」のイベントのあとエリアを出入りする
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Mercenary_Life;エリアを出入りしてサラヒム・センチネル I-10 に入るとイベント。近いエリアの出口は H-10 のワジャーム樹林への門（FFXIclopedia）
g01 go - | 一度エリアを出て入り直す | 近いのは(H-10)の1階のワジャーム樹林への門。 | @アトルガン白門 H-10
g02 go - | アトルガン白門(I-10)のサラヒム・センチネルに入ってイベントを見ると完了 | - | @アトルガン白門 I-10

@ mission.aht_urhgan.009 https://wiki.ffo.jp/html/5192.html
Q Undersea Scouting | 聖跡の巡視 | no | T npc.アトルガン白門.Naja_Salaheem
MN ToAU9 9
RW key_item:魔笛指向儀
LK condition:前節「傭兵のつとめ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Undersea_Scouting;ナイズル島監視哨があれば H-9 の南東のワープ、次に東のワープでアルザダール海底遺跡群へ入るとイベント
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/Undersea_Scouting;監視哨がないときはバフラウ段丘 F-6 の Kamih Mapokhalam に白銀貨1枚で遺跡へ。MAP7 の G-8 から東へ進むとイベント
g01 talk - | アトルガン白門(I-10)のNaja Salaheemに話して依頼を受ける | 白門(H-7)のSajahbに道順を聞いてもよい。 | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem | > a01,b01
a01 trade - | バフラウ段丘(F-6)のKamih Mapokhalamにアトルガン白銀貨1枚を渡して、アルザダール海底遺跡群に入る | 出たらまた白銀貨が要る。 | @バフラウ段丘 F-6 | N アトルガン白銀貨*1 | R バフラウ段丘から | > a02
a02 go - | 遺跡の中を東へ進み、Gilded Doorsが見えるあたりでイベントを見ると完了 | 道中に敵はいない。そのまま奥の監視哨まで行き、移送の幻灯を開けておくとよい。 | @アルザダール海底遺跡群 G-8 #7 | R バフラウ段丘から
b01 go - | ナイズル島監視哨から遺跡に入り、(H-9)の南東のワープ、次に東のワープで進んでイベントを見ると完了 | 監視哨を開けてあるときだけ。白銀貨は要らない。 | @アルザダール海底遺跡群 H-9 #8 | R ナイズル島監視哨から

@ mission.aht_urhgan.010 https://wiki.ffo.jp/html/5193.html
Q Astral Waves | 星気の笛音 | no | T npc.アトルガン白門.Naja_Salaheem
MN ToAU10 10
LK condition:前節「聖跡の巡視」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Astral_Waves;Naja Salaheem I-10 に話す
g01 talk - | アトルガン白門(I-10)のNaja Salaheemに話してイベントを見ると完了 | - | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem

@ mission.aht_urhgan.011 https://wiki.ffo.jp/html/5194.html
Q Imperial Schemes | 双蛇の謀 | no
MN ToAU11 11
LK condition:前節「星気の笛音」クリア後、ヴァナ時間の0時を過ぎてエリアを出入りする
XS BG Wiki;https://www.bg-wiki.com/ffxi/Imperial_Schemes;ヴァナ時間で1日待ってエリアを出入りし、サラヒム・センチネルへ
g01 go - | ヴァナ時間の0時を過ぎてから、一度エリアを出て入り直す | - | @アトルガン白門 | W ヴァナ時間の0時を過ぎてから
g02 go - | アトルガン白門(I-10)のサラヒム・センチネルに入ってイベントを見ると完了 | - | @アトルガン白門 I-10

@ mission.aht_urhgan.012 https://wiki.ffo.jp/html/5195.html
Q Royal Puppeteer | 無手の傀儡師 | no
MN ToAU12 12
RW key_item:ピョピョルン特製招魂香
LK condition:前節「双蛇の謀」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Royal_Puppeteer;ジョディの消化液はバフラウ段丘・ワジャーム樹林の Ameretat、ワジャーム樹林・エジワ蘿洞の Great Ameretat から。Pyopyoroon ナシュモ H-7（FFXIclopedia も H-7）
g01 go - | アトルガン白門(I-10)のサラヒム・センチネルに入ってイベントを見る | - | @アトルガン白門 I-10
g02 gather - | 「ジョディの消化液」を手に入れる | バフラウ段丘・ワジャーム樹林のAmeretat、ワジャーム樹林・エジワ蘿洞のGreat Ameretatが落とす。ナシュモへ行く前に取っておくとよい。 | N ジョディの消化液*1
g03 talk - | ナシュモ(H-7)の1階のPyopyoroonに話してイベントを見る | ナシュモへは白門(I-5)の船で行ける。 | @ナシュモ H-7 | T npc.ナシュモ.Pyopyoroon = npc:Pyopyoroon@ナシュモ H-7
g04 trade - | Pyopyoroonにジョディの消化液をトレードしてイベントを見ると完了 | - | @ナシュモ H-7 | T npc.ナシュモ.Pyopyoroon | N ジョディの消化液*1

@ mission.aht_urhgan.013 https://wiki.ffo.jp/html/5197.html
Q Lost Kingdom | 亡国の墳墓 | no
MN ToAU13 13
RW key_item:イフラマド金貨
LK condition:前節「無手の傀儡師」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Lost_Kingdom;Jazaraat's Headstone カダーバの浮沼 E-10（Home Point #1 の南東。FFXIclopedia も E-10）
g00 go - | ナシュモの西の出口からカダーバの浮沼へ出て、墓地へ行く | Home Point #1（タラッカ入江の前）が近い。 | @カダーバの浮沼 E-10 #1
g01 examine - | 墓地(E-10)のJazaraat's Headstoneを調べてイベントを見る | - | @カダーバの浮沼 E-10 #1 | T obj.79.Jazaraats_Headstone = obj:Jazaraat's Headstone@カダーバの浮沼 E-10 #1
g02 defeat - | もう一度調べて、出てきたフォモル族のNM、Jazaraatを倒す | - | @カダーバの浮沼 E-10 #1 | T mob.79.Jazaraat = mob:Jazaraat@カダーバの浮沼 E-10 #1
g03 examine - | もう一度Jazaraat's Headstoneを調べてイベントを見ると完了 | 金貨は次の次の節のBFに入るとき要る。手伝いの人も墓を調べて金貨をもらっておく。 | @カダーバの浮沼 E-10 #1 | T obj.79.Jazaraats_Headstone

@ mission.aht_urhgan.014 https://wiki.ffo.jp/html/5202.html
Q The Dolphin Crest | 海豚の紋章 | no | T npc.アトルガン白門.Naja_Salaheem
MN ToAU14 14
LK condition:前節「亡国の墳墓」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Dolphin_Crest;Naja Salaheem に話す。墓の北西の洞窟に Home Point がある（FFXIclopedia）
g01 talk - | アトルガン白門(I-10)のNaja Salaheemに話してイベントを見ると完了 | 墓の北西の洞窟のHome Pointから戻れる。 | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem

@ mission.aht_urhgan.015 https://wiki.ffo.jp/html/5205.html
Q The Black Coffin | 漆黒の柩 | no | T obj.54.Cutter
MN ToAU15 15
LK condition:前節「海豚の紋章」クリア、だいじなもの「イフラマド金貨」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Black_Coffin;Cutter は BG Wiki・FFXIclopedia とも H-8（Map 5。用語辞典は MAP3）。カダーバの浮沼の Survival Guide から南の G-8 の入口が近い。Gessho が手伝う。Ashu Talif Captain の HP を2割ほどまで減らすと勝ち
g01 go - | アラパゴ暗礁域のCutter（アシュタリフ号の船着き場）へ行く | カダーバの浮沼のSurvival Guideから南へ行き、(G-8)の入口から入ると近い。 | @アラパゴ暗礁域 H-8 #3
g02 go - | 船着き場に近づいてイベントを見る | - | @アラパゴ暗礁域 H-8 #3 | T obj.54.Cutter
g03 fight - | Cutterを調べてBF「漆黒の柩」に入り、勝つ | 6人・30分・レベル制限なし。全員がイフラマド金貨を持っていないと入れず、入ると金貨はなくなる。Ashu Talif CaptainのHPを2割ほどまで減らすと勝ち。フェイスも呼べる。 | @アラパゴ暗礁域 H-8 #3 | T obj.54.Cutter | K イフラマド金貨
g04 go - | 勝ったあとナシュモへ飛ばされてイベントを見ると完了 | 負けたら墓をまた調べて金貨をもらう。イベントが切れてナシュモに飛ばないときは、Cutterの横のResume Pointを調べる。 | @ナシュモ

@ mission.aht_urhgan.016 https://wiki.ffo.jp/html/5121.html
Q Ghosts of the Past | 幽冥の海賊 | no | T npc.アトルガン白門.Naja_Salaheem
MN ToAU16 16
LK condition:前節「漆黒の柩」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Ghosts_of_the_Past_(Mission);Naja Salaheem に話す
g01 talk - | アトルガン白門(I-10)のNaja Salaheemに話してイベントを見ると完了 | - | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem

@ mission.aht_urhgan.017 https://wiki.ffo.jp/html/5210.html
Q Guests of the Empire | 賓客の資格 | no | T npc.アトルガン白門.Naja_Salaheem
MN ToAU17 17
RW item:アトルガン霊銀貨
RW other:サルベージに参加できる
LK condition:前節「幽冥の海賊」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Guests_of_the_Empire;決まった胴装備（ブリガンダイン・アクトンなど。HQ 可）と、両手・両脚・両足にも何か着る。胴装備は第46節でまた要る。Imperial Whitegate は FFXIclopedia L-8/L-9、用語辞典 L-8
g01 gather - | 決まった胴装備を用意して着て、両手・両脚・両足にも何か装備し、メインとサブの武器を外す | 胴はホーリーブレスト・ブリガンダイン・アクトン・ホマムコラッツァなど（HQも可）。3国の礼服・AF・AF2・プルビアーレ・メガスアタイアはだめ。胴装備はあとの節でまた要るので取っておく。
g02 talk - | その姿でアトルガン白門(I-10)のNaja Salaheemに話してイベントを見る | 合わない服だと見本を見せられるだけ。合えば別のイベントになる。 | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem
g03 examine - | カバンを1つ空けて、アトルガン白門(L-8)のImperial Whitegateを調べてイベントを見ると完了 | カバンがいっぱいだと最後の品をもらえず、長いイベントを見直すことになる。 | @アトルガン白門 L-8 L-9 | T obj.アトルガン白門.Imperial_Whitegate

@ mission.aht_urhgan.018 https://wiki.ffo.jp/html/4816.html
Q Passing Glory | 泡沫の宝冠 | no
MN ToAU18 18
RW title:アヴゼンの小間使い
LK condition:前節「賓客の資格」クリア後、ヴァナ時間の0時を過ぎてエリアを出入りする
XS BG Wiki;https://www.bg-wiki.com/ffxi/Passing_Glory;ヴァナ時間で1日待ってエリアを出入りしてから Naja Salaheem へ。このあとアシュタリフ号のアサルトに参加できる。茶屋 J-12 の座布団でフェイス Gessho。称号 Ovjang's Errand Runner は BG Wiki・FFXIclopedia では前節（つづきのイベント）
g01 go - | 前節のイベントのあと、ヴァナ時間の0時を過ぎてから一度エリアを出て入り直す | - | @アトルガン白門 | W ヴァナ時間の0時を過ぎてから
g02 go - | アトルガン白門(I-10)のサラヒム・センチネルに入ってイベントを見ると完了 | - | @アトルガン白門 I-10

@ mission.aht_urhgan.019 https://wiki.ffo.jp/html/5305.html
Q Sweets for the Soul | 遇人の内懐 | no
MN ToAU19 19
LK condition:前節「泡沫の宝冠」クリア後、ヴァナ時間の0時を過ぎてエリアを出入りする
XS BG Wiki;https://www.bg-wiki.com/ffxi/Sweets_for_the_Soul;茶屋シャララトは BG Wiki・FFXIclopedia K-11、用語辞典 K-12
g01 go - | ヴァナ時間の0時を過ぎてからエリアを出入りし、アトルガン白門(I-10)のサラヒム・センチネルに入ってイベントを見る | 選ぶものはどれでもよい。 | @アトルガン白門 I-10 | W ヴァナ時間の0時を過ぎてから
g02 go - | アトルガン白門(K-11)の茶屋シャララトに入ってイベントを見ると完了 | - | @アトルガン白門 K-11 K-12

@ mission.aht_urhgan.020 https://wiki.ffo.jp/html/5308.html
Q Teahouse Tumult | 茶屋の厄難 | no
MN ToAU20 20
LK condition:前節「遇人の内懐」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Teahouse_Tumult;エジワ蘿洞の Map 5 の G-8（BG Wiki は F-8/G-8）の名前のない調べる物。Map 2 の D-8 か E-9 から下へ。ユニティワープ（ワジャーム樹林）からすぐ
g01 go - | アトルガン白門(K-12)の茶屋シャララトに入ってイベントを見る | 選ぶものはどれでもよい。 | @アトルガン白門 K-11 K-12
g02 go - | ワジャーム樹林(G-7)からエジワ蘿洞に入ってイベントを見る | Survival Guideか、ユニティワープでワジャーム樹林へ飛ぶと近い。 | @ワジャーム樹林 G-7
g03 examine - | MAP2の(D-8)か(E-9)から下へ降り、MAP5(G-8)の木の根もとの名前のない的を調べてイベントを見ると完了 | 「いいえ」を選ぶと同じ問いがくり返される。 | @エジワ蘿洞 G-8 #5

@ mission.aht_urhgan.021 https://wiki.ffo.jp/html/5310.html
Q Finders Keepers | 千古の渦紋 | no
MN ToAU21 21
RW title:カラババのボディガード
LK condition:前節「茶屋の厄難」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Finders_Keepers;サラヒム・センチネルに入るとイベント。称号 Karababa's Bodyguard は FFXIclopedia ではこの節、BG Wiki では次の節
g01 go - | アトルガン白門(I-10)のサラヒム・センチネルに入ってイベントを見ると完了 | 選ぶものはどれでもよい。 | @アトルガン白門 I-10

@ mission.aht_urhgan.022 https://wiki.ffo.jp/html/5311.html
Q Shield of Diplomacy | 特使の御楯 | no
MN ToAU22 22
LK condition:前節「千古の渦紋」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Shield_of_Diplomacy;ゼオルム火山の Home Point #1 が入口のすぐ前。入口は FFXIclopedia でゼオルム火山 D-8。Karababa が手伝い、HP が減ると帰ってしまい負けになる
g01 go - | ゼオルム火山(D-8)からナバゴ処刑場に入ってイベントを見る | ゼオルム火山のHome Point #1がすぐ前。ないときはユニティワープでゼオルム火山へ。 | @ゼオルム火山 D-8
g02 examine - | Decorative Bronze Gateを調べてイベントを見る | - | @ナバゴ処刑場
g03 fight - | もう一度Decorative Bronze Gateを調べてBF「特使の御楯」に入り、Khimaira 13を倒すと完了 | 6人・レベル制限なし。Karababaが手伝う。KarababaのHPが減ると帰ってしまい負けになるので回復する。 | @ナバゴ処刑場

@ mission.aht_urhgan.023 https://wiki.ffo.jp/html/5312.html
Q Social Graces | 宴遊の終幕 | no
MN ToAU23 23
LK condition:前節「特使の御楯」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Social_Graces;サラヒム・センチネルに入るとイベント
g01 go - | アトルガン白門(I-10)のサラヒム・センチネルに入ってイベントを見ると完了 | - | @アトルガン白門 I-10

@ mission.aht_urhgan.024 https://wiki.ffo.jp/html/5313.html
Q Foiled Ambition | 悪魔と悪鬼と | no
MN ToAU24 24
RW item:アトルガン黄金貨×5
RW title:カラババの特命エージェント
LK condition:前節「宴遊の終幕」クリア後、ヴァナ時間の0時を過ぎてエリアを出入りする
XS BG Wiki;https://www.bg-wiki.com/ffxi/Foiled_Ambition;ヴァナ時間で1日待ってエリアを出入りしてから、サラヒム・センチネルへ
g01 go - | ヴァナ時間の0時を過ぎてから、一度エリアを出て入り直す | 前のイベントの間に0時を過ぎていれば、出入りするだけでよい。 | @アトルガン白門 | W ヴァナ時間の0時を過ぎてから
g02 go - | アトルガン白門(I-10)のサラヒム・センチネルに入ってイベントを見ると完了 | - | @アトルガン白門 I-10

@ mission.aht_urhgan.025 https://wiki.ffo.jp/html/8887.html
Q Playing the Part | 運命の歯車 | no | T npc.アトルガン白門.Naja_Salaheem
MN ToAU25 25
LK condition:前節「悪魔と悪鬼と」クリア後、ヴァナ時間の0時を過ぎてエリアを出入りする
XS BG Wiki;https://www.bg-wiki.com/ffxi/Playing_the_Part;ヴァナ時間で1日待ってエリアを出入りしてから Naja Salaheem に話す。イベントでは Aphmau を選ぶ
g01 go - | ヴァナ時間の0時を過ぎてから、一度エリアを出て入り直す | - | @アトルガン白門 | W ヴァナ時間の0時を過ぎてから
g02 talk - | アトルガン白門(I-10)のNaja Salaheemに話してイベントを見ると完了 | イベントではAphmauを選ぶ。 | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem

@ mission.aht_urhgan.026 https://wiki.ffo.jp/html/11403.html
Q Seal of the Serpent | 魔蛇の封蝋 | no | T obj.アトルガン白門.Imperial_Whitegate
MN ToAU26 26
LK condition:前節「運命の歯車」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seal_of_the_Serpent;武器を外して Imperial Whitegate L-9（FFXIclopedia も L-9）を調べる
g01 examine - | 武器を外して、アトルガン白門(L-9)のImperial Whitegateを調べてイベントを見ると完了 | 「賓客の資格」とちがい、礼服は要らない。 | @アトルガン白門 L-9 | T obj.アトルガン白門.Imperial_Whitegate

@ mission.aht_urhgan.027 https://wiki.ffo.jp/html/11404.html
Q Misplaced Nobility | 貴人の失踪 | no
MN ToAU27 27
LK condition:前節「魔蛇の封蝋」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Misplaced_Nobility;「茶屋の厄難」と同じ場所。エジワ蘿洞 Map 5 の G-8（BG Wiki は F-8/G-8）の名前のない調べる物
g01 go - | エジワ蘿洞に入り、MAP2の(D-8)か(E-9)から下へ降りる | Survival Guideか、ユニティワープでワジャーム樹林へ飛ぶと近い。歩くならワジャーム樹林(G-7)から。 | @エジワ蘿洞 #2
g02 examine - | MAP5(G-8)の木の根もとの名前のない的を調べてイベントを見ると完了 | 「茶屋の厄難」と同じ場所。 | @エジワ蘿洞 G-8 #5

@ mission.aht_urhgan.028 https://wiki.ffo.jp/html/11405.html
Q Bastion of Knowledge | 古寺の所縁 | no
MN ToAU28 28
LK condition:前節「貴人の失踪」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Bastion_of_Knowledge;ワラーラ寺院に入るとイベント。寺院の入口は FFXIclopedia J-7、用語辞典 K-8（「黄金の騎士」では BG Wiki・FFXIclopedia とも K-8）
g01 go - | アトルガン白門(K-8)のワラーラ寺院に入ってイベントを見ると完了 | - | @アトルガン白門 J-7 K-8

@ mission.aht_urhgan.029 https://wiki.ffo.jp/html/11406.html
Q Puppet in Peril | 少女の傀儡 | no
MN ToAU29 29
RW title:アフマウの傭兵
LK condition:前節「古寺の所縁」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Puppet_In_Peril;称号 Aphmau's Mercenary は BG Wiki・FFXIclopedia では前節（ワラーラ寺院のイベント）。翡翠廟へはバフラウ段丘の Home Point #1 か、マムージャ監視哨から北の I-9。相手は Lancelord Gaheel Ja
g01 go - | バフラウ段丘(I-9)から翡翠廟に入る | バフラウ段丘のHome Point #1が近い。マムージャ監視哨から北へ行ってもよい（スニークとインビジかマウント）。 | @バフラウ段丘 I-9 #2
g02 examine - | Ornamental Doorを調べてイベントを見る | 長いイベント。 | @翡翠廟
g03 fight - | もう一度Ornamental Doorを調べてBF「少女の傀儡」に入り、Lancelord Gaheel Jaを倒すと完了 | 6人・30分・レベル制限なし。HPが減るとブレージングアンゴン（防御ダウンとノックバック）を何度も使う。防御ダウンは早く消す。 | @翡翠廟

@ mission.aht_urhgan.030 https://wiki.ffo.jp/html/11407.html
Q Prevalence of Pirates | 海賊の利 | no
MN ToAU30 30
RW key_item:アサルト領域特別通行許可証・ペリキア
LK condition:前節「少女の傀儡」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Prevalence_of_Pirates;アラパゴ暗礁域に入るとイベント、Cutter H-8 に近づくともう一度。終わったら歩いて南のカダーバの浮沼のドゥブッカ島監視哨へ行ける
g01 go - | アラパゴ暗礁域に入ってイベントを見る | カダーバの浮沼のSurvival Guideから南の(G-8)の入口が近い。 | @アラパゴ暗礁域
g02 go - | アラパゴ暗礁域MAP3(H-8)のCutterに近づいてイベントを見ると完了 | 次の節の場所へはここから南へ歩いて行けるので、デジョンしない。 | @アラパゴ暗礁域 H-8 #3 | T obj.54.Cutter

@ mission.aht_urhgan.031 https://wiki.ffo.jp/html/11408.html
Q Shades of Vengeance | 暗雲の去来 | no
MN ToAU31 31
RW title:ナシュメラの傭兵
LK condition:前節「海賊の利」クリア、だいじなもの「アサルト領域特別通行許可証・ペリキア」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Shades_of_Vengeance;ドゥブッカ島監視哨のすぐ西の Runic Seal から。K23H1-LAMIA（H-9 にまとまっている）を何体か倒すと勝ち（FFXIclopedia は3体）。負けたら監視哨の Nahshib から許可証をもらい直す（ヴァナ時間で1日に1回）
g01 go - | カダーバの浮沼のドゥブッカ島監視哨へ行く | Cutterから南へ歩いてカダーバの浮沼に入るとすぐ。 | @カダーバの浮沼 I-9 #2
g02 fight - | 監視哨のすぐ西のRunic Sealを調べ、「暗雲の去来」を選んでBFに入る | 6人・レベル制限なし。フェイスも呼べる。 | @カダーバの浮沼 #2 | K アサルト領域特別通行許可証・ペリキア
g03 defeat - | (H-9)にまとまっているK23H1-LAMIAを3体ほど倒すと完了 | リンクするので、1体ずつ釣る。毒が強いので毒消しかポイゾナを。スリプル・グラビデ・バインドが効く。負けたら監視哨のNahshibから許可証をもらい直す。 | @ペリキア H-9

@ mission.aht_urhgan.032 https://wiki.ffo.jp/html/11409.html
Q In the Blood | 逢魔が時 | no | T npc.アトルガン白門.Naja_Salaheem
MN ToAU32 32
RW item:アトルガン黄金貨
LK condition:前節「暗雲の去来」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/In_the_Blood;Naja Salaheem に話す
g01 talk - | アトルガン白門(I-10)のNaja Salaheemに話してイベントを見ると完了 | - | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem

@ mission.aht_urhgan.033 https://wiki.ffo.jp/html/11410.html
Q Sentinels' Honor | 砂上の楼閣 | no | T npc.アトルガン白門.Naja_Salaheem
MN ToAU33 33
LK condition:前節「逢魔が時」クリア後、ヴァナ時間の0時を過ぎてエリアを出入りする
XS BG Wiki;https://www.bg-wiki.com/ffxi/Sentinels%27_Honor;ヴァナ時間で1日待ってエリアを出入りしてから Naja Salaheem に話す。待つあいだに、次の節で要るイフラマド金貨をカダーバの浮沼 E-10 の Jazaraat's Headstone でもらっておける
g01 go - | ヴァナ時間の0時を過ぎてから、一度エリアを出て入り直す | 待つあいだに、次の節で要るイフラマド金貨をもらっておくとよい。 | @アトルガン白門 | W ヴァナ時間の0時を過ぎてから
g02 talk - | アトルガン白門(I-10)のNaja Salaheemに話してイベントを見ると完了 | - | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem

@ mission.aht_urhgan.034 https://wiki.ffo.jp/html/12217.html
Q Testing the Waters | 山猫の皮算用 | no | T obj.54.Cutter
MN ToAU34 34
LK condition:前節「砂上の楼閣」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Testing_The_Waters;Jazaraat's Headstone（カダーバの浮沼 E-10、FFXIclopedia も E-10）でイフラマド金貨をもう一度もらい、アラパゴ暗礁域 Map 5 H-8 の Cutter に近づく。終わるとタラッカ入江に移る
g01 examine - | イフラマド金貨を持っていなければ、カダーバの浮沼(E-10)のJazaraat's Headstoneを調べてもらう | 今回は戦闘なし。カダーバの浮沼のHome Point #1か、ナシュモの西の出口から近い。 | @カダーバの浮沼 E-10 #1 | T obj.79.Jazaraats_Headstone
g02 go - | アラパゴ暗礁域MAP3(H-8)のCutterに近づいてイベントを見ると完了 | イベントのあとタラッカ入江に移る。次の節もそこなので、デジョンしない。 | @アラパゴ暗礁域 H-8 #3 | T obj.54.Cutter | K イフラマド金貨

@ mission.aht_urhgan.035 https://wiki.ffo.jp/html/12218.html
Q Legacy of the Lost | 亡国の遺産 | no | T obj.タラッカ入江.Rock_Slab
MN ToAU35 35
RW key_item:冥衆の護符
RW title:財宝の番兵
LK condition:前節「山猫の皮算用」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Legacy_of_the_Lost;タラッカ入江の Rock Slab から BF。相手は Gessho で、分身を出し、HP が1〜2割で降参する。称号 Treasure Trove Tender は BG Wiki・FFXIclopedia では前節
g00 go - | はじめのイベントでだいじなもの「冥衆の護符」を受け取り、タラッカ入江へ移る | 途中の選択肢はどちらでもよい。 | @タラッカ入江
g01 fight - | タラッカ入江の入って左の洞窟の奥のRock SlabからBF「亡国の遺産」に入り、Gesshoに勝つと完了 | 6人・30分・フェイス可。分身を出すことがあり、分身も微塵がくれを使う。負けてもタラッカ入江に入り直せば何度でも挑める（カダーバの浮沼のHome Point #1が近い）。 | @タラッカ入江 | T obj.タラッカ入江.Rock_Slab

@ mission.aht_urhgan.036 https://wiki.ffo.jp/html/12219.html
Q Gaze of the Saboteur | 天狗の慧眼 | no
MN ToAU36 36
RW title:月照の介錯人
LK condition:前節「亡国の遺産」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Gaze_of_the_Saboteur;ハザルム試験場の入口はカダーバの浮沼 Map 1 の D-9（FFXIclopedia D-10、用語辞典 E-10）。入るとイベント、Entry Gate を調べるとイベント。称号 Gessho's Mercy は BG Wiki・FFXIclopedia では前節
g00 go - | タラッカ入江の南の出口からカダーバの浮沼へ出る | 北の出口はアラパゴ暗礁域に出てしまう。タラッカ入江は地図がないので迷いやすい。 | @タラッカ入江
g01 go - | 西へ進んだ先の入口からハザルム試験場に入ってイベントを見る | カダーバの浮沼のHome Point #1からも近い。 | @カダーバの浮沼 D-9 D-10 #1
g02 examine - | ハザルム試験場のEntry Gateを調べてイベントを見ると完了 | - | @ハザルム試験場

@ mission.aht_urhgan.037 https://wiki.ffo.jp/html/12220.html
Q Path of Blood | 修羅の道 | no
MN ToAU37 37
RW key_item:輝金の短剣
RW title:聖皇の密使
LK condition:前節「天狗の慧眼」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Path_of_Blood;サラヒム・センチネルに入るとイベント。称号 Emissary of the Empress とだいじなもの Luminian Dagger は BG Wiki・FFXIclopedia では前節
g01 go - | アトルガン白門(I-10)のサラヒム・センチネルに入ってイベントを見ると完了 | 同じ名前のクエスト「修羅の道」とは別。 | @アトルガン白門 I-10

@ mission.aht_urhgan.038 https://wiki.ffo.jp/html/12221.html
Q Stirrings of War | 戦乱の兆し | no
MN ToAU38 38
LK condition:前節「修羅の道」クリア後、ヴァナ時間の0時を過ぎてエリアを出入りする
XS BG Wiki;https://www.bg-wiki.com/ffxi/Stirrings_of_War;ヴァナ時間で1日待ってエリアを出入りしてから茶屋シャララトに入る。茶屋は BG Wiki・FFXIclopedia K-11、用語辞典 K-12
g01 go - | ヴァナ時間の0時を過ぎてから、一度エリアを出て入り直す | - | @アトルガン白門 | W ヴァナ時間の0時を過ぎてから
g02 go - | アトルガン白門の茶屋シャララトに入ってイベントを見ると完了 | - | @アトルガン白門 K-11 K-12

@ mission.aht_urhgan.039 https://wiki.ffo.jp/html/12929.html
Q Allied Rumblings | 連合の混迷 | no
MN ToAU39 39
RW key_item:四国軍事会議召喚状
LK condition:前節「戦乱の兆し」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Allied_Rumblings;ル・ルデの庭の宮殿の扉に近づくとイベント。Trion と話すイベントであることを確かめる。だいじなもの Allied Council Summons は BG Wiki・FFXIclopedia では前節
g01 go - | ル・ルデの庭(H-7)のオーロラ宮殿に入ってイベントを見ると完了 | イベントがいくつかあるので、Trionと話すものかを確かめる。 | @ル・ルデの庭 H-7

@ mission.aht_urhgan.040 https://wiki.ffo.jp/html/12930.html
Q Unraveling Reason | 紐解ける理 | no | T npc.243.Pherimociel
MN ToAU40 40
RW title:エンディミオン空艇隊員
LK condition:前節「連合の混迷」クリア後、ヴァナ時間の0時を過ぎてエリアを出入りする
XS BG Wiki;https://www.bg-wiki.com/ffxi/Unraveling_Reason;ヴァナ時間で1日待ってエリアを出入りしてから Pherimociel G-6（FFXIclopedia も G-6）に話す。イベントのあとワジャーム樹林の Leypoint に移る
g01 go - | ヴァナ時間の0時を過ぎてから、一度エリアを出て入り直す | 0時より前に話しても台詞だけ。 | @ル・ルデの庭 | W ヴァナ時間の0時を過ぎてから
g02 talk - | ル・ルデの庭(G-6)のオーロラ宮殿1階のPherimocielに話してイベントを見ると完了 | 「いいえ」を選んでも、その場で選び直せる。イベントのあとワジャーム樹林のLeypointに移る。 | @ル・ルデの庭 G-6 | T npc.243.Pherimociel

@ mission.aht_urhgan.041 https://wiki.ffo.jp/html/12931.html
Q Light of Judgment | 審判の光 | no | T npc.アトルガン白門.Rodin_Comidin = npc:Rodin-Comidin@アトルガン白門 I-7
MN ToAU41 41
LK condition:前節「紐解ける理」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Light_of_Judgment;アトルガン白門 I-7（FFXIclopedia も I-7）のからくり士ギルドの外の Rodin-Comidin に話す。だいじなもの Nyzul Isle Route は BG Wiki・FFXIclopedia ではこの節
g01 go - | ワジャーム樹林のLeypointから、アトルガン白門へ戻る | - | @ワジャーム樹林 G-8
g02 talk - | アトルガン白門(I-7)の2階、からくり士ギルドの外のRodin-Comidinに話してイベントを見ると完了 | - | @アトルガン白門 I-7 | T npc.アトルガン白門.Rodin_Comidin

@ mission.aht_urhgan.042 https://wiki.ffo.jp/html/12932.html
Q Path of Darkness | 巨人の懐へ | no
MN ToAU42 42
RW key_item:ナイズル島ルートメモ
LK condition:前節「審判の光」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Path_of_Darkness;ナイズル島監視哨の消えたランプの名前のない的 J-9 を調べて「はい」、同じ部屋の反対側の Runic Seal I-9 から BF。Naja Salaheem が一緒に戦い、倒れると負け。Amnaf と Imperial Gear 4体を2回、最後に Soulflayer になった Amnaf。負けたら Rodin-Comidin からだいじなものをもらい直す
g01 examine - | 六門院からアルザダール海底遺跡群のナイズル島監視哨へ飛び、すぐ後ろの(J-9)の名前のない「＿」を調べて「はい」を選ぶ | 「はい」を選ぶと、終わるまでサラヒム・センチネルに入れず、昇進試験も受けられない。 | @アルザダール海底遺跡群 J-9
g02 fight - | 同じ部屋の西の(I-9)のRunic SealからBF「巨人の懐へ」に入り、勝つと完了 | 6人・30分・レベル制限なし・フェイス可。Naja Salaheemが一緒に戦い、倒れると負けなので回復する。Amnafと歯車4体を2回、最後に姿を変えたAmnafを倒す。負けたらRodin-Comidinからナイズル島ルートメモをもらい直す。 | @アルザダール海底遺跡群 I-9 | K ナイズル島ルートメモ

@ mission.aht_urhgan.043 https://wiki.ffo.jp/html/12933.html
Q Fangs of the Lion | 蒼獅子の最期 | no
MN ToAU43 43
RW title:ナジャの戦友
LK condition:前節「巨人の懐へ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Fangs_of_the_Lion;Naja Salaheem に近づくとイベント（FFXIclopedia はサラヒム・センチネルに入るとイベント）。称号 Naja's Comrade-in-arms は BG Wiki・FFXIclopedia では前節
g01 go - | アトルガン白門(I-10)のサラヒム・センチネルに入ってイベントを見ると完了 | - | @アトルガン白門 I-10

@ mission.aht_urhgan.044 https://wiki.ffo.jp/html/12935.html
Q Nashmeira's Plea | 少女の決意 | no
MN ToAU44 44
RW key_item:霊銀の鏡
RW title:ナシュメラの腹心
LK condition:前節「蒼獅子の最期」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Nashmeira%27s_Plea;ナイズル島監視哨の名前のない的を調べ、Runic Seal I-9 から BF。45分。Raubahn を3回、Razfahd を HP 半分まで、そのあと Alexander。称号 Nashmeira's Loyalist とだいじなもの Mythril Mirror は BG Wiki・FFXIclopedia では前節
g01 go - | アトルガン白門(I-10)のサラヒム・センチネルに入ってイベントを見る | - | @アトルガン白門 I-10
g02 examine - | アルザダール海底遺跡群のナイズル島監視哨の(J-9)の名前のない「＿」を調べて「はい」を選ぶ | - | @アルザダール海底遺跡群 J-9
g03 fight - | 西の(I-9)のRunic SealからBF「少女の決意」に入り、勝つと完了 | 6人・45分・レベル制限なし・フェイス可。長い戦い。Raubahnは3回倒す必要があり、同じ種類の攻撃ばかりで倒すと最後はその攻撃が効かなくなる。次にRazfahdのHPを半分まで減らし、最後にAlexander。負けたらNaja Salaheemから霊銀の鏡をもらい直す。 | @アルザダール海底遺跡群 I-9 | K 霊銀の鏡

@ mission.aht_urhgan.045 https://wiki.ffo.jp/html/12936.html
Q Ragnarok | ラグナロク（ミッション） | no
MN ToAU45 45
RW title:ラグナロクの調停者
LK condition:前節「少女の決意」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Ragnarok_(Mission);Naja Salaheem に近づくとイベント。称号 Preventer of Ragnarok は BG Wiki・FFXIclopedia では前節
g01 go - | アトルガン白門(I-10)のサラヒム・センチネルに入ってイベントを見ると完了 | - | @アトルガン白門 I-10

@ mission.aht_urhgan.046 https://wiki.ffo.jp/html/12938.html
Q Imperial Coronation | 戴冠の儀 | no | T obj.アトルガン白門.Imperial_Whitegate
MN ToAU46 46
LK condition:前節「ラグナロク」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Imperial_Coronation;第17節と同じ胴装備と、両手・両脚・両足にも何か着る。Imperial Whitegate は FFXIclopedia L-9、用語辞典 L-8
g01 go - | アトルガン白門(I-10)のサラヒム・センチネルでイベントを見る | - | @アトルガン白門 I-10
g02 examine - | 「賓客の資格」と同じ胴装備と、両手・両脚・両足にも何か着て、武器を外し、アトルガン白門のImperial Whitegateを調べてイベントを見ると完了 | 身なりがちがうか、武器を持っていると入れない。 | @アトルガン白門 L-8 L-9 | T obj.アトルガン白門.Imperial_Whitegate

@ mission.aht_urhgan.047 https://wiki.ffo.jp/html/12939.html
Q The Empress Crowned | 大団円 | no | T obj.アトルガン白門.Imperial_Whitegate
MN ToAU47 47
RW item:バルラーンリング・ウルタラムリング・ジャルザーンリングから1つ
RW item:皇国旗
RW title:アトルガンの守護者
LK condition:前節「戴冠の儀」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Empress_Crowned;指輪はあとで選んでもよい（Imperial Whitegate）。指輪を捨てたら Nadeey（BG Wiki・FFXIclopedia J-7）でもらい直せる（コンクエスト集計ごとに1回）。FFXIclopedia は指輪と Imperial Standard を前節の報酬にしている
g01 examine - | イベントの中で指輪を3つから1つ選ぶと完了 | 選ばずにおいて、あとでImperial Whitegateを調べて選んでもよい。持ち物がいっぱいならあとで受け取れる。 | @アトルガン白門 L-8 L-9 | T obj.アトルガン白門.Imperial_Whitegate

@ mission.aht_urhgan.048 https://wiki.ffo.jp/html/12940.html
Q Eternal Mercenary | 永遠の傭兵 | no | T npc.アトルガン白門.Naja_Salaheem
MN ToAU48 48
RW item:グローリークラウン
RW title:エターナルマーシナリー
LK condition:前節「大団円」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Eternal_Mercenary;Naja Salaheem に近づくと最後のイベント。終わったら Imperial Whitegate を調べるとフェイス Nashmeira
g01 go - | アトルガン白門(I-10)のサラヒム・センチネルでNaja Salaheemに近づき、イベントを見ると完了 | 選択肢はどれでも同じ。このあとImperial Whitegateを調べると、フェイスのNashmeiraがもらえる。 | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem
