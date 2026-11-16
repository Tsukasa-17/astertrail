# ノーグのクエスト（0.1.74〜）。用語辞典の各記事を読んで書き直したもの。
# 番号：001〜024 は基礎シート「クエスト一覧」の420〜443行、025 は654行。
# 座標は BG Wiki と FFXIclopedia が一致したもの、または FFXIclopedia に無く BG Wiki にあるもの。名声は BG Wiki（ノーグの名声＝天晶堂の名声）。

@ quest.norg.001 https://wiki.ffo.jp/html/24842.html
Q Voidwatch Ops: Border Crossing | VW作戦の表裏 | no | T npc.252.Kieran = npc:Kieran@ノーグ H-8/I-8
RW key_item:六芒星の灰白色のジェイド
LK condition:Lv75以上で、だいじなもの「冒険者の証」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Voidwatch_Ops:_Border_Crossing;Kieran は I-8（「VW作戦第130計画トゥー・リア」では H-8、FFXIclopedia は H-8/I-8）。Hildegard カザム F-9、Gushing Spring ラバオ G-8
g01 talk - | Lv75以上でノーグ(I-8テンキー7)簡易倉庫前のKieranに話し、「六芒星の灰白色のジェイド」をもらう | 「彼方よりの使者」から始まるヴォイドウォッチとは別の道で、いきなりここから始めてよい。 | @ノーグ H-8/I-8 | T npc.252.Kieran
g02 talk - | カザム(F-9)のHildegardに話し、「VW作戦第250計画エルシモ島」を受ける | ヴォイドウォーカーを倒す前に必ず話しておく。先に倒しても数に入らない。 | @カザム F-9 | T npc.250.Hildegard = npc:Hildegard@カザム F-9
g03 talk - | ラバオ(G-8)のGushing Springに話し、「VW作戦第247計画ゼプウェル島」を受ける | こちらも倒す前に話しておく。 | @ラバオ G-8 | T npc.247.Gushing_Spring = npc:Gushing Spring@ラバオ G-8
g04 go - | 「VW作戦第250計画エルシモ島」と「VW作戦第247計画ゼプウェル島」をクリアする | 2つの中身はそれぞれのクエストの手順にある。
g05 talk - | ノーグのKieranに話して完了 | このあとGilgameshに話してからKieranに話すと「VW作戦第121計画リ・テロア」になる。 | @ノーグ H-8/I-8 | T npc.252.Kieran

@ quest.norg.002 https://wiki.ffo.jp/html/25063.html
Q VW Op. #115: Li'Telor Variant | VW作戦第121計画リ・テロア | no | T npc.252.Kieran
RW key_item:六芒星の灰白色のジェイドIII
LK quest:クエスト「VW作戦の表裏」をコンプリート
LK condition:トゥー・リアに行ける（ジラートミッション「アーク・エンジェル」を受けている）
XS BG Wiki;https://www.bg-wiki.com/ffxi/VW_Op._115:_Li%27Telor_Variant;ヴォイドウォーカーの出る場所：Cath Palug 聖地ジ・タ E-9・F-8・G-10、Modron ボヤーダ樹 MAP1 G-5・K-8／MAP2 F-7、Mimic King ロ・メーヴ E-7・I-9・K-7
g01 talk - | ノーグのGilgameshに話す | 「VW作戦の表裏」のあと。 | @ノーグ L-8 | T npc.252.Gilgamesh
g02 talk - | ノーグのKieranに話して受け、「六芒星の灰白色のジェイドII」をもらう | トゥー・リアに行けないと受けられない。 | @ノーグ H-8/I-8 | T npc.252.Kieran
g03 fight - | 聖地ジ・タのヴォイドウォーカー「Cath Palug」を倒す | 出る場所は E-9・F-8・G-10 のどれか。 | @聖地ジ・タ | T mob.121.Cath_Palug = mob:Cath Palug@聖地ジ・タ
g04 fight - | ボヤーダ樹のヴォイドウォーカー「Modron」を倒す | 出る場所は MAP1 の G-5・K-8、MAP2 の F-7 のどれか。 | @ボヤーダ樹 | T mob.153.Modron = mob:Modron@ボヤーダ樹
g05 fight - | ロ・メーヴのヴォイドウォーカー「Mimic King」を倒す | 出る場所は E-7・I-9・K-7 のどれか。 | @ロ・メーヴ | T mob.122.Mimic_King = mob:Mimic King@ロ・メーヴ
g06 talk - | 3体を倒したらKieranに話して完了 | そのまま「VW作戦第130計画トゥー・リア」になる。 | @ノーグ H-8/I-8 | T npc.252.Kieran

@ quest.norg.003 https://wiki.ffo.jp/html/25106.html
Q Skyward Ho, Voidwatcher! | VW作戦第130計画トゥー・リア | no | T npc.252.Kieran
LK quest:クエスト「VW作戦第121計画リ・テロア」をコンプリート（自動で受ける）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Skyward_Ho,_Voidwatcher!;ヴォイドウォーカーの出る場所：Aello ル・オンの庭 G-5・I-11・J-6、Qilin ル・アビタウ神殿 MAP2 F-6・F-9・J-6、Uptala ヴェ・ルガノン宮殿 D-5・G-13・M-8。先にKieranに話さないとGilgameshのイベントが出ない
g01 go - | 「VW作戦第121計画リ・テロア」を終えると自動で受け、「六芒星の灰白色のジェイドIII」を持っている | - | K 六芒星の灰白色のジェイドIII
g02 fight - | ル・オンの庭のヴォイドウォーカー「Aello」を倒す | 出る場所は G-5・I-11・J-6 のどれか。 | @ル・オンの庭 | T mob.ル・オンの庭.Aello = mob:Aello@ル・オンの庭
g03 fight - | ヴェ・ルガノン宮殿のヴォイドウォーカー「Uptala」を倒す | 出る場所は D-5・G-13・M-8 のどれか。 | @ヴェ・ルガノン宮殿 | T mob.177.Uptala = mob:Uptala@ヴェ・ルガノン宮殿
g04 fight - | ル・アビタウ神殿のヴォイドウォーカー「Qilin」を倒す | 出る場所は MAP2 の F-6・F-9・J-6 のどれか。 | @ル・アビタウ神殿 | T mob.ル・アビタウ神殿.Qilin = mob:Qilin@ル・アビタウ神殿
g05 talk - | 3体を倒したらノーグのKieranに話す | 先にGilgameshに話してしまったら、エリアを出入りしてからKieranに話し直す。 | @ノーグ H-8/I-8 | T npc.252.Kieran
g06 talk - | ノーグのGilgameshに報告して完了 | ジラートのヴォイドウォッチはこれで終わり。 | @ノーグ L-8 | T npc.252.Gilgamesh

