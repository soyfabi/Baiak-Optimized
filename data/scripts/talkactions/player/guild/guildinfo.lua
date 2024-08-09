local guildinfo = TalkAction("!guildinfo", "!guild", "/guildinfo", "/guild")
local exhaust = {}
local exhaustTime = 3

function guildinfo.onSay(player, words, param)
    local playerId = player:getId()
    local currentTime = os.time()
    if exhaust[playerId] and exhaust[playerId] > currentTime then
        player:sendCancelMessage("This command is still on cooldown. (0." .. exhaust[playerId] - currentTime .. "s).")
        return false
    end

    local guild = player:getGuild()
    if not guild then
        player:sendCancelMessage("You are not in a guild.")
        return false
    end

    local membersOnline = guild:getMembersOnline()
    local membersOnlineCount = 0
    local memberInfo = {}
    local maxMembersToShow = 10
    local highestLevelMember = {name = "", level = 0} -- Initialize with an empty member and level 0
    local highestMagicLevelMember = {name = "", magicLevel = 0} -- Initialize with an empty member and magic level 0
    local highestSwordLevelMember = {name = "", swordLevel = 0} -- Initialize with an empty member and sword level 0
    local highestAxeLevelMember = {name = "", axeLevel = 0} -- Initialize with an empty member and axe level 0
    local highestClubLevelMember = {name = "", clubLevel = 0} -- Initialize with an empty member and club level 0
    local highestDistanceLevelMember = {name = "", distanceLevel = 0} -- Initialize with an empty member and distance level 0
    local highestShieldingLevelMember = {name = "", shieldingLevel = 0} -- Initialize with an empty member and shielding level 0

    for _, member in pairs(membersOnline) do
        if membersOnlineCount >= maxMembersToShow then
            break
        end

        local playerName = Player(member):getName()
        local playerLevel = Player(member):getLevel()
        local playerVocation = Player(member):getVocation():getName()

        local memberData = playerName .. " (Level: " .. playerLevel .. ") [" .. playerVocation .. "]"
        table.insert(memberInfo, memberData)
        membersOnlineCount = membersOnlineCount + 1

        -- Check and update highest level member
        if playerLevel > highestLevelMember.level then
            highestLevelMember.name = playerName
            highestLevelMember.level = playerLevel
        end

        -- Check and update highest magic level member
        local playerMagicLevel = Player(member):getMagicLevel()
        if playerMagicLevel > highestMagicLevelMember.magicLevel then
            highestMagicLevelMember.name = playerName
            highestMagicLevelMember.magicLevel = playerMagicLevel
        end

        -- Check and update highest sword level member
        local playerSwordLevel = Player(member):getSkillLevel(SKILL_SWORD)
        if playerSwordLevel > highestSwordLevelMember.swordLevel then
            highestSwordLevelMember.name = playerName
            highestSwordLevelMember.swordLevel = playerSwordLevel
        end

        -- Check and update highest axe level member
        local playerAxeLevel = Player(member):getSkillLevel(SKILL_AXE)
        if playerAxeLevel > highestAxeLevelMember.axeLevel then
            highestAxeLevelMember.name = playerName
            highestAxeLevelMember.axeLevel = playerAxeLevel
        end

        -- Check and update highest club level member
        local playerClubLevel = Player(member):getSkillLevel(SKILL_CLUB)
        if playerClubLevel > highestClubLevelMember.clubLevel then
            highestClubLevelMember.name = playerName
            highestClubLevelMember.clubLevel = playerClubLevel
        end

        -- Check and update highest distance level member
        local playerDistanceLevel = Player(member):getSkillLevel(SKILL_DISTANCE)
        if playerDistanceLevel > highestDistanceLevelMember.distanceLevel then
            highestDistanceLevelMember.name = playerName
            highestDistanceLevelMember.distanceLevel = playerDistanceLevel
        end

        -- Check and update highest shielding level member
        local playerShieldingLevel = Player(member):getSkillLevel(SKILL_SHIELD)
        if playerShieldingLevel > highestShieldingLevelMember.shieldingLevel then
            highestShieldingLevelMember.name = playerName
            highestShieldingLevelMember.shieldingLevel = playerShieldingLevel
        end
    end

    local memberInfoStr = table.concat(memberInfo, "\n")

    local warStatus = Game.getStorageValue(80000)
    local guildId = guild:getId()
    local bankBalance = Guild.getBankBalance(guildId)

    local text = "[Guild Info]\nAll your guild information.\n\n"
    text = text .. "Your guild is: [" .. guild:getName() .. "].\n\n"
    text = text .. "Guild Level is: [" .. guild:getLevel() .. "]: ->\n"
    text = text .. "[+] Exp Bonus: " .. GuildLevel.level_experience[guild:getLevel()].exp .. "%.\n"
    text = text .. "[+] Loot Bonus: " .. GuildLevel.level_experience[guild:getLevel()].loot .. "%.\n"
    text = text .. "Guild Exp Accumulated: [" .. guild:getExperience() .. "].\n\n"

    local resultId =
        db.storeQuery(
        string.format(
            "SELECT `namedeposit`, `amountdeposit`, `namewithdraw`, `amountwithdraw` FROM `guilds` WHERE `id` = %d",
            guildId
        )
    )
    if resultId ~= false then
        local nameDeposit, amountDeposit, nameWithdraw, amountWithdraw

        if result.getDataInt(resultId, "amountdeposit") > 0 then
            nameDeposit = result.getString(resultId, "namedeposit")
            amountDeposit = result.getNumber(resultId, "amountdeposit")
        end

        if result.getDataInt(resultId, "amountwithdraw") > 0 then
            nameWithdraw = result.getString(resultId, "namewithdraw")
            amountWithdraw = result.getNumber(resultId, "amountwithdraw")
        end

        result.free(resultId)

        text = text .. "Guild Bank Balance: [" .. bankBalance .. "].\n"
        if nameDeposit and amountDeposit then
            text = text .. "[+] Last to deposit: " .. nameDeposit .. ".\n"
            text = text .. "[+] Money deposited: " .. amountDeposit .. ".\n"
        else
            text = text .. "[+] Last to deposit:\n"
            text = text .. "[+] No deposits yet.\n"
        end
        if nameWithdraw and amountWithdraw then
            text = text .. "[-] Last to withdraw: " .. nameWithdraw .. ".\n"
            text = text .. "[-] Money withdraw: " .. amountWithdraw .. ".\n\n"
        else
            text = text .. "[-] Last to withdraw:\n"
            text = text .. "[-] No withdraw yet.\n\n"
        end
    else
        text = text .. "Guild Bank Balance: [" .. bankBalance .. "].\n"
        text = text .. "[+] Last to deposit:\n"
        text = text .. "[+] No deposits yet.\n"
        text = text .. "[-] Last to withdraw:\n"
        text = text .. "[-] No withdraw yet.\n\n"
    end

    text = text .. "<-Max 10 Members Online->\n"
    text = text .. "Members online: " .. membersOnlineCount .. ":\n" .. memberInfoStr .. "\n\n"
    text = text .. "<-Top Lists of Members->\n"
    text = text .. "Top Level: " .. highestLevelMember.name .. " (Level " .. highestLevelMember.level .. ").\n"
    text =
        text ..
        "Top Magic Level: " .. highestMagicLevelMember.name .. " (" .. highestMagicLevelMember.magicLevel .. ").\n"
    text =
        text ..
        "Top Sword Fighting: " .. highestSwordLevelMember.name .. " (" .. highestSwordLevelMember.swordLevel .. ").\n"
    text =
        text .. "Top Axe Fighting: " .. highestAxeLevelMember.name .. " (" .. highestAxeLevelMember.axeLevel .. ").\n"
    text =
        text ..
        "Top Club Fighting: " .. highestClubLevelMember.name .. " (" .. highestClubLevelMember.clubLevel .. ").\n"
    text =
        text ..
        "Top Distance Fighting: " ..
            highestDistanceLevelMember.name .. " (" .. highestDistanceLevelMember.distanceLevel .. ").\n"
    text =
        text ..
        "Top Shielding: " ..
            highestShieldingLevelMember.name .. " (" .. highestShieldingLevelMember.shieldingLevel .. ").\n\n"

    text = text .. "<-War Status->\n"
    if warStatus > 1 then
        text = text .. "War Status: On.\n"
    else
        text = text .. "War Status: Off.\n"
    end

    exhaust[playerId] = currentTime + exhaustTime
    player:popupFYI(text)
    return false
