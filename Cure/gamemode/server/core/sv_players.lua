
Cure.Player = {}

-- Find a player
function Cure.Player.FindPlayer( input )
	-- results
	local results = {}
	
	-- by id
	if (type(input) == "number") then
		for k, v in pairs( player.GetAll() ) do
			if (v:UserID() == tonumber(input)) then
				table.insert( results, v )
				return results
			end
		end
	end
	
	-- by name
	if (type(input) == "string") then
		for k, v in pairs( player.GetAll() ) do
			if (string.lower(v:Name()) == string.lower(input)) then
				table.insert( results, v )
				return results
			end
		end
		
		for k, v in pairs( player.GetAll() ) do
			if (string.find(string.lower(v:Name()), string.lower(input))) then
				table.insert( results, v )
				return results
			end
		end
	end
	
	return "#NONE"
end

-- Print something to all
function Cure.Player.PrintAll(str, icon)
	for k,v in pairs(player.GetAll()) do
		v:ChatPrint(str, icon)
	end
end

-- Get all alive players
function Cure.Player.GetAlivePlayers()
	-- store them here
	local alive = {}
	
	-- get alive players
	for k, v in pairs( player.GetAll() ) do
		if (v:Alive()) then
			table.insert( alive, v )
		end
	end
	
	return alive
end

-- Get previous player for spectating
function Cure.Player.GetPrevPlayer( player )
	local aliveplayers = Cure.Player.GetAlivePlayers()
	
	-- if we don't have any
	if (#aliveplayers < 1) then return nil end
	if not IsValid(player) then return aliveplayers[1] end
	
	local old
	
	-- find him
	for k,v in pairs(aliveplayers) do
		if (v == player) then
			return old or aliveplayers[#aliveplayers]
		end
		
		old = v
	end
	
	-- last check
	if not (IsValid(old)) then
		return aliveplayers[#aliveplayers]
	end
	
	return old
end

-- Get next player for spectating
function Cure.Player.GetNextPlayer( player )
	local aliveplayers = Cure.Player.GetAlivePlayers()
	
	-- if we don't have any
	if (#aliveplayers < 1) then return nil end
	if not IsValid(player) then return aliveplayers[1] end
	
	local old, new
	
	-- find him
	for k,v in pairs(aliveplayers) do
		if (old == player) then
			new = v
		end
		
		old = v
	end
	
	-- last check
	if not (IsValid(old)) then
		return aliveplayers[1]
	end
	
	return new
end
