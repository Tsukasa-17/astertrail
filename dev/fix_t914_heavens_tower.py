#!/usr/bin/env python3
"""t914（0.1.324）：天の塔（zone 242）の NPC・オブジェクトに、地図の層（MAP 番号）とマス目と座標を入れる。推測はしない。

- 座標は LSB の data/zones/heavens_tower/npcs.yaml（コミット c359c2a…、資料の location_sources と同じもの）。
- 層は、その座標の真下（上下 3 yalm 以内でいちばん近い）の床の高さを、ゾーン DAT の当たり判定
  （dev/sources/heavens_tower_242_tris.json.gz）から取り、地図の層の高さの範囲（dev/sources/heavens_tower_242.json）で決める。
  扉などは床より少し上に置かれているので、その物の高さではなく床の高さで決める（Door:Vestal Chamber は床 -49.0 → MAP 4）。
  地図は 4 枚（地下・1階・侍女の間・羅星の間と神子の部屋。dev/sources/heavens_tower_242.json の pages）。
- マス目は、同梱の天の塔の地図（scale 20、offset -256/-320）の上のマス。
- 用語辞典のマス目（1 階の NPC の「MAP2」のマス）は、MAP の番号は同梱の 4 枚と同じだが、マスの大きさがちがうので、出典の文にだけ残す。
- 座標の無い手順（相手の無い「天の塔に入ってイベント」の 2 つ）は、そのまま（ピンは出ない）。
data/guides/steps_v2.json と、相手の表を持つ data/missions/*.json・data/quests/*.json を書きかえる。
build_guides.py などで作り直したあとは、もう一度これを走らせる。何度走らせても同じ。
"""
import gzip, json, pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
DATA = ROOT / 'data'
SRC = ROOT / 'dev' / 'sources'
ZONE = 242
ZNAME = '天の塔'
CHECKED = '2026-11-24'
LSB_URL = 'https://github.com/LandSandBoat/server/blob/c359c2a7df6e6add4867b5078cf78ee0050ae4bd/data/zones/heavens_tower/npcs.yaml'

# LSB の座標（npcs.yaml の at = [x, 高さ, y, 向き]）と id
LSB = {
    'Kupipi': ('npc', 17768466, 2.05, 32.4, 0.0),
    'Zubaba': ('npc', 17768486, 15.632, 18.244, -26.25),
    'Rhy_Epocan': ('npc', 17768483, 2.319, 14.0, -47.0),
    'Chumimi': ('npc', 17768531, 0.0, 20.0, 30.749),
    'Sheelala': ('npc', 17768500, 4.45, -8.666, 0.749),
    'Habida-Jubida': ('npc', 17768503, -16.299, -15.847, 0.5),
    'Sassa-Kotassa': ('npc', 17768509, 2.329, 19.017, 0.499),
    'Door_Starway_Stairway': ('obj', 17768475, -13.695, 28.938, -1.504),
    'Door_Vestal_Chamber': ('obj', 17768476, 0.0, 40.25, -51.471),
}
NAME_EN = {'Door_Starway_Stairway': 'Door:Starway Stairway', 'Door_Vestal_Chamber': 'Door:Vestal Chamber'}


def floor_under(P, up, x, y, z):
    """(x, y) の真下・真上の床で、高さ z にいちばん近いもの（3 yalm 以内）"""
    best = None
    for (a, b, c), u in zip(P, up):
        if u < 0.7:
            continue
        ax, ah, ay = a; bx, bh, by = b; cx, ch, cy = c
        d = (by - cy) * (ax - cx) + (cx - bx) * (ay - cy)
        if abs(d) < 1e-9:
            continue
        l1 = ((by - cy) * (x - cx) + (cx - bx) * (y - cy)) / d
        l2 = ((cy - ay) * (x - cx) + (ax - cx) * (y - cy)) / d
        l3 = 1 - l1 - l2
        if min(l1, l2, l3) < -1e-6:
            continue
        h = l1 * ah + l2 * bh + l3 * ch
        # 床は足もとより下（+）か同じ。少し上に置かれた扉なども拾えるよう、下へ 3 yalm まで
        if -0.5 <= h - z <= 3.0 and (best is None or abs(h - z) < abs(best - z)):
            best = h
    return best


