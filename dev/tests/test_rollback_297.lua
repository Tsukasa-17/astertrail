-- 0.1.297: 前のバージョンをとっておく（backups\cur・backups\prev）・戻す、設定の「更新」
require('fake_env')
local json = require('src.lib.json')
local sha256 = require('src.lib.sha256')
local B = require('src.core.install_backup')
local update = require('src.core.update')

-- 覚えておくだけのファイル置き場（区切りは \）
local function memfs()
    local files, dirs = {}, {}
    local fs = { sep = '\\', files = files, fail_copy = nil }
    function fs.read(p) return files[p] end
    function fs.write(p, s) files[p] = s; return true end
    function fs.exists(p) return files[p] ~= nil or dirs[p] == true end
    function fs.mkdir(p) dirs[p] = true; return true end
    function fs.remove(p) files[p] = nil; return true end
    function fs.copy(a, b)
        if fs.fail_copy and b:find(fs.fail_copy, 1, true) then return nil, 'disk' end
        if files[a] == nil then return nil, 'missing' end
        files[b] = files[a]; return true
    end
    return fs
end

local ROOTD = 'C:\\A\\astertrail'
local function p(rel) return ROOTD .. '\\' .. rel:gsub('/', '\\') end

local function install(fs, version, list)
    local out = {}
    for rel, body in pairs(list) do
        fs.files[p(rel)] = body
        out[#out + 1] = { path = rel, sha256 = sha256.of_string(body) }
    end
    table.sort(out, function (a, b) return a.path < b.path end)
    fs.files[p('install_files.json')] = json.encode({ version = version, files = out })
end

local fs = memfs()
install(fs, '0.1.296', { ['astertrail.lua'] = 'v296', ['src/app.lua'] = 'app296', ['data/x.json'] = 'x296' })
fs.files[p('settings.json')] = 'MY SETTINGS'
fs.files[p('progress_Test.json')] = 'MY PROGRESS'

-- 一覧から守るものは外れる
eq(B.clean_rel('settings/a.json'), nil, 'settings protected')
eq(B.clean_rel('backups/prev/x'), nil, 'backups protected')
eq(B.clean_rel('../x'), nil, 'unsafe')
eq(B.clean_rel('src\\app.lua'), 'src/app.lua', 'backslash normalised')
eq(update.is_protected('backups/cur/manifest.json'), true, 'update never touches backups')

-- はじめて読み込んだ：いまを cur へ
local jobs, how = B.plan_on_load(ROOTD, fs, '0.1.296')
eq(how, 'first', 'first load')
eq(#jobs, 1, 'one job')
local st = jobs[1]:step(1)
eq(st, 'run', 'step in chunks')
repeat st = jobs[1]:step(1) until st ~= 'run'
eq(st, 'done', 'snapshot done')
local cur = B.read_manifest(p('backups\\cur'), fs)
eq(cur.version, '0.1.296', 'cur version')
eq(#cur.files, 4, 'cur files incl. list')
eq(fs.files[p('backups\\cur\\settings.json')], nil, 'settings not copied')
eq(B.prev_info(ROOTD, fs, '0.1.296'), nil, 'no prev yet')
local again = B.plan_on_load(ROOTD, fs, '0.1.296')
eq(#again, 0, 'same version: nothing')

-- 手で 0.1.297 を入れた（ファイルが一つ増えた）→ cur を prev へ、いまを cur へ
install(fs, '0.1.297', { ['astertrail.lua'] = 'v297', ['src/app.lua'] = 'app297', ['data/x.json'] = 'x297',
    ['src/core/install_backup.lua'] = 'new297' })
jobs, how = B.plan_on_load(ROOTD, fs, '0.1.297')
eq(how, 'rotate', 'rotate')
eq(#jobs, 2, 'cur->prev, now->cur')
for _, j in ipairs(jobs) do check(j:run_all(), 'job ok') end
local prev = B.prev_info(ROOTD, fs, '0.1.297')
eq(prev and prev.version, '0.1.296', 'prev is 0.1.296')
eq(fs.files[p('backups\\prev\\src\\app.lua')], 'app296', 'prev holds old file')
eq(B.read_manifest(p('backups\\cur'), fs).version, '0.1.297', 'cur now 0.1.297')

-- 戻す：古いファイルに戻り、増えたファイルは消え、設定・進行はそのまま
local r, why = B.restore(ROOTD, fs, { rollback_dir = 'C:\\T\\rb', config_dir = 'C:\\A\\config' })
check(r, 'restore ok ' .. tostring(why))
eq(r and r.version, '0.1.296', 'restored version')
eq(fs.files[p('src\\app.lua')], 'app296', 'file restored')
eq(fs.files[p('astertrail.lua')], 'v296', 'entry restored')
eq(fs.files[p('src\\core\\install_backup.lua')], nil, 'added file removed')
eq(fs.files[p('settings.json')], 'MY SETTINGS', 'settings untouched')
eq(fs.files[p('progress_Test.json')], 'MY PROGRESS', 'progress untouched')
eq(B.read_list(ROOTD, fs).version, '0.1.296', 'list is the old one again')

-- 壊れた写しは戻さない（いまのまま）
install(fs, '0.1.297', { ['astertrail.lua'] = 'v297', ['src/app.lua'] = 'app297', ['data/x.json'] = 'x297' })
fs.files[p('backups\\prev\\src\\app.lua')] = 'tampered'
local r2, why2 = B.restore(ROOTD, fs, { rollback_dir = 'C:\\T\\rb2' })
eq(r2, nil, 'tampered: refused')
eq(why2, 'hash', 'reason hash')
eq(fs.files[p('src\\app.lua')], 'app297', 'current kept on refusal')
fs.files[p('backups\\prev\\src\\app.lua')] = 'app296'

-- 入れ替えの途中で失敗したら、いまに戻す（update.swap の退避）
fs.fail_copy = ROOTD .. '\\data\\'
local r3 = B.restore(ROOTD, fs, { rollback_dir = 'C:\\T\\rb3' })
eq(r3, nil, 'swap failure')
fs.fail_copy = nil
eq(fs.files[p('src\\app.lua')], 'app297', 'current restored after swap failure')
eq(fs.files[p('data\\x.json')], 'x297', 'current data kept')

-- manifest が無い写しは使わない（写しの途中で止まった）
fs.files[p('backups\\prev\\manifest.json')] = nil
eq(B.prev_info(ROOTD, fs, '0.1.297'), nil, 'no manifest: no rollback')
-- install_files.json が無い古い入れ方：何もしない
local fs2 = memfs()
fs2.files[p('astertrail.lua')] = 'old'
local j2, h2 = B.plan_on_load(ROOTD, fs2, '0.1.290')
eq(#j2, 0, 'no list: no jobs'); eq(h2, 'no list', 'no list reason')

-- 設定の「更新」の一行
local panel = require('src.ui.update_panel_ui')
local T = { ['update.status_current'] = 'cur {cur}。', ['update.status_latest'] = '最新',
    ['update.status_unsupported'] = '確認しない', ['update.status_offer'] = '新 {v}', ['update.status_checking'] = '確認中' }
local function t(k, v) local s = T[k] or k; return (s:gsub('{(%w+)}', function (n) return v and v[n] or '' end)) end
local ui = { t = t, addon_version = '0.1.297', update_check_status = function () return { status = 'unsupported' } end }
eq(panel.status_line(ui), 'cur 0.1.297。確認しない', 'local build line')
ui.update_check_status = function () return { status = 'latest', version = '1.1.297' } end
eq(panel.status_line(ui), 'cur 0.1.297。最新', 'latest line')
ui.update_check_status = function () return { status = 'offer', version = '1.1.300' } end
eq(panel.status_line(ui), 'cur 0.1.297。新 1.1.300', 'offer line')

-- ボタン：戻せるときだけ「x に戻す」、確認できないときは「今すぐ確認」なし、更新は sha256 があるときだけ
local function draw(u)
    local seen = {}
    panel.draw(u, 'settings', {
        toggle = function () end, text = function () end,
        button = function (_, id, label, o) seen[#seen + 1] = id .. (o and o.disabled and '(off)' or '') .. '=' .. label; return false end,
    })
    return table.concat(seen, ',')
end
ui.settings = {}
ui.update_check_status = function () return { status = 'unsupported' } end
eq(draw(ui), '', 'unsupported, no backup: no buttons')
ui.rollback_prev = function () return { version = '0.1.296' } end
eq(draw(ui), '', '0.1.301: local test build in prev: no rollback button')
ui.rollback_prev = function () return { version = '1.1.292' } end
eq(draw(ui), 'upd_rollback=update.rollback_button', 'rollback button only (public prev)')
ui.update_check_status = function () return { status = 'offer', version = '1.1.300' } end
ui.update_check_wait = function () return 30 end
ui.state = { update = { status = 'later', zip_url = 'https://x/z.zip', sha256 = string.rep('a', 64) } }
ui.rollback_prev = nil
eq(draw(ui), 'upd_now=update.update_now,upd_check(off)=update.check_now', 'update + check (waiting)')
ui.state.update.sha256 = nil
eq(draw(ui), 'upd_check(off)=update.check_now', 'no sha: no update button')

-- 言葉：「版」を使わない
for _, lang in ipairs({ 'ja' }) do
    local f = io.open(ROOT .. '/locales/' .. lang .. '.json', 'rb'); local s = f:read('*a'); f:close()
    local d = json.decode(s)
    for _, k in ipairs({ 'update.status_current', 'update.rollback_body', 'update.err_rollback', 'settings.update_title', 'update.check_now' }) do
        check(type(d[k]) == 'string' and not d[k]:find('版'), 'ja ' .. k)
    end
end

-- アプリ：確認の窓・sha256 の無いダウンロードはしない・「今すぐ確認」は 60 秒に 1 回
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local platform = require('src.platform.ashita')
local calls = 0
platform.http_get = function (url, cb) calls = calls + 1; FAKE.http_cb = cb; return true end
FAKE.player = { name = 'Rb297', zone = 230, tidx = 5, status = 0 }
frames(1)
check(app.state.ready, 'logged in')
if tostring(app.VERSION):match('^0%.') then
    eq(app.update_check_status().status, 'unsupported', 'local build: no check')
    check(not app.check_update_now(), 'local build: check now does nothing')
else
    -- 公開版（1.1.x）：確かめる場所があるので確かめる
    check(app.update_check_status().status ~= 'unsupported', 'public build: checks')
    -- 読み込みのときの確認を終わらせて、下の「今すぐ確認」を初めから試す
    if FAKE.http_cb then FAKE.http_cb('{"version":"' .. app.VERSION .. '"}') end
    app.state.update_check, app.state.update_check_at = nil, nil
    calls = 0
end
check(not app.ask_rollback(), 'no backup in this tree: no rollback')
app._update_url = 'https://example.com/astertrail/version.json'
check(app.check_update_now(), 'check now starts')
eq(app.update_check_status().status, 'checking', 'checking')
FAKE.http_cb('{"version":"0.1.297"}')
eq(app.update_check_status().status, 'latest', 'latest')
local ok2, left = app.check_update_now()
check(not ok2 and left and left > 50, 'rate limited')
frames(61)
check(app.check_update_now(), 'after 60 s: again')
eq(calls, 2, 'two requests')
FAKE.http_cb('{"version":"1.1.400","zip_url":"https://example.com/z.zip"}')
eq(app.update_check_status().status, 'offer', 'offer')
check(not app.start_update(), 'no sha256: refused')
eq(app.state.update.error, 'no_sha', 'no_sha error')
app._update_url = nil
-- 戻す確認の窓
app.state.update = { kind = 'rollback', status = 'confirm', version = '0.1.296', current = '0.1.297' }
FAKE.texts, FAKE.labels = {}, {}
frame(); frame()
check(texted('バージョン 0.1.296 に戻します'), 'rollback confirm body')
check(labeled('戻す') and labeled('やめる'), 'rollback buttons')
check(not app.start_rollback(), 'no backup: rollback fails safely')
eq(app.state.update.status, 'failed', 'failed state')
eq(app.state.update.error, 'rollback', 'rollback error')
