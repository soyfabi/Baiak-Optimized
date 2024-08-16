local exhaust = {}

local talk = TalkAction("!boost", "!boosted", "!bonus")

function talk.onSay(player, words, param)
	local playerId = player:getId()
    local currentTime = os.time()
    if exhaust[playerId] and exhaust[playerId] > currentTime then
		player:sendCancelMessage("This Commands is still on cooldown. (0." .. exhaust[playerId] - currentTime .. "s).")
		return false
	end
	
	local text = "[Boosted System]\nAll the bonuses you have activated will be displayed.\n\n"
	
	local totalExpBonus = 0
	local totalLootBonus = 0

	-- Check if Cast bonus is active
	if player:getStorageValue(Storage.isCasting) == 1 then
		text = text .. "Cast System: On.\n"
		local castBonus = 10
		text = text .. "[+] Exp Bonus: +" .. castBonus .. "%.\n\n"
		totalExpBonus = totalExpBonus + castBonus
	else
		text = text .. "Cast System: Off.\n\n"
	end	
	
	-- Check Guild bonus
	local guild = player:getGuild()
	if guild then
		local guildExpBonus = GuildLevel.level_experience[guild:getLevel()].exp
		local guildLootBonus = GuildLevel.level_experience[guild:getLevel()].loot
		text = text .. "Guild Bonus: On.\n"
		text = text .. "[+] Exp Bonus: " .. guildExpBonus .. "%.\n"
		text = text .. "[+] Loot Bonus: " .. guildLootBonus .. "%.\n\n"
		totalExpBonus = totalExpBonus + guildExpBonus
		totalLootBonus = totalLootBonus + guildLootBonus
	else
		text = text .. "Guild Bonus: Off.\n\n"
	end
	
	-- Check Exp Potion bonus
	if player:getStorageValue(Storage.STORAGEVALUE_POTIONXP_ID) == 1 then
		text = text .. "Exp Potion: On.\n"
		local expPotionBonus = 25
		text = text .. "[+] Exp Bonus: " .. expPotionBonus .. "%.\n\n"
		totalExpBonus = totalExpBonus + expPotionBonus
	else
		text = text .. "Exp Potion: Off.\n\n"
	end
	
	-- Check Loot Potion bonus
	if player:getStorageValue(Storage.STORAGEVALUE_LOOT_ID) == 1 then
		text = text .. "Loot Potion: On.\n"
		local lootPotionBonus = 25
		text = text .. "[+] Loot Bonus: " .. lootPotionBonus .. "%.\n\n"
		totalLootBonus = totalLootBonus + lootPotionBonus
	else
		text = text .. "Loot Potion: Off.\n\n"
	end
	
	-- Check Castle bonus
	if player:getStorageValue(Storage.STORAGEVALUE_CASTLE_ID) == 1 then
		text = text .. "Castle Bonus: On.\n"
		local castleExpBonus = 10
		local castleLootBonus = 10
		text = text .. "[+] Exp Bonus: " .. castleExpBonus .. "%.\n"
		text = text .. "[+] Loot Bonus: " .. castleLootBonus .. "%.\n\n"
		totalExpBonus = totalExpBonus + castleExpBonus
		totalLootBonus = totalLootBonus + castleLootBonus
	else
		text = text .. "Castle Bonus: Off.\n\n"
	end
	
	-- Check Quest Points Bonus
    local questPoints = player:getStorageValue(Storage.STORAGEVALUE_QUEST_POINTS)
	local EXP_PER_50_POINTS = 2
    if questPoints > 0 then
        text = text .. "Quest Points Bonus: On.\n"
        local questPointsBonus = math.floor(questPoints / 50) * EXP_PER_50_POINTS
        text = text .. "[+] Exp Bonus: " .. questPointsBonus .. "%.\n\n"
        totalExpBonus = totalExpBonus + questPointsBonus
    else
        text = text .. "Quest Points Bonus: Off.\n\n"
    end
	
	-- Check Premium Bonus
	if player:isPremium() then
		text = text .. "Premium Bonus: On.\n"
		local premiumBonus = 15
		text = text .. "[+] Exp Bonus: " .. premiumBonus .. "%.\n\n"
		totalExpBonus = totalExpBonus + premiumBonus
	else
		text = text .. "Premium Bonus: Off.\n\n"
	end
	
	text = text .. "[Total Experience Bonus: " .. totalExpBonus .. "%]\n"
	text = text .. "[Total Loot Bonus: " .. totalLootBonus .. "%]\n\n"
	
	text = text .. "-> Keep in mind that it resets upon death.\n"
	
	-- Display Potions Amplification
	text = text .. "[Potions Amplification]\n"
	for _, itemId in ipairs(getKeysInOrder(potions_amplification)) do
		local potionInfo = potions_amplification[itemId]
		local storage = potionInfo.storage
		local potionAmplification = player:getStorageValue(storage) or 0
		if potionAmplification < 0 then
			potionAmplification = 0
		end
		text = text .. "[+] " .. potionInfo.name .. ": " .. potionAmplification .. "%.\n"
	end
	
	-- Display Potions Resilience
	text = text .. "\n[Potions Resilience]\n"
	for _, itemId in ipairs(getKeysInOrder(potions_resilience)) do
		local potionInfo = potions_resilience[itemId]
		local storage = potionInfo.storage
		local potionAmplification = player:getStorageValue(storage) or 0
		if potionAmplification < 0 then
			potionAmplification = 0
		end
		text = text .. "[+] " .. potionInfo.name .. ": " .. potionAmplification .. "%.\n"
	end
	
	exhaust[playerId] = currentTime + 5
	player:popupFYI(text)
    return false
end

talk:separator(" ")
talk:register()
