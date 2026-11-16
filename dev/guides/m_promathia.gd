# プロマシアミッション（0.1.119〜）。基礎シートのミッション一覧 80〜140 行。id はシートの行の順、order は BG Wiki の並び
# ふたつの道（3-3）はサンドリア編（3-3A）とウィンダス編（3-3B）を先に並べ、本体は両方のあと
@ mission.promathia.001 https://wiki.ffo.jp/html/4756.html
Q The Rites of Life | 命の洗礼 | no | T obj.184.Tales_Beginning = obj:Tales' Beginning@デルクフの塔下層 H-10 #2
MN PM1-1 1
LK condition:「プロマシアの呪縛」をインストール済み
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Rites_of_Life;デルクフの塔下層に入ると始まる。後にしたときは H-10 の Tales' Beginning から。ジュノ上層 G-10 の診療所の Monberaux（FFXIclopedia も G-10）
g01 go - | デルクフの塔下層に入り、イベントを始めるを選ぶ | 後にすることもできる。 | @デルクフの塔下層
g02 examine - | 後にしたときは、デルクフの塔下層MAP2(H-10)のTales' Beginningを調べる | - | @デルクフの塔下層 H-10 #2 | T obj.184.Tales_Beginning
g03 go - | ジュノ上層に入ってイベントを見る | - | @ジュノ上層
g04 talk - | ジュノ上層(G-10)の診療所のMonberauxに話してイベントを見ると完了 | Home Point #3のそば。 | @ジュノ上層 G-10 | T npc.244.Monberaux

@ mission.promathia.002 https://wiki.ffo.jp/html/4129.html
Q Below the Arks | 楼閣の下に | no | T npc.243.Pherimociel = npc:Pherimociel@ル・ルデの庭 G-6
MN PM1-2 2
RW key_item:ホラの輝き／デムの輝き／メアの輝き（入ったプロミヴォンのもの）
LK condition:前節「命の洗礼」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Below_the_Arks;宮殿の Pherimociel G-6（FFXIclopedia も G-6）。Rainhard H-6 と Harith H-5 は話さなくてもよい
g01 talk - | ル・ルデの庭(G-6)のPherimocielに話してイベントを見る | 先に(H-6)のRainhardに話してもよい。 | @ル・ルデの庭 G-6 | T npc.243.Pherimociel
g02 examine - | Shattered Telepointを調べて転移の間に入り、左のLarge Apparatusを調べてプロミヴォンへ | ホラはラテーヌ高原、デムはコンシュタット高地、メアはタロンギ大峡谷のShattered Telepointから。 | @転移の間
g03 go - | 各階層のMemory Receptacleを倒して出たワープで先へ進み、第4階層の塔を目指す | 途中で別のプロミヴォンに行くときは、今のエリアの記憶を消す。
g04 fight - | 塔でBF「誘うは古のほむら」に入り、ボスを倒す | 6人・30分。ホラはWreaker、デムはProgenerator、メアはDelver。睡眠は効かない。 | 
g05 go - | 1か所クリアして輝きをもらうと完了 | 残りの2か所は次の節で回る。

@ mission.promathia.003 https://wiki.ffo.jp/html/1515.html
Q The Mothercrystals | 母なる石 | no
MN PM1-3 3
RW key_item:ホラの輝き
RW key_item:デムの輝き
RW key_item:メアの輝き
RW title:古のほむらに触れし者
LK condition:前節「楼閣の下に」で1か所目のプロミヴォンをクリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Mothercrystals;転移の間の Large Apparatus は左手。3か所目を終えるとルフェーゼ野へ飛ばされる
g01 go - | 転移の間から、まだクリアしていないプロミヴォンへ入る | Shattered Telepointを調べて転移の間へ入り、左のLarge Apparatusから。 | @転移の間
g02 fight - | 第4階層の塔まで進み、BF「誘うは古のほむら」で勝つ | 2か所とも同じようにする。 | 
g03 go - | 3か所目をクリアするとルフェーゼ野へ飛ばされ、完了 | -

@ mission.promathia.004 https://wiki.ffo.jp/html/7035.html
Q An Invitation West | 西への誘い | no
MN PM2-1 4
RW title:どざえもん
LK condition:ホラ・デム・メアの3プロミヴォンをクリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/An_Invitation_West;ルフェーゼ野 K-9 に出てイベント（FFXIclopedia のイベント位置は K-8）。タブナジア地下壕の入口は F-10（FFXIclopedia は E-8 と F-10）
g01 go - | 3か所目のプロミヴォンをクリアしたあと、ルフェーゼ野に出てイベントを見る | - | @ルフェーゼ野
g02 go - | ルフェーゼ野を西へ進み、(F-10)からタブナジア地下壕に入る | タブナジア群島の地図は地図屋で買える。 | @ルフェーゼ野 F-10
g03 go - | タブナジア地下壕に入ってイベントを見ると完了 | - | @タブナジア地下壕

@ mission.promathia.005 https://wiki.ffo.jp/html/6768.html
Q The Lost City | 忘却の町 | no | T npc.26.Despachiaire
MN PM2-2 5
LK condition:前節「西への誘い」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Lost_City;上の階の南の Walnut Door K-9（北の K-7 ではない）の奥に Despachiaire K-10、最下層の Sewer Entrance I-7。FFXIclopedia も同じ座標
g01 talk - | タブナジア地下壕MAP1(K-9)のWalnut Doorから入り、(K-10)のDespachiaireに話してイベントを見る | 上の階の南側の扉。北の(K-7)の扉ではない。 | @タブナジア地下壕 K-10 #1 | T npc.26.Despachiaire
g01a go - | タブナジア地下壕のいちばん下の階（MAP3）へ降りる | - | @タブナジア地下壕 #3
g02 examine - | MAP3(I-7)のSewer Entranceを調べると完了 | フォミュナ水道への入口。 | @タブナジア地下壕 I-7 #3 | T obj.26.Sewer_Entrance = obj:Sewer Entrance@タブナジア地下壕 I-7 #3

@ mission.promathia.006 https://wiki.ffo.jp/html/4131.html
Q Distant Beliefs | 隔たれし信仰 | no | T obj.26.Sewer_Entrance
MN PM2-3 6
LK condition:前節「忘却の町」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Distant_Beliefs;Minotaur は 2枚目の J-2（FFXIclopedia は J-3）。Iron Gate G-8、Wooden Ladder E-8（2枚目、FFXIclopedia も同じ）。3枚目 F-7 の ???、F-8 の Oil Lamp。Justinius J-6
g01 go - | フォミュナ水道を進み、2枚目のマップの(J-2)の小部屋へ行く | (I-6)のはしごを登り、(K-5)で降りて水路を進む。スニークとインビジが要る。 | @フォミュナ水道 J-2 J-3 #2
g02 defeat - | タウルス族のNM、Minotaurを倒す | モータルレイの死の宣告に気をつける。赤い線が出たら背を向ける。 | @フォミュナ水道 J-2 J-3 #2 | T mob.27.Minotaur = mob:Minotaur@フォミュナ水道 J-2 J-3 #2
g03 trade - | 2枚目の(G-8)のIron Gateを青銅のカギかシーフツールで開け、(E-8)のWooden Ladderを調べてイベントを見る | 青銅のカギは水道のフォモル族が落とす。(G-8)の水に落ちると回り直しになる。 | @フォミュナ水道 G-8 #2 | T obj.27.Iron_Gate_G-8 = obj:Iron Gate@フォミュナ水道 G-8 #2 | N 青銅のカギ
g04 examine - | はしごを登って3枚目のマップへ。(F-7)の部屋の南側の本棚の裏の???を調べ、隠し扉を開ける | - | @フォミュナ水道 F-7 #3
g05 examine - | (F-8)の通路で、その日の曜日の属性のランプと、その右どなりのランプを調べて扉を開ける | 並びは南から火・土・水・風・（扉）・氷・雷・光・闇。光曜日と闇曜日は光と闇。 | @フォミュナ水道 F-8 #3 | T obj.27.Oil_Lamp = obj:Oil Lamp@フォミュナ水道 F-8 #3
g06 examine - | いちばん奥の扉を調べてイベントを見る | - | @フォミュナ水道 #3
g07 talk - | タブナジア地下壕MAP1(J-6)のJustiniusに話すと完了 | Home Point #3の北。 | @タブナジア地下壕 J-6 #1 | T npc.26.Justinius

@ mission.promathia.007 https://wiki.ffo.jp/html/7290.html
Q An Eternal Melody | とこしえに響く歌 | no | T obj.26.Walnut_Door_K-7 = obj:Walnut Door@タブナジア地下壕 K-7 #1
MN PM2-4 7
LK condition:前節「隔たれし信仰」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/An_Eternal_Melody;上の階の北の Walnut Door K-7、ミザレオ海岸 I-11 の Dilapidated Gate、本階の橋 H/I-8。FFXIclopedia も K-7 と I-11
g01 examine - | タブナジア地下壕MAP1(K-7)のWalnut Doorを調べてイベントを見る | 上の階の北側の扉。南の(K-9)の扉ではない。 | @タブナジア地下壕 K-7 #1 | T obj.26.Walnut_Door_K-7
g02 talk - | (J-6)のJustiniusに話し、ウルミアの行き先を聞く | 話さなくても進められる。 | @タブナジア地下壕 J-6 #1 | T npc.26.Justinius
g03 examine - | ミザレオ海岸(I-11)のDilapidated Gateを調べてイベントを見る | 地下壕の南の出口から出ると近い。 | @ミザレオ海岸 I-11 | T obj.25.Dilapidated_Gate_I-11 = obj:Dilapidated Gate@ミザレオ海岸 I-11
g04 go - | タブナジア地下壕に戻り、MAP2(I-8)の吊り橋に近づいてイベントを見ると完了 | まん中の階の吊り橋。 | @タブナジア地下壕 H-8 I-8 #2

