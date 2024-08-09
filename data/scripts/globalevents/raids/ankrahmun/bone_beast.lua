local raid = GlobalEvent("Bonebeast_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Bonebeasts are rattling down in the Ankrahmun Dipthrah tombs.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Bonebeasts roaming around in the Ankrahmun Dipthrah tombs.", MESSAGE_STATUS_WARNING)
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

local function bonebeast_wave()
    local from, to, z = {x = 33129, y = 32569}, {x = 33156, y = 32598}, 7
    local boneBeastCount = 15
    spawnWave(from, to, z, "Bonebeast", boneBeastCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(warning2, 20000)
	addEvent(bonebeast_wave, 20000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Bonebeast (Ankrahmun). [Executed: %s]", currentTime))
    return true
end

--raid:register()
