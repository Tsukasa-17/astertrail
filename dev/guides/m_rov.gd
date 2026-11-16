# ヴァナ・ディールの星唄（0.1.130〜）。基礎シートのミッション一覧 391〜484 行。id の番号はシートの行−390。order は BG Wiki の並び（始めるにはだけ 999）。MN の番号はシートの章と節
@ mission.rov.001 https://wiki.ffo.jp/html/39146.html
Q To Start RoV... | 「ヴァナ・ディールの星唄」を始めるには…… | no | T obj.231.Tales_Beginning
MN - 999
LK condition:Lv3以上で三国の街に入って「後にする」を選んだ
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-1;Lv3以上で三国の街に入るとイベント。後にしたときは10か所の Tales' Beginning（南サンドリア H-8・北サンドリア J-10・サンドリア港 H-9・バストゥーク鉱山区 I-9・バストゥーク商業区 I-8・バストゥーク港 D-7・ウィンダス水の区 F-5・ウィンダス石の区 C-6・ウィンダス港 B-5・ウィンダス森の区 J-10）。済むとエスカ-ジ・タとエスカ-ル・オンに入れる（FFXIclopedia も同じ場所）
g01 go - | 三国の街のどれかへ行く | 入ったときに「後にする」を選んだときだけ一覧に出る。10か所のどこでもよい。 | > a01,b01,c01,d01,e01,f01,h01,i01,j01,k01
a01 examine - | 【南サンドリア】南サンドリア(H-8)のTales' Beginningを調べてオープニングのイベントを見ると完了 | このあと「鳴くはクリスタル」になる。 | @南サンドリア H-8 | T obj.230.Tales_Beginning = obj:Tales' Beginning@南サンドリア H-8 | R 南サンドリア | >
b01 examine - | 【北サンドリア】北サンドリア(J-10)のTales' Beginningを調べてオープニングのイベントを見ると完了 | このあと「鳴くはクリスタル」になる。 | @北サンドリア J-10 | T obj.231.Tales_Beginning | R 北サンドリア | >
c01 examine - | 【サンドリア港】サンドリア港(H-9)のTales' Beginningを調べてオープニングのイベントを見ると完了 | このあと「鳴くはクリスタル」になる。 | @サンドリア港 H-9 | T obj.232.Tales_Beginning = obj:Tales' Beginning@サンドリア港 H-9 | R サンドリア港 | >
d01 examine - | 【バストゥーク鉱山区】バストゥーク鉱山区(I-9)のTales' Beginningを調べてオープニングのイベントを見ると完了 | このあと「鳴くはクリスタル」になる。 | @バストゥーク鉱山区 I-9 | T obj.234.Tales_Beginning = obj:Tales' Beginning@バストゥーク鉱山区 I-9 | R バストゥーク鉱山区 | >
e01 examine - | 【バストゥーク商業区】バストゥーク商業区(I-8)のTales' Beginningを調べてオープニングのイベントを見ると完了 | このあと「鳴くはクリスタル」になる。 | @バストゥーク商業区 I-8 | T obj.235.Tales_Beginning | R バストゥーク商業区 | >
f01 examine - | 【バストゥーク港】バストゥーク港(D-7)のTales' Beginningを調べてオープニングのイベントを見ると完了 | このあと「鳴くはクリスタル」になる。 | @バストゥーク港 D-7 | T obj.236.Tales_Beginning = obj:Tales' Beginning@バストゥーク港 D-7 | R バストゥーク港 | >
h01 examine - | 【ウィンダス水の区】ウィンダス水の区(F-5)のTales' Beginningを調べてオープニングのイベントを見ると完了 | このあと「鳴くはクリスタル」になる。 | @ウィンダス水の区 F-5 | T obj.238.Tales_Beginning = obj:Tales' Beginning@ウィンダス水の区 F-5 | R ウィンダス水の区 | >
i01 examine - | 【ウィンダス石の区】ウィンダス石の区(C-6)のTales' Beginningを調べてオープニングのイベントを見ると完了 | このあと「鳴くはクリスタル」になる。 | @ウィンダス石の区 C-6 | T obj.239.Tales_Beginning | R ウィンダス石の区 | >
j01 examine - | 【ウィンダス港】ウィンダス港(B-5)のTales' Beginningを調べてオープニングのイベントを見ると完了 | このあと「鳴くはクリスタル」になる。 | @ウィンダス港 B-5 | T obj.240.Tales_Beginning = obj:Tales' Beginning@ウィンダス港 B-5 | R ウィンダス港 | >
k01 examine - | 【ウィンダス森の区】ウィンダス森の区(J-10)のTales' Beginningを調べてオープニングのイベントを見ると完了 | このあと「鳴くはクリスタル」になる。 | @ウィンダス森の区 J-10 | T obj.241.Tales_Beginning | R ウィンダス森の区 | >

@ mission.rov.002 https://wiki.ffo.jp/html/33721.html
Q Resonance | 鳴くはクリスタル | no
MN RoV1-1 1
LK condition:Lv3以上
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-2;セルビナかマウラに入るとイベント。入った方の街で次の節が進む（FFXIclopedia も同じ。先に三国のモグハウスにつながるエリアに入ってイベント）
g01 go - | レベル3以上で、三国の街のモグハウスにつながるエリアのどれかに入り、イベントを見る | 始めるか後にするかを選べる。後にしたときは「「ヴァナ・ディールの星唄」を始めるには……」のTales' Beginningを調べる。
g02 go - | セルビナかマウラへ行く | 先に入った方の街で次の節が進み、もう一方の街ではイベントが起きない。どちらでもよい。 | > a01,b01
a01 go - | 【セルビナ】セルビナに入ってイベントを見ると完了 | 次の次の節で「蜂花粉」を3つ集めることになる。 | @セルビナ | R セルビナ | >
b01 go - | 【マウラ】マウラに入ってイベントを見ると完了 | 次の次の節で「マンドラゴラの露」を3つ集めることになる。 | @マウラ | R マウラ | >

@ mission.rov.003 https://wiki.ffo.jp/html/33722.html
Q Emissary from the Seas | 外洋からの使者 | no | T npc.248.Naillina = npc:Naillina@セルビナ F-9
MN RoV1-2 2
LK condition:前節「鳴くはクリスタル」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-3;セルビナは町長官邸 F-9 の Naillina、マウラは総督府 F-9 の Numi Adaligo で最初の選択肢。前の節でイベントを見た街で決まる（FFXIclopedia も同じ）
g01 go - | 前の節でイベントを見た街（セルビナかマウラ）へ行く | 先に入った方の街のルートになる。 | > a01,b01
a01 talk - | 【セルビナ】セルビナ(F-9)の町長官邸のNaillinaに話し、「冒険者を探してる？」を選んでイベントを見ると完了 | 「蜂花粉」を3つ持ってくるよう頼まれる。 | @セルビナ F-9 | T npc.248.Naillina | R セルビナ | >
b01 talk - | 【マウラ】マウラ(F-9)の総督府のNumi Adaligoに話し、「冒険者を探してる？」を選んでイベントを見ると完了 | 「マンドラゴラの露」を3つ持ってくるよう頼まれる。 | @マウラ F-9 | T npc.249.Numi_Adaligo | R マウラ | >

@ mission.rov.004 https://wiki.ffo.jp/html/33723.html
Q Set Free | 縛め解きて | no
MN RoV1-3 3
RW other:だいじなもの「ギルガメッシュの紹介状」（サポートジョブのクエストを済ませていないとき）／互助会引換券・銅（済ませているとき）
LK condition:前節「外洋からの使者」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-4;セルビナは Huge Wasp（ラテーヌ高原・コンシュタット高地）の Bee Pollen 3つを G-9 の Abelard に、マウラは Pygmaioi（タロンギ大峡谷）の Mandragora Dewdrop 3つを Ekokoko に。競売でも買える。紹介状は Lv18 以上でセルビナ G-10 の Isacio かマウラ G-10 の Vera に2回話すとサポートジョブが使える（FFXIclopedia も同じ。品を先に持っていればすぐ渡せる）
g01 go - | 前の節で選んだ街のルートで品を集める | 品を先に持っていれば、エリアを移らずにすぐ渡せる。 | > a01,b01
a01 gather - | 【セルビナ】ラテーヌ高原かコンシュタット高地の蜂族「Huge Wasp」から「蜂花粉」を3つ集める | 競売（雑貨）でも買える。コンシュタット高地のデムの岩のまわりに多い。ワイドスキャンで探すとよい。 | R セルビナ | > a02
a02 trade - | セルビナ(G-9)のAbelardに「蜂花粉」を3つトレードし、イベントを見ると完了 | 前の節のNaillinaの隣の部屋にいる。サポートジョブのクエストを済ませていないと、だいじなもの「ギルガメッシュの紹介状」がもらえる。Lv18以上でセルビナ(G-10)のIsacioに2回話すとサポートジョブが使えるようになる。 | @セルビナ G-9 | T npc.248.Abelard | N 蜂花粉*3 | R セルビナ | >
b01 gather - | 【マウラ】タロンギ大峡谷のマンドラゴラ族「Pygmaioi」から「マンドラゴラの露」を3つ集める | 競売（雑貨）でも買える。出にくいので、自分で集めるときは時間がかかる。 | @タロンギ大峡谷 | R マウラ | > b02
b02 trade - | マウラ(F-9)のEkokokoに「マンドラゴラの露」を3つトレードし、イベントを見ると完了 | サポートジョブのクエストを済ませていないと、だいじなもの「ギルガメッシュの紹介状」がもらえる。Lv18以上でマウラ(G-10)のVeraに2回話すとサポートジョブが使えるようになる。 | @マウラ F-9 | T npc.249.Ekokoko = npc:Ekokoko@マウラ F-9 | N マンドラゴラの露*3 | R マウラ | >

@ mission.rov.005 https://wiki.ffo.jp/html/33724.html
Q The Beginning | ある始まり | no
MN RoV1-4 4
RW key_item:醴泉神社の勾玉
LK condition:前節「縛め解きて」クリア。「ジラートの幻影」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-5;セルビナ H-10 の Pacomart かマウラ H-9 の Tonasav に話してノーグへ。ノーグ K-8 の Oaken Door で Reisenjima Sanctorium orb（FFXIclopedia も同じ。体験版ではジラートがないので進めない）
g01 go - | 前の節で選んだ街（セルビナかマウラ）へ行く | 「ギルガメッシュの紹介状」をもらったときは、出かける前に使っておく。 | > a01,b01
a01 talk - | 【セルビナ】セルビナ(H-10)のPacomartに話し、「行く」を選んでノーグへ行く | 話さずにノーグへ行ってもイベントは起きない。 | @セルビナ H-10 | T npc.248.Pacomart = npc:Pacomart@セルビナ H-10 | R セルビナ | > g02
b01 talk - | 【マウラ】マウラ(H-9)のTonasavに話し、「行く」を選んでノーグへ行く | 話さずにノーグへ行ってもイベントは起きない。 | @マウラ H-9 | T npc.249.Tonasav = npc:Tonasav@マウラ H-9 | R マウラ | > g02
g02 examine - | ノーグ(K-8)のOaken Doorを調べてイベントを見て、だいじなもの「醴泉神社の勾玉」をもらうと完了 | ノーグを出る前に、サバイバルガイド・ホームポイント・ウェイポイントを開けておくとよい。このあとノーグ(G-7)のGottnaに話すとセルビナ・マウラへ送ってもらえる。 | @ノーグ K-8 | T obj.252.Oaken_Door

@ mission.rov.006 https://wiki.ffo.jp/html/33725.html
Q Flames of Prayer | 祈りの炎 | no | T obj.252.Oaken_Door
MN RoV1-5 5
RW key_item:星唄の煌めき【一奏】
LK condition:前節「ある始まり」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-6;前の節のあとにもう一度ノーグ K-8 の Oaken Door を調べて Rhapsody in White（経験値・スキル上げ・フェイスの数・ホームポイントの料金などがよくなる。FFXIclopedia も同じ）
g01 examine - | もう一度ノーグ(K-8)のOaken Doorを調べてイベントを見て、だいじなもの「星唄の煌めき【一奏】」をもらうと完了 | 経験値が多くなり、フェイスを1人多く呼べるようになる。ホームポイントのワープも安くなる。 | @ノーグ K-8 | T obj.252.Oaken_Door

@ mission.rov.007 https://wiki.ffo.jp/html/33726.html
Q The Path Untraveled | 第一の定め | no
MN RoV1-6 6
LK condition:前節「祈りの炎」クリア。三国ミッション2-3クリア（所属国のランク3以上）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-7;ホラ・デム・メアの岩のどれかの Shattered Telepoint（Telepoint とは別）を調べ、クフィム島を選ぶ。ランク3以上。ランク2-3 を先に済ませていれば、この節のあと Halver（ドラギーユ城 I-9）・Kupipi（天の塔）で Cipher: Halver・Cipher: Semih（FFXIclopedia も同じ岩。座標はどちらにもない）
g01 go - | 三国ミッション2-3を済ませてから、ホラの岩・デムの岩・メアの岩のどれかへ行く | 岩にはこのあと何度も来るので、テレポの魔法やデムの指輪などがあると楽。 | > a01,b01,c01
a01 examine - | 【ホラの岩】ラテーヌ高原のホラの岩のShattered Telepointを調べ、「クフィム島」を選んでイベントを見ると完了 | Telepointとは別のもの。岩のまわりを探す。三国ミッション2-3のときにKupipiとHalverに話すと「盟-セミ」「盟-ハルヴァー」がもらえる（2-3を先に済ませていれば、この節のあとに話す）。 | @ラテーヌ高原 | T obj.102.Shattered_Telepoint = obj:Shattered Telepoint@ラテーヌ高原 | R ホラの岩 | >
b01 examine - | 【デムの岩】コンシュタット高地のデムの岩のShattered Telepointを調べ、「クフィム島」を選んでイベントを見ると完了 | Telepointとは別のもの。岩のまわりを探す。三国ミッション2-3のときにKupipiとHalverに話すと「盟-セミ」「盟-ハルヴァー」がもらえる（2-3を先に済ませていれば、この節のあとに話す）。 | @コンシュタット高地 | T obj.108.Shattered_Telepoint = obj:Shattered Telepoint@コンシュタット高地 | R デムの岩 | >
c01 examine - | 【メアの岩】タロンギ大峡谷のメアの岩のShattered Telepointを調べ、「クフィム島」を選んでイベントを見ると完了 | Telepointとは別のもの。岩のまわりを探す。三国ミッション2-3のときにKupipiとHalverに話すと「盟-セミ」「盟-ハルヴァー」がもらえる（2-3を先に済ませていれば、この節のあとに話す）。 | @タロンギ大峡谷 | T obj.117.Shattered_Telepoint = obj:Shattered Telepoint@タロンギ大峡谷 | R メアの岩 | >

@ mission.rov.008 https://wiki.ffo.jp/html/33727.html
Q At the Heavens' Door | 天地の間に | no | T obj.126.Undulating_Confluence = obj:Undulating Confluence@クフィム島 G-8
MN RoV1-7 7
LK condition:前節「第一の定め」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-8;クフィム島 G-8 のホームポイントの近くの Undulating Confluence（FFXIclopedia も同じ。次の戦いは一人ならLv40以上がよい）
g01 examine - | クフィム島(G-8)のUndulating Confluenceを調べてイベントを見ると完了 | ホームポイントのすぐ近く。次の節の戦いは思ったより強いので、一人ならLv40以上にしておく。 | @クフィム島 G-8 | T obj.126.Undulating_Confluence

