# その他
@ quest.misc.001 https://wiki.ffo.jp/html/8098.html
Q Lost Chocobo | 迷子のチョコボ | yes
RW other:早く着くほど良い賞品（賞品はコースで違う）
LK condition:だいじなもの「チョコボ乗り免許証」を持ち、Lv20以上
g01 talk - | 三国かカザムのチョコボ厩舎の厩舎員に話して受ける | 週に1回、コンクェストの集計を越えるとまた受けられる。行き先はヴァナ・ディールの日付で決まる（カザムはノーグ行きの日だけ）。
g02 go - | 迷子のチョコボに乗って、行き先のチョコボ厩舎まで走る | 30分（地球時間）で降ろされる。バストゥークとウィンダスの間は、時間を延ばすチョコボ装備があると楽。
g03 talk - | 行き先の厩舎員に話して賞品をもらい、完了 | -

@ quest.misc.002 https://wiki.ffo.jp/html/5991.html
Q Emptiness Investigation | 虚ろなる闇の調査 | yes
RW item:タクティクスパール
RW other:フェローに経験値（倒した敵の数と、調べた???の層で増える）。クエスト「心のシグナル」を終えていて2層目より奥まで調べると、自家製料理も
LK quest:プロマシアミッション「楼閣の下に」が発生している
LK condition:フェローとの親密度が35以上
LK other:コンクェストの集計を越えるとまた受けられる
XS BG Wiki;https://www.bg-wiki.com/ffxi/Emptiness_Investigation;発生条件は「The Mothercrystals を終えている」と書かれていて用語辞典（「楼閣の下に」が発生している）と違う。デム4層の???は K-8（用語辞典は K-9）。フェローの経験値の数え方も用語辞典と違う
g01 talk - | 各国のランデブーポイントでフェローを呼び、「クエストについて話したい」を選んで「虚ろ調査メモ」をもらう | フェローが「虚ろなる闇」の話をしたら受けられる。別のフェロークエストを受けていると出ないことがある。
g02 go - | プロミヴォン（ホラ・デム・メア）のどれかに入り、入ってすぐのランデブーポイントを調べてフェローを呼ぶ | ここから45分。エリアを出る・時間切れ・どちらかが戦闘不能になると失敗し、地球時間の0時を越えるまでやり直せない。シグナルパールは要らない。 | > a01,b01,c01
a01 examine - | 【ホラ】1層(H-7)の???を調べる。経験値を足したいなら「いいえ」で続け、奥の層の???も調べる | 2層G-8、3層E-6とL-5、4層L-11。パールだけ欲しいなら1層で帰ってよい。 | @プロミヴォン-ホラ H-7 | R ホラ | > g03
b01 examine - | 【デム】1層(J-12)の???を調べる。経験値を足したいなら「いいえ」で続け、奥の層の???も調べる | 2層E-9、3層F-6とG-12、4層K-9かK-8。パールだけ欲しいなら1層で帰ってよい。 | @プロミヴォン-デム J-12 | R デム | > g03
c01 examine - | 【メア】1層(F-4)の???を調べる。経験値を足したいなら「いいえ」で続け、奥の層の???も調べる | 2層F-10、3層E-7とK-9、4層I-5。パールだけ欲しいなら1層で帰ってよい。 | @プロミヴォン-メア F-4 | R メア | > g03
g03 talk - | ???の「そろそろ帰る？」に「はい」と答えて調査を終える | 入口に送ってもらうか、その場で別れるかを選べる。
g04 talk - | 各国のランデブーポイントでフェローを呼び、タクティクスパールをもらって完了 | 前のタクティクスパールを持っていると受け取れないので、先に捨てておく。

@ quest.misc.003 https://wiki.ffo.jp/html/32801.html
Q Chacharoon's Cheer | チャチャルンの応援 | no
RW other:チャチャルンの応援：子羊。以後、星のきらめきを使って、持っているモンスターの思い出に合った応援に付け替えられる
LK quest:クエスト「悲しむだけじゃだめクポ」を終えている
LK condition:モグガーデンのモンスター飼育のランクが2
XS BG Wiki;https://www.bg-wiki.com/ffxi/Chacharoon's_Cheer;だいじなもの「Sakura and the Magic Spoon」でモンスター飼育がランク2になってからモグガーデンに入る。報酬で応援「子羊」が最初から有効になる
g01 go - | モグガーデンに入ってイベントを見る | モンスター飼育のランクは、毎日ガーデンのモンスターの世話をすると上がる。
g02 gather - | 「獣人金貨」を1枚用意する | - | N 獣人金貨*1
g03 trade - | モグガーデンのChacharoonに獣人金貨をトレードして完了 | 以後、Chacharoonに応援の付け替えを頼めるようになる。 | N 獣人金貨*1

@ quest.misc.004 https://wiki.ffo.jp/html/6235.html
Q Accumulating Guild Points | 指定生産品クエスト | yes
RW other:ギルドポイント（そのギルドの報奨品と交換できる。職人装備・調度品・サインボードと替えると称号も）
LK condition:そのギルドの職人ランクが下級職人以上
LK other:納められるのは1日に1つのギルドだけ。指定生産品は地球時間の0時に変わる
XS BG Wiki;https://www.bg-wiki.com/ffxi/Guild_Points;1日に貯められるポイントには上限があり、指定品は毎日変わる。用語辞典と同じ
g01 talk - | ギルドの指定生産品担当NPCに話し、今日の指定生産品を聞く | 指定されるランクは、日ごとに素人から自分のランクまでを順に回る（高級職人でも師範まで）。
g02 gather - | 指定生産品を合成するか買って用意する | 1日にもらえるポイントには品ごとの上限がある。
g03 trade - | 担当NPCに指定生産品をトレードしてギルドポイントをもらう | ギルドを移ったら、その日はもう納められない（地球時間の0時越えまで）。ただし職人ランクが上がると、その日のうちに新しい指定品を納められる。

@ quest.misc.005 https://wiki.ffo.jp/html/619.html
Q Supply Quest | 補給クエスト | yes
RW other:補給したアウトポストへのワープ（テレポ・サービス）が使えるようになる
LK other:ヴァナ・ディール時間で1日に1回。補給先に選べるのは、今の所属国が支配しているリージョンだけ
g01 talk - | 所属国のガードに話し、補給先のリージョンを選んで補給物資（だいじなもの）を預かる | 補給済みのリージョンには「済」と出る。オファーリストには載らない。
g02 go - | 補給先のリージョンへ行く | 低地エルシモのように、町を出てすぐ渡せるリージョンもある。
g03 talk - | そのリージョンのガードに話して補給物資を渡し、完了 | アウトポストのガードでなくてもよい。今のコンクェスト期間中に渡す。渡し忘れた物資は、集計のあとに所属国のガードに話すと引き取ってもらえる。

@ quest.misc.006 https://wiki.ffo.jp/html/30062.html
Q Kupofried's Great Katana Moogle Magic | クポフリートの秘術＜両手刀＞ | no | T npc.182.Kupofried = npc:Kupofried@ウォークオブエコーズ
RW other:エンピリアンWS「祖之太刀・不動」を覚える。以後、正宗や鳥頭の太刀を装備していなくても撃てる
LK quest:過去世界クエスト「彼方よりの使者」が発生している
LK condition:Lv90以上の正宗か、Lv99の鳥頭の太刀を持っている
LK other:どれか1つのWSを覚えたら、次のWSはヴァナ・ディール時間の0時を越えてから
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupofried's_Weapon_Skill_Moogle_Magic;見出しは Repeatable=Yes だが、武器ごとに別のクエストなので「くり返せる」にはしていない。-1の武器はル・ルデの庭のMagian Moogleのそばの Splintery Chest にある
g01 gather - | Lv90以上の正宗か、Lv99の鳥頭の太刀を用意する | 鳥頭の太刀は、ル・ルデの庭(H-5)のMagian Moogleの左にあるSplintery Chestから「鳥頭の太刀-1」をもらい、Magian Moogleで試練を受けて、右のDelivery Crateに衰退のコイン×30、トリックダイス×100、リミナルレジデ×100を1回ずつ納めると仕上がる（納めるたびにMagian Moogleへ武器を渡して次の試練を受ける）。
g02 go - | ザルカバード〔Ｓ〕(H-9)の幽門石からウォークオブエコーズに入る | 初めてのときは、正宗か鳥頭の太刀をメインに装備しておく。 | @ザルカバード〔Ｓ〕 H-9
g03 examine - | 入ってすぐ正面の階段の上の???を調べ、武器の種類で「両手刀」を選ぶ | クポフリートが出てくる。
g04 trade - | ???に正宗か鳥頭の太刀をトレードして完了 | -

@ quest.misc.007 https://wiki.ffo.jp/html/30062.html
Q Kupofried's Great Sword Moogle Magic | クポフリートの秘術＜両手剣＞ | no | T npc.182.Kupofried
RW other:エンピリアンWS「トアクリーバー」を覚える。以後、カラドボルグやシフィアスを装備していなくても撃てる
LK quest:過去世界クエスト「彼方よりの使者」が発生している
LK condition:Lv90以上のカラドボルグか、Lv99のシフィアスを持っている
LK other:どれか1つのWSを覚えたら、次のWSはヴァナ・ディール時間の0時を越えてから
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupofried's_Weapon_Skill_Moogle_Magic;見出しは Repeatable=Yes だが、武器ごとに別のクエストなので「くり返せる」にはしていない。-1の武器はル・ルデの庭のMagian Moogleのそばの Splintery Chest にある
g01 gather - | Lv90以上のカラドボルグか、Lv99のシフィアスを用意する | シフィアスは、ル・ルデの庭(H-5)のMagian Moogleの左にあるSplintery Chestから「シフィアス-1」をもらい、Magian Moogleで試練を受けて、右のDelivery Crateに衰退のコイン×30、トリックダイス×100、リミナルレジデ×100を1回ずつ納めると仕上がる（納めるたびにMagian Moogleへ武器を渡して次の試練を受ける）。
g02 go - | ザルカバード〔Ｓ〕(H-9)の幽門石からウォークオブエコーズに入る | 初めてのときは、カラドボルグかシフィアスをメインに装備しておく。 | @ザルカバード〔Ｓ〕 H-9
g03 examine - | 入ってすぐ正面の階段の上の???を調べ、武器の種類で「両手剣」を選ぶ | クポフリートが出てくる。
g04 trade - | ???にカラドボルグかシフィアスをトレードして完了 | -

@ quest.misc.008 https://wiki.ffo.jp/html/30062.html
Q Kupofried's Great Axe Moogle Magic | クポフリートの秘術＜両手斧＞ | no | T npc.182.Kupofried
RW other:エンピリアンWS「ウッコフューリー」を覚える。以後、ウコンバサラやシャマシュを装備していなくても撃てる
LK quest:過去世界クエスト「彼方よりの使者」が発生している
LK condition:Lv90以上のウコンバサラか、Lv99のシャマシュを持っている
LK other:どれか1つのWSを覚えたら、次のWSはヴァナ・ディール時間の0時を越えてから
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupofried's_Weapon_Skill_Moogle_Magic;見出しは Repeatable=Yes だが、武器ごとに別のクエストなので「くり返せる」にはしていない。-1の武器はル・ルデの庭のMagian Moogleのそばの Splintery Chest にある
g01 gather - | Lv90以上のウコンバサラか、Lv99のシャマシュを用意する | シャマシュは、ル・ルデの庭(H-5)のMagian Moogleの左にあるSplintery Chestから「シャマシュ-1」をもらい、Magian Moogleで試練を受けて、右のDelivery Crateに栄華のコイン×30、トリックダイス×100、リミナルレジデ×100を1回ずつ納めると仕上がる（納めるたびにMagian Moogleへ武器を渡して次の試練を受ける）。
g02 go - | ザルカバード〔Ｓ〕(H-9)の幽門石からウォークオブエコーズに入る | 初めてのときは、ウコンバサラかシャマシュをメインに装備しておく。 | @ザルカバード〔Ｓ〕 H-9
g03 examine - | 入ってすぐ正面の階段の上の???を調べ、武器の種類で「両手斧」を選ぶ | クポフリートが出てくる。
g04 trade - | ???にウコンバサラかシャマシュをトレードして完了 | -

