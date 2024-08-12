local raid = GlobalEvent("Lions_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("There are more lions than usual west of Darashia.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Even more lions west of Darashia!", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("Zomba, the king of lions is roaming the Darashia desert!", MESSAGE_STATUS_WARNING)
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

local function lions_wave()
    local from, to, z = {x = 33123, y = 32398}, {x = 33186, y = 32466}, 7
    local lionsCount = 10
    spawnWave(from, to, z, "Lion", lionsCount)
end

local function zomba_wave()
    local from, to, z = {x = 33123, y = 32398}, {x = 33186, y = 32466}, 7
    local zombaCount = 1
    spawnWave(from, to, z, "Zomba", zombaCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(warning2, 20000)
	addEvent(warning3, 120000)
	addEvent(lions_wave, 1000)
	addEvent(lions_wave, 20000)
	addEvent(zomba_wave, 120000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Lions (Darashia). [Executed: %s]", currentTime))
    return true
end

--raid:register()