@ mission.rov.009 https://wiki.ffo.jp/html/33728.html
Q The Lion's Roar | 理外の獅子 | no | T obj.126.Undulating_Confluence
MN RoV1-8 8
LK condition:前節「天地の間に」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-9;もう一度 Undulating Confluence を調べるとすぐ Ophiotaurus が出る。救援要請しても倒せばよい。倒すと完了（FFXIclopedia も同じ。一人ならLv50以上がよい）
g01 examine - | フェイスを先に呼んでから、もう一度クフィム島(G-8)のUndulating Confluenceを調べ、Ophiotaurusを出す | 調べるとすぐ襲ってくるので、強化とフェイスは先に。一人ならLv40〜50以上がよい。 | @クフィム島 G-8 | T obj.126.Undulating_Confluence
g02 defeat - | Ophiotaurusを倒すと完了 | 与えるダメージが1回50ほどに抑えられるので、手数の多い攻撃や多段のWSで攻める。救援要請してから倒してもよい。 | @クフィム島 G-8 | T mob.126.Ophiotaurus = mob:Ophiotaurus@クフィム島 G-8

@ mission.rov.010 https://wiki.ffo.jp/html/33729.html
Q Eddies of Despair | 害毒の渦 | no | T obj.126.Undulating_Confluence
MN RoV1-9 9
LK condition:前節「理外の獅子」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-10;Ophiotaurus のあと、もう一度 Undulating Confluence を調べるとエスカ-ジ・タに移り、着くと完了（FFXIclopedia も同じ。エスカ-ジ・タでは何もしなくてよい）
g01 examine - | もう一度クフィム島(G-8)のUndulating Confluenceを調べてイベントを見て、エスカ-ジ・タに着くと完了 | エスカ-ジ・タでは何もしなくてよい。 | @クフィム島 G-8 | T obj.126.Undulating_Confluence

@ mission.rov.011 https://wiki.ffo.jp/html/33730.html
Q A Land After Time | 時のない世界 | no
MN RoV1-10 10
RW key_item:星唄の煌めき【二奏】
RW item:盟-ライオンII
LK condition:前節「害毒の渦」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-11;ホラ・デム・メアの岩のどれかの Shattered Telepoint（前と違う岩でもよい）。Rhapsody in Umber と Cipher: Lion II。このあと Curio Vendor Moogle で宝箱のカギが買える（FFXIclopedia も同じ）
g01 go - | ホラの岩・デムの岩・メアの岩のどれかへ行く | 前の節と違う岩でもよい。 | > a01,b01,c01
a01 examine - | 【ホラの岩】ラテーヌ高原のホラの岩のShattered Telepointを調べてイベントを見ると完了 | このあと三国のCurio Vendor Moogleで宝箱のカギが買えるようになる。次の「星唄の煌めき」の戦いは強いので、一人ならLv75〜80まで上げておくとよい。 | @ラテーヌ高原 | T obj.102.Shattered_Telepoint | R ホラの岩 | >
b01 examine - | 【デムの岩】コンシュタット高地のデムの岩のShattered Telepointを調べてイベントを見ると完了 | このあと三国のCurio Vendor Moogleで宝箱のカギが買えるようになる。次の「星唄の煌めき」の戦いは強いので、一人ならLv75〜80まで上げておくとよい。 | @コンシュタット高地 | T obj.108.Shattered_Telepoint | R デムの岩 | >
c01 examine - | 【メアの岩】タロンギ大峡谷のメアの岩のShattered Telepointを調べてイベントを見ると完了 | このあと三国のCurio Vendor Moogleで宝箱のカギが買えるようになる。次の「星唄の煌めき」の戦いは強いので、一人ならLv75〜80まで上げておくとよい。 | @タロンギ大峡谷 | T obj.117.Shattered_Telepoint | R メアの岩 | >

@ mission.rov.012 https://wiki.ffo.jp/html/33731.html
Q Fate's Call | 運命を奏でよ | no
MN RoV1-11 11
LK condition:前節「時のない世界」クリア。三国ミッション5-2で闇の王を倒した
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-12;ランク5-2で闇の王を倒してから三国の街に入るとイロハのイベント（FFXIclopedia も同じ。ランク6になっていれば飛ばしてノーグへ行ってよい）
g01 go - | 三国ミッション5-2を、闇の王を倒してだいじなもの「闇の破片」をもらうところまで進める | ミッション5-2を最後まで済ませなくてもよい。
g02 go - | サンドリア・バストゥーク・ウィンダスの街のどれかに入り、イベントを見ると完了 | もう闇の王を倒してあるときは、この手順を飛ばして、ノーグに入れば次の節に進める。

@ mission.rov.013 https://wiki.ffo.jp/html/33732.html
Q What Lies Beyond | 後の先 | no | T obj.252.Oaken_Door
MN RoV1-12 12
LK condition:前節「運命を奏でよ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-13;ノーグに入り、Gilgamesh の部屋の Oaken Door を調べる。ジラートのミッションを始めていなければ、ノーグに入ったときにジラート1のイベントになる（FFXIclopedia も同じ）
g01 examine - | ノーグ(K-8)のOaken Doorを調べてイベントを見ると完了 | ジラートのミッションをまだ始めていないと、ノーグに入ったときにそのイベントが先に起きる。 | @ノーグ K-8 | T obj.252.Oaken_Door

@ mission.rov.014 https://wiki.ffo.jp/html/33733.html
Q The Ties That Bind | ざわめきの言霊 | no | T obj.176.???_J-12 = obj:???@海蛇の岩窟 J-12 #1
MN RoV1-13 13
LK condition:前節「後の先」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-14;海蛇の岩窟 J-12（1枚目）の池のほとりの光る ???。ノーグから南へ歩くか、ウォンテッドのワープ（CL125）で4枚目に出て金貨扉から1枚目に戻る（FFXIclopedia も同じ。Ornamented Door には入らない）
g01 go - | 海蛇の岩窟の1枚目(J-12)の池へ行く | ウォンテッドのワープで海蛇の岩窟に飛び、金貨扉を戻ると近い。ノーグから南へ歩いてもよい。Ornamented Doorの奥ではなく、その下の池。金貨扉の内側はLv99でも絡まれるのでスニークとインビジを。 | @海蛇の岩窟 J-12 #1
g02 examine - | 池のほとりの青く光る???を調べてイベントを見ると完了 | ミスリル貨扉と金貨扉の手前にある。終わっても次の節の案内は出ないので、そのままユタンガ大森林へ行く。 | @海蛇の岩窟 J-12 #1 | T obj.176.???_J-12

@ mission.rov.015 https://wiki.ffo.jp/html/33734.html
Q Impurity | 異質なるもの | no | T obj.123.???_F-11 = obj:???@ユタンガ大森林 F-11
MN RoV1-14 14
LK condition:前節「ざわめきの言霊」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-15;ユタンガ大森林 F-11 の光る ???。海蛇の岩窟からエスケプで出るか、ノーグ H-9 の Marilleune でチョコボを借りるか、ウォンテッドのワープ（CL119）（FFXIclopedia も同じ。次の戦いは一人ならLv80以上がよい）
g01 go - | ユタンガ大森林(F-11)へ行く | 海蛇の岩窟からならエスケプで出るとすぐ。ノーグでチョコボを借りても、ウォンテッドのワープでもよい。出口のサバイバルガイドを開けておくとよい。 | @ユタンガ大森林 F-11
g02 examine - | ノーグへの洞窟の入口の池のほとりの青く光る???を調べてイベントを見ると完了 | 次の節の戦いは思ったより強いので、一人ならLv80以上にしておく。 | @ユタンガ大森林 F-11 | T obj.123.???_F-11

@ mission.rov.016 https://wiki.ffo.jp/html/33735.html
Q The Lost Avatar | 迷えし聖獣 | no | T obj.123.???_F-11
MN RoV1-15 15
RW key_item:星唄の煌めき【三奏】
LK condition:前節「異質なるもの」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-16;もう一度 ??? を調べるとすぐ Siren が出る。15分ほどで消えるので、その間に倒す。風の属性ダメージを吸収、エンタイス（魅了）は前方範囲。倒したら ??? をもう一度調べて Rhapsody in Azure（FFXIclopedia も同じ。一人ならLv90以上がよいとも）
g01 examine - | フェイスを先に呼んでから、もう一度ユタンガ大森林(F-11)の???を調べ、Sirenを出す | 調べるとすぐ戦いになるので、強化とフェイスは先に。一人ならLv80以上がよい。 | @ユタンガ大森林 F-11 | T obj.123.???_F-11
g02 defeat - | 15分ほどのうちにSirenを倒す | 風の属性ダメージ（風のWS、炸裂・分解・光の連携）で回復する。前方のエンタイスで魅了されるとフェイスが消えるので、盾のフェイスに引きつけて後ろに回る。シャントットIIはエアロで回復させることがある。 | @ユタンガ大森林 F-11 | T mob.123.Siren = mob:Siren@ユタンガ大森林 F-11
g03 examine - | もう一度???を調べてイベントを見て、だいじなもの「星唄の煌めき【三奏】」をもらうと完了 | - | @ユタンガ大森林 F-11 | T obj.123.???_F-11

@ mission.rov.017 https://wiki.ffo.jp/html/33736.html
Q Volto Oscuro | 使者ヴォルトオスクーロ | no | T obj.252.Oaken_Door
MN RoV1-16 16
RW item:盟-ザイドII
RW title:運命を知った者
LK condition:前節「迷えし聖獣」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-17;ノーグ K-8 の Oaken Door で Cipher: Zeid II と称号 The Fated（FFXIclopedia も同じ）
g01 examine - | ノーグ(K-8)のOaken Doorを調べてイベントを見て、「盟-ザイドII」をもらうと完了 | マイバッグがいっぱいで受け取れなかったときは、空けてからもう一度調べる。 | @ノーグ K-8 | T obj.252.Oaken_Door

@ mission.rov.018 https://wiki.ffo.jp/html/33737.html
Q Ring My Bell | 誰がために鈴は鳴った | no | T obj.252.Oaken_Door
MN RoV1-17 17
LK condition:前節「使者ヴォルトオスクーロ」クリア。プロマシアミッションを始めている（「命の洗礼」が一覧にある）
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_1-18;Gilgamesh の部屋の扉を何度か調べ、中で Gilgamesh に話すと、Aldo・Tenzen・Zeid・Kagero・Prishe とのイベント。プロマシアの 5-2・7-5・8-1・8-3・8-4 の途中だと進めない。7-5 を始めたら 8-4 の最後のイベント（日本の0時の待ちあり）まで済ませる（FFXIclopedia も同じ）
g01 examine - | ノーグ(K-8)のOaken Doorを調べてイベントを見て、テンゼンを追ってデルクフの塔へ行くよう頼まれると完了 | イベントになるまで何度か調べる。部屋に入ったらGilgameshに話す。プロマシアミッション「主のなき都」でテンゼンに会っていないと、テンゼンを探すよう言われる（テンゼンのフェイスを持っていれば会ったことになる）。「鍔音やむことなく」より先に進めていると、プロマシアミッションをすべて済ませる（「さらばでござる」などのあとのイベントを全部見て称号「虚ろなる闇に涙する者」）まで進めない。 | @ノーグ K-8 | T obj.252.Oaken_Door

@ mission.rov.019 https://wiki.ffo.jp/html/34160.html
Q Spirits Awoken | 御魂の声 | no
MN RoV2-1 18
LK condition:前節「誰がために鈴は鳴った」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-1;クフィム島からデルクフの塔下層に入るとイベント（サバイバルガイドで飛んでもよい。起きなければ入り直す）。FFXIclopedia も同じ（選択肢にかかわらずル・ルデの庭へ行くよう言われる。プロマシアの条件を満たしていなくてもこの節は済む）
g01 go - | デルクフの塔下層に入り、イベントを見ると完了 | クフィム島から入っても、サバイバルガイドで飛んでもよい。起きなければ入り直す。テンゼンの居場所で「タブナジア？」を選ぶと少し話が増える（プロマシアミッションでタブナジアに着いているときだけ）。デルクフの塔下層のサバイバルガイドを開けておくとよい。 | @デルクフの塔下層

@ mission.rov.020 https://wiki.ffo.jp/html/34161.html
Q Crashing Waves | 波の向こうに | no
MN RoV2-2 19
RW item:盟-テンゼンII
LK condition:前節「御魂の声」クリア。プロマシアミッション第3章第2節「主のなき都」を終えている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-2;ル・ルデの庭 H-7 の宮殿に近づくとイベントで Cipher: Tenzen II。プロマシア 3-2 まで進めていないと起きない。受け取れなかったら宮殿の入口の Mystic Retriever（FFXIclopedia も同じ。このあとプリッシュ・ウルミア・テンゼンがいなくなるプロマシアのミッションに注意）
g01 go - | プロマシアミッション「主のなき都」まで済ませる | このあと星唄ではプリッシュとテンゼンが何度も出てくる。プロマシアミッションを先に進めすぎると止まることがあるので、星唄を「遥かな分岐点」まで進めてからにするとよい。
g02 go - | ル・ルデの庭(H-7)のオーロラ宮殿に入り、イベントを見て「盟-テンゼンII」をもらうと完了 | マイバッグがいっぱいで受け取れなかったときは、空けてから近くの光る靄（Mystic Retriever）を調べる。 | @ル・ルデの庭 H-7

@ mission.rov.021 https://wiki.ffo.jp/html/34162.html
Q Call to Serve | 候ふ者たち | no
MN RoV2-3 20
RW item:盟-プリッシュII
RW other:プロマシアミッションの「心に宿る記憶」がすべて見られる
LK condition:前節「波の向こうに」クリア。プロマシアミッションでプリッシュが出られる
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-3;ジュノ港に入るとイベントで Cipher: Prishe II。プロマシア 3-5・5-3・6-4・8-4（戦いのあとのイベント）の途中だと起きない。受け取れなかったらジュノ港のガイドストーンの近くの Mystic Retriever（FFXIclopedia も同じ）
g01 go - | ジュノ港に入り、イベントを見て「盟-プリッシュII」をもらうと完了 | プロマシアミッション「神を名乗りて」を受けているときや、「みっつの道」から「望むはあらゆる答え」を済ませるまでのあいだは進めない（そのことが表示される）。ほかにもプリッシュが別に動いているときは起きない。受け取れなかったときは、ジュノ港(F-8)の光る靄（Mystic Retriever）を調べる。 | @ジュノ港

@ mission.rov.022 https://wiki.ffo.jp/html/34163.html
Q Numbering Days | 待ち人来たらず（ミッション） | no | T obj.244.Door_Marble_Bridge
MN RoV2-4 21
LK condition:前節「候ふ者たち」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-4;ジュノ上層 F-7 の Door: Marble Bridge を調べるとイベント。中に入れなくてもよい（FFXIclopedia も同じ。このあとはプリッシュがいなくてもよい）
g01 examine - | ジュノ上層(F-7)のマーブルブリッジのドア（Door:"Marble Bridge"）を調べてイベントを見ると完了 | 中に入れる資格がなくてもよい。 | @ジュノ上層 F-7 | T obj.244.Door_Marble_Bridge

