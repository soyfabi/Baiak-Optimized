local raid = GlobalEvent("Orc_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Some Orcs are assembling in the woods between Carlin and Northport.", MESSAGE_STATUS_WARNING)
end

local function warning_berserker()
	Game.broadcastMessage("Orcs attacking Carlin from the north-east!", MESSAGE_STATUS_WARNING)
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

local function orc_wave()
    local from, to, z = {x = 32404, y = 31604}, {x = 32436, y = 31642}, 7
    local orcCount = 50
    spawnWave(from, to, z, "Orc", orcCount)
end

local function orc_berserker()
    local from, to, z = {x = 32404, y = 31604}, {x = 32436, y = 31642}, 7
    local orcberserkerCount = 20
	local orcleaderCount = 15
	local orcshamanCount = 15
    spawnWave(from, to, z, "Orc Berserker", orcberserkerCount)
	spawnWave(from, to, z, "Orc Leader", orcleaderCount)
	spawnWave(from, to, z, "Orc Shaman", orcshamanCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(orc_wave, 20000)
	addEvent(warning_berserker, 40000)
	addEvent(orc_berserker, 40000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Orc (Carlin). [Executed: %s]", currentTime))
    return true
end

--raid:register()
