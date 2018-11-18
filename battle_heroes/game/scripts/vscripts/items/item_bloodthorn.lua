LinkLuaModifier ("modifier_bloodthor_bh", "items/item_bloodthorn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_bloodthor_bh_active", "items/item_bloodthorn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_bloodthor_bh_critical", "items/item_bloodthorn", LUA_MODIFIER_MOTION_NONE)

item_bloodthorn_1 = item_bloodthorn_1 or class({})
item_bloodthorn_2 = item_bloodthorn_1 or class({})
item_bloodthorn_3 = item_bloodthorn_1 or class({})

function item_bloodthorn_1:GetIntrinsicModifierName()
    return "modifier_bloodthor_bh"
end

function item_bloodthorn_1:OnSpellStart()
	if not self:GetCursorTarget():TriggerSpellAbsorb(self) then
		self:GetCursorTarget():TriggerSpellReflect(self)
		self:GetCursorTarget():AddNewModifier(self:GetCaster(),self,"modifier_bloodthor_bh_active",{duration = self:GetSpecialValueFor("duration")})
	end
end 

modifier_bloodthor_bh = modifier_bloodthor_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})

function modifier_bloodthor_bh:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end
function modifier_bloodthor_bh:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
function modifier_bloodthor_bh:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end
function modifier_bloodthor_bh:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_attackspeed") end

function modifier_bloodthor_bh:GetModifierPreAttack_CriticalStrike() 
	if RollPercentage(self:GetAbility():GetSpecialValueFor("passive_chance_crit")) then
		return self:GetAbility():GetSpecialValueFor("passive_critical") 
	end
end

modifier_bloodthor_bh_active = modifier_bloodthor_bh_active or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})

function modifier_bloodthor_bh_active:OnCreated()
	self.damage = 0
end 

function modifier_bloodthor_bh_active:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_bloodthor_bh_active:OnTooltip()
	return self:GetAbility():GetSpecialValueFor("critical_active")
end

function modifier_bloodthor_bh_active:OnAttackStart(keys)
	local parent = self:GetParent()
	if parent == keys.target then
		local ability = self:GetAbility()
		if not keys.attacker:IsIllusion() then
			keys.attacker:AddNewModifier(parent, self:GetAbility(), "modifier_bloodthor_bh_critical", {duration = 1.5})
		end
	end
end

function modifier_bloodthor_bh_active:OnTakeDamage(event)
	if IsServer() and self:GetParent() == event.unit then
		self.damage = self.damage + (event.damage * self:GetAbility():GetSpecialValueFor("damage_end")/100)
	end
end

function modifier_bloodthor_bh_active:OnDestroy()
	if IsServer() then
		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}
		ApplyDamage(damage)
	end
end

function modifier_bloodthor_bh_active:GetEffectName()
    return "particles/generic_gameplay/generic_silenced_lanecreeps.vpcf"
end

function modifier_bloodthor_bh_active:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_bloodthor_bh_active:CheckState()
	return {
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_EVADE_DISABLED] = true}
end

modifier_bloodthor_bh_critical = modifier_bloodthor_bh_critical or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})


if IsServer() then
	function modifier_bloodthor_bh_critical:DeclareFunctions()
		return {
			MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
			MODIFIER_EVENT_ON_ATTACK_LANDED
		}
	end

	function modifier_bloodthor_bh_critical:GetModifierPreAttack_CriticalStrike(keys)
		if keys.target == self:GetCaster() and keys.target:HasModifier("modifier_bloodthor_bh_active") then
			return self:GetAbility():GetSpecialValueFor("critical_active")
		else
			self:Destroy()
		end
	end

	function modifier_bloodthor_bh_critical:OnAttackLanded(keys)
		if self:GetParent() == keys.attacker then
			keys.attacker:RemoveModifierByName("modifier_bloodthor_bh_critical")
		end
	end
end