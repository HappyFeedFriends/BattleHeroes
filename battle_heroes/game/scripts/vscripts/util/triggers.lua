function ArenaZoneOnStartTouch(trigger)
	local activator = trigger.activator
	if not IsValidEntity(activator) then return end

	if Duel:IsDuelOngoing() then
		HEROES_ON_DUEL[activator] = true
		return
	end
	local caller = trigger.caller
	local origin = caller:GetAbsOrigin()
	local min = origin + ExpandVector(caller:GetBoundingMins(), 96)
	local max = origin + ExpandVector(caller:GetBoundingMaxs(), 96)
	local clamped = VectorOnBoxPerimeter(activator:GetAbsOrigin(), min, max)
	FindClearSpaceForUnit(activator, clamped, true)
end

function ArenaZoneOnEndTouch(trigger)
	local activator = trigger.activator
	if not IsValidEntity(activator) then return end
	HEROES_ON_DUEL[activator] = nil
	if not activator.OnDuel then return end
	if activator:IsWukongsSummon() then return end
	Timers:CreateTimer(function()
		if not IsValidEntity(activator) then return end
		if not Duel:IsDuelOngoing() then return end
		if HEROES_ON_DUEL[activator] then return end
		local caller = trigger.caller
		local origin = caller:GetAbsOrigin()
		local min = origin + ExpandVector(caller:GetBoundingMins(), -455)
		local max = origin + ExpandVector(caller:GetBoundingMaxs(), -455)
		local clamped = VectorOnBoxPerimeter(activator:GetAbsOrigin(), min, max)
		activator:Teleport(clamped)
	end)
end
