local exhaust = {}
local exhaustTime = 30

local function buyTool(player, toolName, itemId, itemCost)
    local playerId = player:getId()
    local currentTime = os.time()

    if exhaust[playerId] and exhaust[playerId] > currentTime then
        player:sendCancelMessage("The " .. toolName .. " is still on cooldown. (" .. (exhaust[playerId] - currentTime) .. "s).")
        return false
    end

    local itemType = ItemType(itemId)
    local itemWeight = itemType:getWeight()
    local playerCap = player:getFreeCapacity()

    if playerCap < itemWeight then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "You have found a " .. itemType:getName() .. " weighing " .. (itemWeight / 100) .. " oz. It's too heavy.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end

    local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
    if not backpack or backpack:getEmptySlots(false) < 1 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Your main backpack is full. You need to free up 1 available slot to get " .. itemType:getName() .. ".")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end

    if player:removeMoney(itemCost) then
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
        player:say("You bought a " .. toolName .. ".")
        player:addItem(itemId, 1)
        exhaust[playerId] = currentTime + exhaustTime
    else
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:sendCancelMessage("You don't have enough gold coins. Cost: [" .. itemCost .. " gold coins].")
    end

    return false
end

local Machete = TalkAction("!machete", "!machet")
function Machete.onSay(player, words, param)
    return buyTool(player, "Machete", 3308, 1000)
end
Machete:register()

local Pick = TalkAction("!pick", "!pickaxe", "!pico")
function Pick.onSay(player, words, param)
    return buyTool(player, "Pick Axe", 3456, 1000)
end
Pick:register()

local Shovel = TalkAction("!shovel", "!pala")
function Shovel.onSay(player, words, param)
    return buyTool(player, "Shovel", 3457, 1000)
end
Shovel:register()

local Rope = TalkAction("!rope", "!cuerda")
function Rope.onSay(player, words, param)
    return buyTool(player, "Rope", 3003, 1000)
end
Rope:register()

local Tools = TalkAction("!tools")
function Tools.onSay(player, words, param)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You can use the command, !shovel, !machete, !pickaxe and !rope.")
	player:sendCancelMessage("You can use the command, !shovel, !machete, !pickaxe and !rope.")
    return false
end
Tools:register()
