# 蝕世のエンブリオ（0.1.136〜）。基礎シートのミッション一覧 485〜531 行と、シートになかった 1番目（649 行に足した）。id の番号と order は用語辞典の通し番号（1〜46）。MN の番号は BG Wiki の章と節
@ mission.tvr.001 https://wiki.ffo.jp/html/37995.html
Q The Voracious Resurgence | 蝕世のエンブリオ | no | T npc.234.Gumbah
MN TVR1-1 1
LK condition:ヴァナ・ディールの星唄をクリアし、拡張データのレジストレーションコード5つを登録している。盟-イロハIIを覚えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_1-1;星唄を済ませ、盟-イロハIIを覚えている必要がある。Gumbah はバストゥーク鉱山区 J-7。上の通路の家の奥の部屋で、ホームポイント#3が近い（FFXIclopedia：このミッションのページはない）
g01 go - | バストゥーク鉱山区(J-7)の上の通路にあるGumbahの家へ行く | ホームポイント#3が近い。上の通路にある家の奥の部屋。 | @バストゥーク鉱山区 J-7
g02 talk - | Gumbahに話してイベントを見ると完了 | 盟-イロハIIを覚えていないと始まらない。なくしたときは醴泉島(K-9)のMystic Retrieverでもう一度もらえる。続けて次の「グルームファントムの襲来」になる。 | @バストゥーク鉱山区 J-7 | T npc.234.Gumbah

@ mission.tvr.002 https://wiki.ffo.jp/html/38007.html
Q The Gloom Phantom's Approach | グルームファントムの襲来 | no | T obj.172.Disturbed_Dirt = obj:Disturbed Dirt@ツェールン鉱山 K-9
MN TVR1-2 2
RW gil:20,000ギル
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_1-2;バストゥーク鉱山区から歩いてツェールン鉱山に入るとイベント。Makarim（H-11）と Rasmus（I-6）の話は任意。K-9 の Disturbed Dirt を2回調べて Gloom Phantom（約3万HP）とコンフロント戦（FFXIclopedia：Disturbed Dirt は K-9。15分制限でLv制限なし）
g01 go - | バストゥーク鉱山区から歩いてツェールン鉱山に入り、イベントを見る | ワープやサバイバルガイドではなく、バストゥーク鉱山区から歩いて入る。 | @ツェールン鉱山
g02 talk - | （してもしなくてもよい）ツェールン鉱山(H-11)のMakarimに話す | 次に調べる場所の話が聞ける。I-6のRasmusにも話を聞ける。 | @ツェールン鉱山 H-11 | T npc.172.Makarim
g03 go - | ツェールン鉱山(K-9)へ行く | | @ツェールン鉱山 K-9
g04 examine - | ツェールン鉱山(K-9)のDisturbed Dirtを調べてイベントを見る | | @ツェールン鉱山 K-9 | T obj.172.Disturbed_Dirt
g05 examine - | もう一度Disturbed Dirtを調べてコンフロント戦に入る | 制限時間15分、Lv制限なし。フェイスは先に呼んでおく。 | @ツェールン鉱山 K-9 | T obj.172.Disturbed_Dirt
g06 defeat - | Gloom Phantomを倒す | HPは約3万。ブラッドウェポンなどの強い技を使う。負けたらDisturbed Dirtを調べてやり直す。 | @ツェールン鉱山 K-9 | T mob.172.Gloom_Phantom = mob:Gloom Phantom@ツェールン鉱山 K-9
g07 examine - | Disturbed Dirtをもう一度調べてイベントを見ると完了 | 20,000ギルもらえる。 | @ツェールン鉱山 K-9 | T obj.172.Disturbed_Dirt

@ mission.tvr.003 https://wiki.ffo.jp/html/38008.html
Q The Brygid Cup | ブリジッド杯 | no | T npc.235.Brygid
MN TVR1-3 3
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_1-3;Gumbah の次に商業区の Brygid に2回話して、まねる人を選ぶ。頭・胴・両手・両脚・両足の見た目をそろえ（/lockstyle でもよい）、バストゥーク港 E-7 の Steaming Sheep の前の Ruenda に話す。いちばん楽なのは Nbu Latteh（Bronze Harness・Scale Cuisses・Scale Greaves。商業区 E-10 の Brunhilde Armorer かスパークス）。終わると 20,000〜22,000 ギル（FFXIclopedia：Ruenda は E-7。似ていなくても完了する）
g01 talk - | バストゥーク鉱山区(J-7)のGumbahに話してイベントを見る | 前のミッションと同じ家の奥の部屋。 | @バストゥーク鉱山区 J-7 | T npc.234.Gumbah
g02 talk - | バストゥーク商業区(K-9)のBrygidに話してイベントを見る | ホームポイント#4が近い。 | @バストゥーク商業区 K-9 | T npc.235.Brygid
g03 talk - | もう一度Brygidに話し、まねる人を1人選ぶ | Nbu Latteh（胴Bronze Harness・両脚Scale Cuisses・両足Scale Greaves）がいちばん安くそろう。どの人を選んでも進む。 | @バストゥーク商業区 K-9 | T npc.235.Brygid
g04 go - | 選んだ人の頭・胴・両手・両脚・両足の見た目をそろえる | /lockstyleでもよい。Nbu Latteh用の3つは商業区(E-10)のBrunhilde Armorerで約3,000ギル、スパークスでも買える。武器・アクセサリー・種族・性別は関係ない。 | @バストゥーク商業区 E-10
g05 talk - | その見た目でバストゥーク港(E-7)の蒸気の羊亭の前のRuendaに話し、大会に出る | 着替えたときは/lockstyleを切るか、装備セットを作っておく。 | @バストゥーク港 E-7 | T npc.236.Ruenda = npc:Ruenda@バストゥーク港 E-7
g06 talk - | バストゥーク商業区(K-9)のBrygidに話してイベントを見ると完了 | ギルがもらえる。似ていなくても完了する。 | @バストゥーク商業区 K-9 | T npc.235.Brygid

@ mission.tvr.004 https://wiki.ffo.jp/html/38046.html
Q The Destiny Destroyers | ディスティニーデストロイヤー団 | no | T obj.173.Stalagmite = obj:Stalagmite@コロロカの洞門 D-9 #1
MN TVR1-4 4
RW item:マートの薬
RW item:オムレツサンド×12
RW title:ディスティニーデストロイヤー団デストロイヤー
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_1-4;Gumbah の次にコロロカの洞門 Map 1 D-9 の Stalagmite（下の段）を2回調べて Gloom Phantom・Dazbog・Magh Bihu とコンフロント戦。サバイバルガイドでツェールン鉱山へ飛ぶと近い（FFXIclopedia：Stalagmite は Map 1 D-9）
g01 talk - | バストゥーク鉱山区(J-7)のGumbahに話してイベントを見る | | @バストゥーク鉱山区 J-7 | T npc.234.Gumbah
g02 go - | ツェールン鉱山からコロロカの洞門に入り、MAP1(D-9)へ行く | サバイバルガイドでツェールン鉱山へ飛ぶと近い。下の段を進む。 | @コロロカの洞門 D-9 #1
g03 examine - | コロロカの洞門(D-9)のStalagmiteを調べてイベントを見る | | @コロロカの洞門 D-9 #1 | T obj.173.Stalagmite
g04 examine - | もう一度Stalagmiteを調べてコンフロント戦に入る | 制限時間15分。フェイスは先に呼んでおく。3体と同時に戦う。 | @コロロカの洞門 D-9 #1 | T obj.173.Stalagmite
g05 defeat - | Gloom Phantomを倒す | 3体の技がつながると大きく削られる。1体ずつ倒す。 | @コロロカの洞門 D-9 #1 | T mob.173.Gloom_Phantom = mob:Gloom Phantom@コロロカの洞門 D-9 #1
g06 defeat - | Dazbogを倒す | Gloom Phantomと同じ戦いにいる。 | @コロロカの洞門 D-9 #1 | T mob.173.Dazbog = mob:Dazbog@コロロカの洞門 D-9 #1
g07 defeat - | Magh Bihuを倒す | Gloom Phantomと同じ戦いにいる。範囲の回復を使う。 | @コロロカの洞門 D-9 #1 | T mob.173.Magh_Bihu = mob:Magh Bihu@コロロカの洞門 D-9 #1
g08 examine - | Stalagmiteをもう一度調べてイベントを見る | | @コロロカの洞門 D-9 #1 | T obj.173.Stalagmite
g09 talk - | バストゥーク鉱山区(J-7)のGumbahに話してイベントを見ると完了 | | @バストゥーク鉱山区 J-7 | T npc.234.Gumbah

@ mission.tvr.005 https://wiki.ffo.jp/html/38091.html
Q Kupipi's Dilemma | クピピの受難 | no | T npc.天の塔.Kupipi
MN TVR2-1 5
RW gil:20,000ギル
RW title:完熟ヒーロー
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_2-1;天の塔の Kupipi の次に Sassa-Kotassa に Red Grass Cloth、Sheelala に Yagudo Drink、Habida-Jubida に Dream Flower Petal を渡す（順不同）。Kupipi に White Berry か Ripe White Berry を渡し、ウィンダス石の区 K-7 の Shantotto に話す（FFXIclopedia：Kupipi は Map 2 H-6、Sassa-Kotassa は Map 2 H-7、Sheelala は H-9、Habida-Jubida は G-9）
g01 talk - | 天の塔の書記官の間のKupipiに話してイベントを見る | ウィンダス石の区のホームポイント#1から入るとすぐ。 | @天の塔 | T npc.天の塔.Kupipi
g02 trade - | 天の塔の書記官の間のすぐ外にいるSassa-Kotassaに話し、「赤草布」をトレードする | 3人は順不同。 | @天の塔 H-7 #2 | T npc.天の塔.Sassa-Kotassa = npc:Sassa-Kotassa@天の塔 H-7 #2 | N 赤草布*1
g03 trade - | 天の塔の中央の泉の南にいるSheelalaに話し、「ヤグードドリンク」をトレードする | 競売で買える。 | @天の塔 H-9 #2 | T npc.天の塔.Sheelala = npc:Sheelala@天の塔 H-9 #2 | N ヤグードドリンク*1
g04 trade - | 天の塔の西の端にいるHabida-Jubidaに話し、「夢想花の花びら」をトレードする | 競売で買える。 | @天の塔 G-9 #2 | T npc.天の塔.Habida-Jubida = npc:Habida-Jubida@天の塔 G-9 #2 | N 夢想花の花びら*1
g05 trade - | Kupipiに「ホワイトベリー」か「完熟ホワイトベリー」をトレードしてイベントを見る | どちらでもよい。競売で買える。 | @天の塔 | T npc.天の塔.Kupipi | N ホワイトベリー*1
g06 talk - | ウィンダス石の区(K-7)のShantottoに話してイベントを見ると完了 | | @ウィンダス石の区 K-7 | T npc.239.Shantotto

@ mission.tvr.006 https://wiki.ffo.jp/html/38092.html
Q The Cardians' Duty | カーディアンの使命 | no | T obj.116.Disturbed_Earth = obj:Disturbed Earth@東サルタバルタ J-8
MN TVR2-2 6
RW gil:20,000ギル
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_2-2;Shantotto の次に Kupipi。東サルタバルタ J-8（塔の南、谷の壁ぎわ）の Disturbed Earth を2回調べ、Yagudo Underling 2体・Yagudo Centurion・Yagudo Vicar とコンフロント戦。King of Spades が倒れると失敗（FFXIclopedia：Disturbed Earth は J-8。やり直しは Disturbed Earth を調べるだけ）
g01 talk - | ウィンダス石の区(K-7)のShantottoに話してイベントを見る | 前のミッションから続けて話せる。 | @ウィンダス石の区 K-7 | T npc.239.Shantotto
g02 talk - | 天の塔の書記官の間のKupipiに話してイベントを見る | | @天の塔 | T npc.天の塔.Kupipi
g03 talk - | （してもしなくてもよい）天の塔のSassa-Kotassa・Sheelala・Habida-Jubidaに話す | 次に行く場所の話が聞ける。 | @天の塔 H-7 #2 | T npc.天の塔.Sassa-Kotassa
g04 go - | 東サルタバルタ(J-8)へ行く | 北東の塔の南、谷の壁ぎわ。 | @東サルタバルタ J-8
g05 examine - | 東サルタバルタ(J-8)のDisturbed Earthを調べてイベントを見る | | @東サルタバルタ J-8 | T obj.116.Disturbed_Earth
g06 examine - | もう一度Disturbed Earthを調べてコンフロント戦に入る | 4体と同時に戦う。味方のKing of Spadesが倒れると負けになるので守る。負けたらDisturbed Earthを調べてやり直す。 | @東サルタバルタ J-8 | T obj.116.Disturbed_Earth
g07 defeat - | Yagudo Underling 2体を倒す | 忍者とモンクの2体。 | @東サルタバルタ J-8 | T mob.116.Yagudo_Underling = mob:Yagudo Underling@東サルタバルタ J-8
g08 defeat - | Yagudo Centurionを倒す | 黒魔道士。 | @東サルタバルタ J-8 | T mob.116.Yagudo_Centurion = mob:Yagudo Centurion@東サルタバルタ J-8
g09 defeat - | Yagudo Vicarを倒す | 白魔道士。 | @東サルタバルタ J-8 | T mob.116.Yagudo_Vicar = mob:Yagudo Vicar@東サルタバルタ J-8
g10 examine - | Disturbed Earthをもう一度調べてイベントを見る | | @東サルタバルタ J-8 | T obj.116.Disturbed_Earth
g11 talk - | 天の塔のKupipiに話してイベントを見ると完了 | | @天の塔 | T npc.天の塔.Kupipi

@ mission.tvr.007 https://wiki.ffo.jp/html/38102.html
Q Zhuu Buxu's Gambit | ズー・ブシュの戯れ | no | T obj.145.Worn_Chest = obj:Worn Chest@ギデアス F-6 #2
MN TVR2-3 7
RW gil:20,000ギル
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_2-3;Kupipi から召喚状をもらい、ウィンダス水の区の Tosuka-Porika。ギデアス Map 2 F-6（地下の宝物庫、Wistaria Door の奥）の Worn Chest を調べるとすぐ Yagudo Lookout（約3万HP）と戦う。戦ったあとにエリアを出ても、もう一度調べれば戦わずに進む（FFXIclopedia：Worn Chest は地下 F-6）
g01 talk - | 天の塔のKupipiに話し、だいじなもの「星紋章入りの召喚状：目の院宛て」をもらう | 前のミッションから続けて話せる。 | @天の塔 | T npc.天の塔.Kupipi
g02 talk - | ウィンダス水の区(G-8)の目の院のTosuka-Porikaに話してイベントを見る | | @ウィンダス水の区 G-8 | T npc.238.Tosuka-Porika
g03 go - | ギデアスのMAP2(F-6)の宝物庫へ行く | 地下の宝物庫で、扉を開けて入る。フェイスは先に呼んでおく。 | @ギデアス F-6 #2
g04 examine - | ギデアス(F-6)のWorn Chestを調べる | 調べるとすぐ後ろからYagudo Lookoutに襲われる。制限時間15分、Lv制限なし。 | @ギデアス F-6 #2 | T obj.145.Worn_Chest
g05 defeat - | Yagudo Lookoutを倒す | HPは約3万の侍。HPが減ると明鏡止水を何度か使う。睡眠が効く。 | @ギデアス F-6 #2 | T mob.145.Yagudo_Lookout = mob:Yagudo Lookout@ギデアス F-6 #2
g06 examine - | もう一度Worn Chestを調べてイベントを見て、だいじなもの「変な人形」をもらう | 先にエリアを出ても、戻って調べれば戦い直さなくてよい。 | @ギデアス F-6 #2 | T obj.145.Worn_Chest
g07 talk - | ウィンダス水の区(G-8)のTosuka-Porikaに話してイベントを見ると完了 | | @ウィンダス水の区 G-8 | T npc.238.Tosuka-Porika

@ mission.tvr.008 https://wiki.ffo.jp/html/38103.html
Q Star Onion Fortune | スターオニオンズ団の幸運 | no | T obj.153.Muggy_Air = obj:Muggy Air@ボヤーダ樹 D-5 H-6 H-9 #1
MN TVR2-4 8
RW item:おでん×12
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_2-4;Tosuka-Porika の次にウィンダス港 G-5 の Kohlo-Lakolo（Shanruru のイベントは任意）。だいじなものを見てからもう一度 Kohlo-Lakolo。ボヤーダ樹 Map 1 の D-5・H-6・H-9 の Muggy Air のうち白く光るものを調べると Templar Crawler が出る（FFXIclopedia：光る場所は毎回変わる。Map 1 の D-5・H-6・H-9）
g01 talk - | ウィンダス水の区(G-8)のTosuka-Porikaに話し、もう一度「変な人形」を受け取る | | @ウィンダス水の区 G-8 | T npc.238.Tosuka-Porika
g02 talk - | ウィンダス港(G-5)の倉庫の裏にいるKohlo-Lakoloに話してイベントを見て、だいじなもの「しょうこひん」をもらう | 変な人形と引き換えになる。 | @ウィンダス港 G-5 | T npc.240.Kohlo-Lakolo | K 変な人形
g03 talk - | （してもしなくてもよい）ウィンダス港のShanruruに話してイベントを見る | | @ウィンダス港
g04 go - | だいじなもの「しょうこひん」の説明を見る | メニューのだいじなものから開く。 | @ウィンダス港 G-5
g05 talk - | もう一度Kohlo-Lakoloに話してイベントを見る | 解読できたか聞かれるが、できていなくても進む。 | @ウィンダス港 G-5 | T npc.240.Kohlo-Lakolo
g06 go - | ボヤーダ樹のMAP1へ行く | Knight Crawlerがいる3か所（D-5・H-6・H-9）を回る。 | @ボヤーダ樹 D-5 H-6 H-9 #1
g07 examine - | ボヤーダ樹の白く光っているMuggy Airを調べる | 光る場所は毎回変わる。調べるとすぐNMが出るので準備は先に。 | @ボヤーダ樹 D-5 H-6 H-9 #1 | T obj.153.Muggy_Air
g08 defeat - | Templar Crawlerを倒し、だいじなもの「完璧な幸運の卵」をもらう | コンフロント戦ではない普通の戦い。ポイズンブレスで900くらい受けるのでHPを高く保つ。 | @ボヤーダ樹 D-5 H-6 H-9 #1 | T mob.153.Templar_Crawler = mob:Templar Crawler@ボヤーダ樹 D-5 H-6 H-9 #1
g09 talk - | ウィンダス港(G-5)のKohlo-Lakoloに話してイベントを見ると完了 | | @ウィンダス港 G-5 | T npc.240.Kohlo-Lakolo

