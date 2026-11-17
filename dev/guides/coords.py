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
GAME = _DIR / 'game_confirmed.json'
MOVING = _DIR / 'moving_points.json'   # 場所が変わる ??? の候補とサーバーの番号（0.1.213〜）   # ゲームで確かめた座標（いちばん優先。古い値は残さない）
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


def apply_moving(targets):
    """場所が変わる ??? に、サーバーの番号（server_id）と出るかもしれない場所（candidates）を付ける（0.1.213〜）。
    アドオンは番号で本物を見分け、見えていないあいだは地図に候補を出す。出典は location_sources（画面には出さない）。"""
    n = 0
    if not MOVING.exists():
        return n
    d = json.loads(MOVING.read_text(encoding='utf-8'))
    for c in d.get('targets') or []:
        t = targets.get(c['target'])
        assert t is not None, 'moving target not found: ' + c['target']
        t['moves'] = True
        t['server_id'] = c['server_id']
        t['candidates'] = c['candidates']
        t['location_sources'] = (t.get('location_sources') or []) + (c.get('sources') or [])
        n += 1
    return n


LINKS = _DIR / 'step_links_214.json'   # 場所の無い手順に相手と場所をつなぐ（0.1.214〜。make_step_links_214.py）


def apply_links(guides, targets):
    """0.1.214〜：会話・調べる・トレードで場所の無かった手順に相手（target）と場所をつなぐ。BF の戦いの手順には入口（entrance）。
    - 新しい相手は targets に足す（今のデータにある相手はそのまま使い、場所は変えない）。
    - 手順の場所は、マス目が空のときだけ入れる。BF の入口は、入口の手順の場所をそのまま写す。
    - 相手が何人もいる手順は extra_targets（頭上の印だけ。地図は今までどおり）。
    - 出典は extra_sources / location_sources（画面には出さない）。"""
    n = {'steps': 0, 'targets': 0, 'entrance': 0, 'extra': 0}
    if not LINKS.exists():
        return n
    import common
    d = json.loads(LINKS.read_text(encoding='utf-8'))
    for t in d.get('targets') or []:
        if t['id'] in common.EXISTING_T or t['id'] in targets:
            continue
        loc = common.L(t['zone_name'], t.get('grid'), t.get('map_n'))
        if t.get('pos'):
            loc['pos'] = t['pos']
        targets[t['id']] = {'id': t['id'], 'kind': t['kind'], 'name_en': t['name_en'], 'location': loc,
                            'moves': False, 'same_name': False, 'location_sources': t.get('sources') or []}
        n['targets'] += 1
    by_id = {st['id']: st for g in guides for st in g['steps']}
    for e in d.get('steps') or []:
        st = by_id.get(e['step'])
        assert st is not None, 'link step not found: ' + e['step']
        assert st.get('target') in (None, e['target']), 'step already has a target: ' + e['step']
        tid = e['target']
        assert tid in common.EXISTING_T or tid in targets, 'link target not found: ' + tid
        st['target'] = tid
        for x in e.get('extra_targets') or []:
            assert x in common.EXISTING_T or x in targets, 'extra target not found: ' + x
        if e.get('extra_targets'):
            st['extra_targets'] = list(e['extra_targets'])
            n['extra'] += 1
        ent = e.get('entrance')
        if ent:
            st['entrance'] = True
            src = by_id.get(ent['from'])
            if src is not st and src.get('location'):
                st['location'] = json.loads(json.dumps(src['location']))
            n['entrance'] += 1
        else:
            nl = e.get('location')
            if nl:
                loc = st.get('location')
                if not loc:
                    tg = common.EXISTING_T.get(tid) or targets.get(tid)
                    zname = ((tg or {}).get('location') or {}).get('zone_name')
                    loc = common.L(zname, None, nl.get('map_n')) if zname else None
                    assert loc and loc['zone_id'] == nl.get('zone_id'), 'link zone: ' + e['step']
                assert loc['zone_id'] == nl.get('zone_id'), 'link zone differs: ' + e['step']
                if not loc.get('grid'):
                    loc = dict(loc, grid=nl.get('grid'))
                    if nl.get('map_n'):
                        loc['map'] = {'kind': 'number', 'n': nl['map_n']}
                    if nl.get('pos'):
                        loc['pos'] = nl['pos']
                st['location'] = loc
            if e.get('candidates'):
                st['location'] = dict(st.get('location') or {}, candidates=e['candidates'])
        st['extra_sources'] = (st.get('extra_sources') or []) + (e.get('sources') or [])
        n['steps'] += 1
    return n


