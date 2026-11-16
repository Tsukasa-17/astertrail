@ mission.assault.001 https://wiki.ffo.jp/html/4871.html
Q Leujaoam Cleansing | ルジャワン掃討作戦 | yes | T npc.アトルガン白門.Yahsra = npc:Yahsra@アトルガン白門 L-9 L-10
MN - 1
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が二等傭兵以上
LK condition:募集要員はレベル50・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3000（ルジャワン霊窟）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Leujaoam_Cleansing;PSC（二等傭兵）、30分、Lv.50。Leujaoam Worm 15体をすべて倒す。Assault のページ：ルジャワン霊窟の作戦は白門の Yahsra、認識票は Rytaal（公務代理店）、隊長腕章は監視哨の Imperial Guard に皇国軍戦績50（FFXIclopedia：Yahsra L-9/10。F/G-8 から始まり、全部倒すと I-8 に Rune of Release と Ancient Lockbox）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。公務代理店の入口は(K-9)。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal = npc:Rytaal@アトルガン白門 K-10
g02 talk - | 公務代理店(L-9 L-10)のYahsraに話して「ルジャワン掃討作戦」を選び、だいじなもの「アサルト参加証・ルジャワン霊窟」をもらう | 皇国軍認識票はなくなる。傭兵階級より下の作戦も選べる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Yahsra | K 皇国軍認識票
g03 go - | カダーバの浮沼(K-9)のアズーフ島監視哨へ行く | アサルト参加証があれば、一度行ったことのある監視哨へは六門院から無料で飛べる。参加証を持っていると監視哨の門から外には出られない。 | @カダーバの浮沼 K-9
g04 talk - | 突入のリーダーになる人は、アズーフ島監視哨のNareemaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 K-9 | T npc.79.Nareema = npc:Nareema@カダーバの浮沼
g05 examine - | リーダーがアズーフ島監視哨のRunic Sealを調べて、ルジャワン霊窟に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。フェイスは呼べない。 | @カダーバの浮沼 K-9 | T obj.79.Runic_Seal = obj:Runic Seal@カダーバの浮沼 | K アサルト参加証・ルジャワン霊窟
g06 defeat - | ルジャワン霊窟のLeujaoam Wormを15体すべて倒す | スタートは(G-8)（F-8との境目と書く資料もある）。北の通路のあと、落とし穴で最初の広場に戻って南へ。輪の通路は一方通行なので反時計回り。リンクしやすくガ系を使うのでサイレスが効く。 | @ルジャワン霊窟
g07 examine - | （してもしなくてもよい）ルジャワン霊窟(I-8)のAncient Lockboxを開ける | 全部倒すとRune of Releaseの近くに出る。 | @ルジャワン霊窟 I-8
g08 examine - | ルジャワン霊窟(I-8)のRune of Releaseを調べて外に出ると完了 | 時間内に調べないと失敗になる。1人が調べれば全員出られる。作戦戦績はルジャワン霊窟の分にたまる。帰ったら公務代理店で報告して参加証を返しておく。 | @ルジャワン霊窟 I-8 | T obj.69.Rune_of_Release_I-8 = obj:Rune of Release@ルジャワン霊窟 I-8

@ mission.assault.002 https://wiki.ffo.jp/html/8041.html
Q Imperial Agent Rescue | 皇国エージェント救出作戦 | yes | T npc.アトルガン白門.Isdebaaq = npc:Isdebaaq@アトルガン白門 L-9 L-10
MN - 2
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が二等傭兵以上
LK condition:募集要員はレベル60・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,300（マムージャ兵訓練所）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Imperial_Agent_Rescue;PSC、30分、Lv.60。3つの門のどれかの奥の Pot Hatch に Brujeel。Mamool Ja Warder の Axe Throw・Staff Toss 1回か Firespit 4回で門が壊れる。忍者の Mamool Ja は武器を投げない。ペットがいると門が壊れないことがある。助けると J-8 の行き止まりの部屋に Rune of Release。Assault のページ：マムージャ兵訓練所の作戦は Isdebaaq（FFXIclopedia：Isdebaaq L-9/10。G-7 から入り、J-8 の池の部屋に Rune of Release と Ancient Lockbox）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のIsdebaaqに話して「皇国エージェント救出作戦」を選び、だいじなもの「アサルト参加証・マムージャ兵訓練所」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Isdebaaq | K 皇国軍認識票
g03 go - | バフラウ段丘(H-11)のマムージャ監視哨へ行く | 六門院から飛べる。歩くときはマムークを通って、バフラウ段丘の小さい地図に出てから左の壁ぞいに南へ。 | @バフラウ段丘 H-11
g04 talk - | 突入のリーダーになる人は、マムージャ監視哨のDaswillに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @バフラウ段丘 H-11 | T npc.52.Daswill = npc:Daswill@バフラウ段丘
g05 examine - | リーダーがマムージャ監視哨のRunic Sealを調べて、マムージャ兵訓練所に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @バフラウ段丘 H-11 | T obj.52.Runic_Seal = obj:Runic Seal@バフラウ段丘 | K アサルト参加証・マムージャ兵訓練所
g06 go - | マムージャ兵訓練所の東側の、門でふさがれた3つの小部屋（北のまん中・南東・南西）のどれかの前へ行く | スタートは(G-7)。どの部屋にいるかは毎回ちがう。 | @マムージャ兵訓練所
g07 defeat - | Mamool Ja Warderを門の前に連れてきて戦い、アックススロー・ステーヴトス・ファイアースピットを門に当てさせてDilapidated Gateを壊す | 武器投げなら1回、ファイアースピットなら4回ほどで壊れる。忍者のマムージャは武器を投げない。武器を壊してしまうと投げなくなる。ペットは出さないほうがよい。 | @マムージャ兵訓練所
g08 examine - | 門の奥のPot Hatchを調べる | 空っぽのときは、ほかの門で同じことをする。 | @マムージャ兵訓練所 | T obj.66.Pot_Hatch = obj:Pot Hatch@マムージャ兵訓練所
g09 talk - | 出てきたBrujeelに話して助ける | 助けるとデジョンで帰っていく。 | @マムージャ兵訓練所 | T npc.66.Brujeel = npc:Brujeel@マムージャ兵訓練所
g10 examine - | （してもしなくてもよい）マムージャ兵訓練所(J-8)のAncient Lockboxを開ける | 行き止まりの池の部屋に出る。 | @マムージャ兵訓練所 J-8
g11 examine - | マムージャ兵訓練所(J-8)のRune of Releaseを調べて外に出ると完了 | 時間内に調べないと失敗になる。1人が調べれば全員出られる。帰ったら公務代理店で報告して参加証を返しておく。 | @マムージャ兵訓練所 J-8 | T obj.66.Rune_of_Release_J-8 = obj:Rune of Release@マムージャ兵訓練所 J-8

@ mission.assault.003 https://wiki.ffo.jp/html/5565.html
Q Excavation Duty | 土竜作戦 | yes | T npc.アトルガン白門.Famad = npc:Famad@アトルガン白門 L-9 L-10
MN - 3
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が二等傭兵以上
LK condition:募集要員はレベル50・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,300（レベロス風穴）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Excavation_Duty;PSC、30分、Lv.50。Brittle Rock 5つを壊す。岩は動かず攻撃しない。継続ダメージがよく効く。Qiqirn が落とす Qiqirn Mine を、岩と戦っている状態で使うと1回で壊れる。Volcanic Bomb は見て絡むのでインビジでかわせる。最後の岩を壊すと F-10 の行き止まりの部屋に Rune of Release。Assault のページ：レベロス風穴の作戦は Famad（FFXIclopedia：Famad L-9/10。G-11 から始まる。岩は G-10、北の G-6、H-8、I-7 に2つ。Rune of Release は F-10）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のFamadに話して「土竜作戦」を選び、だいじなもの「アサルト参加証・レベロス風穴」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Famad | K 皇国軍認識票
g03 go - | ゼオルム火山(K-6)のハルブーン監視哨へ行く | 六門院から飛べる。歩くときは、ハルブーンに入ってエスケプするとゼオルム火山(L-7)に出るので、(L-6)から西の通路を進む。 | @ゼオルム火山 K-6
g04 talk - | 突入のリーダーになる人は、ハルブーン監視哨のWaudeenに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @ゼオルム火山 K-6 | T npc.61.Waudeen = npc:Waudeen@ゼオルム火山
g05 examine - | リーダーがハルブーン監視哨のRunic Sealを調べて、レベロス風穴に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @ゼオルム火山 K-6 | T obj.61.Runic_Seal = obj:Runic Seal@ゼオルム火山 | K アサルト参加証・レベロス風穴
g06 defeat - | レベロス風穴のBrittle Rockを5つすべて壊す | スタートは(G-11)。道をふさぐ1つ目のあと、北のはずれに1つ、東に3つ（G-10・G-6・H-8・I-7に2つと書く資料もある）。岩は攻撃してこないが、ダメージがとても通りにくい。バイオや精霊の弱体など継続ダメージがよく効き、毒は効かない。キキルンが落とすキキルンマインを、岩と戦っている状態で使うと1回で壊れる。 | @レベロス風穴 | T mob.63.Brittle_Rock = mob:Brittle Rock@レベロス風穴
g07 examine - | （してもしなくてもよい）レベロス風穴(F-10)のAncient Lockboxを開ける | スタートの近くの行き止まりの部屋。 | @レベロス風穴 F-10
g08 examine - | レベロス風穴(F-10)のRune of Releaseを調べて外に出ると完了 | いちばん遠い岩からは数分かかるので、最後の岩のあいだに1人先に向かうとよい。帰ったら公務代理店で報告して参加証を返しておく。 | @レベロス風穴 F-10 | T obj.63.Rune_of_Release_F-10 = obj:Rune of Release@レベロス風穴 F-10

@ mission.assault.004 https://wiki.ffo.jp/html/8043.html
Q Seagull Grounded | 海猫護送作戦 | yes | T npc.アトルガン白門.Lageegee = npc:Lageegee@アトルガン白門 L-9 L-10
MN - 4
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が二等傭兵以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,300（ペリキア）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Seagull_Grounded;PSC、30分、Lv.70。捕虜の Excaliace を F-12 の Rune of Release の場所まで護送する。後ろに少し離れてつくと動き、近すぎると止まり、だれも近くにいないと逃げて失敗。敵を見ると逃げる。部屋 A・B・C のどれかに寄り、カニがいれば先に倒す。H-8 の分かれ道で D か E へ。G-10 と最後の部屋に Debaucher。Lageegee は L-9（FFXIclopedia：Lageegee L-10。H-6 の丸い部屋から始まる。いちばん南の部屋 F-11 の北西のすみに着くと勝ち、Rune of Release と Ancient Lockbox が出る）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のLageegeeに話して「海猫護送作戦」を選び、だいじなもの「アサルト参加証・ペリキア」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Lageegee | K 皇国軍認識票
g03 go - | カダーバの浮沼(I-9)のドゥブッカ島監視哨へ行く | 六門院から飛べる。歩くときは、カダーバの浮沼(E-11)のNasheefaにアトルガン白銀貨を渡してアルザダール海底遺跡群を通り、ドゥブッカ島側に出て右の壁ぞいに進む。 | @カダーバの浮沼 I-9 #2
g04 talk - | 突入のリーダーになる人は、ドゥブッカ島監視哨のNahshibに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 I-9 #2 | T npc.79.Nahshib = npc:Nahshib@カダーバの浮沼
g05 examine - | リーダーがドゥブッカ島監視哨のRunic Sealを調べて、ペリキアに突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 I-9 #2 | T obj.79.Runic_Seal | K アサルト参加証・ペリキア
g06 go - | ペリキア(H-6)の丸い部屋のExcaliaceに近づいて、護送を始める | 近づくと自分で歩き出す。話しかけなくてよい。 | @ペリキア H-6 | T npc.56.Excaliace = npc:Excaliace@ペリキア H-6
g07 defeat - | Excaliaceの先回りをして、行く先のArrapago Crab・Periqia Pugil・Debaucherを倒す | Excaliaceは敵を見ると逃げる。前に出て視界に入ると止まり、後ろに少し離れると歩き出す。離れすぎると逃げて失敗。(H-7)からの左右の小部屋はどちらか片方にカニがいる。(H-8)の分かれ道の先にはプギル。(G-10)と最後の部屋のDebaucherは、脇へ引っぱればExcaliaceに見せずにすむ。 | @ペリキア
g08 go - | Excaliaceを、いちばん南の部屋(F-11)の北西のすみまで連れて行く | F-12と書く資料もある。 | @ペリキア F-11
g09 examine - | （してもしなくてもよい）ペリキア(F-11)のAncient Lockboxを開ける | Excaliaceのそばに出る。 | @ペリキア F-11
g10 examine - | ペリキア(F-11)のRune of Releaseを調べて外に出ると完了 | F-12と書く資料もある。帰ったら公務代理店で報告して参加証を返しておく。 | @ペリキア F-11 | T obj.56.Rune_of_Release_F-11 = obj:Rune of Release@ペリキア F-11

@ mission.assault.005 https://wiki.ffo.jp/html/6640.html
Q Golden Salvage | 黄金の遺産収集作戦 | yes | T npc.アトルガン白門.Bhoy_Yhupplo = npc:Bhoy Yhupplo@アトルガン白門 L-9 L-10
MN - 5
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が二等傭兵以上
LK condition:募集要員はレベル60・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,300（イルルシ環礁）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Golden_Salvage;PSC、30分、Lv.60。12個の箱のうち1つに船首像、残り11個は Cursed Chest（ミミック）。正しい箱を見つけるとスタートに Rune of Release。Bhoy Yhupplo は L-9（FFXIclopedia：Bhoy Yhupplo L-9/10。H-8 から始まり、船首像を見つけると H-7 の十字路の Rune of Release へ。4つの船の箱はいつも出る）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のBhoy Yhupploに話して「黄金の遺産収集作戦」を選び、だいじなもの「アサルト参加証・イルルシ環礁」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Bhoy_Yhupplo | K 皇国軍認識票
g03 go - | アラパゴ暗礁域(G-5)のイルルシ環礁監視哨へ行く | 六門院から飛べる。歩くととても遠く、監視哨の前にインプが多い。 | @アラパゴ暗礁域 G-5
g04 talk - | 突入のリーダーになる人は、イルルシ環礁監視哨のMeyaadaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @アラパゴ暗礁域 G-5 | T npc.54.Meyaada = npc:Meyaada@アラパゴ暗礁域
g05 examine - | リーダーがイルルシ環礁監視哨のRunic Sealを調べて、イルルシ環礁に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @アラパゴ暗礁域 G-5 | T obj.54.Runic_Seal = obj:Runic Seal@アラパゴ暗礁域 | K アサルト参加証・イルルシ環礁
g06 examine - | イルルシ環礁の12個の箱を調べて、黄金の船首像の一部が入った箱を見つける | スタートは(H-8)。11個はミミックで、近づくと襲ってくる。4つの船の箱はいつも出る。プギルはインビジを見破る。ミミックのデストラップの毒に気をつける。 | @イルルシ環礁
g07 examine - | （してもしなくてもよい）イルルシ環礁(H-7)のAncient Lockboxを開ける | | @イルルシ環礁 H-7
g08 examine - | イルルシ環礁(H-7)の十字路のRune of Releaseを調べて外に出ると完了 | スタートの場所に出ると書く資料もある。帰ったら公務代理店で報告して参加証を返しておく。 | @イルルシ環礁 H-7 | T obj.55.Rune_of_Release_H-7 = obj:Rune of Release@イルルシ環礁 H-7

@ mission.assault.006 https://wiki.ffo.jp/html/11114.html
Q Nyzul Isle Investigation | ナイズル島踏査指令 | yes | T npc.アトルガン白門.Sorrowful_Sage = npc:Sorrowful Sage@アトルガン白門 L-9 L-10
MN - 6
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:募集要員はレベル75・1〜6人（レベル制限はかからない。傭兵階級の制限はない）
RW other:トークン（作戦戦績はない。帰還したときに、進んだブロックに応じてもらえる）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Nyzul_Isle_Investigation;PSC、30分、Lv.75。作戦戦績のかわりにトークン。最初の部屋の Rune of Transfer で始めるブロックを選ぶ（1 からはただ、6 以上はトークン）。Vendor Box でトークンを使ってテンポラリアイテム。各ブロックの Rune of Transfer で目標を見て、達成すると点灯し、次へ進むか帰還を選ぶ。Assault のページ：ナイズル島の作戦は公務代理店の Sorrowful Sage。Sorrowful Sage は L-9。Runic Portal のページ：ナイズル島監視哨はアルザダール海底遺跡群 J-8（Nyzul Isle Staging Point のページは J-8 か J-9。Nyzul Isle のページは I-8/9）（FFXIclopedia：Sorrowful Sage L-10。ナイズル島監視哨は J-9/J-8。最初の部屋で Rune of Transfer を調べると Runic Disc がもらえる。時間切れは失敗）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のSorrowful Sageに話して「ナイズル島踏査指令」を選び、だいじなもの「アサルト参加証・ナイズル島」をもらう | 皇国軍認識票はなくなる。いまのトークンの数と、記録したブロックもここで聞ける。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Sorrowful_Sage | K 皇国軍認識票
g03 go - | アルザダール海底遺跡群(J-8 J-9)のナイズル島監視哨へ行く | 六門院から飛べる。歩くときは、バフラウ段丘(F-6)の不滅隊員にアトルガン白銀貨を渡して入り、白いワープを2回使うとこの地図に出る。I-8 I-9と書く資料もある。 | @アルザダール海底遺跡群 J-8 J-9 #5
g04 talk - | 突入のリーダーになる人は、ナイズル島監視哨の不滅隊員に皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 腕章を持っているリーダーは、もらえるトークンが1割ふえる。 | @アルザダール海底遺跡群 J-8 J-9 #5
g05 examine - | リーダーがナイズル島監視哨のRunic Sealを調べて、ナイズル島に突入する | 全員が同じアサルト参加証を持って近くにいること。30分で、のばせない。 | @アルザダール海底遺跡群 J-8 J-9 #5 | T obj.72.Runic_Seal = obj:Runic Seal@アルザダール海底遺跡群 | K アサルト参加証・ナイズル島
g06 examine - | 最初の部屋のRune of Transferを調べて、始めるブロックを選ぶ | 1・6・11…96と5ブロックごとに選べる。6より上は、選んだ人のトークンが減る。はじめてのときは、ここでだいじなもの「幻灯の円盤」をもらう（進んだブロックが記録される）。横のVending Boxで、トークンを使ってテンポラリアイテムがもらえる。ナイズル島では地図が出ない。 | @ナイズル島 | T obj.77.Rune_of_Transfer = obj:Rune of Transfer@ナイズル島
g07 examine - | ブロックのスタートのRune of Transferを調べて戦術目標を見て、それを達成する | 目標は、敵の殲滅（Archaic Gearは数えない）・特定モンスターの駆逐（強さが「計り知れない」普通の敵1体）・特定モンスターの殲滅（計り知れないHeraldic Imp・Psycheflayer・Ebony Pudding・Poroggo Gent・Racing Chariot・キキルン2種のどれか）・敵のヘッドの駆逐（ナイズル島だけのNM）・ランプの点灯（Runic Lampを調べると、全員が調べる／全部同時に点ける／正しい順に押す のどれかがわかる）・戦術目標なし（はじめから点灯）のどれか。「Archaic Gearに注意せよ」「壊すな」と出たときは、ギアに絡まれたり倒したりすると、パトス・残り時間1分減・トークン1割減のどれかになる。20の倍数のブロックは、HNMと門だけ。 | @ナイズル島 | T obj.77.Rune_of_Transfer
g08 examine - | 点灯したRune of Transferを調べて「次のブロックへ移動する」を選び、つぎのブロックでまた目標を達成する | 「右・左」の選択が出ることもある。5ブロック進むのがふつうの目安。 | @ナイズル島 | T obj.77.Rune_of_Transfer
g09 examine - | 切りのよいところで、点灯したRune of Transferを調べて「作戦を中断し、帰還する」を選ぶと完了 | 時間切れや帰巣蛍で出ると失敗になり、トークンも記録ももらえない。記録は前の記録からつながったブロックだけのびる。100ブロックまで記録すると、だいじなもの「幻灯のカギ」をもらう。 | @ナイズル島 | T obj.77.Rune_of_Transfer

@ mission.assault.007 https://wiki.ffo.jp/html/26165.html
Q Nyzul Isle Uncharted Area Survey | ナイズル島未開領域踏査指令 | yes | T npc.アトルガン白門.Sorrowful_Sage
MN - 7
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:募集要員はレベル99・1〜6人（レベル制限はかからない。傭兵階級の制限はない）
RW other:トークン（作戦戦績はない。帰還したときに、進んだブロックに応じてもらえる）
RW title:未踏領域を踏破せし者（100ブロックのボスを倒したとき）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Nyzul_Isle_Uncharted_Area_Survey;PSC、30分、Lv.99。受付は Sorrowful Sage（Sorrowful Sage でテンポラリアイテムのリストを作っておける）。いつもブロック1から始まり、突入したときに目標のブロック（20・40・60・80・100）を選ぶ。その先には進まない。目標はブロックに着くと知らされる。20・40・60 は Stealthlord Haraal Ja・Dabargar the Stoic・Stheno のどれか、80 は Lord Vryko、100 は Dvali Jonah。ボスを決まった回数倒すと天文盤をもらい、白門 L-9 の Berangere で装備と交換（FFXIclopedia：Berangere は天文盤を装備と交換する）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のSorrowful Sageに話して「ナイズル島未開領域踏査指令」を選び、だいじなもの「アサルト参加証・ナイズル島」をもらう | 皇国軍認識票はなくなる。中で取り出すテンポラリアイテムのリストも、ここで作っておける。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Sorrowful_Sage | K 皇国軍認識票
g03 go - | アルザダール海底遺跡群(J-8 J-9)のナイズル島監視哨へ行く | 六門院から飛べる。歩くときは、バフラウ段丘(F-6)の不滅隊員にアトルガン白銀貨を渡して入り、白いワープを2回使うとこの地図に出る。I-8 I-9と書く資料もある。 | @アルザダール海底遺跡群 J-8 J-9 #5
g04 talk - | 突入のリーダーになる人は、ナイズル島監視哨の不滅隊員に皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 腕章を持っているリーダーは、もらえるトークンが1割ふえる。 | @アルザダール海底遺跡群 J-8 J-9 #5
g05 examine - | リーダーがナイズル島監視哨のRunic Sealを調べて、ナイズル島に突入し、目標のブロック（20・40・60・80・100のどれか）を決める | 全員が同じアサルト参加証を持って近くにいること。30分。いつもブロック1から始まる。目標のブロックより先には進まない。 | @アルザダール海底遺跡群 J-8 J-9 #5 | T obj.72.Runic_Seal | K アサルト参加証・ナイズル島
g06 examine - | （してもしなくてもよい）最初の部屋のVending Boxで、トークンを使ってテンポラリアイテムを取り出す | Sorrowful Sageで作ったリストのものを、まとめて取り出せる。ナイズル島では地図が出ない。 | @ナイズル島
g07 examine - | ブロックに着くと知らされる戦術目標を達成する | 目標の種類は踏査指令と同じ（敵の殲滅・特定モンスターの駆逐・特定モンスターの殲滅・敵のヘッドの駆逐・ランプの点灯・戦術目標なし）。スタートのRune of Transferを調べても目標が見られる。「Archaic Gearに注意せよ」のときは、遠くから先に釣るとペナルティにならない。 | @ナイズル島 | T obj.77.Rune_of_Transfer = obj:Rune of Transfer@ナイズル島
g08 examine - | 点灯したRune of Transferを調べて先へ進み、目標のブロックまでくり返す | 1回で2〜11ブロックのどれかだけ進む。 | @ナイズル島 | T obj.77.Rune_of_Transfer
g09 defeat - | 目標が20・40・60ブロックで、Stealthlord Haraal Jaが出たときは、それを倒す | 20・40・60のボスは、Stealthlord Haraal Ja・Stheno・Dabargar the Stoicのどれか。ボスのブロックは広い部屋に、ボスとArchaic Rampartだけがいる（門は倒さなくてよい）。 | @ナイズル島 | T mob.77.Stealthlord_Haraal_Ja = mob:Stealthlord Haraal Ja@ナイズル島
g10 defeat - | 目標が20・40・60ブロックで、Sthenoが出たときは、それを倒す | | @ナイズル島 | T mob.77.Stheno = mob:Stheno@ナイズル島
g11 defeat - | 目標が20・40・60ブロックで、Dabargar the Stoicが出たときは、それを倒す | | @ナイズル島 | T mob.77.Dabargar_the_Stoic = mob:Dabargar the Stoic@ナイズル島
g12 defeat - | 目標が80ブロックのときは、Lord Vrykoを倒す | | @ナイズル島 | T mob.77.Lord_Vryko = mob:Lord Vryko@ナイズル島
g13 defeat - | 目標が100ブロックのときは、Dvali Jonahを倒す | 倒すと称号「未踏領域を踏破せし者」。 | @ナイズル島 | T mob.77.Dvali_Jonah = mob:Dvali Jonah@ナイズル島
g14 examine - | 点灯したRune of Transferを調べて「作戦を中断し、帰還する」を選ぶと完了 | 目標のブロックに着けなくても、目標を達成して帰還すれば成功になる。時間切れや帰巣蛍で出ると失敗。 | @ナイズル島 | T obj.77.Rune_of_Transfer
g15 talk - | （してもしなくてもよい）ボスを決まった回数倒してもらった天文盤を、公務代理店(L-9)のBerangereに渡して装備と交換する | 20は青銅の天文盤（5回）、40は白銀の天文盤（5回）、60は霊銀の天文盤（5回）、80は黄金の天文盤（5回）、100は白金の天文盤（1回）。交換すると天文盤はなくなり、同じものは2つ持てない。 | @アトルガン白門 L-9 | T npc.アトルガン白門.Berangere = npc:Berangere@アトルガン白門 L-9

