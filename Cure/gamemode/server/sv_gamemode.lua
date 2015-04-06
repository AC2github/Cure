Cure.Team.PreventSuicide(TEAM_SPECTATOR)
Cure.Team.SetTeamCollisionEnabled(true)

Cure.Rounds.SetRoundPhase(ROUND_WAITING)
Cure.Rounds.SetTotalRounds(20)

-- Networking
util.AddNetworkString("cure.achievements")
util.AddNetworkString("cure.stats")

-- Called when the player spawn (but may not be valid)
function Cure:PlayerInitialSpawn(player)
	-- To the spectator you go!
	player:SetTeam(TEAM_SPECTATOR)
	
	-- AFK
	player.AFKTime = (CurTime() + Cure.Afk.Time)
	player.AFKTimes = 0
	player.IsAFK = false

	-- Shop attributes
	player.MaximumHealth = 100
	player.Speed = 275
	player.BaseLuck = 50
	player.BaseChanceUnusualItem = 1
	player.BaseChanceLegendaryItem = .25
	player.BaseChanceKeyFragment = 15
	player.ExtraXP = 0

	-- Achievements, stats, shop
	player.PlayerData = {}
	player.PlayerData["achievements"] = {}
	player.PlayerData["stats"] = {}
	player.PlayerData["equipment"] = {}
	player.PlayerData["inventory"] = {}
	player.PlayerData["shop"] = {}
	
	-- Vote
	player.HasVoted = false
	
	-- Spawn
	player:Spawn()
end

-- Noclip
function Cure:PlayerNoClip(player)
	return (player:IsOwner())
end

-- Disconnect
function Cure:PlayerDisconnected(player)
	-- Notify
	Cure.Player.PrintAll("Player <color=red>"..player:ParseName().."</color> has left the server.", "icon16/cross.png")
end

-- Allow use of 'kill' command
function Cure:CanPlayerSuicide(player)
	if not (player:Alive()) then return false end
	if (table.HasValue(Cure.Team.Suicide, player:Team())) then return false end
	
	return true
end

-- F1
function Cure:ShowHelp(player)
	umsg.Start("cure_mainframe", player)
	umsg.End()
end

-- Called when player spawns
function Cure:PlayerSpawn(player)
	-- Spectator
	if (player:Alive()) then
		player:UnSpectate()
		player.SpectatorMode = OBS_MODE_ROAMING
	else
		player:Spectate(OBS_MODE_ROAMING)
		player:SpectateEntity(nil)
	end
		
	-- afk
	player.IsAFK = false
	player.AFKTime = Cure.Afk.Time + CurTime()

	-- collisions
	if (Cure.Team.EnableCollision) then
		player:SetNoCollideWithTeammates(true)
	end
	
	-- speed
	if (Cure.Team.Speed[player:Team()]) then
		player:SetWalkSpeed(Cure.Team.Speed[player:Team()])
		player:SetRunSpeed(Cure.Team.Speed[player:Team()])
	end
	
	-- remove/set stuff
	player:StripWeapons()
	player:StripAmmo()
	player:AllowFlashlight(true)
	player:SetArmor(0)
	player:SetWalkSpeed(player.Speed)
	player:SetRunSpeed(player.Speed)
	player:SetHealth(player.MaximumHealth)
	player:GodDisable()
	
	-- other hooks
	Cure:PlayerLoadOut(player)
	Cure:PlayerSetModel(player)
end

-- Called after spawn
function Cure:PlayerSetModel(player)
	player:SetModel("models/player/Group01/male_01.mdl")
end

-- Called after spawn
function Cure:PlayerLoadOut(player)
	if not (player:Alive()) then return end
	
	if (Cure.Team.Weapons[player:Team()]) then
		for k, v in pairs(Cure.Team.Weapons[player:Team()]) do
			player:Give(v)
		end
	end
end

-- Called when a player dies
function Cure:DoPlayerDeath(ply, attacker, cinfo)
	self.BaseClass:DoPlayerDeath(ply, attacker, cinfo)

	-- Blood
	if not (attacker:IsPlayer()) then
		--Cure:CreateBloodSplat(ply:GetPos(), 1, cinfo:GetDamageForce())
	end
end

function Cure:CreateBlood(pos, amount, normal)
	for i = 1, amount do
		local blood = EffectData()
		blood:SetOrigin(pos)
		blood:SetNormal(normal)
		util.Effect("gore_bloodprop", blood)
	end
end

function Cure:CreateBloodSplat(pos, amount, normal)
	for i = 1, amount do
		local blood = EffectData()
		blood:SetOrigin(pos)
		blood:SetNormal(normal)
		util.Effect("gib_player", blood)
	end
end

-- Called when an entity takes damage (player or entity?)
function Cure:EntityTakeDamage(player, dmginfo)
	local attacker = dmginfo:GetAttacker()
	local damage = dmginfo:GetDamageForce()

	-- Team killing!
    if IsValid(attacker) and attacker:IsPlayer() and player:IsPlayer() then
    	if (player:Team() == attacker:Team()) then
    		dmginfo:ScaleDamage(0)
    		return
    	else
    		Cure.Stats.Increase(attacker, "damage", dmginfo:GetDamage())
    	end
    end

	-- Only 25% chance
	if (math.random(1, 4) == 2) and (player:IsPlayer()) then
		Cure:CreateBlood(player:GetPos(), math.random(10, 20), dmginfo:GetDamageForce())

		local time, speed = math.random(1, 2), math.Rand(2, 3)

		umsg.Start("cure_bloodeffect", player)
	    	umsg.Short(time)
	     	umsg.Float(speed)
	    umsg.End()
	end
