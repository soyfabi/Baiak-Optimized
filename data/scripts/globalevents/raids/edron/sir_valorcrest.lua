local raid = GlobalEvent("Sirvalorcrest_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Beware of Sir Valorcrest!", MESSAGE_STATUS_WARNING)
end

local function sirv_wave()
    local sirvalor = Game.createMonster("Sir Valorcrest", Position(33264, 31768, 10))
	if sirvalor then
		sirvalor:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
    addEvent(warning, 1000)
	addEvent(sirv_wave, 1000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Sir Valorcrest (Edron). [Executed: %s]", currentTime))
    return true
end

--raid:register()
