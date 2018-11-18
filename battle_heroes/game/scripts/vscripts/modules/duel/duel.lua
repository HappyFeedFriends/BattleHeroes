DOTA_DUEL_STATUS_NONE = 0
DOTA_DUEL_STATUS_WATING = 1
DOTA_DUEL_STATUS_IN_PROGRESS = 2
require("modules/duel/data")
if Duel == nil then
	_G.Duel = class({})
	Duel.TimeUntilDuel = 0
	Duel.DuelTimerEndTime = 0
	Duel.DuelStatus = DOTA_DUEL_STATUS_NONE
	Duel.EntIndexer = {}
	Duel.TimesTeamWins = {}
	Duel.AnnouncerCountdownCooldowns = {}
	Duel.DuelCounter = 0
end

function Duel:SetDuelTimer(duration)
	Duel.DuelTimerEndTime = GameRules:GetGameTime() + duration
end

function Duel:CreateGlobalTimer()
	Duel.DuelStatus = DOTA_DUEL_STATUS_WATING
	Duel:SetDuelTimer(-GameRules:GetDOTATime(false, true))
	Timers:CreateTimer(Dynamic_Wrap(Duel, 'GlobalThink'))
end

local triggerBox
function Duel:IsOnDuel(vector)
	if not triggerBox then
		local trigger = Entities:FindByName(nil, "trigger_duel_zone")
		local origin = trigger:GetAbsOrigin()
		triggerBox = {
			origin + ExpandVector(trigger:GetBoundingMins(), 96),
			origin + ExpandVector(trigger:GetBoundingMaxs(), 96),
		}
	end
	return IsInBox(vector, triggerBox[1], triggerBox[2])
end

function Duel:GlobalThink()
	local now = GameRules:GetGameTime()
	for i = 1, 10 do
		local diff = now + i - Duel.DuelTimerEndTime
		if diff < 0.3 and diff > 0 and (not Duel.AnnouncerCountdownCooldowns[i] or now > Duel.AnnouncerCountdownCooldowns[i]) then
			Duel.AnnouncerCountdownCooldowns[i] = now + 1
			if i < 10 then i = "0" .. i end
			EmitAnnouncerSound("announcer_ann_custom_countdown_" .. i)
		end
	end
	if now >= Duel.DuelTimerEndTime then
		if Duel.DuelStatus == DOTA_DUEL_STATUS_IN_PROGRESS then
			Duel:EndDuel()
		elseif Duel.DuelStatus == DOTA_DUEL_STATUS_WATING then
			Duel:StartDuel()
		end
	end
	if Duel:IsDuelOngoing() then
		Duel:EventTimer( "#duel_end", Duel.DuelTimerEndTime - now)
	else
		Duel:EventTimer( "#next_duel", Duel.DuelTimerEndTime - now)
	end
	return 0.2
end

function Duel:EventTimer(text, time)
    local minutes = math.floor(time / 60)
    local seconds = time - (minutes * 60)
	seconds = math.round(seconds)
	minutes = math.round(minutes)
    local m10 = math.floor(minutes / 10)
    local m01 = minutes - (m10 * 10)
    local s10 = math.floor(seconds / 10)
    local s01 = seconds - (s10 * 10)    
    local timer_text = m10 .. m01 .. ":" .. s10 .. s01
    local text_color = "#FFFFFF"
    if time < 20 then
    	text_color = "#FF0000"
    end

    local data = 
    {
    	string = text,
    	time_string = timer_text,
    	color = text_color,
	}
    CustomGameEventManager:Send_ServerToAllClients( "duel_text_update", data )

end

