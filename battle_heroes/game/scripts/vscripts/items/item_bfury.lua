LinkLuaModifier("modifier_battle_fury_bh", "items/item_bfury", LUA_MODIFIER_MOTION_NONE)
item_battle_fury_1 = item_battle_fury_1 or class({})
item_battle_fury_2 = item_battle_fury_2 or class({})
item_battle_fury_3 = item_battle_fury_3 or class({})

function item_battle_fury_1:GetIntrinsicModifierName()
	return "modifier_battle_fury_bh"
end
function item_battle_fury_2:GetIntrinsicModifierName()
	return "modifier_battle_fury_bh"
end
function item_battle_fury_3:GetIntrinsicModifierName()
	return "modifier_battle_fury_bh"
end

modifier_battle_fury_bh = modifier_battle_fury_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_battle_fury_bh:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_battle_fury_bh:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_battle_fury_bh:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("regen_hp")
end

function modifier_battle_fury_bh:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("regen_mana")
end

if IsServer() then
	function modifier_battle_fury_bh:OnAttackLanded(keys)
		local attacker = keys.attacker
		local ability = self:GetAbility()
		local damage = keys.damage * ability:GetSpecialValueFor("cleave_damage")/100
		local target = keys.target
		if attacker == self:GetCaster() and not attacker:IsAttackRange() and attacker:IsRealHero() then
			attacker:CleaveAttacks(target,ability,damage,ability:GetSpecialValueFor("distance"),ability:GetSpecialValueFor("cleave_starting_width"), ability:GetSpecialValueFor("cleave_end_width"))
		end
	end
end