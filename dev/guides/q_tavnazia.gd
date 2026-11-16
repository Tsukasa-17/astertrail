# タブナジア地下壕のクエスト（0.1.115〜）。MAP1 が上の階、MAP2 が入口のある階

@ quest.tavnazia.001 https://wiki.ffo.jp/html/11564.html
Q Knocking on Forbidden Doors | しとやかな傀儡 | no | T npc.26.Enaremand = npc:Enaremand@タブナジア地下壕 J-7 #1
RW key_item:可動関節図版集
RW other:マウラでマネキンのポーズを変えてもらえる（200ギル）
LK quest:「微笑みの模像」クリア（終えてから地球時間で1分待つ）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Knocking_on_Forbidden_Doors;Fame=Other、FLevel は空。Enaremand は (J-7)、Chemioue は (J-6)。Wooden Ladder は フォミュナ水道 MAP2 (C-9)、古の芥の香の???は ミザレオ海岸(I-6)、滝の下の???は(F-4)、Alsha。図版集はマウラの Fyi Chalmwoh に渡す（FFXIclopedia も同じマス）
g01 talk - | タブナジア地下壕MAP1(J-7)のEnaremandに話して受ける | - | @タブナジア地下壕 J-7 #1 | T npc.26.Enaremand
g02 talk - | 一段下(J-6)のChemioueに話して呪術師の話を聞く | ちがう話になったら、もう一度話す。 | @タブナジア地下壕 J-6 #1 | T npc.26.Chemioue = npc:Chemioue@タブナジア地下壕 J-6 #1
g03 examine - | フォミュナ水道MAP2(C-9)のWooden Ladderを調べてイベント | - | @フォミュナ水道 C-9 #2 | T obj.27.Wooden_Ladder = obj:Wooden Ladder@フォミュナ水道 C-9 #2
g04 examine - | ミザレオ海岸(I-6)の川の下流の???を調べ、だいじなもの「古の芥の香」を手に入れる | - | @ミザレオ海岸 I-6 | T obj.25.???_I-6 = obj:???@ミザレオ海岸 I-6
g05 examine - | ミザレオ海岸(F-4)の滝つぼの???を調べてイベント | - | @ミザレオ海岸 F-4 | T obj.25.???_F-4 = obj:???@ミザレオ海岸 F-4 | K 古の芥の香
g06 fight - | もう一度???を調べ、出てきたマネキン「Alsha」を倒す | HPが減るとファイアIIで自分を倒そうとする。自分でとどめを刺せなかったらエリアを出てやり直し。 | @ミザレオ海岸 F-4 | T mob.25.Alsha = mob:Alsha@ミザレオ海岸 F-4
g07 examine - | もう一度???を調べてイベント、だいじなもの「可動関節図版集」をもらって完了 | - | @ミザレオ海岸 F-4 | T obj.25.???_F-4
g08 talk - | マウラのFyi Chalmwohに話すと、200ギルでマネキンのポーズを変えてもらえる | - | @マウラ G-8 | T npc.249.Fyi_Chalmwoh | K 可動関節図版集

@ quest.tavnazia.002 https://wiki.ffo.jp/html/7557.html
Q Fly High | その翼、空高く | yes | T npc.26.Ferchinne = npc:Ferchinne@タブナジア地下壕 G-9 #2
RW item:雲消霧散石
LK quest:プロマシアミッション「よりしろ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Fly_High;Fame=Other、FLevel は空。Repeatable=yes。Quest Reqs=Promathia Mission 4-2。Ferchinne は (G-9)、入口のある階（MAP2）の滝と橋のそば。ヒポグリフの尾羽根はリヴェーヌ岩塊群サイトA01・B01のヒポグリフ族が落とす（競売でも買える）。雲消霧散石は Ouryu を地上に降ろす
g01 talk - | タブナジア地下壕MAP2(G-9)の滝のそばのFerchinneに話して受ける | - | @タブナジア地下壕 G-9 #2 | T npc.26.Ferchinne
g02 gather - | リヴェーヌ岩塊群サイトA01・B01のヒポグリフ族を倒して「ヒポグリフの尾羽根」を2本集める | 競売でも買える。 | N ヒポグリフの尾羽根*2
g03 trade - | Ferchinneに「ヒポグリフの尾羽根」2本をトレードし、「雲消霧散石」をもらって完了 | 2本ごとに何度でも替えてもらえる。 | @タブナジア地下壕 G-9 #2 | T npc.26.Ferchinne | N ヒポグリフの尾羽根*2