function Duel:StartDuel()
	Duel.heroes_teams_for_duel = {}
	for playerId = 0, DOTA_MAX_TEAM_PLAYERS - 1  do
		if PlayerResource:IsValidPlayerID(playerId) and not PlayerResource:IsPlayerAbandoned(playerId) then
			local team = PlayerResource:GetTeam(playerId)
			local hero = PlayerResource:GetSelectedHeroEntity(playerId)
			if IsValidEntity(hero) then
				Duel.heroes_teams_for_duel[team] = Duel.heroes_teams_for_duel[team] or {}
				table.insert(Duel.heroes_teams_for_duel[team], hero)
			end
		end
	end
	local heroes_in_teams = {}
	for i,v in pairs(Duel.heroes_teams_for_duel) do
		for _,unit in pairs(v) do
			local playerId = unit:GetPlayerOwnerID()
			if not unit:IsAlive() then
				unit:RespawnHero(false, false)
			end
			if PlayerResource:IsValidPlayerID(playerId) then
				heroes_in_teams[i] = (heroes_in_teams[i] or 0) + 1
			end
		end
	end
	local heroes_to_fight_n = math.min(unpack(table.iterate(heroes_in_teams)))
	if heroes_to_fight_n > 0 and table.count(heroes_in_teams) > 1 then
		EmitAnnouncerSound("announcer_ann_custom_mode_20")
		Duel.IsFirstDuel = Duel.DuelCounter == 0
		Duel:SetDuelTimer(DUEL_SETTINGS.DurationBase + DUEL_SETTINGS.DurationForPlayer * heroes_to_fight_n)
		Duel.DuelStatus = DOTA_DUEL_STATUS_IN_PROGRESS
		local rndtbl = {}
		table.merge(rndtbl, Duel.heroes_teams_for_duel)
		for i,v in pairs(rndtbl) do
			if #v > 0 then
				table.shuffle(v)
				local count = 0
				repeat
					local unit = v[1]
					if IsValidEntity(unit) then
						local playerId = unit:GetPlayerOwnerID()
						if not unit.DuelChecked and unit:IsAlive() and PlayerResource:IsValidPlayerID(playerId) then
							unit.OnDuel = true
							Duel:FillPreduelUnitData(unit)
							unit:SetHealth(unit:GetMaxHealth())
							unit:SetMana(unit:GetMaxMana())
							count = count + 1
							--[[if not unit:HasModifier("modifier_check_duel") then
								unit:AddNewModifier(nil,nil,"modifier_check_duel",{duration = -1})
							end]]
						end
						unit.DuelChecked = true
					end
					table.shuffle(v)
				until count >= heroes_to_fight_n
			end
		end
		for team,tab in pairs(Duel.heroes_teams_for_duel) do
			for _,_unit in pairs(tab) do
				for _,unit in ipairs({_unit}) do
					for _,v in ipairs(DUEL_PURGED_MODIFIERS) do
						if unit:HasModifier(v) then
							unit:RemoveModifierByName(v)
						end
					end
					if _unit.OnDuel then
						unit.OnDuel = true
						unit.DuelBeforeTpLocation = unit:GetAbsOrigin()
						ProjectileManager:ProjectileDodge(unit)
						unit:Teleport(Entities:FindByName(nil, "target_team_duel_" .. team):GetAbsOrigin())
						unit:AddNewModifier(unit, nil, "modifier_magic_immune", {duration = DUEL_SETTINGS.MagicImmunityDuration})
					elseif unit:IsAlive() then
						Duel:SetUpVisitor(unit)
					end
				end
			end
		end
	else
		Duel:EndDuelLogic(false, true)
		Notifications:TopToAll({text="#duel_no_heroes", duration=3})
	end
end

function Duel:EndDuel()
	local winner = Duel:GetWinner()
	if winner then
		if winner == DOTA_TEAM_GOODGUYS then
			EmitAnnouncerSound("announcer_announcer_victory_rad")
		elseif winner == DOTA_TEAM_BADGUYS then
			EmitAnnouncerSound("announcer_announcer_victory_dire")
		end
		local goldAmount = DUEL_SETTINGS.WinGold_Base + (DUEL_SETTINGS.WinGold_PerDuel * Duel.DuelCounter)
		CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
			type = "generic",
			text = "#custom_toast_duel_end",
			team = winner,
			gold = goldAmount,
		})
		for _,t in pairs(Duel.heroes_teams_for_duel) do
			for _,v in ipairs(t) do
				if IsValidEntity(v) then
					PlayerResource:ModifyPlayerStat(v:GetPlayerID(), "Duels_Played", 1)
				end
			end
		end
		for _,v in ipairs(Duel.heroes_teams_for_duel[winner]) do
			if IsValidEntity(v) then
				Gold:ModifyGold(v,goldAmount)
				PlayerResource:ModifyPlayerStat(v:GetPlayerID(), "Duels_Won", 1)
			end
		end
		Duel.TimesTeamWins[winner] = (Duel.TimesTeamWins[winner] or 0) + 1
	else
		Notifications:TopToAll({text="#duel_over_winner_none", duration=5})
	end 
	Duel.DuelCounter = Duel.DuelCounter + 1
	Duel:EndDuelLogic(true, true)
end

