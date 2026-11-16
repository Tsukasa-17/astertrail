"""書き直し手順の短い書式（*.gd）を読み、common.build に渡す。

書式（1行1件、# はコメント）:
  @ <quest id> <用語辞典URL>              … クエストの始まり
  <key> <type> <from> | 1行目 | 小さい字 | 追加...
    key: g01 など。type: talk/trade/examine/defeat/fight/gather/go
    from: 元の下書きの手順（s01,s02 の形。「=」なら1つ前と同じ）
    小さい字: 無ければ -
  追加（| で区切る）:
    @ゾーン グリッド #MAP   … 場所（グリッドは - で省略可、#n は MAP番号）
    T 既存の対象id          … 対象
    T 新id = kind:英語名@ゾーン グリッド #n   … 新しい対象（moves/same は ! / ~ を英語名の後ろに）
    N 品名*数 / K だいじなもの名
    R ルート名（a/b と書くと複数ルートに共通）
    > key,key               … 次の手順（分岐・合流）。> だけなら最後
    W 時間・天候
    E 資料名;URL[,URL];分かったこと   … 用語辞典以外の出典（画面には出さない）

新しく足すクエスト（0.1.70〜、build_new_quests.py が読み、data/quests/<区分>.json を作る）:
  Q 英語名 | 用語辞典の日本語名 | くり返し(yes/no/-) | 発生の相手（T と同じ書き方）
  RW 種類:名前      … 報酬（item/gil/title/key_item/other）。1行に1つ
  LK 種類:文        … 受ける条件（fame/quest/condition）。1行に1つ
  XS 資料名;URL;分かったこと … クエストの用語辞典以外の出典（画面には出さない）
"""
import re
from common import S, L, T, N, KI, build


def _loc(spec):
    parts = spec.split()
    zone = parts[0]
    grid = None
    mp = None
    for p in parts[1:]:
        if p.startswith('#'):
            mp = int(p[1:])
        elif p != '-':
            grid = p if grid is None else grid + ' ' + p
    return L(zone, grid, mp)


def _target(spec):
    if '=' not in spec:
        return T(spec.strip())
    tid, rest = [x.strip() for x in spec.split('=', 1)]
    kind, rest = rest.split(':', 1)
    if '@' in rest:
        name, locs = rest.split('@', 1)
        loc = _loc(locs.strip())
    else:
        name, loc = rest, None
    name = name.strip()
    moves = same = False
    while name and name[-1] in '!~':
        if name[-1] == '!':
            moves = True
        else:
            same = True
        name = name[:-1].strip()
    return T(tid, kind.strip(), name, loc, moves=moves, same_name=same)


def parse(path, checked):
    out = []
    cur = None
    def flush():
        if cur:
            out.append(build(cur['qid'], cur['steps'], cur['url'], checked))
    prev_from = []
    for raw in open(path, encoding='utf-8'):
        line = raw.rstrip('\n')
        if not line.strip() or line.lstrip().startswith('#'):
            continue
        if line.startswith('@ '):
            flush()
            _, qid, url = line.split()
            cur = {'qid': qid, 'url': url, 'steps': []}
            prev_from = []
            continue
        if line.startswith(('Q ', 'MN ', 'RK ', 'RW ', 'LK ', 'XS ')):
            continue   # クエストそのものの行（build_new_quests.py が読む）
        fields = [f.strip() for f in line.split('|')]
        head = fields[0].split()
        key, typ = head[0], head[1]
        frm = head[2] if len(head) > 2 else '='
        if frm == '=':
            frm_list = prev_from
        elif frm == '-':
            frm_list = []
        else:
            frm_list = [x for x in frm.split(',') if x]
        prev_from = frm_list
        text1 = fields[1]
        text2 = fields[2] if len(fields) > 2 and fields[2] not in ('', '-') else None
        kw = {'loc': None, 'tgt': None, 'needs': [], 'tw': None, 'route': None, 'nxt': 'auto', 'extra': None}
        for f in fields[3:]:
            if not f:
                continue
            if f.startswith('@'):
                kw['loc'] = _loc(f[1:].strip())
            elif f.startswith('T '):
                kw['tgt'] = _target(f[2:])
            elif f.startswith('N '):
                for it in f[2:].split(','):
                    it = it.strip()
                    m = re.match(r'(.+?)\*(\d+)$', it)
                    kw['needs'].append(N(m.group(1), int(m.group(2))) if m else N(it))
            elif f.startswith('K '):
                for it in f[2:].split(','):
                    kw['needs'].append(KI(it.strip()))
            elif f.startswith('R '):
                r = f[2:].strip()
                kw['route'] = r.split('/') if '/' in r else r
            elif f.startswith('>'):
                ks = f[1:].strip()
                kw['nxt'] = [k.strip() for k in ks.split(',') if k.strip()] if ks else []
            elif f.startswith('W '):
                kw['tw'] = f[2:].strip()
            elif f.startswith('E '):
                name, urls, fact = f[2:].split(';', 2)
                kw['extra'] = [{'name': name.strip(), 'urls': [u.strip() for u in urls.split(',')],
                                'checked': checked, 'fact_ja': fact.strip()}]
            else:
                raise ValueError('%s: unknown field %r' % (path, f))
        cur['steps'].append(S(key, typ, text1, text2, kw['loc'], kw['tgt'], kw['needs'], kw['tw'],
                              frm_list, kw['nxt'], kw['route'], None, kw['extra']))
    flush()
    return out