@ quest.tavnazia.003 https://wiki.ffo.jp/html/12079.html
Q Petals for Parelbriaux | ふたりはいつか | no | T npc.26.Ondieulix = npc:Ondieulix@タブナジア地下壕 I-7 #2
RW item:パワフルロープ
RW title:ちょっと臭う人
LK quest:プロマシアミッション第3章第5節「神を名乗りて」クリア
LK condition:先にChemioueとParelbriauxのイベントを見る
XS BG Wiki;https://www.bg-wiki.com/ffxi/Petals_for_Parelbriaux;Fame=Other、FLevel は空。Quest Reqs=Promathia Mission 3-5。Chemioue (J-6)、Tressia はその隣、Parelbriaux (K-7)、Ondieulix (I-7)。???は ルフェーゼ野(G-6)で、霧の時だけ Baumesel が出る（FFXIclopedia も同じマス。霧は朝の2:00〜7:00ごろ）
g01 talk - | タブナジア地下壕MAP1(J-6)のChemioueに話してイベント | - | @タブナジア地下壕 J-6 #1 | T npc.26.Chemioue = npc:Chemioue@タブナジア地下壕 J-6 #1
g02 talk - | Chemioueの隣のTressiaに話す | - | @タブナジア地下壕 J-6 #1 | T npc.26.Tressia = npc:Tressia@タブナジア地下壕 J-6 #1
g03 talk - | MAP1(K-7)のParelbriauxに話す | 罪狩りの話になったら、(K-10)のDespachiaireに話して「罪狩りたちの舞踏曲」を受けてから、もう一度話す。 | @タブナジア地下壕 K-7 #1 | T npc.26.Parelbriaux = npc:Parelbriaux@タブナジア地下壕 K-7 #1
g04 talk - | MAP2(I-7)のOndieulixに話してイベント、受ける | - | @タブナジア地下壕 I-7 #2 | T npc.26.Ondieulix
g05 examine - | 霧の時に、ルフェーゼ野(G-6)の???を調べる | 霧は朝方に出やすい。 | @ルフェーゼ野 G-6 | T obj.24.???_G-6 = obj:???@ルフェーゼ野 G-6 | W 霧
g06 fight - | 出てきたフライトラップ族NM「Baumesel」を倒す | - | @ルフェーゼ野 G-6 | T mob.24.Baumesel = mob:Baumesel@ルフェーゼ野 G-6
g07 examine - | もう一度???を調べてイベント、だいじなもの「臭いのする葉っぱ」を手に入れる | - | @ルフェーゼ野 G-6 | T obj.24.???_G-6
g08 talk - | タブナジア地下壕のOndieulixに話して完了 | - | @タブナジア地下壕 I-7 #2 | T npc.26.Ondieulix | K 臭いのする葉っぱ

@ quest.tavnazia.004 https://wiki.ffo.jp/html/1471.html
Q X Marks the Spot | スカリーX | no | T npc.26.Despachiaire = npc:Despachiaire@タブナジア地下壕 K-10 #1
RW gil:4000
LK other:プロマシアミッション第3章の途中から受けられる
XS BG Wiki;https://www.bg-wiki.com/ffxi/X_Marks_the_Spot;Fame=Other、FLevel は空。Despachiaire (K-10、K-9 の Walnut Door の奥)、Parelbriaux (K-7)、Odeya (J-10)。フォミュナ水道は MAP1 (F-6) のはしご → MAP2 (J-6) の Iron Gate → (M-8) のはしご → MAP3 (J-9) 北東の??? → 隠し通路 (K-8) の2つ目の Ornate Gate（FFXIclopedia も同じ）
g01 talk - | タブナジア地下壕MAP1(K-10)のDespachiaireに話して受ける | (K-9)のWalnut Doorの奥の部屋にいる。話が進まないときはもう一度話す。 | @タブナジア地下壕 K-10 #1 | T npc.26.Despachiaire
g02 talk - | 同じ階(K-7)のParelbriauxに話す | - | @タブナジア地下壕 K-7 #1 | T npc.26.Parelbriaux
g03 talk - | 同じ階(J-10)のOdeyaに話す | - | @タブナジア地下壕 J-10 #1 | T npc.26.Odeya = npc:Odeya@タブナジア地下壕 J-10 #1
g04 gather - | ルフェーゼ野の大羊族かオーク族から「タブナジア羊レバー」を手に入れる | 落ちにくい。 | @ルフェーゼ野 | N タブナジア羊レバー*1
g05 trade - | Odeyaにタブナジア羊レバーをトレードする | - | @タブナジア地下壕 J-10 #1 | T npc.26.Odeya | N タブナジア羊レバー*1
g06 go - | フォミュナ水道MAP1(F-6)のはしごを上り、MAP2(J-6)のIron Gateを開けて(M-8)のはしごへ進む | Iron Gateは「青銅のカギ」かシーフツールで開く。カギはここのフォモル族が落とす。 | @フォミュナ水道 J-6 #2 | T obj.27.Iron_Gate_J-6 = obj:Iron Gate@フォミュナ水道 J-6 #2
g07 examine - | MAP3の南の通路を進み、(J-9)北東の角の???を調べて隠し扉を開ける | - | @フォミュナ水道 J-9 #3 | T obj.27.???_J-9 = obj:???@フォミュナ水道 J-9 #3
g08 examine - | 隠し通路(K-8)の2つ目のOrnate Gateを調べてイベント | - | @フォミュナ水道 K-8 #3 | T obj.27.Ornate_Gate_K-8 = obj:Ornate Gate@フォミュナ水道 K-8 #3
g09 talk - | タブナジア地下壕のOdeyaに話して完了 | - | @タブナジア地下壕 J-10 #1 | T npc.26.Odeya