@ mission.promathia.008 https://wiki.ffo.jp/html/2566.html
Q Ancient Vows | 誓いの雄叫び | no | T obj.25.Dilapidated_Gate
MN PM2-5 8
RW title:聖者の島を訪れし者
RW other:経験値1000
LK condition:前節「とこしえに響く歌」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Ancient_Vows;ミザレオ海岸 F-7 の Dilapidated Gate、D-6 の Spatial Displacement。サイトA01 G-10 と E-10 の Unstable Displacement に Giant Scale を1枚ずつ（FFXIclopedia も同じ）
g01 examine - | ミザレオ海岸(F-7)のDilapidated Gateを調べてイベントを見る | ユニティワープ（CL128）でミザレオ海岸へ飛ぶと門のすぐそば。 | @ミザレオ海岸 F-7 | T obj.25.Dilapidated_Gate
g02 examine - | (D-6)のSpatial Displacementを調べてリヴェーヌ岩塊群サイトA01へ入り、イベントを見る | - | @ミザレオ海岸 D-6 | T obj.25.Spatial_Displacement_D-6 = obj:Spatial Displacement@ミザレオ海岸 D-6
g03 trade - | サイトA01(G-10)と(E-10)のUnstable Displacementに巨大な鱗を1枚ずつ渡して先へ進む | 全員が近くにいるときに渡す。 | @リヴェーヌ岩塊群サイトA01 G-10 E-10 | N 巨大な鱗*2
g04 go - | 北東のSpatial Displacementから帝龍の飛泉へ入る | - | @リヴェーヌ岩塊群サイトA01
g05 fight - | 帝龍の飛泉の奥のSpatial DisplacementからBF「誓いの雄叫び」に入り、イベントのあとの戦闘に勝つ | - | @帝龍の飛泉
g06 go - | 勝ったあとのイベントで南グスタベルグへ飛ばされると完了 | -

@ mission.promathia.009 https://wiki.ffo.jp/html/4841.html
Q The Call of the Wyrmking | 龍王の導き | no | T npc.237.Cid
MN PM3-1 9
LK condition:前章「誓いの雄叫び」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_3-1;南グスタベルグの灯台のそばから。バストゥーク港 F-7 の飛空艇乗り場の入口の外、大工房2階 H-8 の Cid（FFXIclopedia も F-7 と H-8）
g01 go - | バストゥーク港(F-7)の飛空艇乗り場の入口に近づいてイベントを見る | 建物の外。乗船券は要らない。出ないときはエリアを出て入り直す。 | @バストゥーク港 F-7
g02 talk - | 大工房2階(H-8)のCidに話してイベントを見ると完了 | - | @大工房 H-8 | T npc.237.Cid

@ mission.promathia.010 https://wiki.ffo.jp/html/7057.html
Q A Vessel Without a Captain | 主のなき都 | no | T obj.245.Door_Neptunes_Spire
MN PM3-2 10
LK condition:前節「龍王の導き」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_3-2;ジュノ下層 J-7 の天晶堂の奥の扉、ル・ルデの庭の宮殿の Audience Chamber への階段でイベント
g01 examine - | ジュノ下層(J-7)の天晶堂のいちばん奥のDoor:"Neptune's Spire"を調べてイベントを見る | Home Point #2が近い。 | @ジュノ下層 J-7 | T obj.245.Door_Neptunes_Spire
g02 go - | ル・ルデの庭のオーロラ宮殿に入り、奥の階段でイベントを見ると完了 | - | @ル・ルデの庭 | T obj.243.Door_Audience_Chamber

@ mission.promathia.012 https://wiki.ffo.jp/html/2100.html
Q Emerald Waters | 瑠璃色の川 | no
MN PM3-3A1 11
LK condition:「ふたつの道」を受けている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Road_Forks;サンドリア編の最初。北サンドリアに入るとイベント
g01 go - | 北サンドリアに入ってイベントを見ると完了 | 「ふたつの道」を受けると、この節がリストに出る。 | @北サンドリア

@ mission.promathia.013 https://wiki.ffo.jp/html/4872.html
Q Vicissitudes | 流転 | no | T npc.231.Arnau = npc:Arnau@北サンドリア M-6
MN PM3-3A2 12
LK condition:「瑠璃色の川」のイベントを見ている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Road_Forks;大聖堂の祭壇の Arnau M-6（FFXIclopedia も M-6）、Manuscript room の Chasalvige L-6
g01 talk - | 北サンドリア(M-6)の大聖堂の祭壇にいるArnauに話してイベントを見る | Home Point #2か#3が近い。 | @北サンドリア M-6 | T npc.231.Arnau
g02 talk - | 大聖堂の奥(L-6)のChasalvigeに話してイベントを見ると完了 | - | @北サンドリア L-6 | T npc.231.Chasalvige = npc:Chasalvige@北サンドリア L-6

@ mission.promathia.014 https://wiki.ffo.jp/html/4867.html
Q Descendants of a Line Lost | 累家の末流 | no | T npc.2.Guilloud = npc:Guilloud@ギルド桟橋 H-10 #1
MN PM3-3A3 13
LK condition:前節「流転」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Road_Forks;英語名は BG Wiki・FFXIclopedia の Descendants of a Line Lost（基礎シートは Descendents of Line Lost）。ジャグナー森林 E-6 からギルド桟橋、H-10 の Guilloud に話すと Overgrown Ivy が出る（FFXIclopedia も H-10）
g01 go - | ジャグナー森林(E-6)からギルド桟橋に入る | ギルド桟橋のSurvival Guideからは水にはばまれる。 | @ジャグナー森林 E-6
g02 talk - | ギルド桟橋(H-10)のGuilloudに話す | 何度か話さないとNMが出ないことがある。 | @ギルド桟橋 H-10 #1 | T npc.2.Guilloud
g03 defeat - | 出てきたモルボル族のNM、Overgrown Ivyを倒す | 手数の多い連続攻撃を使う。スリプルと足止めが効く。 | @ギルド桟橋 H-10 #1 | T mob.2.Overgrown_Ivy = mob:Overgrown Ivy@ギルド桟橋 H-10 #1
g04 talk - | もう一度Guilloudに話してイベントを見ると完了 | - | @ギルド桟橋 H-10 #1 | T npc.2.Guilloud

@ mission.promathia.015 https://wiki.ffo.jp/html/4859.html
Q Louverance | ルーヴランスという者 | no | T npc.230.Hinaree = npc:Hinaree@南サンドリア B-6
MN PM3-3A4 14
LK condition:前節「累家の末流」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Road_Forks;南サンドリア B-6、Count's Manor 2階の Hinaree（FFXIclopedia も B-6）
g01 talk - | 南サンドリア(B-6)の屋敷の2階のHinareeに話してイベントを見ると完了 | これでサンドリア編が終わる。Home Point #4が近い。 | @南サンドリア B-6 | T npc.230.Hinaree

@ mission.promathia.016 https://wiki.ffo.jp/html/2101.html
Q Memories of a Maiden | をとめの記憶 | no
MN PM3-3B1 15
LK condition:「ふたつの道」を受けている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Road_Forks;ウィンダス編の最初。ウィンダス水の区に入るとイベント
g01 go - | ウィンダス水の区に入ってイベントを見ると完了 | 「ふたつの道」を受けると、この節がリストに出る。 | @ウィンダス水の区

@ mission.promathia.017 https://wiki.ffo.jp/html/4608.html
Q Comedy of Errors, Act I | をかしき祖国 | no | T npc.238.Ohbiru-Dohbiru = npc:Ohbiru-Dohbiru@ウィンダス水の区 J-9 #2
MN PM3-3B2 16
LK condition:前節「をとめの記憶」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Road_Forks;鼻の院の Ohbiru-Dohbiru J-9（南のマップ）、Yoran-Oran E-5、酒場の Kyume-Romeh F-10（北のマップ）。FFXIclopedia も同じ
g01 talk - | ウィンダス水の区MAP2(J-9)の鼻の院の南の部屋のOhbiru-Dohbiruに話してイベントを見る | Home Point #3のすぐそば。 | @ウィンダス水の区 J-9 #2 | T npc.238.Ohbiru-Dohbiru
g02 talk - | ウィンダス石の区(E-5)のYoran-Oranに話し、再生の鏡さがしを頼まれる | ほかの話が出たら、もう一度話す。 | @ウィンダス石の区 E-5 | T npc.239.Yoran-Oran
g03 talk - | ウィンダス水の区MAP1(F-10)の音楽の森レストランのKyume-Romehに話してイベントを見ると完了 | Home Point #4が近い。 | @ウィンダス水の区 F-10 #1 | T npc.238.Kyume-Romeh = npc:Kyume-Romeh@ウィンダス水の区 F-10 #1

