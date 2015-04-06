
-- Table
Cure.Afk = {}

-- Vars
Cure.Afk.Time = 180

-- Add more time
function Cure.Afk.KeyPress(player, key)
	player.AFKTime = (CurTime() + Cure.Afk.Time)
end

function Cure.Afk.ToggleAfk(player)
	player.IsAFK = not player.IsAFK
	
	-- Message
	if (player:IsAway()) then
		player:ChatPrint( "You are now afk." )
		player:Kill()

		-- Kick him after 3 times
		player.AFKTimes = player.AFKTimes + 1

		if (player.AFKTimes >= 3) then
			player:Kick("You have been kicked for being afk too long.")
		end
	end
end

-- Check for afks
function Cure.Afk.Think()
	for k, v in pairs(player.GetAll()) do
		if (v.AFKTime) then
			if (v.AFKTime < CurTime()) then
				if (v.IsAFK == false) and (v:Alive()) then
					Cure.Afk.ToggleAfk(v)
				end
			end
		end
	end
end