@ mission.rov.023 https://wiki.ffo.jp/html/34164.html
Q Inescapable Binds | 逃れられぬ運命 | no
MN RoV2-5 22
RW other:だいじなもの「渡航免状」（持っていないとき）
LK condition:前節「待ち人来たらず」クリア。「アトルガンの秘宝」を持っている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-5;アトルガン白門に入るとイベント。入れないときはジュノ下層 J-8 の天晶堂の Faursel で3つ目の空白の選択肢を2回選んでから「Where is Tenzen」で渡航免状（FFXIclopedia も同じ。渡航免状を持っていれば次の節へ）
g01 go - | 渡航免状を持っているかどうかで分かれる | 持っていれば、アトルガン白門に入るだけで次の「羅針に従え」も済む。 | > a01,b01
a01 go - | 【渡航免状を持っている】アトルガン白門に入り、イベントを見ると完了 | 「羅針に従え」も済んで「無頼な風」になる。 | @アトルガン白門 | R 渡航免状を持っている | >
b01 talk - | 【渡航免状を持っていない】ジュノ下層(J-8)の天晶堂のFaurselに話し、「テンゼンは？」を選んで渡航免状をもらうと完了 | 先に3つ目の空白の選択肢を2回選ぶと「テンゼンは？」が出る。クエスト「アトルガン皇国へ」を済ませて渡航免状をもらってもよい。 | @ジュノ下層 J-8 | T npc.245.Faursel | R 渡航免状を持っていない | >

@ mission.rov.024 https://wiki.ffo.jp/html/34165.html
Q Desert Winds | 羅針に従え | no
MN RoV2-6 23
LK condition:前節「逃れられぬ運命」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-6;渡航免状を持っていればこの節は飛ばされ、アトルガン白門でテンゼンのイベントを見ると済む（FFXIclopedia：アトルガン白門のホームポイント#2で入るのが早い。ワジャーム樹林 M-7 の扉からでもよい）
g01 go - | マウラからアトルガン皇国行きの船に乗り、アトルガン白門に入ってイベントを見ると完了 | アトルガン白門のホームポイントを開けていれば、ホームポイントで飛んでもよい。前の節で渡航免状を持っていたときは、この節はもう済んでいる。 | @アトルガン白門

@ mission.rov.025 https://wiki.ffo.jp/html/34166.html
Q Ever Forward | 無頼な風 | no | T obj.アトルガン白門.Imperial_Whitegate
MN RoV2-7 24
RW other:盟-アブクーバ（Abquhbahに話すと）
LK condition:前節「羅針に従え」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-7;アトルガンミッション12「Royal Puppeteer」まで進めていないとこの先に進めない。アトルガンミッションを全部済ませていれば Imperial Whitegate のイベントで Reunited まで飛ぶ。12 を始めていれば所属国でイベントのあと Aphmau's Light へ（FFXIclopedia は L-8/L-9。アフマウが白門にいないアトルガンミッションの途中だと止まる）
g01 go - | アトルガンミッション「無手の傀儡師」まで進める | 先に進んでいるほど、星唄の次の節がいくつか飛ばされる。アフマウが白門を離れているアトルガンミッションの途中だと止まるので、星唄を「流浪の旅」まで進めてからアトルガンミッションを進めるとよい。
g02 talk - | （してもしなくてもよい）アトルガン白門(I-10)のサラヒム・センチネルのAbquhbahに話し、「盟-アブクーバ」をもらう | アトルガンミッションの進み具合によってはいないことがある。 | @アトルガン白門 I-10 | T npc.アトルガン白門.Abquhbah
g03 examine - | アトルガン白門(L-9)のImperial Whitegateを調べてイベントを見ると完了 | アトルガンミッションが進んでいないと、進めないと表示される。「無手の傀儡師」まで進んでいれば「咎人を追え」「浄化の光」も済んで「胡乱なる目」になる。そうでなければ進み具合で「咎人を追え」か「浄化の光」になる。 | @アトルガン白門 L-9 | T obj.アトルガン白門.Imperial_Whitegate

@ mission.rov.026 https://wiki.ffo.jp/html/34167.html
Q The Endless Sky | 咎人を追え | no
MN RoV2-8 25
LK condition:前節「無頼な風」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-8;アトルガンミッション12 まで済ませないと先に進めない（FFXIclopedia：所属国に入るとイベントで Aphmau's Light へ）
g01 go - | アトルガンミッションを「無手の傀儡師」まで進める | アトルガンミッションが進んでいれば、この節は飛ばされる。
g02 go - | 大工房以外の三国のエリアに入り、イベントを見ると完了 | そのままアトルガン白門のImperial Whitegateへ行くと「浄化の光」も飛ばして「胡乱なる目」になる。

@ mission.rov.027 https://wiki.ffo.jp/html/34168.html
Q Aphmau's Light | 浄化の光 | no | T obj.アトルガン白門.Imperial_Whitegate
MN RoV2-9 26
LK condition:前節「咎人を追え」クリア。アトルガンミッション「無手の傀儡師」まで進め、アフマウが白門にいる
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-9;アフマウが白門にいるときに Imperial Whitegate（L-8/L-9）を調べる。アトルガン19・29 などの途中はいない（FFXIclopedia も同じ）
g01 go - | アトルガンミッションを、アフマウが白門にいるところまで進める | 進められるのは「無手の傀儡師」「亡国の墳墓」「海豚の紋章」「漆黒の柩」「幽冥の海賊」「賓客の資格」「泡沫の宝冠」「特使の御楯」「宴遊の終幕」「悪魔と悪鬼と」「運命の歯車」「大団円」「永遠の傭兵」を受けているとき。ほかのときは調べても何も起きない。
g02 examine - | アトルガン白門(L-9)のImperial Whitegateを調べてイベントを見ると完了 | - | @アトルガン白門 L-9 | T obj.アトルガン白門.Imperial_Whitegate

@ mission.rov.028 https://wiki.ffo.jp/html/34169.html
Q Reunited | 胡乱なる目 | no | T npc.アトルガン白門.Nadeey
MN RoV2-10 27
RW item:盟-ナシュメラII
RW other:アトルガンミッションの「心に宿る記憶」がすべて見られる
LK condition:前節「浄化の光」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-10;ワラーラ寺院に入って Nadeey に話すとイベント（FFXIclopedia は K-7。BG Wiki は盟-ナシュメラII を前の節の報酬にしている。入ったときに勝手に起きるイベントは「The Rider Cometh」のもので、この節とは別）
g01 go - | アトルガン白門(K-7)のワラーラ寺院に入る | 前の節のアフマウとのイベントで「盟-ナシュメラII」がもらえる。入ったときに勝手にイベントが起きたら、それはほかのミッションのもの。 | @アトルガン白門 K-7
g02 talk - | ワラーラ寺院のNadeeyに話してイベントを見ると完了 | - | @アトルガン白門 K-7 | T npc.アトルガン白門.Nadeey

@ mission.rov.029 https://wiki.ffo.jp/html/34170.html
Q Take Wing | 願え叶え賜え | no
MN RoV2-11 28
LK condition:前節「胡乱なる目」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-11;K-12 の Shararat Teahouse に行くとイベント（FFXIclopedia は J/K-12）
g01 go - | アトルガン白門(J-12/K-12)の茶屋シャララトに行き、イベントを見ると完了 | 近づくと勝手にイベントになる。 | @アトルガン白門 J-12 K-12

@ mission.rov.030 https://wiki.ffo.jp/html/34171.html
Q Prime Number | つごもり | no
MN RoV2-12 29
LK condition:前節「願え叶え賜え」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-12;アルザダール海底遺跡群に入るとイベント。移送の幻灯でナイズル島監視哨へ（皇国軍戦績200）、またはアサルトのナイズル島踏査指令で入る（FFXIclopedia：バフラウ段丘 F-6 で白銀貨を払っても入れる）
g01 go - | アルザダール海底遺跡群に入り、イベントを見ると完了 | 移送の幻灯でナイズル島監視哨へ行くと早い（皇国軍戦績200）。戦績が足りなければ、互助会引換券・銅で戦績をもらうか、アサルト「ナイズル島踏査指令」で入る。バフラウ段丘(F-6)で白銀貨を払って入ってもよい。 | @アルザダール海底遺跡群

@ mission.rov.031 https://wiki.ffo.jp/html/34172.html
Q From the Ruins | 瓦解する存在 | no | T obj.アトルガン白門.Imperial_Whitegate
MN RoV2-13 30
RW key_item:星唄の煌めき【四奏】
LK condition:前節「つごもり」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-13;アトルガン白門の Imperial Whitegate で Rhapsody in Crimson。2-39 までのあいだに、ほかの闇の場所のイベント（アトルガン全部のあとにアルザダール海底遺跡群へ入り直す、プロマシア 3-5 のあと異界の口、プロマシア全部のあと The Garden of Ru'Hmet の一番下の先）を見てもよい（FFXIclopedia は L-8/9。フェイスを5人呼べるようになる）
g01 go - | （してもしなくてもよい）アルザダール海底遺跡群からいったん出て、もう一度入り、イベントを見る | 見なくてもよい。ほかのミッションの進み具合によっては起きない。
g02 examine - | アトルガン白門(L-9)のImperial Whitegateを調べてイベントを見て、だいじなもの「星唄の煌めき【四奏】」をもらうと完了 | フェイスを5人まで呼べるようになる。 | @アトルガン白門 L-9 | T obj.アトルガン白門.Imperial_Whitegate

@ mission.rov.032 https://wiki.ffo.jp/html/34173.html
Q Cauterize | 暗中模索 | no
MN RoV2-14 31
LK condition:前節「瓦解する存在」クリア。アルタナミッションを「ケット・シー、馳せる」を受けるところまで進めている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-14;バタリア丘陵・ロランベリー耕地・ソロムグ原野の Cavernous Maw の横の光る ??? を調べるとイベント。クエスト Champion of the Dawn・A Forbidden Reunion を受けていれば先に済ませる。アルタナを始めていなければ Uncertain Destinations、始めていれば Ganged Up On へ（FFXIclopedia：過去の3つのエリアの口でもよい）
g01 go - | アルタナミッションを「ケット・シー、馳せる」を受けるところまで進める | クエスト「暁よりの使者、再び」「禁断の再会」を受けているときは先に済ませる。アルタナミッションを全部済ませているときは、「暁よりの使者、再び」を済ませ、「禁断の再会」でリリゼットに会う（胡蝶のカギをもらう）ところまで進める。
g02 go - | バタリア丘陵・ロランベリー耕地・ソロムグ原野のどれかの禁断の口へ行く | 〔Ｓ〕の3つのエリアの口でもよい。 | > a01,b01,c01
a01 examine - | 【バタリア丘陵】バタリア丘陵(H-5)の禁断の口（Cavernous Maw）のそばの青く光る???を調べてイベントを見ると完了 | - | @バタリア丘陵 H-5 | T obj.バタリア丘陵.???_Maw = obj:???@バタリア丘陵 H-5 | R バタリア丘陵 | >
b01 examine - | 【ロランベリー耕地】ロランベリー耕地(H-6)の禁断の口（Cavernous Maw）のそばの青く光る???を調べてイベントを見ると完了 | - | @ロランベリー耕地 H-6 | T obj.ロランベリー耕地.???_Maw = obj:???@ロランベリー耕地 H-6 | R ロランベリー耕地 | >
c01 examine - | 【ソロムグ原野】ソロムグ原野(K-9)の禁断の口（Cavernous Maw）のそばの青く光る???を調べてイベントを見ると完了 | - | @ソロムグ原野 K-9 | T obj.ソロムグ原野.???_Maw = obj:???@ソロムグ原野 K-9 | R ソロムグ原野 | >

@ mission.rov.033 https://wiki.ffo.jp/html/34174.html
Q Uncertain Destinations | 流浪の旅 | no
MN RoV2-15 32
RW other:だいじなもの「露光蟲」（ウォークオブエコーズに行ったことがないとき）
LK condition:前節「暗中模索」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-15;3つの Cavernous Maw の横の青く光る ???（白いものではない）を調べるとイベント（FFXIclopedia：過去の3つのエリアの口でもよい。このあと Ganged Up On）
g01 go - | 露光蟲を持って、バタリア丘陵・ロランベリー耕地・ソロムグ原野のどれかの禁断の口へ行く | ウォークオブエコーズに行ったことがなければ、だいじなもの「露光蟲」がもらえる。〔Ｓ〕の3つのエリアの口でもよい。アルタナミッションが進んでいれば、この節は飛ばされる。 | > a01,b01,c01
a01 examine - | 【バタリア丘陵】バタリア丘陵(H-5)の禁断の口のそばの青く光る???を調べてイベントを見ると完了 | 白い???ではなく、青く光る方。 | @バタリア丘陵 H-5 | T obj.バタリア丘陵.???_Maw | R バタリア丘陵 | >
b01 examine - | 【ロランベリー耕地】ロランベリー耕地(H-6)の禁断の口のそばの青く光る???を調べてイベントを見ると完了 | 白い???ではなく、青く光る方。 | @ロランベリー耕地 H-6 | T obj.ロランベリー耕地.???_Maw | R ロランベリー耕地 | >
c01 examine - | 【ソロムグ原野】ソロムグ原野(K-9)の禁断の口のそばの青く光る???を調べてイベントを見ると完了 | 白い???ではなく、青く光る方。 | @ソロムグ原野 K-9 | T obj.ソロムグ原野.???_Maw | R ソロムグ原野 | >

@ mission.rov.034 https://wiki.ffo.jp/html/34175.html
Q Ganged Up On | 仮面の一味 | no
MN RoV2-16 33
RW item:盟-リリゼットII
RW other:「天涯の娘」まで進めたルートでは、アルタナミッションの「心に宿る記憶」がすべて見られ、だいじなもの「露光蟲」ももらえる
LK condition:前節「流浪の旅」クリア。アルタナミッションでリリゼットが出られる
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-16;アルタナを全部済ませていれば Cavernous Maw の横の ??? でイベント。まだなら アルタナ8「In the Name of the Father」より先で南サンドリア〔Ｓ〕に入ると Lightsworm と Cipher: Lilisette II。起きなければ先に口の ??? を調べてから入り直す（FFXIclopedia も同じ。A Timeswept Butterfly の途中は起きない）
g01 go - | アルタナミッションの進み具合で分かれる | 「さようなら、リリゼット」から「映りしは、暁の」までのあいだなど、リリゼットが出られないときは起きない。マイバッグがいっぱいだとイベントが起きない。 | > a01,b01
a01 examine - | 【「傾ぐ天秤」まで進めている】バタリア丘陵(H-5)の禁断の口のそばの青く光る???を調べ、イベントを見る | ロランベリー耕地(H-6)・ソロムグ原野(K-9)の口でも、〔Ｓ〕の口でもよい。前の節と同じ???を続けて調べてよい。 | @バタリア丘陵 H-5 | T obj.バタリア丘陵.???_Maw | R 「傾ぐ天秤」まで進めている | > a02
a02 go - | ウォークオブエコーズ（パシュハウ沼〔Ｓ〕・グロウベルグ〔Ｓ〕につながる側）に移ると完了 | - | @ウォークオブエコーズ | R 「傾ぐ天秤」まで進めている | >
b01 go - | 【まだ「傾ぐ天秤」まで進めていない】アルタナミッション8「天涯の娘」まで進める | BF「紫電、劈く」を済ませたところから。 | R まだ「傾ぐ天秤」まで進めていない | > b02
b02 go - | 南サンドリア〔Ｓ〕に入り、イベントを見て「露光蟲」と「盟-リリゼットII」をもらうと完了 | ホームポイントやサバイバルガイドで入ってもよい。起きないときは、先に禁断の口のそばの青く光る???を調べてから入り直す。 | @南サンドリア〔Ｓ〕 | R まだ「傾ぐ天秤」まで進めていない | >

