local autoloot = {
    talkaction = "!autoloot",
    freeAccountLimit = 2,
    premiumAccountLimit = 4,
	autoLootBoostDays = 7 * 24 * 60 * 60, -- 7 days
	autoLootBoostItem = 24145
}

local currencyItems = {}
for index, item in pairs(Game.getCurrencyItems()) do
	currencyItems[item:getId()] = true
end

local autolootCache = {}
local textEditRequests = {}
local autolootEnabled = {}

local function getPlayerLimit(player)
    return player:isPremium() and autoloot.premiumAccountLimit or autoloot.freeAccountLimit
end

local function getPlayerAutolootItems(player)
    local limits = getPlayerLimit(player)
    local guid = player:getGuid()
    local itemsCache = autolootCache[guid]
    if itemsCache then
        if #itemsCache > limits then
            local newCache = {unpack(itemsCache, 1, limits)}
            autolootCache[guid] = newCache
            return newCache
        end
        return itemsCache
    end

    local items = {}
    for i = 1, limits do
        local itemType = ItemType(math.max(player.storage[Storage.STORAGEVALUE_AUTOLOOTBASE + i], 0))
        if itemType and itemType:getId() ~= 0 then
            items[#items + 1] = itemType:getId()
        end
    end

    autolootCache[guid] = items
    return items
end

local function setPlayerAutolootItems(player, newItems)
    local items = getPlayerAutolootItems(player)
    for i = getPlayerLimit(player), 1, -1 do
        local itemId = newItems[i]
        if itemId then
            player.storage[Storage.STORAGEVALUE_AUTOLOOTBASE + i] = itemId
            items[i] = itemId
        else
            player.storage[Storage.STORAGEVALUE_AUTOLOOTBASE + i] = -1
            table.remove(items, i)
        end
    end
    return true
end

local function addPlayerAutolootItem(player, itemId)
    local items = getPlayerAutolootItems(player)
    for _, id in pairs(items) do
        if itemId == id then
            return false
        end
    end
    items[#items + 1] = itemId
    return setPlayerAutolootItems(player, items)
end

local function removePlayerAutolootItem(player, itemId)
    local items = getPlayerAutolootItems(player)
    for i, id in pairs(items) do
        if itemId == id then
            table.remove(items, i)
            return setPlayerAutolootItems(player, items)
        end
    end
    return false
end

local function hasPlayerAutolootItem(player, itemId)
    for _, id in pairs(getPlayerAutolootItems(player)) do
        if itemId == id then
            return true
        end
    end
    return false
end

local function findLootPouch(player)
    local ammo = player:getSlotItem(CONST_SLOT_AMMO)
    if ammo and ammo:isContainer() then
        if ammo:getId() == ITEM_LOOT_POUCH then
            return ammo
        end
        for i = ammo:getSize() - 1, 0, -1 do
            local subContainer = ammo:getItem(i)
            if subContainer and subContainer:isContainer() and subContainer:getId() == ITEM_LOOT_POUCH then
                return subContainer
            end
        end
    end
    return nil
end

-- Local function to manage boost time
local function BoostDeposit(player, item)
    local currentTime = os.time()
    local boostDeposit = player:getStorageValue(Storage.STORAGEVALUE_AUTOLOOTBOOST)

    if boostDeposit == -1 or (boostDeposit > 0 and (currentTime - boostDeposit) >= autoloot.autoLootBoostDays) then
        player:setStorageValue(Storage.STORAGEVALUE_AUTOLOOTBOOST, currentTime)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You have activated Auto Loot Boost, you now have 7 days.")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		item:remove(1)
	else
        local timeElapsed = currentTime - boostDeposit
        local timeRemaining = autoloot.autoLootBoostDays - timeElapsed
        
        local days = math.floor(timeRemaining / 86400)
        local hours = math.floor((timeRemaining % 86400) / 3600)
        local minutes = math.floor((timeRemaining % 3600) / 60)
        local seconds = timeRemaining % 60
        
        player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("You already have an Auto Loot Boost activated, you have Time left: %dd, %02dh, %02dm, %02ds.", days, hours, minutes, seconds))
    end
end

local function getBoostTimeRemaining(currentTime, boostDeposit, duration)
    if boostDeposit == -1 or (boostDeposit > 0 and (currentTime - boostDeposit) >= autoloot.autoLootBoostDays) then
        return "0d, 0h, 0m, 0s"
    else
        local timeElapsed = currentTime - boostDeposit
        local timeRemaining = autoloot.autoLootBoostDays - timeElapsed
        
        local days = math.floor(timeRemaining / 86400) 
        local hours = math.floor((timeRemaining % 86400) / 3600)
        local minutes = math.floor((timeRemaining % 3600) / 60)
        local seconds = timeRemaining % 60
        
        return string.format("%dd, %02dh, %02dm, %02ds", days, hours, minutes, seconds)
    end
end

local function setAutolootState(player, state)
    player:setStorageValue(Storage.STORAGEVALUE_AUTOLOOTSTATE, state and 1 or -1)
end

local function getAutolootState(player)
    return player:getStorageValue(Storage.STORAGEVALUE_AUTOLOOTSTATE) == 1
end

local function setAutolootDepositState(player, state)
    player:setStorageValue(Storage.STORAGEVALUE_AUTOLOOTDEPOSITSTATE, state and 1 or -1)
end

local function getAutolootDepositState(player)
    return player:getStorageValue(Storage.STORAGEVALUE_AUTOLOOTDEPOSITSTATE) == 1
end

local function setAutolootMoneyState(player, state)
    player:setStorageValue(Storage.STORAGEVALUE_AUTOLOOTMONEYSTATE, state and 1 or -1)
end

local function getAutolootMoneyState(player)
    return player:getStorageValue(Storage.STORAGEVALUE_AUTOLOOTMONEYSTATE) == 1
end

local ec = Event()

function ec.onDropLoot(monster, corpse)
    if not corpse:getType():isContainer() then
        return
    end

    local corpseOwnerGuid = corpse:getCorpseOwner()
    local corpseOwner = corpseOwnerGuid and Player(corpseOwnerGuid) or nil
	
    if not corpseOwner then
        return
    end

    local autolootState = corpseOwner:getStorageValue(Storage.STORAGEVALUE_AUTOLOOTSTATE)
    local autolootDepositState = corpseOwner:getStorageValue(Storage.STORAGEVALUE_AUTOLOOTDEPOSITSTATE)
	local autolootMoneyState = corpseOwner:getStorageValue(Storage.STORAGEVALUE_AUTOLOOTMONEYSTATE)
    
    if autolootState ~= 1 then
        return
    end

    local items = corpse:getItems()
    local warningCapacity = false
    local lootPouch = findLootPouch(corpseOwner)
    
    local autolootItemsFound = false
    for _, item in pairs(items) do
        local itemId = item:getId()
        if hasPlayerAutolootItem(corpseOwner, itemId) then
            autolootItemsFound = true
            break
        end
    end
    
    if autolootItemsFound and not lootPouch then
        corpseOwner:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "You do not have a loot pouch in your ammo slot. Place a loot pouch for autoloot to work.")
        return
    end
    
    for _, item in pairs(items) do
        local itemId = item:getId()
        if hasPlayerAutolootItem(corpseOwner, itemId) then
            if currencyItems[itemId] then
				if autolootMoneyState == 1 then
					if autolootDepositState == 1 then
						local worth = item:getWorth()
						corpseOwner:setBankBalance(corpseOwner:getBankBalance() + worth)
						corpseOwner:sendTextMessage(MESSAGE_STATUS_SMALL, string.format("Your balance increases by %d gold coins.", worth))
						item:remove()
					elseif not item:moveTo(lootPouch, 0) then
						warningCapacity = true
					end
				end
            else
                if not item:moveTo(lootPouch, 0) then
                    warningCapacity = true
                end
            end
        end
    end

    if warningCapacity then
        corpseOwner:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your loot pouch does not have enough capacity.")
    end
