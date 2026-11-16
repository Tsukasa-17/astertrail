# 三国ミッション：サンドリア（パイロット済みの 006・010 以外）
@ mission.sandoria.001 https://wiki.ffo.jp/html/8244.html
g01 talk s01 | サンドリアのゲートガードに話してミッションを受ける | - 
g02 defeat s02 | Orcish Fodderを倒して「オーキシュアクス」を手に入れる | 駆け出しには強い相手。前衛でもLv5前後は欲しい。 | T mob.Orcish_Fodder
g03 trade s03 | ゲートガードに「オーキシュアクス」をトレードして完了 | - | N オーキシュアクス

@ mission.sandoria.002 https://wiki.ffo.jp/html/8245.html
g01 talk s01 | サンドリアのゲートガードに話してミッションを受ける | 何度でも受けられる。2回目以降は「コウモリの牙」を渡すだけ。
g02 examine s02 | 東ロンフォール南端、龍王ランペールの墓(I-10)のTombstoneを調べてイベント | 周りの敵を相手にするならLv10ほど。 | @東ロンフォール I-10 | T obj.101.Tombstone
g03 defeat s03 | 夜に出るDing Batsを倒して「オークの鎧の小札」を手に入れる | - | @東ロンフォール I-10 | T mob.Ding_Bats | W 夜間
g04 trade s04 | ゲートガードに「オークの鎧の小札」をトレードして完了 | - | N オークの鎧の小札

@ mission.sandoria.003 https://wiki.ffo.jp/html/8246.html
g01 talk s01 | 北サンドリアの大聖堂(M-6)のArnauに話す | 2回目以降はガードからBFに直行し、ガードに報告するだけ。 | @北サンドリア M-6 | T npc.Arnau
g02 fight s02 | ゲルスバ野営陣(F-10)のHut DoorからBF「子供の救助」に入り、オーク3体を倒す | レベル無制限・6人・10分、フェイス可。ボスのFodderchief Vokdekより、部下2体から倒すと楽。 | @ゲルスバ野営陣 F-10 | T obj.140.Hut_Door
g03 examine s03 | 「オーク小屋のカギ」を手に入れたら、もう一度Hut Doorを調べてイベント | - | @ゲルスバ野営陣 F-10 | T obj.140.Hut_Door | K オーク小屋のカギ
g04 talk s04 | サンドリアに戻り、ゲートガードに報告して完了 | ランク2、1,000ギル。
g05 talk s05 | 北サンドリアの大聖堂(M-6)のArnauに話してイベント | 次のミッションにつながる。 | @北サンドリア M-6 | T npc.Arnau

@ mission.sandoria.004 https://wiki.ffo.jp/html/8247.html
g01 talk s01 | ラテーヌ高原(F-6)のVicorpasseに話す | 戦闘はなく、NPCの間を行き来するミッション。 | @ラテーヌ高原 F-6 | T npc.102.Vicorpasse
g02 talk s02 | オルデール鍾乳洞MAP[1](H-3)のRuillontに話す | - | @オルデール鍾乳洞 H-3 #1 | T npc.193.Ruillont
g03 talk s03 | ラテーヌ高原の騎士団員に話して「ブロンズソード」を受け取る | Deaufrain(F-6)・Equesobillot(F-6)・Galaihaurat(E-6)のうち誰か（ランダム）。 | @ラテーヌ高原 F-6 | T npc.102.Deaufrain
g04 trade s04 | オルデール鍾乳洞MAP[1](H-3)のRuillontに「ブロンズソード」をトレード | 騎士団員から受け取る前に自前の剣を渡しても受け取ってもらえない。受け取った後なら店売りのものでもよい。 | @オルデール鍾乳洞 H-3 #1 | T npc.193.Ruillont | N ブロンズソード
g05 talk s05 | ラテーヌ高原(F-6)のVicorpasseに話して「救助訓練修了証」を入手 | - | @ラテーヌ高原 F-6 | T npc.102.Vicorpasse
g06 talk s06 | サンドリアに戻り、ゲートガードに報告して完了 | -

