local raid = GlobalEvent("Barbabittermor_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Barbarians are gathering at Bittermor. They seem to be up to something.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("The barbarian pack is roaming around in Bittermor.", MESSAGE_STATUS_WARNING)
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
    local from, to, z = {x = 31971, y = 31259}, {x = 31989, y = 31276}, 7
    local barbarianBloodwalkerCount = 5
	local barbarianBrutetamerCount = 3
	local barbarianHeadsplitterCount = 5
	local barbarianSkullhunterCount = 10
	
    spawnWave(from, to, z, "Barbarian Bloodwalker", barbarianBloodwalkerCount)
	spawnWave(from, to, z, "Barbarian Brutetamer", barbarianBrutetamerCount)
	spawnWave(from, to, z, "Barbarian Headsplitter", barbarianHeadsplitterCount)
	spawnWave(from, to, z, "Barbarian Skullhunter", barbarianSkullhunterCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(warning2, 20000)
	addEvent(barbarians_wave, 20000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Barbarians (Svargrond). [Executed: %s]", currentTime))
    return true
end

--raid:register()
