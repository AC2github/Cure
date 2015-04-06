
-- networking
if (SERVER) then
	util.AddNetworkString("cure.notifychat")
end

-- Prints a message to everyone
function Cure.Admin.PrintAll(message)
	-- Error
	if not (message) then return end
	
	-- Get all players
	local players = Cure.Admin.FindPlayers(TYPE_FIND_ALL)
	
	-- Print message
	for k, v in pairs(players) do
		if (v:IsValid()) then
			v:ChatPrint(message)
		end
	end
end

-- Version of chat.addtext
function Cure.Admin.NotifyAll(...)
	local args = {...}
	
	-- error
	if not (args) then return end

	-- Eh
	if (SERVER) then
		-- Send
		net.Start("cure.notifychat")
			net.WriteTable(args)
		net.Broadcast()
	else
		chat.AddText(unpack(args))
	end
end

-- Same as above, but only for one player
function Cure.Admin.NotifyPlayer(player, ...)
	local args = {...}
	
	-- error
	if not (args) then return end
	if not (player) or not (player:IsValid()) then return end

	-- Eh
	if (SERVER) then
		-- Send
		net.Start("cure.notifychat")
			net.WriteTable(args)
		net.Send(player)
	else
		chat.AddText(unpack(args))
	end
end