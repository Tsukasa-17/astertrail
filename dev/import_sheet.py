#!/usr/bin/env python3
"""シートCSVから公式の本編三国クエストと三国ミッションを取り込む。

既存の14クエストと4ミッションは英語名／ミッション番号で照合し、
IDも中身も上書きしない。新規だけを足す。

書いていない座標・MAP・対象は推測で埋めない。
ウィンダス水の区の北＝MAP 1、南＝MAP 2 は確認済みの方針。
Naji の大工房 J-8 だけ、座標が空のとき埋める。
CatsEye独自は入れない。build_locales.py は走らせない。
"""
from __future__ import annotations

import csv
import json
import re
import sys
from collections import defaultdict
from copy import deepcopy
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / 'data'
EXPORT = Path(__file__).resolve().parent / 'sheet_export'

TODAY = date.today().isoformat()
DATA_VERSION = '2026.11.12-8'

CITY_CLASS = {
    '本編/北サンドリア': ('sandoria', '北サンドリア'),
    '本編/南サンドリア': ('sandoria', '南サンドリア'),
    '本編/サンドリア港': ('sandoria', 'サンドリア港'),
    '本編/サンドリア': ('sandoria', None),
    '本編/ドラギーユ城': ('sandoria', 'ドラギーユ城'),
    '本編/バストゥーク商業区': ('bastok', 'バストゥーク商業区'),
    '本編/バストゥーク港': ('bastok', 'バストゥーク港'),
    '本編/バストゥーク鉱山区': ('bastok', 'バストゥーク鉱山区'),
    '本編/大工房': ('bastok', '大工房'),
    '本編/ウィンダス森の区': ('windurst', 'ウィンダス森の区'),
    '本編/ウィンダス水の区': ('windurst', 'ウィンダス水の区'),
    '本編/ウィンダス港': ('windurst', 'ウィンダス港'),
    '本編/ウィンダス石の区': ('windurst', 'ウィンダス石の区'),
    '本編/ウィンダス': ('windurst', None),
    '本編/天の塔': ('windurst', '天の塔'),
}

MISSION_CLASS = {
    'サンドリアミッション': 'sandoria',
    'バストゥークミッション': 'bastok',
    'ウィンダスミッション': 'windurst',
}

SKIP_JA = {
    'ヴァナ・ディールクイズ',
    '星の大樹',  # ステップ0の記事。クエスト本体は「星の大樹（クエスト）」
}

# 「名声は最初から可」だけ＝受けられない理由ではない
OK_FAME = re.compile(
    r'^名声(?:ランク)?(?:は)?'
    r'(?:初期(?:状態|段階)で可|初期で可|1で可|1で受けられる)'
    r'[。．、,]*$'
    r'|^名声は初期(?:状態|段階)で可[。．、,]*$'
    r'|^名声ランクは初期(?:状態|段階)で可[。．、,]*$'
)

BOILERPLATE = re.compile(
    r'(?:手順は記事本文を読んで手作業で要約（固有名詞・座標は記事表記のまま）'
    r'|番号は「(?:サンドリア|バストゥーク|ウィンダス)ミッション」一覧ページの略称表記'
    r'|開始NPCの座標:\s*記事に記載なし'
    r'|依頼者の座標:\s*記事に記載なし'
    r'|報酬:\s*記事に記載なし'
    r'|手順は「[^」]+」の行を参照)'
    r'[／/]?\s*'
)

GRID_RE = re.compile(
    r'(?:MAP\[(\d+)\])?'
    r'(?:（北マップ）|（南マップ）)?'
    r'\s*'
    r'[（(]?'
    r'(?:北マップ|南マップ|北側|南側|北部|南部|北・|南・|北|南)?'
    r'[,、・]?\s*'
    r'([A-P])-(\d{1,2})'
    r'(?:#(\d+))?'
    r'[）)]?'
)

MAP_RE = re.compile(r'MAP\[(\d+)\]')
GRID_ONLY = re.compile(r'([A-P])-(\d{1,2})')

# 英語の固有名（NPC・オブジェクト・モンスター）
EN_PAREN = re.compile(
    r'[（(]([A-Z][A-Za-z0-9\'\-\.:]*(?:[ \'][A-Za-z0-9\'\-\.:]+)*)[）)]'
)
EN_TOKEN = re.compile(
    r'(?:^|[^A-Za-z0-9\'\-])'
    r'([A-Z][A-Za-z0-9\'\-\.:]*(?:[ \'][A-Za-z0-9\'\-\.:]+)*)'
)

EN_SKIP = {
    'MAP', 'Map', 'BF', 'NM', 'HP', 'Lv', 'WM', 'SM', 'BM', 'G', 'V', 'Ex', 'EX',
    'AF', 'Lv5', 'Lv10', 'Lv15', 'Lv30', 'Lv40', 'Lv50', 'Lv66', 'Lv99',
    'THE', 'QUIZ', 'DE', 'NEW', 'HQ', 'WS', 'NPC', 'PT', 'LS', 'CS', 'MP', 'TP',
    'LV', 'OK', 'NG', 'AND', 'OR', 'OF', 'FOR', 'TO', 'IN', 'AT', 'ON', 'A', 'AN',
    'THE', 'FROM', 'WITH', 'BY', 'AS', 'IF', 'SO', 'NO', 'YES',
    'Survival', 'Guide', 'Home', 'Point', 'Wanted', 'Record', 'Event',
    'Entrance', 'Exit', 'Floor', 'Level', 'Rank', 'Title', 'Weather',
    'Area', 'Zone', 'Step', 'Page', 'Item', 'Key', 'Quest', 'Mission',
    'Treasure', 'Circle', 'Hut', 'Burning', 'Solo', 'Hero', 'Kings',
    'Magic', 'Chest', 'Door', 'Gate', 'Just', 'Handle',  # Handle は OBJ_EXACT で对象に
}
# 11人のゲートガードは専用アイコン側。通常の話す対象にはしない
GATE_GUARDS = {
    'Ambrotien', 'Endracion', 'Grilau', 'Argus', 'Cleades',
    'Malduc', 'Rashid', 'Mokyokyo', 'Janshura-Rashura',
    'Rakoh Buuma', 'Zokima-Rokima',
}
OBJ_EXACT = {
    '???', 'Treasure Chest', 'Hut Door', 'Burning Circle', 'Signpost',
    'Tombstone', 'Handle', 'Sealed Portal', 'Hot Springs', 'Mirror Pond',
    'Cermet Headstone', 'Shimmering Circle', 'Cermet Grate', 'Diary',
    'Gate of Light', 'Gate of Earth', 'Gate of Water', 'Gate of Fire',
    'Qu\'Hau Spring',
}