@ quest.tavnazia.005 https://wiki.ffo.jp/html/15802.html
Q Elderly Pursuits | 信仰と信頼と | no | T npc.26.Despachiaire
RW item:エレガントリボン
LK quest:プロマシアミッション「そしりを受けつつも」とクエスト「失われた料理」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Elderly_Pursuits;Fame=Other、FLevel は空。Rouva は南サンドリア (I-8)、ギルド桟橋 (F-9) の??? で Para（ジャグナー森林 (E-6) から入る）
g01 talk - | タブナジア地下壕MAP1(K-10)のDespachiaireに話して受ける | - | @タブナジア地下壕 K-10 #1 | T npc.26.Despachiaire
g02 talk - | 南サンドリア(I-8)のRouvaに話す | - | @南サンドリア I-8 | T npc.230.Rouva
g03 examine - | ジャグナー森林(E-6)からギルド桟橋に入り、(F-9)の???を調べる | 中桟橋から歩いてもよい。 | @ギルド桟橋 F-9 | T obj.2.???_F-9 = obj:???@ギルド桟橋 F-9
g04 fight - | 出てきたキノコのNM「Para」を倒す | HPが減ると、技を使うたびに分身が増える。残りHPは一気に削る。 | @ギルド桟橋 F-9 | T mob.2.Para = mob:Para@ギルド桟橋 F-9
g05 examine - | もう一度???を調べ、だいじなもの「サンドリア大聖堂のアミュレット」を手に入れる | - | @ギルド桟橋 F-9 | T obj.2.???_F-9 | K サンドリア大聖堂のアミュレット
g06 talk - | 南サンドリアのRouvaに話す | - | @南サンドリア I-8 | T npc.230.Rouva
g07 talk - | タブナジア地下壕のDespachiaireに話して完了 | - | @タブナジア地下壕 K-10 #1 | T npc.26.Despachiaire

@ quest.tavnazia.006 https://wiki.ffo.jp/html/3939.html
Q In the Name of Science | 古の秘術 | yes | T npc.26.Yurim = npc:Yurim@タブナジア地下壕 J-8 #1
RW item:各種属性帯・各種属性ゴルゲット・サナティヴピアス・リラクシングピアスから1つ
LK quest:プロマシアミッション「古代の園」まで進めている
XS BG Wiki;https://www.bg-wiki.com/ffxi/In_the_Name_of_Science;Fame と FLevel は空、Repeatable=Yes。Yurim は (J-8) の最上階。ピアスはシルバーピアス、帯は銀の帯、ゴルゲットはゴルゲットに、属性チップを添えて渡す
g01 talk - | タブナジア地下壕MAP1(J-8)のYurimに話して受ける | - | @タブナジア地下壕 J-8 #1 | T npc.26.Yurim
g02 trade - | ほしい物に合わせて、「銀の帯」「ゴルゲット」「シルバーピアス」のどれかと属性チップをYurimにトレードする | ここで報酬が決まり、あとから変えられない。氷はクリアチップ、水はブルーチップ。 | @タブナジア地下壕 J-8 #1 | T npc.26.Yurim
g03 talk - | もう一度Yurimに話し、要る品を聞く | アップルパイを渡すとヒントがもらえる。 | @タブナジア地下壕 J-8 #1 | T npc.26.Yurim
g04 gather - | 言われたルモリアの敵の部品（ルミニアン器官など）を集める | エスカ-ル・オンのルミニアンは落とさない。ルモリアで集める。 | @ルモリア
g05 trade - | 集めた品をYurimにトレードして完了 | 終えると、隣のMeretとの交換もできるようになる。 | @タブナジア地下壕 J-8 #1 | T npc.26.Yurim

