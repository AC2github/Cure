-- Table
Cure.Shop = {}
Cure.Shop.Data = {}
Cure.Shop.Paints = {}
Cure.Shop.Effects = {}
Cure.Shop.Attributes = {}
Cure.Shop.Categories = {}

-- enums
TYPE_SHOP_HAT = 1
TYPE_SHOP_TRAIL = 2
TYPE_SHOP_MODEL = 3
TYPE_SHOP_TAUNT = 4
TYPE_SHOP_TAG = 5
TYPE_SHOP_WEAPON = 6
TYPE_SHOP_MISC = 7

TYPE_SHOP_LEGENDARY = "legendary"
TYPE_SHOP_UNUSUAL = "unusual"

TYPE_SHOP_PAINT_RED = Color(255, 0, 0, 255)
TYPE_SHOP_PAINT_BLUE = Color(0, 0, 255, 255)

TYPE_SHOP_EFFECT_BURNING1 = "superrare_burning1"
TYPE_SHOP_EFFECT_BURNING2 = "superrare_burning2"

-- Categories
Cure.Shop.Categories[TYPE_SHOP_HAT] = {name = "Hats", icon = Material("icon16/attach.png")}
Cure.Shop.Categories[TYPE_SHOP_TRAIL] = {name = "Trails", icon = Material("icon16/rainbow.png")}
Cure.Shop.Categories[TYPE_SHOP_MODEL] = {name = "Models", icon = Material("icon16/group.png")}
Cure.Shop.Categories[TYPE_SHOP_TAUNT] = {name = "Taunts", icon = Material("icon16/music.png")}
Cure.Shop.Categories[TYPE_SHOP_TAG] = {name = "Tags", icon = Material("icon16/tag_yellow.png")}
Cure.Shop.Categories[TYPE_SHOP_WEAPON] = {name = "Weapons", icon = Material("icon16/gun.png")}
Cure.Shop.Categories[TYPE_SHOP_MISC] = {name = "Misc", icon = Material("icon16/tux.png")}

-- Paints
Cure.Shop.Paints[1] = {name = "Red", color = TYPE_SHOP_PAINT_RED}
Cure.Shop.Paints[2] = {name = "Blue", color = TYPE_SHOP_PAINT_BLUE}

-- Effects
Cure.Shop.Effects[1] = {name = "Flames", effect = TYPE_SHOP_EFFECT_BURNING1}
Cure.Shop.Effects[2] = {name = "Blue flames", effect = TYPE_SHOP_EFFECT_BURNING2}

