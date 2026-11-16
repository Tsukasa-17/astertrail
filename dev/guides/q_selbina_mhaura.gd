# セルビナ・マウラのクエスト（0.1.73〜）。用語辞典の各記事を読んで書き直したもの。
# 番号：001〜010 は基礎シート「クエスト一覧」の201〜210行、011〜024 は282〜295行、025 は296行、026 は1144行。
# 座標は BG Wiki と FFXIclopedia が一致したもの、または FFXIclopedia に無く BG Wiki にあるもの。名声は BG Wiki。

@ quest.selbina_mhaura.001 https://wiki.ffo.jp/html/1043.html
Q An Explorer's Footsteps | ある冒険者の足跡 | yes | T npc.248.Abelard = npc:Abelard@セルビナ G-9
RW gil:石碑ごとに800〜10,000ギル（17か所で合計38,000ギル）
RW key_item:クロウラーの巣地図
RW other:ソロムグ原野・バタリア丘陵を除く15か所を渡すと「クロウラーの巣地図」（持っていれば経験値2000と2000ギル）
LK fame:セルビナの名声ランク4以上
LK condition:Lv15以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/An_Explorer%27s_Footsteps;名声 Selbina 4、Lv15、Abelard G-9（FFXIclopedia も G-9）
g01 talk - | セルビナの町長の家(G-9)のAbelardに話して受け、「セルビナの粘土」をもらう | 星唄ミッション「縛め解きて」をセルビナのルートで進めている間は話しても反応しない。 | @セルビナ G-9 | T npc.248.Abelard
g02 trade - | 各地のStone Monumentに「セルビナの粘土」をトレードし、「碑文を写した粘土」を手に入れる | 西ロンフォールI-10・東ロンフォールG-11・ラテーヌ高原J-7・バルクルム砂丘E-9・ジャグナー森林H-12・北グスタベルグF-7（ダングルフの涸れ谷から）・南グスタベルグK-10・コンシュタット高地G-7・パシュハウ沼F-6・ロランベリー耕地K-11・西サルタバルタG-9・東サルタバルタK-6・タロンギ大峡谷E-5・ブブリム半島J-5・メリファト山地J-10・ソロムグ原野I-9（ガルレージュ要塞から）・バタリア丘陵J-11（エルディーム古墳から）。過去世界の3か所では写せない。 | N セルビナの粘土*1
g03 trade - | Abelardに「碑文を写した粘土」をトレードしてギルを受け取る | 続けると答えると、また粘土をもらえる。 | @セルビナ G-9 | T npc.248.Abelard | N 碑文を写した粘土*1
g04 talk - | 粘土をもらったあとAbelardに話し、まだの石碑のエリアを聞く | 17か所すべて回るまで g02〜g04 をくり返す。 | @セルビナ G-9 | T npc.248.Abelard

@ quest.selbina_mhaura.002 https://wiki.ffo.jp/html/4154.html
Q Elder Memories | ある老人の回想 | no | T npc.248.Isacio = npc:Isacio@セルビナ G-10
RW other:サポートジョブを指定できるようになる
LK condition:Lv18以上でサポートジョブがない
LK quest:マウラの「ごうつくばあさん」を受けていない
g01 talk - | Lv18以上でセルビナ(G-10)倉庫の西側のIsacioに話して受ける | マウラの「ごうつくばあさん」とはどちらか一方だけ。 | @セルビナ G-10 | T npc.248.Isacio | > a01,b01
a01 gather - | 【品】フライ族「Damselfly」を倒して「ガガンボの腹虫」を手に入れる | 3つの品はどれもRare Exで、人から譲ってもらえない。 | N ガガンボの腹虫*1 | R 品
a02 trade - | Isacioに「ガガンボの腹虫」をトレードする | - | @セルビナ G-10 | T npc.248.Isacio | N ガガンボの腹虫*1 | R 品
a03 gather - | スケルトン族「Ghoul」を倒して「呪われたサレコウベ」を手に入れる | バルクルム砂丘のGhoulは夜だけ。グスゲン鉱山などのGhoulはいつでもいる。 | N 呪われたサレコウベ*1 | R 品
a04 trade - | Isacioに「呪われたサレコウベ」をトレードする | - | @セルビナ G-10 | T npc.248.Isacio | N 呪われたサレコウベ*1 | R 品
a05 gather - | クラブ族「Snipper」を倒して「陸ガニのふんどし」を手に入れる | - | N 陸ガニのふんどし*1 | R 品
a06 trade - | Isacioに「陸ガニのふんどし」をトレードして完了 | - | @セルビナ G-10 | T npc.248.Isacio | N 陸ガニのふんどし*1 | R 品 | >
b01 go - | 【紹介状】星唄ミッション「縛め解きて」をクリアして、だいじなもの「ギルガメッシュの紹介状」を手に入れる | 受ける前に手に入れておいてもよい。 | R 紹介状
b02 talk - | Isacioに話して完了 | - | @セルビナ G-10 | T npc.248.Isacio | K ギルガメッシュの紹介状 | R 紹介状 | >

