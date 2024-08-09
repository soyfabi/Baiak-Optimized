local raid = GlobalEvent("Ocyakao_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Beware of Ocyakao!", MESSAGE_STATUS_WARNING)
end

local function ocyakao_wave()
	local ocyakao = Game.createMonster("Ocyakao", Position(32353, 31052, 7))
    if ocyakao then
		ocyakao:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(warning, 2000)
	addEvent(ocyakao_wave, 2000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Ocyakao (Svargrond). [Executed: %s]", currentTime))
    return true
end

--raid:register()
