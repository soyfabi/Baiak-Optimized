local boots = {
    [6530] = {id = 6529, money = 100000},
}

local testAction = Action() -- this is our header, the first thing we have to write (except for configuration tables and such)

function testAction.onUse(player, item, fromPosition, target, toPosition, isHotkey) -- now we can design the action itself
    if boots[item.itemid] then
        if player:removeMoney(boots[item.itemid].money) then
            item:transform(boots[item.itemid].id)
            fromPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have successfully repaired your boots.")
        else
            player:sendCancelMessage("You don't have enough money, you need [100K].")
        end
    end
    return true
end

for index, _ in pairs(boots) do
    testAction:id(index)
end

testAction:register()