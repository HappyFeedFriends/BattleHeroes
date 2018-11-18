LinkLuaModifier ("modifier_satanic_bh", "items/item_satanic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_satanic_bh_active", "items/item_satanic", LUA_MODIFIER_MOTION_NONE)

item_satanic_1 = item_satanic_1 or class({})
item_satanic_2 = item_satanic_2 or class({})
item_satanic_3 = item_satanic_3 or class({})
function item_satanic_1:OnSpellStart() self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_satanic_bh_active",{duration = self:GetSpecialValueFor("duration")}) end 
function item_satanic_2:OnSpellStart() self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_satanic_bh_active",{duration = self:GetSpecialValueFor("duration")}) end 
function item_satanic_3:OnSpellStart() self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_satanic_bh_active",{duration = self:GetSpecialValueFor("duration")}) end 

function item_satanic_1:GetIntrinsicModifierName()
    return "modifier_satanic_bh"
end

function item_satanic_2:GetIntrinsicModifierName()
    return "modifier_satanic_bh"
end

function item_satanic_3:GetIntrinsicModifierName()
    return "modifier_satanic_bh"
end

modifier_satanic_bh = modifier_satanic_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_satanic_bh:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs 
end

function modifier_satanic_bh:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage")
end 
function modifier_satanic_bh:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("strength")
end
function modifier_satanic_bh:GetAttackLifeSteal()
	return self:GetAbility():GetSpecialValueFor("attack_lifesteal")
end

modifier_satanic_bh_active = modifier_satanic_bh_active or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})

function modifier_satanic_bh_active:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs 
end

function modifier_satanic_bh_active:GetAttackLifeSteal()
	return self:GetAbility():GetSpecialValueFor("attack_lifesteal_activate")
end

function modifier_satanic_bh_active:OnTooltip()
	return self:GetAbility():GetSpecialValueFor("attack_lifesteal") + self:GetAbility():GetSpecialValueFor("attack_lifesteal_activate")
end