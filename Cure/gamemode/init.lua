
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
AddCSLuaFile("shared.lua")

include("sh_init.lua")
include("shared.lua")

resource.AddFile("materials/spiceworks/vgui/icon_exit.png")
resource.AddFile("materials/spiceworks/hud/heart.png")
resource.AddFile("materials/spiceworks/hud/round_bar.png")
resource.AddFile("materials/spiceworks/hud/round_death.png")
resource.AddFile("materials/spiceworks/vgui/background_menu.png")
resource.AddFile("materials/spiceworks/vgui/notification/notifications_background.png")
resource.AddFile("materials/spiceworks/vgui/mainmenu/mainmenu_exitbutton.png")
resource.AddFile("materials/spiceworks/vgui/mainmenu/mainmenu_header.png")
resource.AddFile("materials/spiceworks/vgui/mainmenu/spiceworks_logo_final.png")
resource.AddFile("materials/spiceworks/scoreboard/backgrounds/ac_bg.png")
resource.AddFile("materials/spiceworks/scoreboard/backgrounds/bubbles.png")
resource.AddFile("materials/spiceworks/scoreboard/scoreboard_death.png")
resource.AddFile("materials/spiceworks/scoreboard/scoreboard_footer.png")
resource.AddFile("materials/spiceworks/scoreboard/scoreboard_header.png")
resource.AddFile("materials/spiceworks/scoreboard/scoreboard_runner.png")
resource.AddFile("materials/spiceworks/scoreboard/scoreboard_spectator.png")

resource.AddFile("particles/t5_shop.pcf")

for i = 1, 4 do
	resource.AddFile("materials/spiceworks/hud/bloodeffects/blood"..i..".png")
end

util.AddNetworkString("cure_shop_hat")
util.AddNetworkString("deathrun.killnotifications")

function Cure.NoParse(string)
	local name = string.Replace(string, "<", "")
	name = string.Replace(string, ">", "")
	name = string.Replace(string, "/", "")
	name = string.Replace(string, [[\]], "")

	return name
end