@ quest.norg.004 https://wiki.ffo.jp/html/8933.html
Q Forge Your Destiny | ある刀鍛冶の依頼 | no | T npc.252.Jaucribaix = npc:Jaucribaix@ノーグ K-8
RW item:無銘刀
RW title:ブシドー・ザ・ブレード
RW other:侍にジョブチェンジできるようになる
LK condition:Lv30以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Forge_Your_Destiny;Ranemaud I-7、Aeka I-8。Forger はコンシュタット高地 D-8 の洞窟、Guardian Treant は聖地ジ・タ L-9（K-10 の北から入る）
g01 talk - | Lv30以上でノーグ(K-8)のJaucribaixに話して受ける | - | @ノーグ K-8 | T npc.252.Jaucribaix
g02 talk - | ノーグ(I-7)のRanemaudに話し、「神木の新芽」をもらう | なくしたら、金鉱2個と白金鉱1個を渡すとまたもらえる。 | @ノーグ I-7 | T npc.252.Ranemaud = npc:Ranemaud@ノーグ I-7
g03 talk - | ノーグ(I-8)のAekaに話し、「東方の古鉄」をもらう | なくしたら、黒鉄鉱1個を渡すとまたもらえる。 | @ノーグ I-8 | T npc.252.Aeka = npc:Aeka@ノーグ I-8
g04 trade - | コンシュタット高地(D-8)の洞窟の???に「東方の古鉄」をトレードする | ウォンテッドエリアへ移動の(G-7)か、Survival Guideの(G-3)から近い。 | @コンシュタット高地 D-8 | T obj.108.???_D-8 = obj:???@コンシュタット高地 D-8 | N 東方の古鉄*1
g05 fight - | 出てきたボムNM「Forger」を倒して「ボムの卸し鉄」を手に入れる | 負けると「東方の古鉄」がなくなる。 | @コンシュタット高地 D-8 | T mob.108.Forger = mob:Forger@コンシュタット高地 D-8
g06 trade - | 聖地ジ・タ(L-9)の木の幹の???に「まさかり」をトレードする | 木のこぶの上に乗ってトレードする。K-10 の北の地図の外から入る。 | @聖地ジ・タ L-9 | T obj.121.???_L-9 = obj:???@聖地ジ・タ L-9 | N まさかり*1
g07 fight - | 出てきた樹人族NM「Guardian Treant」を倒す | Lv30のソロでも倒せる。フェイスは出してからトレードする。 | @聖地ジ・タ L-9 | T mob.121.Guardian_Treant = mob:Guardian Treant@聖地ジ・タ L-9
g08 trade - | もう一度???に「神木の新芽」をトレードして「聖地の木の枝」を手に入れる | - | @聖地ジ・タ L-9 | T obj.121.???_L-9 | N 神木の新芽*1
g09 trade - | ノーグのJaucribaixに「ボムの卸し鉄」と「聖地の木の枝」をトレードする | - | @ノーグ K-8 | T npc.252.Jaucribaix | N ボムの卸し鉄*1,聖地の木の枝*1
g10 talk - | ヴァナ時間で3日たってからJaucribaixに話して完了 | - | @ノーグ K-8 | T npc.252.Jaucribaix | W ヴァナ時間で3日たってから

@ quest.norg.005 https://wiki.ffo.jp/html/5467.html
Q Everyone's Grudge | みんなのうらみ | yes | T npc.252.Magephaud = npc:Magephaud@ノーグ I-8
RW key_item:ウガレピ寺院小部屋のカギ
RW title:トンベリ博士
RW other:ウガレピ寺院のTonberry Priestに、たまったトンベリのうらみを解いてもらえるようになる
LK fame:ノーグの名声ランク2以上
LK condition:トンベリ族を倒したことがある
XS BG Wiki;https://www.bg-wiki.com/ffxi/Everyone%27s_Grudge;名声 Outlands 2、くり返し可。うらみを解くのは 250〜6,000ギル
g01 talk - | ノーグ(I-8)中央階段下のMagephaudに話して受ける | トンベリ族を倒したことがないと受けられない。 | @ノーグ I-8 | T npc.252.Magephaud
g02 gather - | 「獣人金貨」を3枚用意する | - | N 獣人金貨*3
g03 trade - | Magephaudに「獣人金貨」3枚をトレードして完了 | うらみを解くには、ウガレピ寺院MAP1(F-11)の隠し扉をカギで開け、中のTonberry Priestにギルを払う。 | @ノーグ I-8 | T npc.252.Magephaud | N 獣人金貨*3