@ mission.rov.035 https://wiki.ffo.jp/html/34176.html
Q Sacrifice | 犠牲の上に | no | T obj.ウォークオブエコーズ.Ornate_Door
MN RoV2-17 34
LK condition:前節「仮面の一味」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-17;アルタナ45 まで済ませていればパシュハウ沼〔Ｓ〕J-9 かグロウベルグ〔Ｓ〕F-5 から、そうでなければ Cavernous Maw の横の光る ???（バタリア丘陵 H-5・ロランベリー耕地 H-6・ソロムグ原野 K-9）で Lightsworm をかざしてウォークオブエコーズへ。階段の上の Ornate Door。次の節のあとは町へ戻る手段がないのでデジョンなどを持って行く（FFXIclopedia：ザルカバード〔Ｓ〕側からは入れない）
g01 go - | ウォークオブエコーズに入る | 前の節のあとそのまま中にいれば、次の手順へ。次の節が終わると町へ戻る手段がないので、デジョンなど町へ戻る手段を持って行く。ザルカバード〔Ｓ〕側からは入れない。 | > a01,b01
a01 examine - | 【露光蟲で入る】バタリア丘陵(H-5)の禁断の口のそばの青く光る???を調べ、露光蟲をかざしてウォークオブエコーズに入る | ロランベリー耕地(H-6)・ソロムグ原野(K-9)の口でもよい。 | @バタリア丘陵 H-5 | T obj.バタリア丘陵.???_Maw | R 露光蟲で入る | > g02
b01 examine - | 【「傾ぐ天秤」まで進めている】パシュハウ沼〔Ｓ〕(J-9)のVeridical Confluxからウォークオブエコーズに入る | グロウベルグ〔Ｓ〕(F-5)のVeridical Confluxからでもよい。 | @パシュハウ沼〔Ｓ〕 J-9 | T obj.パシュハウ沼〔Ｓ〕.Veridical_Conflux | R 「傾ぐ天秤」まで進めている | > g02
g02 examine - | 北の階段を上った先のOrnate Doorを調べてイベントを見ると、グロウベルグ〔Ｓ〕(F-5)に移って完了 | 幽境の沢の幽門石のそばに出る。調べる前にウォークオブエコーズを出たら、禁断の口のそばの???からもう一度入る。 | @ウォークオブエコーズ | T obj.ウォークオブエコーズ.Ornate_Door

@ mission.rov.036 https://wiki.ffo.jp/html/34177.html
Q Somber Dreams | 理外の鯨 | no | T obj.グロウベルグ〔Ｓ〕.???_Cetus = obj:???@グロウベルグ〔Ｓ〕 F-5
MN RoV2-18 35
RW title:深淵を覗く者
LK condition:前節「犠牲の上に」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-18;グロウベルグ〔Ｓ〕の幽境の沢で、Veridical Conflux の北東の青く光る ???（すぐ横のものではない）を調べると Cetus。倒したらもう一度調べてイベント、Veridical Conflux の横の ??? からウォークオブエコーズに入るとイベントで称号 Abyssal Purveyor。エーテリックプルのあとドレッドスパイク（FFXIclopedia：Lv90以上、遠隔のフェイスがよい）
g01 examine - | フェイスを先に呼んでから、グロウベルグ〔Ｓ〕(F-5)の青く光る???を調べ、Cetusを出す | Veridical Confluxのすぐ横の???ではなく、北東のもの。前の節のあと目の前にある。 | @グロウベルグ〔Ｓ〕 F-5 | T obj.グロウベルグ〔Ｓ〕.???_Cetus
g02 defeat - | Cetusを倒す | エコーロケーション（前方範囲・静寂）を使う。HPが減るとエーテリックプル（範囲MP吸収）のあとドレッドスパイクになり、殴るとHPを吸われるので、手数の多いジョブは気をつける。盾は必ず。テンゼンIIやシャントットなど遠くから攻めるフェイスがよい。IL装備なら一人でも倒せる。 | @グロウベルグ〔Ｓ〕 F-5 | T mob.グロウベルグ〔Ｓ〕.Cetus = mob:Cetus@グロウベルグ〔Ｓ〕 F-5
g03 examine - | もう一度???を調べてイベントを見る | - | @グロウベルグ〔Ｓ〕 F-5 | T obj.グロウベルグ〔Ｓ〕.???_Cetus
g04 examine - | Veridical Confluxのすぐ横の???からウォークオブエコーズに入り、イベントを見て称号をもらうと完了 | 幽門石から入れないときはすぐ隣の???から。ザルカバード〔Ｓ〕から入ってもよい。デジョンなどを持って来ていれば、終わったら町へ戻る。 | @グロウベルグ〔Ｓ〕 F-5 | T obj.グロウベルグ〔Ｓ〕.???_WoE = obj:???@グロウベルグ〔Ｓ〕 F-5

@ mission.rov.037 https://wiki.ffo.jp/html/34178.html
Q Of Light and Darkness | ヴァナ・ディールの光と闇 | no | T obj.252.Oaken_Door
MN RoV2-19 36
LK condition:前節「理外の鯨」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-19;ノーグの Gilgamesh の Oaken Door（FFXIclopedia も同じ。このあとはリリゼットがいなくてもよい）
g01 examine - | ノーグ(K-8)のOaken Doorを調べてイベントを見ると完了 | このあとはアルタナミッションを「忘らるる君へ」の手前まで進めてもよい。 | @ノーグ K-8 | T obj.252.Oaken_Door

@ mission.rov.038 https://wiki.ffo.jp/html/34179.html
Q Temporary Farewells | 長いお別れ | no | T obj.25.???_G-5 = obj:???@ミザレオ海岸 G-5
MN RoV2-20 37
LK condition:前節「ヴァナ・ディールの光と闇」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-20;ミザレオ海岸 G-5 の Undulating Confluence の横の光る ???。ホームポイントから川ぞいに橋の方へ（FFXIclopedia も同じ G-5）
g01 go - | ミザレオ海岸(G-5)へ行く | ミザレオ海岸のホームポイント#1を開けていれば早い。サバイバルガイドから北へ歩いてもよい。次の節で使う品を先に調べておくと、行き来が少なくて済む。 | @ミザレオ海岸 G-5
g02 examine - | エスカ-ル・オンの入口（Undulating Confluence）の近くの青く光る???を調べてイベントを見ると完了 | - | @ミザレオ海岸 G-5 | T obj.25.???_G-5

@ mission.rov.039 https://wiki.ffo.jp/html/34180.html
Q Brushing Up | ディスティニー | no | T obj.25.???_G-5
MN RoV2-21 38
LK condition:前節「長いお別れ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-21;ミザレオ海岸の Undulating Confluence の横の ??? をもう一度調べてイベント（FFXIclopedia：G-5。稽古の選択で次の節の品が決まる。strength は Beef Stewpot、endurance は Zaru Soba、style は Spicy Cracker 30。Curio Vendor Moogle でそれぞれ 15,000・15,000・13,500 ギル）
g01 examine - | ミザレオ海岸(G-5)の青く光る???をもう一度調べ、イベントを見る | 前の節と同じ???。 | @ミザレオ海岸 G-5 | T obj.25.???_G-5
g02 go - | イベントの中で稽古の内容を選ぶと完了 | 選んだ稽古で次の節に要る品が決まる。筋力アップは牛鍋1つ、体力アップは笊蕎麦1つ、スタイルアップ大作戦はからしせんべい30枚。どれも三国のCurio Vendor Moogleで買える（牛鍋・笊蕎麦は15,000ギル、からしせんべいは30枚で13,500ギル）。自分で作るならからしせんべいが楽。 | @ミザレオ海岸 G-5

@ mission.rov.040 https://wiki.ffo.jp/html/34181.html
Q Keep On Giving | イロハの特訓 | no | T obj.25.???_G-5
MN RoV2-22 39
LK condition:前節「ディスティニー」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-22;イロハに頼まれた食べ物をミザレオ海岸の ??? にトレード。strength は Beef Stewpot（15,000）、style は Spicy Cracker 30（1つ450、計13,500）、endurance は Zaru Soba（15,000）。どれも Curio Vendor Moogle で買える（FFXIclopedia：G-5。最後の質問でアルタナの助けの選択肢を選ぶとイベントが終わる）
g01 go - | 前の節で選んだ稽古の品を用意する | 星唄の煌めき【四奏】を持っていれば、三国のCurio Vendor Moogleで買える。HQ品は受け取ってもらえない。 | > a01,b01,c01
a01 gather - | 【筋力アップ】牛鍋を1つ用意する | Curio Vendor Moogleで15,000ギル。 | R 筋力アップ | > g02
b01 gather - | 【体力アップ】笊蕎麦を1つ用意する | Curio Vendor Moogleで15,000ギル。 | R 体力アップ | > g02
c01 gather - | 【スタイルアップ大作戦】からしせんべいを30枚用意する | Curio Vendor Moogleで1枚450ギル（30枚で13,500ギル）。 | R スタイルアップ大作戦 | > g02
g02 go - | ミザレオ海岸(G-5)へ行く | ミザレオ海岸のホームポイント#1が近い。 | @ミザレオ海岸 G-5
g03 trade - | 青く光る???に用意した品をトレードしてイベントを見ると完了 | 最後の質問でアルタナの助けについての選択肢を選ぶとイベントが終わる。その前の2つを選ぶと話が少し増える。 | @ミザレオ海岸 G-5 | T obj.25.???_G-5

@ mission.rov.041 https://wiki.ffo.jp/html/34182.html
Q Past Imperfect | 累々たる想い | no | T obj.252.Oaken_Door
MN RoV2-23 40
LK condition:前節「イロハの特訓」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-23;ノーグの Oaken Door でイベント。ジラートミッション3「Kazham's Chieftainess」を受けているときは、カザム J-9 の Jakoh Wahcondalo に話してからもう一度 Oaken Door。ジラートの進み具合で止まることがある（FFXIclopedia：Welcome t'Norg のイベントが出たらもう一度調べる）
g01 examine - | ノーグ(K-8)のOaken Doorを調べてイベントを見る | ジラートミッション「海賊の巣窟ノーグ」のイベント（カザムの族長に会ってからウガレピ寺院へ、という話）が出たときは、もう一度調べる。 | @ノーグ K-8 | T obj.252.Oaken_Door | > a01,b01
a01 go - | 【ジラートミッション「カザム族長」を受けていない】そのままイベントを見終わると完了 | - | R 「カザム族長」を受けていない | >
b01 talk - | 【ジラートミッション「カザム族長」を受けている】カザム(J-9)のJakoh Wahcondaloに話す | - | @カザム J-9 | T npc.250.Jakoh_Wahcondalo | R 「カザム族長」を受けている | > b02
b02 examine - | もう一度ノーグ(K-8)のOaken Doorを調べてイベントを見ると完了 | - | @ノーグ K-8 | T obj.252.Oaken_Door | R 「カザム族長」を受けている | >

@ mission.rov.042 https://wiki.ffo.jp/html/34183.html
Q The Cursed Temple | 呪われし寺院 | no | T obj.159.Granite_Door_J-6
MN RoV2-24 41
LK condition:前節「累々たる想い」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-24;ジラートミッション4「The Temple of Uggalepih」を済ませていないと Granite Door のイベントは起きない。ヨアトル大森林 J-11 からウガレピ寺院に入るとイベント（サバイバルガイド、ユニティワープ122、怨念洞のホームポイント#1とエスケプでもよい）。MAP1 J-7 の Granite Door から隠れた道を J-3 まで進んでヨアトル大森林 J-9 に出て、右へ右へと進んで寺院に入り直し、左へ左へと進んで MAP3 J-6 の Granite Door（FFXIclopedia も同じ。これで Wisdom of Our Forefathers も済み Where Divinities Collide になる。テレポの魔法を持って行くと帰りが早い）
g01 go - | ウガレピ寺院に入り、イベントを見る | ノーグのサバイバルガイドから飛ぶと早い。ユニティワープでヨアトル大森林へ飛んで南へ歩いてもよい。起きなくても先へ進めることがある。帰りのためにテレポの魔法などがあると楽。 | @ウガレピ寺院 | > a01,b01
a01 go - | 【ジラートミッション「ウガレピ寺院」を済ませている】MAP1(J-7)のGranite Doorを抜け、地図に出ない道を北へ進んで、(J-3)の階段の上からヨアトル大森林に出る | 呪われたカギは要らない。入口の階段を下りて左、また左へと道なりに進むとJ-7のGranite Doorに着く。 | @ウガレピ寺院 J-7 #1 | R 「ウガレピ寺院」を済ませている | > a02
a02 go - | 寺院の外のテラスを右へ右へと進み、もう一つの入口からウガレピ寺院のMAP3に入り直す | 入り直したところのトンベリとハチは周りより強く、見ただけで襲ってくる。 | @ヨアトル大森林 J-9 | R 「ウガレピ寺院」を済ませている | > a03
a03 examine - | 左手の壁に沿って進み、MAP3(J-6)のGranite Doorを調べてイベントを見ると完了 | インビジがあると楽。次の節「先人の知恵」も済んで「神々の住まう地」になる。 | @ウガレピ寺院 J-6 #3 | T obj.159.Granite_Door_J-6 | R 「ウガレピ寺院」を済ませている | >
b01 go - | 【まだジラートミッション「ウガレピ寺院」を済ませていない】ジラートミッション「ウガレピ寺院」を済ませると完了 | ジラートを始めていなくても30〜45分ほどで済む。次の節「先人の知恵」になる。 | R まだ「ウガレピ寺院」を済ませていない | >

@ mission.rov.043 https://wiki.ffo.jp/html/34184.html
Q Wisdom of Our Forefathers | 先人の知恵 | no | T obj.159.Granite_Door_J-6
MN RoV2-25 42
LK condition:前節「呪われし寺院」クリア。ジラートミッション「ウガレピ寺院」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-25;Granite Door を調べるとイベントで完了（FFXIclopedia：MAP3 J-6。前の節と同じ道順）
g01 go - | ウガレピ寺院のMAP3に入る | MAP1(J-7)のGranite Doorから地図に出ない道を北へ進み、(J-3)からヨアトル大森林に出て、テラスを右へ右へと進むともう一つの入口からMAP3に入れる。前の節でGranite Doorのイベントを見ていれば、この節は飛ばされる。 | @ウガレピ寺院 #3
g02 examine - | MAP3(J-6)のGranite Doorを調べてイベントを見ると完了 | 左手の壁に沿って進む。インビジがあると楽。 | @ウガレピ寺院 J-6 #3 | T obj.159.Granite_Door_J-6

@ mission.rov.044 https://wiki.ffo.jp/html/34185.html
Q Where Divinities Collide | 神々の住まう地 | no
MN RoV2-26 43
LK condition:前節「先人の知恵」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-26;ホラ・デム・メアの岩のどれかの Shattered Telepoint から転移の間に入るとイベント（FFXIclopedia も同じ。Visions of Dread も同時に済む）
g01 go - | ホラの岩・デムの岩・メアの岩のどれかへ行く | テレポの魔法やデムの指輪などがあると楽。 | > a01,b01,c01
a01 examine - | 【ホラの岩】ラテーヌ高原のホラの岩のShattered Telepointを調べ、転移の間に入ってイベントを見ると完了 | 次の「石の見せる夢」も続けて済む。 | @ラテーヌ高原 | T obj.102.Shattered_Telepoint | R ホラの岩 | >
b01 examine - | 【デムの岩】コンシュタット高地のデムの岩のShattered Telepointを調べ、転移の間に入ってイベントを見ると完了 | 次の「石の見せる夢」も続けて済む。 | @コンシュタット高地 | T obj.108.Shattered_Telepoint | R デムの岩 | >
c01 examine - | 【メアの岩】タロンギ大峡谷のメアの岩のShattered Telepointを調べ、転移の間に入ってイベントを見ると完了 | 次の「石の見せる夢」も続けて済む。 | @タロンギ大峡谷 | T obj.117.Shattered_Telepoint | R メアの岩 | >

