LinkLuaModifier ("modifier_octarine_core_bh", "items/item_octarine_core", LUA_MODIFIER_MOTION_NONE)
item_octarine_core_1 = item_octarine_core_1 or class({})
item_octarine_core_2 = item_octarine_core_2 or class({})
item_octarine_core_3 = item_octarine_core_3 or class({})
item_octarine_core_4 = item_octarine_core_4 or class({})
item_octarine_core_5 = item_octarine_core_5 or class({})

function item_octarine_core_1:GetIntrinsicModifierName()
    return "modifier_octarine_core_bh"
end
function item_octarine_core_2:GetIntrinsicModifierName()
    return "modifier_octarine_core_bh"
end
function item_octarine_core_3:GetIntrinsicModifierName()
    return "modifier_octarine_core_bh"
end
function item_octarine_core_4:GetIntrinsicModifierName()
    return "modifier_octarine_core_bh"
end
function item_octarine_core_5:GetIntrinsicModifierName()
    return "modifier_octarine_core_bh"
end

modifier_octarine_core_bh = modifier_octarine_core_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_octarine_core_bh:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, 
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs 
end

function modifier_octarine_core_bh:GetMagicalCreepLifeSteal()
	return self:GetAbility():GetSpecialValueFor("magic_lifesteal_creep")
end

function modifier_octarine_core_bh:GetMagicalLifeSteal()
	return self:GetAbility():GetSpecialValueFor("magic_lifesteal_hero")
end 

function modifier_octarine_core_bh:GetModifierPercentageCooldown()
	return	self:GetAbility():GetSpecialValueFor("reduction_cooldown")
end
function modifier_octarine_core_bh:GetModifierBonusStats_Intellect()
	return	self:GetAbility():GetSpecialValueFor("intellect")
end
function modifier_octarine_core_bh:GetModifierManaBonus()
	return 	self:GetAbility():GetSpecialValueFor("mana")
end
function modifier_octarine_core_bh:GetModifierSpellAmplify_Percentage()
	return 	self:GetAbility():GetSpecialValueFor("amplify")
end