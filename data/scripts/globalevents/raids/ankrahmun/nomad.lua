local raid = GlobalEvent("Nomad_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Nomad scouts have been sighted close to the gates to Ankrahmun.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("The desert nomads are launching a full scale attack on Ankrahmun. Some might even have slipped through the defences!", MESSAGE_STATUS_WARNING)
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

local function nomad_wave()
    local from, to, z = {x = 33254, y = 32752}, {x = 33073, y = 32765}, 7
    local nomadCount = 160
    spawnWave(from, to, z, "Nomad", nomadCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(warning2, 35000)
	addEvent(nomad_wave, 36000)
	addEvent(nomad_wave, 66000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Nomad (Ankrahmun). [Executed: %s]", currentTime))
    return true
end

--raid:register()
