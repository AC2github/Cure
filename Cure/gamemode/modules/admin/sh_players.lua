
-- Enums
TYPE_FIND_ADMIN = 1
TYPE_FIND_ALL = 2
TYPE_FIND_SPECTATORS = 3
TYPE_FIND_ALIVE = 4

-- Find a player by name
function Cure.Admin.FindPlayer(name, allowmultiple)
	-- Allow more than one target
	allowmultiple = allowmultiple or false
	
	-- Store results
	local results = {}

	-- arguments check
	if not (name) then return end

	if (name == "*") then return player.GetAll() end
	if (name == "[ALIVE]") then return Cure.Admin.FindPlayers(TYPE_FIND_ALIVE) end
	if (name == "[SPECTATORS]") then return Cure.Admin.FindPlayers(TYPE_FIND_SPECTATORS) end
	if (name == "[ADMIN]") then return Cure.Admin.FindPlayers(TYPE_FIND_ADMIN) end
	
	-- find it
	for k,v in pairs(player.GetAll()) do
		if (string.find(string.lower(v:Name()), tostring(string.lower(name)))) then
			if (allowmultiple) then
				table.insert(results, v)
			else
				return v
			end
		end
	end
	
	return (results or nil)
end

-- Find a player by ID
function Cure.Admin.FindPlayerByID(id)
	-- arguments check
	if not (id) then return end
	
	-- find it
	for k,v in pairs(player.GetAll()) do
		if (v:UserID() == tonumber(id)) then
			return v
		end
	end
	
	return nil
end

-- Find a player by steamid
function Cure.Admin.FindPlayerBySteamID(steamid)
	-- arguments check
	if not (steamid) then return end
	
	for k,v in pairs(player.GetAll()) do
		if (v:SteamID() == tostring(steamid)) then
			return v
		end
	end
	
	return nil
end


function Cure.Admin.FindPlayers(input)
	-- argument check
	if not (input) then return {} end
	
	-- results
	local results = {}
	
	-- functions that give us the result
	-- i hate if/elseif checks
	local PlayerFinds = {
		-- admins
		[TYPE_FIND_ADMIN] = function()
			for k, v in pairs(player.GetAll()) do
				if (v:IsAdmin()) then
					table.insert(results, v)
				end
			end
		end,
		
		-- everyone
		[TYPE_FIND_ALL] = function()
			results = player.GetAll()
		end,
		
		-- spectators
		[TYPE_FIND_SPECTATORS] = function()
			for k,v in pairs(player.GetAll()) do
				if (v:Team() == TEAM_SPECTATOR) then
					table.insert(results, v)
				end
			end
		end,
		
		-- alive
		[TYPE_FIND_ALIVE] = function()
			for k,v in pairs(player.GetAll()) do
				if not (v:Team() == TEAM_SPECTATOR) then
					table.insert(results, v)
				end
			end
		end,
	}

	-- Call the function once
	if (PlayerFinds[input]) then
		PlayerFinds[input]()
	end
	
	-- return results
	return results
end

-- Find a player by query
function Cure.Admin.FindPlayerByQuery(steamid)
	Cure.Database.Query([[SELECT * FROM Cure_player_data WHERE steamid = ']]..steamid..[[']], function(data)
		if (Cure.Database.IsValidData(data)) then
			return data[1]
		end
	end)
end