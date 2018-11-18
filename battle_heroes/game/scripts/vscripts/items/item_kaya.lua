LinkLuaModifier("modifier_kaya_bh", "items/item_kaya", LUA_MODIFIER_MOTION_NONE )

item_kaya_1 = item_kaya_1 or class({})
item_kaya_2 = item_kaya_1 or class({})
item_kaya_3 = item_kaya_1 or class({})
item_kaya_4 = item_kaya_1 or class({})
item_kaya_5 = item_kaya_1 or class({})

function item_kaya_1:GetIntrinsicModifierName()
	return "modifier_kaya_bh"
end

modifier_kaya_bh = modifier_kaya_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_kaya_bh:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifier_kaya_bh:GetModifierPercentageManacost() return self:GetAbility():GetSpecialValueFor("manacost") end
function modifier_kaya_bh:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
function modifier_kaya_bh:GetModifierSpellAmplify_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_mg") end