@ mission.sandoria.005 https://wiki.ffo.jp/html/8248.html
g01 talk s01 | ダボイ入口付近(J-7)の木陰にいるZantaviatに話す | 省略できるミッション。何度でも受けられる。 | @ダボイ J-7 | T npc.149.Zantaviat
g02 examine s02 | ダボイ(J-8)の「!」を調べて「落とした書類」を入手 | - | @ダボイ J-8
g03 talk s03 | Zantaviatにもう一度話して「ダボイ調査報告書」を入手 | - | @ダボイ J-7 | T npc.149.Zantaviat
g04 talk s04 | サンドリアのゲートガードに報告する | 省略してもよい。2回目以降はここで完了。
g05 examine s05 | 北サンドリア(M-7)大聖堂3FのDoor:Papal Chambersを調べてイベント、完了 | - | @北サンドリア M-7 | T obj.231.Door_Papal_Chambers

@ mission.sandoria.007 https://wiki.ffo.jp/html/8249.html
g01 talk s01 | サンドリアのゲートガードに話してミッションを受ける | 初回と2回目以降で内容が違う。ここで選ぶ。 | > a01,b01
a01 examine s02 | 【初回】ドラギーユ城(H-7)のDoor:Prince Royal's Rmを調べてイベント | - | @ドラギーユ城 H-7 | T obj.233.Door_Prince_Royals_Rm | R 初回
a02 go s03 | ダボイに入ってイベント | - | @ダボイ | R 初回
a03 talk s04 | ダボイ(H-7)あたりを巡回しているQuemaricondに話し「王立騎士団ダボイ調査報告書」を入手 | エルヴァーンのNPC。歩き回っている。 | @ダボイ H-7 | T npc.149.Quemaricond | R 初回
a04 examine s05 | ドラギーユ城(H-7)のDoor:Prince Royal's Rmを調べてイベント、完了 | - | @ドラギーユ城 H-7 | T obj.233.Door_Prince_Royals_Rm | R 初回 | >
b01 talk - | 【2回目以降】ダボイ入口のZantaviatに話す | 暗号メモを3つ集めるよう頼まれる。 | @ダボイ J-7 | T npc.149.Zantaviat | R 2回目以降
b02 examine - | ダボイ(J-7 テンキー7)の「!」を調べて「北居住区の暗号メモ」を入手 | 3つは好きな順でよい。 | @ダボイ J-7 | R 2回目以降
b03 examine - | ダボイ(K-7 テンキー9)の「!」を調べて「東居住区の暗号メモ」を入手 | - | @ダボイ K-7 | R 2回目以降
b04 examine - | ダボイ(L-8 テンキー1)の「!」を調べて「南居住区の暗号メモ」を入手 | - | @ダボイ L-8 | R 2回目以降
b05 talk - | 入口のZantaviatに暗号メモを渡す | - | @ダボイ J-7 | T npc.149.Zantaviat | K 北居住区の暗号メモ,東居住区の暗号メモ,南居住区の暗号メモ | R 2回目以降
b06 talk - | サンドリアのゲートガードに報告して完了 | - | R 2回目以降

@ mission.sandoria.008 https://wiki.ffo.jp/html/5726.html
g01 talk s01 | サンドリアのゲートガードに話してミッションを受ける | 省略できるミッション。何度でも受けられる。
g02 gather s02 | 「クリスタルバス」を1匹用意する | ジャグナー森林東側の水晶泉（Crystwater Spring）で釣れる。競売で買ってもよい。自分で釣るなら下級職人ほどの釣りスキルが必要。 | @ジャグナー森林 | T obj.104.Crystwater_Spring
g03 trade s03 | サンドリアのゲートガードに「クリスタルバス」をトレードしてイベント | 2回目以降はここで完了。 | N クリスタルバス
g04 go s04 | ドラギーユ城に入ってイベント | - | @ドラギーユ城
g05 talk s05 | ドラギーユ城(F-7)のChalvatotに話してイベント、完了 | - | @ドラギーユ城 F-7 | T npc.233.Chalvatot

