-- 1 Page
LinkLuaModifier("modifier_special_bonus_attack_speed_bh_", "modifiers/modifier_talents", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_special_bonus_attack_damage_bh_", "modifiers/modifier_talents", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_special_bonus_hp_bh_", "modifiers/modifier_talents", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_special_bonus_mp_bh_", "modifiers/modifier_talents", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_special_bonus_all_stats_bh_", "modifiers/modifier_talents", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_special_bonus_agility_bh_", "modifiers/modifier_talents", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_special_bonus_strength_bh_", "modifiers/modifier_talents", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_special_bonus_intellect_bh_", "modifiers/modifier_talents", LUA_MODIFIER_MOTION_NONE )
-- 2 Page
LinkLuaModifier("modifier_special_bonus_magic_resistance_bh_", "modifiers/modifier_talents", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_special_bonus_armor_bh_", "modifiers/modifier_talents", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_special_bonus_magic_damage_bh_", "modifiers/modifier_talents", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_special_bonus_gold_bonus_bh_", "modifiers/modifier_talents", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_special_bonus_xp_bonus_bh_", "modifiers/modifier_talents", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_special_bonus_cooldown_reduction_bh_", "modifiers/modifier_talents", LUA_MODIFIER_MOTION_NONE )

local modifier_talent_base = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end,
})

-----------------------------
--  Bonus Magical Damage   --
-----------------------------
modifier_special_bonus_magic_damage_bh_ = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})

function modifier_special_bonus_magic_damage_bh_:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE }
	return funcs
end

function modifier_special_bonus_magic_damage_bh_:GetModifierSpellAmplify_Percentage()
	return self:GetStackCount()
end

-----------------------------
--       Bonus Gold(CREEP) --
-----------------------------
modifier_special_bonus_gold_bonus_bh_ = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})

function modifier_special_bonus_gold_bonus_bh_:GetModifierBonusGoldCreep()
	return self:GetStackCount()
end

-----------------------------
--       Bonus XP(CREEP)   --
-----------------------------
modifier_special_bonus_xp_bonus_bh_ = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})

function modifier_special_bonus_xp_bonus_bh_:GetModifierBonusXPCreep()
	return self:GetStackCount()
end

-----------------------------
--	       Armor     	   --
-----------------------------
modifier_special_bonus_armor_bh_ = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})

function modifier_special_bonus_armor_bh_:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
	return funcs
end

function modifier_special_bonus_armor_bh_:GetModifierPhysicalArmorBonus()
	return self:GetStackCount()
end

-----------------------------
--	 Cooldown Reduction    --
-----------------------------
modifier_special_bonus_cooldown_reduction_bh_ = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})

function modifier_special_bonus_cooldown_reduction_bh_:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT }
	return funcs
end

function modifier_special_bonus_cooldown_reduction_bh_:GetModifierCooldownReduction_Constant()
	return self:GetStackCount()
end

-----------------------------
--	  Magic Resistance     --
-----------------------------
modifier_special_bonus_magic_resistance_bh_ = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})

function modifier_special_bonus_magic_resistance_bh_:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS }
	return funcs
end

function modifier_special_bonus_magic_resistance_bh_:GetModifierMagicalResistanceBonus()
	return self:GetStackCount()
end

-----------------------------
--		    Damage         --
-----------------------------
modifier_special_bonus_attack_damage_bh_ = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})

function modifier_special_bonus_attack_damage_bh_:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
	return funcs
end

function modifier_special_bonus_attack_damage_bh_:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end


-----------------------------
--		  All Stats        --
-----------------------------
modifier_special_bonus_all_stats_bh_ = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})

function modifier_special_bonus_all_stats_bh_:DeclareFunctions()
	local funcs = { 
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
	return funcs
end

function modifier_special_bonus_all_stats_bh_:GetModifierBonusStats_Agility()
	return self:GetStackCount()
end
function modifier_special_bonus_all_stats_bh_:GetModifierBonusStats_Intellect()
	return self:GetStackCount()
end
function modifier_special_bonus_all_stats_bh_:GetModifierBonusStats_Strength()
	return self:GetStackCount()
end

-----------------------------
--		  Strength         --
-----------------------------
modifier_special_bonus_strength_bh_ = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})
function modifier_special_bonus_strength_bh_:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS }
	return funcs
end

function modifier_special_bonus_strength_bh_:GetModifierBonusStats_Strength()
	return self:GetStackCount()
end

function modifier_special_bonus_strength_bh_:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.01, function()
			self:GetParent():CalculateStatBonus()
		end)
	end
end
-----------------------------
--		  Agility         --
-----------------------------
modifier_special_bonus_agility_bh_ = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})
function modifier_special_bonus_agility_bh_:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_STATS_AGILITY_BONUS }
	return funcs
end

function modifier_special_bonus_agility_bh_:GetModifierBonusStats_Agility()
	return self:GetStackCount()
end

function modifier_special_bonus_agility_bh_:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.01, function()
			self:GetParent():CalculateStatBonus()
		end)
	end
end

-----------------------------
--		Intelligence       --
-----------------------------
modifier_special_bonus_intellect_bh_ = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})
function modifier_special_bonus_intellect_bh_:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_STATS_INTELLECT_BONUS }
	return funcs
end

function modifier_special_bonus_intellect_bh_:GetModifierBonusStats_Intellect()
	return self:GetStackCount()
end

function modifier_special_bonus_intellect_bh_:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.01, function()
			self:GetParent():CalculateStatBonus()
		end)
	end
end

-----------------------------
--	     Attack Speed      --
-----------------------------
modifier_special_bonus_attack_speed_bh_ = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})
function modifier_special_bonus_attack_speed_bh_:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }
	return funcs
end

function modifier_special_bonus_attack_speed_bh_:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end


-----------------------------
--	       Health          --
-----------------------------
modifier_special_bonus_hp_bh_ = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})
function modifier_special_bonus_hp_bh_:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_HEALTH_BONUS }
	return funcs
end

function modifier_special_bonus_hp_bh_:GetModifierHealthBonus()
	return self:GetStackCount()
end

function modifier_special_bonus_hp_bh_:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.01, function()
			self:GetParent():CalculateStatBonus()
		end)
	end
end

-----------------------------
--	       Mana            --
-----------------------------

modifier_special_bonus_mp_bh_ = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})
function modifier_special_bonus_mp_bh_:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MANA_BONUS }
	return funcs
end

function modifier_special_bonus_mp_bh_:GetModifierManaBonus()
	return self:GetStackCount()
end

function modifier_special_bonus_mp_bh_:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.01, function()
			self:GetParent():CalculateStatBonus()
		end)
	end
end
