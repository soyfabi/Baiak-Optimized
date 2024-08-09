if not boostCreature then boostCreature = {} end

local BoostedCreature = {

    monsters_exp = {
		"Rat", 
		--"Frost Dragon",
		--"Werehyaena",
		--"Dragon Lord"
	},
	
    monsters_loot = {"Rotworm"},
    monsters_boss = {"Scarlet Etzel"},
    db = true,
    exp = {20, 40},
    loot = {30, 60},
	exp_boss = {15, 30},
	loot_boss = {7, 12},
    messages = {
        prefix = "[Boosted Creature] ",
        chosen = "The creature chosen was %s. When killing you receive +%d of experience and +%d of loot.",
    },
}

function capitalizeFirstLetter(str)
    return str:gsub("^%l", string.upper)
end

function BoostedCreature:start()
    local rand = math.random
    local monsterRand_exp = BoostedCreature.monsters_exp[rand(#BoostedCreature.monsters_exp)]
    local monsterRand_loot = BoostedCreature.monsters_loot[rand(#BoostedCreature.monsters_loot)]
    local monsterRand_boss = BoostedCreature.monsters_boss[rand(#BoostedCreature.monsters_boss)]
    local expRand = rand(BoostedCreature.exp[1], BoostedCreature.exp[2])
    local lootRand = rand(BoostedCreature.loot[1], BoostedCreature.loot[2])
	local expRand_boss = rand(BoostedCreature.exp_boss[1], BoostedCreature.exp_boss[2])
	local lootRand_boss = rand(BoostedCreature.loot_boss[1], BoostedCreature.loot_boss[2])
	local boost_exp = {name = capitalizeFirstLetter(monsterRand_exp), exp = expRand, loot = lootRand}
    local boost_loot = {name_loot = capitalizeFirstLetter(monsterRand_loot), loot = lootRand}
    local boost_boss = {name_boss = capitalizeFirstLetter(monsterRand_boss), exp_boss = expRand_boss, loot_boss = lootRand_boss}
    boostCreature = {}
    table.insert(boostCreature, boost_exp)
    table.insert(boostCreature, boost_loot)
    table.insert(boostCreature, boost_boss)
	
    if BoostedCreature.db then
        db.query("INSERT IGNORE INTO `boosted_creature` (`id`) VALUES (1)")
		
        local currentTime = os.time()
        local query = string.format(
            "UPDATE `boosted_creature` SET `name_normal` = '%s', `percent_normal` = %d, `exp_normal` = %d, `name_boss` = '%s', `percent_boss` = %d, `exp_boss` = %d, `date` = %d WHERE `id` = 1",
            boostCreature[1].name, boostCreature[1].loot, boostCreature[1].exp,
            boostCreature[3].name_boss, boostCreature[3].loot_boss, boostCreature[3].exp_boss, currentTime
        )
        db.query(query)
    end
end

BoostedCreature:start()

-- EventCallBack / onGainExperience --

local ec = Event()

function ec.onGainExperience(self, source, exp, rawExp)
    -- Boost Creature
	if not source or source:isPlayer() then
		return exp
	end
	
    local extraXp = 0
	if (source:getName():lower() == capitalizeFirstLetter(boostCreature[1].name):lower()) then
		local extraPercent = boostCreature[1].exp
		extraXp = math.floor(exp * extraPercent / 100)
		
		local position = self:getPosition()
		addEvent(function()
			Game.sendAnimatedText("+" .. extraXp .. " exp", position, 102)
		end, 250)
	end
	
	local extraXp_boss = 0
    if (source:getName():lower() == capitalizeFirstLetter(boostCreature[3].name_boss):lower()) then
        local extraPercent = boostCreature[3].exp_boss
        extraXp_boss = exp * extraPercent / 100
        addEvent(function() Game.sendAnimatedText("+" .. extraXp_boss .. " exp", self:getPosition(), 102) end, 250)
    end

    return exp + extraXp + extraXp_boss
end

ec:register(1)

-- EventCallBack / onDropLoot --

local event = Event()

event.onDropLoot = function(self, corpse)
	local mType = self:getType()
    if mType:isRewardBoss() then
        corpse:registerReward()
        return
    end

    if configManager.getNumber(configKeys.RATE_LOOT) == 0 then
        return
    end

    local player = Player(corpse:getCorpseOwner())
    if not player then
        return false
    end
	
	 if player:getStamina() > 840 then
		local monsterLoot = mType:getLoot()
		
		-- Boost Creature
        local percent = 0
		if (mType:getName():lower() == boostCreature[2].name_loot:lower()) then
			player:sendTextMessage(MESSAGE_STATUS_DEFAULT, "[Boosted Creature] You have killed a " .. mType:getName() .. " with Bonus Loot.")
			percent = (boostCreature[1].loot / 100)
		end
		
		-- Boost Creature Boss
        local percent_boss = 0
        if (mType:getName():lower() == boostCreature[3].name_boss:lower()) then
            player:sendTextMessage(MESSAGE_STATUS_DEFAULT, "[Boosted Creature] You have killed a " .. mType:getName() .. " with Bonus Loot.")
            percent_boss = (boostCreature[1].loot / 100)
        end
		
		for i = 1, #monsterLoot do
            local chance = monsterLoot[i].chance
            chance = (chance * percent) + (chance * percent_boss)
            monsterLoot[i].chance = chance

            local item = corpse:createLootItem(monsterLoot[i])
            if not item then
                print('[Warning] DropLoot:', 'Could not add loot item to corpse.')
            end
        end
	end
end

event:register(-1)

local boostedlogin = CreatureEvent("Boosted_Login")

function boostedlogin.onLogin(player)
        local message = "Every day the list of bonus monsters is always updated, these are today's.\nToday daily creatures are:\n[" .. boostCreature[1].name .. "]\nBonus Exp Rate: " .. boostCreature[1].exp .. "%.\n[".. boostCreature[2].name_loot.."]\nExtra Loot Rate: " .. boostCreature[2].loot .. "%."
        if boostCreature[3] and boostCreature[3].name_boss then
            message = message .. "\n[".. boostCreature[3].name_boss .. "]\nSpecial Loot Rate: ".. boostCreature[3].loot_boss .. "%."
		end
        player:sendTextMessage(MESSAGE_INFO_DESCR, message)
    return true
end

--boostedlogin:register()

------- TALKACTION -------

local exhaust = {}

local boostedmtalk = TalkAction("!boostedcreature")

function boostedmtalk.onSay(player, words, param)

	local playerId = player:getId()
    local currentTime = os.time()
    if exhaust[playerId] and exhaust[playerId] > currentTime then
        player:sendCancelMessage("This command is still on cooldown. (0." .. exhaust[playerId] - currentTime .. "s).")
        return false
    end
	
	local message = "[Boosted Creature]\nEvery day 3 monsters will be chosen, exp, loot and a boss.\nCreature of Today:\n\nMonster Exp: ".. firstToUpper(boostCreature[1].name) ..".\n[+] Bonus Experience: +".. boostCreature[1].exp .."%.\n\nMonster Loot: "..firstToUpper(boostCreature[2].name_loot)..".\n[+] Bonus Loot: +".. boostCreature[1].loot .."%.\n\nMonster Boss: ".. firstToUpper(boostCreature[3].name_boss) ..".\n[+] Bonus Exp: ".. boostCreature[3].exp_boss .."%.\n[+] Special Bonus Loot: ".. boostCreature[3].loot_boss .."%.\n\nThese have been the monsters of the day, check back tomorrow."
	player:popupFYI(message)
	exhaust[playerId] = currentTime + 3
	return false
end

boostedmtalk:register()