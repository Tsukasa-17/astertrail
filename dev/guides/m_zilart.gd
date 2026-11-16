# ジラートミッション（0.1.118〜）。基礎シートのミッション一覧 62〜79 行。並びはシートの行の順
@ mission.zilart.001 https://wiki.ffo.jp/html/7538.html
Q The New Frontier | 新たなる世界 | no | T obj.252.Tales_Beginning = obj:Tales' Beginning@ノーグ H-9
MN ZM1 1
RK 6
RW key_item:ノーグ地図（持っていなければ）
LK condition:闇王を倒したあと（所属国ランク6）
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_New_Frontier;ランク6でノーグに入ると始まる。後にしたときはノーグ Home Point #1 近くの Tales' Beginning から。FFXIclopedia は H-9
g01 go - | 闇王を倒したあと、ノーグに入ってイベントを始める | 所属国ランク6が要る。始めるかどうかを選べる。 | @ノーグ
g02 examine - | 始めなかったときは、ノーグ(H-9)のTales' Beginningを調べてイベントを見る | ノーグのHome Point #1のそば。 | @ノーグ H-9 | T obj.252.Tales_Beginning
g03 go - | イベントでライオンと再会すると完了 | 「ノーグ地図」を持っていなければもらえる。

@ mission.zilart.002 https://wiki.ffo.jp/html/7547.html
Q Welcome t'Norg | 海賊の巣窟ノーグ | no | T obj.252.Oaken_Door = obj:Oaken Door@ノーグ K-8
MN ZM2 2
XS BG Wiki;https://www.bg-wiki.com/ffxi/Welcome_t%27Norg;Oaken Door は L-8 と書かれている（FFXIclopedia と用語辞典、BG の「ロ・メーヴ」の節は K-8）
g00 go - | ノーグの2階の廊下の奥へ行く | ライオンが会わせたい人は、奥の扉の先にいる。 | @ノーグ K-8
g01 examine - | ノーグの2階の廊下の奥、(K-8)のOaken Doorを調べ、扉を開けてイベントを見ると完了 | 扉を調べるほかのミッションのイベントが先に出たら、もう一度調べる。 | @ノーグ K-8 | T obj.252.Oaken_Door

@ mission.zilart.003 https://wiki.ffo.jp/html/35412.html
Q The Temple of Uggalepih | ウガレピ寺院（ミッション） | no | T obj.生贄の間.Mahogany_Door = obj:Mahogany Door@生贄の間
MN ZM4 4
RW key_item:闇の祈り
RW title:賢者の希望を担いし者
LK condition:前節「カザム族長」で「生贄の間へのカギ」を受け取っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Temple_of_Uggalepih;怨念洞 Home Point #1 から生贄の間へすぐ。ユニティワープ（CL128）で怨念洞へ。寺院から行くには Paintbrush of Souls、怨念洞の扉に Unlit Lantern
g01 go - | ウガレピ寺院を抜けて怨念洞に入り、奥の生贄の間へ進む | 怨念洞のHome Point #1があれば生贄の間のすぐ前に出る。寺院から行くには「魂の絵筆」、怨念洞の扉には「消えたランタン」が要る。 | @怨念洞
g02 fight - | 生贄の間のMahogany DoorからBF「ウガレピ寺院」に入り、トンベリ族のNM3体を倒す | Tungs'itonのアストラルフロウに注意。Grav'itonには睡眠が効かない。挑む前に怨みを解いておくとよい。 | @生贄の間 | T obj.生贄の間.Mahogany_Door | K 生贄の間へのカギ
g03 go - | 勝ったあとのイベントで「闇の祈り」をもらうと完了 | -

