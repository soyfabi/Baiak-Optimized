local raid = GlobalEvent("Undead_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("The dead of the plains of havoc are becoming restless!", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("A veritable army of undead is amassing in the plains of havoc, beware!", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("The dreaded banshee lead their undead minions to claim the plains of havoc!", MESSAGE_STATUS_WARNING)
end

local function spawnWave(from, to, z, monsterName, count)
    for _ = 1, count do
        local x, y = math.random(from.x, to.x), math.random(from.y, to.y)
        local monster = Game.createMonster(monsterName, Position(x, y, z))
        if monster then
            monster:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
        end
    end
end

local function undead_wave()
    local from, to, z = {x = 32789, y = 32277}, {x = 32836, y = 32299}, 7
	local skeletonCount = 35
	local bansheeCount = 12
	local ghoulCount = 22
	local demonSkeletonCount = 18
	local vampireCount = 15
	
    spawnWave(from, to, z, "Skeleton", skeletonCount)
	spawnWave(from, to, z, "Banshee", bansheeCount)
	spawnWave(from, to, z, "Ghoul", ghoulCount)
	spawnWave(from, to, z, "Demon Skeleton", demonSkeletonCount)
	spawnWave(from, to, z, "Vampire", vampireCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(warning2, 20000)
	addEvent(warning3, 60000)
	addEvent(undead_wave, 60000)
	
    
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Undead (Venore). [Executed: %s]", currentTime))
    return true
end

--raid:register()
