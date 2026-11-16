"""試し書き：三国ミッション10件（手順の文が長かったもの）。出典は各ミッションの用語辞典の記事。"""
from common import S, L, T, N, KI, build

CHECKED = '2026-11-14'
G = []

# ---------------------------------------------------------------------------
# 魔晶石を奪え（三国共通の記事 1376）
# ---------------------------------------------------------------------------
EMB = {
    'sandoria': ('mission.sandoria.010', 'G-9', 'npc.243.Nelcabrit', 'Nelcabrit', 'obj.243.Door_San_dOrian_Emb', "Door:San d'Orian Emb."),
    'bastok': ('mission.bastok.010', 'H-10', 'npc.243.Goggehn', 'Goggehn', 'obj.243.Door_Bastokan_Emb', 'Door:Bastokan Emb.'),
    'windurst': ('mission.windurst.010', 'I-9', 'npc.243.Pakh_Jatalfih', 'Pakh Jatalfih', 'obj.243.Door_Windurstian_Emb', 'Door:Windurstian Emb.'),
}

def magicite(nation):
    qid, grid, npc, npc_name, door, door_name = EMB[nation]
    audience = T('obj.243.Door_Audience_Chamber', 'obj', 'Door:Audience Chamber', L('ル・ルデの庭'))
    steps = [
        S('g01', 'talk', 'ル・ルデの庭(%s)の%sに話す' % (grid, npc_name),
          '自国の大使館の人。自国のゲートハウスではこのミッションは出ない。',
          L('ル・ルデの庭', grid), npc, frm=['s01']),
        S('g02', 'examine', '%sを調べてミッションを受ける' % door_name,
          None, L('ル・ルデの庭', grid), door, frm=['s01']),
        S('g03', 'examine', '大公宮のDoor:Audience Chamberを調べてイベント',
          '「ジュノ大公面会許可証」を持っていれば調べられる。終わるとだいじなもの「アルドへの手紙」を入手。',
          L('ル・ルデの庭'), audience, needs=[KI('ジュノ大公面会許可証')], frm=['s02']),
        S('g04', 'talk', 'ジュノ下層の天晶堂でアルドに話し「銀の鈴」を入手',
          '天晶堂に入るにはクエスト「天晶堂入会」が必要。移籍後の2回目は鈴はもらえないが、話すイベントは必ず見る（見ないと魔晶石が取れない）。',
          L('ジュノ下層'), None, frm=['s03']),
        # ダボイ
        S('g05', 'trade', 'ジュノ上層(G-8 テンキー7)のBaudinにクァールの肉を渡し「ダボイ村紋章」を入手',
          'クエスト「ダボイ村の紋章」。紋章が無いと修道窟に入れない。ダボイ・ベドー・オズトロヤ城の3か所は好きな順でよい。',
          L('ジュノ上層', 'G-8'), T('npc.244.Baudin', 'npc', 'Baudin', L('ジュノ上層', 'G-8')),
          needs=[N('クァールの肉')], frm=['s04'], route='ダボイ'),
        S('g06', 'examine', 'ダボイ(G-7)のWall of Dark Artsを調べて修道窟に入る',
          'オークは視覚感知なのでインビジで絡まれない。Lv60未満だと絡まれることがある。',
          L('ダボイ', 'G-7'), T('obj.149.Wall_of_Dark_Arts', 'obj', 'Wall of Dark Arts', L('ダボイ', 'G-7')),
          needs=[KI('ダボイ村紋章')], frm=['s04'], route='ダボイ'),
        S('g07', 'examine', '修道窟(F-6)のMagiciteを調べて「魔晶石・メノ石」を入手',
          '回想イベントのあとに手に入る。',
          L('修道窟', 'F-6'), T('obj.修道窟.Magicite', 'obj', 'Magicite', L('修道窟', 'F-6')),
          frm=['s04'], route='ダボイ'),
        # ベドー
        S('g08', 'defeat', "ベドー(I-9)のDe'Vyu Headhunterを倒して「クゥダフの呪符」を入手",
          'ベドー入口から(H-7)へ進み、地下道MAP[2](F-8)を抜けて(E-10)の架け橋から上がった高台にいる。途中に呪い・静寂の装置があるので聖水ややまびこ薬を用意。いなければ5分ほど待つ。',
          L('ベドー', 'I-9'), T('mob.147.DeVyu_Headhunter', 'mob', "De'Vyu Headhunter", L('ベドー', 'I-9')),
          frm=['s05'], route='ベドー'),
        S('g09', 'defeat', "ベドー(F-6)のGo'Bhu Gasconを倒して「クゥダフの卜占甲」を入手",
          '同じ高台のエリアにいる。いなければ5分ほど待つ。',
          L('ベドー', 'F-6'), T('mob.147.GoBhu_Gascon', 'mob', "Go'Bhu Gascon", L('ベドー', 'F-6')),
          frm=['s05'], route='ベドー'),
        S('g10', 'trade', 'ジュノ下層(J-8)天晶堂のSattal-Mansalに2つを1つずつトレード',
          '「妖光の数珠」と「漆黒のマチネー」がもらえる。2つ同時に渡すと1つしかもらえない。',
          L('ジュノ下層', 'J-8'), T('npc.245.Sattal-Mansal', 'npc', 'Sattal-Mansal', L('ジュノ下層', 'J-8')),
          needs=[N('クゥダフの呪符'), N('クゥダフの卜占甲')], frm=['s05'], route='ベドー'),
        S('g11', 'examine', 'ベドー地下道MAP[2](H-7)からクゥルンの大伽藍に入り、扉を調べる',
          '扉の近くで調べないと開かない。クゥダフは聴覚感知なのでスニークで絡まれない。',
          L('ベドー', 'H-7', 2), None,
          needs=[KI('銀の鈴'), KI('妖光の数珠'), KI('漆黒のマチネー')], frm=['s05'], route='ベドー'),
        S('g12', 'examine', 'クゥルンの大伽藍(F-8)のMagiciteを調べて「魔晶石・ミノ石」を入手',
          '中には敵がいない。回想イベントのあとに手に入る。',
          L('クゥルンの大伽藍', 'F-8'), T('obj.148.Magicite', 'obj', 'Magicite', L('クゥルンの大伽藍', 'F-8')),
          frm=['s05'], route='ベドー'),
        # オズトロヤ城
        S('g13', 'talk', 'ジュノ上層(I-8)のPaya-Sabyaに話してイベント',
          None, L('ジュノ上層', 'I-8'), T('npc.244.Paya-Sabya', 'npc', 'Paya-Sabya', L('ジュノ上層', 'I-8')),
          frm=['s06'], route='オズトロヤ城'),
        S('g14', 'talk', 'ジュノ下層(H-10)カバンクエ奥のMuckvixに話し「ヤグードの松明」を入手',
          None, L('ジュノ下層', 'H-10'), T('npc.245.Muckvix', 'npc', 'Muckvix', L('ジュノ下層', 'H-10')),
          frm=['s06'], route='オズトロヤ城'),
        S('g15', 'examine', 'オズトロヤ城MAP[2](I-8 テンキー3)の仕掛け扉のHandleを引いてMAP[3]へ上がる',
          '落とし穴に注意。扉の中央から下がって引き、すぐレバー横のすき間に入るか扉に密着する。落ちたら八角形の蓋から下りるとMAP[6]経由でMAP[2]に戻れる。ヤグードは視覚、コウモリなどは聴覚感知。',
          L('オズトロヤ城', 'I-8', 2), T('obj.151.Handle', 'obj', 'Handle', L('オズトロヤ城', 'I-8', 2), same_name=True),
          frm=['s06'], route='オズトロヤ城'),
        S('g16', 'go', 'MAP[3]の(G-7)から中庭のMAP[7]へ出て、(I-7)からMAP[1]（地下）へ入る',
          'MAP[3]は最初の分かれ道(I-8)を右へ。横道は無視して、マップ上側の道を道なりに進む（下側は行き止まり）。',
          L('オズトロヤ城', 'G-7', 3), None, frm=['s06'], route='オズトロヤ城'),
        S('g17', 'examine', 'MAP[1](H-9 テンキー1)の扉のTorch Standに火をつけて通る',
          '長い階段を下りて右手の壁沿いに進んだ扉（内側の広間の扉ではない）。「はい」を選ぶ。ヤグードの松明が無いと通れない。',
          L('オズトロヤ城', 'H-9', 1), T('obj.151.Torch_Stand', 'obj', 'Torch Stand', L('オズトロヤ城', 'H-9', 1), same_name=True),
          needs=[KI('ヤグードの松明')], frm=['s06'], route='オズトロヤ城'),
        S('g18', 'examine', 'MAP[1](G-10)のBrass Doorを開けて祭壇の間に入る',
          '入るとイベント。',
          L('オズトロヤ城', 'G-10', 1), T('obj.151.Brass_Door_G-10', 'obj', 'Brass Door', L('オズトロヤ城', 'G-10', 1), same_name=True),
          frm=['s06'], route='オズトロヤ城'),
        S('g19', 'examine', '祭壇の間(G-8)のMagiciteを調べて「魔晶石・クノ石」を入手',
          '回想イベントのあとに手に入る。3つ目の魔晶石なら、続けてもう1つイベントがある。',
          L('祭壇の間', 'G-8'), T('obj.祭壇の間.Magicite', 'obj', 'Magicite', L('祭壇の間', 'G-8')),
          frm=['s06'], route='オズトロヤ城'),
        # 報告
        S('g20', 'examine', 'ル・ルデの庭に戻り、大公宮のDoor:Audience Chamberを調べてイベント',
          '3つの魔晶石がそろってから。「飛空艇パス」がもらえる（持っていれば20,000ギル）。',
          L('ル・ルデの庭'), audience, frm=['s07']),
        S('g21', 'talk', 'ル・ルデの庭の自国の大使館で報告して完了',
          'ランク5になり、10,000ギル。報告する相手の名前は記事に書かれていない。',
          L('ル・ルデの庭'), None, frm=['s08']),
    ]
    return build(qid, steps, 'https://wiki.ffo.jp/html/1376.html', CHECKED)