@ mission.zilart.004 https://wiki.ffo.jp/html/2732.html
Q Headstone Pilgrimage | 古代石碑巡礼 | no
MN ZM5 5
RW key_item:炎の祈り
RW key_item:土の祈り
RW key_item:水の祈り
RW key_item:風の祈り
RW key_item:氷の祈り
RW key_item:雷の祈り
RW key_item:光の祈り
RW title:八つの祈りを帯びし者
XS BG Wiki;https://www.bg-wiki.com/ffxi/Headstone_Pilgrimage;土 西アルテパ H-8/H-9（FFXIclopedia と用語辞典は H-9）、水 ラテーヌ G-11、氷 凍結の回廊の奥、炎 ユタンガ L-6/L-7（Carthi・Tipha）、雷 ベヒーモスの縄張り G-9（Legendary Weapon・Ancient Weapon）、風 テリガン H-5（Axesarion the Wanderer、用語辞典は G-5）、光 聖地ジ・タ I-7（Doomed Pilgrims）
g01 examine - | 西アルテパ砂漠(H-9)の石碑（Cermet Headstone）を調べて「土の祈り」を手に入れる | 戦闘なし。(J-9)から流砂洞に入り、北東の落とし穴を落ちて地下の道を進む。 | @西アルテパ砂漠 H-9 | T obj.125.Cermet_Headstone = obj:Cermet Headstone@西アルテパ砂漠 H-9
g02 examine - | ラテーヌ高原(G-11)の谷の奥の石碑を調べて「水の祈り」を手に入れる | 戦闘なし。オルデール鍾乳洞を抜けた先の谷。 | @ラテーヌ高原 G-11 | T obj.102.Cermet_Headstone = obj:Cermet Headstone@ラテーヌ高原 G-11
g03 examine - | フェ・インの地下、凍結の回廊の奥の石碑を調べて「氷の祈り」を手に入れる | 戦闘なし。フェ・イン(G-9)の階段を降り、(I-5)から凍結の回廊へ。手前の敵にはスニークが要る。 | @凍結の回廊 | T obj.凍結の回廊.Cermet_Headstone = obj:Cermet Headstone@凍結の回廊
g04 fight - | ユタンガ大森林(L-7)の石碑を調べ、出てきたオポオポ族のNM2体を倒す | イフリートの釜を抜けた先、滝の裏のトンネル。 | @ユタンガ大森林 L-6 L-7 | T obj.123.Cermet_Headstone
g05 examine - | もう一度石碑を調べて「炎の祈り」を手に入れる | 倒したあと15分のうちに調べる。 | @ユタンガ大森林 L-6 L-7 | T obj.123.Cermet_Headstone
g06 fight - | ベヒーモスの縄張り(G-9)の石碑を調べ、出てきたAncient WeaponとLegendary Weaponを倒す | - | @ベヒーモスの縄張り G-9 | T obj.127.Cermet_Headstone = obj:Cermet Headstone@ベヒーモスの縄張り G-9
g07 examine - | もう一度石碑を調べて「雷の祈り」を手に入れる | 倒したあと15分のうちに調べる。 | @ベヒーモスの縄張り G-9 | T obj.127.Cermet_Headstone
g08 fight - | テリガン岬(H-5)の石碑を調べ、出てきたシャドウ族のNM Axesarion the Wandererを倒す | (F-7)の地図にないトンネルから北へ、(G-5)のトンネルの先。 | @テリガン岬 H-5 | T obj.113.Cermet_Headstone
g09 examine - | もう一度石碑を調べて「風の祈り」を手に入れる | 倒したあと15分のうちに調べる。 | @テリガン岬 H-5 | T obj.113.Cermet_Headstone
g10 fight - | 聖地ジ・タ(I-7)の石碑を調べ、出てきたドゥーム族のNM Doomed Pilgrimsを倒す | (J-9)の地図にない通路から北へ。 | @聖地ジ・タ I-7 | T obj.121.Cermet_Headstone
g11 examine - | もう一度石碑を調べて「光の祈り」を手に入れると完了 | 闇の祈りと合わせて8つそろうと次の節へ。 | @聖地ジ・タ I-7 | T obj.121.Cermet_Headstone

