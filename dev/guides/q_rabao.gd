# ラバオ（Rabao）
@ quest.rabao.001 https://wiki.ffo.jp/html/24844.html
Q VW Op. #101: Detour to Zepwell | VW作戦第247計画ゼプウェル島 | no | T npc.247.Gushing_Spring = npc:Gushing Spring@ラバオ G-8
LK quest:クエスト「VW作戦の表裏」を受けている
XS BG Wiki;https://www.bg-wiki.com/ffxi/VW_Op._101:_Detour_to_Zepwell;ヴォイドウォーカーの出る場所：Sabotender Campeador 西アルテパ砂漠 G-10・H-5・L-6、Tangaroa クフタルの洞門 MAP2 F-8・J-9／MAP3 I-8、Malleator Maurok 流砂洞 MAP3 F-9・G-9
g01 talk - | ラバオ(G-8)オアシス付近のGushing Springに話し、選択肢で「参加する」を選んで受ける | ほかを選ぶと進まない。受けるとAtmacite Refinerが西アルテパ砂漠・クフタルの洞門・流砂洞の入口へ送ってくれる。 | @ラバオ G-8 | T npc.247.Gushing_Spring
g02 fight - | 西アルテパ砂漠のヴォイドウォーカー「Sabotender Campeador」を倒す | 出る場所は G-10・H-5・L-6 のどれか。 | @西アルテパ砂漠 | T mob.125.Sabotender_Campeador = mob:Sabotender Campeador@西アルテパ砂漠
g03 fight - | クフタルの洞門のヴォイドウォーカー「Tangaroa」を倒す | 出る場所は MAP2 の F-8・J-9、MAP3 の I-8 のどれか。 | @クフタルの洞門 | T mob.174.Tangaroa = mob:Tangaroa@クフタルの洞門
g04 fight - | 流砂洞のヴォイドウォーカー「Malleator Maurok」を倒す | 出る場所は MAP3 の F-9・G-9 のどちらか。 | @流砂洞 #3 | T mob.208.Malleator_Maurok = mob:Malleator Maurok@流砂洞 #3
g05 talk - | 3体を倒したらGushing Springに話して完了 | 「VW作戦第250計画エルシモ島」も終えたら、ノーグのKieranに話す。 | @ラバオ G-8 | T npc.247.Gushing_Spring

@ quest.rabao.002 https://wiki.ffo.jp/html/4763.html
Q The Kuftal Tour | クフタル観光案内 | no | T npc.247.Datta = npc:Datta@ラバオ F-7
RW gil:8,000ギル
RW title:クフタルツーリスト
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Kuftal_Tour;Datta F-7。???はクフタルの洞門の入ってすぐの崖の上（グリッドは用語辞典の H-8）
g01 talk - | ラバオ(F-7)のDattaに話して受ける | - | @ラバオ F-7 | T npc.247.Datta
g02 go - | 全員Lv40以下の2人以上のパーティを組む | フェイスは数に入らない。レベルシンクで合わせてもよい。
g03 examine - | クフタルの洞門に入ってすぐの広場(H-8)の崖の上にある???にみんなで集まって調べる | 崖下のゴースト族はHPが減っていると寄ってくる。 | @クフタルの洞門 H-8 | T obj.174.???_H-8 = obj:???@クフタルの洞門 H-8
g04 talk - | ラバオのDattaに話して完了 | - | @ラバオ F-7 | T npc.247.Datta

@ quest.rabao.003 https://wiki.ffo.jp/html/33862.html
Q Fish Favors the Bold | 勇魚 | no | T npc.247.Irmilant = npc:Irmilant@ラバオ G-7
RW item:真恵比寿釣竿
RW title:釣神
LK condition:「恵比寿釣竿」を持っている
LK condition:2015年6月25日以降に100種類以上の水産物を釣っている
LK condition:「アビセアの死闘」までの拡張データをすべて登録している
XS BG Wiki;https://www.bg-wiki.com/ffxi/Fish_Favors_the_Bold;Irmilant G-7
g01 talk - | ラバオ(G-7)のIrmilantに話して受ける | 恵比寿釣竿をモグボナンザでもらっていると、「折れぬ魂」が自動で完了になる。 | @ラバオ G-7 | T npc.247.Irmilant
g02 gather - | 伝説魚「シンリュウノツカイ」「ゴライアスホーン」「マツヤ」「コウリュウ」「ナミニャミ」を自分で釣る | シンリュウノツカイとゴライアスホーンは「伝説の巨大魚紀聞」がいる。マツヤとコウリュウはEx餌がいる。伝説魚を持っているとヒントを聞けない。
g03 trade - | Irmilantに5種類の伝説魚を1尾ずつトレードする | 自分で釣ってKatsunagaのリストに載ったものだけ受け取ってもらえる。5種類渡すと称号「釣神」。 | @ラバオ G-7 | T npc.247.Irmilant | N シンリュウノツカイ*1,ゴライアスホーン*1,マツヤ*1,コウリュウ*1,ナミニャミ*1
g04 trade - | Irmilantに「恵比寿釣竿」をトレードして完了 | - | @ラバオ G-7 | T npc.247.Irmilant | N 恵比寿釣竿*1

