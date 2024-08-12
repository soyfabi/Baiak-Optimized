local raid = GlobalEvent("Warlock_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Some monks have gathered at a stone circle west of Edron. They seem to be up to something.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("More monks have gathered at a stone circle west of Edron. Something terrible is going to happen!", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("Run! Warlocks east of Edron! There seems to be a very unholy gathering!", MESSAGE_STATUS_WARNING)
end

local function spawnWave(from, to, z, monsterName, count)
    for _ = 1, count do
        local x, y = math.random(from.x, to.x), math.random(from.y, to.y)
        local monster = Game.createMonster(monsterName, Position(x, y, z))
        if monster then
            monster:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
        end
    end
end

local function monk_wave()
    local from, to, z = {x = 33112, y = 31694}, {x = 33123, y = 31705}, 7
    local monkCount = 6
    spawnWave(from, to, z, "Monk", monkCount)
end

local function warlock_wave()
    local from, to, z = {x = 33112, y = 31694}, {x = 33123, y = 31705}, 7
	local warlockCount = 3
	spawnWave(from, to, z, "Warlock", warlockCount)
end

function raid.onTime(interval)
    addEvent(warning, 1000)
	addEvent(warning2, 20000)
	addEvent(warning3, 120000)
	addEvent(monk_wave, 20000)
	addEvent(warlock_wave, 120000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Warlock (Edron). [Executed: %s]", currentTime))
    return true
end

--raid:register()
