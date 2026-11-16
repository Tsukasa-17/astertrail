#!/usr/bin/env python3
"""
Astertrail - となりのエリアへの出口（data/exits.json）を作る（0.1.171〜、t227-map）。

元：LandSandBoat/server の data/zones/<zone>/zone.yaml の zonelines（GPL-3.0。数と名前だけを使う）。
  0.1.181〜：町と中の建物の行き来（スクリプトで動かすもの）を SCRIPTED で足す。
  from  … この出口の位置（このエリアの中。LSB は [x, 高さ, y]）
  to    … 行き先のエリア（data/enums/zone.yaml の名前 → 番号）
  at    … 行き先で立つ位置（[x, 高さ, y(, 向き)]）
ゲームの座標（vana.game.entity）は x・y が水平面、z が高さなので、[x, 高さ, y] → x, y, z に入れ替える。
取ってきた yaml は LSB_ZONES_CACHE（初期 dev/.cache/lsb_zones）に置く（2回目からはそれを読む。--fetch で取り直す）。
"""
import json, os, re, sys, urllib.request

# zonelines に無い「スクリプトで動かす出入り口」（0.1.181〜、t292）。
# 町と中の建物の行き来は、LSB では zone.yaml の zonelines ではなく、Zone.lua・npc のスクリプト
# （registerCuboidTriggerArea の箱に入る → イベント → setPos(x, 高さ, y, 向き, ゾーン)）で動かしている。
# そのため zonelines だけを読んでいた 0.1.171〜0.1.180 では、北サンドリア↔ドラギーユ城などが出なかった。
# 数は LSB のスクリプトから（箱は真ん中、npc は !pos、行き先は setPos）。LSB に片方の向きの数が無いものは、
# 反対の向きで「来たときに立つ位置」を出口に使う（BG Wiki の Connected Zone のマスと同じマスなのを確かめた）。
# 形は zonelines と同じ [x, 高さ, y]。'approx' は画面には出さない（PROGRESS に書く）。
SCRIPTED = [
    # 北サンドリア → ドラギーユ城：scripts/zones/Northern_San_dOria/Zone.lua の箱 1 (-7,-3,110)-(7,-1,155)、csid 569 → setPos(0, 0, -13, 192, 233)
    {'key': 'script_231_233', 'from_zone': 231, 'to': 233, 'from': [0.0, -2.0, 132.5], 'at': [0.0, 0.0, -13.0]},
    # ドラギーユ城 → 北サンドリア：LSB に数が無い。出口は城で立つ位置 (0, -13)（BG Wiki 城側 H-9 と同じマス）、
    # 着く位置は北サンドリアの箱の真ん中（BG Wiki 北サンドリア側 I-6 と同じマス）
    {'key': 'script_233_231', 'from_zone': 233, 'to': 231, 'from': [0.0, 0.0, -13.0], 'at': [0.0, -2.0, 132.5], 'approx': True},
    # ウィンダス石の区 → 天の塔：scripts/zones/Windurst_Walls/Zone.lua の箱 1 (-2,-17,140)-(2,-16,142)、csid 86 → setPos(0, 0, -22.40, 192, 242)
    {'key': 'script_239_242', 'from_zone': 239, 'to': 242, 'from': [0.0, -16.5, 141.0], 'at': [0.0, 0.0, -22.4]},
    # 天の塔 → ウィンダス石の区：scripts/zones/Heavens_Tower/Zone.lua の箱 1 (-1,-1,-35)-(1,1,-33)、csid 41 → setPos(0, -17, 135, 60, 239)
    {'key': 'script_242_239', 'from_zone': 242, 'to': 239, 'from': [0.0, 0.0, -34.0], 'at': [0.0, -17.0, 135.0]},
    # セレニア図書館 → 東アドゥリン：scripts/zones/Celennia_Memorial_Library/npcs/Door_Back_to_Town.lua（!pos -92.357 -3.050 -82.322）
    #   → setPos(-86.2, -0.15, -76, 220, 257)
    {'key': 'script_284_257', 'from_zone': 284, 'to': 257, 'from': [-92.357, -3.05, -82.322], 'at': [-86.2, -0.15, -76.0]},
    # 東アドゥリン → セレニア図書館：LSB に数が無い。出口は東アドゥリンで立つ位置（BG Wiki 東アドゥリン側 F-10 と同じマス）。
    #   図書館の中で立つ位置は資料に無いので空
    {'key': 'script_257_284', 'from_zone': 257, 'to': 284, 'from': [-86.2, -0.15, -76.0], 'approx': True},
]

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
COMMIT = '889078200b13e0d72399a0e8ebb64076bacaec98'
RAW = 'https://raw.githubusercontent.com/LandSandBoat/server/%s/' % COMMIT
# 取ってきた yaml の置き場（配る zip には入れない。6MB ほど）
CACHE = os.environ.get('LSB_ZONES_CACHE', 'dev/.cache/lsb_zones')
OUT = os.path.join(ROOT, 'data', 'exits.json')


