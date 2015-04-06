
-- Register a new rank
function Cure.Admin.RegisterRank(unique_id, name, desc, immunity, flags)
	-- nil
	if not (unique_id) then
		Cure.Error.Log( "Cure.Admin.RegisterRank called with no argument!", TYPE_LUA)
		return
	end
	
	-- Already have one
	if (Cure.Admin.IsValidRank(unique_id)) then return end
	
	-- register it
	local count = #Cure.Admin.Ranks
	Cure.Admin.Ranks[count+1] = {["id"] = unique_id, ["name"] = name or "N/A", ["desc"] = desc or "N/A", ["immunity"] = immunity or 1, ["flags"] = flags or {}}
	
	print("[Cure] Registered rank "..name)
end

-- Get data from a rank
function Cure.Admin.GetRankData(rank)
	-- nil
	if not (rank) then
		Cure.Error.Log( "Cure.Admin.GetRankData called with no argument!", TYPE_LUA)
		return
	end
	
	-- Check if it exists
	if not (Cure.Admin.IsValidRank(rank)) then return end
	
	-- return shit
	for k, v in pairs(Cure.Admin.Ranks) do
		if (v.id == rank) then
			return v
		end
	end
	
	return {}
end

-- See if it's a registered rank
function Cure.Admin.IsValidRank(rank)
	-- nil
	if not (rank) then 
		Cure.Error.Log( "Cure.Admin.IsValidRank called with no argument!", TYPE_LUA)
		return
	end
	
	-- Lets search it
	for k,v in pairs(Cure.Admin.Ranks) do
		if (v.id == rank) then
			-- found it
			return true
		end
	end
	
	return false
end

-- Get flags
function Cure.Admin.GetFlags(rank)
	-- nil
	if not (rank) then
		Cure.Error.Log( "Cure.Admin.GetFlags called with no argument!", TYPE_LUA)
		return {}
	end
	
	-- Check if it exists
	if not (Cure.Admin.IsValidRank(rank)) then return {} end
	
	-- Get stuff
	local flags = Cure.Admin.GetRankData(rank).flags
	
	return flags
end

-- See if a rank can target another rank
function Cure.Admin.RankCanTarget(rank1, rank2)
	-- errors
	if not (rank1) or not (rank2) then return end
	
	-- just check immunity number
	return (Cure.Admin.GetRankData(rank1).immunity >= (Cure.Admin.GetRankData(rank2).immunity))
end

-- Transfer flags
function Cure.Admin.CopyFlags(from,to)
	-- nil
	if not (from) then
		Cure.Error.Log( "Cure.Admin.CopyFlags called with no from argument!", TYPE_LUA)
		return
	end
	
	if not (to) then
		Cure.Error.Log( "Cure.Admin.CopyFlags called with no to argument!", TYPE_LUA)
		return
	end
	
	-- from/to
	local source = Cure.Admin.GetFlags(from)
	local destination = Cure.Admin.GetFlags(to)
	
	-- add them
	for k,v in pairs(source) do
		table.insert(destination, v)
	end
end

-- See if a rank has a flag
function Cure.Admin.HasFlag(rank, flagid)
	-- nil
	if not (rank) then return false end
	if not (flagid) then return false end
	
	-- Check if it exists
	if not (Cure.Admin.IsValidRank(rank)) then return false end
	
	-- Get flags
	local data = Cure.Admin.GetRankData(rank)
	
	-- Search the flag and return true if found
	if (table.HasValue(data.flags, flagid)) then
		return true
	end
	
	return false
end

-- Create ranks
Cure.Admin.RegisterRank("user", "User", "Default rank", 1, {})
Cure.Admin.RegisterRank("moderator", "Moderator", "Limited access", 2, {"kick", "ban", "slay", "slap", "bring", "mute", "gag"})
Cure.Admin.RegisterRank("admin", "Admin", "Default admin rank", 3, {"goto", "health"})
Cure.Admin.RegisterRank("superadmin", "Super Admin", "Default superadmin rank", 4, {"spawn"})
Cure.Admin.RegisterRank("globaladmin", "Global Admin", "Global admin rank", 5, {})
Cure.Admin.RegisterRank("owner", "Owner", "Default Owner rank", 99, {})

-- Copy flags
Cure.Admin.CopyFlags("moderator","admin")
Cure.Admin.CopyFlags("admin","superadmin")
Cure.Admin.CopyFlags("superadmin", "globaladmin")
Cure.Admin.CopyFlags("globaladmin","owner")

Cure.Error.Print("Registered a total of "..#Cure.Admin.Ranks.." ranks.")
	