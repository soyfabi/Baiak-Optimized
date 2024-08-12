local raid = GlobalEvent("Hunter_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Hunters on the hunt north of the Green Claw Swamp.", MESSAGE_STATUS_WARNING)
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

local function hunter_wave()
    local from, to, z = {x = 32692, y = 31947}, {x = 32808, y = 32032}, 7
    local hunterCount = 15
    spawnWave(from, to, z, "Hunter", hunterCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(hunter_wave, 1000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Hunter (Venore). [Executed: %s]", currentTime))
    return true
end

--raid:register()
