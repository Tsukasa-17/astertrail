-- Astertrail - diagnostics（最小限。生チャットは扱わない。ネットへは送らない）

local diagnostics = { lines = {}, max = 100, capabilities = {} }

function diagnostics.log(kind, msg)
    local l = diagnostics.lines
    l[#l + 1] = { at = os.date('%H:%M:%S'), kind = kind, msg = tostring(msg) }
    if #l > diagnostics.max then table.remove(l, 1) end
end

function diagnostics.set_capability(name, ok, note)
    diagnostics.capabilities[name] = { ok = ok and true or false, note = note }
end

function diagnostics.recent(n)
    local out = {}
    local l = diagnostics.lines
    for i = math.max(1, #l - (n or 10) + 1), #l do out[#out + 1] = l[i] end
    return out
end

return diagnostics
