#!/usr/bin/env python3
"""t261（0.1.174）：受けられない理由から「ガードにクリスタルをトレード」（ランクポイント）を外す。

ユーザーの判断（2026-11-16）：その条件はランクポイントのことでトレードではないので要らない。
- 「〜をトレード等」「クリスタルトレード等」「規定ランクポイントに達すると」など、ランクポイントを上げる条件の文が対象。
- 文の頭の「「前のミッション」終了後／クリア後」は前提として残す（その部分だけの文にする）。
- 前提が無い文は理由ごと外す。GPS クリスタルなどランクポイントでないものはさわらない。
何度走らせても同じ（もう外れていれば変えない）。変えた件を出す。
"""
import glob, json, re, os

ROOT = os.path.join(os.path.dirname(__file__), '..')
PAT = re.compile(r'クリスタル.{0,6}トレード|トレード.{0,4}クリスタル|ランクポイント')
PRE = re.compile(r'^(「[^」]+」(?:終了後|クリア後))')

def main():
    out = []
    for f in sorted(glob.glob(os.path.join(ROOT, 'data', 'missions', '*.json')) + glob.glob(os.path.join(ROOT, 'data', 'quests', '*.json'))):
        s = open(f, encoding='utf-8').read()
        d = json.loads(s)
        changed = False
        for q in d['quests']:
            new = []
            for r in q.get('lock_reasons', []):
                t = r.get('text_ja', '')
                if PAT.search(t) and 'GPS' not in t:
                    m = PRE.match(t)
                    changed = True
                    if m:
                        nr = dict(r); nr['text_ja'] = m.group(1); new.append(nr)
                    out.append((q['id'], q.get('mission_no') or '', t, m.group(1) if m else None))
                else:
                    new.append(r)
            q['lock_reasons'] = new
        if changed:
            open(f, 'w', encoding='utf-8').write(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    for o in out:
        print('\t'.join([o[0], o[1], o[2], o[3] or '（外した）']))
    print('changed', len(out))

if __name__ == '__main__':
    main()
