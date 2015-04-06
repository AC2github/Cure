local PLUGIN = {}
PLUGIN.ID = "goto" -- unique id
PLUGIN.Name = "Goto" -- Name for in the menu
PLUGIN.Author = "BlackSteve"
PLUGIN.Help = "Teleport to players - !goto <name>"
PLUGIN.Console = "goto" -- console command 
PLUGIN.Flag = "goto" -- flag required
PLUGIN.Chat = "!goto"

-- ULX CODE
function PLUGIN:Teleport( from, to, force )
	if not to:IsInWorld() and not force then return false end -- No way we can do this one

	local yawForward = to:EyeAngles().yaw
	local directions = { -- Directions to try
		math.NormalizeAngle( yawForward - 180 ), -- Behind first
		math.NormalizeAngle( yawForward + 90 ), -- Right
		math.NormalizeAngle( yawForward - 90 ), -- Left
		yawForward,
	}

	local t = {}
	t.start = to:GetPos() + Vector( 0, 0, 32 ) -- Move them up a bit so they can travel across the ground
	t.filter = { to, from }

	local i = 1
	t.endpos = to:GetPos() + Angle( 0, directions[ i ], 0 ):Forward() * 47 -- (33 is player width, this is sqrt( 33^2 * 2 ))
	local tr = util.TraceEntity( t, from )
	
	while tr.Hit do -- While it's hitting something, check other angles
		i = i + 1
		if i > #directions then	-- No place found
			if force then
				return to:GetPos() + Angle( 0, directions[ 1 ], 0 ):Forward() * 47
			else
				return false
			end
		end

		t.endpos = to:GetPos() + Angle( 0, directions[ i ], 0 ):Forward() * 47

		tr = util.TraceEntity( t, from )
	end

	return tr.HitPos
end

function PLUGIN:Call(ply, args)
	-- Find a target
	local target = Cure.Admin.FindPlayer(args[1])
	
	-- Couldn't find him
	if not (target) then
		ply:ChatPrint( "Could not find player.")
		return
	end
	
	-- dead
	if not (target:Alive()) then 
		Cure.Admin.NotifyPlayer(ply, color_white, "Target is dead.")
		return
	end
	
	-- immunity
	if not (Cure.Admin.RankCanTarget(ply:GetRank(), target:GetRank())) then
		Cure.Admin.NotifyPlayer(ply, color_white, "Target their rank is higher than yours.")
		return
	end
	
	-- Goto him
	if (target:IsValid()) then
		local teleport = self:Teleport(ply, target, false)
		
		if (teleport) then
			ply:SetPos(teleport)
			Cure.Admin.NotifyAll(color_red, "[ADMIN] ", color_blue, ply:Name(), color_white, " teleported to player ", color_red, target:Name(), color_white, ".")
			Cure.Error.Log("[ADMIN] "..ply:Name().." ran command goto on "..target:Name(), TYPE_ADMIN)
		else
			ply:ChatPrint( "Cannot find space to put you in." )
			return
		end
	end
end

-- Register plugin
Cure.Admin.RegisterPlugin(PLUGIN)