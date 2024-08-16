local raid = GlobalEvent("Waterbuffalo_raids")
raid:type("timer")
raid:interval(1800)

local function spawnWave(from, to, z, monsterName, count)
    for _ = 1, count do
        local x, y = math.random(from.x, to.x), math.random(from.y, to.y)
        local monster = Game.createMonster(monsterName, Position(x, y, z))
        if monster then
            monster:setStorageValue(monsterRaidStorages.FONTICAK_TOKEN, 1)
        end
    end
end

local waterBuffaloCount = 4

local function waterBuffalo_wave()
    local from, to, z = {x = 32857, y = 32135}, {x = 32865, y = 32142}, 7
    spawnWave(from, to, z, "Water Buffalo", waterBuffaloCount)
end

local function waterBuffalo2_wave()
    local from, to, z = {x = 32874, y = 32201}, {x = 32882, y = 32207}, 7
    spawnWave(from, to, z, "Water Buffalo", waterBuffaloCount)
end

local function waterBuffalo3_wave()
    local from, to, z = {x = 32881, y = 32229}, {x = 32885, y = 32233}, 7
    spawnWave(from, to, z, "Water Buffalo", waterBuffaloCount)
end

local function waterBuffalo4_wave()
    local from, to, z = {x = 32942, y = 32260}, {x = 32951, y = 32266}, 7
    spawnWave(from, to, z, "Water Buffalo", waterBuffaloCount)
end

local function waterBuffalo5_wave()
    local from, to, z = {x = 32957, y = 32226}, {x = 32965, y = 32236}, 7
    spawnWave(from, to, z, "Water Buffalo", waterBuffaloCount)
end

local function waterBuffalo6_wave()
    local from, to, z = {x = 32818, y = 32168}, {x = 32825, y = 32173}, 7
    spawnWave(from, to, z, "Water Buffalo", waterBuffaloCount)
end

local function waterBuffalo7_wave()
    local from, to, z = {x = 33091, y = 32069}, {x = 33095, y = 32073}, 7
    spawnWave(from, to, z, "Water Buffalo", waterBuffaloCount)
end

local function waterBuffalo8_wave()
    local from, to, z = {x = 33057, y = 32141}, {x = 33062, y = 32148}, 7
    spawnWave(from, to, z, "Water Buffalo", waterBuffaloCount)
end

function raid.onTime(interval)
	addEvent(waterBuffalo_wave, 1000)
	addEvent(waterBuffalo2_wave, 1000)
	addEvent(waterBuffalo3_wave, 1000)
	addEvent(waterBuffalo4_wave, 1000)
	addEvent(waterBuffalo5_wave, 1000)
	addEvent(waterBuffalo6_wave, 1000)
	addEvent(waterBuffalo7_wave, 1000)
	addEvent(waterBuffalo8_wave, 1000)
    
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Water Buffalo (Venore). [Executed: %s]", currentTime))
    return true
end

--raid:register()
