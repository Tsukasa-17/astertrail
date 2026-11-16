#!/usr/bin/env python3
"""新しく足すクエスト（*.gd の Q / RW / LK / XS 行）から data/quests/<区分>.json を作る（0.1.70〜）。

- 名前・報酬・条件は用語辞典（基礎シートの行）と、BG Wiki で直したもの（XS に出典）。推測で埋めない。
- 発生の相手は T と同じ書き方。新しい相手はこのファイルの targets に入れる（手順からも同じ id を使う）。
- 手順は build_guides.py（同じ .gd の手順の行）。先にこちらを走らせる。
"""
import json, re, sys, pathlib
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE / 'guides'))
DATA = HERE.parent / 'data'

CATS = {
    'jeuno': ('Jeuno', 'ジュノ'),
    'selbina_mhaura': ('Selbina / Mhaura', 'セルビナ・マウラ'),
    'norg': ('Norg', 'ノーグ'),
    'kazham': ('Kazham','カザム'),
    'rabao': ('Rabao','ラバオ'),
    'tavnazia': ('Tavnazian Safehold','タブナジア'),
    'records': ('Records of Eminence','エミネンス・レコード'),
    'aht_urhgan': ('Aht Urhgan','アトルガン'),
    'altana': ('Wings of the Goddess','アルタナ'),
    'abyssea': ('Abyssea','アビセア'),
    'adoulin': ('Adoulin','アドゥリン'),
    'misc': ('Other','その他'),
    'sandoria': ("San d'Oria", 'サンドリア'),
    'bastok': ('Bastok', 'バストゥーク'),
    'windurst': ('Windurst', 'ウィンダス'),
    # ミッションの系列（0.1.118〜）。本のミッションのタブで3国のすぐ後に並べる
    'zilart': ('Rise of the Zilart', 'ジラート'),
    'promathia': ('Chains of Promathia', 'プロマシア'),
    # 追加シナリオ（0.1.122〜）。アルタナのすぐ後に並べる
    'acp': ('A Crystalline Prophecy', '石の見る夢'),
    'mkd': ("A Moogle Kupo d'Etat", '戦慄！モグ祭りの夜'),
    'asa': ('A Shantotto Ascension', 'シャントット帝国の陰謀'),
    # 0.1.130〜。アドゥリンのすぐ後に並べる
    'rov': ("Rhapsodies of Vana'diel", 'ヴァナ・ディールの星唄'),
    'tvr': ('The Voracious Resurgence', '蝕世のエンブリオ'),
    'assault': ('Assault', 'アサルト'),
    'campaign': ('Campaign', 'カンパニエ'),
}
# 3国のすぐ後に入れる系列（ミッションだけの系列、拡張の順）
AFTER_NATIONS = ['zilart', 'promathia']
# 前からある3国のファイル（0.1.111〜）：.gd の Q 行にあるクエストだけを、いまの json に足す（ほかはそのまま残す）
# この系列のすぐ後に入れる（0.1.122〜）
AFTER_CAT = {'acp': 'altana', 'mkd': 'acp', 'asa': 'mkd', 'rov': 'adoulin', 'tvr': 'rov', 'assault': 'tvr', 'campaign': 'assault'}
MERGE = {'sandoria', 'bastok', 'windurst'}
CHECKED = '2026-11-14'

def zones():
    z = json.loads((DATA / 'zones.json').read_text(encoding='utf-8'))
    m = json.loads((DATA / 'maps.json').read_text(encoding='utf-8'))
    by = {x['zone_name']: x['zone_id'] for x in z['zones'] if x.get('zone_name')}
    ids, floors = {}, {}
    for f in m['floors']:
        if f.get('zone_name') and f.get('zone_id') is not None:
            ids.setdefault(f['zone_name'], set()).add(f['zone_id'])
            floors[f['zone_id']] = floors.get(f['zone_id'], 0) + 1
    for n, s in ids.items():
        if n not in by and len(s) == 1:
            by[n] = next(iter(s))
    return z, by, floors

def loc(spec, by, floors):
    parts = spec.split()
    zone, grid, mp = parts[0], None, None
    for p in parts[1:]:
        if p.startswith('#'): mp = int(p[1:])
        elif p != '-': grid = p if grid is None else grid + ' ' + p
    zid = by.get(zone)
    if mp is not None: m = {'kind': 'number', 'n': mp}
    elif zid is not None and floors.get(zid) == 1: m = {'kind': 'single'}
    else: m = {'kind': 'unknown'}
    return {'zone_id': zid, 'zone_name': zone, 'grid': grid, 'map': m}

def target(spec, by, floors):
    spec = spec.strip()
    if spec.startswith('T '): spec = spec[2:].strip()
    if '=' not in spec:
        return spec.strip(), None
    tid, rest = [x.strip() for x in spec.split('=', 1)]
    kind, rest = rest.split(':', 1)
    if '@' in rest:
        name, ls = rest.split('@', 1); L = loc(ls.strip(), by, floors)
    else:
        name, L = rest, None
    name = name.strip(); moves = same = False
    while name and name[-1] in '!~':
        if name[-1] == '!': moves = True
        else: same = True
        name = name[:-1].strip()
    return tid, {'id': tid, 'kind': kind.strip(), 'name_en': name, 'location': L, 'moves': moves, 'same_name': same}