@ quest.selbina_mhaura.003 https://wiki.ffo.jp/html/1338.html
Q Inside the Belly | ハラキリ | yes | T npc.248.Zaldon
RW gil:魚に応じたギル
RW other:魚の中からアイテムが出ることがある（オオナマズからアースワンド、シルバーシャークからトライデント、リュウグウノツカイからメルクリウスソードなど）
RW title:釣り名人／釣り大名人／太公望（魚による）
LK quest:クエスト「本当のプレゼント」をコンプリート
LK condition:釣りスキル30以上（装備やイメージサポートの分も込みでよい）
g01 talk - | 釣りスキル30以上で、セルビナ漁師ギルド売店(H-9)のZaldonに話して受ける | 2回目からは話さずに魚をトレードするだけでよく、スキルも問わない。 | @セルビナ H-9 | T npc.248.Zaldon
g02 gather - | 指定の魚を釣る | 指定の魚は釣りスキルのランクで増える。指定外の魚でも受け取ってもらえる。
g03 trade - | Zaldonに魚をトレードして完了 | 魚に応じたギルと、まれに魚の中のアイテムがもらえる。 | @セルビナ H-9 | T npc.248.Zaldon

@ quest.selbina_mhaura.004 https://wiki.ffo.jp/html/4550.html
Q The Gift | プレゼント | no | T npc.248.Oswald = npc:Oswald@セルビナ I-9
RW item:スリプルダガー
RW title:愛の救世主
LK quest:クエスト「港の落とし物」をコンプリート
LK quest:マウラのクエスト「安否」を受けている
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/The_Gift;Oswald の座標 I-9。オドリタケは競売（食品→食材）で買える
g01 talk - | 「安否」を受けた状態で、セルビナ(I-9)羊飼いの溜まり場のOswaldに話して受ける | - | @セルビナ I-9 | T npc.248.Oswald
g02 gather - | 「オドリタケ」を1個用意する | 競売（食品→食材）で買える。 | N オドリタケ*1
g03 trade - | Oswaldに「オドリタケ」をトレードして完了 | - | @セルビナ I-9 | T npc.248.Oswald | N オドリタケ*1

@ quest.selbina_mhaura.005 https://wiki.ffo.jp/html/6129.html
Q Only the Best | 品質管理 | yes | T npc.248.Melyon = npc:Melyon@セルビナ I-9
RW gil:ラテーヌキャベツ5個で100ギル／ミリオンコーン3個で120ギル／ボヤーダ苔1個で600ギル
RW other:サンドリアとバストゥークの名声が上がる
g01 talk - | セルビナ(I-9)織工ギルド売店前のMelyonに話して受ける | 2回目からは話さずにトレードするだけでよい。 | @セルビナ I-9 | T npc.248.Melyon
g02 gather - | 「ラテーヌキャベツ」5個、「ミリオンコーン」3個、「ボヤーダ苔」1個のどれかを用意する | 名声はボヤーダ苔がいちばん上がる。
g03 trade - | Melyonに用意した品をトレードして完了 | エリアを出なくても続けて渡せる。 | @セルビナ I-9 | T npc.248.Melyon

@ quest.selbina_mhaura.006 https://wiki.ffo.jp/html/3823.html
Q The Rescue | 救出 | no | T npc.248.Thunder_Hawk = npc:Thunder Hawk@セルビナ G-9
RW gil:5,000ギル
RW other:経験値2000
RW title:セルビナ名誉市民
RW key_item:ラングモント峠地図
LK fame:名声ランク4以上
g01 talk - | セルビナ(G-9)町長宅前のThunder Hawkに話して受ける | - | @セルビナ G-9 | T npc.248.Thunder_Hawk
g02 go - | ベドーMAP1の入口から(H-7)へ進み、MAP2の地下道を抜けてMAP1(E-10)の架け橋から高台に上がる | 途中の「呪い」(The Afflictor)と「静寂」(The Mute)の装置は都合のよいほうを選ぶ。 | @ベドー E-10 #1
g03 fight - | ベドー(I-9)のクゥダフ族NM「De'Vyu Headhunter」を倒して「クゥダフの呪符」を手に入れる | 「ベドーの謎その1」も受けていると、トレードで呪符がなくなるので倒し直す。 | @ベドー I-9 #1 | T mob.147.DeVyu_Headhunter
g04 trade - | ベドー(I-8)テンキー3の段差の下の穴の奥のJail Doorに「クゥダフの呪符」をトレードし、だいじなもの「商人のずだ袋」をもらう | 高台の穴の上からでもトレードできる。高台から降りたら(J-7)か(K-7)の架け橋で(I-9)へ戻れる。 | @ベドー I-8 #1 | T obj.147.Jail_Door = obj:Jail Door@ベドー I-8 #1 | N クゥダフの呪符*1
g05 talk - | セルビナのThunder Hawkに話して完了 | ラングモント峠地図を持っていれば地図はもらえない。 | @セルビナ G-9 | T npc.248.Thunder_Hawk | K 商人のずだ袋

@ quest.selbina_mhaura.007 https://wiki.ffo.jp/html/3817.html
Q The Real Gift | 本当のプレゼント | no | T npc.248.Oswald
RW item:グラスロッド
RW title:キング・オブ・ラブ
LK quest:クエスト「プレゼント」とクエスト「安否」をコンプリート
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/The_Real_Gift;Oswald の座標 I-9
g01 talk - | セルビナ(I-9)羊飼いの溜まり場のOswaldに話して受ける | - | @セルビナ I-9 | T npc.248.Oswald
g02 gather - | 「シャル貝」を1個用意する | バルクルム砂丘などで釣る、プギル族が落とす、ビビキー湾の漁師ギルドで買う。セルビナからバルクルム砂丘に出てすぐの海岸のBeach Pugilが手早い。 | N シャル貝*1
g03 trade - | Oswaldに「シャル貝」をトレードして完了 | - | @セルビナ I-9 | T npc.248.Oswald | N シャル貝*1