@ mission.assault.008 https://wiki.ffo.jp/html/7628.html
Q Orichalcum Survey | オリハルコン鉱脈調査 | yes | T npc.アトルガン白門.Yahsra
MN - 8
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が一等傭兵以上
LK condition:募集要員はレベル50・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,600（ルジャワン霊窟）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Orichalcum_Survey;PFC、30分、Lv.50。Mulwahah（H-8）からテンポラリアイテムのつるはしをもらい、Mining Point を調べて掘る。オリハルコン鉱・小石か亜鉛鉱・何も出ない・つるはしが壊れる・Mineral Worm が出る のどれか。鉱石が出ると Qiqirn Miner が襲ってくるようになるので、インビジで Mulwahah に戻り、掘った人が話すと完了（FFXIclopedia：Yahsra L-9/10。Rune of Release と Ancient Lockbox は H-8。ワームは1300〜1500HPでスニークを見破る。Qiqirn Miner は Lv76〜82）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のYahsraに話して「オリハルコン鉱脈調査」を選び、だいじなもの「アサルト参加証・ルジャワン霊窟」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Yahsra | K 皇国軍認識票
g03 go - | カダーバの浮沼(K-9)のアズーフ島監視哨へ行く | 六門院から飛べる。 | @カダーバの浮沼 K-9
g04 talk - | 突入のリーダーになる人は、アズーフ島監視哨のNareemaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 K-9 | T npc.79.Nareema
g05 examine - | リーダーがアズーフ島監視哨のRunic Sealを調べて、ルジャワン霊窟に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 K-9 | T obj.79.Runic_Seal | K アサルト参加証・ルジャワン霊窟
g06 talk - | ルジャワン霊窟(H-8)のスタートにいるMulwahahに話して、テンポラリアイテムのつるはしをもらう | ふつうのつるはしは使えない。 | @ルジャワン霊窟 H-8 | T npc.69.Mulwahah = npc:Mulwahah@ルジャワン霊窟 H-8
g07 examine - | 北・東・南の道にあるMining Pointを調べて、オリハルコン鉱が出るまで掘る | つるはしはトレードしなくてよい。小石や亜鉛鉱はトレジャーに入る。つるはしが壊れたらMulwahahでもう一度もらう。Mineral Wormが出たら、その死骸が消えるまでそこは掘れない。オリハルコン鉱は掘った人のかばんに入る。 | @ルジャワン霊窟 | T obj.69.Mining_Point = obj:Mining Point!@ルジャワン霊窟
g08 talk - | オリハルコン鉱を掘った人が、スタート(H-8)のMulwahahに話す | 鉱石が出るとQiqirn Minerが黄色の名前になって、見て襲ってくるので、インビジでかわして戻る。掘った人が倒れて起き上がれないと失敗になるので、リレイズがあるとよい。 | @ルジャワン霊窟 H-8 | T npc.69.Mulwahah
g09 examine - | （してもしなくてもよい）ルジャワン霊窟(H-8)のAncient Lockboxを開ける | | @ルジャワン霊窟 H-8
g10 examine - | ルジャワン霊窟(H-8)のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ルジャワン霊窟 H-8 | T obj.69.Rune_of_Release_H-8 = obj:Rune of Release@ルジャワン霊窟 H-8

@ mission.assault.009 https://wiki.ffo.jp/html/6099.html
Q Preemptive Strike | 秘密訓練所急襲作戦 | yes | T npc.アトルガン白門.Isdebaaq
MN - 9
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が一等傭兵以上
LK condition:募集要員はレベル60・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,000（マムージャ兵訓練所）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Preemptive_Strike;PFC、30分、Lv.60。Mamool Ja Executioner 13体（青・白・忍）を倒す。Puk Executioner は倒さなくてよい。全部倒すと I-7 の南東のすみの行き止まりに Rune of Release。遠隔や魔法がない人は、I-8 と G-8 のマムージャを倒すまでスタートの高台から降りない（戻る坂がない）（FFXIclopedia：Isdebaaq L-9/10。I-6 から入る。北の G-7 の高台だけ坂がある。Rune of Release は I-7 の下）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のIsdebaaqに話して「秘密訓練所急襲作戦」を選び、だいじなもの「アサルト参加証・マムージャ兵訓練所」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Isdebaaq | K 皇国軍認識票
g03 go - | バフラウ段丘(H-11)のマムージャ監視哨へ行く | 六門院から飛べる。歩くときはマムークを通って、バフラウ段丘の小さい地図に出てから左の壁ぞいに南へ。 | @バフラウ段丘 H-11
g04 talk - | 突入のリーダーになる人は、マムージャ監視哨のDaswillに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @バフラウ段丘 H-11 | T npc.52.Daswill
g05 examine - | リーダーがマムージャ監視哨のRunic Sealを調べて、マムージャ兵訓練所に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @バフラウ段丘 H-11 | T obj.52.Runic_Seal | K アサルト参加証・マムージャ兵訓練所
g06 defeat - | マムージャ兵訓練所のMamool Ja Executionerを13体すべて倒す | スタートは(I-6)の高台。高台は一度降りると戻れないので、(I-8)と(G-8)のマムージャは先に倒すか、下から釣れるようにしておく。(I-6)から(G-7)への橋を渡って下へ降り、残りを倒す。まざっているPuk Executioner 7体は倒さなくてよいが絡んでくる。名前は同じで、忍者3・白魔道士4・青魔道士6。範囲魔法にはサイレス。 | @マムージャ兵訓練所 | T mob.66.Mamool_Ja_Executioner = mob:Mamool Ja Executioner@マムージャ兵訓練所
g07 examine - | （してもしなくてもよい）マムージャ兵訓練所のAncient Lockboxを開ける | | @マムージャ兵訓練所
g08 examine - | マムージャ兵訓練所(I-7)のRune of Releaseを調べて外に出ると完了 | 下の段の南東のすみの行き止まり。帰ったら公務代理店で報告して参加証を返しておく。 | @マムージャ兵訓練所 I-7 | T obj.66.Rune_of_Release_I-7 = obj:Rune of Release@マムージャ兵訓練所 I-7

@ mission.assault.010 https://wiki.ffo.jp/html/4909.html
Q Lebros Supplies | レベロス補給作戦 | yes | T npc.アトルガン白門.Famad
MN - 10
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が一等傭兵以上
LK condition:募集要員はレベル60・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,000（レベロス風穴）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Lebros_Supplies;PFC、30分、Lv.60。Imperial Stormer 12人全員に食べ物を渡して満腹にする。Yazuhma（H-8）がテンポラリアイテムの食べ物をくれる（寄せ鍋7＋同じ組の全員・バイソンステーキ5・クァールサンド4・バイソンジャーキー3・豆のスープ2・白パン1。7で満腹）。食べ物を持たずに話すと満腹かどうかわかる。同じ場所の兵は盾で見分ける。西南西2・南南西2・南東3・北西3・北2。Rune of Release は Yazuhma のところに出る。Crimson Eruca はスニークを見破る（FFXIclopedia：Famad L-9/10。Yazuhma は入口。6か7で満腹。話すと勝手に渡る）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のFamadに話して「レベロス補給作戦」を選び、だいじなもの「アサルト参加証・レベロス風穴」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Famad | K 皇国軍認識票
g03 go - | ゼオルム火山(K-6)のハルブーン監視哨へ行く | 六門院から飛べる。歩くときは、ハルブーンに入ってエスケプするとゼオルム火山(L-7)に出るので、(L-6)から西の通路を進む。 | @ゼオルム火山 K-6
g04 talk - | 突入のリーダーになる人は、ハルブーン監視哨のWaudeenに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @ゼオルム火山 K-6 | T npc.61.Waudeen
g05 examine - | リーダーがハルブーン監視哨のRunic Sealを調べて、レベロス風穴に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @ゼオルム火山 K-6 | T obj.61.Runic_Seal | K アサルト参加証・レベロス風穴
g06 talk - | レベロス風穴(H-8)のスタートにいるYazuhmaに話して、テンポラリアイテムの食べ物をもらう | 白パン・豆のスープ・バイソンジャーキー・クァールサンド・バイソンステーキ・寄せ鍋のどれかが出る。持ってきたふつうの食べ物は使えない。捨てても食べても同じものをまたくれる。 | @レベロス風穴 H-8 | T npc.63.Yazuhma = npc:Yazuhma@レベロス風穴 H-8
g07 talk - | 各所にいるImperial Stormerに話して食べ物を渡し、12人全員を満腹にする | 話すと勝手に渡る。満腹の目安は白パン1・豆のスープ2・バイソンジャーキー3・クァールサンド4・バイソンステーキ5で7くらい。寄せ鍋は1回で満腹になり、同じ組のまわりの兵にも効く。食べ物を持たずに話すと満腹かどうかわかるので、渡したあとはもう一度話して確かめ、足りなければYazuhmaに戻る。同じ場所の兵は盾の形で見分ける。Crimson Erucaはアクティブでスニークを見破る。 | @レベロス風穴 | T npc.63.Imperial_Stormer = npc:Imperial Stormer!@レベロス風穴
g08 examine - | （してもしなくてもよい）レベロス風穴のAncient Lockboxを開ける | | @レベロス風穴
g09 examine - | スタート(H-8)のYazuhmaのところに出るRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @レベロス風穴 H-8 | T obj.63.Rune_of_Release_H-8 = obj:Rune of Release@レベロス風穴 H-8

@ mission.assault.011 https://wiki.ffo.jp/html/4892.html
Q Requiem | レクイエム作戦 | yes | T npc.アトルガン白門.Lageegee
MN - 11
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が一等傭兵以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,000（ペリキア）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Requiem_(Assault);PFC、30分、Lv.70。アンデッドを全部倒す（Batteilant Bhoot 4・Darkling Draugar 暗7・竜5・Putrid Immortal Guard 2）（FFXIclopedia：Lageegee L-10。F-9 から始まり、全部倒すとスタートに Rune of Release。H-8/9 と F/G-8 の門は気にしなくてよい）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のLageegeeに話して「レクイエム作戦」を選び、だいじなもの「アサルト参加証・ペリキア」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Lageegee | K 皇国軍認識票
g03 go - | カダーバの浮沼(I-9)のドゥブッカ島監視哨へ行く | 六門院から飛べる。歩くときは、カダーバの浮沼(E-11)のNasheefaにアトルガン白銀貨を渡してアルザダール海底遺跡群を通り、ドゥブッカ島側に出て右の壁ぞいに進む。 | @カダーバの浮沼 I-9 #2
g04 talk - | 突入のリーダーになる人は、ドゥブッカ島監視哨のNahshibに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 I-9 #2 | T npc.79.Nahshib
g05 examine - | リーダーがドゥブッカ島監視哨のRunic Sealを調べて、ペリキアに突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 I-9 #2 | T obj.79.Runic_Seal | K アサルト参加証・ペリキア
g06 defeat - | ペリキアのアンデッド（ドラウガー12体・ドゥーム2体・ブフート4体）をすべて倒す | スタートは(G-9)（F-9と書く資料もある）。配置はほぼ決まっている。骨は範囲ドレインが強いので1体ずつ早く倒す。竜騎士タイプの子竜はスリプルが効かないので先に倒す。お化けはガ系を使うのでサイレスで釣る。バニシュがよく効く。途中の門は気にしなくてよい。 | @ペリキア
g07 examine - | （してもしなくてもよい）ペリキアのAncient Lockboxを開ける | | @ペリキア
g08 examine - | ペリキア(F-9)のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ペリキア F-9 | T obj.56.Rune_of_Release_F-9 = obj:Rune of Release@ペリキア F-9

@ mission.assault.012 https://wiki.ffo.jp/html/4675.html
Q Lamia No.13 | ラミア13号討伐作戦 | yes | T npc.アトルガン白門.Bhoy_Yhupplo
MN - 12
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が一等傭兵以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,600（イルルシ環礁）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Lamia_No.13;PFC、30分、Lv.70。I-8 から始まり、北にいる狩人の Lamia No. 13 を倒す。魅了された Fallen Volunteer・Fallen Imperial Wizard・Fallen Imperial Trooper がついている。ディスペル・フィナーレなどで魅了をとくと味方になってラミアを攻撃する。ベリーダンス（範囲の魅了）でまた魅了される（FFXIclopedia：Bhoy Yhupplo L-9/10。南東 I-8 の船から始まる。倒すと北東 H-8 に Rune of Release。フォモルにとどめをとられると経験値と戦利品はない）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のBhoy Yhupploに話して「ラミア13号討伐作戦」を選び、だいじなもの「アサルト参加証・イルルシ環礁」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Bhoy_Yhupplo | K 皇国軍認識票
g03 go - | アラパゴ暗礁域(G-5)のイルルシ環礁監視哨へ行く | 六門院から飛べる。歩くととても遠く、監視哨の前にインプが多い。 | @アラパゴ暗礁域 G-5
g04 talk - | 突入のリーダーになる人は、イルルシ環礁監視哨のMeyaadaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @アラパゴ暗礁域 G-5 | T npc.54.Meyaada
g05 examine - | リーダーがイルルシ環礁監視哨のRunic Sealを調べて、イルルシ環礁に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @アラパゴ暗礁域 G-5 | T obj.54.Runic_Seal | K アサルト参加証・イルルシ環礁
g06 defeat - | イルルシ環礁の北にいるLamia No.13を倒す | スタートは(I-8)の船。ついているFallen Volunteer・Fallen Imperial Wizard・Fallen Imperial Trooperは倒さなくてよい（倒してもペナルティはない）。ディスペルやフィナーレで魅了をとくと味方になってラミアを攻撃するので、黒のFallen Imperial Wizardから先にとく。ベリーダンスでまた魅了されたら、とき直す。この作戦のベリーダンスは背を向けても魅了される。フォモルに強化をかけない。ラミアの弓はとても遠くまで届く。 | @イルルシ環礁 | T mob.55.Lamia_No13 = mob:Lamia No.13@イルルシ環礁
g07 examine - | （してもしなくてもよい）イルルシ環礁のAncient Lockboxを開ける | | @イルルシ環礁
g08 examine - | イルルシ環礁(H-8)のRune of Releaseを調べて外に出ると完了 | 北東に出る。帰ったら公務代理店で報告して参加証を返しておく。 | @イルルシ環礁 H-8 | T obj.55.Rune_of_Release_H-8 = obj:Rune of Release@イルルシ環礁 H-8

@ mission.assault.013 https://wiki.ffo.jp/html/8800.html
Q Escort Professor Chanoix | クラボエール男爵警護 | yes | T npc.アトルガン白門.Yahsra
MN - 13
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が上等傭兵以上
LK condition:募集要員はレベル60・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,300（ルジャワン霊窟）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Escort_Professor_Chanoix;SP、30分、Lv.60。Professor Clavauert B Chanoix を J-5 か G-9 の部屋まで守る。だれかが横を通ると歩き出し、止められない。ときどき休む。ケアル・プロテス・シェルはかけられる。敵は Frozen Bones と Gelid Bhoot（アンデッド）で、男爵に近いと絡む。男爵が倒れると失敗（FFXIclopedia：Yahsra L-10。行き先は J-5 か G-9 の部屋。男爵はワイドスキャンに出る。骨9・お化け7）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のYahsraに話して「クラボエール男爵警護」を選び、だいじなもの「アサルト参加証・ルジャワン霊窟」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Yahsra | K 皇国軍認識票
g03 go - | カダーバの浮沼(K-9)のアズーフ島監視哨へ行く | 六門院から飛べる。 | @カダーバの浮沼 K-9
g04 talk - | 突入のリーダーになる人は、アズーフ島監視哨のNareemaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 K-9 | T npc.79.Nareema
g05 examine - | リーダーがアズーフ島監視哨のRunic Sealを調べて、ルジャワン霊窟に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 K-9 | T obj.79.Runic_Seal | K アサルト参加証・ルジャワン霊窟
g06 go - | スタート(F-6)のすぐ先にいるクラボエール男爵（Clavauert B Chanoix）に近づくと、男爵が歩き出す | 話しかけなくてよい。歩き出すと止められず、こちらの言うことは聞かない。スタートの細いところの端を通ると男爵は動かないので、先に敵を倒しておいてから歩かせる手もある。 | @ルジャワン霊窟 F-6 | T npc.69.Clavauert_B_Chanoix = npc:Clavauert B Chanoix!@ルジャワン霊窟
g07 go - | 男爵について行き、男爵に絡みそうなスケルトンとブフートを倒すか寝かせて、発掘現場まで守る | 行き先はJ-5かG-9の部屋。男爵が倒れると失敗。男爵にはケアル・プロテス・シェルがかけられる。敵は光の寝かし・グラビデ・バインドが効き、ブフートはガ系を使う。男爵はときどき休むので、そのあいだに回復する。 | @ルジャワン霊窟 | T npc.69.Clavauert_B_Chanoix
g08 examine - | （してもしなくてもよい）ルジャワン霊窟のAncient Lockboxを開ける | | @ルジャワン霊窟
g09 examine - | 男爵が着くと出るルジャワン霊窟(I-8)のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ルジャワン霊窟 I-8 | T obj.69.Rune_of_Release_I-8

@ mission.assault.014 https://wiki.ffo.jp/html/7630.html
Q Sagelord Elimination | 賢哲王暗殺作戦 | yes | T npc.アトルガン白門.Isdebaaq
MN - 14
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が上等傭兵以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる。レベル60と書く資料もある）
RW other:作戦戦績3,600（マムージャ兵訓練所）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Sagelord_Elimination;SP、30分、Lv.60。Sagelord Molaal Ja を攻撃して、HP15%で逃げると I-7 の南東のすみの行き止まりに Rune of Release。ダメージを受けると逃げ、逃げた先の Mamool Ja Trainee をリンクさせる。HPは回復しない。ペットやワイドスキャンで追う（FFXIclopedia：Isdebaaq L-10。Lv.70。HP10〜20%ごとにウォームアップのあと逃げる。スタンで止まるが、切れるとまた走る。Trainee 15）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のIsdebaaqに話して「賢哲王暗殺作戦」を選び、だいじなもの「アサルト参加証・マムージャ兵訓練所」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Isdebaaq | K 皇国軍認識票
g03 go - | バフラウ段丘(H-11)のマムージャ監視哨へ行く | 六門院から飛べる。歩くときはマムークを通って、バフラウ段丘の小さい地図に出てから左の壁ぞいに南へ。 | @バフラウ段丘 H-11
g04 talk - | 突入のリーダーになる人は、マムージャ監視哨のDaswillに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @バフラウ段丘 H-11 | T npc.52.Daswill
g05 examine - | リーダーがマムージャ監視哨のRunic Sealを調べて、マムージャ兵訓練所に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @バフラウ段丘 H-11 | T obj.52.Runic_Seal | K アサルト参加証・マムージャ兵訓練所
g06 defeat - | （してもしなくてもよい）Sagelord Molaal Jaが逃げる道の、Mamool Ja Traineeを先に倒しておく | スタートは(I-10)。Sagelord Molaal Jaははじめ北の広場(G-7)のあたりにいる。逃げるとまわりのTraineeをリンクさせるので、先に減らしておくと楽。 | @マムージャ兵訓練所
g07 defeat - | Sagelord Molaal Jaを攻撃して、HPを大きく減らすとデジョンで逃げて目標達成 | 倒しきらなくてよい。HPが減るとウォームアップのあと速く走って逃げるので、ワイドスキャンやペットで追ってまた攻撃する。スリプル・グラビデ・バインドは効かない。スタンで止まるが、切れるとまた走る。HPは回復しない。 | @マムージャ兵訓練所 | T mob.66.Sagelord_Molaal_Ja = mob:Sagelord Molaal Ja!@マムージャ兵訓練所
g08 examine - | （してもしなくてもよい）マムージャ兵訓練所のAncient Lockboxを開ける | | @マムージャ兵訓練所
g09 examine - | マムージャ兵訓練所(I-7)のRune of Releaseを調べて外に出ると完了 | 下の段の南東のすみの行き止まり。帰ったら公務代理店で報告して参加証を返しておく。 | @マムージャ兵訓練所 I-7 | T obj.66.Rune_of_Release_I-7

