item_book_of_strength_25 = item_book_of_strength_25 or class({})
item_book_of_strength_50 = item_book_of_strength_25 or class({})
item_book_of_strength_75 = item_book_of_strength_25 or class({})

item_book_of_agility_25 = item_book_of_agility_25 or class({})
item_book_of_agility_50 = item_book_of_agility_25 or class({})
item_book_of_agility_75 = item_book_of_agility_25 or class({})

item_book_of_intellect_25 = item_book_of_intellect_25 or class({})
item_book_of_intellect_50 = item_book_of_intellect_25 or class({})
item_book_of_intellect_75 = item_book_of_intellect_25 or class({})

item_stone_of_all_15 = item_stone_of_all_15 or class({})
item_stone_of_all_30 = item_stone_of_all_15 or class({})
item_stone_of_all_60 = item_stone_of_all_15 or class({})

item_stone_of_lvl_1 = item_stone_of_lvl_1 or class({})
item_stone_of_lvl_10 = item_stone_of_lvl_1 or class({})

function item_book_of_strength_25:OnSpellStart()
	if not self:GetCaster():IsTrueHero() then Containers:DisplayError(self:GetCaster():GetPlayerID(), "#hud_error_clone_used") return end
	self:GetCaster():ModifyStrength(self:GetSpecialValueFor("strength"))
	self:SpendCharge()
end

function item_book_of_agility_25:OnSpellStart()
	if not self:GetCaster():IsTrueHero() then Containers:DisplayError(self:GetCaster():GetPlayerID(), "#hud_error_clone_used") return end
	self:GetCaster():ModifyAgility(self:GetSpecialValueFor("agility"))
	self:SpendCharge()
end

function item_book_of_intellect_25:OnSpellStart()
	if not self:GetCaster():IsTrueHero() then Containers:DisplayError(self:GetCaster():GetPlayerID(), "#hud_error_clone_used") return end
	self:GetCaster():ModifyIntellect(self:GetSpecialValueFor("intellect"))
	self:SpendCharge()
end 

function item_stone_of_all_15:OnSpellStart()
	if not self:GetCaster():IsTrueHero() then Containers:DisplayError(self:GetCaster():GetPlayerID(), "#hud_error_clone_used") return end
	self:GetCaster():ModifyIntellect(self:GetSpecialValueFor("bonus_all"))
	self:GetCaster():ModifyAgility(self:GetSpecialValueFor("bonus_all"))
	self:GetCaster():ModifyStrength(self:GetSpecialValueFor("bonus_all"))
	self:SpendCharge()
end

function item_stone_of_lvl_1:OnSpellStart()
	if not self:GetCaster():IsTrueHero() then Containers:DisplayError(self:GetCaster():GetPlayerID(), "#hud_error_clone_used") return end
	CommandsLevel(self:GetCaster(),self:GetSpecialValueFor("lvl"))
	self:SpendCharge()
end 