@ mission.tvr.009 https://wiki.ffo.jp/html/38104.html
Q The Doll Whisperer | 魔法人形の呼び声 | no | T obj.115.Secluded_Spot = obj:Secluded Spot@西サルタバルタ J-8
MN TVR2-5 9
RW item:マートの薬
RW item:完璧な幸運の卵
RW title:ケテロテククムウラケミニ
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_2-5;Kohlo-Lakolo の次に西サルタバルタ J-8（塔の南、木の陰。ウィンダス水の区のホームポイント#1が近い）の Secluded Spot を2回調べて Chepelle（獣使い）とコンフロント戦。Tiger で始まり、HP75%で Sheep、50%で Hare を呼ぶ。ペットは倒さなくてもよく、眠りが効く。勝ったら Secluded Spot、Kohlo-Lakolo で悪い魔法人形さん、Kupipi で報酬（FFXIclopedia：Secluded Spot は J-8、Rose Tower のそば。Kupipi は Map 2 H-6）
g01 talk - | ウィンダス港(G-5)のKohlo-Lakoloに話してイベントを見る | 前のミッションから続けて話せる。 | @ウィンダス港 G-5 | T npc.240.Kohlo-Lakolo
g02 go - | 西サルタバルタ(J-8)へ行く | 塔の南の木の陰。ウィンダス水の区のホームポイント#1から出るとすぐ。 | @西サルタバルタ J-8
g03 examine - | 西サルタバルタ(J-8)のSecluded Spotを調べてイベントを見る | | @西サルタバルタ J-8 | T obj.115.Secluded_Spot
g04 examine - | もう一度Secluded Spotを調べてコンフロント戦に入る | Chepelleは途中でペットを増やす。フェイスは先に呼んでおく。 | @西サルタバルタ J-8 | T obj.115.Secluded_Spot
g05 defeat - | Chepelle's Tigerを倒す | ChepelleのHPが減るとChepelle's SheepとChepelle's Hareも出る。ペットは眠りが効き、倒さなくても勝てることがある。 | @西サルタバルタ J-8 | T mob.115.Chepelles_Tiger = mob:Chepelle's Tiger@西サルタバルタ J-8
g06 defeat - | Chepelleを倒す | 物理も魔法も受けるダメージが少ない。片手斧のWSを使う。 | @西サルタバルタ J-8 | T mob.115.Chepelle = mob:Chepelle@西サルタバルタ J-8
g07 examine - | Secluded Spotをもう一度調べてイベントを見る | | @西サルタバルタ J-8 | T obj.115.Secluded_Spot
g08 talk - | ウィンダス港(G-5)のKohlo-Lakoloに話してイベントを見て、だいじなもの「悪い魔法人形さん」をもらう | | @ウィンダス港 G-5 | T npc.240.Kohlo-Lakolo
g09 talk - | 天の塔のKupipiに話して「悪い魔法人形さん」を渡し、イベントを見ると完了 | | @天の塔 | T npc.天の塔.Kupipi | K 悪い魔法人形さん

@ mission.tvr.010 https://wiki.ffo.jp/html/38180.html
Q Dancing Prince | 踊るトリオン | no | T obj.150.Ritual_Site = obj:Ritual Site@修道窟 H-10
MN TVR3-1 10
RW gil:20,000ギル
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_3-1;Halver の次に西の王立騎士団の Rahal。ダボイの Quemaricond は G-7 か H-7 の道を行き来している（プロトワープかサバイバルガイドが近い）。ダボイ H-11 から修道窟に入り、H-10 と H-9 の境目の Ritual Site を調べて Orcish Bewitcher（黒/暗、約3万HP、魔力の泉）とコンフロント戦。倒すとオーク帝国の作戦図。Quemaricond でクマリコンの調査報告書、Rahal で報酬（FFXIclopedia：Rahal H-9、Quemaricond H-7、修道窟の入口 H-11、Ritual Site H-10）
g01 talk - | ドラギーユ城(I-9)のHalverに話してイベントを見て、「はい」を選ぶ | | @ドラギーユ城 I-9 | T npc.233.Halver
g02 talk - | ドラギーユ城(H-9)のRahalに話してイベントを見る | 西の王立騎士団の詰所にいる。 | @ドラギーユ城 H-9 | T npc.233.Rahal
g03 talk - | ダボイ(H-7)のあたりを歩くQuemaricondに話してイベントを見る | G-7とH-7のあいだの道を行き来している。ダボイのプロトワープかサバイバルガイドが近い。 | @ダボイ H-7 | T npc.149.Quemaricond
g04 go - | ダボイ(H-11)から修道窟に入る | 先に準備しておく。 | @ダボイ H-11
g05 examine - | 修道窟(H-10)のRitual Siteを調べる | H-9との境目の近く。調べるとすぐコンフロント戦になる。制限時間15分。 | @修道窟 H-10 | T obj.150.Ritual_Site
g06 defeat - | Orcish Bewitcherを倒し、だいじなもの「オーク帝国の作戦図」をもらう | HPは3万〜4万。HPが減ると魔力の泉を使う。 | @修道窟 H-10 | T mob.150.Orcish_Bewitcher = mob:Orcish Bewitcher@修道窟 H-10
g07 talk - | ダボイ(H-7)のQuemaricondに話してイベントを見て、だいじなもの「クマリコンの調査報告書」をもらう | エスケプで修道窟から出ると早い。 | @ダボイ H-7 | T npc.149.Quemaricond
g08 talk - | ドラギーユ城(H-9)のRahalに話してイベントを見ると完了 | 2つのだいじなものを渡す。 | @ドラギーユ城 H-9 | T npc.233.Rahal | K クマリコンの調査報告書

@ mission.tvr.011 https://wiki.ffo.jp/html/38181.html
Q Claidie's Concern | クレーディの冴えたやり方 | no | T obj.7.Harvesting_Point_H-8 = obj:Harvesting Point@アットワ地溝 H-8
MN TVR3-2 11
RW gil:20,000ギル
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_3-2;Halver の次に中央庭園の西の Queen Leaute's Memorial Garden（F-7）へ行くとイベント。鎌を持ってアットワ地溝 H-8 の光る花の Harvesting Point で採るとキンノキリンソウ（Trailblazing Sickle とその+1は使えない。この場所だけ。ユニティのワープ125が近い）。Chalvatot、Halver で報酬（FFXIclopedia：Harvesting Point は H-8 の北西の隅。Chalvatot は F-7）
g01 talk - | ドラギーユ城(I-9)のHalverに話してイベントを見る | 前のミッションから続けて話せる。 | @ドラギーユ城 I-9 | T npc.233.Halver
g02 go - | ドラギーユ城の庭園の前の廊下へ行き、イベントを見る | 庭園の前の廊下のF-8、王妃の庭園はF-7。中央の庭園の西。 | @ドラギーユ城 F-8 F-7
g03 go - | 「草刈鎌」を持ってアットワ地溝(H-8)へ行く | ユニティのワープが近い。真ん中の大きな裂け目のあたり。 | @アットワ地溝 H-8
g04 trade - | アットワ地溝(H-8)の光るHarvesting Pointで採集し、だいじなもの「キンノキリンソウ」をもらう | この場所のHarvesting Pointだけ。Trailblazing Sickleとその+1は使えない。先にChalvatotに話すと場所のヒントが聞ける。 | @アットワ地溝 H-8 | T obj.7.Harvesting_Point_H-8 | N 草刈鎌*1
g05 talk - | ドラギーユ城(F-7)の庭園のChalvatotに話してイベントを見る | | @ドラギーユ城 F-7 | T npc.233.Chalvatot | K キンノキリンソウ
g06 talk - | ドラギーユ城(I-9)のHalverに話してイベントを見ると完了 | | @ドラギーユ城 I-9 | T npc.233.Halver

@ mission.tvr.012 https://wiki.ffo.jp/html/38268.html
Q Curilla Unleashed | クリルラの狂おしき一日 | no | T npc.233.Halver
MN TVR3-3 12
RW item:ペアリシールド
RW title:ラブ・ア・ライブ
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_3-3;前のミッションのあとエリアを移ってから Halver でアルテニアへの手紙。ラングモント峠 J-8 の Vicious Claw Marks で Harnessed Smilodon（戦、約3.5万HP、マイティストライク）とコンフロント戦。もう一度調べて Altennia のイベント、Halver、中央庭園の北の扉 H-7 の Door:Prince Royal's Rm。ボストーニュ監獄の上の階 H-9 の Frigid Confluence で Trion（約2.5万HP、防御が高い、インビンシブル）。E-7/E-8 の穴に落ちない。神殿騎士団の詰所の Curilla で報酬（FFXIclopedia：ボストーニュ監獄 Map 1 H-9。Curilla は I-9）
g01 go - | 前のミッションのあとエリアを移る | 移らないとHalverのイベントが始まらない。 | @ドラギーユ城
g02 talk - | ドラギーユ城(I-9)のHalverに話してイベントを見て、だいじなもの「アルテニアへの手紙」をもらう | | @ドラギーユ城 I-9 | T npc.233.Halver
g03 go - | ラングモント峠(J-8)へ行く | サバイバルガイドが近い。東ロンフォールのK-4からも入れる。 | @ラングモント峠 J-8
g04 examine - | ラングモント峠(J-8)のVicious Claw Marksを調べる | 調べるとすぐコンフロント戦になるので準備は先に。制限時間15分。 | @ラングモント峠 J-8 | T obj.166.Vicious_Claw_Marks = obj:Vicious Claw Marks@ラングモント峠 J-8
g05 defeat - | Harnessed Smilodonを倒す | 攻撃力が高いので盾のフェイスがいると楽。HPが減るとマイティストライクと範囲アムネジアの魂の咆哮を使う。 | @ラングモント峠 J-8 | T mob.166.Harnessed_Smilodon = mob:Harnessed Smilodon@ラングモント峠 J-8
g06 examine - | もう一度Vicious Claw Marksを調べてイベントを見る | 手紙はなくなる。 | @ラングモント峠 J-8 | T obj.166.Vicious_Claw_Marks
g07 talk - | ドラギーユ城(I-9)のHalverに話してイベントを見る | | @ドラギーユ城 I-9 | T npc.233.Halver
g08 examine - | ドラギーユ城(H-7)のDoor:Prince Royal's Rmを調べてイベントを見る | 中央の庭園の北の扉。 | @ドラギーユ城 H-7 | T obj.233.Door_Prince_Royals_Rm
g09 go - | ドラギーユ城からボストーニュ監獄に入り、MAP1(H-9)へ行く | 上の階のまま進む。E-7・E-8の穴に落ちない。 | @ボストーニュ監獄 H-9 #1
g10 examine - | ボストーニュ監獄(H-9)のFrigid Confluenceを調べる | 調べるとすぐコンフロント戦になるので準備は先に。 | @ボストーニュ監獄 H-9 #1 | T obj.167.Frigid_Confluence = obj:Frigid Confluence@ボストーニュ監獄 H-9 #1
g11 defeat - | Trionを倒す | 防御が高い。HPが減るとインビンシブルを使い、強い技は空蝉を抜ける。勝つと自動でイベントになる。 | @ボストーニュ監獄 H-9 #1 | T mob.167.Trion = mob:Trion@ボストーニュ監獄 H-9 #1
g12 talk - | ドラギーユ城(I-9)のCurillaに話してイベントを見ると完了 | 神殿騎士団の詰所にいる。ほかのクエストがあるときは何度か話す。 | @ドラギーユ城 I-9 | T npc.233.Curilla

@ mission.tvr.013 https://wiki.ffo.jp/html/38293.html
Q Run, Excenmille, Run! | 走れ、エグセニミル | no | T obj.111.Ferric_Stench = obj:Ferric Stench@ボスディン氷河 H-8
MN TVR3-4 13
RW item:Ｈエリクサータンク
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_3-4;前のミッションからヴァナ時間の1日待つ。Halver、王立騎士団の詰所の Rahal。ボスディン氷河 H-8 の塔の東側の Ferric Stench で Orcish Atlatl・Orcish Axeman・Orcish Praetor・Harnessed Smilodon とコンフロント戦、紅燕騎士隊が記した地図。もう一度調べてイベント。いちばん下の段の Mirror Pond のそば、J-6/I-6 の左下の角の Point of Interest で報酬。次のミッションで Doll Gizmo が要る（競売か、ウガレピ寺院 Map 2 I-10/J-10 の Manipulator が必ず落とす）（FFXIclopedia：Rahal H-9。Ferric Stench は H-8 のサバイバルガイドのそば。Point of Interest は J-6）
g01 go - | 前のミッションからヴァナ時間の日が変わるまで待ち、エリアを移る | 待つあいだに次のミッションで使う「ドールギズモ」を用意しておくとよい。競売で買える。 | W ヴァナ時間の日が変わってから
g02 talk - | ドラギーユ城(I-9)のHalverに話してイベントを見る | | @ドラギーユ城 I-9 | T npc.233.Halver
g03 talk - | ドラギーユ城(H-9)のRahalに話してイベントを見る | 王立騎士団の詰所にいる。 | @ドラギーユ城 H-9 | T npc.233.Rahal
g04 go - | ボスディン氷河(H-8)へ行く | サバイバルガイドかアウトポストテレポ：フォルガンディ地方が近い。塔の東側。 | @ボスディン氷河 H-8
g05 examine - | ボスディン氷河(H-8)のFerric Stenchを調べる | 調べるとすぐコンフロント戦になるので準備は先に。制限時間15分。4体と同時に戦うので早く数を減らす。どれも眠りが効く。 | @ボスディン氷河 H-8 | T obj.111.Ferric_Stench
g06 defeat - | Orcish Axemanを倒す | HPが半分ほどになるとマイティストライクを使う。 | @ボスディン氷河 H-8 | T mob.111.Orcish_Axeman = mob:Orcish Axeman@ボスディン氷河 H-8
g07 defeat - | Orcish Atlatlを倒す | HPが半分ほどになるとマイティストライクを使う。 | @ボスディン氷河 H-8 | T mob.111.Orcish_Atlatl = mob:Orcish Atlatl@ボスディン氷河 H-8
g08 defeat - | Orcish Praetorを倒す | | @ボスディン氷河 H-8 | T mob.111.Orcish_Praetor = mob:Orcish Praetor@ボスディン氷河 H-8
g09 defeat - | Harnessed Smilodonを倒し、だいじなもの「紅燕騎士隊が記した地図」をもらう | 4体を全部倒すともらえる。 | @ボスディン氷河 H-8 | T mob.111.Harnessed_Smilodon = mob:Harnessed Smilodon@ボスディン氷河 H-8
g10 examine - | もう一度Ferric Stenchを調べてイベントを見る | 地図はなくなる。 | @ボスディン氷河 H-8 | T obj.111.Ferric_Stench
g11 go - | ボスディン氷河(J-6)へ行く | いちばん下の段で、Mirror Pondのそば。ユニティのワープでフェ・インへ飛び、南へ出ると近い。 | @ボスディン氷河 J-6
g12 examine - | ボスディン氷河(J-6)のPoint of Interestを調べてイベントを見ると完了 | 次のミッションへ続けるときはワープで離れない。 | @ボスディン氷河 J-6 | T obj.111.Point_of_Interest = obj:Point of Interest@ボスディン氷河 J-6

@ mission.tvr.014 https://wiki.ffo.jp/html/38296.html
Q Of Knights and Orcs | 騎士とオークと喰らうものども | no | T obj.111.Point_of_Interest
MN TVR3-5 14
RW item:マートの薬
RW item:ペアリソード
RW title:目覚めを見届けし者
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_3-5;先に Doll Gizmo を用意する（競売か、ウガレピ寺院 Map 2 I-10/J-10 の Manipulator）。ボスディン氷河からフェ・インに入るとイベント。Map 2 H-7 の Talos（Capricious Cassie の大部屋から南の廊下 H-6 の先、扉の前の人形の残骸。ワイドスキャンに出ない）に Doll Gizmo をトレード。ボスディン氷河 J-6 の南西の角、Mirror Pond のそばの Point of Interest を2回調べて Slackjawed Mukdrom（戦、約5万HP、マイティストライクを何度も）とコンフロント戦。もう一度調べてイベント、ドラギーユ城 H-7 の Door:Prince Royal's Rm で報酬（FFXIclopedia：Talos は Map 2 H-7。Point of Interest は J-6。Excenmille が手伝う）
g01 go - | ボスディン氷河から歩いてフェ・インに入り、イベントを見る | ホームポイントなどのワープで入ると起きない。先に「ドールギズモ」を用意しておく。 | @フェ・イン
g02 go - | フェ・インの下の階(H-7)へ行く | マップの番号は資料によってMAP2とMAP3がある。Capricious Cassieが出る大部屋から南の廊下を進んだ先の扉の前。 | @フェ・イン H-7
g03 examine - | フェ・イン(H-7)のTalosを調べ、「調べてみる」を選ぶ | 壊れた人形の残骸。ワイドスキャンには出ない。 | @フェ・イン H-7 | T npc.204.Talos = npc:Talos@フェ・イン H-7
g04 trade - | Talosに「ドールギズモ」をトレードしてイベントを見る | 競売で買える。ウガレピ寺院のManipulatorも必ず落とす。 | @フェ・イン H-7 | T npc.204.Talos | N ドールギズモ*1
g05 go - | ボスディン氷河(J-6)へ行く | 黒魔道士のサポートでエスケプすると近い。Mirror Pondのそば。 | @ボスディン氷河 J-6
g06 examine - | ボスディン氷河(J-6)のPoint of Interestを調べ、「はい」を選んでイベントを見る | | @ボスディン氷河 J-6 | T obj.111.Point_of_Interest
g07 examine - | もう一度Point of Interestを調べてコンフロント戦に入る | 制限時間15分。味方のExcenmilleが倒れると負けになる。Excenmilleは敵を引きつけにくいので盾を別に用意する。 | @ボスディン氷河 J-6 | T obj.111.Point_of_Interest
g08 defeat - | Slackjawed Mukdromを倒す | HPが減るとマイティストライクを何度も使い、ジャンプもする。 | @ボスディン氷河 J-6 | T mob.111.Slackjawed_Mukdrom = mob:Slackjawed Mukdrom@ボスディン氷河 J-6
g09 examine - | Point of Interestをもう一度調べてイベントを見る | | @ボスディン氷河 J-6 | T obj.111.Point_of_Interest
g10 examine - | ドラギーユ城(H-7)のDoor:Prince Royal's Rmを調べてイベントを見ると完了 | | @ドラギーユ城 H-7 | T obj.233.Door_Prince_Royals_Rm