@ quest.tavnazia.007 https://wiki.ffo.jp/html/4139.html
Q Secrets of Ovens Lost | 失われた料理 | yes | T npc.26.Jonette = npc:Jonette@タブナジア地下壕 G-9 #2
RW item:ミラテテ様言行録
LK quest:プロマシアミッション「流転」とクエスト「タブナジアの商人」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Secrets_of_Ovens_Lost;Fame=Other、FLevel は空、Repeatable=Yes。Jonette (G-9)。??? はフォミュナ水道 MAP3 か礼拝堂 MAP2 に出て、時間で動く
g01 talk - | タブナジア地下壕MAP1(K-10)のDespachiaireに話してイベントを見る | - | @タブナジア地下壕 K-10 #1 | T npc.26.Despachiaire
g02 talk - | MAP2(G-9)のJonetteに話して受ける | 地下水脈のそばにいる。 | @タブナジア地下壕 G-9 #2 | T npc.26.Jonette | > a01,b01
a01 examine - | 【フォミュナ水道】MAP3の(F-7)(F-9)(J-7)(J-9)のどれかにある???を調べ、だいじなもの「タブナジアの料理書」を手に入れる | ???は時間がたつと4か所を移る。途中の扉は青銅のカギかシーフツールで開ける。 | @フォミュナ水道 F-7 #3 | T obj.27.???_Ovens = obj:???@フォミュナ水道 F-7 #3 | K タブナジアの料理書 | R フォミュナ水道 | > g03
b01 examine - | 【礼拝堂】MAP2の(F-11)(H-11)(H-6)(F-6)のどれかにある???を調べ、だいじなもの「タブナジアの料理書」を手に入れる | ???は時間がたつと4か所を移る。妖霧のときはNM「Elel」に注意。 | @礼拝堂 F-11 #2 | T obj.28.???_Ovens = obj:???@礼拝堂 F-11 #2 | K タブナジアの料理書 | R 礼拝堂 | > g03
g03 talk - | タブナジア地下壕のJonetteに話して完了 | - | @タブナジア地下壕 G-9 #2 | T npc.26.Jonette

@ quest.tavnazia.008 https://wiki.ffo.jp/html/2145.html
Q The Big One | 巨大な影の正体 | yes | T npc.26.Travonce = npc:Travonce@タブナジア地下壕 F-9 #2
RW item:ランペール戦記・シンキングミノー・グラスロッドなど
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Big_One_(Quest);Fame=Other、FLevel は空、Repeatable=Yes、Level=45。Travonce (F-9)、13:00〜16:00 に南東の出口からルフェーゼ野へ。釣れる NM は Asrai、Abhac、Vu-Murt、Petrocrab、Cetic Parasite、Ferrocrab、Nakki
g01 talk - | タブナジア地下壕MAP2(F-9)のTravonceに話して受ける | 地下水脈のそばにいる。 | @タブナジア地下壕 F-9 #2 | T npc.26.Travonce
g02 go - | ヴァナ時間13:00〜16:00に、南東のアルタンディゼ門(I-6)からルフェーゼ野へ出る | 出るとTravonceが現れる。制限は30分。 | @タブナジア地下壕 I-6
g03 talk - | 全員がそろってから、ルフェーゼ野のTravonceに話して護衛を始める | Lv45に制限され、フェイスは呼べない。6人まで。 | @ルフェーゼ野 | T npc.24.Travonce = npc:Travonce@ルフェーゼ野
g04 fight - | 吊り橋で釣り上げられたNM「Asrai」を倒す | Travonceは敵がいても進むので、先に道の敵を倒しておく。 | @ルフェーゼ野 | T mob.24.Asrai = mob:Asrai@ルフェーゼ野
g05 fight - | 海岸で釣り上げられたNM「Abhac」「Vu-Murt」を倒す | 道中のオークも倒す。 | @ルフェーゼ野 | T mob.24.Abhac = mob:Abhac@ルフェーゼ野
g06 fight - | ルルーミュ湖で釣り上げられたNM「Petrocrab」「Ferrocrab」「Cetic Parasite」「Nakki」を倒す | 湖のリーチはまわりのリーチとリンクする。 | @ルフェーゼ野 | T mob.24.Nakki = mob:Nakki@ルフェーゼ野
g07 talk - | Travonceに話し、だいじなもの「トラヴォンス護衛依頼完了証」をもらう | - | @ルフェーゼ野 | T npc.24.Travonce | K トラヴォンス護衛依頼完了証
g08 talk - | タブナジア地下壕のTravonceに話して完了 | - | @タブナジア地下壕 F-9 #2 | T npc.26.Travonce