@ quest.norg.006 https://wiki.ffo.jp/html/6481.html
Q The Sahagin's Stash | サハギンの宝物庫 | no | T npc.252.Laisrean = npc:Laisrean@ノーグ H-7
RW item:空蝉の術:壱
RW title:宝物庫あらし
LK fame:ノーグの名声ランク4以上
LK condition:レベルが一定以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Sahagin%27s_Stash;Laisrean H-7（用語辞典は冒頭で I-7、手順では H-7）。銀の扉は3回調べてから獣人銀貨をトレード（銀貨はなくならない）
g01 talk - | ノーグ(H-7)簡易倉庫のLaisreanに話して受ける | - | @ノーグ H-7 | T npc.252.Laisrean
g02 trade - | 海蛇の岩窟の最初の地図(N-14)の扉を3回調べ、「獣人銀貨」をトレードして開ける | 銀貨はなくならない。ノーグからは H-6 で東、J-5 で南、J-10 で東へ進む。 | @海蛇の岩窟 N-14 | N 獣人銀貨*1
g03 go - | 次の地図を北へ進み、(H-8)の崖から下の道へ飛び降りる | 中の敵は見て気づかないので、スニークだけで行ける。 | @海蛇の岩窟 H-8
g04 examine - | 北へ進み、(H-3)の???を調べてだいじなもの「海龍の像」を手に入れる | - | @海蛇の岩窟 H-3 | T obj.176.???_H-3 = obj:???@海蛇の岩窟 H-3
g05 talk - | ノーグのLaisreanに話して完了 | - | @ノーグ H-7 | T npc.252.Laisrean | K 海龍の像

@ quest.norg.007 https://wiki.ffo.jp/html/6291.html
Q Black Market | ブラックマーケット | yes | T npc.252.Muzaffar = npc:Muzaffar@ノーグ I-8
RW gil:北方の毛皮4個で1,500ギル／東方の磁器4個で2,000ギル／南方の木乃伊4個で3,000ギル
RW title:闇ブローカー
RW other:ノーグの名声が上がる
g01 talk - | ノーグ(I-8)荷物置き場のMuzaffarに話して受ける | - | @ノーグ I-8 | T npc.252.Muzaffar
g02 gather - | 「北方の毛皮」「東方の磁器」「南方の木乃伊」のどれかを4個用意する | 北方の毛皮はクフィム島のGiant Hunterやデルクフの塔のGiant Lobber、東方の磁器はガルレージュ要塞とフェ・インのClockwork Pod、南方の木乃伊は西アルテパ砂漠のLichが落とす。競売でも買える。
g03 trade - | Muzaffarに同じ品を4個トレードして完了 | 何度でもできる。 | @ノーグ I-8 | T npc.252.Muzaffar

@ quest.norg.008 https://wiki.ffo.jp/html/8402.html
Q A Thief in Norg!? | 先代の遺品 | no | T npc.252.Jaucribaix
RW item:明珍桃形兜
RW title:無双なる大武士
LK quest:クエスト「黄泉送り」をコンプリートし、エリアを出入りして1分たつ
LK condition:侍で話す
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Thief_in_Norg!%3F;Sanosuke ジュノ港 H-8、Phoochuchu マウラ H-8（橋の下）、バストゥーク鉱山区 J-6 の扉は閉まっているときに調べる
g01 talk - | 侍でノーグ(K-8)のJaucribaixに話して受ける | 「黄泉送り」のあと、エリアを出入りして1分たってから。 | @ノーグ K-8 | T npc.252.Jaucribaix
g02 talk - | マウラ(H-8)の橋の下のPhoochuchuに話す | - | @マウラ H-8 | T npc.249.Phoochuchu = npc:Phoochuchu@マウラ H-8
g03 talk - | ジュノ港(H-8)の免税店の中のSanosukeに話す | - | @ジュノ港 H-8 | T npc.246.Sanosuke = npc:Sanosuke@ジュノ港 H-8
g04 examine - | バストゥーク鉱山区(J-6)錬金術ギルド手前のDoor: Houseを調べる | 扉が閉まっているときに調べる。ほかの人が開けているとイベントが出ない。 | @バストゥーク鉱山区 J-6 | T obj.234.Door_House_J-6 = obj:Door: House@バストゥーク鉱山区 J-6
g05 go - | パルブロ鉱山の上の階からワールンの祠に入ってイベントを見る | - | @ワールンの祠
g06 talk - | ノーグのJaucribaixに話し、「破魔の御守」をもらう | なくしてもまたもらえる。 | @ノーグ K-8 | T npc.252.Jaucribaix
g07 fight - | ワールンの祠のBurning Circleに「破魔の御守」をトレードし、BF「先代の遺品」でGaki・Rasetsu・Onkiに勝つ | 6人・30分・レベル制限なし・フェイス可。黒魔道士タイプのGakiはサイレスが効かないので最初に倒す。勝つとだいじなもの「壊れた兜」が手に入る。 | @ワールンの祠 | T obj.ワールンの祠.Burning_Circle | N 破魔の御守*1
g08 trade - | ノーグのJaucribaixに話して「金糸」をトレードする | 破魔の御守は捨ててよい。 | @ノーグ K-8 | T npc.252.Jaucribaix | N 金糸*1 | K 壊れた兜
g09 talk - | エリアを出入りして1分たってからJaucribaixに話して完了 | - | @ノーグ K-8 | T npc.252.Jaucribaix

