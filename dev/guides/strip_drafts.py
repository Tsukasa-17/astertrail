#!/usr/bin/env python3
"""古い手順の下書き（data/quests, data/missions の steps）をゲーム用データから外す（2026-11-14、1回だけ）。

- 下書きの文はシート（基礎シートの「手順の要点」）に残っているので、ゲーム用データには持たない。
- シートの文と同じだと確かめられなかった件（KEEP）は消さずに残す。
- 保存済みの進み具合（古い手順 id のチェック）を引き継ぐため、古い id → 新しい id の対応表だけ
  data/guides/step_map.json に残す（文は入れない）。対応表は build_guides.py が毎回書き直す。
"""
import json, pathlib, sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
DATA = ROOT / 'data'

# 0.1.54 では、シートの「手順の要点」と文が一致しなかった初版の18件（58手順）を残していた。
# 0.1.56 でその文をシートの新しい列「手順下書き（アドオン版）」（クエスト一覧・ミッション一覧の N 列）に写し、
# 読み戻して一致を確かめてから、ここでも外した。もう残すものはない。
KEEP = set()

def main():
    man = json.loads((DATA / 'manifest.json').read_text(encoding='utf-8'))
    removed = kept = 0
    for rel in man['files']:
        if not rel.startswith(('quests/', 'missions/')):
            continue
        p = DATA / rel
        doc = json.loads(p.read_text(encoding='utf-8'))
        for q in doc.get('quests') or []:
            if q['id'] in KEEP:
                kept += len(q.get('steps') or [])
            elif q.get('steps'):
                removed += len(q['steps'])
                q['steps'] = []
        p.write_text(json.dumps(doc, ensure_ascii=False, indent=2, sort_keys=True) + '\n', encoding='utf-8')
    print('removed', removed, 'kept', kept)

if __name__ == '__main__':
    main()
