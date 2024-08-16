local CHANNEL_HELP = 9

local globalevent = GlobalEvent("channelmessage")

function globalevent.onThink(interval)
    sendChannelMessage(CHANNEL_HELP, TALKTYPE_CHANNEL_R1, "[ChatGPT] Aster: Keep in mind that you have me, an automatic bot that responds and helps with any questions. You can ask about trainers, stamina, items, cities, or other topics. Don't hesitate to ask. Good luck!")
    return true
end

globalevent:interval(20 * 60 * 1000) -- 20 min
globalevent:register()