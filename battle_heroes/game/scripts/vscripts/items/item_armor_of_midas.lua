LinkLuaModifier("modifier_armor_of_midas", "items/item_armor_of_midas", LUA_MODIFIER_MOTION_NONE )


item_armor_of_midas = item_armor_of_midas or class({})

function item_armor_of_midas:GetIntrinsicModifierName()
	return "modifier_armor_of_midas"
end

modifier_armor_of_midas = modifier_armor_of_midas or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_armor_of_midas:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_armor_of_midas:OnTakeDamage(params)
	if self:GetCaster() == params.unit and params.attacker:IsHero() and self:GetAbility():IsCooldownReady() then
		local gold = self:GetAbility():GetSpecialValueFor("gold_per_attack")
		local xp = self:GetAbility():GetSpecialValueFor("xp_per_attack")
		Gold:ModifyGold(self:GetCaster(),gold)
		self:GetCaster():AddExperience( xp,0,false,false )
		self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
	end
end 