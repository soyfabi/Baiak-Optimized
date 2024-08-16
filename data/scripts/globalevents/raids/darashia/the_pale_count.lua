local raid = GlobalEvent("Thepalecount_raids")
raid:type("timer")
raid:interval(1800)

local function palecount_wave()
    local paleco = Game.createMonster("The Pale Count", Position(32969, 32420, 15))
	if paleco then
		paleco:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(palecount_wave, 2000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: The Pale Count (Darashia). [Executed: %s]", currentTime))
    return true
end

--raid:register()
