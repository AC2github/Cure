
-- This should only be called serverside
function Cure.Achievements.Unlock(player, id)
	-- Simple check
	if not (SERVER) then return end
	if not (Cure.Achievements.IsValid(id)) then return end
	if not (player:IsValid()) then return end
	if not (Cure.Database.Ready) then return end

	-- Already has it
	if (table.HasValue(player.PlayerData["achievements"], id)) then return end

	-- Insert
	table.insert(player.PlayerData["achievements"], id)

	-- Query database
	Cure.Database.Query([[INSERT INTO deathrun_player_awards(id, name, steamid) VALUES( ']]..id..[[', ']]..Cure.Database.Escape(player:Name())..[[', ']]..player:SteamID()..[[')]])

	-- Notify
	local name = Cure.Achievements.GetData(id).name
	local xp = Cure.Achievements.GetData(id).reward or 0
	Cure.Player.PrintAll("Player <color=yellow>"..player:ParseName().. "</color> has earned the achievement <color=yellow>"..Cure.NoParse(name).."</color>.", "icon16/rosette.png")
	
	Cure:SendNotifcation(player, "Achievement unlocked", name, 3, .6)
	Cure:SendNotifcation(player, "", "Achievement unlocked         +100XP", 1, 2)

	Cure.Stats.Increase(player, "xp", (xp + 100))

	-- Network
	Cure.Achievements.SendAchievements(player)
 
	-- Call hook
	hook.Call("OnAchievementEarned", GAMEMODE, player, id)
end

-- Send achievements
function Cure.Achievements.SendAchievements(player)
	-- Meh, just to be safe
	if not (player:IsValid()) then return end

	-- Simple
	net.Start("cure.achievements")
		net.WriteTable(player.PlayerData["achievements"])
	net.Send(player)
end

-- Some achievements function that make my life easier
function Cure.Achievements.UnlockOnPlayerDeath(ply, victim, id, achv)
	if (victim:SteamID() == tostring(id)) then Cure.Achievements.Unlock(ply, achv) end
end

-- Unlock when someone joins
function Cure.Achievements.UnlockOnPlayerJoin(ply, id, achv)
	if (ply:SteamID() == tostring(id)) then
		for k, v in pairs(player.GetAll()) do 
			Cure.Achievements.Unlock(v, achv)
		end
	end
end