def is_valid_en_name(n: str | None) -> bool:
    if not n:
        return False
    n = n.strip()
    if n in EN_SKIP or n.upper() in {s.upper() for s in EN_SKIP}:
        return False
    if n in GATE_GUARDS:
        return False
    if re.fullmatch(r'[A-P]-\d{1,2}', n):
        return False
    if re.fullmatch(r'MAP\[\d+\]', n, re.I):
        return False
    if re.fullmatch(r'NM\d+', n) or re.fullmatch(r'Lv\d+', n):
        return False
    if re.fullmatch(r'[A-Z]\d+', n):
        return False
    letters = re.sub(r'[^A-Za-z]', '', n)
    if len(letters) < 2:
        return False
    # 1文字+ハイフン+数字の残り（F-3 など）
    if re.fullmatch(r'[A-P]-\d{1,2}[a-z]?', n):
        return False
    return True

# 時間帯・天候
TW_RE = re.compile(
    r'(?:晴れ|雨|雪|霧|雷|曇り)(?:の時|のとき|ている時|の日)?'
    r'|夜間|夜中|深夜|昼間'
    r'|(?:午後|午前)\s*\d+\s*時'
    r'|\d+\s*時(?:頃|～|〜|\-)\s*\d+\s*時'
    r'|\d{1,2}:\d{2}\s*[～〜~\-]\s*\d{1,2}:\d{2}'
    r'|7:00～23:59'
    r'|ヴァナ(?:時間)?(?:の)?0時'
)

REPORT = []


def log(msg: str) -> None:
    REPORT.append(msg)


def dump(path: Path, obj) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('w', encoding='utf-8') as f:
        json.dump(obj, f, ensure_ascii=False, indent=2, sort_keys=True)
        f.write('\n')


def load_json(path: Path):
    return json.loads(path.read_text(encoding='utf-8'))


def slug(name: str) -> str:
    s = (name or '').replace(' ', '_').replace("'", '').replace(":", '_')
    s = s.replace('.', '_').replace('/', '_')
    s = re.sub(r'_+', '_', s).strip('_')
    return s or 'unnamed'


def load_maps():
    m = load_json(DATA / 'maps.json')
    name_to_ids = defaultdict(set)
    floor_count = defaultdict(int)
    for f in m['floors']:
        zid, name = f.get('zone_id'), f.get('zone_name')
        if name and zid is not None:
            name_to_ids[name].add(zid)
            floor_count[zid] += 1
    # 一意なときだけ zone_id。同名で複数ID（飛空艇航路など）は使わない
    name_to_id = {}
    ambiguous = {}
    for name, ids in name_to_ids.items():
        if len(ids) == 1:
            name_to_id[name] = next(iter(ids))
        else:
            ambiguous[name] = sorted(ids)
    zone_names = sorted(name_to_id.keys(), key=len, reverse=True)
    return name_to_id, floor_count, zone_names, ambiguous


NAME_TO_ID, FLOOR_COUNT, ZONE_NAMES, AMBIGUOUS = load_maps()


def zone_id_of(name: str | None):
    if not name:
        return None
    if name in AMBIGUOUS:
        return None
    return NAME_TO_ID.get(name)


def find_zone_in(text: str | None) -> str | None:
    """本文から既知のゾーン名を最長一致で拾う。無ければ None。"""
    if not text:
        return None
    for name in ZONE_NAMES:
        if name in text:
            return name
    # maps に無いがシートで使われる名前（天の塔）
    if '天の塔' in text:
        return '天の塔'
    return None


def map_info(zone_id, explicit_n, ns=None, zone_name=None):
    """MAP番号。資料の MAP[n]、水の区の南北方針、1枚だけの地図、以外は unknown。"""
    n = explicit_n
    if n is None and zone_name == 'ウィンダス水の区' and ns == 'north':
        n = 1
    if n is None and zone_name == 'ウィンダス水の区' and ns == 'south':
        n = 2
    if n is not None:
        return {'kind': 'number', 'n': int(n)}
    if zone_id is not None and FLOOR_COUNT.get(zone_id) == 1:
        return {'kind': 'single'}
    return {'kind': 'unknown'}


def detect_ns(text: str | None):
    if not text:
        return None
    # 北サンドリア等に反応しないよう、水の区周辺か短い接頭辞だけ
    if re.search(r'(?:北マップ|北側|北部|北・|\(北|（北|^北[(（]|南ではなく北)', text):
        return 'north'
    if re.search(r'(?:南マップ|南側|南部|南・|\(南|（南|^南[(（])', text):
        return 'south'
    # 「水の区（北部）」「水の区(北G-8)」
    if re.search(r'水の区[（(]北', text) or re.search(r'水の区（北部）', text):
        return 'north'
    if re.search(r'水の区[（(]南', text) or re.search(r'水の区（南部）', text):
        return 'south'
    return None


def parse_place(text: str | None, zone_hint: str | None = None) -> dict:
    """座標・MAP・ゾーンを、書いてあるときだけ取る。"""
    text = text or ''
    zone = find_zone_in(text) or zone_hint
    zid = zone_id_of(zone)
    map_n = None
    mm = MAP_RE.search(text)
    if mm:
        map_n = int(mm.group(1))
    grid = None
    tenkey = None
    # より具体的な「南(J-8)」「MAP[1](F-10)」「(G-6#9)」を優先
    # 複数グリッドがある（ランダム候補）ときは、一つに決めない
    grids = GRID_ONLY.findall(text)
    unique_grids = list(dict.fromkeys(f'{a}-{b}' for a, b in grids))
    if len(unique_grids) == 1:
        grid = unique_grids[0]
        tm = re.search(rf'{re.escape(grid)}#(\d+)', text)
        if tm:
            tenkey = tm.group(1)
    elif len(unique_grids) > 1:
        grid = None  # ランダムや複数は埋めない
    ns = detect_ns(text)
    # 水の区で「南(J-8)」のような短い座標欄
    if zone == 'ウィンダス水の区' and ns is None:
        ns = detect_ns(text)
    loc = {
        'zone_name': zone,
        'zone_id': zid,
        'grid': grid,
        'map': map_info(zid, map_n, ns, zone),
    }
    note_parts = []
    if tenkey:
        note_parts.append(f'テンキー{tenkey}')
    if len(unique_grids) > 1:
        note_parts.append('マスは複数')
    return {'loc': loc if (zone or grid or map_n) else None, 'note': '、'.join(note_parts) or None,
            'ns': ns, 'map_n': map_n, 'grids': unique_grids}