@ mission.zilart.005 https://wiki.ffo.jp/html/4373.html
Q Through the Quicksand Caves | 流砂洞を越えて | no
MN ZM6 6
XS BG Wiki;https://www.bg-wiki.com/ffxi/Through_the_Quicksand_Caves;西アルテパ C/D-11 のトンネルから D-12 の入口、流砂洞 I-9 と H-7 の重量扉（ガルカ1人・タルタル3人・ほか2人、または Loadstone）、穴を落ちて D-4 から宣託の間。アンティカ族NM3体。FFXIclopedia は重量扉を MAP4
g01 go - | 西アルテパ砂漠(D-11)の地図にないトンネルを抜け、(D-12)の入口から流砂洞に入る | 流砂洞のHome Point #1があれば宣託の間のすぐ前に出る。 | @西アルテパ砂漠 D-12
g02 go - | 流砂洞(I-9)と(H-7)の重量扉を越え、穴を落ちて(D-4)から宣託の間に入る | 重量扉はガルカ1人、タルタル3人、ほかは2人で開く。ひとりなら「重量石」が要る。中はスニークが要る。 | @流砂洞 D-4 #4
g03 fight - | BFに入り、アンティカ族のNM3体を倒すと完了 | 沈黙を使う。魔法を使う人はやまびこ薬を持っていく。 | @宣託の間

@ mission.zilart.006 https://wiki.ffo.jp/html/35783.html
Q The Chamber of Oracles | 宣託の間（ミッション） | no
MN ZM7 7
RW key_item:虹の祈り
RW title:光の紡ぎ手
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Chamber_of_Oracles;装置の8か所を調べて祈りをはめるとイベント
g01 examine - | BFに勝って移された宣託の間で、奥の台座の8か所を調べて祈りをはめ込む | イベントの前にエリアを出るとBFからやり直し。イベントが始まらなければ台座をもう一度調べる。 | @宣託の間
g02 go - | イベントのあと「虹の祈り」をもらうと完了 | 後ろのCermet Doorから出られる。

@ mission.zilart.007 https://wiki.ffo.jp/html/4350.html
Q Return to Delkfutt's Tower | デルクフの塔再び | no | T npc.245.Aldo
MN ZM8 8
RW title:いにしえを屠る者
XS BG Wiki;https://www.bg-wiki.com/ffxi/Return_to_Delkfutt%27s_Tower;Aldo は任意。デルクフの塔上層 Home Point #1 から天輪の場へ。Qe'lov Gate から BF、Kam'lanaut
g01 talk - | ジュノ下層(J-8)の天晶堂のAldoに話してイベント | 話さなくても進められる。 | @ジュノ下層 J-8 | T npc.245.Aldo
g02 go - | デルクフの塔下層に入ってイベント | - | @デルクフの塔下層
g03 go - | 塔の12階の転送装置から天輪の場に入ってイベント | デルクフの塔上層のHome Point #1から近い。塔を登るなら「デルクフのカギ」があると早い。 | @天輪の場
g04 fight - | 奥のQe'lov GateからBFに入り、Kam'lanautを倒すと完了 | エレメンタルブレードで変わる属性の魔法は吸収される。睡眠・沈黙は効かない。 | @天輪の場 | T mob.天輪の場.Kamlanaut = mob:Kam'lanaut@天輪の場

@ mission.zilart.008 https://wiki.ffo.jp/html/35784.html
Q Ro'Maeve | ロ・メーヴ（ミッション） | no | T npc.245.Aldo
MN ZM9 9
XS BG Wiki;https://www.bg-wiki.com/ffxi/Ro%27Maeve_(Mission);Aldo は任意。ノーグ K-8 の Oaken Door で「扉を開ける」を選ぶ
g01 talk - | ジュノ下層(J-8)の天晶堂のAldoに話してイベント | 話さなくても進められる。 | @ジュノ下層 J-8 | T npc.245.Aldo
g02 examine - | ノーグ(K-8)のOaken Doorを調べ、扉を開けてギルガメッシュの部屋のイベントを見ると完了 | ほかのミッションのイベントが先に出たら、もう一度調べる。 | @ノーグ K-8 | T obj.252.Oaken_Door

