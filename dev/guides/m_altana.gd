# アルタナミッション（0.1.121〜）。基礎シートのミッション一覧 189〜242 行。id の番号はシートの行−188、order も同じ
@ mission.altana.001 https://wiki.ffo.jp/html/14363.html
Q Cavernous Maws | 忘らるる口 | no | T obj.バタリア丘陵.Cavernous_Maw
MN WotG1 1
XS BG Wiki;https://www.bg-wiki.com/ffxi/Cavernous_Maws_(Mission);禁断の口はバタリア丘陵 H-5、ロランベリー耕地 H-6（FFXIclopedia も同じ）、ソロムグ原野 J-10（FFXIclopedia は K-9。ガルレージュ要塞の第3の門の先から出る）。調べた場所と飛ばされる過去の場所は一致しないことがある。だいじなもの Pure White Feather は BG Wiki・FFXIclopedia ではこの節
g01 go - | ジュノのまわりの3つの禁断の口のどれかへ行く | 飛ばされる過去の場所は、調べた口と同じとは限らない。 | @バタリア丘陵 | > a01,b01,c01
a01 examine - | バタリア丘陵(H-5)の丘の裏のCavernous Mawを調べてイベントを見ると完了 | - | @バタリア丘陵 H-5 | T obj.バタリア丘陵.Cavernous_Maw | R バタリア丘陵から
b01 examine - | ロランベリー耕地(H-6)の小さな丘ぞいのCavernous Mawを調べてイベントを見ると完了 | - | @ロランベリー耕地 H-6 | T obj.ロランベリー耕地.Cavernous_Maw = obj:Cavernous Maw@ロランベリー耕地 H-6 | R ロランベリー耕地から
c01 examine - | ソロムグ原野のCavernous Mawを調べてイベントを見ると完了 | ガルレージュ要塞の第3の門の先から出た崖の上にある。 | @ソロムグ原野 J-10 K-9 | T obj.ソロムグ原野.Cavernous_Maw = obj:Cavernous Maw@ソロムグ原野 J-10 K-9 | R ソロムグ原野から

@ mission.altana.002 https://wiki.ffo.jp/html/14364.html
Q Back to the Beginning | はじまりの刻 | no
MN WotG2 2
RW key_item:純白の羽根
LK condition:前節「忘らるる口」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Back_to_the_Beginning;過去の3国のどれかの軍に入る（サンドリアはガルレージュ要塞〔Ｓ〕Map 2 I-6 の Randecque、ウィンダスはクロウラーの巣〔Ｓ〕L-8 の Kalsu-Kalasu、バストゥークはエルディーム古墳〔Ｓ〕J-9 の Turbulent Storm。FFXIclopedia も同じ）。どの国でも進み方は同じ
g01 go - | 過去の世界でイベントを見る | 飛ばされた場所の禁断の口から一度現代へ抜けると、その口が開く。近くのSurvival Guideも開けておく。 | @バタリア丘陵〔Ｓ〕
g02 talk - | 過去の3国のどれかの軍に入り、推薦状をもらう | サンドリアはガルレージュ要塞〔Ｓ〕(I-6)のRandecque、ウィンダスはクロウラーの巣〔Ｓ〕(L-8)のKalsu-Kalasu、バストゥークはエルディーム古墳〔Ｓ〕(J-9)のTurbulent Storm。どの国でもミッションの進み方は同じ。
g03 go - | 過去の3国のどれかで「オーク軍団掃討作戦」（サンドリア）「静かなる警鐘」（バストゥーク）「禍つ闇、襲来」（ウィンダス）を終えると完了 | 3国とも同じクエストの流れを進めてよい。

@ mission.altana.003 https://wiki.ffo.jp/html/14365.html
Q Cait Sith | ケット・シー、馳せる | no
MN WotG3 3
RW title:ケット・シーの助手
LK condition:前節「はじまりの刻」クリア、過去の3国の「オーク軍団掃討作戦」「静かなる警鐘」「禍つ闇、襲来」のどれかを終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Cait_Sith_(Mission);ジュノのまわりの禁断の口を、過去で（現代なら過去から開けた口で）調べるとイベント。次の国のクエストを終え、東ロンフォール〔Ｓ〕から歩いて南サンドリア〔Ｓ〕に入る（Home Point・Survival Guide ではだめ）。称号 Cait Sith's Assistant は FFXIclopedia ではこの節、BG Wiki では前節
g01 examine - | ジュノのまわりの禁断の口（過去のもの、または過去から開けた現代のもの）を調べてイベントを見る | - | @バタリア丘陵〔Ｓ〕
g02 go - | 過去の3国のどれかで「ちいさな勝利、ひとつの決意」（サンドリア）「新たなる猜疑」（バストゥーク）「降臨、異貌の徒」（ウィンダス）を終える | -
g03 go - | 東ロンフォール〔Ｓ〕から歩いて南サンドリア〔Ｓ〕に入ってイベントを見ると完了 | どの国のクエストを進めていても南サンドリア〔Ｓ〕。Home PointやSurvival Guideで入るとイベントにならない。 | @南サンドリア〔Ｓ〕

@ mission.altana.004 https://wiki.ffo.jp/html/15329.html
Q The Queen of the Dance | 舞姫、来たりて | no | T obj.南サンドリア〔Ｓ〕.Door_Lion_Springs = obj:Door:"Lion Springs"@南サンドリア〔Ｓ〕 K-6
MN WotG4 4
LK condition:前節「ケット・シー、馳せる」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Queen_of_the_Dance;獅子の泉の扉 K-6、Turlough ジュノ上層 G-7（踊り子を見ている。FFXIclopedia も同じ）でショーのチケットをもらい、扉をもう一度調べる
g01 examine - | 南サンドリア〔Ｓ〕(K-6)の獅子の泉の扉を調べてイベントを見る | 選ぶものはどれでもよい。 | @南サンドリア〔Ｓ〕 K-6 | T obj.南サンドリア〔Ｓ〕.Door_Lion_Springs
g02 talk - | 現代のジュノ上層(G-7)で踊り子を見ているTurloughに話して、だいじなもの「ショー・チケット」をもらう | - | @ジュノ上層 G-7 | T npc.ジュノ上層.Turlough = npc:Turlough@ジュノ上層 G-7
g03 examine - | 南サンドリア〔Ｓ〕(K-6)の獅子の泉の扉をもう一度調べてイベントを見ると完了 | - | @南サンドリア〔Ｓ〕 K-6 | T obj.南サンドリア〔Ｓ〕.Door_Lion_Springs | K ショー・チケット

@ mission.altana.005 https://wiki.ffo.jp/html/15331.html
Q While the Cat is Away | 玉冠の獣、ふたたび | no
MN WotG5 5
LK condition:前節「舞姫、来たりて」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/While_the_Cat_is_Away;前節の最後のイベントで始まる。南サンドリア〔Ｓ〕から東ロンフォール〔Ｓ〕へ出るとイベント
g01 go - | 南サンドリア〔Ｓ〕から東ロンフォール〔Ｓ〕へ出てイベントを見ると完了 | - | @東ロンフォール〔Ｓ〕

@ mission.altana.006 https://wiki.ffo.jp/html/15332.html
Q A Timeswept Butterfly | 梢の胡蝶 | no
MN WotG6 6
LK condition:前節「玉冠の獣、ふたたび」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Timeswept_Butterfly;ジャグナー森林〔Ｓ〕G-11 の Wooden Gate からラヴォール村〔Ｓ〕へ（FFXIclopedia も G-11）。すぐ外に Survival Guide がある
g01 go - | ジャグナー森林〔Ｓ〕(G-11)からラヴォール村〔Ｓ〕に入ってイベントを見ると完了 | すぐ外にSurvival Guideがある。 | @ジャグナー森林〔Ｓ〕 G-11

@ mission.altana.007 https://wiki.ffo.jp/html/15333.html
Q Purple, The New Black | 紫電、劈く | no | T obj.ラヴォール村〔Ｓ〕.Reinforced_Gateway = obj:Reinforced Gateway@ラヴォール村〔Ｓ〕 F-9
MN WotG7 7
LK condition:前節「梢の胡蝶」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Purple,_The_New_Black;Reinforced Gateway F-9（FFXIclopedia も F-9）。BF の相手は Galarhigg。称号 Traverser of Time は BG Wiki・FFXIclopedia ではこの節
g01 go - | ラヴォール村〔Ｓ〕(F-9)のReinforced Gatewayへ行く | 入口から右の壁ぞいに行くのが安全（インビジ。インプは見破る）。(G-6)の近道はNMがいて危ない。 | @ラヴォール村〔Ｓ〕 F-9
g02 examine - | Reinforced Gatewayを調べてイベントを見る | - | @ラヴォール村〔Ｓ〕 F-9 | T obj.ラヴォール村〔Ｓ〕.Reinforced_Gateway
g03 fight - | もう一度調べてBF「紫電、劈く」に入り、Galarhiggを倒すと完了 | 6人・30分・フェイス可。入ると強化が消える。石化に気をつける。 | @ラヴォール村〔Ｓ〕 F-9 | T obj.ラヴォール村〔Ｓ〕.Reinforced_Gateway

