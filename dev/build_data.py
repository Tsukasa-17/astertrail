#!/usr/bin/env python3
"""
Astertrail 初版データの組み立て（開発用。ゲームには不要）

出典: 共有の基礎シート「FF11クエスト一覧（用語辞典ベース）」
  https://docs.google.com/spreadsheets/d/1YMnJiDxFuuV-JOe3NJXz1TqYHAdFFese4ScXhMFETf0
  （2026-11-12 JST に読み取り。シートは FF11用語辞典 https://wiki.ffo.jp/ を参照して作られたもの）

方針:
- 名前・エリア・座標・報酬・条件はシートの表記どおり。分からないものは空のまま。
- 手順の1行（next_line_ja / text_ja）は、シートの項目から独自に書いた短い要約。記事本文の写しではない。
- Journal / Questlog のデータは使っていない。
- zone_id はクライアントのゾーン番号（一般に知られた値）。実機での照合は未了（zones.json の checked=false）。
"""
import json, os

ROOT = os.path.join(os.path.dirname(__file__), '..', 'data')
DATA_VERSION = '2026.11.12-7'
SHEET = 'https://docs.google.com/spreadsheets/d/1YMnJiDxFuuV-JOe3NJXz1TqYHAdFFese4ScXhMFETf0'
READ_ON = '2026-11-12'

ZONES = [
    # zone_id, 用語辞典表記の名前
    (101, '東ロンフォール'),
    (108, 'コンシュタット高地'),
    (116, '東サルタバルタ'),
    (143, 'パルブロ鉱山'),
    (172, 'ツェールン鉱山'),
    (191, 'ダングルフの涸れ谷'),
    (192, '内ホルトト遺跡'),
    (230, '南サンドリア'),
    (231, '北サンドリア'),
    (234, 'バストゥーク鉱山区'),
    (235, 'バストゥーク商業区'),
    (237, '大工房'),
    (238, 'ウィンダス水の区'),
    (240, 'ウィンダス港'),
    (241, 'ウィンダス森の区'),
]
ZNAME = dict(ZONES)

def loc(zone_id=None, grid=None, map_n=None, map_kind='unknown', zone_name=None):
    if zone_id is None and zone_name is None:
        return None
    if grid:
        grid = grid.strip('()')
    m = {'kind': map_kind}
    if map_n is not None:
        m = {'kind': 'number', 'n': map_n}
    return {
        'zone_id': zone_id,
        'zone_name': zone_name or ZNAME.get(zone_id),
        'map': m,
        'grid': grid,
    }

def npc(zone_id, name, grid=None, same_name=False, moves=False, map_n=None, map_kind='unknown'):
    return {
        'id': 'npc.%d.%s' % (zone_id, name.replace(' ', '_')),
        'kind': 'npc', 'name_en': name, 'same_name': same_name, 'moves': moves,
        'location': loc(zone_id, grid, map_n, map_kind=map_kind),
    }

def mob(zone_id, name, zone_name=None):
    slug = name.replace(' ', '_')
    tid = ('mob.%d.%s' % (zone_id, slug)) if zone_id is not None else ('mob.%s' % slug)
    return {
        'id': tid,
        'kind': 'mob', 'name_en': name, 'same_name': False, 'moves': True,
        'location': loc(zone_id, None, zone_name=zone_name),
    }

def obj(zone_id, name, grid=None, map_n=None):
    return {
        'id': 'obj.%d.%s' % (zone_id, name.replace(' ', '_').replace(':', '')),
        'kind': 'obj', 'name_en': name, 'same_name': False, 'moves': False,
        'location': loc(zone_id, grid, map_n),
    }

def need(name_ja, count, kind='item', group=None):
    n = {'kind': kind, 'item_id': None, 'count': count, 'name_ja': name_ja, 'name_en': None}
    if group:
        n['group'] = group
    return n

def step(qid, n, typ, line, text=None, location=None, target=None, needs=None,
         tw=None, nxt='auto', location_note=None):
    s = {
        'id': '%s#s%02d' % (qid, n),
        'order': n,
        'type': typ,
        'next_line_ja': line,
        'text_ja': text,
        'text_status': 'draft_from_sheet',
        'location': location,
        'target': target,
        'needs': needs or [],
        'time_weather_ja': tw,
    }
    if location_note:
        s['location_note_ja'] = location_note
    s['_next'] = nxt
    return s

