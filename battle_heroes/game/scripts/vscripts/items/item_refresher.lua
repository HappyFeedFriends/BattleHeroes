LinkLuaModifier("modifier_refresher_bh", "items/item_refresher", LUA_MODIFIER_MOTION_NONE)
item_refresher_orb_1 = item_refresher_orb_1 or class({})
item_refresher_orb_2 = item_refresher_orb_1 or class({})
item_refresher_orb_3 = item_refresher_orb_1 or class({})

function item_refresher_orb_1:OnSpellStart()
	self:GetCaster():Refreshing()
end 

function item_refresher_orb_1:GetIntrinsicModifierName()
	return "modifier_refresher_bh"
end

modifier_refresher_bh = modifier_refresher_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})
 
function modifier_refresher_bh:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, 
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs 
end

function modifier_refresher_bh:GetMagicalCreepLifeSteal()
	return self:GetAbility():GetSpecialValueFor("magic_lifesteal_creep")
end

function modifier_refresher_bh:GetMagicalLifeSteal()
	return self:GetAbility():GetSpecialValueFor("magic_lifesteal_hero")
end 

function modifier_refresher_bh:GetModifierPercentageCooldown()
	return	self:GetAbility():GetSpecialValueFor("reduction_cooldown")
end
function modifier_refresher_bh:GetModifierBonusStats_Intellect()
	return	self:GetAbility():GetSpecialValueFor("intellect")
end
function modifier_refresher_bh:GetModifierManaBonus()
	return 	self:GetAbility():GetSpecialValueFor("mana")
end
function modifier_refresher_bh:GetModifierSpellAmplify_Percentage()
	return 	self:GetAbility():GetSpecialValueFor("amplify")
end