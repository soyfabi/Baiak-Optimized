local raid = GlobalEvent("Hirintror_raids")
raid:type("timer")
raid:interval(1800)

local function hirintror_wave()
	local hirintror = Game.createMonster("Hirintror", Position(32101, 31167, 9))
    if hirintror then
		hirintror:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(hirintror_wave, 1000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Hirintror (Svargrond). [Executed: %s]", currentTime))
    return true
end

--raid:register()
