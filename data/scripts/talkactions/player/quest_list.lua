local config = {
    ["Demon Armor"] = {points = 100, storage = 2300, value = 1},
    ["The Annihilator Quest"] = {points = 100, storage = 10102, value = 1},
}

local exhaust = {}
local EXP_PER_50_POINTS = 2

local questList = TalkAction("!questlist", "/questlist")
local quest = TalkAction("!quest", "/quest")

function questList.onSay(player, words, param, type)
	local playerId = player:getId()
    local currentTime = os.time()
    if exhaust[playerId] and exhaust[playerId] > currentTime then
		player:sendCancelMessage("This Commands is still on cooldown. (0." .. exhaust[playerId] - currentTime .. "s).")
		return false
	end
	
    local text = "[Quest not Completed]:\n\n"
    local questCompleted = true
    
    for questName, questDetails in pairs(config) do
        if player:getStorageValue(questDetails.storage) ~= questDetails.value then
            text = text .. string.format("[-] %s - %d points.\n", questName, questDetails.points)
            questCompleted = false
        end
    end
    
    if questCompleted then
        text = "All quests completed."
    end

    player:showTextDialog(37114, text)
	exhaust[playerId] = currentTime + 2
    return false
end

function quest.onSay(player, words, param, type)
	local playerId = player:getId()
    local currentTime = os.time()
    if exhaust[playerId] and exhaust[playerId] > currentTime then
		player:sendCancelMessage("This Commands is still on cooldown. (0." .. exhaust[playerId] - currentTime .. "s).")
		return false
	end
	
    local totalPoints = 0
    local text = "[Quest Completed]:\n\n"
    local anyCompleted = false
    
    for questName, questDetails in pairs(config) do
        if player:getStorageValue(questDetails.storage) == questDetails.value then
            totalPoints = totalPoints + questDetails.points
            text = text .. string.format("[+] %s - %d points.\n", questName, questDetails.points)
            anyCompleted = true
        end
    end
    
    if not anyCompleted then
        text = "No quests completed yet."
    else
        -- Update the storage with total accumulated points
        player:setStorageValue(Storage.STORAGEVALUE_QUEST_POINTS, totalPoints)
        -- Calculate experience based on total points
        local expGained = math.floor(totalPoints / 50) * EXP_PER_50_POINTS
        -- Add total points and experience info to the text
        text = string.format("[!] Total Points: %d\n- Every 50 points you get %d%% exp.\n- Exp Accumulated: [%d exp].\n\n%s", totalPoints, EXP_PER_50_POINTS, expGained, text)
    end

    player:showTextDialog(37114, text)
	exhaust[playerId] = currentTime + 2
    return false
end

questList:register()
quest:register()

local ec = Event()

function ec.onGainExperience(self, source, exp, rawExp)
    -- Only apply quest points bonus if the source is a creature
	if not source or not source:isCreature() then
		return exp
	end
	
    local questPoints = self:getStorageValue(Storage.STORAGEVALUE_QUEST_POINTS)
    local questBonus = 0
    
    if questPoints > 0 then
        questBonus = math.floor(questPoints / 50) * EXP_PER_50_POINTS
    end
    
    if questBonus > 0 then
        local bonusExp = math.floor(exp * questBonus / 100)
        return exp + bonusExp
    end
    
    return exp
end

ec:register()