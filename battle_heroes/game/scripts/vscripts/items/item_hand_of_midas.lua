LinkLuaModifier ("modifier_hand_of_midas", "items/item_hand_of_midas", LUA_MODIFIER_MOTION_NONE)

item_hand_of_midas_1 = item_hand_of_midas_1 or class({})
item_hand_of_midas_2 = item_hand_of_midas_1 or class({})
item_hand_of_midas_3 = item_hand_of_midas_1 or class({})

function item_hand_of_midas_1:GetIntrinsicModifierName()
    return "modifier_hand_of_midas"
end

function item_hand_of_midas_1:OnSpellStart()
local xp,gold = self:GetSpecialValueFor("xp"),self:GetSpecialValueFor("gold")
	self:GetCursorTarget():Midas(gold,xp,self:GetCaster(),self)
end 

modifier_hand_of_midas = modifier_hand_of_midas or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})

function modifier_hand_of_midas:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_hand_of_midas:GetModifierAttackSpeedBonus_Constant()
	return	self:GetAbility():GetSpecialValueFor("attack_speed")
end 