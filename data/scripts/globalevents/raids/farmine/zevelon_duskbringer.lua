local raid = GlobalEvent("Zevelon_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Beware of Zevelon Duskbringer!", MESSAGE_STATUS_WARNING)
end

local function zevelon_wave()
    local zevelon = Game.createMonster("Zevelon Duskbringer", Position(32754, 31578, 11))
	if zevelon then
		zevelon:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
	end
end

function raid.onTime(interval)
    addEvent(warning, 1000)
	addEvent(zevelon_wave, 1000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Zevelon Duskbringer (Farmine). [Executed: %s]", currentTime))
    return true
end

--raid:register()
