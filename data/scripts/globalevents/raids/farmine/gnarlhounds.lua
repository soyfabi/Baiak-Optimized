local raid = GlobalEvent("Gharl_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("There seems to be a big gnarlhoud gang in Zao Steppe.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("The gnarlhounds seem to multiply by the minute.", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("The gnarlhounds roam free in the Zao Steppe. Watch out!", MESSAGE_STATUS_WARNING)
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

local function gnarl_wave()
    local from, to, z = {x = 33065, y = 31411}, {x = 33149, y = 31474}, 7
    local gnarlhoundCount = 20
    spawnWave(from, to, z, "Gnarlhound", gnarlhoundCount)
end

function raid.onTime(interval)
    addEvent(warning, 1000)
	addEvent(warning2, 20000)
	addEvent(warning3, 120000)
	addEvent(gnarl_wave, 120000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Gnarlhounds (Farmine). [Executed: %s]", currentTime))
    return true
end

--raid:register()
