# Astertrail 技術検証（MVP：冒険の本＋トラッカー）

- 日付: 2026-11-12（JST）
- 対象: CatsEyeXI クライアント + VanaCore（GAME-PC の `C:\Games\CatsEyeXI\catseyexi-client\Vanacore\`）。読むだけで、何も入れていない・変えていない。
- 方法: VanaCore 同梱の文書（`Vanacore\docs\`）、同じ環境で動いている Ashita 形式のアドオン（読み込み方・API 名を見るだけ。コードは写していない）、`boot.txt`・ini の設定、箱の上での LuaJIT 2.1 による動作テスト（偽の imgui／Ashita を使う）。
- 判定: **成立**＝資料と同じ環境の前例で確かめられた／**不成立**／**未検証(実機が必要)**＝ゲーム内でないと分からない／**判定保留**。

## 結論

**止める理由（読み込めない・ImGui が出せない・ファイルを保存できない）は見つからなかったので、Phase 2（本＋トラッカーの実装）に進んだ。**
ただし、どれも「自分のアドオンをゲーム内で動かした」確認ではない。下の「実機で最初に見ること」を先に試してほしい。

## 項目ごと

| # | 項目 | 判定 | 根拠 | MVP への影響 |
|---|---|---|---|---|
| 1 | Ashita v4 形式のアドオンを読み込めるか | 成立（自分のは未検証(実機が必要)） | 文書: VanaCore は Ashita v4・Windower・VanaCore 形式を動かす。種類はメインのファイルの中身で判定（`vana.` があれば VanaCore、`ashita.`/`AshitaCore`/`addon.` が多ければ Ashita、無ければフォルダの種類）。同じ環境で Ashita 形式の Journal が `addons\vanacore\` に置かれ `//addon load Journal vanacore` で読み込まれている（boot.txt）。 | `addons\vanacore\astertrail\astertrail.lua`。`addon.name/author/version/desc` と `ashita.events.register` を使う。メインのファイルには `vana.` の文字を書かない（判定が変わるため）。 |
| 2 | 読み込みコマンド | 未検証(実機が必要) | 文書: `/addon load <名前> [vanacore\|ashita\|windower]`。前例は `vanacore` 付き。 | README は `/addon load astertrail vanacore`（だめなら `/addon load astertrail`）。 |
| 3 | ImGui の窓を出せるか | 成立（表示は未検証(実機が必要)） | 文書: `require('imgui')` で ImGui 1.92 の Ashita 互換の呼び方（ドット呼び、ポインタは `{v}`、ベクトルは `{x,y}`、色は ImU32、戻り値は複数値 `local x, y = imgui.GetWindowPos()`）。描くのは d3d_present の中だけ。`###` で窓の名前を固定。VanaCore の配置機能が窓を動かすことがある。 | 窓名は `…###astertrail_<窓>`。Begin/End の組は失敗しても必ず閉じる仕組みを入れた。 |
| 4 | 日本語の文字 | 未検証(実機が必要) | 既定のフォント（Agave）には日本語が無い。この PC の ini は `imgui.font=azukiLP.ttf`、`fonts\azukiLP.ttf` がある。ゲームの文字は Shift-JIS、ImGui は UTF-8。 | 文字はすべて UTF-8。四角になる場合はフォント設定の確認が必要（アドオン側では変えない）。 |
| 5 | 保存先 | 成立（自分の書き込みは未検証(実機が必要)） | 文書: `AshitaCore:GetInstallPath()` は VanaCore のフォルダ。Journal も `config\addons\<名前>\` に書いている。 | `Vanacore\config\addons\astertrail\catseye_<キャラ名>\`。キャラ名が分かるまで読み書きしない。 |
| 6 | ファイルの読み書き | 成立（実機は未検証(実機が必要)） | LuaJIT 2.1（Lua 5.1）で `io.open` が使える（文書）。`ashita.fs.exists / create_directory / get_directory` は同じ環境のアドオンで多数使われている。箱のテストで、一時ファイル→読み直し確認→`.bak`→差し替え、壊れた記録からの復旧、新しい形式の記録を上書きしないこと、を確認。 | 保存は「.tmp に書いて読み直し→古い .bak を消す→今のを .bak→.tmp を本物に」。1日1回のバックアップ（10件）。 |
| 7 | イベント | 成立 | 文書: load／unload／command（`e.command`, `e.blocked`）／d3d_present／key_data（`e.key`, `e.down`, `e.blocked`）／key_state／xinput_button（`e.button`, `e.state`, `e.blocked`）。 | 入力のイベントは無い環境でも本体が動くよう、1つずつ登録。 |
| 8 | キャラ名・ゾーン | 成立（未検証(実機が必要)） | `GetMemoryManager():GetParty():GetMemberName(0) / GetMemberZone(0)` は同じ環境のアドオンで使われている。 | 0.5秒ごとに読む。ゾーン移動中に一瞬読めなくても、5秒続かない限りログアウト扱いにしない。 |
| 9 | 戦闘中の判定 | 未検証(実機が必要) | `GetEntity():GetStatus(index)` が 1 なら戦闘態勢、という前提。 | エリア入場のお知らせを戦闘中に出さないためだけに使う。読めなければ「戦闘中でない」。 |
| 10 | キーをゲームに渡さない | 未検証(実機が必要) | 文書: key_data の `e.blocked`。key（WNDPROC）で止まるのは文字入力だけ。key_state は毎フレームのキー状態。 | 窓を操作中で、文字入力中でない時だけ、矢印・Enter・Esc・Tab を止める。key_state でも同じキーを 0 にする（ffi、失敗しても無視）。 |
| 11 | パッド | 未検証(実機が必要) | 文書: xinput_button（0上 1下 2左 3右 4Start 5Back 8LB 9RB 12A 13B 14X 15Y）。`vana.gamepad.*` はどの形式のアドオンからも呼べるが、メインのファイルに書くと判定が変わるので別ファイルでだけ使う。 | xinput_button を使い、操作中かつ「パッドで操作」がオンの時だけ止める。`vana.gamepad` は設定画面の表示（検出の有無）だけ。キーボード・マウスでも全部できる。 |
| 12 | 所持品（袋）の読み取り | 判定保留（止める理由ではない） | `GetInventory():GetContainerItem` はあるが未確認。データに item_id がまだ無い。 | MVP では使わず「未確認」と出す。移動・売却・トレードの通信は送らない。所持で手順を自動完了しない。 |
| 13 | Esc・YunaUI との取り合い | 未検証(実機が必要) | YunaUI も入力を扱う（読み込みは boot.txt の `//addon load yunaui vanacore`）。 | 操作中だけ受け取る作りにして、取り合いの範囲を小さくした。 |
| 14 | CatsEyeXI のアドオン方針 | 成立 | 方針: 読むだけの情報表示は可。 | 通信を送らない・自動操作しない作り。 |
| 15 | ネット・テレメトリ | 成立 | コードに通信が無い。 | — |

