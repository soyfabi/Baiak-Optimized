local raid = GlobalEvent("Oldwidow_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("The mating season of the giant spiders is at hand. Leave the plains of havoc as fast as you can.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Giant spiders have gathered on the plains of havoc for their mating season. Beware!", MESSAGE_STATUS_WARNING)
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

local function oldwidow_wave()
    local widow = Game.createMonster("The Old Widow", Position(32776, 32296, 7))
	if widow then
		widow:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
	end
end

local function giantspider_wave()
    local from, to, z = {x = 32760, y = 32292}, {x = 32796, y = 32306}, 7
	local giantSpiderCount = 10

    spawnWave(from, to, z, "Giant Spider", giantSpiderCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(warning2, 180000)
	addEvent(giantspider_wave, 170000)
	addEvent(oldwidow_wave, 180000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: The Old Widow (Venore). [Executed: %s]", currentTime))
    return true
end

--raid:register()