@ quest.misc.009 https://wiki.ffo.jp/html/30062.html
Q Kupofried's Staff Moogle Magic | クポフリートの秘術＜両手棍＞ | no | T npc.182.Kupofried
RW other:エンピリアンWS「ミルキル」を覚える。以後、フヴェルゲルミルやパイケアを装備していなくても撃てる
LK quest:過去世界クエスト「彼方よりの使者」が発生している
LK condition:Lv90以上のフヴェルゲルミルか、Lv99のパイケアを持っている
LK other:どれか1つのWSを覚えたら、次のWSはヴァナ・ディール時間の0時を越えてから
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupofried's_Weapon_Skill_Moogle_Magic;見出しは Repeatable=Yes だが、武器ごとに別のクエストなので「くり返せる」にはしていない。-1の武器はル・ルデの庭のMagian Moogleのそばの Splintery Chest にある
g01 gather - | Lv90以上のフヴェルゲルミルか、Lv99のパイケアを用意する | パイケアは、ル・ルデの庭(H-5)のMagian Moogleの左にあるSplintery Chestから「パイケア-1」をもらい、Magian Moogleで試練を受けて、右のDelivery Crateに滅亡のコイン×30、トリックダイス×100、リミナルレジデ×100を1回ずつ納めると仕上がる（納めるたびにMagian Moogleへ武器を渡して次の試練を受ける）。
g02 go - | ザルカバード〔Ｓ〕(H-9)の幽門石からウォークオブエコーズに入る | 初めてのときは、フヴェルゲルミルかパイケアをメインに装備しておく。 | @ザルカバード〔Ｓ〕 H-9
g03 examine - | 入ってすぐ正面の階段の上の???を調べ、武器の種類で「両手棍」を選ぶ | クポフリートが出てくる。
g04 trade - | ???にフヴェルゲルミルかパイケアをトレードして完了 | -

@ quest.misc.010 https://wiki.ffo.jp/html/30062.html
Q Kupofried's Polearm Moogle Magic | クポフリートの秘術＜両手槍＞ | no | T npc.182.Kupofried
RW other:エンピリアンWS「カムラン」を覚える。以後、ロンゴミアントやダボヤを装備していなくても撃てる
LK quest:過去世界クエスト「彼方よりの使者」が発生している
LK condition:Lv90以上のロンゴミアントか、Lv99のダボヤを持っている
LK other:どれか1つのWSを覚えたら、次のWSはヴァナ・ディール時間の0時を越えてから
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupofried's_Weapon_Skill_Moogle_Magic;見出しは Repeatable=Yes だが、武器ごとに別のクエストなので「くり返せる」にはしていない。-1の武器はル・ルデの庭のMagian Moogleのそばの Splintery Chest にある
g01 gather - | Lv90以上のロンゴミアントか、Lv99のダボヤを用意する | ダボヤは、ル・ルデの庭(H-5)のMagian Moogleの左にあるSplintery Chestから「ダボヤ-1」をもらい、Magian Moogleで試練を受けて、右のDelivery Crateに発展のコイン×30、トリックダイス×100、リミナルレジデ×100を1回ずつ納めると仕上がる（納めるたびにMagian Moogleへ武器を渡して次の試練を受ける）。
g02 go - | ザルカバード〔Ｓ〕(H-9)の幽門石からウォークオブエコーズに入る | 初めてのときは、ロンゴミアントかダボヤをメインに装備しておく。 | @ザルカバード〔Ｓ〕 H-9
g03 examine - | 入ってすぐ正面の階段の上の???を調べ、武器の種類で「両手槍」を選ぶ | クポフリートが出てくる。
g04 trade - | ???にロンゴミアントかダボヤをトレードして完了 | -

@ quest.misc.011 https://wiki.ffo.jp/html/30062.html
Q Kupofried's Scythe Moogle Magic | クポフリートの秘術＜両手鎌＞ | no | T npc.182.Kupofried
RW other:エンピリアンWS「クワイタス」を覚える。以後、リデンプションやウミリアティを装備していなくても撃てる
LK quest:過去世界クエスト「彼方よりの使者」が発生している
LK condition:Lv90以上のリデンプションか、Lv99のウミリアティを持っている
LK other:どれか1つのWSを覚えたら、次のWSはヴァナ・ディール時間の0時を越えてから
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupofried's_Weapon_Skill_Moogle_Magic;見出しは Repeatable=Yes だが、武器ごとに別のクエストなので「くり返せる」にはしていない。-1の武器はル・ルデの庭のMagian Moogleのそばの Splintery Chest にある
g01 gather - | Lv90以上のリデンプションか、Lv99のウミリアティを用意する | ウミリアティは、ル・ルデの庭(H-5)のMagian Moogleの左にあるSplintery Chestから「ウミリアティ-1」をもらい、Magian Moogleで試練を受けて、右のDelivery Crateに誕生のコイン×30、トリックダイス×100、リミナルレジデ×100を1回ずつ納めると仕上がる（納めるたびにMagian Moogleへ武器を渡して次の試練を受ける）。
g02 go - | ザルカバード〔Ｓ〕(H-9)の幽門石からウォークオブエコーズに入る | 初めてのときは、リデンプションかウミリアティをメインに装備しておく。 | @ザルカバード〔Ｓ〕 H-9
g03 examine - | 入ってすぐ正面の階段の上の???を調べ、武器の種類で「両手鎌」を選ぶ | クポフリートが出てくる。
g04 trade - | ???にリデンプションかウミリアティをトレードして完了 | -

@ quest.misc.012 https://wiki.ffo.jp/html/30062.html
Q Kupofried's Marksmanship Moogle Magic | クポフリートの秘術＜射撃＞ | no | T npc.182.Kupofried
RW other:エンピリアンWS「ワイルドファイア」を覚える。以後、アルマゲドンやモルフリッスを装備していなくても撃てる
LK quest:過去世界クエスト「彼方よりの使者」が発生している
LK condition:Lv90以上のアルマゲドンか、Lv99のモルフリッスを持っている
LK other:どれか1つのWSを覚えたら、次のWSはヴァナ・ディール時間の0時を越えてから
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupofried's_Weapon_Skill_Moogle_Magic;見出しは Repeatable=Yes だが、武器ごとに別のクエストなので「くり返せる」にはしていない。-1の武器はル・ルデの庭のMagian Moogleのそばの Splintery Chest にある
g01 gather - | Lv90以上のアルマゲドンか、Lv99のモルフリッスを用意する | モルフリッスは、ル・ルデの庭(H-5)のMagian Moogleの左にあるSplintery Chestから「モルフリッス-1」をもらい、Magian Moogleで試練を受けて、右のDelivery Crateに誕生のコイン×30、トリックダイス×100、リミナルレジデ×100を1回ずつ納めると仕上がる（納めるたびにMagian Moogleへ武器を渡して次の試練を受ける）。
g02 go - | ザルカバード〔Ｓ〕(H-9)の幽門石からウォークオブエコーズに入る | 初めてのときは、アルマゲドンかモルフリッスをメインに装備しておく。 | @ザルカバード〔Ｓ〕 H-9
g03 examine - | 入ってすぐ正面の階段の上の???を調べ、武器の種類で「射撃」を選ぶ | クポフリートが出てくる。
g04 trade - | ???にアルマゲドンかモルフリッスをトレードして完了 | -

@ quest.misc.013 https://wiki.ffo.jp/html/30062.html
Q Kupofried's Archery Moogle Magic | クポフリートの秘術＜弓術＞ | no | T npc.182.Kupofried
RW other:エンピリアンWS「ジシュヌの光輝」を覚える。以後、ガーンデーヴァやキルキナエを装備していなくても撃てる
LK quest:過去世界クエスト「彼方よりの使者」が発生している
LK condition:Lv90以上のガーンデーヴァか、Lv99のキルキナエを持っている
LK other:どれか1つのWSを覚えたら、次のWSはヴァナ・ディール時間の0時を越えてから
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupofried's_Weapon_Skill_Moogle_Magic;見出しは Repeatable=Yes だが、武器ごとに別のクエストなので「くり返せる」にはしていない。-1の武器はル・ルデの庭のMagian Moogleのそばの Splintery Chest にある
g01 gather - | Lv90以上のガーンデーヴァか、Lv99のキルキナエを用意する | キルキナエは、ル・ルデの庭(H-5)のMagian Moogleの左にあるSplintery Chestから「キルキナエ-1」をもらい、Magian Moogleで試練を受けて、右のDelivery Crateに衰退のコイン×30、トリックダイス×100、リミナルレジデ×100を1回ずつ納めると仕上がる（納めるたびにMagian Moogleへ武器を渡して次の試練を受ける）。
g02 go - | ザルカバード〔Ｓ〕(H-9)の幽門石からウォークオブエコーズに入る | 初めてのときは、ガーンデーヴァかキルキナエをメインに装備しておく。 | @ザルカバード〔Ｓ〕 H-9
g03 examine - | 入ってすぐ正面の階段の上の???を調べ、武器の種類で「弓術」を選ぶ | クポフリートが出てくる。
g04 trade - | ???にガーンデーヴァかキルキナエをトレードして完了 | -

@ quest.misc.014 https://wiki.ffo.jp/html/30062.html
Q Kupofried's Hand-to-Hand Moogle Magic | クポフリートの秘術＜格闘＞ | no | T npc.182.Kupofried
RW other:エンピリアンWS「ビクトリースマイト」を覚える。以後、ウルスラグナやデゥムズィを装備していなくても撃てる
LK quest:過去世界クエスト「彼方よりの使者」が発生している
LK condition:Lv90以上のウルスラグナか、Lv99のデゥムズィを持っている
LK other:どれか1つのWSを覚えたら、次のWSはヴァナ・ディール時間の0時を越えてから
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupofried's_Weapon_Skill_Moogle_Magic;見出しは Repeatable=Yes だが、武器ごとに別のクエストなので「くり返せる」にはしていない。-1の武器はル・ルデの庭のMagian Moogleのそばの Splintery Chest にある
g01 gather - | Lv90以上のウルスラグナか、Lv99のデゥムズィを用意する | デゥムズィは、ル・ルデの庭(H-5)のMagian Moogleの左にあるSplintery Chestから「デゥムズィ-1」をもらい、Magian Moogleで試練を受けて、右のDelivery Crateに発展のコイン×30、トリックダイス×100、リミナルレジデ×100を1回ずつ納めると仕上がる（納めるたびにMagian Moogleへ武器を渡して次の試練を受ける）。
g02 go - | ザルカバード〔Ｓ〕(H-9)の幽門石からウォークオブエコーズに入る | 初めてのときは、ウルスラグナかデゥムズィをメインに装備しておく。 | @ザルカバード〔Ｓ〕 H-9
g03 examine - | 入ってすぐ正面の階段の上の???を調べ、武器の種類で「格闘」を選ぶ | クポフリートが出てくる。
g04 trade - | ???にウルスラグナかデゥムズィをトレードして完了 | -

