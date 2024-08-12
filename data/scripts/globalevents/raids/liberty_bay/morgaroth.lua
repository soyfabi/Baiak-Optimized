local raid = GlobalEvent("Morgaroth_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("The ancient volcano on Goroma slowly becomes active once again.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("There is an evil presence at the volcano of Goroma.", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("Evil Cultists have called an ancient evil into the volcano on Goroma. Beware of its power mortals.", MESSAGE_STATUS_WARNING)
end

local function morga_wave()
    local morga = Game.createMonster("Morgaroth", Position(32063, 32612, 14))
	if morga then
		morga:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(warning2, 30000)
	addEvent(warning3, 60000)
	addEvent(morga_wave, 60000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Morgaroth (Liberty Bay). [Executed: %s]", currentTime))
    return true
end

--raid:register()