@ mission.zilart.009 https://wiki.ffo.jp/html/7549.html
Q The Temple of Desolation | 聖地ジ・タ～滅びの神殿 | no
MN ZM10 10
RW title:神の扉を閉ざす者
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Temple_of_Desolation;称号 Sealer of the Portal of the Gods はこの節（用語辞典はひとつ前の「ロ・メーヴ」の行）。ロ・メーヴ H-5 から神々の間、Cermet Grate を調べる
g01 go - | ロ・メーヴ(H-5)から神々の間に入る | ロ・メーヴの敵は魔法に反応する。スニークとインビジは入口でかけるか、薬を使う。マウントにも乗れる。 | @ロ・メーヴ H-5
g02 examine - | 神々の間の奥の格子戸（Cermet Grate）を調べると完了 | イベントはなく、メッセージだけ。ミッションの一覧で次の節になっていれば終わり。 | @神々の間 | T obj.251.Cermet_Grate = obj:Cermet Grate@神々の間

@ mission.zilart.010 https://wiki.ffo.jp/html/35785.html
Q The Hall of the Gods | 神々の間（ミッション） | no | T obj.252.Oaken_Door
MN ZM11 11
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Hall_of_the_Gods;ノーグに戻り、扉を開けてギルガメッシュに話す
g00 go - | ノーグに戻る | - | @ノーグ
g01 examine - | ノーグ(K-8)のOaken Doorを調べ、ギルガメッシュの部屋に入ってイベントを見ると完了 | - | @ノーグ K-8 | T obj.252.Oaken_Door

@ mission.zilart.011 https://wiki.ffo.jp/html/915.html
Q The Mithra and the Crystal | ミスラとクリスタル | no | T npc.247.Maryoh_Comyujah = npc:Maryoh Comyujah@ラバオ G-7
MN ZM12 12
RW key_item:青水晶
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Mithra_and_the_Crystal;Maryoh Comyujah ラバオ G-7。西アルテパ C/D-11 の隠し入口、流砂洞の重量扉2つの先で穴を落ち、??? から Ancient Vessel、Scrap of papyrus。BG は MAP5・6、FFXIclopedia と用語辞典は MAP4 K-8・MAP7 G-8／I-8
g01 talk - | ラバオ(G-7)の風車の前のMaryoh Comyujahに話し、取引の話を受ける | 上の選択肢を選ぶ。 | @ラバオ G-7 | T npc.247.Maryoh_Comyujah
g02 go - | 西アルテパ砂漠(D-11)の地図にないトンネルを抜け、(D-12)の入口から流砂洞に入る | 「流砂洞を越えて」と同じ入口。 | @西アルテパ砂漠 D-12
g03 go - | 流砂洞(K-8)の重量扉を越えて東へ、もう一つの重量扉(G-8)を越える | 重量扉はガルカ1人、タルタル3人、ほかは2人で開く。ひとりなら「重量石」が要る。 | @流砂洞 K-8 #4
g04 fight - | (I-8)の穴を落ちたところの???を調べ、出てきたマジックポット族のNM Ancient Vesselを倒す | ???のすぐ近くで調べる。 | @流砂洞 I-8 #7 | T mob.208.Ancient_Vessel = mob:Ancient Vessel@流砂洞 I-8 #7
g05 examine - | もう一度???を調べて「パピルスの切れ端」を手に入れる | - | @流砂洞 I-8 #7
g06 talk - | ラバオ(G-7)のMaryoh Comyujahに戻って「青水晶」をもらう | - | @ラバオ G-7 | T npc.247.Maryoh_Comyujah | K パピルスの切れ端
g07 talk - | ジュノ下層(J-8)の天晶堂のAldoに話してイベント | 話さなくても進められる。ラバオへ行く前でもよい。 | @ジュノ下層 J-8 | T npc.245.Aldo
g08 examine - | 神々の間の格子戸（Cermet Grate）を調べてイベントを見て、もう一度調べて奥へ進む | - | @神々の間 | T obj.251.Cermet_Grate | K 青水晶
g09 examine - | 廊下の先の転送装置（Shimmering Circle）を調べてイベントを見ると完了 | 以後はここからトゥー・リアへ行ける。 | @神々の間 | T obj.251.Shimmering_Circle = obj:Shimmering Circle@神々の間