@ quest.misc.015 https://wiki.ffo.jp/html/30062.html
Q Kupofried's Katana Moogle Magic | クポフリートの秘術＜片手刀＞ | no | T npc.182.Kupofried
RW other:エンピリアンWS「秘」を覚える。以後、神無や鵲を装備していなくても撃てる
LK quest:過去世界クエスト「彼方よりの使者」が発生している
LK condition:Lv90以上の神無か、Lv99の鵲を持っている
LK other:どれか1つのWSを覚えたら、次のWSはヴァナ・ディール時間の0時を越えてから
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupofried's_Weapon_Skill_Moogle_Magic;見出しは Repeatable=Yes だが、武器ごとに別のクエストなので「くり返せる」にはしていない。-1の武器はル・ルデの庭のMagian Moogleのそばの Splintery Chest にある
g01 gather - | Lv90以上の神無か、Lv99の鵲を用意する | 鵲は、ル・ルデの庭(H-5)のMagian Moogleの左にあるSplintery Chestから「鵲-1」をもらい、Magian Moogleで試練を受けて、右のDelivery Crateに栄華のコイン×30、トリックダイス×100、リミナルレジデ×100を1回ずつ納めると仕上がる（納めるたびにMagian Moogleへ武器を渡して次の試練を受ける）。
g02 go - | ザルカバード〔Ｓ〕(H-9)の幽門石からウォークオブエコーズに入る | 初めてのときは、神無か鵲をメインに装備しておく。 | @ザルカバード〔Ｓ〕 H-9
g03 examine - | 入ってすぐ正面の階段の上の???を調べ、武器の種類で「片手刀」を選ぶ | クポフリートが出てくる。
g04 trade - | ???に神無か鵲をトレードして完了 | -

@ quest.misc.016 https://wiki.ffo.jp/html/30062.html
Q Kupofried's Sword Moogle Magic | クポフリートの秘術＜片手剣＞ | no | T npc.182.Kupofried
RW other:エンピリアンWS「シャンデュシニュ」を覚える。以後、アルマスやブルネロを装備していなくても撃てる
LK quest:過去世界クエスト「彼方よりの使者」が発生している
LK condition:Lv90以上のアルマスか、Lv99のブルネロを持っている
LK other:どれか1つのWSを覚えたら、次のWSはヴァナ・ディール時間の0時を越えてから
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupofried's_Weapon_Skill_Moogle_Magic;見出しは Repeatable=Yes だが、武器ごとに別のクエストなので「くり返せる」にはしていない。-1の武器はル・ルデの庭のMagian Moogleのそばの Splintery Chest にある
g01 gather - | Lv90以上のアルマスか、Lv99のブルネロを用意する | ブルネロは、ル・ルデの庭(H-5)のMagian Moogleの左にあるSplintery Chestから「ブルネロ-1」をもらい、Magian Moogleで試練を受けて、右のDelivery Crateに栄華のコイン×30、トリックダイス×100、リミナルレジデ×100を1回ずつ納めると仕上がる（納めるたびにMagian Moogleへ武器を渡して次の試練を受ける）。
g02 go - | ザルカバード〔Ｓ〕(H-9)の幽門石からウォークオブエコーズに入る | 初めてのときは、アルマスかブルネロをメインに装備しておく。 | @ザルカバード〔Ｓ〕 H-9
g03 examine - | 入ってすぐ正面の階段の上の???を調べ、武器の種類で「片手剣」を選ぶ | クポフリートが出てくる。
g04 trade - | ???にアルマスかブルネロをトレードして完了 | -

@ quest.misc.017 https://wiki.ffo.jp/html/30062.html
Q Kupofried's Axe Moogle Magic | クポフリートの秘術＜片手斧＞ | no | T npc.182.Kupofried
RW other:エンピリアンWS「クラウドスプリッタ」を覚える。以後、ファルシャやサクリパンテを装備していなくても撃てる
LK quest:過去世界クエスト「彼方よりの使者」が発生している
LK condition:Lv90以上のファルシャか、Lv99のサクリパンテを持っている
LK other:どれか1つのWSを覚えたら、次のWSはヴァナ・ディール時間の0時を越えてから
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupofried's_Weapon_Skill_Moogle_Magic;見出しは Repeatable=Yes だが、武器ごとに別のクエストなので「くり返せる」にはしていない。-1の武器はル・ルデの庭のMagian Moogleのそばの Splintery Chest にある
g01 gather - | Lv90以上のファルシャか、Lv99のサクリパンテを用意する | サクリパンテは、ル・ルデの庭(H-5)のMagian Moogleの左にあるSplintery Chestから「サクリパンテ-1」をもらい、Magian Moogleで試練を受けて、右のDelivery Crateに発展のコイン×30、トリックダイス×100、リミナルレジデ×100を1回ずつ納めると仕上がる（納めるたびにMagian Moogleへ武器を渡して次の試練を受ける）。
g02 go - | ザルカバード〔Ｓ〕(H-9)の幽門石からウォークオブエコーズに入る | 初めてのときは、ファルシャかサクリパンテをメインに装備しておく。 | @ザルカバード〔Ｓ〕 H-9
g03 examine - | 入ってすぐ正面の階段の上の???を調べ、武器の種類で「片手斧」を選ぶ | クポフリートが出てくる。
g04 trade - | ???にファルシャかサクリパンテをトレードして完了 | -

@ quest.misc.018 https://wiki.ffo.jp/html/30062.html
Q Kupofried's Club Moogle Magic | クポフリートの秘術＜片手棍＞ | no | T npc.182.Kupofried
RW other:エンピリアンWS「ダガン」を覚える。以後、ガンバンテインやローズクーベルトを装備していなくても撃てる
LK quest:過去世界クエスト「彼方よりの使者」が発生している
LK condition:Lv90以上のガンバンテインか、Lv99のローズクーベルトを持っている
LK other:どれか1つのWSを覚えたら、次のWSはヴァナ・ディール時間の0時を越えてから
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupofried's_Weapon_Skill_Moogle_Magic;見出しは Repeatable=Yes だが、武器ごとに別のクエストなので「くり返せる」にはしていない。-1の武器はル・ルデの庭のMagian Moogleのそばの Splintery Chest にある
g01 gather - | Lv90以上のガンバンテインか、Lv99のローズクーベルトを用意する | ローズクーベルトは、ル・ルデの庭(H-5)のMagian Moogleの左にあるSplintery Chestから「ローズクーベルト-1」をもらい、Magian Moogleで試練を受けて、右のDelivery Crateに衰退のコイン×30、トリックダイス×100、リミナルレジデ×100を1回ずつ納めると仕上がる（納めるたびにMagian Moogleへ武器を渡して次の試練を受ける）。
g02 go - | ザルカバード〔Ｓ〕(H-9)の幽門石からウォークオブエコーズに入る | 初めてのときは、ガンバンテインかローズクーベルトをメインに装備しておく。 | @ザルカバード〔Ｓ〕 H-9
g03 examine - | 入ってすぐ正面の階段の上の???を調べ、武器の種類で「片手棍」を選ぶ | クポフリートが出てくる。
g04 trade - | ???にガンバンテインかローズクーベルトをトレードして完了 | -

@ quest.misc.019 https://wiki.ffo.jp/html/30062.html
Q Kupofried's Dagger Moogle Magic | クポフリートの秘術＜短剣＞ | no | T npc.182.Kupofried
RW other:エンピリアンWS「ルドラストーム」を覚える。以後、トゥワシュトラやカンドローマを装備していなくても撃てる
LK quest:過去世界クエスト「彼方よりの使者」が発生している
LK condition:Lv90以上のトゥワシュトラか、Lv99のカンドローマを持っている
LK other:どれか1つのWSを覚えたら、次のWSはヴァナ・ディール時間の0時を越えてから
XS BG Wiki;https://www.bg-wiki.com/ffxi/Kupofried's_Weapon_Skill_Moogle_Magic;見出しは Repeatable=Yes だが、武器ごとに別のクエストなので「くり返せる」にはしていない。-1の武器はル・ルデの庭のMagian Moogleのそばの Splintery Chest にある
g01 gather - | Lv90以上のトゥワシュトラか、Lv99のカンドローマを用意する | カンドローマは、ル・ルデの庭(H-5)のMagian Moogleの左にあるSplintery Chestから「カンドローマ-1」をもらい、Magian Moogleで試練を受けて、右のDelivery Crateに誕生のコイン×30、トリックダイス×100、リミナルレジデ×100を1回ずつ納めると仕上がる（納めるたびにMagian Moogleへ武器を渡して次の試練を受ける）。
g02 go - | ザルカバード〔Ｓ〕(H-9)の幽門石からウォークオブエコーズに入る | 初めてのときは、トゥワシュトラかカンドローマをメインに装備しておく。 | @ザルカバード〔Ｓ〕 H-9
g03 examine - | 入ってすぐ正面の階段の上の???を調べ、武器の種類で「短剣」を選ぶ | クポフリートが出てくる。
g04 trade - | ???にトゥワシュトラかカンドローマをトレードして完了 | -

@ quest.misc.020 https://wiki.ffo.jp/html/15811.html
Q An Affable Adamantking? | クゥダフの博雅 | yes | T npc.148.Raptorlegs_Gedwad = npc:Raptorlegs Gedwad@クゥルンの大伽藍
RW item:ダ・ヴ・バルバト
RW item:獣人金貨
RW title:ブロンズクゥダフ
LK condition:Lv60以上
LK other:ほかの獣人帽子クエスト（ヤグードの勇胆・オークの謙譲・ゴブリンの仁義）を受けておらず、ヒーロー帽子を装備していない
XS BG Wiki;https://www.bg-wiki.com/ffxi/An_Affable_Adamantking%3F;クゥルンの大伽藍の入口は (H-7)（用語辞典は I-7）。断るとコンクェストの集計越えまで受け直せないとある（用語辞典はヴァナ0時越え）。Repeatable=Yes。クゥダフ冑パーツは翌日もらえ、エリアを出入りしなくてよい。クゥダフバルバトの材料は Quadav Parts・Tiger Leather・Lizard Molt・Bugard Tusk・Wool Thread・Red Grass Cloth・Black Pearl×2
g01 go - | ベドー(H-7かI-7)の入口から魔晶石のあるクゥルンの大伽藍に入り、イベントで「はい」を選んで受ける | 「いいえ」を選ぶと、しばらく受け直せない。 | @ベドー H-7 I-7
g02 talk - | ウィンダス森の区(H-13)の骨工ギルドのギルドマスター Peshi Yohnts に話す | - | @ウィンダス森の区 H-13 | T npc.241.Peshi_Yohnts = npc:Peshi Yohnts@ウィンダス森の区 H-13
g03 trade - | Peshi Yohnts に「ブガードのなめし革」「海亀の甲羅」と10000ギルをトレードする | - | @ウィンダス森の区 H-13 | T npc.241.Peshi_Yohnts | N ブガードのなめし革*1 | N 海亀の甲羅*1
g04 talk - | ヴァナ・ディール時間の0時を越えてから Peshi Yohnts にもう一度話し、「クゥダフ冑パーツ」をもらう | - | @ウィンダス森の区 H-13 | T npc.241.Peshi_Yohnts | W ヴァナ時間の0時を越えてから
g05 gather - | クゥダフ冑パーツで「クゥダフバルバト」を合成する（骨細工78、裁縫50・革細工40。土のクリスタル） | ほかの材料は合成レシピで確かめる。腕が足りなければ骨細工職人に頼む。失敗したら Peshi Yohnts に10万ギルを渡すとパーツをもう一度もらえる。 | N クゥダフバルバト*1
g06 go - | クゥダフバルバトを装備して、魔晶石のあるクゥルンの大伽藍に入り、「偵察コウモリ」をもらう | - | @ベドー H-7 I-7
g07 examine - | クゥダフバルバトを装備したまま(F-8)のBeastmen's Bannerを調べ、NMを7体呼び出す | 倒すのはボスの Diamond Quadav（白魔道士）だけでよい。スリプル・サイレスは効かない。護衛はスリプガで寝かせて、ボスだけ釣ると楽。 | @クゥルンの大伽藍 F-8 | T obj.148.Beastmens_Banner = obj:Beastmen's Banner@クゥルンの大伽藍 F-8
g08 defeat - | Diamond Quadav を倒す | 倒すと護衛のNMはみな消える。 | @クゥルンの大伽藍 F-8 | T mob.148.Diamond_Quadav = mob:Diamond Quadav@クゥルンの大伽藍 F-8
g09 examine - | クゥダフバルバトを装備したまま、もう一度Beastmen's Bannerを調べてイベントを見る | このイベントの前にエリアを出ると、倒したことが取り消される。 | @クゥルンの大伽藍 F-8 | T obj.148.Beastmens_Banner
g10 trade - | Beastmen's Bannerにクゥダフバルバトをトレードし、「ダ・ヴ・バルバト」と取り替えて完了 | ダ・ヴ・バルバトを装備してクゥルンの大伽藍に入り直すと、獣人金貨がもらえる。 | @クゥルンの大伽藍 F-8 | T obj.148.Beastmens_Banner | N クゥダフバルバト*1