@ mission.assault.015 https://wiki.ffo.jp/html/8473.html
Q Troll Fugitives | 落ち武者追撃戦 | yes | T npc.アトルガン白門.Famad
MN - 15
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が上等傭兵以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,000（レベロス風穴）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Troll_Fugitives;SP、30分、Lv.70。Broken Troll Soldier（モ・ナ・赤・戦）15体を全部倒す。はじめからHPが25〜75%に減っていて、2時間アビを使う。足がおそい。Rune of Release は H-9 の北西、橋の下に出る（FFXIclopedia：Famad L-10。H-7 3・I-8 1・G-8 3・I-9 3・I-7 1・G-10 2・F-10 1・G-9 1 の順に倒すと、Rune of Release は G-9 のトロールのすぐ東）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のFamadに話して「落ち武者追撃戦」を選び、だいじなもの「アサルト参加証・レベロス風穴」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Famad | K 皇国軍認識票
g03 go - | ゼオルム火山(K-6)のハルブーン監視哨へ行く | 六門院から飛べる。歩くときは、ハルブーンに入ってエスケプするとゼオルム火山(L-7)に出るので、(L-6)から西の通路を進む。 | @ゼオルム火山 K-6
g04 talk - | 突入のリーダーになる人は、ハルブーン監視哨のWaudeenに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @ゼオルム火山 K-6 | T npc.61.Waudeen
g05 examine - | リーダーがハルブーン監視哨のRunic Sealを調べて、レベロス風穴に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @ゼオルム火山 K-6 | T obj.61.Runic_Seal | K アサルト参加証・レベロス風穴
g06 defeat - | レベロス風穴のBroken Troll Soldierを15体すべて倒す | スタートは(G-6)。名前は同じで、ナイト・戦士・赤魔道士・モンクがいる。はじめからHPが減っていて、2時間アビ（百烈拳・連続魔など）を使うことがあるので、赤はサイレス、モンクは寝かしやバインド。通路は8の字に回っているので、むだなく回る。配置の目安はH-7に3・I-8に1・G-8に3・I-9に3・I-7に1・G-10に2・F-10に1・G-9に1。 | @レベロス風穴 | T mob.63.Broken_Troll_Soldier = mob:Broken Troll Soldier@レベロス風穴
g07 examine - | （してもしなくてもよい）レベロス風穴のAncient Lockboxを開ける | | @レベロス風穴
g08 examine - | レベロス風穴(H-9)のRune of Releaseを調べて外に出ると完了 | 橋の下の北西。帰ったら公務代理店で報告して参加証を返しておく。 | @レベロス風穴 H-9 | T obj.63.Rune_of_Release_H-9 = obj:Rune of Release@レベロス風穴 H-9

@ mission.assault.016 https://wiki.ffo.jp/html/4615.html
Q Saving Private Ryaaf | ライアーフ捜索作戦 | yes | T npc.アトルガン白門.Lageegee
MN - 16
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が上等傭兵以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,300（ペリキア）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Saving_Private_Ryaaf;SP、30分、Lv.70。I-7 から始まり、Rune of Release もそこに出る。北・東・南・西・中の5部屋のうち3つに捕まった3人（Ryaaf・Balarahb・Rhagmakah）、2つにフォモル。並び方は5通り。フォモルは東を向いている（東の部屋は見分けられない）。部屋ごとに Cursed Chigoe 3（呪いの追加効果）。Experimental Undead は音とアビリティを見破る（FFXIclopedia：Lageegee L-10。並び方は同じ5通り。北と西か、東と中を先に見ると、外れは1つまで）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のLageegeeに話して「ライアーフ捜索作戦」を選び、だいじなもの「アサルト参加証・ペリキア」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Lageegee | K 皇国軍認識票
g03 go - | カダーバの浮沼(I-9)のドゥブッカ島監視哨へ行く | 六門院から飛べる。歩くときは、カダーバの浮沼(E-11)のNasheefaにアトルガン白銀貨を渡してアルザダール海底遺跡群を通り、ドゥブッカ島側に出て右の壁ぞいに進む。 | @カダーバの浮沼 I-9 #2
g04 talk - | 突入のリーダーになる人は、ドゥブッカ島監視哨のNahshibに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 I-9 #2 | T npc.79.Nahshib
g05 examine - | リーダーがドゥブッカ島監視哨のRunic Sealを調べて、ペリキアに突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 I-9 #2 | T obj.79.Runic_Seal | K アサルト参加証・ペリキア
g06 go - | スタート(I-7)から北の部屋へ行き、うずくまっている人に近づいて、捕まった隊員かフォモルかを見る | 部屋は北・東・南・西・中の5つで、3つに隊員、2つにフォモルがいる。近づくと隊員なら話しかけられるようになり、フォモルなら襲ってくる。フォモルは東を向いている（東の部屋だけはこれで見分けられない）。部屋ごとにチゴーが3匹いて、呪いの追加効果がある。通路のフォモルは音・アビリティ・生命を見破るので、よけて通る。 | @ペリキア
g07 talk - | 北の部屋がフォモルだったときは、西の部屋の人も見る。わかった並び方で部屋を回り、Ryaafに話して助ける | 北にBalarahbなら北・東・中、北にRhagmakahなら北・西・中、北にRyaafなら北・南・東。西にBalarahbなら西・南・中、西にRhagmakahなら西・南・東に隊員がいる。どの順で助けてもよい。 | @ペリキア | T npc.56.Ryaaf = npc:Ryaaf@ペリキア
g08 talk - | Balarahbに話して助ける | どの順で助けてもよい。 | @ペリキア | T npc.56.Balarahb = npc:Balarahb@ペリキア
g09 talk - | Rhagmakahに話して助ける | 3人とも助けると目標達成。Ryaafだけ先に助けても終わらない。 | @ペリキア | T npc.56.Rhagmakah = npc:Rhagmakah@ペリキア
g10 examine - | （してもしなくてもよい）ペリキアのAncient Lockboxを開ける | | @ペリキア
g11 examine - | スタート(I-7)に戻り、ペリキアのRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ペリキア I-7 | T obj.56.Rune_of_Release_I-7 = obj:Rune of Release@ペリキア I-7

@ mission.assault.017 https://wiki.ffo.jp/html/5245.html
Q Extermination | 蠱物駆除作戦 | yes | T npc.アトルガン白門.Bhoy_Yhupplo
MN - 17
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が上等傭兵以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,300（イルルシ環礁）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Extermination;SP、30分、Lv.70。敵を全部倒す（Carrion Crab・Carrion Leech・Carrion Slime・Carrion Toad）。倒したあと、ランダムで1体が Undead（Crab・Leech・Slime・Toad のどれか）としてまた出るので、それも倒す（FFXIclopedia：Bhoy Yhupplo L-9/10。Crab 7・Leech 3・Slime 3・Toad 2。Undead は2体出たこともある。打撃はリーチとスライムに効きにくい）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のBhoy Yhupploに話して「蠱物駆除作戦」を選び、だいじなもの「アサルト参加証・イルルシ環礁」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Bhoy_Yhupplo | K 皇国軍認識票
g03 go - | アラパゴ暗礁域(G-5)のイルルシ環礁監視哨へ行く | 六門院から飛べる。歩くととても遠く、監視哨の前にインプが多い。 | @アラパゴ暗礁域 G-5
g04 talk - | 突入のリーダーになる人は、イルルシ環礁監視哨のMeyaadaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @アラパゴ暗礁域 G-5 | T npc.54.Meyaada
g05 examine - | リーダーがイルルシ環礁監視哨のRunic Sealを調べて、イルルシ環礁に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @アラパゴ暗礁域 G-5 | T obj.54.Runic_Seal | K アサルト参加証・イルルシ環礁
g06 defeat - | イルルシ環礁のリーチ・クラブ・スライム・ドゥームをすべて倒す | スタートはマップのまん中(H-8)。スライムは南西、ドゥームは北東にかたまっていて、クラブとリーチはその道のとちゅうにいる。スライムには精霊魔法がよく効き、リーチとスライムには打撃が効きにくい。 | @イルルシ環礁
g07 defeat - | 敵を倒したあとに出る「Undead ～」も倒す | どの敵がもう一度出るかはランダム。ほかの敵の場所に出ることもある。HPは多めだが、ドゥーム以外はドレイン・アスピルも効く。2体出たと書く資料もある。 | @イルルシ環礁
g08 examine - | （してもしなくてもよい）イルルシ環礁のAncient Lockboxを開ける | | @イルルシ環礁
g09 examine - | イルルシ環礁のまん中(H-8)のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @イルルシ環礁 H-8 | T obj.55.Rune_of_Release_H-8

@ mission.assault.018 https://wiki.ffo.jp/html/8801.html
Q Shanarha Grass Conservation | シャナーハ草保護作戦 | yes | T npc.アトルガン白門.Yahsra
MN - 18
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が傭兵長以上
LK condition:募集要員はレベル50・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績（穴ウサギを倒しきったときに残っている薬草の数で変わる）（ルジャワン霊窟）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Shanarha_Grass_Conservation;LC、30分、Lv.50。Coney 20匹を倒す。I-9 からはじまり、Coney も20匹ともそこにいて、少しすると北と南に分かれる。ノンアク・視覚リンク・ワイドスキャンに出ない。戦っていると逃げてタゲが切れ、放っておくとHPが全快する。数分待って散らばってから戦うとよい。薬草を食べすぎられると失敗。残った薬草が多いほど作戦戦績が多い（FFXIclopedia：Yahsra L-10。北と南に9〜11匹ずつ。HP約2200。Rune of Release は I-9）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のYahsraに話して「シャナーハ草保護作戦」を選び、だいじなもの「アサルト参加証・ルジャワン霊窟」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Yahsra | K 皇国軍認識票
g03 go - | カダーバの浮沼(K-9)のアズーフ島監視哨へ行く | 六門院から飛べる。 | @カダーバの浮沼 K-9
g04 talk - | 突入のリーダーになる人は、アズーフ島監視哨のNareemaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 K-9 | T npc.79.Nareema
g05 examine - | リーダーがアズーフ島監視哨のRunic Sealを調べて、ルジャワン霊窟に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 K-9 | T obj.79.Runic_Seal | K アサルト参加証・ルジャワン霊窟
g06 go - | （してもしなくてもよい）スタート(I-9)で少し待ち、穴ウサギが北と南に分かれてから戦う | はじめは20匹ともスタートにいて、見てリンクするので、いっぺんに絡まれやすい。北か南に少し進んで、はしから1匹ずつ釣るとよい。範囲攻撃で一気に倒せるなら、待たずにスタートの広場で倒してもよい。 | @ルジャワン霊窟 I-9
g07 defeat - | ルジャワン霊窟の穴ウサギ（Coney）を20匹すべて倒す | 穴ウサギはこちらから手を出すまで襲ってこず、ワイドスキャンに出ない。戦っているとダメージで逃げ出し、タゲが切れると放っておけばHPが全快するので、グラビデ・バインド・スタンで止める。麻痺の追加効果のある雪煙を使う。穴ウサギが薬草（Vegetation）を食べるので、食べられすぎると失敗。残った薬草が多いほど作戦戦績が多い。 | @ルジャワン霊窟
g08 examine - | （してもしなくてもよい）ルジャワン霊窟のAncient Lockboxを開ける | | @ルジャワン霊窟
g09 examine - | スタート(I-9)のルジャワン霊窟のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ルジャワン霊窟 I-9 | T obj.69.Rune_of_Release_I-9 = obj:Rune of Release@ルジャワン霊窟 I-9

@ mission.assault.019 https://wiki.ffo.jp/html/8431.html
Q Breaking Morale | 慰問物資強奪作戦 | yes | T npc.アトルガン白門.Isdebaaq
MN - 19
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が傭兵長以上
LK condition:募集要員はレベル60・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績2,400＋開けた箱の数×200（マムージャ兵訓練所）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Breaking_Morale;LC、15分、Lv.60。8つの箱の慰問物資を、スタートの Quhaaja に見つからずに渡す。1つでよい。Mamool Ja Trainer に見つかると I-8 の行き止まりに飛ばされ、持っている物資は箱に戻る。Recruit は襲ってくるが、寝かせるとすぐタゲが切れる。いちばん早いのは、トンネルを出て左の坂を上った I-7 の1つ目の箱。Quhaaja に話して終えると Rune of Release が出て、そのあとは渡せない（FFXIclopedia：Isdebaaq L-10。スタート・Rune of Release・Quhaaja は北の同じ場所。牢屋のそばの Viscous Liquid でマムージャに化けられるが、スリップがあり、箱を開けると解ける。箱は I-7 上段・H-7 地面・H-7 上段・H-8 上段・G-7 中段・G-7 上段・H-9 地面・I-8 中段。8つのうち5つは牢屋からしか行けない。3人なら2つ要る、とも書く）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のIsdebaaqに話して「慰問物資強奪作戦」を選び、だいじなもの「アサルト参加証・マムージャ兵訓練所」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Isdebaaq | K 皇国軍認識票
g03 go - | バフラウ段丘(H-11)のマムージャ監視哨へ行く | 六門院から飛べる。歩くときはマムークを通って、バフラウ段丘の小さい地図に出てから左の壁ぞいに南へ。 | @バフラウ段丘 H-11
g04 talk - | 突入のリーダーになる人は、マムージャ監視哨のDaswillに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @バフラウ段丘 H-11 | T npc.52.Daswill
g05 examine - | リーダーがマムージャ監視哨のRunic Sealを調べて、マムージャ兵訓練所に突入する | 全員が同じアサルト参加証を持って近くにいること。15分。 | @バフラウ段丘 H-11 | T obj.52.Runic_Seal | K アサルト参加証・マムージャ兵訓練所
g06 examine - | トンネルを出て左（東）の坂を上り、突き当たり(I-7)のSupplies Crateを開けて慰問物資「野兎の尻尾」を取る | スタートは(H-6)。箱は8つあり、これがいちばん取りやすい。杖を持った青いMamool Ja Trainerに見つかると、行き止まりの牢屋に飛ばされ、持っている慰問物資は箱に戻る。下にいるTrainerからも見えるので、崖のふちに寄りすぎない。黄色いMamool Ja Recruitは襲ってくるが、寝かせるとタゲが切れる。 | @マムージャ兵訓練所 I-7 | T obj.66.Supplies_Crate = obj:Supplies Crate!@マムージャ兵訓練所
g07 talk - | スタート(H-6)のQuhaajaに話して、慰問物資を渡す | 3人以上で行くときは2つ要ると書く資料もある。 | @マムージャ兵訓練所 H-6 | T npc.66.Quhaaja = npc:Quhaaja@マムージャ兵訓練所 H-6
g08 examine - | （してもしなくてもよい）ほかのSupplies Crateも開けて、慰問物資をQuhaajaに渡す | 渡した数だけ作戦戦績が増える。広場の正面の大木の裏(H-7)にも1つある。残りは牢屋から行く場所にあり、牢屋のそばのViscous Liquidを飲むとマムージャに化けて見つからなくなる。化けているあいだはHPが減り続け（最大HPの2%ずつ）、箱を開けると解ける。ストンスキン・リジェネで持たせる。 | @マムージャ兵訓練所 | T obj.66.Supplies_Crate
g09 talk - | Quhaajaに話して作戦を終えるほうを選ぶ | 選ぶと少しして出口が出る。そのあとは慰問物資を渡せない。時間ぎりぎりだと間に合わないので、残り1分になる前に話す。 | @マムージャ兵訓練所 H-6 | T npc.66.Quhaaja
g10 examine - | （してもしなくてもよい）マムージャ兵訓練所のAncient Lockboxを開ける | | @マムージャ兵訓練所
g11 examine - | スタート(H-6)に出るマムージャ兵訓練所のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @マムージャ兵訓練所 H-6 | T obj.66.Rune_of_Release_H-6 = obj:Rune of Release@マムージャ兵訓練所 H-6

@ mission.assault.020 https://wiki.ffo.jp/html/8413.html
Q Evade and Escape | 土筆作戦 | yes | T npc.アトルガン白門.Famad
MN - 20
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が傭兵長以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,000（レベロス風穴）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Evade_and_Escape;LC、30分、Lv.70。3つのスイッチを同時に入れる。スイッチは7か所の候補（マップのはしの行き止まり）のうち3か所に出て、入れると5分つづく。ワイドスキャンに出ない。Dahak 3体は視界がせまく、HPがとても多い。3つ入ると H-8 の洞くつに Rune of Release（FFXIclopedia：Famad L-10。7つの小部屋のうち3つ。いちばん西の2か所なら1人で両方押せる。G-7 の大部屋の南東のすみと G-8 の東に隠れられる岩。Dahak は見て絡み、引き寄せを使う。Rune of Release は H-8）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のFamadに話して「土筆作戦」を選び、だいじなもの「アサルト参加証・レベロス風穴」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Famad | K 皇国軍認識票
g03 go - | ゼオルム火山(K-6)のハルブーン監視哨へ行く | 六門院から飛べる。歩くときは、ハルブーンに入ってエスケプするとゼオルム火山(L-7)に出るので、(L-6)から西の通路を進む。 | @ゼオルム火山 K-6
g04 talk - | 突入のリーダーになる人は、ハルブーン監視哨のWaudeenに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @ゼオルム火山 K-6 | T npc.61.Waudeen
g05 examine - | リーダーがハルブーン監視哨のRunic Sealを調べて、レベロス風穴に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @ゼオルム火山 K-6 | T obj.61.Runic_Seal | K アサルト参加証・レベロス風穴
g06 go - | レベロス風穴のはしの行き止まりの小部屋を回って、Switchが出ている3か所を見つける | スタートは(H-5)。Switchは7か所のうち3か所に出て、ワイドスキャンに出ない。7か所は北の(G-6)、(G-8)から西の(E-7)・(E-8)、南東の(G-10)・(J-7)・(J-9)・(K-11)。(G-6)以外へは(G-8)を通る。通路を歩くDahak（3体）は見て絡み、大きい1体は引き寄せを使うので、壁ぎわや岩のかげでやりすごす。 | @レベロス風穴 | T obj.63.Switch = obj:Switch!@レベロス風穴
g07 examine - | 3か所のSwitchを、5分のうちに全部調べる | 調べたSwitchは5分光っていて、そのあいだに3つとも光れば目標達成。同時でなくてよく、1人で全部押してもよい。先に3か所を見つけておき、遠いほうから押してゴールへ戻るとよい。 | @レベロス風穴 | T obj.63.Switch
g08 examine - | （してもしなくてもよい）レベロス風穴のAncient Lockboxを開ける | | @レベロス風穴
g09 examine - | レベロス風穴(H-8)の洞くつに出るRune of Releaseを調べて外に出ると完了 | (G-8)を通ってスタートのほうへ戻るので、最後までDahakに気をつける。帰ったら公務代理店で報告して参加証を返しておく。 | @レベロス風穴 H-8 | T obj.63.Rune_of_Release_H-8

@ mission.assault.021 https://wiki.ffo.jp/html/8735.html
Q Shooting Down the Baron | 黒い男爵撃墜作戦 | yes | T npc.アトルガン白門.Lageegee
MN - 21
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が傭兵長以上
LK condition:募集要員はレベル60・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,300（ペリキア）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Shooting_Down_the_Baron;LC、15分、Lv.60。Black Baron を倒す。東の I-8 の部屋から入り、Rune of Release もそこに出る。Black Baron はまん中か北西・北東・南西・南東のトンネルのどこかに出て、ワイドスキャンに出ない。戦うと少しして別の場所へワープする。ペットは追っていく。Periqia Pugil 6（音で絡み、リンクする）（FFXIclopedia：Lageegee L-10。I-8 から入る。上から見えなければ、こわれた橋から下りる。スタートのそばに出ることもある。こちらからは絡まない。HP15%ほどごとにワープし、HPは回復しない。プギルは寝かせて離れるとタゲが切れる。倒すとスタートに Rune of Release と Ancient Lockbox）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のLageegeeに話して「黒い男爵撃墜作戦」を選び、だいじなもの「アサルト参加証・ペリキア」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Lageegee | K 皇国軍認識票
g03 go - | カダーバの浮沼(I-9)のドゥブッカ島監視哨へ行く | 六門院から飛べる。歩くときは、カダーバの浮沼(E-11)のNasheefaにアトルガン白銀貨を渡してアルザダール海底遺跡群を通り、ドゥブッカ島側に出て右の壁ぞいに進む。 | @カダーバの浮沼 I-9 #2
g04 talk - | 突入のリーダーになる人は、ドゥブッカ島監視哨のNahshibに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 I-9 #2 | T npc.79.Nahshib
g05 examine - | リーダーがドゥブッカ島監視哨のRunic Sealを調べて、ペリキアに突入する | 全員が同じアサルト参加証を持って近くにいること。15分。 | @カダーバの浮沼 I-9 #2 | T obj.79.Runic_Seal | K アサルト参加証・ペリキア
g06 go - | スタート(I-8)から西へ進んで、ペリキアのどこかにいるBlack Baronを探す | Black Baronはどこに出るか毎回ちがい、ワイドスキャンに出ない。スタートのそばにいることもある。スタートのすぐ西の、穴のあいた橋から下に落ちられるが、落ちると北(I-7)を回る遠回りになる。スタートはH-8と書く資料もある。プギルは音で絡み、インビジを見破る。寝かせたあと十分に離れないとタゲが切れない。 | @ペリキア
g07 defeat - | Black Baronを倒す | こちらからは絡んでこない。戦っていると少しして別の場所へワープして逃げるが、HPは回復しない。ペットを当てておくとワープしたあとも追っていくので目印になる。アムネジアと静寂のTP技を使う。 | @ペリキア | T mob.56.Black_Baron = mob:Black Baron!@ペリキア
g08 examine - | （してもしなくてもよい）スタート(I-8)に出るペリキアのAncient Lockboxを開ける | | @ペリキア I-8
g09 examine - | スタート(I-8)に出るペリキアのRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ペリキア I-8 | T obj.56.Rune_of_Release_I-8 = obj:Rune of Release@ペリキア I-8