@ quest.tavnazia.009 https://wiki.ffo.jp/html/11563.html
Q Behind the Smile | 微笑みの模像 | no | T npc.26.Enaremand
RW item:マヌカンパンプス
LK quest:マウラのクエスト「呪われた人形」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Behind_the_Smile;Fame=Other、FLevel は空。Enaremand (J-7)、Fyi Chalmwoh はマウラ (G-8)、ギルド桟橋 (I-10) の赤いキノコの上の???、ジャグナー森林 (J-8) から入る（FFXIclopedia も同じ）
g01 talk - | タブナジア地下壕MAP1(J-7)のEnaremandに話して受ける | - | @タブナジア地下壕 J-7 #1 | T npc.26.Enaremand
g02 talk - | マウラ(G-8)の彫金ギルドにいるFyi Chalmwohに話す | - | @マウラ G-8 | T npc.249.Fyi_Chalmwoh = npc:Fyi Chalmwoh@マウラ G-8
g03 examine - | ジャグナー森林(J-8)からギルド桟橋に入り、(I-10)西側の赤いキノコの上の???を調べる | - | @ギルド桟橋 I-10 | T obj.2.???_I-10 = obj:???@ギルド桟橋 I-10
g04 fight - | 出てきたオーク族NM「Bullheaded Grosvez」を倒す | 百烈拳を何度も使い、技を3回続けて使う。 | @ギルド桟橋 I-10 | T mob.2.Bullheaded_Grosvez = mob:Bullheaded Grosvez@ギルド桟橋 I-10
g05 examine - | もう一度???を調べ、だいじなもの「レッドオイル」を手に入れる | - | @ギルド桟橋 I-10 | T obj.2.???_I-10 | K レッドオイル
g06 talk - | タブナジア地下壕のEnaremandに話して完了 | 次は「しとやかな傀儡」。 | @タブナジア地下壕 J-7 #1 | T npc.26.Enaremand

@ quest.tavnazia.010 https://wiki.ffo.jp/html/12080.html
Q A Bitter Past | 愛する君達へ | no | T npc.26.Frescheque = npc:Frescheque@タブナジア地下壕 H-8 #1
RW item:陰陽のローネット
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Bitter_Past;Fame=Other、FLevel は空。Frescheque (H-8)、Raminey (J-7)、Equette (I-9、2F)、ルフェーゼ野 (I-8) の???、Blackbone Frazdiz と Rainbringer Vjatvot（FFXIclopedia も Vjatvot）
g01 talk - | タブナジア地下壕MAP1(H-8)のFreschequeに話して受ける | - | @タブナジア地下壕 H-8 #1 | T npc.26.Frescheque
g02 talk - | 同じ階(J-7)のRamineyに話す | - | @タブナジア地下壕 J-7 #1 | T npc.26.Raminey = npc:Raminey@タブナジア地下壕 J-7 #1
g03 talk - | MAP2(I-9)のEquetteに話してイベント | - | @タブナジア地下壕 I-9 #2 | T npc.26.Equette = npc:Equette@タブナジア地下壕 I-9 #2
g04 examine - | ルフェーゼ野(I-8)の湖のそばの???を調べる | - | @ルフェーゼ野 I-8 | T obj.24.???_I-8 = obj:???@ルフェーゼ野 I-8
g05 fight - | 出てきたオーク族NM「Blackbone Frazdiz」と「Rainbringer Vjatvot」を倒す | Vjatvotは黒魔道士。 | @ルフェーゼ野 I-8 | T mob.24.Blackbone_Frazdiz = mob:Blackbone Frazdiz@ルフェーゼ野 I-8
g06 examine - | もう一度???を調べ、だいじなもの「小さな腕輪」を手に入れる | - | @ルフェーゼ野 I-8 | T obj.24.???_I-8 | K 小さな腕輪
g07 talk - | タブナジア地下壕のFreschequeに話して完了 | 終えたあとEquetteに話すと続きの話がある。 | @タブナジア地下壕 H-8 #1 | T npc.26.Frescheque

@ quest.tavnazia.011 https://wiki.ffo.jp/html/3837.html
Q Uninvited Guests | 招かざる影たち | yes | T npc.26.Justinius = npc:Justinius@タブナジア地下壕 J-6 #1
RW title:帝龍の飛泉調査員
RW item:ランダムで1つ（ミラテテ様言行録が多い）
LK fame:名声ランク1以上（どの地域の名声かは資料にない）
LK quest:プロマシアミッション「猛き者たちよ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Uninvited_Guests;Fame=O、FLevel=1、Repeatable=Yes。Justinius (J-6) 最上階。Mammet-800 は 2 人ごとに 1 体増え、最大 9 体
g01 talk - | タブナジア地下壕MAP1(J-6)のJustiniusに話し、だいじなもの「帝龍の飛泉調査委任状」をもらう | 全員が委任状を持つ。入ると消える。 | @タブナジア地下壕 J-6 #1 | T npc.26.Justinius | K 帝龍の飛泉調査委任状
g02 go - | リヴェーヌ岩塊群サイトB01のホームポイントからSpatial Displacementを通り、帝龍の飛泉のBFに入る | 1〜18人で、Lv制限はない。 | @リヴェーヌ岩塊群サイトB01
g03 fight - | BFでMammet-800を倒す | 2人ごとに1体増え、最大9体。戦闘不能でデスペナルティがある。 | T mob.Mammet-800 = mob:Mammet-800@帝龍の飛泉
g04 talk - | タブナジア地下壕のJustiniusに話して完了 | かばんが満杯だと報酬が選び直される。 | @タブナジア地下壕 J-6 #1 | T npc.26.Justinius