@ mission.zilart.012 https://wiki.ffo.jp/html/3733.html
Q The Gate of the Gods | 神の扉トゥー・リア | no
MN ZM13 13
RW other:トゥー・リアへ行けるようになる
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Gate_of_the_Gods;転送のあと進んでル・オンの庭に入ると次の節。Prishe's Boots +1 のクエスト中は別のイベントが先に出るので入り直す
g00 go - | 神々の間のShimmering Circleから北へ進む | - | @神々の間
g01 go - | その先のル・オンの庭に入ってイベントを見ると完了 | 別のイベントが出たらエリアを出て入り直す。入ってすぐのSurvival Guideも開けておく。 | @ル・オンの庭

@ mission.zilart.013 https://wiki.ffo.jp/html/3734.html
Q Ark Angels | アーク・ガーディアン | yes
MN ZM14 14
RW key_item:無知のかけら
RW key_item:怯懦のかけら
RW key_item:嫉妬のかけら
RW key_item:驕慢のかけら
RW key_item:憎悪のかけら
XS BG Wiki;https://www.bg-wiki.com/ffxi/Ark_Angels;ル・オンの庭 H-8 からル・アビタウ神殿へ入り G/H-11 の印でイベント。BF はラ・ロフの劇場、入口はル・オンの庭 Home Point #1〜#5 のそば（HM #1、TT #2、MR #3、EV #4、GK #5）。島の座標は用語辞典だけ
g01 examine - | ル・オンの庭(H-8)からル・アビタウ神殿に入り、北の壁の印を調べてイベント | 中はスニークが要る。クエスト「神威」で5体を一度に相手にする道もある。 | @ル・アビタウ神殿
g02 fight - | ル・オンの庭の北(H-4)の島からラ・ロフの劇場に入り、Ark Angel HMを倒して「無知のかけら」を手に入れる | 入口はル・オンの庭のHome Point #1のそば。6人・30分、入ると強化とペットが消える。 | @ル・オンの庭 H-4 | T mob.130.Ark_Angel_HM
g03 fight - | 南西(F-11)の島から入り、Ark Angel TTを倒して「怯懦のかけら」を手に入れる | 入口はHome Point #2のそば。 | @ル・オンの庭 F-11 | T mob.130.Ark_Angel_TT
g04 fight - | 北西(E-7)の島から入り、Ark Angel MRを倒して「嫉妬のかけら」を手に入れる | 入口はHome Point #3のそば。ペットを連れている。 | @ル・オンの庭 E-7 | T mob.130.Ark_Angel_MR
g05 fight - | 北東(K-7)の島から入り、Ark Angel EVを倒して「驕慢のかけら」を手に入れる | 入口はHome Point #4のそば。 | @ル・オンの庭 K-7 | T mob.130.Ark_Angel_EV
g06 fight - | 南東(J-11)の島から入り、Ark Angel GKを倒して「憎悪のかけら」を手に入れると完了 | 入口はHome Point #5のそば。ワイバーンを連れている。5つそろうと次の節へ。 | @ル・オンの庭 J-11 | T mob.130.Ark_Angel_GK

@ mission.zilart.014 https://wiki.ffo.jp/html/7550.html
Q The Sealed Shrine | 閉ざされし門 | no | T obj.252.Oaken_Door
MN ZM15 15
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Sealed_Shrine;ノーグ K-8 の Oaken Door でギルガメッシュ、ル・アビタウ神殿に入るとイベント（ホームポイントで飛んでも可）。FFXIclopedia は Aldo（任意）も
g01 examine - | ノーグ(K-8)のOaken Doorを調べ、ギルガメッシュの部屋に入ってイベント | - | @ノーグ K-8 | T obj.252.Oaken_Door
g02 go - | ル・オンの庭からル・アビタウ神殿に入ってイベントを見ると完了 | 入口はどこでもよい。(I-6)から入ると次の節に近い。 | @ル・アビタウ神殿

