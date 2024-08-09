local raid = GlobalEvent("Cyclops_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Let da mashing begin! Cyclops riot east of Thais.", MESSAGE_STATUS_WARNING)
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

local function cyclops_wave()
    local from, to, z = {x = 32440, y = 32223}, {x = 32474, y = 32266}, 7
    local cyclopsCount = 5
	local cyclopsDroneCount = 5
	local cyclopsSmithCount = 3
    spawnWave(from, to, z, "Cyclops", cyclopsCount)
	spawnWave(from, to, z, "Cyclops Drone", cyclopsDroneCount)
	spawnWave(from, to, z, "Cyclops Smith", cyclopsSmithCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(cyclops_wave, 1000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Cyclops (Thais). [Executed: %s]", currentTime))
    return true
end

--raid:register()