@ mission.tvr.015 https://wiki.ffo.jp/html/38304.html
Q Best Served Cold | 復讐のド・ボ | no | T obj.172.Quadav_Inquest = obj:Quadav Inquest@ツェールン鉱山 I-9
MN TVR4-1 15
RW item:ナジの包帯
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_4-1;Gumbah（ホームポイント#1、上の段 J-7）の次にツェールン鉱山の入口近くの Drangord（D-7）。バストゥーク鉱山区からツェールン鉱山に入るとイベント。Drake Fang（H-6）の話は任意。I-9 の Quadav Inquest を2回調べて Do'Bho Venomtail（黒、約3万HP、魔力の泉、攻撃に毒）・Old Quadav・Brass Quadav・Copper Quadav（約2.5万HP）とコンフロント戦。もう一度調べて報酬（FFXIclopedia：Quadav Inquest は I-9。Do'Bho Venomtail は早めに静寂にするとよい）
g01 talk - | バストゥーク鉱山区(J-7)のGumbahに話してイベントを見る | | @バストゥーク鉱山区 J-7 | T npc.234.Gumbah
g02 talk - | バストゥーク鉱山区(D-7)のDrangordに話してイベントを見る | ツェールン鉱山の入口の近く。 | @バストゥーク鉱山区 D-7 | T npc.234.Drangord = npc:Drangord@バストゥーク鉱山区 D-7
g03 go - | バストゥーク鉱山区からツェールン鉱山に入り、イベントを見る | | @ツェールン鉱山
g04 talk - | （してもしなくてもよい）ツェールン鉱山(H-6)のDrake Fangに話す | 南へ行くよう言われる。 | @ツェールン鉱山 H-6 | T npc.172.Drake_Fang
g05 examine - | ツェールン鉱山(I-9)のQuadav Inquestを調べてイベントを見る | | @ツェールン鉱山 I-9 | T obj.172.Quadav_Inquest
g06 examine - | もう一度Quadav Inquestを調べてコンフロント戦に入る | 制限時間15分。4体と同時に戦う。フェイスは先に呼んでおく。 | @ツェールン鉱山 I-9 | T obj.172.Quadav_Inquest
g07 defeat - | Do'Bho Venomtailを倒す | 水の精霊魔法とダイヤモンドシェルを使い、HPが半分ほどで魔力の泉。早めに静寂にすると楽。石化は効かない。 | @ツェールン鉱山 I-9 | T mob.172.DoBho_Venomtail = mob:Do'Bho Venomtail@ツェールン鉱山 I-9
g08 defeat - | Old Quadavを倒す | | @ツェールン鉱山 I-9 | T mob.172.Old_Quadav = mob:Old Quadav@ツェールン鉱山 I-9
g09 defeat - | Copper Quadavを倒す | | @ツェールン鉱山 I-9 | T mob.172.Copper_Quadav = mob:Copper Quadav@ツェールン鉱山 I-9
g10 defeat - | Brass Quadavを倒す | | @ツェールン鉱山 I-9 | T mob.172.Brass_Quadav = mob:Brass Quadav@ツェールン鉱山 I-9
g11 examine - | もう一度Quadav Inquestを調べてイベントを見ると完了 | | @ツェールン鉱山 I-9 | T obj.172.Quadav_Inquest

@ mission.tvr.016 https://wiki.ffo.jp/html/38306.html
Q Cornelia's Call to Action | 決起のコーネリア | no | T obj.143.Perversions_Refuge = obj:Perversion's Refuge@パルブロ鉱山 H-9 #3
MN TVR4-2 16
RW item:海の幸グラタン×12
RW title:ロマンシング サ・ソリさん
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_4-2;大工房 J-8 の大統領執務室の Iron Eater。北グスタベルグからパルブロ鉱山に入るとイベント（パルブロ鉱山のホームポイントからエスケプすると入口）。Map 3 H-9（ホームポイント#1の北）の Perversion's Refuge を2回調べて Mind-warped Scorpion（約5万HP、攻撃でHP吸収）とコンフロント戦。もう一度調べて Iapetus、Iron Eater で Seafood Gratin（FFXIclopedia：Perversion's Refuge は Map 3 H-9、ホームポイントのすぐそば）
g01 talk - | 大工房(J-8)の大統領執務室のIron Eaterに話してイベントを見る | | @大工房 J-8 | T npc.237.Iron_Eater
g02 go - | 北グスタベルグから歩いてパルブロ鉱山に入り、イベントを見る | ホームポイントなどのワープで入ると起きない。パルブロ鉱山のホームポイントへ飛んでエスケプすると入口に出る。 | @パルブロ鉱山
g03 go - | パルブロ鉱山のMAP3(H-9)へ行く | ホームポイント#1のすぐ北。 | @パルブロ鉱山 H-9 #3
g04 examine - | パルブロ鉱山(H-9)のPerversion's Refugeを調べてイベントを見る | | @パルブロ鉱山 H-9 #3 | T obj.143.Perversions_Refuge
g05 examine - | もう一度Perversion's Refugeを調べてコンフロント戦に入る | 制限時間15分。フェイスは先に呼んでおく。 | @パルブロ鉱山 H-9 #3 | T obj.143.Perversions_Refuge
g06 defeat - | Mind-warped Scorpionを倒す | 通常攻撃でHPを吸う。石化は効かない。 | @パルブロ鉱山 H-9 #3 | T mob.143.Mind-warped_Scorpion = mob:Mind-warped Scorpion@パルブロ鉱山 H-9 #3
g07 examine - | もう一度Perversion's Refugeを調べてイベントを見て、エーペトスをもらう | | @パルブロ鉱山 H-9 #3 | T obj.143.Perversions_Refuge
g08 talk - | 大工房(J-8)のIron Eaterに話してイベントを見ると完了 | | @大工房 J-8 | T npc.237.Iron_Eater

@ mission.tvr.017 https://wiki.ffo.jp/html/38342.html
Q Naja the Ambitious | ナジャよ大志を抱け | no | T obj.51.Savage_Scars = obj:Savage Scars@ワジャーム樹林 H-13
MN TVR4-3 17
LK condition:アトルガンミッションをコンプリートしている
RW item:ザイアメクード
RW item:ザイアメペティ
RW item:ザイアメバズバンド
RW item:ザイアメシャルバル
RW item:ザイアメネール
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_4-3;アトルガンミッションを済ませている必要がある。アトルガン白門 I-10 の Naja Salaheem。ワジャーム樹林 H-13 の Engraved Tablet の後ろの光る Savage Scars を2回調べて Returned Soulflayer（青、約10万HP、アジュールロー・N.ウィズドム）とコンフロント戦。もう一度調べて金色の髪の毛、Naja で報酬（FFXIclopedia：Savage Scars は H-13）
g01 talk - | アトルガン白門(I-10)のNaja Salaheemに話してイベントを見る | | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem
g02 go - | ワジャーム樹林(H-13)へ行く | ユニティのワープか、エジワ蘿洞へのサバイバルガイドが近い。 | @ワジャーム樹林 H-13
g03 examine - | ワジャーム樹林(H-13)のEngraved Tabletのそばの光るSavage Scarsを調べてイベントを見る | | @ワジャーム樹林 H-13 | T obj.51.Savage_Scars
g04 examine - | もう一度Savage Scarsを調べてコンフロント戦に入る | 制限時間15分。フェイスは先に呼んでおく。 | @ワジャーム樹林 H-13 | T obj.51.Savage_Scars
g05 defeat - | Returned Soulflayerを倒す | 青魔道士。HPが減るとアジュールローとN.ウィズドムで青魔法を続けて使う。静寂が効く。 | @ワジャーム樹林 H-13 | T mob.51.Returned_Soulflayer = mob:Returned Soulflayer@ワジャーム樹林 H-13
g06 examine - | もう一度Savage Scarsを調べてイベントを見て、だいじなもの「金色の髪の毛」をもらう | | @ワジャーム樹林 H-13 | T obj.51.Savage_Scars
g07 talk - | アトルガン白門(I-10)のNaja Salaheemに話してイベントを見ると完了 | | @アトルガン白門 I-10 | T npc.アトルガン白門.Naja_Salaheem | K 金色の髪の毛

@ mission.tvr.018 https://wiki.ffo.jp/html/38343.html
Q Raubahn the Blue | 青のラウバーン | no | T obj.アトルガン白門.Imperial_Whitegate
MN TVR4-4 18
LK condition:アトルガンミッションの「遇人の内懐」〜「戴冠の儀」のあいだでないこと。ビシージでガダラルが捕まっていないこと
RW key_item:メネジンレシーバー
RW title:再生を見届けし者
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_4-4;アトルガン白門 L-9 の Imperial Whitegate。カダーバの浮沼 Map 4（ヘディバ島）へ（ユニティのワープ135、またはナイズル島踏査指令の入口からテレポーターで）。北東の隠れた道の先、I-6 の Engraved Tablet のそばの Savage Scars を2回調べて Arisen Soulflayer と Descended Winebibber 3体とコンフロント戦。Winebibber も全部倒す。Uran-Mafran が倒れると負け。もう一度調べてイベント、Imperial Whitegate でメネジンレシーバー（FFXIclopedia：Savage Scars は Map 4 I-6）
g01 examine - | アトルガン白門(L-9)のImperial Whitegateを調べてイベントを見る | | @アトルガン白門 L-9 | T obj.アトルガン白門.Imperial_Whitegate
g02 go - | カダーバの浮沼のMAP4（ヘディバ島）(I-6)へ行く | ユニティのワープが近いが、謎の証文などが要る。ナイズル島踏査指令からテレポーターを乗り継いでも行ける。北東の少し隠れた道の先。 | @カダーバの浮沼 I-6 #4
g03 examine - | カダーバの浮沼(I-6)のEngraved TabletのそばのSavage Scarsを調べてイベントを見る | | @カダーバの浮沼 I-6 #4 | T obj.79.Savage_Scars = obj:Savage Scars@カダーバの浮沼 I-6 #4
g04 examine - | もう一度Savage Scarsを調べてコンフロント戦に入る | 制限時間15分。味方のUran-Mafranが倒れると負けになるので守る。フェイスは先に呼んでおく。 | @カダーバの浮沼 I-6 #4 | T obj.79.Savage_Scars
g05 defeat - | Arisen Soulflayerを倒す | | @カダーバの浮沼 I-6 #4 | T mob.79.Arisen_Soulflayer = mob:Arisen Soulflayer@カダーバの浮沼 I-6 #4
g06 defeat - | Descended Winebibber 3体を倒す | 全部倒さないと勝てない。フルイドスルーが強いので、敵はPC側で引きつける。 | @カダーバの浮沼 I-6 #4 | T mob.79.Descended_Winebibber = mob:Descended Winebibber@カダーバの浮沼 I-6 #4
g07 examine - | もう一度Savage Scarsを調べてイベントを見る | | @カダーバの浮沼 I-6 #4 | T obj.79.Savage_Scars
g08 examine - | アトルガン白門(L-9)のImperial Whitegateを調べてイベントを見ると完了 | ジュノ上層(G-6)のElijahに話すとエミネンス・レコードのクエスト4が開く。 | @アトルガン白門 L-9 | T obj.アトルガン白門.Imperial_Whitegate

@ mission.tvr.019 https://wiki.ffo.jp/html/38376.html
Q Ghatsad's Quandary | 憂鬱なるガッサド | no | T obj.79.Vexing_Sniffles = obj:Vexing Sniffles@カダーバの浮沼 E-10 #1
MN TVR5-1 19
RW gil:20,000ギル
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_5-1;オートマトン工房 I-7 の Ghatsad でメゴマックへのお土産。ゼオルム火山の Gates of Halvung（J-7、Cast metal plate が要る）の先、I-9 の北西の Acid-eaten Door。ハザルム試験場の Entry Gate。カダーバの浮沼 E-10（墓場、ハザルム試験場の外）の Vexing Sniffles を2回調べて Gloom Phantom・Magh Bihu（モンク）・Dazbog（約6万HP）とコンフロント戦、Mnejing を守る。真っ白なアンプル。もう一度調べてイベント、Acid-eaten Door、Ghatsad で報酬（FFXIclopedia：Acid-eaten Door は I-9、Vexing Sniffles は E-10）
g01 talk - | アトルガン白門(I-7)のオートマトン工房のGhatsadに話してイベントを見て、だいじなもの「メゴマックへのお土産」をもらう | | @アトルガン白門 I-7 | T npc.アトルガン白門.Ghatsad
g02 go - | ゼオルム火山のGates of Halvungの中へ行く | ハルブーン駐屯地のそばのJ-7の門を、だいじなもの「Cast metal plate」で開ける。中の2階の南側。 | @ゼオルム火山 J-7
g03 examine - | ゼオルム火山(I-9)のAcid-eaten Doorを調べてイベントを見る | お土産はなくなる。 | @ゼオルム火山 I-9 | T obj.ゼオルム火山.Acid-eaten_Door
g04 examine - | ハザルム試験場のEntry Gateを調べてイベントを見る | カダーバの浮沼のホームポイント#1が近い。 | @ハザルム試験場 | T obj.ハザルム試験場.Entry_Gate = obj:Entry Gate@ハザルム試験場
g05 examine - | カダーバの浮沼(E-10)のVexing Snifflesを調べてイベントを見る | ハザルム試験場を出てすぐの墓場。 | @カダーバの浮沼 E-10 #1 | T obj.79.Vexing_Sniffles
g06 examine - | もう一度Vexing Snifflesを調べてコンフロント戦に入る | 制限時間15分。味方のMnejingが倒れると負けになるので守る。3体と同時に戦う。 | @カダーバの浮沼 E-10 #1 | T obj.79.Vexing_Sniffles
g07 defeat - | Gloom Phantomを倒す | | @カダーバの浮沼 E-10 #1 | T mob.79.Gloom_Phantom = mob:Gloom Phantom@カダーバの浮沼 E-10 #1
g08 defeat - | Dazbogを倒す | | @カダーバの浮沼 E-10 #1 | T mob.79.Dazbog = mob:Dazbog@カダーバの浮沼 E-10 #1
g09 defeat - | Magh Bihuを倒し、だいじなもの「真っ白なアンプル」をもらう | 今回はモンクで百烈拳を使う。3体を全部倒すともらえる。 | @カダーバの浮沼 E-10 #1 | T mob.79.Magh_Bihu = mob:Magh Bihu@カダーバの浮沼 E-10 #1
g10 examine - | もう一度Vexing Snifflesを調べてイベントを見る | | @カダーバの浮沼 E-10 #1 | T obj.79.Vexing_Sniffles
g11 examine - | ゼオルム火山(I-9)のAcid-eaten Doorを調べてイベントを見る | アンプルはなくなる。 | @ゼオルム火山 I-9 | T obj.ゼオルム火山.Acid-eaten_Door | K 真っ白なアンプル
g12 talk - | アトルガン白門(I-7)のGhatsadに話してイベントを見ると完了 | | @アトルガン白門 I-7 | T npc.アトルガン白門.Ghatsad

@ mission.tvr.020 https://wiki.ffo.jp/html/38377.html
Q The Revelation | アブダルラブダショック | no | T obj.68.Final_Survey_Point = obj:Final Survey Point@エジワ蘿洞 G-10 #3
MN TVR5-2 20
RW gil:20,000ギル
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_5-2;オートマトン工房 I-7 の Abda-Lurabda。ワジャーム樹林 I-6 の入口からエジワ蘿洞に入るとイベント。Survey Point は Map 2 K-7、Map 2 の I-9/J-9 の境目、Map 5 F-8。Map 3 G-10 の Final Survey Point を調べ、もう一度調べて Missabikong（約15万HP、ショックスパイク、雷を吸う、打撃に弱い）とコンフロント戦。もう一度調べてイベント、Abda-Lurabda で報酬（FFXIclopedia：Survey Point は Map 2 K-7、Map 2 J-9（I-9 との境目）、Map 5 F-8。Final Survey Point は Map 3 G-10）
g01 talk - | アトルガン白門(I-7)のオートマトン工房のAbda-Lurabdaに話してイベントを見る | 「いいえ」を選ぶとやめられる。 | @アトルガン白門 I-7 | T npc.アトルガン白門.Abda-Lurabda = npc:Abda-Lurabda@アトルガン白門 I-7
g02 go - | ワジャーム樹林(I-6)の入口から歩いてエジワ蘿洞に入り、イベントを見る | チョコボでもよい。エジワ蘿洞へのサバイバルガイドで飛んでエスケプするとこの入口に出る。 | @ワジャーム樹林 I-6
g03 examine - | エジワ蘿洞のMAP2(K-7)のSurvey Pointを調べてイベントを見る | 3か所は順不同。 | @エジワ蘿洞 K-7 #2 | T obj.68.Survey_Point_K-7 = obj:Survey Point@エジワ蘿洞 K-7 #2
g04 examine - | エジワ蘿洞のMAP2(J-9)のSurvey Pointを調べてイベントを見る | I-9との境目。 | @エジワ蘿洞 J-9 #2 | T obj.68.Survey_Point_J-9 = obj:Survey Point@エジワ蘿洞 J-9 #2
g05 examine - | エジワ蘿洞のMAP5(F-8)のSurvey Pointを調べてイベントを見る | MAP2のE-9から西の坂を下りた部屋。絡んでくる敵が多い。 | @エジワ蘿洞 F-8 #5 | T obj.68.Survey_Point_F-8 = obj:Survey Point@エジワ蘿洞 F-8 #5
g06 go - | エジワ蘿洞のMAP3(G-10)へ行く | 階段に近づくと短いイベントがある。 | @エジワ蘿洞 G-10 #3
g07 examine - | エジワ蘿洞(G-10)のFinal Survey Pointを調べてイベントを見る | 近づいたときのイベントが出なかったときも、ここを調べれば進む。 | @エジワ蘿洞 G-10 #3 | T obj.68.Final_Survey_Point
g08 examine - | もう一度Final Survey Pointを調べてコンフロント戦に入る | 制限時間15分。フェイスは先に呼んでおく。 | @エジワ蘿洞 G-10 #3 | T obj.68.Final_Survey_Point
g09 defeat - | Missabikongを倒す | 雷を吸い、消せないショックスパイクがある。打撃が効く。範囲の技が多い。 | @エジワ蘿洞 G-10 #3 | T mob.68.Missabikong = mob:Missabikong@エジワ蘿洞 G-10 #3
g10 examine - | もう一度Final Survey Pointを調べてイベントを見る | | @エジワ蘿洞 G-10 #3 | T obj.68.Final_Survey_Point
g11 talk - | アトルガン白門(I-7)のAbda-Lurabdaに話してイベントを見ると完了 | | @アトルガン白門 I-7 | T npc.アトルガン白門.Abda-Lurabda

