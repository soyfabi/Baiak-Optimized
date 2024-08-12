local guild_level = CreatureEvent("Guild Level")

function guild_level.onKill(player, target)
	if target:isMonster() then
		return false
	end
	
	if not player:getGuild() or not target:getGuild() then
		return false
	end
	
	if GuildLevel.antimc then
		if target:getIp() then   
			return false
		end
	end

	if player:getLevel() < GuildLevel.minLevelBonus or target:getLevel() < GuildLevel.minLevelBonus then
		return false
	end
	
	local guild = player:getGuild()
	local guild_target = target:getGuild()
	
	if guild:getId() == guild_target:getId() then
		return false
	end
	
	local currentLevel = guild:getLevel()
    local experienceNeeded = GuildLevel.level_experience[currentLevel].expMax
	local max = 12 --local max = math.max(12, guild_target:getLevel() - guild:getLevel() + (isInWar(player, target) and 20 or 16))
	local xp = math.random(2, max)

	if currentLevel < #GuildLevel.level_experience then
        guild:addExperience(xp)
	end
   
	local newLevel = currentLevel
    while guild:getExperience() >= experienceNeeded and GuildLevel.level_experience[newLevel + 1] do
        newLevel = newLevel + 1
        experienceNeeded = GuildLevel.level_experience[newLevel].expMax
    end
	if currentLevel < #GuildLevel.level_experience then
		if newLevel > currentLevel then
			local levelName = GuildLevel.level_experience[newLevel].name
			player:say(GuildLevel.text_level:format(guild:getLevel() + 1))
			sendGuildChannelMessage(guild:getId(), TALKTYPE_CHANNEL_O, GuildLevel.text_level:format(guild:getLevel() + 1))
			guild:addLevel(newLevel - currentLevel)
		else
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, GuildLevel.text:format(xp, target:getName()))
			sendGuildChannelMessage(guild:getId(), TALKTYPE_CHANNEL_O, GuildLevel.text_guild:format(player:getName(), xp , target:getName()))
		end
	end
	
	------- TARGET -------
	local currentLevel = guild_target:getLevel()

	local max = -16
	local xp = math.random(-3, max)

	local nuevaExperiencia = guild_target:getExperience() + xp

	if nuevaExperiencia >= GuildLevel.level_experience[currentLevel].expMin then
		guild_target:addExperience(xp)
		target:sendTextMessage(MESSAGE_EVENT_ADVANCE, GuildLevel.text_dead:format(player:getName(), xp))
		sendGuildChannelMessage(guild_target:getId(), TALKTYPE_CHANNEL_O, GuildLevel.text_dead_guild:format(target:getName(), xp))
	else
		if currentLevel > 1 then
			local nivelAnterior = currentLevel - 1
			guild_target:addExperience(xp)
			guild_target:setLevel(nivelAnterior)
			sendGuildChannelMessage(guild_target:getId(), TALKTYPE_CHANNEL_O, GuildLevel.text_level_lower:format(guild_target:getLevel()))
			target:sendTextMessage(MESSAGE_EVENT_ADVANCE, GuildLevel.text_dead:format(player:getName(), xp))
			sendGuildChannelMessage(guild_target:getId(), TALKTYPE_CHANNEL_O, GuildLevel.text_dead_guild:format(target:getName(), xp))
		else
			guild_target:addExperience(xp)
			target:sendTextMessage(MESSAGE_EVENT_ADVANCE, GuildLevel.text_dead:format(player:getName(), xp))
			sendGuildChannelMessage(guild_target:getId(), TALKTYPE_CHANNEL_O, GuildLevel.text_dead_guild:format(target:getName(), xp))
		end
	end
	
	return true
end

guild_level:register()

-- Login --
local guild_login = CreatureEvent("GuildLogin")

function guild_login.onLogin(player)
	player:registerEvent("Guild Level")
	return true
end 
guild_login:register()

local ec = Event()
ec.onGainExperience = function(self, source, exp, rawExp)

	local guildbonus = 0
	local guild = self:getGuild()
	if guild then
		local level = guild:getLevel()
		if GuildLevel.level_experience[level] and GuildLevel.level_experience[level].exp > 0 then
			local expBonusPercent = GuildLevel.level_experience[level].exp
			local expBonus = exp * (expBonusPercent / 100)
			guildbonus = expBonus
		end	
    end
	
	return exp + guildbonus
end

ec:register()

local event = Event()

event.onDropLoot = function(self, corpse)
    local mType = self:getType()
    if mType:isRewardBoss() then
        corpse:registerReward()
        return
    end

    if configManager.getNumber(configKeys.RATE_LOOT) == 0 then
        return
    end

    local player = Player(corpse:getCorpseOwner())
    if not player then
        return false
    end

    if player:getStamina() > 840 then
        local monsterLoot = mType:getLoot()
        
        -- Guild Level Bonus
        local lootBonus = 0
        local guild = player:getGuild()
        if guild then
            local level = guild:getLevel()
            if GuildLevel.level_experience[level] and GuildLevel.level_experience[level].loot > 0 then
                local lootBonusPercent = GuildLevel.level_experience[level].loot
                lootBonus = lootBonusPercent / 100
            end
        end
        
        for i = 1, #monsterLoot do
            local chance = monsterLoot[i].chance
            chance = (chance * lootBonus)
            monsterLoot[i].chance = chance

            local item = corpse:createLootItem(monsterLoot[i])
            if not item then
                print('[Warning] DropLoot:', 'Could not add loot item to corpse.')
            end
        end
    end
end

event:register(-1)