function Duel:GetWinner()
	local teams = {}
	for team,tab in pairs(Duel.heroes_teams_for_duel) do
		for _,unit in pairs(tab) do
			if (
				IsValidEntity(unit) and
				unit:IsAlive() and
				not PlayerResource:IsPlayerAbandoned(unit:GetPlayerID())
		 	) then
				if not table.includes(teams, team) and unit.OnDuel then
					table.insert(teams, team)
				end
			end
		end
	end
	return #teams == 1 and teams[1] or nil
end
function Duel:SetUpVisitor(unit)
	unit.DuelBeforeTpLocation = unit.DuelBeforeTpLocation or (unit:GetUnitName() == FORCE_PICKED_HERO and FindFountain(unit:GetTeamNumber()):GetAbsOrigin() or unit:GetAbsOrigin())
	Duel:FillPreduelUnitData(unit)
	ProjectileManager:ProjectileDodge(unit)
	unit:AddNewModifier(unit, nil, "modifier_hero_out_of_game", {})
end

function Duel:EndDuelLogic(bEndForUnits, timeUpdate)
	Duel.EntIndexer = {}
	Duel.DuelStatus = DOTA_DUEL_STATUS_WATING
	Duel.heroes_teams_for_duel = {}
	if bEndForUnits then
		for playerId = 0, DOTA_MAX_TEAM_PLAYERS-1  do
			if PlayerResource:IsValidPlayerID(playerId) then
				local _hero = PlayerResource:GetSelectedHeroEntity(playerId)
				if not PlayerResource:IsPlayerAbandoned(playerId) and IsValidEntity(_hero) then
					for _,hero in ipairs({_hero}) do
						Duel:EndDuelForUnit(hero)
					end
				end
			end
		end
	end
	Events:Emit("Duel/end")


	if timeUpdate then
		local delay = table.nearestOrLowerKey(DUEL_SETTINGS.DelaysFromLast, GetDOTATimeInMinutesFull())
		Timers:CreateTimer(2, function()
			EmitAnnouncerSound("announcer_ann_custom_timer_0" .. delay/60)
		end)
		Duel:SetDuelTimer(delay)
	end
end

function Duel:EndDuelForUnit(unit)
	unit:RemoveModifierByName("modifier_hero_out_of_game")
	Timers:CreateTimer(0.1, function()
		if IsValidEntity(unit) and unit:IsAlive() and unit.StatusBeforeDuel then
			if unit.StatusBeforeDuel.Health then unit:SetHealth(unit.StatusBeforeDuel.Health) end
			if unit.StatusBeforeDuel.Mana then unit:SetMana(unit.StatusBeforeDuel.Mana) end
			for ability,v in pairs(unit.StatusBeforeDuel.AbilityCooldowns or {}) do
				if IsValidEntity(ability) and unit:HasAbility(ability:GetAbilityName()) then
					ability:EndCooldown()
					ability:StartCooldown(v)
				end
			end
			for item,v in pairs(unit.StatusBeforeDuel.ItemCooldowns or {}) do
				if IsValidEntity(item) then
					item:EndCooldown()
					item:StartCooldown(v)
				end
			end
			unit.StatusBeforeDuel = nil
		end
	end)

	if unit.Teleport then
		local pos = unit.DuelBeforeTpLocation
		if not pos then
			pos = FindFountain(unit:GetTeamNumber()):GetAbsOrigin()
		end
		ProjectileManager:ProjectileDodge(unit)
		unit:Teleport(pos)
	end
	unit.OnDuel = nil
	unit.DuelBeforeTpLocation = nil
	unit.DuelChecked = nil
end

function Duel:FillPreduelUnitData(unit)
	unit.StatusBeforeDuel = {
		Health = unit:GetHealth(),
		Mana = unit:GetMana(),
		AbilityCooldowns = {},
		ItemCooldowns = {},
	}
	for i = 0, unit:GetAbilityCount() - 1 do
		local ability = unit:GetAbilityByIndex(i)
		if ability and ability:GetCooldown(ability:GetLevel()) > 0 then
			unit.StatusBeforeDuel.AbilityCooldowns[ability] = ability:GetCooldownTimeRemaining()
			ability:EndCooldown()
		end
	end
	for i = 0, 5 do
		local item = unit:GetItemInSlot(i)
		if item then
			unit.StatusBeforeDuel.ItemCooldowns[item] = item:GetCooldownTimeRemaining()
			item:EndCooldown()
		end
	end
end

function Duel:IsDuelOngoing()
	return Duel.DuelStatus == DOTA_DUEL_STATUS_IN_PROGRESS
end

function Duel:EndIfFinished()
	if Duel:IsDuelOngoing() and Duel:GetWinner() ~= nil then
		Duel:EndDuel()
	end
end