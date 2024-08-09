local autosell = {
    talkaction = "!autosell",
    freeAccountLimit = 10,
    premiumAccountLimit = 20
}

local autosellCache = {}

local function getPlayerLimit(player)
    return player:isPremium() and autosell.premiumAccountLimit or autosell.freeAccountLimit
end

local function getPlayerAutosellItems(player)
    local limits = getPlayerLimit(player)
    local guid = player:getGuid()
    local itemsCache = autosellCache[guid]
    if itemsCache then
        if #itemsCache > limits then
            local newCache = {unpack(itemsCache, 1, limits)}
            autosellCache[guid] = newCache
            return newCache
        end
        return itemsCache
    end

    local items = {}
    for i = 1, limits do
        local itemId = player:getStorageValue(Storage.STORAGEVALUE_AUTOSELLBASE + i)
        if itemId and itemId > 0 then
            table.insert(items, itemId)
        end
    end

    autosellCache[guid] = items
    return items
end

local function setPlayerAutosellItems(player, newItems)
    local limits = getPlayerLimit(player)
    local items = getPlayerAutosellItems(player)
    for i = 1, limits do
        local itemId = newItems[i]
        if itemId then
            player:setStorageValue(Storage.STORAGEVALUE_AUTOSELLBASE + i, itemId)
        else
            player:setStorageValue(Storage.STORAGEVALUE_AUTOSELLBASE + i, -1)
        end
    end
    autosellCache[player:getGuid()] = newItems
    return true
end

local function isItemAllowed(itemName)
    for _, item in ipairs(sellItems) do
        if item.id:lower() == itemName:lower() then
            return true
        end
    end
    return false
end

local function hasPlayerAutosellItem(player, itemId)
    local items = getPlayerAutosellItems(player)
    for _, id in ipairs(items) do
        if id == itemId then
            return true
        end
    end
    return false
end

local function getAvailableSlots(player)
    local limits = getPlayerLimit(player)
    local currentItemsCount = #getPlayerAutosellItems(player)
    return limits - currentItemsCount
end

local function capitalizeWords(str)
    return (str:gsub("%a+", function(word)
        return word:sub(1,1):upper() .. word:sub(2):lower()
    end))
end