@ quest.norg.009 https://wiki.ffo.jp/html/2941.html
Q The Potential Within | 内に眠る力 | no | T npc.252.Jaucribaix
RW other:両手刀のウェポンスキル「九之太刀・花車」
LK condition:Lv71以上の侍で、両手刀スキル250以上
LK condition:ほかのウェポンスキルのクエストを受けていない
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Potential_Within;???はクフタルの洞門 L-7（最初の分かれ道を北へ、I-5 から南東の通路）
g01 talk - | Lv71以上の侍でノーグ(K-8)2階廊下奥のJaucribaixに話し、「試練の太刀」をもらう | 両手刀スキル250以上。ほかのウェポンスキルのクエストを受けていたらやめてから。 | @ノーグ K-8 | T npc.252.Jaucribaix
g02 gather - | 「試練の太刀」を装備して戦い、潜在能力を消す | - | N 試練の太刀*1
g03 trade - | Jaucribaixに「試練の太刀」をトレードし、だいじなもの「試練の地図」をもらう | - | @ノーグ K-8 | T npc.252.Jaucribaix | N 試練の太刀*1
g04 examine - | テリガン岬(G-10)からクフタルの洞門に入った最初の地図(L-7)の???を調べる | - | @クフタルの洞門 L-7 #2 | T obj.174.???_L-7 = obj:???@クフタルの洞門 L-7 #2
g05 fight - | 出てきた甲虫族NM「Kettenkaefer」を倒す | ディスペルやイレースがあると楽。Lv90ならジョブによってはソロでも倒せる。 | @クフタルの洞門 L-7 #2 | T mob.174.Kettenkaefer = mob:Kettenkaefer@クフタルの洞門 L-7 #2
g06 examine - | もう一度???を調べてだいじなもの「試練の書」を手に入れる | 調べ忘れに注意。 | @クフタルの洞門 L-7 #2 | T obj.174.???_L-7
g07 talk - | ノーグのJaucribaixに話して完了 | - | @ノーグ K-8 | T npc.252.Jaucribaix | K 試練の書

@ quest.norg.010 https://wiki.ffo.jp/html/12512.html
Q It's Not Your Vault | 占拠された倉庫 | no | T npc.252.Keal = npc:Keal@ノーグ H-8!
RW item:遁甲の術:壱
LK fame:ノーグの名声ランク3以上
LK condition:Lv5以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/It%27s_Not_Your_Vault;名声 Outlands 3、Lv5。Keal は Survival Guide のあたりを歩いている
g01 talk - | ノーグ(H-8)のKealに話して受ける | Survival Guide のあたりを歩いている。 | @ノーグ H-8 | T npc.252.Keal
g02 go - | 海蛇の岩窟に入り、右手の壁ぞいに進む | H-7 で西、F-7 で南、B-7 で北へ曲がる。帰りは左手の壁ぞいに戻ればノーグへ着く。 | @海蛇の岩窟
g03 examine - | 海蛇の岩窟(C-5)の部屋の???を調べてだいじなもの「封のされた箱」を手に入れる | - | @海蛇の岩窟 C-5 | T obj.176.???_C-5 = obj:???@海蛇の岩窟 C-5
g04 talk - | ノーグのKealに話して完了 | - | @ノーグ H-8 | T npc.252.Keal | K 封のされた箱

@ quest.norg.011 https://wiki.ffo.jp/html/7570.html
Q Mama Mia | 大いなる力宿るモノ | - | T npc.252.Mamaulabion = npc:Mamaulabion@ノーグ G-6
RW item:エボカーリング
RW other:ノーグの名声が大きく上がる
LK fame:ノーグの名声ランク4以上
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/Mama_Mia;Mamaulabion G-6
g01 talk - | ノーグ(G-6)競売所付近のMamaulabionに話して受ける | 品を先に集めておいてもよい。 | @ノーグ G-6 | T npc.252.Mamaulabion
g02 gather - | 7つの「力宿るモノ」を用意する | 空気の水（風の試練）、エギルの松明（火の試練）、ネプトの目（水の試練）、砂漠の光（土の試練）、長老の枝（雷の試練）、サビトレール（氷の試練）、古代種のカギ（月の導き）。それぞれのクエストの報酬で選ぶ。
g03 trade - | Mamaulabionに7つの品を1つずつトレードする | まとめて渡しても1つしか受け取らない。いくつ渡したかは話すと分かる。 | @ノーグ G-6 | T npc.252.Mamaulabion | N 空気の水*1,エギルの松明*1,ネプトの目*1,砂漠の光*1,長老の枝*1,サビトレール*1,古代種のカギ*1
g04 talk - | 地球時間の0時を過ぎてからMamaulabionに話して完了 | エボカーリングを捨てると、また受けられる。 | @ノーグ G-6 | T npc.252.Mamaulabion | W 地球時間の0時を過ぎてから

@ quest.norg.012 https://wiki.ffo.jp/html/12514.html
Q Stop Your Whining | 大自然の極上酒 | no | T npc.252.Washu = npc:Washu@ノーグ J-8
RW item:捕縄の術:壱
RW title:ソムリエ見習い
LK fame:ノーグの名声ランク4以上
LK condition:Lv10以上
g01 talk - | Lv10以上でノーグ(J-8)のWashuに話して受け、だいじなもの「空っぽの酒樽」をもらう | - | @ノーグ J-8 | T npc.252.Washu
g02 examine - | ヨアトル大森林(F-8)テンキー8の直角に曲がる所の???を調べ、だいじなもの「ヨアトル産天然ワイン」を手に入れる | 2016年6月から???の場所は固定。 | @ヨアトル大森林 F-8 | T obj.124.???_F-8 = obj:???@ヨアトル大森林 F-8 | K 空っぽの酒樽
g03 talk - | ノーグのWashuに話して完了 | - | @ノーグ J-8 | T npc.252.Washu | K ヨアトル産天然ワイン