def fetch(rel, force):
    path = os.path.join(CACHE, rel.replace('/', '__'))
    if force or not os.path.exists(path):
        with urllib.request.urlopen(RAW + rel, timeout=30) as r:
            body = r.read().decode('utf-8')
        with open(path, 'w', encoding='utf-8') as f:
            f.write(body)
    with open(path, encoding='utf-8') as f:
        return f.read()


def zone_enum(text):
    ids = {}
    on = False
    for line in text.splitlines():
        if line.startswith('values:'):
            on = True
            continue
        if on:
            m = re.match(r'^\s+([a-z0-9_]+):\s+(\d+)', line)
            if m:
                ids[m.group(1)] = int(m.group(2))
    return ids


def nums(s):
    return [float(v) for v in re.findall(r'-?\d+(?:\.\d+)?', s)]


def zonelines(text):
    """zone.yaml の zonelines: だけを読む（ほかの欄は使わない）。"""
    out, cur, on = [], None, False
    for line in text.splitlines():
        if re.match(r'^zonelines:\s*$', line):
            on = True
            continue
        if not on:
            continue
        if re.match(r'^\S', line):   # 次の欄
            break
        m = re.match(r'^  (\S+):\s*$', line)
        if m:
            cur = {'key': m.group(1)}
            out.append(cur)
            continue
        m = re.match(r'^\s{4}(from|to|at|scale):\s*(.+?)\s*$', line)
        if m and cur is not None:
            k, v = m.group(1), m.group(2)
            cur[k] = v if k == 'to' else nums(v)
    return out


def main():
    force = '--fetch' in sys.argv
    os.makedirs(CACHE, exist_ok=True)
    tree_path = os.path.join(CACHE, '_tree.json')
    if force or not os.path.exists(tree_path):
        url = 'https://api.github.com/repos/LandSandBoat/server/git/trees/%s?recursive=1' % COMMIT
        with urllib.request.urlopen(url, timeout=60) as r:
            open(tree_path, 'wb').write(r.read())
    tree = json.load(open(tree_path))
    dirs = sorted(p['path'].split('/')[2] for p in tree['tree']
                  if re.match(r'^data/zones/[^/]+/zone\.yaml$', p['path']))
    ids = zone_enum(fetch('data/enums/zone.yaml', force))
    zones, skipped = {}, []
    for d in dirs:
        zid = ids.get(d)
        if zid is None:
            skipped.append(d)
            continue
        for zl in zonelines(fetch('data/zones/%s/zone.yaml' % d, force)):
            fr, to, at = zl.get('from'), zl.get('to'), zl.get('at')
            tid = ids.get(to) if to else None
            if not fr or len(fr) < 3 or tid is None or tid == zid:
                continue
            row = {'x': round(fr[0], 2), 'y': round(fr[2], 2), 'z': round(fr[1], 2), 'to': tid, 'line': zl['key']}
            if at and len(at) >= 3:
                row['at'] = {'x': round(at[0], 2), 'y': round(at[2], 2), 'z': round(at[1], 2)}
            zones.setdefault(str(zid), []).append(row)
    for sc in SCRIPTED:
        fr, at = sc['from'], sc.get('at')
        row = {'x': round(fr[0], 2), 'y': round(fr[2], 2), 'z': round(fr[1], 2), 'to': sc['to'], 'line': sc['key']}
        if at:
            row['at'] = {'x': round(at[0], 2), 'y': round(at[2], 2), 'z': round(at[1], 2)}
        lst = zones.setdefault(str(sc['from_zone']), [])
        if any(r['to'] == sc['to'] for r in lst):
            raise SystemExit('scripted exit already in zonelines: %s' % sc['key'])
        lst.append(row)
    for z in zones.values():
        z.sort(key=lambda r: (r['to'], r['x'], r['y']))
    doc = {
        'data_kind': 'exits', 'data_schema': 1,
        'source': 'LandSandBoat/server %s data/zones/*/zone.yaml zonelines, plus scripted entrances from scripts/zones/*/Zone.lua and npcs (GPL-3.0). Only the numbers are used.' % COMMIT,
        'rule_ja': 'x・y は水平面、z は高さ（vana.game.entity と同じ）。at は行き先で立つ位置。',
        'zones': zones,
    }
    with open(OUT, 'w', encoding='utf-8') as f:
        json.dump(doc, f, ensure_ascii=False, separators=(',', ':'), sort_keys=True)
        f.write('\n')
    n = sum(len(v) for v in zones.values())
    print('exits', n, 'zones', len(zones), 'skipped dirs', skipped[:8], len(skipped))


if __name__ == '__main__':
    main()