@ quest.selbina_mhaura.008 https://wiki.ffo.jp/html/13556.html
Q Test My Mettle | 根性試し | yes | T npc.248.Devean = npc:Devean@セルビナ I-8
RW gil:掛け金×倍率（24時間3.0倍・36時間2.5倍・48時間2.0倍・60時間1.5倍・72時間1.2倍）
LK condition:ジョブのレベルで受けられないことがある（具体的なLvは記事に書いていない）
g01 talk - | セルビナ(I-8)羊飼いの溜まり場の裏のDeveanに話して受ける | もう一度受けるには地球時間の0時を過ぎてから。 | @セルビナ I-8 | T npc.248.Devean
g02 talk - | 掛け金（100・250・500・1000）と制限時間（ヴァナ時間24〜72時間）を選ぶ | 短い時間ほど倍率が高い。 | @セルビナ I-8 | T npc.248.Devean
g03 examine - | 制限時間のうちに、ダボイのJarを調べて「ど根性サンダル」を探す | Jarが出る場所はI-8・K-9・J-8・H-8・F-6・J-9・F-9・G-9・H-9・F-7。セルビナからProto-Waypointでダボイへ直行できる。 | @ダボイ | T obj.149.Jar = obj:Jar@ダボイ
g04 trade - | Deveanに「ど根性サンダル」をトレードして完了 | 掛け金×倍率のギルを受け取る。サンダルを持ったままでは失敗になる。 | @セルビナ I-8 | T npc.248.Devean | N ど根性サンダル*1

@ quest.selbina_mhaura.009 https://wiki.ffo.jp/html/4546.html
Q Under the Sea | 港の落とし物 | no | T npc.248.Oswald
RW item:アンバーピアス
RW title:愛のキューピッド
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/Under_the_Sea;Zaldon の座標 H-9
g01 talk - | セルビナ(H-9)のYayaに話してイベントを見る | - | @セルビナ H-9 | T npc.248.Yaya = npc:Yaya@セルビナ H-9
g02 talk - | 羊飼いの溜まり場(I-9)のOswaldに話す | - | @セルビナ I-9 | T npc.248.Oswald
g03 talk - | セルビナ(H-9)のJimaidaに話して受ける | - | @セルビナ H-9 | T npc.248.Jimaida = npc:Jimaida@セルビナ H-9
g04 gather - | セルビナで「太ったグリーディ」を釣る | - | N 太ったグリーディ*1
g05 trade - | 漁師ギルド(H-9)のZaldonに「太ったグリーディ」をトレードし、だいじなもの「名前の刻まれた指輪」をもらう | 指輪が出るまで、釣ってはトレードをくり返す。 | @セルビナ H-9 | T npc.248.Zaldon | N 太ったグリーディ*1
g06 talk - | Oswaldに話して完了 | - | @セルビナ I-9 | T npc.248.Oswald | K 名前の刻まれた指輪

@ quest.selbina_mhaura.010 https://wiki.ffo.jp/html/5986.html
Q Picture Perfect | 真珠色の思い出 | no | T npc.248.Diederik = npc:Diederik@セルビナ G-10
RW other:フェローのレベル上限が55になる
RW title:志を共にせし者
LK quest:クエスト「芸術家によるラプソディ」をコンプリート
LK condition:フェローがLv50で親密度40以上、シグナルパールを持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Picture_Perfect;Umberto の座標 L-10
g01 talk - | シグナルパールを持ってセルビナ(G-10)の海辺のDiederikに話し、どちらに頼むか選ぶ | ジュノ上層のLuto Mewrilahに話しても始まらない。 | @セルビナ G-10 | T npc.248.Diederik | > a01,b01
a01 talk - | 【描き直し】ウィンダス水の区(F-10)ララブのしっぽ亭2階のAngelicaに話す | - | @ウィンダス水の区 F-10 | T npc.238.Angelica | R 描き直し
a02 gather - | コロロカの洞門で採掘して「バル貝の殻」を手に入れる | つるはしがいる。 | @コロロカの洞門 | N つるはし*1 | R 描き直し
a03 trade - | Angelicaに「バル貝の殻」をトレードする | - | @ウィンダス水の区 F-10 | T npc.238.Angelica | N バル貝の殻*1 | R 描き直し | > g02
b01 talk - | 【時間かせぎ】バストゥーク商業区(L-10)のUmbertoに話す | - | @バストゥーク商業区 L-10 | T npc.235.Umberto = npc:Umberto@バストゥーク商業区 L-10 | R 時間かせぎ
b02 gather - | コロロカの洞門で採掘して「バル貝の殻」を手に入れる | つるはしがいる。 | @コロロカの洞門 | N つるはし*1 | R 時間かせぎ
b03 trade - | Umbertoに「バル貝の殻」をトレードする | - | @バストゥーク商業区 L-10 | T npc.235.Umberto | N バル貝の殻*1 | R 時間かせぎ
b04 talk - | セルビナのDiederikに話す | - | @セルビナ G-10 | T npc.248.Diederik | R 時間かせぎ | > g02
g02 go - | オズトロヤ城のJ-8とI-9を通って、中庭の2階(I-8)へ進む | - | @オズトロヤ城 I-8
g03 examine - | Brass Doorを調べてイベントを見る | - | @オズトロヤ城 I-8 | T obj.151.Brass_Door = obj:Brass Door@オズトロヤ城 I-8
g04 examine - | もう一度Brass Doorを調べ、奥の???を調べてYagudo Muralistを出す | - | @オズトロヤ城 I-8 | T obj.151.qqq_Picture_Perfect = obj:???~@オズトロヤ城 I-8
g05 defeat - | フェローといっしょにYagudo Muralistを倒す | Lv50くらいの黒魔道士のような敵でHP約2200。Lv50を超えていればソロでも倒せる。パーティでもイベントは1人ずつ。 | @オズトロヤ城 I-8 | T mob.151.Yagudo_Muralist = mob:Yagudo Muralist@オズトロヤ城 I-8
g06 examine - | フェローに話してから???を調べ、だいじなもの「乳白色の原石」を手に入れる | - | @オズトロヤ城 I-8 | T obj.151.qqq_Picture_Perfect
g07 talk - | ウィンダス水の区(F-10)のAngelicaに話して、だいじなもの「おばあさんの肖像画」を受け取る | - | @ウィンダス水の区 F-10 | T npc.238.Angelica | K 乳白色の原石
g08 talk - | バストゥーク商業区(L-10)のUmbertoに肖像画を届けて完了 | - | @バストゥーク商業区 L-10 | T npc.235.Umberto | K おばあさんの肖像画

