LinkLuaModifier ("modifier_blade_mail_bh", "items/item_blade_mail", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_blade_mail_bh_buff", "items/item_blade_mail", LUA_MODIFIER_MOTION_NONE)
item_blade_mail_1 = item_blade_mail_1 or class({})
item_blade_mail_2 = item_blade_mail_1 or class({})
item_blade_mail_3 = item_blade_mail_1 or class({})
item_blade_mail_4 = item_blade_mail_1 or class({})
item_blade_mail_5 = item_blade_mail_1 or class({})

function item_blade_mail_1:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_blade_mail_bh",{duration = self:GetSpecialValueFor("duration")})
end 

function item_blade_mail_1:GetIntrinsicModifierName()
    return "modifier_blade_mail_bh_buff"
end

modifier_blade_mail_bh = modifier_blade_mail_bh or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end,
})

function modifier_blade_mail_bh:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,		
	}
	return funcs
end

function modifier_blade_mail_bh:OnTakeDamage(params)
	if IsServer() then
		local damage = params.original_damage  / 100 * self:GetAbility():GetSpecialValueFor("reflect_damage")
		local unit = self:GetParent()
		local ability = self:GetAbility()
		if unit == params.unit and SimpleDamageReflect(unit, params.attacker, damage, params.damage_flags, ability, params.damage_type) then
			params.attacker:EmitSound("DOTA_Item.BladeMail.Damage")
		end
	end
end

function modifier_blade_mail_bh:GetEffectName()
    return "particles/items_fx/blademail.vpcf"
end

function modifier_blade_mail_bh:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

modifier_blade_mail_bh_buff = modifier_blade_mail_bh_buff or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end,
})

function modifier_blade_mail_bh_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end
function modifier_blade_mail_bh_buff:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
function modifier_blade_mail_bh_buff:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("bonus_armor") end
function modifier_blade_mail_bh_buff:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end