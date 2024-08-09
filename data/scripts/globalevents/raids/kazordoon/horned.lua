local raid = GlobalEvent("Horned_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Beware of The horned Fox!", MESSAGE_STATUS_WARNING)
end

local function horned_wave()
    local horned = Game.createMonster("Minotaur mage", Position(32466, 31955, 4))
	if horned then
		horned:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

local function horned2_wave()
	local horned = Game.createMonster("the Horned Fox", Position(32463, 31954, 4))
	if horned then
		horned:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(horned_wave, 2000)
	addEvent(horned2_wave, 20000)
	
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Horned (Kazordoon). [Executed: %s]", currentTime))
    return true
end

--raid:register()
