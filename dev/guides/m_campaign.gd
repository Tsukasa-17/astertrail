@ mission.campaign.001 https://wiki.ffo.jp/html/14077.html
Q Streetsweeper III (S) | 不審物回収 III（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice = npc:Rasdinice@南サンドリア〔Ｓ〕 I-9
MN - 1
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が黄金剣勲章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Streetsweeper_III_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Security、Golden Star §§§§。Suspicious Object を5つ回収するとノルマを満たし、Rasdinice にもどると連合軍戦績。経験値260・連合軍戦績820。Campaign Ops のページ：受付は Rasdinice（I-9）、Op Credit 1つ（FFXIclopedia：Rasdinice I-9、1人。★ごとに経験値246〜386・戦績703〜1217）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「治安維持」から「不審物回収 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | 南サンドリア〔Ｓ〕の中を歩いて、Suspicious Objectを探す | 戦闘はない。出る場所は毎回ちがい、広域スキャンには出ない。街のほぼどこにでも出る。(F-6)・(F-9)・(G-9)・(J-9)・(K-8)・(K-10)・(L-7)・(M-5)・(M-7)などに出たことがある。 | @南サンドリア〔Ｓ〕
g03 examine - | 見つけたSuspicious Objectを調べて、1つ目を回収する | だれかが先に調べると消えて別の場所に出る。同時にいくつか出ていることもある。 | @南サンドリア〔Ｓ〕 | T obj.南サンドリア〔Ｓ〕.Suspicious_Object = obj:Suspicious Object!@南サンドリア〔Ｓ〕
g04 examine - | 同じようにして、合わせて5つのSuspicious Objectを回収する | 5つ集めると経験値が入り、ノルマを満たしたと出る。 | @南サンドリア〔Ｓ〕 | T obj.南サンドリア〔Ｓ〕.Suspicious_Object
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.002 https://wiki.ffo.jp/html/14076.html
Q Streetsweeper II (S) | 不審物回収 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 2
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が連合突撃章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Streetsweeper_II_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Security、Allied Ribbon of Glory §§§§。Suspicious Object を3つ回収、いくつか同時に出ることがある。経験値160・連合軍戦績620（FFXIclopedia：Rasdinice I-9、1人。★ごとに経験値160〜259・戦績562〜920。だれかが拾うと別の場所に出る。2〜3分で消える）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「治安維持」から「不審物回収 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | 南サンドリア〔Ｓ〕の中を歩いて、Suspicious Objectを探す | 戦闘はない。出る場所は毎回ちがい、広域スキャンには出ない。街のほぼどこにでも出る。(D-7)・(F-6)・(G-9)・(H-9)・(I-9)・(J-9)・(K-10)・(L-6)・(M-5)などに出たことがある。2〜3分だれも調べないと消えると書く資料もある。 | @南サンドリア〔Ｓ〕
g03 examine - | 見つけたSuspicious Objectを調べて、1つ目を回収する | だれかが先に調べると消えて別の場所に出る。同時にいくつか出ていることもある。 | @南サンドリア〔Ｓ〕 | T obj.南サンドリア〔Ｓ〕.Suspicious_Object
g04 examine - | 同じようにして、合わせて3つのSuspicious Objectを回収する | 3つ集めると経験値が入り、ノルマを満たしたと出る。 | @南サンドリア〔Ｓ〕 | T obj.南サンドリア〔Ｓ〕.Suspicious_Object
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.003 https://wiki.ffo.jp/html/14314.html
Q Streetsweeper I (B) | 不審物回収 I（共和国軍） | yes | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus = npc:Hieronymus@バストゥーク商業区〔Ｓ〕 E-8
MN - 3
LK quest:過去世界クエスト「第四共和軍団入団試験」をクリアして、第四共和軍団（共和国軍）に入っている
LK condition:所属軍が共和国軍
LK condition:勲章が二級連合従軍章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Streetsweeper_I_(B);Hieronymus（バストゥーク商業区〔Ｓ〕E-8）、Security、Bronze Ribbon of Service §。Suspicious Object を1つ。経験値60・連合軍戦績420。Campaign Ops のページ：受付は Hieronymus（E-8）（FFXIclopedia：Hieronymus E-8、1つだけでよい。★ごとに戦績516〜717）
g01 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに話して、指令書「治安維持」から「不審物回収 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受付はAureliusと書く資料もある。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
g02 go - | バストゥーク商業区〔Ｓ〕の中を歩いて、Suspicious Objectを探す | 戦闘はない。出る場所は毎回ちがい、広域スキャンには出ない。(E-10)・(F-8)・(G-4)・(H-4)・(H-5)・(I-4)・(J-10)・(L-8)などに出たことがある。 | @バストゥーク商業区〔Ｓ〕
g03 examine - | 見つけたSuspicious Objectを調べる | 調べると経験値が入る。だれかが先に調べると消えて別の場所に出る。 | @バストゥーク商業区〔Ｓ〕 | T obj.バストゥーク商業区〔Ｓ〕.Suspicious_Object = obj:Suspicious Object!@バストゥーク商業区〔Ｓ〕
g04 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus

@ mission.campaign.004 https://wiki.ffo.jp/html/14075.html
Q Streetsweeper I (S) | 不審物回収 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 4
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が二級連合従軍章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Streetsweeper_I_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Security、Bronze Ribbon of Service §。Suspicious Object を1つ。経験値60・連合軍戦績420（FFXIclopedia：Rasdinice I-9、1人、1つだけでよい。★ごとに経験値60〜147・戦績420〜590）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「治安維持」から「不審物回収 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | 南サンドリア〔Ｓ〕の中を歩いて、Suspicious Objectを探す | 戦闘はない。出る場所は毎回ちがい、広域スキャンには出ない。街のほぼどこにでも出て、西か東へ少しずつ移ることが多い。(F-6)・(I-11)・(J-9)・(K-8)・(K-10)・(L-7)・(L-9)・(M-5)・(M-7)などに出たことがある。 | @南サンドリア〔Ｓ〕
g03 examine - | 見つけたSuspicious Objectを調べる | 調べると経験値が入る。だれかが先に調べると消えて別の場所に出る。 | @南サンドリア〔Ｓ〕 | T obj.南サンドリア〔Ｓ〕.Suspicious_Object
g04 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.005 https://wiki.ffo.jp/html/15288.html
Q Streetsweeper I (W) | 不審物回収 I（連邦軍） | yes | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo = npc:Emhi Tchaoryo@ウィンダス水の区〔Ｓ〕 H-9 #1
MN - 5
LK quest:過去世界クエスト「コブラ傭兵団入団試験」をクリアして、コブラ傭兵団（連邦軍）に入っている
LK condition:所属軍が連邦軍
LK condition:勲章が二級連合従軍章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Streetsweeper_I_(W);Emhi Tchaoryo（ウィンダス水の区〔Ｓ〕H-9）、Security、Bronze Ribbon of Service §。Suspicious Object を1つ。経験値60・連合軍戦績420。Campaign Ops のページ：受付は Emhi Tchaoryo（H-9、北）（FFXIclopedia：Emhi Tchaoryo H-9、1人、1つだけでよい。★ごとに戦績422〜715。2〜3分で消える）
g01 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに話して、指令書「治安維持」から「不審物回収 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
g02 go - | ウィンダス水の区〔Ｓ〕の中を歩いて、Suspicious Objectを探す | 戦闘はない。出る場所は毎回ちがい、広域スキャンには出ない。北と南の両方に出る。北の(F-7)・(G-5)・(G-7)・(G-8)・(I-9)・(K-6)・(L-10)、南の(I-8)・(J-9)などに出たことがある。同時に3つまで出ると書く資料もある。 | @ウィンダス水の区〔Ｓ〕
g03 examine - | 見つけたSuspicious Objectを調べる | 調べると経験値が入る。だれかが先に調べると消えて別の場所に出る。 | @ウィンダス水の区〔Ｓ〕 | T obj.ウィンダス水の区〔Ｓ〕.Suspicious_Object = obj:Suspicious Object!@ウィンダス水の区〔Ｓ〕
g04 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo

@ mission.campaign.006 https://wiki.ffo.jp/html/14065.html
Q Vanguard-X III (S) | 兵員輸送 III（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 6
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が黄金剣勲章以上
LK condition:募集要員は1〜6人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Vanguard-X_III_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Supply transport、Golden Star §§§§（要確認の印つき）、1〜6人。Gate Sentry（東ロンフォール〔Ｓ〕J-11、ジャグナー森林〔Ｓ〕G-5、ブンカール浦〔Ｓ〕E-7、バタリア丘陵〔Ｓ〕F-8。Gate Sentry のページ）。Reinforcement を Campaign の NPC まで連れて行く。拠点の NPC は東ロンフォール〔Ｓ〕H-8（Arlayse, R.K. のページも H-8）、バタリア丘陵〔Ｓ〕J-8、ロランベリー耕地〔Ｓ〕J-7、ソロムグ原野〔Ｓ〕H-6、パシュハウ沼〔Ｓ〕K-6。離れすぎると自分で歩き出し、話すと戻る。III は2人。経験値200・連合軍戦績700（FFXIclopedia：Rasdinice I-9、1〜6人、制限30分。Gate Sentry は同じ4か所、拠点は東ロンフォール〔Ｓ〕H-8・ジャグナー森林〔Ｓ〕I-8・ブンカール浦〔Ｓ〕H-10・バタリア丘陵〔Ｓ〕J-7。★ごとに経験値418〜525・戦績1195〜1500）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「輸送運搬」から「兵員輸送 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | 東ロンフォール〔Ｓ〕(J-11)のGate Sentryのところへ行く | サンドリアが支配しているエリアのGate Sentryならどこでもよい。ジャグナー森林〔Ｓ〕(G-5)・ブンカール浦〔Ｓ〕(E-7)・バタリア丘陵〔Ｓ〕(F-8)にもいる。 | @東ロンフォール〔Ｓ〕 J-11
g03 talk - | Gate Sentryに話して、すぐ横に2人のReinforcement（補充兵）を出す | 話すと始まり、制限時間は30分。補充兵は2人出る。 | @東ロンフォール〔Ｓ〕 J-11 | T npc.東ロンフォール〔Ｓ〕.Gate_Sentry = npc:Gate Sentry@東ロンフォール〔Ｓ〕 J-11
g04 talk - | 2人のReinforcementにそれぞれ話して、ついてこさせる | 足が遅く、離れすぎたり敵の斥候を見たようなことを言ったりすると勝手に歩き出す。そのときはもう一度話すと戻ってくる。13ヤルムくらいまでなら離れないと書く資料もある。 | @東ロンフォール〔Ｓ〕 | T npc.東ロンフォール〔Ｓ〕.Reinforcement = npc:Reinforcement!@東ロンフォール〔Ｓ〕
g05 go - | 2人のReinforcementを連れて、東ロンフォール〔Ｓ〕(H-8)のArlayse, R.K.の前まで行く | モンスターに絡まれなければ戦闘はない。2人ともそろえて連れて行く。着くと補充兵がひと言しゃべる。 | @東ロンフォール〔Ｓ〕 H-8
g06 talk - | Arlayse, R.K.に話して、経験値をもらう | ほかのエリアから始めたときは、そのエリアの拠点のNPC（ジャグナー森林〔Ｓ〕(I-8)・ブンカール浦〔Ｓ〕(H-10)・バタリア丘陵〔Ｓ〕(J-7)）に話す。バタリア丘陵〔Ｓ〕はJ-8と書く資料もある。 | @東ロンフォール〔Ｓ〕 H-8 | T npc.東ロンフォール〔Ｓ〕.Arlayse_RK = npc:Arlayse, R.K.@東ロンフォール〔Ｓ〕 H-8
g07 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.007 https://wiki.ffo.jp/html/14064.html
Q Vanguard-X II (S) | 兵員輸送 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 7
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が連合突撃章以上
LK condition:募集要員は1〜6人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Vanguard-X_II_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Supply transport、Allied Ribbon of Glory §§§§、1〜6人。Gate Sentry（東ロンフォール〔Ｓ〕J-11、ジャグナー森林〔Ｓ〕G-5、ブンカール浦〔Ｓ〕E-7、バタリア丘陵〔Ｓ〕F-8。Gate Sentry のページ）。Reinforcement を Campaign の NPC まで連れて行く。拠点の NPC は東ロンフォール〔Ｓ〕H-8（Arlayse, R.K. のページも H-8）、バタリア丘陵〔Ｓ〕J-8、ロランベリー耕地〔Ｓ〕J-7、ソロムグ原野〔Ｓ〕H-6、パシュハウ沼〔Ｓ〕K-6。離れすぎると自分で歩き出し、話すと戻る。経験値200・連合軍戦績700（FFXIclopedia：Rasdinice I-9、1〜6人、制限30分。拠点は東ロンフォール〔Ｓ〕H-8・ジャグナー森林〔Ｓ〕I-8・ブンカール浦〔Ｓ〕H-10・バタリア丘陵〔Ｓ〕J-7。★ごとに経験値200〜375・戦績700〜1200）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「輸送運搬」から「兵員輸送 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | 東ロンフォール〔Ｓ〕(J-11)のGate Sentryのところへ行く | サンドリアが支配しているエリアのGate Sentryならどこでもよい。ジャグナー森林〔Ｓ〕(G-5)・ブンカール浦〔Ｓ〕(E-7)・バタリア丘陵〔Ｓ〕(F-8)にもいる。 | @東ロンフォール〔Ｓ〕 J-11
g03 talk - | Gate Sentryに話して、すぐ横にReinforcement（補充兵）を出す | 話すと始まり、制限時間は30分。 | @東ロンフォール〔Ｓ〕 J-11 | T npc.東ロンフォール〔Ｓ〕.Gate_Sentry
g04 talk - | Reinforcementに話して、ついてこさせる | 足が遅く、離れすぎたり敵の斥候を見たようなことを言ったりすると勝手に歩き出す。そのときはもう一度話すと戻ってくる。13ヤルムくらいまでなら離れないと書く資料もある。 | @東ロンフォール〔Ｓ〕 | T npc.東ロンフォール〔Ｓ〕.Reinforcement
g05 go - | Reinforcementを連れて、東ロンフォール〔Ｓ〕(H-8)のArlayse, R.K.の前まで行く | モンスターに絡まれなければ戦闘はない。着くと補充兵がひと言しゃべる。 | @東ロンフォール〔Ｓ〕 H-8
g06 talk - | Arlayse, R.K.に話して、経験値をもらう | ほかのエリアから始めたときは、そのエリアの拠点のNPC（ジャグナー森林〔Ｓ〕(I-8)・ブンカール浦〔Ｓ〕(H-10)・バタリア丘陵〔Ｓ〕(J-7)）に話す。バタリア丘陵〔Ｓ〕はJ-8と書く資料もある。 | @東ロンフォール〔Ｓ〕 H-8 | T npc.東ロンフォール〔Ｓ〕.Arlayse_RK
g07 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.008 https://wiki.ffo.jp/html/14063.html
Q Vanguard-X I (S) | 兵員輸送 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 8
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が二級連合従軍章以上
LK condition:募集要員は1〜6人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Vanguard-X_I_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Supply transport、Bronze Ribbon of Service §、1〜6人。Gate Sentry（東ロンフォール〔Ｓ〕J-11、ジャグナー森林〔Ｓ〕G-5、ブンカール浦〔Ｓ〕E-7、バタリア丘陵〔Ｓ〕F-8。Gate Sentry のページ）。Reinforcement を Campaign の NPC まで連れて行く。拠点の NPC は東ロンフォール〔Ｓ〕H-8（Arlayse, R.K. のページも H-8）、バタリア丘陵〔Ｓ〕J-8、ロランベリー耕地〔Ｓ〕J-7、ソロムグ原野〔Ｓ〕H-6、パシュハウ沼〔Ｓ〕K-6。離れすぎると自分で歩き出し、話すと戻る。経験値100・連合軍戦績500（FFXIclopedia：Rasdinice I-9、1〜6人、制限30分。拠点は東ロンフォール〔Ｓ〕H-8・ジャグナー森林〔Ｓ〕I-8・ブンカール浦〔Ｓ〕H-10・バタリア丘陵〔Ｓ〕J-7、Arlayse, R.K. に話す。13ヤルム以内なら逃げない。★ごとに経験値100〜225・戦績500〜900）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「輸送運搬」から「兵員輸送 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | 東ロンフォール〔Ｓ〕(J-11)のGate Sentryのところへ行く | サンドリアが支配しているエリアのGate Sentryならどこでもよい。ジャグナー森林〔Ｓ〕(G-5)・ブンカール浦〔Ｓ〕(E-7)・バタリア丘陵〔Ｓ〕(F-8)にもいる。 | @東ロンフォール〔Ｓ〕 J-11
g03 talk - | Gate Sentryに話して、すぐ横にReinforcement（補充兵）を出す | 話すと始まり、制限時間は30分。 | @東ロンフォール〔Ｓ〕 J-11 | T npc.東ロンフォール〔Ｓ〕.Gate_Sentry
g04 talk - | Reinforcementに話して、ついてこさせる | 足が遅く、離れすぎたり敵の斥候を見たようなことを言ったりすると勝手に歩き出す。そのときはもう一度話すと戻ってくる。13ヤルムくらいまでなら離れないと書く資料もある。 | @東ロンフォール〔Ｓ〕 | T npc.東ロンフォール〔Ｓ〕.Reinforcement
g05 go - | Reinforcementを連れて、東ロンフォール〔Ｓ〕(H-8)のArlayse, R.K.の前まで行く | モンスターに絡まれなければ戦闘はない。着くと補充兵がひと言しゃべる。 | @東ロンフォール〔Ｓ〕 H-8
g06 talk - | Arlayse, R.K.に話して、経験値をもらう | ほかのエリアから始めたときは、そのエリアの拠点のNPC（ジャグナー森林〔Ｓ〕(I-8)・ブンカール浦〔Ｓ〕(H-10)・バタリア丘陵〔Ｓ〕(J-7)）に話す。バタリア丘陵〔Ｓ〕はJ-8と書く資料もある。 | @東ロンフォール〔Ｓ〕 H-8 | T npc.東ロンフォール〔Ｓ〕.Arlayse_RK
g07 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.009 https://wiki.ffo.jp/html/14056.html
Q Brave Dawn III (S) | 兵士調練 III（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 9
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が黄金剣勲章以上
LK condition:募集要員は3〜6人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Brave_Dawn_III_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Military training、Golden Star §§§§。Allied Ensign（東ロンフォール〔Ｓ〕G-5。Allied Ensign のページも G-5）から常花の石窟。兵士が戦い始め、メッセージが unfocused・training harder・fighting with vigor と変わる。本気になってから倒す。兵士は HP70% 以下で自分でケアル。制限30分。相手は Trained Scorpion。ケアルできるジョブを連れて行く。経験値310・連合軍戦績1020（FFXIclopedia：Rasdinice I-9、3〜6人。Trained Scorpion はとても強く、Death Scissors で1400、範囲技で300〜400。★ごとに経験値559〜668・戦績1599〜1950）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「軍事訓練」から「兵士調練 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | 南サンドリア〔Ｓ〕から東ロンフォール〔Ｓ〕に出て、左の壁にそって北のG-5へ行く | | @東ロンフォール〔Ｓ〕 G-5
g03 talk - | 東ロンフォール〔Ｓ〕(G-5)のAllied Ensignに話して、常花の石窟に入る | リーダーが選ぶと全員が入るので、パーティを近くに集めておく。制限時間は30分。 | @東ロンフォール〔Ｓ〕 G-5 | T npc.東ロンフォール〔Ｓ〕.Allied_Ensign = npc:Allied Ensign@東ロンフォール〔Ｓ〕 G-5
g04 go - | 常花の石窟の中を進んで、兵士と合流する | 兵士（Royal Infantry）はすぐTrained Scorpionに向かって戦い始める。 | @常花の石窟
g05 go - | 兵士がいちばん本気になるまで、兵士を回復して守る | 兵士のようすのメッセージは3段階で変わる（英語版では unfocused、training harder、fighting with vigor）。兵士にプロテスやリジェネはかからないが、ケアルは効く。HPが70%を切ると自分でもケアルする。 | @常花の石窟
g06 fight - | Trained Scorpionを倒して勝つ | 兵士が本気になる前に倒したり、兵士が倒れたりすると失敗。Trained Scorpionはとても強く、兵士に1000以上のダメージを与えることもある。 | @常花の石窟
g07 examine - | Dawn Aureolaを調べて外に出る | 全員に経験値が入る。 | @常花の石窟 | T obj.常花の石窟.Dawn_Aureola = obj:Dawn Aureola@常花の石窟
g08 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.010 https://wiki.ffo.jp/html/14055.html
Q Brave Dawn II (S) | 兵士調練 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 10
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が連合突撃章以上
LK condition:募集要員は3〜6人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Brave_Dawn_II_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Military training、Allied Ribbon of Glory §§§§。Allied Ensign（東ロンフォール〔Ｓ〕G-5。Allied Ensign のページも G-5）から常花の石窟。兵士が戦い始め、メッセージが unfocused・training harder・fighting with vigor と変わる。本気になってから倒す。兵士は HP70% 以下で自分でケアル。制限30分。相手は Trained Bat。報酬の値は書いてない（FFXIclopedia：Rasdinice I-9、3〜6人。Dawn Aureola で出ると全員に経験値210、Rasdinice で戦績820。★ごとに経験値205〜487・戦績822〜1560）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「軍事訓練」から「兵士調練 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | 南サンドリア〔Ｓ〕から東ロンフォール〔Ｓ〕に出て、左の壁にそって北のG-5へ行く | | @東ロンフォール〔Ｓ〕 G-5
g03 talk - | 東ロンフォール〔Ｓ〕(G-5)のAllied Ensignに話して、常花の石窟に入る | リーダーが選ぶと全員が入るので、パーティを近くに集めておく。制限時間は30分。 | @東ロンフォール〔Ｓ〕 G-5 | T npc.東ロンフォール〔Ｓ〕.Allied_Ensign
g04 go - | 常花の石窟の中を進んで、兵士と合流する | 兵士（Royal Infantry）はすぐTrained Batに向かって戦い始める。 | @常花の石窟
g05 go - | 兵士がいちばん本気になるまで、兵士を回復して守る | 兵士のようすのメッセージは3段階で変わる（英語版では unfocused、training harder、fighting with vigor）。兵士にプロテスやリジェネはかからないが、ケアルは効く。HPが70%を切ると自分でもケアルする。 | @常花の石窟
g06 fight - | Trained Batを倒して勝つ | 兵士が本気になる前に倒したり、兵士が倒れたりすると失敗。Trained Batは長くもち、敵対心がよく移る。 | @常花の石窟
g07 examine - | Dawn Aureolaを調べて外に出る | 全員に経験値が入る。 | @常花の石窟 | T obj.常花の石窟.Dawn_Aureola
g08 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.011 https://wiki.ffo.jp/html/14054.html
Q Brave Dawn I (S) | 兵士調練 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 11
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が二級連合従軍章以上
LK condition:募集要員は3〜6人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Brave_Dawn_I_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Military training、Bronze Ribbon of Service §。Allied Ensign（東ロンフォール〔Ｓ〕G-5。Allied Ensign のページも G-5）から常花の石窟。兵士が戦い始め、メッセージが unfocused・training harder・fighting with vigor と変わる。本気になってから倒す。兵士は HP70% 以下で自分でケアル。制限30分。相手は Trained Crab。3人以上はもう要らない。Dawn Aureola から出る。経験値110・連合軍戦績620（FFXIclopedia：Rasdinice I-9、3〜6人。Trained Crab はほとんど兵士をねらう。兵士にプロテス・リジェネはかからず、ケアルは効く。★ごとに経験値205〜289・戦績822〜1158）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「軍事訓練」から「兵士調練 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。3人より少なくても受けられると書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | 南サンドリア〔Ｓ〕から東ロンフォール〔Ｓ〕に出て、左の壁にそって北のG-5へ行く | | @東ロンフォール〔Ｓ〕 G-5
g03 talk - | 東ロンフォール〔Ｓ〕(G-5)のAllied Ensignに話して、常花の石窟に入る | リーダーが選ぶと全員が入るので、パーティを近くに集めておく。制限時間は30分。 | @東ロンフォール〔Ｓ〕 G-5 | T npc.東ロンフォール〔Ｓ〕.Allied_Ensign
g04 go - | 常花の石窟の中を進んで、兵士と合流する | 兵士（Royal Infantry）はすぐTrained Crabに向かって戦い始める。 | @常花の石窟
g05 go - | 兵士がいちばん本気になるまで、兵士を回復して守る | 兵士のようすのメッセージは3段階で変わる（英語版では unfocused、training harder、fighting with vigor）。兵士にプロテスやリジェネはかからないが、ケアルは効く。HPが70%を切ると自分でもケアルする。 | @常花の石窟
g06 fight - | Trained Crabを倒して勝つ | 兵士が本気になる前に倒したり、兵士が倒れたりすると失敗。Trained Crabはほとんど兵士をねらうが、ときどきパーティも攻撃する。 | @常花の石窟
g07 examine - | Dawn Aureolaを調べて外に出る | 全員に経験値が入る。 | @常花の石窟 | T obj.常花の石窟.Dawn_Aureola
g08 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.012 https://wiki.ffo.jp/html/16031.html
Q Plucking Wings (W) | 即身成神討伐（連邦軍） | yes | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
MN - 12
LK quest:過去世界クエスト「コブラ傭兵団入団試験」をクリアして、コブラ傭兵団（連邦軍）に入っている
LK condition:所属軍が連邦軍
LK condition:勲章が一級戦功水晶章以上
LK condition:募集要員は1〜6人（入る人は全員このopsを受けておく）
LK condition:オズトロヤ城〔Ｓ〕を含むサルタバルタ戦線とアラゴーニュ戦線が、全部味方の支配になっている
RW item:ワイズストラップ／ブレイブグリップ
RW item:鴉天狗甲懸／クーフリンベルト／ラウンデルピアス（出ないこともある）
RW item:エンハンスマント・ピースリング・素材・薬品など
RW other:連合軍戦績はもらえない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Plucking_Wings_(W);Emhi Tchaoryo（ウィンダス水の区〔Ｓ〕、このページは H-10。NPC のページは H-9）、Offensive operations、Iron Emblem of Service §§、30分、Lv75。オズトロヤ城〔Ｓ〕がウィンダスの支配のときだけ。NM でないヤグードから Xicu's Rosary（受ける前でも取れる、エリアにいるパーティ全員）。最上階 H-7 の Collapsing Floor から BF。フェイス可、レベル制限なし。Soo Luma the Ascended（学者、睡眠が効かない）と Jii Xai the Rimebladed・Roo Beju the Eulogizer・Zjaa Bao the Wrathherald。倒すのは Soo Luma だけ。お供はすぐまた出る、敵対心は共有。Armoury Crate が出る。Emhi Tchaoryo に戻ると完了（FFXIclopedia：Emhi Tchaoryo H-10。サルタバルタ戦線・アラゴーニュ戦線が全部ウィンダスの支配、1〜6人。最上階 Brass Gate H-7 の Trap Door。全員が受けておく、Xicu's Rosary は入るとなくなる。入ると強化が消える。お供は1分でまた出るので寝かせる、寝かせ続けると耐性。Armoury Crate の中身の表。NPC のページは H-9）
g01 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに話して、指令書「侵攻支援」から「即身成神討伐（連邦軍）」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。BFに入る人は全員受けておく。H-10と書く資料もある。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
g02 go - | オズトロヤ城〔Ｓ〕へ行く | | @オズトロヤ城〔Ｓ〕
g03 defeat - | オズトロヤ城〔Ｓ〕のヤグードを倒して、だいじなもの「シシュの念珠」を手に入れる | NMでないヤグードならどれでもよいが、なかなか出ないこともある。出るとエリアにいるパーティ全員がもらえる。opsを受ける前でも手に入るので、先に持っていないか確かめる。 | @オズトロヤ城〔Ｓ〕
g04 go - | オズトロヤ城〔Ｓ〕の最上階(H-7)のCollapsing Floorへ行く | | @オズトロヤ城〔Ｓ〕 H-7
g05 fight - | Collapsing Floorを調べてBF「即身成神討伐（連邦軍）」に入り、Soo Luma the Ascendedを倒して勝つ | 6人まで・30分。フェイスを呼べる。入ると強化が消え、シシュの念珠はなくなる。戦い始めるとお供のRoo Beju the Eulogizer・Zjaa Bao the Wrathherald・Jii Xai the Rimebladedが出る。お供は倒さなくてよく、倒してもすぐまた出るので寝かせておく（寝かせ続けると効きにくくなる）。Soo Luma the Ascendedは睡眠が効かず、範囲になった精霊魔法を使う。 | @オズトロヤ城〔Ｓ〕 H-7 | T obj.オズトロヤ城〔Ｓ〕.Collapsing_Floor | K シシュの念珠
g06 examine - | 出てきたArmoury Crateを開けて、戦利品をもらう | | @オズトロヤ城〔Ｓ〕
g07 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに報告すると完了 | 連合軍戦績はもらえない。もう一度BFに入るときは、報告してから受け直す。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo

