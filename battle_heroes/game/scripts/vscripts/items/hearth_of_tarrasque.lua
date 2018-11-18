item_hearth_of_tarrasque_1 = item_hearth_of_tarrasque_1 or class({})
item_hearth_of_tarrasque_2 = item_hearth_of_tarrasque_1 or class({})
item_hearth_of_tarrasque_3 = item_hearth_of_tarrasque_1 or class({})

function item_hearth_of_tarrasque_1:GetIntrinsicModifierName()
    return "modifier_hearth_bh"
end

modifier_hearth_bh = modifier_hearth_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})

function modifier_hearth_bh:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		
	}
	return funcs 
end
function modifier_hearth_bh:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_strength") end
function modifier_hearth_bh:GetModifierHealthBonus() return self:GetAbility():GetSpecialValueFor("bonus_health") end

function modifier_hearth_bh:OnTakeDamage(params)
	if self:GetCaster() == params.unit and params.attacker:IsHero() or params.attacker:IsBoss() then
		local cooldown
		if self:GetCaster():IsAttackRange() then
			cooldown = self:GetAbility():GetSpecialValueFor("cooldown_ranged")
			self:GetAbility():StartCooldown(cooldown)
		else
			cooldown = self:GetAbility():GetSpecialValueFor("cooldown_melee")
			self:GetAbility():StartCooldown(cooldown)
		end 
	end
end
function modifier_hearth_bh:OnCreated()
	self:StartIntervalThink(0.1)
end 
function modifier_hearth_bh:OnDestroy()
	if self:GetCaster():HasModifier("modifier_hearth_bh_buff") then
		self:GetCaster():RemoveModifierByName("modifier_hearth_bh_buff")
	end
end 
function modifier_hearth_bh:OnIntervalThink()
	if IsServer() and self:GetAbility():IsCooldownReady() and self:GetCaster():HasModifier("modifier_hearth_bh") then
		if not self:GetCaster():HasModifier("modifier_hearth_bh_buff") then
			self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_hearth_bh_buff",{duration = -1})
		end 
	elseif self:GetCaster():HasModifier("modifier_hearth_bh_buff") then
		self:GetCaster():RemoveModifierByName("modifier_hearth_bh_buff")
	end
end 

modifier_hearth_bh_buff = modifier_hearth_bh_buff or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})

function modifier_hearth_bh_buff:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		
	}
	return funcs 
end

function modifier_hearth_bh_buff:GetModifierHealthRegenPercentage() 
	return self:GetAbility():GetSpecialValueFor("bonus_regen_hp") 
end