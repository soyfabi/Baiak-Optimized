local raid = GlobalEvent("Elves_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Elf Scouts have been sighted near Venore!", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("The elves attack from shadowthorn!", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("Venore is under attack!", MESSAGE_STATUS_WARNING)
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

local function elves_wave()
    local from, to, z = {x = 32853, y = 32123}, {x = 32861, y = 32130}, 7
	local elfCount = 4
	local elfScoutCount = 4
	local elfArcanistCount = 3

    spawnWave(from, to, z, "Elf", elfCount)
	spawnWave(from, to, z, "Elf Scout", elfScoutCount)
	spawnWave(from, to, z, "Elf Arcanist", elfArcanistCount)
end

local function elves2_wave()
    local from, to, z = {x = 32932, y = 32158}, {x = 32944, y = 32168}, 7
	local elfCount = 4
	local elfScoutCount = 4
	local elfArcanistCount = 3

    spawnWave(from, to, z, "Elf", elfCount)
	spawnWave(from, to, z, "Elf Scout", elfScoutCount)
	spawnWave(from, to, z, "Elf Arcanist", elfArcanistCount)
end

local function elves3_wave()
    local from, to, z = {x = 32853, y = 32025}, {x = 32868, y = 32034}, 7
	local elfCount = 4
	local elfScoutCount = 4
	local elfArcanistCount = 3

    spawnWave(from, to, z, "Elf", elfCount)
	spawnWave(from, to, z, "Elf Scout", elfScoutCount)
	spawnWave(from, to, z, "Elf Arcanist", elfArcanistCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(warning2, 20000)
	addEvent(warning3, 60000)
	addEvent(elves_wave, 60000)
	addEvent(elves2_wave, 60000)
	addEvent(elves3_wave, 60000)
	
    
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Elves (Venore). [Executed: %s]", currentTime))
    return true
end

--raid:register()
