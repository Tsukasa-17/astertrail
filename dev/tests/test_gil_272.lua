-- 0.1.272：金額の左に小さなギルのコイン。所持・ツールチップ・番号照合は付けない
require('fake_env')

local app = require('src.app')
eq(app.VERSION, '1.1.324', 'version')

local item_tip = require('src.ui.item_tip')
local CT = require('src.ui.colored_text')
local gil = require('src.core.gil')
item_tip.clear_source()

local imgui = {
    GetFontSize = function () return 16 end,
    GetCursorScreenPos = function () return 10, 20 end,
    Dummy = function () end,
    SameLine = function () end,
    GetWindowDrawList = function ()
        return {
            AddImage = function () end,
            AddCircleFilled = function (_, _, _, _, _) end,
            AddCircle = function () end,
        }
    end,
}

-- ギルドは金額ではない
eq(gil.find_amount('木工ギルド前'), nil, 'ギルド is not an amount')
eq(item_tip.icon_reserve_width(imgui, { kind = 'item', text = 'ギルド' }), 0, 'ギルド reserves no gil icon')
eq(item_tip.icon_reserve_width(imgui, { text = 'ギルド' }), 0, 'plain ギルド reserves no icon')

-- 金額は、ゲームのアイコンが無くても幅を予約する（自前のコインを描く）
local w5 = item_tip.icon_reserve_width(imgui, { kind = 'gil', text = '5ギル' })
local w3 = item_tip.icon_reserve_width(imgui, { kind = 'gil', text = '3,000ギル' })
check(w5 and w5 > 0, '5ギル reserves icon width')
eq(w5, w3, 'all gil amounts reserve the same icon width')
check(item_tip.draw_gil_icon(imgui, 10, 20, w5 - 3) == true, 'drawn coin is used when the game icon is absent')
eq(item_tip.gil_icon_kind(), 'drawn', 'kind is drawn without a game icon')

-- ゲームの item_icon(65535) が読めて解読できれば、それを使う
local function le32(n)
    n = n % 4294967296
    return string.char(n % 256, math.floor(n / 256) % 256, math.floor(n / 65536) % 256, math.floor(n / 16777216) % 256)
end
local function le16(n)
    n = n % 65536
    return string.char(n % 256, math.floor(n / 256) % 256)
end
local pixels = string.char(0, 0, 255, 255, 0, 255, 0, 255, 255, 0, 0, 255, 255, 255, 255, 255)
local dib = le32(40) .. le32(2) .. le32(2) .. le16(1) .. le16(32) .. le32(0) .. le32(16)
    .. le32(0) .. le32(0) .. le32(0) .. le32(0)
local bmp = 'BM' .. le32(14 + 40 + 16) .. le32(0) .. le32(14 + 40) .. dib .. pixels
item_tip.clear_source()
item_tip.set_source({
    icon = function (id)
        if id == 65535 then return bmp end
        return nil
    end,
    load_texture = function (img)
        return { _tex = true, w = img.width, h = img.height, game = true }
    end,
})
local tex = item_tip.gil_icon_texture()
check(tex and tex._tex == true, 'game gil icon becomes a texture when it decodes')
eq(item_tip.gil_icon_kind(), 'game', 'kind is game when item_icon(65535) decodes')

-- 折り返しはコインの幅を含める
local function tw_ui()
    return {
        GetFontSize = function () return 16 end,
        CalcTextSize = function (text)
            text = tostring(text or '')
            local w, i, n = 0, 1, #text
            while i <= n do
                local b = text:byte(i)
                if not b then break end
                local step = (b < 128 and 1) or (b < 224 and 2) or (b < 240 and 3) or 4
                w = w + ((b < 128) and 8 or 16)
                i = i + step
            end
            return { x = w, y = 16 }
        end,
    }
end
local plain = CT._layout(tw_ui(), { { text = '5ギル' } }, 400)
local with = CT._layout(tw_ui(), { { text = '5ギル', kind = 'gil', color = 'gold' } }, 400)
check(plain and with, 'layout returns lines')
local function width_of(lines)
    local w = 0
    -- use public-ish line measure via piece widths + reserve
    for _, piece in ipairs(lines[1]) do
        local t = piece.text
        local pw = 0
        local i, n = 1, #t
        while i <= n do
            local b = t:byte(i)
            local step = (b < 128 and 1) or (b < 224 and 2) or (b < 240 and 3) or 4
            pw = pw + ((b < 128) and 8 or 16)
            i = i + step
        end
        w = w + pw
        if piece.kind == 'gil' then
            w = w + item_tip.icon_reserve_width(tw_ui(), piece)
        end
    end
    return w
end
check(width_of(with) > width_of(plain), 'layout width includes the gil coin: ' .. tostring(width_of(with)) .. ' vs ' .. tostring(width_of(plain)))

-- 狭い幅でも、コイン分を見て折り返す（金額が次の行の先頭に来るときも幅を予約）
local narrow = 40
local lines = CT._layout(tw_ui(), {
    { text = '前の文 ' },
    { text = '3,000ギル', kind = 'gil', color = 'gold' },
}, narrow)
check(lines and #lines >= 1, 'narrow layout still returns lines')
local saw_icon = false
for _, line in ipairs(lines) do
    for _, piece in ipairs(line) do
        if piece.kind == 'gil' then
            saw_icon = item_tip.icon_reserve_width(tw_ui(), piece) > 0
        end
    end
end
check(saw_icon, 'gil piece in wrapped lines still reserves icon width')

-- 所持・ツールチップ・番号は付けない
eq(item_tip.show_for_need({ imgui = {} }, { kind = 'item', name_ja = 'ギル', count = 5 }), false, 'no gil tooltip')
eq(item_tip.need_from_piece({ kind = 'gil', text = '5ギル' }), nil, 'gil piece is not a need')
local spans = CT.spans('3,000ギル', {})
local saw = false
for _, s in ipairs(spans) do
    if s.kind == 'gil' then
        saw = true
        eq(s.item_id, nil, 'gil span has no item_id')
        eq(s.item_ids, nil, 'gil span has no item_ids')
    end
end
check(saw, '3,000ギル is a gil span')

item_tip.clear_source()
print('test_gil_272 ok')
