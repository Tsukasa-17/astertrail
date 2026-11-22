--[[
  設定の「更新」（0.1.297〜）：アストラルは UPDATES、クラシック・YunaUI は「このアドオンについて」。
  スイッチ「新しいバージョンを知らせる」、いまの様子の一行、「更新する」「今すぐ確認」「x に戻す」。
  見た目は各テーマの部品（opts.toggle / opts.text / opts.button）で描く。
]]
local M = {}

-- いまの様子の一行
function M.status_line(ui)
    local t = ui.t
    local cur = ui.addon_version or '?'
    local st = ui.update_check_status and ui.update_check_status() or { status = 'idle' }
    local head = t('update.status_current', { cur = cur })
    local s = st.status
    local tail
    if s == 'latest' then tail = t('update.status_latest')
    elseif s == 'offer' then tail = t('update.status_offer', { v = st.version or '?' })
    elseif s == 'checking' then tail = t('update.status_checking')
    elseif s == 'error' then tail = t('update.status_error')
    elseif s == 'unsupported' then tail = t('update.status_unsupported')
    end
    return tail and (head .. tail) or head, s
end

function M.draw(ui, name, opts)
    local S, t = ui.settings, ui.t
    S.update_notice = S.update_notice or { enabled = true }
    opts.toggle(ui, name, 'update_notice', t('about.update_notice'), S.update_notice, 'enabled')
    local line, s = M.status_line(ui)
    opts.text(line)
    -- 新しいバージョンがあり、ダウンロードの場所と SHA-256 が分かっているときだけ「更新する」
    local job = ui.state and ui.state.update
    if s == 'offer' and job and job.kind ~= 'rollback' and type(job.zip_url) == 'string' and type(job.sha256) == 'string' then
        local busy = job.status == 'download' or job.status == 'verify' or job.status == 'extract'
            or job.status == 'swap' or job.status == 'reload'
        if opts.button(name, 'upd_now', t('update.update_now'), { disabled = busy }) then
            if ui.start_update then ui.start_update() end
        end
    end
    if s ~= 'unsupported' then
        local wait = ui.update_check_wait and ui.update_check_wait() or 0
        local tip = (wait > 0) and t('update.check_wait', { s = tostring(wait) }) or nil
        if opts.button(name, 'upd_check', t('update.check_now'), { disabled = wait > 0 or s == 'checking', tooltip = tip }) then
            if ui.check_update_now then ui.check_update_now() end
        end
    end
    local prev = ui.rollback_prev and ui.rollback_prev() or nil
    -- 0.1.301〜：戻せるのは公開版（1.x など）だけ。手元の試しの版（0. で始まる）には戻すボタンを出さない
    if prev and not M.public_version(prev.version) then prev = nil end
    if prev then
        if opts.button(name, 'upd_rollback', t('update.rollback_button', { v = prev.version }), { tooltip = t('update.rollback_tip') }) then
            if ui.ask_rollback then ui.ask_rollback() end
        end
    end
end

-- 公開されたバージョンか（0. で始まるのは手元の試しの版）
function M.public_version(v)
    v = tostring(v or '')
    if v == '' or v:find('^0%.') then return false end
    return v:find('^%d+%.') ~= nil
end

return M
