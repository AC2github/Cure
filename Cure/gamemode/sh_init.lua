-- Easy access
Cure = GM

color_red = Color(255, 0, 0)
color_blue = Color(0, 0, 255)
color_yellow = Color(255, 255, 0)

--[[
	-- Get base path from the gamemode
--]]
function Cure.GetBasePath(bool)
	if (bool) then
		if (SERVER) then
			return "gamemodes/Cure/gamemode/"
		else
			return "Cure/gamemode/"
		end
	else
		return "gamemodes/Cure/gamemode/"
	end
end

--[[
	Loads all files inside a certain folder.

	Arguments:
		- folder: what folder to load.
	Usage:
		- Cure.LoadFolder("shared") : Will load all *.lua inside this folder.
--]]
function Cure.LoadFolder(folder)
	if not (folder) then return end
	
	-- Add a /
	if not (string.Right(folder, 1) == "/") then
		folder = folder.."/"
	end
	
	-- Setup a path
	local path = Cure.GetBasePath()
	
	-- Search files
	local files = file.Find(path..folder.."*.lua", "GAME")

	if (CLIENT) then
		path = Cure.GetBasePath(true)
		files = file.Find(path..folder.."*.lua", "LUA")
	end
	
	-- Found em
	if (files) then
		for k,v in pairs(files) do
			-- Clientside
			if (string.Left(v, 3) == "cl_") or (string.Left(v, 5) == "vgui_") then
				if (SERVER) then
					AddCSLuaFile(folder..v)
				end
				
				if (CLIENT) then
					include(folder..v)
				end
				
			-- Serverside
			elseif (string.Left(v, 3) == "sv_") then
				if (SERVER) then
					include(folder..v)
				end
				
			-- Shared
			elseif (string.Left(v, 3) == "sh_") then
				if (SERVER) then
					AddCSLuaFile(folder..v)
					include(folder..v)
				end
				
				if (CLIENT) then
					include(folder..v)
				end
			end
		end
	end
end

--[[
	Loads all files inside a module folder

	Requirements:
	- Server folder
	- Client folder
	- Files must start with the prefix
		- vgui_
		- cl_
		- sh_
		- sv_
	Arguments:
		- folder: what folder to load.
	Usage:
		- Cure.LoadModule("shop") : Will load all *.lua inside this folder.
--]]
function Cure.LoadModule(folder)	
	if not (folder) then return end
	
	-- Add a /
	if not (string.Right(folder, 1) == "/") then
		folder = folder.."/"
	end
	
	-- Setup a path
	local path = "modules/"

	-- Load all files inside this one
	Cure.LoadFolder(path..folder)

	-- Search files
	local files, folders = file.Find(Cure.GetBasePath(false)..path..folder.."/*", "GAME")

	if (CLIENT) then
		files, folders = file.Find(Cure.GetBasePath(true)..path..folder.."*.lua", "LUA")
	end

	if (CLIENT) then
		--PrintTable(files)

	end

	-- Load them
	for k, v in pairs(folders) do
		if CLIENT then print("V:"..v) end
		Cure.LoadFolder(path..folder..v)
	end
end

-- Admin
Cure.Admin = {}
Cure.Admin.Ranks = {}
Cure.Admin.Bans = {}

-- Modules
Cure.LoadModule("mysql")
Cure.LoadModule("stats")
Cure.LoadModule("achievements")
Cure.LoadModule("admin")
Cure.LoadModule("admin/client")
Cure.LoadModule("jukebox")
Cure.LoadModule("jukebox/client")
Cure.LoadModule("shop")
Cure.LoadModule("shop/client")
Cure.LoadModule("levelsystem")
Cure.LoadModule("levelsystem/client")

-- Shared
Cure.LoadFolder("shared")
Cure.LoadFolder("shared/items")

-- Server
Cure.LoadFolder("server/core")
Cure.LoadFolder("server")
Cure.LoadFolder("server/events")

-- Client
Cure.LoadFolder("client/hud")
Cure.LoadFolder("client/vgui")
Cure.LoadFolder("client")
