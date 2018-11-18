require("data/commands") 
require("data/ability_settings") 
require("data/constants") 
UNIVERSAL_SHOP_MODE = true             
ALLOW_SAME_HERO_SELECTION = true       
HERO_SELECTION_TIME = 30.0             
PRE_GAME_TIME = 55.0                   
POST_GAME_TIME = 60.0                   
TREE_REGROW_TIME = 60.0
GOLD_PER_TICK = 3
GOLD_TICK_TIME = 3
RUNE_SPAWN_TIME = 120
MAX_SLOT_ABILITY = 6
DISABLE_FOG_OF_WAR_ENTIRELY = false           
END_GAME_ON_KILLS = true                
HEROES_ON_DUEL = HEROES_ON_DUEL or {}
USE_CUSTOM_HERO_LEVELS = true           
MAX_LEVEL = 350                                         
USE_CUSTOM_XP_VALUES = true            
XP_PER_LEVEL_TABLE = {}
XP_PER_LEVEL_TABLE[1] = 0
for i = 2, MAX_LEVEL do
  	XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + i * 230
end
HIDE_KILL_BANNERS = true 
LOSE_GOLD_ON_DEATH = true    
DISABLE_ANNOUNCER = false               
FORCE_PICKED_HERO = "npc_dota_hero_target_dummy"                 
FOUNTAIN_CONSTANT_MANA_REGEN = -1      
FOUNTAIN_PERCENTAGE_MANA_REGEN = -1     
FOUNTAIN_PERCENTAGE_HEALTH_REGEN = -1       
GAME_END_DELAY = -1                     
VICTORY_MESSAGE_DURATION = 3
STARTING_GOLD = 650  
DISABLE_DAY_NIGHT_CYCLE = false   
SKIP_TEAM_SETUP = false
ENABLE_AUTO_LAUNCH = true   
AUTO_LAUNCH_DELAY = 30  
LOCK_TEAM_SETUP = false

ENABLED_RUNES = {} 
ENABLED_RUNES[DOTA_RUNE_DOUBLEDAMAGE] = true
ENABLED_RUNES[DOTA_RUNE_HASTE] = true
ENABLED_RUNES[DOTA_RUNE_ILLUSION] = true
ENABLED_RUNES[DOTA_RUNE_INVISIBILITY] = true
ENABLED_RUNES[DOTA_RUNE_REGENERATION] = true
ENABLED_RUNES[DOTA_RUNE_BOUNTY] = true
ENABLED_RUNES[DOTA_RUNE_ARCANE] = true

MAP_LENGTH = 8192

MAX_NUMBER_OF_TEAMS = 2                
USE_CUSTOM_TEAM_COLORS = true           
USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS = false          
TEAM_COLORS = {}
TEAM_COLORS[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }  --    Teal
TEAM_COLORS[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }   --    Yellow
USE_AUTOMATIC_PLAYERS_PER_TEAM = true  
CUSTOM_TEAM_PLAYER_COUNT = {}
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 5
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 5
if not KILL_LIMITS then
	KILL_LIMITS = 
	{
		click = 0,
		value = 0,
	}
end
if not COURIER_TEAM then
	COURIER_TEAM = {}
end 

if not MUTATION_TYPE then
	MUTATION_TYPE = {
		gold_unit = false,
	}
end 
--[[UNITES_DOTA = LoadKeyValues("scripts/npc/npc_units.txt")
OVVERIDE = LoadKeyValues("scripts/npc/npc_abilities_override.txt")
UNITES_CUSTOM = LoadKeyValues("scripts/npc/npc_units_custom.txt")
HEROES_CUSTOM = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
DOTA_HEROES = LoadKeyValues("scripts/npc/npc_heroes.txt")
CUSTOM_ABILITY = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
DOTA_ABILITY = LoadKeyValues("scripts/npc/npc_abilities.txt")
CUSTOM_ITEMS = LoadKeyValues("scripts/npc/npc_items_custom.txt") ]]
DOTA_ITEMS = LoadKeyValues("scripts/npc/items.txt")