@ quest.misc.021 https://wiki.ffo.jp/html/26576.html
Q VW Op. #026: Tavnazian Terrors | VW作戦第026計画タブナジア群島 | no | T npc.26.Owain = npc:Owain@タブナジア地下壕 H-6
RW item:六芒星の青紫色のジェイドII（六芒星の青紫色のジェイドが変わる）
LK condition:Lv75以上で、だいじなもの「冒険者の証」を持っている
LK other:プロマシアのヴォイドウォッチの1つ目。タブナジア地下壕まで来ていれば、プロマシアミッションを進めていなくても受けられる
XS BG Wiki;https://www.bg-wiki.com/ffxi/VW_Op._026:_Tavnazian_Terrors;位相の境界の場所は Fjalar アットワ地溝 I-9/K-7/K-10、Abununnu ルフェーゼ野 H-9/F-8/G-7、Tsui-Goab ミザレオ海岸 J-8/I-7/J-10、Isarukitsck ウルガラン山脈 G-11/G-10/J-10・J-11
g01 talk - | タブナジア地下壕・入口(H-6)のOwainに話し、「ヴォイドウォッチに参加する」を選んで「六芒星の青紫色のジェイド」をもらう | ホームポイント#1のそば。 | @タブナジア地下壕 H-6 | T npc.26.Owain
g02 defeat - | ルフェーゼ野の位相の境界でAbununnuを倒す | 位相の境界は H-9・F-8・G-7。 | @ルフェーゼ野 H-9 | T mob.24.Abununnu = mob:Abununnu@ルフェーゼ野 H-9
g03 defeat - | ミザレオ海岸の位相の境界でTsui-Goabを倒す | 位相の境界は J-8・I-7・J-10。 | @ミザレオ海岸 J-8 | T mob.25.Tsui-Goab = mob:Tsui-Goab@ミザレオ海岸 J-8
g04 defeat - | ウルガラン山脈の位相の境界でIsarukitsckを倒す | 位相の境界は G-11・G-10・J-10とJ-11の境目。 | @ウルガラン山脈 G-11 | T mob.5.Isarukitsck = mob:Isarukitsck@ウルガラン山脈 G-11
g05 defeat - | アットワ地溝の位相の境界でFjalarを倒す | 位相の境界は I-9・K-7・K-10。 | @アットワ地溝 I-9 | T mob.7.Fjalar = mob:Fjalar@アットワ地溝 I-9
g06 talk - | 4体とも倒したらOwainに報告して完了 | ジェイドが「六芒星の青紫色のジェイドII」に変わり、続けて「VW作戦第004計画ビビキー湾」が始まる。プロマシアミッションの進み具合でイベントが変わる。 | @タブナジア地下壕 H-6 | T npc.26.Owain

@ quest.misc.022 https://wiki.ffo.jp/html/26579.html
Q VW Op. #004: Bibiki Bombardment | VW作戦第004計画ビビキー湾 | no | T npc.26.Owain = npc:Owain@タブナジア地下壕 H-6
LK quest:クエスト「VW作戦第026計画タブナジア群島」を終えている
LK other:プロマシアのヴォイドウォッチの2つ目。前のクエストを終えると自動で始まる
XS BG Wiki;https://www.bg-wiki.com/ffxi/VW_Op._004:_Bibiki_Bombardment;Bismarck の位相の境界はビビキー湾 MAP2（プルゴノルゴ島）の F-9・J-9・I-10。ヴォイドウォッチのワープか、マナクリッパーで行く
g01 defeat - | ビビキー湾・プルゴノルゴ島の位相の境界でBismarckを倒す | 位相の境界は F-9・J-9・I-10。ヴォイドウォッチのワープかマナクリッパーで渡る。 | @ビビキー湾 #2 F-9 | T mob.4.Bismarck = mob:Bismarck@ビビキー湾 #2 F-9
g02 talk - | タブナジア地下壕・入口(H-6)のOwainに報告して完了 | - | @タブナジア地下壕 H-6 | T npc.26.Owain

@ quest.misc.023 https://wiki.ffo.jp/html/24516.html
Q A Hard Day's Knight | タブナジア侯国騎士団 | no | T npc.26.Quelveuiat = npc:Quelveuiat@タブナジア地下壕 H-10 I-10
RW gil:2100
RW title:タブナジア侯国騎士見習
LK other:クリアすると、侯国騎士団長のカギをもらうサブクエストが始まる
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Hard_Day's_Knight;Quelveuiat は I-10（中の階）。ルフェーゼ野へは地下壕の南の出口 (I-6) から出る。近くのオークはリンクする。クリア後にシーライオンクレストキーとコーラルクレストキーを渡すと「Temple Knight key」がもらえる
g01 talk - | タブナジア地下壕2階の祭壇前を行き来しているQuelveuiatに話し、「はい」を選んで受ける | H-10とI-10の間を往復している。 | @タブナジア地下壕 H-10 I-10 | T npc.26.Quelveuiat
g02 go - | 地下壕の南の出口からルフェーゼ野に出て、南の物見台(H-10)へ行く | 近くのオークはリンクするので先に片付ける。 | @ルフェーゼ野 H-10
g03 examine - | 物見台の上の???を、NMが出るまで何度か調べる | - | @ルフェーゼ野 H-10 | T obj.24.qm_H-10 = obj:???@ルフェーゼ野 H-10
g04 defeat - | 出てきたオークのNM Splinterspine Grukjuk（狩人）を倒す | Lv54あれば楽に勝てる。 | @ルフェーゼ野 H-10 | T mob.24.Splinterspine_Grukjuk = mob:Splinterspine Grukjuk@ルフェーゼ野 H-10
g05 talk - | タブナジア地下壕に戻り、Quelveuiatに報告して完了 | - | @タブナジア地下壕 H-10 I-10 | T npc.26.Quelveuiat

@ quest.misc.024 https://wiki.ffo.jp/html/29367.html
Q Monstrosity | モンストロス・プレッジ | no | T npc.109.Suspicious_Hume = npc:Suspicious Hume@パシュハウ沼 E-12
RW other:だいじなもの「星辰の指輪」。モンストロス・プレッジに参加できるようになる
LK other:クリアのあとSuspicious Humeの話を最後まで聞くと、グラディエイターに参加でき、アドゥリンのクエスト「メルヴィアン殺人事件」の条件の1つも満たす
XS BG Wiki;https://www.bg-wiki.com/ffxi/Monstrosity_(Quest);Suspicious Hume へはユニティのワープ122かヴォイドウォッチのワープが近い。Bog Bunny が野兎の毛皮を落とす。三国のNPCはそれぞれホームポイント#3（北サンドリア・ウィンダス港）、#2（バストゥーク港）のそば
g01 talk - | パシュハウ沼(E-12)のSuspicious Humeに話す | ウォンテッドのワープ CL122 が近い。 | @パシュハウ沼 E-12 | T npc.109.Suspicious_Hume
g02 gather - | 「野兎の毛皮」「トカゲの尻尾」「マンドラゴラの双葉」のどれか1つを用意する | どれでもよく、競売で買ってもよい。 | > a01,b01,c01
a01 trade - | 【北サンドリア】(L-8)のSuspicious Elvaanに用意した品をトレードし、「星辰の指輪」をもらう | - | @北サンドリア L-8 | T npc.231.Suspicious_Elvaan = npc:Suspicious Elvaan@北サンドリア L-8 | R 北サンドリア | > a02
a02 examine - | すぐ隣のOdyssean Passageから中に入り、イベントを見て完了 | 魂の聖櫃に移る。 | @北サンドリア L-8 | T obj.231.Odyssean_Passage = obj:Odyssean Passage@北サンドリア L-8 | R 北サンドリア | >
b01 trade - | 【バストゥーク港】(K-12)のSuspicious Galkaに用意した品をトレードし、「星辰の指輪」をもらう | - | @バストゥーク港 K-12 | T npc.236.Suspicious_Galka = npc:Suspicious Galka@バストゥーク港 K-12 | R バストゥーク港 | > b02
b02 examine - | すぐ隣のOdyssean Passageから中に入り、イベントを見て完了 | 魂の聖櫃に移る。 | @バストゥーク港 K-12 | T obj.236.Odyssean_Passage = obj:Odyssean Passage@バストゥーク港 K-12 | R バストゥーク港 | >
c01 trade - | 【ウィンダス港】(M-4)のSuspicious Tarutaruに用意した品をトレードし、「星辰の指輪」をもらう | - | @ウィンダス港 M-4 | T npc.240.Suspicious_Tarutaru = npc:Suspicious Tarutaru@ウィンダス港 M-4 | R ウィンダス港 | > c02
c02 examine - | すぐ隣のOdyssean Passageから中に入り、イベントを見て完了 | 魂の聖櫃に移る。 | @ウィンダス港 M-4 | T obj.240.Odyssean_Passage = obj:Odyssean Passage@ウィンダス港 M-4 | R ウィンダス港 | >

@ quest.misc.025 https://wiki.ffo.jp/html/15810.html
Q A Generous General? | ゴブリンの仁義 | yes | T npc.11.GuZho_Thunderblade = npc:Gu'Zho Thunderblade@ムバルポロス旧市街
RW item:チョプリクスコイフ
RW item:獣人金貨
RW title:モブリンキンズマン
LK condition:Lv60以上
LK other:ほかの獣人帽子クエスト（クゥダフの博雅・オークの謙譲・ヤグードの勇胆）を受けておらず、ヒーロー帽子を装備していない
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Generous_General%3F;Faulpie は革工ギルド（南サンドリア E-8、HP#4）。Repeatable=Yes（コンクェスト集計ごとに1回）。ゴブリンコイフは革細工75・鍛冶38・裁縫27、土のクリスタル。材料は Goblin Cutting・Steel Sheet・Linen Cloth・Artificial Lens×2・Moblin Thread・Undead Skin・Sheep Leather
g01 go - | 北グスタベルグ(K-6)の南東側の入口からムバルポロス旧市街に入り、イベントで「はい」を選んで受ける | 西側から入ってもイベントは起きない。「いいえ」を選ぶとヴァナ0時を越えるまで受け直せない。 | @北グスタベルグ K-6
g02 talk - | 南サンドリア(E-8)の革工ギルドのギルドマスター Faulpie に話す | - | @南サンドリア E-8 | T npc.230.Faulpie = npc:Faulpie@南サンドリア E-8
g03 trade - | Faulpie に「野牛の毛皮」「大羊のなめし革」と10000ギルをトレードする | - | @南サンドリア E-8 | T npc.230.Faulpie | N 野牛の毛皮*1 | N 大羊のなめし革*1
g04 talk - | ヴァナ・ディール時間の0時を越えてから Faulpie にもう一度話し、「ゴブリン頭巾シート」をもらう | - | @南サンドリア E-8 | T npc.230.Faulpie | W ヴァナ時間の0時を越えてから
g05 gather - | ゴブリン頭巾シートで「ゴブリンコイフ」を合成する（革細工75、鍛冶38・裁縫27。土のクリスタル） | ほかの材料は合成レシピで確かめる。腕が足りなければ革細工職人に頼む。失敗したら Faulpie に10万ギルを渡すとシートをもう一度もらえる。 | N ゴブリンコイフ*1
g06 go - | ゴブリンコイフを装備して、北グスタベルグ(K-6)の南東側の入口からムバルポロス旧市街に入り、「ゴブリンの推薦状」をもらう | シートをもらうイベントを済ませていないと起きない。 | @北グスタベルグ K-6
g07 examine - | ゴブリンコイフを装備したまま(G-8)のIron Boxを調べ、NMを7体呼び出す | 倒すのはボスの Goblin Preceptor（赤魔道士）だけでよい。ボスにスリプルは効かないが、護衛には効く。 | @ムバルポロス旧市街 G-8 | T obj.11.Iron_Box = obj:Iron Box@ムバルポロス旧市街 G-8
g08 defeat - | Goblin Preceptor を倒す | 倒すと護衛のNMはみな消える。 | @ムバルポロス旧市街 G-8 | T mob.11.Goblin_Preceptor = mob:Goblin Preceptor@ムバルポロス旧市街 G-8
g09 examine - | ゴブリンコイフを装備したまま、もう一度Iron Boxを調べてイベントを見る | このイベントの前にエリアを出ると、倒したことが取り消される。 | @ムバルポロス旧市街 G-8 | T obj.11.Iron_Box
g10 trade - | Iron Boxにゴブリンコイフをトレードし、「チョプリクスコイフ」と取り替えて完了 | チョプリクスコイフを装備して北グスタベルグ(K-6)から入り直すと、獣人金貨がもらえる。 | @ムバルポロス旧市街 G-8 | T obj.11.Iron_Box | N ゴブリンコイフ*1

