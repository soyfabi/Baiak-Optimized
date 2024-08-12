local raid = GlobalEvent("Undeadcave_raids")
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

local function undead_wave()
    local from, to, z = {x = 31909, y = 32554}, {x = 31983, y = 32579}, 10
    local undeadCavebearCount = 3
    spawnWave(from, to, z, "Undead Cavebear", undeadCavebearCount)
end

function raid.onTime(interval)
	addEvent(undead_wave, 2000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Undead Cavebear (Liberty Bay). [Executed: %s]", currentTime))
    return true
end

--raid:register()