@ mission.tvr.021 https://wiki.ffo.jp/html/38387.html
Q Tateeya's Worries | タティーヤの失楽 | no | T npc.アトルガン白門.Tateeya = npc:Tateeya@アトルガン白門 I-7
MN TVR5-3 21
RW item:雷槌
RW title:オルドゥームの秘宝
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_5-3;オートマトン工房 I-7 の Tateeya、つぎに Ghatsad でイベント（No Strings Attached の途中だと進まないことがある、要確認）。バフラウ段丘 Map 2 の Home Point #1 から翡翠廟へ（マムージャ監視哨から北でもよい）。Ornamental Door を調べてイベント、もう一度調べて BF「Tateeya's Worries」：Drakeweaver Hageel Ja（ナ、約6万）・Riftweaver Pomaal Ja（青、約6万）・Fistweaver Mufaal Ja（モ、約6万）・Glyphweaver Sikool Ja（黒、約10万、スタン・サンダーV/VI・アイオノヒックスII・サンダジャ）。フェイス可。Glyphweaver の武器を壊さないと1%で止まる。相手の通常攻撃中かその直後にWS。全員静寂・睡眠が効く。Imperial Whitegate で雷槌（あとのミッションで要る）（FFXIclopedia：Glyphweaver の武器の壊し方は同じ。1%になるとダメージ0なのでリゲイン等を持つ。Imperial Whitegate は L-8/L-9）
g01 talk - | アトルガン白門(I-7)のオートマトン工房のTateeyaに話してイベントを見る | | @アトルガン白門 I-7 | T npc.アトルガン白門.Tateeya
g02 talk - | アトルガン白門(I-7)のGhatsadに話してイベントを見る | 同じオートマトン工房の中。 | @アトルガン白門 I-7 | T npc.アトルガン白門.Ghatsad
g03 go - | バフラウ段丘(I-9)から翡翠廟に入る | バフラウ段丘のホームポイント#1が近い。マムージャ監視哨から北へ行ってもよい。 | @バフラウ段丘 I-9 #2
g04 examine - | 翡翠廟のOrnamental Doorを調べてイベントを見る | | @翡翠廟
g05 fight - | もう一度Ornamental Doorを調べてBF「タティーヤの失楽」に入り、マムージャ4体と戦う | 6人・15分・レベル制限なし。入ると強化が消える。フェイスを呼べる。Drakeweaver Hageel Ja、Riftweaver Pomaal Ja、Fistweaver Mufaal Jaの順に倒し、最後にGlyphweaver Sikool Jaにすると楽。Glyphweaver Sikool Jaは最初にサンダーVかVIを必ず撃つので、魔法を防ぐ装備で入る。4体とも静寂と睡眠が効く。 | @翡翠廟
g06 fight - | Glyphweaver Sikool Jaの杖を壊して勝つ | 杖があるあいだはHPが1%から減らない。相手が通常攻撃をしているときか、その直後にWSを当てると壊れる。1%になるとダメージが0になるので、TPをためる手段を持って行く。 | @翡翠廟
g07 examine - | アトルガン白門(L-9)のImperial Whitegateを調べてイベントを見ると完了 | 雷槌は2つあとの「海の賢者ビージュ」で装備するので捨てない。もらえなかったときは持ち物を空けてもう一度調べる。 | @アトルガン白門 L-9 | T obj.アトルガン白門.Imperial_Whitegate

@ mission.tvr.022 https://wiki.ffo.jp/html/38388.html
Q The Seagull Phratrie | 海猫党の水難 | no | T obj.54.???_H-10
MN TVR5-4 22
RW gil:20,000ギル
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_5-4;先に Hamsi を用意（アトルガン白門 H-11 の Wahnid はギルドに売られたときだけ、競売、白門で釣れる）。Lamian Fang Key はカダーバの浮沼 Map 1 I-7 の ??? で1日1回、このあと少なくとも2つ要る。アラパゴ暗礁域 Map 1 H-10 の船の ???（コルセアのクエストと同じ、光る名前のない印のすぐ左）でイベント。Survival Guide が近い。Map 3 F-7 の Apkallu Guide に Hamsi をトレード（カダーバの浮沼の Survival Guide から東の洞窟。ないときはカギがもう1つ）。西の Camp Remnants（F-7）で Merrow Kabukidancer 2（侍、Torrent で装備を外す）・Qutrub 2（暗）・Mamool Ja Diver 2（モ）とコンフロント戦。範囲の技は1体にしか当たらない。Qutrub 以外は眠る。もう一度調べてイベント、H-10 の ??? で報酬（FFXIclopedia：??? は Map 1 H-10、Apkallu Guide は Map 3 F-7、Camp Remnants はその少し西）
g01 examine - | （してもしなくてもよい）カダーバの浮沼(I-7)の???を調べて「ラミアの牙のカギ」を取る | 先に取っておく。ヴァナ時間の1日に1つ取れる。このミッションではあと2つ使うことがある。 | @カダーバの浮沼 I-7 #1 | T obj.カダーバの浮沼.???_I-7
g02 go - | アラパゴ暗礁域のMAP1(H-10)の船へ行く | アラパゴ暗礁域のSurvival Guideが近い。歩いて行くときはラミアの牙のカギで門を抜ける。 | @アラパゴ暗礁域 H-10 #1
g03 examine - | アラパゴ暗礁域(H-10)の???を調べてイベントを見る | 船の舳先の真ん中、光る名前のない印のすぐ左。コルセアになるクエストと同じ場所。Pteraketosの話が出るイベントなら合っている。 | @アラパゴ暗礁域 H-10 #1 | T obj.54.???_H-10
g04 go - | カダーバの浮沼のSurvival Guideから東の洞窟に入り、アラパゴ暗礁域(F-7)へ行く | Survival Guideがないときはラミアの牙のカギがもう1つ要る。マップの番号はMAP3とMAP11の2通りの書き方がある。 | @アラパゴ暗礁域 F-7
g05 talk - | アラパゴ暗礁域(F-7)のApkallu Guideに話す | おなかがすいているようだと出る。 | @アラパゴ暗礁域 F-7 | T npc.54.Apkallu_Guide = npc:Apkallu Guide@アラパゴ暗礁域 F-7
g06 trade - | Apkallu Guideに「ハムシー」をトレードしてイベントを見る | このあたりでは手に入らないので先に用意する。競売で買えるほか、アトルガン白門の釣りでも釣れる。 | @アラパゴ暗礁域 F-7 | T npc.54.Apkallu_Guide | N ハムシー*1
g07 examine - | アラパゴ暗礁域(F-7)の光るCamp Remnantsを調べてコンフロント戦に入る | Apkallu Guideの少し西。制限時間15分。6体と同時に戦い、攻撃が強いので強化と被ダメージを減らす装備で入る。フェイスは先に呼んでおく。範囲の技は1体にしか当たらない。 | @アラパゴ暗礁域 F-7 | T obj.54.Camp_Remnants = obj:Camp Remnants@アラパゴ暗礁域 F-7
g08 defeat - | Merrow Kabukidancer 2体を倒す | Torrentで装備を外されるので、すぐ着替えられるようにしておく。 | @アラパゴ暗礁域 F-7 | T mob.54.Merrow_Kabukidancer = mob:Merrow Kabukidancer@アラパゴ暗礁域 F-7
g09 defeat - | Mamool Ja Diver 2体を倒す | | @アラパゴ暗礁域 F-7 | T mob.54.Mamool_Ja_Diver = mob:Mamool Ja Diver@アラパゴ暗礁域 F-7
g10 defeat - | Qutrub 2体を倒す | Qutrubは眠らない。 | @アラパゴ暗礁域 F-7 | T mob.54.Qutrub = mob:Qutrub@アラパゴ暗礁域 F-7
g11 examine - | もう一度Camp Remnantsを調べてイベントを見る | | @アラパゴ暗礁域 F-7 | T obj.54.Camp_Remnants
g12 examine - | （してもしなくてもよい）カダーバの浮沼(I-7)の???を調べて「ラミアの牙のカギ」を取る | ヴァナ時間が次の日になっていれば、もう1つ取れる。船へ戻るときに使う。 | @カダーバの浮沼 I-7 #1 | T obj.カダーバの浮沼.???_I-7
g13 go - | アラパゴ暗礁域のMAP1(H-10)の船へ戻る | ラミアの牙のカギがもう1つ要る。歩いて戻ることもできる。 | @アラパゴ暗礁域 H-10 #1
g14 examine - | アラパゴ暗礁域(H-10)の???を調べてイベントを見ると完了 | | @アラパゴ暗礁域 H-10 #1 | T obj.54.???_H-10

@ mission.tvr.023 https://wiki.ffo.jp/html/38389.html
Q The Sea Sage | 海の賢者ビージュ | no | T npc.54.Apkallu_Guide
MN TVR5-5 23
RW item:アプカルセプター
RW title:アプクーップアプカリッチョ
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_5-5;雷槌が要る。アラパゴ暗礁域 Map 3 F-7 の Apkallu Guide（カダーバの浮沼の Survival Guide から東）。ワジャーム樹林 G-8 の Leypoint（オルドゥームリングで直行、Survival Guide かユニティ125でも）。ワジャーム樹林 E-10 の入口8からエジワ蘿洞 Map 3 へ、左の壁沿いに落ちずに J-8 の出口7。最初の段差を下りた先の G-9 のマロリスに雷槌を装備して近づくと Aeropearl（ターゲットできない、Hydra は近づかなければ絡まない）。Apkallu Guide、白門 I-7 の Ghatsad。アルザダール海底遺跡群で Qiqirn を倒すと Panaiveriyamman（戦、約15万、マイティストライク、魔法とくに闇に強く水に弱い）。Man-made solution はパーティ全員。Ghatsad で Repaired aeropearl。Lamian Fang Key を持って H-10 の ???、Apkallu Guide で報酬。ジュノ上層の Elijah（FFXIclopedia：Leypoint G-8、マロリス G-9、エジワ蘿洞は E-10 から入り左の壁沿いに I-8 からワジャームへ（別の行では Map 3 J-8）、G-9 の段差を下りる。雷槌をなくしたら Abda-Lurabda にまたもらえる。Elijah は G-6）
g01 go - | カダーバの浮沼のSurvival Guideから東の洞窟に入り、アラパゴ暗礁域(F-7)へ行く | 雷槌を持っていること。 | @アラパゴ暗礁域 F-7
g02 talk - | アラパゴ暗礁域(F-7)のApkallu Guideに話してイベントを見る | | @アラパゴ暗礁域 F-7 | T npc.54.Apkallu_Guide
g03 go - | ワジャーム樹林(G-8)へ行く | オルドゥームリングで直接行ける。ワジャーム樹林のSurvival Guideも近い。 | @ワジャーム樹林 G-8
g04 examine - | ワジャーム樹林(G-8)のLeypointを調べてイベントを見る | | @ワジャーム樹林 G-8 | T obj.ワジャーム樹林.Leypoint
g05 go - | ワジャーム樹林(E-10)の入口からエジワ蘿洞に入る | | @ワジャーム樹林 E-10
g06 go - | エジワ蘿洞のMAP3を左の壁に沿って進み、J-8かI-8の出口からワジャーム樹林へ出る | 途中で下に落ちないようにする。ラプトルやクモが見えたら道をまちがえている。 | @エジワ蘿洞 J-8 I-8 #3
g07 go - | 北へ進み、ワジャーム樹林(G-9)の段差を下りる | Hydraが出る場所で、ここからしか行けない。 | @ワジャーム樹林 G-9
g08 go - | 雷槌をメインの武器に装備し、ワジャーム樹林(G-9)のマロリスに近づいてイベントを見て、だいじなもの「空の空気玉」をもらう | 地面の岩の山で、ターゲットできない。Hydraがいても近づかなければ絡まれない。雷槌をなくしたときはAbda-Lurabdaにまたもらえる。 | @ワジャーム樹林 G-9
g09 go - | カダーバの浮沼のSurvival Guideからアラパゴ暗礁域(F-7)へ戻る | | @アラパゴ暗礁域 F-7
g10 talk - | Apkallu Guideに話してイベントを見る | | @アラパゴ暗礁域 F-7 | T npc.54.Apkallu_Guide
g11 talk - | アトルガン白門(I-7)のオートマトン工房のGhatsadに話してイベントを見る | | @アトルガン白門 I-7 | T npc.アトルガン白門.Ghatsad
g12 go - | アルザダール海底遺跡群へ行く | | @アルザダール海底遺跡群
g13 defeat - | アルザダール海底遺跡群のキキルンを倒してPanaiveriyammanを出す | 自分でたたいて倒す。たまに出るので何体も倒すことがある。倒すとすぐ出るので、フェイスは先に呼んでおく。 | @アルザダール海底遺跡群
g14 defeat - | Panaiveriyammanを倒し、だいじなもの「人工飽和液」をもらう | マイティストライクを使う。魔法が効きにくいので物理で戦う。水には弱い。パーティの全員がもらえる。 | @アルザダール海底遺跡群 | T mob.72.Panaiveriyamman = mob:Panaiveriyamman@アルザダール海底遺跡群
g15 talk - | アトルガン白門(I-7)のGhatsadに話してイベントを見て、だいじなもの「改造空気玉」をもらう | 空の空気玉と人工飽和液はなくなる。 | @アトルガン白門 I-7 | T npc.アトルガン白門.Ghatsad | K 人工飽和液
g16 examine - | （してもしなくてもよい）カダーバの浮沼(I-7)の???を調べて「ラミアの牙のカギ」を取る | 船へ行くときに使う。ヴァナ時間の1日に1つ取れる。 | @カダーバの浮沼 I-7 #1 | T obj.カダーバの浮沼.???_I-7
g17 go - | アラパゴ暗礁域のMAP1(H-10)の船へ行く | ラミアの牙のカギを持って行く。アラパゴ暗礁域のSurvival Guideが近い。 | @アラパゴ暗礁域 H-10 #1
g18 examine - | アラパゴ暗礁域(H-10)の???を調べてイベントを見る | | @アラパゴ暗礁域 H-10 #1 | T obj.54.???_H-10
g19 go - | カダーバの浮沼のSurvival Guideからアラパゴ暗礁域(F-7)へ戻る | | @アラパゴ暗礁域 F-7
g20 talk - | Apkallu Guideに話してイベントを見ると完了 | 改造空気玉はなくなる。ジュノ上層(G-6)のElijahに話すとエミネンス・レコードのクエストが開く。 | @アラパゴ暗礁域 F-7 | T npc.54.Apkallu_Guide | K 改造空気玉

@ mission.tvr.024 https://wiki.ffo.jp/html/38419.html
Q Sky, Moon, Incantrix | 空と月とインカントリックス | no | T npc.醴泉島.Reikuu = npc:Reikuu@醴泉島 K-8
MN TVR6-1 24
RW gil:20,000ギル
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_6-1;醴泉島 K-8 の Reikuu（Ethereal Ingress #6 のそば）。Ingress #10 の Incantrix で「No, of course not」を選ぶ。H-6（Ingress #3 と #5 のあいだ）の Suspicious Overgrowth を調べ、Hoptoad 3つと Eastern Ginger 1つをトレード。Hoptoad は Ingress #2 のそばの橋から Fly Lure か Lufaise Fly で釣る。Eastern Ginger は醴泉島（Grimslight は Reaper が要る）・バフラウ段丘で採れる、醴泉島の宝箱。Reikuu で報酬（FFXIclopedia：Reikuu K-8、Suspicious Overgrowth H-6、Hoptoad は G-8 の川、Eastern Ginger はワジャーム樹林・バフラウ段丘）
g01 talk - | 醴泉島(K-8)のReikuuに話してイベントを見る | Ethereal Ingress #6が近い。 | @醴泉島 K-8 | T npc.醴泉島.Reikuu
g02 go - | 醴泉島のEthereal Ingress #10へ行く | | @醴泉島
g03 talk - | Incantrixに話してイベントを見る | 「No, of course not」にあたる選択肢を選ばないと進まない。 | @醴泉島 | T npc.醴泉島.Incantrix = npc:Incantrix@醴泉島
g04 go - | 醴泉島(H-6)へ行く | Ethereal Ingress #3・#4・#5のあいだ。 | @醴泉島 H-6
g05 examine - | 醴泉島(H-6)のSuspicious Overgrowthを調べてイベントを見る | ヒキガエル3つと茗荷1つを頼まれる。 | @醴泉島 H-6 | T obj.醴泉島.Suspicious_Overgrowth = obj:Suspicious Overgrowth@醴泉島 H-6
g06 trade - | Suspicious Overgrowthに「ヒキガエル」3つと「茗荷」1つをトレードしてイベントを見る | ヒキガエルは醴泉島のEthereal Ingress #2のそばの川で、Fly Lureなどを使って釣れる。茗荷はバフラウ段丘やワジャーム樹林で採れ、醴泉島でも採れる。 | @醴泉島 H-6 | T obj.醴泉島.Suspicious_Overgrowth | N ヒキガエル*3 | N 茗荷*1
g07 talk - | 醴泉島(K-8)のReikuuに話してイベントを見ると完了 | | @醴泉島 K-8 | T npc.醴泉島.Reikuu

@ mission.tvr.025 https://wiki.ffo.jp/html/38420.html
Q Nii's Last Stand | ニーの死地 | no | T npc.醴泉島.Reikuu
MN TVR6-2 25
RW item:独鈷杵
RW title:ディスティニーシショー
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_6-2;Reikuu（前の節からエリアを移らなくてよい）。Ingress #10 の Incantrix。F-5（Ingress #4）の川の Babbling Brook。Incantrix。K-7（Ingress #6）の Aspirants' Grounds でイベントと Aspirant's canteen。もう一度調べて BF「Nii's Last Stand」（ひとり・10分、フェイス不可、パーティを抜ける）。敵の攻撃は1ダメージ。自分と Nii Aquu で半分ずつ倒す。Nii Aquu のせりふで差がわかる。勝つと報酬（FFXIclopedia：Incantrix のあと Reikuu にもう一度話す手順がある。Babbling Brook F-5、Aspirant's Grounds K-7。強化は消えない。差が1〜2までなら勝てる。負けてもすぐやり直せる）
g01 talk - | 醴泉島(K-8)のReikuuに話してイベントを見る | 前の節から続けて話せる。 | @醴泉島 K-8 | T npc.醴泉島.Reikuu
g02 go - | 醴泉島のEthereal Ingress #10へ行く | | @醴泉島
g03 talk - | Incantrixに話してイベントを見る | Babbling Brookで進まないときは、Reikuuにもう一度話してみる。 | @醴泉島 | T npc.醴泉島.Incantrix
g04 go - | 醴泉島(F-5)へ行く | 北西の滝の手前。Ethereal Ingress #4が近い。 | @醴泉島 F-5
g05 examine - | 醴泉島(F-5)の川の中のBabbling Brookを調べてイベントを見る | | @醴泉島 F-5 | T obj.醴泉島.Babbling_Brook = obj:Babbling Brook@醴泉島 F-5
g06 go - | 醴泉島のEthereal Ingress #10へ行く | | @醴泉島
g07 talk - | もう一度Incantrixに話してイベントを見る | | @醴泉島 | T npc.醴泉島.Incantrix
g08 go - | 醴泉島(K-7)へ行く | Ethereal Ingress #6から北へ。 | @醴泉島 K-7
g09 examine - | 醴泉島(K-7)のAspirants' Groundsを調べてイベントを見て、だいじなもの「修行の飯盒」をもらう | | @醴泉島 K-7 | T obj.醴泉島.Aspirants_Grounds = obj:Aspirants' Grounds@醴泉島 K-7
g10 fight - | もう一度Aspirants' Groundsを調べてBF「ニーの死地」に入り、Nii Aquuと一緒にKatashiroを倒して勝つと完了 | ひとり・10分。パーティを抜けてから入る。フェイスは呼べない。強化は消えない。Katashiroの攻撃は1ダメージほど。自分とNii Aquuの倒した数の差を1〜2までにする。Nii Aquuのせりふで差がわかる。負けてもすぐやり直せる。修行の飯盒はなくなる。 | @醴泉島 K-7 | T obj.醴泉島.Aspirants_Grounds | K 修行の飯盒

