--[[
  Astertrail - core: 前のバージョンをとっておく・戻す（0.1.297〜）
  アドオンのフォルダの backups\cur\（いま動いているバージョン）と backups\prev\（一つ前）に、
  入っているファイルを写す。どちらも manifest.json（version・files { path, sha256 }）を最後に書き、
  manifest.json があるものだけを使える写しとみなす。
  入っているファイルの一覧は、配布の zip に入れる install_files.json（dev/build_install_list.py が作る）。
  設定・進行・backups・ログなど、更新で守るファイル（update.is_protected）は写さない・戻さない。
  ファイルの読み書きは fs を渡す（read, write, exists, mkdir, remove, copy, sep）。
]]

local json = require('src.lib.json')
local update = require('src.core.update')
local sha256 = require('src.lib.sha256')

local M = {}

M.LIST = 'install_files.json'
M.MANIFEST = 'manifest.json'
M.CUR = 'backups\\cur'
M.PREV = 'backups\\prev'

local function join(root, rel, sep)
    sep = sep or '\\'
    rel = tostring(rel):gsub('[\\/]', sep)
    if not root or root == '' then return rel end
    root = tostring(root):gsub('[\\/]+$', '')
    return root .. sep .. rel
end
M.join = join

local function parent(path)
    return path:match('^(.*)[\\/][^\\/]+$')
end

local function decode(s)
    if type(s) ~= 'string' or s == '' then return nil end
    local ok, v = pcall(json.decode, s)
    if ok and type(v) == 'table' then return v end
    return nil
end

-- 相対パスを / にそろえ、危ないもの・守るものは外す
local function clean_rel(rel)
    if type(rel) ~= 'string' or rel == '' then return nil end
    rel = rel:gsub('\\', '/'):gsub('^/+', '')
    if rel == M.MANIFEST then return nil end
    local safe = require('src.lib.zip').safe_rel(rel)
    if not safe then return nil end
    if update.is_protected(safe) then return nil end
    return safe
end
M.clean_rel = clean_rel