@ mission.altana.008 https://wiki.ffo.jp/html/15334.html
Q In the Name of the Father | 天涯の娘 | no | T obj.南サンドリア〔Ｓ〕.Door_Lion_Springs
MN WotG8 8
RW title:往代を巡りし者
LK condition:前節「紫電、劈く」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/In_the_Name_of_the_Father;次の国のクエストを終えて、獅子の泉の扉 K-6 を調べる（FFXIclopedia も K-6）
g01 go - | 過去の3国のどれかで「それぞれの死地へ」「隠滅の炎」「淑女たちの饗宴」を終える | -
g02 examine - | 南サンドリア〔Ｓ〕(K-6)の獅子の泉の扉を調べてイベントを見ると完了 | - | @南サンドリア〔Ｓ〕 K-6 | T obj.南サンドリア〔Ｓ〕.Door_Lion_Springs

@ mission.altana.009 https://wiki.ffo.jp/html/16646.html
Q Dancers in Distress | 踊り子の憂慮 | no | T obj.南サンドリア〔Ｓ〕.Door_Lion_Springs
MN WotG9 9
LK condition:前節「天涯の娘」クリア、過去の3国の「それぞれの死地へ」「隠滅の炎」「淑女たちの饗宴」のどれかを終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Dancers_in_Distress;Raustigne 南サンドリア〔Ｓ〕I-7（BG Wiki は I-7/8）、Elegant Footprints ジャグナー森林〔Ｓ〕I-6（H-6 との境の切り株のそば。FFXIclopedia は H-6 と I-6 の境）。求められる品はリンクスの肉・獣人金貨・ニュモモちゃんのどれか。エリアを出入りしてからトレード
g01 examine - | 南サンドリア〔Ｓ〕(K-6)の獅子の泉の扉を調べてイベントを見る | - | @南サンドリア〔Ｓ〕 K-6 | T obj.南サンドリア〔Ｓ〕.Door_Lion_Springs
g02 talk - | 南サンドリア〔Ｓ〕(I-7)の凱旋門の前のRaustigneに話してイベントを見る | - | @南サンドリア〔Ｓ〕 I-7 | T npc.南サンドリア〔Ｓ〕.Raustigne
g03 examine - | ジャグナー森林〔Ｓ〕(I-6)の切り株のそばのElegant Footprintsを調べてイベントを見る | 東ロンフォール〔Ｓ〕のSurvival Guideから入ると近い。リンクスの肉・獣人金貨・ニュモモちゃんのどれかを求められる。もう一度調べると何が要るか教えてくれる。 | @ジャグナー森林〔Ｓ〕 H-6 I-6 | T obj.ジャグナー森林〔Ｓ〕.Elegant_Footprints = obj:Elegant Footprints@ジャグナー森林〔Ｓ〕 H-6 I-6
g04 trade - | 一度エリアを出入りしてから、求められた品をElegant Footprintsにトレードしてイベントを見ると完了 | ニュモモちゃんは現代のバタリア丘陵のオークが落とす。次の節で要るケルヌンノスの球根を、ここで若木から取っておくとよい。 | @ジャグナー森林〔Ｓ〕 H-6 I-6 | T obj.ジャグナー森林〔Ｓ〕.Elegant_Footprints

@ mission.altana.010 https://wiki.ffo.jp/html/16647.html
Q Daughter of a Knight | 白い涙、黒い泪 | no | T npc.230.Amaura
MN WotG10 10
RW key_item:鎮静薬
LK condition:前節「踊り子の憂慮」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Daughter_of_a_Knight;Amaura 南サンドリア G-6（FFXIclopedia も G-6）。ケルヌンノスの球根はジャグナー森林〔Ｓ〕の Wandering Sapling から。乙女の泉 E-6 の Humus-rich Earth に植え、現代のジャグナー森林の同じ場所で Cernunnos を倒す
g01 talk - | 現代の南サンドリア(G-6)の猟犬横丁のAmauraに話してイベントを見る | Home Point #4が近い。 | @南サンドリア G-6 | T npc.230.Amaura
g02 gather - | ジャグナー森林〔Ｓ〕の若木（Wandering Sapling）からケルヌンノスの球根を手に入れる | (E-11)から(F-8)の道ぞいにいる。 | @ジャグナー森林〔Ｓ〕
g03 trade - | Amauraにケルヌンノスの球根をトレードしてイベントを見る | - | @南サンドリア G-6 | T npc.230.Amaura | N ケルヌンノスの球根*1
g04 trade - | ジャグナー森林〔Ｓ〕(E-6)の乙女の泉のHumus-rich Earthにケルヌンノスの球根をトレードして植える | 球根はもう1つ要る。キャンペーンのワープかSurvival Guideが近い。 | @ジャグナー森林〔Ｓ〕 E-6 | T obj.ジャグナー森林〔Ｓ〕.Humus-rich_Earth = obj:Humus-rich Earth@ジャグナー森林〔Ｓ〕 E-6 | N ケルヌンノスの球根*1
g05 examine - | 現代のジャグナー森林(E-6)の同じ場所のHumus-rich Earthを調べてイベントを見る | - | @ジャグナー森林 E-6 | T obj.104.Humus-rich_Earth = obj:Humus-rich Earth@ジャグナー森林 E-6
g06 defeat - | もう一度調べて、出てきたCernunnosを倒す | 樹人族のNM。 | @ジャグナー森林 E-6 | T mob.104.Cernunnos = mob:Cernunnos@ジャグナー森林 E-6
g07 examine - | もう一度Humus-rich Earthを調べて、だいじなもの「ケルヌンノスの樹脂」をもらう | - | @ジャグナー森林 E-6 | T obj.104.Humus-rich_Earth
g08 talk - | 南サンドリア(G-6)のAmauraに話してイベントを見る | - | @南サンドリア G-6 | T npc.230.Amaura | K ケルヌンノスの樹脂
g09 talk - | ヴァナ時間の0時を過ぎてエリアを出入りしてから、もう一度Amauraに話して鎮静薬をもらうと完了 | 早く話すと、もう一度エリアを出入りする必要がある。 | @南サンドリア G-6 | T npc.230.Amaura | W ヴァナ時間の0時を過ぎてから

@ mission.altana.011 https://wiki.ffo.jp/html/16695.html
Q A Spoonful of Sugar | 彼の世に至る病 | no | T npc.南サンドリア〔Ｓ〕.Raustigne
MN WotG11 11
LK condition:前節「白い涙、黒い泪」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Spoonful_of_Sugar;凱旋門 I-7 の Raustigne（FFXIclopedia も I-7）
g01 talk - | 南サンドリア〔Ｓ〕(I-7)のRaustigneに話してイベントを見ると完了 | 長いイベント。 | @南サンドリア〔Ｓ〕 I-7 | T npc.南サンドリア〔Ｓ〕.Raustigne | K 鎮静薬

@ mission.altana.012 https://wiki.ffo.jp/html/16651.html
Q Affairs of State | 国務、携えし | no
MN WotG12 12
RW key_item:ボーレル卿の封書
LK condition:前節「彼の世に至る病」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Affairs_of_State;Radford バストゥーク商業区〔Ｓ〕H-6、Velda-Galda ウィンダス水の区〔Ｓ〕北 K-9（FFXIclopedia も同じ）。順番はどちらでもよい。街が攻められているときはいない
g01 talk - | バストゥーク商業区〔Ｓ〕(H-6)の大工房の近くのRadfordに話してイベントを見る | ウィンダスと順番はどちらでもよい。 | @バストゥーク商業区〔Ｓ〕 H-6 | T npc.バストゥーク商業区〔Ｓ〕.Radford = npc:Radford@バストゥーク商業区〔Ｓ〕 H-6
g02 talk - | ウィンダス水の区〔Ｓ〕(K-9)のVelda-Galdaに話してイベントを見ると完了 | 両方の国で話すと、ボーレル卿の封書がもらえる。街が攻められているときはいない。 | @ウィンダス水の区〔Ｓ〕 K-9 | T npc.ウィンダス水の区〔Ｓ〕.Velda-Galda = npc:Velda-Galda@ウィンダス水の区〔Ｓ〕 K-9