EXACT = pathlib.Path(__file__).resolve().parents[1] / 'sources' / 'exact_pos_extra.json'   # 0.1.218〜（0.1.219 で map_n）
EXACT_MANUAL = pathlib.Path(__file__).resolve().parents[1] / 'sources' / 'exact_pos_manual.json'   # 0.1.220〜（手で確かめたもの）
EXACT_222 = EXACT.parent / 'exact_pos_222.json'   # 0.1.222〜：同名が2つ以上で真ん中に残っていたものを、文と LSB で1つに決めたもの


# ---- 0.1.220〜：場所の文字（マス目）を正確な座標のマスに合わせる
import math as _math
_FLOORS = None


def _floors():
    global _FLOORS
    if _FLOORS is None:
        _FLOORS = {}
        p = pathlib.Path(__file__).resolve().parents[2] / 'data' / 'maps.json'
        for f in json.loads(p.read_text(encoding='utf-8'))['floors']:
            if f.get('zone_id') is not None and f.get('map_n'):
                _FLOORS.setdefault(f['zone_id'], []).append(f)
        for z in _FLOORS:
            _FLOORS[z].sort(key=lambda f: f['map_n'])
    return _FLOORS


def exact_cell(loc):
    """pos のあるマス目（アドオンの maps.pick_floor → maps.world_px → grid_name と同じ換算）。分からなければ None"""
    pos = (loc or {}).get('pos')
    if not pos or pos.get('x') is None or pos.get('y') is None:
        return None
    lst = _floors().get(loc.get('zone_id')) or []
    m = loc.get('map') or {}
    f = None
    if m.get('kind') == 'number' and m.get('n'):
        f = next((x for x in lst if x['map_n'] == m['n']), None)
    elif lst and (m.get('kind') == 'single' or len(lst) == 1):
        f = lst[0]
    if not f:
        return None
    s = abs(f.get('scale') or 0)
    if not s:
        return None
    bx = float(pos['x']) * s * 0.2 - (f.get('offset_x') or 0)
    by = -float(pos['y']) * s * 0.2 - (f.get('offset_y') or 0)
    col = _math.floor((bx - 16) / 32)
    row = _math.floor((by - 16) / 32) + 1
    if 0 <= col <= 15 and 1 <= row <= 16:
        return '%s-%d' % (chr(65 + col), row)
    return None


def _one_cell(g):
    m = re.match(r'^\s*([A-Za-z])\s*[-－]?\s*(\d+)\s*$', g or '')
    return (m.group(1).upper() + '-' + str(int(m.group(2)))) if m else None


def relabel_grid(loc):
    """正確な座標のマスが書いてあるマス目と違えば、新しいマス目を返す（同じ・直さないときは None）。
    - 書いてあるマス目が1マス（または空）のとき。0.1.221〜：境目の「H-8/I-8」なども、座標のマスがその中にあればそのマスに。
    - となりのマス（3×3）より遠いときは直さない（作るときの決まりで起きないはず）。"""
    new = exact_cell(loc)
    old = (loc or {}).get('grid')
    if not new or new == old:
        return None
    if not old:
        return new
    if '/' in old:   # 0.1.221〜：境目の2マスも、座標のマスがその中にあれば そのマスだけに
        cs = [_one_cell(x) for x in old.split('/')]
        return new if all(cs) and new in cs else None
    o = _one_cell(old)
    if not o:
        return None
    if abs(ord(o[0]) - ord(new[0])) > 1 or abs(int(o[2:]) - int(new[2:])) > 1:
        return None
    return new


