LinkLuaModifier ("modifier_gem_shard_bh", "items/item_gem_shard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_gem_shard_bh_passive", "items/item_gem_shard", LUA_MODIFIER_MOTION_NONE)

item_gem_shard = item_gem_shard or class({
	GetIntrinsicModifierName = function(self) return "modifier_gem_shard_bh" end
})

function item_gem_shard:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_gem_shard_bh_passive",{duration = -1})
	self:GetCaster():RemoveItem(self)
end 
modifier_gem_shard_bh = modifier_gem_shard_bh or class({	
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
	IsAura					= function(self) return true end,
	GetAuraSearchFlags		= function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end,
	GetAuraSearchTeam		= function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY	 end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO end,
	GetModifierAura			= function(self) return "modifier_no_invis_bh" end,
	GetAuraRadius			= function(self) return 900 end,
	GetAttributes 			= function() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	GetTexture 				= function() return "items_custom/item_gem_shard" end
})

function modifier_gem_shard_bh:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
	}
end 

function modifier_gem_shard_bh:OnDeath(keys)
	if keys.unit == self:GetCaster() and self:GetCaster():HasItemInInventory("item_gem_shard") then
		self:GetAbility():DropItemHero(self:GetCaster())
	end 
end

modifier_gem_shard_bh_passive = modifier_gem_shard_bh