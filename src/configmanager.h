/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef FS_CONFIGMANAGER_H_6BDD23BD0B8344F4B7C40E8BE6AF6F39
#define FS_CONFIGMANAGER_H_6BDD23BD0B8344F4B7C40E8BE6AF6F39

#include <utility>
#include <vector>

using ExperienceStages = std::vector<std::tuple<uint32_t, uint32_t, float>>;

class ConfigManager
{
	public:
		enum boolean_config_t {
			ALLOW_CHANGEOUTFIT,
			ONE_PLAYER_ON_ACCOUNT,
			AIMBOT_HOTKEY_ENABLED,
			REMOVE_RUNE_CHARGES,
			REMOVE_WEAPON_AMMO,
			REMOVE_WEAPON_CHARGES,
			REMOVE_POTION_CHARGES,
			EXPERIENCE_FROM_PLAYERS,
			FREE_PREMIUM,
			REPLACE_KICK_ON_LOGIN,
			ALLOW_CLONES,
			ALLOW_WALKTHROUGH,
			BIND_ONLY_GLOBAL_ADDRESS,
			OPTIMIZE_DATABASE,
			EMOTE_SPELLS,
			STAMINA_SYSTEM,
			WARN_UNSAFE_SCRIPTS,
			CONVERT_UNSAFE_SCRIPTS,
			CLASSIC_EQUIPMENT_SLOTS,
			CLASSIC_ATTACK_SPEED,
			SCRIPTS_CONSOLE_LOGS,
			SERVER_SAVE_NOTIFY_MESSAGE,
			SERVER_SAVE_CLEAN_MAP,
			SERVER_SAVE_CLOSE,
			SERVER_SAVE_SHUTDOWN,
			ONLINE_OFFLINE_CHARLIST,
			HOUSE_DOOR_SHOW_PRICE,
			YELL_ALLOW_PREMIUM,
			FORCE_MONSTERTYPE_LOAD,
			SPOOF_ENABLED,
			CLOSED_WORLD,
			REMOVE_ON_DESPAWN,
			PACKET_COMPRESSION,
			PUSH_CRUZADO,
			SORT_LOOT_BY_CHANCE,
			BLOCK_LOGIN,
			SHOW_PACKETS,
			STAMINA_TRAINER,
			STAMINA_PZ,

			LAST_BOOLEAN_CONFIG /* this must be the last one */
		};

		enum string_config_t {
			IP_STRING,
			MAP_NAME,
			HOUSE_RENT_PERIOD,
			SERVER_NAME,
			OWNER_NAME,
			OWNER_EMAIL,
			URL,
			LOCATION,
			MOTD,
			WORLD_TYPE,
			MYSQL_HOST,
			MYSQL_USER,
			MYSQL_PASS,
			MYSQL_DB,
			MYSQL_SOCK,
			DEFAULT_PRIORITY,
			MAP_AUTHOR,
			BLOCK_LOGIN_TEXT,

			LAST_STRING_CONFIG /* this must be the last one */
		};

		enum integer_config_t {
			IP,
			SQL_PORT,
			MAX_PLAYERS,
			PZ_LOCKED,
			DEFAULT_DESPAWNRANGE,
			DEFAULT_DESPAWNRADIUS,
			RATE_EXPERIENCE,
			RATE_SKILL,
			RATE_LOOT,
			RATE_MAGIC,
			RATE_SPAWN,
      		SPAWN_MULTIPLIER,
			HOUSE_PRICE,
			KILLS_TO_RED,
			KILLS_TO_BLACK,
			MAX_MESSAGEBUFFER,
			PROTECTION_LEVEL,
			DEATH_LOSE_PERCENT,
			STATUSQUERY_TIMEOUT,
			FRAG_TIME,
			WHITE_SKULL_TIME,
			GAME_PORT,
			LOGIN_PORT,
			STATUS_PORT,
			STAIRHOP_DELAY,
			EXP_FROM_PLAYERS_LEVEL_RANGE,
			MAX_PACKETS_PER_SECOND,
			PROTECTION_TIME,
			SERVER_SAVE_NOTIFY_DURATION,
			YELL_MINIMUM_LEVEL,
			SPOOF_DAILY_MIN_PLAYERS,
			SPOOF_DAILY_MAX_PLAYERS,
			SPOOF_NOISE_INTERVAL,
			SPOOF_TIMEZONE,
			SPOOF_NOISE,
			SPOOF_INTERVAL,
			SPOOF_CHANGE_CHANCE,
			SPOOF_INCREMENT_CHANCE,
			STAMINA_REGEN_MINUTE,
			STAMINA_REGEN_PREMIUM,
			STAMINA_PZ_GAIN,
			STAMINA_ORANGE_DELAY,
			STAMINA_GREEN_DELAY,
			STAMINA_TRAINER_DELAY,
			STAMINA_TRAINER_GAIN,

			LAST_INTEGER_CONFIG /* this must be the last one */
		};

		enum floating_config_t {
			RATE_SPELL_COOLDOWN,
			MLVL_BONUSDMG,
			MLVL_BONUSSPEED,
			MLVL_BONUSHP,

			LAST_FLOATING_CONFIG
		};

		bool load();
		bool reload();

		const std::string& getString(string_config_t what) const;
		int32_t getNumber(integer_config_t what) const;
		bool getBoolean(boolean_config_t what) const;
		float getExperienceStage(uint32_t level) const;
		float getFloat(floating_config_t what) const;

	private:
		std::string string[LAST_STRING_CONFIG] = {};
		int32_t integer[LAST_INTEGER_CONFIG] = {};
		bool boolean[LAST_BOOLEAN_CONFIG] = {};
		float floating[LAST_FLOATING_CONFIG] = {};

		ExperienceStages expStages = {};

		bool loaded = false;
};

#endif