@ mission.rov.045 https://wiki.ffo.jp/html/34186.html
Q Visions of Dread | 石の見せる夢 | no
MN RoV2-27 44
LK condition:前節「神々の住まう地」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-27;転移の間でイベント（FFXIclopedia：前の節と同時に済む）
g01 go - | 前の節のイベントに続いて、転移の間でイベントを見ると完了 | 前の節と同時に済む。何もしなくてよい。

@ mission.rov.046 https://wiki.ffo.jp/html/34187.html
Q To the Skies | 羽ばたくセイレーン | no | T obj.252.Oaken_Door
MN RoV2-28 45
LK condition:前節「石の見せる夢」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-28;ノーグの Oaken Door でイベント（FFXIclopedia も同じ）
g01 examine - | ノーグ(K-8)のOaken Doorを調べてイベントを見ると完了 | - | @ノーグ K-8 | T obj.252.Oaken_Door

@ mission.rov.047 https://wiki.ffo.jp/html/34188.html
Q Escha - Ru'Aun | エスカ-ル・オン（ミッション） | no | T obj.25.Undulating_Confluence = obj:Undulating Confluence@ミザレオ海岸 G-5
MN RoV2-29 46
LK condition:前節「羽ばたくセイレーン」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-29;ミザレオ海岸 G-5 の Undulating Confluence でイベント、もう一度調べてエスカ-ル・オンに入るとイベント。ホームポイントからすぐ（FFXIclopedia も同じ G-5）
g01 go - | ミザレオ海岸(G-5)へ行く | ミザレオ海岸のホームポイント#1のすぐ横。 | @ミザレオ海岸 G-5
g02 examine - | Undulating Confluenceを調べてイベントを見る | - | @ミザレオ海岸 G-5 | T obj.25.Undulating_Confluence
g03 examine - | もう一度Undulating Confluenceを調べてエスカ-ル・オンに入り、イベントを見ると完了 | - | @ミザレオ海岸 G-5 | T obj.25.Undulating_Confluence

@ mission.rov.048 https://wiki.ffo.jp/html/34189.html
Q The Decisive Heroine | イロハの決意 | no | T obj.289.qqq_bell
MN RoV2-30 47
RW key_item:星唄の煌めき【五奏】
RW key_item:セイレーンの風切り羽根
LK condition:前節「エスカ-ル・オン」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-30;入口から坂を北へ上り、最初の分かれ道を左（西北西、H-10）へ。階段の上の青い ??? でイベント、Siren's plume（FFXIclopedia：H-10 の南西のすみ。Rhapsody in Emerald で経験値とリミットポイント30%増し、Curio Vendor Moogle の品が増える）
g01 go - | エスカ-ル・オンの入口から坂を北へ上り、最初の分かれ道を左（西）へ進む | 前の節のあとは入口にいる。 | @エスカ-ル・オン H-10
g02 examine - | 下り階段のすぐ手前の青く光る???を調べてイベントを見て、だいじなもの「星唄の煌めき【五奏】」と「セイレーンの風切り羽根」をもらうと完了 | エスカンドロップがもらえる???とは別のもの。経験値とリミットポイントが30%増え、Curio Vendor Moogleの品が増える。 | @エスカ-ル・オン H-10 | T obj.289.qqq_bell

@ mission.rov.049 https://wiki.ffo.jp/html/34190.html
Q Fall from Grace | 急転直下 | no
MN RoV2-31 48
LK condition:前節「イロハの決意」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-31;ホラ・デム・メアの岩のどれかの Shattered Telepoint を調べるとイベント（FFXIclopedia も同じ）
g01 go - | ホラの岩・デムの岩・メアの岩のどれかへ行く | 前と違う岩でもよい。 | > a01,b01,c01
a01 examine - | 【ホラの岩】ラテーヌ高原のホラの岩のShattered Telepointを調べてイベントを見ると完了 | - | @ラテーヌ高原 | T obj.102.Shattered_Telepoint | R ホラの岩 | >
b01 examine - | 【デムの岩】コンシュタット高地のデムの岩のShattered Telepointを調べてイベントを見ると完了 | - | @コンシュタット高地 | T obj.108.Shattered_Telepoint | R デムの岩 | >
c01 examine - | 【メアの岩】タロンギ大峡谷のメアの岩のShattered Telepointを調べてイベントを見ると完了 | - | @タロンギ大峡谷 | T obj.117.Shattered_Telepoint | R メアの岩 | >

@ mission.rov.050 https://wiki.ffo.jp/html/34191.html
Q Banishing the Darkness | 虚ろ晴れし日 | no | T obj.252.Oaken_Door
MN RoV2-32 49
LK condition:前節「急転直下」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-32;ノーグの Gilgamesh の Oaken Door でイベント。プロマシアミッション 3-5 Darkness Named・5-3 Three Paths・6-1 For Whom the Verse is Sung・6-2 A Place to Return・6-3 More Questions than Answers を受けているあいだは起きない（FFXIclopedia も同じ Oaken Door）
g01 examine - | ノーグ(K-8)のOaken Doorを調べてイベントを見ると完了 | プロマシアミッション「神を名乗りて」「みっつの道」「歌うは誰がため」「ゐぬる場所」「望むはあらゆる答え」を受けているあいだは起きない。そのときはプロマシアミッションを「畏れよ、我を」まで進めてから、もう一度調べる。 | @ノーグ K-8 | T obj.252.Oaken_Door

@ mission.rov.051 https://wiki.ffo.jp/html/34192.html
Q Over the Rainbow | 虹の向こう | no | T npc.239.Shantotto
MN RoV2-33 50
RW key_item:魔法人形「ワルノリくん」
LK condition:前節「虚ろ晴れし日」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-33;ウィンダス石の区のホームポイント#3から、シャントット邸（K-7）の Shantotto に話すとイベント、Most curious curio（FFXIclopedia も同じ K-7）
g01 talk - | ウィンダス石の区(K-7)のShantottoに話し、イベントを見て、だいじなもの『魔法人形「ワルノリくん」』をもらうと完了 | ウィンダス石の区のホームポイント#3が近い。 | @ウィンダス石の区 K-7 | T npc.239.Shantotto

@ mission.rov.052 https://wiki.ffo.jp/html/34193.html
Q Cacophonous Discord | 不協和音 | no | T obj.25.Undulating_Confluence
MN RoV2-34 51
LK condition:前節「虹の向こう」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-34;ミザレオ海岸の Undulating Confluence からエスカ-ル・オンに入るとイベント（FFXIclopedia も同じ。ゴブリンの足あとでの見直しでは「Both Paths Taken」と誤って出る）
g01 go - | ミザレオ海岸(G-5)へ行く | ミザレオ海岸のホームポイント#1のすぐ横。 | @ミザレオ海岸 G-5
g02 examine - | Undulating Confluenceを調べてエスカ-ル・オンに入り、イベントを見ると完了 | - | @ミザレオ海岸 G-5 | T obj.25.Undulating_Confluence

@ mission.rov.053 https://wiki.ffo.jp/html/34194.html
Q Eddies of Despair | 迷宮の渦 | no | T obj.289.???_Portal15 = obj:???@エスカ-ル・オン H-12
MN RoV2-35 52
LK condition:前節「不協和音」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-35;入口の左の ??? で Eschan Droplets をもらい、Eschan Portal で次へ。着いた先ごとに ??? を探して Droplets をもらい、#15 まで繰り返す。#15 の光る ??? でイベント。見つけにくいときは入口の ??? で取り直し、シルトを払ってポータルで戻ってもよい。夜は Eschan Limule が音、Eschan Murex が魔法とアビリティ、Eschan Amoeban が魔法に反応して襲ってくる
g01 go - | エスカ-ル・オンの奥のEschan Portal #15(H-12)へ行く | 夜は音や魔法に反応して襲ってくる敵がいるので、昼に動くか、スニークを使う。 | > a01,b01
a01 go - | 【#15まで開けてある】Eschan Portalでシルトを払って#15へ飛ぶ | - | R #15まで開けてある | > g02
b01 examine - | 【まだ#15まで開けていない】入口の左の???を調べ、エスカンドロップをもらう | - | @エスカ-ル・オン H-11 | T obj.289.???_Droplets = obj:???@エスカ-ル・オン H-11 | R まだ#15まで開けていない | > b02
b02 go - | Eschan Portal #1から#2へ飛び、着いた先の???でエスカンドロップを拾っては次のポータルへ飛ぶのを、#15まで繰り返す | ???は、#2・#5・#8・#11・#14は道の行き止まり（扉の横）、#3は最初の階段を上った右の柱のそば、#4は橋を渡った左の大きな柱のあいだ、#6は2つ目の階段の下を抜けた先の閉じた扉のある橋の上（G-6）、#7は2つ目の橋のすぐ左（F-5）、#9は階段を2つ上って左、水の上の橋を左へ渡ったところ、#10は橋を2つ渡った最後の足場の南西、#12は階段を2つ上って右、左の階段を通り過ぎた先（J-7）、#13は最初の橋を渡った左の大きな柱のそば。見つからないときは入口の???で取り直し、シルトを払ってポータルで元の場所へ戻ってもよい（2,800シルトほどあると楽）。 | @エスカ-ル・オン | R まだ#15まで開けていない | > g02
g02 examine - | #15(H-12)の光る???を調べてイベントを見ると完了 | 次の節はこの???を調べるとすぐ戦いになるので、続けて進めるならフェイスを先に呼んでおく。 | @エスカ-ル・オン H-12 | T obj.289.???_Portal15

@ mission.rov.054 https://wiki.ffo.jp/html/34195.html
Q Pretender to the Throne | 面汚し | no | T obj.289.???_Portal15
MN RoV2-36 53
RW item:盟-バラモア
RW title:享楽と悪意を退けし者
LK condition:前節「迷宮の渦」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-36;??? をもう一度調べると Balamor。ラストラフ（前方範囲のHP吸収）を繰り返すので後衛は離れる。負けたらエリアを出て入り直すと Most curious curio をもう一度もらえる。倒したらもう一度 ??? で Cipher: Balamor、称号 Banisher of the Profane。ポータルの横の ??? で Eschan Droplets、#15 から #1 へ戻れる（FFXIclopedia：BF ではなく調べるとすぐ戦いになる。出すと curio が Most confounding curio に変わる。強いバイオ。フェイス5人で一人でも倒せる）
g01 examine - | フェイスを先に呼んでから、#15(H-12)の光る???をもう一度調べ、Balamorを出す | 出すとだいじなもの『魔法人形「ワルノリくん」』が『魔力切れした「ワルノリくん」』に変わる。パーティで行くときは、全員が前の節のイベントを見ておく。 | @エスカ-ル・オン H-12 | T obj.289.???_Portal15
g02 defeat - | Balamorを倒す | 15分ほどで終わってしまう。火・光に極端に弱く、闇側の属性には強い。ラストラフ（前方範囲のHP吸収）をよく使い、途中からカーテンコール（自分のまわりのHP・MP・強化を吸収）も使う。強いバイオも入れてくる。通常攻撃が範囲なので、前衛は少なめにして、後衛は離れる。負けたらエスカ-ル・オンを出て入り直すと「ワルノリくん」が元に戻り、もう一度戦える。 | @エスカ-ル・オン H-12 | T mob.289.Balamor = mob:Balamor@エスカ-ル・オン H-12
g03 examine - | もう一度???を調べてイベントを見て、「盟-バラモア」と称号をもらうと完了 | マイバッグがいっぱいで盟を受け取れないと、イベントを見なかったことになる。 | @エスカ-ル・オン H-12 | T obj.289.???_Portal15
g04 examine - | （してもしなくてもよい）#15のEschan Portalの横の???を調べてエスカンドロップをもらい、#15から#1へ戻る | 戦わなくても、???を調べればこの道は使える。 | @エスカ-ル・オン H-12

@ mission.rov.055 https://wiki.ffo.jp/html/34196.html
Q Banished | 電撃 | no | T obj.252.Oaken_Door
MN RoV2-37 54
LK condition:前節「面汚し」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-37;ノーグの Oaken Door でイベント（FFXIclopedia も同じ）
g01 examine - | ノーグ(K-8)のOaken Doorを調べてイベントを見ると完了 | - | @ノーグ K-8 | T obj.252.Oaken_Door

@ mission.rov.056 https://wiki.ffo.jp/html/34197.html
Q Call of the Void | 澄んだ空の下 | no
MN RoV2-38 55
RW item:盟-セルテウス
LK condition:前節「電撃」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-38;どれかの岩の Dimensional Portal を調べるとイベント、Cipher: Selh'teus。もらえなかったら天象の鎖の Mystic Retriever。これをもらわないと先へ進めない（FFXIclopedia：プロマシアの進み具合にかかわらず天象の鎖へ移る）
g01 go - | ホラの岩・デムの岩・メアの岩のどれかへ行く | このあと「遥かな分岐点」が終わるまで、岩のDimensional Portalから天象の鎖へ行き来できる。 | > a01,b01,c01
a01 examine - | 【ホラの岩】ラテーヌ高原のホラの岩のDimensional Portalを調べ、イベントを見て天象の鎖に移り、「盟-セルテウス」をもらうと完了 | 盟をもらわないと先へ進めない。マイバッグがいっぱいで受け取れなかったときは、天象の鎖の光る靄（Mystic Retriever）を調べる。 | @ラテーヌ高原 | T obj.102.Dimensional_Portal = obj:Dimensional Portal@ラテーヌ高原 | R ホラの岩 | >
b01 examine - | 【デムの岩】コンシュタット高地のデムの岩のDimensional Portalを調べ、イベントを見て天象の鎖に移り、「盟-セルテウス」をもらうと完了 | 盟をもらわないと先へ進めない。マイバッグがいっぱいで受け取れなかったときは、天象の鎖の光る靄（Mystic Retriever）を調べる。 | @コンシュタット高地 | T obj.108.Dimensional_Portal = obj:Dimensional Portal@コンシュタット高地 | R デムの岩 | >
c01 examine - | 【メアの岩】タロンギ大峡谷のメアの岩のDimensional Portalを調べ、イベントを見て天象の鎖に移り、「盟-セルテウス」をもらうと完了 | 盟をもらわないと先へ進めない。マイバッグがいっぱいで受け取れなかったときは、天象の鎖の光る靄（Mystic Retriever）を調べる。 | @タロンギ大峡谷 | T obj.117.Dimensional_Portal = obj:Dimensional Portal@タロンギ大峡谷 | R メアの岩 | >

