LinkLuaModifier ("modifier_ethereal_bh", "items/item_ethereal_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_ethereal_bh_debuff", "items/item_ethereal_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_ethereal_bh_buff", "items/item_ethereal_blade", LUA_MODIFIER_MOTION_NONE)
item_ethereal_blade_1 = item_ethereal_blade_1 or class({})
item_ethereal_blade_2 = item_ethereal_blade_1 or class({})
item_ethereal_blade_3 = item_ethereal_blade_1 or class({})
item_ethereal_blade_4 = item_ethereal_blade_1 or class({})
item_ethereal_blade_5 = item_ethereal_blade_1 or class({})

function item_ethereal_blade_1:GetIntrinsicModifierName()
    return "modifier_ethereal_bh"
end

function item_ethereal_blade_1:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,
		EffectName = "particles/items_fx/ethereal_blade.vpcf",
		bDodgeable = true,
		bProvidesVision = true,
		iMoveSpeed = 1300,
		iVisionRadius = 250,
		iVisionTeamNumber = caster:GetTeamNumber(),
	}
	ProjectileManager:CreateTrackingProjectile( info )
end 

function item_ethereal_blade_1:OnProjectileHit( hTarget, vLocation )
	local caster = self:GetCaster()
	local dur
	if hTarget:GetTeamNumber() ~= caster:GetTeamNumber() then
		dur = self:GetSpecialValueFor("duration_enemy")
		ApplyDamage({
		victim = hTarget,
		attacker = caster,
		damage = caster:GetPrimaryStatValue() * self:GetSpecialValueFor("blast_agility_multiplier") + self:GetSpecialValueFor("blast_damage_base"),
		damage_type = DAMAGE_TYPE_MAGICAL,})
		hTarget:AddNewModifier(caster,self,"modifier_ethereal_bh_debuff",{duration = dur})
	else
		dur = self:GetSpecialValueFor("duration_friendly")
		hTarget:AddNewModifier(caster,self,"modifier_ethereal_bh_buff",{duration = dur})
	end 
end

modifier_ethereal_bh = modifier_ethereal_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_ethereal_bh:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end
function modifier_ethereal_bh:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_strength") end
function modifier_ethereal_bh:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_agility") end
function modifier_ethereal_bh:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_intellect") end

modifier_ethereal_bh_debuff = modifier_ethereal_bh_debuff or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
})
function modifier_ethereal_bh_debuff:CheckState()
	local state =
	{
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true
	}
	return state
end 
function modifier_ethereal_bh_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
	}
	return funcs
end
function modifier_ethereal_bh_debuff:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("blast_movement_slow") end
function modifier_ethereal_bh_debuff:GetModifierMagicalResistanceDecrepifyUnique() return self:GetAbility():GetSpecialValueFor("ethereal_damage_bonus") end

modifier_ethereal_bh_buff = modifier_ethereal_bh_buff or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
})
function modifier_ethereal_bh_buff:CheckState()
	local state =
	{
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true
	}
	return state
end 
function modifier_ethereal_bh_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
	}
	return funcs
end
function modifier_ethereal_bh_buff:GetModifierMagicalResistanceDecrepifyUnique() return self:GetAbility():GetSpecialValueFor("ethereal_damage_bonus") end