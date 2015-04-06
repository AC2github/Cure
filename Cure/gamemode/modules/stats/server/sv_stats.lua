-- Add an stat count
function Cure.Stats.Increase(player, id, amount)
	-- Simple check
	if not (SERVER) then return end
	if not (Cure.Stats.IsValid(id)) then return end
	if not (player:IsValid()) then return end
	if not (Cure.Database.Ready) then return end
	if not (amount) then return end

	-- New stat or increase old one
	if (player.PlayerData["stats"][id]) then
		player.PlayerData["stats"][id] = player.PlayerData["stats"][id] + tonumber(amount)

		-- Get stat
		local stat = player.PlayerData["stats"][id]

		-- Query
		Cure.Database.Query([[UPDATE deathrun_player_stats SET value = ']]..stat..[[' WHERE steamid = ']]..player:SteamID()..[[' AND id = ']]..id..[[']])
	else
		-- New value
		player.PlayerData["stats"][id] = amount

		-- Query
		Cure.Database.Query([[INSERT INTO deathrun_player_stats(id, value, steamid) VALUES(']]..id..[[', ']]..amount..[[', ']]..player:SteamID()..[[')]])
	end

	-- Unlock achievements
	if (Cure.Achievements.Handlers[id]) then
		for k, v in pairs(Cure.Achievements.Handlers[id]) do
			if (player.PlayerData["stats"][id] >= v[id]) then
				Cure.Achievements.Unlock(player, v.achv)
			end
		end
	end

	-- Stat is XP, check level
	if (id == "xp") then
		-- Check if level up
		Cure.Level.CalculatePlayerLevel(player)

		-- Network
		umsg.Start("cure.xp.notify", player)
			umsg.Long(amount)
		umsg.End()
	end

	-- Network
	Cure.Stats.SendStats(player)

	-- Call hook
	hook.Call("OnStatIncrease", GAMEMODE, player, id, amount)
end

-- Send stats
function Cure.Stats.SendStats(player)
	-- Meh, just to be safe
	if not (player:IsValid()) then return end

	-- Simple
	net.Start("cure.stats")
		net.WriteTable(player.PlayerData["stats"])
	net.Send(player)
end

