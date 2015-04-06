local meta = FindMetaTable("Player")
if not (meta) then return end

-- return users current rank
function meta:GetRank()
	-- console
	if not (self:IsValid()) then
		return "owner"
	end
	
	-- return rank if we have one
	if (self.Rank) then
		return self.Rank
	end
	
	-- default
	return "user"
end

-- Network rank
function meta:UpdateRank()
	for k,v in pairs(player.GetAll()) do
		umsg.Start("cure.rank")
			umsg.Entity(v)
			umsg.String(v:GetRank())
		umsg.End()
	end
end

-- sets a user their rank
function meta:SetRank(rank)
	-- Prevent errors
	if not (Cure.Admin.IsValidRank(rank)) then return end
	
	-- Why
	if (self:GetRank() == rank) then return end
	
	-- Actually change it
	self.Rank = rank
	
	-- Gotta love logs
	Cure.Error.Log( self:Name().." his rank was changed to "..rank, TYPE_ADMIN)
	
	-- Query database
	Cure.Database.Query([[SELECT rank FROM cure_admins WHERE steamid = ']]..self:SteamID()..[[']], function(data)
		if (Cure.Database.IsValidData(data)) then
			-- Rank is already changed so we can do this
			if (self:GetRank() == "user") then
				-- No user ranks!
				Cure.Database.Query([[DELETE FROM cure_admins WHERE steamid = ']]..self:SteamID()..[[']])
			else
				-- Update the new rank
				Cure.Database.Query([[UPDATE cure_admins SET rank = ']]..rank..[[' WHERE steamid = ']]..self:SteamID()..[[']])
			end
		else
			-- New admin
			Cure.Database.Query([[INSERT INTO cure_admins (name, steamid, rank, server) Values( ']]..Cure.Database.Escape(self:Name())..[[', ']]..self:SteamID()..[[', ']]..rank..[[', '1')]])
		end
	end)
	
	-- Network it
	self:UpdateRank()
end

-- Has a user the flag
function meta:HasFlag(flag)
	-- console
	if not (self:IsValid()) then return true end
	
	-- true or false
	return (Cure.Admin.HasFlag(self:GetRank(), flag))
end

-- Le moderator
function meta:IsModerator()
	if (self:GetRank() == "owner") then return true end
	if (self:GetRank() == "globaladmin") then return true end
	if (self:GetRank() == "superadmin") then return true end
	if (self:GetRank() == "admin") then return true end
	if (self:GetRank() == "moderator") then return true end
	
	return false
end

-- Le admin
function meta:IsAdmin()
	if (self:GetRank() == "owner") then return true end
	if (self:GetRank() == "globaladmin") then return true end
	if (self:GetRank() == "superadmin") then return true end
	if (self:GetRank() == "admin") then return true end
	
	return false
end

-- superb admin
function meta:IsSuperAdmin()
	if (self:GetRank() == "owner") then return true end
	if (self:GetRank() == "globaladmin") then return true end
	if (self:GetRank() == "superadmin") then return true end
	
	return false
end

-- see if player is a global admin
function meta:IsGlobalAdmin()
	if (self:GetRank() == "owner") then return true end
	if (self:GetRank() == "globaladmin") then return true end
	
	return false
end

-- see if player is the owner
function meta:IsOwner()
	if (self:GetRank() == "owner") then return true end
	
	return false
end