@ mission.rov.057 https://wiki.ffo.jp/html/34198.html
Q Both Paths Taken | 遥かな分岐点 | no | T obj.Transcendental_Radiance
MN RoV2-39 56
RW title:魂の眼を持つ者
LK condition:前節「澄んだ空の下」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-39;前へ歩いて Transcendental Radiance を調べ、BF で Disjoined One と戦う。15分、フェイス5人で一人でも勝てる。イロハは倒れても15秒で何度も起き上がる。出たら岩の Dimensional Portal で戻れる。称号 Spirit Seeker（FFXIclopedia：入ると Siren's plume が Motionless plume に変わる。6人まで、強化は消える、フェイスは入ってから呼ぶ。勝つとどれかの岩の Dimensional Portal のそばに出る。IL115以上がよい）
g01 go - | 前の節のイベントのあと、天象の鎖の入口にいる | 出てしまったときは、岩のDimensional Portalからもう一度入れる。 | @天象の鎖
g02 go - | 前へ歩いて扉の先の部屋に入る | 一度出て入り直すと別のイベントがある（あとで見直せる）。 | @天象の鎖
g03 examine - | Transcendental Radianceを調べてBFに入る | 入るとだいじなもの「セイレーンの風切り羽根」が「動きを止めた風切り羽根」に変わる。6人まで、制限時間15分。入ると強化が消えるので、フェイスは入ってから呼ぶ。 | @天象の鎖 | T obj.Transcendental_Radiance
g04 fight - | Disjoined Oneに勝つ | 片手剣のWSを使う暗黒騎士。イロハが手伝ってくれ、倒れても15秒ほどで何度も起き上がる。フェイス5人で一人でも勝てる。負けたら一度エリアを出て天象の鎖に入り直すと風切り羽根が元に戻り、もう一度挑める。 | @天象の鎖
g05 go - | イベントを見たあと、岩のDimensional Portalのそばに出ると完了 | 風切り羽根はなくなる。

@ mission.rov.058 https://wiki.ffo.jp/html/34199.html
Q The Man Behind the Mask | あわい | no | T obj.252.Oaken_Door
MN RoV2-40 57
RW key_item:星唄の煌めき【六奏】
LK condition:前節「遥かな分岐点」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-40;ノーグの Oaken Door でイベント、Rhapsody in Mauve（FFXIclopedia：経験値とリミットポイント30%増し、ユニティの功績30%増し、ヴォイドウォッチ・レギオン・アビセア・リンバス・カンパニエなどの待ち時間や値段が軽くなる）
g01 examine - | ノーグ(K-8)のOaken Doorを調べてイベントを見て、だいじなもの「星唄の煌めき【六奏】」をもらうと完了 | ユニティの功績が30%増え、ヴォイドウォッチ・レギオン・アビセア・リンバス・カンパニエなどの待ち時間や値段が軽くなる。Curio Vendor Moogleの品も増える。 | @ノーグ K-8 | T obj.252.Oaken_Door

@ mission.rov.059 https://wiki.ffo.jp/html/34200.html
Q Uncertain Futures | 時の溜り | no
MN RoV2-41 58
LK condition:前節「あわい」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_2-41;三国のモグハウスの出入り口があるエリアに入るとイベント、Song of hope（FFXIclopedia も同じ。これで Darkness Beckons になる）
g01 go - | 三国のモグハウスの出入り口があるエリアに入り、イベントを見ると完了 | だいじなもの「希望の唄」がもらえ、第3章になる。アルタナミッションの進み具合によっては、ここで露光蟲ももらえる。

@ mission.rov.060 https://wiki.ffo.jp/html/34949.html
Q Darkness Beckons | 叫ぶ闇 | no | T obj.醴泉島.Etched_Rock = obj:Etched Rock@醴泉島 K-9
MN RoV3-1 59
RW key_item:希望の唄
LK condition:前節「時の溜り」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-1;ホラ・デム・メアの岩の Dimensional Portal で醴泉島へ。着くとイベント。入口のゴブリン Shiftrix に話すと Oseem の強化が使える。醴泉島の地図（50シルト）と次の節の Mollifier（500シルト）も売っている。道なりに進んで K-9 の Etched Rock でイベント。ここから Ethereal Ingress が取れる。Cumulus Masque +1 を使うと #6 のそばに出る。醴泉島の敵はほとんど襲ってきて、見破りや聞き破りもいる（FFXIclopedia：インビジとスニークがあるとよい。H/I-5 の Hippogryph は見破り。HPが減ると襲ってくる敵もいる。全部走って6分ほど）
g01 go - | 三国のモグハウスの出入り口があるエリアに入り、イベントを見て、だいじなもの「希望の唄」をもらう | 前の節で受け取っていれば、次の手順へ。 | > g02
g02 go - | ホラの岩・デムの岩・メアの岩のどれかへ行く | - | > a01,b01,c01
a01 examine - | 【ホラの岩】ラテーヌ高原のホラの岩のDimensional Portalを調べ、「醴泉島」を選ぶ | - | @ラテーヌ高原 | T obj.102.Dimensional_Portal | R ホラの岩 | > g03
b01 examine - | 【デムの岩】コンシュタット高地のデムの岩のDimensional Portalを調べ、「醴泉島」を選ぶ | - | @コンシュタット高地 | T obj.108.Dimensional_Portal | R デムの岩 | > g03
c01 examine - | 【メアの岩】タロンギ大峡谷のメアの岩のDimensional Portalを調べ、「醴泉島」を選ぶ | - | @タロンギ大峡谷 | T obj.117.Dimensional_Portal | R メアの岩 | > g03
g03 go - | 醴泉島に着いてイベントを見る | - | @醴泉島 | > g04
g04 talk - | （してもしなくてもよい）入口のゴブリンShiftrixに話す | 話すとOseemの強化が使えるようになる。醴泉島地図（50シルト）と、次の節で使う退魔の神符（500シルト）も買っておくとよい。 | @醴泉島 | T npc.醴泉島.Shiftrix = npc:Shiftrix@醴泉島 | > g05
g05 go - | 道なりに進んで(K-9)のEtched Rockへ行く | 近道はない。ほとんどの敵が襲ってくるので、インビジとスニークを使う。H-5・I-5あたりのHippogryphは見破るので、道に立っていたら脇で待つ。HPが減っていると襲ってくる敵もいるので、HPを満タンにしておく。途中のEthereal Ingress（#2〜#6）を取っておくと、あとで楽。キュムラスマスク+1を使うと#6のそばに出られる。 | @醴泉島 K-9 | > g06
g06 examine - | Etched Rockを調べてイベントを見ると完了 | 近くのEthereal Ingress #6も取っておく。 | @醴泉島 K-9 | T obj.醴泉島.Etched_Rock

@ mission.rov.061 https://wiki.ffo.jp/html/34953.html
Q The Brewing Storm | 乱雲たちこめ | no | T mob.醴泉島.Perfervid_Naraka = mob:Perfervid Naraka@醴泉島 K-8 K-9
MN RoV3-2 60
LK condition:前節「叫ぶ闇」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-2;#6 の近くで夜（20:00〜4:00）に出る Perfervid Naraka を3体倒す。星唄の煌めき【六奏】があると、からんだときにLv107に下がる。倒すと Ascended Naraka が出ることがあるので Mollifier を持っておく。進めている人がパーティを抜けたりエリアを移ったりすると、戦っている途中でもLvとHPが元に戻る（FFXIclopedia：Etched Rock K-9 の近く。音とHPの減りに反応し、リンクしない。3体倒す前にエリアを移ると数え直し。黒いピクシーには弱くならない。シートは K-8・エリアを移っても数は消えない）
g01 go - | Etched Rock(K-9)から見える鳥居を抜けて、(K-8)のあたりへ行く | - | @醴泉島 K-8
g02 go - | 夜（ヴァナ時間20:00〜4:00）になるまで待つ | ナラカ族は夜だけ出る。 | @醴泉島 K-8
g03 defeat - | Perfervid Narakaを3体倒すと完了 | 進めている人がパーティにいると、からんだときに「とても楽な相手」まで弱くなる。進めている人がパーティを抜けたりエリアを移ったりすると、強さとHPが元に戻る。音とHPの減りに反応するが、リンクしないので1体ずつ釣る。たまに出るNM「Ascended Naraka」は弱くならないので、退魔の神符を持っておくとよい。まわりの黒いピクシーは弱くならないので近づかない。3体より多く倒さなくてよい。 | @醴泉島 K-8 K-9 | T mob.醴泉島.Perfervid_Naraka

@ mission.rov.062 https://wiki.ffo.jp/html/34954.html
Q The River Runs Red | 流るる血 | no | T obj.醴泉島.Etched_Rock
MN RoV3-3 61
RW key_item:星唄の煌めき【七奏】
RW other:だいじなもの「ロゼッタ石」（持っていないとき）
LK condition:前節「乱雲たちこめ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-3;K-9 の Etched Rock でイベント、Rhapsody in Fuchsia。Geomagnetron を持っていなければもらえ、もう合わせてあるので Darcia に話すだけで Adoulinian charter permit がもらえる（FFXIclopedia：醴泉島の祠に入る）
g01 examine - | 醴泉島(K-9)のEtched Rockを調べ、醴泉島の祠に入ってイベントを見て、だいじなもの「星唄の煌めき【七奏】」をもらうと完了 | ロゼッタ石を持っていなければ、ここでもらえる。 | @醴泉島 K-9 | T obj.醴泉島.Etched_Rock

@ mission.rov.063 https://wiki.ffo.jp/html/34955.html
Q The Crucible | 坩堝 | no
MN RoV3-4 62
LK condition:前節「流るる血」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-4;アドゥリンへ行くには The Geomagnetron を済ませる（前の節で品をもらっていればジュノ下層の Darcia に話すだけ）。三国のモグハウスの出入り口があるエリアに入るとイベント（しなくてもよい）。ケイザック古戦場に入るとイベント。アドゥリン 1-7 Meeting of the Minds を済ませていないと起きない（FFXIclopedia：Darcia H-7。Rumors from the West は自動で済む。アドゥリンの進み具合で Forward Thinking か Tears of the Generals になる）
g01 talk - | アドゥリンへ行けないときは、ジュノ下層(H-7)のDarciaに話してアドゥリンミッション「ロゼッタ石」を済ませる | もうアドゥリンへ行けるなら、次の手順へ。前の節でロゼッタ石をもらっていれば、話すだけで済む。 | @ジュノ下層 H-7 | T npc.245.Darcia
g02 go - | アドゥリンミッションを「十二家会」まで済ませる | 済ませていないと、ケイザック古戦場のイベントが起きない。 | > g03
g03 go - | （してもしなくてもよい）三国のモグハウスの出入り口があるエリアに入り、イベントを見る | ケイザック古戦場へ来るように言われる。見なくてもよい。 | > g04
g04 go - | ケイザック古戦場に入り、イベントを見ると完了 | ジュノ下層やアドゥリンのWaypoint、ホームポイントから入ってもよい。アドゥリンミッションが進んでいれば、次の「関所を越えよ」も続けて済む。 | @ケイザック古戦場

@ mission.rov.064 https://wiki.ffo.jp/html/34956.html
Q Forward Thinking | 関所を越えよ | no
MN RoV3-5 63
RW key_item:力を奪われた勾玉
LK condition:前節「坩堝」クリア。アドゥリンミッション「リフキンを統べるもの」まで進めている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-5;ケイザック古戦場に入るとイベント。Reisenjima Sanctorium orb が Drained orb に変わる（FFXIclopedia：アドゥリンが進んでいれば前の節と同時に済む）
g01 go - | アドゥリンミッションを「リフキンを統べるもの」を受けるところまで進める | 次の「悲しみのケイザック」を済ませるには、「オーダーサイン」まで進める必要がある。 | > g02
g02 go - | ケイザック古戦場に入り、イベントを見て、だいじなもの「力を奪われた勾玉」をもらうと完了 | 前の節で続けて済んでいれば、この節は飛ばされる。 | @ケイザック古戦場

@ mission.rov.065 https://wiki.ffo.jp/html/34957.html
Q Tears of the Generals | 悲しみのケイザック | no | T npc.257.Ploh_Trishbahk
MN RoV3-6 64
LK condition:前節「関所を越えよ」クリア。アドゥリンミッション「オーダーサイン」まで進めている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-6;東アドゥリンの Castle Adoulin gates の Ploh Trishbahk に話す。アドゥリン 2-2 An Aimless Journey を済ませていないと起きない。アドゥリン 3-6-3 Stonewalled・3-6-4 Salvation・4-5 Balamor, the Deathborne Xol・4-5-1 Anagnorisis・5-4-1 Abomination を受けているあいだは起きない（FFXIclopedia：Ortharsyne のあと。3-6-1 Kumhau・4-4 の途中・5-5 でも起きない）
g01 go - | アドゥリンミッションを「オーダーサイン」まで進める | 「標なき旅」を済ませていないと、話しても起きない。アドゥリンミッション「絶零公クムハウ」「第三の敵」「アシェラの下へ」「不死君バラモア」「悲劇の後」「神の化身」を受けているあいだも起きないので、先に進めてから話す。 | > g02
g02 talk - | 東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話し、イベントを見ると完了 | - | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk

@ mission.rov.066 https://wiki.ffo.jp/html/34958.html
Q What He Left Behind | 遺跡の奥に | no
MN RoV3-7 65
RW item:盟-アシェラII
RW other:アドゥリンの魔境ミッションの「心に宿る記憶」がすべて見られる
LK condition:前節「悲しみのケイザック」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-7;ララ水道 B-6 の Augural Conveyor の部屋の入口近くの床の光る ??? でイベント、Cipher: Arciela II。西アドゥリン F-5 の入口（Waypoint Adoulin Waterfront）から東へ進み、C-7 から B-6 に入る。Augural Conveyor が開いていれば Waypoint の enigmatic device で飛べる（FFXIclopedia：C-6 の南西のすみ。小さい橋を上ってすこし右。この盟をもらわないと先へ進めない）
g01 go - | ララ水道(B-6/C-6)のAugural Conveyorの部屋へ行く | 謎の魔導器が開いていれば、Waypointから飛ぶと早い。開いていなければ、アドゥリン港のWaypointから西アドゥリン(F-5)の入口に入り、Sluice Gateを過ぎて東、南、西と回り込む。スニークがあるとよい。着いたらAugural Conveyorを調べて開けておく。 | @ララ水道 B-6 C-6 | T obj.258.Augural_Conveyor
g02 examine - | 部屋の入口近くの床の青く光る???を調べてイベントを見て、「盟-アシェラII」をもらうと完了 | アジト跡の方ではなく、南の???。マイバッグがいっぱいで盟を受け取れないと先へ進めないので、もう一度調べる。 | @ララ水道 B-6 C-6 | T obj.258.???_RoV = obj:???@ララ水道 B-6 C-6

@ mission.rov.067 https://wiki.ffo.jp/html/34959.html
Q Gone but Not Forgotten | 遺されし力 | no | T obj.258.Sluice_Gate
MN RoV3-8 66
RW key_item:覇王のオーブ
LK condition:前節「遺跡の奥に」クリア。アドゥリンミッション「水門の奥へ」のBFの手前まで進めている
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-8;ララ水道の Sluice Gate から C-6 のアジトに入り、Inconspicuous Barrel で Founder king's orb（FFXIclopedia：アドゥリン 2-7 Predators and Prey を済ませ、2-7-1 Behind the Sluices を受けて Waterway facility crank を持っていること。Sluice Gate を調べてイベント、もう一度調べて入る）
g01 go - | アドゥリンミッション「水門の奥へ」を受け、だいじなもの「水道施設用クランク」を持っておく | クランクはララ水道(H-6)のStorage Containerでもらえる。 | > g02
g02 examine - | ララ水道(C-6)のSluice Gateを調べてイベントを見て、もう一度調べてアジト跡に入る | 西アドゥリン(F-5)の入口から入るとすぐ。 | @ララ水道 C-6 | T obj.258.Sluice_Gate | K 水道施設用クランク
g03 examine - | 入ってすぐ右のInconspicuous Barrelを調べ、だいじなもの「覇王のオーブ」をもらうと完了 | - | @ララ水道 | T obj.258.Inconspicuous_Barrel = obj:Inconspicuous Barrel@ララ水道