@ mission.promathia.018 https://wiki.ffo.jp/html/4607.html
Q Comedy of Errors, Act II | をかしき再会 | no | T npc.238.Honoi-Gomoi = npc:Honoi-Gomoi@ウィンダス水の区 E-7 #2
MN PM3-3B3 17
LK condition:前節「をかしき祖国」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Road_Forks;Honoi-Gomoi E-7（南のマップ）、アットワ地溝 K-8 の Loose Sand で Lioumere、パラダモの丘の上の Cradle of Rebirth。登り口は K-9。FFXIclopedia も K-8
g01 talk - | ウィンダス水の区MAP2(E-7)の民家2階のHonoi-Gomoiに話し、「壊れた再生の鏡」を受け取る | 裏口の階段から入る。 | @ウィンダス水の区 E-7 #2 | T npc.238.Honoi-Gomoi
g02 talk - | ウィンダス石の区(E-5)のYoran-Oranに話してイベントを見る | 鏡はなくなる。持ったままだと次のNMが出ない。 | @ウィンダス石の区 E-5 | T npc.239.Yoran-Oran
g03 defeat - | アットワ地溝(K-8)の3本の木の間のLoose Sandを調べ、出てきたアントリオン族のNM、Lioumereを倒す | 技のあと砂に戻ってHPが全快するので、離して戦う。ユニティワープ（CL125）が早い。 | @アットワ地溝 K-8 | T mob.7.Lioumere = mob:Lioumere@アットワ地溝 K-8
g04 examine - | もう一度Loose Sandを調べて「再生の玉」を受け取る | 30分のうちに頂上へ。マウント、ネクサスケープ、エリアを出ると玉が壊れる。壊れたらまた砂を調べる。 | @アットワ地溝 K-8 | T obj.7.Loose_Sand = obj:Loose Sand@アットワ地溝 K-8
g05 examine - | 歩いてパラダモの丘の頂上へ登り、Cradle of Rebirthを調べて「再生の羽」3枚にかえる | 登り口は(K-9)。何人かなら1人ずつ調べる。 | @アットワ地溝 | T obj.7.Cradle_of_Rebirth = obj:Cradle of Rebirth@アットワ地溝 | K 再生の玉
g06 talk - | ウィンダス石の区(E-5)のYoran-Oranに話すと完了 | - | @ウィンダス石の区 E-5 | T npc.239.Yoran-Oran

@ mission.promathia.019 https://wiki.ffo.jp/html/4609.html
Q Exit Stage Left | をかしき旅立ち | no | T npc.240.Yujuju = npc:Yujuju@ウィンダス港 M-6
MN PM3-3B4 18
LK condition:前節「をかしき再会」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Road_Forks;Kyume-Romeh は話さなくてもよい。ウィンダス港 M-6 の Yujuju、目の院東棟の Tosuka-Porika G-8（北のマップ）、Yoran-Oran E-5。FFXIclopedia も同じ
g00 talk - | （してもしなくてもよい）ウィンダス水の区MAP1(F-10)のKyume-Romehに話す | 音楽の森レストランにいる。話さなくても進む。 | @ウィンダス水の区 F-10 #1 | T npc.238.Kyume-Romeh
g01 talk - | ウィンダス港(M-6)の飛空艇乗り場の前のYujujuに話してイベントを見る | Home Point #3が近い。 | @ウィンダス港 M-6 | T npc.240.Yujuju
g02 talk - | ウィンダス水の区MAP1(G-8)の目の院東棟のTosuka-Porikaに話してイベントを見る | Home Point #1が近い。 | @ウィンダス水の区 G-8 #1 | T npc.238.Tosuka-Porika
g03 talk - | ウィンダス石の区(E-5)のYoran-Oranに話してイベントを見ると完了 | これでウィンダス編が終わる。 | @ウィンダス石の区 E-5 | T npc.239.Yoran-Oran

@ mission.promathia.011 https://wiki.ffo.jp/html/2102.html
Q The Road Forks | ふたつの道 | no
MN PM3-3 19
LK condition:前節「主のなき都」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Road_Forks;サンドリア編とウィンダス編はどちらが先でもよく、同時に進めてもよい。両方が要る
g01 go - | サンドリア編（瑠璃色の川から）を進める | 北サンドリアに入ると始まる。 | @北サンドリア
g02 go - | ウィンダス編（をとめの記憶から）を進める | ウィンダス水の区に入ると始まる。どちらが先でもよい。 | @ウィンダス水の区
g03 go - | 両方を終えると完了 | 次の節は大工房のCidから。

@ mission.promathia.020 https://wiki.ffo.jp/html/2098.html
Q Tending Aged Wounds | 戦慄き | no | T npc.237.Cid
MN PM3-4 20
LK condition:「ふたつの道」のサンドリア編・ウィンダス編を両方クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Tending_Aged_Wounds;ジュノ下層に入るとイベント、天晶堂の扉でもう一度。FFXIclopedia のイベント一覧の最初は大工房
g01 talk - | 大工房2階(H-8)のCidに話してイベントを見る | - | @大工房 H-8 | T npc.237.Cid
g02 go - | ジュノ下層に入ってイベントを見る | - | @ジュノ下層
g03 examine - | ジュノ下層(J-7)の天晶堂のいちばん奥のDoor:"Neptune's Spire"を調べてイベントを見ると完了 | - | @ジュノ下層 J-7 | T obj.245.Door_Neptunes_Spire

@ mission.promathia.021 https://wiki.ffo.jp/html/4136.html
Q Darkness Named | 神を名乗りて | no | T npc.244.Monberaux
MN PM3-5 21
RW key_item:ソ・ジヤ識別札
RW gil:500
RW title:夢を断つ者
RW title:うたかたなる夢を見し者
LK condition:前節「戦慄き」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Darkness_Named;Monberaux G-10、天晶堂の Ghebi Damomohe にチップ1つで 500 ギルと Pso'Xja pass（FFXIclopedia は I-7）。ボスディン氷河 H-8 の入口から。色の壁は 赤・黒・赤・黒の順、エレベーターで下りて北西の Stone Gate から異界の口
g01 talk - | ジュノ上層(G-10)の診療所のMonberauxに話してイベントを見る | Home Point #3のそば。 | @ジュノ上層 G-10 | T npc.244.Monberaux
g02 trade - | ジュノ下層(I-7)の天晶堂のGhebi Damomoheに、カーマインチップ・グレーチップ・シアンチップのどれかを渡して「ソ・ジヤ識別札」を受け取る | チップはソ・ジヤの敵が落とす。何人かで行くときは全員が要る。 | @ジュノ下層 I-7 | T npc.245.Ghebi_Damomohe | N カーマインチップ・グレーチップ・シアンチップのどれか
g03 go - | ボスディン氷河(H-8)からソ・ジヤに入り、奥の異界の口へ進む | 色の壁は赤、黒、赤、黒の順に通る。最後のエレベーターで下り、北西の道へ。 | @ボスディン氷河 H-8 | K ソ・ジヤ識別札
g04 fight - | 異界の口のMemento CircleからBF「神を名乗りて」に入って勝つ | 入るときと調べたときにイベントがある。 | @異界の口
g05 talk - | ジュノ上層(G-10)のMonberauxに話してイベントを見ると完了 | - | @ジュノ上層 G-10 | T npc.244.Monberaux

@ mission.promathia.022 https://wiki.ffo.jp/html/2236.html
Q Sheltering Doubt | よりしろ | no | T npc.26.Despachiaire
MN PM4-1 22
LK condition:前節「神を名乗りて」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Sheltering_Doubt;地下壕に入るとイベント、上の階の Despachiaire K-10、Justinius J-6 は話さなくてもよい、ミザレオ海岸 I-11 の Dilapidated Gate（FFXIclopedia も同じ）
g01 go - | タブナジア地下壕に入ってイベントを見る | Home Point #3が次の場所に近い。 | @タブナジア地下壕
g02 talk - | タブナジア地下壕MAP1(K-10)のDespachiaireに話してイベントを見る | Walnut Doorの奥。2回話すことがある。 | @タブナジア地下壕 K-10 #1 | T npc.26.Despachiaire
g02a talk - | （してもしなくてもよい）タブナジア地下壕MAP1(J-6)のJustiniusに話してイベントを見る | 見なくても、あとで記憶のウタイビト（MAP2 H-6のLatteaune）で見られる。 | @タブナジア地下壕 J-6 #1 | T npc.26.Justinius
g03 examine - | ミザレオ海岸(I-11)のDilapidated Gateを調べてイベントを見ると完了 | 地下壕の南の出口から出ると近い。 | @ミザレオ海岸 I-11 | T obj.25.Dilapidated_Gate_I-11

@ mission.promathia.023 https://wiki.ffo.jp/html/4138.html
Q The Savage | 猛き者たちよ | no | T obj.25.Dilapidated_Gate
MN PM4-2 23
RW title:龍に応える者
RW title:ナグモラーダのなじみ
LK condition:前節「よりしろ」の天華崎でのイベントを見ている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Savage;ミザレオ海岸 F-7 の門からサイトB01、Unstable Displacement は G-8（FFXIclopedia は G-8/H-8）に Giant Scale 1枚。サイトA01 からの帝龍の飛泉とは別の場所。Justinius J-6
g01 examine - | ミザレオ海岸(F-7)のDilapidated Gateを調べてイベントを見ると、リヴェーヌ岩塊群サイトB01へ移る | ユニティワープ（CL122・CL128）で門のすぐそばに出る。 | @ミザレオ海岸 F-7 | T obj.25.Dilapidated_Gate
g02 trade - | サイトB01の(G-8)のUnstable Displacementに巨大な鱗を1枚渡して通り、先のSpatial Displacementから帝龍の飛泉へ | サイトA01から行く帝龍の飛泉ではこのBFに入れない。 | @リヴェーヌ岩塊群サイトB01 G-8 H-8 | N 巨大な鱗
g03 fight - | 帝龍の飛泉のSpatial DisplacementからBF「猛き者たちよ」に入って勝つ | 30分。空を飛ぶので、Mistmeltがあると楽。 | @帝龍の飛泉
g04 talk - | タブナジア地下壕MAP1(J-6)のJustiniusに話してイベントを見ると完了 | Home Point #3が近い。 | @タブナジア地下壕 J-6 #1 | T npc.26.Justinius