@ mission.sandoria.009 https://wiki.ffo.jp/html/8250.html
g01 talk s01 | ゲートガードでミッションを受け、ドラギーユ城(I-9)のHalverに話す | - | @ドラギーユ城 I-9 | T npc.233.Halver
g02 examine s02 | ドラギーユ城のDoor:Great Hall(I-9)を調べて謁見、「ジュノ大使への紹介状」を入手 | - | @ドラギーユ城 I-9 | T obj.233.Door_Great_Hall = obj:Door:Great Hall@ドラギーユ城 I-9
g03 talk s03 | ル・ルデの庭のサンドリア大使館(G-9)のNelcabritに話してイベント | 「デルクフ認証キー」か「デルクフのカギ」を持っているかで道が分かれる。 | @ル・ルデの庭 G-9 | T npc.243.Nelcabrit | > a01,b01
a01 defeat s04 | 【キーなし】デルクフの塔上層10階のPorphyrionを倒して「デルクフのカギ」を手に入れる | 巨人族のNM（Lv36相当）。ソロならLv50ほど。カギはPT全員分落ちる。 | @デルクフの塔上層 | T mob.158.Porphyrion | R キーなし
a02 trade s05 | (H-8)のElevatorに「デルクフのカギ」をトレードして「デルクフ認証キー」を入手 | 下り専用の螺旋階段に移る。認証キーを取ったあとのカギは捨ててよい。 | @デルクフの塔上層 H-8 | T npc.Elevator | N デルクフのカギ | R キーなし
a03 go s05 | 螺旋階段を下りて、デルクフの塔下層の地下まで行く | - | @デルクフの塔下層 | R キーなし | > g07
b01 go - | 【キーあり】デルクフの塔下層1階(E-8)のCermet Doorから地下へ行く | 「デルクフのカギ」だけなら、このCermet Doorにトレードすると認証キーがもらえる。 | @デルクフの塔下層 E-8 | R キーあり
g07 examine s06 | デルクフの塔下層の地下(M-8)のCermet Doorを調べてイベント | サンドリア大使Jimaと会う。 | @デルクフの塔下層 M-8 | T obj.184.Cermet_Door
g08 examine s07 | ル・ルデの庭のサンドリア大使館(G-9)のDoor:San d'Orian Emb.を調べて完了 | ランク4、5,000ギル。 | @ル・ルデの庭 G-9 | T obj.243.Door_San_dOrian_Emb

@ mission.sandoria.011 https://wiki.ffo.jp/html/5644.html
g01 go s01 | 「魔晶石を奪え」のあと、ドラギーユ城に入ってイベント | - | @ドラギーユ城
g02 talk s02 | ゲートハウスのミッションNPCに話してミッションを受ける | 南サンドリアのAmbrotien(K-10)・Endracion(F-9)、北サンドリアのGrilau(D-8)。
g03 talk s03 | ドラギーユ城(I-9)のHalverに話して「フェ・インの新しい護符」を入手 | - | @ドラギーユ城 I-9 | T npc.233.Halver
g04 go s04 | フェ・インに入ってイベント | - | @フェ・イン
g05 fight s05,s06 | フェ・インMAP[1](K-8)からク・ビアの闘技場に入り、Burning CircleでBF「ランク5ミッション」に勝つ | 勝つと「燃え尽きた護符」を入手。 | @フェ・イン K-8 #1 | T obj.204.Burning_Circle
g06 talk s07 | ドラギーユ城のHalverに報告して完了 | - | @ドラギーユ城 I-9 | T npc.233.Halver

@ mission.sandoria.012 https://wiki.ffo.jp/html/4255.html
g01 talk s01 | サンドリアのゲートガードに話してミッションを受ける | -
g02 talk s02 | ドラギーユ城(I-9)のHalverに話す | - | @ドラギーユ城 I-9 | T npc.233.Halver
g03 examine s03 | ドラギーユ城(H-7)のトリオン王子の部屋、Door:Prince Royal's Rmを調べてイベント | - | @ドラギーユ城 H-7 | T obj.233.Door_Prince_Royals_Rm
g04 examine s04 | ズヴァール城内郭の王の間に入り、Throne Roomを調べてイベント | - | @ズヴァール城内郭 | T obj.162.Throne_Room
g05 fight s05 | もう一度Throne Roomを調べ、BF「ランク5ミッション」に勝って「闇の破片」を入手 | 勝つとズヴァール城外郭の入口に戻される。 | @ズヴァール城内郭 | T obj.162.Throne_Room
g06 talk s06 | ドラギーユ城(I-9)のHalverに話して完了 | ランク6、20,000ギル。 | @ドラギーユ城 I-9 | T npc.233.Halver
g07 examine s07 | ドラギーユ城(I-9)のDoor:Great Hallを調べて謁見の間のイベント | - | @ドラギーユ城 I-9 | T obj.233.Door_Great_Hall