for n in ('sandoria', 'bastok', 'windurst'):
    G.append(magicite(n))

# ---------------------------------------------------------------------------
# パルブロ鉱山のミスリルの砂粒（他国を回れ・三大強国で同じ手順）
# ---------------------------------------------------------------------------
def mithril_steps(prefix, consul_name, consul_tgt, consul_loc, pius_grid, frm, route):
    k = lambda i: '%s%d' % (prefix, i)
    return [
        S(k(1), 'talk', '大統領府のPius(%s)に話す' % pius_grid, None,
          L('大工房', pius_grid), T('npc.237.Pius', 'npc', 'Pius', L('大工房', 'K-8')), frm=frm, route=route),
        S(k(2), 'talk', '大工房の食堂のGrohm(H-9)に話し、つるはしを3つもらう', None,
          L('大工房', 'H-9'), T('npc.237.Grohm', 'npc', 'Grohm', L('大工房', 'H-9')), frm=frm, route=route),
        S(k(3), 'gather', 'パルブロ鉱山で「鉱山の砂利」を手に入れる',
          None,
          L('パルブロ鉱山'), None, frm=frm, route=route),
        S(k(4), 'trade', 'パルブロ鉱山MAP[3](I-7)のRefiner Lidに「鉱山の砂利」をトレード',
          None, L('パルブロ鉱山', 'I-7', 3), 'npc.143.Refiner_Lid',
          needs=[N('鉱山の砂利')], frm=frm, route=route),
        S(k(5), 'examine', '隣のRefiner Leverを調べて精製を始める', None, L('パルブロ鉱山', 'I-7', 3),
          T('obj.143.Refiner_Lever', 'obj', 'Refiner Lever', L('パルブロ鉱山'), same_name=True), frm=frm, route=route),
        S(k(6), 'examine', 'MAP[2]に落ち、近くのRefiner Leverを調べて「ミスリルの砂粒」を入手',
          '装置の奥から落ちる。砂粒は自動でかばんに入る（入手のメッセージが出ないこともある）。',
          L('パルブロ鉱山', None, 2), 'obj.143.Refiner_Lever', frm=frm, route=route),
        S(k(7), 'trade', '大工房の%sに「ミスリルの砂粒」を渡す' % consul_name,
          '先に砂粒を持っていれば、Grohmの話のあとすぐ渡せる。',
          consul_loc, consul_tgt, needs=[N('ミスリルの砂粒')], frm=frm, route=route),
    ]

