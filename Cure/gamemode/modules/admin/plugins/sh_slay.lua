local PLUGIN = {}
PLUGIN.ID = "slay" -- unique id
PLUGIN.Name = "Slay" -- Name for in the menu
PLUGIN.Author = "AC2"
PLUGIN.Console = "slay" -- console command 
PLUGIN.Help = "Slay Players - !slay <name>"
PLUGIN.Chat = "!slay" -- Chat command
PLUGIN.Flag = "slay" -- flag required

function PLUGIN:Call(ply, args)
	-- Find a target
	local target = Cure.Admin.FindPlayer(args[1], true)
	
	-- Couldn't find him
	if not (target) then
		ply:ChatPrint( "Could not find player.")
		return
	end

	for k, v in pairs(target) do
		-- Dead
		if not (v:Alive()) then 
			Cure.Admin.NotifyPlayer(ply, color_white, "Target is dead.")
			return
		end
	
		-- IOmmunity
		if not (Cure.Admin.RankCanTarget(ply:GetRank(), v:GetRank())) then
			Cure.Admin.NotifyPlayer(ply, color_white, "Target their rank is higher than yours.")
			return
		end

		-- Slay
		if (v:IsValid()) then
			v:Kill()
			Cure.Admin.NotifyAll(color_red, "[ADMIN] ", color_blue, ply:Name(), color_white, " slayed player ", color_red, v:Name(), color_white, ".")
			Cure.Error.Log("[ADMIN] "..ply:Name().." ran command slay on "..v:Name(), TYPE_ADMIN)
		end
	end
end

-- Register plugin
Cure.Admin.RegisterPlugin(PLUGIN)