@ quest.rabao.004 https://wiki.ffo.jp/html/10516.html
Q The Missing Piece | 古代魔法の石版 | no | T npc.247.Alfesar = npc:Alfesar@ラバオ H-7
RW item:Scroll of Teleport-Altep
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Missing_Piece;報酬は Scroll of Teleport-Altep。日本語の正式なアイテム名は用語辞典で確かめられないので英語名
RW title:古代秘法を継ぐ者
LK fame:ラバオの名声ランク4以上
LK condition:Lv10以上
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/The_Missing_Piece;名声 Rabao 4。Alfesar H-7（用語辞典は H-8、FFXIclopedia は H-7）。???は流砂洞 MAP1 H-6・H-10・E-9、MAP2 D-9・L-11 のどれかに出る（用語辞典は MAP2 L-11）。Charlaimagnat 北サンドリア M-7
g01 talk - | ラバオ(H-7)オアシス付近のAlfesarに話して受ける | - | @ラバオ H-7 | T npc.247.Alfesar
g02 examine - | 東アルテパ砂漠(H-10)から流砂洞に入り、???を調べてだいじなもの「古代石版の欠片」を手に入れる | ???は MAP1 の H-6・H-10・E-9、MAP2 の D-9・L-11 のどれかに出る。 | @流砂洞 | T obj.208.??? = obj:???@流砂洞
g03 talk - | ラバオのAlfesarに話し、だいじなもの「古代魔法の石版」と「アルフェザールの紹介状」をもらう | - | @ラバオ H-7 | T npc.247.Alfesar | K 古代石版の欠片
g04 talk - | 北サンドリア(M-7)大聖堂地下のCharlaimagnatに話す | - | @北サンドリア M-7 | T npc.231.Charlaimagnat = npc:Charlaimagnat@北サンドリア M-7 | K 古代魔法の石版,アルフェザールの紹介状
g05 talk - | エリアを出入りしてからもう一度Charlaimagnatに話して完了 | 「後日」と言われても、エリアを出入りすればその日のうちにもらえる。 | @北サンドリア M-7 | T npc.231.Charlaimagnat

@ quest.rabao.005 https://wiki.ffo.jp/html/10223.html
Q The Immortal Lu Shang | 太公望は死なず | yes | T npc.247.Irmilant
RW item:太公望の釣竿
RW title:不死身の太公望
LK condition:「折れた太公望の釣竿」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Immortal_Lu_Shang;Irmilant G-7
g01 talk - | 「折れた太公望の釣竿」を持ってラバオ(G-7)のIrmilantに話して受ける | 「意地」「根性」を終えていなくてよい。 | @ラバオ G-7 | T npc.247.Irmilant
g02 trade - | Irmilantに「折れた太公望の釣竿」「神代木」「光のクリスタル」2個をトレードして完了 | 折れた真太公望はここでは直せない。 | @ラバオ G-7 | T npc.247.Irmilant | N 折れた太公望の釣竿*1,神代木*1,光のクリスタル*2

@ quest.rabao.006 https://wiki.ffo.jp/html/1339.html
Q Indomitable Spirit | 折れぬ魂 | no | T npc.247.Irmilant
RW item:恵比寿釣竿
RW title:釣神流免許皆伝
LK condition:だいじなもの「サーペントの伝説」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Indomitable_Spirit;サーペントの伝説はウィンダス港の Fennella で 95,000 ポイントと交換（釣りスキル皆伝以上）。剣の枝はリク、五色の糸はググリューサウルスをセルビナの Zaldon に渡すとまれにもらえる
g01 go - | 釣りギルドのポイント95,000で、だいじなもの「サーペントの伝説」と交換する | 釣りスキルが皆伝以上でないと交換できない。 | K サーペントの伝説
g02 talk - | ラバオ(G-7)のIrmilantに話して受ける | - | @ラバオ G-7 | T npc.247.Irmilant | K サーペントの伝説
g03 gather - | 「剣の枝」と「五色の糸」を用意する | リクやググリューサウルスをセルビナのZaldonに渡すと、まれにもらえる。 | N 剣の枝*1,五色の糸*1
g04 trade - | Irmilantに「剣の枝」と「五色の糸」をトレードする | - | @ラバオ G-7 | T npc.247.Irmilant | N 剣の枝*1,五色の糸*1
g05 talk - | コンクェストの集計をまたいでからIrmilantに話して完了 | - | @ラバオ G-7 | T npc.247.Irmilant | W コンクェストの集計のあと

