require("modules/shopes/data")

if not AbilityShop then
	AbilityShop = class({})
end

if not TalentShop then
	TalentShop = class({})
end    

function AbilityShop:AddAbilityShop(keys)
	if PlayerResource:HasSelectedHero( keys.playerId ) then
		local hero = PlayerResource:GetSelectedHeroEntity( keys.playerId )
		local abilityName = keys.abilityName
		local hero_points = hero:GetAbilityPoints()
		local cost = keys.abilityCost
		local function buy()
			if hero and keys.enough == 1 and  hero_points >= cost then
				for i = 1, 24 do
					if hero:FindAbilityByName("empty_slot_" .. i) then
						hero:SwapAbility("empty_slot_" .. i,abilityName,1)
						keys["AbilityBuy"] = true
						CustomGameEventManager:Send_ServerToAllClients("UpdateAbilityList", keys)
						CustomGameEventManager:Send_ServerToAllClients("UpdateTalentTable", keys)
						CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.playerId),"UpdateTalentHero", keys)
						hero:SetAbilityPoints(hero_points - cost)
						BattleHeroes:PrecacheUnitQueueed(keys.heroName)
						EmitSoundOn("General.Buy",PlayerResource:GetPlayer(keys.playerId))
						break
					end 
				end 
			else
				Containers:DisplayError(keys.playerId, "#no_buy_ability")
				EmitSoundOn("General.Cancel",PlayerResource:GetPlayer(keys.playerId))
			end
		end
		if not hero:HasAbility(abilityName) then
			--PrecacheUnitByNameAsync(hero:GetHeroName(), PickHero,keys.playerId)
			PrecacheItemByNameAsync(abilityName, buy)
		end
	end
end

function AbilityShop:SellingAbility(keys)
if not (keys.AbilityName or keys.playerId or keys.abilityCost  ) then return end
	local AbilityName = keys.AbilityName
	local playerId = keys.playerId
	local abilityCost = keys.abilityCost
	local hero = PlayerResource:GetSelectedHeroEntity( playerId )
	local position = hero:FindAbilityByName(AbilityName):GetAbilityIndex() + 1
	RemoveAbilityWithModifiers(hero,hero:FindAbilityByName(AbilityName))
	hero:SwapAbility(AbilityName,"empty_slot_" .. position)
	hero:SetAbilityPoints(hero:GetAbilityPoints() + abilityCost)	
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerId),"UpdateTalentHero", keys)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerId),"UpdateAbilityList", keys)
end 

function TalentShop:AddTalentShop(keys)
	if PlayerResource:HasSelectedHero( keys.playerId ) then
		local hero = PlayerResource:GetSelectedHeroEntity( keys.playerId )
		local hero_points = hero:GetAbilityPoints()
		local value = keys.value
		local ability = keys.ability
		local cost = keys.abilityCost
		if not (value or ability or cost) then
			return
		end
		if hero and keys.enough == 1 and  hero_points >= cost then 
			local modifier = "modifier_" .. ability
			local modify = hero:AddNewModifier(hero,nil,modifier,{duration = -1})
			local stackCount = hero:FindModifierByName(modifier):GetStackCount() or 0
			if TALENT_BUY_LIMIT[modifier] and (stackCount + value) >= TALENT_BUY_LIMIT[modifier] then
				Containers:DisplayError(keys.playerId, "#limit_buy_talents")
			else 
				stackCount = stackCount + value
				modify:SetStackCount(stackCount)
				hero:SetAbilityPoints(hero_points - cost)
				keys["TalentBuy"] = true	
				EmitSoundOn("General.Buy",PlayerResource:GetPlayer(keys.playerId))
				--CustomGameEventManager:Send_ServerToAllClients("UpdateTalentTable", keys)
				--CustomGameEventManager:Send_ServerToAllClients("UpdateAbilityList", keys)
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.playerId),"UpdateTalentTable", keys)
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.playerId),"UpdateAbilityList", keys)
			end
		else
			Containers:DisplayError(keys.playerId, "#not_enough_ability_points_talent")
			EmitSoundOn("General.Cancel",PlayerResource:GetPlayer(keys.playerId))
		end
	end
end

function TalentShop:AddTalentHeroShop(keys)
	if PlayerResource:HasSelectedHero( keys.playerId ) then
		local hero = PlayerResource:GetSelectedHeroEntity( keys.playerId )
		local hero_points = hero:GetAbilityPoints()
		local value = keys.value
		local ability = keys.abilityName
		local cost = keys.abilityCost
		if not (value or ability or cost) then
			return
		end
		local function buy()
			if hero and keys.enough == 1 and hero_points >= cost then 	
				EmitSoundOn("General.Buy",PlayerResource:GetPlayer(keys.playerId))
				hero:AddAbility(ability):SetLevel(1)
				BattleHeroes:PrecacheUnitQueueed(keys.heroName)
				hero:SetAbilityPoints(hero_points - cost)
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.playerId),"UpdateTalentHero", keys)
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.playerId),"UpdateAbilityList", keys)
				hero:CalculateStatBonus()
			else
				Containers:DisplayError(keys.playerId, "#not_enough_ability_points_talent")
				EmitSoundOn("General.Cancel",PlayerResource:GetPlayer(keys.playerId))
			end
		end
		if not hero:HasAbility(ability) then
			PrecacheItemByNameAsync(ability, buy)
		end
	end
end

--[[function AbilityShop:AddAbilityShop(keys)
	local hero = PlayerResource:GetSelectedHeroEntity( keys.playerId )
	local abilityName = keys.abilityName
	local cost = keys.abilityCost
	if not (hero or abilityName or cost) then
		return
	end
	if hero and cost and hero:GetAbilityPoints() >= cost then
		local function Buy()
			if IsValidEntity(hero) and hero:GetAbilityPoints() >= cost then
				local abilityh = hero:FindAbilityByName(abilityname)
				if abilityh and not abilityh:IsHidden() then
					if abilityh:GetLevel() < abilityh:GetMaxLevel() then
						hero:SetAbilityPoints(hero:GetAbilityPoints() - cost)
						abilityh:SetLevel(abilityh:GetLevel() + 1)
					end
				elseif hero:HasAbility("ability_empty") then
					if abilityh and abilityh:IsHidden() then
						RemoveAbilityWithModifiers(hero, abilityh)
					end
					hero:SetAbilityPoints(hero:GetAbilityPoints() - cost)
					hero:RemoveAbility("ability_empty")
					GameMode:PrecacheUnitQueueed(abilityInfo.hero)
					local a, linked = hero:AddNewAbility(abilityname)
					a:SetLevel(1)
					if linked then
						for _,v in ipairs(linked) do
							if v:GetAbilityName() == "phoenix_launch_fire_spirit" then
								v:SetLevel(1)
							end
						end
					end
					hero:CalculateStatBonus()
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(PlayerID), "dota_ability_changed", {})
				end
			end
		end
		if hero:HasAbility(abilityname) then
			Buy()
		else
			PrecacheItemByNameAsync(abilityname, Buy)
		end
	end
end]]