@ mission.tvr.026 https://wiki.ffo.jp/html/38469.html
Q Dance of the Tengu | 天狗の舞 | no | T npc.醴泉島.Reikuu
MN TVR6-3 26
RW item:天狗の葉団扇
RW item:天狗の隠れ蓑
RW title:葉団扇に乗せて歩み続ける者
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_6-3;醴泉島 K-8 の Reikuu（Ingress #6 のそば）。F-5（Ingress #4）の Babbling Brook でイベント。もう一度調べて BF（Zhuu Buxu、約12.5万、15分、フェイス可、微塵がくれ、Nii Aquu を守る）。勝つと自動でイベント。もう一度調べて BF（Reikuu、約9万、15分、Gessho を守る、分身を出す、本体に当てると分身が消える、微塵がくれは -dt でも2千以上）。Reikuu で報酬。ジュノ上層 Home Point #1 のそばの Elijah（FFXIclopedia：Reikuu K-8、Babbling Brook F-5。6人・15分。Nii Aquu は白魔道士。Gessho が倒れると負け。分身は範囲のダメージを99%減らす。Elijah は F-6）
g01 talk - | 醴泉島(K-8)のReikuuに話してイベントを見る | Ethereal Ingress #6が近い。 | @醴泉島 K-8 | T npc.醴泉島.Reikuu
g02 go - | 醴泉島(F-5)へ行く | 北西の滝の手前。Ethereal Ingress #4が近い。 | @醴泉島 F-5
g03 examine - | 醴泉島(F-5)のBabbling Brookを調べてイベントを見る | | @醴泉島 F-5 | T obj.醴泉島.Babbling_Brook
g04 fight - | もう一度Babbling Brookを調べてBF「天狗の舞（ズー・ブシュ戦）」に入り、Zhuu Buxu the Silentに勝つ | 6人・15分・レベル制限なし。フェイスを呼べる。強化は消えない。忍者で、最後のほうで微塵がくれを使う。味方のNii Aquuは倒れないように守る。 | @醴泉島 F-5 | T obj.醴泉島.Babbling_Brook
g05 fight - | もう一度Babbling Brookを調べてBF「天狗の舞（レイクウ戦）」に入り、Reikuuに勝つ | 前と同じ条件。味方のGesshoが倒れると負け。Reikuuは分身をたくさん出し、分身は範囲の攻撃をほとんど受けないので本体を探してたたく。本体に当てると分身が消える。最後の微塵がくれは被ダメージを減らしていても大きい。 | @醴泉島 F-5 | T obj.醴泉島.Babbling_Brook
g06 talk - | 醴泉島(K-8)のReikuuに話してイベントを見ると完了 | ジュノ上層(G-6かF-6)のElijahに話すとエミネンス・レコードのクエストが開く。 | @醴泉島 K-8 | T npc.醴泉島.Reikuu

@ mission.tvr.027 https://wiki.ffo.jp/html/38492.html
Q Raebrimm's Rebirth | ラエブリームの転生 | no | T npc.234.Gumbah
MN TVR7-1 27
RW gil:20,000ギル
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_7-1;バストゥーク鉱山区 J-7 の Gumbah（上の通路の家の奥の部屋）。ラバオ G-6/G-7 の Dancing Wolf。任意で G-9 の Agado-Pugado と Rahi Fohlatti。西アルテパ砂漠 G-5 から流砂洞、重量扉を越えて G-11 の像の ???。次のミッションのため C-8 から西アルテパ砂漠へ出て sapphire column を押すとよい。D-12 から流砂洞、Map 5 の K-8 から出口 D を通って Map 6 の H-8 の ??? でコンフロント（Spelunking Sabotender・Sand Lizard・Sand Tarantula 各2、睡眠・石化が効きにくい）。もう一度 ??? で報酬（FFXIclopedia：G-11 は Map 5、G-5 は入口 #6。H-8 は Map 7、D-12 は入口 #4、Map 4 の L-8 の出口 D。Proto-Waypoint で Map 4 へ。6体は前置きなしにすぐ出る）
g01 talk - | バストゥーク鉱山区(J-7)のGumbahに話してイベントを見る | 上の通路の家の奥の部屋にいる。 | @バストゥーク鉱山区 J-7 | T npc.234.Gumbah
g02 talk - | ラバオ(G-7)のDancing Wolfに話してイベントを見る | G-6と書く資料もある。 | @ラバオ G-7 | T npc.247.Dancing_Wolf
g03 talk - | （してもしなくてもよい）ラバオ(G-9)のAgado-PugadoとRahi Fohlattiに話す | 話が少し増えるだけ。 | @ラバオ G-9 | T npc.247.Agado-Pugado
g04 go - | 西アルテパ砂漠(G-5)の入口から流砂洞に入る | クフタルの洞門のSurvival Guideで飛んで西アルテパ砂漠へ出るのが早い。ユニティのワープ（125）でクフタルの洞門へ行き、エスケプで入口に出てもよい。 | @西アルテパ砂漠 G-5
g05 go - | 流砂洞の重量扉を越えて、MAP[5](G-11)の像のある小部屋へ行く | 重量扉はガルカ1人、タルタル3人、ほかは2人で開く。ひとりなら「重量石」が要る。 | @流砂洞 G-11 #5
g06 examine - | 流砂洞MAP[5](G-11)の像の???を調べてイベントを見る | | @流砂洞 G-11 #5 | T obj.208.???_G-11
g07 go - | （してもしなくてもよい）流砂洞(C-8)から西アルテパ砂漠へ出て、アルテパゲートを開けるしかけの柱（sapphire column）を押しておく | 次のミッションでアルテパゲートを通る。 | @流砂洞 C-8
g08 go - | 西アルテパ砂漠(D-12)の入口から流砂洞に入り、出口Dを通って(H-8)へ行く | Proto-Waypointで流砂洞へ飛ぶと近い。重量扉を越える。壁画の廊下の奥は崖なので落ちないように。まわりのアンティカ族はレベルが高くても絡んでくる。マップ番号はMAP[7]と書くものとMAP[6]と書くものがある。 | @西アルテパ砂漠 D-12
g09 examine - | 流砂洞(H-8)の???を調べる。すぐにコンフロント戦になる | 調べる前に準備をすませておく。15分制限。フェイスを呼べる。 | @流砂洞 H-8 | T obj.208.???_H-8_7
g10 defeat - | Sand Lizardを2匹倒す | 睡眠と石化が効きにくい。 | @流砂洞 H-8 | T mob.208.Sand_Lizard = mob:Sand Lizard@流砂洞 H-8
g11 defeat - | Spelunking Sabotenderを2匹倒す | 1,000 Needlesを使う。 | @流砂洞 H-8 | T mob.208.Spelunking_Sabotender
g12 defeat - | Sand Tarantulaを2匹倒す | | @流砂洞 H-8 | T mob.208.Sand_Tarantula = mob:Sand Tarantula@流砂洞 H-8
g13 examine - | もう一度???を調べてイベントを見ると完了 | | @流砂洞 H-8 | T obj.208.???_H-8_7

@ mission.tvr.028 https://wiki.ffo.jp/html/38493.html
Q Uran-Mafran of the Maelstrom | 渦の末裔ウランマフラン | no | T npc.247.Dancing_Wolf
MN TVR7-2 28
RW item:共和プラチナ章
RW title:ガルカンハザード
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_7-2;ラバオ G-6 の Dancing Wolf。西アルテパ砂漠 I-6/7 のアルテパゲートから流砂洞に入るとイベント。K-10 の Journey's End を調べるとすぐ Uran-Mafran 戦（約18.5万、フェイス可、魔力の泉を何度も使い弱体が消える、精霊・メテオ・一人連携から MB）。Oggbi を守る。倒した扱いは自分が倒れても残る。もう一度 Journey's End。バストゥーク鉱山区 J-7 の Gumbah で報酬（FFXIclopedia：Journey's End は Map 6 の K-10。I-7 の柱が沈んでいればしかけは押してある）
g01 talk - | ラバオ(G-7)のDancing Wolfに話してイベントを見る | G-6と書く資料もある。 | @ラバオ G-7 | T npc.247.Dancing_Wolf
g02 go - | 西アルテパ砂漠(I-6 I-7)のアルテパゲートを開けて流砂洞に入り、イベントを見る | アルテパゲートは柱のしかけを順に押して開ける。I-7の柱が沈んでいれば、もう押してある。パーティでジョブを替えるときは、だれかが中に残って内側から開けるとよい。 | @西アルテパ砂漠 I-6 I-7
g03 go - | 流砂洞MAP[6](K-10)へ行く | | @流砂洞 K-10 #6
g04 examine - | 流砂洞MAP[6](K-10)のJourney's Endを調べる。すぐにコンフロント戦になる | 15分制限。フェイスを呼べる。味方のOggbiが倒れると負け。Oggbiはあまり打たれ強くない。リレイズをかけておく。手伝いはこのミッションを受けている人だけ。 | @流砂洞 K-10 #6 | T obj.208.Journeys_End = obj:Journey's End@流砂洞 K-10 #6
g05 defeat - | Uran-Mafranを倒す | 魔力の泉を何度も使い、そのたびに弱体が消える。精霊魔法やメテオ、一人連携からのマジックバーストが痛い。被ダメージを減らす装備で。WSを止めることも考える。自分が倒れても、倒した扱いは残る。 | @流砂洞 K-10 #6 | T mob.208.Uran-Mafran = mob:Uran-Mafran@流砂洞 K-10 #6
g06 examine - | もう一度Journey's Endを調べてイベントを見る | | @流砂洞 K-10 #6 | T obj.208.Journeys_End
g07 talk - | バストゥーク鉱山区(J-7)のGumbahに話してイベントを見ると完了 | | @バストゥーク鉱山区 J-7 | T npc.234.Gumbah

@ mission.tvr.029 https://wiki.ffo.jp/html/38513.html
Q Koru-Moru's Hypothesis | コルモル博士の異常な理論 | no | T npc.239.Shantotto
MN TVR7-3 29
RW item:シビルスカーフ
RW key_item:魔法人形「思ひ出くん」
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_7-3;ウィンダス石の区 K-7 の Shantotto。Spectral Crimson はミザレオ海岸・ルフェーゼ野のフォモル族（吟遊詩人・ナイト・赤魔道士）、Spect. Goldenrod はクフタルの洞門の Haunt かウルガラン山脈の Srei Ap、Luminicloth はゴースト族。3つを Shantotto にトレードして報酬と思ひ出くん。思ひ出くんで各地の記憶を集めると Depleted Memorian（7-4 のあと）（FFXIclopedia：Luminicloth はほとんどのゴースト族、Spectral Crimson は夜に出るフォモル族だけ）
g01 talk - | ウィンダス石の区(K-7)のShantottoに話してイベントを見る | | @ウィンダス石の区 K-7 | T npc.239.Shantotto
g02 gather - | 「赤霊布」を手に入れる | ミザレオ海岸かルフェーゼ野に夜に出るフォモル族（吟遊詩人・ナイト・赤魔道士）が落とす。競売に出せず、ほかのキャラクターから送れない。 | @ミザレオ海岸 | N 赤霊布*1
g03 gather - | 「黄霊布」を手に入れる | クフタルの洞門のHauntか、ウルガラン山脈のSrei Apが落とす。競売に出せず、ほかのキャラクターから送れない。 | @クフタルの洞門 | N 黄霊布*1
g04 gather - | 「夜光布」を手に入れる | たいていのゴースト族が落とす。競売でも買える。 | N 夜光布*1
g05 trade - | ウィンダス石の区(K-7)のShantottoに赤霊布・黄霊布・夜光布をトレードしてイベントを見ると完了 | 魔法人形「思ひ出くん」をもらう。これを持って各地の人に話すと、なくした記憶が見られる（してもしなくてもよい）。 | @ウィンダス石の区 K-7 | T npc.239.Shantotto | N 赤霊布*1 | N 黄霊布*1 | N 夜光布*1

@ mission.tvr.030 https://wiki.ffo.jp/html/38514.html
Q Altennia Burns Bright | 燃えよアルテニア | no | T npc.233.Halver
MN TVR7-4 30
RW item:上級近衛騎士カラー
RW title:秘密を託されし者
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_7-4;ドラギーユ城の Halver で Trion's directive。王立騎士団詰所の Rahal。任意の記憶：ウィンダス水の区 E-7 の Honoi-Gomoi（2階）、ラバオ G-7 の Dancing Wolf、G-9 の Rahi Fohlatti、アトルガン白門 I-7 の Ghatsad、北グスタベルグからパルブロ鉱山に入る。つるはしを多めに持ってイフリートの釜の Mining Point で Ember-encrusted orichalcum（南サンドリア E-9 の Ostalie がつるはしを売る。ユニティのワープ 125。正しい場所は7か所で順に移る：Map 5 G-8、Map 3 J-7、Map 3 F-7、Map 4 F-7、Map 1 F-9、Map 1 G-8、Map 7 I-10。見えるのはミッション中でまだ持っていない人だけ。品が出たら違う場所。「Event skipped.」でもだいじなものは入っている）。Rahal で報酬。ジュノ上層 Home Point #1 のそばの Elijah（FFXIclopedia：Halver I-9、Rahal H-9。採集道具は要らないとある。7か所は同じ。Rahi Fohlatti ではイベントにならない。Dancing Wolf は G-6。Elijah は G-6）
g01 talk - | ドラギーユ城(I-9)のHalverに話してイベントを見て、だいじなもの「トリオンの指令書」をもらう | | @ドラギーユ城 I-9 | T npc.233.Halver
g02 talk - | ドラギーユ城(H-9)のRahalに話してイベントを見る | トリオンの指令書はなくなる。 | @ドラギーユ城 H-9 | T npc.233.Rahal | K トリオンの指令書
g03 go - | イフリートの釜へ行く | ユニティのワープ（125）で行ける。予備の「つるはし」も持っていく。南サンドリア(E-9)のOstalieが売っている。 | @イフリートの釜
g04 gather - | イフリートの釜のMining Pointを掘って、だいじなもの「煉獄のオリハルコン」を手に入れる | このミッション用のMining Pointは7か所を順に移る。MAP[5](G-8)、MAP[3](J-7)、MAP[3](F-7)、MAP[4](F-7)、MAP[1](F-9)、MAP[1](G-8)、MAP[7](I-10)。MAP[1](G-8)は書いていない資料もある。見えるのは、このミッション中でまだ持っていない人だけ。品が出たら違う場所。見つからなければ一度出て回り直す。「Event skipped.」と出ても手に入っていることがあるので、だいじなものを見て確かめる。 | @イフリートの釜 | N つるはし*1
g05 talk - | （してもしなくてもよい）思ひ出くんを持って各地の人に話し、なくした記憶を見る | ウィンダス水の区(E-7)のHonoi-Gomoi（2階）、ラバオのDancing WolfとRahi Fohlatti、アトルガン白門(I-7)のGhatsad、北グスタベルグからパルブロ鉱山に入る。HalverとRahalのぶんはこのミッションで見られる。 | @ウィンダス水の区 E-7 #2 | T npc.238.Honoi-Gomoi
g06 talk - | ドラギーユ城(H-9)のRahalに話して煉獄のオリハルコンを渡し、イベントを見ると完了 | 記憶を全部集めていれば「Depleted Memorian」ももらえる。Shantottoに返せるが、何ももらえない。ジュノ上層(G-6)のElijahに話すとエミネンス・レコードのクエストが開く。 | @ドラギーユ城 H-9 | T npc.233.Rahal | K 煉獄のオリハルコン

@ mission.tvr.031 https://wiki.ffo.jp/html/38539.html
Q Maat on the Rampage | マート御乱心 | no | T npc.243.Maat
MN TVR8-1 31
RW item:獣人印章*99
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_8-1;ル・ルデの庭 H-5 の Maat で Cloth-lined basket。ジュノ下層 H-10 の Muckvix（ゴブリンの店の奥）で Map to the woman's home。J-5 のモグハウスの入口そばの Miladi-Nildi。バタリア丘陵 K-7 の Goblin Festival Site を夜（18:00〜06:00）に調べる（ユニティのワープ 125 で K-8、Survival Guide、ジュノ上層から出てもよい。洞窟へ向かう海岸）。もう一度調べてコンフロント（The Shadow That Terrorizes Battalia Downs、約20万、15分、Mumor が倒れると負け、夜でなくてよい、女神の祝福を何度も使う、魔力の泉・百烈拳・連続魔・明鏡止水・ブラッドウェポンなど、連続魔のあいだ範囲の弱体、弱体は効く）。もう一度調べて Maat's pillow。Maat で報酬（FFXIclopedia：Goblin Festival Site は K-7 と J-7 の境。夜は 18:00〜4:00。Miladi-Nildi で basket と map がなくなる）
g01 talk - | ル・ルデの庭(H-5)のMaatに話してイベントを見て、だいじなもの「布張りのバスケット」をもらう | | @ル・ルデの庭 H-5 | T npc.243.Maat
g02 talk - | ジュノ下層(H-10)のMuckvixに話してイベントを見て、だいじなもの「娘っこの家の案内図」をもらう | ゴブリンの店の奥にいる。 | @ジュノ下層 H-10 | T npc.245.Muckvix
g03 talk - | ジュノ下層(J-5)のMiladi-Nildiに話してイベントを見る | モグハウスの入口のそばにいる。布張りのバスケットと娘っこの家の案内図はなくなる。 | @ジュノ下層 J-5 | T npc.245.Miladi-Nildi = npc:Miladi-Nildi@ジュノ下層 J-5 | K 布張りのバスケット | K 娘っこの家の案内図
g04 go - | バタリア丘陵(J-7 K-7)へ行く | ユニティのワープ（125）でK-8に出る。Survival Guideやジュノ上層から出てもよい。洞窟へ向かう海岸ぞい。 | @バタリア丘陵 J-7 K-7
g05 examine - | ヴァナ時間18:00〜6:00に、バタリア丘陵(J-7 K-7)のGoblin Festival Siteを調べてイベントを見る | 夜の終わりを4:00とする書き方もある。 | @バタリア丘陵 J-7 K-7 | T obj.105.Goblin_Festival_Site = obj:Goblin Festival Site@バタリア丘陵 J-7 K-7
g06 examine - | もう一度Goblin Festival Siteを調べてコンフロント戦に入る | このときは夜でなくてよい。15分制限。味方のMumorが倒れると負け。 | @バタリア丘陵 J-7 K-7 | T obj.105.Goblin_Festival_Site
g07 defeat - | Maatを倒す | 敵の名前は「The Shadow That Terrorizes Battalia Downs」と出る。HPがとても多いモンクで、女神の祝福を何度も使う。WSを使うと女神の祝福を使いやすい。魔力の泉・百烈拳・連続魔・絶対回避なども使う。弱体やスタンは効く。Mumorを/cheerなどで応援するとよいという話もある。自分たちが倒れても、MumorがMaatを倒せば終わる。 | @バタリア丘陵 J-7 K-7 | T mob.105.The_Shadow_That_Terrorizes_Battalia_Downs = mob:The Shadow That Terrorizes Battalia Downs@バタリア丘陵 J-7 K-7
g08 examine - | もう一度Goblin Festival Siteを調べてイベントを見て、だいじなもの「マートの枕」をもらう | | @バタリア丘陵 J-7 K-7 | T obj.105.Goblin_Festival_Site
g09 talk - | ル・ルデの庭(H-5)のMaatに話して枕を返し、イベントを見ると完了 | | @ル・ルデの庭 H-5 | T npc.243.Maat | K マートの枕

