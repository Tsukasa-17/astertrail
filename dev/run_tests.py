#!/usr/bin/env python3
"""開発用テスト。LuaJIT 2.1（lupa）で dev/tests/*.lua を順に動かす。ゲームには不要。"""
import glob, os, sys, tempfile, shutil
import lupa.luajit21 as lj

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
failed = 0
for path in sorted(glob.glob(os.path.join(ROOT, 'dev', 'tests', 'test_*.lua'))):
    tmp = tempfile.mkdtemp(prefix='astertrail_')
    L = lj.LuaRuntime(unpack_returned_tuples=True)
    g = L.globals()
    g.ROOT = ROOT
    g.TMP = tmp
    L.execute("package.path = ROOT .. '/?.lua;' .. ROOT .. '/dev/tests/?.lua;' .. package.path")
    name = os.path.basename(path)
    try:
        L.execute(open(path, encoding='utf-8').read())
        n = L.eval('(T_PASSED or 0)')
        print(f'ok   {name} ({n} checks)')
    except Exception as e:
        failed += 1
        print(f'FAIL {name}: {e}')
    shutil.rmtree(tmp, ignore_errors=True)
sys.exit(1 if failed else 0)
