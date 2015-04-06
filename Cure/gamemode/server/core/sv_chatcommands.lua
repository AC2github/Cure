Cure.ChatCommands = {}

-- Add a chatcommand
function Cure.AddChatCommand( command, func, show )
	-- Small check
	for k, v in pairs(Cure.ChatCommands) do
		if (v.command == command) then
			print( "[Cure] There is already a chatcommand with that name!" )
			return
		end
	end
	
	-- Insert
	Cure.ChatCommands[command:lower()] = {["func"] = func, ["show"] = show or false}
end

function Cure.RunChatCommand(player, command, arguments)
	local funct
	
	-- Find it
	if (Cure.ChatCommands[command]) then
		funct = Cure.ChatCommands[command].func
	end
	
	-- Simple check
	if not(funct) then
		return
	end
	
	-- Call functions
	funct(player, command, arguments)
end

function GM:PlayerSay(player, text)
	-- Mute plugin
	if (Cure.Admin.Bans[player:SteamID()]) then
		-- Time expired, unban him
		if (Cure.Admin.GetBannedData(player:SteamID(), TYPE_BAN_MUTE).time < os.time()) then
			-- So if he's muted or gagged
			Cure.Database.Query([[DELETE FROM cure_bans WHERE steamid = ']]..player:SteamID()..[[' AND type = '2']])
			
			-- Remove cache
			Cure.Admin.RemoveBan(player:SteamID(), TYPE_BAN_MUTE)

			-- Eh
			return text
		end

		-- Banned
		if (Cure.Admin.Bans[player:SteamID()].type == TYPE_BAN_MUTE) then
			-- Calculate time
			local timeleft = Cure.Admin.Bans[player:SteamID()].time - os.time()
			local minutes = math.floor(timeleft / 60)
			local seconds = timeleft - (minutes * 60)
			local hours = math.floor(minutes / 60)

			-- ChatPrint
			player:ChatPrint(Format("You are muted for: '%s'. The ban will expire in %s.", Cure.Admin.Bans[player:SteamID()].reason, hours.."h:"..minutes.."m:"..seconds.."s"))
			return ""
		end
	end

	-- Logs
	Cure.Error.Log("Player "..player:Name().." <"..player:SteamID().."> <"..player:IPAddress().."> said "..text, TYPE_CHAT)
	
	-- Taking from Rabbish chatcommand module
	local txt = text
	txt = txt:sub( 1 )

	local cmd = txt:match( "^(%S+)" )
	txt = txt:gsub( "^(%S+)", "",10 )

	local quote = txt:sub( 1, 1 ) ~= '"'
	local ret = {}
	for chunk in txt:gmatch( '[^"]+' ) do
		quote = not quote
		if quote then
			table.insert( ret, chunk )
		else
			for chunk in chunk:gmatch( "%S+" ) do
				table.insert( ret, chunk )
			end
		end
	end

	-- Admin module
	local chatcommands = Cure.Admin.GetPlugin("chatcommands")
	chatcommands:PlayerSay(player, cmd, ret)

	-- Run it
	Cure.RunChatCommand(player, cmd, ret)
	
	-- Show it or not
	if (Cure.ChatCommands[cmd]) then
		if not (Cure.ChatCommands[cmd].show) then
			return ""
		end
	end
	
	return text
end