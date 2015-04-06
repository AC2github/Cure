--[[
	CureEngine
	A gamemode base

	Credits:
	AC² - Code
--]]

GM.Name = "CureEngine"
GM.Author = "AC²"

TEAM_SPECTATOR = 999
TEAM_SPEC = TEAM_SPECTATOR

function Cure:CreateTeams()
	team.SetUp( TEAM_SPECTATOR, "Spectator", Color( 62, 62, 62, 255 ), false )
	team.SetSpawnPoint( TEAM_SPECTATOR, "info_player_counterterrorist" )
end

-- CONFIG
-- Background effects for certain players

Cure.Config = {}
Cure.Config.pBackgrounds = {}
Cure.Config.pIcons = {}

-- Icons
Cure.Config.pIcons["owner"] = Material("icon16/tux.png")
Cure.Config.pIcons["globaladmin"] = Material("icon16/star.png")
Cure.Config.pIcons["superadmin"] = Material("icon16/shield_add.png")
Cure.Config.pIcons["admin"] = Material("icon16/shield.png")
Cure.Config.pIcons["moderator"] = Material("icon16/user_add.png")
Cure.Config.pIcons["user"] = Material("icon16/user.png")
Cure.Config.pIcons["world"] = Material("icon16/world.png")
Cure.Config.pIcons["jukebox"] = Material("icon16/music.png")

-- Backgrounds
Cure.Config.pBackgrounds["STEAM_0:0:16134549"] = Material("spiceworks/scoreboard/backgrounds/ac_bg.png", "smooth")
Cure.Config.pBackgrounds["STEAM_0:1:69148762"] = Material("spiceworks/scoreboard/backgrounds/bubbles.png", "smooth")

-- Backgrounds for teams
Cure.Config.pBackgrounds[1] = Material("spiceworks/scoreboard/scoreboard_spectator.png", "smooth")
Cure.Config.pBackgrounds[2] = Material("spiceworks/scoreboard/scoreboard_runner.png", "smooth")
Cure.Config.pBackgrounds[3] = Material("spiceworks/scoreboard/scoreboard_death.png", "smooth")

-- Weapons replaced
GM.weapons = {
	"weapon_ak47",
	"weapon_aug",
	"weapon_awp",
	"weapon_deagle",
	"weapon_elite",
	"weapon_glock",
	"weapon_m3",
	"weapon_m4a1",
	"weapon_m249",
	"weapon_mp5navy",
	"weapon_p90",
	"weapon_scout",
	"weapon_sg552",
	"weapon_usp",
	"weapon_xm1014"
}

weapons.Register({Base = "dr_secret"}, "weapon_knife", false)
weapons.Register({Base = "dr_secret"}, "weapon_smokegrenade", false)
weapons.Register({Base = "dr_secret"}, "weapon_flashbang", false)

for k,v in pairs(GM.weapons) do
	scripted_ents.Register({Base = "weapon_spawner"}, v, false)
end


