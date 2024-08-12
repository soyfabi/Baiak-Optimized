local raid = GlobalEvent("Orsha_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Orshabaal's minions are working on his return to the World. LEAVE Edron at once, mortals.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Orshabaal is about to make his way into the mortal realm. Run for your lives!", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("Orshabaal has been summoned from hell to plague the lands of mortals once again.", MESSAGE_STATUS_WARNING)
end

local function orsha_wave()
    local orsha = Game.createMonster("Orshabaal", Position(33118, 31699, 7))
	if orsha then
		orsha:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
    addEvent(warning, 1000)
	addEvent(warning2, 20000)
	addEvent(warning3, 60000)
	addEvent(orsha_wave, 60000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Orshabaal (Edron). [Executed: %s]", currentTime))
    return true
end

--raid:register()
