local raid = GlobalEvent("Crustaceagigantica_raids")
raid:type("timer")
raid:interval(1800)

local function crustaceagigantica_wave()
	local crustaceagigantica = Game.createMonster("Crustacea Gigantica", Position(33556, 31788, 14))
    if crustaceagigantica then
		crustaceagigantica:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
    end
end

function raid.onTime(interval)
	addEvent(crustaceagigantica_wave, 10000)
    
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Crustacea Gigantica (Oramond). [Executed: %s]", currentTime))
    return true
end

--raid:register()
