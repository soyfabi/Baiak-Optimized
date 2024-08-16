local raid = GlobalEvent("Zulazza_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("A massive orc force is gathering at the gates of Zzaion.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Orc reinforcements have arrived at the gates of Zzaion! The gates are under heavy attack!", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("More orc reinforcements have arrived at the gates of Zzaion! The gates are under heavy attack!", MESSAGE_STATUS_WARNING)
end

local function warning4()
	Game.broadcastMessage("The gates to Zzaion have been breached! Orcs are invading the city!", MESSAGE_STATUS_WARNING)
end

local function warning5()
	Game.broadcastMessage("More orcs have arrived in Zzaion! The city is under attack! Strong lizard leaders have come to defend the city.", MESSAGE_STATUS_WARNING)
end

local function zulazza_wave()
    local zulazza = Game.createMonster("Zulazza the Corruptor", Position(33348, 31609, 1))
	if zulazza then
		zulazza:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
	end
	local chizzoron = Game.createMonster("Chizzoron the Distorter", Position(33344, 31605, 4))
	if chizzoron then
		chizzoron:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
	end
end

function raid.onTime(interval)
    addEvent(warning, 1000)
	addEvent(warning2, 30000)
	addEvent(warning3, 60000)
	addEvent(warning4, 90000)
	addEvent(warning5, 120000)
	addEvent(zulazza_wave, 120000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Zulazza the corruptor (Farmine). [Executed: %s]", currentTime))
    return true
end

--raid:register()
