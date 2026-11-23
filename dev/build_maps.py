#!/usr/bin/env python3
"""
地図の対応表（CSV）から data/maps.json を作る。開発用。ゲームには不要。

入力の既定: /workspace/astertrail-maptable/correspondence/map_floor_correspondence_20261112.csv
MAP 番号がある行だけを表示対象にする。FloorIndex 0（MAP 空欄）の行は出さない。
未確定のゾーンは unconfirmed_zones にまとめる。機械固有のパスは書かない。
"""
import csv, json, io, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..', 'data')
DEFAULT_CSV = '/workspace/astertrail-maptable/correspondence/map_floor_correspondence_20261112.csv'

STATUS = {
    'ルール適用': 'rule_applied',
    '未確定（FloorIndex=0）': 'unconfirmed',
    '確認済み': 'confirmed',
    '確認済み（メニューに出ない）': 'not_in_menu',
    '確認済み（メニューなし・1枚）': 'confirmed',
    '確認済み（メニューなし・1枚、FloorIndex例外）': 'confirmed',
    '確認済み（1枚）': 'confirmed',
}

def build(csv_path, out_path):
    text = open(csv_path, 'rb').read().decode('utf-8-sig')
    rows = list(csv.DictReader(io.StringIO(text)))
    floors, unconfirmed, seen = [], [], set()
    for r in rows:
        zid = int(r['zone_id'])
        st = STATUS.get(r['status'])
        if not st:
            raise SystemExit('unknown status: ' + r['status'])
        mn = (r.get('map_n') or '').strip()
        rec = {
            'zone_id': zid,
            'zone_name': r['zone_name'],
            'floor_index': int(r['floor_index']),
            'floor_id': int(r['floor_id']),
            'status': st,
            'scale': int(r['scale']) if r.get('scale') else None,
            'offset_x': int(r['offset_x']) if r.get('offset_x') not in (None, '') else None,
            'offset_y': int(r['offset_y']) if r.get('offset_y') not in (None, '') else None,
            'file_id': int(r['file_id']) if r.get('file_id') else None,
        }
        if mn:
            rec['map_n'] = int(mn)
            if 'FloorIndex例外' in (r.get('status') or '') or 'FloorIndex例外' in (r.get('note') or ''):
                rec['note'] = '選択メニューなし・1枚。MAP 1（FloorIndex＝MAP番号の例外）。'
            floors.append(rec)
        elif st == 'unconfirmed':
            if zid not in seen:
                seen.add(zid)
                unconfirmed.append({'zone_id': zid, 'zone_name': r['zone_name']})
    floors.sort(key=lambda f: (f['zone_id'], f['map_n']))
    unconfirmed.sort(key=lambda f: f['zone_id'])
    doc = {
        'data_schema': 1,
        'data_kind': 'maps',
        'client_version': '3.0.0.0',
        'dumped_at': '2026-11-12 13:22:22',
        'built': '2026-11-12',
        'source': 'maptable 0.1 の読み出し（661件・231ゾーン）と、同日のメニュー照合。',
        'rule_ja': 'メニューに [n] が出るエリアでは FloorIndex＝MAP n。FloorId は別の番号。FloorIndex 0 はメニューに出ない行で、MAP番号は付けない。1枚だけのエリアは FloorIndex が MAP番号と一致するとは限らない（ツェールン鉱山）。',
        'floors': floors,
        'unconfirmed_zones': unconfirmed,
    }
    # ゲームの地図が無いエリアの、ゾーン DAT から描いた地図（0.1.323〜、天の塔）。作り直しても消えないように最後に足す
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    import build_dat_maps
    doc = build_dat_maps.merge_maps(doc)
    floors = doc['floors']
    unconfirmed = doc['unconfirmed_zones']
    with open(out_path, 'w', encoding='utf-8', newline='\n') as f:
        json.dump(doc, f, ensure_ascii=False, indent=2)
        f.write('\n')
    print('floors', len(floors), 'unconfirmed_zones', len(unconfirmed), '->', out_path)

if __name__ == '__main__':
    csv_path = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_CSV
    out = sys.argv[2] if len(sys.argv) > 2 else os.path.join(ROOT, 'maps.json')
    build(csv_path, out)
