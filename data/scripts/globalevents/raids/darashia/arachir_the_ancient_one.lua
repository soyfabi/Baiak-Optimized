local raid = GlobalEvent("arachir_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Beware of Arachir the Ancient One!", MESSAGE_STATUS_WARNING)
end

local function arachir_wave()
    local arachir = Game.createMonster("Arachir the Ancient One", Position(32965, 32400, 12))
	if arachir then
		arachir:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(arachir_wave, 1000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Arachir the Ancient One (Darashia). [Executed: %s]", currentTime))
    return true
end

--raid:register()