@ mission.promathia.024 https://wiki.ffo.jp/html/2245.html
Q The Secrets of Worship | 礼拝の意味 | no | T obj.26.Walnut_Door_K-7
MN PM4-3 24
LK condition:前節「猛き者たちよ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Secrets_of_Worship;ミザレオ海岸の Iron Gate は G-4（FFXIclopedia も G-4）。2枚目 H-7 のカギ穴2つの扉、G-8 の Wooden Gate、6つの教室の机の ??? から Old Professor Mariselle。Keremet は FFXIclopedia で K-8 の奥の部屋
g01 examine - | タブナジア地下壕MAP1(K-7)のWalnut Doorを調べてイベントを見る | Home Point #3が近い。 | @タブナジア地下壕 K-7 #1 | T obj.26.Walnut_Door_K-7
g02 examine - | ミザレオ海岸(G-4)のIron Gateを調べてイベントを見て、礼拝堂へ入る | 礼拝堂の1枚目の迷路は曜日でかわる。 | @ミザレオ海岸 G-4 | T obj.25.Iron_Gate_G-4 = obj:Iron Gate@ミザレオ海岸 G-4
g03 defeat - | 礼拝堂のフォモル族から「珊瑚の紋章のカギ」、コース族のNM、Keremetから「海獅子の紋章のカギ」を手に入れる | 「侯国騎士団長のカギ」があれば要らない。Keremetの手前の骸骨を先に倒す。 | @礼拝堂 L-8 #2 | T mob.28.Keremet = mob:Keremet@礼拝堂 L-8 #2
g04 trade - | 礼拝堂MAP2(H-7)の扉で、1人がSmall Keyholeに珊瑚の紋章のカギ、もう1人が数秒のうちにLarge Keyholeに海獅子の紋章のカギを渡して開ける | 侯国騎士団長のカギがあれば1人で開く。珊瑚の紋章のカギは使うとなくなる。 | @礼拝堂 H-7 #2 | N 珊瑚の紋章のカギ,海獅子の紋章のカギ
g05 examine - | 扉の奥の右手、(G-8)のWooden Gateを調べてイベントを見る | - | @礼拝堂 G-8 #2 | T obj.28.Wooden_Gate = obj:Wooden Gate@礼拝堂 G-8 #2
g06 defeat - | 近くの教室の机の???を調べ、出てきたゴースト族のNM、Old Professor Mariselleを倒す | どの教室から出るかは決まっていない。弟子を呼び、ワープしてスリプガを使う。 | @礼拝堂 #2 | T mob.28.Old_Professor_Mariselle = mob:Old Professor Mariselle@礼拝堂 #2
g07 examine - | もう一度???を調べて「礼拝堂宝物庫のカギ」を受け取る | 全員が調べる。 | @礼拝堂 #2
g08 examine - | もう一度(H-7)の扉を通り、(G-8)のWooden Gateを調べてイベントを見ると完了 | - | @礼拝堂 G-8 #2 | T obj.28.Wooden_Gate | K 礼拝堂宝物庫のカギ

@ mission.promathia.025 https://wiki.ffo.jp/html/7558.html
Q Slanderous Utterings | そしりを受けつつも | no | T npc.26.Despachiaire
MN PM4-4 25
RW title:迷いに心揺れし者
LK condition:前節「礼拝の意味」クリア
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/Slanderous_Utterings;海獅子の巣窟への入口は地下壕 H-9、Iron Gate は海獅子の巣窟 H-6（BG Wiki と用語辞典には座標がない）。BG Wiki の Despachiaire は K-10
g01 go - | タブナジア地下壕MAP1(K-9)のWalnut Doorの奥、Despachiaireの部屋に入ってイベントを見る | Home Point #3が近い。 | @タブナジア地下壕 K-10 #1 | T npc.26.Despachiaire
g02 go - | いちばん下の階の(H-9)から海獅子の巣窟に入る | Home Point #2が近い。 | @タブナジア地下壕 H-9 #3
g03 examine - | 海獅子の巣窟(H-6)のIron Gateを調べてイベントを見ると完了 | - | @海獅子の巣窟 H-6 | T obj.32.Iron_Gate = obj:Iron Gate@海獅子の巣窟 H-6

@ mission.promathia.026 https://wiki.ffo.jp/html/7559.html
Q The Enduring Tumult of War | 鍔音やむことなく | no | T npc.237.Cid
MN PM5-1 26
RW key_item:不思議なアミュレット
RW key_item:ヴァズの輝き
LK condition:前節「そしりを受けつつも」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Enduring_Tumult_of_War;Despachiaire・Chasalvige・Anoki（サンドリア港 H-6）は話さなくてもよい。ボスディン氷河 F-7 のヌエ塔、ソ・ジヤの Stone Door で Nunyunuwi（FFXIclopedia は Map 1 の H-8、用語辞典は MAP12 の H-8）
g00a talk - | （してもしなくてもよい）タブナジア地下壕MAP1(K-10)のDespachiaireに話してイベントを見る | ほかのクエストのイベントが先に出ることがあるので、出なくなるまで話す。見なくても、あとで記憶のウタイビト（MAP2 H-6のLatteaune）で見られる。 | @タブナジア地下壕 K-10 #1 | T npc.26.Despachiaire
g00b talk - | （してもしなくてもよい）北サンドリア(L-6)のChasalvigeに話してイベントを見る | 見なくても、あとで記憶のウタイビト（北サンドリア J-10のJufaue）で見られる。 | @北サンドリア L-6 | T npc.231.Chasalvige
g00c talk - | （してもしなくてもよい）サンドリア港(H-6)のAnokiに話してイベントを見る | 見なくても、あとで記憶のウタイビト（サンドリア港 H-9のDabbio）で見られる。 | @サンドリア港 H-6 | T npc.232.Anoki = npc:Anoki@サンドリア港 H-6
g01 go - | バストゥーク港に入ってイベントを見る | 急ぐなら、話さずにここから始めてよい。 | @バストゥーク港
g02 talk - | 大工房2階(H-8)のCidに話してイベントを見る | - | @大工房 H-8 | T npc.237.Cid
g03 go - | ボスディン氷河(F-7)からソ・ジヤに入ってイベントを見る | - | @ボスディン氷河 F-7
g04 defeat - | ソ・ジヤMAP12(H-8)のStone Doorを調べ、出てきたゴーレム族のNM、Nunyunuwiを倒す | オートリジェネが強い。穴は落ちない。 | @ソ・ジヤ H-8 #12 | T mob.9.Nunyunuwi = mob:Nunyunuwi@ソ・ジヤ H-8 #12
g05 examine - | もう一度Stone Doorを調べて通り、エレベーターで下りた先のStone Doorを調べてイベントを見ると完了 | プロミヴォン-ヴァズへ移る。エレベーターでは魔法を使わない。 | @ソ・ジヤ #12 | T obj.9.Stone_Door = obj:Stone Door@ソ・ジヤ H-8 #12

@ mission.promathia.062 https://wiki.ffo.jp/html/4140.html
Q Desires of Emptiness | 願わくば闇よ | no
MN PM5-2 27
RW title:ドザえもん
RW other:経験値1500
LK condition:前節「鍔音やむことなく」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Desires_of_Emptiness;3階 J-8・4階 M-6・5階 D-6 の Memory Flux で Propagator・Solicitor・Ponderer、F-8 からヴァズの塔（FFXIclopedia・用語辞典も同じ）。基礎シートには行がなく、ミッション一覧の最後に足した
g01 go - | プロミヴォン-ヴァズの各階層でMemory Receptacleを倒し、出たワープで先へ進む | 1階と2階はそのまま進む。 | @プロミヴォン-ヴァズ
g02 defeat - | 3階層(J-8)のMemory Fluxを調べ、出てきたNM、Propagatorを倒してもう一度調べる | Offspringを2体まで呼ぶ。倒したあと調べる前にトラクタを受けるとやり直し。 | @プロミヴォン-ヴァズ J-8 | T mob.プロミヴォン-ヴァズ.Propagator = mob:Propagator@プロミヴォン-ヴァズ J-8
g03 defeat - | 4階層(M-6)のMemory Fluxを調べ、出てきたNM、Solicitorを倒してもう一度調べる | - | @プロミヴォン-ヴァズ M-6 | T mob.プロミヴォン-ヴァズ.Solicitor = mob:Solicitor@プロミヴォン-ヴァズ M-6
g04 defeat - | 5階層(D-6)のMemory Fluxを調べ、出てきたNM、Pondererを倒してもう一度調べる | 3人を助けないとBFに入れない。 | @プロミヴォン-ヴァズ D-6 | T mob.プロミヴォン-ヴァズ.Ponderer = mob:Ponderer@プロミヴォン-ヴァズ D-6
g05 fight - | (F-8)からヴァズの塔に入り、BF「願わくば闇よ」でProcreator・Agonizer・Cumulatorに勝つ | 6人・30分。1体を8割ほど削ると次が来る。 | @プロミヴォン-ヴァズ F-8
g06 talk - | ボスディン氷河に戻されたら、大工房2階(H-8)のCidに話してイベントを見ると完了 | 選ぶものはどれでもよい。 | @大工房 H-8 | T npc.237.Cid

@ mission.promathia.027 https://wiki.ffo.jp/html/5429.html
Q Three Paths | みっつの道 | no | T npc.237.Cid
MN PM5-3 50
RW title:凍てつく過去を踏みしめる者
LK condition:前節「願わくば闇よ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Three_Paths;ルーヴランス・テンゼン・ウルミアの3つの道。どれから進めても、途中で切りかえてもよい
g01 talk - | 大工房2階(H-8)のCidに話してイベントを見る | 選ぶものはどれでもよい。あとで話すと残りの道のヒントが聞ける。 | @大工房 H-8 | T npc.237.Cid
g02 go - | ルーヴランスの道（汝の罪は）、テンゼンの道（楽園を求めるは）、ウルミアの道（群れ立つ使者は）を進める | 3つとも要る。 | 
g03 go - | 3つとも終えると完了 | オファーリストに「歌うは誰がため」が出れば済んでいる。

