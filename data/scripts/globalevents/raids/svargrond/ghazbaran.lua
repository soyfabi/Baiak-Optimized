local raid = GlobalEvent("Ghazbaran_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("An ancient evil is awakening in the mines beneath Hrodmir.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Demonic entities are entering the mortal realm in the Hrodmir mines.", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("The demonic master has revealed itself in the mines of Hrodmir.", MESSAGE_STATUS_WARNING)
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

local function ghazbaran_wave()
	local ghaz = Game.createMonster("Ghazbaran", Position(32228, 31163, 15))
	if ghaz then
		ghaz:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
	end
end

local function ghazbaran2_wave()
    local from, to, z = {x = 32194, y = 30986}, {x = 32213, y = 31012}, 14
    local deathslicerCount = 12
	
    spawnWave(from, to, z, "Deathslicer", deathslicerCount)
end

local function ghazbaran3_wave()
    local from, to, z = {x = 32194, y = 30986}, {x = 32213, y = 31012}, 14
    local juggernautCount = 5
	
    spawnWave(from, to, z, "Juggernaut", juggernautCount)
end

local function ghazbaran4_wave()
    local from, to, z = {x = 32194, y = 30986}, {x = 32213, y = 31012}, 14
    local furyCount = 8
	
    spawnWave(from, to, z, "Fury", furyCount)
end

local function ghazbaran5_wave()
    local from, to, z = {x = 32194, y = 30986}, {x = 32213, y = 31012}, 14
    local demonCount = 6
	
    spawnWave(from, to, z, "Demon", demonCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(warning2, 30000)
	addEvent(warning3, 60000)
	addEvent(ghazbaran_wave, 60000)
	
	addEvent(ghazbaran2_wave, 53000)
	addEvent(ghazbaran3_wave, 55000)
	addEvent(ghazbaran4_wave, 56000)
	addEvent(ghazbaran5_wave, 58000)
	
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Ghazbaran (Svargrond). [Executed: %s]", currentTime))
    return true
end

--raid:register()