end

ec:register(3)

local talkAction = TalkAction(autoloot.talkaction)

local exhaust = {}

function talkAction.onSay(player, words, param, type)
    local playerId = player:getId()
    local currentTime = os.time()
    if exhaust[playerId] and exhaust[playerId] > currentTime then
        player:sendCancelMessage("You are on cooldown, now wait (0." .. exhaust[playerId] - currentTime .. "s).")
        return false
    end
    
    local split = param:splitTrimmed(",")
    local action = split[1]
    local limit = getPlayerLimit(player)
    local items = getPlayerAutolootItems(player)
    local usedSlots = #items
	local boostDeposit = player:getStorageValue(Storage.STORAGEVALUE_AUTOLOOTBOOST)
	
    if not action then
        player:popupFYI(string.format("[+] Auto Loot Commands [+]\n\nExamples of use:\n%s add, dragon scale mail -> To add item from list.\n%s remove, royal helmet -> To remove item from list.\n%s clear -> To clear the list.\n%s list -> To show the list.\n%s edit -> To edit the list of loot.\n%s on/off -> To enable or disable the auto loot.\n%s money -> To enable or disable the money collect.\n%s deposit -> To enable or disable the deposit auto loot.\n\n[+] Auto Loot Info [+]\nAuto Loot: %s\nGold Money: %s\nGold Deposit: %s\nFree Account: %d\nPremium Account: %d\n\nYour Slots: [%d/%d].\n[Auto Loot Boost: %s].", 
		words, words, words, words, words, words, words, words, getAutolootState(player) and "Enabled." or "Disabled.", getAutolootMoneyState(player) and "Enabled." or "Disabled.", getAutolootDepositState(player) and "Enabled." or "Disabled.", autoloot.freeAccountLimit, autoloot.premiumAccountLimit, usedSlots, limit, getBoostTimeRemaining(currentTime, boostDeposit, autoloot.autoLootBoostDays)), false)
        exhaust[playerId] = currentTime + 2
        return false
    end
	
	if action == "on" then
		setAutolootState(player, true)
		player:sendTextMessage(MESSAGE_INFO_DESCR, "The Auto Loot has been enabled.")
		exhaust[playerId] = currentTime + 2
		return false
	elseif action == "off" then
		setAutolootState(player, false)
		player:sendTextMessage(MESSAGE_INFO_DESCR, "The Auto Loot has been disabled.")
		exhaust[playerId] = currentTime + 2
		return false
	elseif action == "deposit" then
		if boostDeposit == -1 or (boostDeposit > 0 and (currentTime - boostDeposit) >= autoloot.autoLootBoostDays) then
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You need to have Auto Loot Boost to use deposit.")
            return false
        end
        setAutolootDepositState(player, not getAutolootDepositState(player))
        player:sendTextMessage(MESSAGE_EVENT_ORANGE, string.format("Auto Loot Deposit is now %s.", getAutolootDepositState(player) and "enabled" or "disabled"))
		exhaust[playerId] = currentTime + 2
		return false
	elseif action == "money" then
		setAutolootMoneyState(player, not getAutolootMoneyState(player))
        player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Auto Loot Money is now: %s.", getAutolootMoneyState(player) and "enabled" or "disabled"))
		exhaust[playerId] = currentTime + 2
		return false
    elseif action == "clear" then
        setPlayerAutolootItems(player, {})
        player:sendTextMessage(MESSAGE_EVENT_ORANGE, "Autoloot list cleaned.")
        return false
    elseif action == "list" then
        local items = getPlayerAutolootItems(player)
		local description = {string.format('Your Auto Loot list:')}
		for i, itemId in ipairs(items) do
			local itemName = ItemType(itemId):getName()
			if i == #items then
				description[#description + 1] = string.format(" %s", itemName)
			else
				description[#description + 1] = string.format(" %s,", itemName)
			end
		end
		description[#description + 1] = string.format("\n[Slots used: %d/%d].", #items, getPlayerLimit(player))
		player:sendTextMessage(MESSAGE_EVENT_ORANGE, table.concat(description, ''))
        exhaust[playerId] = currentTime + 2
        return false
    elseif action == "edit" then
        local items = getPlayerAutolootItems(player)
        if #items == 0 then
            -- Example
            items = {3386,3381,3079}
        end
        local description = {}
        for i, itemId in pairs(items) do
            description[#description + 1] = ItemType(itemId):getName()
        end
        player:registerEvent("autolootTextEdit")
        player:showTextDialog(2814, string.format("To add articles you just have to write their IDs or names on each line\nfor example:\n\n%s", table.concat(description, '\n')), true)
        exhaust[playerId] = currentTime + 2
        return false
    end

    local itemName = split[2] and split[2]:trim() or ""
    local itemId = ItemType(itemName):getId()

    if action == "add" then
        if itemId == 0 then
            player:sendCancelMessage("Item not found.")
            return false
        end
		
		if table.contains({3031, 3035, 3043}, itemId) then
            player:sendCancelMessage("You cannot add this item to the autoloot list.")
            return false
        end
		
        if addPlayerAutolootItem(player, itemId) then
            player:sendTextMessage(MESSAGE_EVENT_ORANGE, string.format("The item %s added to autoloot list.", ItemType(itemId):getName()))
        else
            player:sendCancelMessage("The item is already in your autoloot list.")
        end
    elseif action == "remove" then
        if itemId == 0 then
            player:sendCancelMessage("Item not found.")
            return false
        end
        if removePlayerAutolootItem(player, itemId) then
            player:sendTextMessage(MESSAGE_EVENT_ORANGE, string.format("The Item %s removed from autoloot list.", ItemType(itemId):getName()))
        else
            player:sendCancelMessage("Item not found in your autoloot list.")
        end
    end

    exhaust[playerId] = currentTime + 2
    return false
end

talkAction:separator(" ")
talkAction:register()

local creatureEvent = CreatureEvent("autolootCleanCache")

function creatureEvent.onLogout(player)
	local boostDeposit = player:getStorageValue(Storage.STORAGEVALUE_AUTOLOOTBOOST)
    if boostDeposit > 0 and os.time() - boostDeposit >= autoloot.autoLootBoostDays then
        setAutolootDepositState(player, false)
    end
    setPlayerAutolootItems(player, getPlayerAutolootItems(player))
    autolootCache[player:getGuid()] = nil
    return true
end

creatureEvent:register()

creatureEvent = CreatureEvent("autolootTextEdit")

function creatureEvent.onTextEdit(player, item, text)
    player:unregisterEvent("autolootTextEdit")
    local split = text:splitTrimmed("\n")
    local items = {}
	
    for index, name in pairs(split) do 
        repeat
            local itemType = ItemType(name)
            if not itemType or itemType:getId() == 0 then
                itemType = ItemType(tonumber(name))
                if not itemType or itemType:getId() == 0 then
                    break
                end
            end

            local itemId = itemType:getId()
            if table.contains({3031, 3035, 3043}, itemId) then
                player:sendCancelMessage("You cannot add this item to the autoloot list.")
                return false
            end

            items[#items + 1] = itemId
        until true 
    end
	
    setPlayerAutolootItems(player, items)
    player:sendTextMessage(MESSAGE_STATUS_SMALL, "Perfect, you have modified the list of articles manually.")
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Perfect, you have modified the list of articles manually.")
    return true
end

creatureEvent:register()

local autolootBoost = Action()

function autolootBoost.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    BoostDeposit(player, item)
    return true
end

autolootBoost:aid(autoloot.autoLootBoostItem)
autolootBoost:register()