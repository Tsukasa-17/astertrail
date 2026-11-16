#!/usr/bin/env python3
"""
ゲームのクエスト・ミッションの番号（ログの種類＋番号）と、資料のクエストを結びつける（0.1.169〜、t223）。

元にするもの：LandSandBoat の id 表（dev/sources/lsb/ にそのまま置いた。版は SOURCE.txt）。
  - クエスト：scripts/globals/quests.lua の xi.quest.id（ログごとの名前＝番号）
  - ミッション：scripts/globals/missions.lua の xi.mission.id、アサルトは scripts/enum/assault.lua
結び方：英語名を大文字・英数字だけにしたものが、LSB の名前と「ちょうど1つ」一致したときだけ。
  英語名に「/」で別名があるときはそれぞれ、最後の（国名）は外して比べる。
  - ログは資料の分類で決まる（例：サンドリアのクエストはサンドリアのログだけ）。
    ミスラ・ノーグなどの「その他の地域」「辺境」は 2 つのログのどちらか。misc・records は全部のログ。
  - 一致が 0 個・2 個以上のものは結ばない（推測しない）。
  - カンパニエ（LSB に id がない）、ヴァナ・ディールの星唄 TVR（LSB で「推測」と書いてある）は結ばない。
出力：data/game_refs.json（{ "quest.bastok.001": ["q", 1, 12], "mission.zilart.002": ["m", 3, 4] } など）
"""
import glob, json, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, 'dev', 'sources', 'lsb')

QUEST_LOG = {'SANDORIA': 0, 'BASTOK': 1, 'WINDURST': 2, 'JEUNO': 3, 'OTHER_AREAS': 4, 'OUTLANDS': 5,
             'AHT_URHGAN': 6, 'CRYSTAL_WAR': 7, 'ABYSSEA': 8, 'ADOULIN': 9, 'COALITION': 10}
MISSION_LOG = {'SANDORIA': 0, 'BASTOK': 1, 'WINDURST': 2, 'ZILART': 3, 'TOAU': 4, 'WOTG': 5, 'COP': 6,
               'ASSAULT': 7, 'ACP': 9, 'AMK': 10, 'ASA': 11, 'SOA': 12, 'ROV': 13}

# 資料の分類 → 探すログ
QUEST_CAT = {
    'sandoria': ['SANDORIA'], 'bastok': ['BASTOK'], 'windurst': ['WINDURST'], 'jeuno': ['JEUNO'],
    'selbina_mhaura': ['OTHER_AREAS', 'OUTLANDS'], 'rabao': ['OTHER_AREAS', 'OUTLANDS'],
    'kazham': ['OTHER_AREAS', 'OUTLANDS'], 'norg': ['OTHER_AREAS', 'OUTLANDS'],
    'tavnazia': ['OTHER_AREAS', 'OUTLANDS'],
    'aht_urhgan': ['AHT_URHGAN'], 'altana': ['CRYSTAL_WAR'], 'abyssea': ['ABYSSEA'],
    'adoulin': ['ADOULIN', 'COALITION'],
    'misc': list(QUEST_LOG), 'records': list(QUEST_LOG),
}
MISSION_CAT = {
    'sandoria': 'SANDORIA', 'bastok': 'BASTOK', 'windurst': 'WINDURST', 'zilart': 'ZILART',
    'aht_urhgan': 'TOAU', 'altana': 'WOTG', 'promathia': 'COP', 'assault': 'ASSAULT',
    'acp': 'ACP', 'mkd': 'AMK', 'asa': 'ASA', 'adoulin': 'SOA', 'rov': 'ROV',
}


def parse(path, area_re):
    out, cur = {}, None
    for line in open(path, encoding='utf-8'):
        m = re.match(r'\s*\[xi\.' + area_re + r'\]\]\s*=', line)
        if m:
            cur = m.group(1)
            out[cur] = {}
            continue
        if cur:
            m = re.match(r'\s*([A-Z0-9_]+)\s*=\s*(\d+)\s*,', line)
            if m:
                out[cur][m.group(1)] = int(m.group(2))
            elif re.match(r'\s*\},', line):
                cur = None
    return out


def parse_assault(path):
    out, on = {}, False
    for line in open(path, encoding='utf-8'):
        if line.startswith('xi.assault.mission ='):
            on = True
            continue
        if on:
            m = re.match(r'\s*([A-Z0-9_]+)\s*=\s*(\d+)\s*,', line)
            if m:
                out[m.group(1)] = int(m.group(2))
            elif line.startswith('}'):
                break
    return out


def key(s):
    s = (s or '').upper().replace("'", '').replace('\u2019', '')
    return re.sub(r'[^A-Z0-9]', '', s)


