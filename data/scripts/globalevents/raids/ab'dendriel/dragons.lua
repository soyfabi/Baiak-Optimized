local raid = GlobalEvent("Dragons_raids")
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

local function dragon_wave(from, to, z)
    local dragonCount = math.random(2, 3)
    local hatchlingCount = math.random(2, 3)
    spawnWave(from, to, z, "Dragon", dragonCount)
    spawnWave(from, to, z, "Dragon Hatchling", hatchlingCount)
end

local function dragons_wave()
    dragon_wave({x = 32780, y = 31581}, {x = 32783, y = 31587}, 7)
end

local function dragons2_wave()
    dragon_wave({x = 32819, y = 31591}, {x = 32823, y = 31596}, 7)
end

local function dragons3_wave()
    dragon_wave({x = 32801, y = 31601}, {x = 32809, y = 31608}, 7)
end

local function dragons4_wave()
    dragon_wave({x = 32776, y = 31598}, {x = 32788, y = 31610}, 7)
end

function raid.onTime(interval)
    addEvent(dragons_wave, 1000)
    addEvent(dragons2_wave, 1000)
    addEvent(dragons3_wave, 1000)
    addEvent(dragons4_wave, 1000)
	Game.createMonster("Dragon Lord", Position(32798, 31558, 6))
	Game.createMonster("Dragon Lord", Position(32798, 31558, 5))
	Game.createMonster("Dragon Lord", Position(32798, 31558, 4))
	Game.createMonster("Dragon Lord", Position(32798, 31558, 3))
	
	Game.broadcastMessage("There are dragons rising in Draconia!", MESSAGE_STATUS_WARNING)
    
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Dragons (Draconia). [Executed: %s]", currentTime))
    return true
end

--raid:register()
