LinkLuaModifier ("modifier_monkey_king_bar_bh", "items/item_monkey_king_bar", LUA_MODIFIER_MOTION_NONE)
item_monkey_king_bar_1 = item_monkey_king_bar_1 or class({})
item_monkey_king_bar_2 = item_monkey_king_bar_1 or class({})
item_monkey_king_bar_3 = item_monkey_king_bar_1 or class({})
item_monkey_king_bar_4 = item_monkey_king_bar_1 or class({})
item_monkey_king_bar_5 = item_monkey_king_bar_1 or class({})

function item_monkey_king_bar_1:GetIntrinsicModifierName()
    return "modifier_monkey_king_bar_bh"
end

modifier_monkey_king_bar_bh = modifier_monkey_king_bar_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_monkey_king_bar_bh:CheckState()
	return {[MODIFIER_STATE_CANNOT_MISS] = true}
end 

function modifier_monkey_king_bar_bh:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
	return funcs
end

function modifier_monkey_king_bar_bh:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_agility")  end
function modifier_monkey_king_bar_bh:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage")  end