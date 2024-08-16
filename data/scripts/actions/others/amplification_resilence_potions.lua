potions_amplification = {
    [36736] = {effect = CONST_ME_HITBYFIRE, storage = Storage.STORAGEVALUE_FIREAMPLIFICATION, maxIncrease = 10, type = COMBAT_FIREDAMAGE, name = "Fire Amplification"},
    [36737] = {effect = CONST_ME_ICEAREA, storage = Storage.STORAGEVALUE_ICEAMPLIFICATION, maxIncrease = 10, type = COMBAT_ICEDAMAGE, name = "Ice Amplification"},
    [36738] = {effect = CONST_ME_HITBYPOISON, storage = Storage.STORAGEVALUE_EARTHAMPLIFICATION, maxIncrease = 10, type = COMBAT_EARTHDAMAGE, name = "Earth Amplification"},
    [36739] = {effect = CONST_ME_ENERGYAREA, storage = Storage.STORAGEVALUE_ENERGYAMPLIFICATION, maxIncrease = 10, type = COMBAT_ENERGYDAMAGE, name = "Energy Amplification"},
    [36740] = {effect = CONST_ME_YELLOW_RINGS, storage = Storage.STORAGEVALUE_HOLYAMPLIFICATION, maxIncrease = 10, type = COMBAT_HOLYDAMAGE, name = "Holy Amplification"},
    [36741] = {effect = CONST_ME_MORTAREA, storage = Storage.STORAGEVALUE_DEATHAMPLIFICATION, maxIncrease = 10, type = COMBAT_DEATHDAMAGE, name = "Death Amplification"},
    [36742] = {effect = CONST_ME_HITAREA, storage = Storage.STORAGEVALUE_PHYSICALAMPLIFICATION, maxIncrease = 10, type = COMBAT_PHYSICALDAMAGE, name = "Physical Amplification"},
}

potions_resilience = {
    [36729] = {effect = CONST_ME_HITBYFIRE, storage = Storage.STORAGEVALUE_FIRERESILIENCE, maxIncrease = 10, type = COMBAT_FIREDAMAGE, name = "Fire Resilience"},
    [36730] = {effect = CONST_ME_ICEAREA, storage = Storage.STORAGEVALUE_ICERESILIENCE, maxIncrease = 10, type = COMBAT_ICEDAMAGE, name = "Ice Resilience"},
    [36731] = {effect = CONST_ME_HITBYPOISON, storage = Storage.STORAGEVALUE_EARTHRESILIENCE, maxIncrease = 10, type = COMBAT_EARTHDAMAGE, name = "Earth Resilience"},
    [36732] = {effect = CONST_ME_ENERGYAREA, storage = Storage.STORAGEVALUE_ENERGYRESILIENCE, maxIncrease = 10, type = COMBAT_ENERGYDAMAGE, name = "Energy Resilience"},
    [36733] = {effect = CONST_ME_YELLOW_RINGS, storage = Storage.STORAGEVALUE_HOLYRESILIENCE, maxIncrease = 10, type = COMBAT_HOLYDAMAGE, name = "Holy Resilience"},
    [36734] = {effect = CONST_ME_MORTAREA, storage = Storage.STORAGEVALUE_DEATHRESILIENCE, maxIncrease = 10, type = COMBAT_DEATHDAMAGE, name = "Death Resilience"},
    [36735] = {effect = CONST_ME_HITAREA, storage = Storage.STORAGEVALUE_PHYSICALRESILIENCE, maxIncrease = 10, type = COMBAT_PHYSICALDAMAGE, name = "Physical Resilience"},
}

local resets_disconnect = false -- Do you want it to restart (% potions amplification/resilience) when disconnected?
local resets_death = true -- Do you want it to restart (% potions amplification/resilience) when death?

local exhaust = {}
local amp_resi = Action()

