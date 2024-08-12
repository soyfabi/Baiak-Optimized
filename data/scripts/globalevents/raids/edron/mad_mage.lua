local raid = GlobalEvent("Madmage_raids")
raid:type("timer")
raid:interval(1800)

local function spawnWave(from, to, z, monsterName, count)
    for _ = 1, count do
        local x, y = math.random(from.x, to.x), math.random(from.y, to.y)
        local monster = Game.createMonster(monsterName, Position(x, y, z))
        if monster then
            monster:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
        end
    end
end

local function servant_wave()
    local from, to, z = {x = 33311, y = 31850}, {x = 33362, y = 31908}, 9
    local goldenServantCount = 7
	local ironServantCount = 7
    spawnWave(from, to, z, "Golden Servant", goldenServantCount)
	spawnWave(from, to, z, "Iron Servant", ironServantCount)
end

local function madmage_wave()
	local madm = Game.createMonster("Mad Mage", Position(33360, 31873, 9))
	if madm then
		madm:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
    addEvent(servant_wave, 10000)
	addEvent(madmage_wave, 20000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Mad Mage (Edron). [Executed: %s]", currentTime))
    return true
end

--raid:register()
