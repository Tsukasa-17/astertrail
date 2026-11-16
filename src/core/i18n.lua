-- Astertrail - i18n（画面の文言。クエスト名・NPC名はどの言語でも英語のまま）

local json = require('src.lib.json')

local i18n = {}
i18n.__index = i18n

-- fs.read と locales フォルダを受け取る
function i18n.new(fs, base)
    local self = setmetatable({ fs = fs, base = base, lang = 'ja', tables = {}, missing = {} }, i18n)
    for _, lang in ipairs({ 'ja', 'en' }) do
        local text = fs.read(base .. lang .. '.json')
        local t = text and json.decode(text)
        self.tables[lang] = type(t) == 'table' and t or {}
    end
    return self
end

function i18n:set_language(lang)
    if self.tables[lang] then self.lang = lang end
end

-- {name} を params.name で置き換える
function i18n:t(key, params)
    local s = self.tables[self.lang][key] or self.tables.ja[key]
    if s == nil then
        self.missing[key] = true
        s = key
    end
    if params then
        s = s:gsub('{([%w_]+)}', function (k)
            local v = params[k]
            if v == nil then return '{' .. k .. '}' end
            return tostring(v)
        end)
    end
    return s
end

-- 関数として渡せる形
function i18n:fn()
    return function (key, params) return self:t(key, params) end
end

return i18n