-- install_files.json を読む。戻り値: { version, files = { rel... } } または nil
function M.read_list(addon_dir, fs)
    local t = decode(fs.read(join(addon_dir, M.LIST, fs.sep)))
    if not t or type(t.files) ~= 'table' then return nil end
    local out, seen, sha = {}, {}, {}
    for _, f in ipairs(t.files) do
        local rel = clean_rel(type(f) == 'table' and f.path or f)
        if rel and not seen[rel] then
            seen[rel] = true; out[#out + 1] = rel
            local h = type(f) == 'table' and f.sha256
            if type(h) == 'string' and #h == 64 then sha[rel] = h:lower() end
        end
    end
    -- 一覧そのものも写す（戻したあと、その版の一覧に戻るように）
    if not seen[M.LIST] then out[#out + 1] = M.LIST end
    return { version = type(t.version) == 'string' and t.version or nil, files = out, sha = sha }
end

-- 写しの manifest.json を読む。戻り値: { version, files = { { path, sha256 } }, set = { [path] = sha } } または nil
function M.read_manifest(slot_dir, fs)
    local t = decode(fs.read(join(slot_dir, M.MANIFEST, fs.sep)))
    if not t or type(t.version) ~= 'string' or type(t.files) ~= 'table' then return nil end
    local files, set = {}, {}
    for _, f in ipairs(t.files) do
        local rel = type(f) == 'table' and clean_rel(f.path) or nil
        local sha = type(f) == 'table' and type(f.sha256) == 'string' and f.sha256:lower() or nil
        if rel and sha and #sha == 64 and not set[rel] then
            files[#files + 1] = { path = rel, sha256 = sha }
            set[rel] = sha
        end
    end
    if #files == 0 then return nil end
    return { version = t.version, files = files, set = set, made = t.made }
end

--[[ 写す仕事。少しずつ進める（読み込み直後に止まらないように）。
  M.copy_job(src_root, slot_dir, rels, version, fs) → job
  job:step(n) → 'run' | 'done' | 'failed', err
  初めに manifest.json を消し、写したファイルの sha256 を数えて、最後に manifest.json を書く。
  前の写しにあって今回に無いファイルは消す。 ]]
function M.copy_job(src_root, slot_dir, rels, version, fs, known)
    local job = { i = 0, files = {}, state = 'run' }
    local sep = fs.sep or '\\'
    local old = M.read_manifest(slot_dir, fs)
    local mpath = join(slot_dir, M.MANIFEST, sep)
    function job:step(n)
        if self.state ~= 'run' then return self.state, self.err end
        if self.i == 0 then
            fs.mkdir(slot_dir)
            if fs.exists(mpath) then fs.remove(mpath) end
            if fs.exists(mpath) then self.state, self.err = 'failed', 'manifest'; return self.state, self.err end
            self.i = 1
        end
        local last = math.min(#rels, self.i + (n or 20) - 1)
        for k = self.i, last do
            local rel = rels[k]
            local s, d = join(src_root, rel, sep), join(slot_dir, rel, sep)
            if fs.exists(s) then
                local par = parent(d)
                if par then fs.mkdir(par) end
                local ok, err = fs.copy(s, d)
                if not ok then self.state, self.err = 'failed', err or ('copy ' .. rel); return self.state, self.err end
                -- 作ったときの sha256 が分かっていれば数え直さない（大きいファイルで止まらないように）。
                -- 写しが壊れていれば、戻すときの確かめ（M.verify）で見つかって戻さない
                local h = known and known[rel] or sha256.of_file(d, fs.read)
                if not h then self.state, self.err = 'failed', 'hash ' .. rel; return self.state, self.err end
                self.files[#self.files + 1] = { path = rel, sha256 = h }
            end
        end
        self.i = last + 1
        if self.i <= #rels then return 'run' end
        if #self.files == 0 then self.state, self.err = 'failed', 'no files'; return self.state, self.err end
        -- 前の写しにだけあったファイルを消す
        if old then
            local now = {}
            for _, f in ipairs(self.files) do now[f.path] = true end
            for _, f in ipairs(old.files) do
                if not now[f.path] then pcall(fs.remove, join(slot_dir, f.path, sep)) end
            end
        end
        local body = json.encode({ version = version, made = os.date and os.date('!%Y-%m-%dT%H:%M:%SZ') or nil, files = self.files })
        local ok, err = fs.write(mpath, body)
        if not ok then self.state, self.err = 'failed', err or 'manifest'; return self.state, self.err end
        self.state = 'done'
        return 'done'
    end
    function job:run_all()
        local st, err
        repeat st, err = self:step(1000) until st ~= 'run'
        return st == 'done', err
    end
    return job
end

-- いま入っているファイル → slot
function M.snapshot_job(addon_dir, slot_dir, fs, version)
    local list = M.read_list(addon_dir, fs)
    if not list then return nil, 'no list' end
    return M.copy_job(addon_dir, slot_dir, list.files, version or list.version or '?', fs, list.sha)
end

-- slot → slot（cur を prev に）
function M.slot_copy_job(from_dir, to_dir, fs)
    local man = M.read_manifest(from_dir, fs)
    if not man then return nil, 'no manifest' end
    local rels = {}
    for _, f in ipairs(man.files) do rels[#rels + 1] = f.path end
    return M.copy_job(from_dir, to_dir, rels, man.version, fs, man.set)
end

-- 写しが manifest どおりか（全部の sha256）。戻り値: ok, 合わなかったパス
function M.verify(slot_dir, man, fs)
    if not man then return false, 'no manifest' end
    for _, f in ipairs(man.files) do
        local h = sha256.of_file(join(slot_dir, f.path, fs.sep), fs.read)
        if not sha256.eq(h, f.sha256) then return false, f.path end
    end
    return true
end

-- 新しいほうにだけあるファイル（戻したあとに消す）
function M.added_files(cur_list, prev_man)
    local out = {}
    if not cur_list or not prev_man then return out end
    for _, rel in ipairs(cur_list.files) do
        if not prev_man.set[rel] and rel ~= M.LIST then out[#out + 1] = rel end
    end
    return out
end

--[[ 読み込んだときにやること。戻り値: 仕事の並び（順に step する）と、どうしたか
  cur が無い → いまを cur へ
  cur がいまのバージョン → 何もしない
  cur が別のバージョン → cur を prev へ（prev がすでに同じバージョンなら写さない）→ いまを cur へ ]]
function M.plan_on_load(addon_dir, fs, version)
    local cur_dir, prev_dir = join(addon_dir, M.CUR, fs.sep), join(addon_dir, M.PREV, fs.sep)
    if not M.read_list(addon_dir, fs) then return {}, 'no list' end
    local cur = M.read_manifest(cur_dir, fs)
    if cur and cur.version == version then return {}, 'same' end
    local jobs = {}
    if cur then
        local prev = M.read_manifest(prev_dir, fs)
        if not (prev and prev.version == cur.version) then
            local j = M.slot_copy_job(cur_dir, prev_dir, fs)
            if j then jobs[#jobs + 1] = j end
        end
    end
    local s = M.snapshot_job(addon_dir, cur_dir, fs, version)
    if s then jobs[#jobs + 1] = s end
    return jobs, cur and 'rotate' or 'first'
end

-- 戻せる先。戻り値: manifest（version ほか）または nil
function M.prev_info(addon_dir, fs, version)
    local man = M.read_manifest(join(addon_dir, M.PREV, fs.sep), fs)
    if not man or man.version == version then return nil end
    return man
end

--[[ prev へ戻す。opts: { rollback_dir, config_dir }
  1) prev を sha256 で確かめる 2) update.swap で入れ替え（失敗したら swap がいまに戻す）
  3) 新しいほうにだけあったファイルを消す。戻り値: true | nil, 理由 ]]
function M.restore(addon_dir, fs, opts)
    opts = opts or {}
    local prev_dir = join(addon_dir, M.PREV, fs.sep)
    local man = M.read_manifest(prev_dir, fs)
    if not man then return nil, 'no backup' end
    local ok, bad = M.verify(prev_dir, man, fs)
    if not ok then return nil, 'hash', bad end
    local cur_list = M.read_list(addon_dir, fs)
    local rels = {}
    for _, f in ipairs(man.files) do rels[#rels + 1] = f.path end
    local r, why = update.swap(prev_dir, addon_dir, rels, opts.rollback_dir, {
        exists = fs.exists, mkdir = fs.mkdir, copy = fs.copy, remove = fs.remove,
        config_dir = opts.config_dir, sep = fs.sep,
    })
    if not r then return nil, why or 'swap' end
    local removed = 0
    for _, rel in ipairs(M.added_files(cur_list, man)) do
        local p = join(addon_dir, rel, fs.sep)
        if fs.exists(p) and pcall(fs.remove, p) then removed = removed + 1 end
    end
    return { version = man.version, copied = r.copied, removed = removed }
end

return M
