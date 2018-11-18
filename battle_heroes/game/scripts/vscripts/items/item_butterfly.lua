LinkLuaModifier ("modifier_butterfly_bh", "items/item_butterfly", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_butterfly_bh_buff", "items/item_butterfly", LUA_MODIFIER_MOTION_NONE)
item_butterfly_1 = item_butterfly_1 or class({})
item_butterfly_2 = item_butterfly_1 or class({})
item_butterfly_3 = item_butterfly_1 or class({})
item_butterfly_4 = item_butterfly_1 or class({})
item_butterfly_5 = item_butterfly_1 or class({})

function item_butterfly_1:GetIntrinsicModifierName()
    return "modifier_butterfly_bh"
end

function item_butterfly_1:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_butterfly_bh_buff",{duration = self:GetSpecialValueFor("duration")})
end

modifier_butterfly_bh = modifier_butterfly_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_butterfly_bh:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
	}
	return funcs 
end

function modifier_butterfly_bh:GetModifierEvasion_Constant() return self:GetAbility():GetSpecialValueFor("bonus_evasion") end
function modifier_butterfly_bh:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_agility") end
function modifier_butterfly_bh:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end
function modifier_butterfly_bh:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end

modifier_butterfly_bh_buff = modifier_butterfly_bh_buff or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
})

function modifier_butterfly_bh_buff:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs 
end
function modifier_butterfly_bh_buff:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("active_bonus_movespeed") end