@ mission.campaign.013 https://wiki.ffo.jp/html/14344.html
Q Granite Rose III (S) | 友軍支援 III（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 13
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級戦功水晶章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる。倒された友軍の人数だけ減る）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Granite_Rose_III_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Defensive operations、勲章は Sterling Star §§ と書いてある、30分。バタリア丘陵〔Ｓ〕D-6（マップのいちばん西）の Fortilace から常花の石窟。Orc Stormer 9体、3体ずつ3人の友軍に向かう。全部倒して Dawn Aureola から出る。用語辞典の友軍支援のページ：指令書「防衛支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章、1〜6人（2015.2.19 から）、リーダーだけ受ければよい、友軍 I 1人・II 2人・III 3人、敵は3体1組（FFXIclopedia：Rasdinice I-9、Iron Emblem of Service §§（emblem2）、3〜6人。攻略は書いてない）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「防衛支援」から「友軍支援 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになる。ほかの人は受けなくても入れて経験値ももらえるが、連合軍戦績は受けた人だけ。3人以上要ると書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | バタリア丘陵〔Ｓ〕(D-6)のFortilaceへ行く | D-6の南のはし、マップのいちばん西。サバイバルガイドのワープを使うと近い。 | @バタリア丘陵〔Ｓ〕 D-6
g03 examine - | リーダーがFortilaceを調べて、常花の石窟に入る | 制限時間は30分。中では友軍に強化をかけられないので、強化は入る前にかけておく。 | @バタリア丘陵〔Ｓ〕 D-6 | T obj.84.Fortilace = obj:Fortilace@バタリア丘陵〔Ｓ〕 D-6
g04 go - | 常花の石窟の中で、友軍のNPC（3人）のところへ行く | 友軍は離れた場所にいる。 | @常花の石窟
g05 fight - | 友軍を守りながら、Orcish Stormerを9体とも倒して勝つ | 敵はモンク・ナイト・狩人の3体で1組で、3組来る。プレイヤーには絡まず友軍に向かうので、こちらから釣る（ペットには絡む）。リンクしないので1体ずつ釣れ、睡眠や静寂が効く。友軍にケアルはできる。1人でも残れば成功だが、倒された人数だけ報酬が減る。 | @常花の石窟
g06 examine - | Dawn Aureolaを調べて外に出る |  | @常花の石窟 | T obj.常花の石窟.Dawn_Aureola
g07 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.060 https://wiki.ffo.jp/html/14344.html
Q Granite Rose II (S) | 友軍支援 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 14
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が白銀剣勲章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる。倒された友軍の人数だけ減る）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Granite_Rose_II_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Defensive operations、Sterling Star §§、30分。バタリア丘陵〔Ｓ〕D-6 の Fortilace から常花の石窟。Orc Stormer 6体、3体ずつ2人の友軍に向かう。全部倒して Dawn Aureola から出る。用語辞典の友軍支援のページ：指令書「防衛支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章、1〜6人（2015.2.19 から）、リーダーだけ受ければよい、友軍 I 1人・II 2人・III 3人、敵は3体1組（FFXIclopedia：Rasdinice I-9、star2、3〜6人。D-6 の Fortilace、3体ずつ2組がそれぞれ友軍に向かう。受けていない人は戦績なし）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「防衛支援」から「友軍支援 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになる。ほかの人は受けなくても入れて経験値ももらえるが、連合軍戦績は受けた人だけ。3人以上要ると書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | バタリア丘陵〔Ｓ〕(D-6)のFortilaceへ行く | D-6の南のはし、マップのいちばん西。サバイバルガイドのワープを使うと近い。 | @バタリア丘陵〔Ｓ〕 D-6
g03 examine - | リーダーがFortilaceを調べて、常花の石窟に入る | 制限時間は30分。中では友軍に強化をかけられないので、強化は入る前にかけておく。 | @バタリア丘陵〔Ｓ〕 D-6 | T obj.84.Fortilace
g04 go - | 常花の石窟の中で、友軍のNPC（2人）のところへ行く | 友軍は離れた場所にいる。 | @常花の石窟
g05 fight - | 友軍を守りながら、Orcish Stormerを6体とも倒して勝つ | 敵はモンク・ナイト・狩人の3体で1組で、2組来る。プレイヤーには絡まず友軍に向かうので、こちらから釣る（ペットには絡む）。リンクしないので1体ずつ釣れ、睡眠や静寂が効く。友軍にケアルはできる。1人でも残れば成功だが、倒された人数だけ報酬が減る。 | @常花の石窟
g06 examine - | Dawn Aureolaを調べて外に出る |  | @常花の石窟 | T obj.常花の石窟.Dawn_Aureola
g07 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.061 https://wiki.ffo.jp/html/14344.html
Q Granite Rose I (S) | 友軍支援 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 15
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級連合従軍章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Granite_Rose_I_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Defensive operations、Brass Ribbon of Service §§、30分、経験値170・連合軍戦績640。バタリア丘陵〔Ｓ〕D-6（マップのいちばん西、サバイバルガイド）の Fortilace から常花の石窟。Orc Stormer 3体（RNG・PLD・WAR）、睡眠が効く、HP 1800ほど。Dawn Aureola から出る。用語辞典の友軍支援のページ：指令書「防衛支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章、1〜6人（2015.2.19 から）、リーダーだけ受ければよい、友軍 I 1人・II 2人・III 3人、敵は3体1組（FFXIclopedia：Rasdinice I-9、ribbon2、3〜6人。D-6 の南側の Fortilace。Orcish Stormer 3体（PLD・RNG・MNK）。★ごとに経験値170〜390・戦績640〜1365）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「防衛支援」から「友軍支援 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになる。ほかの人は受けなくても入れて経験値ももらえるが、連合軍戦績は受けた人だけ。3人以上要ると書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | バタリア丘陵〔Ｓ〕(D-6)のFortilaceへ行く | D-6の南のはし、マップのいちばん西。サバイバルガイドのワープを使うと近い。 | @バタリア丘陵〔Ｓ〕 D-6
g03 examine - | リーダーがFortilaceを調べて、常花の石窟に入る | 制限時間は30分。中では友軍に強化をかけられないので、強化は入る前にかけておく。 | @バタリア丘陵〔Ｓ〕 D-6 | T obj.84.Fortilace
g04 go - | 常花の石窟の中で、友軍のNPCのところへ行く |  | @常花の石窟
g05 fight - | 友軍を守りながら、Orcish Stormerを3体とも倒して勝つ | 敵はモンク・ナイト・狩人の3体で1組。プレイヤーには絡まず友軍に向かうので、こちらから釣る（ペットには絡む）。リンクしないので1体ずつ釣れ、睡眠や静寂が効く。友軍にケアルはできる。友軍が全員倒されると失敗。戦士がいると書く資料もある。HPは1体1800ほど。 | @常花の石窟
g06 examine - | Dawn Aureolaを調べて外に出る |  | @常花の石窟 | T obj.常花の石窟.Dawn_Aureola
g07 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.062 https://wiki.ffo.jp/html/14344.html
Q Granite Rose III (B) | 友軍支援 III（共和国軍） | yes | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
MN - 16
LK quest:過去世界クエスト「第四共和軍団入団試験」をクリアして、第四共和軍団（共和国軍）に入っている
LK condition:所属軍が共和国軍
LK condition:勲章が一級戦功水晶章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる。倒された友軍の人数だけ減る）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Granite_Rose_III_(B);Hieronymus（バストゥーク商業区〔Ｓ〕E-8）、Defensive operations、Iron Emblem of Service §§、30分。ロランベリー耕地〔Ｓ〕D-9 の Fortilace からルホッツ銀山。Quadav 3体ずつ3組、HP が少なく睡眠が効く。Dawn Aureola から出ないと失敗（デジョンしない）。用語辞典の友軍支援のページ：指令書「防衛支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章、1〜6人（2015.2.19 から）、リーダーだけ受ければよい、友軍 I 1人・II 2人・III 3人、敵は3体1組（FFXIclopedia：Hieronymus E-8、emblem2、3〜6人。まっすぐ進むと友軍、9体が3体ずつ3回来る（WHM・PLD・WAR）。2回目と3回目はすぐ続く）
g01 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに話して、指令書「防衛支援」から「友軍支援 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになる。ほかの人は受けなくても入れて経験値ももらえるが、連合軍戦績は受けた人だけ。3人以上要ると書く資料もある。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
g02 go - | ロランベリー耕地〔Ｓ〕(D-9)のFortilaceへ行く |  | @ロランベリー耕地〔Ｓ〕 D-9
g03 examine - | リーダーがFortilaceを調べて、ルホッツ銀山に入る | 制限時間は30分。中では友軍に強化をかけられないので、強化は入る前にかけておく。 | @ロランベリー耕地〔Ｓ〕 D-9 | T obj.91.Fortilace = obj:Fortilace@ロランベリー耕地〔Ｓ〕 D-9
g04 go - | ルホッツ銀山の中で、友軍のNPC（3人）のところへ行く |  | @ルホッツ銀山
g05 fight - | 友軍を守りながら、Quadav Stormerを9体とも倒して勝つ | 敵は戦士・白魔道士・暗黒騎士（ナイトと書く資料もある）の3体で1組で、3組来る。プレイヤーには絡まず友軍に向かうので、こちらから釣る（ペットには絡む）。リンクしないので1体ずつ釣れ、睡眠や静寂が効く。友軍にケアルはできる。1人でも残れば成功だが、倒された人数だけ報酬が減る。2組目と3組目はほとんど間をあけずに来るので、睡眠やペットで止めておく。 | @ルホッツ銀山
g06 examine - | Dawn Aureolaを調べて外に出る | 調べないで外に出る（デジョンなど）と失敗になる。 | @ルホッツ銀山 | T obj.ルホッツ銀山.Dawn_Aureola = obj:Dawn Aureola@ルホッツ銀山
g07 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus

@ mission.campaign.063 https://wiki.ffo.jp/html/14344.html
Q Granite Rose II (B) | 友軍支援 II（共和国軍） | yes | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
MN - 17
LK quest:過去世界クエスト「第四共和軍団入団試験」をクリアして、第四共和軍団（共和国軍）に入っている
LK condition:所属軍が共和国軍
LK condition:勲章が白銀剣勲章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる。倒された友軍の人数だけ減る）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Granite_Rose_II_(B);Hieronymus（バストゥーク商業区〔Ｓ〕E-8）、Defensive operations、Sterling Star §§、30分。ロランベリー耕地〔Ｓ〕D-9 の Fortilace からルホッツ銀山。Quadav 3体ずつ2組、睡眠が効く。Dawn Aureola から出ないと失敗。用語辞典の友軍支援のページ：指令書「防衛支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章、1〜6人（2015.2.19 から）、リーダーだけ受ければよい、友軍 I 1人・II 2人・III 3人、敵は3体1組（FFXIclopedia：Hieronymus E-8、star2、3〜6人。まっすぐ進むと友軍、3体のあと数分で2組目が同じ道を来る（WHM・PLD・WAR））
g01 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに話して、指令書「防衛支援」から「友軍支援 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになる。ほかの人は受けなくても入れて経験値ももらえるが、連合軍戦績は受けた人だけ。3人以上要ると書く資料もある。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
g02 go - | ロランベリー耕地〔Ｓ〕(D-9)のFortilaceへ行く |  | @ロランベリー耕地〔Ｓ〕 D-9
g03 examine - | リーダーがFortilaceを調べて、ルホッツ銀山に入る | 制限時間は30分。中では友軍に強化をかけられないので、強化は入る前にかけておく。 | @ロランベリー耕地〔Ｓ〕 D-9 | T obj.91.Fortilace
g04 go - | ルホッツ銀山の中で、友軍のNPC（2人）のところへ行く |  | @ルホッツ銀山
g05 fight - | 友軍を守りながら、Quadav Stormerを6体とも倒して勝つ | 敵は戦士・白魔道士・暗黒騎士（ナイトと書く資料もある）の3体で1組で、2組来る。プレイヤーには絡まず友軍に向かうので、こちらから釣る（ペットには絡む）。リンクしないので1体ずつ釣れ、睡眠や静寂が効く。友軍にケアルはできる。1人でも残れば成功だが、倒された人数だけ報酬が減る。2組目は少したってから同じ道を来る。 | @ルホッツ銀山
g06 examine - | Dawn Aureolaを調べて外に出る | 調べないで外に出る（デジョンなど）と失敗になる。 | @ルホッツ銀山 | T obj.ルホッツ銀山.Dawn_Aureola
g07 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus

@ mission.campaign.064 https://wiki.ffo.jp/html/14344.html
Q Granite Rose I (B) | 友軍支援 I（共和国軍） | yes | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
MN - 18
LK quest:過去世界クエスト「第四共和軍団入団試験」をクリアして、第四共和軍団（共和国軍）に入っている
LK condition:所属軍が共和国軍
LK condition:勲章が一級連合従軍章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Granite_Rose_I_(B);Hieronymus（バストゥーク商業区〔Ｓ〕E-8）、Defensive operations、Brass Ribbon of Service §§、30分、経験値170・連合軍戦績640。ロランベリー耕地〔Ｓ〕D-9 の Fortilace からルホッツ銀山。Quadav 3体、睡眠が効き HP が少ない。Dawn Aureola から出ないと失敗。用語辞典の友軍支援のページ：指令書「防衛支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章、1〜6人（2015.2.19 から）、リーダーだけ受ければよい、友軍 I 1人・II 2人・III 3人、敵は3体1組（FFXIclopedia：Hieronymus E-8、ribbon2、3〜6人、30分。まっすぐ進むと友軍、待つと Quadav Stormer 3体（WHM・PLD・DRK・WAR）。★ごとに経験値170〜390・戦績640〜1365）
g01 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに話して、指令書「防衛支援」から「友軍支援 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになる。ほかの人は受けなくても入れて経験値ももらえるが、連合軍戦績は受けた人だけ。3人以上要ると書く資料もある。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
g02 go - | ロランベリー耕地〔Ｓ〕(D-9)のFortilaceへ行く |  | @ロランベリー耕地〔Ｓ〕 D-9
g03 examine - | リーダーがFortilaceを調べて、ルホッツ銀山に入る | 制限時間は30分。中では友軍に強化をかけられないので、強化は入る前にかけておく。 | @ロランベリー耕地〔Ｓ〕 D-9 | T obj.91.Fortilace
g04 go - | ルホッツ銀山の中で、友軍のNPCのところへ行く | 入ったらまっすぐ進むと友軍がいる。そこで待つと敵が来る。 | @ルホッツ銀山
g05 fight - | 友軍を守りながら、Quadav Stormerを3体とも倒して勝つ | 敵は戦士・白魔道士・暗黒騎士（ナイトと書く資料もある）の3体で1組。プレイヤーには絡まず友軍に向かうので、こちらから釣る（ペットには絡む）。リンクしないので1体ずつ釣れ、睡眠や静寂が効く。友軍にケアルはできる。友軍が全員倒されると失敗。HPが少ない。 | @ルホッツ銀山
g06 examine - | Dawn Aureolaを調べて外に出る | 調べないで外に出る（デジョンなど）と失敗になる。 | @ルホッツ銀山 | T obj.ルホッツ銀山.Dawn_Aureola
g07 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus

@ mission.campaign.065 https://wiki.ffo.jp/html/14344.html
Q Granite Rose III (W) | 友軍支援 III（連邦軍） | yes | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
MN - 19
LK quest:過去世界クエスト「コブラ傭兵団入団試験」をクリアして、コブラ傭兵団（連邦軍）に入っている
LK condition:所属軍が連邦軍
LK condition:勲章が一級戦功水晶章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる。倒された友軍の人数だけ減る）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Granite_Rose_III_(W);Emhi Tchaoryo（ウィンダス水の区〔Ｓ〕H-9）、Defensive operations、Iron Emblem of Service §§、1〜6人、30分。ソロムグ原野〔Ｓ〕L-9 の Fortilace からゴユの空洞。Yagudo Stormer 9体。入る前の強化は残る。Dawn Aureola から出る。リーダーだけ受ければよい。用語辞典の友軍支援のページ：指令書「防衛支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章、1〜6人（2015.2.19 から）、リーダーだけ受ければよい、友軍 I 1人・II 2人・III 3人、敵は3体1組（FFXIclopedia：Emhi Tchaoryo H-9、emblem2、3〜6人。L-8 の上の坂から。3体ずつ3回（BLM・NIN・SAM）。Dawn Aureola の近くにいないと経験値なし）
g01 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに話して、指令書「防衛支援」から「友軍支援 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになる。ほかの人は受けなくても入れて経験値ももらえるが、連合軍戦績は受けた人だけ。3人以上要ると書く資料もある。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
g02 go - | ソロムグ原野〔Ｓ〕(L-9)のFortilaceへ行く | L-8の上の坂から行く。 | @ソロムグ原野〔Ｓ〕 L-9
g03 examine - | リーダーがFortilaceを調べて、ゴユの空洞に入る | 制限時間は30分。中では友軍に強化をかけられないので、強化は入る前にかけておく。 | @ソロムグ原野〔Ｓ〕 L-9 | T obj.98.Fortilace = obj:Fortilace@ソロムグ原野〔Ｓ〕 L-9
g04 go - | ゴユの空洞の中で、友軍のNPC（3人）のところへ行く |  | @ゴユの空洞
g05 fight - | 友軍を守りながら、Yagudo Stormerを9体とも倒して勝つ | 敵は黒魔道士・侍・忍者の3体で1組で、3組来る。プレイヤーには絡まず友軍に向かうので、こちらから釣る（ペットには絡む）。リンクしないので1体ずつ釣れ、睡眠や静寂が効く。友軍にケアルはできる。1人でも残れば成功だが、倒された人数だけ報酬が減る。敵は3組が順に来る。 | @ゴユの空洞
g06 examine - | Dawn Aureolaを調べて外に出る | Dawn Aureolaから離れていると経験値が入らない。 | @ゴユの空洞 | T obj.ゴユの空洞.Dawn_Aureola = obj:Dawn Aureola@ゴユの空洞
g07 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo

@ mission.campaign.066 https://wiki.ffo.jp/html/14344.html
Q Granite Rose II (W) | 友軍支援 II（連邦軍） | yes | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
MN - 20
LK quest:過去世界クエスト「コブラ傭兵団入団試験」をクリアして、コブラ傭兵団（連邦軍）に入っている
LK condition:所属軍が連邦軍
LK condition:勲章が白銀剣勲章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる。倒された友軍の人数だけ減る）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Granite_Rose_II_(W);Emhi Tchaoryo（ウィンダス水の区〔Ｓ〕H-9）、Defensive operations、Sterling Star §§、1〜6人。ソロムグ原野〔Ｓ〕L-9 の Fortilace からゴユの空洞、30分。友軍は2人（入った先と、その西）。Yagudo Stormer 6体が北から、3体ずつ友軍に向かう。Dawn Aureola から出る。用語辞典の友軍支援のページ：指令書「防衛支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章、1〜6人（2015.2.19 から）、リーダーだけ受ければよい、友軍 I 1人・II 2人・III 3人、敵は3体1組（FFXIclopedia：Emhi Tchaoryo H-9、star2、3〜6人。L-8 の上の坂。友軍は Dawn Aureola の先の大部屋と、その西の通路。友軍が倒されると経験値・戦績が減る）
g01 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに話して、指令書「防衛支援」から「友軍支援 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになる。ほかの人は受けなくても入れて経験値ももらえるが、連合軍戦績は受けた人だけ。3人以上要ると書く資料もある。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
g02 go - | ソロムグ原野〔Ｓ〕(L-9)のFortilaceへ行く | L-8の上の坂から行く。 | @ソロムグ原野〔Ｓ〕 L-9
g03 examine - | リーダーがFortilaceを調べて、ゴユの空洞に入る | 制限時間は30分。中では友軍に強化をかけられないので、強化は入る前にかけておく。 | @ソロムグ原野〔Ｓ〕 L-9 | T obj.98.Fortilace
g04 go - | ゴユの空洞の中で、友軍のNPC（2人）のところへ行く | 1人は入ってすぐ先（Dawn Aureolaの先の大部屋）、もう1人はその西の通路にいる。 | @ゴユの空洞
g05 fight - | 友軍を守りながら、Yagudo Stormerを6体とも倒して勝つ | 敵は黒魔道士・侍・忍者の3体で1組で、2組来る。プレイヤーには絡まず友軍に向かうので、こちらから釣る（ペットには絡む）。リンクしないので1体ずつ釣れ、睡眠や静寂が効く。友軍にケアルはできる。1人でも残れば成功だが、倒された人数だけ報酬が減る。敵は北から来て、3体ずつそれぞれの友軍に向かう。 | @ゴユの空洞
g06 examine - | Dawn Aureolaを調べて外に出る | Dawn Aureolaから離れていると経験値が入らない。 | @ゴユの空洞 | T obj.ゴユの空洞.Dawn_Aureola
g07 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo

@ mission.campaign.067 https://wiki.ffo.jp/html/14344.html
Q Granite Rose I (W) | 友軍支援 I（連邦軍） | yes | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
MN - 21
LK quest:過去世界クエスト「コブラ傭兵団入団試験」をクリアして、コブラ傭兵団（連邦軍）に入っている
LK condition:所属軍が連邦軍
LK condition:勲章が一級連合従軍章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Granite_Rose_I_(W);Emhi Tchaoryo（ウィンダス水の区〔Ｓ〕H-9）、Defensive operations、Brass Ribbon of Service §§、3〜6人、30分、経験値170・連合軍戦績640。ソロムグ原野〔Ｓ〕L-9 の Fortilace（BG Wiki は Fortilice と書く）からゴユの空洞。Yagudo 3体。入る前の強化は残る。Dawn Aureola から出る。リーダーだけ受ければよい。用語辞典の友軍支援のページ：指令書「防衛支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章、1〜6人（2015.2.19 から）、リーダーだけ受ければよい、友軍 I 1人・II 2人・III 3人、敵は3体1組（FFXIclopedia：Emhi Tchaoryo H-9、ribbon2、1〜6人。L-8 の上の坂。まっすぐ進むと友軍、待つと Yagudo Stormer 3体（BLM・SAM・NIN）。Dawn Aureola の近くにいないと経験値なし。★ごとに経験値170〜390・戦績640〜1365）
g01 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに話して、指令書「防衛支援」から「友軍支援 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになる。ほかの人は受けなくても入れて経験値ももらえるが、連合軍戦績は受けた人だけ。3人以上要ると書く資料もある。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
g02 go - | ソロムグ原野〔Ｓ〕(L-9)のFortilaceへ行く | L-8の上の坂から行く。 | @ソロムグ原野〔Ｓ〕 L-9
g03 examine - | リーダーがFortilaceを調べて、ゴユの空洞に入る | 制限時間は30分。中では友軍に強化をかけられないので、強化は入る前にかけておく。 | @ソロムグ原野〔Ｓ〕 L-9 | T obj.98.Fortilace
g04 go - | ゴユの空洞の中で、友軍のNPCのところへ行く | 入ったらまっすぐ進むと友軍がいる。そこで待つと敵が来る。 | @ゴユの空洞
g05 fight - | 友軍を守りながら、Yagudo Stormerを3体とも倒して勝つ | 敵は黒魔道士・侍・忍者の3体で1組。プレイヤーには絡まず友軍に向かうので、こちらから釣る（ペットには絡む）。リンクしないので1体ずつ釣れ、睡眠や静寂が効く。友軍にケアルはできる。友軍が全員倒されると失敗。とても弱い。 | @ゴユの空洞
g06 examine - | Dawn Aureolaを調べて外に出る | Dawn Aureolaから離れていると経験値が入らない。 | @ゴユの空洞 | T obj.ゴユの空洞.Dawn_Aureola
g07 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo

@ mission.campaign.014 https://wiki.ffo.jp/html/14080.html
Q Delta Strike III (S) | 巡回任務 III（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 22
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級戦功水晶章以上
LK condition:募集要員は1〜6人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Delta_Strike_III_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Security、Iron Emblem of Service §§、Lv70以上。東ロンフォール〔Ｓ〕K-5 の南西のすみの ???。Goblin Picaroon 3体（WAR・RDM・RNG）。倒してもう一度 ??? で経験値。経験値4095・連合軍戦績5265。Goblin Picaroon のページ：東ロンフォール〔Ｓ〕の NM、HP 9500ほど（FFXIclopedia の Goblin Picaroon のページ：5分で再出現、10〜20分で強くなる（要確認）、1分だれも戦わないと消えて失敗）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「治安維持」から「巡回任務 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。1人用と書く資料もある。東ロンフォール〔Ｓ〕がサンドリアの支配でないと受けられないと書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | 東ロンフォール〔Ｓ〕(K-5)の???のところへ行く | K-5の南西のすみ。 | @東ロンフォール〔Ｓ〕 K-5
g03 examine - | ???を調べて、3体のGoblin Picaroonを出す | Goblin Picaroonは3体（戦士・赤魔道士・狩人）出る。1分ほどだれも戦わないと消えて失敗する。 | @東ロンフォール〔Ｓ〕 K-5 | T obj.81.???_K-5 = obj:???@東ロンフォール〔Ｓ〕 K-5
g04 defeat - | Goblin Picaroonを3体とも倒す | 10〜20分たつと強くなると書く資料もある。 | @東ロンフォール〔Ｓ〕 K-5 | T mob.81.Goblin_Picaroon = mob:Goblin Picaroon@東ロンフォール〔Ｓ〕
g05 examine - | もう一度???を調べて、経験値をもらう | 調べないで報告すると失敗になる。手伝った人も調べると経験値がもらえる。 | @東ロンフォール〔Ｓ〕 K-5 | T obj.81.???_K-5
g06 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.015 https://wiki.ffo.jp/html/14079.html
Q Delta Strike II (S) | 巡回任務 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 23
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が白銀剣勲章以上
LK condition:募集要員は1〜6人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Delta_Strike_II_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Security、Sterling Star §§、Lv70以上。東ロンフォール〔Ｓ〕I-5 の道の上の ???。Goblin Picaroon 2体。倒してもう一度 ??? で経験値160。連合軍戦績620（FFXIclopedia：Rasdinice I-9、1人、東ロンフォール〔Ｓ〕がサンドリアの支配。I-5 の ???、Goblin Picaroon 2体（WHM・BLM、名前は同じ）。片方を引き離すと消えて失敗。10〜20分で強くなる。手伝った人も ??? で経験値、戦績は受けた人だけ。★ごとに経験値260〜491・戦績820〜1475）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「治安維持」から「巡回任務 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。1人用と書く資料もある。東ロンフォール〔Ｓ〕がサンドリアの支配でないと受けられないと書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | 東ロンフォール〔Ｓ〕(I-5)の???のところへ行く | 道の上。 | @東ロンフォール〔Ｓ〕 I-5
g03 examine - | ???を調べて、2体のGoblin Picaroonを出す | Goblin Picaroonは2体（白魔道士と黒魔道士、名前は同じ）出る。1分ほどだれも戦わないと消えて失敗する。 | @東ロンフォール〔Ｓ〕 I-5 | T obj.81.???_I-5 = obj:???@東ロンフォール〔Ｓ〕 I-5
g04 defeat - | Goblin Picaroonを2体とも倒す | 片方だけ引き離すと消えて失敗する。10〜20分たつと強くなる。 | @東ロンフォール〔Ｓ〕 I-5 | T mob.81.Goblin_Picaroon
g05 examine - | もう一度???を調べて、経験値をもらう | 調べないで報告すると失敗になる。手伝った人も調べると経験値がもらえる。 | @東ロンフォール〔Ｓ〕 I-5 | T obj.81.???_I-5
g06 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.016 https://wiki.ffo.jp/html/14078.html
Q Delta Strike I (S) | 巡回任務 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 24
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級連合従軍章以上
LK condition:募集要員は1〜6人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Delta_Strike_I_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Security、Brass Ribbon of Service §§、Lv70以上。東ロンフォール〔Ｓ〕H-7 の ???。Goblin Picaroon を倒してもう一度 ??? で経験値160。連合軍戦績620（FFXIclopedia：Rasdinice I-9、1人、東ロンフォール〔Ｓ〕がサンドリアの支配。H-7 のまん中の大きな木のそばの ???。HP 8000〜10000 のシーフ、20%以下で強くなる、15分ほどで再出現。手伝った人も経験値。★ごとに経験値221〜321・戦績773〜1124）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「治安維持」から「巡回任務 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。1人用と書く資料もある。東ロンフォール〔Ｓ〕がサンドリアの支配でないと受けられないと書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | 東ロンフォール〔Ｓ〕(H-7)の???のところへ行く | まん中の大きな木のそば。 | @東ロンフォール〔Ｓ〕 H-7
g03 examine - | ???を調べて、Goblin Picaroonを出す | 倒されたあとはしばらく出ない。1分ほどだれも戦わないと消えて失敗する。 | @東ロンフォール〔Ｓ〕 H-7 | T obj.81.???_H-7 = obj:???@東ロンフォール〔Ｓ〕 H-7
g04 defeat - | Goblin Picaroonを倒す | HPが20%を切ると命中・攻撃・防御・回避が上がる。ほかの人と一緒に倒してもよい。 | @東ロンフォール〔Ｓ〕 H-7 | T mob.81.Goblin_Picaroon
g05 examine - | もう一度???を調べて、経験値をもらう | 調べないで報告すると失敗になる。手伝った人も調べると経験値がもらえる。 | @東ロンフォール〔Ｓ〕 H-7 | T obj.81.???_H-7
g06 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.017 https://wiki.ffo.jp/html/16582.html
Q Stock and Awe III (B) | 戦略物資収集 III（共和国軍） | yes | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
MN - 25
LK quest:過去世界クエスト「第四共和軍団入団試験」をクリアして、第四共和軍団（共和国軍）に入っている
LK condition:所属軍が共和国軍
LK condition:勲章が黄金剣勲章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Stock_and_Awe_III_(B);Hieronymus（バストゥーク商業区〔Ｓ〕E-8）、Resource procurement、1人。Quartermaster H-9 がグロウベルグ〔Ｓ〕で収穫してこいと言う。Lesser Chigoe・Red Moko Grass・Burdock Root 各1。自分で収穫すると Supply Order。時間制限があるかは不明。経験値290・戦績880。勲章は Golden Star §§§§（star4）（FFXIclopedia も同じ）。用語辞典の戦略物資収集のページ：「黄金剣勲章 所持で受領可能」。（FFXIclopedia：Hieronymus E-8、Quartermaster H-9、Lesser Chigoe・Burdock・Red Moko Grass 各1。Supply Order は自分で取ったときだけで、なくてよい。★ごとに経験値344〜472・戦績985〜1350）
g01 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに話して、指令書「物資確保」から「戦略物資収集 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
g02 talk - | バストゥーク商業区〔Ｓ〕(H-9)のQuartermasterに話して、集める品を聞く | 次のどれかを言われる：レッサーチゴー1個・バードック1個・赤モコ草1個。 | @バストゥーク商業区〔Ｓ〕 H-9 | T npc.バストゥーク商業区〔Ｓ〕.Quartermaster = npc:Quartermaster@バストゥーク商業区〔Ｓ〕 H-9
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。3つともグロウベルグ〔Ｓ〕で収穫できる。レッサーチゴーはチョコボ掘りやモグガーデンの木立、バードックは西サルタバルタ〔Ｓ〕の収穫やモグガーデンの畑でも取れる。赤モコ草は競売に多い。自分で収穫・採掘・伐採したり敵から取ったりすると、だいじなもの「Supply Order」が入ると書く資料もあるが、なくても完了できる。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @バストゥーク商業区〔Ｓ〕 H-9 | T npc.バストゥーク商業区〔Ｓ〕.Quartermaster
g05 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに報告して、連合軍戦績をもらうと完了 | - | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus

@ mission.campaign.018 https://wiki.ffo.jp/html/14059.html
Q Stock and Awe III (S) | 戦略物資収集 III（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 26
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が黄金剣勲章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Stock_and_Awe_III_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Resource procurement、1人。Quartermaster は I-9（Rasdinice の向かいのテントのそば）。Willow Log・Walnut Log・Walnut。経験値290・戦績880。勲章は Golden Star §§§§（star4）（FFXIclopedia も同じ）。用語辞典の戦略物資収集のページ：「黄金剣勲章 所持で受領可能」。（FFXIclopedia：Rasdinice I-9、Quartermaster H-9、Walnut・Walnut Log・Willow Log 各1。★ごとに経験値316〜469・戦績904〜1341）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「物資確保」から「戦略物資収集 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(H-9)のQuartermasterに話して、集める品を聞く | 次のどれかを言われる：胡桃1個・ウィロー原木1個・ウォルナット原木1個。場所をI-9と書く資料もある。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster = npc:Quartermaster@南サンドリア〔Ｓ〕 H-9
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。胡桃は競売に少なく、東ロンフォール〔Ｓ〕やジャグナー森林〔Ｓ〕の伐採で取ることが多い。原木は木工ギルドなどで買える。自分で収穫・採掘・伐採したり敵から取ったりすると、だいじなもの「Supply Order」が入ると書く資料もあるが、なくても完了できる。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.019 https://wiki.ffo.jp/html/14611.html
Q Stock and Awe III (W) | 戦略物資収集 III（連邦軍） | yes | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
MN - 27
LK quest:過去世界クエスト「コブラ傭兵団入団試験」をクリアして、コブラ傭兵団（連邦軍）に入っている
LK condition:所属軍が連邦軍
LK condition:勲章が黄金剣勲章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Stock_and_Awe_III_(W);Emhi Tchaoryo（ウィンダス水の区〔Ｓ〕H-9）、Resource procurement、1人。Quartermaster F-9。Nopales・Dragon Fruit・Holy Water 各1。経験値290・戦績880。勲章は Golden Star §§§§（star4）（FFXIclopedia も同じ）。用語辞典の戦略物資収集のページ：「黄金剣勲章 所持で受領可能」。（FFXIclopedia：Emhi Tchaoryo H-9、Quartermaster F-9（北）、Dragon Fruit・Holy Water・Nopales 各1。★ごとに経験値290〜469・戦績880〜1341）
g01 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに話して、指令書「物資確保」から「戦略物資収集 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
g02 talk - | ウィンダス水の区〔Ｓ〕北(F-9)のQuartermasterに話して、集める品を聞く | 次のどれかを言われる：ドラゴンフルーツ1個・ノパル1個・聖水1個。 | @ウィンダス水の区〔Ｓ〕 F-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Quartermaster = npc:Quartermaster@ウィンダス水の区〔Ｓ〕 F-9 #1
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。Quartermasterはカルゴナルゴ城砦で伐採してこいと言う。ドラゴンフルーツとノパルはカルゴナルゴ城砦〔Ｓ〕でしか取れず、競売にもほとんど出ない。自分で収穫・採掘・伐採したり敵から取ったりすると、だいじなもの「Supply Order」が入ると書く資料もあるが、なくても完了できる。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @ウィンダス水の区〔Ｓ〕 F-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Quartermaster
g05 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに報告して、連合軍戦績をもらうと完了 | - | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo

@ mission.campaign.020 https://wiki.ffo.jp/html/15366.html
Q Stock and Awe II (B) | 戦略物資収集 II（共和国軍） | yes | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
MN - 28
LK quest:過去世界クエスト「第四共和軍団入団試験」をクリアして、第四共和軍団（共和国軍）に入っている
LK condition:所属軍が共和国軍
LK condition:勲章が連合突撃章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Stock_and_Awe_II_(B);Hieronymus（バストゥーク商業区〔Ｓ〕E-8）、Resource procurement、1人。Quartermaster H-9。Quadav Chestplate・Goblin Mess Tin・Wyvern Wing・Wivre Horn・Peiste Skin・Slug Eye・Cotton Cloth・Giant Sheep Meat x3・Rock Salt x3・Flint Stone x12・Spider Web・Revival Root・Malboro Vine・Beehive Chip x2。経験値190・戦績680。勲章は Allied Ribbon of Glory §§§§（ribbon4）（FFXIclopedia も同じ）。用語辞典の戦略物資収集のページ：「連合突撃章 所持で受領可能」。（FFXIclopedia：Hieronymus E-8、Quartermaster H-9。用語辞典の8品のほか Goblin Mess Tin・Heavy Quadav Backplate／Chestplate・Peiste Skin／Stinger・Speed Apple x4・Slug Eye・Wivre Horn・Wyvern Wing。★5で経験値1050・戦績1500ほど）
g01 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに話して、指令書「物資確保」から「戦略物資収集 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
g02 talk - | バストゥーク商業区〔Ｓ〕(H-9)のQuartermasterに話して、集める品を聞く | 次のどれかを言われる：蜂の巣のかけら2個・蜘蛛の網1個・火打石12個・反魂樹の根1個・大羊の肉3個・モルボルのつる1個・岩塩3個・木綿布1枚。ほかの品を書く資料もある。 | @バストゥーク商業区〔Ｓ〕 H-9 | T npc.バストゥーク商業区〔Ｓ〕.Quartermaster
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。蜘蛛の網はスタックできないが、北グスタベルグ〔Ｓ〕に出てすぐの場所に蜘蛛が多い。火打石は12個要る。自分で収穫・採掘・伐採したり敵から取ったりすると、だいじなもの「Supply Order」が入ると書く資料もあるが、なくても完了できる。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @バストゥーク商業区〔Ｓ〕 H-9 | T npc.バストゥーク商業区〔Ｓ〕.Quartermaster
g05 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに報告して、連合軍戦績をもらうと完了 | - | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus

@ mission.campaign.021 https://wiki.ffo.jp/html/14058.html
Q Stock and Awe II (S) | 戦略物資収集 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 29
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が連合突撃章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Stock_and_Awe_II_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Resource procurement、1人。Quartermaster は I-9。用語辞典の8品のほか Gnole Claw・Orc Helm・Ladybug Wing x4。経験値190・戦績680。勲章は Allied Ribbon of Glory §§§§（ribbon4）（FFXIclopedia も同じ）。用語辞典の戦略物資収集のページ：「連合突撃章 所持で受領可能」。（FFXIclopedia：Rasdinice I-9、Quartermaster H-9。用語辞典の8品のほか Agaricus Mushroom・Djinn Ash・Gnole Claw・Ladybug Wing x4・Orc Helmet・Smilodon Hide・Smilodon Liver。★ごとに経験値226〜327・戦績723〜1047）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「物資確保」から「戦略物資収集 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(H-9)のQuartermasterに話して、集める品を聞く | 次のどれかを言われる：陸魚の鱗1枚・大羊の毛皮1枚・コリブリの嘴1個・甲虫のアゴ1個・フライトラップの葉1個・宿木1個・野兎の毛皮1枚・木霊の根1個。ほかの品を書く資料もある。場所をI-9と書く資料もある。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。宿木は少し高い。フライトラップの葉は競売にほとんど出ない。自分で収穫・採掘・伐採したり敵から取ったりすると、だいじなもの「Supply Order」が入ると書く資料もあるが、なくても完了できる。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.022 https://wiki.ffo.jp/html/18156.html
Q Stock and Awe II (W) | 戦略物資収集 II（連邦軍） | yes | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
MN - 30
LK quest:過去世界クエスト「コブラ傭兵団入団試験」をクリアして、コブラ傭兵団（連邦軍）に入っている
LK condition:所属軍が連邦軍
LK condition:勲章が連合突撃章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Stock_and_Awe_II_(W);Emhi Tchaoryo（ウィンダス水の区〔Ｓ〕H-9）、Resource procurement、1人。Quartermaster F-9。用語辞典の8品のほか Dhalmel Hair・Yagudo Kote・Gnat Wing x4・Rafflesia Petal・Lynx Hide（どれも要確認の印つき）。経験値190・戦績680。勲章は Allied Ribbon of Glory §§§§（ribbon4）（FFXIclopedia も同じ）。用語辞典の戦略物資収集のページ：「連合突撃章 所持で受領可能」。（FFXIclopedia：Emhi Tchaoryo H-9、Quartermaster F-9。用語辞典の8品のほか Dhalmel Hair・Gnat Wing x4・Ice Crystal x12・Lynx Hide・Lynx Meat・Rafflesia Petal・Rafflesia Vine・Yagudo Kote。★ごとに経験値190〜333・戦績680〜1065）
g01 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに話して、指令書「物資確保」から「戦略物資収集 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
g02 talk - | ウィンダス水の区〔Ｓ〕北(F-9)のQuartermasterに話して、集める品を聞く | 次のどれかを言われる：大鳥の羽根1枚・大サソリの爪1個・巨大な大腿骨1個・虫の翅12枚・ラプトルの皮1個・トレントの球根3個・野兎の尻尾1個・リコポディウムの花1個。ほかの品を書く資料もある。 | @ウィンダス水の区〔Ｓ〕 F-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Quartermaster
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。野兎の尻尾は手に入りにくい。虫の翅は12枚要る。ラプトルの皮と大鳥の羽根は少し高い。自分で収穫・採掘・伐採したり敵から取ったりすると、だいじなもの「Supply Order」が入ると書く資料もあるが、なくても完了できる。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @ウィンダス水の区〔Ｓ〕 F-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Quartermaster
g05 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに報告して、連合軍戦績をもらうと完了 | - | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo

@ mission.campaign.023 https://wiki.ffo.jp/html/15409.html
Q Stock and Awe IV (B) | 戦略物資収集 IV（共和国軍） | yes | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
MN - 31
LK quest:過去世界クエスト「第四共和軍団入団試験」をクリアして、第四共和軍団（共和国軍）に入っている
LK condition:所属軍が共和国軍
LK condition:勲章が二級勲功翼章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Stock_and_Awe_IV_(B);Hieronymus（バストゥーク商業区〔Ｓ〕E-8）、Resource procurement、1人。Quartermaster H-9。Wyvern Wing・Goblin Mess Tin・Peiste Stinger・Peiste Skin・Wivre Horn・Heavy Quadav Chestplate・Heavy Quadav Backplate 各1（Slug Eye はない）。★5で経験値518・戦績1436。勲章は Brass Wings of Service §（wings1）（FFXIclopedia も同じ）。用語辞典の戦略物資収集のページ：「二級勲功翼章 所持で受領可能」。（FFXIclopedia：Hieronymus E-8、Quartermaster H-9、用語辞典と同じ8品 各1。★ごとに経験値407〜595・戦績1085〜1587）
g01 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに話して、指令書「物資確保」から「戦略物資収集 IV」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
g02 talk - | バストゥーク商業区〔Ｓ〕(H-9)のQuartermasterに話して、集める品を聞く | 次のどれかを言われる：クゥダフの超重胸甲・クゥダフの超重背甲・ペイストの皮・ペイストの毒針・スラッグの眼・ゴブリンメスティン・飛竜の翼・鎧竜の角。個数はどれも1個と書く資料もある。 | @バストゥーク商業区〔Ｓ〕 H-9 | T npc.バストゥーク商業区〔Ｓ〕.Quartermaster
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。どれも過去世界の敵が落とす品。いくつかはユニオンの戦利品で手に入り、競売にも出る。自分で収穫・採掘・伐採したり敵から取ったりすると、だいじなもの「Supply Order」が入ると書く資料もあるが、なくても完了できる。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @バストゥーク商業区〔Ｓ〕 H-9 | T npc.バストゥーク商業区〔Ｓ〕.Quartermaster
g05 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに報告して、連合軍戦績をもらうと完了 | - | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus

@ mission.campaign.024 https://wiki.ffo.jp/html/18159.html
Q Stock and Awe IV (S) | 戦略物資収集 IV（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 32
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が二級勲功翼章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Stock_and_Awe_IV_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Resource procurement、1人。Quartermaster は I-9。用語辞典と同じ8品（Ladybug Wing は2）。経験値390・戦績1080。勲章は Brass Wings of Service §（wings1）（FFXIclopedia も同じ）。用語辞典の戦略物資収集のページ：「二級勲功翼章 所持で受領可能」。（FFXIclopedia：Rasdinice I-9、Quartermaster H-9、用語辞典と同じ8品。★ごとに経験値407〜577・戦績1085〜1539）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「物資確保」から「戦略物資収集 IV」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(H-9)のQuartermasterに話して、集める品を聞く | 次のどれかを言われる：アガリクス1個・オークの鉄冑1個・オークの肩甲1個・ジンの灰1個・スミロドンの肝1個・スミロドンの毛皮1枚・ノールの爪1個・レディバグの上翅2個。場所をI-9と書く資料もある。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。多くはユニオンの戦利品で手に入る。自分で収穫・採掘・伐採したり敵から取ったりすると、だいじなもの「Supply Order」が入ると書く資料もあるが、なくても完了できる。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.025 https://wiki.ffo.jp/html/18160.html
Q Stock and Awe IV (W) | 戦略物資収集 IV（連邦軍） | yes | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
MN - 33
LK quest:過去世界クエスト「コブラ傭兵団入団試験」をクリアして、コブラ傭兵団（連邦軍）に入っている
LK condition:所属軍が連邦軍
LK condition:勲章が二級勲功翼章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Stock_and_Awe_IV_(W);Emhi Tchaoryo（ウィンダス水の区〔Ｓ〕H-9）、Resource procurement、1人。Quartermaster F-9。Gnat Wing のほかの7品 各1。報酬は要確認。勲章は Brass Wings of Service §（wings1）（FFXIclopedia も同じ）。用語辞典の戦略物資収集のページ：「二級勲功翼章 所持で受領可能」。（FFXIclopedia：Emhi Tchaoryo H-9、Quartermaster F-9、用語辞典と同じ8品（Gnat Wing x2）。★ごとに経験値407〜607・戦績1080〜1571）
g01 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに話して、指令書「物資確保」から「戦略物資収集 IV」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
g02 talk - | ウィンダス水の区〔Ｓ〕北(F-9)のQuartermasterに話して、集める品を聞く | 次のどれかを言われる：ダルメルヘア1個・ナットの翅2個・ヤグードの大袖1個・ヤグードの篭手1個・ラフレシアのつる1個・ラフレシアの花弁1個・リンクスの毛皮1枚・リンクスの肉1個。 | @ウィンダス水の区〔Ｓ〕 F-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Quartermaster
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。ほとんどがユニオンの戦利品で手に入り、競売で買えることが多い。自分で収穫・採掘・伐採したり敵から取ったりすると、だいじなもの「Supply Order」が入ると書く資料もあるが、なくても完了できる。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @ウィンダス水の区〔Ｓ〕 F-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Quartermaster
g05 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに報告して、連合軍戦績をもらうと完了 | - | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo

@ mission.campaign.026 https://wiki.ffo.jp/html/14626.html
Q Stock and Awe I (B) | 戦略物資収集 I（共和国軍） | yes | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
MN - 34
LK quest:過去世界クエスト「第四共和軍団入団試験」をクリアして、第四共和軍団（共和国軍）に入っている
LK condition:所属軍が共和国軍
LK condition:勲章が二級連合従軍章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Stock_and_Awe_I_(B);Hieronymus（バストゥーク商業区〔Ｓ〕E-8）、Resource procurement、1人。Quartermaster H-9。Copper Ore・Zinc Ore・Tin Ore 各1。経験値90・戦績480。勲章は Bronze Ribbon of Service §（ribbon1）（FFXIclopedia も同じ）。用語辞典の戦略物資収集のページ：「二級連合従軍章 所持で受領可能」。（FFXIclopedia：Hieronymus E-8、指令書は Resource Procurement、Quartermaster H-9 が北グスタベルグ〔Ｓ〕でと言う。Copper Ore・Tin Ore・Zinc Ore。銅鉱・亜鉛鉱は彫金ギルド（Teerth・Celestina）、スズ石は鍛冶ギルドで買える。採掘はゼーガム丘陵の2段目（J-8 から上がる）、Tunnel Worm が落とす。★ごとに経験値135〜540・戦績597〜1080）
g01 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに話して、指令書「物資確保」から「戦略物資収集 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
g02 talk - | バストゥーク商業区〔Ｓ〕(H-9)のQuartermasterに話して、集める品を聞く | 次のどれかを言われる：銅鉱1個・スズ石1個・亜鉛鉱1個。 | @バストゥーク商業区〔Ｓ〕 H-9 | T npc.バストゥーク商業区〔Ｓ〕.Quartermaster
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。ギルドで買えるほか、ワーム類が落とし、採掘でも取れる。HieronymusからQuartermasterまでは少し遠い。自分で収穫・採掘・伐採したり敵から取ったりすると、だいじなもの「Supply Order」が入ると書く資料もあるが、なくても完了できる。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @バストゥーク商業区〔Ｓ〕 H-9 | T npc.バストゥーク商業区〔Ｓ〕.Quartermaster
g05 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに報告して、連合軍戦績をもらうと完了 | - | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus

@ mission.campaign.027 https://wiki.ffo.jp/html/14057.html
Q Stock and Awe I (S) | 戦略物資収集 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 35
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が二級連合従軍章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Stock_and_Awe_I_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Resource procurement、1人。Quartermaster は I-9（Rasdinice の向かいのテントのそば）。Arrowwood Log・Ash Log・Maple Log 各1。経験値90・戦績480。勲章は Bronze Ribbon of Service §（ribbon1）（FFXIclopedia も同じ）。用語辞典の戦略物資収集のページ：「二級連合従軍章 所持で受領可能」。（FFXIclopedia：Rasdinice I-9、Quartermaster H-9。Arrowwood Log・Ash Log・Maple Log のほか Copper Ore・Walnut。★ごとに経験値135〜200・戦績542〜801）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「物資確保」から「戦略物資収集 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(H-9)のQuartermasterに話して、集める品を聞く | 次のどれかを言われる：アローウッド原木1個・アッシュ原木1個・メープル原木1個。ほかの品を書く資料もある。場所をI-9と書く資料もある。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。Quartermasterは東ロンフォールで伐採してこいと言う。現代の木工ギルドなどで買うのが早い。自分で収穫・採掘・伐採したり敵から取ったりすると、だいじなもの「Supply Order」が入ると書く資料もあるが、なくても完了できる。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.028 https://wiki.ffo.jp/html/14625.html
Q Stock and Awe I (W) | 戦略物資収集 I（連邦軍） | yes | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
MN - 36
LK quest:過去世界クエスト「コブラ傭兵団入団試験」をクリアして、コブラ傭兵団（連邦軍）に入っている
LK condition:所属軍が連邦軍
LK condition:勲章が二級連合従軍章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Stock_and_Awe_I_(W);Emhi Tchaoryo（ウィンダス水の区〔Ｓ〕H-9）、Resource procurement、1人。Quartermaster は酒場の前（西サルタバルタへの出口のアーチを向いて、橋の向こう）。Fresh Marjoram・Saruta Cotton・Moko Grass 各1（ギデアス・西サルタバルタで収穫、競売や店で買ってもよい）。経験値90・戦績480。勲章は Bronze Ribbon of Service §（ribbon1）（FFXIclopedia も同じ）。用語辞典の戦略物資収集のページ：「二級連合従軍章 所持で受領可能」。（FFXIclopedia：Emhi Tchaoryo H-9、Quartermaster F-9（北）、Fresh Marjoram・Moko Grass・Saruta Cotton。現代でも過去でも収穫できる。★ごとに経験値90〜201・戦績480〜804）
g01 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに話して、指令書「物資確保」から「戦略物資収集 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
g02 talk - | ウィンダス水の区〔Ｓ〕北(F-9)のQuartermasterに話して、集める品を聞く | 次のどれかを言われる：サルタ綿花1個・モコ草1個・マージョラム1個。 | @ウィンダス水の区〔Ｓ〕 F-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Quartermaster
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。どれもスタックできるので、先に用意しておくと早い。自分で収穫・採掘・伐採したり敵から取ったりすると、だいじなもの「Supply Order」が入ると書く資料もあるが、なくても完了できる。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @ウィンダス水の区〔Ｓ〕 F-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Quartermaster
g05 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに報告して、連合軍戦績をもらうと完了 | - | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo

@ mission.campaign.029 https://wiki.ffo.jp/html/14074.html
Q Iron Anvil III (S) | 技術供与 III（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 37
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級戦功水晶章以上
LK condition:合成スキルのどれか（釣り以外）が41以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Iron_Anvil_III_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Supply manufacture、Iron Emblem of Service §§、Adjutant（D-8）に話す。2つの品のクリスタルと材料（8つまで、選び終わっても聞かれたら No additional materials）、聞かれる順はランダム。経験値340・連合軍戦績980。BG Wiki の Adjutant のページは D-7。用語辞典の技術供与のページ：指令書「生産支援」、1人、Adjutant は南サンドリア〔Ｓ〕D-8、2問続けて正解で成功、I・II は材料の選択肢の並びが決まっていて III からランダム、III は一級戦功水晶章を持ち合成スキルのどれかが41以上。（FFXIclopedia：Rasdinice I-9、Supply Manufacture、emblem2、1人、Op Credit 1。Adjutant D-8。時間制限があり、遅いか間違えると失敗。材料は8つまで、8つ未満なら No more ingredients。ジョブLv10より上でないと経験値なし。★ごとに経験値321〜478・戦績884〜1315）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「生産支援」から「技術供与 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(D-8)の軍需監督副官Adjutantに話して、「支援する！」と答え、得意な合成を選ぶ | 革工ギルドの近くの外にいる（中ではない）。釣りは選べない。場所をD-7と書く資料もある。 | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant = npc:Adjutant@南サンドリア〔Ｓ〕 D-8
g03 talk - | Adjutantに聞かれた品のクリスタルと材料を順に選んで、1問目に答える | 材料は8つまで。全部選んだら「これで全部。」を選ぶ（8つのときは要らない）。選択肢の並びは毎回変わる。答えるのに時間制限があり、遅いか間違えると失敗。スキル60までのレシピから出る。 | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g04 talk - | Adjutantの2問目に答える。2問続けて正解すると成功で、経験値が入る | ジョブのレベルが10より上でないと経験値が入らないと書く資料もある。 | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.030 https://wiki.ffo.jp/html/14073.html
Q Iron Anvil II (S) | 技術供与 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 38
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が白銀剣勲章以上
LK condition:合成スキルのどれか（釣り以外）が21以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Iron_Anvil_II_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Supply manufacture、Sterling Star §§、Adjutant（D-8）に話す。2つの品のクリスタルと材料（5つまで）、聞かれる順は決まっている。選び終わっても聞かれたら No additional materials。経験値240・連合軍戦績780。BG Wiki の Adjutant のページは D-7。用語辞典の技術供与のページ：指令書「生産支援」、1人、Adjutant は南サンドリア〔Ｓ〕D-8、2問続けて正解で成功、I・II は材料の選択肢の並びが決まっていて III からランダム、II は白銀剣勲章を持ち合成スキルのどれかが21以上。（FFXIclopedia：Rasdinice I-9、Supply Manufacture、star2、1人、Op Credit 1。Adjutant D-8（革工ギルドの北西、外のたるの後ろ）。材料の並びが変わることがある。時間制限。スキル21より低い合成を選ぶと断られる。選んだあと No more ingredients を選ぶ。★ごとに経験値240〜603・戦績723〜1047）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「生産支援」から「技術供与 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(D-8)の軍需監督副官Adjutantに話して、「支援する！」と答え、得意な合成を選ぶ | 革工ギルドの近くの外にいる（中ではない）。釣りは選べない。スキルが21より低い合成を選ぶと断られる。場所をD-7と書く資料もある。 | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g03 talk - | Adjutantに聞かれた品のクリスタルと材料を順に選んで、1問目に答える | 材料は5つまで。全部選んだら「これで全部。」を選ぶ（そろっても自動では終わらない）。答えるのに時間制限があり、遅いか間違えると失敗。スキル40までのレシピから出る。材料の選択肢の並びが変わると書く資料もある。 | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g04 talk - | Adjutantの2問目に答える。2問続けて正解すると成功で、経験値が入る | - | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.031 https://wiki.ffo.jp/html/14035.html
Q Iron Anvil I (S) | 技術供与 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 39
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級連合従軍章以上
LK condition:合成スキルのどれか（釣り以外）が1以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Iron_Anvil_I_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Supply manufacture、Brass Ribbon of Service §§、Adjutant（D-8）に話す。2つの品のクリスタルと材料（4つ目はないこともある）。職業訓練 I（Crystal Fist I）とほぼ同じで、問題が3つでなく2つ。経験値140・連合軍戦績580。BG Wiki の Adjutant のページは D-7。用語辞典の技術供与のページ：指令書「生産支援」、1人、Adjutant は南サンドリア〔Ｓ〕D-8、2問続けて正解で成功、I・II は材料の選択肢の並びが決まっていて III からランダム、I は一級連合従軍章を持ち合成スキルのどれかが1以上。（FFXIclopedia：Rasdinice I-9、Supply Manufacture、ribbon2、どれかの合成がLv1、1人、Op Credit 1。Adjutant D-8。時間制限があり、遅いか間違えると失敗。★ごとに経験値160〜236・戦績562〜826）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「生産支援」から「技術供与 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(D-8)の軍需監督副官Adjutantに話して、「支援する！」と答え、得意な合成を選ぶ | 革工ギルドの近くの外にいる（中ではない）。釣りは選べない。場所をD-7と書く資料もある。 | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g03 talk - | Adjutantに聞かれた品のクリスタルと材料を順に選んで、1問目に答える | クリスタルと材料はどれも4つから選び、一度選んだら変えられない。材料は3〜4つ。答えるのに時間制限があり、遅いか間違えると失敗。スキル20までのレシピから出る。 | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g04 talk - | Adjutantの2問目に答える。2問続けて正解すると成功で、経験値が入る | - | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.032 https://wiki.ffo.jp/html/14050.html
Q Hawk Eye III (S) | 拠点偵察 III（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 40
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が黄金剣勲章以上
LK condition:王国のまわりに獣人血盟軍が支配するエリアがある
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Hawk_Eye_III_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Intel gathering、Golden Star §§§§。オークの支配するエリアの拠点へ行き、拠点の ??? を調べる（??? は2つあり、もう1つは Slaughterhouse 用）。Commencing intel extraction のあと Gathering intel が何度か出て Investigation complete!。国のエリアが獣人の支配になっているときだけ出る。用語辞典の拠点偵察のページ：指令書「諜報工作」、黄金剣勲章 所持で受領可能、1人。王国軍はオーク帝国軍の勢力圏（エルディーム古墳〔Ｓ〕・クロウラーの巣〔Ｓ〕・ガルレージュ要塞〔Ｓ〕は対象外の模様）。インビジ・スニーク・デオード中は調べられない。/blockaid で座り、Esc でやめない限り立てない。I 30秒ほど・III 80秒ほど。アライドタグがなければ襲われない（FFXIclopedia：Rasdinice I-9、star4、1人、Op Credit 1。スニーク・インビジ中は集められない。集めているあいだは絡まれない。アライドタグもバトルも要らない）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「諜報工作」から「拠点偵察 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。王国のまわりに獣人血盟軍が支配するエリアがないと出ない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | オーク帝国軍の勢力圏で、獣人血盟軍が支配しているエリアの拠点へ行く | エルディーム古墳〔Ｓ〕・クロウラーの巣〔Ｓ〕・ガルレージュ要塞〔Ｓ〕は対象にならないようだ。アライドタグをつけていなければ獣人血盟軍に襲われない。
g03 examine - | 拠点の???を調べる | インビジ・スニーク・デオードがかかっていると調べられない。???は2つあり、もう1つは破壊工作のもの。
g04 go - | 座ったまま情報収集が終わるまで待つ。終わると経験値が入る | III は80秒ほど。Escキーでやめない限り立ち上がれない。
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.033 https://wiki.ffo.jp/html/14049.html
Q Hawk Eye II (S) | 拠点偵察 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 41
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が連合突撃章以上
LK condition:王国のまわりに獣人血盟軍が支配するエリアがある
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Hawk_Eye_II_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Intel gathering、Allied Ribbon of Glory §§§§。オークの支配するエリアの拠点へ行き、拠点の ??? を調べる（??? は2つあり、もう1つは Slaughterhouse 用）。Commencing intel extraction のあと Gathering intel が何度か出て Investigation complete!。国のエリアが獣人の支配になっているときだけ出る。用語辞典の拠点偵察のページ：指令書「諜報工作」、連合突撃章 所持で受領可能、1人。王国軍はオーク帝国軍の勢力圏（エルディーム古墳〔Ｓ〕・クロウラーの巣〔Ｓ〕・ガルレージュ要塞〔Ｓ〕は対象外の模様）。インビジ・スニーク・デオード中は調べられない。/blockaid で座り、Esc でやめない限り立てない。I 30秒ほど・III 80秒ほど。アライドタグがなければ襲われない（FFXIclopedia：Rasdinice I-9、ribbon4、1人、Op Credit 1。スニーク・インビジ中は集められない。集めているあいだは絡まれない。アライドタグもバトルも要らない）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「諜報工作」から「拠点偵察 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。王国のまわりに獣人血盟軍が支配するエリアがないと出ない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | オーク帝国軍の勢力圏で、獣人血盟軍が支配しているエリアの拠点へ行く | エルディーム古墳〔Ｓ〕・クロウラーの巣〔Ｓ〕・ガルレージュ要塞〔Ｓ〕は対象にならないようだ。アライドタグをつけていなければ獣人血盟軍に襲われない。
g03 examine - | 拠点の???を調べる | インビジ・スニーク・デオードがかかっていると調べられない。???は2つあり、もう1つは破壊工作のもの。
g04 go - | 座ったまま情報収集が終わるまで待つ。終わると経験値が入る | Escキーでやめない限り立ち上がれない。
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.034 https://wiki.ffo.jp/html/14048.html
Q Hawk Eye I (S) | 拠点偵察 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 42
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が二級連合従軍章以上
LK condition:王国のまわりに獣人血盟軍が支配するエリアがある
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Hawk_Eye_I_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Intel gathering、Bronze Ribbon of Service §。オークの支配するエリアの拠点へ行き、拠点の ??? を調べる（??? は2つあり、もう1つは Slaughterhouse 用）。Commencing intel extraction のあと Gathering intel が何度か出て Investigation complete!。国のエリアが獣人の支配になっているときだけ出る。用語辞典の拠点偵察のページ：指令書「諜報工作」、二級連合従軍章 所持で受領可能、1人。王国軍はオーク帝国軍の勢力圏（エルディーム古墳〔Ｓ〕・クロウラーの巣〔Ｓ〕・ガルレージュ要塞〔Ｓ〕は対象外の模様）。インビジ・スニーク・デオード中は調べられない。/blockaid で座り、Esc でやめない限り立てない。I 30秒ほど・III 80秒ほど。アライドタグがなければ襲われない（FFXIclopedia：Rasdinice I-9、ribbon1、1人、Op Credit 1。スニーク・インビジ中は集められない。集めているあいだは絡まれない。アライドタグもバトルも要らない）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「諜報工作」から「拠点偵察 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。王国のまわりに獣人血盟軍が支配するエリアがないと出ない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | オーク帝国軍の勢力圏で、獣人血盟軍が支配しているエリアの拠点へ行く | エルディーム古墳〔Ｓ〕・クロウラーの巣〔Ｓ〕・ガルレージュ要塞〔Ｓ〕は対象にならないようだ。アライドタグをつけていなければ獣人血盟軍に襲われない。
g03 examine - | 拠点の???を調べる | インビジ・スニーク・デオードがかかっていると調べられない。???は2つあり、もう1つは破壊工作のもの。
g04 go - | 座ったまま情報収集が終わるまで待つ。終わると経験値が入る | I は30秒ほど。Escキーでやめない限り立ち上がれない。
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.035 https://wiki.ffo.jp/html/14038.html
Q Smokescreen III (S) | 拠点攻略 III（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 43
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が黄金剣勲章以上
LK condition:王国のまわりに獣人血盟軍が支配するエリアがある
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/Smokescreen_III_(San_d%27Oria);BG Wiki にこのランクのページはない。用語辞典の拠点攻略のページ：指令書「侵攻支援」、黄金剣勲章 所持で受領可能、1人。オーク帝国軍の勢力圏で獣人血盟軍が支配するエリアのカンパニエバトル（I〜III は本拠地は対象外）。目安 I ほとんどなし・II 経験値1500・III 2400。足りるとバトルの終わりに報告するように出る。足りないまま報告するとあきらめるか聞かれ、はいで失敗。何度かに分けてよい、エリアチェンジ・ジョブチェンジ・ログアウトしてよい（FFXIclopedia：Rasdinice I-9、star4、獣人の支配するエリアがあること、1人、Op Credit 1。経験値3000要る）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「侵攻支援」から「拠点攻略 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。王国のまわりに獣人血盟軍が支配するエリアがないと出ない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | オーク帝国軍の勢力圏で、獣人血盟軍が支配しているエリアのカンパニエバトルに出て、経験値を稼ぐ | 目安は経験値2400ほど。3000と書く資料もある。獣人の本拠地（ラヴォール村〔Ｓ〕など）は対象にならない。何度かのバトルに分けてもよく、エリアを変えてもよい。
g03 go - | バトルが終わるまで待つ。目標に届いていれば、Rasdiniceに報告するようにと出て経験値が入る | 出なければまだ足りない。ほかのバトルにも出る。
g04 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 目標に届く前に報告すると、あきらめるか聞かれる。「はい」を選ぶと失敗になる。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.036 https://wiki.ffo.jp/html/14037.html
Q Smokescreen II (S) | 拠点攻略 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 44
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が連合突撃章以上
LK condition:王国のまわりに獣人血盟軍が支配するエリアがある
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/Smokescreen_II_(San_d%27Oria);BG Wiki にこのランクのページはない。用語辞典の拠点攻略のページ：指令書「侵攻支援」、連合突撃章 所持で受領可能、1人。オーク帝国軍の勢力圏で獣人血盟軍が支配するエリアのカンパニエバトル（I〜III は本拠地は対象外）。目安 I ほとんどなし・II 経験値1500・III 2400。足りるとバトルの終わりに報告するように出る。足りないまま報告するとあきらめるか聞かれ、はいで失敗。何度かに分けてよい、エリアチェンジ・ジョブチェンジ・ログアウトしてよい（FFXIclopedia：Rasdinice I-9、ribbon4、獣人の支配するエリアがあること、1人、Op Credit 1。経験値2000要る）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「侵攻支援」から「拠点攻略 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。王国のまわりに獣人血盟軍が支配するエリアがないと出ない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | オーク帝国軍の勢力圏で、獣人血盟軍が支配しているエリアのカンパニエバトルに出て、経験値を稼ぐ | 目安は経験値1500ほど。2000と書く資料もある。獣人の本拠地（ラヴォール村〔Ｓ〕など）は対象にならない。何度かのバトルに分けてもよく、エリアを変えてもよい。
g03 go - | バトルが終わるまで待つ。目標に届いていれば、Rasdiniceに報告するようにと出て経験値が入る | 出なければまだ足りない。ほかのバトルにも出る。
g04 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 目標に届く前に報告すると、あきらめるか聞かれる。「はい」を選ぶと失敗になる。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.037 https://wiki.ffo.jp/html/14036.html
Q Smokescreen I (S) | 拠点攻略 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 45
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が二級連合従軍章以上
LK condition:王国のまわりに獣人血盟軍が支配するエリアがある
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Smokescreen_I_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Offensive operations、Bronze Ribbon of Service §。オークの支配するエリアの攻めるバトルに出る。経験値65・戦績68で足りる。経験値110・戦績520。用語辞典の拠点攻略のページ：指令書「侵攻支援」、二級連合従軍章 所持で受領可能、1人。オーク帝国軍の勢力圏で獣人血盟軍が支配するエリアのカンパニエバトル（I〜III は本拠地は対象外）。目安 I ほとんどなし・II 経験値1500・III 2400。足りるとバトルの終わりに報告するように出る。足りないまま報告するとあきらめるか聞かれ、はいで失敗。何度かに分けてよい、エリアチェンジ・ジョブチェンジ・ログアウトしてよい（FFXIclopedia：Rasdinice I-9、ribbon1、獣人の支配するエリアがあること、1人、Op Credit 1。経験値1000要る）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「侵攻支援」から「拠点攻略 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。王国のまわりに獣人血盟軍が支配するエリアがないと出ない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | オーク帝国軍の勢力圏で、獣人血盟軍が支配しているエリアのカンパニエバトルに出て、経験値を稼ぐ | 少しでも経験値を稼げばよい。1000要ると書く資料もある。獣人の本拠地（ラヴォール村〔Ｓ〕など）は対象にならない。何度かのバトルに分けてもよく、エリアを変えてもよい。
g03 go - | バトルが終わるまで待つ。目標に届いていれば、Rasdiniceに報告するようにと出て経験値が入る | 出なければまだ足りない。ほかのバトルにも出る。
g04 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 目標に届く前に報告すると、あきらめるか聞かれる。「はい」を選ぶと失敗になる。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.038 https://wiki.ffo.jp/html/14044.html
Q Aegis Scream III (S) | 拠点防衛 III（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 46
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が黄金剣勲章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/Aegis_Scream_III_(San_d%27Oria);BG Wiki にこのランクのページはない。用語辞典の拠点防衛のページ：指令書「防衛支援」、黄金剣勲章 所持で受領可能、1人。自国が支配するエリアのうちオーク帝国軍の勢力圏のカンパニエバトル（本拠地は対象外）。目安 II 経験値1500・III 2400。I は何か行動すればよく、アライドタグを受けて1分たたないと経験値・戦績0。足りないまま報告するとあきらめるか聞かれる（FFXIclopedia：Rasdinice I-9、star4、1人、Op Credit 1。3000の経験値、何回・どのエリアに分けてもよい）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「防衛支援」から「拠点防衛 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | オーク帝国軍の勢力圏で、王国軍が支配しているエリアのカンパニエバトルに出て、経験値を稼ぐ | 目安は経験値2400ほど。3000と書く資料もある。獣人の本拠地は対象にならない。何度かのバトルに分けてもよく、エリアを変えてもよい。
g03 go - | バトルが終わるまで待つ。目標に届いていれば、Rasdiniceに報告するようにと出て経験値が入る | 出なければまだ足りない。ほかのバトルにも出る。
g04 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 目標に届く前に報告すると、あきらめるか聞かれる。「はい」を選ぶと失敗になる。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.039 https://wiki.ffo.jp/html/14043.html
Q Aegis Scream II (S) | 拠点防衛 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 47
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が連合突撃章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Aegis_Scream_II_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Defensive operations、Allied Ribbon of Glory §§§§。サンドリアの支配するエリアのバトル。Objective Completed が出たら報告、出る前に報告すると失敗。経験値894・戦績1341。用語辞典の拠点防衛のページ：指令書「防衛支援」、連合突撃章 所持で受領可能、1人。自国が支配するエリアのうちオーク帝国軍の勢力圏のカンパニエバトル（本拠地は対象外）。目安 II 経験値1500・III 2400。I は何か行動すればよく、アライドタグを受けて1分たたないと経験値・戦績0。足りないまま報告するとあきらめるか聞かれる（FFXIclopedia：Rasdinice I-9、ribbon4、1人、Op Credit 1。1500の経験値、何回・どのエリアに分けてもよい）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「防衛支援」から「拠点防衛 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | オーク帝国軍の勢力圏で、王国軍が支配しているエリアのカンパニエバトルに出て、経験値を稼ぐ | 目安は経験値1500ほど。獣人の本拠地は対象にならない。何度かのバトルに分けてもよく、エリアを変えてもよい。
g03 go - | バトルが終わるまで待つ。目標に届いていれば、Rasdiniceに報告するようにと出て経験値が入る | 出なければまだ足りない。ほかのバトルにも出る。
g04 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 目標に届く前に報告すると、あきらめるか聞かれる。「はい」を選ぶと失敗になる。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.040 https://wiki.ffo.jp/html/14042.html
Q Aegis Scream I (S) | 拠点防衛 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 48
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が二級連合従軍章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Aegis_Scream_I_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Defensive operations、Bronze Ribbon of Service §。サンドリアの支配するエリアのバトルに出る。バトルが終わらないとだめ（早めの査定で抜けると完了にならない）。経験値110・戦績520。用語辞典の拠点防衛のページ：指令書「防衛支援」、二級連合従軍章 所持で受領可能、1人。自国が支配するエリアのうちオーク帝国軍の勢力圏のカンパニエバトル（本拠地は対象外）。目安 II 経験値1500・III 2400。I は何か行動すればよく、アライドタグを受けて1分たたないと経験値・戦績0。足りないまま報告するとあきらめるか聞かれる（FFXIclopedia：Rasdinice I-9、ribbon1、1人、Op Credit 1。国の支配するエリアのバトルに出る。タグを受けて返すだけでよいとも（要確認の印つき））
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「防衛支援」から「拠点防衛 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | オーク帝国軍の勢力圏で、王国軍が支配しているエリアのカンパニエバトルに出て、経験値を稼ぐ | 何かしら働けばよい（強化魔法をかける、アライドタグをつけて攻撃を受けるなど）。アライドタグを受けて1分たたないと経験値と戦績が入らない。獣人の本拠地は対象にならない。
g03 go - | バトルが終わるまで待つ。目標に届いていれば、Rasdiniceに報告するようにと出て経験値が入る | 出なければまだ足りない。ほかのバトルにも出る。途中で早めの査定を受けて抜けると完了にならないと書く資料もある。
g04 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 目標に届く前に報告すると、あきらめるか聞かれる。「はい」を選ぶと失敗になる。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.041 https://wiki.ffo.jp/html/14805.html
Q Deep Cover II (S) | 敵兵装備偵察 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 49
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が白銀剣勲章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Deep_Cover_II_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Intel gathering、Sterling Star §§。Crochepallade（H-9）から Fiendtrapper と Blank Fiend Plate 5枚。スニーク・インビジ中や遠いと撮れない。名前のちがうオークを正面から撮る、カンパニエバトルの敵もよい。Fiend Plate はスタックしない。1枚ずつトレードして3枚で完了。用語辞典の敵兵装備偵察のページ：指令書「諜報工作」、1人、II は白銀剣勲章以上、撮るオークはレベル70以上（三国のまわりの獣人程度はだめ、カンパニエバトルに出ている獣人ならどれでも可）。魔写器はレアなので持っていると次を受けられない。王国軍はオーク。正面から、ほぼ密着して撮る（2タルタルほどあけるとよい模様）。知覚遮断中は撮れない。寝かせてもよい。3枚要り、同じ名前の敵は2枚目を受け取らない。月牙隊のノール族はだめ。魔写器は12回まで。経験値は3枚目をトレードしたとき。用語辞典の敵兵装備偵察 II（王国軍）のページ：受領できる勲章は不明と書く。Crochepallade は H-9。かばんに空きがないと撮れない。東ロンフォール〔Ｓ〕のオークは「君の階級章は飾りか?」で失敗扱い、ジャグナー森林〔Ｓ〕のオークは受け取ってもらえる。経験値250・連合軍戦績800（FFXIclopedia：Rasdinice I-9、Sterling Star ∮∮、1人、Op Credit 1。Crochepallade H-9。Orcish Transporter はだめで後ろの Orcish Guard はよい。Dark Kindred はだめ。レベルの低いオークだと断られて封魔板は返ってくる。ジャグナー森林〔Ｓ〕の Orcish Veteran・Orcish Dragonbrander、カンパニエのオークは全部よい。War machine もよい。★4 経験値354〜359・戦績834〜1077）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「諜報工作」から「敵兵装備偵察 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(H-9)の偵察総監Crochepalladeに話して、魔写器と魔影板5枚をもらう | 魔写器は1つしか持てない。前の魔写器を持っていたら、捨ててから話す。魔影板は追加でもらえないので、余った魔影板はとっておくと次に使える。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Crochepallade = npc:Crochepallade@南サンドリア〔Ｓ〕 H-9
g03 go - | 魔写器をレンジウェポン、魔影板を矢弾に装備して、オークのいる場所へ行く | レベル70以上のオークでないと受け取ってもらえない。東ロンフォール〔Ｓ〕などのオークはだめで、ジャグナー森林〔Ｓ〕のオークやカンパニエバトルに出ているオークならよい。月牙隊のノール族など、オークでない相手はだめ。Orcish Transporterもだめ。
g04 gather - | オークを正面から撮って、名前のちがうオークの封魔板を3枚作る | 正面のすぐ近くから撮る（くっつきすぎると失敗するので少し離れる）。スニーク・インビジがかかっていると撮れない。かばんに空きがないと撮れない。封魔板は重ならない。寝ているオークでも撮れる。
g05 trade - | 南サンドリア〔Ｓ〕(H-9)のCrochepalladeに封魔板を1枚ずつトレードして、3枚受け取ってもらうと成功。経験値が入る | 同じ名前のオークの封魔板は2枚目を受け取ってもらえない。断られた封魔板は返ってくる。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Crochepallade
g06 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.042 https://wiki.ffo.jp/html/14804.html
Q Deep Cover I (S) | 敵兵装備偵察 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 50
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級連合従軍章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Deep_Cover_I_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Intel gathering、Brass Ribbon of Service §§。Crochepallade（H-9）から Fiendtrapper と Blank Fiend Plate 5枚。スニーク・インビジ中や遠いと撮れない。名前のちがうオークを正面から撮る、カンパニエバトルの敵もよい。Fiend Plate はスタックしない。1枚ずつトレードして3枚で完了。用語辞典の敵兵装備偵察のページ：指令書「諜報工作」、1人、I は一級連合従軍章所持で受領可能、撮る獣人のレベル制限はない。魔写器はレアなので持っていると次を受けられない。王国軍はオーク。正面から、ほぼ密着して撮る（2タルタルほどあけるとよい模様）。知覚遮断中は撮れない。寝かせてもよい。3枚要り、同じ名前の敵は2枚目を受け取らない。月牙隊のノール族はだめ。魔写器は12回まで。経験値は3枚目をトレードしたとき。用語辞典の敵兵装備偵察 I（王国軍）のページ：受領できる勲章は不明と書く。Crochepallade は H-9。かばんに空きがないと撮れない。撮れなかったときの魔影板は追加でもらえず、3枚に届かないとあきらめるしかない。経験値・戦績の値は空欄（FFXIclopedia：Rasdinice I-9、ribbon2、1人、Op Credit 1。Crochepallade H-9。Orcish Transporter はだめで後ろの Orcish Guard はよい。Dark Kindred はだめ。Fiendtrapper を持っているとくり返し受けられないので捨てる。★1 経験値180・戦績633ほど）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「諜報工作」から「敵兵装備偵察 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(H-9)の偵察総監Crochepalladeに話して、魔写器と魔影板5枚をもらう | 魔写器は1つしか持てない。前の魔写器を持っていたら、捨ててから話す。魔影板は追加でもらえないので、余った魔影板はとっておくと次に使える。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Crochepallade
g03 go - | 魔写器をレンジウェポン、魔影板を矢弾に装備して、オークのいる場所へ行く | オークのレベルは問わない。月牙隊のノール族など、オークでない相手はだめ。Orcish Transporterもだめ。
g04 gather - | オークを正面から撮って、名前のちがうオークの封魔板を3枚作る | 正面のすぐ近くから撮る（くっつきすぎると失敗するので少し離れる）。スニーク・インビジがかかっていると撮れない。かばんに空きがないと撮れない。封魔板は重ならない。寝ているオークでも撮れる。
g05 trade - | 南サンドリア〔Ｓ〕(H-9)のCrochepalladeに封魔板を1枚ずつトレードして、3枚受け取ってもらうと成功。経験値が入る | 同じ名前のオークの封魔板は2枚目を受け取ってもらえない。断られた封魔板は返ってくる。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Crochepallade
g06 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.043 https://wiki.ffo.jp/html/14053.html
Q Slaughterhouse III (S) | 破壊工作 III（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 51
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級戦功水晶章以上
LK condition:王国のまわりに獣人血盟軍が支配するエリアがある
LK condition:募集要員は1〜6人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/Slaughterhouse_III_(San_d%27Oria);BG Wiki にこのランクのページはない。FFXIclopedia：Rasdinice（南サンドリア〔Ｓ〕I-9）、Intel Gathering、emblem2、1人、Op Credit 1。オークの支配する外のエリアの拠点へ行く（エルディーム古墳〔Ｓ〕・ラヴォール村〔Ｓ〕はできない）。拠点の ??? は2つ（爆弾を置けるのは1つ）。調べて爆弾を置き、爆発を待ってもう一度調べる。爆発のあと遅い・ワープやエリアを出る・戦闘不能・獣人が近づいて爆弾を外すと失敗（外されてもメッセージなし）。パーティなら受けていないメンバーも爆発の直後に調べると経験値。衰弱中は経験値なし。爆発まで52秒ほど（ゲームの21分）。★1 経験値341〜361・戦績984〜994。用語辞典の破壊工作のページ：指令書「諜報工作」、1〜6人、一級戦功水晶章 所持で受領可能。獣人血盟軍の支配するエリアの拠点の ??? を調べると爆弾。爆発はグラフィックだけでログなし。爆発までの時間は難易度で増える（III 約50秒、IV 約1分20秒）。アライドタグがなければ攻撃されない。部隊や補給部隊に見つかると回収されて失敗。爆発後に調べる前にエリアチェンジすると失敗、時間がたちすぎても失敗（10秒以内がよい）。爆弾は1個でやり直しなし。他人が置いているあいだは置けない。王国軍はオーク帝国軍の勢力圏、エルディーム古墳〔Ｓ〕・ラヴォール村〔Ｓ〕・クロウラーの巣〔Ｓ〕・ベドー〔Ｓ〕・ガルレージュ要塞〔Ｓ〕・オズトロヤ城〔Ｓ〕は対象外。PT なら1人の爆破で成功扱い、受けていない人にも経験値（戦績は爆破した1人）。用語辞典の破壊工作 III（王国軍）のページは指令内容と募集要員1〜6人だけ
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「諜報工作」から「破壊工作 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。王国のまわりに獣人血盟軍が支配するエリアがないと出ない。募集要員を1人と書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | オーク帝国軍の勢力圏で、獣人血盟軍が支配している外のエリアの拠点へ行く | エルディーム古墳〔Ｓ〕・ラヴォール村〔Ｓ〕などのダンジョンのエリアは対象にならない。アライドタグをつけていなければ獣人血盟軍に襲われない。
g03 examine - | 拠点の???を調べて、爆弾を仕掛ける | ???は2つあり、爆弾を置けるのは1つだけ（もう1つは拠点偵察のもの）。爆弾は1個だけでやり直せない。ほかの人が仕掛けているあいだは置けない。
g04 go - | 爆弾が爆発するまで、そばで待つ | III は50秒ほど。爆発は見た目だけで、ログには出ない。獣人血盟軍の部隊や補給部隊が近づくと爆弾を外されて失敗になる（何も出ない）。部隊が引き上げてから仕掛けるとよい。エリアを出たり、戦闘不能になったりしても失敗。
g05 examine - | 爆発したらすぐ、もう一度???を調べる。経験値が入る | 時間がたちすぎると失敗になるので、爆発から10秒以内に調べるとよい。パーティを組んでいれば、受けていないメンバーも爆発の直後に???を調べると経験値が入る。衰弱中は経験値が入らない。
g06 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.044 https://wiki.ffo.jp/html/14052.html
Q Slaughterhouse II (S) | 破壊工作 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 52
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が白銀剣勲章以上
LK condition:王国のまわりに獣人血盟軍が支配するエリアがある
LK condition:募集要員は1〜6人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/Slaughterhouse_II_(San_d%27Oria);BG Wiki にこのランクのページはない。FFXIclopedia：Rasdinice（南サンドリア〔Ｓ〕I-9）、Intel Gathering、star2、1人、Op Credit 1。オークの支配する外のエリアの拠点へ行く（エルディーム古墳〔Ｓ〕・ラヴォール村〔Ｓ〕はできない）。拠点の ??? は2つ（爆弾を置けるのは1つ）。調べて爆弾を置き、爆発を待ってもう一度調べる。爆発のあと遅い・ワープやエリアを出る・戦闘不能・獣人が近づいて爆弾を外すと失敗（外されてもメッセージなし）。パーティなら受けていないメンバーも爆発の直後に調べると経験値。衰弱中は経験値なし。★1 経験値271・戦績814ほど。用語辞典の破壊工作のページ：指令書「諜報工作」、1〜6人、白銀剣勲章 所持で受領可能。獣人血盟軍の支配するエリアの拠点の ??? を調べると爆弾。爆発はグラフィックだけでログなし。爆発までの時間は難易度で増える（III 約50秒、IV 約1分20秒）。アライドタグがなければ攻撃されない。部隊や補給部隊に見つかると回収されて失敗。爆発後に調べる前にエリアチェンジすると失敗、時間がたちすぎても失敗（10秒以内がよい）。爆弾は1個でやり直しなし。他人が置いているあいだは置けない。王国軍はオーク帝国軍の勢力圏、エルディーム古墳〔Ｓ〕・ラヴォール村〔Ｓ〕・クロウラーの巣〔Ｓ〕・ベドー〔Ｓ〕・ガルレージュ要塞〔Ｓ〕・オズトロヤ城〔Ｓ〕は対象外。PT なら1人の爆破で成功扱い、受けていない人にも経験値（戦績は爆破した1人）。用語辞典の破壊工作 II（王国軍）のページは指令内容と募集要員1〜6人だけ
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「諜報工作」から「破壊工作 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。王国のまわりに獣人血盟軍が支配するエリアがないと出ない。募集要員を1人と書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | オーク帝国軍の勢力圏で、獣人血盟軍が支配している外のエリアの拠点へ行く | エルディーム古墳〔Ｓ〕・ラヴォール村〔Ｓ〕などのダンジョンのエリアは対象にならない。アライドタグをつけていなければ獣人血盟軍に襲われない。
g03 examine - | 拠点の???を調べて、爆弾を仕掛ける | ???は2つあり、爆弾を置けるのは1つだけ（もう1つは拠点偵察のもの）。爆弾は1個だけでやり直せない。ほかの人が仕掛けているあいだは置けない。
g04 go - | 爆弾が爆発するまで、そばで待つ | 爆発は見た目だけで、ログには出ない。獣人血盟軍の部隊や補給部隊が近づくと爆弾を外されて失敗になる（何も出ない）。部隊が引き上げてから仕掛けるとよい。エリアを出たり、戦闘不能になったりしても失敗。
g05 examine - | 爆発したらすぐ、もう一度???を調べる。経験値が入る | 時間がたちすぎると失敗になるので、爆発から10秒以内に調べるとよい。パーティを組んでいれば、受けていないメンバーも爆発の直後に???を調べると経験値が入る。衰弱中は経験値が入らない。
g06 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.045 https://wiki.ffo.jp/html/14051.html
Q Slaughterhouse I (S) | 破壊工作 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 53
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級連合従軍章以上
LK condition:王国のまわりに獣人血盟軍が支配するエリアがある
LK condition:募集要員は1〜6人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/Slaughterhouse_I_(San_d%27Oria);BG Wiki にこのランクのページはない。FFXIclopedia：Rasdinice（南サンドリア〔Ｓ〕I-9）、Intel Gathering、ribbon2、1人、Op Credit 1。オークの支配する外のエリアの拠点へ行く（エルディーム古墳〔Ｓ〕・ラヴォール村〔Ｓ〕はできない）。拠点の ??? は2つ（爆弾を置けるのは1つ）。調べて爆弾を置き、爆発を待ってもう一度調べる。爆発のあと遅い・ワープやエリアを出る・戦闘不能・獣人が近づいて爆弾を外すと失敗（外されてもメッセージなし）。パーティなら受けていないメンバーも爆発の直後に調べると経験値。衰弱中は経験値なし。★1 経験値180・戦績633ほど。用語辞典の破壊工作のページ：指令書「諜報工作」、1〜6人、一級連合従軍章 所持で受領可能。獣人血盟軍の支配するエリアの拠点の ??? を調べると爆弾。爆発はグラフィックだけでログなし。爆発までの時間は難易度で増える（III 約50秒、IV 約1分20秒）。アライドタグがなければ攻撃されない。部隊や補給部隊に見つかると回収されて失敗。爆発後に調べる前にエリアチェンジすると失敗、時間がたちすぎても失敗（10秒以内がよい）。爆弾は1個でやり直しなし。他人が置いているあいだは置けない。王国軍はオーク帝国軍の勢力圏、エルディーム古墳〔Ｓ〕・ラヴォール村〔Ｓ〕・クロウラーの巣〔Ｓ〕・ベドー〔Ｓ〕・ガルレージュ要塞〔Ｓ〕・オズトロヤ城〔Ｓ〕は対象外。PT なら1人の爆破で成功扱い、受けていない人にも経験値（戦績は爆破した1人）。用語辞典の破壊工作 I（王国軍）のページは指令内容と募集要員1〜6人だけ
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「諜報工作」から「破壊工作 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。王国のまわりに獣人血盟軍が支配するエリアがないと出ない。募集要員を1人と書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | オーク帝国軍の勢力圏で、獣人血盟軍が支配している外のエリアの拠点へ行く | エルディーム古墳〔Ｓ〕・ラヴォール村〔Ｓ〕などのダンジョンのエリアは対象にならない。アライドタグをつけていなければ獣人血盟軍に襲われない。
g03 examine - | 拠点の???を調べて、爆弾を仕掛ける | ???は2つあり、爆弾を置けるのは1つだけ（もう1つは拠点偵察のもの）。爆弾は1個だけでやり直せない。ほかの人が仕掛けているあいだは置けない。
g04 go - | 爆弾が爆発するまで、そばで待つ | 爆発は見た目だけで、ログには出ない。獣人血盟軍の部隊や補給部隊が近づくと爆弾を外されて失敗になる（何も出ない）。部隊が引き上げてから仕掛けるとよい。エリアを出たり、戦闘不能になったりしても失敗。
g05 examine - | 爆発したらすぐ、もう一度???を調べる。経験値が入る | 時間がたちすぎると失敗になるので、爆発から10秒以内に調べるとよい。パーティを組んでいれば、受けていないメンバーも爆発の直後に???を調べると経験値が入る。衰弱中は経験値が入らない。
g06 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.046 https://wiki.ffo.jp/html/14072.html
Q Crystal Fist III (S) | 職業訓練 III（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 54
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が黄金剣勲章以上
LK condition:合成スキルのどれか（釣り以外）が41以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystal_Fist_III_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Supply manufacture、Golden Star §§§§。Adjutant（D-8）で合成を選び、3つの品のクリスタルと材料（3つまで）を答える。時間制限あり。経験値1054・連合軍戦績1406。用語辞典の職業訓練のページ：指令書「生産支援」、1人、Adjutant は南サンドリア〔Ｓ〕D-8・バストゥーク商業区〔Ｓ〕J-9・ウィンダス水の区〔Ｓ〕F-9。得意な合成（釣り以外）を言うと品を1つ言われ、レシピを選んで答える。3問続けて正解で成功。時間制限あり。III 黄金剣勲章所持、合成スキル（釣り以外）のどれかが41以上で受領可能。「これで全部」を選ぶ。用語辞典の職業訓練 III（王国軍）のページ：D-8 の Adjutant。スキル1〜60の素人〜目録のレシピ、クリスタル以外の材料1〜3。材料は6択で最後に「これで全部。」。制限時間がとても短い。全3問（FFXIclopedia：Rasdinice I-9、Supply Manufacture、star4、1人、Op Credit 1。Adjutant は Apprentice（少なくとも38）以上の合成でないと断る。材料は3つまで。選択肢は6つ。材料の出る順は毎回変わる。時間は選択肢が出ているあいだだけ数える。★ごとに経験値281〜403・戦績804〜1152）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「生産支援」から「職業訓練 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(D-8)の軍需監督副官Adjutantに話して、「支援する！」と答え、得意な合成を選ぶ | 革工ギルドの近くの外にいる（中ではない）。釣りは選べない。選んだ合成のスキルが足りないと断られる。38あれば選べたと書く資料もある。 | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g03 talk - | Adjutantに聞かれた品のクリスタルと材料を順に選んで、1問目に答える | 選択肢は6つずつ。材料を全部選んだら最後に「これで全部。」を選ぶ。材料の並びは毎回変わる。スキル60までのレシピ（クリスタル以外の材料1〜3）から出る。答えるのに時間制限があり、問題が出たときから数える。遅いか間違えると失敗。時間は選択肢が出ているあいだだけ数えると書く資料もある。 | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g04 talk - | Adjutantの2問目に答える | - | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g05 talk - | Adjutantの3問目に答える。3問続けて正解すると成功で、経験値が入る | - | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g06 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.047 https://wiki.ffo.jp/html/14071.html
Q Crystal Fist II (S) | 職業訓練 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 55
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が連合突撃章以上
LK condition:合成スキルのどれか（釣り以外）が21以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystal_Fist_II_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Supply manufacture、Allied Ribbon of Glory §§§§。Adjutant（D-8）で合成を選び、3つの品のクリスタルと材料2つを答える。時間制限あり。合成スキル7では受けられず67ではできた。経験値190・連合軍戦績680。用語辞典の職業訓練のページ：指令書「生産支援」、1人、Adjutant は南サンドリア〔Ｓ〕D-8・バストゥーク商業区〔Ｓ〕J-9・ウィンダス水の区〔Ｓ〕F-9。得意な合成（釣り以外）を言うと品を1つ言われ、レシピを選んで答える。3問続けて正解で成功。時間制限あり。II 連合突撃章所持、合成スキル（釣り以外）のどれかが21以上で受領可能。五択。徒弟〜下級職人のクリスタル以外の材料1〜2のレシピ。申告した合成スキルが徒弟に満たないと断られる模様。用語辞典の職業訓練 II（王国軍）のページ：D-8 の Adjutant。スキル21〜40の徒弟〜下級職人のレシピ、材料1〜2。経験値190・連合軍戦績680（FFXIclopedia：Rasdinice I-9、Supply Manufacture、ribbon4、1人、Op Credit 1。Adjutant はスキル21以上の合成でないと断る。3つの品。時間は選択肢が出ているあいだだけ数える。★ごとに経験値201〜287・戦績643〜947）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「生産支援」から「職業訓練 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(D-8)の軍需監督副官Adjutantに話して、「支援する！」と答え、得意な合成を選ぶ | 革工ギルドの近くの外にいる（中ではない）。釣りは選べない。選んだ合成のスキルが21より低いと断られるようだ。 | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g03 talk - | Adjutantに聞かれた品のクリスタルと材料を順に選んで、1問目に答える | 選択肢は5つずつ。スキル21〜40のレシピ（クリスタル以外の材料1〜2）から出る。答えるのに時間制限があり、問題が出たときから数える。遅いか間違えると失敗。時間は選択肢が出ているあいだだけ数えると書く資料もある。 | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g04 talk - | Adjutantの2問目に答える | - | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g05 talk - | Adjutantの3問目に答える。3問続けて正解すると成功で、経験値が入る | - | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g06 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.048 https://wiki.ffo.jp/html/14156.html
Q Crystal Fist I (B) | 職業訓練 I（共和国軍） | yes | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
MN - 56
LK quest:過去世界クエスト「第四共和軍団入団試験」をクリアして、第四共和軍団（共和国軍）に入っている
LK condition:所属軍が共和国軍
LK condition:勲章が二級連合従軍章以上
LK condition:合成スキルのどれか（釣り以外）が1以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystal_Fist_I_(B);Hieronymus（バストゥーク商業区〔Ｓ〕E-8）、Supply manufacture、Bronze Ribbon of Service §。Adjutant（J-9）で合成を選び、3つの品のクリスタルと材料2つを答える。時間制限あり。経験値90・連合軍戦績480。用語辞典の職業訓練のページ：指令書「生産支援」、1人、Adjutant は南サンドリア〔Ｓ〕D-8・バストゥーク商業区〔Ｓ〕J-9・ウィンダス水の区〔Ｓ〕F-9。得意な合成（釣り以外）を言うと品を1つ言われ、レシピを選んで答える。3問続けて正解で成功。時間制限あり。I 二級連合従軍章所持、合成スキル（釣り以外）のどれかが1以上で受領可能。四択。素人〜見習のクリスタル以外の材料1〜2のレシピ。用語辞典の職業訓練 I（共和国軍）のページ：カーミライド宝石店と民家の間（J-9）の Adjutant に「支援する！」。クリスタル（四択）・材料（四択）・材料（四択）、選んだら変えられない、材料1つのレシピは1つ目で終わる。3問続けて正解で成功、経験値90・連合軍戦績480（FFXIclopedia：Hieronymus E-8、Supply Manufacture、ribbon1、合成のどれかがレベル1、1人、Op Credit 1。Adjutant J-9。3つの品。時間は選択肢が出ているあいだだけ数える）
g01 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに話して、指令書「生産支援」から「職業訓練 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
g02 talk - | バストゥーク商業区〔Ｓ〕(J-9)の軍需監督副官Adjutantに話して、「支援する！」と答え、得意な合成を選ぶ | カーミライド宝石店と民家のあいだにいる。釣りは選べない。 | @バストゥーク商業区〔Ｓ〕 J-9 | T npc.バストゥーク商業区〔Ｓ〕.Adjutant = npc:Adjutant@バストゥーク商業区〔Ｓ〕 J-9
g03 talk - | Adjutantに聞かれた品のクリスタルと材料を順に選んで、1問目に答える | 選択肢は4つずつ。一度選んだら変えられない。材料が1つのレシピは、1つ目の材料で終わる。スキル20までのレシピ（クリスタル以外の材料1〜2）から出る。答えるのに時間制限があり、問題が出たときから数える。遅いか間違えると失敗。時間は選択肢が出ているあいだだけ数えると書く資料もある。 | @バストゥーク商業区〔Ｓ〕 J-9 | T npc.バストゥーク商業区〔Ｓ〕.Adjutant
g04 talk - | Adjutantの2問目に答える | - | @バストゥーク商業区〔Ｓ〕 J-9 | T npc.バストゥーク商業区〔Ｓ〕.Adjutant
g05 talk - | Adjutantの3問目に答える。3問続けて正解すると成功で、経験値が入る | - | @バストゥーク商業区〔Ｓ〕 J-9 | T npc.バストゥーク商業区〔Ｓ〕.Adjutant
g06 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに報告して、連合軍戦績をもらうと完了 | - | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus

@ mission.campaign.049 https://wiki.ffo.jp/html/14070.html
Q Crystal Fist I (S) | 職業訓練 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 57
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が二級連合従軍章以上
LK condition:合成スキルのどれか（釣り以外）が1以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crystal_Fist_I_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Supply manufacture、Bronze Ribbon of Service §。Adjutant（D-8）で合成を選び、3つの品のクリスタルと材料2つを答える。時間制限あり。経験値90・連合軍戦績480。用語辞典の職業訓練のページ：指令書「生産支援」、1人、Adjutant は南サンドリア〔Ｓ〕D-8・バストゥーク商業区〔Ｓ〕J-9・ウィンダス水の区〔Ｓ〕F-9。得意な合成（釣り以外）を言うと品を1つ言われ、レシピを選んで答える。3問続けて正解で成功。時間制限あり。I 二級連合従軍章所持、合成スキル（釣り以外）のどれかが1以上で受領可能。四択。素人〜見習のクリスタル以外の材料1〜2のレシピ。用語辞典の職業訓練 I（王国軍）のページ：D-8 は革工ギルドの近く（中ではない）の Adjutant に「支援する！」。クリスタル（四択）・材料（四択）・材料（四択）、選んだら変えられない、材料1つのレシピは1つ目で終わる。3問続けて正解で成功、経験値90・連合軍戦績480。時間は1問ごとに問題が出た瞬間から数え、選び終えるまでに使いすぎると失敗（FFXIclopedia：Rasdinice I-9、Supply Manufacture、ribbon1、合成のどれかがレベル1、1人、Op Credit 1。3つの品。時間は選択肢が出ているあいだだけ数える。★ごとに経験値120〜346・戦績482〜693）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「生産支援」から「職業訓練 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(D-8)の軍需監督副官Adjutantに話して、「支援する！」と答え、得意な合成を選ぶ | 革工ギルドの近くの外にいる（中ではない）。釣りは選べない。 | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g03 talk - | Adjutantに聞かれた品のクリスタルと材料を順に選んで、1問目に答える | 選択肢は4つずつ。一度選んだら変えられない。材料が1つのレシピは、1つ目の材料で終わる。スキル20までのレシピ（クリスタル以外の材料1〜2）から出る。答えるのに時間制限があり、問題が出たときから数える。遅いか間違えると失敗。時間は選択肢が出ているあいだだけ数えると書く資料もある。 | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g04 talk - | Adjutantの2問目に答える | - | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g05 talk - | Adjutantの3問目に答える。3問続けて正解すると成功で、経験値が入る | - | @南サンドリア〔Ｓ〕 D-8 | T npc.南サンドリア〔Ｓ〕.Adjutant
g06 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.050 https://wiki.ffo.jp/html/14342.html
Q Pit Spider III (S) | 補給部隊強襲 III（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 58
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級戦功水晶章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる）
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/Pit_Spider_III_(San_d%27Oria);BG Wiki にこのランクのページはない。用語辞典の補給部隊強襲のページ（14342。王国軍の行ごとのページ 14039〜14041 はこのページへ転送）：指令書「侵攻支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章 所持で受領可能。1〜6人（2015年2月19日から。それまでは3〜6人）、リーダーだけ受ければよく、ほかのメンバーも経験値。受けた人がリーダーになって入る。Beastman Ensign は王国軍ブンカール浦 J-7（常花の石窟）・共和国軍グロウベルグ G-12（ルホッツ銀山）・連邦軍カルゴナルゴ城砦 外 I-8 北西（ゴユの空洞）。Carrier と Guard がゴールへ向かい、着くとデジョンで消える。Carrier に逃げられると失敗、Guard を逃がすと経験値・戦績が減る。入るとすぐ動き出すので強化は外で。Carrier は数割削ると逃げ出すのでグラビデ、ナイトのキャリアはスリプルをレジストすることがある。混んでいて入るのが遅れると、とんずらがないと追いつけない。全滅させて「作戦目標を達成した。」と出てもデジョンで帰ると失敗、START 地点の装置で出る。I 1部隊（Carrier1・Guard2）、II 2部隊が別々のゴール、III Guard4 で黒魔道士あり。経験値3587〜5355、戦績4612〜6885（Guard を全部倒したとき）。成功で自国の士気・軍資金が上がる。（FFXIclopedia：Rasdinice I-9、Offensive operations、emblem2、3〜6人、Op Credit 1。ブンカール浦〔Ｓ〕 の Beastman Ensign J-7 から 常花の石窟。Twilight Aureola から出る。受けていないメンバーは戦績なし）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「侵攻支援」から「補給部隊強襲 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになって入る。ほかの人は受けなくても入れて経験値も入るが、連合軍戦績は受けた人だけ。募集要員を3〜6人と書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | ブンカール浦〔Ｓ〕(J-7)のBeastman Ensignへ行く | 戦績テレポで出る場所から遠く、3分ほど歩く。インビジ・スニークが要る場所を通る。 | @ブンカール浦〔Ｓ〕 J-7 | T obj.ブンカール浦〔Ｓ〕.Beastman_Ensign
g03 examine - | リーダーがBeastman Ensignを調べて、常花の石窟に入る | 入るとすぐ敵の部隊が動き出すので、強化は外でかけておく。制限時間は30分と書く資料もある。 | @ブンカール浦〔Ｓ〕 J-7 | T obj.ブンカール浦〔Ｓ〕.Beastman_Ensign
g04 go - | 入ったらすぐ、動き出した敵の部隊（Orcish CarrierとGuard）に追いつく | エリアが混んでいて入るのが遅れると、もう部隊が進んでいて、とんずらなどがないと追いつけないことがある。先に行く人はリーダーにならないほうがよい。
g05 fight - | 5体ずつ2組（10体）を全部倒す。Carrierを倒せば作戦は成功 | 1組はCarrier（ナイト）とGuard（戦士・竜騎士・黒魔道士・暗黒騎士）、もう1組はCarrier（ナイト）とGuard（モンク・狩人・黒魔道士・暗黒騎士）。CarrierはHPを数割削ると逃げ出す。グラビデで止めて、ウェポンスキルや精霊魔法で一気に倒す。ナイトのCarrierにはスリプルが効かないことがある。Carrierがゴールに着くとデジョンで消えて失敗。Guardを逃がすと経験値と連合軍戦績が減る。2組は別々のゴールへ向かう。片方のCarrierはすぐ逃げ出す。どの組にも黒魔道士のGuardがいて、スリプガやバインドをしてくるので、早めに倒すかサイレスをかける。
g06 examine - | 「作戦目標を達成した。」と出たら、入ったところのTwilight Aureolaを調べて外に出る | デジョンなどで帰ると失敗になる。 | @常花の石窟 | T obj.常花の石窟.Twilight_Aureola = obj:Twilight Aureola@常花の石窟
g07 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.068 https://wiki.ffo.jp/html/14342.html
Q Pit Spider II (S) | 補給部隊強襲 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 59
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が白銀剣勲章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pit_Spider_II_(S);Rasdinice（南サンドリア〔Ｓ〕 I-9）、Offensive operations、Brass Ribbon of Service §§。ブンカール浦〔Ｓ〕 の Beastman Ensign（J-7）から 常花の石窟。Carrier と Guard を全部倒し、Twilight Aureola から出る（ワープで出ると失敗）。制限時間30分。用語辞典の補給部隊強襲のページ（14342。王国軍の行ごとのページ 14039〜14041 はこのページへ転送）：指令書「侵攻支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章 所持で受領可能。1〜6人（2015年2月19日から。それまでは3〜6人）、リーダーだけ受ければよく、ほかのメンバーも経験値。受けた人がリーダーになって入る。Beastman Ensign は王国軍ブンカール浦 J-7（常花の石窟）・共和国軍グロウベルグ G-12（ルホッツ銀山）・連邦軍カルゴナルゴ城砦 外 I-8 北西（ゴユの空洞）。Carrier と Guard がゴールへ向かい、着くとデジョンで消える。Carrier に逃げられると失敗、Guard を逃がすと経験値・戦績が減る。入るとすぐ動き出すので強化は外で。Carrier は数割削ると逃げ出すのでグラビデ、ナイトのキャリアはスリプルをレジストすることがある。混んでいて入るのが遅れると、とんずらがないと追いつけない。全滅させて「作戦目標を達成した。」と出てもデジョンで帰ると失敗、START 地点の装置で出る。I 1部隊（Carrier1・Guard2）、II 2部隊が別々のゴール、III Guard4 で黒魔道士あり。経験値2562〜3825、戦績3587〜5355（Guard を全部倒したとき）。成功で自国の士気・軍資金が上がる。（FFXIclopedia：Rasdinice I-9、Offensive operations、star2、3〜6人、Op Credit 1。ブンカール浦〔Ｓ〕 の Beastman Ensign J-7 から 常花の石窟。Twilight Aureola から出る。受けていないメンバーは戦績なし）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「侵攻支援」から「補給部隊強襲 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになって入る。ほかの人は受けなくても入れて経験値も入るが、連合軍戦績は受けた人だけ。募集要員を3〜6人と書く資料もある。勲章を一級連合従軍章と書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | ブンカール浦〔Ｓ〕(J-7)のBeastman Ensignへ行く | 戦績テレポで出る場所から遠く、3分ほど歩く。インビジ・スニークが要る場所を通る。 | @ブンカール浦〔Ｓ〕 J-7 | T obj.ブンカール浦〔Ｓ〕.Beastman_Ensign
g03 examine - | リーダーがBeastman Ensignを調べて、常花の石窟に入る | 入るとすぐ敵の部隊が動き出すので、強化は外でかけておく。制限時間は30分と書く資料もある。 | @ブンカール浦〔Ｓ〕 J-7 | T obj.ブンカール浦〔Ｓ〕.Beastman_Ensign
g04 go - | 入ったらすぐ、動き出した敵の部隊（Orcish CarrierとGuard）に追いつく | エリアが混んでいて入るのが遅れると、もう部隊が進んでいて、とんずらなどがないと追いつけないことがある。先に行く人はリーダーにならないほうがよい。
g05 fight - | 3体ずつ2組（6体）を全部倒す。Carrierを倒せば作戦は成功 | 1組はCarrier（ナイト）とGuard（戦士・竜騎士）、もう1組はCarrier（ナイト）とGuard（モンク・狩人）。CarrierはHPを数割削ると逃げ出す。グラビデで止めて、ウェポンスキルや精霊魔法で一気に倒す。ナイトのCarrierにはスリプルが効かないことがある。Carrierがゴールに着くとデジョンで消えて失敗。Guardを逃がすと経験値と連合軍戦績が減る。2組は別々のゴールへ向かうので、片方を逃がしやすい。片方のCarrierはすぐ逃げ出す（Guardが倒されたり、グラビデをかけられたりしただけで逃げ始める）。どちらかのCarrierに逃げられると失敗。
g06 examine - | 「作戦目標を達成した。」と出たら、入ったところのTwilight Aureolaを調べて外に出る | デジョンなどで帰ると失敗になる。 | @常花の石窟 | T obj.常花の石窟.Twilight_Aureola
g07 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.069 https://wiki.ffo.jp/html/14342.html
Q Pit Spider I (S) | 補給部隊強襲 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 60
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級連合従軍章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pit_Spider_I_(S);Rasdinice（南サンドリア〔Ｓ〕 I-9）、Offensive operations、Brass Ribbon of Service §§。ブンカール浦〔Ｓ〕 の Beastman Ensign（J-7）から 常花の石窟。Carrier と Guard を全部倒し、Twilight Aureola から出る（ワープで出ると失敗）。制限時間30分。用語辞典の補給部隊強襲のページ（14342。王国軍の行ごとのページ 14039〜14041 はこのページへ転送）：指令書「侵攻支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章 所持で受領可能。1〜6人（2015年2月19日から。それまでは3〜6人）、リーダーだけ受ければよく、ほかのメンバーも経験値。受けた人がリーダーになって入る。Beastman Ensign は王国軍ブンカール浦 J-7（常花の石窟）・共和国軍グロウベルグ G-12（ルホッツ銀山）・連邦軍カルゴナルゴ城砦 外 I-8 北西（ゴユの空洞）。Carrier と Guard がゴールへ向かい、着くとデジョンで消える。Carrier に逃げられると失敗、Guard を逃がすと経験値・戦績が減る。入るとすぐ動き出すので強化は外で。Carrier は数割削ると逃げ出すのでグラビデ、ナイトのキャリアはスリプルをレジストすることがある。混んでいて入るのが遅れると、とんずらがないと追いつけない。全滅させて「作戦目標を達成した。」と出てもデジョンで帰ると失敗、START 地点の装置で出る。I 1部隊（Carrier1・Guard2）、II 2部隊が別々のゴール、III Guard4 で黒魔道士あり。経験値1537〜2295、戦績2562〜3825（Guard を全部倒したとき）。成功で自国の士気・軍資金が上がる。（FFXIclopedia：Rasdinice I-9、Offensive operations、ribbon2、3〜6人、Op Credit 1。ブンカール浦〔Ｓ〕 の Beastman Ensign J-7 から 常花の石窟。Twilight Aureola から出る。受けていないメンバーは戦績なし）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「侵攻支援」から「補給部隊強襲 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになって入る。ほかの人は受けなくても入れて経験値も入るが、連合軍戦績は受けた人だけ。募集要員を3〜6人と書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | ブンカール浦〔Ｓ〕(J-7)のBeastman Ensignへ行く | 戦績テレポで出る場所から遠く、3分ほど歩く。インビジ・スニークが要る場所を通る。 | @ブンカール浦〔Ｓ〕 J-7 | T obj.ブンカール浦〔Ｓ〕.Beastman_Ensign
g03 examine - | リーダーがBeastman Ensignを調べて、常花の石窟に入る | 入るとすぐ敵の部隊が動き出すので、強化は外でかけておく。制限時間は30分と書く資料もある。 | @ブンカール浦〔Ｓ〕 J-7 | T obj.ブンカール浦〔Ｓ〕.Beastman_Ensign
g04 go - | 入ったらすぐ、動き出した敵の部隊（Orcish CarrierとGuard）に追いつく | エリアが混んでいて入るのが遅れると、もう部隊が進んでいて、とんずらなどがないと追いつけないことがある。先に行く人はリーダーにならないほうがよい。
g05 fight - | 3体（Carrier1体とGuard2体）の1組を全部倒す。Carrierを倒せば作戦は成功 | Carrierはナイト、Guardは戦士・竜騎士。CarrierはHPを数割削ると逃げ出す。グラビデで止めて、ウェポンスキルや精霊魔法で一気に倒す。ナイトのCarrierにはスリプルが効かないことがある。Carrierがゴールに着くとデジョンで消えて失敗。Guardを逃がすと経験値と連合軍戦績が減る。
g06 examine - | 「作戦目標を達成した。」と出たら、入ったところのTwilight Aureolaを調べて外に出る | デジョンなどで帰ると失敗になる。 | @常花の石窟 | T obj.常花の石窟.Twilight_Aureola
g07 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.070 https://wiki.ffo.jp/html/14342.html
Q Pit Spider III (B) | 補給部隊強襲 III（共和国軍） | yes | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
MN - 61
LK quest:過去世界クエスト「第四共和軍団入団試験」をクリアして、第四共和軍団（共和国軍）に入っている
LK condition:所属軍が共和国軍
LK condition:勲章が一級戦功水晶章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pit_Spider_III_(B);Hieronymus（バストゥーク商業区〔Ｓ〕 I-9 と書く）、Offensive operations、Iron Emblem of Service §§。グロウベルグ〔Ｓ〕 の Beastman Ensign（G-12）から ルホッツ銀山。Carrier と Guard を全部倒し、Twilight Aureola から出る（ワープで出ると失敗）。用語辞典の補給部隊強襲のページ（14342。王国軍の行ごとのページ 14039〜14041 はこのページへ転送）：指令書「侵攻支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章 所持で受領可能。1〜6人（2015年2月19日から。それまでは3〜6人）、リーダーだけ受ければよく、ほかのメンバーも経験値。受けた人がリーダーになって入る。Beastman Ensign は王国軍ブンカール浦 J-7（常花の石窟）・共和国軍グロウベルグ G-12（ルホッツ銀山）・連邦軍カルゴナルゴ城砦 外 I-8 北西（ゴユの空洞）。Carrier と Guard がゴールへ向かい、着くとデジョンで消える。Carrier に逃げられると失敗、Guard を逃がすと経験値・戦績が減る。入るとすぐ動き出すので強化は外で。Carrier は数割削ると逃げ出すのでグラビデ、ナイトのキャリアはスリプルをレジストすることがある。混んでいて入るのが遅れると、とんずらがないと追いつけない。全滅させて「作戦目標を達成した。」と出てもデジョンで帰ると失敗、START 地点の装置で出る。I 1部隊（Carrier1・Guard2）、II 2部隊が別々のゴール、III Guard4 で黒魔道士あり。経験値3587〜5355、戦績4612〜6885（Guard を全部倒したとき）。成功で自国の士気・軍資金が上がる。（FFXIclopedia：Hieronymus E-8、Offensive operations、emblem2、3〜6人、Op Credit 1。グロウベルグ〔Ｓ〕 の Beastman Ensign G-12 から ルホッツ銀山。Twilight Aureola から出る。受けていないメンバーは戦績なし）
g01 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに話して、指令書「侵攻支援」から「補給部隊強襲 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになって入る。ほかの人は受けなくても入れて経験値も入るが、連合軍戦績は受けた人だけ。募集要員を3〜6人と書く資料もある。受付の場所をI-9と書く資料もある。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
g02 go - | グロウベルグ〔Ｓ〕(G-12)のBeastman Ensignへ行く | 戦績テレポで出る場所から遠く、3分ほど歩く。インビジ・スニークが要る場所を通る。ロランベリー耕地〔Ｓ〕から入ると書く資料もある。 | @グロウベルグ〔Ｓ〕 G-12 | T obj.グロウベルグ〔Ｓ〕.Beastman_Ensign = obj:Beastman Ensign@グロウベルグ〔Ｓ〕 G-12
g03 examine - | リーダーがBeastman Ensignを調べて、ルホッツ銀山に入る | 入るとすぐ敵の部隊が動き出すので、強化は外でかけておく。制限時間は30分と書く資料もある。 | @グロウベルグ〔Ｓ〕 G-12 | T obj.グロウベルグ〔Ｓ〕.Beastman_Ensign
g04 go - | 入ったらすぐ、動き出した敵の部隊（Quadav CarrierとGuard）に追いつく | エリアが混んでいて入るのが遅れると、もう部隊が進んでいて、とんずらなどがないと追いつけないことがある。先に行く人はリーダーにならないほうがよい。
g05 fight - | 5体ずつ2組（10体）を全部倒す。Carrierを倒せば作戦は成功 | 1組はCarrier（ナイト）とGuard（戦士・赤魔道士・黒魔道士・暗黒騎士）、もう1組はCarrier（ナイト）とGuard（白魔道士・シーフ・黒魔道士・暗黒騎士）。CarrierはHPを数割削ると逃げ出す。グラビデで止めて、ウェポンスキルや精霊魔法で一気に倒す。ナイトのCarrierにはスリプルが効かないことがある。Carrierがゴールに着くとデジョンで消えて失敗。Guardを逃がすと経験値と連合軍戦績が減る。2組は別々のゴールへ向かう。片方のCarrierはすぐ逃げ出す。どの組にも黒魔道士のGuardがいて、スリプガやバインドをしてくるので、早めに倒すかサイレスをかける。
g06 examine - | 「作戦目標を達成した。」と出たら、入ったところのTwilight Aureolaを調べて外に出る | デジョンなどで帰ると失敗になる。 | @ルホッツ銀山 | T obj.ルホッツ銀山.Twilight_Aureola = obj:Twilight Aureola@ルホッツ銀山
g07 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus

@ mission.campaign.071 https://wiki.ffo.jp/html/14342.html
Q Pit Spider II (B) | 補給部隊強襲 II（共和国軍） | yes | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
MN - 62
LK quest:過去世界クエスト「第四共和軍団入団試験」をクリアして、第四共和軍団（共和国軍）に入っている
LK condition:所属軍が共和国軍
LK condition:勲章が白銀剣勲章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pit_Spider_II_(B);Hieronymus（バストゥーク商業区〔Ｓ〕 I-9 と書く）、Offensive operations、Sterling Star §§。グロウベルグ〔Ｓ〕 の Beastman Ensign（G-12）から ルホッツ銀山。Carrier と Guard を全部倒し、Twilight Aureola から出る（ワープで出ると失敗）。用語辞典の補給部隊強襲のページ（14342。王国軍の行ごとのページ 14039〜14041 はこのページへ転送）：指令書「侵攻支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章 所持で受領可能。1〜6人（2015年2月19日から。それまでは3〜6人）、リーダーだけ受ければよく、ほかのメンバーも経験値。受けた人がリーダーになって入る。Beastman Ensign は王国軍ブンカール浦 J-7（常花の石窟）・共和国軍グロウベルグ G-12（ルホッツ銀山）・連邦軍カルゴナルゴ城砦 外 I-8 北西（ゴユの空洞）。Carrier と Guard がゴールへ向かい、着くとデジョンで消える。Carrier に逃げられると失敗、Guard を逃がすと経験値・戦績が減る。入るとすぐ動き出すので強化は外で。Carrier は数割削ると逃げ出すのでグラビデ、ナイトのキャリアはスリプルをレジストすることがある。混んでいて入るのが遅れると、とんずらがないと追いつけない。全滅させて「作戦目標を達成した。」と出てもデジョンで帰ると失敗、START 地点の装置で出る。I 1部隊（Carrier1・Guard2）、II 2部隊が別々のゴール、III Guard4 で黒魔道士あり。経験値2562〜3825、戦績3587〜5355（Guard を全部倒したとき）。成功で自国の士気・軍資金が上がる。（FFXIclopedia：Hieronymus E-8、Offensive operations、star2、3〜6人、Op Credit 1。グロウベルグ〔Ｓ〕 の Beastman Ensign G-12 から ルホッツ銀山。Twilight Aureola から出る。受けていないメンバーは戦績なし）
g01 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに話して、指令書「侵攻支援」から「補給部隊強襲 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになって入る。ほかの人は受けなくても入れて経験値も入るが、連合軍戦績は受けた人だけ。募集要員を3〜6人と書く資料もある。受付の場所をI-9と書く資料もある。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
g02 go - | グロウベルグ〔Ｓ〕(G-12)のBeastman Ensignへ行く | 戦績テレポで出る場所から遠く、3分ほど歩く。インビジ・スニークが要る場所を通る。ロランベリー耕地〔Ｓ〕から入ると書く資料もある。 | @グロウベルグ〔Ｓ〕 G-12 | T obj.グロウベルグ〔Ｓ〕.Beastman_Ensign
g03 examine - | リーダーがBeastman Ensignを調べて、ルホッツ銀山に入る | 入るとすぐ敵の部隊が動き出すので、強化は外でかけておく。制限時間は30分と書く資料もある。 | @グロウベルグ〔Ｓ〕 G-12 | T obj.グロウベルグ〔Ｓ〕.Beastman_Ensign
g04 go - | 入ったらすぐ、動き出した敵の部隊（Quadav CarrierとGuard）に追いつく | エリアが混んでいて入るのが遅れると、もう部隊が進んでいて、とんずらなどがないと追いつけないことがある。先に行く人はリーダーにならないほうがよい。
g05 fight - | 3体ずつ2組（6体）を全部倒す。Carrierを倒せば作戦は成功 | 1組はCarrier（ナイト）とGuard（戦士・赤魔道士）、もう1組はCarrier（ナイト）とGuard（白魔道士・シーフ）。CarrierはHPを数割削ると逃げ出す。グラビデで止めて、ウェポンスキルや精霊魔法で一気に倒す。ナイトのCarrierにはスリプルが効かないことがある。Carrierがゴールに着くとデジョンで消えて失敗。Guardを逃がすと経験値と連合軍戦績が減る。2組は別々のゴールへ向かうので、片方を逃がしやすい。片方のCarrierはすぐ逃げ出す（Guardが倒されたり、グラビデをかけられたりしただけで逃げ始める）。どちらかのCarrierに逃げられると失敗。
g06 examine - | 「作戦目標を達成した。」と出たら、入ったところのTwilight Aureolaを調べて外に出る | デジョンなどで帰ると失敗になる。 | @ルホッツ銀山 | T obj.ルホッツ銀山.Twilight_Aureola
g07 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus

@ mission.campaign.072 https://wiki.ffo.jp/html/14342.html
Q Pit Spider I (B) | 補給部隊強襲 I（共和国軍） | yes | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
MN - 63
LK quest:過去世界クエスト「第四共和軍団入団試験」をクリアして、第四共和軍団（共和国軍）に入っている
LK condition:所属軍が共和国軍
LK condition:勲章が一級連合従軍章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pit_Spider_I_(B);Hieronymus（バストゥーク商業区〔Ｓ〕 I-9 と書く）、Offensive operations、Brass Ribbon of Service §§。グロウベルグ〔Ｓ〕 の Beastman Ensign（G-12）から ルホッツ銀山。Carrier と Guard を全部倒し、Twilight Aureola から出る（ワープで出ると失敗）。用語辞典の補給部隊強襲のページ（14342。王国軍の行ごとのページ 14039〜14041 はこのページへ転送）：指令書「侵攻支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章 所持で受領可能。1〜6人（2015年2月19日から。それまでは3〜6人）、リーダーだけ受ければよく、ほかのメンバーも経験値。受けた人がリーダーになって入る。Beastman Ensign は王国軍ブンカール浦 J-7（常花の石窟）・共和国軍グロウベルグ G-12（ルホッツ銀山）・連邦軍カルゴナルゴ城砦 外 I-8 北西（ゴユの空洞）。Carrier と Guard がゴールへ向かい、着くとデジョンで消える。Carrier に逃げられると失敗、Guard を逃がすと経験値・戦績が減る。入るとすぐ動き出すので強化は外で。Carrier は数割削ると逃げ出すのでグラビデ、ナイトのキャリアはスリプルをレジストすることがある。混んでいて入るのが遅れると、とんずらがないと追いつけない。全滅させて「作戦目標を達成した。」と出てもデジョンで帰ると失敗、START 地点の装置で出る。I 1部隊（Carrier1・Guard2）、II 2部隊が別々のゴール、III Guard4 で黒魔道士あり。経験値1537〜2295、戦績2562〜3825（Guard を全部倒したとき）。成功で自国の士気・軍資金が上がる。（FFXIclopedia：Hieronymus E-8、Offensive operations、ribbon2、3〜6人、Op Credit 1。グロウベルグ〔Ｓ〕 の Beastman Ensign G-12 から ルホッツ銀山。Twilight Aureola から出る。受けていないメンバーは戦績なし）
g01 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに話して、指令書「侵攻支援」から「補給部隊強襲 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになって入る。ほかの人は受けなくても入れて経験値も入るが、連合軍戦績は受けた人だけ。募集要員を3〜6人と書く資料もある。受付の場所をI-9と書く資料もある。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
g02 go - | グロウベルグ〔Ｓ〕(G-12)のBeastman Ensignへ行く | 戦績テレポで出る場所から遠く、3分ほど歩く。インビジ・スニークが要る場所を通る。ロランベリー耕地〔Ｓ〕から入ると書く資料もある。 | @グロウベルグ〔Ｓ〕 G-12 | T obj.グロウベルグ〔Ｓ〕.Beastman_Ensign
g03 examine - | リーダーがBeastman Ensignを調べて、ルホッツ銀山に入る | 入るとすぐ敵の部隊が動き出すので、強化は外でかけておく。制限時間は30分と書く資料もある。 | @グロウベルグ〔Ｓ〕 G-12 | T obj.グロウベルグ〔Ｓ〕.Beastman_Ensign
g04 go - | 入ったらすぐ、動き出した敵の部隊（Quadav CarrierとGuard）に追いつく | エリアが混んでいて入るのが遅れると、もう部隊が進んでいて、とんずらなどがないと追いつけないことがある。先に行く人はリーダーにならないほうがよい。
g05 fight - | 3体（Carrier1体とGuard2体）の1組を全部倒す。Carrierを倒せば作戦は成功 | Carrierはナイト、Guardは戦士・赤魔道士。CarrierはHPを数割削ると逃げ出す。グラビデで止めて、ウェポンスキルや精霊魔法で一気に倒す。ナイトのCarrierにはスリプルが効かないことがある。Carrierがゴールに着くとデジョンで消えて失敗。Guardを逃がすと経験値と連合軍戦績が減る。
g06 examine - | 「作戦目標を達成した。」と出たら、入ったところのTwilight Aureolaを調べて外に出る | デジョンなどで帰ると失敗になる。 | @ルホッツ銀山 | T obj.ルホッツ銀山.Twilight_Aureola
g07 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus

@ mission.campaign.073 https://wiki.ffo.jp/html/14342.html
Q Pit Spider III (W) | 補給部隊強襲 III（連邦軍） | yes | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
MN - 64
LK quest:過去世界クエスト「コブラ傭兵団入団試験」をクリアして、コブラ傭兵団（連邦軍）に入っている
LK condition:所属軍が連邦軍
LK condition:勲章が一級戦功水晶章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pit_Spider_III_(W);Emhi Tchaoryo（ウィンダス水の区〔Ｓ〕 H-9）、Offensive operations、Iron Emblem of Service §§。カルゴナルゴ城砦〔Ｓ〕 の Beastman Ensign（I-8）から ゴユの空洞。Carrier と Guard を全部倒し、Twilight Aureola から出る（ワープで出ると失敗）。用語辞典の補給部隊強襲のページ（14342。王国軍の行ごとのページ 14039〜14041 はこのページへ転送）：指令書「侵攻支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章 所持で受領可能。1〜6人（2015年2月19日から。それまでは3〜6人）、リーダーだけ受ければよく、ほかのメンバーも経験値。受けた人がリーダーになって入る。Beastman Ensign は王国軍ブンカール浦 J-7（常花の石窟）・共和国軍グロウベルグ G-12（ルホッツ銀山）・連邦軍カルゴナルゴ城砦 外 I-8 北西（ゴユの空洞）。Carrier と Guard がゴールへ向かい、着くとデジョンで消える。Carrier に逃げられると失敗、Guard を逃がすと経験値・戦績が減る。入るとすぐ動き出すので強化は外で。Carrier は数割削ると逃げ出すのでグラビデ、ナイトのキャリアはスリプルをレジストすることがある。混んでいて入るのが遅れると、とんずらがないと追いつけない。全滅させて「作戦目標を達成した。」と出てもデジョンで帰ると失敗、START 地点の装置で出る。I 1部隊（Carrier1・Guard2）、II 2部隊が別々のゴール、III Guard4 で黒魔道士あり。経験値3587〜5355、戦績4612〜6885（Guard を全部倒したとき）。成功で自国の士気・軍資金が上がる。（FFXIclopedia：Emhi Tchaoryo H-9、Offensive operations、emblem2、3〜6人、Op Credit 1。カルゴナルゴ城砦〔Ｓ〕 の Beastman Ensign H-8/I-8 のさかい から ゴユの空洞。Twilight Aureola から出る。受けていないメンバーは戦績なし。制限時間30分。出るときメンバーが近くにいないと経験値が入らない）
g01 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに話して、指令書「侵攻支援」から「補給部隊強襲 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになって入る。ほかの人は受けなくても入れて経験値も入るが、連合軍戦績は受けた人だけ。募集要員を3〜6人と書く資料もある。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
g02 go - | カルゴナルゴ城砦〔Ｓ〕MAP1(I-8)のBeastman Ensignへ行く | 砦の外、I-8の北西のはし（H-8とのさかい）。戦績テレポで出る場所から比較的近い。 | @カルゴナルゴ城砦〔Ｓ〕 I-8 #1 | T obj.カルゴナルゴ城砦〔Ｓ〕.Beastman_Ensign = obj:Beastman Ensign@カルゴナルゴ城砦〔Ｓ〕 I-8 #1
g03 examine - | リーダーがBeastman Ensignを調べて、ゴユの空洞に入る | 入るとすぐ敵の部隊が動き出すので、強化は外でかけておく。中ではフェイスを呼べないと書く資料もある。制限時間は30分と書く資料もある。 | @カルゴナルゴ城砦〔Ｓ〕 I-8 #1 | T obj.カルゴナルゴ城砦〔Ｓ〕.Beastman_Ensign
g04 go - | 入ったらすぐ、動き出した敵の部隊（Yagudo CarrierとGuard）に追いつく | エリアが混んでいて入るのが遅れると、もう部隊が進んでいて、とんずらなどがないと追いつけないことがある。先に行く人はリーダーにならないほうがよい。
g05 fight - | 5体ずつ2組（10体）を全部倒す。Carrierを倒せば作戦は成功 | 1組はCarrier（侍）とGuard（白魔道士・吟遊詩人・黒魔道士・忍者）、もう1組はCarrier（侍）とGuard（モンク・白魔道士・黒魔道士・忍者）。CarrierはHPを数割削ると逃げ出す。グラビデで止めて、ウェポンスキルや精霊魔法で一気に倒す。Carrierがゴールに着くとデジョンで消えて失敗。Guardを逃がすと経験値と連合軍戦績が減る。2組は別々のゴールへ向かう。片方のCarrierはすぐ逃げ出す。どの組にも黒魔道士のGuardがいて、スリプガやバインドをしてくるので、早めに倒すかサイレスをかける。
g06 examine - | 「作戦目標を達成した。」と出たら、入ったところのTwilight Aureolaを調べて外に出る | デジョンなどで帰ると失敗になる。出るときにメンバーが近くにいないと経験値が入らないと書く資料もある。 | @ゴユの空洞 | T obj.ゴユの空洞.Twilight_Aureola = obj:Twilight Aureola@ゴユの空洞
g07 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo

@ mission.campaign.074 https://wiki.ffo.jp/html/14342.html
Q Pit Spider II (W) | 補給部隊強襲 II（連邦軍） | yes | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
MN - 65
LK quest:過去世界クエスト「コブラ傭兵団入団試験」をクリアして、コブラ傭兵団（連邦軍）に入っている
LK condition:所属軍が連邦軍
LK condition:勲章が白銀剣勲章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pit_Spider_II_(W);Emhi Tchaoryo（ウィンダス水の区〔Ｓ〕 H-9）、Offensive operations、Brass Ribbon of Service §§。カルゴナルゴ城砦〔Ｓ〕 の Beastman Ensign（I-8）から ゴユの空洞。Carrier と Guard を全部倒し、Twilight Aureola から出る（ワープで出ると失敗）。制限時間30分。フェイスは呼べない（W）。用語辞典の補給部隊強襲のページ（14342。王国軍の行ごとのページ 14039〜14041 はこのページへ転送）：指令書「侵攻支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章 所持で受領可能。1〜6人（2015年2月19日から。それまでは3〜6人）、リーダーだけ受ければよく、ほかのメンバーも経験値。受けた人がリーダーになって入る。Beastman Ensign は王国軍ブンカール浦 J-7（常花の石窟）・共和国軍グロウベルグ G-12（ルホッツ銀山）・連邦軍カルゴナルゴ城砦 外 I-8 北西（ゴユの空洞）。Carrier と Guard がゴールへ向かい、着くとデジョンで消える。Carrier に逃げられると失敗、Guard を逃がすと経験値・戦績が減る。入るとすぐ動き出すので強化は外で。Carrier は数割削ると逃げ出すのでグラビデ、ナイトのキャリアはスリプルをレジストすることがある。混んでいて入るのが遅れると、とんずらがないと追いつけない。全滅させて「作戦目標を達成した。」と出てもデジョンで帰ると失敗、START 地点の装置で出る。I 1部隊（Carrier1・Guard2）、II 2部隊が別々のゴール、III Guard4 で黒魔道士あり。経験値2562〜3825、戦績3587〜5355（Guard を全部倒したとき）。成功で自国の士気・軍資金が上がる。（FFXIclopedia：Emhi Tchaoryo H-9、Offensive operations、star2、3〜6人、Op Credit 1。カルゴナルゴ城砦〔Ｓ〕 の Beastman Ensign H-8/I-8 のさかい から ゴユの空洞。Twilight Aureola から出る。受けていないメンバーは戦績なし。制限時間30分。出るときメンバーが近くにいないと経験値が入らない）
g01 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに話して、指令書「侵攻支援」から「補給部隊強襲 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになって入る。ほかの人は受けなくても入れて経験値も入るが、連合軍戦績は受けた人だけ。募集要員を3〜6人と書く資料もある。勲章を一級連合従軍章と書く資料もある。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
g02 go - | カルゴナルゴ城砦〔Ｓ〕MAP1(I-8)のBeastman Ensignへ行く | 砦の外、I-8の北西のはし（H-8とのさかい）。戦績テレポで出る場所から比較的近い。 | @カルゴナルゴ城砦〔Ｓ〕 I-8 #1 | T obj.カルゴナルゴ城砦〔Ｓ〕.Beastman_Ensign
g03 examine - | リーダーがBeastman Ensignを調べて、ゴユの空洞に入る | 入るとすぐ敵の部隊が動き出すので、強化は外でかけておく。中ではフェイスを呼べないと書く資料もある。制限時間は30分と書く資料もある。 | @カルゴナルゴ城砦〔Ｓ〕 I-8 #1 | T obj.カルゴナルゴ城砦〔Ｓ〕.Beastman_Ensign
g04 go - | 入ったらすぐ、動き出した敵の部隊（Yagudo CarrierとGuard）に追いつく | エリアが混んでいて入るのが遅れると、もう部隊が進んでいて、とんずらなどがないと追いつけないことがある。先に行く人はリーダーにならないほうがよい。
g05 fight - | 3体ずつ2組（6体）を全部倒す。Carrierを倒せば作戦は成功 | 1組はCarrier（侍）とGuard（白魔道士・吟遊詩人）、もう1組はCarrier（侍）とGuard（モンク・白魔道士）。CarrierはHPを数割削ると逃げ出す。グラビデで止めて、ウェポンスキルや精霊魔法で一気に倒す。Carrierがゴールに着くとデジョンで消えて失敗。Guardを逃がすと経験値と連合軍戦績が減る。2組は別々のゴールへ向かうので、片方を逃がしやすい。片方のCarrierはすぐ逃げ出す（Guardが倒されたり、グラビデをかけられたりしただけで逃げ始める）。どちらかのCarrierに逃げられると失敗。
g06 examine - | 「作戦目標を達成した。」と出たら、入ったところのTwilight Aureolaを調べて外に出る | デジョンなどで帰ると失敗になる。出るときにメンバーが近くにいないと経験値が入らないと書く資料もある。 | @ゴユの空洞 | T obj.ゴユの空洞.Twilight_Aureola
g07 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo

@ mission.campaign.075 https://wiki.ffo.jp/html/14342.html
Q Pit Spider I (W) | 補給部隊強襲 I（連邦軍） | yes | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
MN - 66
LK quest:過去世界クエスト「コブラ傭兵団入団試験」をクリアして、コブラ傭兵団（連邦軍）に入っている
LK condition:所属軍が連邦軍
LK condition:勲章が一級連合従軍章以上
LK condition:募集要員は1〜6人（opsを受けるのはリーダーだけでよい）
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Pit_Spider_I_(W);Emhi Tchaoryo（ウィンダス水の区〔Ｓ〕 H-9）、Offensive operations、Brass Ribbon of Service §§。カルゴナルゴ城砦〔Ｓ〕 の Beastman Ensign（I-8）から ゴユの空洞。Carrier と Guard を全部倒し、Twilight Aureola から出る（ワープで出ると失敗）。制限時間30分。用語辞典の補給部隊強襲のページ（14342。王国軍の行ごとのページ 14039〜14041 はこのページへ転送）：指令書「侵攻支援」、I 一級連合従軍章・II 白銀剣勲章・III 一級戦功水晶章 所持で受領可能。1〜6人（2015年2月19日から。それまでは3〜6人）、リーダーだけ受ければよく、ほかのメンバーも経験値。受けた人がリーダーになって入る。Beastman Ensign は王国軍ブンカール浦 J-7（常花の石窟）・共和国軍グロウベルグ G-12（ルホッツ銀山）・連邦軍カルゴナルゴ城砦 外 I-8 北西（ゴユの空洞）。Carrier と Guard がゴールへ向かい、着くとデジョンで消える。Carrier に逃げられると失敗、Guard を逃がすと経験値・戦績が減る。入るとすぐ動き出すので強化は外で。Carrier は数割削ると逃げ出すのでグラビデ、ナイトのキャリアはスリプルをレジストすることがある。混んでいて入るのが遅れると、とんずらがないと追いつけない。全滅させて「作戦目標を達成した。」と出てもデジョンで帰ると失敗、START 地点の装置で出る。I 1部隊（Carrier1・Guard2）、II 2部隊が別々のゴール、III Guard4 で黒魔道士あり。経験値1537〜2295、戦績2562〜3825（Guard を全部倒したとき）。成功で自国の士気・軍資金が上がる。（FFXIclopedia：Emhi Tchaoryo H-9、Offensive operations、ribbon2、1〜6人、Op Credit 1。カルゴナルゴ城砦〔Ｓ〕 の Beastman Ensign H-8/I-8 のさかい から ゴユの空洞。Twilight Aureola から出る。受けていないメンバーは戦績なし。制限時間30分。出るときメンバーが近くにいないと経験値が入らない）
g01 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに話して、指令書「侵攻支援」から「補給部隊強襲 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。受けた人がパーティのリーダーになって入る。ほかの人は受けなくても入れて経験値も入るが、連合軍戦績は受けた人だけ。募集要員を3〜6人と書く資料もある。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo
g02 go - | カルゴナルゴ城砦〔Ｓ〕MAP1(I-8)のBeastman Ensignへ行く | 砦の外、I-8の北西のはし（H-8とのさかい）。戦績テレポで出る場所から比較的近い。 | @カルゴナルゴ城砦〔Ｓ〕 I-8 #1 | T obj.カルゴナルゴ城砦〔Ｓ〕.Beastman_Ensign
g03 examine - | リーダーがBeastman Ensignを調べて、ゴユの空洞に入る | 入るとすぐ敵の部隊が動き出すので、強化は外でかけておく。中ではフェイスを呼べないと書く資料もある。制限時間は30分と書く資料もある。 | @カルゴナルゴ城砦〔Ｓ〕 I-8 #1 | T obj.カルゴナルゴ城砦〔Ｓ〕.Beastman_Ensign
g04 go - | 入ったらすぐ、動き出した敵の部隊（Yagudo CarrierとGuard）に追いつく | エリアが混んでいて入るのが遅れると、もう部隊が進んでいて、とんずらなどがないと追いつけないことがある。先に行く人はリーダーにならないほうがよい。
g05 fight - | 3体（Carrier1体とGuard2体）の1組を全部倒す。Carrierを倒せば作戦は成功 | Carrierは侍、Guardは白魔道士・吟遊詩人。CarrierはHPを数割削ると逃げ出す。グラビデで止めて、ウェポンスキルや精霊魔法で一気に倒す。Carrierがゴールに着くとデジョンで消えて失敗。Guardを逃がすと経験値と連合軍戦績が減る。
g06 examine - | 「作戦目標を達成した。」と出たら、入ったところのTwilight Aureolaを調べて外に出る | デジョンなどで帰ると失敗になる。出るときにメンバーが近くにいないと経験値が入らないと書く資料もある。 | @ゴユの空洞 | T obj.ゴユの空洞.Twilight_Aureola
g07 talk - | ウィンダス水の区〔Ｓ〕北(H-9)のEmhi Tchaoryoに報告して、連合軍戦績をもらうと完了 | 連合軍戦績がもらえるのは受けた人だけ。 | @ウィンダス水の区〔Ｓ〕 H-9 #1 | T npc.ウィンダス水の区〔Ｓ〕.Emhi_Tchaoryo