def finish_steps(steps):
    for i, s in enumerate(steps):
        nxt = s.pop('_next')
        if nxt == 'auto':
            s['next'] = [steps[i + 1]['id']] if i + 1 < len(steps) else []
        else:
            s['next'] = nxt
    return steps

def quest(qid, kind, category, name_en, name_ja_ref, url, repeatable, rewards,
          lock_reasons, start_target, steps, note=None, mission_no=None):
    q = {
        'id': qid, 'kind': kind, 'category': category, 'name_en': name_en,
        'name_ja_ref': name_ja_ref,
        'game_ref': None,
        'repeatable': repeatable,
        'lock_reasons': lock_reasons,
        'start': {'target': start_target},
        'rewards': rewards,
        'sources': [{'url': url, 'checked': READ_ON, 'via': 'sheet'}],
        'steps': finish_steps(steps),
    }
    if note:
        q['note_ja'] = note
    if mission_no:
        q['mission_no'] = mission_no
    return q

def gil(text):
    return {'kind': 'gil', 'name_ja': text}

def title(text):
    return {'kind': 'title', 'name_ja': text}

def item(text):
    return {'kind': 'item', 'name_ja': text, 'name_en': None}

def other(text):
    return {'kind': 'other', 'name_ja': text}

def lock(text, typ='condition'):
    return {'type': typ, 'text_ja': text}

files = {}

# ---------------------------------------------------------------- San d'Oria
T = []
Q = []
q = 'quest.sandoria.001'
t = npc(230, 'Parvipon', '(E-8)'); T.append(t)
Q.append(quest(q, 'quest', 'sandoria', "The Merchant's Bidding", '商人のお願い',
    'https://wiki.ffo.jp/html/6465.html', 'yes',
    [gil('120ギル'), title('ワイルドハンター')], [], t['id'], [
    step(q, 1, 'talk', 'Parviponに話して受ける', '革工ギルド横のParviponに話す。', loc(230, 'E-8'), t['id']),
    step(q, 2, 'gather', '野兎の毛皮を3個用意する', 'ウサギ族から手に入る。革工ギルドでも買える。',
         None, None, [need('野兎の毛皮', 3)], location_note='場所の指定なし'),
    step(q, 3, 'trade', 'Parviponに野兎の毛皮3個を渡す', None, loc(230, 'E-8'), t['id'], [need('野兎の毛皮', 3)]),
]))
q = 'quest.sandoria.002'
t = npc(230, 'Legata', '(K-6)'); T.append(t)
Q.append(quest(q, 'quest', 'sandoria', 'Starting a Flame', '火打石の調達',
    'https://wiki.ffo.jp/html/6034.html', 'yes', [gil('100ギル')], [], t['id'], [
    step(q, 1, 'talk', '獅子の泉のLegataに話して受ける', None, loc(230, 'K-6'), t['id']),
    step(q, 2, 'gather', '火打石を4個集める', 'ワーム族から。競売でも可。', None, None,
         [need('火打石', 4)], location_note='場所の指定なし'),
    step(q, 3, 'trade', 'Legataに火打石4個を渡す', None, loc(230, 'K-6'), t['id'], [need('火打石', 4)]),
]))
q = 'quest.sandoria.003'
t = npc(231, 'Secodiand', '(F-6)'); T.append(t)
Q.append(quest(q, 'quest', 'sandoria', 'Fear of the Dark', '闇への抵抗',
    'https://wiki.ffo.jp/html/5054.html', 'yes', [gil('200ギル')], [], t['id'], [
    step(q, 1, 'talk', 'ギルド前広場のSecodiandに話して受ける', None, loc(231, 'F-6'), t['id']),
    step(q, 2, 'gather', 'コウモリの翼を2個集める', 'コウモリ族から。競売でも可。', None, None,
         [need('コウモリの翼', 2)], location_note='場所の指定なし'),
    step(q, 3, 'trade', 'Secodiandにコウモリの翼2個を渡す', None, loc(231, 'F-6'), t['id'], [need('コウモリの翼', 2)]),
]))
q = 'quest.sandoria.004'
t = npc(230, 'Taumila', '(F-9)'); T.append(t)
Q.append(quest(q, 'quest', 'sandoria', "Tiger's Teeth", 'トラの牙',
    'https://wiki.ffo.jp/html/4247.html', 'yes', [gil('2,100ギル'), title('ファング')],
    [lock('名声ランク3（「聞いた覚えがあるぞ」）以上', 'fame')], t['id'], [
    step(q, 1, 'talk', '雑貨のターミラのTaumilaに話して受ける', None, loc(230, 'F-9'), t['id']),
    step(q, 2, 'gather', '黒虎の牙を3本集める', '剣虎族から。競売でも可。', None, None,
         [need('黒虎の牙', 3)], location_note='場所の指定なし'),
    step(q, 3, 'trade', 'Taumilaに黒虎の牙3本を渡す', None, loc(230, 'F-9'), t['id'], [need('黒虎の牙', 3)]),
]))
files['quests/sandoria.json'] = (Q, T)

