local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:openMarket()
	return true
end

action:id(12903)
action:register()