@ quest.norg.013 https://wiki.ffo.jp/html/8403.html
Q I'll Take the Big Box | 想いを遺すために | no | T npc.252.Ryoma = npc:Ryoma@ノーグ H-8
RW item:乱波袴
LK quest:クエスト「海賊たちの20年」をコンプリートし、エリアを出入りする
LK condition:Lv50以上の忍者で話す
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/I%27ll_Take_the_Big_Box;Ensetsu バストゥーク港 I-5、Leodarion ラバオ F-8（湖の西、風車のそば）。オークポールは各国の Records of Eminence の係からスパークで買える
g01 talk - | Lv50以上の忍者でノーグ(H-8)のRyomaに話して受ける | - | @ノーグ H-8 | T npc.252.Ryoma
g02 talk - | バストゥーク港(I-5)のEnsetsuに話す | - | @バストゥーク港 I-5 | T npc.236.Ensetsu = npc:Ensetsu@バストゥーク港 I-5
g03 talk - | ラバオ(F-8)のLeodarionに話す | 湖の西側の風車のそば。 | @ラバオ F-8 | T npc.247.Leodarion = npc:Leodarion@ラバオ F-8
g04 trade - | Leodarionに「オークポール」をトレードする | - | @ラバオ F-8 | T npc.247.Leodarion | N オークポール*1
g05 talk - | ヴァナ時間の0時を過ぎてからLeodarionに話し、だいじなもの「死者を呼ぶ杖」をもらう | - | @ラバオ F-8 | T npc.247.Leodarion | W ヴァナ時間の0時を過ぎてから
g06 go - | マウラ16:00発か0:00発のセルビナ行きの機船に乗る | 16:00発なら20:00に、0:00発なら乗るとすぐNMがいる。 | W マウラ16:00発か0:00発の便 | K 死者を呼ぶ杖
g07 fight - | 機船に出るゴースト族NM「Enagakure」を、セルビナに着く前に倒す | 着く前に倒しきれなかったり、倒したあとデジョンなどで降りたりするとやり直し。黄色ネームなので、ほかの人に事情を伝えておくとよい。 | T mob.Enagakure = mob:Enagakure
g08 go - | そのままセルビナに着いてイベントを見て完了 | かばんを1つ空けておく。 | @セルビナ

@ quest.norg.014 https://wiki.ffo.jp/html/2709.html
Q Bugi Soden | 武技相伝 | no | T npc.252.Ryoma
RW other:片手刀のウェポンスキル「空」
LK condition:Lv71以上の忍者で、片手刀スキル250以上
LK condition:ほかのウェポンスキルのクエストを受けていない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Bugi_Soden;???は I-5/I-6 の境目（用語辞典は I-5 テンキー3）
g01 talk - | Lv71以上の忍者でノーグ(H-8)水辺のRyomaに話し、「試練の小太刀」をもらう | 片手刀スキル250以上。ほかのウェポンスキルのクエストを受けていたらやめてから。 | @ノーグ H-8 | T npc.252.Ryoma
g02 gather - | 「試練の小太刀」を装備して戦い、潜在能力を消す | - | N 試練の小太刀*1
g03 trade - | Ryomaに「試練の小太刀」をトレードし、だいじなもの「試練の地図」をもらう | - | @ノーグ H-8 | T npc.252.Ryoma | N 試練の小太刀*1
g04 examine - | オンゾゾの迷路(I-5)テンキー3の???を調べる | ウォンテッドエリアへ移動のCL122から近い。天候によってはアクティブな風のエレメンタルが出る。 | @オンゾゾの迷路 I-5/I-6 | T obj.オンゾゾの迷路.???_I-5 = obj:???@オンゾゾの迷路 I-5/I-6
g05 fight - | 出てきたクラブ族NM「Megapod Megalops」を倒す | - | @オンゾゾの迷路 I-5/I-6 | T mob.オンゾゾの迷路.Megapod_Megalops = mob:Megapod Megalops@オンゾゾの迷路 I-5/I-6
g06 examine - | もう一度???を調べてだいじなもの「試練の書」を手に入れる | - | @オンゾゾの迷路 I-5/I-6 | T obj.オンゾゾの迷路.???_I-5
g07 talk - | ノーグのRyomaに話して完了 | - | @ノーグ H-8 | T npc.252.Ryoma | K 試練の書

@ quest.norg.015 https://wiki.ffo.jp/html/5417.html
Q Trial by Water | 水の試練 | yes | T npc.252.Edal-Tahdal = npc:Edal-Tahdal@ノーグ H-9
RW item:リバイアサンロッド／ウォーターベルト／ウォーターリング／ネプトの目／10,000ギル のどれか1つ
RW other:何もいらないを選ぶと、召喚獣“リヴァイアサン”と契約できる
RW title:大いなる水の継承者
LK fame:ノーグの名声ランク4以上
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/Trial_by_Water;Edal-Tahdal H-9（用語辞典は H-8〜9）。怨念洞へはウガレピ寺院から「魂の絵筆」で入る
g01 talk - | ノーグ(H-9)見張り塔付近のEdal-Tahdalに話して受け、だいじなもの「水の音叉」をもらう | 名声が足りていても断られたら、何度か話す。 | @ノーグ H-9 | T npc.252.Edal-Tahdal
g02 go - | ウガレピ寺院から怨念洞に入り、水の試練の場の前まで行く | 怨念洞のホームポイント#2がいちばん近い。 | @怨念洞
g03 fight - | 巨大なクリスタルに「水の音叉」をかかげ、試練でLeviathan Primeに勝つ | 6人・30分・レベル制限なし・フェイス不可。勝つとだいじなもの「水の息吹」が手に入る。 | @怨念洞 | T mob.Leviathan_Prime = mob:Leviathan Prime | K 水の音叉
g04 talk - | ノーグのEdal-Tahdalに話して報酬を選び、完了 | 地球時間の0時を過ぎるとまた音叉をもらえる。 | @ノーグ H-9 | T npc.252.Edal-Tahdal | K 水の息吹

