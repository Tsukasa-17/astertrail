#!/usr/bin/env python3
"""
手順の「必要な品」（data/guides/steps_v2.json の needs[].name_ja）を、ゲームの品の番号に結ぶ（0.1.184〜、t297）。

元にするもの：ゲームのクライアントにある日本語の DAT（読むだけ。このリポジトリには置かない）。
  - 品：ファイル番号 4, 5, 6, 7, 8, 9, 55547, 55548, 55549, 55550, 55551
        （1 件 0xC00 バイト。各バイトを右に 5 ビット回すと元に戻る。名前は最初の文字列）
  - だいじなもの：ファイル番号 55575（d_msg 形式。ヘッダー 64 バイトのあとを 0xFF で反転。
        1 件 = 欄の数・(位置, 種類) の並び。欄 0 が番号、欄 1 が名前）
  使い方：python3 dev/build_item_refs.py <DAT を「番号.DAT」の名前で置いたフォルダ>
結び方：名前が「ちょうど 1 つ」の番号と同じ文字列のときだけ（前後の空白だけ落とす）。
  0 個・2 個以上のものは結ばない（推測しない。画面では所持が「未確認」のまま）。
出力：data/item_refs.json（{ "items": { "氷のクリスタル": 4097 }, "key_items": { ... } } など）
"""
import json, os, struct, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ITEM_FILES = ['4', '5', '6', '7', '8', '9', '55547', '55548', '55549', '55550', '55551']
KEY_ITEM_FILE = '55575'
ROT = bytes([((b >> 5) | (b << 3)) & 0xFF for b in range(256)])


def _first_text(r, base):
    if base + 4 > len(r):
        return None
    n = struct.unpack_from('<i', r, base)[0]
    if n < 1 or n > 12 or base + 4 + n * 8 > len(r):
        return None
    off, typ = struct.unpack_from('<ii', r, base + 4)
    if off != 4 + n * 8 or typ != 0:
        return None
    p = base + off
    if p + 28 > len(r) or struct.unpack_from('<i', r, p)[0] != 1:
        return None
    e = r.find(b'\0', p + 28)
    return None if e < 0 else r[p + 28:e]


def item_names(path):
    raw = open(path, 'rb').read()
    out = {}
    for i in range(0, len(raw) - 0xC00 + 1, 0xC00):
        r = raw[i:i + 0xC00].translate(ROT)
        iid = struct.unpack_from('<I', r, 0)[0]
        for base in range(0x0C, 0x300, 2):
            s = _first_text(r, base)
            if s is not None:
                try:
                    nm = s.decode('cp932')
                except UnicodeDecodeError:
                    nm = None
                if nm and nm != '.':
                    out.setdefault(iid, nm)
                break
    return out


def key_item_names(path):
    r = open(path, 'rb').read()
    h = struct.unpack_from('<8sHHIIIIIIIII', r, 0)
    if h[0] != b'd_msg\0\0\0':
        raise SystemExit('d_msg ではありません: ' + path)
    x = bytes(b ^ 0xFF for b in r) if h[11] == 1 else r
    count, toc, size = h[10], h[7], h[8]
    out = {}
    for i in range(count):
        if toc:
            off, ln = struct.unpack_from('<II', x, 64 + i * 8)
            e = x[64 + toc + off:64 + toc + off + ln]
        else:
            e = x[64 + i * size:64 + (i + 1) * size]
        n = struct.unpack_from('<I', e, 0)[0]
        if n < 2:
            continue
        o0, t0 = struct.unpack_from('<Ii', e, 4)
        o1, t1 = struct.unpack_from('<Ii', e, 12)
        if t0 == 0 or t1 != 0:
            continue
        kid = struct.unpack_from('<i', e, o0)[0]
        s = e[o1 + 28:e.find(b'\0', o1 + 28)]
        try:
            out[kid] = s.decode('cp932')
        except UnicodeDecodeError:
            pass
    return out


def reverse(m):
    rev = {}
    for k, v in m.items():
        rev.setdefault(v.strip(), set()).add(k)
    return rev


def main():
    if len(sys.argv) < 2:
        raise SystemExit(__doc__)
    d = sys.argv[1]
    items = {}
    for f in ITEM_FILES:
        for k, v in item_names(os.path.join(d, f + '.DAT')).items():
            items.setdefault(k, v)
    keys = key_item_names(os.path.join(d, KEY_ITEM_FILE + '.DAT'))
    ri, rk = reverse(items), reverse(keys)
    guides = json.load(open(os.path.join(ROOT, 'data', 'guides', 'steps_v2.json'), encoding='utf-8'))
    out_i, out_k, stat = {}, {}, {'item': [0, 0, 0], 'key_item': [0, 0, 0]}   # 結んだ・候補なし・候補が複数
    for g in guides.get('guides', []):
        for s in g.get('steps', []):
            for n in s.get('needs') or []:
                name = (n.get('name_ja') or '').strip()
                kind = 'key_item' if n.get('kind') == 'key_item' else 'item'
                ids = (rk if kind == 'key_item' else ri).get(name)
                if ids and len(ids) == 1:
                    (out_k if kind == 'key_item' else out_i)[name] = next(iter(ids))
                    stat[kind][0] += 1
                elif ids:
                    stat[kind][2] += 1
                else:
                    stat[kind][1] += 1
    doc = {
        'source': 'ゲームの日本語 DAT（品 ' + ', '.join(ITEM_FILES) + ' / だいじなもの ' + KEY_ITEM_FILE +
                  '）。名前がちょうど 1 つの番号と同じものだけ',
        'items': dict(sorted(out_i.items(), key=lambda kv: kv[1])),
        'key_items': dict(sorted(out_k.items(), key=lambda kv: kv[1])),
    }
    with open(os.path.join(ROOT, 'data', 'item_refs.json'), 'w', encoding='utf-8') as f:
        json.dump(doc, f, ensure_ascii=False, indent=0)
        f.write('\n')
    for k, (ok, miss, multi) in stat.items():
        print(f'{k}: 結んだ {ok} / 候補なし {miss} / 候補が複数 {multi}（必要の欄の数）')
    print(f'名前の数：品 {len(out_i)}、だいじなもの {len(out_k)}')


if __name__ == '__main__':
    main()