@ mission.sandoria.013 https://wiki.ffo.jp/html/4943.html
g01 talk s01 | ゲートガードでミッションを受け、ドラギーユ城(I-9)のHalverに話す | - | @ドラギーユ城 I-9 | T npc.233.Halver
g02 examine s02 | ドラギーユ城(I-9)のDoor:Great Hallを調べて謁見の間のイベント | - | @ドラギーユ城 I-9 | T obj.233.Door_Great_Hall
g03 examine s03 | 西アルテパ砂漠(G-7 テンキー5)、天啓の岩の西のオアシスのDreamroseを調べる | ユニティワープ（CL125）で西アルテパ砂漠に飛び、西へ向かうと早い。NMが出る。 | @西アルテパ砂漠 G-7 | T obj.125.Dreamrose = obj:Dreamrose@西アルテパ砂漠 G-7
g04 defeat s03 | 出てきたSabotender Enamoradoを倒す | 特殊技が多く、針千本の連発に注意。 | @西アルテパ砂漠 G-7 | T mob.125.Sabotender_Enamorado
g05 examine s04 | もう一度Dreamroseを調べて「夢幻花」を入手 | - | @西アルテパ砂漠 G-7 | T obj.125.Dreamrose
g06 talk s05 | ドラギーユ城(I-9)のHalverに話す | - | @ドラギーユ城 I-9 | T npc.233.Halver
g07 go s05 | ドラギーユ城のローテの庭(F-7)でイベントを見て完了 | 選択肢はどちらでもよい。「紙くず」を入手。あとでガードに「花を見に来て」と言われたら、もう一度ローテの庭でイベントを見る。 | @ドラギーユ城 F-7

@ mission.sandoria.014 https://wiki.ffo.jp/html/4840.html
g01 examine s01 | ドラギーユ城(H-7)のトリオンの私室（Door:Prince Royal's Rm）を調べてイベント | ガードでミッションを受けてから。 | @ドラギーユ城 H-7 | T obj.233.Door_Prince_Royals_Rm
g02 examine s02 | 龍王ランペールの墓MAP[1](H-8 テンキー2)のHeavy Stone Doorを調べる | スケルトン族のNMが3体出る。スニークをかけていれば出たときに襲われない。 | @龍王ランペールの墓 H-8 #1 | T obj.190.Heavy_Stone_Door
g03 defeat s02 | Corrupted Yorgos・Corrupted Soffeil・Corrupted Ulbrigを倒す | リンクしないので1体ずつ釣る。残りは放っておけば消え、釣った1体を倒せば全部倒した扱い。鎌の2体は強い魔法を使うのでサイレスやスタンを。 | @龍王ランペールの墓 H-8 #1 | T mob.190.Corrupted_Yorgos = mob:Corrupted Yorgos@龍王ランペールの墓 H-8 #1
g04 examine s03 | もう一度Heavy Stone Doorを調べて小部屋に入り、奥のTombstoneを調べて「古代サンドリア語の古文書」を入手 | - | @龍王ランペールの墓 H-8 #1 | T obj.190.Tombstone
g05 talk s04 | サンドリアのゲートガードに報告する | -
g06 talk s04 | 1分待って、ゲートガードにもう一度話す | -
g07 go s05 | ドラギーユ城(H-7)のトリオンの私室へ行く | - | @ドラギーユ城 H-7 | T obj.233.Door_Prince_Royals_Rm
g08 examine s06 | 龍王ランペールの墓MAP[1](H-8)のHeavy Stone Doorを調べる | - | @龍王ランペールの墓 H-8 #1 | T obj.190.Heavy_Stone_Door
g09 talk s07 | サンドリアのゲートガードに報告して完了 | ランク7、40,000ギル。

@ mission.sandoria.015 https://wiki.ffo.jp/html/8251.html
g01 talk s01 | サンドリアのゲートガードに話してミッションを受ける | -
g02 examine s02 | 北サンドリアの大聖堂3F(M-7)のDoor:Papal Chambersを調べてイベント | - | @北サンドリア M-7 | T obj.231.Door_Papal_Chambers
g03 examine s03 | ボストーニュ監獄を通って西ロンフォール(E-8)の???を調べる | オーク族のNMが出る。 | @西ロンフォール E-8 | T obj.100.???_E-8 = obj:???@西ロンフォール E-8
g04 defeat s03 | 出てきたMarauder Dvogzogを倒す | モンクタイプで手数が多く、百烈拳を何度も使う。回避の高いジョブだと楽。 | @西ロンフォール E-8 | T mob.100.Marauder_Dvogzog = mob:Marauder Dvogzog@西ロンフォール E-8
g05 examine s04 | もう一度???を調べて「古代サンドリア語の石版」を入手 | - | @西ロンフォール E-8 | T obj.100.???_E-8
g06 examine s05 | 大聖堂3FのDoor:Papal Chambersを調べて完了 | - | @北サンドリア M-7 | T obj.231.Door_Papal_Chambers

