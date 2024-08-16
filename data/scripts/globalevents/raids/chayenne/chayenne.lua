local raid = GlobalEvent("Chayenne_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("An immense force is approaching Draconia.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Get prepare mortals, the visit of Chayenne is near.", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("Chayenne has returned to his citadel once more. Be careful there.", MESSAGE_STATUS_WARNING)
end

local function chayenne_wave()
	local chayenne = Game.createMonster("Chayenne", Position(32799, 31604, 7))
	if chayenne then
		chayenne:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(warning2, 50000)
	addEvent(warning3, 60000)
    addEvent(chayenne_wave, 60000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Chayenne (Draconia). [Executed: %s]", currentTime))
    return true
end

--raid:register()
