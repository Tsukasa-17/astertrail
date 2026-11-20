#!/usr/bin/env python3
"""0.1.218〜0.1.220：data/quests・data/missions の相手に、正確な座標（pos）を足す（0.1.220 で apply_exact_pos_219.py を置きかえた）。

元: dev/sources/exact_pos_extra.json と exact_pos_222.json（0.1.222〜）の targets（file が quests/・missions/ のもの。dev/compare/coords/make_exact_pos_219.py が作る）。
- まず前に足した分（出典 LSB の「座標 x=…」）を外す：pos を消し、MAP を出典の map_from に戻し、その出典を消す。
- それから、ゾーンとマス目が作ったときと同じ相手に pos を入れる。map_n があれば（MAP が書いてなかった場所。
  ゾーンの当たり判定の階から）MAP 番号も入れる。
- 0.1.220〜：マス目（場所の文字）も、座標のマスに合わせる（coords.relabel_grid。元のマス目は出典の grid_from）。
  境目の「H-8/I-8」などで座標のマスがその中にあるものは変えない。
- 出典は location_sources に足す（画面には出さない）。
何度走らせても同じ。このあと dev/build_guides.py を走らせる（手順と新しい相手は coords.apply_exact が当てる）。
dev/build_data.py は使わない。
"""
import json, pathlib, collections, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
DATA = ROOT / 'data'
SRC = ROOT / 'dev' / 'sources' / 'exact_pos_extra.json'
sys.path.insert(0, str(ROOT / 'dev' / 'guides'))
import coords


def is_ours(s):
    return s.get('name') == 'LSB' and (s.get('fact_ja') or '').startswith('座標 x=')


SRC_222 = ROOT / 'dev' / 'sources' / 'exact_pos_222.json'   # 0.1.222〜：同名が2つ以上で真ん中に残っていたもの（文と LSB で1つに決めた）
d = json.loads(SRC.read_text(encoding='utf-8'))
if SRC_222.exists():
    d['targets'] = (d.get('targets') or []) + (json.loads(SRC_222.read_text(encoding='utf-8')).get('targets') or [])
by_file = collections.defaultdict(dict)
for e in d.get('targets') or []:
    if e['file'].startswith(('quests/', 'missions/')):
        assert e['target'] not in by_file[e['file']], 'exact target twice: ' + e['target']
        by_file[e['file']][e['target']] = e
man = json.loads((DATA / 'manifest.json').read_text(encoding='utf-8'))
n = {'stripped': 0, 'applied': 0, 'map_set': 0, 'labels': 0}
for rel in man['files']:
    if not rel.startswith(('quests/', 'missions/')):
        continue
    p = DATA / rel
    doc = json.loads(p.read_text(encoding='utf-8'))
    want = by_file.get(rel, {})
    seen = set()
    for t in doc.get('targets') or []:
        srcs = t.get('location_sources') or []
        ours = [s for s in srcs if is_ours(s)]
        if ours:
            loc = t['location']
            loc.pop('pos', None)
            for s in ours:
                if s.get('map_from'):
                    loc['map'] = dict(s['map_from'])
                if 'grid_from' in s:
                    loc['grid'] = s['grid_from']
            srcs = [s for s in srcs if not is_ours(s)]
            if srcs:
                t['location_sources'] = srcs
            else:
                t.pop('location_sources', None)
            n['stripped'] += 1
        e = want.get(t['id'])
        if not e:
            continue
        loc = t.get('location') or {}
        assert loc.get('zone_id') == e['zone_id'] and loc.get('grid') == e['grid'], 'target moved: ' + t['id']
        assert not loc.get('pos'), 'target already has pos: ' + t['id']
        loc['pos'] = dict(e['pos'])
        if e.get('map_n'):
            assert (loc.get('map') or {}).get('kind') != 'number', 'map already known: ' + t['id']
            loc['map'] = {'kind': 'number', 'n': e['map_n']}
            n['map_set'] += 1
        srcs = [dict(s) for s in e['sources']]
        g = coords.relabel_grid(loc)
        if g:
            for s in srcs:
                s['grid_from'] = loc.get('grid')
            loc['grid'] = g
            n['labels'] += 1
        t['location'] = loc
        t['location_sources'] = (t.get('location_sources') or []) + srcs
        seen.add(t['id'])
        n['applied'] += 1
    missing = set(want) - seen
    assert not missing, (rel, sorted(missing))
    p.write_text(json.dumps(doc, ensure_ascii=False, indent=2, sort_keys=True) + '\n', encoding='utf-8')
# 0.1.220〜：クエストの注（note_ja・lock_reasons）の「ゾーン(旧)…名前」も直す。直す前の文は note_grid_from に残す（何度走らせても同じ）
docs = {}
for rel in man['files']:
    if rel.startswith(('quests/', 'missions/')):
        docs[rel] = json.loads((DATA / rel).read_text(encoding='utf-8'))
ch = coords.label_changes([d.get('targets') or [] for d in docs.values()])
n['notes'] = 0
for rel, doc in docs.items():
    hit = False
    for q in doc.get('quests') or []:
        if 'note_grid_from' in q:
            orig = q.pop('note_grid_from')
            q['note_ja'] = orig.get('note_ja')
            for r, t0 in zip(q.get('lock_reasons') or [], orig.get('lock_reasons') or []):
                r['text_ja'] = t0
            hit = True
        orig = {'note_ja': q.get('note_ja'), 'lock_reasons': [r.get('text_ja') for r in q.get('lock_reasons') or []]}
        k = 0
        v, k1 = coords.retext_named(q.get('note_ja'), ch)
        if k1:
            q['note_ja'] = v; k += k1
        for r in q.get('lock_reasons') or []:
            v, k1 = coords.retext_named(r.get('text_ja'), ch)
            if k1:
                r['text_ja'] = v; k += k1
        if k:
            q['note_grid_from'] = orig
            n['notes'] += k
            hit = True
    if hit:
        (DATA / rel).write_text(json.dumps(doc, ensure_ascii=False, indent=2, sort_keys=True) + '\n', encoding='utf-8')
print('exact pos', n)
