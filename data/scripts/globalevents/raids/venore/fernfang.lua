local raid = GlobalEvent("Fernfang_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Beware Fernfang.", MESSAGE_STATUS_WARNING)
end

local function fernfang_wave()
	local fernfang = Game.createMonster("Fernfang", Position(32851, 32337, 6))
    if fernfang then
		fernfang:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

local function warwolf_wave()
	local warwolf = Game.createMonster("War Wolf", Position(32852, 32335, 6))
    if warwolf then
		warwolf:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

local function warwolf2_wave()
	local warwolf = Game.createMonster("War Wolf", Position(32858, 32334, 6))
    if warwolf then
		warwolf:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(fernfang_wave, 2000)
	addEvent(warwolf_wave, 3000)
	addEvent(warwolf2_wave, 5000)
    
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Fernfang (Venore). [Executed: %s]", currentTime))
    return true
end

--raid:register()