-- Create attributes
function Cure.Shop.CreateAttribute(type, id, desc, boost)
	-- Create if not exist
	if not (Cure.Shop.Attributes[type]) then
		Cure.Shop.Attributes[type] = {}
	end

	-- Get count
	local i = (#Cure.Shop.Attributes[type] + 1)

	-- Add it
	Cure.Shop.Attributes[type][i] = {id = id, desc = desc, boost = boost}
end

-- Atrributes
Cure.Shop.CreateAttribute("speed", "s1", "Run 5% faster", 5)
Cure.Shop.CreateAttribute("speed", "s2", "Run 10% faster", 10)
Cure.Shop.CreateAttribute("speed", "s3", "Run 15% faster", 15)
Cure.Shop.CreateAttribute("speed", "s4", "Run 20% faster", 20)
Cure.Shop.CreateAttribute("speed", "s5", "Run 25% faster", 25)

Cure.Shop.CreateAttribute("health", "h1", "Spawn with 5% more health", 5)
Cure.Shop.CreateAttribute("health", "h2", "Spawn with 10% more health", 10)
Cure.Shop.CreateAttribute("health", "h3", "Spawn with 15% more health", 15)
Cure.Shop.CreateAttribute("health", "h4", "Spawn with 20% more health", 20)
Cure.Shop.CreateAttribute("health", "h5", "Spawn with 25% more health", 25)

Cure.Shop.CreateAttribute("dice", "d1", "5% Luck increase with !rtd", 5)

Cure.Shop.CreateAttribute("xp", "x1", "Earn 5% more xp", 5)
Cure.Shop.CreateAttribute("xp", "x2", "Earn 10% more xp", 10)
Cure.Shop.CreateAttribute("xp", "x3", "Earn 15% more xp", 15)
Cure.Shop.CreateAttribute("xp", "x4", "Earn 20% more xp", 20)

-- Register an item
function Cure.Shop.RegisterItem(tbl)
	-- Prevent registering the same items
	if (Cure.Shop.Data[tbl.ID]) then
		print("There is already an item with that unique ID!")
		return
	end

	-- Register it
	-- Make shit do shit
	Cure.Shop.Data[tbl.ID] = tbl

	-- Precache model
	if (tbl.Model) then
		util.PrecacheModel(tbl.Model)
	end
end

-- DEBUG
game.AddParticles( "particles/t5_shop.pcf" )

PrecacheParticleSystem( "superrare_burning1" )
PrecacheParticleSystem( "superrare_burning2" )
PrecacheParticleSystem( "superrare_burning3" )
PrecacheParticleSystem( "superrare_beams1" )
PrecacheParticleSystem( "superrare_halo" )
PrecacheParticleSystem( "superrare_plasma1" )
PrecacheParticleSystem( "superrare_plasma2" )
PrecacheParticleSystem( "superrare_ghost" )
PrecacheParticleSystem( "superrare_ghost2" )
PrecacheParticleSystem( "superrare_greenenergy" )
PrecacheParticleSystem( "superrare_stormcloud" )
PrecacheParticleSystem( "superrare_glow" )
PrecacheParticleSystem( "superrare_moon")
-- END DEBUG

-- Add a paint
function Cure.Shop.AddPaint(itemid, name, paint)
	local item = Cure.Shop.Data[itemid]

	-- Check shit
	if not (item.Paint) then
		item.Paint = {}
	end

	if (item) then
		table.insert(item.Paint, {name = name, paint = paint})
	end
end

-- Add a quality
function Cure.Shop.AddQuality(itemid, name, quality, effect, attributes)
	local item = Cure.Shop.Data[itemid]

	-- Check shit
	if not (item.Quality) then
		item.Quality = {}
	end

	if (item) then
		table.insert(item.Quality, {name = name, quality = quality, effect = effect, attributes = attributes or {}})
	end
end

-- Get vectors, angels, scales and other weird shit
function Cure.Shop.GetHatData(player, itemid)
	local item = Cure.Shop.GetItem(itemid)

	if (item) then
		return item.HatData[player:GetModel()] or item.HatData["default"]
	end
end

-- Get an item data
function Cure.Shop.GetItem(id)
	-- Find and return
	if (Cure.Shop.Data[id]) then
		return Cure.Shop.Data[id]
	end

	-- Oh noes
	return {}
end

-- Get Cure.Shop.Data data from Cure.Shop.ConvertToTable
function Cure.Shop.GetFullData(id)
	for k, v in pairs(Cure.Shop.Data) do
		if (v.ID == id) then
			return v
		end
	end
end

-- Convert a table into a String
function Cure.Shop.ConvertToString(data)
	if not (data) then return end

	-- vars
	local tbl = {}
	local str = ""
	local finalstr = ""

	if (type(data) == "table") then
		-- id
		table.insert(tbl, "id."..(data.id or data.ID or "error"))

		-- name
		table.insert(tbl, ":name."..(data.name or data.Name or "error"))

		-- Convert
		if not (data.trade) and data.Trade then
			data.trade = data.Trade
		end

		-- Bools
		if (data.trade) then
			if (tonumber(data.trade) == 1) then
				data.trade = "true"
			else
				data.trade = "false"
			end
		end

		-- trade
		table.insert(tbl, ":trade."..(tostring(data.trade) or "false"))

		-- quality
		table.insert(tbl, ":quality."..(tostring(data.quality) or tostring(data.Quality) or "none"))

		-- effect
		table.insert(tbl, ":effect."..(tostring(data.effect) or tostring(data.Effect) or "none"))

		-- paint
		table.insert(tbl, ":paint."..(tostring(data.paint) or tostring(data.Paint) or "none"))

		-- Convert
		if not (data.attributes) and (data.Attributes) then
			data.attributes = data.Attributes
		end

		-- attributes
		if (data.attributes) then
			for k, v in pairs(data.attributes) do
				str = str..v.."."
			end

			table.insert(tbl, ":attributes."..str)
		end
	end

	-- Put everything in a string
	for k, v in pairs(tbl) do
		finalstr = finalstr..v
	end

	-- return it
	return finalstr or "error"
end

-- Fuck you ConvertToTable, y u no work
function Cure.Shop.ConvertToTable(str)
	if not (str) then return end

	local newtbl = {}
	local tbl = string.Explode(":", str)

	-- Find other elements
	for k, v in pairs(tbl) do
		local startpos, endpos = string.find(v, ".", 1, true)
		newtbl[string.sub(v, 1, endpos - 1)] = string.sub(v, endpos + 1, string.len(v))
	end

	-- Temporary vars
	local t = (newtbl["attributes"] or newtbl["Attributes"])

	if not (t) then
		return newtbl
	end

	local s = ""
	local temptbl = {}
	local tries = 0

	while (s != nil) do
		-- find attributes
		s = string.find(t, ".", 1, true)

		-- stop when done
		if (s == nil) then break end

		-- Insert into temporary table
		table.insert(temptbl, string.sub(t, 1, s - 1))

		-- Remove that part of the string
		t = string.sub(t, s + 1, string.len(t))

		-- Infinite loop protection, this shouldn't be called though
		if (tries >= 50) then break end
	end

	-- Just reset it
	newtbl["attributes"] = {}

	-- Insert new values
	for k, v in pairs(temptbl) do
		table.insert(newtbl["attributes"], v)
	end

	-- return this pile of shit
	return newtbl
end