local raid = GlobalEvent("Draptor_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("The dragons of the Dragonblaze Mountains have  descended to Zao to protect the lizardkin!", MESSAGE_STATUS_WARNING)
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

local function dragons_wave()
    local from, to, z = {x = 33213, y = 31160}, {x = 33352, y = 31237}, 7
    local dragonCount = 70
    spawnWave(from, to, z, "Dragon", dragonCount)
end

local function dragons2_wave()
    local from, to, z = {x = 33195, y = 31185}, {x = 33286, y = 31247}, 7
    local dragonCount = 40
    spawnWave(from, to, z, "Dragon", dragonCount)
end

local function dragons3_wave()
    local from, to, z = {x = 33284, y = 31169}, {x = 33350, y = 31196}, 7
    local dragonCount = 40
    spawnWave(from, to, z, "Dragon", dragonCount)
end

local function draptor_wave()
    local draptorPositions = {
        Position(33206, 31247, 7),
        Position(33256, 31235, 7),
		Position(33214, 31187, 7),
		Position(33236, 31168, 7),
		Position(33307, 31185, 7),
		Position(33338, 31197, 7),
		Position(33256, 31158, 7),
		Position(33234, 31185, 7)
    }

    for _, pos in ipairs(draptorPositions) do
        local draptor = Game.createMonster("Draptor", pos)
        if draptor then
            draptor:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
        end
    end
end

local function grandmother_wave()
    local grandmo = Game.createMonster("Grand Mother Foulscale", Position(33311, 31177, 7))
    if grandmo then
		grandmo:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
    addEvent(warning, 1000)
	addEvent(dragons_wave, 20000)
	addEvent(dragons2_wave, 10000)
	addEvent(dragons3_wave, 10000)
	addEvent(draptor_wave, 120000)
	addEvent(grandmother_wave, 120000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Draptor (Farmine). [Executed: %s]", currentTime))
    return true
end

--raid:register()
