require('harness')
local json = require('src.lib.json')
local util = require('src.lib.util')
local data_mod = require('src.core.data')
local progress = require('src.core.progress')
local storage = require('src.core.storage')
local settings = require('src.core.settings')
local i18n = require('src.core.i18n')

-- json
local v = json.decode('\239\187\191{"a":[1,2,{"b":null}],"s":"\\u3042\\ud83d\\ude00","n":-1.5e2}')
eq(v.a[2], 2, 'array'); eq(v.a[3].b, nil, 'null->nil'); eq(v.s, 'あ😀', 'unicode'); eq(v.n, -150, 'num')
check(json.is_array(v.a), 'array mark')
local enc = json.encode({ z = 1, a = json.array({}), o = json.object({}), t = 'x"y' })
eq(enc, '{\n  "a": [],\n  "o": {},\n  "t": "x\\"y",\n  "z": 1\n}\n', 'encode sorted')
check(json.decode('{"a":') == nil, 'broken returns nil')
check(json.encode({ x = 0/0 }) == nil, 'NaN refused')
check(json.decode(json.encode(v)).s == v.s, 'roundtrip')

-- util
eq(util.safe_name('A<b>:c'), 'A_b__c', 'safe_name')
eq(util.utf8_cut('あいうえお', 3), 'あいう…', 'utf8_cut'); eq(util.utf8_cut('あい', 3), 'あい', 'short')

