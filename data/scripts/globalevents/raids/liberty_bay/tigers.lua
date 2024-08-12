local raid = GlobalEvent("Tigers_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Majestic creatures with stripes roam the small desert at Meriana.", MESSAGE_STATUS_WARNING)
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

local function tigers_wave()
    local from, to, z = {x = 32287, y = 32541}, {x = 32386, y = 32618}, 7
    local tigersCount = 30
    spawnWave(from, to, z, "Tiger", tigersCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(tigers_wave, 120000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Tigers (Liberty Bay). [Executed: %s]", currentTime))
    return true
end

--raid:register()