@ quest.selbina_mhaura.011 https://wiki.ffo.jp/html/15141.html
Q A Potter's Preference | ある陶芸家のこだわり | yes | T npc.249.Nereus = npc:Nereus@マウラ I-8
RW gil:2,160ギル
LK fame:名声ランク5以上
LK condition:はじめて受けるときはレベルの制限がある（記事ではLv40以上かと推測）
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/A_Potter%27s_Preference;名声5、Nereus I-8、Clay はグスゲン鉱山の3枚目のマップ I-7
g01 talk - | マウラ(I-8)船乗りの宿2階出入口近くのNereusに話して受ける | 一度クリアすると、次からはレベルの制限がない。 | @マウラ I-8 | T npc.249.Nereus
g02 examine - | グスゲン鉱山のいちばん奥の3部屋のうち、いちばん東の部屋のClayを調べて「グスゲン鉱山の土」を手に入れる | 近くの池のそば。道中にLv85以上の敵がいるのでスニークがあると安心。 | @グスゲン鉱山 I-7 #3 | T obj.196.Clay = obj:Clay@グスゲン鉱山 I-7 #3
g03 trade - | Nereusに「グスゲン鉱山の土」をトレードして完了 | 地球時間で8時間たつと、また受けられる。 | @マウラ I-8 | T npc.249.Nereus | N グスゲン鉱山の土*1

@ quest.selbina_mhaura.012 https://wiki.ffo.jp/html/4151.html
Q The Old Lady | ごうつくばあさん | no | T npc.249.Vera = npc:Vera@マウラ G-10
RW other:サポートジョブを指定できるようになる
LK condition:Lv18以上でサポートジョブがない
LK quest:セルビナの「ある老人の回想」を受けていない・クリアしていない
g01 talk - | Lv18以上でマウラ(G-10)倉庫前のVeraに話して受ける | セルビナの「ある老人の回想」とはどちらか一方だけ。 | @マウラ G-10 | T npc.249.Vera | > a01,b01
a01 gather - | 【品】「Mighty Rarab」を倒して「野兎の尻尾」を手に入れる | 3つの品はどれもRare Exで、人から譲ってもらえない。 | N 野兎の尻尾*1 | R 品
a02 trade - | Veraに「野兎の尻尾」をトレードする | - | @マウラ G-10 | T npc.249.Vera | N 野兎の尻尾*1 | R 品
a03 gather - | 「Bull Dhalmel」を倒して「ダルメルの唾液」を手に入れる | - | N ダルメルの唾液*1 | R 品
a04 trade - | Veraに「ダルメルの唾液」をトレードする | - | @マウラ G-10 | T npc.249.Vera | N ダルメルの唾液*1 | R 品
a05 gather - | 「Bogy」を倒して「血染めの衣」を手に入れる | Lv18サポートなしのソロではかなり厳しい。 | N 血染めの衣*1 | R 品
a06 trade - | Veraに「血染めの衣」をトレードして完了 | - | @マウラ G-10 | T npc.249.Vera | N 血染めの衣*1 | R 品 | >
b01 go - | 【紹介状】星唄ミッション「縛め解きて」をクリアして、だいじなもの「ギルガメッシュの紹介状」を手に入れる | こちらのほうが楽。 | R 紹介状
b02 talk - | Veraに話して完了 | - | @マウラ G-10 | T npc.249.Vera | K ギルガメッシュの紹介状 | R 紹介状 | >

