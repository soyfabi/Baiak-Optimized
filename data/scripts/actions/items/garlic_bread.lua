local garlicBread = Action()
local BloodBrothers = Storage.Quest.U8_4.BloodBrothers
function garlicBread.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 8194 and player:getStorageValue(BloodBrothers.GarlicBread) == 0 then
		player:setStorageValue(BloodBrothers.GarlicBread, 1)
	end
	player:say("After taking a small bite you decide that you don't want to eat that.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	item:remove(1)
	return true
end

garlicBread:id(8194)
garlicBread:register()