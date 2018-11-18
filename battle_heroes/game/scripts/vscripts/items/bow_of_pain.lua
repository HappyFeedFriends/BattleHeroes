LinkLuaModifier ("modifier_bow_of_pain_bh", "items/bow_of_pain", LUA_MODIFIER_MOTION_NONE)
item_bow_of_pain_1 = item_bow_of_pain_1 or class({})
item_bow_of_pain_2 = item_bow_of_pain_2 or class({})
item_bow_of_pain_3 = item_bow_of_pain_3 or class({})

function item_bow_of_pain_1:GetIntrinsicModifierName()
    return "modifier_bow_of_pain_bh"
end

function item_bow_of_pain_1:OnProjectileHit( hTarget, vLocation )
	local damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())/100 * self:GetSpecialValueFor("split_damage")
	local damageTable = 
	{
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
	}
	ApplyDamage(damageTable)
end

function item_bow_of_pain_2:GetIntrinsicModifierName()
    return "modifier_bow_of_pain_bh"
end

function item_bow_of_pain_2:OnProjectileHit( hTarget, vLocation )
	local damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())/100 * self:GetSpecialValueFor("split_damage")
	local damageTable = 
	{
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
	}
	ApplyDamage(damageTable)
end

function item_bow_of_pain_3:GetIntrinsicModifierName()
    return "modifier_bow_of_pain_bh"
end

function item_bow_of_pain_3:OnProjectileHit( hTarget, vLocation )
	local damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())/100 * self:GetSpecialValueFor("split_damage")
	local damageTable = 
	{
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
	}
	ApplyDamage(damageTable)
end

modifier_bow_of_pain_bh = modifier_bow_of_pain_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_bow_of_pain_bh:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,   
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS, 		
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,		
		MODIFIER_EVENT_ON_ATTACK,	
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,	
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,	
	}
	return funcs 
end

function modifier_bow_of_pain_bh:GetModifierBonusStats_Intellect()
	return 	self:GetAbility():GetSpecialValueFor("all_stats")
end 

function modifier_bow_of_pain_bh:GetModifierBonusStats_Agility()
	return	self:GetAbility():GetSpecialValueFor("all_stats")
end

function modifier_bow_of_pain_bh:GetModifierBonusStats_Strength()
	return	self:GetAbility():GetSpecialValueFor("all_stats")
end 

function modifier_bow_of_pain_bh:OnAttack(params)
	if params.attacker == self:GetCaster() and self:GetCaster():IsRealHero() then
		self:GetCaster():SplitShot(self:GetAbility(),self:GetAbility():GetSpecialValueFor("radius"),self:GetAbility():GetSpecialValueFor("bonus_target"))
	end 
end

function modifier_bow_of_pain_bh:GetModifierPreAttack_BonusDamage()
	return	self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_bow_of_pain_bh:GetModifierMoveSpeedBonus_Constant()
	return	self:GetAbility():GetSpecialValueFor("attack_speed")
end