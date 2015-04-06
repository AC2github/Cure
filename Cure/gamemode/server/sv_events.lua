--[[
	Round based events

	Functions:
		- Cure.Events.Register - Register from table
		- Cure.Events.GetActiveEvent - Current active event
		- Cure.Events.SetActiveEvent - Set a round
		- Cure.Events.Hook - Hook

	Credits:
		- AC²
--]]

Cure.Events = {}
Cure.Events.Data = {}
Cure.Events.Hooks = {}
Cure.Events.Active = "default"

-- Register a new Events
function Cure.Events.Register(event)
	Cure.Events.Data[event.ID] = event
end

-- Get current event
function Cure.Events.GetActiveEvent()
	return Cure.Events.Active
end

-- Set an event
function Cure.Events.SetActiveEvent(event)
	-- Clear up old hooks
	if (Cure.Events.Hooks[Cure.Events.GetActiveEvent()]) then
		for k, v in pairs(Cure.Events.Hooks[Cure.Events.GetActiveEvent()]) do
			hook.Remove(v.hook, Cure.Events.GetActiveEvent().."-"..v.hook)
		end
	end

	-- Find it
	for k, v in pairs(Cure.Events.Data) do
		if (event == v.ID) then
			Cure.Events.Active = event

			if (Cure.Events.Hooks[event]) then
				for i, j in pairs(Cure.Events.Hooks[event]) do
					hook.Add(j.hook, event.."-"..j.hook, j.func)
				end
			end

			return
		end
	end

	-- If invalid
	Cure.Events.Active = "default"
end


-- Hook
function Cure.Events.Hook(event, hook, func)
	-- Create table if not exists
	if not (Cure.Events.Hooks[event]) then
		Cure.Events.Hooks[event] = {}
	end

	-- Store
	table.insert(Cure.Events.Hooks[event], {hook = hook, func = func})
end

