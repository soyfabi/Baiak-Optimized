local raid = GlobalEvent("Omrafir_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Omrafir is about to make his way into the roshamuul prison. Run for your lives!", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Bewarehas Omrafir.", MESSAGE_STATUS_WARNING)
end

local function omrafir_wave()
    local omrafir = Game.createMonster("Omrafir", Position(33587, 32378, 12))
	if omrafir then
		omrafir:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
	end
end

function raid.onTime(interval)
	addEvent(warning, 20000)
	addEvent(warning2, 60000)
	addEvent(omrafir_wave, 60000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Omrafir (Roshamuul). [Executed: %s]", currentTime))
    return true
end

--raid:register()