@ mission.altana.013 https://wiki.ffo.jp/html/16652.html
Q Borne by the Wind | 威風凛凛 | no | T obj.ソロムグ原野〔Ｓ〕.Bulwark_Gate
MN WotG13 13
RW key_item:ハッチのカギ
LK condition:前節「国務、携えし」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Borne_by_the_Wind;Bulwark Gate ソロムグ原野〔Ｓ〕E-6/F-6（FFXIclopedia F-6）。イベントの選択肢は1番目。描画の速さを変える設定だとイベントが止まることがある
g01 examine - | ソロムグ原野〔Ｓ〕(F-6)のBulwark Gateを調べてイベントを見ると完了 | 選択肢は1番目を選ぶ。ボイドウォッチの進み具合によって別のイベントが出たら、もう一度調べる。 | @ソロムグ原野〔Ｓ〕 F-6 | T obj.ソロムグ原野〔Ｓ〕.Bulwark_Gate | K ボーレル卿の封書

@ mission.altana.014 https://wiki.ffo.jp/html/16653.html
Q A Nation on the Brink | ジュノ、擾乱 | no | T obj.バタリア丘陵〔Ｓ〕.Underpass_Hatch = obj:Underpass Hatch@バタリア丘陵〔Ｓ〕 J-9
MN WotG14 14
LK condition:前節「威風凛凛」クリア、だいじなもの「ハッチのカギ」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Nation_on_the_Brink;Underpass Hatch バタリア丘陵〔Ｓ〕J-9（BG Wiki は J-9/K-9）の防壁の塔の中。BF は常花の石窟で、獣人の群れを倒すと One-eyed Gwajboj が出る。称号 Battle of Jeuno Veteran と Jeunoan Flag は BG Wiki・FFXIclopedia ではこの節。負けたらヴァナ時間の0時のあと Bulwark Gate でカギをもらい直す
g01 examine - | バタリア丘陵〔Ｓ〕(K-9)の東の階段から防壁に上がり、(J-9)の塔の中のUnderpass Hatchを調べてイベントを見る | - | @バタリア丘陵〔Ｓ〕 J-9 | T obj.バタリア丘陵〔Ｓ〕.Underpass_Hatch
g02 fight - | もう一度調べてBF「ジュノ、擾乱」に入り、獣人の群れを倒したあと出てくるOne-eyed Gwajbojを倒すと完了 | 6人・30分・レベル制限なし・フェイス可。味方の兵と一緒に北・東・南西の群れを倒す。敵は寝ない。Gwajbojはインビンシブルとケアルを使う。負けたらヴァナ時間の0時のあとBulwark Gateでカギをもらい直す。 | @バタリア丘陵〔Ｓ〕 J-9 | T obj.バタリア丘陵〔Ｓ〕.Underpass_Hatch | K ハッチのカギ

@ mission.altana.015 https://wiki.ffo.jp/html/16691.html
Q Crossroads of Time | 宙の座 | no
MN WotG15 15
RW item:大公国旗
RW title:ジュノ攻防戦の功労者
LK condition:前節「ジュノ、擾乱」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crossroads_of_Time;次の国のクエストを終えて、東ロンフォール〔Ｓ〕から南サンドリア〔Ｓ〕に入る。大公国旗を受け取れなかったときは、バタリア丘陵〔Ｓ〕J-9 の防壁の行き止まりの樽の ??? で受け取れる（用語辞典）
g01 go - | 過去の3国のどれかで「不帰の道程」「栄誉と背反」「隠者と神獣と」を終える | 大公国旗を受け取るので、カバンを空けておく。
g02 go - | ヴァナ時間の0時を過ぎてから、東ロンフォール〔Ｓ〕から歩いて南サンドリア〔Ｓ〕に入ってイベントを見ると完了 | デジョンやリトレースで入るとイベントにならない。 | @南サンドリア〔Ｓ〕 | W ヴァナ時間の0時を過ぎてから

@ mission.altana.016 https://wiki.ffo.jp/html/17594.html
Q Sandswept Memories | 砂の記憶 | no | T obj.南サンドリア〔Ｓ〕.Door_Lion_Springs
MN WotG16 16
LK condition:前節「宙の座」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Sandswept_Memories;獅子の泉の扉 K-6（FFXIclopedia も K-6）
g01 examine - | 南サンドリア〔Ｓ〕(K-6)の獅子の泉の扉を調べてイベントを見ると完了 | - | @南サンドリア〔Ｓ〕 K-6 | T obj.南サンドリア〔Ｓ〕.Door_Lion_Springs

@ mission.altana.017 https://wiki.ffo.jp/html/17595.html
Q Northland Exposure | 娘、北進して | no
MN WotG17 17
RW key_item:尾行蟲
LK condition:前節「砂の記憶」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Northland_Exposure;ボスディン氷河〔Ｓ〕に入るとイベント。Survival Guide がなければバタリア丘陵〔Ｓ〕E-4 のトンネルから
g01 go - | ボスディン氷河〔Ｓ〕に入ってイベントを見ると完了 | Survival Guideか、キャンペーンのワープが近い。歩くならバタリア丘陵〔Ｓ〕(E-4)のトンネルから。 | @ボスディン氷河〔Ｓ〕

@ mission.altana.018 https://wiki.ffo.jp/html/17596.html
Q Traitor in the Midst | 紫雲か、暗雲か | no
MN WotG18 18
LK condition:前節「娘、北進して」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Traitor_in_the_Midst;ボスディン氷河〔Ｓ〕の北の5つの塔の Regal Pawprints でミニゲーム。J-8・I-7 は FFXIclopedia も同じ、F-7・H-8・G-9 と最後の H-10 は用語辞典。順番はどれでもよい。ほかの節で使う Regal Pawprints もあるので、塔のそばのものを調べる
g01 examine - | ボスディン氷河〔Ｓ〕の5つの塔のそばのRegal Pawprintsを調べ、ミニゲームでケット・シーに尾行蟲をつける | 場所は(F-7)(H-8)(G-9)(I-7)(J-8)。順番はどれでもよい。失敗してもその場でやり直せる。済んだ場所はログアウトしても残る。 | @ボスディン氷河〔Ｓ〕 F-7 H-8 G-9 I-7 J-8 | K 尾行蟲
g02 examine - | 5か所とも済んだら、(H-10)の塔の近くの木の根もとのRegal Pawprintsを調べてイベントを見ると完了 | - | @ボスディン氷河〔Ｓ〕 H-10 | T obj.ボスディン氷河〔Ｓ〕.Regal_Pawprints_H10 = obj:Regal Pawprints@ボスディン氷河〔Ｓ〕 H-10

@ mission.altana.019 https://wiki.ffo.jp/html/17617.html
Q Betrayal at Beaucedine | 黒き奸計の尾 | no | T obj.ボスディン氷河〔Ｓ〕.Regal_Pawprints_H9 = obj:Regal Pawprints@ボスディン氷河〔Ｓ〕 H-9
MN WotG19 19
LK condition:前節「紫雲か、暗雲か」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Betrayal_at_Beaucedine;Regal Pawprints H-9（FFXIclopedia も H-9）。キャンペーンのワープから坂を下りた木の陰。Count Halphas と Dark Demon 4体が出て、Count Halphas を倒せばよい
g01 examine - | ボスディン氷河〔Ｓ〕(H-9)のRegal Pawprintsを調べてイベントを見る | キャンペーンのワープから南西の坂を下りた、曲がった木のそば。塔のそばのものとは別。 | @ボスディン氷河〔Ｓ〕 H-9 | T obj.ボスディン氷河〔Ｓ〕.Regal_Pawprints_H9
g02 defeat - | もう一度調べて、出てきたCount Halphasを倒す | Dark Demon 4体も出るが、Count Halphasを倒すと消える。Dark Demonはスリプガで寝る。 | @ボスディン氷河〔Ｓ〕 H-9 | T mob.ボスディン氷河〔Ｓ〕.Count_Halphas = mob:Count Halphas@ボスディン氷河〔Ｓ〕 H-9
g03 examine - | もう一度Regal Pawprintsを調べてイベントを見ると完了 | 長いイベント。 | @ボスディン氷河〔Ｓ〕 H-9 | T obj.ボスディン氷河〔Ｓ〕.Regal_Pawprints_H9

@ mission.altana.020 https://wiki.ffo.jp/html/17618.html
Q On Thin Ice | 盤上の罠 | no | T npc.南サンドリア〔Ｓ〕.Raustigne
MN WotG20 20
LK condition:前節「黒き奸計の尾」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/On_Thin_Ice;Raustigne I-7（FFXIclopedia も I-7）。次の節のお使いの品（オークの装備・ギサールの野菜・クロスボウボルト・ノールの爪など）を先に用意しておくと楽（FFXIclopedia）
g01 talk - | 南サンドリア〔Ｓ〕(I-7)の凱旋門のRaustigneに話してイベントを見ると完了 | - | @南サンドリア〔Ｓ〕 I-7 | T npc.南サンドリア〔Ｓ〕.Raustigne