# ---------------------------------------------------------------------------
# 他国を回れ SM2-3（2049）
# ---------------------------------------------------------------------------
qid = 'mission.sandoria.006'
savae_loc = L('大工房', 'I-9')
savae = T('npc.237.Savae_E_Paleade', 'npc', 'Savae E Paleade', savae_loc)
mour = 'npc.241.Mourices'
kupipi = 'npc.天の塔.Kupipi'
steps = [
    S('g01', 'talk', 'ドラギーユ城の入口正面のHalverに話し「領事への紹介状」を入手',
      'ここで回る順を選ぶ：バストゥーク先か、ウィンダス先か。', L('ドラギーユ城', 'I-9'), 'npc.233.Halver',
      frm=['s01'], nxt=['a01', 'b01']),
    # バストゥーク → ウィンダス
    S('a01', 'talk', '【バストゥーク先】大工房(I-9)のサンドリア領事館でSavae E Paleadeに話す', None,
      savae_loc, savae, frm=['s02'], route='バストゥーク先'),
] + mithril_steps('am', 'Savae E Paleade', savae, savae_loc, 'K-8', ['s02'], 'バストゥーク先') + [
    S('a02', 'talk', 'ウィンダス森の区(G-10)のサンドリア領事館でMouricesに話す', 'ここからウィンダス編。',
      L('ウィンダス森の区', 'G-10'), mour, frm=['s03'], route='バストゥーク先'),
    S('a03', 'talk', '天の塔のKupipiに話し「黒光りしたカギ」を入手', None, L('天の塔'), kupipi, frm=['s03'], route='バストゥーク先'),
    S('a04', 'fight', 'バルガの舞台でBF戦に勝つ', None,
      L('バルガの舞台'), None, needs=[KI('黒光りしたカギ')], frm=['s03'], route='バストゥーク先'),
    S('a05', 'talk', 'Mouricesに報告し「闇の血族報告書」を入手', None,
      L('ウィンダス森の区', 'G-10'), mour, frm=['s03'], nxt=['g02'], route='バストゥーク先'),
    # ウィンダス → バストゥーク
    S('b01', 'talk', '【ウィンダス先】ウィンダス森の区(G-10)のサンドリア領事館でMouricesに話す', None,
      L('ウィンダス森の区', 'G-10'), mour, frm=['s04'], route='ウィンダス先'),
    S('b02', 'talk', '天の塔のKupipiに話し「献上品・魔法盾」を入手', None, L('天の塔'), kupipi, frm=['s04'], route='ウィンダス先'),
    S('b03', 'talk', 'ギデアスMAP[2](F-6)のUu Zhoumoに話す', '地下のマップ。',
      L('ギデアス', 'F-6', 2), T('npc.145.Uu_Zhoumo', 'npc', 'Uu Zhoumo', L('ギデアス', 'F-6', 2)), frm=['s04'], route='ウィンダス先'),
    S('b04', 'defeat', '(H-7)のZhuu Buxu the Silentを2回倒し「パラナシールド」を2個入手',
      '1人につき2回倒す。出直しは5分ほどと書かれている。',
      L('ギデアス', 'H-7', 2), 'mob.145.Zhuu_Buxu_the_Silent', frm=['s04'], route='ウィンダス先'),
    S('b05', 'trade', 'Mouricesに「パラナシールド」を2個渡す', 'ウィンダス編はここまで。',
      L('ウィンダス森の区', 'G-10'), mour, needs=[N('パラナシールド', 2)], frm=['s04'], route='ウィンダス先'),
    S('b06', 'talk', '大工房(I-9)のサンドリア領事館でSavae E Paleadeに話す', 'ここからバストゥーク編。',
      savae_loc, savae, frm=['s05'], route='ウィンダス先'),
    S('b07', 'talk', '大工房のPius(K-8)に話す', None, L('大工房', 'K-8'), 'npc.237.Pius', frm=['s05'], route='ウィンダス先'),
    S('b08', 'talk', '大工房のGrohm(H-9)に話す', None, L('大工房', 'H-9'), 'npc.237.Grohm', frm=['s05'], route='ウィンダス先'),
    S('b09', 'fight', 'ワールンの祠でBF戦に勝つ', None,
      L('ワールンの祠'), None, frm=['s05'], route='ウィンダス先'),
    S('b10', 'talk', 'Savae E Paleadeに報告し「闇の血族報告書」を入手', None,
      savae_loc, savae, frm=['s05'], nxt=['g02'], route='ウィンダス先'),
    S('g02', 'talk', 'サンドリアに戻り、ドラギーユ城のHalverに報告して完了',
      'ランク3、3,000ギル、だいじなもの「冒険者の証」。', L('ドラギーユ城', 'I-9'), 'npc.233.Halver',
      needs=[KI('闇の血族報告書')], frm=['s06']),
]
G.append(build(qid, steps, 'https://wiki.ffo.jp/html/2049.html', CHECKED))

