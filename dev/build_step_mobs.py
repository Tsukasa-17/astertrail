#!/usr/bin/env python3
"""手順の文に書いてある「落とすモンスター」と「種族」を、印の相手にする（0.1.190〜、t321・t322）。

data/step_mobs.json を作る。名前は推測しない：
- 文の名前（英語）は、LSB のモンスターの名前（dev/sources/lsb/mobs_by_zone.json）にあるものだけ使う。
- 「A・B・C Quadav」のような後ろ（前）が同じ並びは、広げた名前が全部 LSB にあるときだけ広げる。
- 「〜は落とさない」の文の名前は外す（クエストの注記の文も、そのクエストの全部の手順で外す）。
- 種族（「クゥダフ族」「オーク」など）は、名前が書いていない手順だけ。下の FAMILY の種族の一覧だけを使う。
  種族のモンスターの名前は、ゾーンごとに LSB の species から作る（ゲームの中で、名前でその種族か分かる）。
「」『』の中（品の名前）は読まない。
"""
import json, re, pathlib, collections, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
DATA = ROOT / 'data'
OUT = DATA / 'step_mobs.json'

# 種族の日本語 → LSB の species（はっきり同じ種族のものだけ。像・砲台・兵器は入れない）
FAMILY = {
    'クゥダフ': ('quadav', ['quadav', 'quadav_s', 'horned_quadav_s', 'dynamis_quadav']),
    'オーク': ('orc', ['orc', 'orc_s', 'masked_orc_s', 'dynamis_orc']),
    'ヤグード': ('yagudo', ['yagudo', 'yagudo_s', 'whitehead_yagudo_s', 'dynamis_yagudo']),
    'ゴブリン': ('goblin', ['goblin', 'goblin_s', 'armored_goblin', 'dynamis_goblin']),
    'モブリン': ('moblin', ['moblin']),
    'ギガース': ('gigas', ['gigas']),
    'サハギン': ('sahagin', ['blue_sahagin', 'yellow_sahagin']),
    'アンティカ': ('antica', ['antica']),
    'トンベリ': ('tonberry', ['tonberry']),
    'ラミア': ('lamiae', ['lamiae']),
    'トロール': ('troll', ['light_troll', 'heavy_troll', 'plated_troll']),
    'フォモル': ('fomor', ['fomor']),
    'ゴースト': ('ghost', ['ghost']),
    'スケルトン': ('skeleton', ['skeleton']),
    'ボム': ('bomb', ['bomb']),
    'スライム': ('slime', ['slime']),
    'ワーム': ('worm', ['worm']),
    'インプ': ('imp', ['imp']),
    'コウモリ': ('bat', ['bat', 'flock_bat']),
    'リーチ': ('leech', ['leech']),
    'クラブ': ('crab', ['crab']),
    'プギル': ('pugil', ['pugil']),
    'サソリ': ('scorpion', ['scorpion']),
    'クロウラー': ('crawler', ['crawler']),
    'ゴーレム': ('golem', ['golem']),
    'ドール': ('doll', ['doll']),
    'スパイダー': ('spider', ['spider']),
    'モルボル': ('morbol', ['morbol']),
    'タウルス': ('taurus', ['taurus']),
    'マジックポット': ('magic_pot', ['magic_pot']),
}

POS = re.compile(r'落と[すし]|から(も)?(出る|手に入る)|ドロップ|を倒して.*(手に入れ|集め|入手|もら)|を倒して.*を(手に入れ|集め|入手)')
NEG = re.compile(r'落とさ(ない|ず)|は出ない')
WORD = r"[A-Z][A-Za-z'\-\.]*"
LINK = r"(?:of|the|de|du|la|le)"
NAME = re.compile(WORD + r"(?: (?:" + WORD + "|" + LINK + r"))*")
KATA = re.compile(r'[ァ-ヶー]')


def strip_quotes(t):
    return re.sub(r'「[^」]*」|『[^』]*』', '', t or '')


def sentences(t):
    return [s for s in re.split(r'[。\n]', strip_quotes(t)) if s.strip()]


def key(n):
    # LSB の名前は ' を落としていることがある（NiGhu Nestfender ＝ Ni'Ghu Nestfender）。大文字・小文字と ' は見ない
    return n.replace("'", '').replace('’', '').lower()