@ mission.rov.068 https://wiki.ffo.jp/html/34960.html
Q August Artifacts | 秘められしオーブ | no
MN RoV3-9 67
LK condition:前節「遺されし力」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-9;ララ水道の Augural Conveyor（C-6/B-6）の近くの ??? でイベント。前の節から走るならスニークだけでよい（FFXIclopedia：Augural Conveyor は B-6）
g01 go - | アジト跡から出て、ララ水道(B-6/C-6)のAugural Conveyorの近くへ戻る | Waypointで謎の魔導器からララ水道へ飛ぶと近い。走るならスニークがあればよい。 | @ララ水道 B-6 C-6
g02 examine - | 前の節と同じ青く光る???を調べてイベントを見ると完了 | - | @ララ水道 B-6 C-6 | T obj.258.???_RoV

@ mission.rov.069 https://wiki.ffo.jp/html/34961.html
Q Solemnity | 論客バラモア | no
MN RoV3-10 68
LK condition:前節「秘められしオーブ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-10;東アドゥリンのセレニア図書館に入るとイベント（FFXIclopedia：東アドゥリン F-10 の Eppel-Treppel から）
g01 talk - | （してもしなくてもよい）東アドゥリン(K-9)のアドゥリン城門前のPloh Trishbahkに話す | アシェラがセレニア図書館へ行ったと教えてくれる。 | @東アドゥリン K-9 | T npc.257.Ploh_Trishbahk | > g02
g02 go - | 東アドゥリンのセレニア図書館に入り、イベントを見ると完了 | 東アドゥリン(F-10)のあたりから入る。 | @セレニア図書館

@ mission.rov.070 https://wiki.ffo.jp/html/34962.html
Q Eyes on You | 眼前の道 | no
MN RoV3-11 69
LK condition:前節「論客バラモア」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-11;神々の間に入るとイベント。ロ・メーヴのサバイバルガイドからすぐ、ル・オンの庭から戻って入ってもよい。ヴォイドウォッチの NPC のワープでもよい。ユニティワープ Lv125 はロ・メーヴの南の入口（FFXIclopedia も同じ。どの入口からでもよい）
g01 go - | 神々の間に入り、イベントを見ると完了 | ロ・メーヴかル・オンの庭のサバイバルガイドから入ると早い。行ったことがなければ、ユニティのワープでロ・メーヴ（Lv125）へ飛び、北の真ん中の入口を目指す。イベントのあとCermet Grateの前に移る。 | @神々の間

@ mission.rov.071 https://wiki.ffo.jp/html/34963.html
Q Exploring the Ruins | リ・テロアを往く | no | T obj.251.Cermet_Grate
MN RoV3-12 70
LK condition:前節「眼前の道」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-12;目の前の Cermet Grate でイベント。このあとル・ルデの庭 H-5 の Jamal に話すとエンブレムの課題が出て、済ませると Ark の5人の盟がもらえる（FFXIclopedia も同じ Cermet Grate）
g01 examine - | 神々の間(H-6/H-7)の目の前のCermet Grateを調べてイベントを見ると完了 | 青水晶がなくても開けてもらえる。このあとル・ルデの庭(H-5)のJamalに話すと、Arkの5人の盟がもらえる課題が出る。 | @神々の間 H-6 H-7 | T obj.251.Cermet_Grate

@ mission.rov.072 https://wiki.ffo.jp/html/34964.html
Q Become Something More | 大いなるものを超えよ | no | T obj.醴泉島.Etched_Rock
MN RoV3-13 71
RW key_item:時空の羅針盤
LK condition:前節「リ・テロアを往く」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-13;醴泉島の祠に戻るとイベント、Dimensional compass。醴泉島へは岩の Dimensional Portal から（FFXIclopedia：K-9 の Etched Rock から入る。Curio Vendor Moogle で teleport ring が買える）
g01 go - | 岩のDimensional Portalから醴泉島へ行き、(K-9)のEtched Rockへ行く | Ethereal Ingress #6を取っていれば、そこへ飛ぶと早い。 | @醴泉島 K-9
g02 examine - | Etched Rockを調べて醴泉島の祠に入り、イベントを見て、だいじなもの「時空の羅針盤」をもらうと完了 | このあと三国のCurio Vendor Moogleで岩へ飛べる指輪が買えるようになる。 | @醴泉島 K-9 | T obj.醴泉島.Etched_Rock

@ mission.rov.073 https://wiki.ffo.jp/html/34965.html
Q Unshakable Nightmares | 蓄えられし悪夢 | no
MN RoV3-14 72
LK condition:前節「大いなるものを超えよ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-14;ウォークオブエコーズに入るとイベント。バタリア丘陵・ロランベリー耕地・ソロムグ原野（現代か過去）の Cavernous Maw の横の青い ???（Lightsworm が要る）、グロウベルグ〔Ｓ〕、パシュハウ沼〔Ｓ〕から入る。ザルカバード〔Ｓ〕から入ると次の節の場所と違う。Champion of the Dawn で止まると出たら、ザルカバード〔Ｓ〕から入ってそのクエストを進める（FFXIclopedia：現代で入る）
g01 go - | ウォークオブエコーズのミッションの側へ入る入口へ行く | ザルカバード〔Ｓ〕から入ってもイベントは起きるが、次の節の場所と違う。「暁よりの使者、再び」で止まると出たときは、先にそのクエストを進める。 | > a01,b01,c01
a01 examine - | 【禁断の口から入る】バタリア丘陵(H-5)の禁断の口のそばの青く光る???を調べ、ウォークオブエコーズに入ってイベントを見ると完了 | ロランベリー耕地(H-6)・ソロムグ原野(K-9)の口でも、〔Ｓ〕の口でもよい。露光蟲が要る。現代の口のそばにはサバイバルガイドがある。 | @バタリア丘陵 H-5 | T obj.バタリア丘陵.???_Maw | R 禁断の口から入る | K 露光蟲 | >
b01 examine - | 【アルタナミッション「夢見果てし時」まで進めている】グロウベルグ〔Ｓ〕(F-5)のVeridical Confluxからウォークオブエコーズに入り、イベントを見ると完了 | 「理外の鯨」で使った???からは入れない。 | @グロウベルグ〔Ｓ〕 F-5 | T obj.グロウベルグ〔Ｓ〕.Veridical_Conflux | R 「夢見果てし時」まで進めている | >
c01 examine - | 【クエスト「白水晶の輝き」まで進めている】パシュハウ沼〔Ｓ〕(J-9)のVeridical Confluxからウォークオブエコーズに入り、イベントを見ると完了 | - | @パシュハウ沼〔Ｓ〕 J-9 | T obj.パシュハウ沼〔Ｓ〕.Veridical_Conflux | R 「白水晶の輝き」まで進めている | >

@ mission.rov.074 https://wiki.ffo.jp/html/34967.html
Q What Remains of Hope | 望みを繋ぎ | no
MN RoV3-15 73
RW key_item:ケット・シーのヒゲ
LK condition:前節「蓄えられし悪夢」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-15;近くの白く光る ???（東、遠くの空に Atomos が見える方）でイベント、Desuetia - Empyreal Paradox に移って Cait Sith's whisker。ザルカバード〔Ｓ〕から入ったときは場所が違う（FFXIclopedia：Veridical Conflux の北東の ???）
g01 go - | ウォークオブエコーズに入る | - | @ウォークオブエコーズ
g02 examine - | 入ったところから東（北東）の白く光る???を調べ、イベントを見る | 大きな紫の階段は上らない。ケット・シーに準備ができたか聞かれる。 | @ウォークオブエコーズ | T obj.ウォークオブエコーズ.???_White = obj:???@ウォークオブエコーズ
g03 go - | 「はい」と答えてデスエチア-天象の鎖に移り、イベントを見て、だいじなもの「ケット・シーのヒゲ」をもらうと完了 | - | @デスエチア-天象の鎖

@ mission.rov.075 https://wiki.ffo.jp/html/34968.html
Q Death Cares Not | 死を死を死を | no | T obj.デスエチア-天象の鎖.Transcendental_Radiance = obj:Transcendental Radiance@デスエチア-天象の鎖
MN RoV3-16 74
LK condition:前節「望みを繋ぎ」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-16;Transcendental Radiance でイベント（FFXIclopedia：Desuetia - Empyreal Paradox）
g01 examine - | まっすぐ進んでTranscendental Radianceを調べ、イベントを見ると完了 | 次の節はここから戦いになるので、準備しておく。 | @デスエチア-天象の鎖 | T obj.デスエチア-天象の鎖.Transcendental_Radiance

@ mission.rov.076 https://wiki.ffo.jp/html/34969.html
Q No Time like the Future | 未来を導く | no | T obj.デスエチア-天象の鎖.Transcendental_Radiance
MN RoV3-17 75
LK condition:前節「死を死を死を」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-17;もう一度 Transcendental Radiance で BF、Sempurne。アビセア-天象の鎖の Shinryu の弱い版で、技は同じだが、技や魔法の構え中に殴られてHPを戻すことはない。IL装備の前衛ならフェイスと一人で勝てる。負けたら BF の外の Cait Sith からもう一度 whisker（FFXIclopedia：HP約100,000。Mighty Guard を使い、青魔道士が覚えられる。状態異常を治す薬を持って行く。パーティで入ってから抜けてフェイスを呼んでもよい）
g01 examine - | もう一度Transcendental Radianceを調べてBFに入る | 負けたら、BFの入口の近くのケット・シーに話すと「ケット・シーのヒゲ」をまたもらえる。 | @デスエチア-天象の鎖 | T obj.デスエチア-天象の鎖.Transcendental_Radiance
g02 fight - | Sempurneに勝つと完了 | アビセア-天象の鎖のShinryuの弱い版で、技は同じだが、構えのあいだに殴ってもHPは戻らない。HPは約10万。Mighty Guardを使い、青魔道士はラーニングできる。状態異常を治す薬を持って行く。IL装備の前衛ならフェイスと一人でも勝てる。パーティで入ってから抜け、フェイスを呼んでもよい。 | @デスエチア-天象の鎖

@ mission.rov.077 https://wiki.ffo.jp/html/34970.html
Q Sin | 罪深き決断 | no | T obj.デスエチア-天象の鎖.Transcendental_Radiance
MN RoV3-18 76
LK condition:前節「未来を導く」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-18;BF のあともう一度 Transcendental Radiance を調べると長いイベント。あとで見直すときは醴泉島の Goblin Footprint の「Penance」（FFXIclopedia：イベントは10分以上）
g01 examine - | BFに勝ったあと、もう一度Transcendental Radianceを調べてイベントを見ると完了 | イベントは10分以上あり、そのまま次の節に続く。途中で切れて醴泉島に移らなかったときは、歩いて醴泉島へ行くと続きが始まる。見のがしたところはGoblin Footprintで「罪深き決断(3)」か「罪深き決断(4)」として見直せる。 | @デスエチア-天象の鎖 | T obj.デスエチア-天象の鎖.Transcendental_Radiance

@ mission.rov.078 https://wiki.ffo.jp/html/34971.html
Q Penance | 償うためには | no
MN RoV3-19 77
LK condition:前節「罪深き決断」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-19;前の節のイベントを見ているあいだに済む。称号 The Decider と Rhapsody in Puce はこの節の終わり（FFXIclopedia：途中で切れたらデスエチア-天象の鎖に入り直す）
g01 go - | 前の節から続くイベントを見る（醴泉島に移り、デスエチア-天象の鎖に戻る）と完了 | 途中で切れたときは、醴泉島の入口のすぐそば(F-12)のResume Pointを調べるとデスエチア-天象の鎖に戻り、続きになる。だいじなもの「星唄の煌めき【八奏】」と称号「裁定者」は次の節で付く。 | @デスエチア-天象の鎖

@ mission.rov.079 https://wiki.ffo.jp/html/34972.html
Q Vessel of Light | 心の資格 | no
MN RoV3-20 78
RW key_item:星唄の煌めき【八奏】
RW title:裁定者
LK condition:前節「償うためには」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-20;もう一度岩の Dimensional Portal から醴泉島の祠へ行くとイベント（FFXIclopedia：醴泉島の祠に入るとイベント）
g01 go - | 前の節から続くイベントを見て、だいじなもの「星唄の煌めき【八奏】」をもらう | イベントはデスエチア-天象の鎖で続く。 | @デスエチア-天象の鎖
g02 go - | 岩のDimensional Portalから醴泉島へ行き、(K-9)のEtched Rockへ行く | Ethereal Ingress #6を取っていれば、そこへ飛ぶと早い。 | @醴泉島 K-9
g03 examine - | Etched Rockを調べて醴泉島の祠に入り、イベントを見ると完了 | - | @醴泉島 K-9 | T obj.醴泉島.Etched_Rock

@ mission.rov.080 https://wiki.ffo.jp/html/34973.html
Q The Lifestream of Reisenjima | 醴泉島の地脈 | no
MN RoV3-21 79
LK condition:前節「心の資格」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-21;醴泉島 H-5 の大きな遺跡の近くの丘の ??? でイベント。Tribulens の話が出たら別の ???（丘の下の方）。Ethereal Ingress #5 から西へ、見破る Hippogryph に注意。プロマシアミッション8-1・8-4（最後のイベントの前）のあいだは見られない（FFXIclopedia：H-5。次の節の討伐はこのイベントのあとから数える）
g01 go - | 醴泉島のEthereal Ingress #5から道なりに西へ進み、(H-5)の黒っぽい遺跡の近くへ行く | まわりに見破るHippogryphがいる。プロマシアミッション「願わくば闇よ」を受けてからプロミヴォン-ヴァズでTenzenを助けるまでと、「暁」のBFに勝ってから最後のイベントを見るまでのあいだは、この節を進められない。 | @醴泉島 H-5
g02 examine - | 遺跡のすぐ横の丘の上の???を調べ、イベントを見ると完了 | 丘の下の方の???（ギアスフェット用）とは別のもの。 | @醴泉島 H-5 | T obj.醴泉島.???_H-5 = obj:???@醴泉島 H-5

@ mission.rov.081 https://wiki.ffo.jp/html/34974.html
Q From West to East | 風向きは東 | no | T mob.醴泉島.Obstreperous_Panopt = mob:Obstreperous Panopt@醴泉島 F-11
MN RoV3-22 80
LK condition:前節「醴泉島の地脈」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-22;Obstreperous Panopt を11体倒す。Ethereal Ingress #1 のすぐ北の F-11 に多い。Ascended Panopt が出ないように Shiftrix で Mollifier を買っておく。エリアを移ると数え直し。星唄の煌めき【七奏】でLv112に下がる。エミネンス・レコードの醴泉島の戦闘（10体）と同時に進められる（FFXIclopedia：F-11。E-11 の ??? のあたりは開けていて釣りやすい。属性を吸う構えがあるので魔法のフェイスは避ける。Ascended Panopt も数に入る。11体倒したあとならエリアを移ってもよい。シート：Ethereal Ingress #1〜#2 のあいだに多く、#2 の南西 E-10 の橋の北にパノプトだけが3体、橋は安全）
g01 go - | 醴泉島のEthereal Ingress #1のすぐ北、(F-11)のあたりへ行く | 先にShiftrixで退魔の神符を買っておくと、NM「Ascended Panopt」が出ない。エミネンス・レコード「戦闘：醴泉島1」（10体）も受けておくとよい。 | @醴泉島 F-11
g02 defeat - | エリアを移らずに、Obstreperous Panoptを11体倒すと完了 | 倒すたびに残りの数が出る。エリアを移ると0に戻る（11体倒したあとなら移ってもよい）。進めている人がパーティにいると弱くなる。「Ascended Panopt」も数に入るが、弱くならない。目が緑のあいだは魔法を吸うので、精霊魔法を使うフェイスは呼ばない。Ethereal Ingress #2の南西(E-10)の橋の北にはパノプトだけが3体いて、橋の上は安全。(E-11)の???のあたりも開けていて釣りやすい。 | @醴泉島 F-11 | T mob.醴泉島.Obstreperous_Panopt

