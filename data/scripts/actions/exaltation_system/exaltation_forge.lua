-- Function to show fusion forge details
function showFusionForge(playerId)
    local player = Player(playerId)
    if not player then
        return false
    end

    local item = _G.currentExaltationItem
    if not item then
        return false
    end

    local position = item:getPosition()
    position.y = position.y - 3

    local container = Tile(position):getItemById(configForge.itemId.exaltationChestID)
    if not container or not container:isContainer() then
        return false
    end

    local containerSize = 3
    local totalCost = 0
    local itemsMessage = ""

    -- Use the first non-core item found for cost calculation
    local usedForCost = false

    for i = 0, containerSize - 1 do
        local itemInContainer = container:getItem(i)
        if itemInContainer then
            local itemId = itemInContainer:getId()
            local itemCount = itemInContainer:getCount()
            local itemType = ItemType(itemId)
            local itemName = itemType:getName()
            itemName = itemName:gsub("(%l)(%w*)", function(a, b) return a:upper() .. b:lower() end)

            if itemId == configForge.itemId.exaltedCore then
                itemsMessage = itemsMessage .. "- " .. itemName .. " - Count: (x" .. itemCount .. ")\n"
            else
                if not usedForCost then
                    local tier = itemInContainer:getAttribute(ITEM_ATTRIBUTE_TIER) or 0
                    local itemInfo = getItemTier(tier)
                    totalCost = itemInfo.cost
                    usedForCost = true
                end

                itemsMessage = itemsMessage .. "- " .. itemName .. " (Tier: " .. (itemInContainer:getAttribute(ITEM_ATTRIBUTE_TIER) or "Unknown") .. ")\n"
            end
        else
            itemsMessage = itemsMessage .. "- Empty\n"
        end
    end

    player:registerEvent("showFusionForge")

    local windowTitle = "Fusion Details:\n\n"
    windowTitle = windowTitle .. "Items included in the exaltation chest:\n"
    windowTitle = windowTitle .. itemsMessage
    windowTitle = windowTitle .. "\nCost: " .. totalCost .. " gold coins.\n"
    windowTitle = windowTitle .. "Success Rate: " .. calculateSuccessRate(container) .. "%.\n\n"
    windowTitle = windowTitle .. "Click here to start a fusion attempt. This will consume or alter the required ingredients."

    local window = ModalWindow(1001, "Forge Confirmation", windowTitle .. "\n")

    window:addButton(1, "Start")
    window:addButton(2, "Back")

    window:setDefaultEnterButton(1)
    window:setDefaultEscapeButton(5)

    window:sendToPlayer(player)
end

