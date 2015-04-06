-- TODO
-- Make PlaySound function work without valid JSON data from the youtube API
-- Volume/mute cvars
-- Clientside playlist
-- Clean up code (!)

print("LOADED JUKEBOX CLIENT")

-- Object
Cure.Jukebox = {}
Cure.Jukebox.Songs = {}
Cure.Jukebox.SongsSorted = {}
Cure.Jukebox.Queue = {}
Cure.Jukebox.CurrentSong = {}
Cure.Jukebox.AudioChannel = {}

-- Vars
Cure.Jukebox.IsPlayingSong = false

-- Networking
if (SERVER) then
	util.AddNetworkString("jukebox.songdata")
	util.AddNetworkString("jukebox.isplaying")
	util.AddNetworkString("jukebox.addsong")
	util.AddNetworkString("jukebox.networksongs")
	util.AddNetworkString("jukebox.clearsongs")
	util.AddNetworkString("jukebox.queue")
end

-- Add a new song
function Cure.Jukebox.AddSong(title, length, link)
	table.insert(Cure.Jukebox.Songs, {length = length or 0, title = title or "N/A", link = link or "N/A"})
end

-- See if we're playing
function Cure.Jukebox.IsPlaying()
	return (Cure.Jukebox.IsPlayingSong or false)
end

-- Play a song
function Cure.Jukebox.PlaySong(link)
	-- Only play registered songs
	if not (Cure.Jukebox.IsValidSong(link)) then return end

	-- Store stuff
	local data = {}

	-- Find the song in our cached songs table
	for k, v in pairs(Cure.Jukebox.Songs) do
		if (tostring(v.link) == tostring(link)) then
			data = v
		end
	end

	-- Store data
	Cure.Jukebox.CurrentSong = {length = data.length, title = data.title, link = data.link}

	-- Create stream and play
	if (CLIENT) then
		-- Just play clientside
		Cure.Jukebox.CreateAudioChannel(data.title, data.length, data.link)

		-- Playing 
		Cure.Jukebox.IsPlayingSong = true
	else
		-- Network to everyone
		net.Start("jukebox.songdata")
			net.WriteTable(Cure.Jukebox.CurrentSong)
		net.Broadcast()

		-- Notify
		Cure.Player.PrintAll("<color=yellow>[Jukebox]</color> Now playing: <color=yellow>"..Cure.NoParse(Cure.Jukebox.CurrentSong.title).."</color>.", "icon16/music.png")

		-- We are playing
		Cure.Jukebox.IsPlayingSong = true
	end
	
	-- Queue update
	net.Start("jukebox.queue")
		net.WriteTable(Cure.Jukebox.Queue)
	net.Broadcast()

	-- Timer
	timer.Simple(Cure.Jukebox.GetCurrentSongData().length, function()
		-- No longer playing
		Cure.Jukebox.IsPlayingSong = false

		-- Remove current data
		Cure.Jukebox.CurrentSong = {}

		-- Network to client to notify
		net.Start("jukebox.isplaying")
		net.Broadcast()

		-- Remove from queue
		table.remove(Cure.Jukebox.GetQueue(), 1)

		if (#(Cure.Jukebox.GetQueue()) > 0) then
			Cure.Jukebox.PlaySong(Cure.Jukebox.GetQueue()[1])
		end
	end)
end

-- Show actual data
function Cure.Jukebox.GetCurrentSongData()
	return Cure.Jukebox.CurrentSong
end

-- Get queue
function Cure.Jukebox.GetQueue()
	return Cure.Jukebox.Queue
end

-- Check if a song is registered
function Cure.Jukebox.IsValidSong(link)
	-- Loop
	for k, v in pairs(Cure.Jukebox.Songs) do 
		if (tostring(v.link) == tostring(link)) then
			return true
		end
	end

	return false
end

-- Get data from a link
function Cure.Jukebox.GetSongDataFromLink(link)
	-- Fail
	if not (link) then return end
	if not (Cure.Jukebox.IsValidSong(link)) then return end

	-- Loop
	for k, v in pairs(Cure.Jukebox.Songs) do
		if (tostring(v.link) == tostring(link)) then
			return v
		end
	end
end

-- HTML PANEL
-- Create stream
function Cure.Jukebox.CreateAudioChannel(title, length, link)
	-- Play
	gDeathrunJukebox:PlayURL(title, length, link)
end

function Cure.Jukebox.SetVolume(volume)
	-- Panel not valid?
	if not (gDeathrunJukebox) then return end

	-- Javascript
	gDeathrunJukebox:Javascript([[
		try { 
			player.setVolume(]] .. (volume*100) .. [[);
		} catch (e) {}
	]])
end

function Cure.Jukebox.Pause(bool)
	-- Panel not valid?
	if not (gDeathrunJukebox) then return end

	-- Javascript
	if (bool) then
		gDeathrunJukebox:Javascript([[
			try { 
				if (player)
				{
					player.pauseVideo();
				}
			} catch (e) {}
		]])
	else
		gDeathrunJukebox:Javascript([[
			try { 
				if (player)
				{
					player.playVideo();
				}
			} catch (e) {}
		]])
	end
end

function Cure.Jukebox.CheckHTMLPlaying()
	if not (gDeathrunJukebox) then return false end

	-- Javascript
	gDeathrunJukebox:Javascript([[
		try
		{

			var playing = player.getPlayerState();

			if (playing == 1)
			{
				jukebox.isplaying(true);
			}
			else
			{
				jukebox.isplaying(false);
			}
		}
		 catch (e)
		 	{}

	]])
end

function Cure.Jukebox.IsVideoPlaying()
	return (Cure.Jukebox.IsHTMLPlaying or false)
end

