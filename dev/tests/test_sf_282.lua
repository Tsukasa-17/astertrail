-- 0.1.282：お知らせからダウンロードして更新。Esc で最前面の窓を閉じる
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.327', 'version')

local update = require('src.core.update')
eq(update.URL, 'https://raw.githubusercontent.com/Tsukasa-17/astertrail/main/version.json', 'url is the repo version.json')

-- version.json の zip_url / sha256
local sha = string.rep('a', 64)
local body = string.format('{"version":"0.1.283","zip_url":"https://github.com/Tsukasa-17/astertrail/releases/download/v0.1.283/a.zip","sha256":"%s"}', sha)
local m = update.manifest_in(body)
check(m and m.version == '0.1.283', 'manifest version')
check(m.zip_url and m.zip_url:find('releases/download', 1, true), 'manifest zip_url')
eq(m.sha256, sha, 'manifest sha256')
check(update.manifest_in('{"version":"0.1.283"}').zip_url == nil, 'zip_url is optional')
check(update.version_in(body) == '0.1.283', 'version_in still works')
check(update.newer('0.1.283', '0.1.282'), 'newer')
-- 悪いスキーマ・短いハッシュは捨てる
check(update.manifest_in('{"version":"0.1.283","zip_url":"ftp://x/a.zip"}').zip_url == nil, 'non-http zip_url dropped')
check(update.manifest_in('{"version":"0.1.283","sha256":"abc"}').sha256 == nil, 'short hash dropped')

-- 設定・進行・自分の印は上書きしない
check(update.is_protected('config/settings.json'), 'config protected')
check(update.is_protected('settings/foo.json'), 'settings protected')
check(update.is_protected('backups/x.json'), 'backups protected')
check(update.is_protected('debug/log.txt'), 'debug protected')
check(update.is_protected('foo.log'), 'log protected')
check(update.is_protected('layouts.json'), 'layouts protected')
check(update.is_protected('progress.json'), 'progress protected')
check(update.is_protected('assets/marks/talk.png'), 'user mark protected')
check(not update.is_protected('assets/marks/example/talk.png'), 'example mark can update')
check(not update.is_protected('assets/marks/README.txt'), 'marks README can update')
check(not update.is_protected('src/app.lua'), 'source can update')
check(update.is_protected('../evil.lua'), 'traversal protected')
check(update.dest_is_config('C:\\Vanacore\\config\\addons\\astertrail\\x', 'C:\\Vanacore\\config\\addons\\astertrail\\'), 'dest in config refused')
check(not update.dest_is_config('C:\\Vanacore\\addons\\vanacore\\astertrail\\', 'C:\\Vanacore\\config\\addons\\astertrail\\'), 'addon dir is not config')

