LinkLuaModifier ("modifier_scythe_of_vyse_bh", "items/item_scythe_of_vyse", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_scythe_of_vyse_bh_debuff", "items/item_scythe_of_vyse", LUA_MODIFIER_MOTION_NONE)
item_scythe_of_vyse_1 = item_scythe_of_vyse_1 or class({})
item_scythe_of_vyse_2 = item_scythe_of_vyse_1 or class({})
item_scythe_of_vyse_3 = item_scythe_of_vyse_1 or class({})
item_scythe_of_vyse_4 = item_scythe_of_vyse_1 or class({})
item_scythe_of_vyse_5 = item_scythe_of_vyse_1 or class({})

function item_scythe_of_vyse_1:GetIntrinsicModifierName()
    return "modifier_scythe_of_vyse_bh"
end

function item_scythe_of_vyse_1:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	local dur = self:GetSpecialValueFor("duration")
	if target:IsIllusion() then
			target:Kill(self, caster)
	elseif not target:TriggerSpellAbsorb(self) then
		target:TriggerSpellReflect(self)
		target:EmitSound("DOTA_Item.Sheepstick.Activate")
		target:AddNewModifier(caster,self,"modifier_scythe_of_vyse_bh_debuff",{duration = dur})
	end
end  

modifier_scythe_of_vyse_bh = modifier_scythe_of_vyse_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})
function modifier_scythe_of_vyse_bh:OnCreated()
	self:StartIntervalThink(0.2)
end 
function modifier_scythe_of_vyse_bh:OnIntervalThink()
	if IsServer() and self:GetAbility():GetLevel() >= 3 and self:GetAbility():IsCooldownReady() and self:GetCaster():IsRealHero() then
	local radius = self:GetAbility():GetSpecialValueFor("range_tooltip")
		local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetOrigin(),
		nil,
		radius, 
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		self:GetAbility():GetAbilityTargetFlags(),
		FIND_CLOSEST, 
		false )
		local target_count = 0
		for _,target in pairs(units) do
			if target_count < 1 and not (target:IsHexed() and target:IsBoss() and target:IsInvisible() and target:IsInvulnerable() and target:IsMagicImmune()) then
				if not target:TriggerSpellAbsorb(self:GetAbility()) then
					target:TriggerSpellReflect(self:GetAbility())
					target:EmitSound("DOTA_Item.Sheepstick.Activate")
					target:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_scythe_of_vyse_bh_debuff",{duration = self:GetAbility():GetSpecialValueFor("duration")})
					self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
				else
					self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
				end
				target_count = target_count + 1
			end 
		end 
	end 
end 
function modifier_scythe_of_vyse_bh:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs 
end

function modifier_scythe_of_vyse_bh:GetModifierBonusStats_Strength()return self:GetAbility():GetSpecialValueFor("bonus_strength") end 
function modifier_scythe_of_vyse_bh:GetModifierBonusStats_Agility()return self:GetAbility():GetSpecialValueFor("bonus_agility") end 
function modifier_scythe_of_vyse_bh:GetModifierBonusStats_Intellect()return self:GetAbility():GetSpecialValueFor("bonus_intellect") end 

modifier_scythe_of_vyse_bh_debuff = modifier_scythe_of_vyse_bh_debuff or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})

function modifier_scythe_of_vyse_bh_debuff:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}
	return funcs 
end

function modifier_scythe_of_vyse_bh_debuff:GetModifierModelChange()
	return "models/items/hex/sheep_hex/sheep_hex.vmdl"
end

function modifier_scythe_of_vyse_bh_debuff:CheckState()
	return {
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}
end

function modifier_scythe_of_vyse_bh_debuff:GetModifierMoveSpeed_Limit()return self:GetAbility():GetSpecialValueFor("base_movespeed") end
function modifier_scythe_of_vyse_bh_debuff:GetModifierMoveSpeed_Max	()return self:GetAbility():GetSpecialValueFor("base_movespeed") end