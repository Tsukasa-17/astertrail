#!/usr/bin/env python3
"""手順の書き直し（steps v2）を data/guides/steps_v2.json に書き出す。

古い手順の下書きは 0.1.54 でゲーム用データから外した（文はシートに残る）。アドオンは新しい手順だけを使い、
下書きへの代替表示はしない。保存済みの進み具合は、古い id → 新しい id の対応表
（guides/step_map.json、ここで migrated_from から作る）と migrated_from で引き継ぐ。
"""
import json, sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent / 'guides'))
import common
import pilot_missions, pilot_quests, textfmt, coords

OUT = common.DATA / 'guides' / 'steps_v2.json'
REL = 'guides/steps_v2.json'
MAP_OUT = common.DATA / 'guides' / 'step_map.json'
MAP_REL = 'guides/step_map.json'
DATA_VERSION = '2026.11.16-112'

guides = pilot_missions.G + pilot_quests.G
GD_DIR = pathlib.Path(__file__).resolve().parent / 'guides'
for gd in sorted(GD_DIR.glob('*.gd')):
    guides += textfmt.parse(gd, '2026-11-14')
common.check_pending()
seen = set()
for g in guides:
    assert g['quest'] not in seen, 'duplicate guide ' + g['quest']
    seen.add(g['quest'])
# 座標の直し（BG Wiki と FFXIclopedia が一致したもの。dev/compare/coords/）
_names = {tid: t.get('name_en') for tid, t in common.EXISTING_T.items()}
_names.update({tid: t.get('name_en') for tid, t in common.NEW_TARGETS.items()})
print('coords', coords.apply(guides, common.NEW_TARGETS, _names))
print('game', coords.apply_game(guides, common.NEW_TARGETS))
doc = {
    'data_schema': 1,
    'data_kind': 'guides',
    'guide_version': 1,
    'note_ja': '各記事を読んで書き直した手順。記事の文はそのまま写していない。書いていないことは空のまま。',
    'sources': [{'name': '用語辞典', 'urls': ['https://wiki.ffo.jp/']}],
    'guides': guides,
    'targets': sorted(common.NEW_TARGETS.values(), key=lambda t: t['id']),
}
OUT.parent.mkdir(parents=True, exist_ok=True)
OUT.write_text(json.dumps(doc, ensure_ascii=False, indent=2, sort_keys=True) + '\n', encoding='utf-8')

# 古い id → 新しい id（文は入れない）。保存済みのチェックを引き継ぐためだけに使う。
step_map = {}
for g in guides:
    for s in g['steps']:
        for old in s.get('migrated_from') or []:
            step_map.setdefault(old, []).append(s['id'])
for g in guides:
    for old in common.old_step_ids(g['quest']):
        assert old in step_map, 'old step not mapped ' + old
MAP_OUT.write_text(json.dumps({
    'data_schema': 1,
    'data_kind': 'step_map',
    'note_ja': '古い手順（下書き）の id → 新しい手順の id。保存済みのチェックを引き継ぐためだけに使う。下書きの文はシートにある。',
    'map': {k: step_map[k] for k in sorted(step_map)},
}, ensure_ascii=False, separators=(',', ':'), sort_keys=True) + '\n', encoding='utf-8')

man_path = common.DATA / 'manifest.json'
man = json.loads(man_path.read_text(encoding='utf-8'))
for rel in (REL, MAP_REL):
    if rel not in man['files']:
        man['files'].append(rel)
man['data_version'] = DATA_VERSION
man['guides_ja'] = '手順は guides/steps_v2.json（記事をもとに書き直したもの。出典は各手順の sources）だけを使う。古い下書きはゲーム用データから外した（文はシートにある）。guides/step_map.json は古い手順 id → 新しい id の対応表。'
man_path.write_text(json.dumps(man, ensure_ascii=False, indent=2, sort_keys=True) + '\n', encoding='utf-8')

n_old = sum(len(common.old_step_ids(g['quest'])) for g in guides)
n_new = sum(len(g['steps']) for g in guides)
print('guides', len(guides), 'steps', n_old, '->', n_new, 'new targets', len(common.NEW_TARGETS))
for g in guides:
    q = common.EXISTING_Q[g['quest']]
    longest = max(len(s['next_line_ja']) for s in g['steps'])
    print(' %-22s %-40s %2d -> %2d  max line %d' % (g['quest'], q['name_en'][:40], len(common.old_step_ids(g['quest'])), len(g['steps']), longest))