## 実機で最初に見ること（この順に）

1. `/addon load astertrail vanacore` で読み込めるか（だめなら `/addon load astertrail`）。チャットに Lua のエラーが出ないか。
2. 本のアイコンと本の窓が出るか。日本語が読めるか。
3. 手順をチェック → ログアウト／読み直し後に残るか。`config\addons\astertrail\catseye_<名前>\progress.json` ができるか。
4. 本を操作中に矢印・Enter・Esc がゲームに効かないか。閉じた後はゲームに戻るか。
5. 本を操作中にパッドで動かせるか。トラッカーが見えているだけの時にキャラが普通に動くか。
6. YunaUI と一緒の時の Esc。

## 箱の上でのテスト（参考）

`python3 dev/run_tests.py`（LuaJIT 2.1）。本の表（BeginTable が無い・失敗する時は並べたセルに切り替え）、本の右側の詳細とダブルクリックの詳細だけの窓、詳細に出典を出さないこと、名前の色分けも偽の imgui で確かめる（表の見た目は実機で要確認）。JSON、データの読み込み（16件・出典URL・手順のつながり）、進み具合の規則（自動で完了にしない・固定中の扱い・ピンの上限・周回）、保存と復旧、設定のまとめ方、文言の ja/en のそろい、そして偽の imgui と偽の Ashita で本体を丸ごと動かす流れ（ログイン前に保存しない・操作中だけ入力を取る・トラッカーは見えているだけでは入力を取らない・お知らせの表示と自動で消える・戦闘中は出さない・画面の途中の失敗でも Begin/End を閉じる・新しい形式の記録を上書きしない・キャラごとのフォルダ）。ゲーム内での確認の代わりにはならない。