@ mission.tvr.032 https://wiki.ffo.jp/html/38563.html
Q Not Just a Pretty Face | アイドルはやめられない | no | T npc.245.Muckvix
MN TVR8-2 32
RW gil:20,000ギル
RW title:ミュモルNo.1
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_8-2;ジュノ下層 H-10 の Muckvix。クフィム島 G-6 の Before Delkfutt's Tower（Survival Guide が早い）。もう一度調べて Echion 戦（ギガース族の戦士、約20万、フェイス可、Destiny Destroyers が1体でも倒れると負け、味方は回復できない、Ice Roar のあと消えないアイススパイク、マイティストライク・百烈拳、50%以下で Colossal Slam、Daunting Hurl）。もう一度調べてイベント。Muckvix で報酬（FFXIclopedia：G-6。味方は Dazbog・Magh Bihu・Gloom Phantom。約21.6万）
g01 talk - | ジュノ下層(H-10)のMuckvixに話してイベントを見る | | @ジュノ下層 H-10 | T npc.245.Muckvix
g02 go - | クフィム島(G-6)へ行く | クフィム島のSurvival Guideが早い。デルクフの塔の入口のそば。 | @クフィム島 G-6
g03 examine - | クフィム島(G-6)のBefore Delkfutt's Towerを調べてイベントを見る | | @クフィム島 G-6 | T obj.126.Before_Delkfutts_Tower = obj:Before Delkfutt's Tower@クフィム島 G-6
g04 examine - | もう一度Before Delkfutt's Towerを調べてコンフロント戦に入る | 15分制限。フェイスを呼べる。味方のGloom Phantom・Dazbog・Magh Bihuが1体でも倒れると負け。味方は回復できない。 | @クフィム島 G-6 | T obj.126.Before_Delkfutts_Tower
g05 defeat - | Echionを倒す | ギガース族の戦士。範囲の技が多く、モリバンドハックで敵対心を大きく下げる。Ice Roarのあと消えないアイススパイクがつく。バ系やキャロルで減らせる。マイティストライクと百烈拳を何度も使う。 | @クフィム島 G-6 | T mob.126.Echion = mob:Echion@クフィム島 G-6
g06 examine - | もう一度Before Delkfutt's Towerを調べてイベントを見る | | @クフィム島 G-6 | T obj.126.Before_Delkfutts_Tower
g07 talk - | ジュノ下層(H-10)のMuckvixに話してイベントを見ると完了 | | @ジュノ下層 H-10 | T npc.245.Muckvix

@ mission.tvr.033 https://wiki.ffo.jp/html/38564.html
Q Delkfutt the Great | 大魔法使いデルクフ | no | T npc.246.Shami
MN TVR8-3 33
RW item:ハイエリクサー
RW item:チャックチャック
RW title:悪魔を見抜きし者
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_8-3;任意でジュノ上層 F-6 の Elijah。ジュノ港 H-8 の Shami。南サンドリア〔Ｓ〕 H-8 の Valaineral R Davilles（カンパニエで出ていたら戻るまで待つ。戻っても出ないときはエリアを出入りする。Voucheramme・Hinrich・Dallus-Mallus で居場所がわかる）。バタリア丘陵〔Ｓ〕 G-7 の東の端の光る Secret Entrance からエルディーム古墳〔Ｓ〕（Survival Guide かカンパニエワープが近い）。F-9 の Egg Discovery Site（Noillurie が出撃中・負傷中だと進まない）。もう一度調べてコンフロント（Sa'Jho Shieldbreaker・Enkelados と若木3・Sharpshot Luttdrutt、15分、若木以外は睡眠・ブレイクが効かない、Luttdrutt は高台から引きずり下ろす、若木を先に倒すと Enkelados があやつる）。もう一度調べてイベント。Valaineral で報酬（FFXIclopedia：Elijah は G-6。Egg Discovery Site は Map 2 の F-9。Luttdrutt はそのうち下りてくる）
g01 talk - | （してもしなくてもよい）ジュノ上層(G-6かF-6)のElijahに話す | 前のミッションの話の続きが聞ける。 | @ジュノ上層 G-6 F-6
g02 talk - | ジュノ港(H-8)のShamiに話してイベントを見る | | @ジュノ港 H-8 | T npc.246.Shami = npc:Shami@ジュノ港 H-8
g03 talk - | 南サンドリア〔Ｓ〕(H-8)のValaineral R Davillesに話してイベントを見る | カンパニエバトルに出ているときは、戻るまで待つ。戻っても見えないときはエリアを出入りする。Voucheramme・Hinrich・Dallus-Mallusに聞くと居場所がわかる。 | @南サンドリア〔Ｓ〕 H-8 | T npc.80.Valaineral_R_Davilles = npc:Valaineral R Davilles@南サンドリア〔Ｓ〕 H-8
g04 go - | バタリア丘陵〔Ｓ〕(G-7)の東の端へ行く | Survival Guideかカンパニエのワープが近い。 | @バタリア丘陵〔Ｓ〕 G-7
g05 examine - | 光るSecret Entranceを調べてエルディーム古墳〔Ｓ〕に入る | | @バタリア丘陵〔Ｓ〕 G-7 | T obj.84.Secret_Entrance = obj:Secret Entrance@バタリア丘陵〔Ｓ〕 G-7
g06 go - | エルディーム古墳〔Ｓ〕MAP[2](F-9)へ行く | | @エルディーム古墳〔Ｓ〕 F-9 #2
g07 examine - | エルディーム古墳〔Ｓ〕MAP[2](F-9)のEgg Discovery Siteを調べてイベントを見る | 薔薇傭兵騎士団（Noillurie）がカンパニエに出ているときや、Noillurieがけがをしているときは進まない。調べるとそう出る。 | @エルディーム古墳〔Ｓ〕 F-9 #2 | T obj.175.Egg_Discovery_Site = obj:Egg Discovery Site@エルディーム古墳〔Ｓ〕 F-9 #2
g08 examine - | もう一度Egg Discovery Siteを調べてコンフロント戦に入る | 15分制限。 | @エルディーム古墳〔Ｓ〕 F-9 #2 | T obj.175.Egg_Discovery_Site
g09 defeat - | Enkeladosを倒す | ペットの若木がいると使い魔を使い、若木がいないとあやつるを使う。睡眠が効かない。 | @エルディーム古墳〔Ｓ〕 F-9 #2 | T mob.175.Enkelados = mob:Enkelados@エルディーム古墳〔Ｓ〕 F-9 #2
g10 defeat - | Gigas's Stalking Saplingを3体倒す | 範囲の睡眠を使う。若木は眠る。 | @エルディーム古墳〔Ｓ〕 F-9 #2 | T mob.175.Gigass_Stalking_Sapling = mob:Gigas's Stalking Sapling@エルディーム古墳〔Ｓ〕 F-9 #2
g11 defeat - | Sa'Jho Shieldbreakerを倒す | ナイト。睡眠と静寂が効かない。 | @エルディーム古墳〔Ｓ〕 F-9 #2 | T mob.175.SaJho_Shieldbreaker = mob:Sa'Jho Shieldbreaker@エルディーム古墳〔Ｓ〕 F-9 #2
g12 defeat - | Sharpshot Luttdruttを倒す | 高台から遠くを撃ってくるので、高台から引きずり下ろす。高台の上で待ってもよい。睡眠が効かない。 | @エルディーム古墳〔Ｓ〕 F-9 #2 | T mob.175.Sharpshot_Luttdrutt = mob:Sharpshot Luttdrutt@エルディーム古墳〔Ｓ〕 F-9 #2
g13 examine - | もう一度Egg Discovery Siteを調べてイベントを見る | | @エルディーム古墳〔Ｓ〕 F-9 #2 | T obj.175.Egg_Discovery_Site
g14 talk - | 南サンドリア〔Ｓ〕(H-8)のValaineral R Davillesに話してイベントを見ると完了 | ジュノ上層(G-6かF-6)のElijahに話すとエミネンス・レコードのクエストが開く。 | @南サンドリア〔Ｓ〕 H-8 | T npc.80.Valaineral_R_Davilles

@ mission.tvr.034 https://wiki.ffo.jp/html/38582.html
Q Oshasha Violation | オシャシャの守り手 | no | T npc.セレニア図書館.Andreine
MN TVR9-1 34
RW gil:20,000ギル
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_9-1;アドゥリンミッションを終えていること。セレニア図書館（F-10）の Andreine（入って左の受付）。マリアミ渓谷 I-10 の Bibliomaniac's Lair（Waypoint #2 から南東、見張り台の北東の洞窟 J-9/10、I-10 のテントとレイヴのところで左の洞窟に入りつるを登る。Seat of Gramk-Droog の前の平らな岩）。調べるとすぐコンフロント（Gramk-Droog・Velkk Defiler・Velkk Inquisitor、3体とも睡眠・静寂が効く）。もう一度調べて Liber Daemonium。Andreine で報酬（FFXIclopedia：東アドゥリン F-10 から図書館。I-10。15分。小さい2体はバインドと睡眠を使う。Gramk-Droog は範囲の攻撃とアムネジア）
g01 talk - | 東アドゥリン(F-10)からセレニア図書館に入り、Andreineに話してイベントを見る | 入って左の受付にいる。アドゥリンミッションを全部終えていないと始まらない。 | @セレニア図書館 | T npc.セレニア図書館.Andreine
g02 go - | マリアミ渓谷(I-10)へ行く | ビバック#2から南へ進み、見張り台のそばの洞窟(J-9 J-10)を抜ける。コロナイズ・レイヴを越えるか、Scalable Areaから登る。Seat of Gramk-Droogの前の平らな岩のところ。 | @マリアミ渓谷 I-10
g03 examine - | マリアミ渓谷(I-10)のBibliomaniac's Lairを調べる。すぐにコンフロント戦になる | 調べる前にフェイスを呼んでおく。15分制限。 | @マリアミ渓谷 I-10 | T obj.266.Bibliomaniacs_Lair = obj:Bibliomaniac's Lair@マリアミ渓谷 I-10
g04 defeat - | Gramk-Droogを倒す | HPが減るとマイティストライクを使う。範囲の攻撃が多い。眠る。 | @マリアミ渓谷 I-10 | T mob.266.Gramk-Droog = mob:Gramk-Droog@マリアミ渓谷 I-10
g05 defeat - | Velkk Defilerを倒す | 眠る。 | @マリアミ渓谷 I-10 | T mob.266.Velkk_Defiler = mob:Velkk Defiler@マリアミ渓谷 I-10
g06 defeat - | Velkk Inquisitorを倒す | 眠る。 | @マリアミ渓谷 I-10 | T mob.266.Velkk_Inquisitor = mob:Velkk Inquisitor@マリアミ渓谷 I-10
g07 examine - | もう一度Bibliomaniac's Lairを調べてイベントを見て、だいじなもの「リーベア・デイモニウム」をもらう | | @マリアミ渓谷 I-10 | T obj.266.Bibliomaniacs_Lair
g08 talk - | セレニア図書館のAndreineに話してイベントを見ると完了 | | @セレニア図書館 | T npc.セレニア図書館.Andreine

@ mission.tvr.035 https://wiki.ffo.jp/html/38587.html
Q Phantasmic Heroes | 夢幻なる英雄たち | no | T npc.256.Marjoirelle
MN TVR9-2 35
RW item:オシャシャの原論文
RW title:デモニカル・ドリーマーズ
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_9-2;西アドゥリン H-12 の Marjoirelle（Home Point #2 のそば）。リファーリアの Odyssean Passage。そばの Test of Talents でイベント。もう一度調べてひとりの BF（パーティを抜けるか同じエリアにほかの人がいないこと、強化は持ちこめる、フェイス不可）。Shadow Lord は二刀と両手剣を切り替え、強化を消し、マイティストライク・ブラッドウェポンを何度も使う。味方は Volker・Zeid・Valli・Oshasha・Romaa Mihgo、5人とも倒れると負け。戦いのあとイベント。セレニア図書館の Andreine で報酬（FFXIclopedia：Odyssean Passage は H-8。戦場は王の間〔Ｖ〕、15分。約17.5万。自分が倒れても味方が倒せば勝ち）
g01 talk - | 西アドゥリン(H-12)のMarjoirelleに話してイベントを見る | モグハウスを出てすぐ右、テュランドー家の前。 | @西アドゥリン H-12 | T npc.256.Marjoirelle
g02 go - | リファーリアへ行く | | @リファーリア
g03 examine - | リファーリア(H-8)のOdyssean Passageを調べてイベントを見る | | @リファーリア H-8 | T obj.281.Odyssean_Passage = obj:Odyssean Passage@リファーリア H-8
g04 examine - | そばのTest of Talentsを調べてイベントを見る | | @リファーリア H-8 | T obj.281.Test_of_Talents = obj:Test of Talents@リファーリア H-8
g05 fight - | パーティを抜けて、もう一度Test of Talentsを調べてBF「夢幻なる英雄たち」に入り、Shadow Lordに勝つ | ひとり・15分。フェイスは呼べない。強化は消えない。味方のValli・Oshasha・Volker・Zeid・Romaa Mihgoが5人とも倒れると負け。Shadow Lordは強化を消し、マイティストライクとブラッドウェポンを何度も使う。前衛ならリレイズを用意する。自分が倒れても味方が勝てば進むが、勝ったときに倒れたままだとイベントが進まないので、リレイズで起きて待つ。 | @リファーリア H-8 | T obj.281.Test_of_Talents
g06 go - | 戦いのあとのイベントを見て、東アドゥリン(F-10)からセレニア図書館に入る | | @東アドゥリン F-10
g07 talk - | セレニア図書館のAndreineに話してイベントを見ると完了 | | @セレニア図書館 | T npc.セレニア図書館.Andreine

@ mission.tvr.036 https://wiki.ffo.jp/html/38757.html
Q Skokkr Undrborn's Temptation | 誘惑のスコクル・ウンドルボルン | no | T npc.257.Glowing_Hearth
MN TVR9-3 36
RW gil:20,000ギル
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_9-3;東アドゥリン H-6 の Glowing Hearth（Home Point #1 のそば、イベントでシルバー・ナイフの中へ）。Oscarnot（Auria Collection の入札が終わっていたら Gama-Shama の前に Zemerine）。Gama-Shama。東アドゥリン J-10 の Runje Desaali でマスクの話を聞いてから、IL106 か 115 の七支公レイヴの武器・防具・Rare/Ex のアクセサリーをトレード（Kupon AW-WK・Mog Kupon AW-WK でもよい）。「What does Geosuke recommend?」で Esthete's Masque・Coat・Hose を各30,000ベヤルド。装備かそのロックスタイルで Zemerine（ほかのロックスタイルは不可。イベントが出なければ次へ）。外して Oscarnot。外の Glowing Hearth で報酬（FFXIclopedia：H-6・J-10。七支公レイヴの報酬かクーポン）
g01 talk - | 東アドゥリン(H-6)のGlowing Hearthに話してイベントを見る | イベントのあと、シルバー・ナイフの中にいる。 | @東アドゥリン H-6 | T npc.257.Glowing_Hearth = npc:Glowing Hearth@東アドゥリン H-6
g02 talk - | シルバー・ナイフのOscarnotに話してイベントを見る | | @シルバー・ナイフ | T npc.シルバー・ナイフ.Oscarnot = npc:Oscarnot@シルバー・ナイフ
g03 talk - | Oscarnotから見て左のZemerineに話す | オークションの入札が終わっているときは、ここで話しておかないとGama-Shamaの話が進まない。 | @シルバー・ナイフ | T npc.シルバー・ナイフ.Zemerine = npc:Zemerine@シルバー・ナイフ
g04 talk - | Gama-Shamaに話してイベントを見る | Runje Desaaliの話が出るまで話す。 | @シルバー・ナイフ | T npc.シルバー・ナイフ.Gama-Shama = npc:Gama-Shama@シルバー・ナイフ
g05 talk - | 東アドゥリン(J-10)のRunje Desaaliに話す | マスクの話が出るまで話す。アドゥリン城の門のWaypointが近い。 | @東アドゥリン J-10 | T npc.東アドゥリン.Runje_Desaali
g06 trade - | Runje Desaaliに七支公装備を1つトレードしてイベントを見る | 先に話を聞かずに渡すと、ふつうの下取りになって装備がなくなる。IL106か115の七支公レイヴの武器・防具・アクセサリー。ILでもらえるベヤルドが変わる。 | @東アドゥリン J-10 | T npc.東アドゥリン.Runje_Desaali | N 七支公装備*1
g07 talk - | Runje Desaaliの「ジオスケのオススメ」で、エステットマスク・エステットコート・エステットホーズを買う | 1つ30,000ベヤルド、3つで90,000ベヤルド。 | @東アドゥリン J-10 | T npc.東アドゥリン.Runje_Desaali
g08 talk - | 3つを装備するか、その3つでロックスタイルにして、シルバー・ナイフのZemerineに話してイベントを見る | ほかの見た目のロックスタイルではだめ。頭を見せない設定はかまわない。イベントが出ないときは次の手順へ進んでみる。 | @シルバー・ナイフ | T npc.シルバー・ナイフ.Zemerine | N エステットマスク*1 | N エステットコート*1 | N エステットホーズ*1
g09 talk - | 3つを外して（ロックスタイルも解いて）Oscarnotに話してイベントを見る | | @シルバー・ナイフ | T npc.シルバー・ナイフ.Oscarnot
g10 talk - | シルバー・ナイフを出て、東アドゥリン(H-6)のGlowing Hearthに話してイベントを見ると完了 | このあと次のミッションで会員証をもらうまで、シルバー・ナイフに入れない。 | @東アドゥリン H-6 | T npc.257.Glowing_Hearth

