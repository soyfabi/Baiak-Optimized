local Onslaught1 = CreatureEvent("Onslaught1")

function Onslaught1.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if not creature or not attacker or not attacker:isPlayer() then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    local player = attacker:getPlayer()
    local weapon = player:getSlotItem(CONST_SLOT_LEFT)

    if weapon and weapon:getType():isWeapon() then
        local attributeName = "Onslaught"
        local attributeValue = weapon:getCustomAttribute(attributeName) -- Access the specific attribute
        local tier = weapon:getAttribute(ITEM_ATTRIBUTE_TIER) or 0
        local activationChance = _G.activationChances[attributeName] and _G.activationChances[attributeName][tier] or 0
		
        if attributeValue and math.random() < activationChance then
            -- Adds 60% to the damage
            local damageBoost = math.floor(primaryDamage * 0.60)
            primaryDamage = primaryDamage + damageBoost

            -- Show visual effect
            creature:getPosition():sendMagicEffect(CONST_ME_FATAL)
        end
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

Onslaught1:register()

local Onslaught2 = CreatureEvent("Onslaught2")

function Onslaught2.onManaChange(creature, attacker, manaChange)
    if not creature or not attacker or not attacker:isPlayer() then
        return manaChange
    end

    local player = attacker:getPlayer()
    local weapon = player:getSlotItem(CONST_SLOT_LEFT)

    if weapon and weapon:getType():isWeapon() then
        local attributeName = "Onslaught"
        local attributeValue = weapon:getCustomAttribute(attributeName) -- Access the specific attribute
        local tier = weapon:getAttribute(ITEM_ATTRIBUTE_TIER) or 0
        local activationChance = _G.activationChances[attributeName] and _G.activationChances[attributeName][tier] or 0
		
        if attributeValue and math.random() < activationChance then
            -- Adds 60% to the mana change
            local manaBoost = math.floor(manaChange * 0.60)
            manaChange = manaChange + manaBoost

            -- Show visual effect
            creature:getPosition():sendMagicEffect(CONST_ME_FATAL)
        end
    end

    return manaChange
end

Onslaught2:register()

local Onslaught3 = CreatureEvent("OnslaughtLogin")
function Onslaught3.onLogin(player)
	player:registerEvent("Onslaught1")
	player:registerEvent("Onslaught2")
	return true
end

Onslaught3:register()

local Onslaught4 = Event()

function Onslaught4.onSpawn(creature)
    if creature:isMonster() then
        creature:registerEvent("Onslaught1")
    end
    return true
end

Onslaught4:register()
