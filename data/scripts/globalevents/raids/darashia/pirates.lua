local raid = GlobalEvent("Pirates_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Pillage and plunder! Pirates have been sighted north of Darashia!", MESSAGE_STATUS_WARNING)
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

local function pirates_wave()
    local from, to, z = {x = 33275, y = 32324}, {x = 33316, y = 32360}, 7
    local pirateBuccaneerCount = 20
	local pirateCutthroatCount = 15
	local pirateMarauderCount = 15
    spawnWave(from, to, z, "Pirate Buccaneer", pirateBuccaneerCount)
	spawnWave(from, to, z, "Pirate Cutthroat", pirateCutthroatCount)
	spawnWave(from, to, z, "Pirate Marauder", pirateMarauderCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(pirates_wave, 1000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Pirates (Darashia). [Executed: %s]", currentTime))
    return true
end

--raid:register()
