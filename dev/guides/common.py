"""手順の書き直し（steps v2）を組み立てる共通部品。

- 元の下書き（data/quests, data/missions の steps）は 0.1.54 でゲーム用データから外した（文はシートに残る）。
  古い手順 id の一覧は data/guides/step_map.json（古い id → 新しい id）から読む。
- 新しい手順の id は「<quest id>#gNN」。下書きの「#sNN」とぶつからない。
- 各手順の migrated_from に、元になった下書きの手順 id を書く（保存済みの進み具合を引き継ぐため）。
"""
import json, pathlib

ROOT = pathlib.Path(__file__).resolve().parents[2]
DATA = ROOT / 'data'

def load(p):
    return json.loads((DATA / p).read_text(encoding='utf-8'))

ZONES = {z['zone_name']: z for z in load('zones.json')['zones'] if z.get('zone_name')}

EXISTING_Q, EXISTING_T = {}, {}
for rel in load('manifest.json')['files']:
    if rel.startswith(('quests/', 'missions/')):
        doc = load(rel)
        for q in doc.get('quests') or []:
            EXISTING_Q[q['id']] = q
        for t in doc.get('targets') or []:
            EXISTING_T[t['id']] = t

# 古い手順 id（下書きを外したクエストは step_map.json から）
STEP_MAP = {}
_sm = DATA / 'guides' / 'step_map.json'
if _sm.exists():
    STEP_MAP = json.loads(_sm.read_text(encoding='utf-8')).get('map') or {}

def old_step_ids(qid):
    ids = {s['id'] for s in EXISTING_Q[qid].get('steps') or []}
    pre = qid + '#'
    ids |= {k for k in STEP_MAP if k.startswith(pre)}
    return ids

# 今のデータで「1枚の地図」と分かっているゾーン（MAP番号を付けない）
SINGLE = set()
for t in EXISTING_T.values():
    loc = t.get('location') or {}
    if loc.get('zone_id') and (loc.get('map') or {}).get('kind') == 'single':
        SINGLE.add(loc['zone_id'])
for q in EXISTING_Q.values():
    for s in q.get('steps') or []:
        loc = s.get('location') or {}
        if loc.get('zone_id') and (loc.get('map') or {}).get('kind') == 'single':
            SINGLE.add(loc['zone_id'])
# 下書きの手順の場所だけから分かっていた分（0.1.54 で下書きを外したので固定で持つ）
SINGLE |= {109, 126, 128, 252}


# 0.1.70〜：前からのゾーン（81）以外は、地図の枚数（maps.json）が1枚なら 1枚の地図。前からのゾーンの扱いは変えない
_OLD_Z = set(json.loads((pathlib.Path(__file__).resolve().parent / 'old_zone_ids.json').read_text()))
_FLOORS = {}
for _f in load('maps.json')['floors']:
    if _f.get('zone_id') is not None:
        _FLOORS[_f['zone_id']] = _FLOORS.get(_f['zone_id'], 0) + 1
for _zid, _n in _FLOORS.items():
    if _zid not in _OLD_Z and _n == 1:
        SINGLE.add(_zid)

def L(zone, grid=None, map_n=None):
    """場所。ゾーン名は用語辞典の表記。zones.json に無いゾーンは zone_id を入れない（推測しない）。"""
    z = ZONES.get(zone)
    zid = z['zone_id'] if z else None
    if map_n is not None:
        m = {'kind': 'number', 'n': map_n}
    elif zid in SINGLE:
        m = {'kind': 'single'}
    else:
        m = {'kind': 'unknown'}
    return {'zone_id': zid, 'zone_name': zone, 'grid': grid, 'map': m}


NEW_TARGETS = {}
# 定義（kind と名前）より前のファイルで使われた相手（0.1.118〜、m_zilart など）。全部読んだあとで確かめる
PENDING = set()

def T(tid, kind=None, name_en=None, loc=None, moves=False, same_name=False):
    """対象。今のデータにある id はそのまま使う。無いものだけ用語辞典の位置で足す。"""
    if tid in EXISTING_T:
        return tid
    if tid not in NEW_TARGETS:
        if not (kind and name_en):
            PENDING.add(tid)
            return tid
        NEW_TARGETS[tid] = {
            'id': tid, 'kind': kind, 'name_en': name_en, 'location': loc,
            'moves': moves, 'same_name': same_name,
        }
    return tid


def check_pending():
    for tid in sorted(PENDING):
        assert tid in EXISTING_T or tid in NEW_TARGETS, 'new target needs kind and name: ' + tid


def N(name_ja, count=1, kind='item'):
    return {'kind': kind, 'item_id': None, 'count': count, 'name_ja': name_ja, 'name_en': None}

def KI(name_ja):
    return N(name_ja, 1, 'key_item')


def S(key, typ, line, text=None, loc=None, tgt=None, needs=None, tw=None, frm=(), nxt='auto',
      route=None, note=None, extra=None):
    return {'extra_sources': extra or [],'key': key, 'type': typ, 'next_line_ja': line, 'text_ja': text, 'location': loc,
            'target': tgt, 'needs': needs or [], 'time_weather_ja': tw, 'from': list(frm),
            'next': nxt, 'route_ja': route, 'location_note_ja': note}


def build(qid, steps, url, checked):
    """steps: S(...) の並び。key は 'g01' など。next は 'auto'（次の行）か key の並び。"""
    old_ids = old_step_ids(qid)
    keys = [s['key'] for s in steps]
    assert len(set(keys)) == len(keys), qid + ' duplicate keys'
    def sid_of(k):
        return '%s#%s' % (qid, k if k.startswith('g') else 'g' + k)
    out = []
    covered = set()
    for i, s in enumerate(steps):
        sid = sid_of(s['key'])
        if s['next'] == 'auto':
            nxt = [sid_of(steps[i + 1]['key'])] if i + 1 < len(steps) else []
        else:
            nxt = [sid_of(k) for k in s['next']]
            for n in s['next']:
                assert n in keys, qid + ' next missing ' + n
        frm = ['%s#%s' % (qid, k) for k in s['from']]
        for f in frm:
            assert f in old_ids, qid + ' migrated_from unknown ' + f
            covered.add(f)
        if s['target']:
            assert s['target'] in EXISTING_T or s['target'] in NEW_TARGETS or s['target'] in PENDING, 'target ' + s['target']
        st = {
            'id': sid, 'order': i + 1, 'type': s['type'],
            'next_line_ja': s['next_line_ja'], 'text_ja': s['text_ja'],
            'text_status': 'guide_v1',
            'location': s['location'], 'target': s['target'], 'needs': s['needs'],
            'time_weather_ja': s['time_weather_ja'], 'next': nxt, 'migrated_from': frm,
        }
        if isinstance(s['route_ja'], (list, tuple)):
            st['routes_ja'] = list(s['route_ja'])   # 複数のルートに共通の手順
        elif s['route_ja']:
            st['route_ja'] = s['route_ja']
        if s['location_note_ja']:
            st['location_note_ja'] = s['location_note_ja']
        if s['extra_sources']:
            # 用語辞典に書いていないことを、ほかの資料で確かめて足したもの（手順の文にも「用語辞典以外」と書く）
            st['extra_sources'] = s['extra_sources']
        out.append(st)
    missing = old_ids - covered
    assert not missing, qid + ' draft steps not mapped: ' + ', '.join(sorted(missing))
    return {
        'quest': qid,
        'source': {'url': url, 'checked': checked, 'via': 'wiki.ffo.jp'},
        'steps': out,
    }
