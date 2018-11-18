----------------
--	BOSS LOOT --
----------------
LinkLuaModifier ("modifier_god_blood_bh", "items/boss_loot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_frozen_soul_bh", "items/boss_loot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_fire_soul_bh", "items/boss_loot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_demonic_hearth_bh", "items/boss_loot", LUA_MODIFIER_MOTION_NONE)
item_god_blood = item_god_blood or class({})
item_frozen_soul = item_frozen_soul or class({})
item_fire_soul = item_fire_soul or class({})
item_demonic_hearth = item_demonic_hearth or class({})

function item_god_blood:GetIntrinsicModifierName() return "modifier_god_blood_bh" end
function item_frozen_soul:GetIntrinsicModifierName() return "modifier_frozen_soul_bh" end
function item_fire_soul:GetIntrinsicModifierName() return "modifier_fire_soul_bh" end
function item_demonic_hearth:GetIntrinsicModifierName() return "modifier_demonic_hearth_bh" end

--------------------------------------------------------------
--				 Demonic Hearth Modifier					    --
--------------------------------------------------------------
modifier_demonic_hearth_bh = modifier_demonic_hearth_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})

function modifier_demonic_hearth_bh:GetAttackLifeSteal()
	return	self:GetAbility():GetSpecialValueFor("lifesteal")
end

--------------------------------------------------------------
--				  God Blood Modifier					    --
--------------------------------------------------------------
modifier_god_blood_bh = modifier_god_blood_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})

function modifier_god_blood_bh:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, 
	}
	return funcs
end

function modifier_god_blood_bh:GetModifierPreAttack_BonusDamage()
	return	self:GetAbility():GetSpecialValueFor("damage")
end
--------------------------------------------------------------
--				  Frozen Soul Modifier					    --
--------------------------------------------------------------
modifier_frozen_soul_bh = modifier_frozen_soul_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})

function modifier_frozen_soul_bh:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,	
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,		
	}
	return funcs
end
function modifier_frozen_soul_bh:GetModifierPreAttack_BonusDamage()return self:GetAbility():GetSpecialValueFor("damage") end
function modifier_frozen_soul_bh:GetModifierBonusStats_Intellect()return self:GetAbility():GetSpecialValueFor("all_stats") end
function modifier_frozen_soul_bh:GetModifierBonusStats_Agility()return self:GetAbility():GetSpecialValueFor("all_stats") end
function modifier_frozen_soul_bh:GetModifierBonusStats_Strength()return self:GetAbility():GetSpecialValueFor("all_stats") end

--------------------------------------------------------------
--				  Fire Soul Modifier					    --
--------------------------------------------------------------
modifier_fire_soul_bh = modifier_fire_soul_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end,
})

function modifier_fire_soul_bh:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,		
	}
	return funcs
end

function modifier_fire_soul_bh:OnTakeDamage(params)
	if self:GetParent() == params.unit and SimpleDamageReflect(self:GetParent(), params.attacker, params.original_damage / 100 * self:GetAbility():GetSpecialValueFor("reflect_damage"), params.damage_flags, self:GetAbility(), params.damage_type) then
	end
end