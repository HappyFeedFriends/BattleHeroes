function BattleHeroes:StartEvents()
	ListenToGameEvent('entity_killed', Dynamic_Wrap(self, 'OnEntityKilled'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(self, 'OnConnectFull'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(self, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(self, 'OnNPCSpawned'), self)
	ListenToGameEvent('player_chat', Dynamic_Wrap(self, 'OnPlayerChat'), self)
	ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(self, 'OnRunePickUp'), self)
	CustomGameEventManager:RegisterListener("AddAbilityShop", Dynamic_Wrap(AbilityShop, 'AddAbilityShop'))
	CustomGameEventManager:RegisterListener("SellingAbility", Dynamic_Wrap(AbilityShop, 'SellingAbility'))
  --CustomGameEventManager:RegisterListener("AddTalentShop", Dynamic_Wrap(TalentShop, 'AddTalentShop'))
	CustomGameEventManager:RegisterListener("AddTalentHeroShop", Dynamic_Wrap(TalentShop, 'AddTalentHeroShop'))
	CustomGameEventManager:RegisterListener("KillScoreSelection", Dynamic_Wrap(self, 'KillScoreSelection'))
	ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(self, 'OnTeamKillCredit'), self)
	ListenToGameEvent("dota_rune_pickup", Dynamic_Wrap(self, 'On_dota_rune_pickup'),self)
	CustomGameEventManager:RegisterListener("PickedHero", Dynamic_Wrap(HeroSelection, 'PickedHero'))
	CustomGameEventManager:RegisterListener("SetHeroPicked", Dynamic_Wrap(HeroSelection, 'SetHeroPicked'))
end

function BattleHeroes:OnRunePickUp(keys)
		local player = PlayerResource:GetPlayer(keys.PlayerID)
		local hero = player:GetAssignedHero()
		local data = 
		{
			type = "generic",
			player = keys.PlayerID,
			text = "#custom_toast_rune_up",
			runeType = keys.rune,
		}
		for i=0, 5 do
			local current_item = hero:GetItemInSlot(i)
			if current_item and current_item:GetAbilityName():find("item_bottle") then
				data.text = "#custom_toast_bottle_use"
				break
			end
		end
		if IsMutation() then
			if Mutation_active["UPGRADE_RUNE"] then
				local modifier,dur = unpack(PickRandomValueTable(MUTATION_SETTINGS["UPGRADE_RUNE"].BONUS_EFFECTS))
				hero:AddNewModifier(hero,hero,modifier,{duration = dur})
			end
		end
		CustomGameEventManager:Send_ServerToTeam(hero:GetTeamNumber(),"create_custom_toast",data)
end 
function BattleHeroes:OnGameRulesStateChange(keys)
  local newState = GameRules:State_Get()	
  	if newState == DOTA_GAMERULES_STATE_TEAM_SHOWCASE  then 
		for i = 0, 23 do
           -- local hPlayer = PlayerResource:GetPlayer(i)
           -- if PlayerResource:IsValidPlayerID(i) and hPlayer and not PlayerResource:HasSelectedHero(i) then
           --    hPlayer:MakeRandomHeroSelection()
           -- end
        end
    end
	if newState == DOTA_GAMERULES_STATE_PRE_GAME then
		BattleHeroes:OnHeroSelectionStart()
	end
	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		BattleHeroes:OnGameInProgress()
	end
end

function BattleHeroes:OnNPCSpawned(keys)
local SpawnedUnit = EntIndexToHScript(keys.entindex)
	if SpawnedUnit:IsRealHero() then
		if IsRandomOMGMap() then
			RandomOMG:Init(SpawnedUnit)
		end
		if  SpawnedUnit.FirstSpawn == nil then
			SpawnedUnit.FirstSpawn = true
			if IsCreateHeroMap() then
				SpawnedUnit:RemoveAllAbility()
			end
			Timers:CreateTimer(2, function()
				if IsMutation() and Mutation_active["MAX_SPEED"] then
					SpawnedUnit:AddNewModifier(nil,nil,"modifier_max_speed_mutation_bh",{duration = -1})
				end 
			end)
			if not SpawnedUnit:HasModifier("modifier_custom_mechanics") then
				SpawnedUnit:AddNewModifier(nil,nil,"modifier_custom_mechanics",{duration = -1})
			end 
			Timers:CreateTimer(0.8, function()
				COURIER_TEAM[SpawnedUnit:GetTeamNumber()]:SetControllableByPlayer(SpawnedUnit:GetPlayerID(), true)
			end)
		end 
		Timers:CreateTimer(0.1, function()
			if SpawnedUnit:HasModifier("modifier_silencer_int_steal") then
					SpawnedUnit:RemoveModifierByName("modifier_silencer_int_steal")
			end
		end)
		if Duel:IsDuelOngoing() and not SpawnedUnit:IsReincarnating() then
			Duel:SetUpVisitor(SpawnedUnit)
		end 
	end 
end

function BattleHeroes:OnEntityKilled( keys )
local killedUnit = EntIndexToHScript( keys.entindex_killed )
local killerEntity
local killerAbility
local damagebits = keys.damagebits
	if keys.entindex_attacker ~= nil then killerEntity = EntIndexToHScript( keys.entindex_attacker ) end
	if keys.entindex_inflictor ~= nil then killerAbility = EntIndexToHScript( keys.entindex_inflictor ) end
	
	if killedUnit:IsRealHero() then
		killedUnit:SetRespawnTime()
		if IsMutation() and killerEntity  then
			if Mutation_active["HEALING_KILL"] then
				local healing = killedUnit:GetMaxHealth()/100 * MUTATION_SETTINGS["HEALING_KILL"].heal
				killerEntity:Healing(healing)
			end
			if Mutation_active["KILLED_BONUS_STATS"] then
				local reduction = MUTATION_SETTINGS["KILLED_BONUS_STATS"].reduction_stats
				local bonus = MUTATION_SETTINGS["KILLED_BONUS_STATS"].bonus_stats
				local modifyKilled = 	killedUnit:GetPrimaryAttribute() == 0 and killedUnit:ModifyStrength(-reduction) or  killedUnit:GetPrimaryAttribute() == 1 and killedUnit:ModifyAgility(-reduction) or killedUnit:GetPrimaryAttribute() == 2 and killedUnit:ModifyIntellect(-reduction)
				local modifyKiller =  killerEntity:GetPrimaryAttribute() == 0 and killerEntity:ModifyStrength(bonus) or killerEntity:GetPrimaryAttribute() == 1 and killerEntity:ModifyAgility(bonus) or killerEntity:GetPrimaryAttribute() == 2 and killerEntity:ModifyIntellect(bonus)
			end 
		end
		if killedUnit.OnDuel and not killedUnit:IsReincarnating() then
			killedUnit:SetTimeUntilRespawn( 1 )
			killedUnit.ArenaBeforeTpLocation = nil
			killedUnit.OnDuel = false
			Duel:EndIfFinished()
		end
		if killerEntity then
			kills:OnEntityKilled(killerEntity,killedUnit)
		end
	end
	if killedUnit:IsCreep() and killerEntity then
		local gold = killedUnit:GetGoldBounty() or 0
		if IsMutation() then
			if Mutation_active["BONUS_GOLD_CREEP"] then
				gold = gold + MUTATION_SETTINGS["BONUS_GOLD_CREEP"].gold
			end
		end 
		if killerEntity:GetModifierBonusGoldCreep() and killerEntity:GetModifierBonusGoldCreep() > 0 then
			gold = gold + killerEntity:GetModifierBonusGoldCreep()
		end	
		if gold > 0 then
			GameRules:GetGameModeEntity():SetGoldSoundDisabled(false)
			Gold:AddGoldWithMessage(killerEntity, gold)
			GameRules:GetGameModeEntity():SetGoldSoundDisabled(true)
		end 
		if killerEntity:GetModifierBonusXPCreep() and killerEntity:GetModifierBonusXPCreep() > 0 then
			local xp = killerEntity:GetModifierBonusXPCreep()
			killerEntity:AddExperience( xp,0,false,false )
		end
	end 
	if killerEntity and killedUnit:IsCourier() then
		kills:OnEntityKilled(killerEntity,killedUnit)
	end
	if killedUnit:IsRealCreep() then
		Spawner:OnCreepDeath(killedUnit)
	end
	if killedUnit:IsBoss() then
		Bosses:KilledBoss(killedUnit,killerEntity)
	end 
	if PlayerResource:GetTeamKills(killerEntity:GetTeam()) >= tonumber(self.kill_limit) then
		Timers:CreateTimer(1.2, function()
			BattleHeroes:EndGame( killerEntity:GetTeam() )
		end)
	end
	
end

function BattleHeroes:OnItemPickedUp(keys)
  local unitEntity = nil
  if keys.UnitEntitIndex then
    unitEntity = EntIndexToHScript(keys.UnitEntitIndex)
  elseif keys.HeroEntityIndex then
    unitEntity = EntIndexToHScript(keys.HeroEntityIndex)
  end
  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname
end

function BattleHeroes:OnConnectFull(keys)
  local entIndex = keys.index + 1
  local ply = EntIndexToHScript(entIndex)
  local playerID = ply:GetPlayerID()
end

function BattleHeroes:OnTeamKillCredit(keys)
	local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
	local killedUnit = victimPlayer:GetAssignedHero()
	local killedPlayerID = victimPlayer:GetPlayerID()
	local killerEntity
	local killerPlayerID
	if killerPlayer then
		killerEntity = killerPlayer:GetAssignedHero()
		if killerEntity.GetPlayerID then
			killerPlayerID = killerEntity:GetPlayerID()
		elseif killerEntity.GetPlayerOwnerID then
			killerPlayerID = killerEntity:GetPlayerOwnerID()
		end
	end
end
function BattleHeroes:OnPlayerChat(keys)
	local text = keys.text
	local ID = keys.userid
	local PlayerId = keys.playerid
	if PlayerId and PlayerId >= 0 then
		local teamOnly = keys.teamonly
		local SteamdID = PlayerResource:GetSteamAccountID(PlayerId)
		local player = PlayerResource:GetPlayer(PlayerId)
		local playerName = PlayerResource:GetPlayerName(PlayerId)
		local hero = player:GetAssignedHero()
		local team = PlayerResource:GetTeam(PlayerId)
		local hero_table = PlayerResource:GetSelectedHeroEntity(PlayerId)	
		local commands = {}
		for v in string.gmatch(string.sub(text, 2), "%S+") do 
			table.insert(commands, v) 
		end		
		local command = table.remove(commands, 1)
		local prob =  text:find(" ") or 0
		local numbers = string.sub(text, prob+1)
		local cmd =  CHAT_COMMANDS[command:upper()]	
		if cmd and cmd.ACCESS <= GetAccesCheatsPlayer(PlayerId) then
			cmd.funcs(numbers,PlayerId)
		end 
	end
end
function BattleHeroes:KillScoreSelection(data)
	local value = data.Value
	local ID = data.PlayerID
	KILL_LIMITS.value = KILL_LIMITS.value + value
	KILL_LIMITS.click = KILL_LIMITS.click + 1
end