def grid_of(x, y):
    bx, by = x * 4 + 256, -y * 4 + 320
    col = int((bx - 16) // 32)
    row = int((by - 16) // 32) + 1
    return chr(ord('A') + col) + '-' + str(row)


def places():
    doc = json.loads(gzip.open(SRC / 'heavens_tower_242_tris.json.gz').read())
    P = [[[v / 20.0 for v in t[i * 3:i * 3 + 3]] for i in range(3)] for t in doc['tris']]
    import numpy as np
    A = np.array(P)
    n = np.cross(A[:, 1] - A[:, 0], A[:, 2] - A[:, 0])
    up = np.abs(n[:, 1]) / np.maximum(np.linalg.norm(n, axis=1), 1e-9)
    src = json.loads((SRC / 'heavens_tower_242.json').read_text(encoding='utf-8'))
    # 地図のページ（0.1.324〜、4 枚）。高さの範囲は、そのページに入れた DAT の層の範囲
    bands = {l['map_n']: l for l in src['layers']}
    layers = [{'map_n': p['map_n'], 'h_min': min(bands[b]['h_min'] for b in p['bands']),
               'h_max': max(bands[b]['h_max'] for b in p['bands'])} for p in src['pages']]
    out = {}
    for key, (kind, sid, x, y, z) in LSB.items():
        h = floor_under(A, up, x, y, z)
        assert h is not None, key
        mn = [l['map_n'] for l in layers if l['h_min'] <= h < l['h_max']]
        assert len(mn) == 1, (key, h)
        out[key] = dict(kind=kind, sid=sid, x=x, y=y, z=z, floor=round(h, 3), n=mn[0], grid=grid_of(x, y))
    return out


def loc_of(p):
    return {'grid': p['grid'], 'map': {'kind': 'number', 'n': p['n']},
            'pos': {'x': p['x'], 'y': p['y'], 'z': p['z']}, 'zone_id': ZONE, 'zone_name': ZNAME}


def source_of(p, old_grid=None):
    f = ('座標 x=%.3f y=%.3f z=%.3f（id %d）。ゾーン DAT の床の高さ %.2f から同梱の天の塔の地図の MAP%d、マス目 %s'
         % (p['x'], p['y'], p['z'], p['sid'], p['floor'], p['n'], p['grid']))
    if old_grid:
        f += '（用語辞典の %s は用語辞典の地図のマスで、同梱の地図のマスとは大きさがちがう）' % old_grid
    return {'checked': CHECKED, 'fact_ja': f, 'name': 'LSB', 'urls': [LSB_URL]}


def key_of(tid):
    for pre in ('npc.%s.' % ZNAME, 'obj.%s.' % ZNAME, 'npc.%d.' % ZONE, 'obj.%d.' % ZONE):
        if tid.startswith(pre):
            k = tid[len(pre):]
            return k if k in LSB else None
    return None


def fix_target(t, pl):
    k = key_of(t.get('id', ''))
    if not k:
        return False
    p = pl[k]
    old = t.get('location') or {}
    og = None
    if old.get('grid') and (old.get('map') or {}).get('kind') == 'number' and not old.get('pos'):
        og = '%s（MAP%s）' % (old['grid'], old['map']['n'])
    prev = [s for s in (t.get('location_sources') or []) if s.get('name') == 'LSB' and 'ゾーン DAT' in s.get('fact_ja', '')]
    if prev:
        og = og or (prev[0]['fact_ja'].split('（用語辞典の ')[1].split(' は')[0] if '（用語辞典の ' in prev[0]['fact_ja'] else None)
    t['location'] = loc_of(p)
    t['location_sources'] = [s for s in (t.get('location_sources') or []) if s.get('name') != 'LSB'] + [source_of(p, og)]
    t['server_id'] = p['sid']
    t.setdefault('name_en', NAME_EN.get(k, k.replace('_', ' ')))
    return True


def main():
    pl = places()
    changed = {}
    # 相手の表
    files = [DATA / 'guides' / 'steps_v2.json'] + sorted((DATA / 'missions').glob('*.json')) + sorted((DATA / 'quests').glob('*.json'))
    for path in files:
        raw = path.read_text(encoding='utf-8')
        if ('npc.%s.' % ZNAME) not in raw and ('obj.%s.' % ZNAME) not in raw and ('.%d.' % ZONE) not in raw:
            continue
        doc = json.loads(raw)
        n = 0
        for t in doc.get('targets') or []:
            if fix_target(t, pl):
                n += 1
        # 手順の場所（steps v2）：相手の座標と層を入れる
        for g in doc.get('guides') or []:
            for s in g.get('steps') or []:
                k = key_of(s.get('target') or '')
                if not k:
                    continue
                p = pl[k]
                s['location'] = loc_of(p)
                ex = [e for e in (s.get('extra_sources') or []) if not (e.get('name') == 'LSB' and 'heavens_tower' in ' '.join(e.get('urls') or []))]
                s['extra_sources'] = ex + [source_of(p)]
                n += 1
        if n:
            nl = '\n' if raw.endswith('\n') else ''
            path.write_text(json.dumps(doc, ensure_ascii=False, indent=2) + nl, encoding='utf-8')
            changed[str(path.relative_to(ROOT))] = n
    for k, p in pl.items():
        print('%-22s floor %7.2f  MAP%d  %s' % (k, p['floor'], p['n'], p['grid']))
    for k, v in changed.items():
        print('wrote', k, v)
    # 相手の無い天の塔の手順（ピンは出せない）
    d = json.loads((DATA / 'guides' / 'steps_v2.json').read_text(encoding='utf-8'))
    for g in d['guides']:
        for s in g['steps']:
            L = s.get('location') or {}
            if L.get('zone_id') == ZONE and not (L.get('pos') or L.get('grid')):
                print('no pin:', s['id'], s.get('target'), s.get('next_line_ja'))


if __name__ == '__main__':
    main()