@ mission.rov.082 https://wiki.ffo.jp/html/34975.html
Q Good Things Come in Threes | 辣腕三人衆 | no
MN RoV3-23 81
LK condition:前節「風向きは東」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-23;醴泉島 K-9 の Etched Rock でイベント（Ethereal Ingress #6、祠の入口）（FFXIclopedia：K-9）
g01 go - | 醴泉島(K-9)のEtched Rockへ行く | Ethereal Ingress #6のすぐ近く。 | @醴泉島 K-9
g02 examine - | Etched Rockを調べてイベントを見て、醴泉島の祠に移ると完了 | - | @醴泉島 K-9 | T obj.醴泉島.Etched_Rock

@ mission.rov.083 https://wiki.ffo.jp/html/34976.html
Q Tackling the Problem | 問題解決 | no | T obj.醴泉島の祠.Reisen_Crystal = obj:Reisen Crystal@醴泉島の祠
MN RoV3-24 82
RW key_item:次元の傷跡
LK condition:前節「辣腕三人衆」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-24;醴泉島の祠の Reisen Crystal でイベント（FFXIclopedia：長いイベント）
g01 examine - | 醴泉島の祠のReisen Crystalを調べ、イベントを見る | だいじなもの「次元の傷跡」はログに出ない。 | @醴泉島の祠 | T obj.醴泉島の祠.Reisen_Crystal
g02 go - | セルテウスに準備ができたか聞かれたら答えると完了 | 「はい」なら続けて天象の鎖に移り、次の「蘇りし神への道」は飛ばして「ローディング」になる。BFにすぐ入るわけではないので、ここで戦いの準備はいらない。「いいえ」なら次の「蘇りし神への道」になる。 | @醴泉島の祠

@ mission.rov.084 https://wiki.ffo.jp/html/34977.html
Q Way to Divinity | 蘇りし神への道 | no | T obj.醴泉島の祠.Reisen_Crystal
MN RoV3-25 83
LK condition:前節「問題解決」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-25;前の節から続くイベントを見ると済み、途中で天象の鎖に移る。称号 The Ascended（FFXIclopedia：前の節のイベントの中で済む）
g01 go - | 醴泉島の祠のReisen Crystalの前へ行く | 前の節で「はい」と答えていれば、この節は飛ばされる。祠を出ていたら、醴泉島(K-9)のEtched Rockから入る。 | @醴泉島の祠
g02 examine - | Reisen Crystalを調べ、準備ができたか聞かれたら「はい」と答えて天象の鎖に移り、イベントを見ると完了 | BFにすぐ入るわけではない。 | @醴泉島の祠 | T obj.醴泉島の祠.Reisen_Crystal

@ mission.rov.085 https://wiki.ffo.jp/html/34978.html
Q The Winds of Time | ローディング | no | T obj.Transcendental_Radiance
MN RoV3-26 84
RW title:神となりし者
LK condition:前節「蘇りし神への道」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-26;天象の鎖の Transcendental Radiance で BF「The Winds of Time」、Metus を倒す。プロマシアの技と Osmotic Wave・Censure、メテオ。フェイスが使える。負けたら醴泉島の祠の Reisen Crystal で女神に会うと答えて天象の鎖に戻り、Metus のイベント、Transcendental Radiance の部屋の入口の右の Dimensional Portal で祠に戻り、もう一度 Reisen Crystal で Extradimensional scar（FFXIclopedia：HP約100,000。魔法と物理のフェイスを組み合わせ、IL装備がよい。勝つとまた長いイベント。ル・メトの園のホームポイント#1から近くのエレベーターで下りて Dimensional Portal を使うと早い）
g01 go - | 天象の鎖の奥のTranscendental Radianceの前へ行く | 前の節で天象の鎖に移ったところから続く。天象の鎖のDimensional Portalから、ホラ・デム・メアの岩と醴泉島の祠へ飛べるようになる。 | @天象の鎖
g02 examine - | Transcendental Radianceを調べてBFに入る | 勝ったあとのイベントがとても長いので、時間に余裕があるときに入る。 | @天象の鎖 | T obj.Transcendental_Radiance
g03 fight - | Metusに勝つと完了 | HPは約10万。プロマシアと同じ技を使い、メテオも唱える。フェイスが使え、魔法と物理のフェイスを組み合わせるとよい。勝つとそのまま次の節のイベントになる。負けたら、天象の鎖を出て入り直してイベントを見て、Transcendental Radianceの部屋の入口の右のDimensional Portalから醴泉島の祠へ行き、Reisen Crystalで「はい」を選ぶと、「次元の傷跡」をまたもらって天象の鎖に戻れる。Transcendental Radianceでイベントを見てから、もう一度調べて入る。だいじなもの「星唄の煌めき【九奏】」・盟-イロハ・称号「ヴァナ・ディールの救世主」は、勝ったあとのイベントの中でもらえる。 | @天象の鎖

@ mission.rov.086 https://wiki.ffo.jp/html/34979.html
Q Calm After the Storm | 静かなる嵐 | no
MN RoV3-27 85
LK condition:前節「ローディング」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-27;前の戦いのあとのイベントを見る。Tenzen がプロマシアミッションで「ふさがって」いると（暁の最後のイベントの前など）進めないので、天象の鎖の Resume Point を調べる（FFXIclopedia：Metus を倒したあとのイベントの中で済む）
g01 go - | 勝ったあとのイベントを見る（醴泉島の祠に移る）と完了 | 途中で切れたときや、プロマシアミッション「暁」の最後のイベントをまだ見ていなくて止まったときは、天象の鎖のResume Pointを調べると醴泉島の祠に移り、続きになる。見のがしたところはGoblin Footprintで「静かなる嵐」として見直せる。 | @天象の鎖

@ mission.rov.087 https://wiki.ffo.jp/html/34980.html
Q Nary a Cloud in Sight | 雲ひとつなし | no
MN RoV3-28 86
RW item:盟-イロハ
RW key_item:星唄の煌めき【九奏】
RW title:ヴァナ・ディールの救世主
LK condition:前節「静かなる嵐」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-28;同じイベントを見つづけ、終わりに Cipher: Iroha と Rhapsody in Ochre、称号 The Savior of Vana'diel（FFXIclopedia：盟を受け取れなかったときは、醴泉島 K-9 の Etched Rock のすぐ外の Mystic Retriever でもらう。受け取らないと先に進めない）
g01 go - | 続くイベントを見て（醴泉島に移る）、「盟-イロハ」とだいじなもの「星唄の煌めき【九奏】」をもらうと完了 | マイバッグに空きを作っておく。祠でのイベントが途中で切れたときは、もう一度醴泉島に入ると続きになる。見のがしたところはGoblin Footprintで「雲ひとつなし」として見直せる。 | @醴泉島

@ mission.rov.088 https://wiki.ffo.jp/html/34981.html
Q An Unending Song | 終わりなき唄 | no
MN RoV3-29 87
LK condition:前節「雲ひとつなし」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-29;三国のモグハウスの入口があるエリアに入るとイベント。前の節でマイバッグがいっぱいだったら、醴泉島の Mystic Retriever で盟をもらってから（FFXIclopedia：Etched Rock のすぐ外 K-9。シート：K-9、醴泉島の祠の手前）
g01 examine - | 「盟-イロハ」を受け取れていないときは、醴泉島(K-9)のEtched Rockのすぐ外のMystic Retrieverを調べて受け取る | 受け取っていれば、次の手順へ。受け取らないと次のイベントが起きない。 | @醴泉島 K-9 | T obj.醴泉島.Mystic_Retriever = obj:Mystic Retriever@醴泉島 K-9
g02 go - | 三国のモグハウスの出入り口があるエリアに入り、イベントを見ると完了 | -

@ mission.rov.089 https://wiki.ffo.jp/html/34982.html
Q A Deep Sleep | 眠りの底で | no
MN RoV3-30 88
LK condition:前節「終わりなき唄」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-30;醴泉島の祠へ行くとイベント。プロマシアミッションを済ませているか「暁」まで進めていれば、ル・メトの園のホームポイントからエレベーターで下り、天象の鎖の Dimensional Portal で醴泉島の祠へ（FFXIclopedia：醴泉島の祠に入るとイベント。シート：K-9 の Etched Rock から入る）
g01 go - | 醴泉島の祠へ行く | 醴泉島から入るか、天象の鎖のDimensional Portalから飛ぶ。 | > a01,b01
a01 examine - | 【醴泉島から】醴泉島(K-9)のEtched Rockを調べて醴泉島の祠に入り、イベントを見ると完了 | 岩のDimensional Portalから醴泉島へ行き、Ethereal Ingress #6を取っていればそこへ飛ぶと早い。 | @醴泉島 K-9 | T obj.醴泉島.Etched_Rock | R 醴泉島から | >
b01 examine - | 【天象の鎖から】天象の鎖のDimensional Portalを調べ、醴泉島の祠を選んで移り、イベントを見ると完了 | プロマシアミッションを済ませているか「暁」まで進めていれば、ル・メトの園のホームポイントから近くのエレベーターで下りて行ける。 | @天象の鎖 | T obj.天象の鎖.Dimensional_Portal = obj:Dimensional Portal@天象の鎖 | R 天象の鎖から | >

@ mission.rov.090 https://wiki.ffo.jp/html/34983.html
Q Guardians | ガーディアン（ミッション） | no
MN RoV3-31 89
RW key_item:大いなるものたちの息吹
RW title:大いなる力の継承者
LK condition:前節「眠りの底で」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-31;ラテーヌ高原 G-6 の Stone Circle の ??? でイベント、Breath of the avatars。ユニティのワープ（Lv99）で近くへ飛べる（FFXIclopedia：G-6）
g01 go - | ラテーヌ高原(G-6)のストーンサークルへ行く | ユニティのワープ（Lv99）でラテーヌ高原へ飛ぶと近い。 | @ラテーヌ高原 G-6
g02 examine - | ストーンサークルの中の???を調べてイベントを見て、だいじなもの「大いなるものたちの息吹」をもらうと完了 | - | @ラテーヌ高原 G-6 | T obj.102.???_G-6

@ mission.rov.091 https://wiki.ffo.jp/html/34984.html
Q Iroha in Distress | イロハを救え | no
MN RoV3-32 90
RW other:ジラートの幻影ミッションの「心に宿る記憶」がすべて見られる
LK condition:前節「ガーディアン（ミッション）」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-32;醴泉島の祠に戻るとイベント。ル・メトの園のホームポイントと天象の鎖の Dimensional Portal で早く行ける。ジラートミッションの記憶がすべて見られるようになる（FFXIclopedia：醴泉島の祠に入るとイベント）
g01 go - | 醴泉島の祠へ行く | 醴泉島から入るか、天象の鎖のDimensional Portalから飛ぶ。 | > a01,b01
a01 examine - | 【醴泉島から】醴泉島(K-9)のEtched Rockを調べて醴泉島の祠に入り、イベントを見ると完了 | - | @醴泉島 K-9 | T obj.醴泉島.Etched_Rock | R 醴泉島から | >
b01 examine - | 【天象の鎖から】天象の鎖のDimensional Portalを調べ、醴泉島の祠を選んで移り、イベントを見ると完了 | ル・メトの園のホームポイントから近くのエレベーターで下りると早い。 | @天象の鎖 | T obj.天象の鎖.Dimensional_Portal | R 天象の鎖から | >

@ mission.rov.092 https://wiki.ffo.jp/html/34985.html
Q Absolute Trust | 真のフェイス | no | T obj.醴泉島の祠.Reisen_Crystal
MN RoV3-33 91
LK condition:前節「イロハを救え」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-33;Reisen Crystal を調べてイベント（FFXIclopedia：醴泉島の祠の Reisen Crystal）
g01 examine - | 醴泉島の祠のReisen Crystalを調べ、イベントを見ると完了 | 次の節はここからBFになる。 | @醴泉島の祠 | T obj.醴泉島の祠.Reisen_Crystal

@ mission.rov.093 https://wiki.ffo.jp/html/34986.html
Q The Orb's Radiance | 勾玉の輝き | no | T obj.醴泉島の祠.Reisen_Crystal
MN RoV3-34 92
RW item:盟-イロハII
RW key_item:鳳凰の息吹
RW key_item:星唄の煌めき【終奏】
RW title:星唄に乗せて歩み続ける者
LK condition:前節「真のフェイス」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-34;もう一度 Reisen Crystal を調べて Cloud of Darkness と BF。負けたらラテーヌ高原 G-6 の Stone Circle で Breath of the avatars をもう一度。済ませた人はだいじなものなしで手伝える。イロハが一緒に戦い、プロテス・シェル、フレアを使い、倒れても自分で起き上がり、レイズもする。Primordial Surge のあと物理か魔法を吸う（FFXIclopedia：勝ったあとのイベントとスタッフロールは15〜20分。フェイスで一人で勝つのは強い盾役でないと難しい。Reisen Shrine Glory は手伝ったとき）
g01 examine - | もう一度Reisen Crystalを調べてBFに入る | 勝ったあとのイベントとスタッフロールが15〜20分あるので、時間に余裕があるときに入る。済ませた人は、だいじなものがなくても手伝える。 | @醴泉島の祠 | T obj.醴泉島の祠.Reisen_Crystal
g02 fight - | Cloud of Darknessに勝つと完了 | イロハが一緒に戦い、フレアを唱え、倒れても自分で起き上がる。Primordial Surgeのあとは物理か魔法を吸うので、イロハの戦い方を見て合わせる。フェイスで一人で勝つのは、装備のそろった盾役でないと難しい。負けたら、ラテーヌ高原(G-6)のストーンサークルの???を調べて「大いなるものたちの息吹」をまたもらう。コンプリートしたあと手伝って勝つと「醴泉神社の功徳」がもらえる。 | @醴泉島の祠

@ mission.rov.094 https://wiki.ffo.jp/html/34987.html
Q A Rhapsody for the Ages | すべてが星の唄となる | no
MN RoV3-35 93
LK condition:前節「勾玉の輝き」クリア
XS BG Wiki;https://www.bg-wiki.com/ffxi/Rhapsodies_of_Vanadiel_Mission_3-35;エンディングのイベントを見る。このあと蝕世のエンブリオのミッションを始められる（FFXIclopedia：星唄の物語の終わり）
g01 go - | 勝ったあとのイベント（エンディングとスタッフロール）を最後まで見ると完了 | 醴泉島の祠、醴泉島、醴泉島の祠とエリアが移りながら続く。星唄ミッションはこれで終わり。 | @醴泉島の祠