# みっつの道：ルーヴランスの道（5-3L）
@ mission.promathia.042 https://wiki.ffo.jp/html/7023.html
Q Past Sins | 汝の罪は | no | T npc.26.Despachiaire
MN PM5-3L1 28
LK condition:「みっつの道」でルーヴランスの道（アル・タユを探す）を選んでいる
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_5-3/Louverance%27s_Path;上の階の Despachiaire K-10。ほかのイベントが先に出ることがある
g01 talk - | タブナジア地下壕MAP1(K-10)のDespachiaireに話してイベントを見ると完了 | 何度か話すことがある。Home Point #3が近い。 | @タブナジア地下壕 K-10 #1 | T npc.26.Despachiaire

@ mission.promathia.031 https://wiki.ffo.jp/html/7024.html
Q Southern Legend | 南方の伝説 | no | T npc.241.Perih_Vashai
MN PM5-3L2 29
LK condition:前節「汝の罪は」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_5-3/Louverance%27s_Path;ウィンダス森の区 K-7 の Perih Vashai、Home Point #1
g01 talk - | ウィンダス森の区(K-7)のPerih Vashaiに話してイベントを見ると完了 | Home Point #1が近い。 | @ウィンダス森の区 K-7 | T npc.241.Perih_Vashai

@ mission.promathia.032 https://wiki.ffo.jp/html/7001.html
Q Partners Without Fame | 名捨て人ふたり | no | T obj.4.???_Warmachine = obj:??? Warmachine@ビビキー湾 H-11
MN PM5-3L3 30
LK condition:前節「南方の伝説」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_5-3/Louverance%27s_Path;プルゴノルゴ島 H-11 の ??? Warmachine（FFXIclopedia も H-11）。マナクリッパーはビビキー湾 H-7、Atmacite Refiner からも島へ行ける
g01 go - | ビビキー湾のマナクリッパーでプルゴノルゴ島へ渡る | 一度ビビキー湾に行っていれば、HQの水着やヴォイドウォッチのワープでも行ける。 | @ビビキー湾
g02 examine - | 島の南のはし(H-11)の??? Warmachineを調べてイベントを見ると完了 | 長いイベント。 | @ビビキー湾 H-11 | T obj.4.???_Warmachine

@ mission.promathia.029 https://wiki.ffo.jp/html/7014.html
Q A Century of Hardship | なにゆえにその子は | no | T npc.11.Tarnotik
MN PM5-3L4 31
RW other:経験値1000
LK condition:前節「名捨て人ふたり」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_5-3/Louverance%27s_Path;旧市街に入るとイベント。K-10 の Tarnotik に Snow Lily で 2716号採石場へ（FFXIclopedia も K-10）。新市街 Home Point #1 があればすぐ前。BF はモブリン4体と Bugbby
g00 talk - | （してもしなくてもよい）ウィンダス石の区(E-5)のYoran-Oranに話して、北グスタベルグの土の話を聞く | 話さなくても進む。 | @ウィンダス石の区 E-5 | T npc.239.Yoran-Oran
g01 go - | ムバルポロス旧市街に入ってイベントを見る | - | @ムバルポロス旧市街
g02 trade - | ムバルポロス旧市街(K-10)のTarnotikにスノーリリーを渡して2716号採石場へ送ってもらう | ムバルポロス新市街のHome Point #1があれば採石場のすぐ前に出る。着いたら一度新市街に出てHome Pointを開けておく。 | @ムバルポロス旧市街 K-10 | T npc.11.Tarnotik | N スノーリリー
g03 fight - | 2716号採石場のShaft EntranceからBF「なにゆえにその子は」に入り、モブリン4体とBugbbyを倒すと完了 | 6人・30分。ENMとまちがえない。黒魔道士から沈黙で止める。 | @2716号採石場 | T obj.Shaft_Entrance

@ mission.promathia.030 https://wiki.ffo.jp/html/6986.html
Q Departures | 永いお別れ | no | T npc.237.Cid
MN PM5-3L5 32
RW title:ルーヴランスの友人
LK condition:前節「なにゆえにその子は」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_5-3/Louverance%27s_Path;Gold Key は新市街の旧市街側のモブリンが落とす。Shaft Entrance に渡してイベント、そのあと Cid
g01 talk - | 大工房2階(H-8)のCidに話してイベントを見る | - | @大工房 H-8 | T npc.237.Cid
g01a talk - | （してもしなくてもよい）ムバルポロス旧市街(K-10)のTarnotikに話す | 黄金のカギが要る話が聞ける。 | @ムバルポロス旧市街 K-10 | T npc.11.Tarnotik
g02 gather - | ムバルポロス新市街で「黄金のカギ」を手に入れる | 旧市街に近いところのゴブリン族・モブリン族が落とす。何人かなら全員分。 | @ムバルポロス新市街
g03 trade - | 2716号採石場のShaft Entranceに黄金のカギを渡してイベントを見る | Home Pointが開いていれば、そこから行く。 | @2716号採石場 | T obj.Shaft_Entrance | N 黄金のカギ
g04 talk - | 大工房2階(H-8)のCidに話してイベントを見ると完了 | これでルーヴランスの道が終わる。 | @大工房 H-8 | T npc.237.Cid

# みっつの道：テンゼンの道（5-3T）
@ mission.promathia.035 https://wiki.ffo.jp/html/4144.html
Q The Pursuit of Paradise | 楽園を求めるは | no | T obj.102.???_G-6
MN PM5-3T1 33
LK condition:「みっつの道」でテンゼンの道（セルテウスを探す）を選んでいる
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_5-3/Tenzen%27s_Path;ラテーヌ高原 G-6 の ???（FFXIclopedia も G-6）。カーバンクルとテンゼンのイベントが正しいもの
g01 examine - | ラテーヌ高原(G-6)のストーンサークルの中の???を調べてイベントを見ると完了 | ほかのクエストのカーバンクルのイベントも出る。テンゼンが出るイベントまで見る。 | @ラテーヌ高原 G-6 | T obj.102.???_G-6

@ mission.promathia.036 https://wiki.ffo.jp/html/4146.html
Q Spiral | 螺旋 | no | T obj.9.Avatar_Gate
MN PM5-3T2 34
LK condition:前節「楽園を求めるは」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_5-3/Tenzen%27s_Path;ボスディン氷河 J-8 の塔（FFXIclopedia も J-8）、Stone Door 16枚、多くで Gargoyle が出る。エレベーターの下の Avatar Gate
g01 go - | ボスディン氷河(J-8)の塔からソ・ジヤに入る | ユニティワープ（CL125）が近い。 | @ボスディン氷河 J-8
g02 defeat - | 16か所のStone Doorを順に通る。調べて出てきたドール族のNM、Gargoyleを倒すと開く | 扉はすぐ閉まるので、開いたらすぐ通る。裏からは開かない。 | @ソ・ジヤ | T mob.9.Gargoyle = mob:Gargoyle@ソ・ジヤ
g03 examine - | 16枚目の先のエレベーターで下り、Avatar Gateを調べてイベントを見ると完了 | - | @ソ・ジヤ | T obj.9.Avatar_Gate

@ mission.promathia.037 https://wiki.ffo.jp/html/4630.html
Q Branded | 烙印ありて | no | T npc.244.Monberaux
MN PM5-3T3 35
LK condition:前節「螺旋」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_5-3/Tenzen%27s_Path;Monberaux G-10、Pherimociel G-6（FFXIclopedia も同じ）
g01 talk - | ジュノ上層(G-10)のMonberauxに話し、「モンブローの封筒」を受け取る | Home Point #3が近い。 | @ジュノ上層 G-10 | T npc.244.Monberaux
g02 talk - | ル・ルデの庭(G-6)のPherimocielに話してイベントを見る | Home Point #1が近い。 | @ル・ルデの庭 G-6 | T npc.243.Pherimociel
g03 talk - | ジュノ上層(G-10)のMonberauxに話すと完了 | - | @ジュノ上層 G-10 | T npc.244.Monberaux

@ mission.promathia.038 https://wiki.ffo.jp/html/4616.html
Q Pride and Honor | 礼賛者 | no | T obj.105.???_K-9 = obj:???@バタリア丘陵 K-9
MN PM5-3T4 36
LK condition:前節「烙印ありて」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_5-3/Tenzen%27s_Path;バタリア丘陵の ??? は K-8/9（FFXIclopedia は K-9）、ジュノ上層からの出口の壁の外。デルクフの塔下層1階 H-5 の Cermet Door で Disaster Idol（FFXIclopedia も H-5）
g01 examine - | バタリア丘陵(K-9)の???を調べてイベントを見る | ジュノ上層から出た門の外。 | @バタリア丘陵 K-9 | T obj.105.???_K-9
g02 examine - | もう一度???を調べて「デルクフ解除キー」を受け取る | 受け取らずにデルクフの塔へ行かない。 | @バタリア丘陵 K-9 | T obj.105.???_K-9
g03 defeat - | デルクフの塔下層MAP2(H-5)のCermet Doorを調べ、出てきたドール族のNM、Disaster Idolを倒す | 曜日の属性の魔法を使い、スタンが効かない。ほかの人が戦っているときは待つ。 | @デルクフの塔下層 H-5 #2 | T mob.184.Disaster_Idol = mob:Disaster Idol@デルクフの塔下層 H-5 #2 | K デルクフ解除キー
g04 examine - | もう一度Cermet Doorを調べてイベントを見ると完了 | - | @デルクフの塔下層 H-5 #2 | T obj.184.Cermet_Door_H-5 = obj:Cermet Door@デルクフの塔下層 H-5 #2

