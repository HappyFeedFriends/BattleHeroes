
modifier_custom_mechanics = modifier_custom_mechanics or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_custom_mechanics:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_START,
	}
end

function modifier_custom_mechanics:OnAttackStart(params)
	if params.attacker == self:GetParent() then
		if self:GetParent():IsAttackRange() then
		local particle = self:GetParent():GetChangeParticles() 
		local particle_hero = self:GetParent():GetKeyValue("ProjectileModel")
			if particle then
				if self:GetParent():GetRangedProjectileName() ~= particle then
					self:GetParent():SetRangedProjectileName(self:GetParent():GetChangeParticles())
				end
			else
				self:GetParent():SetRangedProjectileName(particle_hero)
			end
		end
	end
end
 