@ quest.rabao.007 https://wiki.ffo.jp/html/33861.html
Q Thanks for All the Fish | 根気 | no | T npc.247.Jourdenaux = npc:Jourdenaux@ラバオ F-8
RW item:真太公望の釣竿
RW title:一竿入魂の太公望
LK condition:「太公望の釣竿」を持っている
LK quest:エミネンス・レコードのクエスト「始まりの軌跡」をコンプリート
XS BG Wiki;https://www.bg-wiki.com/ffxi/Thanks_for_All_the_Fish;Jourdenaux F-8
g01 talk - | ラバオ(F-8)のJourdenauxに話して受ける | エミネンス・レコード「釣り：『根気』」が加わる。 | @ラバオ F-8 | T npc.247.Jourdenaux
g02 gather - | 2015年6月25日以降に60種類以上の獲物を釣り上げる | 釣竿は何でもよい。マウラの「釣り人の心」で数を確かめられる。
g03 gather - | エミネンス・レコード「釣り：『根気』」の目標をすべて達成する | こちらは太公望の釣竿で釣った分だけ数える。
g04 trade - | Jourdenauxに「太公望の釣竿」をトレードして完了 | - | @ラバオ F-8 | T npc.247.Jourdenaux | N 太公望の釣竿*1

@ quest.rabao.008 https://wiki.ffo.jp/html/11943.html
Q Don't Forget the Antidote | 砂漠の旅の必需品 | yes | T npc.247.Edigey = npc:Edigey@ラバオ F-9
RW item:同田貫（初回だけ）
RW gil:1,800ギル（2回目から）
RW title:デザートハンター
LK fame:ラバオの名声ランク4以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Don%27t_Forget_the_Antidote;名声 Rabao 4。砂サソリの毒は東西アルテパ砂漠のサソリ（Doom Scorpion・Tulwar Scorpion など）
g01 talk - | ラバオ(F-9)のEdigeyに話して受ける | - | @ラバオ F-9 | T npc.247.Edigey
g02 gather - | 東西のアルテパ砂漠のサソリを倒して「砂サソリの毒」を手に入れる | 流砂洞へのアリ地獄のような穴の近くにいる。東はLv40代、西はLv50代。競売でも買える。 | N 砂サソリの毒*1
g03 trade - | Edigeyに「砂サソリの毒」をトレードして完了 | - | @ラバオ F-9 | T npc.247.Edigey | N 砂サソリの毒*1

@ quest.rabao.009 https://wiki.ffo.jp/html/7571.html
Q Trial by Wind | 風の試練 | yes | T npc.247.Agado-Pugado = npc:Agado-Pugado@ラバオ G-9
RW item:ガルーダダガー／ウィンドベルト／ウィンドリング／空気の水／10,000ギル のどれか1つ
RW other:何もいらないを選ぶと、召喚獣“ガルーダ”と契約できる
RW title:大いなる風の継承者
LK fame:ラバオの名声ランク6以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Trial_by_Wind;名声 Rabao 6。試練の場はテリガン岬、相手は Garuda Prime
g01 talk - | ラバオ(G-9)オアシス付近のAgado-Pugadoに話して受け、だいじなもの「風の音叉」をもらう | - | @ラバオ G-9 | T npc.247.Agado-Pugado
g02 go - | テリガン岬の風の試練の場の前まで行く | テリガン岬のホームポイント#1がいちばん近い。 | @テリガン岬
g03 fight - | 巨大なクリスタルに「風の音叉」をかかげ、試練でGaruda Primeに勝つ | 6人・30分・レベル制限なし・フェイス不可。勝つとだいじなもの「風の息吹」が手に入る。 | @テリガン岬 | T mob.113.Garuda_Prime = mob:Garuda Prime@テリガン岬 | K 風の音叉
g04 talk - | ラバオのAgado-Pugadoに話して報酬を選び、完了 | 地球時間の0時を過ぎるとまた音叉をもらえる。 | @ラバオ G-9 | T npc.247.Agado-Pugado | K 風の息吹