@ mission.assault.022 https://wiki.ffo.jp/html/8736.html
Q Demolition Duty | イルルシ掃海作戦 | yes | T npc.アトルガン白門.Bhoy_Yhupplo
MN - 22
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が傭兵長以上
LK condition:募集要員はレベル50・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,000（イルルシ環礁）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Demolition_Duty;LC、30分、Lv.50。スタートの NPC に話すとオートマトンを1体借りられ、話した人について行く。5つの難破船をオートマトンに壊させる。範囲攻撃を近くに当てても削れる。オートマトンがWSを使うたびに Carrion Crab が出てオートマトンを狙う（HP2000ほど）。壊れたらスタートの NPC でまた借りられる。全部壊したらスタートの NPC に話すと Rune of Release（FFXIclopedia：Bhoy Yhupplo L-9/10。H-10 の船の上の Uzhahn から始まる。難破船は南側だけ。離れすぎると5秒後に止まる。Imp はオートマトンやペットにも絡み、5分ほどでまた出る。傷んだら Uzhahn で直せる）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のBhoy Yhupploに話して「イルルシ掃海作戦」を選び、だいじなもの「アサルト参加証・イルルシ環礁」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Bhoy_Yhupplo | K 皇国軍認識票
g03 go - | アラパゴ暗礁域(G-5)のイルルシ環礁監視哨へ行く | 六門院から飛べる。歩くととても遠く、監視哨の前にインプが多い。 | @アラパゴ暗礁域 G-5
g04 talk - | 突入のリーダーになる人は、イルルシ環礁監視哨のMeyaadaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @アラパゴ暗礁域 G-5 | T npc.54.Meyaada
g05 examine - | リーダーがイルルシ環礁監視哨のRunic Sealを調べて、イルルシ環礁に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @アラパゴ暗礁域 G-5 | T obj.54.Runic_Seal | K アサルト参加証・イルルシ環礁
g06 talk - | スタート(H-10)の船の上のUzhahnに話して、Demolition Automatonを借りる | 1体しか借りられず、話した人について行く。ケアル・プロテス・シェル・ヘイストがかけられる白魔道士や赤魔道士が借りるとよい。 | @イルルシ環礁 H-10 | T npc.55.Uzhahn = npc:Uzhahn@イルルシ環礁 H-10
g07 talk - | Demolition Automatonに話して、ついて来させる | | @イルルシ環礁 H-10 | T npc.55.Demolition_Automaton = npc:Demolition Automaton!@イルルシ環礁
g08 go - | オートマトンを連れて南の岩場のWreckage（木材でふさがれた所）5か所へ行き、壊させる | Wreckageは(F-8)・(G-9)・(H-9)・(I-10)に2つで、北半分には行かなくてよい。近くに行くとオートマトンが勝手に壊しはじめる。離れすぎると緑の名前になって5カウント後に自爆するので、すぐ話しかけて止める。移動速度アップの装備は外しておく。インプはこちらにもオートマトンにもペットにも絡み、5分ほどでまた出る。 | @イルルシ環礁
g09 defeat - | オートマトンが作業中に出るCarrion Crabを倒して、オートマトンを守る | カニはオートマトンだけを狙う。カニやインプに範囲攻撃を当てると、近くのWreckageも削れる。オートマトンが壊れたら、Uzhahnに話すとまた借りられる。 | @イルルシ環礁
g10 talk - | 5か所とも壊したら、Uzhahnに話す | 目の前に出口が出る。 | @イルルシ環礁 H-10 | T npc.55.Uzhahn
g11 examine - | （してもしなくてもよい）イルルシ環礁のAncient Lockboxを開ける | | @イルルシ環礁
g12 examine - | スタート(H-10)に出るイルルシ環礁のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @イルルシ環礁 H-10 | T obj.55.Rune_of_Release_H-10 = obj:Rune of Release@イルルシ環礁 H-10

@ mission.assault.023 https://wiki.ffo.jp/html/8276.html
Q Counting Sheep | 黒羊買付作戦 | yes | T npc.アトルガン白門.Yahsra
MN - 23
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が伍長以上
LK condition:募集要員はレベル60・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績1000＋羊の数×500（最大3500）（ルジャワン霊窟）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Counting_Sheep;C、15分、Lv.60。氷の壁の奥の Karakul を助ける。入口に Qiqirn 4人：Mine Baron（つるはし、鉱石を貨幣に）、Greengrocer（鎌、収穫物を食べ物に）、Dealer（青銅貨5か白銀貨1で賭け、勝つと黄金貨）、Shepherd（黄金貨1・白銀貨4・青銅貨20で雇える。氷の壁まで連れて行くと爆破する。食べ物を欲しがることがある）。部屋の中の Karakul を調べないと数えない。1匹で Rune of Release が出る（FFXIclopedia：Yahsra L-10。鉱石は1種類1つずつしか持てない。氷の壁はおよそ F-8・G-8・H-8・H-9・I-9。Rune of Release はスタートに出る）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のYahsraに話して「黒羊買付作戦」を選び、だいじなもの「アサルト参加証・ルジャワン霊窟」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Yahsra | K 皇国軍認識票
g03 go - | カダーバの浮沼(K-9)のアズーフ島監視哨へ行く | 六門院から飛べる。 | @カダーバの浮沼 K-9
g04 talk - | 突入のリーダーになる人は、アズーフ島監視哨のNareemaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 K-9 | T npc.79.Nareema
g05 examine - | リーダーがアズーフ島監視哨のRunic Sealを調べて、ルジャワン霊窟に突入する | 全員が同じアサルト参加証を持って近くにいること。15分。戦闘はない。 | @カダーバの浮沼 K-9 | T obj.79.Runic_Seal | K アサルト参加証・ルジャワン霊窟
g06 talk - | スタートのQiqirn Mine Baronに話して、つるはしをもらう | スタートにはキキルンが4人いる。持ちこんだ物は使えず、もらった物はほかの人にトレードできない。 | @ルジャワン霊窟 H-9 I-9 | T npc.69.Qiqirn_Mine_Baron = npc:Qiqirn Mine Baron@ルジャワン霊窟 H-9 I-9
g07 examine - | ルジャワン霊窟のMining Pointを調べて、銅鉱・銀鉱・金鉱を掘る | 同じ鉱石は1つずつしか持てないので、こまめに貨幣にかえる。金鉱が出ればいちばん早い。 | @ルジャワン霊窟 | T obj.69.Mining_Point
g08 talk - | Qiqirn Mine Baronに話して、鉱石をアトルガン青銅貨・白銀貨・黄金貨にかえる | 銅鉱は青銅貨、銀鉱は白銀貨、金鉱は黄金貨になる。 | @ルジャワン霊窟 H-9 I-9 | T npc.69.Qiqirn_Mine_Baron
g09 talk - | （してもしなくてもよい）Qiqirn Dealerに青銅貨5枚か白銀貨1枚をはらって賭けをし、勝てば黄金貨をもらう | こちらが先に/randomをふり、1000をこえずに1000に近いほうが勝ち。キキルンが勝ちやすい。白銀貨を持って話すとすぐ賭けが始まる。 | @ルジャワン霊窟 H-9 I-9 | T npc.69.Qiqirn_Dealer = npc:Qiqirn Dealer@ルジャワン霊窟 H-9 I-9
g10 talk - | 黄金貨1枚（白銀貨なら4枚、青銅貨なら20枚）を持ってQiqirn Shepherdに話して、雇う | 白銀貨は同じShepherdにわたしていく。Shepherdはスタートに1人いて、氷の中からも出てくる。 | @ルジャワン霊窟 | T npc.69.Qiqirn_Shepherd = npc:Qiqirn Shepherd!@ルジャワン霊窟
g11 go - | Qiqirn Shepherdを氷の壁（Ice Cage）まで連れて行って、爆破させる | 雇った人が離れすぎるとShepherdは近くまでワープしてくる。黒羊はF-8・G-7・I-9に1匹ずつとH-8に2匹と書く資料と、氷の壁はF-8・G-8・H-8・H-9・I-9のあたりと書く資料がある。 | @ルジャワン霊窟
g12 talk - | Shepherdが「腹が減った」「のどが渇いた」と言ったときは、Qiqirn Greengrocerに草刈鎌をもらってHarvesting Pointでボスディン菜・スノーリリー・シモカブを取り、パママ・パママ・オレ・デーツにかえて持って行く | 食べ物を持ってShepherdに話すと食べて、また爆破にもどる。だれが持って行ってもよい。言わないときはそのまま次へ。 | @ルジャワン霊窟 H-9 I-9 | T npc.69.Qiqirn_Greengrocer = npc:Qiqirn Greengrocer@ルジャワン霊窟 H-9 I-9
g13 examine - | 氷がなくなった部屋の黒羊（Karakul）を調べて買い付ける | 1匹で目標達成で、スタートに出口とAncient Lockboxが出る。調べないと数えない。 | @ルジャワン霊窟 | T npc.69.Karakul = npc:Karakul!@ルジャワン霊窟
g14 examine - | （してもしなくてもよい）時間まで、ほかの黒羊も同じように買い付ける | 黒羊は5匹で、多いほど作戦戦績が多い。氷をこわした中にもShepherdがいるので、近いShepherdを雇うとよい。 | @ルジャワン霊窟 | T npc.69.Karakul
g15 examine - | （してもしなくてもよい）スタートに出るルジャワン霊窟のAncient Lockboxを開ける | | @ルジャワン霊窟 H-9 I-9
g16 examine - | スタートに出るルジャワン霊窟のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ルジャワン霊窟 H-9 I-9 | T obj.69.Rune_of_Release_H-9_I-9 = obj:Rune of Release@ルジャワン霊窟 H-9 I-9

@ mission.assault.024 https://wiki.ffo.jp/html/7037.html
Q The Double Agent | 二重スパイ捕縛作戦 | yes | T npc.アトルガン白門.Isdebaaq
MN - 24
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が伍長以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,600から誤認逮捕の回数だけ減る（マムージャ兵訓練所）
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Double_Agent;C、30分、Lv.70。たくさんの Qiqirn Spy のうち1人がスパイ。話すと「捕まえる」「話す」。スパイだけがうそをつき、ほかはほんとうのことを言う（近い・遠い・方角・何ヤルム）。ちがうキキルンを捕まえると、もう話を聞けず、作戦戦績が減る。Puk はすぐタゲが切れ、すぐまた出る。Rune of Release は I-8 の南西（FFXIclopedia：Isdebaaq L-10。スパイは何も教えないこともある。Puk はキキルンの集まりごとに2体、3分ほどでまた出る。Rune of Release は I-8 の南）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のIsdebaaqに話して「二重スパイ捕縛作戦」を選び、だいじなもの「アサルト参加証・マムージャ兵訓練所」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Isdebaaq | K 皇国軍認識票
g03 go - | バフラウ段丘(H-11)のマムージャ監視哨へ行く | 六門院から飛べる。歩くときはマムークを通って、バフラウ段丘の小さい地図に出てから左の壁ぞいに南へ。 | @バフラウ段丘 H-11
g04 talk - | 突入のリーダーになる人は、マムージャ監視哨のDaswillに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @バフラウ段丘 H-11 | T npc.52.Daswill
g05 examine - | リーダーがマムージャ監視哨のRunic Sealを調べて、マムージャ兵訓練所に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @バフラウ段丘 H-11 | T obj.52.Runic_Seal | K アサルト参加証・マムージャ兵訓練所
g06 talk - | マムージャ兵訓練所のQiqirn Spyに話して「質問するるん」を選び、スパイのいる方角や近さを聞いて回る | スタートは(G-9)。スパイは1人だけで、うそを言うか「知らない」と答える。ほかのキキルンはほんとうのことを言う。近くのキキルン何人かに聞いて、1人だけ話が合わなければそれがスパイ。何人かいるときは西・南・東の部屋を分けて聞くとよい。Pukは絡んでくるが、すぐまた出るので相手にしなくてよい。 | @マムージャ兵訓練所 | T npc.66.Qiqirn_Spy = npc:Qiqirn Spy!@マムージャ兵訓練所
g07 talk - | スパイだと思うQiqirn Spyに話して「捕獲するるん」を選び、捕まえる | 当たると「なぜわかった」と言って目標達成。ちがうキキルンを捕まえるとそのキキルンには聞けなくなり、作戦戦績が減る。片っぱしから捕まえてもクリアはできる。 | @マムージャ兵訓練所 | T npc.66.Qiqirn_Spy
g08 examine - | （してもしなくてもよい）マムージャ兵訓練所のAncient Lockboxを開ける | | @マムージャ兵訓練所
g09 examine - | マムージャ兵訓練所(I-8)の南のほうに出るRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @マムージャ兵訓練所 I-8 | T obj.66.Rune_of_Release_I-8 = obj:Rune of Release@マムージャ兵訓練所 I-8

@ mission.assault.025 https://wiki.ffo.jp/html/5175.html
Q Siegemaster Assassination | 傭兵軍師狙撃作戦 | yes | T npc.アトルガン白門.Famad
MN - 25
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が伍長以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,300（レベロス風穴）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Siegemaster_Assassination;C、30分、Lv.70。Old Troll（狩人）8体のうち1体が Borgerlur。遠隔攻撃とイーグルアイは分身を通す。外れはすぐまた出るが、当たりは変わらない（また出たものはいつも外れ）。また出るまで3分45秒。倒すとほかは消え、G-7 に Rune of Release（FFXIclopedia：Famad L-10。入ると H-8 のあたりにトロールが多い部屋。G-7 から始めて南へ、と書く人もいる。また出るまで5分ほど。Rune of Release は G-7）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のFamadに話して「傭兵軍師狙撃作戦」を選び、だいじなもの「アサルト参加証・レベロス風穴」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Famad | K 皇国軍認識票
g03 go - | ゼオルム火山(K-6)のハルブーン監視哨へ行く | 六門院から飛べる。歩くときは、ハルブーンに入ってエスケプするとゼオルム火山(L-7)に出るので、(L-6)から西の通路を進む。 | @ゼオルム火山 K-6
g04 talk - | 突入のリーダーになる人は、ハルブーン監視哨のWaudeenに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @ゼオルム火山 K-6 | T npc.61.Waudeen
g05 examine - | リーダーがハルブーン監視哨のRunic Sealを調べて、レベロス風穴に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @ゼオルム火山 K-6 | T obj.61.Runic_Seal | K アサルト参加証・レベロス風穴
g06 defeat - | レベロス風穴のOld Troll（8体）を順に倒して、ボーゲールーがなりすました1体を倒す | スタートは(G-7)。見た目では区別できない。外れはすぐ（別の場所に）また出るが、また出たものはいつも外れなので、倒した相手と区別しておく。当たりを倒すとセリフが出て、ほかのOld Trollは消える。遠隔攻撃とイーグルアイは分身を通す。 | @レベロス風穴 | T mob.63.Old_Troll = mob:Old Troll@レベロス風穴
g07 examine - | （してもしなくてもよい）レベロス風穴のAncient Lockboxを開ける | | @レベロス風穴
g08 examine - | スタート(G-7)に出るレベロス風穴のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @レベロス風穴 G-7 | T obj.63.Rune_of_Release_G-7 = obj:Rune of Release@レベロス風穴 G-7

@ mission.assault.026 https://wiki.ffo.jp/html/6406.html
Q Building Bridges | ペリキア架橋作戦 | yes | T npc.アトルガン白門.Lageegee
MN - 26
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が伍長以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,600（ペリキア）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Building_Bridges;C、15分、Lv.70。4つのスイッチを入れる。小さい地図から始まり、北東へ進んで大きい地図に出る。スイッチは西 F-8・南 H-10・北 H-6・東 J-8 の部屋で、どの順でもよく、ずっと入ったまま。Rune of Release はまん中の H-8。ラミア（NPC）は襲わないが、つかまるとスタートにもどされる。追うのは1人だけ（FFXIclopedia：Lageegee L-10。スタートは小さい地図の H-6 の部屋で、J-6 から大きい地図へ。ラミアは見破り、5歩ほどでつかまる。レーダーに緑の点で出るが、ワイドスキャンには出ない。スイッチ F-8・H-6・J-8・H-10、Rune of Release H-8）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のLageegeeに話して「ペリキア架橋作戦」を選び、だいじなもの「アサルト参加証・ペリキア」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Lageegee | K 皇国軍認識票
g03 go - | カダーバの浮沼(I-9)のドゥブッカ島監視哨へ行く | 六門院から飛べる。歩くときは、カダーバの浮沼(E-11)のNasheefaにアトルガン白銀貨を渡してアルザダール海底遺跡群を通り、ドゥブッカ島側に出て右の壁ぞいに進む。 | @カダーバの浮沼 I-9 #2
g04 talk - | 突入のリーダーになる人は、ドゥブッカ島監視哨のNahshibに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 I-9 #2 | T npc.79.Nahshib
g05 examine - | リーダーがドゥブッカ島監視哨のRunic Sealを調べて、ペリキアに突入する | 全員が同じアサルト参加証を持って近くにいること。15分。戦闘はない。 | @カダーバの浮沼 I-9 #2 | T obj.79.Runic_Seal | K アサルト参加証・ペリキア
g06 go - | スタート(H-6)の部屋を出て左（東）へ進み、大きい地図に出る | スタートは海猫護送作戦と同じ部屋。右へ行っても扉は開かない。ラミアは見破りがあり、見つかると追ってきて、つかまるとスタートにもどされる。追うのは見つけた1人だけ。柱をはさむと見えない。近づくとコンパスに緑の点で出るが、ワイドスキャンには出ない。 | @ペリキア H-6
g07 examine - | 大きい地図の西の部屋(F-8)のスイッチを調べる | 4つのスイッチはどの順でもよく、一度入れれば消えない。 | @ペリキア F-8 | T obj.56.Switch_F-8 = obj:Switch@ペリキア F-8
g08 examine - | 北の部屋(H-6)のスイッチを調べる | | @ペリキア H-6 | T obj.56.Switch_H-6 = obj:Switch@ペリキア H-6
g09 examine - | 東の部屋(J-8)のスイッチを調べる | | @ペリキア J-8 | T obj.56.Switch_J-8 = obj:Switch@ペリキア J-8
g10 examine - | 南の部屋(H-10)のスイッチを調べる | 4つ目を入れると目標達成。ラミアがゴールのまわりに集まるので、ほかの人がゴールに着いてから4つ目を入れるとよい。 | @ペリキア H-10 | T obj.56.Switch_H-10 = obj:Switch@ペリキア H-10
g11 examine - | （してもしなくてもよい）ペリキアのAncient Lockboxを開ける | | @ペリキア
g12 examine - | まん中の部屋(H-8)に出るペリキアのRune of Releaseを調べて外に出ると完了 | 目標達成のあとでも、ラミアにつかまるとスタートにもどされる。帰ったら公務代理店で報告して参加証を返しておく。 | @ペリキア H-8 | T obj.56.Rune_of_Release_H-8 = obj:Rune of Release@ペリキア H-8

@ mission.assault.027 https://wiki.ffo.jp/html/8797.html
Q Searat Salvation | シーラット送迎作戦 | yes | T npc.アトルガン白門.Bhoy_Yhupplo
MN - 27
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が伍長以上
LK condition:募集要員はレベル60・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績1,000＋連れて行ったキキルン1匹につき500（1,500〜3,500）（イルルシ環礁）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Searat_Salvation;C、15分、Lv.60。Qiqirn Diver を F-10 のスタートから J-6 の Qiqirn Chief Diver まで連れて行く。話すとついて来て、1人で何匹でも連れられる。Giant Orobon（NPC）に見られるとキキルンは逃げるので、また話しかける。1匹連れて行けば Rune of Release が出る（FFXIclopedia：Bhoy Yhupplo L-9/10。F-10 から始まり、目の前に Diver 5匹。最初に話した人について行く。オロボンは見て追い、細い視界のわきを通れる。Diver はワイドスキャンに出て、オロボンは出ない。Chief Diver は J-6）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のBhoy Yhupploに話して「シーラット送迎作戦」を選び、だいじなもの「アサルト参加証・イルルシ環礁」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Bhoy_Yhupplo | K 皇国軍認識票
g03 go - | アラパゴ暗礁域(G-5)のイルルシ環礁監視哨へ行く | 六門院から飛べる。歩くととても遠く、監視哨の前にインプが多い。 | @アラパゴ暗礁域 G-5
g04 talk - | 突入のリーダーになる人は、イルルシ環礁監視哨のMeyaadaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @アラパゴ暗礁域 G-5 | T npc.54.Meyaada
g05 examine - | リーダーがイルルシ環礁監視哨のRunic Sealを調べて、イルルシ環礁に突入する | 全員が同じアサルト参加証を持って近くにいること。15分。戦闘はない。 | @アラパゴ暗礁域 G-5 | T obj.54.Runic_Seal | K アサルト参加証・イルルシ環礁
g06 talk - | スタート(F-10)のQiqirn Diverに話して、ついて来させる | 5匹いて、1人で全部連れてもよい。最初に話した人について行く。 | @イルルシ環礁 F-10 | T npc.55.Qiqirn_Diver = npc:Qiqirn Diver!@イルルシ環礁
g07 go - | Giant Orobonに見られないようにして、キキルンをゴール(J-6)の小部屋まで連れて行く | オロボン（NPC）は決まった道を歩き、キキルンを見ると追う。こちらには何もしない。視界は長いが細いので、わきや後ろを通る。壁のくぼみや海ぞいでやりすごす。オロボンはワイドスキャンに出ない。 | @イルルシ環礁
g08 talk - | キキルンが逃げたときは、追いかけて話しかけ、また連れて行く | だれが話しかけてもよく、話した人について来る。キキルンはワイドスキャンに出る。足が速いので、近道して追う。逃げないときはそのまま次へ。 | @イルルシ環礁 | T npc.55.Qiqirn_Diver
g09 talk - | キキルンを連れて、ゴール(J-6)のQiqirn Chief Diverに話す | 1匹でも連れていれば目標達成。 | @イルルシ環礁 J-6 | T npc.55.Qiqirn_Chief_Diver = npc:Qiqirn Chief Diver@イルルシ環礁 J-6
g10 go - | （してもしなくてもよい）時間まで、残りのキキルンも連れて来る | 連れて来た数が多いほど作戦戦績が多い。 | @イルルシ環礁
g11 examine - | （してもしなくてもよい）イルルシ環礁のAncient Lockboxを開ける | | @イルルシ環礁
g12 examine - | ゴール(J-6)に出るイルルシ環礁のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @イルルシ環礁 J-6 | T obj.55.Rune_of_Release_J-6 = obj:Rune of Release@イルルシ環礁 J-6


@ mission.assault.028 https://wiki.ffo.jp/html/6780.html
Q Supplies Recovery | 補給物資奪還指令 | yes | T npc.アトルガン白門.Yahsra
MN - 28
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が軍曹以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績は取り返した補給物資の数で変わる（ルジャワン霊窟）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Supplies_Recovery;S、30分、Lv.70。スタートの Kuihlud に話すまでインプは出ない。インプが落とす補給物資（テンポラリアイテム）を不滅隊より多く集める。不滅隊が一度でも攻撃したインプの物資は不滅隊のもの。全部の物資が出るわけではない。6つ集めるとインプが残っていても達成。インプが全部倒れたときに同じか少ないと失敗。Rune of Release はスタートの Kuihlud の横（FFXIclopedia：Yahsra L-10。スタートは J-7。不滅隊は Gasharyad と Salimuhl の2人で、地形に関係なく動く）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のYahsraに話して「補給物資奪還指令」を選び、だいじなもの「アサルト参加証・ルジャワン霊窟」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Yahsra | K 皇国軍認識票
g03 go - | カダーバの浮沼(K-9)のアズーフ島監視哨へ行く | 六門院から飛べる。 | @カダーバの浮沼 K-9
g04 talk - | 突入のリーダーになる人は、アズーフ島監視哨のNareemaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 K-9 | T npc.79.Nareema
g05 examine - | リーダーがアズーフ島監視哨のRunic Sealを調べて、ルジャワン霊窟に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 K-9 | T obj.79.Runic_Seal | K アサルト参加証・ルジャワン霊窟
g06 go - | （してもしなくてもよい）Kuihludに話す前に、話す人を1人だけ残して、ほかの人はエリアのまん中の広間や崖の上へ先に行っておく | インプは話すまで出ない。不滅隊はスタートに近いインプから向かうので、遠くのインプを先に倒せるようにしておく。 | @ルジャワン霊窟
g07 talk - | スタート(J-7)のKuihludに話して作戦を始める | 話すとインプが10体出て、不滅隊の2人も動き出す。 | @ルジャワン霊窟 J-7 | T npc.69.Kuihlud = npc:Kuihlud@ルジャワン霊窟 J-7
g08 defeat - | 不滅隊が手を出す前にルジャワン霊窟のインプを倒して、補給物資を集める | 不滅隊が一度でも攻撃したインプは、こちらが倒しても物資は不滅隊のものになる。物資を落とさないインプもいる。6つ集めるか、インプが全部倒れたときに不滅隊より多ければ目標達成で、同じ数だと失敗。不滅隊はとても強く足が速く、こちらが登れない崖も登る。スタート近くのインプを1匹残して不滅隊をそこに引きつけ、奥のインプを先に倒す手もある。 | @ルジャワン霊窟
g09 examine - | （してもしなくてもよい）ルジャワン霊窟のAncient Lockboxを開ける | | @ルジャワン霊窟
g10 examine - | スタート(J-7)のKuihludの横に出るルジャワン霊窟のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ルジャワン霊窟 J-7 | T obj.69.Rune_of_Release_J-7 = obj:Rune of Release@ルジャワン霊窟 J-7