@ mission.zilart.015 https://wiki.ffo.jp/html/35786.html
Q The Celestial Nexus | 宿星の座（ミッション） | no
MN ZM16 16
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Celestial_Nexus;ル・オンの庭 H-8 から入り H-10 の東のモノリスで黄色い扉を開け、I-6 から入って南へ、H-9 の階段を降りて宿星の座。Eald'narche（2形態）。称号 Burier of the Illusion（用語辞典は記載なし）
g01 examine - | ル・オンの庭(H-8)からル・アビタウ神殿に入り、(H-10)の部屋の東のモノリスが黄色い扉を開ける色になっているか確かめる | 神殿の敵はほとんど魔法に反応する。スニークとインビジは薬で。 | @ル・アビタウ神殿 H-10
g02 go - | ル・オンの庭(I-6)から神殿に入り、黄色い扉を抜けて南へ進み、(H-9)の階段を降りて宿星の座へ | 宿星の座の前にHome Point #1がある。 | @ル・アビタウ神殿 H-9
g03 fight - | BFに入り、Eald'narcheを倒すと完了 | 形が2つある。勝ったあとのイベントで神々の間に移される。 | @宿星の座 | T mob.宿星の座.Ealdnarche = mob:Eald'narche@宿星の座

@ mission.zilart.016 https://wiki.ffo.jp/html/7551.html
Q Awakening | 1万年の夢の終わりに | no
MN ZM17 17
XS BG Wiki;https://www.bg-wiki.com/ffxi/Awakening;ノーグに入ってギルガメッシュ（出なければ部屋で話す）、ジュノ下層の Neptune's Spire の扉で Aldo。順は問わない
g01 go - | ノーグに入ってイベント | 出ないときはギルガメッシュの部屋で話す。 | @ノーグ
g02 examine - | ジュノ下層(J-7)のDoor:Neptune's Spireを調べてイベントを見ると完了 | ノーグと順番は問わない。 | @ジュノ下層 J-7 | T obj.245.Door_Neptunes_Spire

@ mission.zilart.017 https://wiki.ffo.jp/html/7294.html
Q The Last Verse | すべての終わりが閉ざされん | no
MN ZM18 18
LK quest:クエスト「世界に在りて君は何を想うのか？」をクリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Last_Verse;ジラートの18番目（プロマシアの8-5）。終わると一覧に出るだけ
g01 go - | クエスト「世界に在りて君は何を想うのか？」をクリアすると、一覧に出て完了 | することはない。物語が終わった印。

@ mission.zilart.018 https://wiki.ffo.jp/html/39141.html
Q To Commence RotZ | 「ジラートの幻影」を始めるには…… | no | T obj.252.Tales_Beginning
MN - 19
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/The_New_Frontier;開始のイベントを飛ばしたら H-9 の Tales' Beginning から。BG Wiki にこの導入のページはない
g01 examine - | ノーグ(H-9)のTales' Beginningを調べてオープニングのイベントを見ると完了 | ノーグに入ったときに「後にする」を選んだときだけ一覧に出る。終わると「新たなる世界」が一覧に出る。 | @ノーグ H-9 | T obj.252.Tales_Beginning


@ mission.zilart.019 https://wiki.ffo.jp/html/7548.html
Q Kazham's Chieftainess | カザム族長 | no | T npc.250.Jakoh_Wahcondalo
MN ZM3 3
RW key_item:生贄の間へのカギ
LK condition:前節「海賊の巣窟ノーグ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kazham%27s_Chieftainess;カザム J-9 の Jakoh Wahcondalo から Sacrificial Chamber key。カザム Home Point #1 のそば（FFXIclopedia も J-9）。基礎シートには行がなく、ミッション一覧の最後に足した
g01 talk - | カザム(J-9)のJakoh Wahcondaloに話して「生贄の間へのカギ」を受け取ると完了 | カザムのHome Point #1のすぐそば。 | @カザム J-9 | T npc.250.Jakoh_Wahcondalo
