item_aghanim_bh = item_aghanim_bh or class({})
LinkLuaModifier("modifier_aghanim_scepter_bh", "items/item_aghanim_scepter_bh", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("item_aghanim_scepter_bh_active", "items/item_aghanim_scepter_bh", LUA_MODIFIER_MOTION_NONE )
ALL_STATS = 0
HP_BONUS = 0
MP_BONUS = 0
function item_aghanim_bh:GetIntrinsicModifierName()
	return "modifier_aghanim_scepter_bh"
end 
function item_aghanim_bh:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"item_aghanim_scepter_bh_active",{duration = -1})
	self:GetCaster():RemoveItem(self)
end
modifier_aghanim_scepter_bh = modifier_aghanim_scepter_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetModifierHealthBonus	= function(self) HP_BONUS = self:GetAbility():GetSpecialValueFor("health_bonus")return HP_BONUS end,
	GetModifierManaBonus		= function(self) MP_BONUS = self:GetAbility():GetSpecialValueFor("mana_bonus") return MP_BONUS end,
	GetModifierBonusStats_Strength	= function(self) ALL_STATS = self:GetAbility():GetSpecialValueFor("all_stats") return ALL_STATS end,
	GetModifierBonusStats_Agility	= function(self) ALL_STATS = self:GetAbility():GetSpecialValueFor("all_stats") return ALL_STATS end,
	GetModifierBonusStats_Intellect	= function(self) ALL_STATS = self:GetAbility():GetSpecialValueFor("all_stats") return ALL_STATS end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	GetModifierScepter		= function(self) return 1 end,
}) 

function modifier_aghanim_scepter_bh:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_IS_SCEPTER,
	}
end 

item_aghanim_scepter_bh_active = item_aghanim_scepter_bh_active or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetModifierHealthBonus	= function(self) return HP_BONUS end,
	GetModifierManaBonus		= function(self) return MP_BONUS end,
	GetModifierBonusStats_Strength	= function(self) return ALL_STATS end,
	GetModifierBonusStats_Agility	= function(self) return ALL_STATS end,
	GetModifierBonusStats_Intellect	= function(self) return ALL_STATS end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	GetTexture 				= function() return "items_custom/item_aghanim_scepter_bh" end,
	GetModifierScepter		= function(self) return 1 end,
}) 

function item_aghanim_scepter_bh_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_IS_SCEPTER,
	}
end