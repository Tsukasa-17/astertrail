-- 0.1.315：頭上の文字（クエスト名・オブジェクト名）のフォント選び・上から下のグラデーション・色そのものの不透明度。
-- 古い保存は今までの見た目のまま（フォントはいつもの、向きは左から右、不透明度は 1）。
require('harness')
local settings = require('src.core.settings')
local ext = require('src.platform.vanacore_ext')
local W = require('src.ui.widgets')
local app = require('src.app')
eq(app.VERSION, '1.1.327', 'version')

-- 1) 初期値と古い保存
local d = settings.defaults()
eq(d.marks.label_grad_dir, 'across', 'default dir label')
eq(d.marks.under_grad_dir, 'across', 'default dir under')
eq(d.marks.label_clear, 0, 'default clear (0.1.317)')
eq(d.marks.under_clear, 0, 'default clear 2 (0.1.317)')
eq(d.marks.label_font, '', 'default font is the usual one')
local old = { marks = { label_color = { 10, 20, 30 }, label_grad = true, label_color2 = { 40, 50, 60 } } }
local m = settings.merge(old)
eq(m.marks.label_grad_dir, 'across', 'old save keeps left to right')
eq(m.marks.label_clear, 0, 'old save opaque')
eq(m.marks.label_color_a, nil, 'old per-color key dropped')
eq(m.marks.label_font, '', 'old save keeps the usual font')
local c1, c2 = settings.text_colors(m.marks, 'label')
eq(c1[4], nil, 'opaque color has no 4th value')
eq(c2[4], nil, 'opaque end color has no 4th value')
local st = settings.label_style(m.marks, 'label')
eq(st.font, nil, 'no font by default')
eq(st.text_dir, 'across', 'style dir default')
-- 壊れた値
local bad = settings.merge({ marks = { label_grad_dir = 'sideways', under_grad_dir = 'down', label_color_a = 'x',
    under_color_a = 3, under_color2_a = -1, label_font = '  Yu Gothic UI  ' } })
eq(bad.marks.label_grad_dir, 'across', 'unknown dir')
eq(bad.marks.under_grad_dir, 'down', 'down kept')
eq(bad.marks.label_clear, 0, 'broken alpha -> clear 0')
eq(bad.marks.under_clear, 0, 'alpha clamped high -> clear 0')
eq(bad.marks.label_font, 'Yu Gothic UI', 'font trimmed')
eq(settings.clamp_label_font('a\nb'), '', 'control chars refused')
eq(settings.clamp_label_font(string.rep('x', 65)), '', 'too long refused')
eq(settings.clamp_label_font(nil), '', 'nil font')
-- 0.1.317〜：始めの色の不透明度を透明度に読み替え、両方の色に同じだけ
local M2 = settings.merge({ marks = { label_color_a = 0.5, label_grad = true, label_color2_a = 0.25, label_font = 'Meiryo UI' } }).marks
local a1, a2 = settings.text_colors(M2, 'label')
eq(M2.label_clear, 0.5, 'opacity 0.5 -> clear 0.5')
eq(a1[4], 128, 'alpha 0.5 -> 128')
eq(a2[4], 128, 'end color uses the same value')
eq(settings.label_style(M2, 'under').font, 'Meiryo UI', 'font shared by object names')

