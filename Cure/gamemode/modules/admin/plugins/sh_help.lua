local PLUGIN = {}
PLUGIN.ID = "help"
PLUGIN.Name = "Help"
PLUGIN.Author = "AC2"
PLUGIN.Console = "help"
PLUGIN.Chat = "!help"
PLUGIN.Help = "Admin Help - !help"

function PLUGIN:Call(ply, args)
	ply:PrintMessage(HUD_PRINTCONSOLE, "==========")
	
	for k, v in pairs(Cure.Admin.Plugins) do
		if (v.Help) then
			ply:ChatPrint(v.Help)
		end
	end
	
	ply:PrintMessage(HUD_PRINTCONSOLE, "==========")
	Cure.Admin.NotifyPlayer(ply, color_white, "See your chat for output." )
end

Cure.Admin.RegisterPlugin(PLUGIN)