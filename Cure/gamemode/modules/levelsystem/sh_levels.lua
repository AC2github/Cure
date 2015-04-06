--[[
    All data for levels

    Credits:
        - AC²
--]]

Cure.Level = {}
Cure.Level.Data = {}

-- Add a Level
function Cure.Level.AddLevel(xp, level)
	Cure.Level.Data[level] = {xp = xp, level = level}
end

-- Valid stuff
function Cure.Level.IsValidLevel(level)
	return util.tobool(Cure.Level.Data[level])
end

-- Set level
function Cure.Level.SetLevel(player, level)
	if not (player.PlayerData) then return end
	player.PlayerData["stats"]["level"] = level
end

-- Get level
function Cure.Level.GetLevel(player)
	if not (player.PlayerData) then return 0 end
	return tonumber(player.PlayerData["stats"]["level"]) or 0
end

-- Get XP from a level
function Cure.Level.GetXPFromLevel(level)
	return (Cure.Level.Data[level+1].xp) or 0
end

-- Get xp
function Cure.Level.GetXP(player)
	if not (player.PlayerData) then return 0 end
	return tonumber(player.PlayerData["stats"]["xp"]) or 0
end

-- Set a player his level
function Cure.Level.SetXP(player, xp)
	if not (player.PlayerData) then return end
	player.PlayerData["stats"]["xp"] = xp
end

-- Calculate a player their level
function Cure.Level.CalculatePlayerLevel(player)
	-- Get shit
	local xp, level = tonumber(player.PlayerData["stats"]["xp"]), tonumber(player.PlayerData["stats"]["level"]) or 0

	-- wtf
	if (level == 100) then return end

	for k, v in pairs(table.Reverse(Cure.Level.Data)) do
		-- Checks, nuff said
		if (tonumber(v.xp) <= xp) then
			-- Don't get spammed
			if not (v.level <= level) then
				-- Actually level him
				Cure.Level.SetLevel(player, v.level)

				-- Cut XP in half
				Cure.Level.SetXP(player, math.Round(xp / 2))

				-- Network it
				if (SERVER) then
					Cure.Stats.SendStats(player)
				end

				-- Call hook
				hook.Call("OnLevelUp", GAMEMODE, player, Cure.Level.GetLevel(player))
			end
			
			-- Break our loop, don't wanna keep going
			break
		end
	end
end

-- This shit will take forever
for i = 1, 100 do
	if not (i <= 10) then
		Cure.Level.AddLevel(Cure.Level.Data[i-1].xp + (i * 10000), i)
	else
		Cure.Level.AddLevel(i * 1000, i)
	end
end