def load():
    mobs = json.loads((ROOT / 'dev/sources/lsb/mobs_by_zone.json').read_text(encoding='utf-8'))
    zones_of = collections.defaultdict(set)   # 名前の鍵 → ゾーン
    canon = {}
    for z, names in mobs.items():
        for n in names:
            zones_of[key(n)].add(int(z))
            canon.setdefault(key(n), n)
    zdoc = json.loads((DATA / 'zones.json').read_text(encoding='utf-8'))
    zname = sorted(((z['zone_name'], z['zone_id']) for z in zdoc['zones'] if z.get('zone_name')), key=lambda x: -len(x[0]))
    return mobs, zones_of, canon, zname


MOBS, ZONES_OF, CANON, ZNAME = load()


def real(n):
    return key(n) in ZONES_OF


def name_lists(sen):
    """名前の並び（・ でつながったもの）"""
    out, cur, last_end = [], [], None
    for m in NAME.finditer(sen):
        tok = m.group(0).rstrip('.')
        if cur and last_end is not None and sen[last_end:m.start()] in ('・', '、', ' ・ '):
            cur.append(tok)
        else:
            if cur: out.append(cur)
            cur = [tok]
        last_end = m.end()
    if cur: out.append(cur)
    return out


def resolve(lst, stats):
    """並びを名前にする。広げるのは、広げた名前が全部本物のときだけ。"""
    if all(real(t) for t in lst):
        return list(lst), None
    if len(lst) >= 2:
        last = lst[-1].split(' ')
        for k in range(1, len(last)):
            suf = ' '.join(last[-k:])
            ex = [t if t.endswith(' ' + suf) or t == suf else t + ' ' + suf for t in lst]
            if all(real(t) for t in ex):
                stats['suffix'] += 1
                return ex, 'suffix'
        first = lst[0].split(' ')
        for k in range(1, len(first)):
            pre = ' '.join(first[:k])
            ex = [t if t.startswith(pre + ' ') else pre + ' ' + t for t in lst]
            if all(real(t) for t in ex):
                stats['prefix'] += 1
                return ex, 'prefix'
    ok = [t for t in lst if real(t)]
    bad = [t for t in lst if not real(t)]
    return ok, ('partial' if bad else None), bad


def zones_in(sen):
    out, rest = [], sen
    for nm, zid in ZNAME:
        if nm in rest:
            out.append(zid)
            rest = rest.replace(nm, '\0')
    return out


report_skip = []
FAM_TAIL = re.compile(r'^(族)?((?:か|や|・|と|、)[^、。を]{0,16}?)*?(?:\d+体|など|の群れ)?(?:（[^）]*）)?(を倒|が落と|から(も)?出|を狩)')


def families(sen):
    out, skipped_end = [], set()
    hits = []
    for word, (fk, _) in FAMILY.items():
        for m in re.finditer(re.escape(word), sen):
            hits.append((m.start(), m, word, fk))
    hits.sort(key=lambda x: x[0])
    for _, m, word, fk in hits:
        if True:
            if m.start() > 0 and KATA.match(sen[m.start() - 1]):
                continue
            after = sen[m.end():]
            if after[:1] and KATA.match(after[0]):
                continue
            if not FAM_TAIL.match(after):
                continue
            if 'トレード' in sen:
                continue
            # 直前の「<ゾーン>の」（「AとBの」も。ゾーンの名前に「の」が入ることがある）
            h = sen[:m.start()]
            zs = []
            if h.endswith('の'):
                h = h[:-1]
                while True:
                    hit = next(((nm, zid) for nm, zid in ZNAME if h.endswith(nm)), None)
                    if not hit:
                        break
                    zs.append(hit[1]); h = h[:-len(hit[0])]
                    if h[-1:] in ('と', '・', 'や'):
                        h = h[:-1]
                    else:
                        break
            # 前に付いた言葉が種族を絞っている（「一部の」「詩人」「重装備の」など）ときは使わない。
            # よいのは：文の頭・区切りのあと・ゾーンの名前の「の」・過去世界の／現代の／ここの／たいていの
            head = sen[:m.start()]
            free = (head == '' or head[-1] in '、・かやは（' or bool(zs)
                    or any(head.endswith(w) for w in ('過去世界の', '現代の', 'ここの', 'たいていの')))
            end = m.end() + (1 if sen[m.end():m.end() + 1] == '族' else 0)
            # 「A族・B族」の前のほうを使わなかったら、続きも使わない
            if head[-1:] in '・かや' and head and (len(head) - 1) in skipped_end:
                free = False
            if not free:
                skipped_end.add(end)
                report_skip.append((word, sen[:60]))
                continue
            out.append((fk, zs))
    return out


