
usermessage.Hook( "cure.rank", function(um)
	local player = um:ReadEntity()
	
	-- Check if we have an valid entity
	if (player) and (IsValid(player)) then
		player.Rank = um:ReadString()
	end
end)

net.Receive("cure.notifychat", function()
	chat.AddText(unpack(net.ReadTable()))
end)

local meta = FindMetaTable("Player")
if not (meta) then return end

function meta:GetRank()
	if not (self:IsValid()) then
		return "owner"
	end
	
	if (self.Rank) then
		return self.Rank
	end
	
	return "user"
end

function meta:IsModerator()
	if (self:GetRank() == "owner") then return true end
	if (self:GetRank() == "globaladmin") then return true end
	if (self:GetRank() == "superadmin") then return true end
	if (self:GetRank() == "admin") then return true end
	if (self:GetRank() == "moderator") then return true end
	
	return false
end

function meta:IsAdmin()
	if (self:GetRank() == "owner") then return true end
	if (self:GetRank() == "globaladmin") then return true end
	if (self:GetRank() == "superadmin") then return true end
	if (self:GetRank() == "admin") then return true end
	
	return false
end

function meta:IsSuperAdmin()
	if (self:GetRank() == "owner") then return true end
	if (self:GetRank() == "globaladmin") then return true end
	if (self:GetRank() == "superadmin") then return true end
	
	return false
end

function meta:IsGlobalAdmin()
	if (self:GetRank() == "owner") then return true end
	if (self:GetRank() == "globaladmin") then return true end
	
	return false
end

function meta:IsOwner()
	if (self:GetRank() == "owner") then return true end
	
	return false
end