end

function Cure:AddDeathNotifcation(c1, p1, c2, text, c3, p2)
	net.Start("deathrun.killnotifications")
		net.WriteTable({one = p1, text = text, two = p2})
		net.WriteTable({one = c1, two = c2, three = c3})
	net.Broadcast()
end

-- Random ways to die
local randomdeathtext = {"got pancaked!", "was hit by a kiwi!", "died!", "got rekt!", "was hit by AC!"}

function Cure:PlayerDeath(ply, attacker)
	-- First display
	if (attacker:IsPlayer()) and (attacker:IsValid()) then
		-- Suicide
		if (ply == attacker) then
			Cure:AddDeathNotifcation(team.GetColor(attacker:Team()), attacker, color_white, "died")
		else
			-- A legit kill
			Cure:AddDeathNotifcation(team.GetColor(attacker:Team()), attacker, color_white, "killed", team.GetColor(ply:Team()), ply)
		end
	else
		-- Trap
		Cure:AddDeathNotifcation(team.GetColor(ply:Team()), ply, color_white, table.Random(randomdeathtext))
	end

	-- Now change
	ply:SetTeam(TEAM_SPECTATOR)

	-- Remove hats
	Cure.Shop.RemoveHat(ply)
	
	-- Specate
	ply:Spectate(OBS_MODE_CHASE)
	ply.SpectatorMode = OBS_MODE_CHASE
	
	local target = ply:GetObserverTarget()
	
	if not (target == attacker) then
		SendUserMessage("spectator", ply, target)
	end

	-- Spectators
	for k, v in pairs( player.GetAll() ) do
		if not (ply == v) then 
			local target = v:GetObserverTarget()
			
			if (IsValid(target)) and (target == ply) then
				v:Spectate(OBS_MODE_ROAMING)
				v:SpectateEntity(nil)
				v:SetPos(ply:EyePos())
				SendUserMessage("spectator", player, nil)
			end
		end
	end
end

-- On Level
function Cure:OnLevelUp(player, level)
	print("Player "..player:Name().." has reached level "..level)

	for k, v in pairs(Cure.Achievements.Handlers["level"]) do
		if (v.level == level) then
			Cure.Achievements.Unlock(player, v.achv)
			break
		end
	end
end

-- On stat increase
function Cure:OnStatIncrease(player, stat, amount)
	print("Player "..player:Name().." increased stat "..stat.." with "..amount)
end

function Cure:SendNotifcation(ply, title, text, time, speed)
	umsg.Start("cure_texteffect", ply)
		umsg.String(title)
		umsg.String(text) 
		umsg.Short(time)
		umsg.Float(speed)
	umsg.End()
end

function Cure:PlayerDeathThink(ply)
	return false
end

function Cure:Think()
	-- Rounds
	Cure.Rounds.Think()
	
	-- Afk
	Cure.Afk.Think()
end

function Cure:KeyPress(player, key)
	-- Spectator
	Cure.Spectator.KeyPress(player, key)
	
	-- AFK
	Cure.Afk.KeyPress(player, key)

	-- Keys
	Cure.Keys.KeyPress(player, key)
end

function Cure:KeyRelease(player, key)
	-- Keys
	Cure.Keys.KeyRelease(player, key)
end

local function PlayerReady(player, command)
	-- Spam prevent
	if (player.Ready) then return end

	-- Prevent spam
	player.Ready = true

	-- Load
	hook.Call("PlayerReady", GAMEMODE, player)
end
concommand.Add("_PlayerReady", PlayerReady)

-- Called when the player is 100% valid
function GM:PlayerReady(player)
	-- To setup default tables on client
	Cure.Achievements.SendAchievements(player)
	Cure.Stats.SendStats(player)

	-- Get achievements
	Cure.Database.Query([[SELECT id FROM deathrun_player_awards WHERE steamid = ']]..player:SteamID()..[[']], function(data)
		if (Cure.Database.IsValidData(data)) then
			-- Put them in your table
			for k, v in pairs(data) do
				table.insert(player.PlayerData["achievements"], v.id)
			end

			-- Unlock me first!
			Cure.Achievements.UnlockOnPlayerJoin(player, "STEAM_0:0:16134549", "achv_ac")

			-- Send real achievements now
			Cure.Achievements.SendAchievements(player)
		end
	end)

	-- Get stats
	Cure.Database.Query([[SELECT id, value FROM deathrun_player_stats WHERE steamid = ']]..player:SteamID()..[[']], function(data)
		if (Cure.Database.IsValidData(data)) then
			for k, v in pairs(data) do
				-- Just set it
				player.PlayerData["stats"][v.id] = v.value
			end

			-- Network
			Cure.Stats.SendStats(player)
			Cure.Level.CalculatePlayerLevel(player)
		end
	end)

	-- Get invetory items
	Cure.Database.Query([[SELECT id, name, trade, quality, color, effect, attributes FROM deathrun_player_shopitems WHERE steamid = ']]..player:SteamID()..[[']], function(data)
		if (Cure.Database.IsValidData(data)) then
			local item
			for k, v in pairs(data) do

				v.attributes = util.JSONToTable(v.attributes)
				item = Cure.Shop.ConvertToString(v) -- dis is table right

				--PrintTable(v)
				table.insert(player.PlayerData["inventory"], item)
			end
		end
	end)

	-- Get equipped items


	-- Jukebox
	Cure.Jukebox.NetworkSongs(player)

	-- Admin
	Cure.Admin.LoadAdmin(player)

	-- Debug
	print(player:Name().." is now ready.")
end

