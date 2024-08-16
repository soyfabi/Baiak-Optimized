local raid = GlobalEvent("Barbarian_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Scouts report a barbarian army gathering near Svargrond.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Some invaders might try to access Svargrond via the ice to the North.", MESSAGE_STATUS_WARNING)
end

local function warning3()
	Game.broadcastMessage("Raiders are attacking Svargrond!", MESSAGE_STATUS_WARNING)
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
    local from, to, z = {x = 32199, y = 31063}, {x = 32251, y = 31084}, 5
    local barbarianBloodwalkerCount = 35
	local barbarianBrutetamerCount = 22
	local barbarianHeadsplitterCount = 22
	local barbarianSkullhunterCount = 28
	local iceWitchCount = 15
	
    spawnWave(from, to, z, "Barbarian Bloodwalker", barbarianBloodwalkerCount)
	spawnWave(from, to, z, "Barbarian Brutetamer", barbarianBrutetamerCount)
	spawnWave(from, to, z, "Barbarian Headsplitter", barbarianHeadsplitterCount)
	spawnWave(from, to, z, "Barbarian Skullhunter", barbarianSkullhunterCount)
	spawnWave(from, to, z, "Ice Witch", iceWitchCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(warning2, 4000)
	addEvent(warning3, 8000)
	addEvent(barbarians_wave, 10000)
	
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Barbarian (Svargrond). [Executed: %s]", currentTime))
    return true
end

--raid:register()
