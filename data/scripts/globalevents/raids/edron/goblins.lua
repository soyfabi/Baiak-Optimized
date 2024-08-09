local raid = GlobalEvent("Goblins_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Goblins are converging west of Edron.", MESSAGE_STATUS_WARNING)
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

local function goblins_wave()
    local from, to, z = {x = 33101, y = 31795}, {x = 33136, y = 31836}, 7
    local goblinCount = 40
	local goblinScavengerCount = 10
	local goblinAssassinCount = 15
    spawnWave(from, to, z, "Goblin", goblinCount)
	spawnWave(from, to, z, "Goblin Scavenger", goblinScavengerCount)
	spawnWave(from, to, z, "Goblin Assassin", goblinAssassinCount)
end

function raid.onTime(interval)
    addEvent(warning, 1000)
	addEvent(goblins_wave, 1000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Goblins (Edron). [Executed: %s]", currentTime))
    return true
end

--raid:register()
