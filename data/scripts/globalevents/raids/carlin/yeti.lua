local raid = GlobalEvent("Yeti_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Something is moving to the icy grounds of Folda.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Many Yetis are emerging from the icy mountains of Folda.", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("Numerous Yetis are dominating Folda, beware!", MESSAGE_STATUS_WARNING)
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

local function yeti_wave()
    local from, to, z = {x = 31991, y = 31580}, {x = 32044, y = 31616}, 7
    local yetiCount = 60
    spawnWave(from, to, z, "Yeti", yetiCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(warning2, 20000)
	addEvent(warning3, 60000)
    addEvent(yeti_wave, 60000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Yeti (Carlin). [Executed: %s]", currentTime))
    return true
end

--raid:register()