@ quest.tavnazia.012 https://wiki.ffo.jp/html/13424.html
Q The Call of the Sea | 海からの贈り物 | no | T npc.26.Anteurephiaux = npc:Anteurephiaux@タブナジア地下壕 J-8 #1
RW item:メメントマフラー
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Call_of_the_Sea;Fame=Other、FLevel は空。Leporaitceau と Anteurephiaux は (J-8) の3F、Equette (I-9) の2F、ミザレオ海岸 (K-12) の???で Bloody Coffin
g01 talk - | タブナジア地下壕MAP1(J-8)のLeporaitceauに話す | ホームポイント#3が近い。 | @タブナジア地下壕 J-8 #1 | T npc.26.Leporaitceau = npc:Leporaitceau@タブナジア地下壕 J-8 #1
g02 talk - | MAP2(I-9)のEquetteに話す | 坂の下にいる。 | @タブナジア地下壕 I-9 #2 | T npc.26.Equette
g03 talk - | MAP1(J-8)のAnteurephiauxに話して受ける | - | @タブナジア地下壕 J-8 #1 | T npc.26.Anteurephiaux
g04 examine - | ミザレオ海岸(K-12)の???を調べる | - | @ミザレオ海岸 K-12 | T obj.25.???_K-12 = obj:???@ミザレオ海岸 K-12
g05 fight - | 出てきたクラブ族NM「Bloody Coffin」を倒す | ダメージをほとんど通さない。魔法や技の詠唱中だけ通るので、そこへ強いWSを当てる。 | @ミザレオ海岸 K-12 | T mob.25.Bloody_Coffin = mob:Bloody Coffin@ミザレオ海岸 K-12
g06 examine - | もう一度???を調べ、だいじなもの「追憶の巻き貝」を手に入れる | - | @ミザレオ海岸 K-12 | T obj.25.???_K-12 | K 追憶の巻き貝
g07 talk - | タブナジア地下壕のAnteurephiauxに話す | - | @タブナジア地下壕 J-8 #1 | T npc.26.Anteurephiaux
g08 talk - | MAP2のEquetteに話して完了 | - | @タブナジア地下壕 I-9 #2 | T npc.26.Equette

@ quest.tavnazia.013 https://wiki.ffo.jp/html/8814.html
Q Paradise, Salvation, and Maps | 神の御許に | no | T npc.26.Nivorajean = npc:Nivorajean@タブナジア地下壕 I-9 #2
RW key_item:礼拝堂地図
RW exp:2000
RW gil:2000
LK quest:プロマシアミッション「礼拝の意味」で礼拝堂に行っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Paradise,_Salvation,_and_Maps;Fame=o、FLevel=unknown/none（用語辞典にも名声の記載なし）。Nivorajean (I-9)。礼拝堂の宝箱は専用のカギで開ける。答えが合えば翌日0時を過ぎて報酬
g01 talk - | タブナジア地下壕MAP2(I-9)のNivorajeanに話して受ける | - | @タブナジア地下壕 I-9 #2 | T npc.26.Nivorajean
g02 examine - | 礼拝堂でTreasure Chestを探して開け、だいじなもの「礼拝堂設計図の切れ端」を手に入れる | 礼拝堂の宝箱を開けるカギがいる。見つけた場所のマスを覚えておく。 | @礼拝堂 | T obj.28.Treasure_Chest = obj:Treasure Chest@礼拝堂 | K 礼拝堂設計図の切れ端
g03 talk - | Nivorajeanに話し、宝箱があった場所を答える | まちがえると宝箱を開けるところからやり直し。 | @タブナジア地下壕 I-9 #2 | T npc.26.Nivorajean
g04 talk - | ヴァナ時間0時を過ぎてから、もう一度Nivorajeanに話して完了 | - | @タブナジア地下壕 I-9 #2 | T npc.26.Nivorajean

