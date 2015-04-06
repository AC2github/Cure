
-- Enums
TYPE_BAN = 1
TYPE_BAN_MUTE = 2
TYPE_BAN_GAG = 3
TYPE_BAN_SHOP = 4
TYPE_BAN_JUKEBOX = 5

-- Adds ban to the database
function Cure.Admin.AddBan(steamid, name, reason, time, bantype, admin, ip)
	-- Check
	if not (name) or not (reason) or not (time) or not (bantype) or not (admin) or not (ip) then
		Cure.Error.Log("Cure.Admin.AddBan called with missing one or more arguments.", TYPE_LUA)
		return
	end

	-- Convert
	name = Cure.Database.Escape(name)
	admin = Cure.Database.Escape(admin)
	reason = Cure.Database.Escape(reason)
	
	-- Query
	Cure.Database.Query([[INSERT INTO cure_bans (steamid, name, reason, time, type, ip, admin) VALUES(']]..steamid..[[', ']]..name..[[', ']]..reason..[[', ']]..time..[[', ']]..bantype..[[', ']]..ip..[[', ']]..admin..[[')]])
end

-- Use in ban command
function Cure.Admin.BanByName(name, reason, time, bantype, admin, ip)
	-- Check
	if not (name) or not (reason) or not (time) or not (bantype) or not (admin) or not (ip) then
		Cure.Error.Log("Cure.Admin.BanByName called with missing one or more arguments.", TYPE_LUA)
		return
	end

	-- Find a player
	local player = Cure.Admin.FindPlayer(name)
	
	-- Valid player
	if (player) then
		-- Add to the database
		Cure.Admin.AddBan(player:SteamID(), player:Name(), reason, time, bantype, admin, ip)
	end
end

-- Get banned information
function Cure.Admin.GetBannedData(steamid, type)
	for k, v in pairs(Cure.Admin.Bans) do
		if (v.steamid == steamid) and (v.type == type) then
			return v
		end
	end

	return nil
end

-- Remove ban
function Cure.Admin.RemoveBan(steamid, type)
	for k, v in pairs(Cure.Admin.Bans) do
		if (v.steamid == steamid) and (v.type == type) then
			Cure.Admin.Bans[k] = nil
		end
	end
end

-- Called when player joins
function Cure:CheckPassword(steam, ip, pass, clientpass, name)
	-- Convert 64bit steamid to normal steamid
	-- http://www.facepunch.com/showthread.php?t=1253982&p=39923262
	local steam64 = tonumber(steam:sub(2))
	local a = steam64 % 2 == 0 and 0 or 1
	local b = math.abs(6561197960265728 - steam64 - a) / 2
	local sid = "STEAM_0:" .. a .. ":" .. (a == 1 and b -1 or b)
	
	-- vars
	local allowed = true
	local strreason = "Banned by admin"

	-- steamid
	local steamid = sid
	
	-- Check cache
	if (Cure.Admin.GetBannedData(steamid, TYPE_BAN)) then
		-- Calculate time
		local timeleft = Cure.Admin.GetBannedData(steamid, TYPE_BAN).time - os.time()
		local minutes = math.floor(timeleft / 60)
		local seconds = timeleft - (minutes * 60)
		local hours = math.floor(minutes / 60)
		
		-- goodbye forever
		if (Cure.Admin.GetBannedData(steamid, TYPE_BAN).time == 0) and (Cure.Admin.GetBannedData(steamid, TYPE_BAN).type == TYPE_BAN) then
			return false, Format("You are banned for: '%s'.", Cure.Admin.GetBannedData(steamid, TYPE_BAN).reason)
		end
		
		-- Time expired, unban him
		if (Cure.Admin.GetBannedData(steamid, TYPE_BAN).time < os.time()) and (Cure.Admin.GetBannedData(steamid, TYPE_BAN).type == TYPE_BAN) then
			-- So if he's muted or gagged
			Cure.Database.Query([[DELETE FROM cure_bans WHERE steamid = ']]..steamid..[[' AND type = '1']])
			
			-- Remove cache
			Cure.Admin.RemoveBan(steamid, TYPE_BAN)
			return true
		end
		
		return false, Format("You are banned for: '%s'. The ban will expire in %s.", Cure.Admin.GetBannedData(steamid, TYPE_BAN).reason, hours.."h:"..minutes.."m:"..seconds.."s")
	end
	
	Cure.Database.Query([[SELECT reason, time, type FROM cure_bans WHERE steamid = ']]..steamid..[[' AND type = '1']], function(data)
		-- if we have data
		if (Cure.Database.IsValidData(data)) then
			-- Get time and reason
			local reason, time, bantype = data[1]["reason"], data[1]["time"], data[1]["type"]

			-- Calculate time
			local timeleft = time - os.time()
			local minutes = math.floor(timeleft / 60)
			local seconds = timeleft - (minutes * 60)
			local hours = math.floor(minutes / 60)
			
			-- goodbye forever
			if (time == 0) then
				allowed = false
				strreason = Format("You are banned for: '%s'.", reason)
				return
			end
			
			-- Time expired, unban him
			if (time < os.time()) and (tonumber(bantype) == TYPE_BAN) then
				-- So if he's muted or gagged
				Cure.Database.Query([[DELETE FROM cure_bans WHERE steamid = ']]..steamid..[[' AND type = '1']])
				
				-- Remove cache
				Cure.Admin.RemoveBan(steamid, tonumber(TYPE_BAN))
				return true
			end
			
			-- Cache result so we don't send a query each time he tries to reconnect
			local count = #Cure.Admin.Bans + 1
			Cure.Admin.Bans[count] = {["steamid"] = steamid, ["reason"] = reason, ["time"] = time, ["type"] = tonumber(bantype)}

			-- Kick him
			allowed = false
			strreason = Format("You are banned for: '%s'. The ban will expire in %s.", reason, hours.."h:"..minutes.."m:"..seconds.."s")
		else
			-- Debug
			print("[Cure.Bans] No serverban found for "..steamid)

			-- Allow in
			return true
		end
	end)

	return allowed, strreason
end