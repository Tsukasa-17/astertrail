#!/usr/bin/env python3
"""
ゲームの地図が無いゾーンの地図を、ゾーン DAT から出した床・壁の形で描く（0.1.323〜、t911）。開発用。ゲームには不要。

入力: dev/sources/heavens_tower_242.json（GAME-PC の Lua でゾーン DAT を読んで出した、床のマスと層の高さ。
      屋根や外の面を外した「その層の床」の範囲として使う）
      dev/sources/heavens_tower_242_tris.json.gz（同じく読んだ当たり判定の三角形。0.1.324〜。床と壁の形はこれを描く）
出力:
  assets/maps/z242_<n>.png    1024×1024 の地図画像（0.1.324〜。自分で描いたもの。ほかの地図画像は使わない）。
                              4 倍の大きさで描いて縮めるので、線のふちはなめらか。座標は 512 基準のまま（画像の大きさに関係しない）
  data/maps.json              そのゾーンの floors を入れ替える（scale・offset はゲームの地図と同じ式）

見た目は FFXI Database の地図の印象（薄い茶色の地・白い床・茶色の細い線・縁の A〜O と 1〜15）を参考に、
線と色はここで決めて描いている。画像もコードも写していない。
dev/build_maps.py も最後にこれを呼ぶので、作り直しても消えない。
"""
import glob, json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, '..'))
SOURCES = [os.path.join(HERE, 'sources', 'heavens_tower_242.json')]
# 当たり判定の三角形（0.1.324〜。床と壁の形をそのまま描くため。GAME-PC の Lua でゾーン DAT から読んだもの）
TRIS = os.path.join(HERE, 'sources', 'heavens_tower_242_tris.json.gz')

A = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
BASE, MARGIN, CELL, COLS, ROWS = 512, 16, 32, 15, 15

# 色（自分で決めたもの）
BG = (236, 216, 178)        # 地
FRAME = (222, 196, 150)     # 縁の帯
FRAME_LINE = (122, 86, 38)  # 縁の線
GRID = (204, 176, 128)      # マス線
SHADOW = (186, 150, 98)     # 塔の外形の線（すべての層を重ねた形）
FLOOR = (253, 251, 246)     # 床
EDGE = (140, 96, 40)        # 床のふち
WALL = (150, 108, 52)       # 床の上の壁
TEXT = (96, 64, 26)         # 縁の文字


def load(path):
    with open(path, encoding='utf-8') as f:
        return json.load(f)


def decode(part, n):
    head, body = part.split(':', 1)
    name = head[:head.index('@')]
    y0 = int(head[head.index('@') + 1:head.index('#')])
    want = int(head[head.index('#') + 1:])
    m = [[0] * n for _ in range(n)]
    total = 0
    for r, row in enumerate(body.split(',') if body else []):
        y = y0 + r
        x, cur, i = 0, 0, 0
        while i < len(row):
            if row[i] == 'Z' and i + 1 < len(row) and row[i + 1] == '0':
                run, i = 61, i + 2
                if cur:
                    for k in range(run): m[y][x + k] = 1
                x += run
                continue
            run = A.index(row[i]); i += 1
            if cur:
                for k in range(run): m[y][x + k] = 1
            x += run
            cur ^= 1
        total += sum(m[y])
    if total != want:
        raise SystemExit('checksum mismatch in ' + name)
    return name, m


def masks(src):
    n = src['grid']['n']
    floors, walls = {}, {}
    for p in src['floors']:
        name, m = decode(p, n)
        floors[int(name[1:])] = m
    for p in src['walls']:
        name, m = decode(p, n)
        walls[int(name[1:])] = m
    return floors, walls


OUT = 1024                  # 画像の大きさ（0.1.324〜。前は 512）。座標は 512 基準のまま、画像は 2 倍の細かさ
SS = 4                      # 描くときはさらに 4 倍で描いて縮める（線のふちをなめらかに）