@ quest.selbina_mhaura.013 https://wiki.ffo.jp/html/3819.html
Q His Name is Valgeir | その名はヴァルゲール | no | T npc.249.Rycharde = npc:Rycharde@マウラ H-8/I-8
RW gil:2,000ギル
RW other:経験値2000
RW key_item:トライマライ水路地図
LK fame:名声ランク2以上
LK quest:クエスト「飽くなき追求」をコンプリートしてから、ヴァナ時間で3日たっている
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/His_Name_Is_Valgeir;名声2、Rycharde I-8（用語辞典は H-8）、Valgeir I-9
g01 talk - | マウラ(H-8/I-8)船乗りの宿のRychardeに話して受け、だいじなもの「アラゴーニュピザ」をもらう | セルビナ行きの船賃を前払いしてくれる。一度降りると次は自分で払う。ほかの手段で行ってもよい。 | @マウラ H-8/I-8 | T npc.249.Rycharde | W 「飽くなき追求」からヴァナ時間で3日たってから
g02 talk - | セルビナ(I-9)羊飼いの溜まり場のValgeirにピザを届ける | 選択肢はどれでもよい。 | @セルビナ I-9 | T npc.248.Valgeir = npc:Valgeir@セルビナ I-9 | K アラゴーニュピザ
g03 talk - | マウラのRychardeに話して完了 | トライマライ水路地図を持っていれば地図はもらえない。 | @マウラ H-8/I-8 | T npc.249.Rycharde

@ quest.selbina_mhaura.014 https://wiki.ffo.jp/html/4554.html
Q Expertise | その腕前 | no | T npc.249.Take = npc:Take@マウラ I-8
RW item:食器一式
RW title:調達人
LK fame:名声ランク4以上
LK quest:クエスト「その名はヴァルゲール」をコンプリート
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/Expertise;名声4、Take I-8、Valgeir I-9（用語辞典は I-8）
g01 talk - | マウラ(I-8)船乗りの宿のTakeに話して受ける | - | @マウラ I-8 | T npc.249.Take
g02 gather - | 「陸ガニの肉」と「サケビタケ」を1個ずつ用意する | - | N 陸ガニの肉*1,サケビタケ*1
g03 trade - | セルビナ(I-9)羊飼いの溜まり場のValgeirに2つの品をトレードする | - | @セルビナ I-9 | T npc.248.Valgeir | N 陸ガニの肉*1,サケビタケ*1
g04 talk - | ヴァナ時間で24時間たってからValgeirに話し、陸ガニのビスクを受け取る | - | @セルビナ I-9 | T npc.248.Valgeir | W ヴァナ時間で24時間たってから
g05 talk - | マウラのTakeにビスクを届けて完了 | - | @マウラ I-8 | T npc.249.Take

@ quest.selbina_mhaura.015 https://wiki.ffo.jp/html/8146.html
Q Orlando's Antiques | 古物商オルランド | yes | T npc.249.Orlando = npc:Orlando@マウラ G-9
RW gil:8個ごとに100〜900ギル（品による）
LK quest:クエスト「傷ついたチョコボ」をクリア
g01 talk - | マウラ(G-9)の屋内のOrlandoに話して受ける | - | @マウラ G-9 | T npc.249.Orlando
g02 gather - | 同じガラクタを8個集める | ゴブリンダイス・歯の入った麻袋・爪の入った麻袋・腐肉・魚の骨・ゴブリンカップ・がら・獣人貨・獣人銀貨・獣人ミスリル貨・獣人金貨のどれか。主にチョコボ掘りで出る。獣人貨は競売のほうが高く売れる。
g03 trade - | Orlandoに8個まとめてトレードして完了 | 品に応じたギル（100〜900ギル）。何度でもできる。 | @マウラ G-9 | T npc.249.Orlando

@ quest.selbina_mhaura.016 https://wiki.ffo.jp/html/7101.html
Q It's Raining Mannequins | 呪われた人形 | no | T npc.249.Fyi_Chalmwoh = npc:Fyi Chalmwoh@マウラ G-8
RW other:自分の種族・性別のマネキン（このあと1体10万ギルで買えるようになる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/It%27s_Raining_Mannequins;Ramona H-9、Cheupirudaux F-3
g01 talk - | マウラ(G-8)彫金ギルドのFyi Chalmwohに話して受ける | - | @マウラ G-8 | T npc.249.Fyi_Chalmwoh
g02 talk - | セルビナ(H-9)織工ギルドのRamonaに話し、だいじなもの「マネキンのカタログ」をもらう | - | @セルビナ H-9 | T npc.248.Ramona = npc:Ramona@セルビナ H-9
g03 talk - | 北サンドリア(F-3)木工ギルドのギルドマスターCheupirudauxに話し、だいじなもの「マネキンの絵図」をもらう | - | @北サンドリア F-3 | T npc.231.Cheupirudaux = npc:Cheupirudaux@北サンドリア F-3
g04 gather - | 「マネキンヘッド」「マネキンボディ」「マネキンハンズ」「マネキンレッグズ」「マネキンフィート」を1個ずつ用意する | 入手先は記事に書いていない。 | N マネキンヘッド*1,マネキンボディ*1,マネキンハンズ*1,マネキンレッグズ*1,マネキンフィート*1
g05 trade - | Fyi Chalmwohに5つのパーツをトレードする | - | @マウラ G-8 | T npc.249.Fyi_Chalmwoh | N マネキンヘッド*1,マネキンボディ*1,マネキンハンズ*1,マネキンレッグズ*1,マネキンフィート*1
g06 talk - | 20秒ほど待ってからFyi Chalmwohに話して完了 | - | @マウラ G-8 | T npc.249.Fyi_Chalmwoh