@ mission.altana.021 https://wiki.ffo.jp/html/17619.html
Q Proof of Valor | 勇胆の証 | no | T npc.南サンドリア〔Ｓ〕.Raustigne
MN WotG21 21
RW item:署名の数でオックスオーブ・フーラード・エンゼルオーブ・オリハルコン・モリブデインゴットのどれか
LK condition:前節「盤上の罠」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Proof_of_Valor;署名は20人分あればよい。話すだけ10人（Aissaville I-7・Illeuse H-9・Daigraffeaux I-11・Andagge H-9・Louxiard G-7・Machionage C-6・Remiotte L-10・Elnonde K-9・Loillie K-9・Mailleronce M-6）、問答4人（Farouel K-7・Aurfet G-9・Corseihaut F-6・Vichauxdat I-8、最大6ずつ）。座標は FFXIclopedia も同じ。多く集めると報酬が増える
g01 talk - | 南サンドリア〔Ｓ〕の騎士たちに話して、署名を20人分以上集める | 話すだけでもらえる10人：Aissaville(I-7)、Illeuse(H-9)、Daigraffeaux(I-11)、Andagge(H-9)、Louxiard(G-7)、Machionage(C-6)、Remiotte(L-10)、Elnonde(K-9)、Loillie(K-9)、Mailleronce(M-6)。問答の4人：Farouel(K-7)、Aurfet(G-9)、Corseihaut(F-6)、Vichauxdat(I-8)は、正しく答えるほど多くくれる。お使いの人もいる。 | @南サンドリア〔Ｓ〕
g02 talk - | 南サンドリア〔Ｓ〕(I-7)の凱旋門のRaustigneに話してイベントを見ると完了 | 署名が多いほど報酬がよくなる。 | @南サンドリア〔Ｓ〕 I-7 | T npc.南サンドリア〔Ｓ〕.Raustigne

@ mission.altana.022 https://wiki.ffo.jp/html/17620.html
Q A Sanguinary Prelude | 衝突、会戦の序 | no
MN WotG22 22
RW key_item:芳香蟲
LK condition:前節「勇胆の証」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Sanguinary_Prelude;ボスディン氷河〔Ｓ〕に入るとイベント。Survival Guide で入ると次の節の Regal Pawprints と同じ段に出る（FFXIclopedia）
g01 go - | ボスディン氷河〔Ｓ〕に入ってイベントを見ると完了 | キャンペーンのワープかSurvival Guideで入ると、次の節の場所に近い。 | @ボスディン氷河〔Ｓ〕

@ mission.altana.023 https://wiki.ffo.jp/html/17702.html
Q Dungeons and Dancers | 囚われの迷宮で | no | T obj.ボスディン氷河〔Ｓ〕.Regal_Pawprints_G9 = obj:Regal Pawprints@ボスディン氷河〔Ｓ〕 G-9
MN WotG23 23
RW key_item:蝕甚蟲
LK condition:前節「衝突、会戦の序」クリア、だいじなもの「芳香蟲」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Dungeons_and_Dancers;Regal Pawprints G-9（FFXIclopedia も G-9）は塔ではなく、キャンペーンのワープと同じ高い段。常花の石窟の迷路を30分で抜ける。ネズミ火薬で壁を壊す。時間切れなら H-10 の Regal Pawprints で芳香蟲をもらい直す。だいじなもの Umbra Bug は BG Wiki・FFXIclopedia でこの節の報酬
g01 examine - | ボスディン氷河〔Ｓ〕(G-9)のRegal Pawprintsを調べてイベントを見る | 塔のそばではなく、キャンペーンのワープと同じ高い段の南西。 | @ボスディン氷河〔Ｓ〕 G-9 | T obj.ボスディン氷河〔Ｓ〕.Regal_Pawprints_G9
g02 fight - | もう一度調べて「囚われの迷宮で」に入り、30分以内に迷路の出口から出ると完了 | 6人・フェイス可。行き止まりの壁の???でネズミ火薬を使って道を開く（ゴブリンを倒すと補充できる）。色つきの壁は同じ色のSwitchで壊す。時間切れなら(H-10)のRegal Pawprintsで芳香蟲をもらい直す。 | @ボスディン氷河〔Ｓ〕 G-9 | T obj.ボスディン氷河〔Ｓ〕.Regal_Pawprints_G9 | K 芳香蟲

@ mission.altana.024 https://wiki.ffo.jp/html/17706.html
Q Distorter of Time | 禁断の口（ミッション） | no | T obj.ボスディン氷河〔Ｓ〕.Regal_Pawprints_H7 = obj:Regal Pawprints@ボスディン氷河〔Ｓ〕 H-7
MN WotG24 24
LK condition:前節「囚われの迷宮で」クリア、だいじなもの「蝕甚蟲」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Distorter_of_Time;キャンペーンのワープから北の H-7 の右下の穴から下りたすぐの Regal Pawprints（FFXIclopedia も H-7）。相手は Cait Sith Ceithir で、Lilisette が一緒に戦う。負けたら H-10 の Regal Pawprints で蝕甚蟲をもらい直す（ヴァナ時間で1日1回）
g01 go - | ボスディン氷河〔Ｓ〕のキャンペーンのワープから北へ行き、(H-7)の穴から下の段へ降りる | - | @ボスディン氷河〔Ｓ〕 H-7
g02 fight - | すぐ先のRegal Pawprintsを調べてBF「禁断の口」に入り、Cait Sith Ceithirに勝つと完了 | 30分・フェイス可。Lilisetteが一緒に戦う。負けたら(H-10)のRegal Pawprintsで蝕甚蟲をもらい直す（ヴァナ時間で1日1回）。 | @ボスディン氷河〔Ｓ〕 H-7 | T obj.ボスディン氷河〔Ｓ〕.Regal_Pawprints_H7 | K 蝕甚蟲

@ mission.altana.025 https://wiki.ffo.jp/html/17720.html
Q The Will of the World | 喰らわれし未来 | no | T npc.南サンドリア〔Ｓ〕.Raustigne
MN WotG25 25
LK condition:前節「禁断の口」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Will_of_the_World;Raustigne I-7（FFXIclopedia も I-7）。描画の速さを変える設定だとイベントが止まることがある
g01 talk - | 南サンドリア〔Ｓ〕(I-7)のRaustigneに話してイベントを見ると完了 | - | @南サンドリア〔Ｓ〕 I-7 | T npc.南サンドリア〔Ｓ〕.Raustigne

@ mission.altana.026 https://wiki.ffo.jp/html/17721.html
Q Fate in Haze | 傾ぐ天秤 | no | T obj.南サンドリア〔Ｓ〕.Door_Lion_Springs
MN WotG26 26
LK condition:前節「喰らわれし未来」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Fate_in_Haze;次の国のクエストを終えて、獅子の泉の扉 K-6 を調べる（FFXIclopedia も同じ）
g01 go - | 過去の3国のどれかで「囚われし者」「雪原を朱に染めて」「星月、その姿は」を終える | その前の「不慮の援軍」「向かうべき道」「光の記憶」から進める。
g02 examine - | 南サンドリア〔Ｓ〕(K-6)の獅子の泉の扉を調べてイベントを見ると完了 | - | @南サンドリア〔Ｓ〕 K-6 | T obj.南サンドリア〔Ｓ〕.Door_Lion_Springs

@ mission.altana.027 https://wiki.ffo.jp/html/19502.html
Q The Scent of Battle | 死闘の萌芽 | no | T obj.ソロムグ原野〔Ｓ〕.Bulwark_Gate
MN WotG27 27
LK condition:前節「傾ぐ天秤」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Scent_of_Battle;Bulwark Gate F-6（FFXIclopedia も F-6）
g01 examine - | ソロムグ原野〔Ｓ〕(F-6)のBulwark Gateを調べてイベントを見ると完了 | キャンペーンのワープか、現代のロランベリー耕地のSurvival Guideの横の禁断の口から行くと近い。 | @ソロムグ原野〔Ｓ〕 F-6 | T obj.ソロムグ原野〔Ｓ〕.Bulwark_Gate

@ mission.altana.028 https://wiki.ffo.jp/html/19503.html
Q Another World | 現世と隠世と | no | T npc.233.Halver
MN WotG28 28
LK condition:前節「死闘の萌芽」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Another_World;現代の東ロンフォールから南サンドリアに入るとイベント（Home Point ではだめ）。Halver I-9（FFXIclopedia も I-9）。ほかのミッションやクエストのイベントが先に出ることがある
g01 go - | 現代の東ロンフォールから歩いて南サンドリアに入ってイベントを見る | Home Pointで入るとイベントにならない。 | @南サンドリア
g02 talk - | ドラギーユ城(I-9)のHalverに話してイベントを見ると完了 | ほかのイベントが先に出たら、一度エリアを出て入り直す。 | @ドラギーユ城 I-9 | T npc.233.Halver

