local raid = GlobalEvent("Gargoyle_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("There is something stony moving down in the Ankrahmun Rahemos tombs.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Gargoyle attack in the Ankrahmun Rahemos tombs!", MESSAGE_STATUS_WARNING)
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

local function gargoyle_wave()
    local from, to, z = {x = 33141, y = 32680}, {x = 33173, y = 32699}, 12
    local gargoyleCount = 15
    spawnWave(from, to, z, "Gargoyle", gargoyleCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(warning2, 20000)
	addEvent(gargoyle_wave, 20000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Gargoyle (Ankrahmun). [Executed: %s]", currentTime))
    return true
end

--raid:register()