@ quest.misc.026 https://wiki.ffo.jp/html/31585.html
Q Feeding Frenzy | ごはんをあげてみるクポ | no
LK quest:クエスト「子羊を放ってみるクポ」を終えている
g01 trade - | モグガーデンのLittleSheepに「ラテーヌキャベツ」をトレードする | - | N ラテーヌキャベツ*1
g02 go - | いったんエリアを出て、もう一度モグガーデンに入り、イベントを見て完了 | 続けて「悲しむだけじゃだめクポ」が始まる。

@ quest.misc.027 https://wiki.ffo.jp/html/35683.html
Q Glittering Gals | たね★うえ？ | no | T npc.280.Green_Thumb_Moogle = npc:Green Thumb Moogle@モグガーデン
RW other:だいじなもの「♪大羊」
RW title:疾走ガーデンライダー
LK quest:クエスト「ライドオン！」「モグの書」「みんな家族クポ」をすべて終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Glittering_Gals;英名は Glittering Gals（用語辞典は Glittering Girls）。称号は Gardener for the Ages とあり用語辞典と違う。バルクルムの太陽砂はバルクルム砂丘(H-9)の???で砂塵の天候のときに拾える。トロピカルカクタスは競売でも買える
g01 talk - | モグガーデンのGreen Thumb Moogleに話し、「謎の果物の種」をもらう | ほかのクエストを終えたあと、エリアを出入りしなくてよい。
g02 gather - | 「トロピカルカクタス」を1つ用意する | 種を畑に植えてバルクルムの太陽砂を肥料にすると採れるが、必ず採れるわけではない。種は何でもよく、1時間で採れる反魂樹の根に太陽砂を使うほうが早い。競売で買うのがいちばん早い。 | N トロピカルカクタス*1
g03 trade - | Green Thumb Moogleにトロピカルカクタスをトレードして完了 | - | N トロピカルカクタス*1

@ quest.misc.028 https://wiki.ffo.jp/html/34947.html
Q Rowing Together | みんな家族クポ | no
RW item:サッチブーツ
LK quest:クエスト「チャチャルンのお医者さん」を終えている
LK condition:モグガーデンのモンスター飼育のランクが7
g01 go - | モグガーデンに入ってイベントを見る | -
g02 talk - | ジュノ下層(H-9)のゴブリンの店のStinknixに話し、「チャチャルン宛ての荷物」をもらう | - | @ジュノ下層 H-9 | T npc.245.Stinknix = npc:Stinknix@ジュノ下層 H-9
g03 talk - | モグガーデンの飼育場にいるChacharoonに話して完了 | ガーデンの真ん中ではなく、飼育場のほうにいる。

@ quest.misc.029 https://wiki.ffo.jp/html/29734.html
Q Hypnotic Hospitality | グモパスなおもてなし | no | T npc.280.Green_Thumb_Moogle
RW item:クワ
RW title:クワッどコア
LK quest:クエスト「サングラスなおもてなし」を終えている
LK condition:GPSクリスタルに星のきらめきが20回灯っている
g01 talk - | モグガーデンのGreen Thumb Moogleに話して受ける | 終えるまで、ガーデンで最初に話しかけるたびに品を催促される。
g02 gather - | 「魚籠【堀ブナ】」「ナットベイン」「デーツ」を用意する | 魚籠【堀ブナ】は池にワークス練り餌を入れるとときどき採れる（ＭＭＭ水産課を終えると確実）。ナットベインは謎の香草の種か森の香草の種、デーツは謎の多肉植物の子株か森の果実の種を畑に植えると採れる。 | N 魚籠【堀ブナ】*1 | N ナットベイン*1 | N デーツ*1
g03 trade - | Green Thumb Moogleに3つまとめてトレードする | - | N 魚籠【堀ブナ】*1 | N ナットベイン*1 | N デーツ*1
g04 go - | ヴァナ・ディール時間の0時を越えてからモグガーデンに入り直し、イベントを見る | - | W ヴァナ時間の0時を越えてから
g05 talk - | Green Thumb Moogleに話してクワをもらい、完了 | -

@ quest.misc.030 https://wiki.ffo.jp/html/29239.html
Q Trinket for the Tyrant | サングラスなおもてなし | no | T npc.280.Green_Thumb_Moogle
RW item:ワークス促成剤
LK quest:クエスト「ノマドなおもてなし」を終えている
LK condition:GPSクリスタルに星のきらめきが10回灯っている
g01 talk - | モグガーデンのGreen Thumb Moogleに話して受ける | -
g02 examine - | 海岸の漂着物（Flotsam）を調べ、だいじなもの「ガラスの振り子」を手に入れる | -
g03 talk - | Green Thumb Moogleに話して完了 | -

@ quest.misc.031 https://wiki.ffo.jp/html/33936.html
Q Doctor Chacharoon | チャチャルンのお医者さん | no
RW item:ワークグローブ
LK quest:クエスト「チャチャルンの試練」を終えている
LK condition:モグガーデンのモンスター飼育のランクが5
g01 go - | モグガーデンに入ってイベントを見る | -
g02 gather - | 「ザリガニ」を12匹用意する | - | N ザリガニ*12
g03 trade - | Green Thumb Moogleにザリガニを12匹まとめてトレードして完了 | - | N ザリガニ*12

@ quest.misc.032 https://wiki.ffo.jp/html/32670.html
Q Trial of the Chacharoon | チャチャルンの試練 | no
RW other:フェイス「チャチャルン」を覚える
LK quest:クエスト「チャチャルンの応援」を終えている
LK condition:モグガーデンのモンスター飼育のランクが3
LK item:3種類のフェイス使用許可証のどれかを持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Trial_of_the_Chacharoon;ランク3はだいじなもの「Sakura and the Fountain」を買って上げる。飼育場へはボートの近くの小道から行く
g01 go - | モグガーデンに入ってイベントを見る | 飼育場の使い方の説明もある。
g02 talk - | ボートの近くの小道から新しい飼育場へ行き、Chacharoonに話して完了 | フェイス使用許可証を持っていないと進まない。

@ quest.misc.033 https://wiki.ffo.jp/html/29238.html
Q Courtesy Crustacean | ノマドなおもてなし | no | T npc.280.Green_Thumb_Moogle
RW item:ワークス促成剤
LK quest:クエスト「漂着物を調べてみるクポ」を終えている
LK condition:GPSクリスタルに星のきらめきが4回灯っている（数ではなく、ガーデンでログインして増えた回数）
g01 talk - | モグガーデンのGreen Thumb Moogleに話して受ける | きらめき2倍のボーナスで5個以上になっても始まらない。
g02 examine - | 海岸の網（Coastal Fishing Net）を引き揚げ、だいじなもの「七色ハマグリ」を手に入れる | -
g03 talk - | Green Thumb Moogleに話して完了 | もらうワークス促成剤は「マウ★ント！」で要るので取っておく。

@ quest.misc.034 https://wiki.ffo.jp/html/35684.html
Q Sally Forth! | マウ★ント！ | no
RW other:だいじなもの「♪モルボル」
RW title:伝説ラグーンライダー
LK quest:クエスト「たね★うえ？」を終えて、エリアを出入りしている
g01 talk - | モグガーデンのGreen Thumb Moogleに話し、イベントを見る | 「ワークス促成剤」を求められる。
g02 trade - | Green Thumb Moogleにワークス促成剤をトレードし、イベントを見て完了 | - | N ワークス促成剤*1

@ quest.misc.035 https://wiki.ffo.jp/html/31518.html
Q Titillating Tomes | モグの書 | no | T npc.280.Green_Thumb_Moogle
RW item:ストローハット
RW title:あばばばヒーラー
LK quest:クエスト「グモパスなおもてなし」を終えている
LK condition:モグガーデンのランク（畑・木立・鉱脈・池・海）がすべて7
g01 talk - | モグガーデンのGreen Thumb Moogleに話してイベントを見る | 4つがランク7でも始まらない。
g02 gather - | 「ドリルカラマリ」「更紗コメット」「賢者の石」を用意する | 海の網・池・鉱脈からと言われるが、どこで手に入れてもよい。 | N ドリルカラマリ*1 | N 更紗コメット*1 | N 賢者の石*1
g03 trade - | Green Thumb Moogleに3つまとめてトレードして完了 | - | N ドリルカラマリ*1 | N 更紗コメット*1 | N 賢者の石*1

@ quest.misc.036 https://wiki.ffo.jp/html/31584.html
Q Release the Fleece | 子羊を放ってみるクポ | no | T npc.280.Green_Thumb_Moogle
LK condition:畑・木立・鉱脈・池・海のランクが平均4以上
LK other:アシスタントのススルンを解放している（契約中でなくてよい）
g01 talk - | モグガーデンのGreen Thumb Moogleに話してイベントを見る | Chacharoonがガーデンに来る。
g02 talk - | Chacharoonに話し、「ヒツジ」を育て始める | -
g03 talk - | もう一度Chacharoonに話す | ヒツジに触れてみろと言われる。
g04 talk - | LittleSheepに話して「モンスターに触る」をする | 中身はどれでもよい。
g05 talk - | Chacharoonに報告する | -
g06 talk - | Green Thumb Moogleに報告して完了 | 続けて「ごはんをあげてみるクポ」が始まる。

@ quest.misc.037 https://wiki.ffo.jp/html/31586.html
Q Cry Not, Caretaker | 悲しむだけじゃだめクポ | no
RW item:マトンのロースト
RW title:命をかける飼育士
RW other:だいじなもの「子羊の思い出」
LK quest:クエスト「ごはんをあげてみるクポ」を終えている
g01 gather - | 「木綿糸」を1つ用意する | - | N 木綿糸*1
g02 trade - | モグガーデンのGreen Thumb Moogleに木綿糸をトレードし、イベントを見て完了 | このあとモンスター飼育を本格的に始められる。 | N 木綿糸*1

@ quest.misc.038 https://wiki.ffo.jp/html/29045.html
Q Green Groves | 木立の収穫をしてみるクポ | no
LK quest:クエスト「畑の収穫をしてみるクポ」を終えている（続けて始まる）
g01 examine - | モグガーデンの左のほうにある木立（Arboreal Grove）を調べ、伐採か収穫をする | まさかりや草刈鎌は要らない。
g02 talk - | Green Thumb Moogleに報告して完了 | 続けて「鉱脈を調査してみるクポ」が始まる。

@ quest.misc.039 https://wiki.ffo.jp/html/29047.html
Q Pond Probing | 池の網を調べてみるクポ | no
LK quest:クエスト「鉱脈を調査してみるクポ」を終えている（続けて始まる）
g01 examine - | モグガーデンの左奥にある池の網（Pond Dredger）を調べ、網を引いて魚を取る | -
g02 talk - | Green Thumb Moogleに報告して完了 | 続けて「砂浜で網を調べてみるクポ」が始まる。

