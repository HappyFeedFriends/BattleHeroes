require("modules/spawners/data")
if Spawner == nil then
	Spawner = class({})
	Spawner.SpawnerEntities = {}
	Spawner.Creeps = {}
	Spawner.MinimapPoints = {}
	Spawner.NextCreepsSpawnTime = 0
end

function Spawner:GetSpawners()
	local spawners = {}
	for i,_ in pairs(SPAWNER_SETTINGS) do
		if i ~= "Cooldown" then
			table.insert(spawners, i)
		end
	end
	return spawners
end

function Spawner:PreloadSpawners()
	local targets = Entities:FindAllByClassname("info_target")
	for _,v in ipairs(targets) do
		local entname = v:GetName()
		if string.find(entname, "target_stack_") then
			table.insert(Spawner.SpawnerEntities, v)
		end
	end
end
function Spawner:RegisterTimers()
	Timers:CreateTimer(function()
		if GameRules:GetDOTATime(false, false) >= Spawner.NextCreepsSpawnTime then
			Spawner.NextCreepsSpawnTime = Spawner.NextCreepsSpawnTime + SPAWNER_SETTINGS.Cooldown * (Spawner.NextCreepsSpawnTime == 0 and 2 or 1)
			Spawner:SpawnStacks()
		end
		return 1
	end)
end

function Spawner:SpawnStacks()
	for _,entity in ipairs(Spawner.SpawnerEntities) do
		local entname = entity:GetName()
		local sName = string.gsub(string.gsub(entname, "target_stack_", ""), "_type%d+", "")
		local SpawnerType = tonumber(string.sub(entname, string.find(entname, "_type") + 5))
		local entid = entity:GetEntityIndex()
		local coords = entity:GetAbsOrigin()
		if Spawner:CanSpawnUnits(sName, entid) then
			for i = 1, SPAWNER_SETTINGS[sName].SpawnedPerSpawn do
				local unitRootTable = SPAWNER_SETTINGS[sName].SpawnTypes[SpawnerType]
				local unitName = unitRootTable[1][-1]
				local unit = CreateUnitByName(unitName, coords, true, nil, nil, DOTA_TEAM_NEUTRALS)
				unit.SpawnerIndex = SpawnerType
				unit.SpawnerType = sName
				unit.CreepIndex = entid
				unit.SLevel = GetDOTATimeInMinutesFull()
				Spawner.Creeps[entid] = Spawner.Creeps[entid] + 1
				Spawner:UpgradeCreep(unit, unit.SpawnerType, unit.SLevel, unit.SpawnerIndex)
			end
		end
	end
end

function Spawner:CanSpawnUnits(sName, id)
	Spawner:InitializeStack(id)
	return Spawner.Creeps[id] + SPAWNER_SETTINGS[sName].SpawnedPerSpawn <= SPAWNER_SETTINGS[sName].MaxUnits 
end

function Spawner:InitializeStack(id)
	if not Spawner.Creeps[id] then
		Spawner.Creeps[id] = 0
	end
end

function Spawner:UpgradeCreep(unit, spawnerType, minutelevel, spawnerIndex)
	local modelScale = 1 + (0.004 * minutelevel)
	if minutelevel > 1 then
		unit:CreatureLevelUp(minutelevel - 1)
	end

	local goldbounty, hp, damage, attackspeed, movespeed, armor, xpbounty, customCalculate = unpack(table.nearestOrLowerKey(CREEP_UPGRADE_FUNCTIONS[spawnerType], minutelevel))
	if not customCalculate then
		goldbounty, hp, damage, attackspeed, movespeed, armor, xpbounty = goldbounty * (minutelevel == 0 and 1 or minutelevel), hp * minutelevel, damage * minutelevel, attackspeed * minutelevel,movespeed * minutelevel,armor * minutelevel, xpbounty * minutelevel
	end
	unit:SetDeathXP(unit:GetDeathXP() + xpbounty)
	unit:SetMinimumGoldBounty(goldbounty)
	unit:SetMaximumGoldBounty(goldbounty)
	unit:SetMaxHealth(unit:GetMaxHealth() + hp)
	unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() + hp)
	unit:SetHealth(unit:GetMaxHealth() + hp)
	unit:SetBaseDamageMin(unit:GetBaseDamageMin() + damage)
	unit:SetBaseDamageMax(unit:GetBaseDamageMax() + damage)
	unit:SetBaseMoveSpeed(unit:GetBaseMoveSpeed() + movespeed) 
	unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue() + armor)
	unit:SetModelScale(modelScale)
	local model = table.nearestOrLowerKey(SPAWNER_SETTINGS[spawnerType].SpawnTypes[spawnerIndex][1], minutelevel)
	if model then
		unit:SetModel(model)
		unit:SetOriginalModel(model)
	end
end

function CDOTA_BaseNPC:IsRealCreep()
	return self.CreepIndex ~= nil and self.SpawnerType ~= nil
end

function Spawner:OnCreepDeath(unit)
	Spawner.Creeps[unit.CreepIndex] = Spawner.Creeps[unit.CreepIndex] - 1
	Spawner:Drop(unit,GetDOTATimeInMinutesFull())
end

function Spawner:Drop(unit,minute)
	minute = tonumber(minute)
	local time = table.nearestOrLowerKey(ITEM_LOOT_SETTINGS, minute)
	local SpawnerType = unit.SpawnerType
	if SpawnerType then
		--local gold  = time[SpawnerType]["gold"]
		local chance = time[SpawnerType]["chance"]
		--local gold_min = time[SpawnerType]["gold_min"]
		if RollPercentage(chance) then
			--local item = RollItemsGold(gold,gold_min)
			--unit:DropItem(item)
			unit:RollDropItemSpawners(time.DROP_ITEMS)
		end 
	end
end 