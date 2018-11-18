LinkLuaModifier("modifier_dragon_breath_bh", "items/item_dragons_breath", LUA_MODIFIER_MOTION_NONE)
item_dragons_breath_1 = item_dragons_breath_1 or class({
	GetIntrinsicModifierName = function(self) return "modifier_dragon_breath_bh" end,
})
item_dragons_breath_2 = item_dragons_breath_1 or class({})
item_dragons_breath_3 = item_dragons_breath_1 or class({})
item_dragons_breath_4 = item_dragons_breath_1 or class({})
item_dragons_breath_5 = item_dragons_breath_1 or class({})

function item_dragons_breath_1:OnSpellStart()
	local damage = self:GetSpecialValueFor("damage")
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local slow = self:GetSpecialValueFor("slow")
	local max = self:GetSpecialValueFor("max_target") - 1
	CreateParticleDragon(self:GetCaster(),self:GetCursorTarget(),damage)
	local damage_table =
	{
		victim = self:GetCursorTarget(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
	}
	ApplyDamage(damage_table)
	self:GetCursorTarget():AddNewModifier(self:GetCaster(),self,"modifier_movespeed_slow_procentage_bh",{
		duration = duration,
		slow = slow
	})
	local units = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCursorTarget():GetAbsOrigin(), nil,radius,self:GetAbilityTargetTeam(), self:GetAbilityTargetType(),self:GetAbilityTargetFlags(),FIND_CLOSEST,false)
	for _,v in pairs(units) do
		if max > 0 and v ~= self:GetCursorTarget() and  not v:IsMagicImmune() and not v:IsInvulnerable() and not v:IsInvisible() then
			CreateParticleDragon(self:GetCursorTarget(),v,damage)
			damage_table.victim = v
			ApplyDamage(damage_table)
			max = max - 1
		end
	end
end

function CreateParticleDragon(caster,target,damage)
	local particle = ParticleManager:CreateParticle("particles/econ/events/ti4/dagon_ti4.vpcf",PATTACH_POINT, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT, "attach_attack1", caster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(particle, 2, Vector(damage,0,0))
end

modifier_dragon_breath_bh = modifier_dragon_breath_bh or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_dragon_breath_bh:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
end

function modifier_dragon_breath_bh:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("all_stats") end
function modifier_dragon_breath_bh:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("all_stats") end
function modifier_dragon_breath_bh:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("intellect") + self:GetAbility():GetSpecialValueFor("all_stats") end