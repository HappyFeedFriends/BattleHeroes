bosses_shield = bosses_shield or class({})
LinkLuaModifier( "modifier_bosses", "heroes/boss", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_max_attack_range", "heroes/boss", LUA_MODIFIER_MOTION_NONE )
function bosses_shield:GetIntrinsicModifierName()
	return "modifier_bosses"
end 

modifier_bosses = modifier_bosses or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes 			= function() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_bosses:CheckState()
		return {
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
end 

function modifier_bosses:DeclareFunctions()
	return {
			MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end 

function modifier_bosses:OnTakeDamage(keys)
	if keys.unit == self:GetParent() then
		keys.attacker:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_no_invis_bh",{duration = 3})
		keys.attacker:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_max_attack_range",{
		duration = 3,
		AttackRange = 550,
		})
	end 
end 

modifier_max_attack_range = class({})
modifier_max_attack_range.ParentAttackRange = 0
modifier_max_attack_range.AttackRangeChange = 0

function modifier_max_attack_range:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS}
end

function modifier_max_attack_range:RemoveOnDeath()
	return false
end

function modifier_max_attack_range:IsPurgable()
	return false
end

function modifier_max_attack_range:IsHidden()
	return true
end
function modifier_max_attack_range:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

if IsServer() then
	function modifier_max_attack_range:OnCreated(kv)
		if kv and kv.AttackRange then
			self:SetStackCount(kv.AttackRange)
		end
		local mods = self:GetParent():FindAllModifiersByName("modifier_max_attack_range")
		for _,v in ipairs(mods) do
			if v ~= self then
				if v:GetStackCount() < self:GetStackCount() then
					self:SetStackCount(v:GetStackCount())
				end
				if v:GetRemainingTime() > self:GetRemainingTime() then
					v:SetDuration(v:GetRemainingTime(), true)
				end
				v:Destroy()
			end
		end
		self:OnIntervalThink()
		self:StartIntervalThink(1/30)
	end

	function modifier_max_attack_range:GetModifierAttackRangeBonus()
		if self.ParentAttackRange > self:GetStackCount() then
			self.AttackRangeChange = self.ParentAttackRange - self:GetStackCount()
			return -self.AttackRangeChange
		end
	end

	function modifier_max_attack_range:OnIntervalThink()
		self.ParentAttackRange = self:GetParent():GetAttackRange() + self.AttackRangeChange
	end
end 