@ quest.misc.040 https://wiki.ffo.jp/html/29050.html
Q Flotsam Finding | 漂着物を調べてみるクポ | no
RW item:ガーデンワーム、木立蚯蚓、ストーンオイル、イワシ練り餌、イワシ撒き餌
RW title:モグガーデンのタマゴ
LK quest:クエスト「畑に種まきしてみるクポ」を終えている（続けて始まる）
g01 examine - | モグガーデンの手前の砂浜にある漂着物（Flotsam）を調べ、水の塊などを拾う | -
g02 talk - | Green Thumb Moogleに報告して完了 | 持ち物の空きが5つないと完了できないので、先に空けておく。

@ quest.misc.041 https://wiki.ffo.jp/html/29049.html
Q Seed Sowing | 畑に種まきしてみるクポ | no | T npc.280.Green_Thumb_Moogle
LK quest:クエスト「砂浜で網を調べてみるクポ」を終えている（続けて始まる）
g01 talk - | Green Thumb Moogleから「謎の香草の種」をもらう | 受ける前に種を植えていると、次に植えられるときまで終えられない。
g02 examine - | 畑のそばの籠（Garden Furrow）を調べ、謎の香草の種を植える | - | N 謎の香草の種*1
g03 talk - | Green Thumb Moogleに報告して完了 | 続けて「漂着物を調べてみるクポ」が始まる。

@ quest.misc.042 https://wiki.ffo.jp/html/29044.html
Q Full Fields | 畑の収穫をしてみるクポ | no
RW item:GPSクリスタル
g01 go - | 初めてモグガーデンに入ってイベントを見る | 自動で受け、GPSクリスタルを1つもらう。
g02 examine - | 畑のそばの籠（Garden Furrow）を調べ、実をつけた「森の香草の種」を収穫する | -
g03 talk - | Green Thumb Moogleに報告して完了 | 続けて「木立の収穫をしてみるクポ」が始まる。

@ quest.misc.043 https://wiki.ffo.jp/html/29048.html
Q Coastal Chaos | 砂浜で網を調べてみるクポ | no
LK quest:クエスト「池の網を調べてみるクポ」を終えている（続けて始まる）
g01 examine - | モグガーデンの右手前の砂浜にある定置網（Coastal Fishing Net）を調べ、網を引いて魚を取る | -
g02 talk - | Green Thumb Moogleに報告して完了 | 続けて「畑に種まきしてみるクポ」が始まる。

@ quest.misc.044 https://wiki.ffo.jp/html/29046.html
Q Mining Missive | 鉱脈を調査してみるクポ | no
LK quest:クエスト「木立の収穫をしてみるクポ」を終えている（続けて始まる）
g01 examine - | モグガーデンの奥にある鉱脈（Mineral Vein）を調べて掘る | つるはしは要らない。
g02 talk - | Green Thumb Moogleに報告して完了 | 続けて「池の網を調べてみるクポ」が始まる。

@ quest.misc.045 https://wiki.ffo.jp/html/6068.html
Q The Moogle's Picnic! | ピクニックに行きたいクポの巻 | no
RW other:モグ金庫が70個まで入るようになる
RW title:すてきなご主人さま
LK quest:クエスト「モグ祭りが近いクポの巻」を終えている
LK fame:所属国の名声ランク5（かなり知られる）以上
g01 go - | モグハウスにマホガニーベッドを置き、地球時間で1分待ってから、いったん出て入り直す | ログアウトではだめ。
g02 talk - | 所属国のモグハウスのモーグリに話し、イベントが起きたら受ける | -
g03 trade - | モーグリに「シュリンプルアー」と「セルビナバター」をトレードし、地球時間で1分待つ | - | N シュリンプルアー*1 | N セルビナバター*1
g04 talk - | モーグリにもう一度話して完了 | -

@ quest.misc.046 https://wiki.ffo.jp/html/5564.html
Q Give a Moogle a Break | モグ祭りが近いクポの巻 | no
RW other:モグ金庫が60個まで入るようになる
RW title:やさしいご主人様
LK fame:所属国の名声ランク3（聞いた覚えがある）以上
g01 go - | モグハウスにブロンズベッドを置き、地球時間で1分過ごす | ベッドを置いてモーグリに話し続けていれば、そのうち始まる。
g02 talk - | 所属国のモグハウスのモーグリに話し、イベントが起きたら受ける | -
g03 trade - | モーグリに「パワーボウ」と「ビートルリング」をトレードし、地球時間で1分待つ | - | N パワーボウ*1 | N ビートルリング*1
g04 talk - | モーグリにもう一度話して完了 | -

@ quest.misc.047 https://wiki.ffo.jp/html/7794.html
Q Moogles in the Wild | 世界は広いクポの巻 | no
RW other:モグ金庫が80個まで入るようになる
RW title:ラブラブご主人さま
LK quest:クエスト「ピクニックに行きたいクポの巻」を終えている
LK fame:所属国の名声ランク7以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Moogles_in_the_Wild;FLevel=7（用語辞典はランク6「ほとんど知っている」）
g01 go - | モグハウスにノーブルベッドを置き、地球時間で1分待つ | テキスタイルダイで染めたノーブルベッドではだめ。
g02 talk - | 所属国のモグハウスのモーグリに話し、イベントが起きたら受ける | -
g03 trade - | モーグリに「ラプトルマント」と「ウールハット」をトレードし、地球時間で1分待つ | - | N ラプトルマント*1 | N ウールハット*1
g04 talk - | モーグリにもう一度話して完了 | -

@ quest.misc.048 https://wiki.ffo.jp/html/5276.html
Q Waking the Beast | 神在月 | yes | T obj.102.Carbuncle = obj:???@ラテーヌ高原 G-6
RW item:カーバンクルポール
RW other:光を失った紅玉（だいじなもの）
LK other:イフリート・タイタン・リヴァイアサン・ガルーダ・シヴァ・ラムウの6体と契約している
XS BG Wiki;https://www.bg-wiki.com/ffxi/Waking_the_Beast;Repeatable=Yes（用語辞典はコンクェスト集計ごと）。回廊戦の召喚獣はLv85。満月の泉へはHPワープでトライマライ水路から行くのが早い。報酬はカーバンクルポールのほか、カフスや各神獣の武器も挙がっている
g01 examine - | ラテーヌ高原(G-6)の???を調べて受け、「虹の呼び玉」をもらう | - | @ラテーヌ高原 G-6 | T obj.102.Carbuncle
g02 fight - | 灼熱・震動・海流・突風・凍結・雷鳴の各回廊でBF「神在月」に勝ち、6つの「まなこ」（火・土・水・風・氷・雷）を集める | 18人・30分まで、フェイスは呼べない。音叉は要らない。お供のエレメンタルは召喚獣と敵対心を共有し、睡眠・スタン・サイレスが効かないので、出たらすぐ倒す。
g03 fight - | 6つそろったら満月の泉でBF「神在月」を選び、最終戦に勝つ | 18人・30分まで、フェイスは呼べない。Carbuncle PrimeのHPを削るたびに召喚獣が1体・2体・3体と出て、最後にCarbuncle Primeが5体出る。究極履行に巻き込まれないよう散らばって戦う。勝ったら「光を失った紅玉」をもらう。
g04 examine - | ラテーヌ高原(G-6)の???を調べて完了 | 満月の泉での選び方で称号が変わる。 | @ラテーヌ高原 G-6 | T obj.102.Carbuncle

@ quest.misc.049 https://wiki.ffo.jp/html/15812.html
Q An Understanding Overlord? | オークの謙譲 | yes | T npc.150.Loo_Kohor = npc:Loo Kohor@修道窟
RW item:ザラッドヘルム
RW item:獣人金貨
RW title:オーキシュサージェント
LK condition:Lv60以上
LK other:ほかの獣人帽子クエスト（ゴブリンの仁義・ヤグードの勇胆・クゥダフの博雅）を受けておらず、ヒーロー帽子を装備していない
XS BG Wiki;https://www.bg-wiki.com/ffxi/An_Understanding_Overlord%3F;Repeatable=Yes。Cryptexphere は (F-6)。オークヘルムは革細工74・鍛冶31・裁縫22、土のクリスタル。材料は Orc Cutting・Iron Sheet・Linen Thread・Wool Thread・Manticore Hair×2・Black Pearl×2
g01 go - | ダボイ(G-7)から魔晶石のある修道窟に入り、イベントで「はい」を選んで受ける | 「いいえ」を選ぶとヴァナ0時を越えるまで受け直せない。 | @ダボイ G-7
g02 talk - | 南サンドリア(E-8)の革工ギルドのギルドマスター Faulpie に話す | - | @南サンドリア E-8 | T npc.230.Faulpie = npc:Faulpie@南サンドリア E-8
g03 trade - | Faulpie に「野牛の毛皮」「雄羊のなめし革」と10000ギルをトレードする | - | @南サンドリア E-8 | T npc.230.Faulpie | N 野牛の毛皮*1 | N 雄羊のなめし革*1
g04 talk - | ヴァナ・ディール時間の0時を越えてから Faulpie にもう一度話し、「オーク冑シート」をもらう | - | @南サンドリア E-8 | T npc.230.Faulpie | W ヴァナ時間の0時を越えてから
g05 gather - | オーク冑シートで「オークヘルム」を合成する（革細工74、鍛冶31・裁縫22。土のクリスタル） | ほかの材料は合成レシピで確かめる。腕が足りなければ革細工職人に頼む。失敗したら Faulpie に10万ギルを渡すとシートをもう一度もらえる。 | N オークヘルム*1
g06 go - | オークヘルムを装備して修道窟に入り、「シシュの親書」をもらう | - | @ダボイ G-7
g07 examine - | オークヘルムを装備したままCryptexphereを調べ、NMを7体呼び出す | 倒すのはボスの Orcish Overlord（ナイト）だけでよい。ボスにスリプル・サイレスは効かない。HPが減るとインビンシブルを使い、攻撃力がとても上がる。 | @修道窟 F-6 | T obj.150.Cryptexphere = obj:Cryptexphere@修道窟 F-6
g08 defeat - | Orcish Overlord を倒す | 倒すと護衛のNMはみな消える。 | @修道窟 F-6 | T mob.150.Orcish_Overlord = mob:Orcish Overlord@修道窟 F-6
g09 examine - | オークヘルムを装備したまま、もう一度Cryptexphereを調べてイベントを見る | このイベントの前にエリアを出ると、倒したことが取り消される。済ませたあとは日を改めてよい。 | @修道窟 F-6 | T obj.150.Cryptexphere
g10 trade - | Cryptexphereにオークヘルムをトレードし、「ザラッドヘルム」と取り替えて完了 | ザラッドヘルムを装備して修道窟に入り直すと、獣人金貨がもらえる。 | @修道窟 F-6 | T obj.150.Cryptexphere | N オークヘルム*1