local function addPlayerAutosellItem(player, itemName)
    local itemType = ItemType(itemName)
    if not itemType or itemType:getId() == 0 then
        itemType = ItemType(math.max(tonumber(itemName) or 0), 0)
        if not itemType or itemType:getId() == 0 then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, string.format("The item %s does not exist!", itemName))
            return false
        end
    end
    
    local itemId = itemType:getId()
    local items = getPlayerAutosellItems(player)
    if hasPlayerAutosellItem(player, itemId) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, string.format("The item %s is already in the list!", capitalizeWords(itemType:getName())))
        return false
    end

    items[#items + 1] = itemId
    if setPlayerAutosellItems(player, items) then
        local availableSlots = getAvailableSlots(player)
        local totalSlots = getPlayerLimit(player)
        player:sendTextMessage(MESSAGE_EVENT_ORANGE, string.format("The item %s has been added to your sell list. [%d/%d]", capitalizeWords(itemType:getName()), totalSlots - availableSlots, totalSlots))
    end
    return true
end

local function removePlayerAutosellItem(player, itemId)
    local items = getPlayerAutosellItems(player)
    for i, id in ipairs(items) do
        if itemId == id then
            table.remove(items, i)
            return setPlayerAutosellItems(player, items)
        end
    end
    return false
end

local function clearPlayerAutosellItems(player)
    local limits = getPlayerLimit(player)
    local items = {}
    for i = 1, limits do
        player:setStorageValue(Storage.STORAGEVALUE_AUTOSELLBASE + i, -1)
    end
    autosellCache[player:getGuid()] = items
    return true
end

local sellTalk = TalkAction(autosell.talkaction)

local exhaust = {}

function sellTalk.onSay(player, words, param, type)
    local playerId = player:getId()
    local currentTime = os.time()
    if exhaust[playerId] and exhaust[playerId] > currentTime then
        player:sendCancelMessage("You are on cooldown, now wait (0." .. exhaust[playerId] - currentTime .. "s).")
        return false
    end

    local split = param:splitTrimmed(",")
    local action = split[1]
    local itemName = split[2] and split[2]:trim():lower()
	
	local availableSlots = getAvailableSlots(player)
    local totalSlots = getPlayerLimit(player)
    local usedSlots = totalSlots - availableSlots -- Calculate used slots
	
    if not action then
		player:popupFYI(string.format("[+] Auto Sell Commands [+]\n\nExamples of use:\n%s add, magic plate armor -> To add item from list.\n%s remove, demon shield -> To remove item from list.\n%s clear -> To clear the list.\n\n[+] Available slots [+]\nFree Account: %d.\nPremium Account: %d.\n\nYour Slots: [%d/%d].", words, words, words, autosell.freeAccountLimit, autosell.premiumAccountLimit, usedSlots, totalSlots), false)
        exhaust[playerId] = currentTime + 2
        return false
    end

    local function getItemIdByName(name)
        local itemType = ItemType(name)
        if itemType and itemType:getId() > 0 then
            return itemType:getId()
        end
        return -1
    end

    if action == "add" then
		if not itemName then
            player:sendTextMessage(MESSAGE_EVENT_ORANGE, "Usage: !autosell add, ITEMNAME")
            exhaust[playerId] = currentTime + 2
            return false
        end
		
        if itemName then
            local itemId = getItemIdByName(itemName)
            if itemId <= 0 then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, string.format("The item '%s' does not exist.", itemName))
                exhaust[playerId] = currentTime + 2
                return false
            end
            
            local itemType = ItemType(itemName)
            if not isItemAllowed(itemType:getName()) then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, string.format("The item %s is not allowed to be added to the sell list!", itemType:getName()))
                return false
            end

            local limits = getPlayerLimit(player)
            if #getPlayerAutosellItems(player) >= limits then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, string.format("Your auto sell only allows you to add %d items.", limits))
                exhaust[playerId] = currentTime + 2
                return false
            end

            addPlayerAutosellItem(player, itemId)
            exhaust[playerId] = currentTime + 2
        end
        return false
    elseif action == "remove" then
		if not itemName then
            player:sendTextMessage(MESSAGE_EVENT_ORANGE, "Usage: !autosell remove, ITEMNAME - You can view the list using !autosell list.")
            exhaust[playerId] = currentTime + 2
            return false
        end
		
        if itemName then
            local itemId = getItemIdByName(itemName)
            if itemId <= 0 then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, string.format("The item %s does not exist.", capitalizeWords(itemName)))
                exhaust[playerId] = currentTime + 2
                return false
            end

            if removePlayerAutosellItem(player, itemId) then
                player:sendTextMessage(MESSAGE_EVENT_ORANGE, string.format("The item %s has been removed from your sell list.", capitalizeWords(itemName)))
            else
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, string.format("The item %s does not exist in the list.", capitalizeWords(itemName)))
            end
            exhaust[playerId] = currentTime + 2
        end
        return false
    elseif action == "list" then
		local items = getPlayerAutosellItems(player)
		local availableSlots = getAvailableSlots(player)
		local totalSlots = getPlayerLimit(player)
		
		if #items == 0 then
			player:sendTextMessage(MESSAGE_EVENT_ORANGE, string.format("Your sell list is empty. Available slots: %d/%d", availableSlots, totalSlots))
			exhaust[playerId] = currentTime + 2
			return false
		end

		local description = {"Your sell list:"}
		local itemNames = {}

		for _, itemId in ipairs(items) do
			local itemName = capitalizeWords(ItemType(itemId):getName())
			table.insert(itemNames, itemName)
		end

		local itemList = table.concat(itemNames, ", ")
		local usedSlots = totalSlots - availableSlots
		description[#description + 1] = string.format("%s", itemList)
		description[#description + 1] = string.format("[Slots used: %d/%d].", usedSlots, totalSlots)

		player:sendTextMessage(MESSAGE_EVENT_ORANGE, table.concat(description, "\n"))
		exhaust[playerId] = currentTime + 2
		return false
    elseif action == "clear" then
        if clearPlayerAutosellItems(player) then
            player:sendTextMessage(MESSAGE_EVENT_ORANGE, "Your sell list has been cleared.")
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "There was an error clearing your sell list.")
        end
        exhaust[playerId] = currentTime + 2
        return false
    end

    return false
end

sellTalk:separator(" ")
sellTalk:register()

local creatureEvent = CreatureEvent("autosellCleanCache")

function creatureEvent.onLogout(player)
    setPlayerAutosellItems(player, getPlayerAutosellItems(player))
    autosellCache[player:getGuid()] = nil
    return true
end

creatureEvent:register()

-- Check if the item is on the sale list
local function isItemInList(itemId)
    for _, item in ipairs(sellItems) do
        if string.lower(item.id) == string.lower(itemId) then
            return true
        end
    end
    return false
end

-- Removes all items of a specific type from the container
local function removeAllItems(container, itemId)
    for i = container:getSize() - 1, 0, -1 do
        local item = container:getItem(i)
        if item then
            if item:getId() == itemId then
                item:remove(item:getCount())
            elseif item:isContainer() then
                removeAllItems(item, itemId)
            end
        end
    end
end

-- Check if an item has imbuements
local function hasImbuements(item)
    local imbuements = item:getImbuements()
    return next(imbuements) ~= nil -- Checks if the imbuements table is not empty
end

-- Remove all items from the player's backpack and containers
local function removeItemsFromBackpack(player, itemId)
    local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
    if backpack and backpack:isContainer() then
        for i = 0, backpack:getSize() - 1 do
            local item = backpack:getItem(i)
            if item and item:getId() == itemId then
                if hasImbuements(item) then
                    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, string.format("You cannot sell %s because it has imbuements.", capitalizeWords(ItemType(itemId):getName())))
                else
                    item:remove(item:getCount())
                end
            elseif item and item:isContainer() then
                removeAllItems(item, itemId)
            end
        end
    end
