local raid = GlobalEvent("Priestesses_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("The priestesses in Drefia are preparing a black celebration.", MESSAGE_STATUS_WARNING)
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

local function priestess_wave()
    local from, to, z = {x = 32984, y = 32404}, {x = 33009, y = 32430}, 7
    local priestessCount = 25
    spawnWave(from, to, z, "Priestess", priestessCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(priestess_wave, 1000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Priestesses (Darashia). [Executed: %s]", currentTime))
    return true
end

--raid:register()