# ---------------------------------------------------------------------------
# 三大強国 WM2-3（5725）
# ---------------------------------------------------------------------------
qid = 'mission.windurst.006'
kas_loc = L('北サンドリア', 'H-9')
kas = T('npc.231.Kasaroro', 'npc', 'Kasaroro', kas_loc)
patt_loc = L('大工房', 'I-7')
patt = T('npc.237.Patt-Pott', 'npc', 'Patt-Pott', patt_loc)
steps = [
    S('g01', 'talk', '天の塔のKupipiに話し「領事への紹介状」を入手',
      'ここで回る順を選ぶ：サンドリア先か、バストゥーク先か。', L('天の塔'), kupipi, frm=['s01'], nxt=['a01', 'b01']),
    # サンドリア → バストゥーク
    S('a01', 'talk', '【サンドリア先】北サンドリア(H-9)のウィンダス領事館で受付のHeruze-Moruzeに話す', None,
      kas_loc, T('npc.231.Heruze-Moruze', 'npc', 'Heruze-Moruze', kas_loc), frm=['s02'], route='サンドリア先'),
    S('a02', 'talk', '領事のKasaroroに話す', 'ここからドラギーユ城に入れる。', kas_loc, kas, frm=['s02'], route='サンドリア先'),
    S('a03', 'talk', 'ドラギーユ城(I-9)のHalverに話す', None, L('ドラギーユ城', 'I-9'), 'npc.233.Halver', frm=['s02'], route='サンドリア先'),
    S('a04', 'defeat', 'ゲルスバ野営陣(H-7)の上層にいるWarchief Vatgitを倒す', None,
      L('ゲルスバ野営陣', 'H-7'), 'mob.140.Warchief_Vatgit', frm=['s02'], route='サンドリア先'),
    S('a05', 'talk', 'Kasaroroに報告する', 'サンドリア編はここまで。', kas_loc, kas, frm=['s02'], route='サンドリア先'),
    S('a06', 'talk', '大工房(I-7)のウィンダス領事館でPatt-Pottに話す', 'ここからバストゥーク編。',
      patt_loc, patt, frm=['s03'], route='サンドリア先'),
    S('a07', 'talk', '大工房のPius(K-8)に話す', None, L('大工房', 'K-8'), 'npc.237.Pius', frm=['s03'], route='サンドリア先'),
    S('a08', 'talk', '大工房のGrohm(H-9)に話す', None, L('大工房', 'H-9'), 'npc.237.Grohm', frm=['s03'], route='サンドリア先'),
    S('a09', 'fight', 'パルブロ鉱山のいちばん奥、ワールンの祠でBF戦に勝つ', None,
      L('ワールンの祠'), None, frm=['s03'], route='サンドリア先'),
    S('a10', 'talk', 'Patt-Pottに報告し「闇の血族報告書」を入手', None, patt_loc, patt, frm=['s03'], nxt=['g02'], route='サンドリア先'),
    # バストゥーク → サンドリア
    S('b01', 'talk', '【バストゥーク先】大工房(I-7)のウィンダス領事館でPatt-Pottに話す', None,
      patt_loc, patt, frm=['s04'], route='バストゥーク先'),
] + mithril_steps('bm', 'Patt-Pott', patt, patt_loc, 'K-8', ['s04'], 'バストゥーク先') + [
    S('b02', 'talk', '北サンドリア(H-9)のウィンダス領事館でKasaroroに話す', 'ここからサンドリア編。ドラギーユ城に入れるようになる。',
      kas_loc, kas, frm=['s05'], route='バストゥーク先'),
    S('b03', 'talk', 'ドラギーユ城(I-9)のHalverに話す', None, L('ドラギーユ城', 'I-9'), 'npc.233.Halver', frm=['s05'], route='バストゥーク先'),
    S('b04', 'fight', 'ホルレーの岩峰でBF戦に勝つ', None,
      L('ホルレーの岩峰'), None, frm=['s05'], route='バストゥーク先'),
    S('b05', 'talk', 'Kasaroroに報告し「闇の血族報告書」を入手', None, kas_loc, kas, frm=['s05'], nxt=['g02'], route='バストゥーク先'),
    S('g02', 'talk', 'ウィンダスに戻り、天の塔のKupipiに報告して完了',
      'ランク3、3,000ギル、だいじなもの「冒険者の証」。', L('天の塔'), kupipi,
      needs=[KI('闇の血族報告書')], frm=['s06']),
]
G.append(build(qid, steps, 'https://wiki.ffo.jp/html/5725.html', CHECKED))

