local raid = GlobalEvent("Furyosa_raids")
raid:type("timer")
raid:interval(1800)

local function spawnWave(from, to, z, monsterName, count)
    for _ = 1, count do
        local x, y = math.random(from.x, to.x), math.random(from.y, to.y)
        local monster = Game.createMonster(monsterName, Position(x, y, z))
        if monster then
            monster:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
        end
    end
end

local function demon_wave()
    local from, to, z = {x = 33257, y = 31784}, {x = 33342, y = 31867}, 14
    local demonCount = 30
    spawnWave(from, to, z, "Demon", demonCount)
end

local function demon2_wave()
    local from, to, z = {x = 33257, y = 31784}, {x = 33342, y = 31867}, 15
    local demonCount = 30
    spawnWave(from, to, z, "Demon", demonCount)
end

local function furyosa_wave()
    local furyosa = Game.createMonster("Furyosa", Position(33281, 31804, 15))
	if furyosa then
		furyosa:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
    addEvent(demon_wave, 2000)
	addEvent(demon2_wave, 2000)
	addEvent(furyosa_wave, 2000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Furyosa (Fury Gate). [Executed: %s]", currentTime))
    return true
end

--raid:register()
