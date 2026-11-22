#!/usr/bin/env python3
"""
Astertrail - エミネンスのくり返し・日・週・月で受け直せる目標の番号（data/roe_cycles.json）を作る（0.1.293〜）。

元：LandSandBoat/server の scripts/globals/roe_records.lua（GPL-3.0）。各レコードの flags の名前と番号だけを使う。
  repeat  … 達成しても受注のまま／外してもすぐ受け直せる（サーバーの 0x10C は repeat なら達成済みでも受け付ける）
  daily   … 毎日 0:00 JST に達成が消える（src/map/roe.cpp の ClearDailyRecords）
  unity   … ユニティの目標。ClearDailyRecords で毎日 0:00 JST に達成が消える
  weekly  … 毎週月曜 0:00 JST に達成が消える（ClearWeeklyRecords、earth_time::get_next_game_week）
  monthly … LSB は毎月 1 日 0:00 JST に達成が消える（ClearMonthlyRecords。本家は版の更新のとき）
  timed   … 4 時間ごとにゲームが入れる（自分では受けられない）
  known   … LSB に載っている番号すべて（ここに無い番号は、クライアント DAT のくり返しの印を使う）
  timed_schedule … 0.1.294〜。scripts/globals/roe.lua の timedSchedule（曜日 日〜土 × 4 時間の枠 6 つ、JST）。
                   サーバーは JST の 0・4・8・12・16・20 時に CycleTimedRecords で入れ替える（src/map/time_server.cpp）
使い方: python3 dev/build_roe_cycles.py <roe_records.lua のパス> [roe.lua のパス]
（dev/build_data.py とは別。クエストのデータは触らない）
"""
import json, os, re, sys, datetime
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import roe_lsb

FLAGS = ['repeat', 'daily', 'weekly', 'monthly', 'unity', 'timed']


def parse(src):
    # 0.1.294〜：コメントを外してから読む（dev/roe_lsb.py）
    return {rid: roe_lsb.flags_of(body) for rid, body in roe_lsb.records(src).items()}


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(2)
    recs = parse(open(sys.argv[1], encoding='utf-8').read())
    doc = {
        'built': datetime.date.today().isoformat(),
        'source': 'LSB scripts/globals/roe_records.lua (flags only)',
        'known': sorted(recs),
    }
    for f in FLAGS:
        doc[f] = sorted(r for r, fl in recs.items() if f in fl)
    if len(sys.argv) >= 3:
        src = roe_lsb.strip_comments(open(sys.argv[2], encoding='utf-8').read())
        m = re.search(r'local\s+timedSchedule\s*=\s*\{(.*?)\n\}', src, re.S)
        rows = re.findall(r'\{([^{}]*)\}', m.group(1)) if m else []
        sched = [[int(x) for x in re.findall(r'\d+', r)] for r in rows]
        if len(sched) == 7 and all(len(r) == 6 for r in sched):
            doc['timed_schedule'] = sched
        else:
            print('timedSchedule not found / bad shape', sched)
            sys.exit(1)
    root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    path = os.path.join(root, 'data', 'roe_cycles.json')
    with open(path, 'w', encoding='utf-8') as fp:
        json.dump(doc, fp, ensure_ascii=False, separators=(',', ':'))
        fp.write('\n')
    print(path, len(recs), {f: len(doc[f]) for f in FLAGS})


if __name__ == '__main__':
    main()
