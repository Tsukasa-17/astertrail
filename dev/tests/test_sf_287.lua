-- 0.1.287：新しい版を見つけたら offer の仕事を作り、お知らせ窓から更新できる
require('fake_env')

local update = require('src.core.update')
local sha256 = require('src.lib.sha256')
local app = require('src.app')
eq(app.VERSION, '1.1.292', 'version')

-- version_in は版だけ。zip_url / sha256 は manifest_in
local real_body = [[{
  "version": "1.1.285",
  "zip_url": "https://github.com/Tsukasa-17/astertrail/releases/download/v1.1.285/astertrail-ui-1.1.285.zip",
  "sha256": "95e9f04685ab18ff19c3ff268ce938011144af31183a6780bd0d144746075bb9"
}
]]
eq(update.version_in(real_body), '1.1.285', 'version_in returns only the version')
local man = update.manifest_in(real_body)
check(man and man.version == '1.1.285', 'manifest_in version')
eq(man.zip_url, 'https://github.com/Tsukasa-17/astertrail/releases/download/v1.1.285/astertrail-ui-1.1.285.zip', 'manifest_in zip_url')
eq(man.sha256, '95e9f04685ab18ff19c3ff268ce938011144af31183a6780bd0d144746075bb9', 'manifest_in sha256')
check(not update.newer('1.1.285', app.VERSION), '1.1.285 is not newer than this public build')
check(update.newer('1.1.293', app.VERSION), '1.1.293 is newer than this build')

local src = io.open(ROOT .. '/src/app.lua', 'r'):read('*a')
local i_check = src:find('function app.check_update', 1, true)
check(i_check ~= nil, 'check_update exists')
local chunk = src:sub(i_check, i_check + 1800)
check(chunk:find('manifest_in', 1, true) ~= nil, 'check_update uses manifest_in for zip_url/sha256')
check(chunk:find("status = 'offer'", 1, true) ~= nil, 'check_update creates an offer job')
check(chunk:find('zip_url = man', 1, true) ~= nil, 'offer job stores zip_url')
check(chunk:find('sha256 = man', 1, true) ~= nil, 'offer job stores sha256')

