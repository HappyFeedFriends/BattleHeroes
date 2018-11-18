if not HeroSelection then
	HeroSelection = class({})
	PickPrecacheHero = {}
	HeroPick = {}
	lockedHeroes = {}
	STAGE_SELECTION = -1
	STAGE_SELECTION_START = 0
	STAGE_SELECTION_PICKED_HERO = 1
	STAGE_SELECTION_END = 2
	HERO_SELECTION_PICKING_TIME = 40
	CUSTOM_STARTING_GOLD = 650
end

local a_table = a_table or {}
if not a_table[0] then
	for i=0,23 do
		a_table[i] = 0
	end
end

function HeroSelection:Init()
	HeroSelection:StartingTimer()
	STAGE_SELECTION = STAGE_SELECTION_START
end
function HeroSelection:StartingTimer()
	Timers:CreateTimer(1,function()
	CustomGameEventManager:Send_ServerToAllClients("HeroSelectionTimer", {
		time = HERO_SELECTION_PICKING_TIME,
	})
		if HERO_SELECTION_PICKING_TIME > 0 then
			HERO_SELECTION_PICKING_TIME = HERO_SELECTION_PICKING_TIME - 1;
			STAGE_SELECTION = STAGE_SELECTION_PICKED_HERO
			return 1
		else
			STAGE_SELECTION = STAGE_SELECTION_END
			HeroSelection:PickedHeroEnd()
		end 
	end)
end
function HeroSelection:GetSelectionStage()
	return STAGE_SELECTION
end

function HeroSelection:PreLoad()
	local t = {
		agility = {},
		strength = {},
		intellect = {},
	}
	local t_,TableAttributes
	for _,HeroName in pairs(GetAllHeroesNames()) do
		TableAttributes = GetKeyValueByHeroName(HeroName, "AttributePrimary")
		t_ = TableAttributes == "DOTA_ATTRIBUTE_STRENGTH" and t.strength or 
		TableAttributes == "DOTA_ATTRIBUTE_AGILITY" and t.agility or 
		TableAttributes == "DOTA_ATTRIBUTE_INTELLECT" and t.intellect
		table.insert(t_,HeroName)
		CustomNetTables:SetTableValue("HeroSelection", HeroName, HeroSelection:HeroAbility(HeroName))
	end
	CustomNetTables:SetTableValue("HeroSelection", "DOTA_ATTRIBUTE_AGILITY", t.agility)	
	CustomNetTables:SetTableValue("HeroSelection", "DOTA_ATTRIBUTE_STRENGTH", t.strength)	
	CustomNetTables:SetTableValue("HeroSelection", "DOTA_ATTRIBUTE_INTELLECT", t.intellect)	
	CustomNetTables:SetTableValue("HeroSelection", "picks", a_table)
	CustomNetTables:SetTableValue("HeroSelection", "settings", {
		["Hero"] = FORCE_PICKED_HERO,
	})
end

function HeroSelection:PickedHero(data)
	if not (data.PlayerID or data.heroName) then return end
	local function PickHero() 
		local hero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
		if hero:GetUnitName() == data.heroName then Containers:DisplayError(data.PlayerID,"#hud_error_picking_hero") return end
			PlayerResource:ReplaceHeroWith(data.PlayerID, data.heroName, 0, 0 )
			UTIL_Remove(hero)
			Gold:ModifyGold(data.PlayerID, CUSTOM_STARTING_GOLD) 
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(data.PlayerID),"HeroSelection_picked", {})
	end
	if not PickPrecacheHero[data.heroName] then
		PrecacheUnitByNameAsync(data.heroName, PickHero,data.PlayerID)
		PickPrecacheHero[data.heroName] = true
	else
		 PickHero()
	end
end 

function HeroSelection:SetHeroPicked(data) 
	local t = CustomNetTables:GetTableValue("HeroSelection","picks")
	t[tostring(data.pID)] = data.heroName
	CustomNetTables:SetTableValue("HeroSelection", "picks", t)
	table.insert(lockedHeroes,data.heroName)
	CustomGameEventManager:Send_ServerToAllClients("PickingHeroes", {table = lockedHeroes})
end

function HeroSelection:HeroAbility(hero)
local full = KeyValues.UnitKV
local heroes = {}
	for i = 1,24 do
		if full[hero]["Ability" .. i] and	not 
		full[hero]["Ability" .. i]:find("special_bonus_") and 
		full[hero]["Ability" .. i] ~= "generic_hidden" then
			table.insert(heroes, full[hero]["Ability" .. i])
		end
	end
	return heroes
end

function HeroSelection:PickedHeroEnd()
  local newState = GameRules:State_Get()	
	CustomGameEventManager:Send_ServerToAllClients( 'state_change', {
		newState = newState
	})
end 