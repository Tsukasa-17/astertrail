--[[
  Astertrail - core: アップデートのお知らせ（0.1.58〜）
  新しい版を調べる先（URL）は update.URL。空なら何もしない（通信もしない・エラーも出さない）。
  調べた結果の形は、どちらでもよい：
    {"version": "0.1.60"} のような JSON（"latest" でも可）／ 「0.1.60」だけの文字
]]

local update = {}

-- 新しい版を書いたファイル（リポジトリの main にある version.json。{"version": "1.1.260"} の形）。
-- 読み込んだあと 1 回だけ GET で読む（読むだけ・64KB まで・つながらなければ何もしない）。
-- 版を出すときは、リリースと同じ版をこのファイルに書く。
update.URL = 'https://raw.githubusercontent.com/Tsukasa-17/astertrail/main/version.json'

-- '0.1.58' → { 0, 1, 58 }。読めなければ nil
function update.parse_version(s)
    if type(s) ~= 'string' then return nil end
    s = s:match('^%s*[vV]?([%d%.]+)%s*$') or s:match('"[%w_]*version"%s*:%s*"[vV]?([%d%.]+)"')
        or s:match('"latest"%s*:%s*"[vV]?([%d%.]+)"')
    if not s or s == '' then return nil end
    local out = {}
    for n in s:gmatch('%d+') do out[#out + 1] = tonumber(n) end
    if #out == 0 then return nil end
    return out, s
end

-- a が b より新しければ true
function update.newer(a, b)
    local va, vb = update.parse_version(a), update.parse_version(b)
    if not va or not vb then return false end
    for i = 1, math.max(#va, #vb) do
        local x, y = va[i] or 0, vb[i] or 0
        if x ~= y then return x > y end
    end
    return false
end

-- 返ってきた本文から版を取り出す（JSON でも文字だけでも）
function update.version_in(body)
    if type(body) ~= 'string' or body == '' or #body > 65536 then return nil end
    local _, v = update.parse_version(body)
    return v
end

-- 調べる先が入っているか
function update.configured(url)
    url = url == nil and update.URL or url
    return type(url) == 'string' and url:match('^https?://') ~= nil
end

return update
