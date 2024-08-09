local debugMode = true -- Set to true to enable debug messages for spells, false to disable

-- Function to print debug messages
local function debugPrint(message)
    if debugMode then
        print(message)
    end
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREAREA)
combat:setArea(createCombatArea(AREA_WAVE4))

function onGetFormulaValues(player, level, magicLevel)
    local min = (level / 5) + (magicLevel * 8) + 50
    local max = (level / 5) + (magicLevel * 12) + 75
    return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
    if creature:isPlayer() then
        local player = creature:getPlayer()
        local spellName = "Hell's Core"
        local currentTime = os.time()
        local baseCooldown = 5
        local lastCastTime = player:getStorageValue(45002)

        local timeElapsed = lastCastTime > 0 and (currentTime - lastCastTime) or baseCooldown
        local cooldown = baseCooldown
		
        local momentumTriggered = triggerMomentum(player)
        if momentumTriggered then
            cooldown = 2
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, string.format("Momentum reduced cooldown to %d seconds.", cooldown))
        end
		
        print("Cooldown Base (seconds): " .. baseCooldown)
        print("Elapsed Time (seconds): " .. timeElapsed)
        print("Cooldown After Reduction (seconds): " .. cooldown)
		
        if timeElapsed < cooldown then
            local timeRemaining = cooldown - timeElapsed
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, string.format("You must wait %d seconds to cast %s again.", timeRemaining, spellName))
            debugPrint(string.format("Spell %s cast too early. You must wait %d seconds.", spellName, timeRemaining))
            return false
        end
		
        player:setStorageValue(45002, currentTime)
        return combat:execute(creature, variant)
    end
    return false
end

spell:name("Hell's Core")
spell:words("test spell")
spell:group("attack")
spell:vocation("warrior", "master sorcerer")
spell:cooldown(1000)
spell:groupCooldown(1000)
spell:id(24)
spell:level(60)
spell:mana(1100)
spell:isSelfTarget(false)
spell:isPremium(false)
spell:register()