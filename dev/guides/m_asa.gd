# シャントット帝国の陰謀（0.1.123〜）。基礎シートのミッション一覧 271〜286 行。id の番号はシートの行−270。order は id と同じ（始めるにはだけ 999）
@ mission.asa.001 https://wiki.ffo.jp/html/39144.html
Q To Begin ASA... | 「シャントット帝国の陰謀」を始めるには…… | no | T obj.239.Tales_Beginning = obj:Tales' Beginning@ウィンダス石の区 C-6 D-6
MN - 999
LK condition:ウィンダス石の区に入って「後にする」を選んだ
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_1;「後にする」を選ぶと一覧に出て、ウィンダス石の区 C-6/D-6 の Tales' Beginning を調べると始まる。本は後にした人にしか見えない
g01 examine - | ウィンダス石の区(C-6/D-6)のTales' Beginningを調べてオープニングのイベントを見ると完了 | 「後にする」を選んだときだけ一覧に出る。本は後にした人にしか見えない。このあと「シャントット帝国の陰謀」になる。 | @ウィンダス石の区 C-6 D-6 | T obj.239.Tales_Beginning

@ mission.asa.002 https://wiki.ffo.jp/html/16530.html
Q A Shantotto Ascension | シャントット帝国の陰謀 | no
MN ASA1 2
LK condition:追加シナリオ「シャントット帝国の陰謀」を持っている、Lv10以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_1;Lv10以上でウィンダス森の区か水の区からウィンダス石の区に入るとイベント。モグハウスから出たときなどは起きない（FFXIclopedia にこの節の手順はない）
g01 go - | Lv10以上でウィンダス森の区か水の区からウィンダス石の区に歩いて入り、イベントを見ると完了 | モグハウスから出たときやワープで来たときは起きない。「後にする」を選んだときは、ウィンダス石の区(C-6/D-6)のTales' Beginningを調べる。終わると「不吉な予感」になる。 | @ウィンダス石の区

@ mission.asa.003 https://wiki.ffo.jp/html/18193.html
Q Burgeoning Dread | 不吉な予感 | no
MN ASA2 3
LK condition:前節「シャントット帝国の陰謀」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_2;ウィンダスの門から東サルタバルタか西サルタバルタに出るとイベント。言われる呪符キットの種類を覚えておく（FFXIclopedia も同じ。チョコボを借りたとき・アウトポストのワープ・タロンギ大峡谷から入ったときは起きない）
g01 go - | ウィンダスの門から東サルタバルタか西サルタバルタに出て、イベントを見ると完了 | チョコボを借りて出たとき、アウトポストのワープ、タロンギ大峡谷から入ったときは起きない。イベントで言われる呪符キットの種類を覚えておく。 | @東サルタバルタ

@ mission.asa.004 https://wiki.ffo.jp/html/18206.html
Q That Which Curdles Blood | 謎の召集令状 | no
MN ASA3 4
RW key_item:ドルチェ特製・灼熱のお札
RW key_item:ドルチェ特製・海流のお札
RW key_item:ドルチェ特製・突風のお札
RW key_item:ドルチェ特製・雷鳴のお札
RW key_item:ドルチェ特製・凍結のお札
RW key_item:ドルチェ特製・震動のお札
LK condition:前節「不吉な予感」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_3;呪符キットは沈黙・睡眠・毒・暗闇のどれか。Padded Box（土・Bast Parchment 2・Inferior Cocoon、または Woodworking Kit 5）、Fine Parchment 2（闇・Parchment・Pumice Stone）、Enchanted Ink 2（闇・Black Ink・Magicked Blood）と薬を土のクリスタルで合成。錬金術10くらいがよい。キットは本人が合成する。クフィム島 H-7 の Trodden Snow にトレード（FFXIclopedia も同じ。6枚のお札はこの節の報酬）
g01 gather - | 合成で「化粧箱」を1つ、「上質な羊皮紙」を2枚、「魔法のインク」を2つ作る | 化粧箱は土のクリスタル・Bast Parchment 2枚・Inferior Cocoon（木工のキットでも作れる）。上質な羊皮紙は闇のクリスタル・Parchment・Pumice Stone。魔法のインクは闇のクリスタル・Black Ink・Magicked Blood。ここまではほかの人に作ってもらってもよい。
g02 gather - | 土のクリスタル・上質な羊皮紙2枚・魔法のインク2つ・化粧箱と、言われた薬（沈黙薬・昏睡薬・毒薬・暗闇薬のどれか）で、自分で呪符キットを合成する | 種類を忘れたらウィンダス港(E-7)の口の院のKuroido-Moidoに聞く。フィールドのGoblin Footprintが言う種類はあてにならない。失敗しやすいので、錬金術を10くらいまで上げるか材料を多めに。 | @ウィンダス港 E-7 | N 化粧箱,上質な羊皮紙,魔法のインク
g03 trade - | クフィム島(H-7)の池の中のTrodden Snowに呪符キットをトレードしてイベントを見ると完了 | 6枚のお札をもらう。 | @クフィム島 H-7 | T obj.126.Trodden_Snow = obj:Trodden Snow@クフィム島 H-7

