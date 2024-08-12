local raid = GlobalEvent("Diblisthefair_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Beware of Diblis The Fair!", MESSAGE_STATUS_WARNING)
end

local function diblis_wave()
    local diblis = Game.createMonster("Diblis The Fair", Position(32009, 32795, 10))
	if diblis then
		diblis:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(diblis_wave, 10000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Diblis The Fair (Liberty Bay). [Executed: %s]", currentTime))
    return true
end

--raid:register()
