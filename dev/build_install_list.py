#!/usr/bin/env python3
"""install_files.json を作る（0.1.297〜）。配布 zip に入れ、アドオンが「入っているファイル」を知るのに使う
（backups\\cur・backups\\prev への写しと、前のバージョンに戻すとき）。
dev/・.git・__pycache__・backups・設定などは入れない。使い方: python3 dev/build_install_list.py [アドオンのフォルダ]"""
import hashlib, json, os, re, sys

root = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(__file__), '..'))
SKIP_DIRS = {'dev', '.git', '__pycache__', 'backups', 'config', 'logs', 'temp', 'tmp'}
SKIP_FILES = {'install_files.json', 'settings.json', 'progress.json'}

src = open(os.path.join(root, 'astertrail.lua'), encoding='utf-8').read()
m = re.search(r"addon\.version\s*=\s*'([^']+)'", src)
version = m.group(1) if m else '?'

files = []
for d, dirs, names in os.walk(root):
    rel_d = os.path.relpath(d, root)
    dirs[:] = sorted(x for x in dirs if not (rel_d == '.' and x in SKIP_DIRS) and x != '__pycache__')
    for n in sorted(names):
        rel = os.path.normpath(os.path.join(rel_d, n)).replace(os.sep, '/')
        if rel in SKIP_FILES or n.endswith('.pyc') or n.endswith('.zip'):
            continue
        with open(os.path.join(d, n), 'rb') as f:
            h = hashlib.sha256(f.read()).hexdigest()
        files.append({'path': rel, 'sha256': h})

with open(os.path.join(root, 'install_files.json'), 'w', encoding='utf-8') as f:
    json.dump({'version': version, 'files': files}, f, ensure_ascii=False, indent=0)
    f.write('\n')
print(f'install_files.json: version {version}, {len(files)} files')