-- Function to handle the fusion forge process
function fusionForge(playerId, item, isTransfer)
    local player = Player(playerId)
    if not player then
        print("Player not found")
        return false
    end
    
    local item = _G.currentExaltationItem
    if not item then
        print("Item not found")
        return false
    end

    local position = item:getPosition()
    position.y = position.y - 3

    local container = Tile(position):getItemById(configForge.itemId.exaltationChestID)
    if container and container:isContainer() then
        local hasTransferCore = false
        local itemsToRemove = {}
        local itemIdToCheck = nil
        local bonusChance = 0

        for i = 0, container:getSize() - 1 do
            local itemInContainer = container:getItem(i)
            if itemInContainer then
                local itemId = itemInContainer:getId()
                local itemCount = itemInContainer:getCount()

                if itemId == configForge.itemId.exaltationTransferCore then
                    hasTransferCore = true
                elseif itemId == configForge.itemId.exaltedCore then
                    bonusChance = bonusChance + (configForge.bonusExaltedCores * itemCount)
                else
                    if not itemIdToCheck then
                        itemIdToCheck = itemId
                    end
                    table.insert(itemsToRemove, itemInContainer)
                end
            end
        end
		
        if hasTransferCore then
            local transferSuccess = transferForge(playerId, item)
            if not transferSuccess then
                return false
            end
        else
            if #itemsToRemove == 2 then
                if itemsToRemove[1]:getId() ~= itemsToRemove[2]:getId() then
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need exactly two items in the chest to perform the fusion.")
                    return false
                end

                local tier = itemsToRemove[1]:getAttribute(ITEM_ATTRIBUTE_TIER) or 0
                local itemType = ItemType(itemIdToCheck)
                local itemClassification = itemType:getClassification()
                local maxTier = getMaxTierForClassification(itemClassification)

                if tier >= maxTier then
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The item has already reached its maximum tier.")
                    return false
                end

                local itemInfo = getItemTier(tier)
                local successChance = itemInfo.chance + bonusChance
                local cost = itemInfo.cost
                local randomValue = math.random(100)

                if player:getMoney() < cost then
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You do not have enough money to perform the fusion.")
                    return false
                end

                local itemName = itemType:getName()
                itemName = itemName:gsub("(%l)(%w*)", function(a, b) return a:upper() .. b:lower() end)
                local successMessage = "The fusion of " .. itemName .. " was successful, upgraded to Tier "
                local upgradeTier = 1
                local newTier = tier + upgradeTier
                local finalSuccessMessage = successMessage .. newTier .. "."
                
                if itemType:isArmor() then
                    attributeName = "Ruse"
                elseif itemType:isWeapon() then
                    attributeName = "Onslaught"
                elseif itemType:isHelmet() then
                    attributeName = "Momentum"
                elseif itemType:isLegs() then
                    attributeName = "Transcendence"
                end
				
                if randomValue <= successChance then
                    local removeOneItem = math.random(100) <= configForge.chancePreservatedItem
                    local preservedItemMessage = "\nYou were lucky, one of the " .. itemName .. " has been preserved."

                    if removeOneItem then
                        local itemToRemove = math.random(1, 2)
                        local itemToRemove = table.remove(itemsToRemove, itemToRemove)
                        if itemToRemove then
                            itemToRemove:remove()
                        end

                        local newItem = Game.createItem(itemIdToCheck, 1)
                        if newItem then
                            newItem:setAttribute(ITEM_ATTRIBUTE_TIER, newTier)
                            if attributeName then
                                applyAttribute(newItem, attributeName)  
                            end

                            local newContainer = Game.createItem(configForge.itemId.exaltationChestID, 1)
                            if newContainer then
                                newContainer:addItemEx(newItem, 1)
                                container:addItemEx(newContainer, 1)

                                local preservedUpgrade = math.random(100) <= configForge.chanceDoubleTierBoth
                                if preservedUpgrade then
                                    local preservedItem = itemsToRemove[1]
                                    if preservedItem then
                                        preservedItem:setAttribute(ITEM_ATTRIBUTE_TIER, newTier)
                                        if attributeName then
                                            applyAttribute(preservedItem, attributeName)
                                        end
                                        preservedItemMessage = preservedItemMessage .. "\nYou were even luckier, the preserved " .. itemName .. " was also upgraded to Tier " .. newTier .. "."
                                    end
                                end

                                if math.random(100) <= configForge.chanceDoubledTier then
                                    newTier = newTier + 1
                                    newItem:setAttribute(ITEM_ATTRIBUTE_TIER, newTier)
                                    if attributeName then
                                        applyAttribute(newItem, attributeName)
                                    end
                                    finalSuccessMessage = successMessage .. newTier .. ".\nYou were lucky, the " .. itemName .. " has doubled the tier."
                                end

                                local bonusItemsRemoved = true
                                for i = 0, container:getSize() - 1 do
                                    local itemInContainer = container:getItem(i)
                                    if itemInContainer and itemInContainer:getId() == configForge.itemId.exaltedCore then
                                        local bonusRandomValue = math.random(100)
                                        if bonusRandomValue <= configForge.chanceExaltedCores then
                                            itemInContainer:remove()
                                        else
                                            bonusItemsRemoved = false
                                        end
                                    end
                                end
								
                                local preservedMoneyMessage = ""
                                if math.random(100) >= configForge.chancePreservatedMoney then
                                    player:removeMoney(cost)
                                else
                                    preservedMoneyMessage = "\nYou were lucky and did not lose your money for the fusion."
                                end

                                local finalMessage = finalSuccessMessage .. preservedItemMessage .. preservedMoneyMessage
                                if not bonusItemsRemoved then
                                    finalMessage = finalMessage .. "\nYou were lucky, the Exalted Cores were not removed."
                                end
                                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, finalMessage)
                                player:getPosition():sendMagicEffect(CONST_ME_GHOST_SMOKE)
                                player:getPosition():sendMagicEffect(CONST_ME_DAZZLING)

                                -- Record fusion history
                                recordForgeHistory(playerId, "Fusion", finalMessage)
                            end
                        end
                    else
                        for _, itemToRemove in ipairs(itemsToRemove) do
                            itemToRemove:remove()
                        end

                        local newItem = Game.createItem(itemIdToCheck, 1)
                        if newItem then
                            newItem:setAttribute(ITEM_ATTRIBUTE_TIER, newTier)
                            if attributeName then
                                applyAttribute(newItem, attributeName)
                            end

                            local newContainer = Game.createItem(configForge.itemId.exaltationChestID, 1)
                            if newContainer then
                                newContainer:addItemEx(newItem, 1)
                                container:addItemEx(newContainer, 1)

                                if math.random(100) <= configForge.chanceDoubledTier then
                                    newTier = newTier + 1
                                    newItem:setAttribute(ITEM_ATTRIBUTE_TIER, newTier)
                                    if attributeName then
                                        applyAttribute(newItem, attributeName)
                                    end
                                    finalSuccessMessage = successMessage .. newTier .. ".\nYou were lucky, the " .. itemName .. " has doubled the tier."
                                end

                                local bonusItemsRemoved = true
                                for i = 0, container:getSize() - 1 do
                                    local itemInContainer = container:getItem(i)
                                    if itemInContainer and itemInContainer:getId() == configForge.itemId.exaltedCore then
                                        local bonusRandomValue = math.random(100)
                                        if bonusRandomValue <= configForge.chanceExaltedCores then
                                            itemInContainer:remove()
                                        else
                                            bonusItemsRemoved = false
                                        end
                                    end
                                end
								
                                local preservedMoneyMessage = ""
                                if math.random(100) >= configForge.chancePreservatedMoney then
                                    player:removeMoney(cost)
                                else
                                    preservedMoneyMessage = "\nYou were lucky and did not lose your money for the fusion."
                                end
								
                                local finalMessage = finalSuccessMessage .. preservedMoneyMessage
                                if not bonusItemsRemoved then
                                    finalMessage = finalMessage .. "\nYou were lucky, the Exalted Cores were not removed."
                                end
                                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, finalMessage)
                                player:getPosition():sendMagicEffect(CONST_ME_GHOST_SMOKE)
                                player:getPosition():sendMagicEffect(CONST_ME_DAZZLING)

                                -- Record fusion history
                                recordForgeHistory(playerId, "Fusion", finalMessage)
                            end
                        end
                    end
                else
                    local downgradeMessage = ""
                    if tier > 0 and math.random(100) <= configForge.chanceLossItemTier then
                        for _, itemToRemove in ipairs(itemsToRemove) do
                            itemToRemove:remove()
                        end
                        tier = tier - 1
                        downgradeMessage = "Fusion failed. The " .. itemName .. " was downgraded to Tier " .. tier .. "."
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, downgradeMessage)
                        local itemToDowngrade = Game.createItem(itemIdToCheck, 1)
                        if itemToDowngrade then
                            itemToDowngrade:setAttribute(ITEM_ATTRIBUTE_TIER, tier)
                            local newContainer = Game.createItem(configForge.itemId.exaltationChestID, 1)
                            if newContainer then
                                newContainer:addItemEx(itemToDowngrade, 1)
                                container:addItemEx(newContainer, 1)
                                player:getPosition():sendMagicEffect(CONST_ME_GROUNDSHAKER)
                            end
                        end

                        -- Record failed fusion history with downgrade
                        recordForgeHistory(playerId, "Fusion Failed", downgradeMessage)
                    else
                        if #itemsToRemove > 0 then
                            local itemToRemove = itemsToRemove[1]
                            if itemToRemove then
                                itemToRemove:remove()
                            end
                        end
                        local failMessage = "Fusion failed. Good luck next time."
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, failMessage)
                        player:getPosition():sendMagicEffect(CONST_ME_GROUNDSHAKER)

                        -- Record failed fusion history without downgrade
                        recordForgeHistory(playerId, "Forge", failMessage)
                    end
                end
            else
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need exactly two items in the chest to perform the fusion.")
                return false
            end
        end
    end
    return true