@ quest.tavnazia.014 https://wiki.ffo.jp/html/6102.html
Q Unforgiven | 秘めたる想い | no | T npc.26.Elysia = npc:Elysia@タブナジア地下壕 G-10 #2
RW key_item:タブナジア群島地図
RW exp:2000
RW gil:2000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Unforgiven;Fame=Other、FLevel は空。Elysia (G-10)、???は 3F の (K-9) で Walnut Door のそばの柱の裏、Pradiulot (H-9)
g01 talk - | タブナジア地下壕MAP2(G-10)のElysiaに話して受ける | - | @タブナジア地下壕 G-10 #2 | T npc.26.Elysia
g02 examine - | MAP1(K-9)のWalnut Doorのそばの柱の裏の???を調べ、だいじなもの「純白の髪飾り」を手に入れる | 2回調べることがある。 | @タブナジア地下壕 K-9 #1 | T obj.26.???_K-9 = obj:???@タブナジア地下壕 K-9 #1 | K 純白の髪飾り
g03 talk - | Elysiaに話してイベント | - | @タブナジア地下壕 G-10 #2 | T npc.26.Elysia
g04 talk - | MAP2(H-9)のPradiulotに話して完了 | このあとElysiaとPradiulotにもう一度話すと続きの話がある。 | @タブナジア地下壕 H-9 #2 | T npc.26.Pradiulot = npc:Pradiulot@タブナジア地下壕 H-9 #2

@ quest.tavnazia.015 https://wiki.ffo.jp/html/8813.html
Q Go! Go! Gobmuffin! | 空に浮かぶ岩塊 | no | T npc.26.Epinolle = npc:Epinolle@タブナジア地下壕 F-8 #2
RW key_item:リヴェーヌ岩塊群地図
RW exp:2000
RW gil:2000
LK quest:プロマシアミッション「猛き者たちよ」まで進め、リヴェーヌ岩塊群サイトB01に一度入っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Go!_Go!_Gobmuffin!;Fame=Other、FLevel は空、Quest Reqs=Promathia Mission 4-2。(J-6) の島に着くと NM 3 体。FFXIclopedia の道順は (M-9) → (K-8) → (K-7) → (J-6)、名前は Spell Spitter Spiluspok（BG Wiki は Spilospok）
g01 talk - | タブナジア地下壕MAP2(F-8)のEpinolleに話して受ける | ノマドモーグリのそばにいる。 | @タブナジア地下壕 F-8 #2 | T npc.26.Epinolle
g02 go - | リヴェーヌ岩塊群サイトB01で、Spatial Displacementを(M-9)から(L-10)へ、(K-8)から(K-7)へと進む | - | @リヴェーヌ岩塊群サイトB01 K-7
g03 go - | (K-7)で準備してから、(J-6)行きのSpatial Displacementに入る | 着いたとたんにNMが出るので、全員そろって入る。 | @リヴェーヌ岩塊群サイトB01 K-7
g04 fight - | 着いた島で出るモブリン族NM3体を倒す | Spell Spitter Spiluspok、Chemical Cook Chemachiq、Book Browser Bokabraq。スリプガやフリーズに注意。 | @リヴェーヌ岩塊群サイトB01 J-6 | T mob.29.Spell_Spitter_Spiluspok = mob:Spell Spitter Spiluspok@リヴェーヌ岩塊群サイトB01 J-6
g05 talk - | タブナジア地下壕のEpinolleに話して完了 | - | @タブナジア地下壕 F-8 #2 | T npc.26.Epinolle

@ quest.tavnazia.016 https://wiki.ffo.jp/html/1475.html
Q Tango with a Tracker | 罪狩りたちの舞踏曲 | no | T npc.26.Despachiaire
RW gil:10000
RW title:決闘の勝利者
LK quest:プロマシアミッション「武士道とは」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Tango_with_a_Tracker;Fame=Other、FLevel は空。Quest Reqs=Promathia Mission 7-5。千骸谷の Dark Miasma で BF、6人・30分、Lv制限なし、フェイス不可。Shikaree X（獣/忍）とウサギ、Shikaree Y（暗/モ）
g01 talk - | タブナジア地下壕MAP1(K-10)のDespachiaireに話し、だいじなもの「スカリーXからの挑戦状」をもらう | この時点ではクエストの一覧に出ない。 | @タブナジア地下壕 K-10 #1 | T npc.26.Despachiaire | K スカリーXからの挑戦状
g02 go - | アットワ地溝の先の千骸谷へ行き、Dark MiasmaでBF「罪狩りたちの舞踏曲」に入る | 6人・30分で、Lv制限はない。フェイスは呼べない。各自が挑戦状を持つ。 | @アットワ地溝
g03 fight - | Shikaree X、Shikaree Y、Xのウサギを倒して完了 | ウサギは眠らず、Xを倒しても消えない。2人は連携を狙ってくる。 | T mob.Shikaree_X = mob:Shikaree X@千骸谷

