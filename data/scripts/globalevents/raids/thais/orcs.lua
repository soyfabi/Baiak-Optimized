local raid = GlobalEvent("Orc_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Orc activity near Thais reported! Beware!", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Thais is under attack!", MESSAGE_STATUS_WARNING)
end

local function Orc_Helmet()
	local orc_helmet = Game.createMonster("Orc Helmet", Position(32368, 32162, 7))
	if orc_helmet then
		orc_helmet:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
	end
end

local function Orc_Shield()
	local orc_shield = Game.createMonster("Orc Shield", Position(32344, 32287, 7))
	if orc_shield then
		orc_shield:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
	end
end

local function Orc_Armor()
	local orc_armor = Game.createMonster("Orc Armor", Position(32271, 32282, 7))
	if orc_armor then
		orc_armor:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
	end
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

local function orcs_wave()
    local from, to, z = {x = 32358, y = 32161}, {x = 32374, y = 32173}, 7
    local orcShamanCount = 3
	local orcBerserkerCount = 3
	local orcWarlordCount = 1
	local orcRiderCount = 5
	local orcCount = 3
    spawnWave(from, to, z, "Orc Shaman", orcShamanCount)
	spawnWave(from, to, z, "Orc Berserker", orcBerserkerCount)
	spawnWave(from, to, z, "Orc Warlord", orcWarlordCount)
	spawnWave(from, to, z, "Orc Rider", orcRiderCount)
	spawnWave(from, to, z, "Orc", orcCount)
end

local function orcs2_wave()
    local from, to, z = {x = 32452, y = 32235}, {x = 32437, y = 32220}, 7
    local orcShamanCount = 3
	local orcBerserkerCount = 2
	local orcWarlordCount = 1
	local orcRiderCount = 3
	local orcCount = 3
    spawnWave(from, to, z, "Orc Shaman", orcShamanCount)
	spawnWave(from, to, z, "Orc Berserker", orcBerserkerCount)
	spawnWave(from, to, z, "Orc Warlord", orcWarlordCount)
	spawnWave(from, to, z, "Orc Rider", orcRiderCount)
	spawnWave(from, to, z, "Orc", orcCount)
end

local function orcs3_wave()
    local from, to, z = {x = 32348, y = 32286}, {x = 32335, y = 32297}, 7
    local orcShamanCount = 3
	local orcBerserkerCount = 2
	local orcWarlordCount = 1
	local orcRiderCount = 3
	local orcCount = 3
    spawnWave(from, to, z, "Orc Shaman", orcShamanCount)
	spawnWave(from, to, z, "Orc Berserker", orcBerserkerCount)
	spawnWave(from, to, z, "Orc Warlord", orcWarlordCount)
	spawnWave(from, to, z, "Orc Rider", orcRiderCount)
	spawnWave(from, to, z, "Orc", orcCount)
end

local function orcs4_wave()
    local from, to, z = {x = 32261, y = 32271}, {x = 32287, y = 32297}, 7
    local orcShamanCount = 3
	local orcBerserkerCount = 2
	local orcWarlordCount = 1
	local orcRiderCount = 3
	local orcCount = 3
    spawnWave(from, to, z, "Orc Shaman", orcShamanCount)
	spawnWave(from, to, z, "Orc Berserker", orcBerserkerCount)
	spawnWave(from, to, z, "Orc Warlord", orcWarlordCount)
	spawnWave(from, to, z, "Orc Rider", orcRiderCount)
	spawnWave(from, to, z, "Orc", orcCount)
end

local function orcs5_wave()
    local from, to, z = {x = 32358, y = 32161}, {x = 32374, y = 32173}, 7
    local orcShamanCount = 4
	
    spawnWave(from, to, z, "Orc Shaman", orcShamanCount)
end

local function orcs6_wave()
    local from, to, z = {x = 32360, y = 32161}, {x = 32374, y = 32173}, 7
    local orcBerserkerCount = 3
	local orcWarlordCount = 3
	local orcCount = 3
	local orcRiderCount = 3
	
    spawnWave(from, to, z, "Orc Berserker", orcBerserkerCount)
	spawnWave(from, to, z, "Orc Warlord", orcWarlordCount)
	spawnWave(from, to, z, "Orc", orcCount)
	spawnWave(from, to, z, "Orc Rider", orcRiderCount)
end

local function orcs7_wave()
    local from, to, z = {x = 32452, y = 32235}, {x = 32437, y = 32220}, 7
	local orcShamanCount = 3
    local orcBerserkerCount = 3
	local orcWarlordCount = 1
	local orcCount = 3
	local orcRiderCount = 3
	
	spawnWave(from, to, z, "Orc Shaman", orcShamanCount)
    spawnWave(from, to, z, "Orc Berserker", orcBerserkerCount)
	spawnWave(from, to, z, "Orc Warlord", orcWarlordCount)
	spawnWave(from, to, z, "Orc", orcCount)
	spawnWave(from, to, z, "Orc Rider", orcRiderCount)
end

local function orcs8_wave()
    local from, to, z = {x = 32348, y = 32286}, {x = 32335, y = 32297}, 7
	local orcShamanCount = 3
    local orcBerserkerCount = 3
	local orcWarlordCount = 1
	local orcCount = 3
	local orcRiderCount = 3
	
	spawnWave(from, to, z, "Orc Shaman", orcShamanCount)
    spawnWave(from, to, z, "Orc Berserker", orcBerserkerCount)
	spawnWave(from, to, z, "Orc Warlord", orcWarlordCount)
	spawnWave(from, to, z, "Orc", orcCount)
	spawnWave(from, to, z, "Orc Rider", orcRiderCount)
end

local function orcs9_wave()
    local from, to, z = {x = 32261, y = 32271}, {x = 32287, y = 32297}, 7
	local orcShamanCount = 3
    local orcBerserkerCount = 3
	local orcWarlordCount = 1
	local orcCount = 3
	local orcRiderCount = 3
	
	spawnWave(from, to, z, "Orc Shaman", orcShamanCount)
    spawnWave(from, to, z, "Orc Berserker", orcBerserkerCount)
	spawnWave(from, to, z, "Orc Warlord", orcWarlordCount)
	spawnWave(from, to, z, "Orc", orcCount)
	spawnWave(from, to, z, "Orc Rider", orcRiderCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
	addEvent(warning2, 60000)
	addEvent(orcs_wave, 60000)
	addEvent(orcs2_wave, 60000)
	addEvent(orcs3_wave, 60000)
	addEvent(orcs4_wave, 60000)
	addEvent(orcs5_wave, 120000)
	addEvent(orcs6_wave, 120000)
	addEvent(orcs7_wave, 120000)
	addEvent(orcs8_wave, 120000)
	addEvent(orcs9_wave, 120000)
	addEvent(Orc_Helmet, 120000)
	addEvent(Orc_Shield, 120000)
	addEvent(Orc_Armor, 120000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Orcs (Thais). [Executed: %s]", currentTime))
    return true
end

--raid:register()