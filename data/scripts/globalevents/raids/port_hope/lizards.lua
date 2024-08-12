local raid = GlobalEvent("Lizard_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Lizards Sentinels seem to attack Port Hope from Chor.", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Lizards are advancing to Port Hope from Chor.", MESSAGE_STATUS_WARNING)
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

local function lizard_wave()
    local from, to, z = {x = 32882, y = 32804}, {x = 32818, y = 32764}, 7
    local lizardSnakecharmerCount = 5
	local lizardTemplarCount = 10
	local lizardSentinelCount = 5
    spawnWave(from, to, z, "Lizard Snakecharmer", lizardSnakecharmerCount)
	spawnWave(from, to, z, "Lizard Templar", lizardTemplarCount)
	spawnWave(from, to, z, "Lizard Sentinel", lizardSentinelCount)
end

local function lizard2_wave()
    local from, to, z = {x = 32882, y = 32804}, {x = 32818, y = 32764}, 7
    local lizardSnakecharmerCount = 10
	local lizardTemplarCount = 5
	local lizardSentinelCount = 5
    spawnWave(from, to, z, "Lizard Snakecharmer", lizardSnakecharmerCount)
	spawnWave(from, to, z, "Lizard Templar", lizardTemplarCount)
	spawnWave(from, to, z, "Lizard Sentinel", lizardSentinelCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(lizard_wave, 1000)
    addEvent(warning2, 120000)
	addEvent(lizard2_wave, 120000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Lizard (Port Hope). [Executed: %s]", currentTime))
    return true
end

--raid:register()
