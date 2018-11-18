LinkLuaModifier ("modifier_mask_of_madness_bh", "items/mask_of_madness", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_mask_of_madness_bh_use", "items/mask_of_madness", LUA_MODIFIER_MOTION_NONE)
item_mask_of_madness_1 = item_mask_of_madness_1 or class({})
item_mask_of_madness_2 = item_mask_of_madness_1 or class({})
item_mask_of_madness_3 = item_mask_of_madness_1 or class({})
item_mask_of_madness_4 = item_mask_of_madness_1 or class({})
item_mask_of_madness_5 = item_mask_of_madness_1 or class({})

function item_mask_of_madness_1:GetIntrinsicModifierName()
    return "modifier_mask_of_madness_bh"
end

function item_mask_of_madness_1:OnSpellStart()
	self:GetCaster():EmitSound("DOTA_Item.MaskOfMadness.Activate")
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_mask_of_madness_bh_use",{duration = self:GetSpecialValueFor("duration")})
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_silence",{duration = self:GetSpecialValueFor("duration")})
end 

modifier_mask_of_madness_bh = modifier_mask_of_madness_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})


function modifier_mask_of_madness_bh:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs 
end

function modifier_mask_of_madness_bh:GetModifierPreAttack_BonusDamage()
	return	self:GetAbility():GetSpecialValueFor("bonus_damage")
end
function modifier_mask_of_madness_bh:GetModifierAttackSpeedBonus_Constant()
	return	self:GetAbility():GetSpecialValueFor("attack_speed")
end
function modifier_mask_of_madness_bh:GetAttackLifeSteal()
	return self:GetAbility():GetSpecialValueFor("lifesteal")
end

modifier_mask_of_madness_bh_use = modifier_mask_of_madness_bh_use or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})


function modifier_mask_of_madness_bh_use:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs 
end

function modifier_mask_of_madness_bh_use:GetModifierAttackSpeedBonus_Constant()
	return	self:GetAbility():GetSpecialValueFor("attack_speed_use")
end

function modifier_mask_of_madness_bh_use:GetModifierMoveSpeedBonus_Percentage()
	return	self:GetAbility():GetSpecialValueFor("move_speed_use")
end

function modifier_mask_of_madness_bh_use:GetModifierPhysicalArmorBonus()
	return	self:GetAbility():GetSpecialValueFor("armor_use")
end

