#!/usr/bin/env python3
"""
Astertrail - サーバーに入っていないエミネンス（data/roe_unimplemented.json）を作る（0.1.294〜）。

判定（LSB の実物で確かめた）：
  - サーバーは xi.roe.records（scripts/globals/roe_records.lua）に載っている番号だけを ImplementedRecords に入れる
    （src/map/roe.cpp の ParseRecords）。載っていない番号を受けると AddEminenceRecord が
    「The record #N is not implemented at this time.」と返して受けない。
  - そこで「クライアント DAT に名前があり、roe_records.lua（コメントを外したあと）に無い番号」を未実装とする。
  - 載っていても trigger の無い番号は、スクリプトから進めているかを確かめる（下の表示）。
    0.1.294 の時点では、trigger の無い 29 件すべてに進め方があった（retro の check、または
    xi.roe.onRecordTrigger の呼び出し。100〜107 は guild_master.lua の guildId + 99、1447 は aman_trove.lua の変数）。
使い方: python3 dev/build_roe_unimplemented.py <LSB の checkout> <DAT の番号の JSON>
  DAT の番号の JSON は、ゲーム PC で読むだけの小道具（dev/roe_dat_ids.py）が出すもの。
（dev/build_data.py とは別。クエストのデータは触らない）
"""
import json, os, re, sys, datetime, subprocess
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import roe_lsb

# 変数で呼んでいるため文字では見つからない進め方（手で確かめたもの）
VIA_VARIABLE = {
    **{n: 'scripts/globals/hobbies/crafting/guild_master.lua (guildId + 99)' for n in range(100, 108)},
    1447: 'scripts/globals/aman_trove.lua (exploringTheTrove)',
}


def literal_triggers(lsb):
    found = set()
    pat = re.compile(r'(?:onRecordTrigger\(\s*\w+\s*,\s*|setEminenceCompleted\()(\d+)')
    for root, _, files in os.walk(os.path.join(lsb, 'scripts')):
        for f in files:
            if not f.endswith('.lua') or f == 'roe_records.lua':
                continue
            for m in pat.finditer(open(os.path.join(root, f), encoding='utf-8', errors='replace').read()):
                found.add(int(m.group(1)))
    return found


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(2)
    lsb, dat_json = sys.argv[1], sys.argv[2]
    recs = roe_lsb.records(open(os.path.join(lsb, 'scripts', 'globals', 'roe_records.lua'), encoding='utf-8').read())
    raw = open(dat_json, encoding='utf-8-sig').read()
    dat = {int(k): v for k, v in json.loads(raw)['recs'].items()}
    missing = sorted(i for i in dat if i not in recs)
    lit = literal_triggers(lsb)
    no_trigger = sorted(i for i, b in recs.items() if not re.search(r'\btrigger\s*=', b))
    unproven = []
    for i in no_trigger:
        b = recs[i]
        retro_check = 'retro' in roe_lsb.flags_of(b) and re.search(r'\bcheck\s*=', b)
        if not (retro_check or i in lit or i in VIA_VARIABLE):
            unproven.append(i)
    try:
        commit = subprocess.check_output(['git', '-C', lsb, 'rev-parse', 'HEAD'], text=True).strip()
    except Exception:
        commit = ''
    doc = {
        'built': datetime.date.today().isoformat(),
        'source': 'LSB scripts/globals/roe_records.lua ' + commit[:10] + ' vs client DAT 55672',
        'dat_count': len(dat),
        'implemented_count': len(recs),
        'missing': missing,
    }
    root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    path = os.path.join(root, 'data', 'roe_unimplemented.json')
    with open(path, 'w', encoding='utf-8') as fp:
        json.dump(doc, fp, ensure_ascii=False, separators=(',', ':'))
        fp.write('\n')
    print(path, 'dat', len(dat), 'lsb', len(recs), 'missing', len(missing),
          'lsb-not-in-dat', len([i for i in recs if i not in dat]))
    print('no trigger', len(no_trigger), 'unproven', unproven)
    for i in missing[:12]:
        print(' ', i, dat[i]['name'])


if __name__ == '__main__':
    main()