@ mission.altana.029 https://wiki.ffo.jp/html/19504.html
Q A Hawk in Repose | 勇鷹の墓標 | no | T obj.バタリア丘陵.Weathered_Gravestone
MN WotG29 29
LK condition:前節「現世と隠世と」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Hawk_in_Repose;ライラックはジュノ上層 H-6 の Areebah で120ギル（あとのクエストでも要るので2つ）。Weathered Gravestone バタリア丘陵 I-10（FFXIclopedia も同じ）。エルディーム古墳の Survival Guide が近い
g01 gather - | ジュノ上層(H-6)のＭ＆ＰマートのAreebahからライラックを買う | 120ギル。あとのクエストでも要るので2つ買うとよい。 | @ジュノ上層 H-6 | T npc.ジュノ上層.Areebah = npc:Areebah@ジュノ上層 H-6
g02 examine - | 現代のバタリア丘陵(I-10)の丘の上のWeathered Gravestoneを調べてイベントを見る | エルディーム古墳のSurvival Guideから外へ出ると近い。 | @バタリア丘陵 I-10 | T obj.バタリア丘陵.Weathered_Gravestone
g03 trade - | Weathered Gravestoneにライラックをトレードしてイベントを見ると完了 | - | @バタリア丘陵 I-10 | T obj.バタリア丘陵.Weathered_Gravestone | N ライラック*1

@ mission.altana.030 https://wiki.ffo.jp/html/19505.html
Q The Battle of Xarcabard | 決戦、ザルカバード | no | T obj.ザルカバード〔Ｓ〕.Rally_Point_Red = obj:Rally Point: Red@ザルカバード〔Ｓ〕 F-8
MN WotG30 30
LK condition:前節「勇鷹の墓標」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Battle_of_Xarcabard_(Mission);ザルカバード〔Ｓ〕に入るとイベント。Rally Point: Red は F-8（BG Wiki と用語辞典。FFXIclopedia は座標なし）
g01 go - | ザルカバード〔Ｓ〕に入ってイベントを見る | ザルカバード〔Ｓ〕のHome Pointか、ボスディン氷河〔Ｓ〕のSurvival Guideが近い。インプやタウルスは見破るのでマウントが安全。 | @ザルカバード〔Ｓ〕
g02 examine - | ザルカバード〔Ｓ〕(F-8)の南の壁ぞい、2本の岩の間のRally Point: Redを調べてイベントを見ると完了 | - | @ザルカバード〔Ｓ〕 F-8 | T obj.ザルカバード〔Ｓ〕.Rally_Point_Red

@ mission.altana.031 https://wiki.ffo.jp/html/19508.html
Q Prelude to a Storm | 雪上の嵐：翠 | no | T obj.ザルカバード〔Ｓ〕.Rally_Point_Green = obj:Rally Point: Green@ザルカバード〔Ｓ〕 G-9
MN WotG31 31
RW item:エリクサー・バイルエリクサー・バイルエリクサー+1のどれか
LK condition:前節「決戦、ザルカバード」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Prelude_to_a_Storm;Rally Point: Green と Spell-worked Snow は G-9（FFXIclopedia も G-9）。中で Pesoso に話して始め、3つの部屋の獣人を全部倒して Pesoso に話す。負けたらヴァナ時間の0時のあと Rally Point: Green で照明弾をもらい直す
g01 examine - | ザルカバード〔Ｓ〕(G-9)の黒い建物の前のRally Point: Greenを調べてイベントを見て、だいじなもの「軍用魔法照明弾」をもらう | - | @ザルカバード〔Ｓ〕 G-9 | T obj.ザルカバード〔Ｓ〕.Rally_Point_Green
g02 fight - | すぐ南のSpell-worked Snowを調べて「雪上の嵐：翠」に入り、Pesosoに話して始め、3つの部屋の敵を全部倒す | 6人・30分・レベル制限なし・フェイス可。部屋の最後の敵が壁に穴を開けると次の部屋へ進める。3つ目の部屋にはデーモンもいる。範囲攻撃が便利。 | @ザルカバード〔Ｓ〕 G-9 | T obj.ザルカバード〔Ｓ〕.Spell-worked_Snow = obj:Spell-worked Snow@ザルカバード〔Ｓ〕 G-9 | K 軍用魔法照明弾
g03 talk - | 全部倒したという知らせが出たら、Pesosoに話して出ると完了 | 知らせが出ないときは、最初の部屋へ戻って残りを探す。報酬の薬を持っていると受け取れないので、整理してRally Point: Greenで受け取る。負けたらヴァナ時間の0時のあとRally Point: Greenで照明弾をもらい直す。 | @ザルカバード〔Ｓ〕 G-9

@ mission.altana.032 https://wiki.ffo.jp/html/19509.html
Q Storm's Crescendo | 雪上の嵐：藍 | no | T obj.ザルカバード〔Ｓ〕.Rally_Point_Blue = obj:Rally Point: Blue@ザルカバード〔Ｓ〕 H-8
MN WotG32 32
LK condition:前節「雪上の嵐：翠」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Storm%27s_Crescendo;Rally Point: Blue は H-8 の北西の角（FFXIclopedia も H-8）。中で Antje に話すととんずらの効果がつき、効果があるうちに24人の兵に話して爆薬を使わせる。パーティーで同時にやると効果が消し合うので1人で（1人が勝てば全員クリア）。勝ったら Rally Point: Red F-8
g01 examine - | ザルカバード〔Ｓ〕(H-8)の北西の角、黒い岩の建物の裏のRally Point: Blueを調べてイベントを見て、だいじなもの「軍用火薬照明弾」をもらう | - | @ザルカバード〔Ｓ〕 H-8 | T obj.ザルカバード〔Ｓ〕.Rally_Point_Blue
g02 fight - | すぐ北東のExcavated Snowを調べて「雪上の嵐：藍」に入り、Antjeに話してから、走る効果が切れないうちに24人の兵に次々と話す | 6人・30分・レベル制限なし。効果が切れたまま兵に話すと最初に戻される。爆発の方向に次の兵がいる。パーティーで同時にやると効果が消し合うので、1人でやる。 | @ザルカバード〔Ｓ〕 H-8 | T obj.ザルカバード〔Ｓ〕.Excavated_Snow = obj:Excavated Snow@ザルカバード〔Ｓ〕 H-8 | K 軍用火薬照明弾
g03 talk - | 24人全員に話したら、もう一度Antjeに話して出る | 負けたらヴァナ時間の0時のあとRally Point: Blueで照明弾をもらい直す。 | @ザルカバード〔Ｓ〕 H-8
g04 examine - | ザルカバード〔Ｓ〕(F-8)のRally Point: Redを調べてイベントを見ると完了 | - | @ザルカバード〔Ｓ〕 F-8 | T obj.ザルカバード〔Ｓ〕.Rally_Point_Red

@ mission.altana.033 https://wiki.ffo.jp/html/19510.html
Q Into the Beast's Maw | 闇の牙城 | no | T obj.ズヴァール城外郭〔Ｓ〕.Peculiar_Glint = obj:Peculiar Glint@ズヴァール城外郭〔Ｓ〕 G-7 #1
MN WotG33 33
LK condition:前節「雪上の嵐：藍」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Into_the_Beast%27s_Maw;ズヴァール城外郭〔Ｓ〕に入るとイベント。Peculiar Glint は Map 1 の G-7（FFXIclopedia も同じ）。相手は Count Bifrons とオーク4体で、Count Bifrons を倒せばよい。負けたらすぐ横の Ornate Block で照明弾をもらい直す（ヴァナ時間で1日待つことがある）
g01 go - | ズヴァール城外郭〔Ｓ〕に入ってイベントを見る | ここのSurvival Guideも開けておく。 | @ズヴァール城外郭〔Ｓ〕
g02 examine - | (G-7)の積み重ねた箱のそばのPeculiar Glintを調べてイベントを見て、だいじなもの「離脱用特殊照明弾」をもらう | - | @ズヴァール城外郭〔Ｓ〕 G-7 #1 | T obj.ズヴァール城外郭〔Ｓ〕.Peculiar_Glint
g03 fight - | もう一度Peculiar Glintを調べてBF「闇の牙城」に入り、Count Bifronsを倒すと完了 | 6人・30分・フェイス可。中は狭いので、入ってすぐ絡まれないように。オークは寝るが、倒さなくてよい。Count Bifronsはスリプガと範囲の技を使う。負けたらすぐ横のOrnate Blockで照明弾をもらい直す。 | @ズヴァール城外郭〔Ｓ〕 G-7 #1 | T obj.ズヴァール城外郭〔Ｓ〕.Peculiar_Glint | K 離脱用特殊照明弾

