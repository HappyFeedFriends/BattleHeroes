item_swap_team = item_swap_team or class({})

function item_swap_team:OnSpellStart()
	local caster = self:GetCaster()
	if not caster:IsRealHero() or Duel:IsDuelOngoing() then
		Containers:DisplayError(caster:GetPlayerID(), "#duel_error_uses")
		return
	end
	local oldTeam = caster:GetTeamNumber()
	local newTeam = oldTeam == DOTA_TEAM_BADGUYS and DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS
	--[[
	if oldTeam == DOTA_TEAM_BADGUYS then
		oldTeam = DOTA_TEAM_GOODGUYS
	else
		oldTeam = DOTA_TEAM_BADGUYS
	end 
	]]
	if GetTeamPlayerCount(newTeam) >= GetTeamPlayerCount(oldTeam) then
		Containers:DisplayError(caster:GetPlayerID(), "#bh_error_swap_team_2")
		return
	end

	GameRules:SetCustomGameTeamMaxPlayers(newTeam, GameRules:GetCustomGameTeamMaxPlayers(newTeam) + 1)
	PlayerResource:SetPlayerTeam(caster:GetPlayerID(), newTeam)
	GameRules:SetCustomGameTeamMaxPlayers(oldTeam, GameRules:GetCustomGameTeamMaxPlayers(oldTeam) - 1)
	FindClearSpaceForUnit(caster, FindFountain(newTeam):GetAbsOrigin(), true)
	self:SpendCharge()
end