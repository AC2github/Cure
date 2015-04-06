local PLUGIN = {}
PLUGIN.ID = "commands"
PLUGIN.Name = "Commands"

function PLUGIN:GetArguments(allargs)
	local newargs = {}
	
	for i = 2, #allargs do
		table.insert( newargs, allargs[i] )
	end
	
	return newargs
end

function PLUGIN:CCommand(ply, cmd, cargs)
	if ( #cargs == 0 ) then return end
	if not (ply:IsValid()) then return end

	local command = cargs[1]
	local args = self:GetArguments( cargs )

	for _, plugin in pairs(Cure.Admin.Plugins) do
		if (plugin.Console == string.lower( command or "" ) ) then			
			if (plugin.Flag) then
				if (ply:HasFlag(plugin.Flag)) then
					plugin:Call(ply, args)
				else
					Cure.Admin.NotifyPlayer(ply, color_white, "You don't have access to this command." )
				end
			else
				plugin:Call(ply, args)
			end
	
			return ""
		end
	end
end

concommand.Add( "cure_admin", function(ply, com, args)
	-- Actually calls commands
	PLUGIN:CCommand(ply, com, args)
end )

Cure.Admin.RegisterPlugin(PLUGIN)