@ mission.promathia.039 https://wiki.ffo.jp/html/4147.html
Q And the Compass Guides | 羅針の示すもの | no | T obj.9.Avatar_Gate
MN PM5-3T5 37
RW title:テンゼンの盟友
LK condition:前節「礼賛者」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_5-3/Tenzen%27s_Path;ボスディン氷河 H-10 の塔（FFXIclopedia も H-10）。外まわりを回って I-8 で穴に落ち、南・西・北のあとエレベーターで Avatar Gate
g00 go - | ボスディン氷河(H-10)の塔へ行く | ヴォイドウォッチのAtmacite RefinerかウォンテッドエリアのCL125のワープが近い。 | @ボスディン氷河 H-10
g01 go - | 塔からソ・ジヤに入ってイベントを見る | Lv99でも敵に気づかれる。サイレントオイルとプリズムパウダーを持っていく。 | @ソ・ジヤ
g02 go - | 右の壁にそって外まわりをほぼ1周し、(I-8)の部屋で床の穴に落ちる | - | @ソ・ジヤ I-8
g03 examine - | 南・西・北と進んでリフトで下り、Avatar Gateを調べてイベントを見る | - | @ソ・ジヤ | T obj.9.Avatar_Gate
g04 talk - | 大工房2階(H-8)のCidに話してイベントを見ると完了 | これでテンゼンの道が終わる。 | @大工房 H-8 | T npc.237.Cid

# みっつの道：ウルミアの道（5-3U）
@ mission.promathia.040 https://wiki.ffo.jp/html/5509.html
Q Where Messengers Gather | 群れ立つ使者は | no | T npc.230.Hinaree
MN PM5-3U1 38
LK condition:「みっつの道」でウルミアの道（プリッシュを探す）を選んでいる
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_5-3/Ulmia%27s_Path;南サンドリアの Hinaree は A-6（FFXIclopedia は B-6）、Home Point #4
g01 talk - | 南サンドリア(A-6)の屋敷の2階のHinareeに話してイベントを見ると完了 | Home Point #4が近い。 | @南サンドリア A-6 B-6 | T npc.230.Hinaree

@ mission.promathia.041 https://wiki.ffo.jp/html/5501.html
Q Entanglement | 結び目 | no | T npc.231.Chasalvige
MN PM5-3U2 39
LK condition:前節「群れ立つ使者は」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_5-3/Ulmia%27s_Path;英語名は BG Wiki・FFXIclopedia の Entanglement（基礎シートは Enlanglement）。サンドリア港に入るとイベント、大聖堂の Chasalvige L-6（FFXIclopedia も L-6）
g01 go - | サンドリア港に入ってイベントを見る | Home Pointで入ってもよい。 | @サンドリア港
g02 talk - | 北サンドリア(L-6)の大聖堂の西の部屋のChasalvigeに話してイベントを見ると完了 | 入口から左の最初の扉。 | @北サンドリア L-6 | T npc.231.Chasalvige

@ mission.promathia.033 https://wiki.ffo.jp/html/1474.html
Q Head Wind | 向かい風 | no | T npc.238.Kerutoto
MN PM5-3U3 40
RW title:デルタを狩る者
RW other:経験値1000
LK condition:前節「結び目」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_5-3/Ulmia%27s_Path;鼻の院の北の Kerutoto J-8（FFXIclopedia も南のマップの J-8）、Yoran-Oran E-5、アットワ地溝 H-6 から千骸谷の Dark Miasma
g00 talk - | （してもしなくてもよい）ボスディン氷河(I-7)のタルタル3人組に話す | ルーヴランスが凍ったプリッシュを運んできて、ウィンダスへ送った話が聞ける。 | @ボスディン氷河 I-7
g01 talk - | ウィンダス水の区MAP2(J-8)の鼻の院の北の部屋のKerutotoに話してイベントを見る | 「うわぁ！なんかきみ、すっごいまぶしいんだけど」で始まるイベント。ほかのクエストのイベントが先に出るので2回以上話す。 | @ウィンダス水の区 J-8 #2 | T npc.238.Kerutoto
g02 talk - | ウィンダス石の区(E-5)のYoran-Oranに話してイベントを見る | - | @ウィンダス石の区 E-5 | T npc.239.Yoran-Oran
g03 fight - | アットワ地溝(H-6)から千骸谷に入り、Dark MiasmaからBF「向かい風」に入って、Shikaree X・Y・Zとペットを倒すと完了 | 6人・30分。ミスラはWSで連携をねらう。「Like the Wind」のBFとまちがえない。 | @千骸谷 | T obj.千骸谷.Dark_Miasma = obj:Dark Miasma@千骸谷

@ mission.promathia.034 https://wiki.ffo.jp/html/5489.html
Q Flames for the Dead | 迎え火 | no
MN PM5-3U4 41
RW title:真のルーヴランスの友人
RW title:ウルミアの理解者
LK condition:前節「向かい風」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_5-3/Ulmia%27s_Path;ウルガラン山脈 J-9 の穴に落ちて熊爪嶽（FFXIclopedia も J-9、いちばん北西の穴）。BF は Snoll Tzar、勝ったら Cid
g01 go - | ウルガラン山脈(J-9)の広場の穴に落ち、北へ進んで熊爪嶽に入る | 近くのHome Point #2も開けておく。道中の敵はLv75以上でも気づくのでマウントがよい。 | @ウルガラン山脈 J-9
g02 fight - | 熊爪嶽のBF「迎え火」に入って勝つ | シュメーヨの塩があるとよい。 | @熊爪嶽
g03 talk - | 大工房2階(H-8)のCidに話してイベントを見ると完了 | これでウルミアの道が終わる。 | @大工房 H-8 | T npc.237.Cid

@ mission.promathia.028 https://wiki.ffo.jp/html/39142.html
Q To Begin CoP... | 「プロマシアの呪縛」を始めるには…… | no | T obj.184.Tales_Beginning
MN - 999
LK condition:デルクフの塔下層に入って「後にする」を選んだ
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Rites_of_Life;後にしたときは「To Start CoP...」がミッションのリストに出る。デルクフの塔下層 H-10 の Tales' Beginning を調べると始まる
g01 examine - | デルクフの塔下層MAP2(H-10)のTales' Beginningを調べてオープニングのイベントを見ると完了 | 「後にする」を選んだときだけ。このあと「命の洗礼」になる。 | @デルクフの塔下層 H-10 #2 | T obj.184.Tales_Beginning

@ mission.promathia.043 https://wiki.ffo.jp/html/7615.html
Q For Whom the Verse is Sung | 歌うは誰がため | no | T npc.243.Pherimociel
MN PM6-1 51
LK condition:「みっつの道」の3つの道をすべてクリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/For_Whom_the_Verse_is_Sung;Pherimociel G-6、ジュノ上層 F-7 のマーブルブリッジの扉（FFXIclopedia も同じ）
g01 talk - | ル・ルデの庭(G-6)のPherimocielに話してイベントを見る | 何度か話すことがある。 | @ル・ルデの庭 G-6 | T npc.243.Pherimociel
g02 examine - | ジュノ上層(F-7)のマーブルブリッジの扉を調べてイベントを見る | Home Point #1が近い。 | @ジュノ上層 F-7 | T obj.244.Door_Marble_Bridge = obj:Door:"Marble Bridge"@ジュノ上層 F-7
g03 go - | ル・ルデの庭に入ってイベントを見ると完了 | - | @ル・ルデの庭

@ mission.promathia.044 https://wiki.ffo.jp/html/4604.html
Q A Place to Return | ゐぬる場所 | no
MN PM6-2 52
LK condition:前節「歌うは誰がため」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Place_to_Return;宮殿 H-7 でイベント、ミザレオ海岸 I-11 の Dilapidated Gate で Warder 3体（FFXIclopedia も I-11）
g01 go - | ル・ルデの庭(H-7)のオーロラ宮殿に入ってイベントを見る | - | @ル・ルデの庭 H-7
g02 defeat - | ミザレオ海岸(I-11)のDilapidated Gateを調べ、出てきたスフィアロイド族のNM3体を倒す | Warder Aglaia・Warder Euphrosyne・Warder Thalia。範囲のノックバックとショックスパイクに気をつける。睡眠が効く。 | @ミザレオ海岸 I-11 | T obj.25.Dilapidated_Gate_I-11
g03 examine - | もう一度Dilapidated Gateを調べてイベントを見ると完了 | - | @ミザレオ海岸 I-11 | T obj.25.Dilapidated_Gate_I-11

@ mission.promathia.045 https://wiki.ffo.jp/html/7077.html
Q More Questions than Answers | 望むはあらゆる答え | no | T npc.243.Pherimociel
MN PM6-3 53
LK condition:前節「ゐぬる場所」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Promathia_Mission_6-3;Pherimociel G-6、セルビナ H-9 の織工ギルドの Mathilde。謁見の間の扉のことは BG Wiki にはない
g01 talk - | ル・ルデの庭(G-6)のPherimocielに話してイベントを見る | Home Point #1が近い。 | @ル・ルデの庭 G-6 | T npc.243.Pherimociel
g02 examine - | ル・ルデの庭(H-6)の謁見の間の扉（Door:Audience Chamber）を調べてイベントを見る | - | @ル・ルデの庭 H-6 | T obj.243.Door_Audience_Chamber
g03 talk - | セルビナ(H-9)の織工ギルドのMathildeに話してイベントを見ると完了 | - | @セルビナ H-9 | T npc.248.Mathilde = npc:Mathilde@セルビナ H-9

