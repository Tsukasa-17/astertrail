-- テスト用の小道具
T_PASSED = 0
function check(cond, msg)
    if not cond then error('check failed: ' .. tostring(msg), 2) end
    T_PASSED = T_PASSED + 1
end
function eq(a, b, msg)
    if a ~= b then error(('expected %s, got %s: %s'):format(tostring(b), tostring(a), tostring(msg)), 2) end
    T_PASSED = T_PASSED + 1
end

-- Windows 風（\）のパスをこの箱の / に直してから io と os を使う
local function fix(p) return (p:gsub('\\', '/')) end
local real_open, real_rename, real_remove = io.open, os.rename, os.remove
function posix_fs()
    local fs = { sep = '/' }
    function fs.read(p) local f, e = real_open(p, 'rb'); if not f then return nil, e end local s = f:read('*a'); f:close(); return s end
    function fs.write(p, s) local f, e = real_open(p, 'wb'); if not f then return nil, e end f:write(s); f:close(); return true end
    function fs.exists(p) local f = real_open(p, 'rb'); if f then f:close(); return true end
        local ok = os.execute('test -d "' .. p .. '"'); return ok == 0 or ok == true end
    function fs.remove(p) local ok, e = real_remove(p); if ok then return true end return nil, e end
    function fs.rename(a, b) local ok, e = real_rename(a, b); if ok then return true end return nil, e end
    function fs.mkdir(p) os.execute('mkdir -p "' .. p .. '"'); return true end
    function fs.list(d)
        local out = {}
        local h = io.popen('ls -1 "' .. d .. '" 2>/dev/null')
        for line in h:lines() do if line:match('%.json$') then out[#out + 1] = line end end
        h:close(); return out
    end
    return fs
end
function install_backslash_io()
    io.open = function (p, m) return real_open(fix(p), m) end
    os.rename = function (a, b) return real_rename(fix(a), fix(b)) end
    os.remove = function (p) return real_remove(fix(p)) end
end
return { fix = fix }
