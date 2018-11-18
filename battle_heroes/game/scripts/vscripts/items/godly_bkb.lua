LinkLuaModifier ("modifier_godly_bkb", "items/godly_bkb", LUA_MODIFIER_MOTION_NONE)

item_godly_black_king_bar_1 = item_godly_black_king_bar_1 or class({})
item_godly_black_king_bar_2 = item_godly_black_king_bar_1 or class({})
item_godly_black_king_bar_3 = item_godly_black_king_bar_1 or class({})
item_godly_black_king_bar_4 = item_godly_black_king_bar_1 or class({})
item_godly_black_king_bar_5 = item_godly_black_king_bar_1 or class({})

function item_godly_black_king_bar_1:GetIntrinsicModifierName()
    return "modifier_godly_bkb"
end

function item_godly_black_king_bar_1:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_invulnerability_bh",{duration = self:GetSpecialValueFor("duration")})
	self:GetCaster():EmitSound("DOTA_Item.BlackKingBar.Activate")
end 

modifier_godly_bkb = modifier_black_king_bar_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_godly_bkb:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_godly_bkb:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_all") end
function modifier_godly_bkb:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_all") end
function modifier_godly_bkb:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_all") end
function modifier_godly_bkb:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("bonus_armor") end
function modifier_godly_bkb:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end