@ mission.promathia.046 https://wiki.ffo.jp/html/7855.html
Q One to be Feared | 畏れよ、我を | no | T npc.237.Cid
MN PM6-4 54
LK condition:前節「望むはあらゆる答え」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/One_to_be_Feared;海獅子の巣窟から BF。3連戦で、あいだにロビーの Airship Door から入る。Iron Gate は FFXIclopedia で H-6
g01 talk - | 大工房2階(H-8)のCidに話してイベントを見る | - | @大工房 H-8 | T npc.237.Cid
g02 examine - | 海獅子の巣窟に入ってイベントを見て、奥のIron Gateを調べてイベントを見る | - | @海獅子の巣窟 H-6 | T obj.32.Iron_Gate
g03 fight - | もう一度Iron Gateを調べてBF「畏れよ、我を」に入り、3回の戦いに勝つ | 6人。戦いの前ごとにロビーのAirship Doorから入る。ロビーから巣窟に戻ると1戦目からやり直し。 | @海獅子の巣窟 H-6 | T obj.32.Iron_Gate
g04 go - | 勝ったあとルフェーゼ野へ飛ばされると完了 | -

@ mission.promathia.047 https://wiki.ffo.jp/html/7614.html
Q Chains and Bonds | 鎖と絆 | no
MN PM7-1 55
RW item:大公親衛隊制式指輪
LK condition:前節「畏れよ、我を」クリア
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/Chains_and_Bonds;海獅子の巣窟への入口は地下壕のいちばん下の階 H-9（用語辞典は H-10）、Sewer Entrance I-7、Walnut Door K-7。BG Wiki も Walnut Door K-7
g01 go - | ルフェーゼ野(K-8)に飛ばされてイベントを見て、大公親衛隊制式指輪を受け取る | 選ぶものはどれでもよい。持ち物がいっぱいなら空けて、近くの???を調べる。 | @ルフェーゼ野 K-8
g02 go - | タブナジア地下壕に入ってイベントを見る | 次の3か所はどの順でもよい。 | @タブナジア地下壕
g03 examine - | 上の階、MAP1(K-7)のWalnut Doorを調べてイベントを見る | - | @タブナジア地下壕 K-7 #1 | T obj.26.Walnut_Door_K-7
g04 go - | いちばん下の階の(H-9)から海獅子の巣窟に入ってイベントを見る | - | @タブナジア地下壕 H-9 H-10 #3
g05 examine - | いちばん下の階、MAP3(I-7)のSewer Entranceを調べてイベントを見ると完了 | 3か所を見終えると次の節へ。 | @タブナジア地下壕 I-7 #3 | T obj.26.Sewer_Entrance

@ mission.promathia.048 https://wiki.ffo.jp/html/5050.html
Q Flames in the Darkness | 闇に炎 | no | T obj.25.Dilapidated_Gate
MN PM7-2 56
RW title:エシャンタールの戦友
LK condition:前節「鎖と絆」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Flames_in_the_Darkness;ミザレオ海岸 F-7 の門、Sueleen H-6、宮殿 H-7、マーブルブリッジ F-7（FFXIclopedia も同じ）
g01 examine - | ミザレオ海岸(F-7)のDilapidated Gateを調べてイベントを見る | - | @ミザレオ海岸 F-7 | T obj.25.Dilapidated_Gate
g02 talk - | 海獅子の巣窟(H-6)のSueleenに話す | - | @海獅子の巣窟 H-6 | T npc.32.Sueleen
g03 go - | ル・ルデの庭(H-7)の宮殿に近づいてイベントを見る | Home Point #1が近い。 | @ル・ルデの庭 H-7
g04 examine - | ジュノ上層(F-7)のDoor:"Marble Bridge"を調べてイベントを見ると完了 | - | @ジュノ上層 F-7 | T obj.244.Door_Marble_Bridge

@ mission.promathia.049 https://wiki.ffo.jp/html/5296.html
Q Fire in the Eyes of Men | 眦決して | no | T obj.Shaft_Entrance
MN PM7-3 57
RW title:プリッシュの同志
LK condition:前節「闇に炎」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Fire_in_the_Eyes_of_Men;2716号採石場の Shaft Entrance、新市街 Home Point #1（FFXIclopedia は M-9）か Tarnotik（K-10）。そのあと Cid H-8
g01 examine - | 2716号採石場のShaft Entranceを調べてイベントを見る | ムバルポロス新市街のHome Point #1か、旧市街(K-10)のTarnotikにスノーリリーで。 | @2716号採石場 | T obj.Shaft_Entrance
g02 talk - | 大工房2階(H-8)のCidに話してイベントを見る | - | @大工房 H-8 | T npc.237.Cid
g03 talk - | ヴァナ時間の0時を過ぎてから、もう一度Cidに話してイベントを見ると完了 | - | @大工房 H-8 | T npc.237.Cid | W ヴァナ時間の0時を過ぎてから

@ mission.promathia.050 https://wiki.ffo.jp/html/7613.html
Q Calm Before the Storm | 決別の前 | no | T npc.237.Cid
MN PM7-4 58
RW key_item:光の箱
RW key_item:プリッシュたちの手紙
LK condition:前節「眦決して」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Calm_Before_the_Storm;ギルド桟橋 I-9 の ??? で Cryptonberry Executor、ビビキー湾 F-6 の洞窟の ??? で Dalham、ミザレオ海岸 E-7 の Storage Compartment で Boggelmann（FFXIclopedia も F-6・E-7）。Sueleen H-6
g01 defeat - | ギルド桟橋MAP1(I-9)の???を調べ、トンベリ族のNM、Cryptonberry Executorたちを倒し、もう一度???を調べる | あとからCryptonberry Assassinが3体出る。Executorを先に倒す。3か所はどの順でもよい。 | @ギルド桟橋 I-9 #1 | T mob.2.Cryptonberry_Executor = mob:Cryptonberry Executor@ギルド桟橋 I-9 #1
g02 defeat - | ビビキー湾MAP1(F-6)の洞窟の奥の???を調べ、頭足族のNM、Dalhamを倒し、もう一度???を調べる | HPが減ると攻撃の回数がふえる。 | @ビビキー湾 F-6 #1 | T mob.4.Dalham = mob:Dalham@ビビキー湾 F-6 #1
g03 defeat - | ミザレオ海岸(E-7)の小屋のStorage Compartmentを調べ、ブガード族のNM、Boggelmannを倒し、もう一度調べて「光の箱」を受け取る | 防御が高い。ユニティワープ（CL128）からすぐ。 | @ミザレオ海岸 E-7 | T mob.25.Boggelmann = mob:Boggelmann@ミザレオ海岸 E-7
g04 talk - | 大工房2階(H-8)のCidに話して「プリッシュたちの手紙」を受け取る | - | @大工房 H-8 | T npc.237.Cid
g05 talk - | 海獅子の巣窟(H-6)のSueleenに話してイベントを見ると完了 | タブナジア地下壕のHome Point #2が近い。 | @海獅子の巣窟 H-6 | T npc.32.Sueleen

@ mission.promathia.051 https://wiki.ffo.jp/html/6194.html
Q The Warrior's Path | 武士道とは | no | T npc.32.Sueleen
MN PM7-5 59
RW other:経験値1000
LK condition:前節「決別の前」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Warrior%27s_Path;海獅子の巣窟の Sueleen（H-6）と Iron Gate から BF
g01 talk - | 海獅子の巣窟(H-6)のSueleenに話してイベントを見る | - | @海獅子の巣窟 H-6 | T npc.32.Sueleen
g02 fight - | Iron GateからBF「武士道とは」に入って勝つと完了 | 勝ったあとアル・タユに入れるようになる。勝ったときに戦闘不能だと経験値はもらえない。 | @海獅子の巣窟 H-6 | T obj.32.Iron_Gate

@ mission.promathia.052 https://wiki.ffo.jp/html/6196.html
Q Garden of Antiquity | 古代の園 | no | T obj.アル・タユ.Crystalline_Field = obj:Crystalline Field@アル・タユ H-11
MN PM8-1 60
RW key_item:アル・タユの輝き（ガルカ以外）
RW key_item:タブナジアリング
LK condition:前節「武士道とは」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Garden_of_Antiquity;Crystalline Field H-11、Rubious Crystal は D-10・H-13・L-10 で Ru'aern 3体ずつ、Gate of the Gods と東の Particle Gate H-8（FFXIclopedia も H-11・H-8）
g01 examine - | アル・タユ(H-11)のCrystalline Fieldを調べてイベントを見る | - | @アル・タユ H-11 | T obj.アル・タユ.Crystalline_Field
g02 defeat - | (D-10)・(H-13)・(L-10)のRubious Crystalを調べてアーン族のNM、Ru'aern3体を倒し、もう一度調べる | 3か所ともする。関係のない人にも気づく。(L-10)はフワボ族にも気をつける。 | @アル・タユ D-10 H-13 L-10 | T mob.アル・タユ.Ruaern = mob:Ru'aern@アル・タユ D-10 H-13 L-10
g03 go - | もう一度Crystalline Fieldを調べてフ・ゾイの王宮に入る | - | @アル・タユ H-11 | T obj.アル・タユ.Crystalline_Field
g04 examine - | フ・ゾイの王宮MAP3(H-8)の正面のGate of the Godsを調べてイベントを見て、タブナジアリングを受け取る | Home Pointを開けておく。 | @フ・ゾイの王宮 H-8 #3 | T obj.34.Gate_of_the_Gods
g05 examine - | (H-8)の東のParticle Gateを調べてイベントを見ると完了 | - | @フ・ゾイの王宮 H-8 #3 | T obj.34.Particle_Gate_East = obj:Particle Gate@フ・ゾイの王宮 H-8 #3

