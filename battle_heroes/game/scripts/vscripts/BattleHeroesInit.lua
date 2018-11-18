REQUIRE_TABLE = 
{
'settings',
"events",
"modifiers/modifier_talents",
-- Util include
["util"] = {
	"funcs",
	"table",
	"math",
	"Teams",
	"keyvalues",
	"triggers",
	"filters",
	"PlayerResource",
	"string",
	},
-- Libraries include
["libraries"] = {
	'physics',
	'notifications',
	'playertables',
	'containers',
	'timers',
	},
}
require("util/functional")
require("util/fun")()
AllPlayersInterval = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23}
BAREBONES_VERSION = "1.00"
BAREBONES_DEBUG_SPEW = false 

if BattleHeroes == nil then
    _G.BattleHeroes = class({})
end

for k,v in pairs(REQUIRE_TABLE) do
	if type(v) == "table" then
		for _,value in pairs(v) do
			require(k .. "/" .. value)
		end 
	else
		require(v)
	end
end
require("modules/index")
require("modifiers/modifiers")
function BattleHeroes:PostLoadPrecache() 
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)
end

function BattleHeroes:OnAllPlayersLoaded()
-- Первая Загрузка всех игроков
end

function BattleHeroes:OnHeroInGame(hero)
end

function BattleHeroes:OnGameInProgress()
	Spawner:RegisterTimers()
end
function BattleHeroes:InitBattleHeroes()
		HeroSelection:PreLoad()
		PlayerTables:CreateTable("player_hero_indexes", {}, AllPlayersInterval)
		PlayerTables:CreateTable("bh", {}, AllPlayersInterval)
		mode = GameRules:GetGameModeEntity()        
		mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
		mode:SetCustomHeroMaxLevel ( MAX_LEVEL )
		mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
		mode:SetAnnouncerDisabled( DISABLE_ANNOUNCER )
		mode:SetFountainConstantManaRegen( FOUNTAIN_CONSTANT_MANA_REGEN )
		mode:SetFountainPercentageHealthRegen( FOUNTAIN_PERCENTAGE_HEALTH_REGEN )
		mode:SetFountainPercentageManaRegen( FOUNTAIN_PERCENTAGE_MANA_REGEN )
		mode:SetLoseGoldOnDeath( LOSE_GOLD_ON_DEATH )
		GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
		GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
		GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
		GameRules:SetPreGameTime( PRE_GAME_TIME + HERO_SELECTION_PICKING_TIME)
		GameRules:SetPostGameTime( POST_GAME_TIME )
		GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
		GameRules:SetGoldPerTick(GOLD_PER_TICK) -- GOLD_PER_TICK
		GameRules:SetGoldTickTime(GOLD_TICK_TIME) -- GOLD_TICK_TIME
		GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
		GameRules:SetHideKillMessageHeaders( HIDE_KILL_BANNERS )
		GameRules:SetCustomGameEndDelay( GAME_END_DELAY )
		GameRules:SetCustomVictoryMessageDuration( VICTORY_MESSAGE_DURATION )
		GameRules:SetStartingGold( STARTING_GOLD )
		GameRules:GetGameModeEntity():SetHudCombatEventsDisabled( true )
		BattleHeroes:StartEvents()
		BattleHeroes:FiltersOn()
		if FORCE_PICKED_HERO ~= nil then
		  mode:SetCustomGameForceHero( FORCE_PICKED_HERO )
		end
		if SKIP_TEAM_SETUP then
			GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
			GameRules:LockCustomGameSetupTeamAssignment( true )
			GameRules:EnableCustomGameSetupAutoLaunch( true )
		else
			GameRules:SetCustomGameSetupAutoLaunchDelay( AUTO_LAUNCH_DELAY )
			GameRules:LockCustomGameSetupTeamAssignment( LOCK_TEAM_SETUP )
			GameRules:EnableCustomGameSetupAutoLaunch( ENABLE_AUTO_LAUNCH )
		end
		
		for team,number in pairs(CUSTOM_TEAM_PLAYER_COUNT) do
				GameRules:SetCustomGameTeamMaxPlayers(team, number)
		end
		
		if USE_CUSTOM_TEAM_COLORS then
			for team,color in pairs(TEAM_COLORS) do
				SetTeamCustomHealthbarColor(team, color[1], color[2], color[3])
			end
		end
		
		self.bSeenWaitForPlayers = false
		self.vUserIds = {}
		for rune, spawn in pairs(ENABLED_RUNES) do
			mode:SetRuneEnabled(rune, spawn)
		end
	if IsCreateHeroMap() then
		local str_table = {}
		local agility_table = {}
		local intellect_table = {} 
		for heroName, abilityKV in pairs( KeyValues.UnitKV ) do
			if heroName:find("npc_dota_hero_") and not heroName:find("dummy") and not heroName:find("base") and not heroName:find("invoker") then
				CustomNetTables:SetTableValue( "abilities", heroName, HeroAbility( heroName ) )
				CustomNetTables:SetTableValue( "talents", heroName, GetHeroTalents( heroName ) )
				if abilityKV["AttributePrimary"] == "DOTA_ATTRIBUTE_STRENGTH" then
					str_table[heroName] = "1"
				elseif abilityKV["AttributePrimary"] == "DOTA_ATTRIBUTE_AGILITY" then
					agility_table[heroName] = "1" 
				elseif abilityKV["AttributePrimary"] == "DOTA_ATTRIBUTE_INTELLECT" then
					intellect_table[heroName] = "1" 
				end
			end				
		end	
		CustomNetTables:SetTableValue( "heroes", "intellect", intellect_table )
		CustomNetTables:SetTableValue( "heroes", "strength", str_table )
		CustomNetTables:SetTableValue( "heroes", "agility", agility_table )
		CustomNetTables:SetTableValue( "heroes", "FullHeroes", FullHeroesName() )
		CustomNetTables:SetTableValue ("GetCostShops", "Cost", GetCostAll())
		for _,Name in pairs(GetAllAbilityName()) do
			if Name:find("special_bonus_") and Name:find(Name:gsub("npc_dota_hero_","")) and KeyValues["AbilityKV"][Name] then
				CustomNetTables:SetTableValue ("abilityKV", Name .. "_KV", KeyValues["AbilityKV"][Name])
			end
		end
	end