@ quest.norg.016 https://wiki.ffo.jp/html/5418.html
Q Trial Size Trial by Water | 水の試練・改 | no | T npc.252.Verctissa = npc:Verctissa@ノーグ H-9
RW other:召喚獣“リヴァイアサン”と契約できる
RW item:呪符デジョン
XS 用語辞典;https://wiki.ffo.jp/html/2389.html;報酬の「呪符デジョン」（Instant Warp）は用語辞典で確認
LK fame:ノーグの名声ランク2以上
LK condition:Lv15以上の召喚士
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/Trial_Size_Trial_by_Water;Verctissa H-9。水の音叉・改をトレードすると試練の場の前へ送ってもらえる。相手は Leviathan Prime、15分、ひとりで、カーバンクルだけ。BG Wiki はLv20以上と書く
g01 talk - | Lv15以上の召喚士で、ノーグ(H-9)見張り塔付近のVerctissaに話して受け、「水の音叉・改」をもらう | - | @ノーグ H-9 | T npc.252.Verctissa
g02 trade - | Verctissaに「水の音叉・改」をトレードして、怨念洞の試練の場の前へ送ってもらう | 準備ができてからでよい。 | @ノーグ H-9 | T npc.252.Verctissa | N 水の音叉・改*1
g03 trade - | 怨念洞の巨大なクリスタルに「水の音叉・改」をかかげて試練の場へ入る | - | @怨念洞 | N 水の音叉・改*1
g04 fight - | 1対1の試練でLeviathan Primeに勝って完了 | ひとりで、使える召喚獣はカーバンクルだけ。テールウィップのヘヴィで距離を取れなくなるので、薬品を多めに。 | T mob.Leviathan_Prime

@ quest.norg.017 https://wiki.ffo.jp/html/8568.html
Q 20 in Pirate Years | 海賊たちの20年 | no | T npc.252.Ryoma
RW item:安寿
RW item:厨子王
LK condition:Lv40以上の忍者で話す
XS BG Wiki;https://www.bg-wiki.com/ffxi/20_in_Pirate_Years;Kagetora バストゥーク港 F-6（倉庫2の中）。???は東アルテパ砂漠 H-5/H-6
g01 talk - | Lv40以上の忍者でノーグ(H-8)水辺のRyomaに話して受ける | - | @ノーグ H-8 | T npc.252.Ryoma
g02 talk - | バストゥーク港(F-6)倉庫の中のKagetoraに話す | - | @バストゥーク港 F-6 | T npc.236.Kagetora = npc:Kagetora@バストゥーク港 F-6
g03 talk - | バストゥーク港(I-5)のEnsetsuに話す | ここからは忍者でなくてよい。 | @バストゥーク港 I-5 | T npc.236.Ensetsu
g04 examine - | 東アルテパ砂漠(H-5)テンキー1、ルテのゲートクリスタルの北東の???を調べる | Survival Guideで西アルテパ砂漠へ飛んでから入ると近い。 | @東アルテパ砂漠 H-5 | T obj.114.???_H-5 = obj:???@東アルテパ砂漠 H-5
g05 fight - | 出てきたスパイダー族NM「Tsuchigumo」2体を倒す | Lv42くらいで、寝ない。 | @東アルテパ砂漠 H-5 | T mob.114.Tsuchigumo = mob:Tsuchigumo@東アルテパ砂漠 H-5
g06 examine - | 2体が消えてから???を調べ、だいじなもの「組木細工の箱」を手に入れる | 倒してすぐは「特に何も無いようだ。」と出る。 | @東アルテパ砂漠 H-5 | T obj.114.???_H-5
g07 talk - | ノーグのRyomaに話して完了 | - | @ノーグ H-8 | T npc.252.Ryoma | K 組木細工の箱

@ quest.norg.018 https://wiki.ffo.jp/html/6212.html
Q Secret of the Damp Scroll | 濡れた巻物の秘密 | no | T npc.252.Shivivi = npc:Shivivi@ノーグ J-8
RW item:呪縛の術:壱
RW title:暗号？解読者
LK fame:ノーグの名声ランク3以上
LK condition:Lv10以上で、「濡れた巻物」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Secret_of_the_Damp_Scroll;名声 Outlands 3、Lv10。濡れた巻物は海蛇の岩窟で釣れるか、競売で買える
g01 gather - | 「濡れた巻物」を1つ用意する | 海蛇の岩窟で釣れる。競売でも買える。 | N 濡れた巻物*1
g02 talk - | 「濡れた巻物」を持ってノーグ(J-8)のShiviviに話して受ける | - | @ノーグ J-8 | T npc.252.Shivivi
g03 trade - | ユグホトの岩屋(J-9)からホルレーの岩峰へ出て、温泉のHot Springsに「濡れた巻物」をトレードして完了 | 巻物が「呪縛の術:壱」に変わる。 | @ホルレーの岩峰 | T obj.ホルレーの岩峰.Hot_Springs = obj:Hot Springs@ホルレーの岩峰 | N 濡れた巻物*1

@ quest.norg.019 https://wiki.ffo.jp/html/5574.html
Q True Will | 物に宿る魂 | no | T npc.252.Ryoma
RW item:乱波鎖帷子
RW title:沈勇なる大忍者
LK quest:クエスト「想いを遺すために」をコンプリート
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/True_Will;???はヨアトル大森林 I-7（Bloodlet Spring の北西）。Leodarion ラバオ F-8（BG Wiki はここだけ F-7、FFXIclopedia は F-8）。クフタルの洞門の宝箱のカギは Curio Vendor Moogle でも買える
g01 talk - | ノーグ(H-8)のRyomaに話して受ける | ここからは忍者でなくてよい。 | @ノーグ H-8 | T npc.252.Ryoma
g02 examine - | ヨアトル大森林(I-7)テンキー3の???を調べる | Survival Guideでヨアトル大森林へ飛ぶと近い。 | @ヨアトル大森林 I-7 | T obj.124.???_I-7 = obj:???@ヨアトル大森林 I-7
g03 fight - | 出てきたサハギンNM「Kappa Biwa」「Kappa Bonze」「Kappa Akuso」を倒す | 3体はリンクしない。3分放っておくと消えるので、怨念洞へ逃げてから1体だけ倒す方法もある。 | @ヨアトル大森林 I-7 | T mob.124.Kappa_Akuso = mob:Kappa Akuso@ヨアトル大森林 I-7
g04 examine - | NMが消えてから???を調べ、だいじなもの「古い組木細工の箱」を手に入れる | - | @ヨアトル大森林 I-7 | T obj.124.???_I-7
g05 talk - | ノーグのRyomaに話す | - | @ノーグ H-8 | T npc.252.Ryoma | K 古い組木細工の箱
g06 talk - | ラバオ(F-8)のLeodarionに話す | - | @ラバオ F-8 | T npc.247.Leodarion
g07 examine - | クフタルの洞門の宝箱を開け、だいじなもの「大きい組木細工の箱」を手に入れる | 宝箱のカギがいる。 | @クフタルの洞門
g08 talk - | ラバオのLeodarionに話して完了 | - | @ラバオ F-8 | T npc.247.Leodarion | K 大きい組木細工の箱

