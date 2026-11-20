#!/usr/bin/env python3
"""
Astertrail 0.1.280 — SF テーマ専用の受注・完了効果音を、数式から作る。

ゲーム・他アドオン・配布音源は使わない。このスクリプトが音の唯一のソース。
出力 WAV のライセンスはアドオン本体と同じ GNU GPL-3.0。

  accept   … 柔らかいシンセ・チャイム（短い2音。約 0.85 秒）
  complete … 明るく上昇するアルペジオ（約 1.10 秒）

使い方（リポジトリのルート、またはどこからでも可）:

  python3 dev/gen_sf_sounds.py

書き先: assets/sounds/sf_accept.wav, assets/sounds/sf_complete.wav
"""

from __future__ import annotations

import math
import wave
from pathlib import Path

import numpy as np

RATE = 44100
PEAK = 0.84  # 割れないよう余裕を残す
ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = ROOT / "assets" / "sounds"


def midi_hz(n: float) -> float:
    return 440.0 * (2.0 ** ((n - 69.0) / 12.0))


def fade_edges(sig: np.ndarray, ms: float = 8.0) -> np.ndarray:
    n = max(1, int(RATE * ms / 1000.0))
    n = min(n, len(sig) // 4)
    if n < 1:
        return sig
    ramp = np.linspace(0.0, 1.0, n, dtype=np.float64)
    sig = sig.copy()
    sig[:n] *= ramp
    sig[-n:] *= ramp[::-1]
    return sig


def normalize(sig: np.ndarray, peak: float = PEAK) -> np.ndarray:
    m = float(np.max(np.abs(sig))) if len(sig) else 0.0
    if m <= 0:
        return sig
    return sig * (peak / m)


def bell(t: np.ndarray, freq: float, amp: float, decay: float, inharm: float = 1.0) -> np.ndarray:
    """柔らかいベル（倍音はわずかに非整数。既製のファンファーレは使わない）。"""
    partials = (
        (1.00, 1.000),
        (0.42, 2.003),
        (0.22, 2.997),
        (0.12, 4.021),
        (0.07, 5.039),
        (0.04, 6.062),
    )
    sig = np.zeros_like(t)
    for a, ratio in partials:
        f = freq * ratio * inharm
        env = np.exp(-t * (decay + (ratio - 1.0) * 1.15))
        sig += a * np.sin(2.0 * math.pi * f * t) * env
    # アタックのごく短いキラッ（ホワイトノイズではない決定的な高域）
    tick = np.exp(-t * 85.0) * np.sin(2.0 * math.pi * freq * 2.7 * t)
    sig = sig / 1.85 + 0.08 * tick
    return amp * sig


def sine_pad(t: np.ndarray, freq: float, amp: float, decay: float) -> np.ndarray:
    env = np.exp(-t * decay) * (1.0 - np.exp(-t * 70.0))
    vib = 1.0 + 0.0022 * np.sin(2.0 * math.pi * 5.1 * t)
    return amp * env * np.sin(2.0 * math.pi * freq * vib * t)


def render_accept() -> np.ndarray:
    # 柔らかい2音のチャイム（A4 の第五＋その上の明るい音。出発ファンファーレではない）
    dur = 0.85
    n = int(RATE * dur)
    out = np.zeros(n, dtype=np.float64)
    # t0: A5 + 静かな A4
    t0 = 0.00
    # t1: E6（完全五度上）を少し遅らせて重ねる
    events = [
        (0.000, 81, 0.72, 3.4, 1.000),  # A5
        (0.000, 69, 0.22, 2.6, 1.000),  # A4 下支え
        (0.155, 88, 0.62, 3.8, 1.001),  # E6
        (0.155, 76, 0.18, 3.0, 1.000),  # E5
    ]
    for t0, note, amp, decay, inh in events:
        i0 = int(t0 * RATE)
        t = np.arange(n - i0, dtype=np.float64) / RATE
        out[i0:] += bell(t, midi_hz(note), amp, decay, inh)
        out[i0:] += sine_pad(t, midi_hz(note), amp * 0.18, decay * 0.72)
    return fade_edges(normalize(out), 6.0)


def render_complete() -> np.ndarray:
    # 明るく上昇するアルペジオ（F# major 風。クラシック版の変ロ長調ファンファーレとは別）
    dur = 1.10
    n = int(RATE * dur)
    out = np.zeros(n, dtype=np.float64)
    # 上昇：C#5, F#5, A#5, C#6, F#6。間隔は独自。最後を少し長く残す。
    steps = [
        (0.000, 73, 0.42, 3.2),  # C#5
        (0.130, 78, 0.50, 3.1),  # F#5
        (0.250, 82, 0.56, 3.0),  # A#5
        (0.380, 85, 0.64, 2.8),  # C#6
        (0.520, 90, 0.70, 2.4),  # F#6 着地
    ]
    for t0, note, amp, decay in steps:
        i0 = int(t0 * RATE)
        t = np.arange(n - i0, dtype=np.float64) / RATE
        out[i0:] += bell(t, midi_hz(note), amp, decay, 1.0005)
        out[i0:] += sine_pad(t, midi_hz(note) * 0.5, amp * 0.16, decay * 0.65)
    # 着地の薄い和音（F#5 + C#6 + F#6）
    i0 = int(0.520 * RATE)
    t = np.arange(n - i0, dtype=np.float64) / RATE
    for note, amp in ((78, 0.16), (85, 0.20), (90, 0.18)):
        out[i0:] += sine_pad(t, midi_hz(note), amp, 2.0)
    return fade_edges(normalize(out), 8.0)


def write_wav(path: Path, sig: np.ndarray) -> dict:
    sig = np.clip(sig, -1.0, 1.0)
    pcm = np.round(sig * 32767.0).astype(np.int16)
    peak = int(np.max(np.abs(pcm))) if len(pcm) else 0
    assert peak <= 32767
    assert not np.any(pcm == -32768) or peak <= 32767
    path.parent.mkdir(parents=True, exist_ok=True)
    with wave.open(str(path), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(pcm.tobytes())
    dur = len(pcm) / RATE
    return {"path": str(path), "seconds": dur, "peak": peak, "rate": RATE, "frames": len(pcm)}


def main() -> None:
    acc = write_wav(OUT_DIR / "sf_accept.wav", render_accept())
    cmp_ = write_wav(OUT_DIR / "sf_complete.wav", render_complete())
    for info, lo, hi in ((acc, 0.5, 1.2), (cmp_, 0.5, 1.2)):
        if not (lo <= info["seconds"] <= hi):
            raise SystemExit(f"duration out of range: {info}")
        print(
            f"{Path(info['path']).name}: {info['seconds']:.3f}s  "
            f"peak={info['peak']}  {info['rate']}Hz mono 16-bit"
        )


if __name__ == "__main__":
    main()
