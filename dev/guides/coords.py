"""座標の直しを、書き直した手順に当てる。

元: dev/compare/coords/coord_fixes.json（make_fixes.py。BG Wiki と FFXIclopedia が一致したもの、0.1.53）
    dev/compare/coords/coord_fixes_unconfirmed.json（make_fixes_u.py。FFXIclopedia に座標が無く BG Wiki に合わせたもの、0.1.55）
- 対象そのものの直し（target_fix）は、その対象を使う全部の手順に当てる。
- クエストだけの直し（step_fix）は、そのクエストの手順に当てる。
- 手順の文の「(旧)」も新しい座標に書きかえる。出典は extra_sources / location_sources に書く（画面には出さない）。
"""
import json, re, pathlib
_DIR = pathlib.Path(__file__).resolve().parents[1] / 'compare' / 'coords'
FIXES = [_DIR / 'coord_fixes.json', _DIR / 'coord_fixes_unconfirmed.json']
GAME = _DIR / 'game_confirmed.json'   # ゲームで確かめた座標（いちばん優先。古い値は残さない）
CHECKED = '2026-11-14'

def _fxc_url(t):
    return 'https://ffxiclopedia.fandom.com/wiki/' + t.replace(' ', '_') if t else None

def _src(f):
    urls = [u for u in (f.get('bg_url'), _fxc_url(f.get('fxc_page'))) if u]
    if f.get('basis') == 'bg_only':
        fact = '座標 %s（BG Wiki。FFXIclopedia には座標の記載なし%s）' % (f['new'], '、用語辞典は %s' % f['old'] if f.get('old') else '')
        return {'name': 'BG Wiki', 'urls': urls, 'checked': CHECKED, 'fact_ja': fact}
    fact = '座標 %s（BG Wiki と FFXIclopedia が一致%s）' % (f['new'], '、用語辞典は %s' % f['old'] if f.get('old') else '')
    return {'name': 'BG Wiki, FFXIclopedia', 'urls': urls, 'checked': CHECKED, 'fact_ja': fact}

def load():
    out = {'step_fix': [], 'target_fix': []}
    for p in FIXES:
        if p.exists():
            d = json.loads(p.read_text(encoding='utf-8'))
            for k in out:
                out[k] += d.get(k) or []
    return out

def _retext(s, old, new, zone, name, add_if_missing):
    if not s:
        return s, False
    if old and ('(%s)' % old) in s:
        return s.replace('(%s)' % old, '(%s)' % new), True
    if add_if_missing and zone and zone in s:
        m = re.search(re.escape(zone) + r'(?:[北南])?(?:MAP\[\d\])?(?:（[^）]*階）)?', s)
        if m and not s[m.end():m.end() + 1] == '(':
            return s[:m.end()] + '(%s)' % new + s[m.end():], True
    return s, False

def _name_retext(s, old, new, name):
    """対象でない手順の文にも「(旧)…名前」があれば直す。"""
    if not s or not old or not name:
        return s, False
    pat = re.compile(r'\(%s\)([^()\n]{0,24}?%s)' % (re.escape(old), re.escape(name)))
    t = pat.sub(lambda m: '(%s)%s' % (new, m.group(1)), s)
    return t, t != s

def game_sources(c):
    pos = c.get('pos') or {}
    return [{'name': 'ゲームで確認', 'urls': [], 'checked': c['checked'],
             'fact_ja': '座標 %s（ゲームで確認 x=%.2f y=%.2f z=%.2f）' % (c['grid'], pos['x'], pos['y'], pos['z'])},
            {'name': 'BG Wiki, FFXIclopedia', 'urls': c.get('urls') or [], 'checked': c['checked'],
             'fact_ja': '座標 %s（BG Wiki と FFXIclopedia も同じ）' % c['grid']}]

def load_game():
    if not GAME.exists():
        return []
    return json.loads(GAME.read_text(encoding='utf-8')).get('targets') or []

def apply_game(guides, targets):
    """ゲームで確かめた座標を、対象・手順の座標・手順の文・出典に当てる。前の出典（用語辞典の古い値を含む）は置きかえる。"""
    n = {'steps': 0, 'targets': 0}
    for c in load_game():
        tid, new = c['target'], c['grid']
        t = targets.get(tid)
        if t is not None:
            old = (t.get('location') or {}).get('grid')
            t['location'] = dict(t.get('location') or {}, grid=new)
            t['location_sources'] = game_sources(c)
            n['targets'] += 1
        for g in guides:
            for st in g['steps']:
                if st.get('target') != tid:
                    continue
                loc = st.get('location') or {}
                old = loc.get('grid')
                if loc:
                    st['location'] = dict(loc, grid=new)
                for k in ('next_line_ja', 'text_ja'):
                    if old and old != new and st.get(k) and ('(%s)' % old) in st[k]:
                        st[k] = st[k].replace('(%s)' % old, '(%s)' % new)
                st['extra_sources'] = [x for x in st.get('extra_sources') or [] if not (x.get('fact_ja') or '').startswith('座標 ')] + game_sources(c)
                n['steps'] += 1
    return n

def apply(guides, new_targets, target_names):
    fx = load()
    changed = {'steps': 0, 'texts': 0, 'targets': 0}
    tfix = {f['target']: f for f in fx['target_fix']}
    sfix = {(f['qid'], f['target']): f for f in fx['step_fix']}
    for tid, f in tfix.items():
        t = new_targets.get(tid)
        if t is not None and (t.get('location') or {}).get('grid') != f['new']:
            t['location'] = dict(t.get('location') or {}, grid=f['new'])   # 手順と同じ dict のことがあるので写してから
            t['location_sources'] = [_src(f)]
            changed['targets'] += 1
    for g in guides:
        qid = g['quest']
        for st in g['steps']:
            tid = st.get('target')
            f = sfix.get((qid, tid)) or tfix.get(tid)
            if f:
                loc = st.get('location') or {}
                old = loc.get('grid') or f.get('old')
                zone = loc.get('zone_name')
                # 境目の2マス（"E-8/F-8"）で、片方が直しの値なら残す（0.1.70）
                both = f['new'] in (loc.get('grid') or '').split('/') and '/' in (loc.get('grid') or '')
                if loc and loc.get('grid') != f['new'] and not both:
                    st['location'] = dict(loc, grid=f['new'])   # ほかの手順と同じ dict のことがあるので写してから
                    changed['steps'] += 1
                    st.setdefault('extra_sources', []).append(_src(f))
                for k in (() if both else ('next_line_ja', 'text_ja')):
                    v, ok = _retext(st.get(k), old, f['new'], zone, target_names.get(tid), k == 'next_line_ja')
                    if ok:
                        st[k] = v; changed['texts'] += 1
            # ほかの対象の手順の文に出てくる名前
            for f2 in list(tfix.values()) + [x for (q, _), x in sfix.items() if q == qid]:
                nm = target_names.get(f2['target'])
                for k in ('next_line_ja', 'text_ja'):
                    v, ok = _name_retext(st.get(k), f2.get('old'), f2['new'], nm)
                    if ok:
                        st[k] = v; changed['texts'] += 1
    return changed