end

-- Function to handle item movement in the forge
function moveForge(playerId, item, count, toPosition, toCylinder)
    local player = Player(playerId)
    if not player then
        return false
    end

    if toPosition.x == CONTAINER_POSITION then
        local containerTo = toCylinder

        if containerTo and containerTo:getId() == configForge.itemId.exaltationChestID then
            if hasImbuements(item) then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You cannot add items with imbuements applied to the Exaltation Chest.')
                return false
            end

            local existingItemId, existingItemTier, itemCount = nil, nil, 0
            local hasExaltedCore = false
            local hasTransferCore = false

            for i = 0, containerTo:getSize() - 1 do
                local itemInContainer = containerTo:getItem(i)
                if itemInContainer then
                    local itemId = itemInContainer:getId()
                    local itemTier = itemInContainer:getAttribute(ITEM_ATTRIBUTE_TIER) or 0

                    if itemId == configForge.itemId.exaltedCore then
                        hasExaltedCore = true
                    elseif itemId == configForge.itemId.exaltationTransferCore then
                        hasTransferCore = true
                    else
                        if not existingItemId then
                            existingItemId = itemId
                            existingItemTier = itemTier
                            itemCount = itemInContainer:getCount()
                        elseif existingItemId == itemId then
                            if existingItemTier == itemTier then
                                itemCount = itemCount + itemInContainer:getCount()
                            else
                                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Items of the same ID must have the same tier.')
                                return false
                            end
                        else
                            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You can only place items with the same ID inside the Exaltation Chest.')
                            return false
                        end
                    end
                end
            end

            if hasExaltedCore and item:getId() == configForge.itemId.exaltationTransferCore then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You cannot place Exalted Core and Transfer Core together in the Exaltation Chest.')
                return false
            end

            if hasTransferCore and item:getId() == configForge.itemId.exaltedCore then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You cannot place Transfer Core and Exalted Core together in the Exaltation Chest.')
                return false
            end

            if item:getId() == configForge.itemId.exaltedCore then
                if existingItemId then
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Place the Exalted Cores before adding other items.')
                    return false
                end
                return true
            end

            if item:getId() == configForge.itemId.exaltationTransferCore then
                if existingItemId then
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Place the Exalted Cores before adding other items.')
                    return false
                end
                return true
            end

            if hasTransferCore then
                local itemTier = item:getAttribute(ITEM_ATTRIBUTE_TIER) or 0
                if itemTier == 0 then
                    if not existingItemId then
                        existingItemId = item:getId()
                        existingItemTier = itemTier
                        itemCount = item:getCount()
                        return true
                    end

                    if existingItemId and item:getId() ~= existingItemId then
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You can only place items with the same ID inside the Exaltation Chest.')
                        return false
                    end

                    if itemCount + count > 2 then
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You can place up to 2 items of the same ID.')
                        return false
                    end

                    if existingItemTier ~= 0 then
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Invalid item order. Please follow the sequence: Transfer Core, non-tier item, tier item.')
                        return false
                    end

                elseif itemTier > 0 then
                    if not existingItemId then
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Invalid item order. Please follow the sequence: Transfer Core, non-tier item, tier item.')
                        return false
                    end

                    if existingItemTier ~= 0 then
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Invalid item order. Please follow the sequence: Transfer Core, non-tier item, tier item.')
                        return false
                    end

                    for i = 0, containerTo:getSize() - 1 do
                        local itemInContainer = containerTo:getItem(i)
                        if itemInContainer then
                            local itemId = itemInContainer:getId()
                            if itemId == item:getId() then
                                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You can only place items of different IDs inside the Exaltation Chest.')
                                return false
                            end
                        end
                    end

                    return true
                end
            else
                local itemType = ItemType(item:getId())
                local itemClassification = itemType:getClassification()
                if itemClassification > 0 then
                    local itemTier = item:getAttribute(ITEM_ATTRIBUTE_TIER) or 0
                    local maxTier = getMaxTierForClassification(itemClassification)

                    if existingItemId and item:getId() ~= existingItemId then
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You can only place items with the same ID inside the Exaltation Chest.')
                        return false
                    end

                    if itemCount + count > 2 then
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You can place up to 2 items of the same ID.')
                        return false
                    end
					
					if itemTier > maxTier then
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Item exceeds the maximum tier.')
                        return false
                    end

                    if existingItemTier and itemTier and existingItemTier ~= itemTier then
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Items of the same ID must have the same tier.')
                        return false
                    end
					
                    if existingItemTier == itemTier and itemTier == maxTier then
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Item has reached its maximum tier.')
                        return false
                    end

                    return true
                end

                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Only items with a classification can be placed in the Exaltation Chest.')
                return false
            end
        end
    end
    return true
