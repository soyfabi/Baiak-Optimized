local raid = GlobalEvent("Feroxa_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("An ancient evil is awakening in the grimvale mines.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Werewolfs entities are entering the mortal realm in the grimvale mines.", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("The Feroxa master has revealed itself in the mines of grimvale.", MESSAGE_STATUS_WARNING)
end

local function ferox_wave()
    local ferox = Game.createMonster("Feroxa", Position(33389, 31539, 11))
	if ferox then
		ferox:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
    addEvent(warning, 1000)
	addEvent(warning2, 20000)
	addEvent(warning3, 60000)
	addEvent(ferox_wave, 60000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Feroxa (Edron). [Executed: %s]", currentTime))
    return true
end

--raid:register()