@ quest.misc.050 https://wiki.ffo.jp/html/15809.html
Q A Moral Manifest? | ヤグードの勇胆 | yes | T npc.152.Hooknox = npc:Hooknox@祭壇の間
RW item:ハジャヘッドギア
RW item:獣人金貨
RW title:ヤグードイニシエート
LK condition:Lv60以上
LK other:ほかの獣人帽子クエスト（ゴブリンの仁義・オークの謙譲・クゥダフの博雅）を受けておらず、ヒーロー帽子を装備していない
XS BG Wiki;https://www.bg-wiki.com/ffxi/A_Moral_Manifest%3F;Repeatable は空欄（用語辞典は再オファー可）。ヤグードヘッドギアは裁縫80・革細工50・骨細工55、土のクリスタル。材料は Yagudo Cutting・Bugard Tusk・Cockatrice Skin・Wool Thread・Yagudo Feather×2・Black Pearl×2。金貨のイベントは南側から出て入り直す
g01 go - | オズトロヤ城から祭壇の間に入り、イベントで「はい」を選んで受ける | 「いいえ」を選ぶとヴァナ0時を越えるまで受け直せない。 | @オズトロヤ城
g02 talk - | ウィンダス森の区(G-12)の織工ギルドのギルドマスター Ponono に話す | - | @ウィンダス森の区 G-12 | T npc.241.Ponono = npc:Ponono@ウィンダス森の区 G-12
g03 trade - | Ponono に「ビロード」「虹布」と10000ギルをトレードする | - | @ウィンダス森の区 G-12 | T npc.241.Ponono | N ビロード*1 | N 虹布*1
g04 talk - | ヴァナ・ディール時間の0時を越えてから Ponono にもう一度話し、「ヤグード頭衣シート」をもらう | - | @ウィンダス森の区 G-12 | T npc.241.Ponono | W ヴァナ時間の0時を越えてから
g05 gather - | ヤグード頭衣シートで「ヤグードヘッドギア」を合成する（裁縫80、革細工50・骨細工55。土のクリスタル） | ほかの材料は合成レシピで確かめる。腕が足りなければ裁縫職人に頼む。失敗したら Ponono に10万ギルを渡すとシートをもう一度もらえる。 | N ヤグードヘッドギア*1
g06 go - | ヤグードヘッドギアを装備して祭壇の間に入り、「宝物庫のキープ」をもらう | - | @オズトロヤ城
g07 examine - | ヤグードヘッドギアを装備したままStone Lidを調べ、NMを7体呼び出す | 倒すのはボスの Yagudo Avatar（召喚士）だけでよい。ボスにスリプルは効かない。HPが減るとアストラルフロウを使い、魔法がとても効きにくくなる。呼び出すエレメンタルは寝かせるかサイレスで止める。 | @祭壇の間 | T obj.152.Stone_Lid = obj:Stone Lid@祭壇の間
g08 defeat - | Yagudo Avatar を倒す | 倒すと護衛のNMはみな消える。 | @祭壇の間 | T mob.152.Yagudo_Avatar = mob:Yagudo Avatar@祭壇の間
g09 examine - | ヤグードヘッドギアを装備したまま、もう一度Stone Lidを調べてイベントを見る | このイベントの前にエリアを出ると、倒したことが取り消される。済ませたあとは日を改めてよい。 | @祭壇の間 | T obj.152.Stone_Lid
g10 trade - | Stone Lidにヤグードヘッドギアをトレードし、「ハジャヘッドギア」と取り替えて完了 | ハジャヘッドギアを装備し、祭壇の間の南側から出て入り直すと、獣人金貨がもらえる。 | @祭壇の間 | T obj.152.Stone_Lid | N ヤグードヘッドギア*1

@ quest.misc.051 https://wiki.ffo.jp/html/10155.html
Q Wandering Souls | 彷徨いし魂の鎮魂 | no | T obj.113.Cermet_Headstone = obj:Cermet Headstone@テリガン岬 H-5
RW item:フラジラントロープ
RW title:時を越えた絆持つ者
LK quest:ジラートミッション「古代石碑巡礼」でテリガン岬の石碑の NM を倒した（いつのまにかオファーリストに載る）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Wandering_Souls;Cermet Headstone は テリガン岬(H-5)。ミッション「古代石碑巡礼」を受けている間から
g01 gather - | 「レインリリー」を1つ用意する | - | N レインリリー*1
g02 trade - | テリガン岬(H-5)の石碑（Cermet Headstone）に「レインリリー」をトレードして完了 | - | @テリガン岬 H-5 | T obj.113.Cermet_Headstone | N レインリリー*1

@ quest.misc.052 https://wiki.ffo.jp/html/10154.html
Q Wrath of the Opo-opos | オポオポの怒り | no | T obj.123.Cermet_Headstone = obj:Cermet Headstone@ユタンガ大森林 L-6 L-7
RW item:オポオポネックレス
RW title:オポオポの友
LK quest:ジラートミッション「古代石碑巡礼」で火の石碑の NM を倒し、だいじなもの「炎の祈り」を手に入れた（自動でオファーリストに載る）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Wrath_of_the_Opo-opos;Cermet Headstone は ユタンガ大森林(L-7)（用語辞典は L-6）
g01 gather - | 「ガーネット」を1つ用意する | ミッションで石碑へ行くときに持っていくと、ついでに終えられる。 | N ガーネット*1
g02 trade - | ユタンガ大森林の火の石碑（Cermet Headstone）に「ガーネット」をトレードして完了 | - | @ユタンガ大森林 L-6 L-7 | T obj.123.Cermet_Headstone | N ガーネット*1

@ quest.misc.053 https://wiki.ffo.jp/html/692.html
Q Divine Might | 神威 | no | T npc.178.Yvenoile = npc:Yve'noile@ル・アビタウ神殿 H-11 #2
RW item:素破の耳／騎士の耳／暗黒の耳／獣使の耳／武士の耳 のどれか1つ
RW title:神威
LK quest:ジラートミッション「アーク・ガーディアン」を受けている（または終えている）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Divine_Might;Quest Reqs=Zilart Mission 13 complete。FLevel は空。Repeatable=Yes は耳の取り直し（別の同名クエスト）のこと。受けるのは ル・アビタウ神殿(G/H-11)の名前のない的で、受けずにBFに勝っても認められない。BFは30分・アライアンス18人まで
g01 examine - | ル・アビタウ神殿MAP2、Ru'Avitau Gateを入ってすぐの名前のない「＿」を調べてイベント、もう一度調べて受ける | 受けずにBFに勝っても認められず、五戦士魔法陣を作り直すことになる。 | @ル・アビタウ神殿 G-11 H-11 #2
g02 trade - | 突入手続きをする人は、満月の夜のヴァナ時間18:00〜6:00に、ロ・メーヴ(H-6)のQu'Hau Springに「光るインク」と「羊皮紙」をトレードして「五戦士魔法陣」を手に入れる | アライアンスで1人が持っていればよい。 | @ロ・メーヴ H-6 | T obj.122.QuHau_Spring | N 光るインク*1,羊皮紙*1 | W 満月の夜 18:00〜6:00
g03 fight - | ラ・ロフの劇場に「五戦士魔法陣」をトレードしてBF「神威」に入り、Ark Angel HM・TT・MR・EV・GKの5体に勝つ | 5体（とペット・子竜）を同時に相手にする。30分・アライアンス18人まで。TT は早めに倒す。MR は魅了を使う。 | @ラ・ロフの劇場 | N 五戦士魔法陣*1
g04 examine - | ル・アビタウ神殿の「＿」を調べてイベント、耳を選んで完了 | ミッション「アーク・ガーディアン」の途中なら、5つのかけらももらえて次の「閉ざされし門」へ進める。 | @ル・アビタウ神殿 G-11 H-11 #2

@ quest.misc.054 https://wiki.ffo.jp/html/692.html
Q Divine Might | 神威 | yes | T npc.178.Yvenoile
RW item:素破の耳／騎士の耳／暗黒の耳／獣使の耳／武士の耳 のどれか1つ
RW title:神威
LK quest:1回目の「神威」クリア
LK condition:今の神威耳を捨てて、エリアを出入りしておく（リサイクルに残っていると受けられない）
LK other:耳を取り直したあと、また受けるにはコンクェストの集計をはさむ
XS BG Wiki;https://www.bg-wiki.com/ffxi/Divine_Might;Re-Questing の節。コンクェスト集計ごとに1回。月光の鉱石は一人ひとつ必要。光の鉱石・光るインク・羊皮紙を同時に渡すと月光の鉱石しかもらえないので、2回に分けて渡す。一度使った五戦士魔法陣は使えない
g01 examine - | 神威耳を捨ててエリアを出入りしてから、ル・アビタウ神殿MAP2入口すぐの「＿」を調べて受ける | オファーリストに2つめの「神威」として載る。 | @ル・アビタウ神殿 G-11 H-11 #2
g02 trade - | 満月の夜のヴァナ時間18:00〜6:00に、ロ・メーヴ(H-6)のQu'Hau Springに「光の鉱石」をトレードして、だいじなもの「月光の鉱石」をもらう | 全員がひとつずつ必要。ないとBFに入れても耳はもらえない。受ける前には作れない。 | @ロ・メーヴ H-6 | T obj.122.QuHau_Spring | N 光の鉱石*1 | W 満月の夜 18:00〜6:00
g03 trade - | 突入手続きをする人は、同じ時間にQu'Hau Springへ「光るインク」と「羊皮紙」を別にトレードして「五戦士魔法陣」を手に入れる | 一度使った五戦士魔法陣は使えない。光の鉱石といっしょに渡すと月光の鉱石しかもらえない。 | @ロ・メーヴ H-6 | T obj.122.QuHau_Spring | N 光るインク*1,羊皮紙*1 | W 満月の夜 18:00〜6:00
g04 fight - | ラ・ロフの劇場に「五戦士魔法陣」をトレードしてBF「神威」に入り、Ark Angel 5体に勝つ | - | @ラ・ロフの劇場 | N 五戦士魔法陣*1 | K 月光の鉱石
g05 examine - | ル・アビタウ神殿の「＿」を調べてイベント、耳を選んで完了 | - | @ル・アビタウ神殿 G-11 H-11 #2

@ quest.misc.055 https://wiki.ffo.jp/html/24835.html
Q Open Sesame | 1人でも開いちゃう？ | no | T npc.114.Lokpix = npc:Lokpix@東アルテパ砂漠 G-7
RW other:だいじなもの「重量石」（流砂洞の重量扉をひとりで開けられる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Open_Sesame;Lokpix は 東アルテパ砂漠(G-7)。FLevel は空。震動石は流砂洞の西の震動の回廊にあり、流砂洞のホームポイント#2が近い。品はいっしょにトレードする
g01 talk - | 東アルテパ砂漠(G-7)ルテのゲートクリスタルそばのLokpixに話し、重量扉の話を聞く | - | @東アルテパ砂漠 G-7 | T npc.114.Lokpix
g02 gather - | 「震動石」1つと「隕石」1つを用意する | 隕石のかわりに「土の精霊石」1つか「土の石印」12個でもよい。震動石は流砂洞の震動の回廊で取れる。 | N 震動石*1,隕石*1
g03 trade - | Lokpixに「震動石」と「隕石」をいっしょにトレードし、だいじなもの「重量石」をもらって完了 | - | @東アルテパ砂漠 G-7 | T npc.114.Lokpix | N 震動石*1,隕石*1

@ quest.misc.056 https://wiki.ffo.jp/html/6252.html
Q Soul Searching | 不浄なる魂の浄化 | no | T obj.121.Cermet_Headstone = obj:Cermet Headstone@聖地ジ・タ I-7
RW item:バットピアス
RW title:聖地に魂導く者
LK quest:ジラートミッション「古代石碑巡礼」でだいじなもの「光の祈り」を手に入れた（自動でオファーリストに載る）
LK quest:ジラートミッション「宣託の間」をクリアしてだいじなもの「虹の祈り」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Soul_Searching;Cermet Headstone は 聖地ジ・タ(I-7)。FLevel=None。Quest Reqs=Zilart Mission 7（The Chamber of Oracles）、Prismatic fragment
g01 gather - | ジラートミッション「宣託の間」をクリアして、だいじなもの「虹の祈り」を手に入れる | 「古代石碑巡礼」の時点ではまだ終えられない。
g02 examine - | 聖地ジ・タ(I-7)の石碑（Cermet Headstone）を調べて完了 | - | @聖地ジ・タ I-7 | T obj.121.Cermet_Headstone | K 虹の祈り

