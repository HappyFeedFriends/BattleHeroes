if Bosses == nil then
print("[Bosses] Loading... ")
	Bosses = class({})
end	
require("modules/bosses/data")
function Bosses:SpawnStaticBoss(name)
	local name_boss = string.gsub(name, "npc_battle_heroes_boss_", "")
	local entity = Entities:FindAllByName(name_boss)
	for _,spawner in pairs(entity) do
		Bosses:SpawnBossUnit(name, spawner)
	end
end



function Bosses:SpawnBossUnit(name, spawner)
	local name_boss = string.gsub(name, "npc_battle_heroes_boss_", "")
	local boss = CreateUnitByName(name, spawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
	local armor,magic,hp,xp,gold,damage,attack_speed = unpack(table.nearestOrLowerKey(DATA_BOSSES[name_boss]["STATS"], GetDOTATimeInMinutesFull()))
	boss:SetDeathXP(xp)
	boss:SetMinimumGoldBounty(0)
	boss:SetMaximumGoldBounty(0)
	boss:SetMaxHealth(hp)
	boss:SetBaseMaxHealth(hp)
	boss:SetHealth(hp)
	boss:SetBaseDamageMin(damage)
	boss:SetBaseDamageMax(damage)
	boss:SetPhysicalArmorBaseValue(armor)
	boss:SetBaseMagicalResistanceValue(magic)
	boss:AddNewModifier(nil,nil,"modifier_creep_attack_speed_bonus",{duration = -1})
	boss:SetModifierStackCount( "modifier_creep_attack_speed_bonus", nil, attack_speed )
	boss:AddAbility("bosses_shield"):SetLevel(1)
end
function CDOTA_BaseNPC:IsBoss()
	return self:GetUnitName():find("npc_battle_heroes_boss_")
end
function Bosses:InitBosses()
	for k,v in pairs(DATA_BOSSES) do
	print("npc_battle_heroes_boss_" .. k)
		Bosses:SpawnStaticBoss("npc_battle_heroes_boss_" .. k)
	end
end
function Bosses:KilledBoss(unit,attacker)
	local unitname = unit:GetUnitName()
	local units = string.gsub(unitname, "npc_battle_heroes_boss_", "")
	local data = {
		type = "generic",
		text = "#custom_toast_BossKilled",
		victimUnitName = unitname,
		teamColor = attacker:GetTeam(),
		team = attacker:GetTeam(),
		gold = DATA_BOSSES[units].GoldDrop
}
	kills:CreateCustomToast(data)
	for _,v in pairs(HeroList:GetAllHeroes()) do
		if v:GetTeam() == attacker:GetTeam() and v:IsTrueHero() then
			Gold:ModifyGold(v,DATA_BOSSES[units].GoldDrop, true, 0 )
			SendOverheadEventMessage( v, OVERHEAD_ALERT_GOLD , v, DATA_BOSSES[units].GoldDrop, nil )
		end
	end
	unit:RollDropItemUnit()
	Timers:CreateTimer(DATA_BOSSES[units].RespawnTime, function()
		Bosses:SpawnStaticBoss(unitname)
	end)
end

function CDOTA_BaseNPC:GetItemDrop() 
	return DATA_BOSSES[string.gsub(self:GetUnitName(), "npc_battle_heroes_boss_", "")]["ITEMDROP"]
end

function CDOTA_BaseNPC:GetItemDropChance(item)
	return self:GetItemDrop()[item].chance
end

function CDOTA_BaseNPC:GetitemDropMaximumValue(item)
	return self:GetItemDrop()[item].maximum
end

function CDOTA_BaseNPC:GetitemDropMinimumValue(item)
	return self:GetItemDrop()[item].minimum
end
