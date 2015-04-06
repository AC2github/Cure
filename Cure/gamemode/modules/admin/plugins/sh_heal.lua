local PLUGIN = {}
PLUGIN.ID = "heal" -- unique id
PLUGIN.Name = "Heal" -- Name for in the menu
PLUGIN.Author = "AC2"
PLUGIN.Help = "Heal Players - !health <name> <amount>"
PLUGIN.Console = "health" -- console command 
PLUGIN.Flag = "health" -- flag required
PLUGIN.Chat = "!hp"

function PLUGIN:Call(ply, args)
	-- Find a target
	local target = Cure.Admin.FindPlayer(args[1])
	local health = tonumber(args[2]) or 100

	-- Ehh, too big
	if (health > 99999) then
		ply:ChatPrint("Your second argument is too big.")
		return
	end
	
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
	
	-- heal him
	if (target:IsValid()) then
		-- Set health
		target:SetHealth(health)

		-- notify
		Cure.Admin.NotifyAll(color_red, "[ADMIN] ", color_blue, ply:Name(), color_white, " set ", color_red, target:Name(), color_white, " their health to ", color_red, tostring(health), color_white, ".")

		-- Log
		Cure.Error.Log("[ADMIN] "..ply:Name().." ran command heal on "..target:Name(), TYPE_ADMIN)
	end
end

-- Register plugin
Cure.Admin.RegisterPlugin(PLUGIN)