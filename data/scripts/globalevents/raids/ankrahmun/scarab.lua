local raid = GlobalEvent("Scarab_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Unusual frequent scarab sightings at the gates of Ankrahmun.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Ancient scarabs are leading an attack on Ankrahmun.", MESSAGE_STATUS_WARNING)
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

local function scarab_wave()
    local from, to, z = {x = 33254, y = 32752}, {x = 33073, y = 32765}, 7
    local larvaCount = 50
	local scarabCount = 30
	local ancientScarabCount = 16
    spawnWave(from, to, z, "Larva", nomadCount)
	spawnWave(from, to, z, "Scarab", nomadCount)
	spawnWave(from, to, z, "Ancient Scarab", nomadCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(warning2, 60000)
	addEvent(scarab_wave, 60000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Scarab (Ankrahmun). [Executed: %s]", currentTime))
    return true
end

--raid:register()
