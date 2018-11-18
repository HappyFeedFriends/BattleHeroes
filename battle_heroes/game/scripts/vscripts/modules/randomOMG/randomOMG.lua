
if not RandomOMG then
	RandomOMG = class({})
end
ModuleRequire(...,"data")
local MAX_ABILITIES_OMG = 6
local MAX_ULTIMATES = 2


function RandomOMG:Init(SpawnedUnit)
	PLAYER_DATA[SpawnedUnit:GetPlayerID()].max_ultimate = 0
	--[[if not SpawnedUnit.FirstSpawn then
		RandomOMG:SetRandomAttributes(SpawnedUnit)
	end]] 
	RandomOMG:RandomSwapAbilities(SpawnedUnit)
end

function RandomOMG:SetRandomAttributes(SpawnedUnit)
	local str = SpawnedUnit:GetStrength()
	local agi = SpawnedUnit:GetAgility()
	local int = SpawnedUnit:GetIntellect()
	SpawnedUnit:ModifyAgility(-agi)
	SpawnedUnit:ModifyStrength(-str)
	SpawnedUnit:ModifyIntellect(-int)
	print("OLD ATTRIBUTES:")
	print("STRENGTH:",str)
	print("AGILITY:",agi)
	print("INTELLECT:",int)
	SpawnedUnit:ModifyAgility(RandomInt(10,45))
	SpawnedUnit:ModifyStrength(RandomInt(10,45))
	SpawnedUnit:ModifyIntellect(RandomInt(10,45))
end 

function RandomOMG:RandomSwapAbilities(SpawnedUnit)
	RandomOMG:RemoveAllAbility(SpawnedUnit)
	RandomOMG:AddRandomAbility(SpawnedUnit)
end

function RandomOMG:RemoveAllAbility(SpawnedUnit)
	SpawnedUnit.ability_lvl = {}
	for i=0,SpawnedUnit:GetAbilityCount() - 1 do
        local ability = SpawnedUnit:GetAbilityByIndex(i)
		if ability then
			table.insert(SpawnedUnit.ability_lvl,ability:GetLevel())
			RemoveAbilityWithModifiers(SpawnedUnit, ability)
			SpawnedUnit:RemoveAbility(ability:GetName())
		end
    end
end

function RandomOMG:AddRandomAbility(SpawnedUnit)
	local list = {}
	local ability
	local table_levels = SpawnedUnit.ability_lvl
	for i = 1,MAX_ABILITIES_OMG do
		local lvl = table_levels[i] or 0
		ability = RandomOMG:PickRandomAbility(SpawnedUnit)
		if GetKeyValue(ability, "AbilityType") and RandomOMG:IsUltimate(ability) and RandomOMG:GetCountUltimates(SpawnedUnit) >= MAX_ULTIMATES then
			while RandomOMG:IsUltimate(ability) do
				ability = RandomOMG:PickRandomAbility(SpawnedUnit)
			end
		elseif i > (MAX_ABILITIES_OMG - MAX_ULTIMATES) and RandomOMG:GetCountUltimates(SpawnedUnit) < MAX_ULTIMATES then
			ability = RandomOMG:PickRandomUltimates(SpawnedUnit)
		end
		SpawnedUnit:AddAbility(ability):SetLevel(lvl) 
		RemoveAbilityWithModifiers(SpawnedUnit, SpawnedUnit:FindAbilityByName(ability)) 
		if RandomOMG:IsUltimate(ability) then
			PLAYER_DATA[SpawnedUnit:GetPlayerID()].max_ultimate = RandomOMG:GetCountUltimates(SpawnedUnit) + 1
		end
	end
end

function RandomOMG:PickRandomAbility(SpawnedUnit)
	local Abilities = self:AllAbilityHeroes()
	local ability
	while true do
		ability = PickRandomValueTable(Abilities)
		if not ability:find("special_bonus_") 
		and not NO_DROP_ABILITY_OMG[ability]
		and not ability:find("empty") 
		and not ability:find("dummy") 
		and not ability:find("containers")
		and not ability:find("courier")
		and not ability:find("spell_steal")
		and not ability:find("roshan")
		and not ability:find("healing_campfire")
		and not ability:find("tornado_tempest")
		and not ability:find("cny2015")
		and not ability:find("dragon_knight_")
		and not ability:find("default")
		and not ability:find("ability_base")
		and not ability:find("unrefined")
		and not ability:find("morphling_morph_")
		and not ability:find("chakram")
		and not ability:find("invoker")
		and not SpawnedUnit:FindAbilityByName(ability) 
		and not AbilityHasBehaviorByName(ability, "DOTA_ABILITY_BEHAVIOR_HIDDEN")
		and not AbilityHasBehaviorByName(ability, "DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE")
		and GetKeyValue(AbilityName, "IsGrantedByScepter") ~= "1" then
			return ability
		end
	end 
end 

function RandomOMG:PickRandomUltimates(SpawnedUnit)
	local Abilities = self:AllAbilityHeroes()
	local ability
	while true do
		ability = PickRandomValueTable(Abilities)
		if not SpawnedUnit:FindAbilityByName(ability)
		and not NO_DROP_ABILITY_OMG[ability]
		and not AbilityHasBehaviorByName(ability, "DOTA_ABILITY_BEHAVIOR_HIDDEN")
		and not AbilityHasBehaviorByName(ability, "DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE")
		and RandomOMG:IsUltimate(ability)  then
			return ability
		end
	end 
end

function RandomOMG:AllAbilityHeroes()
	if RandomOMG.HeroesAbility then return RandomOMG.HeroesAbility end
	RandomOMG.HeroesAbility = {}
	local full = KeyValues.UnitKV
	for i,hero in pairs(GetAllHeroesNames()) do
		for i = 1,24 do
			if full[hero]["Ability" .. i] and not full[hero]["Ability" .. i]:find("special_bonus_") and full[hero]["Ability" .. i] ~= "generic_hidden" then
				table.insert(RandomOMG.HeroesAbility, full[hero]["Ability" .. i])
			end
		end 
	end 
	return RandomOMG.HeroesAbility
end

function RandomOMG:GetCountUltimates(SpawnedUnit)
	return PLAYER_DATA[SpawnedUnit:GetPlayerID()].max_ultimate or 0
end

function RandomOMG:IsUltimate(AbilityName)
	return GetKeyValue(AbilityName, "AbilityType") == "DOTA_ABILITY_TYPE_ULTIMATE"
end