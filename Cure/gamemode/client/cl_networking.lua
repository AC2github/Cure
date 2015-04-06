-- General networking

-- Receive Achievements
net.Receive("cure.achievements", function()
	LocalPlayer().PlayerData["achievements"] = {}
	LocalPlayer().PlayerData["achievements"] = net.ReadTable()
end)

-- Receive stats
net.Receive("cure.stats", function()
	LocalPlayer().PlayerData["stats"] = {}
	LocalPlayer().PlayerData["stats"] = net.ReadTable()

	if (LocalPlayer().PlayerData["stats"]["xp"]) then
		Cure.Level.CalculatePlayerLevel(LocalPlayer())
	end
end)

-- Receive hats
net.Receive("cure_shop_hat", function()
	-- Player
	local player = net.ReadEntity()
	-- Hat
	local hat = net.ReadString()
	-- Color
	local color = {}
	color.r, color.g, color.b, color.a = net.ReadInt(32), net.ReadInt(32), net.ReadInt(32), net.ReadInt(32)

	-- effect
	local effect = net.ReadString()

	-- Checks
	if (effect == "") then 
		effect = nil
	end

	-- Create it
	Cure.Shop.CreateHat(player, hat, color, effect or nil)
end)

-- Chatprint
usermessage.Hook("cure_chatprint", function(um)
	local text = um:ReadString()

	-- Stupid chatbox
	chat.AddText(Color(255, 255, 255), text) 
end)