@ mission.sandoria.016 https://wiki.ffo.jp/html/8252.html
g01 talk s01 | サンドリアのゲートガードに話してイベント | -
g02 go s02 | ドラギーユ城のローテの庭(F-7)へ行ってイベント | - | @ドラギーユ城 F-7
g03 talk s03 | ゲートガードに話してミッションを受ける | -
g04 fight s04 | ユグホトの岩屋の奥、ホルレーの岩峰でBFに勝って「クリスタル・ダウザー」を入手 | オークNM3体（Darokbok of Clan Reaper・Jagidbod of Clan Reaper・Derakbak of Clan Wolf）と戦車NM2体を倒す。スリプガが効く。Jagidbodのイーグルアイに注意。 | @ホルレーの岩峰
g05 talk s05 | サンドリアに戻り、ゲートガードに話して完了 | ランク8、60,000ギル。

@ mission.sandoria.017 https://wiki.ffo.jp/html/8253.html
g01 talk s01 | サンドリアのゲートガードに話してミッションを受ける | -
g02 go s01 | ドラギーユ城に入ってイベント | - | @ドラギーユ城
g03 talk s02 | ドラギーユ城(I-9)のHalverに話し、「落羊水」を取ってくるよう頼まれる | - | @ドラギーユ城 I-9 | T npc.233.Halver
g04 go s03 | 東アルテパ砂漠(H-10)から流砂洞に入り、MAP[2](E-11)の落とし穴から落ちる | 落ちた先で左の壁沿いに進む。 | @流砂洞 E-11 #2
g05 examine s03 | 流砂洞MAP[2](F-14)の王者の泉（Fountain of Kings）を調べる | 地図には出ない。頭足族NMのValorとHonorが出る。近くに釣り人がいたら、出す前に声をかける（外れた敵がほかの人に絡む）。 | @流砂洞 F-14 #2 | T obj.208.Fountain_of_Kings = obj:Fountain of Kings@流砂洞 F-14 #2
g06 defeat s03 | ValorとHonorを倒す | Honorはサイレガとパライガを使うので、やまびこ薬を持っていく。片方だけ倒しても、もう片方が戻って消えたあとならよい。 | @流砂洞 F-14 #2 | T mob.208.Honor = mob:Honor@流砂洞 F-14 #2
g07 examine s04 | NMが消えたら、もう一度Fountain of Kingsを調べて「落羊水」を入手 | - | @流砂洞 F-14 #2 | T obj.208.Fountain_of_Kings
g08 talk s05 | ドラギーユ城(I-9)のHalverに「落羊水」を渡す | - | @ドラギーユ城 I-9 | T npc.233.Halver | K 落羊水
g09 go s06 | 10秒ほど待ってから、北サンドリアに入ってイベント、完了 | - | @北サンドリア

@ mission.sandoria.018 https://wiki.ffo.jp/html/8254.html
g01 examine s01 | ゲートガードでミッションを受け、ドラギーユ城(I-9)のDoor:Great Hallを調べる | - | @ドラギーユ城 I-9 | T obj.233.Door_Great_Hall
g02 talk s02 | ドラギーユ城(H-9)の王立騎士団の部屋のRahalに話して「クリスタル・ダウザー」を入手 | - | @ドラギーユ城 H-9 | T npc.233.Rahal = npc:Rahal@ドラギーユ城 H-9
g03 defeat s03 | トンベリの忍者を倒して「高僧のカギ」を手に入れる | 怨念洞のHP#2から南西に落ちたあたりのTonberry Slasherが狙いやすい。 | @怨念洞 | T mob.160.Tonberry_Slasher = mob:Tonberry Slasher~@怨念洞
g04 defeat s04 | ウガレピ寺院MAP[2](I-10)のTemple Guardianを倒して広場に入る | Proto-Waypointで飛ぶと早い。 | @ウガレピ寺院 I-10 #2 | T mob.159.Temple_Guardian
g05 go s04 | 広場の階段の上のGranite Doorを「高僧のカギ」で開けてMAP[4]へ | 東西に2つあるがどちらでもよい。 | @ウガレピ寺院 - #2 | N 高僧のカギ
g06 examine s05 | MAP[4]南の小部屋（西から1・3・4番目）の???を調べて「カギのかけら」を3つ集める | (G-10)・(H-10)・(I-10)の部屋。 | @ウガレピ寺院 H-10 #4
g07 examine s06 | 西から2番目の開かないGranite Door(H-10)を調べる | ドール族NMのNio-AとNio-Humが出る。 | @ウガレピ寺院 H-10 #4 | T obj.159.Granite_Door_H-10 = obj:Granite Door~@ウガレピ寺院 H-10 #4
g08 defeat s06 | Nio-AとNio-Humを倒す | - | @ウガレピ寺院 H-10 #4 | T mob.Nio-Hum
g09 examine s06 | NMが消えたら、もう一度Granite Doorを調べてイベント | - | @ウガレピ寺院 H-10 #4 | T obj.159.Granite_Door_H-10
g10 examine s07 | ドラギーユ城(I-9)のDoor:Great Hallを調べて完了 | ランク9、80,000ギル。 | @ドラギーユ城 I-9 | T obj.233.Door_Great_Hall