# ---------------------------------------------------------------------------
# バストゥークを離れて BM2-3（2050）
# ---------------------------------------------------------------------------
qid = 'mission.bastok.006'
hel_loc = L('北サンドリア', 'K-9')
hel = T('npc.231.Helaku', 'npc', 'Helaku', hel_loc)
mel_loc = L('ウィンダス港', 'E-5')
mel = T('npc.240.Melek', 'npc', 'Melek', mel_loc)
steps = [
    S('g01', 'talk', '大工房(J-8)のNajiに話し「領事への紹介状」を入手',
      'ここで回る順を選ぶ：サンドリア先か、ウィンダス先か。', L('大工房', 'J-8'), 'npc.237.Naji', frm=['s01'], nxt=['a01', 'b01']),
    # サンドリア → ウィンダス
    S('a01', 'talk', '【サンドリア先】北サンドリア(K-9)のバストゥーク領事館で受付のBarakaに話す', None,
      hel_loc, T('npc.231.Baraka', 'npc', 'Baraka', hel_loc), frm=['s02'], route='サンドリア先'),
    S('a02', 'talk', '領事のHelakuに話してイベント', 'ここからドラギーユ城に入れる。', hel_loc, hel, frm=['s02'], route='サンドリア先'),
    S('a03', 'talk', 'ドラギーユ城(I-9)のHalverに話す', None, L('ドラギーユ城', 'I-9'), 'npc.233.Halver', frm=['s02'], route='サンドリア先'),
    S('a04', 'defeat', 'ゲルスバ野営陣(H-7)のWarchief Vatgitを倒す',
      'ゲルスバ砦のSurvival Guideが使えるなら、着いた先から西の野営陣に入り、一本道の洞窟と家を抜けた先の広場にいる。',
      L('ゲルスバ野営陣', 'H-7'), 'mob.140.Warchief_Vatgit', frm=['s02'], route='サンドリア先'),
    S('a05', 'talk', 'Helakuに報告する', 'サンドリア編はここまで。', hel_loc, hel, frm=['s02'], route='サンドリア先'),
    S('a06', 'talk', 'ウィンダス港(E-5)のバストゥーク領事館でMelekに話す', 'ここからウィンダス編。', mel_loc, mel, frm=['s03'], route='サンドリア先'),
    S('a07', 'talk', '天の塔のKupipiに話し「黒光りしたカギ」を入手', None, L('天の塔'), kupipi, frm=['s03'], route='サンドリア先'),
    S('a08', 'fight', 'バルガの舞台でBF戦に勝つ', None,
      L('バルガの舞台'), None, needs=[KI('黒光りしたカギ')], frm=['s03'], route='サンドリア先'),
    S('a09', 'talk', 'Melekに報告し「闇の血族報告書」を入手', None, mel_loc, mel, frm=['s03'], nxt=['g02'], route='サンドリア先'),
    # ウィンダス → サンドリア
    S('b01', 'talk', '【ウィンダス先】ウィンダス港(E-5)のバストゥーク領事館でMelekに話す', None, mel_loc, mel, frm=['s04'], route='ウィンダス先'),
    S('b02', 'talk', '天の塔のKupipiに話し「献上品・魔法剣」を入手', None, L('天の塔'), kupipi, frm=['s04'], route='ウィンダス先'),
    S('b03', 'talk', '領事館のGold Skullに話し、献上品を「なまくらの剣」とすり替える', None,
      mel_loc, T('npc.240.Gold_Skull', 'npc', 'Gold Skull', mel_loc), frm=['s04'], route='ウィンダス先'),
    S('b04', 'talk', 'ギデアスMAP[2](F-6)のUu Zhoumoに話す', '地下のマップ。',
      L('ギデアス', 'F-6', 2), 'npc.145.Uu_Zhoumo', frm=['s04'], route='ウィンダス先'),
    S('b05', 'defeat', '同じマップ(G-7)のEyy Mon the Ironbreakerを倒して「アスピルナイフ」を入手',
      '必ず落とす。いなければ5分ほど待つ（5分ごとに出る）。',
      L('ギデアス', 'G-7', 2),
      T('mob.145.Eyy_Mon_the_Ironbreaker', 'mob', 'Eyy Mon the Ironbreaker', L('ギデアス', 'G-7', 2)),
      frm=['s04'], route='ウィンダス先',
      extra=[{'name': 'BG Wiki', 'checked': CHECKED, 'urls': [
          'https://www.bg-wiki.com/ffxi/The_Emissary',
          'https://www.bg-wiki.com/ffxi/Aspir_Knife',
          'https://www.bg-wiki.com/ffxi/Eyy_Mon_the_Ironbreaker'],
          'fact_ja': '倒すと手に入る（ドロップ率は「G」＝必ず）。ギデアスの2枚目のマップ(G-7)に5分ごとに出る。'}]),
    S('b06', 'trade', 'Uu Zhoumoに「アスピルナイフ」をトレード', None,
      L('ギデアス', 'F-6', 2), 'npc.145.Uu_Zhoumo', needs=[N('アスピルナイフ')], frm=['s04'], route='ウィンダス先'),
    S('b07', 'talk', 'Melekに報告する', 'ウィンダス編はここまで。', mel_loc, mel, frm=['s04'], route='ウィンダス先'),
    S('b08', 'talk', '北サンドリア(K-9)のバストゥーク領事館でHelakuに話す', 'ここからサンドリア編。ドラギーユ城に入れるようになる。',
      hel_loc, hel, frm=['s05'], route='ウィンダス先'),
    S('b09', 'talk', 'ドラギーユ城(I-9)のHalverに話す', None, L('ドラギーユ城', 'I-9'), 'npc.233.Halver', frm=['s05'], route='ウィンダス先'),
    S('b10', 'fight', 'ホルレーの岩峰でBF戦に勝つ', None,
      L('ホルレーの岩峰'), None, frm=['s05'], route='ウィンダス先'),
    S('b11', 'talk', 'Helakuに報告し「闇の血族報告書」を入手', None, hel_loc, hel, frm=['s05'], nxt=['g02'], route='ウィンダス先'),
    S('g02', 'talk', 'バストゥークに戻り、大工房の大統領府前のNajiに報告して完了',
      'ランク3、3,000ギル、だいじなもの「冒険者の証」。', L('大工房', 'J-8'), 'npc.237.Naji',
      needs=[KI('闇の血族報告書')], frm=['s06']),
]
G.append(build(qid, steps, 'https://wiki.ffo.jp/html/2050.html', CHECKED))

