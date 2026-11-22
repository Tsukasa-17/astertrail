# 読むだけ：クライアントの RoE DAT（en 55672）から、名前のあるレコードの番号と英語名を JSON で出す
import os, struct, json, sys
BASE = r'C:\Games\CatsEyeXI\catseyexi-client\Game\FINAL FANTASY XI'
FID = int(sys.argv[1]) if len(sys.argv) > 1 else 55672
DEC = bytes(((b >> 5) | ((b & 31) << 3)) for b in range(256))
def path_of(fid):
    for n in range(1, 10):
        vt = os.path.join(BASE, 'VTABLE.DAT' if n == 1 else 'ROM%d\\VTABLE%d.DAT' % (n, n))
        ft = os.path.join(BASE, 'FTABLE.DAT' if n == 1 else 'ROM%d\\FTABLE%d.DAT' % (n, n))
        with open(vt, 'rb') as f:
            f.seek(fid); b = f.read(1)
        if b and b[0] == n:
            with open(ft, 'rb') as f:
                f.seek(fid * 2); v = struct.unpack('<H', f.read(2))[0]
            rom = 'ROM' if n == 1 else 'ROM%d' % n
            return os.path.join(BASE, rom, str(v >> 7), '%d.DAT' % (v & 0x7F))
    return None
p = path_of(FID)
raw = open(p, 'rb').read()
d = raw.translate(DEC)
def u32(pos): return struct.unpack_from('<I', d, pos)[0]
def i32(pos): return struct.unpack_from('<i', d, pos)[0]
S = None
for s in (0x1400, 0xC00):
    if len(raw) >= s and len(raw) % s == 0 and raw[s - 1] == 0xFF: S = s; break
def cells(base, limit, want):
    n = i32(base)
    if n < 1 or n > 32 or base + 4 + n * 8 > limit: return None
    out = []
    for i in range(min(n, want)):
        off = i32(base + 4 + i * 8); typ = i32(base + 8 + i * 8)
        if off < 4 + n * 8 or base + off >= limit: return None
        q = base + off
        if typ == 1: out.append(i32(q))
        elif typ == 0:
            if i32(q) != 1: return None
            st = q + 28; e = d.find(b'\0', st)
            if e < 0 or e > limit: return None
            out.append(d[st:e].decode('latin-1'))
        else: return None
    return out
res = {}
toff = None
for slot in range(len(raw) // S):
    b = slot * S; lim = b + S
    rid = u32(b) % 4096
    c = None
    for off in ([toff] if toff else [32, 28]):
        c = cells(b + off, lim, 5)
        if c and isinstance(c[0], str): toff = off; break
        c = None
    if rid > 0 and c and isinstance(c[0], str) and c[0] not in ('', '.'):
        res[rid] = {'name': c[0], 'rep': u32(b + 8) == 1}
print(json.dumps({'path': p, 'slot': S, 'count': len(res), 'recs': res}))
