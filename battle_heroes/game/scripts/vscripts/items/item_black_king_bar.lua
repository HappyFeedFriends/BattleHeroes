LinkLuaModifier ("modifier_black_king_bar_bh", "items/item_black_king_bar", LUA_MODIFIER_MOTION_NONE)
item_black_king_bar_1 = item_black_king_bar_1 or class({})
item_black_king_bar_2 = item_black_king_bar_1 or class({})
item_black_king_bar_3 = item_black_king_bar_1 or class({})
item_black_king_bar_4 = item_black_king_bar_1 or class({})
item_black_king_bar_5 = item_black_king_bar_1 or class({})

function item_black_king_bar_1:GetIntrinsicModifierName()
    return "modifier_black_king_bar_bh"
end

function item_black_king_bar_1:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_magic_immune_bh",{duration = self:GetSpecialValueFor("duration")})
	self:GetCaster():EmitSound("DOTA_Item.BlackKingBar.Activate")
end 

modifier_black_king_bar_bh = modifier_black_king_bar_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_black_king_bar_bh:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_black_king_bar_bh:GetModifierBonusStats_Strength()
	return	self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_black_king_bar_bh:GetModifierPreAttack_BonusDamage()
	return 	self:GetAbility():GetSpecialValueFor("bonus_damage")
end