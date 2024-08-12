local raid = GlobalEvent("Orcbackpack_raids")
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

local function orcback_wave()
    local from, to, z = {x = 32964, y = 31735}, {x = 32981, y = 31756}, 7
    local orcBackpackCount = 1
    spawnWave(from, to, z, "Orc Sambackpack", orcBackpackCount)
end

function raid.onTime(interval)
	addEvent(orcback_wave, 1000)
    
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Orc Backpack (Venore). [Executed: %s]", currentTime))
    return true
end

--raid:register()
