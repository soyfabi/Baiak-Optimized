local raid = GlobalEvent("Barbasvar_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Scouts report a barbarian army gathering near Svargrond.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Some invaders might try to access Svargrond via the ice to the south west.", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("Raiders are attacking Svargrond!", MESSAGE_STATUS_WARNING)
end

local function warning4()
	Game.broadcastMessage("The barbarians attacks on Svargrond are becoming more and more fierce!", MESSAGE_STATUS_WARNING)
end

local function warning5()
	Game.broadcastMessage("The barbarians are preparing for a final assault on Svargrond. Hide or fight!", MESSAGE_STATUS_WARNING)
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

local function barbarians_wave()
    local from, to, z = {x = 32175, y = 31178}, {x = 32207, y = 31208}, 5
    local barbarianBloodwalkerCount = 5
	local barbarianBrutetamerCount = 5
	local barbarianHeadsplitterCount = 5
	local barbarianSkullhunterCount = 5
	
    spawnWave(from, to, z, "Barbarian Bloodwalker", barbarianBloodwalkerCount)
	spawnWave(from, to, z, "Barbarian Brutetamer", barbarianBrutetamerCount)
	spawnWave(from, to, z, "Barbarian Headsplitter", barbarianHeadsplitterCount)
	spawnWave(from, to, z, "Barbarian Skullhunter", barbarianSkullhunterCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(warning2, 10000)
	addEvent(warning3, 30000)
	addEvent(warning4, 120000)
	addEvent(warning5, 180000)
	
	addEvent(barbarians_wave, 30000)
	addEvent(barbarians_wave, 120000)
	addEvent(barbarians_wave, 180000)
	
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Barbarian_Svar (Svargrond). [Executed: %s]", currentTime))
    return true
end

--raid:register()
