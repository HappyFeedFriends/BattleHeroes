LinkLuaModifier ("modifier_desolator_bh", "items/item_desolator", LUA_MODIFIER_MOTION_NONE)
item_desolator_1 = item_desolator_1 or class({})
item_desolator_2 = item_desolator_2 or class({})
item_desolator_3 = item_desolator_3 or class({})
item_desolator_4 = item_desolator_4 or class({})
item_desolator_5 = item_desolator_5 or class({})

function item_desolator_1:GetIntrinsicModifierName()
    return "modifier_desolator_bh"
end
function item_desolator_2:GetIntrinsicModifierName()
    return "modifier_desolator_bh"
end
function item_desolator_3:GetIntrinsicModifierName()
    return "modifier_desolator_bh"
end
function item_desolator_4:GetIntrinsicModifierName()
    return "modifier_desolator_bh"
end
function item_desolator_5:GetIntrinsicModifierName()
    return "modifier_desolator_bh"
end

modifier_desolator_bh = modifier_desolator_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_desolator_bh:GetChangeParticleAttack()
	return "particles/battle_heroes/desolator/desolator.vpcf"
end 

function modifier_desolator_bh:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_desolator_bh:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage_bonus")
end
function modifier_desolator_bh:OnAttackLanded(params)
	if params.attacker == self:GetCaster() then
		params.target:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_desolator_bh_debuff",{duration = self:GetAbility():GetSpecialValueFor("duration")})
	end 
end

modifier_desolator_bh_debuff = modifier_desolator_bh_debuff or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})

function modifier_desolator_bh_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 
	}
	return funcs
end

function modifier_desolator_bh_debuff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_reduction")
end 