@ mission.asa.005 https://wiki.ffo.jp/html/18208.html
Q Sugar-coated Directive | 甘美なる指令 | no | T obj.126.Trodden_Snow
MN ASA4 5
RW gil:3,000～50,000ギル
LK condition:前節「謎の召集令状」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_4;6つの回廊のプロトクリスタルのうち3つ以上で BF「Sugar-coated Directive」。弱い召喚獣はアストラルフロウを5回使うまで倒れない。フェイス不可。勝ったらもう一度調べてお札を貼り台紙をもらう。台紙3枚 3,000・4枚 10,000・5枚 30,000・6枚 50,000ギル（FFXIclopedia も同じ。回廊はイフリートの釜・フェ・イン・テリガン岬・ボヤーダ樹・怨念洞・流砂洞）
g01 examine - | クフィム島(H-7)のTrodden Snowを調べてイベントを見る | お札6枚は前の節でもらっている。 | @クフィム島 H-7 | T obj.126.Trodden_Snow
g02 fight - | 6つの回廊のうち3つ以上で、プロトクリスタルを2回調べてBF「甘美なる指令」に入り、召喚獣に勝つ | 灼熱の回廊はイフリートの釜、凍結の回廊はフェ・イン、突風の回廊はテリガン岬、雷鳴の回廊はボヤーダ樹、海流の回廊は怨念洞、震動の回廊は流砂洞。召喚獣は大きな技を5回使うまで倒れない。フェイスは呼べず、入ると強化が消える。 | K ドルチェ特製・灼熱のお札,ドルチェ特製・海流のお札,ドルチェ特製・突風のお札,ドルチェ特製・雷鳴のお札,ドルチェ特製・凍結のお札,ドルチェ特製・震動のお札
g03 examine - | 勝つたびにプロトクリスタルをもう一度調べてお札を貼り、台紙をもらう | エリアを出てしまっても、戻って調べればもう一度戦わずに貼れる。
g04 examine - | 台紙を3枚以上持ってクフィム島(H-7)のTrodden Snowを調べてイベントを見ると完了 | 台紙の数でギルが変わる（3枚 3,000、4枚 10,000、5枚 30,000、6枚 50,000）。 | @クフィム島 H-7 | T obj.126.Trodden_Snow

@ mission.asa.006 https://wiki.ffo.jp/html/18209.html
Q Enemy of the Empire (I) | アルド暗殺計画　その1 | no | T npc.252.Andrause = npc:Andrause@ノーグ I-8
MN ASA5 6
RW key_item:黒革の帳面
LK condition:前節「甘美なる指令」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_5;ノーグ I-8 の Andrause に海蛇の岩窟の敵3種を言われ、Soultrapper と Blank Soul Plate 12枚を800ギルで買える（次は日本時間0時のあと）。海蛇の岩窟の敵だけ。Soul Plate を1枚ずつトレードして Black book。グスタフの洞門 F-10 の Outcropping でイベント（FFXIclopedia も同じ）
g01 talk - | ノーグ(I-8)のAndrauseに話し、海蛇の岩窟の3種類の敵を言われる | 敵はランダム。銀・ミスリル・金の獣人貨の扉の奥の敵のこともある。 | @ノーグ I-8 | T npc.252.Andrause
g02 talk - | Andrauseから獣写器と獣影板1ダースを800ギルで買う | 一度買うと、次は日本時間の0時を過ぎるまで買えない。 | @ノーグ I-8 | T npc.252.Andrause
g03 gather - | 海蛇の岩窟で言われた敵を獣写器で写して、封獣板を作る | 獣写器を遠隔に、獣影板を矢弾に付けて、アイテムから使う。インビジ・スニーク中は使えない。失敗したら写し直す。ほかのエリアの同じ名前の敵ではだめ。 | @海蛇の岩窟
g04 trade - | 封獣板を1枚ずつAndrauseにトレードして、だいじなもの「黒革の帳面」をもらう | 封獣板はほかの人が写したものでもよい。 | @ノーグ I-8 | T npc.252.Andrause
g05 examine - | グスタフの洞門(F-10)のOutcroppingを調べてイベントを見ると完了 | テリガン岬の入口の近く。 | @グスタフの洞門 F-10 | T obj.212.Outcropping = obj:Outcropping@グスタフの洞門 F-10 | K 黒革の帳面

