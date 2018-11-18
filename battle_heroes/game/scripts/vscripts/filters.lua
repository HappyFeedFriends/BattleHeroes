function BattleHeroes:FiltersOn()
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(BattleHeroes, 'ExecuteOrderFilter'), self )
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(BattleHeroes, 'DamageFilter'), self)
	GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(BattleHeroes, 'ModifyGoldFilter'), self)
	--GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(BattleHeroes, 'ModifyModifierFilter'), self)
end

function BattleHeroes:ModifyGoldFilter(filterTable)
	if ( filterTable.reason_const >= DOTA_ModifyGold_HeroKill and filterTable.reason_const <= DOTA_ModifyGold_CourierKill ) or filterTable.reason_const == DOTA_ModifyGold_CheatCommand then
		filterTable.gold = 0
		return false
	end
	return true
end

function BattleHeroes:ModifyModifierFilter(filterTable)
local name = filterTable.name_const
local duration = filterTable.duration
local parent,caster
if filterTable.entindex_parent_const then parent = EntIndexToHScript(filterTable.entindex_parent_const) end
if filterTable.entindex_caster_const then caster = EntIndexToHScript(filterTable.entindex_caster_const) end
	if name == "modifier_silencer_int_steal" then
		return false
	end 
	return true
end
local function FindShop(vector)
	local trigger = Entities:FindAllByClassname("trigger_shop")
	local box = {}
	local origin
	for k,v in pairs(trigger) do
		origin = v:GetAbsOrigin()
		box[k] = {
		origin + v:GetBoundingMins(),
		origin + v:GetBoundingMaxs(),
		}
	end 
	--[[for i=1,#box do
		if IsInBox(vector, box[i][1], box[i][2]) then
			return IsInBox(vector, box[i][1], box[i][2])
		end 
	end ]]
	return IsInBox(vector, box[1][1], box[1][2]) or IsInBox(vector, box[2][1], box[2][2])
end 
function BattleHeroes:ExecuteOrderFilter(filterTable)
	local order_type = filterTable.order_type
	local unit = EntIndexToHScript(filterTable.units["0"])
	local playerId = filterTable.issuer_player_id_const
	local target = EntIndexToHScript(filterTable.entindex_target)
	local ability = EntIndexToHScript(filterTable.entindex_ability)
	local abilityname
	if ability and ability.GetAbilityName then
		abilityname = ability:GetAbilityName()
	end
	if order_type == DOTA_UNIT_ORDER_CAST_POSITION then
		local orderVector = Vector(filterTable.position_x, filterTable.position_y, 0)
		if not Duel:IsDuelOngoing() then
			if Duel:IsOnDuel(orderVector) then
				Containers:DisplayError(playerId, "#duel_error_use")
				return false
			end
		elseif not Duel:IsOnDuel(orderVector) then
			Containers:DisplayError(playerId, "#duel_error_uses")
			return false
		end
	elseif order_type == DOTA_UNIT_ORDER_CAST_TARGET and IsValidEntity(target) then
		if target:IsBoss() and abilityname and FindStringTable(abilityname,LOCKED_USE_ABILITY) then
			Containers:DisplayError(playerId, "#no_used_bosses")
			return false
		end 
		if target:GetUnitName():find("hard") and  FindStringTable(abilityname,LOCKED_USE_ABILITY) then
			Containers:DisplayError(playerId, "#no_used_hard_neutrals")
			return false 
		end
	end
	return true
end

function BattleHeroes:DamageFilter(filterDamage)
		local attacker
		if filterDamage.entindex_attacker_const then
			attacker = EntIndexToHScript(filterDamage.entindex_attacker_const)
		else
			return true
		end
		local ability,abilityName
		local victim = EntIndexToHScript(filterDamage.entindex_victim_const)
		if filterDamage.entindex_inflictor_const then
			ability = EntIndexToHScript(filterDamage.entindex_inflictor_const )
			if ability:GetAbilityName() then
				abilityName = ability:GetAbilityName()
			end
		end
		local TYPE = filterDamage.damagetype_const
		if ability and IsMutation() and TYPE >= DAMAGE_TYPE_PHYSICAL and  TYPE <= DAMAGE_TYPE_MAGICAL  and filterDamage.damage > 0 and Mutation_active["ABILITY_PURE_DAMAGE"] then
			ApplyDamage{
				victim = victim,
				attacker = attacker,
				damage = filterDamage.damage/100 * MUTATION_SETTINGS["ABILITY_PURE_DAMAGE"].damage ,
				damage_type = DAMAGE_TYPE_PURE,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				ability = ability,
			}
		end
		if attacker then
			if TYPE == DAMAGE_TYPE_MAGICAL  then
				if not (victim:IsBuilding() and victim:IsIllusion() and (victim:GetTeam() == attacker:GetTeam())) then
					local lifesteal = attacker:GetMagicalLifeSteal()
					local CreepLifeSteal = attacker:GetMagicalCreepLifeSteal()
					if lifesteal and lifesteal > 0 then
						if victim:IsHero() then
							attacker:MagicalLifeSteal(filterDamage.damage,lifesteal)
						elseif victim:IsCreep() then
							attacker:MagicalLifeSteal(filterDamage.damage,CreepLifeSteal)
						end 
					end
				end
			elseif TYPE == DAMAGE_TYPE_PHYSICAL then
				if not (victim:IsBuilding() and victim:IsIllusion() and (victim:GetTeam() == attacker:GetTeam())) then
					local lifesteal = attacker:GetAttackLifeSteal()
					if lifesteal and lifesteal > 0 then
						attacker:AttackLifeSteal(filterDamage.damage,lifesteal) 
					end
				end
			end
			--[[if ability then
				if abilityName == "zuus_static_field" then
				print(filterDamage.damage)
					filterDamage.damage  = filterDamage.damage / 2
				end 
			end ]]
		end
	return true
end