# ---------------------------------------------------------------- Bastok
T = []; Q = []
q = 'quest.bastok.001'
t = npc(234, 'Gerbaum', '(F-8)'); T.append(t)
Q.append(quest(q, 'quest', 'bastok', 'Minesweeper', 'ツェールン鉱山の大掃除',
    'https://wiki.ffo.jp/html/6497.html', 'yes', [gil('150ギル'), title('ツェールンスイーパー')], [], t['id'], [
    step(q, 1, 'talk', '作業場のGerbaumに話して受ける', None, loc(234, 'F-8'), t['id']),
    step(q, 2, 'gather', 'ツェールン鉱山でツェールンの煤を3個集める', 'ツェールン鉱山のモンスターから。',
         loc(172), None, [need('ツェールンの煤', 3)]),
    step(q, 3, 'trade', 'Gerbaumにツェールンの煤3個を渡す', None, loc(234, 'F-8'), t['id'], [need('ツェールンの煤', 3)]),
]))
q = 'quest.bastok.002'
t = npc(235, 'Aquillina', '(K-9)'); T.append(t)
Q.append(quest(q, 'quest', 'bastok', 'A Flash in the Pan', 'カマドに火をつけて',
    'https://wiki.ffo.jp/html/10078.html', 'yes', [gil('100ギル')], [], t['id'], [
    step(q, 1, 'talk', '民家のAquillinaに話して受ける', None, loc(235, 'K-9'), t['id']),
    step(q, 2, 'gather', '火打石を4個用意する', None, None, None, [need('火打石', 4)], location_note='場所の指定なし'),
    step(q, 3, 'trade', 'Aquillinaに火打石4個を渡す', '渡した直後は地球時間15分ほど受け取ってもらえないことがある。',
         loc(235, 'K-9'), t['id'], [need('火打石', 4)]),
]))
q = 'quest.bastok.003'
t = npc(235, 'Horatius', '(I-9)'); T.append(t)
o = obj(191, '???', 'I-5', 1); T.append(o)
Q.append(quest(q, 'quest', 'bastok', 'Breaking Stones', 'ダングルフの奇岩',
    'https://wiki.ffo.jp/html/7852.html', 'yes', [gil('400ギル')], [], t['id'], [
    step(q, 1, 'talk', '民家のHoratiusに話して受ける', None, loc(235, 'I-9'), t['id']),
    step(q, 2, 'examine', 'ダングルフの涸れ谷の???を調べてダングルフの奇岩石を手に入れる', None,
         loc(191, 'I-5', 1), o['id'], [], tw='晴れの時'),
    step(q, 3, 'trade', 'Horatiusにダングルフの奇岩石を渡す', None, loc(235, 'I-9'), t['id'], [need('ダングルフの奇岩石', 1)]),
]))
q = 'quest.bastok.004'
t = npc(234, 'Pavvke', '(I-7)'); T.append(t)
m = mob(143, 'Greater Quadav'); T.append(m)
Q.append(quest(q, 'quest', 'bastok', 'Fallen Comrades', '心の壁',
    'https://wiki.ffo.jp/html/10481.html', 'yes', [gil('550ギル')],
    [lock('名声ランク2（「聞いた覚えがあるような」）以上', 'fame')], t['id'], [
    step(q, 1, 'talk', '民家のPavvkeに話して受ける', None, loc(234, 'I-7'), t['id']),
    step(q, 2, 'defeat', 'パルブロ鉱山のGreater Quadavを倒して銀の認識票を手に入れる', None, loc(143), m['id']),
    step(q, 3, 'trade', 'Pavvkeに銀の認識票を渡す', None, loc(234, 'I-7'), t['id'], [need('銀の認識票', 1)]),
]))

