local PLUGIN = {}
PLUGIN.ID = "ban" -- unique id
PLUGIN.Name = "Ban" -- Name for in the menu
PLUGIN.Author = "AC2"
PLUGIN.Console = "ban" -- console command 
PLUGIN.Chat = "!ban"
PLUGIN.Help = "Ban Players - !ban <name> <time in minutes> <reason>"
PLUGIN.Flag = "ban" -- flag required

function PLUGIN:Call(ply, args)
	-- Find a target and define vars
	local target = Cure.Admin.FindPlayer(args[1])
	
	-- Nil
	if not (args[2]) then
		args[2] = 60
	end
	
	-- Moderator check
	if (ply:GetRank() == "moderator") then
		if (tonumber(args[2]) == 0) or (tonumber(args[2] or 60) > 180) then
			ply:ChatPrint( "The maximum banlenght you can provide is 3 hours.")
			return
		else
			time = tonumber(os.time()) + (tonumber(args[2] or 60) * 60)
		end
	else
		if (tonumber(args[2]) == 0) then
			time = 0
		else
			time = tonumber(os.time()) + (tonumber(args[2] or 60) * 60)
		end
	end
	
	-- Nil
	reason = table.concat(args," ",3) or "Banned by admin"
	
	-- Couldn't find him
	if not (target) then
		ply:ChatPrint("Could not find player.")
		return
	end
	
	-- immunity
	if not (Cure.Admin.RankCanTarget(ply:GetRank(), target:GetRank())) then
		Cure.Admin.NotifyPlayer(ply, color_white, "Target their rank is higher than yours.")
		return
	end
	
	-- Ban him
	if (target:IsValid()) then
		-- query
		Cure.Admin.BanByName(args[1], reason, time, TYPE_BAN, ply:Name() or "CONSOLE", ply:IPAddress())
		
		-- cache
		table.insert(Cure.Admin.Bans, {["steamid"] = target:SteamID(), ["reason"] = reason, ["time"] = time, type = TYPE_BAN})

		-- notify
		Cure.Admin.NotifyAll(color_red, "(ADMIN) ", color_blue, ply:Name(), color_white, " banned player ", color_red, target:Name(), color_white, ".")

		-- log
		Cure.Error.Log("[ADMIN] "..ply:Name().." ran command ban on "..target:Name().." with time "..time.." with reason "..reason, TYPE_ADMIN)
		
		-- kick
		target:Kick(reason)
	end
end

-- Register plugin
Cure.Admin.RegisterPlugin(PLUGIN)