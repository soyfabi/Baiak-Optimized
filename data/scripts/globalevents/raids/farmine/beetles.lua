local raid = GlobalEvent("Beetles_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Lancer beetles troop up in Farmine. Beware!", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("A pack of lancer beetles heads towards the coast!", MESSAGE_STATUS_WARNING)
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

local function beetles_wave()
    local from, to, z = {x = 33204, y = 31184}, {x = 33235, y = 31212}, 7
    local lancerBeetlesCount = 20
    spawnWave(from, to, z, "Lancer Beetle", lancerBeetlesCount)
end

function raid.onTime(interval)
    addEvent(warning, 1000)
	addEvent(warning2, 20000)
	addEvent(beetles_wave, 20000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Beetles (Farmine). [Executed: %s]", currentTime))
    return true
end

--raid:register()
