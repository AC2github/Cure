
-- Create an item
function Cure.Shop.AddPlayerItem(player, id, name, trade, quality, paint, effect, attributes)
	if not (player) then return end
	if not (Cure.Shop.GetItem(id)) then return end

	local tbl = {}
	-- Convert everything
	tbl.id = id
	tbl.name = (name or "ERROR")
	tbl.trade = (trade or false)
	tbl.quality = (quality or "none")
	tbl.color = (paint or "none")
	tbl.effect = (effect or "none")
	tbl.attributes = (attributes or {})

	-- To the string we go
	tbl = Cure.Shop.ConvertToString(tbl)

	-- Insert into inventory
	table.insert(player.PlayerData["inventory"], tbl)

	-- JSON
	attributes = util.TableToJSON((attributes or {}))

	-- Query database
	-- Save booleans by converting them to strings, einstein way of doing stuff
	Cure.Database.Query([[INSERT INTO deathrun_player_shopitems (steamid, id, name, trade, quality, color, effect, attributes) VALUES(']]..player:SteamID()..[[', ']]..id..[[', ']]..Cure.Database.Escape(name)..[[', ']]..(trade and 1 or 0)..[[', ']]..quality..[[', ']]..Cure.Database.Escape(paint)..[[', ']]..Cure.Database.Escape(effect)..[[', ']]..attributes..[[')]])
end

-- Equip an item, this is based on the key of the item in the player.PlayerData["inventory"] table
-- 1 - id.hat_bucket
-- 2 - id.hat_trafficcone
function Cure.Shop.EquipPlayerItem(player, key)
	if not (player.PlayerData) then return end
	local item = player.PlayerData["inventory"][key]
	local itemtype = TYPE_SHOP_HAT

	if (item) then
		item = Cure.Shop.ConvertToTable(item)
		itemtype = Cure.Shop.GetItem(item.id).Type

		print("We are dealing with itemtype "..itemtype.." here")

		if (itemtype == 1) then
			-- Create it
			Cure.Shop.CreateHat(player, item.id, nil, item.effect)

			-- Apply attributes
			for k, v in pairs(item.attributes) do
				Cure.Shop.ApplyAttributes(player, v)
			end

			-- Save item
			player.PlayerData["equipment"]["hat"] = Cure.Shop.ConvertToString(item)
		end
	end
end

-- Apply attributes
function Cure.Shop.ApplyAttributes(player, attribute)
	if not (player) then return end
	if not (attribute) then return end

	-- Speed
	for k, v in pairs(Cure.Shop.Attributes["speed"]) do
		if (v.id == attribute) then
			player.Speed = player:GetWalkSpeed() + (player:GetWalkSpeed() / 100 * v.boost)
			break
		end
	end

	-- Health
	for k, v in pairs(Cure.Shop.Attributes["health"]) do
		if (v.id == attribute) then
			player.MaximumHealth = (player:Health() + ((player:Health() / 100) * v.boost))
			break
		end
	end

	-- XP
	for k, v in pairs(Cure.Shop.Attributes["xp"]) do
		if (v.id == attribute) then
			player.ExtraXP = v.boost
			break
		end
	end	
end

-- Network a hat
function Cure.Shop.SendHat(from, to, hat, color, effect)
	if not (from) then return end
	if not (to) then return end
	if not (hat) then return end

	-- No color
	if not (color) then
		color = Color(255, 255, 255, 255)
	end

	-- No effect
	if not (effect) then
		effect = ""
	end

	-- Start
	net.Start("cure_shop_hat")
		-- Player
		net.WriteEntity(from)

		-- String
		net.WriteString(hat)

		-- Color
		net.WriteInt(color.r, 32)
		net.WriteInt(color.g, 32)
		net.WriteInt(color.b, 32)
		net.WriteInt(color.a, 32)

		-- Effect
		net.WriteString(effect)

	-- Send
	if (to == "ALL") then
		net.Broadcast()
	else 
		net.Send(to)
	end
end

-- Create a hat
function Cure.Shop.CreateHat(player, hat, color, effect)
	-- no player
	if not (player) then return end

	-- Color
	if not (color) then
		color = Color(255, 255, 255, 255)
	end

	player.PlayerData["equipment"]["hat"] = hat

	-- Effect
	if not (effect) then
		effect = ""
	end

	-- Tell clients to draw a hat for that person
	Cure.Shop.SendHat(player, "ALL", hat, color, effect)
end

-- Remove a hat
function Cure.Shop.RemoveHat(player)
	Cure.Shop.SendHat(player, "ALL", "remove")
end

-- Set a player model
function Cure.Shop.CreatePlayerModel(player, model)
	-- Set model
	player:SetModel(model)

	-- Update
	player.PlayerData["equipment"]["model"] = model
end

function fuckyouconsole()
	local t = {id = "hat_bucket", name = "AC's Hat", trade = true, quality = "none", attributes = {"a1", "a2", "a3", "a5", "a4"}}

	t = Cure.Shop.ConvertToString(t)
	print("STRING: "..t)
	t = Cure.Shop.ConvertToTable(t)
	print("TABLE:")
	PrintTable(t)
end