def names_of(name):
    """英語名の形を少しだけ変えたもの：全体、「/」で分けたそれぞれ、最後の（国名）を外したもの。"""
    out = []
    for part in [name or ''] + (name or '').split('/'):
        part = part.strip()
        out.append(key(part))
        out.append(key(re.sub(r'\s*[（(][^（）()]*[）)]\s*$', '', part)))
    return [k for k in dict.fromkeys(out) if k]


def main():
    quests = parse(os.path.join(SRC, 'quests.lua'), r'quest\.area\[xi\.questLog\.([A-Z_]+)')
    missions = parse(os.path.join(SRC, 'missions.lua'), r'mission\.area\[xi\.mission\.log_id\.([A-Z_]+)')
    missions['ASSAULT'] = parse_assault(os.path.join(SRC, 'assault_enum.lua'))

    def index(table):
        idx = {}
        for area, names in table.items():
            for n, i in names.items():
                idx.setdefault((area, key(n)), []).append(i)
        return idx
    qidx, midx = index(quests), index(missions)

    refs, stats, unmapped, order = {}, {}, {}, {}
    for f in sorted(glob.glob(os.path.join(ROOT, 'data', 'quests', '*.json')) +
                    glob.glob(os.path.join(ROOT, 'data', 'missions', '*.json'))):
        d = json.load(open(f, encoding='utf-8'))
        for q in d.get('quests', []):
            cat, kind = q.get('category'), q.get('kind')
            order[q['id']] = (q.get('order') if isinstance(q.get('order'), int) else 10 ** 6, q['id'])
            keys = names_of(q.get('name_en'))
            found = set()
            if kind == 'mission':
                area = MISSION_CAT.get(cat)
                if area:
                    for k in keys:
                        found |= {('m', MISSION_LOG[area], i) for i in midx.get((area, k), [])}
            else:
                for area in QUEST_CAT.get(cat, []):
                    for k in keys:
                        found |= {('q', QUEST_LOG[area], i) for i in qidx.get((area, k), [])}
            hits = sorted(found)
            s = stats.setdefault(kind + '.' + str(cat), [0, 0])
            if len(hits) == 1:
                refs[q['id']] = list(hits[0])
                s[0] += 1
            else:
                s[1] += 1
                unmapped.setdefault(kind + '.' + str(cat), []).append((q['id'], q.get('name_en'), len(hits)))
    # 同じゲーム番号に資料のクエストが2つ以上結ばれたら、どれも結ばない
    by_ref = {}
    for qid, r in refs.items():
        by_ref.setdefault(tuple(r), []).append(qid)
    dups = {k: v for k, v in by_ref.items() if len(v) > 1}
    for k, v in dups.items():
        for qid in v:
            del refs[qid]
    # 今のミッションだけが届くログ（プロマシア・追加シナリオ・アドゥリン・星唄）は、
    # 番号の並び（mission_ids）を出す。「今より前の番号は済み」とするのは、LSB の番号が資料の順（話の順）に
    # 増えているログ（mission_ordered）だけ。プロマシアは道が分かれるので「今のミッション＝受注中」だけ。
    order_logs, ordered = {}, []
    for area in ('COP', 'ACP', 'AMK', 'ASA', 'SOA', 'ROV'):
        log = MISSION_LOG[area]
        # 資料の順（本の並びの order。番号の飛んだ後から足したものもあるので id ではなく order）
        mine = sorted(((order[qid], r[2]) for qid, r in refs.items() if r[0] == 'm' and r[1] == log))
        nums = [n for _, n in mine]
        ok = all(a < b for a, b in zip(nums, nums[1:]))
        order_logs[str(log)] = sorted(v for k, v in missions[area].items() if k != 'NONE')
        if ok:
            ordered.append(log)
        print(' order %-4s %s (%d mapped)' % (area, 'ok' if ok else 'NOT increasing - current only', len(nums)))
    out = {'source': open(os.path.join(SRC, 'SOURCE.txt'), encoding='utf-8').read().strip(),
           'mission_ids': order_logs,
           'mission_ordered': ordered,
           'refs': dict(sorted(refs.items()))}
    with open(os.path.join(ROOT, 'data', 'game_refs.json'), 'w', encoding='utf-8') as fp:
        json.dump(out, fp, ensure_ascii=False, indent=0, sort_keys=False)
        fp.write('\n')
    print('game_refs', len(refs), 'dups dropped', sum(len(v) for v in dups.values()))
    for k in sorted(stats):
        print(' %-22s mapped %4d  unmapped %4d' % (k, stats[k][0], stats[k][1]))
    if '-v' in sys.argv:
        for k, v in sorted(unmapped.items()):
            for row in v:
                print('  -', k, row)
        for k, v in dups.items():
            print('  dup', k, v)


if __name__ == '__main__':
    main()
