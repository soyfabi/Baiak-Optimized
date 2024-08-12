local raid = GlobalEvent("Zushuka_raids")
raid:type("timer")
raid:interval(1800)

local function zushuka_wave()
	local zushuka = Game.createMonster("Zushuka", Position(31941, 31388, 9))
    if zushuka then
		zushuka:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(zushuka_wave, 2000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Zushuka (Svargrond). [Executed: %s]", currentTime))
    return true
end

--raid:register()