@ mission.tvr.037 https://wiki.ffo.jp/html/38758.html
Q The Prime Weapons | プライムウェポンの復活 | no | T npc.セレニア図書館.Andreine
MN TVR9-4 37
RW key_item:シルバー・ナイフ会員証
RW title:蝕む魂を求めるもの
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_9-4;見出しの開始は Andreine（セレニア図書館）。歩き方では任意でセレニア図書館の Andreine。リファーリアの Odyssean Passage。Stygian Ash をトレードして Bronze-hued tag（Stygian Ash はピクシー族、グロウベルグ〔Ｓ〕の Witchfire Glen。バタリア丘陵の Survival Guide のそばの青い光で Lightsworm を使い Walk of Echoes へ、うしろの conflux で Witchfire Glen へ。カンパニエワープや Survival Guide でもよい）。ラ・カザナル宮外郭 K-3 の上層（map 1）の Shrouded Workroom（J-3 の根は調べない、入口へ戻される。まわりに Umbril）。Odyssean Passage で報酬。このあとバストゥーク港 E-6 の Oggbi で Uran-Mafran's orb、シルバー・ナイフの Gama-Shama に 10k Gallimaufry でプライムウェポン（1日待つ）。最後のミッションには第2段階のプライムウェポンが要る（盾と楽器は不可）。ジュノ上層の Elijah（FFXIclopedia：Andreine でイベント。Stygian Ash はピクシー族かバザー。K-3。Umbril は目と魔法に反応。Oggbi E-6。Elijah G-6）
g01 talk - | （してもしなくてもよい）セレニア図書館のAndreineに話す | オシャシャの行き先の話が聞ける。ここでイベントを見るという書き方もあるので、話しておくと確実。 | @セレニア図書館 | T npc.セレニア図書館.Andreine
g02 go - | リファーリアへ行く | | @リファーリア
g03 examine - | リファーリア(H-8)のOdyssean Passageを調べてイベントを見る | | @リファーリア H-8 | T obj.281.Odyssean_Passage
g04 gather - | 「火車の灰」を手に入れる | ピクシー族が落とす。グロウベルグ〔Ｓ〕のWitchfire Glenが近い。バタリア丘陵のSurvival Guideのそばの青い光でLightswormを使ってWalk of Echoesに入り、うしろのconfluxでWitchfire Glenへ飛べる。カンパニエのワープやSurvival Guideでもよい。バザーで買ってもよい。 | @グロウベルグ〔Ｓ〕 | N 火車の灰*1
g05 trade - | リファーリア(H-8)のOdyssean Passageに火車の灰をトレードしてイベントを見て、だいじなもの「銅褐色の札」をもらう | | @リファーリア H-8 | T obj.281.Odyssean_Passage | N 火車の灰*1
g06 go - | ラ・カザナル宮外郭(K-3)の上層へ行く | Waypointで外郭へ。上層(L-8)のEntwined Rootsから下層へ降り、コロナイズ・レイヴを越えて進み、下層(G-8)の昇降機で上層へ上がって右の壁ぞいに進む。上層(J-3)の根は調べない（入口へ戻される）。スニーク・インビジがあるとよい。 | @ラ・カザナル宮外郭 K-3 #1
g07 examine - | ラ・カザナル宮外郭(K-3)の上層のShrouded Workroomを調べてイベントを見る | 小部屋にUmbrilが2体いて、イベントのあとに襲われることがあるので、準備してから調べる。銅褐色の札はなくなる。 | @ラ・カザナル宮外郭 K-3 #1 | T obj.274.Shrouded_Workroom = obj:Shrouded Workroom@ラ・カザナル宮外郭 K-3 #1 | K 銅褐色の札
g08 go - | リファーリアへ戻る | | @リファーリア
g09 examine - | リファーリア(H-8)のOdyssean Passageを調べてイベントを見ると完了 | このあとバストゥーク港(E-6)のOggbiに話し、シルバー・ナイフのGama-Shamaに10,000ガリモーフリーを払うとプライムウェポンを作り始められる。この先のミッションで、第2段階まで鍛えた武器が1つ要る（盾と楽器ではだめ）。ジュノ上層(G-6)のElijahに話すとエミネンス・レコードのクエストが開く。 | @リファーリア H-8 | T obj.281.Odyssean_Passage

@ mission.tvr.038 https://wiki.ffo.jp/html/38921.html
Q To Movalpolos! | ムバルポロスへ集え | no | T npc.234.Gumbah
MN TVR10-1 38
RW gil:20,000ギル
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_10-1;プロマシアミッションの後日談（Newfound Family、旧市街の Jabbos のイベント）を済ませていること。バストゥーク鉱山区 J-7 の Gumbah（HP#3、上の通路の家の奥の部屋）。ムバルポロス旧市街 K-10 の Tarnotik（Proto-Waypoint が一番近い、Survival Guide でもよい）。2716号採石場の Shaft Entrance でイベント（Tarnotik に Snow Lily で送ってもらえる。新市街の Home Point が近い。旧市街の Twinkbrix に 10k ギルでも送ってもらえる、E-13。開け方の欄では 2,716 ギル）。もう一度調べて BF（Gloom Phantom・Awoken Vampyr Jarl・Awoken Ariri Samariri・Awoken Hildesvini、フェイス可、Jabbos が1体を受け持つ、抜刀で Jabbos が戦い始める）。勝つとイベントで報酬（FFXIclopedia：Gumbah J-7、Tarnotik K-10。6人・15分・フェイス可。Jabbos が倒れると負け。Gloom Phantom 約15万。Awoken Vampyr Jarl は死の宣告）
g01 go - | バストゥーク鉱山区(J-7)の上の通路にあるGumbahの家へ行く | ホームポイント#3が近い。上の通路にある家の奥の部屋。 | @バストゥーク鉱山区 J-7
g02 talk - | バストゥーク鉱山区(J-7)のGumbahに話してイベントを見る | プロマシアミッションのあとの「澪標」のイベントを見ていないと始まらない。 | @バストゥーク鉱山区 J-7 | T npc.234.Gumbah
g03 go - | ムバルポロス旧市街(K-10)へ行く | Proto-Waypointで飛ぶと一番近い。Survival Guideでもよい。 | @ムバルポロス旧市街 K-10
g04 talk - | ムバルポロス旧市街(K-10)のTarnotikに話してイベントを見る | | @ムバルポロス旧市街 K-10 | T npc.11.Tarnotik
g05 go - | 2716号採石場へ行く | Tarnotikにスノーリリーをトレードすると送ってもらえる。ムバルポロス新市街のHome Pointが近い。旧市街(E-13)のTwinkbrixにギルを渡しても送ってもらえる（10,000ギルとも2,716ギルとも書かれている）。 | @2716号採石場
g06 examine - | 2716号採石場のShaft Entranceを調べてイベントを見る | | @2716号採石場 | T obj.Shaft_Entrance
g07 fight - | もう一度Shaft Entranceを調べてBF「ムバルポロスへ集え」に入り、Gloom Phantom・Awoken Ariri Samariri・Awoken Hildesvini・Awoken Vampyr Jarlに勝つと完了 | 6人・15分。フェイスを呼べる。味方のJabbosが倒れると負け。抜刀するとJabbosが戦い始め、1体を受け持ってくれる。Awoken Vampyr Jarlは死の宣告を使うので、聖水などを持って行く。Awoken Ariri Samaririのカエルの歌は魅了とトードになる。Awoken Ariri SamaririとAwoken Hildesviniは睡眠が効く。勝つとイベントになる。 | @2716号採石場 | T obj.Shaft_Entrance

@ mission.tvr.039 https://wiki.ffo.jp/html/38922.html
Q Magh Bihu on the Prowl | シマっていこうぜマッグビフ | no | T npc.153.Mandragora_Warden
MN TVR10-2 39
RW gil:20,000ギル
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_10-2;先に Acidic Humus と Watermelon を1人1つずつ用意する。Acidic Humus はアビセア-タロンギ（conflux #2 から北）の Pachypodium が落とす Alkaline Humus を H-8 の東の ??? にトレードして出る Gancanagh が落とす。競売でも買える。Watermelon はラバオ F-7（HP#2 のそば）の Scamplix で買える。ボヤーダ樹 Map 1 F-4 の Mandragora Warden（F-4 に2か所あり、E-4 から入る方、1匹だけ。Proto-Waypoint が一番近い、クロイスターのそばの Home Point から北の F の出口へ、ユニティのワープ 135 でも近い）。Magh Bihu のことを聞き、Acidic Humus をトレードしてイベント。もう一度話して「Where did Magh Bihu go?」、Watermelon をトレードしてイベントと報酬（FFXIclopedia：Map 1 F-4。Proto-Waypoint が早い。Watermelon のあとにかんたんなミニゲーム）
g01 gather - | 「酸性腐葉土」を手に入れる | 競売で買える。アビセア-タロンギのGancanaghも落とす。パーティで進めるときは1人1つずつ要る。 | @アビセア-タロンギ | N 酸性腐葉土*1
g02 gather - | 「ウォーターメロン」を手に入れる | ラバオ(F-7)のScamplixで買える。パーティで進めるときは1人1つずつ要る。 | @ラバオ F-7 | N ウォーターメロン*1
g03 go - | ボヤーダ樹MAP[1](F-4)へ行く | Proto-Waypointで飛ぶと一番近い。クロイスターのそばのHome Pointから北の出口のほうへ行ってもよい。ユニティのワープ（135）でも近い。 | @ボヤーダ樹 F-4 #1
g04 talk - | ボヤーダ樹MAP[1](F-4)のMandragora Wardenに話す | F-4に2か所いるうち、1匹だけでいる方（E-4から入る方）。 | @ボヤーダ樹 F-4 #1 | T npc.153.Mandragora_Warden
g05 trade - | Mandragora Wardenに酸性腐葉土をトレードしてイベントを見る | 選択肢はどれでもよい。 | @ボヤーダ樹 F-4 #1 | T npc.153.Mandragora_Warden | N 酸性腐葉土*1
g06 talk - | もう一度Mandragora Wardenに話して「マッグビフはどこへ？」か「マッグビフが好きなものは？」を選ぶ | | @ボヤーダ樹 F-4 #1 | T npc.153.Mandragora_Warden
g07 trade - | Mandragora Wardenにウォーターメロンをトレードしてイベントを見る | | @ボヤーダ樹 F-4 #1 | T npc.153.Mandragora_Warden | N ウォーターメロン*1
g08 talk - | 選択肢で「上から3番目」、次に「左から3番目」を選ぶと完了 | | @ボヤーダ樹 F-4 #1 | T npc.153.Mandragora_Warden

@ mission.tvr.040 https://wiki.ffo.jp/html/38923.html
Q 101 Dazbogs | 101番目のダッツボグ | no | T npc.196.Hedrov = npc:Hedrov@グスゲン鉱山 H-7
MN TVR10-3 40
RW gil:20,000ギル
RW key_item:オーケストリオン譜：DD団
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_10-3;先にグスタフの洞門 Map 2 J-6 の Boulder Eater から Fat Worm Meat を6個（ユニティのワープ 128 で同じ地図、Ex なので買えない）。グスゲン鉱山 Map 4（Juggler Hecatomb の出る地図）H-7 の Hedrov（小屋の裏、部屋のまん中。Survival Guide から A の出口へ、次の地図で左を進み G のトンネルを降りる。または B・E のトンネルから地図3で西の H の穴を降りる）。Fat Worm Meat 6個をトレードしてイベントと報酬（FFXIclopedia：Boulder Eater はグスタフの洞門 Map 2 I-7 とその奥。Hedrov は Map 4 H-7）
g01 gather - | グスタフの洞門MAP[2](I-6〜J-7)のBoulder Eaterを倒して「極太ワームの新鮮肉」を6個集める | J-6、I-7と書く資料もある。ユニティのワープ（128）で同じ地図に出る。右から2番目の広場にいる。買えないので自分で集める。 | @グスタフの洞門 #2 | N 極太ワームの新鮮肉*6
g02 go - | グスゲン鉱山(H-7)のHedrovのいる部屋へ行く | Juggler Hecatombが出る部屋。地図の番号は5とも4とも書かれている。Survival Guideで飛んでAの出口へ行き、次の地図で左を進んでGのトンネルを降りる。または中央の扉から進み、穴から落ちるとすぐそば。 | @グスゲン鉱山 H-7
g03 talk - | グスゲン鉱山(H-7)のHedrovに話してイベントを見る | 部屋のまん中の小屋の裏にいる。 | @グスゲン鉱山 H-7 | T npc.196.Hedrov
g04 trade - | Hedrovに極太ワームの新鮮肉を6個トレードしてイベントを見ると完了 | | @グスゲン鉱山 H-7 | T npc.196.Hedrov | N 極太ワームの新鮮肉*6

@ mission.tvr.041 https://wiki.ffo.jp/html/38993.html
Q Kipdrix the Faithful | 信徒キップドリックス | no | T npc.11.Tarnotik
MN TVR10-4 41
RW gil:20,000ギル
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_10-4;ムバルポロス旧市街 K-10 の Tarnotik でイベント（Proto-Waypoint、Survival Guide）。2716号採石場に入るとイベント（Tarnotik に Snow Lily、新市街の Home Point、Twinkbrix に 10k ギル）。Tarnotik にもう一度話してイベント。王の間の Throne Room の扉でイベント（ズヴァール城内郭の Home Point が近い）。もう一度調べて BF（Orcish Warchief・Yagudo Inquisitor・Topaz Quadav、SP アビリティを使う、弱体・静寂・睡眠が効く、暗闇・アドル・スロウのオーラ、Magh Bihu と Dazbog が味方、抜刀で戦い始める）。30 FPS より上だとこのあとのイベントで落ちることがある。ザルカバードに出てイベントと報酬（FFXIclopedia：Tarnotik K-10。Dazbog か Magh Bihu が倒れると負け）
g01 go - | ムバルポロス旧市街(K-10)へ行く | Proto-Waypointで飛ぶと一番近い。Survival Guideでもよい。 | @ムバルポロス旧市街 K-10
g02 talk - | ムバルポロス旧市街(K-10)のTarnotikに話してイベントを見る | | @ムバルポロス旧市街 K-10 | T npc.11.Tarnotik
g03 go - | 2716号採石場に入ってイベントを見る | Tarnotikにスノーリリーかアーリマンの涙をトレードすると送ってもらえる。ムバルポロス新市街のHome Pointが近い。 | @2716号採石場
g04 go - | ムバルポロス旧市街(K-10)へ戻る | | @ムバルポロス旧市街 K-10
g05 talk - | ムバルポロス旧市街(K-10)のTarnotikに話してイベントを見る | | @ムバルポロス旧市街 K-10 | T npc.11.Tarnotik
g06 go - | ズヴァール城内郭の王の間へ行く | ズヴァール城内郭のHome Pointが近い。 | @ズヴァール城内郭
g07 examine - | 王の間のThrone Roomを調べてイベントを見る | | @ズヴァール城内郭 | T obj.162.Throne_Room
g08 fight - | もう一度Throne Roomを調べてBF「信徒キップドリックス」に入り、Orcish Warchief・Topaz Quadav・Yagudo Inquisitorに勝つ | 6人・15分。フェイスを呼べる。味方のDazbogかMagh Bihuが倒れると負け。抜刀すると味方が戦い始めるので、全員入ってから抜刀する。敵はHPが減るとSPアビリティを使う。Orcish Warchiefは暗闇、Topaz Quadavはスロウ、Yagudo Inquisitorはアドルのオーラを出し、倒すと消える。弱体・静寂・睡眠は効く。フレームレートを30より上にしていると、このあとのイベントでゲームが落ちることがあるので、元に戻しておく。 | @ズヴァール城内郭 | T obj.162.Throne_Room
g09 go - | 勝つとザルカバードに出されるので、イベントを見ると完了 | | @ザルカバード

@ mission.tvr.042 https://wiki.ffo.jp/html/38994.html
Q Duke Alloces's Decision | 憂いのデュークアロセス | no | T obj.112.Heroes_Gambit = obj:Heroes' Gambit@ザルカバード J-9
MN TVR10-5 42
RW gil:20,000ギル
RW title:アナザー・プシュケー
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_10-5;第2段階まで鍛えたプライムウェポン（Loughnashade・Duban は不可）を装備して、ザルカバード J-9 の Heroes' Gambit でイベント（ユニティのワープ 125 が近い）。ズヴァール城内郭 G-7 の Valhallan Rift（Home Point の向かい、話が進んでいないと見えない）。もう一度調べて BF（Chaos、15分、Destiny Destroyers が味方で1人でも倒れると終わり、リレイズを用意、強い強化消し・装備を外す、弱体は効きにくい、魔力の泉で消える、どの武器でもダメージが出る、イベントのあとならジョブを変えてよい）。ザルカバードに出される。J-9 の Heroes' Gambit でイベントと報酬、Despairing psyche はなくなる（FFXIclopedia：Xarcabard J-9。Castle Zvahl Keep Map 4 G-7、Home Point #1 のそば。6人・15分・フェイス可。勝つと Despairing psyche。抜刀するとすぐ味方が突撃。Chaos はメテオ・インパクト・ケアルVI・連続魔、範囲の攻撃、強化消し、シーピングドレッドは範囲テラー）
g01 go - | ザルカバード(J-9)へ行く | ユニティのワープ（125）が近い。 | @ザルカバード J-9
g02 examine - | 第2段階のプライムウェポンを装備して、ザルカバード(J-9)のHeroes' Gambitを調べてイベントを見る | 盾（ドゥバン）と楽器（ラックナシェード）ではだめ。 | @ザルカバード J-9 | T obj.112.Heroes_Gambit
g03 go - | ズヴァール城内郭MAP[4](G-7)へ行く | Home Point #1の向かい。 | @ズヴァール城内郭 G-7 #4
g04 examine - | ズヴァール城内郭MAP[4](G-7)のValhallan Riftを調べてイベントを見る | 話がここまで進んでいないと見えない。 | @ズヴァール城内郭 G-7 #4 | T obj.162.Valhallan_Rift = obj:Valhallan Rift@ズヴァール城内郭 G-7 #4
g05 fight - | もう一度Valhallan Riftを調べてBF「憂いのデュークアロセス」に入り、Chaosに勝って、だいじなもの「絶望のプシュケー」をもらう | 6人・15分。フェイスを呼べる。強化は消えない。中ではプライムウェポンでなくてよく、ジョブを変えてもよい。味方のディスティニーデストロイヤー団が1人でも倒れると負け。抜刀すると味方が突撃するので、準備が終わるまで抜刀しない。Chaosは強化を消し、装備を外すこともある。シーピングドレッドは範囲のテラーで、魔法が届くくらい離れると当たらない。リレイズを用意する。 | @ズヴァール城内郭 G-7 #4 | T obj.162.Valhallan_Rift
g06 go - | 勝つとザルカバード(D-7)に出されるので、ザルカバード(J-9)へ行く | | @ザルカバード J-9
g07 examine - | ザルカバード(J-9)のHeroes' Gambitを調べてイベントを見ると完了 | 絶望のプシュケーはなくなる。 | @ザルカバード J-9 | T obj.112.Heroes_Gambit | K 絶望のプシュケー

