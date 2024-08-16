local raid = GlobalEvent("Terramite_raids")
raid:type("timer")
raid:interval(1800)

local function warning()
	Game.broadcastMessage("Something is moving under the surface in the sand north of Ankrahmun!", MESSAGE_STATUS_WARNING)
end

local function warning2()
	Game.broadcastMessage("Terramites north of Ankrahmun!", MESSAGE_STATUS_WARNING)
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

local function terramite_wave()
    local from, to, z = {x = 33134, y = 32697}, {x = 33189, y = 32742}, 7
    local terramiteCount = 30
	spawnWave(from, to, z, "Terramite", terramiteCount)
end

function raid.onTime(interval)
	addEvent(warning, 1000)
    addEvent(warning2, 120000)
	addEvent(terramite_wave, 120000)

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    print(string.format("--> Raid: Terramite (Ankrahmun). [Executed: %s]", currentTime))
    return true
end

--raid:register()