def make_location(place: dict | None, zone_hint: str | None = None):
    if not place:
        return None
    loc = place.get('loc') if isinstance(place, dict) and 'loc' in place else place
    if not loc:
        return None
    zone = loc.get('zone_name') or zone_hint
    zid = loc.get('zone_id') if loc.get('zone_id') is not None else zone_id_of(zone)
    grid = loc.get('grid')
    mp = loc.get('map') or map_info(zid, None, None, zone)
    if not zone and not grid:
        return None
    return {
        'grid': grid,
        'map': mp,
        'zone_id': zid,
        'zone_name': zone,
    }


def extract_en_names(text: str | None) -> list[str]:
    if not text:
        return []
    found = []

    def add(n: str):
        n = n.strip()
        if not is_valid_en_name(n):
            return
        if n not in found:
            found.append(n)

    for m in EN_PAREN.finditer(text):
        add(m.group(1))
    for m in EN_TOKEN.finditer(text):
        add(m.group(1))
    return found


def is_guard_field(text: str | None) -> bool:
    if not text:
        return False
    t = text.strip()
    if re.search(r'ゲートハウス|ミッションNPC', t):
        return True
    if re.search(r'ガード', t):
        # 英語の人名が主語ならガードではない（「ガードで受け、Cidに会う」は開始がCid）
        # 開始NPC欄が「ガード」や「ガード（ウィンダス）」だけならガード
        names = extract_en_names(t)
        if not names:
            return True
        # Ambrotien 等のゲートガード名だけなら、開始対象は出さない（専用アイコン側）
        if names and all(n in GATE_GUARDS for n in names):
            return True
    return False


def split_steps(text: str | None) -> list[tuple[int, str]]:
    if not text or not text.strip():
        return []
    text = text.replace('\r\n', '\n').replace('\r', '\n').strip()
    parts = re.split(r'\n(?=\s*\d+\.\s)', text)
    steps = []
    for p in parts:
        m = re.match(r'\s*(\d+)\.\s*(.*)', p, re.S)
        if m:
            steps.append((int(m.group(1)), re.sub(r'\s+', ' ', m.group(2).strip())))
        elif p.strip() and steps:
            n, t = steps[-1]
            steps[-1] = (n, (t + ' ' + p.strip()).strip())
    return steps


def step_type(line: str) -> str:
    # 優先：調べる、トレード、討伐（固有名）、話す（入手があっても）、集める
    if re.search(r'調べ|を読む|まで読む', line):
        if re.search(r'(?:NM|を倒し|を倒す|を討て)', line) and extract_mob_name(line):
            return 'defeat'
        return 'examine'
    if re.search(r'トレード|を渡して|を渡す|に渡し|を渡し|にトレード', line):
        return 'trade'
    if extract_mob_name(line) and re.search(r'を倒|を討て|を討つ', line):
        return 'defeat'
    if re.search(r'話す|話し|話して|受ける|報告|届ける|話を聞く|会話|に会う', line):
        return 'talk'
    if re.search(r'用意|集める|を入手|手に入れる|を集め', line):
        return 'gather'
    return 'talk'


def extract_mob_name(line: str) -> str | None:
    """英語の固有モンスター名だけ。〜族は対象にしない。複数列挙は一つに決めない。"""
    # NM「Magic Sludge」 / NM:Porphyrion
    m = re.search(r'NM[:：]?[「『]([A-Z][A-Za-z0-9\'\-\. ]+)[」』]', line)
    if m:
        return m.group(1).strip()
    m = re.search(r'NM[:：]([A-Z][A-Za-z0-9\'\-\. ]+)', line)
    if m:
        name = m.group(1).strip().rstrip('を')
        if is_valid_en_name(name):
            return name
    # 複数を／や・で列挙している（Amber／Brass／Greater…Quadav）は採らない
    if re.search(r'[／/・].{0,40}(?:Quadav|Orc|Yagudo|Goblin|Bat)', line):
        if line.count('／') + line.count('/') >= 2:
            return None
    m = re.search(
        r'((?:[A-Z][A-Za-z\']+)(?:[ \-][A-Z][A-Za-z\']+)*)を倒',
        line,
    )
    if m:
        name = m.group(1).strip()
        if name not in EN_SKIP and not re.fullmatch(r'[A-P]', name):
            return name
    return None


def extract_obj_name(line: str) -> str | None:
    # Door:House of the Hero / Fountain of Kings / Tome of Magic など、of/the を含む名前
    m = re.search(
        r'((?:Door|Gate)[:：] ?[A-Za-z][A-Za-z0-9\'\-\. ]*[A-Za-z0-9.]'
        r'|(?:Fountain|Tome|Book|Altar|Portal|Statue|House|Chest|Spring|Diary) of (?:the )?[A-Z][A-Za-z\']+)',
        line,
    )
    if m:
        return re.sub(r'\s+', ' ', m.group(1).strip().rstrip('を').rstrip('へ'))
    m = re.search(
        r'(\?\?\?|[A-Z][A-Za-z0-9\'\-\.:]*(?:[ ][A-Z][A-Za-z0-9\'\-\.:]+)*)を(?:再度)?調べ',
        line,
    )
    if m:
        return m.group(1)
    if 'Treasure Chest' in line:
        return 'Treasure Chest'
    if '???' in line and re.search(r'調べ', line):
        return '???'
    for exact in OBJ_EXACT:
        if exact in line and exact != '???':
            return exact
    return None


