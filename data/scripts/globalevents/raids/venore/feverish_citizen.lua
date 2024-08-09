local raid = GlobalEvent("Feverish_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Feverish Citizens are invading the streets of Venore!", MESSAGE_STATUS_WARNING)
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

local function feverish_wave()
    local from, to, z = {x = 33012, y = 32052}, {x = 32861, y = 32126}, 6
    local feverishCitizenCount = 120
    spawnWave(from, to, z, "Feverish Citizen", feverishCitizenCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(feverish_wave, 1000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Feverish Citizen (Venore). [Executed: %s]", currentTime))
    return true
end

--raid:register()