@ quest.norg.020 https://wiki.ffo.jp/html/8570.html
Q The Sacred Katana | 神刀 | no | T npc.252.Jaucribaix
RW item:孫六兼元
LK quest:クエスト「ある刀鍛冶の依頼」をコンプリート
LK condition:Lv40以上の侍で話す
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Sacred_Katana;Isonade は HP約6,100。無銘刀をなくしたら Ranemaud(I-7) から 30,000ギルで買える
g01 talk - | Lv40以上の侍でノーグ(K-8)のJaucribaixに話して受ける | ここからは侍でなくてよい。 | @ノーグ K-8 | T npc.252.Jaucribaix
g02 gather - | 聖地ジ・タのゴブリン「Goblin Robber」を倒して「撒き餌の袋」を手に入れる | - | @聖地ジ・タ | N 撒き餌の袋*1
g03 trade - | 聖地ジ・タ(E-8)テンキー2付近の???に「撒き餌の袋」をトレードする | - | @聖地ジ・タ E-8 | T obj.121.???_E-8 = obj:???@聖地ジ・タ E-8 | N 撒き餌の袋*1
g04 fight - | 出てきたプギル族NM「Isonade」を倒す | - | @聖地ジ・タ E-8 | T mob.121.Isonade = mob:Isonade@聖地ジ・タ E-8
g05 examine - | もう一度???を調べてだいじなもの「水晶の鱗」を手に入れる | - | @聖地ジ・タ E-8 | T obj.121.???_E-8
g06 trade - | ノーグのJaucribaixに「無銘刀」をトレードして完了 | 無銘刀をなくしていたら、ノーグ(I-7)のRanemaudから30,000ギルで買う。 | @ノーグ K-8 | T npc.252.Jaucribaix | N 無銘刀*1 | K 水晶の鱗

@ quest.norg.021 https://wiki.ffo.jp/html/11605.html
Q An Undying Pledge | 誓いの連鎖 | no | T npc.252.Stray_Cloud = npc:Stray Cloud@ノーグ H-9
RW item:ライトバックラー
LK fame:ノーグの名声ランク4以上
g01 talk - | ノーグ(H-9)水辺のStray Cloudに話して受ける | - | @ノーグ H-9 | T npc.252.Stray_Cloud
g02 go - | 海蛇の岩窟への出口に近づいてイベントを見る | - | @ノーグ
g03 examine - | 海蛇の岩窟(K-6)の???を調べる | - | @海蛇の岩窟 K-6 | T obj.176.???_K-6 = obj:???@海蛇の岩窟 K-6
g04 fight - | 出てきた頭足族NM「Glyryvilu」を倒す | - | @海蛇の岩窟 K-6 | T mob.176.Glyryvilu = mob:Glyryvilu@海蛇の岩窟 K-6
g05 examine - | もう一度???を調べてだいじなもの「鈍色の剣」を手に入れる | - | @海蛇の岩窟 K-6 | T obj.176.???_K-6
g06 talk - | ノーグのStray Cloudに話して完了 | - | @ノーグ H-9 | T npc.252.Stray_Cloud | K 鈍色の剣

@ quest.norg.022 https://wiki.ffo.jp/html/6217.html
Q Like a Shining Subligar | 輝けるサブリガ | no | T npc.252.Heiji = npc:Heiji@ノーグ I-7
RW item:暗闇の術:壱
RW title:サブリガを輝かせる者
RW other:ノーグの名声が上がる
LK fame:ノーグの名声ランク3以上
g01 talk - | ノーグ(I-7)2階つり橋付近のHeijiに話して受ける | - | @ノーグ I-7 | T npc.252.Heiji
g02 gather - | 「錆びたサブリガ」を10個用意する | - | N 錆びたサブリガ*10
g03 trade - | Heijiに「錆びたサブリガ」を合わせて10個トレードして完了 | 1個ずつ渡してもよい。 | @ノーグ I-7 | T npc.252.Heiji | N 錆びたサブリガ*10

@ quest.norg.023 https://wiki.ffo.jp/html/6216.html
Q Like Shining Leggings | 輝けるレギンス | no | T npc.252.Heizo = npc:Heizo@ノーグ H-7
RW item:毒盛の術:壱
RW title:レギンスを輝かせる者
RW other:ノーグの名声が上がる
LK fame:ノーグの名声ランク3以上
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/Like_Shining_Leggings;Heizo H-7（用語辞典は I-7）
g01 talk - | ノーグ(H-7)2階つり橋付近のHeizoに話して受ける | - | @ノーグ H-7 | T npc.252.Heizo
g02 gather - | 「錆びたレギンス」を10個用意する | - | N 錆びたレギンス*10
g03 trade - | Heizoに「錆びたレギンス」を合わせて10個トレードして完了 | 1個ずつ渡してもよい。 | @ノーグ H-7 | T npc.252.Heizo | N 錆びたレギンス*10