@ mission.assault.029 https://wiki.ffo.jp/html/8799.html
Q Imperial Treasure Retrieval | 魔宝石回収指令 | yes | T npc.アトルガン白門.Isdebaaq
MN - 29
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が軍曹以上
LK condition:募集要員はレベル50・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績は回収した魔宝石の数で変わる（マムージャ兵訓練所）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Imperial_Treasure_Retrieval;S、15分、Lv.50。戦闘はなく鬼ごっこ。宝箱（9つ、鍵はいらない）を開けると魔宝石。持っているときにマムージャ（Red・Blue・Yellow・Green・White・Black Badge Mamool Ja）に近づかれると取られてスタートにもどされる。持っていないときは、魔宝石を持ったマムージャに話して取り返せる。マムージャは F-7 の Mamool Ja Governor へ運ぶ。Governor に話すと魔宝石を取られてスタートにもどされる。1つ以上 Zahakahm に返してから話すと Rune of Release（FFXIclopedia：Isdebaaq L-10。スタートと Zahakahm は H-10、Rune of Release も H-10。マムージャはワイドスキャンに出ない。Governor は F-7）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のIsdebaaqに話して「魔宝石回収指令」を選び、だいじなもの「アサルト参加証・マムージャ兵訓練所」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Isdebaaq | K 皇国軍認識票
g03 go - | バフラウ段丘(H-11)のマムージャ監視哨へ行く | 六門院から飛べる。歩くときはマムークを通って、バフラウ段丘の小さい地図に出てから左の壁ぞいに南へ。 | @バフラウ段丘 H-11
g04 talk - | 突入のリーダーになる人は、マムージャ監視哨のDaswillに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @バフラウ段丘 H-11 | T npc.52.Daswill
g05 examine - | リーダーがマムージャ監視哨のRunic Sealを調べて、マムージャ兵訓練所に突入する | 全員が同じアサルト参加証を持って近くにいること。15分。戦闘はない。 | @バフラウ段丘 H-11 | T obj.52.Runic_Seal | K アサルト参加証・マムージャ兵訓練所
g06 examine - | マムージャ兵訓練所の宝箱を開けて、魔宝石を取り出す | 突入するとすぐ始まる。宝箱は9つで、鍵はいらない。マムージャも同じように宝箱を開けて回っている。 | @マムージャ兵訓練所
g07 go - | 魔宝石を持ったまま、マムージャに見つからないようにスタート(H-10)へもどる | 持っているときにマムージャに近づかれると、魔宝石を取られてスタートにもどされる。見つかっても追いつかれなければよいので、足の速い装備やとんずらが役に立つ。マムージャはワイドスキャンに出ない。スタートのまわりを歩く3匹に気をつける。(F-7)のMamool Ja Governorには話さない（魔宝石を取られてもどされる）。 | @マムージャ兵訓練所 H-10
g08 talk - | （してもしなくてもよい）魔宝石を持っているマムージャに話して、取り返す | 魔宝石を持っていないときだけ取り返せる。2人1組で動いて、取られたらすぐ相方が取り返すとよい。マムージャの陣地に持ちこまれた魔宝石は取り返せない。 | @マムージャ兵訓練所
g09 talk - | スタート(H-10)のZahakahmに話して、魔宝石を渡す | | @マムージャ兵訓練所 H-10 | T npc.66.Zahakahm = npc:Zahakahm@マムージャ兵訓練所 H-10
g10 examine - | （してもしなくてもよい）時間まで、ほかの魔宝石も同じように集めて渡す | 多いほど作戦戦績が多い。魔宝石が全部どちらかの陣地に運ばれると、そのことが表示される。 | @マムージャ兵訓練所
g11 talk - | 魔宝石を1つ以上渡したあとで、Zahakahmに話して作戦を終える | | @マムージャ兵訓練所 H-10 | T npc.66.Zahakahm
g12 examine - | （してもしなくてもよい）マムージャ兵訓練所のAncient Lockboxを開ける | | @マムージャ兵訓練所
g13 examine - | スタート(H-10)に出るマムージャ兵訓練所のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @マムージャ兵訓練所 H-10 | T obj.66.Rune_of_Release_H-10 = obj:Rune of Release@マムージャ兵訓練所 H-10

@ mission.assault.030 https://wiki.ffo.jp/html/8803.html
Q Apkallu Breeding | アプカル繁殖指令 | yes | T npc.アトルガン白門.Famad
MN - 30
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が軍曹以上
LK condition:募集要員はレベル60・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績500＋つがいの数で増える（レベロス風穴）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Apkallu_Breeding;S、15分、Lv.60。オスの Lebros Apkallu をメスのところへ連れて行ってつがいにする。1組で勝ち。鳴き声はモールス信号（Squee が短点、Quark が長点）。オスは西、メスは東に多い。オスは歩くより少し速く、離れすぎると止まる。メスはいつも同じあたり。組み合わせは Blue と Sky、Cod と Fish、Heat と Fire、Moon と Star、Orange と Apple、Rain と Cloud、Snow と White、Song と Sound。Rhap Nelhah に話して終えると Rhap Nelhah のところに Rune of Release。8組できると自動で終わる。Vulcanian Bomb はインビジでよけられ、そのあいだもアプカルはついて来る（FFXIclopedia：Famad L-10。オスは大きく、メスは小さい。オスの場所は毎回変わる。Rune of Release は Rhap Nelhah のうしろ）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のFamadに話して「アプカル繁殖指令」を選び、だいじなもの「アサルト参加証・レベロス風穴」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Famad | K 皇国軍認識票
g03 go - | ゼオルム火山(K-6)のハルブーン監視哨へ行く | 六門院から飛べる。歩くときは、ハルブーンに入ってエスケプするとゼオルム火山(L-7)に出るので、(L-6)から西の通路を進む。 | @ゼオルム火山 K-6
g04 talk - | 突入のリーダーになる人は、ハルブーン監視哨のWaudeenに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @ゼオルム火山 K-6 | T npc.61.Waudeen
g05 examine - | リーダーがハルブーン監視哨のRunic Sealを調べて、レベロス風穴に突入する | 全員が同じアサルト参加証を持って近くにいること。15分。 | @ゼオルム火山 K-6 | T obj.61.Runic_Seal | K アサルト参加証・レベロス風穴
g06 talk - | （してもしなくてもよい）入口のRhap Nelhahに話して、ヒントを聞く | スタートは(I-8)。「鳴き声がポイント」と教えてくれる。 | @レベロス風穴 I-8 | T npc.63.Rhap_Nelhah = npc:Rhap Nelhah@レベロス風穴 I-8
g07 talk - | 大きいほうのLebros Apkallu（オス）に話して、鳴き声を聞く | アプカルは16羽いて、大きいのがオス、小さいのがメス。オスは西のほう、メスは東のほうに多い。鳴き声の「クァー」を長点、「クピッ」を短点にすると和文モールス（英語版は欧文モールス）になる。オスは最初の6音、メスは最初の5音で見分けられる。 | @レベロス風穴 | T npc.63.Lebros_Apkallu = npc:Lebros Apkallu!@レベロス風穴
g08 talk - | 小さいほうのLebros Apkallu（メス）に話して、オスと組になる鳴き声のメスを探す | 組は 青と空、月と星、雪と白、熱と火、雨と雲、歌と音、鮭と魚、蜜柑と桃（英語版は COD と FISH、ORANGE と APPLE）。メスはいつもだいたい同じ場所にいる。 | @レベロス風穴 | T npc.63.Lebros_Apkallu
g09 talk - | オスにもどって話し、「連れて行きますか？」で「はい」を選ぶ | ほかの人が選んだオスは連れて行けない。 | @レベロス風穴 | T npc.63.Lebros_Apkallu
g10 talk - | オスを組になるメスのところまで連れて行き、メスに話してつがいにする | オスは足がおそく、離れすぎると止まるので、少し進んでは止まって待つ。合わないメスに会わせると、オスは泣きながら元の場所にもどり、そのあいだは連れて行けない。Vulcanian Bombはインビジでよけられ、そのあいだもオスはついて来る。 | @レベロス風穴 | T npc.63.Lebros_Apkallu
g11 talk - | （してもしなくてもよい）時間まで、ほかのオスも同じようにつがいにする | 多いほど作戦戦績が多い。8組できるとそこで自動で終わる。 | @レベロス風穴 | T npc.63.Lebros_Apkallu
g12 talk - | 入口(I-8)のRhap Nelhahに話して、作戦を終える | つがいが1組以上あれば目標達成。8組できて自動で終わったときはそのまま次へ。 | @レベロス風穴 I-8 | T npc.63.Rhap_Nelhah
g13 examine - | （してもしなくてもよい）レベロス風穴のAncient Lockboxを開ける | | @レベロス風穴
g14 examine - | Rhap Nelhahのところ(I-8)に出るレベロス風穴のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @レベロス風穴 I-8 | T obj.63.Rune_of_Release_I-8 = obj:Rune of Release@レベロス風穴 I-8

@ mission.assault.031 https://wiki.ffo.jp/html/6299.html
Q Stop the Bloodshed | ブラッドバス計画抑止作戦 | yes | T npc.アトルガン白門.Lageegee
MN - 31
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が軍曹以上
LK condition:募集要員はレベル50・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,000（ペリキア）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Stop_the_Bloodshed;S、30分、Lv.50。Augmented Chigoe 35匹を倒す。Chigoe Breeder（黒魔道士）は見破りで、倒してもすぐまた出る。行き止まりの部屋の檻のまわりもよく探す。Rune of Release は H-8（FFXIclopedia：Lageegee L-10。スタートは黒い男爵撃墜作戦と同じ地図の H-8。チゴーはワイドスキャンに出ない。クリティカル・ジョブアビリティ・ウェポンスキルで1回で倒れる。Chigoe Breeder は3〜4体で倒さなくてよい。Rune of Release は H-8）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のLageegeeに話して「ブラッドバス計画抑止作戦」を選び、だいじなもの「アサルト参加証・ペリキア」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Lageegee | K 皇国軍認識票
g03 go - | カダーバの浮沼(I-9)のドゥブッカ島監視哨へ行く | 六門院から飛べる。歩くときは、カダーバの浮沼(E-11)のNasheefaにアトルガン白銀貨を渡してアルザダール海底遺跡群を通り、ドゥブッカ島側に出て右の壁ぞいに進む。 | @カダーバの浮沼 I-9 #2
g04 talk - | 突入のリーダーになる人は、ドゥブッカ島監視哨のNahshibに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 I-9 #2 | T npc.79.Nahshib
g05 examine - | リーダーがドゥブッカ島監視哨のRunic Sealを調べて、ペリキアに突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 I-9 #2 | T obj.79.Runic_Seal | K アサルト参加証・ペリキア
g06 defeat - | ペリキアのAugmented Chigoeを35匹倒す | スタートは(H-8)。チゴーは弱く、クリティカルやウェポンスキルで1回で倒れる。ワイドスキャンに出ず、遠くからは名前も見えないので、通路・部屋・牢屋・檻の上やうしろまでていねいに歩いて探す。見落とすと時間が足りなくなる。 | @ペリキア | T mob.56.Augmented_Chigoe = mob:Augmented Chigoe!@ペリキア
g07 go - | （してもしなくてもよい）Chigoe Breeder（ラミア）をよける | 倒さなくてよい。インスニを見破り、倒してもすぐまた出る。ガ系や古代魔法が強いので、少ない人数で絡まれないようにする。 | @ペリキア
g08 examine - | （してもしなくてもよい）ペリキアのAncient Lockboxを開ける | | @ペリキア
g09 examine - | スタート(H-8)に出るペリキアのRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ペリキア H-8 | T obj.56.Rune_of_Release_H-8

@ mission.assault.032 https://wiki.ffo.jp/html/8804.html
Q Apkallu Seizure | アプカル捕獲指令 | yes | T npc.アトルガン白門.Bhoy_Yhupplo
MN - 32
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が軍曹以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績1,500＋アプカル捕獲数×500（最大4,000）（イルルシ環礁）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Apkallu_Seizure;S、30分、Lv.70。Fairy Apkallu を1羽以上 Clavauert B Chanoix へ連れて行く。??? を調べて Hamsi。アプカルの前に出て「じっと見つめた」と出たら /bow、警戒を少し解いたら /welcome、「好意を持っているようだ」と出たら話して Hamsi を渡す。捕まえたらすぐうしろへ回り、2〜3歩うしろについて行く。前に出たり、3秒ほど止まらせたり、Kelp Pugil を見せたりすると逃げる。Kelp Pugil はまた出ない。1羽連れて行くとすぐ Rune of Release（FFXIclopedia：Bhoy Yhupplo L-9/10。スタートと Clavauert B Chanoix は F-10。最後の岩場がいちばん難しい）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のBhoy Yhupploに話して「アプカル捕獲指令」を選び、だいじなもの「アサルト参加証・イルルシ環礁」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Bhoy_Yhupplo | K 皇国軍認識票
g03 go - | アラパゴ暗礁域(G-5)のイルルシ環礁監視哨へ行く | 六門院から飛べる。歩くととても遠く、監視哨の前にインプが多い。 | @アラパゴ暗礁域 G-5
g04 talk - | 突入のリーダーになる人は、イルルシ環礁監視哨のMeyaadaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @アラパゴ暗礁域 G-5 | T npc.54.Meyaada
g05 examine - | リーダーがイルルシ環礁監視哨のRunic Sealを調べて、イルルシ環礁に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @アラパゴ暗礁域 G-5 | T obj.54.Runic_Seal | K アサルト参加証・イルルシ環礁
g06 go - | （してもしなくてもよい）アプカルを連れて通る道のKelp Pugilを先に倒しておく | Kelp Pugilは弱く、また出ない。スニークでよけてもよい。連れているアプカルがKelp Pugilを見ると逃げる。 | @イルルシ環礁
g07 examine - | イルルシ環礁のどこかに出る???を調べて、ハムシーを手に入れる | スタート(F-10)にクラボエール男爵（Clavauert B Chanoix）がいる。ハムシーは1つしか持てない。???の場所は毎回ちがう。 | @イルルシ環礁
g08 go - | Fairy Apkalluを探して前に出て、「あなたをじっと見つめた」と出るのを待つ | アプカルは5羽いる。見つめられたら動かない。 | @イルルシ環礁 | T npc.55.Fairy_Apkallu = npc:Fairy Apkallu!@イルルシ環礁
g09 talk - | アプカルをターゲットしてエモーションを使い、警戒を解く | /bowのあと/welcomeと書く資料と、/welcome・/joy・/laugh・/wave・/smileなどちがうエモーションを交互に使うと書く資料がある。同じエモーションを続けたり/angryを使ったりすると逆効果。「好意を持っているようだ」（「興味を持っているようだ」と書く資料もある）と出るまでくり返す。 | @イルルシ環礁 | T npc.55.Fairy_Apkallu
g10 talk - | すぐにアプカルに話して、ハムシーを渡して捕まえる | うしろから話すと書く資料もある。捕まえたらアプカルはしばらく止まるので、すぐうしろに回る。 | @イルルシ環礁 | T npc.55.Fairy_Apkallu
g11 go - | アプカルのすぐうしろ（2〜3歩）について、スタート(F-10)の男爵のところまで行く | アプカルが自分で男爵のほうへ歩く。前に出たり、横にずれたり、離れすぎたりすると止まり、止まったままだと逃げる。逃げたらハムシーからやり直し。/followは段差で引っかかるので使わないほうがよい。最後の岩場がいちばん難しい。 | @イルルシ環礁 F-10
g12 go - | アプカルが男爵の前でさらに一歩進むまで、うしろについたまま待つ | 一歩進むと目標達成で、すぐ出口が出る。男爵やアプカルに話さなくてよい。 | @イルルシ環礁 F-10 | T npc.55.Clavauert_B_Chanoix = npc:Clavauert B Chanoix@イルルシ環礁 F-10
g13 go - | （してもしなくてもよい）時間まで、ほかのアプカルも同じように連れて来る | 多いほど作戦戦績が多い。 | @イルルシ環礁 | T npc.55.Fairy_Apkallu
g14 examine - | （してもしなくてもよい）イルルシ環礁のAncient Lockboxを開ける | | @イルルシ環礁
g15 examine - | 男爵のところ(F-10)に出るイルルシ環礁のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @イルルシ環礁 F-10 | T obj.55.Rune_of_Release_F-10 = obj:Rune of Release@イルルシ環礁 F-10


@ mission.assault.033 https://wiki.ffo.jp/html/6638.html
Q Azure Experiments | 青の治験 | yes | T npc.アトルガン白門.Yahsra
MN - 33
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が曹長以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,000（ルジャワン霊窟）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Azure_Experiments;SM、30分、Lv.70。Nareema に話すとランダムに組織を移植され、ラミアの組が4か所（西に2つ・南・東）のどこかに出る。組を倒したらまた Nareema に話す。4組倒すとスタート(G-7)に Rune of Release。東の組は一方通行の段差の下なので遠くから釣るとよい。Lamia Prosector（黒魔道士）は睡眠が効かない（FFXIclopedia：Yahsra L-10。組は北東の通路・南東の通路・西の北側・西の南側。倒した組はもう出ない。終わったあと Nareema と話す選択肢がある）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のYahsraに話して「青の治験」を選び、だいじなもの「アサルト参加証・ルジャワン霊窟」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Yahsra | K 皇国軍認識票
g03 go - | カダーバの浮沼(K-9)のアズーフ島監視哨へ行く | 六門院から飛べる。 | @カダーバの浮沼 K-9
g04 talk - | 突入のリーダーになる人は、アズーフ島監視哨のNareemaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 K-9 | T npc.79.Nareema
g05 examine - | リーダーがアズーフ島監視哨のRunic Sealを調べて、ルジャワン霊窟に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 K-9 | T obj.79.Runic_Seal | K アサルト参加証・ルジャワン霊窟
g06 talk - | スタート(G-7)のNareemaに話して、組織を移植してもらう | 移植されるのは、グゥーブーの筋組織（攻撃力アップ・スロウ）、ドラゴンフライの眼組織（命中アップ・攻撃力ダウン。ヘイストと書く資料もある）、オポオポの脳組織（ファストキャスト・最大MP半分）、ラプトルの骨組織（足が速くなる・最大HP半分）のどれかで、ランダム。Nareemaは最初に話した人についてくると書く資料もある。 | @ルジャワン霊窟 G-7 | T npc.69.Nareema = npc:Nareema!@ルジャワン霊窟
g07 defeat - | 移植のあとルジャワン霊窟のどこかに出るラミア（2〜3体）をすべて倒す | 出るのは4か所のどれか。ラミアは見て気づき、リンクする。回避が高い。黒魔道士のLamia Prosectorは睡眠・静寂が効かないので、リンクしたら先に倒す（石化は効く）。東の段差を降りるとスタートまで大回りになるので、遠くから釣るか、だれかを段差の上に残すとよい。 | @ルジャワン霊窟
g08 talk - | ラミアを倒したら、またNareemaに話して移植してもらう | 次のラミアがどこかに出る。倒した組はもう出ない。 | @ルジャワン霊窟 | T npc.69.Nareema
g09 defeat - | 新しく出たラミアをすべて倒す | | @ルジャワン霊窟
g10 talk - | 3回目もNareemaに話して移植してもらう | | @ルジャワン霊窟 | T npc.69.Nareema
g11 defeat - | 3組目のラミアをすべて倒す | | @ルジャワン霊窟
g12 talk - | 4回目もNareemaに話して移植してもらう | | @ルジャワン霊窟 | T npc.69.Nareema
g13 defeat - | 4組目のラミアをすべて倒す | 4組倒すと目標達成で、スタートに出口が出る。ラミアは合わせて10体と書く資料もある。 | @ルジャワン霊窟
g14 talk - | （してもしなくてもよい）終わったあとでNareemaに話す | 答えを選べるが、どれを選んでも結果は変わらない。 | @ルジャワン霊窟 | T npc.69.Nareema
g15 examine - | （してもしなくてもよい）ルジャワン霊窟のAncient Lockboxを開ける | | @ルジャワン霊窟
g16 examine - | スタート(G-7)に出るルジャワン霊窟のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ルジャワン霊窟 G-7 | T obj.69.Rune_of_Release_G-7 = obj:Rune of Release@ルジャワン霊窟 G-7