-- 2) 文字の箱に渡す値
eq(ext.hex_of({ 248, 244, 232 }), '#F8F4E8FF', 'opaque hex unchanged')
eq(ext.hex_of({ 248, 244, 232, 128 }), '#F8F4E880', 'alpha hex')
ext.native_gradient = nil
local slot = { codes = true }
local p = ext._label_props(slot, 'Ghebi', { 248, 244, 232 }, nil, 0.8, settings.label_style(m.marks, 'label'))
eq(p.color, '#F8F4E8FF', 'single color as before')
eq(p.gradient, nil, 'no gradient key for old look')
eq(p.font, nil, 'no font key for old look')
eq(p.text, 'Ghebi', 'plain text')
-- 不透明な左から右は、今までどおり色の印
p = ext._label_props(slot, 'AB', { 255, 0, 0 }, { 0, 0, 255 }, 0.8, { text_dir = 'across' })
check(p.text:find('\\cs(255,0,0)', 1, true) ~= nil, 'codes for opaque across')
eq(p.gradient, nil, 'no native gradient for opaque across')
-- 上から下は公式の gradient
p = ext._label_props(slot, 'AB', { 255, 0, 0 }, { 0, 0, 255 }, 0.8, { text_dir = 'down' })
eq(p.gradient, 'down', 'down')
eq(p.gradient_from, '#FF0000FF', 'from')
eq(p.gradient_to, '#0000FFFF', 'to')
eq(p.text, 'AB', 'no codes for down')
-- 左から右へ戻すと、この箱だけ gradient を切る
p = ext._label_props(slot, 'AB', { 255, 0, 0 }, { 0, 0, 255 }, 0.8, { text_dir = 'across' })
eq(p.gradient, 'none', 'native gradient turned off once')
p = ext._label_props(slot, 'AB', { 255, 0, 0 }, { 0, 0, 255 }, 0.8, { text_dir = 'across' })
eq(p.gradient, nil, 'and not sent again')
-- 不透明度のある左から右は公式の across（色の印には不透明度が無い）
p = ext._label_props({ codes = true }, 'AB', { 255, 0, 0, 128 }, { 0, 0, 255 }, 0.8, { text_dir = 'across' })
eq(p.gradient, 'across', 'alpha across uses native')
eq(p.gradient_from, '#FF000080', 'alpha in from')
eq(p.gradient_to, '#0000FF80', 'same alpha in to (0.1.317)')
-- 単色の不透明度
p = ext._label_props({ codes = true }, 'AB', { 1, 2, 3, 51 }, nil, 0.8, {})
eq(p.color, '#01020333', 'single color alpha')
-- フォント：選んだら渡す。いつものに戻したら、箱を作ったときのフォントへ
local fs = { codes = true, font0 = 'Meiryo' }
p = ext._label_props(fs, 'A', { 1, 2, 3 }, nil, 0.8, { font = 'Yu Gothic UI' })
eq(p.font, 'Yu Gothic UI', 'chosen font')
p = ext._label_props(fs, 'A', { 1, 2, 3 }, nil, 0.8, {})
eq(p.font, 'Meiryo', 'back to the usual font')
p = ext._label_props(fs, 'A', { 1, 2, 3 }, nil, 0.8, {})
eq(p.font, nil, 'not sent again')

-- 3) 公式の gradient が無い VanaCore：読み返せなければ色の印へ戻す（一度だけ見る）
ext.native_gradient = nil
local sets = 0
-- 古い VanaCore の箱：知らない名前は set でも代入でも読みでもエラー
local store = {}
local GRAD = { gradient = true, gradient_from = true, gradient_to = true }
local box_old = setmetatable({}, {
    __index = function (t, k)
        if k == 'set' then return function (self, props)
            sets = sets + 1
            for kk in pairs(props) do if GRAD[kk] then error('unknown property ' .. kk) end end
            for kk, vv in pairs(props) do store[kk] = vv end
        end end
        if GRAD[k] then error('no such property') end
        return store[k]
    end,
    __newindex = function (t, k, v)
        if GRAD[k] then error('no such property') end
        store[k] = v
    end,
})
local s_old = { box = box_old, codes = true }
ext._apply_label_text(s_old, 'AB', { 255, 0, 0 }, { 0, 0, 255 }, 0.8, { text_dir = 'down' })
eq(ext.native_gradient, false, 'detected no native gradient')
eq(s_old._st, nil, 'slot re-applied next frame')
ext._apply_label_text(s_old, 'AB', { 255, 0, 0 }, { 0, 0, 255 }, 0.8, { text_dir = 'down' })
check(tostring(store.text):find('\\cs(', 1, true) ~= nil, 'falls back to codes (left to right)')
-- 使える VanaCore
ext.native_gradient = nil
local box_new = { set = function (self, props) for kk, vv in pairs(props) do self[kk] = vv end end }
local s_new = { box = box_new, codes = true }
ext._apply_label_text(s_new, 'AB', { 255, 0, 0 }, { 0, 0, 255 }, 0.8, { text_dir = 'down' })
eq(ext.native_gradient, true, 'native gradient available')
eq(box_new.gradient, 'down', 'box got down')
-- 同じ値なら入れ直さない（毎フレーム set しない）
local n_before = 0
local box_cnt = { set = function (self, props) n_before = n_before + 1 end }
local s_cnt = { box = box_cnt, codes = true }
local stl = { text_dir = 'down', font = 'Meiryo UI' }
for _ = 1, 5 do ext._apply_label_text(s_cnt, 'AB', { 255, 0, 0 }, { 0, 0, 255 }, 0.8, stl) end
eq(n_before, 1, 'set once for the same style')
ext._apply_label_text(s_cnt, 'AB', { 255, 0, 0 }, { 0, 0, 255 }, 0.8, { text_dir = 'down', font = 'Arial' })
eq(n_before, 2, 'font change re-applies')

