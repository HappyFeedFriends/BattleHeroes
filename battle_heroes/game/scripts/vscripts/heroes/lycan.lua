lycan_summon_wolves_bh = lycan_summon_wolves_bh or class({})

function lycan_summon_wolves_bh:OnSpellStart()
	local amount = self:GetSpecialValueFor("wolf_count")
	local dur = self:GetSpecialValueFor("duration")
	local wolf_bat = self:GetSpecialValueFor("attack_time")
	local wolf_damage = self:GetSpecialValueFor("damage")
	local wolf_hp = self:GetSpecialValueFor("health")
	local wolf_armor = self:GetSpecialValueFor("wolf_armor")
	local wolf_movespeed = self:GetSpecialValueFor("wolf_movespeed")
	local ability,ability_Level
	if self:GetLevel() >= self:GetSpecialValueFor("bonus_ability_two") then
		ability = 
		{ 	
			lycan_summon_wolves_critical_strike = 1,
			lycan_summon_wolves_invisibility = 1,
		}
	elseif self:GetLevel() >= self:GetSpecialValueFor("bonus_ability_one") then
		ability = "lycan_summon_wolves_critical_strike"
	end 
	local data = 
	{
		UnitName = "npc_lycan_wolf_bh",
		amount =  amount,
		health = wolf_hp,
		gold = 32,
		xp =  32,
		ability = ability,
		ability_Level = ability_Level,
		damage = wolf_damage,
		movespeed = wolf_movespeed,
		level = self:GetLevel(),
		armor = wolf_armor,
		attack_time = wolf_bat,
		duration = dur,
	}
	self:GetCaster():CreateUnitByCaster(data)
	self:GetCaster():EmitSound("Hero_Lycan.SummonWolves")
end 