def _gauss(a, sigma):
    """2 次元のぼかし（numpy だけ。縦と横に分けて畳み込む）"""
    import numpy as np
    r = max(1, int(sigma * 3 + 0.5))
    x = np.arange(-r, r + 1, dtype=np.float32)
    k = np.exp(-(x * x) / (2 * sigma * sigma)); k /= k.sum()
    p = np.pad(a, r, mode='edge')
    t = np.zeros((p.shape[0], a.shape[1]), dtype=np.float32)
    for i, v in enumerate(k):
        t += v * p[:, i:i + a.shape[1]]
    o = np.zeros(a.shape, dtype=np.float32)
    for i, v in enumerate(k):
        o += v * t[i:i + a.shape[0], :]
    return o


def _smooth(m, n_out, sigma, cut):
    """マス（0/1）をぼかしてから大きくし、しきい値で切る。角の段々が消えて、なめらかな形になる"""
    import numpy as np
    from PIL import Image
    a = _gauss(np.array(m, dtype=np.float32), sigma)
    big = np.array(Image.fromarray(a, mode='F').resize((n_out, n_out), Image.BICUBIC))
    return big >= cut


def _grow(mask, px):
    """mask を px だけ太らせる（丸い形で。px は小さい数）"""
    import numpy as np
    out = mask.copy()
    r = int(px)
    for dy in range(-r, r + 1):
        for dx in range(-r, r + 1):
            if dx * dx + dy * dy <= px * px and (dx or dy):
                out[max(0, dy):mask.shape[0] + min(0, dy), max(0, dx):mask.shape[1] + min(0, dx)] |= \
                    mask[max(0, -dy):mask.shape[0] + min(0, -dy), max(0, -dx):mask.shape[1] + min(0, -dx)]
    return out


# 地形の色（0.1.324〜。自分で決めたもの）
FLOOR_HI = (255, 252, 244)   # 床：その層でいちばん高い所
FLOOR_LO = (226, 212, 184)   # 床：その層でいちばん低い所（高さで濃淡）
SLOPE_LINE = (176, 140, 92)  # 坂・階段の段の線（高さ 0.5 yalm ごと）
BODY = (228, 208, 172)       # 塔の中で、この層では歩けない所
BODY_HATCH = (214, 190, 150) # その斜線
WATER = (160, 204, 232)      # 水
WATER_EDGE = (86, 138, 182)  # 水のふち
STEP = (176, 134, 80)        # 床どうしの段差・低い壁


def load_tris(path=TRIS):
    """ゾーン DAT の当たり判定の三角形（1/20 yalm の整数、頂点ごとに x, h, y。h は + が下）と、水の面"""
    import gzip
    import numpy as np
    with gzip.open(path, 'rb') as f:
        doc = json.loads(f.read().decode('utf-8'))
    P = np.array(doc['tris'], dtype=np.float64).reshape(-1, 3, 3) / 20.0
    u, v = P[:, 1] - P[:, 0], P[:, 2] - P[:, 0]
    n = np.cross(u, v)
    ln = np.linalg.norm(n, axis=1)
    up = np.abs(n[:, 1]) / np.maximum(ln, 1e-9)
    Wt = np.array(doc.get('flag_2006', []), dtype=np.float64).reshape(-1, 3, 3) / 20.0
    return {'P': P, 'ok': ln > 1e-6, 'up': up, 'water': Wt}


def _to_px(src, P, N):
    g = src['grid']
    s = g['scale'] * 0.2
    k = N / BASE
    return (P[:, :, 0] * s - g['offset_x']) * k, (-P[:, :, 2] * s - g['offset_y']) * k