-- data
local fs = posix_fs()
local D = data_mod.load(fs, ROOT .. '/data/')
eq(#D.errors, 0, 'data errors: ' .. json.encode(D.errors, true))
eq(#D:list('quest'), 1168, 'quests'); eq(#D:list('mission'), 661, 'missions')
eq(D.version, '2026.11.16-112', 'data version')
local q = D:quest('quest.sandoria.001'); check(q, 'quest')
eq(q.name_en, "The Merchant's Bidding", 'english name')
local s1 = D:first_step(q); check(s1, 'first step')
local loc = D:location_text(s1, function (k) return k end)
check(loc:find('E%-8'), 'grid in location: ' .. loc)
for _, qq in ipairs(D.quests) do
    for _, st in ipairs(qq.steps) do
        check(st.text_status == (qq.guide and 'guide_v1' or 'draft_from_sheet'), 'text status ' .. st.id)
        for _, n in ipairs(st.next or {}) do check(D:step(n), 'next exists ' .. n) end
    end
    check(qq.sources and qq.sources[1] and qq.sources[1].url:find('^https://wiki%.ffo%.jp/'), 'source url ' .. qq.id)
end

-- progress
local changes = 0
local P = progress.new({ data = D, max_pins = function () return 2 end, on_change = function () changes = changes + 1 end })
eq(P:set_state('quest.sandoria.001', 'accepted').code, 'no_character', 'needs character')
P:reset({ server = 'catseye', name = 'Test' })
eq(P:state('quest.sandoria.001'), 'not_accepted', 'default not accepted')
-- 古い保存の unknown は未受注へ
do
    local ok_ad = P:adopt({
        progress_schema = 1,
        character = { server = 'catseye', name = 'Test' },
        quests = { ['quest.sandoria.002'] = { state = 'unknown', steps = {}, cycles = {} } },
    }, { server = 'catseye', name = 'Test' })
    check(ok_ad, 'adopt old unknown')
    eq(P:state('quest.sandoria.002'), 'not_accepted', 'unknown migrated to not_accepted')
    P:reset({ server = 'catseye', name = 'Test' })
end
-- 0.1.180〜（t290）：未受注のクエストの手順はチェックできない（外すのはできる）。受注してから付ける
check(P:steps_locked(q.id), 'not accepted quest: steps locked')
eq(P:check_step(q.id, q.steps[1].id).code, 'not_accepted', 'not accepted quest: cannot check')
eq(P:check_through(q.id, q.steps[2].id).code, 'not_accepted', 'not accepted quest: cannot check through')
check(P:check_step(q.id, q.steps[1].id, false).ok, 'not accepted quest: unchecking is allowed')
check(not P:step_done(q.id, q.steps[1].id), 'nothing checked')
eq(P:state(q.id), 'not_accepted', 'state unchanged')
do  -- 決定は今の手順を選ぶだけ（前の手順に付けない・受注中にしない）
    local r = P:decide_step(q.id, q.steps[3].id)
    check(r.ok and r.auto_checked == 0 and not r.promoted, 'decide: no auto checks while not accepted')
    eq(P:current_step(q.id).id, q.steps[3].id, 'decide: current step chosen')
    check(not P:step_done(q.id, q.steps[1].id), 'decide: earlier steps not checked')
    P:set_current_step(q.id, q.steps[1].id)
end
do  -- ミッションはこれまでどおり（受注の操作が無いので、チェックで受注中にする）
    local m
    for _, x in ipairs(D.quests) do if x.kind == 'mission' and #x.steps > 0 then m = x; break end end
    check(m and not P:steps_locked(m.id), 'missions are not locked')
    local mr = P:check_step(m.id, m.steps[1].id)
    check(mr.ok and mr.promoted, 'mission: check promotes to accepted')
    P:check_step(m.id, m.steps[1].id, false)
end
P:set_state(q.id, 'accepted')
check(not P:steps_locked(q.id), 'accepted quest: unlocked')
local last
for i, st in ipairs(q.steps) do
    last = P:check_step(q.id, st.id)
    check(last.ok, 'check')
end
eq(P:state(q.id), 'accepted', 'never auto complete')
check(last.suggest_complete, 'suggests complete')
P:lock(q.id)
eq(P:set_state(q.id, 'completed').code, 'locked', 'locked blocks state')
eq(P:start_cycle(q.id).code, 'locked', 'locked blocks cycle')
P:unlock(q.id)
check(P:set_state(q.id, 'completed').ok, 'complete'); eq(P:cycle_count(q.id), 1, 'cycle')
local rc = P:start_cycle(q.id)
check(rc.ok or rc.code == 'need_confirm', 'cycle request')
if rc.code == 'need_confirm' then check(P:start_cycle(q.id, true).ok, 'confirmed cycle') end
eq(P:state(q.id), 'accepted', 'cycle accepted'); check(not P:step_done(q.id, s1.id), 'steps cleared')
-- locked + check: records but not promoted（0.1.180〜：未受注のクエストは付けられないので、ミッションで確かめる）
local q2 = D:quest('quest.bastok.001'); P:lock(q2.id)
eq(P:check_step(q2.id, q2.steps[1].id).code, 'not_accepted', 'locked not-accepted quest: cannot check')
P:unlock(q2.id)
local m2
for _, x in ipairs(D.quests) do if x.kind == 'mission' and #x.steps > 0 and not P:record(x.id) then m2 = x; break end end
P:lock(m2.id)
local r2 = P:check_step(m2.id, m2.steps[1].id)
check(r2.ok and r2.kept_by_lock and not r2.promoted, 'kept by lock'); eq(P:state(m2.id), 'not_accepted', 'state kept')
check(P:step_done(m2.id, m2.steps[1].id), 'step recorded')
P:unlock(m2.id)
-- pins
check(P:pin('quest.sandoria.001').ok, 'pin1'); check(P:pin('quest.bastok.001').ok, 'pin2')
eq(P:pin('quest.windurst.001').code, 'pin_limit', 'pin limit')
P:move_pin('quest.bastok.001', -1); eq(P:pinned_list()[1], 'quest.bastok.001', 'move pin')
P:unpin('quest.bastok.001'); eq(#P:pinned_list(), 1, 'unpin')
check(changes > 0, 'on_change called')
-- 必要品まとめ・エリア入場は 0.1.173 でなくした
P:set_state('quest.windurst.001', 'accepted')
eq(P.needs_summary, nil, 'no needs summary'); eq(P.here_now, nil, 'no here_now')
-- adopt newer schema -> read only
local P2 = progress.new({ data = D })
local ok = P2:adopt({ progress_schema = 99, character = { server = 'catseye', name = 'Test' }, quests = {} }, { server = 'catseye', name = 'Test' })
check(P2.read_only, 'newer schema read-only')
eq(P2:set_state('quest.sandoria.001', 'accepted').code, 'read_only', 'read-only refuses')
local P3 = progress.new({ data = D })
local ok3, why3 = P3:adopt({ progress_schema = 1, character = { server = 'catseye', name = 'Other' }, quests = {} }, { server = 'catseye', name = 'Test' })
check(not ok3 and why3 == 'character_mismatch', 'mismatch ' .. tostring(why3))
-- unknown quest kept as orphan
local P4 = progress.new({ data = D })
check(P4:adopt({ progress_schema = 1, character = { server = 'catseye', name = 'Test' }, quests = { ['gone.999'] = { state = 'accepted' } } }, { server = 'catseye', name = 'Test' }), 'adopt')
eq(P4:orphan_count(), 1, 'orphan kept')

-- storage
local dir = TMP .. '/c'; fs.mkdir(dir); fs.mkdir(dir .. '/backup')
local path = dir .. '/progress.json'
check(storage.save_json(fs, path, P:snapshot()), 'save 1')
check(storage.save_json(fs, path, P:snapshot()), 'save 2')
check(fs.exists(path .. '.bak'), 'bak exists'); check(not fs.exists(path .. '.tmp'), 'tmp gone')
local doc, info = storage.load_json(fs, path, dir .. '/backup', 'progress-', '20261112-000000')
check(doc and info.source == 'main', 'load main')
fs.write(path, '{broken')
doc, info = storage.load_json(fs, path, dir .. '/backup', 'progress-', '20261112-000001')
check(doc and info.source == 'bak', 'recover from bak: ' .. tostring(info and info.source))
check(fs.exists(path .. '.broken-20261112-000001'), 'broken kept')
check(storage.daily_backup(fs, path .. '.bak', dir .. '/backup', 'progress-', 2, os.time()) ~= nil, 'daily backup')

-- settings
local d = settings.defaults()
local m = settings.merge({ settings_schema = 1, font_scale = 99, tracker = { max_pins = 'x' }, extra = 1 })
eq(m.font_scale, 4.0, 'clamped to 400% (0.1.210)'); eq(m.tracker.max_pins, d.tracker.max_pins, 'type mismatch default')
eq(m.extra, 1, 'unknown key kept')

-- i18n: keys in ja and en match
local ja = json.decode(fs.read(ROOT .. '/locales/ja.json'))
local en = json.decode(fs.read(ROOT .. '/locales/en.json'))
for k in pairs(ja) do check(en[k], 'en has ' .. k) end
for k in pairs(en) do check(ja[k], 'ja has ' .. k) end
local I = i18n.new(fs, ROOT .. '/locales/')
eq(I:t('msg.pin_limit', { limit = 3 }), 'ピンは 3 件までです。', 'param')
eq(I:t('no.such.key'), 'no.such.key', 'fallback key')