@ mission.tvr.043 https://wiki.ffo.jp/html/38995.html
Q Odin's Eye | オーディンの左目 | no | T obj.112.Heroes_Gambit
MN TVR10-6 43
RW item:コーネリアの黒帯
RW title:闇の王を見送りし者
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_10-6;デュナミス-ザルカバードに入れること。前のミッションのあとエリアを出入りしないと始まらない（Twinkling Presence も見えない）。Heroes' Gambit でイベント、Despairing psyche をもう一度。デュナミス-ザルカバードの4か所の Twinkling Presence（I-9 の北西、平らなところでまわりにデーモン。H-7 の東、坂を上がると見える右の崖の上。F-7 の北のまん中、ウルガラン山脈への出口の上。G-10 の北西の角）で Suffering・Anguished・Rancorous・Determined psyche。D-7 の光る Before Castle Zvahl（ダイナミスロードの場所）でイベント、ザルカバードに出される。Raebrimm's memento。バストゥーク鉱山区 J-7 の Gumbah で報酬。ジュノ上層の Elijah（FFXIclopedia：エリアを出入りしてから J-9 の Heroes' Gambit、「Despairing psyche をなくした」と出たら前のミッションの最後なのでもう一度。近くの Trail Markings からデュナミス-ザルカバード。I-9 北西、H-7 坂を上がって東の崖の端、G-10 西側、F-7 北の高い崖の上。D-7 の Before Castle Zvahl、プシュケーはなくなる。Gumbah J-7。Elijah G-6）
g01 go - | 前のミッションのあと一度エリアを出てから、ザルカバード(J-9)へ行く | 出入りしないとこのミッションが始まらない。 | @ザルカバード J-9
g02 examine - | ザルカバード(J-9)のHeroes' Gambitを調べてイベントを見て、だいじなもの「絶望のプシュケー」をもらう | 最後に絶望のプシュケーをなくしたと出たときは、前のミッションの最後のイベントだったので、もう一度調べる。 | @ザルカバード J-9 | T obj.112.Heroes_Gambit
g03 go - | 近くのTrail Markingsからデュナミス-ザルカバードに入る | デュナミス-ザルカバードに入る資格が要る。 | @ザルカバード J-9
g04 examine - | デュナミス-ザルカバード(I-9)のTwinkling Presenceを調べて、だいじなもの「苦しみのプシュケー」をもらう | I-9の北西の平らなところ。まわりにデーモンがいる。光っているので見つけやすい。 | @デュナミス-ザルカバード I-9 | T obj.デュナミス-ザルカバード.Twinkling_Presence_I-9 = obj:Twinkling Presence@デュナミス-ザルカバード I-9
g05 examine - | デュナミス-ザルカバード(H-7)のTwinkling Presenceを調べて、だいじなもの「憎しみのプシュケー」をもらう | 坂を上がったところの、東（右）の崖の上の端。 | @デュナミス-ザルカバード H-7 | T obj.デュナミス-ザルカバード.Twinkling_Presence_H-7 = obj:Twinkling Presence@デュナミス-ザルカバード H-7
g06 examine - | デュナミス-ザルカバード(F-7)のTwinkling Presenceを調べて、だいじなもの「誓いのプシュケー」をもらう | G-7から坂を上がった上の段の、北のいちばん奥。 | @デュナミス-ザルカバード F-7 | T obj.デュナミス-ザルカバード.Twinkling_Presence_F-7 = obj:Twinkling Presence@デュナミス-ザルカバード F-7
g07 examine - | デュナミス-ザルカバード(G-10)のTwinkling Presenceを調べて、だいじなもの「願いのプシュケー」をもらう | G-10の西のはしの行き止まり。 | @デュナミス-ザルカバード G-10 | T obj.デュナミス-ザルカバード.Twinkling_Presence_G-10 = obj:Twinkling Presence@デュナミス-ザルカバード G-10
g08 go - | デュナミス-ザルカバード(D-7)のズヴァール城の門の前へ行く | | @デュナミス-ザルカバード D-7
g09 examine - | デュナミス-ザルカバード(D-7)のBefore Castle Zvahlを調べ、ザルカバードに出てイベントを見て、だいじなもの「ラエブリームの形見」をもらう | 光っているので見つけやすい。5つのプシュケーはなくなる。 | @デュナミス-ザルカバード D-7 | T obj.デュナミス-ザルカバード.Before_Castle_Zvahl = obj:Before Castle Zvahl@デュナミス-ザルカバード D-7 | K 絶望のプシュケー | K 苦しみのプシュケー | K 憎しみのプシュケー | K 誓いのプシュケー | K 願いのプシュケー
g10 go - | バストゥーク鉱山区(J-7)の上の通路にあるGumbahの家へ行く | ホームポイント#3が近い。上の通路にある家の奥の部屋。 | @バストゥーク鉱山区 J-7
g11 talk - | バストゥーク鉱山区(J-7)のGumbahに話してイベントを見ると完了 | ラエブリームの形見はなくなる。このあとジュノ上層(G-6)のElijahに話すと、エミネンス・レコードのクエストが開く。 | @バストゥーク鉱山区 J-7 | T npc.234.Gumbah | K ラエブリームの形見

@ mission.tvr.044 https://wiki.ffo.jp/html/39029.html
Q Moglesse Oblige | モーグリのありがとうクポ | no | T npc.Moogle
MN TVR11-1 44
RW item:プラチナモグベルト
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_11-1;所属国のモグハウスの Moogle でイベント。ラテーヌ高原 G-6 のストーンサークルの ???（ユニティのワープ 99 が一番近い、Survival Guide やテレポホラでもよい）。ラテーヌ高原 H-10 の Moogle Meeting（オルデール鍾乳洞の Map 3 の出口から出る。Proto-Waypoint があれば近い。Survival Guide でオルデール鍾乳洞の入口から B、Map 1 の D の道、Map 2 の D で H-11 の南東の穴を降りると Map 3）。もう一度調べて BF（Spikehelm Argok・Tethys・Garmatur the Merciless・Antican Curule Aedilis、フェイス可、全部睡眠・静寂が効く）。勝つとイベントと報酬（FFXIclopedia：G-6 の ???、ユニティのワープ 99。H-10 の Moogle Meeting、Geomagnetic Fount のそば。戦場は常花の石窟、15分、全部睡眠が効く、SP アビリティを使う）
g01 talk - | 所属国のモグハウスのMoogleに話してイベントを見る | モグハウスでMoogleからモグハウスの説明を聞いていないと始まらない。 | T npc.Moogle
g02 go - | ラテーヌ高原(G-6)のストーンサークルへ行く | ユニティのワープ（99）が一番近い。Survival Guideやテレポホラでもよい。 | @ラテーヌ高原 G-6
g03 examine - | ラテーヌ高原(G-6)のストーンサークルの中の???を調べてイベントを見る | | @ラテーヌ高原 G-6 | T obj.102.???_G-6 = obj:???@ラテーヌ高原 G-6
g04 go - | ラテーヌ高原(H-10)へ行く | オルデール鍾乳洞を抜けた崖の下。Proto-Waypointがあれば近い。ないときはSurvival Guideでオルデール鍾乳洞の入口へ飛び、MAP3の出口から出る。 | @ラテーヌ高原 H-10
g05 examine - | ラテーヌ高原(H-10)のMoogle Meetingを調べてイベントを見る | | @ラテーヌ高原 H-10 | T obj.102.Moogle_Meeting = obj:Moogle Meeting@ラテーヌ高原 H-10
g06 fight - | もう一度Moogle Meetingを調べてBF「モーグリのありがとうクポ」に入り、Spikehelm Argok・Tethys・Antican Curule Aedilis・Garmatur the Mercilessに勝つと完了 | 6人・15分。フェイスを呼べる。入ると強化が消える。始めの場所から少しでも前に出ると襲ってくる。4体ともSPアビリティを使う。睡眠と静寂が効くが、Tethysは睡眠が効きにくいという話もある。勝つとイベントになる。 | @ラテーヌ高原 H-10 | T obj.102.Moogle_Meeting

@ mission.tvr.045 https://wiki.ffo.jp/html/39086.html
Q The Voracious Beast | 蝕世の霊獣カオス | no
MN TVR11-2 45
RW item:メダダリング・クレブリング・コーネリアリング・ラジュリーズリング・レコリング・フィックリング・イフラマドリングから1つ
RW key_item:カオスの血
RW title:アストラルの理を守りし者
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_11-2;ザルカバード J-9 の Heroes' Gambit でイベント。ズヴァール城内郭の Home Point の Valhallan Rift（G-7）でイベント。もう一度調べて1戦目（Garazu-Horeizu、両手棍の WS、連続魔と -ガIV、自分とディスティニーデストロイヤー団の分身を呼ぶ、Garazu-Horeizu だけ倒せばよい、入ると強化が消える、フェイス可、味方はディスティニーデストロイヤー団）。イベントのあと、第2段階以上のプライムウェポンを装備して2戦目（Chaos、パーティ全員が装備していないと入れない、Duban・Loughnashade は不可、ほかの武器や第1段階はダメージが7割減ってとどめをさせない、フェイス可、Gurebu-Ougrebu と Medada が味方、HP を減らすと fetter が出る、Cornelia・Lehko Habhoka・Ragelise・Fickblix・Luzaf が1人ずつ出る、Black Sanctus、とどめはプライムウェポンで）。Vial of Chaos's blood。Heroes' Gambit で最後のイベントとリング（あとで選んでもよい、次のミッションには進む。リングを捨てるとコンクェストの集計ごとに1回選び直せる。ザルカバードで捨てたらエリアを出入りする）（FFXIclopedia：Valhallan Rift は Map 4 G-7、Home Point #1 のすぐそば。1戦目は30分、ディスティニーデストロイヤー団が倒れると負け。2戦目は入ったらプライムウェポンを外してよい、30分、味方は2分30秒後に戦い始める）
g01 go - | ザルカバード(J-9)へ行く | ユニティのワープ（125）が近い。 | @ザルカバード J-9
g02 examine - | ザルカバード(J-9)のHeroes' Gambitを調べてイベントを見る | | @ザルカバード J-9 | T obj.112.Heroes_Gambit
g03 go - | ズヴァール城内郭MAP[4](G-7)へ行く | Home Point #1のすぐそば。 | @ズヴァール城内郭 G-7 #4
g04 examine - | ズヴァール城内郭MAP[4](G-7)のValhallan Riftを調べてイベントを見る | | @ズヴァール城内郭 G-7 #4 | T obj.162.Valhallan_Rift
g05 fight - | もう一度Valhallan Riftを調べて1戦目のBFに入り、Garazu-Horeizuに勝つ | プライムウェポンは要らない。入ると強化が消える。フェイスを呼べる。味方のディスティニーデストロイヤー団が1人でも倒れると負け。仲間の誰かが戦い始めると味方も突撃する。Garazu-Horeizuは連続魔で強い魔法を続けて撃ち、強化を消し、自分たちの分身を呼ぶが、倒すのはGarazu-Horeizuだけでよい。30分と書く資料もある。 | @ズヴァール城内郭 G-7 #4 | T obj.162.Valhallan_Rift
g06 fight - | 第2段階のプライムウェポンを装備して、もう一度Valhallan Riftを調べて2戦目のBFに入り、Chaosに勝って、だいじなもの「カオスの血」をもらう | パーティの全員が装備していないと入れない（盾のドゥバンと楽器のラックナシェードではだめ）。入ってから外してもよいが、とどめはプライムウェポンでさす。ほかの武器ではダメージが大きく減る。フェイスを呼べる。HPを減らすとfetterが出て、出ているあいだはダメージが通りにくい。味方が1人ずつ出てBlack Sanctusを受けてくれる。30分と書く資料もある。 | @ズヴァール城内郭 G-7 #4 | T obj.162.Valhallan_Rift
g07 go - | ザルカバード(J-9)へ戻る | | @ザルカバード J-9
g08 examine - | ザルカバード(J-9)のHeroes' Gambitを調べてイベントを見て、報酬のリングを選ぶ | あとで選ぶこともできる（次のミッションには進む）。リングを捨てて、コンクェストの集計をまたいでから調べ直すと選び直せる。ザルカバードで捨てたときは、エリアを出入りしてから調べる。 | @ザルカバード J-9 | T obj.112.Heroes_Gambit
g09 go - | エンディングを見ると完了 | リングと称号をもらい、そのまま次の「あなたの選択」になる。 | @ザルカバード J-9

@ mission.tvr.046 https://wiki.ffo.jp/html/39087.html
Q Your Decision | あなたの選択 | no
MN TVR11-3 46
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_11-3;前のミッションのイベントのあと自動でこのミッションになる。シルバー・ナイフの Gama-Shama に話すとプライムウェポンを最後まで鍛えられる話、ガリモーフリーの上限が 100,000,000 になる。Elijah に話し、エリアを出入りしてもう一度話すと Voracious Psyche を集められる。次は後日談（FFXIclopedia：最後の章、前のミッションのあと自動。後日談は下の相手に話す。持ち物がいっぱいでコンプリートの報酬をもらっていないときは、もらってから始まる）
g01 go - | 蝕世の霊獣カオスのエンディングのあと、自動でこのミッションになる | 進めるイベントはない。ガリモーフリーの上限が1億になる。
g02 examine - | （してもしなくてもよい）報酬のリングを選んでいないときは、ザルカバード(J-9)のHeroes' Gambitを調べてリングをもらう | | @ザルカバード J-9 | T obj.112.Heroes_Gambit
g03 talk - | （してもしなくてもよい）シルバー・ナイフのGama-Shamaに話す | プライムウェポンを最後まで鍛えられるようになった話が聞ける。 | @シルバー・ナイフ | T npc.シルバー・ナイフ.Gama-Shama
g04 talk - | （してもしなくてもよい）ジュノ上層(G-6)のElijahに話し、エリアを出入りしてもう一度話す | エミネンス・レコードのクエストの報酬で「蝕みのプシュケー」を集められるようになる。 | @ジュノ上層 G-6
g05 go - | リングを受け取ったあと、後日談の相手に話すと後日談が始まる | 「蝕世のエンブリオ～後日談」を見る。このミッションに完了はない。

@ mission.tvr.047 https://wiki.ffo.jp/html/39147.html
Q Epilogue | 蝕世のエンブリオ～後日談 | no
MN - 47
RW item:ブードックススーツ
RW item:ブードックスマスク
RW item:マッグビフスーツ
RW item:マッグビフマスク
RW item:ダッツボグナックル
RW item:マートの秘薬*3
XS BG Wiki;https://www.bg-wiki.com/ffxi/Epilogue_Quests;下の相手に、どの順でも話すとイベント。クエストの一覧には出ない。持ち物がいっぱいでコンプリートの報酬をもらっていないときは、もらってから始まる。ムバルポロス旧市街 K-10 の Tarnotik（Boudox's Masque・Boudox's Suit、Proto-Waypoint が近い）。ボヤーダ樹 E-4 の Mandragora Warden（Magh Bihu's Masque・Magh Bihu's Suit、Proto-Waypoint で D-4 に出る）。グスゲン鉱山 H-7 の Hedrov（Dazbog's Knuckles、Survival Guide から A、次の地図で左を進み G のトンネルで地図4）。バストゥーク鉱山区 J-7 の Gumbah・ドラギーユ城 I-9 の Halver・ウィンダス石の区 K-7 の Shantotto（Maat's Concoc. を1つずつ）。ラバオ G-6 の Dancing Wolf（Uran-Mafran's orb が返ってくる、Carbuncle Debacle を済ませていること）（FFXIclopedia：Tarnotik K-10、Hedrov Map 4 H-7、Mandragora Warden Map 1 F-4、Gumbah J-7、Halver I-9、Shantotto K-7、Dancing Wolf G-6）
g01 go - | ムバルポロス旧市街(K-10)へ行く | 後日談の相手には、どの順で話してもよい。Proto-Waypointで飛ぶと一番近い。 | @ムバルポロス旧市街 K-10
g02 talk - | ムバルポロス旧市街(K-10)のTarnotikに話してイベントを見て、ブードックススーツとブードックスマスクをもらう | 蝕世のエンブリオのコンプリートの報酬をもらっていないと始まらない。 | @ムバルポロス旧市街 K-10 | T npc.11.Tarnotik
g03 go - | ボヤーダ樹MAP[1](F-4)へ行く | Proto-Waypointで飛ぶと近い。 | @ボヤーダ樹 F-4 #1
g04 talk - | ボヤーダ樹MAP[1](F-4)のMandragora Wardenに話してイベントを見て、マッグビフスーツとマッグビフマスクをもらう | E-4と書く資料もある。 | @ボヤーダ樹 F-4 #1 | T npc.153.Mandragora_Warden
g05 go - | グスゲン鉱山(H-7)のHedrovのいる部屋へ行く | Juggler Hecatombが出る部屋。地図の番号は5とも4とも書かれている。Survival Guideで飛んでAの出口へ行き、次の地図で左を進んでGのトンネルを降りる。 | @グスゲン鉱山 H-7
g06 talk - | グスゲン鉱山(H-7)のHedrovに話してイベントを見て、ダッツボグナックルをもらう | | @グスゲン鉱山 H-7 | T npc.196.Hedrov
g07 go - | バストゥーク鉱山区(J-7)の上の通路にあるGumbahの家へ行く | ホームポイント#3が近い。上の通路にある家の奥の部屋。 | @バストゥーク鉱山区 J-7
g08 talk - | バストゥーク鉱山区(J-7)のGumbahに話してイベントを見て、マートの秘薬をもらう | | @バストゥーク鉱山区 J-7 | T npc.234.Gumbah
g09 talk - | ドラギーユ城(I-9)のHalverに話してイベントを見て、マートの秘薬をもらう | | @ドラギーユ城 I-9 | T npc.233.Halver
g10 talk - | ウィンダス石の区(K-7)のShantottoに話してイベントを見て、マートの秘薬をもらう | | @ウィンダス石の区 K-7 | T npc.239.Shantotto
g11 talk - | （してもしなくてもよい）ラバオ(G-7)のDancing Wolfに話してイベントを見る | G-6と書く資料もある。召喚士のアーティファクトをもらうクエストを済ませていないと出ない。報酬はないとも、だいじなものが返ってくるとも書かれている。 | @ラバオ G-7 | T npc.247.Dancing_Wolf
