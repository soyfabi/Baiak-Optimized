local raid = GlobalEvent("Midnightpanther_raids")
raid:type("timer")
raid:interval(1800)

local function midnightpanther_wave()
	local midnightpanther = Game.createMonster("Midnight Panther", Position(32841, 32706, 7))
    if midnightpanther then
		midnightpanther:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(midnightpanther_wave, 2000)
    
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Midnight Panther (Port Hope). [Executed: %s]", currentTime))
    return true
end

--raid:register()
