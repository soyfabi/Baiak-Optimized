local raid = GlobalEvent("Mino_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Minotaurs are preparing an attack in the Darashia Minotaur pyramid!", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Minotaurs are attacking Darashia from the north!", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("Minotaurs are advancing to Darashia grom the north!", MESSAGE_STATUS_WARNING)
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

local function mino_wave()
    local from, to, z = {x = 33253, y = 32295}, {x = 33294, y = 32329}, 7
    local minotaurCount = 10
	local minotaurGuardCount = 10
	local minotaurMageCount = 10
    spawnWave(from, to, z, "Minotaur", minotaurCount)
	spawnWave(from, to, z, "Minotaur Guard", minotaurGuardCount)
	spawnWave(from, to, z, "Minotaur Mage", minotaurMageCount)
end

local function mino2_wave()
    local from, to, z = {x = 33253, y = 32295}, {x = 33294, y = 32329}, 7
    local minotaurCount = 20
	local minotaurGuardCount = 15
	local minotaurMageCount = 20
    spawnWave(from, to, z, "Minotaur", minotaurCount)
	spawnWave(from, to, z, "Minotaur Guard", minotaurGuardCount)
	spawnWave(from, to, z, "Minotaur Mage", minotaurMageCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(warning2, 20000)
	addEvent(warning3, 120000)
	addEvent(mino_wave, 20000)
	addEvent(mino2_wave, 120000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Minotaurs (Darashia). [Executed: %s]", currentTime))
    return true
end

--raid:register()
