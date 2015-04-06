
Cure.Admin.Plugins = {}

-- Register plugin
function Cure.Admin.RegisterPlugin(plugin)
	local data = plugin
	local count = #Cure.Admin.Plugins
	
	-- Register it
	Cure.Admin.Plugins[data.ID] = data
	
	-- Notify
	print("[Cure] Registering plugin "..data.ID)
end

-- Find a plugin by it's ID
function Cure.Admin.GetPlugin(id)
	for _, plugin in pairs(Cure.Admin.Plugins) do
		if (plugin.ID == id) then
			return plugin
		end
	end
end
