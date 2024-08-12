function Player.getTotalSavedKills(self)
    local Info = db.storeQuery("SELECT `frags` FROM `players` WHERE `id` = " .. self:getGuid())
    local frags = result.getDataInt(Info, 'frags')
    result.free(Info)
    return frags
end

function Player.getTotalSavedDeaths(self)
    local Info = db.storeQuery("SELECT `deaths` FROM `players` WHERE `id` = " .. self:getGuid())
    local deaths = result.getDataInt(Info, 'deaths')
    result.free(Info)
    return deaths
end

local login = CreatureEvent("KDR_REGISTER_EVENT")

function login.onLogin(player)
    player:registerEvent("KDR_KILL_EVENT")
    player:registerEvent("KDR_DEATH_EVENT")
    return true
end

login:register()

local kill = CreatureEvent("KDR_KILL_EVENT")

function kill.onKill(player)
    if not player:isPlayer() then
        return true
    end
 
    db.query("UPDATE `players` SET `frags` = `frags` + 1 WHERE id = " .. player:getGuid() .. ";") 
    return true
 end

kill:register()

local death = CreatureEvent("KDR_DEATH_EVENT")

function death.onDeath(player)
    if not player:isPlayer() then
        return true
    end
	
    db.query("UPDATE `players` SET `deaths` = `deaths` + 1 WHERE id = " .. player:getGuid() .. ";") 
    player:unregisterEvent("KDR_REGISTER_EVENT")
    player:unregisterEvent("KDR_KILL_EVENT")
    player:unregisterEvent("KDR_DEATH_EVENT")
    return true
 end

death:register()