# ---------------------------------------------------------------------------
# 月詠み WM9-2（1230）
# ---------------------------------------------------------------------------
qid = 'mission.windurst.020'
vestal = 'obj.天の塔.Door_Vestal_Chamber'
steps = [
    S('g01', 'examine', '天の塔3Fの魔天の扉（Door:Vestal Chamber）を調べる', 'ガードでミッションを受けてから。',
      L('天の塔'), vestal, frm=['s01']),
    S('g02', 'examine', "ロ・メーヴ(H-6)のQu'Hau Springを調べて「古代の曲～ロ・メーヴ～」を入手",
      '3つの歌は好きな順でよい。', L('ロ・メーヴ', 'H-6'), 'obj.122.QuHau_Spring', frm=['s02']),
    S('g03', 'defeat', 'ウガレピ寺院のTonberry Cutterを倒して「ウガレピのカギ」を手に入れる',
      '歌のある部屋に入るのに使う。', L('ウガレピ寺院'), 'npc.159.Tonberry_Cutter', frm=['s02']),
    S('g04', 'examine', 'ウガレピ寺院MAP[2](E-8)の???を調べて「古代の曲～ウガレピ～」を入手',
      'MAP[1](F-5)からいったんヨアトル大森林に出て、(H-11)から入り直した先のマップ。Proto-Waypointが使えるならMAP[2](H-8)に飛べる。',
      L('ウガレピ寺院', 'E-8', 2), T('obj.159.???_E-8', 'obj', '???', L('ウガレピ寺院', 'E-8', 2)),
      needs=[N('ウガレピのカギ')], frm=['s02']),
    S('g05', 'go', '宣託の間に入って「古代の曲～アルテパ～」を入手',
      'エリアに入るだけで手に入る。手前の重量扉は、ガルカ以外だと誰かと協力するか「重量石」が必要。',
      L('宣託の間'), None, frm=['s02']),
    S('g06', 'examine', '天の塔に戻り、魔天の扉をもう一度調べる', None, L('天の塔'), vestal,
      needs=[KI('古代の曲～ロ・メーヴ～'), KI('古代の曲～ウガレピ～'), KI('古代の曲～アルテパ～')], frm=['s03']),
    S('g07', 'fight', '満月の泉でBF「月詠み」に勝つ', '6人・30分まで。強化の持ち込み不可、経験値ロストなし。入るときにイベント。',
      L('満月の泉'), None, frm=['s04']),
    S('g08', 'examine', '天の塔3Fの魔天の扉を調べてイベント', None, L('天の塔'), vestal, frm=['s05']),
    S('g09', 'examine', 'もう一度魔天の扉を調べてイベント、ウィンダス石の区に移って完了',
      'ランク10、10万ギル、連邦旗。かばんがいっぱいだと受け取れず未完了になる。そのときは天の塔入口横の「＿」を調べる。',
      L('天の塔'), vestal, frm=['s05']),
]
G.append(build(qid, steps, 'https://wiki.ffo.jp/html/1230.html', CHECKED))

