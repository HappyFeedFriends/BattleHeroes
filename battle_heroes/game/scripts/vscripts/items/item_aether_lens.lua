LinkLuaModifier ("modifier_aether_lens_bh", "items/item_aether_lens", LUA_MODIFIER_MOTION_NONE)
item_aether_lens_1 = item_aether_lens_1 or class({})
item_aether_lens_2 = item_aether_lens_2 or class({})
item_aether_lens_3 = item_aether_lens_3 or class({})
item_aether_lens_4 = item_aether_lens_4 or class({})
item_aether_lens_5 = item_aether_lens_5 or class({})

function item_aether_lens_1:GetIntrinsicModifierName()
    return "modifier_aether_lens_bh"
end
function item_aether_lens_2:GetIntrinsicModifierName()
    return "modifier_aether_lens_bh"
end
function item_aether_lens_3:GetIntrinsicModifierName()
    return "modifier_aether_lens_bh"
end
function item_aether_lens_4:GetIntrinsicModifierName()
    return "modifier_aether_lens_bh"
end
function item_aether_lens_5:GetIntrinsicModifierName()
    return "modifier_aether_lens_bh"
end

modifier_aether_lens_bh = modifier_aether_lens_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_aether_lens_bh:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, 
		--MODIFIER_PROPERTY_MANA_BONUS, 
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, 
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

--[[function modifier_aether_lens_bh:GetModifierConstantManaRegen()
	return self:GetCaster():GetMaxMana()/100 * self:GetAbility():GetSpecialValueFor("mana_regen")
end]]
function modifier_aether_lens_bh:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("mana")
end
function modifier_aether_lens_bh:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("amplify")
end
function modifier_aether_lens_bh:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("intellect")
end