@ quest.selbina_mhaura.017 https://wiki.ffo.jp/html/4558.html
Q The Basics | 基本 | no | T npc.249.Rycharde
RW item:茶器一式
RW title:孤高の調達人
LK quest:クエスト「手がかり」をコンプリート
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Basics;「手がかり」のあと地球時間で8時間たってから。マウラ風クスクスはだいじなものとして Rycharde からもらう
g01 talk - | マウラ(H-8/I-8)船乗りの宿のRychardeに話して受け、だいじなもの「マウラ風クスクス」をもらう | - | @マウラ H-8/I-8 | T npc.249.Rycharde | W 「手がかり」から地球時間で8時間たってから
g02 talk - | セルビナ(I-9)のValgeirにクスクスを渡し、「ポポトイモ」を受け取る | - | @セルビナ I-9 | T npc.248.Valgeir | K マウラ風クスクス
g03 trade - | マウラのRychardeに「ポポトイモ」をトレードして完了 | - | @マウラ H-8/I-8 | T npc.249.Rycharde | N ポポトイモ*1

@ quest.selbina_mhaura.018 https://wiki.ffo.jp/html/3816.html
Q The Sand Charm | 安否 | no | T npc.249.Celestina = npc:Celestina@マウラ G-8
RW gil:2,000ギル
RW other:経験値2000
RW key_item:ボストーニュ監獄地図
LK fame:名声ランク4以上
LK condition:手順の1〜3のイベントを見てから
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/The_Sand_Charm;名声4、Blandine I-9（用語辞典は H-9）。砂の護符は機船のCrossbonesが落とす
g01 talk - | マウラ(I-9)のBlandineに町の側から話し、夫の帰りを待つ話を聞く | - | @マウラ I-9 | T npc.249.Blandine = npc:Blandine@マウラ I-9
g02 talk - | 100ギル払って改札を通り、船着場(I-9)のZexuに話してイベントを見る | - | @マウラ I-9 | T npc.249.Zexu = npc:Zexu@マウラ I-9
g03 talk - | 改札を出て、町の側からもう一度Blandineに話してイベントを見る | - | @マウラ I-9 | T npc.249.Blandine
g04 talk - | 彫金ギルド売店(G-8)のCelestinaに話して受ける | - | @マウラ G-8 | T npc.249.Celestina
g05 defeat - | 機船に乗り、ときどき出る海賊「Crossbones」を倒して「砂の護符」を手に入れる | 海賊が出るかは運しだい。 | T mob.Crossbones = mob:Crossbones
g06 trade - | Celestinaに「砂の護符」をトレードして完了 | ボストーニュ監獄地図を持っていれば地図はもらえない。 | @マウラ G-8 | T npc.249.Celestina | N 砂の護符*1

@ quest.selbina_mhaura.019 https://wiki.ffo.jp/html/4560.html
Q The Clue | 手がかり | no | T npc.249.Rycharde
RW gil:3,000ギル
RW title:調達の達人
LK quest:クエスト「その腕前」をコンプリート
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Clue;「その腕前」のあと地球時間で8時間たってから。蟲の卵は競売の食材かクロウラー族
g01 talk - | マウラ(H-8/I-8)船乗りの宿2階のRychardeに話して受ける | - | @マウラ H-8/I-8 | T npc.249.Rycharde | W 「その腕前」から地球時間で8時間たってから
g02 gather - | 「蟲の卵」を4個用意する | 競売（食品→食材）か、クロウラー族が落とす。 | N 蟲の卵*4
g03 trade - | Rychardeに「蟲の卵」4個をトレードして完了 | - | @マウラ H-8/I-8 | T npc.249.Rycharde | N 蟲の卵*4

@ quest.selbina_mhaura.020 https://wiki.ffo.jp/html/4556.html
Q Way of the Cook | 料理の道 | no | T npc.249.Rycharde
RW gil:1,500ギル（ヴァナ時間で3日を過ぎると1,000ギル）
RW title:食材調達人
LK quest:クエスト「料理人ライチャード」をコンプリート
XS BG Wiki;https://www.bg-wiki.com/ffxi/Way_of_the_Cook;「料理人ライチャード」のあと地球時間で8時間たってから
g01 talk - | マウラ(H-8/I-8)船乗りの宿のRychardeに話して受ける | - | @マウラ H-8/I-8 | T npc.249.Rycharde | W 「料理人ライチャード」から地球時間で8時間たってから
g02 gather - | 「蜂の巣のかけら」と「ダルメルの肉」を1個ずつ用意する | - | N 蜂の巣のかけら*1,ダルメルの肉*1
g03 trade - | Rychardeに2つの品をトレードして完了 | 受けてからヴァナ時間で3日以内だと報酬が多い。 | @マウラ H-8/I-8 | T npc.249.Rycharde | N 蜂の巣のかけら*1,ダルメルの肉*1 | W 受けてからヴァナ時間で3日以内

