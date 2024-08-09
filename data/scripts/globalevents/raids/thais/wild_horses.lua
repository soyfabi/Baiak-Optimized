local raid = GlobalEvent("Wildhorses_raids")
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

local function wildhorses_wave()
    local wildhorses = Game.createMonster("Wild Horse", Position(32462, 32214, 7))
    if wildhorses then
		wildhorses:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

local function wildhorses2_wave()
    local wildhorses = Game.createMonster("Wild Horse", Position(32445, 32227, 7))
    if wildhorses then
		wildhorses:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

local function wildhorses3_wave()
    local wildhorses = Game.createMonster("Wild Horse", Position(32442, 32265, 7))
    if wildhorses then
		wildhorses:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
    addEvent(wildhorses_wave, 2000)
	addEvent(wildhorses2_wave, 2000)
	addEvent(wildhorses3_wave, 2000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Wild Horse (Thais). [Executed: %s]", currentTime))
    return true
end

--raid:register()
