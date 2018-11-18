LinkLuaModifier ("modifier_demonic_peak", "items/item_demonic_peak", LUA_MODIFIER_MOTION_NONE)

item_demonic_peak_1 = item_demonic_peak_1 or class({})
item_demonic_peak_2 = item_demonic_peak_1 or class({})

function item_demonic_peak_1:GetIntrinsicModifierName()
    return "modifier_demonic_peak"
end

modifier_demonic_peak = modifier_demonic_peak or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_demonic_peak:DeclareFunctions()
local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED, 
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE		
	}
	return funcs 
end

function modifier_demonic_peak:CheckState()
	return {[MODIFIER_STATE_CANNOT_MISS] = true}
end 

function modifier_demonic_peak:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end
function modifier_demonic_peak:OnAttackLanded(params)
	if self:GetCaster() == params.attacker then
	local damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())/100 * self:GetAbility():GetSpecialValueFor("damage_pure")
		local damage_table =
		{
			victim = params.target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
		}
	ApplyDamage(damage_table)
	end
end 