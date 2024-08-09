local raid = GlobalEvent("Undeaddarashia_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Sightings of undead, west of Darashia! Imminent invasion is suspected!", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("The undead are attacking Darashia!", MESSAGE_STATUS_WARNING)
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
    local from, to, z = {x = 33156, y = 32414}, {x = 33182, y = 32458}, 7
    local vampireCount = 25
	local stalkerCount = 30
	local skeletonCount = 35
	local demonSkeletonCount = 35
	local bonelordCount = 25
	local necromancerCount = 25
	local bonebeastCount = 25
    spawnWave(from, to, z, "Vampire", vampireCount)
	spawnWave(from, to, z, "Stalker", stalkerCount)
	spawnWave(from, to, z, "Skeleton", skeletonCount)
	spawnWave(from, to, z, "Demon Skeleton", demonSkeletonCount)
	spawnWave(from, to, z, "Bonelord", bonelordCount)
	spawnWave(from, to, z, "Necromancer", necromancerCount)
	spawnWave(from, to, z, "Bonebeast", bonebeastCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(warning2, 10000)
	addEvent(undead_wave, 11000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Undead (Darashia). [Executed: %s]", currentTime))
    return true
end

--raid:register()