def main():
    zdoc, by, floors = zones()
    files = {}
    used_zones = set()
    for gd in sorted((HERE / 'guides').glob('*.gd')):
        cur = None
        for raw in open(gd, encoding='utf-8'):
            line = raw.rstrip('\n')
            if line.startswith('@ '):
                _, qid, url = line.split()
                cur = {'qid': qid, 'url': url}
                continue
            if not cur:
                continue
            if line.startswith('Q '):
                f = [x.strip() for x in line[2:].split('|')]
                en, ja, rep, st = f[0], f[1], f[2], f[3] if len(f) > 3 else ''
                cat = cur['qid'].split('.')[1]
                assert cat in CATS, cur['qid']
                kind = 'mission' if cur['qid'].startswith('mission.') else 'quest'
                key = (kind, cat)
                cur['key'] = key
                if key not in files and cat in MERGE:
                    old = json.loads((DATA / ('%ss/%s.json' % key)).read_text(encoding='utf-8'))
                    files[key] = {'data_schema': old.get('data_schema', 1), 'quests': list(old['quests']),
                                  'targets': {t['id']: t for t in old.get('targets') or []}}
                doc = files.setdefault(key, {'data_schema': 1, 'quests': [], 'targets': {}})
                doc['quests'] = [x for x in doc['quests'] if x['id'] != cur['qid']]
                tid, t = target(st, by, floors) if st else (None, None)
                if t:
                    # 前からある相手に書いてある出典などの欄は残す（0.1.111〜）
                    doc['targets'][tid] = {**doc['targets'].get(tid, {}), **t}
                    if t['location'] and t['location']['zone_id']: used_zones.add((t['location']['zone_id'], t['location']['zone_name']))
                q = {'category': cat, 'game_ref': None, 'id': cur['qid'], 'kind': kind, 'lock_reasons': [],
                     'name_en': en, 'name_ja_ref': ja, 'repeatable': {'yes': 'yes', 'no': 'no'}.get(rep, 'unknown'),
                     'rewards': [], 'sources': [{'checked': CHECKED, 'url': cur['url'], 'via': 'wiki.ffo.jp'}],
                     'start': {'target': tid} if tid else None, 'steps': []}
                doc['quests'].append(q); cur['q'] = q
            elif line.startswith('MN '):
                # ミッションの番号と並び（0.1.118〜）：MN <番号 or -> <並び>
                no, order = line[3:].split()
                if no != '-': cur['q']['mission_no'] = no
                cur['q']['order'] = int(order)
            elif line.startswith('RK '):
                # 受けるのに要る所属国ランク（0.1.119〜、ジラートの最初など。国のミッション以外）
                cur['q']['need_rank'] = int(line[3:].strip())
            elif line.startswith('RW '):
                k, n = line[3:].split(':', 1)
                cur['q']['rewards'].append({'kind': k.strip(), 'name_ja': n.strip()})
            elif line.startswith('LK '):
                k, n = line[3:].split(':', 1)
                cur['q']['lock_reasons'].append({'type': k.strip(), 'text_ja': n.strip()})
            elif line.startswith('XS '):
                name, url, fact = line[3:].split(';', 2)
                cur['q']['sources'].append({'checked': CHECKED, 'url': url.strip(), 'via': name.strip(), 'fact_ja': fact.strip()})
    man_p = DATA / 'manifest.json'
    man = json.loads(man_p.read_text(encoding='utf-8'))
    seen_ids = set()
    for (kind, cat), doc in files.items():
        for q in doc['quests']:
            assert q['id'] not in seen_ids, q['id']; seen_ids.add(q['id'])
        doc['targets'] = sorted(doc['targets'].values(), key=lambda t: t['id'])
        if kind == 'mission' and all('order' in q for q in doc['quests']):
            doc['quests'].sort(key=lambda q: q['order'])   # 本の並び（0.1.119〜）
        rel = '%ss/%s.json' % (kind, cat)
        (DATA / rel).write_text(json.dumps(doc, ensure_ascii=False, indent=2, sort_keys=True) + '\n', encoding='utf-8')
        if rel not in man['files']:
            i = max(i for i, f in enumerate(man['files']) if f.startswith(kind + 's/'))
            man['files'].insert(i + 1, rel)
        if not any(c['id'] == cat for c in man['categories']):
            c = {'id': cat, 'label_en': CATS[cat][0], 'label_ja': CATS[cat][1]}
            if cat in AFTER_NATIONS:
                ids = [x['id'] for x in man['categories']]
                prev = ['windurst'] + AFTER_NATIONS[:AFTER_NATIONS.index(cat)]
                i = max(ids.index(x) for x in prev if x in ids)
                man['categories'].insert(i + 1, c)
            elif cat in AFTER_CAT and AFTER_CAT[cat] in [x['id'] for x in man['categories']]:
                ids = [x['id'] for x in man['categories']]
                man['categories'].insert(ids.index(AFTER_CAT[cat]) + 1, c)
            else:
                man['categories'].append(c)
        print(kind, cat, len(doc['quests']), 'records', len(doc['targets']), 'targets')
    man_p.write_text(json.dumps(man, ensure_ascii=False, indent=2, sort_keys=True) + '\n', encoding='utf-8')
    # zones.json に無いゾーン（maps.json で名前が一つに決まるもの）を足す
    have = {z['zone_id'] for z in zdoc['zones']}
    add = 0
    for gd in sorted((HERE / 'guides').glob('*.gd')):
        for m in re.finditer(r'@([^\s|#]+)', open(gd, encoding='utf-8').read()):
            n = m.group(1)
            zid = by.get(n)
            if zid is not None and zid not in have:
                zdoc['zones'].append({'checked': False, 'maps': 'unknown', 'zone_id': zid, 'zone_name': n}); have.add(zid); add += 1
    zdoc['zones'].sort(key=lambda z: z['zone_id'])
    (DATA / 'zones.json').write_text(json.dumps(zdoc, ensure_ascii=False, indent=2, sort_keys=True) + '\n', encoding='utf-8')
    print('zones added', add)

if __name__ == '__main__':
    main()
