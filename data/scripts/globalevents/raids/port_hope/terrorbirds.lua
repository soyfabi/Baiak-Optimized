local raid = GlobalEvent("Terrorbirds_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Terrorbirds have been sighted in Trapwood south-east of Port Hope!", MESSAGE_STATUS_WARNING)
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

local function terrorbird_wave()
    local from, to, z = {x = 32700, y = 32771}, {x = 32746, y = 32810}, 7
    local terrorBirdCount = 30
	
    spawnWave(from, to, z, "Terror Bird", terrorBirdCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(terrorbird_wave, 120000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Terror Bird (Port Hope). [Executed: %s]", currentTime))
    return true
end

--raid:register()
