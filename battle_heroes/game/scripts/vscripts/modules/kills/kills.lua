if not kills then
	kills = ({})
end
ModuleRequire(...,"data")
function kills:OnEntityKilled(killer,killedUnit)
	local data
	if killer:IsHero() and not killedUnit:IsCourier() then
		data = 
		{
			type = "kill",
			killerPlayer = killer:GetPlayerID(),
			victimPlayer = killedUnit:GetPlayerID(),
			gold = kills:GetPlayerStreak(killedUnit:GetPlayerID()),
		}
		if PlayerResource:GetStreak(killedUnit:GetPlayerID()) > 1 then
			data.type = "generic"
			data.text = "#custom_toast_killed_streak"
			data.variables = {
				["{kill_streak}"] = PlayerResource:GetStreak(killedUnit:GetPlayerID()),
			}
		end 
		if killer ~= killedUnit then
			kills:ModifyGoldKill(kills:GetPlayerStreak(killedUnit:GetPlayerID()),killer,killedUnit) 
		end 
		kills:CreateCustomToast(data)
	elseif killer:IsFountain() then
		kills:KillerFountain(killer,killedUnit)
	elseif killedUnit:IsCourier() then
		kills:KilledCourier(killer,killedUnit)
	elseif killer:IsCreep() then
		kills:KillerCreeps(killer,killedUnit)
	end 
end
function kills:KillerFountain(killer,killedUnit)
		local data = {
			type = "generic",
			text = "#custom_toast_fountain",
			victimPlayer = killedUnit:GetPlayerID(),
			teamColor = killer:GetTeam(),
			team = killer:GetTeam(),
			gold = kills:GetPlayerStreak(killedUnit:GetPlayerID()),
	}
	local playerCountTeam = GetTeamPlayerCount(killer:GetTeam())
	if PlayerResource:GetStreak(killedUnit:GetPlayerID()) > 0 then
			data.text = "#custom_toast_killed_streak_fountain"
			data.variables = {
				["{PlayerTeamCount}"] = playerCountTeam,
				["{HeroCount}"] = playerCountTeam > 1 and "#custom_toast_heroes" or "#custom_toast_hero",
			}
	end
	local gold = kills:GetPlayerStreak(killedUnit:GetPlayerID()) / playerCountTeam
	for i = 0, DOTA_MAX_PLAYERS - 1 do
		if PlayerResource:IsValidPlayerID(i) and not IsPlayerAbandoned(i) and PlayerResource:GetTeam(i) == killer:GetTeam() then
			kills:ModifyGoldKill(gold,killer) 
		end
	end
	kills:CreateCustomToast(data)
end

function kills:KillerCreeps(killer,killedUnit)
	local data = {
			type = "kill",
			victimPlayer = killedUnit:GetPlayerID(),
			--gold = kills:GetPlayerStreak(killedUnit:GetPlayerID()),
	}
	kills:CreateCustomToast(data)
end 

function kills:KilledCourier(killer,killedUnit)
	data = {
		killerPlayer = killer:IsHero() and killer:GetPlayerID() or nil,
		type = "generic",
		text = "#custom_toast_courier_killed",
		teamColor = killedUnit:GetTeam(),
		team = killedUnit:GetTeam(),
		gold = KILL_STREAK_SETTINGS.COURIER_GOLD,
	}
	kills:CreateCustomToast(data)
	kills:ModifyGoldKill(KILL_STREAK_SETTINGS.COURIER_GOLD,killer)
end 

function kills:ModifyGoldKill(gold,killer)
	if not ( killer )then return end
	local plId = -1
	if killer.GetPlayerID then
		plId = killer:GetPlayerID()
	end
	if plId == -1 and killer.GetPlayerOwnerID then
		plId = killer:GetPlayerOwnerID()
	end
	if plId == -1 then return end
	Gold:ModifyGold(killer, gold) 
end 
function kills:GetGoldPerLevel(Player)
	return PlayerResource:GetSelectedHeroEntity(Player):GetLevel() * table.nearestOrLowerKey(KILL_STREAK_SETTINGS.GOLD_PER_LEVEL, PlayerResource:GetSelectedHeroEntity(Player):GetLevel())
end 

function kills:GetStreak(Player)
	return (table.nearestOrLowerKey(KILL_STREAK_SETTINGS.KILL_STREAK_GOLD, PlayerResource:GetStreak(Player)) * (PlayerResource:GetStreak(Player) > 0 and PlayerResource:GetStreak(Player) or 1))
end  

function kills:GetGoldPerMinutes(Player)
	return table.nearestOrLowerKey(KILL_STREAK_SETTINGS.PER_STREAK, GetDOTATimeInMinutesFull()) * (PlayerResource:GetStreak(Player) > 0 and PlayerResource:GetStreak(Player) or 1)
end 
function kills:GetPlayerStreak(Player)
	return math.floor(KILL_STREAK_SETTINGS.DEFAULT_GOLD + kills:GetGoldPerLevel(tonumber(Player)) + kills:GetStreak(Player) + kills:GetGoldPerMinutes(tonumber(Player)))
end 
function kills:CreateCustomToast(data,type,killerPlayer,victimPlayer,gold,player,victimUnitName,team,runeType,variables)
	CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", data or {
	type = type,
	killerPlayer = killerPlayer,
	victimPlayer = victimPlayer,
	gold = gold,
	player = player,
	victimUnitName = victimUnitName,
	team = team,
	runeType = runeType,
	variables = variables, -- table
	})
end