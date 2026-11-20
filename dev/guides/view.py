"""作業用：書き直し前のクエストの下書きと用語辞典の要約を並べて出す。 python3 view.py <id接頭辞> [件数]"""
import sys, re, json, os
from common import EXISTING_Q, EXISTING_T, DATA
SKIP = re.compile(r'歴史|名称|元ネタ|変遷|回想|バグ|人気|戦利品|関連|出典|ネタバレ|余談|小ネタ|台詞|設定|セリフ|イベント|称号|英語名')
done = set()
p = DATA / 'guides' / 'steps_v2.json'
if p.exists():
    done = {g['quest'] for g in json.loads(p.read_text())['guides']}
pref = sys.argv[1]; lim = int(sys.argv[2]) if len(sys.argv) > 2 else 99
skip_n = int(sys.argv[3]) if len(sys.argv) > 3 else 0
ids = [q for q in EXISTING_Q if q.startswith(pref) and q not in done][skip_n:skip_n + lim]
def tg(t):
    x = EXISTING_T.get(t)
    if not x: return str(t)
    l = x.get('location') or {}
    return '%s(%s %s %s)' % (t, l.get('zone_name'), l.get('grid'), (l.get('map') or {}).get('n', ''))
for qid in ids:
    q = EXISTING_Q[qid]
    url = q['sources'][0]['url']
    aid = re.search(r'/(\d+)\.html', url).group(1)
    print('=' * 8, qid, q.get('mission_no') or '', q['name_en'], q['name_ja_ref'], url)
    print('start:', tg(q['start']['target']), '| rep:', q['repeatable'], '| lock:', '; '.join(r['text_ja'] for r in q['lock_reasons']))
    for s in q['steps']:
        loc = s['location'] or {}
        print(' %s[%s] %s | %s | @%s %s #%s | T %s | N %s | W %s' % (s['id'][-3:], s['type'], s['next_line_ja'], s['text_ja'] or '-',
              loc.get('zone_name'), loc.get('grid'), (loc.get('map') or {}).get('n', ''), tg(s['target']) if s['target'] else '-',
              ','.join('%s*%s' % (n['name_ja'], n['count']) for n in s['needs']) or '-', s['time_weather_ja'] or '-'))
    txt = open('/workspace/newaddon-data/digest/%s.txt' % aid, encoding='utf-8').read()
    secs = re.split(r'\n(?=## )', txt)
    out = []
    for sec in secs:
        title = sec.split('\n', 1)[0]
        if title.startswith('## ') and SKIP.search(title):
            continue
        out.append(sec)
    body = '\n'.join(out)
    body = re.sub(r'\n{2,}', '\n', body)
    print(body[:2600])