def retext_grid(st, old, new, name):
    """手順の文のマス目の字だけを書きかえる（用語辞典の文はそのまま）。直した欄の数を返す。
    - next_line_ja に「(旧)」がちょうど1つ → 「(新)」。
    - 「（石の区C-13）」のように括弧の終わりに旧マス目が1つだけあり、その前に相手の名前があるもの → 新マス目。
    - 2つ以上あるものは直さない。「(G-8 テンキー7)」のようなテンキーは strip_numpad（0.1.221〜）。"""
    n = 0
    s = st.get('next_line_ja')
    if s and old:
        tok = '(%s)' % old
        if s.count(tok) == 1:
            st['next_line_ja'] = s.replace(tok, '(%s)' % new)
            n += 1
        else:
            hits = list(re.finditer(r'(?<![A-Za-z])%s(?![0-9])' % re.escape(old), s))
            if len(hits) == 1 and s[hits[0].end():hits[0].end() + 1] in ('）', ')') and name and name in s[:hits[0].start()]:
                h = hits[0]
                st['next_line_ja'] = s[:h.start()] + new + s[h.end():]
                n += 1
    return n


def _exact_entries():
    out = {'targets': [], 'steps': []}
    for p in (EXACT, EXACT_MANUAL, EXACT_222):
        if p.exists():
            d = json.loads(p.read_text(encoding='utf-8'))
            for k in out:
                out[k] += d.get(k) or []
    return out


def _cells(grid):
    return [x.strip().upper() for x in (grid or '').split('/') if x.strip()]


def apply_exact(guides, targets):
    """0.1.218〜：マス目しか無かった場所に正確な座標（pos）を足す（dev/sources/exact_pos_extra.json。
    make_exact_pos_219.py が LSB から作る。地図の換算でマス目と同じ、またはとなりのマスで3×3に1つだけのもの）。
    - 手順の新しい相手（targets）と手順の場所に当てる。data/quests・missions の相手は dev/apply_exact_pos_220.py が当てる。
    - 0.1.220〜：場所の文字（マス目）も座標のマスに（relabel_grid）。手順の文はマス目の字だけ（retext_grid）。
      dev/sources/exact_pos_manual.json（手で確かめたもの。例：ダングルフの涸れ谷の Marin）も同じように当てる。
    - 0.1.219〜：map_n があれば（MAP が書いてなかった場所。ゾーンの当たり判定の階から）MAP 番号も入れる。
    - ゾーンとマス目が作ったときと同じときだけ当てる（違えば止める）。動く相手も、地図の代わりの位置として入れる。
    - 出典は location_sources / extra_sources（画面には出さない）。"""
    n = {'targets': 0, 'steps': 0, 'target_labels': 0, 'step_labels': 0, 'texts': 0, 'left': []}
    d = _exact_entries()
    if not d['targets'] and not d['steps']:
        return n
    for e in d.get('targets') or []:
        if e.get('file') != 'guides/steps_v2.json':
            continue
        t = targets.get(e['target'])
        assert t is not None, 'exact target not found: ' + e['target']
        loc = t.get('location') or {}
        assert loc.get('zone_id') == e['zone_id'] and loc.get('grid') == e['grid'], 'exact target moved: ' + e['target']
        t['location'] = dict(loc, pos=dict(e['pos']))   # 手順と同じ dict のことがあるので写してから
        if e.get('map_n'):
            assert (loc.get('map') or {}).get('kind') != 'number', 'exact map already known: ' + e['target']
            t['location']['map'] = {'kind': 'number', 'n': e['map_n']}
        srcs = [dict(x) for x in e['sources']]
        g = relabel_grid(t['location'])   # 0.1.220〜：場所の文字も座標のマスに
        if g:
            for x in srcs:
                x['grid_from'] = loc.get('grid')
            t['location']['grid'] = g
            n['target_labels'] += 1
        t['location_sources'] = (t.get('location_sources') or []) + srcs
        n['targets'] += 1
    by_id = {st['id']: st for g in guides for st in g['steps']}
    for e in d.get('steps') or []:
        st = by_id.get(e['step'])
        assert st is not None, 'exact step not found: ' + e['step']
        loc = st.get('location') or {}
        assert st.get('target') == e['target'], 'exact step target differs: ' + e['step']
        assert loc.get('zone_id') == e['zone_id'] and loc.get('grid') == e['grid'], 'exact step moved: ' + e['step']
        st['location'] = dict(loc, pos=dict(e['pos']))
        if e.get('map_n'):
            assert (loc.get('map') or {}).get('kind') != 'number', 'exact step map already known: ' + e['step']
            st['location']['map'] = {'kind': 'number', 'n': e['map_n']}
        srcs = [dict(x) for x in e['sources']]
        old = loc.get('grid')
        g = relabel_grid(st['location'])   # 0.1.220〜
        if g:
            for x in srcs:
                x['grid_from'] = old
            st['location']['grid'] = g
            n['step_labels'] += 1
            tg = targets.get(st.get('target')) or _EXISTING_T().get(st.get('target')) or {}
            k = retext_grid(st, old, g, tg.get('name_en'))
            n['texts'] += k
            if old and not k and old in (st.get('next_line_ja') or ''):
                n['left'].append((st['id'], old, g, st.get('next_line_ja')))
        st['extra_sources'] = (st.get('extra_sources') or []) + srcs
        n['steps'] += 1
    return n


