local raid = GlobalEvent("Whitepale_raids")
raid:type("timer")
raid:interval(1800)

local function whitepale_wave()
    local whitep = Game.createMonster("White Pale", Position(33264, 31875, 11))
	if whitep then
		whitep:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(whitepale_wave, 1000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: White Pale (Darashia). [Executed: %s]", currentTime))
    return true
end

--raid:register()
