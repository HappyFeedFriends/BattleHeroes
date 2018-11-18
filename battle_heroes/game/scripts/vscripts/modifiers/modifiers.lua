modifier_hero_out_of_game = class({
	IsHidden =      function() return true end,
	IsPurgable =    function() return false end,
	IsPermanent =   function() return true end,
	RemoveOnDeath = function() return false end,
})

function modifier_hero_out_of_game:CheckState()
	return {
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_BLIND] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_HEXED] = true
	}
end

if IsServer() then
	function modifier_hero_out_of_game:OnCreated()
		self:GetParent():AddNoDraw()
	end

	function modifier_hero_out_of_game:OnDestroy()
		self:GetParent():RemoveNoDraw()
	end
end

modifier_check_duel = class({
	IsHidden =      function() return true end,
	IsPurgable =    function() return false end,
	IsPermanent =   function() return true end,
	RemoveOnDeath = function() return false end,
})

function modifier_check_duel:OnCreated()
	self:StartIntervalThink(0.1)
end 

function modifier_check_duel:OnIntervalThink()
	if Duel:IsDuelOngoing() and self:GetParent().OnDuel and not IsInBox(Vector(self:GetParent():GetAbsOrigin().x,self:GetParent():GetAbsOrigin().y,0), Duel.BlockerBox[1], Duel.BlockerBox[2]) then
		Containers:DisplayError(self:GetParent():GetPlayerID(), "#duel_error_uses")
		self:GetParent():Teleport(Entities:FindByName(nil, "target_team_duel_" .. self:GetParent():GetTeam()):GetAbsOrigin())
	end 
end 

modifier_creep_attack_speed_bonus = class({
	IsHidden =      function() return true end,
	IsPurgable =    function() return false end,
	IsBuff =        function() return true end,
	RemoveOnDeath = function() return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end,
})

function modifier_creep_attack_speed_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_creep_attack_speed_bonus:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end

modifier_magic_immune_bh = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})

function modifier_magic_immune_bh:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_magic_immune_bh:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
 
function modifier_magic_immune_bh:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

modifier_invulnerability_bh = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes 			= function() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_invulnerability_bh:GetEffectName()
    return "particles/battle_heroes/bkb/godly_bkb.vpcf"
end

function modifier_invulnerability_bh:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
 
function modifier_invulnerability_bh:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true
	}
end

modifier_true_strike_bh = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes 			= function() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})
 
function modifier_true_strike_bh:CheckState()
	return {
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
end

modifier_no_invis_bh = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetPriority             = function(self) return 99999 end,
	GetAttributes 			= function() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})
 
function modifier_no_invis_bh:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = false
	}
end

modifier_movespeed_slow_bh = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	DeclareFunctions		= function(self) return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end,
})

function modifier_movespeed_slow_bh:OnCreated(kv)
	self.slow = kv.slow
	if IsServer() then
		Timers:CreateTimer(0.01, function()
			self:GetParent():CalculateStatBonus()
		end)
	end
end 
function modifier_movespeed_slow_bh:GetModifierMoveSpeedBonus_Constant() return self.slow end

modifier_movespeed_slow_procentage_bh = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	DeclareFunctions		= function(self) return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end,
})

function modifier_movespeed_slow_procentage_bh:OnCreated(kv)
	self.slow = kv.slow
	if IsServer() then
		Timers:CreateTimer(0.01, function()
			self:GetParent():CalculateStatBonus()
		end)
	end
end 
function modifier_movespeed_slow_procentage_bh:GetModifierMoveSpeedBonus_Percentage() return self.slow end

modifier_max_speed_mutation_bh = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	DeclareFunctions		= function(self) return {MODIFIER_PROPERTY_MOVESPEED_MAX,MODIFIER_PROPERTY_MOVESPEED_LIMIT} end,
})
function modifier_max_speed_mutation_bh:GetModifierMoveSpeed_Max()
	return 900
end
function modifier_max_speed_mutation_bh:GetModifierMoveSpeed_Limit()
	return 900
end