-- 4) フォントファイルの家族名（name 表だけ読む）
local function be16(n) return string.char(math.floor(n / 256) % 256, n % 256) end
local function be32(n) return be16(math.floor(n / 65536)) .. be16(n % 65536) end
local function u16be(s)
    local out = {}
    for ch in s:gmatch('[%z\1-\127\194-\244][\128-\191]*') do
        local b1, b2, b3 = ch:byte(1, 3)
        local cp = b1
        if #ch == 2 then cp = (b1 - 0xC0) * 64 + (b2 - 0x80)
        elseif #ch == 3 then cp = (b1 - 0xE0) * 4096 + (b2 - 0x80) * 64 + (b3 - 0x80) end
        out[#out + 1] = be16(cp)
    end
    return table.concat(out)
end
local function name_table(recs)
    local strs, rec_bytes, off = {}, {}, 0
    for _, r in ipairs(recs) do
        local raw = u16be(r.s)
        rec_bytes[#rec_bytes + 1] = be16(3) .. be16(1) .. be16(r.lang) .. be16(r.id) .. be16(#raw) .. be16(off)
        strs[#strs + 1] = raw
        off = off + #raw
    end
    local head = be16(0) .. be16(#recs) .. be16(6 + 12 * #recs)
    return head .. table.concat(rec_bytes) .. table.concat(strs)
end
local function ttf(recs, base)
    base = base or 0
    local nt = name_table(recs)
    local dir_len = 12 + 16
    local off = base + dir_len
    return be32(0x00010000) .. be16(1) .. be16(16) .. be16(0) .. be16(0)
        .. 'name' .. be32(0) .. be32(off) .. be32(#nt) .. nt
end
local fdir = TMP .. '/Fonts'
os.execute('mkdir -p "' .. fdir .. '"')
local function write(name, data) local f = io.open(fdir .. '/' .. name, 'wb'); f:write(data); f:close() end
write('meiryo.ttf', ttf({ { id = 1, lang = 0x0409, s = 'Meiryo' }, { id = 1, lang = 0x0411, s = 'メイリオ' } }))
write('meiryob.ttf', ttf({ { id = 1, lang = 0x0409, s = 'Meiryo' } }))   -- 同じ家族は 1 つに
write('arial.ttf', ttf({ { id = 1, lang = 0x0409, s = 'Arial' }, { id = 4, lang = 0x0409, s = 'Arial Regular' } }))
write('wingding.ttf', ttf({ { id = 1, lang = 0x0409, s = 'Wingdings' } }))   -- 記号は出さない
write('broken.ttf', 'xx')
-- TTC（表の場所はファイルの先頭から）
local inner = ttf({ { id = 1, lang = 0x0409, s = 'Yu Gothic' }, { id = 1, lang = 0x0411, s = '游ゴシック' } }, 16)
write('YuGothR.ttc', 'ttcf' .. be32(0x00010000) .. be32(1) .. be32(16) .. inner)
local en, ja = ext.font_file_names(fdir .. '/meiryo.ttf')
eq(en, 'Meiryo', 'english family')
eq(ja, 'メイリオ', 'japanese family')
en, ja = ext.font_file_names(fdir .. '/YuGothR.ttc')
eq(en, 'Yu Gothic', 'ttc english')
eq(ja, '游ゴシック', 'ttc japanese')
eq(ext.font_file_names(fdir .. '/broken.ttf'), nil, 'broken file')
eq(ext.font_file_names(fdir .. '/none.ttf'), nil, 'missing file')
-- 大きなファイルでも先頭と name 表しか読まない（read の量を数える）
local big = ttf({ { id = 1, lang = 0x0409, s = 'Big Font' } }) .. string.rep('\0', 2 * 1024 * 1024)
write('big.ttf', big)
local real_open = io.open
local read_bytes = 0
io.open = function (path, mode)
    local f = real_open(path, mode)
    if not f then return f end
    return setmetatable({}, { __index = function (_, k)
        if k == 'read' then return function (_, n) local s2 = f:read(n); if s2 then read_bytes = read_bytes + #s2 end; return s2 end end
        if k == 'seek' then return function (_, ...) return f:seek(...) end end
        if k == 'close' then return function () return f:close() end end
        return nil
    end })
end
read_bytes = 0
eq(ext.font_file_names(fdir .. '/big.ttf'), 'Big Font', 'big font name')
check(read_bytes < 4096, 'read only the header and the name table: ' .. read_bytes)
io.open = real_open

-- 5) 一覧は少しずつ読む（vana.fs.list）。読み終えたら覚える
local real_getenv = os.getenv
os.getenv = function (k) if k == 'WINDIR' then return TMP end if k == 'LOCALAPPDATA' then return nil end return real_getenv(k) end
local list_calls = 0
_G.vana = { fs = { list = function (dir, filter, which)
    list_calls = list_calls + 1
    eq(which, 'files', 'files only')
    local out = {}
    local h = io.popen('ls -1 "' .. dir:gsub('\\', '/') .. '" 2>/dev/null')
    for line in h:lines() do if line:lower():match('%.tt[fc]$') or line:lower():match('%.otf$') then out[#out + 1] = line end end
    h:close()
    return out
end } }
ext._reset_font_scan()
local list0, done0 = ext.font_families()
eq(#list0, 0, 'nothing before the first step')
eq(done0, false, 'not done before the first step')
eq(ext.font_scan_step(2), false, 'first step lists files')
eq(list_calls, 1, 'listed once')
local steps = 0
while not ext.font_scan_step(2) do steps = steps + 1; check(steps < 20, 'finishes') end
check(steps >= 2, 'took several steps (2 files per step): ' .. steps)
local list, done, unavailable = ext.font_families()
eq(done, true, 'done')
eq(unavailable, false, 'available')
local by = {}
for _, it in ipairs(list) do by[it.value] = it.label end
eq(by['Meiryo'], 'メイリオ（Meiryo）', 'japanese label with the english name')
eq(by['Yu Gothic'], '游ゴシック（Yu Gothic）', 'ttc label')
eq(by['Arial'], 'Arial', 'english only')
eq(by['Big Font'], 'Big Font', 'big font listed')
eq(by['Wingdings'], nil, 'symbol font skipped')
local n_meiryo = 0
for _, it in ipairs(list) do if it.value == 'Meiryo' then n_meiryo = n_meiryo + 1 end end
eq(n_meiryo, 1, 'one entry per family')
eq(ext.font_scan_step(2), true, 'stays done')
eq(list_calls, 1, 'no new listing after done')
-- vana.fs.list が無い環境
_G.vana = nil
ext._reset_font_scan()
eq(ext.font_scan_step(2), true, 'no lister: done at once')
local _, d2, un2 = ext.font_families()
eq(d2, true, 'done without lister')
eq(un2, true, 'unavailable without lister')
os.getenv = real_getenv

-- 6) 色えらびの #RRGGBBAA
local c, a = W.parse_hex_a('#FF800040')
eq(c[1], 255, 'r'); eq(c[2], 128, 'g'); eq(c[3], 0, 'b')
eq(a, 0.25, 'alpha from 8 digits')
c, a = W.parse_hex_a('#102030')
eq(c[3], 48, '6 digits'); eq(a, nil, 'no alpha for 6 digits')
eq(W.parse_hex_a('zz'), nil, 'bad hex')

-- 7) ソース：フォントの一覧は毎フレーム全部は読まない（1 回の数は決めてある）
eq(ext.FONT_SCAN_PER_STEP <= 16, true, 'small step')
local src = io.open(ROOT .. '/src/platform/vanacore_ext.lua', 'r'):read('*a')
check(src:find("if font_scan and font_scan.done then return true end", 1, true) ~= nil, 'done list is cached')
print('test_315 ok')
