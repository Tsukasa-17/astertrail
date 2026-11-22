--[[
  Astertrail（アスタートレイル） - FFXI のクエスト・ミッション・エミネンスを日本語の画面で管理しながら攻略する非公式アドオン
  形式: Ashita v4 アドオン（VanaCore の Ashita 互換層で動かす）
  置き場所: Vanacore\addons\vanacore\astertrail\

  注意: このファイルには VanaCore の API 名を書かない（書くと別形式のアドオンと判定されるため）。
  環境ごとの呼び出しは src/platform/ の中だけにある。
]]

addon.name    = 'astertrail'
addon.author  = 'Tsukasa'
addon.version = '1.1.314'
addon.desc    = 'Quest and mission notebook with tracker (unofficial, Japanese UI).'

-- 自分のフォルダを require の先頭に（他のライブラリと名前がぶつからないよう src. で始める）
do
    local base = addon.path or ''
    if base ~= '' and base:sub(-1) ~= '\\' and base:sub(-1) ~= '/' then base = base .. '\\' end
    package.path = base .. '?.lua;' .. base .. '?\\init.lua;' .. package.path
end

local platform = require('src.platform.ashita')
local app = require('src.app')

app.init(platform)
platform.start(app)