@ quest.rabao.010 https://wiki.ffo.jp/html/11429.html
Q Trial Size Trial by Wind | 風の試練・改 | no | T npc.247.Rahi_Fohlatti = npc:Rahi Fohlatti@ラバオ G-9
RW other:召喚獣“ガルーダ”と契約できる
RW item:呪符デジョン
XS 用語辞典;https://wiki.ffo.jp/html/2389.html;報酬の「呪符デジョン」（Instant Warp）は用語辞典で確認
LK fame:ラバオの名声ランク2以上
LK condition:Lv15以上の召喚士
XS BG Wiki;https://www.bg-wiki.com/ffxi/Trial_Size_Trial_by_Wind;Rahi Fohlatti G-9。報酬に Scroll of Instant Warp。BG Wiki はLv20以上と書く（用語辞典の Lv15 を採用）
g01 talk - | Lv15以上の召喚士で、ラバオ(G-9)オアシス付近のRahi Fohlattiに話して受け、「風の音叉・改」をもらう | - | @ラバオ G-9 | T npc.247.Rahi_Fohlatti
g02 trade - | Rahi Fohlattiに「風の音叉・改」をトレードして、テリガン岬の試練の場の前へ送ってもらう | 準備ができてからでよい。 | @ラバオ G-9 | T npc.247.Rahi_Fohlatti | N 風の音叉・改*1
g03 trade - | テリガン岬の巨大なクリスタルに「風の音叉・改」をかかげて試練の場へ入る | - | @テリガン岬 | N 風の音叉・改*1
g04 fight - | 1対1の試練でGaruda Primeに勝って完了 | ひとりで15分、使える召喚獣はカーバンクルだけ。 | @テリガン岬 | T mob.113.Garuda_Prime

@ quest.rabao.011 https://wiki.ffo.jp/html/5141.html
Q Chasing Dreams | 夢追い旅 | no | T npc.247.Zoriboh = npc:Zoriboh@ラバオ F-6
RW item:ベネラーリング
RW gil:4000
LK quest:プロマシアミッション「西への誘い」でルフェーゼ野に着いている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Chasing_Dreams;Fame=r、FLevel は空、Quest Reqs=Promathia Mission 2-1。Rudolfo (J-7)、Zoriboh (F-6)、Sohyon (J-8)、Giant Clam は MAP1 F-10・MAP3 K-6・MAP5 G-11・MAP2 I-10（用語辞典も同じマス）、Gimb (H-9)、Kagetora (F-6)、Patient Wheel (F-5)、Abelard (G-9)、バルクルム砂丘 (I-9) の渦
g01 talk - | ラバオ(J-7)の競売所のそばのRudolfoに話してイベント | - | @ラバオ J-7 | T npc.247.Rudolfo = npc:Rudolfo@ラバオ J-7
g02 talk - | ラバオ(F-6)のオアシスのそばのZoribohに話して受ける | - | @ラバオ F-6 | T npc.247.Zoriboh
g03 talk - | ノーグ(J-8)のOaken Doorの奥のSohyonに話す | - | @ノーグ J-8 | T npc.252.Sohyon = npc:Sohyon@ノーグ J-8
g04 talk - | 同じ部屋のWashuに話し、だいじなもの「ワシュウの水筒」をもらう | - | @ノーグ J-8 | T npc.252.Washu | K ワシュウの水筒
g05 examine - | コロロカの洞門MAP1(F-10)のGiant Clamを調べる | 4つは順不同。ツェールン鉱山から入るとすぐ。 | @コロロカの洞門 F-10 #1 | T obj.173.Giant_Clam_F-10 = obj:Giant Clam@コロロカの洞門 F-10 #1
g06 examine - | MAP3(K-6)のGiant Clamを調べる | - | @コロロカの洞門 K-6 #3 | T obj.173.Giant_Clam_K-6 = obj:Giant Clam@コロロカの洞門 K-6 #3
g07 examine - | MAP5(G-11)のGiant Clamを調べる | - | @コロロカの洞門 G-11 #5 | T obj.173.Giant_Clam_G-11 = obj:Giant Clam@コロロカの洞門 G-11 #5
g08 examine - | MAP2(I-10)のGiant Clamを調べ、水筒をだいじなもの「コロロカの貝の水」にする | - | @コロロカの洞門 I-10 #2 | T obj.173.Giant_Clam_I-10 = obj:Giant Clam@コロロカの洞門 I-10 #2 | K コロロカの貝の水
g09 talk - | ノーグのSohyonに話し、だいじなもの「穴倉のカギ」をもらう | - | @ノーグ J-8 | T npc.252.Sohyon | K 穴倉のカギ
g10 talk - | ノーグの入口のそば(H-9)のGimbに話す | - | @ノーグ H-9 | T npc.252.Gimb = npc:Gimb@ノーグ H-9
g11 talk - | バストゥーク港(F-6)のKagetoraに話す | - | @バストゥーク港 F-6 | T npc.236.Kagetora
g12 trade - | (F-5)のPatient Wheelに「東方の玉璧」を5つトレードする | 玉璧は海蛇の岩窟などのサハギン族が落とす。 | @バストゥーク港 F-5 | T obj.236.Patient_Wheel = obj:Patient Wheel@バストゥーク港 F-5 | N 東方の玉璧*5
g13 talk - | セルビナ(G-9)のAbelardに話す | - | @セルビナ G-9 | T npc.248.Abelard
g14 go - | バルクルム砂丘(I-9)の洞くつの渦からルフェーゼ野へ行き、イベントを見る | - | @バルクルム砂丘 I-9
g15 talk - | ラバオのZoribohに話して完了 | 次は「黄金のたてがみ」。 | @ラバオ F-6 | T npc.247.Zoriboh