end
function BattleHeroes:EndGame( victoryTeam )
	GameRules:SetGameWinner( victoryTeam )
end

function BattleHeroes:OnHeroSelectionStart()
	Spawner:PreloadSpawners()
	Duel:CreateGlobalTimer()
	HeroSelection:Init()
	Timers:CreateTimer(1, function()
		if IsMutation() then
			Mutation:Init()
		end
	end)
	Timers:CreateTimer(5, function()
		Bosses:InitBosses()
	end)
	Gold:Init()
	if KILL_LIMITS.value == 0 then
		KILL_LIMITS.value = 150
		KILL_LIMITS.click = 1
	end
	BattleHeroes:UpdateKillLimit(math.round(KILL_LIMITS.value / KILL_LIMITS.click))
	--CustomNetTables:SetTableValue( "talents_cost", "cost", TALENT_PRICE )
	--CustomNetTables:SetTableValue( "talents", "data", TALENT_DATA_INFO )
	local fountains = Entities:FindAllByClassname( "ent_dota_fountain")
	for _,Fountain in pairs(fountains) do
		Fountain:AddNewModifier( Fountain, Fountain, "modifier_fountain_protect_bh_aura", {duration = -1} )
		Fountain:AddNewModifier( Fountain, Fountain, "modifier_fountain_protect_bh_aura_enemy", {duration = -1} )
	end 
	for _, playerStart in pairs(Entities:FindAllByClassname("info_courier_spawn")) do
		COURIER_TEAM[playerStart:GetTeam()] = CreateUnitByName("npc_dota_courier", playerStart:GetAbsOrigin(), true, nil, nil, playerStart:GetTeam())
	end	
	Timers:CreateTimer(1, function()
		return FountainThink()
	end)
end

function BattleHeroes:UpdateKillLimit(value)
	value = value or math.round(KILL_LIMITS.value / KILL_LIMITS.click) or 150
	local data = 
	{
		limit = value,
	}
	Timers:CreateTimer(0.1, function()
		CustomGameEventManager:Send_ServerToAllClients("update_kill_limit", data)
		self.kill_limit = value
	end)
end


function BattleHeroes:PrecacheUnitQueueed(name)
	if not IS_PRECACHE_PROCESS_RUNNING then
		IS_PRECACHE_PROCESS_RUNNING = true
		PrecacheUnitByNameAsync(name, function()
			IS_PRECACHE_PROCESS_RUNNING = nil
		end)
	else
		Timers:CreateTimer(0.5, function()
			BattleHeroes:PrecacheUnitQueueed(name)
		end)
	end
end