function amp_resi.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local playerId = player:getId()
    local currentTime = os.time()
    if exhaust[playerId] and exhaust[playerId] > currentTime then
        player:sendCancelMessage("You are on cooldown, wait (0." .. exhaust[playerId] - currentTime .. "s) for use potions.")
        return true
    end

    local potion = potions_amplification[item.itemid] or potions_resilience[item.itemid]
    if not potion then
        return false
    end

    local currentIncrease = player:getStorageValue(potion.storage)
    if currentIncrease == -1 then
        currentIncrease = 0
    end

    if currentIncrease < potion.maxIncrease then
        currentIncrease = currentIncrease + 1
        player:setStorageValue(potion.storage, currentIncrease)
        player:getPosition():sendMagicEffect(potion.effect)
        if potions_amplification[item.itemid] then
            player:sendTextMessage(MESSAGE_EVENT_ORANGE, "Added [" .. currentIncrease .. "/" .. potion.maxIncrease .. "] of " .. potion.name .. " Potion.\nYour damage of " .. getCombatName(potion.type) .. " were increased by " .. currentIncrease .. "%.")
        else
            player:sendTextMessage(MESSAGE_EVENT_ORANGE, "Added [" .. currentIncrease .. "/" .. potion.maxIncrease .. "] of " .. potion.name .. " Potion.\nYour defenses against " .. getCombatName(potion.type) .. " were increased by " .. currentIncrease .. "%.")
        end
        item:remove(1)
		player:say("Glup Arrh!")
    else
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "You have reached the maximum " .. (potions_amplification[item.itemid] and "damage increase " or "defense increase ") .. getCombatName(potion.type) .. " (10%).")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "You have reached the maximum " .. (potions_amplification[item.itemid] and "damage increase " or "defense increase ") .. getCombatName(potion.type) .. " (10%).")
    end
	
    exhaust[playerId] = currentTime + 1
    return true
end

for index, value in pairs(potions_amplification) do
    amp_resi:id(index)
end

for index, value in pairs(potions_resilience) do
    amp_resi:id(index)
end

amp_resi:register()

function getCombatName(combatType)
    local combatNames = {
        [COMBAT_PHYSICALDAMAGE] = 'physical',
        [COMBAT_ENERGYDAMAGE] = 'energy',
        [COMBAT_EARTHDAMAGE] = 'earth',
        [COMBAT_FIREDAMAGE] = 'fire',
        [COMBAT_ICEDAMAGE] = 'ice',
        [COMBAT_HOLYDAMAGE] = 'holy',
        [COMBAT_DEATHDAMAGE] = 'death'
    }
    return combatNames[combatType] or "unknown"
end

local function onDamage(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if not attacker or not attacker:isPlayer() then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    local boostPercent = 0

    for itemId, potionConfig in pairs(potions_amplification) do
        if primaryType == potionConfig.type then
            local increase = attacker:getStorageValue(potionConfig.storage)
            if increase > 0 then
                boostPercent = boostPercent + (increase * 2) -- Multiplied x2
            end
            break
        end
    end

    if boostPercent > 0 then
        primaryDamage = primaryDamage * (1 + (boostPercent / 100))
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

local function onDefense(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if not creature or not creature:isPlayer() then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    local boostPercent = 0

    for itemId, potionConfig in pairs(potions_resilience) do
        if primaryType == potionConfig.type then
            local increase = creature:getStorageValue(potionConfig.storage)
            if increase > 0 then
                boostPercent = boostPercent + (increase * 2) -- Multiplicado x2
            end
            break
        end
    end

    if boostPercent > 0 then
        primaryDamage = primaryDamage * (1 - (boostPercent / 100))
        if primaryDamage < 0 then
            primaryDamage = 0
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

local hpBoost = CreatureEvent("DamageBoostHP")
hpBoost.onHealthChange = onDamage
hpBoost:register()

local mpBoost = CreatureEvent("DamageBoostMP")
mpBoost.onManaChange = onDamage
mpBoost:register()

local hpResilience = CreatureEvent("DefenseBoostHP")
hpResilience.onHealthChange = onDefense
hpResilience:register()

local mpResilience = CreatureEvent("DefenseBoostMP")
mpResilience.onManaChange = onDefense
mpResilience:register()

local event = Event()

function event.onTargetCombat(creature, target)
    if creature and target then
        if creature:isPlayer() then
            target:registerEvent("DamageBoostHP")
            target:registerEvent("DamageBoostMP")
        end
        if target:isPlayer() then
            target:registerEvent("DefenseBoostHP")
            target:registerEvent("DefenseBoostMP")
        end
    end
    return true
end

event:register()
