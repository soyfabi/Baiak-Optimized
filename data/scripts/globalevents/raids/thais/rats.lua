local raid = GlobalEvent("Rats_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Rat Plague in Thais!", MESSAGE_STATUS_WARNING)
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

local function rat_wave()
    local from, to, z = {x = 32331, y = 32182}, {x = 32426, y = 32261}, 7
    local ratCount = 20
	local caveratCount = 20
    spawnWave(from, to, z, "Rat", ratCount)
	spawnWave(from, to, z, "Cave Rat", caveratCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(rat_wave, 1000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Rats (Thais). [Executed: %s]", currentTime))
    return true
end

--raid:register()
