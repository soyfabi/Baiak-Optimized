local config = {
    ["Exercise Sword"] = {
        id = 28552,
    },
    ["Exercise Axe"] = {
        id = 28553,
    },
	["Exercise Club"] = {
        id = 28554,
    },
	["Exercise Bow"] = {
        id = 28555,
    },
	["Exercise Rod"] = {
        id = 28556,
    },
	["Exercise Wand"] = {
        id = 28557,
    },
}

local function createFirstSelectWeaponWindow(playerId)
    local player = Player(playerId)
    if not player then
        return false 
    end

    local windowTitle = "This starter kit will give you a free Exercise Weapon."
    local window = ModalWindow(1500, "Exercise Weapons", windowTitle .. "\n\nSelect an Exercise Weapon:")

    player:registerEvent("SelectExerciseWeaponWindow")

    local choiceId = 1
    for weaponName, weaponInfo in pairs(config) do
        window:addChoice(choiceId, weaponName)
        choiceId = choiceId + 1
    end

    window:addButton(1, "Select")
    window:setDefaultEnterButton(1)
    window:addButton(2, "Cancel")
    window:setDefaultEscapeButton(2)

    window:sendToPlayer(player)
    return true
end

local function createConfirmationWindow(playerId, weaponName, choiceId)
    local player = Player(playerId)
    if not player then
        return false 
    end

    local windowTitle = "Are you sure you want the " .. weaponName .. "?"
    local window = ModalWindow(1501, "Confirm Weapon", windowTitle)

    player:registerEvent("ConfirmExerciseWeaponWindow")
    player:setStorageValue(1501, choiceId)  -- Store the choiceId to retrieve it later

    window:addButton(1, "Accept")
    window:setDefaultEnterButton(1)
    window:addButton(2, "Back")
    window:setDefaultEscapeButton(2)

    window:sendToPlayer(player)
    return true
end

local talkAction = TalkAction("!starter", "!exercise", "!fonticak")

function talkAction.onSay(player, words, param, type)
    if player:getStorageValue(STORAGEVALUE_STARTER_EXERCISE) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have received the reward of exercise.")
		return false
	end
	
	createFirstSelectWeaponWindow(player:getId())
	
    return true
end

talkAction:register()

local selectWeaponModal = CreatureEvent("SelectExerciseWeaponWindow")

function selectWeaponModal.onModalWindow(player, modalWindowId, buttonId, choiceId)
    player:unregisterEvent("SelectExerciseWeaponWindow")

    if modalWindowId == 1500 and buttonId == 1 then
        local weaponName
        local choiceCounter = 1
        for name, info in pairs(config) do
            if choiceCounter == choiceId then
                weaponName = name
                break
            end
            choiceCounter = choiceCounter + 1
        end

        if weaponName then
            createConfirmationWindow(player:getId(), weaponName, choiceId)
        end
    end
    return true
end

selectWeaponModal:register()

local confirmWeaponModal = CreatureEvent("ConfirmExerciseWeaponWindow")

function confirmWeaponModal.onModalWindow(player, modalWindowId, buttonId, choiceId)
    player:unregisterEvent("ConfirmExerciseWeaponWindow")

    if modalWindowId == 1501 then
        local storedChoiceId = player:getStorageValue(1501)

        if buttonId == 1 then
            -- Accept button
            local weaponName
            local choiceCounter = 1
            for name, info in pairs(config) do
                if choiceCounter == storedChoiceId then
                    weaponName = name
                    break
                end
                choiceCounter = choiceCounter + 1
            end

            if weaponName and config[weaponName] then
                local weaponId = config[weaponName].id
                local item = player:addItem(weaponId, 1)
                if item then
                    item:setAttribute(ITEM_ATTRIBUTE_CHARGES, 3000)
					item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "This weapon belongs to [".. player:getName() .."].")
					item:setCustomAttribute("OwnerWeapon", player:getGuid())
                end
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have received a " .. weaponName .. " with 3000 charges.")
                player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
				player:setStorageValue(STORAGEVALUE_STARTER_EXERCISE, 1)
            end
        elseif buttonId == 2 then
            -- Back button
            createFirstSelectSlotWindow(player:getId())
        end
    end
    return true
end

confirmWeaponModal:register()