@ quest.tavnazia.017 https://wiki.ffo.jp/html/1476.html
Q Requiem of Sin | 罪狩りたちの鎮魂歌 | yes | T npc.26.Despachiaire
RW title:正義の勝利者
RW item:宝箱から（Ｘナイフ・Ｙサイズ・Ｚトライデント・素材など）
LK quest:クエスト「罪狩りたちの舞踏曲」とプロマシアミッション後日談「メーガスの名は永遠に」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Requiem_of_Sin;Fame=Other、FLevel は空、Repeatable=Yes。Quest Reqs=Promathia Mission 8-4。2回目からは Letter from the Mithran Trackers。Shikaree X（獣/忍）とウサギ、Y（暗/モ）、Z（竜/白）と子竜
g01 talk - | タブナジア地下壕MAP1(K-10)のDespachiaireに話し、だいじなもの「スカリーYからの挑戦状」をもらう | 2回目からは「3姉妹からの招待状」。コンクェストの集計ごとにできる。 | @タブナジア地下壕 K-10 #1 | T npc.26.Despachiaire | K スカリーYからの挑戦状
g02 go - | 千骸谷のDark MiasmaでBF「罪狩りたちの鎮魂歌」に入る | 6人・30分で、Lv制限はない。フェイスは呼べない。 | @アットワ地溝
g03 fight - | Shikaree X、Y、Zとウサギ・子竜を倒す | ペットは眠らない。まん中のZをねらうと範囲で3人を巻き込める。 | T mob.Shikaree_Z = mob:Shikaree Z@千骸谷
g04 examine - | 出てきた宝箱を開けて完了 | 武器が出ることはまれ。 | T obj.Treasure_Chest_Sin = obj:Treasure Chest@千骸谷

@ quest.tavnazia.018 https://wiki.ffo.jp/html/15804.html
Q In Search of the Truth | 誠実なる予告を | no | T npc.26.Tressia
RW item:グラマリーケープ
LK quest:プロマシアミッション「よりしろ」まで進めている
XS BG Wiki;https://www.bg-wiki.com/ffxi/In_Search_of_the_Truth;Fame=Other、FLevel は空。Quest Reqs=Promathia Mission 3-5 クリア。並べる順は Fouagine、Zadant、Raminey、Noam か Fouagine、Zadant、Noam、Raminey。報告の場所は 1:I-8、2:H-8、3:G-9、4:J-7。???は Noam の横 (G-9) → (G-7) → (G-8) → (H-8) → (H-8) 右下
g01 talk - | タブナジア地下壕MAP1(J-6)の自警団のTressiaに話して受ける | - | @タブナジア地下壕 J-6 #1 | T npc.26.Tressia
g02 talk - | MAP1(I-9)のFouagineに話してイベント | 4人は順不同。 | @タブナジア地下壕 I-9 #1 | T npc.26.Fouagine = npc:Fouagine@タブナジア地下壕 I-9 #1
g03 talk - | MAP2(G-9)のNoamに話してイベント | - | @タブナジア地下壕 G-9 #2 | T npc.26.Noam = npc:Noam@タブナジア地下壕 G-9 #2
g04 talk - | (H-8)の下の階へ降りる坂のZadantに話してイベント | - | @タブナジア地下壕 H-8 | T npc.26.Zadant = npc:Zadant@タブナジア地下壕 H-8
g05 talk - | MAP1(J-7)のRamineyに話してイベント | - | @タブナジア地下壕 J-7 #1 | T npc.26.Raminey
g06 talk - | Tressiaに話し、4人を「Fouagine、Zadant、Raminey、Noam」の順に選ぶ | 外れたら「Fouagine、Zadant、Noam、Raminey」。正解は毎回変わる。まちがえても選び直せる。 | @タブナジア地下壕 J-6 #1 | T npc.26.Tressia
g07 talk - | そばのMengrenauxに話して報告1と2を、Chemioueに話して報告3と4を聞く | - | @タブナジア地下壕 J-6 #1 | T npc.26.Mengrenaux = npc:Mengrenaux@タブナジア地下壕 J-6 #1
g08 talk - | Tressiaに話し、場所を報告1は(I-8)、2は(H-8)、3は(G-9)、4は(J-7)と答える | - | @タブナジア地下壕 J-6 #1 | T npc.26.Tressia
g09 examine - | MAP2(G-9)のNoamの横の???から順に、(G-7)、(G-8)、(H-8)、(H-8)右下の???を調べる | 最初の???で狐狸の秘壷を手に入れる。坂を上がり、通路を進んで順にたどる。 | @タブナジア地下壕 G-9 #2 | T obj.26.???_G-9 = obj:???@タブナジア地下壕 G-9 #2
g10 talk - | Tressiaに話す | - | @タブナジア地下壕 J-6 #1 | T npc.26.Tressia
g11 talk - | MAP2(I-7)のOndieulixに話して報酬をもらい完了 | ホームポイント#1のそばにいる。 | @タブナジア地下壕 I-7 #2 | T npc.26.Ondieulix