@ mission.sandoria.019 https://wiki.ffo.jp/html/8255.html
g01 examine s01 | ゲートガードでミッションを受け、ドラギーユ城(I-9)のDoor:Great Hallを調べる | 小像は陸・空・海の順に取らないといけない。 | @ドラギーユ城 I-9 | T obj.233.Door_Great_Hall
g02 examine s02 | 慟哭の谷(I-8)の???を調べて「陸の王の小像」を入手 | 1つ目。 | @慟哭の谷 I-8 | T obj.128.???_I-8 = obj:???@慟哭の谷 I-8
g03 examine s03 | ザルカバード(H-7)上段、テンキー4と5の境目あたりの???を調べて「空の王の小像」を入手 | 2つ目。 | @ザルカバード H-7 | T obj.112.???_H-7 = obj:???@ザルカバード H-7
g04 examine s04 | バタリア丘陵(J-11)南の小島の石碑側の???を調べる | 3つ目。エルディーム古墳を通って行く。ロック族NMが2体出る。 | @バタリア丘陵 J-11 | T obj.バタリア丘陵.???_J-11 = obj:???@バタリア丘陵 J-11
g05 defeat s04 | SuparnaとSuparna Fledglingを倒す | 弱体魔法にすぐ耐性がつく。エリアチェンジを使って1体だけ倒してもよい（はぐれた1体が消える前に倒さないこと）。 | @バタリア丘陵 J-11 | T mob.バタリア丘陵.Suparna = mob:Suparna@バタリア丘陵 J-11
g06 examine s05 | もう一度???を調べて「海の王の小像」を入手 | - | @バタリア丘陵 J-11 | T obj.バタリア丘陵.???_J-11
g07 examine s06 | ドラギーユ城(I-9)のDoor:Great Hallを調べてイベント、完了 | - | @ドラギーユ城 I-9 | T obj.233.Door_Great_Hall

@ mission.sandoria.020 https://wiki.ffo.jp/html/6043.html
g01 talk s01 | サンドリアのゲートガードに話してミッションを受ける | 質問の答えはどれでもよい。
g02 go s02 | 北サンドリアに入ってイベント | 北サンドリア、ドラギーユ城、フェ・インの順に入ってイベントを見る。 | @北サンドリア
g03 go s02 | ドラギーユ城に入ってイベント | - | @ドラギーユ城
g04 go s02 | フェ・インに入ってイベント | - | @フェ・イン
g05 fight s03 | フェ・インMAP[1](K-8)からク・ビアの闘技場に入り、Burning CircleのBFで敵を全部倒す | このミッションを受けている人か、クリアした人しか入れない。 | @フェ・イン K-8 #1 | T obj.204.Burning_Circle
g06 go s04 | 北サンドリアに入ってイベント | - | @北サンドリア
g07 examine s05 | ドラギーユ城(I-9)のDoor:Great Hallを調べて謁見の間のイベント | - | @ドラギーユ城 I-9 | T obj.233.Door_Great_Hall
g08 examine s06 | 龍王ランペールの墓MAP[1](H-8)のHeavy Stone Doorを調べてイベント | - | @龍王ランペールの墓 H-8 #1 | T obj.190.Heavy_Stone_Door
g09 talk s07 | ドラギーユ城(I-9)のHalverに話して完了 | ランク10、100,000ギル、王国旗。 | @ドラギーユ城 I-9 | T npc.233.Halver
