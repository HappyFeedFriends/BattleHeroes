LinkLuaModifier ("modifier_daedalus_bh", "items/item_daedalus", LUA_MODIFIER_MOTION_NONE)
item_daedalus_1 = item_daedalus_1 or class({})
item_daedalus_2 = item_daedalus_1 or class({})
item_daedalus_3 = item_daedalus_1 or class({})
item_daedalus_4 = item_daedalus_1 or class({})
item_daedalus_5 = item_daedalus_1 or class({})
function item_daedalus_1:GetIntrinsicModifierName()
    return "modifier_daedalus_bh"
end

modifier_daedalus_bh = modifier_daedalus_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_daedalus_bh:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs 
end

function modifier_daedalus_bh:GetModifierPreAttack_CriticalStrike()
	if RollPercentage(self:GetAbility():GetSpecialValueFor("critical_chance")) then
		return self:GetAbility():GetSpecialValueFor("critical_damage")
	end
end 

function modifier_daedalus_bh:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end 