# ---------------------------------------------------------------------------
# 聖者の招待 WM6-2（8260）
# ---------------------------------------------------------------------------
qid = 'mission.windurst.014'
steps = [
    S('g01', 'examine', '天の塔最上階の魔天の扉（Door:Vestal Chamber）を調べて「聖者の招待状」を入手', None,
      L('天の塔'), vestal, frm=['s01']),
    S('g02', 'fight', 'バルガの舞台でBF「聖者の招待」に勝ち「バルガ勝者の証」を入手',
      '6人・30分まで、レベル制限なし。Buu Xolo the Bloodfaced・Nuu Kofu the Gentle・Juu Zeni the Poisonmist・Chaa Paqa the Profoundの4体を全部倒す。スリプルが効く。',
      L('バルガの舞台'), None, needs=[KI('聖者の招待状')], frm=['s02']),
    S('g03', 'defeat', 'オズトロヤ城のYagudo Flagellantを倒して「裁きのカギ」を入手',
      '1つあればよい（複数は持てない）。', L('オズトロヤ城'), 'mob.151.Yagudo_Flagellant', frm=['s03']),
    S('g04', 'trade', 'オズトロヤ城の天守マップ(H-5)のBrass Doorに「裁きのカギ」をトレード',
      '王座の下の広場。見破りのあるYagudo High Priestに注意。誰かが開けるとしばらくほかの人も通れる。',
      L('オズトロヤ城', 'H-5'), 'obj.151.Brass_Door', needs=[N('裁きのカギ')], frm=['s04']),
    S('g05', 'talk', '奥のKaa Toru the Justに話し「聖者の宣誓書」と「阿修羅の数珠」を入手', None,
      L('オズトロヤ城'), T('npc.151.Kaa_Toru_the_Just', 'npc', 'Kaa Toru the Just', L('オズトロヤ城')), frm=['s05']),
    S('g06', 'examine', '天の塔に戻り、魔天の扉を調べて報告、完了', 'ランク7、40,000ギル。',
      L('天の塔'), vestal, frm=['s06']),
]
G.append(build(qid, steps, 'https://wiki.ffo.jp/html/8260.html', CHECKED))

# ---------------------------------------------------------------------------
# 星読み WM3-2（6786）
# ---------------------------------------------------------------------------
qid = 'mission.windurst.008'
zub = 'npc.天の塔.Zubaba'
gate_light = T('obj.192.Gate_of_Light', 'obj', 'Gate of Light', L('内ホルトト遺跡', 'G-7', 4))
steps = [
    S('g01', 'talk', '天の塔2F侍女の間のZubabaに話す',
      '1回目は「光の札」をもらう。2回目以降（「魔晶石を奪え」を先に済ませた場合も）は「錆びた短剣」を3個頼まれる。行き方か2回目かをここで選ぶ。',
      L('天の塔'), zub, frm=['s01'], nxt=['a01', 'b01', 'c01']),
    S('a01', 'go', '【1回目・魔封門】東サルタバルタ(J-7)から内ホルトト遺跡を奥へ進む',
      '(G-8～G-9)から次のマップ、(D-10)からさらに次のマップへ。ゴブリンや骸骨がLv99でも絡んでくる。ゴブリンは道の上で避けられないので、インビジやプリズムパウダーを用意。',
      L('内ホルトト遺跡'), None, frm=['s02'], route='1回目・魔封門'),
    S('a02', 'examine', '白・黒・赤魔道士の3人で魔封門（Sealed Portal）を開ける',
      '「魔封門の札」を持っている人に開けてもらってもよい。',
      L('内ホルトト遺跡'), T('obj.192.Sealed_Portal', 'obj', 'Sealed Portal', L('内ホルトト遺跡'), same_name=True),
      frm=['s02'], nxt=['g02'], route='1回目・魔封門'),
    S('b01', 'go', '【1回目・水呼びの扉】石の区の水呼びの扉からトライマライ水路に入る',
      '右手沿いに進むと内ホルトト遺跡に出る。クエスト「水呼びの扉」でもらう「鼻の院の認可証」が必要。入った部屋がGate of Lightの部屋。',
      L('トライマライ水路'), None, needs=[KI('鼻の院の認可証')], frm=['s02'], nxt=['g02'], route='1回目・水呼びの扉'),
    S('g02', 'examine', '内ホルトト遺跡MAP[4](G-7)のGate of Lightを調べる', None,
      L('内ホルトト遺跡', 'G-7', 4), gate_light, needs=[KI('光の札')], frm=['s02'],
      route=['1回目・魔封門', '1回目・水呼びの扉']),
    S('g03', 'talk', '天の塔に戻り、Zubabaに報告して完了', None, L('天の塔'), zub, frm=['s03'], nxt=[],
      route=['1回目・魔封門', '1回目・水呼びの扉']),
    S('c01', 'gather', '【2回目以降】「錆びた短剣」を3個用意する',
      'Gate of Lightと同じ場所のWendigoが落とす。競売で買ってもよい。', L('内ホルトト遺跡'), None,
      frm=['s04'], route='2回目以降'),
    S('c02', 'trade', 'Zubabaに「錆びた短剣」を3個渡して完了', None, L('天の塔'), zub,
      needs=[N('錆びた短剣', 3)], frm=['s04'], route='2回目以降'),
]
G.append(build(qid, steps, 'https://wiki.ffo.jp/html/6786.html', CHECKED))