@ mission.promathia.053 https://wiki.ffo.jp/html/7612.html
Q A Fate Decided | 選ばれし死 | no | T obj.34.Particle_Gate_East
MN PM8-2 61
LK condition:前節「古代の園」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Fate_Decided;護衛は MAP1 J-8（5分）、MAP2 L-8（用語辞典は M-8、30分）、MAP2 I-10（30分）、MAP1 G-10（40分）。ワープは MAP1 L-7、MAP2 G-12、MAP1 G-4（用語辞典は G-5）。MAP2 H-8 の Cermet Portal で Ix'ghrah
g01 examine - | フ・ゾイの王宮MAP3(H-8)の東のParticle Gateを調べてイベントを見て、もう一度調べてMAP1へ | - | @フ・ゾイの王宮 H-8 #3 | T obj.34.Particle_Gate_East
g02 go - | 各所のCermet Alcoveを調べてQuasiluminを出し、守りながら扉を開けてもらう | MAP1(J-8)は5分、MAP2(L-8/M-8)と(I-10)は30分、MAP1(G-10)は40分。話しかけると止まる。 | @フ・ゾイの王宮
g03 defeat - | MAP2(H-7)のCermet Portalから南へ進み、(H-8)のCermet Portalを調べてゴラホ族のNM、Ix'ghrahを倒す | 形をかえ、曜日のガ系の魔法を使う。スタンが効く。 | @フ・ゾイの王宮 H-8 #2 | T mob.34.Ixghrah = mob:Ix'ghrah@フ・ゾイの王宮 H-8 #2
g04 examine - | もう一度Cermet Portalを調べてイベントを見ると完了 | 戻るときはデジョンなどで。 | @フ・ゾイの王宮 H-8 #2 | T obj.34.Cermet_Portal_H-8 = obj:Cermet Portal@フ・ゾイの王宮 H-8 #2

@ mission.promathia.054 https://wiki.ffo.jp/html/7611.html
Q When Angels Fall | 天使たちの抗い | no | T obj.34.Gate_of_the_Gods
MN PM8-3 62
RW key_item:暁の印
RW key_item:黄昏の印
LK condition:前節「選ばれし死」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/When_Angels_Fall;Gate of the Gods でイベント、ル・メトの園の5つの塔の Ebon Panel（種族の塔なら2回調べて輝き）、中央のエレベーター、2階で暁の印（北）と黄昏の印（南）、3階の Particle Gate から BF
g01 examine - | フ・ゾイの王宮MAP3(H-8)の正面のGate of the Godsを調べ、はいを選んでイベントを見る | - | @フ・ゾイの王宮 H-8 #3 | T obj.34.Gate_of_the_Gods
g02 examine - | ル・メトの園の5つの塔のどれかの上に登り、Ebon Panelを調べてイベントを見る | 自分の種族の塔ならもう一度調べて輝きを取りもどせる。あとでもよい。 | @ル・メトの園
g03 go - | MAP1の(H-8)のQn'zdeiのいる小部屋を抜けて(H-9)の中央エレベーターの部屋へ行き、エレベーターで2階へ | Home Pointがある。Qn'zdeiが4体台にいないと扉が開かない。 | @ル・メトの園 H-9 #1
g04 examine - | 2階の(I-9)のワープから(H-7)のParticle Gateへ行き、調べて「暁の印」を受け取る | 2つの印はどの順でもよい。 | @ル・メトの園 H-7 #2
g05 examine - | アーンの部屋(I-8)の東のワープから北西へ飛んで南へ進み、(H-10)のParticle Gateを調べて「黄昏の印」を受け取る | 西のワープでは南へ抜けられない。 | @ル・メトの園 H-10 #2
g06 fight - | 中央のエレベーターで3階へ行き、Particle Gateを調べてイベントを見て、もう一度調べてBFに入って勝つ | - | @ル・メトの園 | K 暁の印,黄昏の印
g07 go - | Luminous Convergenceを調べてイベントを見て、アル・タユに入ってイベントを見ると完了 | - | @アル・タユ

@ mission.promathia.055 https://wiki.ffo.jp/html/3499.html
Q Dawn | 暁 | no
MN PM8-4 63
RW key_item:アルタナの涙
RW other:経験値2000
LK condition:前節「天使たちの抗い」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Dawn;ル・メトの園 Home Point #1 から中央のエレベーター（FFXIclopedia は MAP1 H-8）で下りて天象の鎖へ
g01 go - | ル・メトの園の入口からまっすぐ北の扉を通り、エレベーターで下りる | Home Point #1が近い。 | @ル・メトの園 H-8 #1
g02 fight - | 天象の鎖のBF「暁」に入って勝つ | - | @天象の鎖
g03 go - | 勝ったあとのイベントで「アルタナの涙」を受け取ると完了 | このあとの5つの話はどの順でもよい。リアルの0時を過ぎてから。

@ mission.promathia.056 https://wiki.ffo.jp/html/8205.html
Q Return to the East | さらばでござる | no | T npc.237.Cid
MN PM8-4E1 64
LK condition:「暁」のBFに勝ったあと、リアルの0時を過ぎている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Dawn;Cid H-8（FFXIclopedia も H-8）
g01 talk - | 大工房2階(H-8)のCidに話してテンゼンのイベントを見ると完了 | リアルの0時を過ぎてから。 | @大工房 H-8 | T npc.237.Cid | W リアルの0時を過ぎてから

@ mission.promathia.057 https://wiki.ffo.jp/html/8206.html
Q A Meteoric Reunion | 究極魔法の起源 | no | T npc.240.Chipmy-Popmy
MN PM8-4E2 65
RW item:イエロードロップ・クリアドロップ・グリーンドロップ・パープルドロップ・ブラックドロップ・ブルードロップ・ホワイトドロップ・レッドドロップのどれか
LK condition:「暁」のBFに勝ったあと、リアルの0時を過ぎている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Dawn;ウィンダス港 C-8 の Fishing Guild の Chipmy-Popmy、プルゴノルゴ島 H-11 の ??? Warmachine（FFXIclopedia も C-8・H-11）
g01 talk - | ウィンダス港(C-8)の漁師ギルドのカウンターの前のChipmy-Popmyに話してイベントを見る | リアルの0時を過ぎてから。ビビキー湾の話が出るまで話す。 | @ウィンダス港 C-8 | T npc.240.Chipmy-Popmy | W リアルの0時を過ぎてから
g02 examine - | プルゴノルゴ島(H-11)の??? Warmachineを調べ、イベントを見てドロップを受け取ると完了 | ビビキー湾のマナクリッパーで渡る。 | @ビビキー湾 H-11 | T obj.4.???_Warmachine

@ mission.promathia.058 https://wiki.ffo.jp/html/5118.html
Q A Name for the Ages | 悠久の名を求め | no | T npc.230.Hinaree
MN PM8-4E3 66
LK condition:「暁」のBFに勝ったあと、リアルの0時を過ぎている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Dawn;Hinaree B-6、ウルガラン山脈に入ったあと屋敷 B-6 の前（FFXIclopedia も B-6）
g01 talk - | 南サンドリア(B-6)のカッファル伯爵邸のHinareeに話してイベントを見る | リアルの0時を過ぎてから。Home Point #4が近い。 | @南サンドリア B-6 | T npc.230.Hinaree | W リアルの0時を過ぎてから
g02 go - | ウルガラン山脈に入ってイベントを見る | - | @ウルガラン山脈
g03 go - | 南サンドリア(B-6)の屋敷の前に戻ってイベントを見ると完了 | - | @南サンドリア B-6

@ mission.promathia.059 https://wiki.ffo.jp/html/5517.html
Q In the Name of Justice | メーガスの名は永遠に | no
MN PM8-4E4 67
LK condition:「暁」のBFに勝ったあと、リアルの0時を過ぎている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Dawn;マウラに入るとスカリーのイベント
g01 go - | マウラに入ってスカリーX・Y・Zのイベントを見ると完了 | リアルの0時を過ぎてから。 | @マウラ | W リアルの0時を過ぎてから

@ mission.promathia.060 https://wiki.ffo.jp/html/5391.html
Q Newfound Family | 澪標 | no
MN PM8-4E5 68
LK condition:「暁」のBFに勝ったあと、リアルの0時を過ぎている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Dawn;ムバルポロス旧市街に入るとジャボスのイベント
g01 go - | ムバルポロス旧市街に入ってジャボスのイベントを見ると完了 | リアルの0時を過ぎてから。 | @ムバルポロス旧市街 | W リアルの0時を過ぎてから

@ mission.promathia.061 https://wiki.ffo.jp/html/8199.html
Q The Chains Fall Free | 呪縛ほどけるとき | no
MN PM8-4E6 69
RW item:ラジャスリング・タマスリング・サットヴァリングから1つ
RW title:虚ろなる闇に涙する者
RW other:フェイス「Prishe」（あとでプリッシュの部屋で）
LK condition:後日談「さらばでござる」「究極魔法の起源」「悠久の名を求め」「メーガスの名は永遠に」「澪標」のイベントをすべて見ている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Dawn;宮殿 H-7、マーブルブリッジ F-7、Walnut Door K-7、ルフェーゼ野 J-6 の蒼剣の丘（FFXIclopedia も同じ）
g01 go - | ル・ルデの庭(H-7)の宮殿に入ってイベントを見る | - | @ル・ルデの庭 H-7
g02 examine - | ジュノ上層(F-7)のDoor:"Marble Bridge"を調べてイベントを見る | - | @ジュノ上層 F-7 | T obj.244.Door_Marble_Bridge
g03 examine - | もう一度Door:"Marble Bridge"を調べ、指輪3つのうち1つを選んで受け取る | - | @ジュノ上層 F-7 | T obj.244.Door_Marble_Bridge
g04 examine - | タブナジア地下壕MAP1(K-7)のプリッシュの部屋のWalnut Doorを調べてイベントを見る | - | @タブナジア地下壕 K-7 #1 | T obj.26.Walnut_Door_K-7
g05 go - | ルフェーゼ野(J-6)の蒼剣の丘へ行き、イベントを見ると完了 | まわりの敵が強い。朝から昼に行き、天気にも気をつける。 | @ルフェーゼ野 J-6
