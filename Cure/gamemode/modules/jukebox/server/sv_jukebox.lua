-- TO DO
-- Make a system to force the user to manual add song length and title

-- Create dirs to store songs
file.CreateDir("jukebox")

-- Check if the file exists
if not (file.Exists("jukebox/songs.txt", "DATA")) then
	file.Write("jukebox/songs.txt", "")
end

-- Add a song to the queue
function Cure.Jukebox.AddToQueue(player, link)
	-- Fail
	if not (link) then return end
	if not (player) then return end

	-- Get the entire song
	local link = tostring(link)

	-- Invalid
	if not (Cure.Jukebox.IsValidSong(link)) then 
		print("invalid")
		return
	end

	-- Already in the queue
	if (table.HasValue(Cure.Jukebox.GetQueue(), link)) then 
		player:ChatPrint("That song is already in the queue.")
		return
	end

	-- Full queue
	if (#Cure.Jukebox.GetQueue() >= 30) then
		player:ChatPrint("The queue is full.")
		return 
	end

	-- Insert
	table.insert(Cure.Jukebox.Queue, link)

	-- Queue update
	net.Start("jukebox.queue")
		net.WriteTable(Cure.Jukebox.Queue)
	net.Broadcast()

	-- Get name
	local name = Cure.NoParse(Cure.Jukebox.GetSongDataFromLink(link).title)

	-- Notify
	Cure.Player.PrintAll("Player <color=yellow>"..player:ParseName().."</color> has added <color=yellow>"..name.."</color> to the queue.", "icon16/music.png")

	-- Check if we're already playing
	if (Cure.Jukebox.IsPlaying()) then return end

	-- Start playing
	Cure.Jukebox.PlaySong(Cure.Jukebox.Queue[1])
end 

-- Anti-spam
local lastused = CurTime()

-- A song to the jukebox list (global song list)
function Cure.Jukebox.AddToList(player, link)
	-- Fail
	if not (player) then return end
	if not (link) then return end

	-- Admin only
	if not (player:IsAdmin()) then return end

	-- ToString
	link = tostring(link)

	-- Anti-spam
	if (lastused > CurTime()) then
		player:ChatPrint("Please do not spam this.")
		return
	end

	-- Update
	lastused = CurTime() + 3

	-- Find
	local startpos, endpos = link:find("v="), string.len(link)

	-- Prevent errors
	if not (startpos) then
		player:ChatPrint("The link you entered could not be loaded into our API.")
		return
	end

	local tempString = ""

	-- Find
	tempString = string.sub(link, startpos + 2, endpos)

	-- Check API
	http.Fetch("http://gdata.youtube.com/feeds/api/videos/"..tempString.."?&alt=json",
		-- Success
		function(body, len, headers, code)
			-- Get data
			data = util.JSONToTable(body)

			-- API returned no JSON data for some weird annoying reason
			if (data == nil) then
				player:ChatPrint("The link you entered could not be loaded into our API. Try again later.")
				return
			end

			-- Get data
			local length = data["entry"]["media$group"]["yt$duration"].seconds
			local name = data["entry"]["media$group"]["media$title"]["$t"]
			local songs = file.Find("jukebox/songs.txt", "DATA")

			-- Nothing
			if not (#songs > 0) then
				file.Write("jukebox/songs.txt", "")
				songs = {}
			else
				-- Get all the songs
				songs = (util.JSONToTable(file.Read("jukebox/songs.txt")) or {})
			end

			-- Check
			for k, v in pairs(Cure.Jukebox.Songs) do
				if (tostring(v.link) == tostring(tempString)) then
					player:ChatPrint("That songs already exists in the list.")
					return
				end
			end

			-- Valid
			if (songs) then
				-- Insert it
				table.insert(songs, {title = name, length = length, link = tempString})

				-- Add to jukebox aswell
				Cure.Jukebox.AddSong(name, length, tempString)

				-- Now save
				file.Write("jukebox/songs.txt", util.TableToJSON(songs))

				-- Network
				net.Start("jukebox.addsong")
					net.WriteTable({title = name, length = length, link = tempString})
				net.Broadcast()

				-- Debug
				print("[JUKEBOX] Song has been added to songs.txt")
			end
		end,

		-- Error
		function(error)
		end)
end

-- Remove a song
function Cure.Jukebox.RemoveFromList(player, link)
	-- Fail
	if not (player) then return end
	if not (link) then return end

	-- Admin only
	if not (player:IsAdmin()) then return end

	-- ToString
	link = tostring(link)

	-- We're removing what
	local found = false

	-- Find it
	for k, v in pairs(Cure.Jukebox.Songs) do
		if (tostring(v.link) == link) then
			print(v)
			-- Remove
			Cure.Jukebox.Songs[k] = nil

			-- Update
			found = true

			-- Write
			file.Write("jukebox/songs.txt", (util.TableToJSON(Cure.Jukebox.Songs) or "{}"))

			-- Stop
			break
		end
	end

	-- Not found
	if not (found) then
		player:ChatPrint("[Jukebox] Could not find the song to remove.")
		return
	end

	-- Network
	Cure.Jukebox.NetworkSongs()
end


-- Load all songs on intialize
function Cure.Jukebox.LoadSongs()
	-- Table
	local songs = {}

	-- Read them
	songs = (util.JSONToTable(file.Read("jukebox/songs.txt")) or {})

	-- Insert into global table
	for k, v in pairs(songs) do
		Cure.Jukebox.AddSong(v.title, v.length, v.link)
	end
end

-- Network all songs
function Cure.Jukebox.NetworkSongs(pl)
	-- Clear songs
	net.Start("jukebox.clearsongs")

	if (pl) then
		net.Send(pl)
	else
		net.Broadcast()
	end

	-- Send
	for k, v in pairs(Cure.Jukebox.Songs) do
		net.Start("jukebox.networksongs")
			net.WriteTable({title = v.title, length = v.length, link = v.link})

		-- Who
		if (pl) then
			net.Send(pl)
		else
			net.Broadcast()
		end
	end
end

-- Console commands
concommand.Add("jukebox_addtolist", function(pl, cmd, args)
	-- Gotta check, GOTTA CHECK
	if (args[1]) then
		Cure.Jukebox.AddToList(pl, tostring(args[1]))
	end
end)

concommand.Add("jukebox_removefromlist", function(pl, cmd, args)
	-- Gotta check, GOTTA CHECK
	if (args[1]) then
		Cure.Jukebox.RemoveFromList(pl, tostring(args[1]))
	end
end)

concommand.Add("jukebox_addtoqueue", function(pl, cmd, args)
	-- Gotta check, GOTTA CHECK
	if (args[1]) then
		Cure.Jukebox.AddToQueue(pl, tostring(args[1]))
	end
end)

-- Hooks
hook.Add("Initialize", "Cure.Jukebox.LoadSongs", Cure.Jukebox.LoadSongs)