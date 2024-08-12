local raid = GlobalEvent("Gigantica3_raids")
raid:type("timer")
raid:interval(1800)

local function gigan_wave()
    local gigan = Game.createMonster("Crustacea Gigantica", Position(32096, 32738, 12))
	if gigan then
		gigan:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(gigan_wave, 10000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Crustacea Gigantica_3 (Liberty Bay). [Executed: %s]", currentTime))
    return true
end

--raid:register()
