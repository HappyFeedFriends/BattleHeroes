LinkLuaModifier("modifier_helmet_of_midas", "items/item_helmet_of_midas", LUA_MODIFIER_MOTION_NONE )

item_helmet_of_midas = item_helmet_of_midas or class({})

function item_helmet_of_midas:GetIntrinsicModifierName()
	return "modifier_helmet_of_midas"
end

modifier_helmet_of_midas = modifier_helmet_of_midas or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_helmet_of_midas:GetModifierBonusXPCreep()
	return self:GetAbility():GetSpecialValueFor("xp_per_unit")
end

function modifier_helmet_of_midas:GetModifierBonusGoldCreep()
	return self:GetAbility():GetSpecialValueFor("gold_per_unit")
end 
