tinker_rearm_bh = tinker_rearm_bh or class({})
local ACT_DOTA_TINKER_REARM = ACT_DOTA_TINKER_REARM1 - 1
function tinker_rearm_bh:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Tinker.RearmStart")
	--if self:GetCaster():GetUnitName():find("tinker") then
		self:GetCaster():StartGesture(ACT_DOTA_TINKER_REARM + tonumber(self:GetLevel() > 3 and 3 or self:GetLevel()))
	--end
end 
function tinker_rearm_bh:OnChannelFinish(i)
	if not i then
		self:GetCaster():RefreshingTinker(self:GetSpecialValueFor("channel_tooltip"))
	end
end  
