--[[DOTA_MAX_ABILITY = 24
DOTA_MAX_ITEM_SLOT = 6
DOTA_MAX_BACKPACK_SLOTS = 3]]

--------------------------------------------------------------------------------------------------------------------
--											GLOBAL																	  --
--------------------------------------------------------------------------------------------------------------------
function GetDOTATimeInMinutesFull()
	return math.floor(GameRules:GetDOTATime(false, false)/60)
end

function GetDotaFormatTime(time)
	time = time or GameRules:GetDOTATime(false, false)
	local minutes = math.floor(time / 60)
    local seconds = time - (minutes * 60)
	seconds = math.round(seconds)
	minutes = math.round(minutes)
    local m10 = math.floor(minutes / 10)
    local m01 = minutes - (m10 * 10)
    local s10 = math.floor(seconds / 10)
    local s01 = seconds - (s10 * 10)    
   return m10 .. m01 .. ":" .. s10 .. s01
end 
--[[function RequestNetwork()
	local dates = CreateHTTPRequestScriptVM('GET', "")
	--dates:SetHTTPRequestGetOrPostParameter('payload', "data")
	dates:Send(function(key)
	json.decode(key["Body"])
	end)		
end]]
function IsCreateHeroMap()
	return GetMapName() == MAP_INFO["CreateHero"].map
end 

function IsRandomOMGMap()
	return GetMapName() == MAP_INFO["RandomOMG"].map
end 
function RemoveAbilityWithModifiers(unit, ability)
	for _,v in ipairs(unit:FindAllModifiers()) do
		if v:GetAbility() == ability then
			v:Destroy()
		end
	end
end

function CDOTA_BaseNPC_Hero:CalculateRespawnTime()
	if self.OnDuel then return 1 end
	local time = (5 + 3.8*self:GetLevel()) + (self.RespawnTimeModifierBloodstone or 0) + (self.RespawnTimeModifierSaiReleaseOfForge or 0)
	return math.max(time, 3)
end
 
function CDOTA_BaseNPC:SetRespawnTime()
local respawn = self:CalculateRespawnTime()
	if respawn > 25 then respawn = 25 end
	self:SetTimeUntilRespawn( math.max(respawn,1) )
end

function CreateGlobalParticle(name, callback, pattach)
	local ps = {}
	for team = DOTA_TEAM_FIRST, DOTA_TEAM_CUSTOM_MAX do
		local f = FindFountain(team)
		if f then
			local p = ParticleManager:CreateParticleForTeam(name, pattach or PATTACH_WORLDORIGIN, f, team)
			callback(p)
			table.insert(ps, p)
		end
	end
	return ps
end

function AllPlayerId(id)
	if id then 
		if PlayerResource:GetPlayer(id) then
			local player = PlayerResource:GetPlayer(id)
			local playerName = PlayerResource:GetPlayerName(id)
			local hero = player:GetAssignedHero():GetUnitName()
			GameRules:SendCustomMessage("<br> Айди игрока: " .. id .. "<br> Имя игрока: " .. playerName .. "<br> Герой: " .. hero,1,1)
		else
			GameRules:SendCustomMessage("Такого игрока не существует",1,1)
		end
	else
		for i = 0, DOTA_MAX_PLAYERS - 1 do
			if PlayerResource:IsValidPlayerID(i) and not IsPlayerAbandoned(i) then
				local player = PlayerResource:GetPlayer(i)
				local playerName = PlayerResource:GetPlayerName(i)
				local hero = player:GetAssignedHero():GetUnitName()
				GameRules:SendCustomMessage("<br> Айди игрока: " .. i .. "<br> Имя игрока: " .. playerName .. "<br> Герой: " .. hero,1,1)			
			end
		end
	end
end 
function GetDirectoryFromPath(path)
	return path:match("(.*[/\\])")
end

function ModuleRequire(path,file)
	return require(GetDirectoryFromPath(path) .. file)
end 

function GetAccesCheatsPlayer(playerId)
	if IsDev(playerId) then
		return DEV_ACCESS
	elseif GameRules:IsCheatMode() then
		return	CHEAT_LOBBY_ACCESS
	end
	return USUAL_ACCESS
end

function RemoveAllUnitsByName(name)
	local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _,v in ipairs(units) do
		if v:GetUnitName():match(name) then
			v:ClearNetworkableEntityInfo()
			v:ForceKill(false)
			UTIL_Remove(v)
		end
	end
end

