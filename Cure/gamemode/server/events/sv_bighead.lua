local event = {}
event.ID = "bighead"
event.Name = "BigHead mode"
event.Help = "BIG HEADS!"

function event:OnRoundPhase(phase, winner)
	if (phase == ROUND_ACTIVE) then
		for k, v in pairs(player.GetAll()) do
			if (v:Team() == TEAM_RUNNER) then
				v:ManipulateBoneScale(6, Vector(4, 4, 4))
			end
		end

		Cure:SendNotifcation(v, event.Name, event.Help, 3, .6)
	end
end

function event:OnPlayerSpawn(player)
end

function event:OnPlayerDeath(victim, attacker)
	victim:ManipulateBoneScale(6, Vector(1, 1, 1))
end

Cure.Events.Register(event)