def extract_npc_from_step(line: str, known: list[str] | None = None) -> str | None:
    known = known or []
    for n in known:
        if n and n in line:
            return n
    # 「のHoratiusに」「Kopuro-Popuroから」「Arnauと」
    m = re.search(
        r'(?:の|で)?([A-Z][A-Za-z0-9\'\-\.:]*(?:[ \'][A-Z][A-Za-z0-9\'\-\.:]+)*)'
        r'(?:に|から|と話|の話)',
        line,
    )
    if m:
        n = m.group(1)
        if is_valid_en_name(n) and n not in GATE_GUARDS:
            return n
    names = extract_en_names(line)
    for n in names:
        if n in OBJ_EXACT or n.startswith('Gate') or n.startswith('Door') or n == '???':
            continue
        if extract_mob_name(line) == n:
            continue
        if n in GATE_GUARDS:
            continue
        if is_valid_en_name(n):
            return n
    return None


def extract_needs(line: str, typ: str) -> list[dict]:
    # 受け取る／入手するものは必要品ではない。渡す・集める側だけ。
    if typ not in ('trade', 'gather'):
        return []
    # 「報酬」を入手 は必要品から外す（引用ごと）
    give = re.sub(
        r'(?:だいじなもの)?[「『][^」』]+[」』]を(?:入手|受け取る|受け取り)|手に入れる',
        '',
        line,
    )
    give = re.split(r'を入手|手に入れる|を受け取', give)[0]
    needs = []
    for m in re.finditer(r'だいじなもの[「『]([^」』]+)[」』]', give):
        needs.append(need_item(m.group(1), 'key_item', 1))
    for m in re.finditer(r'[「『]([^」』]+)[」』]', give):
        name = m.group(1)
        if any(n['name_ja'] == name for n in needs):
            continue
        rest = give[m.end():m.end() + 12]
        prev = give[max(0, m.start() - 8):m.start()]
        cm = re.search(r'を(\d+)\s*(?:個|本|つ|枚|通)', rest)
        if not cm:
            cm = re.search(r'(\d+)\s*(?:個|本|つ|枚|通)の?$', prev)
        count = int(cm.group(1)) if cm else 1
        needs.append(need_item(name, 'item', count))
    return needs


def need_item(name_ja: str, kind: str, count: int) -> dict:
    return {
        'count': count,
        'item_id': None,
        'kind': kind,
        'name_en': None,
        'name_ja': name_ja,
    }


def parse_locks(text: str | None) -> list[dict]:
    if not text or not text.strip():
        return []
    parts = re.split(r'。', text)
    locks = []
    for p in parts:
        p = p.strip()
        if not p:
            continue
        if OK_FAME.match(p):
            continue
        # 「オファーリストに載らない」だけは受けられない理由ではない（発生の仕方）
        # ただし他の条件と一緒なら残す。単独なら出さない
        if p in ('オファーリストに載らない', 'オファーリストには載らない'):
            continue
        if '名声' in p:
            typ = 'fame'
        elif re.search(r'クエスト[「『]', p):
            typ = 'quest'
        elif 'ミッション' in p:
            typ = 'condition'
        else:
            typ = 'condition'
        locks.append({'text_ja': p, 'type': typ})
    return locks


def parse_repeatable(text: str | None, kind: str) -> str:
    if kind == 'mission':
        return 'unknown'
    t = (text or '').strip()
    if t.startswith('可'):
        return 'yes'
    if t.startswith('不可'):
        return 'no'
    return 'no'


def parse_rewards(text: str | None) -> list[dict]:
    if not text or not text.strip():
        return []
    raw = text.strip()
    rewards = []
    rest = raw

    # 称号「A」「B」や 称号「A」、称号「B」
    def take_titles(s):
        out = []
        def repl(m):
            names = re.findall(r'[「『]([^」』]+)[」』]', m.group(0))
            for n in names:
                out.append({'kind': 'title', 'name_ja': n})
            return '\u0000'
        s2 = re.sub(r'称号[「『][^」』]+[」』](?:[「『][^」』]+[」』])*', repl, s)
        return s2, out

    rest, titles = take_titles(rest)
    rewards.extend(titles)

    def take_ki(s):
        out = []
        def repl(m):
            out.append({'kind': 'item', 'name_en': None, 'name_ja': m.group(1)})
            return '\u0000'
        s2 = re.sub(r'だいじなもの[「『]([^」』]+)[」』](?:（所持済みなら無し）)?', repl, s)
        return s2, out

    rest, kis = take_ki(rest)
    rewards.extend(kis)

    # 複雑な分岐は remaining を other にまとめる
    complex_pat = re.compile(
        r'初回|2回目|／|\d+～|ポイント|経験値|ジョブチェンジ|フェイス'
        r'|ランク\d+|契約|クリア数|正解|渡した|選んだ|いずれか'
        r'|Kerutoto|Ohbiru|Kenapa|P:|で\d+G'
    )
    # シンプルなギル
    def take_gil(s):
        out = []
        def repl(m):
            num = m.group(1)
            out.append({'kind': 'gil', 'name_ja': f'{num}ギル'})
            return '\u0000'
        s2 = re.sub(r'([\d,]+)\s*(?:ギル|G)\b', repl, s)
        return s2, out

    if complex_pat.search(rest):
        # ギルだけ取れる単純な先頭／末尾は取る、残りは other
        # ただし「初回：500ギルと…」のような分岐を壊さないよう、丸ごと other
        leftover = re.sub(r'[\u0000、,，\s]+', '、', rest).strip('、,， \t')
        leftover = leftover.replace('\u0000', '').strip('、 ')
        if leftover:
            rewards.append({'kind': 'other', 'name_ja': leftover})
        return [r for r in rewards if r.get('name_ja')]

    rest, gils = take_gil(rest)
    rewards.extend(gils)

    leftover = re.sub(r'[\u0000]+', '、', rest)
    leftover = re.sub(r'[、,，\s]+', '、', leftover).strip('、 ')
    if leftover:
        # 残った固有アイテム名（無臭の腕輪 など）
        for part in leftover.split('、'):
            part = part.strip()
            if part:
                rewards.append({'kind': 'item', 'name_en': None, 'name_ja': part})
    return rewards


def clean_note(text: str | None) -> str | None:
    if not text:
        return None
    t = BOILERPLATE.sub('', text)
    t = re.sub(r'[／/]\s*[／/]', '／', t)
    t = t.strip(' ／/\t')
    return t or None