update.URL = ''  -- 空のときの動きを先に見る。公開版の URL はあとで app._update_url に足す
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local platform = require('src.platform.ashita')
local http_calls = {}
platform.http_get = function (url, cb)
    http_calls[#http_calls + 1] = url
    FAKE.http_cb = cb
    return true
end
FAKE.player = { name = 'Sf287', zone = 230, tidx = 5, status = 0 }
frames(1)
check(app.state.ready, 'logged in')
eq(app.state.update, nil, 'empty URL: no job yet')
check(not app.start_update(), 'start_update returns early without a job')

local S = app._settings()
S.update_notice.enabled = true
app.state.update_checked = false
app._update_url = 'https://raw.githubusercontent.com/Tsukasa-17/astertrail/main/version.json'
FAKE.http_cb = nil
FAKE.printed = {}
frame()
eq(#http_calls, 1, 'one version.json request')
check(FAKE.http_cb ~= nil, 'http_get callback kept')

-- 仕事が作られること（version.json の形は 1.1.285 と同じ。版だけ新しい）
local offer_body = [[{
  "version": "1.1.293",
  "zip_url": "https://github.com/Tsukasa-17/astertrail/releases/download/v1.1.293/astertrail-ui-1.1.293.zip",
  "sha256": "95e9f04685ab18ff19c3ff268ce938011144af31183a6780bd0d144746075bb9"
}
]]
FAKE.http_cb(offer_body)
local job = app.state.update
check(job ~= nil, 'job is created when a newer version is found')
eq(job.status, 'offer', 'job status is offer')
eq(job.version, '1.1.293', 'job version')
eq(job.current, app.VERSION, 'job remembers the current version')
eq(job.zip_url, 'https://github.com/Tsukasa-17/astertrail/releases/download/v1.1.293/astertrail-ui-1.1.293.zip', 'job zip_url')
eq(job.sha256, '95e9f04685ab18ff19c3ff268ce938011144af31183a6780bd0d144746075bb9', 'job sha256')
eq(app.state.update_found, '1.1.293', 'update_found still set')
check(printed('新しい版 1.1.293 があります（いまは 1.1.292）。'), 'chat line still printed')

-- お知らせ窓が出て、「ダウンロードして更新」「あとで」がある
local popup = require('src.ui.update_popup')
check(popup.visible({ state = app.state }), 'popup.visible is true for the offer job')
frame()
check(texted('新しい版があります') or texted('A new version is available'), 'popup title')
check(texted('ダウンロードして入れられます') or texted('can be downloaded'), 'popup body with zip')
check(labeled('ダウンロードして更新') or labeled('Download and update'), 'download button')
check(labeled('あとで') or labeled('Later'), 'later button')

-- zip_url が無いときは案内だけの窓（閉じる）。start_update は no_zip
app.state.update_checked = false
app.state.update = nil
FAKE.http_cb = nil
FAKE.printed = {}
frame()
FAKE.http_cb('{"version":"1.1.293"}')
job = app.state.update
check(job and job.status == 'offer', 'job is still created without zip_url')
eq(job.zip_url, nil, 'no zip_url in the job')
eq(job.sha256, nil, 'no sha256 without a zip')
check(popup.visible({ state = app.state }), 'notice-only popup is visible')
frame()
check(texted('ダウンロードの場所が書かれていません') or texted('no download location'), 'notice-only body')
check(not (labeled('ダウンロードして更新') or labeled('Download and update')), 'no download button without zip_url')
check(labeled('閉じる') or labeled('Close'), 'close button on notice-only popup')
check(not app.start_update(), 'start_update refuses without zip_url')
eq(app.state.update.status, 'failed', 'missing zip is a no_zip failure')
eq(app.state.update.error, 'no_zip', 'error code is no_zip')
app.update_later()

-- 端から端まで：お知らせ → ダウンロード → 展開 → 入れ替え → 再読み込み
-- （ハッシュはモック zip に合わせ、JSON の形は 1.1.285 と同じ）
local function mkdir(p) os.execute('mkdir -p "' .. p .. '"'); return true end
local function write(p, s)
    local f, e = io.open(p, 'wb'); if not f then return nil, e end
    f:write(s); f:close(); return true
end
local function read(p)
    local f = io.open(p, 'rb'); if not f then return nil end
    local s = f:read('*a'); f:close(); return s
end
local zip_path = '/tmp/at282/sample.zip'
local raw = read(zip_path)
check(raw and #raw > 0, 'sample zip present for mocked download')
local digest = sha256.of_string(raw)
local work = '/tmp/at287_live'
os.execute('rm -rf "' .. work .. '"')
mkdir(work .. '/addon/src')
mkdir(work .. '/tmp')
write(work .. '/addon/astertrail.lua', "addon.version = '0.1.287'\n")
write(work .. '/addon/src/app.lua', "VERSION = '0.1.287'\n")
local e2e_body = string.format(
    '{"version":"1.1.293","zip_url":"https://github.com/Tsukasa-17/astertrail/releases/download/v1.1.293/astertrail-ui-1.1.293.zip","sha256":"%s"}',
    digest)
platform.http_get = function (url, cb) FAKE.http_cb = cb; return true end
platform.http_download = function (url, path, cb)
    FAKE.dl_url = url
    FAKE.dl_path = path
    local f = io.open(path, 'wb'); f:write(raw); f:close()
    cb(path)
    return true
end
platform.addon_dir = function () return work .. '/addon/' end
platform.config_dir = function () return work .. '/config/' end
platform.temp_dir = function () return work .. '/tmp/' end
platform.chat_run = function (line)
    FAKE.reload_cmd = line
    return true
end
app.state.update_checked = false
app.state.update = nil
FAKE.http_cb = nil
FAKE.dl_url, FAKE.reload_cmd = nil, nil
frame()
FAKE.http_cb(e2e_body)
job = app.state.update
check(job and job.status == 'offer' and job.zip_url, 'e2e: offer job with zip_url')
eq(job.sha256, digest, 'e2e: sha256 matches the mocked zip')
check(popup.visible({ state = app.state }), 'e2e: popup is visible before download')
frame()
check(labeled('ダウンロードして更新') or labeled('Download and update'), 'e2e: download button shown')
check(app.start_update(), 'e2e: start_update began')
eq(FAKE.dl_url, job.zip_url, 'e2e: downloaded the parsed zip_url')
eq(app.state.update.status, 'reload', 'e2e: reload after successful swap')
eq(FAKE.reload_cmd, '/addon reload astertrail', 'e2e: auto-reload via chat.run')
check((read(work .. '/addon/astertrail.lua') or ''):find('0.1.282', 1, true), 'e2e: addon file replaced from the zip')
check(not (read(work .. '/addon/astertrail.lua') or ''):find('0.1.287', 1, true), 'e2e: old file is gone')

app._update_url = nil
print('test_sf_287 ok')
