// Load our admins

-- Called when a player is valid
-- Sets his rank
function Cure.Admin.LoadAdmin(ply)
	Cure.Database.Query([[SELECT rank FROM cure_admins WHERE steamid = ']]..ply:SteamID()..[[']], function(data)
		if (Cure.Database.IsValidData(data)) then
			local rank = data[1]["rank"]
			
			-- See if it's a valid rank
			if (Cure.Admin.IsValidRank(rank)) then
				-- Change rank
				ply.Rank = rank
				
				-- Network
				ply:UpdateRank()
			else
				-- How did this happen
				Cure.Error.Log(ply:Name().." has an invalid rank", TYPE_ADMIN)
			end
		end
	end)
end