@ mission.assault.034 https://wiki.ffo.jp/html/8638.html
Q Blitzkrieg | 謝鱗祭襲撃作戦 | yes | T npc.アトルガン白門.Isdebaaq
MN - 34
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が曹長以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績2,000、第二波を倒すと2,200、捕虜を助けると400ふえる（マムージャ兵訓練所）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Blitzkrieg;SM、30分、Lv.70。弱いマムージャとペット（ジズ・ブガード・ラプトル・プーク）の群れを200匹倒すと Rune of Release。ペットを残してマムージャを多く倒すと NM の Bluethunder Kaqool Ja が出て、倒すと Blackscale Key。カギで (I-6) の檻の Lumaayu を出すと、さらに100匹が来る。最後の波に Festive Firedrake。Rune of Release は入ったところ（FFXIclopedia：Isdebaaq L-10。捕虜は北東のすみ。最初の125匹でほとんどマムージャを倒すと Bluethunder Kaqool Ja が出ることがある。HP 3500ほどで青魔法。とどめを刺した人がカギ。200匹のあとは終えてもよい。300匹で「敵を殲滅した」）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のIsdebaaqに話して「謝鱗祭襲撃作戦」を選び、だいじなもの「アサルト参加証・マムージャ兵訓練所」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Isdebaaq | K 皇国軍認識票
g03 go - | バフラウ段丘(H-11)のマムージャ監視哨へ行く | 六門院から飛べる。歩くときはマムークを通って、バフラウ段丘の小さい地図に出てから左の壁ぞいに南へ。 | @バフラウ段丘 H-11
g04 talk - | 突入のリーダーになる人は、マムージャ監視哨のDaswillに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @バフラウ段丘 H-11 | T npc.52.Daswill
g05 examine - | リーダーがマムージャ監視哨のRunic Sealを調べて、マムージャ兵訓練所に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @バフラウ段丘 H-11 | T obj.52.Runic_Seal | K アサルト参加証・マムージャ兵訓練所
g06 go - | スタート(I-10)で強化して待つ | 突入して1分ほどすると、敵がこちらへ押し寄せてくる。 | @マムージャ兵訓練所 I-10
g07 defeat - | 押し寄せるマムージャ・ブガード・プーク・ラプトル・ジズを、合わせて200匹倒す | 弱いが数が多く、同時に来るのは10匹ほど。範囲攻撃・ガ系・範囲ウェポンスキルがよく効く。ファランクスで受けるダメージがほとんどなくなる。5匹ごとに数が出る。倒すとテンポラリの薬が手に入ることがある。 | @マムージャ兵訓練所
g08 defeat - | （してもしなくてもよい）マムージャを多めに倒して、中央広場に出るBluethunder Kaqool Jaを倒し、蕃都の黒鱗のカギをもらう | 100匹の時点でマムージャを25匹以上倒していると出る（最初の125匹をほとんどマムージャにすると出ることがあると書く資料もある）。200匹倒すと消えるので、雑魚を1匹残しておく。HPは3500ほどで青魔法を使う。とどめを刺した人がカギをもらう。 | @マムージャ兵訓練所 | T mob.66.Bluethunder_Kaqool_Ja = mob:Bluethunder Kaqool Ja@マムージャ兵訓練所
g09 go - | 200匹倒して敵が止まり、スタート(I-10)にRune of Releaseが出るのを待つ | ここで目標達成。このまま出てもよい。 | @マムージャ兵訓練所 I-10
g10 talk - | （してもしなくてもよい）(I-6)の行き止まりの檻にいるLumaayuを、蕃都の黒鱗のカギで出す | 出すと第2陣（100匹ほど）が来るので、休むのは出す前に。 | @マムージャ兵訓練所 I-6 | T npc.66.Lumaayu = npc:Lumaayu@マムージャ兵訓練所 I-6
g11 go - | （してもしなくてもよい）第2陣を倒しながら、Lumaayuをスタート(I-10)まで連れて行く | LumaayuはHPがとても少ない。 | @マムージャ兵訓練所 I-10
g12 defeat - | （してもしなくてもよい）第2陣の最後に来るFestive Firedrakeを倒す | 倒すと作戦戦績が増える。 | @マムージャ兵訓練所 | T mob.66.Festive_Firedrake = mob:Festive Firedrake@マムージャ兵訓練所
g13 examine - | （してもしなくてもよい）マムージャ兵訓練所のAncient Lockboxを開ける | | @マムージャ兵訓練所
g14 examine - | スタート(I-10)に出るマムージャ兵訓練所のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @マムージャ兵訓練所 I-10 | T obj.66.Rune_of_Release_I-10 = obj:Rune of Release@マムージャ兵訓練所 I-10

@ mission.assault.035 https://wiki.ffo.jp/html/8802.html
Q Wamoura Farm Raid | ワモーラファーム襲撃作戦 | yes | T npc.アトルガン白門.Famad
MN - 35
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が曹長以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,000、成虫を倒した数だけ250ずつふえる（レベロス風穴）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Wamoura_Farm_Raid;SM、30分、Lv.70。ワモーラをすべて倒す。時間がたつと Wamouracampa のいくつかが Wamoura になる。Ranch Wamouracampa と Ranch Wamoura を全部倒すと (H-8) の南西に Rune of Release。ブレイズスパイクが強く、ディスペルが2回要ることもある（FFXIclopedia：Famad L-10。はじめは Ranch Wamouracampa 16匹で、1匹は北西・北東・北のまん中の通路の奥のどれかに出る。1〜3匹が Ranch Wamoura になる。どちらもMPがあってアスピルが効く。ワイドスキャンが役に立つ。Rune of Release はまん中）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のFamadに話して「ワモーラファーム襲撃作戦」を選び、だいじなもの「アサルト参加証・レベロス風穴」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Famad | K 皇国軍認識票
g03 go - | ゼオルム火山(K-6)のハルブーン監視哨へ行く | 六門院から飛べる。歩くときは、ハルブーンに入ってエスケプするとゼオルム火山(L-7)に出るので、(L-6)から西の通路を進む。 | @ゼオルム火山 K-6
g04 talk - | 突入のリーダーになる人は、ハルブーン監視哨のWaudeenに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @ゼオルム火山 K-6 | T npc.61.Waudeen
g05 examine - | リーダーがハルブーン監視哨のRunic Sealを調べて、レベロス風穴に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @ゼオルム火山 K-6 | T obj.61.Runic_Seal | K アサルト参加証・レベロス風穴
g06 defeat - | レベロス風穴のRanch Wamouracampa（幼虫）をすべて倒す | スタートは(I-9)。はじめは16匹とも17匹とも書く資料がある。1匹だけ出る場所が変わる（北の通路の奥のどこか）。北と南を行ったり来たりするので、ワイドスキャンで探すとよい。ブレイズスパイク（ヒートバリア）が強いので、ディスペルやフィナーレで消す。MPがあるのでアスピルも効く。 | @レベロス風穴 | T mob.63.Ranch_Wamouracampa = mob:Ranch Wamouracampa@レベロス風穴
g07 defeat - | 成虫になったRanch Wamouraがいれば、それもすべて倒す | 時間がたつと幼虫の1〜3匹ほどが成虫になる。成虫は幼虫よりずっと強い。成虫を倒すと作戦戦績が増える。 | @レベロス風穴 | T mob.63.Ranch_Wamoura = mob:Ranch Wamoura@レベロス風穴
g08 examine - | （してもしなくてもよい）レベロス風穴のAncient Lockboxを開ける | | @レベロス風穴
g09 examine - | ワモーラを全部倒すと(H-8)の南西に出るレベロス風穴のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @レベロス風穴 H-8 | T obj.63.Rune_of_Release_H-8

@ mission.assault.036 https://wiki.ffo.jp/html/8798.html
Q Defuse the Threat | 地雷原処理作戦 | yes | T npc.アトルガン白門.Lageegee
MN - 36
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が曹長以上
LK condition:募集要員はレベル60・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績1,800＋除去した地雷1つにつき200（ペリキア）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Defuse_the_Threat;SM、30分、Lv.60。かくれた Qiqirn Mine 15個を処理する。地雷は見えず、ワイドスキャンにも出ない。近づくとタイマーが動き、30秒のうちに見つける。「Kachink」のあとの点が少ないほど近く、「Kachink!」で地雷が出て、調べると除去。間に合わないと爆発して少しダメージ。15個が除去か爆発で片付くと H-9 に Rune of Release。全部爆発すると失敗。薄い壁の向こうからも動く。Qiqirn Miner はインビジでよけられる（FFXIclopedia：Lageegee L-10。入るのは H-9。全員がはじめから地雷探知機を持つ。(G-9) の橋の上からも動く。Qiqirn はにおいで追う。Rune of Release は H-9）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のLageegeeに話して「地雷原処理作戦」を選び、だいじなもの「アサルト参加証・ペリキア」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Lageegee | K 皇国軍認識票
g03 go - | カダーバの浮沼(I-9)のドゥブッカ島監視哨へ行く | 六門院から飛べる。歩くときは、カダーバの浮沼(E-11)のNasheefaにアトルガン白銀貨を渡してアルザダール海底遺跡群を通り、ドゥブッカ島側に出て右の壁ぞいに進む。 | @カダーバの浮沼 I-9 #2
g04 talk - | 突入のリーダーになる人は、ドゥブッカ島監視哨のNahshibに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 I-9 #2 | T npc.79.Nahshib
g05 examine - | リーダーがドゥブッカ島監視哨のRunic Sealを調べて、ペリキアに突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 I-9 #2 | T obj.79.Runic_Seal | K アサルト参加証・ペリキア
g06 go - | スタート(H-9)から、地雷探知機の音をたよりにペリキアの地雷を探して歩く | 地雷探知機は突入すると全員が持っている。地雷は見えず、ワイドスキャンにも出ない。南西・南・北東のあたりに散らばると書く資料もある。「カチッ」のあとの「…」が少なくなるほうへ進む。薄い壁の向こうや(G-9)の橋の上からも反応するので、まだ見ていない部屋のそばは気をつける。 | @ペリキア H-9
g07 go - | 「時限信管が作動したようだ……。」と出たら、30秒ほどのうちにまわりを少しずつ歩いて地雷を出す | 「カチッ！」と出たら止まって、1〜2歩動くと出る。離れると消える。 | @ペリキア
g08 examine - | 出た緑の名前のQiqirn Mineをすぐ調べて除去する | 間に合わないと爆発して少しダメージを受け、除去の数に入らない。/targetnpcを入れたマクロが便利。インビジのままだと調べられないので切っておく。 | @ペリキア | T obj.56.Qiqirn_Mine = obj:Qiqirn Mine!@ペリキア
g09 go - | （してもしなくてもよい）歩きまわるQiqirn Minerをインビジでよける | 倒してもしばらくするとまた出る。においで追ってくると書く資料もある。 | @ペリキア
g10 examine - | ほかの地雷も同じように探して、15個すべてを除去か爆発で片付ける | 15個が片付くと出口が出る。1個も除去できないと失敗。除去が多いほど作戦戦績が多い。2〜3個かたまっていることがあるので、確実に除去できるものから。 | @ペリキア | T obj.56.Qiqirn_Mine
g11 examine - | （してもしなくてもよい）ペリキアのAncient Lockboxを開ける | | @ペリキア
g12 examine - | スタート(H-9)に出るペリキアのRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ペリキア H-9 | T obj.56.Rune_of_Release_H-9 = obj:Rune of Release@ペリキア H-9

@ mission.assault.037 https://wiki.ffo.jp/html/8805.html
Q Lost and Found | 指輪捜索指令 | yes | T npc.アトルガン白門.Bhoy_Yhupplo
MN - 37
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が曹長以上
LK condition:募集要員はレベル60・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,000（イルルシ環礁）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Lost_and_Found;SM、30分、Lv.60。なくした指輪（Eye of Zahak）を探す。Tian Tian に話すとついてきて、また話すと近くの手がかりのことを言う。???（1歩ほどまで近づくと出る）を調べると、Kelp Crab・海草（グラビデ）・手がかり・なにもない、のどれか。手がかり1つで指輪にいちばん近い人、2つで方角、3つで距離を言う。みんなで散らばって絞りこむ。指輪を見つけるとスタートに Rune of Release（FFXIclopedia：Bhoy Yhupplo L-10。ほかの人が話すとその人についていく。船の両はしから出られる。クラーケンは音で気づくが範囲がせまい。Rune of Release は地図に H-8）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のBhoy Yhupploに話して「指輪捜索指令」を選び、だいじなもの「アサルト参加証・イルルシ環礁」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Bhoy_Yhupplo | K 皇国軍認識票
g03 go - | アラパゴ暗礁域(G-5)のイルルシ環礁監視哨へ行く | 六門院から飛べる。歩くととても遠く、監視哨の前にインプが多い。 | @アラパゴ暗礁域 G-5
g04 talk - | 突入のリーダーになる人は、イルルシ環礁監視哨のMeyaadaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @アラパゴ暗礁域 G-5 | T npc.54.Meyaada
g05 examine - | リーダーがイルルシ環礁監視哨のRunic Sealを調べて、イルルシ環礁に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @アラパゴ暗礁域 G-5 | T obj.54.Runic_Seal | K アサルト参加証・イルルシ環礁
g06 talk - | 入ってすぐのTian Tianに話して、ついて来てもらう | ほかの人が話すとその人についていく。船の両はしから出られる。 | @イルルシ環礁 H-8 I-9 | T npc.55.Tian_Tian = npc:Tian Tian!@イルルシ環礁
g07 talk - | 歩きながらTian Tianに話して、近くの???までの距離を聞く | 「ここには……たぶん、なにもないある……。」がいちばん遠く、「この近く……すぐ近くに、なにかあるね……。」がいちばん近い。手がかりがないうちは、指輪ではなく手がかりの???のことだけを言う。 | @イルルシ環礁 | T npc.55.Tian_Tian
g08 examine - | 近くでまわりを歩いて、出てきた???をすぐ調べる | ???は1歩くらいまで近づかないと出ず、離れると消える。手がかり（足跡・頭髪・指紋）、Kelp Crab、ヘヴィになる海草、なにもない、のどれか。 | @イルルシ環礁 | T obj.55.??? = obj:???!@イルルシ環礁
g09 defeat - | （してもしなくてもよい）???からKelp Crabが出たら倒す | 弱い。調べた人をねらってくる。 | @イルルシ環礁
g10 examine - | 手がかりが1つ見つかるまで、同じように???を探して調べる | 手がかり1つで、Tian Tianがパーティのだれが指輪にいちばん近いかを言うようになる。2つで方角、3つで距離もわかる。 | @イルルシ環礁 | T obj.55.???
g11 go - | 手がかりが見つかったら、みんなでエリアに散らばってTian Tianに話し、指輪に近い人のほうへしぼっていく | 外れの???を調べてから30秒ほどは、前の???のことを言うことがある。Kelp Kulshedraはスニークでよけられる。 | @イルルシ環礁 | T npc.55.Tian_Tian
g12 examine - | 指輪「ザッハークの眼」の???を見つけて調べると目標達成 | ほぼ真上に立たないと出ないので、みんなでゆっくり歩いて探す。 | @イルルシ環礁 | T obj.55.???
g13 examine - | （してもしなくてもよい）イルルシ環礁のAncient Lockboxを開ける | | @イルルシ環礁
g14 examine - | スタート(H-8 I-9)に出るイルルシ環礁のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @イルルシ環礁 H-8 I-9 | T obj.55.Rune_of_Release_H-8_I-9 = obj:Rune of Release@イルルシ環礁 H-8 I-9


@ mission.assault.038 https://wiki.ffo.jp/html/11354.html
Q Imperial Code | オグマ奪取指令 | yes | T npc.アトルガン白門.Yahsra
MN - 38
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が特務曹長以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績4,000（ルジャワン霊窟）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Imperial_Code;CS、30分、Lv.70。忍者の NM の Oko・Danzo・Saizo を倒す。倒したあとに ??? が出て、最後の1つがオグマ（OGMA）。取ると Rune of Release。Saizo は両手刀で微塵がくれ。Oko と Saizo の近くに Kusa がいる。Kudagitsune は近づくとすぐ Perdition（即死）。Rune of Release は下の層の G-8 と H-8 の境目で、上の層の穴の真下（FFXIclopedia：Yahsra L-10。入るのは南西のすみ G-10/H-10。Oko G-8、Danzo H-8、Saizo I-8。HP 4500ほど。オグマはいつも3体目。おすすめは Saizo・Oko・Danzo の順。Danzo のあと穴から落ちると下の層の G-8 に Rune of Release）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のYahsraに話して「オグマ奪取指令」を選び、だいじなもの「アサルト参加証・ルジャワン霊窟」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Yahsra | K 皇国軍認識票
g03 go - | カダーバの浮沼(K-9)のアズーフ島監視哨へ行く | 六門院から飛べる。 | @カダーバの浮沼 K-9
g04 talk - | 突入のリーダーになる人は、アズーフ島監視哨のNareemaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 K-9 | T npc.79.Nareema
g05 examine - | リーダーがアズーフ島監視哨のRunic Sealを調べて、ルジャワン霊窟に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 K-9 | T obj.79.Runic_Seal | K アサルト参加証・ルジャワン霊窟
g06 defeat - | Saizoのいる部屋(H-8 I-8)へ行き、Saizoを倒す | 入るのは南西のすみ(G-10 H-10)。道なりに進むとSaizo・Oko・Danzoの順になる。Saizoは両手刀で、HPが減ると微塵がくれを使う。近くのKusaを先に倒すか、離れたところへ釣る。Kudagitsuneは近づくとすぐ即死のパーディションを使うので、スニークでよけるか、離れて戦う（うしろへ走ると不発にできる）。 | @ルジャワン霊窟 H-8 I-8 | T mob.69.Saizo = mob:Saizo@ルジャワン霊窟 H-8 I-8
g07 defeat - | (G-8)の東西に長い部屋のOkoを倒す | 二刀流で、属性のついたウェポンスキルを使う。近くのKusaに気をつける。 | @ルジャワン霊窟 G-8 | T mob.69.Oko = mob:Oko@ルジャワン霊窟 G-8
g08 defeat - | 階段をのぼって、(H-8)の部屋のDanzoを倒す | 二刀流で、空蝉を抜ける多段のウェポンスキルを使う。 | @ルジャワン霊窟 H-8 | T mob.69.Danzo = mob:Danzo@ルジャワン霊窟 H-8
g09 examine - | 3体目を倒したところに出る???を調べて、暗号機「オグマ」を手に入れる | 1体目・2体目のあとに出る???はがらくた。3体目の???がオグマ。 | @ルジャワン霊窟 | T obj.69.??? = obj:???!@ルジャワン霊窟
g10 go - | Danzoの部屋の穴から下の層へ落ちる | 落ちたところにRune of Releaseが出ている。下にKusaがいることがある。 | @ルジャワン霊窟 G-8 H-8
g11 examine - | （してもしなくてもよい）ルジャワン霊窟のAncient Lockboxを開ける | | @ルジャワン霊窟
g12 examine - | 下の層(G-8 H-8)に出るルジャワン霊窟のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ルジャワン霊窟 G-8 H-8 | T obj.69.Rune_of_Release_G-8_H-8 = obj:Rune of Release@ルジャワン霊窟 G-8 H-8

@ mission.assault.039 https://wiki.ffo.jp/html/11356.html
Q Marids in the Mist | マーリドガーデン作戦 | yes | T npc.アトルガン白門.Isdebaaq
MN - 39
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が特務曹長以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績4,000、倒したマーリドの数だけ減る（マムージャ兵訓練所）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Marids_in_the_Mist;CS、30分、Lv.70。Marid 8体を倒すか捕まえる。捕まえたほうが作戦戦績が多い。スタートの Zimahd に話すと Thunderguard Dart（テンポラリ）をもらえ、何度でももらえる。1人1本まで。Marid の TP が0（ウェポンスキルのすぐあと）でHPが半分より少ないときに使うと、ほぼ捕まえられる。Marid はTP技を使うと Chigoe を1匹出す。8体片付くと (I-9) の南西に Rune of Release。マムージャはインビジでよけられる（FFXIclopedia：Isdebaaq L-10。スタートは南東の下のトンネル。1部屋に2体。Marid は足がおそく、睡眠・グラビデ・バインドが効く。Dart を使うと2〜3秒すべて効かなくなる。外れると暴れ出す（眠らせておくと起きない）。G-9/H-9 のトンネルは東にしか行けない）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のIsdebaaqに話して「マーリドガーデン作戦」を選び、だいじなもの「アサルト参加証・マムージャ兵訓練所」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Isdebaaq | K 皇国軍認識票
g03 go - | バフラウ段丘(H-11)のマムージャ監視哨へ行く | 六門院から飛べる。歩くときはマムークを通って、バフラウ段丘の小さい地図に出てから左の壁ぞいに南へ。 | @バフラウ段丘 H-11
g04 talk - | 突入のリーダーになる人は、マムージャ監視哨のDaswillに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @バフラウ段丘 H-11 | T npc.52.Daswill
g05 examine - | リーダーがマムージャ監視哨のRunic Sealを調べて、マムージャ兵訓練所に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @バフラウ段丘 H-11 | T obj.52.Runic_Seal | K アサルト参加証・マムージャ兵訓練所
g06 talk - | スタート(I-10)のZimahdに話して、テンポラリアイテムの雷公麻酔鍼をもらう | 1人1本まで持てて、何度でももらえる。帰巣蛍のすぐ下に入るので、まちがえて使わないように。 | @マムージャ兵訓練所 I-10 | T npc.66.Zimahd = npc:Zimahd@マムージャ兵訓練所 I-10
g07 defeat - | Maridと戦い、HPを半分より少なくしてから雷公麻酔鍼を使って捕まえる | 1部屋に2体いる。Maridは足がおそいので、Zimahdの近くまで釣ってくるとよい。ウェポンスキルのすぐあと（TPが0のとき）で、HPが少ないほど捕まえやすい。「立ったまま眠りだした」で成功、「平然としている」は外れ、「折れてしまった」は暴れ出す（眠らせておくと暴れないと書く資料もある）。何人かで同時に使っても効かない。倒してもよいが、作戦戦績が減る。 | @マムージャ兵訓練所 | T mob.66.Marid = mob:Marid!@マムージャ兵訓練所
g08 defeat - | （してもしなくてもよい）Maridがウェポンスキルのあとに出すChigoeを倒す | クリティカルやジャンプ、シールドバッシュで1回で倒れる。 | @マムージャ兵訓練所
g09 talk - | 使った雷公麻酔鍼は、Zimahdに話してまたもらう | 当たっても外れても、使った鍼はなくなる。 | @マムージャ兵訓練所 I-10 | T npc.66.Zimahd
g10 defeat - | 残りのMaridも同じように捕まえるか倒して、8体すべてを片付ける | マムージャは目標に関係ないので、インビジでよけるとよい。(G-9 H-9)のトンネルは東にしか通れないと書く資料もある。 | @マムージャ兵訓練所
g11 examine - | （してもしなくてもよい）マムージャ兵訓練所のAncient Lockboxを開ける | | @マムージャ兵訓練所
g12 examine - | (I-9)の南西に出るマムージャ兵訓練所のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @マムージャ兵訓練所 I-9 | T obj.66.Rune_of_Release_I-9 = obj:Rune of Release@マムージャ兵訓練所 I-9

@ mission.assault.040 https://wiki.ffo.jp/html/11359.html
Q Egg Conservation | ハンターキラー作戦 | yes | T npc.アトルガン白門.Famad
MN - 40
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が特務曹長以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績4,000、気絶した雌1羽につき400減る（レベロス風穴）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Egg_Conservation;CS、30分、Lv.70。アプカルを回復しながらキキルンを倒す。小さいのがメスで戦わない。メスが全部倒れると失敗。大きいオスは近くのキキルンを攻撃し、HPが半分を切ると倒れて戦わなくなる。キキルンは東と西から1〜2匹ずつ来る。15匹倒すと (I-8) に Rune of Release。Qiqirn Eggler は回避が高く、攻撃が速い（FFXIclopedia：Famad L-10。はじめは大きな部屋で、Rune of Release ははじめにいる Rhap Nelhah の横。アプカルは強化・回復ができて、ヘイトがたまらない。キキルンは睡眠・グラビデ・バインド・スタンが効かない。キキルンはペットにも向かう）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のFamadに話して「ハンターキラー作戦」を選び、だいじなもの「アサルト参加証・レベロス風穴」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Famad | K 皇国軍認識票
g03 go - | ゼオルム火山(K-6)のハルブーン監視哨へ行く | 六門院から飛べる。歩くときは、ハルブーンに入ってエスケプするとゼオルム火山(L-7)に出るので、(L-6)から西の通路を進む。 | @ゼオルム火山 K-6
g04 talk - | 突入のリーダーになる人は、ハルブーン監視哨のWaudeenに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @ゼオルム火山 K-6 | T npc.61.Waudeen
g05 examine - | リーダーがハルブーン監視哨のRunic Sealを調べて、レベロス風穴に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @ゼオルム火山 K-6 | T obj.61.Runic_Seal | K アサルト参加証・レベロス風穴
g06 go - | スタート(I-8)の広場で、アプカルのそばで待つ | 小さいのがメス（守る相手）、大きいのがオスで、オスは近くのキキルンと戦ってくれる。アプカルは強化・回復ができ、回復してもヘイトがたまらない。 | @レベロス風穴 I-8
g07 defeat - | 東と西から来るQiqirn Egglerを、合わせて15匹倒す | はじめからいるのもいて、時間とともに東西に出て広場へ向かってくる。ワイドスキャンで探せる。広場のまん中で戦うとオスが手伝ってくれる。回避が高く攻撃が速く、睡眠が効きにくい。 | @レベロス風穴 | T mob.63.Qiqirn_Eggler = mob:Qiqirn Eggler@レベロス風穴
g08 go - | （してもしなくてもよい）メスのアプカルのHPを回復して守る | 広場に着いたキキルンはメスを攻撃し、倒れると気絶する。気絶したメスが多いほど作戦戦績が減り、メスが全部倒れると失敗。オスはHPが半分ほどになると倒れて戦わなくなる。 | @レベロス風穴 I-8
g09 examine - | （してもしなくてもよい）レベロス風穴のAncient Lockboxを開ける | | @レベロス風穴
g10 examine - | 15匹倒すと出るスタート(I-8)のレベロス風穴のRune of Releaseを調べて外に出ると完了 | 「キキルンたちは逃走し始めた。」と出て、残りのキキルンは消える。帰ったら公務代理店で報告して参加証を返しておく。 | @レベロス風穴 I-8 | T obj.63.Rune_of_Release_I-8

