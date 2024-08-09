local raid = GlobalEvent("Waaspbear_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Forrest animals spread out close to Ab'Dendriel!", MESSAGE_STATUS_WARNING)
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

local function waspbear_wave()
    local from, to, z = {x = 32600, y = 31712}, {x = 32634, y = 31739}, 7
    local waspCount = 30
    local bearCount = 30
    spawnWave(from, to, z, "Wasp", waspCount)
    spawnWave(from, to, z, "Bear", bearCount)
end

function raid.onTime(interval)
    addEvent(warning, 1000)
	addEvent(waspbear_wave, 60000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Wasp Bear (Ab'dendriel). [Executed: %s]", currentTime))
    return true
end

--raid:register()
