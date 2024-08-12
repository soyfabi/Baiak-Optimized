local raid = GlobalEvent("Badger_raids")
raid:type("timer")
raid:interval(1800)

local function badger_wave()
    local from, to, z = {x = 32633, y = 31645}, {x = 32715, y = 31708}, 7
    for _ = 1, math.random(50, 100) do
        local x, y = math.random(from.x, to.x), math.random(from.y, to.y)
        local badger = Game.createMonster("Badger", Position(x, y, z))
        if badger then
            badger:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
        end
    end
    Game.broadcastMessage("Ab'dendriel is infected with Badgers, go there and finish them off.", MESSAGE_STATUS_WARNING)
	
	local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Badger (Ab'dendriel). [Executed: %s]", currentTime))
end

function raid.onTime(interval)
    addEvent(badger_wave, 1000)
    return true
end

--raid:register()
