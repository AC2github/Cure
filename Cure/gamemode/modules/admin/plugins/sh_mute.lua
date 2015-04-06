local PLUGIN = {}
PLUGIN.ID = "mute" -- unique id
PLUGIN.Name = "Mute" -- Name for in the menu
PLUGIN.Author = "AC2"
PLUGIN.Console = "mute" -- console command 
PLUGIN.Help = "Mute Players - !mute <name>"
PLUGIN.Chat = "!mute" -- Chat command
PLUGIN.Flag = "mute" -- flag required

function PLUGIN:Call(ply, args)
	local target = Cure.Admin.FindPlayer(args[1])
	local time = 60

	-- nope
	if not (target) then
		Cure.Admin.NotifyPlayer(ply, color_white, "Could not find player.")
		return
	end

	-- Nil
	if not (args[2]) or not (type(args[2] == "number")) then
		args[2] = 60
	end
	
	-- Moderator check
	if (ply:GetRank() == "moderator") then
		if (tonumber(args[2]) == 0) or (tonumber(args[2] or 60) > 180) then
			ply:ChatPrint( "The maximum lenght you can provide is 3 hours.")
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
	reason = table.concat(args," ",3) or "Muted by admin"

	-- Nil
	if not (target.Mute) then
		target.Mute = false
	end

	-- Reverse da boolean
	target.Mute = not target.Mute

	-- Mute
	if (target.Mute) then
		Cure.Admin.Bans[target:SteamID()] = {["steamid"] = target:SteamID(), ["reason"] = reason, ["time"] = time, ["type"] = TYPE_BAN_MUTE}
	else
		Cure.Admin.RemoveBan(target:SteamID(), TYPE_BAN_MUTE)
	end

	-- Notify
	Cure.Admin.NotifyAll(color_red, "[ADMIN] ", color_blue, ply:Name(), color_white, (target.Mute and " muted " or " unmuted "), color_red, target:Name(), color_white, ".")

	-- Log
	Cure.Error.Log("[ADMIN] "..ply:Name().." ran command mute ("..(target.Mute and "on" or "off")..") on "..target:Name(), TYPE_ADMIN)
end

Cure.Admin.RegisterPlugin(PLUGIN)