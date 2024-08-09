local raid = GlobalEvent("SerpentSpawn_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Something bad is happening deep, deep down under Banuta.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Something is sizzling deep under many sheets of soil in Banuta.", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("Hordes of slippery spawns slither in Deeper Banuta.", MESSAGE_STATUS_WARNING)
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

local function serpentSpawn_wave()
    local from, to, z = {x = 32748, y = 32599}, {x = 32757, y = 32609}, 15
    local serpentSpawnCount = 15
	
    spawnWave(from, to, z, "Serpent Spawn", serpentSpawnCount)
end

local function serpentSpawn2_wave()
    local from, to, z = {x = 32759, y = 32602}, {x = 32769, y = 32607}, 15
    local serpentSpawnCount = 15
	
    spawnWave(from, to, z, "Serpent Spawn", serpentSpawnCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(warning2, 20000)
	addEvent(warning3, 120000)
	
	addEvent(serpentSpawn_wave, 20000)
    addEvent(serpentSpawn2_wave, 120000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Serpent Spawn (Port Hope). [Executed: %s]", currentTime))
    return true
end

--raid:register()