@ quest.misc.057 https://wiki.ffo.jp/html/7914.html
Q Bombs Away! | スノールと狩人 | yes | T npc.5.Buffalostalker_Dodzbraz = npc:Buffalostalker Dodzbraz@ウルガラン山脈 F-9
RW item:シュ・メーヨ海の塩
LK condition:プロマシアミッション「迎え火」を進めている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Bombs_Away!;Fame=Other、FLevel は空。Repeatable=Yes。Quest Reqs=プロマシアミッション Flames for the Dead の途中。Buffalostalker Dodzbraz は ウルガラン山脈(F-9)、ユニティワープ（Lv128）のすぐ南東。クラスターの魂はクラスター族がよく落とす
g01 talk - | ウルガラン山脈(F-9)のBuffalostalker Dodzbrazに話して受ける | ユニティワープのすぐ南東。 | @ウルガラン山脈 F-9 | T npc.5.Buffalostalker_Dodzbraz
g02 gather - | クラスター族を倒して「クラスターの魂」を2つ集める | - | N クラスターの魂*2
g03 trade - | Buffalostalker Dodzbrazに「クラスターの魂」2つをトレードし、「シュ・メーヨ海の塩」をもらって完了 | 迎え火のスノール族を弱らせるのに使う。 | @ウルガラン山脈 F-9 | T npc.5.Buffalostalker_Dodzbraz | N クラスターの魂*2

@ quest.misc.058 https://wiki.ffo.jp/html/5400.html
Q Mithran Delicacies | ミスラの大好物 | yes | T npc.2.Anguenet = npc:Anguenet@ギルド桟橋 J-10
RW item:サイレドンの黒焼き
LK condition:プロマシアミッション「向かい風」を進めている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Mithran_Delicacies;Fame=Other、FLevel は空。Repeatable=Yes。Quest Reqs=プロマシアミッション Head Wind の途中。Anguenet は ギルド桟橋(J-10)、サバイバルガイドのすぐ横。4番めの選択肢（井守が淵）を選ぶ。マッディサイレドンは競売でも買える。Lourdaude にトレードすると100ギルを求められる
XS FFXIclopedia;https://ffxiclopedia.fandom.com/wiki/Mithran_Delicacies;100ギルは1回目だけ。2回目からはマッディサイレドンだけでよい
g01 talk - | ギルド桟橋(J-10)南桟橋のAnguenetに話し、「井守が淵」を選ぶ | サバイバルガイドのすぐ横。ジャグナー森林(J-8)から入れる。 | @ギルド桟橋 J-10 | T npc.2.Anguenet
g02 gather - | 井守が淵で「マッディサイレドン」を釣る | 競売でも買える。 | N マッディサイレドン*1
g03 trade - | Anguenetの横のトンベリ族Lourdaudeに「マッディサイレドン」をトレードする | - | @ギルド桟橋 J-10 | T npc.2.Lourdaude = npc:Lourdaude@ギルド桟橋 J-10 | N マッディサイレドン*1
g04 trade - | 続けてLourdaudeに100ギルをトレードし、「サイレドンの黒焼き」をもらって完了 | 次からはマッディサイレドンだけで黒焼きにしてくれる。 | @ギルド桟橋 J-10 | T npc.2.Lourdaude | N ギル*100

@ quest.misc.059 https://wiki.ffo.jp/html/12827.html
Q Missionary Moblin | ズィーロゾックの冒険 | no | T npc.11.Koblakiq = npc:Koblakiq@ムバルポロス旧市街 H-11
RW gil:4000
XS BG Wiki;https://www.bg-wiki.com/ffxi/Missionary_Moblin;Fame と FLevel は空。Koblakiq (H-11)。Soiled Letter はダボイかズヴァール城外郭の Orcish Footsoldier
g01 talk - | ムバルポロス旧市街(H-11)のKoblakiqに話して受ける | - | @ムバルポロス旧市街 H-11 | T npc.11.Koblakiq
g02 gather - | ダボイかズヴァール城外郭のオーク族「Orcish Footsoldier」から「汚れた封筒」を手に入れる | - | @ダボイ | N 汚れた封筒*1
g03 trade - | Koblakiqに汚れた封筒をトレードして完了 | 次は「ズィーロゾックの思い出」。 | @ムバルポロス旧市街 H-11 | T npc.11.Koblakiq | N 汚れた封筒*1

@ quest.misc.060 https://wiki.ffo.jp/html/14240.html
Q For the Birds | ズィーロゾックの思い出 | no | T npc.11.Koblakiq
RW item:ジャガーマント
LK quest:「ズィーロゾックの冒険」クリア後にエリアチェンジ
XS BG Wiki;https://www.bg-wiki.com/ffxi/For_the_Birds;Fame=O、FLevel は空。オズトロヤ城の Brass Door (I-8) → 次のマップ (G-7) → Daa Bola the Seer (I-7)。ベドーは (H-7) から地下、(F-8) の出口、(E-10) から上の段、(G-10) の島の Ge'Fhu Yagudoeye。Nickel Quadav 2体と Magnes Quadav 2体
g01 talk - | ムバルポロス旧市街(H-11)のKoblakiqに話して受ける | - | @ムバルポロス旧市街 H-11 | T npc.11.Koblakiq
g02 gather - | 「アルニカの根」を用意する | アルテパ砂漠のサボテンダー族が落とす。競売でも買える。 | @西アルテパ砂漠 | N アルニカの根*1
g03 go - | オズトロヤ城MAP2(I-8)のBrass Doorを開けて先へ進む | 取っ手の片方は落とし穴。引いたらすぐ扉の前から離れ、だめならもう片方を引く。 | @オズトロヤ城 I-8 #2 | T obj.151.Brass_Door_I-8 = obj:Brass Door@オズトロヤ城 I-8 #2
g04 go - | MAP3(G-7)の出口から、MAP7の崖ぞいを北へ進む | - | @オズトロヤ城 G-7 #3
g05 trade - | MAP7(I-7)のDaa Bola the Seerにアルニカの根をトレードする | - | @オズトロヤ城 I-7 #7 | T npc.151.Daa_Bola_the_Seer = npc:Daa Bola the Seer@オズトロヤ城 I-7 #7 | N アルニカの根*1
g06 talk - | ムバルポロス旧市街のKoblakiqに話し、だいじなもの「まばゆく瞬く破片」をもらう | - | @ムバルポロス旧市街 H-11 | T npc.11.Koblakiq | K まばゆく瞬く破片
g07 go - | ベドー(H-7)から地下に入り、(F-8)の出口から地上に出て、(E-10)から上の段へ上がる | The Afflictorに近づくと呪いになる。やまびこ薬か聖水を持っていく。 | @ベドー E-10
g08 talk - | MAP1(G-10)の島のGe'Fhu Yagudoeyeに話す | まわりのクゥダフはリンクするので先に倒す。 | @ベドー G-10 #1 | T npc.147.Ge'Fhu_Yagudoeye = npc:Ge'Fhu Yagudoeye@ベドー G-10 #1
g09 fight - | 出てきたクゥダフ族NM「Nickel Quadav」2体と「Magnes Quadav」2体を倒す | 進められるのは湧かせた1人だけ。次の人は3分待つ。 | @ベドー G-10 #1 | T mob.147.Nickel_Quadav = mob:Nickel Quadav@ベドー G-10 #1
g10 talk - | もう一度Ge'Fhu Yagudoeyeに話してイベント | - | @ベドー G-10 #1 | T npc.147.Ge'Fhu_Yagudoeye
g11 talk - | ムバルポロス旧市街のKoblakiqに話して完了 | 次は「ズィーロゾックの帰還」。 | @ムバルポロス旧市街 H-11 | T npc.11.Koblakiq

@ quest.misc.061 https://wiki.ffo.jp/html/15806.html
Q Better the Demon You Know | ズィーロゾックの帰還 | no | T npc.11.Koblakiq
RW item:ゴブリングレネード
RW title:雇われ背信者
LK quest:「ズィーロゾックの思い出」クリア後にエリアチェンジ
XS BG Wiki;https://www.bg-wiki.com/ffxi/Better_the_Demon_You_Know;Fame=O、FLevel は空。Demon Pen は Blood Demon か Demon General。??? はズヴァール城外郭 (I-8) の Dark Spark が出る門の奥、Marquis Andrealphus と Demon Banneret 2体・Demon Secretary 2体
g01 talk - | ムバルポロス旧市街(H-11)のKoblakiqに話して受ける | - | @ムバルポロス旧市街 H-11 | T npc.11.Koblakiq
g02 gather - | ズヴァール城外郭のBlood DemonかDemon Generalから「デーモンの指ペン」を手に入れる | - | @ズヴァール城外郭 | N デーモンの指ペン*1
g03 trade - | Koblakiqにデーモンの指ペンをトレードする | - | @ムバルポロス旧市街 H-11 | T npc.11.Koblakiq | N デーモンの指ペン*1
g04 talk - | 地球時間で1分待ってから、もう一度Koblakiqに話す | - | @ムバルポロス旧市街 H-11 | T npc.11.Koblakiq
g05 examine - | ズヴァール城外郭MAP2(I-8)の門の奥の???を調べる | まわりのデーモンは先に倒しておく。 | @ズヴァール城外郭 I-8 #2 | T obj.161.???_I-8 = obj:???@ズヴァール城外郭 I-8 #2
g06 fight - | 出てきたデーモン族NM「Marquis Andrealphus」を倒す | お供はボスを倒すと消える。殴られるとザルカバードへ飛ばされるので空蝉がよい。 | @ズヴァール城外郭 I-8 #2 | T mob.161.Marquis_Andrealphus = mob:Marquis Andrealphus@ズヴァール城外郭 I-8 #2
g07 examine - | もう一度???を調べ、だいじなもの「ズィーロゾックの耳当て」を手に入れる | - | @ズヴァール城外郭 I-8 #2 | T obj.161.???_I-8 | K ズィーロゾックの耳当て
g08 talk - | ムバルポロス旧市街のKoblakiqに話して完了 | - | @ムバルポロス旧市街 H-11 | T npc.11.Koblakiq

@ quest.misc.062 https://wiki.ffo.jp/html/15807.html
Q Confessions of a Bellmaker | 鐘楼の名残 | no | T obj.30.Stone_Monument = obj:Stone Monument@リヴェーヌ岩塊群サイトA01 C-7
RW item:ミンストレルダガー
LK quest:プロマシアミッション「誓いの雄叫び」まで進めている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Confessions_of_a_Bellmaker;Fame=Other、FLevel は空、Repeatable=No。Stone Monument (C-7)、Reinberta は商業区 (I-8) の彫金ギルド（FFXIclopedia も I-8。用語辞典は H-8）、Mevreauche は北サンドリア (E-6)、Arcane Phantasm
g01 examine - | リヴェーヌ岩塊群サイトA01(C-7)のStone Monumentを調べて受ける | 行くたびに巨大な鱗が2枚いる（2往復で4枚）。まわりのクラスターに見つからないように。 | @リヴェーヌ岩塊群サイトA01 C-7 | T obj.30.Stone_Monument
g02 talk - | バストゥーク商業区(I-8)の彫金ギルドのReinbertaに話してイベント | - | @バストゥーク商業区 I-8 | T npc.235.Reinberta = npc:Reinberta@バストゥーク商業区 I-8
g03 talk - | 北サンドリア(E-6)の鍛冶ギルドのMevreaucheに話してイベント | - | @北サンドリア E-6 | T npc.231.Mevreauche = npc:Mevreauche@北サンドリア E-6
g04 examine - | サイトA01のStone Monumentを調べてイベント | - | @リヴェーヌ岩塊群サイトA01 C-7 | T obj.30.Stone_Monument
g05 fight - | もう一度調べ、出てきたフォモル族NM「Arcane Phantasm」を倒す | 詩人のNM。 | @リヴェーヌ岩塊群サイトA01 C-7 | T mob.30.Arcane_Phantasm = mob:Arcane Phantasm@リヴェーヌ岩塊群サイトA01 C-7
g06 examine - | もう一度Stone Monumentを調べてイベントを見て完了 | - | @リヴェーヌ岩塊群サイトA01 C-7 | T obj.30.Stone_Monument