def naji_grid(name: str, zone: str | None, grid: str | None) -> str | None:
    if name == 'Naji' and zone == '大工房' and not grid:
        return 'J-8'
    return grid


def inherit_grid(loc, target_id, registry):
    """同じゾーンの既知のマスを、手順の空の座標にだけ足す（開始ゾーンの漏れはしない）。"""
    if not loc or not target_id or not registry:
        return loc
    tg = registry.by_id.get(target_id) or {}
    tloc = tg.get('location') or {}
    name = tg.get('name_en')
    zone = loc.get('zone_name')
    grid = naji_grid(name, zone, loc.get('grid'))
    same = False
    if loc.get('zone_id') is not None and tloc.get('zone_id') is not None:
        same = loc['zone_id'] == tloc['zone_id']
    elif zone and tloc.get('zone_name'):
        same = zone == tloc['zone_name']
    if same and not grid and tloc.get('grid'):
        grid = tloc['grid']
    if grid != loc.get('grid'):
        out = dict(loc)
        out['grid'] = grid
        return out
    return loc


# ---------------------------------------------------------------------------
# 対象（NPC / obj / mob）の登録。既存は再利用、中身は変えない。
# ---------------------------------------------------------------------------

class Registry:
    def __init__(self):
        self.by_id = {}
        self.existing_ids = set()
        # (kind, name_en, zone_id or zone_name, grid) → id
        self.index = []

    def load_existing(self, targets: list):
        for t in targets:
            self.by_id[t['id']] = t
            self.existing_ids.add(t['id'])
            loc = t.get('location') or {}
            self.index.append((
                t.get('kind'), t.get('name_en'),
                loc.get('zone_id'), loc.get('zone_name'), loc.get('grid'),
                t['id'],
            ))

    def find(self, kind, name_en, zone_id=None, zone_name=None, grid=None):
        # 完全一致
        for k, n, zid, zn, g, tid in self.index:
            if k == kind and n == name_en:
                if kind == 'mob':
                    # ゾーンが両方あるときだけゾーンも見る。片方空なら名前で再利用
                    if zone_id and zid and zone_id != zid:
                        continue
                    return tid
                # NPC / obj
                if zone_id and zid and zone_id != zid:
                    continue
                if zone_name and zn and zone_name != zn and not zone_id:
                    continue
                # 場所が無いときは、場所付きの既存対象を流用しない（内と外の Gizmo など）
                if kind == 'obj' and not zone_id and not zone_name and (zid or zn):
                    continue
                # ??? はマスが違うと別対象
                if name_en == '???' or kind == 'obj':
                    if grid and g and grid != g:
                        continue
                    if name_en == '???' and grid and not g:
                        continue
                    if name_en == '???' and g and not grid:
                        continue
                # NPC：片方のマスが空なら同一とみなす（同ゾーン）
                if kind == 'npc' and grid and g and grid != g:
                    continue
                return tid
        return None

    def add(self, kind, name_en, location=None, moves=None, same_name=False, file_bucket=None):
        """新規対象を作る。既存があればその ID を返す（中身は触らない）。"""
        loc = location
        zid = loc.get('zone_id') if loc else None
        zn = loc.get('zone_name') if loc else None
        grid = loc.get('grid') if loc else None
        found = self.find(kind, name_en, zid, zn, grid)
        if found:
            return found, False
        # ID
        zpart = zid if zid is not None else (slug(zn) if zn else None)
        name_slug = slug(name_en)
        if kind == 'mob' and zpart is None:
            tid = f'mob.{name_slug}'
        elif kind == 'obj' and name_en == '???' and grid:
            tid = f'obj.{zpart}.{name_slug}_{grid}' if zpart is not None else f'obj.{name_slug}_{grid}'
        elif zpart is not None:
            tid = f'{kind}.{zpart}.{name_slug}'
        else:
            tid = f'{kind}.{name_slug}'
        # 衝突回避
        base = tid
        n = 2
        while tid in self.by_id:
            tid = f'{base}_{n}'
            n += 1
        if moves is None:
            moves = (kind == 'mob')
        tgt = {
            'id': tid,
            'kind': kind,
            'location': loc,
            'moves': bool(moves),
            'name_en': name_en,
            'same_name': bool(same_name),
        }
        self.by_id[tid] = tgt
        self.index.append((kind, name_en, zid, zn, grid, tid))
        return tid, True


def loc_or_none(zone_hint, coord_text, npc_text=None, fill_naji=None):
    # 座標欄を優先、無ければ NPC 欄、ゾーンのヒントは分類から
    p1 = parse_place(coord_text, zone_hint)
    p2 = parse_place(npc_text or '', zone_hint)
    loc = None
    zone = None
    grid = None
    mp = None
    if p1['loc']:
        zone = p1['loc']['zone_name'] or zone_hint
        grid = p1['loc']['grid']
        mp = p1['loc']['map']
    if p2['loc']:
        zone = zone or p2['loc']['zone_name'] or zone_hint
        grid = grid or p2['loc']['grid']
        if not mp or mp.get('kind') == 'unknown':
            mp = p2['loc']['map']
    zone = zone or zone_hint
    zid = zone_id_of(zone)
    if fill_naji:
        grid = naji_grid(fill_naji, zone, grid)
    ns = p1['ns'] or p2['ns']
    map_n = p1['map_n'] or p2['map_n']
    mp = map_info(zid, map_n, ns, zone)
    if not zone and not grid:
        return None, p1['note'] or p2['note']
    return {
        'grid': grid,
        'map': mp,
        'zone_id': zid,
        'zone_name': zone,
    }, (p1['note'] or p2['note'])


def first_en_npc(field: str | None) -> str | None:
    if not field or is_guard_field(field):
        return None
    names = extract_en_names(field)
    for n in names:
        if n.startswith('Door') or n.startswith('Gate') or n == '???':
            continue
        return n
    # 欄がすでに英語だけ
    t = (field or '').strip()
    if re.fullmatch(r'[A-Z][A-Za-z0-9\'\-\.:]*(?:[ \'][A-Z][A-Za-z0-9\'\-\.:]+)*', t):
        return t
    return None


