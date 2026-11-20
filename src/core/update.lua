--[[
  Astertrail - core: アップデートのお知らせ（0.1.58〜）
  新しい版を調べる先（URL）は update.URL。空なら何もしない（通信もしない・エラーも出さない）。
  調べた結果の形は、どちらでもよい：
    {"version": "0.1.60"} のような JSON（"latest" でも可）／ 「0.1.60」だけの文字
  0.1.282〜：任意で zip_url と sha256 を書いておくと、お知らせからダウンロードして更新できる。
]]

local update = {}

-- 新しい版を書いたファイル（リポジトリの main にある version.json。{"version": "1.1.285"} の形）。
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

-- JSON 本文から版と、あれば zip_url / sha256 を取り出す（0.1.282〜）
function update.manifest_in(body)
    if type(body) ~= 'string' or body == '' or #body > 65536 then return nil end
    local version = update.version_in(body)
    if not version then return nil end
    local function field(key)
        local v = body:match('"' .. key .. '"%s*:%s*"([^"]+)"')
            or body:match("'" .. key .. "'%s*:%s*'([^']+)'")
        if v and v ~= '' then return v end
        return nil
    end
    local zip_url = field('zip_url') or field('url')
    local sha = field('sha256') or field('sha_256') or field('hash')
    if sha then
        sha = sha:gsub('%s+', ''):lower()
        if not sha:match('^[0-9a-f]+$') or #sha ~= 64 then sha = nil end
    end
    if zip_url and not zip_url:match('^https?://') then zip_url = nil end
    return { version = version, zip_url = zip_url, sha256 = sha }
end

-- 更新で上書きしてはいけない相対パス（設定・進行・レイアウト・バックアップ・ログ・自分の印）
function update.is_protected(rel)
    if type(rel) ~= 'string' or rel == '' then return true end
    rel = rel:gsub('\\', '/'):gsub('^/+', '')
    local lower = rel:lower()
    if lower == 'config' or lower:find('^config/') then return true end
    if lower == 'settings' or lower:find('^settings/') then return true end
    if lower == 'backups' or lower:find('^backups/') then return true end
    if lower == 'debug' or lower:find('^debug/') then return true end
    if lower:find('%.log$') then return true end
    if lower == 'layouts.json' or lower:find('^layouts%.json$') then return true end
    if lower:find('^progress') then return true end
    -- 利用者が置いた印。example と README だけ更新してよい
    if lower:find('^assets/marks/') then
        if lower:find('^assets/marks/example/') then return false end
        if lower == 'assets/marks/readme.txt' then return false end
        return true
    end
    if lower:find('%.%.') then return true end
    return false
end

-- dest が設定フォルダの中なら拒否
function update.dest_is_config(dest, config_dir)
    if type(dest) ~= 'string' or dest == '' then return false end
    if type(config_dir) ~= 'string' or config_dir == '' then return false end
    local function norm(p)
        p = p:gsub('/', '\\'):lower()
        if p:sub(-1) ~= '\\' then p = p .. '\\' end
        return p
    end
    dest, config_dir = norm(dest), norm(config_dir)
    return dest:sub(1, #config_dir) == config_dir
end

-- 作業フォルダへ展開したあと、アドオンのルート（astertrail.lua がある場所）を決める
function update.stage_root(files, exists_fn, stage, sep)
    sep = sep or '/'
    files = files or {}
    local stripped, top = require('src.lib.zip').strip_root(files)
    local function has(rel)
        if type(exists_fn) ~= 'function' or not stage then return false end
        return exists_fn(stage .. sep .. rel:gsub('/', sep)) == true
    end
    if top then
        local root = top
        if has(root .. '/astertrail.lua') or has(root .. '/src/app.lua') then
            return root, stripped
        end
    end
    -- 先頭フォルダなし
    for _, n in ipairs(files) do
        if n == 'astertrail.lua' or n == 'src/app.lua' then
            return '', files
        end
    end
    return nil, nil
end

-- src のファイルを dest へ入れる。失敗したら rollback から戻して、新規ファイルを消す
-- opts: { read, write, exists, mkdir, remove, copy, protected, config_dir, sep }
function update.swap(src_root, dest_root, files, rollback_dir, opts)
    opts = opts or {}
    local sep = opts.sep or package.config:sub(1, 1)
    local exists, mkdir, copy, remove = opts.exists, opts.mkdir, opts.copy, opts.remove
    if type(exists) ~= 'function' or type(copy) ~= 'function' or type(mkdir) ~= 'function' then
        return nil, 'no fs'
    end
    if update.dest_is_config(dest_root, opts.config_dir) then
        return nil, 'config'
    end
    src_root = tostring(src_root or ''):gsub('[\\/]+$', '')
    dest_root = tostring(dest_root or ''):gsub('[\\/]+$', '')
    rollback_dir = rollback_dir and tostring(rollback_dir):gsub('[\\/]+$', '') or nil
    local planned, backed, added = {}, {}, {}
    for _, rel in ipairs(files or {}) do
        if type(rel) == 'string' and rel ~= '' and not update.is_protected(rel) then
            local safe = require('src.lib.zip').safe_rel(rel)
            if not safe then
                return nil, 'unsafe path'
            end
            planned[#planned + 1] = safe
        end
    end
    if #planned == 0 then return nil, 'no files' end
    local function join(root, rel)
        if not root or root == '' then return rel:gsub('/', sep) end
        return root .. sep .. rel:gsub('/', sep)
    end
    local function parent(path)
        return path:match('^(.*)[\\/][^\\/]+$')
    end
    -- 先に退避（全部成功してから入れ替え）
    if rollback_dir then mkdir(rollback_dir) end
    for _, rel in ipairs(planned) do
        local d = join(dest_root, rel)
        if exists(d) then
            if not rollback_dir then return nil, 'no rollback' end
            local b = join(rollback_dir, rel)
            local par = parent(b)
            if par then mkdir(par) end
            local ok, err = copy(d, b)
            if not ok then return nil, err or ('backup ' .. rel) end
            backed[#backed + 1] = rel
        end
    end
    -- 入れ替え
    local failed
    for _, rel in ipairs(planned) do
        local s, d = join(src_root, rel), join(dest_root, rel)
        local par = parent(d)
        if par then mkdir(par) end
        local was = exists(d)
        local ok, err = copy(s, d)
        if not ok then
            failed = err or ('copy ' .. rel)
            break
        end
        if not was then added[#added + 1] = rel end
    end
    if not failed then return { copied = #planned, backed = #backed, added = #added } end
    -- 戻す
    if rollback_dir then
        for _, rel in ipairs(backed) do
            local b, d = join(rollback_dir, rel), join(dest_root, rel)
            pcall(copy, b, d)
        end
    end
    if type(remove) == 'function' then
        for _, rel in ipairs(added) do
            pcall(remove, join(dest_root, rel))
        end
    end
    return nil, failed
end

return update
