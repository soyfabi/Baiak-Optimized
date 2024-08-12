local raid = GlobalEvent("Necropharus_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Beware of Necropharus!", MESSAGE_STATUS_WARNING)
end

local function necrop_wave()
    local necro = Game.createMonster("Necropharus", Position(33044, 32401, 10))
	if necro then
		necro:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(necrop_wave, 1000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Necropharus (Darashia). [Executed: %s]", currentTime))
    return true
end

--raid:register()