q = 'quest.bastok.005'
nbu = npc(235, 'Nbu Latteh', '(J-9)'); T.append(nbu)
roh = npc(234, 'Roh Latteh', '(H-7)'); T.append(roh)
Q.append(quest(q, 'quest', 'bastok', "Mom, the Adventurer?", 'ママは冒険者？',
    'https://wiki.ffo.jp/html/15793.html', 'yes',
    [gil('200ギル（手紙を読むと100ギル）'), title('怪しい運び屋')],
    [], nbu['id'], [
    step(q, 1, 'talk', '黄金通りのNbu Lattehに話して受ける',
         '話を受けると炎のクリスタルを1つ渡される。', loc(235, 'J-9'), nbu['id']),
    step(q, 2, 'gather', 'カッパーリングを1個用意する',
         '彫金の合成品。バストゥーク商業区内のカーミライド宝石店でも入手できる。',
         None, None, [need('カッパーリング', 1)], location_note='場所の指定なし'),
    step(q, 3, 'trade', '鉱山区の扉の中のRoh Lattehにカッパーリングを渡し、ロー・ラッテからの手紙を受け取る',
         None, loc(234, 'H-7'), roh['id'], [need('カッパーリング', 1)],
         location_note='扉の中'),
    step(q, 4, 'talk', 'Nbu Lattehに話して完了する',
         'だいじなもの「ロー・ラッテからの手紙」の中身を確認すると報酬が減る。',
         loc(235, 'J-9'), nbu['id']),
], note='ママの大仕事が発生すると再オファー不可'))
q = 'quest.bastok.006'
sp = obj(108, 'Signpost', 'G-5'); T.append(sp)
Q.append(quest(q, 'quest', 'bastok', 'The Signpost Marks the Spot', 'ママの大仕事',
    'https://wiki.ffo.jp/html/15794.html', 'no',
    [item('リネンローブ'), title('トレジャーハンター')],
    [lock('クエスト「ママは冒険者？」コンプリート後にエリアチェンジする', 'quest'),
     lock('名声ランク2（「聞いた覚えがあるような」）以上', 'fame')],
    nbu['id'], [
    step(q, 1, 'talk', '黄金通りのNbu Lattehに話して受ける', None, loc(235, 'J-9'), nbu['id']),
    step(q, 2, 'examine', 'コンシュタット高地のSignpostを調べて、だいじなもの「風車の絵」を手に入れる',
         None, loc(108, 'G-5'), sp['id']),
    step(q, 3, 'talk', '鉱山区の扉の中のRoh Lattehのところへ行く',
         None, loc(234, 'H-7'), roh['id'], [need('風車の絵', 1, kind='key_item')],
         location_note='扉の中'),
]))

files['quests/bastok.json'] = (Q, T)