end

guildinfo:register()

local config = {
    storage = 89500,
    seconds = 4,
    maxlength = 100,
    messagetype = MESSAGE_STATUS_WARNING
}

local talk = TalkAction("/guildbc", "!guildbc")

function talk.onSay(player, words, param)
    if player:getStorageValue(config.storage) > os.time() then
        player:sendTextMessage(
            MESSAGE_STATUS_SMALL,
            "You can broadcast message only one time per " ..
                config.seconds - player:getStorageValue(config.storage) .. " seconds."
        )
        return false
    end

    if not player:getGuild() then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Sorry, you're not in a guild.")
        return false
    end

    if player:getGuildLevel() < 3 then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "You have to be at least leader to guildcast!")
        return false
    end

    if param == "" then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "You need to type a message to broadcast!")
        return false
    end

    if param:len() > config.maxlength then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Your message max lenght " .. config.maxlength .. " characters")
        return false
    end

    local members, message = 0, "*Guild* " .. player:getName() .. " [" .. player:getLevel() .. "]:\n" .. param

    for i, players in ipairs(Game.getPlayers()) do
        if players:getGuild() and players:getGuild():getId() == player:getGuild():getId() then
            players:sendTextMessage(config.messagetype, message)
            members = members + 1
        end
    end

    player:sendTextMessage(MESSAGE_STATUS_SMALL, "Message sent to your guild members. (Total: " .. members .. ")")
    player:setStorageValue(config.storage, os.time() + config.seconds)
    return false
end

talk:separator(" ")
talk:register()
