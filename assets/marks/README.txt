Astertrail - 自分のアイコン / Your own icons
============================================

このフォルダ（assets/marks/）に、下と同じ名前の PNG を置くと、NPCなどの横のアイコンがその絵に変わります。
置いていない名前は、example/ の中の同梱の絵を使います。
アドオンを更新しても、このフォルダに置いた絵は上書きされません（更新で入るのは example/ とこの説明だけ）。
差し替えたあとは、ゲームで /astertrail icons と打つと読み直します（アドオンの読み込み直しでも同じ）。

  形式：PNG（透過あり）。大きさは 64×64 ピクセルがおすすめ（同梱の絵と同じ）。
        正方形なら別の大きさでもよく、設定の「アイコンの大きさ」に合わせて縮めて出します。

  main.png         メインのミッション（次に進めるもの）
  sub.png          受けられるクエスト
  repeat.png       くり返し受けられるクエスト
  unavailable.png  まだ受けられない
  progress.png     受注中
  blocked.png      受注中だが、必要な品が足りなくて進めない
  complete.png     手順が全部済んだ（報告待ち）
  talk.png         話しかける相手
  hunt.png         倒す相手
  examine.png      調べる場所
  guard.png        ゲートガード
  fame.png         名声を教えてくれる人

  NPCなどの横のアイコンに絵を使うのは VanaCore のときだけです。
  本・トラッカーの小さなアイコンや、設定・コンパス・トラッカー・エミネンスのボタンの絵はプログラムで描いているので、
  このフォルダでは変わりません。

Put a PNG with one of the names above in this folder (assets/marks/) to replace that overhead icon.
Names you do not provide use the bundled image in example/. Updates never overwrite files in this folder
(they only ship example/ and this README). Type /astertrail icons in game to reload after replacing.
PNG with transparency, 64x64 recommended (same as the bundled images); any square size is scaled to the icon size setting.
Overhead images are used with VanaCore only. Icons in the book/tracker and the button pictures are drawn in code.
