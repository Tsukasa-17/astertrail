-- 0.1.304：クラシック・YunaUI の設定もアストラルと同じ並び。
-- お知らせ（POPUP・UPDATES）とマイレイアウト（LAYOUTS）は見た目へ。お知らせの分類はなくした（キーは同じ）
require('fake_env')
dofile(ROOT .. '/astertrail.lua')
FAKE.events.load()
local app = require('src.app')
local focus = require('src.ui.focus')
local sui = require('src.ui.settings_ui')
local theme = require('src.ui.theme')
FAKE.player = { name = 'Rb304', zone = 230, tidx = 5, status = 0 }
frames(1)
eq(app.VERSION, '1.1.327', 'version')
eq(addon.version, app.VERSION, 'lua matches')
local S = app._settings()

local function has_label(p) for _, l in ipairs(FAKE.labels) do if l:find(p, 1, true) then return true end end return false end
local function in_list(id)
    for _, it in ipairs((focus.windows.settings and focus.windows.settings.list) or {}) do
        if it.id == id then return true end
    end
    return false
end

local src = io.open(ROOT .. '/src/ui/settings_sf.lua', 'r'):read('*a')
check(not src:find("key = 'notify'", 1, true), 'no notify category in CATS')

for _, look in ipairs({ 'classic', 'yunaui', 'sf' }) do
    S.look = look; theme.set_look(look)
    app.close_all(); frame()
    app.open_window('settings'); frame(); frame()
    sui.select_tab('look'); FAKE.labels, FAKE.texts = {}, {}; frame(); frame()
    check(has_label('##sfcat_look') and has_label('##sfcat_input') and has_label('##sfcat_save'), look .. ': categories')
    check(not has_label('##sfcat_notify'), look .. ': notify category gone')
    for _, h in ipairs({ 'GENERAL', 'POPUP', 'UPDATES', 'LAYOUTS' }) do
        check(texted(h), look .. ': look has ' .. h)
    end
    for _, id in ipairs({ 'n_popup', 'n_popup_s', 'n_sound', 'n_sound_v', 'n_popup_try', 'lay_name_1', 'lay_save_5', 'lay_load_5' }) do
        check(in_list(id), look .. ': ' .. id .. ' in the look tab')
    end
    -- 保存タブには LAYOUTS はもう無い
    sui.select_tab('save'); FAKE.labels, FAKE.texts = {}, {}; frame(); frame()
    check(texted('BACKUP') and not texted('LAYOUTS'), look .. ': layouts moved out of save')
    check(not in_list('lay_name_1'), look .. ': layout rows not in save')
    -- 前の「お知らせ」を開こうとしても見た目になる
    sui.select_tab('notify'); frame(); frame()
    eq(sui.current_tab(), 'look', look .. ': old notify tab opens look')
    -- 分類の切り替え（R1）：見た目 → … → 保存 → 見た目、お知らせは通らない
    local seen_tabs = {}
    sui.select_tab('look'); frame()
    for _ = 1, 7 do
        sui.cycle_tab(1); frame(); frame()
        seen_tabs[#seen_tabs + 1] = sui.current_tab()
    end
    eq(table.concat(seen_tabs, ','), 'layout,tracker,map,marks,input,save,look', look .. ': tab cycle without notify')
    -- 設定のキーは同じ：トグルで S.notify.popup が変わる
    sui.select_tab('look'); frame(); frame()
    local before = S.notify.popup
    focus.set('settings', 'n_popup', false, 'nav'); app.activate('settings'); frame()
    app.input('confirm', true, 'key'); app.input('confirm', false, 'key'); frame(); frame()
    eq(S.notify.popup, not before, look .. ': popup key unchanged')
    S.notify.popup = before
end
app.close_all(); frame()
print('test_304 ok')