def main():
    stats = collections.Counter()
    steps_out, fam_used = {}, set()
    report = collections.defaultdict(list)
    docs = {}
    for f in sorted((DATA / 'quests').glob('*.json')) + sorted((DATA / 'missions').glob('*.json')):
        d = json.loads(f.read_text(encoding='utf-8'))
        for q in d.get('quests') or d.get('missions') or []:
            docs[q['id']] = q
    guides = json.loads((DATA / 'guides/steps_v2.json').read_text(encoding='utf-8'))['guides']
    for g in guides:
        q = docs.get(g['quest'], {})
        qneg = set()
        for sen in sentences(q.get('note_ja')):
            if NEG.search(sen):
                for lst in name_lists(sen):
                    qneg.update(resolve(lst, collections.Counter())[0])
        for s in g['steps']:
            loc = s.get('location') or {}
            szone = loc.get('zone_id')
            names, fams, neg = [], [], set(qneg)
            for field in ('text_ja', 'next_line_ja'):
                for sen in sentences(s.get(field)):
                    if NEG.search(sen):
                        for lst in name_lists(sen):
                            r = resolve(lst, stats)
                            neg.update(r[0])
                            if r[1] in ('suffix', 'prefix'): report['neg_expanded'].append((s['id'], r[0]))
                        continue
                    if not POS.search(sen):
                        continue
                    zs = zones_in(sen)
                    for lst in name_lists(sen):
                        r = resolve(lst, stats)
                        if r[1] in ('suffix', 'prefix'): report['expanded'].append((s['id'], lst, r[0]))
                        if r[1] == 'partial': report['partial'].append((s['id'], r[2]))
                        for n in r[0]:
                            zl = sorted(ZONES_OF[key(n)])
                            if szone in zl: zl = [szone]
                            elif set(zs) & set(zl): zl = sorted(set(zs) & set(zl))
                            names.append((n, zl, 'など' in sen))
                    for fkey, fz in families(sen):
                        report['family_sen'].append((s['id'], fkey, fz, sen[:70]))
                        if not fz and szone: fz = [szone]
                        fams.append((fkey, sorted(set(fz))))
            negk = {key(x) for x in neg}
            seen, nl = set(), []
            for n, zl, nado in names:
                if key(n) in negk or key(n) in seen: continue
                seen.add(key(n)); nl.append({'name': n, 'zones': zl})
                if nado: stats['nado_names'] += 1
            entry = {}
            if nl:
                entry['names'] = nl
                if fams: stats['family_skipped_for_names'] += 1
            elif fams:
                merged = {}
                for fkey, fz in fams:
                    if fkey in merged and (merged[fkey] == [] or fz == []):
                        merged[fkey] = []
                    else:
                        merged[fkey] = sorted(set(merged.get(fkey, [])) | set(fz))
                fl = []
                for fkey, fz in fams:
                    if fkey in merged:
                        fl.append({'family': fkey, 'zones': merged.pop(fkey)})
                        fam_used.add(fkey)
                entry['families'] = fl
            if entry:
                if neg: entry['exclude'] = sorted(neg)
                steps_out[s['id']] = entry
    # 種族ごと・ゾーンごとの名前（使う種族だけ）
    species_of = {fk: set(sp) for _, (fk, sp) in FAMILY.items()}
    fam_tab = {}
    for fk in sorted(fam_used):
        per = {}
        for z, names in sorted(MOBS.items(), key=lambda x: int(x[0])):
            ns = sorted(n for n, sp in names.items() if sp in species_of[fk])
            if ns: per[z] = ns
        fam_tab[fk] = per
    doc = {
        'data_schema': 1,
        'data_kind': 'step_mobs',
        'note_ja': '手順の文に書いてある、落とすモンスターの名前（本物の名前だけ）と種族。種族の名前の一覧はゾーンごと。dev/build_step_mobs.py が作る。',
        'steps': {k: steps_out[k] for k in sorted(steps_out)},
        'families': fam_tab,
    }
    OUT.write_text(json.dumps(doc, ensure_ascii=False, separators=(',', ':'), sort_keys=True) + '\n', encoding='utf-8')
    n_names = sum(1 for v in steps_out.values() if 'names' in v)
    n_fam = sum(1 for v in steps_out.values() if 'families' in v)
    print('steps', len(steps_out), 'with names', n_names, 'with families', n_fam, dict(stats))
    if '-v' in sys.argv:
        print('== family_skip', len(report_skip))
        for x in report_skip: print('  ', x)
        for k, v in report.items():
            print('==', k, len(v))
            for x in v: print('  ', x)
    return doc


if __name__ == '__main__':
    main()
