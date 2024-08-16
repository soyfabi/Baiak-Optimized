local raid = GlobalEvent("Dharalion_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Beware! Beware of the Dharalion!", MESSAGE_STATUS_WARNING)
end

local function dharalion_wave()
	local dharalion = Game.createMonster("Dharalion", Position(33038, 32176, 9))
    if dharalion then
		dharalion:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(dharalion_wave, 1000)
    
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Dharalion (Venore). [Executed: %s]", currentTime))
    return true
end

--raid:register()
