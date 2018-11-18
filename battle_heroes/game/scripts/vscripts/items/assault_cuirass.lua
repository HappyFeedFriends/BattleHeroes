LinkLuaModifier ("modifier_assault_cuirass_aura", "items/assault_cuirass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_assault_cuirass", "items/assault_cuirass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_assault_cuirass_buff", "items/assault_cuirass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_assault_cuirass_debuff", "items/assault_cuirass", LUA_MODIFIER_MOTION_NONE)
item_assault_cuirass_1 = item_assault_cuirass_1 or class({})
item_assault_cuirass_2 = item_assault_cuirass_1 or class({})
item_assault_cuirass_3 = item_assault_cuirass_1 or class({})
item_assault_cuirass_4 = item_assault_cuirass_1 or class({})
item_assault_cuirass_5 = item_assault_cuirass_1 or class({})

function item_assault_cuirass_1:GetIntrinsicModifierName()
    return "modifier_assault_cuirass_aura"
end

modifier_assault_cuirass_aura = modifier_assault_cuirass_aura or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	IsAura					= function(self) return true end,
	GetAuraSearchTeam		= function(self) return self:GetAbility():GetAbilityTargetTeam() end,
	GetAuraSearchFlags		= function(self) return self:GetAbility():GetAbilityTargetFlags() end,
	GetAuraSearchType		= function(self) return	self:GetAbility():GetAbilityTargetType() end,
	GetModifierAura			= function(self) return "modifier_assault_cuirass" end,
	GetAuraRadius			= function(self) return self:GetAbility():GetSpecialValueFor("radius") end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_assault_cuirass_aura:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,   
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
	return funcs 
end 
function modifier_assault_cuirass_aura:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end
function modifier_assault_cuirass_aura:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("bonus_armor") end
function modifier_assault_cuirass_aura:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_strength") end
function modifier_assault_cuirass_aura:GetModifierHealthBonus() return self:GetAbility():GetSpecialValueFor("bonus_health") end

modifier_assault_cuirass = modifier_assault_cuirass or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})

function modifier_assault_cuirass:OnCreated()
	if IsServer() then
		if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber()  then
			self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_assault_cuirass_buff",{duration = -1})
		else
			self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_assault_cuirass_debuff",{duration = -1})
		end
	end
end 

modifier_assault_cuirass_buff = modifier_assault_cuirass_buff or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
})

function modifier_assault_cuirass_buff:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,   
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs 
end 
function modifier_assault_cuirass_buff:GetModifierAttackSpeedBonus_Constant()
	if not self:GetParent():HasModifier("modifier_assault_cuirass") then 
		self:Destroy()
		return 0
	end
	return self:GetAbility():GetSpecialValueFor("aura_bonus_spd") 
end
function modifier_assault_cuirass_buff:GetModifierPhysicalArmorBonus() 
	if not self:GetParent():HasModifier("modifier_assault_cuirass") then 
		self:Destroy()
		return 0
	end
	return self:GetAbility():GetSpecialValueFor("aura_bonus_armor") 
end

modifier_assault_cuirass_debuff = modifier_assault_cuirass_debuff or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
})

function modifier_assault_cuirass_debuff:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,   
	}
	return funcs 
end 
function modifier_assault_cuirass_debuff:GetModifierPhysicalArmorBonus() 
	if not self:GetParent():HasModifier("modifier_assault_cuirass") then 
		self:Destroy()
		return 0
	end 
	return self:GetAbility():GetSpecialValueFor("aura_debuff_armor") 
end