end

local event = Event()

function event.onMoveItem(player, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
    local resultId = moveForge(player:getId(), item, count, toPosition, toCylinder)
    if not resultId then
        return false
    end
end

event:register()

-- Function to show forge options
function showForgeOptions(playerId)
    local player = Player(playerId)
    if not player then
        print("Player not found")
        return false
    end
    
    player:registerEvent("showForgeOptions")
    
    local windowTitle = "Welcome to the forge, here you can upgrade the tier level of your equipment.\n\n"
    windowTitle = windowTitle .. "Forge details:\n"
    windowTitle = windowTitle .. "- You only have a 50% chance at base.\n"
	windowTitle = windowTitle .. "- Each exalted core is 15% bonus.\n"
	windowTitle = windowTitle .. "- When forging they can have various bonuses.\n\n"
    
    windowTitle = windowTitle .. "Select an option:"
    
    local window = ModalWindow(1000, "Exaltation Forge", windowTitle .."\n")
    
    window:addButton(1, "Forge")
    window:addButton(2, "Transfer")
    window:addButton(3, "Conversion")
    window:addButton(4, "History")
    window:addButton(5, "Cancel")

    window:setDefaultEnterButton(1)
    window:setDefaultEscapeButton(5)
    
    window:sendToPlayer(player)
end

local showForgeOptionsEvent = CreatureEvent("showForgeOptions")
function showForgeOptionsEvent.onModalWindow(player, modalWindowId, buttonId, choiceId)
    player:unregisterEvent("showForgeOptions")
    if modalWindowId ~= 1000 then return false end

    if buttonId == 1 then
        local item = _G.currentExaltationItem
        if not item then
            return false
        end

        local position = item:getPosition()
        position.y = position.y - 3

        local container = Tile(position):getItemById(configForge.itemId.exaltationChestID)
        if container and container:isContainer() then
            local hasItems = false
            local classificationItemCount = 0
            for i = 0, container:getSize() - 1 do
                local itemInContainer = container:getItem(i)
                if itemInContainer then
                    hasItems = true
                    local itemClassification = ItemType(itemInContainer:getId()):getClassification()
                    if itemClassification > 0 then
                        classificationItemCount = classificationItemCount + 1
                    end
                end
            end

            if not hasItems then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The Exaltation Chest is empty. Please add items before proceeding.")
            elseif classificationItemCount < 2 then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to place at least two items with classification in the Exaltation Chest.")
            else
                showFusionForge(player:getId())
            end
        end
    elseif buttonId == 2 then
        local item = _G.currentExaltationItem
        if not item then
            return false
        end

        local position = item:getPosition()
        position.y = position.y - 3

        local container = Tile(position):getItemById(configForge.itemId.exaltationChestID)
        if container and container:isContainer() then
            local hasItems = false
            local hasTransferCore = false
            for i = 0, container:getSize() - 1 do
                local itemInContainer = container:getItem(i)
                if itemInContainer then
                    hasItems = true
                    if itemInContainer:getId() == configForge.itemId.exaltationTransferCore then
                        hasTransferCore = true
                    end
                end
            end

            if not hasItems then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The Exaltation Chest is empty. Please add items before proceeding.")
            elseif not hasTransferCore then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to place at least one Exaltation Transfer Core in the Exaltation Chest.")
            else
                showTransferForge(player:getId())
            end
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The Exaltation Chest is not present.")
        end
    elseif buttonId == 3 then
        showConversionForge(player:getId())
    elseif buttonId == 4 then
        showHistoryOptions(player:getId())
    end
    return true
end

showForgeOptionsEvent:register()

local showFusionForgeEvent = CreatureEvent("showFusionForge")
function showFusionForgeEvent.onModalWindow(player, modalWindowId, buttonId, choiceId)
    player:unregisterEvent("showFusionForge")
    if modalWindowId ~= 1001 then return false end
    
    if buttonId == 1 then
        fusionForge(player:getId(), item, isTransfer)
    else
        showForgeOptions(player:getId())
        return false
    end
    return true
end

showFusionForgeEvent:register()

local showTransferForgeEvent = CreatureEvent("showTransferForge")
function showTransferForgeEvent.onModalWindow(player, modalWindowId, buttonId, choiceId)
    player:unregisterEvent("showTransferForge")
    if modalWindowId ~= 1002 then return false end
    
    if buttonId == 1 then
        fusionForge(player:getId(), item, isTransfer)
    else
        showForgeOptions(player:getId())
        return false
    end
    return true
end

showTransferForgeEvent:register()

local showConversionForgeEvent = CreatureEvent("showConversionForge")
function showConversionForgeEvent.onModalWindow(player, modalWindowId, buttonId, choiceId)
    player:unregisterEvent("showConversionForge")
    if modalWindowId ~= 1003 then return false end
    
    if buttonId == 1 then
        convertDusts(player:getId())
    elseif buttonId == 2 then
        convertSlivers(player:getId())
    else
        showForgeOptions(player:getId())
        return false
    end
    return true
end

showConversionForgeEvent:register()

local showHistoryForgeEvent = CreatureEvent("showHistoryOptions")
function showHistoryForgeEvent.onModalWindow(player, modalWindowId, buttonId, choiceId)
    player:unregisterEvent("showHistoryOptions")
    if modalWindowId ~= 1004 then return false end
    
    if buttonId == 1 then
		showHistoryDetails(player:getId(), choiceId)
    elseif buttonId == 2 then
        showForgeOptions(player:getId())
        return false
    end
    return true
end

showHistoryForgeEvent:register()

local showHistoryDetailsForgeEvent = CreatureEvent("showHistoryDetails")
function showHistoryDetailsForgeEvent.onModalWindow(player, modalWindowId, buttonId, choiceId)
    player:unregisterEvent("showHistoryDetails")
    if modalWindowId ~= 1005 then return false end
    
    if buttonId == 1 then
		showHistoryOptions(player:getId())
        return false
    end
    return true
end

showHistoryDetailsForgeEvent:register()

local forgeAction = Action()
function forgeAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    _G.currentExaltationItem = item
    showForgeOptions(player:getId())
    return true
end

forgeAction:id(40802)
forgeAction:register()

local enterRoom = MoveEvent()

local rooms = {
    Position(32173, 32274, 8), -- Room 1
    Position(32173, 32257, 8), -- Room 2
	Position(32173, 32240, 8) -- Room 3
}

local roomRangeX = 6
local roomRangeY = 6

function enterRoom.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    for _, roomPosition in ipairs(rooms) do
        local spectators = Game.getSpectators(roomPosition, false, false, roomRangeX, roomRangeX, roomRangeY, roomRangeY)
        
        if #spectators == 0 then
            player:teleportTo(roomPosition)
            player:setDirection(DIRECTION_SOUTH)
			player:say("Entered the Exaltation Forge!")
            return true
        end
    end
	
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The forge rooms are busy, come back another time.")
    player:teleportTo(Position(32208, 32284, 7), true) 
    return true
end

enterRoom:type("stepin")
enterRoom:aid(65021)
enterRoom:register()

local exitRoom = Action()
function exitRoom.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:teleportTo(Position(32208, 32284, 7))
	player:getPosition():sendMagicEffect(CONST_ME_PURPLETELEPORT)
	player:setDirection(DIRECTION_SOUTH)
	player:say("Exit the Exaltation Forge!")
	return true
end

exitRoom:id(44688, 44695, 44696)
exitRoom:register()