@ mission.altana.034 https://wiki.ffo.jp/html/19522.html
Q The Hunter Ensnared | 殲撃、響きて | no | T obj.ザルカバード〔Ｓ〕.Rally_Point_Red
MN WotG34 34
LK condition:前節「闇の牙城」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Hunter_Ensnared;Rally Point: Red F-8（FFXIclopedia も F-8）
g01 examine - | ザルカバード〔Ｓ〕(F-8)のRally Point: Redを調べてイベントを見ると完了 | - | @ザルカバード〔Ｓ〕 F-8 | T obj.ザルカバード〔Ｓ〕.Rally_Point_Red

@ mission.altana.035 https://wiki.ffo.jp/html/19523.html
Q Flight of the Lion | 獅子たちの帰還 | no | T obj.ソロムグ原野〔Ｓ〕.Bulwark_Gate
MN WotG35 35
LK condition:前節「殲撃、響きて」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Flight_of_the_Lion;Bulwark Gate F-6（FFXIclopedia も F-6）
g01 examine - | ソロムグ原野〔Ｓ〕(F-6)のBulwark Gateを調べてイベントを見ると完了 | キャンペーンのワープか、現代のロランベリー耕地のSurvival Guideの横の禁断の口から行くと近い。 | @ソロムグ原野〔Ｓ〕 F-6 | T obj.ソロムグ原野〔Ｓ〕.Bulwark_Gate

@ mission.altana.036 https://wiki.ffo.jp/html/19548.html
Q Fall of the Hawk | 鉄鷹、旋回す | no
MN WotG36 36
LK condition:前節「獅子たちの帰還」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Fall_of_the_Hawk;ズヴァール城外郭〔Ｓ〕に入るとイベント（Survival Guide で入ってもよい。FFXIclopedia も同じ）
g01 go - | ズヴァール城外郭〔Ｓ〕に入ってイベントを見ると完了 | ここのSurvival Guideで入ってもよい。 | @ズヴァール城外郭〔Ｓ〕

@ mission.altana.037 https://wiki.ffo.jp/html/19524.html
Q Darkness Descends | 黒天、閃電 | no
MN WotG37 37
RW title:失はれた者
LK condition:前節「鉄鷹、旋回す」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Darkness_Descends;王の間〔Ｓ〕に入るとイベント、扉から BF。相手は Aquila と Haudrale で、リリゼットが一緒に戦い、リリゼットが倒れると負け。3分たつとリリゼットが自分から始める。称号 Wanderer of Time（FFXIclopedia も同じ）
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/Darkness_Descends;星唄ミッションを Of Light and Darkness より先へ進めていないと、この節のあと Whispers of Dawn を終えるまで先へ進めなくなる、とある。王の間〔Ｓ〕までの道は透明でない人がいないと開かない門がある
g00 go - | ズヴァール城内郭〔Ｓ〕を抜けて王の間〔Ｓ〕へ向かう | 行くのに時間がかかるので、余裕をもって行く。王の間〔Ｓ〕の前のHome Pointが使えると近い。途中には透明でない人が開ける門がある。 | @ズヴァール城内郭〔Ｓ〕
g01 go - | 王の間〔Ｓ〕に入ってイベントを見る | - | @王の間〔Ｓ〕
g02 fight - | 奥の扉からBF「黒天、閃電」に入り、リリゼットと一緒に勝つと完了 | 6人・30分・レベル制限なし・フェイス可。リリゼットが倒れると負け。相手は黒魔法とノックバックの技を使う。これまでより強いので準備していく。 | @王の間〔Ｓ〕

@ mission.altana.038 https://wiki.ffo.jp/html/19686.html
Q Adieu, Lilisette | さようなら、リリゼット | no | T obj.南サンドリア〔Ｓ〕.Door_Lion_Springs
MN WotG38 38
LK condition:前節「黒天、閃電」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Adieu,_Lilisette;次の国のクエストを終えて、獅子の泉の扉 K-6 を調べる（FFXIclopedia も K-6）
g01 go - | 過去の3国のどれかで「それぞれの未来へ」「己の行く先に」「魂の果て」を終える | その前の「影」「潜みし影」「壊乱、オズトロヤ城」から進める。
g02 examine - | 南サンドリア〔Ｓ〕(K-6)の獅子の泉の扉を調べてイベントを見ると完了 | - | @南サンドリア〔Ｓ〕 K-6 | T obj.南サンドリア〔Ｓ〕.Door_Lion_Springs

@ mission.altana.039 https://wiki.ffo.jp/html/21130.html
Q By the Fading Light | 鳥籠の宇宙 | no | T obj.ザルカバード〔Ｓ〕.Rally_Point_Red
MN WotG39 39
LK condition:前節「さようなら、リリゼット」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/By_the_Fading_Light;Rally Point: Red F-8（FFXIclopedia も F-8）
g01 examine - | ザルカバード〔Ｓ〕(F-8)のRally Point: Redを調べてイベントを見ると完了 | 「加勢する」を選んだあとに「諦める……」を選ぶと「リリゼットを取り戻す」が出るので、それを選ぶ。「加勢する」ばかり選ぶとくり返しになる。 | @ザルカバード〔Ｓ〕 F-8 | T obj.ザルカバード〔Ｓ〕.Rally_Point_Red

@ mission.altana.040 https://wiki.ffo.jp/html/21131.html
Q Edge of Existence | 記憶の最果て | no | T obj.バタリア丘陵.Cavernous_Maw
MN WotG40 40
LK condition:前節「鳥籠の宇宙」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Edge_of_Existence;禁断の口はバタリア丘陵 H-5、ロランベリー耕地 H-6（FFXIclopedia も同じ）、ソロムグ原野 J-10（FFXIclopedia は K-9）。現代でも過去でもよい
g01 go - | ジュノのまわりの3つの禁断の口のどれかへ行く | 現代の口でも過去の口でもよい。行き先を聞かれたら一度やめて、もう一度調べるとイベントになることがある。 | @バタリア丘陵 | > a01,b01,c01
a01 examine - | バタリア丘陵(H-5)のCavernous Mawを調べてイベントを見ると完了 | - | @バタリア丘陵 H-5 | T obj.バタリア丘陵.Cavernous_Maw | R バタリア丘陵から
b01 examine - | ロランベリー耕地(H-6)のCavernous Mawを調べてイベントを見ると完了 | - | @ロランベリー耕地 H-6 | T obj.ロランベリー耕地.Cavernous_Maw | R ロランベリー耕地から
c01 examine - | ソロムグ原野のCavernous Mawを調べてイベントを見ると完了 | - | @ソロムグ原野 J-10 K-9 | T obj.ソロムグ原野.Cavernous_Maw | R ソロムグ原野から

@ mission.altana.041 https://wiki.ffo.jp/html/21135.html
Q Her Memories | 彼女の想ひ出 | no
MN WotG41 41
LK condition:前節「記憶の最果て」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Her_Memories;4つの Large memory fragment を集める。帰郷（3つの小さなかけらで1つ）、不治の病、キューピッド作戦、過去の所属国の足跡のクエスト（FFXIclopedia も同じ）。不治の病はヴァナ時間で1日待つので先に始めるとよい
g01 go - | 「彼女の想ひ出～不治の病」を終えて、だいじなもの「想ひ出のかけら」をもらう | ヴァナ時間で1日待つところがあるので、先に始めるとよい。賢者の石が要る。 | @南サンドリア G-6 | T npc.230.Amaura
g02 go - | 「彼女の想ひ出～帰郷」を終えて、だいじなもの「想ひ出のかけら」をもらう | 現代の東ロンフォールから歩いて南サンドリアに入ると始まる。「涙の豆料理」「彼と少女の事情」「墓前の決意」の3つで小さなかけらがそろう。ライラックが要る。 | @南サンドリア
g03 go - | 「彼女の想ひ出～キューピッド作戦」を終えて、だいじなもの「想ひ出のかけら」をもらう | ジャグナー森林〔Ｓ〕からバタリア丘陵〔Ｓ〕に入ると始まる。ライスビネガー・ねりわさび・ホーリーバジルが要る。 | @バタリア丘陵〔Ｓ〕
g04 go - | 過去の所属国の「彼女の想ひ出～紅の足跡」「彼女の想ひ出～蒼の足跡」「彼女の想ひ出～翠の足跡」のどれかを終えて、4つ目の「想ひ出のかけら」をもらうと完了 | 所属国のとなりの〔Ｓ〕のエリアから歩いて町に入ると始まる。所属国のキャンペーン任務を受けていると始まらない。4つの順番は自由。