# ---------------------------------------------------------------- Windurst
T = []; Q = []
q = 'quest.windurst.001'
t = npc(241, 'Illu Bohjaa', '(I-6)'); T.append(t)
Q.append(quest(q, 'quest', 'windurst', 'Creepy Crawlies', 'クロウラーを狩る者',
    'https://wiki.ffo.jp/html/11704.html', 'yes', [gil('600ギル'), title('クロウラーバスター')], [], t['id'], [
    step(q, 1, 'talk', 'ダルメル牧場のIllu Bohjaaに話して受ける', None, loc(241, 'I-6'), t['id']),
    step(q, 2, 'gather', '絹糸3個かクロウラーの石3個を用意する', 'どちらか一方でよい。', None, None,
         [need('絹糸', 3, group='a'), need('クロウラーの石', 3, group='a')], location_note='場所の指定なし'),
    step(q, 3, 'trade', 'Illu Bohjaaに渡す', None, loc(241, 'I-6'), t['id'],
         [need('絹糸', 3, group='a'), need('クロウラーの石', 3, group='a')]),
]))
q = 'quest.windurst.002'
t = npc(241, 'Tapoh Lihzeh', '(I-8)'); T.append(t)
Q.append(quest(q, 'quest', 'windurst', 'Paying Lip Service', '売れ筋商品',
    'https://wiki.ffo.jp/html/14380.html', 'yes',
    [other('蜂の巣のかけら3個で150G、レミ貝の殻2個で200G'), title('美の開拓者')], [], t['id'], [
    step(q, 1, 'talk', 'ミスラの薬屋のTapoh Lihzehに話して受ける', None, loc(241, 'I-8'), t['id']),
    step(q, 2, 'gather', '蜂の巣のかけら3個かレミ貝の殻2個を用意する', 'どちらか一方でよい。', None, None,
         [need('蜂の巣のかけら', 3, group='a'), need('レミ貝の殻', 2, group='a')], location_note='場所の指定なし'),
    step(q, 3, 'trade', 'Tapoh Lihzehに渡す', None, loc(241, 'I-8'), t['id'],
         [need('蜂の巣のかけら', 3, group='a'), need('レミ貝の殻', 2, group='a')]),
]))
q = 'quest.windurst.003'
# ウィンダス水の区は北が MAP 1、南が MAP 2（2026-11-12、利用者確認。用語辞典に番号の記載なし）
t = npc(238, 'Moreno-Toeno', '(L-6)', map_n=1); T.append(t)
Q.append(quest(q, 'quest', 'windurst', "Teacher's Pet", '教材募集',
    'https://wiki.ffo.jp/html/11705.html', 'yes', [gil('250ギル')], [], t['id'], [
    step(q, 1, 'talk', '耳の院のMoreno-Toenoに話して受ける', 'ウィンダス水の区（北部）の耳の院。', loc(238, 'L-6', 1), t['id']),
    step(q, 2, 'gather', 'マンドラゴラの双葉と鳥の羽根を1つずつ用意する', None, None, None,
         [need('マンドラゴラの双葉', 1), need('鳥の羽根', 1)], location_note='場所の指定なし'),
    step(q, 3, 'trade', 'Moreno-Toenoに渡す', None, loc(238, 'L-6', 1), t['id'],
         [need('マンドラゴラの双葉', 1), need('鳥の羽根', 1)]),
]))
q = 'quest.windurst.004'
t = npc(241, 'Nanaa Mihgo', '(J-3)'); T.append(t)
Q.append(quest(q, 'quest', 'windurst', "Mihgo's Amigo", '仲良くしたい？',
    'https://wiki.ffo.jp/html/4240.html', 'yes', [gil('200ギル'), title('泥棒ミスラのコブン')],
    [lock('シーフAFクエスト進行中は不可')], t['id'], [
    step(q, 1, 'talk', 'ミスラ居住区のNanaa Mihgoに話して受ける', None, loc(241, 'J-3'), t['id']),
    step(q, 2, 'gather', 'ヤグードの数珠を4個集める', 'ヤグードのドロップ品。', None, None,
         [need('ヤグードの数珠', 4)], location_note='場所の指定なし'),
    step(q, 3, 'trade', 'Nanaa Mihgoにヤグードの数珠4個を渡す', None, loc(241, 'J-3'), t['id'], [need('ヤグードの数珠', 4)]),
]))
files['quests/windurst.json'] = (Q, T)