end

-- Find the cost of an item in the sellItems list
local function getItemCost(itemId)
    for _, item in ipairs(sellItems) do
        local itemType = ItemType(item.id)
        if itemType and itemType:getId() == itemId then
            return item.cost
        end
    end
    return 0
end

local sellAction = Action()

function sellAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local playerId = player:getId()
    local currentTime = os.time()
    if exhaust[playerId] and exhaust[playerId] > currentTime then
        player:sendCancelMessage("You are on cooldown, now wait (0." .. exhaust[playerId] - currentTime .. "s).")
        return true
    end

    local totalGold = 0
    local hasSoldItems = false
    local autosellItems = getPlayerAutosellItems(player)

    for _, itemId in ipairs(autosellItems) do
        if itemId > 0 then
            local itemName = ItemType(itemId):getName()
            local capitalizedItemName = capitalizeWords(itemName)
            local itemCount = 0
            local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)

            if backpack and backpack:isContainer() then
                for i = 0, backpack:getSize() - 1 do
                    local item = backpack:getItem(i)
                    if item and item:getId() == itemId then
                        if hasImbuements(item) then
                            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, string.format("You cannot sell %s because it has imbuements.", capitalizedItemName))
                        else
                            itemCount = itemCount + item:getCount()
                        end
                    elseif item:isContainer() then
                        for j = 0, item:getSize() - 1 do
                            local subItem = item:getItem(j)
                            if subItem and subItem:getId() == itemId then
                                if hasImbuements(subItem) then
                                    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, string.format("You cannot sell %s because it has imbuements.", capitalizedItemName))
                                else
                                    itemCount = itemCount + subItem:getCount()
                                end
                            end
                        end
                    end
                end
            end

            if itemCount > 0 then
                local itemCost = getItemCost(itemId)
                if itemCost > 0 then
                    removeItemsFromBackpack(player, itemId)
                    local totalCost = itemCost * itemCount
                    totalGold = totalGold + totalCost

                    player:sendTextMessage(MESSAGE_EVENT_ORANGE, string.format("You have sold x%d %s for %d gold coins.", itemCount, capitalizedItemName, totalCost))
                    player:getPosition():sendMagicEffect(CONST_ME_LOOT_HIGHLIGHT)
                    player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
                    hasSoldItems = true
                else
                    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, string.format("The item %s does not have a selling price defined.", itemName))
                end
            end
        end
    end
    if totalGold > 0 then
        local crystalCoins = math.floor(totalGold / 10000)
        totalGold = totalGold - (crystalCoins * 10000)
        local platinumCoins = math.floor(totalGold / 100)
        totalGold = totalGold - (platinumCoins * 100)
        local goldCoins = totalGold

        if crystalCoins > 0 then
            player:addItem(3043, crystalCoins)
        end
        if platinumCoins > 0 then
            player:addItem(3035, platinumCoins)
        end
        if goldCoins > 0 then
            player:addItem(3031, goldCoins)
        end
    end

    if not hasSoldItems then
        player:sendTextMessage(MESSAGE_EVENT_ORANGE, "You don't have items to sell. Check the list with !autosell list.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
    end
    exhaust[playerId] = currentTime + 2
    return true
end

sellAction:id(42564, 42565)
sellAction:register()