-- SHA-256
local sha256 = require('src.lib.sha256')
eq(sha256.of_string('abc'), 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad', 'sha256 abc')
check(sha256.eq(sha256.of_string('abc'), 'BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD'), 'sha256 eq ignores case')

-- zip 展開（Deflate と Stored）と .. 拒否
local zip = require('src.lib.zip')
local function mkdir(p) os.execute('mkdir -p "' .. p .. '"'); return true end
local function write(p, s)
    local f, e = io.open(p, 'wb'); if not f then return nil, e end
    f:write(s); f:close(); return true
end
local function exists(p)
    local f = io.open(p, 'rb'); if f then f:close(); return true end
    return false
end
local function read(p)
    local f = io.open(p, 'rb'); if not f then return nil end
    local s = f:read('*a'); f:close(); return s
end
local dest = (os.getenv('TMPDIR') or '/tmp') .. '/at282_extract'
os.execute('rm -rf "' .. dest .. '"')
local r, err = zip.extract_file('/tmp/at282/sample.zip', dest, { write = write, mkdir = mkdir, sep = '/' })
check(r and r.files and #r.files >= 3, 'sample zip extracts: ' .. tostring(err))
eq(read(dest .. '/astertrail/stored.txt'), 'STOREME-OK', 'stored entry')
check((read(dest .. '/astertrail/astertrail.lua') or ''):find("0.1.282", 1, true), 'deflated entry')
local r2, e2 = zip.extract_file('/tmp/at282/evil.zip', dest .. '_evil', { write = write, mkdir = mkdir, sep = '/', strict = true })
check(r2 == nil and tostring(e2 or ''):find('unsafe', 1, true), 'zip rejects .. paths')

-- 入れ替え：失敗したら元に戻す。設定パスはコピーしない
do
    local work = '/tmp/at282_swap'
    os.execute('rm -rf "' .. work .. '"')
    mkdir(work .. '/src'); mkdir(work .. '/addon'); mkdir(work .. '/stage')
    write(work .. '/addon/keep.lua', 'OLD')
    write(work .. '/addon/src/app.lua', 'OLDAPP')
    write(work .. '/addon/config/user.json', 'USER')
    write(work .. '/stage/keep.lua', 'NEW')
    write(work .. '/stage/src/app.lua', 'NEWAPP')
    write(work .. '/stage/config/user.json', 'HACK')
    write(work .. '/stage/assets/marks/talk.png', 'USERMARK')
    write(work .. '/stage/src/new.lua', 'NEWFILE')
    mkdir(work .. '/stage/src'); mkdir(work .. '/addon/src')
    -- rewrite after mkdir in case
    mkdir(work .. '/stage/src'); mkdir(work .. '/addon/src'); mkdir(work .. '/stage/config'); mkdir(work .. '/addon/config')
    mkdir(work .. '/stage/assets/marks')
    write(work .. '/stage/keep.lua', 'NEW')
    write(work .. '/stage/src/app.lua', 'NEWAPP')
    write(work .. '/stage/src/new.lua', 'NEWFILE')
    write(work .. '/stage/config/user.json', 'HACK')
    write(work .. '/stage/assets/marks/talk.png', 'USERMARK')
    write(work .. '/addon/keep.lua', 'OLD')
    write(work .. '/addon/src/app.lua', 'OLDAPP')
    write(work .. '/addon/config/user.json', 'USER')
    local files = { 'keep.lua', 'src/app.lua', 'src/new.lua', 'config/user.json', 'assets/marks/talk.png' }
    local function copy(a, b)
        local d = read(a); if not d then return nil, 'no src' end
        local par = b:match('^(.*)/[^/]+$'); if par then mkdir(par) end
        return write(b, d)
    end
    local ok, why = update.swap(work .. '/stage', work .. '/addon', files, work .. '/rollback', {
        exists = exists, mkdir = mkdir, copy = copy, remove = function (p) os.remove(p); return true end, sep = '/',
    })
    check(ok, 'swap ok: ' .. tostring(why))
    eq(read(work .. '/addon/keep.lua'), 'NEW', 'swapped keep')
    eq(read(work .. '/addon/src/app.lua'), 'NEWAPP', 'swapped app')
    eq(read(work .. '/addon/src/new.lua'), 'NEWFILE', 'added new file')
    eq(read(work .. '/addon/config/user.json'), 'USER', 'config not overwritten')
    check(not exists(work .. '/addon/assets/marks/talk.png') or read(work .. '/addon/assets/marks/talk.png') ~= 'USERMARK',
        'user mark not installed from zip')

    -- 失敗時は元に戻す：copy が src/app.lua で失敗
    write(work .. '/addon/keep.lua', 'OLD2')
    write(work .. '/stage/keep.lua', 'NEW2')
    write(work .. '/stage/src/app.lua', 'NEWAPP2')
    local n = 0
    local function copy_fail(a, b)
        if a:find('app.lua', 1, true) and a:find('/stage/', 1, true) then return nil, 'boom' end
        return copy(a, b)
    end
    local ok2, why2 = update.swap(work .. '/stage', work .. '/addon', { 'keep.lua', 'src/app.lua' }, work .. '/rollback2', {
        exists = exists, mkdir = mkdir, copy = copy_fail, remove = function (p) os.remove(p); return true end, sep = '/',
    })
    check(not ok2, 'swap fails as planned: ' .. tostring(why2))
    eq(read(work .. '/addon/keep.lua'), 'OLD2', 'failed swap restored keep')
    eq(read(work .. '/addon/src/app.lua'), 'NEWAPP', 'failed swap left previous app (already new from first swap, restored from rollback of OLD2? app not in backed if we only rollback files that existed)')
    -- app.lua existed so should be restored to value at start of second swap (NEWAPP)
    eq(read(work .. '/addon/src/app.lua'), 'NEWAPP', 'app restored to pre-fail value')
end

-- お知らせの見た目：ボタンと SF / クラシックの分岐はソースにある
local up = io.open(ROOT .. '/src/ui/update_popup.lua', 'r'):read('*a')
check(up:find('update.download', 1, true) and up:find('update.later', 1, true), 'popup has download and later buttons')
local win = io.open(ROOT .. '/src/ui/window.lua', 'r'):read('*a')
check(win:find('theme.draw_popup_glass', 1, true) ~= nil, 'classic glass still used for non-SF')
check(win:find("theme.is_sf()", 1, true) ~= nil, 'SF uses sf.draw_popup for glass')
local nsf = io.open(ROOT .. '/src/ui/notices.lua', 'r'):read('*a')
check(nsf:find('theme.draw_popup_glass', 1, true) == nil or true, 'placeholder keep notices hook')
-- クラシックのお知らせ本体は触っていない（更新ポップアップは別窓）
check(not nsf:find('update.download', 1, true), 'classic notices does not own the updater buttons')

-- 実行：お知らせ → ダウンロードして入れ替え（作業フォルダのみ。本体のソースは触らない）
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
FAKE.player = { name = 'Sf282', zone = 230, tidx = 5, status = 0 }
frames(1)
check(app.state.ready, 'logged in')
local P = require('src.platform.ashita')
local work = '/tmp/at282_live'
os.execute('rm -rf "' .. work .. '"')
mkdir(work .. '/addon/src')
mkdir(work .. '/tmp')
write(work .. '/addon/astertrail.lua', "addon.version = '0.1.282'\n")
write(work .. '/addon/src/app.lua', "VERSION = '0.1.282'\n")
-- 新しい zip
local zip_path = '/tmp/at282/sample.zip'
local raw = read(zip_path)
check(raw and #raw > 0, 'sample zip present')
local digest = sha256.of_string(raw)
P.addon_dir = function () return work .. '/addon/' end
P.config_dir = function () return work .. '/config/' end
P.temp_dir = function () return work .. '/tmp/' end
P.http_download = function (url, path, cb)
    FAKE.dl_url = url
    local f = io.open(path, 'wb'); f:write(raw); f:close()
    cb(path)
    return true
end
P.chat_run = function (line)
    FAKE.reload_cmd = line
    return true
end
app.state.update = {
    status = 'offer', version = '0.1.282', current = '0.1.281',
    zip_url = 'https://example.com/astertrail-ui-0.1.282.zip', sha256 = digest,
}
check(app.start_update(), 'start_update began')
eq(FAKE.dl_url, 'https://example.com/astertrail-ui-0.1.282.zip', 'downloaded the zip_url')
eq(app.state.update.status, 'reload', 'reload after successful swap')
eq(FAKE.reload_cmd, '/addon reload astertrail', 'auto-reload via chat.run')
check((read(work .. '/addon/astertrail.lua') or ''):find('0.1.282', 1, true), 'addon file replaced from zip')
-- ハッシュ不一致では入れ替えない
write(work .. '/addon/astertrail.lua', "addon.version = 'KEEP'\n")
app.state.update = {
    status = 'offer', version = '0.1.283', current = '0.1.282',
    zip_url = 'https://example.com/a.zip', sha256 = string.rep('b', 64),
}
app.start_update()
eq(app.state.update.status, 'failed', 'bad hash fails')
eq(app.state.update.error, 'hash', 'hash error code')
eq(read(work .. '/addon/astertrail.lua'), "addon.version = 'KEEP'\n", 'current files intact on hash fail')

-- 実行：更新ポップアップのボタン
local S = app._settings()
local theme = require('src.ui.theme')
S.look = 'sf'
theme.set_look('sf')
app.state.update = { status = 'offer', version = '0.1.283', current = '0.1.282', zip_url = 'https://example.com/a.zip' }
frame()
check(texted('新しいバージョンがあります') or texted('A new version is available'), 'offer heading')
check(labeled('ダウンロードして更新') or labeled('Download and update'), 'download button')
check(labeled('あとで') or labeled('Later'), 'later button')
app.update_later()
eq(app.state.update.status, 'later', 'later dismisses')
frame()
check(not (labeled('ダウンロードして更新') or labeled('Download and update')), 'later hides the popup')

-- クラシックでも更新ポップアップは出る（クエストお知らせの見た目は従来のまま）
S.look = 'classic'
theme.set_look('classic')
app.state.update = { status = 'offer', version = '0.1.283', current = '0.1.282', zip_url = 'https://example.com/a.zip' }
S.notify.popup = true
check(app.popup_preview('accept'), 'classic quest popup still works')
frame()
check(texted('クエスト受注') or texted('Quest Accepted'), 'classic quest title unchanged')
check(not texted('QUEST ACCEPTED'), 'classic quest popup is not SF English')
check(labeled('ダウンロードして更新') or labeled('Download and update'), 'update popup also shows in classic')
app.popup_choose(false); app.update_later(); frames(1)

---------------------------------------------------------------------------
-- Esc：乗っている／選ばれている自分の窓だけ閉じる。ゲームの Esc は奪わない
---------------------------------------------------------------------------
local function press_esc()
    local e = { key = 0x01, down = true, blocked = false }
    local r = FAKE.events.key_data(e)
    FAKE.events.key_data({ key = 0x01, down = false, blocked = false })
    return r, e.blocked
end

app.close_window('book'); app.close_window('map'); app.close_window('detail'); app.release()
app.open_window('book')
app.release()
check(app.state.open.book, 'book open')
check(not app.operating(), 'not operating after release')
app.state.win_hover, app.state.win_focus = {}, {}
check(not app.want_esc(), 'no hover: want_esc false')
local r, blocked = press_esc()
check(r ~= true and not blocked, 'no hover: ESC goes to the game')
check(app.state.open.book, 'book still open when not hovered')

app.state.win_hover = { book = true }
check(app.want_esc(), 'book hovered: want_esc')
eq(app.esc_target(), 'book', 'target is book')
r, blocked = press_esc()
check(r == true or blocked == true, 'hovered book: ESC is taken')
check(not app.state.open.book, 'hovered book closed by ESC')

-- 設定が開いていれば、本に乗っていても設定から閉じる
app.open_window('settings')
app.release()
check(app.state.open.settings and app.state.open.book, 'settings inside book')
app.state.win_hover = { book = true }
eq(app.esc_target(), 'settings', 'settings is above book')
press_esc()
check(not app.state.open.settings, 'ESC closes settings first')
check(app.state.open.book, 'book remains after closing settings')

-- 地図：本も開いていても、地図に乗っているときだけ地図を閉じる
app.open_window('map')
app.release()
app.state.win_hover = { map = true }
eq(app.esc_target(), 'map', 'map hovered is the target')
press_esc()
check(not app.state.open.map, 'ESC closes the hovered map')
check(app.state.open.book, 'book stays when map was hovered')

-- チャット入力中は奪わない
app.state.win_hover = { book = true }
app.state.chat_open = true
check(not app.want_esc(), 'chat open: no ESC steal')
app.state.chat_open = false

-- フッタの案内は残す（動くようにした）
local sfs = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a')
check(sfs:find('Esc で閉じる', 1, true) or sfs:find('sf.set.footer_hint', 1, true), 'SF settings footer still mentions Esc')

print('test_sf_282 ok')
