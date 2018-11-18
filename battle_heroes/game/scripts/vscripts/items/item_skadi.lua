LinkLuaModifier("modifier_skadi_bh", "items/item_skadi", LUA_MODIFIER_MOTION_NONE)
item_skadi_1 = item_skadi_1 or class({})
item_skadi_2 = item_skadi_1 or class({})
item_skadi_3 = item_skadi_1 or class({})
item_skadi_4 = item_skadi_1 or class({})
item_skadi_5 = item_skadi_1 or class({})

function item_skadi_1:GetIntrinsicModifierName()
	return "modifier_skadi_bh"
end

modifier_skadi_bh = modifier_skadi_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_skadi_bh:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_skadi_bh:GetChangeParticleAttack() return "particles/items2_fx/skadi_projectile.vpcf" end
function modifier_skadi_bh:GetModifierBonusStats_Strength()return self:GetAbility():GetSpecialValueFor("all_stats") end
function modifier_skadi_bh:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("all_stats") end
function modifier_skadi_bh:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("all_stats") end
function modifier_skadi_bh:GetModifierHealthBonus() return self:GetAbility():GetSpecialValueFor("hp") end
function modifier_skadi_bh:GetModifierManaBonus() return self:GetAbility():GetSpecialValueFor("mp") end
function modifier_skadi_bh:OnAttackLanded(params)
	if self:GetCaster() == params.attacker then
	local dur
	if self:GetCaster():IsAttackRange() then
		dur = self:GetAbility():GetSpecialValueFor("duration_ranged")
	else
		dur = self:GetAbility():GetSpecialValueFor("duration_melee")
	end
		params.target:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_skadi_bh_debuff",{duration = dur})
	end 
end 

modifier_skadi_bh_debuff = modifier_skadi_bh_debuff or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})

function modifier_skadi_bh_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_skadi_bh_debuff:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("slow_attackspeed") end
function modifier_skadi_bh_debuff:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("slow_movespeed") end 