def first_obj_from_start(field: str | None) -> str | None:
    if not field:
        return None
    names = extract_en_names(field)
    for n in names:
        if n.startswith('Door') or n.startswith('Gate') or n == '???':
            return n
    if '???' in field:
        return '???'
    m = re.search(r'((?:Door|Gate)[:：] ?[A-Za-z0-9\'\-\. ]+)', field)
    if m:
        return m.group(1).strip()
    return None


def build_steps(quest_id, raw_steps, start_name, start_id, start_loc, start_kind,
                registry: Registry, zone_hint: str | None, file_targets: list):
    steps = []
    n = len(raw_steps)
    last_qqq = None
    last_named = {}
    if start_id and start_name:
        last_named[start_name] = start_id
    for i, (order, line) in enumerate(raw_steps):
        typ = step_type(line)
        # 手順の場所は本文に書いてあるものだけ。開始エリアを流用しない
        place = parse_place(line, None)
        loc = make_location(place, None)
        note = place['note']
        # 場所のヒントだけ（大聖堂、手の院、民家）でゾーンが取れないとき
        if loc is None:
            # 短い場所メモ
            hint = None
            hm = re.search(
                r'((?:大聖堂|手の院|目の院|耳の院|鼻の院|民家|ゲートハウス|'
                r'見張り塔|大統領執務室|書記官の間|侍女の間)[^\s、。]*)',
                line,
            )
            if hm:
                hint = hm.group(1)
            if hint:
                note = hint if not note else f'{hint}、{note}'

        target = None
        if typ == 'defeat':
            mob = extract_mob_name(line)
            if mob:
                mloc = loc
                # モンスターのマスは書かれていても個体群なので、マスは付けない（ゾーンだけ）
                if mloc:
                    mloc = dict(mloc)
                    mloc['grid'] = None
                tid, created = registry.add('mob', mob, mloc, moves=True)
                target = tid
                if created:
                    file_targets.append(registry.by_id[tid])
                last_named[mob] = tid
        elif typ == 'examine':
            obj = extract_obj_name(line)
            if obj:
                oloc = loc
                no_place = (oloc is None or not (oloc.get('grid') or oloc.get('zone_id') or oloc.get('zone_name')))
                if no_place and obj in last_named:
                    target = last_named[obj]
                    if obj == '???':
                        last_qqq = target
                elif obj == '???' and no_place and last_qqq:
                    target = last_qqq
                else:
                    tid, created = registry.add('obj', obj, oloc, moves=False)
                    target = tid
                    if created:
                        file_targets.append(registry.by_id[tid])
                    last_named[obj] = tid
                    if obj == '???':
                        last_qqq = tid
        else:
            # talk / trade / gather
            npc = extract_npc_from_step(line, [start_name] if start_name else [])
            obj = extract_obj_name(line)
            use_name = npc or obj
            kind = 'npc'
            obj_suffix = ('Fountain', 'Chest', 'Door', 'Circle', 'Spring', 'Tome', 'Portal', 'Seam', 'Riverbed', 'Diary', 'Handle', 'Gizmo', 'Grate')
            if use_name and (use_name in OBJ_EXACT or use_name.startswith('Door') or use_name.startswith('Gate') or use_name == '???' or use_name.endswith(obj_suffix)):
                kind = 'obj'
            if use_name and use_name in GATE_GUARDS:
                use_name = None
            if use_name and kind == 'npc' and not is_valid_en_name(use_name):
                use_name = None
            if use_name:
                nloc = loc
                if start_name and use_name == start_name and start_loc and (
                    nloc is None or (not nloc.get('grid') and start_loc.get('grid'))
                ):
                    nloc = start_loc
                if start_kind == 'obj' and use_name == start_name:
                    kind = 'obj'
                no_place = (nloc is None or not (nloc.get('grid') or nloc.get('zone_id') or nloc.get('zone_name')))
                if no_place and use_name in last_named:
                    target = last_named[use_name]
                else:
                    tid, created = registry.add(kind, use_name, nloc, moves=False)
                    target = tid
                    if created:
                        file_targets.append(registry.by_id[tid])
                    last_named[use_name] = tid
            elif is_guard_field(line) or re.search(r'ガード|ゲートハウス', line):
                target = None

        needs = extract_needs(line, typ)
        tw = None
        tm = TW_RE.search(line)
        if tm:
            # 前後の短い句を拾う
            tw = tm.group(0)
            # 「晴れの時」などはそのまま
        loc = inherit_grid(loc, target, registry)
        sid = f'{quest_id}#s{order:02d}'
        nxt = [f'{quest_id}#s{raw_steps[i+1][0]:02d}'] if i + 1 < n else []
        steps.append({
            'id': sid,
            'location': loc,
            'location_note_ja': note,
            'needs': needs,
            'next': nxt,
            'next_line_ja': line,
            'order': order,
            'target': target,
            'text_ja': None,
            'text_status': 'draft_from_sheet',
            'time_weather_ja': tw,
            'type': typ,
        })
    return steps


def source_of(url: str | None) -> list:
    if not url:
        return []
    return [{'checked': TODAY, 'url': url, 'via': 'sheet'}]


# ---------------------------------------------------------------------------
# メイン
# ---------------------------------------------------------------------------

def load_all_existing():
    manifest = load_json(DATA / 'manifest.json')
    files = {}
    all_quests = []
    all_targets = []
    for rel in manifest['files']:
        if not (rel.startswith('quests/') or rel.startswith('missions/')):
            continue
        path = DATA / rel
        obj = load_json(path)
        files[rel] = obj
        all_quests.extend(obj.get('quests') or [])
        all_targets.extend(obj.get('targets') or [])
    return manifest, files, all_quests, all_targets


def next_ids(existing, kind, category):
    prefix = f'{kind}.{category}.'
    mx = 0
    for q in existing:
        if q['id'].startswith(prefix):
            try:
                mx = max(mx, int(q['id'][len(prefix):]))
            except ValueError:
                pass
    return mx


def should_skip_quest(row) -> str | None:
    ja = (row.get('日本語名') or '').strip()
    en = (row.get('英語名') or '').strip()
    steps = (row.get('ステップ数') or '').strip()
    body = (row.get('手順の要点') or '').strip()
    note = row.get('備考') or ''
    if ja in SKIP_JA:
        return '記事・非クエスト'
    if 'クエストではなく' in note or 'ミッションではなく' in note:
        return '非クエスト'
    if steps in ('', '0') or not body:
        return '手順なし'
    if not en:
        return '英語名なし'
    return None