@ mission.altana.042 https://wiki.ffo.jp/html/21172.html
Q Forget Me Not | 揺籃の宙 | no | T obj.バタリア丘陵.Cavernous_Maw
MN WotG42 42
LK condition:前節「彼女の想ひ出」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Forget_Me_Not;禁断の口はバタリア丘陵 H-5、ロランベリー耕地 H-6（FFXIclopedia も同じ）、ソロムグ原野 J-10（FFXIclopedia は K-9）。現代でも過去でもよい。イベントでグロウベルグ〔Ｓ〕のケット・シーと会う
g01 go - | ジュノのまわりの3つの禁断の口のどれかへ行く | 現代の口でも過去の口でもよい。ウォークオブエコーズに入ってもイベントは起きない。行き先を聞かれたら一度やめて、もう一度調べる。 | @バタリア丘陵 | > a01,b01,c01
a01 examine - | バタリア丘陵(H-5)のCavernous Mawを調べてイベントを見ると完了 | - | @バタリア丘陵 H-5 | T obj.バタリア丘陵.Cavernous_Maw | R バタリア丘陵から
b01 examine - | ロランベリー耕地(H-6)のCavernous Mawを調べてイベントを見ると完了 | - | @ロランベリー耕地 H-6 | T obj.ロランベリー耕地.Cavernous_Maw | R ロランベリー耕地から
c01 examine - | ソロムグ原野のCavernous Mawを調べてイベントを見ると完了 | - | @ソロムグ原野 J-10 K-9 | T obj.ソロムグ原野.Cavernous_Maw | R ソロムグ原野から

@ mission.altana.043 https://wiki.ffo.jp/html/21173.html
Q Pillar of Hope | 光陰の御許に | no | T obj.グロウベルグ〔Ｓ〕.Veridical_Conflux = obj:Veridical Conflux@グロウベルグ〔Ｓ〕 F-5
MN WotG43 43
LK condition:前節「揺籃の宙」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pillar_of_Hope;武器と盾を全部はずしてグロウベルグ〔Ｓ〕F-5 の幽境の沢の Veridical Conflux を調べる（FFXIclopedia も F-5）。キャンペーンのワープか Survival Guide が近い。風水士は遠隔もはずす必要があることがある（FFXIclopedia）
g01 examine - | 武器と盾をはずして、グロウベルグ〔Ｓ〕(F-5)の幽境の沢のVeridical Confluxを調べてイベントを見ると完了 | 武器をつけたまま調べたら、はずしてもう一度調べる。露光蟲があれば禁断の口の横の???からウォークオブエコーズへ行き、すぐ後ろのVeridical Confluxで幽境の沢へ出ると近い。 | @グロウベルグ〔Ｓ〕 F-5 | T obj.グロウベルグ〔Ｓ〕.Veridical_Conflux

@ mission.altana.044 https://wiki.ffo.jp/html/21174.html
Q Glimmer of Life | さかしまの時 | no | T obj.グロウベルグ〔Ｓ〕.Veridical_Conflux
MN WotG44 44
LK condition:前節「光陰の御許に」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Glimmer_of_Life;ヴァナ時間で1日待ってエリアを出入りしてから、Veridical Conflux F-5 を調べる（FFXIclopedia も同じ。武器はつけたままでよい）
g01 go - | エリアを出入りして、ヴァナ時間の0時を過ぎるまで待つ | 待つ間に、次の節で要る鑽孔蟲を取っておくとよい。 | W ヴァナ時間の0時を過ぎてから
g02 examine - | グロウベルグ〔Ｓ〕(F-5)のVeridical Confluxを調べてイベントを見ると完了 | 武器はつけたままでよい。イベントが出ないときはもう一度調べる。 | @グロウベルグ〔Ｓ〕 F-5 | T obj.グロウベルグ〔Ｓ〕.Veridical_Conflux

@ mission.altana.045 https://wiki.ffo.jp/html/22369.html
Q Time Slips Away | 霧らふ世界 | no | T obj.グロウベルグ〔Ｓ〕.Veridical_Conflux
MN WotG45 45
RW key_item:鑽孔蟲のフラスコ
LK condition:前節「さかしまの時」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Time_Slips_Away;鑽孔蟲はパシュハウ沼〔Ｓ〕の Lou Carcolh と Ancient・Gold・Vajra Quadav、ベドー〔Ｓ〕の Ancient・Gold・Vajra Quadav が落とす（FFXIclopedia も同じ）。Veridical Conflux F-5 にトレード
g01 gather - | パシュハウ沼〔Ｓ〕のベドーの入口近くか、ベドー〔Ｓ〕のクゥダフやスラッグから鑽孔蟲を取る | - | @パシュハウ沼〔Ｓ〕
g02 trade - | グロウベルグ〔Ｓ〕(F-5)のVeridical Confluxに鑽孔蟲をトレードしてイベントを見て、だいじなもの「鑽孔蟲のフラスコ」をもらうと完了 | - | @グロウベルグ〔Ｓ〕 F-5 | T obj.グロウベルグ〔Ｓ〕.Veridical_Conflux | N 鑽孔蟲*1

@ mission.altana.046 https://wiki.ffo.jp/html/22370.html
Q When Wills Collide | 夢見果てし時 | no | T obj.ウォークオブエコーズ.Ornate_Door
MN WotG46 46
RW title:盤上の覇者
LK condition:前節「霧らふ世界」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/When_Wills_Collide;Veridical Conflux F-5 からウォークオブエコーズへ入り、北の Ornate Door を調べてイベント、もう一度調べて BF。相手は4人の冥護四衆で、全員倒すと勝ち。入るときに鑽孔蟲のフラスコはなくなる。負けたら鑽孔蟲をまたトレードする（ヴァナ時間で1日に1回）。称号 Vanquisher of Spite は FFXIclopedia のみ
g01 go - | グロウベルグ〔Ｓ〕(F-5)のVeridical Confluxを調べてウォークオブエコーズに入る | - | @グロウベルグ〔Ｓ〕 F-5 | T obj.グロウベルグ〔Ｓ〕.Veridical_Conflux
g02 examine - | 北の階段の上のOrnate Doorを調べてイベントを見る | - | @ウォークオブエコーズ | T obj.ウォークオブエコーズ.Ornate_Door
g03 fight - | もう一度Ornate Doorを調べてBF「夢見果てし時」に入り、4人の敵を全部倒すと完了 | 6人・30分・フェイス可。入ると強化は消え、フラスコもなくなる。負けたら鑽孔蟲をまたVeridical Confluxにトレードする（ヴァナ時間で1日に1回）。4人目は始めた人と同じ武器の技を使う。 | @ウォークオブエコーズ | T obj.ウォークオブエコーズ.Ornate_Door | K 鑽孔蟲のフラスコ

@ mission.altana.047 https://wiki.ffo.jp/html/22371.html
Q Whispers of Dawn | 映りしは、暁の | no | T obj.グロウベルグ〔Ｓ〕.Veridical_Conflux
MN WotG47 47
RW title:翼を抱きし者
LK condition:前節「夢見果てし時」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Whispers_of_Dawn;武器をはずして Veridical Conflux F-5 を調べる。称号 Mender of Wings（FFXIclopedia も同じ）
g01 go - | ウォークオブエコーズの階段を下りたVeridical Confluxで、グロウベルグ〔Ｓ〕の幽境の沢へ戻る | - | @ウォークオブエコーズ
g02 examine - | 武器と盾をはずして、グロウベルグ〔Ｓ〕(F-5)のVeridical Confluxを調べてイベントを見ると完了 | 武器をつけたまま調べたら、はずしてもう一度調べる。 | @グロウベルグ〔Ｓ〕 F-5 | T obj.グロウベルグ〔Ｓ〕.Veridical_Conflux

@ mission.altana.048 https://wiki.ffo.jp/html/22372.html
Q A Dreamy Interlude | 瞼に見るもの | no | T obj.グロウベルグ〔Ｓ〕.Veridical_Conflux
MN WotG48 48
LK condition:前節「映りしは、暁の」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Dreamy_Interlude;エリアを出入りしてヴァナ時間で1日待ち、Veridical Conflux F-5 を調べる（FFXIclopedia も同じ）。短いイベントだけなら、もう1日待つ
g01 go - | エリアを出入りして、ヴァナ時間の0時を過ぎるまで待つ | ウォークオブエコーズに入って戻るのでもよい。 | W ヴァナ時間の0時を過ぎてから
g02 examine - | グロウベルグ〔Ｓ〕(F-5)のVeridical Confluxを調べてイベントを見ると完了 | 短いイベントしか出ないときは、もう一度エリアを出入りして1日待つ。 | @グロウベルグ〔Ｓ〕 F-5 | T obj.グロウベルグ〔Ｓ〕.Veridical_Conflux

