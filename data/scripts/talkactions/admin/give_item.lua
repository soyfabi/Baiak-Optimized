local talk = TalkAction("!giveitem")
function talk.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end
	
	if param == "" or param == "all" then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Usage: !giveitem <player name or 'all'>, <item id>, [count]")
        return false
    end
	
    local params = param:split(",")
    local targetName = params[1]:trim()
    local itemId = tonumber(params[2]) 
    local itemCount = tonumber(params[3]) or 1

    if not itemId then
        player:sendCancelMessage("Invalid item ID.")
        return false
    end

    local itemType = ItemType(itemId)
    if itemType:getId() == 0 then
        player:sendCancelMessage("Invalid item ID.")
        return false
    end

    local itemName = itemType:getName()

    if targetName == "all" then
        for _, p in pairs(Game.getPlayers()) do
            p:addItem(itemId, itemCount)
            p:sendTextMessage(MESSAGE_INFO_DESCR, "You have received " .. itemCount .. " " .. itemName .. ".")
        end
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Item sent to all players.")
    else
        local targetPlayer = Player(targetName)
        if not targetPlayer then
            player:sendCancelMessage("Player not found.")
            return false
        end
        targetPlayer:addItem(itemId, itemCount)
        targetPlayer:sendTextMessage(MESSAGE_INFO_DESCR, "You have received " .. itemCount .. " " .. itemName .. ".")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Item sent to " .. targetName .. ".")
    end

    return false
end

talk:separator(" ")
talk:register()