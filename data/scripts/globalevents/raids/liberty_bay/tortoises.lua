local raid = GlobalEvent("Tortoises_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Slowly but steady, the population of tortoises grows on liberty island.", MESSAGE_STATUS_WARNING)
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

local function torto_wave()
    local from, to, z = {x = 32208, y = 32724}, {x = 32248, y = 32750}, 7
    local tortoiseCount = 30
    spawnWave(from, to, z, "Tortoise", tortoiseCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(torto_wave, 120000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Tortoise (Liberty Bay). [Executed: %s]", currentTime))
    return true
end

--raid:register()
