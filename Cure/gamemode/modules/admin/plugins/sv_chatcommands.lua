local PLUGIN = {}
PLUGIN.ID = "chatcommands"
PLUGIN.Name = "Chat Commands"

function PLUGIN:GetArguments(allargs)
	local newargs = {}
	
	for i = 2, #allargs do
		table.insert( newargs, allargs[i] )
	end
	
	return newargs
end

function PLUGIN:PlayerSay(ply, cmd, args)
	if not (ply:IsValid()) then return end
	
	for _, plugin in pairs(Cure.Admin.Plugins) do
		if (plugin.Chat == cmd) then
			if (plugin.Flag) then
				if (ply:HasFlag(plugin.Flag)) then
					plugin:Call(ply, args)
				else
					Cure.Admin.NotifyPlayer(ply, color_white, "You don't have access to this command." )
				end
			else
				plugin:Call(ply, args)
			end
		end
	end
end

Cure.Admin.RegisterPlugin(PLUGIN)