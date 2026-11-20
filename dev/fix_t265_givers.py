#!/usr/bin/env python3
"""t265（0.1.174）：依頼者（開始の相手）の場所の抜けを埋める。推測はしない。

1. zones.json に無いゾーン名に、ゾーン番号を入れる。番号と日本語名は Windower Resources の zones.lua
   （dev/sources/windower/zones.lua、ゲームのクライアントから作られた表）の ja と完全に同じ名前のときだけ。
   いまの zones.json の 192 件とこの表の番号はすべて一致している（食い違いは 0 件、作るときに確かめる）。
2. 相手の場所に zone_name だけあって zone_id が無いものに、1 の表で番号を入れる（名前が完全に同じときだけ）。
3. 3国の資料（.gd に Q 行が無い、元の表からのもの）で場所が無い・ゾーンが無い相手に、用語辞典の依頼者の行
   （とその手順の行）の場所を入れる。出典は location_sources に書く（画面には出さない）。
何度走らせても同じ。このあと build_new_quests.py と build_guides.py を走らせる（ゾーン名から番号を引き直す）。
"""
import glob, json, os, re, pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
DATA = ROOT / 'data'
CHECKED = '2026-11-16'

def windower():
    out = {}
    s = (ROOT / 'dev' / 'sources' / 'windower' / 'zones.lua').read_text(encoding='utf-8')
    for m in re.finditer(r'\[(\d+)\] = \{id=\d+,en="([^"]*)",ja="([^"]*)"', s):
        out[m.group(3)] = int(m.group(1))
    return out

# 3：用語辞典の依頼者の行（シートの「依頼NPCと場所」「座標」）と、その手順の行の場所
FILL = {
    'quests/sandoria.json': {
        'npc.Regine': ('サンドリア港', 'J-8', None, '用語辞典「魔法屋のチラシ」依頼者：サンドリア港の魔法屋「ルジヌ魔法用品店」(J-8)', 'https://wiki.ffo.jp/html/3300.html'),
    },
    'quests/bastok.json': {
        'npc.Deidogg': ('バストゥーク鉱山区', 'H-6', None, '用語辞典「200年のすれ違い」「語り部の遺品」依頼者：バストゥーク鉱山区の鉱石通り(H-6)', 'https://wiki.ffo.jp/html/7041.html'),
        'npc.Phara': ('バストゥーク鉱山区', 'J-9', None, '用語辞典「祖母の心孫知らず」依頼者：バストゥーク鉱山区(J-9)', 'https://wiki.ffo.jp/html/8579.html'),
    },
    'quests/windurst.json': {
        'npc.Honoi-Gomoi': ('ウィンダス水の区', 'E-7', 2, '用語辞典「カーディアンはトライマライの夢を見るか？」依頼者：ウィンダス水の区（南）の商人の家(E-7)。南は MAP2', 'https://wiki.ffo.jp/html/7400.html'),
        'npc.Ohbiru-Dohbiru': ('ウィンダス水の区', 'J-9', 2, '用語辞典「水呼びの扉」「魔法の水」依頼者：ウィンダス水の区の鼻の院（南マップ J-9）。南は MAP2', 'https://wiki.ffo.jp/html/5421.html'),
        'obj.Door_House_of_the_Hero': ('ウィンダス石の区', 'G-3', None, '用語辞典「7色の光を！」「人形使い」依頼者：ウィンダス石の区の英雄の家(G-3)', 'https://wiki.ffo.jp/html/7011.html'),
    },
    'missions/sandoria.json': {
        'npc.Arnau': ('北サンドリア', 'M-6', None, '用語辞典「子供の救助」：北サンドリアの大聖堂(M-6)のArnau', None),
        'obj.Door_Great_Hall': ('ドラギーユ城', 'I-9', None, '用語辞典のサンドリアミッション：ドラギーユ城(I-9)のDoor:Great Hall', None),
    },
    'missions/bastok.json': {
        'npc.Alois': ('大工房', 'J-8', None, '用語辞典のバストゥークミッション：大工房(J-8)大統領府のAlois', None),
    },
}

def main():
    w = windower()
    zp = DATA / 'zones.json'
    zdoc = json.loads(zp.read_text(encoding='utf-8'))
    have = {z['zone_name']: z['zone_id'] for z in zdoc['zones']}
    bad = [(n, i, w[n]) for n, i in have.items() if n in w and w[n] != i]
    assert not bad, bad
    maps = json.loads((DATA / 'maps.json').read_text(encoding='utf-8'))
    floors = {}
    for f in maps['floors']:
        if f.get('zone_id') is not None: floors[f['zone_id']] = floors.get(f['zone_id'], 0) + 1
    # 使われているゾーン名（.gd の @、資料の zone_name、FILL）
    used = set()
    for gd in (ROOT / 'dev' / 'guides').glob('*.gd'):
        used |= set(re.findall(r'@([^\s|#]+)', gd.read_text(encoding='utf-8')))
    for f in glob.glob(str(DATA / '*' / '*.json')):
        d = json.loads(open(f, encoding='utf-8').read())
        for t in (d.get('targets') or []) if isinstance(d, dict) else []:
            n = (t.get('location') or {}).get('zone_name')
            if n: used.add(n)
    for m in FILL.values():
        for v in m.values(): used.add(v[0])
    added = []
    ids = set(have.values())
    for n in sorted(used):
        if n not in have and n in w and w[n] not in ids:
            zdoc['zones'].append({'checked': False, 'maps': 'unknown', 'zone_id': w[n], 'zone_name': n,
                                  'source': 'Windower Resources zones.lua (ja)'})
            have[n] = w[n]; ids.add(w[n]); added.append(n)
    zdoc['zones'].sort(key=lambda z: z['zone_id'])
    zp.write_text(json.dumps(zdoc, ensure_ascii=False, indent=2, sort_keys=True) + '\n', encoding='utf-8')
    print('zones added', len(added), ' '.join(added))

    def mapkind(zid, n):
        if n is not None: return {'kind': 'number', 'n': n}
        if zid is not None and floors.get(zid) == 1: return {'kind': 'single'}
        return {'kind': 'unknown'}

    filled = zoned = 0
    for f in sorted(glob.glob(str(DATA / 'quests' / '*.json')) + glob.glob(str(DATA / 'missions' / '*.json'))):
        rel = os.path.relpath(f, DATA)
        d = json.loads(open(f, encoding='utf-8').read())
        ch = False
        for t in d.get('targets') or []:
            spec = FILL.get(rel, {}).get(t['id'])
            if spec:
                zone, grid, n, fact, url = spec
                loc = {'zone_id': have[zone], 'zone_name': zone, 'grid': grid, 'map': mapkind(have[zone], n)}
                if t.get('location') != loc:
                    t['location'] = loc; ch = True; filled += 1
                    src = {'checked': CHECKED, 'fact_ja': fact, 'name': '用語辞典'}
                    if url: src['urls'] = [url]
                    ls = t.setdefault('location_sources', [])
                    if not any(s.get('fact_ja') == fact for s in ls): ls.append(src)
                continue
            l = t.get('location')
            if l and l.get('zone_name') and l.get('zone_id') is None and l['zone_name'] in have:
                l['zone_id'] = have[l['zone_name']]
                if (l.get('map') or {}).get('kind') == 'unknown':
                    l['map'] = mapkind(l['zone_id'], None)
                ch = True; zoned += 1
        if ch:
            open(f, 'w', encoding='utf-8').write(json.dumps(d, ensure_ascii=False, indent=2, sort_keys=True) + '\n')
    print('filled', filled, 'zone ids set', zoned)

if __name__ == '__main__':
    main()