def _EXISTING_T():
    import common
    return common.EXISTING_T


def label_changes(target_lists):
    """0.1.220〜：マス目を直した相手の一覧 [(ゾーン名, 旧, 新, 英語名)]（出典の grid_from から）"""
    out = []
    for ts in target_lists:
        for t in ts:
            loc = t.get('location') or {}
            for x in t.get('location_sources') or []:
                if x.get('grid_from') and x['grid_from'] != loc.get('grid') and loc.get('grid'):
                    out.append((loc.get('zone_name'), x['grid_from'], loc['grid'], t.get('name_en'), loc.get('zone_id')))
                    break
    return out


def retext_named(s, changes, own=None):
    """ほかの文の「ゾーン(旧)…名前」（24字以内）・同じゾーンの「名前(旧)」を新しいマス目に。own=(ゾーンid, マス目) と同じ旧マス目は直さない
    （その文の (旧) が手順の場所のことのとき）。直した数と新しい文を返す。"""
    n = 0
    if not s:
        return s, 0
    for zn, old, new, name, zid in changes:
        if not zn or not name or name == '???':
            continue
        if own and own == (zid, old):
            continue
        pat = re.compile(r'%s\(%s\)([^()\n]{0,24}?%s)' % (re.escape(zn), re.escape(old), re.escape(name)))
        t = pat.sub(lambda m: '%s(%s)%s' % (zn, new, m.group(1)), s)
        # 「Rosel(K-8)」のように名前のすぐ後ろ：同じゾーンの文（own のゾーン、または文にゾーン名）のときだけ
        if (own and own[0] == zid) or zn in t:
            pat2 = re.compile(r'(?<![A-Za-z])%s\(%s\)' % (re.escape(name), re.escape(old)))
            t = pat2.sub('%s(%s)' % (name, new), t)
        if t != s:
            s = t
            n += 1
    return s, n


