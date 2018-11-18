LinkLuaModifier("modifier_veil_of_discord_bh", "items/item_veil_of_discord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veil_of_discord_bh_debuff", "items/item_veil_of_discord", LUA_MODIFIER_MOTION_NONE) 
item_veil_of_discord_1 = item_veil_of_discord_1 or class({})
item_veil_of_discord_2 = item_veil_of_discord_1 or class({})
item_veil_of_discord_3 = item_veil_of_discord_1 or class({})
item_veil_of_discord_4 = item_veil_of_discord_1 or class({})
item_veil_of_discord_5 = item_veil_of_discord_1 or class({})

function item_veil_of_discord_1:GetIntrinsicModifierName()
	return "modifier_veil_of_discord_bh"
end

function item_veil_of_discord_1:OnSpellStart()
	self:GetCaster():EmitSound("DOTA_Item.VeilofDiscord.Activate")
	local point = self:GetCursorPosition()
	local dur = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),point,nil,radius, self:GetAbilityTargetTeam(),self:GetAbilityTargetType(),self:GetAbilityTargetFlags(),FIND_CLOSEST, false )
	local particle = ParticleManager:CreateParticle(  "particles/items2_fx/veil_of_discord.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle, 0, point)
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(particle, 2, Vector(radius, radius, radius))
	for _,target in pairs(units) do
		target:AddNewModifier(self:GetCaster(),self,"modifier_veil_of_discord_bh_debuff",{duration = dur})
	end 
end

modifier_veil_of_discord_bh = modifier_veil_of_discord_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_veil_of_discord_bh:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end
function modifier_veil_of_discord_bh:GetModifierBonusStats_Strength()return self:GetAbility():GetSpecialValueFor("bonus_strength") end
function modifier_veil_of_discord_bh:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_agility") end
function modifier_veil_of_discord_bh:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
function modifier_veil_of_discord_bh:GetModifierHealthBonus() return self:GetAbility():GetSpecialValueFor("bonus_health") end
function modifier_veil_of_discord_bh:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("bonus_armor") end

modifier_veil_of_discord_bh_debuff = modifier_veil_of_discord_bh_debuff or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
})

function modifier_veil_of_discord_bh_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_veil_of_discord_bh_debuff:GetEffectName()
    return "particles/items2_fx/veil_of_discord_debuff.vpcf"
end

function modifier_veil_of_discord_bh_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_veil_of_discord_bh_debuff:GetModifierMagicalResistanceBonus() return self:GetAbility():GetSpecialValueFor("reduction_magic") end