# ---------------------------------------------------------------------------
# 王と道化師 WM8-2（7541）
# ---------------------------------------------------------------------------
qid = 'mission.windurst.018'
apu = 'npc.241.Apururu'
apu_loc = L('ウィンダス森の区', 'H-9')
wall = T('obj.194.Cracked_Wall', 'obj', 'Cracked Wall', L('外ホルトト遺跡', 'G-8'))
steps = [
    S('g01', 'talk', 'ウィンダス森の区(H-9)のApururuに話し「手の院の指輪」を入手', 'ガードでミッションを受けてから。',
      apu_loc, apu, frm=['s01']),
    S('g02', 'talk', 'ウィンダス水の区 北(G-8)のTosuka-Porikaから「目の院の指輪」をもらう', '残り3つの指輪は好きな順でよい。',
      L('ウィンダス水の区', 'G-8'), 'npc.238.Tosuka-Porika', frm=['s02']),
    S('g03', 'talk', 'ダボイ(J-8)のSedal-Godjalから「耳の院の指輪」をもらう', '修道窟を通って行く。',
      L('ダボイ', 'J-8'), 'npc.149.Sedal-Godjal', frm=['s02']),
    S('g04', 'examine', 'フェ・イン地下(F-6)のCermet Doorを調べて「鼻の院の指輪」をもらう',
      '部屋の入口の扉。中のRukususuには直接話しかけられない。Home Point#2が近い。', L('フェ・イン', 'F-6'), 'obj.204.Cermet_Door', frm=['s02']),
    S('g05', 'talk', 'ウィンダス森の区のApururuに話す', None, apu_loc, apu, frm=['s03']),
    S('g06', 'talk', '天の塔のKupipiに話す', '選択肢はどれでもよい。', L('天の塔'), kupipi, frm=['s03']),
    S('g07', 'go', '西サルタバルタ(F-4)から外ホルトト遺跡に入り、左手沿いに2枚目のマップへ',
      '外ホルトト遺跡はアマリリスの塔。G-7側からCracked Wallに近づくと、強いスライムに絡まれる。', L('西サルタバルタ', 'F-4'), None, frm=['s04']),
    S('g08', 'defeat', 'Cracked Wall(G-8)を調べ、Queen of SwordsとQueen of Coinsを倒す',
      'スニークで釣れば1体ずつ戦える。1体倒せば、残りが時間で消えてもよい。',
      L('外ホルトト遺跡', 'G-8'), T('mob.194.Queen_of_Swords', 'mob', 'Queen of Swords', L('外ホルトト遺跡', 'G-8')), frm=['s04']),
    S('g09', 'examine', 'もう一度Cracked Wallを調べてイベント、「口の院の指輪」を入手', None,
      L('外ホルトト遺跡', 'G-8'), wall, frm=['s05']),
    S('g10', 'talk', 'ウィンダス森の区のApururuに話す', None, apu_loc, apu, frm=['s06']),
    S('g11', 'talk', 'ウィンダス石の区(K-7)のShantottoに話し「常夜の手袋」を作ってもらう', None,
      L('ウィンダス石の区', 'K-7'), 'npc.239.Shantotto', frm=['s06']),
    S('g12', 'talk', 'Apururuに「常夜の手袋」を渡す', None, apu_loc, apu, frm=['s06']),
    S('g13', 'examine', '内ホルトト遺跡(I-7 テンキー1)の闇牢の扉（Gate of Darkness）を調べてイベント',
      '東サルタバルタ(J-7)から入り、魔封門の先。トライマライ水路のSurvival Guideから戻ると早い。',
      L('内ホルトト遺跡', 'I-7'), T('obj.192.Gate_of_Darkness', 'obj', 'Gate of Darkness', L('内ホルトト遺跡', 'I-7')), frm=['s07']),
    S('g14', 'talk', 'ウィンダス森の区のApururuに話して完了', 'ランク9、80,000ギル。', apu_loc, apu, frm=['s08']),
]
G.append(build(qid, steps, 'https://wiki.ffo.jp/html/7541.html', CHECKED))
