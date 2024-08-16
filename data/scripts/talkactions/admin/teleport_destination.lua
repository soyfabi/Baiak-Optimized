local config = {
	["event"] = Position(25000, 25000, 4),
	["falcon"] = Position(33363, 31349, 7),
	["thais"] = Position(32369, 32234, 7),
	["venore"] = Position(32957, 32076, 7),
}

local talk = TalkAction("!teleport")

function talk.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	local destinationKey = param:lower()
	local destination = config[destinationKey]
	
	if destination then
		player:teleportTo(destination)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		local availableDestinations = table.concat(table.keys(config), ", ")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Invalid destination. Available destinations: " .. availableDestinations .. ".")
	end
	
    return false
end

function table.keys(t)
    local keys = {}
    for k, _ in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

talk:separator(" ")
talk:register()
