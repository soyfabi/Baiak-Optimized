local raid = GlobalEvent("Weakenedshlorg_raids")
raid:type("timer")
raid:interval(1800)

local function weakenedsh_wave()
    local weakenedsh = Game.createMonster("Weakened Shlorg", Position(33164, 31716, 9))
	if weakenedsh then
		weakenedsh:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(weakenedsh, 2000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Weakened Shlorg (Edron). [Executed: %s]", currentTime))
    return true
end

--raid:register()
