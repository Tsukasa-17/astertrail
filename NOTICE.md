# NOTICE

Astertrail は非公式のファンメイドです。Square Enix、CatsEyeXI、VanaCore とは関係ありません。
FINAL FANTASY XI は株式会社スクウェア・エニックスの登録商標です。

## 参考にしたもの

- Based on YunaUI by Yunas - https://github.com/YunasXI/yunaui
  画面の見た目・使い心地の考え方を参考にしました。
  フォントの読み込み（Windows のメイリオを ImGui に足し、大きさごとに使う）は、YunaUI のフォントの読み込みをもとにしています（作者 Tsukasa が YunaUI 側で書いた部分を、本人の許可を得て使っています）。フォントの選択・一覧・合成（MergeMode）は使っていません。

## データ

- クエスト一覧の参照元: FF11用語辞典 https://wiki.ffo.jp/
  （データの各項目に出典URLと確認日を入れています。ゲームの画面には出しません）
- 手順の文は独自に書いた短い要約（下書き）で、記事の本文は含みません。
- Journal・Questlog のデータは使っていません。

## コード

- JSON の読み書き（src/lib/json.lua）を含め、ほとんどはこのアドオンのために書いたものです。
- フォントの読み込み（src/ui/crisp_font.lua、メイリオ）は、YunaUI のフォントの読み込みをもとにしています（上記）。選択・一覧・合成のコードは使っていません。それ以外の YunaUI のコードは含んでいません。Ashita／VanaCore の公開されている API の使い方を参考にしています。

## ライセンス

GNU General Public License v3.0（全文は LICENSE）。

Copyright (C) 2026 Tsukasa