@ mission.asa.007 https://wiki.ffo.jp/html/18189.html
Q Enemy of the Empire (II) | アルド暗殺計画　その2 | no | T obj.212.Outcropping
MN ASA6 7
RW key_item:サボテンダー座のカギ
RW exp:500
LK condition:前節「アルド暗殺計画　その1」クリア、だいじなもの「黒革の帳面」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_6;Outcropping をもう一度調べるとその場の戦い。Renfred・Bompupu・Gorattz の3人で、分身が出る。フェイス不可。帳面は始めると消える。勝つと Cactuar key（FFXIclopedia も同じ。経験値500）
g01 examine - | グスタフの洞門(F-10)のOutcroppingをもう一度調べて、その場の戦いを始める | 黒革の帳面は戦いが始まると消える。負けたら写すところからやり直し。強化は消えない。 | @グスタフの洞門 F-10 | T obj.212.Outcropping | K 黒革の帳面
g02 defeat - | 天晶堂の3人のRenfred・Bompupu・Gorattzを倒す | フェイスは呼べない。はじめは分身ばかりで、しばらくすると本物を狙えるようになる。離れすぎると戦いが終わってしまう。 | @グスタフの洞門 F-10
g03 examine - | もう一度Outcroppingを調べてイベントを見ると完了 | イベントが止まったら、ログインし直してから調べる。 | @グスタフの洞門 F-10 | T obj.212.Outcropping

@ mission.asa.008 https://wiki.ffo.jp/html/18210.html
Q Sugar-coated Subterfuge | 甘美なる企み | no
MN ASA7 8
LK condition:前節「アルド暗殺計画　その2」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_7;ジュノ下層 J-8 の天晶堂の中の Aldo に話すとイベント（FFXIclopedia も同じ。座標なし）
g01 talk - | ジュノ下層(J-8)の天晶堂の中のAldoに話してイベントを見ると完了 | - | @ジュノ下層 J-8 | T npc.245.Aldo

@ mission.asa.009 https://wiki.ffo.jp/html/18217.html
Q Shantotto in Chains | 囚われのシャントット | no | T obj.122.Ensorcelled_Door = obj:Ensorcelled Door@ロ・メーヴ B-10
MN ASA8 9
LK condition:前節「甘美なる企み」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_8;ロ・メーヴ B-10 の Ensorcelled Door を調べてから6体のNMで欠片。Lode Golem E-9/10、Fired Urn K-9/10、Steely Weapon G-10/11（FFXIclopedia は G-10〜I-11）、聖地ジ・タ（17:00〜7:00）の Holey Horror H-8、Skeleton Scuffler F-8、Blest Bones F-7（FFXIclopedia は E/F-7）。パーティなら全員に出る。NMは数分で消え、2分ほどでまた出る
g01 examine - | ロ・メーヴ(B-10)のEnsorcelled Doorを調べる | 先に調べておかないと、NMを倒しても欠片が出ない。イベントはない。 | @ロ・メーヴ B-10 | T obj.122.Ensorcelled_Door
g02 defeat - | ロ・メーヴ(E-9/E-10)のLode Golemを倒して、だいじなもの「ブルーチップの欠片」を手に入れる | 氷・水・土・闇の魔法でしかダメージが入らない。 | @ロ・メーヴ E-9 E-10 | T mob.122.Lode_Golem = mob:Lode Golem@ロ・メーヴ E-9 E-10
g03 defeat - | ロ・メーヴ(K-9/K-10)のFired Urnを倒して、だいじなもの「パープルチップの欠片」を手に入れる | 斬撃でしかダメージが入らない。 | @ロ・メーヴ K-9 K-10 | T mob.122.Fired_Urn = mob:Fired Urn@ロ・メーヴ K-9 K-10
g04 defeat - | ロ・メーヴ(G-10～I-11)のSteely Weaponを倒して、だいじなもの「イエローチップの欠片」を手に入れる | 遠隔攻撃でしかダメージが入らない。 | @ロ・メーヴ G-10 G-11 H-11 I-11 | T mob.122.Steely_Weapon = mob:Steely Weapon@ロ・メーヴ G-10 G-11 H-11 I-11
g05 defeat - | 聖地ジ・タ(H-8)のHoley Horrorを倒して、だいじなもの「グリーンチップの欠片」を手に入れる | ヴァナ時間の17:00～7:00だけ出る。突き（遠隔は除く）でしかダメージが入らない。 | @聖地ジ・タ H-8 | T mob.121.Holey_Horror = mob:Holey Horror@聖地ジ・タ H-8
g06 defeat - | 聖地ジ・タ(F-8)のSkeleton Scufflerを倒して、だいじなもの「レッドチップの欠片」を手に入れる | ヴァナ時間の17:00～7:00だけ出る。打撃でしかダメージが入らない。 | @聖地ジ・タ F-8 | T mob.121.Skeleton_Scuffler = mob:Skeleton Scuffler@聖地ジ・タ F-8
g07 defeat - | 聖地ジ・タ(E-7/F-7)のBlest Bonesを倒して、だいじなもの「クリアチップの欠片」を手に入れる | ヴァナ時間の17:00～7:00だけ出る。風・雷・火・光の魔法でしかダメージが入らない。 | @聖地ジ・タ E-7 F-7 | T mob.121.Blest_Bones = mob:Blest Bones@聖地ジ・タ E-7 F-7
g08 examine - | 6つの欠片を持ってロ・メーヴ(B-10)のEnsorcelled Doorを調べてイベントを見ると完了 | イベントが止まったら、ログインし直してから調べる。 | @ロ・メーヴ B-10 | T obj.122.Ensorcelled_Door | K ブルーチップの欠片,パープルチップの欠片,イエローチップの欠片,グリーンチップの欠片,レッドチップの欠片,クリアチップの欠片

