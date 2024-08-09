local raid = GlobalEvent("Gazharagoth_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Something out of the ordinary, it's better we hide now!", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("His strength is unlimited, the demons kneeling before him!", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("The dreaded Gaz'Haragoth is invading the land from prison.", MESSAGE_STATUS_WARNING)
end

local function warning4()
	Game.broadcastMessage("Leave now mortals, beware Gaz'Haragoth.", MESSAGE_STATUS_WARNING)
end

local function gazharagoth_wave()
    local gazharagoth = Game.createMonster("Gaz'Haragoth", Position(33538, 32381, 12))
	if gazharagoth then
		gazharagoth:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
	end
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(warning2, 20000)
	addEvent(warning3, 50000)
	addEvent(warning4, 80000)
	addEvent(gazharagoth_wave, 80000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Gaz'haragoth (Roshamuul). [Executed: %s]", currentTime))
    return true
end

--raid:register()
