--[[
  Astertrail - 保存と復元（4-4 の手順）
  1. <file>.tmp に書いて読み戻し確認
  2. 古い <file>.bak を先に消す（Windows は上書きで名前を変えられない）
  3. 今の <file> を <file>.bak に
  4. <file>.tmp を <file> に
  ファイル操作の手段は platform から fs として受け取る。
]]

local json = require('src.lib.json')
local util = require('src.lib.util')

local storage = {}

-- fs: read(path) / write(path, text) / exists(path) / remove(path) / rename(a, b) / mkdir(path) / list(dir) (任意)
function storage.save_json(fs, path, value)
    local text, err = json.encode(value)
    if not text then return false, 'encode: ' .. tostring(err) end
    local tmp, bak = path .. '.tmp', path .. '.bak'
    if fs.exists(tmp) then fs.remove(tmp) end
    local ok, why = fs.write(tmp, text)
    if not ok then return false, 'write tmp: ' .. tostring(why) end
    -- 書けた内容を読み戻して確かめる
    local back = fs.read(tmp)
    if back ~= text or not json.decode(back) then
        fs.remove(tmp)
        return false, 'verify tmp failed'
    end
    if fs.exists(path) then
        if fs.exists(bak) then
            local okr, wr = fs.remove(bak)
            if not okr then fs.remove(tmp); return false, 'remove old bak: ' .. tostring(wr) end
        end
        local okm, wm = fs.rename(path, bak)
        if not okm then fs.remove(tmp); return false, 'rename to bak: ' .. tostring(wm) end
    end
    local okf, wf = fs.rename(tmp, path)
    if not okf then
        -- 戻せるなら .bak を元に戻す
        if not fs.exists(path) and fs.exists(bak) then fs.rename(bak, path) end
        return false, 'rename tmp: ' .. tostring(wf)
    end
    return true
end

local function try_read(fs, path)
    if not fs.exists(path) then return nil, 'missing' end
    local text, why = fs.read(path)
    if not text then return nil, why or 'read failed' end
    local v, err = json.decode(text)
    if v == nil or type(v) ~= 'table' then return nil, 'broken: ' .. tostring(err) end
    return v
end

-- バックアップ一覧（新しい順）。list がなければ空
function storage.list_backups(fs, dir, prefix)
    if not fs.list then return {} end
    local names = fs.list(dir) or {}
    local out = {}
    for _, n in ipairs(names) do
        -- 日付で始まるものだけ（形式更新前の schema 付きは数えない）
        if n:sub(1, #prefix) == prefix and n:sub(#prefix + 1, #prefix + 1):match('%d') and n:match('%.json$') then
            out[#out + 1] = n
        end
    end
    table.sort(out, function (a, b) return a > b end)
    return out
end

--[[
  読み込み（壊れていたら .bak → backups の新しい順）
  戻り値: value or nil, info
  info = { source = 'main'|'bak'|'backup:<name>'|'none'|'missing', broken_renamed = path or nil, errors = {...} }
]]
function storage.load_json(fs, path, backup_dir, backup_prefix, now_stamp)
    local info = { errors = {} }
    local v, why = try_read(fs, path)
    if v then info.source = 'main'; return v, info end
    if why == 'missing' and not fs.exists(path .. '.bak') then
        info.source = 'missing'
        return nil, info
    end
    if why ~= 'missing' then
        info.errors[#info.errors + 1] = 'main: ' .. tostring(why)
        -- 壊れたファイルは名前を変えて残す（上書きしない）
        local broken = path .. '.broken-' .. (now_stamp or util.stamp())
        if fs.rename(path, broken) then info.broken_renamed = broken end
    end
    v, why = try_read(fs, path .. '.bak')
    if v then info.source = 'bak'; return v, info end
    info.errors[#info.errors + 1] = 'bak: ' .. tostring(why)
    if backup_dir then
        for _, name in ipairs(storage.list_backups(fs, backup_dir, backup_prefix or '')) do
            v, why = try_read(fs, backup_dir .. name)
            if v then info.source = 'backup:' .. name; return v, info end
            info.errors[#info.errors + 1] = name .. ': ' .. tostring(why)
        end
    end
    info.source = 'none'
    return nil, info
end

-- 1日1回のバックアップ。今の正常な path を backups へ写し、keep 件を超えたら古い順に消す
function storage.daily_backup(fs, path, backup_dir, prefix, keep, t)
    if not fs.exists(path) then return false, 'nothing' end
    fs.mkdir(backup_dir)
    local today = prefix .. util.day(t)
    for _, n in ipairs(storage.list_backups(fs, backup_dir, prefix)) do
        if n:sub(1, #today) == today then return false, 'already' end
    end
    local text = fs.read(path)
    if not text or not json.decode(text) then return false, 'source broken' end
    local name = prefix .. util.stamp(t) .. '.json'
    local ok, why = fs.write(backup_dir .. name, text)
    if not ok then return false, why end
    storage.prune(fs, backup_dir, prefix, keep)
    return true, name
end

-- 形式更新の前のバックアップ（名前に旧版を入れる）
function storage.schema_backup(fs, path, backup_dir, prefix, old_schema, t)
    fs.mkdir(backup_dir)
    local text = fs.read(path)
    if not text then return false, 'read failed' end
    local name = string.format('%sschema%s-%s.json', prefix, tostring(old_schema), util.stamp(t))
    return fs.write(backup_dir .. name, text)
end

function storage.prune(fs, backup_dir, prefix, keep)
    local list = storage.list_backups(fs, backup_dir, prefix)
    for i = (keep or 10) + 1, #list do
        fs.remove(backup_dir .. list[i])
    end
end

return storage
