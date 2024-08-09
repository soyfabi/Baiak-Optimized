local raid = GlobalEvent("Icegolems_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("There is a sudden rise in ice golem population in Formogar mines.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("More ice golems in Svargrond!", MESSAGE_STATUS_WARNING)
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

local function icegolem_wave()
    local from, to, z = {x = 32093, y = 31094}, {x = 32155, y = 31190}, 5
    local iceGolemCount = 15
	
    spawnWave(from, to, z, "Ice Golem", iceGolemCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(warning2, 20000)
	addEvent(icegolem_wave, 20000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Ice Golem (Svargrond). [Executed: %s]", currentTime))
    return true
end

--raid:register()