@ quest.selbina_mhaura.021 https://wiki.ffo.jp/html/4555.html
Q Rycharde the Chef | 料理人ライチャード | no | T npc.249.Rycharde
RW gil:1,500ギル
RW title:食材調達人見習い
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/Rycharde_the_Chef;Numi Adaligo F-9、Take I-8
g01 talk - | マウラ総督府(F-9)のNumi Adaligoに仕事のことを聞く | - | @マウラ F-9 | T npc.249.Numi_Adaligo = npc:Numi Adaligo@マウラ F-9
g02 talk - | 船乗りの宿1階(I-8)のTakeに話す | - | @マウラ I-8 | T npc.249.Take
g03 talk - | 船乗りの宿2階(H-8/I-8)のRychardeに話して受ける | - | @マウラ H-8/I-8 | T npc.249.Rycharde
g04 gather - | 「ダルメルの肉」を2個用意する | - | N ダルメルの肉*2
g05 trade - | Rychardeに「ダルメルの肉」2個をトレードして完了 | このシリーズの次のクエストは、地球時間で数時間たたないと出ない。 | @マウラ H-8/I-8 | T npc.249.Rycharde | N ダルメルの肉*2

@ quest.selbina_mhaura.022 https://wiki.ffo.jp/html/3966.html
Q Fisherman's Heart | 釣り人の心 | no | T npc.249.Katsunaga = npc:Katsunaga@マウラ G-10
RW other:これまでの釣果を教えてもらえる
LK fame:名声ランク2以上
LK condition:釣りスキル20以上（装備などの分も込みでよい）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Fisherman%27s_Heart;名声2
g01 talk - | 釣りスキル20以上でマウラ(G-10)のKatsunagaに話して受ける | 2015年6月25日から(G-10)にいて、機船乗り場の入場料はいらない。 | @マウラ G-10 | T npc.249.Katsunaga
g02 gather - | 「ググリュートゥーナ」を1匹用意する | モグガーデンの海でもとれる。 | N ググリュートゥーナ*1
g03 trade - | Katsunagaに「ググリュートゥーナ」をトレードして完了 | クリアしたあとは、話すだけで釣果を教えてくれる。 | @マウラ G-10 | T npc.249.Katsunaga | N ググリュートゥーナ*1

@ quest.selbina_mhaura.023 https://wiki.ffo.jp/html/11430.html
Q Trial Size Trial by Lightning | 雷の試練・改 | no | T npc.249.Lacia = npc:Lacia@マウラ I-9
RW other:召喚獣“ラムウ”と契約できる
LK fame:マウラの名声ランク2以上
LK condition:Lv15以上の召喚士
XS BG Wiki, FFXIclopedia;https://www.bg-wiki.com/ffxi/Trial-Size_Trial_by_Lightning;Lacia I-9。雷の音叉・改は話したときにもらえ、Lacia にトレードすると試練の場の前へ送ってもらえる。相手は Ramuh Prime、15分、ひとりで、カーバンクルだけ
g01 talk - | Lv15以上の召喚士で、マウラ(I-9)船乗りの宿2階前のLaciaに話して受け、「雷の音叉・改」をもらう | - | @マウラ I-9 | T npc.249.Lacia
g02 trade - | Laciaに「雷の音叉・改」をトレードして、ボヤーダ樹の試練の場の前へ送ってもらう | 準備ができてからでよい。 | @マウラ I-9 | T npc.249.Lacia | N 雷の音叉・改*1
g03 trade - | ボヤーダ樹の巨大なクリスタルに「雷の音叉・改」をかかげて試練の場へ入る | - | @ボヤーダ樹 | N 雷の音叉・改*1
g04 fight - | 1対1の試練でRamuh Primeに勝って完了 | ひとりで、使える召喚獣はカーバンクルだけ。サンダースパークで麻痺し、シアリングライトが出ないことがあるので、薬品は多めに。 | T mob.Ramuh_Prime = mob:Ramuh Prime

@ quest.selbina_mhaura.024 https://wiki.ffo.jp/html/4557.html
Q Unending Chase | 飽くなき追求 | no | T npc.249.Rycharde
RW gil:2,100ギル
RW title:目利きの調達人
LK fame:名声ランク2以上
LK quest:クエスト「料理の道」をコンプリートしてから、ヴァナ時間で8日たっている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Unending_Chase;名声2
g01 talk - | マウラ(H-8/I-8)船乗りの宿のRychardeに話して受ける | - | @マウラ H-8/I-8 | T npc.249.Rycharde | W 「料理の道」からヴァナ時間で8日（地球時間で約7時間41分）たってから
g02 gather - | 「パフボール」を1個用意する | - | N パフボール*1
g03 trade - | Rychardeに「パフボール」をトレードして完了 | - | @マウラ H-8/I-8 | T npc.249.Rycharde | N パフボール*1

@ quest.selbina_mhaura.025 https://wiki.ffo.jp/html/8019.html
Q Donate to Recycling | リサイクル（クエスト） | no | T npc.248.Romeo = npc:Romeo@セルビナ H-9
RW item:くずかご
RW title:エコロジスト
RW other:サンドリアとバストゥークの名声が上がる
g01 talk - | セルビナ(H-9)漁師ギルドの屋上のRomeoに話して受ける | - | @セルビナ H-9 | T npc.248.Romeo
g02 gather - | 同じ種類のオニオン装備を5つ集める | キャラクターを作ったときの武器か、モンクの白帯。モグガーデンでワイルドオニオンを植えても出ることがある。
g03 trade - | Romeoに5つまとめてトレードして完了 | - | @セルビナ H-9 | T npc.248.Romeo