@ mission.assault.041 https://wiki.ffo.jp/html/11375.html
Q Operation: Snake Eyes | 双頭の蛇作戦 | yes | T npc.アトルガン白門.Lageegee
MN - 41
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が特務曹長以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績4,000（ペリキア）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Operation:_Snake_Eyes;CS、30分、Lv.70。スタート (I-9) のまわりの Qutrub 5体を倒すと北の扉が開く。北の6つの部屋のどこかで Merrow No.16 が Karazahm と戦っているので、Karazahm を死なせずに倒す（どちらもワイドスキャンに出ない）。(I-6) の Lamia No.14 を倒すと北の扉が開く。ベリーダンスは目で見る範囲の魅了。(H-6) の Umarid と戦い、HPを半分より少なくすると Lamia No.17 が出る。Umarid を倒すと失敗。Lamia No.17 を倒すと (I-5) に Rune of Release（FFXIclopedia：Lageegee L-10。Qutrub は H-9 の南西・北西・北東に2体・I-9 の北の扉のそば。Karazahm が倒れると失敗。Karazahm は回復できる。全員が魅了されると Lamia No.14 が扉の先へ連れて行く。Lamia No.14 は倒すと少しして扉が開く。Umarid は H-6 の北、HP 3600ほどで、30〜50%ほど減らす。Rune of Release は I-5）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のLageegeeに話して「双頭の蛇作戦」を選び、だいじなもの「アサルト参加証・ペリキア」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Lageegee | K 皇国軍認識票
g03 go - | カダーバの浮沼(I-9)のドゥブッカ島監視哨へ行く | 六門院から飛べる。歩くときは、カダーバの浮沼(E-11)のNasheefaにアトルガン白銀貨を渡してアルザダール海底遺跡群を通り、ドゥブッカ島側に出て右の壁ぞいに進む。 | @カダーバの浮沼 I-9 #2
g04 talk - | 突入のリーダーになる人は、ドゥブッカ島監視哨のNahshibに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 I-9 #2 | T npc.79.Nahshib
g05 examine - | リーダーがドゥブッカ島監視哨のRunic Sealを調べて、ペリキアに突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 I-9 #2 | T obj.79.Runic_Seal | K アサルト参加証・ペリキア
g06 defeat - | スタート(I-9)のまわりのQutrubを5体倒して、北の扉を開ける | (H-9)の南西・北西・北東（2体）と、(I-9)の北の扉のそばにいると書く資料もある。 | @ペリキア I-9 | T mob.56.Qutrub = mob:Qutrub@ペリキア
g07 go - | 北の6つの小部屋を見て回り、Merrow No.16と戦っているKarazahmを探す | ワイドスキャンには出ないので、1部屋ずつ見る。どの部屋かは毎回ちがう。ラミアは見て気づくのでインビジでよけるとよい。 | @ペリキア | T npc.56.Karazahm = npc:Karazahm!@ペリキア
g08 defeat - | Karazahmが倒れる前にMerrow No.16を倒す | Karazahmが倒れると失敗。Karazahmは回復できる。 | @ペリキア | T mob.56.Merrow_No16 = mob:Merrow No.16@ペリキア
g09 talk - | （してもしなくてもよい）助けたKarazahmに話す | | @ペリキア | T npc.56.Karazahm
g10 defeat - | さらに北の扉(I-6)の近くのLamia No.14を倒して、扉を開ける | ベリーダンスは目で見る範囲の魅了なので、背を向けるとよけられる。全員が魅了されると、扉の先へ連れて行かれるので、それで先へ進んでもよい。倒すと少しして扉が開く。 | @ペリキア I-6 | T mob.56.Lamia_No14 = mob:Lamia No.14@ペリキア I-6
g11 go - | 奥の部屋(H-6)のUmaridと戦い、倒さないようにHPを半分ほどまで減らす | Umaridは魅了されて敵になっている。倒すと失敗なので、強いウェポンスキルや弱い武器に気をつける。スリプルは効かない。 | @ペリキア H-6 | T npc.56.Umarid = npc:Umarid@ペリキア H-6
g12 defeat - | 出てきたLamia No.17を倒す | 出たあともUmaridは攻撃してくるので、だれかが引きつけておく。倒すとUmaridが正気にもどって目標達成。 | @ペリキア H-6 | T mob.56.Lamia_No17 = mob:Lamia No.17@ペリキア
g13 examine - | （してもしなくてもよい）ペリキアのAncient Lockboxを開ける | | @ペリキア
g14 examine - | いちばん北(I-5)に出るペリキアのRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ペリキア I-5 | T obj.56.Rune_of_Release_I-5 = obj:Rune of Release@ペリキア I-5

@ mission.assault.042 https://wiki.ffo.jp/html/11376.html
Q Deserter | 脱走兵武装解除指令 | yes | T npc.アトルガン白門.Bhoy_Yhupplo
MN - 42
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が特務曹長以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績は武装解除1匹300、倒すと100（最大3,600）（イルルシ環礁）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Deserter;CS、30分、Lv.70。ラミアかメローを1匹以上、武器を壊して降参させる。クリティカルやクリティカルのウェポンスキルで壊れることがある。壊すとすぐ降参してNPCになる。ラミアとメローは12匹。1匹降参させたあとは、スタートのNPCに話していつでも終われる。12匹全部を倒すか降参させると、1匹以上降参していれば Rune of Release が自動で出る。Rune of Release はスタートのNPCのところ（FFXIclopedia：Bhoy Yhupplo L-10。スタートは (H-9) の Raubahn の横。シールドバッシュなどでも壊せる。倒すと1匹ごとに120減る。1匹倒すか降参させれば勝てる。Raubahn に話して「やめる」で「はい」を選ぶと Rune of Release）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のBhoy Yhupploに話して「脱走兵武装解除指令」を選び、だいじなもの「アサルト参加証・イルルシ環礁」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Bhoy_Yhupplo | K 皇国軍認識票
g03 go - | アラパゴ暗礁域(G-5)のイルルシ環礁監視哨へ行く | 六門院から飛べる。歩くととても遠く、監視哨の前にインプが多い。 | @アラパゴ暗礁域 G-5
g04 talk - | 突入のリーダーになる人は、イルルシ環礁監視哨のMeyaadaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @アラパゴ暗礁域 G-5 | T npc.54.Meyaada
g05 examine - | リーダーがイルルシ環礁監視哨のRunic Sealを調べて、イルルシ環礁に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @アラパゴ暗礁域 G-5 | T obj.54.Runic_Seal | K アサルト参加証・イルルシ環礁
g06 talk - | （してもしなくてもよい）スタート(H-9)のRaubahnに話して、作戦の説明を聞く | 倒さずに武器を壊して捕まえるように言われる。 | @イルルシ環礁 H-9 | T npc.55.Raubahn = npc:Raubahn@イルルシ環礁 H-9
g07 defeat - | 東のメロー・西のラミアと戦い、武器を壊して降参させる | メローは東に6匹、ラミアは西に6匹と書く資料もある。武器はクリティカル・ウェポンスキル・シールドバッシュ・ウェポンバッシュ・ボックスステップ・D.フラリッシュで壊れる（不意打ち・だまし討ちでは壊れない）。壊すと「武器を捨てた」と出てNPCになり、戦いが終わる。弱い武器でクリティカルを多く出すとよい。倒しても数に入るが、作戦戦績が少ない。 | @イルルシ環礁
g08 defeat - | （してもしなくてもよい）時間まで、ほかのラミア・メローも同じように降参させる | 12匹全部を降参させるか倒すと、出口が自動で出る（1匹以上降参していれば）。ドラウガーは目標に関係なく、命で気づくので近くで戦わない。 | @イルルシ環礁
g09 talk - | スタート(H-9)のRaubahnに話して「任務を放棄する」を選び、作戦を終える | 1匹以上降参させるか倒していれば、ここで終われる。12匹片付けて出口が出ているときはそのまま次へ。 | @イルルシ環礁 H-9 | T npc.55.Raubahn
g10 examine - | （してもしなくてもよい）イルルシ環礁のAncient Lockboxを開ける | | @イルルシ環礁
g11 examine - | Raubahnのところ(H-9)に出るイルルシ環礁のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @イルルシ環礁 H-9 | T obj.55.Rune_of_Release_H-9 = obj:Rune of Release@イルルシ環礁 H-9


@ mission.assault.043 https://wiki.ffo.jp/html/12312.html
Q Red Versus Blue | 不滅隊・魔滅隊合同演習 | yes | T npc.アトルガン白門.Yahsra
MN - 43
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が少尉以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績5,000、魔滅隊員が1人倒されるごとに200減る（ルジャワン霊窟）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Red_Versus_Blue;30分、Lv.70。目標は Raubahn を倒すこと。はじめの隊長の NPC に話すまで青軍と Raubahn は出ない。Raubahn たちは (I-6) の上に出る。隊長の Shailham が倒されるとすぐ失敗。味方が倒されるごとに作戦戦績が減る。味方は黒魔道士、青軍は青魔道士（FFXIclopedia：Yahsra L-10。スタートは (G-9)。Shailham に話すと始まる。青軍の出かたは4とおり。青魔道士は睡眠が効かないが、Raubahn は効く。Raubahn は HP 3000ほどで、倒すと残りの敵は消える。Rune of Release はスタートの (G-9)）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のYahsraに話して「不滅隊・魔滅隊合同演習」を選び、だいじなもの「アサルト参加証・ルジャワン霊窟」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Yahsra | K 皇国軍認識票
g03 go - | カダーバの浮沼(K-9)のアズーフ島監視哨へ行く | 六門院から飛べる。 | @カダーバの浮沼 K-9
g04 talk - | 突入のリーダーになる人は、アズーフ島監視哨のNareemaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 K-9 | T npc.79.Nareema
g05 examine - | リーダーがアズーフ島監視哨のRunic Sealを調べて、ルジャワン霊窟に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 K-9 | T obj.79.Runic_Seal | K アサルト参加証・ルジャワン霊窟
g06 talk - | スタート(G-9)のShailhamに話して、演習を始める | 話すと青軍（不滅隊）が出てくる。Shailhamが倒されると失敗。 | @ルジャワン霊窟 G-9 | T npc.69.Shailham = npc:Shailham@ルジャワン霊窟 G-9
g07 go - | （してもしなくてもよい）味方の黒魔道士たちについて行き、青軍の青魔道士から守る | 味方が1人倒されるたびに作戦戦績が減る。青軍の出かたは毎回ちがう。しばらくするとShailhamのうしろに奇襲部隊が出ると書く資料もあるので、1〜2人はShailhamのそばに残すとよい。 | @ルジャワン霊窟
g08 defeat - | 北(I-6)の上に出るRaubahnを倒す | 青軍の大将で、攻撃が強い。まわりの青魔道士は睡眠が効かないが、Raubahnには効く。倒すと残りの青軍は消える。 | @ルジャワン霊窟 I-6 | T mob.69.Raubahn = mob:Raubahn@ルジャワン霊窟 I-6
g09 examine - | （してもしなくてもよい）ルジャワン霊窟のAncient Lockboxを開ける | | @ルジャワン霊窟
g10 examine - | スタート(G-9)に出るルジャワン霊窟のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ルジャワン霊窟 G-9 | T obj.69.Rune_of_Release_G-9 = obj:Rune of Release@ルジャワン霊窟 G-9

@ mission.assault.044 https://wiki.ffo.jp/html/12314.html
Q Azure Ailments | 青の症例 | yes | T npc.アトルガン白門.Isdebaaq
MN - 44
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が少尉以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績1,500＋症例数×300（最大3,600）（マムージャ兵訓練所）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Azure_Ailments;30分、Lv.70。敵からステータス異常をもらい、(H-8) の Soulflayer Garjham に話して報告する。3つ報告して Garjham にもう一度話すと Rune of Release。アムネジア（Qiqirn Huckster）、バイオ（Poroggo）、病気（Pit Lindwurm）、スロウ（Huge Spider・Pit Lindwurm）、STRダウン（Bugard）、攻撃力ダウン（Leech）、回避率ダウン（Slavering Lizard）。Mamool Ja はステータス異常をくれず、インビジでよけられる（FFXIclopedia：Isdebaaq L-10。Garjham は (H-8) のスタートの NPC。1つずつ報告してよく、だれが報告してもよいが、同じものは数えない。3つ報告したあと Garjham にもう一度話すと終わる。ラプトル・スパイダー・キキルンは東、リーチは北、ブガードは西、トカゲは南）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のIsdebaaqに話して「青の症例」を選び、だいじなもの「アサルト参加証・マムージャ兵訓練所」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Isdebaaq | K 皇国軍認識票
g03 go - | バフラウ段丘(H-11)のマムージャ監視哨へ行く | 六門院から飛べる。歩くときはマムークを通って、バフラウ段丘の小さい地図に出てから左の壁ぞいに南へ。 | @バフラウ段丘 H-11
g04 talk - | 突入のリーダーになる人は、マムージャ監視哨のDaswillに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @バフラウ段丘 H-11 | T npc.52.Daswill
g05 examine - | リーダーがマムージャ監視哨のRunic Sealを調べて、マムージャ兵訓練所に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @バフラウ段丘 H-11 | T obj.52.Runic_Seal | K アサルト参加証・マムージャ兵訓練所
g06 go - | まわりの敵と戦い、決められたステータス異常を1つもらう | 7つのうちどれでもよい：アムネジア（Qiqirn Huckster）、バイオ（Poroggo）、病気（Pit Lindwurm）、スロウ（Huge Spider・Pit Lindwurm）、STRダウン（Bugard）、攻撃力ダウン（Leech）、回避率ダウン（Slavering Lizard）。リーチは北、ラプトル・スパイダー・キキルンは東、ブガードは西、トカゲは南と書く資料もある。Mamool Ja Warderは何もくれない。空蝉やヘイストがあると防いでしまう。 | @マムージャ兵訓練所
g07 talk - | 治さずにスタート(H-8)のGarjhamに話して、1つ目の症例を報告する | 報告はステータス異常になった人ならだれでもよい。同じ症例は2回数えない。 | @マムージャ兵訓練所 H-8 | T npc.66.Garjham = npc:Garjham@マムージャ兵訓練所 H-8
g08 go - | ちがうステータス異常をもう1つもらう | アムネジアは短いので、Garjhamの近くまで連れてきて戦うとよい。 | @マムージャ兵訓練所
g09 talk - | Garjhamに話して、2つ目の症例を報告する | | @マムージャ兵訓練所 H-8 | T npc.66.Garjham
g10 go - | ちがうステータス異常をもう1つもらう | 外でもらってきたステータス異常も数えると書く資料もある。 | @マムージャ兵訓練所
g11 talk - | Garjhamに話して3つ目の症例を報告する（Rune of Releaseが出ないときはもう一度話す） | 3つ報告するとRune of Releaseが出ると書く資料と、そのあともう一度話すと書く資料がある。 | @マムージャ兵訓練所 H-8 | T npc.66.Garjham
g12 talk - | （してもしなくてもよい）4つ目からの症例もGarjhamに報告する | 報告が多いほど作戦戦績が増える（最大3,600）。 | @マムージャ兵訓練所 H-8 | T npc.66.Garjham
g13 examine - | （してもしなくてもよい）マムージャ兵訓練所のAncient Lockboxを開ける | | @マムージャ兵訓練所
g14 examine - | スタート(H-8)に出るマムージャ兵訓練所のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @マムージャ兵訓練所 H-8 | T obj.66.Rune_of_Release_H-8 = obj:Rune of Release@マムージャ兵訓練所 H-8

@ mission.assault.045 https://wiki.ffo.jp/html/12318.html
Q Operation: Black Pearl | ブラックパール作戦 | yes | T npc.アトルガン白門.Famad
MN - 45
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が少尉以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績4,200、倒されたNPC1人につき400減る（レベロス風穴）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Operation:_Black_Pearl;30分、Lv.70。Princess Kadjaya と Whyjham を、Jorporbor the Hellraker を倒すまで1回も攻撃させない。Kadjaya が攻撃されると失敗。敵は3つの通路から2組ずつ来て、Wamouracampa・Crimson Eruca・Vulcanian Bomb が5匹ずつ、最後に Troll Combatant。トロールを倒すと次の組が出る。通路の見張りは Yanshaal・Djahama・Kudjreel で、残った数で作戦戦績が変わる。何組か倒すと Jorporbor the Hellraker が来る。倒すと残りの敵は消え、Kadjaya のところに Rune of Release（FFXIclopedia：Famad L-10。スタートは (G-7)。まん中の NPC に話すと敵が来はじめる。ボムはファイアIV・フレア。トロール以外は睡眠がほとんど効かない。メッセージが出たらすぐまん中へもどる）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のFamadに話して「ブラックパール作戦」を選び、だいじなもの「アサルト参加証・レベロス風穴」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Famad | K 皇国軍認識票
g03 go - | ゼオルム火山(K-6)のハルブーン監視哨へ行く | 六門院から飛べる。歩くときは、ハルブーンに入ってエスケプするとゼオルム火山(L-7)に出るので、(L-6)から西の通路を進む。 | @ゼオルム火山 K-6
g04 talk - | 突入のリーダーになる人は、ハルブーン監視哨のWaudeenに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @ゼオルム火山 K-6 | T npc.61.Waudeen
g05 examine - | リーダーがハルブーン監視哨のRunic Sealを調べて、レベロス風穴に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @ゼオルム火山 K-6 | T obj.61.Runic_Seal | K アサルト参加証・レベロス風穴
g06 talk - | スタート(G-7)のまん中にいるKadjayaに話す | まん中のNPCに話すと敵が来はじめると書く資料もある。Kadjaya（姫）は1回でも攻撃されると失敗。そばに執事のWhyjhamもいる。 | @レベロス風穴 G-7 | T npc.63.Kadjaya = npc:Kadjaya@レベロス風穴 G-7
g07 defeat - | 3つの通路から来る敵（Wamouracampa・Crimson Eruca・Vulcanian Bombが5匹ずつ、最後にTroll Combatant）を倒す | 2組が同時に来る。トロール以外はHPが少なく、範囲攻撃で倒せる。ボムはファイアIV・フレアを使う。トロールを倒すと次の組が来るので、1匹寝かせておくと1組ずつ相手にできる。 | @レベロス風穴
g08 go - | （してもしなくてもよい）通路の見張りのYanshaal・Djahama・Kudjreelを守る | 1〜2回攻撃されると倒れ、倒されるほど作戦戦績が減る。見張りの前で待って、敵を先に引きつけるとよい。 | @レベロス風穴
g09 go - | 何組か倒して姫のせりふが出たら、すぐまん中のKadjayaのところへもどる | 3組目のトロールを倒すと来ると書く資料もある。 | @レベロス風穴 G-7
g10 defeat - | 姫をねらって走ってくるJorporbor the Hellrakerを倒す | 暗黒騎士で攻撃が強い。とても速く走ってくるので、姫に届く前に敵対心を取る。あとから雑魚の組も来る。倒すと残りの敵は消える。 | @レベロス風穴 G-7 | T mob.63.Jorporbor_the_Hellraker = mob:Jorporbor the Hellraker!@レベロス風穴
g11 examine - | （してもしなくてもよい）レベロス風穴のAncient Lockboxを開ける | | @レベロス風穴
g12 examine - | Kadjayaのところ(G-7)に出るレベロス風穴のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @レベロス風穴 G-7 | T obj.63.Rune_of_Release_G-7

@ mission.assault.046 https://wiki.ffo.jp/html/12316.html
Q Wake the Puppet | 人形の目覚め作戦 | yes | T npc.アトルガン白門.Lageegee
MN - 46
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が少尉以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績1,800＋マイムン回収数×300（3,000〜3,600）（ペリキア）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Wake_the_Puppet;30分、Lv.70。スタートの NPC の Adeeha のところへパペットを4体以上もどす。パペットは (H-6)・(F-8)・(J-8)・(H-10) の行き止まりの部屋に出て、3つの部屋に2体ずつ、1つは空。/salute で起動、/clap でついてくる、/goodbye で止める（Adeeha の近くで止めると名前が緑になり回収）、/hurray で戦う。同じ動作をくりかえしたら、決まったエモーションで直す。Wight はパペットを起動すると出て、パペットをねらう。4体で Rune of Release、6体まで作戦戦績が増える（FFXIclopedia：Lageegee L-10。スタートは (H-8)。Adeeha に話すと動かし方を教えてくれる。/clap は10より近くで。Rune of Release は (H-8)）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のLageegeeに話して「人形の目覚め作戦」を選び、だいじなもの「アサルト参加証・ペリキア」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Lageegee | K 皇国軍認識票
g03 go - | カダーバの浮沼(I-9)のドゥブッカ島監視哨へ行く | 六門院から飛べる。歩くときは、カダーバの浮沼(E-11)のNasheefaにアトルガン白銀貨を渡してアルザダール海底遺跡群を通り、ドゥブッカ島側に出て右の壁ぞいに進む。 | @カダーバの浮沼 I-9 #2
g04 talk - | 突入のリーダーになる人は、ドゥブッカ島監視哨のNahshibに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 I-9 #2 | T npc.79.Nahshib
g05 examine - | リーダーがドゥブッカ島監視哨のRunic Sealを調べて、ペリキアに突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 I-9 #2 | T obj.79.Runic_Seal | K アサルト参加証・ペリキア
g06 talk - | （してもしなくてもよい）スタート(H-8)のAdeehaに話して、マイムンの動かし方を聞く | /saluteで起動、/clapでついてくる、/hurrayで戦う、/goodbyeで止める。 | @ペリキア H-8 | T npc.56.Adeeha = npc:Adeeha@ペリキア H-8
g07 go - | 4つの小部屋(H-6・F-8・J-8・H-10)を見て、止まっているマイムンを探す | 6体いて、3つの部屋に2体ずつ、1つの部屋は空と書く資料もある。牢屋の中も見る。 | @ペリキア
g08 go - | マイムンの近くで/saluteをして起動する | 1人が動かせるのは1体だけ。起動するとWightが出てきて、マイムンをねらう。 | @ペリキア
g09 go - | /clapでマイムンを呼びながら、スタート(H-8)のAdeehaのところへ連れて行く | /clapはすぐ近くでないと聞かない。とちゅうで同じ動作をくりかえして止まったら、エモーションで直す（お辞儀 /kneel、指を指す /no、手を振る /welcome、踊る /joy、恥ずかしがる /doze、敬礼 /praise、喜ぶ /smile、混乱 /slap、ショック /comfort、賞賛 /blush、拍手 /angry、勝ちどき /psych）。戦っているマイムンは止まらないので、Wightに敵対心を乗せて/hurrayで戦わせ、そのままWightを連れてくるとよい。 | @ペリキア H-8
g10 defeat - | （してもしなくてもよい）マイムンをねらうWightを倒す | Wightは自分からPCには来ない。 | @ペリキア
g11 go - | Adeehaのすぐ近くで/goodbyeをして、マイムンを止める | 名前が緑になれば回収できている。Adeehaから遠いと数えない。 | @ペリキア H-8 | T npc.56.Adeeha
g12 go - | 同じようにして、合わせて4体のマイムンを回収する | 4体でRune of Releaseが出る。 | @ペリキア
g13 go - | （してもしなくてもよい）5体目・6体目のマイムンも回収する | 多いほど作戦戦績が増える。 | @ペリキア
g14 examine - | （してもしなくてもよい）ペリキアのAncient Lockboxを開ける | | @ペリキア
g15 examine - | スタート(H-8)に出るペリキアのRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ペリキア H-8 | T obj.56.Rune_of_Release_H-8