function UnitVarToPlayerID(unitvar)
  if unitvar then
    if type(unitvar) == "number" then
      return unitvar
    elseif type(unitvar) == "table" and not unitvar:IsNull() and unitvar.entindex and unitvar:entindex() then
      if unitvar.GetPlayerID and unitvar:GetPlayerID() > -1 then
        return unitvar:GetPlayerID()
      elseif unitvar.GetPlayerOwnerID then
        return unitvar:GetPlayerOwnerID()
      end
    end
  end
  return -1
end

function PickRandomShuffle( reference_list, bucket )
    if ( #reference_list == 0 ) then
        return nil
    end
    
    if ( #bucket == 0 ) then
        for k, v in pairs(reference_list) do
            bucket[k] = v
        end
    end
    local pick_index = RandomInt( 1, #bucket )
    local result = bucket[ pick_index ]
    table.remove( bucket, pick_index )
    return result
end

function PickRandomValueTable(table)
	 return table[RandomInt( 1, #table )]
end 

function GetCostAll(Talents)
	local all = KeyValues["AbilityKV"]
	local abilities = {}
	for k,v in pairs(all) do
		if v.AbilityType == "DOTA_ABILITY_TYPE_ULTIMATE" then
			abilities[k] = 3
		end 
	end
	return abilities
end 
function RandomAbilityTable()
local ability_table = {}
local ability_name_table = {}
local All = GetAllAbilityName()
	for k,v in pairs(All) do
		if not v:find("special_bonus_") 
		and not v:find("empty") 
		and not v:find("dummy") 
		and not v:find("containers")
		and not v:find("courier")
		and v ~= "example_ability"
		and v ~= "meepo_divided_we_stand" then
			table.insert(ability_name_table,v)
		end 
	end 
local ability = PickRandomShuffle( ability_name_table, ability_table )
return ability
end 

function DebugPrint(...)
  local spew = Convars:GetInt('barebones_spew') or -1
  if spew == -1 and BAREBONES_DEBUG_SPEW then
    spew = 1
  end

  if spew == 1 then
    print(...)
  end
end

function DebugPrintTable(...)
  local spew = Convars:GetInt('barebones_spew') or -1
  if spew == -1 and BAREBONES_DEBUG_SPEW then
    spew = 1
  end

  if spew == 1 then
    PrintTable(...)
  end
end

function PrintTable(t, indent, done)
  if type(t) ~= "table" then return end

  done = done or {}
  done[t] = true
  indent = indent or 0

  local l = {}
  for k, v in pairs(t) do
    table.insert(l, k)
  end

  table.sort(l)
  for k, v in ipairs(l) do
    if v ~= 'FDesc' then
      local value = t[v]

      if type(value) == "table" and not done[value] then
        done [value] = true
        print(string.rep ("\t", indent)..tostring(v)..":")
        PrintTable (value, indent + 2, done)
      elseif type(value) == "userdata" and not done[value] then
        done [value] = true
        print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
        PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
      else
        if t.FDesc and t.FDesc[v] then
          print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
        else
          print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
        end
      end
    end
  end
end

COLOR_NONE = '\x06'
COLOR_GRAY = '\x06'
COLOR_GREY = '\x06'
COLOR_GREEN = '\x0C'
COLOR_DPURPLE = '\x0D'
COLOR_SPINK = '\x0E'
COLOR_DYELLOW = '\x10'
COLOR_PINK = '\x11'
COLOR_RED = '\x12'
COLOR_LGREEN = '\x15'
COLOR_BLUE = '\x16'
COLOR_DGREEN = '\x18'
COLOR_SBLUE = '\x19'
COLOR_PURPLE = '\x1A'
COLOR_ORANGE = '\x1B'
COLOR_LRED = '\x1C'
COLOR_GOLD = '\x1D'

function CDOTA_BaseNPC:SplitShot(ability,radius,max_targets)
if not self:IsAttackRange() then return end
local targetTeam,targetType,targetFlags = ability:GetAbilityTargetTeam(),ability:GetAbilityTargetType(),ability:GetAbilityTargetFlags()
if targetTeam == 0 then targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY  end
if targetType == 0  then targetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC  end
if targetFlags == 0 then targetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES  end
	local split_shot_targets = FindUnitsInRadius(
		self:GetTeam(), 
		self:GetAbsOrigin(), 
		nil,
		radius,
		targetTeam, 
		targetType,
		targetFlags,
		FIND_CLOSEST,
		false)
	for _,v in pairs(split_shot_targets) do
		if v ~= self:GetAttackTarget() and max_targets ~= 0 and not v:IsAttackImmune() and not v:IsInvulnerable() and not v:IsInvisible() then
			local projectile_info = 
			{
				EffectName = self:GetKeyValue("ProjectileModel") or "particles/dev/library/base_ranged_attack.vpcf",
				Ability = ability,
				vSpawnOrigin = self:GetAbsOrigin(),
				Target = v,
				Source = self,
				bHasFrontalCone = false,
				iMoveSpeed = self:GetProjectileSpeed(),
				bReplaceExisting = false,
				bProvidesVision = false
			}
			ProjectileManager:CreateTrackingProjectile(projectile_info)
			max_targets = max_targets - 1
		end
	end
end

function CDOTA_BaseNPC:Healing(healing)
	self:Heal(healing, self)
	local player = PlayerResource:GetPlayer(UnitVarToPlayerID(self))
	SendOverheadEventMessage(player, OVERHEAD_ALERT_HEAL, player, math.round(healing), player)
	local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self)
	ParticleManager:SetParticleControl(lifesteal_pfx, 0, self:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
end

function DebugAllCalls()
    if not GameRules.DebugCalls then
        print("Starting DebugCalls")
        GameRules.DebugCalls = true

        debug.sethook(function(...)
            local info = debug.getinfo(2)
            local src = tostring(info.short_src)
            local name = tostring(info.name)
            if name ~= "__index" then
                print("Call: ".. src .. " -- " .. name .. " -- " .. info.currentline)
            end
        end, "c")
    else
        print("Stopped DebugCalls")
        GameRules.DebugCalls = false
        debug.sethook(nil, "c")
    end
end


function HideWearables( unit )
  unit.hiddenWearables = {} 
    local model = unit:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) 
            table.insert(unit.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end

function ShowWearables( unit )
  for i,v in pairs(unit.hiddenWearables) do
    v:RemoveEffects(EF_NODRAW)
  end
end



function IsDev(playerId)
	return PlayerResource:GetSteamAccountID(playerId) == 311310226
end 

function CommandsGold(hero,gold)
	PlayerResource:ModifyGold( hero, gold, true, 0 )
end 

function CommandsGiveItems(items,hero)	
	for k,v in pairs(GetAllItemName()) do
		if string.find(v,items) then
			if string.find(items,"recipe") then
				hero:AddItem(CreateItem(v, hero, hero))
				return true
			else
				hero:AddItem(CreateItem(v, hero, hero))
				return true
			end
		end		
	end	 
end

function CommandsModifyStats(stats,hero)
	hero:ModifyAgility(stats)
	hero:ModifyStrength(stats)
	hero:ModifyIntellect(stats)
end 


function CommandsCreateCreep(unit,hero)
local position = hero:GetAbsOrigin() + RandomVector( RandomFloat(0,200))	
	for _,v in pairs(GetAllUnitsNames()) do
		if not v:find("npc_dota_hero_") and string.find(v,unit) then
			local spawnedUnit = CreateUnitByName(v, position, true, hero, hero, hero:GetTeam())
			spawnedUnit:SetTeam(hero:GetTeam())
			spawnedUnit:SetControllableByPlayer(hero:GetPlayerID(), true)
			return true
		end		
	end		 
end
function CommandsCreateHero(unit,player)
	for _,name in pairs(GetAllUnitsNames()) do
		if name:find("npc_dota_hero_") and string.find(name,unit) then
			local hero = CreateHeroForPlayer(name, player)
			hero:SetTeam(player:GetTeam())
			hero:SetAbsOrigin(player:GetAbsOrigin())
			hero:SetControllableByPlayer(player:GetPlayerID(), true)
		end		
	end	 
end

function CommandsSwapHero(player_id, hero_entity)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local level = hero:GetLevel()
	PlayerResource:ReplaceHeroWith(player_id, hero_entity, hero:GetGold(), 0 )
	UTIL_Remove(hero)
	CommandsLevel(PlayerResource:GetSelectedHeroEntity(player_id),tonumber(level))
end

function CommandsLevel(hero,lvl)
	local heroLvl = hero:GetLevel()
	lvl = lvl and lvl + (heroLvl - 1) or MAX_LEVEL
	for i = heroLvl, lvl do
		if XP_PER_LEVEL_TABLE[i] and XP_PER_LEVEL_TABLE[i + 1] then
			hero:AddExperience(XP_PER_LEVEL_TABLE[i + 1] - XP_PER_LEVEL_TABLE[i], 0, false, false)
		else
			break
		end
	end
end 

function FindStringTable(stringFind,table)
if not table then return false end
	for _,Name in pairs(table) do
		if Name then
			if type(Name) == "table" then
				return FindStringTable(stringFind,Name) and true
			elseif stringFind:find(Name) then
				return true
			end 
		end
	end	
	return false
end 

function LinkedTalents()
	local all_names = KeyValues["AbilityKV"]
	local LinkAbility = {}
	for Name,ValueAbility in pairs(all_names) do
	local special_bonus = ValueAbility.AbilitySpecial
		if special_bonus then
			for _,values in pairs(special_bonus) do
				for Type,TalentName in pairs(values) do
					if Type == "LinkedSpecialBonus" then
						--if LinkAbility[TalentName] then
							--[[if type(LinkAbility[TalentName]) == "table" then
								if not FindStringTable(Name,LinkAbility[TalentName])  then
								table.insert(LinkAbility[TalentName],Name)
								end
							else 
								local OldArray = LinkAbility[TalentName]
								LinkAbility[TalentName] = {}
								table.insert(LinkAbility[TalentName],OldArray)
								if not FindStringTable(Name,LinkAbility[TalentName])  then
									table.insert(LinkAbility[TalentName],Name)
								end
							end]]
						--else 
							LinkAbility[TalentName] = Name
					end
				end
			end
		end
	end
	return LinkAbility
end

function DotaItemsNames()
	local names = {}
	for k,v in pairs(DOTA_ITEMS) do
		if not names[k] then
			table.insert(names,k)
		end
	end 
	return names
end 

function RollItemsGold(gold_max,gold_min)
	gold_min = gold_min or 0
	local items = DotaItemsNames()
	local table = {}
	local item = PickRandomShuffle( items, table )
	local Cost = GetItemCost(item) or 2
	while Cost > gold_max or Cost < gold_min or FindStringTable(item,FIND_DROP_ITEM) do 
		item = PickRandomShuffle( items, table )
		Cost = GetItemCost(item) or 2
	end
	return item
end 

function HeroAbility(hero)
local full = KeyValues.UnitKV
local heroes = {}
	for i = 1,24 do
		if full[hero]["Ability" .. i] and not full[hero]["Ability" .. i]:find("special_bonus_") and full[hero]["Ability" .. i] ~= "generic_hidden" then
			table.insert(heroes, full[hero]["Ability" .. i])
		end
	end
	return heroes
end

function FullHeroesName()
local heroes = {}
	for k,v in pairs(KeyValues.UnitKV) do
		if k:find("npc_dota_hero_") and not k:find("dummy") and not k:find("base") and k:find(k) then
			heroes[k] = v["AttributePrimary"]
		end
	end 
	return heroes
end 

function IsInBox(point, point1, point2)
	return point.x > point1.x and point.y > point1.y and point.x < point2.x and point.y < point2.y
end

function FindFountain(team)
	return Entities:FindByName(nil, "npc_battle_heroes_fountain_" .. team )
end

function ExpandVector(vec, by)
	return Vector(
		(math.abs(vec.x) + by) * math.sign(vec.x),
		(math.abs(vec.y) + by) * math.sign(vec.y),
		(math.abs(vec.z) + by) * math.sign(vec.z)
	)
end


function VectorOnBoxPerimeter(vec, min, max)
	local l, r, b, t = min.x, max.x, min.y, max.y
	local x, y = math.clamp(vec.x, l, r), math.clamp(vec.y, b, t)

	local dl, dr, db, dt = math.abs(x-l), math.abs(x-r), math.abs(y-b), math.abs(y-t)
	local m = math.min(dl, dr, db, dt)

	if m == dl then return Vector(l, y) end
	if m == dr then return Vector(r, y) end
	if m == db then return Vector(x, b) end
	if m == dt then return Vector(x, t) end
end

function ColorTableToCss(color)
	return "rgb(" .. color[1] .. ',' .. color[2] .. ',' .. color[3] .. ')'
end

function CreateTeamNotificationSettings(team)
	local textColor = ColorTableToCss(Teams:GetColor(team))
	return {text = Teams:GetName(team), continue = true, style = {color = textColor}}
end


function HasDamageFlag(damage_flags, flag)
	return bit.band(damage_flags, flag) == flag
end

function SimpleDamageReflect(victim, attacker, damage, flags, ability, damage_type)
	if victim:IsAlive() and not HasDamageFlag(flags, DOTA_DAMAGE_FLAG_REFLECTION) and attacker:GetTeamNumber() ~= victim:GetTeamNumber() then
		ApplyDamage({
			victim = attacker,
			attacker = victim,
			damage = damage,
			damage_type = damage_type,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION,
			ability = ability
		})
		return true
	end
	return false
end
 
function FindAllOwnedUnits(player)
	local summons = {}
	local pid = type(player) == "number" and player or player:GetPlayerID()
	local units = FindUnitsInRadius(PlayerResource:GetTeam(pid), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)
	for _,v in ipairs(units) do
		if type(player) == "number" and ((v.GetPlayerID ~= nil and v:GetPlayerID() or v:GetPlayerOwnerID()) == pid) or v:GetPlayerOwner() == player then
			if not v:HasModifier("modifier_dummy_unit") and v ~= hero then
				table.insert(summons, v)
			end
		end
	end
	return summons
end

function FindCourier(team)
	if COURIER_TEAM and type(COURIER_TEAM[team]) == "table" then
		return COURIER_TEAM[team]
	end
end

function FindHeroesFountainOrigin(team)
	local origin = FindFountain(team):GetAbsOrigin()
	local targets = FindUnitsInRadius(
		team, 
		origin,
		nil,
		1500,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_CLOSEST,
		false)
	return #targets > 0
end

function GetHeroTalents(HeroName)
	local heroes = {}
	for k,v in pairs(GetAllAbilityName()) do
		k = v
		local finds = HeroName:find("npc_dota_hero_nyx") and k:find("nyx") or 
		HeroName:find("shredder")           and k:find("timbersaw") or
		HeroName:find("magnataur")          and k:find("magnus") or
		HeroName:find("life_stealer")       and k:find("lifestealer") or
		HeroName:find("underlord")          and k:find("underlord") or
		HeroName:find("rattletrap")         and k:find("clockwerk") or
		HeroName:find("doom")               and k:find("doom") or
		HeroName:find("vengefulspirit")     and k:find("vengeful_spirit") or
		HeroName:find("windrunner")         and k:find("windranger") or
		HeroName:find("necrolyte")          and k:find("necrophos") or
		HeroName:find("queenofpain")        and k:find("queen_of_pain") or
		HeroName:find("zuus")               and k:find("zeus") or
		HeroName:find("obsidian_destroyer") and k:find("outworld_devourer") or
		HeroName:find("skywrath_mage")      and k:find("skywrath") or
		HeroName:find("skeleton_king")      and k:find("wraith_king") or 
		k:find(HeroName:gsub("npc_dota_hero_",""))
		if k:find("special_bonus_") and finds and not FindStringTable(k,heroes) and not TALENT_HERO_OFFED[k] then
			table.insert(heroes,k)
		end 
	end
	return heroes
end

function AbilityHasBehaviorByName(ability_name, behaviorString)
	local AbilityBehavior = GetKeyValue(ability_name, "AbilityBehavior")
	if AbilityBehavior then
		local AbilityBehaviors = string.split(AbilityBehavior, " | ")
		return table.contains(AbilityBehaviors, behaviorString)
	end
	return false
end

--------------------------------------------------------------------------------------------------------------------
--											Hero																  --
--------------------------------------------------------------------------------------------------------------------

function CDOTA_BaseNPC:Midas(gold,mult_xp,caster,ability)
	self:SetDeathXP( mult_xp * self:GetDeathXP() )
	self:EmitSound("DOTA_Item.Hand_Of_Midas")
	local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, self)	
	ParticleManager:SetParticleControlEnt(midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
	self:SetMinimumGoldBounty( gold ) 
	self:SetMaximumGoldBounty( gold )
	self:KillTarget(caster, ability)
end

function CDOTA_BaseNPC:RemoveAllAbility()
local heroName = self:GetUnitName()
local count = 1
    for i=0,self:GetAbilityCount() - 1 do
        local ability = self:GetAbilityByIndex(i)
		if ability then
			self:RemoveAbility(ability:GetName())
		end
    end
	for i = 1,MAX_SLOT_ABILITY do
		self:AddAbility("empty_slot_" .. i)
	end
end

function CDOTA_BaseNPC:KillTarget(caster, ability)
	self:Kill(ability, caster)
	if self:IsAlive() then
		self:Kill(ability, caster)
	end	
end

function CDOTA_BaseNPC:Teleport(position)
	self.TeleportPosition = position
	self:Stop()

	local playerId = self:GetPlayerOwnerID()
	PlayerResource:SetCameraTarget(playerId, self)

	FindClearSpaceForUnit(self, position, true)

	Timers:CreateTimer(0.1, function()
		if not IsValidEntity(self) or self.TeleportPosition ~= position then return end
		if (self:GetAbsOrigin() - position):Length2D() > 256 then
			FindClearSpaceForUnit(self, position, true)
			return 0.1
		end

		self.TeleportPosition = nil
		PlayerResource:SetCameraTarget(playerId, nil)
		self:Stop()
	end)
end

function CDOTA_BaseNPC:RollDropItemUnit()
	local name = self:GetUnitName()
	local table = self:GetItemDrop()  
	for ItemName,value in pairs(table) do
		local chance = self:GetItemDropChance(ItemName)
		local maximum = self:GetitemDropMaximumValue(ItemName)
		local minimum = self:GetitemDropMinimumValue(ItemName)
		if maximum >= minimum then
			for i = 1,minimum do
				self:DropItem(ItemName)
			end			
			for i = maximum,maximum do
				if RollPercentage(chance) then
					self:DropItem(ItemName)
				end
			end
		end		
	end 
end

function CDOTA_BaseNPC:RollDropItemSpawners( shuffle )
	local table = {}  
	local item = PickRandomShuffle( shuffle, table )
	self:DropItem( item )
end

function CDOTA_BaseNPC:SwapAbility(ability1,ability2,lvl)
	local ability = self:AddAbility(ability2)
	self:SwapAbilities( ability1, ability2, false, true )
	self:RemoveAbility(ability1)
	if lvl then
		ability:SetLevel(lvl)
	end 
end

function CDOTA_BaseNPC:DropItem(itemName)
if not itemName then return end
   	local newItem = CreateItem(itemName, nil, nil)
	local v = self:GetOrigin() + RandomVector(RandomFloat(0,250))
	local drop = CreateItemOnPositionForLaunch( v, newItem )
	newItem:LaunchLootInitialHeight( false, 0, 500, 0.75, v) 
   	Timers:CreateTimer({
          endTime = 60,
          callback = function()
		if newItem and IsValidEntity(newItem) and not newItem:GetOwnerEntity() then 
			UTIL_Remove(newItem)
			UTIL_Remove(drop)
		end
			return nil
     end})
end

function CDOTA_BaseNPC:IsWukongsSummon()
	return self:IsHero() and (
		self:HasModifier("modifier_monkey_king_fur_army_soldier") or
		self:HasModifier("modifier_monkey_king_fur_army_soldier_inactive") or
		self:HasModifier("modifier_monkey_king_fur_army_soldier_hidden")
	)
end

function CDOTA_BaseNPC:GetFullName()
	return self.UnitName or (self.GetUnitName and self:GetUnitName()) or self:GetName()
end

function CDOTA_BaseNPC:GetMagicalLifeSteal()
	local lifesteal = 0
	for _, modifier in pairs(self:FindAllModifiers()) do
		if modifier.GetMagicalLifeSteal then
			lifesteal = lifesteal + modifier:GetMagicalLifeSteal()
		end
	end
	return lifesteal
end

function CDOTA_BaseNPC:GetModifierBonusGoldCreep()
	local value = 0
	for _, modifier in pairs(self:FindAllModifiers()) do
		if modifier.GetModifierBonusGoldCreep then
			value = value + modifier:GetModifierBonusGoldCreep()
		end
	end
	return value
end

function CDOTA_BaseNPC:GetModifierBonusXPCreep()
	local value = 0
	for _, modifier in pairs(self:FindAllModifiers()) do
		if modifier.GetModifierBonusXPCreep then
			value = value + modifier:GetModifierBonusXPCreep()
		end
	end
	return value
end

function CDOTA_BaseNPC:GetModifierBonusXPCreep()
	local value = 0
	for _, modifier in pairs(self:FindAllModifiers()) do
		if modifier.GetModifierBonusXPCreep then
			value = value + modifier:GetModifierBonusXPCreep()
		end
	end
	return value
end

function CDOTA_BaseNPC:GetMagicalCreepLifeSteal()
	local lifesteal = 0
	for _, modifier in pairs(self:FindAllModifiers()) do
		if modifier.GetMagicalCreepLifeSteal then
			lifesteal = lifesteal + modifier:GetMagicalCreepLifeSteal()
		end
	end
	return lifesteal
end

function CDOTA_BaseNPC:GetAttackLifeSteal()
	local lifesteal = 0
	for _, modifier in pairs(self:FindAllModifiers()) do
		if modifier.GetAttackLifeSteal then
			lifesteal = lifesteal + modifier:GetAttackLifeSteal()
		end
	end
	return lifesteal
end

function CDOTA_BaseNPC:GetReflectionDamage()
	local reflect = 0
	for _, modifier in pairs(self:FindAllModifiers()) do
		if modifier.GetReflectDamage then
			reflect = reflect + modifier:GetReflectDamage()
		end
	end
	return reflect
end

function CDOTA_BaseNPC:GetChangeParticles()
	for _, modifier in pairs(self:FindAllModifiers()) do
		if modifier.GetChangeParticleAttack and self:IsAttackRange() then
			return modifier:GetChangeParticleAttack()
		end
	end
	return
end

function CDOTA_BaseNPC:MagicalLifeSteal(damage,heal)
	local lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self)
	ParticleManager:SetParticleControl(lifesteal_pfx, 0, self:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
	self:Heal(damage/100 * heal, self)
end

function CDOTA_BaseNPC:AttackLifeSteal(damage,heal)
	local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self)
	ParticleManager:SetParticleControl(lifesteal_pfx, 0, self:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
	self:Heal(damage/100 * heal, self)
end

function CDOTA_BaseNPC:IsAttackRange()
	return self:IsRangedAttacker()
end

function CDOTA_BaseNPC:CleaveAttacks(target,ability,damage,distance,start,end_width,particle)
	if not particle then
		particle = "particles/items_fx/battlefury_cleave.vpcf"
	end
	DoCleaveAttack(self, target, ability, damage, distance, start,end_width,particle) 
end 

function CDOTA_BaseNPC:Refreshing()
	for i=0, self:GetAbilityCount() - 1 do
		local current_ability = self:GetAbilityByIndex(i)
		if current_ability and not FindStringTable( current_ability:GetAbilityName(),NO_REFRESHING )  then
			current_ability:EndCooldown()
		end
	end
	for i=0, 5 do
		local current_item = self:GetItemInSlot(i)
		if current_item and not FindStringTable( current_item:GetAbilityName(),NO_REFRESHING ) then
			current_item:EndCooldown()
		end
	end
end

function CDOTA_BaseNPC:RefreshingTinker(cooldown)
	local cooldown_old,current_ability,current_item
	for i=0, self:GetAbilityCount() - 1 do
		current_ability = self:GetAbilityByIndex(i)
		if current_ability and not FindStringTable( current_ability:GetAbilityName(),NO_REFRESHING ) and current_ability:GetCooldownTimeRemaining() > 0 then
			cooldown_old = current_ability:GetCooldownTimeRemaining()
			if cooldown_old - cooldown < 0 then
				cooldown_old = cooldown
			end 
			current_ability:NewCooldown(cooldown_old - cooldown)
		end
	end
	for i=0, 5 do
		current_item = self:GetItemInSlot(i)
		if current_item and not FindStringTable( current_item:GetAbilityName(),NO_REFRESHING )  and current_item:GetCooldownTimeRemaining() > 0  then
			cooldown_old = current_item:GetCooldownTimeRemaining()
			if cooldown_old - cooldown < 0 then
				cooldown_old = cooldown
			end 
			current_item:NewCooldown(cooldown_old - cooldown)
		end
	end
end
--[[
local table_summons = 
{
	UnitName = name unit (KV)
	amount =  amount spawned unit (default = 1)
	model =   model units
	ability = abilities units -- Used table (ability = {ability_name = levelUp(Default = 1)}
	coords =  the coordinates of the appearance(default caster coordinates)
	team =  team units (Default caster team)
	health = health unit (default 400)
	gold =  gold bounty unit (default = 0)
	xp =  xp bounty unit (default = 0)
	ability_Level = level up ability (default = 1)
	damage = attack damage units (default = 25)
	movespeed = movespeed unit (default = 125)
	level = level unit (default 1)
	armor = armor units (default = 0)
	attack_time = attack time units (default = 1 s)
	resistance = magical resistance unit (Default = 25%)
	day_vision = day vision unit (Default = 700)
}
]]

function CDOTA_BaseNPC:IsTrueHero()
	return self:IsRealHero() and not self:IsTempestDouble() and not self:IsWukongsSummon()
end

function CDOTA_BaseNPC:IsFountain()
	return self:GetUnitName():find("fountain")
end

function CDOTA_BaseNPC:CreateUnitByCaster(keys)
	for key,value in pairs(keys) do
		if value == 0 then
			keys[key] = nil
		end 
	end 
	local unitName = keys.UnitName
	local model = keys.model
	local ability = keys.ability
	local amount_summons = keys.amount or 1
	local coords = keys.coords or self:GetOrigin()
	local team = keys.team or self:GetTeam()
	local health = keys.health or 400
	local gold = keys.gold or 0
	local xp = keys.xp or 0
	local damage = keys.damage or 25
	local ms = keys.movespeed or 350
	local level = keys.level or 1
	local armor = keys.armor or 0
	local attack_time = keys.attack_time or 1
	local resist = keys.resistance or 25
	local day_vision = keys.day_vision or 700
	local duration = keys.duration or 3
	local unit,units
	local one_summon = false
	if amount_summons == 1 then
		one_summon = true
	else
		units = {}
	end
	for i = 1,amount_summons do
		unit = CreateUnitByName(unitName, coords, true, self, self, team)
		FindClearSpaceForUnit(unit, coords, true)
		unit:SetDeathXP(xp)
		unit:SetMinimumGoldBounty(gold)
		unit:SetMaximumGoldBounty(gold)
		unit:SetMaxHealth(health)
		unit:SetBaseMaxHealth(health)
		unit:SetHealth(health)
		unit:SetBaseDamageMin(damage)
		unit:SetBaseDamageMax(damage)
		unit:SetBaseMoveSpeed(ms) 
		unit:SetPhysicalArmorBaseValue(armor)
		unit:SetBaseAttackTime(attack_time)
		unit:SetBaseMagicalResistanceValue(resist)
		unit:SetControllableByPlayer(self:GetPlayerID(), true)
		unit:SetDayTimeVisionRange(day_vision)
		unit:CreatureLevelUp(level)
		unit:SetOwner(self)
		if type(ability) == "table" then
			for ability_name,level_ability in pairs(ability) do
				local ab = unit:AddAbility(ability_name)
				ab:SetLevel(level_ability or 1)
			end
		elseif ability then
			local ab = unit:AddAbility(ability)
			local ability_level = keys.ability_Level or 1
			ab:SetLevel(ability_level)
		end
		if model then
			unit:SetModel(model)
			unit:SetOriginalModel(model)
		end 
		unit:AddNewModifier(self, nil, "modifier_kill", { duration = duration})
		if not one_summon then
			table.insert(units,unit)
		end 
	end
	if one_summon then 
		return unit
	else
		return units
	end 
end

function CDOTA_Item:SpendCharge(amount)
	local newCharges = self:GetCurrentCharges() - (amount or 1)
	if newCharges <= 0 then
		UTIL_Remove(self)
	else
		self:SetCurrentCharges(newCharges)
	end
end

function CDOTABaseAbility:DropItemHero(caster)
	local itemName = tostring(self:GetAbilityName())
	if caster:IsHero() and caster:HasInventory() then
		local newItem = CreateItem(itemName, nil, nil)
		CreateItemOnPositionSync(caster:GetOrigin(), newItem)
		caster:RemoveItem(self)
	end
end

--------------------------------------------------------------------------------------------------------------------
--											Ability																  --
--------------------------------------------------------------------------------------------------------------------

function CDOTABaseAbility:NewCooldown(cooldown)
	if not self then return end
	self:EndCooldown()
	return self:StartCooldown(cooldown or self:GetCooldown())
end 

function CDOTA_Buff:SetSharedKey(key, value)
	local t = CustomNetTables:GetTableValue("modifiers_value", self:GetParent():GetEntityIndex() .. "_" .. self:GetName()) or {}
	t[key] = value
	CustomNetTables:SetTableValue("modifiers_value", self:GetParent():GetEntityIndex() .. "_" .. self:GetName(), t)
end

function CDOTA_Buff:GetSharedKey(key)
	local t = CustomNetTables:GetTableValue("modifiers_value", self:GetParent():GetEntityIndex() .. "_" .. self:GetName()) or {}
	return t[key]
end

PLAYER_DATA = {[0] = {}, [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {}, [6] = {}, [7] = {}, [8] = {}, [9] = {}, [10] = {}, [11] = {}, [12] = {}, [13] = {}, [14] = {}, [15] = {}, [16] = {}, [17] = {}, [18] = {}, [19] = {}, [20] = {}, [21] = {}, [22] = {}, [23] = {}}