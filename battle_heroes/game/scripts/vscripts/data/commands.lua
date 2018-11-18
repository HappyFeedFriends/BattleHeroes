
USUAL_ACCESS = 1
CHEAT_LOBBY_ACCESS = 2
DEV_ACCESS = 3

CHAT_COMMANDS =
{
	["GOLD"] = 
	{
		ACCESS = CHEAT_LOBBY_ACCESS,
		funcs = function(args,PlayerId)
			--CommandsGold(PlayerId,tonumber(args)) 
			Gold:AddGold(PlayerId, tonumber(args))
		end
	},
	
	["LVLHERO"] = 
	{
		ACCESS = CHEAT_LOBBY_ACCESS,
		funcs = function(args, PlayerId)
			CommandsLevel(PlayerResource:GetSelectedHeroEntity(PlayerId),tonumber(args)) 
		end
	},
	["GIVEITEMS"] = 
	{
		ACCESS = CHEAT_LOBBY_ACCESS,
		funcs = function(args, PlayerId)
			CommandsGiveItems(args,PlayerResource:GetSelectedHeroEntity(PlayerId)) 
		end
	},	
	["CREATECREEP"] = 
	{
		ACCESS = CHEAT_LOBBY_ACCESS,
		funcs = function(args, PlayerId)
			CommandsCreateCreep(args,PlayerResource:GetSelectedHeroEntity(PlayerId)) 
		end
	},	
	["STATS"] = 
	{
		ACCESS = CHEAT_LOBBY_ACCESS,
		funcs = function(args, PlayerId)
			CommandsModifyStats(tonumber(args),PlayerResource:GetSelectedHeroEntity(PlayerId))
		end
	},	
	["END"] = 
	{
		ACCESS = CHEAT_LOBBY_ACCESS,
		funcs = function(args, PlayerId)
			if PlayerResource:GetSelectedHeroEntity(PlayerId):GetTeam() then
				BattleHeroes:EndGame( PlayerResource:GetSelectedHeroEntity(PlayerId):GetTeam() )
			end
		end
	},	
	["CREATEHEROES"] = 
	{
		ACCESS = CHEAT_LOBBY_ACCESS,
		funcs = function(args, PlayerId)
			CommandsCreateHero(PlayerResource:GetSelectedHeroEntity(PlayerId))
		end
	},	
	["DUEL"] = 
	{
		ACCESS = DEV_ACCESS,
		funcs = function(args, PlayerId)
			Duel:CreateGlobalTimer()
		end
	},	
	["BOSSES"] = 
	{
		ACCESS = DEV_ACCESS,
		funcs = function(args, PlayerId)
			Bosses:InitBosses()
		end
	},	
	["TEST"] = 
	{
		ACCESS = DEV_ACCESS,
		funcs = function(args, PlayerId)
			GameRules:GetGameModeEntity():SetHudCombatEventsDisabled( true )
		end
	},	
	["SWAPHERO"] = 
	{
		ACCESS = DEV_ACCESS,
		funcs = function(args, PlayerId)
			for k,v in pairs(KeyValues.UnitKV) do
				if k:find("npc_dota_hero_") and not k:find("dummy") and not k:find("base") and string.find(k,args) then
					CommandsSwapHero(PlayerId, k)
					break
				end	
			end
		end
	},	
	["SWAPALLPLAYER"] = 
	{
		ACCESS = DEV_ACCESS,
		funcs = function(args, PlayerId)
			for k,v in pairs(KeyValues.UnitKV) do
				if k:find("npc_dota_hero_") and not k:find("dummy") and not k:find("base") and string.find(k,args) then
					for i = 0, DOTA_MAX_PLAYERS - 1 do
						if PlayerResource:IsValidPlayerID(i) and not IsPlayerAbandoned(i) then
							CommandsSwapHero(i, k)
						end
					end
					break
				end	
			end
		end
	},	
	["SWAPTEAMPLAYERS"] = 
	{
		ACCESS = DEV_ACCESS,
		funcs = function(args, PlayerId)
			for k,v in pairs(KeyValues.UnitKV) do
				if k:find("npc_dota_hero_") and not k:find("dummy") and not k:find("base") and string.find(k,args) then
					for i = 0, DOTA_MAX_PLAYERS - 1 do
						if PlayerResource:IsValidPlayerID(i) and not IsPlayerAbandoned(i) and PlayerResource:GetTeam(i) == PlayerResource:GetTeam(PlayerId) then
							CommandsSwapHero(i, k)
						end
					end
					break
				end	
			end
		end
	},	
	["STACK"] = 
	{
		ACCESS = CHEAT_LOBBY_ACCESS,
		funcs = function(args, PlayerId)
			Spawner:SpawnStacks()
		end
	},	
	["SETKILLS"] = 
	{
		ACCESS = DEV_ACCESS,
		funcs = function(args, PlayerId)
			BattleHeroes:UpdateKillLimit(args)
		end
	},		
	["CATACLYSM"] = 
	{
		ACCESS = DEV_ACCESS,
		funcs = function(args, PlayerId)
			if args == "0" then
				Mutation.sunstrike_end_time = 0
			else
				Mutation:SunStrikes()
			end
		end
	},	
	["MUTATION"] = 
	{
		ACCESS = DEV_ACCESS,
		funcs = function(args, PlayerId)
			Mutation:Init()
		end
	},	
}