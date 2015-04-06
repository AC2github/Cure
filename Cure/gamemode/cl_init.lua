
-- Load
include("sh_init.lua")
include("shared.lua")

-- Fonts
surface.CreateFont("hud:spectator", {font = "Arial", size = 16, weight = 400})
surface.CreateFont("hud:timer", {font = "Trebuchet MS", size = 40, weight = 800})
surface.CreateFont("vgui:label_large", {font = "BebasNeue", size = 40, weight = 100})
surface.CreateFont("vgui:button", {font = "BebasNeue", size = 30, weight = 100})
surface.CreateFont("vgui:button_small", {font = "BebasNeue", size = 20, weight = 400})
surface.CreateFont("hud.notify", {font="BebasNeue", size=ScreenScale(28), weight = 100, antialias = true})
surface.CreateFont("hud:title", {font="BebasNeue", size=63.75, weight = 100, antialias = true})
surface.CreateFont("hud:text", {font="BebasNeue", size=38.25, weight = 300, antialias = true})
surface.CreateFont("hud:text.small", {font="BebasNeue", size=25.5, weight = 300, antialias = true})

hook.Add("Think", "PlayerValid", function()
	if (LocalPlayer():IsValid()) then
		-- Tell the server we are ready
		RunConsoleCommand("_PlayerReady")

		-- Tables
		LocalPlayer().PlayerData = {}
		LocalPlayer().PlayerData["achievements"] = {}
		LocalPlayer().PlayerData["stats"] = {}
		LocalPlayer().PlayerData["equipment"] = {}
		LocalPlayer().PlayerData["inventory"] = {}
		LocalPlayer().PlayerData["shop"] = {}

		-- Remove hook
		hook.Remove("Think", "PlayerValid")
	end
end)

