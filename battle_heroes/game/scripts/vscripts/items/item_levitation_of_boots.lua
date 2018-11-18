LinkLuaModifier("modifier_levitation_boots", "items/item_levitation_of_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_levitation_boots_active", "items/item_levitation_of_boots", LUA_MODIFIER_MOTION_NONE)
item_levitation_of_boots = item_levitation_of_boots or class({})

function item_levitation_of_boots:GetIntrinsicModifierName()
	return "modifier_levitation_boots"
end

function item_levitation_of_boots:OnSpellStart()
	local caster  = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_levitation_boots_active",{duration = self:GetSpecialValueFor("duration")})
end 

modifier_levitation_boots = modifier_levitation_boots or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_levitation_boots:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end

function modifier_levitation_boots:GetModifierMoveSpeedBonus_Special_Boots() return self:GetAbility():GetSpecialValueFor("movespeed_bonus") end
function modifier_levitation_boots:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end

modifier_levitation_boots_active = modifier_levitation_boots_active or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_levitation_boots_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_levitation_boots_active:OnCreated() 
	self.spd = self:GetCaster():IsRangedAttacker() and self:GetAbility():GetSpecialValueFor("bonus_move_range") or self:GetAbility():GetSpecialValueFor("bonus_move_melee") 
end 
function modifier_levitation_boots_active:GetModifierMoveSpeedBonus_Percentage() return self.spd end 
function modifier_levitation_boots_active:CheckState() return { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true} end 