@ mission.asa.010 https://wiki.ffo.jp/html/18218.html
Q Fountain of Trouble | くじけ！甘美なる陰謀 | no
MN ASA9 10
LK condition:前節「囚われのシャントット」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_9;トライマライ水路の光る ??? で8属性の sap のどれか1つ以上。闇は1枚目 F-8 でホームポイント#1の近く。ほかは場所が動く（FFXIclopedia も同じ）。満月の泉の Moon Spiral でイベント
g01 examine - | トライマライ水路の光る???を調べて、だいじなもの「大樹の星屑」を1つ以上集める | 満月の泉の入口の前(F-8)の「大樹の星屑・闇」がホームポイント#1から近い。8つ全部あると次の戦いが楽になる。ほかの星屑は場所が動く。 | @トライマライ水路 F-8 #1
g02 examine - | 満月の泉のMoon Spiralを調べてイベントを見ると完了 | 星屑を1つも持っていないとイベントにならない。 | @満月の泉 | T obj.満月の泉.Moon_Spiral = obj:Moon Spiral@満月の泉

@ mission.asa.011 https://wiki.ffo.jp/html/18242.html
Q Battaru Royale | クローン・タルタル部隊 | no | T obj.満月の泉.Moon_Spiral
MN ASA10 11
RW key_item:チョコボ座のカギ
RW exp:700
LK condition:前節「くじけ！甘美なる陰謀」クリア、だいじなもの「大樹の星屑」を1つ以上持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_10;Moon Spiral をもう一度調べて BF「Battaru Royale」。8属性のクローン8体。HP50%ほどで召喚獣を呼んでアストラルフロウ。フェイス可。勝つと Chocobo key（FFXIclopedia も同じ。30分・経験値700・入ると強化が消える）
g01 fight - | 満月の泉のMoon Spiralをもう一度調べてBFに入り、8体のクローンに勝つと完了 | 30分。フェイスを呼べる。入ると強化が消え、星屑も消える。HPが半分ほどになると召喚獣を呼んで大きな技を使う。星屑の効果は最初に入った人の分で決まる。負けると星屑を集め直す。 | @満月の泉 | T obj.満月の泉.Moon_Spiral

@ mission.asa.012 https://wiki.ffo.jp/html/18243.html
Q Romancing the Clone | ふたりがちからを合わせたら | no
MN ASA11 12
LK condition:前節「クローン・タルタル部隊」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_11;ジュノ下層 J-8 の天晶堂の中の Aldo に話すとイベント（FFXIclopedia も J-8）
g01 talk - | ジュノ下層(J-8)の天晶堂の中のAldoに話してイベントを見ると完了 | - | @ジュノ下層 J-8 | T npc.245.Aldo