@ quest.norg.024 https://wiki.ffo.jp/html/5199.html
Q Yomi Okuri | 黄泉送り | no | T npc.252.Jaucribaix
RW item:明珍筒脛当
LK quest:クエスト「神刀」をコンプリートし、エリアを出入りして1分たつ
LK condition:Lv50以上の侍
XS BG Wiki;https://www.bg-wiki.com/ffxi/Yomi_Okuri;Ubume はオンゾゾの迷路 F-8、Doman・Onryo はバルクルム砂丘 B-7（BG Wiki は 18:00〜4:00）
g01 talk - | Lv50以上の侍でノーグ(K-8)のJaucribaixに話して受ける | 「神刀」のあと、エリアを出入りして1分たってから。 | @ノーグ K-8 | T npc.252.Jaucribaix
g02 talk - | ノーグ(J-8)のWashuに話して、エサの材料を聞く | - | @ノーグ J-8 | T npc.252.Washu
g03 trade - | Washuに「大羊の肉」「シモカブ」「バストアサーディン」「ヘクトアイズの眼」をトレードし、だいじなもの「ワシュウ特製詰め物」をもらう | - | @ノーグ J-8 | T npc.252.Washu | N 大羊の肉*1,シモカブ*1,バストアサーディン*1,ヘクトアイズの眼*1
g04 examine - | オンゾゾの迷路(F-8)の???を調べる | Survival Guideでオンゾゾの迷路へ飛ぶと近い。 | @オンゾゾの迷路 F-8 | T obj.オンゾゾの迷路.???_F-8 = obj:???@オンゾゾの迷路 F-8 | K ワシュウ特製詰め物
g05 fight - | 出てきたロック族NM「Ubume」を倒す | 出てすぐ魔物達のララバイを何度も使う。サイレスは効くので、毒薬を先に飲んでおくのも手。すぐ東の通路にLv75でも絡むAir Elementalが出ることがある。 | @オンゾゾの迷路 F-8 | T mob.オンゾゾの迷路.Ubume = mob:Ubume@オンゾゾの迷路 F-8
g06 examine - | もう一度???を調べてだいじなもの「黄泉送りの羽根」を手に入れる | - | @オンゾゾの迷路 F-8 | T obj.オンゾゾの迷路.???_F-8
g07 talk - | ノーグのJaucribaixに話す | - | @ノーグ K-8 | T npc.252.Jaucribaix | K 黄泉送りの羽根
g08 talk - | エリアを出入りして1分たってからJaucribaixに話し、「神刀黄泉平坂」をもらう | - | @ノーグ K-8 | T npc.252.Jaucribaix
g09 examine - | 夜にバルクルム砂丘(B-7)の???を調べる | C-6テンキー6の隠しマップの洞窟の先。 | @バルクルム砂丘 B-7 | T obj.103.???_B-7 = obj:???@バルクルム砂丘 B-7 | W 夜（18:00〜6:00）
g10 fight - | 出てきたNM「Doman」（シャドウ族）と「Onryo」（ゴースト族）を倒す | - | @バルクルム砂丘 B-7 | T mob.103.Doman = mob:Doman@バルクルム砂丘 B-7
g11 examine - | 2体が消えてから???を調べ、「朽ち果てた刀」を手に入れる | - | @バルクルム砂丘 B-7 | T obj.103.???_B-7
g12 talk - | ノーグのJaucribaixに話して完了 | - | @ノーグ K-8 | T npc.252.Jaucribaix | K 朽ち果てた刀

@ quest.norg.025 https://wiki.ffo.jp/html/25099.html
Q VW Op. #126: Qufim Incursion | VW作戦第126計画クフィム島 | no |
RW gil:50,000ギル
LK quest:クエスト「新たな作戦領域」をコンプリート（自動で受ける）
XS BG Wiki;https://www.bg-wiki.com/ffxi/VW_Op._126:_Qufim_Incursion;ヴォイドウォーカーの出る場所：Kaggen クフィム島 G-6・H-6・I-7、Akvan デルクフの塔下層 地下 G-9／2階 F-5/F-6／3階 I-6、Pil ベヒーモスの縄張り E-7・H-8・J-10。VW招集通知がもらえないときは、ソロムグ原野〔Ｓ〕の Bulwark Gate と パシュハウ沼〔Ｓ〕のイベントを先に見る
g01 go - | 「新たな作戦領域」を終えると自動で受ける | -
g02 fight - | クフィム島のヴォイドウォーカー「Kaggen」を倒す | 出る場所は G-6・H-6・I-7 のどれか。 | @クフィム島 | T mob.126.Kaggen = mob:Kaggen@クフィム島
g03 fight - | デルクフの塔下層のヴォイドウォーカー「Akvan」を倒す | 出る場所は地下 G-9、2階 F-5/F-6、3階 I-6 のどれか。 | @デルクフの塔下層 | T mob.184.Akvan = mob:Akvan@デルクフの塔下層
g04 fight - | ベヒーモスの縄張りのヴォイドウォーカー「Pil」を倒す | 出る場所は E-7・H-8・J-10 のどれか。 | @ベヒーモスの縄張り | T mob.127.Pil = mob:Pil@ベヒーモスの縄張り
g05 talk - | 現代のVoidwatch Officerに話し、だいじなもの「VW招集通知」をもらう | どの街のVoidwatch Officerでもよい。 | T npc.Voidwatch_Officer = npc:Voidwatch Officer
g06 examine - | ル・ルデの庭(H-6)のDoor:Audience Chamberを調べてイベントを見て完了 | 次の「ケット・シーの導き」を自動で受ける。 | @ル・ルデの庭 H-6 | T obj.243.Door_Audience_Chamber | K VW招集通知
