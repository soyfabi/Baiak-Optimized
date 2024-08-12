local raid = GlobalEvent("Cobra_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("There's something sizzling in the Ankrahmun Dipthrah tombs.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Even more sizzling in the Ankrahmun Dipthrah tombs.", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("Poison overflow in the Ankrahmun Dipthrah tombs!", MESSAGE_STATUS_WARNING)
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

local function cobra_wave()
    local from, to, z = {x = 33129, y = 32569}, {x = 33156, y = 32598}, 7
    local cobraCount = 25
    spawnWave(from, to, z, "Cobra", cobraCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(warning2, 20000)
	addEvent(warning3, 30000)
	addEvent(cobra_wave, 40000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Cobra (Ankrahmun). [Executed: %s]", currentTime))
    return true
end

--raid:register()
