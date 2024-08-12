local talkaction = TalkAction("!report")

function talkaction.onSay(player, words, param)
    local storage = 25262421 -- You can change the storage if it's already in use
    local delaytime = 30 -- Exhaust in seconds
    if param == '' then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Please provide a description for the report.\nEx: !report [Text Here].")
        return false
    end
    if player:getStorageValue(storage) <= os.time() then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Your report has been received successfully! An administrator will be waiting.")
        db.query("INSERT INTO `player_reports` (`id`, `name`, `posx`, `posy`, `posz`, `report_description`, `date`) VALUES (NULL, " .. db.escapeString(player:getName()) .. ", '" .. player:getPosition().x .. "', '" .. player:getPosition().y .. "', '" .. player:getPosition().z .. "', " .. db.escapeString(param) .. ", '" .. os.time() .. "')")
        player:setStorageValue(storage, os.time() + delaytime)
    else
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "You have to wait " .. (player:getStorageValue(storage) - os.time()) .. " seconds to report again.")
    end
    return false
end

talkaction:separator(" ")
talkaction:register()