@ mission.assault.047 https://wiki.ffo.jp/html/12317.html
Q Desperately Seeking Cephalopods | 鱆号作戦 | yes | T npc.アトルガン白門.Bhoy_Yhupplo
MN - 47
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が少尉以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績3,000（イルルシ環礁）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Desperately_Seeking_Cephalopods;30分、Lv.70。釣りで Orobon（NM）を釣って倒し、手に入るものをスタートの NPC に渡す。釣りスキルはいらない。Qiqirn Pecheur は Willow Fishing Rod か Fly Lure を落とす。どこで釣っても Orobon・Pugil・Crab・Kraken のどれかがかかる。Orobon は決まった場所でしか釣れない。4人の海兵は、4〜5匹釣ったあと話が変わり、1人だけが「いい場所」と言う。さらに釣ると場所をくわしく言う。とどめをさした人が ahtapot をもらう（FFXIclopedia：Bhoy Yhupplo L-10。ahtapot を Ulbuun に持って行く。Bhjaama G-8、Walagarim H-7、Zawahf I-8、Zshahda I-9。Qiqirn Pecheur は見て気づく。Orobon は静寂・睡眠の技があり、睡眠が効く）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のBhoy Yhupploに話して「鱆号作戦」を選び、だいじなもの「アサルト参加証・イルルシ環礁」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Bhoy_Yhupplo | K 皇国軍認識票
g03 go - | アラパゴ暗礁域(G-5)のイルルシ環礁監視哨へ行く | 六門院から飛べる。歩くととても遠く、監視哨の前にインプが多い。 | @アラパゴ暗礁域 G-5
g04 talk - | 突入のリーダーになる人は、イルルシ環礁監視哨のMeyaadaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @アラパゴ暗礁域 G-5 | T npc.54.Meyaada
g05 examine - | リーダーがイルルシ環礁監視哨のRunic Sealを調べて、イルルシ環礁に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @アラパゴ暗礁域 G-5 | T obj.54.Runic_Seal | K アサルト参加証・イルルシ環礁
g06 defeat - | （してもしなくてもよい）Qiqirn Pecheurを倒して、釣竿とえさを手に入れる | ヤナギの釣竿かフライを落とす。釣竿とえさは持ちこんでもよく、釣りスキルはいらない。Qiqirn Pecheurは見て気づく。 | @イルルシ環礁
g07 go - | 湖で釣りをして、かかった敵を倒す | かかるのはクラブ・プギル・頭足族で、スニークではよけられない。5〜7匹ほど倒すと海兵の話が変わる。 | @イルルシ環礁
g08 talk - | 西(G-8)の海兵Bhjaamaに話して様子を聞く | 4人のうち1人だけが「よく釣れる」と言う。見つかったら、残りの海兵には話さなくてよい。 | @イルルシ環礁 G-8 | T npc.55.Bhjaama = npc:Bhjaama@イルルシ環礁 G-8
g09 talk - | 北(H-7)の海兵Walagarimに話して様子を聞く | | @イルルシ環礁 H-7 | T npc.55.Walagarim = npc:Walagarim@イルルシ環礁 H-7
g10 talk - | 東(I-8)の海兵Zawahfに話して様子を聞く | | @イルルシ環礁 I-8 | T npc.55.Zawahf = npc:Zawahf@イルルシ環礁 I-8
g11 talk - | 南(I-9)の海兵Zshahdaに話して様子を聞く | | @イルルシ環礁 I-9 | T npc.55.Zshahda = npc:Zshahda@イルルシ環礁 I-9
g12 go - | 「よく釣れる」と言った海兵の近くでもっと釣ってからもう一度話し、くわしい場所を聞く | 雑魚を多く倒すほど、「北の入り江」「左の入り江」のように場所がくわしくなる。 | @イルルシ環礁
g13 defeat - | 教えられた入り江で釣ってOrobonを倒す | 何回も釣ることがある。静寂のおくび、睡眠のヒプニックランプ（視線）に気をつける。睡眠が効く。とどめをさした人がテンポラリアイテムのアフポットを手に入れるので、全員でかばんを見る。 | @イルルシ環礁 | T mob.55.Orobon = mob:Orobon!@イルルシ環礁
g14 talk - | スタート(G-9)のUlbuunに話して、アフポットを渡す | | @イルルシ環礁 G-9 | T npc.55.Ulbuun = npc:Ulbuun@イルルシ環礁 G-9
g15 examine - | （してもしなくてもよい）イルルシ環礁のAncient Lockboxを開ける | | @イルルシ環礁
g16 examine - | スタート(G-9)に出るイルルシ環礁のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @イルルシ環礁 G-9 | T obj.55.Rune_of_Release_G-9 = obj:Rune of Release@イルルシ環礁 G-9


@ mission.assault.048 https://wiki.ffo.jp/html/12922.html
Q Bloody Rondo | ヘルシング作戦 | yes | T npc.アトルガン白門.Yahsra
MN - 48
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が中尉以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績1,500（ルジャワン霊窟）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Bloody_Rondo;30分、Lv.70。目標は Count Dracula を倒すこと。暗黒騎士で攻撃が強いが、足はふつうで、魔法をよく唱えるので逃げやすい。Bloodrake（吸収）、デコレーション（前方）、断罪の瞳（死の宣告・視線、カーズナ・聖水で治る）、Heliovoid、ノクトサービチュード（前方の魅了、コウモリになる）、ノスフェラトゥキス（まわりの HP・TP 吸収のあと Cursed Doppelganger が出る）、ウイング・オブ・ゲヘナ（まわり・ノックバック・スタン）（FFXIclopedia：Yahsra L-10。地図はない。HP 約21,000。魅了された人は寝かせられる。断罪の瞳は前にいる人に効き、うしろを向いていればかからない。Cursed Doppelganger は HP が少ない。左に大きな柱があり逃げやすい）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のYahsraに話して「ヘルシング作戦」を選び、だいじなもの「アサルト参加証・ルジャワン霊窟」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Yahsra | K 皇国軍認識票
g03 go - | カダーバの浮沼(K-9)のアズーフ島監視哨へ行く | 六門院から飛べる。 | @カダーバの浮沼 K-9
g04 talk - | 突入のリーダーになる人は、アズーフ島監視哨のNareemaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 K-9 | T npc.79.Nareema
g05 examine - | リーダーがアズーフ島監視哨のRunic Sealを調べて、ルジャワン霊窟に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 K-9 | T obj.79.Runic_Seal | K アサルト参加証・ルジャワン霊窟
g06 go - | スタートから通路を進んで、奥の広場へ行く | 地図はない。広場には段差や通れないところが多い。 | @ルジャワン霊窟
g07 defeat - | 奥の広場にいるCount Draculaを倒す | 前に出す技が多いので、盾役のほかは盾役とまっすぐ並ばない。ノクトサービチュードで魅了された人は寝かせる。ノスフェラトゥキスのあとに出るCursed Doppelgangerは睡眠が効かず、1〜2分で消えると書く資料もある。HPが半分を切ると断罪の瞳（視線・死の宣告）が多くなるので、目をそらすか聖水で治す。 | @ルジャワン霊窟 | T mob.69.Count_Dracula = mob:Count Dracula@ルジャワン霊窟
g08 examine - | （してもしなくてもよい）ルジャワン霊窟のAncient Lockboxを開ける | | @ルジャワン霊窟
g09 examine - | ルジャワン霊窟のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ルジャワン霊窟 | T obj.69.Rune_of_Release = obj:Rune of Release@ルジャワン霊窟

@ mission.assault.049 https://wiki.ffo.jp/html/12923.html
Q The Susanoo Shuffle | スサノオ作戦 | yes | T npc.アトルガン白門.Isdebaaq
MN - 49
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が中尉以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績1,500（マムージャ兵訓練所）
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Susanoo_Shuffle;30分、Lv.70。目標は Orochi を倒すこと。Hydra より弱く、HP・リジェネが少なく、TP は自然に増えない。首が落ちてまた生える。引き寄せを使う。エレジー・スロウが入りやすい。ときどき「Orochi has begun to thrash its tail about」と出て30〜45秒ほど尾を向け、サーペンタインテール（1発で倒れることがある）を使う。「The thrashing has ceased.」で終わる。走って離れればよけられる（FFXIclopedia：Isdebaaq L-10。地図はない。開けた場所のまん中に出る。リジェネあり。闇の側の魔法に強い。ナーブガスは毒と呪い。全滅すると HP がすぐもどる）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のIsdebaaqに話して「スサノオ作戦」を選び、だいじなもの「アサルト参加証・マムージャ兵訓練所」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Isdebaaq | K 皇国軍認識票
g03 go - | バフラウ段丘(H-11)のマムージャ監視哨へ行く | 六門院から飛べる。歩くときはマムークを通って、バフラウ段丘の小さい地図に出てから左の壁ぞいに南へ。 | @バフラウ段丘 H-11
g04 talk - | 突入のリーダーになる人は、マムージャ監視哨のDaswillに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @バフラウ段丘 H-11 | T npc.52.Daswill
g05 examine - | リーダーがマムージャ監視哨のRunic Sealを調べて、マムージャ兵訓練所に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @バフラウ段丘 H-11 | T obj.52.Runic_Seal | K アサルト参加証・マムージャ兵訓練所
g06 go - | スタートから通路を進んで、奥の広場へ行く | 地図はない。 | @マムージャ兵訓練所
g07 defeat - | 奥の広場にいるOrochiを倒す | 引き寄せを使う。尾をふり回しはじめた（酔っぱらって回りだした）ら、うしろから殴ったことになりサーペンタインテールが来るので、攻撃をやめて動かないか、走って離れる。HPが半分を切るとナーブガス（まわりに毒と呪い）を使うので、スタンで止めるか、その前に首を落としておく。 | @マムージャ兵訓練所 | T mob.66.Orochi = mob:Orochi@マムージャ兵訓練所
g08 examine - | （してもしなくてもよい）マムージャ兵訓練所のAncient Lockboxを開ける | | @マムージャ兵訓練所
g09 examine - | マムージャ兵訓練所のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @マムージャ兵訓練所 | T obj.66.Rune_of_Release = obj:Rune of Release@マムージャ兵訓練所

@ mission.assault.050 https://wiki.ffo.jp/html/12924.html
Q Better than One | ヘラクレス作戦 | yes | T npc.アトルガン白門.Famad
MN - 50
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が中尉以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績1,500（レベロス風穴）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Better_Than_One;30分、Lv.70。目標は Black Shuck を倒すこと。ふつうのケルベロスより HP が少ない。引き寄せを使う。後衛は Black Shuck のいる場所の北東の通路にいると火のエレメンタルにからまれにくい。ときどき吠えて（その間はダメージを受けない）、Nocuous Inferno を8体呼ぶ、ブレイズスパイク、ゲーツオブハデス、命中・攻撃アップのどれかになる。Nocuous Inferno は魔法に反応してからむので、なるべく少しだけ引いて、消えるまで逃げる（FFXIclopedia：Famad L-10。地図はない。HP 約25,000。吠えるのは最初と HP が約4分の1減るごと。Nocuous Inferno は8体で、次に吠えると消える。睡眠・静寂が効かない。横から盾をしてもよい）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のFamadに話して「ヘラクレス作戦」を選び、だいじなもの「アサルト参加証・レベロス風穴」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Famad | K 皇国軍認識票
g03 go - | ゼオルム火山(K-6)のハルブーン監視哨へ行く | 六門院から飛べる。歩くときは、ハルブーンに入ってエスケプするとゼオルム火山(L-7)に出るので、(L-6)から西の通路を進む。 | @ゼオルム火山 K-6
g04 talk - | 突入のリーダーになる人は、ハルブーン監視哨のWaudeenに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @ゼオルム火山 K-6 | T npc.61.Waudeen
g05 examine - | リーダーがハルブーン監視哨のRunic Sealを調べて、レベロス風穴に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @ゼオルム火山 K-6 | T obj.61.Runic_Seal | K アサルト参加証・レベロス風穴
g06 go - | スタートから通路を進んで、奥の広場へ行く | 地図はない。後衛は広場から北東の通路に入って戦うと、火のエレメンタルにからまれにくいと書く資料もある。 | @レベロス風穴
g07 defeat - | 奥の広場にいるBlack Shuckを倒す | 引き寄せを使う。戦いはじめとHPが4分の1減るごとに吠えて、火のエレメンタルを呼ぶ、ブレイズスパイクとストンスキン、ゲーツオブハデスを使うようになる、回避が上がる、のどれかになる。ゲーツオブハデスはスタンで止め、後衛は魔法がとどく距離より外にいる。ユルレーション（まわりに麻痺）、ラヴァスピット（前）、スコーチングラッシュ（うしろ）にも気をつける。 | @レベロス風穴 | T mob.63.Black_Shuck = mob:Black Shuck@レベロス風穴
g08 defeat - | （してもしなくてもよい）呼ばれたNocuous Infernoを精霊魔法で倒すか、引きつけて逃げる | 魔法に反応してからむ。睡眠・静寂が効かない。8体と書く資料と6体と書く資料がある。ゴール側（Black Shuckの尾が向いている側）の通路寄りで戦うと、相手にするのが3体ですむと書く資料もある。次に吠えると消える。 | @レベロス風穴
g09 examine - | （してもしなくてもよい）レベロス風穴のAncient Lockboxを開ける | | @レベロス風穴
g10 examine - | レベロス風穴のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @レベロス風穴 | T obj.63.Rune_of_Release = obj:Rune of Release@レベロス風穴

@ mission.assault.051 https://wiki.ffo.jp/html/12925.html
Q The Price Is Right | キラーロード作戦 | yes | T npc.アトルガン白門.Lageegee
MN - 51
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が中尉以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績1,500（ペリキア）
XS BG Wiki;https://www.bg-wiki.com/ffxi/The_Price_is_Right;30分、Lv.70。目標は King Goldemar を倒すこと。黒魔道士で、-ga III・古代魔法・スリプガをとても速く唱える。弱体とディスペルにとても強い（フィナーレは入る）。戦いながら動く武器を1つずつ呼び、呼ぶときにどれが来るか言う。カックル（魔法攻撃・魔法防御・魔法命中ダウン）、Hellsnap（まわりにスタン、このあと武器を呼ぶ）、ネクロベイン（麻痺）、Necropurge（呪い）、Thundris Shriek（テラー）。武器は Demonic Rod（白魔法）、Living Staves（黒魔法）、Bloody Daggers（速い攻撃）、Cursed Axe（遅いがいつもクリティカル）、Magic Shields（シールドバッシュだけ）で、どれもダイアワール（FFXIclopedia：Lageegee L-10。地図はない。HP 約20,000。引き寄せはない。グラビデ・スロウが入る。武器は HP 約3,500で、King Goldemar が呼ぶまで攻撃できない）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のLageegeeに話して「キラーロード作戦」を選び、だいじなもの「アサルト参加証・ペリキア」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Lageegee | K 皇国軍認識票
g03 go - | カダーバの浮沼(I-9)のドゥブッカ島監視哨へ行く | 六門院から飛べる。歩くときは、カダーバの浮沼(E-11)のNasheefaにアトルガン白銀貨を渡してアルザダール海底遺跡群を通り、ドゥブッカ島側に出て右の壁ぞいに進む。 | @カダーバの浮沼 I-9 #2
g04 talk - | 突入のリーダーになる人は、ドゥブッカ島監視哨のNahshibに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @カダーバの浮沼 I-9 #2 | T npc.79.Nahshib
g05 examine - | リーダーがドゥブッカ島監視哨のRunic Sealを調べて、ペリキアに突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @カダーバの浮沼 I-9 #2 | T obj.79.Runic_Seal | K アサルト参加証・ペリキア
g06 go - | スタートから通路を進んで、奥の広場へ行く | 地図はない。スリプガIIを唱えるので、毒薬などを用意しておくとよい。 | @ペリキア
g07 defeat - | （してもしなくてもよい）動き出した武具を、King Goldemarから離れたところへ引いて倒す | 武具はBloody Daggers・Cursed Axe・Demonic Rod・Living Staves・Magic Shieldsの5つ。King Goldemarがせりふを言うと、1つずつ動き出す。動き出すまでは攻撃できない。放っておくと次の武具も動き出す。Demonic Rodは白魔法、Living Stavesは黒魔法を使う。 | @ペリキア
g08 defeat - | 奥の広場にいるKing Goldemarを倒す | 精霊魔法をとても速く唱える。引き寄せはないので逃げられる。カックル（魔法防御ダウンなど）はすぐイレースで治し、ネクロベインの麻痺と呪いも早めに治す。HPが少なくなると鮮血の饗宴を使い、近くだとひるむので遠隔攻撃やWSで削ると書く資料もある。削りきるとせりふのあと消える。 | @ペリキア | T mob.56.King_Goldemar = mob:King Goldemar@ペリキア
g09 examine - | （してもしなくてもよい）ペリキアのAncient Lockboxを開ける | | @ペリキア
g10 examine - | ペリキアのRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @ペリキア | T obj.56.Rune_of_Release = obj:Rune of Release@ペリキア

@ mission.assault.052 https://wiki.ffo.jp/html/12926.html
Q Bellerophon's Bliss | ベレロフォン作戦 | yes | T npc.アトルガン白門.Bhoy_Yhupplo
MN - 52
LK quest:アトルガンミッションを進めて、サラヒム・センチネルの傭兵になっている
LK condition:傭兵階級が中尉以上
LK condition:募集要員はレベル70・1〜6人（突入するときにレベル制限をかけられる）
RW other:作戦戦績1,500（イルルシ環礁）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Bellerophon's_Bliss;30分、Lv.70。目標は Khimaira 14X を倒すこと。Martial Maestro Megomak も攻撃してくる。1人が Megomak を引きつけて逃げ、Khimaira 14X に集中すると楽。どちらもスタンが効かない。Megomak がダイスをふった目で Khimaira 14X の技が決まる（トゥールビヨン・Tenebrous Mist・サンダーストライク・ドレッドストーム・岩息・Plague Swipe・フルミネーション）。Megomak は HP が少なくなるか Khimaira 14X が倒されるとワープして消える。「攻略」の欄は Megomak を倒してから Khimaira 14X を倒す（FFXIclopedia：Bhoy Yhupplo L-10。地図はない。Khimaira 14X を釣ると Megomak がリンクする。引き寄せを使う。Megomak は HP が少なく、約20%で逃げる。Khimaira 14X を倒すと、戦う場所の奥の Rune of Release が使えるようになる）
g01 talk - | アトルガン白門(K-10)の公務代理店のRytaalに話して、だいじなもの「皇国軍認識票」をもらう | 1回のアサルトに1枚要る。もう持っているときはそのまま次へ。 | @アトルガン白門 K-10 | T npc.アトルガン白門.Rytaal
g02 talk - | 公務代理店(L-9 L-10)のBhoy Yhupploに話して「ベレロフォン作戦」を選び、だいじなもの「アサルト参加証・イルルシ環礁」をもらう | 皇国軍認識票はなくなる。 | @アトルガン白門 L-9 L-10 | T npc.アトルガン白門.Bhoy_Yhupplo | K 皇国軍認識票
g03 go - | アラパゴ暗礁域(G-5)のイルルシ環礁監視哨へ行く | 六門院から飛べる。歩くととても遠く、監視哨の前にインプが多い。 | @アラパゴ暗礁域 G-5
g04 talk - | 突入のリーダーになる人は、イルルシ環礁監視哨のMeyaadaに皇国軍戦績50を払って、だいじなもの「アサルト隊長腕章」をもらう | 1人で行くときも要る。腕章はほかの監視哨でも使える。 | @アラパゴ暗礁域 G-5 | T npc.54.Meyaada
g05 examine - | リーダーがイルルシ環礁監視哨のRunic Sealを調べて、イルルシ環礁に突入する | 全員が同じアサルト参加証を持って近くにいること。30分。 | @アラパゴ暗礁域 G-5 | T obj.54.Runic_Seal | K アサルト参加証・イルルシ環礁
g06 go - | スタートから通路を進んで、奥の広場へ行く | 地図はない。 | @イルルシ環礁
g07 go - | （してもしなくてもよい）1人がMartial Maestro Megomakを引きつけて、Khimaira 14Xから離れた入口のあたりでキープする | 片方を釣るともう片方もリンクする。Megomakは倒さなくても完了する。生かしておくとKhimaira 14Xの強い技が出なかったりフルミネーションが少なくなったりするが、近くにいるとKhimaira 14Xを回復すると書く資料もある。先にMegomakを倒すと書く資料もある。弱ると逃げる。 | @イルルシ環礁
g08 defeat - | 奥の広場にいるKhimaira 14Xを倒す | 引き寄せを使い、スタンが効かない。フルミネーション（広いまわりに雷のダメージ・スタン・麻痺）にそなえて、パラナを使える人を離れたところに置く。岩息（石化）、トゥールビヨン（防御力ダウン）、ドレッドストームにも気をつける。 | @イルルシ環礁 | T mob.55.Khimaira_14X = mob:Khimaira 14X@イルルシ環礁
g09 examine - | （してもしなくてもよい）イルルシ環礁のAncient Lockboxを開ける | | @イルルシ環礁
g10 examine - | 奥に出るイルルシ環礁のRune of Releaseを調べて外に出ると完了 | 帰ったら公務代理店で報告して参加証を返しておく。 | @イルルシ環礁 | T obj.55.Rune_of_Release = obj:Rune of Release@イルルシ環礁
