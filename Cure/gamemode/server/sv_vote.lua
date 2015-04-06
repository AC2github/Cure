
-- Vars
Cure.MapVote = {}
Cure.MapVote.CanVote = false
Cure.MapVote.Nextmap = game.GetMap()

-- Others
Cure.Maps = {}
Cure.VoteTable = {}

-- Network
util.AddNetworkString( "votemaps" )

-- Add maps
function Cure.MapVote.FindMaps( str )
	for k, v in pairs(file.Find( "maps/*", "GAME" )) do
		if (v:find(str)) and (v:find(".bsp")) and not (game.GetMap() == v:Replace( ".bsp", "")) then
			if not table.HasValue(Cure.Maps, v) then
				table.insert(Cure.Maps, v:Replace( ".bsp", "" ))
			end
		end
	end
end

-- Generate random maps
function Cure.MapVote.GenerateRandomMaps(amount)
	for k, v in RandomPairs(Cure.Maps) do
		if not (table.HasValue(Cure.VoteTable, v)) then
			table.insert(Cure.VoteTable, {["id"] = v, ["votes"] = 0 })
			if (#Cure.VoteTable >= amount) then break end
		end
	end
end

-- Start
function Cure.MapVote.Start()
	-- Allow voting
	Cure.MapVote.CanVote = true
	
	-- Notify
	Cure.Player.PrintAll("Time to vote")
	
	-- Send maps
	net.Start( "votemaps" )
		net.WriteTable(Cure.VoteTable)
	net.Broadcast()
	
	-- Get da next map
	timer.Simple( 30, function()
		Cure.MapVote.CanVote = false
		table.SortByMember(Cure.VoteTable, "votes")
		Cure.MapVote.Nextmap = Cure.VoteTable[1].id
		Cure.Player.PrintAll( "Voting finished, next map will be "..Cure.MapVote.Nextmap )
	end)
end

-- Actual vote function
function Cure.MapVote.Vote(player, map)
	-- No time to vote yet
	if (Cure.MapVote.CanVote == false) then return end
	
	-- Invalid map
	if not (Cure.VoteTable[map]) then return end
	
	-- Invalid map
	if not (table.HasValue(Cure.Maps, Cure.VoteTable[map].id)) then
		Cure.Error.Log(player:Name() .. " <"..player:SteamID().."> voted for an invalid map! #1", TYPE_MAP)
		return
	end
	
	-- Already voted
	if (player.HasVoted) then
		Cure.Error.Log(player:Name() .. " <"..player:SteamID().."> already voted", TYPE_MAP)
		return
	end
	
	-- Vote
	if (Cure.VoteTable[map]) then
		if (player:IsDonator()) then
			Cure.VoteTable[map].votes = Cure.VoteTable[map].votes + 2
		else
			Cure.VoteTable[map].votes = Cure.VoteTable[map].votes + 1
		end
	else
		Cure.Error.Log(player:Name() .. " <"..player:SteamID().."> voted for an invalid map! #2", TYPE_MAP)
		return
	end

	-- Some checkps
	player.HasVoted = true
	Cure.Player.PrintAll( player:Name() .. " has placed "..(player:IsDonator() and "2" or "1").. " votes for "..Cure.VoteTable[map].id )
end

-- Simple consolecommand
concommand.Add( "cure_vote", function(ply, cmd, args)
	if not (ply:IsValid()) then return end
	if not (args[1]) then return end
	
	Cure.MapVote.Vote(ply, tonumber(args[1]))
end)