@ mission.campaign.051 https://wiki.ffo.jp/html/14062.html
Q Materiel Storm III (S) | 軍需品調達 III（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 67
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級戦功水晶章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Materiel_Storm_III_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Resource procurement、Iron Emblem of Service §§。Quartermaster は I-9。パーティだとメンバーごとに別の品を言われる。Deodorizer x5・Echo Drops x3・Eye Drops x3・Hi-Potion・Holy Water x3・Poison Potion x2・Potion x4・Silencing Potion x2・Silent Oil x5・Venom Potion。経験値340・戦績980。勲章は Iron Emblem of Service §§（emblem2）。用語辞典の軍需品調達のページ（14334）：指令書「物資確保」、1人、各国の補給担当官 Quartermaster に品を言われて調達しトレードする。品は三国共通。自作の HQ 品は渡せない。III 一級戦功水晶章所持で受領可能。薬品類16種。経験値1266〜1890・戦績1628〜2430。用語辞典の軍需品調達 III（王国軍）のページ：H-9 の Quartermaster、用語辞典の16種のどれか。★ごとに経験値361〜513・戦績994〜1410（FFXIclopedia：Rasdinice I-9、Resource Procurement、emblem2、1人、Op Credit 1。Quartermaster H-9。HQ品は受け取らない。★1で経験値361・戦績994ほど）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「物資確保」から「軍需品調達 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(H-9)のQuartermasterに話して、集める品を聞く | 次のどれかを言われる：エーテル・ハイポーション・猛毒薬 各1個、暗闇薬・昏睡薬・しびれ薬・沈黙薬・毒薬 各2個、聖水・毒消し・目薬・やまびこ薬 各3個、ポーション4個、サイレントオイル・デオドライザー・プリズムパウダー 各5個。場所をI-9と書く資料もある。パーティで受けるとメンバーごとにちがう品を言われると書く資料もある。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。薬品は競売で買うのが安い。錬金術で作ってもよいが、HQ品は渡せない（ポーションやハイポーションはHQだと「+1」になって受け取ってもらえない）。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.052 https://wiki.ffo.jp/html/14061.html
Q Materiel Storm II (S) | 軍需品調達 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 68
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が白銀剣勲章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Materiel_Storm_II_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Resource procurement、Sterling Star §§。Quartermaster は I-9。パーティだとメンバーごとに別の品を言われる。Soy Milk x3・Roasted Almonds x4・Smoked Salmon x6・Baked Popoto x4・Roast Pipira x4・Puls x4・Dhalmel Steak x3・Hard-boiled Egg x12・Boiled Crab x4 など。経験値240・戦績780。勲章は Sterling Star §§（star2）。用語辞典の軍需品調達のページ（14334）：指令書「物資確保」、1人、各国の補給担当官 Quartermaster に品を言われて調達しトレードする。品は三国共通。自作の HQ 品は渡せない。II 白銀剣勲章所持で受領可能。食品やチョコボレース用の品32種（パインジュース4を含む）。用語辞典の軍需品調達 II（王国軍）のページ：H-9 の Quartermaster、31種のどれか（パインジュースはない）。★ごとに経験値271〜400・戦績814〜1202（FFXIclopedia：Rasdinice I-9、Resource Procurement、star2、1人、Op Credit 1。Quartermaster H-9。どれも低いスキルの調理の品。HQ品は受け取らない。★1で経験値240・戦績780ほど）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「物資確保」から「軍需品調達 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(H-9)のQuartermasterに話して、集める品を聞く | 次のどれかを言われる：草粥・サーモンサンド・豆のスープ 各1個、マトンのロースト・野菜のスープ 各2個、ダルメルステーキ・豆乳・ドライベリー 各3個、アップルジュース・石のスープ・オレンジジュース・キノコの塩焼き・シャドウアップル・スタミナアップル・スピードアップル・野兎のグリル・ピピラの塩焼き・フナの塩焼き・プルス・ベークドポポト・ゆでがに・ローストアーモンド 各4個、スモークドサーモン・トルティーヤ・焼きリンゴ 各6個、蜂蜜8個、ザリガニの塩ゆで・干し肉・ゆで卵・ローストコーン 各12個、アーミービスケット33個。パインジュース4個を書く資料もある。場所をI-9と書く資料もある。パーティで受けるとメンバーごとにちがう品を言われると書く資料もある。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。品数が多いので先に全部用意しておくのはむずかしい。店で買えない品も多く、調理スキルがないと大変（30ほどで全部作れる）。HQ品は渡せないので、調理スキルが高い人は初志の指輪がないとNQ品をそろえにくい。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.053 https://wiki.ffo.jp/html/18161.html
Q Materiel Storm IV (S) | 軍需品調達 IV（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 69
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級勲功翼章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Materiel_Storm_IV_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Resource procurement、勲章は Information Needed。Quartermaster は I-9。パーティだとメンバーごとに別の品を言われる。Apple Pie x4・Salmon Roe x6・Eel Kabob・Roast Trout x3・Icecap Rolanberry・Ginger Cookie x33・Bretzel x33。経験値1628・戦績1989。勲章は wings2（FFXIclopedia。BG Wiki は勲章を書いていない）。用語辞典の軍需品調達のページ（14334）：指令書「物資確保」、1人、各国の補給担当官 Quartermaster に品を言われて調達しトレードする。品は三国共通。自作の HQ 品は渡せない。IV 一級勲功翼章所持で受領可能。食品やチョコボレース用の品32種（グレープジュース1を含む）。用語辞典の軍需品調達 IV（王国軍）のページ：H-9 の Quartermaster、31種のどれか（グレープジュースはない）。★ごとに経験値452〜670・戦績1175〜1743（FFXIclopedia：Rasdinice I-9、Resource Procurement、wings2、1人、Op Credit 1。Quartermaster H-9。HQ品は受け取らない。★1で経験値440・戦績1180ほど）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「物資確保」から「軍需品調達 IV」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(H-9)のQuartermasterに話して、集める品を聞く | 次のどれかを言われる：ウィンダス風サラダ・ウナギの串焼・オレンジ・オレ・キノコのスープ・卵のスープ・トマトジュース・トマトスープ・ネビムナイトの壷焼・パママのタルト・ボスディン菜のソテー・メロンジュース・ヤグードドリンク・雪山のロランベリー 各1個、マスの塩焼き3個、アップルパイ・ニシンの塩漬け 各4個、ウィンダス風タコス・サーモンロウ・バタリアキッシュ・ミスラ風海の幸串焼・ミスラ風山の幸串焼 各6個、ペッパークッキー・ホットクッキー 各9個、アイアンパン・黒パン・白パン・野牛の干し肉 各12個、シナモンクッキー・ジンジャークッキー・どんぐりクッキー・ブレーツェル 各33個。グレープジュース1個を書く資料もある。場所をI-9と書く資料もある。パーティで受けるとメンバーごとにちがう品を言われると書く資料もある。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。調理スキル40〜50台の品が多く、スキルが高いとHQになりやすい。HQ品は渡せない。野牛の干し肉12個は高くつく。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.054 https://wiki.ffo.jp/html/14060.html
Q Materiel Storm I (S) | 軍需品調達 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 70
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級連合従軍章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Materiel_Storm_I_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Resource procurement、Brass Ribbon of Service §§。Quartermaster は I-9（Rasdinice を向いて後ろ、テントのそば）。Wind・Fire・Earth・Ice・Light・Dark・Lightning Crystal のどれか x12。経験値810・戦績1350。勲章は Brass Ribbon of Service §§（ribbon2）。用語辞典の軍需品調達のページ（14334）：指令書「物資確保」、1人、各国の補給担当官 Quartermaster に品を言われて調達しトレードする。品は三国共通。自作の HQ 品は渡せない。I 一級連合従軍章所持で受領可能。クリスタル1ダース、属性はランダム。経験値542〜810・戦績904〜1350。用語辞典の軍需品調達 I（王国軍）のページ：H-9 の Quartermaster、クリスタルのどれか一種を12個。入手方法は問われない。★ごとに経験値180〜268・戦績633〜938（FFXIclopedia：Rasdinice I-9、Resource Procurement、ribbon2、1人、Op Credit 1。Quartermaster H-9、属性はランダムのクリスタル12個。★ごとに経験値180〜256・戦績633〜900）
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「物資確保」から「軍需品調達 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 talk - | 南サンドリア〔Ｓ〕(H-9)のQuartermasterに話して、集める品を聞く | クリスタル（どの属性かはランダム）を12個言われる。場所をI-9と書く資料もある。パーティで受けるとメンバーごとにちがう品を言われると書く資料もある。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster
g03 gather - | 言われた品を手に入れる | どこで手に入れてもよい（競売や店で買ってもよい）。どの属性かは毎回変わる。風や土のクリスタルは競売で安いが、光のクリスタルが続くと高くつく。
g04 trade - | Quartermasterに言われた品をトレードする | トレードするとすぐに経験値が入る。 | @南サンドリア〔Ｓ〕 H-9 | T npc.南サンドリア〔Ｓ〕.Quartermaster
g05 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.055 https://wiki.ffo.jp/html/14068.html
Q Crimson Domino III (S) | 軍需品運搬 III（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 71
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級戦功水晶章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crimson_Domino_III_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Supply transport、Iron Emblem of Service §§（要確認の印）、1〜6人。Gate Sentry 東ロンフォール〔Ｓ〕J-11・ブンカール浦〔Ｓ〕E-7・ジャグナー森林〔Ｓ〕F-5・バタリア丘陵〔Ｓ〕F-8。??? I-11・G-6・F-8・G-8。拠点の NPC H-8・G-10・H-8/I-8・J-8。戦闘すると失敗、絡まれるだけなら失敗しない。時間制限は不明。経験値250・戦績800。（FFXIclopedia：Rasdinice I-9、Supply Transport、emblem2、1人、Op Credit 1。拠点の NPC は Arlayse, R.K.（東ロンフォール〔Ｓ〕H-8）・Roiloux, R.K.（ジャグナー森林〔Ｓ〕I-8、Gate Sentry G-5）・Toulsard, R.K.（ブンカール浦〔Ｓ〕G-10）・Myllue, R.K.（バタリア丘陵〔Ｓ〕J-7）。絡まれても止まって戦わなければ成功。落ちても物資は残る。成功でエリアの戦略物資が3増える。★ごとに経験値361〜538・戦績994〜1480）用語辞典の軍需品運搬のページ（14336）：指令書「輸送運搬」、1人。自国支配エリアの検問所 Gate Sentry で、カンパニエ補給物資を渡されるか、放棄された物資を ??? で探すかのどちらか（ランダム）。??? は王国軍 東ロンフォール〔Ｓ〕I-11・ジャグナー森林〔Ｓ〕F-8・ブンカール浦〔Ｓ〕G-6（洞窟の中）・バタリア丘陵〔Ｓ〕G-8（丘の上）、共通 ボスディン氷河〔Ｓ〕I-7・ザルカバード〔Ｓ〕H-7。「取り扱い注意」なら戦闘不可、「速やかに届けよ」なら時間制限があるようだ。物資を持って拠点のカンパニエ審理官と話せばクリア。エリアで報酬は変わらない。2014年に検問所の近くに Survival Guide、2016年からマウントが使える。III 一級戦功水晶章所持で受領可能。II と同じく条件が付くことが多く、2つ付くこともある。経験値1266〜1890・戦績1628〜2430。用語辞典の軍需品運搬 III（王国軍）のページは指令内容と募集要員1人だけ。
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「輸送運搬」から「軍需品運搬 III」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。募集要員を1〜6人と書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | 王国軍が支配している外のエリアを1つ選んで、そのエリアの検問所のGate Sentryへ行く | どのエリアでも報酬は同じ。Gate Sentryは、東ロンフォール〔Ｓ〕ならJ-11（ジャグナー森林〔Ｓ〕への出口の近く）、ブンカール浦〔Ｓ〕ならE-7、バタリア丘陵〔Ｓ〕ならF-8、ジャグナー森林〔Ｓ〕ならG-5（F-5と書く資料もある）。検問所の近くのSurvival Guideでワープすると早い。
g03 talk - | Gate Sentryに話して、指示を聞く | 「補給の小包だ。」と言われたら、だいじなもの「カンパニエ補給物資」をもらえる。補給隊が襲われたと言われたら、物資は自分で探す。「強い衝撃を与えないように」と言われたら、運ぶあいだ戦ってはいけない（絡まれるだけなら失敗しないと書く資料もある）。「速やかに届けよ」と言われたら時間制限があるようだ。条件が付くことが多く、2つ付くこともある。
g04 examine - | 補給隊が襲われたと言われたときは、エリアの???を調べてカンパニエ補給物資を見つける | ???は、東ロンフォール〔Ｓ〕I-11（オークがうろつく）、ジャグナー森林〔Ｓ〕F-8、ブンカール浦〔Ｓ〕G-6（洞窟の中、コウモリしかいない）、バタリア丘陵〔Ｓ〕G-8（丘の上）、ボスディン氷河〔Ｓ〕I-7、ザルカバード〔Ｓ〕H-7。ほかのクエストなどの???からは取れない。物資をもらえたときは、この手順はない。
g05 go - | カンパニエ補給物資を持って、同じエリアの拠点へ行く | マウントを使うと絡まれずに早く行ける。Survival Guideで帰って戦績テレポで拠点に出てもよい。
g06 talk - | 拠点のカンパニエ審理官（王国軍のガード）に話して物資を渡すと、経験値が入る | 東ロンフォール〔Ｓ〕ならH-8のArlayse, R.K.、ジャグナー森林〔Ｓ〕ならI-8のRoiloux, R.K.、ブンカール浦〔Ｓ〕ならG-10のToulsard, R.K.、バタリア丘陵〔Ｓ〕ならJ-7のMyllue, R.K.（J-8と書く資料もある）。
g07 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.056 https://wiki.ffo.jp/html/14067.html
Q Crimson Domino II (S) | 軍需品運搬 II（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 72
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が白銀剣勲章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crimson_Domino_II_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Supply transport、Sterling Star §§、1〜6人。Gate Sentry 東ロンフォール〔Ｓ〕J-11・ブンカール浦〔Ｓ〕E-7・ジャグナー森林〔Ｓ〕F-5・バタリア丘陵〔Ｓ〕F-8。??? I-11・G-6・F-8・G-8。拠点の NPC H-8・G-10・H-8/I-8・J-8。経験値250・戦績800。（FFXIclopedia：Rasdinice I-9、Supply Transport、star2、1人、Op Credit 1。拠点の NPC は Arlayse, R.K.（東ロンフォール〔Ｓ〕H-8）・Toulsard, R.K.（ブンカール浦〔Ｓ〕G-10）・バタリア丘陵〔Ｓ〕。落ちても物資は残る。★ごとに経験値271〜400・戦績800〜1202）用語辞典の軍需品運搬のページ（14336）：指令書「輸送運搬」、1人。自国支配エリアの検問所 Gate Sentry で、カンパニエ補給物資を渡されるか、放棄された物資を ??? で探すかのどちらか（ランダム）。??? は王国軍 東ロンフォール〔Ｓ〕I-11・ジャグナー森林〔Ｓ〕F-8・ブンカール浦〔Ｓ〕G-6（洞窟の中）・バタリア丘陵〔Ｓ〕G-8（丘の上）、共通 ボスディン氷河〔Ｓ〕I-7・ザルカバード〔Ｓ〕H-7。「取り扱い注意」なら戦闘不可、「速やかに届けよ」なら時間制限があるようだ。物資を持って拠点のカンパニエ審理官と話せばクリア。エリアで報酬は変わらない。2014年に検問所の近くに Survival Guide、2016年からマウントが使える。II 白銀剣勲章所持で受領可能。I より「取り扱い注意」や「速やかに届けよ」の条件が付くことが多いようだ。経験値904〜1350・戦績1266〜1890。用語辞典の軍需品運搬 II（王国軍）のページは指令内容と募集要員1人だけ。
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「輸送運搬」から「軍需品運搬 II」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。募集要員を1〜6人と書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | 王国軍が支配している外のエリアを1つ選んで、そのエリアの検問所のGate Sentryへ行く | どのエリアでも報酬は同じ。Gate Sentryは、東ロンフォール〔Ｓ〕ならJ-11（ジャグナー森林〔Ｓ〕への出口の近く）、ブンカール浦〔Ｓ〕ならE-7、バタリア丘陵〔Ｓ〕ならF-8、ジャグナー森林〔Ｓ〕ならG-5（F-5と書く資料もある）。検問所の近くのSurvival Guideでワープすると早い。
g03 talk - | Gate Sentryに話して、指示を聞く | 「補給の小包だ。」と言われたら、だいじなもの「カンパニエ補給物資」をもらえる。補給隊が襲われたと言われたら、物資は自分で探す。「強い衝撃を与えないように」と言われたら、運ぶあいだ戦ってはいけない（絡まれるだけなら失敗しないと書く資料もある）。「速やかに届けよ」と言われたら時間制限があるようだ。I より条件が付くことが多いようだ。
g04 examine - | 補給隊が襲われたと言われたときは、エリアの???を調べてカンパニエ補給物資を見つける | ???は、東ロンフォール〔Ｓ〕I-11（オークがうろつく）、ジャグナー森林〔Ｓ〕F-8、ブンカール浦〔Ｓ〕G-6（洞窟の中、コウモリしかいない）、バタリア丘陵〔Ｓ〕G-8（丘の上）、ボスディン氷河〔Ｓ〕I-7、ザルカバード〔Ｓ〕H-7。ほかのクエストなどの???からは取れない。物資をもらえたときは、この手順はない。
g05 go - | カンパニエ補給物資を持って、同じエリアの拠点へ行く | マウントを使うと絡まれずに早く行ける。Survival Guideで帰って戦績テレポで拠点に出てもよい。
g06 talk - | 拠点のカンパニエ審理官（王国軍のガード）に話して物資を渡すと、経験値が入る | 東ロンフォール〔Ｓ〕ならH-8のArlayse, R.K.、ジャグナー森林〔Ｓ〕ならI-8のRoiloux, R.K.、ブンカール浦〔Ｓ〕ならG-10のToulsard, R.K.、バタリア丘陵〔Ｓ〕ならJ-7のMyllue, R.K.（J-8と書く資料もある）。
g07 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.057 https://wiki.ffo.jp/html/14066.html
Q Crimson Domino I (S) | 軍需品運搬 I（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 73
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級連合従軍章以上
LK condition:募集要員は1人
RW other:連合軍戦績（受けたときの★の数で変わる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Crimson_Domino_I_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Supply transport、Brass Ribbon of Service §§、1〜6人。Gate Sentry 東ロンフォール〔Ｓ〕J-11・ブンカール浦〔Ｓ〕E-7・バタリア丘陵〔Ｓ〕F-8。??? I-11・G-6・G-8。拠点の NPC H-8・G-10・J-8。経験値150・戦績600。（FFXIclopedia：Rasdinice I-9、Supply Transport、ribbon2、1人、Op Credit 1。Gate Sentry 東ロンフォール〔Ｓ〕J-11・ブンカール浦〔Ｓ〕E-7・バタリア丘陵〔Ｓ〕F-8、拠点の NPC Arlayse, R.K.（H-8）・Toulsard, R.K.（G-10）・Myllue, R.K.（J-7）。★ごとに経験値180〜266・戦績633〜932）用語辞典の軍需品運搬のページ（14336）：指令書「輸送運搬」、1人。自国支配エリアの検問所 Gate Sentry で、カンパニエ補給物資を渡されるか、放棄された物資を ??? で探すかのどちらか（ランダム）。??? は王国軍 東ロンフォール〔Ｓ〕I-11・ジャグナー森林〔Ｓ〕F-8・ブンカール浦〔Ｓ〕G-6（洞窟の中）・バタリア丘陵〔Ｓ〕G-8（丘の上）、共通 ボスディン氷河〔Ｓ〕I-7・ザルカバード〔Ｓ〕H-7。「取り扱い注意」なら戦闘不可、「速やかに届けよ」なら時間制限があるようだ。物資を持って拠点のカンパニエ審理官と話せばクリア。エリアで報酬は変わらない。2014年に検問所の近くに Survival Guide、2016年からマウントが使える。I 一級連合従軍章所持で受領可能。経験値542〜810・戦績904〜1350。用語辞典の軍需品運搬 I（王国軍）のページ：各エリアの Gate Sentry から2通りの指示のどちらか。「補給の小包だ。」なら物資を手渡される。「取り扱いには注意せよ。強い衝撃を与えないようにするのだ。」なら運搬中に戦闘すると失敗。補給隊が襲撃されたと言われたら、エリアの特定の ??? を調べる（ほかのクエストなどの ??? からは取れない）。届け先は同じエリアの拠点の自国軍ガード NPC。東ロンフォール〔Ｓ〕は Gate Sentry J-11 テンキー3、??? I-11 テンキー8（Lv60前後のオークがうろつく）、届け先 H-8 テンキー8 Arlayse,R.K.。任務完了で経験値150、報告で戦績600。時間制限は書いていない（TODO）。
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「輸送運搬」から「軍需品運搬 I」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。募集要員を1〜6人と書く資料もある。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | 王国軍が支配している外のエリアを1つ選んで、そのエリアの検問所のGate Sentryへ行く | どのエリアでも報酬は同じ。Gate Sentryは、東ロンフォール〔Ｓ〕ならJ-11（ジャグナー森林〔Ｓ〕への出口の近く）、ブンカール浦〔Ｓ〕ならE-7、バタリア丘陵〔Ｓ〕ならF-8、ジャグナー森林〔Ｓ〕ならG-5（F-5と書く資料もある）。検問所の近くのSurvival Guideでワープすると早い。
g03 talk - | Gate Sentryに話して、指示を聞く | 「補給の小包だ。」と言われたら、だいじなもの「カンパニエ補給物資」をもらえる。補給隊が襲われたと言われたら、物資は自分で探す。「強い衝撃を与えないように」と言われたら、運ぶあいだ戦ってはいけない（絡まれるだけなら失敗しないと書く資料もある）。「速やかに届けよ」と言われたら時間制限があるようだ。
g04 examine - | 補給隊が襲われたと言われたときは、エリアの???を調べてカンパニエ補給物資を見つける | ???は、東ロンフォール〔Ｓ〕I-11（オークがうろつく）、ジャグナー森林〔Ｓ〕F-8、ブンカール浦〔Ｓ〕G-6（洞窟の中、コウモリしかいない）、バタリア丘陵〔Ｓ〕G-8（丘の上）、ボスディン氷河〔Ｓ〕I-7、ザルカバード〔Ｓ〕H-7。ほかのクエストなどの???からは取れない。物資をもらえたときは、この手順はない。
g05 go - | カンパニエ補給物資を持って、同じエリアの拠点へ行く | マウントを使うと絡まれずに早く行ける。Survival Guideで帰って戦績テレポで拠点に出てもよい。
g06 talk - | 拠点のカンパニエ審理官（王国軍のガード）に話して物資を渡すと、経験値が入る | 東ロンフォール〔Ｓ〕ならH-8のArlayse, R.K.、ジャグナー森林〔Ｓ〕ならI-8のRoiloux, R.K.、ブンカール浦〔Ｓ〕ならG-10のToulsard, R.K.、バタリア丘陵〔Ｓ〕ならJ-7のMyllue, R.K.（J-8と書く資料もある）。
g07 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告して、連合軍戦績をもらうと完了 | - | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice

@ mission.campaign.058 https://wiki.ffo.jp/html/16029.html
Q Cracking Shells (B) | 金剛王討伐（共和国軍） | yes | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
MN - 74
LK quest:過去世界クエスト「第四共和軍団入団試験」をクリアして、第四共和軍団（共和国軍）に入っている
LK condition:所属軍が共和国軍
LK condition:勲章が一級戦功水晶章以上
LK condition:ベドー〔Ｓ〕を含むグスタベルグ戦線の全エリアと、ブンカール浦〔Ｓ〕を除くデルフラント戦線の全エリアがアルタナ連合軍の支配になっている
LK condition:募集要員は1〜6人
RW item:宝箱からワイズストラップかブレイブグリップのどちらか（必ず）、ほかに装備・素材・薬品
XS BG Wiki;https://www.bg-wiki.com/ffxi/Cracking_Shells_(B);Hieronymus（バストゥーク商業区〔Ｓ〕E-8）、Offensive operations、Iron Emblem of Service §§、30分。ベドー〔Ｓ〕が共和国軍の支配のときだけ。Diamond Seal は NM 以外のクゥダフが落とし、そのエリアにいるパーティ全員に入る（作戦を受けていなくても取れる）。Qulun Dome の場所へ行くには Quadav Charm が要る。Map 2 の L-8 の Ironbound Gate から BF。フェイス可、レベル制限なし。Za'Dha Adamantking（狩人）・Di'Mho Platekeeper（白）・Zi'Bhe Gauntletkeeper（黒）・Zo'Bha Helmkeeper（赤）。Za'Dha Adamantking だけ倒せば勝ち。ボスは睡眠が効かず Eagle Eye Shot。護衛は倒すとすぐ戻る。（FFXIclopedia：Hieronymus E-8、グスタベルグ戦線・デルフラント戦線の全エリアが共和国軍の支配、emblem2、1〜6人、Op Credit 1。Quadav Charm は現代のベドーの De'Vyu Headhunter が落とし、Map 1 の I-9 の門を通るのに要る。Map 2 の L-8。全員が Diamond Seal を持っていること。Za'Dha Adamantking だけ倒せば勝ち、倒すと Armoury Crate。報告で完了）用語辞典の金剛王討伐（共和国軍）のページ（16029）：指令書「侵攻支援」、1〜6人、受ける条件（ベドー〔Ｓ〕を含むグスタベルグ戦線全エリアとブンカール浦〔Ｓ〕を除くデルフラント戦線全エリアがアルタナ連合軍支配、共和国軍の傭兵のみ、一級戦功水晶章以上）、参加者全員が受ける。ベドー〔Ｓ〕で通常のクゥダフを倒してだいじなもの「ダイアの宝印」（一度に全員分）。地下マップ L-8 の Ironbound Gate から BF。地上マップ I-9 の Corroded Gate はクゥダフの呪符で開けられる（1人が使えば全員通れ、なくならない）。6人・30分・フェイス可。最初はボスだけで、釣ると護衛 NM が出る。護衛は倒しても戻る、寝かせ続けると耐性。お供が少ないときもある。ボスは回避が高くトリプルアタック、HP1/3ほどでイーグルアイ（空蝉で避けられる）、炸裂岩投げ（ヘイトリセット）。白 NM はサイレスがないとケアルガで起こす。敵を殲滅すると宝箱が出て、開けるとクリア。戦利品はワイズストラップ・ブレイブグリップ（100%）など。成功で自国の士気・軍資金が上がる
g01 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに話して、指令書「侵攻支援」から「金剛王討伐」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。参加する人は全員この作戦を受けておく。ベドー〔Ｓ〕が共和国軍の支配のときだけ受けられる。 | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus
g02 go - | ベドー〔Ｓ〕へ行く | -
g03 gather - | ベドー〔Ｓ〕のクゥダフを倒して、だいじなもの「ダイアの宝印」を手に入れる | NMではないクゥダフならどれでもよい。なかなか出ないこともあるが、出ればそのエリアにいるパーティ全員に入る。作戦を受ける前でも取れるので、先に持っていないか確かめる。
g04 examine - | 地上のマップ(I-9)のCorroded Gateで、クゥダフの呪符を使って通る | 1人が使えば全員通れて、呪符はなくならない。地下のBFの入り口へ行くのに要ると書く資料もある。クゥダフの呪符は現代のベドーのDe'Vyu Headhunterが落とすと書く資料もある。 | @ベドー〔Ｓ〕 I-9 #1 | T obj.ベドー〔Ｓ〕.Corroded_Gate = obj:Corroded Gate@ベドー〔Ｓ〕 I-9 #1
g05 go - | 地下のマップ(L-8)のIronbound Gateへ行く | 現代でZa'Dha Adamantkingがいる場所の近く。 | @ベドー〔Ｓ〕 L-8 #2 | T obj.ベドー〔Ｓ〕.Ironbound_Gate = obj:Ironbound Gate@ベドー〔Ｓ〕 L-8 #2
g06 fight - | Ironbound Gateを調べてBF「金剛王討伐（共和国軍）」に入り、Za'Dha Adamantkingと護衛を全部倒す | 6人・30分・フェイス可。最初はZa'Dha Adamantking（狩人）だけで、釣ると護衛のDi'Mho Platekeeper（白魔道士）・Zi'Bhe Gauntletkeeper（黒魔道士）・Zo'Bha Helmkeeper（赤魔道士）が出る。護衛は倒してもまた出るので、寝かせながら戦う（寝かせ続けると効きにくくなる）。白魔道士の護衛はサイレスがないとケアルガでほかの護衛を起こす。ボスは回避が高く、HPが1/3ほどでイーグルアイ（空蝉で避けられる）、炸裂岩投げはヘイトがリセットされる。Za'Dha Adamantkingだけ倒せば勝ちと書く資料もある。 | @ベドー〔Ｓ〕 L-8 #2 | T obj.ベドー〔Ｓ〕.Ironbound_Gate
g07 examine - | 出てきた宝箱を開けるとクリア | ワイズストラップかブレイブグリップのどちらかは必ず入っている。
g08 talk - | バストゥーク商業区〔Ｓ〕(E-8)のHieronymusに報告すると完了 | - | @バストゥーク商業区〔Ｓ〕 E-8 | T npc.バストゥーク商業区〔Ｓ〕.Hieronymus

@ mission.campaign.059 https://wiki.ffo.jp/html/16026.html
Q Splitting Heirs (S) | 黒太子討伐（王国軍） | yes | T npc.南サンドリア〔Ｓ〕.Rasdinice
MN - 75
LK quest:過去世界クエスト「王立騎士団入団試験」をクリアして、鉄羊騎士隊（王国軍）に入っている
LK condition:所属軍が王国軍
LK condition:勲章が一級戦功水晶章以上
LK condition:ラヴォール村〔Ｓ〕を含むロンフォール戦線・ノルバレン戦線の全エリアとブンカール浦〔Ｓ〕がアルタナ連合軍の支配になっている
LK condition:募集要員は1〜6人
RW item:宝箱からワイズストラップかブレイブグリップのどちらか（必ず）、ほかに装備・素材・薬品
RW other:報告しても連合軍戦績はもらえない
XS BG Wiki;https://www.bg-wiki.com/ffxi/Splitting_Heirs_(S);Rasdinice（南サンドリア〔Ｓ〕I-9）、Offensive operations、Iron Emblem of Service §§、30分。ラヴォール村〔Ｓ〕が王国軍の支配のときだけ。Tigris Stone は NM 以外のオークが落とし、そのエリアにいるパーティ全員に入るが、作戦を受けた人しか入れない。F-9 の Reinforced Gateway から BF。Darkheir Grradhod（侍）と Gorepledge Rozzbrezz（ナイト）・Malicearm Razbhobb（モンク）・Slitherword Razghogg（黒）。Darkheir Grradhod だけ倒せば勝ち。明鏡止水、Tornado Edge。（FFXIclopedia：Rasdinice I-9、ノルバレン戦線・ロンフォール戦線の全エリアが王国軍の支配、emblem2、1〜6人、Op Credit 1。Tigris Stone は NM 以外のオーク。全員が作戦を受けていること。入ると作戦と Tigris Stone はなくなる。30分、入ると強化が消える。北の道をインビジで行くのが安全。いちばん近いのはジャグナー森林〔Ｓ〕の Survival Guide。護衛は1分ほどで戻る。Darkheir Grradhod を倒すとほかは消えて Armoury Crate。報告で報酬）用語辞典の黒太子討伐（王国軍）のページ（16026）：指令書「侵攻支援」、1〜6人、受ける条件（ラヴォール村〔Ｓ〕を含むロンフォール戦線・ノルバレン戦線の全エリアとブンカール浦〔Ｓ〕がアルタナ連合軍支配、王国軍の傭兵のみ、一級戦功水晶章以上）。ラヴォール村〔Ｓ〕以外が獣人血盟軍支配だと受けられても入れない。カンパニエのときユニオンにいると一定時間戦利品が入らない（エリアチェンジ）。参加者全員が受ける。ラヴォール村〔Ｓ〕で通常のオークかスミロドンを倒してだいじなもの「剣虎の石」（一度に全員分）。F-9 の Reinforced Gateway から BF。敵を殲滅すると宝箱、開けるとクリア。報告すると「成功には違いないさ」で、戦績はもらえない。条件を満たさなくなると入れない（コンクェストの集計で判定と推定）。6人・30分・フェイス可。釣ると護衛が出る、護衛はボスとヘイト連動（完全ではない）、スリプルは2回ほどで耐性、倒すとすぐ戻るのでキープ。トルネードエッジ・ショルダーチャージが危ない。入口近くの木は視線をさえぎる。戦利品はワイズストラップ・ブレイブグリップ（100%）など
g01 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに話して、指令書「侵攻支援」から「黒太子討伐」を受ける | 受領券が1枚要る。受領券は1日に1枚たまり、7枚まで持てる。勲章が足りないと選べない。参加する人は全員この作戦を受けておく。ラヴォール村〔Ｓ〕が王国軍の支配のときだけ受けられる。ラヴォール村〔Ｓ〕のほかのエリアが獣人血盟軍の支配だと、受けられてもBFに入れない。受けたあとでも条件を満たさなくなると入れなくなる（コンクェストの集計のときに決まるらしい）ので、受領券をむだにしないよう計画的に受ける。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
g02 go - | ラヴォール村〔Ｓ〕へ行く | カンパニエが起きていたときにユニオンに入っていると、しばらく戦利品が取れない。気になるならエリアを移っておく。
g03 gather - | ラヴォール村〔Ｓ〕のオークかスミロドンを倒して、だいじなもの「剣虎の石」を手に入れる | NMではない敵ならどれでもよい。なかなか出ないこともあるが、出ればそのエリアにいるパーティ全員に入る。オークだけと書く資料もある。
g04 go - | ラヴォール村〔Ｓ〕(F-9)のReinforced Gatewayへ行く | 北の道をインビジで行くのが安全と書く資料もある。 | @ラヴォール村〔Ｓ〕 F-9 | T obj.ラヴォール村〔Ｓ〕.Reinforced_Gateway
g05 fight - | Reinforced Gatewayを調べてBF「黒太子討伐（王国軍）」に入り、Darkheir Grradhodと護衛を全部倒す | 6人・30分・フェイス可。入ると作戦と剣虎の石はなくなると書く資料もある。最初はDarkheir Grradhod（侍）だけで、釣ると護衛のMalicearm Razbhobb（モンク）・Slitherword Razghogg（黒魔道士）・Gorepledge Rozzbrezz（ナイト）が出る。護衛はボスとヘイトがつながっていて、倒すとすぐまた出るので、寝かせてキープする（スリプルは2回ほどで効きにくくなる）。トルネードエッジとショルダーチャージが危ない。入口近くの木は視線をさえぎる。Darkheir Grradhodだけ倒せば勝ちと書く資料もある。 | @ラヴォール村〔Ｓ〕 F-9 | T obj.ラヴォール村〔Ｓ〕.Reinforced_Gateway
g06 examine - | 出てきた宝箱を開けるとクリア | ワイズストラップかブレイブグリップのどちらかは必ず入っている。
g07 talk - | 南サンドリア〔Ｓ〕(I-9)のRasdiniceに報告すると完了 | 「成功には違いないさ」と言われ、連合軍戦績はもらえない。 | @南サンドリア〔Ｓ〕 I-9 | T npc.南サンドリア〔Ｓ〕.Rasdinice
