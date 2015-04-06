local PLUGIN = {}
PLUGIN.ID = "kick" -- unique id
PLUGIN.Name = "Kick" -- Name for in the menu
PLUGIN.Author = "AC2"
PLUGIN.Console = "kick" -- console command 
PLUGIN.Help = "Kick Players - !kick <name> <reason>"
PLUGIN.Chat = "!kick" -- Chat command
PLUGIN.Flag = "kick" -- flag required

function PLUGIN:Call(ply, args)
	-- Find a target
	local target = Cure.Admin.FindPlayer(args[1])
	local reason = table.concat( args, " ", 2 )
	
	if not (reason) then
		reason = "Kicked by admin"
	end
	
	-- Couldn't find him
	if not (target) then
		ply:ChatPrint( "Could not find player.")
		return
	end	
		
	-- immunity
	if not (Cure.Admin.RankCanTarget(ply:GetRank(), target:GetRank())) then
		Cure.Admin.NotifyPlayer(ply, color_white, "Target their rank is higher than yours.")
		return
	end
	
	-- Kick him
	if (target:IsValid()) then
		Cure.Admin.NotifyAll(color_red, "[ADMIN] ", color_blue, ply:Name(), color_white, " kicked player ", color_red, target:Name(), color_white, ".")
		Cure.Error.Log("[ADMIN] "..ply:Name().." ran command kick on "..target:Name().." with reason "..reason, TYPE_ADMIN)
		target:Kick(reason)
	end
end

-- Register plugin
Cure.Admin.RegisterPlugin(PLUGIN)