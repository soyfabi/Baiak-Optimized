local raid = GlobalEvent("Ferumbras_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("The seals on Ferumbras old cidatel are glowing. Prepare for HIS return mortals.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Ferumbras return is at hand. The Edron Academy calls for Heroes to fight that evil.", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("Ferumbras has returned to his citadel once more. Stop him before its too late.", MESSAGE_STATUS_WARNING)
end

local function feru_wave()
    local feru = Game.createMonster("Ferumbras", Position(32124, 32687, 4))
	if feru then
		feru:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(warning2, 80000)
	addEvent(warning3, 100000)
	addEvent(feru_wave, 100000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Ferumbras (Liberty Bay). [Executed: %s]", currentTime))
    return true
end

--raid:register()
