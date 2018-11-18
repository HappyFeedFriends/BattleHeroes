MUTATION_ENABLED = 1
MUTATION_DISABLED = 0
if not Mutation then
	Mutation = class({})
	Mutation_active = {}
	Mutation.sunstrike_on = false
end
ModuleRequire(...,"data")
function Mutation:Init()
	local MutationType
	local t = {}
	local data = {}
	for i = 1,MUTATION_SETTINGS.MAX_MUTATION do
		MutationType = PickRandomShuffle(MUTATION_LIST,t)
		Mutation_active[MutationType] = true 
		data[i] = MUTATION_SETTINGS[MutationType]
	end 
	Mutation:SendInfo(data)
	if Mutation_active["SUNSTRIKES"] then
		Timers:CreateTimer(MUTATION_SETTINGS["SUNSTRIKES"].time * 60, function()
			Mutation:SunStrikes()
			return MUTATION_SETTINGS["SUNSTRIKES"].time * 60
		end)
	end
end 

function Mutation:SendInfo(keys)
	CustomGameEventManager:Send_ServerToAllClients("CreateMutations", keys)
end 
function Mutation:GetMutation()
	return MUTATION_ENABLED
end
function IsMutation()
	return Mutation:GetMutation() == MUTATION_ENABLED
end
function Mutation:IsSunStrike()
	return Mutation.sunstrike_on
end

function Mutation:SunStrikes()
if Mutation:IsSunStrike() then return end
	kills:CreateCustomToast({
			type = "generic",
			text = "#custom_toast_start_mutation_sunstrikes",
			variables = {
				["{time}"] = MUTATION_SETTINGS["SUNSTRIKES"].delay
			}
	})
	Mutation.sunstrike_end_time = GameRules:GetDOTATime(false, true) + (MUTATION_SETTINGS["SUNSTRIKES"].time_active * 60)
	Mutation.sunstrike_on = true
	Timers:CreateTimer(MUTATION_SETTINGS["SUNSTRIKES"].delay, function()
		CreateSunStrikes(GetGroundPosition(Vector(RandomInt(-MAP_LENGTH, MAP_LENGTH), RandomInt(-MAP_LENGTH, MAP_LENGTH), 0), nil))
		if GameRules:GetDOTATime(false, true) >= Mutation.sunstrike_end_time then
			kills:CreateCustomToast({
				type = "generic",
				text = "#custom_toast_end_mutation_sunstrikes",
			})
			Mutation.sunstrike_on = false
			return 
		end 
		return 1/20
	end)
end 

function CreateSunStrikes(position)
	local aoe = MUTATION_SETTINGS["SUNSTRIKES"].radius
	CreateGlobalParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf", function(particle)
		local SunstrikeSourcePosition = position + Vector(RandomInt(-250, 250), RandomInt(-250, 250), 1200)
		ParticleManager:SetParticleControl(particle, 0, position)
		ParticleManager:SetParticleControl(particle, 1, SunstrikeSourcePosition)
	end, PATTACH_WORLDORIGIN)
	EmitSoundOnLocationWithCaster(position, "Hero_Invoker.SunStrike.Ignite", nil)
	GridNav:DestroyTreesAroundPoint(position, aoe, true)
	local damage = MUTATION_SETTINGS["SUNSTRIKES"].damage * GetDOTATimeInMinutesFull()
	for _,v in ipairs(FindUnitsInRadius(DOTA_TEAM_NEUTRALS, position, nil, aoe, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		if not v:IsMagicImmune() and not v:IsBoss() then
			ApplyDamage({
				attacker = GLOBAL_DUMMY,
				victim = v,
				damage_type = DAMAGE_TYPE_PURE,
				damage = damage
			})
		end
	end
end