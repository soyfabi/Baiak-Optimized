local raid = GlobalEvent("Quaras_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Something is moving in the depths of the sea around Liberty Bay.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Numerous Quara fins have been sighted in the seas around Liberty Bay.", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("Quara emerged from the sea to attack Liberty Bay.", MESSAGE_STATUS_WARNING)
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

local function quaras_wave()
    local from, to, z = {x = 32306, y = 32705}, {x = 32319, y = 32731}, 7
    local quaraMantassinCount = 12
	local quaraConstrictorCount = 12
	local quaraHydromancerCount = 12
	local quaraPincherCount = 12
	local quaraPredatorCount = 10
    spawnWave(from, to, z, "Quara Mantassin Scout", quaraMantassinCount)
	spawnWave(from, to, z, "Quara Constrictor Scout", quaraConstrictorCount)
	spawnWave(from, to, z, "Quara Hydromancer Scout", quaraHydromancerCount)
	spawnWave(from, to, z, "Quara Pincher Scout", quaraPincherCount)
	spawnWave(from, to, z, "Quara Predator Scout", quaraPredatorCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(warning2, 20000)
	addEvent(warning3, 60000)
	addEvent(quaras_wave, 60000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Quaras (Liberty Bay). [Executed: %s]", currentTime))
    return true
end

--raid:register()