@ quest.selbina_mhaura.026 https://wiki.ffo.jp/html/9453.html
Q Cargo | 補給物資 | yes | T npc.248.Vuntar = npc:Vuntar@セルビナ H-9
RW gil:ロランベリー881で800ギル／874で2000ギル／864で3000ギル／854で4000ギル
RW other:サンドリアとバストゥークの名声が上がる
LK fame:名声ランク3以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Cargo;クロウラーの巣の丸い部屋のかごにロランベリーをトレードすると、ときどき NM が出て、倒すと1段古いロランベリーを落とす（Guardian Crawler→881、Drone Crawler→874、Matron Crawler／Queen Crawler→864）
g01 talk - | セルビナ(H-9)中央の階段の下のVuntarに話して受ける | もう一度受けるには、前のクリアから地球時間の日付が変わってから。 | @セルビナ H-9 | T npc.248.Vuntar
g02 gather - | 「ロランベリー」をいくつか用意する | NMはトレードしても出ないことがあるので多めに。 | N ロランベリー*1
g03 trade - | クロウラーの巣の丸い部屋にあるかごにロランベリーをトレードする | 出たNMは部屋の出口からかごへ歩いてきて、そのあと襲ってくる。 | @クロウラーの巣 | N ロランベリー*1
g04 defeat - | 出たNMを倒して、古いロランベリーを手に入れる | Guardian Crawlerはロランベリー881、Drone Crawler（881をトレード）は874、Matron CrawlerかQueen Crawler（874をトレード）は864を必ず落とす。 | @クロウラーの巣 | T mob.197.Guardian_Crawler = mob:Guardian Crawler@クロウラーの巣
g05 trade - | Vuntarにロランベリー881・874・864・854のどれかをトレードして完了 | 古いものほど高く買い取ってくれる。市販のロランベリーは受け取らない。 | @セルビナ H-9 | T npc.248.Vuntar

@ quest.selbina_mhaura.027 https://wiki.ffo.jp/html/7573.html
Q Trial by Lightning | 雷の試練 | yes | T npc.249.Ripapa
RW item:ラムウスタッフ／ライトニングベルト／ライトニングリング／長老の枝／10,000ギル のどれか1つ
RW other:何もいらないを選ぶと、召喚獣“ラムウ”と契約できる
RW title:大いなる雷の継承者
XS BG Wiki;https://www.bg-wiki.com/ffxi/Trial_by_Lightning;Ripapa は マウラ(I-9)。Repeatable=Yes。名声の条件は書かれていない
g01 talk - | マウラ(I-9)宿屋2階の前（Porter Moogleの横）のRipapaに話して受け、だいじなもの「雷の音叉」をもらう | - | @マウラ I-9 | T npc.249.Ripapa = npc:Ripapa@マウラ I-9
g02 go - | ボヤーダ樹の雷鳴の回廊へ行く | ボヤーダ樹のホームポイント#1がいちばん近い。 | @ボヤーダ樹
g03 fight - | 雷鳴の回廊のLightning Protocrystalに「雷の音叉」をかかげ、試練でRamuh Primeに勝つ | レベル制限なし・フェイス不可。サンダースパークで分身がよくはがれ、麻痺もつく。ジャッジボルトで敵対心がリセットされるので、ケアルを少し遅らせる。勝つとだいじなもの「雷の息吹」。 | @ボヤーダ樹 | T mob.Ramuh_Prime | K 雷の音叉
g04 talk - | マウラのRipapaに話して報酬を選び、完了 | 地球時間の0時を過ぎるとまた音叉をもらえる。 | @マウラ I-9 | T npc.249.Ripapa | K 雷の息吹

@ quest.selbina_mhaura.028 https://wiki.ffo.jp/html/15668.html
Q Recycling Rods | 折れた釣り竿の謎 | no | T npc.249.Keshab-Menjab = npc:Keshab-Menjab@マウラ H-9
RW gil:1500
RW other:プルゴノルゴ島のPohka Chichiyowahlの店がふつうの値段になる
LK fame:名声ランク1以上（どの地域の名声かは資料にない）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Recycling_Rods;Fame=Other、FLevel=1、Repeatable=no。Keshab-Menjab は (H-9) の下の段（FFXIclopedia も Keshab-Menjab）。プルゴノルゴ島で Lancet Jagil を釣り上げる
g01 talk - | マウラ(H-9)の下の段のKeshab-Menjabに話して受ける | - | @マウラ H-9 | T npc.249.Keshab-Menjab
g02 fight - | ビビキー湾のプルゴノルゴ島でNM「Lancet Jagil」を釣り上げて倒し、「綺麗な折れ口の釣竿」を手に入れる | - | @ビビキー湾 #2 | T mob.4.Lancet_Jagil = mob:Lancet Jagil@ビビキー湾 #2
g03 trade - | Keshab-Menjabに綺麗な折れ口の釣竿をトレードして完了 | - | @マウラ H-9 | T npc.249.Keshab-Menjab | N 綺麗な折れ口の釣竿*1