def apply_named_texts(guides, targets):
    """0.1.220〜：手順の文に出てくる、マス目を直した相手の「ゾーン(旧)…名前」を直す。"""
    ch = label_changes([targets.values(), _EXISTING_T().values()])
    n = 0
    for g in guides:
        for st in g['steps']:
            loc = st.get('location') or {}
            own = (loc.get('zone_id'), loc.get('grid'))
            for k in ('next_line_ja', 'text_ja', 'route_ja'):
                v, k2 = retext_named(st.get(k), ch, own)
                if k2:
                    st[k] = v
                    n += k2
    return n


def strip_numpad(st):
    """0.1.221〜：正確な座標のある手順の1行で、その場所のマス目に付いたテンキーの説明を外し、ただのマス目（座標のマス）にする。
    その手順の場所のマス目（今のマス目・元のマス目 grid_from・境目の各マス、1行にマス目が1つならとなりのマス）に付いたものだけ。
    メモ（text_ja）は「テンキー5。」のような、テンキーだけの文を外す（ほかの場所のマス目があるメモはそのまま）。"""
    loc = st.get('location') or {}
    new = loc.get('grid')
    s = st.get('next_line_ja')
    if not loc.get('pos') or not new or '/' in new or exact_cell(loc) != new:
        return 0
    s = s or ''
    toks = {new}
    for x in st.get('extra_sources') or []:
        if x.get('grid_from'):
            toks.add(x['grid_from'])
    for t in list(toks):
        toks |= {c for c in (_one_cell(y) for y in t.split('/')) if c}
    # 1行にマス目が1つだけなら、となりのマス（3×3）に付いたテンキーも同じ場所（例：「大工房(J-9 テンキー4)」の Lucius は I-9）
    grids = re.findall(r'(?<![A-Za-z])[A-P]-\d{1,2}(?![0-9])', s)
    if len(grids) == 1 and grids[0] not in toks:
        c0 = _one_cell(grids[0])
        if c0 and abs(ord(c0[0]) - ord(new[0])) <= 1 and abs(int(c0[2:]) - int(new[2:])) <= 1:
            toks.add(c0)
    alt = '|'.join(re.escape(t) for t in sorted(toks, key=len, reverse=True))
    k = r'テンキー\d(?:[・と]\d)*'
    t = s
    # (G-8 テンキー7) / (I-8テンキー7) / （H-6のテンキー4と7の境目）
    t = re.sub(r'([\(（])(?:%s)\s*の?%s(?:の境目)?([\)）])' % (alt, k), lambda m: m.group(1) + new + m.group(2), t)
    # (K-9)テンキー4の / (E-8)テンキー2付近の
    t = re.sub(r'\((?:%s)\)\s*%s' % (alt, k), '(%s)' % new, t)
    # (J-8)の北西（テンキー7）の
    t = re.sub(r'\((?:%s)\)(の[東西南北]+)（%s）' % (alt, k), lambda m: '(%s)%s' % (new, m.group(1)), t)
    # (H-7)上段、テンキー4と5の境目あたりの
    t = re.sub(r'\((?:%s)\)([^、()（）]{0,4})、%s(?:の境目)?(?:あたり|付近)?の' % (alt, k), lambda m: '(%s)%sの' % (new, m.group(1)), t)
    n = 0
    if t != s:
        st['next_line_ja'] = t
        n += 1
    # メモ（text_ja）の「テンキー5。」「テンキー7のあたり。」だけの文（ほかのマス目の無いもの）：ピンが正確な位置なので外す
    m = st.get('text_ja')
    if m and 'テンキー' in m and not re.search(r'[A-P]-\d', m):
        m2 = re.sub(r'(?:^|(?<=。))\s*%s(?:のあたり|付近)?。' % k, '', m).strip()
        if m2 != m and 'テンキー' not in m2:
            st['text_ja'] = m2 or None
            n += 1
    return n


def apply_numpad(guides):
    n = 0
    for g in guides:
        for st in g['steps']:
            n += strip_numpad(st)
    return n
