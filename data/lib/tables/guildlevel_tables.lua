GuildLevel = {
	level_experience = {
		[1] = {exp = 0, loot = 0, expMin = 0, expMax = 50}, -- Level 1
		[2] = {exp = 10, loot = 5, expMin = 51, expMax = 230}, -- Level 2
		[3] = {exp = 12, loot = 7, expMin = 231, expMax = 350}, -- Level 3
		[4] = {exp = 14, loot = 9, expMin = 351, expMax = 480}, -- Level 4
		[5] = {exp = 17, loot = 12, expMin = 481, expMax = 650}, -- Level 5
		[6] = {exp = 22, loot = 14, expMin = 651, expMax = 780}, -- Level 6
		[7] = {exp = 26, loot = 16, expMin = 781, expMax = 840}, -- Level 7
		[8] = {exp = 30, loot = 22, expMin = 841, expMax = 940}, -- Level 8
		[9] = {exp = 34, loot = 28, expMin = 941, expMax = 999}, -- Level 9
		[10] = {exp = 40, loot = 35, expMin = 1000, expMax = math.huge}, -- Level 10
	},
	minLevelBonus = 1, -- Minimum level you must have to receive points.
	antimc = false, -- Let him get points by killing his mcs?
	text = "You added [%d] of Experience to your guild for kill [%s].", -- Message for Default when Kill.
	text_dead = "Has died for [%s], therefore [%d] of Experience has been removed for the guild.", -- Message when Dead.
	text_dead_guild = "The player [%s] has died and because of that guild has lost [%d] of Experience.", -- Message when Dead Guild
	text_guild = "The player [%s] has added [%d] of Experience for kill [%s].", -- Message for Guild when Kill.
	text_level = "The guild has leveled up is now: [%d].", -- Level Up Guild
	text_level_lower = "The guild has been reduced in level now it is: [%d]." -- Level Lost Guild
}