@ quest.rabao.012 https://wiki.ffo.jp/html/7330.html
Q The Search for Goldmane | 黄金のたてがみ | no | T npc.247.Zoriboh
RW item:デラックスカービン
RW gil:3000
RW title:冒険初心者の師匠
LK quest:「夢追い旅」クリア、プロマシアミッション「誓いの雄叫び」まで進めている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Search_for_Goldmane;Fame=r、FLevel は空、Quest Reqs=Promathia Mission 2-5。Quelveuiat (I-10)、サイトA01 の (I-11) の島の Trunk に Copper Key（Riverne Vulture）、Vladinek (H-8)、プルゴノルゴ島 (F-9) の Weathered Boat、Rohemolipaud
g01 talk - | ラバオ(F-6)のZoribohに話し、だいじなもの「心のこもった包み」をもらう | - | @ラバオ F-6 | T npc.247.Zoriboh | K 心のこもった包み
g02 talk - | タブナジア地下壕MAP2(I-10)のQuelveuiatに話す | - | @タブナジア地下壕 I-10 #2 | T npc.26.Quelveuiat
g03 go - | リヴェーヌ岩塊群サイトA01で渦を乗りついで(I-11)の島へ行き、イベントを見る | 入って右の渦から(K-10)、(K-11)、(J-11)と進む。一方通行で、戻りに巨大な鱗がいる所がある。 | @リヴェーヌ岩塊群サイトA01 I-11
g04 gather - | 同じエリアのRiverne Vultureから「純銅のカギ」を手に入れる | PTでも人数分いる。 | @リヴェーヌ岩塊群サイトA01 | N 純銅のカギ*1
g05 trade - | (I-11)の島のまん中のTrunkに純銅のカギをトレードしてイベント | 青い宝箱。 | @リヴェーヌ岩塊群サイトA01 I-11 | T obj.30.Trunk_I-11 = obj:Trunk@リヴェーヌ岩塊群サイトA01 I-11 | N 純銅のカギ*1
g06 talk - | 大工房(H-8)の2階の食堂のVladinekに話す | - | @大工房 H-8 | T npc.237.Vladinek = npc:Vladinek@大工房 H-8
g07 examine - | ビビキー湾のプルゴノルゴ島(F-9)のWeathered Boatを調べる | - | @ビビキー湾 F-9 #2 | T obj.4.Weathered_Boat = obj:Weathered Boat@ビビキー湾 F-9 #2
g08 fight - | 出てきたNM「Rohemolipaud」と戦う | イーグルアイを使い、HPが減るとカモフラージュで逃げて戦いが終わる。進められるのは湧かせた1人だけで、次は3分待つ。 | @ビビキー湾 F-9 #2 | T mob.4.Rohemolipaud = mob:Rohemolipaud@ビビキー湾 F-9 #2
g09 examine - | もう一度Weathered Boatを調べ、デラックスカービンをもらう | 「はい」を選ぶと称号ももらえる。 | @ビビキー湾 F-9 #2 | T obj.4.Weathered_Boat
g10 talk - | ラバオのZoribohに話して完了 | - | @ラバオ F-6 | T npc.247.Zoriboh
