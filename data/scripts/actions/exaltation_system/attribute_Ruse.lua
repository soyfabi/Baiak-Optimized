-- Definition of Ruse Attribute
local dodgeStorage = 45001 -- Replace with the correct storage value

-- Function to update dodge chance
local function updateDodgeChance(player, item, equip)
    local attributeName = "Ruse"
    local attributeValue = item:getCustomAttribute(attributeName)
    if attributeValue then
        local tier = item:getAttribute(ITEM_ATTRIBUTE_TIER) or 0
        local activationChance = _G.activationChances[attributeName] and _G.activationChances[attributeName][tier] or 0
        local changeValue = (activationChance * 10000) -- Convert to percentage

        if equip then
            local newValue = player:getStorageValue(Storage.STORAGEVALUE_ATTRIBUTERUSE) + changeValue
            player:setStorageValue(Storage.STORAGEVALUE_ATTRIBUTERUSE, newValue)
        else
            local newValue = player:getStorageValue(Storage.STORAGEVALUE_ATTRIBUTERUSE) - changeValue
            player:setStorageValue(Storage.STORAGEVALUE_ATTRIBUTERUSE, newValue)
        end
    end
end

-- MoveEvent for Equipping
local dodgeOnEquip = MoveEvent()

function dodgeOnEquip.onEquip(player, item, slot, isCheck)
    if not isCheck then
        updateDodgeChance(player, item, true)
    end
    return true
end

dodgeOnEquip:slot("armor")
dodgeOnEquip:register()

-- MoveEvent for Unequipping
local dodgeOnDeEquip = MoveEvent()

function dodgeOnDeEquip.onDeEquip(player, item, slot, isCheck)
    if not isCheck then
        updateDodgeChance(player, item, false)
    end
    return true
end

dodgeOnDeEquip:slot("armor")
dodgeOnDeEquip:register()

-- Function to check dodge on health change
local function checkDodgeOnHealthChange(creature)
    local player = creature:getPlayer()
    if player then
        local slotItem = player:getSlotItem(CONST_SLOT_ARMOR)
        if slotItem then
            local attributeName = "Ruse"
            local attributeValue = slotItem:getCustomAttribute(attributeName)
            if attributeValue then
                local tier = slotItem:getAttribute(ITEM_ATTRIBUTE_TIER) or 0
                local activationChance = _G.activationChances[attributeName] and _G.activationChances[attributeName][tier] or 0
                local storageValue = player:getStorageValue(Storage.STORAGEVALUE_ATTRIBUTERUSE)
                local rand = math.random(10000)
                if rand <= storageValue then
                    print("Dodged attack! Tier: " .. tostring(tier) .. ", Activation Chance: " .. tostring(activationChance * 100) .. "%")
                    return true
                end
            end
        end
    end
    return false
end

-- Health Change Event
local dodgeHealthChange = CreatureEvent("onHealthChange_dodgeChance")

function dodgeHealthChange.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if checkDodgeOnHealthChange(creature) then
        primaryDamage = 0
        secondaryDamage = 0
        creature:getPosition():sendMagicEffect(CONST_ME_DODGE)
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

dodgeHealthChange:register()

-- Mana Change Event
local dodgeManaChange = CreatureEvent("onManaChange_dodgeChance")

function dodgeManaChange.onManaChange(creature, attacker, manaChange)
    if checkDodgeOnHealthChange(creature) then
        manaChange = 0
        creature:getPosition():sendMagicEffect(CONST_ME_DODGE)
    end
    return manaChange
end

dodgeManaChange:register()

-- Updating Dodge Storage on Login
local function updateDodgeStorage(playerId)
    local player = Player(playerId)
    if player then
        local storageValue = -1
        local attributeName = "Ruse"
        local slotItem = player:getSlotItem(CONST_SLOT_ARMOR)
        if slotItem then
            local attributeValue = slotItem:getCustomAttribute(attributeName)
            if attributeValue then
                local tier = slotItem:getAttribute(ITEM_ATTRIBUTE_TIER) or 0
                local activationChance = _G.activationChances[attributeName] and _G.activationChances[attributeName][tier] or 0
                storageValue = storageValue + (activationChance * 10000) -- Convert to percentage
            end
        end        
        player:setStorageValue(Storage.STORAGEVALUE_ATTRIBUTERUSE, storageValue)
    end
end

local loginEvent = CreatureEvent("onLogin_updateDodgeStorage")
loginEvent:type("login")
function loginEvent.onLogin(player)
    player:registerEvent("onHealthChange_dodgeChance")
    player:registerEvent("onManaChange_dodgeChance")
    addEvent(updateDodgeStorage, 100, player:getId()) -- Small delay due to login
    return true
end
loginEvent:register()

local inventoryUpdateEvent = Event()
function inventoryUpdateEvent.onInventoryUpdate(player, item, slot, equip)
    updateDodgeChance(player, item, equip)
    return true
end
inventoryUpdateEvent:register()
