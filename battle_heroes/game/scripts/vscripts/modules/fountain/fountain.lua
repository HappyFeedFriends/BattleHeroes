local FOUNTAIN_EFFECTIVE_TIME_THRESHOLD = 35
local FOUNTAIN_PERCENTAGE_MANA_REGEN = 15
local FOUNTAIN_PERCENTAGE_HEALTH_REGEN = 15
local FOUNTAIN_RADIUS = 1200
local FOUNTAIN_DAMAGE_PER_SEC = 6

local function GetTimeOffProtection()
	return GameRules:GetDOTATime(false, false)/60 <= FOUNTAIN_EFFECTIVE_TIME_THRESHOLD
end

function FountainThink()
	if not GetTimeOffProtection() then
		Notifications:TopToAll({ text = "Fountain_disabled", duratition = 6,style = {color="red"}})
		return nil
	end 
	return 1
end 

modifier_fountain_protect_bh_aura = class({
	IsPurgable =                          function() return false end,
	IsHidden = 							  function() return true end,
	GetAuraRadius =                       function() return FOUNTAIN_RADIUS end,
	GetAuraSearchFlags = 				  function() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end,
	GetAuraSearchTeam = 				  function() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
	GetAuraSearchType = 				  function() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura = 				  	  function() return "modifier_fountain_protect_bh" end,
	IsAura = 				 			  function() return  true end,
	GetAuraDuration = 					  function() return 0.1 end,
})
	
modifier_fountain_protect_bh = class({
	IsPurgable =                          	function() return false end,
	IsHidden = 							  	function() return false end,
	IsBuff = 								function() return true end,
	GetModifierHealthRegenPercentage =    	function() return FOUNTAIN_PERCENTAGE_MANA_REGEN end,
	GetModifierTotalPercentageManaRegen = 	function() return FOUNTAIN_PERCENTAGE_HEALTH_REGEN end,
	GetAbsoluteNoDamagePhysical =			function() return GetTimeOffProtection() and 1 or 0 end,
	GetAbsoluteNoDamageMagical =  			function() return GetTimeOffProtection() and 1 or 0 end,
	GetAbsoluteNoDamagePure =     			function() return GetTimeOffProtection() and 1 or 0 end,
	OnTooltip =                  			function() return FOUNTAIN_EFFECTIVE_TIME_THRESHOLD end,
	GetTexture =                  			function() return "modifier_invulnerable" end,
})
	
function modifier_fountain_protect_bh:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_fountain_protect_bh:CheckState()
	return {
		[MODIFIER_STATE_ATTACK_IMMUNE] = GetTimeOffProtection(),
		[MODIFIER_STATE_MAGIC_IMMUNE] = GetTimeOffProtection(),
	}
end

modifier_fountain_protect_bh_aura_enemy = class({
	IsPurgable =                          function() return false end,
	IsHidden = 							  function() return true end,
	GetAuraRadius =                       function() return FOUNTAIN_RADIUS end,
	GetAuraSearchFlags = 				  function() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end,
	GetAuraSearchTeam = 				  function() return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchType = 				  function() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura = 				  	  function() return "modifier_fountain_protect_bh_enemy" end,
	IsAura = 				 			  function() return  true end,
})

modifier_fountain_protect_bh_enemy = class({
	IsPurgable =                          	function() return false end,
	IsHidden = 							  	function() return true end,
	OnTooltip =                  		  	function() return FOUNTAIN_DAMAGE_PER_SEC end,
})
function modifier_fountain_protect_bh_enemy:OnCreated()
	self:StartIntervalThink(1)
	self:OnIntervalThink()
end
	
function modifier_fountain_protect_bh_enemy:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_fountain_protect_bh_enemy:OnIntervalThink()
	if IsServer() then
	local parent = self:GetParent()
	local fountain = self:GetCaster()
		if GetTimeOffProtection() then
			Timers:CreateTimer(0.1, function()
				if IsValidEntity(parent) then
					local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf", PATTACH_ABSORIGIN, fountain)
					ParticleManager:SetParticleControl(pfx, 0, fountain:GetAbsOrigin() + Vector(0,0,224))
					ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
					parent:KillTarget(fountain)
				end
			end)
		else
			ApplyDamage({
				attacker = fountain,
				victim = parent,
				damage = parent:GetMaxHealth() * self:OnTooltip() * 0.01,
				damage_type = DAMAGE_TYPE_PURE,
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
			})
		end
	end
end

