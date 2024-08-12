local raid = GlobalEvent("Goblins_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Goblins are preparing to attack Kazordoon from Femor Hills!", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Goblins attack from Femor Hills!", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("Danger! Now the goblin leaders attack Kazordoon from Femor Hills!", MESSAGE_STATUS_WARNING)
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

local function goblin_wave()
    local from, to, z = {x = 32485, y = 31835}, {x = 32621, y = 31911}, 7
    local goblinCount = 50
	local goblinScavengerCount = 15
	local goblinAssassinCount = 10
    spawnWave(from, to, z, "Goblin", goblinCount)
	spawnWave(from, to, z, "Goblin Scavenger", goblinScavengerCount)
	spawnWave(from, to, z, "Goblin Assassin", goblinAssassinCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(warning2, 20000)
	addEvent(goblin_wave, 20000)
	addEvent(warning3, 120000)
	
	addEvent(function() Game.createMonster("Goblin Leader", Position(32607, 31859, 7)) end, 120000)
	

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Goblin (Kazordoon). [Executed: %s]", currentTime))
    return true
end

--raid:register()