@ mission.altana.049 https://wiki.ffo.jp/html/22373.html
Q Cait in the Woods | 羅針の行方 | no
MN WotG49 49
RW key_item:黎明の雫
LK condition:前節「瞼に見るもの」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Cait_in_the_Woods;東ロンフォール〔Ｓ〕H-7 の北西の、川ぞいの木のそばの光る場所（FFXIclopedia も H-7）。Ronfaure dawndrop をもらう
g01 examine - | 東ロンフォール〔Ｓ〕(H-7)の北西、川ぞいの木のそばの光る場所を調べてイベントを見て、だいじなもの「黎明の雫」をもらうと完了 | - | @東ロンフォール〔Ｓ〕 H-7

@ mission.altana.050 https://wiki.ffo.jp/html/22374.html
Q Fork in the Road | 轍辿りて | no
MN WotG50 50
RW key_item:原初の輝き
LK condition:前節「羅針の行方」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Fork_in_the_Road;ロンフォールのほか7か所の光る場所を調べて、8つの dawndrop を集めると Primal glow になる。ジャグナー森林〔Ｓ〕I-6（FFXIclopedia は H-6 と I-6 の境）、ラヴォール村〔Ｓ〕K-9、南サンドリア〔Ｓ〕K-6、ボスディン氷河〔Ｓ〕H-9、ザルカバード〔Ｓ〕F-8 の Rally Point: Red の横、王の間〔Ｓ〕、ウォークオブエコーズ。次がグロウベルグ〔Ｓ〕なので、ウォークオブエコーズを最後にするとよい
g01 examine - | 南サンドリア〔Ｓ〕(K-6)の獅子の泉の入口の左横の光る場所を調べてイベントを見る | 7か所の順番は自由。ウォークオブエコーズを最後にすると次の節が近い。 | @南サンドリア〔Ｓ〕 K-6
g02 examine - | ラヴォール村〔Ｓ〕(K-9)の南東、家の横の光る場所を調べてイベントを見る | ジャグナー森林〔Ｓ〕のSurvival Guideが近い。 | @ラヴォール村〔Ｓ〕 K-9
g03 examine - | ジャグナー森林〔Ｓ〕の、湖と川の境の木の根元の光る場所を調べてイベントを見る | 東ロンフォール〔Ｓ〕のSurvival Guideから橋を渡ると近い。 | @ジャグナー森林〔Ｓ〕 H-6 I-6
g04 examine - | ボスディン氷河〔Ｓ〕(H-9)のキャンペーンの拠点から南西の坂を下りた所の光る場所を調べてイベントを見る | - | @ボスディン氷河〔Ｓ〕 H-9
g05 examine - | ザルカバード〔Ｓ〕(F-8)のRally Point: Redの横の光る場所を調べてイベントを見る | - | @ザルカバード〔Ｓ〕 F-8
g06 examine - | 王の間〔Ｓ〕の高い通路の広場の端の光る場所を調べてイベントを見る | ズヴァール城内郭〔Ｓ〕のHome Pointが近い。 | @王の間〔Ｓ〕
g07 examine - | ウォークオブエコーズの、Veridical Confluxの後ろの途切れた階段の光る場所を調べてイベントを見る | グロウベルグ〔Ｓ〕(F-5)のVeridical Confluxから入る。 | @ウォークオブエコーズ
g08 go - | 8つの雫がそろうと、だいじなもの「原初の輝き」になって完了 | -

@ mission.altana.051 https://wiki.ffo.jp/html/22375.html
Q Maiden of the Dusk | 翼もつ女神 | no | T obj.ウォークオブエコーズ.Ornate_Door
MN WotG51 51
LK condition:前節「轍辿りて」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Maiden_of_the_Dusk;Veridical Conflux F-5 を調べてイベントでウォークオブエコーズへ、北の Ornate Door を調べてイベント、もう一度調べて BF。相手はリリスで2段階。報酬 Moonshade earring は BG Wiki・FFXIclopedia ではこの節
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/Maiden_of_the_Dusk;星唄ミッションの進み方によって、この節のあと星唄の A Forbidden Reunion か Champion of the Dawn を終えるまで先へ進めなくなる、とある。入るときに原初の輝きはなくなり、負けたら Veridical Conflux でもらい直す（ヴァナ時間で1日に1回）
g01 examine - | グロウベルグ〔Ｓ〕(F-5)のVeridical Confluxを調べてイベントを見て、ウォークオブエコーズへ入る | 前の節でウォークオブエコーズにいたら、一度出てから調べる。星唄ミッションのイベントが先に出ることがある。 | @グロウベルグ〔Ｓ〕 F-5 | T obj.グロウベルグ〔Ｓ〕.Veridical_Conflux
g02 examine - | 北のOrnate Doorを調べてイベントを見る | - | @ウォークオブエコーズ | T obj.ウォークオブエコーズ.Ornate_Door
g03 fight - | もう一度Ornate Doorを調べてBF「翼もつ女神」に入り、2段階のリリスに勝つと完了 | 30分・フェイス可。BFは1つだけなので、ほかのパーティーがいると待つ。入ると強化は消え、原初の輝きもなくなる。負けたらヴァナ時間の0時のあとVeridical Confluxでもらい直す。 | @ウォークオブエコーズ | T obj.ウォークオブエコーズ.Ornate_Door | K 原初の輝き

@ mission.altana.052 https://wiki.ffo.jp/html/22376.html
Q Where It All Began | はじまりの地 | no | T obj.南サンドリア〔Ｓ〕.Door_Lion_Springs
MN WotG52 52
RW key_item:リリゼットの耳飾り
RW key_item:結婚式招待状
LK condition:前節「翼もつ女神」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Where_It_All_Began;獅子の泉の扉 K-6 を調べてイベント、Wedding invitation をもらう（FFXIclopedia も K-6）
g01 go - | BF「翼もつ女神」のあとのイベントで、だいじなもの「リリゼットの耳飾り」をもらう | -
g02 examine - | 南サンドリア〔Ｓ〕(K-6)の獅子の泉の扉を調べてイベントを見て、だいじなもの「結婚式招待状」をもらうと完了 | - | @南サンドリア〔Ｓ〕 K-6 | T obj.南サンドリア〔Ｓ〕.Door_Lion_Springs

@ mission.altana.053 https://wiki.ffo.jp/html/22377.html
Q A Token of Troth | 約束の刻 | no | T obj.ソロムグ原野〔Ｓ〕.Bulwark_Gate
MN WotG53 53
RW title:アルタナの神兵
LK condition:前節「はじまりの地」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Token_of_Troth;武器をはずして Bulwark Gate を調べてイベント、もう一度調べてイベント。Bulwark Gate は E-6（FFXIclopedia は座標なし）。称号 Champion of the Dawn は BG Wiki では次の節
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/A_Token_of_Troth;称号 Champion of the Dawn はこの節。Atma of a Future Fabulous が買えるようになる
g01 examine - | 武器と盾をはずして、ソロムグ原野〔Ｓ〕のジュノへの門のBulwark Gateを調べてイベントを見る | 武器をつけたまま調べたら、はずしてもう一度調べる。 | @ソロムグ原野〔Ｓ〕 E-6 F-6 | T obj.ソロムグ原野〔Ｓ〕.Bulwark_Gate
g02 examine - | もう一度Bulwark Gateを調べてイベントを見ると完了 | - | @ソロムグ原野〔Ｓ〕 E-6 F-6 | T obj.ソロムグ原野〔Ｓ〕.Bulwark_Gate

@ mission.altana.054 https://wiki.ffo.jp/html/22378.html
Q Lest We Forget | 忘らるる君へ | no | T obj.グロウベルグ〔Ｓ〕.Veridical_Conflux
MN WotG54 54
RW item:胡蝶のイヤリング
LK condition:前節「約束の刻」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Lest_We_Forget;Veridical Conflux F-5 を調べてイベント、Moonshade Earring の2つのオーグメントを選ぶ（FFXIclopedia も同じ）。オーグメントは1つ目が命中・攻撃・飛命・飛攻・魔命・魔攻・HP・MP、2つ目がリゲイン・リフレシュ・TPボーナスなど
g01 examine - | グロウベルグ〔Ｓ〕(F-5)のVeridical Confluxを調べてイベントを見る | - | @グロウベルグ〔Ｓ〕 F-5 | T obj.グロウベルグ〔Ｓ〕.Veridical_Conflux
g02 talk - | 胡蝶のイヤリングにつける2つのオーグメントを選び、「はい」で受け取ると完了 | ミッションはこのあとも一覧に残る。 | @グロウベルグ〔Ｓ〕 F-5