def process():
    manifest, files, existing_qs, existing_tgts = load_all_existing()
    existing_by_en = {}
    existing_by_mno = {}
    existing_snapshot = {q['id']: deepcopy(q) for q in existing_qs}
    for q in existing_qs:
        existing_by_en[(q['kind'], (q.get('name_en') or '').strip().lower())] = q
        if q.get('mission_no'):
            existing_by_mno[q['mission_no']] = q

    reg = Registry()
    reg.load_existing(existing_tgts)

    # ファイルごとの新規
    new_quests = defaultdict(list)   # rel → list
    new_targets = defaultdict(list)
    skipped = []
    kept = []
    added = []
    warnings = []

    # ---- クエスト ----
    qpath = EXPORT / 'quests_part1.csv'
    with qpath.open(encoding='utf-8') as f:
        qrows = list(csv.DictReader(f))

    next_no = {}
    for cat in ('sandoria', 'bastok', 'windurst'):
        next_no[('quest', cat)] = next_ids(existing_qs, 'quest', cat)

    for row in qrows:
        cls = row.get('分類') or ''
        if cls not in CITY_CLASS:
            continue
        reason = should_skip_quest(row)
        if reason:
            skipped.append((row.get('日本語名'), reason))
            continue
        en = (row['英語名'] or '').strip()
        ja = (row['日本語名'] or '').strip()
        cat, zone_hint = CITY_CLASS[cls]
        key = ('quest', en.lower())
        if key in existing_by_en:
            kept.append(existing_by_en[key]['id'])
            continue
        next_no[('quest', cat)] += 1
        qid = f"quest.{cat}.{next_no[('quest', cat)]:03d}"
        rel = f'quests/{cat}.json'

        npc_field = row.get('依頼NPCと場所') or ''
        coord = row.get('座標') or ''
        raw_steps = split_steps(row.get('手順の要点'))
        if not raw_steps:
            skipped.append((ja, '手順パース失敗'))
            continue
        start_name = first_en_npc(npc_field)
        start_obj = first_obj_from_start(npc_field) if not start_name else None
        start_kind = 'npc'
        if start_obj:
            start_name = start_obj
            start_kind = 'obj'
        # 依頼欄に英語が無いときは、最初の手順から取る（クリルラ→Curilla など）
        if not start_name and not is_guard_field(npc_field):
            start_name = extract_npc_from_step(raw_steps[0][1], [])
            obj = extract_obj_name(raw_steps[0][1])
            if not start_name and obj:
                start_name = obj
                start_kind = 'obj'
            elif start_name in OBJ_EXACT or (start_name and (start_name.startswith('Door') or start_name.startswith('Gate'))):
                start_kind = 'obj'
        fill = start_name if start_name == 'Naji' else None
        start_loc, start_note = loc_or_none(zone_hint, coord, npc_field, fill)
        start_id = None
        if start_name and not is_guard_field(npc_field) and start_name not in GATE_GUARDS:
            start_id, created = reg.add(start_kind, start_name, start_loc, moves=False)
            if created:
                new_targets[rel].append(reg.by_id[start_id])
        file_tgts = new_targets[rel]
        steps = build_steps(
            qid, raw_steps, start_name, start_id, start_loc, start_kind,
            reg, zone_hint, file_tgts,
        )
        # 開始対象が取れ、最初の手順に対象が無ければ開始を付ける
        if start_id and steps and steps[0]['target'] is None and steps[0]['type'] in ('talk', 'trade', 'examine'):
            steps[0]['target'] = start_id
            if steps[0]['location'] is None and start_loc:
                steps[0]['location'] = start_loc

        quest = {
            'category': cat,
            'game_ref': None,
            'id': qid,
            'kind': 'quest',
            'lock_reasons': parse_locks(row.get('受注条件')),
            'name_en': en,
            'name_ja_ref': ja,
            'repeatable': parse_repeatable(row.get('リピート可否'), 'quest'),
            'rewards': parse_rewards(row.get('報酬')),
            'sources': source_of(row.get('用語辞典URL')),
            'start': {'target': start_id},
            'steps': steps,
        }
        new_quests[rel].append(quest)
        added.append(qid)
        if not start_id:
            warnings.append(f'{qid} {ja}: 開始NPCを取れず')
        if start_note:
            warnings.append(f'{qid}: {start_note}')

    # ---- ミッション ----
    mpath = EXPORT / 'missions_part1.csv'
    with mpath.open(encoding='utf-8') as f:
        mrows = list(csv.DictReader(f))

    for cat in ('sandoria', 'bastok', 'windurst'):
        next_no[('mission', cat)] = next_ids(existing_qs, 'mission', cat)

    for row in mrows:
        cls = row.get('シナリオ(拡張/国)') or ''
        if cls not in MISSION_CLASS:
            continue
        en = (row.get('英語名') or '').strip()
        ja = (row.get('日本語名') or '').strip()
        mno = (row.get('ミッション番号') or '').strip()
        body = (row.get('手順の要点') or '').strip()
        if not body or not en or not mno:
            skipped.append((ja or mno, '手順または英語名なし'))
            continue
        cat = MISSION_CLASS[cls]
        if mno in existing_by_mno:
            kept.append(existing_by_mno[mno]['id'])
            continue
        key = ('mission', en.lower())
        if key in existing_by_en:
            kept.append(existing_by_en[key]['id'])
            continue
        next_no[('mission', cat)] += 1
        qid = f"mission.{cat}.{next_no[('mission', cat)]:03d}"
        rel = f'missions/{cat}.json'

        npc_field = row.get('開始NPCと場所') or ''
        coord = row.get('座標') or ''
        zone_hint = None
        raw_steps = split_steps(body)
        if not raw_steps:
            skipped.append((ja, '手順パース失敗'))
            continue
        start_name = None if is_guard_field(npc_field) else first_en_npc(npc_field)
        start_obj = first_obj_from_start(npc_field) if not start_name and not is_guard_field(npc_field) else None
        start_kind = 'npc'
        if start_obj:
            start_name = start_obj
            start_kind = 'obj'
        if not start_name and not is_guard_field(npc_field):
            start_name = extract_npc_from_step(raw_steps[0][1], [])
            obj = extract_obj_name(raw_steps[0][1])
            if not start_name and obj:
                start_name = obj
                start_kind = 'obj'
        fill = start_name if start_name == 'Naji' else None
        p = parse_place(coord or npc_field, None)
        zone_hint = (p['loc'] or {}).get('zone_name') if p['loc'] else find_zone_in(npc_field)
        start_loc, start_note = loc_or_none(zone_hint, coord, npc_field, fill)
        start_id = None
        if start_name and not is_guard_field(npc_field) and start_name not in GATE_GUARDS:
            start_id, created = reg.add(start_kind, start_name, start_loc, moves=False)
            if created:
                new_targets[rel].append(reg.by_id[start_id])
        file_tgts = new_targets[rel]
        steps = build_steps(
            qid, raw_steps, start_name, start_id, start_loc, start_kind,
            reg, zone_hint, file_tgts,
        )
        if start_id and steps and steps[0]['target'] is None and steps[0]['type'] in ('talk', 'trade', 'examine'):
            steps[0]['target'] = start_id
            if steps[0]['location'] is None and start_loc:
                steps[0]['location'] = start_loc

        note = clean_note(row.get('備考'))
        quest = {
            'category': cat,
            'game_ref': None,
            'id': qid,
            'kind': 'mission',
            'lock_reasons': parse_locks(row.get('受注条件')),
            'mission_no': mno,
            'name_en': en,
            'name_ja_ref': ja,
            'note_ja': note,
            'repeatable': 'unknown',
            'rewards': parse_rewards(row.get('報酬')),
            'sources': source_of(row.get('用語辞典URL')),
            'start': {'target': start_id},
            'steps': steps,
        }
        new_quests[rel].append(quest)
        added.append(qid)
        if not start_id and not is_guard_field(npc_field):
            warnings.append(f'{qid} {ja}: 開始NPCを取れず（ガード以外）')

    # ---- 書き出し（既存は中身そのまま、後ろに新規） ----
    for rel, obj in files.items():
        qs = list(obj['quests'])
        tgs = list(obj['targets'])
        seen_t = {t['id'] for t in tgs}
        for q in new_quests.get(rel, []):
            qs.append(q)
        for t in new_targets.get(rel, []):
            if t['id'] not in seen_t and t['id'] not in reg.existing_ids:
                tgs.append(t)
                seen_t.add(t['id'])
        obj = {'data_schema': 1, 'quests': qs, 'targets': tgs}
        dump(DATA / rel, obj)

    # 既存が壊れていないか
    _, _, after_qs, _ = load_all_existing()
    after_by_id = {q['id']: q for q in after_qs}
    for qid, before in existing_snapshot.items():
        after = after_by_id.get(qid)
        if after != before:
            # JSON 再読込でキー順が変わるだけなら値は同じはず。deepcopy 比較
            raise SystemExit(f'既存エントリが変わった: {qid}')

    # zones.json：使ったゾーンで、maps にあり未収録のものを足す
    zones_obj = load_json(DATA / 'zones.json')
    have = {z['zone_id'] for z in zones_obj['zones'] if z.get('zone_id') is not None}
    used = set()
    for q in after_qs:
        for s in q.get('steps') or []:
            loc = s.get('location')
            if loc and loc.get('zone_id') is not None:
                used.add((loc['zone_id'], loc.get('zone_name')))
        st = q.get('start') or {}
        # start target location
    # 全 targets から
    for rel, obj in files.items():
        obj = load_json(DATA / rel)
        for t in obj.get('targets') or []:
            loc = t.get('location') or {}
            if loc.get('zone_id') is not None:
                used.add((loc['zone_id'], loc.get('zone_name')))
    added_zones = []
    for zid, zn in sorted(used, key=lambda x: x[0]):
        if zid not in have and zid in FLOOR_COUNT:
            zones_obj['zones'].append({
                'checked': False,
                'maps': 'unknown',
                'zone_id': zid,
                'zone_name': zn or None,
            })
            have.add(zid)
            added_zones.append((zid, zn))
    zones_obj['zones'].sort(key=lambda z: (z.get('zone_id') is None, z.get('zone_id') or 0))
    dump(DATA / 'zones.json', zones_obj)

    # manifest
    nq = sum(1 for q in after_qs if q['kind'] == 'quest')
    nm = sum(1 for q in after_qs if q['kind'] == 'mission')
    manifest['data_version'] = DATA_VERSION
    manifest['built'] = TODAY
    manifest['scope'] = (
        f'公式本編の三国クエストと三国ミッション（クエスト{nq}件・ミッション{nm}件）。'
        'CatsEye独自は含めない。手順の文はシートの要点（下書き）。'
        '書いていない座標・MAPは埋め込んでいない。'
    )
    manifest['source']['read_on'] = TODAY
    dump(DATA / 'manifest.json', manifest)

    # レポート
    lines = []
    lines.append(f'data_version {DATA_VERSION}')
    lines.append(f'kept existing {len(kept)}: {kept}')
    lines.append(f'added {len(added)}')
    by_cat = defaultdict(int)
    for qid in added:
        by_cat[qid.rsplit('.', 1)[0]] += 1
    for k, v in sorted(by_cat.items()):
        lines.append(f'  {k}: {v}')
    lines.append(f'total quests {nq}, missions {nm}')
    lines.append(f'skipped {len(skipped)}:')
    for ja, r in skipped:
        lines.append(f'  - {ja}: {r}')
    lines.append(f'zones added {added_zones}')
    lines.append(f'warnings ({len(warnings)}):')
    for w in warnings:
        lines.append(f'  - {w}')
    # 開始対象の取れなかった新規
    no_start = [qid for qid in added if after_by_id[qid].get('start', {}).get('target') is None]
    # ミッションのガード開始は正常
    lines.append(f'no start target: {len(no_start)}')
    for qid in no_start:
        q = after_by_id[qid]
        lines.append(f'  - {qid} {q["name_ja_ref"]} ({q["kind"]})')
    report = '\n'.join(lines) + '\n'
    (EXPORT / 'import_report.txt').write_text(report, encoding='utf-8')
    print(report)
    return 0


if __name__ == '__main__':
    sys.exit(process())
