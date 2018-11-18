juggernaut_blade_dance_bh = juggernaut_blade_dance_bh or class({})
LinkLuaModifier( "modifier_juggernaut_blade_dance_bh", "heroes/juggernaut", LUA_MODIFIER_MOTION_NONE )
function juggernaut_blade_dance_bh:GetIntrinsicModifierName()
	return "modifier_juggernaut_blade_dance_bh"
end 

modifier_juggernaut_blade_dance_bh = modifier_juggernaut_blade_dance_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes 			= function() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})
 

function modifier_juggernaut_blade_dance_bh:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
end

function modifier_juggernaut_blade_dance_bh:GetModifierPreAttack_CriticalStrike()
	return RollPercentage(self:GetAbility():GetSpecialValueFor("blade_dance_crit_chance")) and self:GetAbility():GetSpecialValueFor("blade_dance_crit_mult")
end 