# ---------------------------------------------------------------- Missions
T = []; Q = []
q = 'mission.sandoria.001'
fodder = mob(None, 'Orcish Fodder'); T.append(fodder)
Q.append(quest(q, 'mission', 'sandoria', 'Smash the Orcish Scouts', 'オークの斥候を倒せ',
    'https://wiki.ffo.jp/html/8244.html', 'unknown', [], [], None, [
    step(q, 1, 'talk', 'サンドリアのガードでミッションを受ける', 'ガードの名前・座標は不明。', None, None,
         location_note='サンドリアのガード（場所の詳細は不明）'),
    step(q, 2, 'defeat', 'Orcish Fodderを倒してオーキシュアクスを手に入れる', None, None, fodder['id'],
         location_note='場所の指定なし'),
    step(q, 3, 'trade', 'ガードにオーキシュアクスを渡す', None, None, None, [need('オーキシュアクス', 1)],
         location_note='サンドリアのガード'),
], note='報酬は不明', mission_no='SM1-1'))
q = 'mission.sandoria.002'
o = obj(101, 'Tombstone', 'I-10'); T.append(o)
bats = mob(None, 'Ding Bats'); T.append(bats)
Q.append(quest(q, 'mission', 'sandoria', 'Bat Hunt', 'コウモリ退治',
    'https://wiki.ffo.jp/html/8245.html', 'unknown', [], [], None, [
    step(q, 1, 'talk', 'ガードでミッションを受ける', None, None, None, location_note='サンドリアのガード'),
    step(q, 2, 'examine', '龍王ランペールの墓でTombstoneを調べる', '東ロンフォール南端。', loc(101, 'I-10'), o['id']),
    step(q, 3, 'defeat', 'Ding Batsを倒してオークの鎧の小札を手に入れる', None, None, bats['id'], tw='夜間',
         location_note='場所の詳細は不明'),
    step(q, 4, 'trade', 'ガードにオークの鎧の小札を渡す', None, None, None, [need('オークの鎧の小札', 1)],
         location_note='サンドリアのガード'),
], note='報酬は不明。2回目以降の扱いも不明', mission_no='SM1-2'))
files['missions/sandoria.json'] = (Q, T)

T = []; Q = []
q = 'mission.bastok.001'
t1 = npc(172, 'Makarim', '(H-11)'); T.append(t1)
# 大工房の Naji は J-8（利用者確認、2026-11-12）。地図は1枚。同名がいるので座標で区別する。
t2 = npc(237, 'Naji', '(J-8)', same_name=True, map_kind='single'); T.append(t2)
Q.append(quest(q, 'mission', 'bastok', 'The Zeruhn Report', 'ツェールン鉱山からの報告',
    'https://wiki.ffo.jp/html/8407.html', 'unknown', [], [], None, [
    step(q, 1, 'talk', 'ガードでミッションを受ける', None, None, None, location_note='バストゥークのガード'),
    step(q, 2, 'talk', 'ツェールン鉱山のMakarimから報告書を受け取る', None, loc(172, 'H-11'), t1['id']),
    step(q, 3, 'talk', '大工房の大統領府前のNajiに報告書を届ける', None, loc(237, 'J-8', map_kind='single'), t2['id']),
], note='報酬は不明', mission_no='BM1-1'))
files['missions/bastok.json'] = (Q, T)

T = []; Q = []
q = 'mission.windurst.001'
t1 = npc(240, 'Hakkuru-Rinkuru', '(E-7)'); T.append(t1)
# Gate: Magical Gizmo は MAP 1・I-9。H-9 はそこに行くための隠し扉（2026-11-12、利用者確認）
o1 = obj(192, 'Gate: Magical Gizmo', 'I-9', 1); T.append(o1)
o2 = obj(192, 'Ancient Magical Gizmo', None, 1); T.append(o2)  # 基礎シート「同マップに6つ」（Gate と同じ MAP 1）
Q.append(quest(q, 'mission', 'windurst', 'The Horutoto Ruins Experiment', 'ホルトト遺跡の大実験',
    'https://wiki.ffo.jp/html/6463.html', 'unknown',
    [title('北風団の新米'), title('天の塔前・魔戦士隊員'), title('ウェスト・オブ・ビースト'), title('ブーマガードの新米')],
    [], None, [
    step(q, 1, 'talk', 'ゲートハウスでミッションを受ける', '移籍者はウィンダス港(B-5)のJanshura-Rashura。',
         None, None, location_note='ウィンダスのゲートハウス'),
    step(q, 2, 'talk', 'ウィンダス港のHakkuru-Rinkuruの話を聞く', None, loc(240, 'E-7'), t1['id']),
    step(q, 3, 'examine', '内ホルトト遺跡の隠し扉の奥でGate: Magical Gizmoを調べる',
         '東サルタバルタ(J-7)の魔法塔から入る。隠し扉は H-9、Gate: Magical Gizmo は I-9。西の小部屋の奥は強い敵がいて危険。', loc(192, 'I-9', 1), o1['id']),
    step(q, 4, 'examine', 'Ancient Magical Gizmoから割れた魔導球を回収する', '6つのうちどれか（ランダム）。', loc(192, None, 1), o2['id']),
    step(q, 5, 'talk', 'Hakkuru-Rinkuruに割れた魔導球を届ける', None, loc(240, 'E-7'), t1['id'],
         [need('割れた魔導球', 1, kind='key_item')]),
], note='報酬の称号はオファー時', mission_no='WM1-1'))
files['missions/windurst.json'] = (Q, T)