@ mission.asa.013 https://wiki.ffo.jp/html/18245.html
Q Sisters in Arms | ストップ！ダブル・シャントット | no
MN ASA12 13
LK condition:前節「ふたりがちからを合わせたら」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_12;ウガレピ寺院と怨念洞の光る ??? で Tablet of Hexes 16枚。寺院 1枚目 F-10・F-8、2枚目 F-8・G-10・J-11・I-8。怨念洞 1枚目 E-5・H-6・J-9・E-10・F-11・K-11・J-13、3枚目 F-9、2枚目 L-13・H-9（FFXIclopedia も同じ。番号は FFXIclopedia の順）。1枚あれば次の BF に入れる。生贄の間の Mahogany Door でイベント
g01 gather - | ウガレピ寺院の光る???を調べて「呪いの古代文字」の1～6画目を集める（1画目は2枚目 G-10、2画目は2枚目 F-8、3画目は1枚目 F-10、4画目は1枚目 F-8、5画目は2枚目 J-11、6画目は2枚目 I-8） | 1つでもあれば次の戦いに入れる。全部そろうと次の戦いがとても楽になる。 | @ウガレピ寺院
g02 gather - | 怨念洞の光る???を調べて7～16画目を集める（7画目は1枚目 J-13、8画目は1枚目 E-5、9画目は1枚目 K-11、10画目は1枚目 E-10、11画目は1枚目 J-9、12画目は1枚目 F-11、13画目は1枚目 H-6、14画目は3枚目 F-9、15画目は2枚目 H-9、16画目は2枚目 L-13） | 寺院から怨念洞へは「魂の絵筆」、生贄の間の前の扉には「消えたランタン」に灯した火が4つ要る。生贄の間の先のホームポイントがあれば要らない。 | @怨念洞
g03 examine - | 生贄の間のMahogany Doorを調べてイベントを見ると完了 | - | @生贄の間 | T obj.生贄の間.Mahogany_Door

@ mission.asa.014 https://wiki.ffo.jp/html/18187.html
Q Project: Shantottofication | 呪われる世界 | no | T obj.生贄の間.Mahogany_Door
MN ASA13 14
RW key_item:トンベリ座のカギ
RW exp:750
LK condition:前節「ストップ！ダブル・シャントット」クリア、だいじなもの「呪いの古代文字」を1つ以上持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_13;Mahogany Door をもう一度調べて BF。相手は D. Shantotto と Shantotto。古代文字は入ると消えて、それぞれ強化になる。HP50%で連携の時間になり、そのあいだ倒れない。勝つと Tonberry key（FFXIclopedia にこの節のページはない）
g01 fight - | 生贄の間のMahogany Doorをもう一度調べてBFに入り、D. ShantottoとShantottoに勝つ | 6人まで・30分。経験値は減らない。フェイスを呼べる。入ると強化が消え、古代文字の強化がつく。どちらかのHPが半分になると2人で連携してきて、そのあいだはそちらを倒せない。 | @生贄の間 | T obj.生贄の間.Mahogany_Door
g02 go - | 勝ったあとの長いイベントを見ると完了 | 10分より長い。 | @生贄の間

@ mission.asa.015 https://wiki.ffo.jp/html/18259.html
Q An Uneasy Peace | 悪夢去りし後…… | no
MN ASA14 15
RW key_item:ベヒーモス座のカギ
RW title:シャントット帝国反乱分子
LK condition:前節「呪われる世界」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_14;ウィンダス森の区か水の区からウィンダス石の区に入るとイベント。モグハウスやホームポイントのワープでは起きない。称号 Arrester of the Ascension、Behemoth key（FFXIclopedia も同じ）
g01 go - | ウィンダス森の区か水の区からウィンダス石の区に歩いて入り、イベントを見ると完了 | モグハウスから出たときやワープで来たときは起きない。終わると一覧の名前が「シャントット帝国の陰謀＜完＞」になる。 | @ウィンダス石の区

@ mission.asa.016 https://wiki.ffo.jp/html/18262.html
Q A Shantotto Ascension (Fin) | シャントット帝国の陰謀＜完＞ | no
MN ASA15 16
LK condition:「悪夢去りし後……」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Shantotto_Ascension_Mission_15;ジュノ下層の天晶堂で Behemoth key を使うと Blitzer Poleyn・Desultor Tassets・Tatsumaki Sitagoromo のどれか（FFXIclopedia も同じ）。BG Wiki はカギの宝箱をジュノ下層 J-8 と書いている
g01 examine - | ジュノ下層の天晶堂の中のTreasure Cofferを調べ、ブリッツァポレイン・デサルタタセッツ・竜巻下衣から1つ選んで受け取ると完了 | どれか1つしか持てない。選び直すときは持っているものを捨てて、呪われる世界の戦いをもう一度勝つ。 | @ジュノ下層 J-8 | K ベヒーモス座のカギ
