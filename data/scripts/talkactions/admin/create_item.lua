local invalidIds = {
	1, 2, 3, 4, 5, 6, 7, 10, 11, 13, 14, 15, 19, 21, 26, 27, 28, 35, 43
}

local createItem = TalkAction("/i")

function createItem.onSay(player, words, param)
	--[[if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end]]

	-- Split parameters by comma
	local split = param:split(",")

	-- Extract item name or id
	local itemIdentifier = split[1]:trim()

	-- Extract count and tier if they exist
	local count = nil
	local tier = nil

	if #split > 1 then
		count = tonumber(split[2]:trim())
	end

	if #split > 2 then
		local tierParam = split[3]:trim()
		if tierParam:match("tier%s*(%d+)") then
			tier = tonumber(tierParam:match("tier%s*(%d+)"))
		end
	end

	local itemType = ItemType(itemIdentifier)
	if itemType:getId() == 0 then
		itemType = ItemType(tonumber(itemIdentifier))
		if itemType:getId() == 0 then
			player:sendCancelMessage("There is no item with that id or name.")
			return false
		end
	end

	if table.contains(invalidIds, itemType:getId()) then
		player:sendCancelMessage("This item ID is not allowed.")
		return false
	end

	local charges = itemType:getCharges()
	if not itemType then
		player:sendCancelMessage("Unable to create item.")
		return false
	end

	-- Handle count default
	if count == nil then
		if not itemType:isFluidContainer() then
			if charges > 0 then
				player:addItem(itemType:getId(), 0)
				return false
			else
				count = 1
			end
		else
			count = 0
		end
	else
		if itemType:isStackable() then
			count = math.min(10000, math.max(1, count))
		elseif not itemType:isFluidContainer() then
			local min = 100
			if charges > 0 then
				min = charges
			end
			count = math.min(min, math.max(1, count))
		else
			count = math.max(0, count)
		end
	end

	local result
	if not tier then
		result = player:addItem(itemType:getId(), count)
	else
		if tier <= 0 or tier > 10 then
			player:sendCancelMessage("Invalid tier count.")
			return false
		else 
			result = player:addItem(itemType:getId(), count, true, 0, CONST_SLOT_WHEREEVER)
			if type(result) == "table" then
				for _, item in ipairs(result) do
					item:setAttribute(ITEM_ATTRIBUTE_TIER, tier)
					if not item:isStackable() then
						item:decay()
					end
				end
			else
				result:setAttribute(ITEM_ATTRIBUTE_TIER, tier)
				if not result:isStackable() then
					result:decay()
				end
			end
		end
	end

	if result then
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end
	return false
end

createItem:separator(" ")
createItem:register()