def _floor_sel(src, T, floors, map_n, px, py, k):
    import numpy as np
    g = src['grid']
    P = T['P']
    h = P[:, :, 1]
    L = [l for l in src['layers'] if l['map_n'] == map_n][0]
    # 床は、DAT で床とした所（floors のマス、少し広げる）にあって、高さがその層に入る三角形だけ
    m = np.array(floors[map_n], dtype=bool)
    def grow(a, n):
        for _ in range(n):
            q = a.copy(); q[1:] |= a[:-1]; q[:-1] |= a[1:]; q[:, 1:] |= a[:, :-1]; q[:, :-1] |= a[:, 1:]; a = q
        return a
    m1, m2 = grow(m, 2), grow(m, 8)
    cell = BASE / g['n']
    cx = np.clip((px.mean(1) / k // cell).astype(int), 0, g['n'] - 1)
    cy = np.clip((py.mean(1) / k // cell).astype(int), 0, g['n'] - 1)
    hmin, hmax = h.min(1), h.max(1)
    inb = (hmax >= L['h_min']) & (hmin < L['h_max'])
    # 坂（傾いた床）は層の境をまたぐので、床のマスから少し離れていても、高さが入れば描く
    slope = (hmax - hmin) > 0.05
    return np.where(T['ok'] & (T['up'] > 0.7) & inb & (m1[cy, cx] | (slope & m2[cy, cx])))[0], L


def _height_map(px, py, h, sel, N):
    """選んだ三角形の高さを N×N に（重なれば上の面。+ が下なので小さいほう）。坂かどうかも"""
    import numpy as np
    H = np.full((N, N), np.inf, dtype=np.float32)
    S = np.zeros((N, N), dtype=bool)
    for i in sel:
        x, y, z = px[i], py[i], h[i]
        x0, x1 = int(max(0, np.floor(x.min()))), int(min(N - 1, np.ceil(x.max())))
        y0, y1 = int(max(0, np.floor(y.min()))), int(min(N - 1, np.ceil(y.max())))
        if x1 < x0 or y1 < y0:
            continue
        gx, gy = np.meshgrid(np.arange(x0, x1 + 1) + 0.5, np.arange(y0, y1 + 1) + 0.5)
        d = (y[1] - y[2]) * (x[0] - x[2]) + (x[2] - x[1]) * (y[0] - y[2])
        if abs(d) < 1e-9:
            continue
        a = ((y[1] - y[2]) * (gx - x[2]) + (x[2] - x[1]) * (gy - y[2])) / d
        b = ((y[2] - y[0]) * (gx - x[2]) + (x[0] - x[2]) * (gy - y[2])) / d
        c = 1 - a - b
        e = -0.02
        inside = (a >= e) & (b >= e) & (c >= e)
        if not inside.any():
            continue
        hz = a * z[0] + b * z[1] + c * z[2]
        sub = H[y0:y1 + 1, x0:x1 + 1]
        put = inside & (hz < sub)
        sub[put] = hz[put]
        if z.max() - z.min() > 0.05:
            S[y0:y1 + 1, x0:x1 + 1][put] = True
        else:
            S[y0:y1 + 1, x0:x1 + 1][put] = False
    return H, S


def _layer_shapes(src, T, floors, map_n, N):
    """その層の床の形（三角形を塗る）と、壁・段の線（三角形のふちを線で）を N×N で描いた形"""
    import numpy as np
    from PIL import Image, ImageDraw
    k = N / BASE
    px, py = _to_px(src, T['P'], N)
    h = T['P'][:, :, 1]
    fsel, L = _floor_sel(src, T, floors, map_n, px, py, k)
    fim = Image.new('L', (N, N), 0)
    d = ImageDraw.Draw(fim)
    for i in fsel:
        d.polygon([(px[i, j], py[i, j]) for j in range(3)], fill=255)
    f = np.array(fim) > 0
    f = ~_grow(~_grow(f, 2), 2)
    hmin, hmax = h.min(1), h.max(1)
    wsel = np.where(T['ok'] & (T['up'] < 0.3) & (hmax > L['h_min'] - 3) & (hmin < L['h_max']))[0]
    wim = Image.new('L', (N, N), 0)
    d = ImageDraw.Draw(wim)
    lw = max(1, int(round(SS * 0.9)))
    for i in wsel:
        pts = [(px[i, j], py[i, j]) for j in range(3)]
        d.line(pts + [pts[0]], fill=255, width=lw)
    return f, np.array(wim) > 0, (px, py, h, fsel, L)


def band_of(src, n):
    """DAT の高さの層（band、dev/sources の layers）"""
    return [l for l in src['layers'] if l['map_n'] == n][0]


def pages(src):
    """地図のページ。src['pages'] が無ければ、層 1 つで 1 枚"""
    out = []
    for p in src.get('pages') or [{'map_n': l['map_n'], 'bands': [l['map_n']]} for l in src['layers']]:
        bs = [band_of(src, b) for b in p['bands']]
        q = dict(p)
        q['h_min'] = min(b['h_min'] for b in bs)
        q['h_max'] = max(b['h_max'] for b in bs)
        out.append(q)
    return out


def page_of(src, map_n):
    return [p for p in pages(src) if p['map_n'] == map_n][0]


def _hatch(N, step, width):
    import numpy as np
    yy, xx = np.mgrid[0:N, 0:N]
    return ((xx + yy) % step) < width


def render(src, floors, walls, map_n, out_path, T=None):
    """地形が分かる地図（0.1.324〜）：床は高さで濃淡、坂・階段は段の線、水は青、塔の中の歩けない所は斜線"""
    import numpy as np
    from PIL import Image, ImageDraw, ImageFont
    T = T or load_tris()
    N = OUT * SS                # 描く大きさ
    k = N / BASE                # 512 基準の 1px が何 px か
    # 1 枚の地図（ページ）は、DAT の高さの層（band）を 1 つ以上重ねたもの（0.1.324〜：天の塔は 4 枚）。
    # 重なる所は主な層を見せ、その下・上にあるほかの層の線は隠す
    page = page_of(src, map_n)
    f = np.zeros((N, N), dtype=bool)
    w = np.zeros((N, N), dtype=bool)
    H = np.full((N, N), np.inf, dtype=np.float32)
    S = np.zeros((N, N), dtype=bool)
    # 重なる所は、そのページの主な層（bands の先頭。NPC のいる床）を上に見せる。ほかの層は、主な層の床が無い所（階段・通路）だけ
    main = page['bands'][0]
    bands = [b for b in page['bands'] if b != main] + [main]
    for b in bands:
        fb, wb, (px, py, h, fsel, L) = _layer_shapes(src, T, floors, b, N)
        Hb, Sb = _height_map(px, py, h, fsel, N)
        Hb[~fb] = np.inf
        w &= ~fb            # 上に床がある所の、下の層の線は隠す
        w |= wb
        top = np.isfinite(Hb) if b == main else (Hb < H)
        H = np.where(top, Hb, H)
        S = np.where(top, Sb, S)
        f |= fb
    L = {'h_min': page['h_min'], 'h_max': page['h_max']}
    # 上の床のふち（下の層の上に張り出した所）：となりと 2 yalm 以上の高さの差
    gap = np.zeros((N, N), dtype=bool)
    Hf = np.where(np.isfinite(H), H, np.nan)
    with np.errstate(invalid='ignore'):
        dx = np.abs(Hf[:, 1:] - Hf[:, :-1]) > 2.0
        dy = np.abs(Hf[1:, :] - Hf[:-1, :]) > 2.0
    gap[:, 1:] |= dx; gap[1:, :] |= dy
    gap = _grow(gap, SS * 0.7)
    # 塔の中で歩けない所：この層の床に囲まれた所（外へつながらない所）だけ。ほかの層の形は出さない
    q = N // 4
    small = np.array(Image.fromarray(f.astype('uint8') * 255).resize((q, q), Image.BILINEAR)) >= 64
    small = _grow(small, 3)
    from PIL import ImageDraw as _D
    fl = Image.fromarray((~small).astype('uint8') * 255).convert('L').copy()   # numpy から作った画像は floodfill が効かないので写す
    _D.floodfill(fl, (0, 0), 128)
    body = (np.array(fl) == 255) | small
    body = np.array(Image.fromarray(body.astype('uint8') * 255).resize((N, N), Image.BILINEAR)) >= 128
    im = np.zeros((N, N, 3), dtype=np.uint8)
    im[:] = BG
    # マス線（細く、塔の外だけ）
    lw = max(1, int(SS * 1.0))
    grid = np.zeros((N, N), dtype=bool)
    for i in range(COLS + 1):
        g = int(round((MARGIN + i * CELL) * k))
        grid[:, g - lw // 2:g - lw // 2 + lw] = True
        grid[g - lw // 2:g - lw // 2 + lw, :] = True
    im[grid & ~body & ~f] = GRID
    # 塔の中で、この層では歩けない所（斜線）
    nb = body & ~f
    im[nb] = BODY
    im[nb & _hatch(N, int(SS * 7), int(SS * 1.2))] = BODY_HATCH
    # 床：高さで濃淡（高い所ほど白く）
    hv = H[f & np.isfinite(H)]
    lo, hi = (float(hv.max()), float(hv.min())) if hv.size else (1.0, 0.0)   # + が下：lo は低い所
    span = max(1.0, lo - hi)
    t = np.clip(np.where(np.isfinite(H), (H - hi) / span, 0.5), 0, 1)[..., None]
    col = (np.array(FLOOR_HI) * (1 - t) + np.array(FLOOR_LO) * t).astype(np.uint8)
    im[f] = col[f]
    # 坂・階段：高さ 0.5 yalm ごとの線（段の向きが分かる）
    q = np.floor(np.where(np.isfinite(H), H, 0) / 0.5)
    ed = np.zeros((N, N), dtype=bool)
    ed[:, 1:] |= (q[:, 1:] != q[:, :-1]) & S[:, 1:] & S[:, :-1]
    ed[1:, :] |= (q[1:, :] != q[:-1, :]) & S[1:, :] & S[:-1, :]
    ed = _grow(ed, SS * 0.4)
    im[ed & f] = SLOPE_LINE
    # 水（DAT の面の印。flag_2006_ja を参照）
    if len(T['water']):
        wx, wy = _to_px(src, T['water'], N)
        wh = T['water'][:, :, 1]
        wim = Image.new('L', (N, N), 0)
        d = ImageDraw.Draw(wim)
        for i in range(len(wx)):
            if L['h_min'] <= wh[i].mean() < L['h_max']:
                d.polygon([(wx[i, j], wy[i, j]) for j in range(3)], fill=255)
        wm = np.array(wim) > 0
        if wm.any():
            wm = ~_grow(~_grow(wm, 3), 3)
            im[wm] = WATER
            wedge = wm & ~(~_grow(~wm, SS * 1.0))
            im[wedge] = WATER_EDGE
    # 床どうしの段差・低い壁（床の中だけ、細く）
    near = _grow(f, SS * 1.5)
    im[w & near] = STEP
    im[gap & f] = EDGE
    # 床のふち（歩ける所の外側。濃い線）
    outer = _grow(f, SS * 1.4)
    im[outer & ~f] = EDGE
    img = Image.fromarray(im).resize((OUT, OUT), Image.LANCZOS)
    d = ImageDraw.Draw(img)
    s = OUT / BASE
    M = MARGIN * s
    # 縁の帯と文字（A〜O・1〜15）
    d.rectangle((0, 0, OUT - 1, M - 1), fill=FRAME)
    d.rectangle((0, OUT - M, OUT - 1, OUT - 1), fill=FRAME)
    d.rectangle((0, 0, M - 1, OUT - 1), fill=FRAME)
    d.rectangle((OUT - M, 0, OUT - 1, OUT - 1), fill=FRAME)
    d.rectangle((0, 0, OUT - 1, OUT - 1), outline=FRAME_LINE, width=2)
    d.rectangle((M - 1, M - 1, OUT - M, OUT - M), outline=FRAME_LINE, width=2)
    font = None
    for p in ('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'):
        if os.path.exists(p):
            font = ImageFont.truetype(p, int(10 * s))
            break
    if font is None:
        font = ImageFont.load_default()
    def label(cx, cy, t):
        b = d.textbbox((0, 0), t, font=font)
        d.text((cx - (b[2] - b[0]) / 2 - b[0], cy - (b[3] - b[1]) / 2 - b[1]), t, fill=TEXT, font=font)
    for i in range(COLS):
        cx = (MARGIN + i * CELL + CELL / 2) * s
        ch = chr(ord('A') + i)
        label(cx, M / 2, ch)
        label(cx, OUT - M / 2, ch)
        g = (MARGIN + i * CELL) * s
        d.line((g, 0, g, 6), fill=FRAME_LINE, width=2); d.line((g, OUT - 7, g, OUT - 1), fill=FRAME_LINE, width=2)
    for i in range(ROWS):
        cy = (MARGIN + i * CELL + CELL / 2) * s
        label(M / 2, cy, str(i + 1))
        label(OUT - M / 2, cy, str(i + 1))
        g = (MARGIN + i * CELL) * s
        d.line((0, g, 6, g), fill=FRAME_LINE, width=2); d.line((OUT - 7, g, OUT - 1, g), fill=FRAME_LINE, width=2)
    # 色数をしぼって軽くする（にじみの中間色は残す。ディザはかけない）
    pimg = img.quantize(colors=192, method=Image.MEDIANCUT, dither=Image.Dither.NONE)
    pimg.save(out_path, optimize=True)
    return out_path


def floor_rows(src):
    g = src['grid']
    out = []
    for L in pages(src):
        n = L['map_n']
        out.append({
            'zone_id': src['zone_id'], 'zone_name': src['zone_name'],
            'floor_index': n, 'floor_id': 0, 'status': 'dat_made',
            'scale': g['scale'], 'offset_x': g['offset_x'], 'offset_y': g['offset_y'],
            'file_id': None, 'map_n': n,
            'image': 'assets/maps/z%d_%d.png' % (src['zone_id'], n),
            'h_min': L['h_min'], 'h_max': L['h_max'],
            **({'level': L['level']} if L.get('level') else {}),
            **({'bands_ja': L['bands_ja']} if L.get('bands_ja') else {}),
            'note': 'ゲームの地図が無いエリア。ゾーン DAT から描いた地図。層は高さで決める（FloorId はどこも 0）。',
        })
    return out


def merge_maps(doc):
    for path in SOURCES:
        src = load(path)
        z = src['zone_id']
        doc['floors'] = [f for f in doc['floors'] if f.get('zone_id') != z] + floor_rows(src)
        doc['floors'].sort(key=lambda f: (f['zone_id'], f['map_n']))
        doc['unconfirmed_zones'] = [u for u in doc.get('unconfirmed_zones', []) if u.get('zone_id') != z]
    doc['dat_maps_ja'] = 'status が dat_made の行は、ゲームの地図が無いエリアをゾーン DAT から描いたもの（dev/build_dat_maps.py）。image が同梱の画像、h_min〜h_max（高さ、+ が下）がその層。'
    return doc


def write_json(path, doc, indent):
    with open(path, 'w', encoding='utf-8', newline='\n') as f:
        json.dump(doc, f, ensure_ascii=False, indent=indent)
        f.write('\n')


def main():
    for path in SOURCES:
        src = load(path)
        floors, walls = masks(src)
        T = load_tris()
        for old in glob.glob(os.path.join(ROOT, 'assets', 'maps', 'z%d_*.png' % src['zone_id'])):
            os.remove(old)   # ページの数が変わったとき、前の画像を残さない
        for L in pages(src):
            out = os.path.join(ROOT, 'assets', 'maps', 'z%d_%d.png' % (src['zone_id'], L['map_n']))
            render(src, floors, walls, L['map_n'], out, T)
            print('wrote', os.path.relpath(out, ROOT))
    mp = os.path.join(ROOT, 'data', 'maps.json')
    write_json(mp, merge_maps(load(mp)), 2)
    print('merged maps.json')
    return 0


if __name__ == '__main__':
    sys.exit(main())
