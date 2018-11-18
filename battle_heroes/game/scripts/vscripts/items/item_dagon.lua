LinkLuaModifier("modifier_dagon_nh", "items/item_dagon", LUA_MODIFIER_MOTION_NONE)
item_dagon_bh_1 = item_dagon_bh_1 or class({})
item_dagon_bh_2 = item_dagon_bh_1 or class({})
item_dagon_bh_3 = item_dagon_bh_1 or class({})
item_dagon_bh_4 = item_dagon_bh_1 or class({})
item_dagon_bh_5 = item_dagon_bh_1 or class({})

function item_dagon_bh_1:OnSpellStart()
	local particle = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf",  PATTACH_POINT, self:GetCaster())
	local damage = self:GetSpecialValueFor("damage")
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT, "attach_attack1", self:GetCaster():GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(particle, 1, self:GetCursorTarget(), PATTACH_POINT, "attach_hitloc", self:GetCursorTarget():GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(particle, 2, Vector(damage,0,0))
	local damage_table =
	{
		victim = self:GetCursorTarget(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
	}
	ApplyDamage(damage_table)
end 

function item_dagon_bh_1:GetIntrinsicModifierName()
	return "modifier_dagon_nh"
end

modifier_dagon_nh = modifier_battle_fury_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_dagon_nh:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
end

function modifier_dagon_nh:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("all_stats")
end
function modifier_dagon_nh:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("all_stats")
end
function modifier_dagon_nh:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("intellect") + self:GetAbility():GetSpecialValueFor("all_stats")
end