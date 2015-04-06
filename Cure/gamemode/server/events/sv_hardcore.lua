local event = {}
event.ID = "speedrun"
event.Name = "Speedrun"
event.Help = "Complete the map in under 2 minutes time"

function event:OnRoundPhase(phase, winner)
end

Cure.Events.Hook(event.ID, "PlayerSpawn", function(pl)
	print("called")
	print(pl:Name())
end)

Cure.Events.Hook(event.ID, "PlayerDeath", function()
	print("called death")
end)

function event:OnPlayerDeath(victim, attacker)
end

Cure.Events.Register(event)