# ---------------------------------------------------------------- write
def dump(rel, obj):
    p = os.path.join(ROOT, rel)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, 'w', encoding='utf-8', newline='\n') as f:
        json.dump(obj, f, ensure_ascii=False, indent=2, sort_keys=True)
        f.write('\n')

listed = []
for rel, (qs, ts) in files.items():
    dump(rel, {'data_schema': 1, 'quests': qs, 'targets': ts})
    listed.append(rel)

dump('zones.json', {'data_schema': 1, 'zones': [
    {'zone_id': z, 'zone_name': n, 'maps': 'unknown', 'checked': False} for z, n in ZONES]})

GUARDS = ['Ambrotien', 'Endracion', 'Grilau', 'Argus', 'Cleades', 'Malduc', 'Rashid',
          'Mokyokyo', 'Janshura-Rashura', 'Rakoh Buuma', 'Zokima-Rokima']
# 所属国（2026-11-14 に確かめた。出典は guards.json の各ガードの sources）
GUARD_NATION = {'Ambrotien': 'sandoria', 'Endracion': 'sandoria', 'Grilau': 'sandoria', 'Argus': 'bastok', 'Cleades': 'bastok', 'Malduc': 'bastok', 'Rashid': 'bastok', 'Mokyokyo': 'windurst', 'Janshura-Rashura': 'windurst', 'Rakoh Buuma': 'windurst', 'Zokima-Rokima': 'windurst'}
guards = []
for g in GUARDS:
    e = {'id': 'guard.%s' % g.replace(' ', '_'), 'name_en': g, 'nation': GUARD_NATION.get(g), 'location': None,
         'same_name': False, 'moves': False}
    if e['nation']:
        e['sources'] = [{'checked': '2026-11-14', 'url': 'https://pegasusxi.com/wiki/Category:Gate_Guard', 'via': 'web'},
                        {'checked': '2026-11-14', 'url': 'https://ffxi.allakhazam.com/db/npc-function/9', 'via': 'web'}]
    if g == 'Janshura-Rashura':
        e['location'] = loc(240, 'B-5')
        e['note_ja'] = 'ウィンダスミッション1-1の行に「移籍者はウィンダス港(B-5)のJanshura-Rashura」とある'
    guards.append(e)
dump('guards.json', {'data_schema': 1, 'guards': guards,
                     'note_ja': '名前だけを先に収録。所属国・場所は確かめてから入れる（頭上マークは次の段階）'})

dump('manifest.json', {
    'data_version': DATA_VERSION,
    'data_schema': 1,
    'built': READ_ON,
    'source': {'sheet': SHEET, 'read_on': READ_ON, 'reference': 'https://wiki.ffo.jp/'},
    'scope': '公式系のクエスト・ミッションの少数（初版の動作確認用）。CatsEye独自は含めない。',
    'files': ['zones.json', 'guards.json', 'maps.json'] + listed,
    'categories': [
        {'id': 'sandoria', 'label_ja': 'サンドリア', 'label_en': "San d'Oria"},
        {'id': 'bastok', 'label_ja': 'バストゥーク', 'label_en': 'Bastok'},
        {'id': 'windurst', 'label_ja': 'ウィンダス', 'label_en': 'Windurst'},
    ],
    'renamed': {},
})
print('ok', listed)
