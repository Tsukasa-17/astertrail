"""
Astertrail - LSB の scripts/globals/roe_records.lua を読む小道具（0.1.294〜）。
Lua のコメント（-- と --[[ ]]）を先に外してから、xi.roe.records の [番号] = { … } を拾う。
（0.1.293 はコメントを外さずに読んでいたので、コメントアウトされた 490・726・3690 も載っていた）
"""
import re


def strip_comments(src):
    out = []
    i, n = 0, len(src)
    while i < n:
        if src.startswith('--', i):
            m = re.match(r'--\[(=*)\[', src[i:])
            if m:
                close = ']' + m.group(1) + ']'
                j = src.find(close, i + m.end())
                i = n if j < 0 else j + len(close)
                continue
            j = src.find('\n', i)
            i = n if j < 0 else j
            continue
        c = src[i]
        if c in '"\'':
            j = i + 1
            while j < n and src[j] != c:
                if src[j] == '\\':
                    j += 1
                j += 1
            out.append(src[i:j + 1])
            i = j + 1
            continue
        out.append(c)
        i += 1
    return ''.join(out)


def records(src):
    """戻り値: { 番号: 本体の文字 }（コメントを外したあと）"""
    s = strip_comments(src)
    parts = re.split(r'\n\s*\[(\d+)\]\s*=\s*\n', s)
    out = {}
    for i in range(1, len(parts), 2):
        out[int(parts[i])] = parts[i + 1]
    return out


def flags_of(body):
    m = re.search(r'flags\s*=\s*set\s*\{([^}]*)\}', body)
    return set(re.findall(r"'(\w+)'", m.group(1))) if m else set()
