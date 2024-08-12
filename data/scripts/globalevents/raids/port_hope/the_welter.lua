local raid = GlobalEvent("Thewelter_raids")
raid:type("timer")
raid:interval(1800)

local function welter_wave()  
    local welter = Game.createMonster("The Welter", Position(33026, 32660, 5))
    if welter then
		welter:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
    addEvent(welter_wave, 1000)
	
	local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: The Welter (Port Hope). [Executed: %s]", currentTime))
    return true
end

--raid:register()
